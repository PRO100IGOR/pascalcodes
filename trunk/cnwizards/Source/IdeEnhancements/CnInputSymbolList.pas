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

unit CnInputSymbolList;
{* |<PRE>
================================================================================
* ������ƣ�CnPack IDE ר�Ұ�
* ��Ԫ���ƣ��������ֵ����б��ඨ�嵥Ԫ
* ��Ԫ���ߣ�Johnson Zhong zhongs@tom.com http://www.longator.com
*           �ܾ��� zjy@cnpack.org
* ��    ע�������б��ඨ��
* ����ƽ̨��PWin2000Pro + Delphi 7.1
* ���ݲ��ԣ�
* �� �� �����õ�Ԫ�е��ַ��������ϱ��ػ�����ʽ
* ��Ԫ��ʶ��$Id: CnInputSymbolList.pas 836 2011-07-05 05:59:33Z liuxiao@cnpack.org $
* �޸ļ�¼��2004.11.05
*               ��ֲ����
================================================================================
|</PRE>}

interface

{$I CnWizards.inc}

{$IFDEF CNWIZARDS_CNINPUTHELPER}

uses
  Windows, SysUtils, Classes, Controls, IniFiles, ToolsApi, Psapi, Math,
  Forms, Graphics, Contnrs, TypInfo, CnCommon, CnWizConsts, CnWizOptions,
  CnWizUtils, CnWizIdeUtils, CnPasCodeParser, OmniXML, OmniXMLPersistent,
  OmniXMLUtils, CnWizMacroUtils, CnWizIni;

type

//==============================================================================
// ��������
//==============================================================================

  TSymbolKind = (skUnknown, skConstant, skType, skVariable, skProcedure,
    skFunction, skUnit, skLabel, skProperty, skConstructor, skDestructor,
    skInterface, skEvent, skKeyword, skClass, skTemplate, skCompDirect,
    skComment, skUser);
  {* �������� }
  TSymbolKindSet = set of TSymbolKind;
  {* �������ͼ��� }

  TCnKeywordStyle = (ksDefault, ksLower, ksUpper, ksFirstUpper);
  {* �ؼ��ִ�Сд��ʽ }
  
{ TSymbolItem }

  TSymbolItem = class(TPersistent)
  {* ���ڴ�������ķ����� }
  private
    FDescription: string;
    FDescIsUtf8: Boolean;
    FKind: TSymbolKind;
    FName: string;
    FScope: Integer;
    FScopeHit: Integer;
    FScopeAdjust: Integer;
    FText: string;
    FTag: Integer;
    FHashCode: Cardinal;
    FMatchFirstOnly: Boolean;
    FAutoIndent: Boolean;
    FAlwaysDisp: Boolean;
    function GetScopeRate: Integer;
    function GetText: string;
    procedure SetScopeRate(const Value: Integer);
    function GetAllowMultiLine: Boolean;
    function GetDescription: string;
  protected
    procedure CalcHashCode; virtual;
    procedure OutputLines(Editor: IOTAEditBuffer; Lines: TStrings);
    procedure OutputTemplate(Editor: IOTAEditBuffer; Icon: TIcon);
  public
    constructor Create; virtual;
    procedure Assign(Source: TPersistent); override;
    procedure Output(Editor: IOTAEditBuffer; Icon: TIcon; KeywordStyle:
      TCnKeywordStyle); virtual;
    {* ����ı�������༭�� }
    function GetKeywordText(KeywordStyle: TCnKeywordStyle): string;
    {* ��ָ�����ȡ�ؼ����ı� }

    property HashCode: Cardinal read FHashCode write FHashCode;
    {* ��ʶ�������͵� HashCode ��Ϣ }
    property Tag: Integer read FTag write FTag;
    {* ����������ʹ�õ����ݣ�������ʱ������ʱ�������� }
    property ScopeHit: Integer read FScopeHit write FScopeHit;
    {* ʹ��Ƶ�����ȼ����������������� }
    property ScopeAdjust: Integer read FScopeAdjust write FScopeAdjust;
    {* ����ʹ��Ƶ�ȵ�����������ȼ����������������� }

    property Scope: Integer read FScope write FScope;
    {* ���ŵ����ȼ���0..MaxInt��ԽС��ʾԽ��ǰ }
    property MatchFirstOnly: Boolean read FMatchFirstOnly write FMatchFirstOnly;
    {* �Ƿ�Ҫ���ͷ��ʼƥ�� }
    property AllowMultiLine: Boolean read GetAllowMultiLine;
    {* ��������ı� }
  published
    property Name: string read FName write FName;
    {* ���ŵ����ƣ����û�������ַ��� }
    property Kind: TSymbolKind read FKind write FKind;
    {* ���ŵ����� }
    property Description: string read GetDescription write FDescription;
    {* ���ŵ���������ʾ���б��� }
    property Text: string read GetText write FText;
    {* ʵ�����������༭�����ı� }
    property ScopeRate: Integer read GetScopeRate write SetScopeRate;
    {* ���ŵ����ȼ���0..100��ԽС��ʾԽ��ǰ }
    property AutoIndent: Boolean read FAutoIndent write FAutoIndent;
    {* ����Ƕ����ı�ʱ���Ƿ��Զ��������� }
    property AlwaysDisp: Boolean read FAlwaysDisp write FAlwaysDisp;
    {* �����ı�ȫƥ��ʱ������������������ı� }
  end;

//==============================================================================
// �����б����
//==============================================================================

{ TSymbolList }

  TSymbolList = class(TObject)
  private
    FList: TObjectList;
    FActive: Boolean;
    function GetCount: Integer;
    function GetItem(Index: Integer): TSymbolItem;
  protected
    property List: TObjectList read FList;
  public
    constructor Create; virtual;
    destructor Destroy; override;
    procedure Load; virtual;
    procedure Save; virtual;
    procedure Sort; virtual;
    class function GetListName: string; virtual;
    function Reload(Editor: IOTAEditBuffer; const InputText: string; PosInfo:
      TCodePosInfo): Boolean; virtual;
    procedure GetValidCharSet(var FirstSet, CharSet: TAnsiCharSet; 
      PosInfo: TCodePosInfo); virtual;
    function Add(AItem: TSymbolItem): Integer; overload;
    function Add(const AName: string; AKind: TSymbolKind; AScope: Integer; const 
      ADescription: string = ''; const AText: string = ''; AAutoIndent: Boolean = 
      True; AMatchFirstOnly: Boolean = False; AAlwaysDisp: Boolean = False;
      ADescIsUtf8: Boolean = False): Integer; overload;
    procedure Clear;
    procedure Delete(Index: Integer);
    procedure Remove(AItem: TSymbolItem);
    function IndexOf(const AName: string; AKind: TSymbolKind): Integer;
    function CanCustomize: Boolean; virtual;
    procedure RestoreDefault; virtual;
    property Count: Integer read GetCount;
    property Items[Index: Integer]: TSymbolItem read GetItem;
    property Active: Boolean read FActive write FActive;
  end;

  TSymbolListClass = class of TSymbolList;

