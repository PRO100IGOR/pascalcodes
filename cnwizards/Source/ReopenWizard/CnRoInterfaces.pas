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

unit CnRoInterfaces;
{ |<PRE>
================================================================================
* ������ƣ�CnPack IDE ר�Ұ�
* ��Ԫ���ƣ�����ʷ�ļ��Ľӿڵ�Ԫ
* ��Ԫ���ߣ�Leeon (real-like@163.com); John Howe
* ��    ע��
*           - INodeManager: �ڵ�������ӿ�
*           - IStrIntfMap : �ַ�����Ӧ�ӿ�Map�ӿ�
*           - IRoFiles    : ��¼�����ļ��ӿ�
*           - IReopener   : Reopener���ýӿ�
*           - IRoOptions  : ѡ��ӿ�
*
* ����ƽ̨��PWin2000Pro + Delphi 5.02
* ���ݲ��ԣ�PWin2000 + Delphi 5/6/7
* �� �� �����ô����е��ַ���֧�ֱ��ػ�����ʽ
* ��Ԫ��ʶ��$Id: CnRoInterfaces.pas 763 2011-02-07 14:18:23Z liuxiao@cnpack.org $
* �޸ļ�¼��- 2004-12-11 V1.1
*                 ɾ��ԭ�нӿڡ�����ΪIReopener��IRoOptions��
*           - 2004-03-02 V1.0
*                 ��������ֲ��Ԫ
================================================================================
|</PRE>}

interface

{$I CnWizards.inc}

{$IFDEF CNWIZARDS_CNFILESSNAPSHOTWIZARD}

type
  ICnNodeManager = interface(IUnknown)
    ['{B391B9EE-5557-4EA9-9EE8-20340F611D50}']
    function AllocNode: Pointer;
    function AllocNodeClear: Pointer;
    procedure FreeNode(aNode: Pointer);
  end;

  ICnStrIntfMap = interface(IUnknown)
    ['{EC9EBF0F-7C22-4662-9BDB-4D0D03421995}']
    procedure Add(const Key: string; Value: IUnknown);
    procedure Clear;
    function GetValue(const Key: string): IUnknown;
    function IsEmpty: Boolean;
    function KeyOf(Value: IUnknown): string;
    procedure Remove(const Key: string);
    property Value[const Key: string]: IUnknown read GetValue; default;
  end;

  ICnRoFiles = interface(IUnknown)
    ['{46DE362F-D912-402F-8CDD-1BF5DB0323DF}']
    procedure AddFile(AFileName: string);
    procedure Clear;
    function Count: Integer;
    procedure Delete(AIndex: Integer);
    function GetCapacity: Integer;
    function GetColumnSorting: string;
    function GetNodes(Index: Integer): Pointer;
    function GetString(Index: Integer): string;
    function IndexOf(AFileName: string): Integer;
    procedure SetCapacity(const AValue: Integer);
    procedure SetColumnSorting(const AValue: string);
    procedure SetString(Index: Integer; AValue: string);
    procedure SortByTimeOpened;
    procedure UpdateTime(AIndex: Integer; AOpenedTime, AClosingTime: string);
    property Capacity: Integer read GetCapacity write SetCapacity;
    property ColumnSorting: string read GetColumnSorting write SetColumnSorting;
    property Nodes[Index: Integer]: Pointer read GetNodes;
  end;
  
  ICnReopener = interface(IUnknown)
    ['{EE71E680-EBBF-4DFB-B1D1-A12655475BB6}']
    procedure LogClosingFile(AFileName: string);
    procedure LogOpenedFile(AFileName: string);
  end;

  ICnRoOptions = interface(IUnknown)
    ['{FAE7DE02-82AE-44E0-A84A-54FDEE0DFACD}']
    function GetColumnPersistance: Boolean;
    function GetDefaultPage: Integer;
    function GetFiles(Name: string): ICnRoFiles;
    function GetFormPersistance: Boolean;
    function GetIgnoreDefaultUnits: Boolean;
    function GetLocalDate: Boolean;
    function GetSortPersistance: Boolean;
    function GetAutoSaveInterval: Cardinal;
    procedure SaveAll;
    procedure SaveFiles;
    procedure SaveSetting;
    procedure SetColumnPersistance(const AValue: Boolean);
    procedure SetDefaultPage(const AValue: Integer);
    procedure SetFormPersistance(const AValue: Boolean);
    procedure SetIgnoreDefaultUnits(const AValue: Boolean);
    procedure SetLocalDate(const AValue: Boolean);
    procedure SetSortPersistance(const AValue: Boolean);
    procedure SetAutoSaveInterval(const AValue: Cardinal);
    property ColumnPersistance: Boolean read GetColumnPersistance write SetColumnPersistance;
    property DefaultPage: Integer read GetDefaultPage write SetDefaultPage;
    property Files[Name: string]: ICnRoFiles read GetFiles;
    property FormPersistance: Boolean read GetFormPersistance write SetFormPersistance;
    property IgnoreDefaultUnits: Boolean read GetIgnoreDefaultUnits write SetIgnoreDefaultUnits;
    property LocalDate: Boolean read GetLocalDate write SetLocalDate;
    property SortPersistance: Boolean read GetSortPersistance write SetSortPersistance;
    property AutoSaveInterval: Cardinal read GetAutoSaveInterval write SetAutoSaveInterval;
  end;

{$ENDIF CNWIZARDS_CNFILESSNAPSHOTWIZARD}

implementation

end.


