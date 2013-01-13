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
{ This unit is derived from http://rouse.front.ru's propsheet.zip, below is the
  author's original declaration
//
//  ****************************************************************************
//  * Project   : PEDump
//  * Unit Name : Import.inc, DebugHlp.pas, DumpUtils.pas
//  * Purpose   : D����?���� ? ImageHlpAPI �� e?��?��?��?��? ?������?����
//                ?��?����?��a��t����? a Windows 98/ME
//  * Author    : ��??��?����?e (Rouse_) ����???��
//  * Copyright : ? Fangorn Wizards Lab 1998 - 2006 ?.
//  * Version   : 1.00
//  * Home Page : http://rouse.front.ru
//  ****************************************************************************
//
}

unit CnSMRPEUtils;
{ |<PRE>
================================================================================
* ������ƣ�CnPack ��ִ���ļ���ϵ��������
* ��Ԫ���ƣ�PE ������Ԫ
* ��Ԫ���ߣ�Chinbo��Shenloqi��
* ��    ע��
* ����ƽ̨��PWin2000Pro + Delphi 5.01
* ���ݲ��ԣ�PWin9X/2000/XP + Delphi 5/6/7 + C++Builder 5/6
* �� �� �����õ�Ԫ�е��ַ���֧�ֱ��ػ�����ʽ
* ��Ԫ��ʶ��$Id: CnSMRPEUtils.pas 763 2011-02-07 14:18:23Z liuxiao@cnpack.org $
* �޸ļ�¼��2008.7.30 V1.0
*               ������Ԫ
================================================================================
|</PRE>}

interface

{$I CnWizards.inc}

uses
  SysUtils, Windows, Classes;

procedure GetImportTable(ss: TStrings; const PEFile: String);
procedure GetDelayImportTable(ss: TStrings; const PEFile: String);
procedure GetExportTable(ss: TStrings; const PEFile: String);

implementation

{$RANGECHECKS OFF}
{$IFDEF DELPHI7_UP}
  {$WARN SYMBOL_PLATFORM OFF}
  {$WARN UNIT_PLATFORM OFF}
{$ENDIF}

const
  IMAGE_ORDINAL_FLAG = DWORD($80000000);
  IMAGE_DIRECTORY_ENTRY_BOUND_IMPORT   = 11;
  IMAGE_DIRECTORY_ENTRY_DELAY_IMPORT   = 13;

