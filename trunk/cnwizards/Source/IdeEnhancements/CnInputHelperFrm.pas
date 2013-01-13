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

unit CnInputHelperFrm;
{* |<PRE>
================================================================================
* ������ƣ�CnPack IDE ר�Ұ�
* ��Ԫ���ƣ���������ר�����ô���
* ��Ԫ���ߣ��ܾ��� zjy@cnpack.org
* ��    ע��
* ����ƽ̨��PWinXP XP2 + Delphi 5.01
* ���ݲ��ԣ�
* �� �� �����õ�Ԫ�е��ַ��������ϱ��ػ�����ʽ
* ��Ԫ��ʶ��$Id: CnInputHelperFrm.pas 773 2011-03-12 03:04:20Z liuxiao@cnpack.org $
* �޸ļ�¼��2005.06.03
*               �� CnInputHelper �з������
================================================================================
|</PRE>}

interface

{$I CnWizards.inc}

{$IFDEF CNWIZARDS_CNINPUTHELPER}

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  CheckLst, StdCtrls, ComCtrls, ExtCtrls, Menus, CnConsts, CnCommon, IniFiles,
  CnWizMultiLang, CnSpin, CnWizConsts, CnInputHelper, CnInputSymbolList,
  CnInputIdeSymbolList, CnInputHelperEditFrm, CnWizMacroText, CnWizUtils;

type

{ TCnInputHelperForm }

  TCnInputHelperForm = class(TCnTranslateForm)
    FontDialog: TFontDialog;
    btnHelp: TButton;
    btnOK: TButton;
    btnCancel: TButton;
    pgc1: TPageControl;
    ts1: TTabSheet;
    ts2: TTabSheet;
    grp1: TGroupBox;
    lbl1: TLabel;
    lbl2: TLabel;
    lbl3: TLabel;
    lbl4: TLabel;
    lbl5: TLabel;
    lbl6: TLabel;
    chkAutoPopup: TCheckBox;
    seDispOnlyAtLeastKey: TCnSpinEdit;
    tbDispDelay: TTrackBar;
    chkSmartDisp: TCheckBox;
    hkEnabled: THotKey;
    hkPopup: THotKey;
    chkCheckImmRun: TCheckBox;
    chkDispOnIDECompDisabled: TCheckBox;
    grp3: TGroupBox;
    lbl9: TLabel;
    lbl10: TLabel;
    edtCompleteChars: TEdit;
    cbbOutputStyle: TComboBox;
    chkSelMidMatchByEnterOnly: TCheckBox;
    chkAutoInsertEnter: TCheckBox;
    chkSpcComplete: TCheckBox;
    ts3: TTabSheet;
    grp2: TGroupBox;
    lbl7: TLabel;
    lbl8: TLabel;
    PaintBox: TPaintBox;
    seListOnlyAtLeastLetter: TCnSpinEdit;
    chkMatchAnyWhere: TCheckBox;
    cbbSortKind: TComboBox;
    btnFont: TButton;
    chkAutoAdjustScope: TCheckBox;
    chkUseCodeInsightMgr: TCheckBox;
    grp4: TGroupBox;
    lbl11: TLabel;
    chklstSymbol: TCheckListBox;
    grp5: TGroupBox;
    lbl12: TLabel;
    lvList: TListView;
    btnAdd: TButton;
    lbl13: TLabel;
    mmoTemplate: TMemo;
    btnDelete: TButton;
    btnEdit: TButton;
    btnImport: TButton;
    btnExport: TButton;
    btnInsertMacro: TButton;
    btnCursor: TButton;
    btnClear: TButton;
    lbl14: TLabel;
    chklstKind: TCheckListBox;
    pmMacro: TPopupMenu;
    dlgOpen: TOpenDialog;
    dlgSave: TSaveDialog;
    btnDup: TButton;
    btnUserMacro: TButton;
    chkRemoveSame: TCheckBox;
    lbl15: TLabel;
    cbbKeyword: TComboBox;
    btnDefault: TButton;
    cbbList: TComboBox;
    chkAutoCompParam: TCheckBox;
    lbl16: TLabel;
    edtFilterSymbols: TEdit;
    chkIgnoreSpace: TCheckBox;
    chkUseKibitzCompileThread: TCheckBox;
    edtAutoSymbols: TEdit;
    chkKeySeq: TCheckBox;
    procedure FormShow(Sender: TObject);
    procedure PaintBoxPaint(Sender: TObject);
    procedure btnFontClick(Sender: TObject);
    procedure UpdateControls(Sender: TObject);
    procedure UpdateListControls(Sender: TObject);
    procedure btnHelpClick(Sender: TObject);
    procedure btnOKClick(Sender: TObject);
    procedure lvListChange(Sender: TObject; Item: TListItem;
      Change: TItemChange);
    procedure btnCursorClick(Sender: TObject);
    procedure btnDeleteClick(Sender: TObject);
    procedure btnEditClick(Sender: TObject);
    procedure btnClearClick(Sender: TObject);
    procedure btnAddClick(Sender: TObject);
    procedure mmoTemplateExit(Sender: TObject);
    procedure FormActivate(Sender: TObject);
    procedure btnImportClick(Sender: TObject);
    procedure btnExportClick(Sender: TObject);
    procedure btnInsertMacroClick(Sender: TObject);
    procedure btnDupClick(Sender: TObject);
    procedure lvListCompare(Sender: TObject; Item1, Item2: TListItem;
      Data: Integer; var Compare: Integer);
    procedure lvListColumnClick(Sender: TObject; Column: TListColumn);
    procedure FormDestroy(Sender: TObject);
    procedure btnUserMacroClick(Sender: TObject);
    procedure cbbListChange(Sender: TObject);
    procedure btnDefaultClick(Sender: TObject);
    procedure FormKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure chkSpcCompleteClick(Sender: TObject);
  private
    InputHelper: TCnInputHelper;
    NewSymbol: string;
    SaveKind: TSymbolKind;
    SaveScope: Integer;
    SaveAutoIndent: Boolean;
    AddMode: Boolean;
    CurrList: TSymbolList;
    SortIdx: Integer;
    SortDesc: Boolean;
    function DoAddSymbol(const NewName: string): Boolean;
    procedure UpdateFont;
    procedure UpdateListView(SelOnly: Boolean);
    procedure OnMacroMenu(Sender: TObject);
    procedure InitListView;
    procedure UpdateListItem(Item: TListItem);
  protected
    function GetHelpTopic: string; override;
  end;
  
