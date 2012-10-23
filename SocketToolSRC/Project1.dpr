program Project1;

uses
  Forms,
  Unit1 in 'Unit1.pas' {Form1},
  datapanel in 'datapanel.pas' {FrmData},
  newserversock in 'newserversock.pas' {frmNewServerSock},
  newclientsock in 'newclientsock.pas' {frmNewClientSock},
  newudpsock in 'newudpsock.pas' {frmNewUdpSock},
  netcardinfo in 'netcardinfo.pas',
  newgroupsock in 'newgroupsock.pas' {frmNewGroupSock},
  newudpserver in 'newudpserver.pas' {frmNewUDPServer};

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TForm1, Form1);
  Application.CreateForm(TfrmNewServerSock, frmNewServerSock);
  Application.CreateForm(TfrmNewClientSock, frmNewClientSock);
  Application.CreateForm(TfrmNewUdpSock, frmNewUdpSock);
  Application.CreateForm(TfrmNewGroupSock, frmNewGroupSock);
  Application.CreateForm(TfrmNewUDPServer, frmNewUDPServer);
  Application.Run;
end.
