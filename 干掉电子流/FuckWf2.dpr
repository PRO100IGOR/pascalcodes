program FuckWf2;

uses
  Forms,
  main in 'main.pas' {MainForm},
  WebLib in 'WebLib.pas' {WebForm},
  Ini in 'Ini.pas',
  ErrorLogsUnit in 'ErrorLogsUnit.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TMainForm, MainForm);
  Application.Run;
end.
