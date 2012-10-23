unit ThreeUnit;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms, 
  Dialogs, bsSkinCtrls, bsSkinGrids, StdCtrls, Mask, bsSkinBoxCtrls,Common,ModelLib;

type
  TThreeModel = class(TFrame)
    bsSkinLabel2: TbsSkinLabel;
    bsSkinExPanel1: TbsSkinExPanel;
    bsSkinStdLabel5: TbsSkinStdLabel;
    bsSkinStdLabel1: TbsSkinStdLabel;
    showRightMessage: TbsSkinCheckRadioBox;
    rightMessage: TbsSkinComboBox;
    showTeachMessage: TbsSkinCheckRadioBox;
    teachMessage: TbsSkinComboBox;
    hipTop: TbsSkinComboBox;
    onCheck: TbsSkinComboBox;
    bsSkinGroupBox2: TbsSkinGroupBox;
    events: TbsSkinListBox;
    bsSkinPanel1: TbsSkinPanel;
    bsSkinButton1: TbsSkinButton;
    bsSkinButton2: TbsSkinButton;
    bsSkinStdLabel2: TbsSkinStdLabel;
    bsSkinStdLabel3: TbsSkinStdLabel;
    bsSkinExPanel2: TbsSkinExPanel;
    formList: TbsSkinStringGrid;
    bsSkinPanel2: TbsSkinPanel;
    bsSkinButton3: TbsSkinButton;
    bsSkinButton4: TbsSkinButton;
    bsSkinButton5: TbsSkinButton;
    bsSkinButton6: TbsSkinButton;
    proList: TbsSkinComboBox;
    showTypeList: TbsSkinComboBox;
    bsSkinScrollBar1: TbsSkinScrollBar;
    bsSkinButton7: TbsSkinButton;
    bsSkinButton8: TbsSkinButton;
    procedure formListSelectCell(Sender: TObject; ACol, ARow: Integer;
      var CanSelect: Boolean);
    procedure showTypeListExit(Sender: TObject);
    procedure proListExit(Sender: TObject);
    procedure bsSkinButton4Click(Sender: TObject);
    procedure bsSkinButton3Click(Sender: TObject);
    procedure bsSkinButton7Click(Sender: TObject);
    procedure bsSkinButton8Click(Sender: TObject);
    procedure bsSkinButton5Click(Sender: TObject);
    procedure bsSkinButton1Click(Sender: TObject);
    procedure bsSkinButton2Click(Sender: TObject);
    procedure onCheckEnter(Sender: TObject);
    procedure showRightMessageClick(Sender: TObject);
    procedure showTeachMessageClick(Sender: TObject);
    procedure bsSkinButton6Click(Sender: TObject);
  private
    { Private declarations }
  public
    procedure init;
    function check(var mess:string):boolean;
  end;

implementation
uses
  main,getDataLib,MethodForms,EventForms,RuleFormUnit;
var
  rulesArr : array of TStringArr;     //����
  needCheck:array of Boolean;
  needsArr : array of TStrings;      //��֤
  eventsList : array of TStrings; //�¼�
  staticDataList:array of TStringArr; //��̬ȡ������ϼ�
  dtDataList:array of Tservice;     //��̬ȡ������ϼ�
  dicList:array of string;          //�����ֵ����ϼ�
  dataTypeList:array of Integer;     //ȡ�����Ͷ���ϼ�
{$R *.dfm}
procedure TThreeModel.formListSelectCell(Sender: TObject; ACol, ARow: Integer;
  var CanSelect: Boolean);
var
  R: TRect;
  org: TPoint;
begin
  with formList do
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
      end
      else if (ACol = 3) and (ARow >= 1) then
      begin
          perform(WM_CANCELMODE, 0, 0);
          R := CellRect(ACol, ARow);
          org := Self.ScreenToClient(ClientToScreen(R.topleft));
          with showTypeList do
          begin
            setbounds(org.X, org.Y, R.right - R.left, height);
            itemindex := Items.IndexOf(Cells[ACol, ARow]);
            Show;
            BringTofront;
            SetFocus;
            DropDown;
          end;
      end;
      if ((ACol = 1) or ((ACol = 4) and (Cells[3,ARow]= 'ʱ��ؼ��ı���'))) and (ARow >= 1) then
      begin
          Options:= [goFixedVertLine,goFixedHorzLine,goVertLine,goHorzLine,goColSizing,goRangeSelect,goediting];
      end
      else
      begin
          Options:= [goFixedVertLine,goFixedHorzLine,goVertLine,goHorzLine,goColSizing,goRangeSelect];
      end;
      bsSkinButton5.Enabled := (Cells[3,ARow] = '������') or (Cells[3,ARow] = '���β˵��ı���')
  end;
