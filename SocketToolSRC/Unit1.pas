unit Unit1;

interface

uses
  Windows, shellapi,Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, NMUDP,ExtCtrls, ComCtrls, StdCtrls,ScktComp,Contnrs,datapanel, ImgList,
  IdBaseComponent, IdComponent, netcardinfo,IdUDPBase, IdUDPServer,winsock,
  WinSkinData, IdUDPClient, Buttons, jpeg, SUIImagePanel, SUIButton,
  OleCtrls, SHDocVw, XComDrv;

const
  WM_SOCK = WM_USER + 1;     //自定义windows消息 ,for udp group

type
//---------udp group--------
  ip_mreq = record
    imr_multiaddr: in_addr;  (* IP multicast address of group *)
    imr_interface: in_addr;  (* local IP address of interface *)
  end;
  TIpMReq = ip_mreq;
  PIpMReq = ^ip_mreq;
//---------udp group--------


  PMySocket = ^TMySocket;
  TMySocket = class(TObject)
  private

  public
   PipePtr:TMysocket;
   CreateTime:string;
   SocketType:string;
   SocketPtr:TObject;
   NodePtr:TTreeNode;
   LinkStatus:integer;
   LocalPort:integer;
   LocalIP:string;
   RemotePort:integer;
   RemoteIP:string;
   DataForm:TFrmData;
   udpsock:tnmudp;
   udpserver:tnmudp;
   //------------
    groupsock: TSocket;
    addr: TSockAddr;
    FSockAddrIn : TSockAddrIn;
    mreq:ip_mreq;

    groupport:integer; //UDP group端口号
    groupaddr:string; //udp group地址
   //-----------
   Procedure  OnTcpServerClientConnect(Sender: TObject;Socket: TCustomWinSocket);
   Procedure  OnTcpServerClientDisConnect(Sender: TObject;Socket: TCustomWinSocket);
   Procedure  OnTcpClientConnect(Sender: TObject;Socket: TCustomWinSocket);
   Procedure  OnTcpClientDisConnect(Sender: TObject;Socket: TCustomWinSocket);

   procedure  OnTcpServerRead(Sender: TObject;Socket: TCustomWinSocket);
   Procedure  OnTcpClientRead(Sender: TObject;Socket: TCustomWinSocket);
   Procedure  OnUDPRead(Sender: TComponent;NumberBytes: Integer; FromIP: String; Port: Integer);
   Procedure  OnUDPServerRead(Sender: TComponent;NumberBytes: Integer; FromIP: String; Port: Integer);
   procedure  OnGroupRead(var Message: TMessage); //message WM_SOCK;
   procedure  onSockErr(Sender: TObject; Socket: TCustomWinSocket; ErrorEvent: TErrorEvent; var ErrorCode: Integer);
   procedure  onClientSockErr(Sender: TObject; Socket: TCustomWinSocket; ErrorEvent: TErrorEvent; var ErrorCode: Integer);

   procedure  DisplayStatus;

//   Procedure  OnTcpServerClientDisconnect;
//   Procedure  OnTcpClientDisconnect;

