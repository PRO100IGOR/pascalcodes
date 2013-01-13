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

unit CnBookmarkWizard;
{ |<PRE>
================================================================================
* ������ƣ�CnPack IDE ר�Ұ�
* ��Ԫ���ƣ���ǩ�������ר�ҵ�Ԫ
* ��Ԫ���ߣ��ܾ��� (zjy@cnpack.org)
* ��    ע��
* ����ƽ̨��PWin2000Pro + Delphi 5.01
* ���ݲ��ԣ�PWin9X/2000/XP + Delphi 5/6/7 + C++Builder 5/6
* �� �� �����ô����е��ַ��������ϱ��ػ�����ʽ
* ��Ԫ��ʶ��$Id: CnBookmarkWizard.pas 763 2011-02-07 14:18:23Z liuxiao@cnpack.org $
* �޸ļ�¼��2008.06.28 V1.2
*               �ۺϴ��� Close all ʱ��رձ�ǩҳʱ֪ͨ�����⣬��л Chide Ng
*           2002.12.10 V1.2
*               ����98/Me��RichEdit��˸������
*           2002.11.23 V1.1
*               Դ�������������ʾ��ǩ��
*           2002.11.20 V1.0
*               ������Ԫ
================================================================================
|</PRE>}

interface

{$I CnWizards.inc}

{$IFDEF CNWIZARDS_CNBOOKMARKWIZARD}

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, ComCtrls, ExtCtrls, Math, ToolWin, ImgList, ToolsAPI, IniFiles,
  CnWizClasses, CnWizNotifier, CnWizMultiLang, CnWizIdeDock, Contnrs;

type

//==============================================================================
// ��ǩ�������
//==============================================================================

{ TCnBookmarkForm }

  TCnBookmarkWizard = class;

  TCnEditorObj = class
  public
    FileName: string;
    List: TObjectList;
    constructor Create;
    destructor Destroy; override;
  end;

  TCnBookmarkObj = class
    Parent: TCnEditorObj;
    BookmarkID: Integer;
    Pos: TOTACharPos;
    Line: string;
    constructor Create(AParent: TCnEditorObj);
  end;

  TCnBookmarkForm = class(TCnIdeDockForm)
    ToolBar: TToolBar;
    tbGoto: TToolButton;
    tbHelp: TToolButton;
    StatusBar: TStatusBar;
    cbbUnit: TComboBox;
    Panel1: TPanel;
    Splitter: TSplitter;
    ListView: TListView;
    RichEdit: TRichEdit;
    tbConfig: TToolButton;
    ToolButton3: TToolButton;
    btnRefresh: TToolButton;
    tbClose: TToolButton;
    ToolButton1: TToolButton;
    ToolButton2: TToolButton;
    ToolButton4: TToolButton;
    btnDelete: TToolButton;
    tmrRefresh: TTimer;
    procedure cbbUnitChange(Sender: TObject);
    procedure ListViewChange(Sender: TObject; Item: TListItem;
      Change: TItemChange);
    procedure ListViewDblClick(Sender: TObject);
    procedure tbConfigClick(Sender: TObject);
    procedure FormKeyPress(Sender: TObject; var Key: Char);
    procedure tbHelpClick(Sender: TObject);
    procedure tbCloseClick(Sender: TObject);
    procedure UpdateAll(Sender: TObject);
    procedure btnDeleteClick(Sender: TObject);
    procedure FormHide(Sender: TObject);
    procedure FormShow(Sender: TObject);
  private
    { Private declarations }
    List: TObjectList;
    UpdateCount: Integer;
    Wizard: TCnBookmarkWizard;
    SaveAllUnit: Boolean;
    SaveFileName: string;
    SaveBookmark: Integer;
    procedure SortList(AList: TObjectList);
    function UpdateBookmarkList: Boolean;
    function GetBufferFromFile(const AFileName: string): IOTAEditBuffer;
    procedure UpdateComboBox;
    procedure UpdateListView;
    procedure UpdateStatusBar;
    procedure UpdatePreview;
  protected
    Editor: IOTASourceEditor;
    APos: TOTACharPos;
    function GetHelpTopic: string; override;
    procedure DoLoadWindowState(Desktop: TCustomIniFile); override;
    procedure DoSaveWindowState(Desktop: TCustomIniFile; IsProject: Boolean); override;
    procedure DoLanguageChanged(Sender: TObject); override;
  public
    { Public declarations }
    procedure UpdateConfig;
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
  end;