//==============================================================================
// �Զ�������б�
//==============================================================================

{ TFileSymbolList }

  TFileSymbolList = class(TSymbolList)
  protected
    function GetReadFileName: string; virtual;
    function GetWriteFileName: string; virtual;
    function GetDataFileName: string; virtual;
  public
    procedure Load; override;
    procedure Save; override;
    function Reload(Editor: IOTAEditBuffer; const InputText: string; PosInfo:
      TCodePosInfo): Boolean; override;
    function CanCustomize: Boolean; override;
    procedure RestoreDefault; override;
  end;

//==============================================================================
// Ԥ��������б�
//==============================================================================

{ TPreDefSymbolList }

  TPreDefSymbolList = class(TFileSymbolList)
  protected
    function GetDataFileName: string; override;
  public
    class function GetListName: string; override;
  end;

//==============================================================================
// Ԥ��������б�
//==============================================================================

{ TUserTemplateList }

  TUserTemplateList = class(TFileSymbolList)
  protected
    function GetDataFileName: string; override;
  public
    class function GetListName: string; override;
  end;

//==============================================================================
// �û���������б�
//==============================================================================

{ TUserSymbolList }

  TUserSymbolList = class(TFileSymbolList)
  protected
    function GetDataFileName: string; override;
  public
    class function GetListName: string; override;
    procedure GetValidCharSet(var FirstSet, CharSet: TAnsiCharSet; 
      PosInfo: TCodePosInfo); override;
  end;

//==============================================================================
// XML ע���б�
//==============================================================================

{ TXMLCommentSymbolList }

  TXMLCommentSymbolList = class(TFileSymbolList)
  protected
    function GetDataFileName: string; override;
  public
    class function GetListName: string; override;
    function Reload(Editor: IOTAEditBuffer; const InputText: string; PosInfo:
      TCodePosInfo): Boolean; override;
    procedure GetValidCharSet(var FirstSet, CharSet: TAnsiCharSet; 
      PosInfo: TCodePosInfo); override;
  end;

//==============================================================================
// JavaDoc ע���б�
//==============================================================================

{ TJavaDocSymbolList }

  TJavaDocSymbolList = class(TFileSymbolList)
  protected
    function GetDataFileName: string; override;
  public
    class function GetListName: string; override;
    function Reload(Editor: IOTAEditBuffer; const InputText: string; PosInfo:
      TCodePosInfo): Boolean; override;
    procedure GetValidCharSet(var FirstSet, CharSet: TAnsiCharSet; PosInfo:
      TCodePosInfo); override;
  end;

//==============================================================================
// ����ָ������б�
//==============================================================================

{ TCompDirectSymbolList }

  TCompDirectSymbolList = class(TSymbolList)
  protected
    procedure AddSection(Ini: TMemIniFile; const Section: string);
  public
    procedure Load; override;
    procedure Save; override;
    class function GetListName: string; override;
    function Reload(Editor: IOTAEditBuffer; const InputText: string; PosInfo:
      TCodePosInfo): Boolean; override;
    procedure GetValidCharSet(var FirstSet, CharSet: TAnsiCharSet; PosInfo:
      TCodePosInfo); override;
  end;

//==============================================================================
// �� uses ��ʹ�õĵ�Ԫ�����б�
//==============================================================================

{ TUnitNameList }

  TUnitNameList = class(TSymbolList)
  private
    FSysPath: string;
    FSysUnits: TStringList;
    FProjectPath: string;
    FProjectUnits: TStringList;
    FUnits: TStringList;
    FCurrList: TStringList;
    procedure AddUnit(const UnitName: string);
    procedure DoFindFile(const FileName: string; const Info: TSearchRec; var Abort: 
      Boolean);
    procedure LoadFromSysPath;
    procedure LoadFromProjectPath;
    procedure LoadFromCurrProject;
    procedure UpdateCaseFromModules(AList: TStringList);
  public
    constructor Create; override;
    destructor Destroy; override;
    class function GetListName: string; override;
    function Reload(Editor: IOTAEditBuffer; const InputText: string; PosInfo:
      TCodePosInfo): Boolean; override;
  end;

//==============================================================================
// ��ǰ��Ԫ���õĵ�Ԫ�����б�
//==============================================================================

{ TUnitUsesList }

  TUnitUsesList = class(TSymbolList)
  public
    class function GetListName: string; override;
    function Reload(Editor: IOTAEditBuffer; const InputText: string; PosInfo:
      TCodePosInfo): Boolean; override;
  end;

//==============================================================================
// ����ģ���б�
//==============================================================================

{ TCodeTemplateList }

  TCodeTemplateList = class(TSymbolList)
  private
    FFileAge: Integer;
  protected
    function GetReadFileName: string; virtual; abstract;
  public
    procedure Load; override;
    function Reload(Editor: IOTAEditBuffer; const InputText: string; PosInfo:
      TCodePosInfo): Boolean; override;
  end;

//==============================================================================
// IDE �Դ��Ĵ���ģ���б�
//==============================================================================

{ TIDECodeTemplateList }

  TIDECodeTemplateList = class(TCodeTemplateList)
  protected
    function GetReadFileName: string; override;
  public
    class function GetListName: string; override; 
  end;

//==============================================================================
// �����б������
//==============================================================================

