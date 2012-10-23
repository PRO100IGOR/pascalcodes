unit EventForms;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, bsSkinCtrls, bsSkinBoxCtrls,Common, BusinessSkinForm,
  ExtCtrls;

type
  TEventForm = class(TForm)
    bsBusinessSkinForm: TbsBusinessSkinForm;
    bsSkinGroupBox1: TbsSkinGroupBox;
    bsSkinStdLabel6: TbsSkinStdLabel;
    bsSkinStdLabel1: TbsSkinStdLabel;
    bsSkinStdLabel2: TbsSkinStdLabel;
    appName: TbsSkinCheckComboBox;
    events: TbsSkinComboBox;
    chkName: TbsSkinComboBox;
    bsSkinButton3: TbsSkinButton;
    bsSkinButton4: TbsSkinButton;
    procedure FormCreate(Sender: TObject);
    procedure FormShow(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  EventForm: TEventForm;

implementation

uses
  main;
{$R *.dfm}

procedure TEventForm.FormCreate(Sender: TObject);
begin
  chkName.Items := Common.getValueFromServer('checkNames.txt',main.Path);
  appName.Items := Common.getValueFromServer('appendNames.txt',main.Path);
  events.Items :=  Common.getValueFromServer('events.txt',main.Path);
  chkName.Items.Add('checkSelf');
end;

procedure TEventForm.FormShow(Sender: TObject);
begin
   events.ItemIndex := -1;
   chkName.ItemIndex := -1;
   appName.Text := '';
end;

end.
