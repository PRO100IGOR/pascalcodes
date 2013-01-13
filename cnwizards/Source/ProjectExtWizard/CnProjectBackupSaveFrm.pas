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

unit CnProjectBackupSaveFrm;
{ |<PRE>
================================================================================
* ������ƣ�CnPack IDE ר�Ұ�
* ��Ԫ���ƣ���Ŀ���ݵ�Ԫ
* ��Ԫ���ߣ�LiuXiao (liuxiao@cnpack.org)
* ��    ע��
* ����ƽ̨��WinXP + Delphi 5.0
* ���ݲ��ԣ�PWin9X/2000/XP + Delphi 5/6/7 + C++Builder 5/6
* �� �� �����õ�Ԫ�е��ַ��������ϱ��ػ�����ʽ
* ��Ԫ��ʶ��$Id: CnProjectBackupSaveFrm.pas 763 2011-02-07 14:18:23Z liuxiao@cnpack.org $
* �޸ļ�¼��2008.06.20 V1.1 by LiuXiao
*               ���뱸�ݺ���������Ļ���
*           2005.10.16 V1.0 by LiuXiao
*               ������Ԫ��ʵ�ֹ���
================================================================================
|</PRE>}

interface

{$I CnWizards.inc}

{$IFDEF CNWIZARDS_CNPROJECTEXTWIZARD}

{$IFDEF SUPPORT_PRJ_BACKUP}

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  CnCommon, CnWizConsts, CnWizMultiLang, StdCtrls, ExtCtrls, ComCtrls;

