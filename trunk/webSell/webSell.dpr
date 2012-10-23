program webSell;

uses
  Forms,
  loginForm in 'loginForm.pas' {TLoginForm},
  SkinH in 'tool\SkinH.pas',
  superobject in 'tool\superobject.pas',
  DocHostUIHandler in 'tool\DocHostUIHandler.pas',
  MainForm in 'MainForm.pas' {Form1},
  TlbImpl in 'tool\TlbImpl.pas',
  NulContainer in 'tool\NulContainer.pas',
  Magican_TLB in 'tool\Magican_TLB.pas',
  ExternalContainer in 'ExternalContainer.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TForm1, Form1);
  Application.Run;
end.
