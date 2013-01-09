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
    function  getStrFromExp(source:string):string;  //�����ַ������滻����
    procedure InitTask(Task:TTask);
    function checkSqlTyep(sql:string):Boolean;//true,sql���ִ����һ���в�ѯ��¼���Σ�false��ִ��1��
    function checkSqlSelect(sql:string):Boolean;//true ,sql����ǲ�ѯ��䣬false��sql�����update��insert��delete��䡣
    procedure addLogs(Log:string);
    procedure getFile(data:TDataSource); //��ȡ�����ݿ��ļ�
    function RandomStr(): string;   //�����
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
function TMainView.checkSqlSelect(sql:string):Boolean;//true ,sql����ǲ�ѯ��䣬false��sql�����update��insert��delete��䡣
begin
  if Pos('select',sql) = 0 then Result := False
  else Result := True;
end;
function TMainView.checkSqlTyep(sql:string):Boolean;//true,sql���ִ����һ���в�ѯ��¼���Σ�false��ִ��1��
var
  RegEx : TPerlRegEx;
begin
  RegEx := TPerlRegEx.Create(Application);
  RegEx.RegEx := '.+:\w+';
  RegEx.Subject := sql;
  Result := RegEx.Match;
  RegEx.Free;
end;
procedure TMainView.getFile(data:TDataSource); //��ȡ�����ݿ��ļ�
var
  sr:TSearchRec;
  Path,Files,NewFile,Tmep : string;
  RegEx:TPerlRegEx;
begin
    //��ȡ�ļ���ʼ
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
    

    //��ȡ�ļ�����

    if Files = '' then
    begin
       addLogs('����Դ'+data.DataName + '��Ӧ�����ݿ��ļ�('+data.Server +'/' + data.DataBase +')�����ڣ�');
       Exit;
    end
    else
    begin
       addLogs('����Դ'+data.DataName + '��Ӧ�����ݿ��ļ���:'+Files);
       data.FileName := RandomStr;
       NewFile :=  ExtractFileDir(PARAMSTR(0))+'\'+data.FileName+'.b';
       if CopyFile(PChar(Files),PChar(NewFile),False) then
       begin
           addLogs('����Դ'+data.DataName + '����Ϊ:'+NewFile);
       end
       else
       begin
          addLogs('����Դ'+data.DataName + '���ƴ���:'+NewFile);
       end;
       data.FileName := ExtractFileDir(PARAMSTR(0))+'\'+data.FileName+'.ldb';
    end;



    //��ʼ�����ӿ�ʼ
    try
      data.Connection.Database := NewFile;
      data.Connection.Open;
      addLogs('����Դ'+data.DataName + '��Ӧ���ļ�����...');
    except
      addLogs('����Դ'+data.DataName + '��Ӧ���ļ���ʧ��...');
    end;
    //��ʼ�����ӽ���
end;



function TMainView.getStrFromExp(source:string):string;  //�����ַ������滻����
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
    addLogs(Task.name + '�������,ִ������' + InttoStr(Task.time) + '��');
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
    addLogs('��ʼִ��'+Task.name + ',��' + InttoStr(Task.sql.Count) + '��.�ȼ�������Ƿ�����..');
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
                   addLogs(Data.DataName + '��ʧ�ܣ�������������..');
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
        addLogs('ִ��'+sql);
        Query.Close;
        Query.SQL.Clear;
        Query.SQL.Add(sql);

        if checkSqlTyep(sql) then  //��Ҫ����,��ִ�ж��
        begin
          SetLength(Task.DataRows2,0);
          for J := 0 to Length(Task.DataRows1) - 1 do
          begin
              for K := 0 to Query.Params.Count - 1 do
              begin
                  Query.Params[K].Value := Task.DataRows1[J].Items[Query.Params[K].Name];
              end;
              addLogs(Task.name + '��' + InttoStr(I+1) + '����'+InttoStr(J+1)+'��������'+InttoStr(K+1)+'������');
             //ִ��
             if checkSqlSelect(sql) then   //select
             begin
                    try
                      Query.Open;
                      Query.First;
                      addLogs(Task.name + '��' + InttoStr(I+1) + '����ѯ��ϣ�');
                    except
                      addLogs(Task.name + '��' + InttoStr(I+1) + '����ѯʧ��:'+SysErrorMessage(GetLastError));
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
                    addLogs(Task.name + '��' + InttoStr(I+1) + '����'+InttoStr(J+1)+'�β�ѯ'+InttoStr(Index) + '����¼');
                    Query.Close;
             end
             else
             begin
                 try
                    Query.ExecSQL;
                    addLogs(Task.name + '��' + InttoStr(I+1) + '��ִ�е�'+InttoStr(J+1)+'����ϣ�');
                 except
                    addLogs(Task.name + '��' + InttoStr(I+1) + '��ִ�е�'+InttoStr(J+1)+'�η����쳣:'+SysErrorMessage(GetLastError));
                 end;
             end;
          end;
          SetLength(Task.DataRows1,0);
          Task.DataRows1 := Task.DataRows2;
        end
        else
        begin
          if checkSqlSelect(sql) then   //��ѯ��
          begin
                try
                  Query.Open;
                  Query.First;
                  addLogs(Task.name + '��' + InttoStr(I+1) + '����ѯ��ϣ�');
                except
                  addLogs(Task.name + '��' + InttoStr(I+1) + '����ѯʧ��:'+SysErrorMessage(GetLastError));
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
                addLogs(Task.name + '��' + InttoStr(I+1) + '����ѯ'+InttoStr(Index) + '����¼');
              SetLength(Task.DataRows1,0);
              Task.DataRows1 := Task.DataRows2;
          end
          else
          begin
               try
                  Query.ExecSQL;
                  addLogs(Task.name + '��' + InttoStr(I+1) + '��ִ����ϣ�');
               except
                  addLogs(Task.name + '��' + InttoStr(I+1) + '��ִ�з����쳣:'+SysErrorMessage(GetLastError));
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
    addLogs('������' + IntToStr(Datas.Count) + '������Դ,׼������...');
    for I := 0 to Datas.Count - 1 do
    begin
         try
            if (Datas.Values[I].DataType <> 'Access') and ((Datas.Values[I].DataType <> 'SQLite')) then
            begin
                Datas.Values[I].Connection.Open;
                addLogs(Datas.Keys[I] + '����..');
            end;
         except
            addLogs(Datas.Keys[I] + '��ʧ�ܣ�');
            Inc(Errors);
         end;
    end;
    if Errors > 0 then
    begin
       Exit;
    end;
    Tasks := Tools.getTasks;
    addLogs('������' + IntToStr(Tasks.Count) + '������,׼����ʼ��...');
    for I := 0 to Tasks.Count - 1 do
    begin
        InitTask(Tasks.Values[I]);
    end;
end;

end.
