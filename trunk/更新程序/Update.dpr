program Update;

uses
  Forms,
  UpdateLib in 'UpdateLib.pas' {UpdateForm},
  UpdateTool in 'UpdateTool.pas',
  UpdateToolForApi in 'UpdateToolForApi.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.Title := '�ĺͿͻ���ϵͳͨ����������';
  Application.CreateForm(TUpdateForm, UpdateForm);
  Application.Run;
end.
