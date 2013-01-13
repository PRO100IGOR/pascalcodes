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

unit CnWizControlHook;
{* |<PRE>
================================================================================
* ������ƣ�CnPack IDE ר�Ұ�
* ��Ԫ���ƣ�IDE ��ƿؼ���Ϣ������̹ҽӵ�Ԫ
* ��Ԫ���ߣ��ܾ��� (zjy@cnpack.org)
* ��    ע���õ�Ԫ�ṩ�� IDE ������ڿؼ���Ϣ�ҽӷ���
* ����ƽ̨��PWin2000Pro + Delphi 5.0
* ���ݲ��ԣ�PWin9X/2000/XP + Delphi 5/6
* �� �� �����õ�Ԫ�е��ַ��������ϱ��ػ�����ʽ
* ��Ԫ��ʶ��$Id: CnWizControlHook.pas 763 2011-02-07 14:18:23Z liuxiao@cnpack.org $
* �޸ļ�¼��2003.05.04 V1.2
*               ʹ�� CnWizNotifier ������ķ������ҽӿؼ���ȥ���� Listener �ӿڣ�
*               ���� Message Notifier �Լ򻯱�̡�
*           2003.04.28 V1.1
*               �����ؼ�����Ϣ����������ͷŵ��¹ҽӶ�����������
*           2002.11.22 V1.0
*               ������Ԫ
================================================================================
|</PRE>}

interface

{$I CnWizards.inc}

// ��Ϊ������������ؼ���ͻ������ȡ�������Ԫ�ˣ���ʱ�ȱ����ű���

{$IFNDEF USE_CONTROLHOOK}
implementation
{$ELSE}

uses
  Windows, Messages, SysUtils, Classes, Controls, Forms, ToolsAPI,
  {$IFDEF COMPILER6_UP}
  DesignIntf,
  {$ELSE}
  DsgnIntf,
  {$ENDIF}
  CnWizNotifier;

type

  TCnWizMessageNotifier = procedure (Control: TControl;
    var Msg: TMessage; var Handled: Boolean) of object;

  ICnWizControlServices = interface(IUnknown)
  {* �ýӿ��ṩ������ڿؼ���Ϣ�ҽӷ���ͨ��ע����Ϣ֪ͨ�����Ϳ��Ի�� IDE ��
     ��������ڿؼ�����Ϣ֪ͨ�����������ṩ������ڴ��弰������������������
     ���·����Ϊ���ࣺ����ڿؼ�����ƶ��󣨴��塢Frame��DataModule ��ע���
     ����������������ƶ������������������ Frame ���������ڵȣ������ƶ�
     ���Ǵ�������������ƴ����Ч��}
    ['{416BB0D2-02EA-40A9-AA50-BBC81771E0AC}']
    function GetControlCount: Integer;
    function GetControls(Index: Integer): TControl;

    function GetDesignRootCount: Integer;
    function GetDesignRoots(Index: Integer): TComponent;
    function GetCurrentDesignRoot: TComponent;

    function GetDesignContainerCount: Integer;
    function GetDesignContainers(Index: Integer): TWinControl;
    function GetCurrentDesignContainer: TWinControl;

    function IndexOfControl(Control: TControl): Integer;
    {* ����ָ���ؼ����б��е�������}
    
    function IndexOfDesignRoot(DesignRoot: TComponent): Integer;
    {* ����ָ����ƶ������б��е�������}
    function IsDesignRoot(Component: TComponent): Boolean;
    {* ����ָ������Ƿ�����ƶ���Form��Frame��Data Module�ȣ�}

    function IndexOfDesignContainer(DesignContainer: TWinControl): Integer;
    {* ����ָ����ƶ����������б��е�������}
    function IsDesignContainer(DesignContainer: TWinControl): Boolean;
    {* ����ָ������Ƿ�����ƶ�������}

    procedure AddBeforeMessageNotifier(Notifier: TCnWizMessageNotifier);
    {* ����һ���ؼ�ǰ��Ϣ֪ͨ��}
    procedure RemoveBeforeMessageNotifier(Notifier: TCnWizMessageNotifier);
    {* ɾ��һ���ؼ�ǰ��Ϣ֪ͨ��}
    procedure AddAfterMessageNotifier(Notifier: TCnWizMessageNotifier);
    {* ����һ���ؼ�����Ϣ֪ͨ��}
    procedure RemoveAfterMessageNotifier(Notifier: TCnWizMessageNotifier);
    {* ɾ��һ���ؼ�����Ϣ֪ͨ��}

    property ControlCount: Integer read GetControlCount;
    {* ��ǰ�ѹҽӵĿؼ�����}
    property Controls[Index: Integer]: TControl read GetControls;
    {* ��ǰ�ѹҽӵĿؼ��б�}
    
    property DesignRootCount: Integer read GetDesignRootCount;
    {* ��ǰ��Ч�Ĵ��塢Frame��Data Module ������ע��ĵ�����ģ������}
    property DesignRoots[Index: Integer]: TComponent read GetDesignRoots;
    {* ��ǰ��Ч�Ĵ��塢Frame��Data Module ������ע��ĵ�����ģ���б�}
    property CurrentDesignRoot: TComponent read GetCurrentDesignRoot;
    {* ��ǰ������ƵĴ��塢Frame��Data Module ������ע��ĵ�����ģ��}

    property DesignContainerCount: Integer read GetDesignContainerCount;
    {* ��ǰ��Ч����ƶ����������������}
    property DesignContainers[Index: Integer]: TWinControl read GetDesignContainers;
    {* ��ǰ��Ч����ƶ�������������б�}
    property CurrentDesignContainer: TWinControl read GetCurrentDesignContainer;
    {* ��ǰ������ƶ������������}
  end;

