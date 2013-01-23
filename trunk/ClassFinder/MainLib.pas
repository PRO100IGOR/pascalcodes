unit MainLib;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ExtCtrls;

type
  TMainForm = class(TForm)
    Memo1: TMemo;
    Memo2: TMemo;
    Memo3: TMemo;
    Memo4: TMemo;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
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
  MainForm: TMainForm;
  cc:Boolean;
  x,y:Integer;
implementation

{$R *.dcfm}

procedure TMainForm.Button1Click(Sender: TObject);
begin
    CC := False;
end;

procedure TMainForm.FormCreate(Sender: TObject);
begin
    CC := True;
end;

procedure TMainForm.Timer1Timer(Sender: TObject);
var
  p:TPoint;
  h:Thandle;
  t,c:pchar;
begin
  //获取Mouse位置
  getcursorpos(p);
  if (p.x = x) and (p.y = y) then Exit;
  Memo1.Lines.Add(inttostr(p.x) + ',' + inttostr(p.y));

  //获取handle
  h:=windowfrompoint(p);
  Memo2.Lines.Add('$'+inttohex(h,4));

  //获取window的text
  getmem(t,128);
  GetWindowText(h,t,128);
  Memo3.Lines.Add(t);
  freemem(t);
  //获取classname
  getmem(c,128);
  GetClassName(h,c,128);
  Memo4.Lines.Add(c);
  freemem(c);
end;

end.
