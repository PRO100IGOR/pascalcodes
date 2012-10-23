unit main;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls,FileCtrl;

type
  TForm1 = class(TForm)
    Memo1: TMemo;
    lbl7: TLabel;
    SystemPath: TEdit;
    btn5: TButton;
    Button1: TButton;
    procedure btn5Click(Sender: TObject);
    procedure Button1Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }   
    function getAllFilesFromDir(dir:string;p:string):TStrings;
  end;

var
  Form1: TForm1;

implementation

{$R *.dfm}

function TForm1.getAllFilesFromDir(dir:string;p:string):TStrings; //从dir中获取全部指定类型的文件名
var
  sr:TSearchRec;
  temp:TStrings;
begin
    temp := TStringList.Create;
    if SysUtils.FindFirst(dir + '\'+p, faAnyFile, sr) = 0 then
    begin
      repeat
        if (sr.Name<>'.') and (sr.Name<>'..') then
        begin
          temp.Add(sr.Name);
        end;
      until SysUtils.FindNext(sr) <> 0;
      SysUtils.FindClose(sr);
    end;
    Result := temp;
end;



procedure TForm1.btn5Click(Sender: TObject);
var
  dir: string;
begin
  if Filectrl.SelectDirectory('选择目录', '', dir) then
  begin
    SystemPath.Text := dir;
  end;
end;

procedure TForm1.Button1Click(Sender: TObject);
var
  s:TStrings;
  i:integer;
begin
  s := getAllFilesFromDir(SystemPath.Text,'*.jar');
  for I := 0 to s.Count - 1 do
  begin
    Memo1.Text := Memo1.text + s[i] + ';';
  end;
end;

end.
