unit MainRunLib;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, PerlRegEx,Tools,ADODB,Uni, ExtCtrls,ErrorLogsUnit;

type
  
  TMainView = class(TForm)
    TimerInit: TTimer;
    mmoLogs: TMemo;
    procedure TimerInitTimer(Sender: TObject);
    procedure RunTimer(Sender: TObject);

  private
    { Private declarations }
  public
    { Public declarations }
    function  getStrFromExp(source:string):string;  //解析字符串，替换变量
    procedure InitTask(Task:TTask);
    function checkSqlTyep(sql:string):Boolean;//true,sql语句执行上一步中查询记录数次，false，执行1次
    function checkSqlSelect(sql:string):Boolean;//true ,sql语句是查询语句，false，sql语句是update、insert、delete语句。
    procedure addLogs(Log:string);
    procedure getFile(data:TDataSource); //获取到数据库文件
    function RandomStr(): string;   //随机数
  end;

var
  MainView: TMainView;
  Datas:TSourceArr;
  Tasks:TTaskArr;
implementation

{$R *.dfm}

function TMainView.RandomStr(): string;
var
  PicName: string;
  I: Integer;
begin
  Randomize;
  for I := 1 to 4 do
    PicName := PicName + chr(97 + random(26));
  RandomStr := PicName;
end;
procedure TMainView.addLogs(Log:string);
begin
    mmoLogs.Lines.Add(Log);
    ErrorLogsUnit.addErrors(Log);
end;
function TMainView.checkSqlSelect(sql:string):Boolean;//true ,sql语句是查询语句，false，sql语句是update、insert、delete语句。
begin
  if Pos('select',sql) = 0 then Result := False
  else Result := True;
end;
function TMainView.checkSqlTyep(sql:string):Boolean;//true,sql语句执行上一步中查询记录数次，false，执行1次
var
  RegEx : TPerlRegEx;
begin
  RegEx := TPerlRegEx.Create(Application);
  RegEx.RegEx := '.+:\w+';
  RegEx.Subject := sql;
  Result := RegEx.Match;
  RegEx.Free;
end;
procedure TMainView.getFile(data:TDataSource); //获取到数据库文件
var
  sr:TSearchRec;
  Path,Files,NewFile,Tmep : string;
  RegEx:TPerlRegEx;
begin
    //获取文件开始
    Path := getStrFromExp(data.Server);

    if Pos('^_^',data.DataBase) = 0 then
    begin
      if SysUtils.FindFirst(Path + '\*.*', faAnyFile, sr) = 0 then
      begin
        RegEx := TPerlRegEx.Create(Application);
        RegEx.RegEx := getStrFromExp(data.DataBase);
        repeat
          if (sr.Name<>'.') and (sr.Name<>'..') then
          begin
            RegEx.Subject := sr.Name;
            if RegEx.Match  then
            begin
                Files := Path + '\' + sr.Name;
            end;
          end;
        until SysUtils.FindNext(sr) <> 0;
        RegEx.Free;
        SysUtils.FindClose(sr);
      end;
    end
    else
    begin
        Tmep := Copy(data.DataBase,1,Length(data.DataBase)-3);
        Files := Path + '\' + Tmep;
    end;
    

    //获取文件结束

    if Files = '' then
    begin
       addLogs('数据源'+data.DataName + '对应的数据库文件('+data.Server +'/' + data.DataBase +')不存在！');
       Exit;
    end
    else
    begin
       addLogs('数据源'+data.DataName + '对应的数据库文件是:'+Files);
       data.FileName := RandomStr;
       NewFile :=  ExtractFileDir(PARAMSTR(0))+'\'+data.FileName+'.b';
       if CopyFile(PChar(Files),PChar(NewFile),False) then
       begin
           addLogs('数据源'+data.DataName + '复制为:'+NewFile);
       end
       else
       begin
          addLogs('数据源'+data.DataName + '复制错误:'+NewFile);
       end;
       data.FileName := ExtractFileDir(PARAMSTR(0))+'\'+data.FileName+'.ldb';
    end;



    //初始化连接开始
    try
      data.Connection.Database := NewFile;
      data.Connection.Open;
      addLogs('数据源'+data.DataName + '对应的文件打开了...');
    except
      addLogs('数据源'+data.DataName + '对应的文件打开失败...');
    end;
    //初始化连接结束
end;



function TMainView.getStrFromExp(source:string):string;  //解析字符串，替换变量
var
   RegEx,RegEx1:TPerlRegEx;
