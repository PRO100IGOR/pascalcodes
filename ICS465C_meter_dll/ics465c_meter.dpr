library ics465c_meter;

{ Important note about DLL memory management: ShareMem must be the
  first unit in your library's USES clause AND your project's (select
  Project-View Source) USES clause if your DLL exports any procedures or
  functions that pass strings as parameters or function results. This
  applies to all strings passed to and from your DLL--even those that
  are nested in records and classes. ShareMem is the interface unit to
  the BORLNDMM.DLL shared memory manager, which must be deployed along
  with your DLL. To avoid using BORLNDMM.DLL, pass string information
  using PChar or ShortString parameters. }

uses
  Windows,
  SysUtils,
  Classes,
  ics465cThread in 'ics465cThread.pas',
  serialportLoad in 'serialportLoad.pas';

const

    Author: String = 'solly';

var
    Port : Integer;

    TICS465C : TIcs465c_meter;

{$R *.res}

function  OpenPort(SerialPortDllFileName: PChar; PortId: Integer): Integer; stdcall;
var
    StrSerialPortDllFileName : String;
begin
    Port := PortId;
    Result := 0;
    
    if TICS465C = nil then
    begin
        TICS465C := TIcs465c_meter.Create(PortId);
    end;
    if TICS465C <> nil then
    begin
        //SetParams(br2400);
        StrSerialPortDllFileName := String(SerialPortDllFileName);
        Result := TICS465C.OpenCom(StrSerialPortDllFileName, PortId);
        TICS465C.SetParams(br9600, sbOneStopBit, dbEight, prNone, fcNone);
    end;
end;

function  ClosePort: Integer; stdcall;
begin
    Result := 0;
    if TICS465C <> nil then
    begin
        TICS465C.Stop;
        Result := TICS465C.CloseCom;
        try
            TICS465C.Free;
        finally
            TICS465C := nil;
        end;
    end;
end;

procedure SetAddress(Addr: Integer); stdcall;
begin
    ///
    if TICS465C <> nil then
    begin
        TICS465C.Address := Addr;
    end;
end;

procedure SetParams(Baud: TBaudRate); stdcall;
begin
    ///
    if TICS465C <> nil then
    begin
        TICS465C.SetParams(Baud, sbOneStopBit, dbEight, prNone, fcNone);
    end;
end;

procedure SetAllParams(Baud: TBaudRate;
                      StopBits: TStopBits;
                      DataBits: TDataBits;
                      Parity: TParityBits;
                      FlowControl: TFlowControl); stdcall;
begin
    ///
    if TICS465C <> nil then
    begin
        //TICS465C.SetParams(Baud, sbOneStopBit, dbEight, prNone, fcNone);
        TICS465C.SetParams(Baud, StopBits, DataBits, Parity, FlowControl);
    end;
end;

procedure SetCallBack(CallBack: Pointer); stdcall;
begin
    if TICS465C <> nil then
    begin
        TICS465C.SetCallBack(CallBack);
    end;
end;

function GetWeight: Double; stdcall;
begin
    if TICS465C <> nil then
        Result := TICS465C.GetWeight
    else
        Result := 0;
end;

function GetTotal: Double; stdcall;
begin
    if TICS465C <> nil then
        Result := TICS465C.GetTotal
    else
        Result := 0;
end;

function GetSubTotal: Double; stdcall;
begin
    if TICS465C <> nil then
        Result := TICS465C.GetSubTotal
    else
        Result := 0;
end;

function GetBeltSpeed: Double; stdcall;
begin
    if TICS465C <> nil then
        Result := TICS465C.GetBeltSpeed
    else
        Result := 0;
end;

function GetLineSpeed: Double; stdcall;
begin
    if TICS465C <> nil then
        Result := TICS465C.GetLineSpeed
    else
        Result := 0;
end;

procedure Start; stdcall;
begin
    if TICS465C <> nil then
    begin
        TICS465C.Start;
    end;
end;

procedure Stop; stdcall;
begin
    if TICS465C <> nil then
    begin
        TICS465C.Stop;
    end;
end;

procedure LibExit(Reason: Integer);
begin
    if Reason = DLL_PROCESS_DETACH then
    begin
        if TICS465C <> nil then
        begin
            try
                ClosePort;
            except
                TICS465C := nil;
            end;
        end;
    end;
    //if Pointer(SaveDllProc) = 0 then Exit;
    //SaveDllProc(Reason);    // call saved entry point procedure
end;

exports
    OpenPort,
    ClosePort,
    SetAddress,
    SetParams,
    SetAllParams,
    SetCallBack,
    GetWeight,
    GetTotal,
    GetSubTotal,
    GetBeltSpeed,
    GetLineSpeed,
    Start,
    Stop;

begin
    TICS465C := nil; //Comport.Create('serialport.dll', 1);
    //SaveDllProc := @DllProc;  // 保存 DLL 的原有退出例程入口
    DllProc := @LibExit;      // 安装新的 DLL 退出例程入口
end.
