unit OPCutils;

{$IFDEF VER150}
{$WARN UNSAFE_CODE OFF}
{$WARN UNSAFE_TYPE OFF}
{$ENDIF}

interface

uses
{$IFDEF VER140}
  Variants,
{$ENDIF}
{$IFDEF VER150}
  Variants,
{$ENDIF}
  Windows,ActiveX,OPCDA,OPCtypes,SysUtils,Variants;

function ServerAddGroup(ServerIf: IOPCServer; Name: string; Active: BOOL;
          UpdateRate: DWORD; ClientHandle: OPCHANDLE; var GroupIf: IOPCItemMgt;
          var ServerHandle: OPCHANDLE): HResult;
function GroupAddItem(GroupIf: IOPCItemMgt; ItemID: string;
          ClientHandle: OPCHANDLE; DataType: TVarType;
          var ServerHandle: OPCHANDLE; var CanonicalType: TVarType): HResult;
function GroupRemoveItem(GroupIf: IOPCItemMgt;
          ServerHandle: OPCHANDLE): HResult;
function GroupAdviseTime(GroupIf: IUnknown; Sink: IAdviseSink;
          var AsyncConnection: Longint): HResult;
function GroupUnAdvise(GroupIf: IUnknown; AsyncConnection: Longint): HResult;
function GroupAdvise2(GroupIf: IUnknown; OPCDataCallback: IOPCDataCallback;
          var AsyncConnection: Longint): HResult;
function GroupUnadvise2(GroupIf: IUnknown;
          var AsyncConnection: Longint): HResult;
function ReadOPCGroupItemValue(GroupIf: IUnknown; ItemServerHandle: OPCHANDLE;
          var ItemValue: string; var ItemQuality: Word): HResult;
function WriteOPCGroupItemValue(GroupIf: IUnknown; ItemServerHandle: OPCHANDLE;
          ItemValue: OleVariant): HResult;
//异步读函数（内部封装IOPCAsyncIO2.read）
function ASReadOPCItemValue(dwCount:DWORD;GroupIf: IUnknown; ItemServerHandle: OPCHANDLE;
          dwTransactionID:DWORD): HResult;
//异步写函数（内部封装IOPCAsyncIO2.write）
function ASWriteOPCItemValue(dwCount:DWORD;GroupIf: IUnknown; ItemServerHandle: OPCHANDLE;
          ItemValue: OleVariant;dwTransactionID:DWORD): HResult;

implementation

// utility functions wrapping OPC methods



// wrapper for IOPCServer.AddGroup
function ServerAddGroup(ServerIf: IOPCServer; Name: string; Active: BOOL;
          UpdateRate: DWORD; ClientHandle: OPCHANDLE; var GroupIf: IOPCItemMgt;
          var ServerHandle: OPCHANDLE): HResult;
var
  PercentDeadBand: Single;
  RevisedUpdateRate: DWORD;
begin
  Result := E_FAIL;
  if ServerIf <> nil then
  begin
    PercentDeadBand := 0.0;
    Result := ServerIf.AddGroup(PWideChar(WideString(Name)), Active, UpdateRate,
                            ClientHandle, nil, @PercentDeadBand, 0,
                            ServerHandle, RevisedUpdateRate, IOPCItemMgt,
                            IUnknown(GroupIf));
  end;
  if Failed(Result) then
  begin
    GroupIf := nil;
  end;
end;

// wrapper for IOPCItemMgt.AddItems (single item only)
function GroupAddItem(GroupIf: IOPCItemMgt; ItemID: string;
          ClientHandle: OPCHANDLE; DataType: TVarType;
          var ServerHandle: OPCHANDLE; var CanonicalType: TVarType): HResult;
var
  ItemDef: OPCITEMDEF;
  Results: POPCITEMRESULTARRAY;
  Errors: PResultList;
begin
  if GroupIf = nil then
  begin
    Result := E_FAIL;
    Exit;
  end;
  with ItemDef do
  begin
    szAccessPath := '';
    szItemID := PWideChar(WideString(ItemID));
    bActive := True;
    hClient := ClientHandle;
    dwBlobSize := 0;
    pBlob := nil;
    vtRequestedDataType := DataType;
  end;
  Result := GroupIf.AddItems(1, @ItemDef, Results, Errors);
  if Succeeded(Result) then
  begin
    Result := Errors[0];
    try
      if Succeeded(Result) then
      begin
        ServerHandle := Results[0].hServer;
        CanonicalType := Results[0].vtCanonicalDataType;
      end;
    finally
      CoTaskMemFree(Results[0].pBlob);
      CoTaskMemFree(Results);
      CoTaskMemFree(Errors);
    end;
  end;
end;

// wrapper for IOPCItemMgt.RemoveItems (single item only)
function GroupRemoveItem(GroupIf: IOPCItemMgt;
          ServerHandle: OPCHANDLE): HResult;
var
  Errors: PResultList;
begin
  if GroupIf = nil then
  begin
    Result := E_FAIL;
    Exit;
  end;
  Result := GroupIf.RemoveItems(1, @ServerHandle, Errors);
  if Succeeded(Result) then
  begin
    Result := Errors[0];
    CoTaskMemFree(Errors);
  end;
end;

// wrapper for IDataObject.DAdvise on an OPC group object
function GroupAdviseTime(GroupIf: IUnknown; Sink: IAdviseSink;
          var AsyncConnection: Longint): HResult;
var
  DataIf: IDataObject;
  Fmt: TFormatEtc;
