unit FourUnit;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms, 
  Dialogs, bsSkinCtrls, bsSkinGrids, bsSkinBoxCtrls,ModelLib;

type
  TFourMoel = class(TFrame)
    bsSkinLabel2: TbsSkinLabel;
    bsSkinExPanel1: TbsSkinExPanel;
    bsSkinPanel3: TbsSkinPanel;
    bsSkinButton9: TbsSkinButton;
    bsSkinButton10: TbsSkinButton;
    bsSkinButton11: TbsSkinButton;
    bsSkinButton12: TbsSkinButton;
    viewGrid: TbsSkinStringGrid;
    bsSkinExPanel2: TbsSkinExPanel;
    bsSkinPanel1: TbsSkinPanel;
    bsSkinButton1: TbsSkinButton;
    bsSkinButton2: TbsSkinButton;
    bsSkinButton3: TbsSkinButton;
    bsSkinButton4: TbsSkinButton;
    fjGrid: TbsSkinStringGrid;
    bsSkinScrollBar1: TbsSkinScrollBar;
    bsSkinScrollBar2: TbsSkinScrollBar;
    proList: TbsSkinComboBox;
    bsSkinButton5: TbsSkinButton;
    orderBox: TbsSkinComboBox;
    procedure bsSkinButton9Click(Sender: TObject);
    procedure bsSkinButton10Click(Sender: TObject);
    procedure bsSkinButton11Click(Sender: TObject);
    procedure bsSkinButton12Click(Sender: TObject);
    procedure viewGridSelectCell(Sender: TObject; ACol, ARow: Integer;
      var CanSelect: Boolean);
    procedure proListExit(Sender: TObject);
    procedure bsSkinButton5Click(Sender: TObject);
    procedure bsSkinButton1Click(Sender: TObject);
    procedure bsSkinButton2Click(Sender: TObject);
    procedure bsSkinButton3Click(Sender: TObject);
    procedure bsSkinButton4Click(Sender: TObject);
    procedure fjGridSelectCell(Sender: TObject; ACol, ARow: Integer;
      var CanSelect: Boolean);
    procedure orderBoxExit(Sender: TObject);
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
  staticDataList:array of TStringArr; //静态取数对象合集
  dtDataList:array of Tservice;     //动态取数对象合集
  dicList:array of string;          //数据字典对象合集
  dataTypeList:array of Integer;     //取数类型对象合集
{$R *.dfm}
procedure TFourMoel.init;
var
  I:Integer;
  ListType:TListType;
begin

  for I := 1 to viewGrid.RowCount - 1 do
     viewGrid.Rows[I].Clear;
  viewGrid.RowCount := 1;

  viewGrid.Cells[0,0] := '序号';
  viewGrid.Cells[1,0] := '描述';
  viewGrid.Cells[2,0] := '对应字段';

  fjGrid.Cells[0,0] := '序号';
  fjGrid.Cells[1,0] := '前缀';
  fjGrid.Cells[2,0] := '后缀';
  fjGrid.Cells[3,0] := '文件类型';
  fjGrid.Cells[4,0] := '最多个数';
  fjGrid.Cells[5,0] := '是否图片';
  fjGrid.Cells[6,0] := '路径';
  fjGrid.Cells[7,0] := '描述';
  proList.Items :=  MainForm.NewModelForm.ModelCode.proList;
  
  for I := 0 to MainForm.NewModelForm.ModelCode.ListTypes.Count - 1 do
  begin
      ListType := MainForm.NewModelForm.ModelCode.ListTypes.Values[I];

      viewGrid.RowCount := viewGrid.RowCount + 1;
      viewGrid.Cells[0,viewGrid.RowCount-1] := IntToStr(viewGrid.RowCount-1);
      viewGrid.Cells[1,viewGrid.RowCount-1] := ListType.comment;
      viewGrid.Cells[2,viewGrid.RowCount-1] := ListType.dataName;

      SetLength(staticDataList,Length(staticDataList)+1);
      staticDataList[Length(staticDataList) - 1] := ListType.StringArr;
      SetLength(dtDataList,Length(dtDataList)+1);
      dtDataList[Length(dtDataList) - 1] := ListType.service;
      SetLength(dicList,Length(dicList)+1);
      dicList[Length(dicList) - 1] := ListType.diccode;
      SetLength(dataTypeList,Length(dataTypeList)+1);
      dataTypeList[Length(dataTypeList)-1] := ListType.dataGetType;
  end;
  viewGrid.FixedRows := 1;
