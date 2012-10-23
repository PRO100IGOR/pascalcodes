unit UpdateTool;

interface
uses
  SysUtils, Classes, IdHTTP, IdAntiFreeze, ShellAPI, Forms, IdComponent, VCLUnZip, VCLZip, Windows, XMLIntf, ActiveX, XMLDoc;

function getUpdateInfo(tomcatUrl, version, IniFile, mainName: string): Boolean;
function nDeleteDir(SrcDir: string; UndoMK: boolean = false): Boolean;

type
  TOnFinashOne = procedure(messShow, version: string; value: Integer) of object; //完成了一个 显示总进度信息、进度
  TOnDowning = procedure(value: Integer) of object; //下载中显示进度
  TOnFinashAll = procedure of object; //完成全部
  TBeforeAllDown = procedure(explain: string; MaxValue: Integer; IniFile: string; ExeFile: string; main, versionLast: string) of object; //全部下载开始前，计算总进度长度、初始化进度条信息、信息
  TBeforeDownOne = procedure(MaxValue: Integer) of object; //下载一个前，初始化进度条长度
  TAddExplans = procedure(explans: TStrings) of object; //更新说明
  TError = procedure of object; //错误发生时
  TDownTool = class(TThread)
  private
    Versions, Configs: TStrings;
    path, url, versionNow, IniFile, ExeFile, main: string;
    I, count: Integer;
    IsDowning, IsInstall: Boolean;
    idhtpLog: TIdHTTP;
    idntfrz1: TIdAntiFreeze;
    Stream: TMemoryStream;
    vclzp1: TVCLZip;
    VOnFinashOne: TOnFinashOne;
    VOnDowning: TOnDowning;
    VOnFinashAll: TOnFinashAll;
    VBeforeAllDown: TBeforeAllDown;
    VBeforeDownOne: TBeforeDownOne;
    VAddExplans: TAddExplans;
    VError: TError;
  public
    procedure Execute; override;
    constructor Create; overload;
    destructor Destroy; override;
    procedure Start;
    property OnFinashOne: TOnFinashOne read VOnFinashOne write VOnFinashOne; //完成了一个 显示总进度信息、进度
    property OnDowning: TOnDowning read VOnDowning write VOnDowning; //下载中显示进度
    property OnFinashAll: TOnFinashAll read VOnFinashAll write VOnFinashAll; //完成全部
    property BeforeAllDown: TBeforeAllDown read VBeforeAllDown write VBeforeAllDown; //全部下载开始前，计算总进度长度、初始化进度条信息、信息
    property BeforeDownOne: TBeforeDownOne read VBeforeDownOne write VBeforeDownOne; //下载一个前，初始化进度条长度
    property AddExplans: TAddExplans read VAddExplans write VAddExplans; //更新说明
    property OnError: TError read VError write VError;
    procedure idhtp1Work(ASender: TObject; AWorkMode: TWorkMode; AWorkCount: Integer);
    procedure idhtp1WorkBegin(ASender: TObject; AWorkMode: TWorkMode; AWorkCountMax: Integer);
  end;

implementation

function getUpdateInfo(tomcatUrl, version, IniFile, mainName: string): Boolean;
var
  idhtpLog: TIdHTTP;
  idntfrz1: TIdAntiFreeze;
  Stream: TMemoryStream;
  versions, newVersions, tempIni: TStrings;
  I: Integer;
  Path: string;
  hasdelete: Boolean;
