unit ModBusLoad;

interface
uses
    Windows;
type
//    TParity = ( None, Odd, Even, Mark, Space );
//    TStopBits = ( _1, _1_5, _2 );
//    TByteSize = ( _5, _6, _7, _8 );
    TOpen        = function(Comm:string;BaudRate,Parity,ByteSize,StopBits,BeginAddress,EndAddress,MacAddress,ReadTime,WaitTimes:Integer):Integer;stdcall;
    TClose       = function:Integer;stdcall;
    TSetCallBack = function(CallBack: Pointer):Integer;stdcall;
    TCloseByComm = function(Comm:string):Integer;stdcall;
    TCallBack    = procedure(Comm:string;MacAddress,Address,Value:Integer) of object;

    TModLoad = class(TObject)
    private
      FillName:string;
      PDllName: HMODULE;
      POpen  : Pointer;
      PClose : Pointer;
      PSetCallBack : Pointer;
      PCloseByComm : Pointer;
      FCallback: TCallBack;
    public
      constructor Create(PFileName:string;PCallBack:TCallBack;var IsSuccess:Boolean); overload;
      destructor  Destroy; override;
      function    Open(Comm:string;BaudRate,Parity,ByteSize,StopBits,BeginAddress,EndAddress,MacAddress,ReadTime,WaitTimes:Integer):Boolean;
      function    Close:Boolean;
      function    CloseByComm(Comm:string):Boolean;
    end;
var
    ModLoad :TModLoad;
implementation

procedure   FunCallBack(Comm:string;MacAddress,Address,Value:Integer);stdcall;
begin
    ModLoad.FCallback(Comm,MacAddress,Address,Value);
end;
constructor TModLoad.Create(PFileName:string;PCallBack:TCallBack;var IsSuccess:Boolean);
begin
    FillName := PFileName;
    PDllName := LoadLibrary(PChar(FillName));
    IsSuccess := False;
    if PDllName > 32 then
    begin
        POpen := GetProcAddress(PDllName, PChar('Open'));
        PClose := GetProcAddress(PDllName, PChar('Close'));
        PSetCallBack := GetProcAddress(PDllName, PChar('SetCallBack'));
        PCloseByComm := GetProcAddress(PDllName, PChar('CloseByComm'));
        FCallback := PCallBack;
        IsSuccess := True;
    end;
end;
destructor  TModLoad.Destroy;
begin
    if PDllName > 32 then
    begin
       Close; 
       FreeLibrary(PDllName);
       PDllName := 0;
    end;
end;
function    TModLoad.Open(Comm:string;BaudRate,Parity,ByteSize,StopBits,BeginAddress,EndAddress,MacAddress,ReadTime,WaitTimes:Integer):Boolean;
begin
        Result := False;
        if PDllName > 32 then
        begin
            Result := TOpen(POpen)(Comm,BaudRate,Parity,ByteSize,StopBits,BeginAddress,EndAddress,MacAddress,ReadTime,WaitTimes) = 1;
            if Result then
               Result := TSetCallBack(PSetCallBack)(@FunCallBack) = 1;
        end;
//      Result := MM.Open(Comm,BaudRate,Parity,ByteSize,StopBits,BeginAddress,EndAddress,MacAddress,ReadTime,WaitTimes) = 1;
end;
function    TModLoad.Close:Boolean;
begin
      Result := False;
      if PDllName > 32 then
         Result := TClose(PClose) = 1;
end;
function    TModLoad.CloseByComm(Comm:string):Boolean;
begin
      Result := False;
      if PDllName > 32 then
         Result := TCloseByComm(PCloseByComm)(Comm) = 1;
end;

end.
