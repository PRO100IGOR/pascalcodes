program ObjectC;

uses
  Forms,
  Main in 'Main.pas' {MainForm},
  Common in 'Common.pas',
  Ini in 'Ini.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.Title := 'Object - c';
  Application.CreateForm(TMainForm, MainForm);
  Application.Run;
end.
