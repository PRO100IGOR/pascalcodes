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

unit CnSrcEditorEnhance;
{* |<PRE>
================================================================================
* ������ƣ�CnPack IDE ר�Ұ�
* ��Ԫ���ƣ�����༭����չ���õ�Ԫ
* ��Ԫ���ߣ���Х(LiuXiao) liuxiao@cnpack.org
* ��    ע��
* ����ƽ̨��PWin98SE + Delphi 6
* ���ݲ��ԣ����ޣ�PWin9X/2000/XP + Delphi 5/6/7 + C++Builder 5/6��
* �� �� �����ô����е��ַ������ϱ��ػ�����ʽ
* ��Ԫ��ʶ��$Id: CnSrcEditorEnhance.pas 819 2011-06-14 14:46:27Z liuxiao@cnpack.org $
* �޸ļ�¼��2011.06.14
*               LiuXiao ��������β�����Ҽ����е�ѡ��
*           2009.05.30 V1.3
*               LiuXiao �޸�֪ͨ�����޸Ĺ������ĸ��·�ʽ������ CPU ռ����
*           2007.05.02 V1.2
*               LiuXiao ����༭���Ҽ��˵��в��븡��������ť�Ĺ���
*           2004.06.12 V1.1
*               LiuXiao ������ļ�ʱ�Զ�ֻ�������Ĺ���
*           2003.06.24 V1.0
*               ������Ԫ��ʵ�ֹ���
================================================================================
|</PRE>}

interface

{$I CnWizards.inc}

{$IFDEF CNWIZARDS_CNSRCEDITORENHANCE}

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Dialogs, ToolsAPI,
  IniFiles, Menus, CnCommon, CnWizUtils, CnConsts, CnWizClasses, CnWizConsts,
  CnWizManager, ComCtrls, ActnList, CnSpin, StdCtrls, ExtCtrls, CnWizMultiLang,
  Forms, CnSrcEditorMisc, CnSrcEditorGutter, CnSrcEditorToolBar, CnSrcEditorNav,
  CnSrcEditorBlockTools, CnSrcEditorKey, CnEditControlWrapper, CnWizNotifier;

type

