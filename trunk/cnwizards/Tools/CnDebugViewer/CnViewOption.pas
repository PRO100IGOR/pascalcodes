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

unit CnViewOption;
{ |<PRE>
================================================================================
* ������ƣ�CnDebugViewer
* ��Ԫ���ƣ����ô��嵥Ԫ
* ��Ԫ���ߣ�С����kend�� kending@21cn.com
* ��    ע��
* ����ƽ̨��PWin2000Pro + Delphi 5.01
* ���ݲ��ԣ�PWin9X/2000/XP + Delphi 5/6/7
* �� �� �����õ�Ԫ�е��ַ���֧�ֱ��ػ�����ʽ
* ��Ԫ��ʶ��$Id: CnViewOption.pas 763 2011-02-07 14:18:23Z liuxiao@cnpack.org $
* �޸ļ�¼��2008.01.18
*               Sesame: ���ӱ���������λ��ѡ��
*           2005.01.01
*               ������Ԫ��ʵ�ֹ���
================================================================================
|</PRE>}

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ComCtrls, CnLangMgr;

type
  TCnViewerOptionsFrm = class(TForm)
    btnOK: TButton;
    btnCancel: TButton;
    chkMinToTrayIcon: TCheckBox;
    chkCloseToTrayIcon: TCheckBox;
    hkShowFormHotKey: THotKey;
    grpTrayIcon: TGroupBox;
    chkShowTrayIcon: TCheckBox;
    grpCapture: TGroupBox;
    chkCapDebug: TCheckBox;
    lblCapOD: TLabel;
    lblHotKey: TLabel;
    chkMinStart: TCheckBox;
    chkSaveFormPosition: TCheckBox;
    procedure chkShowTrayIconClick(Sender: TObject);
  private
    { Private declarations }
    procedure SwitchTrayIconControls(const AShow: Boolean);
  protected
    procedure DoCreate; override;    
  public
    { Public declarations }
    procedure LoadFromOptions;
    procedure SaveToOptions;
  end;

implementation

uses CnViewCore;

{$R *.dfm}

{ TCnViewerOptionsFrm }

procedure TCnViewerOptionsFrm.DoCreate;
begin
  inherited;
  CnLanguageManager.TranslateForm(Self);
end;

procedure TCnViewerOptionsFrm.LoadFromOptions;
begin
  with CnViewerOptions do
  begin
    chkMinStart.Checked := StartMin;
    chkShowTrayIcon.Checked := ShowTrayIcon;
    chkMinToTrayIcon.Checked := MinToTrayIcon;
    chkCloseToTrayIcon.Checked := CloseToTrayIcon;
    chkSaveFormPosition.Checked := SaveFormPosition;
    hkShowFormHotKey.HotKey := MainShortCut;
    chkCapDebug.Checked := not IgnoreODString;
    SwitchTrayIconControls(ShowTrayIcon);
  end;
end;

procedure TCnViewerOptionsFrm.SaveToOptions;
begin
  with CnViewerOptions do
  begin
    StartMin := chkMinStart.Checked;
    ShowTrayIcon := chkShowTrayIcon.Checked;
    MinToTrayIcon := chkMinToTrayIcon.Checked;
    CloseToTrayIcon := chkCloseToTrayIcon.Checked;
    SaveFormPosition := chkSaveFormPosition.Checked;
    MainShortCut := hkShowFormHotKey.HotKey;
    IgnoreODString := not chkCapDebug.Checked;
  end;
end;

procedure TCnViewerOptionsFrm.SwitchTrayIconControls(const AShow: Boolean);
begin
  chkMinToTrayIcon.Enabled := AShow;
  chkCloseToTrayIcon.Enabled := AShow;
end;

procedure TCnViewerOptionsFrm.chkShowTrayIconClick(Sender: TObject);
begin
  SwitchTrayIconControls(chkShowTrayIcon.Checked);
end;

end.
