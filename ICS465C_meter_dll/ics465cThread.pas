unit ics465cThread;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, SyncObjs, serialportLoad;

type
  TWeighingCallBack = procedure(Weight, Tare: Double; isGross, isOverLoad: Boolean); stdcall;

  TIcs465c_meter = class(TThread)
    FCallback: Pointer;

    FisOpened: Boolean;
    FComId: Integer;
    FComPort: TComPort; // 串口对象
    FSerialPortDllFileName: string;
    FisSynchronize: Boolean; // 是否用同步方法

  private
        //FIsOverLoad: Boolean;
        //FIsGross: Boolean;
    FIsCommand: Boolean;
    FAddr: Integer;
    FWeight, FTotal, FSubtotal: Double;
    FFlow, FBeltSpeed, FLineSpeed: Double;

    FCriticalSection: TCriticalSection;

    procedure Lock;
    procedure UnLock;

    function readWeight: Boolean; virtual;
    function IsOverLoad: Boolean; virtual;
    function IsGross: Boolean; virtual;

    function GetDecimalPointFactor(DecimalCount: Byte): Double;
        //function GetDecimalMultiply(StatusByteA: Byte): Double;
        //function TestIsGross(StatusByteB : Byte): Boolean;
        //function GetSign(StatusByteB : Byte): Double;
        //function TestIsOverLoad(StatusByteB: Byte): Boolean;
    function GetWeightInternal(var buffer; Pos, size: Integer): Double;

    procedure SetAddr(Address: Integer);

  protected
    procedure ShowData; virtual; //(Weight, Tare: Double; isGross, isOverLoad: Boolean); virtual;
    procedure Execute; override;
  public
    property ComId: Integer read FComId;
    property SerialPortDllName: string read FSerialPortDllFileName;
    property IsSynchronize: Boolean read FisSynchronize write FisSynchronize;
    property IsCommand: Boolean read FIsCommand write FIsCommand;
    property Address: Integer read FAddr write SetAddr;

    procedure SetCallBack(CallBack: Pointer); virtual;
    function GetWeight: Double; virtual;
    function GetTotal: Double; virtual;
    function GetSubTotal: Double; virtual;
    function GetBeltSpeed: Double; virtual; // 皮带速度
    function GetLineSpeed: Double; virtual; // 线速度
    function OpenCom(SerialPortDllFileName: string; PortId: Integer): Integer; virtual;
    function CloseCom: Integer; virtual;
    procedure SetParams(Baud: TBaudRate;
      StopBit: TStopBits;
      DataBit: TDataBits;
      Parity: TParityBits;
      FlowControl: TFlowControl); virtual;

    procedure Start; virtual;
    procedure Stop; virtual;
    procedure SendCommand; virtual;

    constructor Create(ComId: Integer); overload; virtual;
    destructor Destroy; override;
  published
        {none}
  end;

implementation

constructor TIcs465c_meter.Create(ComId: Integer);
begin
  inherited Create(True);
  FComId := ComId;
  FComPort := nil;
  FSerialPortDllFileName := '';
  FCallback := nil;
  FisOpened := False;

  FIsCommand := True;
  FAddr := $0F;
  FWeight := 0.0;
  FTotal := 0.0;
  FSubtotal := 0.0;
  FFlow := 0.0;
  FBeltSpeed := 0.0;
  FLineSpeed := 0.0;
    //Terminated := True;

  ReturnValue := 0;
  FisSynchronize := False;

  FCriticalSection := TCriticalSection.Create; // 建锁
end;

destructor TIcs465c_meter.Destroy;
begin
  try
    FCriticalSection.Free;
  except
    FCriticalSection := nil;
  end;

  Stop; // 停止线程

  CloseCom; // 关闭串口

  inherited Destroy;
end;

procedure TIcs465c_meter.SetCallBack(CallBack: Pointer);
begin
  FCallback := CallBack;
end;

procedure TIcs465c_meter.Lock;
begin
  if FCriticalSection <> nil then
    FCriticalSection.Enter;
end;

procedure TIcs465c_meter.UnLock;
begin
  if FCriticalSection <> nil then
    FCriticalSection.Leave;
end;

function TIcs465c_meter.GetWeight: Double;
begin
  Result := 0;

   // if not readWeight then Exit;   // 读数据

  Lock;
  try
    Result := FTotal; //FWeight;
  finally
    UnLock;
  end;
end;

function TIcs465c_meter.GetTotal: Double;
begin
  Result := 0;

  //  if not readWeight then Exit;   // 读数据

  Lock;
  try
    Result := FTotal; //FWeight;
  finally
    UnLock;
  end;
end;

function TIcs465c_meter.GetSubTotal: Double;
begin
  Result := 0;

 //   if not readWeight then Exit;   // 读数据

  Lock;
  try
    Result := FSubTotal; //FWeight;
  finally
    UnLock;
  end;
end;

function TIcs465c_meter.GetBeltSpeed: Double;
begin
  Result := 0;

//  if not readWeight then Exit; // 读数据

  Lock;
  try
    Result := FBeltSpeed; //FWeight;
  finally
    UnLock;
  end;