end;

procedure TThreeModel.init;
var
  I:Integer;
  Prototype:TPrototype;
begin
  Common.getHistoryFromtxt(rightMessage,ExtractFileDir(PARAMSTR(0))+'\res\box\rightMessage.txt');
  Common.getHistoryFromtxt(teachMessage,ExtractFileDir(PARAMSTR(0))+'\res\box\teachMessage.txt');
  Common.getHistoryFromtxt(hipTop,ExtractFileDir(PARAMSTR(0))+'\res\box\hipTop.txt');
  Common.getHistoryFromtxt(onCheck,ExtractFileDir(PARAMSTR(0))+'\res\box\onCheck.txt');
  Common.getHistoryFromtxt(events,ExtractFileDir(PARAMSTR(0))+'\res\box\events.txt');


  for I := 1 to formList.RowCount - 1 do
     formList.Rows[I].Clear;
  formList.RowCount := 1;

  proList.Items :=  MainForm.NewModelForm.ModelCode.proList;
  formList.Cells[0,0] := '���';
  formList.Cells[1,0] := '����';
  formList.Cells[2,0] := '��Ӧ�ֶ�';
  formList.Cells[3,0] := '��ʾ��ʽ';
  formList.Cells[4,0] := 'ʱ��ؼ���ʽ';

  for I := 0 to MainForm.NewModelForm.ModelCode.prototypes.Count - 1 do
  begin
     Prototype := MainForm.NewModelForm.ModelCode.prototypes.Values[I];
     if (Prototype.enable) then
     begin
        formList.RowCount := formList.RowCount + 1;
        formList.Cells[0,formList.RowCount-1] := IntToStr(formList.RowCount-1);
        formList.Cells[1,formList.RowCount-1] := Prototype.comment;
        formList.Cells[2,formList.RowCount-1] := Prototype.dataName;
        if Prototype.dataType = 'property' then
           formList.Cells[3,formList.RowCount-1] := '��ͨ�ı���'
        else
           formList.Cells[3,formList.RowCount-1] := '������';
        formList.Cells[4,formList.RowCount-1] := '';

        
        SetLength(rulesArr,Length(rulesArr)+1);
        rulesArr[Length(rulesArr) - 1] := TStringArr.Create;

        SetLength(needCheck,Length(needCheck)+1);
        needCheck[Length(needCheck) - 1] := False;

        SetLength(eventsList,Length(eventsList)+1);
        eventsList[Length(eventsList) - 1] := TStringList.Create;

        SetLength(needsArr,Length(needsArr)+1);
        needsArr[Length(needsArr) - 1] := TStringList.Create;

        SetLength(staticDataList,Length(staticDataList)+1);
        staticDataList[Length(staticDataList) - 1] := TStringArr.Create;

        SetLength(dtDataList,Length(dtDataList)+1);
        dtDataList[Length(dtDataList) - 1] := Tservice.Create;

        SetLength(dicList,Length(dicList)+1);

        SetLength(dataTypeList,Length(dataTypeList)+1);
        dataTypeList[Length(dataTypeList)-1] := 3;
     end
  end;
  formList.FixedRows := 1;
end;



procedure TThreeModel.onCheckEnter(Sender: TObject);
begin
  if MethodForm = nil then
    MethodForm := TMethodForm.Create(Application);
  MethodForm.ShowModal;
  if  MethodForms.MethodForm.ModalResult = 1 then
  begin
       onCheck.Text :=  MethodForms.MethodForm.chkName.Text + '>' + MethodForms.MethodForm.appName.Text;
  end;
end;

