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

unit CnWizNotifier;
{* |<PRE>
================================================================================
* ������ƣ�CnPack IDE ר�Ұ�
* ��Ԫ���ƣ�IDE ֪ͨ����Ԫ
* ��Ԫ���ߣ��ܾ��� (zjy@cnpack.org)
* ��    ע���õ�Ԫ�ṩ�� IDE ֪ͨ�¼�����
* ����ƽ̨��PWin2000Pro + Delphi 5.0
* ���ݲ��ԣ�PWin9X/2000/XP + Delphi 5/6
* �� �� �����õ�Ԫ�е��ַ��������ϱ��ػ�����ʽ
* ��Ԫ��ʶ��$Id: CnWizNotifier.pas 763 2011-02-07 14:18:23Z liuxiao@cnpack.org $
* �޸ļ�¼��2008.05.05
*               ��Х���� StopExecuteOnApplicationIdle ����
*           2006.10.06
*               ��Х���� Debug ���̺Ͷϵ���¼�֪ͨ����
*           2005.05.06
*               hubdog ���ӱ����¼�֪ͨ����
*           2004.01.09
*               LiuXiao ���� BCB 5 �´򿪵��� Unit ʱ�Ĵ���
*           2003.09.29
*               ���� Application OnIdle��OnMessage ֪ͨ
*           2003.05.04
*               ������������
*           2003.04.28
*               �����˴���༭��֪ͨ������ǿ����༭��֪ͨ����
*           2002.11.22
*               ������Ԫ
================================================================================
|</PRE>}

interface

{$I CnWizards.inc}

uses
  Windows, Messages, SysUtils, Classes, Controls, Forms, ToolsAPI, AppEvnts,
  Consts, ExtCtrls, Contnrs, CnWizUtils, CnClasses;
  
type
  PCnWizNotifierRecord = ^TCnWizNotifierRecord;
  TCnWizNotifierRecord = record
    Notifier: TMethod;
  end;

  NoRefCount = Pointer; // ʹ��ָ��������ǿ��Ϊ�ӿڱ�����ֵ�����������ü���
  
  TCnWizFileNotifier = procedure (NotifyCode: TOTAFileNotification;
    const FileName: string) of object;
  {* IDE �ļ�֪ͨ�¼���NotifyCode Ϊ֪ͨ���ͣ�FileName Ϊ�ļ���}

  TCnWizSourceEditorNotifyType = (setOpened, setClosing, setModified,
    setEditViewInsert, setEditViewRemove, setEditViewActivated);
  TCnWizSourceEditorNotifier = procedure (SourceEditor: IOTASourceEditor;
    NotifyType: TCnWizSourceEditorNotifyType; EditView: IOTAEditView) of object;
  {* SourceEditor ֪ͨ�¼���SourceEditor ΪԴ��༭���ӿڣ�NotifyType Ϊ����}

  TCnWizFormEditorNotifyType = (fetOpened, fetClosing, fetModified,
    fetActivated, fetSaving, fetComponentCreating, fetComponentCreated,
    fetComponentDestorying, fetComponentRenamed);
  TCnWizFormEditorNotifier = procedure (FormEditor: IOTAFormEditor;
    NotifyType: TCnWizFormEditorNotifyType; ComponentHandle: TOTAHandle;
    Component: TComponent; const OldName, NewName: string) of object;

  TCnWizAppEventType = (aeActivate, aeDeactivate, aeMinimize, aeRestore, aeHint);
  TCnWizAppEventNotifier = procedure (EventType: TCnWizAppEventType) of object;

  TCnWizMsgHookNotifier = procedure (hwnd: HWND; Control: TWinControl;
    Msg: TMessage) of object;

  TCnWizBeforeCompileNotifier = procedure (const Project: IOTAProject;
    IsCodeInsight: Boolean; var Cancel: Boolean) of object;
  TCnWizAfterCompileNotifier = procedure (Succeeded: Boolean; IsCodeInsight:
    Boolean) of object;

  TCnWizProcessNotifier = procedure (Process: IOTAProcess) of object;
  TCnWizBreakpointNotifier = procedure (Breakpoint: IOTABreakpoint) of object;

  ICnWizNotifierServices = interface(IUnknown)
  {* IDE ֪ͨ����ӿ�}
    ['{18C4DD6A-802A-48D7-AC93-A2487411CA79}']
    procedure AddFileNotifier(Notifier: TCnWizFileNotifier);
    {* ����һ���ļ�֪ͨ�¼�}
    procedure RemoveFileNotifier(Notifier: TCnWizFileNotifier);
    {* ɾ��һ���ļ�֪ͨ�¼�}
    
    procedure AddBeforeCompileNotifier(Notifier:TCnWizBeforeCompileNotifier);
    {* ����һ������ǰ֪ͨ�¼�}
    procedure RemoveBeforeCompileNotifier(Notifier:TCnWizBeforeCompileNotifier);
    {* ɾ��һ������ǰ֪ͨ�¼�}

    procedure AddAfterCompileNotifier(Notifier:TCnWizAfterCompileNotifier);
    {* ����һ�������֪ͨ�¼�}
    procedure RemoveAfterCompileNotifier(Notifier:TCnWizAfterCompileNotifier);
    {* ɾ��һ�������֪ͨ�¼�}

    procedure AddSourceEditorNotifier(Notifier: TCnWizSourceEditorNotifier);
    {* ����һ��Դ����༭��֪ͨ�¼�}
    procedure RemoveSourceEditorNotifier(Notifier: TCnWizSourceEditorNotifier);
    {* ɾ��һ��Դ����༭��֪ͨ�¼�}

    procedure AddFormEditorNotifier(Notifier: TCnWizFormEditorNotifier);
    {* ����һ������༭��֪ͨ�¼�}
    procedure RemoveFormEditorNotifier(Notifier: TCnWizFormEditorNotifier);
    {* ɾ��һ������༭��֪ͨ�¼�}

    procedure AddActiveFormNotifier(Notifier: TNotifyEvent);
    {* ����һ�������Ծ֪ͨ�¼�}
    procedure RemoveActiveFormNotifier(Notifier: TNotifyEvent);
    {* ɾ��һ�������Ծ֪ͨ�¼�}

    procedure AddActiveControlNotifier(Notifier: TNotifyEvent);
    {* ����һ���ؼ���Ծ֪ͨ�¼�}
    procedure RemoveActiveControlNotifier(Notifier: TNotifyEvent);
    {* ɾ��һ���ؼ���Ծ֪ͨ�¼�}

    procedure AddApplicationIdleNotifier(Notifier: TNotifyEvent);
    {* ����һ��Ӧ�ó������֪ͨ�¼�}
    procedure RemoveApplicationIdleNotifier(Notifier: TNotifyEvent);
    {* ɾ��һ��Ӧ�ó������֪ͨ�¼�}

    procedure AddApplicationMessageNotifier(Notifier: TMessageEvent);
    {* ����һ��Ӧ�ó�����Ϣ֪ͨ�¼�}
    procedure RemoveApplicationMessageNotifier(Notifier: TMessageEvent);
    {* ɾ��һ��Ӧ�ó�����Ϣ֪ͨ�¼�}

    procedure AddAppEventNotifier(Notifier: TCnWizAppEventNotifier);
    {* ����һ��Ӧ�ó����¼�֪ͨ�¼�}
    procedure RemoveAppEventNotifier(Notifier: TCnWizAppEventNotifier);
    {* ɾ��һ��Ӧ�ó����¼�֪ͨ�¼�}

    procedure AddCallWndProcNotifier(Notifier: TCnWizMsgHookNotifier; MsgIDs: array of Cardinal);
    {* ����һ�� CallWndProc HOOK ֪ͨ�¼�}
    procedure RemoveCallWndProcNotifier(Notifier: TCnWizMsgHookNotifier);
    {* ɾ��һ�� CallWndProc HOOK ֪ͨ�¼�}

    procedure AddCallWndProcRetNotifier(Notifier: TCnWizMsgHookNotifier; MsgIDs: array of Cardinal);
    {* ����һ�� CallWndProcRet HOOK ֪ͨ�¼�}
    procedure RemoveCallWndProcRetNotifier(Notifier: TCnWizMsgHookNotifier);
    {* ɾ��һ�� CallWndProcRet HOOK ֪ͨ�¼�}

    procedure AddGetMsgNotifier(Notifier: TCnWizMsgHookNotifier; MsgIDs: array of Cardinal);
    {* ����һ�� GetMessage HOOK ֪ͨ�¼�}
    procedure RemoveGetMsgNotifier(Notifier: TCnWizMsgHookNotifier);
    {* ɾ��һ�� GetMessage HOOK ֪ͨ�¼�}

    procedure AddProcessCreatedNotifier(Notifier: TCnWizProcessNotifier);
    {* ����һ�������Խ���������֪ͨ�¼�}
    procedure RemoveProcessCreatedNotifier(Notifier: TCnWizProcessNotifier);
    {* ɾ��һ�������Խ���������֪ͨ�¼�}
    procedure AddProcessDestroyedNotifier(Notifier: TCnWizProcessNotifier);
    {* ����һ�������Խ�����ֹ��֪ͨ�¼�}
    procedure RemoveProcessDestroyedNotifier(Notifier: TCnWizProcessNotifier);
    {* ɾ��һ�������Խ�����ֹ��֪ͨ�¼�}

    procedure AddBreakpointAddedNotifier(Notifier: TCnWizBreakpointNotifier);
    {* ����һ�����Ӷϵ��֪ͨ�¼�}
    procedure RemoveBreakpointAddedNotifier(Notifier: TCnWizBreakpointNotifier);
    {* ɾ��һ�����Ӷϵ��֪ͨ�¼�}
    procedure AddBreakpointDeletedNotifier(Notifier: TCnWizBreakpointNotifier);
    {* ����һ��ɾ���ϵ��֪ͨ�¼�}
    procedure RemoveBreakpointDeletedNotifier(Notifier: TCnWizBreakpointNotifier);
    {* ɾ��һ��ɾ���ϵ��֪ͨ�¼�}
    
    procedure ExecuteOnApplicationIdle(Method: TNotifyEvent);
    {* ��һ��������Ӧ�ó������ʱִ��}
    procedure StopExecuteOnApplicationIdle(Method: TNotifyEvent);
    {* ��һ���Ѿ�����Ϊ����ʱִ�еķ�������ִ��ǰִֹ֪ͨͣ�У�����ִ����˵�����Ч}
  end;

