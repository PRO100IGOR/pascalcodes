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

unit CnScript_ScriptEvent;
{ |<PRE>
================================================================================
* ������ƣ�CnPack IDE ר�Ұ�
* ��Ԫ���ƣ��ű���չ ScriptEvent ע����
* ��Ԫ���ߣ��ܾ��� (zjy@cnpack.org)
* ��    ע���õ�Ԫ�� UnitParser v0.7 �Զ����ɵ��ļ��޸Ķ���
* ����ƽ̨��PWinXP SP2 + Delphi 5.01
* ���ݲ��ԣ�PWin9X/2000/XP + Delphi 5/6/7
* �� �� �����ô����е��ַ���֧�ֱ��ػ�����ʽ
* ��Ԫ��ʶ��$Id: CnScript_ScriptEvent.pas 763 2011-02-07 14:18:23Z liuxiao@cnpack.org $
* �޸ļ�¼��2007.09.30 V1.0
*               ������Ԫ
================================================================================
|</PRE>}

interface

{$I CnWizards.inc}

uses
  Windows, SysUtils, Classes, Dialogs, CnScriptFrm, uPSComponent, uPSRuntime, uPSCompiler;

type

  TPSImport_ScriptEvent = class(TPSPlugin)
  public
    procedure CompileImport1(CompExec: TPSScript); override;
    procedure ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter); override;
  end;

{ compile-time registration functions }
procedure SIRegister_TCnScriptFormEditorNotify(CL: TPSPascalCompiler);
procedure SIRegister_TCnScriptSourceEditorNotify(CL: TPSPascalCompiler);
procedure SIRegister_TCnScriptAfterCompile(CL: TPSPascalCompiler);
procedure SIRegister_TCnScriptBeforeCompile(CL: TPSPascalCompiler);
procedure SIRegister_TCnScriptFileNotify(CL: TPSPascalCompiler);
procedure SIRegister_TCnScriptIDELoaded(CL: TPSPascalCompiler);
procedure SIRegister_TCnScriptManual(CL: TPSPascalCompiler);
procedure SIRegister_TCnScriptEvent(CL: TPSPascalCompiler);
procedure SIRegister_ScriptEvent(CL: TPSPascalCompiler);

{ run-time registration functions }
procedure RIRegister_ScriptEvent_Routines(S: TPSExec);
procedure RIRegister_TCnScriptFormEditorNotify(CL: TPSRuntimeClassImporter);
procedure RIRegister_TCnScriptSourceEditorNotify(CL: TPSRuntimeClassImporter);
procedure RIRegister_TCnScriptAfterCompile(CL: TPSRuntimeClassImporter);
procedure RIRegister_TCnScriptBeforeCompile(CL: TPSRuntimeClassImporter);
procedure RIRegister_TCnScriptFileNotify(CL: TPSRuntimeClassImporter);
procedure RIRegister_TCnScriptIDELoaded(CL: TPSRuntimeClassImporter);
procedure RIRegister_TCnScriptManual(CL: TPSRuntimeClassImporter);
procedure RIRegister_TCnScriptEvent(CL: TPSRuntimeClassImporter);
procedure RIRegister_ScriptEvent(CL: TPSRuntimeClassImporter);

implementation

(* === compile-time registration functions === *)

