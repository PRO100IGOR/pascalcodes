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

unit CnScaners;
{* |<PRE>
================================================================================
* ������ƣ�CnPack �����ʽ��ר��
* ��Ԫ���ƣ�Object Pascal �ʷ�������
* ��Ԫ���ߣ�CnPack������
* ��    ע���õ�Ԫʵ����Object Pascal �ʷ�������
* ����ƽ̨��Win2003 + Delphi 5.0
* ���ݲ��ԣ�not test yet
* �� �� ����not test hell
* ��Ԫ��ʶ��$Id: CnScaners.pas 763 2011-02-07 14:18:23Z liuxiao@cnpack.org $
* �޸ļ�¼��2007-10-13 V1.0
*               ����һЩ����
*           2004-1-14 V0.5
*               �����ǩ(Bookmark)���ܣ����Է������ǰ��N��TOKEN
*           2003-12-16 V0.4
*               ������Ŀǰ�Զ������ո��ע�͡�ע�Ͳ�Ӧ�����������ǻ���Ҫ����
================================================================================
|</PRE>}

interface

{$I CnPack.inc}

uses
  Classes, SysUtils, Contnrs,
  CnParseConsts, CnTokens, CnCodeGenerators; 

type
  TScannerBookmark = class(TObject)
  private
    FOriginBookmark: Longint;
    FTokenBookmark: TPascalToken;
    FTokenPtrBookmark: PChar;
    FSourcePtrBookmark: PChar;
  protected
    property OriginBookmark: Longint read FOriginBookmark write FOriginBookmark;
    property TokenBookmark: TPascalToken read FTokenBookmark write FTokenBookmark;
    property TokenPtrBookmark: PChar read FTokenPtrBookmark write FTokenPtrBookmark;
    property SourcePtrBookmark: PChar read FSourcePtrBookmark write FSourcePtrBookmark;
  end;

  TAbstractScaner = class(TObject)
  private
    FStream: TStream;
    FBookmarks: TObjectList;
    FOrigin: Longint;
    FBuffer: PChar;
    FBufPtr: PChar;
    FBufEnd: PChar;
    FSourcePtr: PChar;
    FSourceEnd: PChar;
    FTokenPtr: PChar;
    FStringPtr: PChar;
    FSourceLine: Integer;
    FSaveChar: Char;
    FToken: TPascalToken;
    FFloatType: Char;
    FWideStr: WideString;
    FBackwardToken: TPascalToken;

    FBlankStringBegin, FBlankStringEnd: PChar;
    FBlankLines, FBlankLinesAfterComment: Integer;
    FBlankLinesBefore: Integer;
    FBlankLinesAfter: Integer;
    FASMMode: Boolean;
    FFirstCommentInBlock: Boolean;
    FPreviousIsComment: Boolean;

    procedure ReadBuffer;
    procedure SetOrigin(AOrigin: Longint);
    procedure SkipBlanks;
  public
    constructor Create(Stream: TStream); virtual;
    destructor Destroy; override;
    procedure CheckToken(T: TPascalToken);
    procedure CheckTokenSymbol(const S: string);
    procedure Error(const Ident: string);
    procedure ErrorFmt(const Ident: string; const Args: array of const);
    procedure ErrorStr(const Message: string);
    procedure HexToBinary(Stream: TStream);

    function NextToken: TPascalToken; virtual; abstract;
    function SourcePos: Longint;
    function TokenComponentIdent: string;
    function TokenFloat: Extended;
{$IFDEF DELPHI5}
    function TokenInt: Integer;
{$ELSE}
    function TokenInt: Int64;
{$ENDIF}
    function BlankString: string;
    function TokenString: string;
    function TokenChar: Char;
    function TokenWideString: WideString;
    function TokenSymbolIs(const S: string): Boolean;

    procedure SaveBookmark(var Bookmark: TScannerBookmark);
    procedure LoadBookmark(var Bookmark: TScannerBookmark; Clear: Boolean = True);
    procedure ClearBookmark(var Bookmark: TScannerBookmark);

    function ForwardToken(Count: Integer = 1): TPascalToken; virtual;

    property FloatType: Char read FFloatType;
    property SourceLine: Integer read FSourceLine;
    property Token: TPascalToken read FToken;

    property ASMMode: Boolean read FASMMode write FASMMode;
    {* ���������Ƿ񽫻س������հף�asm ������Ҫ��ѡ��}
    property BlankLinesBefore: Integer read FBlankLinesBefore write FBlankLinesBefore;
    {* SkipBlank ����һע��ʱ��ע�ͺ�ǰ����Ч���ݸ����������������Ʒ���}
    property BlankLinesAfter: Integer read FBlankLinesAfter write FBlankLinesAfter;
    {* SkipBlank ����һע�ͺ�ע�ͺͺ�����Ч���ݸ����������������Ʒ���}
  end;

  TScaner = class(TAbstractScaner)
  private
    FStream: TStream;
    FCodeGen: TCnCodeGenerator;
  public
    constructor Create(AStream: TStream); overload; override;
    constructor Create(AStream: TStream; ACodeGen: TCnCodeGenerator); reintroduce; overload; 
    destructor Destroy; override;
    function NextToken: TPascalToken; override;
    function ForwardToken(Count: Integer = 1): TPascalToken; override;
  end;

