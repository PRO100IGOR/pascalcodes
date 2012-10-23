unit GetInternetTime;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ComObj, DateUtils;

type
  TForm1 = class(TForm)
    Button1: TButton;
    procedure Button1Click(Sender: TObject);
  private

  public
    function GetInternetTime:string;
  end;

var
  Form1: TForm1;

implementation

{$R *.dfm}

procedure TForm1.Button1Click(Sender: TObject);
var
  InternetTime:string;
begin
  InternetTime:=GetInternetTime;
  ShowMessage(InternetTime);
end;



function TForm1.GetInternetTime:string;
var
  XmlHttp: Variant;
  datetxt: string;
  DateLst: TStringList;
  mon: string;
  timeGMT, GetNetTime: TDateTime;
  s: string;
begin
  XmlHttp := CreateOleObject('Microsoft.XMLHTTP');
  XmlHttp.Open('Get', 'http://www.baidu.com/', False);
  XmlHttp.send;
  datetxt := XmlHttp.getResponseHeader('Date');
  datetxt := Copy(datetxt, Pos(',', datetxt) + 1, 100);
  datetxt := StringReplace(datetxt, 'GMT', '', []);
  datetxt := Trim(datetxt);
  DateLst := TStringList.Create;
  while Pos(' ', datetxt) > 0 do
  begin
    DateLst.Add(Copy(datetxt, 1, Pos(' ', datetxt) - 1));
    datetxt := Copy(datetxt, Pos(' ', datetxt) + 1, 100);

  end;
  DateLst.Add(datetxt);
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
  s := DateLst[2] + '-' + mon + '-' + DateLst[0] + ' ' + DateLst[3];
//标准时间
//  ShowMessage(s);
// '/' or '-'
  timeGMT := StrToDateTime(DateLst[2] + '-' + mon + '-' + DateLst[0] + ' ' + DateLst[3]);
  //转换时区
  GetNetTime := IncHour(TimeGMT, 8);
//  ShowMessage(FormatDateTime('yyyy年mm月dd日 HH:NN:SS', GetNetTime));
  Result:= FormatDateTime('yyyy年mm月dd日 HH:NN:SS', GetNetTime);
end;

end.

