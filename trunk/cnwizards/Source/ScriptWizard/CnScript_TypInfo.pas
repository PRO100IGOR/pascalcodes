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

unit CnScript_TypInfo;
{ |<PRE>
================================================================================
* ������ƣ�CnPack IDE ר�Ұ�
* ��Ԫ���ƣ��ű���չ Windows ע����
* ��Ԫ���ߣ��ܾ��� (zjy@cnpack.org)
* ��    ע���õ�Ԫ�� UnitParser v0.7 �Զ����ɵ��ļ��޸Ķ���
* ����ƽ̨��PWinXP SP2 + Delphi 5.01
* ���ݲ��ԣ�PWin9X/2000/XP + Delphi 5/6/7
* �� �� �����ô����е��ַ���֧�ֱ��ػ�����ʽ
* ��Ԫ��ʶ��$Id: CnScript_TypInfo.pas 763 2011-02-07 14:18:23Z liuxiao@cnpack.org $
* �޸ļ�¼��2006.12.11 V1.0
*               ������Ԫ
================================================================================
|</PRE>}

interface

{$I CnWizards.inc}

uses
  Windows, SysUtils, Classes, TypInfo, uPSComponent, uPSRuntime, uPSCompiler;

type

  TPSImport_TypInfo = class(TPSPlugin)
  public
    procedure CompileImport1(CompExec: TPSScript); override;
    procedure ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter); override;
  end;

{ compile-time registration functions }
procedure SIRegister_TypInfo(CL: TPSPascalCompiler);

{ run-time registration functions }
procedure RIRegister_TypInfo_Routines(S: TPSExec);

implementation

(* === compile-time registration functions === *)

procedure SIRegister_TypInfo(CL: TPSPascalCompiler);
begin
  CL.AddTypeS('TTypeKind', '( tkUnknown, tkInteger, tkChar, tkEnumeration, tkFl'
    + 'oat, tkString, tkSet, tkClass, tkMethod, tkWChar, tkLString, tkWString, tk'
    + 'Variant, tkArray, tkRecord, tkInterface, tkInt64, tkDynArray )');
  CL.AddTypeS('TTypeKinds', 'set of TTypeKind');
  CL.AddTypeS('PTypeInfo', 'Pointer');
  CL.AddConstantN('tkAny', 'TTypeKinds').SetSet([Low(TTypeKind)..High(TTypeKind)]);
  CL.AddConstantN('tkMethods', 'TTypeKinds').SetSet([tkMethod]);
  CL.AddConstantN('tkProperties', 'TTypeKinds').SetSet(tkAny - tkMethods - [tkUnknown]);
  CL.AddDelphiFunction('Function GetPropList( Instance : TObject; TypeKinds : TTypeKinds; PropList : TStrings) : Integer;');
  CL.AddDelphiFunction('Function GetPropTypeInfo( Instance : TObject; const PropName : string) : PTypeInfo;');
  CL.AddDelphiFunction('Function GetEnumName( TypeInfo : PTypeInfo; Value : Integer) : string');
  CL.AddDelphiFunction('Function GetEnumValue( TypeInfo : PTypeInfo; const Name : string) : Integer');
  CL.AddDelphiFunction('Function IsPublishedProp( Instance : TObject; const PropName : string) : Boolean;');
  CL.AddDelphiFunction('Function PropIsType( Instance : TObject; const PropName : string; TypeKind : TTypeKind) : Boolean;');
  CL.AddDelphiFunction('Function PropType( Instance : TObject; const PropName : string) : TTypeKind;');
  CL.AddDelphiFunction('Function IsStoredProp( Instance : TObject; const PropName : string) : Boolean;');
  CL.AddDelphiFunction('Function GetOrdProp( Instance : TObject; const PropName : string) : Longint;');
  CL.AddDelphiFunction('Procedure SetOrdProp( Instance : TObject; const PropName : string; Value : Longint);');
  CL.AddDelphiFunction('Function GetEnumProp( Instance : TObject; const PropName : string) : string;');
  CL.AddDelphiFunction('Procedure SetEnumProp( Instance : TObject; const PropName : string; const Value : string);');
  CL.AddDelphiFunction('Function GetSetProp( Instance : TObject; const PropName : string; Brackets : Boolean) : string;');
  CL.AddDelphiFunction('Procedure SetSetProp( Instance : TObject; const PropName : string; const Value : string);');
  CL.AddDelphiFunction('Function GetObjectProp( Instance : TObject; const PropName : string) : TObject;');
  CL.AddDelphiFunction('Procedure SetObjectProp( Instance : TObject; const PropName : string; Value : TObject);');
  CL.AddDelphiFunction('Function GetStrProp( Instance : TObject; const PropName : string) : string;');
  CL.AddDelphiFunction('Procedure SetStrProp( Instance : TObject; const PropName : string; const Value : string);');
  CL.AddDelphiFunction('Function GetFloatProp( Instance : TObject; const PropName : string) : Extended;');
  CL.AddDelphiFunction('Procedure SetFloatProp( Instance : TObject; const PropName : string; Value : Extended);');
  CL.AddDelphiFunction('Function GetVariantProp( Instance : TObject; const PropName : string) : Variant;');
  CL.AddDelphiFunction('Procedure SetVariantProp( Instance : TObject; const PropName : string; const Value : Variant);');
  CL.AddDelphiFunction('Function GetMethodProp( Instance : TObject; const PropName : string) : TMethod;');
  CL.AddDelphiFunction('Procedure SetMethodProp( Instance : TObject; const PropName : string; const Value : TMethod);');
  CL.AddDelphiFunction('Function GetInt64Prop( Instance : TObject; const PropName : string) : Int64;');
  CL.AddDelphiFunction('Procedure SetInt64Prop( Instance : TObject; const PropName : string; const Value : Int64);');
  CL.AddDelphiFunction('Function GetPropValue( Instance : TObject; const PropName : string; PreferStrings : Boolean) : Variant');
  CL.AddDelphiFunction('Procedure SetPropValue( Instance : TObject; const PropName : string; const Value : Variant)');
