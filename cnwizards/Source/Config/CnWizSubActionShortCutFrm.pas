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

unit CnWizSubActionShortCutFrm;
{* |<PRE>
================================================================================
* ������ƣ�CnPack IDE ר�Ұ�
* ��Ԫ���ƣ�ר���Ӳ˵���ݼ����öԻ���Ԫ
* ��Ԫ���ߣ��ܾ��� (zjy@cnpack.org)
* ��    ע��
* ����ƽ̨��PWin2000Pro + Delphi 5.01
* ���ݲ��ԣ�PWin9X/2000/XP + Delphi 5/6/7 + C++Builder 5/6
* �� �� �����õ�Ԫ�е��ַ��������ϱ��ػ�����ʽ
* ��Ԫ��ʶ��$Id: CnWizSubActionShortCutFrm.pas 763 2011-02-07 14:18:23Z liuxiao@cnpack.org $
* �޸ļ�¼��2003.05.02 V1.0
*               ������Ԫ
================================================================================
|</PRE>}

interface

{$I CnWizards.inc}

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, ComCtrls, Menus, CnWizClasses, CnWizUtils, CnWizShortCut,
  CnWizMenuAction, CnWizConsts, CnWizMultiLang;

type
  TCnWizSubActionShortCutForm = class(TCnTranslateForm)
    grp1: TGroupBox;
    ListView: TListView;
    lbl2: TLabel;
    HotKey: THotKey;
    btnHelp: TButton;
    btnOK: TButton;
    btnCancel: TButton;
    procedure FormShow(Sender: TObject);
    procedure btnOKClick(Sender: TObject);
    procedure btnHelpClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure ListViewChange(Sender: TObject; Item: TListItem;
      Change: TItemChange);
    procedure HotKeyExit(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
  private
    { Private declarations }
    FWizard: TCnSubMenuWizard;
    FHelpStr: string;
    FShortCuts: array of TShortCut;
    procedure GetShortCutsFromWizard;
    procedure SetShortCutsToWizard;
    function GetShortCut(Index: Integer): TShortCut;
    procedure SetShortCut(Index: Integer; const Value: TShortCut);
  protected
    function GetHelpTopic: string; override;
  public
    { Public declarations }
    property Wizard: TCnSubMenuWizard read FWizard;
    property ShortCuts[Index: Integer]: TShortCut read GetShortCut write SetShortCut;
  end;

function SubActionShortCutConfig(AWizard: TCnSubMenuWizard;
  const HelpStr: string = ''): Boolean;

implementation

{$R *.DFM}

function SubActionShortCutConfig(AWizard: TCnSubMenuWizard;
  const HelpStr: string): Boolean;
begin
  with TCnWizSubActionShortCutForm.Create(nil) do
  try
    FWizard := AWizard;
    if HelpStr <> '' then
      FHelpStr := HelpStr;
    Result := ShowModal = mrOk;
  finally
    Free;
  end;
end;

procedure TCnWizSubActionShortCutForm.FormCreate(Sender: TObject);
begin
  FHelpStr := 'CnWizSubActionShortCutForm';
  ListView.SmallImages := GetIDEImageList;
end;

procedure TCnWizSubActionShortCutForm.FormShow(Sender: TObject);
begin
  GetShortCutsFromWizard;
  Caption := Format(SCnWizSubActionShortCutFormCaption, [Wizard.WizardName]);
end;

procedure TCnWizSubActionShortCutForm.FormDestroy(Sender: TObject);
begin
  FShortCuts := nil;
  inherited;
end;

procedure TCnWizSubActionShortCutForm.btnOKClick(Sender: TObject);
begin
  SetShortCutsToWizard;
  ModalResult := mrOk;
end;

procedure TCnWizSubActionShortCutForm.btnHelpClick(Sender: TObject);
begin
  ShowFormHelp;
end;

function TCnWizSubActionShortCutForm.GetHelpTopic: string;
begin
  Result := FHelpStr;
end;

function TCnWizSubActionShortCutForm.GetShortCut(
  Index: Integer): TShortCut;
begin
  Result := FShortCuts[Index];
end;

procedure TCnWizSubActionShortCutForm.SetShortCut(Index: Integer;
  const Value: TShortCut);
begin
  FShortCuts[Index] := Value;
  if ListView.Items[Index].SubItems.Count > 0 then
    ListView.Items[Index].SubItems[0] := ShortCutToText(Value)
  else
    ListView.Items[Index].SubItems.Add(ShortCutToText(Value));
end;

procedure TCnWizSubActionShortCutForm.GetShortCutsFromWizard;
var
  i: Integer;
begin
  ListView.Items.Clear;
  SetLength(FShortCuts, Wizard.SubActionCount);
  for i := 0 to Wizard.SubActionCount - 1 do
    with ListView.Items.Add do
    begin
      Caption := StripHotkey(Wizard.SubActions[i].Caption);
      ImageIndex := Wizard.SubActions[i].ImageIndex;
      Data := Wizard.SubActions[i];
      ShortCuts[i] := Wizard.SubActions[i].ShortCut;
    end;
end;

procedure TCnWizSubActionShortCutForm.SetShortCutsToWizard;
var
  i: Integer;
begin
  WizShortCutMgr.BeginUpdate;
  try
    for i := 0 to ListView.Items.Count - 1 do
      TCnWizMenuAction(ListView.Items[i].Data).ShortCut := ShortCuts[i];
  finally
    WizShortCutMgr.EndUpdate;
  end;
end;

procedure TCnWizSubActionShortCutForm.ListViewChange(Sender: TObject;
  Item: TListItem; Change: TItemChange);
begin
  if Assigned(ListView.Selected) then
    HotKey.HotKey := ShortCuts[ListView.Selected.Index]
  else
    HotKey.HotKey := 0;
end;

procedure TCnWizSubActionShortCutForm.HotKeyExit(Sender: TObject);
begin
  if Assigned(ListView.Selected) then
    ShortCuts[ListView.Selected.Index] := HotKey.HotKey;
end;

end.