function CnWizNotifierServices: ICnWizNotifierServices;
{* ��ȡ IDE ֪ͨ����ӿ�}

implementation

{$IFDEF Debug}
uses
  CnDebug, TypInfo;
{$ENDIF Debug}

const
  csIdleMinInterval = 50;

type

//==============================================================================
// IDE ֪ͨ���ࣨ˽���ࣩ
//==============================================================================

{ TCnWizIdeNotifier }

  TCnWizNotifierServices = class;

  TCnWizIdeNotifier = class(TNotifierObject, IOTAIdeNotifier, IOTAIDENotifier50)
  private
    FNotifierServices: TCnWizNotifierServices;
  protected
    // IOTAIdeNotifier
    procedure FileNotification(NotifyCode: TOTAFileNotification;
      const FileName: string; var Cancel: Boolean);
    procedure BeforeCompile(const Project: IOTAProject; var Cancel: Boolean); overload;
    procedure AfterCompile(Succeeded: Boolean); overload;
  protected
    // IOTAIDENotifier50
    procedure BeforeCompile(const Project: IOTAProject; IsCodeInsight: Boolean;
      var Cancel: Boolean); overload;
    procedure AfterCompile(Succeeded: Boolean; IsCodeInsight: Boolean); overload;
  public
    constructor Create(ANotifierServices: TCnWizNotifierServices);
  end;

//==============================================================================
// SourceEditor ֪ͨ���ࣨ˽���ࣩ
//==============================================================================

{ TCnSourceEditorNotifier }

  TCnSourceEditorNotifier = class(TNotifierObject, IOTANotifier, IOTAEditorNotifier)
  private
    FNotifierServices: TCnWizNotifierServices;
    NotifierIndex: Integer;
    OpenedNotified: Boolean;
    ClosingNotified: Boolean;
    SourceEditor: IOTASourceEditor;
  protected
    procedure ViewNotification(const View: IOTAEditView; Operation: TOperation);
    procedure ViewActivated(const View: IOTAEditView);
    procedure Destroyed;
    procedure Modified;
  public
    constructor Create(ANotifierServices: TCnWizNotifierServices);
    destructor Destroy; override;
  end;

//==============================================================================
// FormEditor ֪ͨ���ࣨ˽���ࣩ
//==============================================================================

{ TCnFormEditorNotifier }

  TCnFormEditorNotifier = class(TNotifierObject, IOTANotifier, IOTAFormNotifier)
  private
    FNotifierServices: TCnWizNotifierServices;
    NotifierIndex: Integer;
    ClosingNotified: Boolean;
    FormEditor: IOTAFormEditor;
  protected
    procedure FormActivated;
    procedure FormSaving;
    procedure ComponentRenamed(ComponentHandle: TOTAHandle;
      const OldName, NewName: string);
    procedure Destroyed;
    procedure Modified;
  public
    constructor Create(ANotifierServices: TCnWizNotifierServices);
    destructor Destroy; override;
  end;

//==============================================================================
// DebuggerNotifier ֪ͨ���ࣨ˽���ࣩ
//==============================================================================

{ TCnDebuggerNotifier }

  TCnWizDebuggerNotifier = class(TNotifierObject, IOTANotifier, IOTADebuggerNotifier)
  private
    FNotifierServices: TCnWizNotifierServices;
  protected
    procedure ProcessCreated({$IFDEF COMPILER9_UP}const {$ENDIF}Process: IOTAProcess);
    procedure ProcessDestroyed({$IFDEF COMPILER9_UP}const {$ENDIF}Process: IOTAProcess);
    procedure BreakpointAdded({$IFDEF COMPILER9_UP}const {$ENDIF}Breakpoint: IOTABreakpoint);
    procedure BreakpointDeleted({$IFDEF COMPILER9_UP}const {$ENDIF}Breakpoint: IOTABreakpoint);
  public
    constructor Create(ANotifierServices: TCnWizNotifierServices);
    destructor Destroy; override;
  end;

//==============================================================================
// ���֪ͨ����
//==============================================================================

{ TCnWizCompNotifyObj }

  TCnWizCompNotifyObj = class(TComponent)
  protected
    procedure Notification(AComponent: TComponent; Operation: TOperation); override;
  public
    FormEditor: IOTAFormEditor;
    NotifyType: TCnWizFormEditorNotifyType;
    ComponentHandle: TOTAHandle;
    Component: TComponent;
    OldName, NewName: string;
  end;

//==============================================================================
// ֪ͨ�������ࣨ˽���ࣩ
//==============================================================================

{ TCnWizNotifierServices }

  TCnWizNotifierServices = class(TSingletonInterfacedObject, ICnWizNotifierServices)
  private
    FBeforeCompileNotifiers: TList;
    FAfterCompileNotifiers: TList;
    FProcessCreatedNotifiers: TList;
    FProcessDestroyedNotifiers: TList;
    FBreakpointAddedNotifiers: TList;
    FBreakpointDeletedNotifiers: TList;
    FFileNotifiers: TList;
    FSourceEditorNotifiers: TList;
    FSourceEditorIntfs: TList;
    FFormEditorNotifiers: TList;
    FFormEditorIntfs: TList;
    FActiveFormNotifiers: TList;
    FActiveControlNotifiers: TList;
    FApplicationIdleNotifiers: TList;
    FApplicationMessageNotifiers: TList;
    FAppEventNotifiers: TList;
    FCallWndProcNotifiers: TList;
    FCallWndProcMsgList: TList;
    FCallWndProcRetNotifiers: TList;
    FCallWndProcRetMsgList: TList;
    FGetMsgNotifiers: TList;
    FGetMsgMsgList: TList;
    FIdleMethods: TList;
    FEvents: TApplicationEvents;
    FIdeNotifierIndex: Integer;
    FDebuggerNotifierIndex: Integer;
    FCnWizIdeNotifier: TCnWizIdeNotifier;
    FCnWizDebuggerNotifier: TCnWizDebuggerNotifier;
    FLastControl: TWinControl;
    FLastForm: TForm;
    FCompNotifyList: TComponentList;
    FLastIdleTick: Cardinal;
    FIdleExecuting: Boolean;
    procedure ClearAndFreeList(var List: TList);
    function IndexOf(List: TList; Notifier: TMethod): Integer;
    procedure AddNotifier(List: TList; Notifier: TMethod);
    procedure AddNotifierEx(List, MsgList: TList; Notifier: TMethod; MsgIDs: array of Cardinal);
    procedure RemoveNotifier(List: TList; Notifier: TMethod);
    procedure CheckActiveControl;
    procedure DoIdleNotifiers;
  protected
    // ICnWizNotifierServices
    procedure AddFileNotifier(Notifier: TCnWizFileNotifier);
    procedure RemoveFileNotifier(Notifier: TCnWizFileNotifier);
    procedure AddBeforeCompileNotifier(Notifier: TCnWizBeforeCompileNotifier);
    procedure RemoveBeforeCompileNotifier(Notifier: TCnWizBeforeCompileNotifier);
    procedure AddAfterCompileNotifier(Notifier: TCnWizAfterCompileNotifier);
    procedure RemoveAfterCompileNotifier(Notifier: TCnWizAfterCompileNotifier);
    procedure AddSourceEditorNotifier(Notifier: TCnWizSourceEditorNotifier);
    procedure RemoveSourceEditorNotifier(Notifier: TCnWizSourceEditorNotifier);
    procedure AddFormEditorNotifier(Notifier: TCnWizFormEditorNotifier);
    procedure RemoveFormEditorNotifier(Notifier: TCnWizFormEditorNotifier);
    procedure AddActiveFormNotifier(Notifier: TNotifyEvent);
    procedure RemoveActiveFormNotifier(Notifier: TNotifyEvent);
    procedure AddActiveControlNotifier(Notifier: TNotifyEvent);
    procedure RemoveActiveControlNotifier(Notifier: TNotifyEvent);
    procedure AddApplicationIdleNotifier(Notifier: TNotifyEvent);
    procedure RemoveApplicationIdleNotifier(Notifier: TNotifyEvent);
    procedure AddApplicationMessageNotifier(Notifier: TMessageEvent);
    procedure RemoveApplicationMessageNotifier(Notifier: TMessageEvent);
    procedure AddAppEventNotifier(Notifier: TCnWizAppEventNotifier);
    procedure RemoveAppEventNotifier(Notifier: TCnWizAppEventNotifier);
    procedure AddCallWndProcNotifier(Notifier: TCnWizMsgHookNotifier; MsgIDs: array of Cardinal);
    procedure RemoveCallWndProcNotifier(Notifier: TCnWizMsgHookNotifier);
    procedure AddCallWndProcRetNotifier(Notifier: TCnWizMsgHookNotifier; MsgIDs: array of Cardinal);
    procedure RemoveCallWndProcRetNotifier(Notifier: TCnWizMsgHookNotifier);
    procedure AddGetMsgNotifier(Notifier: TCnWizMsgHookNotifier; MsgIDs: array of Cardinal);
    procedure RemoveGetMsgNotifier(Notifier: TCnWizMsgHookNotifier);
    procedure AddProcessCreatedNotifier(Notifier: TCnWizProcessNotifier);
    procedure RemoveProcessCreatedNotifier(Notifier: TCnWizProcessNotifier);
    procedure AddProcessDestroyedNotifier(Notifier: TCnWizProcessNotifier);
    procedure RemoveProcessDestroyedNotifier(Notifier: TCnWizProcessNotifier);
    procedure AddBreakpointAddedNotifier(Notifier: TCnWizBreakpointNotifier);
    procedure RemoveBreakpointAddedNotifier(Notifier: TCnWizBreakpointNotifier);
    procedure AddBreakpointDeletedNotifier(Notifier: TCnWizBreakpointNotifier);
    procedure RemoveBreakpointDeletedNotifier(Notifier: TCnWizBreakpointNotifier);
    procedure ExecuteOnApplicationIdle(Method: TNotifyEvent);
    procedure StopExecuteOnApplicationIdle(Method: TNotifyEvent);

    procedure FileNotification(NotifyCode: TOTAFileNotification;
      const FileName: string);
    procedure BeforeCompile(const Project: IOTAProject; IsCodeInsight: Boolean;
      var Cancel: Boolean);
    procedure AfterCompile(Succeeded: Boolean; IsCodeInsight: Boolean);

    procedure ProcessCreated(Process: IOTAProcess);
    procedure ProcessDestroyed(Process: IOTAProcess);
    procedure BreakpointAdded(Breakpoint: IOTABreakpoint);
    procedure BreakpointDeleted(Breakpoint: IOTABreakpoint);

    procedure SourceEditorOpened(SourceEditor: IOTASourceEditor;
      CalledByNotifier: Boolean);
    procedure SourceEditorNotify(SourceEditor: IOTASourceEditor;
      NotifyType: TCnWizSourceEditorNotifyType; EditView: IOTAEditView = nil);
    procedure SourceEditorFileNotification(NotifyCode: TOTAFileNotification;
      const FileName: string);

    procedure CheckNewFormEditor;
    procedure FormEditorOpened(FormEditor: IOTAFormEditor);
    procedure FormEditorNotify(FormEditor: IOTAFormEditor;
      NotifyType: TCnWizFormEditorNotifyType);
    procedure FormEditorComponentRenamed(FormEditor: IOTAFormEditor;
      ComponentHandle: TOTAHandle; const OldName, NewName: string);
    procedure CheckCompNotifyObj;
    procedure FormEditorFileNotification(NotifyCode: TOTAFileNotification;
      const FileName: string);
    procedure AppEventNotify(EventType: TCnWizAppEventType);

    procedure DoApplicationIdle(Sender: TObject; var Done: Boolean);
    procedure DoApplicationMessage(var Msg: TMsg; var Handled: Boolean);
    procedure DoMsgHook(AList, MsgList: TList; hwnd: HWND; Msg: TMessage);
    procedure DoCallWndProc(hwnd: HWND; Msg: TMessage);
    procedure DoCallWndProcRet(hwnd: HWND; Msg: TMessage);
    procedure DoGetMsg(hwnd: HWND; Msg: TMessage);
    procedure DoActiveFormChange;
    procedure DoApplicationActivate(Sender: TObject);
    procedure DoApplicationDeactivate(Sender: TObject);
    procedure DoApplicationMinimize(Sender: TObject);
    procedure DoApplicationRestore(Sender: TObject);
    procedure DoApplicationHint(Sender: TObject);
    procedure DoActiveControlChange;
    procedure DoIdleExecute;
  public
    constructor Create;
    destructor Destroy; override;
  end;

