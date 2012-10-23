program AccessSrv;

uses
  Forms,
  main in 'main.pas' {MainForm},
  Common in 'tool\Common.pas',
  Ini in 'tool\Ini.pas',
  LogsUnit in 'tool\LogsUnit.pas',
  superobject in 'tool\superobject.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TMainForm, MainForm);
  Application.Run;
end.
