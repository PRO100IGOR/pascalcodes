unit TestLib;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls,ScktComp,Ini,Common;

type
  TTestForm = class(TForm)
    SERVERNAME: TEdit;
    Label1: TLabel;
    GROUPNAME: TEdit;
    Label2: TLabel;
    AddBtn: TButton;
    Logs: TMemo;
    ClearBtn: TButton;
    AutoClear: TCheckBox;
    ConBtn: TButton;
    procedure ClearBtnClick(Sender: TObject);
    procedure ConBtnClick(Sender: TObject);
    procedure AddBtnClick(Sender: TObject);
  private
    { Private declarations }
    ClientSocket : TClientSocket;
    procedure OnConnect(Sender: TObject; Socket: TCustomWinSocket);
    procedure OnDisconnect(Sender: TObject; Socket: TCustomWinSocket);
    procedure OnRead(Sender: TObject; Socket: TCustomWinSocket);
    procedure AddLogs(Content:string);
    function  RandomStr(): string;
  public
    { Public declarations }
  end;

var
  TestForm: TTestForm;

implementation

{$R *.dfm}

function TTestForm.RandomStr(): string;
var
  PicName: string;
  I: Integer;
begin
  Randomize;
  for I := 1 to 4 do
    PicName := PicName + chr(97 + random(26));
  RandomStr := PicName;
end;


procedure TTestForm.AddBtnClick(Sender: TObject);
var
  code:string;
begin
//  code := '{"device":[{"id":"'+RandomStr+'","device":[{"serverName":"'+SERVERNAME.Text +'","itemName":"'+GROUPNAME.Text +'"}]}]}^_^';
  code := '{"device":[{"id":"'+GROUPNAME.Text+'","device":[{"serverName":"'+SERVERNAME.Text +'","itemName":"'+GROUPNAME.Text +'"}]}]}^_^';
  ClientSocket.Socket.SendText(code);
end;

procedure TTestForm.AddLogs(Content:string);
begin
  if (AutoClear.Checked) and (Logs.Lines.Count >= 100) then
  begin
      Logs.Lines.Clear;
  end;
  Logs.Lines.Add(FormatDateTime('hh:mm:ss', now) + '  ' + Content);
end;
procedure TTestForm.ClearBtnClick(Sender: TObject);
begin
    Logs.Lines.Clear;
end;

procedure TTestForm.ConBtnClick(Sender: TObject);
begin
   if ConBtn.Caption = '连接' then
   begin
        ClientSocket := TClientSocket.Create(Application);
        ClientSocket.Port := StrToInt(Ini.ReadIni('server','port'));
        ClientSocket.Host := '127.0.0.1';
        ClientSocket.OnConnect := OnConnect;
        ClientSocket.OnDisconnect := OnDisconnect;
        ClientSocket.OnRead := OnRead;
        ClientSocket.Open;
        ConBtn.Enabled := False;
   end
   else
   begin
       ClientSocket.Close;
   end;
end;

procedure TTestForm.OnConnect(Sender: TObject; Socket: TCustomWinSocket);
begin
    ConBtn.Caption := '断开';
    ConBtn.Enabled := True;
    AddBtn.Enabled := True;
    AddLogs('连接成功...');
end;

procedure TTestForm.OnDisconnect(Sender: TObject; Socket: TCustomWinSocket);
begin
    //ClientSocket.Free;
    ClientSocket := nil;
    ConBtn.Caption := '连接';
    AddLogs('连接断开...');
end;
procedure TTestForm.OnRead(Sender: TObject; Socket: TCustomWinSocket);
begin
    AddLogs(Common.decode(Socket.ReceiveText));
end;

end.
