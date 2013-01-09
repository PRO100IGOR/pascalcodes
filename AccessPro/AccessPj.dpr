program AccessPj;

uses
  Forms,
  MainPJ in 'MainPJ.pas' {Form1},
  Tools in 'Tools.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.Title := 'Access√‹¬Î∆∆Ω‚';
  Application.CreateForm(TForm1, Form1);
  Application.Run;
end.