procedure TThreeModel.proListExit(Sender: TObject);
begin
  with proList do
  begin
    hide;
    if itemindex >= 0 then
    begin
      with formList do
      begin
        Cells[col, row] := Items[itemindex];
        if Cells[1, row] = '' then
          Cells[1, row] := MainForm.NewModelForm.ModelCode.prototypes.Items[Items[itemindex]].comment;
      end;
    end;
  end;
end;

procedure TThreeModel.showRightMessageClick(Sender: TObject);
begin
    rightMessage.Enabled := showRightMessage.Checked;
end;

procedure TThreeModel.showTypeListExit(Sender: TObject);
begin
  with showTypeList do
  begin
    hide;
    if itemindex >= 0 then
    begin
      with formList do
      begin
        Cells[col, row] := Items[itemindex];
        if (showTypeList.Text = 'ʱ��ؼ��ı���') and (Cells[4, row]='') then
          Cells[4, row] := 'yyyy-MM-dd'
        else if (showTypeList.Text <> 'ʱ��ؼ��ı���') then
          Cells[4, row] := '';
        bsSkinButton5.Enabled := (Cells[3,row] = '������') or (Cells[3,row] = '���β˵��ı���')
      end;
    end;
  end;
end;

procedure TThreeModel.bsSkinButton1Click(Sender: TObject);
var
  tempStr:string;
begin
  if EventForm  = nil then
    EventForm := TEventForm.Create(Application);
  EventForm.ShowModal;
  if  EventForms.EventForm.ModalResult = 1 then
  begin
    if EventForm.events.Text <> '' then
    begin
      tempStr := '';
      tempStr := tempStr + EventForm.events.Text + '>';
      if EventForm.chkName.Text <> '' then
      begin
          tempStr := tempStr + EventForm.chkName.Text + ',';
      end;
      tempStr :=  tempStr +  EventForm.appName.Text;
    end;
    events.Items.Add(tempStr);
  end;
end;

procedure TThreeModel.bsSkinButton2Click(Sender: TObject);
begin
case Application.MessageBox('��ע�⣺�˲������ɻָ���',
            'ȷ���Ƴ���', MB_OKCANCEL + MB_ICONWARNING + MB_DEFBUTTON2) of
     IDOK:
     begin
        if events.ItemIndex <> -1 then
          events.Items.Delete(events.ItemIndex);
     end;
     IDCANCEL:
     begin

     end;
end;
end;

procedure TThreeModel.bsSkinButton3Click(Sender: TObject);
var
  I:Integer;
begin
   if formList.Row = 0 then Exit;
   if Application.MessageBox('ȷ��ɾ����', '��ʾ', MB_OKCANCEL + MB_ICONQUESTION) = 1 then
   begin
       with formList do
       begin
          Move(rulesArr[Row], rulesArr[Row-1], (Length(rulesArr) - Row) * SizeOf(rulesArr[0]));
          SetLength(rulesArr, Length(rulesArr) - 1);

          Move(eventsList[Row], eventsList[Row-1], (Length(eventsList) - Row) * SizeOf(eventsList[0]));
          SetLength(eventsList, Length(eventsList) - 1);

          Move(needsArr[Row], needsArr[Row-1], (Length(needsArr) - Row) * SizeOf(needsArr[0]));
          SetLength(needsArr, Length(needsArr) - 1);

          Move(staticDataList[Row], staticDataList[Row-1], (Length(staticDataList) - Row) * SizeOf(staticDataList[0]));
          SetLength(staticDataList, Length(staticDataList) - 1);

          Move(dtDataList[Row], dtDataList[Row-1], (Length(dtDataList) - Row) * SizeOf(dtDataList[0]));
          SetLength(dtDataList, Length(dtDataList) - 1);

          Move(dicList[Row], dicList[Row-1], (Length(dicList) - Row) * SizeOf(dicList[0]));
          SetLength(dicList, Length(dicList) - 1);

          Move(dataTypeList[Row], dataTypeList[Row-1], (Length(dataTypeList) - Row) * SizeOf(dataTypeList[0]));
          SetLength(dataTypeList, Length(dataTypeList) - 1);

          Move(needCheck[Row], needCheck[Row-1], (Length(needCheck) - Row) * SizeOf(needCheck[0]));
          SetLength(needCheck, Length(needCheck) - 1);

          for I:=Row to RowCount-1 do
          begin
              Rows[i]:=Rows[i+1];
              Cells[0,i] := IntToStr(i);
          end;
          RowCount := RowCount-1;
       end;
   end;
