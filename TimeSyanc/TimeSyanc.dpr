program TimeSyanc;

uses
  Forms,SysUtils,
  Main in 'Main.pas' {MainForm};

{$R *.res}

begin
  //2��������url maxtimes
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.Title := 'ʱ��ͬ������';
  if ParamCount >= 2 then
  begin
      Main.url := ParamStr(1);
      Main.times := StrToInt(ParamStr(2));
  end;
  Application.CreateForm(TMainForm, MainForm);
  Application.Run;
end.
