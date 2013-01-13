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

unit CnWizLangID;
{* |<PRE>
================================================================================
* ������ƣ�CnPack IDE ר�Ұ�
* ��Ԫ���ƣ����� ID ������Ԫ
* ��Ԫ���ߣ�CnPack������
* ��    ע���õ�Ԫ������ȡ CnWizards �ĵ�ǰ���� ID��
            ���ļ����貢�Ҳ��ܼ���ר�Ұ��Ĺ����ļ��У�ֻ����������ʹ�á�
* ����ƽ̨��PWin2000Pro + Delphi 5.01
* ���ݲ��ԣ�PWin9X/2000/XP + Delphi 5/6/7 + C++Builder 5/6
* �� �� �����õ�Ԫ�е��ַ��������ϱ��ػ�����ʽ
* ��Ԫ��ʶ��$Id: CnWizLangID.pas 763 2011-02-07 14:18:23Z liuxiao@cnpack.org $
* �޸ļ�¼��2005.01.14 V1.0
*               LiuXiao: ������Ԫ
================================================================================
|</PRE>}

interface

{$I CnWizards.inc}

uses
  SysUtils, Classes, Windows, Registry, CnCommon, CnConsts;

function GetWizardsLanguageID: DWORD;
{* ��ע����ж�ȡ��ǰ CnWizards ������ ID }

procedure SetWizardsLanguageID(LangID: DWORD);
{* ����ע����еĵ�ǰ CnWizards ������ ID }

implementation

const
  csWizardRegPath = 'CnWizards';
  csOptionSection = 'Option';
  csLangID = 'CurrentLangID';

// ��ע����ж�ȡ��ǰ CnWizards ������ ID
function GetWizardsLanguageID: DWORD;
begin
  with TRegistryIniFile.Create(MakePath(MakePath(SCnPackRegPath) + csWizardRegPath)) do
  begin
    Result := ReadInteger(csOptionSection, csLangID, GetSystemDefaultLCID);
    Free;
  end;
end;

// ����ע����еĵ�ǰ CnWizards ������ ID
procedure SetWizardsLanguageID(LangID: DWORD);
begin
  with TRegistryIniFile.Create(MakePath(MakePath(SCnPackRegPath) + csWizardRegPath)) do
  begin
    WriteInteger(csOptionSection, csLangID, LangID);
    Free;
  end;
end; 

end.