implementation

{ TAbstractScaner }

const
  ScanBufferSize = 512 * 1024 {KB};

procedure BinToHex(Buffer, Text: PChar; BufSize: Integer); assembler;
const
  Convert: array[0..15] of Char = '0123456789ABCDEF';
var
  I: Integer;
begin
  for I := 0 to BufSize - 1 do
  begin
    Text[0] := Convert[Byte(Buffer[I]) shr 4];
    Text[1] := Convert[Byte(Buffer[I]) and $F];
    Inc(Text, 2);
  end;
end;
{asm
        PUSH    ESI
        PUSH    EDI
        MOV     ESI,EAX
        MOV     EDI,EDX
        MOV     EDX,0
        JMP     @@1
@@0:    DB      '0123456789ABCDEF'
@@1:    LODSB
        MOV     DL,AL
        AND     DL,0FH
        MOV     AH,@@0.Byte[EDX]
        MOV     DL,AL
        SHR     DL,4
        MOV     AL,@@0.Byte[EDX]
        STOSW
        DEC     ECX
        JNE     @@1
        POP     EDI
        POP     ESI
end;}

function HexToBin(Text, Buffer: PChar; BufSize: Integer): Integer; assembler;
const
  Convert: array['0'..'f'] of SmallInt =
    ( 0, 1, 2, 3, 4, 5, 6, 7, 8, 9,-1,-1,-1,-1,-1,-1,
     -1,10,11,12,13,14,15,-1,-1,-1,-1,-1,-1,-1,-1,-1,
     -1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,
     -1,10,11,12,13,14,15);
var
  I: Integer;
begin
  I := BufSize;
  while I > 0 do
  begin
    if not (Text[0] in ['0'..'f']) or not (Text[1] in ['0'..'f']) then Break;
    Buffer[0] := Char((Convert[Text[0]] shl 4) + Convert[Text[1]]);
    Inc(Buffer);
    Inc(Text, 2);
    Dec(I);
  end;
  Result := BufSize - I;
end;

