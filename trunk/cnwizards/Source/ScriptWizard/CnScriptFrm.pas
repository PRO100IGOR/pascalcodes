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

unit CnScriptFrm;
{ |<PRE>
================================================================================
* ������ƣ�CnPack IDE ר�Ұ�
* ��Ԫ���ƣ��ű�����
* ��Ԫ���ߣ��ܾ��� (zjy@cnpack.org)
* ��    ע��
* ����ƽ̨��PWinXP SP2 + Delphi 5.01
* ���ݲ��ԣ�PWin9X/2000/XP + Delphi 5/6/7
* �� �� �����ô����е��ַ���֧�ֱ��ػ�����ʽ
* ��Ԫ��ʶ��$Id: CnScriptFrm.pas 763 2011-02-07 14:18:23Z liuxiao@cnpack.org $
* �޸ļ�¼��2006.09.20 V1.0
*               ������Ԫ
================================================================================
|</PRE>}

interface

{$I CnWizards.inc}

{$IFDEF CNWIZARDS_CNSCRIPTWIZARD}

{$IFDEF SUPPORT_PASCAL_SCRIPT}

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  ComCtrls, ToolWin, StdCtrls, ExtCtrls, IniFiles, CnCommon, CnWizMultiLang,
  CnWizIdeDock, CnScriptClasses, CnWizConsts, CnWizManager, CnWizOptions,
  CnWizUtils, CnWizIdeUtils, CnOTACreators, CnWizNotifier, ToolsAPI, Menus,
  Contnrs, uPSComponent, uPSCompiler, uPSRuntime;

type
  TCnScriptMode = (smManual, smIDELoaded, smFileNotify, smBeforeCompile,
    smAfterCompile, smSourceEditorNotify, smFormEditorNotify);
  TCnScriptModeSet = set of TCnScriptMode;

