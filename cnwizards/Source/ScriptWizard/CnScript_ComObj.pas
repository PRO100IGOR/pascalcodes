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

unit CnScript_ComObj;
{ |<PRE>
================================================================================
* ������ƣ�CnPack IDE ר�Ұ�
* ��Ԫ���ƣ��ű���չ ComObj ע����
* ��Ԫ���ߣ��ܾ��� (zjy@cnpack.org)
* ��    ע���õ�Ԫ�� UnitParser v0.7 �Զ����ɵ��ļ��޸Ķ���
* ����ƽ̨��PWinXP SP2 + Delphi 5.01
* ���ݲ��ԣ�PWin9X/2000/XP + Delphi 5/6/7
* �� �� �����ô����е��ַ���֧�ֱ��ػ�����ʽ
* ��Ԫ��ʶ��$Id: CnScript_ComObj.pas 763 2011-02-07 14:18:23Z liuxiao@cnpack.org $
* �޸ļ�¼��2006.12.29 V1.0
*               ������Ԫ
================================================================================
|</PRE>}

interface

{$I CnWizards.inc}

uses
  Windows, SysUtils, ComObj, uPSComponent, uPSRuntime, uPSCompiler;

type

  TPSImport_ComObj = class(TPSPlugin)
  public
    procedure CompileImport1(CompExec: TPSScript); override;
    procedure ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter); override;
  end;

  { compile-time registration functions }
procedure SIRegister_ComObj(CL: TPSPascalCompiler);

{ run-time registration functions }
procedure RIRegister_ComObj_Routines(S: TPSExec);

implementation

(* === compile-time registration functions === *)

procedure SIRegister_ComObj(CL: TPSPascalCompiler);
begin
  CL.AddDelphiFunction('Function CreateComObject( const ClassID : TGUID) : IUnknown');
  CL.AddDelphiFunction('Function CreateRemoteComObject( const MachineName : WideString; const ClassID : TGUID) : IUnknown');
  CL.AddDelphiFunction('Function CreateOleObject( const ClassName : string) : IDispatch');
  CL.AddDelphiFunction('Function GetActiveOleObject( const ClassName : string) : IDispatch');
  CL.AddDelphiFunction('Procedure OleError( ErrorCode : HResult)');
  CL.AddDelphiFunction('Procedure OleCheck( Result : HResult)');
  CL.AddDelphiFunction('Function StringToGUID( const S : string) : TGUID');
  CL.AddDelphiFunction('Function GUIDToString( const ClassID : TGUID) : string');
  CL.AddDelphiFunction('Function ProgIDToClassID( const ProgID : string) : TGUID');
  CL.AddDelphiFunction('Function ClassIDToProgID( const ClassID : TGUID) : string');
  CL.AddDelphiFunction('Procedure CreateRegKey( const Key, ValueName, Value : string)');
  CL.AddDelphiFunction('Procedure DeleteRegKey( const Key : string)');
  CL.AddDelphiFunction('Function GetRegStringValue( const Key, ValueName : string) : string');
  CL.AddDelphiFunction('Function CreateClassID : string');
end;

(* === run-time registration functions === *)

procedure RIRegister_ComObj_Routines(S: TPSExec);
begin
  S.RegisterDelphiFunction(@CreateComObject, 'CreateComObject', cdRegister);
  S.RegisterDelphiFunction(@CreateRemoteComObject, 'CreateRemoteComObject', cdRegister);
  S.RegisterDelphiFunction(@CreateOleObject, 'CreateOleObject', cdRegister);
  S.RegisterDelphiFunction(@GetActiveOleObject, 'GetActiveOleObject', cdRegister);
  S.RegisterDelphiFunction(@OleError, 'OleError', cdRegister);
  S.RegisterDelphiFunction(@OleCheck, 'OleCheck', cdRegister);
  S.RegisterDelphiFunction(@StringToGUID, 'StringToGUID', cdRegister);
  S.RegisterDelphiFunction(@GUIDToString, 'GUIDToString', cdRegister);
  S.RegisterDelphiFunction(@ProgIDToClassID, 'ProgIDToClassID', cdRegister);
  S.RegisterDelphiFunction(@ClassIDToProgID, 'ClassIDToProgID', cdRegister);
  S.RegisterDelphiFunction(@CreateRegKey, 'CreateRegKey', cdRegister);
  S.RegisterDelphiFunction(@DeleteRegKey, 'DeleteRegKey', cdRegister);
  S.RegisterDelphiFunction(@GetRegStringValue, 'GetRegStringValue', cdRegister);
  S.RegisterDelphiFunction(@CreateClassID, 'CreateClassID', cdRegister);
end;

{ TPSImport_ComObj }

procedure TPSImport_ComObj.CompileImport1(CompExec: TPSScript);
begin
  SIRegister_ComObj(CompExec.Comp);
end;

procedure TPSImport_ComObj.ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter);
begin
  RIRegister_ComObj_Routines(CompExec.Exec); // comment it if no routines
end;

end.

