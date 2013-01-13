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

unit CnGetThread;
{ |<PRE>
================================================================================
* ������ƣ�CnDebugViewer
* ��Ԫ���ƣ���ȡ�̵߳�Ԫ
* ��Ԫ���ߣ���Х��LiuXiao�� liuxiao@cnpack.org
* ��    ע��
* ����ƽ̨��PWin2000Pro + Delphi 5.01
* ���ݲ��ԣ�PWin9X/2000/XP + Delphi 5/6/7
* �� �� �����õ�Ԫ�е��ַ���֧�ֱ��ػ�����ʽ
* ��Ԫ��ʶ��$Id: CnGetThread.pas 763 2011-02-07 14:18:23Z liuxiao@cnpack.org $
* �޸ļ�¼��2006.10.15
*               �����ȡ OutputDebugString ���ݵĹ���
*           2005.01.01
*               ������Ԫ��ʵ�ֹ���
================================================================================
|</PRE>}

interface

uses
  Classes, SysUtils, Windows, Forms, Contnrs,
  CnViewCore, CnDebugIntf, CnMsgClasses;

type
  TGetDebugThread = class(TThread)
  {* ��ȡ CnDebugger ���ݵ��߳�}
  private
    FPaused: Boolean;
  protected
    procedure AddADescToStore(var ADesc: TCnMsgDesc);
    procedure Execute; override;
  public
    property Paused: Boolean read FPaused write FPaused;
  end;

  TDbgGetDebugThread = class(TGetDebugThread)
  {* ��ȡ OutputDebugString ���ݵ��߳�}
  protected
    procedure Execute; override;
  end;

implementation

uses
  CnMdiView;

{ GetDebug }

procedure TGetDebugThread.AddADescToStore(var ADesc: TCnMsgDesc);
var
  AStore: TCnMsgStore;
  StoreInited: Boolean;
begin
  AStore := CnMsgManager.IndexOf(ADesc.Annex.ProcessId);
  StoreInited := False;
  if AStore = nil then
  begin
    AStore := CnMsgManager.IndexOf(0);
    if AStore = nil then
    begin
      if Application.MainForm <> nil then
        if not (csDestroying in Application.MainForm.ComponentState) then
        begin
          AStore := CnMsgManager.AddStore(0, SCnNoneProcName);
          AStore.ProcessID := ADesc.Annex.ProcessId;
          AStore.ProcName := GetProcNameFromProcessID(AStore.ProcessID);
          PostMessage(Application.MainForm.Handle, WM_USER_NEW_FORM, Integer(AStore), 0);
        end;
    end;

    if not StoreInited and (AStore <> nil) then
    begin
      AStore.ProcessID := ADesc.Annex.ProcessId;
      AStore.ProcName := GetProcNameFromProcessID(AStore.ProcessID);
    end;
  end;

  // ���޿���Ļ��Ӧ�� Store�������
  if AStore <> nil then
  begin
    // ���������ʱ�ȿ�ʼ������ȡ���ȴ����ݶ���ʱ�ٸ��½���
    AStore.BeginUpdate;
    AStore.AddMsgDesc(@ADesc);
  end;
end;

procedure TGetDebugThread.Execute;
var
  Len, RestLen, QueueSize: Integer;
  Desc: PCnMsgDesc;
  ADesc: TCnMsgDesc;
  Front, Tail: Integer;
  Res: DWORD;
