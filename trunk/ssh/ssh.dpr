program ssh;

uses
  Forms,
  MainUnit in 'MainUnit.pas' {Form1},
  AxNetwork_TLB in 'AxNetwork_TLB.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TMainForm, MainForm);
  Application.Run;
end.
