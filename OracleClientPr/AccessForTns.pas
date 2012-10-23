unit AccessForTns;

interface

uses
  ADODB, SysUtils, Common, ENUtil, bsDBGrids, bsSkinCtrls;

type
  TTNS = class(TObject)
  public
    TID, TNAME, TCP, HOST, PORT, SID: string;
    constructor Create; overload;
  end;

  TTNSARR = array of TTNS;


  TnsManage = class(TObject)
  public
    ADOQuery, ADOQueryop: TADOQuery;
    ADOConnection: TADOConnection;
    procedure InitADO;
    function GetCurrentDir: string;
    procedure InitAll();
    procedure SaveAll(bsSkinGauge: TbsSkinGauge);
    procedure Search(TSQL, FileName: string; DBGrid: TbsSkinDBGrid);
    function GetTnsById(Tid: string): TTNS;
    function AddTns(TNS: TTNS): Boolean;
    function UpdateTns(TNS: TTNS): Boolean;
    function DeleteTns(TNS: TTNS): Boolean;
    function DeleteAll: Boolean;
    function CheckTnsName(Tns, TID: string): Boolean;
    constructor Create; overload;
    destructor Destroy; override;
  end;

implementation


constructor TTNS.Create;
begin
  Self.TID := Common.CreateOnlyId;
  inherited Create;
end;

constructor TnsManage.Create;
begin
  Self.ADOQuery := TADOQuery.Create(nil);
  Self.ADOQueryop := TADOQuery.Create(nil);
  Self.ADOConnection := TADOConnection.Create(nil);
  Self.ADOQuery.Connection := ADOConnection;
  Self.ADOQueryop.Connection := ADOConnection;
  InitADO;
  inherited Create;
end;

destructor TnsManage.Destroy;
begin
  ADOQuery.Close;
  ADOQueryop.Close;
  ADOConnection.Close;
  ADOQuery.Destroy;
  ADOQueryop.Destroy;
  ADOConnection.Destroy;
  inherited Destroy;
end;

procedure TnsManage.InitADO;
begin
  ADOConnection.ConnectionString :=
    'Provider=Microsoft.Jet.OLEDB.4.0;Password="";Data Source=' +
    GetCurrentDir +
    '\Oracle.mdb;Persist Security Info=True';
  ADOConnection.LoginPrompt := false;
  ADOConnection.Open;
end;

function TnsManage.GetCurrentDir: string;
begin
  GetDir(0, Result);
end;

function TnsManage.GetTnsById(Tid: string): TTNS;
var
  TNS: TTNS;
