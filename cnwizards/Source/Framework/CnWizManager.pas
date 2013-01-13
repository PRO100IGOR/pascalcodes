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

unit CnWizManager;
{* |<PRE>
================================================================================
* ������ƣ�CnPack IDE ר�Ұ�
* ��Ԫ���ƣ�CnWizardMgr ר�ҹ�����ʵ�ֵ�Ԫ
* ��Ԫ���ߣ��ܾ��� (zjy@cnpack.org)
* ��    ע���õ�ԪΪ CnWizards ��ܵ�һ���֣������� CnWizardMgr ר�ҹ�������
*           ��Ԫʵ����ר�� DLL ����ڵ�������������ר�ҹ�����ʼ�����е�ר�ҡ�
* ����ƽ̨��PWin2000Pro + Delphi 5.01
* ���ݲ��ԣ�PWin9X/2000/XP + Delphi 5/6/7 + C++Builder 5/6
* �� �� �����õ�Ԫ�е��ַ��������ϱ��ػ�����ʽ
* ��Ԫ��ʶ��$Id: CnWizManager.pas 763 2011-02-07 14:18:23Z liuxiao@cnpack.org $
* �޸ļ�¼��2003.10.03 V1.2 by ����(QSoft)
*               ����ר����������
*           2003.08.02 V1.1
*               LiuXiao ���� WizardCanCreate ���ԡ�
*           2002.09.17 V1.0
*               ������Ԫ��ʵ�ֻ�������
================================================================================
|</PRE>}

interface

{$I CnWizards.inc}

uses
  Windows, Messages, Classes, Graphics, Controls, Sysutils, Menus, ActnList,
  Forms, ImgList, ExtCtrls, IniFiles, Dialogs, Registry, ToolsAPI, 
  {$IFDEF COMPILER6_UP}
  DesignIntf, DesignEditors,
  {$ELSE}
  DsgnIntf,
  {$ENDIF}
  CnRestoreSystemMenu,
  CnWizClasses, CnWizConsts, CnWizMenuAction, CnLangMgr, CnWizIdeHooks;

const
  BootShortCutKey = VK_LSHIFT; // ��ݼ�Ϊ �� Shift���û����������� Delphi ʱ
                               // ���¸ü�������ר����������

type

//==============================================================================
// TCnWizardMgr ��ר����
//==============================================================================

