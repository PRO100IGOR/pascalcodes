unit TwoUnit;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms, 
  Dialogs, bsSkinCtrls,XMLIntf, XMLDoc, bsSkinGrids, bsSkinBoxCtrls, StdCtrls,ModelLib,Common;

type
  TTwoModel = class(TFrame)
    proList: TbsSkinComboBox;
    eqsList: TbsSkinComboBox;
    showTypeList: TbsSkinComboBox;
    bsSkinExPanel2: TbsSkinExPanel;
    bsSkinPanel4: TbsSkinPanel;
    bsSkinButton3: TbsSkinButton;
    bsSkinButton4: TbsSkinButton;
    bsSkinButton2: TbsSkinButton;
    bsSkinButton9: TbsSkinButton;
    bsSkinButton10: TbsSkinButton;
    listFormgd: TbsSkinStringGrid;
    bsSkinScrollBar1: TbsSkinScrollBar;
    bsSkinExPanel1: TbsSkinExPanel;
    bsSkinPanel2: TbsSkinPanel;
    bsSkinStdLabel1: TbsSkinStdLabel;
    bsSkinStdLabel2: TbsSkinStdLabel;
    showAsTree: TbsSkinCheckRadioBox;
    bsSkinButton1: TbsSkinButton;
    bsSkinButton5: TbsSkinButton;
    parents: TbsSkinComboBox;
    bsSkinButton6: TbsSkinButton;
    bsSkinButton7: TbsSkinButton;
    checkbox: TbsSkinCheckRadioBox;
    num: TbsSkinCheckRadioBox;
    bsSkinButton8: TbsSkinButton;
    treenode: TbsSkinComboBox;
    bsSkinLabel2: TbsSkinLabel;
    sgrid: TbsSkinStringGrid;
    bsSkinScrollBar6: TbsSkinScrollBar;
    orderBox: TbsSkinComboBox;
    showExcept: TbsSkinCheckRadioBox;
    bsSkinStdLabel3: TbsSkinStdLabel;
    mobileTitle: TbsSkinComboBox;
    procedure sgridSelectCell(Sender: TObject; ACol, ARow: Integer;
      var CanSelect: Boolean);
    procedure orderBoxExit(Sender: TObject);
    procedure bsSkinButton1Click(Sender: TObject);
    procedure bsSkinButton8Click(Sender: TObject);
    procedure proListExit(Sender: TObject);
    procedure bsSkinButton6Click(Sender: TObject);
    procedure bsSkinButton7Click(Sender: TObject);
    procedure showAsTreeClick(Sender: TObject);
    procedure bsSkinButton2Click(Sender: TObject);
    procedure listFormgdSelectCell(Sender: TObject; ACol, ARow: Integer;
      var CanSelect: Boolean);
    procedure eqsListExit(Sender: TObject);
    procedure showTypeListExit(Sender: TObject);
    procedure bsSkinButton9Click(Sender: TObject);
    procedure bsSkinButton10Click(Sender: TObject);
    procedure bsSkinButton5Click(Sender: TObject);
    procedure bsSkinButton3Click(Sender: TObject);
    procedure bsSkinButton4Click(Sender: TObject);
    procedure FrameEnter(Sender: TObject);
  private
    { Private declarations }
  public
    procedure init;
    function check(var mess:string):boolean;
  end;

implementation
uses
  main,getDataLib;
var
  staticDataList:array of TStringArr; //��̬ȡ������ϼ�
  dtDataList:array of Tservice;     //��̬ȡ������ϼ�
  dicList:array of string;          //�����ֵ����ϼ�
  dataTypeList:array of Integer;     //ȡ�����Ͷ���ϼ�

  staticDataForm:array of TStringArr; //��̬ȡ������ϼ�
  dtDataForm:array of Tservice;     //��̬ȡ������ϼ�
  dicForm:array of string;          //�����ֵ����ϼ�
  dataTypeForm:array of Integer;     //ȡ�����Ͷ���ϼ�
{$R *.dfm}
procedure TTwoModel.init;
var
  I:Integer;
  Prototype:TPrototype;
