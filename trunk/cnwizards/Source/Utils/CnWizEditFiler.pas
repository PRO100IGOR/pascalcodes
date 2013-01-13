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

{******************************************************************************}
{ Unit Note:                                                                   }
{    This file is partly derived from GExperts 1.2                             }
{                                                                              }
{ Original author:                                                             }
{    GExperts, Inc  http://www.gexperts.org/                                   }
{    Erik Berry <eberry@gexperts.org> or <eb@techie.com>                       }
{******************************************************************************}

unit CnWizEditFiler;
{* |<PRE>
================================================================================
* ������ƣ�CnPack IDE ר�Ұ�
* ��Ԫ���ƣ��༭���ļ���ȡ�൥Ԫ
* ��Ԫ���ߣ�CnPack ������
* ��    ע���õ�Ԫ�� GExperts 1.2 Src �� GX_EditReader ��ֲ����
*           ��ԭʼ������ GExperts License �ı���
* ����ƽ̨��PWin2000Pro + Delphi 5.01
* ���ݲ��ԣ�PWin9X/2000/XP + Delphi 5/6/7 + C++Builder 5/6
* �� �� �����õ�Ԫ�е��ַ��������ϱ��ػ�����ʽ
* ��Ԫ��ʶ��$Id: CnWizEditFiler.pas 985 2011-09-12 09:15:21Z liuxiaoshanzhashu@gmail.com $
* �޸ļ�¼��2003.06.17 V1.1
*               �޸��ļ���������д���ܣ�LiuXiao��
*           2003.03.02 V1.0
*               ������Ԫ����ֲ������By �ܾ���
================================================================================
|</PRE>}

interface

{$I CnWizards.inc}

uses
  SysUtils, Classes, Math, ToolsAPI, CnWizConsts;

type
  TModuleMode = (mmModule, mmFile);

  TCnEditFiler = class(TObject)
  private
    FSourceInterfaceAllocated: Boolean;
    FModuleNotifier: IOTAModuleNotifier;
    FEditIntf: IOTASourceEditor;
    FEditRead: IOTAEditReader;
    FEditWrite: IOTAEditWriter;
    FModIntf: IOTAModule;
    FNotifierIndex: Integer;

    Buf: Pointer;
    FBufSize: Integer;
    FFileName: string;
    FMode: TModuleMode;
    SFile: TStream;
    procedure AllocateFileData;
    function GetLineCount: Integer;
    procedure SetBufSize(New: Integer);
    procedure InternalGotoLine(Line: Integer; Offset: Boolean);
    function GetFileSize: Integer;
  protected
    procedure SetFileName(const Value: string);
    procedure ReleaseModuleNotifier;
  public
    constructor Create(const FileName: string);
    destructor Destroy; override;
    procedure FreeFileData;
    procedure Reset;
    procedure GotoLine(L: Integer);
    procedure GotoOffsetLine(L: Integer);
    procedure ShowSource;
    procedure ShowForm;
    procedure SaveToStream(Stream: TStream; CheckUtf8: Boolean = False);
    procedure SaveToStreamFromPos(Stream: TStream);
    procedure SaveToStreamToPos(Stream: TStream);
    // LiuXiao �������������������
    procedure ReadFromStream(Stream: TStream);
    procedure ReadFromStreamInPos(Stream: TStream);
    procedure ReadFromStreamInsertToPos(Stream: TStream);

    function GetCurrentBufferPos: Integer;
    property BufSize: Integer read FBufSize write SetBufSize;
    property FileName: string read FFileName write SetFileName;
    property LineCount: Integer read GetLineCount;
    property Mode: TModuleMode read FMode;
    property FileSize: Integer read GetFileSize;
  end;

procedure EditFilerSaveFileToStream(const FileName: string; Stream: TStream; CheckUtf8: Boolean = False);

implementation

uses
{$IFDEF Debug}
  CnDebug,
{$ENDIF Debug}
  CnWizUtils;

procedure EditFilerSaveFileToStream(const FileName: string; Stream: TStream; CheckUtf8: Boolean);
begin
  with TCnEditFiler.Create(FileName) do
  try
    SaveToStream(Stream, CheckUtf8);
  finally
    Free;
  end;
end;

type
  TModuleFreeNotifier = class(TNotifierObject, IOTAModuleNotifier)
  private
    FOwner: TCnEditFiler;
  public
    constructor Create(Owner: TCnEditFiler);
    destructor Destroy; override;
    procedure ModuleRenamed(const NewName: String);
    function CheckOverwrite: Boolean;
  end;

{ TModuleFreeNotifier }

function TModuleFreeNotifier.CheckOverwrite: Boolean;
begin
  Result := True;
end;

constructor TModuleFreeNotifier.Create(Owner: TCnEditFiler);
begin
  inherited Create;

  FOwner := Owner;
end;

destructor TModuleFreeNotifier.Destroy;
begin
  Assert(FOwner <> nil);
  FOwner.FreeFileData;
  FOwner.FModuleNotifier := nil;

  inherited Destroy;
end;

procedure TModuleFreeNotifier.ModuleRenamed(const NewName: String);
begin
  // We might want to handle this and change the stored file name
end;

resourcestring
  SNoEditReader = 'FEditRead: No Editor Reader Interface (You have found a bug!)';
  SNoEditWriter = 'FEditWrite: No Editor Writer Interface (You have found a bug!)';

constructor TCnEditFiler.Create(const FileName: string);
begin
  inherited Create;

  FBufSize := 32760; // Large buffers are faster, but too large causes crashes
  FNotifierIndex := InvalidNotifierIndex;
  FMode := mmModule;
  if FileName <> '' then
    SetFileName(FileName);
end;

// Use the FreeFileData to release the references
// to the internal editor buffer or the external
// file on disk in order not to block the file
// or track the editor (which may disappear) for
// possibly extended periods of time.
//
// Calls to edit reader will always (re-)allocate
// references again by calling the "AllocateFileData"
// method, so calling "FreeFileData" essentially comes
// for free, only reducing the length a reference
// is held to an entity.
procedure TCnEditFiler.FreeFileData;
begin
  FreeAndNil(SFile);
  FEditRead := nil;
  FEditWrite := nil;
  FEditIntf := nil;

  ReleaseModuleNotifier;
  FModIntf := nil;

  FSourceInterfaceAllocated := False;
end;

destructor TCnEditFiler.Destroy;
begin
  FreeFileData;

  if Buf <> nil then
    FreeMem(Buf);
  Buf := nil;
  FEditRead := nil;
  FEditWrite := nil;

  inherited Destroy;
end;

procedure TCnEditFiler.AllocateFileData;

  procedure AllocateFromDisk;
  begin
    if not FileExists(FFileName) then
      raise Exception.CreateFmt(SCnFileDoesNotExist, [FFileName]);

    FMode := mmFile;
    try
      SFile := TFileStream.Create(FFileName, fmOpenReadWrite or fmShareDenyWrite);
    except
      SFile := TFileStream.Create(FFileName, fmOpenRead);
    end;
  end;

begin
  if FSourceInterfaceAllocated then
    Exit;

  if BorlandIDEServices = nil then
  begin
    AllocateFromDisk;
    Exit;
  end;

  // Get module interface
  Assert(FModIntf = nil);
  FModIntf := CnOtaGetModule(FFileName);
  if FModIntf = nil  then
  begin
{$IFDEF DEBUG}
    CnDebugger.LogMsg('EditReader: Module not open in the IDE - opening from disk');
{$ENDIF}
    AllocateFromDisk;
  end
  else if CnOtaGetSourceEditorFromModule(FModIntf, FileName) = nil then
  begin
    // ������ View as Text ʱ���޷��õ�Դ��� SourceEditor �ӿ�
    AllocateFromDisk;
  end
  else
  begin
    FMode := mmModule;
{$IFDEF DEBUG}
    CnDebugger.LogMsg('EditReader: Got module for ' + FFileName);
{$ENDIF}

    // Allocate notifier for module
    Assert(FModuleNotifier = nil);
    FModuleNotifier := TModuleFreeNotifier.Create(Self);
{$IFDEF DEBUG}
    CnDebugger.LogMsg('EditReader: Got FModuleNotifier');
{$ENDIF}
    if FModuleNotifier = nil then
    begin
      FModIntf := nil;

      raise Exception.CreateFmt(SCnNoModuleNotifier, [FFileName]);
    end;
    FNotifierIndex := FModIntf.AddNotifier(FModuleNotifier);

    // Get Editor Interface
    Assert(FEditIntf = nil);

    FEditIntf := CnOtaGetSourceEditorFromModule(FModIntf, FFileName);
{$IFDEF DEBUG}
    CnDebugger.LogMsg('EditReader: Got FEditIntf for module');
{$ENDIF}
    if FEditIntf = nil then
    begin
      ReleaseModuleNotifier;
      FModIntf := nil;

      // Should we do this instead?
      //FreeFileData;

      // Sometimes causes "Instance of TEditClass has a dangling reference count of 3"
      // Happens in BCB5 when trying to focus a .h when the .dfm is being vewed as text
      // Maybe fixed in 1.0?
      raise Exception.CreateFmt(SCnNoEditorInterface, [FFileName]);
    end;

    // Get Reader interface }
    Assert((FEditRead = nil) and (FEditWrite = nil));
    FEditRead := FEditIntf.CreateReader;
    FEditWrite := FEditIntf.CreateUndoableWriter;
    if (FEditRead = nil) or (FEditWrite = nil) then
    begin
      ReleaseModuleNotifier;
      FModIntf := nil;
      FEditIntf := nil;
      if FEditRead = nil then
        raise Exception.Create(SNoEditReader);
      if FEditWrite = nil then
        raise Exception.Create(SNoEditWriter);
    end;
  end;

  FSourceInterfaceAllocated := True;
end;

procedure TCnEditFiler.SetFileName(const Value: string);
begin
  if SameText(Value, FFileName) then
    Exit;

  FreeFileData;

  // Assigning an empty string clears allocation.
  if Value = '' then
    Exit;

  FFileName := Value;
  Reset;
end;

procedure TCnEditFiler.SetBufSize(New: Integer);
begin
  if (Buf = nil) and (New <> FBufSize) then
    FBufSize := New;
  // 32K is the max we can read from an edit reader at once
  Assert(FBufSize <= 1024 * 32);
end;

procedure TCnEditFiler.ShowSource;
begin
  AllocateFileData;

  Assert(Assigned(FEditIntf));

  if FMode = mmModule then
    FEditIntf.Show;
end;

procedure TCnEditFiler.ShowForm;
begin
  AllocateFileData;
  Assert(Assigned(FModIntf));

  if FMode = mmModule then
    CnOtaShowFormForModule(FModIntf);
end;

procedure TCnEditFiler.GotoLine(L: Integer);
begin
  InternalGotoLine(L, False);
end;

procedure TCnEditFiler.GotoOffsetLine(L: Integer);
begin
  InternalGotoLine(L, True);
end;

procedure TCnEditFiler.InternalGotoLine(Line: Integer; Offset: Boolean);
var
  EditView: IOTAEditView;
  EditPos: TOTAEditPos;
  S: Integer;
  ViewCount: Integer;
begin
  AllocateFileData;

  //{$IFDEF Debug} CnDebugger.LogMsg('LineCount ' + IntToStr(LineCount)); {$ENDIF}
  if Line > LineCount then Exit;
  if Line < 1 then
    Line := 1;

  Assert(FModIntf <> nil);
  ShowSource;

  Assert(FEditIntf <> nil);
  ViewCount := FEditIntf.EditViewCount;
  if ViewCount < 1 then
    Exit;

  EditView := FEditIntf.EditViews[0];
  if EditView <> nil then
  begin
    EditPos.Col := 1;
    EditPos.Line := Line;
    if Offset then
    begin
      EditView.CursorPos := EditPos;
      S := Line - (EditView.ViewSize.cy div 2);
      if S < 1 then S := 1;
      EditPos.Line := S;
      EditView.TopPos := EditPos;
    end
    else
    begin
      EditView.TopPos := EditPos;
      EditView.CursorPos := EditPos;
      ShowSource;
    end;
    EditView.Paint;
  end;
end;

function TCnEditFiler.GetLineCount: Integer;
begin
  if FMode = mmModule then
  begin
    AllocateFileData;
    Assert(FEditIntf <> nil);

    Result := FEditIntf.GetLinesInBuffer;
  end
  else
    Result := -1;
end;

procedure TCnEditFiler.Reset;
begin
  if FMode = mmFile then
  begin
    // We do not need to allocate file data
    // in order to set the stream position
    if SFile <> nil then
      SFile.Position := 0;
  end;
end;

procedure TCnEditFiler.SaveToStream(Stream: TStream; CheckUtf8: Boolean);
var
  Pos: Integer;
  Size: Integer;
{$IFDEF IDE_WIDECONTROL}
  Text: AnsiString;
{$ENDIF}
const
  TheEnd: AnsiChar = AnsiChar(#0); // Leave typed constant as is - needed for streaming code
begin
  Assert(Stream <> nil);

  Reset;

  AllocateFileData;

  if Mode = mmFile then
  begin
    Assert(SFile <> nil);

    SFile.Position := 0;
    Stream.CopyFrom(SFile, SFile.Size);
    Stream.Write(TheEnd, 1);
  end
  else
  begin
    Pos := 0;
    if Buf = nil then
      GetMem(Buf, BufSize + 1);
    if FEditRead = nil then
      raise Exception.Create(SNoEditReader);
    // Delphi 5+ sometimes returns -1 here, for an unknown reason
    Size := FEditRead.GetText(Pos, Buf, BufSize);
    if Size = -1 then
    begin
      FreeFileData;
      AllocateFileData;
      Size := FEditRead.GetText(Pos, Buf, BufSize);
    end;
    if Size > 0 then
    begin
      Pos := Pos + Size;
      while Size = BufSize do
      begin
        Stream.Write(Buf^, Size);
        Size := FEditRead.GetText(Pos, Buf, BufSize);
        Pos := Pos + Size;
      end;
      Stream.Write(Buf^, Size);
    end;
    Stream.Write(TheEnd, 1);

{$IFDEF IDE_WIDECONTROL}
    if CheckUtf8 and (Stream is TMemoryStream) then
    begin
      Text := CnUtf8ToAnsi(PAnsiChar((Stream as TMemoryStream).Memory));
      Stream.Size := Length(Text) + 1;
      Stream.Position := 0;
      Stream.Write(PAnsiChar(Text)^, Length(Text) + 1);
    end;
{$ENDIF}
  end;
end;

function TCnEditFiler.GetCurrentBufferPos: Integer;
var
  EditorPos: TOTAEditPos;
  CharPos: TOTACharPos;
  EditView: IOTAEditView;
begin
  AllocateFileData;

  Assert(FEditIntf <> nil);

  Result := -1;
  Assert(FEditIntf.EditViewCount > 0);

  EditView := FEditIntf.EditViews[0];
  if EditView <> nil then
  begin
    EditorPos := EditView.CursorPos;
    EditView.ConvertPos(True, EditorPos, CharPos);
    Result := EditView.CharPosToPos(CharPos);
  end;
end;

procedure TCnEditFiler.SaveToStreamFromPos(Stream: TStream);
var
  Pos: Integer;
  Size: Integer;
begin
  AllocateFileData;

  Reset;

  if Mode = mmFile then
  begin
    Assert(SFile <> nil);
    SFile.Position := 0;
    Stream.CopyFrom(SFile, SFile.Size);
  end
  else
  begin
    Pos := GetCurrentBufferPos;
    if Buf = nil then
      GetMem(Buf, BufSize + 1);
    if FEditRead = nil then
      raise Exception.Create(SNoEditReader);
    Size := FEditRead.GetText(Pos, Buf, BufSize);
    if Size > 0 then
    begin
      Pos := Pos + Size;
      while Size = BufSize do
      begin
        Stream.Write(Buf^, Size);
        Size := FEditRead.GetText(Pos, Buf, BufSize);
        Pos := Pos + Size;
      end;
      Stream.Write(Buf^, Size);
    end;
  end;
end;

// The character at the current position is not written to the stream
procedure TCnEditFiler.SaveToStreamToPos(Stream: TStream);
var
  Pos, AfterPos: Integer;
  ToReadSize, Size: Integer;
  NullChar: char;
begin
  AllocateFileData;

  Reset;

  if Mode = mmFile then
  begin
    Assert(SFile <> nil);
    SFile.Position := 0;
    Stream.CopyFrom(SFile, SFile.Size);
  end
  else
  begin
    AfterPos := GetCurrentBufferPos;
    Pos := 0;
    if Buf = nil then
      GetMem(Buf, BufSize + 1);
    if FEditRead = nil then
      raise Exception.Create(SNoEditReader);

    ToReadSize := Min(BufSize, AfterPos - Pos);
    Size := FEditRead.GetText(Pos, Buf, ToReadSize);
    if Size > 0 then
    begin
      Pos := Pos + Size;
      while Size = BufSize do
      begin
        Stream.Write(Buf^, Size);
        ToReadSize := Min(BufSize, AfterPos - Pos);
        Size := FEditRead.GetText(Pos, Buf, ToReadSize);
        Pos := Pos + Size;
      end;
      Stream.Write(Buf^, Size);
    end;
  end;
  NullChar := #0;
  Stream.Write(NullChar, SizeOf(NullChar));
end;

procedure TCnEditFiler.ReleaseModuleNotifier;
begin
  if FNotifierIndex <> InvalidNotifierIndex then
    FModIntf.RemoveNotifier(FNotifierIndex);
  FNotifierIndex := InvalidNotifierIndex;
  FModuleNotifier := nil;
end;

// ��Stream����д���ļ��򻺳��У�����ԭ�����ݣ���Stream��Position�͹��λ���޹ء�
procedure TCnEditFiler.ReadFromStream(Stream: TStream);
var
  Size: Integer;
begin
  Assert(Stream <> nil);

  Reset;

  AllocateFileData;

  if Mode = mmFile then
  begin
    Assert(SFile <> nil);

    Stream.Position := 0;
    SFile.Size := 0;
    SFile.CopyFrom(Stream, Stream.Size);
  end
  else
  begin
    if FEditWrite = nil then
      raise Exception.Create(SNoEditWriter);

    FEditWrite.DeleteTo(MaxInt);
{    if Stream is TMemoryStream then
      FEditWrite.Insert(TMemoryStream(Stream).Memory)
    else
    begin }

    if Buf = nil then
      GetMem(Buf, BufSize + 1);

    if Stream.Size > 0 then
    begin
      Stream.Position := 0;
      repeat
        FillChar(Buf^, BufSize + 1, 0);
        Size := Stream.Read(Buf^, BufSize);
        FEditWrite.Insert(Buf);
      until Size <> BufSize;
    end;
  end;
end;

// �������ݸ��ǵ�ǰλ�õ��ı�
procedure TCnEditFiler.ReadFromStreamInPos(Stream: TStream);
var
  Size: Integer;
  CurrPos: Integer;
begin
  Assert(Stream <> nil);

  Reset;

  AllocateFileData;

  if Mode = mmFile then
  begin
    Assert(SFile <> nil);

    Stream.Position := 0;
    SFile.Size := 0;
    SFile.CopyFrom(Stream, Stream.Size);
  end
  else
  begin
    if FEditWrite = nil then
      raise Exception.Create(SNoEditWriter);

    CurrPos := CnOtaGetCurrPos;
    FEditWrite.CopyTo(CurrPos);

    FEditWrite.DeleteTo(CurrPos + Stream.Size);
    if Buf = nil then
      GetMem(Buf, BufSize + 1);

    if Stream.Size > 0 then
    begin
      Stream.Position := 0;
      repeat
        FillChar(Buf^, BufSize + 1, 0);
        Size := Stream.Read(Buf^, BufSize);
        FEditWrite.Insert(Buf);
      until Size <> BufSize;
    end;
  end;
end;

// �����ݲ��뵱ǰ�ı��ĵ�ǰλ�á�
procedure TCnEditFiler.ReadFromStreamInsertToPos(Stream: TStream);
var
  Size: Integer;
begin
  Assert(Stream <> nil);

  Reset;

  AllocateFileData;

  if Mode = mmFile then
  begin
    Assert(SFile <> nil);

    Stream.Position := 0;
    SFile.Size := 0;
    SFile.CopyFrom(Stream, Stream.Size);
  end
  else
  begin
    if FEditWrite = nil then
      raise Exception.Create(SNoEditWriter);

    FEditWrite.CopyTo(CnOtaGetCurrPos);
    if Buf = nil then
      GetMem(Buf, BufSize + 1);

    if Stream.Size > 0 then
    begin
      Stream.Position := 0;
      repeat
        FillChar(Buf^, BufSize + 1, 0);
        Size := Stream.Read(Buf^, BufSize);
        FEditWrite.Insert(Buf);
      until Size <> BufSize;
    end;
  end;
end;

function TCnEditFiler.GetFileSize: Integer;
var
  Size: Integer;
begin
  Reset;
  AllocateFileData;

  if Mode = mmFile then
  begin
    Assert(SFile <> nil);
    Result := SFile.Size;
  end
  else
  begin
    Result := 0;
    if Buf = nil then
      GetMem(Buf, BufSize + 1);

    if FEditRead = nil then
      raise Exception.Create(SNoEditReader);
    // Delphi 5+ sometimes returns -1 here, for an unknown reason
    Size := FEditRead.GetText(Result, Buf, BufSize);
    if Size = -1 then
    begin
      FreeFileData;
      AllocateFileData;
      Size := FEditRead.GetText(Result, Buf, BufSize);
    end;

    if Size > 0 then
    begin
      Inc(Result, Size);
      while Size = BufSize do
      begin
        Size := FEditRead.GetText(Result, Buf, BufSize);
        Inc(Result, Size);
      end;
    end;
  end;
end;

end.



