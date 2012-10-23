unit newclientsock;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls,netcardinfo, SUIButton;

type
  TfrmNewClientSock = class(TForm)
    Edit1: TEdit;
    Edit2: TEdit;
    Label1: TLabel;
    Label2: TLabel;
    Button1: TsuiButton;
    Button2: TsuiButton;
    procedure Button1Click(Sender: TObject);
    procedure FormActivate(Sender: TObject);
    procedure Button2Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  clientsock_remoteport:integer;
  clientsock_remotehost:string;
  frmNewClientSock: TfrmNewClientSock;

implementation

{$R *.dfm}

procedure TfrmNewClientSock.Button1Click(Sender: TObject);
begin
  clientsock_remotehost:=edit1.text;
  clientsock_remoteport:=strtoint(edit2.text);
  ModalResult := mrOK;
end;

procedure TfrmNewClientSock.FormActivate(Sender: TObject);
begin
 edit1.text:=getlocalip;
end;

procedure TfrmNewClientSock.Button2Click(Sender: TObject);
begin
 ModalResult := mrcancel;
end;

end.