function CnWizControlServices: ICnWizControlServices;

implementation

uses
{$IFDEF Debug}
  CnDebug,
{$ENDIF Debug}
  CnWizUtils;

type

  PCnWizNotifierRecord = ^TCnWizNotifierRecord;
  TCnWizNotifierRecord = record
    Notifier: TMethod;
  end;

  TControlHack = class(TControl);

//==============================================================================
// �ؼ���Ϣ������̹ҽӶ���˽���ࣩ
//==============================================================================

{ TCnWizHookObject }

  TCnWizControlServices = class;

  TCnWizHookObject = class
  private
    FControlServices: TCnWizControlServices;
    FControl: TControl;
    FOldWndProc: TWndMethod;
    FUpdateCount: Integer;
    FAutoFree: Boolean;
  protected
    procedure WndProc(var Message: TMessage);
    property Control: TControl read FControl;
    property ControlServices: TCnWizControlServices read FControlServices;
  public
    constructor Create(AControlServices: TCnWizControlServices; AControl: TControl);
    destructor Destroy; override;
    procedure DoFree;
    function Updating: Boolean;
  end;

//==============================================================================
// �ؼ���Ϣ������̹ҽӷ����ࣨ˽���ࣩ
//==============================================================================

{ TCnWizControlServices }

  TCnWizControlServices = class(TComponent, IUnknown, ICnWizControlServices)
  private
    FHookObjs: TList;
    FDesignRoots: TList;
    FDesignContainers: TList;
    FBeforeNotifiers: TList;
    FAfterNotifiers: TList;
    NotifierServices: ICnWizNotifierServices;
    procedure FormNotify(FormEditor: IOTAFormEditor;
      NotifyType: TCnWizFormEditorNotifyType; ComponentHandle: TOTAHandle;
      Component: TComponent; const OldName, NewName: string);
    procedure GetChildProc(Child: TComponent);
    procedure ClearList(List: TList);
    function IndexOf(List: TList; Notifier: TMethod): Integer;
    procedure AddNotifier(List: TList; Notifier: TMethod);
    procedure RemoveNotifier(List: TList; Notifier: TMethod);
    function GetDesignContainerFromEditor(FormEditor: IOTAFormEditor): TWinControl;
  protected
    // Overriden IUnknown implementations for singleton life-time management
    function _AddRef: Integer; stdcall;
    function _Release: Integer; stdcall;

    // ICnWizControlServices
    function GetControlCount: Integer;
    function GetControls(Index: Integer): TControl;

    function GetDesignRootCount: Integer;
    function GetDesignRoots(Index: Integer): TComponent;
    function GetCurrentDesignRoot: TComponent;

    function GetDesignContainerCount: Integer;
    function GetDesignContainers(Index: Integer): TWinControl;
    function GetCurrentDesignContainer: TWinControl;

    function IndexOfControl(Control: TControl): Integer;

    function IndexOfDesignRoot(DesignRoot: TComponent): Integer;
    function IsDesignRoot(Component: TComponent): Boolean;

    function IndexOfDesignContainer(DesignContainer: TWinControl): Integer;
    function IsDesignContainer(DesignContainer: TWinControl): Boolean;

    procedure AddBeforeMessageNotifier(Notifier: TCnWizMessageNotifier);
    procedure RemoveBeforeMessageNotifier(Notifier: TCnWizMessageNotifier);
    procedure AddAfterMessageNotifier(Notifier: TCnWizMessageNotifier);
    procedure RemoveAfterMessageNotifier(Notifier: TCnWizMessageNotifier);

    // �ҽ���ع���
    procedure Notification(AComponent: TComponent; Operation: TOperation); override;
    procedure HookEditor(Editor: IOTAFormEditor);
    procedure UnhookEditor(Editor: IOTAFormEditor);
    procedure HookControl(Control: TControl; IncludeChild: Boolean = True);
    procedure UnhookControl(Control: TControl); overload;
    procedure UnhookAll;
    procedure HookDesignRoot(DesignRoot: TComponent);

    function DoAfterMessage(Control: TControl; var Msg: TMessage): Boolean; dynamic;
    function DoBeforeMessage(Control: TControl; var Msg: TMessage): Boolean; dynamic;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
  end;