{ TCnWizardMgr }

  TCnWizardMgr = class(TNotifierObject, IOTAWizard)
  {* CnWizardMgr ר�ҹ������࣬����ά��ר���б�
     �벻Ҫֱ�Ӵ��������ʵ���������ʵ����ר�� DLL ע��ʱ�Զ���������ʹ��ȫ��
     ���� CnWizardMgr �����ʹ�����ʵ����}
  private
    FRestoreSysMenu: TCnRestoreSystemMenu;
    FMenu: TMenuItem;
    FToolsMenu: TMenuItem;
    FWizards: TList;
    FMenuWizards: TList;
    FIDEEnhanceWizards: TList;
    FRepositoryWizards: TList;
    FTipTimer: TTimer;
    FSepMenu: TMenuItem;
    FConfigAction: TCnWizMenuAction;
    FWizMultiLang: TCnMenuWizard;
    FWizAbout: TCnMenuWizard;
    FOffSet: array[0..3] of Integer;
    FSettingsLoaded: Boolean;
  {$IFDEF BDS}
    FSplashBmp: TBitmap;
    FAboutBmp: TBitmap;
  {$ENDIF}
    procedure CreateIDEMenu;
    procedure InstallIDEMenu;
    procedure FreeMenu;
    procedure InstallWizards;
    procedure FreeWizards;
    procedure CreateMiscMenu;
    procedure InstallMiscMenu;
    procedure FreeMiscMenu;

    procedure RegisterPluginInfo;
    procedure InternalCreate;
    procedure InstallPropEditors;
    procedure InstallCompEditors;
    procedure SetTipShowing;
    procedure ShowTipofDay(Sender: TObject);
    procedure CheckIDEVersion;
    
    function GetWizards(Index: Integer): TCnBaseWizard;
    function GetWizardCount: Integer;
    function GetMenuWizardCount: Integer;
    function GetMenuWizards(Index: Integer): TCnMenuWizard;
    function GetRepositoryWizardCount: Integer;
    function GetRepositoryWizards(Index: Integer): TCnRepositoryWizard;
    procedure OnConfig(Sender: TObject);
    procedure OnIdeLoaded(Sender: TObject);
    procedure OnFileNotify(NotifyCode: TOTAFileNotification; const FileName: string);
    function GetIDEEnhanceWizardCount: Integer;
    function GetIDEEnhanceWizards(Index: Integer): TCnIDEEnhanceWizard;
    function GetWizardCanCreate(WizardClassName: string): Boolean;
    procedure SetWizardCanCreate(WizardClassName: string;
      const Value: Boolean);
    function GetOffSet(Index: Integer): Integer;
  public
    constructor Create;
    {* �๹����}
    destructor Destroy; override;
    {* ��������}

    // IOTAWizard methods
    function GetIDString: string;
    function GetName: string;
    function GetState: TWizardState;
    procedure Execute;

    procedure LoadSettings;
    {* װ������ר�ҵ�����}
    procedure SaveSettings;
    {* ��������ר�ҵ�����}
    procedure ConstructSortedMenu;
    {* �ؽ������Ĳ˵� }
    procedure UpdateMenuPos(UseToolsMenu: Boolean);
    {* �����������˵���λ�ã��ж������˵������� Tools �� }
    procedure RefreshLanguage;
    {* ���¶���ר�ҵĸ��������ַ��������� Action ���� }
    procedure ChangeWizardLanguage;
    {* ����ר�ҵ����Ըı��¼�������ר�ҵ����� }
    function WizardByName(const WizardName: string): TCnBaseWizard;
    {* ����ר�����Ʒ���ר��ʵ��������Ҳ���ר�ң�����Ϊ nil}
    function WizardByClass(AClass: TCnWizardClass): TCnBaseWizard;
    {* ����ר����������ר��ʵ��������Ҳ���ר�ң�����Ϊ nil}
    function WizardByClassName(AClassName: string): TCnBaseWizard;
    {* ����ר�������ַ�������ר��ʵ��������Ҳ���ר�ң�����Ϊ nil}
    property Menu: TMenuItem read FMenu;
    {* ���뵽 IDE ���˵��еĲ˵���}
    property WizardCount: Integer read GetWizardCount;
    {* TCnBaseWizard ��������ר�ҵ����������������е�ר��}
    property MenuWizardCount: Integer read GetMenuWizardCount;
    {* TCnMenuWizard �˵�ר�Ҽ������������}
    property IDEEnhanceWizardCount: Integer read GetIDEEnhanceWizardCount;
    {* TCnIDEEnhanceWizard ר�Ҽ������������}
    property RepositoryWizardCount: Integer read GetRepositoryWizardCount;
    {* TCnRepositoryWizard ģ����ר�Ҽ������������}
    property Wizards[Index: Integer]: TCnBaseWizard read GetWizards; default;
    {* ר�����飬�����˹�����ά��������ר��}
    property MenuWizards[Index: Integer]: TCnMenuWizard read GetMenuWizards;
    {* �˵�ר�����飬������ TCnMenuWizard ��������ר��}
    property IDEEnhanceWizards[Index: Integer]: TCnIDEEnhanceWizard
      read GetIDEEnhanceWizards;
    {* IDE ������չר�����飬������ TCnIDEEnhanceWizard ��������ר��}
    property RepositoryWizards[Index: Integer]: TCnRepositoryWizard
      read GetRepositoryWizards;
    {* ģ����ר�����飬������ TCnRepositoryWizard ��������ר��}

    property WizardCanCreate[WizardClassName: string]: Boolean read GetWizardCanCreate
      write SetWizardCanCreate;
    {* ָ��ר���Ƿ񴴽� }
    property OffSet[Index: Integer]: Integer read GetOffSet;
  end;

var
  CnWizardMgr: TCnWizardMgr;
  {* TCnWizardMgr ��ר��ʵ��}

  InitSplashProc: TProcedure = nil;
  {* ������洰��ͼƬ�����ݵ����ģ��}

implementation

uses
{$IFDEF DEBUG}
  CnDebug, 
{$ENDIF}
  CnWizUtils, CnWizOptions, CnWizShortCut, CnCommon, CnWizConfigFrm, CnWizAbout,
  CnWizUpgradeFrm, CnDesignEditor, CnWizShareImages, CnWizMultiLang, CnWizBoot,
  CnWizCommentFrm, CnWizTranslate, CnWizNotifier, CnWizTipOfDayFrm, CnIDEVersion,
  CnWizCompilerConst;

const
  csCnWizFreeMutex = 'CnWizFreeMutex';
  csMaxWaitFreeTick = 5000;

//==============================================================================
// TCnWizardMgr ��ר����
//==============================================================================

{ TCnWizardMgr }

procedure TCnWizardMgr.InternalCreate;
begin
  FWizards := TList.Create;
  FMenuWizards := TList.Create;
  FIDEEnhanceWizards := TList.Create;
  FRepositoryWizards := TList.Create;
  dmCnSharedImages := TdmCnSharedImages.Create(nil);

