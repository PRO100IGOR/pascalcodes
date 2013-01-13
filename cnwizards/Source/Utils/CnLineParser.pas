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

unit CnLineParser;
{ |<PRE>
================================================================================
* ������ƣ�CnPack IDE ר�Ұ�
* ��Ԫ���ƣ�Դ����ʽ����ģ��
* ��Ԫ���ߣ���Х(LiuXiao) liuxiao@cnpack.org
* ��    ע��Դ����ʽ����ģ��
* ����ƽ̨��Windows 98 + Delphi 6
* ���ݲ��ԣ�PWin9X/2000/XP + Delphi 5/6/7 + C++Builder 5/6
* �� �� �����õ�Ԫ�е��ַ���֧�ֱ��ػ�����ʽ
* ��Ԫ��ʶ��$Id: CnLineParser.pas 763 2011-02-07 14:18:23Z liuxiao@cnpack.org $
* �޸ļ�¼��2003.03.31 V1.1
*               �޸��˶��ļ���ͷ//��ʽע�ͺʹ����Ŵ������Ĵ���
*           2003.03.26 V1.0
*               ������Ԫ
================================================================================
|</PRE>}

interface

uses
  Classes, SysUtils;

type
  TLineTokenKind = (lkUndefined, lkCode, lkBlockComment, lkLineComment,
    lkQuoteString, lkDittoString);

type
  TCnLineParser = class(TObject)
  private
    FCommentBytes: Integer;
    FCodeBytes: Integer;
    FCommentLines: Integer;
    FCommentBlocks: Integer;
    FCodeLines: Integer;
    FBlankLines: Integer;
    FEffectiveLines: Integer;
    FAllLines: Integer;

    FStrings: TStringList;
    FInStream: TStream;
    FLineTokenKind: TLineTokenKind;

    FParsed: Boolean;

    FCurChar: Char;
    FNextChar: Char;
    FIgnoreBlanks: Boolean;
    function GetAllLines: Integer;
    function GetBlankLines: Integer;
    function GetCodeBytes: Integer;
    function GetCodeLines: Integer;
    function GetCommentBytes: Integer;
    function GetCommentLines: Integer;
    function GetEffectiveLines: Integer;
    procedure ResetStat;
    procedure DoDefaultProcess(var HasCode, HasComment: Boolean);
    procedure SetInStream(const Value: TStream);
    function GetCommentBlocks: Integer;
  protected
    procedure ParseALine(AStr: String); virtual; abstract;
  public
    constructor Create;
    destructor Destroy; override;
    procedure Parse;

    property InStream: TStream read FInStream write SetInStream;
    property AllLines: Integer read GetAllLines;
    property CommentLines: Integer read GetCommentLines;
    property CommentBlocks: Integer read GetCommentBlocks;
    property CodeLines: Integer read GetCodeLines;
    property BlankLines: Integer read GetBlankLines;
    property EffectiveLines: Integer read GetEffectiveLines;
    property CommentBytes: Integer read GetCommentBytes;
    property CodeBytes: Integer read GetCodeBytes;
    property IgnoreBlanks: Boolean read FIgnoreBlanks write FIgnoreBlanks;
  end;

  TCnPasLineParser = class(TCnLineParser)
  protected
    procedure ParseALine(AStr: String); override;
  public

  end;

  TCnCPPLineParser = class(TCnLineParser)
  protected
    procedure ParseALine(AStr: String); override;
  public

  end;

implementation

{ TCnLineParser }

constructor TCnLineParser.Create;
begin
  FStrings := TStringList.Create;
end;

destructor TCnLineParser.Destroy;
begin
  FStrings.Free;
  inherited;
end;