{asm
        PUSH    ESI
        PUSH    EDI
        PUSH    EBX
        MOV     ESI,EAX
        MOV     EDI,EDX
        MOV     EBX,EDX
        MOV     EDX,0
        JMP     @@1
@@0:    DB       0, 1, 2, 3, 4, 5, 6, 7, 8, 9,-1,-1,-1,-1,-1,-1
        DB      -1,10,11,12,13,14,15,-1,-1,-1,-1,-1,-1,-1,-1,-1
        DB      -1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1
        DB      -1,10,11,12,13,14,15
@@1:    LODSW
        CMP     AL,'0'
        JB      @@2
        CMP     AL,'f'
        JA      @@2
        MOV     DL,AL
        MOV     AL,@@0.Byte[EDX-'0']
        CMP     AL,-1
        JE      @@2
        SHL     AL,4
        CMP     AH,'0'
        JB      @@2
        CMP     AH,'f'
        JA      @@2
        MOV     DL,AH
        MOV     AH,@@0.Byte[EDX-'0']
        CMP     AH,-1
        JE      @@2
        OR      AL,AH
        STOSB
        DEC     ECX
        JNE     @@1
@@2:    MOV     EAX,EDI
        SUB     EAX,EBX
        POP     EBX
        POP     EDI
        POP     ESI
end;}

{ TAbstractScaner }

constructor TAbstractScaner.Create(Stream: TStream);
begin
  FStream := Stream;
  FBookmarks := TObjectList.Create;
    
  GetMem(FBuffer, ScanBufferSize);
  FBuffer[0] := #0;
  FBufPtr := FBuffer;
  FBufEnd := FBuffer + ScanBufferSize;
  FSourcePtr := FBuffer;
  FSourceEnd := FBuffer;
  FTokenPtr := FBuffer;
  FSourceLine := 1;
  FBackwardToken := tokNoToken;

  NextToken;
end;

destructor TAbstractScaner.Destroy;
begin
  if FBuffer <> nil then
  begin
    FStream.Seek(Longint(FTokenPtr) - Longint(FBufPtr), 1);
    FreeMem(FBuffer, ScanBufferSize);
  end;

  FBookmarks.Free;
end;

procedure TAbstractScaner.CheckToken(T: TPascalToken);
begin
  if Token <> T then
    case T of
      tokSymbol:
        Error(SIdentifierExpected);
      tokString, tokWString:
        Error(SStringExpected);
      tokInteger, tokFloat:
        Error(SNumberExpected);
    else
      ErrorFmt(SCharExpected, [Integer(T)]);
    end;
end;

procedure TAbstractScaner.CheckTokenSymbol(const S: string);
begin
  if not TokenSymbolIs(S) then ErrorFmt(SSymbolExpected, [S]);
end;

procedure TAbstractScaner.Error(const Ident: string);
begin
  ErrorStr(Ident);
end;

procedure TAbstractScaner.ErrorFmt(const Ident: string; const Args: array of const);
begin
  ErrorStr(Format(Ident, Args));
end;

procedure TAbstractScaner.ErrorStr(const Message: string);
begin
  raise EParserError.CreateResFmt(@SParseError, [Message, FSourceLine, SourcePos]);
end;

procedure TAbstractScaner.HexToBinary(Stream: TStream);
var
  Count: Integer;
  Buffer: array[0..255] of Char;
begin
  SkipBlanks;
  while FSourcePtr^ <> '}' do
  begin
    Count := HexToBin(FSourcePtr, Buffer, SizeOf(Buffer));
    if Count = 0 then Error(SInvalidBinary);
    Stream.Write(Buffer, Count);
    Inc(FSourcePtr, Count * 2);
    SkipBlanks;
  end;
  NextToken;
end;

procedure TAbstractScaner.ReadBuffer;
var
  Count: Integer;
begin
  Inc(FOrigin, FSourcePtr - FBuffer);
  FSourceEnd[0] := FSaveChar;
  Count := FBufPtr - FSourcePtr;
  if Count <> 0 then Move(FSourcePtr[0], FBuffer[0], Count);
  FBufPtr := FBuffer + Count;
  Inc(FBufPtr, FStream.Read(FBufPtr[0], FBufEnd - FBufPtr));
  FSourcePtr := FBuffer;
  FSourceEnd := FBufPtr;
  if FSourceEnd = FBufEnd then
  begin
    FSourceEnd := LineStart(FBuffer, FSourceEnd - 1);
    if FSourceEnd = FBuffer then Error(SLineTooLong);
  end;
  FSaveChar := FSourceEnd[0];
  FSourceEnd[0] := #0;
