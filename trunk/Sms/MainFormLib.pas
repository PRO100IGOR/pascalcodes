unit MainFormLib;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ExtCtrls, StdCtrls,ScktComp,Common,SmsObj,superobject,ErrorLogsUnit,
  SmsLib,Clipbrd,StrUtils;

(*
   �����ʽ
   type:command
   type --
          forces   ��Կ��֤          ��     forces:sihekejimustgo,������ظ�java���� forces:sihekejibugo,����֤���
          form     �رջ���������    ��     form:close  form:restart
          com      �رջ���������    ��     com:close   com:restart   �ص���ǰ������ĳ������ ��һ�����ּ���   ��com:2
          msg      ������Ϣ          ��     msg:{msg:[{tel:'',msg:''}]},���Է��Ͷ������.��Ϣ����������
   ���е�����Ҫ��^_^��β
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
    ScoketServer    : TServerSocket;    //���ؼ���scoket
    SmsList         : TSmsList;         //��Ϣ����
    CloseCount      : Integer;          //�з��ͼ�¼�ı��
    ClientSocket    : TCustomWinSocket ;//�ͻ�������
    CommandCashe     : string;             //�����
    Sms             : TSmsLoad;
    //**ScoketServer�¼����忪ʼ
    procedure OnClientRead(Sender: TObject;Socket: TCustomWinSocket);
    procedure OnClientConnect(Sender: TObject;Socket: TCustomWinSocket);
    procedure OnClientError(Sender: TObject; Socket: TCustomWinSocket; ErrorEvent: TErrorEvent; var ErrorCode: Integer);
    //**ScoketServer�¼��������
    procedure AddLogs(Content:string);
    procedure RestartApp; //��������
  public
    Port            : Integer;
    Com             : Integer;
    BaudRate        : Integer;
    function  OpenPort:Integer;                 //��tcp
    function  OpenCom(NeedReapt :Boolean = True):Integer;  //��������è����
    function  CloseCom:Integer;                               //�رն���è����
    function  SendMsg(Tel,Msg:string):Integer;              //���Ͷ���
    function  DesFree:Integer;                                //�ͷš��ر���Դ
  end;
var
  MainForm: TMainForm;
  key     : string = 'sihekejikillall';   //������Կ
  cipher  : string = 'sihekejimustgo';  //����
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
  AddLogs(address + '�����쳣');
  ErrorCode := 0;
end;
procedure TMainForm.OnClientConnect(Sender: TObject;Socket: TCustomWinSocket);
var
  address : string;
begin
  address := Socket.RemoteAddress+':'+ InttoStr(Socket.RemotePort);
  AddLogs(address + '�Ѿ�����');
end;
procedure TMainForm.OnClientRead(Sender: TObject;Socket: TCustomWinSocket);
var
  RevText       :  string; //���յ�����Ϣ
  CommandType   :  string; //��������
  Command       :  string; //��������
  Index         :  Integer; //�±�
  RevObj        :  ISuperObject;//msg�ܶ���
  Msgs          :  TSuperArray;  //msg������
begin
  RevText := Trim(Socket.ReceiveText);
  Addlogs('�յ����� >>' + RevText);
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
      Addlogs('��������forces >>' + Command);
      if Command = cipher then
      begin
           ClientSocket := Socket;
           ClientSocket.SendText('forces:'+cipher2+#$D#$A);
      end;
  end
  else if CommandType = 'form'  then
  begin
      Addlogs('��������form >>' + Command);
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
      Addlogs('��������com >>' + Command);
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
      Addlogs('��������msg >>' + Command);
      RevObj := SO(Command);
      if not Assigned(RevObj) then
      begin
         ClientSocket.SendText('msg'+#$D#$A);
         AddLogs('������ʽ����'+Command);
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
       AddLogs(InttoStr(Port) + '�˿�׼��over');
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
     AddLogs(InttoStr(Com) + '���ڴ���');
     if not Assigned(Sms) then Sms := TSmsLoad.Create(Result);
     if Result = 1 then Result := Sms.Connection('//�Ϻ�Ѹ����Ϣ�������޹�˾,��ַwww.xunsai.com//',COM,BaudRate,Mobile_Type,CopyRightToCOM);
     if Result <> 1 then  closeCom
     else
     begin
         Timer.Enabled := True;
         AddLogs(InttoStr(Com) + '���ڴ���');
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
       AddLogs('���ڹر���');
       Result  := 1;
       TimerFree.Enabled := False;
    end;
end;
function  TMainForm.SendMsg(Tel,Msg:string):Integer;
begin
   Result := 0;
   if not Assigned(Sms) then  OpenCom(False);
   if Assigned(Sms) then Result := Sms.Send(Common.deLargeCode(Tel,key),Common.deLargeCode(Msg,key));
   if Result = 1 then AddLogs('�������>>'+Common.deLargeCode(Msg,key) + '>>>' + Common.deLargeCode(Tel,key))
   else AddLogs('����ʧ��>>'+Common.deLargeCode(Msg,key) + '>>>' + Common.deLargeCode(Tel,key));
   CloseCount := 0;
end;
function  TMainForm.DesFree:Integer;
begin
    CloseCom;
    Result := 1;
    AddLogs('��Դ�ͷ����');
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
       AddLogs('����ʱ�䳬��5���ӣ��رմ���');
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
                        AddLogs('�յ���Ϣ' + SmsOne.Text + '����' + SmsOne.Tel);
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
    ErrorLogsUnit.addErrors('ϵͳ����ʧ��');
  end;
end;

end.