end;

procedure TThreeModel.bsSkinButton4Click(Sender: TObject);
begin
  formList.RowCount := formList.RowCount + 1;
  formList.Cells[0,formList.RowCount-1] := IntToStr(formList.RowCount-1);
  formList.Cells[4,formList.RowCount-1] := '��';
  formList.Cells[3,formList.RowCount-1] := '��ͨ�ı���';
  formList.FixedRows := 1;

  SetLength(rulesArr,Length(rulesArr)+1);
  rulesArr[Length(rulesArr) - 1] := TStringArr.Create;
  SetLength(eventsList,Length(eventsList)+1);
  eventsList[Length(eventsList) - 1] := TStringList.Create;
  SetLength(needsArr,Length(needsArr)+1);
  needsArr[Length(needsArr) - 1] := TStringList.Create;
  SetLength(staticDataList,Length(staticDataList)+1);
  staticDataList[Length(staticDataList) - 1] := TStringArr.Create;
  SetLength(dtDataList,Length(dtDataList)+1);
  dtDataList[Length(dtDataList) - 1] := Tservice.Create;
  SetLength(dicList,Length(dicList)+1);
  SetLength(dataTypeList,Length(dataTypeList)+1);
  dataTypeList[Length(dataTypeList)-1] := 3;
  SetLength(needCheck,Length(needCheck)+1);
  needCheck[Length(needCheck) - 1] := False;
end;

procedure TThreeModel.bsSkinButton5Click(Sender: TObject);
var
  I:Integer;
begin
  if formList.Row = 0 then Exit;
  if GetData = nil then
    GetData := TGetData.Create(Application);
  GetData.serviceList.Items := MainForm.NewModelForm.ModelCode.otherModels.Keys;

  if staticDataList[formList.Row-1] <> nil then
  begin
      GetData.PageC.TabIndex := dataTypeList[formList.Row-1];
      for I := 1 to GetData.dataGD.RowCount - 1 do
         GetData.dataGD.Rows[I].Clear;
      GetData.dataGD.RowCount := 1;
      for I := 0 to staticDataList[formList.Row-1].Count - 1 do
      begin
            GetData.dataGD.RowCount := GetData.dataGD.RowCount + 1;
            GetData.dataGD.Cells[0,I+1] :=  staticDataList[formList.Row-1].Keys[I];
            GetData.dataGD.Cells[1,I+1] :=  staticDataList[formList.Row-1].Values[I];
      end;
      if staticDataList[formList.Row-1].Count > 0 then
        GetData.dataGD.FixedRows := 1;
      GetData.serviceList.Text := dtDataList[formList.Row-1].sercieName;
      GetData.dataKeys.Text := dtDataList[formList.Row-1].key;
      GetData.dataValues.Text := dtDataList[formList.Row-1].value;

      GetData.dicType.Text := dicList[formList.Row-1];
  end;

  GetData.ShowModal;

  if GetData.modelResult = 0 then Exit;
  
  dataTypeList[formList.Row-1] := GetData.PageC.TabIndex;

  dtDataList[formList.Row-1].sercieName := GetData.serviceList.Text;
  dtDataList[formList.Row-1].key := GetData.dataKeys.Text;
  dtDataList[formList.Row-1].value := GetData.dataValues.Text;

  dicList[formList.Row-1] := GetData.dicType.Text;

  staticDataList[formList.Row-1].clear;
  for I := 1 to GetData.dataGD.RowCount - 1 do
  begin
    if (GetData.dataGD.Cells[0,I] <> '') and (GetData.dataGD.Cells[1,I] <> '') then
      staticDataList[formList.Row-1].Add(GetData.dataGD.Cells[0,I],GetData.dataGD.Cells[1,I]);
  end;
end;

