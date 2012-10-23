unit PrintLib;

interface

uses
  MySqlLib, Base, StdCtrls,Classes,Ini,SPComm, SysUtils, ExtCtrls,LogsUnit,FireDwr,Common,CnUDP,SOAPHTTPClient;

  function getStrNums(src,p:string):Integer;

type

  TPrint = class(TBase)
  public
    PID: string;
    PNAME: string;
    COMM: string;
    BaudRate: string;
    StopBits: string;
    DataBits: string;
    ParityBits: string;
    FlowControl: string;
    ConnType:string;
    Port:string;
    SpComm: TComm;
    UDP:TCnUDP;
    mess:string;
    messCount :Integer;
    Timer: TTimer;
//    thread:TThread;
    procedure open;
    procedure close;
    procedure receiveData(Sender: TObject; Buffer: Pointer; BufferLength: Word);
    procedure UDPDataReceived(Sender: TComponent; Buffer: Pointer;
      Len: Integer; FromIP: String; Port: Integer);
    procedure sendMess(Sender: TObject);
  end;

  THashBases = class(TPersistent)
  private
    function GetItems(Key: string): TPrint;
    function GetCount: Integer;
  public
    Keys: TStrings;
    Values: array of TPrint;
    property Items[Key: string]: TPrint read GetItems; default;  //获取其单一元素
    property Count: Integer read GetCount;  //获取个数
    function Add(Key: string; Value: TPrint): Integer;  //添加元素
    function Remove(Key: string): Integer;  //移除
    constructor Create; overload;
  end;

  TPrintManager = class(MySqlBase)
    prints:THashBases;
    procedure open;
    procedure close;
  end;
  var
     owner:TComponent;
     path:string;
     HTTPRIO: THTTPRIO;
     Memo1: TMemo;
implementation

function getStrNums(src,p:string):Integer;
begin
   Result := (Length(src) - Length(StringReplace(src,p,'',[rfReplaceAll])));
end;

procedure TPrint.sendMess(Sender: TObject);
var
  FireDwrs :FireDwrPortType;
  r:Boolean;
begin
   Timer.Enabled := False;
   if Sender <> nil then
   begin
      Memo1.Lines.Add('******************');
      Memo1.Lines.Add(FormatDateTime('hh:mm:ss',now) + '等待超时，发送剩余消息：' +mess);
      Memo1.Lines.Add('******************');
   end;

   try
      Memo1.Lines.Add('******************');
      Memo1.Lines.Add(FormatDateTime('hh:mm:ss',now)+'全部信息：'+mess);
      Memo1.Lines.Add('******************');
      mess := Common.StrToUniCode(mess);
      FireDwrs := GetFireDwrPortType(True, path, HTTPRIO);
      r := FireDwrs.addInfo(mess,PID);
      LogsUnit.addErrors(PNAME+'发送成功');
   except
      LogsUnit.addErrors(PNAME+'发送数据时，webservice连接异常,稍后重新发送');
      Memo1.Lines.Add('******************');
      Memo1.Lines.Add(FormatDateTime('hh:mm:ss',now)+ '  '+PNAME+'发送失败');
      Memo1.Lines.Add('******************');
   end;
   FireDwrs._Release;
   messCount := 0;
   mess := '';
end;


procedure TPrintManager.close;
var
  I:Integer;
begin
  if prints <> nil then
  begin
    for I := 0 to prints.Count - 1 do
    begin
        prints.Values[I].close;
    end;
    prints.Destroy;
  end;
end;

procedure TPrint.receiveData(Sender: TObject; Buffer: Pointer; BufferLength: Word);
var
  Str: string;
begin
  SetLength(Str, BufferLength);
  Move(buffer^, PChar(@Str[1])^, bufferlength);
  Str := Common.StrToUniCode(Str);
  Memo1.Lines.Add(Str);
  mess :=  mess + Str;
  messCount := getStrNums(mess,' ');
  if not  Timer.Enabled then
     Timer.Enabled := True;
  if messCount >= StrToInt(Ini.ReadIni('server','count')) then
     sendMess(nil);
end;