end;

procedure TAbstractScaner.SetOrigin(AOrigin: Integer);
begin
  if AOrigin <> FOrigin then
  begin
    FOrigin := AOrigin;
    FSourceEnd[0] := FSaveChar;
    FStream.Seek(AOrigin, soFromBeginning);
    FBufPtr := FBuffer;
    Inc(FBufPtr, FStream.Read(FBuffer[0], ScanBufferSize));
    FSourcePtr := FBuffer;
    FSourceEnd := FBufPtr;
    if FSourceEnd = FBufEnd then
    begin
      FSourceEnd := LineStart(FBuffer, FSourceEnd - 1);
      if FSourceEnd = FBuffer then Error(SLineTooLong);
    end;
    FSaveChar := FSourceEnd[0];
    FSourceEnd[0] := #0;
  end;
end;

procedure TAbstractScaner.SkipBlanks;
begin
  FBlankStringBegin := FSourcePtr;
  FBlankStringEnd := FBlankStringBegin;
  FBlankLines := 0;
  
  while True do
  begin
    case FSourcePtr^ of
      #0:
        begin
          ReadBuffer;
          if FSourcePtr^ = #0 then
            Exit;
          Continue;
        end;
      #10:
        begin
          Inc(FSourceLine);
          Inc(FBlankLines);

          if FASMMode then // ��Ҫ���س��ı�־
          begin
            FBlankStringEnd := FSourcePtr;
            Exit;
          end;
        end;
      #33..#255:
        begin
          FBlankStringEnd := FSourcePtr;
          Exit;
        end;
    end;
    
    Inc(FSourcePtr);
    FBackwardToken := tokBlank;
  end;
end;

function TAbstractScaner.SourcePos: Longint;
begin
  Result := FOrigin + (FTokenPtr - FBuffer);
end;

function TAbstractScaner.TokenFloat: Extended;
begin
  if FFloatType <> #0 then Dec(FSourcePtr);
  Result := StrToFloat(TokenString);
  if FFloatType <> #0 then Inc(FSourcePtr);
end;

{$IFDEF DELPHI5}
function TAbstractScaner.TokenInt: Integer;
begin
  Result := StrToInt(TokenString);
end;
{$ELSE}
function TAbstractScaner.TokenInt: Int64;
begin
  Result := StrToInt64(TokenString);
end;
{$ENDIF}

function TAbstractScaner.TokenString: string;
var
  L: Integer;
begin
  if FToken = tokString then
    L := FStringPtr - FTokenPtr
  else
    L := FSourcePtr - FTokenPtr;
  SetString(Result, FTokenPtr, L);
end;

function TAbstractScaner.TokenWideString: WideString;
begin
  if FToken = tokString then
    Result := TokenString
  else
    Result := FWideStr;
end;

function TAbstractScaner.TokenSymbolIs(const S: string): Boolean;
begin
  Result := SameText(S, TokenString);
end;

function TAbstractScaner.TokenComponentIdent: string;
var
  P: PChar;
begin
  CheckToken(tokSymbol);
  P := FSourcePtr;
  while P^ = '.' do
  begin
    Inc(P);
    if not (P^ in ['A'..'Z', 'a'..'z', '_']) then
      Error(SIdentifierExpected);
    repeat
      Inc(P)
    until not (P^ in ['A'..'Z', 'a'..'z', '0'..'9', '_']);
  end;
  FSourcePtr := P;
  Result := TokenString;
end;

function TAbstractScaner.TokenChar: Char;
begin
  Result := TokenString[1];
end;

procedure TAbstractScaner.LoadBookmark(var Bookmark: TScannerBookmark; Clear:
  Boolean = True);