function CnInputHelperConfig(AInputHelper: TCnInputHelper; HideSymbolPages: Boolean = False): Boolean;

function CnInputHelperAddSymbol(AInputHelper: TCnInputHelper;
  const ASymbol: string): Boolean;

{$ENDIF CNWIZARDS_CNINPUTHELPER}

implementation

{$IFDEF CNWIZARDS_CNINPUTHELPER}

{$R *.dfm}

const
  csCnKeywordStyles: array[TCnKeywordStyle] of PString = (
    @SCnKeywordDefault, @SCnKeywordLower, @SCnKeywordUpper, @SCnKeywordFirstUpper);

//==============================================================================
// �����������ô���
//==============================================================================

function CnInputHelperConfig(AInputHelper: TCnInputHelper;
  HideSymbolPages: Boolean): Boolean;
begin
  with TCnInputHelperForm.Create(nil) do
  try
    InputHelper := AInputHelper;
    AddMode := False;

    if HideSymbolPages then
    begin
      ts2.TabVisible := False;
      ts3.TabVisible := False;
    end;  
    Result := ShowModal = mrOK;
  finally
    Free;
  end;
end;

function CnInputHelperAddSymbol(AInputHelper: TCnInputHelper;
  const ASymbol: string): Boolean;
begin
  with TCnInputHelperForm.Create(nil) do
  try
    InputHelper := AInputHelper;
    NewSymbol := ASymbol;
    AddMode := True;
    Result := ShowModal = mrOK;
  finally
    Free;
  end;
end;

{ TCnInputHelperForm }

const
  csOption = 'Option';
  csSortIdx = 'SortIdx';
  csSortDesc = 'SortDesc';
  csSaveKind = 'SaveKind';
  csSaveScope = 'SaveScope';

