unit WebLib;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, OleCtrls, SHDocVw, StdCtrls, BusinessSkinForm;

type
  TWebForm = class(TForm)
    WebBrowser: TWebBrowser;
    bsBusinessSkinForm: TbsBusinessSkinForm;
    result: TMemo;
    procedure WebBrowserDocumentComplete(ASender: TObject;
      const pDisp: IDispatch; var URL: OleVariant);
    procedure WebBrowserNavigateError(ASender: TObject; const pDisp: IDispatch;
      var URL, Frame, StatusCode: OleVariant; var Cancel: WordBool);
  private
    { Private declarations }
    OldProgress:Integer;
  public
    { Public declarations }
  end;

var
  WebForm: TWebForm;


implementation
uses
  CodeMakerLib;
{$R *.dfm}

procedure TWebForm.WebBrowserDocumentComplete(ASender: TObject;
  const pDisp: IDispatch; var URL: OleVariant);
begin
  if WebBrowser.Application = pDisp then
  begin
     CodeMaker.createFile();
  end;
end;

procedure TWebForm.WebBrowserNavigateError(ASender: TObject;
  const pDisp: IDispatch; var URL, Frame, StatusCode: OleVariant;
  var Cancel: WordBool);
begin
    CodeMaker.logMemo.Lines.Add('º”‘ÿƒ£∞Ê£∫'+URL+' ß∞‹£°£°');
end;

end.
