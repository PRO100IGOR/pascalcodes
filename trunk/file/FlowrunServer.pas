// ************************************************************************ //
// The types declared in this file were generated from data read from the
// WSDL File described below:
// WSDL     : http://127.0.0.1:8080/office/services/FlowrunServer?wsdl
//  >Import : http://127.0.0.1:8080/office/services/FlowrunServer?wsdl:0
//  >Import : http://127.0.0.1:8080/office/services/FlowrunServer?wsdl:1
//  >Import : http://127.0.0.1:8080/office/services/FlowrunServer?wsdl:2
// Encoding : UTF-8
// Version  : 1.0
// (2011-8-27 11:28:11 - - $Rev: 10138 $)
// ************************************************************************ //

unit FlowrunServer;

interface

uses InvokeRegistry, SOAPHTTPClient, Types, XSBuiltIns;

const
  IS_OPTN = $0001;
  IS_UNBD = $0002;
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
  // !:long            - "http://www.w3.org/2001/XMLSchema"[Gbl]

  FlowRun              = class;                 { "http://domain.flowrun.office.sxsihe.com"[GblCplx] }
  FlowRunProcess       = class;                 { "http://domain.flowrunprocess.office.sxsihe.com"[GblCplx] }

  ArrayOfFlowRunProcess = array of FlowRunProcess;   { "http://domain.flowrunprocess.office.sxsihe.com"[GblCplx] }


  // ************************************************************************ //
  // XML       : FlowRun, global, <complexType>
  // Namespace : http://domain.flowrun.office.sxsihe.com
  // ************************************************************************ //
  FlowRun = class(TRemotable)
  private
    FbeginTime: WideString;
    FbeginTime_Specified: boolean;
    FbeginUser: WideString;
    FbeginUser_Specified: boolean;
    FbeginUserId: WideString;
    FbeginUserId_Specified: boolean;
    FdeptCode: WideString;
    FdeptCode_Specified: boolean;
    FendTime: WideString;
    FendTime_Specified: boolean;
    FendUser: WideString;
    FendUser_Specified: boolean;
    FendUserId: WideString;
    FendUserId_Specified: boolean;
    FflowRunProcesses: ArrayOfFlowRunProcess;
    FflowRunProcesses_Specified: boolean;
    FnowLevel: Int64;
    FnowLevel_Specified: boolean;
    Fremark: WideString;
    Fremark_Specified: boolean;
    FrunId: WideString;
    FrunId_Specified: boolean;
    FrunName: WideString;
    FrunName_Specified: boolean;
    FrunNo: WideString;
    FrunNo_Specified: boolean;
    procedure SetbeginTime(Index: Integer; const AWideString: WideString);
    function  beginTime_Specified(Index: Integer): boolean;
    procedure SetbeginUser(Index: Integer; const AWideString: WideString);
    function  beginUser_Specified(Index: Integer): boolean;
    procedure SetbeginUserId(Index: Integer; const AWideString: WideString);
    function  beginUserId_Specified(Index: Integer): boolean;
    procedure SetdeptCode(Index: Integer; const AWideString: WideString);
    function  deptCode_Specified(Index: Integer): boolean;
    procedure SetendTime(Index: Integer; const AWideString: WideString);
    function  endTime_Specified(Index: Integer): boolean;
    procedure SetendUser(Index: Integer; const AWideString: WideString);
    function  endUser_Specified(Index: Integer): boolean;
    procedure SetendUserId(Index: Integer; const AWideString: WideString);
    function  endUserId_Specified(Index: Integer): boolean;
    procedure SetflowRunProcesses(Index: Integer; const AArrayOfFlowRunProcess: ArrayOfFlowRunProcess);
    function  flowRunProcesses_Specified(Index: Integer): boolean;
    procedure SetnowLevel(Index: Integer; const AInt64: Int64);
    function  nowLevel_Specified(Index: Integer): boolean;
    procedure Setremark(Index: Integer; const AWideString: WideString);
    function  remark_Specified(Index: Integer): boolean;
    procedure SetrunId(Index: Integer; const AWideString: WideString);
    function  runId_Specified(Index: Integer): boolean;
    procedure SetrunName(Index: Integer; const AWideString: WideString);
    function  runName_Specified(Index: Integer): boolean;
    procedure SetrunNo(Index: Integer; const AWideString: WideString);
    function  runNo_Specified(Index: Integer): boolean;
  public
    destructor Destroy; override;
  published
    property beginTime:        WideString             Index (IS_OPTN or IS_NLBL) read FbeginTime write SetbeginTime stored beginTime_Specified;
    property beginUser:        WideString             Index (IS_OPTN or IS_NLBL) read FbeginUser write SetbeginUser stored beginUser_Specified;
    property beginUserId:      WideString             Index (IS_OPTN or IS_NLBL) read FbeginUserId write SetbeginUserId stored beginUserId_Specified;
    property deptCode:         WideString             Index (IS_OPTN or IS_NLBL) read FdeptCode write SetdeptCode stored deptCode_Specified;
    property endTime:          WideString             Index (IS_OPTN or IS_NLBL) read FendTime write SetendTime stored endTime_Specified;
    property endUser:          WideString             Index (IS_OPTN or IS_NLBL) read FendUser write SetendUser stored endUser_Specified;
    property endUserId:        WideString             Index (IS_OPTN or IS_NLBL) read FendUserId write SetendUserId stored endUserId_Specified;
    property flowRunProcesses: ArrayOfFlowRunProcess  Index (IS_OPTN or IS_NLBL) read FflowRunProcesses write SetflowRunProcesses stored flowRunProcesses_Specified;
    property nowLevel:         Int64                  Index (IS_OPTN or IS_NLBL) read FnowLevel write SetnowLevel stored nowLevel_Specified;
    property remark:           WideString             Index (IS_OPTN or IS_NLBL) read Fremark write Setremark stored remark_Specified;
    property runId:            WideString             Index (IS_OPTN or IS_NLBL) read FrunId write SetrunId stored runId_Specified;
    property runName:          WideString             Index (IS_OPTN or IS_NLBL) read FrunName write SetrunName stored runName_Specified;
    property runNo:            WideString             Index (IS_OPTN or IS_NLBL) read FrunNo write SetrunNo stored runNo_Specified;
  end;



  // ************************************************************************ //
  // XML       : FlowRunProcess, global, <complexType>
  // Namespace : http://domain.flowrunprocess.office.sxsihe.com
  // ************************************************************************ //
  FlowRunProcess = class(TRemotable)
  private
    FbeginUser: WideString;
    FbeginUser_Specified: boolean;
    FcreateUserId: WideString;
    FcreateUserId_Specified: boolean;
    FflowRun: FlowRun;
    FflowRun_Specified: boolean;
    FprocessCreateTime: WideString;
    FprocessCreateTime_Specified: boolean;
    FprocessFlag: Int64;
    FprocessFlag_Specified: boolean;
    FprocessId: WideString;
    FprocessId_Specified: boolean;
    FprocessLevel: Int64;
    FprocessLevel_Specified: boolean;
    FprocessLog: WideString;
    FprocessLog_Specified: boolean;
    FprocessRemark: WideString;
    FprocessRemark_Specified: boolean;
    FprocessTime: WideString;
    FprocessTime_Specified: boolean;
    FrunName: WideString;
    FrunName_Specified: boolean;
    Frunid: WideString;
    Frunid_Specified: boolean;
    FuserId: WideString;
    FuserId_Specified: boolean;
    FuserName: WideString;
    FuserName_Specified: boolean;
    procedure SetbeginUser(Index: Integer; const AWideString: WideString);
    function  beginUser_Specified(Index: Integer): boolean;
    procedure SetcreateUserId(Index: Integer; const AWideString: WideString);
    function  createUserId_Specified(Index: Integer): boolean;
    procedure SetflowRun(Index: Integer; const AFlowRun: FlowRun);
    function  flowRun_Specified(Index: Integer): boolean;
    procedure SetprocessCreateTime(Index: Integer; const AWideString: WideString);
    function  processCreateTime_Specified(Index: Integer): boolean;
    procedure SetprocessFlag(Index: Integer; const AInt64: Int64);
    function  processFlag_Specified(Index: Integer): boolean;
    procedure SetprocessId(Index: Integer; const AWideString: WideString);
    function  processId_Specified(Index: Integer): boolean;
    procedure SetprocessLevel(Index: Integer; const AInt64: Int64);
    function  processLevel_Specified(Index: Integer): boolean;
    procedure SetprocessLog(Index: Integer; const AWideString: WideString);
    function  processLog_Specified(Index: Integer): boolean;
    procedure SetprocessRemark(Index: Integer; const AWideString: WideString);
    function  processRemark_Specified(Index: Integer): boolean;
    procedure SetprocessTime(Index: Integer; const AWideString: WideString);
    function  processTime_Specified(Index: Integer): boolean;
    procedure SetrunName(Index: Integer; const AWideString: WideString);
    function  runName_Specified(Index: Integer): boolean;
    procedure Setrunid(Index: Integer; const AWideString: WideString);
    function  runid_Specified(Index: Integer): boolean;
    procedure SetuserId(Index: Integer; const AWideString: WideString);
    function  userId_Specified(Index: Integer): boolean;
    procedure SetuserName(Index: Integer; const AWideString: WideString);
    function  userName_Specified(Index: Integer): boolean;
  public
    destructor Destroy; override;
  published
    property beginUser:         WideString  Index (IS_OPTN or IS_NLBL) read FbeginUser write SetbeginUser stored beginUser_Specified;
    property createUserId:      WideString  Index (IS_OPTN or IS_NLBL) read FcreateUserId write SetcreateUserId stored createUserId_Specified;
    property flowRun:           FlowRun     Index (IS_OPTN or IS_NLBL) read FflowRun write SetflowRun stored flowRun_Specified;
    property processCreateTime: WideString  Index (IS_OPTN or IS_NLBL) read FprocessCreateTime write SetprocessCreateTime stored processCreateTime_Specified;
    property processFlag:       Int64       Index (IS_OPTN or IS_NLBL) read FprocessFlag write SetprocessFlag stored processFlag_Specified;
    property processId:         WideString  Index (IS_OPTN or IS_NLBL) read FprocessId write SetprocessId stored processId_Specified;
    property processLevel:      Int64       Index (IS_OPTN or IS_NLBL) read FprocessLevel write SetprocessLevel stored processLevel_Specified;
    property processLog:        WideString  Index (IS_OPTN or IS_NLBL) read FprocessLog write SetprocessLog stored processLog_Specified;
    property processRemark:     WideString  Index (IS_OPTN or IS_NLBL) read FprocessRemark write SetprocessRemark stored processRemark_Specified;
    property processTime:       WideString  Index (IS_OPTN or IS_NLBL) read FprocessTime write SetprocessTime stored processTime_Specified;
    property runName:           WideString  Index (IS_OPTN or IS_NLBL) read FrunName write SetrunName stored runName_Specified;
    property runid:             WideString  Index (IS_OPTN or IS_NLBL) read Frunid write Setrunid stored runid_Specified;
    property userId:            WideString  Index (IS_OPTN or IS_NLBL) read FuserId write SetuserId stored userId_Specified;
    property userName:          WideString  Index (IS_OPTN or IS_NLBL) read FuserName write SetuserName stored userName_Specified;
  end;


  // ************************************************************************ //
  // Namespace : http://server.flowrunprocess.office.sxsihe.com
  // transport : http://schemas.xmlsoap.org/soap/http
  // style     : document
  // binding   : FlowrunServerHttpBinding
  // service   : FlowrunServer
  // port      : FlowrunServerHttpPort
  // URL       : http://127.0.0.1:8080/office/services/FlowrunServer
  // ************************************************************************ //
  FlowrunServerPortType = interface(IInvokable)
  ['{B5F0937F-754F-AED9-5D86-B02BE82089B3}']
    function  getFlowCount(const in0: WideString): ArrayOfFlowRunProcess; stdcall;
  end;

