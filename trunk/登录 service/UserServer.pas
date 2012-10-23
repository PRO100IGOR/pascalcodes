// ************************************************************************ //
// The types declared in this file were generated from data read from the
// WSDL File described below:
// WSDL     : http://10.10.0.158:8083/oxhide/services/UserServer?wsdl
//  >Import : http://10.10.0.158:8083/oxhide/services/UserServer?wsdl:0
// Encoding : UTF-8
// Version  : 1.0
// (2012-4-1 15:16:11 - - $Rev: 10138 $)
// ************************************************************************ //

unit UserServer;

interface

uses InvokeRegistry, SOAPHTTPClient, Types, XSBuiltIns;

const
  IS_NLBL = $0004;
  IS_REF  = $0080;


type

  // ************************************************************************ //
  // The following types, referred to in the WSDL document are not being represented
  // in this file. They are either aliases[@] of other types represented or were referred
  // to but never[!] declared in the document. The types from the latter category
  // typically map to predefined/known XML or Borland types; however, they could also 
  // indicate incorrect WSDL documents that failed to declare or import a schema type.
  // ************************************************************************ //
  // !:string          - "http://www.w3.org/2001/XMLSchema"[Gbl]
  // !:boolean         - "http://www.w3.org/2001/XMLSchema"[Gbl]



  // ************************************************************************ //
  // Namespace : http://users.server.oxhide.sxsihe.com
  // transport : http://schemas.xmlsoap.org/soap/http
  // style     : document
  // binding   : UserServerHttpBinding
  // service   : UserServer
  // port      : UserServerHttpPort
  // URL       : http://10.10.0.158:8083/oxhide/services/UserServer
  // ************************************************************************ //
  UserServerPortType = interface(IInvokable)
  ['{9752F248-09DE-6C49-BBD4-A6967012A604}']
    function  saveToken(const in0: WideString): Boolean; stdcall;
    procedure unSendData(const in0: WideString; const in1: WideString); stdcall;
    function  sendTokenData(const in0: WideString): WideString; stdcall;
    function  login(const in0: WideString): WideString; stdcall;
    function  hasRescource(const in0: WideString; const in1: WideString; const in2: WideString): Boolean; stdcall;
    function  loginCheck(const in0: WideString): Boolean; stdcall;
  end;

function GetUserServerPortType(UseWSDL: Boolean=System.False; Addr: string=''; HTTPRIO: THTTPRIO = nil): UserServerPortType;


implementation
  uses SysUtils;

function GetUserServerPortType(UseWSDL: Boolean; Addr: string; HTTPRIO: THTTPRIO): UserServerPortType;
const
  defWSDL = 'http://10.10.0.141:8083/oxhide/services/UserServer?wsdl';
  defURL  = 'http://10.10.0.141:8083/oxhide/services/UserServer';
  defSvc  = 'UserServer';
  defPrt  = 'UserServerHttpPort';
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
    Result := (RIO as UserServerPortType);
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
  InvRegistry.RegisterInterface(TypeInfo(UserServerPortType), 'http://users.server.oxhide.sxsihe.com', 'UTF-8');
  InvRegistry.RegisterDefaultSOAPAction(TypeInfo(UserServerPortType), '');
  InvRegistry.RegisterInvokeOptions(TypeInfo(UserServerPortType), ioDocument);
  InvRegistry.RegisterExternalParamName(TypeInfo(UserServerPortType), 'saveToken', 'out_', 'out');
  InvRegistry.RegisterExternalParamName(TypeInfo(UserServerPortType), 'sendTokenData', 'out_', 'out');
  InvRegistry.RegisterExternalParamName(TypeInfo(UserServerPortType), 'login', 'out_', 'out');
  InvRegistry.RegisterExternalParamName(TypeInfo(UserServerPortType), 'hasRescource', 'out_', 'out');
  InvRegistry.RegisterExternalParamName(TypeInfo(UserServerPortType), 'loginCheck', 'out_', 'out');

end.