//==============================================================================
// ��ǩ���ר��
//==============================================================================

{ TCnBookmarkWizard }

  TCnBookmarkWizard = class(TCnMenuWizard)
  private
    FDispLines: Integer;
    FSaveBookmark: Boolean;
    FSourceFont: TFont;
    FHighlightFont: TFont;
    FAutoRefresh: Boolean;
    FRefreshInterval: Integer;
    procedure SourceEditorNotifier(SourceEditor: IOTASourceEditor;
      NotifyType: TCnWizSourceEditorNotifyType; EditView: IOTAEditView);
    procedure LoadBookmark(SourceEditor: IOTASourceEditor);
    procedure SaveBookmark(SourceEditor: IOTASourceEditor);
    function FindSection(Ini: TCustomIniFile; const FileName: string;
      var Section: string): Boolean;
    function CharPosToStr(CharPos: TOTACharPos): string;
    function StrToCharPos(Str: string): TOTACharPos;
    procedure ClearInvalidBookmarks(Ini: TCustomIniFile);
  protected
    function GetHasConfig: Boolean; override;
    function DoConfig: Boolean;
    procedure SetActive(Value: Boolean); override;
  public
    constructor Create; override;
    destructor Destroy; override;
    procedure Config; override;
    procedure LoadSettings(Ini: TCustomIniFile); override;
    procedure SaveSettings(Ini: TCustomIniFile); override;
    function GetState: TWizardState; override;
    class procedure GetWizardInfo(var Name, Author, Email, Comment: string); override;
    function GetCaption: string; override;
    function GetHint: string; override;
    function GetDefShortCut: TShortCut; override;
    procedure Execute; override;
  end;

{$ENDIF CNWIZARDS_CNBOOKMARKWIZARD}

implementation

{$IFDEF CNWIZARDS_CNBOOKMARKWIZARD}

uses
{$IFDEF DEBUG}
  CnDebug,
{$ENDIF}
  CnIni, CnWizUtils, CnWizConsts, CnConsts, CnCommon, CnWizOptions,
  CnBookmarkConfigFrm, CnWizShareImages, CnWizManager;

{$R *.DFM}

var
  CnBookmarkForm: TCnBookmarkForm = nil;

const
  csDispLines = 'DispLines';
  csSaveBookmark = 'SaveBookmark';
  csBookmark = 'Bookmark';
  csFileName = 'FileName';
  csSourceFont = 'Font.Source';
  csHighlightFont = 'Font.Highlight';
  csAutoRefresh = 'AutoRefresh';
  csRefreshInterval = 'RefreshInterval';
  csItem = 'Item';

  csBrowseForm = 'CnBookmarkForm';
  csEditHeight = 'EditHeight';
  csColumnWidth = 'ColumnWidth';

//==============================================================================
// ��ǩ���ר��
//==============================================================================

{ TCnBookmarkWizard }

constructor TCnBookmarkWizard.Create;
var
  Options: IOTAEditOptions;
begin
  inherited;
  FSourceFont := TFont.Create;
  Options := CnOtaGetEditOptions;
  if Assigned(Options) then
    FSourceFont.Name := Options.FontName;
  FSourceFont.Size := 9;
  FHighlightFont := TFont.Create;
  FHighlightFont.Assign(FSourceFont);
  FHighlightFont.Color := clTeal;
  FAutoRefresh := True;
  FRefreshInterval := 1000;
  CnWizNotifierServices.AddSourceEditorNotifier(SourceEditorNotifier);
  IdeDockManager.RegisterDockableForm(TCnBookmarkForm, CnBookmarkForm,
    csBrowseForm);
end;

destructor TCnBookmarkWizard.Destroy;
begin
  IdeDockManager.UnRegisterDockableForm(CnBookmarkForm, csBrowseForm);
  if CnBookmarkForm <> nil then
  begin
    CnBookmarkForm.Free;
    CnBookmarkForm := nil;
  end;
  CnWizNotifierServices.RemoveSourceEditorNotifier(SourceEditorNotifier);
  FHighlightFont.Free;
  FSourceFont.Free;
  inherited;
end;

