unit ModFace;

interface
uses
   Classes,SPComm,Windows,SysUtils,StrUtils;
const
  //* CRC 高位字节值表 */
  CRCTableHi:array[0..255] of DWORD = (
       $00, $C1, $81, $40,$01, $C0, $80, $41,$01, $C0, $80, $41,$00, $C1, $81, $40,
       $01, $C0, $80, $41,$00, $C1, $81, $40,$00, $C1, $81, $40,$01, $C0, $80, $41,
       $01, $C0, $80, $41,$00, $C1, $81, $40,$00, $C1, $81, $40,$01, $C0, $80, $41,
       $00, $C1, $81, $40,$01, $C0, $80, $41,$01, $C0, $80, $41,$00, $C1, $81, $40,
       $01, $C0, $80, $41,$00, $C1, $81, $40,$00, $C1, $81, $40,$01, $C0, $80, $41,
       $00, $C1, $81, $40,$01, $C0, $80, $41,$01, $C0, $80, $41,$00, $C1, $81, $40,
       $00, $C1, $81, $40,$01, $C0, $80, $41,$01, $C0, $80, $41,$00, $C1, $81, $40,
       $01, $C0, $80, $41,$00, $C1, $81, $40,$00, $C1, $81, $40,$01, $C0, $80, $41,
       $01, $C0, $80, $41,$00, $C1, $81, $40,$00, $C1, $81, $40,$01, $C0, $80, $41,
       $00, $C1, $81, $40,$01, $C0, $80, $41,$01, $C0, $80, $41,$00, $C1, $81, $40,
       $00, $C1, $81, $40,$01, $C0, $80, $41,$01, $C0, $80, $41,$00, $C1, $81, $40,
       $01, $C0, $80, $41,$00, $C1, $81, $40,$00, $C1, $81, $40,$01, $C0, $80, $41,
       $00, $C1, $81, $40,$01, $C0, $80, $41,$01, $C0, $80, $41,$00, $C1, $81, $40,
       $01, $C0, $80, $41,$00, $C1, $81, $40,$00, $C1, $81, $40,$01, $C0, $80, $41,
       $01, $C0, $80, $41,$00, $C1, $81, $40,$00, $C1, $81, $40,$01, $C0, $80, $41,
       $00, $C1, $81, $40,$01, $C0, $80, $41,$01, $C0, $80, $41,$00, $C1, $81, $40
  );
  //* CRC低位字节值表*/
  CRCTableLo:array[0..255] of DWORD  = (
      $00, $C0, $C1, $01,$C3, $03, $02, $C2,$C6, $06, $07, $C7,$05, $C5, $C4, $04,
      $CC, $0C, $0D, $CD,$0F, $CF, $CE, $0E,$0A, $CA, $CB, $0B,$C9, $09, $08, $C8,
      $D8, $18, $19, $D9,$1B, $DB, $DA, $1A,$1E, $DE, $DF, $1F,$DD, $1D, $1C, $DC,
      $14, $D4, $D5, $15,$D7, $17, $16, $D6,$D2, $12, $13, $D3,$11, $D1, $D0, $10,
      $F0, $30, $31, $F1,$33, $F3, $F2, $32,$36, $F6, $F7, $37,$F5, $35, $34, $F4,
      $3C, $FC, $FD, $3D,$FF, $3F, $3E, $FE,$FA, $3A, $3B, $FB,$39, $F9, $F8, $38,
      $28, $E8, $E9, $29,$EB, $2B, $2A, $EA,$EE, $2E, $2F, $EF,$2D, $ED, $EC, $2C,
      $E4, $24, $25, $E5,$27, $E7, $E6, $26,$22, $E2, $E3, $23,$E1, $21, $20, $E0,
      $A0, $60, $61, $A1,$63, $A3, $A2, $62,$66, $A6, $A7, $67,$A5, $65, $64, $A4,
      $6C, $AC, $AD, $6D,$AF, $6F, $6E, $AE,$AA, $6A, $6B, $AB,$69, $A9, $A8, $68,
      $78, $B8, $B9, $79,$BB, $7B, $7A, $BA,$BE, $7E, $7F, $BF,$7D, $BD, $BC, $7C,
      $B4, $74, $75, $B5,$77, $B7, $B6, $76,$72, $B2, $B3, $73,$B1, $71, $70, $B0,
      $50, $90, $91, $51,$93, $53, $52, $92,$96, $56, $57, $97,$55, $95, $94, $54,
      $9C, $5C, $5D, $9D,$5F, $9F, $9E, $5E,$5A, $9A, $9B, $5B,$99, $59, $58, $98,
      $88, $48, $49, $89,$4B, $8B, $8A, $4A,$4E, $8E, $8F, $4F,$8D, $4D, $4C, $8C,
      $44, $84, $85, $45,$87, $47, $46, $86,$82, $42, $43, $83,$41, $81, $80, $40
  );