procedure TCnInputHelperForm.FormShow(Sender: TObject);
var
  Kind: TCnSortKind;
  SymbolKind: TSymbolKind;
  KwStyle: TCnKeywordStyle;
  Macro: TCnWizMacro;
  i: Integer;
begin
  inherited;

  if AddMode then
    pgc1.ActivePageIndex := 2
  else
    pgc1.ActivePageIndex := 0;

  with InputHelper.CreateIniFile do
  try
    SortIdx := ReadInteger(csOption, csSortIdx, 0);
    SortDesc := ReadBool(csOption, csSortDesc, False);
    SaveKind := TSymbolKind(ReadInteger(csOption, csSaveKind, Ord(skUser)));
    SaveScope := ReadInteger(csOption, csSaveScope, csDefScopeRate);
  finally
    Free;
  end;
  SaveAutoIndent := True;

  with InputHelper do
  begin
    chkUseCodeInsightMgr.Enabled := SupportMultiIDESymbolList;
    if SupportMultiIDESymbolList then
      chkUseCodeInsightMgr.Checked := UseCodeInsightMgr;
    chkUseKibitzCompileThread.Enabled := SupportKibitzCompileThread;
    if SupportKibitzCompileThread then
      chkUseKibitzCompileThread.Checked := UseKibitzCompileThread;
    chkAutoPopup.Checked := AutoPopup;
    seDispOnlyAtLeastKey.Value := DispOnlyAtLeastKey;
    tbDispDelay.Position := DispDelay;
    seListOnlyAtLeastLetter.Value := ListOnlyAtLeastLetter;
    chkMatchAnyWhere.Checked := MatchAnyWhere;
    chkAutoAdjustScope.Checked := AutoAdjustScope;
    chkRemoveSame.Checked := RemoveSame;
    chkSmartDisp.Checked := SmartDisplay;
    for Kind := Low(TCnSortKind) to High(TCnSortKind) do
      cbbSortKind.Items.Add(StripHotkey(csSortKindTexts[Kind]^));
    cbbSortKind.ItemIndex := Ord(SortKind);
    for KwStyle := Low(TCnKeywordStyle) to High(TCnKeywordStyle) do
      cbbKeyword.Items.Add(csCnKeywordStyles[KwStyle]^);
    cbbKeyword.ItemIndex := Ord(KeywordStyle);
    hkEnabled.HotKey := InputHelper.Action.ShortCut;
    hkPopup.HotKey := PopupKey;
    chkCheckImmRun.Checked := CheckImmRun;
    edtCompleteChars.Text := CompleteChars;
    edtFilterSymbols.Text := FilterSymbols.CommaText;
    edtAutoSymbols.Text := AutoSymbols.CommaText;
    chkSpcComplete.Checked := SpcComplete;
    chkIgnoreSpace.Checked:= IgnoreSpc;
    chkIgnoreSpace.Enabled := chkSpcComplete.Checked;
    cbbOutputStyle.ItemIndex := Ord(OutputStyle);
    chkSelMidMatchByEnterOnly.Checked := SelMidMatchByEnterOnly;
    chkAutoInsertEnter.Checked := AutoInsertEnter;
    chkAutoCompParam.Checked := AutoCompParam;
    chkDispOnIDECompDisabled.Checked := DispOnIDECompDisabled;
    chkKeySeq.Checked := EnableAutoSymbols;
    FontDialog.Font.Assign(ListFont);

    for i := 0 to SymbolListMgr.Count - 1 do
    begin
      chklstSymbol.Items.Add(SymbolListMgr.List[i].GetListName);
      chklstSymbol.Checked[i] := SymbolListMgr.List[i].Active;
      if SymbolListMgr.List[i].CanCustomize then
        cbbList.Items.AddObject(SymbolListMgr.List[i].GetListName,
          SymbolListMgr.List[i]);
    end;

    for SymbolKind := Low(SymbolKind) to High(SymbolKind) do
    begin
      chklstKind.Items.Add(GetSymbolKindName(SymbolKind));
      chklstKind.Checked[Ord(SymbolKind)] := SymbolKind in DispKindSet;
    end;

    for Macro := Low(Macro) to High(Macro) do
    begin
      AddMenuItem(pmMacro.Items, Format('%s - %s', [GetMacroEx(Macro),
        csCnWizMacroDescs[Macro]^]), OnMacroMenu, nil, 0, '', Ord(Macro));
    end;

    InputHelper.SymbolListMgr.Load;
    CurrList := InputHelper.SymbolListMgr.ListByClass(TUserSymbolList);
    Assert(Assigned(CurrList));
    cbbList.ItemIndex := cbbList.Items.IndexOfObject(CurrList);
    Assert(cbbList.ItemIndex >= 0);
    InitListView;
  end;

  UpdateFont;
  UpdateControls(nil);
  UpdateListControls(nil);