{$IFDEF BDS}
  FSplashBmp := TBitmap.Create;
  CnWizLoadBitmap(FSplashBmp, SCnSplashBmp);
  FAboutBmp := TBitmap.Create;
  CnWizLoadBitmap(FAboutBmp, SCnAboutBmp);
{$ENDIF}
  RegisterPluginInfo;

  CreateLanguageManager;
  if CnLanguageManager <> nil then
    InitLangManager;
  CnTranslateConsts(nil);

  CheckIDEVersion;

  CreateIDEMenu;

  InstallWizards;

  LoadSettings;

  // ���� MenuOrder ����������Ȼ�����˵�
  CreateMiscMenu;

  // ������˵�����ٲ��뵽 IDE �У��Խ�� D7 �²˵�����Ҫ�����������������
  InstallIDEMenu;

  InstallPropEditors;
  InstallCompEditors;

  // ��ˢ��������Ŀ�������Ըı�ʱ�Ĵ������ơ�
  if (CnLanguageManager <> nil) and (CnLanguageManager.LanguageStorage <> nil) then
  begin
    // ע�⣬���� Languages ��Ŀ���ڣ��ɱ��������жϡ���ǰ����������Ϊ -1
    RefreshLanguage;
    ChangeWizardLanguage;
    CnDesignEditorMgr.LanguageChanged(CnLanguageManager);
  end;

  // �ļ�֪ͨ
  CnWizNotifierServices.AddFileNotifier(OnFileNotify);

  // IDE ������ɺ���� Loaded
  CnWizNotifierServices.ExecuteOnApplicationIdle(OnIdeLoaded);
end;

// BDS ��ע������Ʒ��Ϣ
procedure TCnWizardMgr.RegisterPluginInfo;
{$IFDEF BDS}
var
  AboutSvcs: IOTAAboutBoxServices;
{$ENDIF}
begin
{$IFDEF BDS}
  if Assigned(SplashScreenServices) then
  begin
    SplashScreenServices.AddPluginBitmap(SCnWizardCaption, FSplashBmp.Handle);
  end;

  if QuerySvcs(BorlandIDEServices, IOTAAboutBoxServices, AboutSvcs) then
  begin
    AboutSvcs.AddPluginInfo(SCnWizardCaption, SCnWizardDesc, FAboutBmp.Handle,
      False, SCnWizardLicense);
  end;
{$ENDIF}
end;

// �๹����
constructor TCnWizardMgr.Create;
begin
{$IFDEF Debug}
  CnDebugger.LogEnter('TCnWizardMgr.Create');
{$ENDIF}
  inherited Create;
  
  // ��ר�ҿ����� Create �������������ܹ����� CnWizardMgr �е��������ԡ�
  CnWizardMgr := Self;
  WizOptions := TCnWizOptions.Create;
  // ������洰��
  if @InitSplashProc <> nil then
    InitSplashProc();

  WizShortCutMgr.BeginUpdate;
  CnListBeginUpdate;
  try
    InternalCreate;
  finally
    CnListEndUpdate;
    WizShortCutMgr.EndUpdate;
  end;
  
  ConstructSortedMenu;

  FRestoreSysMenu := TCnRestoreSystemMenu.Create(nil);

{$IFDEF DEBUG}
  CnDebugger.LogLeave('TCnWizardMgr.Create');
  CnDebugger.LogSeparator;
{$ENDIF}
end;

// ��������
destructor TCnWizardMgr.Destroy;
var
  hMutex: THandle;
begin
{$IFDEF DEBUG}
  CnDebugger.LogSeparator;
  CnDebugger.LogEnter('TCnWizardMgr.Destroy');
{$ENDIF}

  // ��ֹ���IDEʵ��ͬʱ�ͷ�ʱ�������ó�ͻ
  hMutex := CreateMutex(nil, False, csCnWizFreeMutex);
{$IFDEF DEBUG}
  if GetLastError = ERROR_ALREADY_EXISTS then
    CnDebugger.LogMsg('Waiting for another instance');
{$ENDIF}
  WaitForSingleObject(hMutex, csMaxWaitFreeTick);

  try
    // ��ֹ�����ж�ʱ������Ч������
    if FSettingsLoaded then
      SaveSettings;

    CnWizNotifierServices.RemoveFileNotifier(OnFileNotify);

    WizShortCutMgr.BeginUpdate;
    try
      FreeMiscMenu;
      FreeWizards;
    finally
      WizShortCutMgr.EndUpdate;
    end;

    FreeMenu;

    FreeAndNil(dmCnSharedImages);

  {$IFDEF BDS}
    FreeAndNil(FSplashBmp);
    FreeAndNil(FAboutBmp);
  {$ENDIF}

    FreeAndNil(FRepositoryWizards);
    FreeAndNil(FIDEEnhanceWizards);
    FreeAndNil(FMenuWizards);
    FreeAndNil(FWizards);
    FreeWizActionMgr;
    FreeWizShortCutMgr;
    FreeAndNil(WizOptions);
    FreeAndNil(FTipTimer);
    FreeAndNil(FRestoreSysMenu);
    inherited Destroy;
  finally
    if hMutex <> 0 then
    begin
      ReleaseMutex(hMutex);
      CloseHandle(hMutex);
    end;
  end;          

{$IFDEF DEBUG}
  CnDebugger.LogLeave('TCnWizardMgr.Destroy');
{$ENDIF}
end;

//------------------------------------------------------------------------------
// ר��������ط���
//------------------------------------------------------------------------------

// ����ר�Ұ��˵���
procedure TCnWizardMgr.CreateIDEMenu;
begin
  FMenu := TMenuItem.Create(nil);
  Menu.Name := SCnWizardsMenuName;
  Menu.Caption := SCnWizardsMenuCaption;
  Menu.AutoHotkeys := maManual;
