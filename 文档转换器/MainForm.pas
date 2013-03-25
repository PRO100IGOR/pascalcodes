unit MainForm;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls,Comobj,OleAuto;
const
  wdExportFormatPDF = 17;
type
  TForm1 = class(TForm)
    OpenDialog1: TOpenDialog;
    SaveDialog1: TSaveDialog;
    Button1: TButton;
    procedure Button1Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form1: TForm1;

implementation

{$R *.dfm}

procedure TForm1.Button1Click(Sender: TObject);
var
   Word, Doc: OleVariant;
begin
   if OpenDialog1.Execute(Handle) then
   begin
      Word := CreateOLEObject('Word.Application');
      Doc := Word.Documents.Open(OpenDialog1.FileName);
      Doc.ExportAsFixedFormat(SaveDialog1.FileName, wdExportFormatPDF);
   end;
end;

end.