//   Procedure Init;
  end;


  TForm1 = class(TForm)
    Panel1: TPanel;
    Panel2: TPanel;
    TreeView1: TTreeView;
    Splitter1: TSplitter;
    ImageList1: TImageList;
    StatusBar1: TStatusBar;
    Panel3: TPanel;
    suiImagePanel1: TsuiImagePanel;
    Button5: TSpeedButton;
    Button6: TSpeedButton;
    Button1: TsuiButton;
    Button2: TsuiButton;
    Button8: TsuiButton;
    Panel4: TPanel;
    Panel5: TPanel;
    Image1: TImage;
    Image2: TImage;
    Label1: TLabel;
    Memo1: TMemo;
    Label2: TLabel;
    Memo2: TMemo;
    Panel6: TPanel;
    Label3: TLabel;
    ImageList2: TImageList;
    Image3: TImage;
    WebStr2: TMemo;
    WebStr1: TMemo;
    procedure Button1Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormActivate(Sender: TObject);
    procedure TreeView1Change(Sender: TObject; Node: TTreeNode);
    procedure Button5Click(Sender: TObject);
    procedure Button6Click(Sender: TObject);
    procedure Button8Click(Sender: TObject);
    procedure Label1Click(Sender: TObject);
    procedure Label2Click(Sender: TObject);
    procedure Label3Click(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure Image1Click(Sender: TObject);
    procedure Image2Click(Sender: TObject);
    procedure TreeView1DragOver(Sender, Source: TObject; X, Y: Integer;
      State: TDragState; var Accept: Boolean);
    procedure TreeView1DragDrop(Sender, Source: TObject; X, Y: Integer);
  private
    { Private declarations }
  public
    { Public declarations }
  end;



var
  Form1: TForm1;
  MySocketList:TObjectList;

implementation

uses newserversock, newclientsock, newudpsock, newgroupsock,newudpserver;

{$R *.dfm}

procedure TMySocket.OnUDPRead(Sender: TComponent;NumberBytes: Integer; FromIP: String; Port: Integer);
var
  MyStream: TMemoryStream;
  buf,Str,hexstr: String;
  cmd:byte;
  i:integer;
begin
  if NumberBytes=-1 then
  begin
    exit;
  end;
  MyStream := TMemoryStream.Create;
  try
    UDPSock.ReadStream(MyStream);
    SetLength(Str,NumberBytes);
    MyStream.Read(Str[1],NumberBytes);
  finally
    MyStream.Free;
  end;


     buf:=str;
     hexstr:='';
     if DataForm.checkbox2.Checked then
     begin
      hexstr:='{';
      for i:=1 to length(buf) do
      begin
       hexstr:=hexstr+hextostr(ord(buf[i]))+' ';
      end;
      hexstr:=hexstr+'}';
     end;

     DataForm.memo2.Lines.Add(timetostr(now)+' 收到数据：'+hexstr+buf);
     DataForm.g_recvcnt:=DataForm.g_recvcnt+length(buf);

     DataForm.statusbar2.Panels[0].Text:='收：'+inttostr(DataForm.G_recvcnt)+'字节，发:'+inttostr(DataForm.g_sndcnt)+'字节';

end;


procedure TMySocket.OnUDPServerRead(Sender: TComponent;NumberBytes: Integer; FromIP: String; Port: Integer);
var
  MyStream: TMemoryStream;
  buf,Str,hexstr: String;
  cmd:byte;
  i:integer;
begin
  if NumberBytes=-1 then
  begin
    exit;
  end;
  MyStream := TMemoryStream.Create;
  try
    UDPServer.ReadStream(MyStream);
    SetLength(Str,NumberBytes);
    MyStream.Read(Str[1],NumberBytes);
  finally
    MyStream.Free;
  end;

     buf:=str;
     hexstr:='';
     if DataForm.checkbox2.Checked then
     begin
      hexstr:='{';
      for i:=1 to length(buf) do
      begin
       hexstr:=hexstr+hextostr(ord(buf[i]))+' ';
      end;
      hexstr:=hexstr+'}';
     end;

     DataForm.memo2.Lines.Add(timetostr(now)+' 收到数据：'+hexstr+buf);
     DataForm.g_recvcnt:=DataForm.g_recvcnt+length(buf);

     DataForm.statusbar2.Panels[0].Text:='收：'+inttostr(DataForm.G_recvcnt)+'字节，发:'+inttostr(DataForm.g_sndcnt)+'字节';

     //--------------
     udpserver.RemoteHost:=FromIP;
     udpserver.RemotePort:=Port;
     remoteip:=fromip; remoteport:=port;
     DisplayStatus;
     //--------------


     if DataForm.XComm1.Opened then
     begin
//        for i:=1 to length(buf) do
        begin
           DataForm.XComm1.SendString(buf);
          //Sleep(100);
        end;
     end;
     
end;

procedure TForm1.Button1Click(Sender: TObject);
var mysocket:tmysocket;
    serversocket:TServerSocket;
    clientsocket:TClientSocket;
    treenode:ttreenode;
    i:integer;
    ret:integer;
    TempWSAData: TWSAData;
    
  //  keepalive:tcp_keepalive;
 //   t:DWORD;
begin
  if treeview1.Selected=nil then exit;
  if treeview1.Selected.parent<>nil then
  begin
    treeview1.Selected.Parent.Selected:=true;
  end;

  if treeview1.Selected.Text='TCP Server' then
  begin
    if  frmNewServerSock=nil then frmNewServerSock:=TFrmNewServerSock.Create(nil);
    ret:=frmNewServerSock.showmodal;
    if ret=mrOK then
    begin

     mysocket:=tmysocket.Create;
     mysocket.SocketType:='TCP Server';

     //create winsock
     serversocket:=TServerSocket.Create(nil);
     serversocket.Port:=serverport;
     mysocket.SocketPtr:=serversocket;
     serversocket.Socket.Data:=mysocket;

     mysocket.LocalPort:=serverport;
     mysocket.LocalIP:=getlocalip;
     mysocket.CreateTime:=datetimetostr(now);

     serversocket.OnClientConnect:=mysocket.OnTcpServerClientConnect;
     serversocket.OnClientDisConnect:=mysocket.OnTcpServerClientDisConnect;
     serversocket.OnClientRead:=mysocket.OnTcpServerRead;
     serversocket.Socket.OnErrorEvent:=mysocket.onSockErr;
     serversocket.Socket.OnClientError:=mysocket.onClientSockErr;

     //create treenode
     treenode:=TreeView1.Items.AddChild(TreeView1.Selected,getlocalip+'['+inttostr(serverport)+']');
     TreeView1.Selected.Expand(false);
     treenode.Data:=mysocket;
     treenode.imageIndex:=-1;
     treenode.StateIndex:=4;
     mysocket.NodePtr:=treenode;
     treenode.Selected:=true;

     //open serversocket
     try
       serversocket.open;
       mysocket.linkstatus:=1;
       treenode.StateIndex:=3;
     except
       showmessage('该端口已被占用,监听未启动!');
     end;

     //create datapanel
     mysocket.DataForm:=tfrmData.Create(nil);
     mysocket.DataForm.owner:=mysocket;
     mysocket.DataForm.ckwebsvr.Visible:=true;


     mysocket.displaystatus;
     
     MySocketList.Add(mysocket);
    end;
  end;

  if treeview1.Selected.Text='TCP Client' then
  begin
    if  frmNewClientSock=nil then frmNewClientSock:=TFrmNewClientSock.Create(nil);
    ret:=frmNewClientSock.showmodal;
    if ret=mrOK then
    begin
     mysocket:=tmysocket.Create;
     mysocket.SocketType:='TCP Client';
     mysocket.CreateTime:=datetimetostr(now);
     //create winsock
     clientsocket:=TClientSocket.Create(nil);
     clientsocket.Port:=clientsock_remoteport;
     clientsocket.Host:=clientsock_remotehost;
     mysocket.SocketPtr:=clientsocket;

     mysocket.RemotePort:=clientsock_remoteport;
     mysocket.RemoteIP:=clientsock_remotehost;
 
     clientsocket.Socket.Data:=mysocket;
     clientsocket.OnConnect:=mysocket.OnTcpClientConnect;
     clientsocket.OnDisConnect:=mysocket.OnTcpClientDisConnect;
     clientsocket.OnRead:=mysocket.OnTcpClientRead;
     clientsocket.OnError:=mysocket.onSockErr;


   //  WSAIoctl(clientsocket.Socket.SocketHandle, SIO_KEEPALIVE_VALS,   @keekalive,   SizeOf(tcp_keepalive),
   //   nil,   0,   t,   nil,   nil);

     //create datapanel
     mysocket.DataForm:=tfrmData.Create(nil);
     mysocket.DataForm.owner:=mysocket;

     //create treenode
     treenode:=TreeView1.Items.AddChild(TreeView1.Selected,clientsock_remotehost+'['+inttostr(clientsock_remoteport)+']');
     TreeView1.Selected.Expand(false);
     treenode.Data:=mysocket;
     treenode.StateIndex:=2;
     mysocket.NodePtr:=treenode;
     treenode.Selected:=true;
     mysocket.DisplayStatus;
     MySocketList.Add(mysocket);
    end;
  end;

  if treeview1.Selected.Text='UDP Client' then
  begin
    if  frmNewUDPSock=nil then frmNewUDPSock:=TFrmNewUDPSock.Create(nil);
    ret:=frmNewUDPSock.showmodal;
    if ret=mrOK then
    begin

     mysocket:=tmysocket.Create;
     mysocket.SocketType:='UDP Client';
     mysocket.CreateTime:=datetimetostr(now);
     //create udp
     mysocket.udpsock:=TNmudp.Create(nil);
     mysocket.udpsock.LocalPort:=udpsock_localport;
     mysocket.udpsock.RemotePort:=udpsock_remoteport;
     mysocket.udpsock.RemoteHost:=udpsock_remotehost;
     mysocket.udpsock.OnDataReceived:=mysocket.onudpread;

     mysocket.SocketPtr:=mysocket.udpsock;
     mysocket.LocalPort:=mysocket.udpsock.LocalPort;

     //mysocket.LocalIP:=
     mysocket.RemotePort:=udpsock_remoteport;
     mysocket.RemoteIP:=udpsock_remotehost;
     //udpsocket.Data:=mysocket;
     //udpsocket.OnRead:=mysocket.OnUDPRead;
     //create datapanel
     mysocket.DataForm:=tfrmData.Create(nil);
     mysocket.DataForm.owner:=mysocket;

     //create treenode
     treenode:=TreeView1.Items.AddChild(TreeView1.Selected,udpsock_remotehost+'['+inttostr(udpsock_remoteport)+']');
     TreeView1.Selected.Expand(false);
     treenode.Data:=mysocket;
     treenode.StateIndex:=5;
     mysocket.NodePtr:=treenode;
     treenode.Selected:=true;
     mysocket.DisplayStatus;
     MySocketList.Add(mysocket);
    end;
  end;

  if treeview1.Selected.Text='UDP Server' then
  begin
    if  frmNewUDPServer=nil then frmNewUDPServer:=TFrmNewUDPServer.Create(nil);
    ret:=frmNewUDPServer.showmodal;
    if ret=mrOK then
    begin
     mysocket:=tmysocket.Create;
     mysocket.SocketType:='UDP Server';
     mysocket.CreateTime:=datetimetostr(now);
     //create udp
     mysocket.udpserver:=TNmudp.Create(nil);
     mysocket.udpserver.LocalPort:=udpserver_localport;
//     mysocket.udpserver.RemotePort:=udpserver_remoteport;
     mysocket.udpserver.RemoteHost:='';//udpserver_remotehost;
     mysocket.udpserver.OnDataReceived:=mysocket.onudpserverread;

     mysocket.SocketPtr:=mysocket.udpserver;
     mysocket.LocalPort:=mysocket.udpserver.LocalPort;

     //mysocket.LocalIP:=
     mysocket.RemotePort:=udpsock_remoteport;
     mysocket.RemoteIP:='';//udpsock_remotehost;
     //create datapanel
     mysocket.DataForm:=tfrmData.Create(nil);
     mysocket.DataForm.owner:=mysocket;


     mysocket.DataForm.xcomm1.BaudRate:=brcustom;
     mysocket.DataForm.xcomm1.BaudValue:=28800;
     mysocket.DataForm.xcomm1.DeviceName:='com1';
  mysocket.DataForm.xcomm1.FlowControl :=fcCustom;//fcrtscts;//fcnone;//
  mysocket.DataForm.xcomm1.DTRSettings := [fsDTREnabled];
  mysocket.DataForm.xcomm1.RTSSettings:= [fsRTSEnabled];

  mysocket.DataForm.xcomm1.Timeouts.WriteConstant:=500;
  mysocket.DataForm.xcomm1.Timeouts.writemultiplier:=20;
  mysocket.DataForm.xcomm1.Timeouts.ReadInterval:=100;
  mysocket.DataForm.xcomm1.Timeouts.ReadConstant:=20;
  mysocket.DataForm.xcomm1.Timeouts.ReadMultiplier:=20;

     mysocket.DataForm.xcomm1.OpenDevice;
     

     //create treenode
     treenode:=TreeView1.Items.AddChild(TreeView1.Selected,getlocalip+'['+inttostr(udpserver_localport)+']');
     TreeView1.Selected.Expand(false);
     treenode.Data:=mysocket;
     treenode.StateIndex:=5;
     mysocket.NodePtr:=treenode;
     treenode.Selected:=true;
     mysocket.DisplayStatus;
     MySocketList.Add(mysocket);
    end;
  end;

  if treeview1.Selected.Text='UDP Group' then
  begin
    if  frmNewGroupSock=nil then frmNewGroupSock:=TFrmNewGroupSock.Create(nil);
    ret:=frmNewGroupSock.showmodal;
    if ret=mrOK then
    begin
     mysocket:=tmysocket.Create;
     mysocket.SocketType:='UDP Group';
     mysocket.CreateTime:=datetimetostr(now);

      //create datapanel
      mysocket.DataForm:=tfrmData.Create(nil);
      mysocket.DataForm.owner:=mysocket;

     //create udp group
      // 初始化SOCKET
      if WSAStartup($101, TempWSAData)=1 then
      showmessage('StartUp Error!');

      mysocket.groupsock:= Socket(AF_INET, SOCK_DGRAM, 0);
      if (mysocket.groupsock = INVALID_SOCKET) then   //Socket创建失败
      begin
         showmessage(inttostr(WSAGetLastError())+'  Socket创建失败');
         CloseSocket(mysocket.groupsock);
        //exit;
      end;

      //发送方SockAddr绑定
      mysocket.addr.sin_family := AF_INET;
      mysocket.addr.sin_addr.S_addr := INADDR_ANY;
      //->
      mysocket.groupport:=udpgroup_localport;
      mysocket.addr.sin_port := htons(mysocket.groupport);
      if Bind(mysocket.groupsock, mysocket.addr, sizeof(mysocket.addr)) <> 0  then
      begin
        showmessage('bind fail');
      end;
      //->
      mysocket.Groupaddr:=udpgroup_localip;

      mysocket.mreq.imr_multiaddr.S_addr := inet_addr(pchar(mysocket.GROUPADDR));//htonl(INADDR_ALLHOSTS_GROUP);
      mysocket.mreq.imr_interface.S_addr := htonl(INADDR_ANY);
      if setsockopt(mysocket.groupsock,IPPROTO_IP,IP_ADD_MEMBERSHIP,pchar(@mysocket.mreq),sizeof(mysocket.mreq)) = SOCKET_ERROR then
      begin
       showmessage('无法进行UDP组播');
      end;
      WSAAsyncSelect(mysocket.groupsock, mysocket.DataForm.Handle , WM_SOCK, FD_READ);
      //接收端SockAddrIn设定
      mysocket.FSockAddrIn.SIn_Family := AF_INET;
      mysocket.FSockAddrIn.SIn_Port := htons(mysocket.GroupPort);

//      mysocket.SocketPtr:=mysocket.groupsock;
      mysocket.LocalIP:=mysocket.GroupAddr;
      mysocket.LocalPort:=mysocket.GroupPort;


      //create treenode
      treenode:=TreeView1.Items.AddChild(TreeView1.Selected,udpgroup_localip+'['+inttostr(udpgroup_localport)+']');
      TreeView1.Selected.Expand(false);
      treenode.Data:=mysocket;
      treenode.StateIndex:=6;
      mysocket.NodePtr:=treenode;
     treenode.Selected:=true;
      mysocket.DisplayStatus;
      MySocketList.Add(mysocket);
    end;
  end;

  if mysocketlist.Count>0 then panel3.Hide;
end;

procedure TForm1.Button2Click(Sender: TObject);
var mysocket:TMySocket;
    serversocket:tserversocket;
    clientsocket:tclientsocket;
    serverclient:tcustomwinsocket;
    udpsocket:tnmudp;

begin
  if treeview1.Selected=nil then exit;
  if treeview1.Selected.Data=nil then exit;

  MySocket:=treeview1.Selected.Data;
  if MySocket.SocketType='TCP Server' then
  begin
     serversocket:=(MySocket.SocketPtr as tserversocket);
     serversocket.Socket.Close;
     serversocket.free;

     mysocket.DataForm.Free;
  end;

  if MySocket.SocketType='TCP ServerClient' then
  begin
     serverclient:=(MySocket.SocketPtr as tcustomwinsocket);
     serverclient.Close;
     exit;
     //mysocket.DataForm.Free;
  end;


  if MySocket.SocketType='TCP Client' then
  begin
     clientsocket:=(MySocket.SocketPtr as tclientsocket);
     clientsocket.Socket.Close;
     clientsocket.free;

     mysocket.DataForm.Free;
  end;

  if MySocket.SocketType='UDP Client' then
  begin
     //udpsocket:=(MySocket.SocketPtr as tnmudp);
     CloseSocket(mysocket.udpsock.ThisSocket);
     mysocket.udpsock.Free;
     //udpsocket.free;
     mysocket.DataForm.Free;
  end;

  if MySocket.SocketType='UDP Group' then
  begin
     CloseSocket(MySocket.GroupSock);
     mysocket.DataForm.Free;
  end;

  MySocketList.Remove(MySocket);
  treeview1.Items.Delete(treeview1.Selected);
  if mysocketlist.Count=0 then panel3.show;   
end;

procedure TForm1.FormCreate(Sender: TObject);
begin
  MySocketList:=TObjectList.Create;
  MySocketList.OwnsObjects:=true;

end;

procedure TForm1.FormActivate(Sender: TObject);
begin
//  treeview1.Items[0].Selected:=true;
//  webbrowser1.Navigate('http://www.zstel.com');  
end;

procedure TForm1.TreeView1Change(Sender: TObject; Node: TTreeNode);
var i:integer;
    mysocket:tmysocket;
begin
  if node.data=nil then exit;
  
  for i:=0 to mysocketlist.Count-1 do
  begin
     mysocket:=node.data;
     if mysocket<>(mysocketlist.Items[i] as tmysocket) then
     begin
        if mysocket.dataform<>nil then
        begin
         // mysocket.dataform.visible:=false;
        end;
     end
     else
     begin
        if mysocket.dataform<>nil then
        begin
          mysocket.DisplayStatus;
          mysocket.dataform.show;//visible:=true;
        end;
     end;
  end;
end;

procedure TForm1.Button5Click(Sender: TObject);
var    MySocket:tmysocket;
begin
  if treeview1.Selected=nil then exit;
  if treeview1.Selected.Data=nil then exit;

  MySocket:=treeview1.Selected.Data;
  if MySocket.SocketType='TCP Server' then
  begin
    try
     (MySocket.SocketPtr as tserversocket).Open;
     MySocket.NodePtr.StateIndex:=3;
     mysocket.LinkStatus:=1;
    except
      showmessage('Socket端口已经被占用');
    end;
    mysocket.DisplayStatus;
  end;
  if MySocket.SocketType='TCP Client' then
  begin
    try
     (MySocket.SocketPtr as tclientsocket).Open;
     MySocket.LinkStatus:=1;
     mysocket.LocalPort:=(mysocket.SocketPtr as tclientsocket).socket.LocalPort;
     mysocket.DisplayStatus;

    except
    end;
  end;

end;

procedure TMySocket.DisplayStatus ;
var serversock:tserversocket;
begin
  form1.button5.Visible:=false;
  form1.button6.Visible:=false;
  dataform.button5.Visible:=false;
  dataform.button6.Visible:=false;

  if SocketType='TCP Server' then
  begin
     if LinkStatus=1 then  DataForm.Label1.caption:='已启动';
     if LinkStatus=0 then  DataForm.Label1.caption:='已停止';

     DataForm.Label2.Caption:='Socket服务器创建时间:'+CreateTime;
     DataForm.Label3.Caption:='';     DataForm.Label4.Caption:='';
     DataForm.Label5.Caption:='';     DataForm.Label6.Caption:='';
//     form1.button5.Visible:=true;     form1.button6.Visible:=true;
     dataform.button5.caption:='启动监听';  dataform.button6.caption:='停止监听';
     dataform.button5.Visible:=true;  dataform.button6.Visible:=true;
     DataForm.Label6.Caption:='本地端口:'+inttostr(localport);     
     if linkstatus=1 then
     begin
       dataform.button5.Enabled:=false;       dataform.button6.Enabled:=true;
     end;
     if linkstatus=0 then
     begin
       dataform.button5.Enabled:=true;       dataform.button6.Enabled:=false;
     end;
  end;

  if SocketType='TCP ServerClient' then
  begin
     if LinkStatus=1 then  DataForm.Label1.caption:='已连接';
     if LinkStatus=0 then  DataForm.Label1.caption:='已断开';

     DataForm.Label2.Caption:='Socket创建时间:'+CreateTime;
     DataForm.Label3.Caption:='对方IP:'+RemoteIP;
     DataForm.Label4.Caption:='对方端口:'+inttostr(RemotePort);
     DataForm.Label5.Caption:='';
     DataForm.Label6.Caption:='本地端口:'+inttostr(localport);
//     form1.button5.Visible:=true;     form1.button6.Visible:=true;
     dataform.button5.caption:='连接'; dataform.button6.caption:='断开';
     dataform.button5.Visible:=false;  dataform.button6.Visible:=true;
     if linkstatus=1 then
     begin
       dataform.button5.Enabled:=false;       dataform.button6.Enabled:=true;
     end;
     if linkstatus=0 then
     begin
       dataform.button5.Enabled:=true;       dataform.button6.Enabled:=false;
     end;
  end;

  if SocketType='TCP Client' then
  begin
     if LinkStatus=1 then  DataForm.Label1.caption:='已连接';
     if LinkStatus=0 then  DataForm.Label1.caption:='已断开';

     DataForm.Label2.Caption:='Socket创建时间:'+CreateTime;
     DataForm.Label3.Caption:='对方IP:'+remoteip;
     DataForm.Label4.Caption:='对方端口:'+inttostr(remoteport);
     DataForm.Label5.Caption:='';
     DataForm.Label6.Caption:='本地端口:'+inttostr(localport);
//     form1.button5.Visible:=true;     form1.button6.Visible:=true;
     dataform.button5.caption:='连接';  dataform.button6.caption:='断开';
     dataform.button5.Visible:=true;  dataform.button6.Visible:=true;
     if linkstatus=1 then
     begin
       dataform.button5.Enabled:=false;       dataform.button6.Enabled:=true;
     end;
     if linkstatus=0 then
     begin
       dataform.button5.Enabled:=true;       dataform.button6.Enabled:=false;
     end;
  end;

  if SocketType='UDP Client' then
  begin
     DataForm.Label1.caption:='';

     DataForm.Label2.Caption:='Socket创建时间:'+CreateTime;
     DataForm.Label3.Caption:='对方IP:'+remoteip;
     DataForm.Label4.Caption:='对方端口:'+inttostr(remoteport);
     DataForm.Label5.Caption:='';
     DataForm.Label6.Caption:='本地端口:'+inttostr(localport);
  end;

  if SocketType='UDP Server' then
  begin
     DataForm.Label1.caption:='';

     DataForm.Label2.Caption:='Socket创建时间:'+CreateTime;
     DataForm.Label3.Caption:='对方IP:'+remoteip;
     DataForm.Label4.Caption:='对方端口:'+inttostr(remoteport);
     DataForm.Label5.Caption:='';
     DataForm.Label6.Caption:='本地端口:'+inttostr(localport);
  end;

  if SocketType='UDP Group' then
  begin
     DataForm.Label1.caption:='';

     DataForm.Label2.Caption:='Socket创建时间:'+CreateTime;
     DataForm.Label3.Caption:='组播地址:'+localip;
     DataForm.Label4.Caption:='组播端口:'+inttostr(localport);
     DataForm.Label5.Caption:='';
     DataForm.Label6.Caption:='';//本地端口:'+inttostr(localport);
  end;
end;

procedure  TMySocket.onClientSockErr(Sender: TObject; Socket: TCustomWinSocket; ErrorEvent: TErrorEvent; var ErrorCode: Integer);
begin
  if dataform<>nil then
  begin
   dataform.memo3.Lines.add(datetimetostr(now)+'Client Socket异常,代码='+inttostr(ErrorCode));
  end;
  
  ErrorCode:=0;
  //Socket.Close;
end;

Procedure  TMySocket.onSockErr(Sender: TObject; Socket: TCustomWinSocket; ErrorEvent: TErrorEvent; var ErrorCode: Integer);
begin
  ErrorCode:=0;
end;

Procedure  TMySocket.OnTcpServerRead(Sender: TObject;Socket: TCustomWinSocket);
var mysocket,parentmysock:tmysocket;
    treenode:ttreenode;
    hexstr,buf:string;
    i,k:integer;
begin
     buf:=socket.ReceiveText;
     mysocket:=socket.data;


     hexstr:='';
     if mysocket.DataForm.checkbox2.Checked then
     begin
      hexstr:='{';
      for i:=1 to length(buf) do
      begin
       hexstr:=hexstr+hextostr(ord(buf[i]))+' ';
      end;
      hexstr:=hexstr+'}';
     end;

     mysocket.DataForm.memo2.Lines.Add(timetostr(now)+' 收到数据：'+hexstr+buf);
     mysocket.DataForm.g_recvcnt:=mysocket.DataForm.g_recvcnt+length(buf);

     mysocket.DataForm.statusbar2.Panels[0].Text:='收：'+inttostr(mysocket.DataForm.G_recvcnt)+'字节，发:'+inttostr(mysocket.DataForm.g_sndcnt)+'字节';

     if mysocket.DataForm.XComm1.Opened then
     begin
//        for i:=1 to length(buf) do
        begin
          mysocket.DataForm.XComm1.SendString(buf);
          //Sleep(100);
        end;
     end;

     if self.DataForm.ckwebsvr.Checked then
     begin
     //  mysocket.DataForm.memo2.Lines.Add('自动发送Web网页');
       socket.SendText(form1.webstr1.Text+'Content-Length: '+inttostr(length(form1.WebStr2.text))+chr(13)+chr(10)+chr(13)+chr(10)+form1.webstr2.Text);
       socket.Close;
     end;
end;


Procedure  TMySocket.OnTcpClientRead(Sender: TObject;Socket: TCustomWinSocket);
var mysocket,parentmysock:tmysocket;
    treenode:ttreenode;
    hexstr,buf:string;
    i:integer;
begin
     buf:=socket.ReceiveText;
     mysocket:=socket.data;

     hexstr:='';
     if mysocket.DataForm.checkbox2.Checked then
     begin
      hexstr:='{';
      for i:=1 to length(buf) do
      begin
       hexstr:=hexstr+hextostr(ord(buf[i]))+' ';
      end;
      hexstr:=hexstr+'}';
     end;

     mysocket.DataForm.memo2.Lines.Add(timetostr(now)+' 收到数据：'+hexstr+buf);
     mysocket.DataForm.g_recvcnt:=mysocket.DataForm.g_recvcnt+length(buf);

     mysocket.DataForm.statusbar2.Panels[0].Text:='收：'+inttostr(mysocket.DataForm.G_recvcnt)+'字节，发:'+inttostr(mysocket.DataForm.g_sndcnt)+'字节';
end;


Procedure  TMySocket.OnTcpServerClientConnect(Sender: TObject;Socket: TCustomWinSocket);
var mysocket,parentmysock:tmysocket;
    treenode:ttreenode;
begin
     mysocket:=tmysocket.Create;
     mysocket.CreateTime:=datetimetostr(now);
     
     mysocket.SocketType:='TCP ServerClient';
     mysocket.SocketPtr:=socket;
     Socket.Data:=mysocket;

     parentmysock:=(sender as tcustomwinsocket).Data;
     parentmysock.DisplayStatus;
     treenode:=form1.TreeView1.Items.AddChild(parentmysock.nodeptr,socket.RemoteAddress+'['+inttostr(socket.RemotePort)+']');
     parentmysock.nodeptr.Expand(false);
     treenode.StateIndex:=1;
     treenode.Selected:=true;
     treenode.Data:=mysocket;
     mysocket.NodePtr:=treenode;
     mysocket.DataForm:=tfrmData.Create(nil);
     mysocket.DataForm.owner:=mysocket;
     mysocket.LinkStatus:=1;

     {
     mysocket.DataForm.xcomm1.BaudRate:=brcustom;
     mysocket.DataForm.xcomm1.BaudValue:=28800;
     mysocket.DataForm.xcomm1.DeviceName:='com1';
  mysocket.DataForm.xcomm1.FlowControl :=fcCustom;//fcrtscts;//fcnone;//
  mysocket.DataForm.xcomm1.DTRSettings := [fsDTREnabled];
  mysocket.DataForm.xcomm1.RTSSettings:= [fsRTSEnabled];

  mysocket.DataForm.xcomm1.Timeouts.WriteConstant:=500;
  mysocket.DataForm.xcomm1.Timeouts.writemultiplier:=20;
  mysocket.DataForm.xcomm1.Timeouts.ReadInterval:=100;
  mysocket.DataForm.xcomm1.Timeouts.ReadConstant:=20;
  mysocket.DataForm.xcomm1.Timeouts.ReadMultiplier:=20;

     mysocket.DataForm.xcomm1.OpenDevice;
     }

     mysocket.RemotePort:=socket.RemotePort;
     mysocket.RemoteIP:=socket.RemoteAddress;
     mysocket.LocalPort:=socket.LocalPort;  

     mysocket.DisplayStatus;

     MySocketList.Add(mysocket);

     if PipePtr<>nil then
     begin
      if  PipePtr.SocketType='TCP Client' then
      begin
       (PipePtr.SocketPtr as tclientsocket).Open;

        PipePtr.LocalPort:=(PipePtr.SocketPtr as tclientsocket).socket.LocalPort;
        PipePtr.DisplayStatus;
      end;
     end;     
end;

Procedure  TMySocket.OnTcpClientConnect(Sender: TObject;Socket: TCustomWinSocket);
var mysocket,parentmysock:tmysocket;
    treenode:ttreenode;
begin
//     socket.OnErrorEvent:=onsockErr;
     mysocket:=socket.data;
     mysocket.LinkStatus:=1;
     mysocket.LocalPort:=(mysocket.SocketPtr as tclientsocket).socket.LocalPort;     
     mysocket.DisplayStatus;
     mysocket.NodePtr.StateIndex:=1;

end;


Procedure  TMySocket.OnTcpServerClientDisConnect(Sender: TObject;Socket: TCustomWinSocket);
var mysocket,parentmysock:tmysocket;
    treenode:ttreenode;
begin
    // exit;
   //  parentmysock:=(sender as tcustomwinsocket).Data;
   //  parentmysock.DisplayStatus;
     if PipePtr<>nil then
     begin
      if  PipePtr.SocketType='TCP Client' then
      begin
        // showmessage(PipePtr.NodePtr.Text); 
         //(PipePtr.SocketPtr as tclientsocket).Socket.Close;
         //PipePtr.DataForm.Button6MouseUp(nil,0,,0,0);
               form1.treeview1.Select(PipePtr.NodePtr); 
               (PipePtr.SocketPtr as tclientsocket).Close;
               PipePtr.LinkStatus:=0;
               PipePtr.DisplayStatus;
      end;
     end;
     
     mysocket:=socket.data;
     mysocket.LinkStatus:=0;
     mysocket.NodePtr.StateIndex:=2;
     form1.TreeView1.Items.Delete(mysocket.nodeptr);

     mysocket.DataForm.Free;
     MySocketList.remove(mysocket);


end;

Procedure  TMySocket.OnTcpClientDisConnect(Sender: TObject;Socket: TCustomWinSocket);
var mysocket,parentmysock:tmysocket;
    treenode:ttreenode;
begin
     mysocket:=socket.data;
     mysocket.linkstatus:=0;
     mysocket.DisplayStatus;     
     mysocket.NodePtr.StateIndex:=2;

     if PipePtr<>nil then
     begin
      if  PipePtr.SocketType='TCP Server' then
      begin
        (PipePtr.SocketPtr as tserversocket).Close;
      end;
     end;
end;

procedure TForm1.Button6Click(Sender: TObject);
var  MySocket:tmysocket;
     i:integer;
begin
  if treeview1.Selected=nil then exit;
  if treeview1.Selected.Data=nil then exit;

  MySocket:=treeview1.Selected.Data;
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
     (MySocket.SocketPtr as tclientsocket).Close;
     MySocket.LinkStatus:=0;
     mysocket.DisplayStatus;
  end;
  if MySocket.SocketType='TCP ServerClient' then
  begin
     (MySocket.SocketPtr as tcustomwinsocket).Close;
  end;
end;

procedure TMySocket.OnGroupRead(var Message: TMessage);
var
  buffer: Array [1..4096] of char;
  len,i: integer;
  flen: integer;
  Event: word;
  value: string;
  buf,Str,hexstr: String;
begin
  flen:=sizeof(FSockAddrIn);
  Event := WSAGetSelectEvent(Message.LParam);
  if Event = FD_READ then
  begin
      len := recvfrom(groupsock, buffer, sizeof(buffer), 0, FSockAddrIn, flen);
      value := copy(buffer, 1, len);
      //Memo1.Lines.add(value)
  end;

     buf:=value;
     hexstr:='';
     if DataForm.checkbox2.Checked then
     begin
      hexstr:='{';
      for i:=1 to length(buf) do
      begin
       hexstr:=hexstr+hextostr(ord(buf[i]))+' ';
      end;
      hexstr:=hexstr+'}';
     end;

     DataForm.memo2.Lines.Add(timetostr(now)+' 收到数据：'+hexstr+buf);
     DataForm.g_recvcnt:=DataForm.g_recvcnt+length(buf);

     DataForm.statusbar2.Panels[0].Text:='收：'+inttostr(DataForm.G_recvcnt)+'字节，发:'+inttostr(DataForm.g_sndcnt)+'字节';

end;

procedure TForm1.Button8Click(Sender: TObject);
begin
        application.Terminate;
end;

procedure TForm1.Label1Click(Sender: TObject);
begin
  ShellExecute(form1.Handle,nil,pchar('http://www.smset.com/productdetail.asp?productID=14&ClassID=7'),nil,nil,1);
end;

procedure TForm1.Label2Click(Sender: TObject);
begin
ShellExecute(form1.Handle,nil,pchar('http://www.smset.com/productdetail.asp?classID=1&productID=4'),nil,nil,1);
end;

procedure TForm1.Label3Click(Sender: TObject);
begin
ShellExecute(form1.Handle,nil,pchar('http://www.smset.com/'),nil,nil,1);
end;

procedure TForm1.FormClose(Sender: TObject; var Action: TCloseAction);
var i:integer;
begin
  for i:=0 to mysocketlist.Count-1 do
  begin
    if (mysocketlist.Items[i]  as tmysocket).SocketType='TCP Server' then
    begin
      ((mysocketlist.Items[i]  as tmysocket).SocketPtr as tserversocket).Close;
    end;
  end;
end;

procedure TForm1.Image1Click(Sender: TObject);
begin
  ShellExecute(form1.Handle,nil,pchar('http://www.smset.com/productdetail.asp?productID=14&ClassID=7'),nil,nil,1);
end;

procedure TForm1.Image2Click(Sender: TObject);
begin
   ShellExecute(form1.Handle,nil,pchar('http://www.smset.com/productdetail.asp?classID=1&productID=4'),nil,nil,1);
end;

procedure TForm1.TreeView1DragOver(Sender, Source: TObject; X, Y: Integer;
  State: TDragState; var Accept: Boolean);
var mysocket1,mysocket2:tmysocket;
begin
 if  TreeView1.GetNodeAt(X, Y)<>nil then
  begin
    if TreeView1.GetNodeAt(X, Y).Text=(source as TTreeView).selected.text then
    begin
     Accept:=false; exit;
    end;

   {
    if  TreeView2.GetNodeAt(X, Y).Text='[全部]' then
    begin
     Accept:=false; exit;
    end;
   }
    if source.classname='TTreeView' then
    begin
      mysocket1:=TreeView1.GetNodeAt(X, Y).Data;
      if mysocket1=nil then
      begin
       Accept:=false; exit;
      end;
      mysocket2:=(Source as TTreeView).Selected.Data;
      if  Mysocket1.SocketType=Mysocket2.SocketType then
      begin
        Accept:=false; exit;
      end;

      {
      if (source as TTreeView).selected.text='[全部]' then
      begin
        Accept:=false; exit;
      end;
      }
    end;
  end;

  Accept := true;
end;

procedure TForm1.TreeView1DragDrop(Sender, Source: TObject; X, Y: Integer);
var s,taskname,worktype:string;
    AnItem: TTreeNode;
    AttachMode: TNodeAttachMode;
    HT: THitTests;
    mysocket1,mysocket2:tmysocket;
begin
  if source.classname='TTreeView' then
  begin
          if TreeView1.Selected = nil then Exit;
          HT := TreeView1.GetHitTestInfoAt(X, Y);
          AnItem := TreeView1.GetNodeAt(X, Y);
          mysocket1:=TreeView1.GetNodeAt(X, Y).Data;

          if AnItem=nil then exit;

          if (HT - [htOnItem, htOnIcon, htNowhere, htOnIndent] <> HT) then
          begin
            if (htOnItem in HT) or (htOnIcon in HT) then AttachMode := naAddChild
            else if htNowhere in HT then AttachMode := naAdd

            else if htOnIndent in HT then AttachMode := naInsert;
            //TreeView1.Selected.MoveTo(AnItem, AttachMode);
          end;
  end;

  if  (sender as ttreeview).GetNodeAt(x,y)=nil then exit;

  if mysocket1=nil then  exit;
  mysocket2:=(Source as TTreeView).Selected.Data;

  mysocket1.PipePtr:=mysocket2;
  mysocket2.PipePtr:=mysocket1;
  
  showmessage('监听管道已经建立!');
end;

end.

