unit BaseTypes;

interface
uses
  Classes,Windows,SysUtils,ScktComp,superobject,Common,ComObj,OPCtypes,OPCDA, OPCutils,ActiveX,ExtCtrls;
type
   TOnDataChange =  procedure (dwTransid: DWORD; hGroup: OPCHANDLE;hrMasterquality: HResult; hrMastererror: HResult; dwCount: DWORD;phClientItems: POPCHANDLEARRAY; pvValues: POleVariantArray;pwQualities: PWordArray; pftTimeStamps: PFileTimeArray;pErrors: PResultList;ServerName:string) of object;
   TOnReadComplete = procedure (dwTransid: DWORD; hGroup: OPCHANDLE;hrMasterquality: HResult; hrMastererror: HResult; dwCount: DWORD; phClientItems: POPCHANDLEARRAY; pvValues: POleVariantArray;pwQualities: PWordArray; pftTimeStamps: PFileTimeArray;pErrors: PResultList)of object;
   TOnWriteComplete = procedure (dwTransid: DWORD; hGroup: OPCHANDLE;hrMastererr: HResult; dwCount: DWORD; pClienthandles: POPCHANDLEARRAY;pErrors: PResultList)of object;
   TOnCancelComplete =  procedure (dwTransid: DWORD; hGroup: OPCHANDLE) of object;

   TOnNewData = procedure(LogicDeviceId:string;ItemHandel:Opchandle;ItemValue:string) of object;

   TOPCDataCallback = class(TInterfacedObject, IOPCDataCallback)
  private
    ServerName       : string;
    VOnDataChange    : TOnDataChange;
    VOnReadComplete  : TOnReadComplete;
    VOnWriteComplete : TOnWriteComplete;
    VOnCancelComplete: TOnCancelComplete;
    function OnDataChange(dwTransid: DWORD; hGroup: OPCHANDLE;hrMasterquality: HResult; hrMastererror: HResult; dwCount: DWORD;phClientItems: POPCHANDLEARRAY; pvValues: POleVariantArray;pwQualities: PWordArray; pftTimeStamps: PFileTimeArray;pErrors: PResultList): HResult; stdcall;
    function OnReadComplete(dwTransid: DWORD; hGroup: OPCHANDLE;hrMasterquality: HResult; hrMastererror: HResult; dwCount: DWORD; phClientItems: POPCHANDLEARRAY; pvValues: POleVariantArray;pwQualities: PWordArray; pftTimeStamps: PFileTimeArray;pErrors: PResultList): HResult; stdcall;
    function OnWriteComplete(dwTransid: DWORD; hGroup: OPCHANDLE;hrMastererr: HResult; dwCount: DWORD; pClienthandles: POPCHANDLEARRAY;pErrors: PResultList): HResult; stdcall;
    function OnCancelComplete(dwTransid: DWORD; hGroup: OPCHANDLE):HResult; stdcall;
  public
    property POnDataChange  : TOnDataChange read VOnDataChange write VOnDataChange;
    property POnReadComplete: TOnReadComplete read VOnReadComplete write VOnReadComplete;
    property POnWriteComplete: TOnWriteComplete read VOnWriteComplete write VOnWriteComplete;
    property POnCancelComplete: TOnCancelComplete read VOnCancelComplete write VOnCancelComplete;
    property PServerName: string read ServerName write ServerName;
  end;

   TStringMap = class(TPersistent)
   private
    function GetItems(Key: string): string;
    function GetCount: Integer;
   public
    Keys: TStrings;
    Values: array of string;
    property Items[Key: string]: string read GetItems; default;
    property Count: Integer read GetCount;
    function Add(Key: string; Value: string): Integer;
    procedure clear;
    function Remove(Key: string): Integer;
    constructor Create; overload;
  end;
  TItem = class(TObject)
     ItemHandel    : Opchandle;
     LogicDeviceId :TStrings;
     ItemValue:string;
     ItemName : string;
  end;

   TItems = class(TPersistent)
   private
    function GetItems(Key: string): TItem;
    function GetCount: Integer;
   public
    Keys: TStrings;
    Values: array of TItem;
    property Items[Key: string]: TItem read GetItems; default;
    property Count: Integer read GetCount;
    function Add(Key: string; Value: TItem): Integer;
    procedure clear;
    function Remove(Key: string): Integer;
    constructor Create; overload;
  end;

   TServer = class(TObject)
   public
    ServerName                 : string;  
    ServerIf                   : IOPCServer;
    GroupIf                    : IOPCItemMgt;
    GroupHandle                : Cardinal;
    Items                      : TItems;
    destructor     Destroy; override;
    constructor    Create; overload;
    function       Init :Boolean;
    function       Add(ALogicDeviceId:string;ItemName:string;var isAdd : Boolean):Opchandle;
    procedure      Clear;
  end;
   TServers = class(TPersistent)
   private
    function GetItems(Key: string): TServer;
    function GetCount: Integer;
   public
    Keys: TStrings;
    Values: array of TServer;
    property Items[Key: string]: TServer read GetItems; default;
    property Count: Integer read GetCount;
    function Add(Key: string; Value: TServer): Integer;
    procedure clear;
    function Remove(Key: string): Integer;
    constructor Create; overload;
    procedure RemoveErrors(itemNames:TStrings);
  end;

   TLogicDevice = class(TObject)
   private
   public
    ID          :     string;
    Address     :     string;
    ItemsValues :     TStringMap;
    constructor     Create;         overload;
    function        getValueString  :string;
   end;
   TLogicDevices = class(TPersistent)
  private
    function GetItems(Key: string): TLogicDevice;
    function GetCount: Integer;
  public
    Keys: TStrings;
    Values: array of TLogicDevice;
    property Items[Key: string]: TLogicDevice read GetItems; default;  
    property Count: Integer read GetCount;                   
    function Add(Key: string; Value: TLogicDevice): Integer; 
    procedure clear;
    function Remove(Key: string): Integer; 
    constructor Create; overload;
  end;
   TScokets = class(TPersistent)
   private
    function GetItems(Key: string): TCustomWinSocket;
    function GetCount: Integer;
   public
    Keys: TStrings;
    Values: array of TCustomWinSocket;
    property Items[Key: string]: TCustomWinSocket read GetItems; default;  //获取其单一元素
    property Count: Integer read GetCount;  //获取个数
    function Add(Key: string; Value: TCustomWinSocket): Integer;  //添加元素
    procedure clear;
    function Remove(Key: string): Integer;  //移除
    constructor Create; overload;
   end;

