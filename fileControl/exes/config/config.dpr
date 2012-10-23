program config;

uses
  Forms,
  main in 'main.pas' {mainForm},
  AccessLib in '..\..\sql\access\AccessLib.pas',
  Common in '..\..\tool\Common.pas',
  BaseServerLib in '..\..\sql\BaseServerLib.pas',
  Base in '..\..\base\Base.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TmainForm, mainForm);
  Application.Run;
end.
