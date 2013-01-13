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

unit CnCommon;
{ |<PRE>
================================================================================
* ������ƣ�CnPack IDE ר�Ұ�
* ��Ԫ���ƣ��ڽű���ʹ�õ� CnCommon ��Ԫ����
* ��Ԫ���ߣ��ܾ��� (zjy@cnpack.org)
* ��    ע������Ԫ�����������ͺͺ��������� PasScript �ű���ʹ��
* ����ƽ̨��PWinXP SP2 + Delphi 5.01
* ���ݲ��ԣ�PWin9X/2000/XP + Delphi 5/6/7
* �� �� ����
* ��Ԫ��ʶ��$Id: CnCommon.pas 763 2011-02-07 14:18:23Z liuxiao@cnpack.org $
* �޸ļ�¼��2006.12.31 V1.0
*               ������Ԫ
================================================================================
|</PRE>}

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  IniFiles, StdCtrls, ComCtrls, ExtCtrls;

//------------------------------------------------------------------------------
// ��չ���ļ�Ŀ¼��������
//------------------------------------------------------------------------------

procedure ExploreDir(APath: string; ShowDir: Boolean);
{* ����Դ�������д�ָ��Ŀ¼ }

procedure ExploreFile(AFile: string; ShowDir: Boolean);
{* ����Դ�������д�ָ���ļ� }

function ForceDirectories(Dir: string): Boolean;
{* �ݹ鴴���༶��Ŀ¼}

function MoveFile(const sName, dName: string): Boolean;
{* �ƶ��ļ���Ŀ¼������ΪԴ��Ŀ����}

function DeleteToRecycleBin(const FileName: string): Boolean;
{* ɾ���ļ�������վ}

procedure FileProperties(const FName: string);
{* ���ļ����Դ���}

function OpenDialog(var FileName: string; Title: string; Filter: string;
  Ext: string): Boolean;
{* ���ļ���}

function GetDirectory(const Caption: string; var Dir: string;
  ShowNewButton: Boolean = True): Boolean;
{* ��ʾѡ���ļ��жԻ���֧������Ĭ���ļ���}

function FormatPath(APath: string; Width: Integer): string;
{* ������ʾ���µĳ�·����}

procedure DrawCompactPath(Hdc: HDC; Rect: TRect; Str: string);
{* ͨ�� DrawText ��������·��}

function SameCharCounts(s1, s2: string): Integer;
{* �����ַ�����ǰ�����ͬ�ַ���}
function CharCounts(Str: PChar; C: Char): Integer;
{* ���ַ�����ĳ�ַ����ֵĴ���}
function GetRelativePath(ATo, AFrom: string;
  const PathStr: string = '\'; const ParentStr: string = '..';
  const CurrentStr: string = '.'; const UseCurrentDir: Boolean = False): string;
{* ȡ����Ŀ¼�����·��}

function LinkPath(const Head, Tail: string): string;
{* ��������·����
   Head - ��·���������� C:\Test��\\Test\C\Abc��http://www.abc.com/dir/ �ȸ�ʽ
   Tail - β·���������� ..\Test��Abc\Temp��\Test��/web/lib �ȸ�ʽ����Ե�ַ��ʽ }

procedure RunFile(const FName: string; Handle: THandle = 0;
  const Param: string = '');
{* ����һ���ļ�}

procedure OpenUrl(const Url: string);
{* ��һ������}

procedure MailTo(const Addr: string; const Subject: string = '');
{* �����ʼ�}

function WinExecute(FileName: string; Visibility: Integer = SW_NORMAL): Boolean;
{* ����һ���ļ����������� }

function WinExecAndWait32(FileName: string; Visibility: Integer = SW_NORMAL;
  ProcessMsg: Boolean = False): Integer;
{* ����һ���ļ����ȴ������}

function WinExecWithPipe(const CmdLine, Dir: string; slOutput: TStrings;
  var dwExitCode: Cardinal): Boolean; overload;
{* �ùܵ���ʽ�� Dir Ŀ¼ִ�� CmdLine��Output ���������Ϣ��
   dwExitCode �����˳��롣����ɹ����� True }

function AppPath: string;
{* Ӧ�ó���·��}

function ModulePath: string;
{* ��ǰִ��ģ�����ڵ�·�� }

function GetProgramFilesDir: string;
{* ȡProgram FilesĿ¼}

function GetWindowsDir: string;
{* ȡWindowsĿ¼}

function GetWindowsTempPath: string;
{* ȡ��ʱ�ļ�·��}

function CnGetTempFileName(const Ext: string): string;
{* ����һ����ʱ�ļ��� }

function GetSystemDir: string;
{* ȡϵͳĿ¼}

function ShortNameToLongName(const FileName: string): string;
{* ���ļ���ת���ļ���}

function LongNameToShortName(const FileName: string): string;
{* ���ļ���ת���ļ���}

function GetTrueFileName(const FileName: string): string;
{* ȡ����ʵ���ļ�����������Сд}

function FindExecFile(const AName: string; var AFullName: string): Boolean;
{* ���ҿ�ִ���ļ�������·�� }

function GetSpecialFolderLocation(const Folder: Integer): string;
{* ȡ��ϵͳ�����ļ���λ�ã�Folder ʹ���� ShlObj �ж���ı�ʶ���� CSIDL_DESKTOP }

