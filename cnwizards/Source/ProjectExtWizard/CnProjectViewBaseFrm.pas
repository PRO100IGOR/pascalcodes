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

unit CnProjectViewBaseFrm;
{ |<PRE>
================================================================================
* ������ƣ�CnPack IDE ר�Ұ�
* ��Ԫ���ƣ�������չ���ߴ����б�Ԫ�б����
* ��Ԫ���ߣ�Leeon (real-like@163.com); ��ΰ��Alan�� BeyondStudio@163.com
* ��    ע��
* ����ƽ̨��PWin2000Pro + Delphi 5.5
* ���ݲ��ԣ�PWin2000 + Delphi 5/6/7
* �� �� �����ô����е��ַ���֧�ֱ��ػ�����ʽ
* ��Ԫ��ʶ��$Id: CnProjectViewBaseFrm.pas 763 2011-02-07 14:18:23Z liuxiao@cnpack.org $
* �޸ļ�¼��2004.02.22 V1.1
*               ��д���д���
*           2004.02.08 V1.0
*               ������Ԫ
================================================================================
|</PRE>}

interface

{$I CnWizards.inc}

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs, 
  ImgList, Contnrs, ActnList, 
{$IFDEF COMPILER6_UP}
  StrUtils,
{$ENDIF COMPILER6_UP}
  ComCtrls, StdCtrls, ExtCtrls, Math, ToolWin, Clipbrd, IniFiles, ToolsAPI,
  CnCommon, CnConsts, CnWizConsts, CnWizOptions, CnWizUtils, CnIni, CnWizIdeUtils,
  CnWizMultiLang, CnWizShareImages, CnWizNotifier, CnIniStrUtils, RegExpr;

type

//==============================================================================
// ������Ϣ��
//==============================================================================

{ TCnProjectInfo }

  TCnProjectInfo = class
    Name: string;
    FileName: string;
    InfoList: TObjectList;
    constructor Create;
    destructor Destroy; override;
  end;

//==============================================================================
// �����鵥Ԫ�����б���ര��
//==============================================================================