{$M+} // Generate RTTI
  TCnScriptEvent = class
  private
    FMode: TCnScriptMode;
  public
    constructor Create(AMode: TCnScriptMode);
  published
    property Mode: TCnScriptMode read FMode;
  end;
{$M-}

  TCnScriptManual = class(TCnScriptEvent)
  public
    constructor Create;
  end;

  TCnScriptIDELoaded = class(TCnScriptEvent)
  public
    constructor Create;
  end;

  TCnScriptFileNotify = class(TCnScriptEvent)
  private
    FFileName: string;
    FFileNotifyCode: TOTAFileNotification;
  public
    constructor Create(AFileNotifyCode: TOTAFileNotification; AFileName: string);
  published
    property FileNotifyCode: TOTAFileNotification read FFileNotifyCode;
    property FileName: string read FFileName;
  end;

  TCnScriptBeforeCompile = class(TCnScriptEvent)
  private
    FCancel: Boolean;
    FProject: IOTAProject;
  public
    constructor Create(AProject: IOTAProject; ACancel: Boolean);
  published
    property Project: IOTAProject read FProject;
    property Cancel: Boolean read FCancel write FCancel;
  end;

  TCnScriptAfterCompile = class(TCnScriptEvent)
  private
    FSucceeded: Boolean;
  public
    constructor Create(ASucceeded: Boolean);
  published
    property Succeeded: Boolean read FSucceeded;
  end;

  TCnScriptSourceEditorNotify = class(TCnScriptEvent)
  private
    FEditView: IOTAEditView;
    FSourceEditor: IOTASourceEditor;
    FNotifyType: TCnWizSourceEditorNotifyType;
  public
    constructor Create(ASourceEditor: IOTASourceEditor;
      ANotifyType: TCnWizSourceEditorNotifyType; AEditView: IOTAEditView);
  published
    property SourceEditor: IOTASourceEditor read FSourceEditor;
    property NotifyType: TCnWizSourceEditorNotifyType read FNotifyType;
    property EditView: IOTAEditView read FEditView;
  end;

  TCnScriptFormEditorNotify = class(TCnScriptEvent)
  private
    FFormEditor: IOTAFormEditor;
    FOldName: string;
    FNewName: string;
    FNotifyType: TCnWizFormEditorNotifyType;
    FComponent: TComponent;
  public
    constructor Create(AFormEditor: IOTAFormEditor;
      ANotifyType: TCnWizFormEditorNotifyType; AComponent: TComponent;
      const AOldName, ANewName: string);
  published
    property FormEditor: IOTAFormEditor read FFormEditor;
    property NotifyType: TCnWizFormEditorNotifyType read FNotifyType;
    property Component: TComponent read FComponent;
    property OldName: string read FOldName;
    property NewName: string read FNewName;
  end;

  TCnScriptCreator = class(TCnTemplateModuleCreator)
  protected
    function GetTemplateFile(FileType: TCnSourceType): string; override;
    procedure DoReplaceTagsSource(const TagString: string; TagParams: TStrings;
      var ReplaceText: string; ASourceType: TCnSourceType; ModuleIdent, FormIdent,
      AncestorIdent: string); override;
  public
    function GetImplFileName: string; override;
    function GetShowSource: Boolean; override;
    function GetOwner: IOTAModule; override;
    function GetUnnamed: Boolean; override;
  end;

  TCnScriptForm = class(TCnIdeDockForm)
    tlb1: TToolBar;
    mmoOut: TMemo;
    btnLoad: TToolButton;
    btnNew: TToolButton;
    btnRun: TToolButton;
    btn5: TToolButton;
    btnCompile: TToolButton;
    btn7: TToolButton;
    btnHelp: TToolButton;
    btnClose: TToolButton;
    btnAddToList: TToolButton;
    pmHelp: TPopupMenu;
    mniHelp: TMenuItem;
    mniDeclDir: TMenuItem;
    mniN1: TMenuItem;
    mniDemoDir: TMenuItem;
    pmRun: TPopupMenu;
    mniRun: TMenuItem;
    mniN2: TMenuItem;
    btn1: TToolButton;
    btnOption: TToolButton;
    pmOpen: TPopupMenu;
    dlgOpenFile: TOpenDialog;
    btnClear: TToolButton;
    procedure FormDestroy(Sender: TObject);
    procedure btnNewClick(Sender: TObject);
    procedure btnLoadClick(Sender: TObject);
    procedure btnCloseClick(Sender: TObject);
    procedure btnRunClick(Sender: TObject);
    procedure btnAddToListClick(Sender: TObject);
    procedure mniHelpClick(Sender: TObject);
    procedure mniDeclDirClick(Sender: TObject);
    procedure mniDemoDirClick(Sender: TObject);
    procedure pmRunPopup(Sender: TObject);
    procedure pmOpenPopup(Sender: TObject);
    procedure btnOptionClick(Sender: TObject);
    procedure btnCompileClick(Sender: TObject);
    procedure btnClearClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
  private
    { Private declarations }
    FDemoFiles: TStrings;
    FEngineList: TObjectList;
    procedure DemoFindCallBack(const FileName: string; const Info: TSearchRec;
      var Abort: Boolean);
    procedure OutputMessages(Engine: TCnScriptExec; const AName: string);
    procedure GotoErrorCode(Engine: TCnScriptExec; const AName, ModuleName:
      string; Col, Row: Integer);
    procedure DoExec(const AFileName: string; CompileOnly: Boolean;
      AScriptEvent: TCnScriptEvent);
    procedure DoManualExec(const AFileName: string; CompileOnly: Boolean);
    procedure OnCompImport(Sender: TObject; x: TIFPSPascalcompiler);
    procedure OnScriptExecute(Sender: TPSScript);
    procedure OnExecImport(Sender: TObject; Exec: TIFPSExec;
      x: TIFPSRuntimeClassImporter);
    procedure OnScriptCompile(Sender: TPSScript);
    procedure OnOpenFile(Sender: TObject);
    procedure OnOpenDemoFile(Sender: TObject);
  protected
    function GetHelpTopic: string; override;
  public
    { Public declarations }
    procedure OnReadln(const Prompt: string; var Text: string);
    procedure OnWriteln(const Text: string);
    function CreateEngine: TCnScriptExec;
    procedure ClearEngineList;
  end;

  TCnScriptFormMgr = class
  private
    FActive: Boolean;
    procedure SetActive(Value: Boolean);
  public
    constructor Create;
    destructor Destroy; override;
    function Execute(Show: Boolean): Boolean;
    procedure ClearEngineList;
    procedure ExecuteScript(AFileName: string; AScriptEvent: TCnScriptEvent);
    property Active: Boolean read FActive write SetActive;
  end;