procedure TCnLineParser.DoDefaultProcess(var HasCode, HasComment: Boolean);
begin
  if (((FCurChar > #32) or not (AnsiChar(FCurChar) in [#1..#9, #11, #12, #14..#32]))
    and (FLineTokenKind = lkUndefined)) or (FLineTokenKind = lkCode) then
  begin
    FLineTokenKind := lkCode;
    Inc(FCodeBytes);
    HasCode := True;
  end
  else if (FLineTokenKind = lkLineComment) or (FLineTokenKind = lkBlockComment) then
  begin
    HasComment := True;
    Inc(FCommentBytes);
  end;
end;

function TCnLineParser.GetAllLines: Integer;
begin
  if not FParsed then Parse;
  Result := FAllLines;
end;

function TCnLineParser.GetBlankLines: Integer;
begin
  if not FParsed then Parse;
  Result := FBlankLines;
end;

function TCnLineParser.GetCodeBytes: Integer;
begin
  if not FParsed then Parse;
  Result := FCodeBytes;
end;

function TCnLineParser.GetCodeLines: Integer;
begin
  if not FParsed then Parse;
  Result := FCodeLines;
end;

function TCnLineParser.GetCommentBlocks: Integer;
begin
  if not FParsed then Parse;
  Result := FCommentBlocks;
end;

function TCnLineParser.GetCommentBytes: Integer;
begin
  if not FParsed then Parse;
  Result := FCommentBytes;
end;

function TCnLineParser.GetCommentLines: Integer;
begin
  if not FParsed then Parse;
  Result := FCommentLines;
end;

function TCnLineParser.GetEffectiveLines: Integer;
begin
  if not FParsed then Parse;
  Result := FEffectiveLines;
end;

procedure TCnLineParser.Parse;
var
  i: Integer;
begin
  if (FInStream <> nil) and (FInStream.Size > 0) then
  begin
    ResetStat;
    FInStream.Position := 0;

    FStrings.LoadFromStream(InStream);
    FAllLines := FStrings.Count;

    for i := 0 to FStrings.Count - 1 do
      ParseALine(FStrings[i]);

    FParsed := True;
  end;
end;

procedure TCnLineParser.ResetStat;
begin
  FParsed := False;
  FCommentBytes := 0;
  FCodeBytes := 0;
  FCommentLines := 0;
  FCommentBlocks := 0;
  FCodeLines := 0;
  FBlankLines := 0;
  FEffectiveLines := 0;
  FAllLines := 0;
end;

procedure TCnLineParser.SetInStream(const Value: TStream);
begin
  FInStream := Value;
  ResetStat;
end;

{ TCnPasLineParser }

procedure TCnPasLineParser.ParseALine(AStr: String);
var
  i, Len: Integer;
  HasComment: Boolean;
  HasCode: Boolean;
begin
  if (Trim(AStr) = '') then
  begin
    if (FLineTokenKind <> lkBlockComment) then
      Inc(FBlankLines)
    else
      Inc(FCommentLines);
    Exit;
  end
  else
    Inc(FEffectiveLines);

  if FIgnoreBlanks then AStr := Trim(AStr);

  Len := Length(AStr);
  HasComment := False;
  HasCode := False;
  if FLineTokenKind <> lkBlockComment then
    FLineTokenKind := lkUndefined;
  i := 1;

  while (i <= Len) or (FNextChar <> #0) do
  begin
    FCurChar := AStr[i];
    if i = Len then FNextChar := #0
    else FNextChar := AStr[i + 1];

    case FCurChar of
    '/':
      begin
        if ((FLineTokenKind = lkCode) or (FLineTokenKind = lkUndefined)) and (FNextChar = '/') then
        begin
          FLineTokenKind := lkLineComment;
          Inc(FCommentBytes);
          Inc(FCommentBlocks);
          HasComment := True;
        end
        else
          DoDefaultProcess(HasCode, HasComment);
      end;
    '''':
      begin
        if FLineTokenKind = lkCode then
        begin
          FLineTokenKind := lkQuoteString;
        end
        else if FLineTokenKind = lkQuoteString then
        begin
           FLineTokenKind := lkCode
        end;
        Inc(FCodeBytes);
      end;
    '{':
      begin
        if (FLineTokenKind = lkCode) or (FLineTokenKind = lkUndefined) then
        begin
//          if FNextChar <> '$' then
          FLineTokenKind := lkBlockComment;
          HasComment := True;
          Inc(FCommentBytes);
          Inc(FCommentBlocks);
        end
      end;
    '}':
      begin
        if FLineTokenKind = lkBlockComment then
        begin
          FLineTokenKind := lkUndefined;
          Inc(FCommentBytes);
        end
      end;
    '(':
      begin
        if (FNextChar = '*') and ((FLineTokenKind = lkCode) or (FLineTokenKind = lkUndefined)) then
        begin
          FLineTokenKind := lkBlockComment;
          Inc(FCommentBytes);
          Inc(FCommentBlocks);
          HasComment := True;
        end
        else
          DoDefaultProcess(HasCode, HasComment);
      end;
    '*':
      begin
        if (FNextChar = ')') and (FLineTokenKind = lkBlockComment) then
        begin
          FLineTokenKind := lkUndefined;
          Inc(FCommentBytes);
        end
        else
          DoDefaultProcess(HasCode, HasComment);
      end;
    else
      DoDefaultProcess(HasCode, HasComment);
    end;
    Inc(i);
  end;

  if HasCode then Inc(FCodeLines);
  if HasComment then Inc(FCommentLines);
end;

{ TCnCPPLineParser }

procedure TCnCPPLineParser.ParseALine(AStr: String);
var
  i, Len: Integer;
  HasComment: Boolean;
  HasCode: Boolean;
begin
  if (Trim(AStr) = '') then
  begin
    if (FLineTokenKind <> lkBlockComment) then
      Inc(FBlankLines)
    else
      Inc(FCommentLines);
    Exit;
  end
  else
    Inc(FEffectiveLines);

  if FIgnoreBlanks then AStr := Trim(AStr);

  Len := Length(AStr);
  HasComment := False;
  HasCode := False;
  if FLineTokenKind <> lkBlockComment then
    FLineTokenKind := lkUndefined;
  i := 1;

  while (i <= Len) or (FNextChar <> #0) do
  begin
    FCurChar := AStr[i];
    if i = Len then FNextChar := #0
    else FNextChar := AStr[i + 1];

    case FCurChar of
    '/':
      begin
        if ((FLineTokenKind = lkCode) or (FLineTokenKind = lkUndefined)) and (FNextChar = '/') then
        begin
          FLineTokenKind := lkLineComment;
          Inc(FCommentBytes);
          Inc(FCommentBlocks);
          HasComment := True;
        end
        else if (FNextChar = '*') and ((FLineTokenKind = lkCode) or (FLineTokenKind = lkUndefined)) then
        begin
          FLineTokenKind := lkBlockComment;
          Inc(FCommentBytes);
          Inc(FCommentBlocks);
          HasComment := True;
        end
        else
          DoDefaultProcess(HasCode, HasComment);
      end;
    '''':
      begin
        if FLineTokenKind = lkCode then
        begin
          FLineTokenKind := lkQuoteString;
        end
        else if FLineTokenKind = lkQuoteString then
        begin
           FLineTokenKind := lkCode
        end;
        Inc(FCodeBytes);
      end;
    '"':
      begin
        if FLineTokenKind = lkCode then
        begin
          FLineTokenKind := lkDittoString;
        end
        else if FLineTokenKind = lkDittoString then
        begin
           FLineTokenKind := lkCode
        end;
        Inc(FCodeBytes);
      end;
    '*':
      begin
        if (FNextChar = '/') and (FLineTokenKind = lkBlockComment) then
        begin
          FLineTokenKind := lkUndefined;
          Inc(FCommentBytes);
        end
        else
          DoDefaultProcess(HasCode, HasComment);
      end;
    else
      DoDefaultProcess(HasCode, HasComment);
    end;
    Inc(i);
  end;

  if HasCode then Inc(FCodeLines);
  if HasComment then Inc(FCommentLines);
end;

end.
