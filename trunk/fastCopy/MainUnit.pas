unit MainUnit;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ExtCtrls, StdCtrls, CoolTrayIcon, Menus,ShellApi,Ini;
const
  WM_TrayIcon = WM_USER + 1280;
type
  TMain = class(TForm)
    Timer: TTimer;
    Logs: TMemo;
    CoolTrayIcon: TCoolTrayIcon;
    PopupMenu1: TPopupMenu;
    N1: TMenuItem;
    N2: TMenuItem;
    N3: TMenuItem;
    N4: TMenuItem;
    procedure N4Click(Sender: TObject);
    procedure N2Click(Sender: TObject);
    procedure N3Click(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormCreate(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure CoolTrayIconDblClick(Sender: TObject);
    procedure TimerTimer(Sender: TObject);
    procedure FormHide(Sender: TObject);
  private
    { Private declarations }
    IconData: TNotifyIconData;
  public
    { Public declarations }
    procedure AddIconToTray;
    procedure DelIconFromTray;
  end;

var
  Main: TMain;
  ServerDescription: ShortString;
  Cl,shows:Boolean;
  fileFrom,fileTo : string;
implementation

{$R *.dfm}
procedure TMain.AddIconToTray;
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
procedure TMain.CoolTrayIconDblClick(Sender: TObject);
begin
  if shows then Hide
  else Show;
end;

procedure TMain.DelIconFromTray;
begin
  Shell_NotifyIcon(NIM_DELETE, @IconData);
end;
procedure TMain.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  if not Cl then
  begin
    Hide;
    Abort;
  end;
end;

procedure TMain.FormCreate(Sender: TObject);
begin
    Cl := False;
    fileFrom := Ini.ReadIni('server','fileFrom');
    fileTo := Ini.ReadIni('server','fileTo');
    Timer.Enabled := True;
end;

procedure TMain.FormHide(Sender: TObject);
begin
  shows := False;
end;

procedure TMain.FormShow(Sender: TObject);
begin
    shows := True;
end;

procedure TMain.N2Click(Sender: TObject);
begin
    Show;
end;

procedure TMain.N3Click(Sender: TObject);
begin
    Hide;
end;

procedure TMain.N4Click(Sender: TObject);
begin
     DelIconFromTray;
     Cl := True;
     Close;
end;

procedure TMain.TimerTimer(Sender: TObject);
var
  sr:TSearchRec;
begin
    Application.ProcessMessages;
    if SysUtils.FindFirst(fileFrom + '\*', faAnyFile, sr) = 0 then
    begin
      repeat
        if (sr.Name<>'.') and (sr.Name<>'..') then
        begin
          CopyFile(PChar(fileFrom + '\' + sr.Name),PChar(fileTo + '\' + sr.Name),False);
          if Logs.Lines.Count > 200 then Logs.Lines.Clear;
          
          Logs.Lines.Add(FormatDateTime('hh:mm:ss', now) + ' ∏¥÷∆¡À:' + sr.Name);
        end;
      until SysUtils.FindNext(sr) <> 0;
      SysUtils.FindClose(sr);
    end;
end;

end.
