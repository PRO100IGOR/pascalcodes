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

unit CnWizOptions;
{* |<PRE>
================================================================================
* ������ƣ�CnPack IDE ר�Ұ�
* ��Ԫ���ƣ�CnWizards ���������൥Ԫ
* ��Ԫ���ߣ�CnPack ������
* ��    ע��
* ����ƽ̨��PWin2000Pro + Delphi 5.01
* ���ݲ��ԣ�PWin9X/2000/XP + Delphi 5/6/7 + C++Builder 5/6
* �� �� �����õ�Ԫ�е��ַ��������ϱ��ػ�����ʽ
* ��Ԫ��ʶ��$Id: CnWizOptions.pas 763 2011-02-07 14:18:23Z liuxiao@cnpack.org $
* �޸ļ�¼��2002.11.07 V1.0
*               ������Ԫ
================================================================================
|</PRE>}

interface

uses
  Windows, Messages, Classes, Graphics, Controls, SysUtils, IniFiles, Forms;

type

//==============================================================================
// ר�ҹ���������
//==============================================================================

{ TCnWizOptions }

  TCnWizUpgradeStyle = (usDisabled, usAllUpgrade, usUserDefine);
  TCnWizUpgradeContentE = (ucNewFeature, ucBigBugFixed);
  TCnWizUpgradeContent = set of TCnWizUpgradeContentE;

  TCnWizOptions = class (TObject)
  {* ר�һ���������}
  private
    FShowHint: Boolean;
    FUpgradeReleaseOnly: Boolean;
    FShowTipOfDay: Boolean;
    FShowWizComment: Boolean;
    FCurrentLangID: Cardinal;
    FRegPath: string;
    FHelpPath: string;
    FCompEditorRegPath: string;
    FCompilerPath: string;
    FDllPath: string;
    FDllName: string;
    FCompilerName: string;
    FIconPath: string;
    FPropEditorRegPath: string;
    FDelphiExt: string;
    FUpgradeURL: string;
    FIdeEhnRegPath: string;
    FCExt: string;
    FLangPath: string;
    FDataPath: string;
    FUserPath: string;
    FNightlyBuildURL: string;
    FCompilerRegPath: string;
    FRegBase: string;
    FTemplatePath: string;
    FCompilerID: string;
    FUpgradeContent: TCnWizUpgradeContent;
    FUpgradeStyle: TCnWizUpgradeStyle;
    FUpgradeLastDate: TDateTime;
    FBuildDate: TDateTime;
    function GetUpgradeCheckDate: TDateTime;
    function GetUseToolsMenu: Boolean;
    procedure SetCurrentLangID(const Value: Cardinal);
    procedure SetUpgradeCheckDate(const Value: TDateTime);
    procedure SetUseToolsMenu(const Value: Boolean);
  public
    constructor Create;
    destructor Destroy; override;
    procedure LoadSettings;
    procedure SaveSettings;

    // ������д����
    function CreateRegIniFile: TCustomIniFile; overload;
    {* ����һ��ר�Ұ���·���� INI ����}
    function CreateRegIniFileEx(const APath: string;
      CompilerSection: Boolean = False): TCustomIniFile; overload;
    {* ����һ��ָ��·���� INI ����CompilerSection ��ʾ�Ƿ�ʹ�ñ�������صĺ�׺}
    function ReadBool(const Section, Ident: string; Default: Boolean): Boolean;
    {* ��ר�Ұ���·���� INI �����ж�ȡ Bool ֵ}
    function ReadInteger(const Section, Ident: string; Default: Integer): Integer;
    {* ��ר�Ұ���·���� INI �����ж�ȡ Integer ֵ}
    function ReadString(const Section, Ident: string; Default: string): string;
    {* ��ר�Ұ���·���� INI �����ж�ȡ String ֵ}
    procedure WriteBool(const Section, Ident: string; Value: Boolean);
    {* ��ר�Ұ���·���� INI ������д Bool ֵ}
    procedure WriteInteger(const Section, Ident: string; Value: Integer);
    {* ��ר�Ұ���·���� INI ������д Integer ֵ}
    procedure WriteString(const Section, Ident: string; Value: string);
    {* ��ר�Ұ���·���� INI ������д String ֵ}

    function IsDelphiSource(const FileName: string): Boolean;
    {* �ж�ָ���ļ��Ƿ� Delphi Դ�ļ���ʹ�����û����õ���չ���б��ж�}
    function IsCSource(const FileName: string): Boolean;
    {* �ж�ָ���ļ��Ƿ� C Դ�ļ���ʹ�����û����õ���չ���б��ж�}

    function GetUserFileName(const FileName: string; IsRead: Boolean; FileNameDef:
      string = ''): string;
    {* �����û������ļ�������� UserPath �µ��ļ������ڣ����� DataPath �е��ļ���}
    function CheckUserFile(const FileName: string; FileNameDef: string = ''):
      Boolean;
    {* ����û������ļ������ UserPath �µ��ļ��� DataPath �µ�һ�£�ɾ��
       UserPath �µ��ļ����Ա�֤ DataPath �µ��ļ�������ʹ��Ĭ�����õ�
       �û����Ի�ø��¡�������ļ�һ�£����� True}
    function LoadUserFile(Lines: TStrings; const FileName: string; FileNameDef:
      string = ''; DoTrim: Boolean = True): Boolean;
    {* װ���û��ļ����ַ����б� }
    function SaveUserFile(Lines: TStrings; const FileName: string; FileNameDef:
      string = ''; DoTrim: Boolean = True): Boolean;
    {* �����ַ����б��û��ļ� }

    // ר�� DLL ����
    property DllName: string read FDllName;
    {* ר�� DLL �ļ���}
    property DllPath: string read FDllPath;
    {* ר�� DLL ���ڵ�Ŀ¼}
    property CompilerPath: string read FCompilerPath;

    // ��ǰ���� ID
    property CurrentLangID: Cardinal read FCurrentLangID write SetCurrentLangID;

    // ר��ʹ�õ�Ŀ¼��
    property LangPath: string read FLangPath;
    {* �����Դ洢�ļ�Ŀ¼ }
    property IconPath: string read FIconPath;
    {* ͼ��Ŀ¼}
    property DataPath: string read FDataPath;
    {* ϵͳ����Ŀ¼�������ֻ���������ļ�������������ݻᱻ����}
    property TemplatePath: string read FTemplatePath;
    {* ֻ����ϵͳģ���ļ����Ŀ¼����������Ŀ¼֮�� }
    property UserPath: string read FUserPath;
    {* �û�����Ŀ¼��������б����û����ݺ����õ��ļ���ţ�����װʱ��ѡ��ɾ����Ŀ¼}
    property HelpPath: string read FHelpPath;
    {* �����ļ�Ŀ¼�����ר�Ұ������ļ�}

    // ע���·��
    property RegBase: string read FRegBase;
    {* CnPack ע����·��������ͨ�� -cnregXXXX ָ�� }
    property RegPath: string read FRegPath;
    {* ר�Ұ�ʹ�õ�ע���·��}
    property PropEditorRegPath: string read FPropEditorRegPath;
    {* ר�Ұ����Ա༭������ʹ�õ�ע���·��}
    property CompEditorRegPath: string read FCompEditorRegPath;
    {* ר�Ұ�����༭������ʹ�õ�ע���·��}
    property IdeEhnRegPath: string read FIdeEhnRegPath;
    {* ר�Ұ� IDE ��չ����ʹ�õ�ע���·��}

    // ��������ز���
    property CompilerName: string read FCompilerName;
    {* ���������ƣ��� Delphi 5}
    property CompilerID: string read FCompilerID;
    {* ��������д���� D5}
    property CompilerRegPath: string read FCompilerRegPath;
    {* ������ IDE ʹ�õ�ע���·��}

    // �û�����
    property DelphiExt: string read FDelphiExt write FDelphiExt;
    {* �û������ Delphi �ļ���չ��}
    property CExt: string read FCExt write FCExt;
    {* �û������ C �ļ���չ��}
    property ShowHint: Boolean read FShowHint write FShowHint;
    {* �Ƿ���ʾ�ؼ� Hint��������Ӧ�� Create ʱ���� TForm.ShowHint ���ڸ�ֵ}
    property ShowWizComment: Boolean read FShowWizComment write FShowWizComment;
    {* �Ƿ���ʾ������ʾ����}
    property ShowTipOfDay: Boolean read FShowTipOfDay write FShowTipOfDay;
    {* �Ƿ���ʾÿ��һ�� }

    // �����������
    property BuildDate: TDateTime read FBuildDate;
    {* ר�� Build ����}
    property UpgradeURL: string read FUpgradeURL;
    property NightlyBuildURL: string read FNightlyBuildURL;
    {* ר����������ַ}
    property UpgradeStyle: TCnWizUpgradeStyle read FUpgradeStyle write FUpgradeStyle;
    {* ר��������ⷽʽ}
    property UpgradeContent: TCnWizUpgradeContent read FUpgradeContent write FUpgradeContent;
    {* ר�������������}
    property UpgradeReleaseOnly: Boolean read FUpgradeReleaseOnly write FUpgradeReleaseOnly;
    {* �Ƿ�ֻ���ǵ��԰��ר������}
    property UpgradeLastDate: TDateTime read FUpgradeLastDate write FUpgradeLastDate;
    {* ���һ�μ�����������}
    property UpgradeCheckDate: TDateTime read GetUpgradeCheckDate write SetUpgradeCheckDate;
    {* ���˵��Ƿ񼯳ɵ� Tools �˵��� }
    property UseToolsMenu: Boolean read GetUseToolsMenu write SetUseToolsMenu;
  end;