type

//    TParity = ( None, Odd, Even, Mark, Space );
//    TStopBits = ( _1, _1_5, _2 );
//    TByteSize = ( _5, _6, _7, _8 );


   TModCallBack = procedure(Comm:string;MacAddress,Address,Value:Integer);stdcall;
   TModBus = class(TTHread)
   private
      Address  : array of array of Byte;
      Values   : array of array of Byte;
      Commands : array of array of Byte;
      SpComm     : TComm;
      IsWaiting  : Boolean; //等待回应标记,暂无等待超时
      ActiveIndex: Integer; //活动下标
      MyMacAddress : Integer;  //从机地址
      CommName   :  string;
      FCallback: Pointer;
      WaitTimes : Integer; //等待次数上限，超时时间为ReadTime*WaitTimes
      ReadTime : Integer; // 读取间隔
      HasWaitTimes:Integer; //等待次数累计
      procedure CustomReceiveData(Sender: TObject; Buffer: Pointer; BufferLength: Word);
      function ModBusCRC16(Data: string;var CRC16Hi,CRC16Lo:DWORD): string;
      procedure ModCrc(Command:array of Byte;var CRC16Hi,CRC16Lo:DWORD);
   protected
      procedure getData;
      procedure Execute;override;
   public
      //初始化 串口名、波特、奇偶检验、数据位、停止位、起始地址、结束地址、从机地址
      function  Init(Comm:string;BaudRate,Parity,ByteSize,StopBits,BeginAddress,EndAddress,MacAddress,PReadTime,PWaitTimes:Integer):Boolean;
      procedure Start;
      procedure Stop;
      procedure SetCallBack(CallBack: Pointer);
      function  CloseComm:Boolean;
   end;


   TModBuses = class(TPersistent)
   private
    function GetItems(Key: string): TModBus;
    function GetCount: Integer;
   public
    Keys: TStrings;
    Values: array of TModBus;
    property Items[Key: string]: TModBus read GetItems; default;
    property Count: Integer read GetCount;
    function Add(Key: string; Value: TModBus): Integer;
    procedure clear;
    function Remove(Key: string): Integer;
    constructor Create; overload;
  end;

implementation


function  TModBus.Init(Comm:string;BaudRate,Parity,ByteSize,StopBits,BeginAddress,EndAddress,MacAddress,PReadTime,PWaitTimes:Integer):Boolean;
var
  I,Index,Count:Integer;
  CRC16Hi,CRC16Lo:DWORD;
begin
     SpComm := TComm.Create(nil);
     SpComm.CommName :=   Comm;
     SpComm.BaudRate :=   BaudRate;
     SpComm.Parity   :=   TParity(Parity);
     SpComm.ByteSize :=   TByteSize(ByteSize);
     SpComm.StopBits :=   TStopBits(StopBits);
     SpComm.OnReceiveData := CustomReceiveData;
     try
        SpComm.StartComm;
        Result := True;
     except
        Result := False;
        Exit;
     end;
     CommName := Comm;
     MyMacAddress := MacAddress;
     Index := 0;
     Count := 0;
     SetLength(Address,1);
     SetLength(Commands,1);
     SetLength(Values,1);
     SetLength(Commands[0],8);
     Commands[0][0] := MacAddress;
     Commands[0][1] := $03;
     Commands[0][2] := $00;
     Commands[0][3] := BeginAddress - 1;
     Commands[0][4] := $00;

     for I := BeginAddress to EndAddress do
     begin
         if Length(Address[Index]) = 100 then
         begin
             Commands[Index][5] := 100;
             ModCrc(Commands[Index],CRC16Lo,CRC16Hi);
             Commands[Index][6] := CRC16Lo;
             Commands[Index][7] := CRC16Hi;

             Inc(Index);
             SetLength(Address,Index+1);
             SetLength(Values,Index+1);
             SetLength(Commands,Index+1);
             SetLength(Commands[Index],8);
             Commands[Index][0] := MacAddress;
             Commands[Index][1] := $03;
             Commands[Index][2] := $00;
             Commands[Index][3] := I - 1;
             Commands[Index][4] := $00;

             Count := 0;
         end;
         Inc(Count);
         SetLength(Address[Index],Length(Address[Index]) + 1);
         SetLength(Values[Index],Length(Values[Index]) + 1);
         Address[Index][Length(Address[Index]) - 1] := I;
     end;
     if Commands[Index][5] = $00 then
     begin
         Commands[Index][5] := Count;
         ModCrc(Commands[Index],CRC16Lo,CRC16Hi);
         Commands[Index][6] := CRC16Lo;
         Commands[Index][7] := CRC16Hi;
     end;

     IsWaiting := False;
     ActiveIndex := 0;
     ReadTime := PReadTime;
     WaitTimes := PWaitTimes;
     HasWaitTimes := 0;