type
  TCnProjectBackupSaveForm = class(TCnTranslateForm)
    btnOK: TButton;
    btnCancel: TButton;
    btnHelp: TButton;
    dlgSave: TSaveDialog;
    pgc1: TPageControl;
    ts1: TTabSheet;
    ts2: TTabSheet;
    grp2: TGroupBox;
    chkUseExternal: TCheckBox;
    grpSave: TGroupBox;
    lblFile: TLabel;
    lblTime: TLabel;
    btnSelect: TButton;
    edtFile: TEdit;
    cbbTimeFormat: TComboBox;
    grp1: TGroupBox;
    lblSecond: TLabel;
    lblPass: TLabel;
    chkRememberPass: TCheckBox;
    edtSecond: TEdit;
    edtPass: TEdit;
    chkPassword: TCheckBox;
    chkRemovePath: TCheckBox;
    lblPredefine: TLabel;
    cbbPredefine: TComboBox;
    lblCompressor: TLabel;
    edtCompressor: TEdit;
    btnCompressor: TButton;
    lblCmd: TLabel;
    mmoCmd: TMemo;
    dlgOpenCompressor: TOpenDialog;
    tsAfter: TTabSheet;
    grpAfter: TGroupBox;
    lblPreParams: TLabel;
    lblAfterCmd: TLabel;
    lblPreCmd: TLabel;
    chkExecAfter: TCheckBox;
    cbbParams: TComboBox;
    edtAfterCmd: TEdit;
    btnAfterCmd: TButton;
    mmoAfterCmd: TMemo;
    procedure btnSelectClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
    procedure chkPasswordClick(Sender: TObject);
    procedure btnHelpClick(Sender: TObject);
    procedure edtFileChange(Sender: TObject);
    procedure cbbTimeFormatChange(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure cbbPredefineChange(Sender: TObject);
    procedure btnCompressorClick(Sender: TObject);
    procedure chkUseExternalClick(Sender: TObject);
    procedure btnAfterCmdClick(Sender: TObject);
    procedure cbbParamsChange(Sender: TObject);
  private
    FConfirmed: Boolean;
    FSavePath: string;
    FCurrentName: string;
    FExt: string;
    { Private declarations }
    function GetPassword: string;
    function GetRemovePath: Boolean;
    function GetUsePassword: Boolean;
    procedure SetPassword(const Value: string);
    procedure SetUsePassword(const Value: Boolean);
    function GetSaveFileName: string;
    procedure SetRemovePath(const Value: Boolean);
    procedure SetSaveFileName(const Value: string);
    function GetRememberPass: Boolean;
    procedure SetRememberPass(const Value: Boolean);
    function GetCompressCmd: string;
    function GetCompressor: string;
    function GetUseExternal: Boolean;
    procedure SetCompressCmd(const Value: string);
    procedure SetCompressor(const Value: string);
    procedure SetUseExternal(const Value: Boolean);
    function GetAfterCmd: string;
    procedure SetAfterCmd(const Value: string);
    function GetExecAfter: Boolean;
    procedure SetExecAfter(const Value: Boolean);
    function GetExecAfterFile: string;
    procedure SetExecAfterFile(const Value: string);
  protected
    function GetHelpTopic: string; override;
    procedure UpdateContent;
  public
    { Public declarations }
    function GetExtFromCompressor(Compressor: string): string;

    property UsePassword: Boolean read GetUsePassword write SetUsePassword;
    property Password: string read GetPassword write SetPassword;
    property RemovePath: Boolean read GetRemovePath write SetRemovePath;
    property RememberPass: Boolean read GetRememberPass write SetRememberPass;
    property SaveFileName: string read GetSaveFileName write SetSaveFileName;
    property Confirmed: Boolean read FConfirmed write FConfirmed;
    property UseExternal: Boolean read GetUseExternal write SetUseExternal;
    property Compressor: string read GetCompressor write SetCompressor;
    property CompressCmd: string read GetCompressCmd write SetCompressCmd;

    property ExecAfter: Boolean read GetExecAfter write SetExecAfter;
    property ExecAfterFile: string read GetExecAfterFile write SetExecAfterFile;
    property AfterCmd: string read GetAfterCmd write SetAfterCmd;

    property SavePath: string read FSavePath write FSavePath;
    property CurrentName: string read FCurrentName write FCurrentName;
  end;

{$ENDIF SUPPORT_PRJ_BACKUP}

{$ENDIF CNWIZARDS_CNPROJECTEXTWIZARD}

implementation

{$IFDEF CNWIZARDS_CNPROJECTEXTWIZARD}

{$IFDEF SUPPORT_PRJ_BACKUP}

{$R *.DFM}

type
  TCnCompressPredefined = (cpRAR, cpRARRp, {cp7zip, }cp7zipRp, cpZip);

const
  SCnCompressCmdPredefined: array[TCnCompressPredefined] of string = (
    '<compress.exe> a -p<Password> <BackupFile> @<ListFile>',
    '<compress.exe> a -ep -p<Password> <BackupFile> @<ListFile>',
    '<compress.exe> a -p<Password> <BackupFile> @<ListFile>',
    '<compress.exe> -a -s<Password> <BackupFile> @<ListFile>'
  );

  SCnAfterCmdPredefined: array[0..1] of string = (
    '<externfile.exe>',
    '<externfile.exe> <BackupFile>'
  );

{ TCnProjectBackupSaveForm }

function TCnProjectBackupSaveForm.GetPassword: string;
begin
  Result := edtPass.Text;
end;

function TCnProjectBackupSaveForm.GetRemovePath: Boolean;
begin
  Result := chkRemovePath.Checked;
end;

function TCnProjectBackupSaveForm.GetSaveFileName: string;
begin
  Result := Trim(edtFile.Text);
end;

procedure TCnProjectBackupSaveForm.SetSaveFileName(const Value: string);
begin
  if Value <> '' then
    edtFile.Text := Value;
end;

function TCnProjectBackupSaveForm.GetUsePassword: Boolean;
begin
  Result := chkPassword.Checked;
end;

procedure TCnProjectBackupSaveForm.SetPassword(const Value: string);
begin
  edtPass.Text := Value;
  edtSecond.Text := Value;
end;

procedure TCnProjectBackupSaveForm.SetUsePassword(const Value: Boolean);
begin
  chkPassword.Checked := Value;
end;

procedure TCnProjectBackupSaveForm.btnSelectClick(Sender: TObject);
var
  FileName: string;
begin
  dlgSave.FileName := ExtractFileName(edtFile.Text);
  if Self.dlgSave.Execute then
  begin
    case dlgSave.FilterIndex of
      1: FileName := ChangeFileExt(Self.dlgSave.FileName, '.zip');
      2: FileName := ChangeFileExt(Self.dlgSave.FileName, '.rar');
      3: FileName := ChangeFileExt(Self.dlgSave.FileName, '.7z');
    end;
    
    if not FileExists(FileName) or QueryDlg(SCnOverwriteQuery) then
    begin
      edtFile.Text := FileName;
      FSavePath := ExtractFilePath(Self.dlgSave.FileName);
      FConfirmed := True;
    end;
  end;
end;

procedure TCnProjectBackupSaveForm.FormShow(Sender: TObject);
begin
  UpdateContent;
end;

procedure TCnProjectBackupSaveForm.SetRemovePath(const Value: Boolean);
begin
  chkRemovePath.Checked := Value;
end;

procedure TCnProjectBackupSaveForm.FormCloseQuery(Sender: TObject;
  var CanClose: Boolean);
begin
  if ModalResult = mrOK then
  begin
    if (edtFile.Text = '') then
    begin
      ErrorDlg(SCnInputFile);
      CanClose := False;
      Exit;
    end;

    if chkUseExternal.Checked and not FileExists(edtCompressor.Text) then
    begin
      ErrorDlg(SCnProjExtBackupErrorCompressor);
      CanClose := False;
      Exit;
    end;

    if not chkUseExternal.Checked and (UpperCase(ExtractFileExt(edtFile.Text)) <> '.ZIP') then
    begin
      CanClose := QueryDlg(SCnProjExtBackupMustZip);
      Exit;
    end;

    if chkPassword.Checked and (edtPass.Text = '') or (edtPass.Text <> edtSecond.Text) then
    begin
      ErrorDlg(SCnDoublePasswordError);
      CanClose := False;
      edtPass.SetFocus;
      Exit;
    end;
  end;
end;

procedure TCnProjectBackupSaveForm.chkPasswordClick(Sender: TObject);
begin
  UpdateContent;
end;

procedure TCnProjectBackupSaveForm.btnHelpClick(Sender: TObject);
begin
  ShowFormHelp;
end;

function TCnProjectBackupSaveForm.GetHelpTopic: string;
begin
  Result := 'CnProjectBackup';
end;

procedure TCnProjectBackupSaveForm.edtFileChange(Sender: TObject);
begin
  FConfirmed := False;
end;

procedure TCnProjectBackupSaveForm.cbbTimeFormatChange(Sender: TObject);
begin
  if FExt = '' then
    FExt := '.zip';

  edtFile.Text := SavePath + CurrentName
    + FormatDateTime('_' + Trim(cbbTimeFormat.Items[cbbTimeFormat.ItemIndex]), Date + Time) + FExt;

  FConfirmed := False;
end;

function TCnProjectBackupSaveForm.GetRememberPass: Boolean;
begin
  Result := chkRememberPass.Checked;
end;

procedure TCnProjectBackupSaveForm.SetRememberPass(const Value: Boolean);
begin
  chkRememberPass.Checked := Value;
end;

function TCnProjectBackupSaveForm.GetCompressCmd: string;
begin
  Result := Trim(mmoCmd.Lines.Text);
end;

function TCnProjectBackupSaveForm.GetCompressor: string;
begin
  Result := Trim(edtCompressor.Text);
end;

function TCnProjectBackupSaveForm.GetUseExternal: Boolean;
begin
  Result := chkUseExternal.Checked;
end;

procedure TCnProjectBackupSaveForm.SetCompressCmd(const Value: string);
begin
  mmoCmd.Lines.Text := Value;
end;

procedure TCnProjectBackupSaveForm.SetCompressor(const Value: string);
begin
  edtCompressor.Text := Value;
end;

procedure TCnProjectBackupSaveForm.SetUseExternal(const Value: Boolean);
begin
  chkUseExternal.Checked := Value;
  UpdateContent;
end;

procedure TCnProjectBackupSaveForm.FormCreate(Sender: TObject);
begin
  Self.pgc1.ActivePageIndex := 0;
  UpdateContent;
end;

procedure TCnProjectBackupSaveForm.UpdateContent;
begin
  edtPass.Enabled := chkPassword.Checked;
  edtSecond.Enabled := chkPassword.Checked;
  chkRemovePath.Enabled := not chkUseExternal.Checked;
  lblPredefine.Enabled := chkUseExternal.Checked;
  lblCompressor.Enabled := chkUseExternal.Checked;
  lblCmd.Enabled := chkUseExternal.Checked;
  mmoCmd.Enabled := chkUseExternal.Checked;
  cbbPredefine.Enabled := chkUseExternal.Checked;
  btnCompressor.Enabled := chkUseExternal.Checked;
  edtCompressor.Enabled := chkUseExternal.Checked;

  lblAfterCmd.Enabled := chkExecAfter.Checked;
  edtAfterCmd.Enabled := chkExecAfter.Checked;
  btnAfterCmd.Enabled := chkExecAfter.Checked;
  lblPreParams.Enabled := chkExecAfter.Checked;
  cbbParams.Enabled := chkExecAfter.Checked;
  lblPreCmd.Enabled := chkExecAfter.Checked;
  mmoAfterCmd.Enabled := chkExecAfter.Checked;
  
  if not chkUseExternal.Checked then Exit;
  FExt := GetExtFromCompressor(edtCompressor.Text);
  edtFile.Text := ChangeFileExt(edtFile.Text, FExt);
end;

procedure TCnProjectBackupSaveForm.cbbPredefineChange(Sender: TObject);
var
  Ext: string;
begin
  // ʹ��Ԥ�������������
  if cbbPredefine.ItemIndex >= 0 then
  begin
    mmoCmd.Lines.Text := SCnCompressCmdPredefined[TCnCompressPredefined(cbbPredefine.ItemIndex)];
    Ext := GetExtFromCompressor(edtCompressor.Text);
    if Ext <> '' then
      edtFile.Text :=  ChangeFileExt(edtFile.Text, Ext);
  end;
end;

procedure TCnProjectBackupSaveForm.btnCompressorClick(Sender: TObject);
begin
  if dlgOpenCompressor.Execute then
  begin
    edtCompressor.Text := dlgOpenCompressor.FileName;
    UpdateContent;
  end;
end;

procedure TCnProjectBackupSaveForm.chkUseExternalClick(Sender: TObject);
begin
  UpdateContent;
end;

function TCnProjectBackupSaveForm.GetExtFromCompressor(
  Compressor: string): string;
var
  S: string;
begin
  Result := '';
  S := LowerCase(ExtractFileName(Compressor));
  if S = '' then Exit;

  if Pos('rar', S) > 0 then
    Result := '.rar'
  else if Pos('7z', S) > 0 then
    Result := '.7z'
  else if Pos('zip', S) > 0 then
    Result := '.zip';
end;

procedure TCnProjectBackupSaveForm.btnAfterCmdClick(Sender: TObject);
begin
  if dlgOpenCompressor.Execute then
  begin
    edtAfterCmd.Text := dlgOpenCompressor.FileName;
    UpdateContent;
  end;
end;

procedure TCnProjectBackupSaveForm.cbbParamsChange(Sender: TObject);
begin
  // ʹ��Ԥ�������������
  if cbbParams.ItemIndex >= 0 then
    mmoAfterCmd.Lines.Text := SCnAfterCmdPredefined[cbbParams.ItemIndex];
end;

function TCnProjectBackupSaveForm.GetAfterCmd: string;
begin
  Result := Trim(mmoAfterCmd.Lines.Text);
end;

procedure TCnProjectBackupSaveForm.SetAfterCmd(const Value: string);
begin
  mmoAfterCmd.Lines.Text := Value;
end;

function TCnProjectBackupSaveForm.GetExecAfter: Boolean;
begin
  Result := chkExecAfter.Checked;
end;

procedure TCnProjectBackupSaveForm.SetExecAfter(const Value: Boolean);
begin
  chkExecAfter.Checked := Value;
end;

function TCnProjectBackupSaveForm.GetExecAfterFile: string;
begin
  Result := Trim(edtAfterCmd.Text);
end;

procedure TCnProjectBackupSaveForm.SetExecAfterFile(const Value: string);
begin
  edtAfterCmd.Text := Trim(Value);
end;

{$ENDIF SUPPORT_PRJ_BACKUP}

{$ENDIF CNWIZARDS_CNPROJECTEXTWIZARD}
end.