{ TSymbolListMgr }

  TSymbolListMgr = class(TObject)
  private
    FList: TObjectList;
    function GetCount: Integer;
    function GetList(Index: Integer): TSymbolList;
  public
    constructor Create;
    destructor Destroy; override;
    procedure InitList;
    procedure GetValidCharSet(var FirstSet, CharSet: TAnsiCharSet; 
      PosInfo: TCodePosInfo);
    function ListByClass(AClass: TSymbolListClass): TSymbolList;
    procedure Load;
    procedure Save;
    property List[Index: Integer]: TSymbolList read GetList;
    property Count: Integer read GetCount;
  end;

function GetSymbolKindName(Kind: TSymbolKind): string;
{* ���ط������͵����� }

function ScopeToRate(Scope: Integer): Integer;
function RateToScope(Rate: Integer): Integer;

function SaveListToXMLFile(List: TSymbolList; const FileName: string): Boolean;
function LoadListFromXMLFile(List: TSymbolList; const FileName: string): Boolean;

procedure RegisterSymbolList(AClass: TSymbolListClass);
{* ע��һ�������б��� }

const
  csDefScopeRate = 15;
  csIdentFirstSet: TAnsiCharSet = Alpha;
  csIdentCharSet: TAnsiCharSet = AlphaNumeric;
  csCompDirectFirstSet: TAnsiCharSet = ['{'];
  csCompDirectCharSet: TAnsiCharSet = ['$', '+', '-'] + AlphaNumeric;
  csCommentFirstSet: TAnsiCharSet = ['/'];
  csCommentCharSet: TAnsiCharSet = ['/'] + AlphaNumeric;
  csJavaDocFirstSet: TAnsiCharSet = ['{'];
  csJavaDocTagFirstSet: TAnsiCharSet = ['@'];
  csJavaDocCharSet: TAnsiCharSet = ['*', '-'] + AlphaNumeric;

{$ENDIF CNWIZARDS_CNINPUTHELPER}

implementation

{$IFDEF CNWIZARDS_CNINPUTHELPER}

uses
{$IFDEF DEBUG}
  CnDebug,
{$ENDIF}
  CnCRC32, CnWizMacroText, CnWizMacroFrm;

const
  csCompD5 = 'D5';
  csCompD6 = 'D6';
  csCompD7 = 'D7';
  csCompD8 = 'D8';
  csCompD9 = 'D9';
  csCompD10 = 'D10';
  csCompD11 = 'D11';
  csCompD12 = 'D12';
  csCompUser = 'User';

  csCompDirectScope = MaxInt div 100 * 35;
  csUnitScope = MaxInt div 100 * 30;
  csUsesScope = MaxInt div 100 * 25;
  csTemplateScope = MaxInt div 100 * 20;
  csCommentScope = MaxInt div 100 * 15;
  csDefScope = MaxInt div 100 * csDefScopeRate;

type
  TOmniXMLReaderHack = class(TOmniXMLReader);
  TOmniXMLWriterHack = class(TOmniXMLWriter);

// ���ط������͵�����
function GetSymbolKindName(Kind: TSymbolKind): string;
begin
  Result := Copy(GetEnumName(TypeInfo(TSymbolKind), Ord(Kind)), 3, MaxInt);
end;

function ScopeToRate(Scope: Integer): Integer;
begin
  Result := Round(Scope / MaxInt * 100);
end;

function RateToScope(Rate: Integer): Integer;
begin
  Result := Round(Rate / 100 * MaxInt);
end;

//==============================================================================
// ��������
//==============================================================================

{ TSymbolItem }

constructor TSymbolItem.Create;
begin
  FScope := csDefScope;
  FAutoIndent := True;
  FAlwaysDisp := False;
end;

procedure TSymbolItem.Assign(Source: TPersistent);
begin
  if Source is TSymbolItem then
  begin
    FDescription := TSymbolItem(Source).FDescription;
    FDescIsUtf8 := TSymbolItem(Source).FDescIsUtf8;
    FKind := TSymbolItem(Source).FKind;
    FName := TSymbolItem(Source).FName;
    FScope := TSymbolItem(Source).FScope;
    FScopeAdjust := TSymbolItem(Source).FScopeAdjust;
    FText := TSymbolItem(Source).FText;
    FTag := TSymbolItem(Source).FTag;
    FHashCode := TSymbolItem(Source).FHashCode;
    FMatchFirstOnly := TSymbolItem(Source).FMatchFirstOnly;
    FAutoIndent := TSymbolItem(Source).FAutoIndent;
  end
  else
    inherited;
end;

procedure TSymbolItem.CalcHashCode;
begin
  FHashCode := Ord(FKind);
  FHashCode := StrCRC32(FHashCode, FName);
  FHashCode := StrCRC32(FHashCode, FDescription);
end;

function TSymbolItem.GetScopeRate: Integer;
begin
  Result := ScopeToRate(FScope);
end;

function TSymbolItem.GetText: string;
begin
  if AllowMultiLine then
    Result := FText
  else
    Result := FName;
end;

function TSymbolItem.GetDescription: string;
begin
  if FDescIsUtf8 then
    Result := string(ConvertEditorTextToText(AnsiString(FDescription)))
  else
    Result := FDescription;
end;

procedure TSymbolItem.SetScopeRate(const Value: Integer);
begin
  FScope := RateToScope(Value);
end;

function TSymbolItem.GetAllowMultiLine: Boolean;
begin
  Result := Kind in [skTemplate, skComment];
end;

function TSymbolItem.GetKeywordText(KeywordStyle: TCnKeywordStyle): string;
begin
  Result := Name;
  if (FKind = skKeyword) and (KeywordStyle <> ksDefault) then
  begin
    case KeywordStyle of
      ksLower: Result := LowerCase(Result);
      ksUpper: Result := UpperCase(Result);
      ksFirstUpper:
        begin
          Result := LowerCase(Result);
          if Result <> '' then
            Result[1] := UpCase(Result[1]);
        end;
    end;
  end;
end;

procedure TSymbolItem.OutputLines(Editor: IOTAEditBuffer; Lines: TStrings);
var
  Line: string;
  OrgPos: TOTAEditPos;
  EditPos: TOTAEditPos;
  Relocate: Boolean;
  OffsetX: Integer;
  OffsetY: Integer;
  i: Integer;
