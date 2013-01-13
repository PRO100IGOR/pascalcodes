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

program CnDebugViewer;

uses
  Sysutils,
  Forms,
  CnViewMain in 'CnViewMain.pas' {CnMainViewer},
  CnDebugIntf in 'CnDebugIntf.pas',
  CnMsgClasses in 'CnMsgClasses.pas',
  CnGetThread in 'CnGetThread.pas',
  CnViewCore in 'CnViewCore.pas',
  CnMdiView in 'CnMdiView.pas' {CnMsgChild},
  VTHeaderPopup in 'VirtualTree\VTHeaderPopup.pas',
  VirtualTrees in 'VirtualTree\VirtualTrees.pas',
  CnMsgXMLFiler in 'CnMsgXMLFiler.pas',
  CnFilterFrm in 'CnFilterFrm.pas' {CnSenderFilterFrm},
  CnViewOption in 'CnViewOption.pas' {CnViewerOptionsFrm};

{$R *.RES}

begin
  if CheckRunning then Exit;
  Application.Initialize;
  Application.CreateForm(TCnMainViewer, CnMainViewer);
  Application.CreateForm(TCnMsgChild, CnMsgChild);
  CnMainViewer.LaunchThread;
  Application.Run;
end.