begin
  try
    with ADOQueryop do
    begin
      Close;
      Sql.Clear;
      Sql.Add('select * from tns where TID = ''' + Tid + '''');
      Open;
      if ADOQuery.RecordCount > 0 then
      begin
        TNS := TTNS.Create;
        TNS.TID := FieldByName('TID').AsString;
        TNS.TNAME := FieldByName('TNAME').AsString;
        TNS.TCP := FieldByName('TCP').AsString;
        TNS.HOST := FieldByName('HOST').AsString;
        TNS.PORT := FieldByName('PORT').AsString;
        TNS.SID := FieldByName('SID').AsString;
        Result := TNS;
        Close;
      end
      else
      begin
        Result := nil;
        Close;
      end;
    end;
  except

  end;
end;

function TnsManage.AddTns(TNS: TTNS): Boolean;
begin
  Result := false;
  try
    with ADOQueryop do
    begin
      Close;
      Sql.Clear;
      Sql.Add
        ('insert into tns values  (:TID,:TNAME,:TCP,:HOST,:PORT,:SID)');
      Parameters.ParamByName('TID').Value := TNS.TID;
      Parameters.ParamByName('TNAME').Value := TNS.TNAME;
      Parameters.ParamByName('TCP').Value := TNS.TCP;
      Parameters.ParamByName('HOST').Value := TNS.HOST;
      Parameters.ParamByName('PORT').Value := TNS.PORT;
      Parameters.ParamByName('SID').Value := TNS.SID;
      ExecSQL;
      Close;
    end;
  except

  end;
  Result := true;
end;

function TnsManage.UpdateTns(TNS: TTNS): Boolean;
begin
  Result := false;
  try
    with ADOQueryop do
    begin
      Close;
      Sql.Clear;
      Sql.Add(
        'update tns set TNAME = :TNAME, TCP = :TCP,HOST = :HOST ,PORT = :PORT,SID = :SID where TID =:TID');
      Parameters.ParamByName('TID').Value := TNS.TID;
      Parameters.ParamByName('TNAME').Value := TNS.TNAME;
      Parameters.ParamByName('TCP').Value := TNS.TCP;
      Parameters.ParamByName('HOST').Value := TNS.HOST;
      Parameters.ParamByName('PORT').Value := TNS.PORT;
      Parameters.ParamByName('SID').Value := TNS.SID;
      ExecSQL;
      Close;
    end;
  except
  end;
  Result := true;
end;

function TnsManage.DeleteTns(TNS: TTNS): Boolean;
begin
  Result := false;
  try
    with ADOQueryop do
    begin
      Close;
      Sql.Clear;
      Sql.Add('delete from  tns where TID =:TID');
      Parameters.ParamByName('TID').Value := TNS.TID;
      ExecSQL;
      Close;
    end;
  except

  end;
  Result := true;
end;

function TnsManage.DeleteAll: Boolean;
begin
  Result := false;
  try
    with ADOQueryop do
    begin
      Close;
      Sql.Clear;
      Sql.Add('delete from  tns ');
      ExecSQL;
      Close;
    end;
  except

  end;
  Result := true;
end;

procedure TnsManage.InitAll();
var
  F: TextFile;
  FileName, Str: string;
  I, EmptyRows, HROWS: Integer;
  TNS: TTNS;
begin
  EmptyRows := 0;
  HROWS := 0;
  FileName := ExtractFileDir(PARAMSTR(0)) + '\oran\network\ADMIN\tnsnames.ora';
  AssignFile(F, FileName);
  Reset(F);
  for I := 0 to 9999999 do begin
    Readln(F, Str);
    if Str = '' then
    begin
      Inc(EmptyRows);
      TNS := TTNS.Create;
      HROWS := 0;
    end
    else
    begin
      if TNS <> nil then
      begin
        if HROWS = 0 then
        begin
          TNS.TNAME := Common.Split(Str, ' ')[0];
        end
        else if HROWS = 3 then
        begin
          TNS.TCP := Common.Split(Common.Split(Str, ')(')[0], ' = ')[2];
          TNS.HOST := Common.Split(Common.Split(Str, 'HOST = ')[1], ')(')[0];
          TNS.PORT := Common.Split(Common.Split(Str, 'PORT = ')[1], '))')[0];
        end
        else if HROWS = 6 then
        begin
          TNS.SID := Common.Split(Common.Split(Str, ' = ')[1], ')')[0];
          Self.AddTns(TNS);
          EmptyRows := 0;
        end;
      end;
      Inc(HROWS);
    end;
    if EmptyRows >= 3 then break;
  end;
  CloseFile(F);
end;

procedure TnsManage.SaveAll(bsSkinGauge: TbsSkinGauge);
var
  F: TextFile;
  FileName: string;
begin
  try
    FileName := ExtractFileDir(PARAMSTR(0)) + '\oran\network\ADMIN\tnsnames.ora';
    AssignFile(F, FileName);
    Reset(F);
    ReWrite(F);
    with ADOQueryop do
    begin
      Close;
      Sql.Clear;
      Sql.Add('select * from  tns');
      Open;
      while not Eof do
      begin
        Writeln(F, '');
        Writeln(F, Trim(FieldByName('TNAME').AsString) + ' = ');
        Writeln(F, '  (DESCRIPTION =');
        Writeln(F, '    (ADDRESS_LIST =');
        Writeln(F, '      (ADDRESS = (PROTOCOL = ' + Trim(FieldByName('TCP').AsString) + ')(HOST = ' + Trim(FieldByName('HOST').AsString) + ')(PORT = ' + Trim(FieldByName('PORT').AsString) + '))');
        Writeln(F, '    )');
        Writeln(F, '    (CONNECT_DATA =');
        Writeln(F, '      (SID = ' + Trim(FieldByName('SID').AsString) + ')');
        Writeln(F, '    )');
        Writeln(F, '  )');
        Writeln(F, '');
        bsSkinGauge.Value := bsSkinGauge.Value + 10;
        Next;
      end;
      Close;
      Self.DeleteAll;
      CloseFile(F);
    end;
  except
  end;

end;

procedure TnsManage.Search(TSQL, FileName: string; DBGrid: TbsSkinDBGrid);
begin
  try
    with ADOQuery do
    begin
      Close;
      ENUtil.changeDB(FileName, 'count', DBGrid);
      Sql.Clear;
      Sql.Add(TSQL);
      Open;
      DBGrid.Refresh;
    end;
  except

  end;

end;

function TnsManage.CheckTnsName(Tns, TID: string): Boolean;
begin
  try
    with ADOQueryop do
    begin
      Close;
      Sql.Clear;
      Sql.Add('select * from tns where TNAME = ''' + Tns + ''' and TID <> ''' + TID + '''');
      Open;
      if RecordCount > 0 then Result := true
      else Result := false;
      Close;
    end;
  except

  end;

end;


end.

