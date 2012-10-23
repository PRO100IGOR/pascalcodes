unit WebService;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, BusinessSkinForm, bsSkinCtrls, StdCtrls, Mask, bsSkinBoxCtrls,ApplicationServer,
  InvokeRegistry, Rio, SOAPHTTPClient,ResourceServer,ShellApi,ErrorLogsUnit,Common;

type
  TWebServiceForm = class(TForm)
    bsBusinessSkinForm: TbsBusinessSkinForm;
    bsSkinButton3: TbsSkinButton;
    apps: TbsSkinComboBox;
    bsSkinStdLabel1: TbsSkinStdLabel;
    bsSkinButton1: TbsSkinButton;
    bsSkinStdLabel3: TbsSkinStdLabel;
    models: TbsSkinComboBox;
    bsSkinStdLabel2: TbsSkinStdLabel;
    menuName: TbsSkinEdit;
    bsSkinStdLabel4: TbsSkinStdLabel;
    HTTPRIO: THTTPRIO;
    HTTPRIO1: THTTPRIO;
    procedure appsChange(Sender: TObject);
    procedure bsSkinButton1Click(Sender: TObject);
    procedure bsSkinButton3Click(Sender: TObject);
    procedure FormShow(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  WebServiceForm: TWebServiceForm;

implementation
uses
  main;
var
  AArrayOfApplication:ArrayOfApplication;
  AArrayOfResources:ArrayOfResources;
{$R *.dfm}

procedure TWebServiceForm.appsChange(Sender: TObject);
var
  AResourceServerPortType:ResourceServerPortType;
  I:Integer;
begin
  if apps.ItemIndex > -1 then
  begin
    try
      AResourceServerPortType := GetResourceServerPortType(True,main.oxhidePath + '/services/ResourceServer?wsdl',HTTPRIO1);
      AArrayOfResources := AResourceServerPortType.queryHql('from Resources  t where t.application.appid = '''+AArrayOfApplication[apps.ItemIndex].appid+'''');
      models.Items.Clear;
      for I := 0 to Length(AArrayOfResources) - 1 do
      begin
           models.Items.Add(AArrayOfResources[I].resourcename);
      end;
      AResourceServerPortType._Release;
    except
       ErrorLogsUnit.addErrors('��ȡģ���б�ʱ�����쳣��');
       Application.MessageBox('���Ӳ���webservice��', '��ʾ', MB_OK +
         MB_ICONSTOP);
    end;

  end;
end;

procedure TWebServiceForm.bsSkinButton1Click(Sender: TObject);
begin
Close;
end;

procedure TWebServiceForm.bsSkinButton3Click(Sender: TObject);
var
  AResourceServerPortType:ResourceServerPortType;
  Rid,msg:string;
begin
  if apps.ItemIndex = -1 then
  begin
    Application.MessageBox('ѡ������ϵͳ��', '��ʾ', MB_OK +
      MB_ICONSTOP);
    Exit;
  end;
  if models.ItemIndex = -1 then
  begin
    if Application.MessageBox('û��ѡ������ģ�飬����Ϊ�����˵���ӵ�ϵͳ�£�' +
      #13#10 + '�Ƿ����?', '��ʾ', MB_OKCANCEL + MB_ICONQUESTION) <> MB_OK then
      Exit;
     Rid := '';
     msg :=  '[ϵͳ]' + AArrayOfApplication[apps.ItemIndex].apptitle + '�Ķ����˵�:'+ menuName.Text;
  end
  else
  begin
      Rid := AArrayOfResources[models.ItemIndex].resourceid;
      msg :=  '[ϵͳ]' + AArrayOfApplication[apps.ItemIndex].apptitle + '�Ĳ˵�:'+ AArrayOfResources[models.ItemIndex].resourcename + '���Ӳ˵�:' + menuName.Text;
  end;


  try
    AResourceServerPortType := GetResourceServerPortType(True,main.oxhidePath + '/services/ResourceServer?wsdl',HTTPRIO1);
    AResourceServerPortType.add1(Common.encode(menuName.Text),'',AArrayOfApplication[apps.ItemIndex].appid,Rid,'/'+main.MainForm.NewModelForm.ModelCode.modelName + 'LoadAction.do?action=showList');
    ErrorLogsUnit.addErrors('��Ӳ˵�'+menuName.Text +'��'+AArrayOfApplication[apps.ItemIndex].apptitle+'ϵͳ��'+AArrayOfResources[models.ItemIndex].resourcename+'ģ����');
    Application.MessageBox(PChar( '����ɹ�Ϊ��'+#13#10+ msg+ #13#10 + '���¼ϵͳΪ��ɫ������Դ��'), '��ʾ',
      MB_OK + MB_ICONINFORMATION);
    ShellExecute(handle, 'open', 'explorer.exe', pChar(oxhidePath), nil, SW_SHOWNORMAL);
    Close;
  except
     ErrorLogsUnit.addErrors('��Ӳ˵�ʱ�����쳣��');
     Application.MessageBox('���Ӳ���webservice��', '��ʾ', MB_OK +
       MB_ICONSTOP);
  end;

end;

procedure TWebServiceForm.FormShow(Sender: TObject);
var
  AApplicationServerPortType:ApplicationServerPortType;
  I:Integer;
begin
  try
    if main.oxhidePath = '' then
    begin
     Application.MessageBox('config.ini��û������oxhide��ַ��', '��ʾ', MB_OK +
         MB_ICONSTOP);
     Exit;    
    end;
    
    AApplicationServerPortType := GetApplicationServerPortType(True,main.oxhidePath + '/services/ApplicationServer?wsdl',HTTPRIO);
    AArrayOfApplication := AApplicationServerPortType.getAll;
    apps.Items.Clear;
    for I := 0 to Length(AArrayOfApplication) - 1 do
    begin
        apps.Items.Add(AArrayOfApplication[I].appname);
    end;
    AApplicationServerPortType._Release;
    menuName.Text := main.MainForm.NewModelForm.ModelCode.modelChname;
  except
     ErrorLogsUnit.addErrors('��ȡϵͳ�б�ʱ�����쳣��');
     Application.MessageBox('���Ӳ���webservice��', '��ʾ', MB_OK +
         MB_ICONSTOP);
  end;

end;

end.
