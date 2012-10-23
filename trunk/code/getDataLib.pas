unit getDataLib;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, BusinessSkinForm, bsSkinCtrls, bsSkinBoxCtrls, StdCtrls, ComCtrls,
  bsSkinTabs, bsSkinGrids, Mask, ExtCtrls;

type
  TGetData = class(TForm)
    bsBusinessSkinForm: TbsBusinessSkinForm;
    bsSkinPanel2: TbsSkinPanel;
    bsSkinButton3: TbsSkinButton;
    bsSkinButton4: TbsSkinButton;
    PageC: TbsSkinPageControl;
    bsSkinTabSheet1: TbsSkinTabSheet;
    bsSkinTabSheet2: TbsSkinTabSheet;
    bsSkinTabSheet3: TbsSkinTabSheet;
    bsSkinStdLabel3: TbsSkinStdLabel;
    bsSkinStdLabel1: TbsSkinStdLabel;
    bsSkinStdLabel2: TbsSkinStdLabel;
    serviceList: TbsSkinComboBox;
    dataKeys: TbsSkinComboBox;
    dataValues: TbsSkinComboBox;
    dataGD: TbsSkinStringGrid;
    bsSkinPanel1: TbsSkinPanel;
    bsSkinButton1: TbsSkinButton;
    bsSkinButton2: TbsSkinButton;
    bsSkinStdLabel4: TbsSkinStdLabel;
    dicType: TbsSkinEdit;
    bsSkinTabSheet5: TbsSkinTabSheet;
    bsSkinStdLabel6: TbsSkinStdLabel;
    treeLabel: TbsSkinStdLabel;
    treeid: TbsSkinComboBox;
    procedure serviceListChange(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure bsSkinButton3Click(Sender: TObject);
    procedure bsSkinButton4Click(Sender: TObject);
    procedure bsSkinButton1Click(Sender: TObject);
    procedure bsSkinButton2Click(Sender: TObject);
    procedure dataGDSelectCell(Sender: TObject; ACol, ARow: Integer;
      var CanSelect: Boolean);
  private
    { Private declarations }
  public
    { Public declarations }
    modelResult:Integer;
  end;

var
  GetData: TGetData;

implementation

{$R *.dfm}
uses
  main;
procedure TGetData.bsSkinButton1Click(Sender: TObject);
begin
   dataGD.RowCount := dataGD.RowCount + 1;
   dataGD.FixedRows := 1;
end;

procedure TGetData.bsSkinButton2Click(Sender: TObject);
var
  I:Integer;
begin
   if dataGD.Row = 0 then Exit;
   if Application.MessageBox('确定删除？', '提示', MB_OKCANCEL + MB_ICONQUESTION) = 1 then
   begin
       with dataGD do
       begin
          for I:=Row to RowCount-1 do
          begin
              Rows[i]:=Rows[i+1];
          end;
          RowCount := RowCount-1;
       end;
   end;
end;

procedure TGetData.bsSkinButton3Click(Sender: TObject);
begin
    modelResult := 1;
    Close;
end;

procedure TGetData.bsSkinButton4Click(Sender: TObject);
begin
    modelResult := 0;
    Close;
end;

procedure TGetData.dataGDSelectCell(Sender: TObject; ACol, ARow: Integer;
  var CanSelect: Boolean);
begin
  with dataGD do
  begin
      if ARow >= 1 then
      begin
          Options:= [goFixedVertLine,goFixedHorzLine,goVertLine,goHorzLine,goColSizing,goRangeSelect,goediting];
      end
      else
      begin
          Options:= [goFixedVertLine,goFixedHorzLine,goVertLine,goHorzLine,goColSizing,goRangeSelect];
      end;
  end;
end;

procedure TGetData.FormShow(Sender: TObject);
begin
  dataGD.Cells[0,0] := '值';
  dataGD.Cells[1,0] := '内容';
end;

procedure TGetData.serviceListChange(Sender: TObject);
begin
    if main.MainForm.NewModelForm.ModelCode.otherModels[serviceList.Text] <> nil then
    begin
        dataKeys.Items := main.MainForm.NewModelForm.ModelCode.otherModels[serviceList.Text].prototypes.Keys;
        dataValues.Items := dataKeys.Items;
        treeid.Items := dataKeys.Items;
    end;
end;

end.
