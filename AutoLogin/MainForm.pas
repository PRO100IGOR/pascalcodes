unit MainForm;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls,Ini,TLHelp32, ExtCtrls, CoolTrayIcon, Menus;

type
  TMain = class(TForm)
    Timer: TTimer;
    CoolTrayIcon: TCoolTrayIcon;
    PopupMenu1: TPopupMenu;
    N1: TMenuItem;
    N4: TMenuItem;
    procedure TimerTimer(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure N4Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
    procedure Login;
  end;

var
  Main: TMain;

  FilePath,TitleText,UserName,PassWord,UserNameClass,PasswordClass,LoginClass,ClassNameNeedFind,ExeName:string;
  
  UserNameIndex,PasswordIndex,LoginIndex :Integer;
  
  hwnds  : array of HWND;     //ÕÒµ½µÄ¾ä±ú¼¯ºÏ
  WindwoHwnd : HWND;          //´°Ìå¾ä±ú
  TitleClass : PChar;
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
  MyHwnd: THandle;
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


procedure TMain.FormCreate(Sender: TObject);
begin
    Application.ShowMainForm := False;

    ExeName :=   Ini.ReadIni('server','ExeName');

    FilePath :=  Ini.ReadIni('server','FilePath');

    TitleText := Ini.ReadIni('server','TitleText');
    TitleClass := PChar(Ini.ReadIni('server','TitleClass'));

    UserName := Ini.ReadIni('server','UserName');
    UserNameClass := LowerCase(Ini.ReadIni('server','UserNameClass'));
    UserNameIndex := StrToInt(Ini.ReadIni('server','UserNameIndex'));

    PassWord := Ini.ReadIni('server','PassWord');
    PasswordClass := LowerCase(Ini.ReadIni('server','PasswordClass'));
    PasswordIndex := StrToInt(Ini.ReadIni('server','PasswordIndex'));

    LoginClass := LowerCase(Ini.ReadIni('server','LoginClass'));
    LoginIndex := StrToInt(Ini.ReadIni('server','LoginIndex'));
end;

procedure TMain.Login;
var
   ProcID: Cardinal;
   HwndHold : LongWord;
begin
    WinExec(PChar(FilePath),SW_SHOW);

    Sleep(5000);

    WindwoHwnd := FindWindow(TitleClass,PChar(TitleText));
    if WindwoHwnd <> 0 then
    begin

       //ÕÒusername
       ClassNameNeedFind := UserNameClass;
       SetLength(hwnds,0);
       EnumChildWindows(WindwoHwnd,@EnumWindowsProc,0);
       if (Length(hwnds) > 0) and (UserNameIndex < Length(hwnds)) then
       begin
          HwndHold := hwnds[UserNameIndex];
          SendMessage(HwndHold,WM_SETTEXT,0,LPARAM(UserName));
       end;

       //ÕÒpassword
       ClassNameNeedFind := PasswordClass;
       SetLength(hwnds,0);
       EnumChildWindows(WindwoHwnd,@EnumWindowsProc,0);
       if (Length(hwnds) > 0) and (PasswordIndex < Length(hwnds)) then
       begin
          HwndHold := hwnds[PasswordIndex];
          SendMessage(HwndHold,WM_SETTEXT,0,LPARAM(PassWord));
       end;

       //ÕÒµÇÂ¼°´Å¥
       ClassNameNeedFind := LoginClass;
       SetLength(hwnds,0);
       EnumChildWindows(WindwoHwnd,@EnumWindowsProc,0);
       if (Length(hwnds) > 0) and (LoginIndex < Length(hwnds)) then
       begin
          HwndHold := hwnds[LoginIndex];
          SendMessage(HwndHold,WM_LBUTTONDOWN,0,0);
          SendMessage(HwndHold,WM_LBUTTONUP,0,0);
       end;
       //½áÊø
    end;
end;

procedure TMain.N4Click(Sender: TObject);
begin
    Close;
end;

procedure TMain.TimerTimer(Sender: TObject);
begin
    if GetHWndByPIDSource(ExeName) = 0 then
       Login;
end;

end.
