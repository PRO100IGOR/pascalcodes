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

unit CnWizAboutFrm;
{* |<PRE>
================================================================================
* ������ƣ�CnPack IDE ר�Ұ�
* ��Ԫ���ƣ����ڴ��嵥Ԫ
* ��Ԫ���ߣ�CnPack������
* ��    ע��
* ����ƽ̨��PWin2000Pro + Delphi 5.01
* ���ݲ��ԣ�PWin9X/2000/XP + Delphi 5/6/7 + C++Builder 5/6
* �� �� �����õ�Ԫ�е��ַ��������ϱ��ػ�����ʽ
* ��Ԫ��ʶ��$Id: CnWizAboutFrm.pas 763 2011-02-07 14:18:23Z liuxiao@cnpack.org $
* �޸ļ�¼��2002.09.28 V1.0
*               ������Ԫ
*           2003.03.10 V1.1
*               ������ͼƬ
================================================================================
|</PRE>}

interface

{$I CnWizards.inc}

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  ExtCtrls, StdCtrls, CnConsts, CnWizFeedbackFrm, CnWizMultiLang, CnLangMgr,
  CnWaterImage;

type
  TCnWizAboutForm = class(TCnTranslateForm)
    Bevel1: TBevel;
    Label2: TLabel;
    Label4: TLabel;
    btnOK: TButton;
    lblWeb: TLabel;
    lblEmail: TLabel;
    lblVersion: TLabel;
    lblBbs: TLabel;
    Bevel2: TBevel;
    Label3: TLabel;
    btnReport: TButton;
    Panel1: TPanel;
    btnLicense: TButton;
    tmr1: TTimer;
    CnWaterImage1: TCnWaterImage;
    imgDonation: TImage;
    edtVer: TEdit;
    lblSource: TLabel;
    procedure lblWebClick(Sender: TObject);
    procedure lblEmailClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure lblBbsClick(Sender: TObject);
    procedure btnReportClick(Sender: TObject);
    procedure btnLicenseClick(Sender: TObject);
    procedure imgDonationClick(Sender: TObject);
    procedure lblSourceClick(Sender: TObject);
  private
    { Private declarations }
  protected
    function GetHelpTopic: string; override;
  public
    { Public declarations }
  end;

// ��ʾ���ڴ���
procedure ShowCnWizAboutForm;

implementation

uses
  CnCommon, CnWizConsts, CnWizOptions;

{$R *.DFM}

// ��ʾ���ڴ���
procedure ShowCnWizAboutForm;
begin
  with TCnWizAboutForm.Create(Application.MainForm) do
  try
    ShowHint := WizOptions.ShowHint;
    ShowModal;
  finally
    Free;
  end;
end;

{ TCnWizAboutForm }

procedure TCnWizAboutForm.FormCreate(Sender: TObject);
begin
  edtVer.Text := Format('%s %s.%s Build %s', [edtVer.Text,
    SCnWizardMajorVersion, SCnWizardMinorVersion, SCnWizardBuildDate]);
end;

procedure TCnWizAboutForm.lblWebClick(Sender: TObject);
begin
  OpenUrl(SCnPackUrl);
end;

procedure TCnWizAboutForm.lblEmailClick(Sender: TObject);
begin
  MailTo(SCnPackEmail, SCnWizMailSubject);
end;

procedure TCnWizAboutForm.lblBbsClick(Sender: TObject);
begin
  OpenUrl(SCnPackBbsUrl);
end;

procedure TCnWizAboutForm.lblSourceClick(Sender: TObject);
begin
  OpenUrl(SCnPackSourceUrl);
end;

procedure TCnWizAboutForm.imgDonationClick(Sender: TObject);
begin
  OpenUrl(SCnPackDonationUrl);
end;

procedure TCnWizAboutForm.btnReportClick(Sender: TObject);
begin
  ShowFeedbackForm;
  ModalResult := mrOk;
end;

procedure TCnWizAboutForm.btnLicenseClick(Sender: TObject);
begin
  ShowFormHelp;
end;

function TCnWizAboutForm.GetHelpTopic: string;
begin
  Result := 'License';
end;

end.
