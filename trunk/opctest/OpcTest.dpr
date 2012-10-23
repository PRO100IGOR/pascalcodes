program OpcTest;

uses
  Forms,
  iOPCClasses in 'iopc\iOPCClasses.pas',
  iOPCFunctions in 'iopc\iOPCFunctions.pas',
  iOPCItem in 'iopc\iOPCItem.pas',
  iOPCTypes in 'iopc\iOPCTypes.pas',
  Common in 'tool\Common.pas',
  Ini in 'tool\Ini.pas',
  LogsUnit in 'tool\LogsUnit.pas',
  Main in 'Main.pas' {MainForm},
  superobject in 'tool\superobject.pas',
  FormQuery in 'FormQuery.pas' {FormQueryUnit};

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TMainForm, MainForm);
  Application.Run;
end.
