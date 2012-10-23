unit MethodForms;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, bsSkinCtrls, bsSkinBoxCtrls, StdCtrls, BusinessSkinForm,Common,
  ExtCtrls;

type
  TMethodForm = class(TForm)
    bsBusinessSkinForm: TbsBusinessSkinForm;
    bsSkinGroupBox1: TbsSkinGroupBox;
    bsSkinStdLabel6: TbsSkinStdLabel;
    bsSkinStdLabel1: TbsSkinStdLabel;
    appName: TbsSkinCheckComboBox;
    chkName: TbsSkinComboBox;
    bsSkinButton3: TbsSkinButton;
    bsSkinButton4: TbsSkinButton;
    procedure FormShow(Sender: TObject);
    procedure FormCreate(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  MethodForm: TMethodForm;

implementation

uses
    main;
{$R *.dfm}

procedure TMethodForm.FormCreate(Sender: TObject);
begin
  chkName.Items := Common.getValueFromServer('checkNames.txt',main.Path);
  appName.Items := Common.getValueFromServer('appendNames.txt',main.Path);
end;

procedure TMethodForm.FormShow(Sender: TObject);
begin
     chkName.ItemIndex := -1;
     appName.Text := '';
end;

end.
