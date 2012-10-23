unit Unit2;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls,UserServer;

type
  TForm2 = class(TForm)
    Edit1: TEdit;
    Label1: TLabel;
    Label2: TLabel;
    Edit2: TEdit;
    Button1: TButton;
    Edit3: TEdit;
    Label3: TLabel;
    Edit4: TEdit;
    Label4: TLabel;
    procedure Button1Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form2: TForm2;

implementation

{$R *.dfm}

function encode(text:String):string;
var
  i, len: Integer;
  cur: Integer;
  t: string;
  ws: WideString;
begin
  Result := '';
  ws := text;
  len := Length(ws);
  i := 1;
  while i <= len do
  begin
    cur := Ord(ws[i]);
    if cur > 255 then
    begin
        FmtStr(t, '%4.4X', [cur]);
        Result := Result + '^' + LowerCase(t);
    end
    else
    begin
        if ((cur < 48) or ((cur > 57) and (cur < 65)) or ( (cur > 90) and (cur < 97)) or (cur > 122)) then
        begin
          FmtStr(t, '%2.2X', [cur]);
          Result := Result + '~' + LowerCase(t);
        end
        else
        begin
           Result := Result + ws[i];
        end;

    end;
    Inc(i);
  end;
end;

procedure TForm2.Button1Click(Sender: TObject);
var
  AUserServerPortType : UserServerPortType;
begin
  AUserServerPortType := GetUserServerPortType(True,Edit1.Text,nil);
  ShowMessage(  AUserServerPortType.sendTokenData('{"appcode":"'+Edit3.Text+'","rescode":"'+Edit4.Text+'","type":"ipad","info":"'+encode(Edit2.Text)+'","organcode":"LAJT","up":"false"}'));
  AUserServerPortType._Release;
end;

end.