begin
   RegEx := TPerlRegEx.Create(Application);
   RegEx.RegEx := '\${[^}${]*}';
   RegEx.Subject := source;
   RegEx1 := TPerlRegEx.Create(Application);
   RegEx1.RegEx := '[^\${}]*';
   while RegEx.MatchAgain do
   begin
      RegEx1.Subject := RegEx.MatchedExpression;;
      if RegEx1.Match then
      begin
          RegEx.Replacement :=  FormatDateTime(RegEx1.MatchedExpression, now);
          RegEx.Replace;
      end;
   end;
   Result := RegEx.Subject;
   RegEx.Free;
   RegEx1.Free;
end;

procedure TMainView.InitTask(Task:TTask);
begin
    Task.Timer := TTimer.Create(Application);
    Task.Timer.Enabled := False;
    Task.Timer.Interval := Task.time * 1000;
    Task.Timer.Name := Task.name;
    Task.Timer.OnTimer := RunTimer;
    addLogs(Task.name + '启动完毕,执行周期' + InttoStr(Task.time) + '秒');
    Task.Timer.Enabled := True;
end;

procedure TMainView.RunTimer(Sender: TObject);
var
    Task : TTask;
    Data : TDataSource;
    I,K,J,Index :Integer;
    sql : string;
    StringArr :TStringArr;
    Query:TUniQuery;
begin
    Task := Tasks.Items[(Sender as TTimer).Name];
    if Task.isRun then Exit;
    Task.isRun := True;
    addLogs('开始执行'+Task.name + ',有' + InttoStr(Task.sql.Count) + '步.先检查连接是否都正常..');
    for I := 0 to Task.data.Count - 1 do
    begin
        Data := Datas.Items[Task.data[I]];
        if not Data.Connection.Connected then
        begin
            if (Data.DataType = 'Access') or ((Data.DataType = 'SQLite')) then
            begin
                getFile(Data);
            end
            else
            begin
                try
                   Data.Connection.Open;
                except
                   addLogs(Data.DataName + '打开失败，本次任务跳过..');
                end;
            end;
        end;
        if not Data.Connection.Connected then
        begin
          if (Data.DataType = 'Access') or (Data.DataType = 'SQLite') then
          begin
              DeleteFile(Data.Connection.Database);
              DeleteFile(Data.FileName);
          end;

          Task.isRun := False;
          Exit;
        end;
        if Task.UniQueryArr.Items[Task.data[I]] = nil then
        begin
           Query := TUniQuery.Create(Application);
           Query.Connection := Data.Connection;
           Task.UniQueryArr.Add(Task.data[I],query);
        end;
    end;



    for I := 0 to Task.sql.Count - 1 do
    begin
        sql := getStrFromExp(Task.sql[I]);
        Data := Datas.Items[Task.data[I]];
        Query := Task.UniQueryArr.Items[Task.data[I]];
        addLogs('执行'+sql);
        Query.Close;
        Query.SQL.Clear;
        Query.SQL.Add(sql);

        if checkSqlTyep(sql) then  //需要参数,并执行多次
        begin
          SetLength(Task.DataRows2,0);
          for J := 0 to Length(Task.DataRows1) - 1 do
          begin
              for K := 0 to Query.Params.Count - 1 do
              begin
                  Query.Params[K].Value := Task.DataRows1[J].Items[Query.Params[K].Name];
              end;
              addLogs(Task.name + '第' + InttoStr(I+1) + '步第'+InttoStr(J+1)+'次设置了'+InttoStr(K+1)+'个参数');
             //执行
             if checkSqlSelect(sql) then   //select
             begin
                    try
                      Query.Open;
                      Query.First;
                      addLogs(Task.name + '第' + InttoStr(I+1) + '步查询完毕！');
                    except
                      addLogs(Task.name + '第' + InttoStr(I+1) + '步查询失败:'+SysErrorMessage(GetLastError));
                    end;
                    index := 0;
                    while not Query.Eof do
                    begin
                        Inc(Index);
                        StringArr := TStringArr.Create;
                        for K := 0 to Query.Fields.Count - 1 do
                        begin
                            StringArr.Add(Query.Fields[K].FullName,Query.Fields[K].AsString);
                        end;
                        SetLength(Task.DataRows2,Length(Task.DataRows2)+1);
                        Task.DataRows2[Length(Task.DataRows2) - 1] := StringArr;
                        Query.Next;
                    end;
                    addLogs(Task.name + '第' + InttoStr(I+1) + '步第'+InttoStr(J+1)+'次查询'+InttoStr(Index) + '条记录');
                    Query.Close;
             end
             else
             begin
                 try
                    Query.ExecSQL;
                    addLogs(Task.name + '第' + InttoStr(I+1) + '步执行第'+InttoStr(J+1)+'次完毕！');
                 except
                    addLogs(Task.name + '第' + InttoStr(I+1) + '步执行第'+InttoStr(J+1)+'次发生异常:'+SysErrorMessage(GetLastError));
                 end;
             end;
          end;
          SetLength(Task.DataRows1,0);
          Task.DataRows1 := Task.DataRows2;
        end
        else
        begin
          if checkSqlSelect(sql) then   //查询，
          begin
                try
                  Query.Open;
                  Query.First;
                  addLogs(Task.name + '第' + InttoStr(I+1) + '步查询完毕！');
                except
                  addLogs(Task.name + '第' + InttoStr(I+1) + '步查询失败:'+SysErrorMessage(GetLastError));
                end;
                SetLength(Task.DataRows2,0);
                Index := 0;
                while not Query.Eof do
                begin
                    Inc(Index);
                    StringArr := TStringArr.Create;
                    for K := 0 to Query.Fields.Count - 1 do
                    begin
                        StringArr.Add(Query.Fields[K].FullName,Query.Fields[K].AsString);
                    end;
                    SetLength(Task.DataRows2,Length(Task.DataRows2)+1);
                    Task.DataRows2[Length(Task.DataRows2) - 1] := StringArr;
                    Query.Next;
                end;
                addLogs(Task.name + '第' + InttoStr(I+1) + '步查询'+InttoStr(Index) + '条记录');
              SetLength(Task.DataRows1,0);
              Task.DataRows1 := Task.DataRows2;
          end
          else
          begin
               try
                  Query.ExecSQL;
                  addLogs(Task.name + '第' + InttoStr(I+1) + '步执行完毕！');
               except
                  addLogs(Task.name + '第' + InttoStr(I+1) + '步执行发生异常:'+SysErrorMessage(GetLastError));
               end;
          end;
        end;

        if (Data.DataType = 'Access') or (Data.DataType = 'SQLite') then
        begin
            if Data.Connection.Connected then Data.Connection.Close;
            DeleteFile(Data.Connection.Database);
            DeleteFile(Data.FileName);
        end;
    end;
    Task.isRun := False;
