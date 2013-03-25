unit Main;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, OleCtrls, SHDocVw;

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

implementation

{$R *.dfm}

procedure TForm1.FormCreate(Sender: TObject);
begin
   WebBrowser1.OleObject.document.innerHTML := '<embed src="http://www.xiami.com/widget/803107_6757,6759,6764,6761,6762,6770,6765,6766,6767,6768,6769,'
   +'6771,126908,1769515283,3402703,386530,2561568,2561569,'
   +'2561570,2561571,2561572,2561573,2561574,2561575,2099531,2099533,2099540,2100478,2100482,60008,60009,'
   +'60011,60013,369209,369210,2097675,2440787,2440793,2440798,56622'
   +',1769485698,1769485704,1769485696,1769485703,1769485705,391526,391531,1381754,1379597,51429,_235_346_FF8719_494949_0/multiPlayer.swf" type="application/x-shockwave-flash" width="235" height="346" wmode="opaque"></embed>';
end;

end.
