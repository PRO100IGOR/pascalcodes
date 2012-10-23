program ModBusTest;

uses
  Forms,
  Main in 'Main.pas' {MainForm},
  Box in 'Box.pas' {PControl: TFrame},
  Common in 'Common.pas',
  Ini in 'Ini.pas',
  ModBusLoad in 'ModBusLoad.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TMainForm, MainForm);
  Application.Run;
end.