end;

procedure TCnInputHelperForm.FormDestroy(Sender: TObject);
begin
  inherited;
  
  with InputHelper.CreateIniFile do
  try
    WriteInteger(csOption, csSortIdx, SortIdx);
    WriteBool(csOption, csSortDesc, SortDesc);
    WriteInteger(csOption, csSaveKind, Ord(SaveKind));
    WriteInteger(csOption, csSaveScope, SaveScope);
  finally
    Free;
  end;

  InputHelper.SymbolListMgr.Save;
end;

procedure TCnInputHelperForm.InitListView;
var
  i: Integer;
begin
  lvList.Items.Clear;
  for i := 0 to CurrList.Count - 1 do
    lvList.Items.Add.Data := CurrList.Items[i];
  UpdateListView(False);
  lvList.AlphaSort;
end;

procedure TCnInputHelperForm.FormActivate(Sender: TObject);
begin
  if AddMode then
  begin
    AddMode := False;
    DoAddSymbol(NewSymbol);
  end;
end;

procedure TCnInputHelperForm.btnOKClick(Sender: TObject);
var
  i: Integer;
  SymbolKind: TSymbolKind;
begin
  with InputHelper do
  begin
    if SupportMultiIDESymbolList then
      UseCodeInsightMgr := chkUseCodeInsightMgr.Checked;
    if SupportKibitzCompileThread then
      UseKibitzCompileThread := chkUseKibitzCompileThread.Checked;
    AutoPopup := chkAutoPopup.Checked;
    DispOnlyAtLeastKey := seDispOnlyAtLeastKey.Value;
    DispDelay := tbDispDelay.Position;
    ListOnlyAtLeastLetter := seListOnlyAtLeastLetter.Value;
    MatchAnyWhere := chkMatchAnyWhere.Checked;
    AutoAdjustScope := chkAutoAdjustScope.Checked;
    RemoveSame := chkRemoveSame.Checked;
    SmartDisplay := chkSmartDisp.Checked;
    SortKind := TCnSortKind(cbbSortKind.ItemIndex);
    KeywordStyle := TCnKeywordStyle(cbbKeyword.ItemIndex);
    InputHelper.Action.ShortCut := hkEnabled.HotKey;
    PopupKey := hkPopup.HotKey;
    CheckImmRun := chkCheckImmRun.Checked;
    CompleteChars := edtCompleteChars.Text;
    FilterSymbols.CommaText := edtFilterSymbols.Text;
    AutoSymbols.CommaText := edtAutoSymbols.Text;
    SpcComplete := chkSpcComplete.Checked;
    IgnoreSpc := chkIgnoreSpace.Checked;
    OutputStyle := TCnOutputStyle(cbbOutputStyle.ItemIndex);
    SelMidMatchByEnterOnly := chkSelMidMatchByEnterOnly.Checked;
    AutoInsertEnter := chkAutoInsertEnter.Checked;
    AutoCompParam := chkAutoCompParam.Checked;
    DispOnIDECompDisabled := chkDispOnIDECompDisabled.Checked;
    EnableAutoSymbols := chkKeySeq.Checked;
    ListFont.Assign(FontDialog.Font);

    for i := 0 to SymbolListMgr.Count - 1 do
    begin
      SymbolListMgr.List[i].Active := chklstSymbol.Checked[i];
    end;

    DispKindSet := [];
    for SymbolKind := Low(SymbolKind) to High(SymbolKind) do
    begin
      if chklstKind.Checked[Ord(SymbolKind)] then
       DispKindSet := DispKindSet + [SymbolKind];
    end;
  end;

  ModalResult := mrOk;
