unit MainLoader;

interface

uses
  Windows, Messages, Ini,ShellAPI,SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs;

type
  TLoaderForm = class(TForm)
    procedure FormShow(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  LoaderForm: TLoaderForm;

implementation

{$R *.dfm}

procedure TLoaderForm.FormShow(Sender: TObject);
var
  FileName :string;
  ProcID: Cardinal;
begin
    FileName := Ini.ReadIni('server','file');
    ShellExecute(Application.Handle, nil, pchar(FileName), nil,nil, SW_SHOW);
   // Application.Terminate;
end;

end.
