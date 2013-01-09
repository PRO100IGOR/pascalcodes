program TaskRunerView;

uses
  Forms,
  MainRunLib in 'MainRunLib.pas' {MainView},
  ErrorLogsUnit in 'ErrorLogsUnit.pas',
  Tools in 'Tools.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.Title := '四和Access数据采集';
  Application.CreateForm(TMainView, MainView);
  Application.Run;
end.