var
  CnScriptForm: TCnScriptForm = nil;

function ScriptEvent: TCnScriptEvent;

{$ENDIF}

{$ENDIF CNWIZARDS_CNSCRIPTWIZARD}

implementation

{$IFDEF CNWIZARDS_CNSCRIPTWIZARD}

{$IFDEF SUPPORT_PASCAL_SCRIPT}

{$R *.DFM}

uses
{$IFDEF DEBUG}
  CnDebug,
{$ENDIF}
  CnScriptWizard;

var
  _ScripEvent: TCnScriptEvent;
  _ScriptFormDestroyed: Boolean = False;
  _DestroyingScriptForm: Boolean = False;

function ScriptEvent: TCnScriptEvent;
begin
  Result := _ScripEvent;
end;
  
{ TCnScriptEvent }

constructor TCnScriptEvent.Create(AMode: TCnScriptMode);
begin
  FMode := AMode;
end;

{ TCnScriptManual }

constructor TCnScriptManual.Create;
begin
  inherited Create(smManual);
end;

{ TCnScriptIDELoaded }

constructor TCnScriptIDELoaded.Create;
begin
  inherited Create(smIDELoaded);
end;

{ TCnScriptFileNotify }

constructor TCnScriptFileNotify.Create(
  AFileNotifyCode: TOTAFileNotification; AFileName: string);
begin
  inherited Create(smFileNotify);
  FFileNotifyCode := AFileNotifyCode;
  FFileName := AFileName;
end;

{ TCnScriptBeforeCompile }

constructor TCnScriptBeforeCompile.Create(AProject: IOTAProject; ACancel: Boolean);
begin
  inherited Create(smBeforeCompile);
  FProject := AProject;
  FCancel := ACancel;
end;

{ TCnScriptAfterCompile }

constructor TCnScriptAfterCompile.Create(ASucceeded: Boolean);
begin
  inherited Create(smAfterCompile);
  FSucceeded := ASucceeded;
end;

{ TCnScriptSourceEditorNotify }

constructor TCnScriptSourceEditorNotify.Create(
  ASourceEditor: IOTASourceEditor;
  ANotifyType: TCnWizSourceEditorNotifyType; AEditView: IOTAEditView);
begin
  inherited Create(smSourceEditorNotify);
  FSourceEditor := ASourceEditor;
  FNotifyType := ANotifyType;
  FEditView := AEditView;
end;

{ TCnScriptFormEditorNotify }

constructor TCnScriptFormEditorNotify.Create(AFormEditor: IOTAFormEditor;
  ANotifyType: TCnWizFormEditorNotifyType; AComponent: TComponent;
  const AOldName, ANewName: string);
begin
  inherited Create(smFormEditorNotify);
  FFormEditor := AFormEditor;
  FNotifyType := ANotifyType;
  FComponent := AComponent;
  FOldName := AOldName;
  FNewName := ANewName; 
end;

{ TCnScriptCreator }

procedure TCnScriptCreator.DoReplaceTagsSource(const TagString: string;
  TagParams: TStrings; var ReplaceText: string; ASourceType: TCnSourceType;
  ModuleIdent, FormIdent, AncestorIdent: string);
begin
  inherited;

end;

function TCnScriptCreator.GetImplFileName: string;
var
  Dir: string;
  i: Integer;
begin
  Dir := MakePath(WizOptions.UserPath) + SCnScriptFileDir;
  ForceDirectories(Dir);
  ChDir(Dir);
  i := 1;
  repeat
    Result := MakePath(Dir) + Format(SCnScriptDefName, [i]);
    Inc(i);
  until not FileExists(Result);
end;

function TCnScriptCreator.GetOwner: IOTAModule;
begin
  Result := nil;
end;

