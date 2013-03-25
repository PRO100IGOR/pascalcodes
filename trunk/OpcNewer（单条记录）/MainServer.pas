unit MainServer;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, SvcMgr, Dialogs;

type
  TSiheOpc = class(TService)
  private
    { Private declarations }
  public
    function GetServiceController: TServiceController; override;
    { Public declarations }
  end;

var
  SiheOpc: TSiheOpc;

implementation

{$R *.DFM}

procedure ServiceController(CtrlCode: DWord); stdcall;
begin
  SiheOpc.Controller(CtrlCode);
end;

function TSiheOpc.GetServiceController: TServiceController;
begin
  Result := ServiceController;
end;

end.