end;
procedure TFourMoel.orderBoxExit(Sender: TObject);
begin
  with orderBox do
  begin
    hide;
    if itemindex >= 0 then
        with fjgrid do
          Cells[col, row] := Items[itemindex];
  end;
end;

procedure TFourMoel.proListExit(Sender: TObject);
begin
  with proList do
  begin
    hide;
    if itemindex >= 0 then
    begin
      with viewGrid do
      begin
        Cells[col, row] := Items[itemindex];
        if Cells[1, row] = '' then
          Cells[1, row] := MainForm.NewModelForm.ModelCode.prototypes.Items[Items[itemindex]].comment;
      end;
    end;
  end;
end;

procedure TFourMoel.viewGridSelectCell(Sender: TObject; ACol, ARow: Integer;
  var CanSelect: Boolean);
var
  R: TRect;
  org: TPoint;
begin
with viewGrid do
  begin
     if (ACol = 2) and (ARow >= 1) then
      begin
          perform(WM_CANCELMODE, 0, 0);
          R := CellRect(ACol, ARow);
          org := Self.ScreenToClient(ClientToScreen(R.topleft));
          with proList do
          begin
            setbounds(org.X, org.Y, R.right - R.left, height);
            itemindex := Items.IndexOf(Cells[ACol, ARow]);
            Show;
            BringTofront;
            SetFocus;
            DropDown;
          end;
      end;
      if (ACol = 1) and (ARow >= 1) then
      begin
          Options:= [goFixedVertLine,goFixedHorzLine,goVertLine,goHorzLine,goColSizing,goRangeSelect,goediting];
      end
      else
      begin
          Options:= [goFixedVertLine,goFixedHorzLine,goVertLine,goHorzLine,goColSizing,goRangeSelect];
      end;
  end;
end;

procedure TFourMoel.bsSkinButton10Click(Sender: TObject);
var
  I:Integer;
begin
  if viewGrid.Row = 0 then Exit;
  if Application.MessageBox('确定删除？', '提示', MB_OKCANCEL + MB_ICONQUESTION) = 1 then
  begin
      with viewGrid do
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

procedure TFourMoel.bsSkinButton11Click(Sender: TObject);
var
   temp:string;
   tempTStringArr:TStringArr;
   tempTservice:Tservice;
   tempstring:string;
   tempInteger:Integer;
begin
   if viewGrid.Row > 1 then
   begin
      temp := viewGrid.Cells[0,viewGrid.Row];
      viewGrid.Cells[0,viewGrid.Row] := viewGrid.Cells[0,viewGrid.Row-1];
      viewGrid.Cells[0,viewGrid.Row-1] := temp;
      viewGrid.changeRow(viewGrid.Row,viewGrid.Row-1);

      tempTStringArr := staticDataList[viewGrid.Row-1];
      staticDataList[viewGrid.Row-1] := staticDataList[viewGrid.Row-2];
      staticDataList[viewGrid.Row-2] := tempTStringArr;

      tempTservice := dtDataList[viewGrid.Row-1];
      dtDataList[viewGrid.Row-1] := dtDataList[viewGrid.Row-2];
      dtDataList[viewGrid.Row-2] := tempTservice;

      tempstring := dicList[viewGrid.Row-1];
      dicList[viewGrid.Row-1] := dicList[viewGrid.Row-2];
      dicList[viewGrid.Row-2] := tempstring;

      tempInteger := dataTypeList[viewGrid.Row-1];
      dataTypeList[viewGrid.Row-1] := dataTypeList[viewGrid.Row-2];
      dataTypeList[viewGrid.Row-2] := tempInteger;

      viewGrid.Row := viewGrid.Row-1;
   end;
end;

procedure TFourMoel.bsSkinButton12Click(Sender: TObject);
var
   temp:string;
   tempTStringArr:TStringArr;
   tempTservice:Tservice;
   tempstring:string;
   tempInteger:Integer;
