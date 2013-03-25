program OpcServers;

uses
  SvcMgr,
  BaseTypes in 'BaseTypes.pas',
  Hashes in 'Hashes.pas',
  MainLib in 'MainLib.pas' {MainForm},
  MainServer in 'MainServer.pas' {SiheOpc: TService},
  Common in 'tool\Common.pas',
  Ini in 'tool\Ini.pas',
  LogsUnit in 'tool\LogsUnit.pas',
  superobject in 'tool\superobject.pas',
  OPC_AE in 'opc\OPC_AE.pas',
  OPCCOMN in 'opc\OPCCOMN.pas',
  OPCDA in 'opc\OPCDA.pas',
  OPCerror in 'opc\OPCerror.pas',
  OPCHDA in 'opc\OPCHDA.pas',
  OPCSEC in 'opc\OPCSEC.pas',
  OPCtypes in 'opc\OPCtypes.pas',
  OPCutils in 'opc\OPCutils.pas';

{$R *.RES}

begin
  // Windows 2003 Server requires StartServiceCtrlDispatcher to be
  // called before CoRegisterClassObject, which can be called indirectly
  // by Application.Initialize. TServiceApplication.DelayInitialize allows
  // Application.Initialize to be called from TService.Main (after
  // StartServiceCtrlDispatcher has been called).
  //
  // Delayed initialization of the Application object may affect
  // events which then occur prior to initialization, such as
  // TService.OnCreate. It is only recommended if the ServiceApplication
  // registers a class object with OLE and is intended for use with
  // Windows 2003 Server.
  //
  // Application.DelayInitialize := True;
  //
  if not Application.DelayInitialize or Application.Installing then
    Application.Initialize;
  Application.CreateForm(TSiheOpc, SiheOpc);
  Application.CreateForm(TMainForm, MainForm);
  Application.Run;
end.
