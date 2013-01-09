program GetACPass;

uses
Forms,
GetAPass in 'GetAPass.pas' {PassForm};

{$R *.res}

begin
Application.Initialize;
Application.CreateForm(TPassForm, PassForm);
Application.Run;
end.
