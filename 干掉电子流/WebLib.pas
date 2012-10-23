unit WebLib;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, OleCtrls, SHDocVw;

type
  TWebForm = class(TForm)
    WebBrowser: TWebBrowser;
    procedure WebBrowserDocumentComplete(ASender: TObject;
      const pDisp: IDispatch; var URL: OleVariant);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  WebForm: TWebForm;

implementation

{$R *.dfm}
  uses
    main;

procedure TWebForm.WebBrowserDocumentComplete(ASender: TObject;
  const pDisp: IDispatch; var URL: OleVariant);
begin
  if WebBrowser.Application = pDisp then
  begin
      MainForm.doweb;
  end;
end;

end.