procedure TThreeModel.bsSkinButton6Click(Sender: TObject);
begin
  if formList.Row = 0 then Exit;
  if RuleFactory = nil then
     RuleFactory := TRuleFactory.Create(Application);
  if rulesArr[formList.Row - 1].Items['realName'] = '' then
     rulesArr[formList.Row - 1].add('realName',formList.Cells[1,formList.Row]);

  RuleFactory.realName.Text := rulesArr[formList.Row - 1].Items['realName'];
  RuleFactory.needCheck.Checked := needCheck[formList.Row - 1];
  RuleFactory.needCheckClick(nil);
  RuleFactory.valid.Checked := (rulesArr[formList.Row - 1].Items['valid'] = 'yes') or (rulesArr[formList.Row - 1].Items['valid'] = '') ;
  RuleFactory.teachMessage.Text := rulesArr[formList.Row - 1].Items['teachMessage'];
  RuleFactory.rightMessage.Text := rulesArr[formList.Row - 1].Items['rightMessage'];
  RuleFactory.showTeachMessage.Checked := (rulesArr[formList.Row - 1].Items['showTeachMessage'] = 'yes') or (rulesArr[formList.Row - 1].Items['showTeachMessage'] <> '');
  RuleFactory.showRightMessage.Checked := (rulesArr[formList.Row - 1].Items['showRightMessage'] = 'yes') or (rulesArr[formList.Row - 1].Items['showRightMessage'] <> '');
  RuleFactory.onCheck.Text := rulesArr[formList.Row - 1].Items['onCheck'];
  RuleFactory.events.Items.Assign(eventsList[formList.Row - 1]);
  RuleFactory.rules.Lines.Assign(needsArr[formList.Row - 1]);
  if RuleFactory.ShowModal = 1 then
  begin
     rulesArr[formList.Row - 1].clear;
     rulesArr[formList.Row - 1].Add('realName',RuleFactory.realName.Text);
     if not RuleFactory.valid.Checked then
       rulesArr[formList.Row - 1].Add('valid','no')
     else
       rulesArr[formList.Row - 1].Remove('valid');
     if RuleFactory.teachMessage.Text <> '' then
       rulesArr[formList.Row - 1].Add('teachMessage',RuleFactory.teachMessage.Text)
     else
       rulesArr[formList.Row - 1].remove('teachMessage');
     if RuleFactory.rightMessage.Text <> '' then
       rulesArr[formList.Row - 1].Add('rightMessage',RuleFactory.rightMessage.Text)
     else
       rulesArr[formList.Row - 1].remove('rightMessage');

     if  (RuleFactory.showTeachMessage.Checked) and (not showRightMessage.Checked) then
        rulesArr[formList.Row - 1].Add('showTeachMessage','yes')
     else if  (not RuleFactory.showTeachMessage.Checked) and (showRightMessage.Checked) then
        rulesArr[formList.Row - 1].Add('showTeachMessage','no')
     else
        rulesArr[formList.Row - 1].remove('showTeachMessage');


     if  (RuleFactory.showRightMessage.Checked) and (not showRightMessage.Checked) then
        rulesArr[formList.Row - 1].Add('showRightMessage','yes')
     else if  (not RuleFactory.showRightMessage.Checked) and (showRightMessage.Checked) then
        rulesArr[formList.Row - 1].Add('showRightMessage','no')
     else
        rulesArr[formList.Row - 1].remove('showRightMessage');
     if RuleFactory.onCheck.Text <> '' then
        rulesArr[formList.Row - 1].Add('onCheck',RuleFactory.onCheck.Text);
     eventsList[formList.Row - 1].Assign(RuleFactory.events.Items);
     needsArr[formList.Row - 1].Assign(RuleFactory.rules.Lines);
     needCheck[formList.Row - 1] := RuleFactory.needCheck.Checked;
  end;
end;

procedure TThreeModel.bsSkinButton7Click(Sender: TObject);
var
   temp:string;
   tempTStringArr:TStringArr;
   tempTservice:Tservice;
   tempstring:string;
   tempInteger:Integer;
   tempTStrings:TStrings;
   tempBoolean:Boolean;
