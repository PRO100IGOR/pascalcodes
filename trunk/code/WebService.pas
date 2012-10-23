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
       ErrorLogsUnit.addErrors('读取模块列表时发生异常！');
       Application.MessageBox('连接不到webservice！', '提示', MB_OK +
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
    Application.MessageBox('选择所属系统！', '提示', MB_OK +
      MB_ICONSTOP);
    Exit;
  end;
  if models.ItemIndex = -1 then
  begin
    if Application.MessageBox('没有选择所属模块，将作为顶级菜单添加到系统下！' +
      #13#10 + '是否继续?', '提示', MB_OKCANCEL + MB_ICONQUESTION) <> MB_OK then
      Exit;
     Rid := '';
     msg :=  '[系统]' + AArrayOfApplication[apps.ItemIndex].apptitle + '的顶级菜单:'+ menuName.Text;
  end
  else
  begin
      Rid := AArrayOfResources[models.ItemIndex].resourceid;
      msg :=  '[系统]' + AArrayOfApplication[apps.ItemIndex].apptitle + '的菜单:'+ AArrayOfResources[models.ItemIndex].resourcename + '的子菜单:' + menuName.Text;
  end;


  try
    AResourceServerPortType := GetResourceServerPortType(True,main.oxhidePath + '/services/ResourceServer?wsdl',HTTPRIO1);
    AResourceServerPortType.add1(Common.encode(menuName.Text),'',AArrayOfApplication[apps.ItemIndex].appid,Rid,'/'+main.MainForm.NewModelForm.ModelCode.modelName + 'LoadAction.do?action=showList');
    ErrorLogsUnit.addErrors('添加菜单'+menuName.Text +'到'+AArrayOfApplication[apps.ItemIndex].apptitle+'系统的'+AArrayOfResources[models.ItemIndex].resourcename+'模块下');
    Application.MessageBox(PChar( '保存成功为：'+#13#10+ msg+ #13#10 + '请登录系统为角色分配资源！'), '提示',
      MB_OK + MB_ICONINFORMATION);
    ShellExecute(handle, 'open', 'explorer.exe', pChar(oxhidePath), nil, SW_SHOWNORMAL);
    Close;
  except
     ErrorLogsUnit.addErrors('添加菜单时发生异常！');
     Application.MessageBox('连接不到webservice！', '提示', MB_OK +
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
     Application.MessageBox('config.ini中没有设置oxhide地址！', '提示', MB_OK +
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
     ErrorLogsUnit.addErrors('读取系统列表时发生异常！');
     Application.MessageBox('连接不到webservice！', '提示', MB_OK +
         MB_ICONSTOP);
  end;

end;

end.
