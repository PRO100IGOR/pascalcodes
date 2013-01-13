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

unit CnInputHelperEditFrm;
{* |<PRE>
================================================================================
* ������ƣ�CnPack IDE ר�Ұ�
* ��Ԫ���ƣ���������ר�ҷ��ű༭����
* ��Ԫ���ߣ��ܾ��� zjy@cnpack.org
* ��    ע��
* ����ƽ̨��PWinXP XP2 + Delphi 5.01
* ���ݲ��ԣ�
* �� �� �����õ�Ԫ�е��ַ��������ϱ��ػ�����ʽ
* ��Ԫ��ʶ��$Id: CnInputHelperEditFrm.pas 763 2011-02-07 14:18:23Z liuxiao@cnpack.org $
* �޸ļ�¼��2005.06.03
*               ������Ԫ
================================================================================
|</PRE>}

interface

{$I CnWizards.inc}

{$IFDEF CNWIZARDS_CNINPUTHELPER}

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  CnWizMultiLang, CnWizConsts, StdCtrls, CnCommon, CnInputSymbolList,
  CnSpin;

type
  TCnInputHelperEditForm = class(TCnTranslateForm)
    grp1: TGroupBox;
    lbl1: TLabel;
    edtName: TEdit;
    lbl2: TLabel;
    edtDesc: TEdit;
    lbl3: TLabel;
    cbbKind: TComboBox;
    btnHelp: TButton;
    btnOK: TButton;
    btnCancel: TButton;
    chkAutoIndent: TCheckBox;
    lbl4: TLabel;
    seScope: TCnSpinEdit;
    lbl5: TLabel;
    chkAlwaysDisp: TCheckBox;
    procedure FormCreate(Sender: TObject);
    procedure btnHelpClick(Sender: TObject);
    procedure btnOKClick(Sender: TObject);
    procedure cbbKindChange(Sender: TObject);
  private
    { Private declarations }
  protected
    function GetHelpTopic: string; override;
  public
    { Public declarations }
  end;

function CnShowInputHelperEditForm(var AName, ADesc: string;
  var AKind: TSymbolKind; var Scope: Integer; var AutoIndent,
  AlwaysDisp: Boolean): Boolean;

{$ENDIF CNWIZARDS_CNINPUTHELPER}

implementation

{$IFDEF CNWIZARDS_CNINPUTHELPER}

{$R *.DFM}

function CnShowInputHelperEditForm(var AName, ADesc: string;
  var AKind: TSymbolKind; var Scope: Integer; var AutoIndent,
  AlwaysDisp: Boolean): Boolean;
begin
  with TCnInputHelperEditForm.Create(Application) do
  try
    edtName.Text := AName;
    edtDesc.Text := ADesc;
    cbbKind.ItemIndex := Ord(AKind);
    seScope.Value := Scope;
    chkAutoIndent.Checked := AutoIndent;
    chkAlwaysDisp.Checked := AlwaysDisp;
    cbbKindChange(nil);

    Result := ShowModal = mrOk;
    if Result then
    begin
      AName := Trim(edtName.Text);
      ADesc := Trim(edtDesc.Text);
      AKind := TSymbolKind(cbbKind.ItemIndex);
      Scope := seScope.Value;
      AutoIndent := chkAutoIndent.Checked;
      AlwaysDisp := chkAlwaysDisp.Checked;
    end;
  finally
    Free;
  end;
end;

procedure TCnInputHelperEditForm.FormCreate(Sender: TObject);
var
  Kind: TSymbolKind;
begin
  inherited;
  for Kind := Low(Kind) to High(Kind) do
    cbbKind.Items.Add(GetSymbolKindName(Kind));
end;

function TCnInputHelperEditForm.GetHelpTopic: string;
begin
  Result := SCnInputHelperHelpStr;
end;

procedure TCnInputHelperEditForm.btnHelpClick(Sender: TObject);
begin
  ShowFormHelp;
end;

procedure TCnInputHelperEditForm.btnOKClick(Sender: TObject);
begin
  if Trim(edtName.Text) = '' then
  begin
    ErrorDlg(SCnInputHelperSymbolNameIsEmpty);
    Exit;
  end;

  if cbbKind.ItemIndex < 0 then
  begin
    ErrorDlg(SCnInputHelperSymbolKindError);
    Exit;
  end;

  ModalResult := mrOk;
end;

procedure TCnInputHelperEditForm.cbbKindChange(Sender: TObject);
begin
  chkAutoIndent.Enabled := TSymbolKind(cbbKind.ItemIndex) in
    [skTemplate, skComment];
end;

{$ENDIF CNWIZARDS_CNINPUTHELPER}
end.
