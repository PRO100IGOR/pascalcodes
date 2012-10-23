{*******************************************************}
{                                                       }
{       TiOPCItem Component                             }
{                                                       }
{       Copyright (c) 1997,2002 Iocomp Software         }
{                                                       }
{*******************************************************}
{$I iInclude.inc}

{$ifdef iVCL}unit  iOPCItem;{$endif}
{$ifdef iCLX}unit QiOPCItem;{$endif}

interface

uses
  {$I iIncludeUses.inc}

  {$IFDEF iVCL} ActiveX, ComObj, iTypes, iGPFunctions, iOPCtypes, iOPCFunctions, iOPCClasses;{$ENDIF}

type

  TiOPCItem        = class;
  TiOPCItemManager = class;

  TOPCItemGetDataTypeEvent = procedure(PropertyName: String; var AVarType: TVarType) of object;

  TiOPCItem = class(TPersistent)
  private
    FPropertyName               : String;
    FServerName                 : String;
    FComputerName               : String;
    FItemName                   : String;
    FAutoConnect                : Boolean;
    FUpdateRate                 : Integer;

    FActive                     : Boolean;

    FServerIf                   : IOPCServer;

    FGroupIf                    : IOPCItemMgt;
    FGroupHandle                : Cardinal;

    FItemHandle                 : OPCHANDLE;
    FItemType                   : TVarType;

    FAdviseSink                 : TiOPCAdviseSink;
    FAdviseSinkConnection       : Longint;

    FOPCDataCallback            : TiOPCDataCallback;
    FOPCDataCallbackConnection  : Longint;

    FShutdownCallback           : TiOPCShutdownCallback;
    FShutdownCallbackConnection : Longint;

    FData                       : OleVariant;
    FTimeStamp                  : TDateTime;
    FQuality                    : Word;

    FOwner                      : TiOPCItemManager;
    FAutoError                  : Boolean;
  protected
    procedure SetPropertyName(const Value: String);
    procedure SetServerName  (const Value: String);
    procedure SetComputerName(const Value: String);
    procedure SetItemName    (const Value: String);
    procedure SetAutoConnect (const Value: Boolean);
    procedure SetUpdateRate  (const Value: Integer);
    procedure SetAutoError   (const Value: Boolean);

    procedure AdviseCallBack  (Sender: TObject);
    procedure AsyncDataChange (Sender: TObject);
    procedure ShutdownCallback(Sender: TObject);

    function GetQualityGood: Boolean;

    procedure SetData(const Value: OleVariant);

    procedure UpdateError;
  public
    constructor Create;
    destructor  Destroy;                    override;

    procedure Activate;
    procedure Deactivate;

    procedure UpdateResume;
    procedure UpdateSuspend;

    procedure Loaded;

    property Data             : OleVariant        read FData             write SetData;
    property TimeStamp        : TDateTime         read FTimeStamp;
    property Quality          : Word              read FQuality;
    property Active           : Boolean           read FActive;

    property QualityGood      : Boolean           read GetQualityGood;

    property Owner            : TiOPCItemManager  read FOwner            write FOwner;
  published
    property PropertyName     : String            read FPropertyName     write SetPropertyName;
    property ComputerName     : String            read FComputerName     write SetComputerName;
    property ServerName       : String            read FServerName       write SetServerName;
    property ItemName         : String            read FItemName         write SetItemName;
    property UpdateRate       : Integer           read FUpdateRate       write SetUpdateRate;

    property AutoConnect      : Boolean           read FAutoConnect      write SetAutoConnect;
    property AutoError        : Boolean           read FAutoError        write SetAutoError;
  end;

  TiOPCItemManager = class(TObject)
  private
    FList           : TStringList;
    FOnGetDesigning : TGetDesigningEvent;
    FOnNewData      : TNotifyEvent;
    FOnGetType      : TOPCItemGetDataTypeEvent;
    FOwner          : TComponent;
  protected
    function  GetCount: Integer;
    function  GetItem  (Index: Integer): TiOpcItem;
    function  GetDesigning: Boolean;
  public
    constructor Create;
    destructor  Destroy; override;

    function  DoWriteToStream : Boolean;
    procedure WriteToStream (Writer: TWriter);
    procedure ReadFromStream(Reader: TReader);

    function FindIndex(OPCItem: TiOPCItem): Integer;

    procedure Clear;
    procedure Delete(Index: Integer);
    function  Add: Integer;

    property  Items[Index: Integer]: TiOpcItem                read GetItem;
    property  Count                : Integer                  read GetCount;

    property IsDesigning           : Boolean                  read GetDesigning;

    property Owner                 : TComponent               read FOwner          write FOwner;

    property OnGetDesigning        : TGetDesigningEvent       read FOnGetDesigning write FOnGetDesigning;
    property OnNewData             : TNotifyEvent             read FOnNewData      write FOnNewData;
    property OnGetType             : TOPCItemGetDataTypeEvent read FOnGetType      write FOnGetType;
  end;

