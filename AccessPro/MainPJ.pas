unit MainPJ;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs,shellApi, StdCtrls,tools,Clipbrd;

type
  TForm1 = class(TForm)
    Memo1: TMemo;
    procedure FormCreate(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
    procedure WM_Dropfiles(var Msg:Tmessage);message WM_Dropfiles;
  end;

var
  Form1: TForm1;

implementation

{$R *.dfm}


procedure TForm1.FormCreate(Sender: TObject);
begin
    DragAcceptFiles(Handle,True);
end;

procedure TForm1.WM_Dropfiles(var Msg:Tmessage);
var
  I,Num:Integer;
  Name: array [0..254] of char;
  FileName :string;
  Pass : PassType;
  H:Boolean;
begin
  Num := DragQueryFile(Msg.WParam,$FFFFFFFF,nil,0); //¸öÊý
  H := False;
  for I := 0 to Num - 1 do
  begin
      DragQueryFile(Msg.WParam,I,Name,255);
      FileName := StrPas(Name);
      if LowerCase(Copy(FileName,LastDelimiter('.',FileName)+1,100)) = 'mdb' then
      begin
         Pass:= Tools.ExecFile(FileName);
         Memo1.Lines.Add(FileName + ' >>> ' + Pass.PassCode);
         H := True;
      end;
  end;
  if (Num = 1) and H  then
  begin
     Clipboard.AsText := Pass.PassCode;
  end;
  
end;

end.
