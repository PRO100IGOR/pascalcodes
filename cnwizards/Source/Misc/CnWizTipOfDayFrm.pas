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

unit CnWizTipOfDayFrm;
{* |<PRE>
================================================================================
* ������ƣ�CnPack IDE ר�Ұ�
* ��Ԫ���ƣ�ÿ��һ�����嵥Ԫ
* ��Ԫ���ߣ�h4x0r ogleu@msn.com; http://www.16cm.net
* ����ƽ̨��WinXpPro + Delphi 7
* ���ݲ��ԣ�PWin9X/2000/XP + Delphi 5/6/7 + C++Builder 5/6
* �� �� �����õ�Ԫ�е��ַ��������ϱ��ػ�����ʽ
* ��Ԫ��ʶ��$Id: CnWizTipOfDayFrm.pas 763 2011-02-07 14:18:23Z liuxiao@cnpack.org $
* �޸ļ�¼��2004.03.24 V1.0
*               ������Ԫ
================================================================================
|</PRE>}

interface

{$I CnWizards.inc}

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, ExtCtrls, IniFiles, CnWizClasses, CnWizMultiLang, CnLangMgr, CnWizIni,
  CnWideStrings;

type

//==============================================================================
// ÿ��һ������
//==============================================================================

{ TCnWizTipOfDayForm }

  TCnWizTipOfDayForm = class(TCnTranslateForm)
    imgIcon: TImage;
    btnNext: TButton;
    btnClose: TButton;
    Panel: TPanel;
    PanelBack: TPanel;
    lblTip: TLabel;
    PanelDyk: TPanel;
    lblDyk: TLabel;
    PanelSeparator: TPanel;
    ChkShowNextTime: TCheckBox;
    Label1: TLabel;
    Bevel1: TBevel;
    Bevel2: TBevel;
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure btnNextClick(Sender: TObject);
    procedure ShowTip;
  private
    FIni: TCnWideMemIniFile;
    FCurIndex: Integer;
    FTips: TStrings;
  public

  end;

procedure ShowCnWizTipOfDayForm(Manual: Boolean);
{* ��ʾÿ��һ�����壬Manual ��ʾ�Ƿ��ֹ�ǿ����ʾ�����Ϊ True ����ʾ��
   Ϊ False �����Ƿ���Ҫ��ʾ����ʾ���ݴ�ͳһ���ļ��ж�ȡ��}

implementation

uses CnWizConsts, CnWizOptions, CnCommon;

{$R *.dfm}

const
  csTipItem = 'TipItems';

var
  TipShowing: Boolean = False;

{ TCnWizTipOfDayForm }

procedure ShowCnWizTipOfDayForm(Manual: Boolean);
begin
  if (Manual or WizOptions.ShowTipOfDay) and not TipShowing then
  begin
    TipShowing := True;
    with TCnWizTipOfDayForm.Create(nil) do
    try
      ChkShowNextTime.Checked := WizOptions.ShowTipOfDay;
      ShowModal;

      WizOptions.ShowTipOfDay := ChkShowNextTime.Checked;
      WizOptions.SaveSettings;
    finally
      Free;
      TipShowing := False;
    end;
  end;
end;

procedure TCnWizTipOfDayForm.FormCreate(Sender: TObject);
var
  FileName: string;
begin
  FileName := GetFileFromLang(SCnWizTipOfDayIniFile);
  if not FileExists(FileName) then Exit;

  FIni := TCnWideMemIniFile.Create(FileName);
  FTips := TStringList.Create;
  FIni.ReadSectionValues(csTipItem, FTips);
  FCurIndex := Random(FTips.Count);
  ShowTip;
end;

procedure TCnWizTipOfDayForm.FormDestroy(Sender: TObject);
begin
  FTips.Free;
  FIni.Free;
end;

procedure TCnWizTipOfDayForm.btnNextClick(Sender: TObject);
begin
  if FTips = nil then
    Exit;

  Inc(FCurIndex);
  if FCurIndex > FTips.Count - 1 then
    FCurIndex := 0;
  ShowTip;
end;

procedure TCnWizTipOfDayForm.ShowTip;
var
  S: string;
  I: Integer;
begin
  if FTips = nil then
    Exit;
    
  if FTips.Count = 0 then
    S := ''
  else
    S := FTips.Strings[FCurIndex];
  I := Pos('=', S);
  if I > 0 then Delete(S, 1, I);
  lblTip.Caption := StringReplace(S, '\n', #13#10 , [rfReplaceAll, rfIgnoreCase]);
end;

end.