begin
  if not AutoIndent then
  begin
    CnOtaInsertTextToCurSource(Lines.Text);
  end
  else
  begin
    OffsetX := 0;
    OffsetY := 0;
    Relocate := False;
    OrgPos := Editor.TopView.CursorPos;
    for i := 0 to Lines.Count - 1 do
    begin
      if i > 0 then
      begin
        EditPos.Col := OrgPos.Col;
        EditPos.Line := OrgPos.Line + i;
        Editor.TopView.CursorPos := EditPos;
      end;

      Line := Lines[i];
      if not Relocate and (Pos('|', Line) > 0) then
      begin
        OffsetX := Pos('|', Line) - 1;
        OffsetY := i;
        Relocate := True;
      end;

      Line := StringReplace(Line, '|', '', [rfReplaceAll]);
      if i < Lines.Count - 1 then
        Line := Line + #13#10;
      CnOtaInsertTextToCurSource(Line);
    end;

    if Relocate then
    begin
      EditPos.Col := OrgPos.Col + OffsetX;
      EditPos.Line := OrgPos.Line + OffsetY;
      Editor.TopView.CursorPos := EditPos;
      Application.ProcessMessages;
      Editor.TopView.Paint;
    end;
  end;
end;

procedure TSymbolItem.OutputTemplate(Editor: IOTAEditBuffer; Icon: TIcon);
var
  OutText: string;
  Lines: TStringList;
  CurrPos: Integer;
  MacroText: TCnWizMacroText;
begin
  OutText := Text;
  if (OutText <> '') and Assigned(Editor) and Assigned(Editor.TopView) then
  begin
    OutText := StringReplace(OutText, GetMacroEx(cwmCursor), '|', [rfReplaceAll]);
    MacroText := TCnWizMacroText.Create(OutText);
    try
      if MacroText.Macros.Count > 0 then
      begin
        if not GetEditorMacroValue(MacroText.Macros, SCnInputHelperName, Icon) then
          Exit;
      end;
      OutText := MacroText.OutputText(CurrPos);
    finally
      MacroText.Free;
    end;

    Lines := TStringList.Create;
    try
      Lines.Text := OutText;
      OutputLines(Editor, Lines);
    finally
      Lines.Free;
    end;
  end;
end;

procedure TSymbolItem.Output(Editor: IOTAEditBuffer; Icon: TIcon; KeywordStyle: 
  TCnKeywordStyle);
var
  S: string;
  Idx: Integer;
begin
  if Assigned(Editor) and Assigned(Editor.EditPosition) then
  begin
    if not AllowMultiLine then
    begin
      S := GetKeywordText(KeywordStyle);
      Idx := Pos('|', S);
      S := StringReplace(S, '|', '', [rfReplaceAll]);
    {$IFDEF UNICODE_STRING}
      Editor.EditPosition.InsertText(string(ConvertTextToEditorText(AnsiString(S))));
    {$ELSE}
      Editor.EditPosition.InsertText(ConvertTextToEditorText(S));
    {$ENDIF}
      Editor.TopView.Paint;
      if Idx > 0 then
        Editor.EditPosition.MoveRelative(0, -(Length(S) - Idx + 1));
    end
    else
    begin
      Editor.TopView.Paint;
      OutputTemplate(Editor, Icon);
    end;        
  end;
end;

//==============================================================================
// �����б����
//==============================================================================

{ TSymbolList }

const
  csXmlRoot = 'Symbols';
  csXmlItem = 'Item';

function SaveListToXMLFile(List: TSymbolList; const FileName: string): Boolean;
var
  Doc: IXMLDocument;
  Root: IXMLElement;
  Node: IXMLElement;
  Writer: TOmniXMLWriterHack;
  i: Integer;
begin
  Result := False;
  if FileName <> '' then
  try
    Doc := CreateXMLDoc;
    Root := Doc.CreateElement(csXmlRoot);
    Doc.DocumentElement := Root;
    
    List.Sort;
    Writer := TOmniXMLWriterHack.Create(Doc);
    try
      for i := 0 to List.Count - 1 do
      begin
        Node := Doc.CreateElement(csXmlItem);
        Writer.Write(List.Items[i], Node, False);
        Root.AppendChild(Node);
      end;
    finally
      Writer.Free;
    end;
    Doc.Save(FileName, ofIndent);
    Result := True;
  except
    ;
  end;
end;

function LoadListFromXMLFile(List: TSymbolList; const FileName: string): Boolean;
var
  Doc: IXMLDocument;
  Root: IXMLElement;
  Item: TSymbolItem;
  i, Idx: Integer;
  Reader: TOmniXMLReaderHack;
begin
  Result := False;
  if FileExists(FileName) then
  try
    Doc := CreateXMLDoc;
    Doc.Load(FileName);
    Root := Doc.DocumentElement;
    if not Assigned(Root) or not SameText(Root.NodeName, csXmlRoot) then
      Exit;

    Reader := TOmniXMLReaderHack.Create(pfNodes);
    try
      for i := 0 to Root.ChildNodes.Length - 1 do
        if SameText(Root.ChildNodes.Item[i].NodeName, csXmlItem) then
        begin
          Item := TSymbolItem.Create;
          try
            Reader.Read(Item, Root.ChildNodes.Item[i] as IXmlElement);
            Item.MatchFirstOnly := Item.Kind in [skCompDirect, skComment];
            Idx := List.IndexOf(Item.Name, Item.Kind);
            if Idx < 0 then
              List.Add(Item)
            else
            begin
              List.Items[Idx].Assign(Item);
              Item.Free;
            end;
          except
            Item.Free;
          end;
        end;
    finally
      Reader.Free;
    end;
    Result := List.Count > 0;
  except
    ;
  end;
end;

// ��������ֵ�������ظ�ֵ
procedure AdjustSymbolListScope(List: TSymbolList);
var
  i: Integer;
begin
  for i := 0 to List.Count - 1 do
    List.Items[i].FScope := RateToScope(List.Items[i].ScopeRate) + i;  
end;

constructor TSymbolList.Create;
begin
  inherited;
  FList := TObjectList.Create;
  FActive := True;
  Load;
end;

destructor TSymbolList.Destroy;
begin
  FList.Free;
  inherited;
end;

function TSymbolList.Add(AItem: TSymbolItem): Integer;
begin
  AItem.CalcHashCode;
  Result := FList.Add(AItem);
end;

