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

unit CnWizEdtTabSetFrm;
{* |<PRE>
================================================================================
* ������ƣ�CnPack IDE ר�Ұ�
* ��Ԫ���ƣ�����༭�� TabSet �ҽӻ�����
* ��Ԫ���ߣ��ܾ��� (zjy@cnpack.org)
* ��    ע���õ�Ԫ������չIDEԴ��༭����TabSet��ǩ
* ����ƽ̨��PWin2000Pro + Delphi 5.01
* ���ݲ��ԣ�PWin9X/2000/XP + Delphi 5/6/7 + C++Builder 5/6
* �� �� �����õ�Ԫ�е��ַ��������ϱ��ػ�����ʽ
* ��Ԫ��ʶ��$Id: CnWizEdtTabSetFrm.pas 763 2011-02-07 14:18:23Z liuxiao@cnpack.org $
* �޸ļ�¼��
================================================================================
|</PRE>}

interface

{$I CnWizards.inc}

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  CnWizMultiLang, ToolsAPI;

type
  TCnWizEdtTabSetForm = class(TCnTranslateForm)
  private
    { Private declarations }
  public
    { Public declarations }
    function GetTabCaption: string; virtual; abstract;
    function IsTabVisible(Editor: IOTASourceEditor; View: IOTAEditView): Boolean; virtual;
    procedure DoTabShow(Editor: IOTASourceEditor; View: IOTAEditView); virtual;
    procedure DoTabHide; virtual;
  end;

  TCnWizEdtTabSetFormClass = class of TCnWizEdtTabSetForm;

implementation

{$R *.DFM}

{ TCnWizEdtTabSetForm }

procedure TCnWizEdtTabSetForm.DoTabHide;
begin

end;

procedure TCnWizEdtTabSetForm.DoTabShow(Editor: IOTASourceEditor;
  View: IOTAEditView);
begin

end;

function TCnWizEdtTabSetForm.IsTabVisible(Editor: IOTASourceEditor;
  View: IOTAEditView): Boolean;
begin
  Result := True;
end;

end.
