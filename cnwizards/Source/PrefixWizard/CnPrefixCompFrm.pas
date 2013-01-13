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

unit CnPrefixCompFrm;
{* |<PRE>
================================================================================
* ������ƣ�CnPack IDE ר�Ұ�
* ��Ԫ���ƣ����ǰ׺ר������б��嵥Ԫ
* ��Ԫ���ߣ��ܾ��� (zjy@cnpack.org)
* ��    ע�����ǰ׺ר������б��嵥Ԫ
* ����ƽ̨��PWin2000Pro + Delphi 5.01
* ���ݲ��ԣ�PWin9X/2000/XP + Delphi 5/6/7 + C++Builder 5/6
* �� �� �����õ�Ԫ�е��ַ��������ϱ��ػ�����ʽ
* ��Ԫ��ʶ��$Id: CnPrefixCompFrm.pas 763 2011-02-07 14:18:23Z liuxiao@cnpack.org $
* �޸ļ�¼��2003.04.28 V1.0
*               ������Ԫ
================================================================================
|</PRE>}

interface

{$I CnWizards.inc}

{$IFDEF CNWIZARDS_CNPREFIXWIZARD}

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  ComCtrls, StdCtrls, Contnrs, ToolsAPI, CnCommon, CnPrefixList, CnWizUtils,
  CnWizConsts, CnWizMultiLang, IniFiles;

type

{ TCnPrefixCompForm }

  TCnPrefixCompForm = class(TCnTranslateForm)
    gbList: TGroupBox;
    ListView: TListView;
    lbl1: TLabel;
    edtNewName: TEdit;
    btnModify: TButton;
    btnOK: TButton;
    btnCancel: TButton;
    btnHelp: TButton;
    procedure edtNewNameKeyPress(Sender: TObject; var Key: Char);
    procedure FormShow(Sender: TObject);
    procedure btnModifyClick(Sender: TObject);
    procedure btnOKClick(Sender: TObject);
    procedure btnHelpClick(Sender: TObject);
    procedure ListViewColumnClick(Sender: TObject; Column: TListColumn);
    procedure ListViewCompare(Sender: TObject; Item1, Item2: TListItem;
      Data: Integer; var Compare: Integer);
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
    procedure edtNewNameEnter(Sender: TObject);
    procedure edtNewNameKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure ListViewSelectItem(Sender: TObject; Item: TListItem;
      Selected: Boolean);
  private
    { Private declarations }
    FList: TCompList;
    FSortIndex: Integer;
    FSortDown: Boolean;
    procedure SetListToListView;
    procedure UpdateListToListView(Sender: TObject);
    procedure GetListFromListView;
    procedure UpdateNameEdit;
  protected
    function GetHelpTopic: string; override;
  public
    { Public declarations }
  end;

function ShowPrefixCompForm(List: TCompList; IniFile: TCustomIniFile;
  var UpdateTrigger: TNotifyEvent): Boolean;

{$ENDIF CNWIZARDS_CNPREFIXWIZARD}

implementation

{$IFDEF CNWIZARDS_CNPREFIXWIZARD}

{$R *.DFM}

uses
  CnWizManager, CnPrefixWizard;

const
  aSection = 'CnPrefixCompForm';
  csWidth = 'Width';
  csHeight = 'Height';
  csListViewWidth = 'ListViewWidth';

function ShowPrefixCompForm(List: TCompList; IniFile: TCustomIniFile;
  var UpdateTrigger: TNotifyEvent): Boolean;
var
  Frm: TCnPrefixCompForm;
begin
  Frm := TCnPrefixCompForm.Create(nil);
  with Frm, IniFile do
  try
    FList := List;
    Width := ReadInteger(aSection, csWidth, Width);
    Height := ReadInteger(aSection, csHeight, Height);
    CenterForm(Frm);
    SetListViewWidthString(ListView, ReadString(aSection, csListViewWidth, ''));
    UpdateTrigger := UpdateListToListView;
    Result := ShowModal = mrOk;
    
    WriteInteger(aSection, csWidth, Width);
    WriteInteger(aSection, csHeight, Height);
    WriteString(aSection, csListViewWidth, GetListViewWidthString(ListView));
  finally
    Frm.Free;
  end;