function TSymbolList.Add(const AName: string; AKind: TSymbolKind; AScope:
  Integer; const ADescription: string = ''; const AText: string = ''; 
  AAutoIndent: Boolean = True; AMatchFirstOnly: Boolean = False; 
  AAlwaysDisp: Boolean = False; ADescIsUtf8: Boolean = False): Integer;
var
  Item: TSymbolItem;
begin
  Item := TSymbolItem.Create;
  Item.Name := AName;
  Item.Description := ADescription;
  if AText = '' then
    Item.Text := AName
  else
    Item.Text := AText;
  Item.Kind := AKind;
  Item.Scope := AScope;
  Item.AutoIndent := AAutoIndent;
  if not (Item.Kind in [Low(TSymbolKind)..High(TSymbolKind)]) then
    Item.Kind := skUnknown;
  Item.MatchFirstOnly := AMatchFirstOnly;
  Item.AlwaysDisp := AAlwaysDisp;
  Item.FDescIsUtf8 := ADescIsUtf8;
  Item.CalcHashCode;
  Result := FList.Add(Item);
end;

procedure TSymbolList.Clear;
begin
  FList.Clear;
end;

procedure TSymbolList.Delete(Index: Integer);
begin
  FList.Delete(Index);
end;

procedure TSymbolList.Remove(AItem: TSymbolItem);
begin
  FList.Remove(AItem);
end;

function TSymbolList.IndexOf(const AName: string; AKind: TSymbolKind): Integer;
var
  i: Integer;
begin
  for i := 0 to Count - 1 do
    if (AKind = Items[i].Kind) and (CompareStr(Items[i].Name, AName) = 0) then
    begin
      Result := i;
      Exit;
    end;
  Result := -1;
end;

function TSymbolList.GetCount: Integer;
begin
  Result := FList.Count;
end;

function TSymbolList.GetItem(Index: Integer): TSymbolItem;
begin
  Result := TSymbolItem(FList[Index]);
end;

class function TSymbolList.GetListName: string;
begin
  Result := RemoveClassPrefix(ClassName);
end;

function TSymbolList.Reload(Editor: IOTAEditBuffer; const InputText: string;
  PosInfo: TCodePosInfo): Boolean;
begin
  Result := Count > 0;
end;

procedure TSymbolList.GetValidCharSet(var FirstSet, CharSet: TAnsiCharSet; 
  PosInfo: TCodePosInfo);
begin
  FirstSet := csIdentFirstSet;
  CharSet := csIdentCharSet;
end;

function TSymbolList.CanCustomize: Boolean;
begin
  Result := False;
end;

procedure TSymbolList.RestoreDefault;
begin

end;

function DoListSort(Item1, Item2: Pointer): Integer;
begin
  Result := CompareText(TSymbolItem(Item1).Name, TSymbolItem(Item2).Name);
end;  

procedure TSymbolList.Sort;
begin
  FList.Sort(DoListSort);
end;

procedure TSymbolList.Load;
begin

end;

procedure TSymbolList.Save;
begin

end;

//==============================================================================
// �Զ�������б�
//==============================================================================

{ TFileSymbolList }

function TFileSymbolList.CanCustomize: Boolean;
begin
  Result := True;
end;

function TFileSymbolList.GetDataFileName: string;
begin

end;

function TFileSymbolList.GetReadFileName: string;
begin
  Result := WizOptions.GetUserFileName(GetDataFileName, True);
end;

function TFileSymbolList.GetWriteFileName: string;
begin
  Result := WizOptions.GetUserFileName(GetDataFileName, False);
end;

procedure TFileSymbolList.Load;
begin
  Clear;
  LoadListFromXMLFile(Self, GetReadFileName);
  AdjustSymbolListScope(Self);
end;

function TFileSymbolList.Reload(Editor: IOTAEditBuffer;
  const InputText: string; PosInfo: TCodePosInfo): Boolean;
begin
  Result := PosInfo.PosKind in (csNormalPosKinds + [pkCompDirect, pkComment]);
end;

procedure TFileSymbolList.RestoreDefault;
begin
  DeleteFile(WizOptions.UserPath + GetDataFileName);
  Load;
end;

procedure TFileSymbolList.Save;
begin
  SaveListToXMLFile(Self, GetWriteFileName);
  WizOptions.CheckUserFile(GetDataFileName);
end;

//==============================================================================
// Ԥ��������б�
//==============================================================================

{ TPreDefSymbolList }

class function TPreDefSymbolList.GetListName: string;
begin
  Result := SCnInputHelperPreDefSymbolList;
end;

function TPreDefSymbolList.GetDataFileName: string;
begin
  Result := SCnPreDefSymbolsFile;
end;

{ TUserTemplateList }

class function TUserTemplateList.GetListName: string;
begin
  Result := SCnInputHelperUserTemplateList;
end;

function TUserTemplateList.GetDataFileName: string;
begin
  Result := SCnCodeTemplateFile;
end;

//==============================================================================
// ����ָ������б�
//==============================================================================

{ TCompDirectSymbolList }

procedure TCompDirectSymbolList.GetValidCharSet(var FirstSet, 
  CharSet: TAnsiCharSet; PosInfo: TCodePosInfo);
begin
  FirstSet := csCompDirectFirstSet;
  CharSet := csCompDirectCharSet;
end;

procedure TCompDirectSymbolList.AddSection(Ini: TMemIniFile; const Section: string);
var
  Names: TStringList;
  i: Integer;
  Desc: string;
begin
  Names := TStringList.Create;
  try
    Ini.ReadSection(Section, Names);
    for i := 0 to Names.Count - 1 do
    begin
      Desc := Trim(Ini.ReadString(Section, Names[i], ''));
      Add(Names[i], skCompDirect, csCompDirectScope, Desc, Names[i], True, True);
    end;
  finally
    Names.Free;
  end;
end;

procedure TCompDirectSymbolList.Load;
var
  Ini: TMemIniFile;