var
  FIsReleased: Boolean = False;
  FCnWizNotifierServices: TCnWizNotifierServices;

function CnWizNotifierServices: ICnWizNotifierServices;
begin
  Assert(not FIsReleased, 'Access CnWizNotifierServices After Released.');
  if not Assigned(FCnWizNotifierServices) then
    FCnWizNotifierServices := TCnWizNotifierServices.Create;
  Result := FCnWizNotifierServices as ICnWizNotifierServices;
end;

procedure FreeCnWizNotifierServices;
begin
  if Assigned(FCnWizNotifierServices) then
  begin
    FCnWizNotifierServices.Free;
    FCnWizNotifierServices := nil;
    FIsReleased := True;
  end;
end;

//==============================================================================
// IDE ֪ͨ���ࣨ˽���ࣩ
//==============================================================================

{ TCnWizIdeNotifier }

constructor TCnWizIdeNotifier.Create(ANotifierServices: TCnWizNotifierServices);
begin
  inherited Create;
  FNotifierServices := ANotifierServices;
{$IFDEF Debug}
  CnDebugger.LogMsg('TCnWizIdeNotifier.Create succeed');
{$ENDIF Debug}
end;

procedure TCnWizIdeNotifier.AfterCompile(Succeeded,
  IsCodeInsight: Boolean);
begin
  FNotifierServices.AfterCompile(Succeeded, IsCodeInsight);
end;

procedure TCnWizIdeNotifier.AfterCompile(Succeeded: Boolean);
begin

end;

procedure TCnWizIdeNotifier.BeforeCompile(const Project: IOTAProject;
  var Cancel: Boolean);
begin

end;

procedure TCnWizIdeNotifier.BeforeCompile(const Project: IOTAProject;
  IsCodeInsight: Boolean; var Cancel: Boolean);
begin
  Cancel := False;
  FNotifierServices.BeforeCompile(Project, IsCodeInsight, Cancel);
end;

procedure TCnWizIdeNotifier.FileNotification(
  NotifyCode: TOTAFileNotification; const FileName: string;
  var Cancel: Boolean);
begin
  Cancel := False;
  FNotifierServices.FileNotification(NotifyCode, FileName);
end;

//==============================================================================
// SourceEditor ֪ͨ���ࣨ˽���ࣩ
//==============================================================================

// �� IDE ��ֱ�Ӵ򿪻�رյ�����Ԫʱ��ͨ�� IDE �ļ�֪ͨ���Ի�� SourceEditor��
// ���� EditViewCount Ϊ 1��
// �����ڴ򿪹���ʱ��IDE �ļ�֪ͨ��õ� SourceEditor �� EditViewCount Ϊ 0������
// �ڹرչ���ʱ����������� IDE �ļ�֪ͨ��
// �ʶ�ÿһ�� SourceEditor ע��һ�� Notifier������ļ���ʱ��EditViewCount Ϊ 0��
// ���� Notifier �м�� EditView ���������� SourceEditor Opened ֪ͨ��
// ����ļ������رգ��� IDE �ļ�֪ͨ�в��� SourceEditor Closing ֪ͨ����֮ͨ��
// Notifier �� SourceEditor Destroyed ʱ���� Closing ֪ͨ��

{ TCnSourceEditorNotifier }

constructor TCnSourceEditorNotifier.Create(ANotifierServices: TCnWizNotifierServices);
begin
  Assert(Assigned(ANotifierServices));
  inherited Create;
  FNotifierServices := ANotifierServices;
  OpenedNotified := False;
  ClosingNotified := False;
{$IFDEF Debug}
  CnDebugger.LogMsg('TCnSourceEditorNotifier.Create succeed');
{$ENDIF Debug}
end;

destructor TCnSourceEditorNotifier.Destroy;
var
  idx: Integer;
begin
{$IFDEF Debug}
  CnDebugger.LogEnter('TCnSourceEditorNotifier.Destroy');
{$ENDIF Debug}
  NoRefCount(SourceEditor) := nil;
  with FNotifierServices.FSourceEditorIntfs do
  begin
    idx := IndexOf(Self);
  {$IFDEF Debug}
    CnDebugger.LogInteger(idx, 'IndexOf TCnSourceEditorNotifier');
  {$ENDIF Debug}
    if idx >= 0 then
      Delete(idx);
  end;
  inherited;
{$IFDEF Debug}
  CnDebugger.LogLeave('TCnSourceEditorNotifier.Destroy');
{$ENDIF Debug}
end;

procedure TCnSourceEditorNotifier.Destroyed;
begin
{$IFDEF Debug}
  CnDebugger.LogMsg('TCnSourceEditorNotifier.Destroyed: ' + SourceEditor.FileName);
  CnDebugger.LogInteger(SourceEditor.EditViewCount, 'TCnSourceEditorNotifier ViewCount');
{$ENDIF Debug}
  if not ClosingNotified then
  begin
    ClosingNotified := True;
    FNotifierServices.SourceEditorNotify(SourceEditor, setClosing);
  end;
  NoRefCount(SourceEditor) := nil;
end;

procedure TCnSourceEditorNotifier.Modified;
begin
  FNotifierServices.SourceEditorNotify(SourceEditor, setModified);
end;

procedure TCnSourceEditorNotifier.ViewActivated(const View: IOTAEditView);
begin
  FNotifierServices.SourceEditorNotify(SourceEditor, setEditViewActivated, View)
end;

procedure TCnSourceEditorNotifier.ViewNotification(const View: IOTAEditView;
  Operation: TOperation);
begin
{$IFDEF Debug}
  CnDebugger.LogFmt('ViewNotification: %s, %s', [SourceEditor.FileName,
    GetEnumName(TypeInfo(TOperation), Ord(Operation))]);
{$ENDIF Debug}
  if not OpenedNotified and (Operation = opInsert) then
  begin
    OpenedNotified := True;
    FNotifierServices.SourceEditorOpened(SourceEditor, True);
  end;

  if Operation = opInsert then
    FNotifierServices.SourceEditorNotify(SourceEditor, setEditViewInsert, View)
  else if Operation = opRemove then
    FNotifierServices.SourceEditorNotify(SourceEditor, setEditViewRemove, View)
end;

//==============================================================================
// FormEditor ֪ͨ���ࣨ˽���ࣩ
//==============================================================================

{ TCnFormEditorNotifier }

constructor TCnFormEditorNotifier.Create(
  ANotifierServices: TCnWizNotifierServices);
begin
  Assert(Assigned(ANotifierServices));
  inherited Create;
  FNotifierServices := ANotifierServices;
  ClosingNotified := False;
{$IFDEF Debug}
  CnDebugger.LogMsg('TCnFormEditorNotifier.Create succeed');
{$ENDIF Debug}
end;

destructor TCnFormEditorNotifier.Destroy;
var
  idx: Integer;
begin
{$IFDEF Debug}
  CnDebugger.LogEnter('TCnFormEditorNotifier.Destroy');
{$ENDIF Debug}
  NoRefCount(FormEditor) := nil;
  with FNotifierServices.FFormEditorIntfs do
  begin
    idx := IndexOf(Self);
  {$IFDEF Debug}
    CnDebugger.LogInteger(idx, 'Index');
  {$ENDIF Debug}
    if idx >= 0 then
      Delete(idx);
  end;
  inherited;
{$IFDEF Debug}
  CnDebugger.LogLeave('TCnFormEditorNotifier.Destroy');
{$ENDIF Debug}
end;

