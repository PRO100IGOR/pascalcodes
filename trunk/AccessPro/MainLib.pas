unit MainLib;

interface

uses
  Windows, SysUtils, Classes, Controls, Forms,StdCtrls, ComCtrls, ExtCtrls,Tools,Graphics,Dialogs,
  TooltipUtil,PerlRegEx,Messages,ShellAPi;

type
  TMainForm = class(TForm)
    PageControl1: TPageControl;
    TabSheet1: TTabSheet;
    LogMemo: TMemo;
    GroupBox1: TGroupBox;
    ServerColor: TShape;
    ServerState: TLabel;
    btnStopStart: TButton;
    btnClearLog: TButton;
    btnInstallUnInstall: TButton;
    TabSheet2: TTabSheet;
    SQLBox: TScrollBox;
    GroupBox2: TGroupBox;
    Label1: TLabel;
    cbbTaskNames: TComboBox;
    btnLoad: TButton;
    btnSave: TButton;
    btnDelTask: TButton;
    lbledtReadTime: TLabeledEdit;
    btnAddSql: TButton;
    TabSheet3: TTabSheet;
    TabSheet4: TTabSheet;
    Memo1: TMemo;
    lbledtServer: TLabeledEdit;
    cbbDataName: TComboBox;
    Label2: TLabel;
    lbledtPort: TLabeledEdit;
    lbledtUserName: TLabeledEdit;
    lbledtPassWord: TLabeledEdit;
    cbbDataType: TComboBox;
    Label3: TLabel;
    btnLoadData: TButton;
    btnSaveData: TButton;
    btnData: TButton;
    lbledtDataBase: TLabeledEdit;
    tltpA: TToolTip;
    Timer: TTimer;
    Button1: TButton;
    Label4: TLabel;
    Label5: TLabel;
    Label6: TLabel;
    Label7: TLabel;
    procedure FormCreate(Sender: TObject);
    procedure btnClearLogClick(Sender: TObject);
    procedure btnAddSqlClick(Sender: TObject);
    procedure Panel1Click(Sender: TObject);
    procedure btnLoadDataClick(Sender: TObject);
    procedure btnSaveDataClick(Sender: TObject);
    procedure btnDataClick(Sender: TObject);
    procedure btnSaveClick(Sender: TObject);
    procedure btnLoadClick(Sender: TObject);
    procedure btnDelTaskClick(Sender: TObject);
    procedure cbbDataTypeChange(Sender: TObject);
    procedure TimerTimer(Sender: TObject);
    procedure btnInstallUnInstallClick(Sender: TObject);
    procedure btnStopStartClick(Sender: TObject);
    procedure btnAccessPjClick(Sender: TObject);
  private
    { Private declarations }
    procedure btnDelClick(Sender: TObject);
  public
    { Public declarations }
    procedure LoadLogs;
    procedure ReadLogs;
    procedure InitServiceState;
    function checkSqlTyep(sql:string):Boolean;//true,sql语句执行上一步中查询记录数次，false，执行1次
  end;

var
  MainForm: TMainForm;
  ComputName:string; //计算机名
  LinesCount :Integer; //读取到最新日志文件的第几行了.
implementation

{$R *.dfm}

procedure TMainForm.InitServiceState;
var
  install,IsRunning : Boolean;
begin
  if ComputName = '' then
     ComputName := Tools.ComputerName;
  install := Tools.ServiceInstalled(ComputName,'shService');
  if not install then
  begin
      ServerColor.Brush.Color := clRed;
      ServerState.Caption := '四和数据采集服务尚未安装!';
      btnStopStart.Enabled := False;
      btnInstallUnInstall.Enabled := True;
  end
  else
  begin
      IsRunning := Tools.ServiceRunning(ComputName,'shService');
      if IsRunning then
      begin
          ServerColor.Brush.Color := clGreen;
          ServerState.Caption := '四和数据采集服务运行中...';
          btnStopStart.Enabled := True;
          btnStopStart.Caption := '停止服务';
          btnInstallUnInstall.Enabled := True;
          btnInstallUnInstall.Caption := '卸载服务';
      end
      else
      begin
          ServerColor.Brush.Color := clPurple;
          ServerState.Caption := '四和数据采集服务已停止!';
          btnStopStart.Enabled := True;
          btnStopStart.Caption := '启动服务';
          btnInstallUnInstall.Enabled := True;
          btnInstallUnInstall.Caption := '卸载服务'
      end;
  end;