implementation

uses
  iVCLComponent;

type
  TWriterAccess        = class(TWriter)        end;
  TReaderAccess        = class(TReader)        end;
  TiVCLComponentAccess = class(TiVCLComponent) end;
//***********************************************************************************************************************************
constructor TiOPCItem.Create;
begin
  FUpdateRate   := 500;
  FAutoConnect  := True;
  FComputerName := 'Local';
  CoInitializeSecurity(nil, -1, nil, nil,iRPC_C_AUTHN_LEVEL_NONE, iRPC_C_IMP_LEVEL_IDENTIFY, nil, EOAC_NONE, nil);
end;
//***********************************************************************************************************************************
destructor TiOPCItem.Destroy;
begin
  try
    Deactivate;
  except
  end;
  inherited;
end;
//***********************************************************************************************************************************
procedure TiOPCItem.Loaded;
begin
  try
    if FAutoError then UpdateError;

    if FAutoConnect then
      begin
        try
          if not FOwner.IsDesigning then Activate;
        except
          on exception do;
        end;
      end;
  except
  end;
end;
//***********************************************************************************************************************************
procedure TiOPCItem.SetServerName(const Value: String);
begin
  FServerName := Value;
  if FActive then Activate;
end;
//***********************************************************************************************************************************
procedure TiOPCItem.SetComputerName(const Value: String);
begin
  FComputerName := Value;
  if FActive then Activate;
end;
//***********************************************************************************************************************************
procedure TiOPCItem.SetItemName(const Value: String);
begin
  FItemName := Value;
  if FActive then Activate;
end;
//***********************************************************************************************************************************
procedure TiOPCItem.SetUpdateRate(const Value: Integer);
begin
  FUpdateRate := Value;
  if FActive then Activate;
end;
//***********************************************************************************************************************************
procedure TiOPCItem.SetAutoConnect(const Value: Boolean);
begin
  FAutoConnect := Value;
  if FActive then Activate;
end;
//***********************************************************************************************************************************
procedure TiOPCItem.SetPropertyName(const Value: String);
begin
  FPropertyName := Value;
end;
//***********************************************************************************************************************************
procedure TiOPCItem.Activate;
var
  HR                : HResult;
  ActualMachineName : String;
  OPCServerList     : IOPCServerList;
  AVarType          : TVarType;
begin
  try
    if FAutoError         then UpdateError;
    if Assigned(FServerIf) then Deactivate;

//    if Trim(FPropertyName) = '' then Exit;
    if Trim(FServerName)   = '' then Exit;
    if Trim(FItemName)     = '' then Exit;

    FActive := True;

    ActualMachineName := Trim(FComputerName);
    if UpperCase(ActualMachineName) = 'LOCAL' then ActualMachineName := '';

    try
      if Trim(ActualMachineName) <> '' then
        begin
          FServerIf := CreateRemoteComObject(ActualMachineName, OPCGetRemoteCLSID(ActualMachineName, FServerName, OPCServerList)) as IOPCServer;
        end
      else
        FServerIf := CreateComObject(ProgIDToClassID(FServerName)) as IOPCServer;
    except
      on e : exception do
        begin
          raise Exception.Create('Exception : Failed to Connect to Server - ' + e.message);
          FServerIf := nil;
        end;
    end;

    if not Assigned(FServerIf) then raise Exception.Create('Failed to Connect to Server');

    FShutdownCallback := TiOPCShutdownCallback.Create;
    FShutdownCallback.OnChange := ShutdownCallback;
    OPCShutdownAdvise(FServerIf, FShutdownCallback, FShutdownCallbackConnection);

    HR := OPCServerAddGroup(FServerIf, '', True, FUpdateRate, FGroupIf, FGroupHandle);
    if not Succeeded(HR) then raise Exception.Create('Failed to Add Group');

    AVarType := VT_EMPTY;
