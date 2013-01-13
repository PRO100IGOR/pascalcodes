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

unit CnPrefixNewFrm;
{* |<PRE>
================================================================================
* ������ƣ�CnPack IDE ר�Ұ�
* ��Ԫ���ƣ����ǰ׺ר����ǰ׺�Ի���Ԫ
* ��Ԫ���ߣ��ܾ��� (zjy@cnpack.org)
* ��    ע�����ǰ׺ר����ǰ׺�Ի���Ԫ
* ����ƽ̨��PWin2000Pro + Delphi 5.01
* ���ݲ��ԣ�PWin9X/2000/XP + Delphi 5/6/7 + C++Builder 5/6
* �� �� �����õ�Ԫ�е��ַ��������ϱ��ػ�����ʽ
* ��Ԫ��ʶ��$Id: CnPrefixNewFrm.pas 763 2011-02-07 14:18:23Z liuxiao@cnpack.org $
* �޸ļ�¼��2003.04.26 V1.0
*               ������Ԫ
================================================================================
|</PRE>}

interface

{$I CnWizards.inc}

{$IFDEF CNWIZARDS_CNPREFIXWIZARD}

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, CnWizConsts, CnCommon, CnWizUtils, CnWizMultiLang;

type

{ TCnPrefixNewForm }

  TCnPrefixNewForm = class(TCnTranslateForm)
    gbNew: TGroupBox;
    lbl1: TLabel;
    lbl3: TLabel;
    edtPrefix: TEdit;
    btnOK: TButton;
    btnCancel: TButton;
    btnHelp: TButton;
    cbNeverDisp: TCheckBox;
    Label1: TLabel;
    edtComponent: TEdit;
    cbIgnore: TCheckBox;
    procedure btnOKClick(Sender: TObject);
    procedure btnHelpClick(Sender: TObject);
    procedure edtPrefixKeyPress(Sender: TObject; var Key: Char);
  private
    { Private declarations }
  protected
    function GetHelpTopic: string; override;
  public
    { Public declarations }
  end;

// ȡ���µ����ǰ׺��
function GetNewComponentPrefix(const ComponentClass: string; var NewPrefix: string;
  UserMode: Boolean; var Ignore, PopPrefixDefine: Boolean): Boolean;

{$ENDIF CNWIZARDS_CNPREFIXWIZARD}

implementation

{$IFDEF CNWIZARDS_CNPREFIXWIZARD}

{$R *.DFM}

{ TCnPrefixNewForm }

function GetNewComponentPrefix(const ComponentClass: string; var NewPrefix: string;
  UserMode: Boolean; var Ignore, PopPrefixDefine: Boolean): Boolean;
begin
  with TCnPrefixNewForm.Create(nil) do
  try
    edtComponent.Text := ComponentClass;
    edtPrefix.Text := NewPrefix;
    cbIgnore.Visible := not UserMode;
    cbNeverDisp.Visible := not UserMode;

    Result := ShowModal = mrOk;
   
    NewPrefix := edtPrefix.Text;
    PopPrefixDefine := not cbNeverDisp.Checked;
    Ignore := cbIgnore.Checked;
  finally
    Free;
  end;
end;

procedure TCnPrefixNewForm.btnOKClick(Sender: TObject);
begin
  if IsValidIdent(edtPrefix.Text) then
    ModalResult := mrOk
  else
    ErrorDlg(SCnPrefixInputError);
end;

procedure TCnPrefixNewForm.btnHelpClick(Sender: TObject);
begin
  ShowFormHelp;
end;

function TCnPrefixNewForm.GetHelpTopic: string;
begin
  Result := 'CnPrefixNewForm';
end;

procedure TCnPrefixNewForm.edtPrefixKeyPress(Sender: TObject;
  var Key: Char);
const
  Chars = ['A'..'Z', 'a'..'z', '_', '0'..'9', #03, #08, #22];
begin
  if not CharInSet(Key, Chars) then
    Key := #0;
end;

{$ENDIF CNWIZARDS_CNPREFIXWIZARD}
end.
