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

unit CnWizClasses;
{* |<PRE>
================================================================================
* ������ƣ�CnPack IDE ר�Ұ�
* ��Ԫ���ƣ�CnWizards �����ඨ�嵥Ԫ
* ��Ԫ���ߣ��ܾ��� (zjy@cnpack.org)
* ��    ע���õ�ԪΪ CnWizards ��ܵ�һ���֣�����������ר�ҵĻ����ࡣ
*           Ҫע��һ����ʵ�ֵ�ר�ң�����ʵ�ָ�ר�ҵĵ�Ԫ initialization �ڵ���
*           RegisterCnWizard ��ע��һ��ר�������á�
*         - TCnBaseWizard
*           ���� CnWizard ��ײ�ĳ�����ࡣ
*           - TCnIconWizard
*             ��ͼ��ĳ�����ࡣ
*             - TCnIDEEnhanceWizard
*               IDE ������չר�һ��ࡣ
*             - TCnActionWizard
*               �� IDE Action �ĳ�����࣬�������������п�ݼ���ר�ҡ�
*               - TCnMenuWizard
*                 ���˵��ĵĳ�����࣬������������ͨ���˵����õ�ר�ҡ�
*                 - TCnSubMenuWizard
*                   ���Ӳ˵���ĳ�����࣬������������ͨ���Ӳ˵�����õ�ר�ҡ�
*             - TCnRepositoryWizard
*               ���� Repository ר�һ��ࡣ
*               - TCnFormWizard
*                 �����������嵥Ԫ�ļ���ģ���򵼻��࣬���������� Pas ��Ԫ��
*               - TCnProjectWizard
*                 ��������Ӧ�ó��򹤳̵�ģ���򵼻��ࡣ
* ����ƽ̨��PWin2000Pro + Delphi 5.01
* ���ݲ��ԣ�PWin9X/2000/XP + Delphi 5/6/7 + C++Builder 5/6
* �� �� �����õ�Ԫ�е��ַ��������ϱ��ػ�����ʽ
* ��Ԫ��ʶ��$Id: CnWizClasses.pas 763 2011-02-07 14:18:23Z liuxiao@cnpack.org $
* �޸ļ�¼��2004.06.01 V1.8
*               LiuXiao ���� TCnSubMenuWizard.OnPopup �������ڵ����˵��м����Ӳ˵���
*           2004.04.27 V1.7
*               beta �� TCnSubMenuWizard ������һ��������AddSubMenuWizard��
*               ����������Ӧ�ķ��������ṩ�Զ༶�Ӳ˵�ר�ҵ�֧�֡�
*           2003.12.12 V1.6
*               �� TCnUnitWizard ���� IOTAFormWizard �ӿڡ�
*           2003.06.22 V1.5
*               ���ӳ����� TCnIconWizard���Դ����ͼ���ר�ҡ�
*               ���ӻ����� TCnIDEEnhanceWizard���Դ��� IDE ������չ�����ࡣ
*           2003.05.02 V1.4
*               ʵ���� TCnSubMenuWizard.ShowShortCutDialog ����
*           2003.04.15 V1.3
*               �����Ӳ˵�ר�Ҳ����İ�ť״̬�����Զ����µ�����
*           2003.02.27 V1.2
*               Ϊ�Ӳ˵�ר�����ӹ�������ť֧�֣����ʱ����������
*           2002.10.26 V1.1
*               ���� CnSubMenuWizard ����
*           2002.09.17 V1.0
*               ������Ԫ��ʵ�ֻ�������
================================================================================
|</PRE>}

interface

{$I CnWizards.inc}

uses
  Windows, Classes, Sysutils, Graphics, Menus, ActnList, IniFiles, ToolsAPI,
  Registry, ComCtrls, Forms, CnWizShortCut, CnWizMenuAction, CnIni, CnWizConsts,
  CnPopupMenu;

type

//==============================================================================
// ר�Ұ�ר�ҳ������
//==============================================================================

{ TCnBaseWizard }