function TCnScriptCreator.GetShowSource: Boolean;
begin
  Result := True;
end;

function TCnScriptCreator.GetTemplateFile(FileType: TCnSourceType): string;
begin
  if FileType = stImplSource then
    Result := MakePath(WizOptions.TemplatePath) + SCnScriptTemplateFileName
  else
    Result := '';
end;

function TCnScriptCreator.GetUnnamed: Boolean;
begin
  Result := True;
end;

{ TCnScriptForm }

procedure TCnScriptForm.FormCreate(Sender: TObject);
begin
  inherited;
  FEngineList := TObjectList.Create(True);
end;

procedure TCnScriptForm.FormDestroy(Sender: TObject);
begin
  FEngineList.Free;
  CnScriptForm := nil;
  if not _DestroyingScriptForm then
  begin
    _ScriptFormDestroyed := True;
  end;  
  inherited;
end;

function TCnScriptForm.CreateEngine: TCnScriptExec;
var
  Wizard: TCnScriptWizard;
begin
  Result := TCnScriptExec.Create;
  Result.OnCompile := OnScriptCompile;
  Result.OnExecute := OnScriptExecute;
  Result.OnCompImport := OnCompImport;
  Result.OnExecImport := OnExecImport;
  Result.OnReadln := OnReadln;
  Result.OnWriteln := OnWriteln;
  Wizard := TCnScriptWizard(CnWizardMgr.WizardByClass(TCnScriptWizard));
  if Wizard <> nil then
    Result.SearchPath.Assign(Wizard.SearchPath);
end;

procedure TCnScriptForm.btnNewClick(Sender: TObject);
var
  Module: IOTAModule;
  SourceEditor: IOTASourceEditor;
begin
  Module := (BorlandIDEServices as IOTAModuleServices).CreateModule(TCnScriptCreator.Create);
  SourceEditor := CnOtaGetSourceEditorFromModule(Module);
  if Assigned(SourceEditor) then
    SourceEditor.Show;
end;

procedure TCnScriptForm.btnLoadClick(Sender: TObject);
begin
  if dlgOpenFile.Execute then
    CnOtaOpenFile(dlgOpenFile.FileName);
end;

procedure TCnScriptForm.btnOptionClick(Sender: TObject);
var
  Wizard: TCnScriptWizard;
begin
  Wizard := TCnScriptWizard(CnWizardMgr.WizardByClass(TCnScriptWizard));
  if Wizard <> nil then
  begin
    Wizard.Config;
  end;
end;

procedure TCnScriptForm.btnAddToListClick(Sender: TObject);
var
  FName: string;
  Wizard: TCnScriptWizard;
begin
  FName := CnOtaGetCurrentSourceFile;
  if FName <> '' then
  begin
    Wizard := TCnScriptWizard(CnWizardMgr.WizardByClass(TCnScriptWizard));
    if Wizard <> nil then
    begin
      Wizard.AddScript(FName);
    end;
  end;
end;

procedure TCnScriptForm.btnClearClick(Sender: TObject);
begin
  mmoOut.Clear;
end;

procedure TCnScriptForm.mniHelpClick(Sender: TObject);
begin
  ShowFormHelp;
end;

procedure TCnScriptForm.mniDeclDirClick(Sender: TObject);
begin
  ExploreDir(WizOptions.DllPath + SCnScriptDeclDir);
end;

procedure TCnScriptForm.mniDemoDirClick(Sender: TObject);
begin
  ExploreDir(WizOptions.DllPath + SCnScriptDemoDir);
end;

procedure TCnScriptForm.pmRunPopup(Sender: TObject);
var
  Wizard: TCnScriptWizard;
  Menu: TMenuItem;
  i: Integer;
begin
  Wizard := TCnScriptWizard(CnWizardMgr.WizardByClass(TCnScriptWizard));
  if Wizard <> nil then
  begin
    while pmRun.Items.Count > 2 do
      pmRun.Items[2].Free;
    for i := 2 to Wizard.SubActionCount - 1 do
    begin
      Menu := TMenuItem.Create(pmRun.Items);
      Menu.Action := Wizard.SubActions[i];
      pmRun.Items.Add(Menu);
    end;
  end;
