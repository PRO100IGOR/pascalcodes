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

unit CnWizHelp;
{* |<PRE>
================================================================================
* ������ƣ�CnPack IDE ר�Ұ�
* ��Ԫ���ƣ���ʾ�����������̿ⵥԪ
* ��Ԫ���ߣ�CnPack ������
* ��    ע��
* ����ƽ̨��PWinXP SP3 + Delphi 5.01
* ���ݲ��ԣ�
* �� �� �����õ�Ԫ�е��ַ��������ϱ��ػ�����ʽ
* ��Ԫ��ʶ��$Id: CnWizHelp.pas 434 2010-02-10 09:23:00Z zhoujingyu $
* �޸ļ�¼��2010.02.21 V1.0
*               ������Ԫ
================================================================================
|</PRE>}

interface

{$I CnWizards.inc}

uses
  Windows, Messages, SysUtils, IniFiles, ShellAPI, CnLangMgr, CnWideStrings;

const
  csSection = 'CnWizards';

function GetFileFromLang(const FileName: string): string;

function ShowHelp(const Topic: string; const Section: string = csSection): Boolean;

implementation

const
  csCnWizOnlineHelpUrl = 'http://help.cnpack.org/cnwizards/';
  csLangPath = 'Lang\';
  csHelpPath = 'Help\';
  csWizHelpIniFile = 'Help.ini';

// ��ǰִ��ģ�����ڵ�·��
function ModulePath: string;
var
  ModName: array[0..MAX_PATH] of Char;
begin
  SetString(Result, ModName, GetModuleFileName(HInstance, ModName, SizeOf(ModName)));
  Result := ExtractFilePath(Result);
end;

// ��������ȡ�ļ���
function GetFileFromLang(const FileName: string): string;
begin
  if (CnLanguageManager.LanguageStorage <> nil) and
    (CnLanguageManager.LanguageStorage.CurrentLanguage <> nil) then
  begin
    Result := IncludeTrailingBackslash(ModulePath + csLangPath +
      CnLanguageManager.LanguageStorage.CurrentLanguage.LanguageDirName)
      + FileName;
  end
  else
  begin
    // �����Գ�ʼ��ʧ�ܣ��򷵻�Ӣ�ĵ����ݣ���ΪĬ�ϵĽ�����Ӣ�ĵ�
    Result := ModulePath + csLangPath + '1033\' + FileName;
  end;
end;

// ȡ������������
function GetTopicHelpUrl(const Topic: string; const Section: string): string;
var
  FileName: string;
begin
  Result := '';
  FileName := GetFileFromLang(csWizHelpIniFile);

  if not FileExists(FileName) then
    Exit;
  with TCnWideMemIniFile.Create(FileName) do
  try
    Result := ReadString(Section, Topic, '');
  finally
    Free;
  end;
end;

// ȡ���������Ƿ����
function TopicHelpFileExists(Url: string): Boolean;
var
  i: Integer;
begin
  i := AnsiPos('::/', Url);
  if i > 0 then
  begin
    Delete(Url, i, MaxInt);
    Result := FileExists(ModulePath + csHelpPath + Url);
  end
  else
    Result := True;  
end;  

// ��ʾָ������İ�������
function ShowHelp(const Topic: string; const Section: string): Boolean;
var
  Url: string;
  si: TStartupInfo;
  pi: TProcessInformation;
begin
  Result := False;
  Url := GetTopicHelpUrl(Topic, Section);
  if Url <> '' then
  begin
    if TopicHelpFileExists(Url) then
    begin
      Url := 'mk:@MSITStore:' + ModulePath + csHelpPath + Url;
      ZeroMemory(@si, SizeOf(si));
      si.cb := SizeOf(si);
      ZeroMemory(@pi, SizeOf(pi));
      CreateProcess(nil, PChar('hh ' + Url),
        nil, nil, False, 0, nil, nil, si, pi);
      if pi.hProcess <> 0 then CloseHandle(pi.hProcess);
      if pi.hThread <> 0 then CloseHandle(pi.hThread);
    end
    else
      ShellExecute(0, nil, PChar(csCnWizOnlineHelpUrl + Url), nil, nil, SW_SHOWNORMAL);
    Result := True;
  end;
end;

end.
