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

unit CnScript_CnWizOptions;
{ |<PRE>
================================================================================
* ������ƣ�CnPack IDE ר�Ұ�
* ��Ԫ���ƣ��ű���չ CnWizIdeUtils ע����
* ��Ԫ���ߣ��ܾ��� (zjy@cnpack.org)
* ��    ע���õ�Ԫ�� UnitParser v0.7 �Զ����ɵ��ļ��޸Ķ���
* ����ƽ̨��PWinXP SP2 + Delphi 5.01
* ���ݲ��ԣ�PWin9X/2000/XP + Delphi 5/6/7
* �� �� �����ô����е��ַ���֧�ֱ��ػ�����ʽ
* ��Ԫ��ʶ��$Id: CnScript_CnWizOptions.pas 763 2011-02-07 14:18:23Z liuxiao@cnpack.org $
* �޸ļ�¼��2006.12.31 V1.0
*               ������Ԫ
================================================================================
|</PRE>}

interface

{$I CnWizards.inc}

uses
  Windows, SysUtils, Classes, Forms, ToolsAPI, IniFiles, CnWizOptions,
  uPSComponent, uPSRuntime, uPSCompiler;

type

  TPSImport_CnWizOptions = class(TPSPlugin)
  public
    procedure CompileImport1(CompExec: TPSScript); override;
    procedure ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter); override;
  end;

  { compile-time registration functions }
procedure SIRegister_TCnWizOptions(CL: TPSPascalCompiler);
procedure SIRegister_CnWizOptions(CL: TPSPascalCompiler);

{ run-time registration functions }
procedure RIRegister_CnWizOptions_Routines(S: TPSExec);
procedure RIRegister_TCnWizOptions(CL: TPSRuntimeClassImporter);
procedure RIRegister_CnWizOptions(CL: TPSRuntimeClassImporter);

implementation

(* === compile-time registration functions === *)

