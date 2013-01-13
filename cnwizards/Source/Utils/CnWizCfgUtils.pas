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

unit CnWizCfgUtils;
{* |<PRE>
================================================================================
* ������ƣ�CnPack IDE ר�Ұ�
* ��Ԫ���ƣ����ù�����Ԫ
* ��Ԫ���ߣ�CnPack������
* ��    ע���õ�Ԫ������ȡ CnWizards ��������ã�
            ���ļ����貢�Ҳ��ܼ���ר�Ұ��Ĺ����ļ��У�ֻ����������ʹ�á�
* ����ƽ̨��PWinXP + Delphi 7.1
* ���ݲ��ԣ�
* �� �� �����õ�Ԫ�е��ַ��������ϱ��ػ�����ʽ
* ��Ԫ��ʶ��$Id: CnWizLangID.pas 138 2009-07-14 03:23:28Z zhoujingyu $
* �޸ļ�¼��2009.09.09 V1.0
*               ZhouJingYu: ������Ԫ
================================================================================
|</PRE>}

interface

{$I CnWizards.inc}

uses
  SysUtils, Classes, Windows, Registry, CnCommon, CnConsts;

function GetCWUseCustomUserDir: Boolean;
function GetCWUserPath: string;
{* ��ע����ж�ȡ��ǰ CnWizards �û�����·�� }

implementation

const
  SCnWizUserPath = 'User';
  SCnOptionSection = 'Option';
  csWizardRegPath = 'CnWizards';
  csUseCustomUserDir = 'UseCustomUserDir';
  csCustomUserDir = 'CustomUserDir';

function GetCWUseCustomUserDir: Boolean;
begin
  with TRegistryIniFile.Create(MakePath(MakePath(SCnPackRegPath) + csWizardRegPath)) do
  try
    Result := ReadBool(SCnOptionSection, csUseCustomUserDir, CheckWinVista);
  finally
    Free;
  end;
end;

// ��ע����ж�ȡ��ǰ CnWizards �û�����·��
function GetCWUserPath: string;
begin
  Result := MakePath(ModulePath + SCnWizUserPath);

  with TRegistryIniFile.Create(MakePath(MakePath(SCnPackRegPath) + csWizardRegPath)) do
  try
    if ReadBool(SCnOptionSection, csUseCustomUserDir, CheckWinVista) then
      Result := MakePath(ReadString(SCnOptionSection, csCustomUserDir, Result));
  finally
    Free;
  end;
end;

end.