procedure TCnFormEditorNotifier.Destroyed;
begin
{$IFDEF Debug}
  CnDebugger.LogMsg('TCnFormEditorNotifier.Destroyed: ' + FormEditor.FileName);
{$ENDIF Debug}
  if not ClosingNotified then
  begin
    ClosingNotified := True;
    FNotifierServices.FormEditorNotify(FormEditor, fetClosing);
  end;
  FormEditor.RemoveNotifier(NotifierIndex);
  NoRefCount(FormEditor) := nil;
end;

procedure TCnFormEditorNotifier.ComponentRenamed(
  ComponentHandle: TOTAHandle; const OldName, NewName: string);
begin
  FNotifierServices.FormEditorComponentRenamed(FormEditor, ComponentHandle,
    Trim(OldName), Trim(NewName));
end;

procedure TCnFormEditorNotifier.FormActivated;
begin
  FNotifierServices.FormEditorNotify(FormEditor, fetActivated);
end;

procedure TCnFormEditorNotifier.FormSaving;
begin
  FNotifierServices.FormEditorNotify(FormEditor, fetSaving);
end;

procedure TCnFormEditorNotifier.Modified;
begin
  FNotifierServices.FormEditorNotify(FormEditor, fetModified);
end;

//==============================================================================
// Windows HOOK
//==============================================================================

var
  CallWndProcHook: HHOOK;
  CallWndProcRetHook: HHOOK;
  GetMsgHook: HHOOK;

function CallWndProc(nCode: Integer; wParam: WPARAM; lParam: LPARAM): LRESULT; stdcall;
var
  Msg: TMessage;
begin
  if nCode < 0 then
  begin
    Result := CallNextHookEx(CallWndProcHook, nCode, wParam, lParam);
    Exit;
  end;

  if nCode = HC_ACTION then
  begin
    FillChar(Msg, SizeOf(Msg), 0);
    Msg.Msg := PCWPStruct(lParam)^.message;
    Msg.LParam := PCWPStruct(lParam)^.lParam;
    Msg.WParam := PCWPStruct(lParam)^.wParam;
    FCnWizNotifierServices.DoCallWndProc(PCWPStruct(lParam)^.hwnd, Msg);
  end;

  Result := CallNextHookEx(CallWndProcHook, nCode, wParam, lParam);
end;

function CallWndProcRet(nCode: Integer; wParam: WPARAM; lParam: LPARAM): LRESULT; stdcall;
var
  Msg: TMessage;
begin
  if nCode < 0 then
  begin
    Result := CallNextHookEx(CallWndProcRetHook, nCode, wParam, lParam);
    Exit;
  end;

  if nCode = HC_ACTION then
  begin
    FillChar(Msg, SizeOf(Msg), 0);
    Msg.Msg := PCWPRetStruct(lParam)^.message;
    Msg.LParam := PCWPRetStruct(lParam)^.lParam;
    Msg.WParam := PCWPRetStruct(lParam)^.wParam;
    Msg.Result := PCWPRetStruct(lParam)^.lResult;
    FCnWizNotifierServices.DoCallWndProcRet(PCWPRetStruct(lParam)^.hwnd, Msg);
  end;

  Result := CallNextHookEx(CallWndProcRetHook, nCode, wParam, lParam);
end;

function GetMsgProc(nCode: Integer; wParam: WPARAM; lParam: LPARAM): LRESULT; stdcall;
var
  Msg: TMessage;
begin
  if nCode < 0 then
  begin
    Result := CallNextHookEx(GetMsgHook, nCode, wParam, lParam);
    Exit;
  end;

  if nCode = HC_ACTION then
  begin
    if wParam = PM_REMOVE then
    begin
      FillChar(Msg, SizeOf(Msg), 0);
      Msg.Msg := PMsg(lParam)^.message;
      Msg.LParam := PMsg(lParam)^.lParam;
      Msg.WParam := PMsg(lParam)^.wParam;
      FCnWizNotifierServices.DoGetMsg(PMsg(lParam)^.hwnd, Msg);
    end;
  end;

  Result := CallNextHookEx(GetMsgHook, nCode, wParam, lParam);
end;

//==============================================================================
// ���֪ͨ����
//==============================================================================

{ TCnWizCompNotifyObj }

procedure TCnWizCompNotifyObj.Notification(AComponent: TComponent;
  Operation: TOperation);
begin
  inherited;
  if (AComponent = Component) and (Operation = opRemove) then
    Free;
end;

//==============================================================================
// ֪ͨ�������ࣨ˽���ࣩ
//==============================================================================

{ TCnWizNotifierServices }

constructor TCnWizNotifierServices.Create;
var
  IServices: IOTAServices;
  IDebuggerService: IOTADebuggerServices;
begin
  inherited;
  IServices := BorlandIDEServices as IOTAServices;
  IDebuggerService := BorlandIDEServices as IOTADebuggerServices;
  Assert(Assigned(IServices) and Assigned(IDebuggerService));

  FBeforeCompileNotifiers := TList.Create;
  FAfterCompileNotifiers := TList.Create;
  FProcessCreatedNotifiers := TList.Create;
  FProcessDestroyedNotifiers := TList.Create;
  FBreakpointAddedNotifiers := TList.Create;
  FBreakpointDeletedNotifiers := TList.Create;

  FFileNotifiers := TList.Create;
  FEvents := TApplicationEvents.Create(nil);
  FEvents.OnIdle := DoApplicationIdle;
  FEvents.OnMessage := DoApplicationMessage;
  //FEvents.OnActivate := DoApplicationActivate;
  //FEvents.OnDeactivate := DoApplicationDeactivate;
  FEvents.OnMinimize := DoApplicationMinimize;
  FEvents.OnRestore := DoApplicationRestore;
  FEvents.OnHint := DoApplicationHint;
  FSourceEditorNotifiers := TList.Create;
  FSourceEditorIntfs := TList.Create;
  FFormEditorNotifiers := TList.Create;
  FFormEditorIntfs := TList.Create;
  FActiveFormNotifiers := TList.Create;
  FActiveControlNotifiers := TList.Create;
  FApplicationIdleNotifiers := TList.Create;
  FApplicationMessageNotifiers := TList.Create;
  FAppEventNotifiers := TList.Create;
  FCallWndProcNotifiers := TList.Create;
  FCallWndProcMsgList := TList.Create;
  FCallWndProcRetNotifiers := TList.Create;
  FCallWndProcRetMsgList := TList.Create;
  FGetMsgNotifiers := TList.Create;
  FGetMsgMsgList := TList.Create;
  FIdleMethods := TList.Create;
  FCompNotifyList := TComponentList.Create(True);
  FCnWizIdeNotifier := TCnWizIdeNotifier.Create(Self);
  FIdeNotifierIndex := IServices.AddNotifier(FCnWizIdeNotifier as IOTAIDENotifier);
  FCnWizDebuggerNotifier := TCnWizDebuggerNotifier.Create(Self);
  FDebuggerNotifierIndex := IDebuggerService.AddNotifier(FCnWizDebuggerNotifier as IOTADebuggerNotifier);
  CallWndProcHook := SetWindowsHookEx(WH_CALLWNDPROC, CallWndProc, 0, GetCurrentThreadId);
  CallWndProcRetHook := SetWindowsHookEx(WH_CALLWNDPROCRET, CallWndProcRet, 0, GetCurrentThreadId);
  GetMsgHook := SetWindowsHookEx(WH_GETMESSAGE, GetMsgProc, 0, GetCurrentThreadId);
  FLastControl := nil;
  FLastForm := nil;
{$IFDEF Debug}
  CnDebugger.LogMsg('TCnWizNotifierServices.Create succeed');
{$ENDIF Debug}
end;

destructor TCnWizNotifierServices.Destroy;
var
  IServices: IOTAServices;
  IDebuggerService: IOTADebuggerServices;
  i: Integer;
begin
{$IFDEF Debug}
  CnDebugger.LogEnter('TCnWizNotifierServices.Destroy');
{$ENDIF Debug}
  UnhookWindowsHookEx(CallWndProcHook);
  CallWndProcHook := 0;
  UnhookWindowsHookEx(CallWndProcRetHook);
  CallWndProcRetHook := 0;
  UnhookWindowsHookEx(GetMsgHook);
  GetMsgHook := 0;

  IServices := BorlandIDEServices as IOTAServices;
  if Assigned(IServices) then
    IServices.RemoveNotifier(FIdeNotifierIndex);
  IDebuggerService := BorlandIDEServices as IOTADebuggerServices;
  if Assigned(IDebuggerService) then
    IDebuggerService.RemoveNotifier(FDebuggerNotifierIndex);

  FreeAndNil(FCompNotifyList);
  FreeAndNil(FEvents);

  ClearAndFreeList(FBeforeCompileNotifiers);
  ClearAndFreeList(FAfterCompileNotifiers);
  ClearAndFreeList(FProcessCreatedNotifiers);
  ClearAndFreeList(FProcessDestroyedNotifiers);
  ClearAndFreeList(FBreakpointAddedNotifiers);
  ClearAndFreeList(FBreakpointDeletedNotifiers);
  ClearAndFreeList(FFileNotifiers);
  ClearAndFreeList(FSourceEditorNotifiers);
  ClearAndFreeList(FFormEditorNotifiers);
  ClearAndFreeList(FActiveFormNotifiers);
  ClearAndFreeList(FActiveControlNotifiers);
  ClearAndFreeList(FApplicationIdleNotifiers);
  ClearAndFreeList(FApplicationMessageNotifiers);
  ClearAndFreeList(FAppEventNotifiers);
  ClearAndFreeList(FCallWndProcNotifiers);
  FreeAndNil(FCallWndProcMsgList);
  ClearAndFreeList(FCallWndProcRetNotifiers);
  FreeAndNil(FCallWndProcRetMsgList);
  ClearAndFreeList(FGetMsgNotifiers);
  FreeAndNil(FGetMsgMsgList);
  ClearAndFreeList(FIdleMethods);