type
  PIMAGE_IMPORT_BY_NAME = ^IMAGE_IMPORT_BY_NAME;
  {$EXTERNALSYM PIMAGE_IMPORT_BY_NAME}
  _IMAGE_IMPORT_BY_NAME = record
    Hint: Word;
    Name: array [0..0] of Char;
  end;
  {$EXTERNALSYM _IMAGE_IMPORT_BY_NAME}
  IMAGE_IMPORT_BY_NAME = _IMAGE_IMPORT_BY_NAME;
  {$EXTERNALSYM IMAGE_IMPORT_BY_NAME}
  TImageImportByName = IMAGE_IMPORT_BY_NAME;
  PImageImportByName = PIMAGE_IMPORT_BY_NAME;

  PIMAGE_THUNK_DATA32 = ^IMAGE_THUNK_DATA32;
  {$EXTERNALSYM PIMAGE_THUNK_DATA32}
  _IMAGE_THUNK_DATA32 = record
    case Integer of
      0: (ForwarderString: PBYTE);
      1: (Function_: PDWORD);
      2: (Ordinal: DWORD);
      3: (AddressOfData: PIMAGE_IMPORT_BY_NAME);
  end;
  {$EXTERNALSYM _IMAGE_THUNK_DATA32}
  IMAGE_THUNK_DATA32 = _IMAGE_THUNK_DATA32;
  {$EXTERNALSYM IMAGE_THUNK_DATA32}
  TImageThunkData32 = IMAGE_THUNK_DATA32;
  PImageThunkData32 = PIMAGE_THUNK_DATA32;

  TIIDUnion = record
    case Integer of
      0: (Characteristics: DWORD);
      1: (OriginalFirstThunk: PIMAGE_THUNK_DATA32);
  end;

  PIMAGE_IMPORT_DESCRIPTOR = ^IMAGE_IMPORT_DESCRIPTOR;
  {$EXTERNALSYM PIMAGE_IMPORT_DESCRIPTOR}
  _IMAGE_IMPORT_DESCRIPTOR = record
    Union: TIIDUnion;
    TimeDateStamp: DWORD;                  
    ForwarderChain: DWORD;
    Name: DWORD;
    FirstThunk: PIMAGE_THUNK_DATA32;         
  end;
  {$EXTERNALSYM _IMAGE_IMPORT_DESCRIPTOR}
  IMAGE_IMPORT_DESCRIPTOR = _IMAGE_IMPORT_DESCRIPTOR;
  {$EXTERNALSYM IMAGE_IMPORT_DESCRIPTOR}
  TImageImportDescriptor = IMAGE_IMPORT_DESCRIPTOR;
  PImageImportDescriptor = PIMAGE_IMPORT_DESCRIPTOR;

  {$EXTERNALSYM ImgDelayDescr}
  ImgDelayDescr = packed record
    grAttrs: DWORD;                 
    szName: DWORD;                  
    phmod: PDWORD;                  
    pIAT: TImageThunkData32;          
    pINT: TImageThunkData32;          
    pBoundIAT: TImageThunkData32;     
    pUnloadIAT: TImageThunkData32;    
    dwTimeStamp: DWORD;                                    
  end;
  TImgDelayDescr = ImgDelayDescr;
  PImgDelayDescr = ^ImgDelayDescr;

  PloadedImage = ^TLoadedImage;
  {$EXTERNALSYM _LOADED_IMAGE}
  _LOADED_IMAGE = record
    ModuleName: LPSTR;
    hFile: THandle;
    MappedAddress: PChar;
    FileHeader: PImageNtHeaders;
    LastRvaSection: PImageSectionHeader;
    NumberOfSections: ULONG;
    Sections: PImageSectionHeader;
    Characteristics: ULONG;
    fSystemImage: ByteBool;
    fDOSImage: ByteBool;
    Links: TListEntry;
    SizeOfImage: ULONG;
  end;
  {$EXTERNALSYM LOADED_IMAGE}
  LOADED_IMAGE = _LOADED_IMAGE;
  LoadedImage = _LOADED_IMAGE;
  TLoadedImage = _Loaded_IMAGE;

type
  TFWOrdinalData = record
    FuncName: ShortString;
    Ordinal: DWORD;
    Addr: String[10];
  end;
  TFWOrdinalDataArray = array of TFWOrdinalData;

var
  OrdinalData: TFWOrdinalDataArray;

function MapAndLoad(ImageName, DllPath: LPSTR; LoadedImage: PLoadedImage;
  DotDll, ReadOnly: Bool): Bool; stdcall; external 'Imagehlp.dll';

function UnMapAndLoad(LoadedImage: PLoadedImage): Bool; stdcall;
  external 'Imagehlp.dll';

function FieldOffset(const Struc; const Field): Cardinal;
begin
  Result := Cardinal(@Field) - Cardinal(@Struc);
end;

function IMAGE_FIRST_SECTION(NtHeader: PImageNtHeaders): PImageSectionHeader;
begin
  Result := PImageSectionHeader(Cardinal(NtHeader) +
    FieldOffset(NtHeader^, NtHeader^.OptionalHeader) +
    NtHeader^.FileHeader.SizeOfOptionalHeader);
end;

function ImageRvaToSection(NtHeaders: PImageNtHeaders; Base: Pointer;
  Rva: ULONG): PImageSectionHeader;
var
  NtSection: PImageSectionHeader;
  I: Integer;
begin
  Result := nil;
  NtSection := IMAGE_FIRST_SECTION(NtHeaders);
  for I := 0 to NtHeaders^.FileHeader.NumberOfSections - 1 do
    if (Rva >= NtSection.VirtualAddress) and
      (Rva < NtSection.VirtualAddress + NtSection.SizeOfRawData) then
    begin
      Result := NtSection;
      Exit;
    end
    else
      Inc(NtSection);
end;

function ImageRvaToVa(NtHeaders: PImageNtHeaders; Base: Pointer;
  Rva: ULONG; var LastRvaSection: PImageSectionHeader): Pointer;