procedure SIRegister_TCnWizOptions(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TObject', 'TCnWizOptions') do
  with CL.AddClassN(CL.FindClass('TObject'), 'TCnWizOptions') do
  begin
    RegisterMethod('Constructor Create');
    RegisterMethod('Procedure LoadSettings');
    RegisterMethod('Procedure SaveSettings');
    RegisterMethod('Function CreateRegIniFile : TCustomIniFile;');
    RegisterMethod('Function CreateRegIniFileEx( const APath : string; CompilerSection : Boolean) : TCustomIniFile;');
    RegisterMethod('Function ReadBool( const Section, Ident : string; Default : Boolean) : Boolean');
    RegisterMethod('Function ReadInteger( const Section, Ident : string; Default : Integer) : Integer');
    RegisterMethod('Function ReadString( const Section, Ident : string; Default : string) : string');
    RegisterMethod('Procedure WriteBool( const Section, Ident : string; Value : Boolean)');
    RegisterMethod('Procedure WriteInteger( const Section, Ident : string; Value : Integer)');
    RegisterMethod('Procedure WriteString( const Section, Ident : string; Value : string)');
    RegisterMethod('Function IsDelphiSource( const FileName : string) : Boolean');
    RegisterMethod('Function IsCSource( const FileName : string) : Boolean');
    RegisterMethod('Function GetUserFileName( const FileName : string; IsRead : Boolean; FileNameDef : string) : string');
    RegisterMethod('Function CheckUserFile( const FileName : string; FileNameDef : string) : Boolean');
    RegisterMethod('Function LoadUserFile( Lines : TStrings; const FileName : string; FileNameDef : string; DoTrim : Boolean) : Boolean');
    RegisterMethod('Function SaveUserFile( Lines : TStrings; const FileName : string; FileNameDef : string; DoTrim : Boolean) : Boolean');
    RegisterProperty('DllName', 'string', iptr);
    RegisterProperty('DllPath', 'string', iptr);
    RegisterProperty('CompilerPath', 'string', iptr);
    RegisterProperty('CurrentLangID', 'Cardinal', iptrw);
    RegisterProperty('LangPath', 'string', iptr);
    RegisterProperty('IconPath', 'string', iptr);
    RegisterProperty('DataPath', 'string', iptr);
    RegisterProperty('TemplatePath', 'string', iptr);
    RegisterProperty('UserPath', 'string', iptr);
    RegisterProperty('HelpPath', 'string', iptr);
    RegisterProperty('RegBase', 'string', iptr);
    RegisterProperty('RegPath', 'string', iptr);
    RegisterProperty('PropEditorRegPath', 'string', iptr);
    RegisterProperty('CompEditorRegPath', 'string', iptr);
    RegisterProperty('IdeEhnRegPath', 'string', iptr);
    RegisterProperty('CompilerName', 'string', iptr);
    RegisterProperty('CompilerID', 'string', iptr);
    RegisterProperty('CompilerRegPath', 'string', iptr);
    RegisterProperty('DelphiExt', 'string', iptrw);
    RegisterProperty('CExt', 'string', iptrw);
    RegisterProperty('ShowHint', 'Boolean', iptrw);
    RegisterProperty('ShowWizComment', 'Boolean', iptrw);
    RegisterProperty('ShowTipOfDay', 'Boolean', iptrw);
    RegisterProperty('BuildDate', 'TDateTime', iptr);
    RegisterProperty('UpgradeURL', 'string', iptr);
    RegisterProperty('NightlyBuildURL', 'string', iptr);
    RegisterProperty('UpgradeStyle', 'TCnWizUpgradeStyle', iptrw);
    RegisterProperty('UpgradeContent', 'TCnWizUpgradeContent', iptrw);
    RegisterProperty('UpgradeReleaseOnly', 'Boolean', iptrw);
    RegisterProperty('UpgradeLastDate', 'TDateTime', iptrw);
    RegisterProperty('UpgradeCheckDate', 'TDateTime', iptrw);
    RegisterProperty('UseToolsMenu', 'Boolean', iptrw);
  end;
end;

procedure SIRegister_CnWizOptions(CL: TPSPascalCompiler);
begin
  CL.AddTypeS('TCnWizUpgradeStyle', '( usDisabled, usAllUpgrade, usUserDefine )');
  CL.AddTypeS('TCnWizUpgradeContentE', '( ucNewFeature, ucBigBugFixed )');
  CL.AddTypeS('TCnWizUpgradeContent', 'set of TCnWizUpgradeContentE');
  SIRegister_TCnWizOptions(CL);
  CL.AddDelphiFunction('Function WizOptions : TCnWizOptions');
end;

(* === run-time registration functions === *)

procedure TCnWizOptionsUseToolsMenu_W(Self: TCnWizOptions; const T: Boolean);
begin
  Self.UseToolsMenu := T;
end;

procedure TCnWizOptionsUseToolsMenu_R(Self: TCnWizOptions; var T: Boolean);
begin
  T := Self.UseToolsMenu;
end;

procedure TCnWizOptionsUpgradeCheckDate_W(Self: TCnWizOptions; const T: TDateTime);
begin
  Self.UpgradeCheckDate := T;
end;

procedure TCnWizOptionsUpgradeCheckDate_R(Self: TCnWizOptions; var T: TDateTime);
begin
  T := Self.UpgradeCheckDate;
end;

procedure TCnWizOptionsUpgradeLastDate_W(Self: TCnWizOptions; const T: TDateTime);
begin
  Self.UpgradeLastDate := T;
end;

procedure TCnWizOptionsUpgradeLastDate_R(Self: TCnWizOptions; var T: TDateTime);
begin
  T := Self.UpgradeLastDate;
end;

procedure TCnWizOptionsUpgradeReleaseOnly_W(Self: TCnWizOptions; const T: Boolean);
begin
  Self.UpgradeReleaseOnly := T;
end;

procedure TCnWizOptionsUpgradeReleaseOnly_R(Self: TCnWizOptions; var T: Boolean);
begin
  T := Self.UpgradeReleaseOnly;
end;

procedure TCnWizOptionsUpgradeContent_W(Self: TCnWizOptions; const T: TCnWizUpgradeContent);
begin
  Self.UpgradeContent := T;
end;

procedure TCnWizOptionsUpgradeContent_R(Self: TCnWizOptions; var T: TCnWizUpgradeContent);
begin
  T := Self.UpgradeContent;
end;

procedure TCnWizOptionsUpgradeStyle_W(Self: TCnWizOptions; const T: TCnWizUpgradeStyle);
begin
  Self.UpgradeStyle := T;
end;

procedure TCnWizOptionsUpgradeStyle_R(Self: TCnWizOptions; var T: TCnWizUpgradeStyle);
begin
  T := Self.UpgradeStyle;
end;

procedure TCnWizOptionsNightlyBuildURL_R(Self: TCnWizOptions; var T: string);
begin
  T := Self.NightlyBuildURL;
end;

procedure TCnWizOptionsUpgradeURL_R(Self: TCnWizOptions; var T: string);
begin
  T := Self.UpgradeURL;
end;

procedure TCnWizOptionsBuildDate_R(Self: TCnWizOptions; var T: TDateTime);
begin
  T := Self.BuildDate;
end;

procedure TCnWizOptionsShowTipOfDay_W(Self: TCnWizOptions; const T: Boolean);
begin
  Self.ShowTipOfDay := T;
end;

procedure TCnWizOptionsShowTipOfDay_R(Self: TCnWizOptions; var T: Boolean);
begin
  T := Self.ShowTipOfDay;
end;

procedure TCnWizOptionsShowWizComment_W(Self: TCnWizOptions; const T: Boolean);
begin
  Self.ShowWizComment := T;
end;

procedure TCnWizOptionsShowWizComment_R(Self: TCnWizOptions; var T: Boolean);
begin
  T := Self.ShowWizComment;
end;

procedure TCnWizOptionsShowHint_W(Self: TCnWizOptions; const T: Boolean);
begin
  Self.ShowHint := T;
end;

procedure TCnWizOptionsShowHint_R(Self: TCnWizOptions; var T: Boolean);
begin
  T := Self.ShowHint;
end;

procedure TCnWizOptionsCExt_W(Self: TCnWizOptions; const T: string);
begin
  Self.CExt := T;
end;

procedure TCnWizOptionsCExt_R(Self: TCnWizOptions; var T: string);
begin
  T := Self.CExt;
end;

procedure TCnWizOptionsDelphiExt_W(Self: TCnWizOptions; const T: string);
begin
  Self.DelphiExt := T;
end;

procedure TCnWizOptionsDelphiExt_R(Self: TCnWizOptions; var T: string);
begin
  T := Self.DelphiExt;
end;

procedure TCnWizOptionsCompilerRegPath_R(Self: TCnWizOptions; var T: string);
begin
  T := Self.CompilerRegPath;
end;

procedure TCnWizOptionsCompilerID_R(Self: TCnWizOptions; var T: string);
begin
  T := Self.CompilerID;
end;

procedure TCnWizOptionsCompilerName_R(Self: TCnWizOptions; var T: string);
begin
  T := Self.CompilerName;
end;

procedure TCnWizOptionsIdeEhnRegPath_R(Self: TCnWizOptions; var T: string);
begin
  T := Self.IdeEhnRegPath;
end;

procedure TCnWizOptionsCompEditorRegPath_R(Self: TCnWizOptions; var T: string);
begin
  T := Self.CompEditorRegPath;
end;

procedure TCnWizOptionsPropEditorRegPath_R(Self: TCnWizOptions; var T: string);
begin
  T := Self.PropEditorRegPath;
end;

procedure TCnWizOptionsRegPath_R(Self: TCnWizOptions; var T: string);
begin
  T := Self.RegPath;
end;

procedure TCnWizOptionsRegBase_R(Self: TCnWizOptions; var T: string);
begin
  T := Self.RegBase;
end;

procedure TCnWizOptionsHelpPath_R(Self: TCnWizOptions; var T: string);
begin
  T := Self.HelpPath;
end;

procedure TCnWizOptionsUserPath_R(Self: TCnWizOptions; var T: string);
begin
  T := Self.UserPath;
end;

procedure TCnWizOptionsTemplatePath_R(Self: TCnWizOptions; var T: string);
begin
  T := Self.TemplatePath;
end;

procedure TCnWizOptionsDataPath_R(Self: TCnWizOptions; var T: string);
begin
  T := Self.DataPath;
end;

procedure TCnWizOptionsIconPath_R(Self: TCnWizOptions; var T: string);
begin
  T := Self.IconPath;
end;

procedure TCnWizOptionsLangPath_R(Self: TCnWizOptions; var T: string);
begin
  T := Self.LangPath;
end;

procedure TCnWizOptionsCurrentLangID_W(Self: TCnWizOptions; const T: Cardinal);
begin
  Self.CurrentLangID := T;
end;

procedure TCnWizOptionsCurrentLangID_R(Self: TCnWizOptions; var T: Cardinal);
begin
  T := Self.CurrentLangID;
end;

procedure TCnWizOptionsCompilerPath_R(Self: TCnWizOptions; var T: string);
begin
  T := Self.CompilerPath;
end;

procedure TCnWizOptionsDllPath_R(Self: TCnWizOptions; var T: string);
begin
  T := Self.DllPath;
end;

procedure TCnWizOptionsDllName_R(Self: TCnWizOptions; var T: string);
begin
  T := Self.DllName;
end;

function TCnWizOptionsCreateRegIniFileEx_P(Self: TCnWizOptions; const APath: string; CompilerSection: Boolean): TCustomIniFile;
begin
  Result := Self.CreateRegIniFile(APath, CompilerSection);
end;

function TCnWizOptionsCreateRegIniFile_P(Self: TCnWizOptions): TCustomIniFile;
begin
  Result := Self.CreateRegIniFile;
end;

function WizOptions_P: TCnWizOptions;
begin
  Result := WizOptions;
end;  

procedure RIRegister_CnWizOptions_Routines(S: TPSExec);
begin
  S.RegisterDelphiFunction(@WizOptions_P, 'WizOptions', cdRegister);
end;

procedure RIRegister_TCnWizOptions(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TCnWizOptions) do
  begin
    RegisterConstructor(@TCnWizOptions.Create, 'Create');
    RegisterMethod(@TCnWizOptions.LoadSettings, 'LoadSettings');
    RegisterMethod(@TCnWizOptions.SaveSettings, 'SaveSettings');
    RegisterMethod(@TCnWizOptionsCreateRegIniFile_P, 'CreateRegIniFile');
    RegisterMethod(@TCnWizOptionsCreateRegIniFileEx_P, 'CreateRegIniFileEx');
    RegisterMethod(@TCnWizOptions.ReadBool, 'ReadBool');
    RegisterMethod(@TCnWizOptions.ReadInteger, 'ReadInteger');
    RegisterMethod(@TCnWizOptions.ReadString, 'ReadString');
    RegisterMethod(@TCnWizOptions.WriteBool, 'WriteBool');
    RegisterMethod(@TCnWizOptions.WriteInteger, 'WriteInteger');
    RegisterMethod(@TCnWizOptions.WriteString, 'WriteString');
    RegisterMethod(@TCnWizOptions.IsDelphiSource, 'IsDelphiSource');
    RegisterMethod(@TCnWizOptions.IsCSource, 'IsCSource');
    RegisterMethod(@TCnWizOptions.GetUserFileName, 'GetUserFileName');
    RegisterMethod(@TCnWizOptions.CheckUserFile, 'CheckUserFile');
    RegisterMethod(@TCnWizOptions.LoadUserFile, 'LoadUserFile');
    RegisterMethod(@TCnWizOptions.SaveUserFile, 'SaveUserFile');
    RegisterPropertyHelper(@TCnWizOptionsDllName_R, nil, 'DllName');
    RegisterPropertyHelper(@TCnWizOptionsDllPath_R, nil, 'DllPath');
    RegisterPropertyHelper(@TCnWizOptionsCompilerPath_R, nil, 'CompilerPath');
    RegisterPropertyHelper(@TCnWizOptionsCurrentLangID_R, @TCnWizOptionsCurrentLangID_W, 'CurrentLangID');
    RegisterPropertyHelper(@TCnWizOptionsLangPath_R, nil, 'LangPath');
    RegisterPropertyHelper(@TCnWizOptionsIconPath_R, nil, 'IconPath');
    RegisterPropertyHelper(@TCnWizOptionsDataPath_R, nil, 'DataPath');
    RegisterPropertyHelper(@TCnWizOptionsTemplatePath_R, nil, 'TemplatePath');
    RegisterPropertyHelper(@TCnWizOptionsUserPath_R, nil, 'UserPath');
    RegisterPropertyHelper(@TCnWizOptionsHelpPath_R, nil, 'HelpPath');
    RegisterPropertyHelper(@TCnWizOptionsRegBase_R, nil, 'RegBase');
    RegisterPropertyHelper(@TCnWizOptionsRegPath_R, nil, 'RegPath');
    RegisterPropertyHelper(@TCnWizOptionsPropEditorRegPath_R, nil, 'PropEditorRegPath');
    RegisterPropertyHelper(@TCnWizOptionsCompEditorRegPath_R, nil, 'CompEditorRegPath');
    RegisterPropertyHelper(@TCnWizOptionsIdeEhnRegPath_R, nil, 'IdeEhnRegPath');
    RegisterPropertyHelper(@TCnWizOptionsCompilerName_R, nil, 'CompilerName');
    RegisterPropertyHelper(@TCnWizOptionsCompilerID_R, nil, 'CompilerID');
    RegisterPropertyHelper(@TCnWizOptionsCompilerRegPath_R, nil, 'CompilerRegPath');
    RegisterPropertyHelper(@TCnWizOptionsDelphiExt_R, @TCnWizOptionsDelphiExt_W, 'DelphiExt');
    RegisterPropertyHelper(@TCnWizOptionsCExt_R, @TCnWizOptionsCExt_W, 'CExt');
    RegisterPropertyHelper(@TCnWizOptionsShowHint_R, @TCnWizOptionsShowHint_W, 'ShowHint');
    RegisterPropertyHelper(@TCnWizOptionsShowWizComment_R, @TCnWizOptionsShowWizComment_W, 'ShowWizComment');
    RegisterPropertyHelper(@TCnWizOptionsShowTipOfDay_R, @TCnWizOptionsShowTipOfDay_W, 'ShowTipOfDay');
    RegisterPropertyHelper(@TCnWizOptionsBuildDate_R, nil, 'BuildDate');
    RegisterPropertyHelper(@TCnWizOptionsUpgradeURL_R, nil, 'UpgradeURL');
    RegisterPropertyHelper(@TCnWizOptionsNightlyBuildURL_R, nil, 'NightlyBuildURL');
    RegisterPropertyHelper(@TCnWizOptionsUpgradeStyle_R, @TCnWizOptionsUpgradeStyle_W, 'UpgradeStyle');
    RegisterPropertyHelper(@TCnWizOptionsUpgradeContent_R, @TCnWizOptionsUpgradeContent_W, 'UpgradeContent');
    RegisterPropertyHelper(@TCnWizOptionsUpgradeReleaseOnly_R, @TCnWizOptionsUpgradeReleaseOnly_W, 'UpgradeReleaseOnly');
    RegisterPropertyHelper(@TCnWizOptionsUpgradeLastDate_R, @TCnWizOptionsUpgradeLastDate_W, 'UpgradeLastDate');
    RegisterPropertyHelper(@TCnWizOptionsUpgradeCheckDate_R, @TCnWizOptionsUpgradeCheckDate_W, 'UpgradeCheckDate');
    RegisterPropertyHelper(@TCnWizOptionsUseToolsMenu_R, @TCnWizOptionsUseToolsMenu_W, 'UseToolsMenu');
  end;
end;

procedure RIRegister_CnWizOptions(CL: TPSRuntimeClassImporter);
begin
  RIRegister_TCnWizOptions(CL);
end;

{ TPSImport_CnWizOptions }

procedure TPSImport_CnWizOptions.CompileImport1(CompExec: TPSScript);
begin
  SIRegister_CnWizOptions(CompExec.Comp);
end;

procedure TPSImport_CnWizOptions.ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter);
begin
  RIRegister_CnWizOptions(ri);
  RIRegister_CnWizOptions_Routines(CompExec.Exec); // comment it if no routines
end;

end.