end;

procedure TCnScriptForm.OnOpenFile(Sender: TObject);
var
  Wizard: TCnScriptWizard;
  FileName: string;
begin
  if (Sender = nil) or not (Sender is TMenuItem) then
    Exit;

  Wizard := TCnScriptWizard(CnWizardMgr.WizardByClass(TCnScriptWizard));
  if Wizard <> nil then
  begin
    FileName := Wizard.Scripts[TMenuItem(Sender).Tag].FileName;
    if FileExists(FileName) then
      CnOtaOpenFile(FileName)
    else
      ErrorDlg(SCnScriptFileNotExists);
  end;
end;

procedure TCnScriptForm.OnOpenDemoFile(Sender: TObject);
var
  FileName: string;
begin
  if (Sender = nil) or not (Sender is TMenuItem) then
    Exit;

  FileName := TMenuItem(Sender).Hint;
  if FileExists(FileName) then
    CnOtaOpenFile(FileName)
  else
    ErrorDlg(SCnScriptFileNotExists);
end;

procedure TCnScriptForm.DemoFindCallBack(const FileName: string; const Info: TSearchRec;
  var Abort: Boolean);
begin
  FDemoFiles.Add(ExtractFileName(FileName));
end;

procedure TCnScriptForm.pmOpenPopup(Sender: TObject);
var
  Wizard: TCnScriptWizard;
  Menu: TMenuItem;
  i: Integer;

  procedure LoadDemoNamesToMenu(Menu: TMenuItem);
  var
    Item: TMenuItem;
    I: Integer;
  begin
    FDemoFiles := TStringList.Create;
    try
      FindFile(WizOptions.DllPath + SCnScriptDemoDir, '*.pas', DemoFindCallBack);
      if FDemoFiles.Count > 0 then
      begin
        for I := 0 to FDemoFiles.Count - 1 do
        begin
          Item := TMenuItem.Create(Menu);
          Item.Caption := FDemoFiles[I];
          Item.Hint := MakePath(WizOptions.DllPath + SCnScriptDemoDir) + FDemoFiles[I];
          Item.OnClick := OnOpenDemoFile;
          Menu.Add(Item);
        end;
      end
      else
      begin
        Menu.Visible := False;
      end;
    finally
      FreeAndNil(FDemoFiles);
    end;
  end;
begin
  Wizard := TCnScriptWizard(CnWizardMgr.WizardByClass(TCnScriptWizard));
  if Wizard <> nil then
  begin
    while pmOpen.Items.Count > 0 do
      pmOpen.Items[0].Free;

    Menu := TMenuItem.Create(pmOpen.Items);
    Menu.Caption := SCnScriptMenuDemoCaption;
    Menu.Hint := SCnScriptMenuDemoHint;
    pmOpen.Items.Add(Menu);

    LoadDemoNamesToMenu(Menu);

    Menu := TMenuItem.Create(pmOpen.Items);
    Menu.Caption := '-';
    pmOpen.Items.Add(Menu);
    for i := 0 to Wizard.Scripts.Count - 1 do
    begin
      Menu := TMenuItem.Create(pmOpen.Items);
      Menu.Caption := Wizard.Scripts[i].Name;
      Menu.Hint := Wizard.Scripts[i].Comment;
      Menu.Tag := i;
      Menu.OnClick := OnOpenFile;
      pmOpen.Items.Add(Menu);
    end;
  end;
end;

procedure TCnScriptForm.GotoErrorCode(Engine: TCnScriptExec;
  const AName, ModuleName: string; Col, Row: Integer);
var
  MName: string;
begin
  if (AName <> '') and CnOtaOpenFile(AName) then
  begin
    if ModuleName <> '' then
    begin
      if Engine.FindFileInSearchPath(AName, ModuleName, MName) and
        CnOtaOpenFile(MName) then
        CnOtaGotoEditPos(OTAEditPos(Col, Row));
    end
    else
      CnOtaGotoEditPos(OTAEditPos(Col, Row));
  end;
end;

procedure TCnScriptForm.OutputMessages(Engine: TCnScriptExec; const AName: string);
var
  i: Longint;
  b: Boolean;
