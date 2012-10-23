unit Common;

interface

uses
  SysUtils, ActiveX, Winsock, Classes;
const
  strEncryptCode : String = 'VZHLEPDQKYMGSOJX';
type
  StringArray = array of string;

function Split(const Source: string; ASplit: string): StringArray;

function SplitToStringList(const Source: string; ASplit: string): TStrings; overload;

function SplitToStringList(const Source: string; ASplit: string; Strings: TStrings): TStrings; overload;

function toArr(const Source: string): StringArray; //字符串变为一个数组

function toStringList(const Source: string): TStrings; //字符串变为一个数组

function StrToUniCode(text: string): string;

function UnicodeToStr(text: string): string;

procedure CompletStr(var text: string; Lengths: Integer); // 用0填充text为指定长度

function CheckNum(const V: string): Boolean; //验证是否是数子

function CreateOnlyId: string; //产生唯一序列号

function CompletWeight(text: string; LengthInt, LengthFloat: Integer): string; //格式化重量输出

function GetIPAddr: string; //获取ip地址

function FormatDouble(Source: Double; Format: string): Double; //四舍五入数字

function RandomStr(): string; //随机取得4位a到z之间字符串

function BooleanToStr(va: boolean): string;
function Encrypt(Source: string): string; //解密
function Decrypt(Source: string): string;    //加密
implementation

function Encrypt(Source: string): string;
var
  i, n, j: Integer;
  strTmp: string;
  chrTmp: Char;
begin
//    strEncryptCode := 'VZHLEPDQKYMGSOJX';

  Result := '';
  n := Length(Source);
  if (n <= 0) or (n >= 100) then Exit; // 限制

    // 生成2位长度
  if n < 10 then Result := '0' + IntToStr(n) // 长度
  else Result := IntToStr(n);

    // 生成 00+AABBCCDD....
  for i := 1 to n do
  begin
    chrTmp := Source[i];
    strTmp := IntToHex(Ord(ChrTmp), 2);
    Result := Result + strTmp;
  end;
  n := Length(Result);
  strTmp := Copy(Result, n, 1);
  Delete(Result, n, 1);
  Result := strTmp + Result; // 最后一个字符放到第一个字符
  strTmp := '';
    //
  for i := 1 to n do // 替换
  begin
    case Result[i] of
      '0'..'9':
        strTmp := strTmp + strEncryptCode[StrToInt(Result[i]) + 1];
      'A'..'F', 'a'..'f':
        begin
          j := Ord(UpperCase(Result[i])[1]) - 54; //(-55+1)//91;
          strTmp := strTmp + strEncryptCode[j];
        end;
    end;
  end;
  Result := strTmp;
end;

function Decrypt(Source: string): string;
var
  i, n, j, k: Integer;
  strTmp, strTmp1: string;
    //chrTmp: Char;
begin
  Result := '';
  n := Length(Source);
  if n <= 4 then Exit;

  j := -1;
  strTmp := '';
  for i := 1 to n do
  begin
    StrTmp := Source[i];
    j := Pos(strTmp, strEncryptCode) - 1;
    if j < 0 then break;
        //if j>9 then j := j + 54;

    Result := Result + IntToHex(j, 1);
  end;
  if j < 0 then // 出错
  begin
    Result := '';
    Exit;
  end;

  strTmp := Copy(Result, 1, 1);
  Delete(Result, 1, 1);
  Result := Result + strTmp;
  strTmp := Copy(Result, 1, 2);
  try
    k := StrToInt(strTmp);
  except
    Result := '';
    Exit;
  end;

  if k > ((n - 2) div 2) then // 较验长度
  begin
    Result := '';
    Exit;
  end;
  n := k;
  strTmp := '';
  for i := 1 to n do
  begin
    strTmp1 := Copy(Result, i * 2 + 1, 2);
    j := 0;
    for k := 1 to 2 do
    begin
      case strTmp1[k] of
        '0'..'9':
          j := j * 16 + StrToInt(strTmp1[k]);
        'A'..'F', 'a'..'f':
          begin
            j := j * 16 + Ord(UpperCase(strTmp1[k])[1]) - 55; //91
          end;
      end;
    end;
    strTmp := strTmp + Chr(j);
  end;
  Result := strTmp;
end;

function FormatDouble(Source: Double; Format: string): Double;
var
  Temp: string;
begin
  Temp := FormatFloat(Format, Source);
  Result := StrtoFloat(Temp);
end;

function Split(const Source: string; ASplit: string): StringArray;
var
  AStr: string;
  rArray: StringArray;
  I: Integer;
begin
  if Source = '' then
    Exit;
  AStr := Source;
  I := pos(ASplit, Source);
  Setlength(rArray, 0);
  while I <> 0 do
  begin
    Setlength(rArray, Length(rArray) + 1);
    rArray[Length(rArray) - 1] := copy(AStr, 0, I - 1);
    Delete(AStr, 1, I + Length(ASplit) - 1);
    I := pos(ASplit, AStr);
  end;
  Setlength(rArray, Length(rArray) + 1);
  rArray[Length(rArray) - 1] := AStr;
  Result := rArray;
