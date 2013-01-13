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

unit CnSourceDiffWizard;
{* |<PRE>
================================================================================
* ������ƣ�CnPack IDE ר�Ұ�
* ��Ԫ���ƣ�Դ����Ƚ�ר�ҵ�Ԫ
* ��Ԫ���ߣ��ܾ��� (zjy@cnpack.org)
* ��    ע��
* ����ƽ̨��PWin2000Pro + Delphi 5.01
* ���ݲ��ԣ�PWin9X/2000/XP + Delphi 5/6/7 + C++Builder 5/6
* �� �� �����ô����е��ַ��������ϱ��ػ�����ʽ
* ��Ԫ��ʶ��$Id: CnSourceDiffWizard.pas 763 2011-02-07 14:18:23Z liuxiao@cnpack.org $
* �޸ļ�¼��2003.03.11 V1.0
*               ������Ԫ��ʵ�ֹ���
================================================================================
|</PRE>}

interface

{$I CnWizards.inc}

{$IFDEF CNWIZARDS_CNSOURCEDIFFWIZARD}

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  ToolsAPI, IniFiles, CnWizClasses, CnWizUtils, CnWizConsts, CnConsts,
  CnSourceDiffFrm;

type

//==============================================================================
// Դ����Ƚ�ר��
//==============================================================================

{ TCnSourceDiffWizard }

  TCnSourceDiffWizard = class(TCnMenuWizard)
  private
    FIni: TCustomIniFile;
  protected
    procedure SetActive(Value: Boolean); override;
  public
    constructor Create; override;
    destructor Destroy; override;
    class procedure GetWizardInfo(var Name, Author, Email, Comment: string); override;
    function GetCaption: string; override;
    function GetHint: string; override;
    function GetDefShortCut: TShortCut; override;
    procedure Execute; override;
  end;

{$ENDIF CNWIZARDS_CNSOURCEDIFFWIZARD}

implementation

{$IFDEF CNWIZARDS_CNSOURCEDIFFWIZARD}

//==============================================================================
// Դ����Ƚ�ר��
//==============================================================================

{ TCnSourceDiffWizard }

constructor TCnSourceDiffWizard.Create;
begin
  inherited;
  FIni := CreateIniFile;
end;

destructor TCnSourceDiffWizard.Destroy;
begin
  FreeSourceDiffForm;
  FIni.Free;
  inherited;
end;

procedure TCnSourceDiffWizard.Execute;
begin
  ShowSourceDiffForm(FIni, Self.Icon);
end;

function TCnSourceDiffWizard.GetCaption: string;
begin
  Result := SCnSourceDiffWizardMenuCaption;
end;

function TCnSourceDiffWizard.GetDefShortCut: TShortCut;
begin
  Result := 0;
end;

function TCnSourceDiffWizard.GetHint: string;
begin
  Result := SCnSourceDiffWizardMenuHint;
end;

class procedure TCnSourceDiffWizard.GetWizardInfo(var Name, Author, Email, Comment: string);
begin
  Name := SCnSourceDiffWizardName;
  Author := 'Angus Johnson' + ';' + SCnPack_Zjy;
  Email := 'ajohnson@rpi.net.au' + ';' + SCnPack_ZjyEmail;
  Comment := SCnSourceDiffWizardComment;
end;

procedure TCnSourceDiffWizard.SetActive(Value: Boolean);
begin
  inherited;
  if not Active then
  begin
    if CnSourceDiffForm <> nil then
      FreeAndNil(CnSourceDiffForm);
  end;
end;

initialization
  RegisterCnWizard(TCnSourceDiffWizard); // ע��ר��

{$ENDIF CNWIZARDS_CNSOURCEDIFFWIZARD}
end.
