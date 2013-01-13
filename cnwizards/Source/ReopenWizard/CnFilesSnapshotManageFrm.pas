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

unit CnFilesSnapshotManageFrm;
{ |<PRE>
================================================================================
* ������ƣ�CnPack IDE ר�Ұ�
* ��Ԫ���ƣ������鵥Ԫ�б�Ԫ
* ��Ԫ���ߣ��ܺ㣨beta�� xbeta@tom.com
* ��    ע��
* ����ƽ̨��PWin2000Pro + Delphi 7
* ���ݲ��ԣ�P2000Pro + Delphi 6/7
* �� �� �����õ�Ԫ�е��ַ��������ϱ��ػ�����ʽ
* ��Ԫ��ʶ��$Id: CnFilesSnapshotManageFrm.pas 763 2011-02-07 14:18:23Z liuxiao@cnpack.org $
* �޸ļ�¼��2007.08.02 V1.2
*               beta �ļ��б��Ϊ�� virtual ��ʽ���ṩ�� D5 �ļ���
*           2007.08.01 V1.1
*               beta �ļ��б�֧�������ק����ݼ������߰�ť�ȷ�ʽ�ı�˳��
*               �ϲ���ӿ��մ�����ʵ�ֹ��ܴ��빲�ã��ļ��б�֧�ֶ�ѡ
*               ��������ļ������༭�ļ����ȣ������Ż������������ع�
*           2004.04.23 V1.0
*               ������Ԫ
================================================================================
|</PRE>}

interface

{$I CnWizards.inc}

{$IFDEF CNWIZARDS_CNFILESSNAPSHOTWIZARD}

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, CnWizMultiLang, CnCommon, CnWizConsts, CheckLst,
  ImgList, ActnList;

type

//==============================================================================
// ���չ�����
//==============================================================================