begin
   if formList.Row > 1 then
   begin
      temp := formList.Cells[0,formList.Row];
      formList.Cells[0,formList.Row] := formList.Cells[0,formList.Row-1];
      formList.Cells[0,formList.Row-1] := temp;
      formList.changeRow(formList.Row,formList.Row-1);

      tempTStringArr := staticDataList[formList.Row-1];
      staticDataList[formList.Row-1] := staticDataList[formList.Row-2];
      staticDataList[formList.Row-2] := tempTStringArr;

      tempTStrings := eventsList[formList.Row-1];
      eventsList[formList.Row-1] := eventsList[formList.Row-2];
      eventsList[formList.Row-2] := tempTStrings;

      tempTservice := dtDataList[formList.Row-1];
      dtDataList[formList.Row-1] := dtDataList[formList.Row-2];
      dtDataList[formList.Row-2] := tempTservice;

      tempstring := dicList[formList.Row-1];
      dicList[formList.Row-1] := dicList[formList.Row-2];
      dicList[formList.Row-2] := tempstring;

      tempInteger := dataTypeList[formList.Row-1];
      dataTypeList[formList.Row-1] := dataTypeList[formList.Row-2];
      dataTypeList[formList.Row-2] := tempInteger;

      tempBoolean := needCheck[formList.Row-1];
      needCheck[formList.Row-1] := needCheck[formList.Row-2];
      needCheck[formList.Row-2] := tempBoolean;

      tempTStringArr := rulesArr[formList.Row-1];
      rulesArr[formList.Row-1] := rulesArr[formList.Row-2];
      rulesArr[formList.Row-2] := tempTStringArr;

      tempTStrings := needsArr[formList.Row-1];
      needsArr[formList.Row-1] := needsArr[formList.Row-2];
      needsArr[formList.Row-2] := tempTStrings;

      formList.Row := formList.Row-1;
   end;
end;

procedure TThreeModel.bsSkinButton8Click(Sender: TObject);
var
   temp:string;
   tempTStringArr:TStringArr;
   tempTservice:Tservice;
   tempstring:string;
   tempInteger:Integer;
   tempTStrings:TStrings;
   tempBoolean:Boolean;
begin
   if formList.Row = 0 then Exit;
   if formList.Row < formList.RowCount-1 then
   begin
      temp := formList.Cells[0,formList.Row];
      formList.Cells[0,formList.Row] := formList.Cells[0,formList.Row+1];
      formList.Cells[0,formList.Row+1] := temp;
      formList.changeRow(formList.Row,formList.Row+1);

      tempTStringArr := staticDataList[formList.Row-1];
      staticDataList[formList.Row-1] := staticDataList[formList.Row];
      staticDataList[formList.Row] := tempTStringArr;

      tempTStrings := eventsList[formList.Row-1];
      eventsList[formList.Row-1] := eventsList[formList.Row];
      eventsList[formList.Row] := tempTStrings;

      tempTservice := dtDataList[formList.Row-1];
      dtDataList[formList.Row-1] := dtDataList[formList.Row];
      dtDataList[formList.Row] := tempTservice;

      tempstring := dicList[formList.Row-1];
      dicList[formList.Row-1] := dicList[formList.Row];
      dicList[formList.Row] := tempstring;

      tempInteger := dataTypeList[formList.Row-1];
      dataTypeList[formList.Row-1] := dataTypeList[formList.Row];
      dataTypeList[formList.Row] := tempInteger;

      tempTStringArr := rulesArr[formList.Row-1];
      rulesArr[formList.Row-1] := rulesArr[formList.Row];
      rulesArr[formList.Row] := tempTStringArr;

      tempTStrings := needsArr[formList.Row-1];
      needsArr[formList.Row-1] := needsArr[formList.Row];
      needsArr[formList.Row] := tempTStrings;

      tempBoolean := needCheck[formList.Row-1];
      needCheck[formList.Row-1] := needCheck[formList.Row];
      needCheck[formList.Row] := tempBoolean;

      formList.Row := formList.Row+1;
   end;
end;

procedure TThreeModel.showTeachMessageClick(Sender: TObject);
begin
  teachMessage.Enabled := showTeachMessage.Checked;
end;

function TThreeModel.check(var mess:string):boolean;
var
  I:Integer;
  FormTypes:TFormTypes;
  FormType:TFormType;
  hasId:Boolean;