{ TCnSrcEditorEnhanceForm }

  TCnSrcEditorEnhanceForm = class(TCnTranslateForm)
    btnOK: TButton;
    btnCancel: TButton;
    btnHelp: TButton;
    ActionList: TActionList;
    actReplace: TAction;
    actAdd: TAction;
    actDelete: TAction;
    pgc1: TPageControl;
    ts1: TTabSheet;
    ts2: TTabSheet;
    grpEditorEnh: TGroupBox;
    chkAddMenuCloseOtherPages: TCheckBox;
    chkAddMenuSelAll: TCheckBox;
    chkAddMenuExplore: TCheckBox;
    chkCodeCompletion: TCheckBox;
    hkCodeCompletion: THotKey;
    grpAutoReadOnly: TGroupBox;
    lblDir: TLabel;
    chkAutoReadOnly: TCheckBox;
    lbReadOnlyDirs: TListBox;
    edtDir: TEdit;
    btnSelectDir: TButton;
    btnReplace: TButton;
    btnAdd: TButton;
    btnDel: TButton;
    grpLineNumber: TGroupBox;
    chkShowLineNumber: TCheckBox;
    grpToolBar: TGroupBox;
    chkShowToolBar: TCheckBox;
    btnToolBar: TButton;
    chkToolBarWrap: TCheckBox;
    rbLinePanelAutoWidth: TRadioButton;
    rbLinePanelFixedWidth: TRadioButton;
    lbl1: TLabel;
    seLinePanelFixWidth: TCnSpinEdit;
    chkShowLineCount: TCheckBox;
    lbl2: TLabel;
    seLinePanelMinWidth: TCnSpinEdit;
    dlgFontCurrLine: TFontDialog;
    dlgFontLine: TFontDialog;
    btnLineFont: TButton;
    btnCurrLineFont: TButton;
    grpEditorNav: TGroupBox;
    chkExtendForwardBack: TCheckBox;
    Label1: TLabel;
    seNavMinLineDiff: TCnSpinEdit;
    Label2: TLabel;
    seNavMaxItems: TCnSpinEdit;
    ts3: TTabSheet;
    gbTab: TGroupBox;
    chkDispModifiedInTab: TCheckBox;
    gbFlatButton: TGroupBox;
    chkShowFlatButton: TCheckBox;
    chkDblClkClosePage: TCheckBox;
    chkRClickShellMenu: TCheckBox;
    chkAddMenuShellMenu: TCheckBox;
    ts4: TTabSheet;
    grpKeyExtend: TGroupBox;
    chkShiftEnter: TCheckBox;
    chkHomeExtend: TCheckBox;
    chkHomeFirstChar: TCheckBox;
    grpAutoIndent: TGroupBox;
    chkAutoIndent: TCheckBox;
    mmoAutoIndent: TMemo;
    lbl3: TLabel;
    chkSearchAgain: TCheckBox;
    chkTabIndent: TCheckBox;
    chkShowInDesign: TCheckBox;
    chkAddMenuBlockTools: TCheckBox;
    chkAddMenuCopyFileName: TCheckBox;
    grpAutoSave: TGroupBox;
    chkAutoSave: TCheckBox;
    seSaveInterval: TCnSpinEdit;
    lblSaveInterval: TLabel;
    lblMinutes: TLabel;
    chkEditorMultiLine: TCheckBox;
    chkEditorFlatButtons: TCheckBox;
    grpSmart: TGroupBox;
    chkSmartCopy: TCheckBox;
    chkSmartPaste: TCheckBox;
    chkAutoBracket: TCheckBox;
    chkKeepSearch: TCheckBox;
    lbl4: TLabel;
    edtExploreCmdLine: TEdit;
    chkF2Rename: TCheckBox;
    hkRename: THotKey;
    chkSemicolon: TCheckBox;
    chkAutoEnterEnd: TCheckBox;
    btnDesignToolBar: TButton;
    chkLeftRightWrapLine: TCheckBox;
    procedure btnHelpClick(Sender: TObject);
    procedure UpdateContent(Sender: TObject);
    procedure FormKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure FormCreate(Sender: TObject);
    procedure actReplaceExecute(Sender: TObject);
    procedure actAddExecute(Sender: TObject);
    procedure lbReadOnlyDirsClick(Sender: TObject);
    procedure btnSelectDirClick(Sender: TObject);
    procedure actDeleteExecute(Sender: TObject);
    procedure ActionListUpdate(Action: TBasicAction; var Handled: Boolean);
    procedure btnToolBarClick(Sender: TObject);
    procedure btnLineFontClick(Sender: TObject);
    procedure btnCurrLineFontClick(Sender: TObject);
    procedure btnDesignToolBarClick(Sender: TObject);
  private
    { Private declarations }
  protected
    function GetHelpTopic: string; override;
  public
    { Public declarations }
  end;

//==============================================================================
// ����༭����չ��
//==============================================================================

{ TCnSrcEditorEnhance }

  TCnSrcEditorEnhance = class(TCnIDEEnhanceWizard)
  private
    FEditorMisc: TCnSrcEditorMisc;
    FToolbarMgr: TCnSrcEditorToolBarMgr;

    FGutterMgr: TCnSrcEditorGutterMgr;
  {$IFNDEF BDS}
    FNavMgr: TCnSrcEditorNavMgr;
  {$ENDIF}

    FBlockTools: TCnSrcEditorBlockTools;
    FEditorKey: TCnSrcEditorKey;

  {$IFDEF BDS}
    procedure EditorChanged(Editor: TEditorObject;
      ChangeType: TEditorChangeTypes);
    procedure EditControlNotify(EditControl: TControl; EditWindow: TCustomForm; 
      Operation: TOperation);
    procedure CheckToolBarEnableOnIdle(Sender: TObject);
  {$ENDIF}
  protected
    procedure SetActive(Value: Boolean); override;
    function GetHasConfig: Boolean; override;
    procedure OnEnhConfig_0(Sender: TObject);
    procedure OnEnhConfig_1(Sender: TObject);
    procedure OnEnhConfig_2(Sender: TObject);
    procedure OnEnhConfig_3(Sender: TObject);
  public
    constructor Create; override;
    destructor Destroy; override;
    class procedure GetWizardInfo(var Name, Author, Email, Comment: string); override;
    procedure LoadSettings(Ini: TCustomIniFile); override;
    procedure SaveSettings(Ini: TCustomIniFile); override;
    procedure Config; override;
    procedure ConfigEx(APageIndex: Integer);
    procedure LanguageChanged(Sender: TObject); override;

    property GutterMgr: TCnSrcEditorGutterMgr read FGutterMgr;
  {$IFNDEF BDS}
    property NavMgr: TCnSrcEditorNavMgr read FNavMgr;
  {$ENDIF}
  
    property ToolBarMgr: TCnSrcEditorToolBarMgr read FToolbarMgr;
    property EditorMisc: TCnSrcEditorMisc read FEditorMisc;
    property BlockTools: TCnSrcEditorBlockTools read FBlockTools;
    property EditorKey: TCnSrcEditorKey read FEditorKey;
  end;