function WizOptions: TCnWizOptions; overload;
{* ר�һ�����������}
  
implementation

{ TCnWizOptions }

function TCnWizOptions.CheckUserFile(const FileName: string;
  FileNameDef: string): Boolean;
begin

end;

constructor TCnWizOptions.Create;
begin

end;

function TCnWizOptions.CreateRegIniFile: TCustomIniFile;
begin

end;

function TCnWizOptions.CreateRegIniFileEx(const APath: string;
  CompilerSection: Boolean): TCustomIniFile;
begin

end;

destructor TCnWizOptions.Destroy;
begin

  inherited;
end;

function TCnWizOptions.GetUpgradeCheckDate: TDateTime;
begin

end;

function TCnWizOptions.GetUserFileName(const FileName: string;
  IsRead: Boolean; FileNameDef: string): string;
begin

end;

function TCnWizOptions.GetUseToolsMenu: Boolean;
begin

end;

function TCnWizOptions.IsCSource(const FileName: string): Boolean;
begin

end;

function TCnWizOptions.IsDelphiSource(const FileName: string): Boolean;
begin

end;

procedure TCnWizOptions.LoadSettings;
begin

end;

function TCnWizOptions.LoadUserFile(Lines: TStrings;
  const FileName: string; FileNameDef: string; DoTrim: Boolean): Boolean;
