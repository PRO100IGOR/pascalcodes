unit ExternalContainer;
 
 interface
 
 uses
 ActiveX, SHDocVw,
 DocHostUIHandler, NulContainer, TlbImpl;
 
 type
 TExternalContainer = class(TNulWBContainer, IDocHostUIHandler, IOleClientSite)
 private
     fExternalObj: IDispatch;
 protected
     function GetExternal(out ppDispatch: IDispatch): HResult; stdcall;
 public
     constructor Create(const HostedBrowser: TWebBrowser);
 end;
 
 implementation
 
 { TExternalContainer }
 
 constructor TExternalContainer.Create(const HostedBrowser: TWebBrowser);
 begin
	inherited;
	fExternalObj := TMyLib.Create;
 end;
 
 function TExternalContainer.GetExternal(out ppDispatch: IDispatch): HResult;
 begin
	ppDispatch := fExternalObj;
	Result := S_OK;
 end;
 
 end.