{$ENDIF CNWIZARDS_CNSRCEDITORENHANCE}

implementation

{$IFDEF CNWIZARDS_CNSRCEDITORENHANCE}

{$R *.DFM}

uses
{$IFDEF DEBUG}
  CnDebug,
{$ENDIF}
  CnWizOptions, CnWizIdeUtils;

{ TCnSrcEditorEnhanceForm }

procedure TCnSrcEditorEnhanceForm.btnHelpClick(Sender: TObject);
begin
  ShowFormHelp;
end;

function TCnSrcEditorEnhanceForm.GetHelpTopic: string;
begin
  Result := 'CnSrcEditorEnhance';
end;

procedure TCnSrcEditorEnhanceForm.UpdateContent(Sender: TObject);
begin
  edtExploreCmdLine.Enabled := chkAddMenuExplore.Checked;
  hkCodeCompletion.Enabled := chkCodeCompletion.Checked;
  lbReadOnlyDirs.Enabled := chkAutoReadOnly.Checked;
  lblDir.Enabled := chkAutoReadOnly.Checked;
  edtDir.Enabled := chkAutoReadOnly.Checked;
  btnSelectDir.Enabled := chkAutoReadOnly.Checked;

  btnToolBar.Enabled := chkShowToolBar.Checked;
  btnDesignToolBar.Enabled := chkShowInDesign.Checked;
{$IFDEF BDS}
  chkEditorMultiLine.Enabled := False;
  chkEditorFlatButtons.Enabled := False;  
{$ELSE}
  chkShowInDesign.Enabled := False;
{$ENDIF}
  chkToolBarWrap.Enabled := chkShowToolBar.Checked or
    chkShowInDesign.Enabled and chkShowInDesign.Checked;

  chkShowLineCount.Enabled := chkShowLineNumber.Checked;
  rbLinePanelAutoWidth.Enabled := chkShowLineNumber.Checked;
  btnLineFont.Enabled := chkShowLineNumber.Checked;
  btnCurrLineFont.Enabled := chkShowLineNumber.Checked;

  seLinePanelMinWidth.Enabled := chkShowLineNumber.Checked and
    rbLinePanelAutoWidth.Checked;
  rbLinePanelFixedWidth.Enabled := chkShowLineNumber.Checked;
  seLinePanelFixWidth.Enabled := chkShowLineNumber.Checked and
    rbLinePanelFixedWidth.Checked;

  lblSaveInterval.Enabled := chkAutoSave.Checked;
  lblMinutes.Enabled := chkAutoSave.Checked;
  seSaveInterval.Enabled := chkAutoSave.Checked;
  
  seNavMinLineDiff.Enabled := chkExtendForwardBack.Checked;
  seNavMaxItems.Enabled := chkExtendForwardBack.Checked;

  chkHomeFirstChar.Enabled := chkHomeExtend.Checked;
  chkKeepSearch.Enabled := chkSearchAgain.Checked;

  mmoAutoIndent.Enabled := chkAutoIndent.Checked;
end;

procedure TCnSrcEditorEnhanceForm.FormKeyDown(Sender: TObject;
  var Key: Word; Shift: TShiftState);