begin
  b := False;
  for i := 0 to Engine.Engine.CompilerMessageCount - 1 do
  begin
    mmoOut.Lines.Add(SCnScriptCompiler + ': ' + string(Engine.Engine.CompilerErrorToStr(i)));
    if (not b) and (Engine.Engine.CompilerMessages[i] is TIFPSPascalCompilerError) then
    begin
      b := True;
      with TIFPSPascalCompilerError(Engine.Engine.CompilerMessages[i]) do
        GotoErrorCode(Engine, AName, string(ModuleName), Col, Row);
    end;
  end;
end;

procedure TCnScriptForm.DoExec(const AFileName: string; CompileOnly: Boolean;
  AScriptEvent: TCnScriptEvent);
var
  CompileSucc: Boolean;
  Engine: TCnScriptExec;
  ScriptText: string;
  NeedCompile: Boolean;
  i: Integer;

  procedure AddLog(const Msg: string; ManualOnly: Boolean = True);
  begin
    if not ManualOnly or (AScriptEvent.Mode = smManual) then
      mmoOut.Lines.Add(Msg);
  end;
begin
{$IFDEF DEBUG}
  CnDebugger.LogFmt('Exec Script: %s', [AFileName]);
  CnDebugger.LogObject(AScriptEvent);
{$ENDIF}
  if AScriptEvent.Mode = smManual then
    mmoOut.Lines.Clear;

  Engine := nil;
  for i := 0 to FEngineList.Count - 1 do
  begin
    if SameFileName(TCnScriptExec(FEngineList[i]).ScripFile, AFileName) then
    begin
      Engine := TCnScriptExec(FEngineList[i]);
      Break;
    end;
  end;

  if Engine = nil then
  begin
    Engine := CreateEngine;
    Engine.Engine.Script.Text := string(IdeGetSourceByFileName(AFileName));
    Engine.ScripFile := AFileName;
    FEngineList.Add(Engine);
    NeedCompile := True;
  end
  else
  begin
    ScriptText := string(IdeGetSourceByFileName(AFileName));
    // ��ֹ�ַ���תΪ�б�����ݱ��
    with TStringList.Create do
    try
      Text := ScriptText;
      ScriptText := Text;
    finally
      Free;
    end;
    
    if (Engine.Engine.Script.Text = '') or
      not AnsiSameStr(ScriptText, Engine.Engine.Script.Text) then
    begin
      Engine.Engine.Script.Text := ScriptText;
      NeedCompile := True;
    end
    else
      NeedCompile := False;
  end;

  if NeedCompile then
  begin
    AddLog(SCnScriptCompiling);
    try
      CompileSucc := Engine.Engine.Compile;
    except
      on E: Exception do
      begin
        AddLog(SCnScriptCompiler + ': ' + E.Message, False);
        CompileSucc := False;
      end;
    end;

    if CompileSucc then
    begin
      if AScriptEvent.Mode = smManual then
        OutputMessages(Engine, AFileName);
      AddLog(SCnScriptCompiledSucc);
    end
    else
    begin
      Engine.Engine.Script.Clear;
      IdeDockManager.ShowForm(CnScriptForm);
      if AScriptEvent.Mode = smManual then
        OutputMessages(Engine, AFileName);
      AddLog(SCnScriptCompilingFailed);
      Exit;
    end;
  end
  else
  begin
    AddLog(SCnScriptCompiledSucc);
  end;

  if not CompileOnly then
  begin
    _ScripEvent := AScriptEvent;
    try
      if not Engine.Engine.Execute then
      begin
        IdeDockManager.ShowForm(CnScriptForm);
        AddLog(Format(SCnScriptErrorMsg,
          [Engine.Engine.ExecErrorToString,
          Engine.Engine.ExecErrorProcNo,
          Engine.Engine.ExecErrorByteCodePosition]), False);
        with Engine.Engine do
          GotoErrorCode(Engine, AFileName, string(ExecErrorFileName), ExecErrorCol,
            ExecErrorRow);
      end
      else
        AddLog(SCnScriptExecutedSucc);
    finally
      _ScripEvent := nil;
    end;
  end;