var
  FCnWizControlServices: TCnWizControlServices;

// ���عҽӹ�����
function CnWizControlServices: ICnWizControlServices;
begin
  if not Assigned(FCnWizControlServices) then
    FCnWizControlServices := TCnWizControlServices.Create(nil);
  Result := FCnWizControlServices as ICnWizControlServices;
end;

procedure FreeCnWizControlServices;
begin
  if Assigned(FCnWizControlServices) then
    FreeAndNil(FCnWizControlServices);
end;

//==============================================================================
// �ؼ���Ϣ������̹ҽӶ���˽���ࣩ
//==============================================================================

{ TCnWizHookObject }

// ������
constructor TCnWizHookObject.Create(AControlServices: TCnWizControlServices;
  AControl: TControl);
begin
  inherited Create;
  Assert(Assigned(AControlServices) and Assigned(AControl));
  FControlServices := AControlServices;
  FControl := AControl;
  FOldWndProc := FControl.WindowProc;
  FControl.WindowProc := WndProc;
  FControl.FreeNotification(FControlServices);
  FUpdateCount := 0;
  FAutoFree := False;
{$IFDEF DEBUG}
  CnDebugger.LogFmt('Hook Control: %s: %s (%x, %x)', [AControl.Name, AControl.ClassName,
    Integer(TMethod(FOldWndProc).Code), Integer(TMethod(AControl.WindowProc).Code)]);
{$ENDIF}    
end;

// ������
destructor TCnWizHookObject.Destroy;
begin
  try                                  // �쳣����
    if Assigned(FControl) then
    begin
    {$IFDEF DEBUG}
      CnDebugger.LogFmt('Unhook Control: %s: %s (%x)', [FControl.Name,
        FControl.ClassName, Integer(TMethod(FControl.WindowProc).Code)]);
    {$ENDIF}
      FControl.RemoveFreeNotification(FControlServices);
      FControl.WindowProc := FOldWndProc;
      FControl := nil;
    end;
  except
    DoHandleException('TCnWizHookObject.Destroy');
  end;
  inherited;
end;

// �������� Alt+F12 �ر�ʱ��������� WndProc ������ͷŲ������ʴ�ʱ����һ�����
// �� WndProc ���ͷ�����
procedure TCnWizHookObject.DoFree;
begin
  if Updating then
  begin
  {$IFDEF Debug}
    CnDebugger.LogMsg('Free hook object delay');
  {$ENDIF Debug}
    FAutoFree := True;
    try
    {$IFDEF DEBUG}
      CnDebugger.LogFmt('UnhookEx Control: %s: %s (%x)', [FControl.Name,
        FControl.ClassName, Integer(TMethod(FControl.WindowProc).Code)]);
    {$ENDIF}
      FControl.RemoveFreeNotification(FControlServices);
      FControl.WindowProc := FOldWndProc;
      FControl := nil;
    except
      DoHandleException('TCnWizHookObject.DoFree');
    end;
  end
  else
    Free;
end;

function TCnWizHookObject.Updating: Boolean;
begin
  Result := FUpdateCount > 0;
end;

