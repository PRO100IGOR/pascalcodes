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
  Application.Title := '�ĺ�Access���ݿ����ݽ�������';
  Application.CreateForm(TMainForm, MainForm);
  Application.Run;
end.
