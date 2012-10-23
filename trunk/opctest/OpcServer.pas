unit OpcServer;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, SvcMgr, Dialogs;

type
  Tsiheopc = class(TService)
  private
    { Private declarations }
  public
    function GetServiceController: TServiceController; override;
    { Public declarations }
  end;

var
  siheopc: Tsiheopc;
implementation

{$R *.DFM}

procedure ServiceController(CtrlCode: DWord); stdcall;
begin
  siheopc.Controller(CtrlCode);
end;

function Tsiheopc.GetServiceController: TServiceController;
begin
  Result := ServiceController;
end;

end.