function GetFlowrunServerPortType(UseWSDL: Boolean=System.False; Addr: string=''; HTTPRIO: THTTPRIO = nil): FlowrunServerPortType;


implementation
  uses SysUtils;

function GetFlowrunServerPortType(UseWSDL: Boolean; Addr: string; HTTPRIO: THTTPRIO): FlowrunServerPortType;
const
  defWSDL = 'http://127.0.0.1:8080/office/services/FlowrunServer?wsdl';
  defURL  = 'http://127.0.0.1:8080/office/services/FlowrunServer';
  defSvc  = 'FlowrunServer';
  defPrt  = 'FlowrunServerHttpPort';
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
    Result := (RIO as FlowrunServerPortType);
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


destructor FlowRun.Destroy;
var
  I: Integer;
begin
  for I := 0 to Length(FflowRunProcesses)-1 do
    FreeAndNil(FflowRunProcesses[I]);
  SetLength(FflowRunProcesses, 0);
  inherited Destroy;
end;

procedure FlowRun.SetbeginTime(Index: Integer; const AWideString: WideString);
begin
  FbeginTime := AWideString;
  FbeginTime_Specified := True;
end;

function FlowRun.beginTime_Specified(Index: Integer): boolean;
begin
  Result := FbeginTime_Specified;
