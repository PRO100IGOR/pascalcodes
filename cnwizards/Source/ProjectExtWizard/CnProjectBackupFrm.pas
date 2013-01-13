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

unit CnProjectBackupFrm;
{ |<PRE>
================================================================================
* ������ƣ�CnPack IDE ר�Ұ�
* ��Ԫ���ƣ���Ŀ���ݵ�Ԫ
* ��Ԫ���ߣ����� (qsoft@cnpack.org)
* ��    ע��
* ����ƽ̨��PWin2000Pro + Delphi 5.01
* ���ݲ��ԣ�PWin9X/2000/XP + Delphi 5/6/7 + C++Builder 5/6
* �� �� �����õ�Ԫ�е��ַ��������ϱ��ػ�����ʽ
* ��Ԫ��ʶ��$Id: CnProjectBackupFrm.pas 763 2011-02-07 14:18:23Z liuxiao@cnpack.org $
* �޸ļ�¼��2008.06.20 V1.1 by LiuXiao
*               ���뱸�ݺ���������Ļ���
*           2006.08.19 V1.3 by LiuXiao
*               ���̱������Ʊ�������Ĺ���
*           2005.01.10 V1.2 by ����
*               1. ʹ��TObjectList��Ԥ�����ļ��б���߼����ٶ�
*           2005.01.09 V1.1 by ����
*               1. �ļ��б�ʹ��ϵͳ�ļ�ͼ��
*               2. ֧��ȫ�����̡���ǰ����̺��ض�������Ŀ����ѡ��
*               3. ����һ�������ļ�������ӵ�Bug
*           2004.12.31 V1.0 by ����
*               ������Ԫ
================================================================================
|</PRE>}

interface

{$I CnWizards.inc}

{$IFDEF CNWIZARDS_CNPROJECTEXTWIZARD}

{$IFDEF SUPPORT_PRJ_BACKUP}

uses
  Windows, SysUtils, Messages, Classes, Graphics, Forms, Controls, StdCtrls,
  Buttons, ExtCtrls, CheckLst, IniFiles, Menus, ActnList, FileCtrl, CnCommon,
  CnWizConsts, CnWizMultiLang, ComCtrls, ToolWin, ToolsAPI, ShellAPI, CommCtrl,
  contnrs, Dialogs, CnLangTranslator, CnLangMgr, CnLangStorage, CnHashLangStorage;