procedure TCnBookmarkWizard.Execute;
begin
  if CnBookmarkForm = nil then
    CnBookmarkForm := TCnBookmarkForm.Create(nil);
  IdeDockManager.ShowForm(CnBookmarkForm);
end;

function TCnBookmarkWizard.CharPosToStr(CharPos: TOTACharPos): string;
begin
  Result := Format('%d,%d', [CharPos.Line, CharPos.CharIndex]);
end;

function TCnBookmarkWizard.StrToCharPos(Str: string): TOTACharPos;
var
  i: Integer;
begin
  i := Pos(',', Str);
  Result.Line := StrToIntDef(Trim(Copy(Str, 1, i - 1)), 0);
  Result.CharIndex := StrToIntDef(Trim(Copy(Str, i + 1, Length(Str) - i - 1)), 0);
end;

function TCnBookmarkWizard.FindSection(Ini: TCustomIniFile;
  const FileName: string; var Section: string): Boolean;
var
  Sections: TStrings;
  i: Integer;
begin
  Result := False;
  Sections := TStringList.Create;
  try
    Ini.ReadSections(Sections);
    for i := 0 to Sections.Count - 1 do
      if Pos(csItem, Sections[i]) > 0 then
        if SameFileName(Ini.ReadString(Sections[i], csFileName, ''), FileName) then
        begin
          Section := Sections[i];
          Result := True;
          Break;
        end;
    if not Result then
    begin
      i := 0;
      while True do
      begin
        Section := csItem + IntToStr(i);
        if Ini.SectionExists(Section) then
          Inc(i)
        else
          Break;
      end;
    end;
  finally
    Sections.Free;
  end;
end;

procedure TCnBookmarkWizard.LoadBookmark(SourceEditor: IOTASourceEditor);
var
  i: Integer;
  View: IOTAEditView;
  Pos: TOTACharPos;
  EditPos, SavePos: TOTAEditPos;
  Ini: TCustomIniFile;
  Section: string;
begin
{$IFDEF DEBUG}
  CnDebugger.LogEnter('TCnBookmarkWizard.LoadBookmark');
  if SourceEditor.GetEditViewCount = 0 then
    CnDebugger.LogMsgWithType('SourceEditor.GetEditViewCount = 0', cmtWarning);
{$ENDIF}
  if Active and FileExists(SourceEditor.FileName) and
    (SourceEditor.GetEditViewCount > 0) then
  begin
    Ini := CreateIniFile;
    try
      if FindSection(Ini, SourceEditor.FileName, Section) then
      begin
      {$IFDEF DEBUG}
        CnDebugger.LogMsg('Load bookmark: ' + SourceEditor.FileName);
        CnDebugger.LogMsg('Section: ' + Section);
      {$ENDIF}
        View := SourceEditor.EditViews[0];
        SavePos := View.CursorPos;
        for i := 0 to 9 do
        begin
          Pos := StrToCharPos(Ini.ReadString(Section, csBookmark + IntToStr(i), ''));
          if (Pos.CharIndex <> 0) or (Pos.Line <> 0) then
          begin
            EditPos.Col := Pos.CharIndex + 1;
            EditPos.Line := Pos.Line;
            View.SetCursorPos(EditPos);
            View.BookmarkRecord(i);
          end;
        end;
        View.SetCursorPos(SavePos);
      end;
    finally
      Ini.Free;
    end;
  end;
{$IFDEF DEBUG}
  CnDebugger.LogLeave('TCnBookmarkWizard.LoadBookmark');
{$ENDIF}
end;

procedure TCnBookmarkWizard.SaveBookmark(SourceEditor: IOTASourceEditor);
var
  i: Integer;
  View: IOTAEditView;
  Pos: TOTACharPos;
  Ini: TCustomIniFile;
  FileNameSaved: Boolean;
  Section: string;
