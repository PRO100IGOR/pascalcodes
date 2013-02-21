program OpcDesTop;

uses
  Forms,
  Sysutils,
  Windows,
  Dialogs,
  TLHelp32,
  MainLib in 'MainLib.pas' {MainForm},
  OPC_AE in 'opc\OPC_AE.pas',
  OPCCOMN in 'opc\OPCCOMN.pas',
  OPCDA in 'opc\OPCDA.pas',
  OPCerror in 'opc\OPCerror.pas',
  OPCHDA in 'opc\OPCHDA.pas',
  OPCSEC in 'opc\OPCSEC.pas',
  OPCtypes in 'opc\OPCtypes.pas',
  OPCutils in 'opc\OPCutils.pas',
  Common in 'tool\Common.pas',
  Ini in 'tool\Ini.pas',
  LogsUnit in 'tool\LogsUnit.pas',
  ScktComp in 'tool\ScktComp.pas',
  superobject in 'tool\superobject.pas';

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
  if ExtractFileName(Application.ExeName) <> 'OpcDesTop.exe' then
  begin
    ShowMessage('请不要修改程序名字！');
    Exit;
  end;
  Application.Initialize;
  if GetHWndByPIDSource('OpcDesTop.exe') = 1 then
  begin
    Application.MainFormOnTaskbar := False;
    Application.CreateForm(TMainForm, MainForm);
    MainForm.CoolTrayIcon.IconVisible := True;
    MainForm.CoolTrayIcon.Enabled := True;
    Application.Run;
  end;
end.