begin
  if FBookmarks.IndexOf(Bookmark) >= 0 then
  begin
    with Bookmark do
    begin
      if Assigned(SourcePtrBookmark) and Assigned(TokenPtrBookmark) then
      begin
        if OriginBookmark <> FOrigin then
          SetOrigin(OriginBookmark);
        FSourcePtr := SourcePtrBookmark;
        FTokenPtr := TokenPtrBookmark;
        FToken := TokenBookmark;
      end
      else
        Error(SInvalidBookmark);
    end;
  end
  else
    Error(SInvalidBookmark);

  if Clear then
    ClearBookmark(Bookmark);
end;

procedure TAbstractScaner.SaveBookmark(var Bookmark: TScannerBookmark);
begin
  Bookmark := TScannerBookmark.Create;
  with Bookmark do
  begin
    OriginBookmark := FOrigin;
    SourcePtrBookmark := FSourcePtr;
    TokenBookmark := FToken;
    TokenPtrBookmark := FTokenPtr;
  end;
  FBookmarks.Add(Bookmark);
end;

procedure TAbstractScaner.ClearBookmark(var Bookmark: TScannerBookmark);
begin
  Bookmark := TScannerBookmark(FBookmarks.Extract(Bookmark));
  if Assigned(Bookmark) then
    FreeAndNil(Bookmark);
end;

function TAbstractScaner.ForwardToken(Count: Integer): TPascalToken;
var
  Bookmark: TScannerBookmark;
  I: Integer;
begin
  Result := Token;

  SaveBookmark(Bookmark);

  for I := 0 to Count - 1 do
  begin
    Result := NextToken;
    if Result = tokEOF then
      Exit;
  end;

  LoadBookmark(Bookmark);
end;

function TAbstractScaner.BlankString: string;
var
  L: Integer;
begin
  L := FBlankStringEnd - FBlankStringBegin;
  SetString(Result, FBlankStringBegin, L);
end;

{ TScaner }

constructor TScaner.Create(AStream: TStream; ACodeGen: TCnCodeGenerator);
begin
  AStream.Seek(0, soFromBeginning);
  FStream := AStream;
  FCodeGen := ACodeGen;

  inherited Create(AStream);
end;

constructor TScaner.Create(AStream: TStream);
begin
  Create(AStream, nil); //TCnCodeGenerator.Create);
end;

destructor TScaner.Destroy;
begin
  inherited Destroy;
end;

function TScaner.ForwardToken(Count: Integer): TPascalToken;
begin
  FCodeGen.LockOutput;
  try
    Result := inherited ForwardToken(Count);
  finally
    FCodeGen.UnLockOutput;
  end;
end;

