unit newudpsock;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, IdBaseComponent, IdComponent, IdUDPBase, IdUDPServer,netcardinfo,winsock,
  SUIButton;

type
  TfrmNewUdpSock = class(TForm)
    Edit1: TEdit;
    Edit2: TEdit;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Edit3: TEdit;
    Button1: TsuiButton;
    suiButton1: TsuiButton;
    Button3: TsuiButton;
    procedure Button1Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure FormActivate(Sender: TObject);
    procedure Button3Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  frmNewUdpSock: TfrmNewUdpSock;
  udpsock_remoteport:integer;
  udpsock_localport:integer;
  udpsock_remotehost:string;

  function isudpportused(port:integer):boolean;  
implementation
uses unit1;

{$R *.dfm}

function isudpportused(port:integer):boolean;
var TempWSAData: TWSAData;
    udpsock:TSocket;
    addr: TSockAddr;
begin
     //create udp group
      // ��ʼ��SOCKET
      if WSAStartup($101, TempWSAData)=1 then
      begin
       //showmessage('WSAStartup Error!');
       //exit;
       result:=true;
       exit;
      end;

      udpsock:= Socket(AF_INET, SOCK_DGRAM, 0);
      if (udpsock = INVALID_SOCKET) then   //Socket����ʧ��
      begin
         //showmessage(inttostr(WSAGetLastError())+'UDP Socket����ʧ��');
         CloseSocket(udpsock);
         result:=true;
         exit;
      end;

      //���ͷ�SockAddr��
      addr.sin_family := AF_INET;
      addr.sin_addr.S_addr := INADDR_ANY;
      //->
      addr.sin_port := htons(port);
      if Bind(udpsock, addr, sizeof(addr)) <> 0  then
      begin
        //showmessage('���ض˿��ѱ�ռ�ã�������ѡ�񱾵ض˿ں�');
        CloseSocket(udpsock);
        result:=true;
        exit;
      end;
      CloseSocket(udpsock);
      result:=false;
end;

procedure TfrmNewUdpSock.Button1Click(Sender: TObject);
var idudp:tidudpserver;
    TempWSAData: TWSAData;
    udpsock:TSocket;
    addr: TSockAddr;
    FSockAddrIn : TSockAddrIn;
begin
  udpsock_remotehost:=edit1.text;
  udpsock_remoteport:=strtoint(edit2.text);
  udpsock_localport:=strtoint(edit3.Text);
  if isudpportused(udpsock_localport) then
  begin
          showmessage('���ض˿��ѱ�ռ�ã�������ѡ�񱾵ض˿ں�');
          exit;
  end;
  ModalResult := mrOK;
end;

procedure TfrmNewUdpSock.Button2Click(Sender: TObject);
begin
 ModalResult := mrcancel;
end;

procedure TfrmNewUdpSock.FormActivate(Sender: TObject);
begin
 edit1.text:=getlocalip;
end;

procedure TfrmNewUdpSock.Button3Click(Sender: TObject);
begin
 edit1.text:=getudpbroadaddr;
end;

end.
