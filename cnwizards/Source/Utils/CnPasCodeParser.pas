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

unit CnPasCodeParser;
{* |<PRE>
================================================================================
* ������ƣ�CnPack IDE ר�Ұ�
* ��Ԫ���ƣ�Pas Դ���������
* ��Ԫ���ߣ��ܾ��� zjy@cnpack.org
* ��    ע��
* ����ƽ̨��PWin2000Pro + Delphi 5.01
* ���ݲ��ԣ�
* �� �� �����õ�Ԫ�е��ַ��������ϱ��ػ�����ʽ
* ��Ԫ��ʶ��$Id: CnPasCodeParser.pas 922 2011-07-13 05:25:51Z liuxiao@cnpack.org $
* �޸ļ�¼��2011.05.29
*               ����BDS�¶Ժ���UTF8δ��������½������������
*           2004.11.07
*               ������Ԫ
================================================================================
|</PRE>}

interface

{$I CnWizards.inc}

uses
  Windows, SysUtils, Classes, mPasLex, mwBCBTokenList, CnWizUtils,
  Contnrs, CnCommon, CnFastList;

const
  CN_TOKEN_MAX_SIZE = 63;

type
  TCnUseToken = class(TObject)
  private
    FIsImpl: Boolean;
    FTokenPos: Integer;
    FToken: string;
    FTokenID: TTokenKind;
  public
    property Token: string read FToken write FToken;
    property IsImpl: Boolean read FIsImpl write FIsImpl;
    property TokenPos: Integer read FTokenPos write FTokenPos;
    property TokenID: TTokenKind read FTokenID write FTokenID;
  end;

  TCnPasToken = class(TPersistent)
  {* ����һ Token �Ľṹ������Ϣ}
  private
    function GetToken: PAnsiChar;
  
  protected
    FCppTokenKind: TCTokenKind;
    FCharIndex: Integer;
    FEditCol: Integer;
    FEditLine: Integer;
    FItemIndex: Integer;
    FItemLayer: Integer;
    FLineNumber: Integer;
    FMethodLayer: Integer;
    FToken: array[0..CN_TOKEN_MAX_SIZE] of AnsiChar;
    FTokenID: TTokenKind;
    FTokenPos: Integer;
    FIsMethodStart: Boolean;
    FIsMethodClose: Boolean;
    FIsBlockStart: Boolean;
    FIsBlockClose: Boolean;
    FUseAsC: Boolean;
  public
    procedure Clear;

    property UseAsC: Boolean read FUseAsC;
    {* �Ƿ��� C ��ʽ�Ľ�����Ĭ�ϲ���}
    property CharIndex: Integer read FCharIndex; // Start 0
    {* �ӱ��п�ʼ�����ַ�λ�ã����㿪ʼ }
    property EditCol: Integer read FEditCol write FEditCol;
    {* �����У���һ��ʼ }
    property EditLine: Integer read FEditLine write FEditLine;
    {* �����У���һ��ʼ }
    property ItemIndex: Integer read FItemIndex;
    {* ������ Parser �е���� }
    property ItemLayer: Integer read FItemLayer;
    {* ���ڸ����Ĳ�� }
    property LineNumber: Integer read FLineNumber; // Start 0
    {* �����кţ����㿪ʼ }
    property MethodLayer: Integer read FMethodLayer;
    {* ���ں�����Ƕ�ײ�Σ������Ϊһ }
    property Token: PAnsiChar read GetToken;
    {* �� Token ���ַ������� }
    property TokenID: TTokenKind read FTokenID;
    {* Token ���﷨���� }
    property CppTokenKind: TCTokenKind read FCppTokenKind;
    {* ��Ϊ C �� Token ʹ��ʱ�� CToken ����}
    property TokenPos: Integer read FTokenPos;
    {* Token �������ļ��е�����λ�� }
    property IsBlockStart: Boolean read FIsBlockStart;
    {* �Ƿ���һ���ƥ���������Ŀ�ʼ }
    property IsBlockClose: Boolean read FIsBlockClose;
    {* �Ƿ���һ���ƥ���������Ľ��� }
    property IsMethodStart: Boolean read FIsMethodStart;
    {* �Ƿ��Ǻ������̵Ŀ�ʼ������ function �� begin/asm ����� }
    property IsMethodClose: Boolean read FIsMethodClose;
    {* �Ƿ��Ǻ������̵Ľ��� }
  end;

//==============================================================================
// Pascal �ļ��ṹ����������
//==============================================================================

  { TCnPasStructureParser }

  TCnPasStructureParser = class(TObject)
  {* ���� Lex �����﷨�����õ����� Token ��λ����Ϣ}
  private
    FBlockCloseToken: TCnPasToken;
    FBlockStartToken: TCnPasToken;
    FChildMethodCloseToken: TCnPasToken;
    FChildMethodStartToken: TCnPasToken;
    FCurrentChildMethod: AnsiString;
    FCurrentMethod: AnsiString;
    FKeyOnly: Boolean;
    FList: TCnList;
    FMethodCloseToken: TCnPasToken;
    FMethodStartToken: TCnPasToken;
    FSource: AnsiString;
    FInnerBlockCloseToken: TCnPasToken;
    FInnerBlockStartToken: TCnPasToken;
    FUseTabKey: Boolean;
    FTabWidth: Integer;
    function GetCount: Integer;
    function GetToken(Index: Integer): TCnPasToken;
  public
    constructor Create;
    destructor Destroy; override;
    procedure Clear;
    procedure ParseSource(ASource: PAnsiChar; AIsDpr, AKeyOnly: Boolean);
    function FindCurrentDeclaration(LineNumber, CharIndex: Integer): AnsiString;
    procedure FindCurrentBlock(LineNumber, CharIndex: Integer);
    function IndexOfToken(Token: TCnPasToken): Integer;
    property Count: Integer read GetCount;
    property Tokens[Index: Integer]: TCnPasToken read GetToken;
    property MethodStartToken: TCnPasToken read FMethodStartToken;
    {* ��ǰ�����Ĺ��̻���}
    property MethodCloseToken: TCnPasToken read FMethodCloseToken;
    {* ��ǰ�����Ĺ��̻���}
    property ChildMethodStartToken: TCnPasToken read FChildMethodStartToken;
    {* ��ǰ���ڲ�Ĺ��̻�����������Ƕ�׹��̻�����������}
    property ChildMethodCloseToken: TCnPasToken read FChildMethodCloseToken;
    {* ��ǰ���ڲ�Ĺ��̻�����������Ƕ�׹��̻�����������}
    property BlockStartToken: TCnPasToken read FBlockStartToken;
    {* ��ǰ������}
    property BlockCloseToken: TCnPasToken read FBlockCloseToken;
    {* ��ǰ������}
    property InnerBlockStartToken: TCnPasToken read FInnerBlockStartToken;
    {* ��ǰ���ڲ��}
    property InnerBlockCloseToken: TCnPasToken read FInnerBlockCloseToken;
    {* ��ǰ���ڲ��}
    property CurrentMethod: AnsiString read FCurrentMethod;
    {* ��ǰ�����Ĺ��̻�����}
    property CurrentChildMethod: AnsiString read FCurrentChildMethod;
    {* ��ǰ���ڲ�Ĺ��̻�������������Ƕ�׹��̻�����������}
    property Source: AnsiString read FSource;
    property KeyOnly: Boolean read FKeyOnly;
    {* �Ƿ�ֻ������ؼ���}

    property UseTabKey: Boolean read FUseTabKey write FUseTabKey;
    {* �Ƿ��Ű洦�� Tab ���Ŀ�ȣ��粻������ Tab ��������Ϊ 1 ����}
    property TabWidth: Integer read FTabWidth write FTabWidth;
    {* Tab ���Ŀ��}
  end;