begin
   if viewGrid.Row = 0 then Exit;
   if viewGrid.Row < viewGrid.RowCount-1 then
   begin
      temp := viewGrid.Cells[0,viewGrid.Row];
      viewGrid.Cells[0,viewGrid.Row] := viewGrid.Cells[0,viewGrid.Row+1];
      viewGrid.Cells[0,viewGrid.Row+1] := temp;
      viewGrid.changeRow(viewGrid.Row,viewGrid.Row+1);

      tempTStringArr := staticDataList[viewGrid.Row-1];
      staticDataList[viewGrid.Row-1] := staticDataList[viewGrid.Row];
      staticDataList[viewGrid.Row] := tempTStringArr;

      tempTservice := dtDataList[viewGrid.Row-1];
      dtDataList[viewGrid.Row-1] := dtDataList[viewGrid.Row];
      dtDataList[viewGrid.Row] := tempTservice;

      tempstring := dicList[viewGrid.Row-1];
      dicList[viewGrid.Row-1] := dicList[viewGrid.Row];
      dicList[viewGrid.Row] := tempstring;

      tempInteger := dataTypeList[viewGrid.Row-1];
      dataTypeList[viewGrid.Row-1] := dataTypeList[viewGrid.Row];
      dataTypeList[viewGrid.Row] := tempInteger;

      viewGrid.Row := viewGrid.Row+1;
   end;
end;

procedure TFourMoel.bsSkinButton1Click(Sender: TObject);
begin
  fjGrid.RowCount := fjGrid.RowCount + 1;
  fjGrid.Cells[0,fjGrid.RowCount-1] := IntToStr(fjGrid.RowCount-1);

  fjGrid.Cells[3,fjGrid.RowCount-1] := 'image';
  fjGrid.Cells[4,fjGrid.RowCount-1] := '1';
  fjGrid.Cells[5,fjGrid.RowCount-1] := '是';
  fjGrid.Cells[7,fjGrid.RowCount-1] := '附件';

  fjGrid.FixedRows := 1;
end;

procedure TFourMoel.bsSkinButton2Click(Sender: TObject);
var
  I:Integer;
begin
  if fjGrid.Row = 0 then Exit;
  if Application.MessageBox('确定删除？', '提示', MB_OKCANCEL + MB_ICONQUESTION) = 1 then
  begin
      with fjGrid do
      begin
          for I:=Row to RowCount-1 do
          begin
              Rows[i]:=Rows[i+1];
              Cells[0,i] := IntToStr(i);
          end;
          RowCount := RowCount-1;
      end;

  end;
end;

procedure TFourMoel.bsSkinButton5Click(Sender: TObject);
var
  I:Integer;
begin
  if viewGrid.Row = 0 then Exit;
  if GetData = nil then
    GetData := TGetData.Create(Application);
  GetData.serviceList.Items := MainForm.NewModelForm.ModelCode.otherModels.Keys;

  if staticDataList[viewGrid.Row-1] <> nil then
  begin
      GetData.PageC.TabIndex := dataTypeList[viewGrid.Row-1];
      for I := 1 to GetData.dataGD.RowCount - 1 do
         GetData.dataGD.Rows[I].Clear;
      GetData.dataGD.RowCount := 1;
      for I := 0 to staticDataList[viewGrid.Row-1].Count - 1 do
      begin
            GetData.dataGD.RowCount := GetData.dataGD.RowCount + 1;
            GetData.dataGD.Cells[0,I+1] :=  staticDataList[viewGrid.Row-1].Keys[I];
            GetData.dataGD.Cells[1,I+1] :=  staticDataList[viewGrid.Row-1].Values[I];
      end;
      if staticDataList[viewGrid.Row-1].Count > 0 then
        GetData.dataGD.FixedRows := 1;
      GetData.serviceList.Text := dtDataList[viewGrid.Row-1].sercieName;
      GetData.dataKeys.Text := dtDataList[viewGrid.Row-1].key;
      GetData.dataValues.Text := dtDataList[viewGrid.Row-1].value;

      GetData.dicType.Text := dicList[viewGrid.Row-1];
  end;

  GetData.ShowModal;

  if GetData.modelResult = 0 then Exit;
  
  dataTypeList[viewGrid.Row-1] := GetData.PageC.TabIndex;

  dtDataList[viewGrid.Row-1].sercieName := GetData.serviceList.Text;
  dtDataList[viewGrid.Row-1].key := GetData.dataKeys.Text;
  dtDataList[viewGrid.Row-1].value := GetData.dataValues.Text;

  dicList[viewGrid.Row-1] := GetData.dicType.Text;

  staticDataList[viewGrid.Row-1].clear;
  for I := 1 to GetData.dataGD.RowCount - 1 do
  begin
    if (GetData.dataGD.Cells[0,I] <> '') and (GetData.dataGD.Cells[1,I] <> '') then
    staticDataList[viewGrid.Row-1].Add(GetData.dataGD.Cells[0,I],GetData.dataGD.Cells[1,I]);
  end;

