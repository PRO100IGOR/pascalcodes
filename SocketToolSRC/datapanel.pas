unit datapanel;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, NMUDP, StdCtrls, ExtCtrls, ComCtrls,ScktComp,winsock,
  WinSkinData, SUIButton, XComDrv;
const
  WM_SOCK = WM_USER + 1;     //自定义windows消息 ,for udp group
type
  TFrmData = class(TForm)
    GroupBox1: TGroupBox;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    Label6: TLabel;
    Panel2: TPanel;
    Panel4: TPanel;
    GroupBox3: TGroupBox;
    Memo2: TMemo;
    GroupBox2: TGroupBox;
    Panel6: TPanel;
    Label7: TLabel;
    ComboBox2: TComboBox;
    StatusBar2: TStatusBar;
    Memo3: TMemo;
    GroupBox8: TGroupBox;
    CheckBox2: TCheckBox;
    ClientSocket1: TClientSocket;
    Button5: TsuiButton;
    Button6: TsuiButton;
    Button2: TsuiButton;
    Button11: TsuiButton;
    ClientSocket2: TClientSocket;
    ckwebsvr: TCheckBox;
    XComm1: TXComm;
    Timer1: TTimer;
    suiButton1: TsuiButton;
    suiButton2: TsuiButton;
    Label8: TLabel;
    Edit1: TEdit;

    procedure Button2Click(Sender: TObject);
    procedure CheckBox2Click(Sender: TObject);
    procedure Memo3KeyPress(Sender: TObject; var Key: Char);
    procedure Button5Click(Sender: TObject);
    procedure Button6Click(Sender: TObject);
    procedure Button11Click(Sender: TObject);
    procedure Button6MouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure XComm1Data(Sender: TObject; const Received: Cardinal);
    procedure Timer1Timer(Sender: TObject);
    procedure suiButton1Click(Sender: TObject);
    procedure suiButton2Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
    G_SndCnt:integer;
    G_RecvCnt:integer;
    owner:tobject;
    procedure  OnGroupRead(var Message: TMessage); message WM_SOCK;    
  end;

var
  FrmData: TFrmData;
  function HexToStr(i:integer):string;
  function strtohex(s:string):integer;
implementation

uses Unit1;

{$R *.dfm}

function HexToStr(i:integer):string;
var tmp:string;
begin
  tmp:='0123456789ABCDEF ';
  result:=tmp[(i div 16)+1]+tmp[(i mod 16)+1];
end;

function TextToHexStr(s:string):string;
var i:integer;
    ss:string;
begin
  ss:='';
  for i:=1 to length(s) do
  begin
    ss:=ss+hextostr(ord(s[i]))+' ';
  end;
  result:=ss;
end;

function strtohex(s:string):integer;
var tmp:string;
    i,j,a,b:integer;
begin
  if s='' then
  begin
    result:=0;
    exit;
  end;
  s:=uppercase(s);

  a:=0;
  tmp:='0123456789ABCDEF ';
  for j:=1 to length(s) do
  begin
   if s[j]=' ' then s[j]:='0';
   i:=1;
   while i<=16 do
   begin
    if tmp[i]=s[j] then
    begin
       b:=i-1;
       break;
    end;
    i:=i+1;
   end;
   a:=a*16+b;
  end;
  result:=a;
end;

procedure SendUDPPacket(udp:tnmudp;s:string);
var
  MyStream: TMemoryStream;
  TmpStr: String;
  i:integer;
  len:integer;

  buf:array[1..1500] of char;
Begin
//  udp.SendBuffer(buf,0);
  TmpStr := s;
  MyStream := TMemoryStream.Create;
  len:=length(s);
  mystream.SetSize(len);
  try
    MyStream.Write(TmpStr[1], Length(s));
    UDP.SendStream(MyStream);
  finally
    MyStream.Free;
  end;
end;

procedure SendGroupData(mysock:tmysocket;Content: String);
var
  value{,hostname}: string;
  len: integer;
begin
  //FSockAddrIn.SIn_Addr.S_addr := INADDR_BROADCAST;
  mysock.FSockAddrIn.SIn_Addr.S_addr := inet_addr(pchar(mysock.groupaddr));
  value := Content;
  len := sendto(mysock.groupsock, value[1], Length(value), 0, mysock.FSockAddrIn, sizeof(mysock.FSockAddrIn));
  if (WSAGetLastError() <> WSAEWOULDBLOCK) and (WSAGetLastError() <> 0) then
    showmessage(inttostr(WSAGetLastError()));
  if len = SOCKET_ERROR then
    showmessage('send fail');
  if len <> Length(value) then
    showmessage('Not Send all');
