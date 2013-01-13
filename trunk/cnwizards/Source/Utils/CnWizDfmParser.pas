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

unit CnWizDfmParser;
{ |<PRE>
================================================================================
* ������ƣ�CnPack IDE ר�Ұ�
* ��Ԫ���ƣ����� DFM �ļ���Ϣ
* ��Ԫ���ߣ��ܾ��� (zjy@cnpack.org)
* ��    ע��
* ����ƽ̨��PWinXP SP2 + Delphi 7.1
* ���ݲ��ԣ�PWin9X/2000/XP + Delphi 5/6/7 + C++Builder 5/6
* �� �� �����õ�Ԫ�е��ַ���֧�ֱ��ػ�����ʽ
* ��Ԫ��ʶ��$Id: CnWizDfmParser.pas 763 2011-02-07 14:18:23Z liuxiao@cnpack.org $
* �޸ļ�¼��2005.03.23 V1.0
*               ������Ԫ
================================================================================
|</PRE>}

interface

{$I CnWizards.inc}

uses
  Windows, SysUtils, Classes, CnCommon,
{$IFDEF COMPILER6_UP}
  Variants, RTLConsts,
{$ELSE}
  Consts,
{$ENDIF}
  TypInfo;

type
  TDfmFormat = (dfUnknown, dfText, dfBinary);
  TDfmKind = (dkObject, dkInherited, dkInline);

  TDfmInfo = class(TPersistent)
  private
    FFormat: TDfmFormat;
    FKind: TDfmKind;
    FName: string;
    FFormClass: string;
    FCaption: string;
    FLeft: Integer;
    FTop: Integer;
    FWidth: Integer;
    FHeight: Integer;
  published
    property Top: Integer read FTop write FTop;
    property Width: Integer read FWidth write FWidth;
    property Name: string read FName write FName;
    property Left: Integer read FLeft write FLeft;
    property Kind: TDfmKind read FKind write FKind;
    property Height: Integer read FHeight write FHeight;
    property Format: TDfmFormat read FFormat write FFormat;
    property FormClass: string read FFormClass write FFormClass;
    property Caption: string read FCaption write FCaption;
  end;

const
  SDfmFormats: array[TDfmFormat] of string = ('Unknown', 'Text', 'Binary');
  SDfmKinds: array[TDfmKind] of string = ('Object', 'Inherited', 'Inline');

function ParseDfmStream(Stream: TStream; Info: TDfmInfo): Boolean;

function ParseDfmFile(const FileName: string; Info: TDfmInfo): Boolean;

implementation

const
  csPropCount = 5;

