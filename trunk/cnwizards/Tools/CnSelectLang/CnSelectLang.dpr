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

program CnSelectLang;

uses
  SysUtils,
  Forms,
  CnSelLang in 'CnSelLang.pas' {CnSelLangFrm},
  CnWizLangID in '..\..\Source\MultiLang\CnWizLangID.pas';

{$R *.RES}

var
  Param : Boolean;
begin
  Param := FindCmdLineSwitch('?', ['-', '/'], True) or
    FindCmdLineSwitch('help', ['-', '/'], True) or
    FindCmdLineSwitch('h', ['-', '/'], True) or
    FindCmdLineSwitch('l', ['-', '/'], True);
  Application.Initialize;
    Application.ShowMainForm := not Param;
  Application.CreateForm(TCnSelLangFrm, CnSelLangFrm);
  Application.Run;
end.