begin
{$IFDEF DEBUG}
  CnDebugger.LogEnter('TCnBookmarkWizard.SaveBookmark');
  if SourceEditor.GetEditViewCount = 0 then
    CnDebugger.LogMsgWithType('SourceEditor.GetEditViewCount = 0', cmtWarning);
{$ENDIF}
  if Active and FileExists(SourceEditor.FileName) and
    (SourceEditor.GetEditViewCount > 0) then
  begin
    View := SourceEditor.EditViews[0];
    Ini := CreateIniFile;
    try
      if FindSection(Ini, SourceEditor.FileName, Section) then
        Ini.EraseSection(Section); // ����Ѿ���������ɾ��
      FileNameSaved := False;
      for i := 0 to 9 do
      begin
        Pos := View.BookmarkPos[i];
        if (Pos.CharIndex <> 0) or (Pos.Line <> 0) then
        begin
          if not FileNameSaved then
          begin
          {$IFDEF DEBUG}
            CnDebugger.LogMsg('Save bookmark: ' + SourceEditor.FileName);
            CnDebugger.LogMsg('Section: ' + Section);
          {$ENDIF}
            Ini.WriteString(Section, csFileName, SourceEditor.FileName);
            FileNameSaved := True;
          end;
          Ini.WriteString(Section, csBookmark + IntToStr(i), CharPosToStr(Pos));
        end;
      end;
    finally
      Ini.Free;
    end;
  end;
{$IFDEF DEBUG}
  CnDebugger.LogLeave('TCnBookmarkWizard.SaveBookmark');
{$ENDIF}
end;

procedure TCnBookmarkWizard.SourceEditorNotifier(SourceEditor: IOTASourceEditor;
  NotifyType: TCnWizSourceEditorNotifyType; EditView: IOTAEditView);
begin
  if not Active then Exit;

  if FSaveBookmark then
  begin
    if NotifyType = setOpened then
      LoadBookmark(SourceEditor)
    else if NotifyType in [setEditViewRemove, setClosing] then
      SaveBookmark(SourceEditor);
  end;
  // setEditViewRemove setClosing ����Ҫ��
  // setEditViewRemove Ŀ���Ǳܿ��ر� dpk ʱ Closing ��֪ͨʱ EditView �Ѿ��رյ����⡣
  // setClosing Ŀ���Ǳ��� Close All ʱ������ setEditViewRemove �¼���©������
  // ��Ȼ���ܶ����Щ����Ҫ�ı��棬�����۲���

  if Assigned(CnBookmarkForm) and (NotifyType in [setOpened, setEditViewRemove, setClosing]) then
    CnWizNotifierServices.ExecuteOnApplicationIdle(CnBookmarkForm.UpdateAll);
end;

procedure TCnBookmarkWizard.ClearInvalidBookmarks(Ini: TCustomIniFile);
var
  Sections: TStrings;
  i: Integer;
begin
  Sections := TStringList.Create;
  try
    Ini.ReadSections(Sections);
    for i := 0 to Sections.Count - 1 do
      if Pos(csItem, Sections[i]) > 0 then  // ����ļ������ڵı�ǩ
        if not FileExists(Ini.ReadString(Sections[i], csFileName, '')) then
          Ini.EraseSection(Sections[i]);
  finally
    Sections.Free;
  end;
end;

procedure TCnBookmarkWizard.LoadSettings(Ini: TCustomIniFile);
begin
  inherited;
  with TCnIniFile.Create(Ini) do
  try
    FDispLines := ReadInteger('', csDispLines, 2);
    FSaveBookmark := ReadBool('', csSaveBookmark, True);
    FSourceFont := ReadFont('', csSourceFont, FSourceFont);
    FHighlightFont := ReadFont('', csHighlightFont, FHighlightFont);
    FAutoRefresh := ReadBool('', csAutoRefresh, FAutoRefresh);
    FRefreshInterval := ReadInteger('', csRefreshInterval, FRefreshInterval);
  finally
    Free;
  end;
end;

procedure TCnBookmarkWizard.SaveSettings(Ini: TCustomIniFile);
begin
  inherited;
  with TCnIniFile.Create(Ini) do
  try
    WriteInteger('', csDispLines, FDispLines);
    WriteBool('', csSaveBookmark, FSaveBookmark);
    WriteFont('', csSourceFont, FSourceFont);
    WriteFont('', csHighlightFont, FHighlightFont);
    WriteBool('', csAutoRefresh, FAutoRefresh);
    WriteInteger('', csRefreshInterval, FRefreshInterval);
    ClearInvalidBookmarks(Ini);
  finally
    Free;
  end;
end;

