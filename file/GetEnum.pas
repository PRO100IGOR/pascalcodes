unit GetEnum;

interface

uses
  TLHelp32, Windows,Dialogs, Messages, Classes, SysUtils;

function GetProcessId(FileName: string): TStrings; //返回指定程序的进程ID
function GetHwndFromProcess(ProcessId: DWORD): boolean; //通过进程返回窗体句柄

function GetHWndByPIDSource(ProgressName: string): Integer; //根据进程名获取窗体句柄

function GetHWndByPID(const hPID: THandle): THandle; //根据PID获取句柄

function EnumChildWndProc(AhWnd: LongInt; AlParam: lParam): boolean;

function GetTexts(ProgressName, TitleName: string): TStrings;
var
  hWnd_List, Texts: TStrings;

  HasFinaly: Boolean;
  ProcessIDT: dword;
  input_PID: DWORD;
  FhWnd: integer;

implementation

function GetTexts(ProgressName, TitleName: string): TStrings;
var
  I: Integer;
  Temp: TStrings;
begin
  Texts := TStringList.Create;
  hWnd_List := TStringList.Create;
  HasFinaly := false;
  I := 0;
  Temp := GetProcessId(ProgressName); //指定程序名称
  for i := 0 to Temp.Count - 1 do
  begin
    ProcessIDT := strtoint(Temp[i]);
    GetHwndFromProcess(ProcessIDT);
  end;

  FhWnd := FindWindowEx(0, 0, nil, pChar(trim(TitleName))); //得到目标窗口句柄
  if FhWnd <> 0 then
  hWnd_List.Add(InttoStr(FhWnd));

  FhWnd := GetHWndByPIDSource(ProgressName); //得到目标窗口句柄
  if FhWnd <> 0 then
  hWnd_List.Add(InttoStr(FhWnd));

  FhWnd := FindWindow(nil, pchar(trim(TitleName)));
  if FhWnd <> 0 then
  hWnd_List.Add(InttoStr(FhWnd));


  if hWnd_List.Count > 0 then
  begin
    for i := 0 to hWnd_List.Count - 1 do
    begin
      FhWnd := strtoint(hWnd_List.Strings[i]);
      if FhWnd <> 0 then
      begin
        EnumChildWindows(FhWnd, @EnumChildWndProc, 0);
      end;
    end;
  end;
  Result := Texts;
end;

function EnumChildWndProc(AhWnd: LongInt; AlParam: lParam): boolean;
var
  WndClassName: array[0..254] of Char;
  WndCaption: array[0..254] of Char;
  WndText: array[0..254] of Char;
  StrText: Pchar;
begin
  GetMem(StrText, 254);
  Sendmessage(AhWnd, WM_GETTEXT, 254, LongInt(StrText)); //WM_SETTEXT
  GetClassName(AhWnd, wndClassName, 254);
  GetWindowText(AhWnd, WndCaption, 254);
  if Trim(string(StrText)) <> '' then
  Texts.Add(string(StrText));
//  Texts.Add(string(wndClassName));
//  Texts.Add(string(WndCaption));
  result := true;
  HasFinaly := true;
end;

function GetHWndByPIDSource(ProgressName: string): Integer; //根据进程名获取句柄
var
  ProcessName: string; //进程名
  FSnapshotHandle: THandle; //进程快照句柄
  FProcessEntry32: TProcessEntry32; //进程入口的结构体信息
  ContinueLoop: BOOL;
  MyHwnd: THandle;
begin
  Result := 0;
  FSnapshotHandle := CreateToolhelp32Snapshot(TH32CS_SNAPPROCESS, 0); //创建一个进程快照
  FProcessEntry32.dwSize := Sizeof(FProcessEntry32);
  ContinueLoop := Process32First(FSnapshotHandle, FProcessEntry32); //得到系统中第一个进程
  //循环例举
  while ContinueLoop do
  begin
    ProcessName := FProcessEntry32.szExeFile;
    if (ProcessName = ProgressName) then begin
//      MyHwnd := GetHWndByPID(FProcessEntry32.th32ProcessID);
      Inc(Result);
    end;
    ContinueLoop := Process32Next(FSnapshotHandle, FProcessEntry32);
  end;
  CloseHandle(FSnapshotHandle); //   释放快照句柄
//  Result := MyHwnd;
end;

function GetHWndByPID(const hPID: THandle): THandle;
type
  PEnumInfo = ^TEnumInfo;
  TEnumInfo = record
    ProcessID: DWORD;
    HWND: THandle;
  end;

  function EnumWindowsProc(Wnd: DWORD; var EI: TEnumInfo): Bool;
  var
    PID: DWORD;
  begin
    GetWindowThreadProcessID(Wnd, @PID);
    Result := (PID <> EI.ProcessID) or (not IsWindowVisible(WND)) or (not IsWindowEnabled(WND));
    if not Result then EI.HWND := WND;
  end;

  function FindMainWindow(PID: DWORD): DWORD;
  var
    EI: TEnumInfo;
  begin
    EI.ProcessID := PID;
    EI.HWND := 0;
    EnumWindows(@EnumWindowsProc, Integer(@EI));
    Result := EI.HWND;
  end;
begin
  if hPID <> 0 then
    Result := FindMainWindow(hPID)
  else
    Result := 0;
end;

function GetProcessId(FileName: string): TStrings; //返回指定程序的进程ID
var
  FSnapshotHandle: THandle;
  FProcessEntry32: TProcessEntry32;
  Ret: BOOL;
  ProcessID: integer;
  ProcessName: string;
  Rs: TStrings;
begin
  Rs := TStringList.Create;
  FSnapshotHandle := CreateToolhelp32Snapshot(TH32CS_SNAPPROCESS, 0);
  FProcessEntry32.dwSize := Sizeof(FProcessEntry32);
  Ret := Process32First(FSnapshotHandle, FProcessEntry32);
  while Ret do
  begin
    ProcessID := FProcessEntry32.th32ProcessID;
    ProcessName := ExtractFileName(FProcessEntry32.szExeFile);
    if (ProcessName = FileName) then
    begin
      Rs.Add(inttostr(ProcessID));
    end;
    result := Rs;
    Ret := Process32Next(FSnapshotHandle, FProcessEntry32);
  end;
end;

//通过进程返回窗体句柄

function GetHwndFromProcess(ProcessId: DWORD): boolean;
  function _EnumWindowsProc(P_HWND: Cardinal; lParam: Cardinal): Boolean; 
  var
    PID: DWORD;
    Title: array[0..500] of Char;
    iTitleLen: integer;
  begin
    GetWindowThreadProcessId(P_HWND, @PID);
    if input_PID <> PID then
      Result := True
    else
    begin
      iTitleLen := GetWindowText(P_HWND, Title, 500);
//      if iTitleLen > 0 then
        hWnd_List.Add(inttostr(P_HWND));
      //Result := False;
    end;
  end;
begin
  Result := false;
  input_PID := ProcessId;
  EnumWindows(@_EnumWindowsProc, 0);
  if hWnd_List.Count > 0 then
    Result := true;
end;

end.

