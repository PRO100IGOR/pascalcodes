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

unit Windows;
{ |<PRE>
================================================================================
* ������ƣ�CnPack IDE ר�Ұ�
* ��Ԫ���ƣ��ڽű���ʹ�õ� Windows ��Ԫ����
* ��Ԫ���ߣ��ܾ��� (zjy@cnpack.org)
* ��    ע����Ԫ�����������޸��� Borland Delphi Դ���룬��������������
*           ����Ԫ�����������ͺͺ��������� PasScript �ű���ʹ��
* ����ƽ̨��PWinXP SP2 + Delphi 5.01
* ���ݲ��ԣ�PWin9X/2000/XP + Delphi 5/6/7
* �� �� ����
* ��Ԫ��ʶ��$Id: Windows.pas 763 2011-02-07 14:18:23Z liuxiao@cnpack.org $
* �޸ļ�¼��2006.12.11 V1.0
*               ������Ԫ
================================================================================
|</PRE>}

interface

const
  MAX_PATH = 260;

type

  WCHAR = WideChar;
  DWORD = LongWord;
  BOOL = LongBool;
  UCHAR = Byte;
  SHORT = Smallint;
  UINT = LongWord;
  ULONG = Cardinal;
  LCID = DWORD;
  LANGID = Word;
  THandle = LongWord;
  LONGLONG = Int64;
  TLargeInteger = Int64;

  FILETIME = record
    dwLowDateTime: DWORD;
    dwHighDateTime: DWORD;
  end;
  TFileTime = FILETIME;

  SYSTEMTIME = record
    wYear: Word;
    wMonth: Word;
    wDayOfWeek: Word;
    wDay: Word;
    wHour: Word;
    wMinute: Word;
    wSecond: Word;
    wMilliseconds: Word;
  end;
  TSystemTime = SYSTEMTIME;

  WIN32_FIND_DATA = record
    dwFileAttributes: DWORD;
    ftCreationTime: TFileTime;
    ftLastAccessTime: TFileTime;
    ftLastWriteTime: TFileTime;
    nFileSizeHigh: DWORD;
    nFileSizeLow: DWORD;
    dwReserved0: DWORD;
    dwReserved1: DWORD;
    cFileName: array[0..MAX_PATH - 1] of Char;
    cAlternateFileName: array[0..13] of Char;
  end;

  TWin32FindData = WIN32_FIND_DATA;

  HWND = LongWord;
  HDC = LongWord;
  HFONT = LongWord;
  HICON = LongWord;
  HMENU = LongWord;
  HINST = LongWord;
  HMODULE = HINST;
  HCURSOR = HICON;
  COLORREF = DWORD;
  TColorRef = DWORD;

  TPoint = record
    x: LongInt;
    y: LongInt;
  end;

  TSize = record
    cx: LongInt;
    cy: LongInt;
  end;

  TRect = record
    Left, Top, Right, Bottom: LongInt;
  end;

  TSmallPoint = record
    x: SmallInt;
    y: SmallInt;
  end;

  WPARAM = Longint;
  LPARAM = Longint;
  LRESULT = Longint;

  MSG = record
    hwnd: HWND;
    message: UINT;
    wParam: WPARAM;
    lParam: LPARAM;
    time: DWORD;
    pt: TPoint;
  end;
  TMsg = MSG;
  
  TOwnerDrawStateE = (odSelected, odGrayed, odDisabled, odChecked,
    odFocused, odDefault, odHotLight, odInactive, odNoAccel, odNoFocusRect,
    odReserved1, odReserved2, odComboBoxEdit);
  TOwnerDrawState = set of TOwnerDrawStateE;

  HKEY = type LongWord;

