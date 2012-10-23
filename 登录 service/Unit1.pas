unit Unit1;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs,UserServer, StdCtrls;

type
  TForm1 = class(TForm)
    Memo1: TMemo;
    procedure FormCreate(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form1: TForm1;

implementation

{$R *.dfm}

procedure TForm1.FormCreate(Sender: TObject);
var
  AUserServerPortType : UserServerPortType;
begin
  AUserServerPortType := GetUserServerPortType;
  Memo1.Lines.Add(
    AUserServerPortType.login('{"username":"yd","password":"888888","android":"dd74de7abe4e6208","type":"tree","appcode":"XTGL"}')
  );
end;

end.
