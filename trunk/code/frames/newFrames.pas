unit newFrames;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms, 
  Dialogs, Mask, bsSkinBoxCtrls, bsSkinShellCtrls, bsSkinCtrls, StdCtrls,
  bsSkinExCtrls,UpdateTool,Common,Shellapi;

type
  TNewProForm = class(TFrame)
    bsSkinGroupBox1: TbsSkinGroupBox;
    bsSkinGauge1: TbsSkinGauge;
    bsSkinExPanel4: TbsSkinExPanel;
    TbsSkinMemo2: TbsSkinMemo2;
    bsSkinScrollBar18: TbsSkinScrollBar;
    bsSkinExPanel1: TbsSkinExPanel;
    bsSkinStdLabel1: TbsSkinStdLabel;
    bsSkinStdLabel2: TbsSkinStdLabel;
    bsSkinStdLabel3: TbsSkinStdLabel;
    bsSkinStdLabel4: TbsSkinStdLabel;
    bsSkinStdLabel5: TbsSkinStdLabel;
    bsSkinStdLabel6: TbsSkinStdLabel;
    propath: TbsSkinDirectoryEdit;
    proname: TbsSkinEdit;
    drivers: TbsSkinComboBox;
    bsSkinStdLabel7: TbsSkinStdLabel;
    url: TbsSkinComboBox;
    username: TbsSkinComboBox;
    password: TbsSkinComboBox;
    webservice: TbsSkinComboBox;
    updatePro: TbsSkinButtonEx;
    dialect: TbsSkinComboBox;
    bsSkinStdLabel8: TbsSkinStdLabel;
    procedure updateProClick(Sender: TObject);
  private
    { Private declarations }
    procedure TBeforeDown;
    procedure TBeforeUnZip(value:Integer);
    procedure TOnDowning(value: Integer); //��������ʾ����
    procedure TOnUnZip(value:Integer); //��ѹ��ʾ����
    procedure TAddExplan(explans: string); //����˵��/��־
    procedure TOnfinsh; //ȫ������
  public
    { Public declarations }
    procedure Init;
  end;

implementation

{$R *.dfm}
uses
  main;

procedure TNewProForm.TBeforeDown;
begin
   bsSkinGauge1.MaxValue := 100;
   bsSkinGauge1.Value := 0;
   bsSkinGauge1.ProgressText := '������...';
end;
procedure TNewProForm.TBeforeUnZip(value:Integer);
begin
   bsSkinGauge1.MaxValue := value;
   bsSkinGauge1.Value := 0;
   bsSkinGauge1.ProgressText := '��ѹ��...';
end;
procedure TNewProForm.TOnUnZip(value:Integer);
begin
   bsSkinGauge1.Value := value;
end;
procedure TNewProForm.TOnDowning(value: Integer);
begin
  bsSkinGauge1.Value := value;
end;
procedure TNewProForm.TAddExplan(explans: string);
begin
   TbsSkinMemo2.Lines.Add(explans);
end;
procedure TNewProForm.TOnfinsh;
var
  configs:TStrings;