//==============================================================================
// Դ��λ����Ϣ����
//==============================================================================

  // Դ������������
  TCodeAreaKind = (
    akUnknown,         // δ֪��Ч��
    akHead,            // ��Ԫ����֮ǰ
    akUnit,            // ��Ԫ������
    akProgram,         // ������������
    akInterface,       // interface ��
    akIntfUses,        // interface �� uses ��
    akImplementation,  // implementation ��
    akImplUses,        // implementation �� uses ��
    akInitialization,  // initialization ��
    akFinalization,    // finalization ��
    akEnd);            // end. ֮�������

  TCodeAreaKinds = set of TCodeAreaKind;

  // Դ����λ�����ͣ�ͬʱ֧�� Pascal �� C/C++
  TCodePosKind = (
    pkUnknown,         // δ֪��Ч��
    pkFlat,            // ��Ԫ�հ���
    pkComment,         // ע�Ϳ��ڲ�
    pkIntfUses,        // Pascal interface �� uses �ڲ�
    pkImplUses,        // Pascal implementation �� uses �ڲ�
    pkClass,           // Pascal class �����ڲ�
    pkInterface,       // Pascal interface �����ڲ�
    pkType,            // Pascal type ������
    pkConst,           // Pascal const ������
    pkResourceString,  // Pascal resourcestring ������
    pkVar,             // Pascal var ������
    pkCompDirect,      // ����ָ���ڲ�
    pkString,          // �ַ����ڲ�
    pkField,           // ��ʶ��. ��������ڲ������ԡ��������¼�����¼���
    pkProcedure,       // �����ڲ�
    pkFunction,        // �����ڲ�
    pkConstructor,     // �������ڲ�
    pkDestructor,      // �������ڲ�
    pkFieldDot,        // ������ĵ�

    pkDeclaration);    // C�еı���������

  TCodePosKinds = set of TCodePosKind;

  // ��ǰ����λ����Ϣ��ͬʱ֧�� Pascal �� C/C++
  PCodePosInfo = ^TCodePosInfo;
  TCodePosInfo = record
    IsPascal: Boolean;         // �Ƿ��� Pascal �ļ�
    LastIdentPos: Integer;     // ��һ����ʶ��λ��
    LastNoSpace: TTokenKind;   // ��һ���ǿռǺ�����
    LastNoSpacePos: Integer;   // ��һ�ηǿռǺ�λ��
    LineNumber: Integer;       // �к�
    LinePos: Integer;          // ��λ��
    TokenPos: Integer;         // ��ǰ�Ǻ�λ��
    Token: AnsiString;         // ��ǰ�Ǻ�����
    TokenID: TTokenKind;       // ��ǰPascal�Ǻ�����
    CTokenID: TCTokenKind;     // ��ǰC�Ǻ�����
    AreaKind: TCodeAreaKind;   // ��ǰ��������
    PosKind: TCodePosKind;     // ��ǰλ������
  end;

const
  // ���е�λ�ü���
  csAllPosKinds = [Low(TCodePosKind)..High(TCodePosKind)];
  // �Ǵ�������λ�ü���
  csNonCodePosKinds = [pkUnknown, pkComment, pkIntfUses, pkImplUses,
    pkCompDirect, pkString];
  // ������λ�ü���
  csFieldPosKinds = [pkField, pkFieldDot];
  // �����������
  csNormalPosKinds = csAllPosKinds - csNonCodePosKinds - csFieldPosKinds;

function ParsePasCodePosInfo(const Source: AnsiString; CurrPos: Integer;
  FullSource: Boolean = True; IsUtf8: Boolean = False): TCodePosInfo;
{* ����Դ�����е�ǰλ�õ���Ϣ}

procedure ParseUnitUses(const Source: AnsiString; UsesList: TStrings);
{* ����Դ���������õĵ�Ԫ}

implementation

var
  TokenPool: TCnList;

// �óط�ʽ������ PasTokens ���������
function CreatePasToken: TCnPasToken;
begin
  if TokenPool.Count > 0 then
  begin
    Result := TCnPasToken(TokenPool.Last);
    TokenPool.Delete(TokenPool.Count - 1);
  end
  else
    Result := TCnPasToken.Create;
end;

procedure FreePasToken(Token: TCnPasToken);
begin
  if Token <> nil then
  begin
    Token.Clear;
    TokenPool.Add(Token);
  end;
end;

procedure ClearTokenPool;
var
  I: Integer;
begin
  for I := 0 to TokenPool.Count - 1 do
    TObject(TokenPool[I]).Free;
end;

// NextNoJunk����ֻ����ע�ͣ���û��������ָ���������Ӵ˺����ɹ�����ָ��
procedure LexNextNoJunkWithoutCompDirect(Lex: TmwPasLex);
begin
  repeat
    Lex.Next;
  until not (Lex.TokenID in [tkSlashesComment, tkAnsiComment, tkBorComment, tkCRLF,
    tkCRLFCo, tkSpace, tkCompDirect]);