function AddDirSuffix(const Dir: string): string;
{* Ŀ¼β��'\'����}

function MakePath(const Dir: string): string;
{* Ŀ¼β��'\'����}

function MakeDir(const Path: string): string;
{* ·��βȥ�� '\'}

function GetUnixPath(const Path: string): string;
{* ·���е� '\' ת�� '/'}

function GetWinPath(const Path: string): string;
{* ·���е� '/' ת�� '\'}

function FileNameMatch(Pattern, FileName: PChar): Integer;
{* �ļ����Ƿ���ͨ���ƥ�䣬����ֵΪ0��ʾƥ�䣬����Ϊ��ƥ��}

function MatchExt(const S, Ext: string): Boolean;
{* �ļ����Ƿ�����չ��ͨ���ƥ��}

function MatchFileName(const S, FN: string): Boolean;
{* �ļ����Ƿ���ͨ���ƥ��}

procedure FileExtsToStrings(const FileExts: string; ExtList: TStrings; CaseSensitive: Boolean);
{* ת����չ��ͨ����ַ���Ϊͨ����б�}

procedure FileMasksToStrings(const FileMasks: string; MaskList: TStrings; CaseSensitive: Boolean);
{* ת���ļ�ͨ����ַ���Ϊͨ����б�}

function FileMatchesMasks(const FileName, FileMasks: string; CaseSensitive: Boolean): Boolean; overload;
{* �ļ����Ƿ�ƥ��ͨ���}

function FileMatchesExts(const FileName, FileExts: string): Boolean; overload;
{* �ļ�������չ���б�Ƚϡ�FileExts����'.pas;.dfm;.inc'�������ַ���}

function IsFileInUse(const FName: string): Boolean;
{* �ж��ļ��Ƿ�����ʹ��}

function IsAscii(FileName: string): Boolean;
{* �ж��ļ��Ƿ�Ϊ Ascii �ļ�}

function IsValidFileName(const Name: string): Boolean;
{* �ж��ļ��Ƿ�����Ч���ļ���}

function GetValidFileName(const Name: string): string;
{* ������Ч���ļ��� }

function SetFileDate(const FileName: string; CreationTime, LastWriteTime, LastAccessTime:
  TFileTime): Boolean;
{* �����ļ�ʱ��}

function GetFileDate(const FileName: string; var CreationTime, LastWriteTime, LastAccessTime:
  TFileTime): Boolean;
{* ȡ�ļ�ʱ��}

function FileTimeToDateTime(const FileTime: TFileTime): TDateTime;
{* �ļ�ʱ��ת��������ʱ��}

function DateTimeToFileTime(const DateTime: TDateTime): TFileTime;
{* ��������ʱ��ת�ļ�ʱ��}

function GetFileIcon(const FileName: string; var Icon: TIcon): Boolean;
{* ȡ�����ļ���ص�ͼ�꣬�ɹ��򷵻�True}

function CreateBakFile(const FileName, Ext: string): Boolean;
{* ���������ļ�}

function FileTimeToLocalSystemTime(FTime: TFileTime): TSystemTime;
{* �ļ�ʱ��ת����ʱ��}

function LocalSystemTimeToFileTime(STime: TSystemTime): TFileTime;
{* ����ʱ��ת�ļ�ʱ��}

function DateTimeToLocalDateTime(DateTime: TDateTime): TDateTime;
{* UTC ʱ��ת����ʱ��}
function LocalDateTimeToDateTime(DateTime: TDateTime): TDateTime;
{* ����ʱ��ת UTC ʱ��}

function CompareTextPos(const ASubText, AText1, AText2: string): Integer;
{* �Ƚ� SubText �������ַ����г��ֵ�λ�õĴ�С����������Ƚ��ַ����������Դ�Сд }

function Deltree(Dir: string; DelRoot: Boolean = True;
  DelEmptyDirOnly: Boolean = False): Boolean;
{* ɾ������Ŀ¼, DelRoot ��ʾ�Ƿ�ɾ��Ŀ¼����}

procedure DelEmptyTree(Dir: string; DelRoot: Boolean = True);
{* ɾ������Ŀ¼�еĿ�Ŀ¼, DelRoot ��ʾ�Ƿ�ɾ��Ŀ¼����}

function GetDirFiles(Dir: string): Integer;
{* ȡ�ļ����ļ���}

type
  TFindCallBack = procedure(const FileName: string; const Info: TSearchRec;
    var Abort: Boolean) of object;
{* ����ָ��Ŀ¼���ļ��Ļص�����}

  TDirCallBack = procedure(const SubDir: string) of object;
{* ����ָ��Ŀ¼ʱ������Ŀ¼�ص�����}

function FindFile(const Path: string; const FileName: string = '*.*';
  Proc: TFindCallBack = nil; DirProc: TDirCallBack = nil; bSub: Boolean = True;
  bMsg: Boolean = True): Boolean;
{* ����ָ��Ŀ¼���ļ��������Ƿ��ж� }

function OpenWith(const FileName: string): Integer;
{* ��ʾ�ļ��򿪷�ʽ�Ի���}

function CheckAppRunning(const FileName: string; var Running: Boolean): Boolean;
{* ���ָ����Ӧ�ó����Ƿ���������
 |<PRE>
   const FileName: string   - Ӧ�ó����ļ���������·�������������չ����
                              Ĭ��Ϊ".EXE"����Сд����ν��
                              �� Notepad.EXE
   var Running: Boolean     - ���ظ�Ӧ�ó����Ƿ����У�����Ϊ True
   Result: Boolean          - ������ҳɹ�����Ϊ True������Ϊ False
 |</PRE>}

type
  TVersionNumber = record
  {* �ļ��汾��}
    Minor: Word;
    Major: Word;
    Build: Word;
    Release: Word;
  end;

function GetFileVersionNumber(const FileName: string): TVersionNumber;
{* ȡ�ļ��汾��}

function GetFileVersionStr(const FileName: string): string;
{* ȡ�ļ��汾�ַ���}

function GetFileInfo(const FileName: string; var FileSize: Int64;
  var FileTime: TDateTime): Boolean;
{* ȡ�ļ���Ϣ}

function GetFileSize(const FileName: string): Int64;
{* ȡ�ļ�����}

function GetFileDateTime(const FileName: string): TDateTime;
{* ȡ�ļ�Delphi��ʽ����ʱ��}

function LoadStringFromFile(const FileName: string): string;
{* ���ļ���Ϊ�ַ���}

function SaveStringToFile(const S, FileName: string): Boolean;
{* �����ַ�����Ϊ�ļ�}

//------------------------------------------------------------------------------
// �����������
//------------------------------------------------------------------------------

function DelEnvironmentVar(const Name: string): Boolean;
{* ɾ����ǰ�����еĻ������� }

function ExpandEnvironmentVar(var Value: string): Boolean;
{* ��չ��ǰ�����еĻ������� }

function GetEnvironmentVar(const Name: string; var Value: string;
  Expand: Boolean): Boolean;
{* ���ص�ǰ�����еĻ������� }

function GetEnvironmentVars(const Vars: TStrings; Expand: Boolean): Boolean;
{* ���ص�ǰ�����еĻ��������б� }

function SetEnvironmentVar(const Name, Value: string): Boolean;
{* ���õ�ǰ�����еĻ������� }

//------------------------------------------------------------------------------
// ��չ���ַ�����������
//------------------------------------------------------------------------------

function InStr(const sShort: string; const sLong: string): Boolean;
{* �ж�s1�Ƿ������s2��}

function IntToStrEx(Value: Integer; Len: Integer; FillChar: Char = '0'): string;
{* ��չ����ת�ַ�������}

function IntToStrSp(Value: Integer; SpLen: Integer = 3; Sp: Char = ','): string;
{* ���ָ������������ַ�ת��}

function IsFloat(const s: String): Boolean;
{* �ж��ַ����Ƿ��ת���ɸ�����}

function IsInt(const s: String): Boolean;
{* �ж��ַ����Ƿ��ת��������}

function IsDateTime(const s: string): Boolean;
{* �ж��ַ����Ƿ��ת���� DateTime }

function IsValidEmail(const s: string): Boolean;
{* �ж��Ƿ���Ч���ʼ���ַ }

function StrSpToInt(Value: String; Sp: Char = ','): Int64;
{* ȥ���ַ����еķָ������ַ�ת��}

function ByteToBin(Value: Byte): string;
{* �ֽ�ת�����ƴ�}

function StrRight(Str: string; Len: Integer): string;
{* �����ַ����ұߵ��ַ�}

function StrLeft(Str: string; Len: Integer): string;
{* �����ַ�����ߵ��ַ�}

function GetLine(C: Char; Len: Integer): string;
{* �����ַ�����}

function GetTextFileLineCount(FileName: String): Integer;
{* �����ı��ļ�������}

function Spc(Len: Integer): string;
{* ���ؿո�}

procedure SwapStr(var s1, s2: string);
{* �����ִ�}

procedure SeparateStrAndNum(const AInStr: string; var AOutStr: string;
  var AOutNum: Integer);
{* �ָ�"������+����"��ʽ���ַ����еķ����ֺ�����}

function UnQuotedStr(const str: string; const ch: Char;
  const sep: string = ''): string;
{* ȥ�������õ��ַ���������}

function CharPosWithCounter(const Sub: Char; const AStr: String;
  Counter: Integer = 1): Integer;
{* �����ַ����г��ֵĵ� Counter �ε��ַ���λ�� }

function CountCharInStr(const Sub: Char; const AStr: string): Integer;
{* �����ַ������ַ��ĳ��ִ���}

function IsValidIdentChar(C: Char; First: Boolean = False): Boolean;
{* �ж��ַ��Ƿ���Ч��ʶ���ַ���First ��ʾ�Ƿ�Ϊ���ַ�}

{$IFDEF COMPILER5}
function BoolToStr(B: Boolean; UseBoolStrs: Boolean = False): string;
{* Delphi5û��ʵ�ֲ�����ת��Ϊ�ַ�����������Delphi6,7��ʵ��}
{$ENDIF COMPILER5}

function LinesToStr(const Lines: string): string;
{* �����ı�ת���У����з�ת'\n'��}

function StrToLines(const Str: string): string;
{* �����ı�ת���У�'\n'ת���з���}

function MyDateToStr(Date: TDate): string;
{* ����ת�ַ�����ʹ�� yyyy.mm.dd ��ʽ}

function RegReadStringDef(const RootKey: HKEY; const Key, Name, Def: string): string;
{* ȡע����ֵ}

procedure ReadStringsFromIni(Ini: TCustomIniFile; const Section: string; Strings: TStrings);
{* �� INI �ж�ȡ�ַ����б�}

procedure WriteStringsToIni(Ini: TCustomIniFile; const Section: string; Strings: TStrings);
{* д�ַ����б� INI �ļ���}

function VersionToStr(Version: DWORD): string;
{* �汾��ת���ַ������� $01020000 --> '1.2.0.0' }

function StrToVersion(s: string): DWORD;
{* �ַ���ת�ɰ汾�ţ��� '1.2.0.0' --> $01020000�������ʽ����ȷ������ $01000000 }

function CnDateToStr(Date: TDateTime): string;
{* ת������Ϊ yyyy.mm.dd ��ʽ�ַ��� }

function CnStrToDate(const S: string): TDateTime;
{* �� yyyy.mm.dd ��ʽ�ַ���ת��Ϊ���� }

function DateTimeToFlatStr(const DateTime: TDateTime): string;
{* ����ʱ��ת '20030203132345' ʽ���� 14 λ�����ַ���}

function FlatStrToDateTime(const Section: string; var DateTime: TDateTime): Boolean;
{* '20030203132345' ʽ���� 14 λ�����ַ���ת����ʱ��}

function StrToRegRoot(const s: string): HKEY;
{* �ַ���תע��������֧�� 'HKEY_CURRENT_USER' 'HKCR' �������ָ�ʽ}

function RegRootToStr(Key: HKEY; ShortFormat: Boolean = True): string;
{* ע������ת�ַ�������ѡ 'HKEY_CURRENT_USER' 'HKCR' �������ָ�ʽ}

function ExtractSubstr(const S: string; var Pos: Integer;
  const Delims: TSysCharSet): string;
{* ���ַ����и���ָ���ķָ���������Ӵ�
 |<PRE>
   const S: string           - Դ�ַ���
   var Pos: Integer          - ������ҵ���ʼλ�ã����������ɵĽ���λ��
   const Delims: TSysCharSet - �ָ�������
   Result: string            - �����Ӵ�
 |</PRE>}

function WildcardCompare(const FileWildcard, FileName: string; const IgnoreCase:
  Boolean = True): Boolean;
{* �ļ���ͨ����Ƚ�}

function ScanCodeToAscii(Code: Word): Char;
{* ���ݵ�ǰ���̲��ֽ�����ɨ����ת���� ASCII �ַ������� WM_KEYDOWN �ȴ�ʹ��
   ���ڲ����� ToAscii���ʿ�֧��ʹ�� Accent Character �ļ��̲��� }

function IsDeadKey(Key: Word): Boolean;
{* ����һ��������Ƿ� Dead key}

function VirtualKeyToAscii(Key: Word): Char;
{* ���ݵ�ǰ����״̬�������ת���� ASCII �ַ������� WM_KEYDOWN �ȴ�ʹ��
   ���ܻᵼ�� Accent Character ����ȷ}

function VK_ScanCodeToAscii(VKey: Word; Code: Word): Char;
{* ���ݵ�ǰ�ļ��̲��ֽ��������ɨ����ת���� ASCII �ַ���ͨ�������������С���̣�
   ɨ���봦�����̣�֧�� Accent Character �ļ��̲��� }

function GetShiftState: TShiftState;
{* ���ص�ǰ�İ���״̬���ݲ�֧�� ssDouble ״̬ }

function IsShiftDown: Boolean;
{* �жϵ�ǰ Shift �Ƿ��� }

function IsAltDown: Boolean;
{* �жϵ�ǰ Alt �Ƿ��� }

function IsCtrlDown: Boolean;
{* �жϵ�ǰ Ctrl �Ƿ��� }

function IsInsertDown: Boolean;
{* �жϵ�ǰ Insert �Ƿ��� }

function IsCapsLockDown: Boolean;
{* �жϵ�ǰ Caps Lock �Ƿ��� }

function IsNumLockDown: Boolean;
{* �жϵ�ǰ NumLock �Ƿ��� }

function IsScrollLockDown: Boolean;
{* �жϵ�ǰ Scroll Lock �Ƿ��� }

function RemoveClassPrefix(const ClassName: string): string;
{* ɾ������ǰ׺ T}

//------------------------------------------------------------------------------
// ��չ�ĶԻ�����
//------------------------------------------------------------------------------

procedure InfoDlg(Mess: string); overload;
{* ��ʾ��ʾ����}

function InfoOk(Mess: string): Boolean; overload;
{* ��ʾ��ʾȷ�ϴ���}

procedure ErrorDlg(Mess: string); overload;
{* ��ʾ���󴰿�}

procedure WarningDlg(Mess: string); overload;
{* ��ʾ���洰��}

function QueryDlg(Mess: string; DefaultNo: Boolean): Boolean; overload;
{* ��ʾ��ѯ�Ƿ񴰿�}

function CnInputQuery(const ACaption, APrompt: string;
  var Value: string; Ini: TCustomIniFile; const Section: string): Boolean;
{* ����Ի���}

function CnInputBox(const ACaption, APrompt, ADefault: string;
   Ini: TCustomIniFile; const Section: string): string;
{* ����Ի���}

//------------------------------------------------------------------------------
// ��չ����ʱ���������
//------------------------------------------------------------------------------

function GetYear(Date: TDate): Integer;
{* ȡ������ݷ���}
function GetMonth(Date: TDate): Integer;
{* ȡ�����·ݷ���}
function GetDay(Date: TDate): Integer;
{* ȡ������������}
function GetHour(Time: TTime): Integer;
{* ȡʱ��Сʱ����}
function GetMinute(Time: TTime): Integer;
{* ȡʱ����ӷ���}
function GetSecond(Time: TTime): Integer;
{* ȡʱ�������}
function GetMSecond(Time: TTime): Integer;
{* ȡʱ��������}

//------------------------------------------------------------------------------
// ϵͳ���ܺ���
//------------------------------------------------------------------------------

procedure MoveMouseIntoControl(AWinControl: TControl);
{* �ƶ���굽�ؼ�}

procedure AddComboBoxTextToItems(ComboBox: TComboBox; MaxItemsCount: Integer = 10);
{* �� ComboBox ���ı��������ӵ������б���}

function DynamicResolution(x, y: WORD): Boolean;
{* ��̬���÷ֱ���}

procedure StayOnTop(Handle: HWND; OnTop: Boolean);
{* �������Ϸ���ʾ}

procedure SetHidden(Hide: Boolean);
{* ���ó����Ƿ������������}

procedure SetTaskBarVisible(Visible: Boolean);
{* �����������Ƿ�ɼ�}

procedure SetDesktopVisible(Visible: Boolean);
{* ���������Ƿ�ɼ�}

function ForceForegroundWindow(HWND: HWND): Boolean;
{* ǿ����һ��������ʾ��ǰ̨}

function GetWorkRect(const Form: TCustomForm = nil): TRect;
{* ȡ��������}

procedure BeginWait;
{* ��ʾ�ȴ����}

procedure EndWait;
{* �����ȴ����}

function CheckWindows9598: Boolean;
{* ����Ƿ�Win95/98ƽ̨}

function CheckWinXP: Boolean;
{* ����Ƿ�WinXP����ƽ̨}

function GetOSString: string;
{* ���ز���ϵͳ��ʶ��}

function GetComputeNameStr : string;
{* �õ�������}

function GetLocalUserName: string;
{* �õ������û���}

function GetRegisteredCompany: string;
{* �õ���˾��}

function GetRegisteredOwner: string;
{* �õ�ע���û���}

//------------------------------------------------------------------------------
// ��������
//------------------------------------------------------------------------------

function GetControlScreenRect(AControl: TControl): TRect;
{* ���ؿؼ�����Ļ�ϵ��������� }

procedure SetControlScreenRect(AControl: TControl; ARect: TRect);
{* ���ÿؼ�����Ļ�ϵ��������� }

function GetMultiMonitorDesktopRect: TRect;
{* ��ö���ʾ������£������������������ʾ��ԭ�������}

procedure ListboxHorizontalScrollbar(Listbox: TCustomListBox);
{* Ϊ Listbox ����ˮƽ������}

function TrimInt(Value, Min, Max: Integer): Integer;
{* ���������Min..Max֮��}

function CompareInt(V1, V2: Integer; Desc: Boolean = False): Integer;
{* �Ƚ�����������V1 > V2 ���� 1��V1 < V2 ���� -1��V1 = V2 ���� 0
   ��� Desc Ϊ True�����ؽ������ }

function IntToByte(Value: Integer): Byte;
{* ���������0..255֮��}

function InBound(Value: Integer; V1, V2: Integer): Boolean;
{* �ж�����Value�Ƿ���V1��V2֮��}

function SameMethod(Method1, Method2: TMethod): Boolean;
{* �Ƚ�����������ַ�Ƿ����}

function RectEqu(Rect1, Rect2: TRect): Boolean;
{* �Ƚ�����Rect�Ƿ����}

procedure DeRect(Rect: TRect; var x, y, Width, Height: Integer);
{* �ֽ�һ��TRectΪ���Ͻ�����x, y�Ϳ��Width���߶�Height}

function EnSize(cx, cy: Integer): TSize;
{* ����һ��TSize����}

function RectWidth(Rect: TRect): Integer;
{* ����TRect�Ŀ��}

function RectHeight(Rect: TRect): Integer;
{* ����TRect�ĸ߶�}

procedure Delay(const uDelay: DWORD);
{* ��ʱ}

function GetLastErrorMsg(IncludeErrorCode: Boolean = False): string;
{* ȡ�����һ�δ�����Ϣ}

procedure ShowLastError;
{* ��ʾWin32 Api���н����Ϣ}

function GetHzPy(const AHzStr: string): string;
{* ȡ���ֵ�ƴ��}

function GetSelText(edt: TCustomEdit): string;
{* ���CustomEditѡ�е��ַ���������ȷ����ʹ����XP��ʽ�ĳ���}

function SoundCardExist: Boolean;
{* �����Ƿ����}

function InheritsFromClassName(AObject: TObject; const AClass: string): Boolean; overload;
{* �ж� AObject �Ƿ�����������Ϊ AClass ���� }

procedure KillProcessByFileName(const FileName: String);
{* �����ļ����������̣�������·��}

function IndexStr(AText: string; AValues: array of string; IgCase: Boolean = True): Integer;
{* �����ַ����ڶ�̬�����е�����������string����ʹ��Case���}

function IndexInt(ANum: Integer; AValues: array of Integer): Integer;
{* �������α����ڶ�̬�����е����������ڱ���ʹ��Case���}

procedure TrimStrings(AList: TStrings);
{* ɾ�����к�ÿһ�е�����β�ո� }

//==============================================================================
// �������Բ�����غ��� by LiuXiao
//==============================================================================

function GetPropValueIncludeSub(Instance: TObject; PropName: string;
    PreferStrings: Boolean = True): Variant;
{* ��ü�������ֵ}

function SetPropValueIncludeSub(Instance: TObject; const PropName: string;
  const Value: Variant): Boolean;
{* ���ü�������ֵ}

//==============================================================================
// ��������� by LiuXiao
//==============================================================================

function IsParentFont(AControl: TControl): Boolean;
{* �ж�ĳ Control �� ParentFont �����Ƿ�Ϊ True������ Parent �򷵻� False }

function GetParentFont(AControl: TComponent): TFont;
{* ȡĳ Control �� Parent �� Font ���ԣ����û�з��� nil }

implementation

{$WARNINGS OFF}

procedure ExploreDir(APath: string; ShowDir: Boolean);
begin
end;

procedure ExploreFile(AFile: string; ShowDir: Boolean);
begin
end;

function ForceDirectories(Dir: string): Boolean;
begin
end;

function MoveFile(const sName, dName: string): Boolean;
begin
end;

function DeleteToRecycleBin(const FileName: string): Boolean;
begin
end;

procedure FileProperties(const FName: string);
begin
end;

function OpenDialog(var FileName: string; Title: string; Filter: string;
  Ext: string): Boolean;
begin
end;

function GetDirectory(const Caption: string; var Dir: string;
  ShowNewButton: Boolean = True): Boolean;
begin
end;

function FormatPath(APath: string; Width: Integer): string;
begin
end;

procedure DrawCompactPath(Hdc: HDC; Rect: TRect; Str: string);
begin
end;

function SameCharCounts(s1, s2: string): Integer;
begin
end;

function CharCounts(Str: PChar; C: Char): Integer;
begin
end;

function GetRelativePath(ATo, AFrom: string;
  const PathStr: string = '\'; const ParentStr: string = '..';
  const CurrentStr: string = '.'; const UseCurrentDir: Boolean = False): string;
begin
end;

function LinkPath(const Head, Tail: string): string;
begin
end;

procedure RunFile(const FName: string; Handle: THandle = 0;
  const Param: string = '');
begin
end;

procedure OpenUrl(const Url: string);
begin
end;

procedure MailTo(const Addr: string; const Subject: string = '');
begin
end;

function WinExecute(FileName: string; Visibility: Integer = SW_NORMAL): Boolean;
begin
end;

function WinExecAndWait32(FileName: string; Visibility: Integer = SW_NORMAL;
  ProcessMsg: Boolean = False): Integer;
begin
end;

function WinExecWithPipe(const CmdLine, Dir: string; slOutput: TStrings;
  var dwExitCode: Cardinal): Boolean; overload;
begin
end;

function AppPath: string;
begin
end;

function ModulePath: string;
begin
end;

function GetProgramFilesDir: string;
begin
end;

function GetWindowsDir: string;
begin
end;

function GetWindowsTempPath: string;
begin
end;

function CnGetTempFileName(const Ext: string): string;
begin
end;

function GetSystemDir: string;
begin
end;

function ShortNameToLongName(const FileName: string): string;
begin
end;

function LongNameToShortName(const FileName: string): string;
begin
end;

function GetTrueFileName(const FileName: string): string;
begin
end;

function FindExecFile(const AName: string; var AFullName: string): Boolean;
begin
end;

function GetSpecialFolderLocation(const Folder: Integer): string;
begin
end;

function AddDirSuffix(const Dir: string): string;
begin
end;

function MakePath(const Dir: string): string;
begin
end;

function MakeDir(const Path: string): string;
begin
end;

function GetUnixPath(const Path: string): string;
begin
end;

function GetWinPath(const Path: string): string;
begin
end;

function FileNameMatch(Pattern, FileName: PChar): Integer;
begin
end;

function MatchExt(const S, Ext: string): Boolean;
begin
end;

function MatchFileName(const S, FN: string): Boolean;
begin
end;

procedure FileExtsToStrings(const FileExts: string; ExtList: TStrings; CaseSensitive: Boolean);
begin
end;

procedure FileMasksToStrings(const FileMasks: string; MaskList: TStrings; CaseSensitive: Boolean);
begin
end;

function FileMatchesMasks(const FileName, FileMasks: string; CaseSensitive: Boolean): Boolean; overload;
begin
end;

function FileMatchesExts(const FileName, FileExts: string): Boolean; overload;
begin
end;

function IsFileInUse(const FName: string): Boolean;
begin
end;

function IsAscii(FileName: string): Boolean;
begin
end;

function IsValidFileName(const Name: string): Boolean;
begin
end;

function GetValidFileName(const Name: string): string;
begin
end;

function SetFileDate(const FileName: string; CreationTime, LastWriteTime, LastAccessTime:
  TFileTime): Boolean;
begin
end;

function GetFileDate(const FileName: string; var CreationTime, LastWriteTime, LastAccessTime:
  TFileTime): Boolean;
begin
end;

function FileTimeToDateTime(const FileTime: TFileTime): TDateTime;
begin
end;

function DateTimeToFileTime(const DateTime: TDateTime): TFileTime;
begin
end;

function GetFileIcon(const FileName: string; var Icon: TIcon): Boolean;
begin
end;

function CreateBakFile(const FileName, Ext: string): Boolean;
begin
end;

function FileTimeToLocalSystemTime(FTime: TFileTime): TSystemTime;
begin
end;

function LocalSystemTimeToFileTime(STime: TSystemTime): TFileTime;
begin
end;

function DateTimeToLocalDateTime(DateTime: TDateTime): TDateTime;
begin
end;

function LocalDateTimeToDateTime(DateTime: TDateTime): TDateTime;
begin
end;

function CompareTextPos(const ASubText, AText1, AText2: string): Integer;
begin
end;

function Deltree(Dir: string; DelRoot: Boolean = True;
  DelEmptyDirOnly: Boolean = False): Boolean;
begin
end;

procedure DelEmptyTree(Dir: string; DelRoot: Boolean = True);
begin
end;

function GetDirFiles(Dir: string): Integer;
begin
end;

function FindFile(const Path: string; const FileName: string = '*.*';
  Proc: TFindCallBack = nil; DirProc: TDirCallBack = nil; bSub: Boolean = True;
  bMsg: Boolean = True): Boolean;
begin
end;

function OpenWith(const FileName: string): Integer;
begin
end;

function CheckAppRunning(const FileName: string; var Running: Boolean): Boolean;
begin
end;

function GetFileVersionNumber(const FileName: string): TVersionNumber;
begin
end;

function GetFileVersionStr(const FileName: string): string;
begin
end;

function GetFileInfo(const FileName: string; var FileSize: Int64;
  var FileTime: TDateTime): Boolean;
begin
end;

function GetFileSize(const FileName: string): Int64;
begin
end;

function GetFileDateTime(const FileName: string): TDateTime;
begin
end;

function LoadStringFromFile(const FileName: string): string;
begin
end;

function SaveStringToFile(const S, FileName: string): Boolean;
begin
end;

function DelEnvironmentVar(const Name: string): Boolean;
begin
end;

function ExpandEnvironmentVar(var Value: string): Boolean;
begin
end;

function GetEnvironmentVar(const Name: string; var Value: string;
  Expand: Boolean): Boolean;
begin
end;

function GetEnvironmentVars(const Vars: TStrings; Expand: Boolean): Boolean;
begin
end;

function SetEnvironmentVar(const Name, Value: string): Boolean;
begin
end;

function InStr(const sShort: string; const sLong: string): Boolean;
begin
end;

function IntToStrEx(Value: Integer; Len: Integer; FillChar: Char = '0'): string;
begin
end;

function IntToStrSp(Value: Integer; SpLen: Integer = 3; Sp: Char = ','): string;
begin
end;

function IsFloat(const s: String): Boolean;
begin
end;

function IsInt(const s: String): Boolean;
begin
end;

function IsDateTime(const s: string): Boolean;
begin
end;

function IsValidEmail(const s: string): Boolean;
begin
end;

function StrSpToInt(Value: String; Sp: Char = ','): Int64;
begin
end;

function ByteToBin(Value: Byte): string;
begin
end;

function StrRight(Str: string; Len: Integer): string;
begin
end;

function StrLeft(Str: string; Len: Integer): string;
begin
end;

function GetLine(C: Char; Len: Integer): string;
begin
end;

function GetTextFileLineCount(FileName: String): Integer;
begin
end;

function Spc(Len: Integer): string;
begin
end;

procedure SwapStr(var s1, s2: string);
begin
end;

procedure SeparateStrAndNum(const AInStr: string; var AOutStr: string;
  var AOutNum: Integer);
begin
end;

function UnQuotedStr(const str: string; const ch: Char;
  const sep: string = ''): string;
begin
end;

function CharPosWithCounter(const Sub: Char; const AStr: String;
  Counter: Integer = 1): Integer;
begin
end;

function CountCharInStr(const Sub: Char; const AStr: string): Integer;
begin
end;

function IsValidIdentChar(C: Char; First: Boolean = False): Boolean;
begin
end;

function BoolToStr(B: Boolean; UseBoolStrs: Boolean = False): string;
begin
end;

function LinesToStr(const Lines: string): string;
begin
end;

function StrToLines(const Str: string): string;
begin
end;

function MyDateToStr(Date: TDate): string;
begin
end;

function RegReadStringDef(const RootKey: HKEY; const Key, Name, Def: string): string;
begin
end;

procedure ReadStringsFromIni(Ini: TCustomIniFile; const Section: string; Strings: TStrings);
begin
end;

procedure WriteStringsToIni(Ini: TCustomIniFile; const Section: string; Strings: TStrings);
begin
end;

function VersionToStr(Version: DWORD): string;
begin
end;

function StrToVersion(s: string): DWORD;
begin
end;

function CnDateToStr(Date: TDateTime): string;
begin
end;

function CnStrToDate(const S: string): TDateTime;
begin
end;

function DateTimeToFlatStr(const DateTime: TDateTime): string;
begin
end;

function FlatStrToDateTime(const Section: string; var DateTime: TDateTime): Boolean;
begin
end;

function StrToRegRoot(const s: string): HKEY;
begin
end;

function RegRootToStr(Key: HKEY; ShortFormat: Boolean = True): string;
begin
end;

function ExtractSubstr(const S: string; var Pos: Integer;
  const Delims: TSysCharSet): string;
begin
end;

function WildcardCompare(const FileWildcard, FileName: string; const IgnoreCase:
  Boolean = True): Boolean;
begin
end;

function ScanCodeToAscii(Code: Word): Char;
begin
end;

function IsDeadKey(Key: Word): Boolean;
begin
end;

function VirtualKeyToAscii(Key: Word): Char;
begin
end;

function VK_ScanCodeToAscii(VKey: Word; Code: Word): Char;
begin
end;

function GetShiftState: TShiftState;
begin
end;

function IsShiftDown: Boolean;
begin
end;

function IsAltDown: Boolean;
begin
end;

function IsCtrlDown: Boolean;
begin
end;

function IsInsertDown: Boolean;
begin
end;

function IsCapsLockDown: Boolean;
begin
end;

function IsNumLockDown: Boolean;
begin
end;

function IsScrollLockDown: Boolean;
begin
end;

function RemoveClassPrefix(const ClassName: string): string;
begin
end;

procedure InfoDlg(Mess: string); overload;
begin
end;

function InfoOk(Mess: string): Boolean; overload;
begin
end;

procedure ErrorDlg(Mess: string); overload;
begin
end;

procedure WarningDlg(Mess: string); overload;
begin
end;

function QueryDlg(Mess: string; DefaultNo: Boolean): Boolean; overload;
begin
end;

function CnInputQuery(const ACaption, APrompt: string;
  var Value: string; Ini: TCustomIniFile; const Section: string): Boolean;
begin
end;

function CnInputBox(const ACaption, APrompt, ADefault: string;
   Ini: TCustomIniFile; const Section: string): string;
begin
end;

function GetYear(Date: TDate): Integer;
begin
end;

function GetMonth(Date: TDate): Integer;
begin
end;

function GetDay(Date: TDate): Integer;
begin
end;

function GetHour(Time: TTime): Integer;
begin
end;

function GetMinute(Time: TTime): Integer;
begin
end;

function GetSecond(Time: TTime): Integer;
begin
end;

function GetMSecond(Time: TTime): Integer;
begin
end;

procedure MoveMouseIntoControl(AWinControl: TControl);
begin
end;

procedure AddComboBoxTextToItems(ComboBox: TComboBox; MaxItemsCount: Integer = 10);
begin
end;

function DynamicResolution(x, y: WORD): Boolean;
begin
end;

procedure StayOnTop(Handle: HWND; OnTop: Boolean);
begin
end;

procedure SetHidden(Hide: Boolean);
begin
end;

procedure SetTaskBarVisible(Visible: Boolean);
begin
end;

procedure SetDesktopVisible(Visible: Boolean);
begin
end;

function ForceForegroundWindow(HWND: HWND): Boolean;
begin
end;

function GetWorkRect(const Form: TCustomForm = nil): TRect;
begin
end;

procedure BeginWait;
begin
end;

procedure EndWait;
begin
end;

function CheckWindows9598: Boolean;
begin
end;

function CheckWinXP: Boolean;
begin
end;

function GetOSString: string;
begin
end;

function GetComputeNameStr : string;
begin
end;

function GetLocalUserName: string;
begin
end;

function GetRegisteredCompany: string;
begin
end;

function GetRegisteredOwner: string;
begin
end;

function GetControlScreenRect(AControl: TControl): TRect;
begin
end;

procedure SetControlScreenRect(AControl: TControl; ARect: TRect);
begin
end;

function GetMultiMonitorDesktopRect: TRect;
begin
end;

procedure ListboxHorizontalScrollbar(Listbox: TCustomListBox);
begin
end;

function TrimInt(Value, Min, Max: Integer): Integer;
begin
end;

function CompareInt(V1, V2: Integer; Desc: Boolean = False): Integer;
begin
end;

function IntToByte(Value: Integer): Byte;
begin
end;

function InBound(Value: Integer; V1, V2: Integer): Boolean;
begin
end;

function SameMethod(Method1, Method2: TMethod): Boolean;
begin
end;

function RectEqu(Rect1, Rect2: TRect): Boolean;
begin
end;

procedure DeRect(Rect: TRect; var x, y, Width, Height: Integer);
begin
end;

function EnSize(cx, cy: Integer): TSize;
begin
end;

function RectWidth(Rect: TRect): Integer;
begin
end;

function RectHeight(Rect: TRect): Integer;
begin
end;

procedure Delay(const uDelay: DWORD);
begin
end;

function GetLastErrorMsg(IncludeErrorCode: Boolean = False): string;
begin
end;

procedure ShowLastError;
begin
end;

function GetHzPy(const AHzStr: string): string;
begin
end;

function GetSelText(edt: TCustomEdit): string;
begin
end;

function SoundCardExist: Boolean;
begin
end;

function InheritsFromClassName(AObject: TObject; const AClass: string): Boolean; overload;
begin
end;

procedure KillProcessByFileName(const FileName: String);
begin
end;

function IndexStr(AText: string; AValues: array of string; IgCase: Boolean = True): Integer;
begin
end;

function IndexInt(ANum: Integer; AValues: array of Integer): Integer;
begin
end;

procedure TrimStrings(AList: TStrings);
begin
end;

function GetPropValueIncludeSub(Instance: TObject; PropName: string;
    PreferStrings: Boolean = True): Variant;
begin
end;

function SetPropValueIncludeSub(Instance: TObject; const PropName: string;
  const Value: Variant): Boolean;
begin
end;

function IsParentFont(AControl: TControl): Boolean;
begin
end;

function GetParentFont(AControl: TComponent): TFont;
begin
end;

end.