implementation

uses
    MainLib;


constructor TStringMap.Create;
begin
  Keys := TStringList.Create;
  SetLength(Values, 0);
end;
procedure   TStringMap.clear;
begin
  SetLength(Values, 0);
  Keys.Clear;
end;
function    TStringMap.GetItems(Key: string): string;
var
  KeyIndex: Integer;
begin
  KeyIndex := Keys.IndexOf(Key);
  if KeyIndex <> -1 then
    Result := Values[KeyIndex]
  else
    Result := '';
end;
function    TStringMap.Add(Key: string; Value: string): Integer;
var
  I:Integer;
begin
  if Value = '' then Exit;
  I := Keys.IndexOf(Key);
  if I = -1 then
  begin
    Keys.Add(Key);
    SetLength(Values, Length(Values) + 1);
    Values[Length(Values) - 1] := Value;
  end
  else
    Values[I] := Value;
  Result := Length(Values) - 1;
end;
function    TStringMap.GetCount: Integer;
begin
  Result := Keys.Count;
end;
function    TStringMap.Remove(Key: string): Integer;
var
  Index : Integer;
  Count : Integer;
begin
  Index := Keys.IndexOf(Key);
  Count := Length(Values);
  if Index <> -1 then
  begin
    Keys.Delete(Index);
    Move(Values[Index + 1], Values[Index], (Count - Index) * SizeOf(Values[0]));
    SetLength(Values, Count - 1);
  end;
  Result := Count - 1;
end;


constructor TServer.Create;
begin
    Items := TItems.Create;
    inherited Create;
end;
destructor  TServer.Destroy;
begin
    Clear;
    if Assigned(GroupIf) then
       ServerIf.RemoveGroup(GroupHandle, False);
end;
function    TServer.Init:Boolean;
var
    Hr  : HResult;
begin
    Result := True;
    try
        ServerIf := CreateComObject(ProgIDToClassID(ServerName)) as IOPCServer;
    except
        Result := False;
        Exit;
    end;
    Hr := ServerAddGroup(ServerIf, ServerName + ' g1', True, 5000, 0,GroupIf, GroupHandle);
    if not Succeeded(HR) then
    begin
        Result := False;
        Exit;
    end;
end;
function    TServer.Add(ALogicDeviceId:string;ItemName:string;var isAdd : Boolean):Opchandle;
var
    Hr         : HRESULT;
    ItemHandle : Opchandle;
    ItemType   : TVarType;
    Item       : TItem;