end;

//==============================================================================
// �ṹ����������
//==============================================================================

{ TCnPasStructureParser }

constructor TCnPasStructureParser.Create;
begin
  FList := TCnList.Create;
  FTabWidth := 2;
end;

destructor TCnPasStructureParser.Destroy;
begin
  Clear;
  FList.Free;
  inherited;
end;

procedure TCnPasStructureParser.Clear;
var
  I: Integer;
begin
  for I := 0 to FList.Count - 1 do
    FreePasToken(TCnPasToken(FList[I]));
  FList.Clear;

  FMethodStartToken := nil;
  FMethodCloseToken := nil;
  FChildMethodStartToken := nil;
  FChildMethodCloseToken := nil;
  FBlockStartToken := nil;
  FBlockCloseToken := nil;
  FCurrentMethod := '';
  FCurrentChildMethod := '';
  FSource := '';
end;

function TCnPasStructureParser.GetCount: Integer;
begin
  Result := FList.Count;
end;

function TCnPasStructureParser.GetToken(Index: Integer): TCnPasToken;
begin
  Result := TCnPasToken(FList[Index]);
end;

procedure TCnPasStructureParser.ParseSource(ASource: PAnsiChar; AIsDpr, AKeyOnly:
  Boolean);
var
  Lex: TmwPasLex;
  MethodStack, BlockStack, MidBlockStack: TObjectStack;
  Token, CurrMethod, CurrBlock, CurrMidBlock: TCnPasToken;
  SavePos, SaveLineNumber: Integer;
  IsClassOpen, IsClassDef, IsImpl, IsHelper, IsSealed: Boolean;
  DeclareWithEndLevel: Integer;
  PrevTokenID: TTokenKind;

  function CalcCharIndex(): Integer;
{$IFDEF BDS2009_UP}
  var
    I, Len: Integer;
{$ENDIF}
  begin
{$IFDEF BDS2009_UP}
    if FUseTabKey and (FTabWidth >= 2) then
    begin
      // ������ǰ�����ݽ��� Tab ��չ��
      I := Lex.LinePos;
      Len := 0;
      while ( I < Lex.TokenPos ) do
      begin
        if (ASource[I] = #09) then
          Len := ((Len div FTabWidth) + 1) * FTabWidth
        else
          Inc(Len);
        Inc(I);
      end;
      Result := Len;
    end
    else
{$ENDIF}
      Result := Lex.TokenPos - Lex.LinePos;
  end;

  procedure NewToken;
  var
    Len: Integer;
  begin
    Token := CreatePasToken;
    Token.FTokenPos := Lex.TokenPos;
    
    Len := Lex.TokenLength;
    if Len > CN_TOKEN_MAX_SIZE then
      Len := CN_TOKEN_MAX_SIZE;
    FillChar(Token.FToken[0], SizeOf(Token.FToken), 0);
    CopyMemory(@Token.FToken[0], Lex.TokenAddr, Len);

    // Token.FToken := AnsiString(Lex.Token);
    
    Token.FLineNumber := Lex.LineNumber;
    Token.FCharIndex := CalcCharIndex();
    Token.FTokenID := Lex.TokenID;
    Token.FItemIndex := FList.Count;
    if CurrBlock <> nil then
      Token.FItemLayer := CurrBlock.FItemLayer;
    if CurrMethod <> nil then
      Token.FMethodLayer := CurrMethod.FMethodLayer;
    FList.Add(Token);
  end;

  procedure DiscardToken(Forced: Boolean = False);
  begin
    if AKeyOnly or Forced then
    begin
      FreePasToken(FList[FList.Count - 1]);
      FList.Delete(FList.Count - 1);
    end;
  end;
begin
  Clear;
  Lex := nil;
  MethodStack := nil;
  BlockStack := nil;
  MidBlockStack := nil;
  PrevTokenID := tkProgram;
  
  try
    FSource := ASource;
    FKeyOnly := AKeyOnly;

    MethodStack := TObjectStack.Create;
    BlockStack := TObjectStack.Create;
    MidBlockStack := TObjectStack.Create;

    Lex := TmwPasLex.Create;
    Lex.Origin := PAnsiChar(ASource);

    DeclareWithEndLevel := 0; // Ƕ�׵���Ҫend�Ķ������
    Token := nil;
    CurrMethod := nil;
    CurrBlock := nil;
    CurrMidBlock := nil;
    IsImpl := AIsDpr;
    IsHelper := False;

    while Lex.TokenID <> tkNull do
    begin
      if {IsImpl and } (Lex.TokenID in
        [tkProcedure, tkFunction, tkConstructor, tkDestructor,
        tkInitialization, tkFinalization,
        tkBegin, tkAsm,
        tkCase, tkTry, tkRepeat, tkIf, tkFor, tkWith, tkOn, tkWhile,
        tkRecord, tkObject, tkOf, tkEqual,
        tkClass, tkInterface, tkDispInterface,
        tkExcept, tkFinally, tkElse,
        tkEnd, tkUntil, tkThen, tkDo]) then
      begin
        NewToken;
        case Lex.TokenID of
          tkProcedure, tkFunction, tkConstructor, tkDestructor:
            begin
              // ������ procedure/function ���Ͷ��壬ǰ���� = ��
              // Ҳ������ procedure/function ����������ǰ���� : ��
              // Ҳ��������������������ǰ���� to
              // Ҳ��������������ʵ�֣�ǰ���� := ��ֵ�� ( , �������������ܲ���ȫ
              if IsImpl and ((not (Lex.TokenID in [tkProcedure, tkFunction]))
                or (not (PrevTokenID in [tkEqual, tkColon, tkTo, tkAssign, tkRoundOpen, tkComma])))
                and (DeclareWithEndLevel <= 0) then
              begin
                // DeclareWithEndLevel <= 0 ��ʾֻ���� class/record ����������ڲ�����
                while BlockStack.Count > 0 do
                  BlockStack.Pop;
                CurrBlock := nil;
                Token.FItemLayer := 0;
                Token.FIsMethodStart := True;

                if CurrMethod <> nil then
                begin
                  Token.FMethodLayer := CurrMethod.FMethodLayer + 1;
                  MethodStack.Push(CurrMethod);
                end
                else
                  Token.FMethodLayer := 1;
                CurrMethod := Token;
              end;
            end;
          tkInitialization, tkFinalization:
            begin
              while BlockStack.Count > 0 do
                BlockStack.Pop;
              CurrBlock := nil;
              while MethodStack.Count > 0 do
                MethodStack.Pop;
              CurrMethod := nil;
            end;
          tkBegin, tkAsm:
            begin
              Token.FIsBlockStart := True;
              if (CurrBlock = nil) and (CurrMethod <> nil) then
                Token.FIsMethodStart := True;
              if CurrBlock <> nil then
              begin
                Token.FItemLayer := CurrBlock.FItemLayer + 1;
                BlockStack.Push(CurrBlock);
              end
              else
                Token.FItemLayer := 1;
              CurrBlock := Token;
            end;
          tkCase:
            begin
              if (CurrBlock = nil) or (CurrBlock.TokenID <> tkRecord) then
              begin
                Token.FIsBlockStart := True;
                if CurrBlock <> nil then
                begin
                  Token.FItemLayer := CurrBlock.FItemLayer + 1;
                  BlockStack.Push(CurrBlock);
                end
                else
                  Token.FItemLayer := 1;
                CurrBlock := Token;
              end
              else
                DiscardToken(True);
            end;
          tkTry, tkRepeat, tkIf, tkFor, tkWith, tkOn, tkWhile,
          tkRecord, tkObject:
            begin
              // ������ of object ��������������ǰ���� @@ �͵�label������
              if ((Lex.TokenID <> tkObject) or (PrevTokenID <> tkOf))
                and not (PrevTokenID in [tkAt, tkDoubleAddressOp])
                and not ((Lex.TokenID = tkFor) and IsHelper) then
                // ������ helper �е� for
              begin
                Token.FIsBlockStart := True;
                if CurrBlock <> nil then
                begin
                  Token.FItemLayer := CurrBlock.FItemLayer + 1;
                  BlockStack.Push(CurrBlock);
                  if (CurrBlock.TokenID = tkTry) and (Token.TokenID = tkTry)
                    and (CurrMidBlock <> nil) then
                  begin
                    MidBlockStack.Push(CurrMidBlock);
                    CurrMidBlock := nil;
                  end;
                end
                else
                  Token.FItemLayer := 1;
                CurrBlock := Token;

                if Lex.TokenID = tkRecord then
                begin
                  // ������¼ record����Ϊ record �����ں������ begin end ֮���� end
                  // IsInDeclareWithEnd := True;
                  Inc(DeclareWithEndLevel);
                end;
              end;
              
              if (Lex.TokenID = tkFor) and IsHelper then
                IsHelper := False;
            end;
          tkClass, tkInterface, tkDispInterface:
            begin
              IsHelper := False;
              IsSealed := False;
              IsClassDef := ((Lex.TokenID = tkClass) and Lex.IsClass)
                or ((Lex.TokenID = tkInterface) and Lex.IsInterface) or
                (Lex.TokenID = tkDispInterface);

              // ������ classdef ���� class helper for TObject ������
              if not IsClassDef and (Lex.TokenID = tkClass) and not Lex.IsClass then
              begin
                SavePos := Lex.RunPos;
                SaveLineNumber := Lex.LineNumber;

                LexNextNoJunkWithoutCompDirect(Lex);
                if Lex.TokenID in [tkSymbol, tkIdentifier] then
                begin
                  if LowerCase(Lex.Token) = 'helper' then
                  begin
                    IsClassDef := True;
                    IsHelper := True;
                  end
                  else if LowerCase(Lex.Token) = 'sealed' then
                  begin
                    IsClassDef := True;
                    IsSealed := True;
                  end;     
                end;
                Lex.LineNumber := SaveLineNumber;
                Lex.RunPos := SavePos;
              end;

              IsClassOpen := False;
              if IsClassDef then
              begin
                IsClassOpen := True;
                SavePos := Lex.RunPos;
                SaveLineNumber := Lex.LineNumber;
                LexNextNoJunkWithoutCompDirect(Lex);
                if Lex.TokenID = tkSemiColon then // �Ǹ� class; ����Ҫ end;
                  IsClassOpen := False
                else if IsHelper or IsSealed then
                  LexNextNoJunkWithoutCompDirect(Lex);

                if Lex.TokenID = tkRoundOpen then // �����ţ����ǲ���();
                begin
                  while not (Lex.TokenID in [tkNull, tkRoundClose]) do
                    LexNextNoJunkWithoutCompDirect(Lex);
                  if Lex.TokenID = tkRoundClose then
                    LexNextNoJunkWithoutCompDirect(Lex);
                end;

                if Lex.TokenID = tkSemiColon then
                  IsClassOpen := False
                else if Lex.TokenID = tkFor then
                  IsClassOpen := True;

                // RunPos ���¸�ֵ���ᵼ���Ѿ����Ƶ� LineNumber �ع飬�Ǹ� Bug
                // ����� Lex �� LineNumber ֱ�Ӹ�ֵ���ֲ�֪������ɶ����
                Lex.LineNumber := SaveLineNumber;
                Lex.RunPos := SavePos;
              end;

              if IsClassOpen then // �к������ݣ���Ҫһ�� end
              begin
                Token.FIsBlockStart := True;
                if CurrBlock <> nil then
                begin
                  Token.FItemLayer := CurrBlock.FItemLayer + 1;
                  BlockStack.Push(CurrBlock);
                end
                else
                  Token.FItemLayer := 1;
                CurrBlock := Token;
                // �ֲ���������Ҫ end ����β
                // IsInDeclareWithEnd := True;
                Inc(DeclareWithEndLevel);
              end
              else // Ӳ�޲������ unit �� interface �Լ� class procedure �ȱ�����
                DiscardToken(Token.TokenID in [tkClass, tkInterface]);
            end;
          tkExcept, tkFinally:
            begin
              if (CurrBlock = nil) or (CurrBlock.TokenID <> tkTry) then
                DiscardToken
              else if CurrMidBlock = nil then
              begin
                CurrMidBlock := Token;
              end
              else
                DiscardToken;
            end;
          tkElse:
            begin
              if (CurrBlock = nil) or (PrevTokenID in [tkAt, tkDoubleAddressOp]) then
                DiscardToken
              else if (CurrBlock.TokenID = tkTry) and (CurrMidBlock <> nil) and
                (CurrMidBlock.TokenID = tkExcept) and
                (PrevTokenID in [tkSemiColon, tkExcept]) then
                Token.FItemLayer := CurrBlock.FItemLayer
              else if not ((CurrBlock.TokenID = tkCase)
                and (PrevTokenID = tkSemiColon)) then
                Token.FItemLayer := Token.FItemLayer + 1;
            end;
          tkEnd, tkUntil, tkThen, tkDo:
            begin
              if (CurrBlock <> nil) and not (PrevTokenID in [tkPoint, tkAt, tkDoubleAddressOp]) then
              begin
                if ((Lex.TokenID = tkUntil) and (CurrBlock.TokenID <> tkRepeat))
                  or ((Lex.TokenID = tkThen) and (CurrBlock.TokenID <> tkIf))
                  or ((Lex.TokenID = tkDo) and not (CurrBlock.TokenID in
                  [tkOn, tkWhile, tkWith, tkFor])) then
                begin
                  DiscardToken;
                end
                else
                begin
                  // ���ⲿ�ֹؼ����������������Σ���ֻ��һ��С patch������������
                  Token.FItemLayer := CurrBlock.FItemLayer;
                  Token.FIsBlockClose := True;
                  if (CurrBlock.TokenID = tkTry) and (CurrMidBlock <> nil) then
                  begin
                    if MidBlockStack.Count > 0 then
                      CurrMidBlock := TCnPasToken(MidBlockStack.Pop)
                    else
                      CurrMidBlock := nil;
                  end;
                  if BlockStack.Count > 0 then
                  begin
                    CurrBlock := TCnPasToken(BlockStack.Pop);
                  end
                  else
                  begin
                    CurrBlock := nil;
                    if (CurrMethod <> nil) and (Lex.TokenID = tkEnd) and (DeclareWithEndLevel <= 0) then
                    begin
                      Token.FIsMethodClose := True;
                      if MethodStack.Count > 0 then
                        CurrMethod := TCnPasToken(MethodStack.Pop)
                      else
                        CurrMethod := nil;
                    end;
                  end;
                end;
              end
              else // Ӳ�޲������ unit �� End Ҳ����
                DiscardToken(Token.TokenID = tkEnd);

              if (DeclareWithEndLevel > 0) and (Lex.TokenID = tkEnd) then // �����˾ֲ�����
                Dec(DeclareWithEndLevel);
            end;
        end;
      end
      else
      begin
        if not IsImpl and (Lex.TokenID = tkImplementation) then
          IsImpl := True;

        if (CurrMethod <> nil) and // forward, external ��ʵ�ֲ��֣�ǰ������Ƿֺ�
          (Lex.TokenID in [tkForward, tkExternal]) and (PrevTokenID = tkSemicolon) then
        begin
          CurrMethod.FIsMethodStart := False;
          if AKeyOnly and (CurrMethod.FItemIndex = FList.Count - 1) then
          begin
            FreePasToken(FList[FList.Count - 1]);
            FList.Delete(FList.Count - 1);
          end;
          if MethodStack.Count > 0 then
            CurrMethod := TCnPasToken(MethodStack.Pop)
          else
            CurrMethod := nil;
        end;

        if not AKeyOnly then
          NewToken;
      end;

      PrevTokenID := Lex.TokenID;
      LexNextNoJunkWithoutCompDirect(Lex);
    end;
  finally
    Lex.Free;
    MethodStack.Free;
    BlockStack.Free;
    MidBlockStack.Free;
  end;
end;

procedure TCnPasStructureParser.FindCurrentBlock(LineNumber, CharIndex:
  Integer);
var
  Token: TCnPasToken;
  CurrIndex: Integer;

  procedure _BackwardFindDeclarePos;
  var
    Level: Integer;
    i, NestedProcs: Integer;
    StartInner: Boolean;
  begin
    Level := 0;
    StartInner := True;
    NestedProcs := 1;
    for i := CurrIndex - 1 downto 0 do
    begin
      Token := Tokens[i];
      if Token.IsBlockStart then
      begin
        if StartInner and (Level = 0) then
        begin
          FInnerBlockStartToken := Token;
          StartInner := False;
        end;

        if Level = 0 then
          FBlockStartToken := Token
        else
          Dec(Level);
      end
      else if Token.IsBlockClose then
      begin
        Inc(Level);
      end;

      if Token.IsMethodStart then
      begin
        if Token.TokenID in [tkProcedure, tkFunction, tkConstructor, tkDestructor] then
        begin
          // ���� procedure �����Ӧ�� begin �������� MethodStart�������Ҫ��������
          Dec(NestedProcs);
          if (NestedProcs = 0) and (FChildMethodStartToken = nil) then
            FChildMethodStartToken := Token;
          if Token.MethodLayer = 1 then
          begin
            FMethodStartToken := Token;
            Exit;
          end;
        end
        else if Token.TokenID in [tkBegin, tkAsm] then
        begin
          // �ڿ�Ƕ�������������̵ĵ�������ʱ������������
        end;
      end
      else if Token.IsMethodClose then
        Inc(NestedProcs);

      if Token.TokenID in [tkImplementation] then
      begin
        Exit;
      end;
    end;
  end;

  procedure _ForwardFindDeclarePos;
  var
    Level: Integer;
    i, NestedProcs: Integer;
    EndInner: Boolean;
  begin
    Level := 0;
    EndInner := True;
    NestedProcs := 1;
    for i := CurrIndex to Count - 1 do
    begin
      Token := Tokens[i];
      if Token.IsBlockClose then
      begin
        if EndInner and (Level = 0) then
        begin
          FInnerBlockCloseToken := Token;
          EndInner := False;
        end;

        if Level = 0 then
          FBlockCloseToken := Token
        else
          Dec(Level);
      end
      else if Token.IsBlockStart then
      begin
        Inc(Level);
      end;

      if Token.IsMethodClose then
      begin
        Dec(NestedProcs);
        if Token.MethodLayer = 1 then // ����������� Layer Ϊ 1 �ģ���Ȼ�������
        begin
          FMethodCloseToken := Token;
          Exit;
        end
        else if (NestedProcs = 0) and (FChildMethodCloseToken = nil) then
          FChildMethodCloseToken := Token;
          // �����ͬ��εģ����� ChildMethodClose  
      end
      else if Token.IsMethodStart and (Token.TokenID in [tkProcedure, tkFunction,
        tkConstructor, tkDestructor]) then
      begin
        Inc(NestedProcs);
      end;

      if Token.TokenID in [tkInitialization, tkFinalization] then
      begin
        Exit;
      end;
    end;
  end;

  procedure _FindInnerBlockPos;
  var
    I, Level: Integer;
  begin
    // �˺����� _ForwardFindDeclarePos �� _BackwardFindDeclarePos �����
    if (FInnerBlockStartToken <> nil) and (FInnerBlockCloseToken <> nil) then
    begin
      // ���һ�����˳�
      if FInnerBlockStartToken.ItemLayer = FInnerBlockCloseToken.ItemLayer then
        Exit;
      // ���·��ٽ��� Block ���ܲ�β�һ������Ҫ�Ҹ�һ����εģ��������Ϊ׼

      if FInnerBlockStartToken.ItemLayer > FInnerBlockCloseToken.ItemLayer then
        Level := FInnerBlockCloseToken.ItemLayer
      else
        Level := FInnerBlockStartToken.ItemLayer;

      for I := CurrIndex - 1 downto 0 do
      begin
        Token := Tokens[I];
        if Token.IsBlockStart and (Token.ItemLayer = Level) then
          FInnerBlockStartToken := Token;
      end;
      for i := CurrIndex to Count - 1 do
      begin
        Token := Tokens[i];
        if Token.IsBlockClose and (Token.ItemLayer = Level) then
          FInnerBlockCloseToken := Token;
      end;
    end;
  end;

  function _GetMethodName(StartToken, CloseToken: TCnPasToken): AnsiString;
  var
    i: Integer;
  begin
    Result := '';
    if Assigned(StartToken) and Assigned(CloseToken) then
      for i := StartToken.ItemIndex + 1 to CloseToken.ItemIndex do
      begin
        Token := Tokens[i];
        if (Token.Token = '(') or (Token.Token = ':') or (Token.Token = ';') then
          Break;
        Result := Result + AnsiTrim(Token.Token);
      end;
  end;

begin
  FMethodStartToken := nil;
  FMethodCloseToken := nil;
  FChildMethodStartToken := nil;
  FChildMethodCloseToken := nil;
  FBlockStartToken := nil;
  FBlockCloseToken := nil;
  FInnerBlockCloseToken := nil;
  FInnerBlockStartToken := nil;
  FCurrentMethod := '';
  FCurrentChildMethod := '';
  
  CurrIndex := 0;
  while CurrIndex < Count do
  begin
    // ǰ�ߴ� 0 ��ʼ�����ߴ� 1 ��ʼ�������Ҫ�� 1
    if (Tokens[CurrIndex].LineNumber > LineNumber - 1) then
      Break;

    // ���ݲ�ͬ����ʼ Token���ж�����Ҳ������ͬ
    if Tokens[CurrIndex].LineNumber = LineNumber - 1 then
    begin
      if (Tokens[CurrIndex].TokenID in [tkBegin, tkAsm, tkTry, tkRepeat, tkIf,
        tkFor, tkWith, tkOn, tkWhile, tkCase, tkRecord, tkObject, tkClass,
        tkInterface, tkDispInterface]) and
        (Tokens[CurrIndex].CharIndex > CharIndex ) then // ��ʼ�������ж�
        Break
      else if (Tokens[CurrIndex].TokenID in [tkEnd, tkUntil, tkThen, tkDo]) and
        (Tokens[CurrIndex].CharIndex + Length(Tokens[CurrIndex].Token) > CharIndex ) then
        Break;  //�����������ж�
    end;

    Inc(CurrIndex);
  end;

  if (CurrIndex > 0) and (CurrIndex < Count) then
  begin
    _BackwardFindDeclarePos;
    _ForwardFindDeclarePos;

    _FindInnerBlockPos;
    if not FKeyOnly then
    begin
      FCurrentMethod := _GetMethodName(FMethodStartToken, FMethodCloseToken);
      FCurrentChildMethod := _GetMethodName(FChildMethodStartToken, FChildMethodCloseToken);
    end;
  end;
end;

function TCnPasStructureParser.IndexOfToken(Token: TCnPasToken): Integer;
begin
  Result := FList.IndexOf(Token);
end;

function TCnPasStructureParser.FindCurrentDeclaration(LineNumber, CharIndex: Integer): AnsiString;
var
  Idx: Integer;
begin
  Result := '';
  FindCurrentBlock(LineNumber, CharIndex);
  
  if InnerBlockStartToken <> nil then
  begin
    if InnerBlockStartToken.TokenID in [tkClass, tkInterface, tkRecord,
      tkDispInterface] then
    begin
      // ��ǰ�ҵȺ���ǰ�ı�ʶ��
      Idx := IndexOfToken(InnerBlockStartToken);
      if Idx > 3 then
      begin
        if (InnerBlockStartToken.TokenID = tkRecord)
          and (Tokens[Idx - 1].TokenID = tkPacked) then
          Dec(Idx);
        if Tokens[Idx - 1].TokenID = tkEqual then
          Dec(Idx);
        if Tokens[Idx - 1].TokenID = tkIdentifier then
          Result := Tokens[Idx - 1].Token;
      end;
    end;
  end;
end;

//==============================================================================
// Pascal Դ��λ����Ϣ����
//==============================================================================

function ParsePasCodePosInfo(const Source: AnsiString; CurrPos: Integer;
  FullSource: Boolean = True; IsUtf8: Boolean = False): TCodePosInfo;
var
  IsProgram: Boolean;
  InClass: Boolean;
  ProcStack: TStack;
  ProcIndent: Integer;
  SavePos: TCodePosKind;
  Lex: TmwPasLex;
  Text: AnsiString;

  procedure DoNext(NoJunk: Boolean = False);
  begin
    Result.LastIdentPos := Lex.LastIdentPos;
    Result.LastNoSpace := Lex.LastNoSpace;
    Result.LastNoSpacePos := Lex.LastNoSpacePos;
    Result.LineNumber := Lex.LineNumber;
    Result.LinePos := Lex.LinePos;
    Result.TokenPos := Lex.TokenPos;
    Result.Token := AnsiString(Lex.Token);
    Result.TokenID := Lex.TokenID;
    if NoJunk then
      Lex.NextNoJunk
    else
      Lex.Next;
  end;
begin
  if CurrPos <= 0 then
    CurrPos := MaxInt;
  Lex := nil;
  ProcStack := nil;
  Result.IsPascal := True;

  try
    Lex := TmwPasLex.Create;
    ProcStack := TStack.Create;
{$IFDEF BDS}
    if IsUtf8 then
    begin
      Text := CnUtf8ToAnsi(PAnsiChar(Source));
      CurrPos := Length(CnUtf8ToAnsi(Copy(Source, 1, CurrPos)));
    end
    else
      Text := Source;
{$ELSE}
    Text := Source;
{$ENDIF}
    Lex.Origin := PAnsiChar(Text);

    if FullSource then
    begin
      Result.AreaKind := akHead;
      Result.PosKind := pkUnknown;
    end
    else
    begin
      Result.AreaKind := akImplementation;
      Result.PosKind := pkUnknown;
    end;
    SavePos := pkUnknown;
    IsProgram := False;
    InClass := False;
    ProcIndent := 0;
    while (Lex.TokenPos < CurrPos) and (Lex.TokenID <> tkNull) do
    begin
      // CnDebugger.LogFmt('Token ID %d, %s',[Integer(Lex.TokenID), Lex.Token]);
      case Lex.TokenID of
        tkUnit:
          begin
            IsProgram := False;
            Result.AreaKind := akUnit;
            Result.PosKind := pkFlat;
          end;
        tkProgram, tkLibrary:
          begin
            IsProgram := True;
            Result.AreaKind := akProgram;
            Result.PosKind := pkFlat;
          end;
        tkInterface:
          begin
            if (Result.AreaKind in [akUnit, akProgram]) and not IsProgram then
            begin
              Result.AreaKind := akInterface;
              Result.PosKind := pkFlat;
            end
            else if Lex.IsInterface then
            begin
              Result.PosKind := pkInterface;
              DoNext(True);
              if (Lex.TokenPos < CurrPos) and (Lex.TokenID = tkSemiColon) then
                Result.PosKind := pkType
              else if (Lex.TokenPos < CurrPos) and (Lex.TokenID = tkRoundOpen) then
              begin
                while (Lex.TokenPos < CurrPos) and not (Lex.TokenID in
                  [tkNull, tkRoundClose]) do
                  DoNext;
                if (Lex.TokenPos < CurrPos) and (Lex.TokenID = tkRoundClose) then
                begin
                  DoNext(True);
                  if (Lex.TokenPos < CurrPos) and (Lex.TokenID = tkSemiColon) then
                    Result.PosKind := pkType;
                end;
              end;
              if Result.PosKind = pkInterface then
                InClass := True;
            end;
          end;
        tkUses:
          begin
            if Result.AreaKind in [akProgram, akInterface] then
            begin
              Result.AreaKind := akIntfUses;
              Result.PosKind := pkIntfUses;
            end
            else if Result.AreaKind = akImplementation then
            begin
              Result.AreaKind := akImplUses;
              Result.PosKind := pkIntfUses;
            end;
            if Result.AreaKind in [akIntfUses, akImplUses] then
            begin
              while (Lex.TokenPos < CurrPos) and not (Lex.TokenID in [tkNull, tkSemiColon]) do
                DoNext;
              if (Lex.TokenPos < CurrPos) and (Lex.TokenID = tkSemiColon) then
              begin
                if Result.AreaKind = akIntfUses then
                  Result.AreaKind := akInterface
                else
                  Result.AreaKind := akImplementation;
                Result.PosKind := pkFlat;
              end;
            end;
          end;
        tkImplementation:
          if not IsProgram then
          begin
            Result.AreaKind := akImplementation;
            Result.PosKind := pkFlat;
          end;
        tkInitialization:
          begin
            Result.AreaKind := akInitialization;
            Result.PosKind := pkFlat;
          end;
        tkFinalization:
          begin
            Result.AreaKind := akFinalization;
            Result.PosKind := pkFlat;
          end;
        tkSquareClose:
          if (Lex.Token = '.)') and (Lex.LastNoSpace in [tkIdentifier,
            tkPointerSymbol, tkSquareClose, tkRoundClose]) then
          begin
            if not (Result.PosKind in [pkFieldDot, pkField]) then
              SavePos := Result.PosKind;
            Result.PosKind := pkFieldDot;
          end;
        tkPoint:
          if Lex.LastNoSpace = tkEnd then
          begin
            Result.AreaKind := akEnd;
            Result.PosKind := pkUnknown;
          end
          else if Lex.LastNoSpace in [tkIdentifier, tkPointerSymbol,
            tkSquareClose, tkRoundClose] then
          begin
            if not (Result.PosKind in [pkFieldDot, pkField]) then
              SavePos := Result.PosKind;
            Result.PosKind := pkFieldDot;
          end;
        tkAnsiComment, tkBorComment, tkSlashesComment:
          begin
            if Result.PosKind <> pkComment then
            begin
              SavePos := Result.PosKind;
              Result.PosKind := pkComment;
            end;
          end;
        tkClass:
          begin
            if Lex.IsClass then
            begin
              Result.PosKind := pkClass;
              DoNext(True);
              if (Lex.TokenPos < CurrPos) and (Lex.TokenID = tkSemiColon) then
                Result.PosKind := pkType
              else if (Lex.TokenPos < CurrPos) and (Lex.TokenID = tkRoundOpen) then
              begin
                while (Lex.TokenPos < CurrPos) and not (Lex.TokenID in
                  [tkNull, tkRoundClose]) do
                  DoNext;
                if (Lex.TokenPos < CurrPos) and (Lex.TokenID = tkRoundClose) then
                begin
                  DoNext(True);
                  if (Lex.TokenPos < CurrPos) and (Lex.TokenID = tkSemiColon) then
                    Result.PosKind := pkType
                  else
                  begin
                    InClass := True;
                    Continue;
                  end;
                end;
              end
              else
              begin
                InClass := True;
                Continue;
              end;
            end;
          end;
        tkType:
          Result.PosKind := pkType;
        tkConst:
          if not InClass then
            Result.PosKind := pkConst;
        tkResourceString:
          Result.PosKind := pkResourceString;
        tkVar:
          if not InClass then
            Result.PosKind := pkVar;
        tkCompDirect:
          begin
            if Result.PosKind <> pkCompDirect then
            begin
              SavePos := Result.PosKind;
              Result.PosKind := pkCompDirect;
            end;
          end;
        tkString:
          begin
            if not SameText(string(Lex.Token), 'String') and (Result.PosKind <> pkString) then
            begin
              SavePos := Result.PosKind;
              Result.PosKind := pkString;
            end;
          end;
        tkIdentifier, tkMessage, tkRead, tkWrite, tkDefault, tkIndex:
          if (Lex.LastNoSpace = tkPoint) and (Result.PosKind = pkFieldDot) then
          begin
            Result.PosKind := pkField;
          end;
        tkProcedure, tkFunction, tkConstructor, tkDestructor:
          begin
            if not InClass and (Result.AreaKind in [akProgram, akImplementation]) then
            begin
              ProcIndent := 0;
              if Lex.TokenID = tkProcedure then
                Result.PosKind := pkProcedure
              else if Lex.TokenID = tkFunction then
                Result.PosKind := pkFunction
              else if Lex.TokenID = tkConstructor then
                Result.PosKind := pkConstructor
              else
                Result.PosKind := pkDestructor;
              ProcStack.Push(Pointer(Result.PosKind));
            end;
            // todo: �����������ĺ���
          end;
        tkBegin, tkTry, tkCase, tkAsm, tkRecord:
          begin
            if ProcStack.Count > 0 then
            begin
              Inc(ProcIndent);
              Result.PosKind := TCodePosKind(ProcStack.Peek);
            end;
          end;
        tkEnd:
          begin
            if InClass then
            begin
              Result.PosKind := pkType;
              InClass := False;
            end
            else if ProcStack.Count > 0 then
            begin
              Dec(ProcIndent);
              if ProcIndent <= 0 then
              begin
                ProcStack.Pop;
                Result.PosKind := pkFlat;
              end;
            end;
          end;
      else
        if Result.PosKind in [pkCompDirect, pkComment, pkString, pkField,
          pkFieldDot] then
          Result.PosKind := SavePos;
      end;

      DoNext;
    end;
  finally
    if Lex <> nil then
      Lex.Free;
    if ProcStack <> nil then
      ProcStack.Free;
  end;
end;

// ����Դ���������õĵ�Ԫ
procedure ParseUnitUses(const Source: AnsiString; UsesList: TStrings);
var
  Lex: TmwPasLex;
  Flag: Integer;
{$IFDEF BDS2012_UP}
  I: Integer;
  TempList: TObjectList;
  AUseObj, NextUseObj, Next2UseObj: TCnUseToken;
{$ENDIF}
begin
  UsesList.Clear;
  Lex := TmwPasLex.Create;
{$IFDEF BDS2012_UP}
  TempList := TObjectList.Create(True);
{$ENDIF}
  Flag := 0;
  try
    Lex.Origin := PAnsiChar(Source);
    while Lex.TokenID <> tkNull do
    begin
      if Lex.TokenID = tkUses then
      begin
        while not (Lex.TokenID in [tkNull, tkSemiColon]) do
        begin
          Lex.Next;
{$IFDEF BDS2012_UP}
          if (Lex.TokenID = tkIdentifier) or (Lex.TokenID = tkPoint) then
          begin
            AUseObj := TCnUseToken.Create;
            AUseObj.Token := string(Lex.Token);
            AUseObj.IsImpl := Flag = 1;
            AUseObj.TokenPos := Lex.TokenPos;
            AUseObj.TokenID := Lex.TokenID;
            TempList.Add(AUseObj);
          end;
{$ELSE}
          if Lex.TokenID = tkIdentifier then
          begin
            UsesList.AddObject(string(Lex.Token), TObject(Flag));
          end;
{$ENDIF}
        end;
      end
      else if Lex.TokenID = tkImplementation then
      begin
        Flag := 1;
        // �� Flag ����ʾ interface ���� implementation
      end;
      Lex.Next;
    end;
{$IFDEF BDS2012_UP}
    // XE2 ������ Vcl.Forms ������ uses�������Ҫ�ϲ�
    I := 0;
    while I < TempList.Count do
    begin
      AUseObj := TCnUseToken(TempList.Items[I]);
      if AUseObj.IsImpl then
        Flag := 1
      else
        Flag := 0;

      if (I = TempList.Count - 1) or (I = TempList.Count - 2) then
      begin
        if AUseObj.TokenID = tkIdentifier then
          UsesList.AddObject(AUseObj.Token, TObject(Flag));
      end
      else if (I >= 0) and (I < TempList.Count - 2) then
      begin
        NextUseObj := TCnUseToken(TempList.Items[I + 1]);
        if (NextUseObj.TokenID = tkPoint)
          and (NextUseObj.TokenPos = AUseObj.TokenPos + Length(AUseObj.Token)) then
        begin
          // ����ͺ���ĵ������
          Next2UseObj := TCnUseToken(TempList.Items[I + 2]);
          if (Next2UseObj.TokenID = tkIdentifier)
            and (Next2UseObj.TokenPos = NextUseObj.TokenPos + Length(NextUseObj.Token)) then
          begin
            // ��ͺ���Ľ����ţ�ƴ��һ��
            UsesList.AddObject(AUseObj.Token + '.' + Next2UseObj.Token, TObject(Flag));
            Inc(I, 3);
            Continue;
          end;
        end;

        if AUseObj.TokenID = tkIdentifier then
          UsesList.AddObject(AUseObj.Token, TObject(Flag));
      end;
      Inc(I);
    end;
{$ENDIF}
  finally
{$IFDEF BDS2012_UP}
    TempList.Free;
{$ENDIF}
    Lex.Free;
  end;
end;

{ TCnPasToken }

procedure TCnPasToken.Clear;
begin
  FCppTokenKind := TCTokenKind(0);
  FCharIndex := 0;
  FEditCol := 0;
  FEditLine := 0;
  FItemIndex := 0;
  FItemLayer := 0;
  FLineNumber := 0;
  FMethodLayer := 0;
  FillChar(FToken[0], SizeOf(FToken), 0);
  FTokenID := TTokenKind(0);
  FTokenPos := 0;
  FIsMethodStart := False;
  FIsMethodClose := False;
  FIsBlockStart := False;
  FIsBlockClose := False;
end;

function TCnPasToken.GetToken: PAnsiChar;
begin
  Result := @FToken[0];
end;

initialization
  TokenPool := TCnList.Create;

finalization
  ClearTokenPool;
  FreeAndNil(TokenPool);

end.
