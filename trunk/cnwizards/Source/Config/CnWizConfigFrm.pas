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

unit CnWizConfigFrm;
{* |<PRE>
================================================================================
* ������ƣ�CnPack IDE ר�Ұ�
* ��Ԫ���ƣ�ר�����ô��嵥Ԫ
* ��Ԫ���ߣ��ܾ��� (zjy@cnpack.org)
* ��    ע��
* ����ƽ̨��PWin2000Pro + Delphi 5.01
* ���ݲ��ԣ�PWin9X/2000/XP + Delphi 5/6/7 + C++Builder 5/6
* �� �� �����õ�Ԫ�е��ַ��������ϱ��ػ�����ʽ
* ��Ԫ��ʶ��$Id: CnWizConfigFrm.pas 763 2011-02-07 14:18:23Z liuxiao@cnpack.org $
* �޸ļ�¼��
*           2004.11.18 V1.4
*               ����listbox�Ի����ʺ�120DPI��С���� (shenloqi)
*           2003.06.25 V1.3
*               �Ƴ� IDE ��չ���ý��� (LiuXiao)
*           2003.05.01 V1.2
*               ���� IDE ��չ����
*           2003.03.20 V1.1
*               �������Ա༭������
*           2002.10.01 V1.0
*               ������Ԫ
================================================================================
|</PRE>}

interface

{$I CnWizards.inc}

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  Menus, ExtCtrls, ComCtrls, ToolWin, StdCtrls, CnDesignEditor, CnWizMultiLang,
  CnDesignEditorConsts, ImgList, Buttons;

type

//==============================================================================
// ר�����ô���
//==============================================================================

