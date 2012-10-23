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
      Application.MessageBox('��ѡ�����', '��ʾ', MB_OK + MB_ICONSTOP);
      Exit;
  end;
  ruleName := rulesName[ruleRealName.IndexOf(rulesList.Text)];

  if ruleName = 'must' then
  begin
      params.ReadOnly := true;
      message.ReadOnly := false;
      HelpLable.Caption := '����Ҫ������'#13'Ĭ����Ϣ��������'+realName;
  end
  else if ruleName = 'trimCheck' then
  begin
      params.ReadOnly := true;
      message.ReadOnly := false;
      HelpLable.Caption := '����Ҫ������'#13'Ĭ����Ϣ��'+realName + '��������ո�'
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
             HelpLable.Caption := '����һЩ�Զ���������ʽ��'#13'Ĭ����Ϣ'+TypesUnit.messages[TypesUnit.TypesForm.types.ItemIndex];
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
      HelpLable.Caption := '�����ǷǷ��ַ���'#13'Ĭ����Ϣ��'+realName + s[1]+#13'Ĭ�ϲ�����'+s[0];
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
      HelpLable.Caption := '������һ�����飡'#13'Ĭ�ϵ�message����'#13'ѡ��ȽϷ�ʽ��>=,message���û����ĳ��Ȳ���С��5'#13'���ѡ��ıȽϷ�ʽ�Ǵ��ڣ�����Ϣ���ǲ���С�ڵ���';
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
      HelpLable.Caption := '������һ�����飡'#13'Ĭ�ϵ�message����'#13'ѡ��ȽϷ�ʽ��>=,message���û�������С��5'#13'���ѡ��ıȽϷ�ʽ�Ǵ��ڣ�����Ϣ���ǲ���С�ڵ���';
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
      HelpLable.Caption := '������һ�����飡'#13'Ĭ�ϵ�message����'#13'ѡ��ȽϷ�ʽ��>=,message���û�����ѡ���������С��5'#13'���ѡ��ıȽϷ�ʽ�Ǵ��ڣ�����Ϣ���ǲ���С�ڵ���';
  end
  else if ruleName = 'suffix' then
  begin
      params.ReadOnly := false;
      message.ReadOnly := false;
      HelpLable.Caption := 'params�������ļ����ͣ����������Ӣ�Ķ��ŷָ�'#13'Ĭ����Ϣ:'+realName+'�ļ����ʹ���,��ѡ���׺��Ϊxxx���ļ�';
  end
  else if ruleName = 'unsuffix' then
  begin
      params.ReadOnly := false;
      message.ReadOnly := false;
      HelpLable.Caption := 'params�������ļ����ͣ����������Ӣ�Ķ��ŷָ�'#13'Ĭ����Ϣ:'+realName+'�ļ����ʹ���,����ѡ���׺��Ϊxxx���ļ�';
  end
  else if ruleName = 'regular' then
  begin
      temp := diag.InputBox('�������Զ���������ʽ��','������ʽ��','');
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
      HelpLable.Caption := '������һ������';
  end
  else if ruleName = 'dwr' then
  begin
      params.ReadOnly := false;
      message.ReadOnly := false;
      HelpLable.Caption := '����dwr���÷�������DWRBaseClass.checkObjcect(v1,v2,v3)'#13'����ǿؼ������ݣ����^,��DWRBaseClass.checkObjcect(name^,name2^)'#13'�����'+ realName+'�Ѿ����ڣ�';
  end
  else if ruleName = 'method' then
  begin
      params.ReadOnly := false;
      message.ReadOnly := false;
      HelpLable.Caption := '�Զ��巽����Ҫ����booleanֵ'#13'Ĭ����Ϣ��'+realName+'�������';
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

