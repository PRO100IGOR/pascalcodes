unit RuleFormUnit;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, BusinessSkinForm, bsSkinCtrls, StdCtrls, Mask, bsSkinBoxCtrls,Common,
  ExtCtrls;

type
  TRuleFactory = class(TForm)
    bsBusinessSkinForm: TbsBusinessSkinForm;
    bsSkinGroupBox1: TbsSkinGroupBox;
    bsSkinStdLabel6: TbsSkinStdLabel;
    realName: TbsSkinEdit;
    valid: TbsSkinCheckRadioBox;
    bsSkinGroupBox2: TbsSkinGroupBox;
    bsSkinStdLabel5: TbsSkinStdLabel;
    bsSkinStdLabel1: TbsSkinStdLabel;
    showRightMessage: TbsSkinCheckRadioBox;
    rightMessage: TbsSkinComboBox;
    showTeachMessage: TbsSkinCheckRadioBox;
    teachMessage: TbsSkinComboBox;
    bsSkinGroupBox3: TbsSkinGroupBox;
    bsSkinStdLabel3: TbsSkinStdLabel;
    onCheck: TbsSkinComboBox;
    bsSkinGroupBox4: TbsSkinGroupBox;
    events: TbsSkinListBox;
    bsSkinPanel1: TbsSkinPanel;
    bsSkinButton1: TbsSkinButton;
    bsSkinButton2: TbsSkinButton;
    bsSkinGroupBox5: TbsSkinGroupBox;
    rules: TbsSkinMemo;
    bsSkinScrollBar1: TbsSkinScrollBar;
    bsSkinPanel2: TbsSkinPanel;
    bsSkinButton3: TbsSkinButton;
    bsSkinPanel3: TbsSkinPanel;
    bsSkinButton4: TbsSkinButton;
    bsSkinButton5: TbsSkinButton;
    needCheck: TbsSkinCheckRadioBox;
    Shape: TShape;
    bsSkinStdLabel2: TbsSkinStdLabel;
    Timer: TTimer;
    procedure bsSkinButton1Click(Sender: TObject);
    procedure onCheckEnter(Sender: TObject);
    procedure bsSkinButton3Click(Sender: TObject);
    procedure showRightMessageClick(Sender: TObject);
    procedure showTeachMessageClick(Sender: TObject);
    procedure bsSkinButton2Click(Sender: TObject);
    procedure needCheckClick(Sender: TObject);
    procedure TimerTimer(Sender: TObject);
    procedure FormShow(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  RuleFactory: TRuleFactory;

implementation
uses
  main,MethodForms,EventForms,RulesUnit;
{$R *.dfm}

procedure TRuleFactory.bsSkinButton1Click(Sender: TObject);
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

procedure TRuleFactory.bsSkinButton2Click(Sender: TObject);
begin
case Application.MessageBox('请注意：此操作不可恢复！',
            '确定移除吗？', MB_OKCANCEL + MB_ICONWARNING + MB_DEFBUTTON2) of
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

procedure TRuleFactory.bsSkinButton3Click(Sender: TObject);
var
  str:string;
  flag:boolean;
begin
  RulesUnit.realName := realName.Text;
  if RulesChoose = nil then
     RulesChoose := TRulesChoose.Create(Application);
  if  RulesChoose.ShowModal = 1 then
  begin
      if RulesUnit.RulesChoose.rulesList.Text <> '' then
      begin
          str := str + RulesUnit.ruleName + ':{';
          flag := false;
          if RulesUnit.RulesChoose.message.Text <> '' then
          begin
               flag := true;
               str:= str+ 'message:'''+RulesUnit.RulesChoose.message.Text+'''';
          end;
          if RulesUnit.RulesChoose.params.Text <> '' then
          begin
              if flag then
              begin
                  if Pos(']',RulesUnit.RulesChoose.params.Text) = 0 then
                       str:= str+ ',params:'''+RulesUnit.RulesChoose.params.Text+''''
                  else
                       str:= str+ ',params:'+RulesUnit.RulesChoose.params.Text+''
              end
              else
              begin
                  if Pos(']',RulesUnit.RulesChoose.params.Text) = 0 then
                       str:= str+ 'params:'''+RulesUnit.RulesChoose.params.Text+''''
                  else
                       str:= str+ 'params:'+RulesUnit.RulesChoose.params.Text+''
              end;
          end;
          if RulesUnit.RulesChoose.isWarn.Checked then
          begin
              if flag then
              begin
                  str:= str+ ',isWarn:true'
              end
              else
              begin
                  str:= str+ 'isWarn:true'
              end;
          end;
          str := str + '}';
          rules.Lines.Add(str);
      end;
  end;
end;

procedure TRuleFactory.FormShow(Sender: TObject);
begin
Timer.Enabled := True;
end;

procedure TRuleFactory.needCheckClick(Sender: TObject);
begin
  bsSkinGroupBox1.Enabled := needCheck.Checked;
  bsSkinGroupBox2.Enabled := needCheck.Checked;
  bsSkinGroupBox3.Enabled := needCheck.Checked;
  bsSkinGroupBox5.Enabled := needCheck.Checked;
end;

procedure TRuleFactory.onCheckEnter(Sender: TObject);
begin
  if MethodForm = nil then
    MethodForm := TMethodForm.Create(Application);
  MethodForm.ShowModal;
  if  MethodForms.MethodForm.ModalResult = 1 then
  begin
       onCheck.Text :=  MethodForms.MethodForm.chkName.Text + '>' + MethodForms.MethodForm.appName.Text;
  end;
end;

procedure TRuleFactory.showRightMessageClick(Sender: TObject);
begin
    rightMessage.Enabled := showRightMessage.Checked;
end;

procedure TRuleFactory.showTeachMessageClick(Sender: TObject);
begin
    teachMessage.Enabled := showTeachMessage.Checked;
end;

procedure TRuleFactory.TimerTimer(Sender: TObject);
begin
   if Shape.tag mod 2 =  0 then
   begin
       Shape.Width := 250;
   end
   else
   begin
     Shape.Width := 143;
     if Shape.tag > 10  then
     begin
        Shape.tag := 0;
        Timer.Enabled := False;
     end; 
     
   end;
   Shape.tag := Shape.tag + 1;
end;

end.
