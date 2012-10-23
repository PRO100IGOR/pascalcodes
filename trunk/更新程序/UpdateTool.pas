unit UpdateTool;

interface
uses
  SysUtils, Classes, IdHTTP, IdAntiFreeze, ShellAPI, Forms, IdComponent, VCLUnZip, VCLZip, Windows, XMLIntf, ActiveX, XMLDoc;

function getUpdateInfo(tomcatUrl, version, IniFile, mainName: string): Boolean;
function nDeleteDir(SrcDir: string; UndoMK: boolean = false): Boolean;

type
  TOnFinashOne = procedure(messShow, version: string; value: Integer) of object; //�����һ�� ��ʾ�ܽ�����Ϣ������
  TOnDowning = procedure(value: Integer) of object; //��������ʾ����
  TOnFinashAll = procedure of object; //���ȫ��
  TBeforeAllDown = procedure(explain: string; MaxValue: Integer; IniFile: string; ExeFile: string; main, versionLast: string) of object; //ȫ�����ؿ�ʼǰ�������ܽ��ȳ��ȡ���ʼ����������Ϣ����Ϣ
  TBeforeDownOne = procedure(MaxValue: Integer) of object; //����һ��ǰ����ʼ������������
  TAddExplans = procedure(explans: TStrings) of object; //����˵��
  TError = procedure of object; //������ʱ
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
    property OnFinashOne: TOnFinashOne read VOnFinashOne write VOnFinashOne; //�����һ�� ��ʾ�ܽ�����Ϣ������
    property OnDowning: TOnDowning read VOnDowning write VOnDowning; //��������ʾ����
    property OnFinashAll: TOnFinashAll read VOnFinashAll write VOnFinashAll; //���ȫ��
    property BeforeAllDown: TBeforeAllDown read VBeforeAllDown write VBeforeAllDown; //ȫ�����ؿ�ʼǰ�������ܽ��ȳ��ȡ���ʼ����������Ϣ����Ϣ
    property BeforeDownOne: TBeforeDownOne read VBeforeDownOne write VBeforeDownOne; //����һ��ǰ����ʼ������������
    property AddExplans: TAddExplans read VAddExplans write VAddExplans; //����˵��
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
      Application.MessageBox('���ָ��£������³����޷�������ԭ������ǣ�' +
        #13#10#13#10 + '1��������δ֪����' + #13#10 +
        '2�����³����Ƴ���������' + #13#10 + '3���ļ����ƻ�' + #13#10#13#10 +
        '����ϵ����Ա���', '��ʾ', MB_OK + MB_ICONWARNING + MB_DEFBUTTON3 +
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
  FS.Wnd := Application.Handle; //Ӧ�ó�����
  FS.wFunc := FO_DELETE; //��ʾɾ��
  FS.pFrom := PChar(SrcDir + #0#0);
  FS.pTo := nil;
  if DirectoryExists(SrcDir) then
  begin
    try
      if UndoMK
        then FS.fFlags := FOF_NOCONFIRMATION + FOF_SILENT + FOF_ALLOWUNDO
   // ��ʾɾ��������վ
      else FS.fFlags := FOF_NOCONFIRMATION + FOF_SILENT;
   // ��ʾ��ɾ��������վ
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
    BeforeAllDown('��������' + IntToStr(count) + '�����°�', count * 100, IniFile, ExeFile, main, versionLast);
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
        OnFinashOne('���ڻ�ȡ��' + versionNow + '�����ļ��б�', versionNow, (I-1) * 100);
        Stream.Clear;
        idhtpLog.Get(url + '/CsUpdate/' + versionNow + '.xml', Stream);

        CoInitialize(nil);
        XMLDocument := TXMLDocument.Create(nil);
        XMLDocument.LoadFromStream(Stream);
        explains := TStringList.Create;
        Bean := XMLDocument.DocumentElement;
        explains.Add('*******************************************');
        explains.Add('�汾�ţ�' + Bean.ChildNodes['version'].text);
        explains.Add('����ʱ�䣺' + Bean.ChildNodes['time'].text);
        explains.Add('�������ݣ�');
        BeanChilds := Bean.ChildNodes['explains'];
        for Index := 0 to BeanChilds.ChildNodes.Count - 1 do
          explains.Add(BeanChilds.ChildNodes[Index].Text);
        AddExplans(explains);

        OnFinashOne('�������ء�' + versionNow + '���Ÿ��°�', versionNow, (I-1) * 100);
        Stream.Clear;
        idhtpLog.Get(url + '/CsUpdate/' + versionNow + '.pak', Stream);
        Stream.SaveToFile(path + '\update_temp\' + versionNow + '.pak');
        OnFinashOne('���ڰ�װ��' + versionNow + '���Ÿ��°�', versionNow, (I-1) * 100);
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
        OnFinashOne('��' + versionNow + '���Ÿ��°���װ���', versionNow, I * 100);
        Inc(I);
      except
        OnFinashOne('��' + versionNow + '���Ÿ��°�����ʧ�ܣ�����', versionNow, I * 100);
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