begin
  idhtpLog := TIdHTTP.Create(nil);
  idntfrz1 := TIdAntiFreeze.Create(nil);
  Stream := TMemoryStream.Create;
  versions := TStringList.Create;
  newVersions := TStringList.Create;
  tempIni := TStringList.Create;
  Result := True;
  Path := ExtractFileDir(PARAMSTR(0));
  if Trim(version) = '' then version := '0.0.0.0';
  nDeleteDir(Path + '\update_temp');
  CreateDir(Path + '\update_temp');
  idntfrz1.OnlyWhenIdle := False;
  try
    idhtpLog.Get(tomcatUrl + '/CsUpdate/updateList.txt', Stream);
  except
    Result := False;
  end;
  if Result then
  begin
    Stream.SaveToFile(Path + '\update_temp\updateList.txt');
    versions.LoadFromFile(Path + '\update_temp\updateList.txt');
    DeleteFile(PChar(Path + '\update_temp\updateList.txt'));
    for I := 0 to versions.Count - 1 do
    begin
      if versions[I] > version then
        newVersions.Add(versions[I]);
    end;
    Result := newVersions.Count > 0;
    if Result then
    begin
      try
        newVersions.SaveToFile(Path + '\update_temp\list.txt');
        tempIni.Add(version);
        tempIni.Add(tomcatUrl);
        tempIni.Add(IniFile);
        tempIni.Add(mainName);
        tempIni.Add(ExtractFileName(Application.ExeName));
        tempIni.SaveToFile(Path + '\update_temp\tempIni.ini');
      except
        Result := False;
      end;
    end;
  end;
  idhtpLog.Free;
  idntfrz1.Free;
  Stream.Free;
  versions.Free;
  newVersions.Free;
  tempIni.Free;
  if Result then
  begin
    if FileExists(Path + '\Update.exe') then
      ShellExecute(Application.Handle, nil, 'Update.exe', nil, pchar(Path), SW_SHOW)
    else
    begin
      Application.MessageBox('发现更新，但更新程序无法启动，原因可能是：' +
        #13#10#13#10 + '1：程序发生未知错误' + #13#10 +
        '2：更新程序被移除或者易名' + #13#10 + '3：文件被破坏' + #13#10#13#10 +
        '请联系管理员解决', '提示', MB_OK + MB_ICONWARNING + MB_DEFBUTTON3 +
        MB_TOPMOST);
      nDeleteDir(Path + '\update_temp');
    end;
    Application.Terminate;
  end
  else
    nDeleteDir(Path + '\update_temp');
end;

procedure copyFileDo(old,new:string);
var
  dir:string;