// �µ���Ϣ�������
procedure TCnWizHookObject.WndProc(var Message: TMessage);
begin
  try
    Inc(FUpdateCount);
    try
      if FControlServices.DoBeforeMessage(FControl, Message) then Exit;
      if Assigned(FOldWndProc) then FOldWndProc(Message);
      // �ڴ�����ԭ��Ϣ�󣬿ؼ������Ѿ����ͷŵ��ˣ��ڴ˴��ж�
      if not FAutoFree then
        FControlServices.DoAfterMessage(FControl, Message);
    finally
      Dec(FUpdateCount);
    end;

    // �˴������ͷ�
    if FAutoFree then
      Free;
  except
    DoHandleException('TCnWizHookObject.WndProc');
  end;
end;

//==============================================================================
// �ؼ���Ϣ������̹ҽ������˽���ࣩ
//==============================================================================

{ TCnWizControlServices }

constructor TCnWizControlServices.Create(AOwner: TComponent);
begin
  inherited;
{$IFDEF Debug}
  CnDebugger.LogEnter('TCnWizControlServices.Create');
{$ENDIF Debug}
  FHookObjs := TList.Create;
  FDesignRoots := TList.Create;
  FDesignContainers := TList.Create;
  FBeforeNotifiers := TList.Create;
  FAfterNotifiers := TList.Create;
  NotifierServices := CnWizNotifierServices;
  NotifierServices.AddFormEditorNotifier(FormNotify);
{$IFDEF Debug}
  CnDebugger.LogLeave('TCnWizControlServices.Create');
{$ENDIF Debug}
end;

destructor TCnWizControlServices.Destroy;
begin
{$IFDEF Debug}
  CnDebugger.LogEnter('TCnWizControlServices.Destroy');
{$ENDIF Debug}
  NotifierServices.RemoveFormEditorNotifier(FormNotify);
  UnhookAll;
  ClearList(FBeforeNotifiers);
  ClearList(FAfterNotifiers);
  FBeforeNotifiers.Free;
  FAfterNotifiers.Free;
  FDesignContainers.Free;
  FDesignRoots.Free;
  FHookObjs.Free;
{$IFDEF Debug}
  CnDebugger.LogLeave('TCnWizControlServices.Destroy');
{$ENDIF Debug}
  inherited;
end;

//------------------------------------------------------------------------------
// �ҽ���ط���
//------------------------------------------------------------------------------

procedure TCnWizControlServices.FormNotify(FormEditor: IOTAFormEditor;
  NotifyType: TCnWizFormEditorNotifyType; ComponentHandle: TOTAHandle;
  Component: TComponent; const OldName, NewName: string);
begin
  case NotifyType of
    fetOpened: HookEditor(FormEditor);
    fetClosing: UnhookEditor(FormEditor);
    fetComponentCreated:
      if Component is TControl then
        HookControl(TControl(Component));
  end;
end;

procedure TCnWizControlServices.HookDesignRoot(DesignRoot: TComponent);
var
  i: Integer;
begin
  if not Assigned(DesignRoot) then Exit;

  // �ҽ������ Root ���
  if DesignRoot is TControl then
    HookControl(TControl(DesignRoot), False);

  // �ҽ��������
  for i := 0 to DesignRoot.ComponentCount - 1 do
    if DesignRoot.Components[i] is TControl then
      HookControl(TControl(DesignRoot.Components[i]));
end;

procedure TCnWizControlServices.Notification(AComponent: TComponent;
  Operation: TOperation);
begin
  if (AComponent is TControl) and (Operation = opRemove) then
    UnhookControl(TControl(AComponent)); // �ؼ��ͷ�ʱ���ҽ�
end;

procedure TCnWizControlServices.GetChildProc(Child: TComponent);
begin
  if Child is TControl then
    HookControl(TControl(Child));
end;

procedure TCnWizControlServices.HookControl(Control: TControl; IncludeChild: Boolean);
var
  Obj: TCnWizHookObject;
begin
  if not Assigned(Control) then Exit;

  if IndexOfControl(Control) < 0 then
  begin
    Obj := TCnWizHookObject.Create(Self, Control);
    FHookObjs.Add(Obj);

    // �������ϵ� TFrame �����Ƶĵ�����ע����
    if IncludeChild then
      TControlHack(Control).GetChildren(GetChildProc, Control);
  end;
end;

procedure TCnWizControlServices.UnhookControl(Control: TControl);
var
  Idx: Integer;