end;

function TIcs465c_meter.GetLineSpeed: Double;
begin
  Result := 0;

//    if not readWeight then Exit;   // 读数据

  Lock;
  try
    Result := FLineSpeed; //FWeight;
  finally
    UnLock;
  end;
end;

function TIcs465c_meter.OpenCom(SerialPortDllFileName: string; PortId: Integer): Integer;
begin
  if FComPort = nil then
  begin
    FComPort := TComPort.Create(SerialPortDllFileName, ComId);
  end;
  Result := FComPort.OpenPort;
  FisOpened := True; //FComPort
end;

function TIcs465c_meter.CloseCom: Integer;
begin
  Result := 0;
  if FComPort <> nil then
  begin
    try
      Result := FComPort.ClosePort;
    finally
      try
        FComPort.Free;
      finally
        FComPort := nil;
      end;
    end;
  end;
  FisOpened := False;
end;

procedure TIcs465c_meter.SetParams(Baud: TBaudRate;
  StopBit: TStopBits;
  DataBit: TDataBits;
  Parity: TParityBits;
  FlowControl: TFlowControl);
begin
  if FComPort <> nil then
  begin
    FComPort.SetPortParams(Baud, StopBit, DataBit, Parity, FlowControl);
  end;
end;

procedure TIcs465c_meter.Start;
begin
    //if Terminated = True then
    //begin
  if Suspended then
    Resume;
    //Execute;
    //end;
end;

procedure TIcs465c_meter.Stop;
begin
  if not Suspended then
    Self.Suspend;
    //if not Terminated then
    //begin
    //    Terminate;
    //    WaitFor;
    // end;
//    Self.WaitFor;
end;
(*
function TIcs465c_meter.GetDecimalMultiply(StatusByteA: Byte): Double;
begin
    Result := 1.0;
end;

function TIcs465c_meter.TestIsGross(StatusByteB : Byte): Boolean;
begin
    Result := False;
end;

function TIcs465c_meter.GetSign(StatusByteB : Byte): Double;
begin
    Result := 1.0;
end;

function TIcs465c_meter.TestIsOverLoad(StatusByteB: Byte): Boolean;
begin
    Result := False;
end;
*)

procedure TIcs465c_meter.SetAddr(Address: Integer);
begin
  FAddr := Address and $FF;
end;

function TIcs465c_meter.GetDecimalPointFactor(DecimalCount: Byte): Double;
var
  decimal_point_pos: Integer;
begin
  decimal_point_pos := (DecimalCount and $FF);
  case decimal_point_pos of
    7: Result := 10000000;
    6: Result := 1000000;
    5: Result := 100000;
    4: Result := 10000;
    3: Result := 1000;
    2: Result := 100;
    1: Result := 10;
    0: Result := 1;
  else
    Result := 1.0;
  end;
end;

function TIcs465c_meter.GetWeightInternal(var buffer; Pos, size: Integer): Double;
type
  TArray = array[1..255] of Byte;
var
  Factor: Double;
  intTemp: Cardinal; //Integer;
begin
  if size = 5 then
  begin
    Factor := GetDecimalPointFactor(TArray(buffer)[Pos]);
    Inc(Pos);
  end
  else
    Factor := 1000000.0;
  intTemp := Cardinal(TArray(buffer)[pos])
    + ((Cardinal(TArray(buffer)[pos + 1]) shl 8) and $0000FF00)
    + ((Cardinal(TArray(buffer)[pos + 2]) shl 16) and $00FF0000)
    + ((Cardinal(TArray(buffer)[pos + 3]) shl 24) and $FF000000);
  Result := intTemp / Factor;
end;

procedure TIcs465c_meter.SendCommand;
var
  buffer: array[1..6] of Byte;
begin
  buffer[1] := (FAddr and $FF);
  buffer[2] := $AA;
  buffer[3] := $01;
  buffer[4] := $00;
  buffer[5] := $A4;
  buffer[6] := $00;
  if FComPort <> nil then
  begin
    try
      FComPort.WritePort(buffer, 5);
    except
            //
    end;
  end;
end;

function TIcs465c_meter.readWeight: Boolean;
const
  DataLength: Integer = 22;
  PackageLength: Integer = 22 + 5;
  PackageTailPos: Integer = 22 + 5;
  PackageReadLength: Integer = 2; //22+5-1;
var
  isSTX, {isCR,} isFound: Boolean;
  i, n, m, p, k: Integer;
  xorSum, intDataLength: Integer;
  buffer: array[1..255] of Byte;
    //decimal_point_factor : Double;
    //decimal_multiply  : Double;
    ///////
    //pBuffer : ^Byte;  // Pointer for byte
    //sign: Double;
    //aWeight, aTare : array[1..8] of Byte;
    //strWeight, strTare: String;
//    fltWeight, fltTare: Double;
begin
  Result := False;