var
  NtSection: PImageSectionHeader;
begin
  Result := nil;
  NtSection := LastRvaSection;
  if (LastRvaSection = nil) or (Rva < NtSection^.VirtualAddress) or
    (Rva < NtSection^.VirtualAddress + NtSection^.SizeOfRawData) then
    NtSection := ImageRvaToSection(NtHeaders, Base, Rva);
  if NtSection = nil then Exit;
  if LastRvaSection <> nil then
    LastRvaSection := NtSection;
  Result := Pointer(DWORD(Base) + (Rva - NtSection^.VirtualAddress) +
    NtSection^.PointerToRawData);
end;

function ImageDirectoryEntryToData(Base: Pointer; MappedAsImage: ByteBool;
  DirectoryEntry: Word; var Size: ULONG): Pointer;
const
  IMAGE_NT_OPTIONAL_HDR32_MAGIC = $10B;
  IMAGE_NT_OPTIONAL_HDR64_MAGIC = $20B;
  IMAGE_ROM_OPTIONAL_HDR_MAGIC  = $107;
var
  DOSHeader: PImageDosHeader;
  NTHeader: PImageNtHeaders;
  FileHeader: TImageFileHeader;
  NtSection: PImageSectionHeader;
  OptionalHeader: TImageOptionalHeader;
  DirectoryAddress: DWORD;
  I: Integer;
begin
  Result := nil;

  if (DWORD(Base) and 1) = 1 then
    Base := Pointer((DWORD(Base) and not 1));

  DOSHeader := PImageDosHeader(Base);
  if IsBadReadPtr(Pointer(Base), SizeOf(TImageNtHeaders)) then Exit;
  if (DOSHeader^.e_magic <> IMAGE_DOS_SIGNATURE) then Exit;
  NTHeader := PImageNtHeaders(DWORD(DOSHeader) + DWORD(DOSHeader^._lfanew));
  if NTHeader^.Signature <> IMAGE_NT_SIGNATURE then Exit;
  FileHeader := NTHeader^.FileHeader;
  if FileHeader.Machine <> IMAGE_FILE_MACHINE_I386 then Exit;
  OptionalHeader := NTHeader^.OptionalHeader;
  if OptionalHeader.Magic <> IMAGE_NT_OPTIONAL_HDR32_MAGIC then Exit;

  if DirectoryEntry >= OptionalHeader.NumberOfRvaAndSizes then
  begin
    Size := 0;
    Exit;
  end;

  DirectoryAddress :=
    OptionalHeader.DataDirectory[DirectoryEntry].VirtualAddress;
  if DirectoryAddress = 0 then
  begin
    Size := 0;
    Exit;
  end;

  Size := OptionalHeader.DataDirectory[DirectoryEntry].Size;
  if MappedAsImage and (DirectoryAddress < OptionalHeader.SizeOfHeaders) then
  begin
    Result := Pointer(DWORD(Base) + DirectoryAddress);
    Exit;
  end;

  NtSection := ImageRvaToSection(NTHeader, Base, DirectoryAddress);
  if NtSection = nil then
  begin
    Size := 0;
    Exit;
  end;

  for I := 0 to FileHeader.NumberOfSections - 1 do
    if (DirectoryAddress >= NtSection^.VirtualAddress) and
      (DirectoryAddress < NtSection^.VirtualAddress + NtSection^.SizeOfRawData) then
    begin
      Result := Pointer(DWORD(Base) +
        (DirectoryAddress - NtSection^.VirtualAddress) + NtSection^.PointerToRawData);
      Break;
    end
    else
      Inc(NtSection);
end;

procedure MapAndLoadModuleForReadOrdinalFuncName(const ModuleName: String);
type
  PDWORDArray = ^TDWORDArray;
  TDWORDArray = array [0..MaxInt div SizeOf(DWORD) - 1] of DWORD;
var
  liImageInfo: LoadedImage;
  pExportDirectory: PImageExportDirectory;
  nDirSize: Cardinal;
  pDummy: PImageSectionHeader;
  I: Cardinal;
  pNameRVAs: PDWORDArray;
  FuncName, FuncAddr: String;
  Ordinal: PWORD;