end;

{ TCnPrefixCompForm }

procedure TCnPrefixCompForm.FormCloseQuery(Sender: TObject;
  var CanClose: Boolean);
begin
  if ModalResult = mrOK then
    if not QueryDlg(SCnPrefixAskToProcess) then
      CanClose := False;
end;

procedure TCnPrefixCompForm.FormShow(Sender: TObject);
begin
  FSortIndex := 0;
  FSortDown := False;
  SetListToListView;
  if ListView.Items.Count > 0 then
  begin
    // �˴���Ҫ�ȷ�һ�� VK_DOWN�������û��� Edit �е�һ�ΰ� Down ��Ч
    SendMessage(ListView.Handle, WM_KEYDOWN, VK_DOWN, 0);
    ListView.Selected := ListView.Items[0];
  end;
  edtNewName.SetFocus;
end;

function TCnPrefixCompForm.GetHelpTopic: string;
begin
  Result := 'CnPrefixCompForm';
end;

procedure TCnPrefixCompForm.SetListToListView;
var
  i: Integer;
begin
  ListView.Items.BeginUpdate;
  try
    ListView.Items.Clear;
    for i := 0 to FList.Count - 1 do
    begin
      with ListView.Items.Add do
      begin
        Checked := FList[i].Active;
        Caption := FList[i].ProjectName;
        SubItems.Add(ExtractFileName(FList[i].FormEditor.FileName));
        SubItems.Add(FList[i].OldName);
        SubItems.Add(FList[i].Component.ClassName);
        SubItems.Add(CnGetComponentText(FList[i].Component));
        SubItems.Add(FList[i].Prefix);
        SubItems.Add(FList[i].NewName);
        Data := FList[i];
      end;
    end;
  finally
    ListView.Items.EndUpdate;
  end;
end;

procedure TCnPrefixCompForm.GetListFromListView;
var
  i: Integer;
begin
  for i := 0 to ListView.Items.Count - 1 do
    with TCompItem(ListView.Items[i].Data) do
    begin
      NewName := ListView.Items[i].SubItems[5];
      Active := (NewName <> '') and ListView.Items[i].Checked;
    end;
end;

procedure TCnPrefixCompForm.UpdateNameEdit;
begin
  if ListView.Selected <> nil then
  begin
    edtNewName.Text := ListView.Selected.SubItems[5];
    edtNewName.Enabled := True;
    btnModify.Enabled := True;
  end
  else
  begin
    edtNewName.Text := '';
    edtNewName.Enabled := False;
    btnModify.Enabled := False;
  end;
end;

procedure TCnPrefixCompForm.ListViewSelectItem(Sender: TObject;
  Item: TListItem; Selected: Boolean);
begin
  UpdateNameEdit;
end;

procedure TCnPrefixCompForm.btnModifyClick(Sender: TObject);
begin
  if ListView.Selected <> nil then
  begin
    if (edtNewName.Text = '') or IsValidIdent(edtNewName.Text) then
      ListView.Selected.SubItems[5] := edtNewName.Text
    else
      ErrorDlg(SCnPrefixNameError);
  end;
end;

procedure TCnPrefixCompForm.ListViewColumnClick(Sender: TObject;
  Column: TListColumn);
begin
  if FSortIndex = Column.Index then
    FSortDown := not FSortDown
  else
    FSortIndex := Column.Index;
  ListView.CustomSort(nil, 0);
end;

procedure TCnPrefixCompForm.ListViewCompare(Sender: TObject; Item1,
  Item2: TListItem; Data: Integer; var Compare: Integer);
begin
  if FSortIndex <= 0 then
    Compare := CompareText(Item1.Caption, Item2.Caption)
  else
    Compare := CompareText(Item1.SubItems[FSortIndex - 1], Item2.SubItems[FSortIndex - 1]);
  if FSortDown then
    Compare := -Compare;
end;

