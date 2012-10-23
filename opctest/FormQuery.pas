unit FormQuery;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ExtCtrls, StdCtrls,iOPCTypes,ScktComp,Ini,LogsUnit,superobject,
  StrUtils,Common,iOPCFunctions,ComObj;

type
  TStringMap = class(TPersistent)
  private
    function GetItems(Key: string): string;
    function GetCount: Integer;
  public
    Keys: TStrings;
    Values: array of string;
    property Items[Key: string]: string read GetItems; default;
    property Count: Integer read GetCount;
    function Add(Key: string; Value: string): Integer;
    procedure clear;
    function Remove(Key: string): Integer;
    constructor Create; overload;
  end;
  TServer = class(TObject)
  public
    OPCItemMgt : IOPCItemMgt;
    OPCServer  : IOPCServer;
    GroupHandle: OPCHANDLE
  end;
  TServers = class(TPersistent)
  private
    function GetItems(Key: string): TServer;
    function GetCount: Integer;
  public
    Keys: TStrings;
    Values: array of TServer;
    property Items[Key: string]: TServer read GetItems; default;  //获取其单一元素
    property Count: Integer read GetCount;  //获取个数
    function Add(Key: string; Value: TServer): Integer;  //添加元素
    procedure clear;
    function Remove(Key: string): Integer;  //移除
    constructor Create; overload;
  end;

  TDevice = class(TObject)
  public
      OHandel : OPCHANDLE; //句柄
      OValue  : string;    //值
      OName   : string;    //名称
      Server  : TServer;   //服务
  end;

  TLogicDevice = class(TObject)
  public
    LogicDeviceId : string;
    IsOk          : Boolean;  //物理删除标识
    Address       : string;
    Value         : string;
    Devices       : array of TDevice;
    procedure Add(Device:TDevice);
  end;




  TScokets = class(TPersistent)
  private
    function GetItems(Key: string): TCustomWinSocket;
    function GetCount: Integer;
  public
    Keys: TStrings;
    Values: array of TCustomWinSocket;
    property Items[Key: string]: TCustomWinSocket read GetItems; default;  //获取其单一元素
    property Count: Integer read GetCount;  //获取个数
    function Add(Key: string; Value: TCustomWinSocket): Integer;  //添加元素
    procedure clear;
    function Remove(Key: string): Integer;  //移除
    constructor Create; overload;
  end;


  TFormQueryUnit = class(TForm)
    Logs: TMemo;
    LogClear: TCheckBox;
    ClearLogBtn: TButton;
    Timer: TTimer;
    DeBugCk: TCheckBox;
    ReadServer: TTimer;
    procedure FormShow(Sender: TObject);
    procedure TimerTimer(Sender: TObject);
    procedure ClearLogBtnClick(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure ReadServerTimer(Sender: TObject);
  private
    { Private declarations }
     HasError        : Boolean;
     IsAdd           : Boolean; 
     Servers         : TServers;
     Devices         : array of TLogicDevice;
     Scokets         : TScokets;
     Port            : Integer;      //本地监听端口
     ScoketServer    : TServerSocket; //本地监听scoket
     TimeSpan        : Integer;       //定时扫描间隔
     ServerPath      : string;
     RegeditStrings  : TStringMap;       //引擎注册字符串集合
     procedure AddLogs(Content:string);
     procedure Start;
     procedure OnClientConnect(Sender: TObject;Socket: TCustomWinSocket);
     procedure OnClientDisConnect(Sender: TObject;Socket: TCustomWinSocket);
     procedure OnClientRead(Sender: TObject;Socket: TCustomWinSocket);
     procedure OnErrorEvent(Sender: TObject; Socket: TCustomWinSocket; ErrorEvent: TErrorEvent; var ErrorCode: Integer);
     procedure OnClientError(Sender: TObject; Socket: TCustomWinSocket; ErrorEvent: TErrorEvent; var ErrorCode: Integer);
     procedure GetNewData; //读取新数据
      
  public
    { Public declarations }
  end;

var
  FormQueryUnit: TFormQueryUnit;

implementation

{$R *.dfm}
procedure TLogicDevice.Add(Device:TDevice);
begin
    SetLength(Devices,Length(Devices)+1);
    Devices[Length(Devices)-1] := Device;
end;



constructor TStringMap.Create;
begin
  Keys := TStringList.Create;
  SetLength(Values, 0);
end;
procedure TStringMap.clear;
begin
  SetLength(Values, 0);
  Keys.Clear;
end;
function TStringMap.GetItems(Key: string): string;
var
  KeyIndex: Integer;
begin
  KeyIndex := Keys.IndexOf(Key);
  if KeyIndex <> -1 then
    Result := Values[KeyIndex]
  else
    Result := '';
end;
function TStringMap.Add(Key: string; Value: string): Integer;
begin
  if Keys.IndexOf(Key) = -1 then
  begin
    Keys.Add(Key);
    SetLength(Values, Length(Values) + 1);
    Values[Length(Values) - 1] := Value;
  end
  else
    Values[Keys.IndexOf(Key)] := Value;
  Result := Length(Values) - 1;
end;
function TStringMap.GetCount: Integer;
begin
  Result := Keys.Count;
end;
function TStringMap.Remove(Key: string): Integer;
var
  Index : Integer;
  Count : Integer;
begin
  Index := Keys.IndexOf(Key);
  Count := Length(Values);
  if Index <> -1 then
  begin
    Keys.Delete(Index);
    Move(Values[Index + 1], Values[Index], (Count - Index) * SizeOf(Values[0]));
    SetLength(Values, Count - 1);
  end;
  Result := Count - 1;
end;



constructor TServers.Create;
begin
  Keys := TStringList.Create;
  SetLength(Values, 0);
end;
procedure TServers.clear;
begin
  SetLength(Values, 0);
  Keys.Clear;
end;
function TServers.GetItems(Key: string): TServer;
var
  KeyIndex: Integer;
begin
  KeyIndex := Keys.IndexOf(Key);
  if KeyIndex <> -1 then
  begin
      Result := Values[KeyIndex];
  end
  else
    Result := nil;
end;
function TServers.Add(Key: string; Value: TServer): Integer;
begin
  if Keys.IndexOf(Key) = -1 then
  begin
    Keys.Add(Key);
    SetLength(Values, Length(Values) + 1);
    Values[Length(Values) - 1] := Value;
  end
  else
  begin
    Values[Keys.IndexOf(Key)] := Value;
  end;
  Result := Length(Values) - 1;
end;
function TServers.GetCount: Integer;
begin
  Result := Keys.Count;
end;
function TServers.Remove(Key: string): Integer;
var
  Index : Integer;
  Count : Integer;
begin
  Index := Keys.IndexOf(Key);
  Count := Length(Values);
  if Index <> -1 then
  begin
    Keys.Delete(Index);
    Values[Index].Free;
    Move(Values[Index + 1], Values[Index], (Count - Index) * SizeOf(Values[0]));
    SetLength(Values, Count - 1);
  end;
  Result := Count - 1;
end;


constructor TScokets.Create;
begin
  Keys := TStringList.Create;
  SetLength(Values, 0);
end;
procedure TScokets.clear;
begin
  SetLength(Values, 0);
  Keys.Clear;
end;
function TScokets.GetItems(Key: string): TCustomWinSocket;
var
  KeyIndex: Integer;
begin
  KeyIndex := Keys.IndexOf(Key);
  if KeyIndex <> -1 then
    Result := Values[KeyIndex]
  else
    Result := nil;
end;
function TScokets.Add(Key: string; Value: TCustomWinSocket): Integer;
begin
  if Keys.IndexOf(Key) = -1 then
  begin
    Keys.Add(Key);
    SetLength(Values, Length(Values) + 1);
    Values[Length(Values) - 1] := Value;
  end
  else
    Values[Keys.IndexOf(Key)] := Value;
  Result := Length(Values) - 1;
end;
function TScokets.GetCount: Integer;
begin
  Result := Keys.Count;
end;
function TScokets.Remove(Key: string): Integer;
var
  Index : Integer;
  Count : Integer;
begin
  Index := Keys.IndexOf(Key);
  Count := Length(Values);
  if Index <> -1 then
  begin
    Keys.Delete(Index);
    Move(Values[Index + 1], Values[Index], (Count - Index) * SizeOf(Values[0]));
    SetLength(Values, Count - 1);
  end;
  Result := Count - 1;
end;




procedure TFormQueryUnit.ClearLogBtnClick(Sender: TObject);
begin
   Logs.Lines.Clear;
end;
procedure TFormQueryUnit.FormDestroy(Sender: TObject);
begin
   Servers.clear;
end;

procedure TFormQueryUnit.FormShow(Sender: TObject);
begin
   DeBugCk.Checked := True;
end;
procedure TFormQueryUnit.Start;
var
    temp : TStrings;
begin
    if not DirectoryExists(ExtractFileDir(PARAMSTR(0)) + '\logs') then CreateDirectory(PChar(ExtractFilePath(ParamStr(0)) + '\logs'), nil);
    if not FileExists(ExtractFileDir(PARAMSTR(0)) + '\config.ini') then
    begin
        temp := TStringList.Create;
        temp.Add('[server]');
        temp.Add('port=5000');
        temp.Add('serverpath=');
        temp.Add('time=500');
        AddLogs('没有找到配置文件，默认端口5000，连接本地..');
        temp.SaveToFile(ExtractFileDir(PARAMSTR(0)) + '\config.ini');
        Port := 5000;
        TimeSpan := 500;
    end
    else
    begin
        Port  := StrToInt(Ini.ReadIni('server','port'));
        TimeSpan  := StrToInt(Ini.ReadIni('server','time'));
        ServerPath    := Ini.ReadIni('server','serverpath');
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
       AddLogs('成功监听在端口：' + IntToStr(Port));
    except
       AddLogs('打开失败，可能是端口被占用了,当前端口：' + IntToStr(Port));
    end;
    Servers := TServers.Create;
    Scokets := TScokets.Create;
    RegeditStrings := TStringMap.Create;
    HasError:= False;
    IsAdd   := False;
    ReadServer.Interval := TimeSpan;
    ReadServer.Enabled := True;
end;
procedure TFormQueryUnit.TimerTimer(Sender: TObject);
begin
   Timer.Enabled := False;
   Start;
end;
procedure TFormQueryUnit.GetNewData;
var
  I                 :Integer;
  NeedSend          :Boolean;
  Scoket            :TCustomWinSocket;
  K                 :Integer;
  tempValue         :string;
  ItemQuality       : Word;
  RObject           :ISuperObject;
begin
  if IsAdd then Exit;
  if HasError then
  begin
      SetLength(Devices,0);
      Scokets.clear;
      HasError := False;
      Exit;
  end;
  
  
  for I := 0 to Length(Devices) - 1 do
  begin
     if not Devices[I].IsOk then Continue;
     
     RObject := SO('{}');
     NeedSend := False;
     RObject.S['id'] := Devices[I].LogicDeviceId;
     for K := 0 to Length(Devices[I].Devices) - 1 do
     begin
          try
              iOPCFunctions.OPCReadGroupItemValue(Devices[I].Devices[K].Server.OPCItemMgt,Devices[I].Devices[K].OHandel,tempValue,ItemQuality);
              if tempValue <> Devices[I].Devices[K].OValue  then
                 NeedSend := True;
              Devices[I].Devices[K].OValue := tempValue;
              RObject['value[]'] := SO(tempValue);
          except
              AddLogs('ID为' + Devices[I].LogicDeviceId+'的逻辑设备的点：'+Devices[I].Devices[K].OName+'查询失败，移除该设备！');
              Devices[I].IsOk := False;
          end;
     end;
     if NeedSend and Devices[I].IsOk then
     begin
         Devices[I].Value :=  Common.encode(RObject.AsString);
         Scoket := Scokets.Items[Devices[I].Address];
         if Assigned(Scoket) and Scoket.Connected then
         begin
            Scoket.SendText(Devices[I].Value+#$D#$A);
         end;
     end;
  end;
end;
procedure TFormQueryUnit.AddLogs(Content:string);
begin
   if  DeBugCk.Checked then
   begin
        Logs.Lines.Add(Content);
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
procedure TFormQueryUnit.OnClientConnect(Sender: TObject;Socket: TCustomWinSocket);
var
  address : string;
begin
  address := Socket.RemoteAddress+':'+ InttoStr(Socket.RemotePort);
  AddLogs(address + '已经连接');
end;
procedure TFormQueryUnit.OnClientDisConnect(Sender: TObject;Socket: TCustomWinSocket);
var
  address : string;
begin
  address := Socket.RemoteAddress+':'+ InttoStr(Socket.RemotePort);
  AddLogs(address + '断开连接');
  HasError:= True;
end;
procedure TFormQueryUnit.OnClientRead(Sender: TObject;Socket: TCustomWinSocket);
var
  RevText             : string;
  Temp                : string;
  Index               : Integer;
  RevObj              : ISuperObject;
  Address             : string;
  Devs                : TSuperArray;
  Dev                 : ISuperObject;
  I                   : Integer;
  K                   : Integer;
  ALogicDevice        : TLogicDevice;
  Points              : TSuperArray;
  phDev               : ISuperObject;
  Server              : TServer;
  Device              : TDevice;
  CanonicalType       : TVarType;
  Active              : Boolean;
begin
  Address := Socket.RemoteAddress+':'+ InttoStr(Socket.RemotePort);
  RevText := Trim(Socket.ReceiveText);
  Index := Pos('^_^',RevText);
  if Index = 0 then
  begin
      Temp := RegeditStrings.Items[Address];
      Temp := Temp + RevText;
      RegeditStrings.Add(Address,Temp);
      Exit;
  end;

   Temp := RegeditStrings.Items[Address];
   Temp := Temp + RevText;
   RevText := '';
   RegeditStrings.Remove(Address);
   Temp := LeftStr(Temp,Length(Temp)-3);
  try
     RevText := Common.decode(Temp);
  except
     AddLogs('解码发生异常！('+Address+')'+RevText);
     Exit;
  end;
  IsAdd   := True;
  RevObj := SO(RevText);
  if not Assigned(RevObj) then
  begin
     AddLogs('解析格式错误('+Address+')'+RevText);
     Exit;
  end;
  Devs := RevObj.A['device'];
  if not Assigned(Devs) then
  begin
     AddLogs('解析格式错误('+Address+')'+RevText);
     Exit;
  end;

  Scokets.Add(Address,Socket);

  for I := 0 to Devs.Length - 1 do
  begin
      Dev := Devs.O[I];
      ALogicDevice := TLogicDevice.Create;
      ALogicDevice.LogicDeviceId := Dev.S['id'];
      ALogicDevice.Address := Address;
      ALogicDevice.IsOk := True;
      Points := Dev.A['device'];
      Active := True;
      for K := 0 to Points.Length - 1 do
      begin
           phDev := Points.O[K];
           Server := Servers.Items[phDev.S['serverName']];
           Device := TDevice.Create;
           Device.OName := phDev.S['itemName'];
           if not Assigned(Server) then
           begin
              try
                Server := TServer.Create;
                Server.OPCServer  := (CreateComObject(ProgIDToClassID(phDev.S['serverName'])) as IOPCServer);
                iOPCFunctions.OPCServerAddGroup(Server.OPCServer,phDev.S['serverName'] + '_group1',True,500,Server.OPCItemMgt,Server.GroupHandle);
                Servers.Add(phDev.S['serverName'],Server);
              except
                AddLogs(phDev.S['serverName'] + '服务注册失败');
                Server.Free;
                Server := nil;
                Servers.Remove(phDev.S['serverName']);
              end;
           end;
           if Assigned(Server) then
           begin
               iOPCFunctions.OPCGroupAddItem(Server.OPCItemMgt,Device.OName,Server.GroupHandle,varString,Device.OHandel,CanonicalType);
               Device.Server := Server;
               ALogicDevice.Add(Device);
           end
           else
           begin
               AddLogs(Device.OName + '点注册失败');
               Active := False;
           end;
      end;
      if Active then
      begin
          SetLength(Devices,Length(Devices)+1);
          Devices[Length(Devices)-1] := ALogicDevice;
      end;
  end;
  IsAdd   := False;
end;
procedure TFormQueryUnit.OnErrorEvent(Sender: TObject; Socket: TCustomWinSocket; ErrorEvent: TErrorEvent; var ErrorCode: Integer);
var
  address:string;
begin
  address := Socket.RemoteAddress+':'+ InttoStr(Socket.RemotePort);
  AddLogs(address + '发生异常');
  ErrorCode := 0;
  HasError:= True;
end;
procedure TFormQueryUnit.ReadServerTimer(Sender: TObject);
begin
    GetNewData;
end;

procedure TFormQueryUnit.OnClientError(Sender: TObject; Socket: TCustomWinSocket; ErrorEvent: TErrorEvent; var ErrorCode: Integer);
var
  address : string;
begin
  address := Socket.RemoteAddress+':'+ InttoStr(Socket.RemotePort);
  AddLogs(address + '发生异常');
  ErrorCode := 0;
  HasError:= True;
end;


end.