procedure SIRegister_TCnScriptFormEditorNotify(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TCnScriptEvent', 'TCnScriptFormEditorNotify') do
  with CL.AddClass(CL.FindClass('TCnScriptEvent'), TCnScriptFormEditorNotify) do
  begin
    RegisterPublishedProperties;
  end;
end;

procedure SIRegister_TCnScriptSourceEditorNotify(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TCnScriptEvent', 'TCnScriptSourceEditorNotify') do
  with CL.AddClass(CL.FindClass('TCnScriptEvent'), TCnScriptSourceEditorNotify) do
  begin
    RegisterPublishedProperties;
  end;
end;

procedure SIRegister_TCnScriptAfterCompile(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TCnScriptEvent', 'TCnScriptAfterCompile') do
  with CL.AddClass(CL.FindClass('TCnScriptEvent'), TCnScriptAfterCompile) do
  begin
    RegisterPublishedProperties;
  end;
end;

procedure SIRegister_TCnScriptBeforeCompile(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TCnScriptEvent', 'TCnScriptBeforeCompile') do
  with CL.AddClass(CL.FindClass('TCnScriptEvent'), TCnScriptBeforeCompile) do
  begin
    RegisterPublishedProperties;
  end;
end;

procedure SIRegister_TCnScriptFileNotify(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TCnScriptEvent', 'TCnScriptFileNotify') do
  with CL.AddClass(CL.FindClass('TCnScriptEvent'), TCnScriptFileNotify) do
  begin
    RegisterPublishedProperties;
  end;
end;

procedure SIRegister_TCnScriptIDELoaded(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TCnScriptEvent', 'TCnScriptIDELoaded') do
  with CL.AddClass(CL.FindClass('TCnScriptEvent'), TCnScriptIDELoaded) do
  begin
    RegisterPublishedProperties;
  end;
end;

procedure SIRegister_TCnScriptManual(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TCnScriptEvent', 'TCnScriptManual') do
  with CL.AddClass(CL.FindClass('TCnScriptEvent'), TCnScriptManual) do
  begin
    RegisterPublishedProperties;
  end;
end;

procedure SIRegister_TCnScriptEvent(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TOBJECT', 'TCnScriptEvent') do
  with CL.AddClass(CL.FindClass('TOBJECT'), TCnScriptEvent) do
  begin
    RegisterPublishedProperties;
  end;
end;

procedure SIRegister_ScriptEvent(CL: TPSPascalCompiler);
begin
  CL.AddTypeS('TCnScriptMode', '( smManual, smIDELoaded, smFileNotify, smBefore'
    + 'Compile, smAfterCompile, smSourceEditorNotify, smFormEditorNotify )');
  CL.AddTypeS('TCnScriptModeSet', 'set of TCnScriptMode');
  SIRegister_TCnScriptEvent(CL);
  SIRegister_TCnScriptManual(CL);
  SIRegister_TCnScriptIDELoaded(CL);
  SIRegister_TCnScriptFileNotify(CL);
  SIRegister_TCnScriptBeforeCompile(CL);
  SIRegister_TCnScriptAfterCompile(CL);
  CL.AddTypeS('TCnWizSourceEditorNotifyType', '( setOpened, setClosing, setModi'
    + 'fied, setEditViewInsert, setEditViewRemove, setEditViewActivated )');
  SIRegister_TCnScriptSourceEditorNotify(CL);
  CL.AddTypeS('TCnWizFormEditorNotifyType', '( fetOpened, fetClosing, fetModifi'
    + 'ed, fetActivated, fetSaving, fetComponentCreating, fetComponentCreated, '
    + 'fetComponentDestorying, fetComponentRenamed )');
  SIRegister_TCnScriptFormEditorNotify(CL);
  CL.AddDelphiFunction('Function Event : TCnScriptEvent;');
end;

(* === run-time registration functions === *)

function Event_P: TCnScriptEvent;
begin
  Result := CnScriptFrm.ScriptEvent;
end;

procedure RIRegister_ScriptEvent_Routines(S: TPSExec);
begin
  S.RegisterDelphiFunction(@Event_P, 'Event', cdRegister);
end;

procedure RIRegister_TCnScriptFormEditorNotify(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TCnScriptFormEditorNotify) do
  begin
  end;
end;

procedure RIRegister_TCnScriptSourceEditorNotify(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TCnScriptSourceEditorNotify) do
  begin
  end;
end;

procedure RIRegister_TCnScriptAfterCompile(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TCnScriptAfterCompile) do
  begin
  end;
end;

procedure RIRegister_TCnScriptBeforeCompile(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TCnScriptBeforeCompile) do
  begin
  end;
end;

procedure RIRegister_TCnScriptFileNotify(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TCnScriptFileNotify) do
  begin
  end;
end;

procedure RIRegister_TCnScriptIDELoaded(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TCnScriptIDELoaded) do
  begin
  end;
end;

procedure RIRegister_TCnScriptManual(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TCnScriptManual) do
  begin
  end;
end;

procedure RIRegister_TCnScriptEvent(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TCnScriptEvent) do
  begin
  end;
end;

procedure RIRegister_ScriptEvent(CL: TPSRuntimeClassImporter);
begin
  RIRegister_TCnScriptEvent(CL);
  RIRegister_TCnScriptManual(CL);
  RIRegister_TCnScriptIDELoaded(CL);
  RIRegister_TCnScriptFileNotify(CL);
  RIRegister_TCnScriptBeforeCompile(CL);
  RIRegister_TCnScriptAfterCompile(CL);
  RIRegister_TCnScriptSourceEditorNotify(CL);
  RIRegister_TCnScriptFormEditorNotify(CL);
end;

{ TPSImport_ScriptEvent }

procedure TPSImport_ScriptEvent.CompileImport1(CompExec: TPSScript);
begin
  SIRegister_ScriptEvent(CompExec.Comp);
end;

procedure TPSImport_ScriptEvent.ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter);
begin
  RIRegister_ScriptEvent(ri);
  RIRegister_ScriptEvent_Routines(CompExec.Exec); // comment it if no routines
end;

end.