{$M+}

  TCnBaseWizard = class(TNotifierObject, IOTAWizard)
  {* CnWizard ר�ҳ�����࣬������ר��������Ĺ������� }
  private
    FActive: Boolean;
    FWizardIndex: Integer;
  protected
    procedure SetActive(Value: Boolean); virtual;
    {* Active ����д�������������ظ÷������� Active ���Ա���¼� }
    function GetHasConfig: Boolean; virtual;
    {* HasConfig ���Զ��������������ظ÷��������Ƿ���ڿ��������� }
    function GetIcon: TIcon; virtual; abstract;
    {* Icon ���Զ��������������ظ÷������ط���ר��ͼ�꣬�û�ר��ͨ�������Լ����� }

    // IOTAWizard methods
    function GetIDString: string;
    function GetName: string; virtual;
  public
    constructor Create; virtual;
    {* �๹���� }
    destructor Destroy; override;
    {* �������� }
    class function WizardName: string;
    {* ȡר�����ƣ�������֧�ֱ��ػ����ַ��� }
    function GetAuthor: string; virtual;
    function GetComment: string; virtual;

    // IOTAWizard methods
    function GetState: TWizardState; virtual;
    {* ����ר��״̬��IOTAWizard �������������ظ÷�������ר��״̬ }
    procedure Execute; virtual; abstract;
    {* ר��ִ���巽����IOTAWizard ���󷽷����������ʵ�֡�
       ���û�ִ��һ��ר��ʱ�������ø÷����� }

    procedure Loaded; virtual;
    {* IDE ������ɺ���ø÷���}

    class function IsInternalWizard: Boolean; virtual;
    {* ��ר���Ƿ������ڲ�ר�ң�����ʾ���������� }
    
    class procedure GetWizardInfo(var Name, Author, Email, Comment: string);
      virtual; {$IFNDEF BCB}abstract;{$ENDIF BCB}
    {* ȡר����Ϣ�������ṩר�ҵ�˵���Ͱ�Ȩ��Ϣ�����󷽷����������ʵ�֡�
     |<PRE>
       var AName: string      - ר�����ƣ�������֧�ֱ��ػ����ַ���
       var Author: string     - ר�����ߣ�����ж�����ߣ��÷ֺŷָ�
       var Email: string      - ר���������䣬����ж�����ߣ��÷ֺŷָ�
       var Comment: string    - ר��˵����������֧�ֱ��ػ������з����ַ���
     |</PRE> }
    procedure Config; virtual;
    {* ר�����÷�������ר�ҹ�������ר�����ý����е��ã��� HasConfig Ϊ��ʱ��Ч }
    procedure LanguageChanged(Sender: TObject); virtual;
    {* ר���ڶ�������Է����ı��ʱ��Ĵ����������ش˹��̴��������ַ��� }
    procedure LoadSettings(Ini: TCustomIniFile); virtual;
    {* װ��ר�����÷������������ش˷����� INI �����ж�ȡר�Ҳ��� }
    procedure SaveSettings(Ini: TCustomIniFile); virtual;
    {* ����ר�����÷������������ش˷�����ר�Ҳ������浽 INI ������ }

    class function GetIDStr: string;
    {* ����ר��Ψһ��ʶ������������ʹ�� }
    class function CreateIniFile(CompilerSection: Boolean = False): TCustomIniFile;
    {* ����һ�����ڴ�ȡר�����ò����� INI �����û�ʹ�ú����Լ��ͷ� }
    procedure DoLoadSettings;
    {* װ��ר������ }
    procedure DoSaveSettings;
    {* װ��ר������ }

    property Active: Boolean read FActive write SetActive;
    {* ��Ծ���ԣ�����ר�ҵ�ǰ�Ƿ���� }
    property HasConfig: Boolean read GetHasConfig;
    {* ��ʾר���Ƿ�������ý�������� }
    property WizardIndex: Integer read FWizardIndex write FWizardIndex;
    {* ר��ע����� IDE ���ص������ţ����ͷ�ר��ʱʹ�ã��벻Ҫ�޸ĸ�ֵ }
    property Icon: TIcon read GetIcon;
    {* ר��ͼ������ }
  end;
  
{$M-}

type
  TCnWizardClass = class of TCnBaseWizard;

//==============================================================================
// ��ͼ�����ԵĻ�����
//==============================================================================

{ TCnIconWizard }

  TCnIconWizard = class(TCnBaseWizard)
  {* IDE ��ͼ�����ԵĻ����� }
  private
    FIcon: TIcon;
  protected
    function GetIcon: TIcon; override;
    {* ���ظ���ר�ҵ�ͼ�꣬��������ش˹��̷��������� Icon ���� }
    procedure InitIcon(AIcon: TIcon); virtual;
    {* ����������ʼ��ͼ�꣬���󴴽�ʱ���ã���������ش˹������´��� FIcon }
    class function GetIconName: string; virtual;
    {* ����ͼ���ļ��� }
  public
    constructor Create; override;
    {* �๹���� }
    destructor Destroy; override;
    {* �������� }
  end;

//==============================================================================
// IDE ������չ������
//==============================================================================

{ TCnIDEEnhanceWizard }

  TCnIDEEnhanceWizard = class(TCnIconWizard);
  {* IDE ������չ������ }
  
//==============================================================================
// �� Action �Ϳ�ݼ��ĳ���ר����
//==============================================================================

{ TCnActionWizard }

  TCnActionWizard = class(TCnIDEEnhanceWizard)
  {* �� Action �Ϳ�ݼ��� CnWizard ר�ҳ������ }
  private
    FAction: TCnWizAction;
    function GetImageIndex: Integer;
  protected
    function GetIcon: TIcon; override;
    procedure OnActionUpdate(Sender: TObject); virtual;
    function CreateAction: TCnWizAction; virtual;
    procedure Click(Sender: TObject); virtual;
    function GetCaption: string; virtual; abstract;
    {* ����ר�ҵı��� }
    function GetHint: string; virtual;
    {* ����ר�ҵ�Hint��ʾ }
    function GetDefShortCut: TShortCut; virtual;
    {* ����ר�ҵ�Ĭ�Ͽ�ݼ���ʵ��ʹ��ʱר�ҵĿ�ݼ�������ɹ��������趨������
       ֻ��Ҫ����Ĭ�ϵľ����ˡ� }
  public
    constructor Create; override;
    {* �๹���� }
    destructor Destroy; override;
    {* �������� }
    property ImageIndex: Integer read GetImageIndex;
    {* ר��ͼ���� IDE ���� ImageList �е������� }
    property Action: TCnWizAction read FAction;
    {* ר�� Action ���� }
    function EnableShortCut: Boolean; virtual;
    {* ����ר���Ƿ�����ÿ�ݼ����� }
    procedure RefreshAction; virtual;
    {* ���¸��� Action ������ }
  end;

//==============================================================================
// ���˵��ĳ���ר����
//==============================================================================

{ TCnMenuWizard }

