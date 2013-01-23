unit MainForm;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, IdBaseComponent, IdComponent, IdTCPConnection, IdTCPClient,
  IdExplicitTLSClientServerBase, IdFTP, CoolTrayIcon, Menus, StdCtrls, ExtCtrls,Ini;

type
  TMain = class(TForm)
    IdFTP: TIdFTP;
    PopupMenu1: TPopupMenu;
    N1: TMenuItem;
    N2: TMenuItem;
    N3: TMenuItem;
    N4: TMenuItem;
    CoolTrayIcon: TCoolTrayIcon;
    Memo1: TMemo;
    Timer: TTimer;
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormCreate(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure FormHide(Sender: TObject);
    procedure N2Click(Sender: TObject);
    procedure N3Click(Sender: TObject);
    procedure N4Click(Sender: TObject);
    procedure TimerTimer(Sender: TObject);
  private
    { Private declarations }

  public
    { Public declarations }
  end;

var
  Main: TMain;
  Cl,shows:Boolean;
  SavePath : string;
implementation

{$R *.dfm}

procedure TMain.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  if not Cl then
  begin
    if IdFTP.Connected then  IdFTP.Disconnect;
    Hide;
    Abort;
  end;
end;

procedure TMain.FormCreate(Sender: TObject);
begin
    Cl := False;
    SavePath   :=  Ini.ReadIni('server','SavePath');
    IdFTP.Host :=  Ini.ReadIni('server','Host');
    IdFTP.Port :=  StrToInt(Ini.ReadIni('server','Port'));
    IdFTP.Username := Ini.ReadIni('server','Username');
    IdFTP.Password := Ini.ReadIni('server','Password');
    IdFTP.Passive :=   Ini.ReadIni('server','Passive') = 'True';
    IdFTP.Connect;
end;

procedure TMain.FormHide(Sender: TObject);
begin
  shows := True;
end;

procedure TMain.FormShow(Sender: TObject);
begin
  shows := False;
end;

procedure TMain.N2Click(Sender: TObject);
begin
    Show;
end;

procedure TMain.N3Click(Sender: TObject);
begin
   Hide;
end;

procedure TMain.N4Click(Sender: TObject);
begin
     Cl := True;
     Close;
end;

procedure TMain.TimerTimer(Sender: TObject);
var
    Files: TStrings;
    I:Integer;
begin
    if not IdFTP.Connected then IdFTP.Connect;
    if not IdFTP.Connected then Exit;
    IdFTP.Noop;
    Files := TStringList.Create;
    IdFTP.List(Files);
    for I := 0 to Files.Count - 1 do
    begin
        IdFTP.Get(Files[I],SavePath + '/' + Files[I],True);
    end;
    Files.Free;  
end;

end.
