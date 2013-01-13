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

unit TypeInfo;
{ |<PRE>
================================================================================
* ������ƣ�CnPack IDE ר�Ұ�
* ��Ԫ���ƣ��ڽű���ʹ�õ� TypInfo ��Ԫ����
* ��Ԫ���ߣ��ܾ��� (zjy@cnpack.org)
* ��    ע����Ԫ�����������޸��� Borland Delphi Դ���룬��������������
*           ����Ԫ�����������ͺͺ��������� PasScript �ű���ʹ��
* ����ƽ̨��PWinXP SP2 + Delphi 5.01
* ���ݲ��ԣ�PWin9X/2000/XP + Delphi 5/6/7
* �� �� ����
* ��Ԫ��ʶ��$Id: TypInfo.pas 763 2011-02-07 14:18:23Z liuxiao@cnpack.org $
* �޸ļ�¼��2006.12.11 V1.0
*               ������Ԫ
================================================================================
|</PRE>}

interface

type
  TTypeKind = (tkUnknown, tkInteger, tkChar, tkEnumeration, tkFloat,
    tkString, tkSet, tkClass, tkMethod, tkWChar, tkLString, tkWString,
    tkVariant, tkArray, tkRecord, tkInterface, tkInt64, tkDynArray);

  TTypeKinds = set of TTypeKind;

  PTypeInfo = Pointer;

const
  tkAny = [Low(TTypeKind)..High(TTypeKind)];
  tkMethods = [tkMethod];
  tkProperties = tkAny - tkMethods - [tkUnknown];

function GetPropList(Instance: TObject; TypeKinds: TTypeKinds; PropList: TStrings): Integer;

function GetPropTypeInfo(Instance: TObject; const PropName: string): PTypeInfo;

function GetEnumName(TypeInfo: PTypeInfo; Value: Integer): string;

function GetEnumValue(TypeInfo: PTypeInfo; const Name: string): Integer;

function IsPublishedProp(Instance: TObject; const PropName: string): Boolean;

function PropIsType(Instance: TObject; const PropName: string; TypeKind: TTypeKind): Boolean;

function PropType(Instance: TObject; const PropName: string): TTypeKind;

function IsStoredProp(Instance: TObject; const PropName: string): Boolean;

function GetOrdProp(Instance: TObject; const PropName: string): Longint;

procedure SetOrdProp(Instance: TObject; const PropName: string; Value: Longint);

function GetEnumProp(Instance: TObject; const PropName: string): string;

procedure SetEnumProp(Instance: TObject; const PropName: string; const Value: string);

function GetSetProp(Instance: TObject; const PropName: string; Brackets: Boolean): string;

procedure SetSetProp(Instance: TObject; const PropName: string; const Value: string);

function GetObjectProp(Instance: TObject; const PropName: string): TObject;

procedure SetObjectProp(Instance: TObject; const PropName: string; Value: TObject);

function GetStrProp(Instance: TObject; const PropName: string): string;

procedure SetStrProp(Instance: TObject; const PropName: string; const Value: string);

function GetFloatProp(Instance: TObject; const PropName: string): Extended;

procedure SetFloatProp(Instance: TObject; const PropName: string; Value: Extended);

function GetVariantProp(Instance: TObject; const PropName: string): Variant;

procedure SetVariantProp(Instance: TObject; const PropName: string; const Value: Variant);

function GetMethodProp(Instance: TObject; const PropName: string): TMethod;

procedure SetMethodProp(Instance: TObject; const PropName: string; const Value: TMethod);

function GetInt64Prop(Instance: TObject; const PropName: string): Int64;

procedure SetInt64Prop(Instance: TObject; const PropName: string; const Value: Int64);

function GetPropValue(Instance: TObject; const PropName: string; PreferStrings: Boolean): Variant;

procedure SetPropValue(Instance: TObject; const PropName: string; const Value: Variant);

implementation

end.

