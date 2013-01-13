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

unit CnWizCmdSend;
{* |<PRE>
================================================================================
* ������ƣ�CnPack IDE ר�ҹ��߰�
* ��Ԫ���ƣ�CnWizards ������Ƶķ��Ͷ�
* ��Ԫ���ߣ�CnPack������ ��Х (liuxiao@cnpack.org)
* ��    ע���õ�Ԫʵ���� CnWizards ������Ƶķ��Ͷ�
*           �ⲿ�������������Ϣ����ʱ��Ҫʹ�õ�����Ԫ
* ����ƽ̨��WinXP + Delphi 5.01
* ���ݲ��ԣ�PWin9X/2000/XP + Delphi 5/6/7 + C++Builder 5/6
* �� �� �����õ�Ԫ�е��ַ��������ϱ��ػ�����ʽ
* ��Ԫ��ʶ��$Id: CnWizCmdSend.pas 763 2011-02-07 14:18:23Z liuxiao@cnpack.org $
* �޸ļ�¼��2008.04.29 V1.0
*               ������Ԫ
================================================================================
|</PRE>}

interface

{$I CnWizards.inc}

uses
  Messages, Windows, Classes, SysUtils, CnWizCompilerConst;

function CnWizSendCommand(Command: Cardinal; DestIDESet: TCnCompilers = [];
  const DestID: string = ''; const SourceID: string = '';
  const Params: TStrings = nil): Boolean;
{* ���ݴ���Ĳ�����������
   ����:      Command: Cardinal;             �����
              DestIDESet: TCnCompilers = []; Ŀ�� IDE �汾Ҫ��
              const DestID: string = '';     Ŀ�� ID
              const SourceID: string = '';   �����ߵ�Դ ID
              const Params: TStrings = nil;  �����͵Ķ������ݣ�
                Ϊ�ַ����б����ʽ���ɶ��� param=value ��ʽ���ַ������

   ����ֵ:    Boolean���Ƿ��ͳɹ�

   ��ע��     �����δʹ�� CnWizCmdNotifier.AddCmdNotifier ��ע���Լ��Ľ��� ID��
              ��˴��� SourceID �������ã��Է���ʹ���ô� SourceID �ظ�������Ҳ
              �޷����ա���� SourceID ��Ϊ��������ֻ������Ϣ�������յļ򵥳��ϡ�

              ֻ���Ѿ�ע���Լ��Ľ��� ID ���Ҵ˴����͵� SourceID ����ע�� ID ��
              ����£����͵���Ϣ���Է� Reply ʱ��������յ��Է��Ļ�Ӧ��}

function CnWizSendCommandFromScript(Command: Cardinal; DestIDESet: TCnCompilers;
  const DestID: string; const Params: TStrings): Boolean;
{* ���ű�ר�ҵ��õġ����׵ķ�������ĺ���
   ����:      Command: Cardinal;             �����
              DestIDESet: TCnCompilers = []; Ŀ�� IDE �汾Ҫ��
              const DestID: string = '';     Ŀ�� ID
              const Params: TStrings = nil;  �����͵Ķ������ݣ�
                Ϊ�ַ����б����ʽ���ɶ��� param=value ��ʽ���ַ������

   ����ֵ:    Boolean���Ƿ��ͳɹ�

   ��ע��     ���ڽű��޷�ע���Լ��Ľ��� ID����˷���ʱҲ�����עԴ ID��
}

