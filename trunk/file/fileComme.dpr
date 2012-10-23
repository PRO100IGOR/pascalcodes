program fileComme;

uses
  Forms,
  Sysutils,
  Windows,
  Dialogs,
  login in 'login.pas' {LoginForm},
  SkinH in 'SkinH.pas',
  ErrorLogsUnit in 'ErrorLogsUnit.pas',
  Common in 'Common.pas',
  UserServer in 'UserServer.pas',
  ConfigUnit in 'ConfigUnit.pas' {Config},
  Ini in 'Ini.pas',
  FlowrunServer in 'FlowrunServer.pas',
  MainForm in 'MainForm.pas' {Main},
  Tip in 'Tip.pas' {TipForm},
  Regedit in 'Regedit.pas',
  Entry in 'Entry.pas',
  GetEnum in 'GetEnum.pas',
  UpdateToolForApi in 'UpdateToolForApi.pas',
  ResourceServer in '..\code\webservice\ResourceServer.pas';

{$R *.res}

begin
  if Pos('fileComme.exe',Application.ExeName) = 0 then
  begin
    ShowMessage('�벻Ҫ�޸ĳ������֣�');
    Exit;
  end;
  Application.Initialize;
  if GetEnum.GetHWndByPIDSource('fileComme.exe') <= 1 then
  begin
    Application.MainFormOnTaskbar := True;
    Application.Title := '��������ϵͳ';
    Application.CreateForm(TLoginForm, LoginForm);
  end;

  Application.Run;
end.
