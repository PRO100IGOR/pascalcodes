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

unit CnDUnitSetFrm;
{* |<PRE>
================================================================================
* ������ƣ�CnPack IDE ר�Ұ�
* ��Ԫ���ƣ�DUnit ��Ԫ���Թ����򵼴���
* ��Ԫ���ߣ����� (SQUALL)
* ��    ע���� LiuXiao ��ֲ��
* ����ƽ̨��PWin2000Pro + Delphi 5.01
* ���ݲ��ԣ�PWin9X/2000/XP + Delphi 5/6/7
* �� �� �����õ�Ԫ�е��ַ��������ϱ��ػ�����ʽ
* ��Ԫ��ʶ��$Id: CnDUnitSetFrm.pas 763 2011-02-07 14:18:23Z liuxiao@cnpack.org $
* �޸ļ�¼��2003.10.13 V1.0
*               ��ֲ��Ԫ
================================================================================
|</PRE>}

interface

{$I CnWizards.inc}

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, Buttons, ExtCtrls, CnWizMultiLang, CnOTACreators;

type
  TCnDUnitSetForm = class(TCnTranslateForm)
    gbxSetup: TGroupBox;
    chbxUnitHead: TCheckBox;
    chbxInitClass: TCheckBox;
    rbCreateApplication: TRadioButton;
    rbCreateUnit: TRadioButton;
    btnOK: TButton;
    btnCancel: TButton;
    btnHelp: TButton;
    procedure btnHelpClick(Sender: TObject);
  private
    { Private declarations }
    function GetIsAddHead: Boolean;
    procedure SetIsAddHead(const Value: Boolean);
    function GetIsAddInit: Boolean;
    procedure SetIsAddInit(const Value: Boolean);
    function GetCreatorType: TCnCreatorType;
    procedure SetCreatorType(const Value: TCnCreatorType);
  protected
    function GetHelpTopic: string; override;
  public
    { Public declarations }
    property IsAddHead: Boolean read GetIsAddHead write SetIsAddHead;
    property IsAddInit: Boolean read GetIsAddInit write SetIsAddInit;
    property CreatorType: TCnCreatorType read GetCreatorType write SetCreatorType;
  end;

implementation

{$R *.dfm}

{ TCnDUnitSetForm }

function TCnDUnitSetForm.GetIsAddHead: Boolean;
begin
  Result := Self.chbxUnitHead.Checked;
end;

procedure TCnDUnitSetForm.SetIsAddHead(const Value: Boolean);
begin
  Self.chbxUnitHead.Checked := Value;
end;

function TCnDUnitSetForm.GetIsAddInit: Boolean;
begin
  Result := Self.chbxInitClass.Checked;
end;

procedure TCnDUnitSetForm.SetIsAddInit(const Value: Boolean);
begin
  Self.chbxInitClass.Checked := Value;
end;

function TCnDUnitSetForm.GetCreatorType: TCnCreatorType;
begin
  if Self.rbCreateApplication.Checked then
    Result := ctProject
  else // if Self.rbCreateUnit.Checked then
    Result := ctPascalUnit;
end;

procedure TCnDUnitSetForm.SetCreatorType(const Value: TCnCreatorType);
begin
  case Value of
    ctProject: Self.rbCreateApplication.Checked := True;
    ctPascalUnit: Self.rbCreateUnit.Checked := True;
  end;
end;

procedure TCnDUnitSetForm.btnHelpClick(Sender: TObject);
begin
  ShowFormHelp;
end;

function TCnDUnitSetForm.GetHelpTopic: string;
begin
  Result := 'CnDUnitWizard';
end;

end.