end;

// ��װ IDE �˵���
procedure TCnWizardMgr.InstallIDEMenu;
var
  MainMenu: TMainMenu;
begin
  MainMenu := GetIDEMainMenu; // IDE���˵�
  if MainMenu <> nil then
  begin
    FToolsMenu := GetIDEToolsMenu;
    if WizOptions.UseToolsMenu and Assigned(FToolsMenu) then
      FToolsMenu.Insert(0, Menu)
    else if Assigned(FToolsMenu) then // �²˵����� Tools �˵�����
      MainMenu.Items.Insert(MainMenu.Items.IndexOf(FToolsMenu) + 1, Menu)
    else
      MainMenu.Items.Add(Menu);
  {$IFDEF DEBUG}
    CnDebugger.LogMsg('Install menu succeed');
  {$ENDIF}
  end;
end;

// ���¶���ר�ҵĸ��������ַ��������� Action ����
procedure TCnWizardMgr.RefreshLanguage;
var
  i: Integer;
begin
  FConfigAction.Caption := SCnWizConfigCaption;
  FConfigAction.Hint := SCnWizConfigHint;
  FWizAbout.RefreshAction;
  
  WizActionMgr.MoreAction.Caption := SCnMoreMenu;
  WizActionMgr.MoreAction.Hint := StripHotkey(SCnMoreMenu);
  
  for i := 0 to WizardCount - 1 do
    if Wizards[i] is TCnActionWizard then
      TCnActionWizard(Wizards[i]).RefreshAction;
end;

// ����ר�ҵ����Ըı��¼�����ר���Լ��������Ա仯
procedure TCnWizardMgr.ChangeWizardLanguage;
var
  i: Integer;
begin
  for i := 0 to WizardCount - 1 do
    Wizards[i].LanguageChanged(CnLanguageManager);
end;

// ���������˵���
procedure TCnWizardMgr.CreateMiscMenu;
begin
  FSepMenu := TMenuItem.Create(nil);
  FSepMenu.Caption := '-';
  FConfigAction := WizActionMgr.AddMenuAction(SCnWizConfigCommand, SCnWizConfigCaption,
    SCnWizConfigMenuName, 0, OnConfig, SCnWizConfigIcon, SCnWizConfigHint);
  FWizMultiLang := TCnWizMultiLang.Create;
  FWizAbout := TCnWizAbout.Create;
end;

// ���ݲ˵�ר���б�͸��˵����ؽ��˵���
procedure TCnWizardMgr.ConstructSortedMenu;
var
  List: TList;
  i: Integer;
begin
  if (FMenuWizards = nil) or (Menu = nil) then Exit;

  List := TList.Create;
  try
    for i := 0 to FMenuWizards.Count - 1 do
      List.Add(FMenuWizards.Items[i]);

    for i := Menu.Count - 1 downto 0 do
      Menu.Delete(i);

    SortListByMenuOrder(List);

    for i := 0 to List.Count - 1 do
      Menu.Add(TCnMenuWizard(List.Items[i]).Menu);

    InstallMiscMenu;
  finally
    List.Free;
  end;

  WizActionMgr.ArrangeMenuItems(Menu);
end;

procedure TCnWizardMgr.UpdateMenuPos(UseToolsMenu: Boolean);
var
  MainMenu: TMainMenu;
  Svcs40: INTAServices40;
begin
  if FToolsMenu <> nil then
  begin
    if not QuerySvcs(BorlandIDEServices, INTAServices40, Svcs40) then
      Exit;

    MainMenu := Svcs40.MainMenu; // IDE���˵�
    if UseToolsMenu then
    begin
      MainMenu.Items.Remove(FMenu);
      FToolsMenu.Insert(0, FMenu);
    end
    else
    begin
      FToolsMenu.Remove(FMenu);
      MainMenu.Items.Insert(FToolsMenu.MenuIndex + 1, FMenu);
    end;
  end;
end;

// ���� TCnIDEEnhanceWizard ר�Ҽ������������
function TCnWizardMgr.GetIDEEnhanceWizardCount: Integer;
begin
  Result := FIDEEnhanceWizards.Count;
end;

// ȡָ���� IDE ������չר��
function TCnWizardMgr.GetIDEEnhanceWizards(Index: Integer): TCnIDEEnhanceWizard;
begin
  if (Index >= 0) and (Index <= FIDEEnhanceWizards.Count - 1) then
    Result := TCnIDEEnhanceWizard(FIDEEnhanceWizards[Index])
  else
    Result := nil;
end;

// ����ר����������ר��ʵ��������Ҳ���ר�ң�����Ϊ nil
function TCnWizardMgr.WizardByClass(AClass: TCnWizardClass): TCnBaseWizard;
var
  i: Integer;
begin
  for i := 0 to WizardCount - 1 do
    if Wizards[i] is AClass then
    begin
      Result := Wizards[i];
      Exit;
    end;
  Result := nil;
