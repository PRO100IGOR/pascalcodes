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

unit CnPrefixEditFrm;
{* |<PRE>
================================================================================
* ������ƣ�CnPack IDE ר�Ұ�
* ��Ԫ���ƣ����ǰ׺ר������������嵥Ԫ
* ��Ԫ���ߣ��ܾ��� (zjy@cnpack.org)
* ��    ע�����ǰ׺ר������������嵥Ԫ
* ����ƽ̨��PWin2000Pro + Delphi 5.01
* ���ݲ��ԣ�PWin9X/2000/XP + Delphi 5/6/7 + C++Builder 5/6
* �� �� �����õ�Ԫ�е��ַ��������ϱ��ػ�����ʽ
* ��Ԫ��ʶ��$Id: CnPrefixEditFrm.pas 763 2011-02-07 14:18:23Z liuxiao@cnpack.org $
* �޸ļ�¼��2003.04.26 V1.0
*               ������Ԫ
================================================================================
|</PRE>}

interface

{$I CnWizards.inc}

{$IFDEF CNWIZARDS_CNPREFIXWIZARD}

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, ExtCtrls, CnWizConsts, CnCommon, CnWizUtils, CnWizMultiLang,
  Buttons;

type

{ TCnPrefixEditForm }

  TCnPrefixEditForm = class(TCnTranslateForm)
    gbEdit: TGroupBox;
    lblFormName: TLabel;
    bvl1: TBevel;
    lbl1: TLabel;
    lbl2: TLabel;
    lbl3: TLabel;
    edtName: TEdit;
    btnOK: TButton;
    btnCancel: TButton;
    btnHelp: TButton;
    cbNeverDisp: TCheckBox;
    cbIgnoreComp: TCheckBox;
    btnPrefix: TButton;
    img1: TImage;
    edtOldName: TEdit;
    lbl4: TLabel;
    lblClassName: TLabel;
    lbl5: TLabel;
    lblText: TLabel;
    btnClassName: TSpeedButton;
    procedure btnOKClick(Sender: TObject);
    procedure btnHelpClick(Sender: TObject);
    procedure btnPrefixClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure edtNameKeyPress(Sender: TObject; var Key: Char);
    procedure btnClassNameClick(Sender: TObject);
  private
    { Private declarations }
    FPrefix: string;
    FUseUnderLine: Boolean;
    FComponentClass: string;
  protected
    function GetHelpTopic: string; override;
  public
    { Public declarations }
    procedure SetEditSel(Sender: TObject);
  end;

// ��ʾ�Ի���ȡ���µ��������
function GetNewComponentName(const FormName, ComponentClass, ComponentText,
  OldName: string; var Prefix, NewName: string; HideMode: Boolean;
  var IgnoreComp, AutoPopSuggestDlg: Boolean; UseUnderLine: Boolean): Boolean;

{$ENDIF CNWIZARDS_CNPREFIXWIZARD}

implementation

{$IFDEF CNWIZARDS_CNPREFIXWIZARD}

uses
  CnPrefixNewFrm, CnWizNotifier;

{$R *.DFM}

{ TCnPrefixEditForm }

// ȡ���µ��������
function GetNewComponentName(const FormName, ComponentClass, ComponentText,
  OldName: string; var Prefix, NewName: string; HideMode: Boolean;
  var IgnoreComp, AutoPopSuggestDlg: Boolean; UseUnderLine: Boolean): Boolean;
begin
  with TCnPrefixEditForm.Create(nil) do
  try
    lblFormName.Caption := FormName;
    lblClassName.Caption := ComponentClass;
    lblText.Caption := ComponentText;
    FUseUnderLine := UseUnderLine;
    FPrefix := Prefix;
    FComponentClass := ComponentClass;
    edtOldName.Text := OldName;
    edtName.Text := NewName;
    cbNeverDisp.Checked := not AutoPopSuggestDlg;
    if HideMode then
    begin
      cbIgnoreComp.Visible := False;
      cbNeverDisp.Visible := False;
      // btnPrefix.Visible := False;
    end;

    Result := ShowModal = mrOk;

    Prefix := FPrefix;
    NewName := edtName.Text;
    IgnoreComp := cbIgnoreComp.Checked;
    AutoPopSuggestDlg := not cbNeverDisp.Checked;
  finally
    Free;
  end;
end;

procedure TCnPrefixEditForm.FormShow(Sender: TObject);
begin
  CnWizNotifierServices.ExecuteOnApplicationIdle(SetEditSel);
end;

procedure TCnPrefixEditForm.btnOKClick(Sender: TObject);
begin
  if IsValidIdent(edtName.Text) then
    ModalResult := mrOk
  else
    ErrorDlg(SCnPrefixNameError);
end;

procedure TCnPrefixEditForm.btnPrefixClick(Sender: TObject);
var
  B1, B2: Boolean;
  OldPrefix: string;
begin
  OldPrefix := FPrefix;
  if GetNewComponentPrefix(FComponentClass, FPrefix, True, B1, B2) then
    if Pos(OldPrefix, edtName.Text) = 1 then
      edtName.Text := StringReplace(edtName.Text, OldPrefix, FPrefix, []);

  SetEditSel(nil);
end;

procedure TCnPrefixEditForm.SetEditSel;
begin
  edtName.SetFocus;
  if Self.FUseUnderLine then
  begin
    edtName.SelStart := Length(FPrefix) + 1;
    edtName.SelLength := Length(edtName.Text) - Length(FPrefix) - 1;
  end
  else
  begin
    edtName.SelStart := Length(FPrefix);
    edtName.SelLength := Length(edtName.Text) - Length(FPrefix);
  end;
end;

procedure TCnPrefixEditForm.btnHelpClick(Sender: TObject);
begin
  ShowFormHelp;
end;

function TCnPrefixEditForm.GetHelpTopic: string;
begin
  Result := 'CnPrefixEditForm';
end;

procedure TCnPrefixEditForm.edtNameKeyPress(Sender: TObject;
  var Key: Char);
const
  Chars = ['A'..'Z', 'a'..'z', '_', '0'..'9', #03, #08, #22, #24, #26]; // Ctrl+C/V/X/Z
begin
  if not CharInSet(Key, Chars) and not IsValidIdent('A' + Key) then
    Key := #0;
end;

procedure TCnPrefixEditForm.btnClassNameClick(Sender: TObject);
begin
  edtName.Text := RemoveClassPrefix(lblClassName.Caption);
end;

{$ENDIF CNWIZARDS_CNPREFIXWIZARD}
end.
