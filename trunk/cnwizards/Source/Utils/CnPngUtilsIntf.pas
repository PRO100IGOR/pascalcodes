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

unit CnPngUtilsIntf;
{* |<PRE>
================================================================================
* ������ƣ�CnWizards ��������
* ��Ԫ���ƣ�Png ��ʽ֧�ֵ�Ԫ
* ��Ԫ���ߣ��ܾ��� zjy@cnpack.org
* ��    ע������ pngimage �Ѿ��� Embarcadero �չ����µ����Э���ƺ������������Ŀ
*           ��Դ��Ϊ�˱����Ȩ���⣬�˴��� D2010 ��ʹ�ùٷ��� pngimage ����һ��
*           DLL �����Ͱ汾�� IDE ������ʹ�á�
* ����ƽ̨��Win7 + Delphi 2010
* ���ݲ��ԣ�
* �� �� �����õ�Ԫ�ʹ����е��ַ����Ѿ����ػ�����ʽ
* ��Ԫ��ʶ��$Id: $
* �޸ļ�¼��
*           2011.07.05 V1.0
*               ������Ԫ
================================================================================
|</PRE>}

{$I CnWizards.inc}

interface

function CnPngLibLoaded: LongBool;
function CnConvertPngToBmp(PngFile, BmpFile: string): LongBool; stdcall;
function CnConvertBmpToPng(BmpFile, PngFile: string): LongBool; stdcall;

implementation

uses
  Windows, SysUtils;

type
  TCnConvertPngToBmpProc = function (PngFile, BmpFile: PAnsiChar): LongBool; stdcall;
  TCnConvertBmpToPngProc = function (BmpFile, PngFile: PAnsiChar): LongBool; stdcall;

var
  _hMod: HMODULE;
  _CnConvertPngToBmpProc: TCnConvertPngToBmpProc = nil;
  _CnConvertBmpToPngProc: TCnConvertBmpToPngProc = nil;

function ModulePath: string;
var
  ModName: array[0..MAX_PATH] of Char;
begin
  SetString(Result, ModName, GetModuleFileName(HInstance, ModName, SizeOf(ModName)));
  Result := ExtractFilePath(Result);
end;

procedure LoadCnPngLib;
var
  DllName: string;
begin
  DllName := ModulePath + 'CnPngLib.dll';
  _hMod := LoadLibrary(PChar(DllName));
  if _hMod <> 0 then
  begin
    _CnConvertPngToBmpProc := TCnConvertPngToBmpProc(GetProcAddress(_hMod, 'CnConvertPngToBmp'));
    _CnConvertBmpToPngProc := TCnConvertBmpToPngProc(GetProcAddress(_hMod, 'CnConvertBmpToPng'));
  end;
end;

procedure FreeCnPngLib;
begin
  if _hMod <> 0 then
  begin
    FreeLibrary(_hMod);
    _CnConvertPngToBmpProc := nil;
    _CnConvertBmpToPngProc := nil;
    _hMod := 0;
  end;
end;

function CnPngLibLoaded: LongBool;
begin
  Result := Assigned(_CnConvertPngToBmpProc) and Assigned(_CnConvertBmpToPngProc);
end;

function CnConvertPngToBmp(PngFile, BmpFile: string): LongBool; stdcall;
var
  P, B: AnsiString;
begin
  P := AnsiString(PngFile);
  B := AnsiString(BmpFile);
  if Assigned(_CnConvertPngToBmpProc) then
    Result := _CnConvertPngToBmpProc(PAnsiChar(P), PAnsiChar(B))
  else
    Result := False;
end;

function CnConvertBmpToPng(BmpFile, PngFile: string): LongBool; stdcall;
var
  P, B: AnsiString;
begin
  P := AnsiString(PngFile);
  B := AnsiString(BmpFile);
  if Assigned(_CnConvertBmpToPngProc) then
    Result := _CnConvertBmpToPngProc(PAnsiChar(B), PAnsiChar(P))
  else
    Result := False;
end;

initialization
  LoadCnPngLib;

finalization
  FreeCnPngLib;

end.