end;

function TCnInputHelperForm.GetHelpTopic: string;
begin
  Result := SCnInputHelperHelpStr;
end;

procedure TCnInputHelperForm.PaintBoxPaint(Sender: TObject);
var
  Text: string;
  W, H: Integer;
begin
  with PaintBox.Canvas do
  begin
    Font := FontDialog.Font;
    Font.Color := clBlack;
    Brush.Color := clWhite;
    Text := Format('%s, %d', [FontDialog.Font.Name, FontDialog.Font.Size]);
    W := TextWidth(Text);
    H := TextHeight(Text);
    PaintBox.Canvas.TextRect(PaintBox.ClientRect, (PaintBox.Width - W) div 2,
      (PaintBox.Height - H) div 2, Text);
    Brush.Color := clBlack;
    FrameRect(PaintBox.ClientRect);
  end;
end;

procedure TCnInputHelperForm.UpdateFont;
begin
  PaintBox.Invalidate;
end;

procedure TCnInputHelperForm.btnFontClick(Sender: TObject);
begin
  if FontDialog.Execute then
    UpdateFont;
end;

procedure TCnInputHelperForm.btnHelpClick(Sender: TObject);
begin
  ShowFormHelp;
end;

procedure TCnInputHelperForm.UpdateControls(Sender: TObject);
begin
  tbDispDelay.Enabled := chkAutoPopup.Checked;
  seDispOnlyAtLeastKey.Enabled := chkAutoPopup.Checked;
  chkSmartDisp.Enabled := chkAutoPopup.Checked;
  chkDispOnIDECompDisabled.Enabled := chkAutoPopup.Checked;
  chkKeySeq.Enabled := chkAutoPopup.Checked;
  edtAutoSymbols.Enabled := chkAutoPopup.Checked and chkKeySeq.Checked;
end;

procedure TCnInputHelperForm.UpdateListItem(Item: TListItem);
begin
  if Item <> nil then
    with TSymbolItem(Item.Data) do
    begin
      Item.Caption := Name;
      Item.SubItems.Clear;
      Item.SubItems.Add(GetSymbolKindName(Kind));
      Item.SubItems.Add(IntToStr(ScopeRate));
      Item.SubItems.Add(Description);
    end;
end;

procedure TCnInputHelperForm.UpdateListView(SelOnly: Boolean);
var
  i: Integer;
begin
  if SelOnly then
    UpdateListItem(lvList.Selected)
  else
    for i := 0 to lvList.Items.Count - 1 do
      UpdateListItem(lvList.Items[i]);
end;

procedure TCnInputHelperForm.UpdateListControls(Sender: TObject);
var
  IsTemplate: Boolean;
begin
  btnDelete.Enabled := lvList.SelCount > 0;
  btnEdit.Enabled := lvList.Selected <> nil;
  btnDup.Enabled := lvList.SelCount > 0;
  IsTemplate := (lvList.Selected <> nil) and
    TSymbolItem(lvList.Selected.Data).AllowMultiLine;
  mmoTemplate.Enabled := IsTemplate;
  btnInsertMacro.Enabled := IsTemplate;
  btnUserMacro.Enabled := IsTemplate;
  btnCursor.Enabled := IsTemplate;
  btnClear.Enabled := IsTemplate;
  if IsTemplate then
    mmoTemplate.Lines.Text := TSymbolItem(lvList.Selected.Data).Text
  else
    mmoTemplate.Lines.Clear;
end;

procedure TCnInputHelperForm.lvListColumnClick(Sender: TObject;
  Column: TListColumn);
begin
  if Column.Index = SortIdx then
    SortDesc := not SortDesc
  else
    SortIdx := Column.Index;
  lvList.AlphaSort;
end;

procedure TCnInputHelperForm.lvListCompare(Sender: TObject; Item1,
  Item2: TListItem; Data: Integer; var Compare: Integer);