begin
  Clear;
  Ini := TMemIniFile.Create(WizOptions.DataPath + SCnCompDirectDataFile);
  try
  {$IFDEF DELPHI5_UP} AddSection(Ini, csCompD5); {$ENDIF}
  {$IFDEF DELPHI6_UP} AddSection(Ini, csCompD6); {$ENDIF}
  {$IFDEF DELPHI7_UP} AddSection(Ini, csCompD7); {$ENDIF}
  {$IFDEF DELPHI8_UP} AddSection(Ini, csCompD8); {$ENDIF}
  {$IFDEF DELPHI9_UP} AddSection(Ini, csCompD9); {$ENDIF}
  {$IFDEF DELPHI10_UP} AddSection(Ini, csCompD10); {$ENDIF}
  {$IFDEF DELPHI11_UP} AddSection(Ini, csCompD11); {$ENDIF}
  {$IFDEF DELPHI12_UP} AddSection(Ini, csCompD12); {$ENDIF}
  finally
    Ini.Free;
  end;
  AdjustSymbolListScope(Self);
end;

function TCompDirectSymbolList.Reload(Editor: IOTAEditBuffer;
  const InputText: string; PosInfo: TCodePosInfo): Boolean;
begin
  Result := PosInfo.PosKind in (csNormalPosKinds + [pkCompDirect]);
end;

procedure TCompDirectSymbolList.Save;
begin
  // do nothing
end;

class function TCompDirectSymbolList.GetListName: string;
begin
  Result := SCnInputHelperCompDirectSymbolList;
end;

//==============================================================================
// �û��Զ�������б�
//==============================================================================

{ TUserSymbolList }

class function TUserSymbolList.GetListName: string;
begin
  Result := SCnInputHelperUserSymbolList;
end;

function TUserSymbolList.GetDataFileName: string;
begin
  Result := SCnUserSymbolsFile;
end;

procedure TUserSymbolList.GetValidCharSet(var FirstSet,
  CharSet: TAnsiCharSet; PosInfo: TCodePosInfo);
begin
  FirstSet := csIdentFirstSet + csCompDirectFirstSet + csCommentFirstSet;
  CharSet := csIdentCharSet + csCompDirectCharSet + csCommentCharSet;
end;

//==============================================================================
// XML ע���б�
//==============================================================================

{ TXMLCommentSymbolList }

class function TXMLCommentSymbolList.GetListName: string;
begin
  Result := SCnInputHelperXMLCommentList;
end;

function TXMLCommentSymbolList.GetDataFileName: string;
begin
  Result := SCnXmlCommentDataFile;
end;

procedure TXMLCommentSymbolList.GetValidCharSet(var FirstSet,
  CharSet: TAnsiCharSet; PosInfo: TCodePosInfo);
begin
  FirstSet := csCommentFirstSet;
  CharSet := csCommentCharSet; 
end;

function TXMLCommentSymbolList.Reload(Editor: IOTAEditBuffer;
  const InputText: string; PosInfo: TCodePosInfo): Boolean;
begin
  Result := PosInfo.PosKind in (csNormalPosKinds + [pkComment]);
end;

//==============================================================================
// JavaDoc ע���б�
//==============================================================================

{ TJavaDocSymbolList }

class function TJavaDocSymbolList.GetListName: string;
begin
  Result := SCnInputHelperJavaDocList;
end;

function TJavaDocSymbolList.GetDataFileName: string;
begin
  Result := SCnJavaDocDataFile;
end;

procedure TJavaDocSymbolList.GetValidCharSet(var FirstSet,
  CharSet: TAnsiCharSet; PosInfo: TCodePosInfo);
begin
  if PosInfo.PosKind in [pkComment] then
  begin
    FirstSet := csJavaDocFirstSet + csJavaDocTagFirstSet;
  end
  else
  begin
    FirstSet := csJavaDocFirstSet;
  end;
  CharSet := csJavaDocCharSet;
end;

function TJavaDocSymbolList.Reload(Editor: IOTAEditBuffer;
  const InputText: string; PosInfo: TCodePosInfo): Boolean;
begin
  Result := PosInfo.PosKind in [pkComment];
end;

//==============================================================================
// �� uses ��ʹ�õĵ�Ԫ�����б�
//==============================================================================

{ TUnitNameList }

constructor TUnitNameList.Create;
begin
  inherited;
  FSysUnits := TStringList.Create;
  FProjectUnits := TStringList.Create;
  FUnits := TStringList.Create;
  FCurrList := nil;
  FSysUnits.Sorted := True;
  FProjectUnits.Sorted := True;
  FUnits.Sorted := True;
  LoadFromSysPath;
end;

destructor TUnitNameList.Destroy;
begin
  FProjectUnits.Free;
  FSysUnits.Free;
  FUnits.Free;
  inherited;
end;

class function TUnitNameList.GetListName: string;
begin
  Result := SCnInputHelperUnitNameList;
end;

procedure TUnitNameList.AddUnit(const UnitName: string);
begin
  if FUnits.IndexOf(UnitName) < 0 then
  begin
    FUnits.Add(UnitName);
    Add(UnitName, skUnit, csUnitScope);
  end;
end;

procedure TUnitNameList.LoadFromCurrProject;
var
  ProjectGroup: IOTAProjectGroup;
  Project: IOTAProject;
  FileName: string;
  i, j: Integer;
begin
  ProjectGroup := CnOtaGetProjectGroup;
  if Assigned(ProjectGroup) then
  begin
    for i := 0 to ProjectGroup.GetProjectCount - 1 do
    begin
      Project := ProjectGroup.Projects[i];
      if Assigned(Project) then
      begin
        for j := 0 to Project.GetModuleCount - 1 do
        begin
          FileName := Project.GetModule(j).FileName;
          if IsPas(FileName) or IsDcu(FileName) then
            AddUnit(ChangeFileExt(ExtractFileName(FileName), ''));
        end;
      end;
    end;
  end;
end;

procedure TUnitNameList.DoFindFile(const FileName: string; const Info:
  TSearchRec; var Abort: Boolean);
var
  S: string;
begin
  S := ChangeFileExt(Info.Name, '');
  if IsValidIdent(StringReplace(S, '.', '', [rfReplaceAll])) and (FCurrList.IndexOf(S) < 0) then
    FCurrList.Add(S);
end;

procedure TUnitNameList.LoadFromSysPath;
var
  i: Integer;
  Paths: TStringList;
