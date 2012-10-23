unit udpmulticast;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs, winsock,
  StdCtrls;

const
  WM_SOCK = WM_USER + 1;     //自定义windows消息
  UDPPORT = 6543;            //设定UDP端口号

  //D类地址224.0.0.0 - 239.255.255.255
  //若为224.0.0.1则本机也能收到，否则本机收不到，其它机器能收到。
  MY_GROUP = '224.1.1.1';


(*
 * Argument structure for IP_ADD_MEMBERSHIP and IP_DROP_MEMBERSHIP.
 * Delphi5自带的winsock.pas中没有ip_mreq的定义。
 *)

type
  ip_mreq = record
    imr_multiaddr: in_addr;  (* IP multicast address of group *)
    imr_interface: in_addr;  (* local IP address of interface *)
  end;
  TIpMReq = ip_mreq;
  PIpMReq = ^ip_mreq;

type
  Tfrmmain = class(TForm)
    Button1: TButton;
    Edit1: TEdit;
    Memo1: TMemo;
    Edit2: TEdit;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    procedure FormCreate(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure Button1Click(Sender: TObject);
  private
    { Private declarations }
    s: TSocket;
    addr: TSockAddr;
    FSockAddrIn : TSockAddrIn;
    mreq:ip_mreq;
    //利用消息实时获知UDP消息
    procedure ReadData(var Message: TMessage); message WM_SOCK;
  public
    { Public declarations }
    procedure SendData(Content: String);
  end;

var
  frmmain: Tfrmmain;

implementation

{$R *.DFM}
function  creategroup(form:tform;group:string;PORT:integer):integer;
var
  TempWSAData: TWSAData;
  s: TSocket;
  addr: TSockAddr;
  FSockAddrIn : TSockAddrIn;
  mreq:ip_mreq;
begin
  // 初始化SOCKET
  if WSAStartup($101, TempWSAData)=1 then
  begin
    //showmessage('StartUp Error!');
    result:=-1;
  end;

  s:= Socket(AF_INET, SOCK_DGRAM, 0);
  if (s = INVALID_SOCKET) then   //Socket创建失败
  begin
      //showmessage(inttostr(WSAGetLastError())+'  Socket创建失败');
      CloseSocket(s);
      result:=-2;
      //exit;
  end;
  //发送方SockAddr绑定
  addr.sin_family := AF_INET;
  addr.sin_addr.S_addr := INADDR_ANY;
  addr.sin_port := htons(PORT);
  if Bind(s, addr, sizeof(addr)) <> 0  then
   begin
     //showmessage('bind fail');
     result:=-3;
   end;

  {optval:= 1;
  if setsockopt(s,SOL_SOCKET,SO_BROADCAST,pchar(@optval),sizeof(optval)) = SOCKET_ERROR then
  begin
   showmessage('无法进行UDP广播');
  end;}

  mreq.imr_multiaddr.S_addr := inet_addr(pchar(GROUP));//htonl(INADDR_ALLHOSTS_GROUP);
  mreq.imr_interface.S_addr := htonl(INADDR_ANY);
  if setsockopt(s,IPPROTO_IP,IP_ADD_MEMBERSHIP,pchar(@mreq),sizeof(mreq)) = SOCKET_ERROR then
  begin
   //showmessage('无法进行UDP组播');
    result:=-4;
  end;

  WSAAsyncSelect(s, form.Handle , WM_SOCK, FD_READ);
  //接收端SockAddrIn设定
  FSockAddrIn.SIn_Family := AF_INET;
  FSockAddrIn.SIn_Port := htons(PORT);

//  label3.Caption := '端口：'+inttostr(PORT);

  result:=0;
end;


procedure Tfrmmain.FormCreate(Sender: TObject);
var
  TempWSAData: TWSAData;
  //optval: integer;
begin
  Edit1.Text := MY_GROUP;
  // 初始化SOCKET
  if WSAStartup($101, TempWSAData)=1 then
    showmessage('StartUp Error!');

  s := Socket(AF_INET, SOCK_DGRAM, 0);
  if (s = INVALID_SOCKET) then   //Socket创建失败
  begin
      showmessage(inttostr(WSAGetLastError())+'  Socket创建失败');
      CloseSocket(s);
      //exit;
  end;
  //发送方SockAddr绑定
  addr.sin_family := AF_INET;
  addr.sin_addr.S_addr := INADDR_ANY;
  addr.sin_port := htons(UDPPORT);
  if Bind(s, addr, sizeof(addr)) <> 0  then
   begin
     showmessage('bind fail');
   end;

  {optval:= 1;
  if setsockopt(s,SOL_SOCKET,SO_BROADCAST,pchar(@optval),sizeof(optval)) = SOCKET_ERROR then
  begin
   showmessage('无法进行UDP广播');
  end;}

  mreq.imr_multiaddr.S_addr := inet_addr(pchar(MY_GROUP));//htonl(INADDR_ALLHOSTS_GROUP);
  mreq.imr_interface.S_addr := htonl(INADDR_ANY);
  if setsockopt(s,IPPROTO_IP,IP_ADD_MEMBERSHIP,pchar(@mreq),sizeof(mreq)) = SOCKET_ERROR then
  begin
   showmessage('无法进行UDP组播');
  end;


  WSAAsyncSelect(s, frmmain.Handle , WM_SOCK, FD_READ);
  //接收端SockAddrIn设定
  FSockAddrIn.SIn_Family := AF_INET;
  FSockAddrIn.SIn_Port := htons(UDPPORT);

  label3.Caption := '端口：'+inttostr(UDPPORT);
end;

procedure Tfrmmain.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  CloseSocket(s);
end;

procedure Tfrmmain.ReadData(var Message: TMessage);
var
  buffer: Array [1..4096] of char;
  len: integer;
  flen: integer;
  Event: word;
  value: string;
begin
  flen:=sizeof(FSockAddrIn);
  Event := WSAGetSelectEvent(Message.LParam);
  if Event = FD_READ then
  begin
      len := recvfrom(s, buffer, sizeof(buffer), 0, FSockAddrIn, flen);
      value := copy(buffer, 1, len);
      Memo1.Lines.add(value)
  end;
end;

procedure Tfrmmain.SendData(Content: String);
var
  value{,hostname}: string;
  len: integer;
begin
  //FSockAddrIn.SIn_Addr.S_addr := INADDR_BROADCAST;
  FSockAddrIn.SIn_Addr.S_addr := inet_addr(pchar(MY_GROUP));
  value := Content;
  len := sendto(s, value[1], Length(value), 0, FSockAddrIn, sizeof(FSockAddrIn));
  if (WSAGetLastError() <> WSAEWOULDBLOCK) and (WSAGetLastError() <> 0) then
    showmessage(inttostr(WSAGetLastError()));
  if len = SOCKET_ERROR then
    showmessage('send fail');
  if len <> Length(value) then
    showmessage('Not Send all');
end;

procedure Tfrmmain.Button1Click(Sender: TObject);
begin
  senddata(Edit2.text);
end;

end.
