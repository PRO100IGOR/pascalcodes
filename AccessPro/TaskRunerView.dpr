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
  Application.Title := '�ĺ�Access���ݲɼ�';
  Application.CreateForm(TMainView, MainView);
  Application.Run;
end.