{$IFDEF Debug}
  CnDebugger.LogInteger(FFormEditorIntfs.Count, 'Remove FormEditorNotifiers');
{$ENDIF Debug}
  for i := FFormEditorIntfs.Count - 1 downto 0 do
  begin
    with TCnFormEditorNotifier(FFormEditorIntfs[i]) do
    begin
      if Assigned(FormEditor) then
      begin
        {$IFDEF Debug}
          CnDebugger.LogMsg('Form: ' + FormEditor.FileName);
        {$ENDIF Debug}
          FormEditor.RemoveNotifier(NotifierIndex);
      end;
    end;
  end;
  FreeAndNil(FFormEditorIntfs);

{$IFDEF Debug}
  CnDebugger.LogInteger(FSourceEditorIntfs.Count, 'Remove SourceEditorNotifiers');
{$ENDIF Debug}
  for i := FSourceEditorIntfs.Count - 1 downto 0 do
  begin
    with TCnSourceEditorNotifier(FSourceEditorIntfs[i]) do
    begin
      if Assigned(SourceEditor) then
      begin
        {$IFDEF Debug}
          CnDebugger.LogMsg('Source: ' + SourceEditor.FileName);
        {$ENDIF Debug}
          SourceEditor.RemoveNotifier(NotifierIndex);
      end;
    end;
  end;
  FreeAndNil(FSourceEditorIntfs);

  inherited;
{$IFDEF Debug}
  CnDebugger.LogLeave('TCnWizNotifierServices.Destroy');
{$ENDIF Debug}
end;

//------------------------------------------------------------------------------
// �б����
//------------------------------------------------------------------------------

procedure TCnWizNotifierServices.AddNotifier(List: TList;
  Notifier: TMethod);
var
  Rec: PCnWizNotifierRecord;
begin
  if IndexOf(List, Notifier) < 0 then
  begin
    New(Rec);
    Rec^.Notifier := TMethod(Notifier);
    List.Add(Rec);
  end;
end;

procedure TCnWizNotifierServices.AddNotifierEx(List, MsgList: TList;
  Notifier: TMethod; MsgIDs: array of Cardinal);
var
  I: Integer;
begin
  AddNotifier(List, Notifier);
  for I := Low(MsgIDs) to High(MsgIDs) do
    if MsgList.IndexOf(Pointer(MsgIDs[I])) < 0 then
      MsgList.Add(Pointer(MsgIDs[I]));
end;

procedure TCnWizNotifierServices.RemoveNotifier(List: TList;
  Notifier: TMethod);
var
  Rec: PCnWizNotifierRecord;
  idx: Integer;
begin
  idx := IndexOf(List, Notifier);
  if idx >= 0 then
  begin
    Rec := List[idx];
    Dispose(Rec);
    List.Delete(idx);
  end;
end;

procedure TCnWizNotifierServices.ClearAndFreeList(var List: TList);
var
  Rec: PCnWizNotifierRecord;
begin
  while List.Count > 0 do
  begin
    Rec := List[0];
    Dispose(Rec);
    List.Delete(0);
  end;
  FreeAndNil(List);
end;

function TCnWizNotifierServices.IndexOf(List: TList;
  Notifier: TMethod): Integer;
var
  i: Integer;
begin
  Result := -1;
  for i := 0 to List.Count - 1 do
    if CompareMem(List[i], @Notifier, SizeOf(TMethod)) then
    begin
      Result := i;
      Exit;
    end;
end;

//------------------------------------------------------------------------------
// IDE �ļ�֪ͨ
//------------------------------------------------------------------------------

procedure TCnWizNotifierServices.AddFileNotifier(
  Notifier: TCnWizFileNotifier);
begin
  AddNotifier(FFileNotifiers, TMethod(Notifier));
end;

procedure TCnWizNotifierServices.RemoveFileNotifier(
  Notifier: TCnWizFileNotifier);
begin
  RemoveNotifier(FFileNotifiers, TMethod(Notifier));
end;

procedure TCnWizNotifierServices.FileNotification(
  NotifyCode: TOTAFileNotification; const FileName: string);
var
  i: Integer;
begin
{$IFDEF Debug}
  CnDebugger.LogFmt('FileNotification: %s (%s)',
    [GetEnumName(TypeInfo(TOTAFileNotification), Ord(NotifyCode)), FileName]);
{$ENDIF Debug}

  if Trim(FileName) = '' then
    Exit; // BCB ���������ļ���������

  SourceEditorFileNotification(NotifyCode, FileName);
  FormEditorFileNotification(NotifyCode, FileName);
  if FFileNotifiers <> nil then
  begin
    for i := FFileNotifiers.Count - 1 downto 0 do
    try
      with PCnWizNotifierRecord(FFileNotifiers[i])^ do
        TCnWizFileNotifier(Notifier)(NotifyCode, FileName);
    except
      DoHandleException('TCnWizNotifierServices.FileNotification[' + IntToStr(i) + ']');
    end;
  end;

  if NotifyCode = ofnPackageUninstalled then
  begin
    if (Application = nil) or (Application.FindComponent('AppBuilder') = nil) then
    begin
    {$IFDEF DEBUG}
      if not IdeClosing then
      begin
        CnDebugger.LogSeparator;
        CnDebugger.LogMsg('Ide is closing');
      end;
    {$ENDIF}
      IdeClosing := True;
    end;
  end;
end;

//------------------------------------------------------------------------------
// ����֪ͨ
//------------------------------------------------------------------------------

procedure TCnWizNotifierServices.AddAfterCompileNotifier(
  Notifier: TCnWizAfterCompileNotifier);
begin
  AddNotifier(FAfterCompileNotifiers, TMethod(Notifier));
end;

procedure TCnWizNotifierServices.AddBeforeCompileNotifier(
  Notifier: TCnWizBeforeCompileNotifier);
begin
  AddNotifier(FBeforeCompileNotifiers, TMethod(Notifier));
end;

procedure TCnWizNotifierServices.RemoveAfterCompileNotifier(
  Notifier: TCnWizAfterCompileNotifier);
begin
  RemoveNotifier(FAfterCompileNotifiers, TMethod(Notifier));
end;

procedure TCnWizNotifierServices.RemoveBeforeCompileNotifier(
  Notifier: TCnWizBeforeCompileNotifier);
begin
  RemoveNotifier(FBeforeCompileNotifiers, TMethod(Notifier));
end;

procedure TCnWizNotifierServices.AfterCompile(Succeeded,
  IsCodeInsight: Boolean);
var
  i: Integer;
begin
{$IFDEF DEBUG}
  CnDebugger.LogFmt('AfterCompile: Succedded: %d IsCodeInsight: %d',
    [Integer(Succeeded), Integer(IsCodeInsight)]);
{$ENDIF}
  if GetCurrentThreadId <> MainThreadID then
    Exit;
  if FAfterCompileNotifiers <> nil then
  begin
    for i := FAfterCompileNotifiers.Count - 1 downto 0 do
    try
      with PCnWizNotifierRecord(FAfterCompileNotifiers[i])^ do
        TCnWizAfterCompileNotifier(Notifier)(Succeeded, IsCodeInsight);
    except
      DoHandleException('TCnWizNotifierServices.AfterCompile[' + IntToStr(i) + ']');
    end;
  end;
end;

procedure TCnWizNotifierServices.BeforeCompile(const Project: IOTAProject;
  IsCodeInsight: Boolean; var Cancel: Boolean);
var
  i: Integer;
begin
{$IFDEF DEBUG}
  if Project = nil then
    CnDebugger.LogFmt('BeforeCompile: Project is nil. IsCodeInsight: %d',
      [Integer(IsCodeInsight)])
  else
    CnDebugger.LogFmt('BeforeCompile: %s IsCodeInsight: %d',
      [Project.FileName, Integer(IsCodeInsight)]);
{$ENDIF}
  if GetCurrentThreadId <> MainThreadID then
    Exit;
  if FBeforeCompileNotifiers <> nil then
  begin
    for i := FBeforeCompileNotifiers.Count - 1 downto 0 do
    try
      with PCnWizNotifierRecord(FBeforeCompileNotifiers[i])^ do
        TCnWizBeforeCompileNotifier(Notifier)(Project, IsCodeInsight, Cancel);
    except
      DoHandleException('TCnWizNotifierServices.BeforeCompile[' + IntToStr(i) + ']');
    end;
  end;
end;

//------------------------------------------------------------------------------
// SourceEditor ֪ͨ
//------------------------------------------------------------------------------

procedure TCnWizNotifierServices.AddSourceEditorNotifier(
  Notifier: TCnWizSourceEditorNotifier);
begin
  AddNotifier(FSourceEditorNotifiers, TMethod(Notifier));
end;

procedure TCnWizNotifierServices.RemoveSourceEditorNotifier(
  Notifier: TCnWizSourceEditorNotifier);
begin
  RemoveNotifier(FSourceEditorNotifiers, TMethod(Notifier));
end;

procedure TCnWizNotifierServices.SourceEditorNotify(SourceEditor: IOTASourceEditor;
  NotifyType: TCnWizSourceEditorNotifyType; EditView: IOTAEditView = nil);
var
  i: Integer;
begin
{$IFDEF DEBUG}
  CnDebugger.LogFmt('SourceEditorNotifier: %s (%s)',
    [GetEnumName(TypeInfo(TCnWizSourceEditorNotifyType), Ord(NotifyType)),
    SourceEditor.FileName]);
{$ENDIF}
  if FSourceEditorNotifiers <> nil then
  begin
    for i := FSourceEditorNotifiers.Count - 1 downto 0 do
    try
      with PCnWizNotifierRecord(FSourceEditorNotifiers[i])^ do
        TCnWizSourceEditorNotifier(Notifier)(SourceEditor, NotifyType, EditView);
    except
      DoHandleException('TCnWizNotifierServices.SourceEditorNotify[' + IntToStr(i) + ']');
    end;
  end;
end;

procedure TCnWizNotifierServices.SourceEditorOpened(
  SourceEditor: IOTASourceEditor; CalledByNotifier: Boolean);
var
  Notifier: TCnSourceEditorNotifier;
