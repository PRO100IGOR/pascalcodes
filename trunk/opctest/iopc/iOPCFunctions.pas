
{$I iInclude.inc}

{$ifdef iVCL}unit  iOPCFunctions;{$endif}
{$ifdef iCLX}unit QiOPCFunctions;{$endif}

interface

uses
  {$I iIncludeUses.inc}
  {$IFDEF iVCL}ActiveX, ComObj,  iOPCTypes;{$ENDIF}
  {$IFDEF iCLX}               , QiOPCTypes;{$ENDIF}


function OPCServerAddGroup      (ServerIf: IOPCServer; Name: String; Active: BOOL; UpdateRate: DWORD; var GroupIf: IOPCItemMgt; var GroupHandle: OPCHANDLE): HResult;

function OPCServerSetGroupActive(GroupIf: IOPCItemMgt; NewActive: LongBool): HResult;

function OPCGroupAddItem        (GroupIf: IOPCItemMgt; ItemID: String; ClientHandle: OPCHANDLE; DataType: TVarType; var ItemHandle: OPCHANDLE; var CanonicalType: TVarType): HResult;
function OPCGroupRemoveItem     (GroupIf: IOPCItemMgt;                                                                  ItemHandle: OPCHANDLE                             ): HResult;

function OPCGroupAdviseTime     (GroupIf: IUnknown; Sink: IAdviseSink;                 var AsyncConnection: Longint): HResult;
function OPCGroupUnAdvise       (GroupIf: IUnknown;                                        AsyncConnection: Longint): HResult;

function OPCGroupAdvise2        (GroupIf: IUnknown; OPCDataCallback: IOPCDataCallback; var AsyncConnection: Longint): HResult;
function OPCGroupUnadvise2      (GroupIf: IUnknown;                                    var AsyncConnection: Longint): HResult;

function OPCShutdownAdvise(ServerIf: IUnknown; ShutDownCallback: IOPCShutdown; var AsyncConnection: Longint): HResult;
function OPCShutdownUnadvise(ServerIf: IUnknown; var AsyncConnection: Longint): HResult;

function OPCReadGroupItemValue (GroupIf: IUnknown; ItemServerHandle: OPCHANDLE; var ItemValue: string; var ItemQuality: Word): HResult;
function OPCWriteGroupItemValue(GroupIf: IUnknown; ItemServerHandle: OPCHANDLE;     ItemValue: OleVariant): HResult;

function OPCGetRemoteCLSID(MachineName: String; ProgID: String; var OPCServerList: IOPCServerList):TCLSID;

function OPCSetItemActiveState(GroupIf: IOPCItemMgt; ItemHandle: OPCHANDLE; State: Boolean): HResult;

function OPCCreateServerList(MachineName: String): IOPCServerList;
function OPCCreateBrowser   (MachineName, OPCServerName: String; var OPCServerList: IOPCServerList): IOPCBrowseServerAddressSpace;

implementation
//***********************************************************************************************************************************
function OPCServerAddGroup(ServerIf: IOPCServer; Name: String; Active: BOOL; UpdateRate: DWORD; var GroupIf: IOPCItemMgt; var GroupHandle: OPCHANDLE): HResult;
var
  PercentDeadBand   : Single;
  RevisedUpdateRate : DWORD;
begin
  GroupHandle := 0;
  GroupIf     := nil;
  Result      := E_FAIL;

  if not Assigned(ServerIf) then exit;

  PercentDeadBand := 0.0;
  Result := ServerIf.AddGroup(PWideChar(WideString(Name)), Active, UpdateRate, 0, nil, @PercentDeadBand, 0, GroupHandle, RevisedUpdateRate, IOPCItemMgt, IUnknown(GroupIf));

  if Failed(Result) then GroupIf := nil;
end;
//***********************************************************************************************************************************
function OPCServerSetGroupActive(GroupIf: IOPCItemMgt; NewActive: LongBool): HResult;
var
  GroupStateMgt     : IOPCGroupStateMgt;
  RevisedUpdateRate : Cardinal;
