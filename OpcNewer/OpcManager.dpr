program OpcManager;

uses
  Forms,
  MainManagerLib in 'MainManagerLib.pas' {MainForm},
  Common in 'tool\Common.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.Title := '�ĺ�OPC�������';
  Application.CreateForm(TMainForm, MainForm);
  Application.Run;
end.