function CnWizReplyCommand(Command: Cardinal; DestIDESet: TCnCompilers = [];
  const SourceID: string = ''; const Params: TStrings = nil): Boolean;
{* ���յ�����Ĵ�������лظ���������ٴ�ָ��Ŀ�Ķ�
   ����:      Command: Cardinal;             �����
              DestIDESet: TCnCompilers = [];     Ŀ�� IDE �汾Ҫ��
              const SourceID: string = '';   �����ߵ�Դ ID
              const Params: TStrings = nil;  �����͵Ķ������ݣ�
                Ϊ�ַ����б����ʽ���ɶ��� param=value ��ʽ���ַ������

   ����ֵ:    Boolean�������Ƿ�ظ��ɹ�

   ��ע��     �˺���ֻ���ڱ� CnWizCmdNotifier.AddCmdNotifier ע���֪ͨ�ص�����
              �е��ã��������ط��������޷���֪��ǰ����ķ����ߣ���˻����
              ����ֻ�пͻ�������ʱ��Ҳ���Ǵ��� SourceID ʱ��������ظ���

              ��������Ϊ��
              �Է��״η���->�����״ν���->���ػ�Ӧ->�Է����ջ�Ӧ
              ->���ػ�Ӧ���->�Է��״η������
}

implementation

uses
  CnWizCmdMsg, CnWizCmdNotify;

// ���ݴ���Ĳ���������������Ƿ��ͳɹ�
function CnWizSendCommand(Command: Cardinal; DestIDESet: TCnCompilers;
  const DestID: string; const SourceID: string; const Params: TStrings): Boolean;
var
  ASet: TCnCompilers;
  Cds: TCopyDataStruct;
  Cmd: PCnWizMessage;
  HWnd: Cardinal;
  S: string;
  DataLength: Integer;
begin
  Result := False;

  // ����������˳�
  if (Length(DestID) > CN_WIZ_MAX_ID) or (Length(SourceID) > CN_WIZ_MAX_ID) then
    Exit;

  HWnd := FindWindowEx(0, 0, PChar(SCN_WIZ_CMD_WINDOW_NAME), nil);
  if HWnd = 0 then // ��Ŀ�Ĵ������˳�
    Exit;

  // �޲�������Ϊ��
  if Params <> nil then
  begin
    S := Params.Text;
    DataLength := Length(S);
  end
  else
    DataLength := 0;

  Cds.cbData := SizeOf(TCnWizMessage) - SizeOf(Cardinal) + DataLength;

  GetMem(Cds.lpData, Cds.cbData);
  if Cds.lpData = nil then
    Exit;

  Cmd := Cds.lpData;
  FillChar(Cmd^, Cds.cbData, 0);

  Cmd^.Command := Command;

  ASet := DestIDESet;
  Cmd^.IDESets := Cardinal(PInteger(@ASet)^);

  StrCopy(Cmd^.DestID, PChar(DestID));
  StrCopy(Cmd^.SourceID, PChar(SourceID));

  Cmd^.DataLength := DataLength;
  CopyMemory(@(Cmd^.Data[0]), @S[1], DataLength);

  try
    while HWnd <> 0 do
    begin
      if GetCurrentThreadId <> GetWindowThreadProcessId(HWnd, nil) then
      begin
        // ֻ�����������߳�֮��Ĵ���
        Result := Boolean(SendMessage(HWnd, WM_COPYDATA, 0, LPARAM(@Cds)));
      end;
      HWnd := FindWindowEx(0, HWnd, PChar(SCN_WIZ_CMD_WINDOW_NAME), nil);
    end;
  finally
    FreeMem(Cds.lpData);
  end;
end;

// ���ű�ר�ҵ��õġ����׵ķ�������ĺ���
function CnWizSendCommandFromScript(Command: Cardinal; DestIDESet: TCnCompilers;
  const DestID: string; const Params: TStrings): Boolean;
begin
  Result := CnWizSendCommand(Command, DestIDESet, DestID, '', nil);
end;  

// ���յ�����Ĵ�������лظ���������ٴ�ָ��Ŀ�Ķˣ������Ƿ�ظ��ɹ�
function CnWizReplyCommand(Command: Cardinal; DestIDESet: TCnCompilers;
  const SourceID: string; const Params: TStrings): Boolean;
begin
  Result := False;
  if CnWizCmdNotifier.GetCurrentSourceId <> '' then // ֻ�ظ��������Ŀͻ�
    Result := CnWizSendCommand(Command, DestIDESet,
      CnWizCmdNotifier.GetCurrentSourceId, SourceID, Params);
end;

end.