end;

procedure TFourMoel.bsSkinButton9Click(Sender: TObject);
begin
  viewGrid.RowCount := viewGrid.RowCount + 1;
  viewGrid.Cells[0,viewGrid.RowCount-1] := IntToStr(viewGrid.RowCount-1);
  viewGrid.FixedRows := 1;

  SetLength(staticDataList,Length(staticDataList)+1);
  staticDataList[Length(staticDataList) - 1] := TStringArr.Create;
  SetLength(dtDataList,Length(dtDataList)+1);
  dtDataList[Length(dtDataList) - 1] := Tservice.Create;
  SetLength(dicList,Length(dicList)+1);
  SetLength(dataTypeList,Length(dataTypeList)+1);
  dataTypeList[Length(dataTypeList)-1] := 3;
end;

function TFourMoel.check(var mess:string):boolean;
var
  I:Integer;
  ViewTypes:TViewTypes;
  ViewType:TViewType;
  Fjs:TFJS;
  fj:TFj;
begin
   if viewGrid.RowCount = 1 then
   begin
      mess := '至少要有一个查看内容！';
      Result := False;
      Exit;
   end;
   ViewTypes := TViewTypes.Create;
   for I := 1 to viewGrid.RowCount - 1 do
   begin
       viewGrid.Row := I;
       ViewType := TViewType.Create;
       ViewType.dataName := viewGrid.Cells[2,I];
       ViewType.comment :=  viewGrid.Cells[1,I];
       ViewType.Prototype := main.MainForm.NewModelForm.ModelCode.prototypes.Items[ViewType.dataName];
       ViewType.StringArr := staticDataList[I-1];
       ViewType.service :=  dtDataList[I-1];
       ViewType.diccode :=  dicList[I-1];
       ViewType.dataGetType := dataTypeList[I-1];
       
   end;

  for I := 1 to viewGrid.RowCount - 1 do
  begin
     viewGrid.Row := I;
     ViewType := TViewType.Create;
     ViewType.no := StrToInt(viewGrid.Cells[0,I]);
     ViewType.dataName := viewGrid.Cells[2,I];
     if ViewType.dataName = '' then
     begin
        mess := '查看页面第'+Inttostr(I)+'行对应字段没有定义！';
        Result := False;
        Exit;
     end;
     ViewType.comment := viewGrid.Cells[1,I];
     if ViewType.comment = '' then
     begin
        mess := '查看页面第'+Inttostr(I)+'行列表标题不能为空！';
        Result := False;
        Exit;
     end;
     ViewType.Prototype := main.MainForm.NewModelForm.ModelCode.prototypes.Items[ViewType.dataName];
     ViewType.StringArr := staticDataList[I-1];
     ViewType.service :=  dtDataList[I-1];
     ViewType.diccode :=  dicList[I-1];
     ViewType.dataGetType := dataTypeList[I-1];
     if (ViewType.dataGetType = 0) and (ViewType.StringArr.Count = 0) then
     begin
        mess := '查看页面第'+Inttostr(I)+'行取数方式为静态取数，但是没有定义键值！';
        Result := False;
        Exit;
     end
     else if (ViewType.dataGetType = 1) then
     begin
          if ViewType.service.sercieName = '' then
          begin
              mess := '查看页面第'+Inttostr(I)+'行取数方式为动态取数，但是没有定义service！';
              Result := False;
              Exit;
          end;
          if ViewType.service.key = '' then
          begin
              mess := '列表页面第'+Inttostr(I)+'行取数方式为动态取数，但是没有定义key！';
              Result := False;
              Exit;
          end;
          if ViewType.service.value = '' then
          begin
              mess := '列表页面第'+Inttostr(I)+'行取数方式为动态取数，但是没有定义value！';
              Result := False;
              Exit;
          end;
     end
     else if (ViewType.dataGetType = 2) and (ViewType.diccode = '') then
     begin
          if ViewType.service.value = '' then
          begin
              mess := '列表页面第'+Inttostr(I)+'行取数方式为数据字典，但是没有定义数据字典编码！';
              Result := False;
              Exit;
          end;
     end;
     ViewTypes.Add(ViewType.dataName,ViewType);
  end;
  main.MainForm.NewModelForm.ModelCode.viewList := ViewTypes;


  for I := 1 to fjGrid.RowCount - 1 do
  begin
    fj := TFj.Create;
    fj.qz := fjGrid.Cells[1,I];
    fj.hz := fjGrid.Cells[2,I];
    //fj.itemid := fjGrid.Cells[1,I] + main.MainForm.NewModelForm.ModelCode.Prototype.dataName + fjGrid.Cells[2,I];
    fj.fileType := fjGrid.Cells[3,I];
    if  fj.fileType = '' then
    begin
      mess := '附件第'+Inttostr(I)+'行类型不能为空！';
      Result := False;
      Exit;
    end;
     try
        fj.maxcount := StrToInt(fjGrid.Cells[4,I]);
     except
        mess := '附件第'+Inttostr(I)+'行最多个数必须为数字！';
        Result := False;
        Exit;
     end;
     if  fjGrid.Cells[5,I] = '是' then
         fj.showasimage := '1'
     else
         fj.showasimage := '0';
     fj.path := fjGrid.Cells[6,i];
     fj.comment := fjGrid.Cells[7,i];
    if  fj.comment = '' then
    begin
      mess := '附件第'+Inttostr(I)+'行描述不能为空！';
      Result := False;
      Exit;
    end;
     SetLength(fjs,Length(fjs)+1);
     Fjs[Length(fjs)-1] := fj;
  end;
  main.MainForm.NewModelForm.ModelCode.Fjs := Fjs;





  Result := True;;

