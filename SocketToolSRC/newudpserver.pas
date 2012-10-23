unit newudpserver;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, SUIButton;

type
  TfrmNewUDPServer = class(TForm)
    Label3: TLabel;
    Edit3: TEdit;
    Button1: TsuiButton;
    Button2: TsuiButton;
    procedure Button1Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  frmNewUDPServer: TfrmNewUDPServer;
  udpserver_localport:integer;

implementation

uses newudpsock;
{$R *.dfm}

procedure TfrmNewUDPServer.Button1Click(Sender: TObject);
begin
  udpserver_localport:=strtoint(edit3.Text);
  if isudpportused(udpserver_localport) then
  begin
     showmessage('本地端口已被占用，请重新选择本地端口号');
     exit;
  end;
  ModalResult := mrOK;
end;

procedure TfrmNewUDPServer.Button2Click(Sender: TObject);
begin
   ModalResult := mrCancel;
end;

end.