begin
  if ActiveControl <> hkCodeCompletion then
    Exit;

  if Key = VK_SPACE then
  begin
    if ssAlt in Shift then
    begin
      hkCodeCompletion.HotKey := ShortCut(VK_SPACE, [ssAlt]);
      Key := 0;
    end
    else if ssCtrl in Shift then
    begin
      hkCodeCompletion.HotKey := ShortCut(VK_SPACE, [ssCtrl]);
      Key := 0;
    end;
  end;
end;

procedure TCnSrcEditorEnhanceForm.FormCreate(Sender: TObject);
begin
  pgc1.ActivePageIndex := 0;
end;

procedure TCnSrcEditorEnhanceForm.actReplaceExecute(Sender: TObject);
begin
  if lbReadOnlyDirs.ItemIndex >= 0 then
    lbReadOnlyDirs.Items[lbReadOnlyDirs.ItemIndex] := Trim(edtDir.Text);
end;

procedure TCnSrcEditorEnhanceForm.actAddExecute(Sender: TObject);
begin
  if Trim(edtDir.Text) <> '' then
  begin
    lbReadOnlyDirs.Items.Add(Trim(edtDir.Text));
    lbReadOnlyDirs.ItemIndex := lbReadOnlyDirs.Items.Count - 1;
  end;
end;

procedure TCnSrcEditorEnhanceForm.lbReadOnlyDirsClick(Sender: TObject);
begin
  if lbReadOnlyDirs.ItemIndex >= 0 then
    edtDir.Text := lbReadOnlyDirs.Items[lbReadOnlyDirs.ItemIndex];
end;

procedure TCnSrcEditorEnhanceForm.btnSelectDirClick(Sender: TObject);
var
  NewDir: string;
begin
  NewDir := ReplaceToActualPath(edtDir.Text);
  if GetDirectory(SCnSelectDir, NewDir) then
    edtDir.Text := NewDir;
end;

procedure TCnSrcEditorEnhanceForm.btnToolBarClick(Sender: TObject);
var
  Wizard: TCnSrcEditorEnhance;
begin
  Wizard := CnWizardMgr.WizardByClass(TCnSrcEditorEnhance) as TCnSrcEditorEnhance;
  if Wizard <> nil then
    Wizard.ToolBarMgr.ConfigToolBar(tbtCode);
end;

procedure TCnSrcEditorEnhanceForm.btnDesignToolBarClick(Sender: TObject);
var
  Wizard: TCnSrcEditorEnhance;
begin
  Wizard := CnWizardMgr.WizardByClass(TCnSrcEditorEnhance) as TCnSrcEditorEnhance;
  if Wizard <> nil then
    Wizard.ToolBarMgr.ConfigToolBar(tbtDesign);
end;

procedure TCnSrcEditorEnhanceForm.actDeleteExecute(Sender: TObject);
begin
  if lbReadOnlyDirs.ItemIndex >= 0 then
  begin
    lbReadOnlyDirs.Items.Delete(lbReadOnlyDirs.ItemIndex);
    lbReadOnlyDirs.SetFocus;
  end;
end;

procedure TCnSrcEditorEnhanceForm.btnLineFontClick(Sender: TObject);
begin
  dlgFontLine.Execute;
end;

procedure TCnSrcEditorEnhanceForm.btnCurrLineFontClick(Sender: TObject);
begin
  dlgFontCurrLine.Execute;
end;

procedure TCnSrcEditorEnhanceForm.ActionListUpdate(Action: TBasicAction;
  var Handled: Boolean);
begin
  if not chkAutoReadOnly.Checked then
  begin
    (Action as TAction).Enabled := False;
    Handled := True;
    Exit;
  end;

  if Action = actReplace then
  begin
    (Action as TAction).Enabled := (lbReadOnlyDirs.ItemIndex >= 0) and
      (edtDir.Text <> lbReadOnlyDirs.Items[lbReadOnlyDirs.ItemIndex]) and (Trim(edtDir.Text) <> '');
  end
  else if Action = actAdd then
  begin
    (Action as TAction).Enabled := (lbReadOnlyDirs.Items.IndexOf(edtDir.Text) < 0)
       and (Trim(edtDir.Text) <> '');
  end
  else if Action = actDelete then
  begin
    (Action as TAction).Enabled := lbReadOnlyDirs.ItemIndex >= 0;
  end;
  Handled := True;
