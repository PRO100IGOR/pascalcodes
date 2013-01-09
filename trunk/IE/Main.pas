unit Main;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, OleCtrls, SHDocVw, ExtCtrls;

type
  TMainForm = class(TForm)
    WebBrowser: TWebBrowser;
    Timer: TTimer;
    procedure FormCreate(Sender: TObject);
    procedure TimerTimer(Sender: TObject);
    procedure WebBrowserDocumentComplete(ASender: TObject;
      const pDisp: IDispatch; var URL: OleVariant);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  MainForm: TMainForm;
  Urls:string;
implementation

{$R *.dfm}

procedure TMainForm.FormCreate(Sender: TObject);
begin
    Width := Screen.Width;
    Height := Screen.Height;
    FormStyle := fsStayOnTop;
    if Urls = '' then
       Urls := 'http://127.0.0.1:8083/dscm';
    Timer.Enabled := True;
end;


procedure TMainForm.TimerTimer(Sender: TObject);
begin
      Timer.Enabled := False;
     WebBrowser.Navigate(Urls);
end;

procedure TMainForm.WebBrowserDocumentComplete(ASender: TObject;
  const pDisp: IDispatch; var URL: OleVariant);
begin
      if (WebBrowser.LocationName <> '¶«É½Ãº¿ó»¶Ó­Äú') then

       Timer.Enabled := True;
end;

end.
