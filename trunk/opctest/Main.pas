unit Main;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,LogsUnit,
  Dialogs,ScktComp,Ini, StdCtrls,iOPCClasses,iOPCFunctions,iOPCTypes,iOPCItem,ActiveX,ComObj,Common,
  ExtCtrls,superobject,StrUtils, iComponent, iVCLComponent, iCustomComponent,
  iAnalogDisplay;

type
  TServer = class(TObject)
  public
    FServerIf                   : IOPCServer;
    FGroupIf                    : IOPCItemMgt;
    FGroupHandle                : Cardinal;
    FOPCDataCallback            : TiOPCDataCallback;
    FOPCDataCallbackConnection  : Longint;
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
  end;

  TItem = class(TObject)
    ItemHandle          : OPCHANDLE;
    CanonicalType       : TVarType;
  end;

  
  TMainForm = class(TForm)
    Logs: TMemo;
    GroupBox1: TGroupBox;
    LogClear: TCheckBox;
    ClearLogBtn: TButton;
    DeBugCk: TCheckBox;
    Button1: TButton;
    Button2: TButton;
    Button3: TButton;
    ServerName: TComboBox;
    Button4: TButton;
    COUNTS: TEdit;
    Label1: TLabel;
    procedure FormCreate(Sender: TObject);
    procedure ClearLogBtnClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure Button3Click(Sender: TObject);
    procedure Button4Click(Sender: TObject);
  private

      Servers         : TServers;         //服务集合
      procedure OnNewData(Sender: TObject); //有新数据发生时
      procedure AsyncDataChange(Sender: TObject);
  public
  end;
var
  MainForm: TMainForm;
  isClear : Boolean;
implementation

{$R *.dfm}

constructor TServers.Create;
begin
  Keys := TStringList.Create;
  SetLength(Values, 0);

end;
procedure TServers.clear;
begin
  SetLength(Values, 0);
  Keys.Clear;
end;
function TServers.GetItems(Key: string): TServer;
var
  KeyIndex: Integer;
begin
  KeyIndex := Keys.IndexOf(Key);
  if KeyIndex <> -1 then
    Result := Values[KeyIndex]
  else
    Result := nil;
end;
function TServers.Add(Key: string; Value: TServer): Integer;
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
function TServers.GetCount: Integer;
begin
  Result := Keys.Count;
end;
function TServers.Remove(Key: string): Integer;
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






procedure TMainForm.FormCreate(Sender: TObject);
begin
    if not DirectoryExists(ExtractFileDir(PARAMSTR(0)) + '\logs') then CreateDirectory(PChar(ExtractFilePath(ParamStr(0)) + '\logs'), nil);
    Servers       := TServers.Create;
    isClear := False;
end;
procedure TMainForm.FormShow(Sender: TObject);
begin
    DeBugCk.Checked := True;
end;
procedure TMainForm.Button1Click(Sender: TObject);
var
  ServerNames             : IOPCServerList;
  Enum                    : IEnumGUID2;
  Guid                    : TGuid;
  Fetched                 : Cardinal;
  ProgIDString            : POleStr;
  ReadableNameString      : POleStr;
begin
  Logs.Lines.Clear;
  ServerName.Items.Clear;
  ServerNames := iOPCFunctions.OPCCreateServerList('');
  ServerNames.EnumClassesOfCategories(1, @CATID_OPCDAServer10, 0, nil, Enum);

  if Assigned(Enum) then
  begin

      while Enum.Next(1, Guid, Fetched) = S_OK do
      begin
          ServerNames.GetClassDetails(Guid, ProgIDString, ReadableNameString);
          if ServerName.Items.IndexOf(ProgIDString) = -1 then
          begin
              Logs.Lines.Add(ProgIDString);
              ServerName.Items.Add(ProgIDString);
          end;
      end;
  end;

  ServerNames.EnumClassesOfCategories(1, @CATID_OPCDAServer20, 0, nil, Enum);
  if Assigned(Enum) then
  begin
      while Enum.Next(1, Guid, Fetched) = S_OK do
      begin
          ServerNames.GetClassDetails(Guid, ProgIDString, ReadableNameString);
          if ServerName.Items.IndexOf(ProgIDString) = -1 then
          begin
              Logs.Lines.Add(ProgIDString);
              ServerName.Items.Add(ProgIDString);
          end;
      end;
  end;
end;

procedure TMainForm.Button2Click(Sender: TObject);
var
    FOPCBrowser         : IOPCBrowseServerAddressSpace;
    ServerNames         : IOPCServerList;
    ServerItems         : TStrings;
    NameSpaceType       : OPCNAMESPACETYPE;
    EnumString          : IEnumString2;
    ProgIDString        : POleStr;
    FetInt              : UInt;
    Enum                : IEnumGUID2;
    Guid                : TGuid;
    Fetched             : Cardinal;
    ReadableNameString  : POleStr;
    Items               : TStrings;
    I                   : Integer;
