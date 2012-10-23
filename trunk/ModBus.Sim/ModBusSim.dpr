program ModBusSim;

uses
  Forms,
  Main in 'Main.pas' {MainForm},
  Common in 'Common.pas',
  Ini in 'Ini.pas',
  SPCOMM in 'SPCOMM.PAS',
  Box in 'Box.pas' {PControl: TFrame};

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TMainForm, MainForm);
  Application.Run;
end.
