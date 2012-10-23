program code;

uses
  Forms,
  main in 'main.pas' {MainForm},
  Ini in 'tool\Ini.pas',
  ErrorLogsUnit in 'tool\ErrorLogsUnit.pas',
  index in 'frames\index.pas' {IndexForm: TFrame},
  UpdatePro in 'frames\UpdatePro.pas' {UpdateProForm: TFrame},
  newFrames in 'frames\newFrames.pas' {NewProForm: TFrame},
  newModelUni in 'frames\newModelUni.pas' {NewModelForm: TFrame},
  UpdateTool in 'tool\UpdateTool.pas',
  Common in 'tool\Common.pas',
  OneUnit in 'frames\newModel\OneUnit.pas' {OneModel: TFrame},
  TwoUnit in 'frames\newModel\TwoUnit.pas' {TwoModel: TFrame},
  ThreeUnit in 'frames\newModel\ThreeUnit.pas' {ThreeModel: TFrame},
  FourUnit in 'frames\newModel\FourUnit.pas' {FourMoel: TFrame},
  ModelLib in 'domain\ModelLib.pas',
  getDataLib in 'getDataLib.pas' {GetData},
  MethodForms in 'MethodForms.pas' {MethodForm},
  EventForms in 'EventForms.pas' {EventForm},
  RuleFormUnit in 'RuleFormUnit.pas' {RuleFactory},
  RulesUnit in 'RulesUnit.pas' {RulesChoose},
  TypesUnit in 'TypesUnit.pas' {TypesForm},
  CompareUnit in 'CompareUnit.pas' {CompareForm},
  CodeMakerLib in 'CodeMakerLib.pas' {CodeMaker},
  WebLib in 'WebLib.pas' {WebForm},
  UpdateToolForApi in 'tool\UpdateToolForApi.pas',
  WebService in 'WebService.pas' {WebServiceForm},
  newMobile in 'frames\newMobile.pas' {MobileFream: TFrame},
  ApplicationServer in 'webservice\ApplicationServer.pas',
  ResourceServer in 'webservice\ResourceServer.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.Title := '´úÂëÉú³ÉÆ÷';
  Application.CreateForm(TMainForm, MainForm);
  Application.Run;
end.
