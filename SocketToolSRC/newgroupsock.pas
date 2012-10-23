unit newgroupsock;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, SUIButton;

type
  TfrmNewGroupSock = class(TForm)
    Edit1: TEdit;
    Label1: TLabel;
    Label2: TLabel;
    Edit2: TEdit;
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
  frmNewGroupSock: TfrmNewGroupSock;
  udpgroup_localport:integer;
  udpgroup_localip:string;
implementation

{$R *.dfm}

procedure TfrmNewGroupSock.Button1Click(Sender: TObject);
begin
  udpgroup_localip:=edit1.text;
  udpgroup_localport:=strtoint(edit2.text);
  modalresult:=mrOk;
end;

procedure TfrmNewGroupSock.Button2Click(Sender: TObject);
begin
  modalresult:=mrCancel;
end;

end.
