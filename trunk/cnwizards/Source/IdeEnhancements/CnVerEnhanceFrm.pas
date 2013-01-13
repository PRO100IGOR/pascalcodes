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

unit CnVerEnhanceFrm;
{ |<PRE>
================================================================================
* ������ƣ�CnPack IDE ר�Ұ�
* ��Ԫ���ƣ��汾��Ϣ��չ���õ�Ԫ
* ��Ԫ���ߣ���ʡ��hubdog��
* ��    ע��
* ����ƽ̨��JWinXPPro + Delphi 7.01
* ���ݲ��ԣ�JWinXPPro+ Delphi 7.01
* �� �� �����õ�Ԫ�е��ַ���֧�ֱ��ػ�����ʽ
* ��Ԫ��ʶ��$Id: CnVerEnhanceFrm.pas 763 2011-02-07 14:18:23Z liuxiao@cnpack.org $
* �޸ļ�¼��2005.05.05 V1.0
*               ������Ԫ
================================================================================
|</PRE>}

interface

{$I CnWizards.inc}

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms,
  Dialogs, CnWizMultiLang, StdCtrls, CnLangTranslator, CnLangMgr,
  CnClasses, CnLangStorage, CnHashLangStorage;

type
  TCnVerEnhanceForm = class(TCnTranslateForm)
    grpVerEnh: TGroupBox;
    chkLastCompiled: TCheckBox;
    chkIncBuild: TCheckBox;
    btnOK: TButton;
    btnCancel: TButton;
    btnHelp: TButton;
    lblNote: TLabel;
    procedure btnHelpClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
  private
    { Private declarations }
  protected
    function GetHelpTopic: string; override;    
  public
    { Public declarations }
  end;

implementation

{$R *.dfm}

procedure TCnVerEnhanceForm.btnHelpClick(Sender: TObject);
begin
  ShowFormHelp;
end;

function TCnVerEnhanceForm.GetHelpTopic: string;
begin
  Result := 'CnVerEnhanceWizard';
end;

procedure TCnVerEnhanceForm.FormCreate(Sender: TObject);
begin
{$IFNDEF COMPILER6_UP}
  chkLastCompiled.Enabled := False;
  chkIncBuild.Enabled := False;
{$ENDIF}
end;

end.

