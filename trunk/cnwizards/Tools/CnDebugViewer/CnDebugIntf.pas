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

unit CnDebugIntf;
{ |<PRE>
================================================================================
* ������ƣ�CnDebugViewer
* ��Ԫ���ƣ�CnDebug �ӿڵ�Ԫ
* ��Ԫ���ߣ���Х��LiuXiao�� liuxiao@cnpack.org
* ��    ע��
* ����ƽ̨��PWin2000Pro + Delphi 5.01
* ���ݲ��ԣ�PWin9X/2000/XP + Delphi 5/6/7
* �� �� �����õ�Ԫ�е��ַ���֧�ֱ��ػ�����ʽ
* ��Ԫ��ʶ��$Id: CnDebugIntf.pas 763 2011-02-07 14:18:23Z liuxiao@cnpack.org $
* �޸ļ�¼��2008.07.16
*               ���������������ڿ��ַ���֧��
*           2005.01.01
*               ������Ԫ��ʵ�ֹ���
================================================================================
|</PRE>}

interface

uses
  SysUtils, Classes, Windows;

const
  CnDefLevel = 3;
  CnMaxTagLength = 8; // ���ɸı�
  CnMaxMsgLength = 4096;
  CnDebugMagicLength = 8;
  CnDebugMapEnabled = $7F3D92E0; // ��㶨���һ��ֵ��ʾ MapEnable
  CnDebugMagicName = 'CNDEBUG';
  
  SCnDebugPrefix = 'Global\';
  SCnDebugMapName = SCnDebugPrefix + 'CnDebugMap';
  SCnDebugQueueEventName = SCnDebugPrefix + 'CnDebugQueueEvent';
  SCnDebugQueueMutexName = SCnDebugPrefix + 'CnDebugQueueMutex';
  SCnDebugStartEventName = SCnDebugPrefix + 'CnDebugStartEvent';
  SCnDebugFlushEventName = SCnDebugPrefix + 'CnDebugFlushEvent';

type
  // ===================== ���½ṹ������Ҫ�� Viewer ���� ======================

  // �������Ϣ����
  TCnMsgType = (cmtInformation, cmtWarning, cmtError, cmtSeparator, cmtEnterProc,
    cmtLeaveProc, cmtTimeMarkStart, cmtTimeMarkStop, cmtMemoryDump, cmtException,
    cmtObject, cmtComponent, cmtCustom, cmtSystem);
  TCnMsgTypes = set of TCnMsgType;

  // ʱ�����ʽ����
  TCnTimeStampType = (ttNone, ttDateTime, ttTickCount, ttCPUPeriod);

  {$NODEFINE TCnMsgAnnex}
  TCnMsgAnnex = packed record
  {* ������������ÿ����Ϣ��ͷ�����ṹ }
    Level:     Integer;                            // �Զ��� Level �������û�������
    Indent:    Integer;                            // ������Ŀ���� Enter �� Leave ����
    ProcessId: DWORD;                              // �����ߵĽ��� ID
    ThreadId:  DWORD;                              // �����ߵ��߳� ID
    Tag: array[0..CnMaxTagLength - 1] of AnsiChar; // �Զ��� Tag ֵ�����û�������
    MsgType:   DWORD;                              // ��Ϣ����
    MsgCPInterval: DWORD;                          // ��ʱ����ʱ�� CPU ������
    TimeStampType: DWORD;                          // ��Ϣ�����ʱ�������
    case Integer of
      1: (MsgDateTime:   TDateTime);               // ��Ϣ�����ʱ���ֵ DateTime
      2: (MsgTickCount:  DWORD);                   // ��Ϣ�����ʱ���ֵ TickCount
      3: (MsgCPUPeriod:  Int64);                   // ��Ϣ�����ʱ���ֵ CPU ����
  end;

  {$NODEFINE TCnMsgDesc}
  {$NODEFINE PCnMsgDesc}
  TCnMsgDesc = packed record
  {* ������������ÿ����Ϣ�������ṹ������һ��Ϣͷ}
    Length: Integer;                               // �ܳ��ȣ�������Ϣͷ
    Annex: TCnMsgAnnex;                            // һ����Ϣͷ
    Msg: array[0..CnMaxMsgLength - 1] of AnsiChar; // ��Ҫ��¼����Ϣ
  end;
  PCnMsgDesc = ^TCnMsgDesc;

  {$NODEFINE TCnMapFilter}
  {$NODEFINE PCnMapFilter}
  TCnMapFilter = packed record
  {* ���ڴ�ӳ���ļ���������ʱ���ڴ���ͷ�еĹ�������ʽ}
    NeedRefresh: DWORD;                            // �� 0 ʱ��Ҫ����
    Enabled: Integer;                              // �� 0 ʱ��ʾʹ��
    Level: Integer;                                // �޶��� Level
    Tag: array[0..CnMaxTagLength - 1] of AnsiChar; // �޶��� Tag
    case Integer of
      0: (MsgTypes: TCnMsgTypes);                  // �޶��� MsgTypes
      1: (DummyPlace: DWORD);
  end;
  PCnMapFilter = ^TCnMapFilter;

  {$NODEFINE TCnMapHeader}
  {$NODEFINE PCnMapHeader}
  TCnMapHeader = packed record
  {* ���ڴ�ӳ���ļ���������ʱ���ڴ���ͷ��ʽ}
    MagicName:  array[0..CnDebugMagicLength - 1] of AnsiChar;  // 'CNDEBUG'
    MapEnabled: DWORD;              // Ϊһ CnDebugMapEnabled ʱ����ʾ�������
    MapSize:    DWORD;              // ���� Map �Ĵ�С��������β������
    DataOffset: Integer;            // �����������ͷ����ƫ������Ŀǰ��Ϊ 64
    QueueFront: Integer;            // ����ͷָ�룬���������������ƫ����
    QueueTail:  Integer;            // ����βָ�룬���������������ƫ����
    Filter: TCnMapFilter;           // Viewer �����õĹ�����
  end;
  PCnMapHeader = ^TCnMapHeader;

  // ===================== ���Ͻṹ������Ҫ�� Viewer ���� ======================

implementation

end.
