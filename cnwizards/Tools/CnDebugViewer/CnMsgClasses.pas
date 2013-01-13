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

unit CnMsgClasses;
{ |<PRE>
================================================================================
* ������ƣ�CnDebugViewer
* ��Ԫ���ƣ���Ϣ�൥Ԫ
* ��Ԫ���ߣ���Х��LiuXiao�� liuxiao@cnpack.org
* ��    ע��Msgs �ȵ��б��� 0 ��ͷ���� VirtualTree �е� Node �� AbsoluteIndex
*           �� 1 ��ͷ��ʹ��ʱӦ��ע�� 
* ����ƽ̨��PWin2000Pro + Delphi 5.01
* ���ݲ��ԣ�PWin9X/2000/XP + Delphi 5/6/7
* �� �� �����õ�Ԫ�е��ַ���֧�ֱ��ػ�����ʽ
* ��Ԫ��ʶ��$Id: CnMsgClasses.pas 784 2011-04-07 05:03:53Z liuxiao@cnpack.org $
* �޸ļ�¼��2005.01.01
*               ������Ԫ��ʵ�ֹ���
================================================================================
|</PRE>}

interface

uses
  SysUtils, Classes, Windows, Messages, Contnrs, CnDebugIntf;

const
  WM_USER_UPDATE_STORE = WM_USER + $C;
  WM_USER_NEW_FORM     = WM_USER + $D;

