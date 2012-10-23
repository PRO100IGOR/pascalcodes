unit TlbImpl;

interface

uses
  Classes, ComObj,Magican_TLB;
type
  TMyLib = class(TAutoIntfObject, BigExternal, IDispatch)
  private
  protected
     procedure Show; safecall;
  public
     constructor Create;
     destructor Destroy; override;
  end;
implementation

uses
  SysUtils, ActiveX, StdActns;

constructor TMyLib.Create;
 var
	TypeLib: ITypeLib;
	ExeName: WideString;
 begin
	ExeName := ParamStr(0);
	OleCheck(LoadTypeLib(PWideChar(ExeName), TypeLib));
	inherited Create(TypeLib, BigExternal);
end;
destructor TMyLib.Destroy;
begin
  inherited;
end;
procedure TMyLib.Show;
begin

end;


end.