begin
  SetLength(OrdinalData, 0);
  if MapAndLoad(PChar(ModuleName), nil, @liImageInfo, True, True) then
  begin
    try
      pExportDirectory := ImageDirectoryEntryToData(liImageInfo.MappedAddress,
        False, IMAGE_DIRECTORY_ENTRY_EXPORT, nDirSize);
      if (pExportDirectory <> nil) then
      begin
        pDummy := nil;
        pNameRVAs := ImageRvaToVa(liImageInfo.FileHeader,
          liImageInfo.MappedAddress,
          DWORD(pExportDirectory^.AddressOfNames), pDummy);
        pDummy := nil;
        Ordinal := ImageRvaToVa(liImageInfo.FileHeader,
          liImageInfo.MappedAddress,
          DWORD(pExportDirectory^.AddressOfNameOrdinals), pDummy);
        
        for I := 0 to pExportDirectory^.NumberOfNames - 1 do
        begin
          SetLength(OrdinalData, Length(OrdinalData) + 1);
          
          pDummy := nil;
          FuncName := PChar(ImageRvaToVa(liImageInfo.FileHeader,
            liImageInfo.MappedAddress, pNameRVAs^[i], pDummy));
          FuncAddr := PChar('0x' + IntToHex(Integer(pNameRVAs^[I]), 8));
          
          OrdinalData[Length(OrdinalData) - 1].FuncName := FuncName;
          OrdinalData[Length(OrdinalData) - 1].Addr := FuncAddr;
          OrdinalData[Length(OrdinalData) - 1].Ordinal := Ordinal^ + pExportDirectory^.Base;
          Inc(Ordinal);
        end;
      end;
    finally
      UnMapAndLoad(@liImageInfo);
    end;
  end;
end;

function ReadOrdinalFuncName(const Ordinal: DWORD): String;
var
  I: Integer;
begin
  Result := '';
  for I := 0 to Length(OrdinalData) - 1 do
    if OrdinalData[I].Ordinal = Ordinal then
    begin
      Result := OrdinalData[I].FuncName;
      Break;
    end;
end;

function ReadOrdinalFuncAddr(const Ordinal: DWORD): String;
var
  I: Integer;
begin
  Result := '';
  for I := 0 to Length(OrdinalData) - 1 do
    if OrdinalData[I].Ordinal = Ordinal then
    begin
      Result := OrdinalData[I].Addr;
      Break;
    end;
end;

procedure GetImportTable(ss: TStrings; const PEFile: String);
var
  ImageInfo: LOADED_IMAGE;
  DirSize: Cardinal;
  pDummy: PImageSectionHeader;
  Image: PIMAGE_IMPORT_DESCRIPTOR;
  ModuleName: PChar;
  Thunk: PImageThunkData32;
begin
  ss.BeginUpdate;
  try
    if MapAndLoad(PChar(PEFile), nil, @ImageInfo, True, True) then
    begin
      try
        Image := ImageDirectoryEntryToData(ImageInfo.MappedAddress,
          False, IMAGE_DIRECTORY_ENTRY_IMPORT, DirSize);
        if (Image <> nil) then
        begin
          while Image^.Name <> 0 do
          begin
            pDummy := nil;

            ModuleName := ImageRvaToVa(ImageInfo.FileHeader,
              ImageInfo.MappedAddress, Image^.Name, pDummy);

            ss.Add(ModuleName);

            if Image^.Union.OriginalFirstThunk <> nil then

              Thunk := PImageThunkData32(ImageRvaToVa(ImageInfo.FileHeader,
                ImageInfo.MappedAddress, Image^.Union.Characteristics, pDummy))
            else
              Thunk := PImageThunkData32(ImageRvaToVa(ImageInfo.FileHeader,
                ImageInfo.MappedAddress, DWORD(Image^.FirstThunk), pDummy));

            if Thunk <> nil then
            try
              while Thunk^.Function_ <> nil do
              begin
                if (DWORD(Thunk^.Function_) and IMAGE_ORDINAL_FLAG) = IMAGE_ORDINAL_FLAG then
                begin
                  if Length(OrdinalData) = 0 then
                    MapAndLoadModuleForReadOrdinalFuncName(ModuleName);
                end;

                ss.Add(ModuleName);
                Inc(Thunk);
              end;
              Inc(Image);
            finally
              SetLength(OrdinalData, 0);
            end;
          end;
        end;
      finally
        UnMapAndLoad(@ImageInfo);
      end;
    end;
  finally
    ss.EndUpdate;
  end;
