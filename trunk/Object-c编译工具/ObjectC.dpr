program ObjectC;

uses
  Forms,
  Main in 'Main.pas' {MainForm},
  GetFile in 'GetFile.pas' {Form1};

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TMainForm, MainForm);
  Application.CreateForm(TForm1, Form1);
  Application.Run;
end.
