program Opc;

uses
  Forms,
  MainLib in 'MainLib.pas' {MainForm},
  OPC_AE in 'opc\OPC_AE.pas',
  OPCCOMN in 'opc\OPCCOMN.pas',
  OPCDA in 'opc\OPCDA.pas',
  OPCerror in 'opc\OPCerror.pas',
  OPCHDA in 'opc\OPCHDA.pas',
  OPCSEC in 'opc\OPCSEC.pas',
  OPCtypes in 'opc\OPCtypes.pas',
  OPCutils in 'opc\OPCutils.pas',
  BaseTypes in 'BaseTypes.pas',
  Ini in 'tool\Ini.pas',
  LogsUnit in 'tool\LogsUnit.pas',
  superobject in 'tool\superobject.pas',
  TestLib in 'TestLib.pas' {TestForm},
  Common in 'tool\Common.pas',
  ScktComp in 'tool\ScktComp.pas';

{$R *.res}
begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.Title := '四和OPC服务测试程序';
  Application.CreateForm(TMainForm, MainForm);
  Application.CreateForm(TTestForm, TestForm);
  TestForm.Show;
  Application.Run;
end.
