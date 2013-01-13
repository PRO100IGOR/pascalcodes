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

unit CnPaletteEnhanceFrm;
{ |<PRE>
================================================================================
* ������ƣ�CnPack IDE ר�Ұ�
* ��Ԫ���ƣ���������չ���õ�Ԫ
* ��Ԫ���ߣ���Х��LiuXiao��
* ��    ע��
* ����ƽ̨��PWin2000Pro + Delphi 5.01
* ���ݲ��ԣ�PWin9X/2000/XP + Delphi 5/6/7 + C++Builder 5/6
* �� �� �����õ�Ԫ�е��ַ���֧�ֱ��ػ�����ʽ
* ��Ԫ��ʶ��$Id: CnPaletteEnhanceFrm.pas 763 2011-02-07 14:18:23Z liuxiao@cnpack.org $
* �޸ļ�¼��2003.06.23 V1.0
*               ������Ԫ
================================================================================
|</PRE>}

interface

{$I CnWizards.inc}

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, ComCtrls, ToolWin, Menus, ToolsAPI,
  CnWizUtils, CnWizMultiLang, CnWizShareImages, CnWizConsts;

type
  TCnPalEnhanceForm = class(TCnTranslateForm)
    grpPalEnh: TGroupBox;
    chkAddTabs: TCheckBox;
    chkMultiLine: TCheckBox;
    btnHelp: TButton;
    btnOK: TButton;
    btnCancel: TButton;
    grpMisc: TGroupBox;
    chkMenuLine: TCheckBox;
    grpMenu: TGroupBox;
    chkMoveWizMenus: TCheckBox;
    edtMoveToUser: TEdit;
    lbl1: TLabel;
    lbl2: TLabel;
    lbl3: TLabel;
    tlb1: TToolBar;
    btnAdd: TToolButton;
    btnUp: TToolButton;
    btnDown: TToolButton;
    btnDelete: TToolButton;
    lstSource: TListBox;
    lstDest: TListBox;
    chkDivTabMenu: TCheckBox;
    chkCompFilter: TCheckBox;
    chkButtonStyle: TCheckBox;
    chkLockToolbar: TCheckBox;
    procedure FormCreate(Sender: TObject);
    procedure btnHelpClick(Sender: TObject);
    procedure UpdateControls(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure btnAddClick(Sender: TObject);
    procedure btnDeleteClick(Sender: TObject);
    procedure btnUpClick(Sender: TObject);
    procedure btnDownClick(Sender: TObject);
  private
    { Private declarations }
  protected
    function GetHelpTopic: string; override;
  public
    { Public declarations }
    procedure SetWizMenuNames(AList: TStrings; AWizMenu: TMenuItem);
    procedure GetWizMenuNames(AList: TStrings);
  end;

implementation

{$R *.DFM}

procedure TCnPalEnhanceForm.FormCreate(Sender: TObject);
begin
  {$IFDEF COMPILER5}
  chkAddTabs.Enabled := True;
  {$ELSE}
  chkAddTabs.Enabled := False;
  {$ENDIF}

  {$IFDEF DELPHI7} // ֻ�� D7 ����Ч
  chkMenuLine.Enabled := True;
  {$ELSE}
  chkMenuLine.Enabled := False;
  {$ENDIF}

  {$IFDEF COMPILER8_UP}
  // 8 �Լ����ϰ汾�޴�����
  chkMultiLine.Enabled := False;
  chkButtonStyle.Enabled := False;
  chkDivTabMenu.Enabled := False;
  chkCompFilter.Enabled := False;
  {$ELSE}
  chkMultiLine.Enabled := True;
  chkButtonStyle.Enabled := True;
  chkDivTabMenu.Enabled := True;
  chkCompFilter.Enabled := True;
  {$ENDIF}
end;

procedure TCnPalEnhanceForm.FormShow(Sender: TObject);
begin
  UpdateControls(nil);
end;

procedure TCnPalEnhanceForm.btnHelpClick(Sender: TObject);
begin
  ShowFormHelp;
end;

function TCnPalEnhanceForm.GetHelpTopic: string;
begin
  Result := 'CnPalEnhanceWizard';
end;

procedure TCnPalEnhanceForm.UpdateControls(Sender: TObject);
begin
  edtMoveToUser.Enabled := chkMoveWizMenus.Checked;
  lstSource.Enabled := chkMoveWizMenus.Checked;
  lstDest.Enabled := chkMoveWizMenus.Checked;
  btnAdd.Enabled := chkMoveWizMenus.Checked and (lstSource.SelCount > 0);
  btnDelete.Enabled := chkMoveWizMenus.Checked and (lstDest.SelCount > 0);
  btnUp.Enabled := chkMoveWizMenus.Checked and (lstDest.SelCount > 0);
  btnDown.Enabled := chkMoveWizMenus.Checked and (lstDest.SelCount > 0);
end;

procedure TCnPalEnhanceForm.GetWizMenuNames(AList: TStrings);
var
  i: Integer;
begin
  AList.Clear;
  for i := 0 to lstDest.Items.Count - 1 do
    AList.Add(TMenuItem(lstDest.Items.Objects[i]).Name);
end;

procedure TCnPalEnhanceForm.SetWizMenuNames(AList: TStrings; AWizMenu: TMenuItem);
var
  i: Integer;
  Idx: Integer;
  MainMenu: TMainMenu;
  
  procedure DoAddMenu(AMenu: TMenuItem);
  begin
    if (AMenu.Name <> '') and (AMenu.Owner <> MainMenu.Owner) and
      not SameText(AMenu.Name, SToolsMenuName) and
      not SameText(AMenu.Name, SCnWizMenuName) then
    begin
      lstSource.Items.AddObject(Format('%s (%s)',
        [StripHotkey(AMenu.Caption), AMenu.Name]), AMenu);
    end;
  end;

  function IndexOfMenu(const AName: string): Integer;
  var
    i: Integer;
  begin
    Result := -1;
    for i := 0 to lstSource.Items.Count - 1 do
      if SameText(TMenuItem(lstSource.Items.Objects[i]).Name, AName) then
      begin
        Result := i;
        Exit;
      end;  
  end;  
begin
  lstSource.Items.Clear;
  MainMenu := GetIDEMainMenu;
  if MainMenu <> nil then
    for i := 0 to MainMenu.Items.Count - 1 do
      DoAddMenu(MainMenu.Items[i]);

  for i := 0 to AWizMenu.Count - 3 do
    DoAddMenu(AWizMenu[i]);

  lstDest.Items.Clear;
  for i := 0 to AList.Count - 1 do
  begin
    Idx := IndexOfMenu(Trim(AList[i]));
    if Idx >= 0 then
      lstDest.Items.AddObject(lstSource.Items[Idx], lstSource.Items.Objects[Idx]);
  end;
end;

procedure TCnPalEnhanceForm.btnAddClick(Sender: TObject);
var
  i: Integer;
begin
  for i := 0 to lstSource.Items.Count - 1 do
    if lstSource.Selected[i] and (lstDest.Items.IndexOf(lstSource.Items[i]) < 0) then
      lstDest.Items.AddObject(lstSource.Items[i], lstSource.Items.Objects[i]);
end;

procedure TCnPalEnhanceForm.btnDeleteClick(Sender: TObject);
var
  i: Integer;
begin
  for i := lstDest.Items.Count - 1 downto 0 do
    if lstDest.Selected[i] then
      lstDest.Items.Delete(i);
end;

procedure TCnPalEnhanceForm.btnUpClick(Sender: TObject);
var
  i: Integer;
begin
  for i := 1 to lstDest.Items.Count - 1 do
    if lstDest.Selected[i] and not lstDest.Selected[i - 1] then
    begin
      lstDest.Items.Move(i, i - 1);
      lstDest.Selected[i - 1] := True;
    end;
end;

procedure TCnPalEnhanceForm.btnDownClick(Sender: TObject);
var
  i: Integer;
begin
  for i := lstDest.Items.Count - 2 downto 0 do
    if lstDest.Selected[i] and not lstDest.Selected[i + 1] then
    begin
      lstDest.Items.Move(i, i + 1);
      lstDest.Selected[i + 1] := True;
    end;
end;

end.
