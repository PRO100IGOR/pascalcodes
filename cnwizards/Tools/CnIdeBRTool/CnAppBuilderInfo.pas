{******************************************************************************}
{                       CnPack For Delphi/C++Builder                           }
{                     �й����Լ��Ŀ���Դ�������������                         }
{                   (C)Copyright 2001-2011 CnPack ������                       }
{                   ------------------------------------                       }
{                                                                              }
{            ���������ǿ�Դ��������������������� CnPack �ķ���Э������        }
{        �ĺ����·�����һ����                                                }
{                                                                              }
{            ������һ��������Ŀ����ϣ�������ã���û���κε���������û��        }
{        �ʺ��ض�Ŀ�Ķ������ĵ���������ϸ���������� CnPack ����Э�顣        }
{                                                                              }
{            ��Ӧ���Ѿ��Ϳ�����һ���յ�һ�� CnPack ����Э��ĸ��������        }
{        ��û�У��ɷ������ǵ���վ��                                            }
{                                                                              }
{            ��վ��ַ��http://www.cnpack.org                                   }
{            �����ʼ���master@cnpack.org                                       }
{                                                                              }
{******************************************************************************}

unit CnAppBuilderInfo;
{* |<PRE>
================================================================================
* ������ƣ�CnPack IDE ר�Ҹ�������/�ָ�����
* ��Ԫ���ƣ�CnWizards ��������/�ָ����߱��ݹ��ߵ�Ԫ
* ��Ԫ���ߣ�ccRun(����)
* ��    ע��CnWizards ר�Ҹ�������/�ָ����߱��ݹ��ߵ�Ԫ
* ����ƽ̨��PWinXP + Delphi 5.01
* ���ݲ��ԣ�PWin9X/2000/XP + Delphi 5/6/7 + C++Builder 5/6
* �� �� �����õ�Ԫ�е��ַ��������ϱ��ػ�����ʽ
* ��Ԫ��ʶ��$Id: CnAppBuilderInfo.pas 991 2011-09-22 02:14:56Z liuxiaoshanzhashu@gmail.com $
* �޸ļ�¼��2008.05.11 V1.1
*               ���ӱ��ݻָ��������� dsk �ļ��Ĺ���
*           2006.08.23 V1.0
*               LiuXiao ��ֲ�˵�Ԫ
================================================================================
|</PRE>}

interface

uses
  Windows, Classes, Registry, IniFiles, ShellApi, SysUtils, FileCtrl,
  CnCompressor, CnBHConst, CnCommon, tlhelp32, OmniXML;

type
  // AppBuilder ����/�ָ�ѡ��
  TAbiOption = (
      aoCodeTemp, //����ģ��
      aoObjRep,   // �����
      aoRegInfo,  // IDE ������Ϣ
      aoMenuTemp  // �˵�ģ��
      );
  TAbiOptions = set of TAbiOption; // ao := [aoCodeTemp, aoObjRep];

  // AppBuilder ����
  TAbiType = (atBCB5, atBCB6, atDelphi5, atDelphi6, atDelphi7, atDelphi8,
    atBDS2005, atBDS2006, atDelphi2007, atDelphi2009, atDelphi2010, atDelphiXE,
    atDelphiXE2);
  TAbiTypes = set of TAbiType; // at := [BCB5, BCB6];

  TAppBuilderInfo = class(TObject)
  private
    m_hOwner: THandle;    // �����ߵľ��
    m_AbiType: TAbiType;    // AppBuilder ����

    m_strTempPath: string;  // ��ʱ�ļ����Ŀ¼
    m_strRootDir: string;   // AppBuilder ��װĿ¼
    m_strAppName: string;   // AppBuilder ����
    m_strAppAbName: string;   // AppBuilder ���Ƽ�д
    m_strRegPath: string;   // AppBuilder ע���·��
    m_bSaveUsrObjRep2Sys: Boolean; // �������ȫ�����浽ϵͳȱʡĿ¼
    // �����־
    procedure OutputLog(strMsg: string; nFlag: Integer=0);
    // ��ȡ����/�ָ����ݵ��ļ���(dci,dro,dmt)
    function GetAbiOptionFile(ao: TAbiOption): string;
    // ��ע����е�ĳ������Ϊ�ļ�
    function SaveKey2File: string;
    // ���������е�Form
    procedure SaveObjRep(strDroFile: string);
    // �ָ�������е�Form
    function LoadRepObj(strDroFile: string): Boolean;

    procedure OnFindBackupDskFile(const FileName: string; const Info: TSearchRec;
      var Abort: Boolean);
    procedure OnFindRestoreDskFile(const FileName: string; const Info: TSearchRec;
      var Abort: Boolean);
  public
    m_AbiOption: TAbiOptions; // ����/�ָ�ѡ��
    constructor Create(hOwner: THandle; AbiType: TAbiType);
    destructor Destroy; override;

    // ����������Ϣ���ļ�
    procedure BackupInfoToFile(strBakFileName: string; bFlag: Boolean);
    // ���ļ���װ��������Ϣ
    function RestoreInfoFromFile(strBakFileName: string): Boolean;
  end;

//------------------------------------------------------------------------------
// ���ú���
//------------------------------------------------------------------------------

// ��ȡ AppBuilder ��װĿ¼
function GetAppRootDir(at: TAbiType): string;
// ���������ļ�
function ParseBakFile(strBakFileName: string;
  var strRootDir, strAppName: string; var at: TAbiType): TAbiOptions;
// ����������ַ���
function OpResult(bResult: Boolean): string;
// ��ʱĿ¼
function MyGetTempPath(strFileName: string): string;
// AppBuilder �Ƿ���������
function IsAppBuilderRunning(at: TAbiType): boolean;
// �鿴ָ���ļ��Ƿ��ڽ����б���
function FileInProcessList(strFileName: string): Boolean;
// ���IDE�򿪹��Ĺ���/�ļ���ʷ��¼
function ClearOpenedHistory(at: TAbiType): Boolean;

// ��� IDE ��ע���·��
function GetRegIDEBaseFromAt(at: TAbiType): string;

implementation

{ TAppBuilderInfo }

constructor TAppBuilderInfo.Create(hOwner: THandle; AbiType: TAbiType);
var
  strTempPath: string;
begin
  m_hOwner := hOwner; // �����ߵľ��
  m_AbiType := AbiType; // AppBuilder ����

  // ��ʼ������
  if Integer(AbiType) <= Integer(High(TAbiType)) then
  begin
    m_strAppName := g_strAppName[Integer(AbiType)];
    m_strAppAbName := g_strAppAbName[Integer(AbiType)];
    m_strRegPath := g_strRegPath[Integer(AbiType)];
  end;

  m_strRootDir := GetAppRootDir(AbiType); // AppBuilder �ĸ�Ŀ¼

  // ��ʱ�ļ����Ŀ¼
  strTempPath := MyGetTempPath(ParamStr(0));
  m_strTempPath := strTempPath + m_strAppAbName + '\';
  // ȷ����ʱ�ļ�Ŀ¼�Ĵ���
  if not DirectoryExists(m_strTempPath) then
    ForceDirectories(m_strTempPath);
  SetFileAttributes(PChar(m_strTempPath),
      GetFileAttributes(PChar(m_strTempPath) + FILE_ATTRIBUTE_HIDDEN));
end;

destructor TAppBuilderInfo.Destroy;
var
  sfo: SHFILEOPSTRUCT;
begin
  // �˳�ʱɾ����ʱĿ¼
  if DirectoryExists(m_strTempPath) then
  begin
    ZeroMemory(@sfo, sizeof(sfo));
    sfo.wFunc := FO_DELETE;
    sfo.pFrom := PChar(Copy(m_strTempPath, 1, Length(m_strTempPath) - 1) + #0 + #0);
    sfo.fFlags := FOF_NOCONFIRMATION or FOF_SILENT; // ��������ʾ
    SHFileOperation(sfo);
  end;
end;

// ����Ϣ���浽�����ļ�
procedure TAppBuilderInfo.BackupInfoToFile(strBakFileName: string; bFlag: Boolean);
var
  cmr: TCompressor;
  ms: TFileStream;
  strFileName, strRegFile: string;
  bResult: Boolean;
  Header: THeaderStruct;
  btCheckSum: Byte;
  i: Integer;
  pHeader: PByte;
  szBuf: array[0..MAX_PATH] of char;
begin
  m_bSaveUsrObjRep2Sys := bFlag;
  // ����ģ���ļ���dci
  if aoCodeTemp in m_AbiOption then
  begin
    if m_AbiType in [atBDS2005, atBDS2006, atDelphi2007, atDelphi2009, atDelphi2010] then
      strFileName := m_strRootDir + 'Objrepos\' + GetAbiOptionFile(aoCodeTemp)
    else if m_AbiType in [atDelphiXE, atDelphiXE2] then
      strFileName := m_strRootDir + 'Objrepos\en\' + GetAbiOptionFile(aoCodeTemp)
    else
      strFileName := m_strRootDir + 'bin\' + GetAbiOptionFile(aoCodeTemp);

    if FileExists(strFileName) then
    begin
      bResult := CopyFile(PChar(strFileName),
          PChar(m_strTempPath + GetAbiOptionFile(aoCodeTemp)), False);
      OutputLog(m_strAppName + ' ' + g_strAbiOptions[Ord(aoCodeTemp)] + g_strBackup + OpResult(bResult));
    end
    else
      OutputLog(g_strNotFound + m_strAppName + ' ' + g_strAbiOptions[Ord(aoCodeTemp)]);
  end;
  // ������ļ���dro
  if aoObjRep in m_AbiOption then
  begin
    if m_AbiType in [atBDS2005, atBDS2006, atDelphi2007, atDelphi2009, atDelphi2010] then
      strFileName := m_strRootDir + 'Objrepos\' + GetAbiOptionFile(aoObjRep)
    else if m_AbiType in [atDelphiXE, atDelphiXE2] then
      strFileName := m_strRootDir + 'Objrepos\en\' + GetAbiOptionFile(aoObjRep)
    else
      strFileName := m_strRootDir + 'bin\' + GetAbiOptionFile(aoObjRep);

    if FileExists(strFileName) then
    begin
      bResult := CopyFile(PChar(strFileName),
          PChar(m_strTempPath + GetAbiOptionFile(aoObjRep)), False);
      OutputLog(m_strAppName + ' ' + g_strObjRepConfig
          + g_strBackup + OpResult(bResult));

      SaveObjRep(m_strTempPath + GetAbiOptionFile(aoObjRep));
    end
    else
      OutputLog(g_strNotFound + m_strAppName + ' ' + g_strObjRepConfig);
  end;
  // �˵�ģ���ļ���dmt
  if aoMenuTemp in m_AbiOption then
  begin
    if m_AbiType in [atDelphiXE, atDelphiXE2] then
      strFileName := m_strRootDir + 'Objrepos\en\' + GetAbiOptionFile(aoMenuTemp)
    else
      strFileName := m_strRootDir + 'bin\' + GetAbiOptionFile(aoMenuTemp);
    if FileExists(strFileName) then
    begin
      bResult := CopyFile(PChar(strFileName),
          PChar(m_strTempPath + GetAbiOptionFile(aoMenuTemp)), False);
      OutputLog(m_strAppName + ' ' + g_strAbiOptions[Ord(aoMenuTemp)] + g_strBackup + OpResult(bResult));
    end
    else
      OutputLog(g_strNotFound + m_strAppName + ' ' + g_strAbiOptions[Ord(aoMenuTemp)]);
  end;
  // IDE ������Ϣ
  if aoRegInfo in m_AbiOption then
  begin
    strRegFile := SaveKey2File;
    OutputLog(m_strAppName + ' ' + g_strAbiOptions[Ord(aoRegInfo)]
        + g_strBackup + OpResult(strRegFile <> ''));
    // *.dsk/dst ������Ϣ�����ļ�
    FindFile(m_strRootDir + 'bin\', '*.dsk', OnFindBackupDskFile, nil, False);
    FindFile(m_strRootDir + 'bin\', '*.dst', OnFindBackupDskFile, nil, False);
  end;
  OutputLog('----------------------------------------');
  OutputLog(g_strCreating + g_strBakFile + g_strPleaseWait);

  // ѹ����Щ�ļ�
  try
    ms := TFileStream.Create(strBakFileName, fmCreate);
  except
    OutputLog(SCnErrorCaption + '! ' + g_strPleaseCheckFile);
    Exit;
  end;
  cmr := TCompressor.Create(ms);
  cmr.AddFolder(m_strTempPath);
  FreeAndNil(cmr);
  // �����ļ�ͷ����Ϣ
  ms.Position := 0;
  ms.ReadBuffer(Header, sizeof(Header));
  // AppBuilder ����
  Header.btAbiType := Byte(m_AbiType) + 1;
  // �����ļ���ѡ��
  Header.btAbiOption := Byte(m_AbiOption);
  // AppBuilder ��װĿ¼
  StrCopy(szBuf, PChar(m_strRootDir));
  for i := 0 to Length(m_strRootDir) - 1 do
  begin
    szBuf[i] := Char(Byte(szBuf[i]) xor XorKey);
  end;
  szBuf[Length(m_strRootDir)] := Char(XorKey);
  StrCopy(Header.szAppRootPath, szBuf);
  // �ļ�ͷУ���(��ȥУ���ֽڱ���)
  pHeader := PByte(@Header);
  btCheckSum := 0;
  for i := 0 to SizeOf(Header) - 2 do
  begin
    btCheckSum := btCheckSum xor pHeader^;
    Inc(pHeader);
  end;
  Header.btCheckSum := btCheckSum;
  // д���ļ�ͷ
  ms.Position := 0;
  ms.Write(Header, sizeof(Header));
  FreeAndNil(ms);
  //
  bResult := FileExists(strBakFileName);
  OutputLog(g_strBakFile + g_strCreate
      + OpResult(bResult) + #13#10 + strBakFileName, 1);
  OutputLog('----------------------------------------');
  if bResult then
    OutputLog(g_strThanksForBackup)
  else
    OutputLog(g_strPleaseCheckFile);
  OutputLog(g_strBugReportToMe);
end;

//
function TAppBuilderInfo.SaveKey2File: string;
  // ��������ע����ļ�ת����ANSI�ַ���
  function GetRegFileText(const strFileName: string): string;
  var
    hFile: DWORD;
    dwSize: DWORD;
    strSec: string;
  begin
    // ���ļ�
    hFile := CreateFile(PChar(strFileName), GENERIC_READ, FILE_SHARE_READ,
        nil, OPEN_EXISTING, FILE_ATTRIBUTE_NORMAL, 0);
    // �ļ���С
    dwSize := Windows.GetFileSize(hFile, nil);
    // �����ڴ�
    SetLength(strSec, dwSize + 2);
    // �����ļ�
    ReadFile(hFile, strSec[1], dwSize, dwSize, nil);
    // �ر��ļ�
    CloseHandle(hFile);
    // �ý�����
    strSec[dwSize + 1] := #0;
    strSec[dwSize + 2] := #0;
    // �����ʽ
    if(strSec[1] = #$FF) and (strSec[2] = #$FE) then // UNICODE
    begin
      // �����ڴ�
      SetLength(Result, dwSize);
      // ת������
      WideCharToMultiByte(CP_ACP, 0, PWideChar(@strSec[3]),
          -1, @Result[1], dwSize, nil, nil);
    end
    else
      Result := strSec;
    // ȥ�������ַ�
    Result := string(PChar(Result));
  end;
var
  bResult: Boolean;
  pList: TStringList;
  strOrgPath, regExec: string;
  ini: TIniFile;
begin
  regExec := 'regedit.exe /e "' + m_strTempPath + m_strAppAbName + '.reg" '
    + 'HKEY_CURRENT_USER' + GetRegIDEBaseFromAt(m_AbiType) + m_strRegPath;
  WinExecAndWait32(regExec, SW_HIDE, True);
  bResult := FileExists(m_strTempPath + m_strAppAbName + '.reg');

  if bResult then
  begin
    // ��REG�ļ��еľ���·��ת�������·��
    pList := TStringList.Create;
    // �����NT�µ�����ע�����Ҫ��Unicodeת����Ansi
    if Win32Platform = VER_PLATFORM_WIN32_NT then
      pList.Text := GetRegFileText(m_strTempPath + m_strAppAbName + '.reg')
    else
      pList.LoadFromFile(m_strTempPath + m_strAppAbName + '.reg');
    // ת�����԰�װĿ¼�ľ���·��Ϊ��·��
    strOrgPath := Copy(m_strRootDir, 1, LastDelimiter('\', m_strRootDir) - 1);
    strOrgPath := StringReplace(strOrgPath, '\', '\\', [rfReplaceAll]);
    pList.Text := StringReplace(pList.Text, strOrgPath,
        '$(MYROOTDIR)', [rfReplaceAll, rfIgnoreCase]);
    pList.SaveToFile(m_strTempPath + m_strAppAbName + '.reg');
    FreeAndNil(pList);

    // ɾ��REG�ļ������õ���Ϣ
    ini := TIniFile.Create(m_strTempPath + m_strAppAbName + '.reg');
    ini.EraseSection('HKEY_CURRENT_USER\Software\Borland\' + m_strRegPath);
    ini.EraseSection('HKEY_CURRENT_USER\Software\Borland\' + m_strRegPath + '\Closed Files');
    ini.EraseSection('HKEY_CURRENT_USER\Software\Borland\' + m_strRegPath + '\Closed Projects');
    ini.EraseSection('HKEY_CURRENT_USER\Software\Borland\' + m_strRegPath + '\Transfer');

    ini.EraseSection('HKEY_CURRENT_USER\Software\CodeGear\' + m_strRegPath);
    ini.EraseSection('HKEY_CURRENT_USER\Software\CodeGear\' + m_strRegPath + '\Closed Files');
    ini.EraseSection('HKEY_CURRENT_USER\Software\CodeGear\' + m_strRegPath + '\Closed Projects');
    ini.EraseSection('HKEY_CURRENT_USER\Software\CodeGear\' + m_strRegPath + '\Transfer');

    FreeAndNil(ini);

    Result := m_strAppAbName + '.reg';
  end
  else
    Result := '';
end;

// ���������е��Զ���Form
procedure TAppBuilderInfo.SaveObjRep(strDroFile: string);
var
  ini: TIniFile;
  pSecList: TStringList;
  i, j: integer;
  strRepsPath, strIconFile, sExt: string;
  strSec, strUnit, strTempType, strTempName: string;
  sfo: SHFILEOPSTRUCT;

  XMLDoc: IXMLDocument;
  Root, Items: IXMLElement;
begin
  // ��Ŷ�����ļ�����ʱĿ¼
  strRepsPath := ExtractFilePath(strDroFile) + 'Reps\';
  if not DirectoryExists(strRepsPath) then
    ForceDirectories(strRepsPath);

  // ��ϵͳĿ¼ObjRepos�������ļ���������ʱĿ¼
  OutputLog(g_strBackuping + m_strAppName + ' ' + g_strObjRepUnit + g_strPleaseWait);
  ZeroMemory(@sfo, sizeof(sfo));
  sfo.wFunc := FO_COPY;
  sfo.pFrom := PChar(m_strRootDir + 'ObjRepos\*.*' + #0 + #0);
  sfo.pTo := PChar(strRepsPath + #0 + #0);
  sfo.fFlags := FOF_NOCONFIRMATION or FOF_SILENT or FOF_NOCONFIRMMKDIR;

  OutputLog(m_strAppName + ' ' + g_strObjRepUnit + g_strBackup
      + OpResult(SHFileOperation(sfo) = 0), 1);

  if m_AbiType in [atBDS2005, atBDS2006, atDelphi2007, atDelphi2009, atDelphi2010,
    atDelphiXE, atDelphiXE2] then
  begin
    // �� XML ��ʽ���� BorlandStudioRepository.xml
    XMLDoc := CreateXMLDoc;
    XMLDoc.preserveWhiteSpace := True;
    XMLDoc.Load(strDroFile);

    Root := XMLDoc.documentElement;
    Items := nil;
    for I := 0 to Root.ChildNodes.Length - 1 do
      if Root.ChildNodes.Item[I].NodeName = 'Items' then
      begin
        Items := Root.ChildNodes.Item[I] as IXMLElement;
        Break;
      end;

    if Items <> nil then
    begin
      for I := 0 to Items.ChildNodes.Length - 1 do
      begin
        if Items.ChildNodes.Item[I].NodeName = 'Item' then
        begin
          // ��ĳ Item
          strSec := (Items.ChildNodes.Item[I] as IXMLElement).GetAttribute('IDString');
          strIconFile := (Items.ChildNodes.Item[I] as IXMLElement).GetAttribute('Icon');
          strUnit := Copy(strSec, LastDelimiter('\', strSec) + 1, Length(strSec));

          for J := 0 to (Items.ChildNodes.Item[I] as IXMLElement).ChildNodes.Length - 1 do
            if (Items.ChildNodes.Item[I] as IXMLElement).ChildNodes.Item[J].NodeName = 'Type' then
            begin
              strTempType := ((Items.ChildNodes.Item[I] as IXMLElement).ChildNodes.Item[J] as IXMLElement).GetAttribute('Value');
              Break;
            end;

          if UpperCase(strTempType) = 'PROJECTTEMPLATE' then
          begin
            // strSec ���õ������·���������� Pos(m_strRootDir + 'Objrepos', strSec) ���ˡ�
            if not DirectoryExists(m_strRootDir + 'Objrepos\' + strSec)
              and not FileExists(m_strRootDir + 'Objrepos\' + strSec + '.pas')
              and not FileExists(m_strRootDir + 'Objrepos\' + strSec + '.dfm')
              and not FileExists(m_strRootDir + 'Objrepos\' + strSec + '.xfm')
              and not FileExists(m_strRootDir + 'Objrepos\' + strSec + '.cpp')
              and not FileExists(m_strRootDir + 'Objrepos\' + strSec + '.h')
              and not FileExists(m_strRootDir + 'Objrepos\' + strSec + '.cs') then
            begin
              // ������ ObjRepos ��ͷ������
              ZeroMemory(@sfo, sizeof(sfo));
              sfo.wFunc := FO_COPY;
              sfo.pFrom := PChar(Copy(strSec, 1, LastDelimiter('\', strSec)) + '*.*' + #0 + #0);
              sfo.pTo := PChar(strRepsPath + strUnit + #0 + #0);
              sfo.fFlags := FOF_NOCONFIRMATION or FOF_SILENT or FOF_NOCONFIRMMKDIR;
              SHFileOperation(sfo);
            end;

            // strIconFile ���õ��Ǿ���·����������˱Ƚ�
            if (Pos(UpperCase(m_strRootDir + 'Objrepos'), UpperCase(strIconFile)) < 1) and FileExists(strIconFile) then
            begin
              CopyFile(PChar(strIconFile), PChar(strRepsPath
               + strUnit + '\' + strUnit + '.ico'), False);
              (Items.ChildNodes.Item[I] as IXMLElement).SetAttribute('Icon',
               '$(MYROOTDIR)\Objrepos\' + strUnit + '\' + strUnit + '.ico');
            end;
            (Items.ChildNodes.Item[I] as IXMLElement).SetAttribute('IDString', '$(MYROOTDIR)\Objrepos\' + strUnit);
          end
          else // FormTemplate
          begin
            // ����ϵͳȱʡĿ¼�µĶ�����ļ�
            // strSec ���õ������·���������� Pos(m_strRootDir + 'Objrepos', strSec) ���ˡ�
            if not DirectoryExists(m_strRootDir + 'Objrepos\' + strSec)
              and not FileExists(m_strRootDir + 'Objrepos\' + strSec + '.pas')
              and not FileExists(m_strRootDir + 'Objrepos\' + strSec + '.dfm')
              and not FileExists(m_strRootDir + 'Objrepos\' + strSec + '.xfm')
              and not FileExists(m_strRootDir + 'Objrepos\' + strSec + '.cpp')
              and not FileExists(m_strRootDir + 'Objrepos\' + strSec + '.h')
              and not FileExists(m_strRootDir + 'Objrepos\' + strSec + '.cs') then
            begin
              // .cpp �ļ�
              CopyFile(PChar(strSec + '.cpp'), PChar(strRepsPath + strUnit + '.cpp'), False);
              // .h �ļ�
              CopyFile(PChar(strSec + '.h'), PChar(strRepsPath + strUnit + '.h'), False);
              // .dfm/.xfm �ļ�
              sExt := '';
              for J := 0 to (Items.ChildNodes.Item[I] as IXMLElement).ChildNodes.Length - 1 do
                if (Items.ChildNodes.Item[I] as IXMLElement).ChildNodes.Item[J].NodeName = 'Designer' then
                begin
                  sExt := ((Items.ChildNodes.Item[I] as IXMLElement).ChildNodes.Item[J] as IXMLElement).GetAttribute('Value');
                  Break;
                end;

              if UpperCase(sExt) = 'ANY' then
              begin
                CopyFile(PChar(strSec + '.dfm'), PChar(strRepsPath + strUnit + '.dfm'), False);
                CopyFile(PChar(strSec + '.xfm'), PChar(strRepsPath + strUnit + '.xfm'), False);
              end
              else
                CopyFile(PChar(strSec + '.' + sExt), PChar(strRepsPath + strUnit + '.' + sExt), False);
              // .pas �ļ�
              CopyFile(PChar(strSec + '.pas'),
                  PChar(strRepsPath + strUnit + '.pas'), False);
              // .ico �ļ�
              if FileExists(strIconFile) then
              begin
                CopyFile(PChar(strIconFile), PChar(strRepsPath
                    + strUnit + '.ico'), False);
                (Items.ChildNodes.Item[I] as IXMLElement).SetAttribute('Icon',
                  '$(MYROOTDIR)\Objrepos\' + strUnit + '.ico');
              end;

              (Items.ChildNodes.Item[I] as IXMLElement).SetAttribute('IDString', '$(MYROOTDIR)\Objrepos\' + strUnit);
            end;
          end;
          OutputLog(g_strAnalyzing + g_strObjRepUnit + ': ' + strTempName, 1);
        end;
      end;
      XMLDoc.Save(strDroFile);
    end;
  end
  else
  begin
    // �����Ƕ� D567/BCB56 �Ĵ���
    pSecList := TStringList.Create;
    // �Ƚ�Dro�ļ��е�[]�滻���������Ӱ��TIniFile��
    pSecList.LoadFromFile(strDroFile);
    pSecList.Text := StringReplace(pSecList.Text, '[]', '[$(MYBLANK)]', [rfReplaceAll]);
    pSecList.SaveToFile(strDroFile);

    // �滻��ϣ���Ini��ʽ����
    ini := TIniFile.Create(strDroFile);
    pSecList := TStringList.Create;
    ini.ReadSections(pSecList);
    try
      for i := 0 to pSecList.Count - 1 do
      begin
        strSec := pSecList.Strings[i];
        strTempType := ini.ReadString(strSec, 'Type', '');
        strIconFile := ini.ReadString(strSec, 'Icon', '');
        strUnit := Copy(strSec, LastDelimiter('\', strSec) + 1, Length(strSec));
        strTempName := ini.ReadString(strSec, 'Name', '');

        if UpperCase(strTempType) = 'PROJECTTEMPLATE' then // ProjectTemplate
        begin
          if Pos(UpperCase(m_strRootDir + 'Objrepos'), UpperCase(strSec)) < 1 then
          begin
            ZeroMemory(@sfo, sizeof(sfo));
            sfo.wFunc := FO_COPY;
            sfo.pFrom := PChar(Copy(strSec, 1, LastDelimiter('\', strSec)) + '*.*' + #0 + #0);
            sfo.pTo := PChar(strRepsPath + strUnit + #0 + #0);
            sfo.fFlags := FOF_NOCONFIRMATION or FOF_SILENT or FOF_NOCONFIRMMKDIR;
            SHFileOperation(sfo);
          end;
          if FileExists(strIconFile) then
          begin
            CopyFile(PChar(strIconFile), PChar(strRepsPath
                + strUnit + '\' + strUnit + '.ico'), False);
            ini.WriteString(strSec, 'Icon', '$(MYROOTDIR)\Objrepos\'
                + strUnit + '\' + strUnit + '.ico');
          end;
          OutputLog(g_strAnalyzing + g_strObjRepUnit + ': ' + strTempName, 1);
        end
        else // FormTemmplate
        begin
          // ���ǺϷ�·���Ķ�������
          if not DirectoryExists(Copy(strSec, 1, LastDelimiter('\', strSec))) then
            Continue;
          // ����ϵͳȱʡĿ¼�µĶ�����ļ�
          if Pos(UpperCase(m_strRootDir + 'Objrepos'), UpperCase(strSec)) < 1 then
          begin
            // C++Builder 5,6 ����
            if (m_AbiType in [atBCB5, atBCB6]) then
            begin
              // .cpp �ļ�
              CopyFile(PChar(strSec + '.cpp'),
                  PChar(strRepsPath + strUnit + '.cpp'), False);
              // .h �ļ�
              CopyFile(PChar(strSec + '.h'),
                  PChar(strRepsPath + strUnit + '.h'), False);
              // .dfm/.xfm �ļ�
              CopyFile(PChar(strSec + '.'
                  + ini.ReadString(strSec, 'Designer', '')),
                  PChar(strRepsPath + strUnit + '.'
                  + ini.ReadString(strSec, 'Designer', '')), False);
              // .ico �ļ�
              if FileExists(strIconFile) then
              begin
                CopyFile(PChar(strIconFile), PChar(strRepsPath
                    + strUnit + '.ico'), False);
                ini.WriteString(strSec, 'Icon', '$(MYROOTDIR)\Objrepos\'
                    + strUnit + '.ico');
              end;
            end;
            // Delphi 5,6,7����
            if (m_AbiType in [atDelphi5, atDelphi6, atDelphi7]) then
            begin
              // .pas �ļ�
              CopyFile(PChar(strSec + '.pas'),
                  PChar(strRepsPath + strUnit + '.pas'), False);
              // .dfm/.xfm �ļ�
              CopyFile(PChar(strSec + '.'
                  + ini.ReadString(strSec, 'Designer', '')),
                  PChar(strRepsPath + strUnit + '.'
                  + ini.ReadString(strSec, 'Designer', '')), False);
              // .ico �ļ�
              if FileExists(strIconFile) then
              begin
                CopyFile(PChar(strIconFile), PChar(strRepsPath
                    + strUnit + '.ico'), False);
                ini.WriteString(strSec, 'Icon', '$(MYROOTDIR)\Objrepos\'
                    + strUnit + '.ico');
              end;
            end; // end of if (m_AbiType in [Delphi5, Delphi6, Delphi7])
            for j := 0 to Length(g_strObjReps) - 1 do
            begin
              ini.WriteString('$(MYROOTDIR)\Objrepos\' + strUnit,
                  g_strObjReps[j],
                  ini.ReadString(strSec, g_strObjReps[j], ''));
            end;
            ini.EraseSection(strSec);
          end; // end of Pos(UpperCase(m_strRootDir + 'Objrepos')...
          OutputLog(g_strAnalyzing + g_strObjRepUnit + ': ' + strTempName, 1);
        end; // end of if UpperCase(strType) = 'PROJECTTEMPLATE'
      end; // end of for
    finally
      FreeAndNil(ini);
      FreeAndNil(pSecList);
    end;
  end;
  pSecList := TStringList.Create;
  // ��AppBuilder��װĿ¼�ַ�����$(MYROOTDIR)����
  pSecList.LoadFromFile(strDroFile);
  pSecList.Text := StringReplace(pSecList.Text, m_strRootDir,
      '$(MYROOTDIR)\', [rfReplaceAll, rfIgnoreCase]);
  pSecList.SaveToFile(strDroFile);
  FreeAndNil(pSecList);
  OutputLog(m_strAppName + ' ' + g_strObjRepUnit + g_strBackupSuccess, 1);
end;

// ���������ļ�
function ParseBakFile(strBakFileName: string;
    var strRootDir, strAppName: string; var at: TAbiType): TAbiOptions;
var
  Header: THeaderStruct;
  btCheckSum: Byte;
  i: Integer;
  pHeader: PByte;
  fs: TFileStream;
  szBuf: array[0..MAX_PATH] of char;
begin
  fs := TFileStream.Create(strBakFileName, fmOpenRead);
  fs.Position := 0;
  fs.ReadBuffer(Header, sizeof(Header));
  FreeAndNil(fs);
  // ��֤У���
  btCheckSum := 0;
  pHeader := PByte(@Header);
  for i := 0 to SizeOf(Header) - 2 do
  begin
    btCheckSum := btCheckSum xor pHeader^;
    Inc(pHeader);
  end;
  if btCheckSum <> Header.btCheckSum then
  begin
    Result := [];
    exit;
  end;
  at := TAbiType(Header.btAbiType - 1);
  // AppBuilder ������
  if at In [Low(TAbiType)..High(TAbiType)] then
    strAppName := g_strAppName[Integer(at)]
  else
    strAppName := g_strUnkownName;
  // AppBuilder ��װĿ¼
  ZeroMemory(@szBuf, SizeOf(szBuf));
  for i := 0 to SizeOf(Header.szAppRootPath) - 1 do
  begin
    szBuf[i] := Char(Byte(Header.szAppRootPath[i]) xor XorKey);
  end;
  strRootDir := szBuf;
  //
  Result := TAbiOptions(Header.btAbiOption);
end;

// �ӱ����ļ��л�ԭ��Ϣ
function TAppBuilderInfo.RestoreInfoFromFile(strBakFileName: string): Boolean;
var
  fs: TFileStream;
  dcmp: TDecompressor;
  strTempPath, strFileName, strOrgPath, strSecName: string;
  sfo: SHFILEOPSTRUCT;
  bResult: Boolean;
  pList: TStringList;
  ini: TIniFile;
  i: Integer;
  regExec: string;
begin
  // ��ѹ�������ļ���
  try
    fs := TFileStream.Create(strBakFileName, fmOpenRead);
    dcmp := TDecompressor.Create(fs);

    strTempPath := MyGetTempPath(ParamStr(0)) + m_strAppAbName + '\';
    if DirectoryExists(strTempPath) then
    begin
      // ɾ���ָ��ļ�ʱ��������ʱ�ļ�Ŀ¼
      if DirectoryExists(strTempPath) then
      begin
        ZeroMemory(@sfo, sizeof(sfo));
        sfo.wFunc := FO_DELETE;
        sfo.pFrom := PChar(Copy(strTempPath, 1, Length(strTempPath) - 1) + #0 + #0);
        sfo.fFlags := FOF_NOCONFIRMATION or FOF_SILENT; // ��������ʾ
        SHFileOperation(sfo);
      end;
    end;
    // �����´�����ʱ�ͷ�Ŀ¼
    ForceDirectories(strTempPath);
    OutputLog(g_strAnalyzing + m_strAppName + ' ' + g_strBakFile + g_strPleaseWait);
    dcmp.Extract(strTempPath);
    OutputLog(m_strAppName + ' ' + g_strBakFile + g_strAnalyseSuccess, 1);
  finally
    FreeAndNil(dcmp);
    FreeAndNil(fs);
  end;
  // ����ģ���ļ���dci
  if aoCodeTemp in m_abiOption then
  begin
    strFileName := m_strTempPath + GetAbiOptionFile(aoCodeTemp);
    if FileExists(strFileName) then
    begin
      if m_AbiType in [atBDS2005, atBDS2006, atDelphi2007, atDelphi2009, atDelphi2010] then
        bResult := CopyFile(PChar(strFileName),
          PChar(m_strRootDir + 'Objrepos\' + GetAbiOptionFile(aoCodeTemp)), False)
      else if m_AbiType in [atDelphiXE, atDelphiXE2] then
        bResult := CopyFile(PChar(strFileName),
          PChar(m_strRootDir + 'Objrepos\en\' + GetAbiOptionFile(aoCodeTemp)), False)
      else
        bResult := CopyFile(PChar(strFileName),
          PChar(m_strRootDir + 'bin\' + GetAbiOptionFile(aoCodeTemp)), False);

      OutputLog(m_strAppName + ' ' + g_strAbiOptions[Ord(aoCodeTemp)]
          + g_strRestore + OpResult(bResult));
    end
    else
      OutputLog(g_strNotFound + m_strAppName + ' ' + g_strAbiOptions[Ord(aoCodeTemp)]);
  end;
  // ������ļ���dro
  if aoObjRep in m_abiOption then
  begin
    strFileName := m_strTempPath + GetAbiOptionFile(aoObjRep);
    if FileExists(strFileName) then
    begin
      OutputLog(g_strRestoring + g_strObjRepUnit + g_strPleaseWait);
      //
      bResult := LoadRepObj(strFileName);
      OutputLog(m_strAppName + ' ' + g_strObjRepUnit + g_strRestore + OpResult(bResult), 1);

      if m_AbiType in [atBDS2005, atBDS2006, atDelphi2007, atDelphi2009, atDelphi2010] then
        bResult := CopyFile(PChar(strFileName),
          PChar(m_strRootDir + 'Objrepos\' + GetAbiOptionFile(aoObjRep)), False)
      else if m_AbiType in [atDelphiXE, atDelphiXE2] then
        bResult := CopyFile(PChar(strFileName),
          PChar(m_strRootDir + 'Objrepos\en' + GetAbiOptionFile(aoObjRep)), False)
      else
        bResult := CopyFile(PChar(strFileName),
          PChar(m_strRootDir + 'bin\' + GetAbiOptionFile(aoObjRep)), False);
      OutputLog(m_strAppName + ' ' + g_strObjRepConfig + g_strRestore + OpResult(bResult));
    end
    else
      OutputLog(g_strNotFound + m_strAppName + ' ' + g_strObjRepConfig);
  end;
  // �˵�ģ���ļ���dmt
  if aoMenuTemp in m_abiOption then
  begin
    strFileName := m_strTempPath + GetAbiOptionFile(aoMenuTemp);
    if FileExists(strFileName) then
    begin
      if m_AbiType in [atDelphiXE, atDelphiXE2] then
        bResult := CopyFile(PChar(strFileName),
          PChar(m_strRootDir + 'ObjRepos\en\' + GetAbiOptionFile(aoMenuTemp)), False)
      else
        bResult := CopyFile(PChar(strFileName),
          PChar(m_strRootDir + 'bin\' + GetAbiOptionFile(aoMenuTemp)), False);
      OutputLog(m_strAppName + ' ' + g_strAbiOptions[Ord(aoMenuTemp)] + g_strRestore + OpResult(bResult));
    end
    else
      OutputLog(g_strNotFound + m_strAppName + ' ' + g_strAbiOptions[Ord(aoMenuTemp)]);
  end;
  // IDE ������Ϣ���Լ�����ģ�� dsk/dst
  if aoRegInfo in m_AbiOption then
  begin
    strFileName := m_strTempPath + m_strAppAbName + '.reg';
    if FileExists(strFileName) then
    begin
      OutputLog(g_strAnalyzing + g_strAbiOptions[Ord(aoRegInfo)] + g_strPleaseWait);
      pList := TStringList.Create;
      pList.LoadFromFile(strFileName);
      strOrgPath := Copy(m_strRootDir, 1, LastDelimiter('\', m_strRootDir) - 1);
      strOrgPath := StringReplace(strOrgPath, '\', '\\', [rfReplaceAll]);
      pList.Text := StringReplace(pList.Text, '$(MYROOTDIR)', strOrgPath,
        [rfReplaceAll, rfIgnoreCase]);
      pList.SaveToFile(m_strTempPath + m_strAppAbName + '.reg');
      FreeAndNil(pList);

      ini := TIniFile.Create(strFileName);
      pList := TStringList.Create;
      strSecName := 'HKEY_CURRENT_USER' + GetRegIDEBaseFromAt(m_AbiType)
          + m_strRegPath + '\Experts';
      // ����REG�ļ��е�IDEר���ļ��Ƿ����
      ini.ReadSection(strSecName, pList);
      for i := 0 to pList.Count - 1 do
      begin
        if not FileExists(ini.ReadString(strSecName, pList.Strings[i], '')) then
          ini.DeleteKey(strSecName, pList.Strings[i]);
      end;
      // ����REG�ļ��е���֪������Ƿ����
      strSecName := 'HKEY_CURRENT_USER' + GetRegIDEBaseFromAt(m_AbiType)
        + m_strRegPath + '\Known Packages';
      ini.ReadSection(strSecName, pList);

      // ��ע����е�˫б���滻�ص�б�ߣ���Ҫȥ�����ţ���лfirefox
      pList.Text := StringReplace(pList.Text, '\\', '\', [rfReplaceAll]);
      for i := 0 to pList.Count - 1 do
      begin
        if (Length(pList.Strings[i]) > 1) and (pList.Strings[i][1] = '"') then // ���ٴ���2������ǰ��������
          pList.Strings[i] := Copy(pList.Strings[i], 2, Length(pList.Strings[i]) - 2);
        if not FileExists(pList.Strings[i]) then
          ini.DeleteKey(strSecName, pList.Strings[i]);
      end;
      // �������
      FreeAndNil(pList);
      FreeAndNil(ini);
      OutputLog(g_strAbiOptions[Ord(aoRegInfo)] + g_strAnalyseSuccess + g_strPleaseWait, 1);
      regExec := 'regedit.exe /s "' + strFileName + '"';
      //bResult := Integer(ShellExecute(0, 'open', , nil, SW_HIDE)) > 32;
      bResult := (0 = WinExecAndWait32(regExec, SW_HIDE, True));

      OutputLog(m_strAppName + ' ' + g_strAbiOptions[Ord(aoRegInfo)] + g_strRestore + OpResult(bResult), 1);
    end
    else
      OutputLog(g_strNotFound + m_strAppName + ' ' + g_strAbiOptions[Ord(aoRegInfo)]);

    FindFile(m_strTempPath, '*.dsk', OnFindRestoreDskFile, nil, False);
    FindFile(m_strTempPath, '*.dst', OnFindRestoreDskFile, nil, False);
  end;
  OutputLog('----------------------------------------');
  OutputLog(g_strThanksForRestore);
  OutputLog(g_strBugReportToMe);
  Result := True;
end;

// �ָ�������е�Form
function TAppBuilderInfo.LoadRepObj(strDroFile: string): Boolean;
var
  pSecList: TStringList;
  strRepsPath: string;
  sfo: SHFILEOPSTRUCT;
begin
  // ��Ŷ�����ļ�����ʱĿ¼
  strRepsPath := ExtractFilePath(strDroFile) + 'Reps\';
  if not DirectoryExists(strRepsPath) then
  begin
    Result := False;
    Exit;
  end;
  // Ŀ���ļ���(BCBϵͳ��ObjReposĿ¼)
  if not DirectoryExists(m_strRootDir + 'ObjRepos\') then
    ForceDirectories(m_strRootDir + 'ObjRepos\');

  pSecList := TStringList.Create;
  pSecList.LoadFromFile(strDroFile);
  // ��[$(MYBLANK)]�滻��ԭ���Ŀո�
  pSecList.Text := StringReplace(pSecList.Text, '[$(MYBLANK)]', '[]', [rfReplaceAll]);
  // ��AppBuilder��װĿ¼�ַ�����$(MYROOTDIR)����
  pSecList.Text := StringReplace(pSecList.Text, '$(MYROOTDIR)\', m_strRootDir,
      [rfReplaceAll, rfIgnoreCase]);
  pSecList.SaveToFile(strDroFile);
  FreeAndNil(pSecList);

  // ����ʱĿ¼�е�Rep�ļ�������ϵͳĿ¼��
  ZeroMemory(@sfo, sizeof(sfo));
  sfo.wFunc := FO_COPY;
  sfo.pFrom := PChar(strRepsPath + '*.*' + #0 + #0);
  sfo.pTo := PChar(m_strRootDir + 'ObjRepos\' + #0 + #0);
  sfo.fFlags := FOF_NOCONFIRMATION or FOF_SILENT or FOF_NOCONFIRMMKDIR;
  Result := SHFileOperation(sfo) = 0;
end;

function TAppBuilderInfo.GetAbiOptionFile(ao: TAbiOption): string;
begin
  case m_AbiType of
    atBCB5, atBCB6:
      case ao of
        aoCodeTemp: Result := 'bcb.dci'; // ����ģ��
        aoObjRep: Result := 'bcb.dro';   // �����
        aoRegInfo: Result := '';     // ע�����Ϣ
        aoMenuTemp: Result := 'bcb.dmt'; // �˵�ģ��
      end;
    atDelphi5, atDelphi6, atDelphi7, atDelphi8:
      case ao of
        aoCodeTemp: Result := 'delphi32.dci'; // ����ģ��
        aoObjRep: Result := 'delphi32.dro';   // �����
        aoRegInfo: Result := '';        // ע�����Ϣ
        aoMenuTemp: Result := 'delphi32.dmt'; // �˵�ģ��
      end;
    atBDS2005, atBDS2006, atDelphi2007, atDelphi2009:
      case ao of
        aoCodeTemp: Result := 'bds.dci'; // ����ģ��
        aoObjRep: Result := 'BorlandStudioRepository.xml';   // �����
        aoRegInfo: Result := '';        // ע�����Ϣ
        aoMenuTemp: Result := 'bds.dmt'; // �˵�ģ��
      end;
    atDelphi2010, atDelphiXE, atDelphiXE2:
      case ao of
        aoCodeTemp: Result := 'bds.dci'; // ����ģ��
        aoObjRep: Result := 'RADStudioRepository.xml';   // �����
        aoRegInfo: Result := '';        // ע�����Ϣ
        aoMenuTemp: Result := 'bds.dmt'; // �˵�ģ��
      end;
    else
      Result := '';
  end;
end;

// �����־
procedure TAppBuilderInfo.OutputLog(strMsg: string; nFlag: Integer);
begin
  SendMessage(m_hOwner, $400 + 1001, WPARAM(PChar(strMsg)), nFlag);
end;

//---------------------------------------------------------------------------
// ���ú����Ķ��岿�� -- �����ķָ��� --
//---------------------------------------------------------------------------

// �鿴 AppBuilder �Ƿ���������
function IsAppBuilderRunning(at: TAbiType): boolean;
var
  hAppBuilder: THandle;
  szBuf: array[0..255] of char;
  strTemp, strAppName: string;
  strExeName: string;
  bInProcess, bFoundWin: Boolean;
begin
  strAppName := g_strAppName[Integer(at)];
  hAppBuilder := FindWindow('TAppBuilder', nil);
  if hAppBuilder <> 0 then
  begin
    GetWindowText(hAppBuilder, szBuf, 255);
    strTemp := Copy(strAppName, 1, Length(strAppName) - 2);
    bFoundWin := Pos(strTemp, string(szBuf)) > 0;
  end
  else
    bFoundWin := False;

  case at of
    atBCB5, atBCB6:
      strExeName := 'bcb.exe';
    atDelphi5, atDelphi6, atDelphi7, atDelphi8:
      strExeName := 'Delphi32.exe';
    atBDS2005, atBDS2006, atDelphi2007, atDelphi2009, atDelphi2010:
      strExeName := 'bds.exe';
    else
      strExeName := '';
  end;
  bInProcess := FileInProcessList(GetAppRootDir(at) + 'bin\' + strExeName);
  Result := bInProcess or bFoundWin;
end;

// AppBuilder �İ�װ��Ŀ¼
function GetAppRootDir(at: TAbiType): string;
var
  bResult: Boolean;
  strAppFile: string;
  pReg: TRegistry; // ����ע������
begin
  Result := '';

  pReg := TRegistry.Create; // ��������ע������
  pReg.RootKey := HKEY_LOCAL_MACHINE;
  bResult := pReg.OpenKey(GetRegIDEBaseFromAt(at) + g_strRegPath[Integer(at)], False);
  if bResult = True then
  begin
    if pReg.ValueExists('App') then
    begin
      strAppFile := pReg.ReadString('App');
      if FileExists(strAppFile) and pReg.ValueExists('RootDir') then
        Result := IncludeTrailingBackslash(pReg.ReadString('RootDir'));
    end;
  end;

  pReg.CloseKey;

  // �� LocalMachine�Ļ����ټ��CurrentUser
  if Trim(Result) = '' then
  begin
    pReg.RootKey := HKEY_CURRENT_USER;
    bResult := pReg.OpenKey(GetRegIDEBaseFromAt(at) + g_strRegPath[Integer(at)], False);
    if bResult = True then
    begin
      if pReg.ValueExists('App') then
      begin
        strAppFile := pReg.ReadString('App');
        if FileExists(strAppFile) and pReg.ValueExists('RootDir') then
          Result := IncludeTrailingBackslash(pReg.ReadString('RootDir'));
      end;
    end;
  end;

  pReg.CloseKey;
  FreeAndNil(pReg);
end;

// ����������ַ���
function OpResult(bResult: Boolean): string;
begin
  Result := g_strOpResult[Integer(bResult)];
end;

// ��ʱ�ļ����Ŀ¼
function MyGetTempPath(strFileName: string): string;
var
  szBuf: array[0..MAX_PATH] of char;
begin
  GetTempPath(MAX_PATH, szBuf);
  Result := szBuf;
end;

// �鿴ָ���ļ��Ƿ��ڽ����б���
function FileInProcessList(strFileName: string): Boolean;
var
  pe32: PROCESSENTRY32;
  me32: MODULEENTRY32;
  hSnapShot: THandle;
  bFlag: Boolean;
  hModuleSnap: THandle;
  strTemp: string;
begin
  Result := False;
  ZeroMemory(@pe32, sizeof(pe32));
  pe32.dwSize := SizeOf(pe32);

  hSnapShot := CreateToolhelp32Snapshot(TH32CS_SNAPPROCESS, 0);
  if hSnapShot = 0 then exit;

  bFlag := Process32First(hSnapShot, pe32);
  while bFlag do
  begin
    if UpperCase(ExtractFileName(strFileName))
        = UpperCase(ExtractFileName(pe32.szExeFile)) then
    begin
      hModuleSnap := CreateToolhelp32Snapshot(TH32CS_SNAPALL, pe32.th32ProcessID);
      if hModuleSnap = INVALID_HANDLE_VALUE then
        strTemp := string(pe32.szExeFile)
      else
      begin
        ZeroMemory(@me32, sizeof(me32));
		    me32.dwSize := sizeof(me32);
			  if Module32First(hModuleSnap, me32) then
          strTemp := string(me32.szExePath);
      end;
      CloseHandle(hModuleSnap);
      if UpperCase(strTemp) = UpperCase(strFileName) then
      begin
        Result := True;
        exit;
      end;
    end;
    bFlag := Process32Next(hSnapShot, pe32);
  end;
  CloseHandle(hSnapShot);
end;

// ���IDE�򿪹��Ĺ���/�ļ���ʷ��¼
function ClearOpenedHistory(at: TAbiType): Boolean;
var
  reg: TRegistry;
begin
  reg := TRegistry.Create;
  reg.RootKey := HKEY_CURRENT_USER;
  reg.OpenKey(GetRegIDEBaseFromAt(at) + g_strRegPath[Integer(at)], False);
  reg.DeleteKey('Closed Files');
  reg.CreateKey('Closed Files');
  reg.DeleteKey('Closed Projects');
  reg.CreateKey('Closed Projects');
  Result := True;
  FreeAndNil(reg);
end;

function GetRegIDEBaseFromAt(at: TAbiType): string;
begin
  if Integer(at) >= Integer(atDelphiXE) then
    Result := '\Software\Embarcadero\'
  else if Integer(at) >= Integer(atDelphi2009) then
    Result := '\Software\CodeGear\'
  else
    Result := '\Software\Borland\';
end;

procedure TAppBuilderInfo.OnFindBackupDskFile(const FileName: string;
  const Info: TSearchRec; var Abort: Boolean);
var
  bResult: Boolean;
begin
  bResult := CopyFile(PChar(FileName), PChar(MakePath(m_strTempPath) +
    ExtractFileName(FileName)), False);
  OutputLog(m_strAppName + ' ' + ExtractFileName(FileName) + g_strBackup + OpResult(bResult));
end;

procedure TAppBuilderInfo.OnFindRestoreDskFile(const FileName: string;
  const Info: TSearchRec; var Abort: Boolean);
var
  bResult: Boolean;
begin
  bResult := CopyFile(PChar(FileName), PChar(m_strRootDir + 'bin\' +
    ExtractFileName(FileName)), False);
  OutputLog(m_strAppName + ' ' + ExtractFileName(FileName) + g_strRestore + OpResult(bResult));
end;

end.
