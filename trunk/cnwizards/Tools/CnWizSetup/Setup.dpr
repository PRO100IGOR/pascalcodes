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

program Setup;
{* |<PRE>
================================================================================
* ������ƣ�CnWizards IDE ר�ҹ��߰�
* ��Ԫ���ƣ��򵥵İ�װ����
* ��Ԫ���ߣ��ܾ��� (zjy@cnpack.org)
* ��    ע��������������ʱ�Զ��жϰ�װ״̬������װ/����װר��
*           ������ Setup [/i|/u] [/n] [/?|/h]
*           �� /i ��������ʱ��װר��
*           �� /u ��������ʱ����װר��
*           �� /n ��������ʱ����ʾ�Ի��򣨿���ǰ�����ϣ�
*           �� /? ��ʾ֧�ֵĲ����б�
* ����ƽ̨��PWin2000Pro + Delphi 5.01
* ���ݲ��ԣ�PWin9X/2000/XP + Delphi 5/6
* �� �� �����õ�Ԫ�е��ַ����ɴ���Ϊ���ϱ��ػ�����ʽ
* ��Ԫ��ʶ��$Id: Setup.dpr,v 1.19 2009/04/18 13:42:17 zjy Exp $
* �޸ļ�¼��2002.10.01 V1.1
*               ��������֧��
*           2002.09.28 V1.0
*               ������Ԫ��ʵ�ֹ���
================================================================================
|</PRE>}

{$I CnPack.inc}

uses
  Windows,
  SysUtils,
  Registry,
  CnCommon,
  CnLangTranslator,
  CnLangStorage,
  CnHashLangStorage,
  CnLangMgr,
  CnWizCompilerConst,
  CnWizLangID;

{$R *.RES}
{$R SetupRes.RES}

{$IFDEF COMPILER7_UP}
{$R WindowsXP.res}
{$ENDIF}

type
  TCompilerName = (cvD5, cvD6, cvD7, cvD8, cbD9, cbD10, cbD2007, cbD2009,
    cbD2010, cbD2011, cbD2012, cvCB5, cvCB6);

const
  csCompilerNames: array[TCompilerName] of string = (
    'Delphi 5',
    'Delphi 6',
    'Delphi 7',
    'Delphi 8',
    'BDS 2005',
    'BDS 2006',
    'RAD Studio 2007',
    'RAD Studio 2009',
    'RAD Studio 2010',
    'RAD Studio XE',
    'RAD Studio XE 2',
    'C++Builder 5',
    'C++Builder 6');

  csRegPaths: array[TCompilerName] of string = (
    '\Software\Borland\Delphi\5.0',
    '\Software\Borland\Delphi\6.0',
    '\Software\Borland\Delphi\7.0',
    '\Software\Borland\BDS\2.0',
    '\Software\Borland\BDS\3.0',
    '\Software\Borland\BDS\4.0',
    '\Software\Borland\BDS\5.0',
    '\Software\CodeGear\BDS\6.0',
    '\Software\CodeGear\BDS\7.0',
    '\Software\Embarcadero\BDS\8.0',
    '\Software\Embarcadero\BDS\9.0',
    '\Software\Borland\C++Builder\5.0',
    '\Software\Borland\C++Builder\6.0');

  csDllNames: array[TCompilerName] of string = (
    'CnWizards_D5.DLL',
    'CnWizards_D6.DLL',
    'CnWizards_D7.DLL',
    'CnWizards_D8.DLL',
    'CnWizards_D9.DLL',
    'CnWizards_D10.DLL',
    'CnWizards_D11.DLL',
    'CnWizards_D12.DLL',
    'CnWizards_D14.DLL',
    'CnWizards_D15.DLL',
    'CnWizards_D16.DLL',
    'CnWizards_CB5.DLL',
    'CnWizards_CB6.DLL');

  csLangDir = 'Lang\';
  csExperts = '\Experts';
  csLangFile = 'Setup.txt';

