unit login;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ExtCtrls,SkinH, InvokeRegistry, Rio, SOAPHTTPClient,
  ALHintBalloon,ConfigUnit,Ini,UserServer,Common,ErrorLogsUnit, CoolTrayIcon,UpdateToolForApi,
  ImgList;

type
  TLoginForm = class(TForm)
    Label1: TLabel;
    Label2: TLabel;
    editUserName: TEdit;
    editPassword: TEdit;
    chkSave: TCheckBox;
    AutoLogin: TCheckBox;
    cmdLogin: TButton;
    Image1: TImage;
    Image2: TImage;
    HTTPRIO: THTTPRIO;
    ConfigBtn: TButton;
    Hint: TALHintBalloonControl;
    Timer: TTimer;
    procedure FormCreate(Sender: TObject);
    procedure ConfigBtnClick(Sender: TObject);
    procedure cmdLoginClick(Sender: TObject);
    procedure AutoLoginClick(Sender: TObject);
    procedure TimerTimer(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  LoginForm: TLoginForm;
  ip,port,eid:string;
implementation
uses
  MainForm,Tip;
{$R *.dfm}

procedure TLoginForm.ConfigBtnClick(Sender: TObject);
begin
if Config = nil then
  Config := TConfig.Create(Application);
Config.ShowModal;
end;

procedure TLoginForm.AutoLoginClick(Sender: TObject);
begin
    if AutoLogin.Checked then
      chkSave.Checked := True;
end;

procedure TLoginForm.cmdLoginClick(Sender: TObject);
var
   AUserServerPortType:UserServerPortType;
begin
  Timer.Enabled := False;
  if editUserName.Text = '' then
  begin
    Hint.ShowTextHintBalloon(bmtError, '', '请输入用户名！', 300, 10, 10, editUserName, bapBottomLeft);
    Exit;
  end;
  if editPassword.Text = '' then
  begin
    Hint.ShowTextHintBalloon(bmtError, '', '请输入密码！', 300, 10, 10, editPassword, bapBottomLeft);
    Exit;
  end;
  ip := Ini.ReadIni('server','ip');
  if ip = '' then
  begin
      Application.MessageBox('系统检测到您没有设置服务器IP，因此无法登录，请先设置服务器Ip！',
        '发生错误', MB_OK + MB_ICONSTOP);
      ConfigBtn.Click;
      Exit;
  end;
  port :=  Ini.ReadIni('server','port');
  if port = '' then
  begin
      Application.MessageBox('系统检测到您没有设置服务器端口，因此无法登录，请先设置服务器端口！',
        '发生错误', MB_OK + MB_ICONSTOP);
      ConfigBtn.Click;
      Exit;
  end;
  cmdLogin.Enabled := False;
  AUserServerPortType := GetUserServerPortType(True,'http://'+ip+':'+port+'/oxhide/services/UserServer?wsdl',HTTPRIO);
  try
     eid := AUserServerPortType.loginHasEID(editUserName.Text,editPassword.Text);
     AUserServerPortType._Release;
     if eid = '' then
     begin
        Application.MessageBox('用户名或者密码错误！','发生错误', MB_OK + MB_ICONSTOP);
        cmdLogin.Enabled := True;
        Exit;
     end
     else
     begin
         if AutoLogin.Checked then
         begin
           Ini.WriteIni('server','autoLogin','true');
           Ini.WriteIni('server','chkSave','true');
           Ini.WriteIni('server','username',editUserName.Text);
           Ini.WriteIni('server','password',Encrypt(editPassword.Text));
         end
         else if chkSave.Checked then
         begin
           Ini.WriteIni('server','chkSave','true');
           Ini.DeleteIni('server','autoLogin');
           Ini.DeleteIni('server','password');
           Ini.WriteIni('server','username',editUserName.Text);
         end
         else
         begin
           Ini.DeleteIni('server','autoLogin');
           Ini.DeleteIni('server','chkSave');
           Ini.DeleteIni('server','password');
           Ini.DeleteIni('server','username');
         end;
         cmdLogin.Enabled := True;
         if Main = nil then
            Main := TMain.Create(Application);
         MainForm.path :='http://'+ip+':'+port+'/office/services/FlowrunServer?wsdl';
         if TipForm <> nil then
            TipForm.Close;
         Main.TimerTimer(nil);
         Main.Timer.Enabled := True;
         Main.Show;
         Self.Hide;
     end;
  except
    Application.MessageBox('服务器连接错误，请检查您的配置！','发生错误', MB_OK + MB_ICONSTOP);
    cmdLogin.Enabled := True;
    ConfigBtn.Click;
    ErrorLogsUnit.addErrors('登录发生异常，ip='+ip+',端口='+port);
    Exit;
  end;
end;

procedure TLoginForm.FormCreate(Sender: TObject);
var
  url:string;
  version:string;
begin
  SkinH_Attach;
  ip := Ini.ReadIni('server','ip');
  if ip = '' then
  begin
      Application.MessageBox('系统检测到您没有设置服务器IP，因此无法登录，请先设置服务器Ip！',
        '发生错误', MB_OK + MB_ICONSTOP);
      ConfigBtn.Click;
      Exit;
  end;
  port :=  Ini.ReadIni('server','port');
  if port = '' then
  begin
      Application.MessageBox('系统检测到您没有设置服务器端口，因此无法登录，请先设置服务器端口！',
        '发生错误', MB_OK + MB_ICONSTOP);
      ConfigBtn.Click;
      Exit;
  end;
  version := Ini.ReadIni('server','version');
  url := 'http://'+ip+':'+port;
  UpdateToolForApi.getUpdateInfo(Url, version,'Config.ini','server');
  if not DirectoryExists(ExtractFileDir(PARAMSTR(0)) + '\logs') then CreateDirectory(PChar(ExtractFilePath(ParamStr(0)) + '\logs'), nil);
  editUserName.Text := Ini.ReadIni('server','username');
  editPassword.Text := Decrypt(Ini.ReadIni('server','password'));
  AutoLogin.Checked :=  Ini.ReadIni('server','autoLogin') = 'true';
  chkSave.Checked :=  Ini.ReadIni('server','chkSave') = 'true';
  if AutoLogin.Checked then
  begin
      Timer.Enabled := True;
      cmdLogin.Enabled := False;
  end;
end;

procedure TLoginForm.TimerTimer(Sender: TObject);
begin
    cmdLoginClick(nil);
end;

end.
