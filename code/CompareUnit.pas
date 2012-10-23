unit CompareUnit;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, bsSkinCtrls, bsSkinBoxCtrls, Mask, BusinessSkinForm,
  ExtCtrls;

type
  TCompareForm = class(TForm)
    bsBusinessSkinForm: TbsBusinessSkinForm;
    bsSkinGroupBox1: TbsSkinGroupBox;
    bsSkinStdLabel2: TbsSkinStdLabel;
    bsSkinStdLabel1: TbsSkinStdLabel;
    bsSkinStdLabel3: TbsSkinStdLabel;
    bsSkinStdLabel4: TbsSkinStdLabel;
    action: TbsSkinComboBox;
    bsSkinButton3: TbsSkinButton;
    bsSkinButton4: TbsSkinButton;
    CPname: TbsSkinComboBox;
    realName: TbsSkinComboBox;
    procedure FormShow(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  CompareForm: TCompareForm;

implementation
uses
  main;
{$R *.dfm}

procedure TCompareForm.FormShow(Sender: TObject);
var
  I:Integer;
begin
    action.ItemIndex := -1;
    CPname.Text := '';
    realName.Text := '';
    CPname.Items.Clear;
    realName.Items.Clear;
    for I := 0 to main.MainForm.NewModelForm.ModelCode.prototypes.Count - 1 do
    begin
        CPname.Items.Add('^'+main.MainForm.NewModelForm.ModelCode.prototypes.Keys[I]);
        realName.Items.Add(main.MainForm.NewModelForm.ModelCode.prototypes.Values[I].comment);
    end;
end;

end.