begin
    Item :=  Items.Items[ItemName];
    if Assigned(Item) then
    begin
       Result := Item.ItemHandel;
       Item.LogicDeviceId.Add(ALogicDeviceId);
       Items.Add(ItemName ,Item);
       isAdd := False; 
    end
    else
    begin
        Hr := GroupAddItem(GroupIf,ItemName, 0, VT_EMPTY,ItemHandle,ItemType);
        if not Succeeded(Hr) then
        begin
            Result := 0;
            Exit;
        end;
        isAdd := True;
        Item := TItem.Create;
        Item.ItemHandel := ItemHandle;
        Item.ItemName := ItemName;
        Item.LogicDeviceId := TStringList.Create;
        Item.LogicDeviceId.Add(ALogicDeviceId);
        Item.ItemValue := '';
        Items.Add(ItemName ,Item);
        Result := ItemHandle;
    end;
end;
procedure  TServer.Clear;
begin
    Items.clear;
end;



constructor TServers.Create;
begin
  Keys := TStringList.Create;
  SetLength(Values, 0);
end;
procedure   TServers.clear;
begin
  SetLength(Values, 0);
  Keys.Clear;
end;
function    TServers.GetItems(Key: string): TServer;
var
  KeyIndex: Integer;
begin
  KeyIndex := Keys.IndexOf(Key);
  if KeyIndex <> -1 then
    Result := Values[KeyIndex]
  else
    Result := nil;
end;
function    TServers.Add(Key: string; Value: TServer): Integer;
begin
  if Keys.IndexOf(Key) = -1 then
  begin
    Keys.Add(Key);
    SetLength(Values, Length(Values) + 1);
    Values[Length(Values) - 1] := Value;
  end
  else
    Values[Keys.IndexOf(Key)] := Value;
  Result := Length(Values) - 1;
end;
function    TServers.GetCount: Integer;
begin
  Result := Keys.Count;
end;
function    TServers.Remove(Key: string): Integer;
var
  Index : Integer;
  Count : Integer;
begin
  Index := Keys.IndexOf(Key);
  Count := Length(Values);
  if Index <> -1 then
  begin
    Keys.Delete(Index);
    Move(Values[Index + 1], Values[Index], (Count - Index) * SizeOf(Values[0]));
    SetLength(Values, Count - 1);
  end;
  Result := Count - 1;
end;
procedure   TServers.RemoveErrors(itemNames:TStrings);
var
  I,K:Integer;
begin
  for I := 0 to Count - 1 do
  begin
      for K := 0 to itemNames.Count - 1 do
      begin
          Values[I].Items.Remove(itemNames[K]);
      end;
  end;
end;


constructor TItems.Create;
begin
  Keys := TStringList.Create;
  SetLength(Values, 0);
end;
procedure   TItems.clear;
begin
  SetLength(Values, 0);
  Keys.Clear;
end;
function    TItems.GetItems(Key: string): TItem;
var
  KeyIndex: Integer;
begin
  KeyIndex := Keys.IndexOf(Key);
  if KeyIndex <> -1 then
    Result := Values[KeyIndex]
  else
    Result := nil;
end;
function    TItems.Add(Key: string; Value: TItem): Integer;
begin
  if Keys.IndexOf(Key) = -1 then
  begin
    Keys.Add(Key);
    SetLength(Values, Length(Values) + 1);
    Values[Length(Values) - 1] := Value;
  end
  else
    Values[Keys.IndexOf(Key)] := Value;
  Result := Length(Values) - 1;
end;
function    TItems.GetCount: Integer;
begin
  Result := Keys.Count;
end;
function    TItems.Remove(Key: string): Integer;
var
  Index : Integer;
  Count : Integer;
begin
  Index := Keys.IndexOf(Key);
  Count := Length(Values);
  if Index <> -1 then
  begin
    Keys.Delete(Index);
    Move(Values[Index + 1], Values[Index], (Count - Index) * SizeOf(Values[0]));
    SetLength(Values, Count - 1);
  end;
  Result := Count - 1;
end;

constructor TScokets.Create;
begin
  Keys := TStringList.Create;
  SetLength(Values, 0);
end;
procedure   TScokets.clear;
begin
  SetLength(Values, 0);
  Keys.Clear;
end;
function    TScokets.GetItems(Key: string): TCustomWinSocket;
var
  KeyIndex: Integer;
begin
  KeyIndex := Keys.IndexOf(Key);
  if KeyIndex <> -1 then
    Result := Values[KeyIndex]
  else
    Result := nil;
end;
function    TScokets.Add(Key: string; Value: TCustomWinSocket): Integer;
begin
  if Keys.IndexOf(Key) = -1 then
  begin
    Keys.Add(Key);
    SetLength(Values, Length(Values) + 1);
    Values[Length(Values) - 1] := Value;
  end
  else
    Values[Keys.IndexOf(Key)] := Value;
  Result := Length(Values) - 1;