end;

function TCnWizardMgr.WizardByClassName(AClassName: string): TCnBaseWizard;
var
  i: Integer;
begin
  for i := 0 to WizardCount - 1 do
    if Wizards[i].ClassNameIs(AClassName) then
    begin
      Result := Wizards[i];
      Exit;
    end;
  Result := nil;
end;

// ����ר�����Ʒ���ר��ʵ��������Ҳ���ר�ң�����Ϊ nil
function TCnWizardMgr.WizardByName(const WizardName: string): TCnBaseWizard;
var
  i: Integer;
begin
  for i := 0 to WizardCount - 1 do
    if SameText(Wizards[i].WizardName, WizardName) then
    begin
      Result := Wizards[i];
      Exit;
    end;
  Result := nil;
end;

// �ͷŲ˵���
procedure TCnWizardMgr.FreeMenu;
begin
  if Menu <> nil then
  begin
    while Menu.Count > 0 do
      Menu[0].Free;
    FreeAndNil(FMenu);
{$IFDEF DEBUG}
    CnDebugger.LogMsg('Free menu succeed');
{$ENDIF}
  end;
end;

// ��װר���б�
procedure TCnWizardMgr.InstallWizards;
var
  i: Integer;
  Wizard: TCnBaseWizard;
  MenuWizard: TCnMenuWizard;
  IDEEnhanceWizard: TCnIDEEnhanceWizard;
  RepositoryWizard: TCnRepositoryWizard;
  WizardSvcs: IOTAWizardServices;

  frmBoot: TCnWizBootForm;
  KeyState: TKeyboardState;
  bUserBoot: boolean;
  BootList: array of boolean;
begin
  if not QuerySvcs(BorlandIDEServices, IOTAWizardServices, WizardSvcs) then
  begin
  {$IFDEF DEBUG}
    CnDebugger.LogMsgWithType('Query IOTAWizardServices fail', cmtError);
  {$ENDIF}
    Exit;
  end;

{$IFDEF DEBUG}
  CnDebugger.LogMsg('Begin installing wizards');
{$ENDIF}

  bUserBoot := False;
  GetKeyboardState(KeyState);

  if (KeyState[BootShortCutKey] and $80 <> 0) or // �Ƿ����û�����ר��
    FindCmdLineSwitch(SCnShowBootFormSwitch, ['/', '-'], True) then
  begin
    frmBoot := TCnWizBootForm.Create(Application);
    try
      if frmBoot.ShowModal = mrOK then
      begin
        bUserBoot := True;
        SetLength(BootList, GetCnWizardClassCount);
        frmBoot.GetBootList(BootList);
      end;
    finally
      frmBoot.Free;
    end;
  end;

  for i := 0 to GetCnWizardClassCount - 1 do
  begin
    if ((not bUserBoot) and WizardCanCreate[TCnWizardClass(GetCnWizardClassByIndex(i)).ClassName]) or
       (bUserBoot and BootList[i]) then
    begin
      try
        Wizard := TCnWizardClass(GetCnWizardClassByIndex(i)).Create;
      {$IFDEF DEBUG}
        CnDebugger.LogMsg('Wizard Created: ' + Wizard.ClassName);
      {$ENDIF}
      except
      {$IFDEF DEBUG}
        CnDebugger.LogMsg('Wizard Create Fail: ' +
          TCnWizardClass(GetCnWizardClassByIndex(i)).ClassName);
      {$ENDIF}
        Wizard := nil;
      end;

      if Wizard = nil then Continue;

      if Wizard is TCnRepositoryWizard then
      begin
        RepositoryWizard := TCnRepositoryWizard(Wizard);
        FRepositoryWizards.Add(RepositoryWizard);
        RepositoryWizard.WizardIndex := WizardSvcs.AddWizard(RepositoryWizard);
      end
      else if Wizard is TCnMenuWizard then // �˵���ר��
      begin
        MenuWizard := TCnMenuWizard(Wizard);
        FMenuWizards.Add(MenuWizard);
      end
      else if Wizard is TCnIDEEnhanceWizard then  // IDE ������չר��
      begin
        IDEEnhanceWizard := TCnIDEEnhanceWizard(Wizard);
        FIDEEnhanceWizards.Add(IDEEnhanceWizard);
      end
      else
        FWizards.Add(Wizard);

    {$IFDEF DEBUG}
      CnDebugger.LogFmt('Wizard [%d] installed: %s', [i, Wizard.ClassName]);
    {$ENDIF}
    end;
  end;

//��ʼ��ƫ����
  FOffSet[0] := FWizards.Count;
  FOffSet[1] := FOffSet[0] + FMenuWizards.Count;
  FOffSet[2] := FOffSet[1] + FIDEEnhanceWizards.Count;
  FOffSet[3] := FOffSet[2] + FRepositoryWizards.Count;
  if bUserBoot then SetLength(BootList, 0);
end;

function TCnWizardMgr.GetOffSet(Index: Integer): Integer;
begin
  Result := FOffSet[Index];
end;

