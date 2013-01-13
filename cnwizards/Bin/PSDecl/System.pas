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

unit SysUtils;
{ |<PRE>
================================================================================
* ������ƣ�CnPack IDE ר�Ұ�
* ��Ԫ���ƣ��ڽű���ʹ�õ� SysUtils ��Ԫ����
* ��Ԫ���ߣ��ܾ��� (zjy@cnpack.org)
* ��    ע����Ԫ�����������޸��� Borland Delphi Դ���룬��������������
*           ����Ԫ�����������ͺͺ��������� PasScript �ű���ʹ��
* ����ƽ̨��PWinXP SP2 + Delphi 5.01
* ���ݲ��ԣ�PWin9X/2000/XP + Delphi 5/6/7
* �� �� ����
* ��Ԫ��ʶ��$Id: System.pas 763 2011-02-07 14:18:23Z liuxiao@cnpack.org $
* �޸ļ�¼��2006.12.11 V1.0
*               ������Ԫ
================================================================================
|</PRE>}

interface

type
  // Pascal Script doesn't support Pointer directly,
  // so we declare Pointer as Cardinal.
  // Use _GetXXX() and _SetXXX() to access Pointer
  Pointer = type Cardinal;

  HRESULT = LongInt;
  UCS2Char = WideChar;
  UCS4Char = LongWord;
  UTF8String = string;
  TDateTime = Double;
  THandle = LongWord;
  HINST = THandle;
  HMODULE = HINST;
  HGLOBAL = THandle;

  TMethod = record
    Code, Data: Pointer;
  end;

  TGUID = record
    D1: LongWord;
    D2: Word;
    D3: Word;
    D4: array[0..7] of Byte;
  end;

const
  S_OK = 0;
  S_FALSE = $00000001;
  E_NOINTERFACE = HRESULT($80004002);
  E_UNEXPECTED = HRESULT($8000FFFF);
  E_NOTIMPL = HRESULT($80004001);

type
  TObject = class
    constructor Create;
    procedure Free;
    class function ClassName: string;
    class function ClassNameIs(const Name: string): Boolean;
    class function ClassInfo: Pointer;
    class function InstanceSize: Longint;
    class function MethodAddress(const Name: string): Pointer;
    class function MethodName(Address: Pointer): string;
    function FieldAddress(const Name: string): Pointer;
  end;

  IUnknown = interface
    ['{00000000-0000-0000-C000-000000000046}']
    function QueryInterface(const IID: TGUID; out Obj): HResult; stdcall;
    function _AddRef: Integer; stdcall;
    function _Release: Integer; stdcall;
  end;

  IDispatch = interface(IUnknown)
    ['{00020400-0000-0000-C000-000000000046}']
    function GetTypeInfoCount(out Count: Integer): HResult; stdcall;
    function GetTypeInfo(Index, LocaleID: Integer; out TypeInfo): HResult; stdcall;
    function GetIDsOfNames(const IID: TGUID; Names: Pointer;
      NameCount, LocaleID: Integer; DispIDs: Pointer): HResult; stdcall;
    function Invoke(DispID: Integer; const IID: TGUID; LocaleID: Integer;
      Flags: Word; var Params; VarResult, ExcepInfo, ArgErr: Pointer): HResult; stdcall;
  end;

  TInterfacedObject = class(TObject, IUnknown)
  public
    property RefCount: Integer read FRefCount;
  end;

function _PChar(P: Pointer): PChar;

function _Pointer(P: TObject): Pointer;

function _TObject(P: Pointer): TObject;

function _GetChar(P: Pointer): Char;

procedure _SetChar(P: Pointer; V: Char);

function _GetByte(P: Pointer): Byte;

procedure _SetByte(P: Pointer; V: Byte);

function _GetWord(P: Pointer): Word;

procedure _SetWord(P: Pointer; V: Word);

function _GetInteger(P: Pointer): Integer;

procedure _SetInteger(P: Pointer; V: Integer);

function _GetSingle(P: Pointer): Single;

procedure _SetSingle(P: Pointer; V: Single);

function _GetDouble(P: Pointer): Double;

procedure _SetDouble(P: Pointer; V: Double);

procedure ChDir(const S: string);

procedure MkDir(const S: string);

function ParamCount: Integer;

function ParamStr(Index: Integer): string;

procedure Randomize;

function Random(Range: Integer): Integer;

procedure RmDir(const S: string);

function UpCase(Ch: Char): Char;

{$IFDEF COMPILER6_UP}
function UTF8Encode(const WS: WideString): UTF8String;

function UTF8Decode(const S: UTF8String): WideString;

function AnsiToUtf8(const S: string): UTF8String;

function Utf8ToAnsi(const S: UTF8String): string;
{$ENDIF}

function GetMemory(Size: Integer): Pointer;

function FreeMemory(P: Pointer): Integer;

function ReallocMemory(P: Pointer; Size: Integer): Pointer;

procedure GetMem(var P: Pointer; Size: Integer);

procedure FreeMem(var P: Pointer);

implementation

end.

