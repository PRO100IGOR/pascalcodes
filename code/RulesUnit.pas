unit RulesUnit;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs,XMLIntf, msxmldom, XMLDoc, StdCtrls, bsSkinCtrls, bsSkinBoxCtrls, Mask,
  BusinessSkinForm,IdHTTP,Common, bsDialogs, ExtCtrls;

type
  TRulesChoose = class(TForm)
    bsBusinessSkinForm: TbsBusinessSkinForm;
    diag: TbsSkinInputDialog;
    bsSkinGroupBox2: TbsSkinGroupBox;
    bsSkinStdLabel6: TbsSkinStdLabel;
    bsSkinStdLabel3: TbsSkinStdLabel;
    HelpLable: TbsSkinStdLabel;
    rulesList: TbsSkinComboBox;
    bsSkinGroupBox1: TbsSkinGroupBox;
    bsSkinStdLabel1: TbsSkinStdLabel;
    bsSkinStdLabel2: TbsSkinStdLabel;
    params: TbsSkinEdit;
    message: TbsSkinEdit;
    isWarn: TbsSkinCheckRadioBox;
    bsSkinButton1: TbsSkinButton;
    Button2: TbsSkinButton;
    bsSkinButton3: TbsSkinButton;
    procedure FormCreate(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure rulesListChange(Sender: TObject);
    procedure FormShow(Sender: TObject);
  private
    { Private declarations }
    procedure getRules;
  public
    { Public declarations }
  end;

var
  RulesChoose: TRulesChoose;
  realName,ruleName:String;
  rulesName,ruleRealName:TStrings;
implementation
uses
  main,CompareUnit,TypesUnit;
{$R *.dfm}
procedure TRulesChoose.Button1Click(Sender: TObject);
var
  s:Tstrings;
  str,temp:string;
begin
  if Trim(rulesList.Text) = '' then
  begin
      Application.MessageBox('请选择规则！', '提示', MB_OK + MB_ICONSTOP);
      Exit;
  end;
  ruleName := rulesName[ruleRealName.IndexOf(rulesList.Text)];

  if ruleName = 'must' then
  begin
      params.ReadOnly := true;
      message.ReadOnly := false;
      HelpLable.Caption := '不需要参数！'#13'默认消息：请输入'+realName;
  end
  else if ruleName = 'trimCheck' then
  begin
      params.ReadOnly := true;
      message.ReadOnly := false;
      HelpLable.Caption := '不需要参数！'#13'默认消息：'+realName + '不能输入空格！'
  end
  else if ruleName = 'types' then
  begin
      if TypesForm = nil then TypesForm := TTypesForm.Create(Application);
      TypesForm.ShowModal;
      if TypesForm.ModalResult = 1 then
      begin
          if TypesForm.types.ItemIndex <> -1 then
          begin
             params.Text := TypesUnit.names[TypesUnit.TypesForm.types.ItemIndex];
             HelpLable.Caption := '这是一些自定义正则表达式！'#13'默认消息'+TypesUnit.messages[TypesUnit.TypesForm.types.ItemIndex];
          end;
          params.ReadOnly := false;
          message.ReadOnly := false;
      end;
  end
  else if ruleName = 'illegal' then
  begin
      s := common.getValueFromServer('illegal.txt',main.Path);
      params.ReadOnly := false;
      message.ReadOnly := false;
      HelpLable.Caption := '参数是非法字符！'#13'默认消息：'+realName + s[1]+#13'默认参数：'+s[0];
  end
  else if ruleName = 'compareLength' then
  begin
      if CompareForm = nil then CompareForm := TCompareForm.Create(Application);
      CompareForm.ShowModal;
      if CompareForm.ModalResult = 1 then
      begin
          str := params.Text;
          if str = '' then str := '['
          else str :=StringReplace(str,']',',',[]);
          if CompareForm.realName.Text <> '' then
            str := str + ''''+CompareForm.action.Text+CompareForm.CPname.Text + '|'+ CompareForm.realName.Text + ''']'
          else
            str := str + ''''+CompareForm.action.Text+CompareForm.CPname.Text+ ''']';
          params.Text := str;
          params.ReadOnly := false;
          message.ReadOnly := false;
      end;
      HelpLable.Caption := '参数是一个数组！'#13'默认的message例如'#13'选择比较方式是>=,message是用户名的长度不能小于5'#13'如果选择的比较方式是大于，那消息就是不能小于等于';
  end
  else if ruleName = 'compareValue' then
  begin
      if CompareForm = nil then CompareForm := TCompareForm.Create(Application);
      CompareForm.ShowModal;
      if CompareForm.ModalResult = 1 then
      begin
          str := params.Text;
          if str = '' then str := '['
          else str :=StringReplace(str,']',',',[]);
          if CompareForm.realName.Text <> '' then
            str := str + ''''+CompareForm.action.Text+CompareForm.CPname.Text + '|'+ CompareForm.realName.Text + ''']'
          else
            str := str + ''''+CompareForm.action.Text+CompareForm.CPname.Text+ ''']';
          params.Text := str;
          params.ReadOnly := false;
          message.ReadOnly := false;
      end;
      HelpLable.Caption := '参数是一个数组！'#13'默认的message例如'#13'选择比较方式是>=,message是用户名不能小于5'#13'如果选择的比较方式是大于，那消息就是不能小于等于';
  end
  else if ruleName = 'chooseCompare' then
  begin
      if CompareForm = nil then CompareForm := TCompareForm.Create(Application);
      CompareForm.ShowModal;
      if CompareForm.ModalResult = 1 then
      begin
          str := params.Text;
          if str = '' then str := '['
          else str :=StringReplace(str,']',',',[]);
          if CompareForm.realName.Text <> '' then
            str := str + ''''+CompareForm.action.Text+CompareForm.CPname.Text + '|'+ CompareForm.realName.Text + ''']'
          else
            str := str + ''''+CompareForm.action.Text+CompareForm.CPname.Text+ ''']';
          params.Text := str;
          params.ReadOnly := false;
          message.ReadOnly := false;
      end;
      HelpLable.Caption := '参数是一个数组！'#13'默认的message例如'#13'选择比较方式是>=,message是用户名的选择个数不能小于5'#13'如果选择的比较方式是大于，那消息就是不能小于等于';
  end
  else if ruleName = 'suffix' then
  begin
      params.ReadOnly := false;
      message.ReadOnly := false;
      HelpLable.Caption := 'params中输入文件类型，多个类型用英文逗号分隔'#13'默认消息:'+realName+'文件类型错误,请选择后缀名为xxx的文件';
  end
  else if ruleName = 'unsuffix' then
  begin
      params.ReadOnly := false;
      message.ReadOnly := false;
      HelpLable.Caption := 'params中输入文件类型，多个类型用英文逗号分隔'#13'默认消息:'+realName+'文件类型错误,不能选择后缀名为xxx的文件';
  end
  else if ruleName = 'regular' then
  begin
      temp := diag.InputBox('请输入自定义正则表达式！','正则表达式：','');
      if temp <> '' then
      begin
          str := params.Text;
          if str = '' then str := '['
          else str :=StringReplace(str,']',',',[]);
          str := str + ''''+temp + ''']';
          params.Text := str;
          params.ReadOnly := false;
          message.ReadOnly := false;
      end;
      HelpLable.Caption := '参数是一个数组';
  end
  else if ruleName = 'dwr' then
  begin
      params.ReadOnly := false;
      message.ReadOnly := false;
      HelpLable.Caption := '参数dwr调用方法，如DWRBaseClass.checkObjcect(v1,v2,v3)'#13'如果是控件的内容，请加^,如DWRBaseClass.checkObjcect(name^,name2^)'#13'输入的'+ realName+'已经存在！';
  end
  else if ruleName = 'method' then
  begin
      params.ReadOnly := false;
      message.ReadOnly := false;
      HelpLable.Caption := '自定义方法需要返回boolean值'#13'默认消息：'+realName+'输入错误！';
  end;
  params.Enabled := True;
  message.Enabled := True;
  Button2.Enabled :=True;
  isWarn.Enabled := True;