procedure TCnPrefixCompForm.edtNewNameEnter(Sender: TObject);
var
  Prefix: string;
begin
  if (ListView.Selected <> nil) and (edtNewName.Text <> '') then
  begin
    Prefix := TCompItem(ListView.Selected.Data).Prefix;
    if (Prefix <> '') and (AnsiPos(Prefix, edtNewName.Text) = 1) then
    begin
      edtNewName.SelStart := Length(Prefix);
      edtNewName.SelLength := Length(edtNewName.Text) - Length(Prefix);
    end
    else
      edtNewName.SelectAll;
  end;
end;

procedure TCnPrefixCompForm.edtNewNameKeyPress(Sender: TObject;
  var Key: Char);
const
  Chars = ['A'..'Z', 'a'..'z', '_', '0'..'9', #08];
  EditChars = [#3, #22, #24, #26];  // Ctrl+C/V/X/Z
begin
  if Key = #13 then
  begin
    btnModifyClick(nil);
    if (edtNewName.Text = '') or IsValidIdent(edtNewName.Text) then
      if ListView.Selected.Index < ListView.Items.Count - 1 then
      begin
        ListView.Selected := ListView.Items[ListView.Selected.Index + 1];
        edtNewName.SetFocus;
      end
      else
        btnOK.SetFocus;
    Key := #0;
  end
  else if not CharInSet(Key, Chars + EditChars) and not IsValidIdent('A' + Key) then
    Key := #0;
end;

procedure TCnPrefixCompForm.btnOKClick(Sender: TObject);
begin
  GetListFromListView;
  ModalResult := mrOk;
end;

procedure TCnPrefixCompForm.btnHelpClick(Sender: TObject);
begin
  ShowFormHelp;
end;

procedure TCnPrefixCompForm.edtNewNameKeyDown(Sender: TObject;
  var Key: Word; Shift: TShiftState);
begin
  if Key in [VK_UP, VK_DOWN, VK_HOME, VK_END, VK_PRIOR, VK_NEXT] then
  begin
    SendMessage(ListView.Handle, WM_KEYDOWN, Key, 0);
    Key := 0;
    edtNewName.SetFocus;
  end;
end;

procedure TCnPrefixCompForm.UpdateListToListView(Sender: TObject);
var
  I: Integer;
  RenameList: TList;
  FormEditor: IOTAFormEditor;
  Wizard: TCnPrefixWizard;
  ProjectName: string;
begin
  if Sender <> nil then
  begin
    // ���Sender��Ϊ�գ�˵���Ǳ������ĵ��õģ�Ϊһ RenameList��
    // �ڴ��� RenameList ���� FList
    RenameList := Sender as TList;
    FormEditor := CnOtaGetCurrentFormEditor;
    Wizard := TCnPrefixWizard(CnWizardMgr.WizardByClass(TCnPrefixWizard));
    if Wizard = nil then
      Exit;

    // ȡ������
    if Assigned(FormEditor.Module) and (FormEditor.Module.OwnerCount > 0) then
      ProjectName := ExtractFileName(FormEditor.Module.Owners[0].FileName)
    else
      ProjectName := '';

    for i := 0 to RenameList.Count - 1 do
    begin
      // ֻ�е�ǰ�����ϴ��ڵ�����Ŵ���
      if FList.IndexOfComponent(FormEditor, TComponent(RenameList[i])) < 0 then
        if Assigned(FormEditor.GetComponentFromHandle(RenameList[i])) then
          Wizard.AddCompToList(ProjectName, FormEditor, TComponent(RenameList[i]), FList);
    end;

    SetListToListView;
    
    if ListView.Items.Count > 0 then
    begin
      // �˴���Ҫ�ȷ�һ�� VK_DOWN�������û��� Edit �е�һ�ΰ� Down ��Ч
      SendMessage(ListView.Handle, WM_KEYDOWN, VK_DOWN, 0);
      ListView.Selected := ListView.Items[0];
    end;
    edtNewName.SetFocus;
  end;
end;

{$ENDIF CNWIZARDS_CNPREFIXWIZARD}

end.