end;

//==============================================================================
// ����༭����չ��
//==============================================================================

{ TCnSrcEditorEnhance }

constructor TCnSrcEditorEnhance.Create;
begin
  inherited;
  FEditorMisc := TCnSrcEditorMisc.Create;
  FToolbarMgr := TCnSrcEditorToolBarMgr.Create;

  if Assigned(CreateEditorToolBarServiceProc) then
    CreateEditorToolBarServiceProc();

  FToolbarMgr.OnEnhConfig := OnEnhConfig_1;
  FGutterMgr := TCnSrcEditorGutterMgr.Create;
  FGutterMgr.OnEnhConfig := OnEnhConfig_1;
{$IFNDEF BDS}
  FNavMgr := TCnSrcEditorNavMgr.Create;
  FNavMgr.OnEnhConfig := OnEnhConfig_1;
{$ENDIF}
  FBlockTools := TCnSrcEditorBlockTools.Create;
  FBlockTools.OnEnhConfig := OnEnhConfig_2;
  FEditorKey := TCnSrcEditorKey.Create;
  FEditorKey.OnEnhConfig := OnEnhConfig_3;
{$IFDEF BDS}
  EditControlWrapper.AddEditorChangeNotifier(EditorChanged);
  EditControlWrapper.AddEditControlNotifier(EditControlNotify);
{$ENDIF}
end;

destructor TCnSrcEditorEnhance.Destroy;
begin
{$IFDEF BDS}
  EditControlWrapper.RemoveEditorChangeNotifier(EditorChanged);
  EditControlWrapper.RemoveEditControlNotifier(EditControlNotify);
{$ENDIF}
  FEditorMisc.Free;
  FToolbarMgr.Free;
  
  CnEditorToolBarService := nil;
  FGutterMgr.Free;
{$IFNDEF BDS}
  FNavMgr.Free;
{$ENDIF}
  FBlockTools.Free;
  FEditorKey.Free;
  inherited;
end;

procedure TCnSrcEditorEnhance.LanguageChanged(Sender: TObject);
begin
  inherited;
  FEditorMisc.LanguageChanged(Sender);
  FToolbarMgr.LanguageChanged(Sender);
  if CnEditorToolBarService <> nil then
    CnEditorToolBarService.LanguageChanged;
  FGutterMgr.LanguageChanged(Sender);
{$IFNDEF BDS}
  FNavMgr.LanguageChanged(Sender);
{$ENDIF}
  FBlockTools.LanguageChanged(Sender);
  FEditorKey.LanguageChanged(Sender);
end;

//------------------------------------------------------------------------------
// ��������
//------------------------------------------------------------------------------

procedure TCnSrcEditorEnhance.LoadSettings(Ini: TCustomIniFile);
begin
  FEditorMisc.LoadSettings(Ini);
  FToolbarMgr.LoadSettings(Ini);
  FGutterMgr.LoadSettings(Ini);
{$IFNDEF BDS}
  FNavMgr.LoadSettings(Ini);
{$ENDIF}
  FBlockTools.LoadSettings(Ini);
  FEditorKey.LoadSettings(Ini);
end;

procedure TCnSrcEditorEnhance.SaveSettings(Ini: TCustomIniFile);
begin
  FEditorMisc.SaveSettings(Ini);
  FToolbarMgr.SaveSettings(Ini);
  FGutterMgr.SaveSettings(Ini);
{$IFNDEF BDS}
  FNavMgr.SaveSettings(Ini);
{$ENDIF}
  FBlockTools.SaveSettings(Ini);
  FEditorKey.SaveSettings(Ini);
end;

procedure TCnSrcEditorEnhance.SetActive(Value: Boolean);
begin
  inherited;
  FEditorMisc.Active := Value;
  FToolbarMgr.Active := Value;
  FGutterMgr.Active := Value;
{$IFNDEF BDS}
  FNavMgr.Active := Value;
{$ENDIF}
  FBlockTools.Active := Value;
  FEditorKey.Active := Value;
