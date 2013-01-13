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

unit CnWizIni;
{* |<PRE>
================================================================================
* ������ƣ�CnPack IDE ר�Ұ�
* ��Ԫ���ƣ�Ansi ��ʽ����� IniFile �滻��Ԫ
* ��Ԫ���ߣ���Х liuxiao@cnpack.org
* ��    ע��
* ����ƽ̨��PWinXP SP3 + Delphi 2009
* ���ݲ��ԣ�PWin9X/2000/XP + Delphi 5/6/7 + C++Builder 5/6
* �� �� �����õ�Ԫ�е��ַ��������ϱ��ػ�����ʽ
* ��Ԫ��ʶ��$Id: CnWizIni.pas 763 2011-02-07 14:18:23Z liuxiao@cnpack.org $
* �޸ļ�¼��2008.08.06 V1.0
*               ������Ԫ
================================================================================
|</PRE>}

interface

{$I CnWizards.inc}

{$IFDEF DELPHI2009_UP}

uses
  Windows, SysUtils, Classes, RTLConsts, CnCommon, IniFiles;

type
  TCnAnsiMemIniFile = class(TMemIniFile)
  public
    procedure UpdateFile; override;
  end;

  TCnAnsiIniFile = class(TCnAnsiMemIniFile)
  public
    destructor Destroy; override;
  end;

  TMemIniFile = TCnAnsiMemIniFile;

  TIniFile = TCnAnsiIniFile;
  
{$ENDIF}

implementation

{$IFDEF DELPHI2009_UP}
  
{ TCnAnsiMemIniFile }

procedure TCnAnsiMemIniFile.UpdateFile;
var
  List: TStringList;
  Text: AnsiString;
  Stream: TFileStream;
begin
  List := TStringList.Create;
  try
    GetStrings(List);
    Text := AnsiString(List.Text);
  finally
    List.Free;
  end;

  Stream := TFileStream.Create(FileName, fmCreate);
  try
    Stream.WriteBuffer(PAnsiChar(Text)^, Length(Text));
  finally
    Stream.Free;
  end;
end;

{ TCnAnsiIniFile }

destructor TCnAnsiIniFile.Destroy;
begin
  UpdateFile;
  inherited;
end;

{$ENDIF}
end.
