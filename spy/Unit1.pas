unit Unit1;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ExtCtrls;

type
  TForm1 = class(TForm)
    Bevel1: TBevel;
    Panel1: TPanel;
    Label1: TLabel;
    labelx: TLabel;
    Panel2: TPanel;
    Label3: TLabel;
    labely: TLabel;
    Panel3: TPanel;
    Label5: TLabel;
    labelHandle: TLabel;
    Panel4: TPanel;
    Label7: TLabel;
    labelName: TLabel;
    Timer1: TTimer;
    Panel5: TPanel;
    Label2: TLabel;
    labelText: TLabel;
    procedure Timer1Timer(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form1: TForm1;

implementation

{$R *.dfm}

procedure TForm1.Timer1Timer(Sender: TObject);
var
  p:TPoint;
  h:Thandle;
  t,c:pchar;
begin
  //获取Mouse位置
  getcursorpos(p);
  labelx.caption:=inttostr(p.x);
  labely.caption:=inttostr(p.Y);
  //获取handle
  h:=windowfrompoint(p);
  labelHandle.Caption:='$'+inttohex(h,4);
  //获取window的text
  getmem(t,128);
  GetWindowText(h,t,128);
  labeltext.Caption:=t;
  freemem(t);
  //获取classname
  getmem(c,128);
  GetClassName(h,c,128);
  labelname.caption:=c;
  freemem(c);
end;

end.