function TCnBookmarkWizard.DoConfig: Boolean;
begin
  Result := ShowBookmarkConfigForm(FDispLines, FSaveBookmark, FAutoRefresh,
    FRefreshInterval, FSourceFont, FHighlightFont);
  if Result then
  begin
    DoSaveSettings;
    if Assigned(CnBookmarkForm) then
      CnBookmarkForm.UpdateConfig;
  end;
end;

procedure TCnBookmarkWizard.Config;
begin
  inherited;
  DoConfig;
end;

procedure TCnBookmarkWizard.SetActive(Value: Boolean);
begin
  if Value <> Active then
  begin
    inherited;
    if Value then
    begin
      IdeDockManager.RegisterDockableForm(TCnBookmarkForm, CnBookmarkForm,
        csBrowseForm);
    end
    else
    begin
      IdeDockManager.UnRegisterDockableForm(CnBookmarkForm, csBrowseForm);
      if Assigned(CnBookmarkForm) then
        FreeAndNil(CnBookmarkForm);
    end;
  end;
end;

function TCnBookmarkWizard.GetCaption: string;
begin
  Result := SCnBookmarkWizardMenuCaption;
end;

function TCnBookmarkWizard.GetDefShortCut: TShortCut;
begin
  Result := 0;
end;

function TCnBookmarkWizard.GetHasConfig: Boolean;
begin
  Result := True;
end;

function TCnBookmarkWizard.GetHint: string;
begin
  Result := SCnBookmarkWizardMenuHint;
end;

function TCnBookmarkWizard.GetState: TWizardState;
begin
  Result := [wsEnabled];
end;

class procedure TCnBookmarkWizard.GetWizardInfo(var Name, Author, Email, Comment: string);
begin
  Name := SCnBookmarkWizardName;
  Author := SCnPack_Zjy;
  Email := SCnPack_ZjyEmail;
  Comment := SCnBookmarkWizardComment;
end;

//==============================================================================
// ��ǩ�������
//==============================================================================

{ TCnEditorObj }

constructor TCnEditorObj.Create;
begin
  inherited Create;
  List := TObjectList.Create;
end;

destructor TCnEditorObj.Destroy;
begin
  List.Free;
  inherited;
end;

{ TCnBookmarkObj }

constructor TCnBookmarkObj.Create(AParent: TCnEditorObj);
begin
  inherited Create;
  Parent := AParent;
end;

{ TCnBookmarkForm }

constructor TCnBookmarkForm.Create(AOwner: TComponent);
begin
{$IFDEF DEBUG}
  CnDebugger.LogMsg('TCnBookmarkForm.Create');
{$ENDIF}
  inherited;
  List := TObjectList.Create;
  Wizard := TCnBookmarkWizard(CnWizardMgr.WizardByClass(TCnBookmarkWizard));
  Icon := Wizard.Icon;
  ShowHint := WizOptions.ShowHint;
end;

destructor TCnBookmarkForm.Destroy;
begin
  List.Free;
  CnBookmarkForm := nil;
  inherited;
{$IFDEF DEBUG}
  CnDebugger.LogMsg('TCnBookmarkForm.Destroy');
{$ENDIF}
end;

procedure TCnBookmarkForm.FormShow(Sender: TObject);
begin
  inherited;
  UpdateConfig;
  UpdateAll(nil);
  UpdateStatusBar;
end;

procedure TCnBookmarkForm.FormHide(Sender: TObject);
begin
  inherited;
  tmrRefresh.Enabled := False;
end;

procedure TCnBookmarkForm.FormKeyPress(Sender: TObject; var Key: Char);
begin
  if Key = #13 then
    ListViewDblClick(nil);
end;

function DoSort(Item1, Item2: Pointer): Integer;
begin
  Result := CompareText(TCnEditorObj(Item1).FileName, TCnEditorObj(Item2).FileName);
end;

procedure TCnBookmarkForm.SortList(AList: TObjectList);
begin
  AList.Sort(DoSort);
end;

function TCnBookmarkForm.GetBufferFromFile(
  const AFileName: string): IOTAEditBuffer;
var
  Editor: IOTAEditor;
begin
  Result := nil;
  Editor := CnOtaGetEditor(AFileName);
  if Assigned(Editor) then
    Supports(Editor, IOTAEditBuffer, Result); 
end;

