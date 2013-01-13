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

unit CnWizHelperIntf;

interface
{ |<PRE>
================================================================================
* ������ƣ�CnPack IDE ר�Ұ�
* ��Ԫ���ƣ�CnWizHelper.dll �Ľӿ�
* ��Ԫ���ߣ��ܾ��� (zjy@cnpack.org)
* ��    ע��
* ����ƽ̨��PWin2000Pro + Delphi 5.01
* ���ݲ��ԣ�PWin2000/XP + Delphi 5/6/7 + C++Builder 5/6
* �� �� �����õ�Ԫ�е��ַ��������ϱ��ػ�����ʽ
* ��Ԫ��ʶ��$Id: CnWizInetUtils.pas 418 2010-02-08 04:53:54Z zhoujingyu $
* �޸ļ�¼��2010.05.1 V1.0 by zjy
*               ������Ԫ
================================================================================
|</PRE>}

uses
  Windows, SysUtils;

const
  SCnWizHelperDllName = 'CnWizHelper.Dll';

function CnWizHelperLoaded: Boolean;

//------------------------------------------------------------------------------
// ZIP ����
//------------------------------------------------------------------------------

function CnWizHelperZipValid: Boolean;

procedure CnWiz_StartZip(const SaveFileName: PAnsiChar; const Password: PAnsiChar;
  RemovePath: Boolean); stdcall;
{* ��ʼһ�� Zip�������ڲ�����ָ���ļ����������}

procedure CnWiz_ZipAddFile(FileName: PAnsiChar); stdcall;
{* ����ļ��� Zip}

function CnWiz_ZipSaveAndClose: Boolean; stdcall;
{* ѹ������ Zip �ļ����ͷ��ڲ�����}

//------------------------------------------------------------------------------
// InetUtils ����
//------------------------------------------------------------------------------

function CnWizHelperInetValid: Boolean;

function CnWiz_Inet_GetFile(AURL, FileName: PAnsiChar): Boolean; stdcall;

implementation

{$IFDEF DEBUG}
uses
  CnDebug;
{$ENDIF}

type
  TProcCnWiz_StartZip = procedure (const SaveFileName: PAnsiChar; const Password: PAnsiChar;
    RemovePath: Boolean); stdcall;
  {* ��ʼһ�� Zip�������ڲ�����ָ���ļ����������}

  TProcCnWiz_ZipAddFile = procedure (FileName: PAnsiChar); stdcall;
  {* ����ļ��� Zip}

  TFuncCnWiz_ZipSaveAndClose = function : Boolean; stdcall;
  {* ѹ������ Zip �ļ����ͷ��ڲ�����}

  TFuncCnWiz_Inet_GetFile = function (AURL, FileName: PAnsiChar): Boolean; stdcall;

var
  hHelperDll: HMODULE;

  fnCnWiz_StartZip: TProcCnWiz_StartZip;
  fnCnWiz_ZipAddFile: TProcCnWiz_ZipAddFile;
  fnCnWiz_ZipSaveAndClose: TFuncCnWiz_ZipSaveAndClose;
  fnCnWiz_Inet_GetFile: TFuncCnWiz_Inet_GetFile;

procedure LoadWizHelperDll;
var
  ModuleName: array[0..MAX_Path - 1] of Char;
begin
  GetModuleFileName(hInstance, ModuleName, MAX_PATH);
  hHelperDll := LoadLibrary(PChar(ExtractFilePath(ModuleName) + SCnWizHelperDllName));
  
  if hHelperDll <> 0 then
  begin
    fnCnWiz_StartZip := TProcCnWiz_StartZip(GetProcAddress(hHelperDll, 'CnWiz_StartZip'));
    fnCnWiz_ZipAddFile := TProcCnWiz_ZipAddFile(GetProcAddress(hHelperDll, 'CnWiz_ZipAddFile'));
    fnCnWiz_ZipSaveAndClose := TFuncCnWiz_ZipSaveAndClose(GetProcAddress(hHelperDll, 'CnWiz_ZipSaveAndClose'));
    fnCnWiz_Inet_GetFile := TFuncCnWiz_Inet_GetFile(GetProcAddress(hHelperDll, 'CnWiz_Inet_GetFile'));
  end
  else
  begin
  {$IFDEF DEBUG}
    CnDebugger.LogMsg('Load CnWizHelper.dll failed.');
  {$ENDIF}
  end;

{$IFDEF DEBUG}
  CnDebugger.LogBoolean(CnWizHelperZipValid, 'CnWizHelperZipValid');
  CnDebugger.LogBoolean(CnWizHelperInetValid, 'CnWizHelperInetValid');
{$ENDIF}
end;

procedure FreeWizHelperDll;
begin
  if hHelperDll <> 0 then
  begin
    FreeLibrary(hHelperDll);
    hHelperDll := 0;
  end;
end;  

function CnWizHelperLoaded: Boolean;
begin
  Result := hHelperDll <> 0;
end;  

//------------------------------------------------------------------------------
// ZIP ����
//------------------------------------------------------------------------------

function CnWizHelperZipValid: Boolean;
begin
  Result := CnWizHelperLoaded and Assigned(fnCnWiz_StartZip) and
    Assigned(fnCnWiz_ZipAddFile) and Assigned(fnCnWiz_ZipSaveAndClose);
end;  

procedure CnWiz_StartZip(const SaveFileName: PAnsiChar; const Password: PAnsiChar;
  RemovePath: Boolean); stdcall;
begin
  if CnWizHelperZipValid then
    fnCnWiz_StartZip(SaveFileName, Password, RemovePath);
end;  

procedure CnWiz_ZipAddFile(FileName: PAnsiChar); stdcall;
begin
  if CnWizHelperZipValid then
    fnCnWiz_ZipAddFile(FileName);
end;

function CnWiz_ZipSaveAndClose: Boolean; stdcall;
begin
  if CnWizHelperZipValid then
    Result := fnCnWiz_ZipSaveAndClose
  else
    Result := False;
end;

//------------------------------------------------------------------------------
// InetUtils ����
//------------------------------------------------------------------------------

function CnWizHelperInetValid: Boolean;
begin
  Result := CnWizHelperLoaded and Assigned(fnCnWiz_Inet_GetFile);
end;

function CnWiz_Inet_GetFile(AURL, FileName: PAnsiChar): Boolean; stdcall;
begin
  if CnWizHelperInetValid then
    Result := fnCnWiz_Inet_GetFile(AURL, FileName)
  else
    Result := False;
end;  

initialization
  LoadWizHelperDll;

finalization
  FreeWizHelperDll;

end.