type
  TCnMenuWizard = class(TCnActionWizard)
  {* ���˵��� CnWizard ר�ҳ������ }
  private
    FMenuOrder: Integer;
    function GetAction: TCnWizMenuAction;
    function GetMenu: TMenuItem;
    procedure SetMenuOrder(const Value: Integer);
  protected
    function CreateAction: TCnWizAction; override;
  public
    constructor Create; override;
    function EnableShortCut: Boolean; override;
    {* ����ר���Ƿ�����ÿ�ݼ����� }
    property Menu: TMenuItem read GetMenu;
    {* ר�ҵĲ˵����� }
    property Action: TCnWizMenuAction read GetAction;
    {* ר�� Action ���� }
    property MenuOrder: Integer read FMenuOrder write SetMenuOrder;
  end;

//==============================================================================
// ���Ӳ˵���ĳ���ר����
//==============================================================================

{ TCnSubMenuWizard }

  TCnSubMenuWizard = class(TCnMenuWizard)
  {* ���Ӳ˵���� CnWizard ר�ҳ������ }
  private
    FList: TList;
    FPopupMenu: TPopupMenu;
    FPopupAction: TCnWizAction;
    FExecuting: Boolean;
    FRefreshing: Boolean;
    procedure FreeSubMenus;
    procedure OnExecute(Sender: TObject);
    procedure OnUpdate(Sender: TObject);
    procedure OnPopup(Sender: TObject);
    function GetSubActions(Index: Integer): TCnWizMenuAction;
    function GetSubActionCount: Integer;
    function GetSubMenus(Index: Integer): TMenuItem;
  protected
    procedure OnActionUpdate(Sender: TObject); override;
    function CreateAction: TCnWizAction; override;
    procedure Click(Sender: TObject); override;
    function IndexOf(SubAction: TCnWizMenuAction): Integer;
    {* ����ָ���� Action ���б��е������� }
    function RegisterASubAction(const ACommand, ACaption: string;
      AShortCut: TShortCut = 0; const AHint: string = '';
      const AIconName: string = ''): Integer;
    {* ע��һ���� Action�����������š�
     |<PRE>
       ACommand: string         - Action �����֣�����Ϊһ��Ψһ���ַ���ֵ
       ACaption: string         - Action �ı���
       AShortCut: TShortCut     - Action ��Ĭ�Ͽ�ݼ���ʵ��ʹ�õļ�ֵ���ע����ж�ȡ
       AHint: string            - Action ����ʾ��Ϣ
       Result: Integer          - �����б��е�������
     |</PRE> }
    procedure AddSubMenuWizard(SubMenuWiz: TCnSubMenuWizard);
    {* Ϊ��ר�ҹҽ�һ���Ӳ˵�ר�� }
    procedure AddSepMenu;
    {* ����һ���ָ��˵� }
    procedure DeleteSubAction(Index: Integer);
    {* ɾ��ָ������ Action }

    function ShowShortCutDialog(const HelpStr: string): Boolean;
    {* ��ʾ�� Action ��ݼ����öԻ��� }

    procedure SubActionExecute(Index: Integer); virtual;
    {* �Ӳ˵���ִ�з���������Ϊ�Ӳ˵��������ţ�ר�������ظ÷������� Action ִ���¼� }
    procedure SubActionUpdate(Index: Integer); virtual;
    {* �Ӳ˵�����·���������Ϊ�Ӳ˵��������ţ�ר�������ظ÷������� Action ״̬ }
  public
    constructor Create; override;
    {* �๹���� }
    destructor Destroy; override;
    {* �������� }
    procedure Execute; override;
    {* ִ����ʲô������ }
    procedure AcquireSubActions; virtual;
    {* �������ش˹��̣��ڲ����� RegisterASubAction �����Ӳ˵��
        �˹����ڶ����л�ʱ�ᱻ�ظ����á� }
    procedure ClearSubActions;
    {* ɾ�����е��� Action�������Ӳ˵��еķָ��� }
    procedure RefreshAction; override;
    {* ���ص�ˢ�� Action �ķ��������˼̳�ˢ�²˵����⣬��ˢ���Ӳ˵� Action }
    procedure RefreshSubActions; virtual;
    {* ���������� Action������������ش˷�������ֹ�� Action ���� }
    property SubActionCount: Integer read GetSubActionCount;
    {* ר���� Action ���� }
    property SubMenus[Index: Integer]: TMenuItem read GetSubMenus;
    {* ר�ҵ��Ӳ˵��������� }
    property SubActions[Index: Integer]: TCnWizMenuAction read GetSubActions;
    {* ר�ҵ��� Action �������� }
  end;

//==============================================================================
// ����Repositoryר�һ���
//==============================================================================

{ TCnRepositoryWizard }

  TCnRepositoryWizard = class(TCnIconWizard, IOTARepositoryWizard)
  {* CnWizard ģ���򵼳������ }
  protected
    FIconHandle: HICON;
    function GetName: string; override;
    {* ���� GetName ���������� WizardName ��Ϊ��ʾ���ַ�����  }
  public
    constructor Create; override;
    {* �๹���� }
    destructor Destroy; override;
    {* �������� }

    // IOTARepositoryWizard methods
    function GetPage: string;
    {$IFDEF COMPILER6_UP}
    function GetGlyph: Cardinal;
    {$ELSE}
    function GetGlyph: HICON;
    {$ENDIF}
  end;

//==============================================================================
// ��Ԫģ���򵼻���
//==============================================================================

{ TCnUnitWizard }

  TCnUnitWizard = class(TCnRepositoryWizard, {$IFDEF DELPHI10_UP}IOTAProjectWizard{$ELSE}IOTAFormWizard{$ENDIF});
  {* ����ʵ�� IOTAFormWizard ������ New �Ի����г���, BDS2006 ��Ҫ�� IOTAProjectWizard}

//==============================================================================
// ����ģ���򵼻���
//==============================================================================

{ TCnFormWizard }

  TCnFormWizard = class(TCnRepositoryWizard, IOTAFormWizard);