begin
{$IFDEF COMPILER5}
  // D5 �����Ϊ���ļ�ע��֪ͨ�������ͷ�ʱ���ܻ���쳣
  if IsPackage(SourceEditor.FileName) then
    Exit;
{$ENDIF COMPILER5}

  if SourceEditor.GetEditViewCount > 0 then
  begin
    SourceEditorNotify(SourceEditor, setOpened);

    // ���������֪ͨ�����õģ�����һ��֪ͨ������ñ༭���ر�ʱ��֪ͨ
    if not CalledByNotifier then
    begin
      Notifier := TCnSourceEditorNotifier.Create(Self);
      Notifier.OpenedNotified := True;

      NoRefCount(Notifier.SourceEditor) := NoRefCount(SourceEditor);
      Notifier.NotifierIndex := SourceEditor.AddNotifier(Notifier as IOTAEditorNotifier);
      FSourceEditorIntfs.Add(Notifier);
    end
  end
  else
  begin
    // ��һ������ʱ��SourceEditor ��û�� View �ģ��ʴ���һ��֪ͨ����
    // SourceEditor ������һ�� View ʱ���֪ͨ
    Notifier := TCnSourceEditorNotifier.Create(Self);
    Notifier.OpenedNotified := False;
    // ���������ü����±���ӿڣ�����ر�ʱ�����
    NoRefCount(Notifier.SourceEditor) := NoRefCount(SourceEditor);
    Notifier.NotifierIndex := SourceEditor.AddNotifier(Notifier as IOTAEditorNotifier);
    FSourceEditorIntfs.Add(Notifier);
  end;
end;

procedure TCnWizNotifierServices.SourceEditorFileNotification(
  NotifyCode: TOTAFileNotification; const FileName: string);
var
  i, j: Integer;
  Module: IOTAModule;
  Editor: IOTAEditor;
  SourceEditor: IOTASourceEditor;
begin
  if (NotifyCode = ofnFileOpened) or (NotifyCode = ofnFileClosing) then
  begin
    Module := CnOtaGetModule(FileName);
    if not Assigned(Module) then Exit;
    for i := 0 to Module.GetModuleFileCount - 1 do
    begin
      Editor := nil;
      try
        Editor := Module.GetModuleFileEditor(i);
        // BCB 5 �е��ô˺������ܻ�����ʳ�ͻ�����Դ������Σ��������ơ�
      except
        ;
      end;

      if Assigned(Editor) and Supports(Editor, IOTASourceEditor, SourceEditor) then
      begin
        if NotifyCode = ofnFileOpened then
        begin
        {$IFDEF Debug}
          CnDebugger.LogMsg('SourceEditorOpened');
        {$ENDIF Debug}
          SourceEditorOpened(SourceEditor, False);
        end
        else
        begin
        {$IFDEF Debug}
          CnDebugger.LogMsg('SourceEditorClosing');
        {$ENDIF Debug}
          SourceEditorNotify(SourceEditor, setClosing);
          for j := 0 to FSourceEditorIntfs.Count - 1 do
            if TCnSourceEditorNotifier(FSourceEditorIntfs[j]).SourceEditor =
              SourceEditor then
            begin
            {$IFDEF Debug}
              CnDebugger.LogMsg('Remove SourceEditorNotifier in FileNotification');
            {$ENDIF Debug}
              TCnSourceEditorNotifier(FSourceEditorIntfs[j]).ClosingNotified := True;
              Break;
            end;
        end;
      end;
    end;
  end;
end;

//------------------------------------------------------------------------------
// FormEditor ֪ͨ
//------------------------------------------------------------------------------

procedure TCnWizNotifierServices.AddFormEditorNotifier(
  Notifier: TCnWizFormEditorNotifier);
begin
  AddNotifier(FFormEditorNotifiers, TMethod(Notifier));
end;

procedure TCnWizNotifierServices.RemoveFormEditorNotifier(
  Notifier: TCnWizFormEditorNotifier);
begin
  RemoveNotifier(FFormEditorNotifiers, TMethod(Notifier));
end;

procedure TCnWizNotifierServices.FormEditorNotify(FormEditor: IOTAFormEditor;
  NotifyType: TCnWizFormEditorNotifyType);
var
  i: Integer;
begin
{$IFDEF DEBUG}
  CnDebugger.LogFmt('FormEditorNotify: %s (%s)',
   [GetEnumName(TypeInfo(TCnWizFormEditorNotifyType),
    Ord(NotifyType)), FormEditor.FileName]);
{$ENDIF}
  if FFormEditorNotifiers <> nil then
  begin
    for I := FFormEditorNotifiers.Count - 1 downto 0 do
    try
      with PCnWizNotifierRecord(FFormEditorNotifiers[I])^ do
        TCnWizFormEditorNotifier(Notifier)(FormEditor, NotifyType, nil, nil, '', '');
    except
      DoHandleException('TCnWizNotifierServices.FormEditorNotify[' + IntToStr(I) + ']');
    end;
  end;
end;

procedure TCnWizNotifierServices.FormEditorComponentRenamed(
  FormEditor: IOTAFormEditor; ComponentHandle: TOTAHandle; const OldName,
  NewName: string);
var
  i: Integer;
  NotifyType: TCnWizFormEditorNotifyType;
  Comp: TComponent;
  NotifyObj: TCnWizCompNotifyObj;

  function GetComponent: TComponent;
  var
    OTAComponent: IOTAComponent;
    NTAComponent: INTAComponent;
  begin
    Result := nil;
    OTAComponent := FormEditor.GetComponentFromHandle(ComponentHandle);
    QuerySvcs(OTAComponent, INTAComponent, NTAComponent);
    if Assigned(NTAComponent) then
      Result := NTAComponent.GetComponent;
  end;
begin
  if (FFormEditorNotifiers <> nil) and IsVCLFormEditor(FormEditor) then
  begin
    Comp := GetComponent;
    
    // ����������ʱ�¾������ǿգ���ʼ����ɺ������ḳ����ֵ
    if (OldName = '') and (NewName = '') then
      NotifyType := fetComponentCreating
    else if (OldName = '') and (NewName <> '') then
    begin
      // ����մ���ʱ Name �����Ի�û�и�ֵ����ʱ���������¼�
      NotifyObj := TCnWizCompNotifyObj.Create(nil);
      NotifyObj.FormEditor := FormEditor;
      NotifyObj.NotifyType := fetComponentCreated;
      NotifyObj.ComponentHandle := ComponentHandle;
      NotifyObj.Component := Comp;
      Comp.FreeNotification(NotifyObj);
      NotifyObj.OldName := OldName;
      NotifyObj.NewName := NewName;
      FCompNotifyList.Add(NotifyObj);
  {$IFDEF DEBUG}
      CnDebugger.LogFmt('Component DelayCreated: %s --> %s.', [OldName, NewName]);
  {$ENDIF}
      Exit;
    end
    else if (OldName <> '') and (NewName = '') then
      NotifyType := fetComponentDestorying
    else
      NotifyType := fetComponentRenamed;
  {$IFDEF DEBUG}
    CnDebugger.LogFmt('Component renamed: %s --> %s. NotifyType %d', [OldName, NewName, Integer(NotifyType)]);
  {$ENDIF}

    for I := FFormEditorNotifiers.Count - 1 downto 0 do
    try
      with PCnWizNotifierRecord(FFormEditorNotifiers[I])^ do
        TCnWizFormEditorNotifier(Notifier)(FormEditor, NotifyType,
          ComponentHandle, Comp, OldName, NewName);
    except
      DoHandleException('TCnWizNotifierServices.FormEditorComponentRenamed[' + IntToStr(I) + ']');
    end;
  end;
end;

procedure TCnWizNotifierServices.CheckCompNotifyObj;
var
  i: Integer;
  NotifyObj: TCnWizCompNotifyObj;
begin
  if FFormEditorNotifiers <> nil then
  begin
    while FCompNotifyList.Count > 0 do
    begin
      NotifyObj := TCnWizCompNotifyObj(FCompNotifyList.Extract(FCompNotifyList.First));
      for I := FFormEditorNotifiers.Count - 1 downto 0 do
      try
        with PCnWizNotifierRecord(FFormEditorNotifiers[I])^, NotifyObj do
          TCnWizFormEditorNotifier(Notifier)(FormEditor, NotifyType,
            ComponentHandle, Component, OldName, NewName);
      except
        DoHandleException('TCnWizNotifierServices.FormEditorComponentRenamed[' + IntToStr(I) + '] at Idle.');
      end;
    end;      
  end;
end;

procedure TCnWizNotifierServices.FormEditorOpened(
  FormEditor: IOTAFormEditor);
var
  Notifier: TCnFormEditorNotifier;
begin
  FormEditorNotify(FormEditor, fetOpened);

  Notifier := TCnFormEditorNotifier.Create(Self);
  NoRefCount(Notifier.FormEditor) := NoRefCount(FormEditor);
  Notifier.NotifierIndex := FormEditor.AddNotifier(Notifier as IOTAFormNotifier);
  FFormEditorIntfs.Add(Notifier);
end;

procedure TCnWizNotifierServices.CheckNewFormEditor;
var
  ModuleServices: IOTAModuleServices;
  Module: IOTAModule;
  Editor: IOTAEditor;
  FormEditor: IOTAFormEditor;
  i, j, k: Integer;
  Exists: Boolean;
begin
  Assert(Assigned(BorlandIDEServices));

  ModuleServices := BorlandIDEServices as IOTAModuleServices;
  Assert(Assigned(ModuleServices));

  for i := 0 to ModuleServices.ModuleCount - 1 do
  begin
    Module := ModuleServices.Modules[i];
    for j := 0 to Module.GetModuleFileCount - 1 do
    begin
      Editor := nil;
      try
        Editor := Module.GetModuleFileEditor(j);
      except
        ;
      end;
      if Assigned(Editor) and Supports(Editor, IOTAFormEditor, FormEditor) then
      begin
        Exists := False;
        for k := 0 to FFormEditorIntfs.Count - 1 do
          if TCnFormEditorNotifier(FFormEditorIntfs[k]).FormEditor =
            FormEditor then
          begin
            Exists := True;
            Break;
          end;
          
        if not Exists then
        begin
        {$IFDEF Debug}
          CnDebugger.LogMsg('New FormEditor found: ' + FormEditor.FileName);
        {$ENDIF Debug}
          FormEditorOpened(FormEditor);
        end;
      end;
    end;
  end;
end;