begin
  // ����ؼ��� Hook ֮���ٴα��������� Hook������ Hook �Ĵ�����ܻᱣ��
  // TCnWizHookObject �� WndProc ������ ����ڿؼ��ͷ�ǰ���ͷ��� TCnWizHookObject
  // ��������ܵ��¶��� Hook �Ĵ�����õ���Ч�� TCnWizHookObject ���󣬵����쳣��
  // ���磺TNT ϵ�пؼ��� CnWizards �ĳ�ͻ��
  // ��ֻ���ڿؼ��ͷ�ʱ�Ž��� Unhook���Ա���ǰ������⡣
  if not Assigned(Control) or not (csDestroying in Control.ComponentState) then Exit;

  Idx := IndexOfControl(Control);
  if Idx >= 0 then
  begin
    TCnWizHookObject(FHookObjs[Idx]).DoFree;
    FHookObjs.Delete(Idx);
  end;
end;

procedure TCnWizControlServices.UnhookAll;
begin
  while FHookObjs.Count > 0 do
  begin
    TCnWizHookObject(FHookObjs[0]).DoFree;
    FHookObjs.Delete(0);
  end;
end;

procedure TCnWizControlServices.HookEditor(Editor: IOTAFormEditor);
var
  Component: TComponent;
  Container: TWinControl;
begin
  Component := CnOtaGetRootComponentFromEditor(Editor);
  if Assigned(Component) then
  begin
    FDesignRoots.Add(Component);

    Container := GetDesignContainerFromEditor(Editor);
    if Assigned(Container) then
    begin
      FDesignContainers.Add(Container);
      if Container <> Component then // Component Ϊ TFrame ʱ
        HookControl(Container, False);
    end;

    // ֻ�ҽ�������ƵĴ��塢Frame����ע��ĵ�����ģ�飬������ Data Module
    if Component is TWinControl then
    begin
    {$IFDEF Debug}
      CnDebugger.LogMsg('Hook Editor: ' + Editor.GetFileName);
    {$ENDIF Debug}
      HookDesignRoot(Component);
    end;
  end;
end;

procedure TCnWizControlServices.UnhookEditor(Editor: IOTAFormEditor);
var
  Component: TComponent;
  Container: TWinControl;
begin
  Component := CnOtaGetRootComponentFromEditor(Editor);
  if Assigned(Component) then
  begin
    FDesignRoots.Remove(Component);
    
    Container := GetDesignContainerFromEditor(Editor);
    if Assigned(Container) then
    begin
      FDesignContainers.Remove(Container);
    end;
  end;
end;

//------------------------------------------------------------------------------
// �б����
//------------------------------------------------------------------------------