//==============================================================================
// ����ģ���򵼻���
//==============================================================================

{ TCnProjectWizard }

  TCnProjectWizard = class(TCnRepositoryWizard, IOTAProjectWizard);

//==============================================================================
// ר�����б���ع���
//==============================================================================

procedure RegisterCnWizard(const AClass: TCnWizardClass);
{* ע��һ�� CnBaseWizard ר�������ã�ÿ��ר��ʵ�ֵ�ԪӦ�ڸõ�Ԫ�� initialization
   �ڵ��øù���ע��ר���� }

function GetCnWizardClass(const ClassName: string): TCnWizardClass;
{* ����ר������ȡָ����ר�������� }

function GetCnWizardClassCount: Integer;
{* ������ע���ר�������� }

function GetCnWizardClassByIndex(const Index: Integer): TCnWizardClass;
{* ����������ȡָ����ר�������� }

function GetCnWizardTypeNameFromClass(AClass: TClass): String; 
{* ����ר������ȡר���������� }

function GetCnWizardTypeName(AWizard: TCnBaseWizard): String;
{* ����ר��ʵ����ȡָ����ר�������� }

implementation

uses
  CnWizUtils, CnWizOptions, CnCommon, CnWizCommentFrm, CnWizSubActionShortCutFrm
  {$IFDEF Debug}, CnDebug{$ENDIF Debug};

//==============================================================================
// ר�����б���ع���
//==============================================================================

var
  CnWizardClassList: TList = nil; // ר���������б�

// ע��һ��CnBaseWizardר��������
procedure RegisterCnWizard(const AClass: TCnWizardClass);
begin
  Assert(CnWizardClassList <> nil, 'CnWizardClassList is nil!');
  if CnWizardClassList.IndexOf(AClass) < 0 then
    CnWizardClassList.Add(AClass);
end;

// ����ר������ȡָ����ר��������
function GetCnWizardClass(const ClassName: string): TCnWizardClass;
var
  i: Integer;
begin
  for i := 0 to CnWizardClassList.Count - 1 do
  begin
    Result := CnWizardClassList[i];
    if Result.ClassNameIs(ClassName) then Exit;
  end;
  Result := nil;
end;

// ������ע���ר��������
function GetCnWizardClassCount: Integer;
begin
  Result := CnWizardClassList.Count;
end;

// ����������ȡָ����ר��������
function GetCnWizardClassByIndex(const Index: Integer): TCnWizardClass;
begin
  Result := nil;
  if (Index >= 0) and (Index <= CnWizardClassList.Count - 1) then
    Result := CnWizardClassList[Index];
end;

// ����ר������ȡר����������
function GetCnWizardTypeNameFromClass(AClass: TClass): String;
begin
  if AClass.InheritsFrom(TCnProjectWizard) then
    Result := SCnProjectWizardName
  else if AClass.InheritsFrom(TCnFormWizard) then
    Result := SCnFormWizardName
  else if AClass.InheritsFrom(TCnUnitWizard) then
    Result := SCnUnitWizardName
  else if AClass.InheritsFrom(TCnRepositoryWizard) then
    Result := SCnRepositoryWizardName
  else if AClass.InheritsFrom(TCnSubMenuWizard) then
    Result := SCnSubMenuWizardName
  else if AClass.InheritsFrom(TCnMenuWizard) then
    Result := SCnMenuWizardName
  else if AClass.InheritsFrom(TCnActionWizard) then
    Result := SCnActionWizardName
  else if AClass.InheritsFrom(TCnIDEEnhanceWizard) then
    Result := SCnIDEEnhanceWizardName
  else
    Result := SCnBaseWizardName;
end;

// ����ר��ʵ����ȡָ����ר��������
function GetCnWizardTypeName(AWizard: TCnBaseWizard): String;
begin
  Result := GetCnWizardTypeNameFromClass(AWizard.ClassType);
end;

//==============================================================================
// ר�Ұ�ר�һ�����
//==============================================================================

{ TCnBaseWizard }

// �๹����
constructor TCnBaseWizard.Create;
begin
  inherited Create;
  FWizardIndex := -1;
end;

// ��������
destructor TCnBaseWizard.Destroy;
begin
  inherited Destroy;
end;

{$IFDEF BCB}
class procedure TCnBaseWizard.GetWizardInfo(var Name, Author, Email,
  Comment: string);
begin

end;
{$ENDIF BCB}

// ȡר������
class function TCnBaseWizard.WizardName: string;
var
  Author, Email, Comment: string;
begin
  GetWizardInfo(Result, Author, Email, Comment);
end;

// ����ר��Ψһ��ʶ������������ʹ��
class function TCnBaseWizard.GetIDStr: string;
begin
  Result := RemoveClassPrefix(ClassName);
end;

// ����ר������
function TCnBaseWizard.GetAuthor: string;
var
  Name, Email, Comment: string;
begin
  GetWizardInfo(Name, Result, Email, Comment);
end;

// ����ר��ע��
function TCnBaseWizard.GetComment: string;
var
  Name, Author, Email: string;
begin
  GetWizardInfo(Name, Author, Email, Result);
end;

// ��ר���Ƿ������ڲ�ר�ң�����ʾ����������
class function TCnBaseWizard.IsInternalWizard: Boolean;
begin
  Result := False;
end;

//------------------------------------------------------------------------------
// �������÷���
//------------------------------------------------------------------------------

// ����һ�����ڴ�ȡר�����ò����� INI �����û�ʹ�ú����Լ��ͷ�
class function TCnBaseWizard.CreateIniFile(CompilerSection: Boolean): TCustomIniFile;
var
  Path: string;
