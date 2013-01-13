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

unit CnSelectMaskFrm;
{ |<PRE>
================================================================================
* ������ƣ�CnPack ��ִ���ļ���ϵ��������
* ��Ԫ���ƣ�Ŀ¼�ļ��б�ɾ����Ԫ
* ��Ԫ���ߣ�Chinbo��Shenloqi��
* ��    ע��
* ����ƽ̨��PWin2000Pro + Delphi 5.01
* ���ݲ��ԣ�PWin9X/2000/XP + Delphi 5/6/7 + C++Builder 5/6
* �� �� �����õ�Ԫ�е��ַ���֧�ֱ��ػ�����ʽ
* ��Ԫ��ʶ��$Id: CnSelectMaskFrm.pas 763 2011-02-07 14:18:23Z liuxiao@cnpack.org $
* �޸ļ�¼��2008.02.27 V1.0 V1.0
*               ������Ԫ
================================================================================
|</PRE>}

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, Menus, CnCommon;

type
  TCnSelectMaskForm = class(TForm)
    btnOK: TButton;
    btnCancel: TButton;
    edtMasks: TEdit;
    Label1: TLabel;
    chbDelDirs: TCheckBox;
    chbDelFiles: TCheckBox;
    chbCaseSensitive: TCheckBox;
    pmMasks: TPopupMenu;
    procedure edtMasksContextPopup(Sender: TObject; MousePos: TPoint;
      var Handled: Boolean);
    procedure FormCreate(Sender: TObject);
    procedure chbDelDirsClick(Sender: TObject);
    procedure edtMasksChange(Sender: TObject);
  private
    { Private declarations }
    FUIUpdating: Boolean;

    function GetCaseSensitive: Boolean;
    function GetDelDirs: Boolean;
    function GetDelFiles: Boolean;
    procedure SetCaseSensitive(const Value: Boolean);
    procedure SetDelDirs(const Value: Boolean);
    procedure SetDelFiles(const Value: Boolean);
    procedure SetMasks(const Value: string);
    function GetMasks: string;

    procedure UpdateControlsState;
    procedure SetEditMenu;
    procedure MenuItemClick(Sender: TObject);
  protected
    procedure DoCreate; override;
  public
    { Public declarations }
    property Masks: string read GetMasks write SetMasks;
    property CaseSensitive: Boolean read GetCaseSensitive write SetCaseSensitive;
    property DelDirs: Boolean read GetDelDirs write SetDelDirs;
    property DelFiles: Boolean read GetDelFiles write SetDelFiles;
  end;

function SelectMasks(var s: string;
  var bCaseSensitive, bDelDirs, bDelFiles: Boolean): Boolean;

implementation

uses
  CnBaseUtils, CnLangMgr;

{$R *.dfm}

function SelectMasks(var s: string;
  var bCaseSensitive, bDelDirs, bDelFiles: Boolean): Boolean;
begin
  with TCnSelectMaskForm.Create(Application) do
  try
    Masks := s;
    CaseSensitive := bCaseSensitive;
    DelDirs := bDelDirs;
    DelFiles := bDelFiles;
    ShowModal;
    Result := ModalResult = mrOk;
    if Result then
    begin
      s := Masks;
      bCaseSensitive := CaseSensitive;
      bDelDirs := DelDirs;
      bDelFiles := DelFiles;
    end;
  finally
    Free;
  end;
end;

procedure TCnSelectMaskForm.chbDelDirsClick(Sender: TObject);
begin
  UpdateControlsState;
end;

procedure TCnSelectMaskForm.DoCreate;
begin
  inherited;
  CnLanguageManager.TranslateForm(Self);
end;

procedure TCnSelectMaskForm.edtMasksChange(Sender: TObject);
begin
  UpdateControlsState;
end;

procedure TCnSelectMaskForm.edtMasksContextPopup(Sender: TObject; MousePos: TPoint;
  var Handled: Boolean);
var
  Pos: TPoint;
begin
  if pmMasks.Items.Count > 0 then
  begin
    Pos := edtMasks.ClientToScreen(MousePos);
    pmMasks.Popup(Pos.X, Pos.Y);
    Handled := True;
  end;
end;

procedure TCnSelectMaskForm.FormCreate(Sender: TObject);
begin
  SetEditMenu;
end;

function TCnSelectMaskForm.GetCaseSensitive: Boolean;
begin
  Result := chbCaseSensitive.Checked;
end;

function TCnSelectMaskForm.GetDelDirs: Boolean;
begin
  Result := chbDelDirs.Checked;
end;

function TCnSelectMaskForm.GetDelFiles: Boolean;
begin
  Result := chbDelFiles.Checked;
end;

function TCnSelectMaskForm.GetMasks: string;
begin
  Result := Trim(edtMasks.Text);
end;

procedure TCnSelectMaskForm.MenuItemClick(Sender: TObject);
begin
  if Sender is TMenuItem then
  begin
    if Masks = '' then
    begin
      Masks := TMenuItem(Sender).Caption;
    end
    else
    begin
      Masks := Masks + ';' + TMenuItem(Sender).Caption;
    end;
  end;
end;

procedure TCnSelectMaskForm.SetCaseSensitive(const Value: Boolean);
begin
  chbCaseSensitive.Checked := Value;
end;

procedure TCnSelectMaskForm.SetDelDirs(const Value: Boolean);
begin
  chbDelDirs.Checked := Value;
end;

procedure TCnSelectMaskForm.SetDelFiles(const Value: Boolean);
begin
  chbDelFiles.Checked := Value;
end;

procedure TCnSelectMaskForm.SetEditMenu;
var
  ss: TStrings;
  sFile: string;
  i: Integer;
  mi: TMenuItem;
begin
  ss := TStringList.Create;
  try
    sFile := MakePath(ExtractFileDir(ParamStr(0))) + 'Masks.txt';
    if FileExists(sFile) then
    begin
      StringsLoadFromFileWithSection(ss, sFile, 'DeleteMasks');
    end;
    if ss.Count = 0 then
    begin
      ss.Add('*.~*;*.dsk;*.tmp;*.bak;*.old;*.bad;*.stat;*.todo;*.upd');
      ss.Add('*.exe;*.config;*.bpl;*.dll;*.cpl;*.xex;*.jdbg;*.dcp;*.dpc;*.pce;*.ocx');
      ss.Add('*.txt;*.log;*.inf;*.reg;*.ini;*.int');
      ss.Add('*.obj;*.map;*.rsm;*.tds;*.o;*.lib');
    end;

    for i := 0 to ss.Count - 1 do
    begin
      if Trim(ss[i]) = '' then
      begin
        Continue;
      end;

      mi := TMenuItem.Create(pmMasks);
      mi.Caption := ss[i];
      mi.OnClick := MenuItemClick;
      pmMasks.Items.Add(mi);
    end;
  finally
    ss.Free;
  end;
end;

procedure TCnSelectMaskForm.SetMasks(const Value: string);
begin
  edtMasks.Text := Trim(Value);
end;

procedure TCnSelectMaskForm.UpdateControlsState;
begin
  if FUIUpdating then
  begin
    Exit;
  end;

  FUIUpdating := True;
  try
    btnOK.Enabled := (Masks <> '') and (chbDelDirs.Checked or chbDelFiles.Checked);
  finally
    FUIUpdating := False;
  end;
end;

end.
