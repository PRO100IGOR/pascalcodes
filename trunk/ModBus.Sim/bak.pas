unit Unit2;

interface
uses
  SysUtils;
type
{CRCУ��}
TDataByte = array of byte;

const
  CRCHi: array [0..255] of byte =
  (
   $00, $C1, $81, $40, $01, $C0, $80, $41, $01, $C0, $80, $41, $00,
   $C1, $81, $40, $01, $C0, $80, $41, $00, $C1, $81, $40, $00, $C1,
   $81, $40, $01, $C0, $80, $41, $01, $C0, $80, $41, $00, $C1, $81,
$40, $00, $C1, $81, $40, $01, $C0, $80, $41, $00, $C1, $81, $40,
$01, $C0, $80, $41, $01, $C0, $80, $41, $00, $C1, $81, $40, $01,
$C0, $80, $41, $00, $C1, $81, $40, $00, $C1, $81, $40, $01, $C0,
$80, $41, $00, $C1, $81, $40, $01, $C0, $80, $41, $01, $C0, $80,
$41, $00, $C1, $81, $40, $00, $C1, $81, $40, $01, $C0, $80, $41,
$01, $C0, $80, $41, $00, $C1, $81, $40, $01, $C0, $80, $41, $00,
$C1, $81, $40, $00, $C1, $81, $40, $01, $C0, $80, $41, $01, $C0,
$80, $41, $00, $C1, $81, $40, $00, $C1, $81, $40, $01, $C0, $80,
$41, $00, $C1, $81, $40, $01, $C0, $80, $41, $01, $C0, $80, $41,
$00, $C1, $81, $40, $00, $C1, $81, $40, $01, $C0, $80, $41, $01,
$C0, $80, $41, $00, $C1, $81, $40, $01, $C0, $80, $41, $00, $C1,
$81, $40, $00, $C1, $81, $40, $01, $C0, $80, $41, $00, $C1, $81,
$40, $01, $C0, $80, $41, $01, $C0, $80, $41, $00, $C1, $81, $40,
$01, $C0, $80, $41, $00, $C1, $81, $40, $00, $C1, $81, $40, $01,
$C0, $80, $41, $01, $C0, $80, $41, $00, $C1, $81, $40, $00, $C1,
$81, $40, $01, $C0, $80, $41, $00, $C1, $81, $40, $01, $C0, $80,
$41, $01, $C0, $80, $41, $00, $C1, $81, $40
) ;

CRCLo: array [0..255] of  byte =
(
$00, $C0, $C1, $01, $C3, $03, $02, $C2, $C6, $06, $07, $C7, $05,
$C5, $C4, $04, $CC, $0C, $0D, $CD, $0F, $CF, $CE, $0E, $0A, $CA,
$CB, $0B, $C9, $09, $08, $C8, $D8, $18, $19, $D9, $1B, $DB, $DA,
$1A, $1E, $DE, $DF, $1F, $DD, $1D, $1C, $DC, $14, $D4, $D5, $15,
$D7, $17, $16, $D6, $D2, $12, $13, $D3, $11, $D1, $D0, $10, $F0,
$30, $31, $F1, $33, $F3, $F2, $32, $36, $F6, $F7, $37, $F5, $35,
$34, $F4, $3C, $FC, $FD, $3D, $FF, $3F, $3E, $FE, $FA, $3A, $3B,
$FB, $39, $F9, $F8, $38, $28, $E8, $E9, $29, $EB, $2B, $2A, $EA,
$EE, $2E, $2F, $EF, $2D, $ED, $EC, $2C, $E4, $24, $25, $E5, $27,
$E7, $E6, $26, $22, $E2, $E3, $23, $E1, $21, $20, $E0, $A0, $60,
$61, $A1, $63, $A3, $A2, $62, $66, $A6, $A7, $67, $A5, $65, $64,
$A4, $6C, $AC, $AD, $6D, $AF, $6F, $6E, $AE, $AA, $6A, $6B, $AB,
$69, $A9, $A8, $68, $78, $B8, $B9, $79, $BB, $7B, $7A, $BA, $BE,
$7E, $7F, $BF, $7D, $BD, $BC, $7C, $B4, $74, $75, $B5, $77, $B7,
$B6, $76, $72, $B2, $B3, $73, $B1, $71, $70, $B0, $50, $90, $91,
$51, $93, $53, $52, $92, $96, $56, $57, $97, $55, $95, $94, $54,
$9C, $5C, $5D, $9D, $5F, $9F, $9E, $5E, $5A, $9A, $9B, $5B, $99,
$59, $58, $98, $88, $48, $49, $89, $4B, $8B, $8A, $4A, $4E, $8E,
$8F, $4F, $8D, $4D, $4C, $8C, $44, $84, $85, $45, $87, $47, $46,
$86, $82, $42, $43, $83, $41, $81, $80, $40
);