begin
  if CompilerSection then
    Path := MakePath(MakePath(WizOptions.RegPath) + GetIDStr) + WizOptions.CompilerID
  else
    Path := MakePath(WizOptions.RegPath) + GetIDStr;
  Result := TRegistryIniFile.Create(Path, KEY_ALL_ACCESS);
end;

procedure TCnBaseWizard.DoLoadSettings;
var
  Ini: TCustomIniFile;
begin
  Ini := CreateIniFile;
  try
  {$IFDEF Debug}
    CnDebugger.LogMsg('Loading settings: ' + ClassName);
  {$ENDIF Debug}
    LoadSettings(Ini);
  finally
    Ini.Free;
  end;
end;

procedure TCnBaseWizard.DoSaveSettings;
var
  Ini: TCustomIniFile;
begin
  Ini := CreateIniFile;
  try
  {$IFDEF Debug}
    CnDebugger.LogMsg('Saving settings: ' + ClassName);
  {$ENDIF Debug}
    SaveSettings(Ini);
  finally
    Ini.Free;
  end;
end;

procedure TCnBaseWizard.Config;
begin
  // do nothing
end;

procedure TCnBaseWizard.LanguageChanged(Sender: TObject);
begin
  // do nothing
end;

procedure TCnBaseWizard.LoadSettings(Ini: TCustomIniFile);
begin
  with TCnIniFile.Create(Ini) do
  try
    ReadObject('', Self);
  finally
    Free;
  end;   
end;

procedure TCnBaseWizard.SaveSettings(Ini: TCustomIniFile);
begin
  with TCnIniFile.Create(Ini) do
  try
    WriteObject('', Self);
  finally
    Free;
  end;   
end;

procedure TCnBaseWizard.Loaded;
begin
  // do nothing
end;

//------------------------------------------------------------------------------
// ���Զ�д����
//------------------------------------------------------------------------------

// HasConfig ���Զ�����
function TCnBaseWizard.GetHasConfig: Boolean;
begin
  Result := False;
end;

// Active  ����д����
procedure TCnBaseWizard.SetActive(Value: Boolean);
begin
  FActive := Value;
end;

//------------------------------------------------------------------------------
// ����ʵ�ֵ� IOTAWizard ����
//------------------------------------------------------------------------------

{ TCnBaseWizard.IOTAWizard }

function TCnBaseWizard.GetIDString: string;
begin
  Result := SCnWizardsNamePrefix + '.' + GetIDStr;
end;

function TCnBaseWizard.GetName: string;
begin
  Result := SCnWizardsNamePrefix + ' ' + GetIDStr;
end;

function TCnBaseWizard.GetState: TWizardState;
begin
  Result := [wsEnabled];
end;

//==============================================================================
// ��ͼ�����ԵĻ�����
//==============================================================================

{ TCnIconWizard }

constructor TCnIconWizard.Create;
begin
  inherited;
  FActive := True;
  FIcon := TIcon.Create;
  InitIcon(FIcon);
end;

destructor TCnIconWizard.Destroy;
begin
  inherited;
  if FIcon <> nil then
    FIcon.Free;
end;

// ���� Icon ���ԣ���ʹ������ͼ�꣬�����ء�
function TCnIconWizard.GetIcon: TIcon;
begin
  Result := FIcon;
end;

// ����ͼ���ļ���
class function TCnIconWizard.GetIconName: string;
begin
  Result := ClassName;
end;

// ����������ʼ��ͼ�꣬�����ء�
procedure TCnIconWizard.InitIcon(AIcon: TIcon);
begin
  if AIcon <> nil then
    CnWizLoadIcon(FIcon, GetIconName);
end;

//==============================================================================
// �� Action �Ϳ�ݼ��ĳ���ר����
//==============================================================================

{ TCnActionWizard }

// �๹����
constructor TCnActionWizard.Create;
begin
  inherited Create;
  FActive := True;
  FAction := CreateAction;
  FAction.OnUpdate := OnActionUpdate;
end;

// ��������
destructor TCnActionWizard.Destroy;
begin
  if Assigned(FAction) then
    WizActionMgr.DeleteAction(FAction);
  inherited Destroy;
end;

// ���¸��� Action ������
procedure TCnActionWizard.RefreshAction;
begin
  if FAction <> nil then
  begin
    FAction.Caption := GetCaption;
    FAction.Hint := GetHint;
  end;
end;

//------------------------------------------------------------------------------
// ���ⷽ��
//------------------------------------------------------------------------------

// Action ����¼�
procedure TCnActionWizard.Click(Sender: TObject);
begin
  try
    if Active and Action.Enabled and (IsInternalWizard or
      ShowCnWizCommentForm(Self)) then
      Execute;
  except
    DoHandleException(ClassName + '.Click');
  end;
end;

// ״̬�����¼�
procedure TCnActionWizard.OnActionUpdate(Sender: TObject);
var
  State: TWizardState;
begin
  State := GetState;
  FAction.Visible := FActive;
  FAction.Enabled := FActive and (wsEnabled in State);
  FAction.Checked := wsChecked in State;
  // ĳЩ����²�������ڿ�ݼ�������Ӳ˵��Ĳ˵���
  if not EnableShortCut then
    FAction.ShortCut := 0;
end;

// ���� Action
function TCnActionWizard.CreateAction: TCnWizAction;
begin
  Result := WizActionMgr.AddAction(GetIDStr, GetCaption, GetDefShortCut, Click,
    GetIconName, GetHint);
end;

// ȡĬ�Ͽ�ݼ�����
function TCnActionWizard.GetDefShortCut: TShortCut;
begin
  Result := 0;
end;

