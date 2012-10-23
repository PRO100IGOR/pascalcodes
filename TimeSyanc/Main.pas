unit Main;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs,DateUtils,ComObj,ActiveX;

type

  TMainForm = class(TForm)
    procedure FormCreate(Sender: TObject);
  private
    R:Boolean;
  public
    procedure SetTime(DateTime: TDateTime);    //设置系统时间
    procedure Execute;
  end;

var
  MainForm: TMainForm;
  url   : string = 'http://cn.bing.com/';
  times : Integer = 10;
implementation

{$R *.dfm}
procedure TMainForm.Execute;
var
    I      : Integer;
    XmlHttp: Variant;
    Datetxt: string;
    DateLst: TStringList;
    mon    : string;
    timeGMT, GetNetTime: TDateTime;
begin
    I := 0;
    R := False;
    while I <= times do
    begin
      try
        XmlHttp := CreateOleObject('Microsoft.XMLHTTP');
        XmlHttp.Open('Get', url, False);
        XmlHttp.send;
        Datetxt := XmlHttp.getResponseHeader('Date');
        Datetxt := Copy(Datetxt, Pos(',', Datetxt) + 1, 100);
        Datetxt := StringReplace(datetxt, 'GMT', '', []);
        if Datetxt = '' then  Raise Exception.Create('错误了！');
        Datetxt := Trim(datetxt);
        DateLst := TStringList.Create;
        while Pos(' ', Datetxt) > 0 do
        begin
          DateLst.Add(Copy(Datetxt, 1, Pos(' ', Datetxt) - 1));
          Datetxt := Copy(Datetxt, Pos(' ', Datetxt) + 1, 100);
        end;
        DateLst.Add(Datetxt);
        if DateLst[1] = 'Jan' then
          mon := '01'
        else if DateLst[1] = 'Feb' then
          mon := '02'
        else if DateLst[1] = 'Mar' then
          mon := '03'
        else if DateLst[1] = 'Apr' then
          mon := '04'
        else if DateLst[1] = 'Mar' then
          mon := '05'
        else if DateLst[1] = 'Jun' then
          mon := '06'
        else if DateLst[1] = 'Jul' then
          mon := '07'
        else if DateLst[1] = 'Aug' then
          mon := '08'
        else if DateLst[1] = 'Sep' then
          mon := '09'
        else if DateLst[1] = 'Oct' then
          mon := '10'
        else if DateLst[1] = 'Nov' then
          mon := '11'
        else if DateLst[1] = 'Dec' then
          mon := '12';
        Datetxt := DateLst[2] + '-' + mon + '-' + DateLst[0] + ' ' + DateLst[3];
        timeGMT := StrToDateTime(DateLst[2] + '-' + mon + '-' + DateLst[0] + ' ' + DateLst[3]);
        GetNetTime := IncHour(TimeGMT, 8);
        I := times + 1;
        SetTime(GetNetTime);
        R := True;
      except
        Sleep(5000);
        Inc(I);
      end;
    end;
    if not R then
       Application.MessageBox('时间同步失败！', 'sorry', MB_OK + MB_ICONWARNING);
    Application.Terminate;
end;

procedure TMainForm.FormCreate(Sender: TObject);
begin
   Application.ShowMainForm := False;
   Execute;
end;

procedure TMainForm.SetTime(DateTime: TDateTime);
var
  ADateTime: TSystemTime;
  yy, mon, dd, hh, min, ss, ms: Word;
begin
  decodedate(DateTime, yy, mon, dd);
  decodetime(DateTime, hh, min, ss, ms);
  with ADateTime do
  begin
    wYear := yy;
    wMonth := mon;
    wDay := dd;
    wHour := hh;
    wMinute := min;
    wSecond := ss;
    wMilliseconds := ms;
  end;
  SetLocalTime(ADateTime);
end;

end.
