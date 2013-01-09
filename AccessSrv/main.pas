unit main;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ExtCtrls, StdCtrls,ADODB,LogsUnit,Ini, UniProvider,
  OracleUniProvider, DB, DBAccess, Uni, MemDS,Common, MySQLUniProvider,
  ODBCUniProvider, AccessUniProvider;

type
  TMainForm = class(TForm)
    Logs: TMemo;
    LogClear: TCheckBox;
    ClearLogBtn: TButton;
    Timer: TTimer;
    TimerRead: TTimer;
    UniConnection: TUniConnection;
    OracleUniProvider: TOracleUniProvider;
    UniQuery: TUniQuery;
    AccessUniProvider1: TAccessUniProvider;
    procedure FormDestroy(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure TimerTimer(Sender: TObject);
    procedure TimerReadTimer(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
    DbPath  : string;
    ADOQuery: TADOQuery;
    ADOConnection: TADOConnection;
    function Init:Boolean;
    procedure AddLogs(Content:string);
    function changeData(Data:string):string;
    function DeDate(Date:string):string;
  end;

var
  MainForm: TMainForm;
implementation

{$R *.dfm}

function TMainForm.DeDate(Date:string):string;
var
  G : StringArray;
  K : StringArray;
  M : StringArray;
  I : Integer;
begin
     Result := '';
     if Date = '' then
     begin
        Exit;
     end
     else
     begin
        K := Common.Split(Date,' ');
        G := Common.Split(K[0],'-');
        for I := 0 to Length(G) - 1 do
        begin
            if Length(G[I]) = 1 then
            begin
                G[I] := '0' + G[I];
            end;
            if I <> Length(G) - 1 then
              Result := Result + G[I] + '-'
            else
              Result := Result + G[I];
        end;
        if Length(K) > 1 then
        begin
           Result := Result + ' ';
           M := Common.Split(K[1],':');
           for I := 0 to Length(M) - 1 do
           begin
                if Length(M[I]) = 1 then
                begin
                    M[I] := '0' + M[I];
                end;
                if I <> Length(G) - 1 then
                  Result := Result + M[I] + ':'
                else
                  Result := Result + M[I];
           end;
        end;
     end;
end;


function TMainForm.changeData(Data:string):string;
begin
     if Data = 'True' then
     begin
       Result := '1';
     end
     else if Data = 'False' then
     begin
       Result := '0';
     end
     else if Data = 'No' then
     begin
       Result := '0';
     end
     else
     begin
       Result := '1';
     end
end;

procedure TMainForm.FormCreate(Sender: TObject);
begin
    if not DirectoryExists(ExtractFileDir(PARAMSTR(0)) + '\logs') then CreateDirectory(PChar(ExtractFilePath(ParamStr(0)) + '\logs'), nil);
    DbPath := Ini.ReadIni('server','path');
end;

procedure TMainForm.FormDestroy(Sender: TObject);
begin
  try
    ADOQuery.Close;
    ADOConnection.Close;
    ADOQuery.Destroy;
    ADOConnection.Destroy;
  except
    AddLogs('数据库关闭错误!');
  end;
  try
    UniConnection.Close;
    UniConnection.Destroy;
  except
    AddLogs('数据库关闭错误!');
  end;
end;



function TMainForm.Init:Boolean;
begin
  Result := True;
  try
    ADOQuery := TADOQuery.Create(nil);
    ADOConnection := TADOConnection.Create(nil);
    ADOConnection.ConnectionString := 'Provider=Microsoft.Jet.OLEDB.4.0;Data Source=' + DbPath +';Jet OLEDB:Database Password=';
    ADOConnection.LoginPrompt := false;
    ADOQuery.Connection := ADOConnection;
    ADOConnection.Open;
  except
    AddLogs('Access数据库打开失败!');
    Result := False;
  end;
  try
    UniConnection.Server := Ini.ReadIni('server','oracle');
    UniConnection.Username := Ini.ReadIni('server','username');
    UniConnection.Password := Ini.ReadIni('server','password');
    UniConnection.Open;
  except
    AddLogs('Oracle数据库打开失败!');
    Result := False;
  end;
end;
procedure TMainForm.AddLogs(Content:string);
begin
   if (LogClear.Checked) and (Logs.Lines.Count >= 100) then
   begin
       Logs.Lines.Clear;
   end;
   LogsUnit.addErrors(Content);
   Logs.Lines.Add(Content);
end;




procedure TMainForm.TimerReadTimer(Sender: TObject);
var
  C:Integer;
  A:Integer;
begin
    A := 0;
    C := 0;
    try
      UniQuery.SQL.Clear;
      UniQuery.SQL.Add('delete from AMEAVMESSAGE');
      UniQuery.ExecSQL;
      with ADOQuery do
      begin
        Close;
        Sql.Clear;
        Sql.Add('select * from Ameav_Message  order by tjsq');
        Open;
        First;
        UniQuery.SQL.Clear;
        UniQuery.SQL.Add('insert into AMEAVMESSAGE values (:aid,:mesname,:content1,:content2,:content3,:aboutname,:sources,:cjsj,:rjrq,:bc,:viewflag,:secretflag,:addtime,:replycontent,:replytime,:enviewflag,:idd,:sortname,:sortid,:tjsq,:tjr,:sfdb,:zrbm)');
        while not Eof do
        begin
          Inc(C);
          UniQuery.ParamByName('aid').Value :=  FieldByName('ID').AsString;
          UniQuery.ParamByName('mesname').Value :=  FieldByName('MesName').AsString;
          UniQuery.ParamByName('content1').Value :=  FieldByName('Content').AsString;
          UniQuery.ParamByName('content2').Value :=  FieldByName('Content2').AsString;
          UniQuery.ParamByName('content3').Value :=  FieldByName('Content3').AsString;
          UniQuery.ParamByName('aboutname').Value :=  FieldByName('aboutname').AsString;
          UniQuery.ParamByName('sources').Value :=  FieldByName('source').AsString;
          UniQuery.ParamByName('cjsj').Value :=  FieldByName('cjsj').AsString;
          UniQuery.ParamByName('rjrq').Value :=  DeDate(FieldByName('rjrq').AsString);
          UniQuery.ParamByName('bc').Value :=  FieldByName('bc').AsString;
          UniQuery.ParamByName('viewflag').Value :=  changeData(FieldByName('ViewFlag').AsString);
          UniQuery.ParamByName('secretflag').Value :=  changeData(FieldByName('SecretFlag').AsString);
          UniQuery.ParamByName('addtime').Value :=  FieldByName('AddTime').AsString;
          UniQuery.ParamByName('replycontent').Value :=  FieldByName('ReplyContent').AsString;
          UniQuery.ParamByName('replytime').Value :=  DeDate(FieldByName('ReplyTime').AsString);
          UniQuery.ParamByName('enviewflag').Value :=  changeData(FieldByName('enViewFlag').AsString);
          UniQuery.ParamByName('idd').Value :=  FieldByName('idd').AsString;
          UniQuery.ParamByName('sortname').Value :=  FieldByName('SortName').AsString;
          UniQuery.ParamByName('sortid').Value :=  FieldByName('Sortid').AsString;
          UniQuery.ParamByName('tjsq').Value :=  DeDate(FieldByName('tjsq').AsString);
          UniQuery.ParamByName('tjr').Value :=  FieldByName('tjr').AsString;
          UniQuery.ParamByName('sfdb').Value :=  changeData(FieldByName('sfdb').AsString);
          UniQuery.ParamByName('zrbm').Value :=  FieldByName('zrbm').AsString;
          try
            UniQuery.ExecSQL;
            Inc(A);
          except
          end;
          Next;
        end;
        Close;
        UniQuery.Close;
        if A > 0 then
        begin
            AddLogs('查询到'+IntToStr(C)+'条记录,插入'+IntToStr(A)+'条,'+IntToStr(C-A)+'条已存在！');
        end;

      end;
    except
      AddLogs('查询记录失败');
    end;
end;

procedure TMainForm.TimerTimer(Sender: TObject);
begin
  if Init then
  begin
    Timer.Enabled := False;
    AddLogs('数据库已打开,准备启动数据交换..');
    TimerRead.Interval := StrToInt(Ini.ReadIni('server','timer')) * 60 * 1000;
    AddLogs('数据交换时间间隔为'+Ini.ReadIni('server','timer')+'分钟..');
    TimerReadTimer(nil);
    TimerRead.Enabled := True;
  end;
end;

end.
