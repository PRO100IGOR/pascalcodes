program Update;

uses
  Forms,
  UpdateLib in 'UpdateLib.pas' {UpdateForm},
  UpdateTool in 'UpdateTool.pas',
  UpdateToolForApi in 'UpdateToolForApi.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.Title := '四和客户端系统通用升级程序';
  Application.CreateForm(TUpdateForm, UpdateForm);
  Application.Run;
end.
