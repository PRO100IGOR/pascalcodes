program WebGet;

uses
  Forms,
  MainLib in 'MainLib.pas' {MainForm},
  WebLIb in 'WebLIb.pas' {WebForm},
  Ini in 'Ini.pas',
  ErrorLogsUnit in 'ErrorLogsUnit.pas',
  Common in 'Common.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.Title := '四和对司马OA报表采集程序';
  Application.CreateForm(TMainForm, MainForm);
  Application.Run;
end.
