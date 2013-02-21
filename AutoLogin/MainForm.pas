unit MainForm;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, Ini,TLHelp32, ExtCtrls, CoolTrayIcon, Menus,ErrorLogsUnit,
  TextTrayIcon;

type
  TMain = class(TForm)
    Timer: TTimer;
    PopupMenu1: TPopupMenu;
    N1: TMenuItem;
    N4: TMenuItem;
    CoolTrayIcon: TCoolTrayIcon;
    procedure TimerTimer(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure N4Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
    procedure Login;
    procedure ClearWarn;
    procedure AddLog(V:string);
  end;

var
  Main: TMain;

  FilePath,TitleText,UserName,PassWord,UserNameClass,PasswordClass,LoginClass,ClassNameNeedFind,ExeName,TitleClass,WarnTitle,WarnClass:string;
  
  UserNameIndex,PasswordIndex,LoginIndex :Integer;
  
  hwnds  : array of HWND;     //找到的句柄集合

  ShowLogs,WarnNeed:Boolean;
implementation

{$R *.dfm}
function EnumWindowsProc(HwndFind:HWND;lParam:DWORD):boolean; stdcall;
var
  ClassNameTemp :PChar;
  CTemp:string;
begin
    GetMem(ClassNameTemp,128);
    GetClassName(HwndFind,ClassNameTemp,128);
    CTemp := LowerCase(ClassNameTemp);
    if CTemp = ClassNameNeedFind then
    begin
        SetLength(hwnds,Length(hwnds) + 1);
        hwnds[Length(hwnds) - 1] := HwndFind;
    end;
    FreeMem(ClassNameTemp);
    Result := True;
end;


function GetHWndByPIDSource(ProgressName: string): Integer;
var
  ProcessName: string; 
  FSnapshotHandle: THandle;
  FProcessEntry32: TProcessEntry32;
  ContinueLoop: BOOL;
begin
  Result := 0;
  FSnapshotHandle := CreateToolhelp32Snapshot(TH32CS_SNAPPROCESS, 0);
  FProcessEntry32.dwSize := Sizeof(FProcessEntry32);
  ContinueLoop := Process32First(FSnapshotHandle, FProcessEntry32);
  while ContinueLoop do
  begin
    ProcessName := FProcessEntry32.szExeFile;
    if (ProcessName = ProgressName) then begin
      Inc(Result);
    end;
    ContinueLoop := Process32Next(FSnapshotHandle, FProcessEntry32);
  end;
  CloseHandle(FSnapshotHandle);
end;
procedure TMain.AddLog(V:string);
begin
    if ShowLogs then
       ErrorLogsUnit.addErrors(V);
end;

procedure TMain.FormCreate(Sender: TObject);
begin
    Application.ShowMainForm := False;
    if not DirectoryExists(ExtractFileDir(PARAMSTR(0)) + '\logs') then  CreateDirectory(PChar(ExtractFilePath(ParamStr(0)) + '\logs'), nil);
    ExeName :=   Ini.ReadIni('server','ExeName');

    FilePath :=  Ini.ReadIni('server','FilePath');

    TitleText := Ini.ReadIni('server','TitleText');


    TitleClass := Ini.ReadIni('server','TitleClass');

    UserName := Ini.ReadIni('server','UserName');
    UserNameClass := LowerCase(Ini.ReadIni('server','UserNameClass'));
    UserNameIndex := StrToInt(Ini.ReadIni('server','UserNameIndex'));

    PassWord := Ini.ReadIni('server','PassWord');
    PasswordClass := LowerCase(Ini.ReadIni('server','PasswordClass'));
    PasswordIndex := StrToInt(Ini.ReadIni('server','PasswordIndex'));

    LoginClass := LowerCase(Ini.ReadIni('server','LoginClass'));
    LoginIndex := StrToInt(Ini.ReadIni('server','LoginIndex'));

    ShowLogs := Ini.ReadIni('server','ShowLogs') = 'True';

    WarnNeed := Ini.ReadIni('server','WarnNeed') = 'True';
    WarnTitle := Ini.ReadIni('server','WarnTitle');
    WarnClass := LowerCase(Ini.ReadIni('server','WarnClass'));

    Timer.Interval := StrToInt(Ini.ReadIni('server','Time')) * 1000 * 60;
    Timer.Enabled := True;


end;
procedure TMain.ClearWarn;
var
   WarnHwnd : LongWord;
begin
     if WarnNeed then
     begin
        WarnHwnd := FindWindow(PChar(WarnClass),PChar(WarnTitle));
        FindWindowA
        if WarnHwnd <> 0 then
        begin
           AddLog('找到警告窗体');
           SendMessage(WarnHwnd,WM_CLOSE,0,0);
           AddLog('关闭了警告窗体！');
        end
        else
          AddLog('找不到警告窗体');
     end;
end;
procedure TMain.Login;
var
   AA,BB,CC,WindwoHwnd,ParentWnd : LongWord;
   A,B,C:PChar;
begin
    WinExec(PChar(FilePath),SW_SHOW);

    Sleep(5000);

    WindwoHwnd := FindWindow(PChar(TitleClass),PChar(TitleText));
    ParentWnd := GetParent(WindwoHwnd);
    if ParentWnd<>GetDesktopWindow then
       SetWindowPos(WindwoHwnd,HWND_TOPMOST,0,0,0,0,SWP_NOMOVE or SWP_NOSIZE);
    if WindwoHwnd <> 0 then
    begin
       AddLog('程序启动完毕');

       //找username
       ClassNameNeedFind := UserNameClass;
       SetLength(hwnds,0);
       EnumChildWindows(WindwoHwnd,@EnumWindowsProc,0);
       if (Length(hwnds) > 0) and (UserNameIndex < Length(hwnds)) then
       begin

          AA := hwnds[UserNameIndex];
          SendMessage(AA,WM_SETTEXT,0,LPARAM(UserName));
          GetMem(A,128);
          GetWindowText(AA,A,128);
          AddLog('用户名句柄:'+ IntToStr(AA)+',赋值为:'+A);
          FreeMem(A);
       end;

       //找password
       ClassNameNeedFind := PasswordClass;
       SetLength(hwnds,0);
       EnumChildWindows(WindwoHwnd,@EnumWindowsProc,0);
       if (Length(hwnds) > 0) and (PasswordIndex < Length(hwnds)) then
       begin
          BB := hwnds[PasswordIndex];
          SendMessage(BB,WM_SETTEXT,0,LPARAM(PassWord));
          GetMem(B,128);
          GetWindowText(BB,B,128);
          AddLog('密码句柄:'+ IntToStr(BB)+',赋值为:'+B);
          FreeMem(B);
       end;

       //找登录按钮
       ClassNameNeedFind := LoginClass;
       SetLength(hwnds,0);
       EnumChildWindows(WindwoHwnd,@EnumWindowsProc,0);
       if (Length(hwnds) > 0) and (LoginIndex < Length(hwnds)) then
       begin
          CC := hwnds[LoginIndex];
          SendMessage(CC,WM_LBUTTONDOWN,0,0);
          SendMessage(CC,WM_LBUTTONUP,0,0);

          GetMem(C,128);
          GetWindowText(CC,C,128);
          AddLog('按钮句柄:'+ IntToStr(CC)+',其LABLE为:'+C);
          FreeMem(C);
       end;
       //结束
    end
    else
       AddLog('找不到窗体！');
end;

procedure TMain.N4Click(Sender: TObject);
begin
    Close;
end;

procedure TMain.TimerTimer(Sender: TObject);
begin
    if GetHWndByPIDSource(ExeName) = 0 then
       Login
    else
       ClearWarn;
end;

end.
