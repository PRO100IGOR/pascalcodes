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

unit CnEditorWizard;
{* |<PRE>
================================================================================
* ������ƣ�CnPack IDE ר�Ұ�
* ��Ԫ���ƣ��༭��ר�ҵ�Ԫ
* ��Ԫ���ߣ��ܾ��� (zjy@cnpack.org)
* ��    ע��
* ����ƽ̨��PWin2000Pro + Delphi 5.01
* ���ݲ��ԣ�PWin9X/2000/XP + Delphi 5/6/7 + C++Builder 5/6
* �� �� �����ô����е��ַ��������ϱ��ػ�����ʽ
* ��Ԫ��ʶ��$Id: CnEditorWizard.pas 763 2011-02-07 14:18:23Z liuxiao@cnpack.org $
* �޸ļ�¼��2002.12.03 V1.0
*               ������Ԫ��ʵ�ֹ���
================================================================================
|</PRE>}

interface

{$I CnWizards.inc}

{$IFDEF CNWIZARDS_CNEDITORWIZARD}

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs, Menus,
  StdCtrls, ComCtrls, IniFiles, ToolsAPI, Registry, CnWizClasses, CnConsts, CnIni,
  CnWizConsts, CnWizMenuAction, ExtCtrls, CnWizMultiLang, CnWizManager;

type

{ TCnEditorForm }

  TCnEditorWizard = class;

  TCnEditorToolsForm = class(TCnTranslateForm)
    btnHelp: TButton;
    btnOK: TButton;
    grp1: TGroupBox;
    lbl1: TLabel;
    lbl2: TLabel;
    lblToolName: TLabel;
    imgIcon: TImage;
    bvlWizard: TBevel;
    lbl3: TLabel;
    lblToolAuthor: TLabel;
    lvTools: TListView;
    mmoComment: TMemo;
    chkEnabled: TCheckBox;
    HotKey: THotKey;
    btnConfig: TButton;
    procedure FormCreate(Sender: TObject);
    procedure lvToolsDblClick(Sender: TObject);
    procedure HotKeyExit(Sender: TObject);
    procedure chkEnabledClick(Sender: TObject);
    procedure btnConfigClick(Sender: TObject);
    procedure btnHelpClick(Sender: TObject);
    procedure lvToolsChange(Sender: TObject; Item: TListItem;
      Change: TItemChange);
  private
    { Private declarations }
    FWizard: TCnEditorWizard;
    procedure InitTools;
    procedure UpdateToolItem(Index: Integer);
  protected
    function GetHelpTopic: string; override;
  public
    { Public declarations }
  end;

{ TCnEditorWizard }

{$M+}

  TCnBaseEditorTool = class(TObject)
  private
    FActive: Boolean;
    FOwner: TCnEditorWizard;
    FAction: TCnWizMenuAction;
  protected
    function GetIDStr: string;
    procedure SetActive(Value: Boolean); virtual;
    {* Active ����д�������������ظ÷������� Active ���Ա���¼�}
    function GetHasConfig: Boolean; virtual;
    {* HasConfig ���Զ��������������ظ÷��������Ƿ���ڿ���������}
    function GetCaption: string; virtual; abstract;
    {* ���ع��ߵı���}
    function GetHint: string; virtual;
    {* ���ع��ߵ�Hint��ʾ}
    function GetDefShortCut: TShortCut; virtual;
    {* ���ع��ߵ�Ĭ�Ͽ�ݼ���ʵ��ʹ��ʱ���ߵĿ�ݼ�������ɹ��������趨������
       ֻ��Ҫ����Ĭ�ϵľ����ˡ�}
    function CreateIniFile: TCustomIniFile;
    {* ����һ�����ڴ�ȡ�������ò����� INI �����û�ʹ�ú����Լ��ͷ�}
    property Owner: TCnEditorWizard read FOwner;
  public
    constructor Create(AOwner: TCnEditorWizard); virtual;
    destructor Destroy; override;
    function GetEditorName: string;
    procedure LoadSettings(Ini: TCustomIniFile); virtual;
    {* װ�ع������÷������������ش˷����� INI �����ж�ȡר�Ҳ��� }
    procedure SaveSettings(Ini: TCustomIniFile); virtual;
    {* ���湤�����÷�������������Щ������ר�Ҳ������浽 INI ������ }
    function GetState: TWizardState; virtual;
    {* ���ع���״̬��IOTAWizard �������������ظ÷������ع���״̬}
    procedure Execute; virtual; abstract;
    {* ���û�ִ��һ������ʱ�������ø÷�����}
    procedure Config; virtual;
    {* ���÷������ɹ����������ý����е��ã��� HasConfig Ϊ��ʱ��Ч}
    procedure Loaded; virtual;
    {* IDE ������ɺ���ø÷���}
    procedure GetEditorInfo(var Name, Author, Email: string); virtual; abstract;
    {* ȡ������Ϣ�������ṩ���ߵ�˵���Ͱ�Ȩ��Ϣ�����󷽷����������ʵ�֡�
     |<PRE>
       var AName: string      - �������ƣ�������֧�ֱ��ػ����ַ���
       var Author: string     - �������ߣ�����ж�����ߣ��÷ֺŷָ�
       var Email: string      - �����������䣬����ж�����ߣ��÷ֺŷָ�
     |</PRE>}
    procedure RefreshAction; virtual;
    {* ���¸��� Action ������ }
    procedure ParentActiveChanged(ParentActive: Boolean); virtual;
    {* �༭��ר��״̬�ı�ʱ������ }
    property Active: Boolean read FActive write SetActive;
    {* ��Ծ���ԣ��������ߵ�ǰ�Ƿ����}
    property HasConfig: Boolean read GetHasConfig;
    {* ��ʾ�����Ƿ�������ý��������}
  end;