begin
  if SortIdx = 0 then
    Compare := CompareText(Item1.Caption, Item2.Caption)
  else if SortIdx = 2 then
  begin
    if TSymbolItem(Item1.Data).Scope > TSymbolItem(Item2.Data).Scope then
      Compare := 1
    else if TSymbolItem(Item1.Data).Scope < TSymbolItem(Item2.Data).Scope then
      Compare := -1
    else
      Compare := 0;
  end
  else if (SortIdx > 0) and (SortIdx <= Item1.SubItems.Count) then
    Compare := CompareText(Item1.SubItems[SortIdx - 1], Item2.SubItems[SortIdx - 1]);
  if SortDesc then
    Compare := -Compare;
end;

procedure TCnInputHelperForm.lvListChange(Sender: TObject; Item: TListItem;
  Change: TItemChange);
begin
  UpdateListControls(Sender);
end;

procedure TCnInputHelperForm.cbbListChange(Sender: TObject);
begin
  if cbbList.ItemIndex >= 0 then
  begin
    CurrList := TSymbolList(cbbList.Items.Objects[cbbList.ItemIndex]);
    InitListView;
  end;
end;

function TCnInputHelperForm.DoAddSymbol(const NewName: string): Boolean;
var
  AName, ADesc: string;
  LVItem: TListItem;
  AlwaysDisp: Boolean;
begin
  AName := NewName;
  ADesc := '';
  AlwaysDisp := False;
  if CnShowInputHelperEditForm(AName, ADesc, SaveKind, SaveScope,
    SaveAutoIndent, AlwaysDisp) then
  begin
    CurrList.Add(AName, SaveKind, RateToScope(SaveScope), ADesc, '',
      SaveAutoIndent, AlwaysDisp);
    LVItem := lvList.Items.Add;
    LVItem.Data := CurrList.Items[CurrList.Count - 1];
    UpdateListItem(LVItem);
    ListViewSelectItems(lvList, smNone);
    lvList.Selected := LVItem;
    lvList.AlphaSort;
    Result := True;
  end
  else
    Result := False;
end;

procedure TCnInputHelperForm.btnAddClick(Sender: TObject);
begin
  DoAddSymbol('');
end;

procedure TCnInputHelperForm.btnDupClick(Sender: TObject);
var
  i: Integer;
  Item: TSymbolItem;
  LVItem: TListItem;
begin
  if lvList.SelCount > 0 then
  begin
    for i := 0 to lvList.Items.Count - 1 do
    begin
      if lvList.Items[i].Selected then
      begin
        lvList.Items[i].Selected := False;
        Item := TSymbolItem.Create;
        Item.Assign(TSymbolItem(lvList.Items[i].Data));
        Item.Name := Item.Name + '1';
        CurrList.Add(Item);
        LVItem := lvList.Items.Add;
        LVItem.Data := Item;
        LVItem.Selected := True;
        UpdateListItem(LVItem);
      end;
    end;
    lvList.AlphaSort;
  end;
end;

procedure TCnInputHelperForm.btnDeleteClick(Sender: TObject);
var
  i, Idx: Integer;
begin
  if (lvList.SelCount > 0) and QueryDlg(SCnDeleteConfirm) then
  begin
    Idx := -1;
    for i := lvList.Items.Count - 1 downto 0 do
    begin
      if lvList.Items[i].Selected then
      begin
        Idx := i;
        CurrList.Remove(TSymbolItem(lvList.Items[i].Data));
        lvList.Items.Delete(i);
      end;
    end;

    if Idx > lvList.Items.Count - 1 then
      Idx := lvList.Items.Count - 1;
    if Idx >= 0 then
      lvList.Selected := lvList.Items[Idx];
  end;
end;

procedure TCnInputHelperForm.btnEditClick(Sender: TObject);
var
  Item: TSymbolItem;
  AName, ADesc: string;
  AKind: TSymbolKind;
  AutoIndent: Boolean;
  AlwaysDisp: Boolean;
  AScope: Integer;