begin
  Paths := TStringList.Create;
  try
    Paths.Sorted := True;
    GetLibraryPath(Paths, False);
    if not SameText(Paths.Text, FSysPath) then
    begin
      FSysUnits.Clear;
      FCurrList := FSysUnits;
      for i := 0 to Paths.Count - 1 do
        FindFile(Paths[i], '*.pas', DoFindFile, nil, False, False);

      FindFile(MakePath(GetInstallDir) + 'Lib\', '*.dcu', DoFindFile, nil,
        False, False);
      UpdateCaseFromModules(FSysUnits);
      FSysPath := Paths.Text;
    end;
  finally
    Paths.Free;
  end;

  for i := 0 to FSysUnits.Count - 1 do
    AddUnit(FSysUnits[i]);
end;

procedure TUnitNameList.LoadFromProjectPath;
var
  i: Integer;
  Paths: TStringList;
begin
  Paths := TStringList.Create;
  try
    Paths.Sorted := True;
    GetProjectLibPath(Paths);
    if not SameText(Paths.Text, FProjectPath) then
    begin
      FProjectUnits.Clear;
      FCurrList := FProjectUnits;
      for i := 0 to Paths.Count - 1 do
        FindFile(Paths[i], '*.pas', DoFindFile, nil, False, False);
      UpdateCaseFromModules(FProjectUnits);
      FProjectPath := Paths.Text;
    end;
  finally
    Paths.Free;
  end;

  for i := 0 to FProjectUnits.Count - 1 do
    AddUnit(FProjectUnits[i]);
end;

type
  PUnitsInfoRec = ^TUnitsInfoRec;
  TUnitsInfoRec = record
    Sorted: TStringList;
    Unsorted: TStringList;
  end;

procedure GetInfoProc(const Name: string; NameType: TNameType; Flags: Byte;
  Param: Pointer);
var
  Idx: Integer;
begin
  // ����Ԫ���滻����ȷ�Ĵ�Сд��ʽ
  if NameType = ntContainsUnit then
  begin
    Idx := PUnitsInfoRec(Param).Sorted.IndexOf(Name);
    if Idx >= 0 then
      PUnitsInfoRec(Param).Unsorted[Idx] := Name;
  end;
end;

function GetModuleProc(HInstance: THandle; Data: Pointer): Boolean;
var
  Flags: Integer;
begin
  Result := True;
  try
    if FindResource(HInstance, 'PACKAGEINFO', RT_RCDATA) <> 0 then
      GetPackageInfo(HInstance, Data, Flags, GetInfoProc);
  except
    ;
  end;
end;

// �����ļ�����õĵ�Ԫ����Сд���ܲ���ȷ���˴�ͨ������ IDE ģ��������
procedure TUnitNameList.UpdateCaseFromModules(AList: TStringList);
var
  Data: TUnitsInfoRec;
begin
  { Use a sorted StringList for searching and copy this list to an unsorted list
    which is manipulated in GetInfoProc(). After that the unsorted list is
    copied back to the original sorted list. BinSearch is a lot faster than
    linear search. (by AHUser) }
  Data.Sorted := AList;
  Data.Unsorted := TStringList.Create;
  try
    Data.Unsorted.Assign(AList);
    EnumModules(GetModuleProc, @Data);
  finally
    AList.Sorted := False;
    AList.Assign(Data.Unsorted);
    AList.Sorted := True;
    Data.Unsorted.Free;
  end;
end;

function TUnitNameList.Reload(Editor: IOTAEditBuffer; const InputText: string;
  PosInfo: TCodePosInfo): Boolean;
begin
  Result := False;
  try
    if PosInfo.PosKind in [pkIntfUses, pkImplUses] then
    begin
      FUnits.Clear;
      Clear;
      LoadFromCurrProject;
      LoadFromSysPath;
      LoadFromProjectPath;
      AdjustSymbolListScope(Self);
      Result := True;
    end;
  except
    ;
  end;            
end;

//==============================================================================
// ��ǰ��Ԫ���õĵ�Ԫ�����б�
//==============================================================================

{ TUnitUsesList }

class function TUnitUsesList.GetListName: string;
begin
  Result := SCnInputHelperUnitUsesList;
end;

function TUnitUsesList.Reload(Editor: IOTAEditBuffer; const InputText: string;
  PosInfo: TCodePosInfo): Boolean;
const
  csMaxProcessLines = 2048;
var
  View: IOTAEditView;
  Stream: TMemoryStream;
  UsesList: TStringList;
  i: Integer;
begin
  Result := False;
  try
    Clear;
    View := CnOtaGetTopMostEditView;
    Result := (PosInfo.PosKind in csNormalPosKinds) and Assigned(View) and
      (View.Buffer.GetLinesInBuffer <= csMaxProcessLines);
    if Result then
    begin
      Stream := TMemoryStream.Create;
      try
        CnOtaSaveCurrentEditorToStream(Stream, False);
        UsesList := TStringList.Create;
        try
          ParseUnitUses(PAnsiChar(Stream.Memory), UsesList);
          for i := 0 to UsesList.Count - 1 do
            Add(UsesList[i], skUnit, csUsesScope);
          AdjustSymbolListScope(Self);
        finally
          UsesList.Free;
        end;
      finally
        Stream.Free;
      end;
    end;
  except
    ;
  end;          
end;

//==============================================================================
// ����ģ���б�
//==============================================================================

{ TCodeTemplateList }

procedure TCodeTemplateList.Load;
var
  Lines: TStringList;
  StrList: TStringList;
  i: Integer;
  FileName: string;
  Text: string;
  Line: string;
  Name: string;
  Desc: string;
  LangName: string;

  function IsTempleteCaption(const AText: string): Boolean;
  begin
    Result := (AText <> '') and (AText[1] = '[') and (AText[Length(AText)] = ']');
  end;
