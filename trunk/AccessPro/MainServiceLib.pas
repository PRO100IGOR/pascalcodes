unit MainServiceLib;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, SvcMgr, Dialogs,MainRunLib;

type
  TshService = class(TService)
    procedure ServiceStart(Sender: TService; var Started: Boolean);
  private
    { Private declarations }
  public
    function GetServiceController: TServiceController; override;
    { Public declarations }
  end;

var
  shService: TshService;

implementation

{$R *.DFM}

procedure ServiceController(CtrlCode: DWord); stdcall;
begin
  shService.Controller(CtrlCode);
end;

function TshService.GetServiceController: TServiceController;
begin
  Result := ServiceController;
end;

procedure TshService.ServiceStart(Sender: TService; var Started: Boolean);
begin
    MainView := TMainView.Create(Application);
end;

end.