//  FWeight := 0.0;
//  FTotal := 0.0;
//  FSubTotal := 0.0;
//  FFlow := 0.0;
//  FBeltSpeed := 0.0;
//  FLineSpeed := 0.0;

  if FComport = nil then Exit;

  FComport.ClearBuffer(1); // 清空串口对象接收缓冲区
    ////
  if FIsCommand then // 是否命令方式
  begin
    SendCommand;
    Sleep(100);
  end;

    //FComport.ClearBuffer(1);   // 清空串口对象接收缓冲区

  FillChar(buffer, 255, 0);
  isSTX := False;
    //isCR := False;
  isFound := False;
    //n := 1;
  p := 1;
  k := 0;
  while isSTX = False do // loop
  begin
        //pBuffer := @buffer[p];
        //n := FComport.ReadPort(pBuffer, 2);  // 前2字节
    n := FComport.ReadPort(Buffer, PackageReadLength); // 前2字节
    if n = 0 then
    begin
            //Exit;  // 没有读到数据
      sleep(100);
      Inc(k);
      if k < 5 then continue // 5次重试
      else break;
    end;
    xorSum := 0;
    if ((buffer[p] = FAddr) and (buffer[p + 1] = $AA)) then // 找头标志
    begin
      isSTX := True;
      xorSum := xorSum xor buffer[p]; // 计算较验
      xorSum := xorSum xor buffer[p + 1]; // 计算较验
      p := p + PackageReadLength; //+2;  // 第3字节开始
      while isFound = False do
      begin
        m := p - 1;
        while m < PackageLength do // loop
        begin
                    //pBuffer := @buffer[p];
                    //n := FComport.ReadPort(pBuffer, PackageLength-m);
          n := FComport.ReadPort(Buffer[p], PackageLength - m);
          if n = 0 then
          begin
            Exit; // 没有读到数据
          end;
          Inc(m, n);
          p := m + 1; // 缓冲区下一次写入位置
        end; // loop 读数
        k := p - PackageLength - 1; // 包头位置
        for i := 3 to (PackageLength - 1) do // 跳过包尾标志(较验值)
          xorSum := xorSum xor buffer[k + i]; // 计算较验和
        if buffer[k + PackageTailPos] = xorSum then // 找尾标志
        begin
          isFound := True;
          Break; // 找到数据
        end
        else
        begin
                    //n := p+m;
          isSTX := False;
          for i := 2 {p} to PackageLength {n} do
          begin
            if (buffer[i] = FAddr) and (buffer[i + 1] = $AA) then // 找头标志
            begin
              p := i;
              m := PackageLength - i + 1; //n - i - 1;
              isSTX := True;
              isFound := False;
              break; // 继续读取后续数据
            end;
          end;
          if isSTX then // 找到第2个标头
          begin
                        //memmove  将剩余部分前移
            for i := 1 to m do
            begin
              buffer[i] := buffer[p + i - 1];
            end;

            fillChar(buffer[m + 1], PackageLength - m, 0); // 清空

            p := m + 1;
            continue; // 重新读取
          end
          else
          begin
            Exit; // 读到的数据无用
          end;
        end;
      end; // isFound
    end;
  end; // isSTX

  if isFound then
  begin
    if buffer[3] <> $01 then // 功能号是否正确
    begin
      FTotal := 0;
      FSubtotal := 0;
      FFlow := 0;
      FBeltSpeed := 0;
      FLineSpeed := 0;
      Exit; // 数据错误
    end;

    intDataLength := Integer(buffer[4]);
        //if intDataLength <> 22 then   // 数据长度不对
        //begin
        //    Exit;  // 数据错误
        //end;
        //decimal_multiply := GetDecimalMultiply(buffer[2]);

        //FIsGross
        //////////

    Lock; // 上锁
    try
      FTotal := GetWeightInternal(buffer, 5, 5);
      FSubtotal := GetWeightInternal(buffer, 10, 5);
      FFlow := GetWeightInternal(buffer, 15, 4);
      FBeltSpeed := GetWeightInternal(buffer, 19, 4);
      FLineSpeed := GetWeightInternal(buffer, 23, 4);
    finally
      Unlock;
    end;

        //Weight := FloatToStr(fltWeight);    // 毛重或净重
        //Tare   := FloatToStr(fltTare);      // 皮重
    Result := True;
  end
  else
  begin
    FTotal := 0;
    FSubtotal := 0;
    FFlow := 0;
    FBeltSpeed := 0;
    FLineSpeed := 0;
  end;

end;

function TIcs465c_meter.IsOverLoad: Boolean;
begin
  Result := False;
end;

function TIcs465c_meter.IsGross: Boolean;
begin
  Result := False;
end;

procedure TIcs465c_meter.ShowData;
begin
  if FCallback <> nil then
  begin
    try
      TWeighingCallBack(FCallback)
        (FTotal, FSubtotal, isGross, isOverLoad);
    except
            { none }
    end;
  end;
end;

procedure TIcs465c_meter.Execute;
var
//    Weight, Tare: Double;
  isOK: Boolean;
begin
  while not Terminated do
  begin
    isOK := readWeight;
    if isOK then
    begin
      if FCallback <> nil then
      begin
        Lock;
        try
          ShowData;
        finally
          Unlock;
        end;
      end;
    end;
    sleep(300);
  end;
end;

end.

