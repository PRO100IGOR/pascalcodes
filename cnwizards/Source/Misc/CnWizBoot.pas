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

unit CnWizBoot;
{ |<PRE>
================================================================================
* ������ƣ�CnPack IDE ר�Ұ�
* ��Ԫ���ƣ�ר����������
* ��Ԫ���ߣ����壨QSoft��  qsoft@cnpack.org
* ��    ע�������û�����������Delphiʱ������Shift�������ù��ߣ�������ʱ����/����
*           ר�ҡ�
*
* ����ƽ̨��PWin2000Pro + Delphi 5.62
* ���ݲ��ԣ�PWin9X/2000/XP + Delphi 5/6/7 + C++Builder 5/6
* �� �� �����ô����е��ַ��������ϱ��ػ�����ʽ
* ��Ԫ��ʶ��$Id: CnWizBoot.pas 763 2011-02-07 14:18:23Z liuxiao@cnpack.org $
* �޸ļ�¼��2003.10.03 V1.0
*               ������Ԫ
================================================================================
|</PRE>}

interface

{$I CnWizards.inc}

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  CnWizMultiLang, ComCtrls, StdCtrls, Buttons, ToolWin, CnWizConsts, CnWizOptions;

type
  TCnWizBootForm = class(TCnTranslateForm)
    lvWizardsList: TListView;
    ToolBar1: TToolBar;
    tbnSelectAll: TToolButton;
    tbnUnSelect: TToolButton;
    tbnReverseSelect: TToolButton;
    tbtnOK: TToolButton;
    ToolButton5: TToolButton;
    tbtnCancel: TToolButton;
    stbStatusbar: TStatusBar;
    procedure FormShow(Sender: TObject);
    procedure tbtnOKClick(Sender: TObject);
    procedure tbtnCancelClick(Sender: TObject);
    procedure tbnSelectAllClick(Sender: TObject);
    procedure tbnUnSelectClick(Sender: TObject);
    procedure tbnReverseSelectClick(Sender: TObject);
    procedure lvWizardsListClick(Sender: TObject);
    procedure FormKeyPress(Sender: TObject; var Key: Char);
  private
    { Private declarations }
    procedure UpdateStatusBar;
  public
    { Public declarations }
    procedure GetBootList(var ABoots: array of boolean);
  end;

implementation

uses CnWizClasses, CnWizManager;

{$R *.DFM}

procedure TCnWizBootForm.FormShow(Sender: TObject);
var
  i: integer;
begin
  for i := 0 to GetCnWizardClassCount - 1 do
  begin
    with lvWizardsList.Items.Add do
    begin
      Caption := IntToStr(i + 1); 
      SubItems.Add(TCnWizardClass(GetCnWizardClassByIndex(i)).WizardName);
      SubItems.Add(TCnWizardClass(GetCnWizardClassByIndex(i)).GetIDStr);
      SubItems.Add(GetCnWizardTypeNameFromClass(TCnWizardClass(GetCnWizardClassByIndex(i))));
      Checked := WizOptions.ReadBool(SCnBootLoadSection,
        TCnWizardClass(GetCnWizardClassByIndex(i)).ClassName,
        CnWizardMgr.WizardCanCreate[TCnWizardClass(GetCnWizardClassByIndex(i)).ClassName]);
    end;
  end;
  UpdateStatusBar;
end;

procedure TCnWizBootForm.UpdateStatusBar;
var
  i, count: integer;
begin
  count := 0;
  for i := 0 to lvWizardsList.Items.Count - 1 do
  begin
    if lvWizardsList.Items[i].Checked then
      Inc(count);
  end;
  
  stbStatusbar.Panels[1].Text := Format(SCnWizBootCurrentCount, [lvWizardsList.Items.Count]);
  stbStatusbar.Panels[2].Text := Format(SCnWizBootEnabledCount, [count]);
end;

procedure TCnWizBootForm.GetBootList(var ABoots: array of boolean);
var
  i: integer;
begin
  for i := 0 to lvWizardsList.Items.Count - 1 do
  begin
    ABoots[i] := lvWizardsList.Items[i].Checked;
  end;
end;

procedure TCnWizBootForm.tbtnOKClick(Sender: TObject);
var
  i: integer;
begin
  for i := 0 to GetCnWizardClassCount - 1 do
  begin
    WizOptions.WriteBool(SCnBootLoadSection,
      TCnWizardClass(GetCnWizardClassByIndex(i)).ClassName,
      lvWizardsList.Items[i].Checked);
  end;
  ModalResult := mrOK;
end;

procedure TCnWizBootForm.tbtnCancelClick(Sender: TObject);
begin
  ModalResult := mrCancel;
end;

procedure TCnWizBootForm.tbnSelectAllClick(Sender: TObject);
var
  i: integer;
begin
  for i := 0 to lvWizardsList.Items.Count - 1 do
  begin
    lvWizardsList.Items[i].Checked := True;
  end;
  UpdateStatusBar;
end;

procedure TCnWizBootForm.tbnUnSelectClick(Sender: TObject);
var
  i: integer;
begin
  for i := 0 to lvWizardsList.Items.Count - 1 do
  begin
    lvWizardsList.Items[i].Checked := False;
  end;
  UpdateStatusBar;
end;

procedure TCnWizBootForm.tbnReverseSelectClick(Sender: TObject);
var
  i: integer;
begin
  for i := 0 to lvWizardsList.Items.Count - 1 do
  begin
    lvWizardsList.Items[i].Checked := not lvWizardsList.Items[i].Checked;
  end;  
  UpdateStatusBar;
end;

procedure TCnWizBootForm.lvWizardsListClick(Sender: TObject);
begin
  UpdateStatusBar;
end;

procedure TCnWizBootForm.FormKeyPress(Sender: TObject; var Key: Char);
begin
  if Key = #27 then
    tbtnCancelClick(Nil);
end;

end.

