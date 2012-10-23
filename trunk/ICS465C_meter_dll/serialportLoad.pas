unit serialportLoad;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes;

type
  TBaudRate = (brCustom, br110, br300, br600, br1200, br2400, br4800, br9600, br14400,
    br19200, br38400, br56000, br57600, br115200, br128000, br256000);
  TStopBits = (sbOneStopBit, sbOne5StopBits, sbTwoStopBits);
  TDataBits = (dbFive, dbSix, dbSeven, dbEight);
  TParityBits = (prNone, prOdd, prEven, prMark, prSpace);
  TFlowControl = (fcHardware, fcSoftware, fcNone, fcCustom);

  TOpenPort = function(ComId: Integer): Integer; stdcall;
  TClosePort = function(ComId: Integer): Integer; stdcall;
  TSetPortParams = procedure(ComId: Integer;
    Baud: TBaudRate;
    StopBits: TStopBits;
    DataBits: TDataBits;
    Parity: TParityBits;
    FlowControl: TFlowControl); stdcall;
  TReadPort = function(ComId: Integer; var Buffer; Size: Integer): Integer; stdcall;
  TWritePort = procedure(ComId: Integer; const Buffer; Size: Integer); stdcall;
  TClearBuffer = procedure(ComId: Integer; bufferFlag: Integer); stdcall;

  TComport = class(TObject)
    FComId: Integer;
    FDllFileName: string;
  private
    DllHandle: HMODULE;
  protected
    function InitDll: Integer;
  public
    property ComId: Integer read FComId;
    property DllFileName: string read FDllFileName;

    function OpenPort: Integer;
    function ClosePort: Integer;
    procedure SetPortParams(Baud: TBaudRate;
      StopBits: TStopBits;
      DataBits: TDataBits;
      Parity: TParityBits;
      FlowControl: TFlowControl);
    function ReadPort(var Buffer; Size: Integer): Integer;
    procedure WritePort(const Buffer; Size: Integer);
    procedure ClearBuffer(bufferFlag: Integer);

    constructor Create(DllFileName: string; ComId: Integer); overload;
    destructor Destroy; override;

  published
        { none }
  end;

implementation

constructor TComport.Create(DllFileName: string; ComId: Integer);
begin
  FComId := ComId;
  if DllFileName <> '' then
    FDllFileName := DllFileName
  else
    FDllFileName := 'serialport.dll'; // 默认文件名
  DllHandle := 0;
  InitDll;
end;

destructor TComport.Destroy;
begin
  if DllHandle >= 32 then
  begin
    FreeLibrary(DllHandle);
  end;
end;

function TComport.InitDll: Integer;
begin
  DllHandle := LoadLibrary(PChar(DllFileName));
  Result := 0;
end;

function TComport.OpenPort: Integer;
var
  FOpenPort: Pointer; //TOpenPort;
begin
  Result := -1;
  if DllHandle >= 32 then
  begin
    FOpenPort := GetProcAddress(DllHandle, PChar('OpenPort'));
    if Integer(FOpenPort) > 0 then
    begin
      Result := TOpenPort(FOpenPort)(FComId);
    end;
  end;
end;

function TComport.ClosePort: Integer;
var
  FClosePort: Pointer; //TClosePort;
begin
  Result := -1;
  if DllHandle > 32 then
  begin
    FClosePort := GetProcAddress(DllHandle, PChar('ClosePort'));
    if Integer(FClosePort) > 0 then
    begin
      Result := TClosePort(FClosePort)(FComId);
    end;
  end;
end;

procedure TComport.SetPortParams(Baud: TBaudRate;
  StopBits: TStopBits;
  DataBits: TDataBits;
  Parity: TParityBits;
  FlowControl: TFlowControl);
var
  FSetPortParams: Pointer; //TSetPortParams;
begin
  if DllHandle > 32 then
  begin
    FSetPortParams := GetProcAddress(DllHandle, PChar('SetPortParams'));
    if Integer(FSetPortParams) > 0 then
    begin
      TSetPortParams(FSetPortParams)(FComId, Baud, StopBits,
        DataBits, Parity, FlowControl);
    end;
  end;
end;

function TComport.ReadPort(var Buffer; Size: Integer): Integer;
var
  FReadPort: Pointer; //TReadPort;
begin
  Result := -1;
  if DllHandle > 32 then
  begin
    FReadPort := GetProcAddress(DllHandle, PChar('ReadPort'));
    if Integer(FReadPort) > 0 then
    begin
      Result := TReadPort(FReadPort)(FComId, Buffer, Size);
    end;
  end;
end;

procedure TComport.WritePort(const Buffer; Size: Integer);
var
  FWritePort: Pointer; //TWritePort;
begin
  if DllHandle > 32 then
  begin
    FWritePort := GetProcAddress(DllHandle, PChar('WritePort'));
    if Integer(FWritePort) > 0 then
    begin
      TWritePort(FWritePort)(FComId, Buffer, Size);
    end;
  end;
end;

procedure TComport.ClearBuffer(bufferFlag: Integer);
var
  FClearBuffer: Pointer; //TClearBuffer;
begin
  if DllHandle > 32 then
  begin
    FClearBuffer := GetProcAddress(DllHandle, PChar('ClearBuffer'));
    if Integer(FClearBuffer) > 0 then
    begin
      TClearBuffer(FClearBuffer)(FComId, bufferFlag);
    end;
  end;
end;

end.