function TCnBookmarkForm.UpdateBookmarkList: Boolean;
var
  EditorObj: TCnEditorObj;
  BkObj: TCnBookmarkObj;
  i, j, k: Integer;
  ModuleSvcs: IOTAModuleServices;
  Module: IOTAModule;
  Buffer: IOTAEditBuffer;
  Pos: TOTACharPos;
  NewList: TObjectList;

  function SameEditorList(List1, List2: TObjectList): Boolean;
  var
    i, j: Integer;
    Edt1, Edt2: TCnEditorObj;
    Bk1, Bk2: TCnBookmarkObj;
  begin
    if List1.Count <> List2.Count then
    begin
      Result := False;
      Exit;
    end;

    for i := 0 to List1.Count - 1 do
    begin
      Edt1 := TCnEditorObj(List1[i]);
      Edt2 := TCnEditorObj(List2[i]);
      if not SameText(Edt1.FileName, Edt2.FileName) or
        (Edt1.List.Count <> Edt2.List.Count) then
      begin
        Result := False;
        Exit;
      end;

      for j := 0 to Edt1.List.Count - 1 do
      begin
        Bk1 := TCnBookmarkObj(Edt1.List[j]);
        Bk2 := TCnBookmarkObj(Edt2.List[j]);
        if (Bk1.BookmarkID <> Bk2.BookmarkID) or
          not SameCharPos(Bk1.Pos, Bk2.Pos) then
        begin
          Result := False;
          Exit;
        end;  
      end;
    end;
    Result := True;
  end;
begin
  Result := False;
  if not QuerySvcs(BorlandIDEServices, IOTAModuleServices, ModuleSvcs) then
    Exit;

  NewList := TObjectList.Create;
  try
    try
      for i := 0 to ModuleSvcs.ModuleCount - 1 do
      begin
        Module := ModuleSvcs.Modules[i];
        for j := 0 to Module.GetModuleFileCount - 1 do
        begin
          if Supports(Module.GetModuleFileEditor(j), IOTAEditBuffer, Buffer) then
          begin
            EditorObj := nil;
            if Assigned(Buffer.TopView) then
            begin
              for k := 0 to 9 do
              begin
                Pos := Buffer.TopView.BookmarkPos[k];
                if (Pos.CharIndex <> 0) or (Pos.Line <> 0) then
                begin
                  if EditorObj = nil then
                  begin
                    EditorObj := TCnEditorObj.Create;
                    EditorObj.FileName := Buffer.FileName;
                    NewList.Add(EditorObj);
                  end;
                  BkObj := TCnBookmarkObj.Create(EditorObj);
                  BkObj.BookmarkID := k;
                  BkObj.Pos := Pos;
                  BkObj.Line := CnOtaGetLineText(Pos.Line, Buffer);
                  EditorObj.List.Add(BkObj);
                end;
              end;
            end;
          end;
        end;
      end;
      SortList(NewList);

      Result := not SameEditorList(List, NewList);
      if Result then
      begin
        List.Clear;
        while NewList.Count > 0 do
          List.Add(NewList.Extract(NewList.First));
      end;
    except
      ;
    end;
  finally
    NewList.Free;
  end;
end;

procedure TCnBookmarkForm.UpdateComboBox;
var
  Editor: TCnEditorObj;
  i, Idx: Integer;
begin
  if UpdateCount > 0 then Exit;
  Inc(UpdateCount);
  try
    cbbUnit.Clear;
    cbbUnit.Items.Add(SCnBookmarkAllUnit);
    Idx := 0;
    for i := 0 to List.Count - 1 do
    begin
      Editor := TCnEditorObj(List[i]);
      cbbUnit.Items.Add(ExtractFileName(Editor.FileName));
      if not SaveAllUnit and (CompareText(Editor.FileName, SaveFileName) = 0) then
        Idx := i + 1;
    end;
    cbbUnit.ItemIndex := Idx;
  finally
    Dec(UpdateCount);
  end;
  UpdateListView;
end;