end;

procedure FlowRun.SetbeginUser(Index: Integer; const AWideString: WideString);
begin
  FbeginUser := AWideString;
  FbeginUser_Specified := True;
end;

function FlowRun.beginUser_Specified(Index: Integer): boolean;
begin
  Result := FbeginUser_Specified;
end;

procedure FlowRun.SetbeginUserId(Index: Integer; const AWideString: WideString);
begin
  FbeginUserId := AWideString;
  FbeginUserId_Specified := True;
end;

function FlowRun.beginUserId_Specified(Index: Integer): boolean;
begin
  Result := FbeginUserId_Specified;
end;

procedure FlowRun.SetdeptCode(Index: Integer; const AWideString: WideString);
begin
  FdeptCode := AWideString;
  FdeptCode_Specified := True;
end;

function FlowRun.deptCode_Specified(Index: Integer): boolean;
begin
  Result := FdeptCode_Specified;
end;

procedure FlowRun.SetendTime(Index: Integer; const AWideString: WideString);
begin
  FendTime := AWideString;
  FendTime_Specified := True;
end;

function FlowRun.endTime_Specified(Index: Integer): boolean;
begin
  Result := FendTime_Specified;
end;

procedure FlowRun.SetendUser(Index: Integer; const AWideString: WideString);
begin
  FendUser := AWideString;
  FendUser_Specified := True;