end;

function TCnSrcEditorEnhance.GetHasConfig: Boolean;
begin
  Result := True;
end;

procedure TCnSrcEditorEnhance.Config;
begin
  ConfigEx(0);
end;

procedure TCnSrcEditorEnhance.ConfigEx(APageIndex: Integer);
begin
  with TCnSrcEditorEnhanceForm.Create(nil) do
  try
    pgc1.ActivePageIndex := APageIndex;
    chkAddMenuCloseOtherPages.Checked := FEditorMisc.AddMenuCloseOtherPages;
    chkAddMenuSelAll.Checked := FEditorMisc.AddMenuSelAll;
    chkAddMenuExplore.Checked := FEditorMisc.AddMenuExplore;
    chkAddMenuCopyFileName.Checked := FEditorMisc.AddMenuCopyFileName;
    chkAddMenuShellMenu.Checked := FEditorMisc.AddMenuShell;
    edtExploreCmdLine.Text := FEditorMisc.ExploreCmdLine;
    chkCodeCompletion.Checked := FEditorMisc.ChangeCodeComKey;
    hkCodeCompletion.HotKey := FEditorMisc.CodeCompletionKey;

    chkAutoReadOnly.Checked := FEditorMisc.AutoReadOnly;
    lbReadOnlyDirs.Items.Assign(FEditorMisc.ReadOnlyDirs);

    chkDispModifiedInTab.Checked := FEditorMisc.DispModifiedInTab;
  {$IFDEF BDS}
    chkDispModifiedInTab.Enabled := False;
    chkShowInDesign.Checked := FToolbarMgr.ShowDesignToolBar;
  {$ELSE}
    chkShowInDesign.Enabled := False;
  {$ENDIF}

    chkDblClkClosePage.Checked := FEditorMisc.DblClickClosePage;
    chkRClickShellMenu.Checked := FEditorMisc.RClickShellMenu;

    chkShowToolBar.Checked := FToolbarMgr.ShowToolBar;
    chkToolBarWrap.Checked := FToolbarMgr.Wrapable;

    chkShowLineNumber.Checked := FGutterMgr.ShowLineNumber;
    chkShowLineCount.Checked := FGutterMgr.ShowLineCount;
    rbLinePanelAutoWidth.Checked := FGutterMgr.AutoWidth;
    rbLinePanelFixedWidth.Checked := not FGutterMgr.AutoWidth;
    dlgFontLine.Font := FGutterMgr.Font;
    dlgFontCurrLine.Font := FGutterMgr.CurrFont;
    seLinePanelMinWidth.Value := FGutterMgr.MinWidth;
    seLinePanelFixWidth.Value := FGutterMgr.FixedWidth;

    chkEditorMultiLine.Checked := FEditorMisc.EditorTabMultiLine;
    chkEditorFlatButtons.Checked := FEditorMisc.EditorTabFlatButton;  
  {$IFNDEF BDS}
    chkExtendForwardBack.Checked := FNavMgr.ExtendForwardBack;
    seNavMinLineDiff.Value := FNavMgr.MinLineDiff;
    seNavMaxItems.Value := FNavMgr.MaxItems;
  {$ELSE}
    chkExtendForwardBack.Enabled := False;
    seNavMinLineDiff.Enabled := False;
    seNavMaxItems.Enabled := False;
    chkEditorMultiLine.Checked := False;
    chkEditorFlatButtons.Checked := False;
  {$ENDIF}

    chkShowFlatButton.Checked := FBlockTools.ShowBlockTools;
    chkAddMenuBlockTools.Checked := FEditorMisc.AddMenuBlockTools;

    chkAutoSave.Checked := FEditorMisc.AutoSave;
    seSaveInterval.Value := FEditorMisc.SaveInterval;

    chkSmartCopy.Checked := FEditorKey.SmartCopy;
    chkSmartPaste.Checked := FEditorKey.SmartPaste;
    chkTabIndent.Checked := FBlockTools.TabIndent;
    chkAutoBracket.Checked := FEditorKey.AutoBracket;
    chkShiftEnter.Checked := FEditorKey.ShiftEnter;
    chkHomeExtend.Checked := FEditorKey.HomeExt;
    chkLeftRightWrapLine.Checked := FEditorKey.LeftRightLineWrap;
    chkSearchAgain.Checked := FEditorKey.F3Search;
    chkF2Rename.Checked := FEditorKey.F2Rename;
    hkRename.HotKey := FEditorKey.RenameShortCut;
    chkSemicolon.Checked := FEditorKey.SemicolonLastChar;
    chkKeepSearch.Checked := FEditorKey.KeepSearch;
    chkHomeFirstChar.Checked := FEditorKey.HomeFirstChar;

  {$IFNDEF DELPHI10_UP}
    chkAutoEnterEnd.Checked := FEditorKey.AutoEnterEnd;
    chkAutoIndent.Checked := FEditorKey.AutoIndent;
    mmoAutoIndent.Lines.Assign(FEditorKey.AutoIndentList);
  {$ELSE}
    grpAutoIndent.Enabled := False;
    lbl3.Enabled := False;
    chkAutoIndent.Enabled := False;
    mmoAutoIndent.Enabled := False;
    chkAutoEnterEnd.Enabled := False;
  {$ENDIF}

    UpdateContent(nil);

    if ShowModal = mrOK then
    begin
      FEditorMisc.AddMenuCloseOtherPages := chkAddMenuCloseOtherPages.Checked;
      FEditorMisc.AddMenuSelAll := chkAddMenuSelAll.Checked;
      FEditorMisc.AddMenuExplore := chkAddMenuExplore.Checked;
      FEditorMisc.AddMenuCopyFileName := chkAddMenuCopyFileName.Checked;
      FEditorMisc.AddMenuShell := chkAddMenuShellMenu.Checked;
      FEditorMisc.ExploreCmdLine := Trim(edtExploreCmdLine.Text);
      if FEditorMisc.ExploreCmdLine = '' then
        FEditorMisc.ExploreCmdLine := csDefExploreCmdLine;
      FEditorMisc.ChangeCodeComKey := chkCodeCompletion.Checked;
      FEditorMisc.CodeCompletionKey := hkCodeCompletion.HotKey;

      FEditorMisc.AutoReadOnly := chkAutoReadOnly.Checked;
      FEditorMisc.ReadOnlyDirs := lbReadOnlyDirs.Items;

      FEditorMisc.DblClickClosePage := chkDblClkClosePage.Checked;
      FEditorMisc.DispModifiedInTab := chkDispModifiedInTab.Checked;
      FEditorMisc.RClickShellMenu := chkRClickShellMenu.Checked;

      if FEditorMisc.EditorTabMultiLine <> chkEditorMultiLine.Checked then
      begin
        FEditorMisc.EditorTabMultiLine := chkEditorMultiLine.Checked;
        FEditorMisc.UpdateEditorTabStyle;
      end;
      if FEditorMisc.EditorTabFlatButton <> chkEditorFlatButtons.Checked then
      begin
        FEditorMisc.EditorTabFlatButton := chkEditorFlatButtons.Checked;
        FEditorMisc.UpdateEditorTabStyle;
      end;

      FEditorMisc.AddMenuBlockTools := chkAddMenuBlockTools.Checked;
      FEditorMisc.AutoSave := chkAutoSave.Checked;
      FEditorMisc.SaveInterval := seSaveInterval.Value;

      FToolbarMgr.ShowToolBar := chkShowToolBar.Checked;
      FToolbarMgr.Wrapable := chkToolBarWrap.Checked;

      FGutterMgr.ShowLineNumber := chkShowLineNumber.Checked;
      FGutterMgr.ShowLineCount := chkShowLineCount.Checked;
      FGutterMgr.AutoWidth := rbLinePanelAutoWidth.Checked;
      FGutterMgr.AutoWidth := not rbLinePanelFixedWidth.Checked;
      FGutterMgr.Font := dlgFontLine.Font;
      FGutterMgr.CurrFont := dlgFontCurrLine.Font;
      FGutterMgr.MinWidth := seLinePanelMinWidth.Value;
      FGutterMgr.FixedWidth := seLinePanelFixWidth.Value;
      FGutterMgr.UpdateGutters;

    {$IFNDEF BDS}
      FNavMgr.MinLineDiff := seNavMinLineDiff.Value;
      FNavMgr.MaxItems := seNavMaxItems.Value;
      FNavMgr.ExtendForwardBack := chkExtendForwardBack.Checked;
      FNavMgr.UpdateInstall;
    {$ELSE}
      FToolbarMgr.ShowDesignToolBar := chkShowInDesign.Checked;
    {$ENDIF}

      FBlockTools.ShowBlockTools := chkShowFlatButton.Checked;
      FEditorKey.SmartCopy := chkSmartCopy.Checked;
      FEditorKey.SmartPaste := chkSmartPaste.Checked;
      FBlockTools.TabIndent := chkTabIndent.Checked;
      FEditorKey.AutoBracket := chkAutoBracket.Checked;
      FEditorKey.ShiftEnter := chkShiftEnter.Checked;
      FEditorKey.HomeExt := chkHomeExtend.Checked;
      FEditorKey.LeftRightLineWrap := chkLeftRightWrapLine.Checked;
      FEditorKey.F3Search := chkSearchAgain.Checked;
      FEditorKey.F2Rename := chkF2Rename.Checked;
      FEditorKey.RenameShortCut := hkRename.HotKey;
      FEditorKey.KeepSearch := chkKeepSearch.Checked;
      FEditorKey.HomeFirstChar := chkHomeFirstChar.Checked;
      FEditorKey.SemicolonLastChar := chkSemicolon.Checked;
    {$IFNDEF DELPHI10_UP}
      FEditorKey.AutoEnterEnd := chkAutoEnterEnd.Checked;
      FEditorKey.AutoIndent := chkAutoIndent.Checked;
      FEditorKey.AutoIndentList.Assign(mmoAutoIndent.Lines);
    {$ENDIF}

      DoSaveSettings;
    end;
  finally
    Free;
  end;
