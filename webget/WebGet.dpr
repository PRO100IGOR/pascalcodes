program WebGet;

uses
  Forms,
  Sysutils,
  Windows,
  Dialogs,
  TLHelp32,
  MainLib in 'MainLib.pas' {MainForm},
  WebLIb in 'WebLIb.pas' {WebForm},
  Ini in 'Ini.pas',
  ErrorLogsUnit in 'ErrorLogsUnit.pas',
  Common in 'Common.pas';



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
  if ExtractFileName(Application.ExeName) <> 'WebGet.exe' then
  begin
    ShowMessage('请不要修改程序名字！');
    Exit;
  end;
  Application.Initialize;
  if GetHWndByPIDSource('WebGet.exe') <= 1 then
  begin
    Application.MainFormOnTaskbar := True;
    Application.Title := '四和对司马OA报表采集程序';
    Application.CreateForm(TMainForm, MainForm);
    Application.Run;
  end;

end.