end;
procedure TFourMoel.fjGridSelectCell(Sender: TObject; ACol, ARow: Integer;
  var CanSelect: Boolean);
var
  R: TRect;
  org: TPoint;
begin
with fjGrid do
  begin
      if (ACol <> 0) and (ARow >= 1) and (ACol <> 5) then
      begin
          Options:= [goFixedVertLine,goFixedHorzLine,goVertLine,goHorzLine,goColSizing,goRangeSelect,goediting];
      end
      else
      begin
          Options:= [goFixedVertLine,goFixedHorzLine,goVertLine,goHorzLine,goColSizing,goRangeSelect];
      end;
      if (ACol = 5) and (ARow >= 1) then 
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
  end;
end;

procedure TFourMoel.bsSkinButton3Click(Sender: TObject);
var
   temp:string;
begin
   if fjGrid.Row > 1 then
   begin
      temp := fjGrid.Cells[0,fjGrid.Row];
      fjGrid.Cells[0,fjGrid.Row] := fjGrid.Cells[0,fjGrid.Row-1];
      fjGrid.Cells[0,fjGrid.Row-1] := temp;
      fjGrid.changeRow(fjGrid.Row,fjGrid.Row-1);
      fjGrid.Row := fjGrid.Row-1;
   end;
end;

procedure TFourMoel.bsSkinButton4Click(Sender: TObject);
var
   temp:string;
begin
   if fjGrid.Row = 0 then Exit;
   if fjGrid.Row < fjGrid.RowCount-1 then
   begin
      temp := fjGrid.Cells[0,fjGrid.Row];
      fjGrid.Cells[0,fjGrid.Row] := viewGrid.Cells[0,viewGrid.Row+1];
      fjGrid.Cells[0,fjGrid.Row+1] := temp;
      fjGrid.changeRow(fjGrid.Row,fjGrid.Row+1);

      fjGrid.Row := fjGrid.Row+1;
   end;
end;

end.
