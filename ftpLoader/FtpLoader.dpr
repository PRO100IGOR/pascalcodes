program FtpLoader;

uses
  Forms,
  MainForm in 'MainForm.pas' {Main};

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.Title := 'ftp���ع���';
  Application.CreateForm(TMain, Main);
  Application.Run;
end.
