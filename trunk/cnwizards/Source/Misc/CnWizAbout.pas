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

unit CnWizAbout;
{* |<PRE>
================================================================================
* ������ƣ�CnPack IDE ר�Ұ�
* ��Ԫ���ƣ�ר�Ұ����������ڵ�Ԫ
* ��Ԫ���ߣ��ܾ��� (zjy@cnpack.org)
* ��    ע��
* ����ƽ̨��PWin2000Pro + Delphi 5.01
* ���ݲ��ԣ�PWin9X/2000/XP + Delphi 5/6/7 + C++Builder 5/6
* �� �� �����õ�Ԫ�е��ַ��������ϱ��ػ�����ʽ
* ��Ԫ��ʶ��$Id: CnWizAbout.pas 763 2011-02-07 14:18:23Z liuxiao@cnpack.org $
* �޸ļ�¼��2004.03.24 V1.1
*               ����ÿ��һ��
*           2003.04.29 V1.0
*               ������Ԫ
================================================================================
|</PRE>}

interface

{$I CnWizards.inc}

uses
  Windows, Messages, SysUtils, Classes, IniFiles,
  CnConsts, CnWizClasses, CnWizConsts, CnWizUtils, CnCommon, CnWizOptions;

type

{ TCnWizAbout }

  TCnWizAbout = class(TCnSubMenuWizard)
  private
    FIdHelp: Integer;
    FIdHistory: Integer;
    FIdTipOfDay: Integer;
    FIdBugReport: Integer;
    FIdUpgrade: Integer;
    FIdConfigIO: Integer;
    FIdUrl: Integer;
    FIdBbs: Integer;
    FIdMail: Integer;
    FIdAbout: Integer;
  protected
    procedure ConfigIO;
    procedure SubActionExecute(Index: Integer); override;
  public
    constructor Create; override;
    procedure AcquireSubActions; override;
    class procedure GetWizardInfo(var Name, Author, Email, Comment: string); override;
    class function IsInternalWizard: Boolean; override;

    function GetCaption: string; override;
    function GetHint: string; override;
  end;

implementation

uses
  CnWizAboutFrm, CnWizFeedbackFrm, CnWizUpgradeFrm, CnWizTipOfDayFrm;

{ TCnWizAbout }

procedure TCnWizAbout.ConfigIO;
var
  FileName: string;
begin
  FileName := WizOptions.DllPath + SCnConfigIOName;
  if FileExists(FileName) then
    RunFile(FileName)
  else
    ErrorDlg(SCnConfigIONotExists);
end;

constructor TCnWizAbout.Create;
begin
  inherited;
  // ��Ϊ�� Wizard ���ᱻ Loaded���ã�����Ҫ�ֹ� AcquireSubActions;
  AcquireSubActions;
end;

procedure TCnWizAbout.AcquireSubActions;
begin
  FIdHelp := RegisterASubAction(SCnWizAboutHelp, SCnWizAboutHelpCaption, 0, SCnWizAboutHelpHint);
  FIdHistory := RegisterASubAction(SCnWizAboutHistory, SCnWizAboutHistoryCaption, 0, SCnWizAboutHistoryHint);
  FIdTipOfDay := RegisterASubAction(SCnWizAboutTipOfDay, SCnWizAboutTipOfDaysCaption, 0, SCnWizAboutTipOfDayHint, SCnWizAboutTipOfDay);
  AddSepMenu;
  FIdBugReport := RegisterASubAction(SCnWizAboutBugReport, SCnWizAboutBugReportCaption, 0, SCnWizAboutBugReportHint);
  FIdUpgrade := RegisterASubAction(SCnWizAboutUpgrade, SCnWizAboutUpgradeCaption, 0, SCnWizAboutUpgradeHint);
  FIdConfigIO := RegisterASubAction(SCnWizAboutConfigIO, SCnWizAboutConfigIOCaption, 0, SCnWizAboutConfigIOHint);
  AddSepMenu;
  FIdUrl := RegisterASubAction(SCnWizAboutUrl, SCnWizAboutUrlCaption, 0, SCnWizAboutUrlHint);
  FIdBbs := RegisterASubAction(SCnWizAboutBbs, SCnWizAboutBbsCaption, 0, SCnWizAboutBbsHint);
  FIdMail := RegisterASubAction(SCnWizAboutMail, SCnWizAboutMailCaption, 0, SCnWizAboutMailHint);
  AddSepMenu;
  FIdAbout := RegisterASubAction(SCnWizAboutAbout, SCnWizAboutAboutCaption, 0, SCnWizAboutAboutHint, ClassName);
end;

function TCnWizAbout.GetCaption: string;
begin
  Result := SCnWizAboutCaption;
end;

function TCnWizAbout.GetHint: string;
begin
  Result := SCnWizAboutHint;
end;

class procedure TCnWizAbout.GetWizardInfo(var Name, Author, Email,
  Comment: string);
begin

end;

class function TCnWizAbout.IsInternalWizard: Boolean;
begin
  Result := True;
end;

procedure TCnWizAbout.SubActionExecute(Index: Integer);
begin
  if Index = FIdHelp then
    ShowHelp('Index')
  else if Index = FIdHistory then
    ShowHelp('History')
  else if Index = FIdTipOfDay then
    ShowCnWizTipOfDayForm(True)
  else if Index = FIdBugReport then
    ShowFeedbackForm
  else if Index = FIdUpgrade then
    CheckUpgrade(True)
  else if Index = FIdConfigIO then
    ConfigIO
  else if Index = FIdUrl then
    OpenUrl(SCnPackUrl)
  else if Index = FIdBbs then
    OpenUrl(SCnPackBbsUrl)
  else if Index = FIdMail then
    MailTo(SCnPackEmail, SCnWizMailSubject)
  else if Index = FIdAbout then
    ShowCnWizAboutForm;
end;

end.