type

  ICnMsgFiler = interface(IUnknown)
  {* ���������Ľӿ� }
    ['{10527F73-61EA-4171-8D71-13D85CB3CC62}']
    procedure LoadFromFile(Instance: TPersistent; const FileName: string);
    procedure SaveToFile(Instance: TPersistent; const FileName: string);
  end;

  TCnMsgItem = class(TPersistent)
  private
    FThreadId: DWORD;
    FProcessId: DWORD;
    FMsgTickCount: DWORD;
    FMsgCPUPeriod: Int64;
    FMsgCPInterval: Int64;
    FIndent: Integer;
    FLevel: Integer;
    FTag: string;
    FMsg: string;
    FMsgType: TCnMsgType;
    FTimeStampType: TCnTimeStampType;
    FMsgDateTime: TDateTime;
    FBookmarked: Boolean;
  published
    property Level: Integer read FLevel write FLevel;
    property Indent: Integer read FIndent write FIndent;
    property ProcessId: DWORD read FProcessId write FProcessId;
    property ThreadId: DWORD read FThreadId write FThreadId;
    property MsgCPInterval: Int64 read FMsgCPInterval write FMsgCPInterval;
    property Msg: string read FMsg write FMsg;
    property Tag: string read FTag write FTag;
    property MsgType: TCnMsgType read FMsgType write FMsgType;
    property TimeStampType: TCnTimeStampType read FTimeStampType write FTimeStampType;
    property MsgDateTime: TDateTime read FMsgDateTime write FMsgDateTime;
    property MsgTickCount: DWORD read FMsgTickCount write FMsgTickCount;
    property MsgCPUPeriod: Int64 read FMsgCPUPeriod write FMsgCPUPeriod;

    property Bookmarked: Boolean read FBookmarked write FBookmarked;
  end;

  TCnTimeItem = class(TPersistent)
  private
    FCPUPeriod: Int64;
    FTag: string;
    FMsg: string;
    FPassCount: Integer;
  published
    property Tag: string read FTag write FTag;
    property Msg: string read FMsg write FMsg;
    property CPUPeriod: Int64 read FCPUPeriod write FCPUPeriod;
    property PassCount: Integer read FPassCount write FPassCount;
  end;

  TCnStoreChangeType = (ctAdd, ctModify, ctDelete, ctProcess, ctTimeChanged);
  TCnMsgStoreChangeNotify = procedure (Sender: TObject;
    Operation: TCnStoreChangeType; StartIndex, EndIndex: Integer) of object;

  TCnMsgStore = class(TPersistent)
  private
    FProcessID: DWORD;
    FProcName: string;

    FOwner: TObject;
    FMsgs: TObjectList;
    FTimes: TObjectList;
    FForm: TObject;
    FUpdating: Boolean;
    FOnChange: TCnMsgStoreChangeNotify;
    FChanged: Boolean;
    FAddStart: Integer;
    FAddEnd: Integer;
    FTimeChangeIndex: Integer;

    function GetMsgs(Index: Integer): TCnMsgItem;
    function GetTimes(Index: Integer): TCnTimeItem;
    procedure SetProcessID(const Value: DWORD);
    procedure SetProcName(const Value: string);
    function GetMsgCount: Integer;
    function GetTimeCount: Integer;
    procedure SetUpdating(const Value: Boolean);
  public
    constructor Create(AOwner: TObject; AOwnsObjects: Boolean = True); virtual;
    destructor Destroy; override;

    procedure ClearMsgs;
    procedure ClearTimes;
    procedure DoMsgAdded; virtual;
    procedure DoChanged(Operation: TCnStoreChangeType); virtual;
    procedure DoTimeChanged(Operation: TCnStoreChangeType; Item: TObject); virtual;

    procedure AddMsgDesc(ADesc: PCnMsgDesc);
    procedure AddAMsgItem(AItem: TCnMsgItem);
    procedure AddATimeItem(AItem: TCnTimeItem);

    function AddTimeItem(const ATag: string): TCnTimeItem;
    function IndexOfTime(const ATag: string; var Index: Integer): TCnTimeItem;
    function UsToTime(const UsTime: Double): string;

    procedure BeginUpdate;
    procedure EndUpdate;

    procedure LoadFromFile(Filer: ICnMsgFiler; const FileName: string);
    procedure SaveToFile(Filer: ICnMsgFiler; const FileName: string);

    property ProcessID: DWORD read FProcessID write SetProcessID;
    property ProcName: string read FProcName write SetProcName;
    property Form: TObject read FForm write FForm;
    property Owner: TObject read FOwner write FOwner;
    property Msgs[Index: Integer]: TCnMsgItem read GetMsgs;
    property Times[Index: Integer]: TCnTimeItem read GetTimes;
    property MsgCount: Integer read GetMsgCount;
    property TimeCount: Integer read GetTimeCount;

    property Updating: Boolean read FUpdating write SetUpdating;
    property Changed: Boolean read FChanged;
    property OnChange: TCnMsgStoreChangeNotify read FOnChange write FOnChange;
  end;

  TCnMsgManager = class(TObject)
  private
    FStores: TObjectList;
    function GetStore(Index: Integer): TCnMsgStore;
    function GetCount: Integer;
  public
    constructor Create; virtual;
    destructor Destroy; override;
    function AddStore(AProcessID: DWORD; const AProcName: string): TCnMsgStore;
    function IndexOf(AProcessID: DWORD): TCnMsgStore;
    function IndexOfStore(AStore: TCnMsgStore): Integer;
    procedure RemoveStore(AStore: TCnMsgStore);

    procedure ClearStores;
    property Store[Index: Integer]: TCnMsgStore read GetStore;
    property Count: Integer read GetCount;
  end;

  TCnFilterConditions = class;

  TCnDisplayFilter = class(TObject)
  private
    FThreadId: DWORD;
    FProcessId: DWORD;
    FIndent: Integer;
    FLevel: Integer;
    FTag: string;
    FMsgTypes: TCnMsgTypes;
    FFiltered: Boolean;
    FConditions: TCnFilterConditions;

    procedure SetIndent(const Value: Integer);
    procedure SetLevel(const Value: Integer);
    procedure SetMsgTypes(const Value: TCnMsgTypes);
    procedure SetProcessId(const Value: DWORD);
    procedure SetTag(const Value: string);
    procedure SetThreadId(const Value: DWORD);
  protected
    procedure UpdateFiltered;
  public
    constructor Create;
    destructor Destroy; override;
    function CheckVisible(AItem: TCnMsgItem): Boolean;

    property Level: Integer read FLevel write SetLevel;
    property Indent: Integer read FIndent write SetIndent;
    property ProcessId: DWORD read FProcessId write SetProcessId;
    property ThreadId: DWORD read FThreadId write SetThreadId;
    property Tag: string read FTag write SetTag;
    property MsgTypes: TCnMsgTypes read FMsgTypes write SetMsgTypes;

    property Filtered: Boolean read FFiltered;
    property Conditions: TCnFilterConditions read FConditions;
  end;

  TCnFilterConditions = class(TObject)
  private
    FThreadIDs: TList;
    FTags: TStrings;
  public
    constructor Create;
    destructor Destroy; override;

    function IndexOfThreadID(AID: DWORD): Integer;
    function IndexOfTag(const ATag: string): Integer;

    function CheckAndAddThreadID(AID: DWORD): Boolean;
    function CheckAndAddTag(const ATag: string): Boolean;

    property ThreadIDs: TList read FThreadIDs;
    property Tags: TStrings read FTags;
  end;