// �ͷ�ר���б�
procedure TCnWizardMgr.FreeWizards;
var
  WizardSvcs: IOTAWizardServices;
begin
  if not QuerySvcs(BorlandIDEServices, IOTAWizardServices, WizardSvcs) then
  begin
  {$IFDEF DEBUG}
    CnDebugger.LogMsgWithType('Query IOTAWizardServices Error', cmtError);
  {$ENDIF}
    Exit;
  end;

  while FWizards.Count > 0 do
  begin
  {$IFDEF DEBUG}
    CnDebugger.LogMsg(TCnBaseWizard(FWizards[0]).ClassName + '.Free');
  {$ENDIF}
    try
      try
        TCnBaseWizard(FWizards[0]).Free;
      finally
        FWizards.Delete(0);
      end;
    except
      Continue;
    end;
  end;

  while FMenuWizards.Count > 0 do
  begin
  {$IFDEF DEBUG}
    CnDebugger.LogMsg(TCnMenuWizard(FMenuWizards[0]).ClassName + '.Free');
  {$ENDIF}
    try
      try
        TCnMenuWizard(FMenuWizards[0]).Free;
      finally
        FMenuWizards.Delete(0);
      end;
    except
      Continue;
    end;
  end;

  while FIDEEnhanceWizards.Count > 0 do
  begin
  {$IFDEF DEBUG}
    CnDebugger.LogMsg(TCnIDEEnhanceWizard(FIDEEnhanceWizards[0]).ClassName + '.Free');
  {$ENDIF}
    try
      try
        TCnIDEEnhanceWizard(FIDEEnhanceWizards[0]).Free;
      finally
        FIDEEnhanceWizards.Delete(0);
      end;
    except
      Continue;
    end;
  end;
  
  while FRepositoryWizards.Count > 0 do
  begin
  {$IFDEF DEBUG}
    CnDebugger.LogMsg(TCnRepositoryWizard(FRepositoryWizards[0]).ClassName + '.Free');
  {$ENDIF}
    // �Ƴ�ר�һ��Զ��ͷŵ�
    WizardSvcs.RemoveWizard(TCnRepositoryWizard(FRepositoryWizards[0]).WizardIndex);
    FRepositoryWizards.Delete(0);
  end;
end;

// װ��ר������
procedure TCnWizardMgr.LoadSettings;
var
  i: Integer;
begin
{$IFDEF DEBUG}
  CnDebugger.LogEnter('TCnWizardMgr.LoadSettings');
{$ENDIF}
  with WizOptions.CreateRegIniFile do
  try
    // ���� MenuOrder
    for i := 0 to MenuWizardCount - 1 do
    begin
      MenuWizards[i].MenuOrder := ReadInteger(SCnMenuOrderSection,
        MenuWizards[i].GetIDStr, i);

      // �˴����� AcquireSubActions, �� TCnSubMenuWizard �� Create ʱ�пճ�ʼ��
      if MenuWizards[i] is TCnSubMenuWizard then
      begin
        (MenuWizards[i] as TCnSubMenuWizard).ClearSubActions;
        (MenuWizards[i] as TCnSubMenuWizard).AcquireSubActions;
      end;
    end;

    // װ��ר������
    for i := 0 to WizardCount - 1 do
    begin
      Wizards[i].DoLoadSettings;
      Wizards[i].Active := ReadBool(SCnActiveSection,
        Wizards[i].GetIDStr, Wizards[i].Active);
    end;
  finally
    Free;
  end;

{$IFDEF DEBUG}
  CnDebugger.LogLeave('TCnWizardMgr.LoadSettings');
{$ENDIF}
end;

// ����ר������
procedure TCnWizardMgr.SaveSettings;
var
  i: Integer;
begin
{$IFDEF DEBUG}
  CnDebugger.LogEnter('TCnWizardMgr.SaveSettings');
{$ENDIF}

  with WizOptions.CreateRegIniFile do
  try
    for i := 0 to WizardCount - 1 do
    begin
      Wizards[i].DoSaveSettings;
      // ���� Active
      WriteBool(SCnActiveSection, Wizards[i].GetIDStr, Wizards[i].Active);
    end;
    
    // ���� MenuOrder
    for i := 0 to MenuWizardCount - 1 do
      WriteInteger(SCnMenuOrderSection, MenuWizards[i].GetIDStr,
        MenuWizards[i].MenuOrder);
  finally
    Free;
  end;

  with WizOptions.CreateRegIniFile(WizOptions.CompEditorRegPath) do
  try
    for i := 0 to CnDesignEditorMgr.CompEditorCount - 1 do
    begin
      CnDesignEditorMgr.CompEditors[i].DoSaveSettings;
      with CnDesignEditorMgr.CompEditors[i] do
        WriteBool(SCnActiveSection, IDStr, Active);
    end;
  finally
    Free;
  end;

  with WizOptions.CreateRegIniFile(WizOptions.PropEditorRegPath) do
  try
    for i := 0 to CnDesignEditorMgr.PropEditorCount - 1 do
    begin
      CnDesignEditorMgr.PropEditors[i].DoSaveSettings;
      with CnDesignEditorMgr.PropEditors[i] do
        WriteBool(SCnActiveSection, IDStr, Active);
    end;
  finally
    Free;
  end;