function ParseTextDfmStream(Stream: TStream; Info: TDfmInfo): Boolean;
var
  SaveSeparator: Char;
  Parser: TParser;
  PropCount: Integer;

  function ParseOrderModifier: Integer;
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

  procedure ParseHeader(IsInherited, IsInline: Boolean);
  begin
    Parser.CheckToken(toSymbol);
    Info.FormClass := Parser.TokenString;
    Info.Name := '';
    if Parser.NextToken = ':' then
    begin
      Parser.NextToken;
      Parser.CheckToken(toSymbol);
      Info.Name := Info.FormClass;
      Info.FormClass := Parser.TokenString;
      Parser.NextToken;
    end;
    ParseOrderModifier;
  end;

  procedure ParseProperty(IsForm: Boolean); forward;

  function ParseValue: Variant;
  
  {$IFNDEF COMPILER6_UP}
    function CombineString: string;
    begin
      Result := Parser.TokenString;
      while Parser.NextToken = '+' do
      begin
        Parser.NextToken;
        Parser.CheckToken(toString);
        Result := Result + Parser.TokenString;
      end;
    end;
  {$ENDIF}

    function CombineWideString: WideString;
    begin
      Result := Parser.TokenWideString;
      while Parser.NextToken = '+' do
      begin
        Parser.NextToken;
        if not CharInSet(Parser.Token, [toString, toWString]) then
          Parser.CheckToken(toString);
        Result := Result + Parser.TokenWideString;
      end;
    end;

  begin
    Result := Null;
  {$IFDEF COMPILER6_UP}
    if CharInSet(Parser.Token, [toString, toWString]) then
      Result := CombineWideString
  {$ELSE}
    if Parser.Token = toString then
      Result := CombineString
    else if Parser.Token = toWString then
      Result := CombineWideString
  {$ENDIF}
    else
    begin
      case Parser.Token of
        toSymbol:
          Result := Parser.TokenComponentIdent;
        toInteger:
        {$IFDEF COMPILER6_UP}
          Result := Parser.TokenInt;
        {$ELSE}
          Result := Integer(Parser.TokenInt);
        {$ENDIF}
        toFloat:
          Result := Parser.TokenFloat;
        '[':
          begin
            Parser.NextToken;
            if Parser.Token <> ']' then
              while True do
              begin
                if Parser.Token <> toInteger then
                  Parser.CheckToken(toSymbol);
                if Parser.NextToken = ']' then Break;
                Parser.CheckToken(',');
                Parser.NextToken;
              end;
          end;
        '(':
          begin
            Parser.NextToken;
            while Parser.Token <> ')' do ParseValue;
          end;
        '{':
          Parser.HexToBinary(Stream);
        '<':
          begin
            Parser.NextToken;
            while Parser.Token <> '>' do
            begin
              Parser.CheckTokenSymbol('item');
              Parser.NextToken;
              ParseOrderModifier;
              while not Parser.TokenSymbolIs('end') do ParseProperty(False);
              Parser.NextToken;
            end;
          end;
      else
        Parser.Error(SInvalidProperty);
      end;
      Parser.NextToken;
    end;
  end;

  procedure ParseProperty(IsForm: Boolean);
  var
    PropName: string;
    PropValue: Variant;
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

    Parser.CheckToken('=');
    Parser.NextToken;
    PropValue := ParseValue;

    if IsForm then
    begin
      Inc(PropCount);
      if SameText(PropName, 'Left') then
        Info.Left := PropValue
      else if SameText(PropName, 'Top') then
        Info.Top := PropValue
      else if SameText(PropName, 'Width') or SameText(PropName, 'ClientWidth') then
        Info.Width := PropValue
      else if SameText(PropName, 'Height') or SameText(PropName, 'ClientHeight') then
        Info.Height := PropValue
      else if SameText(PropName, 'Caption') then
        Info.Caption := PropValue
      else
        Dec(PropCount);
    end;
  end;

  procedure ParseObject;
  var
    InheritedObject: Boolean;
    InlineObject: Boolean;
  begin
    InheritedObject := False;
    InlineObject := False;
    if Parser.TokenSymbolIs('INHERITED') then
    begin
      InheritedObject := True;
      Info.Kind := dkInherited;
    end
    else if Parser.TokenSymbolIs('INLINE') then
    begin
      InlineObject := True;
      Info.Kind := dkInline;
    end
    else
    begin
      Parser.CheckTokenSymbol('OBJECT');
      Info.Kind := dkObject;
    end;
    Parser.NextToken;
    ParseHeader(InheritedObject, InlineObject);
    while (PropCount < csPropCount) and
      not Parser.TokenSymbolIs('END') and
      not Parser.TokenSymbolIs('OBJECT') and
      not Parser.TokenSymbolIs('INHERITED') and
      not Parser.TokenSymbolIs('INLINE') do
      ParseProperty(True);
  end;

begin
  try
    Parser := TParser.Create(Stream);
    SaveSeparator := DecimalSeparator;
    DecimalSeparator := '.';
    try
      PropCount := 0;
      ParseObject;
      Result := True;
    finally
      DecimalSeparator := SaveSeparator;
      Parser.Free;
    end;
  except
    Result := False;
  end;
end;