function CnMsgManager: TCnMsgManager;

procedure AssignMsgDescToMsgItem(ADesc: PCnMsgDesc; AItem: TCnMsgItem);

function GetTimeDesc(AMsgItem: TCnMsgItem): string;

implementation

uses
  CnViewCore;

var
  FCnMsgManager: TCnMsgManager = nil;

function CnMsgManager: TCnMsgManager;
begin
  if FCnMsgManager = nil then
    FCnMsgManager := TCnMsgManager.Create;
  Result := FCnMsgManager;
end;

procedure AssignMsgDescToMsgItem(ADesc: PCnMsgDesc; AItem: TCnMsgItem);
var
  ATag: array[0..CnMaxTagLength] of Char;
  AMsg: array [0..CnMaxMsgLength] of Char;
  Size: Integer;

  function HexValueHigh(AChar: Char): Char;
  var
    AByte: Byte;
  begin
    AByte := Ord(AChar) shr 4;
    if AByte in [0..9] then
      Inc(AByte, Ord('0'))
    else
      Inc(AByte, Ord('A') - 10);
    Result := Chr(AByte);
  end;

  function HexValueLow(AChar: Char): Char;
  var
    AByte: Byte;
  begin
    AByte := Ord(AChar) and $F;
    if AByte in [0..9] then
      Inc(AByte, Ord('0'))
    else
      Inc(AByte, Ord('A') - 10);
    Result := Chr(AByte);
  end;

