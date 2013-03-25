unit MainLib;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ExtCtrls,IniFiles, UniProvider, MySQLUniProvider, DB, MemDS,
  DBAccess, Uni,Ini;

type



  TMainForm = class(TForm)
    Timer: TTimer;
    UniConnection: TUniConnection;
    UniQuery: TUniQuery;
    MySQLUniProvider: TMySQLUniProvider;
    procedure FormCreate(Sender: TObject);
    procedure TimerTimer(Sender: TObject);
    procedure FormClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;
var
  MainForm: TMainForm;

implementation

{$R *.dfm}

function  getAllFilesFromDir(dir:string;p:string):TStrings; //从指定目录获取到全部指定类型文件
var
  sr:TSearchRec;
  temp:TStrings;
begin
    temp := TStringList.Create;
    if SysUtils.FindFirst(dir + '\'+p, faAnyFile, sr) = 0 then
    begin
      repeat
        if (sr.Name<>'.') and (sr.Name<>'..') then
        begin
          temp.Add(sr.Name);
        end;
      until SysUtils.FindNext(sr) <> 0;
      SysUtils.FindClose(sr);
    end;
    Result := temp;
end;



procedure TMainForm.FormClick(Sender: TObject);
begin
ShowMessage(Ini.ReadIni('','cc'));
end;

procedure TMainForm.FormCreate(Sender: TObject);
begin
//   try
//      UniConnection.Server   := Ini.ReadIni('server','ip');
//      UniConnection.Port     :=  Ini.ReadIni('server','port');
//      UniConnection.Username := Ini.ReadIni('server','user');
//      UniConnection.Password := Ini.ReadIni('server','pass');
//   except
//   end;
//   Timer.Interval := 1000 * 60 * 60 * 24;
//   Timer.Enabled := True;

end;

procedure TMainForm.TimerTimer(Sender: TObject);
var
  Files : TStrings;
  I:Integer;
  IniFile: TIniFile;
begin
  Files := getAllFilesFromDir(ExtractFileDir(PARAMSTR(0)) + '\tasks\','*.ini');
  if not UniConnection.Connected then UniConnection.Open;
  for I := 0 to Files.Count - 1 do
  begin
      IniFile := TIniFile.Create(ExtractFileDir(PARAMSTR(0)) + '\tasks\' + Files[I]);

      
  end;  
end;

end.
