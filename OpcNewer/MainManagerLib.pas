unit MainManagerLib;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ExtCtrls, StdCtrls;

type
  TForm2 = class(TForm)
    GroupBox1: TGroupBox;
    ServerColor: TShape;
    ServerState: TLabel;
    btnStopStart: TButton;
    btnClearLog: TButton;
    btnInstallUnInstall: TButton;
    btnAccessPj: TButton;
    LogMemo: TMemo;
    Timer: TTimer;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form2: TForm2;

implementation

{$R *.dfm}

end.