function TScaner.NextToken: TPascalToken;

  procedure SkipTo(var P: PChar; TargetChar: Char);
  begin
    while (P^ <> TargetChar) do
    begin
      Inc(P);

      if (P^ = #0) then
      begin
        ReadBuffer;
        if FSourcePtr^ = #0 then
          Break;
      end;
    end;
  end;

var
  IsWideStr: Boolean;
  P: PChar;
begin
  SkipBlanks;
  P := FSourcePtr;
  FTokenPtr := P;
  case P^ of
    'A'..'Z', 'a'..'z', '_':
      begin
        Inc(P);
        while P^ in ['A'..'Z', 'a'..'z', '0'..'9', '_'] do Inc(P);
        Result := tokSymbol;
      end;
    '#', '''':
      begin
        IsWideStr := False;
        // parser string like this: 'abc'#10#13'def'#10#13
        while True do
          case P^ of
            '#':
              begin
                IsWideStr := True;
                Inc(P);
                while P^ in ['$', '0'..'9', 'a'..'f', 'A'..'F'] do Inc(P);
              end;
            '''':
              begin
                Inc(P);
                while True do
                  case P^ of
                    #0, #10, #13:
                      Error(SInvalidString);
                    '''':
                      begin
                        Inc(P);
                        Break;
                      end;
                  else
                    Inc(P);
                  end;
              end;
          else
            Break;
          end; // case P^ of

        FStringPtr := P;
        
        if IsWideStr then
          Result := tokWString
        else
          Result := tokString;
      end; // '#', '''': while True do

    '"':
      begin
        Inc(P);
        while not (P^ in ['"', #0, #10, #13]) do Inc(P);
        Result := tokString;
        if P^ = '"' then  // �͵������ַ���һ���������һ��˫����
          Inc(P);
        FStringPtr := P;
      end;

    '$':
      begin
        Inc(P);
        while P^ in ['0'..'9', 'A'..'F', 'a'..'f'] do
          Inc(P);
        Result := tokInteger;
      end;

    '*':
      begin
        Inc(P);
        Result := tokStar;
      end;

    '{':
      begin
        Inc(P);
        { TODO: Check Directive sign $}

        Result := tokComment;
        while ((P^ <> #0) and (P^ <> '}')) do
          Inc(P);

        if P^ = '}' then
        begin
          FBlankLinesAfterComment := 0;
          Inc(P);
          while P^ in [' ', #9] do
            Inc(P);
          if P^ = #13 then
          begin
            if not FASMMode then // ASM ģʽ�£�������Ϊ��������������ע���ڴ���
            begin
              Inc(P);
              if P^ = #10 then
              begin
                Inc(FBlankLinesAfterComment);
                Inc(P);
              end;
            end;
          end;
        end
        else
          Error(SEndOfCommentExpected);
      end;

    '/':
      begin
        Inc(P);

        if P^ = '/' then
        begin
          Result := tokComment;
          while (P^ <> #0) and (P^ <> #13)
            do Inc(P); // ����β

          FBlankLinesAfterComment := 0;
          if P^ = #13 then
          begin
            if not FASMMode then // ASM ģʽ�£�������Ϊ��������������ע���ڴ���
            begin
              Inc(P);
              if P^ = #10 then
              begin
                Inc(FBlankLinesAfterComment);
                Inc(P);
              end;
            end;
          end
          else
            Error(SEndOfCommentExpected);
        end
        else
          Result := tokDiv;
      end;

    '(':
      begin
        Inc(P);
        Result := tokLB;

        if P^ = '*' then
        begin
          Result := tokComment;

          Inc(P);
          FBlankLinesAfterComment := 0;
          while P^ <> #0 do
          begin
            if P^ = '*' then
            begin
              Inc(P);
              if P^ = ')' then
              begin
                Inc(P);
                while P^ in [' ', #9] do
                  Inc(P);

                if P^ = #13 then
                begin
                  if not FASMMode then // ASM ģʽ�£�������Ϊ��������������ע���ڴ���
                  begin
                    Inc(P);
                    if P^ = #10 then
                    begin
                      Inc(FBlankLinesAfterComment);
                      Inc(P);
                    end;
                  end;
                end;

                Break;
              end;
            end
            else
              Inc(P);
          end;
        end;
      end;

    ')':
      begin
        Inc(P);
        Result := tokRB;
      end;

    '[':
      begin
        Inc(P);
        Result := tokSLB;
      end;

    ']':
      begin
        Inc(P);
        Result := tokSRB;
      end;

    '^':
      begin
        Inc(P);
        Result := tokHat;
      end;

    '=':
      begin
        Inc(P);
        Result := tokEQUAL;
      end;

    ':':
      begin
        Inc(P);
        if (P^ = '=') then
        begin
          Inc(P);
          Result := tokAssign;
        end else
          Result := tokColon;
      end;
      
    ';':
      begin
        Inc(P);
        Result := tokSemicolon;
      end;

    '.':
      begin
        Inc(P);

        if P^ = '.' then
        begin
          Result := tokRange;
          Inc(P);
        end else
          Result := tokDot;
      end;

    ',':
      begin
        Inc(P);
        Result := tokComma;
      end;

    '>':
      begin
        Inc(P);
        Result := tokGreat;
          
        if P^ = '<' then
        begin
          Result := tokNotEqual;
          Inc(P);
        end else
        if P^ = '=' then
        begin
          Result := tokGreatOrEqu;
          Inc(P);
        end;
      end;

    '<':
      begin
        Inc(P);
        Result := tokLess;
        
        if P^ = '=' then
        begin
          Result := tokLessOrEqu;
          Inc(P);
        end;

        if P^ = '>' then
        begin
          Result := tokNotEqual;
          Inc(P);
        end;
      end;

    '@':
      begin
        Inc(P);
        Result := tokAtSign;
      end;

    '+', '-':
      begin
        if P^ = '+' then
          Result := tokPlus
        else
          Result := tokMinus;

        Inc(P);
      end;

    '0'..'9':
      begin
        Inc(P);
        while P^ in ['0'..'9'] do Inc(P);
        Result := tokInteger;

        if (P^ = '.') and ((P+1)^ <> '.') then
        begin
          Inc(P);
          while P^ in ['0'..'9'] do Inc(P);
          Result := tokFloat;
        end;

        if P^ in ['e', 'E'] then
        begin
          Inc(P);
          if P^ in ['-', '+'] then
            Inc(P);
          while P^ in ['0'..'9'] do
            Inc(P);
          Result := tokFloat;
        end;

        if (P^ in ['c', 'C', 'd', 'D', 's', 'S']) then
        begin
          Result := tokFloat;
          FFloatType := P^;
          Inc(P);
        end
        else
          FFloatType := #0;
      end;
    #10:  // ����лس������� #10 Ϊ׼
      begin
        Result := tokCRLF;
        Inc(P);
      end;
  else
    if P^ = #0 then
      Result := tokEOF
    else
      Result := tokUnknown;

    if Result <> tokEOF then
      Inc(P);
  end;

  FSourcePtr := P;
  FToken := Result;

  if Result = tokComment then // ��ǰ�� Comment
  begin
    if Assigned(FCodeGen) then
    begin
      FCodeGen.Write(BlankString);
      FCodeGen.Write(TokenString);
    end;

    if not FFirstCommentInBlock then // ��һ������ Comment ʱ�������
    begin
      FFirstCommentInBlock := True;
      FBlankLinesBefore := FBlankLines;
    end;

    FPreviousIsComment := True;
    Result := NextToken;
    // ����ݹ�Ѱ����һ�� Token��
    // ����� FFirstCommentInBlock Ϊ True����˲������¼�¼ FBlankLinesBefore
    FPreviousIsComment := False;
  end
  else
  begin
    // ֻҪ��ǰ���� Comment �����÷ǵ�һ�� Comment �ı��
    FFirstCommentInBlock := False;

    if FPreviousIsComment then // ��һ���� Comment����¼����� ��һ��Comment�Ŀ�����
    begin
      // ���һ��ע�͵��ڵݹ�����㸳ֵ�����FBlankLinesAfter�ᱻ��㸲�ǣ�
      // �������һ��ע�ͺ�Ŀ�����
      FBlankLinesAfter := FBlankLines + FBlankLinesAfterComment;
    end
    else // ��һ������ Comment����ǰҲ���� Comment��ȫ��0
    begin
      FBlankLinesAfter := 0;
      FBlankLinesBefore := 0;
      FBlankLines := 0;
    end;

    if FBackwardToken = tokComment then // ��ǰ���� Comment����ǰһ���� Comment
      FCodeGen.Write(BlankString);

    if (Result = tokString) and (Length(TokenString) = 1) then
      Result := tokChar
    else if Result = tokSymbol then
      Result := StringToToken(TokenString);

    FToken := Result;
    FBackwardToken := FToken;
  end;
end;

end.