begin
  GroupStateMgt := GroupIf as IOPCGroupStateMgt;
  Result := GroupStateMgt.SetState(nil, RevisedUpdateRate, @NewActive, nil, nil, nil, nil);
end;
//***********************************************************************************************************************************
function OPCGroupAddItem(GroupIf: IOPCItemMgt; ItemID: String; ClientHandle: OPCHANDLE; DataType: TVarType;  var ItemHandle: OPCHANDLE; var CanonicalType: TVarType): HResult;
var
  ItemDef : OPCITEMDEF;
  Results : POPCITEMRESULTARRAY;
  Errors  : PResultList;
begin
  Result       := E_FAIL;
  ItemHandle := 0;

  if not Assigned(GroupIf) then Exit;

  with ItemDef do
    begin
      szAccessPath := '';
      szItemID            := PWideChar(WideString(ItemID));
      bActive             := True;
      hClient             := ClientHandle;
      dwBlobSize          := 0;
      pBlob               := nil;
      vtRequestedDataType := DataType;
    end;
  Result := GroupIf.AddItems(1, @ItemDef, Results, Errors);

  if Succeeded(Result) then
    begin
      Result := Errors[0];
      try
        if Succeeded(Result) then
        begin
          ItemHandle    := Results[0].hServer;
          CanonicalType := Results[0].vtCanonicalDataType;
        end;
      finally
        CoTaskMemFree(Results[0].pBlob);
        CoTaskMemFree(Results);
        CoTaskMemFree(Errors);
      end;
    end;
end;
//***********************************************************************************************************************************
function OPCGroupRemoveItem(GroupIf: IOPCItemMgt; ItemHandle: OPCHANDLE): HResult;
var
  Errors : PResultList;
begin
  if GroupIf = nil then
    begin
      Result := E_FAIL;
      Exit;
    end;

  Result := GroupIf.RemoveItems(1, @ItemHandle, Errors);
  if Succeeded(Result) then
    begin
      Result := Errors[0];
      CoTaskMemFree(Errors);
    end;
end;
//***********************************************************************************************************************************
function OPCGroupAdviseTime(GroupIf: IUnknown; Sink: IAdviseSink; var AsyncConnection: Longint): HResult;
var
  DataIf    : IDataObject;
  FormatEtc : TFormatEtc;
begin
  Result          := E_FAIL;
  AsyncConnection := 0;

  GroupIf.QueryInterface(IDataObject, DataIf);
  if not Assigned(DataIf) then Exit;

  with FormatEtc do
    begin
      cfFormat := OPCSTMFORMATDATATIME;
      dwAspect := DVASPECT_CONTENT;
      ptd      := nil;
      tymed    := TYMED_HGLOBAL;
      lindex   := -1;
    end;
  Result := DataIf.DAdvise(FormatEtc, ADVF_PRIMEFIRST, Sink, AsyncConnection);
  if Failed(Result) then AsyncConnection := 0;
end;
//***********************************************************************************************************************************
function OPCGroupUnAdvise(GroupIf: IUnknown; AsyncConnection: Longint): HResult;
var
  DataIf : IDataObject;
begin
  Result := E_FAIL;
  GroupIf.QueryInterface(IDataObject, DataIf);
  if Assigned(DataIf) then Result := DataIf.DUnadvise(AsyncConnection);
end;
//***********************************************************************************************************************************
function OPCGroupAdvise2(GroupIf: IUnknown; OPCDataCallback: IOPCDataCallback; var AsyncConnection: Longint): HResult;
var
  ConnectionPointContainer : IConnectionPointContainer;
  ConnectionPoint          : IConnectionPoint;
begin
  Result := E_FAIL;
  GroupIf.QueryInterface(IConnectionPointContainer, ConnectionPointContainer);

  if Assigned(ConnectionPointContainer) then
    begin
      Result := ConnectionPointContainer.FindConnectionPoint(IID_IOPCDataCallback, ConnectionPoint);
      if Succeeded(Result) and (ConnectionPoint <> nil) then Result := ConnectionPoint.Advise(OPCDataCallback as IUnknown, AsyncConnection);
    end;
