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

unit CnPropEditorCustomizeFrm;
{ |<PRE>
================================================================================
* ������ƣ�CnPack IDE ר�Ұ�
* ��Ԫ���ƣ����Ա༭�����ƴ���
* ��Ԫ���ߣ��ܾ��� (zjy@cnpack.org)
* ��    ע��
* ����ƽ̨��PWinXP SP2 + Delphi 5.01
* ���ݲ��ԣ�PWin9X/2000/XP + Delphi 5/6/7 + C++Builder 5/6
* �� �� �����õ�Ԫ�е��ַ���֧�ֱ��ػ�����ʽ
* ��Ԫ��ʶ��$Id: CnPropEditorCustomizeFrm.pas 867 2011-07-07 09:34:13Z zjy@cnpack.org $
* �޸ļ�¼��2006.09.08 V1.0
*               ������Ԫ
================================================================================
|</PRE>}

interface

{$I CnWizards.inc}

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, CnDesignEditorConsts, CnWizMultiLang;

type
  TCnPropEditorCustomizeForm = class(TCnTranslateForm)
    grp1: TGroupBox;
    mmoProp: TMemo;
    lbl1: TLabel;
    btnOK: TButton;
    btnCancel: TButton;
    btnHelp: TButton;
    procedure btnHelpClick(Sender: TObject);
    procedure FormKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
  private
    { Private declarations }
  protected
    function GetHelpTopic: string; override;
  public
    { Public declarations }
  end;

function ShowPropEditorCustomizeForm(List: TStrings; IsComp: Boolean): Boolean;

implementation

{$R *.DFM}

function ShowPropEditorCustomizeForm(List: TStrings; IsComp: Boolean): Boolean;
begin
  with TCnPropEditorCustomizeForm.Create(nil) do
  try
    if IsComp then
    begin
      Caption := SCnCompEditorCustomizeCaption;
      grp1.Caption := SCnCompEditorCustomizeCaption1;
      lbl1.Caption := SCnCompEditorCustomizeDesc;
    end;
    mmoProp.Lines.Assign(List);
    Result := ShowModal = mrOk;
    if Result then
      List.Assign(mmoProp.Lines);
  finally
    Free;
  end;   
end;  

procedure TCnPropEditorCustomizeForm.btnHelpClick(Sender: TObject);
begin
  ShowFormHelp;
end;

function TCnPropEditorCustomizeForm.GetHelpTopic: string;
begin
  Result := 'CnPropEditorCustomizeForm';
end;

procedure TCnPropEditorCustomizeForm.FormKeyDown(Sender: TObject;
  var Key: Word; Shift: TShiftState);
begin
  if (Shift = [ssCtrl]) and (Ord(Key) = VK_RETURN) then
    btnOK.Click;
end;

end.
 