end;

(* === run-time registration functions === *)

procedure SetInt64Prop(Instance: TObject; const PropName: string; const Value: Int64);
begin
  TypInfo.SetInt64Prop(Instance, PropName, Value);
end;

function GetInt64Prop(Instance: TObject; const PropName: string): Int64;
begin
  Result := TypInfo.GetInt64Prop(Instance, PropName);
end;

procedure SetMethodProp(Instance: TObject; const PropName: string; const Value: TMethod);
begin
  TypInfo.SetMethodProp(Instance, PropName, Value);
end;

function GetMethodProp(Instance: TObject; const PropName: string): TMethod;
begin
  Result := TypInfo.GetMethodProp(Instance, PropName);
end;

procedure SetVariantProp(Instance: TObject; const PropName: string; const Value: Variant);
begin
  TypInfo.SetVariantProp(Instance, PropName, Value);
end;

function GetVariantProp(Instance: TObject; const PropName: string): Variant;
begin
  Result := TypInfo.GetVariantProp(Instance, PropName);
end;

procedure SetFloatProp(Instance: TObject; const PropName: string; Value: Extended);
begin
  TypInfo.SetFloatProp(Instance, PropName, Value);
end;

function GetFloatProp(Instance: TObject; const PropName: string): Extended;
begin
  Result := TypInfo.GetFloatProp(Instance, PropName);
end;

procedure SetStrProp(Instance: TObject; const PropName: string; const Value: string);
begin
  TypInfo.SetStrProp(Instance, PropName, Value);
end;

function GetStrProp(Instance: TObject; const PropName: string): string;
begin
  Result := TypInfo.GetStrProp(Instance, PropName);
end;

procedure SetObjectProp(Instance: TObject; const PropName: string; Value: TObject);
begin
  TypInfo.SetObjectProp(Instance, PropName, Value);
end;

function GetObjectProp(Instance: TObject; const PropName: string): TObject;
begin
  Result := TypInfo.GetObjectProp(Instance, PropName);
end;

procedure SetSetProp(Instance: TObject; const PropName: string; const Value: string);
begin
  TypInfo.SetSetProp(Instance, PropName, Value);
end;

function GetSetProp(Instance: TObject; const PropName: string; Brackets: Boolean): string;
begin
  Result := TypInfo.GetSetProp(Instance, PropName, Brackets);
end;

procedure SetEnumProp(Instance: TObject; const PropName: string; const Value: string);
begin
  TypInfo.SetEnumProp(Instance, PropName, Value);
end;

function GetEnumProp(Instance: TObject; const PropName: string): string;
begin
  Result := TypInfo.GetEnumProp(Instance, PropName);
end;

procedure SetOrdProp(Instance: TObject; const PropName: string; Value: Longint);
begin
  TypInfo.SetOrdProp(Instance, PropName, Value);
end;

function GetOrdProp(Instance: TObject; const PropName: string): Longint;
begin
  Result := TypInfo.GetOrdProp(Instance, PropName);
end;

function IsStoredProp(Instance: TObject; const PropName: string): Boolean;
begin
  Result := TypInfo.IsStoredProp(Instance, PropName);
end;

function PropType(Instance: TObject; const PropName: string): TTypeKind;
begin
  Result := TypInfo.PropType(Instance, PropName);
