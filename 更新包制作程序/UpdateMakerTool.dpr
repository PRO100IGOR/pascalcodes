program UpdateMakerTool;

uses
  Forms,
  UpdateMaker in 'UpdateMaker.pas' {Form2};

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TForm2, Form2);
  Application.Run;
end.
