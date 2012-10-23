unit MySqlLib;

interface
uses
  AccessLib, Uni, Dialogs, BaseServerLib, Classes,Base;
type
  MySqlBase = class(TBaseServer)
  private
  protected
  public
    UniQueryForShow: TUniQuery;
    UniQueryForOp: TUniQuery;
    procedure Search(TSQL: string);
    function GetItemsFromTable(TSQL, FiledName: string): TStrings;
    function GetOneResult(TSQL, FiledName:String): string;
    function GetItemsArrFromTable(TSQL: string; Fileds: array of string): TItemsArr;
    function ExcuteSql(TSQL:String):Boolean;
    constructor Create(PUniConnection: TUniConnection); overload;
    destructor Destroy; override;
  end;
implementation

function MySqlBase.ExcuteSql(TSQL:String):Boolean;
begin
  try
    with UniQueryForOP do
    begin
      Close;
      SQL.Clear;
      SQL.Add(TSQL);
      ExecSQL;
    end;
  except
    ShowErrorMessage('连接数据库出错,请检查'#13'1：网络连接'#13'2：数据库所在地址、端口是否正确');
  end;
end;

constructor MySqlBase.Create(PUniConnection: TUniConnection);
begin
  inherited Create;
  UniQueryForShow := TUniQuery.Create(nil);
  UniQueryForShow.Connection := PUniConnection;
  UniQueryForOp := TUniQuery.Create(nil);
  UniQueryForOp.Connection := PUniConnection;
end;

destructor MySqlBase.Destroy;
begin
  try
    UniQueryForOp.Close;
    UniQueryForOp.Destroy;
    UniQueryForShow.Close;
    UniQueryForShow.Destroy;
  except
    ShowErrorMessage('关闭数据库时出错');
  end;
end;

procedure MySqlBase.Search(TSQL: string);
begin
  try
    with UniQueryForShow do
    begin
      Close;
      SQL.Clear;
      SQL.Add(TSQL);
      ExecSQL;
    end;
  except
    ShowErrorMessage('连接数据库出错,请检查'#13'1：网络连接'#13'2：数据库所在地址、端口是否正确');
  end;
end;

function MySqlBase.GetItemsFromTable(TSQL, FiledName: string): TStrings;
var
  TS: TStrings;
begin
  try
    TS := TStringList.Create;
    with UniQueryForOp do
    begin
      Close;
      SQL.Clear;
      SQL.Add(TSQL);
      ExecSQL;
      while not Eof do
      begin
        TS.Add(FieldByName(FiledName).AsString);
        Next;
      end;
      Close;
    end;
  except
  end;
  Result := TS;
end;

function MySqlBase.GetOneResult(TSQL, FiledName:String): string;
var
  TS: String;
begin
  try
    with UniQueryForOp do
    begin
      Close;
      SQL.Clear;
      SQL.Add(TSQL);
      ExecSQL;
      while not Eof do
      begin
        TS := (FieldByName(FiledName).AsString);
        Next;
      end;
      Close;
    end;
  except
  end;
  Result := TS;
end;


function MySqlBase.GetItemsArrFromTable(TSQL: string; Fileds: array of string): TItemsArr;
var
  ItemsArr: TItemsArr;
  I: Integer;
begin
  try
    SetLength(ItemsArr, Length(Fileds));
    for I := 0 to Length(Fileds) - 1 do
      ItemsArr[I] := TStringList.Create;
    with UniQueryForOp do
    begin
      Close;
      SQL.Clear;
      SQL.Add(TSQL);
      ExecSQL;
      while not Eof do
      begin
        for I := 0 to Length(Fileds) - 1 do
          ItemsArr[I].Add(FieldByName(Fileds[I]).AsString);
        Next;
      end;
      Close;
    end;
  except
  end;
  Result := ItemsArr;
end;


end.

