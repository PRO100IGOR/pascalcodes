program DataColler;

uses
  Forms,
  MainLib in 'MainLib.pas' {MainForm},
  Ini in 'Ini.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TMainForm, MainForm);
  Application.Run;
end.
