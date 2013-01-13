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

unit CnMemProfWizard;
{* |<PRE>
================================================================================
* ������ƣ�CnPack IDE ר�Ұ�
* ��Ԫ���ƣ�CnMemProfWizard �����򵼺ʹ���
* ��Ԫ���ߣ�LiuXiao (��Х)
* ��    ע���� LiuXiao ��ֲ��
* ����ƽ̨��PWin2000Pro + Delphi 5.01
* ���ݲ��ԣ�PWin9X/2000/XP + Delphi 5/6/7
* �� �� �����õ�Ԫ�е��ַ��������ϱ��ػ�����ʽ
* ��Ԫ��ʶ��$Id: CnMemProfWizard.pas 763 2011-02-07 14:18:23Z liuxiao@cnpack.org $
* �޸ļ�¼��2004.07.06 V1.0
*               ������Ԫ��ʵ�ֹ���
================================================================================
|</PRE>}

interface

{$I CnWizards.inc}

{$IFDEF CNWIZARDS_CNMEMPROFWIZARD}

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, Buttons, ToolsApi, CnConsts, CnCommon, CnWizConsts, CnWizClasses,
  CnWizOptions, CnWizMultiLang, CnOTACreators;

type
  TCnMemProfForm = class(TCnTranslateForm)
    grpMain: TGroupBox;
    btnOK: TButton;
    btnCancel: TButton;
    btnHelp: TButton;
    chkPopupMsg: TCheckBox;
    chkUseObjList: TCheckBox;
    chkUseObjInfo: TCheckBox;
    chkLogToFile: TCheckBox;
    edtLogFile: TEdit;
    lblLogFile: TLabel;
    btnBrowse: TSpeedButton;
    lblNote: TLabel;
    dlgSave: TSaveDialog;
    procedure btnBrowseClick(Sender: TObject);
    procedure UpdateContents(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure btnHelpClick(Sender: TObject);
  private
    { Private declarations }
  protected
    function GetHelpTopic: string; override;
  public
    { Public declarations }
  end;

  TCnMemProfWizard = class(TCnProjectWizard)
  private

  protected

  public
    constructor Create; override;
    destructor Destroy; override;
    class procedure GetWizardInfo(var Name, Author, Email, Comment: string); override;
    procedure Execute; override;

  end;

  // �������̵� Creator
  TCnMemProfProjectCreator = class(TCnTemplateProjectCreator)
  private
    FPopupMsg: Boolean;
    FUseObjList: Boolean;
    FUseObjInfo: Boolean;
    FLogToFile: Boolean;
    FLogFileName: string;
  protected
    function GetTemplateFile(FileType: TCnSourceType): string; override;
    {* �������ṩ��Ŀģ���ļ��� }
    procedure DoReplaceTagsSource(const TagString: string; TagParams:
      TStrings; var ReplaceText: string; ASourceType: TCnSourceType; ProjectName:
      string); override;
    {* �������ش˺���ʵ�� ProjectCreator ��ģ�� Tag �滻 }
  public
    constructor Create; override;
    destructor Destroy; override;
    procedure NewDefaultModule; override;
    {* �½���Ŀʱ����Ĭ��ģ�� }

    property PopupMsg: Boolean read FPopupMsg write FPopupMsg;
    property UseObjList: Boolean read FUseObjList write FUseObjList;
    property UseObjInfo: Boolean read FUseObjInfo write FUseObjInfo;
    property LogToFile: Boolean read FLogToFile write FLogToFile;
    property LogFileName: string read FLogFileName write FLogFileName;
  end;

  // ���� Unit1 ��Creator
  TCnMemProfUnit1Creator = class(TCnTemplateModuleCreator)
  private
  protected
    function GetTemplateFile(FileType: TCnSourceType): string; override;
    {* �������ṩ Unit1 ��ģ���ļ��� }
  public
    constructor Create; override;
    destructor Destroy; override;

    function GetCreatorType: string; override;
    {* �����Է��� sForm ��ʾ����������� Unit }
    function GetMainForm: Boolean; override;
    {* ���� True ��ʾ�ǹ��̵� MainForm }
  end;

var
  SCnMemProfProjectTemplateFile: string = 'CnMemProfProject.dpr';
  SCnMemProfUnit1ModuleTemplateFile: string = 'CnMemProf_Unit1.pas';
  SCnMemProfUnit1DFMModuleTemplateFile: string = 'CnMemProf_Unit1.dfm';

{$ENDIF CNWIZARDS_CNMEMPROFWIZARD}

implementation

{$IFDEF CNWIZARDS_CNMEMPROFWIZARD}

{$R *.DFM}

const
  csMemProfFileName = 'CnMemProf.pas';

  csCnMemProf = 'CnMemProf';
  csPopupMsg = 'PopupMsg';
  csUseObjList = 'UseObjList';
  csUseObjInfo = 'UseObjInfo';
  csLogToFile = 'LogToFile';
  csLogFileName = 'LogFileName';

function IfThenStr(ACondition: Boolean; const Str1, Str2: string): string;
begin
  if ACondition then
    Result := Str1
  else
    Result := Str2;
end;

procedure TCnMemProfForm.btnBrowseClick(Sender: TObject);
begin
  if Self.dlgSave.Execute then
    Self.edtLogFile.Text := Self.dlgSave.FileName;
end;

procedure TCnMemProfForm.UpdateContents(Sender: TObject);
begin
  chkUseObjInfo.Enabled := chkUseObjList.Checked;
  lblLogFile.Enabled := chkLogToFile.Checked;
  edtLogFile.Enabled := chkLogToFile.Checked;
  btnBrowse.Enabled := chkLogToFile.Checked;
end;

procedure TCnMemProfForm.FormCreate(Sender: TObject);
begin
  Self.UpdateContents(nil);
end;

procedure TCnMemProfForm.btnHelpClick(Sender: TObject);
begin
  ShowFormHelp;
end;

{ TCnMemProfWizard }

constructor TCnMemProfWizard.Create;
begin
  inherited;

end;

destructor TCnMemProfWizard.Destroy;
begin
  inherited;

end;

procedure TCnMemProfWizard.Execute;
var
  ModuleCreator: TCnBaseCreator;
begin
  with TCnMemProfForm.Create(nil) do
  begin
    if ShowModal = mrOK then
    begin
      ModuleCreator := TCnMemProfProjectCreator.Create;
      // ������ֵ
      TCnMemProfProjectCreator(ModuleCreator).PopupMsg := chkPopupMsg.Checked;
      TCnMemProfProjectCreator(ModuleCreator).UseObjList := chkUseObjList.Checked;
      TCnMemProfProjectCreator(ModuleCreator).UseObjInfo := chkUseObjInfo.Checked;
      TCnMemProfProjectCreator(ModuleCreator).LogToFile := chkLogToFile.Checked;
      TCnMemProfProjectCreator(ModuleCreator).LogFileName := edtLogFile.Text;

      (BorlandIDEServices as IOTAModuleServices).CreateModule(ModuleCreator);
    end;
    Free;
  end;
end;

class procedure TCnMemProfWizard.GetWizardInfo(var Name, Author, Email,
  Comment: string);
begin
  Name := SCnMemProfWizardName;
  Author := SCnPack_LiuXiao;
  Email := SCnPack_LiuXiaoEmail;
  Comment := SCnMemProfWizardComment;
end;

{ TCnMemProfProjectCreator }

constructor TCnMemProfProjectCreator.Create;
begin
  inherited;

end;

destructor TCnMemProfProjectCreator.Destroy;
begin
  inherited;

end;

procedure TCnMemProfProjectCreator.DoReplaceTagsSource(
  const TagString: string; TagParams: TStrings; var ReplaceText: string;
  ASourceType: TCnSourceType; ProjectName: string);
begin
  if ASourceType = stProjectSource then
  begin
    if TagString = csCnMemProf then
      ReplaceText := '  CnMemProf,'#13#10
    else if TagString = csPopupMsg then
      ReplaceText := IfThenStr(PopupMsg, 'True', 'False')
    else if TagString = csUseObjList then
      ReplaceText := IfThenStr(UseObjList, 'True', 'False')
    else if TagString = csUseObjInfo then
      ReplaceText := IfThenStr(UseObjInfo, 'True', 'False')
    else if TagString = csLogToFile then
      ReplaceText := IfThenStr(LogToFile, 'True', 'False')
    else if TagString = csLogFileName then
      ReplaceText := IfThenStr(LogToFile and (LogFileName <> ''), 'mmErrLogFile := '
        + QuotedStr(LogFileName) + ';'#13#10, '');
  end;
end;

function TCnMemProfProjectCreator.GetTemplateFile(
  FileType: TCnSourceType): string;
begin
  if FileType = stProjectSource then
    Result := MakePath(WizOptions.TemplatePath) + SCnMemProfProjectTemplateFile
  else
    Result := '';
end;

procedure TCnMemProfProjectCreator.NewDefaultModule;
var
  UnitCreator: TCnBaseCreator;
begin
  // ���� Unit1 �� pas �� dfm
  UnitCreator := TCnMemProfUnit1Creator.Create;
  (BorlandIDEServices as IOTAModuleServices).CreateModule(UnitCreator);
end;

{ TCnMemProfUnit1Creator }

constructor TCnMemProfUnit1Creator.Create;
begin
  inherited;

end;

destructor TCnMemProfUnit1Creator.Destroy;
begin
  inherited;

end;

function TCnMemProfUnit1Creator.GetCreatorType: string;
begin
  Result := sForm;
end;

function TCnMemProfUnit1Creator.GetMainForm: Boolean;
begin
  Result := True;
end;

function TCnMemProfUnit1Creator.GetTemplateFile(
  FileType: TCnSourceType): string;
begin
  if FileType = stImplSource then
    Result := MakePath(WizOptions.TemplatePath) + SCnMemProfUnit1ModuleTemplateFile
  else if FileType = stFormFile then
    Result := MakePath(WizOptions.TemplatePath) + SCnMemProfUnit1DFMModuleTemplateFile
  else
    Result := '';
end;

function TCnMemProfForm.GetHelpTopic: string;
begin
  Result := 'CnMemProfWizard';
end;

initialization
  {$IFDEF DELPHI}
  RegisterCnWizard(TCnMemProfWizard);
  {$ENDIF}

{$ENDIF CNWIZARDS_CNMEMPROFWIZARD}
end.