//    if Assigned(FOwner.OnGetType) then FOwner.OnGetType(PropertyName, AVarType);

    HR := OPCGroupAddItem(FGroupIf, FItemName, 0, AVarType, FItemHandle, FItemType);
    if not Succeeded(HR) then raise Exception.Create('Failed to Add Item');

    //---------------------------------------------------
    FOPCDataCallback := TiOPCDataCallback.Create;
    FOPCDataCallback.OnDataChange2 := AsyncDataChange;
    OPCGroupAdvise2(FGroupIf, FOPCDataCallback, FOPCDataCallbackConnection);

    if FOPCDataCallbackConnection = 0 then
      begin
        FAdviseSink := TiOPCAdviseSink.Create;
        FAdviseSink.OnChange := AdviseCallBack;

        OPCGroupAdviseTime(FGroupIf, FAdviseSink, FAdviseSinkConnection);
      end;
  except
    Deactivate;
    raise;
  end;
end;
//***********************************************************************************************************************************
procedure TiOPCItem.Deactivate;
begin
  FActive := False;

  if FAdviseSinkConnection <> 0 then
    begin
      OPCGroupUnAdvise(FGroupIf, FAdviseSinkConnection);
      FAdviseSinkConnection := 0;
      FAdviseSink := nil;
    end;

  if FOPCDataCallbackConnection <> 0 then
    begin
      OPCGroupUnAdvise2(FGroupIf, FOPCDataCallbackConnection);
      FOPCDataCallbackConnection := 0;
      FOPCDataCallback := nil;
    end;

  if FItemHandle <> 0 then
    begin
      OPCGroupRemoveItem(FGroupIf, FItemHandle);
      FItemHandle := 0;
    end;

  if Assigned(FServerIf) then
    begin
      if FShutdownCallbackConnection <> 0 then
        begin
          OPCShutdownUnadvise(FServerIf, FShutdownCallbackConnection);
          FShutdownCallbackConnection := 0;
          FShutdownCallback := nil;
        end;

      if FGroupHandle <> 0 then
        begin
          FServerIf.RemoveGroup(FGroupHandle, False);
          FGroupIf     := nil;
          FGroupHandle := 0;
        end;
      FServerIf := nil;
    end;
  //----------------------------------------------------------------------------
end;
//***********************************************************************************************************************************
procedure TiOPCItem.AdviseCallBack(Sender: TObject);
begin
  if not FActive then Exit;

  FData      := FAdviseSink.Data;
  FQuality   := FAdviseSink.Quality;
  FTimeStamp := FAdviseSink.TimeStamp;

  if FAutoError                 then UpdateError;
  if Assigned(FOwner.OnNewData) then FOwner.OnNewData(Self);
end;
//***********************************************************************************************************************************
procedure TiOPCItem.AsyncDataChange(Sender: TObject);
begin
  if not FActive then Exit;

  FData      := FOPCDataCallback.Data;
  FQuality   := FOPCDataCallback.Quality;
  FTimeStamp := FOPCDataCallback.TimeStamp;

  if FAutoError                 then UpdateError;
  if Assigned(FOwner.OnNewData) then FOwner.OnNewData(Self);
end;
//***********************************************************************************************************************************
procedure TiOPCItem.ShutdownCallback(Sender: TObject);
begin
  if Assigned(FGroupIf) then
    begin
      if FAdviseSinkConnection <> 0 then
        begin
          OPCGroupUnAdvise(FGroupIf, FAdviseSinkConnection);
          FAdviseSinkConnection := 0;
          FAdviseSink := nil;
        end;

      if FOPCDataCallbackConnection <> 0 then
        begin
          OPCGroupUnAdvise2(FGroupIf, FOPCDataCallbackConnection);
          FOPCDataCallbackConnection := 0;
          FOPCDataCallback := nil;
        end;

      if FItemHandle <> 0 then
        begin
          OPCGroupRemoveItem(FGroupIf, FItemHandle);
          FItemHandle := 0;
        end;
    end;

  FAdviseSinkConnection       := 0;
  FOPCDataCallbackConnection  := 0;
  FItemHandle                 := 0;
  FGroupHandle                := 0;
  FShutdownCallbackConnection := 0;

  FAdviseSink       := nil;
  FOPCDataCallback  := nil;
  FShutdownCallback := nil;                 
  FGroupIf          := nil;
end;
//***********************************************************************************************************************************
procedure TiOPCItem.SetData(const Value: OleVariant);
var
  HR : LongInt;
begin
  if not FActive then Exit;
  if not Assigned(FServerIf) then raise Exception.Create('Data Write Failure - Not Connected to Server');
  if not Assigned(FGroupIf)  then raise Exception.Create('Data Write Failure - Not Connected to Group');
  if FItemHandle = 0         then raise Exception.Create('Data Write Failure - Not Connected to Item');

  HR := OPCWriteGroupItemValue(FGroupIf, FItemHandle, Value);
  if not Succeeded(HR) then raise Exception.Create('Data Write Failure');
