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

unit CnProjectDirImportFrm;
{ |<PRE>
================================================================================
* ������ƣ�CnPack IDE ר�Ұ�
* ��Ԫ���ƣ�����Ŀ¼����������Ŀ¼��Ԫ
* ��Ԫ���ߣ�LiuXiao liuxiao@cnpack.org
* ��    ע��
* ����ƽ̨��PWin2000Pro + Delphi 5.01
* ���ݲ��ԣ�PWin9X/2000/XP + Delphi 5/6/7 + C++Builder 5/6
* �� �� �����õ�Ԫ�е��ַ��������ϱ��ػ�����ʽ
* ��Ԫ��ʶ��$Id: CnProjectDirImportFrm.pas 763 2011-02-07 14:18:23Z liuxiao@cnpack.org $
* �޸ļ�¼��2005.06.8 V1.0
*               ������Ԫ
================================================================================
|</PRE>}

interface

{$I CnWizards.inc}

{$IFDEF CNWIZARDS_CNPROJECTEXTWIZARD}

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  CnWizMultiLang, StdCtrls, FileCtrl;

type
  TCnImportDirForm = class(TCnTranslateForm)
    btnHelp: TButton;
    btnOK: TButton;
    btnCancel: TButton;
    grpImport: TGroupBox;
    lblDir: TLabel;
    edtDir: TEdit;
    btnSelectDir: TButton;
    chkIngoreDir: TCheckBox;
    cbbIgnoreDir: TComboBox;
    chkNameIsDesc: TCheckBox;
    procedure btnSelectDirClick(Sender: TObject);
    procedure chkIngoreDirClick(Sender: TObject);
    procedure btnHelpClick(Sender: TObject);
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
  private
    { Private declarations }
  protected
    function GetHelpTopic: string; override;
  public
    { Public declarations }
  end;

function SelectImportDir(var RootDir: string; var Ignore: Boolean;
  var IgnoreDir: string; var GenReadMe: Boolean): Boolean;

{$ENDIF CNWIZARDS_CNPROJECTEXTWIZARD}

implementation

{$IFDEF CNWIZARDS_CNPROJECTEXTWIZARD}

uses
  CnCommon, CnWizConsts, CnWizUtils;

{$R *.DFM}

function SelectImportDir(var RootDir: string; var Ignore: Boolean;
  var IgnoreDir: string; var GenReadMe: Boolean): Boolean;
begin
  with TCnImportDirForm.Create(nil) do
  begin
    edtDir.Text := RootDir;
    chkIngoreDir.Checked := Ignore;
    cbbIgnoreDir.Text := IgnoreDir;
    chkNameIsDesc.Checked := GenReadMe;
    if Assigned(chkIngoreDir.OnClick) then
      chkIngoreDir.OnClick(chkIngoreDir);
      
    Result := ShowModal = mrOK;
    if Result then
    begin
      RootDir := edtDir.Text;
      Ignore := chkIngoreDir.Checked;
      IgnoreDir := cbbIgnoreDir.Text;
      GenReadMe := chkNameIsDesc.Checked;
      if cbbIgnoreDir.Items.IndexOf(IgnoreDir) < 0 then
        cbbIgnoreDir.Items.Add(IgnoreDir);
    end;
    Free;
  end;
end;

procedure TCnImportDirForm.btnSelectDirClick(Sender: TObject);
var
  NewDir: string;
begin
  NewDir := ReplaceToActualPath(edtDir.Text);
  if GetDirectory(SCnSelectDir, NewDir) then
    edtDir.Text := NewDir;
end;

procedure TCnImportDirForm.chkIngoreDirClick(Sender: TObject);
begin
  cbbIgnoreDir.Enabled := chkIngoreDir.Checked;
end;

procedure TCnImportDirForm.btnHelpClick(Sender: TObject);
begin
  ShowFormHelp;
end;

function TCnImportDirForm.GetHelpTopic: string;
begin
  Result := 'CnProjectExtDirBuilder';
end;

procedure TCnImportDirForm.FormCloseQuery(Sender: TObject;
  var CanClose: Boolean);
begin
  if ModalResult = mrOK then
  begin
    if not DirectoryExists(edtDir.Text) then
    begin
      ErrorDlg(SCnStatDirNotExists);
      CanClose := False;
    end;
  end;
end;

{$ENDIF CNWIZARDS_CNPROJECTEXTWIZARD}
end.
