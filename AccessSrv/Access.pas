unit Access;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, SvcMgr, Dialogs;

type
  Tsiheaccess = class(TService)
  private
    { Private declarations }
  public
    function GetServiceController: TServiceController; override;
    { Public declarations }
  end;

var
  siheaccess: Tsiheaccess;

implementation

{$R *.DFM}

procedure ServiceController(CtrlCode: DWord); stdcall;
begin
  siheaccess.Controller(CtrlCode);
end;

function Tsiheaccess.GetServiceController: TServiceController;
begin
  Result := ServiceController;
end;

end.