end;
function    TScokets.GetCount: Integer;
begin
  Result := Keys.Count;
end;
function    TScokets.Remove(Key: string): Integer;
var
  Index : Integer;
  Count : Integer;
begin
  Index := Keys.IndexOf(Key);
  Count := Length(Values);
  if Index <> -1 then
  begin
    Keys.Delete(Index);
    Move(Values[Index + 1], Values[Index], (Count - Index) * SizeOf(Values[0]));
    SetLength(Values, Count - 1);
  end;
  Result := Count - 1;
end;


constructor TLogicDevice.Create;
begin
    ItemsValues := TStringMap.Create;
end;
function    TLogicDevice.getValueString:string;
var
  I       :Integer;
  RObject :ISuperObject;
begin

  Result := '';

  RObject := SO('{}');
  RObject.S['id'] := ID;


  for I := 0 to ItemsValues.Count - 1 do
  begin
      if ItemsValues.Values[I] = '-' then Exit;
      RObject['value[]'] := SO(ItemsValues.Values[I]);
  end;
  Result := RObject.AsString;

end;
constructor TLogicDevices.Create;
begin
  Keys := TStringList.Create;
  SetLength(Values, 0);
end;
procedure   TLogicDevices.clear;
begin
  SetLength(Values, 0);
  Keys.Clear;
end;
function    TLogicDevices.GetItems(Key: string): TLogicDevice;
var
  KeyIndex: Integer;
begin
  KeyIndex := Keys.IndexOf(Key);
  if KeyIndex <> -1 then
    Result := Values[KeyIndex]
  else
    Result := nil;
end;
function    TLogicDevices.Add(Key: string; Value: TLogicDevice): Integer;
begin
  if Keys.IndexOf(Key) = -1 then
  begin
    Keys.Add(Key);
    SetLength(Values, Length(Values) + 1);
    Values[Length(Values) - 1] := Value;
  end
  else
    Values[Keys.IndexOf(Key)] := Value;
  Result := Length(Values) - 1;
end;
function    TLogicDevices.GetCount: Integer;
begin
  Result := Keys.Count;
end;
function    TLogicDevices.Remove(Key: string): Integer;
var
  Index : Integer;
  Count : Integer;
begin
  Index := Keys.IndexOf(Key);
  Count := Length(Values);
  if Index <> -1 then
  begin
    Keys.Delete(Index);
    Move(Values[Index + 1], Values[Index], (Count - Index) * SizeOf(Values[0]));
    SetLength(Values, Count - 1);
  end;
  Result := Count - 1;
end;


function TOPCDataCallback.OnDataChange(dwTransid: DWORD; hGroup: OPCHANDLE;hrMasterquality: HResult; hrMastererror: HResult; dwCount: DWORD;phClientItems: POPCHANDLEARRAY; pvValues: POleVariantArray;pwQualities: PWordArray; pftTimeStamps: PFileTimeArray;pErrors: PResultList): HResult;
begin
  Result := S_OK;
  if Assigned(VOnDataChange) then VOnDataChange(dwTransid,hGroup,hrMasterquality,hrMastererror,dwCount,phClientItems,pvValues,pwQualities,pftTimeStamps,pErrors,ServerName);
end;
function TOPCDataCallback.OnReadComplete(dwTransid: DWORD; hGroup: OPCHANDLE;hrMasterquality: HResult; hrMastererror: HResult; dwCount: DWORD;phClientItems: POPCHANDLEARRAY; pvValues: POleVariantArray;pwQualities: PWordArray; pftTimeStamps: PFileTimeArray;pErrors: PResultList): HResult;
begin
  Result := S_OK;
  if Assigned(VOnReadComplete) then VOnReadComplete(dwTransid,hGroup,hrMasterquality,hrMastererror,dwCount,phClientItems,pvValues,pwQualities, pftTimeStamps,pErrors);
end;
function TOPCDataCallback.OnWriteComplete(dwTransid: DWORD; hGroup: OPCHANDLE;hrMastererr: HResult; dwCount: DWORD; pClienthandles: POPCHANDLEARRAY;pErrors: PResultList): HResult;
begin
   Result := S_OK;
   if Assigned(VOnWriteComplete) then VOnWriteComplete(dwTransid,hGroup,hrMastererr,dwCount,pClienthandles,pErrors);
end;
function TOPCDataCallback.OnCancelComplete(dwTransid: DWORD;hGroup: OPCHANDLE): HResult;
begin
  Result := S_OK;
  if Assigned(VOnCancelComplete) then VOnCancelComplete(dwTransid,hGroup);
end;





end.