{ TCnProjectViewBaseForm }

  TCnProjectViewBaseForm = class(TCnTranslateForm)
    actAttribute: TAction;
    actClose: TAction;
    actCopy: TAction;
    actHelp: TAction;
    actHookIDE: TAction;
    ActionList: TActionList;
    actMatchAny: TAction;
    actMatchStart: TAction;
    actOpen: TAction;
    actQuery: TAction;
    actSelectAll: TAction;
    actSelectInvert: TAction;
    actSelectNone: TAction;
    cbbProjectList: TComboBox;
    edtMatchSearch: TEdit;
    lblProject: TLabel;
    lblSearch: TLabel;
    lvList: TListView;
    pnlHeader: TPanel;
    StatusBar: TStatusBar;
    btnMatchAny: TToolButton;
    btnAttribute: TToolButton;
    btnClose: TToolButton;
    btnCopy: TToolButton;
    btnHelp: TToolButton;
    btnHookIDE: TToolButton;
    btnOpen: TToolButton;
    btnQuery: TToolButton;
    btnSelectInvert: TToolButton;
    btnSelectAll: TToolButton;
    btnSep1: TToolButton;
    btnSep3: TToolButton;
    btnSep4: TToolButton;
    btnSep5: TToolButton;
    btnSep6: TToolButton;
    btnSep7: TToolButton;
    btnSep8: TToolButton;
    btnMatchStart: TToolButton;
    btnSelectNone: TToolButton;
    ToolBar: TToolBar;
    actFont: TAction;
    btnFont: TToolButton;
    dlgFont: TFontDialog;
    procedure lvListDblClick(Sender: TObject);
    procedure edtMatchSearchKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure lvListColumnClick(Sender: TObject; Column: TListColumn);
    procedure FormKeyPress(Sender: TObject; var Key: Char);
    procedure FormCreate(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure cbbProjectListChange(Sender: TObject);
    procedure edtMatchSearchChange(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure lvListCustomDrawItem(Sender: TCustomListView;
      Item: TListItem; State: TCustomDrawState; var DefaultDraw: Boolean);
    procedure actSelectAllExecute(Sender: TObject);
    procedure actSelectNoneExecute(Sender: TObject);
    procedure actSelectInvertExecute(Sender: TObject);
    procedure actCopyExecute(Sender: TObject);
    procedure actFontExecute(Sender: TObject);
    procedure actCloseExecute(Sender: TObject);
    procedure actHelpExecute(Sender: TObject);
    procedure ActionListUpdate(Action: TBasicAction; var Handled: Boolean);
    procedure actAttributeExecute(Sender: TObject);
    procedure actMatchStartExecute(Sender: TObject);
    procedure actMatchAnyExecute(Sender: TObject);
    procedure actQueryExecute(Sender: TObject);
    procedure lvListSelectItem(Sender: TObject; Item: TListItem;
      Selected: Boolean);
    procedure actHookIDEExecute(Sender: TObject);
    procedure actOpenExecute(Sender: TObject);
    procedure FormKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure lvListKeyPress(Sender: TObject; var Key: Char);
    procedure lvListKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
  private
    FSortIndex: Integer;
    FSortDown: Boolean;
    FListViewWidthStr: string;
    FProjectListSelectedAllProject: Boolean;
    function GetMatchAny: Boolean;
    procedure SetMatchAny(const Value: Boolean);

    procedure FirstUpdate(Sender: TObject);
  protected
    FRegExpr: TRegExpr;
    NeedInitProjectControls: Boolean;
    ProjectList: TObjectList;
    CurrList: TList;
    function DoSelectOpenedItem: string; virtual; abstract;
    procedure DoSelectItemChanged(Sender: TObject); virtual;
    procedure DoUpdateListView; virtual; abstract;
    procedure DoSortListView; virtual;
    {* �����������ã��� UpdateListView ����}
    function GetSelectedFileName: string; virtual; abstract;
    procedure CreateList; virtual;
    {* ���� OnCreate ʱ����һ�����ã�������ʼ������ }
    procedure UpdateComboBox; virtual;
    {* ���� OnCreate ʱ���ڶ������ã�������ʼ�� ComboBox �е�����}
    procedure UpdateListView; virtual;
    {* ���� OnCreate ʱ�����������ã��������� ListView �е����ݣ�ͬʱ����������Ӧ����ĵط�����}
    procedure UpdateStatusBar; virtual;
    procedure OpenSelect; virtual; abstract;
    procedure FontChanged(AFont: TFont); virtual;
    procedure DrawListItem(ListView: TCustomListView; Item: TListItem); virtual; abstract;
    procedure SelectFirstItem;
    procedure SelectItemByIndex(Index: Integer);
    procedure LoadProjectSettings(Ini: TCustomIniFile; aSection: string);
    procedure SaveProjectSettings(Ini: TCustomIniFile; aSection: string);
  public
    procedure SelectOpenedItem;
    procedure LoadSettings(Ini: TCustomIniFile; aSection: string); virtual;
    procedure SaveSettings(Ini: TCustomIniFile; aSection: string); virtual;
    property SortIndex: Integer read FSortIndex write FSortIndex;
    property SortDown: Boolean read FSortDown write FSortDown;
    property MatchAny: Boolean read GetMatchAny write SetMatchAny;
  end;

implementation

{$R *.DFM}

{$IFDEF DEBUG}
uses
  CnDebug;
{$ENDIF DEBUG}

//==============================================================================
// ������Ϣ��
//==============================================================================

{ TCnProjectInfo }

constructor TCnProjectInfo.Create;
begin
  InfoList := TObjectList.Create;
end;

destructor TCnProjectInfo.Destroy;
begin
  FreeAndNil(InfoList);
  inherited Destroy;
end;

//==============================================================================
// �����鵥Ԫ�����б���ര��
//==============================================================================

{ TCnProjectViewBaseForm }

procedure TCnProjectViewBaseForm.FormCreate(Sender: TObject);
begin
  Screen.Cursor := crHourGlass;
  try
    FRegExpr := TRegExpr.Create;
    FRegExpr.ModifierI := True;

    lvList.DoubleBuffered := True;
    ProjectList := TObjectList.Create;
    CurrList := TList.Create;
    NeedInitProjectControls := True;
    CreateList;
    UpdateComboBox;
  finally
    Screen.Cursor := crDefault;
  end;
end;

procedure TCnProjectViewBaseForm.FormShow(Sender: TObject);
begin
  UpdateListView;
  SelectOpenedItem;
{$IFDEF BDS}
  SetListViewWidthString(lvList, FListViewWidthStr);
{$ENDIF}
  CnWizNotifierServices.ExecuteOnApplicationIdle(FirstUpdate);
end;

procedure TCnProjectViewBaseForm.FormDestroy(Sender: TObject);
begin
  CnWizNotifierServices.StopExecuteOnApplicationIdle(DoSelectItemChanged);
  ProjectList.Free;
  CurrList.Free;
  FRegExpr.Free;
end;

procedure TCnProjectViewBaseForm.FormKeyPress(Sender: TObject; var Key: Char);
begin
  if Key = #13 then
  begin
    lvListDblClick(Sender);
    Key := #0;
  end
  else if Key = #27 then
  begin
    ModalResult := mrCancel;
    Key := #0;
  end
  else if Key = #22 then // Ctrl + V
  begin
    if edtMatchSearch.Focused then
    begin
      if Clipboard.HasFormat(CF_TEXT) then
      begin
        edtMatchSearch.PasteFromClipboard;
        edtMatchSearch.Text := Trim(edtMatchSearch.Text);
        Key := #0;
      end;
    end;
  end;
end;

procedure TCnProjectViewBaseForm.ActionListUpdate(Action: TBasicAction;
  var Handled: Boolean);
begin
  actSelectAll.Enabled := lvList.Items.Count > 0;
  actSelectNone.Enabled := lvList.Items.Count > 0;
  actSelectInvert.Enabled := lvList.Items.Count > 0;

  actOpen.Enabled := lvList.SelCount > 0;
  actAttribute.Enabled := lvList.SelCount > 0;
  actCopy.Enabled := lvList.SelCount > 0;

  Handled := True;
end;

procedure TCnProjectViewBaseForm.actCopyExecute(Sender: TObject);
var
  i: Integer;
  AList: TStringList;
begin
  AList := TStringList.Create;
  try
    with lvList do
    begin
      for i := 0 to Pred(Items.Count) do
        if Items.Item[i].Selected and (Items.Item[i].Caption <> '') then
          AList.Add(Items[i].Caption);
    end;
  finally
    if AList.Count > 0 then
      Clipboard.AsText := TrimRight(AList.Text);
    FreeAndNil(AList);
  end;
end;

procedure TCnProjectViewBaseForm.actSelectAllExecute(Sender: TObject);
var
  i: Integer;
begin
  with lvList do
    for i := 0 to Pred(Items.Count) do
      Items[i].Selected := True;
end;

procedure TCnProjectViewBaseForm.actSelectNoneExecute(Sender: TObject);
begin
  lvList.Selected := nil;
end;

procedure TCnProjectViewBaseForm.actSelectInvertExecute(Sender: TObject);
var
  i: Integer;
begin
  with lvList do
    for i := Pred(Items.Count) downto 0 do
      Items[i].Selected := not Items[i].Selected;
end;

procedure TCnProjectViewBaseForm.actAttributeExecute(Sender: TObject);
var
  FileName: string;
begin
  FileName := GetSelectedFileName;

  if FileExists(FileName) then
    FileProperties(FileName)
  else
    InfoDlg(SCnProjExtFileNotExistOrNotSave, SCnInformation, 64);
end;

procedure TCnProjectViewBaseForm.actOpenExecute(Sender: TObject);
begin
  OpenSelect;
end;

procedure TCnProjectViewBaseForm.actHookIDEExecute(Sender: TObject);
begin
  actHookIDE.Checked := not actHookIDE.Checked;
end;

procedure TCnProjectViewBaseForm.actMatchStartExecute(Sender: TObject);
begin
  MatchAny := False;
  UpdateListView;
end;

procedure TCnProjectViewBaseForm.actMatchAnyExecute(Sender: TObject);
begin
  MatchAny := True;
  UpdateListView;
end;

procedure TCnProjectViewBaseForm.FontChanged(AFont: TFont);
begin

end;

procedure TCnProjectViewBaseForm.actFontExecute(Sender: TObject);
begin
  dlgFont.Font := lvList.Font; 
  if dlgFont.Execute then
  begin
    lvList.ParentFont := False;
    lvList.Font := dlgFont.Font;
    FontChanged(dlgFont.Font);
  end;
end;

procedure TCnProjectViewBaseForm.actQueryExecute(Sender: TObject);
begin
  actQuery.Checked := not actQuery.Checked;
end;

procedure TCnProjectViewBaseForm.actCloseExecute(Sender: TObject);
begin
  ModalResult := mrCancel;
end;

procedure TCnProjectViewBaseForm.edtMatchSearchKeyDown(Sender: TObject;
  var Key: Word; Shift: TShiftState);
begin
  if not (((Key = VK_F4) and (ssAlt in Shift)) or
    (Key in [VK_DELETE, VK_LEFT, VK_RIGHT]) or
    ((Key in [VK_HOME, VK_END]) and not (ssCtrl in Shift)) or
    ((Key in [VK_INSERT]) and ((ssShift in Shift) or (ssCtrl in Shift)))) then
  begin
    SendMessage(lvList.Handle, WM_KEYDOWN, Key, 0);
    Key := 0;
  end;
end;

procedure TCnProjectViewBaseForm.actHelpExecute(Sender: TObject);
begin
  ShowFormHelp;
end;

function TCnProjectViewBaseForm.GetMatchAny: Boolean;
begin
  Result := actMatchAny.Checked;
end;

procedure TCnProjectViewBaseForm.SetMatchAny(const Value: Boolean);
begin
  actMatchAny.Checked := Value;
  actMatchStart.Checked := not Value;
end;

procedure TCnProjectViewBaseForm.DoSortListView;
begin
  lvList.CustomSort(nil, 0);
end;

procedure TCnProjectViewBaseForm.lvListColumnClick(Sender: TObject;
  Column: TListColumn);
begin
  if FSortIndex = Column.Index then
    FSortDown := not FSortDown
  else
    FSortIndex := Column.Index;
  DoSortListView;
end;

procedure TCnProjectViewBaseForm.lvListDblClick(Sender: TObject);
begin
  OpenSelect;
end;

procedure TCnProjectViewBaseForm.cbbProjectListChange(Sender: TObject);
begin
  if Sender is TComboBox then
  begin
    if TComboBox(Sender).ItemIndex = cbbProjectList.Items.IndexOf(SCnProjExtCurrentProject) then
    begin
      FProjectListSelectedAllProject := False;
    end
    else if TComboBox(Sender).ItemIndex = cbbProjectList.Items.IndexOf(SCnProjExtProjectAll) then
    begin
      FProjectListSelectedAllProject := True;
    end;
  end;
  if Visible then
  begin
    UpdateListView;
    SelectOpenedItem;
  end;
end;

const
  csMatchAny = 'MatchAny';
  csFont = 'Font';
  csSortIndex = 'SortIndex';
  csSortDown = 'SortDown';
  csCurrentPrj = 'SelectCurrentProject';
  csHookIDE = 'HookIDE';
  csOpenMultiUnitQuery = 'Query';
  csWidth = 'Width';
  csHeight = 'Height';
  csListViewWidth = 'ListViewWidth';

procedure TCnProjectViewBaseForm.LoadProjectSettings(Ini: TCustomIniFile;
  aSection: string);
begin
  with Ini do
  begin
    if ReadBool(aSection, csCurrentPrj, False) then
    begin
      cbbProjectList.ItemIndex := cbbProjectList.Items.IndexOf(SCnProjExtCurrentProject);
      cbbProjectListChange(nil);
    end
    else
      cbbProjectList.ItemIndex := cbbProjectList.Items.IndexOf(SCnProjExtProjectAll);

    actHookIDE.Checked := ReadBool(aSection, csHookIDE, True);
    actQuery.Checked := ReadBool(aSection, csOpenMultiUnitQuery, True);
  end;
end;

procedure TCnProjectViewBaseForm.SaveProjectSettings(Ini: TCustomIniFile;
  aSection: string);
begin
  with Ini do
  begin
    if not FProjectListSelectedAllProject then
      WriteBool(aSection, csCurrentPrj, True)
    else
      WriteBool(aSection, csCurrentPrj, False);

    WriteBool(aSection, csHookIDE, actHookIDE.Checked);
    WriteBool(aSection, csOpenMultiUnitQuery, actQuery.Checked);
  end;
end;

procedure TCnProjectViewBaseForm.LoadSettings(Ini: TCustomIniFile; aSection: string);
var
  sFont: string;
begin
  with TCnIniFile.Create(Ini) do
  try
    MatchAny := ReadBool(aSection, csMatchAny, True);
    sFont := ReadString(aSection, csFont, '');
{$IFDEF DEBUG}
    CnDebugger.LogMsg('ReadFont: ' + sFont);
    CnDebugger.LogMsg('SelfFont: ' + FontToString(Self.Font));
{$ENDIF DEBUG}
    if (sFont <> '') and (sFont <> FontToString(Self.Font)) then
    begin
      // ֻ�б�������岻���ڴ��������ʱ��Ҳ���û����ù�����󣬲�����
      lvList.ParentFont := False;
      lvList.Font := ReadFont(aSection, csFont, lvList.Font);
      dlgFont.Font := lvList.Font;
      FontChanged(dlgFont.Font);
    end;

    FSortIndex := ReadInteger(aSection, csSortIndex, 0);
    FSortDown := ReadBool(aSection, csSortDown, False);
    lvList.CustomSort(nil, 0); // ���������������

    Width := ReadInteger(aSection, csWidth, Width);
    Height := ReadInteger(aSection, csHeight, Height);
    CenterForm(Self);
    
    FListViewWidthStr := ReadString(aSection, csListViewWidth, '');
    SetListViewWidthString(lvList, FListViewWidthStr);
  finally
    Free;
  end;

  if NeedInitProjectControls then
    LoadProjectSettings(Ini, aSection);
end;

procedure TCnProjectViewBaseForm.SaveSettings(Ini: TCustomIniFile; aSection: string);
begin
  with TCnIniFile.Create(Ini) do
  try
    WriteBool(aSection, csMatchAny, MatchAny);
    WriteInteger(aSection, csSortIndex, FSortIndex);
    WriteBool(aSection, csSortDown, FSortDown);

    // ���û�û���ù����壬ParentFont ��Ϊ True��������������л��ܻ����仯
    if not lvList.ParentFont then
      WriteFont(aSection, csFont, lvList.Font)
    else
      WriteString(aSection, csFont, '');

    WriteInteger(aSection, csWidth, Width);
    WriteInteger(aSection, csHeight, Height);
    WriteString(aSection, csListViewWidth, GetListViewWidthString(lvList));
  finally
    Free;
  end;

  if NeedInitProjectControls then
    SaveProjectSettings(Ini, aSection);
end;

procedure TCnProjectViewBaseForm.UpdateStatusBar;
begin

end;

procedure TCnProjectViewBaseForm.SelectFirstItem;
begin
  with lvList do
  begin
    Selected := nil;
    Selected := Items[0];
    ItemFocused := Selected;
  end;
end;

procedure TCnProjectViewBaseForm.SelectOpenedItem;
var
  i: Integer;
  aCurrentName: string;
begin
  with lvList do
  begin
    if Items.Count = 0 then
      Exit;

    aCurrentName := DoSelectOpenedItem;
    SelectFirstItem;

    if aCurrentName = '' then
      Exit;

    for i := 0 to Pred(Items.Count) do
      if AnsiSameText(Items[i].Caption, aCurrentName) then
      begin
        Selected := nil;
        Items[i].Selected := True;
        ItemFocused := Selected;
        Selected.MakeVisible(False);
        Break;
      end;
  end;
end;

procedure TCnProjectViewBaseForm.UpdateComboBox;
begin

end;

procedure TCnProjectViewBaseForm.CreateList;
begin

end;

procedure TCnProjectViewBaseForm.UpdateListView;
begin
  DoUpdateListView;
  // RemoveListViewSubImages(lvList);
end;

procedure TCnProjectViewBaseForm.DoSelectItemChanged(Sender: TObject);
begin
  UpdateStatusBar;
  StatusBar.Invalidate;
end;

procedure TCnProjectViewBaseForm.edtMatchSearchChange(Sender: TObject);
begin
  UpdateListView;
end;

procedure TCnProjectViewBaseForm.lvListCustomDrawItem(
  Sender: TCustomListView; Item: TListItem; State: TCustomDrawState;
  var DefaultDraw: Boolean);
begin
  DrawListItem(Sender, Item);
end;

procedure TCnProjectViewBaseForm.lvListSelectItem(Sender: TObject;
  Item: TListItem; Selected: Boolean);
begin
  CnWizNotifierServices.ExecuteOnApplicationIdle(DoSelectItemChanged);
end;

procedure TCnProjectViewBaseForm.SelectItemByIndex(Index: Integer);
begin
  with lvList do
  begin
    if (Index >= 0) and (Index < Items.Count) then
    begin
      Selected := nil;
      Selected := Items[Index];
      ItemFocused := Selected;
    end;
  end;
end;

procedure TCnProjectViewBaseForm.FormKeyDown(Sender: TObject;
  var Key: Word; Shift: TShiftState);
const
  CNCOPY_SPLITER  = #9;     // TAB
  CNCOPY_LINE     = #13#10;
var
  I, J: Integer;
  CopyBuf: string;
begin
  if lvList.MultiSelect then
  begin
    if Shift = [ssCtrl] then
    begin
      // ѡ��ȫ��
      if Key = Ord('A') then
      begin
        lvList.Items.BeginUpdate;
        try
          for I := 0 to lvList.Items.Count - 1 do
            lvList.Items[I].Selected := True;
        finally
          lvList.Items.EndUpdate;
        end;
        Key := 0;
      end
      // ȡ��ѡ��
      else if Key = Ord('D') then
      begin
        lvList.Items.BeginUpdate;
        try
          for I := 0 to lvList.Items.Count - 1 do
            lvList.Items[I].Selected := False;
        finally
          lvList.Items.EndUpdate;
        end;
        Key := 0;
      end
      // �����ı�
      // ��Ϊ�������ܣ������������֣��պ��ʵ�ֿ�ѡ��
      else if Key = Ord('C') then
      begin
        if edtMatchSearch.Focused and (edtMatchSearch.SelText <> '') then
          Exit; // ��ѡ��ʱ�����ж���ĸ���

        if lvList.Selected <> nil then
        begin
          CopyBuf := '';

          // ��������
          for I := 0 to lvList.Columns.Count - 1 do
          begin
            CopyBuf := CopyBuf + lvList.Column[I].Caption;
            if I < lvList.Columns.Count - 1 then
              CopyBuf := CopyBuf + CNCOPY_SPLITER;
          end;
          CopyBuf := CopyBuf + CNCOPY_LINE;

          // ��������
          for I := 0 to lvList.Items.Count - 1 do
          begin
            if lvList.Items[I].Selected then
            begin
              CopyBuf := CopyBuf + lvList.Items[I].Caption;
              for J := 0 to lvList.Items[I].SubItems.Count - 1 do
                CopyBuf := CopyBuf + CNCOPY_SPLITER + lvList.Items[I].SubItems[J];
              CopyBuf := CopyBuf + CNCOPY_LINE;
            end;
          end;

          // ���������
          Clipboard.Clear;
          Clipboard.SetTextBuf(PChar(CopyBuf));
        end
        else
        begin
          // �������������ʾû��ѡ����Ҫ���Ƶ�����
        end;  // if lvList.Selected <> nil
      end;
    end;
  end;
end;

procedure TCnProjectViewBaseForm.lvListKeyPress(Sender: TObject;
  var Key: Char);
begin
  if CharInSet(Key, ['0'..'9', 'a'..'z', 'A'..'Z']) then
  begin
    PostMessage(edtMatchSearch.Handle, WM_CHAR, Integer(Key), 0);
    try
      edtMatchSearch.SetFocus;
    except
      ;
    end;
    Key := #0;
  end;
end;

procedure TCnProjectViewBaseForm.lvListKeyDown(Sender: TObject;
  var Key: Word; Shift: TShiftState);
begin
  if Key in [VK_BACK] then
  begin
    //PostMessage(edtMatchSearch.Handle, WM_CHAR, Integer(Key), 0);
    try
      edtMatchSearch.SetFocus;
    except
      ;
    end;
  end;
end;

procedure TCnProjectViewBaseForm.FirstUpdate(Sender: TObject);
begin
  lvList.Update;
end;

end.