begin
  for I := 1 to sgrid.RowCount - 1 do
     sgrid.Rows[I].Clear;
  sgrid.RowCount := 1;
  for I := 1 to listFormgd.RowCount - 1 do
     listFormgd.Rows[I].Clear;
  listFormgd.RowCount := 1;
  
  parents.Items :=  MainForm.NewModelForm.ModelCode.parentIds;
  proList.Items :=  MainForm.NewModelForm.ModelCode.proList;
  mobileTitle.Items := MainForm.NewModelForm.ModelCode.proList;
  mobileTitle.Enabled := MainForm.NewModelForm.ModelCode.mobile;

  
  treenode.Items := proList.Items;
  sgrid.Cells[0,0] := '���';
  sgrid.Cells[1,0] := '�б����';
  sgrid.Cells[2,0] := '��ʾ����';
  sgrid.Cells[3,0] := '�Ƿ�����';
  sgrid.Cells[4,0] := '���(%)';

  listFormgd.Cells[0,0] := '���';
  listFormgd.Cells[1,0] := '����';
  listFormgd.Cells[2,0] := '��Ӧ�ֶ�';
  listFormgd.Cells[3,0] := 'hql����';
  listFormgd.Cells[4,0] := '��ϵ';
  listFormgd.Cells[5,0] := '��ʾ��ʽ';
  listFormgd.Cells[6,0] := 'ʱ��ؼ���ʽ';


  for I := 0 to MainForm.NewModelForm.ModelCode.prototypes.Count - 1 do
  begin
     Prototype := MainForm.NewModelForm.ModelCode.prototypes.Values[I];
     if (Prototype.dataType = 'property') and (Prototype.enable) then
     begin
        sgrid.RowCount := sgrid.RowCount + 1;
        sgrid.Cells[0,sgrid.RowCount-1] := IntToStr(sgrid.RowCount-1);
        sgrid.Cells[1,sgrid.RowCount-1] := Prototype.comment;
        sgrid.Cells[2,sgrid.RowCount-1] := Prototype.dataName;
        sgrid.Cells[3,sgrid.RowCount-1] := '��';
        sgrid.Cells[4,sgrid.RowCount-1] := '10';
        SetLength(staticDataList,Length(staticDataList)+1);
        staticDataList[Length(staticDataList) - 1] := TStringArr.Create;
        SetLength(dtDataList,Length(dtDataList)+1);
        dtDataList[Length(dtDataList) - 1] := Tservice.Create;
        SetLength(dicList,Length(dicList)+1);
        SetLength(dataTypeList,Length(dataTypeList)+1);
        dataTypeList[Length(dataTypeList)-1] := 3;
     end
  end;
  sgrid.FixedRows := 1;
end;
procedure TTwoModel.listFormgdSelectCell(Sender: TObject; ACol, ARow: Integer;
  var CanSelect: Boolean);
var
  R: TRect;
  org: TPoint;
begin
  with listFormgd do
  begin
      if (ACol = 4) and (ARow >= 1) then
      begin
        perform(WM_CANCELMODE, 0, 0);
        R := CellRect(ACol, ARow);
        org := Self.ScreenToClient(ClientToScreen(R.topleft));
        with eqsList do
        begin
          setbounds(org.X, org.Y, R.right - R.left, height);
          itemindex := Items.IndexOf(Cells[ACol, ARow]);
          Show;
          BringTofront;
          SetFocus;
          DropDown;
        end;
      end
      else if (ACol = 2) and (ARow >= 1) then
      begin
          perform(WM_CANCELMODE, 0, 0);
          R := CellRect(ACol, ARow);
          org := Self.ScreenToClient(ClientToScreen(R.topleft));
          with proList do
          begin
            setbounds(org.X, org.Y, R.right - R.left, height);
            itemindex := Items.IndexOf(Cells[ACol, ARow]);
            Tag := -2;
            Show;
            BringTofront;
            SetFocus;
            DropDown;
          end;
      end
      else if (ACol = 5) and (ARow >= 1) then
      begin
          perform(WM_CANCELMODE, 0, 0);
          R := CellRect(ACol, ARow);
          org := Self.ScreenToClient(ClientToScreen(R.topleft));
          with showTypeList do
          begin
            Tag := -1;
            setbounds(org.X, org.Y, R.right - R.left, height);
            itemindex := Items.IndexOf(Cells[ACol, ARow]);
            Tag := -2;
            Show;
            BringTofront;
            SetFocus;
            DropDown;
          end;
      end;
//      else if (ACol = 7) and (ARow >= 1) then
//      begin
//        perform(WM_CANCELMODE, 0, 0);
//        R := CellRect(ACol, ARow);
//        org := Self.ScreenToClient(ClientToScreen(R.topleft));
//        with orderBox do
//        begin
//          setbounds(org.X, org.Y, R.right - R.left, height);
//          itemindex := Items.IndexOf(Cells[ACol, ARow]);
//          Show;
//          Tag := -2;
//          BringTofront;
//          SetFocus;
//          DropDown;
//        end;
//      end;
      if ((ACol = 1) or (ACol = 3) or ((ACol = 6) and (Cells[5,ARow]= 'ʱ��ؼ��ı���'))) and (ARow >= 1) then
      begin
          Options:= [goFixedVertLine,goFixedHorzLine,goVertLine,goHorzLine,goColSizing,goRangeSelect,goediting];
      end
      else
      begin
          Options:= [goFixedVertLine,goFixedHorzLine,goVertLine,goHorzLine,goColSizing,goRangeSelect];
      end;
      bsSkinButton4.Enabled := (Cells[5,ARow] = '������') or (Cells[5,ARow] = '���β˵��ı���')
  end;
end;

procedure TTwoModel.orderBoxExit(Sender: TObject);
begin
  with orderBox do
  begin
    hide;
    if Tag = -1 then
    begin
      if itemindex >= 0 then
        with sgrid do
          Cells[col, row] := Items[itemindex];
    end
    else
    begin
      if itemindex >= 0 then
        with listFormgd do
          Cells[col, row] := Items[itemindex];
    end;
  end;
