unit ConfigUnit;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ExtCtrls, StdCtrls, Ini,Regedit;

type
  TConfig = class(TForm)
    http: TEdit;
    Label1: TLabel;
    cmdLogin: TButton;
    Image2: TImage;
    Label2: TLabel;
    Label3: TLabel;
    edtport: TEdit;
    AutoRun: TCheckBox;
    procedure FormCreate(Sender: TObject);
    procedure cmdLoginClick(Sender: TObject);
    procedure AutoRunClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Config: TConfig;
implementation

{$R *.dfm}

procedure TConfig.AutoRunClick(Sender: TObject);
begin
Regedit.SetAutoRun(AutoRun.Checked);
end;

procedure TConfig.cmdLoginClick(Sender: TObject);
begin
   Ini.WriteIni('server','ip',http.Text);
   Ini.WriteIni('server','port',edtport.Text);
   Close;
end;

procedure TConfig.FormCreate(Sender: TObject);
begin
    http.Text := Ini.ReadIni('server','ip');
    edtport.Text := Ini.ReadIni('server','port');
    AutoRun.Checked := Regedit.getAutoRun;
end;

end.