var
  csHintStr: string = 'Hint';
  csInstallSucc: string = 'CnPack IDE Wizards have been Installed in:' + #13#10 + '';
  csInstallSuccEnd: string = 'Run Setup again to Uninstall.';
  csUnInstallSucc: string = 'CnPack IDE Wizards have been Uninstalled From:' + #13#10 + '';
  csUnInstallSuccEnd: string = 'Run Setup again to Install.';
  csInstallFail: string = 'Can''t Find Delphi or C++Builder to Install CnPack IDE Wizards.';
  csUnInstallFail: string = 'CnPack IDE Wizards have already Disabled.';

  csSetupCmdHelp: string =
    'This Tool Supports Command Line Mode without Showing the Main Form.' + #13#10#13#10 +
    'Command Line Switch Help:' + #13#10#13#10 +
    '         -i or /i or -install or /install Install to IDE' + #13#10 +
    '         -u or /u or -uninstall or /uninstall UnInstall from IDE' + #13#10 +
    '         -n or /n or -NoMsg or /NoMsg Do NOT Show the Success Message after Setup run.' + #13#10 +
    '         -? or /? or -h or /h Show the Command Line Help.';

//==============================================================================
// ע������
//==============================================================================

// ���ע�����Ƿ����
function RegKeyExists(const RegPath: string): Boolean;
var
  Reg: TRegistry;
begin
  try
    Reg := TRegistry.Create;
    try
      Result := Reg.KeyExists(RegPath);
    finally
      Reg.Free;
    end;
  except
    Result := False;
  end;
end;

// ���ע����ֵ�Ƿ����
function RegValueExists(const RegPath, RegValue: string): Boolean;
var
  Reg: TRegistry;
begin
  try
    Reg := TRegistry.Create;
    try
      Result := Reg.OpenKey(RegPath, False) and Reg.ValueExists(RegValue);
    finally
      Reg.Free;
    end;
  except
    Result := False;
  end;
end;

// ɾ��ע����ֵ
function RegDeleteValue(const RegPath, RegValue: string): Boolean;
var
  Reg: TRegistry;
begin
  try
    Reg := TRegistry.Create;
    try
      Result := Reg.OpenKey(RegPath, False);
      if Result then
        Reg.DeleteValue(RegValue);
    finally
      Reg.Free;
    end;
  except
    Result := False;
  end;
end;

// дע����ַ���
function RegWriteStr(const RegPath, RegValue, Str: string): Boolean;
var
  Reg: TRegistry;
begin
  try
    Reg := TRegistry.Create;
    try
      Result := Reg.OpenKey(RegPath, True);
      if Result then Reg.WriteString(RegValue, Str);
    finally
      Reg.Free;
    end;
  except
    Result := False;
  end;
end;

//==============================================================================
// ר�Ҵ���
//==============================================================================

var
  ParamInstall: Boolean;
  ParamUnInstall: Boolean;
  ParamNoMsg: Boolean;
  ParamCmdHelp :Boolean;

// ȡר��DLL�ļ���
function GetDllName(Compiler: TCompilerName): string;
begin
  Result := ExtractFilePath(ParamStr(0)) + csDllNames[Compiler];
end;

// ȡר����
function GetDllValue(Compiler: TCompilerName): string;
begin
  Result := ChangeFileExt(csDllNames[Compiler], '');
end;

// �ж�ר��DLL�Ƿ����
function WizardExists(Compiler: TCompilerName): Boolean;
begin
  Result := FileExists(GetDllName(Compiler));
end;

// �ж��Ƿ�װ
function IsInstalled: Boolean;
var
  Compiler: TCompilerName;
begin
  Result := True;
  for Compiler := Low(Compiler) to High(Compiler) do
    if WizardExists(Compiler) and RegKeyExists(csRegPaths[Compiler]) and
      not RegValueExists(csRegPaths[Compiler] + csExperts, GetDllValue(Compiler)) then
    begin
      Result := False;
      Exit;
    end;
end;

// ��װר��
procedure InstallWizards;
var
  S: string;
  Compiler: TCompilerName;
  Key: HKEY;