end;
procedure TTwoModel.proListExit(Sender: TObject);
begin
  with proList do
  begin
    Hide;
    if itemindex >= 0 then
    begin
        if Tag = 0 then
        begin
          with sgrid do
          begin
             if Cells[1, row] = '' then
               Cells[1, row] := MainForm.NewModelForm.ModelCode.prototypes.Items[Items[itemindex]].comment;
             Cells[col, row] := Items[itemindex]
          end
        end
        else if Tag = -2 then
        begin
          with listFormgd do
          begin
             Cells[col, row] := Items[itemindex];
             if Cells[3, row] = '' then
                 Cells[3, row] := 'c'+Copy(Cells[2, row],LastDelimiter('.',Cells[2, row])+1,99);
             if Cells[1, row] = '' then
                 Cells[1, row] := MainForm.NewModelForm.ModelCode.prototypes.Items[Items[itemindex]].comment;
          end;
        end;

    end;
  end;
end;

procedure TTwoModel.sgridSelectCell(Sender: TObject; ACol, ARow: Integer;
  var CanSelect: Boolean);
var
  R: TRect;
  org: TPoint;
begin
  with sgrid do
  begin
      if (ACol = 3) and (ARow >= 1) then 
      begin
        perform(WM_CANCELMODE, 0, 0);
        R := CellRect(ACol, ARow);
        org := Self.ScreenToClient(ClientToScreen(R.topleft));
        with orderBox do
        begin
          setbounds(org.X, org.Y, R.right - R.left, height);
          itemindex := Items.IndexOf(Cells[ACol, ARow]);
          Show;
          Tag := -1;
          BringTofront;
          SetFocus;
          DropDown;
        end;
      end
      else if (ACol = 2) and (ARow >= 1) then
      begin
          perform(WM_CANCELMODE, 0, 0);
          R := CellRect(ACol, ARow);
          org := Self.ScreenToClient(ClientToScreen(R.topleft));
          with proList do
          begin
            setbounds(org.X, org.Y, R.right - R.left, height);
            itemindex := Items.IndexOf(Cells[ACol, ARow]);
            Tag := 0;
            Show;
            BringTofront;
            SetFocus;
            DropDown;
          end;
      end;
      if ((ACol = 1) or (ACol = 4)) and (ARow >= 1) then 
      begin
          Options:= [goFixedVertLine,goFixedHorzLine,goVertLine,goHorzLine,goColSizing,goRangeSelect,goediting];
      end
      else
      begin
          Options:= [goFixedVertLine,goFixedHorzLine,goVertLine,goHorzLine,goColSizing,goRangeSelect];
      end;

  end;
end;

procedure TTwoModel.showAsTreeClick(Sender: TObject);
begin
  parents.Enabled := showAsTree.Checked;
  treenode.Enabled := showAsTree.Checked;
end;

procedure TTwoModel.showTypeListExit(Sender: TObject);
begin
  with showTypeList do
  begin
    hide;
    if itemindex >= 0 then
    begin
      with listFormgd do
      begin
        Cells[col, row] := Items[itemindex];
        if (showTypeList.Text = 'ʱ��ؼ��ı���') and (Cells[6, row]='') then
          Cells[6, row] := 'yyyy-MM-dd'
        else if (showTypeList.Text <> 'ʱ��ؼ��ı���') then
          Cells[6, row] := '';
        bsSkinButton4.Enabled := (Cells[3,row] = '������') or (Cells[3,row] = '���β˵��ı���')
      end;
    end;
  end;
end;

procedure TTwoModel.bsSkinButton10Click(Sender: TObject);
var
   temp:string;
   tempTStringArr:TStringArr;
   tempTservice:Tservice;
   tempstring:string;
   tempInteger:Integer;
begin
   if listFormgd.Row = 0 then Exit;
   if listFormgd.Row < listFormgd.RowCount-1 then
   begin
      temp := listFormgd.Cells[0,listFormgd.Row];
      listFormgd.Cells[0,listFormgd.Row] := listFormgd.Cells[0,listFormgd.Row+1];
      listFormgd.Cells[0,listFormgd.Row+1] := temp;
      listFormgd.changeRow(listFormgd.Row,listFormgd.Row+1);

      tempTStringArr := staticDataForm[listFormgd.Row-1];
      staticDataForm[listFormgd.Row-1] := staticDataForm[listFormgd.Row];
      staticDataForm[listFormgd.Row] := tempTStringArr;

      tempTservice := dtDataForm[listFormgd.Row-1];
      dtDataForm[listFormgd.Row-1] := dtDataForm[listFormgd.Row];
      dtDataForm[listFormgd.Row] := tempTservice;

      tempstring := dicForm[listFormgd.Row-1];
      dicForm[listFormgd.Row-1] := dicForm[listFormgd.Row];
      dicForm[listFormgd.Row] := tempstring;

      tempInteger := dataTypeForm[listFormgd.Row-1];
      dataTypeForm[listFormgd.Row-1] := dataTypeForm[listFormgd.Row];
      dataTypeForm[listFormgd.Row] := tempInteger;

      listFormgd.Row := listFormgd.Row+1;
   end;
end;

procedure TTwoModel.bsSkinButton1Click(Sender: TObject);
var
  I:Integer;
