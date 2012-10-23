program OracleClient;

uses
  Forms,
  AccessForTns in 'AccessForTns.pas',
  Common in 'Common.pas',
  MainUnit in 'MainUnit.pas' {MainForm},
  ENUtil in 'ENUtil.pas',
  RegeditUnit in 'RegeditUnit.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.Title := 'Oracle客户端设置工具';
  Application.CreateForm(TMainForm, MainForm);
  Application.Run;
end.
