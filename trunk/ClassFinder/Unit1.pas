unit Unit1;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ExtCtrls, StdCtrls;

type
  TForm1 = class(TForm)
    Memo4: TMemo;
    Button1: TButton;
    Timer1: TTimer;
    procedure Button1Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure Timer1Timer(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form1: TForm1;
  cc:Boolean;
implementation

{$R *.dfm}

procedure TForm1.Button1Click(Sender: TObject);
begin
        CC := False;
end;

procedure TForm1.FormCreate(Sender: TObject);
begin
        CC := True;
end;

procedure TForm1.Timer1Timer(Sender: TObject);
var
  p:TPoint;
  h:Thandle;
  t,c:pchar;
begin
  //��ȡMouseλ��
  if not CC then Exit;
  getcursorpos(p);

  //��ȡhandle
  h:=windowfrompoint(p);

  //��ȡwindow��text
  getmem(t,128);
  GetWindowText(h,t,128);

  freemem(t);
  //��ȡclassname
  getmem(c,128);
  GetClassName(h,c,128);


  if Memo4.Lines.IndexOf(c) = -1 then
  begin
     Memo4.Lines.Add(c);
  end;

  freemem(c);

end;

end.