begin
   if sgrid.Row = 0 then Exit;
   if Application.MessageBox('ȷ��ɾ����', '��ʾ', MB_OKCANCEL + MB_ICONQUESTION) = 1 then
   begin
       with sgrid do
       begin
          Move(staticDataList[Row], staticDataList[Row-1], (Length(staticDataList) - Row) * SizeOf(staticDataList[0]));
          SetLength(staticDataList, Length(staticDataList) - 1);

          Move(dtDataList[Row], dtDataList[Row-1], (Length(dtDataList) - Row) * SizeOf(dtDataList[0]));
          SetLength(dtDataList, Length(dtDataList) - 1);

          Move(dicList[Row], dicList[Row-1], (Length(dicList) - Row) * SizeOf(dicList[0]));
          SetLength(dicList, Length(dicList) - 1);

          Move(dataTypeList[Row], dataTypeList[Row-1], (Length(dataTypeList) - Row) * SizeOf(dataTypeList[0]));
          SetLength(dataTypeList, Length(dataTypeList) - 1);
          
          for I:=Row to RowCount-1 do
          begin
              Rows[i]:=Rows[i+1];
              Cells[0,i] := IntToStr(i);
          end;
          RowCount := RowCount-1;
       end;
   end;
end;

procedure TTwoModel.bsSkinButton2Click(Sender: TObject);
begin
  listFormgd.RowCount := listFormgd.RowCount + 1;
  listFormgd.Cells[0,listFormgd.RowCount-1] := IntToStr(listFormgd.RowCount-1);
//  listFormgd.Cells[7,listFormgd.RowCount-1] := '��';
  listFormgd.FixedRows := 1;

  SetLength(staticDataForm,Length(staticDataForm)+1);
  staticDataForm[Length(staticDataForm)-1] := TStringArr.Create;
  SetLength(dtDataForm,Length(dtDataForm)+1);
  dtDataForm[Length(dtDataForm)-1] := TService.Create;
  SetLength(dicForm,Length(dicForm)+1);
  SetLength(dataTypeForm,Length(dataTypeForm)+1);
  dataTypeForm[Length(dataTypeForm)-1] := 3;
end;

procedure TTwoModel.bsSkinButton3Click(Sender: TObject);
var
  I:Integer;
begin
   if listFormgd.Row = 0 then Exit;
   if Application.MessageBox('ȷ��ɾ����', '��ʾ', MB_OKCANCEL + MB_ICONQUESTION) = 1 then
   begin
       with listFormgd do
       begin
          Move(staticDataForm[Row], staticDataForm[Row-1], (Length(staticDataForm) - Row) * SizeOf(staticDataForm[0]));
          SetLength(staticDataForm, Length(staticDataForm) - 1);

          Move(dtDataForm[Row], dtDataForm[Row-1], (Length(dtDataForm) - Row) * SizeOf(dtDataForm[0]));
          SetLength(dtDataForm, Length(dtDataForm) - 1);

          Move(dicForm[Row], dicForm[Row-1], (Length(dicForm) - Row) * SizeOf(dicForm[0]));
          SetLength(dicForm, Length(dicForm) - 1);

          Move(dataTypeForm[Row], dataTypeForm[Row-1], (Length(dataTypeForm) - Row) * SizeOf(dataTypeForm[0]));
          SetLength(dataTypeForm, Length(dataTypeForm) - 1);
          
          for I:=Row to RowCount-1 do
          begin
              Rows[i]:=Rows[i+1];
              Cells[0,i] := IntToStr(i);
          end;
          RowCount := RowCount-1;
       end;
   end;
end;

procedure TTwoModel.bsSkinButton4Click(Sender: TObject);
var
  I:Integer;
begin
  if sgrid.Row = 0 then Exit;
  if GetData = nil then
    GetData := TGetData.Create(Application);
  GetData.serviceList.Items := MainForm.NewModelForm.ModelCode.otherModels.Keys;
  if listFormgd.Cells[5,listFormgd.Row] = '���β˵��ı���'  then
  begin
      GetData.treeid.Visible := True;
      GetData.treeLabel.Visible := True;
  end
  else
  begin
      GetData.treeid.Visible := False;
      GetData.treeLabel.Visible := False;
  end;

  if staticDataList[listFormgd.Row-1] <> nil then
  begin
      GetData.PageC.TabIndex := dataTypeForm[listFormgd.Row-1];
      for I := 1 to GetData.dataGD.RowCount - 1 do
         GetData.dataGD.Rows[I].Clear;
      GetData.dataGD.RowCount := 1;
      for I := 0 to staticDataForm[listFormgd.Row-1].Count - 1 do
      begin
            GetData.dataGD.RowCount := GetData.dataGD.RowCount + 1;
            GetData.dataGD.Cells[0,I+1] :=  staticDataForm[listFormgd.Row-1].Keys[I];
            GetData.dataGD.Cells[1,I+1] :=  staticDataForm[listFormgd.Row-1].Values[I];
      end;
      if staticDataForm[listFormgd.Row-1].Count > 0 then
        GetData.dataGD.FixedRows := 1;
      GetData.serviceList.Text := dtDataForm[listFormgd.Row-1].sercieName;
      GetData.dataKeys.Text := dtDataForm[listFormgd.Row-1].key;
      GetData.dataValues.Text := dtDataForm[listFormgd.Row-1].value;

      GetData.dicType.Text := dicForm[listFormgd.Row-1];
  end;

  GetData.ShowModal;

  if GetData.modelResult = 0 then Exit;
  
  dataTypeForm[listFormgd.Row-1] := GetData.PageC.TabIndex;

  dtDataForm[listFormgd.Row-1].sercieName := GetData.serviceList.Text;
  dtDataForm[listFormgd.Row-1].key := GetData.dataKeys.Text;
  dtDataForm[listFormgd.Row-1].value := GetData.dataValues.Text;
  dtDataForm[listFormgd.Row-1].treeKey := GetData.treeid.Text;
  dicForm[listFormgd.Row-1] := GetData.dicType.Text;

  staticDataForm[listFormgd.Row-1].clear;
  for I := 1 to GetData.dataGD.RowCount - 1 do
  begin
    if (GetData.dataGD.Cells[0,I] <> '') and (GetData.dataGD.Cells[1,I] <> '') then
    staticDataForm[listFormgd.Row-1].Add(GetData.dataGD.Cells[0,I],GetData.dataGD.Cells[1,I]);
  end;

