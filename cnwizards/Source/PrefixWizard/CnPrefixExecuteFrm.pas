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

unit CnPrefixExecuteFrm;
{* |<PRE>
================================================================================
* ������ƣ�CnPack IDE ר�Ұ�
* ��Ԫ���ƣ����ǰ׺ר��ִ�д��嵥Ԫ
* ��Ԫ���ߣ��ܾ��� (zjy@cnpack.org)
* ��    ע�����ǰ׺ר��ִ�д��嵥Ԫ
* ����ƽ̨��PWin2000Pro + Delphi 5.01
* ���ݲ��ԣ�PWin9X/2000/XP + Delphi 5/6/7 + C++Builder 5/6
* �� �� �����õ�Ԫ�е��ַ��������ϱ��ػ�����ʽ
* ��Ԫ��ʶ��$Id: CnPrefixExecuteFrm.pas 763 2011-02-07 14:18:23Z liuxiao@cnpack.org $
* �޸ļ�¼��2003.04.26 V1.0
*               ������Ԫ
================================================================================
|</PRE>}

interface

{$I CnWizards.inc}

{$IFDEF CNWIZARDS_CNPREFIXWIZARD}

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  Contnrs, IniFiles, StdCtrls, ExtCtrls, ToolsAPI, CnWizUtils, CnWizMultiLang;

type

{ TCnPrefixExecuteForm }

  TPrefixExeKind = (pkSelComp, pkCurrForm, pkOpenedForm, pkCurrProject,
    pkProjectGroup);

  TPrefixCompKind = (pcIncorrect, pcUnnamed, pcAll);

  TCnPrefixExecuteForm = class(TCnTranslateForm)
    btnOK: TButton;
    btnCancel: TButton;
    btnHelp: TButton;
    btnConfig: TButton;
    gbKind: TGroupBox;
    rbSelComp: TRadioButton;
    rbCurrForm: TRadioButton;
    rbOpenedForm: TRadioButton;
    rbCurrProject: TRadioButton;
    rbProjectGroup: TRadioButton;
    rgCompKind: TRadioGroup;
    procedure btnHelpClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
  private
    function GetExeKind: TPrefixExeKind;
    { Private declarations }
  protected
    function GetHelpTopic: string; override;
  public
    { Public declarations }
    property ExeKind: TPrefixExeKind read GetExeKind;
  end;

function ShowPrefixExecuteForm(OnConfig: TNotifyEvent;
  var Kind: TPrefixExeKind; var CompKind: TPrefixCompKind): Boolean;

{$ELSE}

uses
  Windows, SysUtils, Classes;
// δ���� CNWIZARDS_CNPREFIXWIZARD ʱ���� uses ������Ԫ���Ա� RenameProc ����ʹ��

{$ENDIF CNWIZARDS_CNPREFIXWIZARD}

var
  RenameProc: procedure (AComp: TComponent) = nil;

implementation

{$IFDEF CNWIZARDS_CNPREFIXWIZARD}

{$R *.DFM}

function ShowPrefixExecuteForm(OnConfig: TNotifyEvent;
  var Kind: TPrefixExeKind; var CompKind: TPrefixCompKind): Boolean;
begin
  with TCnPrefixExecuteForm.Create(nil) do
  try
    btnConfig.OnClick := OnConfig;
    rgCompKind.ItemIndex := Ord(CompKind);
    Result := ShowModal = mrOk;
    if Result then
    begin
      Kind := ExeKind;
      CompKind := TPrefixCompKind(rgCompKind.ItemIndex);
    end;
  finally
    Free;
  end;
end;

{ TCnPrefixExecuteForm }

procedure TCnPrefixExecuteForm.FormShow(Sender: TObject);
begin
  rbSelComp.Enabled := not CnOtaIsCurrFormSelectionsEmpty;
  if not rbSelComp.Enabled and rbSelComp.Checked then
    rbCurrForm.Checked := True;
  rbCurrForm.Enabled := CurrentIsForm;
  if not rbCurrForm.Enabled and rbCurrForm.Checked then
    rbOpenedForm.Checked := True;
  rbCurrProject.Enabled := CnOtaGetCurrentProject <> nil;
  rbProjectGroup.Enabled := CnOtaGetProjectGroup <> nil;
end;

function TCnPrefixExecuteForm.GetExeKind: TPrefixExeKind;
begin
  if rbSelComp.Checked then
    Result := pkSelComp
  else if rbCurrForm.Checked then
    Result := pkCurrForm
  else if rbOpenedForm.Checked then
    Result := pkOpenedForm
  else if rbCurrProject.Checked then
    Result := pkCurrProject
  else
    Result := pkProjectGroup;
end;

procedure TCnPrefixExecuteForm.btnHelpClick(Sender: TObject);
begin
  ShowFormHelp;
end;

function TCnPrefixExecuteForm.GetHelpTopic: string;
begin
  Result := 'CnPrefixWizard';
end;

{$ENDIF CNWIZARDS_CNPREFIXWIZARD}
end.