end;
//***********************************************************************************************************************************
function OPCGroupUnadvise2(GroupIf: IUnknown; var AsyncConnection: Longint): HResult;
var
  ConnectionPointContainer : IConnectionPointContainer;
  ConnectionPoint          : IConnectionPoint;
begin
  Result := E_FAIL;
  GroupIf.QueryInterface(IConnectionPointContainer, ConnectionPointContainer);

  if Assigned(ConnectionPointContainer) then
    begin
      Result := ConnectionPointContainer.FindConnectionPoint(IID_IOPCDataCallback, ConnectionPoint);
      if Succeeded(Result) and (ConnectionPoint <> nil) then Result := ConnectionPoint.Unadvise(AsyncConnection);
    end;
end;
//***********************************************************************************************************************************
function OPCShutdownAdvise(ServerIf: IUnknown; ShutDownCallback: IOPCShutdown; var AsyncConnection: Longint): HResult;
var
  ConnectionPointContainer : IConnectionPointContainer;
  ConnectionPoint          : IConnectionPoint;
begin
  Result := E_FAIL;
  ServerIf.QueryInterface(IConnectionPointContainer, ConnectionPointContainer);

  if Assigned(ConnectionPointContainer) then
    begin
      Result := ConnectionPointContainer.FindConnectionPoint(IID_IOPCShutdown, ConnectionPoint);
      if Succeeded(Result) and (ConnectionPoint <> nil) then Result := ConnectionPoint.Advise(ShutDownCallback as IUnknown, AsyncConnection);
    end;
end;
//***********************************************************************************************************************************
function OPCShutdownUnadvise(ServerIf: IUnknown; var AsyncConnection: Longint): HResult;
var
  ConnectionPointContainer : IConnectionPointContainer;
  ConnectionPoint          : IConnectionPoint;
begin
  Result := E_FAIL;
  ServerIf.QueryInterface(IConnectionPointContainer, ConnectionPointContainer);

  if Assigned(ConnectionPointContainer) then
    begin
      Result := ConnectionPointContainer.FindConnectionPoint(IID_IOPCShutdown, ConnectionPoint);
      if Succeeded(Result) and (ConnectionPoint <> nil) then Result := ConnectionPoint.Unadvise(AsyncConnection);
    end;
end;
//***********************************************************************************************************************************
function OPCReadGroupItemValue(GroupIf: IUnknown; ItemServerHandle: OPCHANDLE; var ItemValue: string; var ItemQuality: Word): HResult;
var
  SyncIOIf   : IOPCSyncIO;
  Errors     : PResultList;
  ItemValues : POPCITEMSTATEARRAY;
begin
  Result := E_FAIL;
  try
    SyncIOIf := GroupIf as IOPCSyncIO;
  except
    SyncIOIf := nil;
  end;

  if SyncIOIf <> nil then
    begin
      Result := SyncIOIf.Read(OPC_DS_CACHE, 1, @ItemServerHandle, ItemValues, Errors);
      if Succeeded(Result) then
        begin
          Result := Errors[0];
          CoTaskMemFree(Errors);
          ItemValue := VarToStr(ItemValues[0].vDataValue);
          ItemQuality := ItemValues[0].wQuality;
          VariantClear(ItemValues[0].vDataValue);
          CoTaskMemFree(ItemValues);
        end;
    end;
end;
//***********************************************************************************************************************************
function OPCWriteGroupItemValue(GroupIf: IUnknown; ItemServerHandle: OPCHANDLE; ItemValue: OleVariant): HResult;
var
  SyncIOIf : IOPCSyncIO;
  Errors   : PResultList;
begin
  Result := E_FAIL;
  try
    SyncIOIf := GroupIf as IOPCSyncIO;
  except
    SyncIOIf := nil;
  end;

  if SyncIOIf <> nil then
    begin
      Result := SyncIOIf.Write(1, @ItemServerHandle, @ItemValue, Errors);
      if Succeeded(Result) then
        begin
          Result := Errors[0];
          CoTaskMemFree(Errors);
        end;
    end;
