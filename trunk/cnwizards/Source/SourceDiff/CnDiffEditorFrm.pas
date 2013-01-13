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

unit CnDiffEditorFrm;
{* |<PRE>
================================================================================
* ������ƣ�CnPack IDE ר�Ұ�
* ��Ԫ���ƣ�Դ����ƴ�ϴ��嵥Ԫ
* ��Ԫ���ߣ�Angus Johnson��ԭ���ߣ� ajohnson@rpi.net.au
*           �ܾ�����ֲ��zjy@cnpack.org
* ��    ע��
* ����ƽ̨��PWin2000Pro + Delphi 5.01
* ���ݲ��ԣ�PWin9X/2000/XP + Delphi 5/6/7 + C++Builder 5/6
* �� �� �����ô����е��ַ��������ϱ��ػ�����ʽ
* ��Ԫ��ʶ��$Id: CnDiffEditorFrm.pas 763 2011-02-07 14:18:23Z liuxiao@cnpack.org $
* �޸ļ�¼��2003.03.11 V1.0
*               ������Ԫ��ʵ�ֹ���
================================================================================
|</PRE>}

interface

{$I CnWizards.inc}

{$IFDEF CNWIZARDS_CNSOURCEDIFFWIZARD}

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, ExtCtrls, ActnList, CnWizMultiLang;

type
  TCnDiffEditorForm = class(TCnTranslateForm)
    Panel1: TPanel;
    Memo: TMemo;
    bSave: TButton;
    bCancel: TButton;
    Label1: TLabel;
    ActionList: TActionList;
    actSave: TAction;
    actCancel: TAction;
    procedure MemoKeyPress(Sender: TObject; var Key: Char);
    procedure actSaveExecute(Sender: TObject);
    procedure actCancelExecute(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

{$ENDIF CNWIZARDS_CNSOURCEDIFFWIZARD}

implementation

{$IFDEF CNWIZARDS_CNSOURCEDIFFWIZARD}

{$R *.DFM}

procedure TCnDiffEditorForm.MemoKeyPress(Sender: TObject; var Key: Char);
begin
  //if Key = #27 then
    //ModalResult := mrCancel;
end;

procedure TCnDiffEditorForm.actSaveExecute(Sender: TObject);
begin
  ModalResult := mrOk;
end;

procedure TCnDiffEditorForm.actCancelExecute(Sender: TObject);
begin
  ModalResult := mrCancel;
end;

{$ENDIF CNWIZARDS_CNSOURCEDIFFWIZARD}
end.