end;

procedure TTwoModel.bsSkinButton5Click(Sender: TObject);
var
  I:Integer;
begin
  if sgrid.Row = 0 then Exit;
  if GetData = nil then
    GetData := TGetData.Create(Application);
  GetData.serviceList.Items := MainForm.NewModelForm.ModelCode.otherModels.Keys;
  GetData.treeid.Visible := False;
  GetData.treeLabel.Visible := False;
  if staticDataList[sgrid.Row-1] <> nil then
  begin
      GetData.PageC.TabIndex := dataTypeList[sgrid.Row-1];
      for I := 1 to GetData.dataGD.RowCount - 1 do
         GetData.dataGD.Rows[I].Clear;
      GetData.dataGD.RowCount := 1;
      for I := 0 to staticDataList[sgrid.Row-1].Count - 1 do
      begin
            GetData.dataGD.RowCount := GetData.dataGD.RowCount + 1;
            GetData.dataGD.Cells[0,I+1] :=  staticDataList[sgrid.Row-1].Keys[I];
            GetData.dataGD.Cells[1,I+1] :=  staticDataList[sgrid.Row-1].Values[I];
      end;
      if staticDataList[sgrid.Row-1].Count > 0 then
        GetData.dataGD.FixedRows := 1;
      GetData.serviceList.Text := dtDataList[sgrid.Row-1].sercieName;
      GetData.dataKeys.Text := dtDataList[sgrid.Row-1].key;
      GetData.dataValues.Text := dtDataList[sgrid.Row-1].value;

      GetData.dicType.Text := dicList[sgrid.Row-1];
  end;

  GetData.ShowModal;

  if GetData.modelResult = 0 then Exit;
  
  dataTypeList[sgrid.Row-1] := GetData.PageC.TabIndex;

  dtDataList[sgrid.Row-1].sercieName := GetData.serviceList.Text;
  dtDataList[sgrid.Row-1].key := GetData.dataKeys.Text;
  dtDataList[sgrid.Row-1].value := GetData.dataValues.Text;

  dicList[sgrid.Row-1] := GetData.dicType.Text;

  staticDataList[sgrid.Row-1].clear;
  for I := 1 to GetData.dataGD.RowCount - 1 do
  begin
    if (GetData.dataGD.Cells[0,I] <> '') and (GetData.dataGD.Cells[1,I] <> '') then
    staticDataList[sgrid.Row-1].Add(GetData.dataGD.Cells[0,I],GetData.dataGD.Cells[1,I]);
  end;

end;

procedure TTwoModel.bsSkinButton6Click(Sender: TObject);
var
   temp:string;
   tempTStringArr:TStringArr;
   tempTservice:Tservice;
   tempstring:string;
   tempInteger:Integer;
begin
   if sgrid.Row > 1 then
   begin
      temp := sgrid.Cells[0,sgrid.Row];
      sgrid.Cells[0,sgrid.Row] := sgrid.Cells[0,sgrid.Row-1];
      sgrid.Cells[0,sgrid.Row-1] := temp;
      sgrid.changeRow(sgrid.Row,sgrid.Row-1);

      tempTStringArr := staticDataList[sgrid.Row-1];
      staticDataList[sgrid.Row-1] := staticDataList[sgrid.Row-2];
      staticDataList[sgrid.Row-2] := tempTStringArr;

      tempTservice := dtDataList[sgrid.Row-1];
      dtDataList[sgrid.Row-1] := dtDataList[sgrid.Row-2];
      dtDataList[sgrid.Row-2] := tempTservice;

      tempstring := dicList[sgrid.Row-1];
      dicList[sgrid.Row-1] := dicList[sgrid.Row-2];
      dicList[sgrid.Row-2] := tempstring;

      tempInteger := dataTypeList[sgrid.Row-1];
      dataTypeList[sgrid.Row-1] := dataTypeList[sgrid.Row-2];
      dataTypeList[sgrid.Row-2] := tempInteger;

      sgrid.Row := sgrid.Row-1;

   end;
