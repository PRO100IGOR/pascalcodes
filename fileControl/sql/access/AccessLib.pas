unit AccessLib;

interface

uses
  ADODB, SysUtils, Common, BaseServerLib;

type
  TParam = class(TBaseObject)
    PID: string;
    PValue: string;
    PName: string;
  end;

  TParams = array of TParam;

  TParamManage = class(TBaseServer)
  public
    ADOQuery: TADOQuery;
    ADOConnection: TADOConnection;
    function GetParamByName(PName: string): TParam;
    function AddParam(Param: TParam): Boolean;
    function SaveRange(Params: TParams): Boolean;
    function SaveParam(PName, PValue: string): Boolean;
    function UpdateParam(Param: TParam): Boolean;
    function DeleteParam(Param: TParam): Boolean;
    constructor Create; overload;
    destructor Destroy; override;
  end;

implementation


constructor TParamManage.Create;
begin
  inherited Create;
  try
    Self.ADOQuery := TADOQuery.Create(nil);
    Self.ADOConnection := TADOConnection.Create(nil);
    ADOConnection.ConnectionString := 'Provider=Microsoft.Jet.OLEDB.4.0;Data Source=' + ExtractFileDir(PARAMSTR(0)) + '\file\Config.mdb;Jet OLEDB:Database Password=itebase';
    ADOConnection.LoginPrompt := false;
    ADOQuery.Connection := ADOConnection;
    ADOConnection.Open;
  except
    ShowErrorMessage('找不到参数配置文件！');
  end;
end;

destructor TParamManage.Destroy;
begin
  try
    ADOQuery.Close;
    ADOConnection.Close;
    ADOQuery.Destroy;
    ADOConnection.Destroy;
    inherited Destroy;
  except
    ShowErrorMessage('找不到参数配置文件！');
  end;
end;



function TParamManage.GetParamByName(PName: string): TParam;
var
  Param: TParam;
begin
  Result := nil;
  Param := TParam.Create;
  try
    with ADOQuery do
    begin
      Close;
      Sql.Clear;
      Sql.Add('select * from Param where pname = ''' + PName + '''');
      Open;
      First;
      while not Eof do
      begin
        Param.PID := FieldByName('pid').AsString;
        Param.PValue := Common.UncrypKey(FieldByName('pvalue').AsString);
        Param.PName := FieldByName('pname').AsString;
        Result := Param;
        Next;
      end;
      Close;
    end;
  except
    ShowErrorMessage('找不到参数配置文件！');
  end;


  if Result = nil then
  begin
    Param := TParam.Create(true);
    Param.PName := PName;
    Result := Param;
  end;

end;

function TParamManage.SaveRange(Params: TParams): Boolean;
var
  I: Integer;
  Temp: string;
begin
  Result := false;
  try
    with ADOQuery do
    begin
      Close;
      for I := 0 to Length(Params) - 1 do
      begin
        Sql.Clear;
        if Params[I].NeedAdd then
        begin
          Params[I].PID := Params[I].OnlyId;
          Sql.Add('insert into Param values  (:PID,:PName,:PValue)');
          Parameters.ParamByName('PID').Value := Params[I].PID;
          Parameters.ParamByName('PValue').Value := Common.EncrypKey(Params[I].PValue);
          Parameters.ParamByName('PName').Value := Params[I].PName;
        end
        else
        begin
          Sql.Add('update Param set PValue = :PValue, PName = :PName where PID =:PID');
          Parameters.ParamByName('PID').Value := Params[I].PID;
          Parameters.ParamByName('PValue').Value := Common.EncrypKey(Params[I].PValue);
          Parameters.ParamByName('PName').Value := Params[I].PName;
        end;
        ExecSQL;
        Sleep(800);
        Sql.Clear;
      end;
      Close;
    end;
  except

  end;
  Result := true;
end;

function TParamManage.SaveParam(PName, PValue: string): Boolean;
var
  Param: TParam;
begin
  Param := GetParamByName(PName);
  Param.PValue := PValue;
  if Param.NeedAdd then
    AddParam(Param)
  else
    UpdateParam(Param);
end;

function TParamManage.AddParam(Param: TParam): Boolean;
begin
  Result := false;
  Param.PID := Param.OnlyId;
  try
    with ADOQuery do
    begin
      Close;
      Sql.Clear;
      Sql.Add('insert into Param values  (:PID,:PName,:PValue)');
      Parameters.ParamByName('PID').Value := Param.PID;
      Parameters.ParamByName('PValue').Value := Common.EncrypKey(Param.PValue);
      Parameters.ParamByName('PName').Value := Param.PName;
      ExecSQL;
      Close;
    end;
  except

  end;
  Result := true;
end;

function TParamManage.UpdateParam(Param: TParam): Boolean;
begin
  Result := false;
  try
    with ADOQuery do
    begin
      Close;
      Sql.Clear;
      Sql.Add('update Param set PValue = :PValue, PName = :PName where PID =:PID');
      Parameters.ParamByName('PID').Value := Param.PID;
      Parameters.ParamByName('PValue').Value := Common.EncrypKey(Param.PValue);
      Parameters.ParamByName('PName').Value := Param.PName;
      ExecSQL;
      Close;
    end;
  except
  end;
  Result := true;
end;

function TParamManage.DeleteParam(Param: TParam): Boolean;
begin
  Result := false;
  try
    with ADOQuery do
    begin
      Close;
      Sql.Clear;
      Sql.Add('delete from  Param where PID =:PID');
      Parameters.ParamByName('PID').Value := Param.PID;
      ExecSQL;
      Close;
    end;
  except

  end;
  Result := true;
end;

end.

