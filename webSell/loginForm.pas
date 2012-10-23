unit loginForm;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs,SkinH,  StdCtrls, Buttons, jpeg, ExtCtrls;

type
  TTLoginForm = class(TForm)
    Label1: TLabel;
    Label2: TLabel;
    UserName: TComboBox;
    PassWord: TEdit;
    Rem: TCheckBox;
    BOK: TBitBtn;
    Image1: TImage;
    procedure FormCreate(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  TLoginForm: TTLoginForm;

implementation

{$R *.dfm}

procedure TTLoginForm.FormCreate(Sender: TObject);
begin
    SkinH_AttachEx('china.she', '');
end;

end.
