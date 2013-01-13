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

program CnSMR;

uses
  Forms,
  CnMainUnit in 'CnMainUnit.pas' {CnSMRMainForm},
  CnEditARFUnit in 'CnEditARFUnit.pas' {CnEditARFForm},
  CnSMRBplUtils in 'CnSMRBplUtils.pas',
  CnBaseUtils in 'CnBaseUtils.pas',
  CnViewARFUnit in 'CnViewARFUnit.pas' {CnViewARFForm},
  CnViewSMRUnit in 'CnViewSMRUnit.pas' {CnViewSMRForm},
  CnEditSMRUnit in 'CnEditSMRUnit.pas' {CnEditSMRForm},
  CnSMRUtils in 'CnSMRUtils.pas',
  CnAboutUnit in 'CnAboutUnit.pas' {CnAboutForm},
  CnBuffStr in 'CnBuffStr.pas',
  CnSelectMaskFrm in 'CnSelectMaskFrm.pas' {CnSelectMaskForm},
  CnTextPreviewFrm in 'CnTextPreviewFrm.pas' {CnTextPreviewForm},
  CnDirListFrm in 'CnDirListFrm.pas' {CnDirListForm};

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TCnSMRMainForm, CnSMRMainForm);
  Application.CreateForm(TCnDirListForm, CnDirListForm);
  Application.Run;
end.