{$IFDEF DEBUG}
  CnDebugger.LogLeave('TCnWizardMgr.SaveSettings');
{$ENDIF}
end;

// ��װ���������˵�
procedure TCnWizardMgr.InstallMiscMenu;
begin
{$IFDEF DEBUG}
  CnDebugger.LogEnter('Install misc menu Entered.');
{$ENDIF}
  if Menu.Count > 0 then
    Menu.Add(FSepMenu);
  Menu.Add(FConfigAction.Menu);
  Menu.Add(FWizMultiLang.Menu);
  Menu.Add(FWizAbout.Menu);
{$IFDEF DEBUG}
  CnDebugger.LogLeave('Install misc menu Leave successed.');
{$ENDIF}
end;

// �ͷ����������˵�
procedure TCnWizardMgr.FreeMiscMenu;
begin
  WizActionMgr.DeleteAction(TCnWizAction(FConfigAction));
  FWizMultiLang.Free;
  FWizAbout.Free;
  FSepMenu.Free;
{$IFDEF DEBUG}
  CnDebugger.LogMsg('Free misc menu succeed');
{$ENDIF}
end;

// ��װ����༭��
procedure TCnWizardMgr.InstallCompEditors;
var
  i: Integer;
begin
{$IFDEF DEBUG}
  CnDebugger.LogMsg('Begin installing component editors');
{$ENDIF}
  with WizOptions.CreateRegIniFile(WizOptions.CompEditorRegPath) do
  try
    for i := 0 to CnDesignEditorMgr.CompEditorCount - 1 do
      with CnDesignEditorMgr.CompEditors[i] do
      begin
        Active := ReadBool(SCnActiveSection, IDStr, True);
      {$IFDEF DEBUG}
        if Active then
          CnDebugger.LogMsg('Component editors installed: ' + IDStr);
      {$ENDIF}
        DoLoadSettings;
      end;
  finally
    Free;
  end;
{$IFDEF DEBUG}
  CnDebugger.LogMsg('Installing component editors succeed');
{$ENDIF}
end;

// ��װ���Ա༭��
procedure TCnWizardMgr.InstallPropEditors;
var
  i: Integer;
begin
{$IFDEF DEBUG}
  CnDebugger.LogMsg('Begin installing property editors');
{$ENDIF}
  with WizOptions.CreateRegIniFile(WizOptions.PropEditorRegPath) do
  try
    for i := 0 to CnDesignEditorMgr.PropEditorCount - 1 do
      with CnDesignEditorMgr.PropEditors[i] do
      begin
        Active := ReadBool(SCnActiveSection, IDStr, True);
      {$IFDEF DEBUG}
        if Active then
          CnDebugger.LogMsg('Property editors installed: ' + IDStr);
      {$ENDIF}
        DoLoadSettings;
      end;
  finally
    Free;
  end;
{$IFDEF DEBUG}
  CnDebugger.LogMsg('Installing property editors succeed');
{$ENDIF}
end;

// ����ÿ��һ������ʱ
procedure TCnWizardMgr.SetTipShowing;
begin
  FTipTimer := TTimer.Create(nil);
  FTipTimer.Interval := 8000;
  FTipTimer.OnTimer := ShowTipofDay;
end;

// ��ʾÿ��һ��
procedure TCnWizardMgr.ShowTipofDay(Sender: TObject);
begin
  FreeAndNil(FTipTimer);
  ShowCnWizTipOfDayForm(False);
end;

// ��� IDE �汾����ʾ
procedure TCnWizardMgr.CheckIDEVersion;
begin
  if not IsIdeVersionLatest then
    ShowSimpleCommentForm('', SCnIDENOTLatest, 'CheckIDEVersion' + CompilerShortName);
end;

// �ļ�֪ͨ
procedure TCnWizardMgr.OnFileNotify(NotifyCode: TOTAFileNotification;
  const FileName: string);
begin
  // ����ʱ������Ч�������ڼ��ذ���������
  if NotifyCode = ofnPackageInstalled then
    WizOptions.DoFixThreadLocale;
end;

// IDE �������¼�
procedure TCnWizardMgr.OnIdeLoaded(Sender: TObject);
var
  i: Integer;