end;

procedure SendText(form:tfrmdata;s:string);
var   tip:string;
      i:integer;
      csock:tclientsocket;
      custsock:tcustomwinsocket;
      value{,hostname}: string;
      r,len: integer;
begin
  if (form.owner as tmysocket).SocketType='TCP Client' then
  begin
   csock:=(form.owner as tmysocket).SocketPtr as tclientsocket;
   r:=0;
   while r<=0 do
   begin
     r:=csock.socket.SendText(s);
     if r>0 then break;
     application.ProcessMessages;
     Sleep(10);
   end;
  end;
  if (form.owner as tmysocket).SocketType='TCP ServerClient' then
  begin
   custsock:=(form.owner as tmysocket).SocketPtr as tcustomwinsocket;
   //custsock.SendText(s);
   r:=0;
   while r<=0 do
   begin
     r:=custsock.SendText(s);
     if r>0 then break;
     application.ProcessMessages;
     Sleep(10);
   end;
  end;
  if (form.owner as tmysocket).SocketType='UDP Client' then
  begin
   sendudppacket((form.owner as tmysocket).udpsock,s);
  end;
  if (form.owner as tmysocket).SocketType='UDP Server' then
  begin
   sendudppacket((form.owner as tmysocket).udpserver,s);
  end;
  if (form.owner as tmysocket).SocketType='UDP Group' then
  begin
    sendgroupdata(form.owner as tmysocket,s);
  end;
end;

procedure TFrmData.Button11Click(Sender: TObject);
var i,k:integer;
    s,hexstr:string;
begin
    s:=memo3.text;

    if checkbox2.Checked then
    begin
             s:='';
             for k:=1 to (length(memo3.text) div 2) do
             begin
               s:=s+chr(strtohex(copy(memo3.text,(k-1)*2+1,2)));
             end;
    end;
    if s='' then exit;

    memo2.Lines.Add(timetostr(now)+' 发送数据：'+hexstr+s+'['+combobox2.text+'次]');
    memo3.lines.Clear;
    statusbar2.Panels[0].Text:='收：'+inttostr(G_recvcnt)+'字节，发:'+inttostr(g_sndcnt)+'字节';

    for i:=1 to strtoint(combobox2.text) do
    begin
       SendText(self,s);
       G_SndCnt:=G_SndCnt+length(s);
       application.ProcessMessages;
    end;

    hexstr:='';
    if checkbox2.Checked then
    begin
      hexstr:='{';
      for i:=1 to length(s) do
      begin
       hexstr:=hexstr+hextostr(ord(s[i]))+' ';
      end;
      hexstr:=hexstr+'}';
    end;
end;

procedure TFrmData.Button2Click(Sender: TObject);
begin
   G_SndCnt:=0;
   G_RecvCnt:=0;
   statusbar2.Panels[0].Text:='收：'+inttostr(G_recvcnt)+'字节，发:'+inttostr(g_sndcnt)+'字节';
end;

procedure TFrmData.CheckBox2Click(Sender: TObject);
begin
   if checkbox2.Checked then groupbox2.Caption:='数据发送窗口[HEX模式]'
   else groupbox2.Caption:='数据发送窗口(文本模式)';
end;

procedure TFrmData.Memo3KeyPress(Sender: TObject; var Key: Char);
var editmask:string;
begin
 if checkbox2.Checked then
 begin
  editmask:='0123456789ABCDEFabcdef';
  if key=chr(8) then exit;
  if pos(key,editmask)=0 then key:=chr(0);
 end;
end;

procedure TFrmData.OnGroupRead(var Message: TMessage);
begin
  (owner as tmysocket).OnGroupRead(message); 
end;

procedure TFrmData.Button5Click(Sender: TObject);
var    MySocket:tmysocket;
begin
//  exit;
  
  MySocket:=owner as TMySocket;
  if MySocket.SocketType='TCP Server' then
  begin
    try
     (MySocket.SocketPtr as tserversocket).Open;
     MySocket.NodePtr.StateIndex:=3;
     mysocket.LinkStatus:=1;

    except
      showmessage('Socket端口已经被占用!');
    end;
    mysocket.DisplayStatus;
  end;
  if MySocket.SocketType='TCP Client' then
  begin
    try
     (MySocket.SocketPtr as tclientsocket).Open;
