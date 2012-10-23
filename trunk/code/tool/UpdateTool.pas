unit UpdateTool;

interface
uses
  SysUtils, Classes, IdHTTP, IdAntiFreeze, ShellAPI, Forms, IdComponent, VCLUnZip, VCLZip, Windows, XMLIntf, ActiveX, XMLDoc;


function nDeleteDir(SrcDir: string; UndoMK: boolean = false): Boolean;

type
  TBeforeDown = procedure of object; //����ǰ
  TOnDowning = procedure(value: Integer) of object; //��������ʾ����
  TBeforeUnZip = procedure(value: Integer) of object; //��ѹǰ
  TOnUnZip =  procedure(value: Integer) of object; //��ѹ����ʾ����
  TAddExplans = procedure(explans: string) of object; //����˵�� ����־
  TOnfinsh = procedure of object; //���
  TDownTool = class(TThread)
  private
    IsDowning, IsInstall: Boolean;
    idhtpLog: TIdHTTP;
    idntfrz1: TIdAntiFreeze;
    Stream: TMemoryStream;
    vclzp1: TVCLZip;
    VBeforeDown :TBeforeDown;
    VOnDowning: TOnDowning;
    VOnUnZip :TOnUnZip;
    VBeforeUnZip :TBeforeUnZip;
    VAddExplans: TAddExplans;
    VOnfinsh:TOnfinsh;

    procedure copyFileDo(old,new:string);
  public
    path, url,fireName: string;
    isUpdate : Boolean;
    procedure Execute; override;
    constructor Create; overload;
    destructor Destroy; override;
    procedure Start;
    property OnDowning: TOnDowning read VOnDowning write VOnDowning; //��������ʾ����
    property BeforeDown :TBeforeDown read VBeforeDown write VBeforeDown;
    property BeforeUnZip :TBeforeUnZip read VBeforeUnZip write VBeforeUnZip;
    property OnUnZip :TOnUnZip read VOnUnZip write VOnUnZip;
    property AddExplans: TAddExplans read VAddExplans write VAddExplans; //����˵��
    property Onfinsh: TOnfinsh read VOnfinsh write VOnfinsh; //���ؽ���
    procedure idhtp1Work(ASender: TObject; AWorkMode: TWorkMode; AWorkCount: Integer);
  end;
implementation


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
  IsDowning := False;
  IsInstall := False;
  idhtpLog := TIdHTTP.Create(nil);
  idhtpLog.OnWork := idhtp1Work;
  idntfrz1 := TIdAntiFreeze.Create(nil);
  Stream := TMemoryStream.Create;
  vclzp1 := TVCLZip.Create(nil);
  isUpdate := False;
  inherited Create(True);
end;

destructor TDownTool.Destroy;
begin
  idhtpLog.Free;
  idntfrz1.Free;
  Stream.Free;
  vclzp1.Free;
  inherited Destroy;
end;
procedure TDownTool.copyFileDo(old,new:string);
var
  dir:string;
