// ************************************************************************ //
// The types declared in this file were generated from data read from the
// WSDL File described below:
// WSDL     : http://192.168.3.70:8080/fire/services/FireDwr?wsdl
//  >Import : http://192.168.3.70:8080/fire/services/FireDwr?wsdl:0
// Encoding : UTF-8
// Version  : 1.0
// (2011/7/6 17:45:16 - - $Rev: 10138 $)
// ************************************************************************ //

unit FireDwr;

interface

uses InvokeRegistry, SOAPHTTPClient, Types, XSBuiltIns;

const
  IS_NLBL = $0004;
  IS_REF  = $0080;


type

  FireDwrPortType = interface(IInvokable)
  ['{2603990C-5694-AF6B-EB17-8E02F9A444F5}']
    function  addInfo(const in0: WideString; const in1: WideString): Boolean; stdcall;
  end;

function GetFireDwrPortType(UseWSDL: Boolean=System.False; Addr: string=''; HTTPRIO: THTTPRIO = nil): FireDwrPortType;


implementation
  uses SysUtils;

function GetFireDwrPortType(UseWSDL: Boolean; Addr: string; HTTPRIO: THTTPRIO): FireDwrPortType;
const
  defWSDL = 'http://192.168.3.70:8080/fire/services/FireDwr?wsdl';
  defURL  = 'http://192.168.3.70:8080/fire/services/FireDwr';
  defSvc  = 'FireDwr';
  defPrt  = 'FireDwrHttpPort';
var
  RIO: THTTPRIO;
begin
  Result := nil;
  if (Addr = '') then
  begin
    if UseWSDL then
      Addr := defWSDL
    else
      Addr := defURL;
  end;
  if HTTPRIO = nil then
    RIO := THTTPRIO.Create(nil)
  else
    RIO := HTTPRIO;
  try
    Result := (RIO as FireDwrPortType);
    if UseWSDL then
    begin
      RIO.WSDLLocation := Addr;
      RIO.Service := defSvc;
      RIO.Port := defPrt;
    end else
      RIO.URL := Addr;
  finally
    if (Result = nil) and (HTTPRIO = nil) then
      RIO.Free;
  end;
end;


initialization
  InvRegistry.RegisterInterface(TypeInfo(FireDwrPortType), 'http://dwr.fireinfo.fire.sxsihe.com', 'UTF-8');
  InvRegistry.RegisterDefaultSOAPAction(TypeInfo(FireDwrPortType), '');
  InvRegistry.RegisterInvokeOptions(TypeInfo(FireDwrPortType), ioDocument);
  InvRegistry.RegisterExternalParamName(TypeInfo(FireDwrPortType), 'addInfo', 'out_', 'out');

end.