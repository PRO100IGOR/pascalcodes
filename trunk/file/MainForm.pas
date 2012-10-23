unit MainForm;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, RzLstBox, ComCtrls, ExtCtrls, InvokeRegistry, Rio,
  SOAPHTTPClient,FlowrunServer, ImgList,ShellApi,Entry, OleCtrls, SHDocVw,MSHTML,
  IdBaseComponent, IdComponent, IdTCPConnection, IdTCPClient, IdHTTP,IdCookieManager,
  Menus, CoolTrayIcon, TextTrayIcon;
const
  WM_TrayIcon = WM_USER + 1280;
type
  TMain = class(TForm)
    Image2: TImage;
    out: TButton;
    btndomain: TButton;
    Timer: TTimer;
    HTTPRIO: THTTPRIO;
    ListView: TListView;
    HideBtn: TButton;
    btnExit: TButton;
    IdHTTP: TIdHTTP;
    CoolTrayIcon: TCoolTrayIcon;
    PopupMenu1: TPopupMenu;
    N1: TMenuItem;
    N2: TMenuItem;
    N3: TMenuItem;
    procedure TimerTimer(Sender: TObject);
    procedure outClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure HideBtnClick(Sender: TObject);
    procedure btnExitClick(Sender: TObject);
    procedure btndomainClick(Sender: TObject);
    procedure CoolTrayIconStartup(Sender: TObject; var ShowMainForm: Boolean);
  private
    { Private declarations }
    IconData: TNotifyIconData;
    procedure TrayIconMessage(var Msg: TMessage); message WM_TrayIcon;
  public
    { Public declarations }
    procedure AddIconToTray;
    procedure DelIconFromTray;
  end;

var
  Main: TMain;
  path,ipath:string;
  ServerDescription: ShortString;
implementation

uses
    login,Tip;
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

procedure TMain.DelIconFromTray;
begin
  Shell_NotifyIcon(NIM_DELETE, @IconData);
end;

procedure TMain.TrayIconMessage(var Msg: TMessage);
begin
  if (Msg.LParam = WM_LBUTTONUP) then
    Main.Visible := not Main.Visible;
end;

procedure TMain.btndomainClick(Sender: TObject);
begin
    Hide;
    ShellExecute(handle, 'open', 'explorer.exe', pChar('http://'+login.ip+':'+login.port+'/oxhide/'), nil, SW_SHOWNORMAL);
end;

procedure TMain.btnExitClick(Sender: TObject);
begin
  if Application.MessageBox('确定退出？', '请问', MB_OKCANCEL + MB_ICONWARNING) = 1 then
  begin
      Timer.Enabled := False;
      LoginForm.Close;
  end
  else
  begin
    Abort();
  end;
end;

procedure TMain.CoolTrayIconStartup(Sender: TObject; var ShowMainForm: Boolean);
begin
   ShowMainForm:=false;
   ServerDescription := '来文提醒';
end;

procedure TMain.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  if Application.MessageBox('确定退出？', '请问', MB_OKCANCEL + MB_ICONWARNING) = 1 then
  begin
      Timer.Enabled := False;
      DelIconFromTray;
      LoginForm.Close;
  end
  else
  begin
    Abort();
  end;
end;

procedure TMain.HideBtnClick(Sender: TObject);
begin
  Hide;
end;

procedure TMain.outClick(Sender: TObject);
begin
  if Application.MessageBox('确定更换用户吗？', '请问', MB_OKCANCEL + MB_ICONWARNING) = 1 then
  begin
      Timer.Enabled := False;
      if TipForm <> nil then
        TipForm.Close;
      LoginForm.Show;
  end;
end;

procedure TMain.TimerTimer(Sender: TObject);
var
  AFlowrunServer:FlowrunServerPortType;
  FlowRunProcessArray:ArrayOfFlowRunProcess;
  I,has:Integer;
  ListItem:TListItem;
  AFlowRunProcess:FlowRunProcess;
  labels:string;
begin
  try
    AFlowrunServer := GetFlowrunServerPortType(True,path,HTTPRIO);
    FlowRunProcessArray := AFlowrunServer.getFlowCount(login.eid);
    AFlowrunServer._Release;
    ListView.Items.Clear;
    has := 0;
    for I := 0 to Length(FlowRunProcessArray) - 1 do
    begin
       ListItem := ListView.Items.Add();
       AFlowRunProcess := FlowRunProcessArray[I];
       ListItem.Caption := AFlowRunProcess.flowRun.runId;
       ListItem.SubItems.Add(InttoStr(I+1));
       ListItem.SubItems.Add(AFlowRunProcess.flowRun.runName ) ;
       ListItem.SubItems.Add(AFlowRunProcess.beginUser ) ;
       ListItem.SubItems.Add(AFlowRunProcess.processCreateTime);
       if has < 5 then
          labels := labels +  InttoStr(I+1)+':'+AFlowRunProcess.flowRun.runName + #13;
       Inc(has);
    end;
    if not Self.Visible then
    begin
        if ((TipForm <> nil) and  not TipForm.Visible) or (TipForm = nil)  then
        begin
            if Length(FlowRunProcessArray) > 0 then
            begin
                  CoolTrayIcon.Hint := '您有' + IntToStr(Length(FlowRunProcessArray)) + '份公文需要处理！';
                  if TipForm = nil then
                       TipForm := TTipForm.Create(Application);
                  TipForm.header.Caption := '您有' + IntToStr(Length(FlowRunProcessArray)) + '份公文需要处理！';
                  TipForm.lblcontent.Caption := labels;
                  TipForm.Top := Screen.WorkAreaHeight;
                  //TipForm.Height := 0;
                  while TipForm.Top > Screen.WorkAreaHeight - 250 do begin
                    TipForm.Top := TipForm.Top - 1;
                    //TipForm.Height := TipForm.Height + 1;
                    TipForm.Left := Screen.WorkAreaWidth - TipForm.Width - 1;
                  end;
                  TipForm.show;
            end;
        end;
    end;
  except


  end;


end;

end.
