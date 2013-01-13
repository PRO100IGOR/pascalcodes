program OpcManager;

uses
  Forms,
  MainManagerLib in 'MainManagerLib.pas' {MainForm},
  Common in 'tool\Common.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.Title := '四和OPC服务管理';
  Application.CreateForm(TMainForm, MainForm);
  Application.Run;
end.