end;

procedure GetDelayImportTable(ss: TStrings; const PEFile: String);
var
  ImageInfo: LOADED_IMAGE;
  DirSize: Cardinal;
  Image: PImgDelayDescr;
  ModuleName: PChar;
  Thunk: PImageThunkData32;

  function RvaToVaWithAmendment(Value: DWORD): Pointer;
  var
    pDummy: PImageSectionHeader;
  begin
    if (Value > ImageInfo.SizeOfImage) and
      (Value > ImageInfo.FileHeader^.OptionalHeader.ImageBase) then
      Dec(Value, ImageInfo.FileHeader^.OptionalHeader.ImageBase);
    pDummy := nil;
    Result := ImageRvaToVa(ImageInfo.FileHeader, ImageInfo.MappedAddress,
      Value, pDummy);
  end;

begin
  ss.BeginUpdate;
  try
    if MapAndLoad(PChar(PEFile), nil, @ImageInfo, True, True) then
    begin
      try
        Image := ImageDirectoryEntryToData(ImageInfo.MappedAddress,
          False, IMAGE_DIRECTORY_ENTRY_DELAY_IMPORT, DirSize);
        if (Image <> nil) then
        begin
          while Image^.szName <> 0 do
          begin
            ModuleName := RvaToVaWithAmendment(DWORD(Image^.szName));

            ss.Add(ModuleName);
            Thunk := PImageThunkData32(RvaToVaWithAmendment(DWORD(Image^.pINT.AddressOfData)));
            if Thunk <> nil then
            try
              while Thunk^.Function_ <> nil do
              begin
                if (DWORD(Thunk^.Function_) and IMAGE_ORDINAL_FLAG) = IMAGE_ORDINAL_FLAG then
                begin
                  if Length(OrdinalData) = 0 then
                    MapAndLoadModuleForReadOrdinalFuncName(ModuleName);
                end;

                ss.Add(ModuleName);
                Inc(Thunk);
              end;
            Inc(Image);
            finally
              SetLength(OrdinalData, 0);
            end;
          end;
        end;
      finally
        UnMapAndLoad(@ImageInfo);
      end;
    end;
  finally
    ss.EndUpdate;
  end;
end;

procedure GetExportTable(ss: TStrings; const PEFile: String);
type
  PDWORDArray = ^TDWORDArray;
  TDWORDArray = array [0..MaxInt div SizeOf(DWORD) - 1] of DWORD;
var
  liImageInfo: LoadedImage;
  pExportDirectory: PImageExportDirectory;
  nDirSize: Cardinal;
  pDummy: PImageSectionHeader;
  I: Integer;
  pNameRVAs: PDWORDArray;
  FuncName, FuncAddr: String;
begin
  ss.BeginUpdate;
  try
    if MapAndLoad(PChar(PEFile), nil, @liImageInfo, True, True) then
    begin
      try
        pExportDirectory := ImageDirectoryEntryToData(liImageInfo.MappedAddress,
          False, IMAGE_DIRECTORY_ENTRY_EXPORT, nDirSize);
        if (pExportDirectory <> nil) then
        begin
          pDummy := nil;
          pNameRVAs := ImageRvaToVa(liImageInfo.FileHeader,
            liImageInfo.MappedAddress,
            DWORD(pExportDirectory^.AddressOfNames), pDummy);
          
          for I := 0 to pExportDirectory^.NumberOfNames - 1 do
          begin
            pDummy := nil;
            FuncName := PChar(ImageRvaToVa(liImageInfo.FileHeader,
              liImageInfo.MappedAddress, pNameRVAs^[i], pDummy));
            FuncAddr := PChar('0x' + IntToHex(Integer(pNameRVAs^[I]), 8));

            ss.Add(FuncName);
          end;
        end;
      finally
        UnMapAndLoad(@liImageInfo);
      end;
    end;
  finally
    ss.EndUpdate;
  end;
end;

end.