begin
  dir := Copy(new,1,LastDelimiter('\',new)-1);
  if not DirectoryExists(dir) then
  begin
    AddExplans('����Ŀ¼'+dir);
    ForceDirectories(PChar(dir));
  end;
  CopyFile(PChar(old), PChar(new), false);
end;
procedure TDownTool.Start;
var
  versionLast: string;
begin
  try
    Resume;
  except
  end;
end;

procedure TDownTool.Execute;
var
  Bean, BeanChilds: IXMLNode;
  XMLDocument: IXMLDocument;
  explains: TStrings;
  Index: Integer;
  FileName,pathold: string;
  s:Boolean;
begin
  FreeOnTerminate := true;
  try
    Stream.Clear;
    pathold := ExtractFilePath(ParamStr(0));
    CreateDirectory(PChar(pathold + '\update_temp'), nil);
    AddExplans('�����ļ��б�...');
    BeforeDown;
    idhtpLog.Get(url + '/'+fireName+'.xml', Stream);
    CoInitialize(nil);
    XMLDocument := TXMLDocument.Create(nil);
    XMLDocument.LoadFromStream(Stream);
    explains := TStringList.Create;
    Bean := XMLDocument.DocumentElement;

    AddExplans('����ʱ�䣺' + Bean.ChildNodes['time'].text);
    AddExplans('�������ݣ�');
    BeanChilds := Bean.ChildNodes['explains'];
    for Index := 0 to BeanChilds.ChildNodes.Count - 1 do
        AddExplans(BeanChilds.ChildNodes[Index].Text);
    Stream.Clear;
    AddExplans('�����ļ�...');
    idhtpLog.Get(url + '/'+fireName+'.pak', Stream);
    Stream.SaveToFile(pathold + '\update_temp\'+fireName+'.pak');
    AddExplans('��ѹ�ļ�...');
    vclzp1.ZipName := pathold + '\update_temp\'+fireName+'.pak';
    vclzp1.DestDir := pathold  + '\update_temp\';
    vclzp1.DoAll := True;
    vclzp1.RecreateDirs := True;
    vclzp1.RetainAttributes := True;
    vclzp1.OverwriteMode := Always;
    vclzp1.UnZip;

    BeanChilds := Bean.ChildNodes['files'];
    BeforeUnZip(BeanChilds.ChildNodes.Count);


    if isUpdate then
    begin
       nDeleteDir(ExtractFilePath(ParamStr(0)) + '\update_temp\.settings');
       nDeleteDir(ExtractFilePath(ParamStr(0)) + '\update_temp\src');
       DeleteFile(PChar(ExtractFilePath(ParamStr(0)) + '\update_temp\velocity.log'));
       DeleteFile(PChar(ExtractFilePath(ParamStr(0)) + '\update_temp\.project'));
       DeleteFile(PChar(ExtractFilePath(ParamStr(0)) + '\update_temp\WebRoot\WEB-INF\web.xml'));
       DeleteFile(PChar(ExtractFilePath(ParamStr(0)) + '\update_temp\WebRoot\WEB-INF\dwr.xml'));
       DeleteFile(PChar(ExtractFilePath(ParamStr(0)) + '\update_temp\.myumldata'));
       DeleteFile(PChar(ExtractFilePath(ParamStr(0)) + '\update_temp\.mymetadata'));
    end;

    for Index := 0 to BeanChilds.ChildNodes.Count - 1 do
    begin
      FileName := BeanChilds.ChildNodes[Index].Text;
      if not FileExists(pathold + '\update_temp\' + FileName) then
        Continue;
      OnUnZip(Index+1);
      if BeanChilds.ChildNodes[Index].GetAttributeNS('action', '') = 'd' then
      begin
         DeleteFile(PChar(path + '\' + FileName));
         AddExplans('ɾ��'+FileName);
      end
      else if BeanChilds.ChildNodes[Index].GetAttributeNS('action', '') = 'u' then
      begin
         copyFileDo(pathold + '\update_temp\' + FileName,path + '\' + FileName);
         AddExplans(FileName+'���³ɹ�')
      end
      else if BeanChilds.ChildNodes[Index].GetAttributeNS('action', '') = 'ed' then
      begin
        copyFileDo(pathold + '\update_temp\' + FileName,path + '\' + FileName);
        ShellExecute(Application.Handle, nil, pchar(path + '\' + FileName), nil, '', SW_SHOW);
        DeleteFile(pchar(path + '\' + FileName));
        AddExplans('ִ�в�ɾ��'+FileName);
      end
      else if BeanChilds.ChildNodes[Index].GetAttributeNS('action', '') = 'es' then
      begin
        copyFileDo(pathold + '\update_temp\' + FileName,path + '\' + FileName);
        ShellExecute(Application.Handle, nil, pchar(path + '\' + FileName), nil, '', SW_SHOW);
        AddExplans('ִ�в�����'+FileName);
      end;
    end;
    XMLDocument := nil;
    CoUninitialize;
  except
    AddExplans('��������...');
  end;
  nDeleteDir(ExtractFilePath(ParamStr(0)) + '\update_temp');
  Synchronize(Onfinsh);
  Self.Terminate;
end;


procedure TDownTool.idhtp1Work(ASender: TObject; AWorkMode: TWorkMode; AWorkCount: Integer);
begin
  OnDowning(AWorkCount);
end;


end.