// ȡר���Ƿ�����ÿ�ݼ�����
function TCnActionWizard.EnableShortCut: Boolean;
begin
  Result := True;
end;

// ȡHint��ʾ����
function TCnActionWizard.GetHint: string;
begin
  Result := ''
end;

//------------------------------------------------------------------------------
// ���Զ�д����
//------------------------------------------------------------------------------

// Icon ���Զ�����
function TCnActionWizard.GetIcon: TIcon;
begin
  Assert(Assigned(FAction));
  Result := FAction.Icon;
end;

// ImageIndex ���Զ�����
function TCnActionWizard.GetImageIndex: Integer;
begin
  Assert(Assigned(FAction));
  Result := FAction.ImageIndex;
end;

//==============================================================================
// ���˵��ĳ���ר����
//==============================================================================

{ TCnMenuWizard }

// ���췽��
constructor TCnMenuWizard.Create;
begin
  inherited;
  FMenuOrder := -1;
end;

// ���� MenuOrder ����
procedure TCnMenuWizard.SetMenuOrder(const Value: Integer);
begin
  FMenuOrder := Value;
end;

// �������˵��� Action
function TCnMenuWizard.CreateAction: TCnWizAction;
begin
  Result := WizActionMgr.AddMenuAction(GetIDStr, GetCaption, GetIDStr, GetDefShortCut, Click,
    GetIconName, GetHint);
end;

// Action ���Զ�����
function TCnMenuWizard.GetAction: TCnWizMenuAction;
begin
  Assert(inherited Action is TCnWizMenuAction);
  Result := TCnWizMenuAction(inherited Action);
end;

// Menu ���Զ�����
function TCnMenuWizard.GetMenu: TMenuItem;
begin
  Assert(Assigned(Action));
  Result := Action.Menu;
end;

// �����Ƿ��п�ݼ�
function TCnMenuWizard.EnableShortCut: Boolean;
begin
  Result := (Menu = nil) or (Menu.Count = 0); // ���Ӳ˵���ʱ�������ÿ�ݼ�����
end;

//==============================================================================
// ���Ӳ˵���ĳ���ר����
//==============================================================================

{ TCnSubMenuWizard }

// �๹����
constructor TCnSubMenuWizard.Create;
var
  Svcs40: INTAServices40;
begin
  inherited;
  FList := TList.Create;
  // ����ר�ұ��ŵ���������ʱ�������ť�����Ĳ˵�
  FPopupMenu := TPopupMenu.Create(nil);
  QuerySvcs(BorlandIDEServices, INTAServices40, Svcs40);
  FPopupMenu.Images := Svcs40.ImageList;
  // ���ڹ������������ϰ�ť�� Action
  FPopupAction := WizActionMgr.AddAction(GetIDStr + '1', GetCaption, 0, OnPopup,
    GetIconName, GetHint);
  FPopupAction.OnUpdate := OnActionUpdate;
end;

// ��������
destructor TCnSubMenuWizard.Destroy;
begin
  ClearSubActions;
  FreeSubMenus;
  WizActionMgr.DeleteAction(FPopupAction);
  FPopupMenu.Free;
  FList.Free;
  inherited;
end;

procedure TCnSubMenuWizard.AcquireSubActions;
begin
// ���಻����Ӳ˵���
end;

// ����ר�� Action ��
function TCnSubMenuWizard.CreateAction: TCnWizAction;
begin
  Result := inherited CreateAction;
  Assert(Result is TCnWizMenuAction);
  Result.ActionList := nil; // ��ֹ�� Action ���Զ�������ص� ToolBar ��
  TCnWizMenuAction(Result).Menu.ImageIndex := -1; // ���Ӳ˵������ʾλͼ
end;

// ִ����ʲôҲ����
procedure TCnSubMenuWizard.Execute;
begin
// ִ����ʲô������
end;

// ���Ӳ˵�ר����ˢ�� Action ��ʱ�����أ�˳����� Action Ҳˢ��һ�¡�
procedure TCnSubMenuWizard.RefreshAction;
begin
  inherited;
  // ˢ�����ڹ������������ϰ�ť�� Action
  FRefreshing := True;
  try
    if FPopupAction <> nil then
    begin
      FPopupAction.Caption := GetCaption;
      FPopupAction.Hint := GetHint;
    end;
    RefreshSubActions;
  finally
    FRefreshing := False;
  end;
end;

// ˢ���� Action ���类���أ��ɲ� inherited ����ֹ��ˢ�¡�
procedure TCnSubMenuWizard.RefreshSubActions;
begin
//  ClearSubActions;
  AcquireSubActions;
  WizActionMgr.ArrangeMenuItems(Menu);
end;

// �Ǽ�һ���� Action������������
function TCnSubMenuWizard.RegisterASubAction(const ACommand, ACaption: string;
  AShortCut: TShortCut; const AHint: string; const AIconName: string): Integer;
var
  NewAction: TCnWizMenuAction;
  IconName: string;
  I: Integer;
begin
  if AIconName = '' then
    IconName := ACommand
  else
    IconName := AIconName;

  if FRefreshing then
  begin
    for I := 0 to FList.Count - 1 do
    begin
      if TCnWizMenuAction(FList[I]).Command = ACommand then
      begin
        TCnWizMenuAction(FList[I]).Caption := ACaption;
        TCnWizMenuAction(FList[I]).Hint := AHint;
        Result := I;
        Exit;
      end;
    end;
  end;

  NewAction := WizActionMgr.AddMenuAction(ACommand, ACaption, ACommand, AShortCut,
    OnExecute, IconName, AHint);
  NewAction.OnUpdate := OnUpdate;
  Menu.Add(NewAction.Menu);
  Result := FList.Add(NewAction);
