library ModBusDll;

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
  SysUtils,
  Classes,
  Windows,
  ModFace in 'ModFace.pas',
  SPCOMM in 'SPCOMM.PAS';

const
  Author : string = 'Magican';
var
  ModBuses : TModBuses;
{$R *.res}


function  Open(Comm:string;BaudRate,Parity,ByteSize,StopBits,BeginAddress,EndAddress,MacAddress,ReadTime,WaitTimes:Integer):Integer;stdcall;
var
  AModFace : TModBus;
begin
   Result := 0;
   if not Assigned(ModBuses) then
      ModBuses := TModBuses.Create;
   if not Assigned(ModBuses.Items[Comm]) then
   begin
       AModFace := TModBus.Create(True);
       if AModFace.Init(Comm,BaudRate,Parity,ByteSize,StopBits,BeginAddress,EndAddress,MacAddress,ReadTime,WaitTimes) then
       begin
          Result := 1;
          AModFace.Start;
          ModBuses.Add(Comm,AModFace);
       end
       else
          Result := 0;
   end;
end;
function  Close :Integer;stdcall;
var
  I:Integer;
begin
    Result := 1;
    if Assigned(ModBuses) then
    begin
       for I := 0 to ModBuses.Count - 1 do
       begin
           ModBuses.Values[I].Stop;
           if not ModBuses.Values[I].CloseComm then
              Result := 0;
           ModBuses.Values[I].Free;
           ModBuses.Values[I] := nil;
       end;
       ModBuses.clear;
    end;
end;
function  CloseByComm(Comm:string):Integer;stdcall;
var
  AModFace : TModBus;
begin
    Result := 1;
    if Assigned(ModBuses) then
    begin
         AModFace := ModBuses.Items[Comm];
         if Assigned(AModFace) then
         begin
           AModFace.Stop;
           if not AModFace.CloseComm then
              Result := 0;
           AModFace.Free;
           ModBuses.Remove(Comm);
         end;
    end;
end;
function  SetCallBack(CallBack: Pointer):Integer;stdcall;
var
  I:Integer;
begin
    Result := 0;
    if Assigned(ModBuses) then
    begin
       for I := 0 to ModBuses.Count - 1 do
       begin
           ModBuses.Values[I].SetCallBack(CallBack);
           Result := 1;
       end;
    end;
end;
procedure LibExit(Reason: Integer);
begin
    if Reason = DLL_PROCESS_DETACH then
    begin
        if Assigned(ModBuses) then
           Close;
    end;
end;


exports
    Open,
    Close,
    CloseByComm,
    SetCallBack;
begin
    ModBuses := nil;
    DllProc := @LibExit;
end.
