program fastCopy;

uses
  Forms,
  MainUnit in 'MainUnit.pas' {Main},
  Ini in 'Ini.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TMain, Main);
  Application.Run;
end.