{ TCnWizConfigForm }

  TCnWizConfigForm = class(TCnTranslateForm)
    PageControl: TPageControl;
    pnlButton: TPanel;
    btnHelp: TButton;
    btnOK: TButton;
    btnCancel: TButton;
    tsWizards: TTabSheet;
    lbWizards: TListBox;
    pnlWizard: TPanel;
    lblWizardName: TLabel;
    bvlWizard: TBevel;
    Label1: TLabel;
    lblWizardAuthor: TLabel;
    lblWizardComment: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    HotKeyWizard: THotKey;
    Label5: TLabel;
    cbWizardActive: TCheckBox;
    btnConfig: TButton;
    lblWizardKind: TLabel;
    Label7: TLabel;
    tsEnvOption: TTabSheet;
    grpOthers: TGroupBox;
    Label2: TLabel;
    gbHintWnd: TGroupBox;
    cbShowWizComment: TCheckBox;
    btnResetWizComment: TButton;
    cbShowHint: TCheckBox;
    gbUpdate: TGroupBox;
    rbUpgradeDisabled: TRadioButton;
    rbUpgradeAll: TRadioButton;
    cbUpgradeReleaseOnly: TCheckBox;
    btnCheckUpgrade: TButton;
    tsPropEditor: TTabSheet;
    Panel1: TPanel;
    lblDesignEditorName: TLabel;
    Bevel1: TBevel;
    Label11: TLabel;
    lblDesignEditorAuthor: TLabel;
    lblDesignEditorComment: TLabel;
    Label14: TLabel;
    Label16: TLabel;
    lblDesignEditorKind: TLabel;
    Label18: TLabel;
    cbDesignEditorActive: TCheckBox;
    btnDesignEditorConfig: TButton;
    lbDesignEditors: TListBox;
    imgIcon: TImage;
    Image1: TImage;
    dlgSaveActionList: TSaveDialog;
    grpTools: TGroupBox;
    btnExportImagelist: TButton;
    btnExportActionList: TButton;
    btnExportComponents: TButton;
    btnSort: TButton;
    chkUseToolsMenu: TCheckBox;
    btnDesignEditorCustomize: TButton;
    ilEnable: TImageList;
    chkUserDir: TCheckBox;
    edtUserDir: TEdit;
    btnUserDir: TSpeedButton;
    chkFixThreadLocale: TCheckBox;
    chkUseOneCPUCore: TCheckBox;
    procedure lbWizardsDrawItem(Control: TWinControl; Index: Integer;
      Rect: TRect; State: TOwnerDrawState);
    procedure FormCreate(Sender: TObject);
    procedure lbWizardsClick(Sender: TObject);
    procedure HotKeyWizardExit(Sender: TObject);
    procedure cbWizardActiveClick(Sender: TObject);
    procedure btnConfigClick(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure FormResize(Sender: TObject);
    procedure lbWizardsDblClick(Sender: TObject);
    procedure btnResetWizCommentClick(Sender: TObject);
    procedure btnHelpClick(Sender: TObject);
    procedure cbShowHintClick(Sender: TObject);
    procedure UpdateControls(Sender: TObject);
    procedure btnCheckUpgradeClick(Sender: TObject);
    procedure lbDesignEditorsClick(Sender: TObject);
    procedure lbDesignEditorsDblClick(Sender: TObject);
    procedure lbDesignEditorsDrawItem(Control: TWinControl; Index: Integer;
      Rect: TRect; State: TOwnerDrawState);
    procedure cbDesignEditorActiveClick(Sender: TObject);
    procedure btnDesignEditorConfigClick(Sender: TObject);
    procedure btnExportImagelistClick(Sender: TObject);
    procedure btnExportActionListClick(Sender: TObject);
    procedure btnExportComponentsClick(Sender: TObject);
    procedure btnSortClick(Sender: TObject);
    procedure btnDesignEditorCustomizeClick(Sender: TObject);
    procedure btnUserDirClick(Sender: TObject);
  private
    { Private declarations }
    FShortCuts: array of TShortCut;
    FActives: array of Boolean;
    FEditorActives: array of Boolean;
    FDrawTextHeight: Integer;
  protected
    function GetHelpTopic: string; override;
  public
    { Public declarations }
  end;

// ��ʾ���ô���
procedure ShowCnWizConfigForm(AIcon: TIcon = nil);

implementation

uses
  CnWizManager, CnWizClasses, CnCommon, CnWizConsts, CnWizShortCut, CnWizOptions,
  CnWizCommentFrm, CnWizUtils, CnWizUpgradeFrm, CnWizIdeUtils, CnWizMenuSortFrm;

const
  csSelectedColor = $FFB0B0;
  csNormalColor = $FFF4F4;
  csShadowColor = $444444;

  csLastSelectedItem = 'LastSelectedItem';

{$R *.DFM}

// ��ʾ���ô���
procedure ShowCnWizConfigForm(AIcon: TIcon = nil);
begin
  with TCnWizConfigForm.Create(Application.MainForm) do
  try
    ShowHint := WizOptions.ShowHint;
    if AIcon <> nil then
      Icon := AIcon;
    ShowModal;
  finally
    Free;
  end;
end;

//==============================================================================
// ר�����ô���
//==============================================================================

{ TCnWizConfigForm }

// �����ʼ��
procedure TCnWizConfigForm.FormCreate(Sender: TObject);
var
  i: Integer;
begin
  // ר������ҳ��
  SetLength(FShortCuts, CnWizardMgr.WizardCount);
  SetLength(FActives, CnWizardMgr.WizardCount);
  for i := 0 to CnWizardMgr.WizardCount - 1 do
  begin
    FActives[i] := CnWizardMgr[i].Active;
    if CnWizardMgr[i] is TCnActionWizard then
      FShortCuts[i] := TCnActionWizard(CnWizardMgr[i]).Action.ShortCut
    else
      FShortCuts[i] := 0;
    lbWizards.Items.AddObject(CnWizardMgr[i].WizardName, CnWizardMgr[i]);
  end;
  lbWizards.ItemIndex := WizOptions.ReadInteger(SCnOptionSection, csLastSelectedItem, 0);
  lbWizardsClick(lbWizards);
  ActiveControl := lbWizards;

  // ���Ա༭��ҳ��
  SetLength(FEditorActives, CnDesignEditorMgr.PropEditorCount +
    CnDesignEditorMgr.CompEditorCount);
  for i := 0 to CnDesignEditorMgr.PropEditorCount - 1 do
  begin
    FEditorActives[i] := CnDesignEditorMgr.PropEditors[i].Active;
    lbDesignEditors.Items.AddObject(CnDesignEditorMgr.PropEditors[i].Name,
      CnDesignEditorMgr.PropEditors[i]);
  end;

  for i := 0 to CnDesignEditorMgr.CompEditorCount - 1 do
  begin
    FEditorActives[CnDesignEditorMgr.PropEditorCount + i] :=
      CnDesignEditorMgr.CompEditors[i].Active;
    lbDesignEditors.Items.AddObject(CnDesignEditorMgr.CompEditors[i].Name, CnDesignEditorMgr.CompEditors[i]);
  end;
  lbDesignEditors.ItemIndex := 0;
  lbDesignEditorsClick(lbDesignEditors);

  // ��������ҳ��
  chkUseToolsMenu.Checked := WizOptions.UseToolsMenu;
  cbShowHint.Checked := WizOptions.ShowHint;
  cbShowWizComment.Checked := WizOptions.ShowWizComment;
  chkUseOneCPUCore.Checked := WizOptions.UseOneCPUCore;
  chkFixThreadLocale.Checked := WizOptions.FixThreadLocale;

  // ��������
  if WizOptions.UpgradeStyle = usDisabled then
    rbUpgradeDisabled.Checked := True
  else
    rbUpgradeAll.Checked := True;
  cbUpgradeReleaseOnly.Checked := WizOptions.UpgradeReleaseOnly;

  //�Ի��߶ȵ���
  FDrawTextHeight := 12;
  if Scaled then
  begin
    FDrawTextHeight := FScaler.MultiPPI(FDrawTextHeight, Self);
    lbWizards.ItemHeight := FScaler.MultiPPI(lbWizards.ItemHeight, Self);
    lbDesignEditors.ItemHeight := FScaler.MultiPPI(lbDesignEditors.ItemHeight, Self);
  end;

  chkUserDir.Checked := WizOptions.UseCustomUserDir;
  edtUserDir.Text := WizOptions.CustomUserDir;

  UpdateControls(nil);

  PageControl.ActivePageIndex := 0;
end;

// �����ͷ�
procedure TCnWizConfigForm.FormDestroy(Sender: TObject);
var
  i: Integer;
begin
  if ModalResult = mrOK then
  begin
    // ר������ҳ��
    WizShortCutMgr.BeginUpdate;
    try
      for i := 0 to CnWizardMgr.WizardCount - 1 do
      begin
        CnWizardMgr[i].Active := FActives[i];
        if CnWizardMgr[i] is TCnActionWizard then
          TCnActionWizard(CnWizardMgr[i]).Action.ShortCut := FShortCuts[i];
      end;
    finally
      WizShortCutMgr.EndUpdate;
    end;

    // ���Ա༭��ҳ��
    for i := 0 to CnDesignEditorMgr.PropEditorCount - 1 do
      CnDesignEditorMgr.PropEditors[i].Active := FEditorActives[i];

    for i := 0 to CnDesignEditorMgr.CompEditorCount - 1 do
      CnDesignEditorMgr.CompEditors[i].Active :=
        FEditorActives[CnDesignEditorMgr.PropEditorCount + i];

    CnDesignEditorMgr.UnRegister;
    CnDesignEditorMgr.Register;

    // ��������ҳ��
    WizOptions.UseToolsMenu := chkUseToolsMenu.Checked;
    WizOptions.ShowHint := cbShowHint.Checked;
    WizOptions.ShowWizComment := cbShowWizComment.Checked;
    WizOptions.UseOneCPUCore := chkUseOneCPUCore.Checked;
    WizOptions.FixThreadLocale := chkFixThreadLocale.Checked;

    // ��������
    if rbUpgradeDisabled.Checked then
      WizOptions.UpgradeStyle := usDisabled
    else
      WizOptions.UpgradeStyle := usAllUpgrade;
    WizOptions.UpgradeReleaseOnly := cbUpgradeReleaseOnly.Checked;

    WizOptions.UseCustomUserDir := chkUserDir.Checked;
    WizOptions.CustomUserDir := edtUserDir.Text;
    
    WizOptions.WriteInteger(SCnOptionSection, csLastSelectedItem, lbWizards.ItemIndex);

    WizOptions.SaveSettings;
    CnWizardMgr.SaveSettings;
  end;
  FShortCuts := nil;
  FActives := nil;
  FEditorActives := nil;
end;

// �����С���ʱˢ���б����ʾ
procedure TCnWizConfigForm.FormResize(Sender: TObject);
begin
  lbWizards.Refresh;                    // �����б��ˢ�²�����������
  lbDesignEditors.Refresh;
end;

//------------------------------------------------------------------------------
// ר�����ô���
//------------------------------------------------------------------------------

// ���� ListBox ��Ŀ
procedure TCnWizConfigForm.lbWizardsDrawItem(Control: TWinControl;
  Index: Integer; Rect: TRect; State: TOwnerDrawState);
var
  ListBox: TListBox;
  Canvas: TCanvas;
  ARect: TRect;
  R: TRect;
  Wizard: TCnBaseWizard;
  x, y: Integer;
  Bmp: TBitmap;
  EnableIndex, EnableIconMargin: Integer;
begin
  if not (Control is TListBox) then Exit;
  ListBox := TListBox(Control);
  Wizard := TCnBaseWizard(ListBox.Items.Objects[Index]);

  // ������ʱλͼ��������˸
  Bmp := TBitmap.Create;
  try
    Bmp.PixelFormat := pf24bit;
    Bmp.Width := RectWidth(Rect);
    Bmp.Height := RectHeight(Rect);
    ARect := Bounds(0, 0, Bmp.Width, Bmp.Height);

    R.Left := ARect.Left + 4;
    R.Right := ARect.Right - 5;
    R.Top := ARect.Top + 2;
    R.Bottom := ARect.Bottom - 2;

    Canvas := Bmp.Canvas;
    Canvas.Font.Assign(ListBox.Font);
    Canvas.Brush.Style := bsSolid;
    Canvas.Brush.Color := ListBox.Color;
    Canvas.FillRect(ARect);
    Canvas.Brush.Color := csShadowColor;
    Canvas.RoundRect(R.Left + 1, R.Top + 1, R.Right + 1, R.Bottom + 1, 8, 8);

    if odSelected in State then
    begin
      Canvas.Brush.Color := csSelectedColor;
      Canvas.Font.Color := clBlue;
    end
    else if FActives[Index] then
    begin
      Canvas.Brush.Color := csNormalColor;
      Canvas.Font.Color := clBlack;
    end
    else
    begin
      Canvas.Brush.Color := csNormalColor;
      Canvas.Font.Color := clGray;
    end;
    Canvas.RoundRect(R.Left, R.Top, R.Right, R.Bottom, 8, 8);
    if Wizard.Icon <> nil then
      Canvas.Draw(R.Left + 4, R.Top + (R.Bottom - R.Top - Wizard.Icon.Height) div 2, Wizard.Icon);

    x := R.Left + 42;
    y := R.Top + 2;
    Canvas.TextOut(x, y, SCnWizardNameStr + Wizard.WizardName);
    Inc(y, FDrawTextHeight);
    if FActives[Index] then
      Canvas.TextOut(x, y, SCnWizardStateStr + SCnWizardActiveStr)
    else
      Canvas.TextOut(x, y, SCnWizardStateStr + SCnWizardDisActiveStr);
    Inc(y, FDrawTextHeight);
    Canvas.TextOut(x, y, SCnWizardShortCutStr + ShortCutToText(FShortCuts[Index]));

    BitBlt(ListBox.Canvas.Handle, Rect.Left, Rect.Top, Bmp.Width, Bmp.Height,
      Canvas.Handle, 0, 0, SRCCOPY);

    // ������ͼ��
    if FActives[Index] then
      EnableIndex := 0
    else
      EnableIndex := 1;

    EnableIconMargin := (Rect.Bottom - Rect.Top - ilEnable.Height) div 2;
    if EnableIconMargin < 0 then
      EnableIconMargin := 0;
    ilEnable.Draw(ListBox.Canvas, Rect.Right - EnableIconMargin - ilEnable.Width - 6,
      Rect.Top + EnableIconMargin + 1, EnableIndex);
  finally
    Bmp.Free;
  end;
end;

// ListBox ����¼�
procedure TCnWizConfigForm.lbWizardsClick(Sender: TObject);
var
  Wizard: TCnBaseWizard;
  AName, Author, Email, Comment: string;
begin
  if lbWizards.ItemIndex < 0 then
  begin
    btnConfig.Enabled := False;
    Exit;
  end;
  Wizard := TCnBaseWizard(lbWizards.Items.Objects[lbWizards.ItemIndex]);
  imgIcon.Picture.Graphic := Wizard.Icon;
  Wizard.GetWizardInfo(AName, Author, Email, Comment);
  lblWizardName.Caption := AName;
  lblWizardAuthor.Caption := CnAuthorEmailToStr(Author, '');
  lblWizardComment.Caption := Comment;

  lblWizardKind.Caption := GetCnWizardTypeName(Wizard);

  cbWizardActive.Checked := FActives[lbWizards.ItemIndex];
  HotKeyWizard.HotKey := FShortCuts[lbWizards.ItemIndex];
  HotKeyWizard.Visible := (Wizard is TCnActionWizard) and
    TCnActionWizard(Wizard).EnableShortCut;
  btnConfig.Enabled := Wizard.HasConfig and cbWizardActive.Checked;
end;

// ListBox ˫���¼�
procedure TCnWizConfigForm.lbWizardsDblClick(Sender: TObject);
begin
  if btnConfig.Visible and btnConfig.Enabled then
    btnConfigClick(btnConfig);
end;

// �����ȼ�
procedure TCnWizConfigForm.HotKeyWizardExit(Sender: TObject);
begin
  if lbWizards.ItemIndex >= 0 then
    FShortCuts[lbWizards.ItemIndex] := HotKeyWizard.HotKey;
end;

// ����ר�һ�Ծ
procedure TCnWizConfigForm.cbWizardActiveClick(Sender: TObject);
begin
  if lbWizards.ItemIndex >= 0 then
  begin
    FActives[lbWizards.ItemIndex] := cbWizardActive.Checked;
    btnConfig.Enabled := cbWizardActive.Checked and
      TCnBaseWizard(lbWizards.Items.Objects[lbWizards.ItemIndex]).HasConfig;
    lbWizards.Refresh;
  end;
end;

// ����ר��
procedure TCnWizConfigForm.btnConfigClick(Sender: TObject);
begin
  if lbWizards.ItemIndex >= 0 then
  begin
    with TCnBaseWizard(lbWizards.Items.Objects[lbWizards.ItemIndex]) do
      if HasConfig then Config;
    lbWizards.Refresh;
  end;
end;

//------------------------------------------------------------------------------
// �༭������
//------------------------------------------------------------------------------

procedure TCnWizConfigForm.lbDesignEditorsDrawItem(Control: TWinControl;
  Index: Integer; Rect: TRect; State: TOwnerDrawState);
var
  ListBox: TListBox;
  Canvas: TCanvas;
  R: TRect;
  ARect: TRect;
  Info: TCnDesignEditorInfo;
  x, y: Integer;
  Bmp: TBitmap;
  EnableIndex, EnableIconMargin: Integer;
begin
  if not (Control is TListBox) then Exit;
  ListBox := TListBox(Control);
  Info := TCnDesignEditorInfo(ListBox.Items.Objects[Index]);

  // ������ʱλͼ��������˸
  Bmp := TBitmap.Create;
  try
    Bmp.PixelFormat := pf24bit;
    Bmp.Width := RectWidth(Rect);
    Bmp.Height := RectHeight(Rect);
    ARect := Bounds(0, 0, Bmp.Width, Bmp.Height);

    R.Left := ARect.Left + 4;
    R.Right := ARect.Right - 5;
    R.Top := ARect.Top + 2;
    R.Bottom := ARect.Bottom - 2;

    Canvas := Bmp.Canvas;
    Canvas.Font.Assign(ListBox.Font);
    Canvas.Brush.Style := bsSolid;
    Canvas.Brush.Color := ListBox.Color;
    Canvas.FillRect(ARect);
    Canvas.Brush.Color := csShadowColor;
    Canvas.RoundRect(R.Left + 1, R.Top + 1, R.Right + 1, R.Bottom + 1, 8, 8);

    if odSelected in State then
    begin
      Canvas.Brush.Color := csSelectedColor;
      Canvas.Font.Color := clBlue;
    end
    else if FEditorActives[Index] then
    begin
      Canvas.Brush.Color := csNormalColor;
      Canvas.Font.Color := clBlack;
    end
    else
    begin
      Canvas.Brush.Color := csNormalColor;
      Canvas.Font.Color := clGray;
    end;

    Canvas.RoundRect(R.Left, R.Top, R.Right, R.Bottom, 8, 8);
    x := R.Left + 5;
    y := R.Top + 2;
    Canvas.TextOut(x, y, SCnDesignEditorNameStr + Info.Name);
    Inc(y, FDrawTextHeight);

    if FEditorActives[Index] then
      Canvas.TextOut(x, y, SCnDesignEditorStateStr + SCnWizardActiveStr)
    else
      Canvas.TextOut(x, y, SCnDesignEditorStateStr + SCnWizardDisActiveStr);

    BitBlt(ListBox.Canvas.Handle, Rect.Left, Rect.Top, Bmp.Width, Bmp.Height,
      Canvas.Handle, 0, 0, SRCCOPY);

    // ������ͼ��
    if FEditorActives[Index] then
      EnableIndex := 0
    else
      EnableIndex := 1;

    EnableIconMargin := (Rect.Bottom - Rect.Top - ilEnable.Height) div 2;
    if EnableIconMargin < 0 then
      EnableIconMargin := 0;
    ilEnable.Draw(ListBox.Canvas, Rect.Right - EnableIconMargin - ilEnable.Width - 8,
      Rect.Top + EnableIconMargin + 1, EnableIndex);
  finally
    Bmp.Free;
  end;
end;

procedure TCnWizConfigForm.lbDesignEditorsClick(Sender: TObject);
var
  EditorInfo: TCnDesignEditorInfo;
begin
  if lbDesignEditors.ItemIndex < 0 then Exit;

  EditorInfo := TCnDesignEditorInfo(lbDesignEditors.Items.Objects[lbDesignEditors.ItemIndex]);
  with EditorInfo do
  begin
    lblDesignEditorName.Caption := Name;
    lblDesignEditorAuthor.Caption := CnAuthorEmailToStr(Author, '');
    lblDesignEditorComment.Caption := Comment;
    if EditorInfo is TCnPropEditorInfo then
      lblDesignEditorKind.Caption := SCnPropertyEditor
    else if EditorInfo is TCnCompEditorInfo then
      lblDesignEditorKind.Caption := SCnComponentEditor
    else // ��������
      lblDesignEditorKind.Caption := '';
    cbDesignEditorActive.Checked := FEditorActives[lbDesignEditors.ItemIndex];
    btnDesignEditorConfig.Visible := HasConfig;
    btnDesignEditorConfig.Enabled := cbDesignEditorActive.Checked;
    btnDesignEditorCustomize.Visible := HasCustomize;
    btnDesignEditorCustomize.Enabled := cbDesignEditorActive.Checked;
  end;
end;

procedure TCnWizConfigForm.lbDesignEditorsDblClick(Sender: TObject);
begin
  if btnDesignEditorConfig.Visible and btnDesignEditorConfig.Enabled then
    btnDesignEditorConfigClick(btnDesignEditorConfig);
end;

procedure TCnWizConfigForm.cbDesignEditorActiveClick(Sender: TObject);
begin
  if lbDesignEditors.ItemIndex >= 0 then
  begin
    FEditorActives[lbDesignEditors.ItemIndex] := cbDesignEditorActive.Checked;
    btnDesignEditorConfig.Enabled := cbDesignEditorActive.Checked;
    lbDesignEditors.Refresh;
  end;
end;

procedure TCnWizConfigForm.btnDesignEditorConfigClick(Sender: TObject);
begin
  if lbDesignEditors.ItemIndex >= 0 then
  begin
    with TCnDesignEditorInfo(lbDesignEditors.Items.Objects[lbDesignEditors.ItemIndex]) do
      if HasConfig then Config;
    lbDesignEditors.Refresh;
  end;
end;

procedure TCnWizConfigForm.btnDesignEditorCustomizeClick(Sender: TObject);
begin
  if lbDesignEditors.ItemIndex >= 0 then
  begin
    with TCnDesignEditorInfo(lbDesignEditors.Items.Objects[lbDesignEditors.ItemIndex]) do
      if HasCustomize then Customize;
  end;
end;

//------------------------------------------------------------------------------
// ��������
//------------------------------------------------------------------------------

// �������
procedure TCnWizConfigForm.btnCheckUpgradeClick(Sender: TObject);
begin
  CheckUpgrade(True);
end;

procedure TCnWizConfigForm.btnResetWizCommentClick(Sender: TObject);
begin
  ResetAllComment(True);
  InfoDlg(SCnWizCommentReseted);
end;

procedure TCnWizConfigForm.btnHelpClick(Sender: TObject);
begin
  ShowFormHelp;
end;

function TCnWizConfigForm.GetHelpTopic: string;
begin
  case PageControl.ActivePageIndex of
    1: Result := 'CnWizPropConfig';
    2: Result := 'CnWizOtherConfig';
    3: Result := 'CnWizIdeConfig';
  else
    Result := 'CnWizConfig';
  end;
end;

procedure TCnWizConfigForm.cbShowHintClick(Sender: TObject);
begin
  ShowHint := cbShowHint.Checked;
end;

procedure TCnWizConfigForm.UpdateControls(Sender: TObject);
begin
  cbUpgradeReleaseOnly.Enabled := rbUpgradeAll.Checked;
  edtUserDir.Enabled := chkUserDir.Checked;
  btnUserDir.Enabled := chkUserDir.Checked;
end;

procedure TCnWizConfigForm.btnExportImagelistClick(Sender: TObject);
var
  Dir: string;
begin
  if GetDirectory(SCnSelectDir, Dir) then
    SaveIDEImageListToPath(MakePath(Dir));
end;

procedure TCnWizConfigForm.btnExportActionListClick(Sender: TObject);
begin
  if dlgSaveActionList.Execute then
    SaveIDEActionListToFile(dlgSaveActionList.FileName);
end;

procedure TCnWizConfigForm.btnExportComponentsClick(Sender: TObject);
const
  SCnPackageFileName = 'Packages.txt';
  SCnComponentFileName = 'Components.txt';
var
  p, c: TStringList;
  Dir: String;
begin
  p := nil; c := nil;
  try
    p := TStringList.Create;
    c := TStringList.Create;
    GetInstalledComponents(p, c);
    if GetDirectory(SCnExportPCDirCaption, Dir) then
    begin
      p.SaveToFile(MakePath(Dir) + SCnPackageFileName);
      c.SaveToFile(MakePath(Dir) + SCnComponentFileName);
      InfoDlg(Format(SCnExportPCSucc, [SCnComponentFileName, SCnPackageFileName]));
    end;
  finally
    p.Free;
    c.Free;
  end;
end;

procedure TCnWizConfigForm.btnSortClick(Sender: TObject);
begin
// ��ʾ���򴰿�
  with TCnMenuSortForm.Create(nil) do
  begin
    InitWizardMenus;
    if ShowModal = mrOK then
    begin
      ReSortMenuWizards;
      CnWizardMgr.ConstructSortedMenu;
      SaveWizardCreateInfo;
    end;
    Free;
  end;
end;

procedure TCnWizConfigForm.btnUserDirClick(Sender: TObject);
var
  ADir: string;
begin
  ADir := edtUserDir.Text;
  if GetDirectory('', ADir) then
    edtUserDir.Text := ADir;
end;

end.


