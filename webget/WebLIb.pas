unit WebLIb;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, OleCtrls, SHDocVw;

type
  TWebForm = class(TForm)
    WebBrowser: TWebBrowser;
    procedure WebBrowserNewWindow2(ASender: TObject; var ppDisp: IDispatch;
      var Cancel: WordBool);
    procedure WebBrowserDocumentComplete(ASender: TObject;
      const pDisp: IDispatch; var URL: OleVariant);
  private
    { Private declarations }
  public
    { Public declarations }
    OldProgress : Integer;
  end;

var
  WebForm: TWebForm;

implementation

uses
    MainLib;
{$R *.dfm}

procedure TWebForm.WebBrowserDocumentComplete(ASender: TObject;
  const pDisp: IDispatch; var URL: OleVariant);
begin
  if not WebBrowser.Busy then MainForm.doweb(ASender);

end;



procedure TWebForm.WebBrowserNewWindow2(ASender: TObject; var ppDisp: IDispatch;
  var Cancel: WordBool);
begin
     ppDisp := MainLib.WebForm2.WebBrowser.Application;
end;

end.