procedure TPrint.UDPDataReceived(Sender: TComponent; Buffer: Pointer;
      Len: Integer; FromIP: String; Port: Integer);
      var
        Str:string;
        r:Boolean;
        Stream: TStringStream;
        I:Integer;
      begin
        Stream := TStringStream.Create('');
        Stream.WriteBuffer(buffer^,Len);
        Stream.Seek(StrToInt(Ini.ReadIni('server','seek')),0);
        Str := Stream.ReadString(Stream.Size);
        Memo1.Lines.Add(FormatDateTime('hh:mm:ss',now)+'  '+Str);
        mess :=  mess + Str;
        messCount := getStrNums(mess,' ');
        if not  Timer.Enabled then
           Timer.Enabled := True;
        if messCount >= StrToInt(Ini.ReadIni('server','count')) then
           sendMess(nil);
      end;
procedure TPrint.close;
begin
  if ConnType = '1' then
  begin
     SpComm.StopComm;
     SpComm.Free;
  end
  else
  begin
    UDP.Free;
  end;
  if Timer <> nil then
  begin
    Timer.Enabled := False;
    Timer.Free;
  end;
end;

procedure TPrint.open;
begin
  try
    if ConnType = '1' then
    begin
      SpComm := TComm.Create(owner);
      SpComm.CommName := COMM;
      SpComm.BaudRate := StrtoInt(BaudRate);
      SpComm.Parity := TParity(StrToInt(ParityBits));
      SpComm.ByteSize := TByteSize(StrToInt(DataBits));
      SpComm.StopBits := TStopBits(StrToInt(StopBits));
      SpComm.OnReceiveData := receiveData;
      SpComm.StartComm;
    end
    else
    begin
       UDP := TCnUDP.Create(owner);
       UDP.LocalPort := StrToInt(Port);
       UDP.OnDataReceived := UDPDataReceived;
       Memo1.Lines.Add(PNAME+'开始初始化，模式UDP，监听在'+Port);
    end;
    messCount := 0;
    mess := '';
    Timer := TTimer.Create(nil);
    Timer.Enabled := False;
    Timer.Interval := StrToInt(Ini.ReadIni('server','timer')) * 60000;
    Timer.OnTimer := sendMess;
  except

  end;
end;

procedure TPrintManager.open;
var
  TSQL: string;
  Prints: THashBases;
  Print: TPrint;
begin
  TSQL := 'select * from PRINTERS where ENABLED = 1';
  close;
  prints := THashBases.Create;
  try
    with UniQueryForOp do
    begin
      Close;
      Sql.Clear;
      Sql.Add(TSQL);
      ExecSQL;
      while not Eof do
      begin
        Print := TPrint.Create;
        Print.PID := FieldByName('PID').AsString;
        Print.PNAME := FieldByName('PNAME').AsString;
        Print.COMM := FieldByName('COMM').AsString;
        Print.BaudRate := FieldByName('BAUDRATE').AsString;
        Print.StopBits := FieldByName('STOPBITS').AsString;
        Print.DataBits := FieldByName('DATABITS').AsString;
        Print.ParityBits := FieldByName('PARITYBITS').AsString;
        Print.FlowControl := FieldByName('FLOWCONTROL').AsString;
        Print.Port :=   FieldByName('Port').AsString;
        Print.ConnType :=   FieldByName('ConnType').AsString;
        prints.Add(Print.PID, Print);
        Print.open;
        Next;
      end;
      Close;
    end;
  except

  end;
end;

constructor THashBases.Create;
begin
  Keys := TStringList.Create;
  SetLength(Values, 0);
end;

function THashBases.GetItems(Key: string): TPrint;
var
  KeyIndex: Integer;
begin
  KeyIndex := Keys.IndexOf(Key);
  if KeyIndex <> -1 then
    Result := Values[KeyIndex]
  else
    Result := nil;
end;

function THashBases.Add(Key: string; Value: TPrint): Integer;
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

function THashBases.GetCount: Integer;
begin
  Result := Keys.Count;
end;

function THashBases.Remove(Key: string): Integer; //移除
var
  Index, Count: Integer;
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

end.