end;

function PropIsType(Instance: TObject; const PropName: string; TypeKind: TTypeKind): Boolean;
begin
  Result := TypInfo.PropIsType(Instance, PropName, TypeKind);
end;

function IsPublishedProp(Instance: TObject; const PropName: string): Boolean;
begin
  Result := TypInfo.IsPublishedProp(Instance, PropName);
end;

function GetPropTypeInfo(Instance: TObject; const PropName: string): PTypeInfo;
var
  PropInfo: PPropInfo;
begin
  PropInfo := TypInfo.GetPropInfo(Instance, PropName);
  if (PropInfo <> nil) and (PropInfo^.PropType <> nil) then
    Result := PropInfo^.PropType^
  else
    Result := nil;
end;

function GetPropList(Instance: TObject; TypeKinds: TTypeKinds;
  PropList: TStrings): Integer;
var
  i: Integer;
  PList: PPropList;
begin
  PropList.Clear;
  Result := TypInfo.GetPropList(Instance.ClassInfo, TypeKinds, nil);
  if Result > 0 then
  begin
    GetMem(PList, Result * SizeOf(PPropInfo));
    try
      TypInfo.GetPropList(Instance.ClassInfo, TypeKinds, PList);
      for i := 0 to Result - 1 do
        PropList.Add(string(PList[i].Name));
    finally
      FreeMem(PList);
    end;
  end;
end;

procedure RIRegister_TypInfo_Routines(S: TPSExec);
begin
  S.RegisterDelphiFunction(@GetPropList, 'GetPropList', cdRegister);
  S.RegisterDelphiFunction(@GetPropTypeInfo, 'GetPropTypeInfo', cdRegister);
  S.RegisterDelphiFunction(@GetEnumName, 'GetEnumName', cdRegister);
  S.RegisterDelphiFunction(@GetEnumValue, 'GetEnumValue', cdRegister);
  S.RegisterDelphiFunction(@IsPublishedProp, 'IsPublishedProp', cdRegister);
  S.RegisterDelphiFunction(@PropIsType, 'PropIsType', cdRegister);
  S.RegisterDelphiFunction(@PropType, 'PropType', cdRegister);
  S.RegisterDelphiFunction(@IsStoredProp, 'IsStoredProp', cdRegister);
  S.RegisterDelphiFunction(@GetOrdProp, 'GetOrdProp', cdRegister);
  S.RegisterDelphiFunction(@SetOrdProp, 'SetOrdProp', cdRegister);
  S.RegisterDelphiFunction(@GetEnumProp, 'GetEnumProp', cdRegister);
  S.RegisterDelphiFunction(@SetEnumProp, 'SetEnumProp', cdRegister);
  S.RegisterDelphiFunction(@GetSetProp, 'GetSetProp', cdRegister);
  S.RegisterDelphiFunction(@SetSetProp, 'SetSetProp', cdRegister);
  S.RegisterDelphiFunction(@GetObjectProp, 'GetObjectProp', cdRegister);
  S.RegisterDelphiFunction(@SetObjectProp, 'SetObjectProp', cdRegister);
  S.RegisterDelphiFunction(@GetStrProp, 'GetStrProp', cdRegister);
  S.RegisterDelphiFunction(@SetStrProp, 'SetStrProp', cdRegister);
  S.RegisterDelphiFunction(@GetFloatProp, 'GetFloatProp', cdRegister);
  S.RegisterDelphiFunction(@SetFloatProp, 'SetFloatProp', cdRegister);
  S.RegisterDelphiFunction(@GetVariantProp, 'GetVariantProp', cdRegister);
  S.RegisterDelphiFunction(@SetVariantProp, 'SetVariantProp', cdRegister);
  S.RegisterDelphiFunction(@GetMethodProp, 'GetMethodProp', cdRegister);
  S.RegisterDelphiFunction(@SetMethodProp, 'SetMethodProp', cdRegister);
  S.RegisterDelphiFunction(@GetInt64Prop, 'GetInt64Prop', cdRegister);
  S.RegisterDelphiFunction(@SetInt64Prop, 'SetInt64Prop', cdRegister);
  S.RegisterDelphiFunction(@GetPropValue, 'GetPropValue', cdRegister);
  S.RegisterDelphiFunction(@SetPropValue, 'SetPropValue', cdRegister);
end;

{ TPSImport_TypInfo }

procedure TPSImport_TypInfo.CompileImport1(CompExec: TPSScript);
begin
  SIRegister_TypInfo(CompExec.Comp);
end;

procedure TPSImport_TypInfo.ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter);
begin
  RIRegister_TypInfo_Routines(CompExec.Exec);
end;

end.

