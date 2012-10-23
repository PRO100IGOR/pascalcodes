program fileControl;

uses
  Forms,
  main in 'main.pas' {MainForm},
  Base in '..\..\base\Base.pas',
  Consts in '..\..\base\Consts.pas',
  BaseServerLib in '..\..\sql\BaseServerLib.pas',
  AccessLib in '..\..\sql\access\AccessLib.pas',
  MySqlLib in '..\..\sql\mysql\MySqlLib.pas',
  Common in '..\..\tool\Common.pas',
  PrintLib in '..\..\sql\mysql\PrintLib.pas',
  LogsUnit in '..\..\tool\LogsUnit.pas',
  FireDwr in '..\..\web\FireDwr.pas',
  Ini in '..\..\tool\Ini.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TMainForm, MainForm);
  Application.Run;
end.