begin

   if showRightMessage.Checked and (RightMessage.Text = '') then
   begin
     if Application.MessageBox('��ʾ��ȷ��Ϣ����û��������ȷ��Ϣ���ݣ���ʹ��Ĭ����Ϣ����������ȷ�����Ƿ������',
       '��ʾ', MB_OKCANCEL + MB_ICONQUESTION) <> 1 then
     begin
        Result := False;
        mess := '';
        Exit;
     end;
   end;
   if showTeachMessage.Checked and (TeachMessage.Text = '') then
   begin
     if Application.MessageBox('��ʾ��ʾ��Ϣ����û��������ʾ��Ϣ���ݣ���ʹ��Ĭ����Ϣ����������xxx�����Ƿ������',
       '��ʾ', MB_OKCANCEL + MB_ICONQUESTION) <> 1 then
     begin
        Result := False;
        mess := '';
        Exit;
     end;
   end;
   if onCheck.Text = '' then
   begin
        Result := False;
        mess := 'check�¼�û�ж��壡';
        Exit;
   end;
   if events.Items.Count = 0 then
   begin
     if Application.MessageBox('û�ж����¼���ҳ����ֻ��ͨ��xxx.check()�ķ�ʽ��֤���Ƿ������',
       '��ʾ', MB_OKCANCEL + MB_ICONQUESTION) <> 1 then
     begin
        Result := False;
        mess := '';
        Exit;
     end;
   end;

   if formList.RowCount = 1 then
   begin
         mess := '����Ҫ��һ�������ݣ�';
         Result := False;
         Exit;
   end;
   

   FormTypes := TFormTypes.Create;
   for I := 1 to formList.RowCount - 1 do
   begin
       formList.Row := I;
       FormType := TFormType.Create;
       FormType.no := StrToInt(formList.Cells[0,I]);



       FormType.dataName := formList.Cells[2,I];
       if FormType.dataName = '' then
       begin
         mess := '��'+Inttostr(I)+'�ж�Ӧ�ֶ�û�ж��壡';
         Result := False;
         Exit;
       end;
       FormType.Prototype := main.MainForm.NewModelForm.ModelCode.prototypes.Items[FormType.dataName];
       if FormType.Prototype.dataType = 'id' then
          hasId := True;
       
       if not FormType.Prototype.enable then
            FormType.dataName :=  Copy(FormType.dataName,LastDelimiter('.',FormType.dataName)+1,999);

       FormType.showType := formList.Cells[3,I];
       if FormType.showType = '' then
       begin
         mess := '��'+Inttostr(I)+'����ʾ��ʽû�ж��壡';
         Result := False;
         Exit;
       end;


       FormType.comment := formList.Cells[1,I];
       if (FormType.comment = '') and (FormType.showType <> '������') then
       begin
         mess := '��'+Inttostr(I)+'���ֶ�����û�ж��壡';
         Result := False;
         Exit;
       end;

       FormType.timerCoder := formList.Cells[4,I];
       if (FormType.showType = 'ʱ��ؼ��ı���') and (FormType.timerCoder = '') then
       begin
         mess := '��'+Inttostr(I)+'����ʾ��ʽΪʱ��ؼ�����û�ж���ʱ���ʽ��';
         Result := False;
         Exit;
       end;

       FormType.CheckRule.needCheck := needCheck[I-1];
       if FormType.CheckRule.needCheck then
       begin
           FormType.CheckRule.rules := rulesArr[I-1];
           if FormType.CheckRule.rules.Items['realName'] = '' then
           begin
             mess := FormType.dataName+'��֤������û�ж�����ʽ���ƣ�';
             Result := False;
             Exit;
           end;
           FormType.CheckRule.needs := needsArr[I-1];
           if FormType.CheckRule.needs.Count = 0 then
           begin
             mess := FormType.dataName+'û��һ����֤����';
             Result := False;
             Exit;
           end;
           FormType.CheckRule.events := eventsList[I-1];
       end;
       FormType.CheckRule.events := eventsList[I-1];





     if (FormType.showType = '���β˵��ı���') or (FormType.showType = '������') then
     begin
         FormType.StringArr := staticDataList[I-1];
         FormType.service :=  dtDataList[I-1];
         FormType.diccode :=  dicList[I-1];
         FormType.dataGetType := dataTypeList[I-1];
         if (FormType.dataGetType = 0) and (FormType.StringArr.Count = 0) then
         begin
            mess := '��'+Inttostr(I)+'��ȡ����ʽΪ��̬ȡ��������û�ж����ֵ��';
            Result := False;
            Exit;
         end
         else if (FormType.dataGetType = 1) then
         begin
              if FormType.service.sercieName = '' then
              begin
                  mess := '��'+Inttostr(I)+'��ȡ����ʽΪ��̬ȡ��������û�ж���service��';
                  Result := False;
                  Exit;
              end;
              if FormType.service.key = '' then
              begin
                  mess := '��ѯ������'+Inttostr(I)+'��ȡ����ʽΪ��̬ȡ��������û�ж���key��';
                  Result := False;
                  Exit;
              end;
              if FormType.service.value = '' then
              begin
                  mess := '��'+Inttostr(I)+'��ȡ����ʽΪ��̬ȡ��������û�ж���value��';
                  Result := False;
                  Exit;
              end;
         end
         else if (FormType.dataGetType = 2) and (FormType.diccode = '') then
         begin
              if FormType.service.value = '' then
              begin
                  mess := '��'+Inttostr(I)+'��ȡ����ʽΪ�����ֵ䣬����û�ж��������ֵ���룡';
                  Result := False;
                  Exit;
              end;
         end
         else if FormType.dataGetType = 3 then
         begin
              mess := '��'+Inttostr(I)+'�б��붨��ȡ����';
              Result := False;
              Exit;
         end;

     end;



       FormTypes.Add(FormType.dataName,FormType);
   end;
     
       if not hasId then
       begin
         mess := 'û��������';
         Result := False;
         Exit;
       end;

   main.MainForm.NewModelForm.ModelCode.FormTypes := FormTypes;
   with main.MainForm.NewModelForm.ModelCode  do
   begin
        CheckRule.clear;
        if teachMessage.Text <> '' then
          CheckRule.rules.Add('teachMessage',teachMessage.Text)
        else
          CheckRule.rules.Remove('teachMessage');
        if rightMessage.Text <> '' then
          CheckRule.rules.Add('rightMessage',rightMessage.Text)
        else
          CheckRule.rules.Remove('rightMessage');
        if showTeachMessage.Checked then
          CheckRule.rules.Add('showTeachMessage','yes')
        else
          CheckRule.rules.Remove('showTeachMessage');

        if showRightMessage.Checked then
          CheckRule.rules.Add('showRightMessage','yes')
        else
          CheckRule.rules.Remove('showRightMessage');
        CheckRule.rules.Add('onCheck',onCheck.Text);
        CheckRule.events.Assign(Self.events.Items);
   end;
  if (rightMessage.Items.IndexOf(rightMessage.Text) = -1) and (rightMessage.Text <> '') then
         rightMessage.Items.Add(rightMessage.Text);
  if (teachMessage.Items.IndexOf(teachMessage.Text) = -1) and (teachMessage.Text <> '') then
         teachMessage.Items.Add(teachMessage.Text);
  if (hipTop.Items.IndexOf(hipTop.Text) = -1) and (hipTop.Text <> '') then
         hipTop.Items.Add(hipTop.Text);
  if (onCheck.Items.IndexOf(onCheck.Text) = -1) and (onCheck.Text <> '') then
         onCheck.Items.Add(onCheck.Text);
   rightMessage.Items.SaveToFile(ExtractFileDir(PARAMSTR(0))+'\res\box\rightMessage.txt');
   teachMessage.Items.SaveToFile(ExtractFileDir(PARAMSTR(0))+'\res\box\teachMessage.txt');
   hipTop.Items.SaveToFile(ExtractFileDir(PARAMSTR(0))+'\res\box\hipTop.txt');
   onCheck.Items.SaveToFile(ExtractFileDir(PARAMSTR(0))+'\res\box\onCheck.txt');
   events.Items.SaveToFile(ExtractFileDir(PARAMSTR(0))+'\res\box\events.txt');
   Result := True;
end;

end.