procedure TCnWizControlServices.AddNotifier(List: TList;
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

procedure TCnWizControlServices.RemoveNotifier(List: TList;
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

procedure TCnWizControlServices.ClearList(List: TList);
var
  Rec: PCnWizNotifierRecord;
begin
  while List.Count > 0 do
  begin
    Rec := List[0];
    Dispose(Rec);
    List.Delete(0);
  end;
end;

function TCnWizControlServices.IndexOf(List: TList;
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

procedure TCnWizControlServices.AddAfterMessageNotifier(
  Notifier: TCnWizMessageNotifier);
begin
  AddNotifier(FAfterNotifiers, TMethod(Notifier));
end;

procedure TCnWizControlServices.RemoveAfterMessageNotifier(
  Notifier: TCnWizMessageNotifier);
begin
  RemoveNotifier(FAfterNotifiers, TMethod(Notifier));
end;

procedure TCnWizControlServices.AddBeforeMessageNotifier(
  Notifier: TCnWizMessageNotifier);
begin
  AddNotifier(FBeforeNotifiers, TMethod(Notifier));
end;

procedure TCnWizControlServices.RemoveBeforeMessageNotifier(
  Notifier: TCnWizMessageNotifier);
begin
  RemoveNotifier(FBeforeNotifiers, TMethod(Notifier));
end;

//------------------------------------------------------------------------------
// ��Ϣ֪ͨ��ط���
//------------------------------------------------------------------------------

function TCnWizControlServices.DoAfterMessage(Control: TControl;
  var Msg: TMessage): Boolean;
var
  i: Integer;
begin
  Result := False;
  for i := 0 to FAfterNotifiers.Count - 1 do
  begin
    try
      with PCnWizNotifierRecord(FAfterNotifiers[i])^ do
        TCnWizMessageNotifier(Notifier)(Control, Msg, Result);
    except
      DoHandleException('TCnWizControlServices.DoAfterMessage[' + IntToStr(i) + ']');
    end;

    if Result then Exit;
  end;
end;

function TCnWizControlServices.DoBeforeMessage(Control: TControl;
  var Msg: TMessage): Boolean;
var
  i: Integer;
begin
  Result := False;
  for i := 0 to FBeforeNotifiers.Count - 1 do
  begin
    try
      with PCnWizNotifierRecord(FBeforeNotifiers[i])^ do
        TCnWizMessageNotifier(Notifier)(Control, Msg, Result);
    except
      DoHandleException('TCnWizControlServices.DoBeforeMessage[' + IntToStr(i) + ']');
    end;

    if Result then Exit;
  end;
end;

//------------------------------------------------------------------------------
// ��������
//------------------------------------------------------------------------------

function TCnWizControlServices._AddRef: Integer;
begin
  Result := 1;
end;

function TCnWizControlServices._Release: Integer;
begin
  Result := 1;
end;

function TCnWizControlServices.GetDesignContainerFromEditor(
  FormEditor: IOTAFormEditor): TWinControl;
var
  Root: TComponent;
begin
  { TODO : ֧��Ϊ Root �� TWinControl ����ƶ���ȡ�� Container }
  Result := nil;
  Root := CnOtaGetRootComponentFromEditor(FormEditor);
  if Root is TWinControl then
  begin
    Result := Root as TWinControl;
    while Assigned(Result) and Assigned(Result.Parent) do
      Result := Result.Parent;
  end;
end;

function TCnWizControlServices.IsDesignRoot(Component: TComponent): Boolean;
begin
  Result := FDesignRoots.IndexOf(Component) >= 0;
end;

function TCnWizControlServices.IsDesignContainer(
  DesignContainer: TWinControl): Boolean;
begin
  Result := FDesignContainers.IndexOf(DesignContainer) >= 0;
end;

function TCnWizControlServices.IndexOfControl(Control: TControl): Integer;
var
  i: Integer;
begin
  Result := -1;
  for i := 0 to GetControlCount - 1 do
    if Control = GetControls(i) then
    begin
      Result := i;
      Exit;
    end;
end;

function TCnWizControlServices.IndexOfDesignRoot(
  DesignRoot: TComponent): Integer;
var
  i: Integer;
begin
  Result := -1;
  for i := 0 to GetDesignRootCount - 1 do
    if DesignRoot = GetDesignRoots(i) then
    begin
      Result := i;
      Exit;
    end;
end;

function TCnWizControlServices.IndexOfDesignContainer(
  DesignContainer: TWinControl): Integer;
var
  i: Integer;
begin
  Result := -1;
  for i := 0 to GetDesignContainerCount - 1 do
    if DesignContainer = GetDesignContainers(i) then
    begin
      Result := i;
      Exit;
    end;
end;

function TCnWizControlServices.GetControlCount: Integer;
begin
  Result := FHookObjs.Count;
end;

function TCnWizControlServices.GetDesignRootCount: Integer;
begin
  Result := FDesignRoots.Count;
end;

function TCnWizControlServices.GetDesignContainerCount: Integer;
begin
  Result := FDesignContainers.Count;
end;

function TCnWizControlServices.GetControls(Index: Integer): TControl;
begin
  Result := TCnWizHookObject(FHookObjs[Index]).Control;
end;

function TCnWizControlServices.GetDesignRoots(Index: Integer): TComponent;
begin
  Result := TComponent(FDesignRoots[Index]);
end;

function TCnWizControlServices.GetDesignContainers(
  Index: Integer): TWinControl;
begin
   Result := TWinControl(FDesignContainers[Index]);
end;

function TCnWizControlServices.GetCurrentDesignRoot: TComponent;
begin
  Result := CnOtaGetRootComponentFromEditor(CnOtaGetCurrentFormEditor);
end;

function TCnWizControlServices.GetCurrentDesignContainer: TWinControl;
begin
  if CurrentIsForm then
    Result := GetDesignContainerFromEditor(CnOtaGetCurrentFormEditor)
  else
    Result := nil;
end;

initialization

finalization
{$IFDEF Debug}
  CnDebugger.LogEnter('CnWizControlHook finalization.');
{$ENDIF Debug}

  FreeCnWizControlServices;

{$IFDEF Debug}
  CnDebugger.LogLeave('CnWizControlHook finalization.');
{$ENDIF Debug}

{$ENDIF USE_CONTROLHOOK}
end.