end;

procedure TCnScriptForm.DoManualExec(const AFileName: string;
  CompileOnly: Boolean);
var
  Event: TCnScriptEvent;
begin
  Event := TCnScriptManual.Create;
  try
    DoExec(AFileName, CompileOnly, Event);
  finally
    Event.Free;
  end;
end;

procedure TCnScriptForm.ClearEngineList;
begin
  FEngineList.Clear;
end;

procedure TCnScriptForm.btnCompileClick(Sender: TObject);
begin
  DoManualExec(CnOtaGetCurrentSourceFile, True);
end;

procedure TCnScriptForm.btnRunClick(Sender: TObject);
begin
  DoManualExec(CnOtaGetCurrentSourceFile, False);
end;

procedure TCnScriptForm.btnCloseClick(Sender: TObject);
begin
  Close;
end;

function TCnScriptForm.GetHelpTopic: string;
begin
  Result := 'CnScriptWizard';
end;

procedure TCnScriptForm.OnCompImport(Sender: TObject;
  x: TIFPSPascalcompiler);
begin
  //
end;

procedure TCnScriptForm.OnScriptCompile(Sender: TPSScript);
begin
  //
end;

procedure TCnScriptForm.OnExecImport(Sender: TObject;
  Exec: TIFPSExec; x: TIFPSRuntimeClassImporter);
begin
  //
end;

procedure TCnScriptForm.OnScriptExecute(Sender: TPSScript);
begin
  //
end;

procedure TCnScriptForm.OnReadln(const Prompt: string; var Text: string);
begin
  Text := CnInputBox('Script', Prompt, '');
end;

procedure TCnScriptForm.OnWriteln(const Text: string);
begin
  IdeDockManager.ShowForm(CnScriptForm);
  mmoOut.Lines.Add(Text);
end;

{ TCnScriptFormMgr }

procedure TCnScriptFormMgr.ClearEngineList;
begin
  if CnScriptForm <> nil then
    CnScriptForm.ClearEngineList;
end;

constructor TCnScriptFormMgr.Create;
begin
  inherited;
  FActive := True;
  IdeDockManager.RegisterDockableForm(TCnScriptForm, CnScriptForm,
    'CnScriptForm');
end;

destructor TCnScriptFormMgr.Destroy;
begin
  _DestroyingScriptForm := True;
  try
    IdeDockManager.UnRegisterDockableForm(CnScriptForm, 'CnScriptForm');
    if CnScriptForm <> nil then
    begin
      CnScriptForm.Free;
      CnScriptForm := nil;
    end;
  finally
    _DestroyingScriptForm := False;
  end;
  inherited;
end;

function TCnScriptFormMgr.Execute(Show: Boolean): Boolean;
begin
  if _ScriptFormDestroyed then
    Result := False
  else
  begin
    if CnScriptForm = nil then
    begin
      CnScriptForm := TCnScriptForm.Create(nil);
    end;
    if Show then
      IdeDockManager.ShowForm(CnScriptForm);
    Result := True;
  end;      
end;

procedure TCnScriptFormMgr.ExecuteScript(AFileName: string; AScriptEvent: TCnScriptEvent);
begin
  if Active and Execute(False) then
    CnScriptForm.DoExec(AFileName, False, AScriptEvent);
end;

procedure TCnScriptFormMgr.SetActive(Value: Boolean);
begin
  if Value <> FActive then
  begin
    FActive := Value;
    if Value then
    begin
      IdeDockManager.RegisterDockableForm(TCnScriptForm, CnScriptForm,
        'CnScriptForm');
    end
    else
    begin
      _DestroyingScriptForm := True;
      try
        IdeDockManager.UnRegisterDockableForm(CnScriptForm, 'CnScriptForm');
        if CnScriptForm <> nil then
        begin
          CnScriptForm.Free;
          CnScriptForm := nil;
        end;
      finally
        _DestroyingScriptForm := False;
      end;                      
    end;
  end;
end;

{$ENDIF}

{$ENDIF CNWIZARDS_CNSCRIPTWIZARD}
end.
