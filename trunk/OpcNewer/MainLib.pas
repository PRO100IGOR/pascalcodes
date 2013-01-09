unit MainLib;

interface

uses
  Windows, Messages, SysUtils,
  Variants, Classes, Graphics, Controls,
  Forms,Dialogs,ComObj,OPCtypes,OPCDA,
  OPCutils,ActiveX, StdCtrls,BaseTypes,
  ExtCtrls,LogsUnit,ScktComp,Ini,superobject,
  Common,StrUtils,Clipbrd;
type
  TMainForm = class(TForm)
    Logs: TMemo;
    LogClear: TCheckBox;
    ClearLogBtn: TButton;
    DeBugCk: TCheckBox;
    Timer: TTimer;
    TimeStart: TTimer;
    TimeRun: TTimer;
    procedure ClearLogBtnClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure TimerTimer(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure TimeStartTimer(Sender: TObject);
    procedure TimeRunTimer(Sender: TObject);
  private
    { Private declarations }
  public
    ServerPath      : string;       //OPC����·��
    Port            : Integer;      //���ؼ����˿�
    Time            : Integer;      //ʱ��
    Filters         : TStrings;     //�����ı�
    ScoketServer    : TServerSocket; //���ؼ���scoket
    Servers         : TServers;      //����˼���
    LogicDevices    : TLogicDevices;  //�߼��豸����
    Scokets         : TScokets;       //�ͻ������Ӽ���
    RegeditStrings  : TStringMap;       //����ע���ַ�������
    IsClear         : Boolean;
    PointCount      : Integer;        //����
    procedure AddLogs(Content:string);
    procedure Start;
    procedure OnClientConnect(Sender: TObject;Socket: TCustomWinSocket);
    procedure OnClientDisConnect(Sender: TObject;Socket: TCustomWinSocket);
    procedure OnClientRead(Sender: TObject;Socket: TCustomWinSocket);
    procedure OnErrorEvent(Sender: TObject; Socket: TCustomWinSocket; ErrorEvent: TErrorEvent; var ErrorCode: Integer);
    procedure OnClientError(Sender: TObject; Socket: TCustomWinSocket; ErrorEvent: TErrorEvent; var ErrorCode: Integer);
    procedure OnDataChange(LogicDeviceId:TStrings;ItemHandel:Opchandle;ItemValue:string);
    procedure ClearData;
  end;

var
  MainForm: TMainForm;
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
      LogsUnit.addErrors(Content);
   end;
end;
procedure TMainForm.ClearLogBtnClick(Sender: TObject);
begin
  Clipboard.AsText := Logs.Text;
  Logs.Lines.Clear;
end;
procedure TMainForm.FormDestroy(Sender: TObject);
var
  I           :Integer;
begin
  for I := 0 to Servers.Count - 1 do
  begin
      Servers.Values[I].Free ;
  end;
end;
procedure TMainForm.FormShow(Sender: TObject);
begin
    DeBugCk.Checked := True;
end;
procedure TMainForm.Start;
var
    temp : TStrings;
begin
    if not DirectoryExists(ExtractFileDir(PARAMSTR(0)) + '\logs') then CreateDirectory(PChar(ExtractFilePath(ParamStr(0)) + '\logs'), nil);
    if not FileExists(ExtractFileDir(PARAMSTR(0)) + '\config.ini') then
    begin
        temp := TStringList.Create;
        temp.Add('[server]');
        temp.Add('port=5000');
        temp.Add('time=5000');
        temp.Add('serverpath=');
        temp.Add('filter=');
        AddLogs('û���ҵ������ļ���Ĭ�϶˿�5000�����ӱ���..');
        temp.SaveToFile(ExtractFileDir(PARAMSTR(0)) + '\config.ini');
        Port := 5000;
        ServerPath := '';
        Time := 5000;
        Filters := TStringList.Create;
        Filters.Add('Bad');
    end
    else
    begin
      Port          := StrToInt(Ini.ReadIni('server','port'));
      Time          := StrToInt(Ini.ReadIni('server','time'));
      ServerPath    := Ini.ReadIni('server','serverpath');
      Filters       := Common.SplitToStrings(Ini.ReadIni('server','filter'),',');
    end;
    ScoketServer := TServerSocket.Create(Application);
    ScoketServer.Port := Port;
    ScoketServer.OnClientConnect := OnClientConnect;
    ScoketServer.OnClientRead := OnClientRead;
    ScoketServer.OnClientDisconnect := OnClientDisConnect;
    ScoketServer.Socket.OnErrorEvent := OnErrorEvent;
    ScoketServer.Socket.OnClientError := OnClientError;
    try
       ScoketServer.Open;
       AddLogs('�ɹ������ڶ˿ڣ�' + IntToStr(Port));
    except
       AddLogs('��ʧ�ܣ������Ƕ˿ڱ�ռ����,��ǰ�˿ڣ�' + IntToStr(Port));
       Exit;
    end;
    Servers := TServers.Create;
    LogicDevices := TLogicDevices.Create;
    Scokets := TScokets.Create;
    RegeditStrings := TStringMap.Create;
    IsClear := False;
    TimeRun.Interval := Time;
    PointCount := 0;
end;
procedure TMainForm.TimerTimer(Sender: TObject);
begin
    Timer.Enabled := False;
    Start;
end;
procedure TMainForm.TimeRunTimer(Sender: TObject);
var
  I,K                       :Integer;
  ItemValue                 :string;
  ItemQuality               :Word;
  Item                      :TItem;
  Counts        :Integer;
begin
  Counts := 0;
  for I := 0 to Servers.Count - 1 do
  begin
     for K := 0 to Servers.Values[I].Items.Count - 1 do
     begin
          Item := Servers.Values[I].Items.Values[K];
          ReadOPCGroupItemValue(Servers.Values[I].GroupIf, Item.ItemHandel,ItemValue, ItemQuality);
          if (ItemQuality = OPC_QUALITY_GOOD) and (Item.ItemValue <> ItemValue) and (Filters.IndexOf(ItemValue) = -1)then
          begin
               Item.ItemValue := ItemValue;
               OnDataChange(Item.LogicDeviceId,Item.ItemHandel,ItemValue);
               Servers.Values[I].Items.Add(Servers.Values[I].Items.Keys[K],Item);
          end;
          Inc(Counts);
     end;
  end;
  if Counts <> PointCount then
     AddLogs('ɨ���OPC����ԭ����ӵĵ��������,�����' + IntToStr(PointCount)+'��,ɨ����'+InttoStr(Counts)+'��')
end;
procedure TMainForm.TimeStartTimer(Sender: TObject);
begin
  TimeStart.Enabled := False;
  AddLogs('��ʼɨ��OPC...');
  TimeRun.Enabled := True;
end;
procedure TMainForm.OnClientConnect(Sender: TObject;Socket: TCustomWinSocket);
var
  address : string;
begin
  address := Socket.RemoteAddress+':'+ InttoStr(Socket.RemotePort);
  AddLogs(address + '�Ѿ�����');
end;
procedure TMainForm.OnClientDisConnect(Sender: TObject;Socket: TCustomWinSocket);
var
  address : string;
begin
  address := Socket.RemoteAddress+':'+ InttoStr(Socket.RemotePort);
  AddLogs(address + '�Ͽ�����');
  ClearData;
end;
procedure TMainForm.ClearData;
var
    I:Integer;
begin
    if IsClear then Exit;
    if LogicDevices.Count = 0  then Exit;
    IsClear := True;
    TimeRun.Enabled := False;
    for I := 0 to Servers.Count - 1 do
    begin
        Servers.Values[I].Clear;
    end;
    Scokets.clear;
    LogicDevices.clear;
    RegeditStrings.clear;
    IsClear := False;
    PointCount := 0;
end;
procedure TMainForm.OnClientRead(Sender: TObject;Socket: TCustomWinSocket);
var
  RevText     : string;
  Temp        : string;
  Index       : Integer;
  RevObj      : ISuperObject;
  Address     : string;
  Devs        : TSuperArray;
  Dev         : ISuperObject;
  I           : Integer;
  K           : Integer;
  ALogicDevice: TLogicDevice;
  Points      : TSuperArray;
  phDev       : ISuperObject;
  Active      : Boolean;
  Server      : TServer;
  ItemHandle  : Opchandle;
  FailLogicDevice : TStrings;
  HasAdd      :Boolean;
  IsNewItem   :Boolean;
begin
  HasAdd := False;
  Address := Socket.RemoteAddress+':'+ InttoStr(Socket.RemotePort);
  RevText := Trim(Socket.ReceiveText);
  Index := Pos('^_^',RevText);
  if (Index = 0) and (RevText <> '') then
  begin
      Temp := RegeditStrings.Items[Address];
      Temp := Temp + RevText;
      RegeditStrings.Add(Address,Temp);
      Exit;
  end;

  Temp := RegeditStrings.Items[Address];
  Temp := Temp + RevText;
  RevText := '';

  Temp := LeftStr(Temp,Length(Temp)-3);
  try
     RevText := Common.decode(Temp);
  except
     AddLogs('���뷢���쳣��('+Address+')'+RevText);
     Exit;
  end;
  RevObj := SO(RevText);
  if not Assigned(RevObj) then
  begin
     AddLogs('������ʽ����('+Address+')'+RevText);
     Exit;
  end;
  Devs := RevObj.A['device'];
  if not Assigned(Devs) then
  begin
     AddLogs('������ʽ����('+Address+')'+RevText);
     Exit;
  end;
  Scokets.Add(Address,Socket);
  FailLogicDevice := TStringList.Create;
  for I := 0 to Devs.Length - 1 do
  begin
      Dev := Devs.O[I];
      ALogicDevice := TLogicDevice.Create;
      ALogicDevice.ID := Dev.S['id'];
      ALogicDevice.Address := Address;
      Points := Dev.A['device'];
      Active := True;
      for K := 0 to Points.Length - 1 do
      begin
           HasAdd := True;
           phDev := Points.O[K];
           Server := Servers.Items[phDev.S['serverName']];
           if not Assigned(Server) then
           begin
                Server := TServer.Create;
                Server.ServerName := phDev.S['serverName'];
                if not Server.Init then
                begin
                   AddLogs('����ķ�����:' + phDev.S['serverName']);
                   Server.Free;
                   Server := nil;
                end;
                if Assigned(Server) then
                begin
                    Servers.Add(phDev.S['serverName'],Server);
                end;
           end;
           if Assigned(Server) then
           begin
               ItemHandle := Server.Add(ALogicDevice.ID,phDev.S['itemName'],IsNewItem);
               if ItemHandle = 0 then
               begin
                   Active := False;
                   AddLogs(phDev.S['serverName'] + '>'+ phDev.S['itemName']+'����ʧ�ܣ�,�߼��豸ID��' + ALogicDevice.ID);
               end;
               if ItemHandle <> 0 then
               begin
                  ALogicDevice.ItemsValues.Add(IntToStr(ItemHandle),'-');
                  if IsNewItem then
                     Inc(PointCount)
                  else
                     AddLogs(phDev.S['itemName'] + '���ʧ�ܣ��������Ѿ���ӹ����ߵ㲻���ڣ�');
               end
               else
                   Active := False;
           end
           else
           begin
                 Active := False;
                 AddLogs(phDev.S['serverName'] + '>'+ phDev.S['itemName']+'����ʧ�ܣ�');
           end;
      end;
      LogicDevices.Add(ALogicDevice.ID,ALogicDevice);
      if not Active then
         FailLogicDevice.Add(ALogicDevice.ID);
  end;

 for K := 0 to FailLogicDevice.Count - 1 do
 begin
      Servers.RemoveErrors(LogicDevices.Items[FailLogicDevice[K]].ItemsValues.Keys);
      LogicDevices.Remove(FailLogicDevice[K]);
 end;
 if HasAdd and  not TimeStart.Enabled then
     TimeStart.Enabled := True;
 AddLogs('��������' + IntToStr(Devs.Length) + '���豸��Ҫ���,ʵ�������' + IntToStr(Devs.Length - FailLogicDevice.Count)+'��,' + IntToStr(FailLogicDevice.Count) + '��ʧ��,Ŀǰһ����' + IntToStr(LogicDevices.Count) + '��,��' + IntToStr(PointCount)+'��������');
end;
procedure TMainForm.OnErrorEvent(Sender: TObject; Socket: TCustomWinSocket; ErrorEvent: TErrorEvent; var ErrorCode: Integer);
var
  address:string;
begin
  address := Socket.RemoteAddress+':'+ InttoStr(Socket.RemotePort);
  AddLogs(address + '�����쳣');
  ClearData;
  ErrorCode := 0;
end;
procedure TMainForm.OnClientError(Sender: TObject; Socket: TCustomWinSocket; ErrorEvent: TErrorEvent; var ErrorCode: Integer);
var
  address : string;
begin
  address := Socket.RemoteAddress+':'+ InttoStr(Socket.RemotePort);
  AddLogs(address + '�����쳣');
  ClearData;
  ErrorCode := 0;
end;
procedure TMainForm.OnDataChange(LogicDeviceId:TStrings;ItemHandel:Opchandle;ItemValue:string);
 var
   LogicDevice :TLogicDevice;
   Value:string;
   Socket :TCustomWinSocket ;
   I :Integer;
 begin
   for I := 0 to LogicDeviceId.Count - 1 do
   begin
     LogicDevice := LogicDevices.Items[LogicDeviceId[I]];
     if Assigned(LogicDevice) then
     begin
         try
            LogicDevice.ItemsValues.Add(InttoStr(ItemHandel),ItemValue);
            Value := LogicDevice.getValueString;
         except
            Addlogs(LogicDeviceId[I] + '����ֵʱ�����쳣');
         end;
         if Value <> '' then
         begin
             Socket := Scokets.Items[LogicDevice.Address];
             if Assigned(Socket) then
                Socket.SendText(Common.encode(Value) + #$D#$A)
             else
                Addlogs('�Ҳ����Ự��' + LogicDevice.ID);
         end
//         else
//             Addlogs('�����豸û��ֵ��' + LogicDevice.ID);
     end
     else
     begin
         Addlogs('�Ҳ����߼��豸��' + ItemValue);
     end;
   end;
 end;
end.
