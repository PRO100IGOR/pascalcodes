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

unit CnScript_DesignIntf;
{ |<PRE>
================================================================================
* ������ƣ�CnPack IDE ר�Ұ�
* ��Ԫ���ƣ��ű���չ DesignIntf ע����
* ��Ԫ���ߣ��ܾ��� (zjy@cnpack.org)
* ��    ע���õ�Ԫ�� UnitParser v0.7 �Զ����ɵ��ļ��޸Ķ���
* ����ƽ̨��PWinXP SP2 + Delphi 5.01
* ���ݲ��ԣ�PWin9X/2000/XP + Delphi 5/6/7
* �� �� �����ô����е��ַ���֧�ֱ��ػ�����ʽ
* ��Ԫ��ʶ��$Id: CnScript_DesignIntf.pas 763 2011-02-07 14:18:23Z liuxiao@cnpack.org $
* �޸ļ�¼��2006.12.29 V1.0
*               ������Ԫ
================================================================================
|</PRE>}

interface

{$I CnWizards.inc}

uses
  Windows, SysUtils, Classes, DesignIntf, uPSComponent, uPSRuntime, uPSCompiler;

type

  TPSImport_DesignIntf = class(TPSPlugin)
  public
    procedure CompileImport1(CompExec: TPSScript); override;
    procedure ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter); override;
  end;

  { compile-time registration functions }
procedure SIRegister_IDesigner(CL: TPSPascalCompiler);
procedure SIRegister_IDesignerSelections(CL: TPSPascalCompiler);
procedure SIRegister_DesignIntf(CL: TPSPascalCompiler);

{ run-time registration functions }
procedure RIRegister_DesignIntf_Routines(S: TPSExec);

implementation

(* === compile-time registration functions === *)

