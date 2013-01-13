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

unit CnCpuWinEnhanceFrm;
{ |<PRE>
================================================================================
* ������ƣ�CnPack IDE ר�Ұ�
* ��Ԫ���ƣ�CPU ���Դ�����չ���ô���
* ��Ԫ���ߣ�Aimingoo (ԭ����) aim@263.net; http://www.doany.net
*           �ܾ��� (��ֲ) zjy@cnpack.org
* ��    ע��
* ����ƽ̨��PWin2000Pro + Delphi 5.01
* ���ݲ��ԣ�PWin9X/2000/XP + Delphi 5/6/7 + C++Builder 5/6
* �� �� �����õ�Ԫ�е��ַ��������ϱ��ػ�����ʽ
* ��Ԫ��ʶ��$Id: CnCpuWinEnhanceFrm.pas 763 2011-02-07 14:18:23Z liuxiao@cnpack.org $
* �޸ļ�¼��2003.07.31 V1.0
*               ��ֲ��Ԫ
================================================================================
|</PRE>}

interface

{$I CnWizards.inc}

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ComCtrls, ExtCtrls, CnSpin, CnWizUtils, CnWizMultiLang;

type

{ TCnCpuWinEnhanceForm }

  TCopyFrom = (cfTopAddr, cfSelectAddr);
  TCopyTo = (ctClipboard, ctFile);

  TCnCpuWinEnhanceForm = class(TCnTranslateForm)
    CopyParam: TGroupBox;
    rbTopAddr: TRadioButton;
    rbSelectAddr: TRadioButton;
    cbSettingToAll: TCheckBox;
    Label1: TLabel;
    seCopyLineCount: TCnSpinEdit;
    rgCopyToMode: TRadioGroup;
    btnOK: TButton;
    btnCancel: TButton;
    btnHelp: TButton;
    procedure btnHelpClick(Sender: TObject);
    procedure seCopyLineCountKeyPress(Sender: TObject; var Key: Char);
  private

  protected
    function GetHelpTopic: string; override;
  public
    { Public declarations }
  end;

function ShowCpuWinEnhanceForm(var CopyForm: TCopyFrom; var CopyTo: TCopyTo;
  var CopyLineCount: Integer; var SettingToAll: Boolean): Boolean;

implementation

{$R *.dfm}

function ShowCpuWinEnhanceForm(var CopyForm: TCopyFrom; var CopyTo: TCopyTo;
  var CopyLineCount: Integer; var SettingToAll: Boolean): Boolean;
begin
  with TCnCpuWinEnhanceForm.Create(nil) do
  try
    rbTopAddr.Checked := CopyForm = cfTopAddr;
    rbSelectAddr.Checked := not rbTopAddr.Checked;
    seCopyLineCount.Value := CopyLineCount;
    rgCopyToMode.ItemIndex := Ord(CopyTo);
    cbSettingToAll.Checked := SettingToAll;

    Result := ShowModal = mrOk;
    if Result then
    begin
      if rbTopAddr.Checked then
        CopyForm := cfTopAddr
      else
        CopyForm := cfSelectAddr;
      CopyLineCount := seCopyLineCount.Value;
      CopyTo := TCopyTo(rgCopyToMode.ItemIndex);
      SettingToAll := cbSettingToAll.Checked;
    end;
  finally
    Free;
  end;
end;

procedure TCnCpuWinEnhanceForm.btnHelpClick(Sender: TObject);
begin
  ShowFormHelp;
end;

function TCnCpuWinEnhanceForm.GetHelpTopic: string;
begin
  Result := 'CnCpuWinEnhanceWizard';
end;

procedure TCnCpuWinEnhanceForm.seCopyLineCountKeyPress(Sender: TObject;
  var Key: Char);
begin
  if Key = #27 then
  begin
    ModalResult := mrCancel;
    Key := #0;
  end
  else
  if Key = #13 then
  begin
    ModalResult := mrOk;
    Key := #0;
  end
end;

end.
