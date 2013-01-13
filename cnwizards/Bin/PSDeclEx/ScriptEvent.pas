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

unit ScriptEvent;
{ |<PRE>
================================================================================
* ������ƣ�CnPack IDE ר�Ұ�
* ��Ԫ���ƣ��ڽű���ʹ�õ� ScriptEvent ��Ԫ����
* ��Ԫ���ߣ��ܾ��� (zjy@cnpack.org)
* ��    ע��
* ����ƽ̨��PWinXP SP2 + Delphi 5.01
* ���ݲ��ԣ�PWin9X/2000/XP + Delphi 5/6/7
* �� �� ����
* ��Ԫ��ʶ��$Id: ScriptEvent.pas 763 2011-02-07 14:18:23Z liuxiao@cnpack.org $
* �޸ļ�¼��2007.09.30 V1.0
*               ������Ԫ
================================================================================
|</PRE>}

interface

uses
  Windows, Messages, Classes, Graphics, Controls, SysUtils, IniFiles, Forms,
  ToolsAPI;

type
  TCnScriptMode = (smManual, smIDELoaded, smFileNotify, smBeforeCompile,
    smAfterCompile, smSourceEditorNotify, smFormEditorNotify);
  TCnScriptModeSet = set of TCnScriptMode;

{$M+} // Generate RTTI
  TCnScriptEvent = class
  private
    FMode: TCnScriptMode;
  published
    property Mode: TCnScriptMode read FMode;
  end;
{$M-}

  TCnScriptManual = class(TCnScriptEvent)
  end;

  TCnScriptIDELoaded = class(TCnScriptEvent)
  end;

  TCnScriptFileNotify = class(TCnScriptEvent)
  private
    FFileName: string;
    FFileNotifyCode: TOTAFileNotification;
  published
    property FileNotifyCode: TOTAFileNotification read FFileNotifyCode;
    property FileName: string read FFileName;
  end;

  TCnScriptBeforeCompile = class(TCnScriptEvent)
  private
    FIsCodeInsight: Boolean;
    FCancel: Boolean;
    FProject: IOTAProject;
  published
    property Project: IOTAProject read FProject;
    property IsCodeInsight: Boolean read FIsCodeInsight;
    property Cancel: Boolean read FCancel write FCancel;
  end;

  TCnScriptAfterCompile = class(TCnScriptEvent)
  private
    FSucceeded: Boolean;
    FIsCodeInsight: Boolean;
  published
    property Succeeded: Boolean read FSucceeded;
    property IsCodeInsight: Boolean read FIsCodeInsight;
  end;

  TCnWizSourceEditorNotifyType = (setOpened, setClosing, setModified,
    setEditViewInsert, setEditViewRemove, setEditViewActivated);

  TCnScriptSourceEditorNotify = class(TCnScriptEvent)
  private
    FEditView: IOTAEditView;
    FSourceEditor: IOTASourceEditor;
    FNotifyType: TCnWizSourceEditorNotifyType;
  published
    property SourceEditor: IOTASourceEditor read FSourceEditor;
    property NotifyType: TCnWizSourceEditorNotifyType read FNotifyType;
    property EditView: IOTAEditView read FEditView;
  end;

  TCnWizFormEditorNotifyType = (fetOpened, fetClosing, fetModified,
    fetActivated, fetSaving, fetComponentCreating, fetComponentCreated,
    fetComponentDestorying, fetComponentRenamed);

  TCnScriptFormEditorNotify = class(TCnScriptEvent)
  private
    FFormEditor: IOTAFormEditor;
    FOldName: string;
    FNewName: string;
    FNotifyType: TCnWizFormEditorNotifyType;
    FComponent: TComponent;
  published
    property FormEditor: IOTAFormEditor read FFormEditor;
    property NotifyType: TCnWizFormEditorNotifyType read FNotifyType;
    property Component: TComponent read FComponent;
    property OldName: string read FOldName;
    property NewName: string read FNewName;
  end;

function Event: TCnScriptEvent; overload;

implementation

function Event: TCnScriptEvent; overload;
begin

end;  

end.