begin
  PostStartEvent;
  QueueSize := CnMapSize - CnHeadSize;
  if HMutex = 0 then
    HMutex := CreateMutex(nil, False, SCnDebugQueueMutexName);

  while not Terminated do
  begin
    Res := WaitForSingleObject(HEvent, CnWaitEventTime);
    if Res = WAIT_FAILED then // ��ʹ��ʱҲ���ж�һ�¶���״̬
    begin
      Sleep(0);
      Continue;
    end;

    if PHeader^.QueueFront = PHeader^.QueueTail then
    begin
      // ���пգ��ɿ�ʼ���½���
      if (Application.MainForm <> nil) and not (csDestroying in Application.MainForm.ComponentState) then
        PostMessage(Application.MainForm.Handle, WM_USER_UPDATE_STORE, 0, 0);
      Sleep(0);
      Continue;
    end;

    Res := WaitForSingleObject(HMutex, CnWaitMutexTime);
    if (Res = WAIT_FAILED) or (Res = WAIT_TIMEOUT) then
    begin
      //Sleep(0);
      Continue;
    end;

    Front := PHeader^.QueueFront;
    Tail := PHeader^.QueueTail;
    if Front = Tail then
    begin
      if Terminated then
      begin
        CloseHandle(HMutex);
        HMutex := 0;
        Exit;
      end;
      ReleaseMutex(HMutex);
      Continue;
    end;

    Desc := PCnMsgDesc(Front + PHeader^.DataOffset + Integer(PBase));
    if not Paused then
    begin
      FillChar(ADesc, SizeOf(ADesc), 0);
      Len := Desc^.Length;

      if Len = 0 then // ���ⷢ�Ͷ˳�������ѭ��
      begin
        PHeader^.QueueFront := 0;
        PHeader^.QueueTail := 0;
        if Terminated then
        begin
          CloseHandle(HMutex);
          HMutex := 0;
          Exit;
        end;
        ReleaseMutex(HMutex);
        Continue;
      end;
      
      if Front + Len < QueueSize then
        CopyMemory(@ADesc, Desc ,Len)
      else
      begin
        RestLen := QueueSize - Front;
        CopyMemory(@ADesc, Desc ,RestLen);
        CopyMemory(Pointer(Integer(@ADesc) + RestLen), Pointer(PHeader^.DataOffset + Integer(PBase)), Len - RestLen);
      end;

      EnterCriticalSection(CSMsgStore);
      try
        AddADescToStore(ADesc);
      finally
        LeaveCriticalSection(CSMsgStore);
      end;
    end; // ��ͣʱ���ָ��Ȼ���ָ�룬��ȡ������

    Inc(PHeader^.QueueFront, Desc^.Length);
    if PHeader^.QueueFront >= QueueSize then
      PHeader^.QueueFront := PHeader^.QueueFront mod QueueSize;

    if Terminated then
    begin
      CloseHandle(HMutex);
      HMutex := 0;
      Exit;
    end;
    ReleaseMutex(HMutex);
    if HFlush = 0 then
      HFlush := OpenEvent(EVENT_MODIFY_STATE, False, SCnDebugFlushEventName);
    if HFlush <> 0 then
      SetEvent(hFlush);
  end;
end;

{ TDbgGetDebugThread }

procedure TDbgGetDebugThread.Execute;
var
  Res: DWORD;
  ADesc: TCnMsgDesc;
  PPid: PDWORD;
  PStr: PChar;
  Len: Integer;
begin
  if not SysDebugReady then
    InitSysDebug;

  while not Terminated do
  begin
    if not SysDebugReady then
    begin
      Sleep(0);
      Continue;
    end;

    if not SetEvent(HSysBufferReady) then
    begin
      Sleep(0);
      Continue;
    end;

    Res := WaitForSingleObject(HSysDataReady, CnWaitEventTime);
    if Res <> WAIT_OBJECT_0 then
    begin
      Sleep(0);
      Continue;
    end;

    if Paused then
    begin
      Sleep(0);
      Continue;
    end;

    FillChar(ADesc, SizeOf(ADesc), 0);
    PPid := PDWORD(PSysDbgBase);
    PStr := PChar(Integer(PSysDbgBase) + SizeOf(DWORD));

    ADesc.Annex.ProcessId := PPid^;
    
    // OutputDebugString �޶�Ӧ��Ϣ�������Ҫ�ֹ���д
    ADesc.Annex.Level := CnDefLevel;
    ADesc.Annex.MsgType := Ord(cmtSystem);
    // �� ThreadId���� Tag

    // �޷��Ͷ�ʱ��������Ʋ��ý��ն�ʱ���
    ADesc.Annex.TimeStampType := Ord(ttDateTime);
    ADesc.Annex.MsgDateTime := Date + Time;
    Len := StrLen(PStr);
    if Len >= DbWinBufferSize - SizeOf(DWORD) then
      Len := DbWinBufferSize - SizeOf(DWORD);
    CopyMemory(@(ADesc.Msg[0]), PStr, Len);
    ADesc.Length := Len + SizeOf(TCnMsgAnnex) + SizeOf(Integer) + 1;

    EnterCriticalSection(CSMsgStore);
    try
      AddADescToStore(ADesc);
    finally
      LeaveCriticalSection(CSMsgStore);
    end;

    // ���½���
    if (Application.MainForm <> nil) and not (csDestroying in Application.MainForm.ComponentState) then
      PostMessage(Application.MainForm.Handle, WM_USER_UPDATE_STORE, 0, 0);
  end;
end;

end.