{ TCnProjectFilesSnapshotManageForm }

  TCnProjectFilesSnapshotManageForm = class(TCnTranslateForm)
    cbbSnapshots: TComboBox;
    lblSnapshots: TLabel;
    btnDelete: TButton;
    btnHelp: TButton;
    btnRemove: TButton;
    lstFiles: TListBox;
    btnOk: TButton;
    btnCancel: TButton;
    lblFiles: TLabel;
    ilFormIcons: TImageList;
    btnMoveUp: TButton;
    btnMoveDown: TButton;
    actlstFLS: TActionList;
    actSnapshotDelete: TAction;
    actFileMoveUp: TAction;
    actFileMoveDown: TAction;
    actFileRemove: TAction;
    actFileAdd: TAction;
    actFileEdit: TAction;
    actFormOk: TAction;
    dlgOpen: TOpenDialog;
    btnFileRemove: TButton;
    btnFileMoveDown: TButton;
    procedure actFileAddExecute(Sender: TObject);
    procedure actFileEditExecute(Sender: TObject);
    procedure actFileMoveDownExecute(Sender: TObject);
    procedure actFileMoveUpExecute(Sender: TObject);
    procedure actFileRemoveExecute(Sender: TObject);
    procedure actFormOkExecute(Sender: TObject);
    procedure actlstFLSUpdate(Action: TBasicAction; var Handled: Boolean);
    procedure actSnapshotDeleteExecute(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure btnHelpClick(Sender: TObject);
    procedure cbbSnapshotsChange(Sender: TObject);
    procedure lstFilesDblClick(Sender: TObject);
    procedure lstFilesDragDrop(Sender, Source: TObject; X, Y: Integer);
    procedure lstFilesDragOver(Sender, Source: TObject; X, Y: Integer; State:
      TDragState; var Accept: Boolean);
    procedure lstFilesKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
  private
    FFiles: TStrings;
    FManaging: Boolean;
    FSnapshots: TStrings;
    function lstFilesItemFmt(const AFileName: string): string;
    procedure lstFilesRefresh(AItem: Integer = -1);
    procedure lstFilesSetCount(ACount: Integer);
    function GetFirstSelectedIndex: Integer;
    function GetLastSelectedIndex: Integer;
    function GetUnselectedItemCount(AFrom, ATo: Integer): Integer;
    procedure MoveItems(Distance: Integer);
  protected
    function GetHelpTopic: string; override;
  public
    { Public declarations }
  end;

// ��ʾ����ļ����ս��棬���û�ȡ���򷵻ؿ��ַ���
function AddFilesSnapshot(Names, Files: TStrings): string;

// ��ʾ�����ļ����ս��棬���û�ȡ���޸��򷵻� False
function ManageFilesSnapshot(Snapshots: TStrings): Boolean;

{$ENDIF CNWIZARDS_CNFILESSNAPSHOTWIZARD}

implementation

{$IFDEF CNWIZARDS_CNFILESSNAPSHOTWIZARD}

{$R *.dfm}

function AddFilesSnapshot(Names, Files: TStrings): string;
begin
  Result := '';
  with TCnProjectFilesSnapshotManageForm.Create(nil) do
  try
    cbbSnapshots.Items.Assign(Names);
    FFiles := Files;
    lstFilesSetCount(FFiles.Count);

    if ShowModal = mrOK then
      Result := Trim(cbbSnapshots.Text);
  finally
    Free;
  end;
end;

function ManageFilesSnapshot(Snapshots: TStrings): Boolean;
begin
  with TCnProjectFilesSnapshotManageForm.Create(nil) do
  try
    FManaging := True;
    FSnapshots := Snapshots;
    cbbSnapshots.Items.Assign(Snapshots);
    if Snapshots.Count > 0 then
    begin
      cbbSnapshots.ItemIndex := 0;
      cbbSnapshotsChange(nil);
    end;

    Result := ShowModal = mrOk;
  finally
    Free;
  end;
end;

//==============================================================================
// ���չ�����
//==============================================================================

{ TCnProjectFilesSnapshotManageForm }

procedure TCnProjectFilesSnapshotManageForm.FormShow(Sender: TObject);
begin
  if FManaging then
  begin // manage
    Caption := SCnFilesSnapshotManageFrmCaptionManage;
    ilFormIcons.GetIcon(0, Icon);
    lblSnapshots.Caption := SCnFilesSnapshotManageFrmLblSnapshotsCaptionManage;
    cbbSnapshots.Style := csDropDownList;
  end else
  begin // add
    Caption := SCnFilesSnapshotManageFrmCaptionAdd;
    ilFormIcons.GetIcon(1, Icon);
    lblSnapshots.Caption := SCnFilesSnapshotManageFrmLblSnapshotsCaptionAdd;
    cbbSnapshots.Style := csDropDown;
    cbbSnapshots.Width := cbbSnapshots.Width + 5 + btnDelete.Width;
    actSnapshotDelete.Visible := False;
  end;
end;

procedure TCnProjectFilesSnapshotManageForm.actFileAddExecute(Sender: TObject);
begin
  if not Assigned(FFiles) then Exit;

  with dlgOpen do
  begin
    Options := Options + [ofAllowMultiSelect];
    if Execute then
    begin
      FFiles.AddStrings(Files);
      lstFilesSetCount(FFiles.Count);
    end;
  end;
end;

procedure TCnProjectFilesSnapshotManageForm.actFileEditExecute(Sender: TObject);
begin
  if not Assigned(FFiles) or (lstFiles.ItemIndex < 0) then Exit;

  with dlgOpen do
  begin
    Options := Options - [ofAllowMultiSelect];
    FileName := FFiles[lstFiles.ItemIndex];
    if Execute then
      with lstFiles do
      begin
        FFiles[ItemIndex] := FileName;
        lstFilesRefresh(ItemIndex);
      end;
  end;
end;

procedure TCnProjectFilesSnapshotManageForm.actFileMoveDownExecute(Sender:
  TObject);
begin
  if GetLastSelectedIndex < lstFiles.Items.Count - 1 then MoveItems(1);
end;

procedure TCnProjectFilesSnapshotManageForm.actFileMoveUpExecute(Sender:
  TObject);
begin
  if GetFirstSelectedIndex > 0 then MoveItems(-1);
end;

procedure TCnProjectFilesSnapshotManageForm.actFileRemoveExecute(Sender:
  TObject);
var
  i: Integer;
begin
  with lstFiles do
  begin
    for i := Items.Count - 1 downto 0 do
      if Selected[i] then
        FFiles.Delete(i);
    lstFilesSetCount(FFiles.Count);
  end;
end;

procedure TCnProjectFilesSnapshotManageForm.actFormOkExecute(Sender: TObject);
begin
  ModalResult := mrOk;
end;

procedure TCnProjectFilesSnapshotManageForm.actlstFLSUpdate(Action:
  TBasicAction; var Handled: Boolean);
var
  SelCount: Integer;
begin
  SelCount := lstFiles.SelCount;
  actSnapshotDelete.Enabled := FManaging and (cbbSnapshots.ItemIndex >= 0);
  actFileMoveUp.Enabled := SelCount > 0;
  actFileMoveDown.Enabled := SelCount > 0;
  actFileRemove.Enabled := SelCount > 0;
  actFileAdd.Enabled := not FManaging or (cbbSnapshots.ItemIndex >= 0);
  actFileEdit.Enabled := SelCount = 1;
  actFormOk.Enabled := FManaging or (Trim(cbbSnapshots.Text) <> '');
end;

procedure TCnProjectFilesSnapshotManageForm.actSnapshotDeleteExecute(Sender:
  TObject);
var
  Index: Integer;
begin
  Index := cbbSnapshots.ItemIndex;
  if (Index >= 0) and (Index < FSnapshots.Count) then
  begin
    FSnapshots.Objects[Index].Free;
    FSnapshots.Delete(Index);
    cbbSnapshots.Items.Delete(Index);
  end
  else
    Exit;

  if FSnapshots.Count > 0 then
    cbbSnapshots.ItemIndex := 0
  else
    cbbSnapshots.Clear;
  cbbSnapshotsChange(cbbSnapshots);
end;

procedure TCnProjectFilesSnapshotManageForm.cbbSnapshotsChange(Sender: TObject);
var
  Index: Integer;
begin
  if FManaging then
  begin
    Index := cbbSnapshots.ItemIndex;
    if (Index >= 0) and (Index < FSnapshots.Count) then
    begin
      FFiles := TStrings(FSnapshots.Objects[Index]);
      lstFilesSetCount(FFiles.Count);
    end else
    begin
      FFiles := nil;
      lstFilesSetCount(0);
    end;
  end;
end;

procedure TCnProjectFilesSnapshotManageForm.btnHelpClick(Sender: TObject);
begin
  ShowFormHelp;
end;

function TCnProjectFilesSnapshotManageForm.GetFirstSelectedIndex: Integer;
begin
  with lstFiles do
    for Result := 0 to Items.Count - 1 do
      if Selected[Result] then
        Exit;
  Result := -1;
end;

function TCnProjectFilesSnapshotManageForm.GetLastSelectedIndex: Integer;
begin
  with lstFiles do
    for Result := Items.Count - 1 downto 0 do
      if Selected[Result] then
        Exit;
  Result := -1;
end;

function TCnProjectFilesSnapshotManageForm.GetHelpTopic: string;
begin
  Result := 'CnProjectExtFileSnapshot';
end;

function TCnProjectFilesSnapshotManageForm.GetUnselectedItemCount(AFrom, ATo:
  Integer): Integer;
var
  i: Integer;
begin
  Result := 0;
  with lstFiles do
    if AFrom <= ATo then
      for i := AFrom to ATo do
        if not Selected[i] then
          Inc(Result)
        else
          // nothing
    else
      for i := AFrom downto ATo do
        if not Selected[i] then
          Dec(Result)
        else
          // nothing
end;

procedure TCnProjectFilesSnapshotManageForm.lstFilesDblClick(Sender: TObject);
begin
  actFileEdit.Execute;
end;

procedure TCnProjectFilesSnapshotManageForm.lstFilesDragDrop(Sender, Source:
  TObject; X, Y: Integer);
var
  NewIndex: Integer;
begin
  with lstFiles do
  begin
    if X < 0 then X := 0;
    if X > ClientWidth then X := ClientWidth;
    if Y < 0 then Y := 0;
    if Y > ClientHeight then Y := ClientHeight;
    NewIndex := ItemAtPos(Point(X, Y), True);
    if NewIndex < 0 then NewIndex := Items.Count - 1;

    if Selected[NewIndex] then Exit;

    MoveItems(GetUnselectedItemCount(GetFirstSelectedIndex, NewIndex));
  end;
end;

procedure TCnProjectFilesSnapshotManageForm.lstFilesDragOver(Sender, Source:
  TObject; X, Y: Integer; State: TDragState; var Accept: Boolean);
begin
  Accept := Sender = Source;
end;

function TCnProjectFilesSnapshotManageForm.lstFilesItemFmt(
  const AFileName: string): string;
begin
  Result :=
    Format('%s (%s)', [ExtractFileName(AFileName), ExtractFileDir(AFileName)]);
end;

procedure TCnProjectFilesSnapshotManageForm.lstFilesKeyDown(Sender: TObject;
  var Key: Word; Shift: TShiftState);
var
  I: Integer;
begin
  if Key = VK_DELETE then
  begin
    Key := 0;
    actFileRemove.Execute;
  end else
  if (Key = Ord('A')) and (ssCtrl in Shift) then
  begin
    Key := 0;
    if lstFiles.MultiSelect then
      for I := 0 to lstFiles.Items.Count - 1 do
        lstFiles.Selected[I] := True;
  end;
end;

procedure TCnProjectFilesSnapshotManageForm.lstFilesRefresh(AItem: Integer = -1);

  procedure HandleItem(Index: Integer);
  var
    SavedSel: Boolean;
  begin
    with lstFiles do
    begin
      SavedSel := Selected[Index];
      Items[Index] := lstFilesItemFmt(FFiles[Index]);
      Selected[Index] := SavedSel;
    end;
  end;

var
  i: Integer;
begin
  Assert(lstFiles.Items.Count = FFiles.Count);

  if AItem >= 0 then
    HandleItem(AItem)
  else
    for i := 0 to FFiles.Count - 1 do
      HandleItem(i);
end;

procedure TCnProjectFilesSnapshotManageForm.lstFilesSetCount(
  ACount: Integer);
var
  i: Integer;
begin
  with lstFiles do
  begin
    Clear;
    for i := 0 to ACount - 1 do
      Items.AddObject(lstFilesItemFmt(FFiles[i]), nil);
  end;
end;

procedure TCnProjectFilesSnapshotManageForm.MoveItems(Distance: Integer);

  procedure HandleItem(Index: Integer);
  var
    NewIndex: Integer;
  begin
    with lstFiles do
      if Selected[Index] then
      begin
        NewIndex := Index + Distance;
        if NewIndex > Items.Count - 1 then
          NewIndex := Items.Count - 1;
        Selected[Index] := False;
        Selected[NewIndex] := True;
        FFiles.Move(Index, NewIndex);
      end;
  end;

var
  i: Integer;
begin
  with lstFiles do
  begin
    Items.BeginUpdate;
    try
      if Distance > 0 then
        for i := Items.Count - 1 downto 0 do
          HandleItem(i)
      else
        for i := 0 to Items.Count - 1 do
          HandleItem(i);
      lstFilesRefresh;
    finally
      Items.EndUpdate;
    end;
  end;
end;

{$ENDIF CNWIZARDS_CNFILESSNAPSHOTWIZARD}
end.