begin
{$IFDEF DEBUG}
  CnDebugger.LogEnter('OnIdeLoaded');
{$ENDIF}

  WizShortCutMgr.BeginUpdate;
  CnListBeginUpdate;
  try
    for i := 0 to WizardCount - 1 do
    try
      Wizards[i].Loaded;
    except
      DoHandleException(Wizards[i].ClassName + '.Loaded');
    end;

    // װ������༭������
    for i := 0 to CnDesignEditorMgr.CompEditorCount - 1 do
    try
      CnDesignEditorMgr.CompEditors[i].Loaded;
    except
      DoHandleException(CnDesignEditorMgr.CompEditors[i].IDStr + '.Loaded');
    end;

    // װ�����Ա༭������
    for i := 0 to CnDesignEditorMgr.PropEditorCount - 1 do
    try
      CnDesignEditorMgr.PropEditors[i].Loaded;
    except
      DoHandleException(CnDesignEditorMgr.PropEditors[i].IDStr + '.Loaded');
    end;
  finally
    CnListEndUpdate;
    WizShortCutMgr.UpdateBinding;   // IDE ������ǿ�����°�һ��
    WizShortCutMgr.EndUpdate;
  end;

  // IDE ��������ע��༭���Ա�֤���ȼ����
  CnDesignEditorMgr.Register;

  // ȫ��װ��������������־
  FSettingsLoaded := True;

  // �������
  if (WizOptions.UpgradeStyle = usAllUpgrade) or (WizOptions.UpgradeStyle =
    usUserDefine) and (WizOptions.UpgradeContent <> []) then
    CheckUpgrade(False);

  // ��ʾÿ��һ��
  SetTipShowing;

{$IFDEF DEBUG}
  CnDebugger.LogLeave('OnIdeLoaded');
  CnDebugger.LogSeparator;
{$ENDIF}
end;

// ��ʾר�����öԻ���
procedure TCnWizardMgr.OnConfig(Sender: TObject);
var
  I: Integer;
begin
  I := WizActionMgr.IndexOfCommand(SCnWizConfigCommand);
  if I >= 0 then
    ShowCnWizConfigForm(WizActionMgr.WizActions[I].Icon)
  else
    ShowCnWizConfigForm;
end;

//------------------------------------------------------------------------------
// ���Զ�д����
//------------------------------------------------------------------------------

// ȡר������
function TCnWizardMgr.GetWizardCount: Integer;
begin
  Result := OffSet[3];
end;

// ȡָ��ר��
function TCnWizardMgr.GetWizards(Index: Integer): TCnBaseWizard;
begin
  if Index < 0 then
  begin
    Result := nil;
    Exit;
  end;
  // �������ͨר��
  if (Index <= OffSet[0] - 1) then
    Result := TCnBaseWizard(FWizards[Index])
  // ����ǲ˵�ר��
  else if (Index <= OffSet[1] - 1) then
    Result := TCnBaseWizard(FMenuWizards[Index - OffSet[0]])
  // ����� IDE ������չר��
  else if (Index <= OffSet[2] - 1) then
    Result := TCnBaseWizard(FIDEEnhanceWizards[Index - OffSet[1]])
  // �����Repositoryר��
  else if (Index <= OffSet[3] - 1) then
    Result := TCnBaseWizard(FRepositoryWizards[Index - OffSet[2]])
  else
    Result := nil;
end;

// ȡ�˵�ר������
function TCnWizardMgr.GetMenuWizardCount: Integer;
begin
  Result := FMenuWizards.Count;
end;

// ȡָ���˵�ר��
function TCnWizardMgr.GetMenuWizards(Index: Integer): TCnMenuWizard;
begin
  if (Index >= 0) and (Index <= FMenuWizards.Count - 1) then
    Result := TCnMenuWizard(FMenuWizards[Index])
  else
    Result := nil;
end;

// ȡ�ֿ�ר������
function TCnWizardMgr.GetRepositoryWizardCount: Integer;
begin
  Result := FRepositoryWizards.Count;
end;

// ȡָ���ֿ�ר��
function TCnWizardMgr.GetRepositoryWizards(
  Index: Integer): TCnRepositoryWizard;
begin
  if (Index >= 0) and (Index <= FRepositoryWizards.Count - 1) then
    Result := TCnRepositoryWizard(FRepositoryWizards[Index])
  else
    Result := nil;
end;

// ȡָ��ר���Ƿ񴴽�
function TCnWizardMgr.GetWizardCanCreate(WizardClassName: string): Boolean;
begin
  Result := WizOptions.ReadBool(SCnCreateSection, WizardClassName, True);
  WizOptions.WriteBool(SCnCreateSection, WizardClassName, Result);
end;

// дָ��ר���Ƿ񴴽�
procedure TCnWizardMgr.SetWizardCanCreate(WizardClassName: string;
  const Value: Boolean);
begin
  WizOptions.WriteBool(SCnCreateSection, WizardClassName, Value);
end;

//------------------------------------------------------------------------------
// ����ʵ�ֵ� IOTAWizard ����
//------------------------------------------------------------------------------

{ TCnWizardMgr.IOTAWizard }

// ר��ִ�з������շ�����
procedure TCnWizardMgr.Execute;
begin
  // do nothing
end;

// ȡר��ID
function TCnWizardMgr.GetIDString: string;
begin
  Result := SCnWizardMgrID;
end;

// ȡר����
function TCnWizardMgr.GetName: string;
begin
  Result := SCnWizardMgrName;
end;

// ����ר��״̬
function TCnWizardMgr.GetState: TWizardState;
begin
  Result := [wsEnabled];
end;

end.

