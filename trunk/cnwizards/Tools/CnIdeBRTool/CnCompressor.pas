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

unit CnCompressor;
{* |<PRE>
================================================================================
* ������ƣ�CnPack IDE ר�Ҹ�������/�ָ�����
* ��Ԫ���ƣ�CnWizards ��������/�ָ�����ѹ����Ԫ
* ��Ԫ���ߣ�ccRun(����)
* ��    ע��CnWizards ר�Ҹ�������/�ָ�������ѹ����Ԫ
* ����ƽ̨��PWinXP + Delphi 5.01
* ���ݲ��ԣ�PWin9X/2000/XP + Delphi 5/6/7 + C++Builder 5/6
* �� �� �����õ�Ԫ�е��ַ��������ϱ��ػ�����ʽ
* ��Ԫ��ʶ��$Id: CnCompressor.pas 763 2011-02-07 14:18:23Z liuxiao@cnpack.org $
* �޸ļ�¼��2006.08.23 V1.0
*               LiuXiao ��ֲ�˵�Ԫ
================================================================================
|</PRE>}

interface

uses
  Classes, Windows, SysUtils, FileCtrl, ZLib;

type
  THeaderStruct = packed record
    dwSign: DWORD; // �ļ���־
    szReserve: array[0..19] of Char; // ����
    btAbiType: Byte;  // IDE������
    btAbiOption: Byte;  // ���ݵ�ѡ��
    szAppRootPath: array[0..MAX_PATH] of char;
    nFileTableOffset: Integer; // �ļ���ƫ��ֵ
    nFileCount: Integer; // �ļ�����
    btCheckSum: Byte;  // �ļ�ͷУ���
  end;

  PFileEntry = ^TFileEntry;
  TFileEntry = packed record
    dwFileOffset: DWORD;
    dwSizeBeforeCompress: DWORD;
    dwSizeAfterCompress: DWORD;
    dwNextFileEntryOffset: DWORD;
    strFileName: Char;
  end;

  TCompressionQuery = function(const strLocalFileName: String): Boolean of object;

  TCompressor = class
  private
    FStream: TStream;
    FFiles: TList;
    FPosition: Int64;
    FOnCompressionQuery: TCompressionQuery;
    function CanCompress(const strFileName: String): Boolean;
  public
    constructor Create(OutputStream: TStream);
    destructor Destroy;override;
    procedure AddFile(const strLocalFileName: String; const strPackageFileName: String);
    procedure AddFolder(const strFolder: String);
    property OnCompressionQuery: TCompressionQuery read FOnCompressionQuery write FOnCompressionQuery;
  end;

  TDecompressor = class
  private
    FStream: TStream;
    FPosition: Int64;
    FHeader: THeaderStruct;
    FFilePos: Int64;
    FFileIndex: Integer;
  public
    constructor Create(InputStream: TStream);
    destructor Destroy;override;
    function FirstFile: PFileEntry;
    function NextFile: PFileEntry;
    procedure ReadFile(FileEntry: PFileEntry;Stream: TStream);
    function Extract(const strOutputDir: String): Integer;
  end;

const
  CompressSign = $00434942; {BIC0}
  XorKey: Byte = $C2; // ���ļ�ֵ
  function GetHashCode(const Str: String): Cardinal;
  function CreateFileEntry(Offset: DWORD; dwSizeBeforeCompress: DWORD;
      dwSizeAfterCompress: DWORD; const strFileName: String): PFileEntry;
  function ExtractFileSize(const strName: String): Integer;
  procedure CreateDirectory(const strPath: String; dwAttributes: DWORD);

implementation

//------------------------------------------------------------------------------
procedure strenc(s: PChar);
begin
  while s^ <> #0 do
  begin
    Byte(s^) := Byte(s^) xor XorKey;
    Inc(s);
  end;
end;
//------------------------------------------------------------------------------
function ExtractFileSize(const strName: String): Integer;
var
  hFile: THandle;
begin
  Result := -1;
  hFile := CreateFile(PChar(strName), GENERIC_READ, 0, NIL, OPEN_EXISTING, 0, 0);
  if hFile = INVALID_HANDLE_VALUE then exit;
  Result := SetFilePointer(hFile, 0, nil, FILE_END);
  CloseHandle(hFile);
end;
//------------------------------------------------------------------------------
function CreateFileEntry(Offset: DWORD; dwSizeBeforeCompress: DWORD;
    dwSizeAfterCompress: DWORD; const strFileName: String): PFileEntry;
var
  dwRecordSize: DWORD;