{$M-}

  TCnEditorToolClass = class of TCnBaseEditorTool;

{ TCnEditorWizard }

  TCnEditorWizard = class(TCnSubMenuWizard)
  private
    FConfigIndex: Integer;
    FEditorIndex: Integer;
    FEditorTools: TList;

    procedure UpdateActions;
    function GetEditorTools(Index: Integer): TCnBaseEditorTool;
    function GetEditorToolCount: Integer;
  protected
    function GetHasConfig: Boolean; override;
    procedure SetActive(Value: Boolean); override;
    procedure SubActionExecute(Index: Integer); override;
    procedure SubActionUpdate(Index: Integer); override;
  public
    constructor Create; override;
    destructor Destroy; override;
    procedure AcquireSubActions; override;
    procedure RefreshSubActions; override;
    procedure Execute; override;
    procedure Config; override;
    procedure Loaded; override;
    procedure LoadSettings(Ini: TCustomIniFile); override;
    procedure SaveSettings(Ini: TCustomIniFile); override;
    function GetState: TWizardState; override;
    class procedure GetWizardInfo(var Name, Author, Email, Comment: string); override;
    function GetCaption: string; override;
    function GetHint: string; override;
    property EditorTools[Index: Integer]: TCnBaseEditorTool read GetEditorTools;
    property EditorToolCount: Integer read GetEditorToolCount;
  end;

procedure RegisterCnEditor(const AClass: TCnEditorToolClass);
{* ע��һ�� CnEditorTool �༭�����������ã�ÿ���༭��������ʵ�ֵ�Ԫ
   Ӧ�ڸõ�Ԫ�� initialization �ڵ��øù���ע��༭��������}

function GetCnEditorToolClass(const ClassName: string): TCnEditorToolClass;
{* ���ݱ༭����������ȡָ���ı༭������������}

function GetCnEditorToolClassCount: Integer;
{* ������ע��ı༭������������}

function GetCnEditorToolClassByIndex(const Index: Integer): TCnEditorToolClass;
{* ����������ȡָ���ı༭������������}

{$ENDIF CNWIZARDS_CNEDITORWIZARD}

implementation

{$IFDEF CNWIZARDS_CNEDITORWIZARD}

uses
{$IFDEF DEBUG}
  CnDebug,
{$ENDIF}
  CnWizOptions, CnWizUtils, CnWizShortCut, CnCommon, CnWizCommentFrm;

{$R *.DFM}

var
  CnEditorClassList: TList = nil; // �༭�������������б�

// ע��һ�� CnEditorTool �༭������������
procedure RegisterCnEditor(const AClass: TCnEditorToolClass);
begin
  Assert(CnEditorClassList <> nil, 'CnEditorClassList is nil!');
  if CnEditorClassList.IndexOf(AClass) < 0 then
    CnEditorClassList.Add(AClass);
end;

// ���ݱ༭����������ȡָ���ı༭������������
function GetCnEditorToolClass(const ClassName: string): TCnEditorToolClass;
var
  i: Integer;
begin
  Result := nil;
  for i := 0 to CnEditorClassList.Count - 1 do
  begin
    Result := CnEditorClassList[i];
    if Result.ClassNameIs(ClassName) then Exit;
  end;
end;

// ������ע��ı༭������������
function GetCnEditorToolClassCount: Integer;
begin
  Result := CnEditorClassList.Count;
end;