procedure TCnBookmarkForm.UpdateListView;
var
  i: Integer;
  Editor: TCnEditorObj;
  NewSel: TListItem;

  procedure AddEditor(AEditor: TCnEditorObj);
  var
    i: Integer;
    BkObj: TCnBookmarkObj;
    Item: TListItem;
  begin
    for i := 0 to AEditor.List.Count - 1 do
    begin
      BkObj := TCnBookmarkObj(AEditor.List[i]);
      Item := ListView.Items.Add;
      with Item do
      begin
        Caption := ExtractFileName(AEditor.FileName);
        SubItems.Add(IntToStr(BkObj.BookmarkID));
        SubItems.Add(IntToStr(BkObj.Pos.Line));
        SubItems.Add(BkObj.Line);
        Data := BkObj;
      end;
      if SameText(AEditor.FileName, SaveFileName) and
        (BkObj.BookmarkID = SaveBookmark) then
        NewSel := Item;
    end;
  end;
begin
  if UpdateCount > 0 then Exit;
  Inc(UpdateCount);
  ListView.Items.BeginUpdate;
  try
    ListView.Items.Clear;
    NewSel := nil;
    if cbbUnit.ItemIndex <= 0 then
    begin
      for i := 0 to List.Count - 1 do
        AddEditor(TCnEditorObj(List[i]));
    end
    else
    begin
      Editor := TCnEditorObj(List[cbbUnit.ItemIndex - 1]);
      AddEditor(Editor);
    end;
  finally
    ListView.Items.EndUpdate;
    Dec(UpdateCount);
  end;
  
  if NewSel <> nil then
    ListView.Selected := NewSel
  else if ListView.Items.Count > 0 then
    ListView.Selected := ListView.TopItem
  else
    UpdatePreview;
end;

procedure TCnBookmarkForm.UpdateStatusBar;
begin
  if cbbUnit.ItemIndex <= 0 then
    StatusBar.SimpleText := Format(SCnBookmarkFileCount, [List.Count])
  else
    StatusBar.SimpleText := TCnEditorObj(List[cbbUnit.ItemIndex
      - 1]).FileName;
end;

procedure TCnBookmarkForm.cbbUnitChange(Sender: TObject);
begin
  UpdateListView;
  UpdateStatusBar;
end;

procedure TCnBookmarkForm.ListViewChange(Sender: TObject; Item: TListItem;
  Change: TItemChange);
begin
  UpdatePreview;
end;

procedure TCnBookmarkForm.UpdatePreview;
var
  Line1, Line2, Line3: string;
  Buffer: IOTAEditBuffer;
begin
  if UpdateCount > 0 then Exit;
  RichEdit.Perform(WM_SETREDRAW, 0, 0);
  try
    RichEdit.Clear;
    if Assigned(ListView.Selected) then
    with TCnBookmarkObj(ListView.Selected.Data) do
    begin
      Buffer := GetBufferFromFile(Parent.FileName);
      if Assigned(Buffer) then
      begin
        Line1 := CnOtaGetLineText(Pos.Line - Wizard.FDispLines, Buffer,
          Wizard.FDispLines);
        Line2 := CnOtaGetLineText(Pos.Line, Buffer, 1);
        Line3 := CnOtaGetLineText(Pos.Line + 1, Buffer, Wizard.FDispLines);

        if Length(Line1) > 0 then
        begin
          RichEdit.SelAttributes.Assign(Wizard.FSourceFont);
          try
            RichEdit.Lines.Add(Line1);
          except
            ;
          end;
        end;

        RichEdit.SelAttributes.Assign(Wizard.FHighlightFont);
        try
          RichEdit.Lines.Add(Line2);
        except
          ;
        end;

        if Length(Line3) > 0 then
        begin
          RichEdit.SelAttributes.Assign(Wizard.FSourceFont);
          try
            RichEdit.Lines.Add(Line3);
          except
            ;
          end;
        end;
      end;
    end;
  finally
    RichEdit.Perform(WM_SETREDRAW, 1, 0);
    RichEdit.Invalidate;
  end;
end;

procedure TCnBookmarkForm.UpdateConfig;
begin
  UpdatePreview;
  tmrRefresh.Enabled := Wizard.FAutoRefresh;
  tmrRefresh.Interval := Wizard.FRefreshInterval;
end;

procedure TCnBookmarkForm.UpdateAll(Sender: TObject);
begin
  SaveAllUnit := cbbUnit.ItemIndex <= 0;
  if ListView.Selected <> nil then
  begin
    with TCnBookmarkObj(ListView.Selected.Data) do
    begin
      SaveFileName := Parent.FileName;
      SaveBookmark := BookmarkID;
    end;
  end
  else
  begin
    SaveFileName := '';
    SaveBookmark := -1;
  end;
  
  if UpdateBookmarkList then
  begin
    UpdateComboBox;
    UpdateListView;
    UpdateStatusBar;
  end;    
