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

unit IniFiles;
{ |<PRE>
================================================================================
* ������ƣ�CnPack IDE ר�Ұ�
* ��Ԫ���ƣ��ڽű���ʹ�õ� IniFiles ��Ԫ����
* ��Ԫ���ߣ��ܾ��� (zjy@cnpack.org)
* ��    ע����Ԫ�����������޸��� Borland Delphi Դ���룬��������������
*           ����Ԫ�����������ͺͺ��������� PasScript �ű���ʹ��
* ����ƽ̨��PWinXP SP2 + Delphi 5.01
* ���ݲ��ԣ�PWin9X/2000/XP + Delphi 5/6/7
* �� �� ����
* ��Ԫ��ʶ��$Id: IniFiles.pas 763 2011-02-07 14:18:23Z liuxiao@cnpack.org $
* �޸ļ�¼��2006.12.30 V1.0
*               ������Ԫ
================================================================================
|</PRE>}

{$R-,T-,H+,X+}

interface

uses Windows, SysUtils, Classes;

type
  TCustomIniFile = class(TObject)
  public
    constructor Create(const FileName: string);
    function SectionExists(const Section: string): Boolean;
    function ReadString(const Section, Ident, Default: string): string; virtual; abstract;
    procedure WriteString(const Section, Ident, Value: String); virtual; abstract;
    function ReadInteger(const Section, Ident: string; Default: Longint): Longint; virtual;
    procedure WriteInteger(const Section, Ident: string; Value: Longint); virtual;
    function ReadBool(const Section, Ident: string; Default: Boolean): Boolean; virtual;
    procedure WriteBool(const Section, Ident: string; Value: Boolean); virtual;
    function ReadDate(const Section, Name: string; Default: TDateTime): TDateTime; virtual;
    function ReadDateTime(const Section, Name: string; Default: TDateTime): TDateTime; virtual;
    function ReadFloat(const Section, Name: string; Default: Double): Double; virtual;
    function ReadTime(const Section, Name: string; Default: TDateTime): TDateTime; virtual;
    procedure WriteDate(const Section, Name: string; Value: TDateTime); virtual;
    procedure WriteDateTime(const Section, Name: string; Value: TDateTime); virtual;
    procedure WriteFloat(const Section, Name: string; Value: Double); virtual;
    procedure WriteTime(const Section, Name: string; Value: TDateTime); virtual;
    procedure ReadSection(const Section: string; Strings: TStrings); virtual; abstract;
    procedure ReadSections(Strings: TStrings); virtual; abstract;
    procedure ReadSectionValues(const Section: string; Strings: TStrings); virtual; abstract;
    procedure EraseSection(const Section: string); virtual; abstract;
    procedure DeleteKey(const Section, Ident: String); virtual; abstract;
    procedure UpdateFile; virtual; abstract;
    function ValueExists(const Section, Ident: string): Boolean;
    property FileName: string read FFileName;
  end;

  { TIniFile - Encapsulates the Windows INI file interface
    (Get/SetPrivateProfileXXX functions) }

  TIniFile = class(TCustomIniFile)
  public
    function ReadString(const Section, Ident, Default: string): string; override;
    procedure WriteString(const Section, Ident, Value: String); override;
    procedure ReadSection(const Section: string; Strings: TStrings); override;
    procedure ReadSections(Strings: TStrings); override;
    procedure ReadSectionValues(const Section: string; Strings: TStrings); override;
    procedure EraseSection(const Section: string); override;
    procedure DeleteKey(const Section, Ident: String); override;
    procedure UpdateFile; override;
  end;

  { TMemIniFile - loads and entire ini file into memory and allows all
    operations to be performed on the memory image.  The image can then
    be written out to the disk file }

  TMemIniFile = class(TCustomIniFile)
  public
    constructor Create(const FileName: string);
    destructor Destroy; override;
    procedure Clear;
    procedure DeleteKey(const Section, Ident: String); override;
    procedure EraseSection(const Section: string); override;
    procedure GetStrings(List: TStrings);
    procedure ReadSection(const Section: string; Strings: TStrings); override;
    procedure ReadSections(Strings: TStrings); override;
    procedure ReadSectionValues(const Section: string; Strings: TStrings); override;
    function ReadString(const Section, Ident, Default: string): string; override;
    procedure Rename(const FileName: string; Reload: Boolean);
    procedure SetStrings(List: TStrings);
    procedure UpdateFile; override;
    procedure WriteString(const Section, Ident, Value: String); override;
  end;

implementation

end.
