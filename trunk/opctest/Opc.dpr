program Opc;

uses
  SvcMgr,
  OpcServer in 'OpcServer.pas' {siheopc: TService},
  Main in 'Main.pas' {MainForm},
  Common in 'tool\Common.pas',
  Ini in 'tool\Ini.pas',
  LogsUnit in 'tool\LogsUnit.pas',
  superobject in 'tool\superobject.pas',
  iOPCClasses in 'iopc\iOPCClasses.pas',
  iOPCFunctions in 'iopc\iOPCFunctions.pas',
  iOPCItem in 'iopc\iOPCItem.pas',
  iOPCTypes in 'iopc\iOPCTypes.pas',
  FormQuery in 'FormQuery.pas' {FormQueryUnit};

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
  Application.CreateForm(Tsiheopc, siheopc);
  Application.CreateForm(TFormQueryUnit, FormQueryUnit);
  Application.Run;
end.
