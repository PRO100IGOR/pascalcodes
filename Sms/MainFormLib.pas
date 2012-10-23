unit MainFormLib;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ExtCtrls, StdCtrls,ScktComp,Common,SmsObj,superobject,ErrorLogsUnit,
  SmsLib,Clipbrd,StrUtils;

(*
   命令格式
   type:command
   type --
          forces   密钥认证          如     forces:sihekejimustgo,如果返回给java的是 forces:sihekejibugo,则认证完毕
          form     关闭或重启窗体    如     form:close  form:restart
          com      关闭或重启串口    如     com:close   com:restart   关掉当前并开启某个串口 传一个数字即可   如com:2
          msg      发送消息          如     msg:{msg:[{tel:'',msg:''}]},可以发送多个短信.消息内容异或加密
   所有的命令要用^_^结尾
*)


type
  TMainForm = class(TForm)
    Logs: TMemo;
    ClearLogBtn: TButton;
    LogClear: TCheckBox;
    DeBugCk: TCheckBox;
    Timer: TTimer;
    TimerFree: TTimer;
    procedure TimerTimer(Sender: TObject);
    procedure TimerFreeTimer(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure ClearLogBtnClick(Sender: TObject);
  private
    ScoketServer    : TServerSocket;    //本地监听scoket
    SmsList         : TSmsList;         //消息集合
    CloseCount      : Integer;          //有发送记录的标记
    ClientSocket    : TCustomWinSocket ;//客户端连接
    CommandCashe     : string;             //命令缓存
    Sms             : TSmsLoad;
    //**ScoketServer事件定义开始
    procedure OnClientRead(Sender: TObject;Socket: TCustomWinSocket);
    procedure OnClientConnect(Sender: TObject;Socket: TCustomWinSocket);
    procedure OnClientError(Sender: TObject; Socket: TCustomWinSocket; ErrorEvent: TErrorEvent; var ErrorCode: Integer);
    //**ScoketServer事件定义结束
    procedure AddLogs(Content:string);
    procedure RestartApp; //重启程序
  public
    Port            : Integer;
    Com             : Integer;
    BaudRate        : Integer;
    function  OpenPort:Integer;                 //打开tcp
    function  OpenCom(NeedReapt :Boolean = True):Integer;  //建立短信猫连接
    function  CloseCom:Integer;                               //关闭短信猫连接
    function  SendMsg(Tel,Msg:string):Integer;              //发送短信
    function  DesFree:Integer;                                //释放、关闭资源
  end;
var
  MainForm: TMainForm;
  key     : string = 'sihekejikillall';   //加密密钥
  cipher  : string = 'sihekejimustgo';  //暗号
  cipher2 : string = 'sihekejibugo';
  App     : TApplication;
  IsSendIng:Boolean = False;
implementation

{$R *.dfm}

procedure TMainForm.AddLogs(Content:string);
begin
   if  DeBugCk.Checked then
   begin
        Logs.Lines.Add(FormatDateTime('hh:mm:ss', now) + '  ' + Content);
   end
   else
   begin
     if (LogClear.Checked) and (Logs.Lines.Count >= 100) then
     begin
         Logs.Lines.Clear;
     end;
      ErrorLogsUnit.addErrors(Content);
   end;
end;
procedure TMainForm.OnClientError(Sender: TObject; Socket: TCustomWinSocket; ErrorEvent: TErrorEvent; var ErrorCode: Integer);
var
  address : string;
begin
  address := Socket.RemoteAddress+':'+ InttoStr(Socket.RemotePort);
  AddLogs(address + '发生异常');
  ErrorCode := 0;
end;
procedure TMainForm.OnClientConnect(Sender: TObject;Socket: TCustomWinSocket);
var
  address : string;
begin
  address := Socket.RemoteAddress+':'+ InttoStr(Socket.RemotePort);
  AddLogs(address + '已经连接');
end;
procedure TMainForm.OnClientRead(Sender: TObject;Socket: TCustomWinSocket);
var
  RevText       :  string; //接收到的消息
  CommandType   :  string; //命令类型
  Command       :  string; //命令内容
  Index         :  Integer; //下标
  RevObj        :  ISuperObject;//msg总对象
  Msgs          :  TSuperArray;  //msg数组们
begin
  RevText := Trim(Socket.ReceiveText);
  Addlogs('收到命令 >>' + RevText);
  Index   := Pos('^_^',RevText);
  if (Index = 0) and (RevText <> '') then
  begin
       CommandCashe := CommandCashe + RevText;
       Exit;
  end;
  CommandCashe := CommandCashe + LeftStr(RevText,Length(RevText)-3);
  Index := Pos(':',RevText);
  if Index = 0 then Exit;
  CommandType := Common.SplitToStrings(CommandCashe,':')[0];
  Command :=  RightStr(RevText,Length(RevText) - Index);
  Command :=  LeftStr(Command,Length(Command) - 3);
  SetLength(CommandCashe,0);
  if CommandType = 'forces' then
  begin
      Addlogs('处理命令forces >>' + Command);
      if Command = cipher then
      begin
           ClientSocket := Socket;
           ClientSocket.SendText('forces:'+cipher2+#$D#$A);
      end;
  end
  else if CommandType = 'form'  then
  begin
      Addlogs('处理命令form >>' + Command);
      ClientSocket.SendText('form'+#$D#$A);
      if Command = 'close' then
      begin
          Close;
      end
      else if Command = 'restart' then
      begin
          RestartApp;
      end;
  end
  else if CommandType = 'com' then
  begin
      Addlogs('处理命令com >>' + Command);
      if Command = 'close' then
      begin
          CloseCom;
      end
      else if Command = 'restart' then
      begin
          CloseCom;
          OpenCom;
      end
      else
      begin
          CloseCom;
          Com := StrToInt(Command);
          OpenCom;
      end;
      ClientSocket.SendText('com'+#$D#$A);
  end
  else if CommandType = 'msg' then
  begin
      IsSendIng := True;
      Addlogs('处理命令msg >>' + Command);
      RevObj := SO(Command);
      if not Assigned(RevObj) then
      begin
         ClientSocket.SendText('msg'+#$D#$A);
         AddLogs('解析格式错误'+Command);
         Exit;
      end;
      Msgs := RevObj.A['msg'];
      for Index := 0 to Msgs.Length - 1 do
      begin
          RevObj := Msgs.O[Index];
          SendMsg(RevObj.S['tel'],RevObj.S['msg']);
      end;
      ClientSocket.SendText('msg'+#$D#$A);
      IsSendIng := False;
  end;  
end;
function  TMainForm.OpenPort:Integer;
begin
    ScoketServer := TServerSocket.Create(App);
    ScoketServer.Port := Port;
    ScoketServer.OnClientConnect := OnClientConnect;
    ScoketServer.OnClientRead := OnClientRead;
    ScoketServer.Socket.OnClientError := OnClientError;
    try
       ScoketServer.Open;
       Result := 1;
       AddLogs(InttoStr(Port) + '端口准备over');
    except
       Result := 0;
    end;
end;
function  TMainForm.OpenCom(NeedReapt :Boolean = True):Integer;
var
  Mobile_Type   :pchar;
  CopyRightToCOM:pchar;
begin
     Result := 0;
     Mobile_Type := nil;
     CopyRightToCOM := nil;
     AddLogs(InttoStr(Com) + '串口打开中');
     if not Assigned(Sms) then Sms := TSmsLoad.Create(Result);
     if Result = 1 then Result := Sms.Connection('//上海迅赛信息技术有限公司,网址www.xunsai.com//',COM,BaudRate,Mobile_Type,CopyRightToCOM);
     if Result <> 1 then  closeCom
     else
     begin
         Timer.Enabled := True;
         AddLogs(InttoStr(Com) + '串口打开了');
         TimerFree.Enabled := True;
         if NeedReapt and Assigned(ClientSocket)then
            ClientSocket.SendText('com'+#$D#$A)
     end;
end;
procedure TMainForm.ClearLogBtnClick(Sender: TObject);
begin
  Clipboard.AsText := Logs.Text;
  Logs.Lines.Clear;
end;
function  TMainForm.CloseCom:Integer;
begin
    Result  := 0;
    CloseCount := 0;
    if Assigned(Sms) then
    begin
       Sms.Disconnection;
       Timer.Enabled := False;
       Sms := nil;
       AddLogs('串口关闭了');
       Result  := 1;
       TimerFree.Enabled := False;
    end;
end;
function  TMainForm.SendMsg(Tel,Msg:string):Integer;
begin
   Result := 0;
   if not Assigned(Sms) then  OpenCom(False);
   if Assigned(Sms) then Result := Sms.Send(Common.deLargeCode(Tel,key),Common.deLargeCode(Msg,key));
   if Result = 1 then AddLogs('发送完毕>>'+Common.deLargeCode(Msg,key) + '>>>' + Common.deLargeCode(Tel,key))
   else AddLogs('发送失败>>'+Common.deLargeCode(Msg,key) + '>>>' + Common.deLargeCode(Tel,key));
   CloseCount := 0;
end;
function  TMainForm.DesFree:Integer;
begin
    CloseCom;
    Result := 1;
    AddLogs('资源释放完毕');
end;
procedure TMainForm.FormCreate(Sender: TObject);
begin
    if not DeBugCk.Checked then
       Application.ShowMainForm := False;
    if not DirectoryExists(ExtractFileDir(PARAMSTR(0)) + '\logs') then CreateDirectory(PChar(ExtractFilePath(ParamStr(0)) + '\logs'), nil);
    CloseCount := 0;
    SetLength(CommandCashe,0);
end;
procedure TMainForm.TimerFreeTimer(Sender: TObject);
begin
    Inc(CloseCount);
    if (CloseCount >= 5) and (not IsSendIng) then
    begin
       CloseCom;
       AddLogs('闲置时间超过5分钟，关闭串口');
    end;
end;
procedure TMainForm.TimerTimer(Sender: TObject);
var
    StrSmsReceive:PChar;
    I : Integer;
    SmsOne :TSms;
    RObject :ISuperObject;
begin
    StrSmsReceive := PChar('');
    if Assigned(Sms) and Assigned(ClientSocket) and ( Sms.NewFlag = 1 )then
    begin
        if Sms.Receive('4',StrSmsReceive) = 1 then
        begin
           SmsObj.getSmsListFromString(StrSmsReceive,SmsList);
           if Assigned(SmsList) then
           begin
                CloseCount := 0;
                for I := 0 to SmsList.Count - 1 do
                begin
                    SmsOne := SmsList.Values[I];
                    if SmsOne.SmsType = '24' then
                    begin
                        RObject := SO('{}');
                        RObject.S['tel'] := Common.enLargeCode(SmsOne.Tel,key);
                        RObject.S['msg'] := Common.enLargeCode(SmsOne.Text,key);
                        AddLogs('收到消息' + SmsOne.Text + '来自' + SmsOne.Tel);
                        ClientSocket.SendText(RObject.AsString + #$D#$A);
                    end;
                    Sms.Delete(SmsOne.Index);
                end;
                SmsList.clear;
           end;
        end;
    end;

end;
procedure TMainForm.RestartApp;
var
  BatchFile: TextFile;
  BatchFileName: string;
  ProcessInfo: TProcessInformation;
  StartUpInfo: TStartupInfo;
begin
  try
    BatchFileName := ExtractFilePath(ParamStr(0)) + '_D.bat';
    AssignFile(BatchFile, BatchFileName);
    Rewrite(BatchFile);
    Writeln(BatchFile, ExtractFileName(Application.ExeName) + ' ' + IntToStr(Port) + ' ' + IntToStr(Com) + ' '+IntToStr(BaudRate));
    Writeln(BatchFile, 'del   %0');
    CloseFile(BatchFile);
    FillChar(StartUpInfo, SizeOf(StartUpInfo), $00);
    StartUpInfo.dwFlags := STARTF_USESHOWWINDOW;
    StartUpInfo.wShowWindow := SW_HIDE;
    if CreateProcess(nil, PChar(BatchFileName), nil, nil,False, IDLE_PRIORITY_CLASS, nil, nil, StartUpInfo,ProcessInfo) then
    begin
      CloseHandle(ProcessInfo.hThread);
      CloseHandle(ProcessInfo.hProcess);
    end;
    Close;
    Application.Terminate;
  except
    ErrorLogsUnit.addErrors('系统重启失败');
  end;
end;

end.