//     MySocket.LinkStatus:=1;
     mysocket.LocalPort:=(mysocket.SocketPtr as tclientsocket).socket.LocalPort;
     mysocket.DisplayStatus;
    except
     showmessage('连接失败!');
    end;
  end;
end;

procedure TFrmData.Button6Click(Sender: TObject);
var  MySocket:tmysocket;
     i:integer;
begin
{
  exit;
  exit;
  exit;

  MySocket:=owner as tmysocket;
  if MySocket.SocketType='TCP Server' then
  begin
     for i:=0 to  (MySocket.SocketPtr as tserversocket).Socket.ActiveConnections-1 do
     begin
       (MySocket.SocketPtr as tserversocket).Socket.Connections[i].Close;
     end;
     (MySocket.SocketPtr as tserversocket).close;
     mysocket.LinkStatus:=0;
     mysocket.DisplayStatus;
     MySocket.NodePtr.StateIndex:=4;
  end;
  if MySocket.SocketType='TCP Client' then
  begin
   form1.Button6Click(sender);
   exit;
   try
     (MySocket.SocketPtr as tclientsocket).Close;
     MySocket.LinkStatus:=0;
     mysocket.DisplayStatus;
   except
   end;
  end;
  if MySocket.SocketType='TCP ServerClient' then
  begin
   form1.Button6Click(sender);
   exit;

    try
     MySocket.LinkStatus:=0;
     mysocket.DisplayStatus;
     (MySocket.SocketPtr as tcustomwinsocket).Close;
    except
    end;
  end;
  }
end;


procedure TFrmData.Button6MouseUp(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
var  MySocket:tmysocket;
     i:integer;
begin
  MySocket:=owner as tmysocket;
  if MySocket.SocketType='TCP Server' then
  begin
     for i:=0 to  (MySocket.SocketPtr as tserversocket).Socket.ActiveConnections-1 do
     begin
       (MySocket.SocketPtr as tserversocket).Socket.Connections[i].Close;
     end;
     (MySocket.SocketPtr as tserversocket).close;
     mysocket.LinkStatus:=0;
     mysocket.DisplayStatus;
     MySocket.NodePtr.StateIndex:=4;
  end;
  if MySocket.SocketType='TCP Client' then
  begin
   form1.Button6Click(sender);
   exit;
   try
     (MySocket.SocketPtr as tclientsocket).Close;
     MySocket.LinkStatus:=0;
     mysocket.DisplayStatus;
   except
   end;
  end;
  if MySocket.SocketType='TCP ServerClient' then
  begin
   form1.Button6Click(sender);
   exit;

    try
     MySocket.LinkStatus:=0;
     mysocket.DisplayStatus;
     (MySocket.SocketPtr as tcustomwinsocket).Close;
    except
    end;
  end;
end;

procedure TFrmData.XComm1Data(Sender: TObject; const Received: Cardinal);
var s:string;
    i:integer;
begin
  xcomm1.ReadString(s);
  if s<>'' then
  begin
    //for i:=1 to length(s) do
    begin
      SendText(self,s);
      //sleep(100);      
    end;
  end;
end;

procedure TFrmData.Timer1Timer(Sender: TObject);
var i,k:integer;
    s,hexstr:string;
begin
    s:=memo3.text;

    if checkbox2.Checked then
    begin
             s:='';
             for k:=1 to (length(memo3.text) div 2) do
             begin
               s:=s+chr(strtohex(copy(memo3.text,(k-1)*2+1,2)));
             end;
    end;
    if s='' then exit;

    memo2.Lines.Add(timetostr(now)+' 发送数据：'+hexstr+s+'['+combobox2.text+'次]');
//    memo3.lines.Clear;
    statusbar2.Panels[0].Text:='收：'+inttostr(G_recvcnt)+'字节，发:'+inttostr(g_sndcnt)+'字节';

    for i:=1 to strtoint(combobox2.text) do
    begin
       SendText(self,s);
       G_SndCnt:=G_SndCnt+length(s);
       application.ProcessMessages;
    end;

    hexstr:='';
    if checkbox2.Checked then
    begin
      hexstr:='{';
      for i:=1 to length(s) do
      begin
       hexstr:=hexstr+hextostr(ord(s[i]))+' ';
      end;
      hexstr:=hexstr+'}';
    end;
end;

procedure TFrmData.suiButton1Click(Sender: TObject);
begin
  timer1.Interval:=strtoint(edit1.text);
  timer1.enabled:=true;
end;

procedure TFrmData.suiButton2Click(Sender: TObject);
begin
  timer1.enabled:=false;
end;

end.
