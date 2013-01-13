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

unit CnTextPreviewFrm;
{ |<PRE>
================================================================================
* ������ƣ�CnPack ��ִ���ļ���ϵ��������
* ��Ԫ���ƣ�Ŀ¼�ļ��б�Ԥ����Ԫ
* ��Ԫ���ߣ�Chinbo��Shenloqi��
* ��    ע��
* ����ƽ̨��PWin2000Pro + Delphi 5.01
* ���ݲ��ԣ�PWin9X/2000/XP + Delphi 5/6/7 + C++Builder 5/6
* �� �� �����õ�Ԫ�е��ַ���֧�ֱ��ػ�����ʽ
* ��Ԫ��ʶ��$Id: CnTextPreviewFrm.pas 763 2011-02-07 14:18:23Z liuxiao@cnpack.org $
* �޸ļ�¼��2008.02.27 V1.0 V1.0
*               ������Ԫ
================================================================================
|</PRE>}

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls;

type
  TCnTextPreviewForm = class(TForm)
    btnOK: TButton;
    btnCancel: TButton;
    lsbPreview: TListBox;
    btnDelete: TButton;
    sd: TSaveDialog;
    procedure lsbPreviewKeyUp(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure lsbPreviewClick(Sender: TObject);
    procedure btnDeleteClick(Sender: TObject);
    procedure lsbPreviewKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
  private
    { Private declarations }
    FAllowDelete: Boolean;
    FUIUpdating: Boolean;
    FPerformUpdating: Boolean;

    procedure SetAllowDelete(const Value: Boolean);

    procedure UpdateControlsState;
    procedure DeleteSelected;
    procedure SaveSelection;
  protected
    procedure DoCreate; override;
  public
    { Public declarations }
    property AllowDelete: Boolean read FAllowDelete write SetAllowDelete;
  end;

function PreviewText(const s: string; const sCaption: string = ''): Boolean; overload;
function PreviewText(const ss: TStrings;
  const bAllowDelete: Boolean = False; const sCaption: string = ''): Boolean; overload;

implementation

uses
  CnLangMgr;

{$R *.dfm}

function PreviewText(const s: string; const sCaption: string = ''): Boolean;
begin
  Result := False;
  if Trim(s) = '' then
  begin
    Exit;
  end;

  with TCnTextPreviewForm.Create(Application) do
  try
    if Trim(sCaption) <> '' then
    begin
      Caption := sCaption;
    end;
    lsbPreview.Items.Text := s;
    ShowModal;
    Result := ModalResult = mrOk;
  finally
    Free;
  end;
end;

function PreviewText(const ss: TStrings;
  const bAllowDelete: Boolean = False; const sCaption: string = ''): Boolean;
begin
  Result := False;
  if (not Assigned(ss)) or (ss.Count = 0) then
  begin
    Exit;
  end;

  with TCnTextPreviewForm.Create(Application) do
  try
    if Trim(sCaption) <> '' then
    begin
      Caption := sCaption;
    end;
    lsbPreview.Items.Assign(ss);
    AllowDelete := bAllowDelete;
    ShowModal;
    Result := ModalResult = mrOk;
    if AllowDelete and Result then
    begin
      ss.Assign(lsbPreview.Items);
    end;
  finally
    Free;
  end;
end;

procedure TCnTextPreviewForm.btnDeleteClick(Sender: TObject);
begin
  Assert(AllowDelete);
  DeleteSelected;
  UpdateControlsState;
end;

procedure TCnTextPreviewForm.DeleteSelected;
var
  i, j: Integer;
begin
  i := lsbPreview.ItemIndex;

  for j := lsbPreview.Items.Count - 1 downto 0 do
  if lsbPreview.Selected[j] then
    lsbPreview.Items.Delete(j);

  if i > lsbPreview.Items.Count - 1 then
  begin
    i := lsbPreview.Items.Count - 1;
  end;
  if i < 0 then
  begin
    Exit;
  end;
  if lsbPreview.MultiSelect then
  begin
    lsbPreview.Selected[i] := True;
  end
  else
  begin
    lsbPreview.ItemIndex := i;
  end;
end;

procedure TCnTextPreviewForm.DoCreate;
begin
  inherited;
  CnLanguageManager.TranslateForm(Self);
end;

procedure TCnTextPreviewForm.lsbPreviewClick(Sender: TObject);
begin
  UpdateControlsState;
end;

procedure TCnTextPreviewForm.lsbPreviewKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
var
  I: Integer;
begin
  if AllowDelete and (Key = VK_DELETE) then
  begin
    DeleteSelected;
    FPerformUpdating := True;
  end;

  if [ssCtrl] = Shift then
  begin
    case Key of
      $41: begin
        for I := 0 to lsbPreview.Items.Count - 1 do
         lsbPreview.Selected[I] := True;
      end;
      $43, $53: begin
        if lsbPreview.SelCount > 0 then
        begin
          SaveSelection;
        end;
      end;
    end;
  end;
end;

procedure TCnTextPreviewForm.lsbPreviewKeyUp(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if FPerformUpdating then
  begin
    UpdateControlsState;
  end;
end;

procedure TCnTextPreviewForm.SaveSelection;
var
  ss: TStringList;
  i: Integer;
begin
  sd.InitialDir := ExtractFilePath(ParamStr(0));
  if sd.Execute then
  begin
    ss := TStringList.Create;
    try
      for i := 0 to lsbPreview.Items.Count - 1 do
      begin
        if lsbPreview.Selected[i] then
        begin
          ss.Add(lsbPreview.Items[i]);
        end;
      end;  
      ss.SaveToFile(sd.FileName);
    finally
      ss.Free;
    end;
  end;
end;

procedure TCnTextPreviewForm.SetAllowDelete(const Value: Boolean);
begin
  FAllowDelete := Value;
  UpdateControlsState;
end;

procedure TCnTextPreviewForm.UpdateControlsState;
begin
  if FUIUpdating then
  begin
    Exit;
  end;

  FUIUpdating := True;
  try
    btnDelete.Visible := AllowDelete;
    if lsbPreview.MultiSelect then
    begin
      btnDelete.Enabled := AllowDelete and (lsbPreview.SelCount > 0);
    end
    else
    begin
      btnDelete.Enabled := AllowDelete and (lsbPreview.ItemIndex >= 0);
    end;
    btnOK.Enabled := lsbPreview.Items.Count > 0;
  finally
    FUIUpdating := False;
    FPerformUpdating := False;
  end;
end;

end.