end;

procedure TTwoModel.bsSkinButton7Click(Sender: TObject);
var
   temp:string;
   tempTStringArr:TStringArr;
   tempTservice:Tservice;
   tempstring:string;
   tempInteger:Integer;
begin
   if sgrid.Row = 0 then Exit;
   if sgrid.Row < sgrid.RowCount-1 then
   begin
      temp := sgrid.Cells[0,sgrid.Row];
      sgrid.Cells[0,sgrid.Row] := sgrid.Cells[0,sgrid.Row+1];
      sgrid.Cells[0,sgrid.Row+1] := temp;
      sgrid.changeRow(sgrid.Row,sgrid.Row+1);


      tempTStringArr := staticDataList[sgrid.Row-1];
      staticDataList[sgrid.Row-1] := staticDataList[sgrid.Row];
      staticDataList[sgrid.Row] := tempTStringArr;

      tempTservice := dtDataList[sgrid.Row-1];
      dtDataList[sgrid.Row-1] := dtDataList[sgrid.Row];
      dtDataList[sgrid.Row] := tempTservice;

      tempstring := dicList[sgrid.Row-1];
      dicList[sgrid.Row-1] := dicList[sgrid.Row];
      dicList[sgrid.Row] := tempstring;

      tempInteger := dataTypeList[sgrid.Row-1];
      dataTypeList[sgrid.Row-1] := dataTypeList[sgrid.Row];
      dataTypeList[sgrid.Row] := tempInteger;

      sgrid.Row := sgrid.Row+1;
   end;
end;

procedure TTwoModel.bsSkinButton8Click(Sender: TObject);
begin
     sgrid.FixedRows := 1;
     sgrid.RowCount := sgrid.RowCount + 1;
     sgrid.Cells[0,sgrid.RowCount-1] := IntToStr(sgrid.RowCount-1);
     sgrid.Cells[3,sgrid.RowCount-1] := '��';
     sgrid.Cells[4,sgrid.RowCount-1] := '10';
     SetLength(staticDataList,Length(staticDataList)+1);
     staticDataList[Length(staticDataList) - 1] := TStringArr.Create;
     SetLength(dtDataList,Length(dtDataList)+1);
     dtDataList[Length(dtDataList) - 1] := Tservice.Create;
     SetLength(dicList,Length(dicList)+1);
     SetLength(dataTypeList,Length(dataTypeList)+1);
     dataTypeList[Length(dataTypeList)-1] := 3;
end;

procedure TTwoModel.bsSkinButton9Click(Sender: TObject);
var
   temp:string;
   tempTStringArr:TStringArr;
   tempTservice:Tservice;
   tempstring:string;
   tempInteger:Integer;
begin
   if listFormgd.Row > 1 then
   begin
      temp := listFormgd.Cells[0,listFormgd.Row];
      listFormgd.Cells[0,listFormgd.Row] := listFormgd.Cells[0,listFormgd.Row-1];
      listFormgd.Cells[0,listFormgd.Row-1] := temp;
      listFormgd.changeRow(listFormgd.Row,listFormgd.Row-1);

      tempTStringArr := staticDataForm[listFormgd.Row-1];
      staticDataForm[listFormgd.Row-1] := staticDataForm[listFormgd.Row-2];
      staticDataForm[listFormgd.Row-2] := tempTStringArr;

      tempTservice := dtDataForm[listFormgd.Row-1];
      dtDataForm[listFormgd.Row-1] := dtDataForm[listFormgd.Row-2];
      dtDataForm[listFormgd.Row-2] := tempTservice;

      tempstring := dicForm[listFormgd.Row-1];
      dicForm[listFormgd.Row-1] := dicForm[listFormgd.Row-2];
      dicForm[listFormgd.Row-2] := tempstring;

      tempInteger := dataTypeForm[listFormgd.Row-1];
      dataTypeForm[listFormgd.Row-1] := dataTypeForm[listFormgd.Row-2];
      dataTypeForm[listFormgd.Row-2] := tempInteger;

      listFormgd.Row := listFormgd.Row-1;
   end;
end;

function TTwoModel.check(var mess:string):boolean;
var
  I:Integer;
  ListTypes:TListTypes;
  ListType:TListType;
  ConditionType:TConditionType;
  ConditionTypes:TConditionTypes;//��ѯ��������
  //advanceList:TConditionTypes;//�߼���ѯ��������
  tionTypes : TConditionTypes; //���в�ѯ����
begin
  if MainForm.NewModelForm.ModelCode.mobile and (mobileTitle.Text = '') then
  begin
      mess := 'û��ѡ���ƶ��б�ҳ����ʾ�ֶΣ�';
      Result := False;
      Exit
  end;


  if sgrid.RowCount = 1 then
  begin
      mess := '�б�ҳ������Ҫ��һ����ʾ�����ݣ�';
      Result := False;
      Exit;
  end;
  if (showAsTree.Checked) and ((parents.Text = '') or (treenode.Text = '')) then
  begin
      mess := '��ʾΪ��ʱ����ָ����ID�����νڵ㣡';
      Result := False;
      Exit;
  end;

  ListTypes := TListTypes.Create;
  ConditionTypes := TConditionTypes.Create;
 // advanceList := TConditionTypes.Create;
  tionTypes := TConditionTypes.Create;
  for I := 1 to sgrid.RowCount - 1 do
  begin
     sgrid.Row := I;
     ListType := TListType.Create;
     ListType.no := StrToInt(sgrid.Cells[0,I]);
     ListType.order := sgrid.Cells[3,I] = '��';
     try
        ListType.DataLength := StrToInt(sgrid.Cells[4,I]);
     except
        mess := '�б�ҳ���'+Inttostr(I)+'�п�ȱ���Ϊ���֣�';
        Result := False;
        Exit;
     end;
     if (ListType.DataLength > 100) or (ListType.DataLength < 0) then
     begin
        mess := '�б�ҳ���'+Inttostr(I)+'�п�ȱ�����100��0֮���������';
        Result := False;
        Exit;
     end;
     ListType.dataName := sgrid.Cells[2,I];
     if ListType.dataName = '' then
     begin
        mess := '�б�ҳ���'+Inttostr(I)+'�ж�Ӧ�ֶ�û�ж��壡';
        Result := False;
        Exit;
     end;
     ListType.comment := sgrid.Cells[1,I];
     if ListType.comment = '' then
     begin
        mess := '�б�ҳ���'+Inttostr(I)+'���б���ⲻ��Ϊ�գ�';
        Result := False;
        Exit;
     end;
     ListType.Prototype := main.MainForm.NewModelForm.ModelCode.prototypes.Items[ListType.dataName];

     ListType.StringArr := staticDataList[I-1];
     ListType.service :=  dtDataList[I-1];
     ListType.diccode :=  dicList[I-1];
     ListType.dataGetType := dataTypeList[I-1];
     if (ListType.dataGetType = 0) and (ListType.StringArr.Count = 0) then
     begin
        mess := '�б�ҳ���'+Inttostr(I)+'��ȡ����ʽΪ��̬ȡ��������û�ж����ֵ��';
        Result := False;
        Exit;
     end
     else if (ListType.dataGetType = 1) then
     begin
          if ListType.service.sercieName = '' then
          begin
              mess := '�б�ҳ���'+Inttostr(I)+'��ȡ����ʽΪ��̬ȡ��������û�ж���service��';
              Result := False;
              Exit;
          end;
          if ListType.service.key = '' then
          begin
              mess := '�б�ҳ���'+Inttostr(I)+'��ȡ����ʽΪ��̬ȡ��������û�ж���key��';
              Result := False;
              Exit;
          end;
          if ListType.service.value = '' then
          begin
              mess := '�б�ҳ���'+Inttostr(I)+'��ȡ����ʽΪ��̬ȡ��������û�ж���value��';
              Result := False;
              Exit;
          end;
     end
     else if (ListType.dataGetType = 2) and (ListType.diccode = '') then
     begin
          if ListType.service.value = '' then
          begin
              mess := '�б�ҳ���'+Inttostr(I)+'��ȡ����ʽΪ�����ֵ䣬����û�ж��������ֵ���룡';
              Result := False;
              Exit;
          end;
     end;

     if ListType.dataGetType = 1 then
     begin
         main.MainForm.NewModelForm.ModelCode.services.Add(ListType.service.sercieName+'_'+ListType.service.key,ListType.service);
     end;
     

     ListTypes.Add(ListType.dataName,ListType);
  end;



  if listFormgd.RowCount = 1 then
  begin
      if Application.MessageBox('û��һ����ѯ�������Ƿ������', '��ʾ', MB_OKCANCEL + MB_ICONQUESTION) <> 1 then
      begin
        Result := False;
        mess := '';
        Exit;
      end;
  end;

  for I := 1 to listFormgd.RowCount - 1 do
  begin
     ConditionType := TConditionType.Create;
     ConditionType.dataName :=  listFormgd.Cells[2,I];
     if ConditionType.dataName = '' then
     begin
          mess := '��ѯ������'+Inttostr(I)+'�ж�Ӧ�ֶ�û�ж��壡';
          Result := False;
          Exit;
     end;
     ConditionType.datanameex := listFormgd.Cells[3,I];
     if ConditionType.datanameex = '' then
     begin
          mess := '��ѯ������'+Inttostr(I)+'�ж�Ӧ�ֶεı���û�ж��壡';
          Result := False;
          Exit;
     end;

     ConditionType.showType := listFormgd.Cells[5,I];
     if ConditionType.showType = '' then
     begin
          mess := '��ѯ������'+Inttostr(I)+'����ʾ��ʽû�ж��壡';
          Result := False;
          Exit;
     end;

     ConditionType.comment := listFormgd.Cells[1,I];
     if (ConditionType.comment = '') and (ConditionType.showType <> '������') then
     begin
          mess := '��ѯ������'+Inttostr(I)+'������û�ж��壡';
          Result := False;
          Exit;
     end;

     ConditionType.no := StrToInt(listFormgd.Cells[0,I]);
     ConditionType.eqs := listFormgd.Cells[4,I];
     if ConditionType.eqs = '' then
     begin
          mess := '��ѯ������'+Inttostr(I)+'�жԱȹ�ϵû�ж��壡';
          Result := False;
          Exit;
     end;
     //ConditionType.isAdv := listFormgd.Cells[7,I] = '��';
     ConditionType.Prototype := main.MainForm.NewModelForm.ModelCode.prototypes.Items[ConditionType.dataName];

     if (ConditionType.showType = 'ʱ��ؼ��ı���')then
     begin
         ConditionType.timerCoder := listFormgd.Cells[6,I];
         if ConditionType.timerCoder = '' then
         begin
            mess := '��ѯ������'+Inttostr(I)+'��ʱ��ؼ���ʽû�ж��壡';
            Result := False;
            Exit;
         end;
     end
     else if (ConditionType.showType = '���β˵��ı���') or (ConditionType.showType = '������') then
     begin
         ConditionType.StringArr := staticDataForm[I-1];
         ConditionType.service :=  dtDataForm[I-1];
         ConditionType.diccode :=  dicForm[I-1];
         ConditionType.dataGetType := dataTypeForm[I-1];
         if (ConditionType.dataGetType = 0) and (ConditionType.StringArr.Count = 0) then
         begin
            mess := '��ѯ������'+Inttostr(I)+'��ȡ����ʽΪ��̬ȡ��������û�ж����ֵ��';
            Result := False;
            Exit;
         end
         else if (ConditionType.dataGetType = 1) then
         begin
              if ConditionType.service.sercieName = '' then
              begin
                  mess := '��ѯ������'+Inttostr(I)+'��ȡ����ʽΪ��̬ȡ��������û�ж���service��';
                  Result := False;
                  Exit;
              end;
              if ConditionType.service.key = '' then
              begin
                  mess := '��ѯ������'+Inttostr(I)+'��ȡ����ʽΪ��̬ȡ��������û�ж���key��';
                  Result := False;
                  Exit;
              end;
              if ConditionType.service.value = '' then
              begin
                  mess := '��ѯ������'+Inttostr(I)+'��ȡ����ʽΪ��̬ȡ��������û�ж���value��';
                  Result := False;
                  Exit;
              end;
         end
         else if (ConditionType.dataGetType = 2) and (ConditionType.diccode = '') then
         begin
              if ConditionType.service.value = '' then
              begin
                  mess := '��ѯ������'+Inttostr(I)+'��ȡ����ʽΪ�����ֵ䣬����û�ж��������ֵ���룡';
                  Result := False;
                  Exit;
              end;
         end
         else if ConditionType.dataGetType = 3 then
         begin
              mess := '��ѯ������'+Inttostr(I)+'�б��붨��ȡ����';
              Result := False;
              Exit;
         end;

     end;
     if ConditionType.dataGetType = 1 then
     begin
        main.MainForm.NewModelForm.ModelCode.services.Add(ConditionType.service.sercieName+'_'+ConditionType.service.key,ConditionType.service);
     end;