end;
//***********************************************************************************************************************************
function OPCGetRemoteCLSID(MachineName: String; ProgID: String; var OPCServerList: IOPCServerList):TCLSID;
var
  Enum               : IEnumGUID2;
  Guid               : TGuid;
  Fetched            : Cardinal;
  ProgIDString       : POleStr;
  ReadableNameString : POleStr;    
begin
  if Succeeded(CLSIDFromProgID(PWideChar(WideString(ProgID)), Result)) then Exit;//Look at locale first to speed up

  if not Assigned(OPCServerList) then OPCServerList := OPCCreateServerList(MachineName);
  if Succeeded(OPCServerList.CLSIDFromProgID(PWideChar(WideString(ProgID)), Result)) then
    begin
      if Result.D1 = 0 then Beep;
      Exit;
    end;

  OPCServerList.EnumClassesOfCategories(1, @CATID_OPCDAServer20, 0, nil, Enum);

  while Enum.Next(1, Guid, Fetched) = S_OK do
    begin
      OPCServerList.GetClassDetails(Guid, ProgIDString, ReadableNameString);
      if ProgIDString = ProgID then
        begin
          Result := Guid;
          Exit;
        end;
    end;

  OPCServerList.EnumClassesOfCategories(1, @CATID_OPCDAServer10, 0, nil, Enum);

  while Enum.Next(1, Guid, Fetched) = S_OK do
    begin
      OPCServerList.GetClassDetails(Guid, ProgIDString, ReadableNameString);
      if ProgIDString = ProgID then
        begin
          Result := Guid;
          Exit;
        end;
    end;

  raise Exception.Create('不能将 ProgID 变为 CLSID');
end;
//****************************************************************************************************************************************************
function GetActualMachineName(MachineName: String): String;
begin
  if Trim(UpperCase(MachineName)) = 'LOCAL' then Result := '' else Result := Trim(MachineName);
end;
//****************************************************************************************************************************************************
function OPCCreateServerList(MachineName: String): IOPCServerList;
var
  ActualMachineName : String;
begin
  ActualMachineName := GetActualMachineName(MachineName);

  try
    if ActualMachineName = '' then Result := CreateComObject(CLSID_OPCServerList) as IOPCServerList
      else                         Result := CreateRemoteComObject(ActualMachineName, CLSID_OPCServerList) as IOPCServerList;
  except
    on e: exception do raise Exception.Create('无法创建OPC对象 : ' + e.Message);
  end;

  if not Assigned(Result) then raise Exception.Create('无法创建OPC对象');
end;
//***********************************************************************************************************************************
function OPCCreateBrowser(MachineName, OPCServerName: String; var OPCServerList: IOPCServerList): IOPCBrowseServerAddressSpace;
var
  ActualMachineName : String;
  AGuid             : TCLSID;
begin
  ActualMachineName := GetActualMachineName(MachineName);

  try
    if ActualMachineName = '' then
      begin
        Result := CreateComObject(ProgIDToClassID(OPCServerName)) as IOPCBrowseServerAddressSpace;
      end
    else
      begin
        if not Assigned(OPCServerList) then OPCServerList := OPCCreateServerList(MachineName);
        AGuid := OPCGetRemoteCLSID(ActualMachineName, OPCServerName, OPCServerList);
        Result  := CreateRemoteComObject(ActualMachineName, AGuid) as IOPCBrowseServerAddressSpace;
      end;
  except
    Result := nil;
    raise;
  end;

  if not Assigned(Result) then raise Exception.Create('无法创建命名空间');
end;
//***********************************************************************************************************************************
function OPCSetItemActiveState(GroupIf: IOPCItemMgt; ItemHandle: OPCHANDLE; State: Boolean): HResult;
var
  Errors : PResultList;
begin
  Result := GroupIf.SetActiveState(1, @ItemHandle, State, Errors);
  if Succeeded(Result) then
    begin
      Result := Errors[0];
      CoTaskMemFree(Errors);
    end;
end;
//***********************************************************************************************************************************
end.