end;

procedure TMainView.TimerInitTimer(Sender: TObject);
var
    I,Errors:Integer;
    sr:TSearchRec;
begin
    if not DirectoryExists(ExtractFileDir(PARAMSTR(0)) + '\logs') then  CreateDirectory(PChar(ExtractFilePath(ParamStr(0)) + '\logs'), nil);
    if not DirectoryExists(ExtractFileDir(PARAMSTR(0)) + '\task') then  CreateDirectory(PChar(ExtractFilePath(ParamStr(0)) + '\task'), nil);
    if not DirectoryExists(ExtractFileDir(PARAMSTR(0)) + '\data') then  CreateDirectory(PChar(ExtractFilePath(ParamStr(0)) + '\data'), nil);
    if SysUtils.FindFirst(ExtractFileDir(PARAMSTR(0)) + '\*.b', faAnyFile, sr) = 0 then
    begin
      repeat
        if (sr.Name<>'.') and (sr.Name<>'..') then
        begin
          DeleteFile(ExtractFileDir(PARAMSTR(0)) + '\'+sr.Name);
        end;
      until SysUtils.FindNext(sr) <> 0;
      SysUtils.FindClose(sr);
    end;
    if SysUtils.FindFirst(ExtractFileDir(PARAMSTR(0)) + '\*.ldb', faAnyFile, sr) = 0 then
    begin
      repeat
        if (sr.Name<>'.') and (sr.Name<>'..') then
        begin
          DeleteFile(ExtractFileDir(PARAMSTR(0)) + '\'+sr.Name);
        end;
      until SysUtils.FindNext(sr) <> 0;
      SysUtils.FindClose(sr);
    end;
    TimerInit.Enabled := False;
    Errors := 0;
    Datas := Tools.initData(Application);
    addLogs('加载了' + IntToStr(Datas.Count) + '个数据源,准备打开中...');
    for I := 0 to Datas.Count - 1 do
    begin
         try
            if (Datas.Values[I].DataType <> 'Access') and ((Datas.Values[I].DataType <> 'SQLite')) then
            begin
                Datas.Values[I].Connection.Open;
                addLogs(Datas.Keys[I] + '打开了..');
            end;
         except
            addLogs(Datas.Keys[I] + '打开失败！');
            Inc(Errors);
         end;
    end;
    if Errors > 0 then
    begin
       Exit;
    end;
    Tasks := Tools.getTasks;
    addLogs('加载了' + IntToStr(Tasks.Count) + '个任务,准备初始化...');
    for I := 0 to Tasks.Count - 1 do
    begin
        InitTask(Tasks.Values[I]);
    end;
end;

end.