begin
  if lvList.Selected <> nil then
  begin
    Item := TSymbolItem(lvList.Selected.Data);
    AName := Item.Name;
    ADesc := Item.Description;
    AKind := Item.Kind;
    AScope := Item.ScopeRate;
    AutoIndent := Item.AutoIndent;
    AlwaysDisp := Item.AlwaysDisp;

    if CnShowInputHelperEditForm(AName, ADesc, AKind, AScope, AutoIndent,
      AlwaysDisp) then
    begin
      Item.Name := AName;
      Item.Description := ADesc;
      Item.Kind := AKind;
      Item.ScopeRate := AScope;
      Item.AutoIndent := AutoIndent;
      Item.AlwaysDisp := AlwaysDisp;
      UpdateListView(True);
      lvList.AlphaSort;
    end;
  end;
end;

procedure TCnInputHelperForm.btnImportClick(Sender: TObject);
begin
  if dlgOpen.Execute then
  begin
    if not QueryDlg(SCnImportAppend) then
      CurrList.Clear;
    if not LoadListFromXMLFile(CurrList, dlgOpen.FileName) then
      ErrorDlg(SCnImportError);
    InitListView;
  end;
end;

procedure TCnInputHelperForm.btnExportClick(Sender: TObject);
begin
  if dlgSave.Execute then
    if not SaveListToXMLFile(CurrList, dlgSave.FileName) then
      ErrorDlg(SCnExportError);
end;

procedure TCnInputHelperForm.btnClearClick(Sender: TObject);
begin
  mmoTemplate.Lines.Clear;
end;

procedure TCnInputHelperForm.mmoTemplateExit(Sender: TObject);
begin
  if lvList.Selected <> nil then
    TSymbolItem(lvList.Selected.Data).Text := mmoTemplate.Lines.Text;
end;

procedure TCnInputHelperForm.btnInsertMacroClick(Sender: TObject);
var
  P: TPoint;
begin
  P := Point(0, btnInsertMacro.Height);
  P := btnInsertMacro.ClientToScreen(P);
  pmMacro.Popup(P.x, P.y);
end;

procedure TCnInputHelperForm.OnMacroMenu(Sender: TObject);
var
  Macro: string;
  i: Integer;
begin
  if Sender is TMenuItem then
  begin
    Macro := GetMacro(GetMacroDefText(TCnWizMacro(TMenuItem(Sender).Tag)));
    for i := 1 to Length(Macro) do
      mmoTemplate.Perform(WM_CHAR, Ord(Macro[i]), 0);
    mmoTemplate.SetFocus;
  end;
end;

procedure TCnInputHelperForm.btnUserMacroClick(Sender: TObject);
var
  Ini: TCustomIniFile;
  Macro: string;
  i: Integer;
begin
  Ini := InputHelper.CreateIniFile;
  try
    if CnInputQuery(SCnInputHelperUserMacroCaption, SCnInputHelperUserMacroPrompt,
      Macro, Ini, 'UserMacroHis') then
    begin
      Macro := GetMacro(Macro);
      for i := 1 to Length(Macro) do
        mmoTemplate.Perform(WM_CHAR, Ord(Macro[i]), 0);
      mmoTemplate.SetFocus;
    end;
  finally
    Ini.Free;
  end;
end;

procedure TCnInputHelperForm.btnCursorClick(Sender: TObject);
begin
  mmoTemplate.Perform(WM_CHAR, Ord('|'), 0);
end;

procedure TCnInputHelperForm.btnDefaultClick(Sender: TObject);
begin
  if (CurrList <> nil) and QueryDlg(SCnDefaultConfirm) then
  begin
    CurrList.Load;
    InitListView;
  end;
end;

procedure TCnInputHelperForm.FormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
var
  Hk: THotKey;
begin
  if (ActiveControl = nil) or not (ActiveControl is THotKey) then
    Exit;

  Hk := ActiveControl as THotKey;

  if Key = VK_SPACE then
  begin
    if ssAlt in Shift then
    begin
      Hk.HotKey := ShortCut(VK_SPACE, [ssAlt]);
      Key := 0;
    end
    else if ssCtrl in Shift then
    begin
      Hk.HotKey := ShortCut(VK_SPACE, [ssCtrl]);
      Key := 0;
    end;
  end;
end;

procedure TCnInputHelperForm.chkSpcCompleteClick(Sender: TObject);
begin
  chkIgnoreSpace.Enabled := chkSpcComplete.Checked;
end;

{$ENDIF CNWIZARDS_CNINPUTHELPER}
end.

