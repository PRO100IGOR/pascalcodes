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

unit CnScript_IdeInstComp;
{ |<PRE>
================================================================================
* ������ƣ�CnPack IDE ר�Ұ�
* ��Ԫ���ƣ��ű���չע����
* ��Ԫ���ߣ��ܾ��� (zjy@cnpack.org)
* ��    ע���õ�Ԫע���� IDE �а�װ���������
* ����ƽ̨��PWinXP SP2 + Delphi 5.01
* ���ݲ��ԣ�PWin9X/2000/XP + Delphi 5/6/7
* �� �� �����ô����е��ַ���֧�ֱ��ػ�����ʽ
* ��Ԫ��ʶ��$Id: CnScript_IdeInstComp.pas 952 2011-07-25 08:08:55Z liuxiaoshanzhashu@gmail.com $
* �޸ļ�¼��2006.12.30 V1.0
*               ������Ԫ
================================================================================
|</PRE>}

interface

{$I CnWizards.inc}

uses
  Windows, SysUtils, Classes, CnWizIdeUtils, CnScriptClasses,
  uPSComponent, uPSRuntime, uPSCompiler;

type

  TPSImport_IdeInstComp = class(TCnPSPlugin)
  public
    procedure CompileImport1(CompExec: TPSScript); override;
    procedure ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter); override;
    procedure CompOnUses1(CompExec: TPSScript); override;
  end;

  { compile-time registration functions }
procedure SIRegister_IdeInstComp(CL: TPSPascalCompiler);

{ run-time registration functions }
procedure RIRegister_IdeInstComp(CL: TPSRuntimeClassImporter);

implementation

{$IFDEF DEBUG}
uses
  CnDebug;
{$ENDIF}  

(* === compile-time registration functions === *)

procedure SIRegister_IdeInstComp(CL: TPSPascalCompiler);
var
  List: TStringList;
  i: Integer;

  function DoRegisterClass(AClass: TClass): TPSCompileTimeClass;
  begin
    Result := nil;
    if AClass <> nil then
    begin
      Result := CL.FindClass(AnsiString(UpperCase(AClass.ClassName)));
      if Result = nil then
      begin
        Result := CL.AddClass(DoRegisterClass(AClass.ClassParent), AClass);
        Result.RegisterPublishedProperties;
      end;
    end;
  end;
begin
{$IFDEF DEBUG}
  CnDebugger.LogEnter('SIRegister_IdeInstComp');
{$ENDIF}
  List := TStringList.Create;
  try
  {$IFDEF DEBUG}
    CnDebugger.LogMsg('GetInstalledComponents');
  {$ENDIF}
    GetInstalledComponents(nil, List);
  {$IFDEF DEBUG}
    CnDebugger.LogMsg(List.Text);
  {$ENDIF}
    for i := 0 to List.Count - 1 do
    begin
      DoRegisterClass(GetClass(List[i]));
    end;
  finally
    List.Free;
  end;
{$IFDEF DEBUG}
  CnDebugger.LogLeave('SIRegister_IdeInstComp');
{$ENDIF}
end;

(* === run-time registration functions === *)

procedure RIRegister_IdeInstComp(CL: TPSRuntimeClassImporter);
var
  List: TStringList;
  i: Integer;

  function DoRegisterClass(AClass: TClass): TPSRuntimeClass;
  begin
    Result := nil;
    if AClass <> nil then
    begin
      Result := CL.FindClass(AnsiString(UpperCase(AClass.ClassName)));
      if Result = nil then
      begin
        DoRegisterClass(AClass.ClassParent);
        Result := CL.Add(AClass);
      end;
    end;
  end;
begin
{$IFDEF DEBUG}
  CnDebugger.LogEnter('RIRegister_IdeInstComp');
{$ENDIF}
  List := TStringList.Create;
  try
  {$IFDEF DEBUG}
    CnDebugger.LogMsg('GetInstalledComponents');
  {$ENDIF}
    GetInstalledComponents(nil, List);
  {$IFDEF DEBUG}
    CnDebugger.LogMsg(List.Text);
  {$ENDIF}
    for i := 0 to List.Count - 1 do
    begin
      DoRegisterClass(GetClass(List[i]));
    end;  
  finally
    List.Free;
  end;
{$IFDEF DEBUG}
  CnDebugger.LogLeave('RIRegister_IdeInstComp');
{$ENDIF}
end;

{ TPSImport_IdeInstComp }

procedure TPSImport_IdeInstComp.CompileImport1(CompExec: TPSScript);
begin

end;

procedure TPSImport_IdeInstComp.CompOnUses1(CompExec: TPSScript);
begin
  // ���ڸò���������ֻ���û�ʵ��ʹ�� uses IdeInstComp ʱ��ע��
  SIRegister_IdeInstComp(CompExec.Comp);
end;

procedure TPSImport_IdeInstComp.ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter);
begin
  RIRegister_IdeInstComp(ri);
end;

end.



