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

program CnDfm6To5;

{$I CnPack.inc}

{$IFNDEF DELPHI5}
  'Error: This program can only be compiled in Delphi 5.0!'
{$ENDIF}

uses
  Forms,
  CnDTMainFrm in 'CnDTMainFrm.pas' {CnDTMainForm},
  CnWizDfm6To5 in '..\..\Source\Utils\CnWizDfm6To5.pas';

{$R *.RES}

begin
  Application.Initialize;
  Application.Title := 'DFM ����ת������';
  Application.CreateForm(TCnDTMainForm, CnDTMainForm);
  Application.Run;
end.