begin
  dwRecordSize := Sizeof(TFileEntry) + Length(strFileName);
  GetMem(Result, dwRecordSize);
  Result^.dwFileOffset := Offset;
  Result^.dwSizeBeforeCompress := dwSizeBeforeCompress;
  Result^.dwSizeAfterCompress := dwSizeAfterCompress;
  Result^.dwNextFileEntryOffset := dwRecordSize;
  lstrcpy(@Result^.strFileName, PChar(strFileName));
  strenc(@Result^.strFileName);
end;
//------------------------------------------------------------------------------
function GetHashCode(const Str: String): Cardinal;
var
  nOff, nLen, nSkip, i: Integer;
begin
  Result := 0;
  nOff := 1;
  nLen := Length(Str);
  if nLen < 16 then
  for i := (nLen - 1) downto 0 do
  begin
    Result := (Result * 37) + Ord(Str[nOff]);
    Inc(nOff);
  end
  else
  begin
    { Only sample some characters }
    nSkip := nLen div 8;
    i := nLen - 1;
    while i >= 0 do
    begin
      Result := (Result * 39) + Ord(Str[nOff]);
      Dec(i, nSkip);
      Inc(nOff, nSkip);
    end;
  end;
end;
//------------------------------------------------------------------------------
procedure CreateDirectory(const strPath: String; dwAttributes: DWORD);
var
  lpPath: PChar;
  lpTemp: PChar;
  szBuffer: array[1..MAX_PATH] of char;
  procedure MoveToNextSplitter;
  begin
    while lpTemp^ <> #0 do
    begin
      if lpTemp^ = '\' then
        exit;
      Inc(lpTemp);
    end;
  end;
begin
  if DirectoryExists(strPath) then exit;
  FillChar(szBuffer, sizeof(szBuffer), 0);
  lstrcpy(@szBuffer, PChar(strPath));
  lpPath := @szBuffer;
  lpTemp := lpPath;
  MoveToNextSplitter;
  Inc(lpTemp);

  while lpTemp^ <> #0 do
  begin
    MoveToNextSplitter;
    lpTemp^ := #0;
    if DirectoryExists(lpPath) = false then
    begin
      Windows.CreateDirectory(lpPath, Nil);
      SetFileAttributes(lpPath, dwAttributes);
    end;
    lpTemp^ := '\';
    Inc(lpTemp);
  end;
end;
//------------------------------------------------------------------------------


//------------------------------------------------------------------------------
constructor TCompressor.Create(OutputStream: TStream);
var
  Header: THeaderStruct;
begin
  FPosition := OutputStream.Position;
  FStream := OutputStream;
  FFiles := TList.Create;

  Header.dwSign := CompressSign;
  Header.btAbiType := 0;   // IDE����
  Header.btAbiOption := 0; // ����ѡ��
  Header.btCheckSum := 0;  // У���
  Header.nFileTableOffset := 0;
  Header.nFileCount := 0;
  FStream.WriteBuffer(Header,sizeof(Header));
end;
//------------------------------------------------------------------------------
destructor TCompressor.Destroy;
var
  i, nLast: Integer;
  pEntry: PFileEntry;
  lPos, lFileEntryOffset: Int64;
  Header: THeaderStruct;
begin
  lFileEntryOffset := FStream.Position - FPosition;
  nLast := FFiles.Count -1;
  for i := 0 to nLast do
  begin
    pEntry := FFiles[i];
    FStream.WriteBuffer(pEntry^, pEntry^.dwNextFileEntryOffset);
    FreeMem(pEntry);
  end;
  lPos := FStream.Position ;
  FStream.Position := FPosition;
  FStream.ReadBuffer(Header, sizeof(Header));
  Header.nFileTableOffset := lFileEntryOffset;
  Header.nFileCount := FFiles.Count ;
  FStream.Position := FPosition;
  FStream.WriteBuffer(Header, sizeof(Header));
  FStream.Position := lPos;
  FFiles.Free;
  inherited;
end;
//------------------------------------------------------------------------------
procedure TCompressor.AddFile(const strLocalFileName: String; const strPackageFileName: String);
var
  pEntry: PFileEntry;
  lOffset: Int64;
  dwSizeBeforeCompress: DWORD;
  fs: TFileStream;
  cs: TCompressionStream;
begin
  lOffset := FStream.Position - FPosition;
  dwSizeBeforeCompress := ExtractFileSize(strLocalFileName);
  pEntry := CreateFileEntry(lOffset,dwSizeBeforeCompress,0,strPackageFileName);
  FFiles.Add(pEntry);
  fs := nil;
  try
    fs := TFileStream.Create(strLocalFileName, fmOpenRead);
    cs := TCompressionStream.Create(clFastest, FStream);
    cs.CopyFrom(fs,fs.Size);
  finally
    FreeAndNil(cs);
    FreeAndNil(fs);
  end;
  end;
