program fastCopy;

uses
  Forms,
  Sysutils,
  Windows,
  Dialogs,
  TLHelp32,
  MainUnit in 'MainUnit.pas' {Main},
  Ini in 'Ini.pas';



function GetHWndByPIDSource(ProgressName: string): Integer;
var
  ProcessName: string;
  FSnapshotHandle: THandle;
  FProcessEntry32: TProcessEntry32;
  ContinueLoop: BOOL;
begin
  Result := 0;
  FSnapshotHandle := CreateToolhelp32Snapshot(TH32CS_SNAPPROCESS, 0);
  FProcessEntry32.dwSize := Sizeof(FProcessEntry32);
  ContinueLoop := Process32First(FSnapshotHandle, FProcessEntry32);
  while ContinueLoop do
  begin
    ProcessName := FProcessEntry32.szExeFile;
    if (ProcessName = ProgressName) then begin
      Inc(Result);
    end;
    ContinueLoop := Process32Next(FSnapshotHandle, FProcessEntry32);
  end;
  CloseHandle(FSnapshotHandle);
end;

{$R *.res}

begin
  sleep(600);
  Application.Initialize;

  if GetHWndByPIDSource('fastCopy.exe') = 1 then
  begin
    Application.MainFormOnTaskbar := True;
    Application.Title := '四和快速复制工具';
    Application.CreateForm(TMain, Main);
    Application.Run;
  end;
end.