end;

function FlowRun.endUser_Specified(Index: Integer): boolean;
begin
  Result := FendUser_Specified;
end;

procedure FlowRun.SetendUserId(Index: Integer; const AWideString: WideString);
begin
  FendUserId := AWideString;
  FendUserId_Specified := True;
end;

function FlowRun.endUserId_Specified(Index: Integer): boolean;
begin
  Result := FendUserId_Specified;
end;

procedure FlowRun.SetflowRunProcesses(Index: Integer; const AArrayOfFlowRunProcess: ArrayOfFlowRunProcess);
begin
  FflowRunProcesses := AArrayOfFlowRunProcess;
  FflowRunProcesses_Specified := True;
end;

function FlowRun.flowRunProcesses_Specified(Index: Integer): boolean;
begin
  Result := FflowRunProcesses_Specified;
end;

procedure FlowRun.SetnowLevel(Index: Integer; const AInt64: Int64);
begin
  FnowLevel := AInt64;
  FnowLevel_Specified := True;
end;

function FlowRun.nowLevel_Specified(Index: Integer): boolean;
begin
  Result := FnowLevel_Specified;
end;

procedure FlowRun.Setremark(Index: Integer; const AWideString: WideString);
begin
  Fremark := AWideString;
  Fremark_Specified := True;
end;

function FlowRun.remark_Specified(Index: Integer): boolean;
begin
  Result := Fremark_Specified;
end;

procedure FlowRun.SetrunId(Index: Integer; const AWideString: WideString);
begin
  FrunId := AWideString;
  FrunId_Specified := True;
end;

function FlowRun.runId_Specified(Index: Integer): boolean;
begin
  Result := FrunId_Specified;
end;

procedure FlowRun.SetrunName(Index: Integer; const AWideString: WideString);
begin
  FrunName := AWideString;
  FrunName_Specified := True;
end;

function FlowRun.runName_Specified(Index: Integer): boolean;
begin
  Result := FrunName_Specified;
end;

procedure FlowRun.SetrunNo(Index: Integer; const AWideString: WideString);
begin
  FrunNo := AWideString;
  FrunNo_Specified := True;
end;

function FlowRun.runNo_Specified(Index: Integer): boolean;
begin
  Result := FrunNo_Specified;
end;

destructor FlowRunProcess.Destroy;
begin
  FreeAndNil(FflowRun);
  inherited Destroy;
end;

procedure FlowRunProcess.SetbeginUser(Index: Integer; const AWideString: WideString);
begin
  FbeginUser := AWideString;
  FbeginUser_Specified := True;
end;

function FlowRunProcess.beginUser_Specified(Index: Integer): boolean;
begin
  Result := FbeginUser_Specified;
end;

procedure FlowRunProcess.SetcreateUserId(Index: Integer; const AWideString: WideString);
begin
  FcreateUserId := AWideString;
  FcreateUserId_Specified := True;
end;

function FlowRunProcess.createUserId_Specified(Index: Integer): boolean;
begin
  Result := FcreateUserId_Specified;
end;

procedure FlowRunProcess.SetflowRun(Index: Integer; const AFlowRun: FlowRun);
begin
  FflowRun := AFlowRun;
  FflowRun_Specified := True;
end;

function FlowRunProcess.flowRun_Specified(Index: Integer): boolean;
begin
  Result := FflowRun_Specified;
