unit MainForm;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, OleCtrls, SHDocVw,ExternalContainer;

type
  TForm1 = class(TForm)
    WebBrowser1: TWebBrowser;
    procedure FormCreate(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form1: TForm1;
  A :TExternalContainer;
implementation

{$R *.dfm}

procedure TForm1.FormCreate(Sender: TObject);
begin
    A := TExternalContainer.Create(WebBrowser1);
    WebBrowser1.Navigate(ExtractFilePath(Application.ExeName) + 'index.htm');
end;

end.