begin
  Result := E_FAIL;
  try
    DataIf := GroupIf as IDataObject;
  except
    DataIf := nil;
  end;
  if DataIf <> nil then
  begin
    with Fmt do
    begin
      cfFormat := OPCSTMFORMATDATATIME;
      dwAspect := DVASPECT_CONTENT;
      ptd := nil;
      tymed := TYMED_HGLOBAL;
      lindex := -1;
    end;
    AsyncConnection := 0;
    Result := DataIf.DAdvise(Fmt, ADVF_PRIMEFIRST, Sink, AsyncConnection);
    if Failed(Result) then
    begin
      AsyncConnection := 0;
    end;
  end;
end;

// wrapper for IDataObject.DUnadvise on an OPC group object
function GroupUnAdvise(GroupIf: IUnknown; AsyncConnection: Longint): HResult;
var
  DataIf: IDataObject;
begin
  Result := E_FAIL;
  try
    DataIf := GroupIf as IDataObject;
  except
    DataIf := nil;
  end;
  if DataIf <> nil then
  begin
    Result := DataIf.DUnadvise(AsyncConnection);
  end;
end;

// wrapper for setting up an IOPCDataCallback connection
function GroupAdvise2(GroupIf: IUnknown; OPCDataCallback: IOPCDataCallback;
          var AsyncConnection: Longint): HResult;
var
  ConnectionPointContainer: IConnectionPointContainer;
  ConnectionPoint: IConnectionPoint;
begin
  Result := E_FAIL;
  try
    ConnectionPointContainer := GroupIf as IConnectionPointContainer;
  except
    ConnectionPointContainer := nil;
  end;
  if ConnectionPointContainer <> nil then
  begin
    Result := ConnectionPointContainer.FindConnectionPoint(IID_IOPCDataCallback,
      ConnectionPoint);
    if Succeeded(Result) and (ConnectionPoint <> nil) then
    begin
      Result := ConnectionPoint.Advise(OPCDataCallback as IUnknown,
        AsyncConnection);
    end;
  end;
end;

// wrapper for cancelling up an IOPCDataCallback connection
function GroupUnadvise2(GroupIf: IUnknown;
          var AsyncConnection: Longint): HResult;
var
  ConnectionPointContainer: IConnectionPointContainer;
  ConnectionPoint: IConnectionPoint;
begin
  Result := E_FAIL;
  try
    ConnectionPointContainer := GroupIf as IConnectionPointContainer;
  except
    ConnectionPointContainer := nil;
  end;
  if ConnectionPointContainer <> nil then
  begin
    Result := ConnectionPointContainer.FindConnectionPoint(IID_IOPCDataCallback,
      ConnectionPoint);
    if Succeeded(Result) and (ConnectionPoint <> nil) then
    begin
      Result := ConnectionPoint.Unadvise(AsyncConnection);
    end;
  end;
end;

//同步读函数 wrapper for IOPCSyncIO.Read (single item only)
function ReadOPCGroupItemValue(GroupIf: IUnknown; ItemServerHandle: OPCHANDLE;
          var ItemValue: string; var ItemQuality: Word): HResult;
var
  SyncIOIf: IOPCSyncIO;
  Errors: PResultList;
  ItemValues: POPCITEMSTATEARRAY;
begin
  Result := E_FAIL;
  try
    SyncIOIf := GroupIf as IOPCSyncIO;
  except
    SyncIOIf := nil;
  end;
  if SyncIOIf <> nil then
  begin
    Result := SyncIOIf.Read(OPC_DS_CACHE, 1, @ItemServerHandle, ItemValues,
                            Errors);
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
//异步读调用函数,调用IOPCAsyncIO2.read（设定值为：访问项的个数；访问组句柄；访问项句柄；当前项回调标号）
function ASReadOPCItemValue(dwCount:DWORD;GroupIf: IUnknown; ItemServerHandle: OPCHANDLE;
          dwTransactionID:DWORD): HResult;
var
  ASyncIOIf: IOPCAsyncIO2;
  PRcancel:dword;
  Errors: PResultList;

begin
  Result := E_FAIL;
  try
    ASyncIOIf := GroupIf as IOPCASyncIO2;
  except
    ASyncIOIf := nil;
  end;
  if ASyncIOIf <> nil then
  begin
    Result := ASyncIOIf.Read(dwCount,@ItemServerHandle,dwTransactionID,PRcancel,Errors);
    if Succeeded(Result) then
    begin
      Result := Errors[0];
      CoTaskMemFree(Errors);
    end;

  end;

end;

// wrapper for IOPCSyncIO.Write (single item only)
function WriteOPCGroupItemValue(GroupIf: IUnknown; ItemServerHandle: OPCHANDLE;
          ItemValue: OleVariant): HResult;
var
  SyncIOIf: IOPCSyncIO;
  Errors: PResultList;
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
//异步写函数（内部封装）
function ASWriteOPCItemValue(dwCount:DWORD;GroupIf: IUnknown; ItemServerHandle: OPCHANDLE;
          ItemValue: OleVariant;dwTransactionID:DWORD): HResult;
var
  ASyncIOIf: IOPCAsyncIO2;
  PRcancel:dword;
  Errors: PResultList;
begin
  Result := E_FAIL;
  try
    ASyncIOIf := GroupIf as IOPCASyncIO2;
  except
    ASyncIOIf := nil;
  end;
  if ASyncIOIf <> nil then
  begin
    Result := ASyncIOIf.write(dwCount,@ItemServerHandle,@ItemValue,dwTransactionID,PRcancel,Errors);
    if Succeeded(Result) then
    begin
      Result := Errors[0];
      CoTaskMemFree(Errors);
    end;
  end;
end;
end.