//     if ConditionType.isAdv then
//        advanceList.Add(ConditionType.dataName,ConditionType)
//     else
        ConditionTypes.Add(ConditionType.dataName,ConditionType);
     tionTypes.Add(ConditionType.dataName,ConditionType);
  end;

//  if advanceList.Count > 0 then
//  begin
//      for I := 0 to ConditionTypes.Count - 1 do
//      begin
//          advanceList.Add(ConditionTypes.Keys[I],ConditionTypes.Values[I]);
//      end;
//  end;
  

  main.MainForm.NewModelForm.ModelCode.ConditionTypes := ConditionTypes;
  main.MainForm.NewModelForm.ModelCode.ListTypes := ListTypes;
//  main.MainForm.NewModelForm.ModelCode.advanceList := advanceList;
  main.MainForm.NewModelForm.ModelCode.tionTypes := tionTypes;
  main.MainForm.NewModelForm.ModelCode.showAsTree := showAsTree.Checked;
  main.MainForm.NewModelForm.ModelCode.treeNode := parents.Text;
  main.MainForm.NewModelForm.ModelCode.treeText :=  treenode.Text;
  main.MainForm.NewModelForm.ModelCode.showcheckbox := checkbox.Checked;
  main.MainForm.NewModelForm.ModelCode.showNum := num.Checked;
  main.MainForm.NewModelForm.ModelCode.showExport := showExcept.Checked;
  if main.MainForm.NewModelForm.ModelCode.mobile then
     main.MainForm.NewModelForm.ModelCode.mobileTitle := mobileTitle.Text;
  Result := True;
end;


procedure TTwoModel.eqsListExit(Sender: TObject);
begin
  with eqsList do
  begin
    hide;
    if itemindex >= 0 then
      with listFormgd do
        Cells[col, row] := Items[itemindex];
  end;
end;

procedure TTwoModel.FrameEnter(Sender: TObject);
begin
   mobileTitle.Enabled := MainForm.NewModelForm.ModelCode.mobile;
end;

end.
