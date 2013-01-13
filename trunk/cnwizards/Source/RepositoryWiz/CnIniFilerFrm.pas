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

unit CnIniFilerFrm;
{ |<PRE>
================================================================================
* ������ƣ�CnPack IDE ר�Ұ�
* ��Ԫ���ƣ�Ini �ļ���д��Ԫ����
* ��Ԫ���ߣ�LiuXiao ��liuxiao@cnpack.org��
* ��    ע��Ini �ļ���д��Ԫ����
* ����ƽ̨��Windows 2000 + Delphi 5
* ���ݲ��ԣ�PWin9X/2000/XP + Delphi 5/6/7
* �� �� �����ô����е��ַ��������ϱ��ػ�����ʽ
* ��Ԫ��ʶ��$Id: CnIniFilerFrm.pas 763 2011-02-07 14:18:23Z liuxiao@cnpack.org $
* �޸ļ�¼��2003.12.07 V1.0
*               LiuXiao ������Ԫ��ʵ�ֹ���
================================================================================
|</PRE>}

interface

{$I CnWizards.inc}

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, Buttons, CnWizMultiLang, CnCommon, CnWizConsts;

type
  TCnIniFilerForm = class(TCnTranslateForm)
    btnOK: TButton;
    btnCancel: TButton;
    btnHelp: TButton;
    grp1: TGroupBox;
    lblIni: TLabel;
    edtIniFile: TEdit;
    lblConstPrefix: TLabel;
    edtPrefix: TEdit;
    lblIniClassName: TLabel;
    edtClassName: TEdit;
    lblT: TLabel;
    dlgOpen: TOpenDialog;
    btnOpen: TSpeedButton;
    chkIsAllStr: TCheckBox;
    chkBool: TCheckBox;
    dlgSave: TSaveDialog;
    procedure btnOpenClick(Sender: TObject);
    procedure btnHelpClick(Sender: TObject);
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
    procedure chkIsAllStrClick(Sender: TObject);
  private
    function GetConstPrefix: string;
    procedure SetConstPrefix(const Value: string);
    function GetIniClassName: string;
    procedure SetIniClassName(const Value: string);
    function GetIniFileName: string;
    procedure SetIniFileName(const Value: string);
    function GetIsAllStr: Boolean;
    procedure SetIsAllStr(const Value: Boolean);
    function GetCheckBool: Boolean;
    procedure SetCheckBool(const Value: Boolean);
    { Private declarations }
  protected
    function GetHelpTopic: string; override;
  public
    property ConstPrefix: string read GetConstPrefix write SetConstPrefix;
    property IniClassName: string read GetIniClassName write SetIniClassName;
    property IniFileName: string read GetIniFileName write SetIniFileName;
    property IsAllStr: Boolean read GetIsAllStr write SetIsAllStr;
    property CheckBool: Boolean read GetCheckBool write SetCheckBool; 
    { Public declarations }
  end;

var
  CnIniFilerForm: TCnIniFilerForm;

implementation

{$R *.DFM}

function TCnIniFilerForm.GetConstPrefix: string;
begin
  Result := Self.edtPrefix.Text;
end;

procedure TCnIniFilerForm.SetConstPrefix(const Value: string);
begin
  Self.edtPrefix.Text := Value;
end;

function TCnIniFilerForm.GetIniClassName: string;
begin
  Result := Self.edtClassName.Text;
end;

procedure TCnIniFilerForm.SetIniClassName(const Value: string);
begin
  Self.edtClassName.Text := Value;
end;

procedure TCnIniFilerForm.btnOpenClick(Sender: TObject);
begin
  if Self.dlgOpen.Execute then
    Self.IniFileName := Self.dlgOpen.FileName;
end;

function TCnIniFilerForm.GetIniFileName: string;
begin
  Result := Self.edtIniFile.Text;
end;

procedure TCnIniFilerForm.SetIniFileName(const Value: string);
begin
  Self.edtIniFile.Text := Value;
end;

procedure TCnIniFilerForm.btnHelpClick(Sender: TObject);
begin
  ShowFormHelp;
end;

procedure TCnIniFilerForm.FormCloseQuery(Sender: TObject;
  var CanClose: Boolean);
begin
  CanClose := True;
  if Self.ModalResult = mrOK then
  begin
    if (Self.IniFileName = '') or not FileExists(Self.IniFileName) then
    begin
      ErrorDlg(SCnIniErrorNoFile);
      CanClose := False;
    end
    else if (Self.IniClassName = '') or (Pos(' ', Self.IniClassName) > 0) then
    begin
      ErrorDlg(SCnIniErrorClassName);
      CanClose := False;
    end
    else if (Self.ConstPrefix = '') or (Pos(' ', Self.ConstPrefix) > 0) then
    begin
      ErrorDlg(SCnIniErrorPrefix);
      CanClose := False;
    end;
  end;
end;

function TCnIniFilerForm.GetHelpTopic: string;
begin
  Result := 'CnIniFilerWizard';
end;

function TCnIniFilerForm.GetIsAllStr: Boolean;
begin
  Result := not Self.chkIsAllStr.Checked;
end;

procedure TCnIniFilerForm.SetIsAllStr(const Value: Boolean);
begin
  Self.chkIsAllStr.Checked := not Value;
  if Assigned(chkIsAllStr.OnClick) then
    chkIsAllStr.OnClick(chkIsAllStr);
end;

function TCnIniFilerForm.GetCheckBool: Boolean;
begin
  Result := Self.chkBool.Checked;
end;

procedure TCnIniFilerForm.SetCheckBool(const Value: Boolean);
begin
  Self.chkBool.Checked := Value;
end;

procedure TCnIniFilerForm.chkIsAllStrClick(Sender: TObject);
begin
  chkBool.Enabled := chkIsAllStr.Checked;
end;

end.