function ParseBinaryDfmStream(Stream: TStream; Info: TDfmInfo): Boolean;
var
  SaveSeparator: Char;
  Reader: TReader;
  PropName: string;
  PropCount: Integer;

  procedure ParseHeader;
  var
    FormClass: string;
    Flags: TFilerFlags;
    Position: Integer;
  begin
    Reader.ReadPrefix(Flags, Position);
    Info.FormClass := Reader.ReadStr;
    Info.Name := Reader.ReadStr;
    if Info.Name = '' then
      Info.Name := FormClass; 
  end;

  procedure ParseBinary;
  const
    BytesPerLine = 32;
  var
    I: Integer;
    Count: Longint;
    Buffer: array[0..BytesPerLine - 1] of Char;
  begin
    Reader.ReadValue;
    Reader.Read(Count, SizeOf(Count));
    while Count > 0 do
    begin
      if Count >= 32 then I := 32 else I := Count;
      Reader.Read(Buffer, I);
      Dec(Count, I);
    end;
  end;

  procedure ParseProperty(IsForm: Boolean); forward;

  function ParseValue: Variant;
  const
    LineLength = 64;
  var
    S: string;
  begin
    Result := Null;
    case Reader.NextValue of
      vaList:
        begin
          Reader.ReadValue;
          while not Reader.EndOfList do
            ParseValue;
          Reader.ReadListEnd;
        end;
      vaInt8, vaInt16, vaInt32:
        Result := Reader.ReadInteger;
      vaExtended:
        Result := Reader.ReadFloat;
      vaSingle:
        Result := Reader.ReadSingle;
      vaCurrency:
        Result := Reader.ReadCurrency;
      vaDate:
        Result := Reader.ReadDate;
      vaWString{$IFDEF COMPILER6_UP}, vaUTF8String{$ENDIF}:
        Result := Reader.ReadWideString;
      vaString, vaLString:
        Result := Reader.ReadString;
      vaIdent, vaFalse, vaTrue, vaNil, vaNull:
        Result := Reader.ReadIdent;
      vaBinary:
        ParseBinary;
      vaSet:
        begin
          Reader.ReadValue;
          while True do
          begin
            S := Reader.ReadStr;
            if S = '' then Break;
          end;
        end;
      vaCollection:
        begin
          Reader.ReadValue;
          while not Reader.EndOfList do
          begin
            if Reader.NextValue in [vaInt8, vaInt16, vaInt32] then
            begin
              ParseValue;
            end;
            Reader.CheckValue(vaList);
            while not Reader.EndOfList do ParseProperty(False);
            Reader.ReadListEnd;
          end;
          Reader.ReadListEnd;
        end;
      vaInt64:
      {$IFDEF COMPILER6_UP}
        Result := Reader.ReadInt64;
      {$ELSE}
        Result := Integer(Reader.ReadInt64);
      {$ENDIF}
    else
      raise EReadError.CreateResFmt(@sPropertyException,
        [Info.Name, DotSep, PropName, IntToStr(Ord(Reader.NextValue))]);
    end;
  end;

  procedure ParseProperty(IsForm: Boolean);
  var
    PropValue: Variant;
  begin
    PropName := Reader.ReadStr;
    PropValue := ParseValue;

    if IsForm then
    begin
      Inc(PropCount);
      if SameText(PropName, 'Left') then
        Info.Left := PropValue
      else if SameText(PropName, 'Top') then
        Info.Top := PropValue
      else if SameText(PropName, 'Width') then
        Info.Width := PropValue
      else if SameText(PropName, 'Height') then
        Info.Height := PropValue
      else if SameText(PropName, 'Caption') then
        Info.Caption := PropValue
      else
        Dec(PropCount);
    end;
  end;

  procedure ParseObject;
  begin
    ParseHeader;
    while (PropCount < csPropCount) and not Reader.EndOfList do
      ParseProperty(True);
  end;

begin
  try
    Reader := TReader.Create(Stream, 4096);
    SaveSeparator := DecimalSeparator;
    DecimalSeparator := '.';
    try
      PropCount := 0;
      Reader.ReadSignature;
      ParseObject;
      Result := True;
    finally
      DecimalSeparator := SaveSeparator;
      Reader.Free;
    end;
  except
    Result := False;
  end;
end;

function ParseDfmStream(Stream: TStream; Info: TDfmInfo): Boolean;
const
  FilerSignature: array[1..4] of AnsiChar = ('T', 'P', 'F', '0');
var
  Pos: Integer;
  Signature: Integer;
begin
  Pos := Stream.Position;
  Signature := 0;
  Stream.Read(Signature, SizeOf(Signature));
  Stream.Position := Pos;
  if AnsiChar(Signature) in ['o','O','i','I',' ',#13,#11,#9] then
  begin
    Info.Format := dfText;
    Result := ParseTextDfmStream(Stream, Info);
  end
  else
  begin
    Stream.ReadResHeader;
    Pos := Stream.Position;
    Signature := 0;
    Stream.Read(Signature, SizeOf(Signature));
    Stream.Position := Pos;
    if Signature = Integer(FilerSignature) then
    begin
      Info.Format := dfBinary;
      Result := ParseBinaryDfmStream(Stream, Info);
    end
    else
    begin
      Info.Format := dfUnknown;
      Result := False;
    end;
  end;
end;

function ParseDfmFile(const FileName: string; Info: TDfmInfo): Boolean;
var
  Stream: TFileStream;
begin
  try
    Stream := TFileStream.Create(FileName, fmOpenRead or fmShareDenyWrite);
    try
      Result := ParseDfmStream(Stream, Info);
    finally
      Stream.Free;
    end;
  except
    Result := False;
  end;
end;

end.
