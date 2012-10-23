unit newserversock;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, SUIButton;

type
  TfrmNewServerSock = class(TForm)
    Edit1: TEdit;
    Label1: TLabel;
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
  frmNewServerSock: TfrmNewServerSock;
  ServerPort:integer;

implementation

{$R *.dfm}

procedure TfrmNewServerSock.Button1Click(Sender: TObject);
begin
  ServerPort:=strtoint(edit1.text);
  ModalResult := mrOK;
end;

procedure TfrmNewServerSock.Button2Click(Sender: TObject);
begin
  ModalResult := mrCancel;
end;

end.