// ����������ȡָ���ı༭������������
function GetCnEditorToolClassByIndex(const Index: Integer): TCnEditorToolClass;
begin
  Result := nil;
  if (Index >= 0) and (Index <= CnEditorClassList.Count - 1) then
    Result := CnEditorClassList[Index];
end;

{ TCnBaseEditorTool }

procedure TCnBaseEditorTool.Config;
begin

end;

constructor TCnBaseEditorTool.Create(AOwner: TCnEditorWizard);
begin
  inherited Create;
  Assert(Assigned(AOwner));
  FOwner := AOwner;
  FActive := True;
  FAction := nil;
end;

function TCnBaseEditorTool.CreateIniFile: TCustomIniFile;
begin
  Result := TRegistryIniFile.Create(MakePath(WizOptions.RegPath) + Owner.GetIDStr +
    '\' + GetIDStr, KEY_ALL_ACCESS);
end;

destructor TCnBaseEditorTool.Destroy;
begin
  inherited;

end;

procedure TCnBaseEditorTool.Loaded;
begin

end;

procedure TCnBaseEditorTool.LoadSettings(Ini: TCustomIniFile);
begin
  with TCnIniFile.Create(Ini) do
  try
    ReadObject('', Self);
  finally
    Free;
  end;   
end;

procedure TCnBaseEditorTool.SaveSettings(Ini: TCustomIniFile);
begin
  with TCnIniFile.Create(Ini) do
  try
    WriteObject('', Self);
  finally
    Free;
  end;   
end;

function TCnBaseEditorTool.GetDefShortCut: TShortCut;
begin
  Result := 0;
end;

function TCnBaseEditorTool.GetIDStr: string;
begin
  Result := ClassName;
  if UpperCase(Result[1]) = 'T' then
    Delete(Result, 1, 1);
end;

function TCnBaseEditorTool.GetHasConfig: Boolean;
begin
  Result := False;
end;

function TCnBaseEditorTool.GetHint: string;
begin
  Result := '';
end;

function TCnBaseEditorTool.GetEditorName: string;
var
  Author, Email: string;
begin
  GetEditorInfo(Result, Author, Email);
end;

function TCnBaseEditorTool.GetState: TWizardState;
begin
  if Owner.Active and Active then
    Result := [wsEnabled]
  else
    Result := [];
end;

procedure TCnBaseEditorTool.SetActive(Value: Boolean);
begin
  FActive := Value;
end;

procedure TCnBaseEditorTool.RefreshAction;
begin
  if FAction <> nil then
  begin
    FAction.Caption := GetCaption;
    FAction.Hint := GetHint;
  end;
end;

procedure TCnBaseEditorTool.ParentActiveChanged(ParentActive: Boolean);
begin

end;

{ TCnEditorWizard }

procedure TCnEditorWizard.Config;
begin
  inherited;
  with TCnEditorToolsForm.Create(nil) do
  try
    ShowModal;
  finally
    Free;
  end;
  DoSaveSettings;
  UpdateActions;
end;

constructor TCnEditorWizard.Create;
var
  i: Integer;
  Editor: TCnBaseEditorTool;
  ActiveIni: TCustomIniFile;
begin
  inherited;
  FEditorTools := TList.Create;
  ActiveIni := CreateIniFile;
  try
    Editor := nil;
    for i := 0 to GetCnEditorToolClassCount - 1 do
    begin
    {$IFDEF DEBUG}
      CnDebugger.LogMsg('EditorTool Creating: ' + GetCnEditorToolClassByIndex(i).ClassName);
    {$ENDIF}
      try
        Editor := GetCnEditorToolClassByIndex(i).Create(Self);
      except
        on E: Exception do
        begin
          DoHandleException(E.Message);
          Continue;
        end;
      end;
      Editor.Active := ActiveIni.ReadBool(SCnActiveSection,
        Editor.GetIDStr, Editor.Active);
      FEditorTools.Add(Editor);
    {$IFDEF DEBUG}
      CnDebugger.LogMsg('EditorTool Created: ' + GetCnEditorToolClassByIndex(i).ClassName);
    {$ENDIF}
    end;
  finally
    ActiveIni.Free;
  end;
end;

destructor TCnEditorWizard.Destroy;
var
  i: Integer;
  ActiveIni: TCustomIniFile;
begin
  ActiveIni := CreateIniFile;
  try
    for i := 0 to EditorToolCount - 1 do
    with EditorTools[i] do
    begin
      ActiveIni.WriteBool(SCnActiveSection, GetIDStr, Active);
      Free;
    end;
  finally
    ActiveIni.Free;
  end;
  FEditorTools.Free;
  inherited;
end;

// APos���غ��ڵ�ǰ���е�λ�á�
procedure TCnEditorWizard.Execute;
begin

end;

procedure TCnEditorWizard.Loaded;
var
  i: Integer;
begin
  inherited;
  for i := 0 to EditorToolCount - 1 do
    EditorTools[i].Loaded;
end;

function TCnEditorWizard.GetCaption: string;
begin
  Result := SCnEditorWizardMenuCaption;
end;

function TCnEditorWizard.GetHasConfig: Boolean;
begin
  Result := True;
end;

function TCnEditorWizard.GetHint: string;
begin
  Result := SCnEditorWizardMenuHint;
end;

function TCnEditorWizard.GetState: TWizardState;
begin
  if Active then 
    Result := [wsEnabled]
  else
    Result := [];
end;

class procedure TCnEditorWizard.GetWizardInfo(var Name, Author, Email,
  Comment: string);
begin
  Name := SCnEditorWizardName;
  Author := SCnPack_Zjy;
  Email := SCnPack_ZjyEmail;
  Comment := SCnEditorWizardComment;
end;

function TCnEditorWizard.GetEditorTools(Index: Integer): TCnBaseEditorTool;
begin
  Result := TCnBaseEditorTool(FEditorTools[Index]);
end;

function TCnEditorWizard.GetEditorToolCount: Integer;
begin
  Result := FEditorTools.Count;
end;

procedure TCnEditorWizard.LoadSettings(Ini: TCustomIniFile);
var
  i: Integer;
  AIni: TCustomIniFile;
begin
  inherited;

  for i := 0 to EditorToolCount - 1 do
  begin
    AIni := EditorTools[i].CreateIniFile;
    try
      EditorTools[i].LoadSettings(AIni);
    finally
      AIni.Free;
    end;
  end;
end;

procedure TCnEditorWizard.SaveSettings(Ini: TCustomIniFile);
var
  i: Integer;
  AIni: TCustomIniFile;
begin
  inherited;

  for i := 0 to EditorToolCount - 1 do
  begin
    AIni := EditorTools[i].CreateIniFile;
    try
      EditorTools[i].SaveSettings(AIni);
    finally
      AIni.Free;
    end;
  end;
end;

procedure TCnEditorWizard.SubActionExecute(Index: Integer);
var
  i: Integer;
begin
  inherited;
  if Index = FConfigIndex then
  begin
    Config;
  end
  else
  begin
    for i := 0 to EditorToolCount - 1 do
      with EditorTools[i] do
        if Active and (FAction = SubActions[Index]) then
        begin
          Execute;
          Exit;
        end;
  end;
end;

procedure TCnEditorWizard.SubActionUpdate(Index: Integer);
var
  i: Integer;
  State: TWizardState;
begin
  for i := 0 to EditorToolCount - 1 do
  begin
    if EditorTools[i].FAction = SubActions[Index] then
    begin
      State := EditorTools[i].GetState;
      SubActions[Index].Visible := Active and EditorTools[i].Active;
      SubActions[Index].Enabled := Action.Enabled and (wsEnabled in State);
      SubActions[Index].Checked := wsChecked in State;
      Exit;
    end;
  end;
  inherited;
end;

procedure TCnEditorWizard.AcquireSubActions;
var
  i: Integer;
begin
  WizShortCutMgr.BeginUpdate;
  try
    FConfigIndex := RegisterASubAction(SCnEditorWizardConfigName,
      SCnEditorWizardConfigCaption, 0, SCnEditorWizardConfigHint,
      SCnEditorWizardConfigName);
    if EditorToolCount > 0 then
      AddSepMenu;
    FEditorIndex := FConfigIndex + 1;
    for i := 0 to EditorToolCount - 1 do
      with EditorTools[i] do
      begin
        FAction := SubActions[RegisterASubAction(GetIDStr, GetCaption, GetDefShortCut, GetHint)];
        FAction.Visible := Self.Active and Active;
      end;
  finally
    WizShortCutMgr.EndUpdate;
  end;
  UpdateActions;
end;

procedure TCnEditorWizard.RefreshSubActions;
var
  i: Integer;
begin // ������������ͬ����˲��� inherited ���� AcquireSubActions��
  for i := 0 to GetEditorToolCount - 1 do
    EditorTools[i].RefreshAction;

  inherited;
  UpdateActions;
end;

procedure TCnEditorWizard.UpdateActions;
var
  i: Integer;
begin
  for i := 0 to EditorToolCount - 1 do
    EditorTools[i].FAction.Visible := Active and EditorTools[i].Active;
end;

procedure TCnEditorWizard.SetActive(Value: Boolean);
var
  I: Integer;
begin
  if Value <> Active then
  begin
    inherited;
    for i := 0 to EditorToolCount - 1 do
      EditorTools[i].ParentActiveChanged(Active);
  end;
end;

{ TCnEditorToolsForm }

procedure TCnEditorToolsForm.FormCreate(Sender: TObject);
begin
  FWizard := TCnEditorWizard(CnWizardMgr.WizardByClass(TCnEditorWizard));
  Assert(Assigned(FWizard));
  InitTools;
end;

procedure TCnEditorToolsForm.UpdateToolItem(Index: Integer);
var
  AName, AAuthor, AEmail: string;
begin
  with lvTools.Items[Index] do
  begin
    FWizard.EditorTools[Index].GetEditorInfo(AName, AAuthor, AEmail);
    Caption := AName;
    SubItems.Clear;
    if FWizard.EditorTools[Index].Active then
      SubItems.Add(SCnEnabled)
    else
      SubItems.Add(SCnDisabled);
    SubItems.Add(ShortCutToText(FWizard.EditorTools[Index].FAction.ShortCut));
  end;
end;

procedure TCnEditorToolsForm.InitTools;
var
  i: Integer;
begin
  lvTools.Items.Clear;
  for i := 0 to FWizard.EditorToolCount - 1 do
  begin
    lvTools.Items.Add;
    UpdateToolItem(i);
  end;
  lvTools.Selected := lvTools.TopItem;
  lvTools.OnChange(lvTools, lvTools.TopItem, ctState);
end;

procedure TCnEditorToolsForm.lvToolsDblClick(Sender: TObject);
begin
  btnConfigClick(btnConfig);
end;

procedure TCnEditorToolsForm.HotKeyExit(Sender: TObject);
var
  Idx: Integer;
begin
  if not Assigned(lvTools.Selected) then Exit;
  Idx := lvTools.Selected.Index;
  FWizard.EditorTools[Idx].FAction.ShortCut := HotKey.HotKey;
  UpdateToolItem(Idx);
end;

procedure TCnEditorToolsForm.chkEnabledClick(Sender: TObject);
var
  Idx: Integer;
begin
  if not Assigned(lvTools.Selected) then Exit;
  Idx := lvTools.Selected.Index;
  FWizard.EditorTools[Idx].Active := chkEnabled.Checked;
  UpdateToolItem(Idx);
end;

procedure TCnEditorToolsForm.btnConfigClick(Sender: TObject);
var
  Idx: Integer;
begin
  if not Assigned(lvTools.Selected) then Exit;
  Idx := lvTools.Selected.Index;
  if FWizard.EditorTools[Idx].HasConfig then
    FWizard.EditorTools[Idx].Config;
  UpdateToolItem(Idx);
end;

procedure TCnEditorToolsForm.btnHelpClick(Sender: TObject);
begin
  ShowFormHelp;
end;

function TCnEditorToolsForm.GetHelpTopic: string;
begin
  Result := 'CnEditorWizard';
end;

procedure TCnEditorToolsForm.lvToolsChange(Sender: TObject; Item: TListItem;
  Change: TItemChange);
var
  Idx: Integer;
  AName, AAuthor, AEmail: string;
begin
  if Assigned(lvTools.Selected) then
  begin
    Idx := lvTools.Selected.Index;
    FWizard.EditorTools[Idx].GetEditorInfo(AName, AAuthor, AEmail);
    imgIcon.Picture.Assign(FWizard.EditorTools[Idx].FAction.Icon);
    lblToolName.Caption := AName;
    lblToolAuthor.Caption := CnAuthorEmailToStr(AAuthor, AEmail);
    HotKey.HotKey := FWizard.EditorTools[Idx].FAction.ShortCut;
    chkEnabled.Checked := FWizard.EditorTools[Idx].Active;
    btnConfig.Visible := FWizard.EditorTools[Idx].HasConfig;
    mmoComment.Lines.Text := GetCommandComment(FWizard.EditorTools[Idx].GetIDStr);
  end
end;

initialization
  CnEditorClassList := TList.Create;
  RegisterCnWizard(TCnEditorWizard); // ע��ר��

finalization
{$IFDEF DEBUG}
  CnDebugger.LogEnter('CnEditorWizard finalization.');
{$ENDIF}

  FreeAndNil(CnEditorClassList);

{$IFDEF DEBUG}
  CnDebugger.LogLeave('CnEditorWizard finalization.');
{$ENDIF}

{$ENDIF CNWIZARDS_CNEDITORWIZARD}
end.