procedure TCnWizNotifierServices.FormEditorFileNotification(
  NotifyCode: TOTAFileNotification; const FileName: string);
var
  I, J: Integer;
  Module: IOTAModule;
  Editor: IOTAEditor;
  FormEditor: IOTAFormEditor;
begin
  if (NotifyCode = ofnFileOpened) or (NotifyCode = ofnFileClosing) then
  begin
    Module := CnOtaGetModule(FileName);
    if not Assigned(Module) then Exit;
    for I := 0 to Module.GetModuleFileCount - 1 do
    begin
      Editor := nil;
      try
        Editor := Module.GetModuleFileEditor(I);
      except
        ;
      end;
      if Assigned(Editor) and Supports(Editor, IOTAFormEditor, FormEditor) then
        if NotifyCode = ofnFileOpened then
        begin
        {$IFDEF Debug}
          CnDebugger.LogMsg('FormEditorOpened');
        {$ENDIF Debug}
          FormEditorOpened(FormEditor);
        end
        else
        begin
        {$IFDEF Debug}
          CnDebugger.LogMsg('FormEditorClosing');
        {$ENDIF Debug}
          FormEditorNotify(FormEditor, fetClosing);
          for J := 0 to FFormEditorIntfs.Count - 1 do
            if TCnFormEditorNotifier(FFormEditorIntfs[J]).FormEditor =
              FormEditor then
            begin
            {$IFDEF Debug}
              CnDebugger.LogMsg('Remove FormEditorNotifier in FileNotification');
            {$ENDIF Debug}
              TCnFormEditorNotifier(FFormEditorIntfs[J]).ClosingNotified := True;
              Break;
            end;
        end;
    end;
  end;
end;

//------------------------------------------------------------------------------
// ActiveControl��ActiveForm ֪ͨ
//------------------------------------------------------------------------------

procedure TCnWizNotifierServices.AddActiveControlNotifier(
  Notifier: TNotifyEvent);
begin
  AddNotifier(FActiveControlNotifiers, TMethod(Notifier));
end;

procedure TCnWizNotifierServices.AddActiveFormNotifier(
  Notifier: TNotifyEvent);
begin
  AddNotifier(FActiveFormNotifiers, TMethod(Notifier));
end;

procedure TCnWizNotifierServices.RemoveActiveControlNotifier(
  Notifier: TNotifyEvent);
begin
  RemoveNotifier(FActiveControlNotifiers, TMethod(Notifier));
end;

procedure TCnWizNotifierServices.RemoveActiveFormNotifier(
  Notifier: TNotifyEvent);
begin
  RemoveNotifier(FActiveFormNotifiers, TMethod(Notifier));
end;

procedure TCnWizNotifierServices.CheckActiveControl;
begin
  if Screen.ActiveControl <> FLastControl then
  begin
    DoActiveControlChange;
    FLastControl := Screen.ActiveControl;
  end;

  if Screen.ActiveForm <> FLastForm then
  begin
    DoActiveFormChange;
    FLastForm := Screen.ActiveForm;
  end;
end;

procedure TCnWizNotifierServices.DoActiveControlChange;
var
  I: Integer;
begin
  if not IdeClosing and (FActiveControlNotifiers <> nil) then
  begin
    for I := FActiveControlNotifiers.Count - 1 downto 0 do
    try
      with PCnWizNotifierRecord(FActiveControlNotifiers[I])^ do
        TNotifyEvent(Notifier)(Screen.ActiveControl);
    except
      DoHandleException('TCnWizNotifierServices.DoActiveControlChange[' + IntToStr(I) + ']');
    end;
  end;
end;

procedure TCnWizNotifierServices.DoActiveFormChange;
var
  I: Integer;
begin
  // ���ڴ��� View as Text �ٴ򿪺�ԭ֪ͨ����û���ˣ�����ÿ������ڴ����Ծʱ
  // ����Ƿ����µ� FormEditor ���֡�
  if Assigned(Screen.ActiveCustomForm) and (csDesigning in
    Screen.ActiveCustomForm.ComponentState) then
    CheckNewFormEditor;

  if not IdeClosing and (FActiveFormNotifiers <> nil) then
  begin
    for I := FActiveFormNotifiers.Count - 1 downto 0 do
    try
      with PCnWizNotifierRecord(FActiveFormNotifiers[I])^ do
        TNotifyEvent(Notifier)(Screen.ActiveForm);
    except
      DoHandleException('TCnWizNotifierServices.DoActiveFormChange[' + IntToStr(I) + ']');
    end;
  end;
end;

//------------------------------------------------------------------------------
// Application Events ֪ͨ
//------------------------------------------------------------------------------

procedure TCnWizNotifierServices.AddApplicationIdleNotifier(
  Notifier: TNotifyEvent);
begin
  AddNotifier(FApplicationIdleNotifiers, TMethod(Notifier));
end;

procedure TCnWizNotifierServices.RemoveApplicationIdleNotifier(
  Notifier: TNotifyEvent);
begin
  RemoveNotifier(FApplicationIdleNotifiers, TMethod(Notifier));
end;

procedure TCnWizNotifierServices.AddApplicationMessageNotifier(
  Notifier: TMessageEvent);
begin
  AddNotifier(FApplicationMessageNotifiers, TMethod(Notifier));
end;

procedure TCnWizNotifierServices.RemoveApplicationMessageNotifier(
  Notifier: TMessageEvent);
begin
  RemoveNotifier(FApplicationMessageNotifiers, TMethod(Notifier));
end;

procedure TCnWizNotifierServices.AddAppEventNotifier(
  Notifier: TCnWizAppEventNotifier);
begin
  AddNotifier(FAppEventNotifiers, TMethod(Notifier));
end;

procedure TCnWizNotifierServices.RemoveAppEventNotifier(
  Notifier: TCnWizAppEventNotifier);
begin
  RemoveNotifier(FAppEventNotifiers, TMethod(Notifier));
end;

procedure TCnWizNotifierServices.DoIdleNotifiers;
var
  I: Integer;
begin
  if FIdleExecuting then Exit;
  FIdleExecuting := True;
  try
    if not IdeClosing and (FApplicationIdleNotifiers <> nil) then
    begin
      for I := FApplicationIdleNotifiers.Count - 1 downto 0 do
      try
        with PCnWizNotifierRecord(FApplicationIdleNotifiers[I])^ do
          TNotifyEvent(Notifier)(Self);
      except
        DoHandleException('TCnWizNotifierServices.DoApplicationIdle[' + IntToStr(I) + ']');
      end;
    end;
  finally
    FIdleExecuting := False;
  end;
end;

procedure TCnWizNotifierServices.DoApplicationIdle(Sender: TObject;
  var Done: Boolean);
begin
  CheckCompNotifyObj;
  
  DoIdleExecute;

  if Abs(GetTickCount - FLastIdleTick) > csIdleMinInterval then
  begin
    FLastIdleTick := GetTickCount;
    DoIdleNotifiers;
  end;
end;

procedure TCnWizNotifierServices.DoApplicationMessage(var Msg: TMsg;
  var Handled: Boolean);
var
  I: Integer;
begin
  CheckActiveControl;

  // FEvents.OnActivate �п��ܱ����������滻���ˣ��ڴ˴����д���
  if Msg.hwnd = Application.Handle then
  begin
    if Msg.message = CM_ACTIVATE then
      DoApplicationActivate(nil)
    else if Msg.message = CM_DEACTIVATE then
      DoApplicationDeactivate(nil);
  end;

  if not IdeClosing and (FApplicationMessageNotifiers <> nil) then
  begin
    for I := FApplicationMessageNotifiers.Count - 1 downto 0 do
    try
      with PCnWizNotifierRecord(FApplicationMessageNotifiers[I])^ do
        TMessageEvent(Notifier)(Msg, Handled);
      if Handled then
        Break;
    except
      DoHandleException('TCnWizNotifierServices.DoApplicationMessage[' + IntToStr(I) + ']');
    end;
  end;
end;

procedure TCnWizNotifierServices.AppEventNotify(
  EventType: TCnWizAppEventType);
var
  I: Integer;
begin
{$IFDEF DEBUG}
  if EventType <> aeHint then
    CnDebugger.LogFmt('AppEventNotify: %s',
      [GetEnumName(TypeInfo(TCnWizAppEventType), Ord(EventType))]);
{$ENDIF}
  if not IdeClosing and (FAppEventNotifiers <> nil) then
  begin
    for I := FAppEventNotifiers.Count - 1 downto 0 do
    try
      with PCnWizNotifierRecord(FAppEventNotifiers[I])^ do
        TCnWizAppEventNotifier(Notifier)(EventType);
    except
      DoHandleException('TCnWizNotifierServices.AppEventNotify[' + IntToStr(I) + ']');
    end;
  end;
end;

procedure TCnWizNotifierServices.DoApplicationActivate(Sender: TObject);
begin
  AppEventNotify(aeActivate);
end;

procedure TCnWizNotifierServices.DoApplicationDeactivate(Sender: TObject);
begin
  AppEventNotify(aeDeactivate);
end;

procedure TCnWizNotifierServices.DoApplicationHint(Sender: TObject);
begin
  AppEventNotify(aeHint);
end;

procedure TCnWizNotifierServices.DoApplicationMinimize(Sender: TObject);
begin
  AppEventNotify(aeMinimize);
end;

procedure TCnWizNotifierServices.DoApplicationRestore(Sender: TObject);
begin
  AppEventNotify(aeRestore);
end;

//------------------------------------------------------------------------------
// ����ִ��
//------------------------------------------------------------------------------

procedure TCnWizNotifierServices.ExecuteOnApplicationIdle(
  Method: TNotifyEvent);
begin
  AddNotifier(FIdleMethods, TMethod(Method));
end;

procedure TCnWizNotifierServices.StopExecuteOnApplicationIdle(Method: TNotifyEvent);
begin
  RemoveNotifier(FIdleMethods, TMethod(Method));
end;

procedure TCnWizNotifierServices.DoIdleExecute;
var
  Rec: PCnWizNotifierRecord;
  Event: TNotifyEvent;
