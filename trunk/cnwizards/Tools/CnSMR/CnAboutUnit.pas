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

unit CnAboutUnit;
{ |<PRE>
================================================================================
* ������ƣ�CnPack ��ִ���ļ���ϵ��������
* ��Ԫ���ƣ����ڽ��ܵ�Ԫ
* ��Ԫ���ߣ�Chinbo��Shenloqi��
* ��    ע��
* ����ƽ̨��PWin2000Pro + Delphi 5.01
* ���ݲ��ԣ�PWin9X/2000/XP + Delphi 5/6/7 + C++Builder 5/6
* �� �� �����õ�Ԫ�е��ַ���֧�ֱ��ػ�����ʽ
* ��Ԫ��ʶ��$Id: CnAboutUnit.pas 763 2011-02-07 14:18:23Z liuxiao@cnpack.org $
* �޸ļ�¼��2007.08.29 V1.0
*               ������Ԫ
================================================================================
|</PRE>}

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms,
  Dialogs, CnMainUnit, StdCtrls, ExtCtrls, CnClasses, CnLangStorage,
  CnHashLangStorage, Buttons, CnCommon;

type
  TCnAboutForm = class(TForm)
    GridPanel1: TPanel;
    Label2: TLabel;
    pnl1: TPanel;
    lbl2: TLabel;
    lbl1: TLabel;
    bvl1: TBevel;
    img1: TImage;
    btnAbout: TBitBtn;
    btnClose: TBitBtn;
    btnHelp: TBitBtn;
    CnHashLangFileStorage: TCnHashLangFileStorage;
    bvlLine: TBevel;
    procedure btnCloseClick(Sender: TObject);
    procedure btnAboutClick(Sender: TObject);
    procedure btnHelpClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
  private
    { Private declarations }
    procedure CMGetFormIndex(var Message: TMessage); message CM_GETFORMINDEX;
  public
    { Public declarations }
  end;

implementation

{$R *.dfm}

{ TfAbout }

procedure TCnAboutForm.CMGetFormIndex(var Message: TMessage);
begin
  Message.Result := 1;
end;

procedure TCnAboutForm.btnCloseClick(Sender: TObject);
begin
  Application.Terminate;
end;

procedure TCnAboutForm.btnAboutClick(Sender: TObject);
begin
  InfoDlg(SCnIDEAbout, SCnAboutCaption);
end;

procedure TCnAboutForm.btnHelpClick(Sender: TObject);
begin
  if CnSMRMainForm <> nil then
    CnSMRMainForm.actHelp.Execute;
end;

procedure TCnAboutForm.FormShow(Sender: TObject);
begin
  lbl1.Font.Style := lbl1.Font.Style + [fsBold];
  Label2.Anchors := Label2.Anchors + [akRight];
end;

initialization
  RegisterFormClass(TCnAboutForm);

end.
