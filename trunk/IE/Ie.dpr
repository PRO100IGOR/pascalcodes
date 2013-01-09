program Ie;

uses
  Forms,
  Main in 'Main.pas' {MainForm};

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.Title := '´¥ÃþÆÁÏÔÊ¾³ÌÐò';
  if ParamCount >= 1 then
  begin
      Main.Urls := ParamStr(1);
  end;
  Application.CreateForm(TMainForm, MainForm);
  Application.Run;
end.