begin
  dir := Copy(new,1,LastDelimiter('\',new)-1);
  if not DirectoryExists(dir) then
  begin
    ForceDirectories(PChar(dir));
  end;
  CopyFile(PChar(old), PChar(new), false);
end;

function nDeleteDir(SrcDir: string; UndoMK: boolean = false): Boolean;
var
  FS: TShFileOpStruct;
begin
  FS.Wnd := Application.Handle; //应用程序句柄
  FS.wFunc := FO_DELETE; //表示删除
  FS.pFrom := PChar(SrcDir + #0#0);
  FS.pTo := nil;
  if DirectoryExists(SrcDir) then
  begin
    try
      if UndoMK
        then FS.fFlags := FOF_NOCONFIRMATION + FOF_SILENT + FOF_ALLOWUNDO
   // 表示删除到回收站
      else FS.fFlags := FOF_NOCONFIRMATION + FOF_SILENT;
   // 表示不删除到回收站
      FS.lpszProgressTitle := nil;
      Result := (ShFileOperation(FS) = 0);
    except
      Result := False;
    end;
  end
  else
    Result := False;
end;

constructor TDownTool.Create;
begin
  Versions := TStringList.Create;
  Configs := TStringList.Create;
  I := 0;
  count := 0;
  IsDowning := False;
  IsInstall := False;
  idhtpLog := TIdHTTP.Create(nil);
  idhtpLog.OnWork := idhtp1Work;
  idhtpLog.OnWorkBegin := idhtp1WorkBegin;
  idntfrz1 := TIdAntiFreeze.Create(nil);
  Stream := TMemoryStream.Create;
  vclzp1 := TVCLZip.Create(nil);
  inherited Create(True);
end;

destructor TDownTool.Destroy;
begin
  Versions.Free;
  Configs.Free;
  idhtpLog.Free;
  idntfrz1.Free;
  Stream.Free;
  vclzp1.Free;
  inherited Destroy;
end;

procedure TDownTool.Start;
var
  versionLast: string;
begin
  Path := ExtractFileDir(PARAMSTR(0));
  try
    Versions.LoadFromFile(Path + '\update_temp\list.txt');
    Configs.LoadFromFile(Path + '\update_temp\tempIni.ini');
    url := Configs[1];
    versionNow := Configs[0];
    IniFile := Configs[2];
    main := Configs[3];
    ExeFile := Configs[4];
    count := Versions.Count;
    versionLast := Versions[Versions.Count - 1];
    BeforeAllDown('共需下载' + IntToStr(count) + '个更新包', count * 100, IniFile, ExeFile, main, versionLast);
    I := 1;
    Resume;
  except
    Synchronize(OnError);
  end;
end;

procedure TDownTool.Execute;
var
  Bean, BeanChilds: IXMLNode;
  XMLDocument: IXMLDocument;
  explains: TStrings;
  Index: Integer;
  FileName: string;
begin
  FreeOnTerminate := true;
  while not Terminated do
  begin
    if I <= count then
    begin
      try
        versionNow := Versions[I - 1];
        OnFinashOne('正在获取【' + versionNow + '】号文件列表', versionNow, (I-1) * 100);
        Stream.Clear;
        idhtpLog.Get(url + '/CsUpdate/' + versionNow + '.xml', Stream);

        CoInitialize(nil);
        XMLDocument := TXMLDocument.Create(nil);
        XMLDocument.LoadFromStream(Stream);
        explains := TStringList.Create;
        Bean := XMLDocument.DocumentElement;
        explains.Add('*******************************************');
        explains.Add('版本号：' + Bean.ChildNodes['version'].text);
        explains.Add('更新时间：' + Bean.ChildNodes['time'].text);
        explains.Add('更新内容：');
        BeanChilds := Bean.ChildNodes['explains'];
        for Index := 0 to BeanChilds.ChildNodes.Count - 1 do
          explains.Add(BeanChilds.ChildNodes[Index].Text);
        AddExplans(explains);

        OnFinashOne('正在下载【' + versionNow + '】号更新包', versionNow, (I-1) * 100);
        Stream.Clear;
        idhtpLog.Get(url + '/CsUpdate/' + versionNow + '.pak', Stream);
        Stream.SaveToFile(path + '\update_temp\' + versionNow + '.pak');
        OnFinashOne('正在安装【' + versionNow + '】号更新包', versionNow, (I-1) * 100);
        vclzp1.ZipName := path + '\update_temp\' + versionNow + '.pak';
        vclzp1.DestDir := path + '\update_temp\';
        vclzp1.DoAll := True;
        vclzp1.RecreateDirs := True;
        vclzp1.RetainAttributes := True;
        vclzp1.OverwriteMode := Always;
        vclzp1.UnZip;


        BeanChilds := Bean.ChildNodes['files'];
        for Index := 0 to BeanChilds.ChildNodes.Count - 1 do
        begin
          FileName := BeanChilds.ChildNodes[Index].Text;
          if BeanChilds.ChildNodes[Index].GetAttributeNS('action', '') = 'd' then
            DeleteFile(PChar(path + '\' + FileName))
          else if BeanChilds.ChildNodes[Index].GetAttributeNS('action', '') = 'u' then
            copyFileDo(path + '\update_temp\' + FileName,path + '\' + FileName)
          else if BeanChilds.ChildNodes[Index].GetAttributeNS('action', '') = 'ed' then
          begin
            copyFileDo(path + '\update_temp\' + FileName,path + '\' + FileName);
            ShellExecute(Application.Handle, nil, pchar(path + '\' + FileName), nil, '', SW_SHOW);
            DeleteFile(pchar(path + '\' + FileName));
          end
          else if BeanChilds.ChildNodes[Index].GetAttributeNS('action', '') = 'es' then
          begin
            copyFileDo(path + '\update_temp\' + FileName,path + '\' + FileName);
            ShellExecute(Application.Handle, nil, pchar(path + '\' + FileName), nil, '', SW_SHOW);
          end;
        end;
        XMLDocument := nil;
        CoUninitialize;
        OnFinashOne('【' + versionNow + '】号更新包安装完成', versionNow, I * 100);
        Inc(I);
      except
        OnFinashOne('【' + versionNow + '】号更新包下载失败，跳过', versionNow, I * 100);
        Inc(I);
      end;
    end
    else
    begin
      Synchronize(OnFinashAll);
      Suspend;
    end;
  end;
end;


procedure TDownTool.idhtp1Work(ASender: TObject; AWorkMode: TWorkMode; AWorkCount: Integer);
begin
  OnDowning(AWorkCount);
end;

procedure TDownTool.idhtp1WorkBegin(ASender: TObject; AWorkMode: TWorkMode; AWorkCountMax: Integer);
begin
  BeforeDownOne(AWorkCountMax);
end;

end.