end;

procedure TRulesChoose.FormCreate(Sender: TObject);
begin
  getRules;
end;

procedure TRulesChoose.FormShow(Sender: TObject);
begin
   params.Text := '';
   params.Enabled := False;
   message.Enabled := False;
   Button2.Enabled :=False;
   isWarn.Enabled := False;
   message.Text := '';
   rulesList.ItemIndex := -1;
   rulesList.Text := '';
   isWarn.Checked := False;
end;

procedure TRulesChoose.getRules;
var
    XMLDocument : IXMLDocument;
    rootNode,beanNode :IXMLNode;
    index : Integer;
    idhtpLog: TIdHTTP;
    Stream: TMemoryStream;
begin
      rulesName := TStringList.Create;
      ruleRealName := TStringList.Create;
      Stream := TMemoryStream.Create;
      idhtpLog := TIdHTTP.Create(Application);
    try
      idhtpLog.Get(main.Path + '/res/rules.xml', Stream);
      XMLDocument :=  TXMLDocument.Create(Application);
      XMLDocument.LoadFromStream(Stream);
      rootNode := XMLDocument.DocumentElement;
      for index := 0 to rootNode.ChildNodes.Count - 1 do
      begin
          beanNode:= rootNode.ChildNodes[index];
          rulesName.Add(beanNode.GetAttributeNS('name',''));
          ruleRealName.Add(beanNode.GetAttributeNS('value',''));
          rulesList.Items.Add(beanNode.GetAttributeNS('value',''));
      end;
    finally
      XMLDocument := nil;
      idhtpLog.Free;
    end;
end;

procedure TRulesChoose.rulesListChange(Sender: TObject);
begin
   params.Text := '';
   message.Text := '';
end;

end.