begin
  S := csInstallSucc;
  for Compiler := Low(Compiler) to High(Compiler) do
  begin
    if Compiler = cvD8 then // ����װ D8 ��
      Continue;

    if WizardExists(Compiler) and RegKeyExists(csRegPaths[Compiler]) then
    begin
      if not RegKeyExists(csRegPaths[Compiler] + csExperts) then
      begin
        RegCreateKey(HKEY_CURRENT_USER, PChar(csRegPaths[Compiler] + csExperts), Key);
        RegCloseKey(Key);
      end;

      if RegWriteStr(csRegPaths[Compiler] + csExperts, GetDllValue(Compiler),
        GetDllName(Compiler)) then
        S := S + #13#10 + ' - ' + csCompilerNames[Compiler];
    end;
  end;

  if not ParamNoMsg then
  begin
    if S <> csInstallSucc then
    begin
      if not ParamInstall then
        S := S + #13#10#13#10 + csInstallSuccEnd;
    end
    else
      S := csInstallFail;
    MessageBox(0, PChar(S), PChar(csHintStr), MB_OK + MB_ICONINFORMATION);
  end;
end;

// ����װר��
procedure UnInstallWizards;
var
  s: string;
  Compiler: TCompilerName;
begin
  s := csUnInstallSucc;
  for Compiler := Low(Compiler) to High(Compiler) do
    if RegValueExists(csRegPaths[Compiler] + csExperts, GetDllValue(Compiler)) and
      RegDeleteValue(csRegPaths[Compiler] + csExperts, GetDllValue(Compiler)) then
      s := s + #13#10 + ' - ' + csCompilerNames[Compiler];

  if not ParamNoMsg then
  begin
    if s <> csUnInstallSucc then
    begin
      if not ParamUnInstall then
        s := s + #13#10#13#10 + csUnInstallSuccEnd;
    end
    else
      s := csUnInstallFail;
    MessageBox(0, PChar(s), PChar(csHintStr), MB_OK + MB_ICONINFORMATION);
  end;
end;

// �����ַ���
procedure TranslateStrings;
begin
  TranslateStr(csHintStr, 'csHintStr');
  TranslateStr(csInstallSucc, 'csInstallSucc');
  TranslateStr(csInstallSuccEnd, 'csInstallSuccEnd');
  TranslateStr(csUnInstallSucc, 'csUnInstallSucc');
  TranslateStr(csUnInstallSuccEnd, 'csUnInstallSuccEnd');
  TranslateStr(csInstallFail, 'csInstallFail');
  TranslateStr(csUnInstallFail, 'csUnInstallFail');
  TranslateStr(csSetupCmdHelp, 'csSetupCmdHelp');
end;

// ��ʼ������
procedure InitLanguageManager;
var
  LangID: DWORD;
  I: Integer;
begin
  CreateLanguageManager;
  with CnLanguageManager do
  begin
    LanguageStorage := TCnHashLangFileStorage.Create(CnLanguageManager);
    with TCnHashLangFileStorage(LanguageStorage) do
    begin
      StorageMode := smByDirectory;
      FileName := csLangFile;
      LanguagePath := ExtractFilePath(ParamStr(0)) + csLangDir;
    end;
  end;

  LangID := GetWizardsLanguageID;
  
  for I := 0 to CnLanguageManager.LanguageStorage.LanguageCount - 1 do
  begin
    if CnLanguageManager.LanguageStorage.Languages[I].LanguageID = LangID then
    begin
      CnLanguageManager.CurrentLanguageIndex := I;
      TranslateStrings;
      Break;
    end;
  end;
end;

begin
  InitLanguageManager;

  ParamInstall := FindCmdLineSwitch('Install', ['-', '/'], True) or
    FindCmdLineSwitch('i', ['-', '/'], True);
  ParamUnInstall := FindCmdLineSwitch('Uninstall', ['-', '/'], True) or
    FindCmdLineSwitch('u', ['-', '/'], True);
  ParamNoMsg := FindCmdLineSwitch('NoMsg', ['-', '/'], True) or
    FindCmdLineSwitch('n', ['-', '/'], True);
  ParamCmdHelp :=  FindCmdLineSwitch('?', ['-', '/'], True)
    or FindCmdLineSwitch('h', ['-', '/'], True)
    or FindCmdLineSwitch('help', ['-', '/'], True) ;

  if ParamCmdHelp then
    InfoDlg(csSetupCmdHelp)
  else if IsInstalled and not ParamInstall or ParamUnInstall then
    UnInstallWizards
  else
    InstallWizards;
end.
