{******************************************************************************}
{                       CnPack For Delphi/C++Builder                           }
{                     �й����Լ��Ŀ���Դ�������������                         }
{                   (C)Copyright 2001-2011 CnPack ������                       }
{                   ------------------------------------                       }
{                                                                              }
{            ���������ǿ�Դ��������������������� CnPack �ķ���Э������        }
{        �ĺ����·�����һ����                                                }
{                                                                              }
{            ������һ��������Ŀ����ϣ�������ã���û���κε���������û��        }
{        �ʺ��ض�Ŀ�Ķ������ĵ���������ϸ���������� CnPack ����Э�顣        }
{                                                                              }
{            ��Ӧ���Ѿ��Ϳ�����һ���յ�һ�� CnPack ����Э��ĸ��������        }
{        ��û�У��ɷ������ǵ���վ��                                            }
{                                                                              }
{            ��վ��ַ��http://www.cnpack.org                                   }
{            �����ʼ���master@cnpack.org                                       }
{                                                                              }
{******************************************************************************}

unit CnWizDfm6To5;
{ |<PRE>
================================================================================
* ������ƣ�CnPack IDE ר�Ұ�
* ��Ԫ���ƣ�ת���߰汾�� DFM �ļ��� D5 ֧�ֵĸ�ʽ
* ��Ԫ���ߣ��ܾ��� (zjy@cnpack.org)
* ��    ע��
* ����ƽ̨��PWin2000Pro + Delphi 5.01
* ���ݲ��ԣ�PWin9X/2000/XP + Delphi 5/6/7 + C++Builder 5/6
* �� �� �����õ�Ԫ�е��ַ���֧�ֱ��ػ�����ʽ
* ��Ԫ��ʶ��$Id: CnWizDfm6To5.pas 763 2011-02-07 14:18:23Z liuxiao@cnpack.org $
* �޸ļ�¼��2002.12.02 V1.1
*               �����Զ������ļ���ʽ��֧��
*           2002.11.17 V1.0
*               ������Ԫ
================================================================================
|</PRE>}

interface

{$I CnWizards.inc}

{$IFNDEF COMPILER5}
  'Error: This unit can only be used in Delphi/C++ Builder 5!'
{$ENDIF}

uses
  Classes, Consts, SysUtils, TypInfo;

type
  TDFMConvertResult = (crSucc, crOpenError, crSaveError, crInvalidFormat);

function DFM6To5(const FileName: string): TDFMConvertResult;
{* �� Delphi6 ���Ժ�汾�Ĵ����ļ�ת��Ϊ���� Delphi5 ���ļ���
   ֧���ı��Ͷ����Ƹ�ʽ�� DFM �ļ�}

implementation

//------------------------------------------------------------------------------
// ���´��븴���� Delphi5 �� Classes ��Ԫ��������ȡ�� WString ת��Ϊ String
//------------------------------------------------------------------------------

type
  TWriterHack = class(TWriter); // Ϊ���� TWriter ��������������

procedure MyObjectTextToBinary(Input, Output: TStream);
var
  SaveSeparator: Char;
  Parser: TParser;
  Writer: TWriterHack;

  function ConvertOrderModifier: Integer;
  begin
    Result := -1;
    if Parser.Token = '[' then
    begin
      Parser.NextToken;
      Parser.CheckToken(toInteger);
      Result := Parser.TokenInt;
      Parser.NextToken;
      Parser.CheckToken(']');
      Parser.NextToken;
    end;
  end;

  procedure ConvertHeader(IsInherited, IsInline: Boolean);
  var
    ClassName, ObjectName: string;
    Flags: TFilerFlags;
    Position: Integer;
  begin
    Parser.CheckToken(toSymbol);
    ClassName := Parser.TokenString;
    ObjectName := '';
    if Parser.NextToken = ':' then
    begin
      Parser.NextToken;
      Parser.CheckToken(toSymbol);
      ObjectName := ClassName;
      ClassName := Parser.TokenString;
      Parser.NextToken;
    end;
    Flags := [];
    Position := ConvertOrderModifier;
    if IsInherited then
      Include(Flags, ffInherited);
    if IsInline then
      Include(Flags, ffInline);
    if Position >= 0 then
      Include(Flags, ffChildPos);
    Writer.WritePrefix(Flags, Position);
    Writer.WriteStr(ClassName);
    Writer.WriteStr(ObjectName);
  end;

  procedure ConvertProperty; forward;

  procedure ConvertValue;
  var
    Order: Integer;

    function CombineString: string;
    begin
      Result := Parser.TokenString;
      while Parser.NextToken = '+' do
      begin
        Parser.NextToken;
        // Parser.CheckToken(toString);
        if not (Parser.Token in [toString, toWString]) then
          Parser.Error(SStringExpected);        
        Result := Result + Parser.TokenString;
      end;
    end;

    function CombineWideString: WideString;
    begin
      Result := Parser.TokenWideString;
      while Parser.NextToken = '+' do
      begin
        Parser.NextToken;
        // Parser.CheckToken(toWString);
        if not (Parser.Token in [toString, toWString]) then
          Parser.Error(SStringExpected);
        Result := Result + Parser.TokenWideString;
      end;
    end;

  begin
    if Parser.Token = toString then
      Writer.WriteString(CombineString)
    else if Parser.Token = toWString then
      // Writer.WriteWideString(CombineWideString)
      Writer.WriteString(CombineWideString) // �� WString ����Ϊ String �����Լ��� Delphi5
    else
    begin
      case Parser.Token of
        toSymbol:
          Writer.WriteIdent(Parser.TokenComponentIdent);
        toInteger:
          Writer.WriteInteger(Parser.TokenInt);
        toFloat:
          begin
            case Parser.FloatType of
              's', 'S': Writer.WriteSingle(Parser.TokenFloat);
              'c', 'C': Writer.WriteCurrency(Parser.TokenFloat / 10000);
              'd', 'D': Writer.WriteDate(Parser.TokenFloat);
            else
              Writer.WriteFloat(Parser.TokenFloat);
            end;
          end;
        '[':
          begin
            Parser.NextToken;
            Writer.WriteValue(vaSet);
            if Parser.Token <> ']' then
              while True do
              begin
                if Parser.Token <> toInteger then
                  Parser.CheckToken(toSymbol);
                Writer.WriteStr(Parser.TokenString);
                if Parser.NextToken = ']' then Break;
                Parser.CheckToken(',');
                Parser.NextToken;
              end;
            Writer.WriteStr('');
          end;
        '(':
          begin
            Parser.NextToken;
            Writer.WriteListBegin;
            while Parser.Token <> ')' do ConvertValue;
            Writer.WriteListEnd;
          end;
        '{':
          Writer.WriteBinary(Parser.HexToBinary);
        '<':
          begin
            Parser.NextToken;
            Writer.WriteValue(vaCollection);
            while Parser.Token <> '>' do
            begin
              Parser.CheckTokenSymbol('item');
              Parser.NextToken;
              Order := ConvertOrderModifier;
              if Order <> -1 then Writer.WriteInteger(Order);
              Writer.WriteListBegin;
              while not Parser.TokenSymbolIs('end') do ConvertProperty;
              Writer.WriteListEnd;
              Parser.NextToken;
            end;
            Writer.WriteListEnd;
          end;
      else
        Parser.Error('Error property');
      end;
      Parser.NextToken;
    end;
  end;

  procedure ConvertProperty;
  var
    PropName: string;
  begin
    Parser.CheckToken(toSymbol);
    PropName := Parser.TokenString;
    Parser.NextToken;
    while Parser.Token = '.' do
    begin
      Parser.NextToken;
      Parser.CheckToken(toSymbol);
      PropName := PropName + '.' + Parser.TokenString;
      Parser.NextToken;
    end;
    Writer.WriteStr(PropName);
    Parser.CheckToken('=');
    Parser.NextToken;
    ConvertValue;
  end;

  procedure ConvertObject;
  var
    InheritedObject: Boolean;
    InlineObject: Boolean;
  begin
    InheritedObject := False;
    InlineObject := False;
    if Parser.TokenSymbolIs('INHERITED') then
      InheritedObject := True
    else if Parser.TokenSymbolIs('INLINE') then
      InlineObject := True
    else
      Parser.CheckTokenSymbol('OBJECT');
    Parser.NextToken;
    ConvertHeader(InheritedObject, InlineObject);
    while not Parser.TokenSymbolIs('END') and
      not Parser.TokenSymbolIs('OBJECT') and
      not Parser.TokenSymbolIs('INHERITED') and
      not Parser.TokenSymbolIs('INLINE') do
      ConvertProperty;
    Writer.WriteListEnd;
    while not Parser.TokenSymbolIs('END') do ConvertObject;
    Writer.WriteListEnd;
    Parser.NextToken;
  end;

begin
  Parser := TParser.Create(Input);
  SaveSeparator := DecimalSeparator;
  DecimalSeparator := '.';
  try
    Writer := TWriterHack.Create(Output, 4096);
    try
      Writer.WriteSignature;
      ConvertObject;
    finally
      Writer.Free;
    end;
  finally
    DecimalSeparator := SaveSeparator;
    Parser.Free;
  end;
end;

//------------------------------------------------------------------------------
// ���´����޸��� Delphi7 �� Classes��System ��Ԫ���ṩ�� WString��UTF8 ��֧��
//------------------------------------------------------------------------------

const
  sLineBreak = #13#10;

type
  TValueType = (vaNull, vaList, vaInt8, vaInt16, vaInt32, vaExtended,
    vaString, vaIdent, vaFalse, vaTrue, vaBinary, vaSet, vaLString,
    vaNil, vaCollection, vaSingle, vaCurrency, vaDate, vaWString,
    vaInt64, vaUTF8String);

{ Binary to text conversion }

type
  UTF8String = type string;
  PUTF8String = ^UTF8String;

function Utf8ToUnicode(Dest: PWideChar; MaxDestChars: Cardinal; Source: PChar; SourceBytes: Cardinal): Cardinal;
var
  i, Count: Cardinal;
  c: Byte;
  wc: Cardinal;
begin
  if Source = nil then
  begin
    Result := 0;
    Exit;
  end;
  Result := Cardinal(-1);
  Count := 0;
  i := 0;
  if Dest <> nil then
  begin
    while (i < SourceBytes) and (Count < MaxDestChars) do
    begin
      wc := Cardinal(Source[i]);
      Inc(i);
      if (wc and $80) <> 0 then
      begin
        if i >= SourceBytes then Exit;          // incomplete multibyte char
        wc := wc and $3F;
        if (wc and $20) <> 0 then
        begin
          c := Byte(Source[i]);
          Inc(i);
          if (c and $C0) <> $80 then Exit;      // malformed trail byte or out of range char
          if i >= SourceBytes then Exit;        // incomplete multibyte char
          wc := (wc shl 6) or (c and $3F);
        end;
        c := Byte(Source[i]);
        Inc(i);
        if (c and $C0) <> $80 then Exit;       // malformed trail byte

        Dest[Count] := WideChar((wc shl 6) or (c and $3F));
      end
      else
        Dest[Count] := WideChar(wc);
      Inc(Count);
    end;
    if Count >= MaxDestChars then Count := MaxDestChars-1;
    Dest[Count] := #0;
  end
  else
  begin
    while (i < SourceBytes) do
    begin
      c := Byte(Source[i]);
      Inc(i);
      if (c and $80) <> 0 then
      begin
        if i >= SourceBytes then Exit;          // incomplete multibyte char
        c := c and $3F;
        if (c and $20) <> 0 then
        begin
          c := Byte(Source[i]);
          Inc(i);
          if (c and $C0) <> $80 then Exit;      // malformed trail byte or out of range char
          if i >= SourceBytes then Exit;        // incomplete multibyte char
        end;
        c := Byte(Source[i]);
        Inc(i);
        if (c and $C0) <> $80 then Exit;       // malformed trail byte
      end;
      Inc(Count);
    end;
  end;
  Result := Count + 1;
end;

function Utf8Decode(const S: UTF8String): WideString;
var
  L: Integer;
  Temp: WideString;
begin
  Result := '';
  if S = '' then Exit;
  SetLength(Temp, Length(S));

  L := Utf8ToUnicode(PWideChar(Temp), Length(Temp)+1, PChar(S), Length(S));
  if L > 0 then
    SetLength(Temp, L-1)
  else
    Temp := '';
  Result := Temp;
end;

procedure ReadError(Ident: PResStringRec);
begin
  raise EReadError.CreateRes(Ident);
end;

procedure PropValueError;
begin
  ReadError(@SInvalidPropertyValue);
end;

function ReadWideString(Reader: TReader): WideString;
var
  L: Integer;
  Temp: UTF8String;
begin
  if TValueType(Reader.NextValue) in [vaString, vaLString] then
    Result := Reader.ReadString
  else
  begin
    L := 0;
    case TValueType(Reader.ReadValue) of
      vaWString:
        begin
          Reader.Read(L, SizeOf(Integer));
          SetLength(Result, L);
          Reader.Read(Pointer(Result)^, L * 2);
        end;
      vaUTF8String:
        begin
          Reader.Read(L, SizeOf(Integer));
          SetLength(Temp, L);
          Reader.Read(Pointer(Temp)^, L);
          Result := Utf8Decode(Temp);
        end;
    else
      PropValueError;
    end;
  end;
end;

procedure MyObjectBinaryToText(Input, Output: TStream);
var
  NestingLevel: Integer;
  SaveSeparator: Char;
  Reader: TReader;
  Writer: TWriter;
  ObjectName, PropName: string;

  procedure WriteIndent;
  const
    Blanks: array[0..1] of Char = '  ';
  var
    I: Integer;
  begin
    for I := 1 to NestingLevel do Writer.Write(Blanks, SizeOf(Blanks));
  end;

  procedure WriteStr(const S: string);
  begin
    Writer.Write(S[1], Length(S));
  end;

  procedure NewLine;
  begin
    WriteStr(sLineBreak);
    WriteIndent;
  end;

  procedure ConvertValue; forward;

  procedure ConvertHeader;
  var
    ClassName: string;
    Flags: TFilerFlags;
    Position: Integer;
  begin
    Reader.ReadPrefix(Flags, Position);
    ClassName := Reader.ReadStr;
    ObjectName := Reader.ReadStr;
    WriteIndent;
    if ffInherited in Flags then
      WriteStr('inherited ')
    else if ffInline in Flags then
      WriteStr('inline ')
    else
      WriteStr('object ');
    if ObjectName <> '' then
    begin
      WriteStr(ObjectName);
      WriteStr(': ');
    end;
    WriteStr(ClassName);
    if ffChildPos in Flags then
    begin
      WriteStr(' [');
      WriteStr(IntToStr(Position));
      WriteStr(']');
    end;

    if ObjectName = '' then
      ObjectName := ClassName;  // save for error reporting

    WriteStr(sLineBreak);
  end;

  procedure ConvertBinary;
  const
    BytesPerLine = 32;
  var
    MultiLine: Boolean;
    I: Integer;
    Count: Longint;
    Buffer: array[0..BytesPerLine - 1] of Char;
    Text: array[0..BytesPerLine * 2 - 1] of Char;
  begin
    Reader.ReadValue;
    WriteStr('{');
    Inc(NestingLevel);
    Reader.Read(Count, SizeOf(Count));
    MultiLine := Count >= BytesPerLine;
    while Count > 0 do
    begin
      if MultiLine then NewLine;
      if Count >= 32 then I := 32 else I := Count;
      Reader.Read(Buffer, I);
      BinToHex(Buffer, Text, I);
      Writer.Write(Text, I * 2);
      Dec(Count, I);
    end;
    Dec(NestingLevel);
    WriteStr('}');
  end;

  procedure ConvertProperty; forward;

  procedure ConvertValue;
  const
    LineLength = 64;
  var
    I, J, K, L: Integer;
    S: string;
    W: WideString;
    LineBreak: Boolean;
  begin
    case TValueType(Reader.NextValue) of
      vaList:
        begin
          Reader.ReadValue;
          WriteStr('(');
          Inc(NestingLevel);
          while not Reader.EndOfList do
          begin
            NewLine;
            ConvertValue;
          end;
          Reader.ReadListEnd;
          Dec(NestingLevel);
          WriteStr(')');
        end;
      vaInt8, vaInt16, vaInt32:
        WriteStr(IntToStr(Reader.ReadInteger));
      vaExtended:
        WriteStr(FloatToStrF(Reader.ReadFloat, ffFixed, 16, 18));
      vaSingle:
        WriteStr(FloatToStr(Reader.ReadSingle) + 's');
      vaCurrency:
        WriteStr(FloatToStr(Reader.ReadCurrency * 10000) + 'c');
      vaDate:
        WriteStr(FloatToStr(Reader.ReadDate) + 'd');
      // �˴�Ϊ�޸Ĺ��ķ������� Unicode �� AnsiString �ķ�ʽ������
      vaWString, vaUTF8String:
        begin
          W := ReadWideString(Reader);  // ʹ���޸��� D7 �ķ�����ȡ Unicode
          S := W;                       // ת��Ϊ AnsiString ����
          L := Length(S);
          if L = 0 then WriteStr('''''') else
          begin
            I := 1;
            Inc(NestingLevel);
            try
              if L > LineLength then NewLine;
              K := I;
              repeat
                LineBreak := False;
                if (S[I] >= ' ') and (S[I] <> '''') then
                begin
                  J := I;
                  repeat
                    Inc(I)
                  until (I > L) or (S[I] < ' ') or (S[I] = '''') or
                    ((I - K) >= LineLength);
                  if ((I - K) >= LineLength) then
                  begin
                    LIneBreak := True;
                    if ByteType(S, I) = mbTrailByte then Dec(I);
                  end;
                  WriteStr('''');
                  Writer.Write(S[J], I - J);
                  WriteStr('''');
                end else
                begin
                  WriteStr('#');
                  WriteStr(IntToStr(Ord(S[I])));
                  Inc(I);
                  if ((I - K) >= LineLength) then LineBreak := True;
                end;
                if LineBreak and (I <= L) then
                begin
                  WriteStr(' +');
                  NewLine;
                  K := I;
                end;
              until I > L;
            finally
              Dec(NestingLevel);
            end;
          end;
        end;
      vaString, vaLString:
        begin
          S := Reader.ReadString;
          L := Length(S);
          if L = 0 then WriteStr('''''') else
          begin
            I := 1;
            Inc(NestingLevel);
            try
              if L > LineLength then NewLine;
              K := I;
              repeat
                LineBreak := False;
                if (S[I] >= ' ') and (S[I] <> '''') then
                begin
                  J := I;
                  repeat
                    Inc(I)
                  until (I > L) or (S[I] < ' ') or (S[I] = '''') or
                    ((I - K) >= LineLength);
                  if ((I - K) >= LineLength) then
                  begin
                    LIneBreak := True;
                    if ByteType(S, I) = mbTrailByte then Dec(I);
                  end;
                  WriteStr('''');
                  Writer.Write(S[J], I - J);
                  WriteStr('''');
                end else
                begin
                  WriteStr('#');
                  WriteStr(IntToStr(Ord(S[I])));
                  Inc(I);
                  if ((I - K) >= LineLength) then LineBreak := True;
                end;
                if LineBreak and (I <= L) then
                begin
                  WriteStr(' +');
                  NewLine;
                  K := I;
                end;
              until I > L;
            finally
              Dec(NestingLevel);
            end;
          end;
        end;
      vaIdent, vaFalse, vaTrue, vaNil, vaNull:
        WriteStr(Reader.ReadIdent);
      vaBinary:
        ConvertBinary;
      vaSet:
        begin
          Reader.ReadValue;
          WriteStr('[');
          I := 0;
          while True do
          begin
            S := Reader.ReadStr;
            if S = '' then Break;
            if I > 0 then WriteStr(', ');
            WriteStr(S);
            Inc(I);
          end;
          WriteStr(']');
        end;
      vaCollection:
        begin
          Reader.ReadValue;
          WriteStr('<');
          Inc(NestingLevel);
          while not Reader.EndOfList do
          begin
            NewLine;
            WriteStr('item');
            if TValueType(Reader.NextValue) in [vaInt8, vaInt16, vaInt32] then
            begin
              WriteStr(' [');
              ConvertValue;
              WriteStr(']');
            end;
            WriteStr(sLineBreak);
            Reader.CheckValue(Classes.TValueType(vaList));
            Inc(NestingLevel);
            while not Reader.EndOfList do ConvertProperty;
            Reader.ReadListEnd;
            Dec(NestingLevel);
            WriteIndent;
            WriteStr('end');
          end;
          Reader.ReadListEnd;
          Dec(NestingLevel);
          WriteStr('>');
        end;
      vaInt64:
        WriteStr(IntToStr(Reader.ReadInt64));
    else
      raise EReadError.CreateResFmt(@sPropertyException,
        [ObjectName, DotSep, PropName, IntToStr(Ord(Reader.NextValue))]);
    end;
  end;

  procedure ConvertProperty;
  begin
    WriteIndent;
    PropName := Reader.ReadStr;  // save for error reporting
    WriteStr(PropName);
    WriteStr(' = ');
    ConvertValue;
    WriteStr(sLineBreak);
  end;

  procedure ConvertObject;
  begin
    ConvertHeader;
    Inc(NestingLevel);
    while not Reader.EndOfList do ConvertProperty;
    Reader.ReadListEnd;
    while not Reader.EndOfList do ConvertObject;
    Reader.ReadListEnd;
    Dec(NestingLevel);
    WriteIndent;
    WriteStr('end' + sLineBreak);
  end;

begin
  NestingLevel := 0;
  Reader := TReader.Create(Input, 4096);
  SaveSeparator := DecimalSeparator;
  DecimalSeparator := '.';
  try
    Writer := TWriter.Create(Output, 4096);
    try
      Reader.ReadSignature;
      ConvertObject;
    finally
      Writer.Free;
    end;
  finally
    DecimalSeparator := SaveSeparator;
    Reader.Free;
  end;
end;

procedure MyObjectResourceToText(Input, Output: TStream);
begin
  Input.ReadResHeader;
  MyObjectBinaryToText(Input, Output);
end;

//------------------------------------------------------------------------------
// �� Delphi6 ���Ժ�汾�Ĵ����ļ�ת��Ϊ Delphi5 ֧�ֵ��ļ�
//------------------------------------------------------------------------------

function DFM6To5(const FileName: string): TDFMConvertResult;
var
  InStrm, OutStrm: TMemoryStream;
  C: Char;
begin
  InStrm := nil;
  OutStrm := nil;
  Result := crInvalidFormat;
  try
    InStrm := TMemoryStream.Create;
    OutStrm := TMemoryStream.Create;
    try
      InStrm.LoadFromFile(FileName);
    except
      Result := crOpenError;
      Exit;
    end;
    if InStrm.Size > 0 then
    begin
      C := PChar(InStrm.Memory)^;
      if not (C in ['o','O','i','I',' ',#13,#11,#9]) then // ���ı���ʽ�� DFM
      begin
        try
          MyObjectResourceToText(InStrm, OutStrm); // ���޸ĺ�Ĺ��̽�������ת���ı�
        except
          Result := crInvalidFormat;
          Exit;
        end;
        try
          OutStrm.SaveToFile(FileName);
        except
          Result := crSaveError;
          Exit;
        end;
        Result := crSucc;
      end
      else
      begin
        try
          MyObjectTextToBinary(InStrm, OutStrm); // ���޸ĺ�Ĺ��̽��ı�ת���ɶ�������
          InStrm.Clear;
          OutStrm.Position := 0;
          ObjectBinaryToText(OutStrm, InStrm);   // ��Delphi�Լ��ķ������½���������ת�����ı�
        except
          Result := crInvalidFormat;
          Exit;
        end;
        try
          InStrm.SaveToFile(FileName);
        except
          Result := crSaveError;
          Exit;
        end;
        Result := crSucc;
      end;
    end;
  finally
    if InStrm <> nil then InStrm.Free;
    if OutStrm <> nil then OutStrm.Free;
  end;
end;

end.