end;

procedure FlowRunProcess.SetprocessCreateTime(Index: Integer; const AWideString: WideString);
begin
  FprocessCreateTime := AWideString;
  FprocessCreateTime_Specified := True;
end;

function FlowRunProcess.processCreateTime_Specified(Index: Integer): boolean;
begin
  Result := FprocessCreateTime_Specified;
end;

procedure FlowRunProcess.SetprocessFlag(Index: Integer; const AInt64: Int64);
begin
  FprocessFlag := AInt64;
  FprocessFlag_Specified := True;
end;

function FlowRunProcess.processFlag_Specified(Index: Integer): boolean;
begin
  Result := FprocessFlag_Specified;
end;

procedure FlowRunProcess.SetprocessId(Index: Integer; const AWideString: WideString);
begin
  FprocessId := AWideString;
  FprocessId_Specified := True;
end;

function FlowRunProcess.processId_Specified(Index: Integer): boolean;
begin
  Result := FprocessId_Specified;
end;

procedure FlowRunProcess.SetprocessLevel(Index: Integer; const AInt64: Int64);
begin
  FprocessLevel := AInt64;
  FprocessLevel_Specified := True;
end;

function FlowRunProcess.processLevel_Specified(Index: Integer): boolean;
begin
  Result := FprocessLevel_Specified;
end;

procedure FlowRunProcess.SetprocessLog(Index: Integer; const AWideString: WideString);
begin
  FprocessLog := AWideString;
  FprocessLog_Specified := True;
end;

function FlowRunProcess.processLog_Specified(Index: Integer): boolean;
begin
  Result := FprocessLog_Specified;
end;

procedure FlowRunProcess.SetprocessRemark(Index: Integer; const AWideString: WideString);
begin
  FprocessRemark := AWideString;
  FprocessRemark_Specified := True;
end;

function FlowRunProcess.processRemark_Specified(Index: Integer): boolean;
begin
  Result := FprocessRemark_Specified;
end;

procedure FlowRunProcess.SetprocessTime(Index: Integer; const AWideString: WideString);
begin
  FprocessTime := AWideString;
  FprocessTime_Specified := True;
end;

function FlowRunProcess.processTime_Specified(Index: Integer): boolean;
begin
  Result := FprocessTime_Specified;
end;

procedure FlowRunProcess.SetrunName(Index: Integer; const AWideString: WideString);
begin
  FrunName := AWideString;
  FrunName_Specified := True;
end;

function FlowRunProcess.runName_Specified(Index: Integer): boolean;
begin
  Result := FrunName_Specified;
end;

procedure FlowRunProcess.Setrunid(Index: Integer; const AWideString: WideString);
begin
  Frunid := AWideString;
  Frunid_Specified := True;
end;

function FlowRunProcess.runid_Specified(Index: Integer): boolean;
begin
  Result := Frunid_Specified;
end;

procedure FlowRunProcess.SetuserId(Index: Integer; const AWideString: WideString);
begin
  FuserId := AWideString;
  FuserId_Specified := True;
end;

function FlowRunProcess.userId_Specified(Index: Integer): boolean;
begin
  Result := FuserId_Specified;
end;

procedure FlowRunProcess.SetuserName(Index: Integer; const AWideString: WideString);
begin
  FuserName := AWideString;
  FuserName_Specified := True;
end;

function FlowRunProcess.userName_Specified(Index: Integer): boolean;
begin
  Result := FuserName_Specified;
end;

initialization
  InvRegistry.RegisterInterface(TypeInfo(FlowrunServerPortType), 'http://server.flowrunprocess.office.sxsihe.com', 'UTF-8');
  InvRegistry.RegisterDefaultSOAPAction(TypeInfo(FlowrunServerPortType), '');
  InvRegistry.RegisterInvokeOptions(TypeInfo(FlowrunServerPortType), ioDocument);
  InvRegistry.RegisterExternalParamName(TypeInfo(FlowrunServerPortType), 'getFlowCount', 'out_', 'out');
  RemClassRegistry.RegisterXSInfo(TypeInfo(ArrayOfFlowRunProcess), 'http://domain.flowrunprocess.office.sxsihe.com', 'ArrayOfFlowRunProcess');
  RemClassRegistry.RegisterXSClass(FlowRun, 'http://domain.flowrun.office.sxsihe.com', 'FlowRun');
  RemClassRegistry.RegisterXSClass(FlowRunProcess, 'http://domain.flowrunprocess.office.sxsihe.com', 'FlowRunProcess');

end.