begin
   if (drivers.Items.IndexOf(drivers.Text) = -1) and (drivers.Text <> '') then
         drivers.Items.Add(drivers.Text);
   if (url.Items.IndexOf(url.Text) = -1) and (url.Text <> '') then
         url.Items.Add(url.Text);
   if (username.Items.IndexOf(username.Text) = -1) and (username.Text <> '')  then
         username.Items.Add(username.Text);
   if (password.Items.IndexOf(password.Text) = -1) and (password.Text <> '') then
         password.Items.Add(password.Text);
   if (webservice.Items.IndexOf(webservice.Text) = -1) and (webservice.Text <> '') then
         webservice.Items.Add(webservice.Text);
   if (dialect.Items.IndexOf(dialect.Text) = -1) and (dialect.Text <> '') then
         dialect.Items.Add(dialect.Text);
   drivers.Items.SaveToFile(ExtractFileDir(PARAMSTR(0))+'\res\box\driver.txt');
   url.Items.SaveToFile(ExtractFileDir(PARAMSTR(0))+'\res\box\url.txt');
   username.Items.SaveToFile(ExtractFileDir(PARAMSTR(0))+'\res\box\username.txt');
   password.Items.SaveToFile(ExtractFileDir(PARAMSTR(0))+'\res\box\password.txt');
   webservice.Items.SaveToFile(ExtractFileDir(PARAMSTR(0))+'\res\box\webservice.txt');
   dialect.Items.SaveToFile(ExtractFileDir(PARAMSTR(0))+'\res\box\dialect.txt');
   TbsSkinMemo2.Lines.Add('������ϣ���ʼ�����ļ�...');
   if not FileExists(propath.Text+'\src\config.properties') then
      TbsSkinMemo2.Lines.Add('config.properties�ļ�������..����');
   
   configs :=  TStringList.Create;
   configs.Add('hibernate.dialect='+dialect.Text);
   if Pos('oracle',url.Text) > 1 then
      configs.Add('lobHandler=oracleLobHandler')
   else
      configs.Add('lobHandler=defaultLobHandler');
   configs.Add('jdbc.url='+url.Text);
   configs.Add('jdbc.encrypt=cm9vdA\=\=');
   configs.Add('jdbc.username='+username.Text);
   configs.Add('jdbc.password='+password.Text);
   configs.Add('jdbc.driverClassName='+drivers.Text);
   configs.Add('sso.webservice.url='+webservice.Text);
   

   configs.SaveToFile(propath.Text+'\src\config.properties');
   TbsSkinMemo2.Lines.Add('config.properties�޸����');
   Common.changeFileContext(propath.Text+'\.mymetadata','base',proname.Text);
   TbsSkinMemo2.Lines.Add('.mymetadata�޸����');
   Common.changeFileContext(propath.Text+'\.project','base',proname.Text);
   TbsSkinMemo2.Lines.Add('.project�޸����');
   updatePro.Enabled := True;
   if not DirectoryExists(propath.Text + '\src\com\sxsihe\' +proname.Text) then
   begin
      ForceDirectories(PChar(propath.Text + '\src\com\sxsihe\' +proname.Text));
      TbsSkinMemo2.Lines.Add('����Ŀ¼'+propath.Text + '\src\com\sxsihe\' +proname.Text);
   end;
   if not DirectoryExists(propath.Text + '\WebRoot\pages') then
   begin
      ForceDirectories(PChar(propath.Text + '\WebRoot\pages'));
      TbsSkinMemo2.Lines.Add('����Ŀ¼'+propath.Text + '\WebRoot\pages');
   end;
   Application.MessageBox('������ɣ�', '��ʾ', MB_OK +
     MB_ICONINFORMATION);
   ShellExecute(Application.Handle, nil, nil, nil, pchar(propath.Text), SW_SHOW);
end;

procedure TNewProForm.Init;
begin
  Common.getHistoryFromtxt(drivers,ExtractFileDir(PARAMSTR(0))+'\res\box\driver.txt');
  Common.getHistoryFromtxt(url,ExtractFileDir(PARAMSTR(0))+'\res\box\url.txt');
  Common.getHistoryFromtxt(username,ExtractFileDir(PARAMSTR(0))+'\res\box\username.txt');
  Common.getHistoryFromtxt(password,ExtractFileDir(PARAMSTR(0))+'\res\box\password.txt');
  Common.getHistoryFromtxt(webservice,ExtractFileDir(PARAMSTR(0))+'\res\box\webservice.txt');
  Common.getHistoryFromtxt(dialect,ExtractFileDir(PARAMSTR(0))+'\res\box\dialect.txt');
end;

procedure TNewProForm.updateProClick(Sender: TObject);
var
  DownTool: TDownTool;
begin
    if propath.Text = '' then
    begin
         Application.MessageBox('��������ĿĿ¼��', '��ʾ', MB_OK +
           MB_ICONSTOP);
         Exit;
    end;
    if proname.Text = '' then
    begin
         Application.MessageBox('��������Ŀ���ƣ�', '��ʾ', MB_OK +
           MB_ICONSTOP);
         Exit;
    end;
    if drivers.Text = '' then
    begin
         Application.MessageBox('��ѡ�����ݿ�������', '��ʾ', MB_OK +
           MB_ICONSTOP);
         Exit;
    end;
    if url.Text = '' then
    begin
         Application.MessageBox('���������ݿ�������䣡', '��ʾ', MB_OK +
           MB_ICONSTOP);
         Exit;
    end;
    if username.Text = '' then
    begin
         Application.MessageBox('���������ݿ��û�����', '��ʾ', MB_OK +
           MB_ICONSTOP);
         Exit;
    end;
    if webservice.Text = '' then
    begin
         Application.MessageBox('������webservice��ַ��', '��ʾ', MB_OK +
           MB_ICONSTOP);
         Exit;
    end;
    if dialect.Text = '' then
    begin
         Application.MessageBox('���������ݿⷽ�ԣ�', '��ʾ', MB_OK +
           MB_ICONSTOP);
         Exit;
    end;
    if not DirectoryExists(propath.Text) then
    begin
      if Application.MessageBox('��ĿĿ¼�����ڣ�Ҫ������', '��ʾ', MB_OKCANCEL+ MB_ICONQUESTION) = 1 then
      begin
            ForceDirectories(PChar(propath.Text));
      end;
    end;
    if password.Text = '' then
    begin
      if Application.MessageBox('���ݿ�����δ���룬������', '��ʾ', MB_OKCANCEL+ MB_ICONQUESTION) <> 1 then
      begin
           Exit;
      end;
    end;
    DownTool := TDownTool.Create;
    DownTool.fireName := 'baseweb';
    DownTool.path := propath.Text;
    DownTool.url := main.Path;
    DownTool.BeforeDown := TBeforeDown;
    DownTool.OnDowning := TOnDowning;
    DownTool.BeforeUnZip := TBeforeUnZip;
    DownTool.OnUnZip := TOnUnZip;
    DownTool.AddExplans := TAddExplan;
    DownTool.Onfinsh := TOnfinsh;
    updatePro.Enabled := False;
    DownTool.Start;
end;

end.
