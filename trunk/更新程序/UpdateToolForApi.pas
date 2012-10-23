unit UpdateToolForApi;

interface
uses
  SysUtils, Classes, IdHTTP, IdAntiFreeze, Forms, IdComponent, Shellapi, Windows, XMLIntf, ActiveX, XMLDoc;

function getUpdateInfo(tomcatUrl, version, IniFile, mainName: string): Boolean;
function nDeleteDir(SrcDir: string; UndoMK: boolean = false): Boolean;

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

end.