procedure SIRegister_IDesigner(CL: TPSPascalCompiler);
begin
  //with RegInterfaceS(CL,'IUNKNOWN', 'IDesigner') do
  with CL.AddInterface(CL.FindInterface('IUNKNOWN'), IDesigner, 'IDesigner') do
  begin
    RegisterMethod('Procedure Activate', cdRegister);
    RegisterMethod('Procedure Modified', cdRegister);
    RegisterMethod('Function CreateMethod( const Name : string; TypeData : PTypeData) : TMethod', cdRegister);
    RegisterMethod('Function GetMethodName( const Method : TMethod) : string', cdRegister);
    RegisterMethod('Procedure GetMethods( TypeData : PTypeData; Proc : TGetStrProc)', cdRegister);
    RegisterMethod('Function GetPathAndBaseExeName : string', cdRegister);
    RegisterMethod('Function GetPrivateDirectory : string', cdRegister);
    RegisterMethod('Function GetBaseRegKey : string', cdRegister);
    RegisterMethod('Function GetIDEOptions : TCustomIniFile', cdRegister);
    RegisterMethod('Procedure GetSelections( const List : IDesignerSelections)', cdRegister);
    RegisterMethod('Function MethodExists( const Name : string) : Boolean', cdRegister);
    RegisterMethod('Procedure RenameMethod( const CurName, NewName : string)', cdRegister);
    RegisterMethod('Procedure SelectComponent( Instance : TPersistent)', cdRegister);
    RegisterMethod('Procedure SetSelections( const List : IDesignerSelections)', cdRegister);
    RegisterMethod('Procedure ShowMethod( const Name : string)', cdRegister);
    RegisterMethod('Procedure GetComponentNames( TypeData : PTypeData; Proc : TGetStrProc)', cdRegister);
    RegisterMethod('Function GetComponent( const Name : string) : TComponent', cdRegister);
    RegisterMethod('Function GetComponentName( Component : TComponent) : string', cdRegister);
    RegisterMethod('Function GetObject( const Name : string) : TPersistent', cdRegister);
    RegisterMethod('Function GetObjectName( Instance : TPersistent) : string', cdRegister);
    RegisterMethod('Procedure GetObjectNames( TypeData : PTypeData; Proc : TGetStrProc)', cdRegister);
    RegisterMethod('Function MethodFromAncestor( const Method : TMethod) : Boolean', cdRegister);
    RegisterMethod('Function CreateComponent( ComponentClass : TComponentClass; Parent : TComponent; Left, Top, Width, Height : Integer) : TComponent', cdRegister);
    RegisterMethod('Function CreateCurrentComponent( Parent : TComponent; const Rect : TRect) : TComponent', cdRegister);
    RegisterMethod('Function IsComponentLinkable( Component : TComponent) : Boolean', cdRegister);
    RegisterMethod('Function IsComponentHidden( Component : TComponent) : Boolean', cdRegister);
    RegisterMethod('Procedure MakeComponentLinkable( Component : TComponent)', cdRegister);
    RegisterMethod('Procedure Revert( Instance : TPersistent; PropInfo : PPropInfo)', cdRegister);
    RegisterMethod('Function GetIsDormant : Boolean', cdRegister);
    RegisterMethod('Procedure GetProjectModules( Proc : TGetModuleProc)', cdRegister);
    RegisterMethod('Function GetAncestorDesigner : IDesigner', cdRegister);
    RegisterMethod('Function IsSourceReadOnly : Boolean', cdRegister);
    RegisterMethod('Function GetScrollRanges( const ScrollPosition : TPoint) : TPoint', cdRegister);
    RegisterMethod('Procedure Edit( const Component : TComponent)', cdRegister);
    RegisterMethod('Procedure ChainCall( const MethodName, InstanceName, InstanceMethod : string; TypeData : PTypeData)', cdRegister);
    RegisterMethod('Procedure CopySelection', cdRegister);
    RegisterMethod('Procedure CutSelection', cdRegister);
    RegisterMethod('Function CanPaste : Boolean', cdRegister);
    RegisterMethod('Procedure PasteSelection', cdRegister);
    RegisterMethod('Procedure DeleteSelection( ADoAll : Boolean)', cdRegister);
    RegisterMethod('Procedure ClearSelection', cdRegister);
    RegisterMethod('Procedure NoSelection', cdRegister);
    RegisterMethod('Procedure ModuleFileNames( var ImplFileName, IntfFileName, FormFileName : string)', cdRegister);
    RegisterMethod('Function GetRootClassName : string', cdRegister);
    RegisterMethod('Function UniqueName( const BaseName : string) : string', cdRegister);
    RegisterMethod('Function GetRoot : TComponent', cdRegister);
    RegisterMethod('Function GetShiftState : TShiftState', cdRegister);
    RegisterMethod('Procedure ModalEdit( EditKey : Char; const ReturnWindow : IActivatable)', cdRegister);
    RegisterMethod('Procedure SelectItemName( const PropertyName : string)', cdRegister);
    RegisterMethod('Procedure Resurrect', cdRegister);
  end;
end;

procedure SIRegister_IDesignerSelections(CL: TPSPascalCompiler);
begin
  //with RegInterfaceS(CL,'IUNKNOWN', 'IDesignerSelections') do
  with CL.AddInterface(CL.FindInterface('IUNKNOWN'), IDesignerSelections, 'IDesignerSelections') do
  begin
    RegisterMethod('Function Add( const Item : TPersistent) : Integer', cdRegister);
    RegisterMethod('Function Equals( const List : IDesignerSelections) : Boolean', cdRegister);
    RegisterMethod('Function Get( Index : Integer) : TPersistent', cdRegister);
    RegisterMethod('Function GetCount : Integer', cdRegister);
  end;
end;

procedure SIRegister_DesignIntf(CL: TPSPascalCompiler);
begin
  SIRegister_IDesignerSelections(CL);
  SIRegister_IDesigner(CL);
  CL.AddDelphiFunction('Function CreateSelectionList : IDesignerSelections');
end;

(* === run-time registration functions === *)

procedure RIRegister_DesignIntf_Routines(S: TPSExec);
begin
  S.RegisterDelphiFunction(@CreateSelectionList, 'CreateSelectionList', cdRegister);
end;

{ TPSImport_DesignIntf }

procedure TPSImport_DesignIntf.CompileImport1(CompExec: TPSScript);
begin
  SIRegister_DesignIntf(CompExec.Comp);
end;

procedure TPSImport_DesignIntf.ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter);
begin
  RIRegister_DesignIntf_Routines(CompExec.Exec); // comment it if no routines
end;

end.

