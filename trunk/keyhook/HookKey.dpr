program HookKey;

uses
  Forms,
  TestHookKey_Unit in 'TestHookKey_Unit.pas' {Form1};

{$R *.RES}

begin
  Application.Initialize;
  Application.CreateForm(TForm1, Form1);
  Application.Run;
end.
