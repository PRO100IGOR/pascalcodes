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

program CnIdeBRTool;
{* |<PRE>
================================================================================
* ������ƣ�CnPack IDE ר�Ҹ�������/�ָ�����
* ��Ԫ���ƣ�CnWizards ��������/�ָ����߹����ļ�
* ��Ԫ���ߣ�ccRun(����)
* ��    ע��CnWizards ר�Ҹ�������/�ָ����߹����ļ�
* ����ƽ̨��PWinXP + Delphi 5.01
* ���ݲ��ԣ�PWin9X/2000/XP + Delphi 5/6/7 + C++Builder 5/6
* �� �� �����õ�Ԫ�е��ַ��������ϱ��ػ�����ʽ
* ��Ԫ��ʶ��$Id: CnIdeBRTool.dpr,v 1.6 2009/01/02 08:36:30 liuxiao Exp $
* �޸ļ�¼��2006.08.23 V1.0
*               Passion ��ֲ�˵�Ԫ
================================================================================
|</PRE>}

uses
  Forms,
  CnBHMain in 'CnBHMain.pas' {CnIdeBRMainForm},
  CnAppBuilderInfo in 'CnAppBuilderInfo.pas',
  CnCompressor in 'CnCompressor.pas',
  CnBHConst in 'CnBHConst.pas',
  CleanClass in 'CleanClass.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TCnIdeBRMainForm, CnIdeBRMainForm);
  Application.Run;
end.