end;
procedure TModBus.Start;
begin
  if Suspended then
     Resume;
end;
procedure TModBus.Stop;
begin
  if not Suspended then
     Suspend;
end;
procedure TModBus.Execute;
begin
   while not Terminated do
   begin
        getData;
        sleep(ReadTime);
   end;
end;
procedure TModBus.getData;
begin
    if not IsWaiting then
    begin
         if ActiveIndex >= Length(Address)  then
            ActiveIndex := 0;
         HasWaitTimes := 0;
         IsWaiting := True;
         SpComm.WriteCommData(PChar(Commands[ActiveIndex]),8);
    end
    else
    begin
        Inc(HasWaitTimes);
        if HasWaitTimes > WaitTimes then
        begin
           Inc(ActiveIndex);
           IsWaiting := False;
        end;
    end;
end;
function  TModBus.ModBusCRC16(Data:String;var CRC16Hi,CRC16Lo:DWORD) : string;
var
  uIndex:Integer;
  Data1:String;
begin
  CRC16Lo := $FF; //CRC16Lo为CRC寄存器低8位
  CRC16Hi := $FF; //CRC16Hi为CRC寄存器高8位
  Data1:=Trim(Data);
  while Length(Data1)>0 do
  begin
    uIndex := CRC16Hi xor (StrToInt('$'+(Data1[1])+(Data1[2])));
    CRC16Hi := CRC16Lo xor CRCTableHi[uIndex];
    CRC16Lo := CRCTableLo[uIndex];
    Data1:=Trim(MidStr(Data1,3,Length(Data1)));
  end;
  Result := IntToHex(CRC16Hi,2) + IntToHex(CRC16Lo,2);
end;
procedure TModBus.ModCrc(Command:array of Byte;var CRC16Hi,CRC16Lo:DWORD);
var
  I:Integer;
  Str:string;
begin
  Str := '';
  for I := 0 to 5 do
  begin
     Str := Str + ' ' + IntToHex(Command[I],2);
  end;
  ModBusCRC16(Str,CRC16Hi,CRC16Lo);
end;
procedure TModBus.CustomReceiveData(Sender: TObject; Buffer: Pointer; BufferLength: Word);
var
   BufferArr : array of Byte;
   I,Index :Integer;
begin
   if BufferLength < 5 then
   begin
      Inc(ActiveIndex);
      IsWaiting := False;
      Exit;
   end;
   SetLength(BufferArr, BufferLength);
   Move(buffer^, PChar(@BufferArr[0])^, BufferLength);

   if (BufferArr[0] <> MyMacAddress) or (BufferArr[1] <> $03) then
   begin
      Inc(ActiveIndex);
      IsWaiting := False;
      Exit;
   end;

   if BufferArr[2] / 2 <> Length(Address[ActiveIndex]) then
   begin
      Inc(ActiveIndex);
      IsWaiting := False;
      Exit;
   end;
   Index := 0;
   for I := 4 to BufferLength - 3 do
   begin
       if I mod 2 = 0 then
       begin
         if BufferArr[I] <> Values[ActiveIndex][Index] then
         begin
              Values[ActiveIndex][Index] := BufferArr[I];
              if FCallback <> nil then
              begin
                try
                  TModCallBack(FCallback)(CommName, MyMacAddress,Address[ActiveIndex][Index] , BufferArr[I]);
                except
                end;
              end;
         end;
         Inc(Index);
       end;
   end;
   Inc(ActiveIndex);
   IsWaiting := False;
end;
procedure TModBus.SetCallBack(CallBack: Pointer);
begin
    FCallback := CallBack;
end;
function  TModBus.CloseComm:Boolean;
begin
    try
        SpComm.StopComm;
        SpComm.Free;
        SpComm := nil;
        Result := False;
    except
        Result := True;
    end;
end;


constructor TModBuses.Create;
begin
  Keys := TStringList.Create;
  SetLength(Values, 0);
end;
procedure   TModBuses.clear;
begin
  SetLength(Values, 0);
  Keys.Clear;
end;
function    TModBuses.GetItems(Key: string): TModBus;
var
  KeyIndex: Integer;
begin
  KeyIndex := Keys.IndexOf(Key);
  if KeyIndex <> -1 then
    Result := Values[KeyIndex]
  else
    Result := nil;
end;
function    TModBuses.Add(Key: string; Value: TModBus): Integer;
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
function    TModBuses.GetCount: Integer;
begin
  Result := Keys.Count;
end;
function    TModBuses.Remove(Key: string): Integer;
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

end.
