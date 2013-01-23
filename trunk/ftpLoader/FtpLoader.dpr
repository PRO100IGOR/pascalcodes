program FtpLoader;

uses
  Forms,
  MainForm in 'MainForm.pas' {Main};

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.Title := 'ftpœ¬‘ÿπ§æﬂ';
  Application.CreateForm(TMain, Main);
  Application.Run;
end.