end;
procedure TMainForm.btnDataClick(Sender: TObject);
begin
    if cbbDataName.Items.IndexOf(cbbDataName.Text) > -1 then
    begin
       if Application.MessageBox('确定删除？删除后无法恢复！', 
         PChar(Application.Title), MB_OKCANCEL + MB_ICONQUESTION) = IDOK then
       begin
           DeleteFile(ExtractFileDir(PARAMSTR(0)) +'\data\' + cbbDataName.Text);
           cbbDataName.Items.Delete(cbbDataName.Items.IndexOf(cbbDataName.Text));
           cbbDataName.Text := '';
           cbbDataType.Text := '';
           lbledtServer.Text := '';
           lbledtPort.Text := '';
           lbledtUserName.Text := '';
           lbledtPassWord.Text := '';
       end;
    end;
end;

procedure TMainForm.btnDelClick(Sender: TObject);
var
    I,Count : Integer;
begin
    (Sender as TButton).Parent.Parent.Free;
    Count := SQLBox.ControlCount;
    for I := 0 to Count - 1 do
    begin
          (SQLBox.Controls[I] as TSql).Top := I * 125 + 5;
          (SQLBox.Controls[I] as TSql).bLable.Caption := '第 ' + InttoStr(I+1) + ' 步 ';
    end;
end;
procedure TMainForm.btnDelTaskClick(Sender: TObject);
var
    Count,I:Integer;
begin
    if cbbTaskNames.Items.IndexOf(cbbTaskNames.Text) > -1 then
    begin
      if Application.MessageBox('确定删除？删除后无法恢复！', 
        PChar(Application.Title), MB_OKCANCEL + MB_ICONQUESTION) = IDOK then
      begin
         DeleteFile(ExtractFileDir(PARAMSTR(0)) +'\task\' + cbbTaskNames.Text);
         cbbTaskNames.Items.Delete(cbbTaskNames.Items.IndexOf(cbbTaskNames.Text));
         cbbTaskNames.Text := '';
         lbledtReadTime.Text := '';
         Count := SQLBox.ControlCount;
         for I := 0 to Count - 1 do
         begin
             SQLBox.Controls[0].Free;
         end;
      end;
    end;
end;

procedure TMainForm.btnInstallUnInstallClick(Sender: TObject);
begin
    if btnInstallUnInstall.Caption = '安装服务' then
    begin
      Tools.RunDOS('AccessService.exe /install');
      btnInstallUnInstall.Caption := '卸载服务';
    end
    else
    begin
      Tools.RunDOS('sc delete shService');
      btnInstallUnInstall.Caption := '安装服务';
    end;
    InitServiceState;
end;

procedure TMainForm.btnLoadClick(Sender: TObject);
var
   task : TTask;
   I,Count:Integer;
   Sql : TSql;
begin
    if cbbTaskNames.Items.IndexOf(cbbTaskNames.Text) > -1 then
    begin
       Count := SQLBox.ControlCount;
       for I := 0 to Count - 1 do
       begin
           SQLBox.Controls[0].Free;
       end;
        task := Tools.getTask(cbbTaskNames.Text);
        lbledtReadTime.Text := InttoStr(task.time);
        Count := task.sql.Count;
        for I := 0 to Count - 1 do
        begin
            Sql := TSql.Create(Application,cbbDataName.Items,SQLBox);
            Sql.btnDel.OnClick := btnDelClick;
            Sql.SQL.Text := task.sql[I];
            Sql.bLable.Caption := '第 ' + InttoStr(I+1) + ' 步 ';
            Sql.DataSource.ItemIndex :=  Sql.DataSource.Items.IndexOf(task.data[I]);
        end;
    end;
end;
function TMainForm.checkSqlTyep(sql:string):Boolean;//true,sql语句执行上一步中查询记录数次，false，执行1次
var
  RegEx : TPerlRegEx;
begin
  RegEx := TPerlRegEx.Create(Application);
  RegEx.RegEx := '.+:\w+';
  RegEx.Subject := sql;
  Result := RegEx.Match;
  RegEx.Free;
end;
procedure TMainForm.btnLoadDataClick(Sender: TObject);
var
    data : TDataSource;
begin
    if cbbDataName.Items.IndexOf(cbbDataName.Text) > -1 then
    begin
       data := Tools.getData(cbbDataName.Text);
       cbbDataType.ItemIndex := cbbDataType.Items.IndexOf(data.DataType);
       lbledtServer.Text := data.Server;
       lbledtPort.Text := data.Port;
       lbledtUserName.Text := data.UserName;
       lbledtPassWord.Text := data.PassWord;
       lbledtDataBase.Text := data.DataBase;
       data.Free;
    if cbbDataType.Text = 'MySql' then
    begin
        lbledtServer.Enabled := True;
        lbledtPort.Enabled := True;
        lbledtDataBase.Enabled := True;
        lbledtUserName.Enabled := True;
        lbledtPassWord.Enabled := True;
    end
    else if cbbDataType.Text = 'Oracle' then
    begin
        lbledtServer.Enabled := True;
        lbledtPort.Enabled := True;
        lbledtDataBase.Enabled := False;
        lbledtUserName.Enabled := True;
        lbledtPassWord.Enabled := True;
    end
    else if cbbDataType.Text = 'Access' then
    begin
        lbledtServer.Enabled := True;
        lbledtPort.Enabled := False;
        lbledtDataBase.Enabled := True;
        lbledtUserName.Enabled := False;
        lbledtPassWord.Enabled := True;
    end
    else if cbbDataType.Text = 'SQLite' then
    begin
        lbledtServer.Enabled := True;
        lbledtPort.Enabled := False;
        lbledtDataBase.Enabled := True;
        lbledtUserName.Enabled := False;
        lbledtPassWord.Enabled := True;
    end
    end;
end;

procedure TMainForm.btnSaveClick(Sender: TObject);
var
    task : TTask;
    I,Count:LongInt;
    SQL:TSql;
begin
    if cbbTaskNames.Text = '' then
    begin
       tltpA.Popup(cbbTaskNames.Handle,ttInformationIcon,'警告','请输入任务名称');
       Exit;
    end;
    if lbledtReadTime.Text = '' then
    begin
       tltpA.Popup(lbledtReadTime.Handle,ttInformationIcon,'警告','请输入执行周期');
       Exit;
    end;
    if not TryStrToInt(lbledtReadTime.Text,I) then
    begin
       tltpA.Popup(lbledtReadTime.Handle,ttInformationIcon,'警告','执行周期必须是数字');
       Exit;
    end;
    if SQLBox.ControlCount = 0 then
    begin
       tltpA.Popup(SQLBox.Handle,ttInformationIcon,'警告','至少要有一步！');
       Exit;
    end;

    if checkSqlTyep((SQLBox.Controls[0] as TSql).SQL.Text) then
    begin
       tltpA.Popup((SQLBox.Controls[0] as TSql).SQL.Handle,ttInformationIcon,'警告','第一步中不能有 :参数 格式的参数！');
       Exit;
    end;

     ////验证第一步中不能有：参数
    task := TTask.Create(Application);
    task.name := cbbTaskNames.Text;
    task.time := StrToInt(lbledtReadTime.Text);
    Count := SQLBox.ControlCount;
    for I := 0 to Count - 1 do
    begin
        SQL := Sqlbox.Controls[I] as TSql;
        if (SQL.SQL.Text <> '')  and (SQL.DataSource.Text <> '')then
        begin
              task.addSql(SQL); 
        end;
    end;
    Tools.saveTask(task);
    if cbbTaskNames.Items.IndexOf(cbbTaskNames.Text) = -1 then
       cbbTaskNames.Items.Add(cbbTaskNames.Text);
end;

procedure TMainForm.btnSaveDataClick(Sender: TObject);
var
    data : TDataSource;
begin

    if cbbDataName.Text = '' then
    begin
       tltpA.Popup(cbbDataName.Handle,ttInformationIcon,'警告','请输入数据源名');
       Exit;
    end;
    if cbbDataType.Text = '' then
    begin
       tltpA.Popup(cbbDataType.Handle,ttInformationIcon,'警告','请选择数据源类型');
       Exit;
    end;
    if lbledtServer.Enabled and (lbledtServer.Text = '') then
    begin
       tltpA.Popup(lbledtServer.Handle,ttInformationIcon,'警告','请选择服务器地址');
       Exit;
    end;
    if lbledtUserName.Enabled and (lbledtUserName.Text = '') then
    begin
       tltpA.Popup(lbledtUserName.Handle,ttInformationIcon,'警告','请输入用户名');
       Exit;
    end;
    if cbbDataName.Items.IndexOf(cbbDataName.Text) = -1 then
       cbbDataName.Items.Add(cbbDataName.Text);
    data := TDataSource.Create(Application);
    data.DataName := cbbDataName.Text;
    data.DataType := cbbDataType.Text;
    data.Server := lbledtServer.Text;
    data.Port := lbledtPort.Text;
    data.UserName := lbledtUserName.Text;
    data.DataBase := lbledtDataBase.Text;
    data.PassWord := lbledtPassWord.Text;
    Tools.saveData(data);
end;

procedure TMainForm.btnStopStartClick(Sender: TObject);
begin
  if btnStopStart.Caption = '启动服务' then
  begin
      Tools.RunDOS('net start shService');
      btnStopStart.Caption := '停止服务';
  end
  else
  begin
      Tools.RunDOS('net stop shService');
      btnStopStart.Caption := '启动服务';
  end;
  InitServiceState;
end;

procedure TMainForm.cbbDataTypeChange(Sender: TObject);
begin
    if cbbDataType.Text = 'MySql' then
    begin
        lbledtServer.Enabled := True;
        lbledtServer.Text := '';

        lbledtPort.Enabled := True;
        lbledtPort.Text := '';

        lbledtDataBase.Enabled := True;
        lbledtDataBase.Text := '';

        lbledtUserName.Enabled := True;
        lbledtUserName.Text := '';

        lbledtPassWord.Enabled := True;
        lbledtPassWord.Text := '';
    end
    else if cbbDataType.Text = 'Oracle' then
    begin
        lbledtServer.Enabled := True;
        lbledtServer.Text := '';

        lbledtPort.Enabled := True;
        lbledtPort.Text := '';

        lbledtDataBase.Enabled := False;
        lbledtDataBase.Text := '';

        lbledtUserName.Enabled := True;
        lbledtUserName.Text := '';

        lbledtPassWord.Enabled := True;
        lbledtPassWord.Text := '';
    end
    else if cbbDataType.Text = 'Access' then
    begin
        lbledtServer.Enabled := True;
        lbledtServer.Text := '';

        lbledtPort.Enabled := False;
        lbledtPort.Text := '';

        lbledtDataBase.Enabled := True;
        lbledtDataBase.Text := '';

        lbledtUserName.Enabled := False;
        lbledtUserName.Text := '';

        lbledtPassWord.Enabled := True;
        lbledtPassWord.Text := '';
    end
    else if cbbDataType.Text = 'SQLite' then
    begin
        lbledtServer.Enabled := True;
        lbledtServer.Text := '';

        lbledtPort.Enabled := False;
        lbledtPort.Text := '';

        lbledtDataBase.Enabled := True;
        lbledtDataBase.Text := '';

        lbledtUserName.Enabled := False;
        lbledtUserName.Text := '';

        lbledtPassWord.Enabled := True;
        lbledtPassWord.Text := '';
    end
end;

procedure TMainForm.btnAccessPjClick(Sender: TObject);
begin
  ShellExecute(Handle, nil, pchar('AccessPj.exe'), nil, pchar(ExtractFileDir(PARAMSTR(0))), SW_SHOW);
end;

procedure TMainForm.btnAddSqlClick(Sender: TObject);
var
   Sql : TSql;
begin
   Sql := TSql.Create(Application,cbbDataName.Items,SQLBox);
   Sql.btnDel.OnClick := btnDelClick;
   Sql.bLable.Caption := '第 ' + IntToStr(SQLBox.ControlCount) + ' 步';
end;

procedure TMainForm.btnClearLogClick(Sender: TObject);
var
  Dir:string;
  FileName:TStrings;
  I:Integer;
begin
  Dir := ExtractFileDir(PARAMSTR(0)) + '\logs\';
  FileName := Tools.getAllFilesFromDir(Dir,'*');
  LogMemo.Lines.Clear;
  for I := 0 to FileName.Count - 1 do
      DeleteFile(Dir + FileName[I]);
  LinesCount := -1;
end;
procedure TMainForm.FormCreate(Sender: TObject);
begin
  if not DirectoryExists(ExtractFileDir(PARAMSTR(0)) + '\logs') then  CreateDirectory(PChar(ExtractFilePath(ParamStr(0)) + '\logs'), nil);
  if not DirectoryExists(ExtractFileDir(PARAMSTR(0)) + '\task') then  CreateDirectory(PChar(ExtractFilePath(ParamStr(0)) + '\task'), nil);
  if not DirectoryExists(ExtractFileDir(PARAMSTR(0)) + '\data') then  CreateDirectory(PChar(ExtractFilePath(ParamStr(0)) + '\data'), nil);
  InitServiceState;
  LinesCount := -1;
  LoadLogs;
  cbbDataName.Items := Tools.getAllFilesFromDir(ExtractFileDir(PARAMSTR(0)) + '\data\','*');
  cbbTaskNames.Items := Tools.getAllFilesFromDir(ExtractFileDir(PARAMSTR(0)) + '\task\','*');
end;
procedure TMainForm.LoadLogs;
var
  FileName,Logs : TStrings;
  I:Integer;
  Dir:string;
begin
  Dir := ExtractFileDir(PARAMSTR(0)) + '\logs\';
  FileName := Tools.getAllFilesFromDir(Dir,'*');
  Logs := TStringList.Create;
  for I := 0 to FileName.Count - 1 do
  begin
      LogMemo.Lines.Add('==================' + FileName[I] + '==================');
      Logs.LoadFromFile(Dir + FileName[I]);
      LogMemo.Lines.AddStrings(Logs);
      if FileName[I] = FormatDateTime('yyyy-mm-dd', now) then
      begin
         LinesCount :=  Logs.Count;
      end;
  end;
  Logs.Free;
end;
procedure TMainForm.ReadLogs;
var
  Logs : TStrings;
  I:Integer;
begin
  Logs := TStringList.Create;

  if not FileExists(ExtractFileDir(PARAMSTR(0)) + '\logs\' + FormatDateTime('yyyy-mm-dd', now)) then
     Exit;
  
  Logs.LoadFromFile(ExtractFileDir(PARAMSTR(0)) + '\logs\' + FormatDateTime('yyyy-mm-dd', now));
  if LinesCount = -1 then
  begin
      LogMemo.Lines.AddStrings(Logs);
      LinesCount := Logs.Count;
  end
  else
  begin
      if LinesCount <  Logs.Count  then
      begin
          for I := LinesCount - 1 to Logs.Count - 1 do
          begin
              LogMemo.Lines.Add(Logs[I]);
          end;
          LinesCount := I;
      end
      else  if LinesCount >  Logs.Count then
      begin
         LogMemo.Lines.AddStrings(Logs);
         LinesCount := Logs.Count;
      end;

  end;
  
end;

procedure TMainForm.Panel1Click(Sender: TObject);
begin
     (Sender as TPanel).BorderStyle := bsSingle;
end;

procedure TMainForm.TimerTimer(Sender: TObject);
begin
ReadLogs;
LogMemo.Perform(EM_LINESCROLL, 0, LogMemo.Lines.Count);
end;

end.