const

  HKEY_CLASSES_ROOT     = DWORD($80000000);
  HKEY_CURRENT_USER     = DWORD($80000001);
  HKEY_LOCAL_MACHINE    = DWORD($80000002);
  HKEY_USERS            = DWORD($80000003);
  HKEY_PERFORMANCE_DATA = DWORD($80000004);
  HKEY_CURRENT_CONFIG   = DWORD($80000005);
  HKEY_DYN_DATA         = DWORD($80000006);

  MINCHAR = $80;
  MAXCHAR = 127;
  MINSHORT = $8000;
  MAXSHORT = 32767;
  MININT = Integer($80000000);
  MINLONG = Integer($80000000);
  MAXINT = $7FFFFFFF;
  MAXLONG = $7FFFFFFF;
  MAXBYTE = 255;
  MAXWORD = 65535;
  MAXDWORD = $FFFFFFFF;

  INVALID_HANDLE_VALUE = DWORD(-1);
  INVALID_FILE_SIZE = $FFFFFFFF;
  FILE_BEGIN = 0;
  FILE_CURRENT = 1;
  FILE_END = 2;

  MB_OK = $00000000;
  MB_OKCANCEL = $00000001;
  MB_ABORTRETRYIGNORE = $00000002;
  MB_YESNOCANCEL = $00000003;
  MB_YESNO = $00000004;
  MB_RETRYCANCEL = $00000005;
  MB_ICONHAND = $00000010;
  MB_ICONQUESTION = $00000020;
  MB_ICONEXCLAMATION = $00000030;
  MB_ICONASTERISK = $00000040;
  MB_USERICON = $00000080;
  MB_ICONWARNING = $00000030;
  MB_ICONERROR = $00000010;
  MB_ICONINFORMATION = $00000040;
  MB_ICONSTOP = $00000010;
  MB_DEFBUTTON1 = $00000000;
  MB_DEFBUTTON2 = $00000100;
  MB_DEFBUTTON3 = $00000200;
  MB_DEFBUTTON4 = $00000300;
  MB_APPLMODAL = $00000000;
  MB_SYSTEMMODAL = $00001000;
  MB_TASKMODAL = $00002000;
  MB_HELP = $00004000;
  MB_NOFOCUS = $00008000;
  MB_SETFOREGROUND = $00010000;
  MB_DEFAULT_DESKTOP_ONLY = $00020000;
  MB_TOPMOST = $00040000;

  COLOR_SCROLLBAR = 0;
  COLOR_BACKGROUND = 1;
  COLOR_ACTIVECAPTION = 2;
  COLOR_INACTIVECAPTION = 3;
  COLOR_MENU = 4;
  COLOR_WINDOW = 5;
  COLOR_WINDOWFRAME = 6;
  COLOR_MENUTEXT = 7;
  COLOR_WINDOWTEXT = 8;
  COLOR_CAPTIONTEXT = 9;
  COLOR_ACTIVEBORDER = 10;
  COLOR_INACTIVEBORDER = 11;
  COLOR_APPWORKSPACE = 12;
  COLOR_HIGHLIGHT = 13;
  COLOR_HIGHLIGHTTEXT = 14;
  COLOR_BTNFACE = 15;
  COLOR_BTNSHADOW = $10;
  COLOR_GRAYTEXT = 17;
  COLOR_BTNTEXT = 18;
  COLOR_INACTIVECAPTIONTEXT = 19;
  COLOR_BTNHIGHLIGHT = 20;
  COLOR_3DDKSHADOW = 21;
  COLOR_3DLIGHT = 22;
  COLOR_INFOTEXT = 23;
  COLOR_INFOBK = 24;
  COLOR_HOTLIGHT = 26;
  COLOR_GRADIENTACTIVECAPTION = 27;
  COLOR_GRADIENTINACTIVECAPTION = 28;
  COLOR_ENDCOLORS = COLOR_GRADIENTINACTIVECAPTION;
  COLOR_DESKTOP = COLOR_BACKGROUND;
  COLOR_3DFACE = COLOR_BTNFACE;
  COLOR_3DSHADOW = COLOR_BTNSHADOW;
  COLOR_3DHIGHLIGHT = COLOR_BTNHIGHLIGHT;
  COLOR_3DHILIGHT = COLOR_BTNHIGHLIGHT;
  COLOR_BTNHILIGHT = COLOR_BTNHIGHLIGHT;

function MessageBox(hWnd: HWND; lpText, lpCaption: PChar; uType: UINT): Integer;

function GetCurrentProcess: THandle;

function GetCurrentProcessId: DWORD;

procedure ExitProcess(uExitCode: UINT);

function TerminateProcess(hProcess: THandle; uExitCode: UINT): BOOL;

function GetExitCodeProcess(hProcess: THandle; var lpExitCode: DWORD): BOOL;

function GetEnvironmentStrings: PChar;

function GetCurrentThread: THandle;

function GetCurrentThreadId: DWORD;

function SetThreadPriority(hThread: THandle; nPriority: Integer): BOOL;

function GetThreadPriority(hThread: THandle): Integer;

procedure ExitThread(dwExitCode: DWORD);

function TerminateThread(hThread: THandle; dwExitCode: DWORD): BOOL;

function GetExitCodeThread(hThread: THandle; var lpExitCode: DWORD): BOOL;

function GetLastError: DWORD;

procedure SetLastError(dwErrCode: DWORD);

function SuspendThread(hThread: THandle): DWORD;

function ResumeThread(hThread: THandle): DWORD;

procedure Sleep(dwMilliseconds: DWORD);

function Beep(dwFreq, dwDuration: DWORD): BOOL;

function SystemTimeToFileTime(const lpSystemTime: TSystemTime; var lpFileTime: TFileTime): BOOL;

function FileTimeToLocalFileTime(const lpFileTime: TFileTime; var lpLocalFileTime: TFileTime): BOOL;

function LocalFileTimeToFileTime(const lpLocalFileTime: TFileTime; var lpFileTime: TFileTime): BOOL;

function FileTimeToSystemTime(const lpFileTime: TFileTime; var lpSystemTime: TSystemTime): BOOL;

function CompareFileTime(const lpFileTime1, lpFileTime2: TFileTime): LongInt;

function FileTimeToDosDateTime(const lpFileTime: TFileTime; var lpFatDate, lpFatTime: Word): BOOL;

function DosDateTimeToFileTime(wFatDate, wFatTime: Word; var lpFileTime: TFileTime): BOOL;

function GetTickCount: DWORD;

function GetModuleFileName(hModule: HINST; lpFilename: PChar; nSize: DWORD): DWORD;

function GetModuleHandle(lpModuleName: PChar): HMODULE;

function GetCommandLine: PChar;

procedure OutputDebugString(lpOutputString: PChar);

function CopyFile(lpExistingFileName, lpNewFileName: PChar; bFailIfExists: BOOL): BOOL;

function MoveFile(lpExistingFileName, lpNewFileName: PChar): BOOL;

procedure MoveMemory(Destination: Pointer; Source: Pointer; Length: DWORD);

procedure CopyMemory(Destination: Pointer; Source: Pointer; Length: DWORD);

procedure FillMemory(Destination: Pointer; Length: DWORD; Fill: Byte);

procedure ZeroMemory(Destination: Pointer; Length: DWORD);

implementation

end.


