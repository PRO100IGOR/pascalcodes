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

unit CnWizMenuSortFrm;
{* |<PRE>
================================================================================
* ������ƣ�CnPack IDE ר�Ұ�
* ��Ԫ���ƣ��߼����õ�Ԫ
* ��Ԫ���ߣ�LiuXiao
* ��    ע��
* ����ƽ̨��PWin2000Pro + Delphi 5.01
* ���ݲ��ԣ�PWin9X/2000/XP + Delphi 5/6/7 + C++Builder 5/6
* �� �� �����õ�Ԫ�е��ַ��������ϱ��ػ�����ʽ
* ��Ԫ��ʶ��$Id: CnWizMenuSortFrm.pas 763 2011-02-07 14:18:23Z liuxiao@cnpack.org $
* �޸ļ�¼��2003.08.02 V1.1
*               LiuXiao �����Ƿ񴴽�ר�ҵ�����
*           2003.06.27 V1.0
*               ������Ԫ
================================================================================
|</PRE>}

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, Buttons, ComCtrls, ActnList, Menus, CheckLst, CnWizUtils, CnCommon,
  CnWizMultiLang;

type
  TCnMenuSortForm = class(TCnTranslateForm)
    btnOK: TButton;
    btnCancel: TButton;
    btnHelp: TButton;
    ActionList: TActionList;
    UpAction: TAction;
    DownAction: TAction;
    ResetAction: TAction;
    PageControl: TPageControl;
    TabSheet1: TTabSheet;
    lvMenuWizards: TListView;
    Label1: TLabel;
    btnReset: TBitBtn;
    btnDown: TBitBtn;
    btnUp: TBitBtn;
    TabSheet2: TTabSheet;
    Label2: TLabel;
    lvWizardCreate: TListView;
    actSelAll: TAction;
    actSelNone: TAction;
    actSelReverse: TAction;
    BitBtn1: TBitBtn;
    BitBtn2: TBitBtn;
    BitBtn3: TBitBtn;
    procedure ResetActionExecute(Sender: TObject);
    procedure ActionListUpdate(Action: TBasicAction; var Handled: Boolean);
    procedure btnHelpClick(Sender: TObject);
    procedure UpActionExecute(Sender: TObject);
    procedure DownActionExecute(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure lvMenuWizardsStartDrag(Sender: TObject;
      var DragObject: TDragObject);
    procedure lvMenuWizardsDragOver(Sender, Source: TObject; X, Y: Integer;
      State: TDragState; var Accept: Boolean);
    procedure lvMenuWizardsDragDrop(Sender, Source: TObject; X,
      Y: Integer);
    procedure lvMenuWizardsColumnClick(Sender: TObject;
      Column: TListColumn);
    procedure lvMenuWizardsCompare(Sender: TObject; Item1,
      Item2: TListItem; Data: Integer; var Compare: Integer);
    procedure actSelAllExecute(Sender: TObject);
    procedure actSelNoneExecute(Sender: TObject);
    procedure actSelReverseExecute(Sender: TObject);
    procedure lvMenuWizardsKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
  private
    FDragIndex: Integer;
    FColumnToSort: Integer;
    FSortFlag: array[0..3] of Boolean;
    FMWizards: TList;
    procedure InitMenusFromList(Sorted: TList);
    { Private declarations }
  protected
    function GetHelpTopic: string; override;
  public
    procedure InitWizardMenus;
    procedure SaveWizardCreateInfo;
    procedure ReSortMenuWizards;
    procedure ExchangeTwoListItems(A, B: TListItem);
    { Public declarations }
  end;

var
  CnMenuSortForm: TCnMenuSortForm;

implementation

uses CnWizManager, CnWizConsts, CnWizClasses;

{$R *.DFM}

{ TCnMenuSortFrm }

// Ӧ�ð��յ�ǰ�˵���˳��������
procedure TCnMenuSortForm.InitMenusFromList(Sorted: TList);
var
  i: Integer;
begin
  if Sorted = nil then
    Exit;

  Self.lvMenuWizards.Items.BeginUpdate;
  try
    Self.lvMenuWizards.Items.Clear;
    for i := 0 to Sorted.Count - 1 do
    begin
      with Self.lvMenuWizards.Items.Add do
      begin
        Caption := StripHotKey(TCnMenuWizard(Sorted[i]).Menu.Caption);
        SubItems.Add(TCnMenuWizard(Sorted[i]).WizardName);
        SubItems.Add(TCnMenuWizard(Sorted[i]).GetIDStr);
        if TCnMenuWizard(Sorted[i]) is TCnSubMenuWizard then
          SubItems.Add(SCnSubMenuWizardName)
        else
          SubItems.Add(SCnMenuWizardName);
        Data := TCnMenuWizard(Sorted[i]);
      end;
    end;
    if Self.lvMenuWizards.Items.Count > 0 then
      Self.lvMenuWizards.Selected := Self.lvMenuWizards.TopItem;
  finally
    Self.lvMenuWizards.Items.EndUpdate;
  end;
end;

procedure TCnMenuSortForm.ReSortMenuWizards;
var
  i: Integer;
begin
  for i := 0 to Self.lvMenuWizards.Items.Count - 1 do
    TCnMenuWizard(Self.lvMenuWizards.Items[i].Data).MenuOrder := i;
end;

procedure TCnMenuSortForm.ResetActionExecute(Sender: TObject);
var
  i: Integer;
begin
  // �ָ� FMWizards �е�ԭʼ˳��
  Self.FMWizards.Clear;
  for i := 0 to CnWizardMgr.MenuWizardCount - 1 do
  begin
    Self.FMWizards.Add(CnWizardMgr.MenuWizards[i]);
    TCnMenuWizard(FMWizards[i]).MenuOrder := i;
  end;

  Self.InitMenusFromList(Self.FMWizards);
end;

procedure TCnMenuSortForm.ActionListUpdate(Action: TBasicAction;
  var Handled: Boolean);
begin
  Self.UpAction.Enabled := (Self.lvMenuWizards.SelCount = 1)
    and (Self.lvMenuWizards.Selected.Index > 0);
  Self.DownAction.Enabled := (Self.lvMenuWizards.SelCount = 1)
    and (Self.lvMenuWizards.Selected.Index < Self.lvMenuWizards.Items.Count - 1);
  Self.ResetAction.Enabled := True;
  Handled := True;
end;

procedure TCnMenuSortForm.btnHelpClick(Sender: TObject);
begin
  ShowFormHelp;
end;

function TCnMenuSortForm.GetHelpTopic: string;
begin
  Result := 'CnWizConfig';
end;

procedure TCnMenuSortForm.UpActionExecute(Sender: TObject);
var
  Idx: Integer;
begin
  // ѡ�е�����
  if UpAction.Enabled then
    with Self.lvMenuWizards do
    begin
      Idx := Selected.Index;
      ExchangeTwoListItems(Selected, Items[Selected.Index - 1]);
      Selected := Items[Idx - 1];
      ItemFocused := Selected;
      SetFocus;
    end;
end;

procedure TCnMenuSortForm.DownActionExecute(Sender: TObject);
var
  Idx: Integer;
begin
  // ѡ�е�����
  if DownAction.Enabled then
    with Self.lvMenuWizards do
    begin
      Idx := Selected.Index;
      ExchangeTwoListItems(Selected, Items[Selected.Index + 1]);
      Selected := Items[Idx + 1];
      ItemFocused := Selected;
      SetFocus;
    end;
end;

procedure TCnMenuSortForm.ExchangeTwoListItems(A, B: TListItem);
var
  i: Integer;
  S: String;
  P: Pointer;
begin
  if (A = nil) or (B = nil) then
    Exit;

  S := A.Caption;
  A.Caption := B.Caption;
  B.Caption := S;

  P := A.Data;
  A.Data := B.Data;
  B.Data := P;

  for i := 0 to A.SubItems.Count - 1 do
  begin
    S := A.SubItems[i];
    A.SubItems[i] := B.SubItems[i];
    B.SubItems[i] := S;
  end;
end;

procedure TCnMenuSortForm.FormCreate(Sender: TObject);
var
  i: Integer;
begin
  Self.PageControl.ActivePageIndex := 0;
  Self.FMWizards := TList.Create;
  for i := 0 to CnWizardMgr.MenuWizardCount - 1 do
    FMWizards.Add(CnWizardMgr.MenuWizards[i]);
  Self.lvWizardCreate.Items.Clear;
  for i := 0 to GetCnWizardClassCount - 1 do
  begin
    with Self.lvWizardCreate.Items.Add do
    begin
      Caption := TCnWizardClass(GetCnWizardClassByIndex(i)).WizardName;
      SubItems.Add(TCnWizardClass(GetCnWizardClassByIndex(i)).GetIDStr);
      SubItems.Add(GetCnWizardTypeNameFromClass(TCnWizardClass(GetCnWizardClassByIndex(i))));
      Checked := CnWizardMgr.WizardCanCreate[TCnWizardClass(GetCnWizardClassByIndex(i)).ClassName];
    end;
  end;
end;

procedure TCnMenuSortForm.FormDestroy(Sender: TObject);
begin
  Self.FMWizards.Free;
end;

procedure TCnMenuSortForm.InitWizardMenus;
begin
  // FMWizards����Ȼ�����
  SortListByMenuOrder(FMWizards);
  InitMenusFromList(FMWizards);
end;

procedure TCnMenuSortForm.lvMenuWizardsStartDrag(Sender: TObject;
  var DragObject: TDragObject);
begin
  Self.FDragIndex := Self.lvMenuWizards.Selected.Index;
end;

procedure TCnMenuSortForm.lvMenuWizardsDragOver(Sender, Source: TObject; X,
  Y: Integer; State: TDragState; var Accept: Boolean);
begin
  Accept := ((Source = lvMenuWizards) or (Source = Sender));
  // ����ListView
  if Y < 15 then
    lvMenuWizards.Perform(WM_VSCROLL, SB_LINEUP, 0)
  else
    if Y > lvMenuWizards.Height - 15 then
      lvMenuWizards.Perform(WM_VSCROLL, SB_LINEDOWN, 0);
  lvMenuWizards.Selected := lvMenuWizards.GetItemAt(X, Y);
end;

procedure TCnMenuSortForm.lvMenuWizardsDragDrop(Sender, Source: TObject; X,
  Y: Integer);
var
  L: TListItem;
begin
  if Sender = Source then
  begin
    if (Self.FDragIndex > 0) and (Self.lvMenuWizards.GetItemAt(X, Y) <> nil) then
    begin
      // ���뵽�ɿ��� Item ֮��
      L := Self.lvMenuWizards.Items[FDragIndex];
      (Self.lvMenuWizards.Items.Insert(Self.lvMenuWizards.GetItemAt(X, Y).Index)).Assign(L);
      Self.lvMenuWizards.Items.Delete(L.Index);

      Self.lvMenuWizards.Selected := Self.lvMenuWizards.GetItemAt(X, Y);
      Self.lvMenuWizards.ItemFocused := Self.lvMenuWizards.Selected;

      // ���Ի���ƣ����������±������ı䣬���ڽ������������ϵ����һ����Ҳ������
      if (Self.lvMenuWizards.Selected.Index = Self.lvMenuWizards.Items.Count - 1)
        or (Self.lvMenuWizards.Selected.Index - FDragIndex = 1) then
        if Self.lvMenuWizards.Items.Count > 1 then
          Self.ExchangeTwoListItems(Self.lvMenuWizards.Selected,
            Self.lvMenuWizards.Items[Self.lvMenuWizards.Selected.Index - 1]);
    end;
  end;
end;

procedure TCnMenuSortForm.lvMenuWizardsColumnClick(Sender: TObject;
  Column: TListColumn);
begin
  FColumnToSort := Column.Index;
  FSortFlag[FColumnToSort] := not FSortFlag[FColumnToSort];
  (Sender as TCustomListView).AlphaSort;
end;

procedure TCnMenuSortForm.lvMenuWizardsCompare(Sender: TObject; Item1,
  Item2: TListItem; Data: Integer; var Compare: Integer);
var
  ix: Integer;
begin
  if FColumnToSort = 0 then
    Compare := CompareText(Item1.Caption,Item2.Caption)
  else
  begin
   ix := FColumnToSort - 1;
   Compare := CompareText(Item1.SubItems[ix],Item2.SubItems[ix]);
  end;

  if not FSortFlag[FColumnToSort] then
    Compare := -Compare;
end;

procedure TCnMenuSortForm.SaveWizardCreateInfo;
var
  i: Integer;
begin
  for i := 0 to Self.lvWizardCreate.Items.Count - 1 do
    CnWizardMgr.WizardCanCreate[TCnWizardClass(GetCnWizardClassByIndex(i)).ClassName]
      := Self.lvWizardCreate.Items[i].Checked;
end;

procedure TCnMenuSortForm.actSelAllExecute(Sender: TObject);
var
  i: Integer;
begin
  for i := 0 to lvWizardCreate.Items.Count - 1 do
    lvWizardCreate.Items[i].Checked := True;
end;

procedure TCnMenuSortForm.actSelNoneExecute(Sender: TObject);
var
  i: Integer;
begin
  for i := 0 to lvWizardCreate.Items.Count - 1 do
    lvWizardCreate.Items[i].Checked := False;
end;

procedure TCnMenuSortForm.actSelReverseExecute(Sender: TObject);
var
  i: Integer;
begin
  for i := 0 to lvWizardCreate.Items.Count - 1 do
    lvWizardCreate.Items[i].Checked := not lvWizardCreate.Items[i].Checked;
end;

procedure TCnMenuSortForm.lvMenuWizardsKeyDown(Sender: TObject;
  var Key: Word; Shift: TShiftState);
begin
  // ���� Ctrl + Up �� Ctrl + Down ����ʵ����Ŀ�����ƶ�
  if ssCtrl in Shift then
    case Key of
      VK_UP:
      begin
        UpActionExecute(Sender);
        Key := 0;
      end;
      VK_DOWN:
      begin
        DownActionExecute(Sender);
        Key := 0;
      end;
    end;
end;

end.
