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

unit CnIdentRenameFrm;
{ |<PRE>
================================================================================
* ������ƣ�CnPack IDE ר�Ұ�
* ��Ԫ���ƣ���ʶ��������ʾ���嵥Ԫ
* ��Ԫ���ߣ���Х (liuxiao@cnpack.org)
* ��    ע��
* ����ƽ̨��PWinXpPro + Delphi 5.01
* ���ݲ��ԣ�PWin9X/2000/XP + Delphi 5/6/7 + C++Builder 5/6
* �� �� �����õ�Ԫ�е��ַ���֧�ֱ��ػ�����ʽ
* ��Ԫ��ʶ��$Id: CnIdentRenameFrm.pas 763 2011-02-07 14:18:23Z liuxiao@cnpack.org $
* �޸ļ�¼��2009.01.15
*             ������Ԫ
================================================================================
|</PRE>}

interface

{$I CnWizards.inc}

{$IFDEF CNWIZARDS_CNSRCEDITORENHANCE}

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, CnWizMultiLang;

type
  TCnIdentRenameForm = class(TCnTranslateForm)
    grpBrowse: TGroupBox;
    rbCurrentProc: TRadioButton;
    rbCurrentInnerProc: TRadioButton;
    rbUnit: TRadioButton;
    lblReplacePromt: TLabel;
    edtRename: TEdit;
    btnOK: TButton;
    btnCancel: TButton;
    procedure FormShow(Sender: TObject);
    procedure edtRenameKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

{$ENDIF CNWIZARDS_CNSRCEDITORENHANCE}

implementation

{$IFDEF CNWIZARDS_CNSRCEDITORENHANCE}

{$R *.DFM}

procedure TCnIdentRenameForm.FormShow(Sender: TObject);
begin
  edtRename.SetFocus;
end;

procedure TCnIdentRenameForm.edtRenameKeyDown(Sender: TObject;
  var Key: Word; Shift: TShiftState);
var
  NextRadioButton: TRadioButton;
begin
  NextRadioButton := nil;
  if (Key = VK_UP) and (Shift = []) then
  begin
    if rbUnit.Checked then
    begin
      if rbCurrentInnerProc.Enabled then
        NextRadioButton := rbCurrentInnerProc
      else
        NextRadioButton := rbCurrentProc;
    end
    else if rbCurrentInnerProc.Checked then
      NextRadioButton := rbCurrentProc;

    Key := 0;
  end
  else if (Key = VK_DOWN) and (Shift = []) then
  begin
    if rbCurrentProc.Checked then
    begin
      if rbCurrentInnerProc.Enabled then
        NextRadioButton := rbCurrentInnerProc
      else
        NextRadioButton := rbUnit;
    end
    else if rbCurrentInnerProc.Checked then
      NextRadioButton := rbUnit;

    Key := 0;
  end;

  if NextRadioButton <> nil then
    if NextRadioButton.Enabled then
      NextRadioButton.Checked := True;
end;

{$ENDIF CNWIZARDS_CNSRCEDITORENHANCE}
end.