end;
//***********************************************************************************************************************************
{ TiOPCItemManager }
//***********************************************************************************************************************************
constructor TiOPCItemManager.Create;
begin
  FList := TStringList.Create;
end;
//***********************************************************************************************************************************
destructor TiOPCItemManager.Destroy;
begin
  Clear;
  FList.Free;
  inherited;
end;
//***********************************************************************************************************************************
function TiOPCItemManager.Add: Integer;
var
  iOPCItem : TiOPCItem;
begin
  iOPCItem := TiOPCItem.Create;
  iOPCItem.Owner := Self;
  Result := FList.AddObject('',iOPCItem);
end;
//***********************************************************************************************************************************
procedure TiOPCItemManager.Clear;
begin
  while FList.Count > 0 do
    begin
      FList.Objects[0].Free;
      FList.Delete(0);
    end;
end;
//***********************************************************************************************************************************
procedure TiOPCItemManager.Delete(Index: Integer);
begin
  FList.Delete(Index);
end;
//***********************************************************************************************************************************
function TiOPCItemManager.GetCount: Integer;
begin
  Result := FList.Count;
end;
//***********************************************************************************************************************************
function TiOPCItemManager.GetItem(Index: Integer): TiOPCItem;
begin
  Result := FList.Objects[Index] as TiOPCItem;
end;
//***********************************************************************************************************************************
function TiOPCItemManager.FindIndex(OPCItem: TiOPCItem): Integer;
begin
  Result := FList.IndexOfObject(OPCItem);
end;
//***********************************************************************************************************************************
function TiOPCItemManager.DoWriteToStream: Boolean;
begin
  Result := Count > 0;
end;
//***********************************************************************************************************************************
procedure TiOPCItemManager.WriteToStream(Writer: TWriter);
var
  x : Integer;
begin
  TWriterAccess(Writer).WriteValue(vaCollection);
  for x := 0 to Count - 1 do
  begin
    Writer.WriteListBegin;
    WriterWriteProperties(Writer, GetItem(x));
    Writer.WriteListEnd;
  end;
  Writer.WriteListEnd;
end;
//***********************************************************************************************************************************
procedure TiOPCItemManager.ReadFromStream(Reader: TReader);
var
  Item : TiOPCItem;
begin
  Clear;
  if not Reader.EndOfList then Clear;
  if TReaderAccess(Reader).ReadValue <> vaCollection then exit;
  while not Reader.EndOfList do
  begin
    Item := TiOPCItem.Create;
    Item.Owner := Self;
    FList.AddObject('',Item);
    Reader.ReadListBegin;
    while not Reader.EndOfList do TReaderAccess(Reader).ReadProperty(Item);
    Reader.ReadListEnd;
    Item.Loaded;
  end;
  Reader.ReadListEnd; 
end;
//***********************************************************************************************************************************
function TiOPCItemManager.GetDesigning: Boolean;
begin
  Result := False;
  if Assigned(FOnGetDesigning) then FOnGetDesigning(Self, Result);
end;
//***********************************************************************************************************************************
procedure TiOPCItem.UpdateResume;
begin
  if not Assigned(FGroupIF) then raise Exception.Create('Group can not be Activated when group does not exists.');
  OPCServerSetGroupActive(FGroupIf, True);
end;
//***********************************************************************************************************************************
procedure TiOPCItem.UpdateSuspend;
begin
  if not Assigned(FGroupIF) then raise Exception.Create('Group can not be Deactivated when group does not exists.');
  OPCServerSetGroupActive(FGroupIf, False);
end;
//***********************************************************************************************************************************
procedure TiOPCItem.SetAutoError(const Value: Boolean);
begin
  if FAutoError <> Value then
    begin
      FAutoError := Value;
      if FAutoError then UpdateError;
    end;
end;
//***********************************************************************************************************************************
procedure TiOPCItem.UpdateError;
var
  VCLComponent : TiVCLComponent;
begin
  if not Active                    then                                                    Exit;
  if not Assigned(Owner)           then                                                    Exit;
  if not Assigned(Owner.Owner)     then                                                    Exit;
  if Owner.Owner is TiVCLComponent then VCLComponent := Owner.Owner as TiVCLComponent else Exit;

  if Active then
    begin
      if QualityGood then TiVCLComponentAccess(VCLComponent).ErrorActive := False
        else TiVCLComponentAccess(VCLComponent).ErrorActive := True;
    end;
end;
//***********************************************************************************************************************************
function TiOPCItem.GetQualityGood: Boolean;
begin
  Result := (FQuality and $C0) = $C0;
end;
//***********************************************************************************************************************************
end.