implementation


function crc16(var dataaddress :byte; datalength: byte): word;
var
  hi: byte;
  lo: byte;
  i: byte;
  index: byte;
  datadd: pbytearray;
begin
    hi := $FF;
    lo := $FF;
    datadd := @dataaddress;
    i := 0;
    while (datalength > 0) do
    begin
      index := (hi xor PChar(datadd^));
      i := i + 1;
      hi := lo xor crchi[index];
      lo := crclo[index];
     datalength := datalength - 1;
    end;
    crc16 := hi shl 8 or lo;
end;


function ModBusCRC(Data: string): string; //����modbus CRC����
var
  CRC16Lo, CRC16Hi, CL, CH, UseHi, UseLo: Dword;
  i, index: integer;
begin
  CRC16Lo := $FF; //CRC16LoΪCRC�Ĵ�����8λ
  CRC16Hi := $FF; //CRC16HiΪCRC�Ĵ�����8λ
  CL := $01;
  CH := $A0; //  A001 H ��CRC��16����ʽ����
  for i := 1 to Length(Data) do
  begin
    CRC16Lo := CRC16Lo xor ord(Data); //ÿһ��������CRC�Ĵ������
    for index := 0 to 7 do
    begin
      UseHi := CRC16Hi;
      UseLo := CRC16Lo;
      CRC16Hi := CRC16Hi shr 1;
      CRC16Lo := CRC16Lo shr 1; //����һλ
      if ((UseHi and $1) = $1) then //�����λ�ֽ����һλ��1�Ļ�
        CRC16Lo := CRC16Lo or $80; //��λ�ֽ����ƺ�ǰ�油1
      if ((UseLo and $1) = $1) then //���LSB Ϊ1���������ʽ�������
      begin
        CRC16Hi := CRC16Hi xor CH;
        CRC16Lo := CRC16Lo xor CL;
      end;
    end;
  end;

  Result := IntToHex(CRC16Lo, 2) + IntToHex(CRC16Hi, 2);
end;


function StrToHexStr(const S:string):string;
//�ַ���ת����16�����ַ���
var
  I:Integer;
begin
  for I:=1 to Length(S) do
  begin
    if I=1 then
      Result:=IntToHex(Ord(S[1]),2)
    else Result:=Result+' '+IntToHex(Ord(S[I]),2);
  end;
end;

function HexStrToStr(const S:string):string;
//16�����ַ���ת�����ַ���
var
  t:Integer;
  ts:string;
  M,Code:Integer;
begin
  t:=1;
  Result:='';
  while t<=Length(S) do
  begin
    while not (S[t] in ['0'..'9','A'..'F','a'..'f']) do
      inc(t);
    if (t+1>Length(S))or(not (S[t+1] in ['0'..'9','A'..'F','a'..'f'])) then
      ts:='$'+S[t]
    else
      ts:='$'+S[t]+S[t+1];
    Val(ts,M,Code);
    if Code=0 then
      Result:=Result+Chr(M);
    inc(t,2);
  end;