end;

// Ϊ��ר�ҹҽ�һ���Ӳ˵�ר�ң��������� Action ���б��е�������
procedure TCnSubMenuWizard.AddSubMenuWizard(SubMenuWiz: TCnSubMenuWizard);
begin
  // �����Ӳ˵�ר�ҵĲ˵����뱾ר�Ҳ˵�
  Menu.Add(SubMenuWiz.Action.Menu);
  // һ��Ҫ������Ӳ˵�ר�ҵ� Action���μ� ClearSubActions �е�˵��
  FList.Add(SubMenuWiz.Action);
end;

// ����һ���ָ��˵�
procedure TCnSubMenuWizard.AddSepMenu;
var
  SepMenu: TMenuItem;
begin
  if not FRefreshing then
  begin
    SepMenu := TMenuItem.Create(Menu);
    SepMenu.Caption := '-';
    Menu.Add(SepMenu);
  end;
end;

// ����� Action �б������Ӳ˵��еķָ���
procedure TCnSubMenuWizard.ClearSubActions;
var
  WizAction: TCnWizAction;
begin
  while FList.Count > 0 do
  begin
    WizAction := SubActions[0];
    // ����� Action �Ĳ˵����Ӳ˵���˵���� Action ��һ���Ӳ˵�ר�ҵ� Action��
    // ɾ���� Action �Ĺ���Ӧ���������������Ӳ˵�ר�ң��������������Ӳ˵�ר��
    // �뱾ר�Ҳ˵�֮��Ĺ�����������Ӳ˵�ר�ҵ� Menu.Parent ʼ�ղ�Ϊ nil���´�
    // �ٽ����Ӳ˵�ר�ҹ����κ�ר��ʱ������ֲ˵��ظ�������쳣�����ұ�������
    // �� Menu.Clear ��ɾ�����Ӳ˵�ר�ҵĲ˵������Ӳ˵�ר�����ͷ�ʱ��ͨ��ɾ����
    // �� Action ɾ�����Ӳ˵�ʱ�������Ӳ˵��ѱ�ɾ���������� AV �쳣��
    // LiuXiao: �Ӳ˵�ר�һ��ͷ��� Action�������ظ��ͷ������´���
    try
      if Assigned(WizAction) and (WizAction is TCnWizMenuAction) and
        (TCnWizMenuAction(WizAction).Menu.Count > 0) then
        Menu.Remove(TCnWizMenuAction(WizAction).Menu)
      else
        WizActionMgr.DeleteAction(WizAction);
    except
      ;
    end;
    FList.Delete(0);
  end;
  Menu.Clear; // ɾ���Ӳ˵��еķָ���
end;

// ɾ��һ���� Action
procedure TCnSubMenuWizard.DeleteSubAction(Index: Integer);
var
  WizAction: TCnWizAction;
begin
  if (Index >= 0) and (Index < FList.Count) then
  begin
    WizAction := SubActions[Index];
    // ����� Action �Ĳ˵����Ӳ˵���˵���� Action ��һ���Ӳ˵�ר�ҵ� Action��
    // ɾ���� Action �Ĺ���Ӧ���������������Ӳ˵�ר�ң��������������Ӳ˵�ר��
    // �뱾ר�Ҳ˵�֮��Ĺ�����������Ӳ˵�ר�ҵ� Menu.Parent ʼ�ղ�Ϊ nil���´�
    // �ٽ����Ӳ˵�ר�ҹ����κ�ר��ʱ������ֲ˵��ظ�������쳣��
    if Assigned(WizAction) and (WizAction is TCnWizMenuAction) and
      (TCnWizMenuAction(WizAction).Menu.Count > 0) then
      Menu.Remove(TCnWizMenuAction(WizAction).Menu)
    else
      WizActionMgr.DeleteAction(WizAction);
    FList.Delete(Index);
  end;
end;

// �ͷŲ˵���
procedure TCnSubMenuWizard.FreeSubMenus;
begin
  Menu.Clear;
end;

// ����ָ���� Action ���б��е�������
function TCnSubMenuWizard.IndexOf(SubAction: TCnWizMenuAction): Integer;
var
  i: Integer;
begin
  Result := -1;
  for i := 0 to FList.Count - 1 do
    if SubActions[i] = SubAction then
    begin
      Result := i;
      Exit;
    end;
end;

// ר�ҵ��÷���
procedure TCnSubMenuWizard.Click(Sender: TObject);
begin
  // ���̳е��ñ�����ʾ������ʾ�Ի���
end;

// Action ִ����
procedure TCnSubMenuWizard.OnExecute(Sender: TObject);
var
  i: Integer;
begin
  if not Active or FExecuting then Exit;
  FExecuting := True;
  try
    for i := 0 to FList.Count - 1 do
      if TObject(FList[i]) = Sender then
      begin
        // ��ֹͨ����ݼ�������Ч�Ĺ���
        SubActions[i].Update;
        if SubActions[i].Enabled then
        begin
          try
            // �ڲ�ר�Ҳ���ʾ
            if IsInternalWizard or ShowCnWizCommentForm(WizardName + ' - ' +
              GetCaptionOrgStr(SubActions[i].Caption), SubActions[i].Icon,
              SubActions[i].Command) then
              SubActionExecute(i);
          except
            DoHandleException(Format('%s.SubActions[%d].Execute',
              [ClassName, i]));
          end;
        end;

        Exit;
      end;
  finally
    FExecuting := False;
  end;
end;

// Action ����
procedure TCnSubMenuWizard.OnUpdate(Sender: TObject);
var
  i: Integer;
