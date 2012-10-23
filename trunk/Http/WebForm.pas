unit WebForm;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, OleCtrls, SHDocVw;

type
  TWeb = class(TForm)
    WebBrowser: TWebBrowser;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Web: TWeb;

implementation

{$R *.dfm}

end.