end;

function SplitToStringList(const Source: string; ASplit: string): TStrings;
var
  rArray: StringArray;
  Roles: TStrings;
  I: Integer;
begin
  rArray := Split(Source, ASplit);
  Roles := TStringList.Create;
  for I := 0 to Length(rArray) - 1 do
  begin
    if rArray[I] = '' then Continue;
    if Roles.IndexOf(rArray[I]) = -1 then
      Roles.Add(rArray[I]);
  end;
  Result := Roles;
end;

function SplitToStringList(const Source: string; ASplit: string; Strings: TStrings): TStrings;
var
  rArray: StringArray;
  I: Integer;
begin
  rArray := Split(Source, ASplit);
  for I := 0 to Length(rArray) - 1 do
  begin
    Strings.Add(rArray[I]);
  end;
  Result := Strings;
end;

function StrToUniCode(text: string): string;
var
  I, len: Integer;
  cur: Integer;
  t: string;
  ws: WideString;
begin
  Result := '';
  ws := text;
  len := Length(ws);
  I := 1;
  Result := '\u';
  while I <= len do
  begin
    cur := Ord(ws[I]);
    FmtStr(t, '%4.4X', [cur]);
    Result := Result + t;
    if I <> len then
      Result := Result + '\u';
    Inc(I);
  end;
end;

// 恢复

function UnicodeToStr(text: string): string;
var
  I, len: Integer;
  ws: WideString;
begin
  ws := '';
  I := 1;
  len := Length(text);
  while I < len do
  begin
    ws := ws + Widechar(StrToInt('$' + copy(text, I, 4)));
    I := I + 4;
  end;
  Result := ws;
end;

procedure CompletStr(var text: string; Lengths: Integer); // 用0填充text为指定长度
var
  L, I: Integer;
begin
  L := Lengths - Length(text);
  for I := 0 to L - 1 do
  begin
    text := '0' + text;
  end;

end;

function CreateOnlyId: string; //产生唯一序列号
var
  AGuid: TGuid;
begin
  if CoCreateGuid(AGuid) = s_OK then begin
    Result := Split(Split(GUIDToString(AGuid), '{')[1], '}')[0];
  end;
end;

function CheckNum(const V: string): Boolean;
var
  Temp: Double;
begin
  Result := false;
  try
    Temp := StrtoFloat(V);
    Result := true;
  except

  end;

end;

function CompletWeight(text: string; LengthInt, LengthFloat: Integer): string; //格式化重量输出
var
  SA: StringArray;
  L, I: Integer;
begin
  SA := Split(text, '.');
  L := LengthInt - Length(SA[0]);

  text := SA[0];
  for I := 0 to L - 1 do
  begin
    text := '0' + text;
  end;

  text := text + '.';
  if Length(SA) = 2 then
  begin
    L := LengthFloat - Length(SA[1]);
    text := text + SA[1];
  end
  else
  begin
    L := LengthFloat;
  end;

  for I := 0 to L - 1 do
  begin
    text := text + '0';
  end;
  Result := text;
end;

function toArr(const Source: string): StringArray; //字符串变为一个数组
var
  rArray: StringArray;
  I: Integer;
begin
  for I := 1 to Length(Source) do
  begin
    SetLength(rArray, Length(rArray) + 1);
    rArray[Length(rArray) - 1] := Copy(Source, I, 1);
  end;
  Result := rArray;
end;
function toStringList(const Source: string): TStrings; //字符串变为一个数组
var
  a:TStrings;
  I:Integer;
begin
  a:=TStringList.Create;
  for I := 1 to Length(Source) do
  begin
     a.Add(Copy(Source, I, 1))
  end;
  Result := a;
end;
function GetIPAddr: string; //获取ip地址
type
  TaPInAddr = array[0..10] of PInAddr;
  PaPInAddr = ^TaPInAddr;
var
  phe: PHostEnt;
  pptr: PaPInAddr;
  Buffer: array[0..63] of char;
  I: Integer;
  GInitData: TWSADATA;
begin
  WSAStartup($101, GInitData);
  Result := '';
  GetHostName(Buffer, SizeOf(Buffer));
  phe := GetHostByName(buffer);
  if phe = nil then Exit;
  pptr := PaPInAddr(Phe^.h_addr_list);
  I := 0;
  while pptr^[I] <> nil do begin
    result := StrPas(inet_ntoa(pptr^[I]^));
    Inc(I);
  end;
  WSACleanup;
end;

function RandomStr(): string;
var
  PicName: string;
  I: Integer;
begin
  Randomize;
  for I := 1 to 4 do
    PicName := PicName + chr(97 + random(26));
  RandomStr := PicName;
end;

function BooleanToStr(va: boolean): string;
begin
  if va then Result := 'true'
  else Result := 'false';
end;

end.