end;

function Hex2Dec(Hexs: string): string;
//ʮ������ת����ʮ����
var
  i,j: integer;
  res,base: LongWord;
begin
  res := 0;
  for i:=1 to Length(Hexs) do
  begin
    base := 1;
    for j:=1 to Length(Hexs)-i do
      base := base * 16;
    case Hexs of
      '0'..'9': res := res + (Ord(Hexs) - Ord('0')) * base;
      'a'..'f': res := res + (Ord(Hexs) - Ord('a') + 10) * base;
      'A'..'F': res := res + (Ord(Hexs) - Ord('A') + 10) * base;
    end;
  end;
  result := inttostr(res);
end;

function BcdToHex(Hexstr: string): string;
//BCDת����ʮ������
var
  i: integer;
  returnstr : string;
begin
  result := '0';
  try
    returnstr := IntToHex(StrToInt64(Hexstr),4);
    for i := 1 to length(returnstr) do
    begin
      if returnstr[1] = '0' then
      delete(returnstr,1,1);
    end;
    Result := returnstr;
  except
  end;
end;

function DecToHex(DecS : string):string;
//ʮ����ת����ʮ������
var i : integer;
begin
    i := StrToInt(DecS);
    Restult := IntToHex(i,2);
end;


//ʹ��Comport�ؼ�����modbusͨ�ŵļ�����:
//
//procedure TMainForm.btnReadBuadRateClick(Sender: TObject);   //������
//var
//  str,str1,BaudRate1 :string;
//  i : integer;
//  obj : PAsync;
//begin
//     i :=0;
//     if (edAdd.text ='')and (not CheckBox1.checked) then
//          showmessage('������װ�õ�ַ')
//     else
//     begin
//      if  checkBox1.checked then //�㲥��ʽ
//          Address := '00'
//      else
//        Address := DecToHex(edAdd.text);
//        if not(address ='error' ) then  //�жϵ�ַ�Ƿ񳬳�0~255��ַ��Χ
//        begin
//          str := Address+'03'+'00'+'02'+'00'+'01';  //��У����ֵ
//          str := str+ ModBusCRC(HexStrToStr(str));//���͵��ַ���(������ַ,������,����,CRC)
//
//          InitAsync(obj);
//           try
//           ComPort.WriteStrAsync(hexstrToStr(str),obj);
//           SendMemo.Text := SendMemo.text+ str+' ';
//           i := i+1;
//           if (i>30000) then
//           begin
//             ComPort.AbortAllAsync ;
//             showmessage('ͨ��ʧ��,�����·���!');
//           end;
//           ComPort.WaitForAsync(obj);
//           sleep(500);//���������ȴ�500MS����֤���ݵ������ԣ�
//           ComPort.ReadStr(Str, 20);//��ȡ���ջ�����20���ֽ�����
//           comport.ClearBuffer(true,true);//����������ͽ�������׼����һ��ͨ��ͨ�ţ�
//           finally
//           DoneAsync(obj);
//           end;
//
//           RXMemo.text :=RXMemo.text + StrToHexstr(str);
//
//          if (str = '') then
//           showmessage('û���յ����ݣ����ط�!')
//           else
//       begin
////         if(not CRCCheck(str)) then
////          showmessage('�������ݴ���!')
////          else
////           begin
//            for I:=1 to Length(str) do//�����յ�������������
//              begin
//                str1:=IntToHex(Ord(Str),2) ;
//                if i= 5 then BaudRate1:= str1;//����ֵ�ĵ�λ�ֽ�
//              end;
//            end;
//            edit1.text := Hex2Dec(BaudRate1);
//            edBaudRate.text := BaudRateInterv(Hex2Dec(BaudRate1));
//          end;
////          end;
//          str := '';
//        end;
//
//end;

end.
