unit Common;

interface
uses
  ActiveX, SysUtils,Classes;
const
  XorKey: array[0..7] of Byte = ($B2, $09, $AA, $55, $93, $6D, $84, $47); //字符串加密用

type
  StringArray = array of string;

function CreateOnlyId: string; //产生唯一序列号
function Split(const Source: string; ASplit: string): StringArray; //分割字符串
function SplitToStrings(const Source: string; ASplit: string): TStrings;
function Append(Source:TStrings;ASplit: string):string;       //将TStrings用 ASplit连接
function EncrypKey(Str: string): string; //加密函数
function UncrypKey(Str: string): string; //解密函数
function BooleanToStr(Value: Boolean): string;
function rePlace(const s, source, dest: string): string;  //将  source 中的 s 替换为 dest
function StrToUniCode(text: string): string;
function UnicodeToStr(text: string): string;
function encode(text:String):string;
function decode(text:String):string;

implementation

function encode(text:String):string;
var
  i, len: Integer;
  cur: Integer;
  t: string;
  ws: WideString;
begin
  Result := '';
  ws := text;
  len := Length(ws);
  i := 1;
  while i <= len do
  begin
    cur := Ord(ws[i]);
    if cur > 255 then
    begin
        FmtStr(t, '%4.4X', [cur]);
        Result := Result + '^' + LowerCase(t);
    end
    else
    begin
        if ((cur < 48) or ((cur > 57) and (cur < 65)) or ( (cur > 90) and (cur < 97)) or (cur > 122)) then
        begin
          FmtStr(t, '%2.2X', [cur]);
          Result := Result + '~' + LowerCase(t);
        end
        else
        begin
           Result := Result + ws[i];
        end;

    end;
    Inc(i);
  end;
end;

function decode(text:String):string;
var
  I, Len: Integer;
  temp:string;
begin
  I := 1;
  text := StringReplace(text, #13, '', [rfReplaceAll]);
  text := StringReplace(text, #10, '', [rfReplaceAll]);
  Len := Length(text);
  while I <= Len do
  begin
    temp := text[I];
    if temp = '~' then
    begin
        Result := Result + Widechar(StrToInt('$' + copy(text, I+1, 2)));
        I := I + 3;
    end
    else if temp = '^' then
    begin
       Result := Result + Widechar(StrToInt('$' + copy(text, I+1, 4)));
       I := I + 5;
    end
    else
    begin
       Result := Result + temp;
       Inc(I);
    end;
  end;
  Result := Trim(Result);
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
  Result := 'U';
  while I <= len do
  begin
    cur := Ord(ws[I]);
    FmtStr(t, '%4.4X', [cur]);
    Result := Result + t;
    if I <> len then
      Result := Result + ' U';
    Inc(I);
  end;
end;

//恢复

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

function BooleanToStr(Value: Boolean): string;
begin
  if Value then
    Result := 'true'
  else
    Result := 'false';
end;

function CreateOnlyId: string; //产生唯一序列号
var
  AGuid: TGuid;
begin
  if CoCreateGuid(AGuid) = s_OK then begin
    Result := Split(Split(GUIDToString(AGuid), '{')[1], '}')[0];
  end;
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

function SplitToStrings(const Source: string; ASplit: string): TStrings;
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
    if Roles.IndexOf(rArray[I]) = -1 then Roles.Add(rArray[I]);
  end;
  Result := Roles;
end;
function Append(Source:TStrings;ASplit: string):string;
var
  I:Integer;
  Re:String;
begin
  Re := '';
  for I := 0 to Source.Count - 2 do
  begin
     if Trim(Source[I]) <> '' then
     Re := Re +  Source[I]+ASplit;
  end;
  if (Source.Count > 0) and (Trim(Source[Source.Count - 1]) <> '') then   Re := Re + Source[Source.Count - 1];
  Result := Re;
end;
function EncrypKey(Str: string): string; //字符加密函数   这是用的一个异或加密
var
  i, j: Integer;
begin
  Result := '';
  j := 0;
  for i := 1 to Length(Str) do
  begin
    Result := Result + IntToHex(Byte(Str[i]) xor XorKey[j], 2);
    j := (j + 1) mod 8;
  end;
end;

function UncrypKey(Str: string): string; //字符解密函数
var
  i, j: Integer;
begin
  Result := '';
  j := 0;
  for i := 1 to Length(Str) div 2 do
  begin
    Result := Result + Char(StrToInt('$' + Copy(Str, i * 2 - 1, 2)) xor XorKey[j]);
    j := (j + 1) mod 8;
  end;
end;

function rePlace(const s, source, dest: string): string;
var
  ss, ssource, sdest: string;
begin
  ss := s;
  ssource := source;
  sdest := dest;
  while pos(ssource, ss) <> 0 do
  begin
    delete(ss, pos(ssource, ss), length(ssource));
    insert(sdest, ss, pos(ssource, ss));
  end;
  result := ss;
end;



end.