{
ʮ�����������ʽ��
00 11 22 33 44 55 66 77 88 99 AA BB CC DD EE FF ; 01234567890ABCDEF
��Size���ֽڣ�����Ϊ(Size div 16) + 1��һ�����ַ�Ϊ3 * 16 + 2 + 16 + 2
���һ��ΪSize mod 16���������0ʱ�� һ�����ַ�Ϊ3 * 16 + 2 + (Size mod 16)
��β���ÿո���䣬�����ֽ�����Ϊ ((Size div 16) + 1 ) * ( 3 * 16 + 2 + 16 + 2 )
}
  function HexDumpMemory(AMem: Pointer; Size: Integer): string;
  var
    I, J, DestP, PrevLineStart: Integer;
    AChar: Char;
  begin
    if (Size <= 0) or (AMem = nil) then
    begin
      Result := '';
      Exit;
    end;

    SetLength(Result, ((Size div 16) + 1 ) * ( 3 * 16 + 2 + 16 + 2 ));
    FillChar(Result[1], Length(Result), 0);

    DestP := 0; PrevLineStart := 0;
    for I := 0 to Size - 1 do
    begin
      AChar := (PChar(Integer(AMem) + I))^;
      Inc(DestP);
      Result[DestP] := HexValueHigh(AChar);
      Inc(DestP);
      Result[DestP] := HexValueLow(AChar);
      if I < Size then
      begin
        Inc(DestP);
        if (I > 0) and ((I + 1) mod 16 = 0) then
        begin
          // DONE: �������ַ��ټӻس�
          Result[DestP] := ' '; // �ӿո�ָ�
          Inc(DestP);
          Result[DestP] := ';'; // �ӷֺŷָ�
          Inc(DestP);
          Result[DestP] := ' '; // �ӿո�ָ�
          Inc(DestP);

          for J := PrevLineStart to I do
          begin
            AChar := (PChar(Integer(AMem) + J))^;
            if AChar in [#32..#127] then
              Result[DestP] := AChar
            else
              Result[DestP] := '.'; // ������ʾ�ַ�
            Inc(DestP);
          end;
          PrevLineStart := I + 1;

          Result[DestP] := #$D;
          Inc(DestP);
          Result[DestP] := #$A; // �ӻس��ָ�
        end
        else
        begin
          Result[DestP] := ' '; // �ӿո�ָ�
        end;
      end;
    end;

    if (Size mod 16) > 0 then
    begin
      // DONE: ����ĩ��δ�������
      Result[DestP] := ' '; // �ӿո�ָ�
      Inc(DestP);
      Result[DestP] := ';'; // �ӷֺŷָ�
      Inc(DestP);
      Result[DestP] := ' '; // �ӿո�ָ�
      Inc(DestP);

      for J := PrevLineStart to Size - 1 do
      begin
        AChar := (PChar(Integer(AMem) + J))^;
        if AChar in [#32..#127] then
          Result[DestP] := AChar
        else
          Result[DestP] := '.'; // ������ʾ�ַ�
        Inc(DestP);
      end;
    end;
  end;

begin
  if (ADesc <> nil) and (AItem <> nil) then
  begin
    AItem.ThreadId := ADesc^.Annex.ThreadId;
    AItem.ProcessId := ADesc^.Annex.ProcessId;

    AItem.MsgCPInterval := ADesc^.Annex.MsgCPInterval;
    AItem.Indent := ADesc^.Annex.Indent;
    AItem.Level := ADesc^.Annex.Level;

    if (LongInt(ADesc^.Annex.MsgType) >= Ord(Low(TCnMsgType))) and
      (LongInt(ADesc^.Annex.MsgType) <= Ord(High(TCnMsgType))) then
      AItem.MsgType := TCnMsgType(ADesc^.Annex.MsgType)
    else
      AItem.MsgType := cmtCustom;

    if (LongInt(ADesc^.Annex.TimeStampType) >= Ord(Low(TCnTimeStampType))) and
      (LongInt(ADesc^.Annex.TimeStampType) <= Ord(High(TCnTimeStampType))) then
      AItem.TimeStampType := TCnTimeStampType(ADesc^.Annex.TimeStampType)
    else
      AItem.TimeStampType := ttNone;

    case AItem.TimeStampType of
      ttDateTime:  AItem.MsgDateTime := ADesc^.Annex.MsgDateTime;
      ttTickCount: AItem.MsgTickCount := ADesc^.Annex.MsgTickCount;
      ttCPUPeriod: AItem.MsgCPUPeriod := ADesc^.Annex.MsgCPUPeriod;
    else
      AItem.MsgCPUPeriod := 0;
    end;

    FillChar(ATag, SizeOf(ATag), 0);
    CopyMemory(@ATag, @(ADesc^.Annex.Tag), CnMaxTagLength);
    AItem.Tag := ATag;

    FillChar(AMsg, SizeOf(AMsg), 0);
    Size := ADesc^.Length - SizeOf(ADesc^.Annex) - SizeOf(DWord);
    CopyMemory(@AMsg, @(ADesc^.Msg), Size);
    if AItem.MsgType = cmtMemoryDump then
      AItem.Msg := HexDumpMemory(@AMsg, Size)
    else
      AItem.Msg := AMsg;
  end;
end;

function GetTimeDesc(AMsgItem: TCnMsgItem): string;
begin
  case AMsgItem.TimeStampType of
    ttDateTime: Result := FormatDateTime(CnViewerOptions.DateTimeFormat,
      AMsgItem.MsgDateTime);
    ttTickCount: Result := IntToStr(AMsgItem.MsgTickCount);
    ttCPUPeriod: Result := IntToStr(AMsgItem.MsgCPUPeriod);
  else
    Result := '';
  end;
end;

{ TCnMsgStore }

procedure TCnMsgStore.AddAMsgItem(AItem: TCnMsgItem);
begin
  FMsgs.Add(AItem);
  FChanged := True;
end;

procedure TCnMsgStore.AddATimeItem(AItem: TCnTimeItem);
begin
  FTimes.Add(AItem);
  FChanged := True;
end;

procedure TCnMsgStore.AddMsgDesc(ADesc: PCnMsgDesc);
var
  AMsgItem: TCnMsgItem;
  ATimeItem: TCnTimeItem;
begin
  if ADesc <> nil then
  begin
    AMsgItem := TCnMsgItem.Create;
    AssignMsgDescToMsgItem(ADesc, AMsgItem);
    FMsgs.Add(AMsgItem);

    FChanged := True;
    // FAddStart �����һ����Ҫ���µĿ�ʼ��, FAddEnd �ǽ�����
    if FAddStart < 0 then
      FAddStart := FMsgs.Count - 1;
    FAddEnd := FMsgs.Count - 1;
    DoMsgAdded;

    if AMsgItem.MsgType = cmtTimeMarkStop then
    begin
      // ���� Tag ֵ��ɵĻ��½� TimeItem������������
      ATimeItem := IndexOfTime(AMsgItem.Tag, FTimeChangeIndex);
      if ATimeItem = nil then
      begin
        ATimeItem := AddTimeItem(AMsgItem.Tag);
        FTimeChangeIndex := FTimes.Count - 1;
      end;

      ATimeItem.PassCount := ATimeItem.PassCount + 1;
      ATimeItem.CPUPeriod := ATimeItem.CPUPeriod + AMsgItem.MsgCPInterval;
      ATimeItem.Msg := AMsgItem.Msg;
      DoChanged(ctTimeChanged);
    end;
  end;
end;

function TCnMsgStore.AddTimeItem(const ATag: string): TCnTimeItem;
var
  Item: TCnTimeItem;
begin
  Item := TCnTimeItem.Create;
  Item.Tag := ATag;
  FTimes.Add(Item);
  Result := Item;
end;

procedure TCnMsgStore.BeginUpdate;
begin
  Updating := True;
end;

procedure TCnMsgStore.DoChanged(Operation: TCnStoreChangeType);
begin
  if FChanged and ((not FUpdating) or (Operation in [ctProcess, ctTimeChanged])) then
  begin
    // Updating Ϊ True ��״̬�£���Ҫ���� FChanged �� True���� EndUpdate ʱ�ٴ�
    if not FUpdating then
      FChanged := False;

    if Assigned(FOnChange) then
    begin
      case Operation of
        ctAdd:
          begin
            FOnChange(Self, ctAdd, FAddStart, FAddEnd);
            FAddStart := -1;
            FAddEnd := -1;
          end;
        ctProcess:
          begin
            FOnChange(Self, ctProcess, -1, -1);
          end;
        ctTimeChanged:
          begin
            FOnChange(Self, ctTimeChanged, FTimeChangeIndex, FTimeChangeIndex);
          end;
        // ������δʵ��
      else
        ;
      end;
    end;
  end;
end;

procedure TCnMsgStore.ClearMsgs;
begin
  FMsgs.Clear;
end;

procedure TCnMsgStore.ClearTimes;
begin
  FTimes.Clear;
end;

constructor TCnMsgStore.Create(AOwner: TObject; AOwnsObjects: Boolean);
begin
  FOwner := AOwner;
  FMsgs := TObjectList.Create(AOwnsObjects);
  FTimes := TObjectList.Create(AOwnsObjects);
  FAddStart := -1;
  FAddEnd := -1;
  FTimeChangeIndex := -1;
end;

destructor TCnMsgStore.Destroy;
begin
  FTimes.Free;
  FMsgs.Free;
  inherited;
end;

procedure TCnMsgStore.EndUpdate;
begin
  Updating := False;
end;

function TCnMsgStore.GetMsgCount: Integer;
begin
  Result := FMsgs.Count;
end;

function TCnMsgStore.GetMsgs(Index: Integer): TCnMsgItem;
begin
  Result := nil;
  if (Index >= 0) and (Index < FMsgs.Count) then
    Result := TCnMsgItem(FMsgs[Index]);
end;

function TCnMsgStore.GetTimeCount: Integer;
begin
  Result := FTimes.Count;
end;

function TCnMsgStore.GetTimes(Index: Integer): TCnTimeItem;
begin
  Result := nil;
  if (Index >= 0) and (Index < FTimes.Count) then
    Result := TCnTimeItem(FTimes[Index]);
end;

function TCnMsgStore.IndexOfTime(const ATag: string; var Index: Integer): TCnTimeItem;
var
  I: Integer;
begin
  Result := nil; Index := -1;
  for I := 0 to FTimes.Count - 1 do
    if TCnTimeItem(FTimes[I]).Tag = ATag then
    begin
      Result := TCnTimeItem(FTimes[I]);
      Index := I;
      Exit;
    end;
end;

procedure TCnMsgStore.SetProcessID(const Value: DWORD);
begin
  if FProcessID <> Value then
  begin
    FProcessID := Value;
    FChanged := True;
    DoChanged(ctProcess);
  end;
end;

procedure TCnMsgStore.SetProcName(const Value: string);
begin
  if FProcName <> Value then
  begin
    FProcName := Value;
    FChanged := True;
    DoChanged(ctProcess);
  end;
end;

procedure TCnMsgStore.SetUpdating(const Value: Boolean);
begin
  if FUpdating <> Value then
  begin
    FUpdating := Value;
    if not FUpdating then
      DoChanged(ctAdd);
  end;
end;

procedure TCnMsgStore.DoMsgAdded;
begin
  DoChanged(ctAdd);
end;

procedure TCnMsgStore.DoTimeChanged(Operation: TCnStoreChangeType;
  Item: TObject);
begin
  DoChanged(ctTimeChanged);
end;

procedure TCnMsgStore.LoadFromFile(Filer: ICnMsgFiler; const FileName: string);
begin
  if Filer <> nil then
    Filer.LoadFromFile(Self, FileName);
end;

procedure TCnMsgStore.SaveToFile(Filer: ICnMsgFiler; const FileName: string);
begin
  if Filer <> nil then
    Filer.SaveToFile(Self, FileName);
end;

//Add Sesame 2008-1-22 ת��΢��ʱ��Ϊʱ�����ʽ
function TCnMsgStore.UsToTime(const UsTime: Double): string;
const 
  SF_DATE_INT = '%.2D:%.2D:%.2D.%.3D';
var
  iHH, iNN, iSS, iZZZ, iTime: Integer;
begin
  Result := '00:00:00.000';
  if UsTime < 0 then
    Exit;
  iTime := Round(UsTime / 1000);
  iZZZ := iTime mod 1000; iTime := iTime div 1000; 
  iSS := iTime mod 60; iTime := iTime div 60;
  iNN := iTime mod 60; iHH := iTime div 60;
  Result := Format(SF_DATE_INT, [iHH, iNN, iSS, iZZZ]);
end;

{ TCnMsgManager }

function TCnMsgManager.AddStore(AProcessID: DWORD;
  const AProcName: string): TCnMsgStore;
var
  AStore: TCnMsgStore;
begin
  Result := nil;
  if AProcName <> '' then
  begin
    AStore := TCnMsgStore.Create(Self);
    AStore.ProcessID := AProcessID;
    AStore.ProcName := AProcName;
    FStores.Add(AStore);
    Result := AStore;
  end;
end;

procedure TCnMsgManager.ClearStores;
begin
  FStores.Clear;
end;

constructor TCnMsgManager.Create;
begin
  FStores := TObjectList.Create(True);
end;

destructor TCnMsgManager.Destroy;
begin
  FStores.Free;
  inherited;
end;

function TCnMsgManager.GetCount: Integer;
begin
  Result := FStores.Count;
end;

function TCnMsgManager.GetStore(Index: Integer): TCnMsgStore;
begin
  Result := nil;
  if (Index >= 0) and (Index < FStores.Count) then
    Result := TCnMsgStore(FStores[Index]);
end;

function TCnMsgManager.IndexOf(AProcessID: DWORD): TCnMsgStore;
var
  I: Integer;
begin
  Result := nil;
  for I := 0 to FStores.Count - 1 do
    if TCnMsgStore(FStores[I]).ProcessID = AProcessID then
    begin
      Result := TCnMsgStore(FStores[I]);
      Exit;
    end;
end;

function TCnMsgManager.IndexOfStore(AStore: TCnMsgStore): Integer;
var
  I: Integer;
begin
  Result := -1;
  if AStore <> nil then
    for I := 0 to FStores.Count - 1 do
      if FStores[I] = AStore then
      begin
        Result := I;
        Exit;
      end;
end;

procedure TCnMsgManager.RemoveStore(AStore: TCnMsgStore);
begin
  FStores.Remove(AStore);
end;

{ TCnDisplayFilter }

function TCnDisplayFilter.CheckVisible(AItem: TCnMsgItem): Boolean;
begin
  Result := (AItem <> nil);
  if Result then
  begin
    // DONE: �жϸ� Item �Ƿ�Ӧ�ñ����˵�
    Result := (AItem.Level <= FLevel)
      and ((FMsgTypes = []) or (AItem.MsgType in FMsgTypes))
      and ((FThreadId = 0) or (AItem.ThreadId = FThreadId))
      and ((FTag = '') or (AItem.Tag = FTag))
      and ((FIndent = -1) or (AItem.Indent = FIndent))
      and ((FProcessId = 0) or (AItem.FProcessId = FProcessId));
  end;
end;

constructor TCnDisplayFilter.Create;
begin
  FLevel := CnDefLevel;
  FIndent := -1;
  FConditions := TCnFilterConditions.Create;
end;

destructor TCnDisplayFilter.Destroy;
begin
  FConditions.Free;
  inherited;
end;

procedure TCnDisplayFilter.SetIndent(const Value: Integer);
begin
  FIndent := Value;
  UpdateFiltered;
end;

procedure TCnDisplayFilter.SetLevel(const Value: Integer);
begin
  FLevel := Value;
  UpdateFiltered;
end;

procedure TCnDisplayFilter.SetMsgTypes(const Value: TCnMsgTypes);
begin
  FMsgTypes := Value;
  UpdateFiltered;
end;

procedure TCnDisplayFilter.SetProcessId(const Value: DWORD);
begin
  FProcessId := Value;
  UpdateFiltered;
end;

procedure TCnDisplayFilter.SetTag(const Value: string);
begin
  FTag := Value;
  UpdateFiltered;
end;

procedure TCnDisplayFilter.SetThreadId(const Value: DWORD);
begin
  FThreadId := Value;
  UpdateFiltered;
end;

procedure TCnDisplayFilter.UpdateFiltered;
begin
  FFiltered := (FLevel < CnDefLevel) or (FIndent >= 0) or (FThreadId > 0)
    or (FProcessId > 0) or (FTag <> '') or (FMsgTypes <> []);
end;

{ TCnFilterConditions }

function TCnFilterConditions.CheckAndAddTag(const ATag: string): Boolean;
begin
  Result := False;
  if IndexOfTag(ATag) < 0 then
  begin
    FTags.Add(ATag);
    Result := True;
  end;
end;

function TCnFilterConditions.CheckAndAddThreadID(AID: DWORD): Boolean;
begin
  Result := False;
  if IndexOfThreadID(AID) < 0 then
  begin
    FThreadIDs.Add(Pointer(AID));
    Result := True;
  end;
end;

constructor TCnFilterConditions.Create;
begin
  FThreadIDs := TList.Create;
  FTags := TStringList.Create;
  // �����������λ��
  FThreadIDs.Add(nil);
  FTags.Add('');
end;

destructor TCnFilterConditions.Destroy;
begin
  FTags.Free;
  FThreadIDs.Free;
  inherited;
end;

function TCnFilterConditions.IndexOfTag(const ATag: string): Integer;
begin
  Result := FTags.IndexOf(ATag);
end;

function TCnFilterConditions.IndexOfThreadID(AID: DWORD): Integer;
begin
  Result := FThreadIDs.IndexOf(Pointer(AID));
end;

initialization

finalization
  FreeAndNil(FCnMsgManager);

end.