begin
  FileName := GetReadFileName;
{$IFDEF DEBUG}
  CnDebugger.LogMsg('TCodeTemplateList.Load: ' + FileName);
{$ENDIF}
  if FileExists(FileName) and (FileAge(FileName) <> FFileAge) then
  begin
    Clear;
    Lines := TStringList.Create;
    try
      Lines.LoadFromFile(FileName);
    {$IFDEF DEBUG}
      CnDebugger.LogStrings(Lines, 'Lines');
    {$ENDIF}

      i := 0;
      while i < Lines.Count - 1 do
      begin
        Line := Lines[i];
        if IsTempleteCaption(Line) then
        begin
          // ȡ��ģ�����ơ�����������
          Line := Copy(Line, 2, Length(Line) - 2); // ɾ�����ߵ� [] ��
          StrList := TStringList.Create;
          try
            Line := StringReplace(Line, ' | ', CRLF, [rfReplaceAll]);
            StrList.Text := StringReplace(Line, '|', CRLF, [rfReplaceAll]);
            Name := '';
            Desc := '';
            LangName := '';
            if StrList.Count > 0 then
              Name := StrList[0];
            if StrList.Count > 1 then
              Desc := StrList[1];
            if StrList.Count > 2 then
              LangName := Trim(StrList[2]);
          finally
            StrList.Free;
          end;

          // ȡ��ģ������
          Text := '';
          Inc(i);
          while (i < Lines.Count - 1) and not IsTempleteCaption(Lines[i]) do
          begin
            if Text <> '' then
              Text := Text + CRLF;
            Text := Text + Lines[i];
            Inc(i);
          end;

          if (Name <> '') and ((LangName = '') or SameText(LangName,
            'Borland.EditOptions.Pascal')) then
            Add(Name, skTemplate, csTemplateScope, Desc, Text, True);
        end
        else
          Inc(i);
      end;
    finally
      Lines.Free;
    end;
    FFileAge := FileAge(FileName);
  end;
end;

function TCodeTemplateList.Reload(Editor: IOTAEditBuffer;
  const InputText: string; PosInfo: TCodePosInfo): Boolean;
begin
  Result := PosInfo.PosKind in csNormalPosKinds;
  if Result then
  begin
    Load;
  end;
end;

//==============================================================================
// IDE �Դ��Ĵ���ģ���б�
//==============================================================================

{ TIDECodeTemplateList }

class function TIDECodeTemplateList.GetListName: string;
begin
  Result := SCnInputHelperIDECodeTemplateList;
end;

function TIDECodeTemplateList.GetReadFileName: string;
begin
{$IFDEF BDS}
  // C:\Documents and Settings\Administrator\Local Settings\Application Data\Borland\BDS\3.0\bds.dci
  Result := MakePath(GetBDSUserDataDir) + 'bds.dci';
  // c:\Program Files\CodeGear\RAD Studio\5.0\ObjRepos\bds.dci
  if not FileExists(Result) then
    Result := ExtractFilePath(ExtractFileDir(Application.ExeName)) + 'ObjRepos\bds.dci';
{$ELSE}
{$IFDEF BCB}
  Result := ExtractFilePath(Application.ExeName) + 'bcb.dci';
{$ELSE}
  Result := ExtractFilePath(Application.ExeName) + 'delphi32.dci';
{$ENDIF}
{$ENDIF}
end;

//==============================================================================
// �����б������
//==============================================================================

{ TSymbolListMgr }

var
  SymbolListClassList: TClassList;

procedure RegisterSymbolList(AClass: TSymbolListClass);
begin
  if SymbolListClassList = nil then
    SymbolListClassList := TClassList.Create;
  if SymbolListClassList.IndexOf(AClass) < 0 then
    SymbolListClassList.Add(AClass);
end;

constructor TSymbolListMgr.Create;
begin
  inherited;
  FList := TObjectList.Create;
end;

destructor TSymbolListMgr.Destroy;
begin
  FList.Free;
  inherited;
end;

function TSymbolListMgr.GetCount: Integer;
begin
  Result := FList.Count;
end;

function TSymbolListMgr.GetList(Index: Integer): TSymbolList;
begin
  Result := TSymbolList(FList[Index]);
end;

procedure TSymbolListMgr.InitList;
var
  i: Integer;
begin
  FList.Clear;
  if SymbolListClassList <> nil then
  begin
    for i := 0 to SymbolListClassList.Count - 1 do
    begin
    {$IFDEF DEBUG}
      CnDebugger.LogMsg('Create SymbolList: ' + SymbolListClassList[i].ClassName);
    {$ENDIF}
      try
        FList.Add(TSymbolListClass(SymbolListClassList[i]).Create);
      except
      {$IFDEF DEBUG}
        on E: Exception do
          CnDebugger.LogMsg('Create SymbolList Error: ' + E.Message);
      {$ENDIF}
      end;
    end;
  end;
end;

procedure TSymbolListMgr.GetValidCharSet(var FirstSet, CharSet: TAnsiCharSet; 
  PosInfo: TCodePosInfo);
var
  i: Integer;
  F, C: TAnsiCharSet;
begin
  FirstSet := [];
  CharSet := [];
  for i := 0 to Count - 1 do
  begin
    if List[i].Active then
    begin
      List[i].GetValidCharSet(F, C, PosInfo);
      FirstSet := FirstSet + F;
      CharSet := CharSet + C;
    end;
  end;
end;

function TSymbolListMgr.ListByClass(AClass: TSymbolListClass): TSymbolList;
var
  i: Integer;
begin
  Result := nil;
  for i := 0 to Count - 1 do
    if List[i].ClassType = AClass then
    begin
      Result := List[i];
      Exit;
    end;
end;

procedure TSymbolListMgr.Load;
var
  i: Integer;
begin
  for i := 0 to Count - 1 do
    List[i].Load;
end;

procedure TSymbolListMgr.Save;
var
  i: Integer;
begin
  for i := 0 to Count - 1 do
    List[i].Save;
end;

initialization
  RegisterSymbolList(TPreDefSymbolList);
  RegisterSymbolList(TUserTemplateList);
  RegisterSymbolList(TCompDirectSymbolList);
  RegisterSymbolList(TXMLCommentSymbolList);
  RegisterSymbolList(TJavaDocSymbolList);
  RegisterSymbolList(TUnitNameList);
  RegisterSymbolList(TUnitUsesList);
  RegisterSymbolList(TIDECodeTemplateList);
  RegisterSymbolList(TUserSymbolList);

finalization
{$IFDEF DEBUG}
  CnDebugger.LogEnter('CnInputSymbolList finalization.');
{$ENDIF}

  FreeAndNil(SymbolListClassList);

{$IFDEF DEBUG}
  CnDebugger.LogLeave('CnInputSymbolList finalization.');
{$ENDIF}

{$ENDIF CNWIZARDS_CNINPUTHELPER}
end.