begin
  OnActionUpdate(nil);
  for i := 0 to FList.Count - 1 do
    if TObject(FList[i]) = Sender then
    begin
      SubActionUpdate(i);
      Exit;
    end;
end;

// ��ʾ��ݼ����öԻ���
function TCnSubMenuWizard.ShowShortCutDialog(const HelpStr: string): Boolean;
begin
  Result := SubActionShortCutConfig(Self, HelpStr);
end;

procedure TCnSubMenuWizard.OnActionUpdate(Sender: TObject);
begin
  inherited;
  FPopupAction.Visible := Action.Visible;
  FPopupAction.Enabled := Action.Enabled;
  FPopupAction.Checked := Action.Checked;
end;

procedure TCnSubMenuWizard.OnPopup(Sender: TObject);
var
  Point: TPoint;

  procedure AddMenuSubItems(SrcItem, DstItem: TMenuItem);
  var
    MenuItem, SubItem: TMenuItem;
    I, J: Integer;
  begin
    for I := 0 to SrcItem.Count - 1 do
    begin
      MenuItem := TMenuItem.Create(FPopupMenu);
      MenuItem.Action := SrcItem.Items[I].Action;
      if not Assigned(MenuItem.Action) then
        MenuItem.Caption := SrcItem.Items[I].Caption
      else if MenuItem.Action is TCnWizMenuAction then
      begin  // ��Ӷ����Ӳ˵�
        for J := 0 to TCnWizMenuAction(MenuItem.Action).Menu.Count - 1 do
        begin
          SubItem := TMenuItem.Create(FPopupMenu);
          SubItem.Action := TCnWizMenuAction(MenuItem.Action).Menu.Items[J].Action;
          if not Assigned(SubItem.Action) then
            SubItem.Caption := TCnWizMenuAction(MenuItem.Action).Menu.Items[J].Caption;
          MenuItem.Add(SubItem);
        end;
      end;
      AddMenuSubItems(SrcItem.Items[I], MenuItem);
      DstItem.Add(MenuItem);
    end;
  end;
begin
  FPopupMenu.Items.Clear;
  AddMenuSubItems(Menu, FPopupMenu.Items);
  GetCursorPos(Point);
  FPopupMenu.Popup(Point.x, Point.y);
end;

//------------------------------------------------------------------------------
// ���ⷽ��
//------------------------------------------------------------------------------

// �Ӳ˵���ִ�з���������Ϊ�Ӳ˵���������
procedure TCnSubMenuWizard.SubActionExecute(Index: Integer);
begin

end;

// �Ӳ˵�����·���������Ϊ�Ӳ˵���������
procedure TCnSubMenuWizard.SubActionUpdate(Index: Integer);
begin
  SubActions[Index].Visible := Active;
  SubActions[Index].Enabled := Active and Action.Enabled;
end;

//------------------------------------------------------------------------------
// ���Զ�д����
//------------------------------------------------------------------------------

// SubActionCount ���Զ�����
function TCnSubMenuWizard.GetSubActionCount: Integer;
begin
  Result := FList.Count;
end;

// SubActions ���Զ�����
function TCnSubMenuWizard.GetSubActions(Index: Integer): TCnWizMenuAction;
begin
  Result := nil;
  if (Index >= 0) and (Index < FList.Count) then
    Result := TCnWizMenuAction(FList[Index]);
end;

// SubMenus ���Զ�����
function TCnSubMenuWizard.GetSubMenus(Index: Integer): TMenuItem;
begin
  Result := nil;
  if (Index >= 0) and (Index < FList.Count) then
    Result := TCnWizMenuAction(FList[Index]).Menu; 
end;

//==============================================================================
// ����Repositoryר�һ���
//==============================================================================

{ TCnRepositoryWizard }

// ��������
constructor TCnRepositoryWizard.Create;
begin
  inherited;
  FIconHandle := 0;
end;

// ��������
destructor TCnRepositoryWizard.Destroy;
begin
  if FIcon <> nil then
    FreeAndNil(FIcon);
//  if FIconHandle <> 0 then    // �� IDE �ͷţ��˴�����Ҫ�ͷţ���л niaoge �ļ��
//    DestroyIcon(FIconHandle);
  inherited;
end;

// ���� GetName ���������� WizardName ��Ϊ��ʾ���ַ�����
function TCnRepositoryWizard.GetName: string;
begin
  Result := WizardName;
end;

//------------------------------------------------------------------------------
// ����ʵ�ֵ� IOTARepositoryWizard ����
//------------------------------------------------------------------------------

{ TCnRepositoryWizard.IOTARepositoryWizard }

// ����ͼ����
{$IFDEF COMPILER6_UP}
function TCnRepositoryWizard.GetGlyph: Cardinal;
{$ELSE}
function TCnRepositoryWizard.GetGlyph: HICON;
{$ENDIF}
begin
  // IDE ��������������ͼ�꣬�����ʹ�� CopyIcon ���޷�������ʾ�����һ�
  // ��ԭ�е�ͼ��������˴��Ĵ���ɱ�֤ͼ��������ʾ�����Ҳ��������Դй©��
  DestroyIcon(FIconHandle);
  FIconHandle := CopyIcon(Icon.Handle);
  Result := FIconHandle;
end;

// ���ذ�װҳ��
function TCnRepositoryWizard.GetPage: string;
begin
  Result := SCnWizardsPage;
end;

initialization
  CnWizardClassList := TList.Create;

finalization
{$IFDEF Debug}
  CnDebugger.LogEnter('CnBaseWizard finalization.');
{$ENDIF Debug}

  FreeAndNil(CnWizardClassList);

{$IFDEF Debug}
  CnDebugger.LogLeave('CnBaseWizard finalization.');
{$ENDIF Debug}

end.