begin
    if ServerName.ItemIndex = -1 then Exit;
    Logs.Lines.Clear;


    ServerNames := iOPCFunctions.OPCCreateServerList('');
    ServerNames.EnumClassesOfCategories(1, @CATID_OPCDAServer10, 0, nil, Enum);
    if Assigned(Enum) then
    begin
      while Enum.Next(1, Guid, Fetched) = S_OK do
      begin
          ServerNames.GetClassDetails(Guid, ProgIDString, ReadableNameString);
      end;
    end;
    ServerNames.EnumClassesOfCategories(1, @CATID_OPCDAServer20, 0, nil, Enum);
    if Assigned(Enum) then
    begin
        while Enum.Next(1, Guid, Fetched) = S_OK do
        begin
            ServerNames.GetClassDetails(Guid, ProgIDString, ReadableNameString);
        end;
    end;


     FOPCBrowser := OPCCreateBrowser('', ServerName.Text, ServerNames);
     Items := TStringList.Create;
     while Succeeded(FOPCBrowser.ChangeBrowsePosition(OPC_BROWSE_UP, '')) do
     begin
              FOPCBrowser.QueryOrganization(NameSpaceType);
     end;
     if   NameSpaceType = OPC_NS_FLAT then
     begin
            FOPCBrowser.BrowseOPCItemIDs(OPC_FLAT, '', VT_EMPTY, 0, EnumString);
            if Assigned(EnumString) then
            begin
                Items := TStringList.Create;
                while Succeeded(EnumString.Next(1, ProgIDString, @FetInt)) and (FetInt = 1) do
                begin
                      if Items.IndexOf(ProgIDString) = -1 then
                      begin
                          Items.Add(ProgIDString);
                      end;
                end;
            end;
            EnumString := nil;
     end
     else
     begin
             FOPCBrowser.BrowseOPCItemIDs(OPC_LEAF, '', VT_EMPTY, 0, EnumString);
             if Assigned(EnumString) then
             begin
                  while Succeeded(EnumString.Next(1, ProgIDString, @FetInt)) and (FetInt = 1) do
                  begin
                      if Items.IndexOf(ProgIDString) = -1 then
                      begin
                          Items.Add(ProgIDString);
                      end;
                  end;
             end;
             FOPCBrowser.BrowseOPCItemIDs(OPC_BRANCH, '', VT_EMPTY, 0, EnumString);
             if Assigned(EnumString) then
             begin
                while Succeeded(EnumString.Next(1, ProgIDString, @FetInt)) and (FetInt = 1) do
                  begin
                    if Items.IndexOf(ProgIDString) = -1 then
                    begin
                        Items.Add(ProgIDString);
                    end;
                  end;
             end;
     end;
     ServerItems := TStringList.Create;
     for I := 0 to Items.Count - 1 do
     begin
        while Succeeded(FOPCBrowser.ChangeBrowsePosition(OPC_BROWSE_UP, '')) do;
        FOPCBrowser.ChangeBrowsePosition(OPC_BROWSE_DOWN, PWideChar(WideString(Items[I])));
        FOPCBrowser.BrowseOPCItemIDs(OPC_LEAF, '', VT_EMPTY, 0, EnumString);
        if Assigned(EnumString) then
        begin
            while Succeeded(EnumString.Next(1, ProgIDString, @FetInt)) and (FetInt = 1) do
            begin
                  if ServerItems.IndexOf(Items[I] + '.' + ProgIDString) = -1 then
                  begin
                        ServerItems.Add(Items[I] + '.' + ProgIDString);
                  end;
            end;
        end;
     end;




    if ServerItems.Count > 0  then
    begin
        Logs.Lines.AddStrings(ServerItems);
        ServerItems.SaveToFile(ExtractFileDir(PARAMSTR(0)) + '\'+ServerName.Text + '.items');
    end
    else
    begin
       Logs.Lines.Add('没有一个点!!!');
    end;


end;

procedure TMainForm.Button3Click(Sender: TObject);
var
    Server      : TServer;
    ServerItems : TStrings;
    I           : Integer;
    Index       : Integer;
    CountsIndex : Integer;
    Item        : TItem;
    FOPCDataCallback            : TiOPCDataCallback;
begin
    if ServerName.ItemIndex = -1 then Exit;
    if not FileExists(ExtractFileDir(PARAMSTR(0)) + '\'+ServerName.Text + '.items') then
    begin
        Application.MessageBox('这个服务需要先遍历获取点信息，才能监听！',
          '提示', MB_OK + MB_ICONSTOP);
        Exit;
    end;
    Logs.Lines.Clear;
    Server := Servers.Items[ServerName.Text];
    ServerItems := TStringList.Create;
    ServerItems.LoadFromFile(ExtractFileDir(PARAMSTR(0)) + '\'+ServerName.Text + '.items');
    if not Assigned(Server) then
    begin
        Server := TServer.Create;
        Server.FServerIf := CreateComObject(ProgIDToClassID(ServerName.Text)) as IOPCServer;
        OPCServerAddGroup(Server.FServerIf, ServerName.Text + 'G1', True, 500, Server.FGroupIf, Server.FGroupHandle);
        FOPCDataCallback := TiOPCDataCallback.Create;
        FOPCDataCallback.OnDataChange2 := AsyncDataChange;
        OPCGroupAdvise2(Server.FGroupIf, FOPCDataCallback, FOPCDataCallbackConnection);
        Servers.Add(ServerName.Text,Server);
    end;
    CountsIndex := StrToInt(COUNTS.Text);
    for I := 0 to ServerItems.Count - 1 do
    begin
        if I > CountsIndex then Break;
        Item := TItem.Create;
        OPCGroupAddItem(Server.FGroupIf,ServerItems[I],0,varString,Item.ItemHandle,Item.CanonicalType);

    end;
end;

procedure TMainForm.Button4Click(Sender: TObject);
begin
    Application.ProcessMessages;
end;

procedure TMainForm.ClearLogBtnClick(Sender: TObject);
begin
    Logs.Lines.Clear;
end;

procedure TMainForm.OnNewData(Sender: TObject);
var
   OPCItem       :  TiOPCItem;
   S             :  string;
begin
   if isClear then Exit;
   Application.ProcessMessages;
   OPCItem      :=  Sender as TiOPCItem;
   S    :=  OPCItem.Data;
   Logs.Lines.Add(OPCItem.ItemName + ' >> ' + S);
end;
procedure TMainForm.AsyncDataChange(Sender: TObject);
begin
    
end;

end.