end;

{$IFDEF BDS}

procedure TCnSrcEditorEnhance.EditorChanged(Editor: TEditorObject;
  ChangeType: TEditorChangeTypes);
begin
  if Active and (ChangeType * [ctTopEditorChanged] <> []) then
    FToolbarMgr.CheckToolBarEnable;
end;

procedure TCnSrcEditorEnhance.CheckToolBarEnableOnIdle(Sender: TObject);
begin
  FToolbarMgr.CheckToolBarEnable;
end;

procedure TCnSrcEditorEnhance.EditControlNotify(EditControl: TControl;
  EditWindow: TCustomForm; Operation: TOperation);
begin
  CnWizNotifierServices.ExecuteOnApplicationIdle(CheckToolBarEnableOnIdle)
end;

{$ENDIF}

procedure TCnSrcEditorEnhance.OnEnhConfig_0(Sender: TObject);
begin
  ConfigEx(0);
end;

procedure TCnSrcEditorEnhance.OnEnhConfig_1(Sender: TObject);
begin
  ConfigEx(1);
end;

procedure TCnSrcEditorEnhance.OnEnhConfig_2(Sender: TObject);
begin
  ConfigEx(2);
end;

procedure TCnSrcEditorEnhance.OnEnhConfig_3(Sender: TObject);
begin
  ConfigEx(3);
end;

class procedure TCnSrcEditorEnhance.GetWizardInfo(var Name, Author,
  Email, Comment: string);
begin
  Name := SCnEditorEnhanceWizardName;
  Author := SCnPack_Zjy + ';' + SCnPack_LiuXiao + ';' +
    SCnPack_Leeon + ';' + SCnPack_DragonPC;
  Email := SCnPack_ZjyEmail + ';' + SCnPack_LiuXiaoEmail +
    ';' + SCnPack_LeeonEmail + ';' + SCnPack_DragonPCEmail;
  Comment := SCnEditorEnhanceWizardComment;
end;

initialization
  RegisterCnWizard(TCnSrcEditorEnhance);

{$ENDIF CNWIZARDS_CNSRCEDITORENHANCE}
end.
