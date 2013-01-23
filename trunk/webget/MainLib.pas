unit MainLib;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, WebLIb,SHDocVw, Menus, CoolTrayIcon,ShellApi, ExtCtrls,Ini,ErrorLogsUnit,Common;
const
  WM_TrayIcon = WM_USER + 1280;
type
  TMainForm = class(TForm)
    CoolTrayIcon: TCoolTrayIcon;
    PopupMenu1: TPopupMenu;
    N1: TMenuItem;
    N2: TMenuItem;
    N3: TMenuItem;
    N4: TMenuItem;
    Log: TMemo;
    Timer: TTimer;
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormCreate(Sender: TObject);
    procedure FormHide(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure N2Click(Sender: TObject);
    procedure N3Click(Sender: TObject);
    procedure N4Click(Sender: TObject);
    procedure TimerTimer(Sender: TObject);
    procedure CoolTrayIconDblClick(Sender: TObject);
  private
    { Private declarations }
    IconData: TNotifyIconData;
  public
    { Public declarations }
    procedure doweb(Sender: TObject);
    procedure AddIconToTray;
    procedure DelIconFromTray;
    procedure AddLog(logName:String);
    procedure exec;
  end;

var
  MainForm: TMainForm;
  WebForm2 :TWebForm;    //WebForm2 报表查
  ServerDescription: ShortString;
  Cl,shows,isBusy:Boolean;     //cl=是关闭还是隐藏 shows=是否正显示
  path,user,pass:string;
  needs :StringArray;  //需要取的报表编号
  needIndex,MainHtml : Integer; //取到第几个报表了  MainHtml main页面要加载7次
implementation

{$R *.dfm}

procedure TMainForm.AddLog(logName:String);
var
   temp:string;
begin
    temp := FormatDateTime('hh:mm:ss', now) + ' : ' + logName;
    if Log.Lines.Count > 500 then  Log.Lines.Clear;
    Log.Lines.Add(temp);
    //ErrorLogsUnit.addErrors(temp);
end;
procedure TMainForm.CoolTrayIconDblClick(Sender: TObject);
begin
  if shows then Hide
  else Show;
end;

procedure TMainForm.AddIconToTray;
begin
    ZeroMemory(@IconData, SizeOf(TNotifyIconData));
    IconData.cbSize := SizeOf(TNotifyIconData);
    IconData.Wnd := Handle;
    IconData.uID := 1;
    IconData.uFlags := NIF_MESSAGE or NIF_ICON or NIF_TIP;
    IconData.uCallbackMessage := WM_TrayIcon;
    IconData.hIcon := Application.Icon.Handle;
    StrPCopy(IconData.szTip, ServerDescription);
    Shell_NotifyIcon(NIM_ADD, @IconData);
end;
procedure TMainForm.DelIconFromTray;
begin
  Shell_NotifyIcon(NIM_DELETE, @IconData);
end;
procedure TMainForm.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  if not Cl then
  begin
    Hide;
    Abort;
  end;
end;
procedure TMainForm.FormCreate(Sender: TObject);
var
   I:Integer;
begin
   if not DirectoryExists(ExtractFileDir(PARAMSTR(0)) + '\logs') then  CreateDirectory(PChar(ExtractFilePath(ParamStr(0)) + '\logs'), nil);
   if not DirectoryExists(ExtractFileDir(PARAMSTR(0)) + '\html') then  CreateDirectory(PChar(ExtractFilePath(ParamStr(0)) + '\html'), nil);
    Cl := False;
    isBusy := False;
    needIndex := 0;
    path := Ini.ReadIni('server','path');
    user := Ini.ReadIni('server','user');
    pass := Ini.ReadIni('server','pass');
    needs := Common.Split(Ini.ReadIni('server','need'),',');
    Timer.Interval := StrToInt(Ini.ReadIni('server','time')) * 60 * 1000;
    Timer.Enabled := True;
    for I := 0 to Length(needs) - 1 do
    begin
        if not DirectoryExists(ExtractFileDir(PARAMSTR(0)) + '\html\' + needs[I]) then  CreateDirectory(PChar(ExtractFilePath(ParamStr(0)) + '\html\' + needs[I]), nil);
    end;

    WebForm := TWebForm.Create(Application);
    WebForm.Show;
    WebForm.WebBrowser.Tag := 1;
    WebForm2 :=  TWebForm.Create(Application);
    WebForm2.Show;
    WebForm.WebBrowser.Tag := 2;
end;
procedure TMainForm.FormHide(Sender: TObject);
begin
    shows := False;
end;
procedure TMainForm.FormShow(Sender: TObject);
begin
    shows := True;
end;
procedure TMainForm.N2Click(Sender: TObject);
begin
   show;
end;
procedure TMainForm.N3Click(Sender: TObject);
begin
   Hide;
end;
procedure TMainForm.N4Click(Sender: TObject);
begin
     DelIconFromTray;
     Cl := True;
     WebForm2.Close;
     WebForm.Close;
     Close;
end;
procedure TMainForm.TimerTimer(Sender: TObject);
begin
  if isBusy then Exit;
  isBusy := True;
  AddLog('正在打开' + path);
  WebForm.WebBrowser.Navigate(path);
end;

procedure TMainForm.exec;
begin
    if needIndex = Length(needs) then
    begin
       AddLog('重新开始...');
       needIndex := 0;
       MainHtml := 0;
       isBusy := False;
    end
    else
    begin
       AddLog('点击第' + IntToStr(needIndex + 1) + '个链接');
       WebForm.WebBrowser.OleObject.document.parentWindow.go(StrToInt(needs[needIndex]) - 1);
    end;
end;




procedure TMainForm.doweb(Sender: TObject);
var
  WebBrowser: TWebBrowser;
  temp:string;
  Aline:TStrings;
begin
    WebBrowser := Sender as  TWebBrowser;
    try
        temp := WebBrowser.OleObject.document.location;
        AddLog('打开了' + temp);
        if Pos('ieframe.dll',Temp) > 0 then
        begin
           AddLog('无法打开页面...');
           needIndex := Length(needs);
           Exit;
        end;
       WebBrowser.OleObject.document.parentWindow.execScript('window.onerror = function(){return false;}','JavaScript');
       if Pos('Login.aspx',Temp) > 0 then
       begin
          AddLog('准备登录...');
          if WebBrowser.Tag = 1 then
          begin
              needIndex := 0;
              MainHtml := 0;
          end;
          WebBrowser.OleObject.document.getElementById('czgbm').value := user;
          WebBrowser.OleObject.document.getElementById('password').value := pass;
          WebBrowser.OleObject.document.getElementById('Button2').click();
       end
       else if Pos('main.htm',Temp) > 0 then
       begin
           Inc(MainHtml);
           if MainHtml = 7 then
           begin
               WebForm.WebBrowser.OleObject.document.parentWindow.execScript('window.go=function(index){window.frames["mainFrame"].document.getElementById("Label_Report").getElementsByTagName("a")[index].click();}','JavaScript');
               exec;
           end;
       end
       else if Pos('/Report/',Temp) > 0 then
       begin
          AddLog('打开了第' + IntToStr(needIndex + 1) + '个报表...');
          WebBrowser.OleObject.document.parentWindow.execScript('window.go=function(){var a = document.getElementById("__EVENTVALIDATION").parentNode.nextSibling;a.removeChild(a.childNodes[0]);return a.innerHTML};','JavaScript');
          temp := WebBrowser.OleObject.document.parentWindow.go();
          Aline := TStringList.Create;
          Aline.Add('<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd"><html><head><title>日报</title><meta http-equiv="content-type" content="text/html;charset=gbk"></head><body>');
          Aline.Add(temp);
          Aline.Add('</body></html>');
          Aline.SaveToFile(ExtractFileDir(PARAMSTR(0))+ '\html\'+ needs[needindex] + '\'+FormatDateTime('yyyy-MM-dd', now) +  '.html');
          Inc(needIndex);
          exec;
       end;
    except
        AddLog('发生异常:' + SysErrorMessage(GetLastError));
    end;
end;

end.