begin

end;

function TCnWizOptions.ReadBool(const Section, Ident: string;
  Default: Boolean): Boolean;
begin

end;

function TCnWizOptions.ReadInteger(const Section, Ident: string;
  Default: Integer): Integer;
begin

end;

function TCnWizOptions.ReadString(const Section, Ident: string;
  Default: string): string;
begin

end;

procedure TCnWizOptions.SaveSettings;
begin

end;

function TCnWizOptions.SaveUserFile(Lines: TStrings;
  const FileName: string; FileNameDef: string; DoTrim: Boolean): Boolean;
begin

end;

procedure TCnWizOptions.SetCurrentLangID(const Value: Cardinal);
begin
  FCurrentLangID := Value;
end;

procedure TCnWizOptions.SetUpgradeCheckDate(const Value: TDateTime);
begin

end;

procedure TCnWizOptions.SetUseToolsMenu(const Value: Boolean);
begin

end;

procedure TCnWizOptions.WriteBool(const Section, Ident: string;
  Value: Boolean);
begin

end;

procedure TCnWizOptions.WriteInteger(const Section, Ident: string;
  Value: Integer);
begin

end;

procedure TCnWizOptions.WriteString(const Section, Ident: string;
  Value: string);
begin

end;

function WizOptions: TCnWizOptions;
begin

end;

end.