end;

procedure TCnBookmarkForm.ListViewDblClick(Sender: TObject);
var
  CharPos: TOTACharPos;
  EditPos: TOTAEditPos;
  Buffer: IOTAEditBuffer;
begin
  if Assigned(ListView.Selected) then
  begin
    Buffer := GetBufferFromFile(TCnBookmarkObj(ListView.Selected.Data).Parent.FileName);
    if Assigned(Buffer) and Assigned(Buffer.TopView) then
    begin
      CharPos := TCnBookmarkObj(ListView.Selected.Data).Pos;
      Buffer.TopView.ConvertPos(False, EditPos, CharPos);
      Buffer.TopView.SetCursorPos(EditPos);
      Buffer.TopView.Center(EditPos.Line, EditPos.Col);
      CnOtaMakeSourceVisible(Buffer.FileName);
    end;      
  end;
end;

procedure TCnBookmarkForm.btnDeleteClick(Sender: TObject);
var
  i: Integer;
  BkObj: TCnBookmarkObj;
  SavePos: TOTAEditPos;
  EditPos: TOTAEditPos;
  Buffer: IOTAEditBuffer;
  View: IOTAEditView;
  BkID: Integer;
begin
  if (ListView.SelCount > 1) and not QueryDlg(SCnDeleteConfirm) then
    Exit;

  for i := ListView.Items.Count - 1 downto 0 do
  begin
    if ListView.Items[i].Selected then
    begin
      BkObj := TCnBookmarkObj(ListView.Items[i].Data);
      Buffer := GetBufferFromFile(BkObj.Parent.FileName);
      if Assigned(Buffer) and Assigned(Buffer.TopView) then
      begin
        View := Buffer.TopView;
        BkID := BkObj.BookmarkID;
        SavePos := View.CursorPos;
        if View.BookmarkPos[BkID].Line > 0 then
        begin
          EditPos := View.CursorPos;
          EditPos.Line := View.BookmarkPos[BkID].Line;
          View.CursorPos := EditPos;
          View.BookmarkToggle(BkID);
        end;
        View.CursorPos := SavePos;
        View.Paint;
      end;
      BkObj.Parent.List.Remove(BkObj);
      ListView.Items.Delete(i);
    end;
  end;
end;

procedure TCnBookmarkForm.tbConfigClick(Sender: TObject);
begin
  Wizard.DoConfig;
end;

procedure TCnBookmarkForm.tbCloseClick(Sender: TObject);
begin
  Close;
end;

procedure TCnBookmarkForm.tbHelpClick(Sender: TObject);
begin
  ShowFormHelp;
end;

procedure TCnBookmarkForm.DoLoadWindowState(Desktop: TCustomIniFile);
begin
  inherited;
  RichEdit.Height := Desktop.ReadInteger(csBrowseForm, csEditHeight, RichEdit.Height);
  SetListViewWidthString(ListView, Desktop.ReadString(csBrowseForm, csColumnWidth, ''));
end;

procedure TCnBookmarkForm.DoSaveWindowState(Desktop: TCustomIniFile;
  IsProject: Boolean);
begin
  inherited;
  Desktop.WriteInteger(csBrowseForm, csEditHeight, RichEdit.Height);
  Desktop.WriteString(csBrowseForm, csColumnWidth, GetListViewWidthString(ListView));
end;

procedure TCnBookmarkForm.DoLanguageChanged(Sender: TObject);
var
  Save: Integer;
begin
  inherited;
  if cbbUnit.Items.Count > 0 then
  begin
    Inc(UpdateCount);
    try
      Save := cbbUnit.ItemIndex;
      cbbUnit.Items[0] := SCnBookmarkAllUnit;
      cbbUnit.ItemIndex := Save;
    finally
      Dec(UpdateCount);
    end;                
  end;
  UpdateStatusBar;
end;

function TCnBookmarkForm.GetHelpTopic: string;
begin
  Result := 'CnBookmarkWizard';
end;

initialization
  RegisterCnWizard(TCnBookmarkWizard); // ע��ר��

{$ENDIF CNWIZARDS_CNBOOKMARKWIZARD}
end.