//------------------------------------------------------------------------------
function TCompressor.CanCompress(const strFileName: String): Boolean;
begin
  if Assigned(FOnCompressionQuery) then
    Result := FOnCompressionQuery(strFileName)
  else
    Result := True;
end;
//------------------------------------------------------------------------------
procedure TCompressor.AddFolder(const strFolder: String);
var
  strPath: String;
  strFileName: String;
  procedure GetFiles(strParentFolder: String; strParent: String);
  var
    strPattern: String;
    sr: TSearchRec;
    nRet: Integer;
  begin
    strPattern := strParentFolder + '*.*';
    nRet := FindFirst(strPattern, faAnyFile, sr);
    while nRet = 0 do
    begin
      if(sr.Attr and faDirectory) = faDirectory then
      begin
        if(CompareStr(sr.Name, '.') <> 0) and (CompareStr(sr.Name, '..') <> 0) then
          GetFiles(strParentFolder + sr.Name + '\', strParent + sr.Name + '\');
      end
      else
      begin
        strFileName := strParentFolder + sr.Name;
        if CanCompress(strFileName) then
        begin
          AddFile(strFileName, strParent + sr.Name);
        end;
      end;
      nRet := FindNext(sr);
    end;
    FindClose(sr);
  end;
begin
if not DirectoryExists(strFolder) then exit;
  strPath := strFolder;
  if strPath[Length(strPath)]<>'\' then strPath := strPath+'\';
  GetFiles(strPath,'');
end;
//------------------------------------------------------------------------------
constructor TDecompressor.Create(InputStream: TStream);
begin
  FStream := InputStream;
  FPosition := InputStream.Position;
  try
    FStream.ReadBuffer(FHeader, sizeof(FHeader));
  except
  end;
  if FHeader.dwSign <> CompressSign then
    raise ERangeError.Create('�ļ���ʽ����');
end;
//------------------------------------------------------------------------------
destructor TDecompressor.Destroy;
begin
end;
//------------------------------------------------------------------------------
function TDecompressor.FirstFile: PFileEntry;
var
  pEntry: TFileEntry;
begin
  FFilePos := FHeader.nFileTableOffset + FPosition;
  FFileIndex := 1;
  Result := nil;
  if FFileIndex>FHeader.nFileCount  then exit;

  FStream.Position := FFilePos;
  FStream.ReadBuffer(pEntry, sizeof(pEntry));

  GetMem(Result, pEntry.dwNextFileEntryOffset);
  FStream.Position := FFilePos;
  FStream.ReadBuffer(Result^, pEntry.dwNextFileEntryOffset);
  strenc(@Result^.strFileName);
  FFilePos := FFilePos+pEntry.dwNextFileEntryOffset;
end;
//------------------------------------------------------------------------------
function TDecompressor.NextFile: PFileEntry;
var
  pEntry: TFileEntry;
begin
  Inc(FFileIndex);
  Result := nil;
  if FFileIndex>FHeader.nFileCount then exit;
  FStream.Position := FFilePos;
  FStream.ReadBuffer(pEntry, sizeof(pEntry));
  GetMem(Result, pEntry.dwNextFileEntryOffset);
  FStream.Position := FFilePos;
  FStream.ReadBuffer(Result^, pEntry.dwNextFileEntryOffset);
  strenc(@Result^.strFileName);
  FFilePos := FFilePos+pEntry.dwNextFileEntryOffset ;
end;
//------------------------------------------------------------------------------
procedure TDecompressor.ReadFile(FileEntry: PFileEntry; Stream: TStream);
var
  ds: TDecompressionStream;
begin
  FStream.Position := FPosition+FileEntry.dwFileOffset;
  ds := TDecompressionStream.Create(FStream);
  try
    Stream.CopyFrom(ds, FileEntry.dwSizeBeforeCompress);
  finally
    ds.Free ;
  end;
end;
//------------------------------------------------------------------------------
function TDecompressor.Extract(const strOutputDir: String): Integer;
var
  pEntry: PFileEntry;
  strFileName: String;
  strPath: String;
  FilePath: String;
  fs: TFileStream;
begin
  strPath := strOutputDir;
  strPath := strPath + '\';
  pEntry := FirstFile;
  Result := 0;
  while pEntry <> nil do
  begin
    Inc(Result);
    strFileName := strPath + StrPas(@pEntry.strFileName);
    FilePath := ExtractFilePath(strFileName);
    if not DirectoryExists(FilePath) then
      CreateDirectory(FilePath, 0);
    fs := nil;
    try
    fs := TFileStream.Create(strFileName, fmCreate);
    if pEntry^.dwSizeBeforeCompress <> 0 then
      ReadFile(pEntry, fs);
    finally
      FreeAndNil(fs);
    end;
    FreeMem(pEntry);
    pEntry := NextFile;
  end;
end;

end.
