program TaskManager;

uses
  Forms,
  MainLib in 'MainLib.pas' {MainForm},
  Tools in 'Tools.pas',
  ErrorLogsUnit in 'ErrorLogsUnit.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.Title := '四和Access数据库数据交换工具';
  Application.CreateForm(TMainForm, MainForm);
  Application.Run;
end.