type

  { TCnBackupFileInfo }

  TCnBackupFileInfo = class
  private
    FCustomFile: Boolean;
    FName: string;
    FPath: string;
    FSize: Integer;
    FHidden: Boolean;

    function GetFullFileName: string;
  public
    constructor Create;
    destructor Destroy; override;

    procedure SetFileInfo(FileName: string; ACustomFile: Boolean = False);

    property CustomFile: Boolean read FCustomFile write FCustomFile;
    property Name: string read FName write FName;
    property Path: string read FPath write FPath;
    property FullFileName: string read GetFullFileName;
    property Size: Integer read FSize write FSize;
    property Hidden: Boolean read FHidden write FHidden;
  end;

  { TCnBackupProjectInfo }

  TCnBackupProjectInfo = class(TCnBackupFileInfo)
  private
    FInfoList: TObjectList;

    function GetCount: Integer;
    function GetItem(Index: Integer): TCnBackupFileInfo;
  public
    constructor Create;
    destructor Destroy; override;

    procedure Add(FileInfo: TCnBackupFileInfo);
    procedure Delete(Index: Integer);
    procedure AddFiles(FileName, UnitName, FormName: string);
    property Count: Integer read GetCount;
    property Items[Index: Integer]: TCnBackupFileInfo read GetItem;
  end;

  { TCnBackupProjectList }

  TCnBackupProjectList = class(TCnBackupFileInfo)
  private
    FProjectList: TObjectList;

    function GetCount: Integer;
    function GetItem(Index: Integer): TCnBackupProjectInfo;
  public
    constructor Create;
    destructor Destroy; override;

    procedure Add(ProjectInfo: TCnBackupProjectInfo);
    procedure Delete(Index: Integer);
    property Count: Integer read GetCount;
    property Items[Index: Integer]: TCnBackupProjectInfo read GetItem;
  end;

  TCnProjectBackupForm = class(TCnTranslateForm)
    statMain: TStatusBar;
    lvFileView: TListView;
    actlstMain: TActionList;
    actAddFile: TAction;
    actRemoveFile: TAction;
    actClose: TAction;
    actHelp: TAction;
    tlbMain: TToolBar;
    btnAddFile: TToolButton;
    btnRemoveFile: TToolButton;
    btnSprt1: TToolButton;
    btnHelp: TToolButton;
    btnClose: TToolButton;
    pnlTool: TPanel;
    lblProjects: TLabel;
    cbbProjectList: TComboBox;
    btnZip: TToolButton;
    btn1: TToolButton;
    actZip: TAction;
    dlgOpen: TOpenDialog;
    procedure actCloseExecute(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure cbbProjectListChange(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure lvFileViewCustomDrawItem(Sender: TCustomListView;
      Item: TListItem; State: TCustomDrawState; var DefaultDraw: Boolean);
    procedure actZipExecute(Sender: TObject);
    procedure actRemoveFileExecute(Sender: TObject);
    procedure actAddFileExecute(Sender: TObject);
    procedure actHelpExecute(Sender: TObject);
    procedure FormKeyPress(Sender: TObject; var Key: Char);
    procedure lvFileViewKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
  private
    { Private declarations }
    CustomFiles: TCnBackupProjectInfo;
    ProjectList: TCnBackupProjectList;
    FExt: string;

    FRemovePath: Boolean;
    FUsePassword: Boolean;
    FRememberPass: Boolean;
    FPassword: string;
    FSavePath: string;
    FCurrentName: string;
    FTimeFormatIndex: Integer;
    FUseExternal: Boolean;
    FCompressor: string;
    FCompressCmd: string;
    FExecCmdAfterBackup: Boolean;
    FExecCmdFile: string;
    FExecCmdString: string;

    procedure OnAppMessage(var Msg: Tmsg; var Handled: Boolean);
    procedure CreateProjectList;
    procedure InitComboBox;
    procedure UpdateStatusBar;
    procedure AddBackupFile(const ProjectName: string; FileInfo: TCnBackupFileInfo);
    procedure AddBackupFiles(ProjectInfo: TCnBackupProjectInfo);
    procedure UpdateBackupFileView(ProjectName: string);
    function FindBackupFile(const FileName: string): Integer;

    procedure SimpleDecode(var Pass: string);
    procedure SimpleEncode(var Pass: string);
  protected
    function GetHelpTopic: string; override;
  public
    { Public declarations }
    procedure LoadSettings(Ini: TCustomIniFile);
    procedure SaveSettings(Ini: TCustomIniFile);
  end;

var
  CnProjectBackupForm: TCnProjectBackupForm;

function ShowProjectBackupForm(Ini: TCustomIniFile): Boolean;

function GetFileIconIndex(FileName: string): Integer;

{$ENDIF SUPPORT_PRJ_BACKUP}

{$ENDIF CNWIZARDS_CNPROJECTEXTWIZARD}

implementation

{$IFDEF CNWIZARDS_CNPROJECTEXTWIZARD}

{$IFDEF SUPPORT_PRJ_BACKUP}

{$R *.DFM}

uses
{$IFDEF DEBUG} CnDebug, {$ENDIF}
{$IFDEF COMPILER6_UP}Variants, {$ENDIF}
  CnWizOptions, CnWizUtils, CnWizHelperIntf,
  CnWizShareImages, CnProjectBackupSaveFrm, CnWizNotifier;

const
  csBackupSection = 'ProjectBackup';
  csRemovePath = 'RemovePath';
  csUsePassword = 'UsePassword';
  csSavePath = 'SavePath';
  csRememberPass = 'RememberPass';
  csZipPass = 'ZipPass';
  csTimeFormatIndex = 'TimeFormatIndex';
  
  csUseExternal = 'UseExternal';
  csCompressor = 'Compressor';
  csCompressCmd = 'CompressCmd';
  csExecCmdAfterBackup = 'ExecCmdAfterBackup';
  csExecCmdFile = 'ExecCmdFile';
  csExecCmdString = 'ExecCmdString';

const
  csCmdCompress = '<compress.exe>';
  csCmdBackupFile = '<BackupFile>';
  csVersionInfo = '<VersionInfo>';
  csCmdListFile = '<ListFile>';
  csCmdPassword = '<Password>';
  csAfterCmd = '<externfile.exe>';

function ShowProjectBackupForm(Ini: TCustomIniFile): Boolean;
begin
  with TCnProjectBackupForm.Create(nil) do
  try
    ShowHint := WizOptions.ShowHint;
    LoadSettings(Ini);
    Result := ShowModal = mrOK;
    SaveSettings(Ini);
  finally
    Free;
  end;
end;

{ ���ļ�����·������ȡϵͳͼ���б�������� }
function GetFileIconIndex(FileName: string): Integer;
var
  FileInfo: TSHFileInfo;
begin
  ShGetFileInfo(PChar(FileName), 0, FileInfo, SizeOf(FileInfo),
    SHGFI_SMALLICON or SHGFI_SYSICONINDEX or SHGFI_TYPENAME);

  Result := FileInfo.iIcon; { ���ػ�ȡ��ͼ����� }
end;

//==============================================================================
// ������Ϣ��
//==============================================================================

constructor TCnBackupFileInfo.Create;
begin  
  inherited Create;

  FCustomFile := False;
  FName := '';
  FPath := '';
  FSize := 0;
end;

destructor TCnBackupFileInfo.Destroy;
begin

  inherited Destroy;
end;
   
function TCnBackupFileInfo.GetFullFileName: string;
begin
  Result := FPath + FName;
end;

procedure TCnBackupFileInfo.SetFileInfo(FileName: string; ACustomFile: Boolean = False);
begin
  FCustomFile := ACustomFile;
  FName := ExtractFileName(FileName);
  FPath := ExtractFilePath(FileName);
  FSize := GetFileSize(FileName);
end;

{ TCnBackupProjectInfo }

constructor TCnBackupProjectInfo.Create;
begin
  inherited Create;
  FInfoList := TObjectList.Create;
end;

destructor TCnBackupProjectInfo.Destroy;
begin
  FreeAndNil(FInfoList);
  inherited Destroy;
end;

procedure TCnBackupProjectInfo.Add(FileInfo: TCnBackupFileInfo);
begin
  FInfoList.Add(FileInfo);
end;

procedure TCnBackupProjectInfo.AddFiles(FileName, UnitName, FormName: string);
var
  TempFileName: string;

  function AddFile(FileName: string): Boolean;
  var
    FileInfo: TCnBackupFileInfo;
  begin
    Result := False;
    if not FileExists(FileName) then
      Exit;

    FileInfo := TCnBackupFileInfo.Create;
    FileInfo.SetFileInfo(FileName);
    Add(FileInfo);

    Result := True;
  end;
begin
  // ������ DCP/BPI/DLL �ļ�
  TempFileName := ExtractUpperFileExt(FileName);
  if (TempFileName = '.DCP') or (TempFileName = '.BPI') or (TempFileName = '.DLL') then
    Exit;

  AddFile( FileName );

  // ���� cpp �ļ���Ӧ�� h/hpp/bpr/bpk
  if TempFileName = '.CPP' then
  begin
    AddFile(ChangeFileExt(FileName, '.h'));
    AddFile(ChangeFileExt(FileName, '.hpp'));
    AddFile(ChangeFileExt(FileName, '.bpr'));
    AddFile(ChangeFileExt(FileName, '.bpk'));
  end;

  // ���������ļ�
  AddFile(ChangeFileExt(FileName, '.dfm'));
  AddFile(ChangeFileExt(FileName, '.xfm'));
  AddFile(ChangeFileExt(FileName, '.nfm'));
  AddFile(ChangeFileExt(FileName, '.todo'));
  AddFile(ChangeFileExt(FileName, '.tlb'));
end;

function TCnBackupProjectInfo.GetCount: Integer;
begin
  Result := FInfoList.Count;
end;

function TCnBackupProjectInfo.GetItem(Index: Integer): TCnBackupFileInfo;
begin
  Result := TCnBackupFileInfo(FInfoList.Items[Index]);
end;

procedure TCnBackupProjectInfo.Delete(Index: Integer);
begin
  FInfoList.Delete(Index);
end;

{ TCnBackupProjectList }

constructor TCnBackupProjectList.Create;
begin
  inherited Create;
  FProjectList := TObjectList.Create;
end;

destructor TCnBackupProjectList.Destroy;
begin
  FreeAndNil(FProjectList);
  inherited Destroy;
end;

procedure TCnBackupProjectList.Add(ProjectInfo: TCnBackupProjectInfo);
begin
  FProjectList.Add(ProjectInfo);
end;

function TCnBackupProjectList.GetCount: Integer;
begin
  Result := FProjectList.Count;
end;

function TCnBackupProjectList.GetItem(Index: Integer): TCnBackupProjectInfo;
begin
  Result := TCnBackupProjectInfo(FProjectList.Items[index]);
end;
 
//==============================================================================
// ���̱�����������
//==============================================================================

procedure TCnBackupProjectList.Delete(Index: Integer);
begin
  FProjectList.Delete(Index);
end;

{ TCnProjectBackupForm }

procedure TCnProjectBackupForm.FormCreate(Sender: TObject);
var
  hImgList: THandle;
  FileInfo: TSHFileInfo;
begin
  inherited;
  Screen.Cursor := crHourGlass;
  try
    ProjectList := TCnBackupProjectList.Create;
    CustomFiles := TCnBackupProjectInfo.Create;

    { ��ȡϵͳͼ���б� }
    hImgList := SHGetFileInfo('C:\', 0, FileInfo, SizeOf(FileInfo),
      SHGFI_SYSICONINDEX or SHGFI_SMALLICON);
    SendMessage(lvFileView.Handle, LVM_SETIMAGELIST, LVSIL_SMALL, hImgList);

    CreateProjectList;
    InitComboBox;

    // �����ļ���ͼ֧��һ���ⲿ���ļ��Ϸ�
    DragAcceptFiles(lvFileView.Handle, True);
    CnWizNotifierServices.AddApplicationMessageNotifier(OnAppMessage);
  finally
    Screen.Cursor := crDefault;
  end;
end;

procedure TCnProjectBackupForm.FormDestroy(Sender: TObject);
begin
  CnWizNotifierServices.RemoveApplicationMessageNotifier(OnAppMessage);
  FreeAndNil(ProjectList);
  FreeAndNil(CustomFiles);
  inherited;
end;

procedure TCnProjectBackupForm.LoadSettings(Ini: TCustomIniFile);
begin
  FUsePassword := Ini.ReadBool(csBackupSection, csUsePassword, False);
  FRememberPass := Ini.ReadBool(csBackupSection, csRememberPass, False);
  FRemovePath := Ini.ReadBool(csBackupSection, csRemovePath, False);
  FSavePath := Ini.ReadString(csBackupSection, csSavePath, '');
  FTimeFormatIndex := Ini.ReadInteger(csBackupSection, csTimeFormatIndex, 0);
  FPassword := Ini.ReadString(csBackupSection, csZipPass, '');
  FUseExternal := Ini.ReadBool(csBackupSection, csUseExternal, False);
  FCompressor := Ini.ReadString(csBackupSection, csCompressor, '');
  FCompressCmd := Ini.ReadString(csBackupSection, csCompressCmd, '');
  FExecCmdAfterBackup := Ini.ReadBool(csBackupSection, csExecCmdAfterBackup, False);
  FExecCmdFile := Ini.ReadString(csBackupSection, csExecCmdFile, '');
  FExecCmdString := Ini.ReadString(csBackupSection, csExecCmdString, '');
  try
    SimpleDecode(FPassword);
  except
    FPassword := '';
  end;
end;

procedure TCnProjectBackupForm.SaveSettings(Ini: TCustomIniFile);
begin
  Ini.WriteBool(csBackupSection, csUsePassword, FUsePassword);
  Ini.WriteBool(csBackupSection, csRememberPass, FRememberPass);
  Ini.WriteBool(csBackupSection, csRemovePath, FRemovePath);
  Ini.WriteString(csBackupSection, csSavePath, FSavePath);
  Ini.WriteInteger(csBackupSection, csTimeFormatIndex, FTimeFormatIndex);
  Ini.WriteBool(csBackupSection, csUseExternal, FUseExternal);
  Ini.WriteString(csBackupSection, csCompressor, FCompressor);
  Ini.WriteString(csBackupSection, csCompressCmd, FCompressCmd);
  Ini.WriteBool(csBackupSection, csExecCmdAfterBackup, FExecCmdAfterBackup);
  Ini.WriteString(csBackupSection, csExecCmdFile, FExecCmdFile);
  Ini.WriteString(csBackupSection, csExecCmdString, FExecCmdString);
  if FRememberPass then
  begin
    try
      SimpleEncode(FPassword);
    except
      FPassword := '';
    end;
    Ini.WriteString(csBackupSection, csZipPass, FPassword);
  end
  else
    Ini.WriteString(csBackupSection, csZipPass, '');
end;

function TCnProjectBackupForm.GetHelpTopic: string;
begin
  Result := 'CnProjectBackup';
end;

function TCnProjectBackupForm.FindBackupFile(const FileName: string): Integer;
var
  i: Integer;
  FileInfo: TCnBackupFileInfo;
begin
  for i := 0 to lvFileView.Items.Count - 1 do
  begin
    FileInfo := TCnBackupFileInfo(lvFileView.Items[i].Data);
    if CompareText(FileName, FileInfo.FullFileName) = 0 then
    begin
      Result := i;
      Exit;
    end;
  end;

  Result := -1;
end;

procedure TCnProjectBackupForm.OnAppMessage(var Msg: Tmsg; var Handled: Boolean);
var
  DroppedFilename: string;
  FileIndex: UINT;
  QtyDroppedFiles: UINT;
  pDroppedFilename: PChar;
  BufferLength, DroppedFileLength: UINT;
  FileInfo: TCnBackupFileInfo;
begin
  if Msg.Message = WM_DROPFILES then
  begin
    BufferLength := 0;
    pDroppedFilename := Nil;

    // ȡ��ǰ�Ϸŵ��ļ���
    FileIndex := $FFFFFFFF;
    QtyDroppedFiles := DragQueryFile(Msg.WParam, FileIndex,
                                     pDroppedFilename, BufferLength);
    for FileIndex := 0 to (QtyDroppedFiles - 1) do
    begin
      // �ȼ����ļ��������ڴ��С
      DroppedFileLength := DragQueryFile(Msg.WParam, FileIndex, Nil, 0);

      // �ڴ治��ʱ��Ҫ���·����ڴ�
      if (DroppedFileLength > BufferLength) then
      begin
        if (pDroppedFilename <> nil) then
          FreeMem(pDroppedFilename);
        BufferLength := DroppedFileLength + 1;
        GetMem(pDroppedFilename, BufferLength );
      end;

      DragQueryFile(Msg.WParam, FileIndex, pDroppedFilename, BufferLength);

      DroppedFilename := StrPas(pDroppedFilename);

      //TODO: ��ʱ��֧��Ŀ¼�Ϸţ�����֮��汾�и���֧��...
      if DirectoryExists( DroppedFilename ) then
        Continue;
        
      if FindBackupFile(DroppedFilename) <> -1 then // �ļ��Ѿ������뵽��ͼ��
        Continue;

      FileInfo := TCnBackupFileInfo.Create;
      FileInfo.SetFileInfo( DroppedFilename, True );
      CustomFiles.Add( FileInfo );

      AddBackupFile( SCnProjExtCustomBackupFile, FileInfo );
    end;

    DragFinish(Msg.WParam);
    if (pDroppedFilename <> nil) then
      FreeMem(pDroppedFilename);

    UpdateStatusBar; // ����״̬����ʾ

    Handled := True;
  end;
end;

procedure TCnProjectBackupForm.CreateProjectList;
var
  ProjectInfo: TCnBackupProjectInfo;

  FileName: string;
  IProjectGroup: IOTAProjectGroup;
  IProject: IOTAProject;
  IModuleInfo: IOTAModuleInfo;
  IEditor: IOTAEditor;
  i, j: Integer;
  ProjectInterfaceList: TInterfaceList;
{$IFDEF BDS}
  ProjectGroup: IOTAProjectGroup;
{$ENDIF}
begin
{$IFDEF DEBUG}
  CnDebugger.LogEnter('TCnProjectBackupForm.CreateProjectList');
{$ENDIF DEBUG}

  IProjectGroup := CnOtaGetProjectGroup;
  if IProjectGroup = nil then
    Exit;

  FileName := CnOtaGetProjectGroupFileName;
  if FileExists(FileName) then
    ProjectList.SetFileInfo(FileName);

  ProjectInterfaceList := TInterfaceList.Create;
  try
    CnOtaGetProjectList(ProjectInterfaceList);

    for I := 0 to ProjectInterfaceList.Count - 1 do
    begin
      IProject := IOTAProject(ProjectInterfaceList[I]);
      if (IProject = nil) then
        Continue;

{$IFDEF BDS}
      // BDS ��ProjectGroup Ҳ֧�� Project �ӿڣ������Ҫȥ��
      if Supports(IProject, IOTAProjectGroup, ProjectGroup) then
        Continue;
{$ENDIF}

      ProjectInfo := TCnBackupProjectInfo.Create;
      ProjectInfo.SetFileInfo(IProject.FileName);
      ProjectList.Add(ProjectInfo);

      for J := 0 to IProject.GetModuleFileCount - 1 do
      begin
        IEditor := IProject.GetModuleFileEditor(J);
        Assert(IEditor <> nil);

        FileName := IEditor.FileName;
        if FileName <> '' then
          ProjectInfo.AddFiles(IEditor.FileName, '', '');
      end;

      for J := 0 to IProject.GetModuleCount - 1 do
      begin
        IModuleInfo := IProject.GetModule(J);
        Assert(IModuleInfo <> nil);

        FileName := IModuleInfo.FileName;
        if FileName <> '' then
          ProjectInfo.AddFiles(IModuleInfo.FileName, '', IModuleInfo.FormName);
      end;
    end;
  finally
    ProjectInterfaceList.Free;
  end;
{$IFDEF DEBUG}
  CnDebugger.LogLeave('TCnProjectBackupForm.CreateProjectList');
{$ENDIF DEBUG}
end;

procedure TCnProjectBackupForm.InitComboBox;
var
  ProjectInfo: TCnBackupProjectInfo;
  i: Integer;
begin
  cbbProjectList.Clear;

  cbbProjectList.Items.Add(SCnProjExtProjectAll);
  cbbProjectList.Items.Add(SCnProjExtCurrentProject);

  for i := 0 to ProjectList.Count - 1 do
  begin
    ProjectInfo := ProjectList.Items[i];
    cbbProjectList.Items.Add(ProjectInfo.Name);
  end;

  cbbProjectList.ItemIndex := 0;
  cbbProjectListChange(nil); // ���±����ļ��б�
end;

procedure TCnProjectBackupForm.UpdateStatusBar;
begin
  with statMain do
  begin
    Panels[1].Text := Format(SCnProjExtProjectCount,
      [cbbProjectList.Items.Count - 2]);

    if cbbProjectList.Text = '' then
      Panels[2].Text := ''
    else
      Panels[2].Text := Format(SCnProjExtBackupFileCount,
        [cbbProjectList.Text, lvFileView.Items.Count]);
  end;
end;

procedure TCnProjectBackupForm.AddBackupFile(const ProjectName: string;
  FileInfo: TCnBackupFileInfo);
begin
  if (FileInfo.Name = '') or FileInfo.Hidden then
    Exit;

  // ���ļ��Ƿ��Ѿ������е������ļ���ͼ�У���Ϊһ���ļ����ܴ����ڶ�������У�
  // ������TCnProjectInfo�п��ܱ�����ͬ���ļ����ò������Ƿǳ��б�Ҫ�ģ�
  if FindBackupFile( FileInfo.FullFileName ) <> -1 then
    Exit;

  with lvFileView.Items.Add do
  begin
    Caption := FileInfo.Name;
    SubItems.Add(ProjectName);
    SubItems.Add(FileInfo.Path);
    SubItems.Add(IntToStrSp(FileInfo.Size));
    Data := FileInfo;
    ImageIndex := GetFileIconIndex(FileInfo.FullFileName);
  end;
end;

procedure TCnProjectBackupForm.AddBackupFiles(ProjectInfo: TCnBackupProjectInfo);
var
  i: Integer;
begin
  { �����û�����ӵ��ļ��б���NameֵΪ�� }
  if (ProjectInfo.Name <> '') then
    AddBackupFile(ProjectInfo.Name, ProjectInfo);

  for i := 0 to ProjectInfo.Count - 1 do
    AddBackupFile(ProjectInfo.Name, ProjectInfo.Items[i]);
end;

{ �ú����� GExperts ��ֲ���� }

procedure TCnProjectBackupForm.UpdateBackupFileView(ProjectName: string);
var
  IProjectGroup: IOTAProjectGroup;
  IProject: IOTAProject;
  I: Integer;
begin
  lvFileView.Items.BeginUpdate;
  try
    lvFileView.Items.Clear;

    if (ProjectName = SCnProjExtProjectAll) then // ����ȫ���Ĺ�����
    begin
      IProjectGroup := CnOtaGetProjectGroup;
      if (IProjectGroup <> nil) and (IProjectGroup.ProjectCount > 1) then
        FCurrentName := CnOtaGetProjectGroupFileName
      else
        FCurrentName := CnOtaGetCurrentProjectFileName;

      AddBackupFile(ProjectList.Name, ProjectList);
      for I := 0 to ProjectList.Count - 1 do
        AddBackupFiles(ProjectList.Items[I]);
    end
    else
    begin
      if (ProjectName = SCnProjExtCurrentProject) then  // ���ݵ�ǰ������
      begin
        IProject := CnOtaGetCurrentProject;
        if (IProject = nil) then
          Exit;

        ProjectName := ExtractFileName(IProject.FileName);
        FCurrentName := IProject.FileName;
      end;

      for I := 0 to ProjectList.Count - 1 do
      begin
        if (CompareText(ProjectList.Items[i].Name, ProjectName) = 0) then
        begin
          FCurrentName := ProjectList.Items[i].GetFullFileName;
          AddBackupFiles(ProjectList.Items[I]);
        end;
      end;
    end;

    // ����û���ѡ�����ļ���
    AddBackupFiles(CustomFiles);
  finally
    lvFileView.Items.EndUpdate;
  end;
end;

procedure TCnProjectBackupForm.actCloseExecute(Sender: TObject);
begin
  Close;
end;

procedure TCnProjectBackupForm.cbbProjectListChange(Sender: TObject);
begin
  UpdateBackupFileView(cbbProjectList.Text);
  UpdateStatusBar;
end;

procedure TCnProjectBackupForm.lvFileViewCustomDrawItem(
  Sender: TCustomListView; Item: TListItem; State: TCustomDrawState;
  var DefaultDraw: Boolean);
var
  FileInfo: TCnBackupFileInfo;
begin
  if Item = nil then
    Exit;

  FileInfo := TCnBackupFileInfo(Item.Data);
  if CnOtaIsFileOpen(FileInfo.FullFileName) then
  begin
    if FileInfo.CustomFile then // ���ڴ򿪵���ѡ�����ļ�����ʾΪ��ɫ
      Sender.Canvas.Font.Color := clRed
    else
      Sender.Canvas.Font.Color := clGreen;
  end
  else
  begin
    if FileInfo.CustomFile then // ����δ�򿪵���ѡ�����ļ�����ʾΪ��ɫ
      Sender.Canvas.Font.Color := clBlue
  end;
end;

procedure TCnProjectBackupForm.actZipExecute(Sender: TObject);
var
  I: Integer;
  CompressorCommand, ListFileName, ExecCommand, VerStr: string;
  List: TStrings;
  Options: IOTAProjectOptions;
begin
  if lvFileView.Items.Count = 0 then
  begin
    ErrorDlg(SCnProjExtBackupNoFile);
    Exit;
  end;

  with TCnProjectBackupSaveForm.Create(nil) do
  try
    RemovePath := FRemovePath;
    RememberPass := FRememberPass;
    UsePassword := FUsePassword;
    UseExternal := FUseExternal;
    Compressor := FCompressor;
    CompressCmd := FCompressCmd;
    ExecAfterFile := FExecCmdFile;
    ExecAfter := FExecCmdAfterBackup;
    AfterCmd := FExecCmdString;

    if RememberPass then
      Password := FPassword;
      
    cbbTimeFormat.ItemIndex := FTimeFormatIndex;
    SavePath := MakePath(FSavePath);
    CurrentName := ChangeFileExt(ExtractFileName(FCurrentName), '');

    if not FUseExternal then
      SaveFileName := SavePath + CurrentName + FormatDateTime('_' + cbbTimeFormat.Items[FTimeFormatIndex], Date + Time) + '.zip'
    else
    begin
      FExt := GetExtFromCompressor(FCompressor);
      if FExt = '' then
        FExt := '.zip';
      SaveFileName := SavePath + CurrentName + FormatDateTime('_' + cbbTimeFormat.Items[FTimeFormatIndex], Date + Time) + FExt;
    end;

    if ShowModal = mrOK then
    begin
      Update;

      FRemovePath := RemovePath;
      FUsePassword := UsePassword;
      FRememberPass := RememberPass;
      FUseExternal := UseExternal;
      FCompressor := Compressor;
      FCompressCmd := CompressCmd;

      FExecCmdAfterBackup := ExecAfter;
      FExecCmdFile := ExecAfterFile;
      FExecCmdString := AfterCmd;

      if FRememberPass then
        FPassword := Password
      else
        FPassword := '';
        
      FSavePath := ExtractFilePath(SaveFileName);
      FTimeFormatIndex := cbbTimeFormat.ItemIndex;

      SaveFileName := LinkPath(ExtractFilePath(FCurrentName), SaveFileName);

      if FileExists(SaveFileName) and not Confirmed then
        if not QueryDlg(SCnOverwriteQuery) then
          Exit;

      // ���� Version ��Ϣ������ VerStr
      VerStr := '';
      Options := CnOtaGetActiveProjectOptions;
      if Assigned(Options) then
      begin
        try
          VerStr := Format('%d.%d.%d.%d',
            [StrToIntDef(VarToStr(Options.GetOptionValue('MajorVersion')), 0),
            StrToIntDef(VarToStr(Options.GetOptionValue('MinorVersion')), 0),
            StrToIntDef(VarToStr(Options.GetOptionValue('Release')), 0),
            StrToIntDef(VarToStr(Options.GetOptionValue('Build')), 0)]);
        except
          ;
        end;
      end;

      if FUseExternal then
      begin
        ListFileName := MakePath(GetWindowsTempPath) + 'BackupList.txt';
        List := TStringList.Create;
        try
          for I := 0 to Self.lvFileView.Items.Count - 1 do
            if Self.lvFileView.Items[I].Data <> nil then
              List.Add(TCnBackupFileInfo(Self.lvFileView.Items[I].Data).FullFileName);

          List.SaveToFile(ListFileName);
        finally
          List.Free;
        end;
        // ����������
        CompressorCommand := StringReplace(FCompressCmd, csCmdCompress, '"' + FCompressor + '"', [rfReplaceAll]);
        CompressorCommand := StringReplace(CompressorCommand, csCmdBackupFile, '"' + SaveFileName + '"', [rfReplaceAll]);
        CompressorCommand := StringReplace(CompressorCommand, csCmdListFile, '"' + ListFileName + '"', [rfReplaceAll]);
        CompressorCommand := StringReplace(CompressorCommand, csVersionInfo, '"' + VerStr + '"', [rfReplaceAll]);
        if FUsePassword then
          CompressorCommand := StringReplace(CompressorCommand, csCmdPassword, '"' + Password + '"', [rfReplaceAll])
        else
        begin
          CompressorCommand := StringReplace(CompressorCommand, '-p' + csCmdPassword, '', [rfReplaceAll]);
          CompressorCommand := StringReplace(CompressorCommand, '-s' + csCmdPassword, '', [rfReplaceAll]);
          CompressorCommand := StringReplace(CompressorCommand, csCmdPassword, '', [rfReplaceAll]);
        end;
          
        WinExecAndWait32(CompressorCommand);
      end
      else
      begin
        // �����ⲿ DLL ��ʵ��ѹ��
        if not CnWizHelperZipValid then
        begin
          ErrorDlg(SCnProjExtBackupDllMissCorrupt);
          Exit;
        end;

        Screen.Cursor := crHourGlass;
        try
          DeleteFile(SaveFileName);
          try
            CnWiz_StartZip(_CnPChar(SaveFileName), _CnPChar(Password), RemovePath);

            for I := 0 to Self.lvFileView.Items.Count - 1 do
              if Self.lvFileView.Items[I].Data <> nil then
                CnWiz_ZipAddFile(_CnPChar(TCnBackupFileInfo(Self.lvFileView.Items[I].Data).FullFileName));

            if CnWiz_ZipSaveAndClose then
              InfoDlg(Format(SCnProjExtBackupSuccFmt, [SaveFileName]));
          except
            ErrorDlg(SCnProjExtBackupFail);
          end;
        finally
          Screen.Cursor := crDefault;
        end;
      end;

      // ���ݺ���ⲿ�������֪ͨ
      if FExecCmdAfterBackup and (Trim(FExecCmdFile) <> '') then
      begin
        if FileExists(FExecCmdFile) then
        begin
          ExecCommand := StringReplace(FExecCmdString,
            csAfterCmd, '"' + FExecCmdFile + '"', [rfReplaceAll]);
          ExecCommand := StringReplace(ExecCommand,
            csCmdBackupFile, '"' + SaveFileName + '"', [rfReplaceAll]);
          ExecCommand := StringReplace(ExecCommand,
            csVersionInfo, '"' + VerStr + '"', [rfReplaceAll]);

          WinExec(PAnsiChar(AnsiString(ExecCommand)), SW_SHOW);
        end;
      end;  
    end;
  finally
    Free;
  end;
end;

procedure TCnProjectBackupForm.actRemoveFileExecute(Sender: TObject);
var
  I, J, K: Integer;
  Info: Pointer;
  Project: TCnBackupProjectInfo;
  Found: Boolean;
begin
  if Self.lvFileView.SelCount > 0 then
  begin
    for I := Self.lvFileView.Items.Count - 1 downto 0 do
    begin
      if not Self.lvFileView.Items[I].Selected then
        Continue;

      Info := Self.lvFileView.Items[I].Data;
      if Info <> nil then
      begin
        Found := False;
        for J := Self.ProjectList.Count - 1 downto 0 do
        begin
          if ProjectList.Items[J] = Info then // Ҫɾ���ǹ����ļ�
          begin
            ProjectList.Items[J].Hidden := True;
            Found := True;
            Break;
          end
          else // �ҹ����е����ļ�
          begin
            Project := ProjectList.Items[J];
            for K := Project.Count - 1 downto 0 do
            begin
              if Project.Items[K] = Info then
              begin
                Project.Delete(K);
                Found := True;
                Break;
              end;
            end;
          end;
        end;

        if not Found then
          for J := Self.CustomFiles.Count - 1 downto 0 do
            if Self.CustomFiles.Items[J] = Info then
            begin
              CustomFiles.Delete(J);
              Break;
            end;

      end;
      Self.lvFileView.Items[I].Delete;
    end;
  end;
end;

procedure TCnProjectBackupForm.actAddFileExecute(Sender: TObject);
var
  I: Integer;
  FileInfo: TCnBackupFileInfo;
begin
  if Self.dlgOpen.Execute then
  begin
    for I := 0 to Self.dlgOpen.Files.Count - 1 do
    begin
      FileInfo := TCnBackupFileInfo.Create;
      FileInfo.SetFileInfo( Self.dlgOpen.Files[I], True );
      CustomFiles.Add( FileInfo );

      AddBackupFile( SCnProjExtCustomBackupFile, FileInfo );
    end;
    UpdateBackupFileView(cbbProjectList.Text);
  end;
end;

procedure TCnProjectBackupForm.actHelpExecute(Sender: TObject);
begin
  ShowFormHelp;
end;

procedure TCnProjectBackupForm.FormKeyPress(Sender: TObject;
  var Key: Char);
begin
  if Key = #27 then
  begin
    ModalResult := mrCancel;
    Key := #0;
  end;
end;

procedure TCnProjectBackupForm.SimpleDecode(var Pass: string);
var
  Tmp: string;
  I: Integer;
begin
  if Pass <> '' then
  begin
    // ����ǷǷ����ģ������
    if (Length(Pass) mod 2) <> 0 then
    begin
      Pass := '';
      Exit;
    end
    else
    begin
      for I := 1 to Length(Pass) do
      begin
        if not CharInSet(Pass[I], ['0'..'9', 'A'..'F']) then
        begin
          Pass := '';
          Exit;
        end;
      end;
    end;
    
    Tmp := '';
    for I := 1 to ((Length(Pass) + 1) div 2) do
      Tmp := Tmp + Chr(255 - StrToInt('$' + Copy(Pass, 2 * I - 1, 2)));
  end;
  Pass := Tmp;
end;

procedure TCnProjectBackupForm.SimpleEncode(var Pass: string);
var
  Tmp: string;
  I: Integer;
begin
  if Pass <> '' then
  begin
    Tmp := '';
    for I := 1 to Length(Pass) do
      Tmp := Tmp + IntToHex(255 - Ord(Pass[I]), 2);
  end;
  Pass := Tmp;
end;

procedure TCnProjectBackupForm.lvFileViewKeyDown(Sender: TObject;
  var Key: Word; Shift: TShiftState);
begin
  if (Key = VK_DELETE) and (Shift = []) then
    Self.actRemoveFile.Execute;
end;

{$ENDIF SUPPORT_PRJ_BACKUP}

{$ENDIF CNWIZARDS_CNPROJECTEXTWIZARD}
end.