begin
  while FIdleMethods.Count > 0 do
  begin
    Rec := FIdleMethods.Extract(FIdleMethods.Last);
    Event := TNotifyEvent(Rec^.Notifier);
    Dispose(Rec);
    try
      Event(Application);
    except
      DoHandleException('TCnWizNotifierServices.DoIdleExecute');
    end;
  end;
end;

//------------------------------------------------------------------------------
// HOOK ֪ͨ
//------------------------------------------------------------------------------

procedure TCnWizNotifierServices.DoMsgHook(AList, MsgList: TList; hwnd: HWND;
  Msg: TMessage);
var
  I: Integer;
  Control: TWinControl;

  function IsMsgRegistered: Boolean;
  var
    I: Integer;
  begin
    Result := False;
    for I := 0 to MsgList.Count - 1 do
      if Msg.Msg = Cardinal(MsgList[I]) then
      begin
        Result := True;
        Exit;
      end;
  end;
begin
  if not IdeClosing and (AList <> nil) and IsMsgRegistered then
  begin
    Control := FindControl(hwnd);
    for I := AList.Count - 1 downto 0 do
    try
      with PCnWizNotifierRecord(AList[I])^ do
        TCnWizMsgHookNotifier(Notifier)(hwnd, Control, Msg);
    except
      DoHandleException('TCnWizNotifierServices.DoMsgHook[' + IntToStr(I) + ']');
    end;
  end;
end;

procedure TCnWizNotifierServices.AddCallWndProcNotifier(
  Notifier: TCnWizMsgHookNotifier; MsgIDs: array of Cardinal);
begin
  AddNotifierEx(FCallWndProcNotifiers, FCallWndProcMsgList, TMethod(Notifier), MsgIDs);
end;

procedure TCnWizNotifierServices.RemoveCallWndProcNotifier(
  Notifier: TCnWizMsgHookNotifier);
begin
  RemoveNotifier(FCallWndProcNotifiers, TMethod(Notifier));
end;

procedure TCnWizNotifierServices.DoCallWndProc(hwnd: HWND; Msg: TMessage);
begin
  DoMsgHook(FCallWndProcNotifiers, FCallWndProcMsgList, hwnd, Msg);
end;

procedure TCnWizNotifierServices.AddCallWndProcRetNotifier(
  Notifier: TCnWizMsgHookNotifier; MsgIDs: array of Cardinal);
begin
  AddNotifierEx(FCallWndProcRetNotifiers, FCallWndProcRetMsgList, TMethod(Notifier), MsgIDs);
end;

procedure TCnWizNotifierServices.RemoveCallWndProcRetNotifier(
  Notifier: TCnWizMsgHookNotifier);
begin
  RemoveNotifier(FCallWndProcRetNotifiers, TMethod(Notifier));
end;

procedure TCnWizNotifierServices.DoCallWndProcRet(hwnd: HWND;
  Msg: TMessage);
begin
  DoMsgHook(FCallWndProcRetNotifiers, FCallWndProcRetMsgList, hwnd, Msg);
end;

procedure TCnWizNotifierServices.AddGetMsgNotifier(
  Notifier: TCnWizMsgHookNotifier; MsgIDs: array of Cardinal);
begin
  AddNotifierEx(FGetMsgNotifiers, FGetMsgMsgList, TMethod(Notifier), MsgIDs);
end;

procedure TCnWizNotifierServices.RemoveGetMsgNotifier(
  Notifier: TCnWizMsgHookNotifier);
begin
  RemoveNotifier(FGetMsgNotifiers, TMethod(Notifier));
end;

procedure TCnWizNotifierServices.DoGetMsg(hwnd: HWND; Msg: TMessage);
begin
  DoMsgHook(FGetMsgNotifiers, FGetMsgMsgList, hwnd, Msg);
end;

procedure TCnWizNotifierServices.BreakpointAdded(
  Breakpoint: IOTABreakpoint);
var
  I: Integer;
begin
  if FBreakpointAddedNotifiers <> nil then
  begin
{$IFDEF Debug}
  CnDebugger.LogMsg('TCnWizDebuggerNotifier.Breakpoint Added');
{$ENDIF Debug}
    for I := FBreakpointAddedNotifiers.Count - 1 downto 0 do
    try
      with PCnWizNotifierRecord(FBreakpointAddedNotifiers[I])^ do
        TCnWizBreakpointNotifier(Notifier)(Breakpoint);
    except
      DoHandleException('TCnWizNotifierServices.BreakpointAdded[' + IntToStr(I) + ']');
    end;
  end;
end;

procedure TCnWizNotifierServices.BreakpointDeleted(
  Breakpoint: IOTABreakpoint);
var
  I: Integer;
begin
  if FBreakpointDeletedNotifiers <> nil then
  begin
{$IFDEF Debug}
  CnDebugger.LogMsg('TCnWizDebuggerNotifier.Breakpoint Deleted');
{$ENDIF Debug}
    for I := FBreakpointDeletedNotifiers.Count - 1 downto 0 do
    try
      with PCnWizNotifierRecord(FBreakpointDeletedNotifiers[I])^ do
        TCnWizBreakpointNotifier(Notifier)(Breakpoint);
    except
      DoHandleException('TCnWizNotifierServices.BreakpointDeleted[' + IntToStr(I) + ']');
    end;
  end;
end;

procedure TCnWizNotifierServices.ProcessCreated(Process: IOTAProcess);
var
  I: Integer;
begin
  if FProcessCreatedNotifiers <> nil then
  begin
{$IFDEF Debug}
  CnDebugger.LogMsg('TCnWizDebuggerNotifier.Process Created');
{$ENDIF Debug}
    for I := FProcessCreatedNotifiers.Count - 1 downto 0 do
    try
      with PCnWizNotifierRecord(FProcessCreatedNotifiers[I])^ do
        TCnWizProcessNotifier(Notifier)(Process);
    except
      DoHandleException('TCnWizNotifierServices.ProcessCreated[' + IntToStr(I) + ']');
    end;
  end;
end;

procedure TCnWizNotifierServices.ProcessDestroyed(Process: IOTAProcess);
var
  I: Integer;
begin
  if FProcessDestroyedNotifiers <> nil then
  begin
{$IFDEF Debug}
  CnDebugger.LogMsg('TCnWizDebuggerNotifier.Process Destroyed');
{$ENDIF Debug}
    for I := FProcessDestroyedNotifiers.Count - 1 downto 0 do
    try
      with PCnWizNotifierRecord(FProcessDestroyedNotifiers[I])^ do
        TCnWizProcessNotifier(Notifier)(Process);
    except
      DoHandleException('TCnWizNotifierServices.ProcessDestroyed[' + IntToStr(I) + ']');
    end;
  end;
end;

procedure TCnWizNotifierServices.AddBreakpointAddedNotifier(
  Notifier: TCnWizBreakpointNotifier);
begin
  AddNotifier(FBreakpointAddedNotifiers, TMethod(Notifier));
end;

procedure TCnWizNotifierServices.AddBreakpointDeletedNotifier(
  Notifier: TCnWizBreakpointNotifier);
begin
  AddNotifier(FBreakpointDeletedNotifiers, TMethod(Notifier));
end;

procedure TCnWizNotifierServices.AddProcessCreatedNotifier(
  Notifier: TCnWizProcessNotifier);
begin
  AddNotifier(FProcessCreatedNotifiers, TMethod(Notifier));
end;

procedure TCnWizNotifierServices.AddProcessDestroyedNotifier(
  Notifier: TCnWizProcessNotifier);
begin
  AddNotifier(FProcessDestroyedNotifiers, TMethod(Notifier));
end;

procedure TCnWizNotifierServices.RemoveBreakpointAddedNotifier(
  Notifier: TCnWizBreakpointNotifier);
begin
  RemoveNotifier(FBreakpointAddedNotifiers, TMethod(Notifier));
end;

procedure TCnWizNotifierServices.RemoveBreakpointDeletedNotifier(
  Notifier: TCnWizBreakpointNotifier);
begin
  RemoveNotifier(FBreakpointDeletedNotifiers, TMethod(Notifier));
end;

procedure TCnWizNotifierServices.RemoveProcessCreatedNotifier(
  Notifier: TCnWizProcessNotifier);
begin
  RemoveNotifier(FProcessCreatedNotifiers, TMethod(Notifier));
end;

procedure TCnWizNotifierServices.RemoveProcessDestroyedNotifier(
  Notifier: TCnWizProcessNotifier);
begin
  RemoveNotifier(FProcessDestroyedNotifiers, TMethod(Notifier));
end;

{ TCnWizDebuggerNotifier }

constructor TCnWizDebuggerNotifier.Create(ANotifierServices: TCnWizNotifierServices);
begin
  inherited Create;
  FNotifierServices := ANotifierServices;
{$IFDEF Debug}
  CnDebugger.LogMsg('TCnWizDebuggerNotifier.Create succeed');
{$ENDIF Debug}
end;

destructor TCnWizDebuggerNotifier.Destroy;
begin

  inherited;
end;

procedure TCnWizDebuggerNotifier.BreakpointAdded({$IFDEF COMPILER9_UP}const {$ENDIF}Breakpoint: IOTABreakpoint);
begin
  FNotifierServices.BreakpointAdded(Breakpoint);
end;

procedure TCnWizDebuggerNotifier.BreakpointDeleted({$IFDEF COMPILER9_UP}const {$ENDIF}Breakpoint: IOTABreakpoint);
begin
  FNotifierServices.BreakpointDeleted(Breakpoint);
end;

procedure TCnWizDebuggerNotifier.ProcessCreated({$IFDEF COMPILER9_UP}const {$ENDIF}Process: IOTAProcess);
begin
  FNotifierServices.ProcessCreated(Process);
end;

procedure TCnWizDebuggerNotifier.ProcessDestroyed({$IFDEF COMPILER9_UP}const {$ENDIF}Process: IOTAProcess);
begin
  FNotifierServices.ProcessDestroyed(Process);
end;

initialization

finalization
{$IFDEF Debug}
  CnDebugger.LogEnter('CnWizNotifier finalization.');
{$ENDIF Debug}

  FreeCnWizNotifierServices;

{$IFDEF Debug}
  CnDebugger.LogLeave('CnWizNotifier finalization.');
{$ENDIF Debug}
end.

