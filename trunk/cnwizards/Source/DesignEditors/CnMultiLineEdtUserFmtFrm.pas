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

unit CnMultiLineEdtUserFmtFrm;

{* |<PRE>
================================================================================
* ������ƣ����������ԡ�����༭����
* ��Ԫ���ƣ��ַ����༭�����������Զ����ʽ������
* ��Ԫ���ߣ�Chinbo(Shenloqi@hotmail.com)
* ��    ע��
* ����ƽ̨��WinXP + Delphi 5.0
* ���ݲ��ԣ�PWin9X/2000/XP + Delphi 5/6
* �� �� �����õ�Ԫ�ʹ����е��ַ����Ѿ����ػ�����ʽ
* ��Ԫ��ʶ��$Id: CnMultiLineEdtUserFmtFrm.pas 763 2011-02-07 14:18:23Z liuxiao@cnpack.org $
* �޸ļ�¼��
*           2003.10.18
*               ������Ԫ
================================================================================
|</PRE>}

interface

{$I CnWizards.inc}

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  CnWizMultiLang, CnMultiLineEditorFrm, StdCtrls;

type
  TCnMultiLineEditorUserFmtForm = class(TCnTranslateForm)
    btnOK: TButton;
    btnCancel: TButton;
    edt1: TEdit;
    edt2: TEdit;
    chk1: TCheckBox;
    chk2: TCheckBox;
    lbl1: TLabel;
    lbl2: TLabel;
    procedure FormShow(Sender: TObject);
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
  private
    { Private declarations }
    FUserFormatOpt: DWORD;
    FUserFormatStrBefore: string;
    FUserFormatStrAfter: string;
    function Getchk1Enabled: Boolean;
    procedure Setchk1Enabled(const Value: Boolean);
  public
    { Public declarations }
    property UserFormatStrBefore: string read FUserFormatStrBefore write FUserFormatStrBefore;
    property UserFormatStrAfter: string read FUserFormatStrAfter write FUserFormatStrAfter;
    property UserFormatOpt: DWORD read FUserFormatOpt write FUserFormatOpt;
    property chk1Enabled: Boolean read Getchk1Enabled write Setchk1Enabled;
  end;

implementation

uses
  CnCommon;

{$R *.DFM}

procedure TCnMultiLineEditorUserFmtForm.FormShow(Sender: TObject);
begin
  inherited;
  edt1.Text := UserFormatStrBefore;
  edt2.Text := UserFormatStrAfter;
  chk1.Checked := GetBit(UserFormatOpt, 0);
  chk2.Checked := GetBit(UserFormatOpt, 1);
end;

procedure TCnMultiLineEditorUserFmtForm.FormCloseQuery(Sender: TObject;
  var CanClose: Boolean);
begin
  inherited;
  UserFormatStrBefore := edt1.Text;
  UserFormatStrAfter := edt2.Text;
  SetBit(FUserFormatOpt, 0, chk1.Checked);
  SetBit(FUserFormatOpt, 1, chk2.Checked);
end;

function TCnMultiLineEditorUserFmtForm.Getchk1Enabled: Boolean;
begin
  Result := chk1.Enabled;
end;

procedure TCnMultiLineEditorUserFmtForm.Setchk1Enabled(const Value: Boolean);
begin
  chk1.Enabled := Value;
end;

end.
