unit AxNetwork_TLB;

// ************************************************************************ //
// WARNING                                                                    
// -------                                                                    
// The types declared in this file were generated from data read from a       
// Type Library. If this type library is explicitly or indirectly (via        
// another type library referring to this type library) re-imported, or the   
// 'Refresh' command of the Type Library Editor activated while editing the   
// Type Library, the contents of this file will be regenerated and all        
// manual modifications will be lost.                                         
// ************************************************************************ //

// $Rev: 17244 $
// File generated on 12/14/2012 10:48:14 AM from Type Library described below.

// ************************************************************************  //
// Type Lib: H:\AxNetwork\InstallShield\Source\COM Files Shared\axnetwork32.dll (1)
// LIBID: {B52B14BA-244B-4006-86E0-2923CB69D881}
// LCID: 0
// Helpfile: 
// HelpString: ActiveXperts Network Component 4.4 Type Library
// DepndLst: 
//   (1) v2.0 stdole, (C:\WINDOWS\system32\stdole2.tlb)
// Errors:
//   Hint: Member 'Set' of 'ISnmpManager' changed to 'Set_'
//   Hint: Member 'Type' of 'ISnmpObject' changed to 'Type_'
//   Hint: Member 'Class' of 'IDnsRecord' changed to 'Class_'
//   Hint: Member 'Type' of 'IDnsRecord' changed to 'Type_'
//   Hint: Member 'Set' of 'I_SnmpManager' changed to 'Set_'
//   Hint: Member 'Set' of 'ISnmpManager' changed to 'Set_'
//   Hint: Member 'Type' of 'ISnmpObject' changed to 'Type_'
//   Hint: Member 'Class' of 'IDnsRecord' changed to 'Class_'
//   Hint: Member 'Type' of 'IDnsRecord' changed to 'Type_'
//   Hint: Member 'Set' of 'I_SnmpManager' changed to 'Set_'
//   WARN: Could not find file 't:\utilities\TLIBIMP.SYM, G:\axnetwork\TLIBIMP.SYM, t:\utilities\..\bin\tlibimp.sym'
// Cmdline:
//   tlibimp -P+ -Ha- -Hs- -Hr- -D"G:\AxNetwork\samples\Delphi\Imports\" "H:\AxNetwork\InstallShield\Source\COM Files Shared\axnetwork32.dll"
// ************************************************************************ //
{$TYPEDADDRESS OFF} // Unit must be compiled without type-checked pointers. 
{$WARN SYMBOL_PLATFORM OFF}
{$WRITEABLECONST ON}
{$VARPROPSETTER ON}
{$ALIGN 4}
interface

uses Windows, ActiveX, Classes, Graphics, OleServer, StdVCL, Variants;
  

// *********************************************************************//
// GUIDS declared in the TypeLibrary. Following prefixes are used:        
//   Type Libraries     : LIBID_xxxx                                      
//   CoClasses          : CLASS_xxxx                                      
//   DISPInterfaces     : DIID_xxxx                                       
//   Non-DISP interfaces: IID_xxxx                                        
// *********************************************************************//
const
  // TypeLibrary Major and minor versions
  AxNetworkMajorVersion = 1;
  AxNetworkMinorVersion = 0;

  LIBID_AxNetwork: TGUID = '{B52B14BA-244B-4006-86E0-2923CB69D881}';

  IID_IRSh: TGUID = '{844E4159-8D81-466B-9D13-7CE8098D4A6B}';
  CLASS_RSh: TGUID = '{5A128291-2445-441C-A8E9-ED886D053019}';
  IID_INtp: TGUID = '{CC932613-BE5F-43B3-9955-A40E1A8D736C}';
  CLASS_Ntp: TGUID = '{9591DC19-DD2F-4AD4-A3B6-65CDC428ABD1}';
  IID_IWOL: TGUID = '{18AD1230-A4C9-4A48-98B3-B3C669D28001}';
  CLASS_WOL: TGUID = '{454BE66D-12D0-43D0-87FE-99EE02E2C05B}';
  IID_IIcmp: TGUID = '{A92A390F-E285-4A8E-ACE1-C9981CE951E9}';
  CLASS_Icmp: TGUID = '{743A672A-9985-4866-BC54-9C89087E01AE}';
  IID_INwConstants: TGUID = '{37B4E86F-AAE3-48AC-922B-DF90945125B9}';
  CLASS_NwConstants: TGUID = '{EC4937DE-1B46-4AB4-BE3B-2CEF007F0D36}';
  IID_ISnmpManager: TGUID = '{1542A06C-4DBA-407A-B54D-991D13D481AD}';
  CLASS_SnmpManager: TGUID = '{97AAC3BF-BF70-405A-A1CA-1B1AE465F5C6}';
  IID_ISnmpTrap: TGUID = '{66673904-CCFB-45C5-8AFA-5C003BFE48FA}';
  CLASS_SnmpTrap: TGUID = '{E00A6261-0E7E-46FD-AEFF-36995D4F202A}';
  IID_ISnmpTrapManager: TGUID = '{BCB9AFE8-D460-4BA6-AD97-A0ACD4A76E4F}';
  CLASS_SnmpTrapManager: TGUID = '{27F65374-7C6D-4456-824F-1603CF5C8FD8}';
  IID_IFtpServer: TGUID = '{B629A000-C7D2-4CFB-94D7-9797545EA6D1}';
  CLASS_FtpServer: TGUID = '{0BBB8BEE-8043-4807-A9D6-8B5AFC8E0308}';
  IID_IFtpFile: TGUID = '{0B545BC4-BFB2-4426-8EDF-2F482EA5C511}';
  CLASS_FtpFile: TGUID = '{B58DEFA2-B1D6-4381-AA80-E746F03F95CF}';
  IID_IUdp: TGUID = '{96DD0191-EFBF-4C6E-B045-DB33F0D4A72F}';
  CLASS_Udp: TGUID = '{01E89353-9C04-4B25-8CAF-436D147BEA0D}';
  IID_ISnmpObject: TGUID = '{C3E4F5F3-C188-4F3B-9A41-9CAE2891150E}';
  CLASS_SnmpObject: TGUID = '{A6174470-3F28-4350-8621-BD0A20A5E0B6}';
  IID_ITcp: TGUID = '{4CCDB6A4-1BEE-4D3C-9937-D53CDFB5E1A3}';
  CLASS_Tcp: TGUID = '{916C28A2-8314-4AA5-9E25-18E5DEFBE2A3}';
  IID_IIPtoCountry: TGUID = '{D886339C-6F33-49AC-9FA8-73FC5A227769}';
  CLASS_IPtoCountry: TGUID = '{E6645574-3DB3-418F-AF16-229EF24EE2C8}';
  IID_IDnsServer: TGUID = '{D51DDAA9-6264-4ED7-82DF-1A46DE9D1C37}';
  CLASS_DnsServer: TGUID = '{13BE898F-BED8-4DD5-95A8-1D07FC891E5A}';
  IID_IDnsRecord: TGUID = '{CFCFF8CA-30EA-44F8-856E-52AD9A971024}';
  CLASS_DnsRecord: TGUID = '{3506465E-79C9-4486-AB94-D91EFF87CAC0}';
  IID_ISsh: TGUID = '{CF6C8D3D-1ACE-4111-AE15-724CB21DAC08}';
  CLASS_Ssh: TGUID = '{EC34BA42-AFDE-4B9C-BDBF-CB994E5493E5}';
  IID_ISnmpMibBrowser: TGUID = '{3FEF0C60-A4D8-4740-A6B7-5DF4388996B0}';
  CLASS_SnmpMibBrowser: TGUID = '{895ABC88-39A6-4BA0-9733-2A7392D5AD50}';
  IID_ITftpServer: TGUID = '{411DBA2E-A588-4F74-AD8B-4E426E63894A}';
  CLASS_TftpServer: TGUID = '{115B3846-4A61-499B-AC97-7ED71862B7A9}';
  IID_IMsn: TGUID = '{6EA3B1C3-71BA-4404-AA01-BB39CE2A3423}';
  CLASS_Msn: TGUID = '{2F2FA2B6-3391-4BDC-8447-01E62DBCD367}';
  IID_IRadius: TGUID = '{8218765A-2229-40DF-B600-A8A64AF09AC5}';
  CLASS_Radius: TGUID = '{BA61EEFD-EA47-4E5B-BE28-89E71633E226}';
  IID_IScp: TGUID = '{4116F2EA-0122-496A-A70E-AFFD0A9B5F6A}';
  CLASS_Scp: TGUID = '{14EDB06A-7BAF-403C-955A-87E01DD81368}';
  IID_ISFtp: TGUID = '{06B4D9C1-3A2D-43C3-8E1E-72BD1EBA6B4D}';
  CLASS_SFtp: TGUID = '{63C9D46B-2391-4399-8202-EC7464D55526}';
  IID_ISFtpFile: TGUID = '{5479FBF8-C8BD-4DC0-9967-AAA27F768994}';
  CLASS_SFtpFile: TGUID = '{0B5F4F80-E099-4158-96A4-54CD81AD212B}';
  IID_IHttpEx: TGUID = '{805D87DC-5860-4562-BE30-802A47A2F7E0}';
  CLASS_HttpEx: TGUID = '{522D4F3C-0F01-42E1-A22D-19068FDA0EC7}';
  IID_ITraceRoute: TGUID = '{081790B5-1D5D-4FFF-9F46-6B5F2E144BFF}';
  CLASS_TraceRoute: TGUID = '{04596FB6-AFDF-4997-8CA7-78DF085C1FA5}';
  IID_ITraceHop: TGUID = '{601A723F-F66D-4129-91D5-AD1B5E9CB590}';
  CLASS_TraceHop: TGUID = '{9EF8CC81-5438-4614-89E7-26052B6A9D2F}';
  IID_I_SnmpManager: TGUID = '{F46A9413-336E-4E18-A2C3-CD4068C25A0A}';
  CLASS__SnmpManager: TGUID = '{A16CD138-E448-47AA-BFD7-5A6F10C5793B}';
  IID_I_SnmpTrapManager: TGUID = '{07316FD5-B0E6-4A17-9015-9ABC7FECAEB4}';
  CLASS__SnmpTrapManager: TGUID = '{634320AF-A7F3-4048-8A52-D1387F44B8CC}';
  IID_IVMware: TGUID = '{EB3954ED-BAF8-4623-9B38-811C6894E87F}';
  CLASS_VMware: TGUID = '{621A76C5-D037-43B7-9EFE-E92E04CF21A9}';
  IID_IXen: TGUID = '{4D219C63-9EEC-4419-8764-FFC69299B22C}';
  CLASS_Xen: TGUID = '{7EF7E4E7-F6BA-4ED9-B4FE-58633AC378D6}';
type

// *********************************************************************//
// Forward declaration of types defined in TypeLibrary                    
// *********************************************************************//
  IRSh = interface;
  IRShDisp = dispinterface;
  INtp = interface;
  INtpDisp = dispinterface;
  IWOL = interface;
  IWOLDisp = dispinterface;
  IIcmp = interface;
  IIcmpDisp = dispinterface;
  INwConstants = interface;
  INwConstantsDisp = dispinterface;
  ISnmpManager = interface;
  ISnmpManagerDisp = dispinterface;
  ISnmpTrap = interface;
  ISnmpTrapDisp = dispinterface;
  ISnmpTrapManager = interface;
  ISnmpTrapManagerDisp = dispinterface;
  IFtpServer = interface;
  IFtpServerDisp = dispinterface;
  IFtpFile = interface;
  IFtpFileDisp = dispinterface;
  IUdp = interface;
  IUdpDisp = dispinterface;
  ISnmpObject = interface;
  ISnmpObjectDisp = dispinterface;
  ITcp = interface;
  ITcpDisp = dispinterface;
  IIPtoCountry = interface;
  IIPtoCountryDisp = dispinterface;
  IDnsServer = interface;
  IDnsServerDisp = dispinterface;
  IDnsRecord = interface;
  IDnsRecordDisp = dispinterface;
  ISsh = interface;
  ISshDisp = dispinterface;
  ISnmpMibBrowser = interface;
  ISnmpMibBrowserDisp = dispinterface;
  ITftpServer = interface;
  ITftpServerDisp = dispinterface;
  IMsn = interface;
  IMsnDisp = dispinterface;
  IRadius = interface;
  IRadiusDisp = dispinterface;
  IScp = interface;
  IScpDisp = dispinterface;
  ISFtp = interface;
  ISFtpDisp = dispinterface;
  ISFtpFile = interface;
  ISFtpFileDisp = dispinterface;
  IHttpEx = interface;
  IHttpExDisp = dispinterface;
  ITraceRoute = interface;
  ITraceRouteDisp = dispinterface;
  ITraceHop = interface;
  ITraceHopDisp = dispinterface;
  I_SnmpManager = interface;
  I_SnmpManagerDisp = dispinterface;
  I_SnmpTrapManager = interface;
  I_SnmpTrapManagerDisp = dispinterface;
  IVMware = interface;
  IVMwareDisp = dispinterface;
  IXen = interface;
  IXenDisp = dispinterface;

// *********************************************************************//
// Declaration of CoClasses defined in Type Library                       
// (NOTE: Here we map each CoClass to its Default Interface)              
// *********************************************************************//
  RSh = IRSh;
  Ntp = INtp;
  WOL = IWOL;
  Icmp = IIcmp;
  NwConstants = INwConstants;
  SnmpManager = ISnmpManager;
  SnmpTrap = ISnmpTrap;
  SnmpTrapManager = ISnmpTrapManager;
  FtpServer = IFtpServer;
  FtpFile = IFtpFile;
  Udp = IUdp;
  SnmpObject = ISnmpObject;
  Tcp = ITcp;
  IPtoCountry = IIPtoCountry;
  DnsServer = IDnsServer;
  DnsRecord = IDnsRecord;
  Ssh = ISsh;
  SnmpMibBrowser = ISnmpMibBrowser;
  TftpServer = ITftpServer;
  Msn = IMsn;
  Radius = IRadius;
  Scp = IScp;
  SFtp = ISFtp;
  SFtpFile = ISFtpFile;
  HttpEx = IHttpEx;
  TraceRoute = ITraceRoute;
  TraceHop = ITraceHop;
  _SnmpManager = I_SnmpManager;
  _SnmpTrapManager = I_SnmpTrapManager;
  VMware = IVMware;
  Xen = IXen;


// *********************************************************************//
// Declaration of structures, unions and aliases.                         
// *********************************************************************//
  POleVariant1 = ^OleVariant; {*}


// *********************************************************************//
// Interface: IRSh
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {844E4159-8D81-466B-9D13-7CE8098D4A6B}
// *********************************************************************//
  IRSh = interface(IDispatch)
    ['{844E4159-8D81-466B-9D13-7CE8098D4A6B}']
    function Get_Version: WideString; safecall;
    function Get_Build: WideString; safecall;
    function Get_Module: WideString; safecall;
    function Get_LicenseStatus: WideString; safecall;
    procedure Set_Reserved(Param1: Integer); safecall;
    function Get_LastError: Integer; safecall;
    function Get_LogFile: WideString; safecall;
    procedure Set_LogFile(const pVal: WideString); safecall;
    function Get_LicenseKey: WideString; safecall;
    procedure Clear; safecall;
    function GetErrorDescription(ErrorCode: Integer): WideString; safecall;
    procedure Activate(const bstrRegKey: WideString; bPersistent: WordBool); safecall;
    procedure Sleep(lMilliSeconds: Integer); safecall;
    function Get_Host: WideString; safecall;
    procedure Set_Host(const pVal: WideString); safecall;
    function Get_UserName: WideString; safecall;
    procedure Set_UserName(const pVal: WideString); safecall;
    function Get_Command: WideString; safecall;
    procedure Set_Command(const pVal: WideString); safecall;
    function Get_ScriptTimeOut: Integer; safecall;
    procedure Set_ScriptTimeOut(pVal: Integer); safecall;
    function Get_StdOut: WideString; safecall;
    function Get_StdErr: WideString; safecall;
    procedure Run; safecall;
    property Version: WideString read Get_Version;
    property Build: WideString read Get_Build;
    property Module: WideString read Get_Module;
    property LicenseStatus: WideString read Get_LicenseStatus;
    property Reserved: Integer write Set_Reserved;
    property LastError: Integer read Get_LastError;
    property LogFile: WideString read Get_LogFile write Set_LogFile;
    property LicenseKey: WideString read Get_LicenseKey;
    property Host: WideString read Get_Host write Set_Host;
    property UserName: WideString read Get_UserName write Set_UserName;
    property Command: WideString read Get_Command write Set_Command;
    property ScriptTimeOut: Integer read Get_ScriptTimeOut write Set_ScriptTimeOut;
    property StdOut: WideString read Get_StdOut;
    property StdErr: WideString read Get_StdErr;
  end;

// *********************************************************************//
// DispIntf:  IRShDisp
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {844E4159-8D81-466B-9D13-7CE8098D4A6B}
// *********************************************************************//
  IRShDisp = dispinterface
    ['{844E4159-8D81-466B-9D13-7CE8098D4A6B}']
    property Version: WideString readonly dispid 1;
    property Build: WideString readonly dispid 2;
    property Module: WideString readonly dispid 3;
    property LicenseStatus: WideString readonly dispid 4;
    property Reserved: Integer writeonly dispid 5;
    property LastError: Integer readonly dispid 6;
    property LogFile: WideString dispid 7;
    property LicenseKey: WideString readonly dispid 8;
    procedure Clear; dispid 20;
    function GetErrorDescription(ErrorCode: Integer): WideString; dispid 21;
    procedure Activate(const bstrRegKey: WideString; bPersistent: WordBool); dispid 22;
    procedure Sleep(lMilliSeconds: Integer); dispid 23;
    property Host: WideString dispid 101;
    property UserName: WideString dispid 105;
    property Command: WideString dispid 106;
    property ScriptTimeOut: Integer dispid 107;
    property StdOut: WideString readonly dispid 110;
    property StdErr: WideString readonly dispid 111;
    procedure Run; dispid 201;
  end;

// *********************************************************************//
// Interface: INtp
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {CC932613-BE5F-43B3-9955-A40E1A8D736C}
// *********************************************************************//
  INtp = interface(IDispatch)
    ['{CC932613-BE5F-43B3-9955-A40E1A8D736C}']
    function Get_Version: WideString; safecall;
    function Get_Build: WideString; safecall;
    function Get_Module: WideString; safecall;
    function Get_LicenseStatus: WideString; safecall;
    procedure Set_Reserved(Param1: Integer); safecall;
    function Get_LastError: Integer; safecall;
    function Get_LogFile: WideString; safecall;
    procedure Set_LogFile(const pVal: WideString); safecall;
    function Get_LicenseKey: WideString; safecall;
    procedure Clear; safecall;
    function GetErrorDescription(ErrorCode: Integer): WideString; safecall;
    procedure Activate(const bstrRegKey: WideString; bPersistent: WordBool); safecall;
    procedure Sleep(lMilliSeconds: Integer); safecall;
    function Get_Year: Integer; safecall;
    function Get_Month: Integer; safecall;
    function Get_Day: Integer; safecall;
    function Get_Hour: Integer; safecall;
    function Get_Minute: Integer; safecall;
    function Get_Second: Integer; safecall;
    function Get_LocalOffsetSeconds: Integer; safecall;
    procedure GetTime(const TimeServer: WideString); safecall;
    property Version: WideString read Get_Version;
    property Build: WideString read Get_Build;
    property Module: WideString read Get_Module;
    property LicenseStatus: WideString read Get_LicenseStatus;
    property Reserved: Integer write Set_Reserved;
    property LastError: Integer read Get_LastError;
    property LogFile: WideString read Get_LogFile write Set_LogFile;
    property LicenseKey: WideString read Get_LicenseKey;
    property Year: Integer read Get_Year;
    property Month: Integer read Get_Month;
    property Day: Integer read Get_Day;
    property Hour: Integer read Get_Hour;
    property Minute: Integer read Get_Minute;
    property Second: Integer read Get_Second;
    property LocalOffsetSeconds: Integer read Get_LocalOffsetSeconds;
  end;

// *********************************************************************//
// DispIntf:  INtpDisp
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {CC932613-BE5F-43B3-9955-A40E1A8D736C}
// *********************************************************************//
  INtpDisp = dispinterface
    ['{CC932613-BE5F-43B3-9955-A40E1A8D736C}']
    property Version: WideString readonly dispid 1;
    property Build: WideString readonly dispid 2;
    property Module: WideString readonly dispid 3;
    property LicenseStatus: WideString readonly dispid 4;
    property Reserved: Integer writeonly dispid 5;
    property LastError: Integer readonly dispid 6;
    property LogFile: WideString dispid 7;
    property LicenseKey: WideString readonly dispid 8;
    procedure Clear; dispid 20;
    function GetErrorDescription(ErrorCode: Integer): WideString; dispid 21;
    procedure Activate(const bstrRegKey: WideString; bPersistent: WordBool); dispid 22;
    procedure Sleep(lMilliSeconds: Integer); dispid 23;
    property Year: Integer readonly dispid 101;
    property Month: Integer readonly dispid 102;
    property Day: Integer readonly dispid 103;
    property Hour: Integer readonly dispid 104;
    property Minute: Integer readonly dispid 105;
    property Second: Integer readonly dispid 106;
    property LocalOffsetSeconds: Integer readonly dispid 107;
    procedure GetTime(const TimeServer: WideString); dispid 201;
  end;

// *********************************************************************//
// Interface: IWOL
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {18AD1230-A4C9-4A48-98B3-B3C669D28001}
// *********************************************************************//
  IWOL = interface(IDispatch)
    ['{18AD1230-A4C9-4A48-98B3-B3C669D28001}']
    function Get_Version: WideString; safecall;
    function Get_Build: WideString; safecall;
    function Get_Module: WideString; safecall;
    function Get_LicenseStatus: WideString; safecall;
    procedure Set_Reserved(Param1: Integer); safecall;
    function Get_LastError: Integer; safecall;
    function Get_LogFile: WideString; safecall;
    procedure Set_LogFile(const pVal: WideString); safecall;
    function Get_LicenseKey: WideString; safecall;
    procedure Clear; safecall;
    function GetErrorDescription(ErrorCode: Integer): WideString; safecall;
    procedure Activate(const bstrRegKey: WideString; bPersistent: WordBool); safecall;
    procedure Sleep(lMilliSeconds: Integer); safecall;
    procedure WakeUp(const MacAddress: WideString); safecall;
    property Version: WideString read Get_Version;
    property Build: WideString read Get_Build;
    property Module: WideString read Get_Module;
    property LicenseStatus: WideString read Get_LicenseStatus;
    property Reserved: Integer write Set_Reserved;
    property LastError: Integer read Get_LastError;
    property LogFile: WideString read Get_LogFile write Set_LogFile;
    property LicenseKey: WideString read Get_LicenseKey;
  end;

// *********************************************************************//
// DispIntf:  IWOLDisp
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {18AD1230-A4C9-4A48-98B3-B3C669D28001}
// *********************************************************************//
  IWOLDisp = dispinterface
    ['{18AD1230-A4C9-4A48-98B3-B3C669D28001}']
    property Version: WideString readonly dispid 1;
    property Build: WideString readonly dispid 2;
    property Module: WideString readonly dispid 3;
    property LicenseStatus: WideString readonly dispid 4;
    property Reserved: Integer writeonly dispid 5;
    property LastError: Integer readonly dispid 6;
    property LogFile: WideString dispid 7;
    property LicenseKey: WideString readonly dispid 8;
    procedure Clear; dispid 20;
    function GetErrorDescription(ErrorCode: Integer): WideString; dispid 21;
    procedure Activate(const bstrRegKey: WideString; bPersistent: WordBool); dispid 22;
    procedure Sleep(lMilliSeconds: Integer); dispid 23;
    procedure WakeUp(const MacAddress: WideString); dispid 201;
  end;

// *********************************************************************//
// Interface: IIcmp
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {A92A390F-E285-4A8E-ACE1-C9981CE951E9}
// *********************************************************************//
  IIcmp = interface(IDispatch)
    ['{A92A390F-E285-4A8E-ACE1-C9981CE951E9}']
    function Get_Version: WideString; safecall;
    function Get_Build: WideString; safecall;
    function Get_Module: WideString; safecall;
    function Get_LicenseStatus: WideString; safecall;
    procedure Set_Reserved(Param1: Integer); safecall;
    function Get_LastError: Integer; safecall;
    function Get_LogFile: WideString; safecall;
    procedure Set_LogFile(const pVal: WideString); safecall;
    function Get_LicenseKey: WideString; safecall;
    procedure Clear; safecall;
    function GetErrorDescription(ErrorCode: Integer): WideString; safecall;
    procedure Activate(const bstrRegKey: WideString; bPersistent: WordBool); safecall;
    procedure Sleep(MilliSecs: Integer); safecall;
    function Get_BufferSize: Integer; safecall;
    procedure Set_BufferSize(pVal: Integer); safecall;
    function Get_Ttl: Integer; safecall;
    procedure Set_Ttl(pVal: Integer); safecall;
    function Get_LastDuration: Integer; safecall;
    function Get_LastTtl: Integer; safecall;
    procedure Ping(const DestinationHost: WideString; TimeoutMsecs: Integer); safecall;
    property Version: WideString read Get_Version;
    property Build: WideString read Get_Build;
    property Module: WideString read Get_Module;
    property LicenseStatus: WideString read Get_LicenseStatus;
    property Reserved: Integer write Set_Reserved;
    property LastError: Integer read Get_LastError;
    property LogFile: WideString read Get_LogFile write Set_LogFile;
    property LicenseKey: WideString read Get_LicenseKey;
    property BufferSize: Integer read Get_BufferSize write Set_BufferSize;
    property Ttl: Integer read Get_Ttl write Set_Ttl;
    property LastDuration: Integer read Get_LastDuration;
    property LastTtl: Integer read Get_LastTtl;
  end;

// *********************************************************************//
// DispIntf:  IIcmpDisp
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {A92A390F-E285-4A8E-ACE1-C9981CE951E9}
// *********************************************************************//
  IIcmpDisp = dispinterface
    ['{A92A390F-E285-4A8E-ACE1-C9981CE951E9}']
    property Version: WideString readonly dispid 1;
    property Build: WideString readonly dispid 2;
    property Module: WideString readonly dispid 3;
    property LicenseStatus: WideString readonly dispid 4;
    property Reserved: Integer writeonly dispid 5;
    property LastError: Integer readonly dispid 6;
    property LogFile: WideString dispid 7;
    property LicenseKey: WideString readonly dispid 8;
    procedure Clear; dispid 20;
    function GetErrorDescription(ErrorCode: Integer): WideString; dispid 21;
    procedure Activate(const bstrRegKey: WideString; bPersistent: WordBool); dispid 22;
    procedure Sleep(MilliSecs: Integer); dispid 23;
    property BufferSize: Integer dispid 101;
    property Ttl: Integer dispid 102;
    property LastDuration: Integer readonly dispid 103;
    property LastTtl: Integer readonly dispid 104;
    procedure Ping(const DestinationHost: WideString; TimeoutMsecs: Integer); dispid 201;
  end;

// *********************************************************************//
// Interface: INwConstants
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {37B4E86F-AAE3-48AC-922B-DF90945125B9}
// *********************************************************************//
  INwConstants = interface(IDispatch)
    ['{37B4E86F-AAE3-48AC-922B-DF90945125B9}']
    function Get_nwSOCKET_PROTOCOL_RAW: Integer; safecall;
    function Get_nwSOCKET_PROTOCOL_TELNET: Integer; safecall;
    function Get_nwSOCKET_CONNSTATE_DISCONNECTED: Integer; safecall;
    function Get_nwSOCKET_CONNSTATE_LISTENING: Integer; safecall;
    function Get_nwSOCKET_CONNSTATE_CONNECTED: Integer; safecall;
    function Get_nwSNMP_TYPE_UNDEFINED: Integer; safecall;
    function Get_nwSNMP_TYPE_INTEGER: Integer; safecall;
    function Get_nwSNMP_TYPE_INTEGER32: Integer; safecall;
    function Get_nwSNMP_TYPE_BITS: Integer; safecall;
    function Get_nwSNMP_TYPE_OCTETSTRING: Integer; safecall;
    function Get_nwSNMP_TYPE_NULL: Integer; safecall;
    function Get_nwSNMP_TYPE_OBJECTIDENTIFIER: Integer; safecall;
    function Get_nwSNMP_TYPE_SEQUENCE: Integer; safecall;
    function Get_nwSNMP_TYPE_IPADDRESS: Integer; safecall;
    function Get_nwSNMP_TYPE_COUNTER32: Integer; safecall;
    function Get_nwSNMP_TYPE_GAUGE32: Integer; safecall;
    function Get_nwSNMP_TYPE_TIMETICKS: Integer; safecall;
    function Get_nwSNMP_TYPE_OPAQUE: Integer; safecall;
    function Get_nwSNMP_TYPE_COUNTER64: Integer; safecall;
    function Get_nwSNMP_TYPE_UNSIGNED32: Integer; safecall;
    function Get_nwSNMP_TRAP_COLDSTART: Integer; safecall;
    function Get_nwSNMP_TRAP_WARMSTART: Integer; safecall;
    function Get_nwSNMP_TRAP_LINKDOWN: Integer; safecall;
    function Get_nwSNMP_TRAP_LINKUP: Integer; safecall;
    function Get_nwSNMP_TRAP_AUTHFAILURE: Integer; safecall;
    function Get_nwSNMP_TRAP_EGPNEIGHLOSS: Integer; safecall;
    function Get_nwSNMP_TRAP_ENTERSPECIFIC: Integer; safecall;
    function Get_nwSNMP_VERSION_V1: Integer; safecall;
    function Get_nwSNMP_VERSION_V2C: Integer; safecall;
    function Get_nwSNMP_VERSION_V3: Integer; safecall;
    function Get_nwDNS_TYPE_A: Integer; safecall;
    function Get_nwDNS_TYPE_NS: Integer; safecall;
    function Get_nwDNS_TYPE_CNAME: Integer; safecall;
    function Get_nwDNS_TYPE_SOA: Integer; safecall;
    function Get_nwDNS_TYPE_PTR: Integer; safecall;
    function Get_nwDNS_TYPE_MX: Integer; safecall;
    function Get_nwDNS_TYPE_AAAA: Integer; safecall;
    function Get_nwDNS_TYPE_ANY: Integer; safecall;
    function Get_nwDNS_TYPE_UNDEFINED: Integer; safecall;
    function Get_nwDNS_TYPE_SRV: Integer; safecall;
    function Get_nwDNS_TYPE_CERT: Integer; safecall;
    function Get_nwMIB_ACCESS_NOACCESS: Integer; safecall;
    function Get_nwMIB_ACCESS_NOTIFY: Integer; safecall;
    function Get_nwMIB_ACCESS_READONLY: Integer; safecall;
    function Get_nwMIB_ACCESS_WRITEONLY: Integer; safecall;
    function Get_nwMIB_ACCESS_READWRITE: Integer; safecall;
    function Get_nwMIB_ACCESS_READCREATE: Integer; safecall;
    function Get_nwMIB_STATUS_CURRENT: Integer; safecall;
    function Get_nwMIB_STATUS_DEPRECATED: Integer; safecall;
    function Get_nwMIB_STATUS_OBSOLETE: Integer; safecall;
    function Get_nwMIB_STATUS_MANDATORY: Integer; safecall;
    function Get_nwSNMP_AUTH_SHA1: Integer; safecall;
    function Get_nwSNMP_AUTH_MD5: Integer; safecall;
    function Get_nwSNMP_PRIV_DES: Integer; safecall;
    function Get_nwSNMP_PRIV_AES: Integer; safecall;
    function Get_nwVMWARE_CPU_USAGE: Integer; safecall;
    function Get_nwVMWARE_MEMORY_USAGE: Integer; safecall;
    function Get_nwVMWARE_MEMORY_AVAILABLE: Integer; safecall;
    function Get_nwVMWARE_MEMORY_USED: Integer; safecall;
    function Get_nwVMWARE_NETWORK_PACKETSRX: Integer; safecall;
    function Get_nwVMWARE_NETWORK_PACKETSTX: Integer; safecall;
    function Get_nwVMWARE_NETWORK_RATERX: Integer; safecall;
    function Get_nwVMWARE_NETWORK_RATETX: Integer; safecall;
    function Get_nwVMWARE_DISK_USAGE: Integer; safecall;
    function Get_nwVMWARE_DISK_AVAILABLE: Integer; safecall;
    function Get_nwVMWARE_DISK_USED: Integer; safecall;
    function Get_nwVMWARE_MACHINE_STATE: Integer; safecall;
    function Get_nwVMWARE_POWER_STATE: Integer; safecall;
    function Get_nwVMWARE_GUESTTOOLS: Integer; safecall;
    function Get_nwVMWARE_POWERSTATE_INVALID: Integer; safecall;
    function Get_nwVMWARE_POWERSTATE_OFF: Integer; safecall;
    function Get_nwVMWARE_POWERSTATE_ON: Integer; safecall;
    function Get_nwVMWARE_POWERSTATE_SUSPENDED: Integer; safecall;
    function Get_nwVMWARE_MACHINESTATE_INVALID: Integer; safecall;
    function Get_nwVMWARE_MACHINESTATE_NOTRUNNING: Integer; safecall;
    function Get_nwVMWARE_MACHINESTATE_RESETTING: Integer; safecall;
    function Get_nwVMWARE_MACHINESTATE_RUNNING: Integer; safecall;
    function Get_nwVMWARE_MACHINESTATE_SHUTTINGDOWN: Integer; safecall;
    function Get_nwVMWARE_MACHINESTATE_STANDBY: Integer; safecall;
    function Get_nwVMWARE_MACHINESTATE_UNKNOWN: Integer; safecall;
    function Get_nwVMWARE_GUESTTOOLS_UNKNOWN: Integer; safecall;
    function Get_nwVMWARE_GUESTTOOLS_NOTRUNNING: Integer; safecall;
    function Get_nwVMWARE_GUESTTOOLS_RUNNING: Integer; safecall;
    function Get_nmXEN_CPU_USAGE: Integer; safecall;
    function Get_nmXEN_MEMORY_USAGE: Integer; safecall;
    function Get_nmXEN_MEMORY_AVAILABLE: Integer; safecall;
    function Get_nmXEN_MEMORY_USED: Integer; safecall;
    function Get_nmXEN_NETWORK_RATERX: Integer; safecall;
    function Get_nmXEN_NETWORK_RATETX: Integer; safecall;
    function Get_nmXEN_DISK_USAGE: Integer; safecall;
    function Get_nmXEN_DISK_AVAILABLE: Integer; safecall;
    function Get_nmXEN_DISK_USED: Integer; safecall;
    function Get_nmXEN_POWER_STATE: Integer; safecall;
    function Get_nmXEN_GUESTTOOLS: Integer; safecall;
    function Get_nmXEN_POWERSTATE_HALTED: Integer; safecall;
    function Get_nmXEN_POWERSTATE_PAUSED: Integer; safecall;
    function Get_nmXEN_POWERSTATE_RUNNING: Integer; safecall;
    function Get_nmXEN_POWERSTATE_SUSPENDED: Integer; safecall;
    function Get_nmXEN_POWERSTATE_SHUTTINGDOWN: Integer; safecall;
    function Get_nmXEN_POWERSTATE_CRASHED: Integer; safecall;
    function Get_nmXEN_POWERSTATE_UNKNOWN: Integer; safecall;
    function Get_nmXEN_GUESTTOOLS_UNKNOWN: Integer; safecall;
    function Get_nmXEN_GUESTTOOLS_NOTRUNNING: Integer; safecall;
    function Get_nmXEN_GUESTTOOLS_RUNNING: Integer; safecall;
    function Get_nwSOCKET_IPVERSION_IP6IP4: Integer; safecall;
    function Get_nwSOCKET_IPVERSION_IP6ONLY: Integer; safecall;
    function Get_nwSOCKET_IPVERSION_IP4ONLY: Integer; safecall;
    property nwSOCKET_PROTOCOL_RAW: Integer read Get_nwSOCKET_PROTOCOL_RAW;
    property nwSOCKET_PROTOCOL_TELNET: Integer read Get_nwSOCKET_PROTOCOL_TELNET;
    property nwSOCKET_CONNSTATE_DISCONNECTED: Integer read Get_nwSOCKET_CONNSTATE_DISCONNECTED;
    property nwSOCKET_CONNSTATE_LISTENING: Integer read Get_nwSOCKET_CONNSTATE_LISTENING;
    property nwSOCKET_CONNSTATE_CONNECTED: Integer read Get_nwSOCKET_CONNSTATE_CONNECTED;
    property nwSNMP_TYPE_UNDEFINED: Integer read Get_nwSNMP_TYPE_UNDEFINED;
    property nwSNMP_TYPE_INTEGER: Integer read Get_nwSNMP_TYPE_INTEGER;
    property nwSNMP_TYPE_INTEGER32: Integer read Get_nwSNMP_TYPE_INTEGER32;
    property nwSNMP_TYPE_BITS: Integer read Get_nwSNMP_TYPE_BITS;
    property nwSNMP_TYPE_OCTETSTRING: Integer read Get_nwSNMP_TYPE_OCTETSTRING;
    property nwSNMP_TYPE_NULL: Integer read Get_nwSNMP_TYPE_NULL;
    property nwSNMP_TYPE_OBJECTIDENTIFIER: Integer read Get_nwSNMP_TYPE_OBJECTIDENTIFIER;
    property nwSNMP_TYPE_SEQUENCE: Integer read Get_nwSNMP_TYPE_SEQUENCE;
    property nwSNMP_TYPE_IPADDRESS: Integer read Get_nwSNMP_TYPE_IPADDRESS;
    property nwSNMP_TYPE_COUNTER32: Integer read Get_nwSNMP_TYPE_COUNTER32;
    property nwSNMP_TYPE_GAUGE32: Integer read Get_nwSNMP_TYPE_GAUGE32;
    property nwSNMP_TYPE_TIMETICKS: Integer read Get_nwSNMP_TYPE_TIMETICKS;
    property nwSNMP_TYPE_OPAQUE: Integer read Get_nwSNMP_TYPE_OPAQUE;
    property nwSNMP_TYPE_COUNTER64: Integer read Get_nwSNMP_TYPE_COUNTER64;
    property nwSNMP_TYPE_UNSIGNED32: Integer read Get_nwSNMP_TYPE_UNSIGNED32;
    property nwSNMP_TRAP_COLDSTART: Integer read Get_nwSNMP_TRAP_COLDSTART;
    property nwSNMP_TRAP_WARMSTART: Integer read Get_nwSNMP_TRAP_WARMSTART;
    property nwSNMP_TRAP_LINKDOWN: Integer read Get_nwSNMP_TRAP_LINKDOWN;
    property nwSNMP_TRAP_LINKUP: Integer read Get_nwSNMP_TRAP_LINKUP;
    property nwSNMP_TRAP_AUTHFAILURE: Integer read Get_nwSNMP_TRAP_AUTHFAILURE;
    property nwSNMP_TRAP_EGPNEIGHLOSS: Integer read Get_nwSNMP_TRAP_EGPNEIGHLOSS;
    property nwSNMP_TRAP_ENTERSPECIFIC: Integer read Get_nwSNMP_TRAP_ENTERSPECIFIC;
    property nwSNMP_VERSION_V1: Integer read Get_nwSNMP_VERSION_V1;
    property nwSNMP_VERSION_V2C: Integer read Get_nwSNMP_VERSION_V2C;
    property nwSNMP_VERSION_V3: Integer read Get_nwSNMP_VERSION_V3;
    property nwDNS_TYPE_A: Integer read Get_nwDNS_TYPE_A;
    property nwDNS_TYPE_NS: Integer read Get_nwDNS_TYPE_NS;
    property nwDNS_TYPE_CNAME: Integer read Get_nwDNS_TYPE_CNAME;
    property nwDNS_TYPE_SOA: Integer read Get_nwDNS_TYPE_SOA;
    property nwDNS_TYPE_PTR: Integer read Get_nwDNS_TYPE_PTR;
    property nwDNS_TYPE_MX: Integer read Get_nwDNS_TYPE_MX;
    property nwDNS_TYPE_AAAA: Integer read Get_nwDNS_TYPE_AAAA;
    property nwDNS_TYPE_ANY: Integer read Get_nwDNS_TYPE_ANY;
    property nwDNS_TYPE_UNDEFINED: Integer read Get_nwDNS_TYPE_UNDEFINED;
    property nwDNS_TYPE_SRV: Integer read Get_nwDNS_TYPE_SRV;
    property nwDNS_TYPE_CERT: Integer read Get_nwDNS_TYPE_CERT;
    property nwMIB_ACCESS_NOACCESS: Integer read Get_nwMIB_ACCESS_NOACCESS;
    property nwMIB_ACCESS_NOTIFY: Integer read Get_nwMIB_ACCESS_NOTIFY;
    property nwMIB_ACCESS_READONLY: Integer read Get_nwMIB_ACCESS_READONLY;
    property nwMIB_ACCESS_WRITEONLY: Integer read Get_nwMIB_ACCESS_WRITEONLY;
    property nwMIB_ACCESS_READWRITE: Integer read Get_nwMIB_ACCESS_READWRITE;
    property nwMIB_ACCESS_READCREATE: Integer read Get_nwMIB_ACCESS_READCREATE;
    property nwMIB_STATUS_CURRENT: Integer read Get_nwMIB_STATUS_CURRENT;
    property nwMIB_STATUS_DEPRECATED: Integer read Get_nwMIB_STATUS_DEPRECATED;
    property nwMIB_STATUS_OBSOLETE: Integer read Get_nwMIB_STATUS_OBSOLETE;
    property nwMIB_STATUS_MANDATORY: Integer read Get_nwMIB_STATUS_MANDATORY;
    property nwSNMP_AUTH_SHA1: Integer read Get_nwSNMP_AUTH_SHA1;
    property nwSNMP_AUTH_MD5: Integer read Get_nwSNMP_AUTH_MD5;
    property nwSNMP_PRIV_DES: Integer read Get_nwSNMP_PRIV_DES;
    property nwSNMP_PRIV_AES: Integer read Get_nwSNMP_PRIV_AES;
    property nwVMWARE_CPU_USAGE: Integer read Get_nwVMWARE_CPU_USAGE;
    property nwVMWARE_MEMORY_USAGE: Integer read Get_nwVMWARE_MEMORY_USAGE;
    property nwVMWARE_MEMORY_AVAILABLE: Integer read Get_nwVMWARE_MEMORY_AVAILABLE;
    property nwVMWARE_MEMORY_USED: Integer read Get_nwVMWARE_MEMORY_USED;
    property nwVMWARE_NETWORK_PACKETSRX: Integer read Get_nwVMWARE_NETWORK_PACKETSRX;
    property nwVMWARE_NETWORK_PACKETSTX: Integer read Get_nwVMWARE_NETWORK_PACKETSTX;
    property nwVMWARE_NETWORK_RATERX: Integer read Get_nwVMWARE_NETWORK_RATERX;
    property nwVMWARE_NETWORK_RATETX: Integer read Get_nwVMWARE_NETWORK_RATETX;
    property nwVMWARE_DISK_USAGE: Integer read Get_nwVMWARE_DISK_USAGE;
    property nwVMWARE_DISK_AVAILABLE: Integer read Get_nwVMWARE_DISK_AVAILABLE;
    property nwVMWARE_DISK_USED: Integer read Get_nwVMWARE_DISK_USED;
    property nwVMWARE_MACHINE_STATE: Integer read Get_nwVMWARE_MACHINE_STATE;
    property nwVMWARE_POWER_STATE: Integer read Get_nwVMWARE_POWER_STATE;
    property nwVMWARE_GUESTTOOLS: Integer read Get_nwVMWARE_GUESTTOOLS;
    property nwVMWARE_POWERSTATE_INVALID: Integer read Get_nwVMWARE_POWERSTATE_INVALID;
    property nwVMWARE_POWERSTATE_OFF: Integer read Get_nwVMWARE_POWERSTATE_OFF;
    property nwVMWARE_POWERSTATE_ON: Integer read Get_nwVMWARE_POWERSTATE_ON;
    property nwVMWARE_POWERSTATE_SUSPENDED: Integer read Get_nwVMWARE_POWERSTATE_SUSPENDED;
    property nwVMWARE_MACHINESTATE_INVALID: Integer read Get_nwVMWARE_MACHINESTATE_INVALID;
    property nwVMWARE_MACHINESTATE_NOTRUNNING: Integer read Get_nwVMWARE_MACHINESTATE_NOTRUNNING;
    property nwVMWARE_MACHINESTATE_RESETTING: Integer read Get_nwVMWARE_MACHINESTATE_RESETTING;
    property nwVMWARE_MACHINESTATE_RUNNING: Integer read Get_nwVMWARE_MACHINESTATE_RUNNING;
    property nwVMWARE_MACHINESTATE_SHUTTINGDOWN: Integer read Get_nwVMWARE_MACHINESTATE_SHUTTINGDOWN;
    property nwVMWARE_MACHINESTATE_STANDBY: Integer read Get_nwVMWARE_MACHINESTATE_STANDBY;
    property nwVMWARE_MACHINESTATE_UNKNOWN: Integer read Get_nwVMWARE_MACHINESTATE_UNKNOWN;
    property nwVMWARE_GUESTTOOLS_UNKNOWN: Integer read Get_nwVMWARE_GUESTTOOLS_UNKNOWN;
    property nwVMWARE_GUESTTOOLS_NOTRUNNING: Integer read Get_nwVMWARE_GUESTTOOLS_NOTRUNNING;
    property nwVMWARE_GUESTTOOLS_RUNNING: Integer read Get_nwVMWARE_GUESTTOOLS_RUNNING;
    property nmXEN_CPU_USAGE: Integer read Get_nmXEN_CPU_USAGE;
    property nmXEN_MEMORY_USAGE: Integer read Get_nmXEN_MEMORY_USAGE;
    property nmXEN_MEMORY_AVAILABLE: Integer read Get_nmXEN_MEMORY_AVAILABLE;
    property nmXEN_MEMORY_USED: Integer read Get_nmXEN_MEMORY_USED;
    property nmXEN_NETWORK_RATERX: Integer read Get_nmXEN_NETWORK_RATERX;
    property nmXEN_NETWORK_RATETX: Integer read Get_nmXEN_NETWORK_RATETX;
    property nmXEN_DISK_USAGE: Integer read Get_nmXEN_DISK_USAGE;
    property nmXEN_DISK_AVAILABLE: Integer read Get_nmXEN_DISK_AVAILABLE;
    property nmXEN_DISK_USED: Integer read Get_nmXEN_DISK_USED;
    property nmXEN_POWER_STATE: Integer read Get_nmXEN_POWER_STATE;
    property nmXEN_GUESTTOOLS: Integer read Get_nmXEN_GUESTTOOLS;
    property nmXEN_POWERSTATE_HALTED: Integer read Get_nmXEN_POWERSTATE_HALTED;
    property nmXEN_POWERSTATE_PAUSED: Integer read Get_nmXEN_POWERSTATE_PAUSED;
    property nmXEN_POWERSTATE_RUNNING: Integer read Get_nmXEN_POWERSTATE_RUNNING;
    property nmXEN_POWERSTATE_SUSPENDED: Integer read Get_nmXEN_POWERSTATE_SUSPENDED;
    property nmXEN_POWERSTATE_SHUTTINGDOWN: Integer read Get_nmXEN_POWERSTATE_SHUTTINGDOWN;
    property nmXEN_POWERSTATE_CRASHED: Integer read Get_nmXEN_POWERSTATE_CRASHED;
    property nmXEN_POWERSTATE_UNKNOWN: Integer read Get_nmXEN_POWERSTATE_UNKNOWN;
    property nmXEN_GUESTTOOLS_UNKNOWN: Integer read Get_nmXEN_GUESTTOOLS_UNKNOWN;
    property nmXEN_GUESTTOOLS_NOTRUNNING: Integer read Get_nmXEN_GUESTTOOLS_NOTRUNNING;
    property nmXEN_GUESTTOOLS_RUNNING: Integer read Get_nmXEN_GUESTTOOLS_RUNNING;
    property nwSOCKET_IPVERSION_IP6IP4: Integer read Get_nwSOCKET_IPVERSION_IP6IP4;
    property nwSOCKET_IPVERSION_IP6ONLY: Integer read Get_nwSOCKET_IPVERSION_IP6ONLY;
    property nwSOCKET_IPVERSION_IP4ONLY: Integer read Get_nwSOCKET_IPVERSION_IP4ONLY;
  end;

// *********************************************************************//
// DispIntf:  INwConstantsDisp
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {37B4E86F-AAE3-48AC-922B-DF90945125B9}
// *********************************************************************//
  INwConstantsDisp = dispinterface
    ['{37B4E86F-AAE3-48AC-922B-DF90945125B9}']
    property nwSOCKET_PROTOCOL_RAW: Integer readonly dispid 101;
    property nwSOCKET_PROTOCOL_TELNET: Integer readonly dispid 102;
    property nwSOCKET_CONNSTATE_DISCONNECTED: Integer readonly dispid 103;
    property nwSOCKET_CONNSTATE_LISTENING: Integer readonly dispid 104;
    property nwSOCKET_CONNSTATE_CONNECTED: Integer readonly dispid 105;
    property nwSNMP_TYPE_UNDEFINED: Integer readonly dispid 106;
    property nwSNMP_TYPE_INTEGER: Integer readonly dispid 107;
    property nwSNMP_TYPE_INTEGER32: Integer readonly dispid 108;
    property nwSNMP_TYPE_BITS: Integer readonly dispid 109;
    property nwSNMP_TYPE_OCTETSTRING: Integer readonly dispid 110;
    property nwSNMP_TYPE_NULL: Integer readonly dispid 111;
    property nwSNMP_TYPE_OBJECTIDENTIFIER: Integer readonly dispid 112;
    property nwSNMP_TYPE_SEQUENCE: Integer readonly dispid 113;
    property nwSNMP_TYPE_IPADDRESS: Integer readonly dispid 115;
    property nwSNMP_TYPE_COUNTER32: Integer readonly dispid 116;
    property nwSNMP_TYPE_GAUGE32: Integer readonly dispid 117;
    property nwSNMP_TYPE_TIMETICKS: Integer readonly dispid 118;
    property nwSNMP_TYPE_OPAQUE: Integer readonly dispid 119;
    property nwSNMP_TYPE_COUNTER64: Integer readonly dispid 120;
    property nwSNMP_TYPE_UNSIGNED32: Integer readonly dispid 121;
    property nwSNMP_TRAP_COLDSTART: Integer readonly dispid 122;
    property nwSNMP_TRAP_WARMSTART: Integer readonly dispid 123;
    property nwSNMP_TRAP_LINKDOWN: Integer readonly dispid 124;
    property nwSNMP_TRAP_LINKUP: Integer readonly dispid 125;
    property nwSNMP_TRAP_AUTHFAILURE: Integer readonly dispid 126;
    property nwSNMP_TRAP_EGPNEIGHLOSS: Integer readonly dispid 127;
    property nwSNMP_TRAP_ENTERSPECIFIC: Integer readonly dispid 128;
    property nwSNMP_VERSION_V1: Integer readonly dispid 129;
    property nwSNMP_VERSION_V2C: Integer readonly dispid 130;
    property nwSNMP_VERSION_V3: Integer readonly dispid 161;
    property nwDNS_TYPE_A: Integer readonly dispid 131;
    property nwDNS_TYPE_NS: Integer readonly dispid 132;
    property nwDNS_TYPE_CNAME: Integer readonly dispid 133;
    property nwDNS_TYPE_SOA: Integer readonly dispid 134;
    property nwDNS_TYPE_PTR: Integer readonly dispid 135;
    property nwDNS_TYPE_MX: Integer readonly dispid 136;
    property nwDNS_TYPE_AAAA: Integer readonly dispid 137;
    property nwDNS_TYPE_ANY: Integer readonly dispid 138;
    property nwDNS_TYPE_UNDEFINED: Integer readonly dispid 139;
    property nwDNS_TYPE_SRV: Integer readonly dispid 140;
    property nwDNS_TYPE_CERT: Integer readonly dispid 141;
    property nwMIB_ACCESS_NOACCESS: Integer readonly dispid 150;
    property nwMIB_ACCESS_NOTIFY: Integer readonly dispid 151;
    property nwMIB_ACCESS_READONLY: Integer readonly dispid 152;
    property nwMIB_ACCESS_WRITEONLY: Integer readonly dispid 153;
    property nwMIB_ACCESS_READWRITE: Integer readonly dispid 154;
    property nwMIB_ACCESS_READCREATE: Integer readonly dispid 155;
    property nwMIB_STATUS_CURRENT: Integer readonly dispid 156;
    property nwMIB_STATUS_DEPRECATED: Integer readonly dispid 157;
    property nwMIB_STATUS_OBSOLETE: Integer readonly dispid 158;
    property nwMIB_STATUS_MANDATORY: Integer readonly dispid 160;
    property nwSNMP_AUTH_SHA1: Integer readonly dispid 162;
    property nwSNMP_AUTH_MD5: Integer readonly dispid 163;
    property nwSNMP_PRIV_DES: Integer readonly dispid 164;
    property nwSNMP_PRIV_AES: Integer readonly dispid 165;
    property nwVMWARE_CPU_USAGE: Integer readonly dispid 180;
    property nwVMWARE_MEMORY_USAGE: Integer readonly dispid 181;
    property nwVMWARE_MEMORY_AVAILABLE: Integer readonly dispid 182;
    property nwVMWARE_MEMORY_USED: Integer readonly dispid 183;
    property nwVMWARE_NETWORK_PACKETSRX: Integer readonly dispid 184;
    property nwVMWARE_NETWORK_PACKETSTX: Integer readonly dispid 185;
    property nwVMWARE_NETWORK_RATERX: Integer readonly dispid 186;
    property nwVMWARE_NETWORK_RATETX: Integer readonly dispid 187;
    property nwVMWARE_DISK_USAGE: Integer readonly dispid 188;
    property nwVMWARE_DISK_AVAILABLE: Integer readonly dispid 189;
    property nwVMWARE_DISK_USED: Integer readonly dispid 190;
    property nwVMWARE_MACHINE_STATE: Integer readonly dispid 191;
    property nwVMWARE_POWER_STATE: Integer readonly dispid 192;
    property nwVMWARE_GUESTTOOLS: Integer readonly dispid 193;
    property nwVMWARE_POWERSTATE_INVALID: Integer readonly dispid 194;
    property nwVMWARE_POWERSTATE_OFF: Integer readonly dispid 195;
    property nwVMWARE_POWERSTATE_ON: Integer readonly dispid 196;
    property nwVMWARE_POWERSTATE_SUSPENDED: Integer readonly dispid 197;
    property nwVMWARE_MACHINESTATE_INVALID: Integer readonly dispid 198;
    property nwVMWARE_MACHINESTATE_NOTRUNNING: Integer readonly dispid 199;
    property nwVMWARE_MACHINESTATE_RESETTING: Integer readonly dispid 200;
    property nwVMWARE_MACHINESTATE_RUNNING: Integer readonly dispid 201;
    property nwVMWARE_MACHINESTATE_SHUTTINGDOWN: Integer readonly dispid 202;
    property nwVMWARE_MACHINESTATE_STANDBY: Integer readonly dispid 203;
    property nwVMWARE_MACHINESTATE_UNKNOWN: Integer readonly dispid 204;
    property nwVMWARE_GUESTTOOLS_UNKNOWN: Integer readonly dispid 205;
    property nwVMWARE_GUESTTOOLS_NOTRUNNING: Integer readonly dispid 206;
    property nwVMWARE_GUESTTOOLS_RUNNING: Integer readonly dispid 207;
    property nmXEN_CPU_USAGE: Integer readonly dispid 250;
    property nmXEN_MEMORY_USAGE: Integer readonly dispid 251;
    property nmXEN_MEMORY_AVAILABLE: Integer readonly dispid 252;
    property nmXEN_MEMORY_USED: Integer readonly dispid 253;
    property nmXEN_NETWORK_RATERX: Integer readonly dispid 254;
    property nmXEN_NETWORK_RATETX: Integer readonly dispid 255;
    property nmXEN_DISK_USAGE: Integer readonly dispid 256;
    property nmXEN_DISK_AVAILABLE: Integer readonly dispid 257;
    property nmXEN_DISK_USED: Integer readonly dispid 258;
    property nmXEN_POWER_STATE: Integer readonly dispid 259;
    property nmXEN_GUESTTOOLS: Integer readonly dispid 260;
    property nmXEN_POWERSTATE_HALTED: Integer readonly dispid 261;
    property nmXEN_POWERSTATE_PAUSED: Integer readonly dispid 262;
    property nmXEN_POWERSTATE_RUNNING: Integer readonly dispid 263;
    property nmXEN_POWERSTATE_SUSPENDED: Integer readonly dispid 264;
    property nmXEN_POWERSTATE_SHUTTINGDOWN: Integer readonly dispid 265;
    property nmXEN_POWERSTATE_CRASHED: Integer readonly dispid 266;
    property nmXEN_POWERSTATE_UNKNOWN: Integer readonly dispid 267;
    property nmXEN_GUESTTOOLS_UNKNOWN: Integer readonly dispid 268;
    property nmXEN_GUESTTOOLS_NOTRUNNING: Integer readonly dispid 269;
    property nmXEN_GUESTTOOLS_RUNNING: Integer readonly dispid 270;
    property nwSOCKET_IPVERSION_IP6IP4: Integer readonly dispid 271;
    property nwSOCKET_IPVERSION_IP6ONLY: Integer readonly dispid 272;
    property nwSOCKET_IPVERSION_IP4ONLY: Integer readonly dispid 273;
  end;

// *********************************************************************//
// Interface: ISnmpManager
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {1542A06C-4DBA-407A-B54D-991D13D481AD}
// *********************************************************************//
  ISnmpManager = interface(IDispatch)
    ['{1542A06C-4DBA-407A-B54D-991D13D481AD}']
    function Get_Version: WideString; safecall;
    function Get_Build: WideString; safecall;
    function Get_Module: WideString; safecall;
    function Get_LicenseStatus: WideString; safecall;
    procedure Set_Reserved(Param1: Integer); safecall;
    function Get_LastError: Integer; safecall;
    function Get_LogFile: WideString; safecall;
    procedure Set_LogFile(const pVal: WideString); safecall;
    function Get_LicenseKey: WideString; safecall;
    procedure Clear; safecall;
    function GetErrorDescription(Error: Integer): WideString; safecall;
    procedure Activate(const bstrRegKey: WideString; bPersistent: WordBool); safecall;
    procedure Sleep(newVal: Integer); safecall;
    function Get_ProtocolVersion: Integer; safecall;
    procedure Set_ProtocolVersion(pVal: Integer); safecall;
    function Get_Timeout: Integer; safecall;
    procedure Set_Timeout(pVal: Integer); safecall;
    function Get_AuthProtocol: Integer; safecall;
    procedure Set_AuthProtocol(pVal: Integer); safecall;
    function Get_PrivProtocol: Integer; safecall;
    procedure Set_PrivProtocol(pVal: Integer); safecall;
    function Get_AuthUsername: WideString; safecall;
    procedure Set_AuthUsername(const pVal: WideString); safecall;
    function Get_AuthPassword: WideString; safecall;
    procedure Set_AuthPassword(const pVal: WideString); safecall;
    function Get_PrivPassword: WideString; safecall;
    procedure Set_PrivPassword(const pVal: WideString); safecall;
    function Get_ContextName: WideString; safecall;
    procedure Set_ContextName(const pVal: WideString); safecall;
    procedure Initialize; safecall;
    procedure Shutdown; safecall;
    procedure Open(const Agent: WideString; const Community: WideString; Port: Integer); safecall;
    procedure Close; safecall;
    function Get(const OID: WideString): OleVariant; safecall;
    function GetNext: OleVariant; safecall;
    procedure Set_(var pVal: OleVariant); safecall;
    procedure LoadMibFile(const bstrMibFile: WideString); safecall;
    property Version: WideString read Get_Version;
    property Build: WideString read Get_Build;
    property Module: WideString read Get_Module;
    property LicenseStatus: WideString read Get_LicenseStatus;
    property Reserved: Integer write Set_Reserved;
    property LastError: Integer read Get_LastError;
    property LogFile: WideString read Get_LogFile write Set_LogFile;
    property LicenseKey: WideString read Get_LicenseKey;
    property ProtocolVersion: Integer read Get_ProtocolVersion write Set_ProtocolVersion;
    property Timeout: Integer read Get_Timeout write Set_Timeout;
    property AuthProtocol: Integer read Get_AuthProtocol write Set_AuthProtocol;
    property PrivProtocol: Integer read Get_PrivProtocol write Set_PrivProtocol;
    property AuthUsername: WideString read Get_AuthUsername write Set_AuthUsername;
    property AuthPassword: WideString read Get_AuthPassword write Set_AuthPassword;
    property PrivPassword: WideString read Get_PrivPassword write Set_PrivPassword;
    property ContextName: WideString read Get_ContextName write Set_ContextName;
  end;

// *********************************************************************//
// DispIntf:  ISnmpManagerDisp
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {1542A06C-4DBA-407A-B54D-991D13D481AD}
// *********************************************************************//
  ISnmpManagerDisp = dispinterface
    ['{1542A06C-4DBA-407A-B54D-991D13D481AD}']
    property Version: WideString readonly dispid 1;
    property Build: WideString readonly dispid 2;
    property Module: WideString readonly dispid 3;
    property LicenseStatus: WideString readonly dispid 4;
    property Reserved: Integer writeonly dispid 5;
    property LastError: Integer readonly dispid 6;
    property LogFile: WideString dispid 7;
    property LicenseKey: WideString readonly dispid 8;
    procedure Clear; dispid 20;
    function GetErrorDescription(Error: Integer): WideString; dispid 21;
    procedure Activate(const bstrRegKey: WideString; bPersistent: WordBool); dispid 22;
    procedure Sleep(newVal: Integer); dispid 23;
    property ProtocolVersion: Integer dispid 101;
    property Timeout: Integer dispid 102;
    property AuthProtocol: Integer dispid 103;
    property PrivProtocol: Integer dispid 104;
    property AuthUsername: WideString dispid 105;
    property AuthPassword: WideString dispid 106;
    property PrivPassword: WideString dispid 107;
    property ContextName: WideString dispid 108;
    procedure Initialize; dispid 201;
    procedure Shutdown; dispid 202;
    procedure Open(const Agent: WideString; const Community: WideString; Port: Integer); dispid 210;
    procedure Close; dispid 211;
    function Get(const OID: WideString): OleVariant; dispid 220;
    function GetNext: OleVariant; dispid 221;
    procedure Set_(var pVal: OleVariant); dispid 222;
    procedure LoadMibFile(const bstrMibFile: WideString); dispid 223;
  end;

// *********************************************************************//
// Interface: ISnmpTrap
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {66673904-CCFB-45C5-8AFA-5C003BFE48FA}
// *********************************************************************//
  ISnmpTrap = interface(IDispatch)
    ['{66673904-CCFB-45C5-8AFA-5C003BFE48FA}']
    function Get_LastError: Integer; safecall;
    procedure Clear; safecall;
    function Get_Host: WideString; safecall;
    procedure Set_Host(const pVal: WideString); safecall;
    function Get_Community: WideString; safecall;
    procedure Set_Community(const pVal: WideString); safecall;
    function Get_GenericTrap: Integer; safecall;
    procedure Set_GenericTrap(pVal: Integer); safecall;
    function Get_SpecificTrap: Integer; safecall;
    procedure Set_SpecificTrap(pVal: Integer); safecall;
    function Get_Enterprise: WideString; safecall;
    procedure Set_Enterprise(const pVal: WideString); safecall;
    function Get_Uptime: Integer; safecall;
    procedure Set_Uptime(pVal: Integer); safecall;
    function Get_Port: Integer; safecall;
    procedure Set_Port(pVal: Integer); safecall;
    function GetFirstObject: OleVariant; safecall;
    function GetNextObject: OleVariant; safecall;
    procedure AddObject(var pVal: OleVariant); safecall;
    property LastError: Integer read Get_LastError;
    property Host: WideString read Get_Host write Set_Host;
    property Community: WideString read Get_Community write Set_Community;
    property GenericTrap: Integer read Get_GenericTrap write Set_GenericTrap;
    property SpecificTrap: Integer read Get_SpecificTrap write Set_SpecificTrap;
    property Enterprise: WideString read Get_Enterprise write Set_Enterprise;
    property Uptime: Integer read Get_Uptime write Set_Uptime;
    property Port: Integer read Get_Port write Set_Port;
  end;

// *********************************************************************//
// DispIntf:  ISnmpTrapDisp
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {66673904-CCFB-45C5-8AFA-5C003BFE48FA}
// *********************************************************************//
  ISnmpTrapDisp = dispinterface
    ['{66673904-CCFB-45C5-8AFA-5C003BFE48FA}']
    property LastError: Integer readonly dispid 1;
    procedure Clear; dispid 20;
    property Host: WideString dispid 101;
    property Community: WideString dispid 102;
    property GenericTrap: Integer dispid 103;
    property SpecificTrap: Integer dispid 104;
    property Enterprise: WideString dispid 105;
    property Uptime: Integer dispid 106;
    property Port: Integer dispid 107;
    function GetFirstObject: OleVariant; dispid 201;
    function GetNextObject: OleVariant; dispid 202;
    procedure AddObject(var pVal: OleVariant); dispid 203;
  end;

// *********************************************************************//
// Interface: ISnmpTrapManager
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {BCB9AFE8-D460-4BA6-AD97-A0ACD4A76E4F}
// *********************************************************************//
  ISnmpTrapManager = interface(IDispatch)
    ['{BCB9AFE8-D460-4BA6-AD97-A0ACD4A76E4F}']
    function Get_Version: WideString; safecall;
    function Get_Build: WideString; safecall;
    function Get_Module: WideString; safecall;
    function Get_LicenseStatus: WideString; safecall;
    procedure Set_Reserved(Param1: Integer); safecall;
    function Get_LastError: Integer; safecall;
    function Get_LogFile: WideString; safecall;
    procedure Set_LogFile(const pVal: WideString); safecall;
    function Get_LicenseKey: WideString; safecall;
    procedure Clear; safecall;
    function GetErrorDescription(Error: Integer): WideString; safecall;
    procedure Activate(const bstrRegKey: WideString; bPersistent: WordBool); safecall;
    procedure Sleep(newVal: Integer); safecall;
    function Get_ProtocolVersion: Integer; safecall;
    procedure Set_ProtocolVersion(pVal: Integer); safecall;
    function Get_AuthProtocol: Integer; safecall;
    procedure Set_AuthProtocol(pVal: Integer); safecall;
    function Get_PrivProtocol: Integer; safecall;
    procedure Set_PrivProtocol(pVal: Integer); safecall;
    function Get_AuthUsername: WideString; safecall;
    procedure Set_AuthUsername(const pVal: WideString); safecall;
    function Get_AuthPassword: WideString; safecall;
    procedure Set_AuthPassword(const pVal: WideString); safecall;
    function Get_PrivPassword: WideString; safecall;
    procedure Set_PrivPassword(const pVal: WideString); safecall;
    function Get_ContextName: WideString; safecall;
    procedure Set_ContextName(const pVal: WideString); safecall;
    function Get_EngineId: WideString; safecall;
    procedure Set_EngineId(const pVal: WideString); safecall;
    procedure Initialize; safecall;
    procedure Shutdown; safecall;
    procedure StartListening(const Community: WideString; Port: Integer); safecall;
    procedure StopListening; safecall;
    function GetFirstTrap: OleVariant; safecall;
    function GetNextTrap: OleVariant; safecall;
    procedure Send(var pVal: OleVariant); safecall;
    procedure LoadMibFile(const bstrMibFile: WideString); safecall;
    property Version: WideString read Get_Version;
    property Build: WideString read Get_Build;
    property Module: WideString read Get_Module;
    property LicenseStatus: WideString read Get_LicenseStatus;
    property Reserved: Integer write Set_Reserved;
    property LastError: Integer read Get_LastError;
    property LogFile: WideString read Get_LogFile write Set_LogFile;
    property LicenseKey: WideString read Get_LicenseKey;
    property ProtocolVersion: Integer read Get_ProtocolVersion write Set_ProtocolVersion;
    property AuthProtocol: Integer read Get_AuthProtocol write Set_AuthProtocol;
    property PrivProtocol: Integer read Get_PrivProtocol write Set_PrivProtocol;
    property AuthUsername: WideString read Get_AuthUsername write Set_AuthUsername;
    property AuthPassword: WideString read Get_AuthPassword write Set_AuthPassword;
    property PrivPassword: WideString read Get_PrivPassword write Set_PrivPassword;
    property ContextName: WideString read Get_ContextName write Set_ContextName;
    property EngineId: WideString read Get_EngineId write Set_EngineId;
  end;

// *********************************************************************//
// DispIntf:  ISnmpTrapManagerDisp
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {BCB9AFE8-D460-4BA6-AD97-A0ACD4A76E4F}
// *********************************************************************//
  ISnmpTrapManagerDisp = dispinterface
    ['{BCB9AFE8-D460-4BA6-AD97-A0ACD4A76E4F}']
    property Version: WideString readonly dispid 1;
    property Build: WideString readonly dispid 2;
    property Module: WideString readonly dispid 3;
    property LicenseStatus: WideString readonly dispid 4;
    property Reserved: Integer writeonly dispid 5;
    property LastError: Integer readonly dispid 6;
    property LogFile: WideString dispid 7;
    property LicenseKey: WideString readonly dispid 8;
    procedure Clear; dispid 20;
    function GetErrorDescription(Error: Integer): WideString; dispid 21;
    procedure Activate(const bstrRegKey: WideString; bPersistent: WordBool); dispid 22;
    procedure Sleep(newVal: Integer); dispid 23;
    property ProtocolVersion: Integer dispid 101;
    property AuthProtocol: Integer dispid 103;
    property PrivProtocol: Integer dispid 104;
    property AuthUsername: WideString dispid 105;
    property AuthPassword: WideString dispid 106;
    property PrivPassword: WideString dispid 107;
    property ContextName: WideString dispid 108;
    property EngineId: WideString dispid 109;
    procedure Initialize; dispid 201;
    procedure Shutdown; dispid 202;
    procedure StartListening(const Community: WideString; Port: Integer); dispid 210;
    procedure StopListening; dispid 211;
    function GetFirstTrap: OleVariant; dispid 220;
    function GetNextTrap: OleVariant; dispid 221;
    procedure Send(var pVal: OleVariant); dispid 230;
    procedure LoadMibFile(const bstrMibFile: WideString); dispid 240;
  end;

// *********************************************************************//
// Interface: IFtpServer
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {B629A000-C7D2-4CFB-94D7-9797545EA6D1}
// *********************************************************************//
  IFtpServer = interface(IDispatch)
    ['{B629A000-C7D2-4CFB-94D7-9797545EA6D1}']
    function Get_Version: WideString; safecall;
    function Get_Build: WideString; safecall;
    function Get_Module: WideString; safecall;
    function Get_LicenseStatus: WideString; safecall;
    procedure Set_Reserved(Param1: Integer); safecall;
    function Get_LastError: Integer; safecall;
    function Get_LogFile: WideString; safecall;
    procedure Set_LogFile(const pVal: WideString); safecall;
    function Get_LicenseKey: WideString; safecall;
    procedure Clear; safecall;
    function GetErrorDescription(newVal: Integer): WideString; safecall;
    procedure Activate(const bstrRegKey: WideString; bPersistent: WordBool); safecall;
    procedure Sleep(lMilliSeconds: Integer); safecall;
    function Get_HostPort: Integer; safecall;
    procedure Set_HostPort(pVal: Integer); safecall;
    function Get_BinaryTransfer: WordBool; safecall;
    procedure Set_BinaryTransfer(pVal: WordBool); safecall;
    function Get_PassiveMode: WordBool; safecall;
    procedure Set_PassiveMode(pVal: WordBool); safecall;
    function Get_LastResponse: WideString; safecall;
    procedure Connect(const bstrHost: WideString; const bstrAccount: WideString; 
                      const bstrPassword: WideString); safecall;
    procedure Disconnect; safecall;
    function FindFirstFile: OleVariant; safecall;
    function FindNextFile: OleVariant; safecall;
    function GetCurrentDir: WideString; safecall;
    procedure ChangeDir(const bstrDir: WideString); safecall;
    procedure CreateDir(const bstrDir: WideString); safecall;
    procedure RenameDir(const bstrOld: WideString; const bstrNew: WideString); safecall;
    procedure DeleteDir(const bstrDir: WideString); safecall;
    procedure GetFile(const bstrRemote: WideString; const bstrLocal: WideString); safecall;
    procedure PutFile(const bstrLocal: WideString; const bstrRemote: WideString); safecall;
    function FindFile(const bstrSearch: WideString): OleVariant; safecall;
    procedure RenameFile(const bstrOld: WideString; const bstrNew: WideString); safecall;
    procedure DeleteFile(const bstrFile: WideString); safecall;
    property Version: WideString read Get_Version;
    property Build: WideString read Get_Build;
    property Module: WideString read Get_Module;
    property LicenseStatus: WideString read Get_LicenseStatus;
    property Reserved: Integer write Set_Reserved;
    property LastError: Integer read Get_LastError;
    property LogFile: WideString read Get_LogFile write Set_LogFile;
    property LicenseKey: WideString read Get_LicenseKey;
    property HostPort: Integer read Get_HostPort write Set_HostPort;
    property BinaryTransfer: WordBool read Get_BinaryTransfer write Set_BinaryTransfer;
    property PassiveMode: WordBool read Get_PassiveMode write Set_PassiveMode;
    property LastResponse: WideString read Get_LastResponse;
  end;

// *********************************************************************//
// DispIntf:  IFtpServerDisp
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {B629A000-C7D2-4CFB-94D7-9797545EA6D1}
// *********************************************************************//
  IFtpServerDisp = dispinterface
    ['{B629A000-C7D2-4CFB-94D7-9797545EA6D1}']
    property Version: WideString readonly dispid 1;
    property Build: WideString readonly dispid 2;
    property Module: WideString readonly dispid 3;
    property LicenseStatus: WideString readonly dispid 4;
    property Reserved: Integer writeonly dispid 5;
    property LastError: Integer readonly dispid 6;
    property LogFile: WideString dispid 7;
    property LicenseKey: WideString readonly dispid 8;
    procedure Clear; dispid 20;
    function GetErrorDescription(newVal: Integer): WideString; dispid 21;
    procedure Activate(const bstrRegKey: WideString; bPersistent: WordBool); dispid 22;
    procedure Sleep(lMilliSeconds: Integer); dispid 23;
    property HostPort: Integer dispid 101;
    property BinaryTransfer: WordBool dispid 102;
    property PassiveMode: WordBool dispid 103;
    property LastResponse: WideString readonly dispid 110;
    procedure Connect(const bstrHost: WideString; const bstrAccount: WideString; 
                      const bstrPassword: WideString); dispid 201;
    procedure Disconnect; dispid 202;
    function FindFirstFile: OleVariant; dispid 205;
    function FindNextFile: OleVariant; dispid 206;
    function GetCurrentDir: WideString; dispid 210;
    procedure ChangeDir(const bstrDir: WideString); dispid 211;
    procedure CreateDir(const bstrDir: WideString); dispid 212;
    procedure RenameDir(const bstrOld: WideString; const bstrNew: WideString); dispid 213;
    procedure DeleteDir(const bstrDir: WideString); dispid 214;
    procedure GetFile(const bstrRemote: WideString; const bstrLocal: WideString); dispid 220;
    procedure PutFile(const bstrLocal: WideString; const bstrRemote: WideString); dispid 221;
    function FindFile(const bstrSearch: WideString): OleVariant; dispid 222;
    procedure RenameFile(const bstrOld: WideString; const bstrNew: WideString); dispid 223;
    procedure DeleteFile(const bstrFile: WideString); dispid 224;
  end;

// *********************************************************************//
// Interface: IFtpFile
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {0B545BC4-BFB2-4426-8EDF-2F482EA5C511}
// *********************************************************************//
  IFtpFile = interface(IDispatch)
    ['{0B545BC4-BFB2-4426-8EDF-2F482EA5C511}']
    procedure Clear; safecall;
    function Get_Size: Integer; safecall;
    procedure Set_Size(pVal: Integer); safecall;
    function Get_Name: WideString; safecall;
    procedure Set_Name(const pVal: WideString); safecall;
    function Get_DateSeconds: Integer; safecall;
    procedure Set_DateSeconds(pVal: Integer); safecall;
    function Get_Date: WideString; safecall;
    procedure Set_Date(const pVal: WideString); safecall;
    function Get_IsDirectory: WordBool; safecall;
    procedure Set_IsDirectory(pVal: WordBool); safecall;
    property Size: Integer read Get_Size write Set_Size;
    property Name: WideString read Get_Name write Set_Name;
    property DateSeconds: Integer read Get_DateSeconds write Set_DateSeconds;
    property Date: WideString read Get_Date write Set_Date;
    property IsDirectory: WordBool read Get_IsDirectory write Set_IsDirectory;
  end;

// *********************************************************************//
// DispIntf:  IFtpFileDisp
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {0B545BC4-BFB2-4426-8EDF-2F482EA5C511}
// *********************************************************************//
  IFtpFileDisp = dispinterface
    ['{0B545BC4-BFB2-4426-8EDF-2F482EA5C511}']
    procedure Clear; dispid 20;
    property Size: Integer dispid 102;
    property Name: WideString dispid 103;
    property DateSeconds: Integer dispid 104;
    property Date: WideString dispid 105;
    property IsDirectory: WordBool dispid 106;
  end;

// *********************************************************************//
// Interface: IUdp
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {96DD0191-EFBF-4C6E-B045-DB33F0D4A72F}
// *********************************************************************//
  IUdp = interface(IDispatch)
    ['{96DD0191-EFBF-4C6E-B045-DB33F0D4A72F}']
    function Get_Version: WideString; safecall;
    function Get_Build: WideString; safecall;
    function Get_Module: WideString; safecall;
    function Get_LicenseStatus: WideString; safecall;
    procedure Set_Reserved(Param1: Integer); safecall;
    function Get_LastError: Integer; safecall;
    function Get_LogFile: WideString; safecall;
    procedure Set_LogFile(const pVal: WideString); safecall;
    function Get_LicenseKey: WideString; safecall;
    procedure Clear; safecall;
    function GetErrorDescription(newVal: Integer): WideString; safecall;
    procedure Activate(const bstrRegKey: WideString; bPersistent: WordBool); safecall;
    procedure Sleep(lMilliSeconds: Integer); safecall;
    function Get_NewLine: WideString; safecall;
    procedure Set_NewLine(const pbstrNewLine: WideString); safecall;
    function Get_IOTimeout: Integer; safecall;
    procedure Set_IOTimeout(pVal: Integer); safecall;
    function Get_RemoteAddress: WideString; safecall;
    procedure Open(const bstrHost: WideString; lPort: Integer; bListen: WordBool; 
                   bVersion6: WordBool); safecall;
    procedure Close; safecall;
    function HasData: WordBool; safecall;
    procedure SendByte(sByte: Smallint); safecall;
    procedure SendBytes(const bstrBytes: WideString); safecall;
    procedure SendString(const bstrString: WideString); safecall;
    function ReceiveByte: Smallint; safecall;
    function ReceiveBytes: WideString; safecall;
    function ReceiveString: WideString; safecall;
    property Version: WideString read Get_Version;
    property Build: WideString read Get_Build;
    property Module: WideString read Get_Module;
    property LicenseStatus: WideString read Get_LicenseStatus;
    property Reserved: Integer write Set_Reserved;
    property LastError: Integer read Get_LastError;
    property LogFile: WideString read Get_LogFile write Set_LogFile;
    property LicenseKey: WideString read Get_LicenseKey;
    property NewLine: WideString read Get_NewLine write Set_NewLine;
    property IOTimeout: Integer read Get_IOTimeout write Set_IOTimeout;
    property RemoteAddress: WideString read Get_RemoteAddress;
  end;

// *********************************************************************//
// DispIntf:  IUdpDisp
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {96DD0191-EFBF-4C6E-B045-DB33F0D4A72F}
// *********************************************************************//
  IUdpDisp = dispinterface
    ['{96DD0191-EFBF-4C6E-B045-DB33F0D4A72F}']
    property Version: WideString readonly dispid 1;
    property Build: WideString readonly dispid 2;
    property Module: WideString readonly dispid 3;
    property LicenseStatus: WideString readonly dispid 4;
    property Reserved: Integer writeonly dispid 5;
    property LastError: Integer readonly dispid 6;
    property LogFile: WideString dispid 7;
    property LicenseKey: WideString readonly dispid 8;
    procedure Clear; dispid 20;
    function GetErrorDescription(newVal: Integer): WideString; dispid 21;
    procedure Activate(const bstrRegKey: WideString; bPersistent: WordBool); dispid 22;
    procedure Sleep(lMilliSeconds: Integer); dispid 23;
    property NewLine: WideString dispid 101;
    property IOTimeout: Integer dispid 102;
    property RemoteAddress: WideString readonly dispid 110;
    procedure Open(const bstrHost: WideString; lPort: Integer; bListen: WordBool; 
                   bVersion6: WordBool); dispid 201;
    procedure Close; dispid 202;
    function HasData: WordBool; dispid 210;
    procedure SendByte(sByte: Smallint); dispid 220;
    procedure SendBytes(const bstrBytes: WideString); dispid 221;
    procedure SendString(const bstrString: WideString); dispid 222;
    function ReceiveByte: Smallint; dispid 230;
    function ReceiveBytes: WideString; dispid 231;
    function ReceiveString: WideString; dispid 232;
  end;

// *********************************************************************//
// Interface: ISnmpObject
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {C3E4F5F3-C188-4F3B-9A41-9CAE2891150E}
// *********************************************************************//
  ISnmpObject = interface(IDispatch)
    ['{C3E4F5F3-C188-4F3B-9A41-9CAE2891150E}']
    procedure Clear; safecall;
    function Get_OID: WideString; safecall;
    procedure Set_OID(const pVal: WideString); safecall;
    function Get_Value: WideString; safecall;
    procedure Set_Value(const pVal: WideString); safecall;
    function Get_Type_: Integer; safecall;
    procedure Set_Type_(pVal: Integer); safecall;
    function Get_Description: WideString; safecall;
    procedure Set_Description(const pVal: WideString); safecall;
    function Get_NodeID: Integer; safecall;
    procedure Set_NodeID(pVal: Integer); safecall;
    function Get_ParentNodeID: Integer; safecall;
    procedure Set_ParentNodeID(pVal: Integer); safecall;
    function Get_OIDNameShort: WideString; safecall;
    procedure Set_OIDNameShort(const pVal: WideString); safecall;
    function Get_RequestID: Integer; safecall;
    procedure Set_RequestID(pVal: Integer); safecall;
    function Get_Syntax: WideString; safecall;
    procedure Set_Syntax(const pVal: WideString); safecall;
    function Get_Access: Integer; safecall;
    procedure Set_Access(pVal: Integer); safecall;
    function Get_Status: Integer; safecall;
    procedure Set_Status(pVal: Integer); safecall;
    function Get_OIDName: WideString; safecall;
    procedure Set_OIDName(const pVal: WideString); safecall;
    function Get_IsUserMib: WordBool; safecall;
    procedure Set_IsUserMib(pVal: WordBool); safecall;
    function Get_IsFolder: WordBool; safecall;
    procedure Set_IsFolder(pVal: WordBool); safecall;
    function Get_IsTrap: WordBool; safecall;
    procedure Set_IsTrap(pVal: WordBool); safecall;
    property OID: WideString read Get_OID write Set_OID;
    property Value: WideString read Get_Value write Set_Value;
    property Type_: Integer read Get_Type_ write Set_Type_;
    property Description: WideString read Get_Description write Set_Description;
    property NodeID: Integer read Get_NodeID write Set_NodeID;
    property ParentNodeID: Integer read Get_ParentNodeID write Set_ParentNodeID;
    property OIDNameShort: WideString read Get_OIDNameShort write Set_OIDNameShort;
    property RequestID: Integer read Get_RequestID write Set_RequestID;
    property Syntax: WideString read Get_Syntax write Set_Syntax;
    property Access: Integer read Get_Access write Set_Access;
    property Status: Integer read Get_Status write Set_Status;
    property OIDName: WideString read Get_OIDName write Set_OIDName;
    property IsUserMib: WordBool read Get_IsUserMib write Set_IsUserMib;
    property IsFolder: WordBool read Get_IsFolder write Set_IsFolder;
    property IsTrap: WordBool read Get_IsTrap write Set_IsTrap;
  end;

// *********************************************************************//
// DispIntf:  ISnmpObjectDisp
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {C3E4F5F3-C188-4F3B-9A41-9CAE2891150E}
// *********************************************************************//
  ISnmpObjectDisp = dispinterface
    ['{C3E4F5F3-C188-4F3B-9A41-9CAE2891150E}']
    procedure Clear; dispid 20;
    property OID: WideString dispid 101;
    property Value: WideString dispid 102;
    property Type_: Integer dispid 103;
    property Description: WideString dispid 105;
    property NodeID: Integer dispid 106;
    property ParentNodeID: Integer dispid 107;
    property OIDNameShort: WideString dispid 108;
    property RequestID: Integer dispid 109;
    property Syntax: WideString dispid 110;
    property Access: Integer dispid 111;
    property Status: Integer dispid 112;
    property OIDName: WideString dispid 113;
    property IsUserMib: WordBool dispid 114;
    property IsFolder: WordBool dispid 115;
    property IsTrap: WordBool dispid 116;
  end;

// *********************************************************************//
// Interface: ITcp
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {4CCDB6A4-1BEE-4D3C-9937-D53CDFB5E1A3}
// *********************************************************************//
  ITcp = interface(IDispatch)
    ['{4CCDB6A4-1BEE-4D3C-9937-D53CDFB5E1A3}']
    function Get_Version: WideString; safecall;
    function Get_Build: WideString; safecall;
    function Get_Module: WideString; safecall;
    function Get_LicenseStatus: WideString; safecall;
    procedure Set_Reserved(Param1: Integer); safecall;
    function Get_LastError: Integer; safecall;
    function Get_LogFile: WideString; safecall;
    procedure Set_LogFile(const pVal: WideString); safecall;
    function Get_LicenseKey: WideString; safecall;
    procedure Clear; safecall;
    function GetErrorDescription(newVal: Integer): WideString; safecall;
    procedure Activate(const bstrRegKey: WideString; bPersistent: WordBool); safecall;
    procedure Sleep(lMilliSeconds: Integer); safecall;
    function Get_Protocol: Integer; safecall;
    procedure Set_Protocol(pVal: Integer); safecall;
    function Get_NewLine: WideString; safecall;
    procedure Set_NewLine(const pVal: WideString); safecall;
    function Get_IOTimeout: Integer; safecall;
    procedure Set_IOTimeout(pVal: Integer); safecall;
    function Get_RemoteAddress: WideString; safecall;
    function Get_ConnectionState: Integer; safecall;
    procedure Connect(const HostName: WideString; PortNumber: Integer); safecall;
    procedure Disconnect; safecall;
    procedure StartListening(PortNumber: Integer; bVersion6: WordBool); safecall;
    procedure StopListening; safecall;
    function HasData: WordBool; safecall;
    function ReceiveString: WideString; safecall;
    procedure SendString(const DataString: WideString); safecall;
    procedure SendByte(Byte: Smallint); safecall;
    function ReceiveByte: Smallint; safecall;
    procedure SendBytes(const Bytes: WideString); safecall;
    function ReceiveBytes: WideString; safecall;
    function GetHostName(const Host: WideString): WideString; safecall;
    property Version: WideString read Get_Version;
    property Build: WideString read Get_Build;
    property Module: WideString read Get_Module;
    property LicenseStatus: WideString read Get_LicenseStatus;
    property Reserved: Integer write Set_Reserved;
    property LastError: Integer read Get_LastError;
    property LogFile: WideString read Get_LogFile write Set_LogFile;
    property LicenseKey: WideString read Get_LicenseKey;
    property Protocol: Integer read Get_Protocol write Set_Protocol;
    property NewLine: WideString read Get_NewLine write Set_NewLine;
    property IOTimeout: Integer read Get_IOTimeout write Set_IOTimeout;
    property RemoteAddress: WideString read Get_RemoteAddress;
    property ConnectionState: Integer read Get_ConnectionState;
  end;

// *********************************************************************//
// DispIntf:  ITcpDisp
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {4CCDB6A4-1BEE-4D3C-9937-D53CDFB5E1A3}
// *********************************************************************//
  ITcpDisp = dispinterface
    ['{4CCDB6A4-1BEE-4D3C-9937-D53CDFB5E1A3}']
    property Version: WideString readonly dispid 1;
    property Build: WideString readonly dispid 2;
    property Module: WideString readonly dispid 3;
    property LicenseStatus: WideString readonly dispid 4;
    property Reserved: Integer writeonly dispid 5;
    property LastError: Integer readonly dispid 6;
    property LogFile: WideString dispid 7;
    property LicenseKey: WideString readonly dispid 8;
    procedure Clear; dispid 20;
    function GetErrorDescription(newVal: Integer): WideString; dispid 21;
    procedure Activate(const bstrRegKey: WideString; bPersistent: WordBool); dispid 22;
    procedure Sleep(lMilliSeconds: Integer); dispid 23;
    property Protocol: Integer dispid 101;
    property NewLine: WideString dispid 102;
    property IOTimeout: Integer dispid 103;
    property RemoteAddress: WideString readonly dispid 110;
    property ConnectionState: Integer readonly dispid 111;
    procedure Connect(const HostName: WideString; PortNumber: Integer); dispid 201;
    procedure Disconnect; dispid 202;
    procedure StartListening(PortNumber: Integer; bVersion6: WordBool); dispid 220;
    procedure StopListening; dispid 221;
    function HasData: WordBool; dispid 230;
    function ReceiveString: WideString; dispid 231;
    procedure SendString(const DataString: WideString); dispid 232;
    procedure SendByte(Byte: Smallint); dispid 233;
    function ReceiveByte: Smallint; dispid 234;
    procedure SendBytes(const Bytes: WideString); dispid 235;
    function ReceiveBytes: WideString; dispid 236;
    function GetHostName(const Host: WideString): WideString; dispid 300;
  end;

// *********************************************************************//
// Interface: IIPtoCountry
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {D886339C-6F33-49AC-9FA8-73FC5A227769}
// *********************************************************************//
  IIPtoCountry = interface(IDispatch)
    ['{D886339C-6F33-49AC-9FA8-73FC5A227769}']
    function Get_Version: WideString; safecall;
    function Get_Build: WideString; safecall;
    function Get_Module: WideString; safecall;
    function Get_LicenseStatus: WideString; safecall;
    procedure Set_Reserved(Param1: Integer); safecall;
    function Get_LastError: Integer; safecall;
    function Get_LogFile: WideString; safecall;
    procedure Set_LogFile(const pVal: WideString); safecall;
    function Get_LicenseKey: WideString; safecall;
    procedure Clear; safecall;
    function GetErrorDescription(newVal: Integer): WideString; safecall;
    procedure Activate(const bstrRegKey: WideString; bPersistent: WordBool); safecall;
    procedure Sleep(lMilliSeconds: Integer); safecall;
    function Get_Host: WideString; safecall;
    procedure Set_Host(const pVal: WideString); safecall;
    function Get_CountryCode: WideString; safecall;
    function Get_CountryCodeEx: WideString; safecall;
    function Get_CountryName: WideString; safecall;
    procedure Query; safecall;
    property Version: WideString read Get_Version;
    property Build: WideString read Get_Build;
    property Module: WideString read Get_Module;
    property LicenseStatus: WideString read Get_LicenseStatus;
    property Reserved: Integer write Set_Reserved;
    property LastError: Integer read Get_LastError;
    property LogFile: WideString read Get_LogFile write Set_LogFile;
    property LicenseKey: WideString read Get_LicenseKey;
    property Host: WideString read Get_Host write Set_Host;
    property CountryCode: WideString read Get_CountryCode;
    property CountryCodeEx: WideString read Get_CountryCodeEx;
    property CountryName: WideString read Get_CountryName;
  end;

// *********************************************************************//
// DispIntf:  IIPtoCountryDisp
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {D886339C-6F33-49AC-9FA8-73FC5A227769}
// *********************************************************************//
  IIPtoCountryDisp = dispinterface
    ['{D886339C-6F33-49AC-9FA8-73FC5A227769}']
    property Version: WideString readonly dispid 1;
    property Build: WideString readonly dispid 2;
    property Module: WideString readonly dispid 3;
    property LicenseStatus: WideString readonly dispid 4;
    property Reserved: Integer writeonly dispid 5;
    property LastError: Integer readonly dispid 6;
    property LogFile: WideString dispid 7;
    property LicenseKey: WideString readonly dispid 8;
    procedure Clear; dispid 20;
    function GetErrorDescription(newVal: Integer): WideString; dispid 21;
    procedure Activate(const bstrRegKey: WideString; bPersistent: WordBool); dispid 22;
    procedure Sleep(lMilliSeconds: Integer); dispid 23;
    property Host: WideString dispid 101;
    property CountryCode: WideString readonly dispid 102;
    property CountryCodeEx: WideString readonly dispid 103;
    property CountryName: WideString readonly dispid 104;
    procedure Query; dispid 201;
  end;

// *********************************************************************//
// Interface: IDnsServer
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {D51DDAA9-6264-4ED7-82DF-1A46DE9D1C37}
// *********************************************************************//
  IDnsServer = interface(IDispatch)
    ['{D51DDAA9-6264-4ED7-82DF-1A46DE9D1C37}']
    function Get_Version: WideString; safecall;
    function Get_Build: WideString; safecall;
    function Get_Module: WideString; safecall;
    function Get_LicenseStatus: WideString; safecall;
    procedure Set_Reserved(Param1: Integer); safecall;
    function Get_LastError: Integer; safecall;
    function Get_LogFile: WideString; safecall;
    procedure Set_LogFile(const pVal: WideString); safecall;
    function Get_LicenseKey: WideString; safecall;
    procedure Clear; safecall;
    function GetErrorDescription(newVal: Integer): WideString; safecall;
    procedure Activate(const bstrRegKey: WideString; bPersistent: WordBool); safecall;
    function Get_Server: WideString; safecall;
    procedure Set_Server(const pVal: WideString); safecall;
    function Get_ServerPort: Integer; safecall;
    procedure Set_ServerPort(pVal: Integer); safecall;
    function Get_ActivityFile: WideString; safecall;
    procedure Set_ActivityFile(const pVal: WideString); safecall;
    function Get_IsAuthoritative: WordBool; safecall;
    procedure Lookup(const bstrHost: WideString; lType: Integer); safecall;
    function GetFirstRecord: OleVariant; safecall;
    function GetNextRecord: OleVariant; safecall;
    property Version: WideString read Get_Version;
    property Build: WideString read Get_Build;
    property Module: WideString read Get_Module;
    property LicenseStatus: WideString read Get_LicenseStatus;
    property Reserved: Integer write Set_Reserved;
    property LastError: Integer read Get_LastError;
    property LogFile: WideString read Get_LogFile write Set_LogFile;
    property LicenseKey: WideString read Get_LicenseKey;
    property Server: WideString read Get_Server write Set_Server;
    property ServerPort: Integer read Get_ServerPort write Set_ServerPort;
    property ActivityFile: WideString read Get_ActivityFile write Set_ActivityFile;
    property IsAuthoritative: WordBool read Get_IsAuthoritative;
  end;

// *********************************************************************//
// DispIntf:  IDnsServerDisp
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {D51DDAA9-6264-4ED7-82DF-1A46DE9D1C37}
// *********************************************************************//
  IDnsServerDisp = dispinterface
    ['{D51DDAA9-6264-4ED7-82DF-1A46DE9D1C37}']
    property Version: WideString readonly dispid 1;
    property Build: WideString readonly dispid 2;
    property Module: WideString readonly dispid 3;
    property LicenseStatus: WideString readonly dispid 4;
    property Reserved: Integer writeonly dispid 5;
    property LastError: Integer readonly dispid 6;
    property LogFile: WideString dispid 7;
    property LicenseKey: WideString readonly dispid 8;
    procedure Clear; dispid 20;
    function GetErrorDescription(newVal: Integer): WideString; dispid 21;
    procedure Activate(const bstrRegKey: WideString; bPersistent: WordBool); dispid 22;
    property Server: WideString dispid 101;
    property ServerPort: Integer dispid 102;
    property ActivityFile: WideString dispid 103;
    property IsAuthoritative: WordBool readonly dispid 104;
    procedure Lookup(const bstrHost: WideString; lType: Integer); dispid 201;
    function GetFirstRecord: OleVariant; dispid 202;
    function GetNextRecord: OleVariant; dispid 203;
  end;

// *********************************************************************//
// Interface: IDnsRecord
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {CFCFF8CA-30EA-44F8-856E-52AD9A971024}
// *********************************************************************//
  IDnsRecord = interface(IDispatch)
    ['{CFCFF8CA-30EA-44F8-856E-52AD9A971024}']
    procedure Clear; safecall;
    function Get_Name: WideString; safecall;
    procedure Set_Name(const pVal: WideString); safecall;
    function Get_Class_: Integer; safecall;
    procedure Set_Class_(pVal: Integer); safecall;
    function Get_Type_: Integer; safecall;
    procedure Set_Type_(pVal: Integer); safecall;
    function Get_Ttl: Integer; safecall;
    procedure Set_Ttl(pVal: Integer); safecall;
    function Get_Preference: Integer; safecall;
    procedure Set_Preference(pVal: Integer); safecall;
    function Get_NameServer: WideString; safecall;
    procedure Set_NameServer(const pVal: WideString); safecall;
    function Get_MailExchange: WideString; safecall;
    procedure Set_MailExchange(const pVal: WideString); safecall;
    function Get_Address: WideString; safecall;
    procedure Set_Address(const pVal: WideString); safecall;
    function Get_MailBox: WideString; safecall;
    procedure Set_MailBox(const pVal: WideString); safecall;
    function Get_SerialNumber: WideString; safecall;
    procedure Set_SerialNumber(const pVal: WideString); safecall;
    function Get_RefreshInterval: Integer; safecall;
    procedure Set_RefreshInterval(pVal: Integer); safecall;
    function Get_RetryInterval: Integer; safecall;
    procedure Set_RetryInterval(pVal: Integer); safecall;
    function Get_ExpirationLimit: Integer; safecall;
    procedure Set_ExpirationLimit(pVal: Integer); safecall;
    function Get_MinimumTTL: Integer; safecall;
    procedure Set_MinimumTTL(pVal: Integer); safecall;
    property Name: WideString read Get_Name write Set_Name;
    property Class_: Integer read Get_Class_ write Set_Class_;
    property Type_: Integer read Get_Type_ write Set_Type_;
    property Ttl: Integer read Get_Ttl write Set_Ttl;
    property Preference: Integer read Get_Preference write Set_Preference;
    property NameServer: WideString read Get_NameServer write Set_NameServer;
    property MailExchange: WideString read Get_MailExchange write Set_MailExchange;
    property Address: WideString read Get_Address write Set_Address;
    property MailBox: WideString read Get_MailBox write Set_MailBox;
    property SerialNumber: WideString read Get_SerialNumber write Set_SerialNumber;
    property RefreshInterval: Integer read Get_RefreshInterval write Set_RefreshInterval;
    property RetryInterval: Integer read Get_RetryInterval write Set_RetryInterval;
    property ExpirationLimit: Integer read Get_ExpirationLimit write Set_ExpirationLimit;
    property MinimumTTL: Integer read Get_MinimumTTL write Set_MinimumTTL;
  end;

// *********************************************************************//
// DispIntf:  IDnsRecordDisp
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {CFCFF8CA-30EA-44F8-856E-52AD9A971024}
// *********************************************************************//
  IDnsRecordDisp = dispinterface
    ['{CFCFF8CA-30EA-44F8-856E-52AD9A971024}']
    procedure Clear; dispid 20;
    property Name: WideString dispid 101;
    property Class_: Integer dispid 102;
    property Type_: Integer dispid 103;
    property Ttl: Integer dispid 104;
    property Preference: Integer dispid 105;
    property NameServer: WideString dispid 106;
    property MailExchange: WideString dispid 107;
    property Address: WideString dispid 108;
    property MailBox: WideString dispid 109;
    property SerialNumber: WideString dispid 110;
    property RefreshInterval: Integer dispid 111;
    property RetryInterval: Integer dispid 112;
    property ExpirationLimit: Integer dispid 113;
    property MinimumTTL: Integer dispid 114;
  end;

// *********************************************************************//
// Interface: ISsh
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {CF6C8D3D-1ACE-4111-AE15-724CB21DAC08}
// *********************************************************************//
  ISsh = interface(IDispatch)
    ['{CF6C8D3D-1ACE-4111-AE15-724CB21DAC08}']
    function Get_Version: WideString; safecall;
    function Get_Build: WideString; safecall;
    function Get_Module: WideString; safecall;
    function Get_LicenseStatus: WideString; safecall;
    procedure Set_Reserved(Param1: Integer); safecall;
    function Get_LastError: Integer; safecall;
    function Get_LogFile: WideString; safecall;
    procedure Set_LogFile(const pVal: WideString); safecall;
    function Get_LicenseKey: WideString; safecall;
    procedure Clear; safecall;
    function GetErrorDescription(newVal: Integer): WideString; safecall;
    procedure Activate(const bstrRegKey: WideString; bPersistent: WordBool); safecall;
    procedure Sleep(lMilliSeconds: Integer); safecall;
    function Get_Host: WideString; safecall;
    procedure Set_Host(const pVal: WideString); safecall;
    function Get_Port: Integer; safecall;
    procedure Set_Port(pVal: Integer); safecall;
    function Get_RequireHostVerification: WordBool; safecall;
    procedure Set_RequireHostVerification(pVal: WordBool); safecall;
    function Get_UserName: WideString; safecall;
    procedure Set_UserName(const pVal: WideString); safecall;
    function Get_Password: WideString; safecall;
    procedure Set_Password(const pVal: WideString); safecall;
    function Get_PrivateKeyFile: WideString; safecall;
    procedure Set_PrivateKeyFile(const pVal: WideString); safecall;
    function Get_Command: WideString; safecall;
    procedure Set_Command(const pVal: WideString); safecall;
    function Get_ScriptTimeOut: Integer; safecall;
    procedure Set_ScriptTimeOut(pVal: Integer); safecall;
    function Get_StdOut: WideString; safecall;
    function Get_StdErr: WideString; safecall;
    function Get_AcceptHostKey: WordBool; safecall;
    procedure Set_AcceptHostKey(pVal: WordBool); safecall;
    function Get_HostFingerprint: WideString; safecall;
    procedure Run; safecall;
    function Get_sysTmpFileRes: WideString; safecall;
    procedure Set_sysTmpFileRes(const pVal: WideString); safecall;
    function Get_sysTmpFileOut: WideString; safecall;
    procedure Set_sysTmpFileOut(const pVal: WideString); safecall;
    function Get_sysTmpFileErr: WideString; safecall;
    procedure Set_sysTmpFileErr(const pVal: WideString); safecall;
    function Get_ProtocolError: WideString; safecall;
    property Version: WideString read Get_Version;
    property Build: WideString read Get_Build;
    property Module: WideString read Get_Module;
    property LicenseStatus: WideString read Get_LicenseStatus;
    property Reserved: Integer write Set_Reserved;
    property LastError: Integer read Get_LastError;
    property LogFile: WideString read Get_LogFile write Set_LogFile;
    property LicenseKey: WideString read Get_LicenseKey;
    property Host: WideString read Get_Host write Set_Host;
    property Port: Integer read Get_Port write Set_Port;
    property RequireHostVerification: WordBool read Get_RequireHostVerification write Set_RequireHostVerification;
    property UserName: WideString read Get_UserName write Set_UserName;
    property Password: WideString read Get_Password write Set_Password;
    property PrivateKeyFile: WideString read Get_PrivateKeyFile write Set_PrivateKeyFile;
    property Command: WideString read Get_Command write Set_Command;
    property ScriptTimeOut: Integer read Get_ScriptTimeOut write Set_ScriptTimeOut;
    property StdOut: WideString read Get_StdOut;
    property StdErr: WideString read Get_StdErr;
    property AcceptHostKey: WordBool read Get_AcceptHostKey write Set_AcceptHostKey;
    property HostFingerprint: WideString read Get_HostFingerprint;
    property sysTmpFileRes: WideString read Get_sysTmpFileRes write Set_sysTmpFileRes;
    property sysTmpFileOut: WideString read Get_sysTmpFileOut write Set_sysTmpFileOut;
    property sysTmpFileErr: WideString read Get_sysTmpFileErr write Set_sysTmpFileErr;
    property ProtocolError: WideString read Get_ProtocolError;
  end;

// *********************************************************************//
// DispIntf:  ISshDisp
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {CF6C8D3D-1ACE-4111-AE15-724CB21DAC08}
// *********************************************************************//
  ISshDisp = dispinterface
    ['{CF6C8D3D-1ACE-4111-AE15-724CB21DAC08}']
    property Version: WideString readonly dispid 1;
    property Build: WideString readonly dispid 2;
    property Module: WideString readonly dispid 3;
    property LicenseStatus: WideString readonly dispid 4;
    property Reserved: Integer writeonly dispid 5;
    property LastError: Integer readonly dispid 6;
    property LogFile: WideString dispid 7;
    property LicenseKey: WideString readonly dispid 8;
    procedure Clear; dispid 20;
    function GetErrorDescription(newVal: Integer): WideString; dispid 21;
    procedure Activate(const bstrRegKey: WideString; bPersistent: WordBool); dispid 22;
    procedure Sleep(lMilliSeconds: Integer); dispid 23;
    property Host: WideString dispid 110;
    property Port: Integer dispid 111;
    property RequireHostVerification: WordBool dispid 112;
    property UserName: WideString dispid 113;
    property Password: WideString dispid 114;
    property PrivateKeyFile: WideString dispid 115;
    property Command: WideString dispid 116;
    property ScriptTimeOut: Integer dispid 117;
    property StdOut: WideString readonly dispid 120;
    property StdErr: WideString readonly dispid 121;
    property AcceptHostKey: WordBool dispid 122;
    property HostFingerprint: WideString readonly dispid 123;
    procedure Run; dispid 201;
    property sysTmpFileRes: WideString dispid 900;
    property sysTmpFileOut: WideString dispid 901;
    property sysTmpFileErr: WideString dispid 902;
    property ProtocolError: WideString readonly dispid 903;
  end;

// *********************************************************************//
// Interface: ISnmpMibBrowser
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {3FEF0C60-A4D8-4740-A6B7-5DF4388996B0}
// *********************************************************************//
  ISnmpMibBrowser = interface(IDispatch)
    ['{3FEF0C60-A4D8-4740-A6B7-5DF4388996B0}']
    function Get_Version: WideString; safecall;
    function Get_Build: WideString; safecall;
    function Get_Module: WideString; safecall;
    function Get_LicenseStatus: WideString; safecall;
    procedure Set_Reserved(Param1: Integer); safecall;
    function Get_LastError: Integer; safecall;
    function Get_LogFile: WideString; safecall;
    procedure Set_LogFile(const pVal: WideString); safecall;
    function Get_LicenseKey: WideString; safecall;
    procedure Clear; safecall;
    function GetErrorDescription(newVal: Integer): WideString; safecall;
    procedure Activate(const bstrRegKey: WideString; bPersistent: WordBool); safecall;
    procedure LoadMibFile(const bstrFileName: WideString); safecall;
    function Get(const bstrParent: WideString): OleVariant; safecall;
    function GetNext: OleVariant; safecall;
    function LookupOIDName(const bstrOID: WideString): WideString; safecall;
    property Version: WideString read Get_Version;
    property Build: WideString read Get_Build;
    property Module: WideString read Get_Module;
    property LicenseStatus: WideString read Get_LicenseStatus;
    property Reserved: Integer write Set_Reserved;
    property LastError: Integer read Get_LastError;
    property LogFile: WideString read Get_LogFile write Set_LogFile;
    property LicenseKey: WideString read Get_LicenseKey;
  end;

// *********************************************************************//
// DispIntf:  ISnmpMibBrowserDisp
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {3FEF0C60-A4D8-4740-A6B7-5DF4388996B0}
// *********************************************************************//
  ISnmpMibBrowserDisp = dispinterface
    ['{3FEF0C60-A4D8-4740-A6B7-5DF4388996B0}']
    property Version: WideString readonly dispid 1;
    property Build: WideString readonly dispid 2;
    property Module: WideString readonly dispid 3;
    property LicenseStatus: WideString readonly dispid 4;
    property Reserved: Integer writeonly dispid 5;
    property LastError: Integer readonly dispid 6;
    property LogFile: WideString dispid 7;
    property LicenseKey: WideString readonly dispid 8;
    procedure Clear; dispid 20;
    function GetErrorDescription(newVal: Integer): WideString; dispid 21;
    procedure Activate(const bstrRegKey: WideString; bPersistent: WordBool); dispid 22;
    procedure LoadMibFile(const bstrFileName: WideString); dispid 201;
    function Get(const bstrParent: WideString): OleVariant; dispid 202;
    function GetNext: OleVariant; dispid 203;
    function LookupOIDName(const bstrOID: WideString): WideString; dispid 300;
  end;

// *********************************************************************//
// Interface: ITftpServer
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {411DBA2E-A588-4F74-AD8B-4E426E63894A}
// *********************************************************************//
  ITftpServer = interface(IDispatch)
    ['{411DBA2E-A588-4F74-AD8B-4E426E63894A}']
    function Get_Version: WideString; safecall;
    function Get_Build: WideString; safecall;
    function Get_Module: WideString; safecall;
    function Get_LicenseStatus: WideString; safecall;
    procedure Set_Reserved(Param1: Integer); safecall;
    function Get_LastError: Integer; safecall;
    function Get_LogFile: WideString; safecall;
    procedure Set_LogFile(const pVal: WideString); safecall;
    function Get_LicenseKey: WideString; safecall;
    procedure Clear; safecall;
    function GetErrorDescription(newVal: Integer): WideString; safecall;
    procedure Activate(const bstrRegKey: WideString; bPersistent: WordBool); safecall;
    function Get_HostPort: Integer; safecall;
    procedure Set_HostPort(pVal: Integer); safecall;
    function Get_BinaryTransfer: WordBool; safecall;
    procedure Set_BinaryTransfer(pVal: WordBool); safecall;
    function Get_Timeout: Integer; safecall;
    procedure Set_Timeout(pVal: Integer); safecall;
    function Get_PacketsSent: Integer; safecall;
    function Get_BytesSent: Integer; safecall;
    function Get_PacketsReceived: Integer; safecall;
    function Get_BytesReceived: Integer; safecall;
    procedure Get(const Host: WideString; const RemoteFile: WideString; const LocalFile: WideString); safecall;
    procedure Put(const Host: WideString; const LocalFile: WideString; const RemoteFile: WideString); safecall;
    property Version: WideString read Get_Version;
    property Build: WideString read Get_Build;
    property Module: WideString read Get_Module;
    property LicenseStatus: WideString read Get_LicenseStatus;
    property Reserved: Integer write Set_Reserved;
    property LastError: Integer read Get_LastError;
    property LogFile: WideString read Get_LogFile write Set_LogFile;
    property LicenseKey: WideString read Get_LicenseKey;
    property HostPort: Integer read Get_HostPort write Set_HostPort;
    property BinaryTransfer: WordBool read Get_BinaryTransfer write Set_BinaryTransfer;
    property Timeout: Integer read Get_Timeout write Set_Timeout;
    property PacketsSent: Integer read Get_PacketsSent;
    property BytesSent: Integer read Get_BytesSent;
    property PacketsReceived: Integer read Get_PacketsReceived;
    property BytesReceived: Integer read Get_BytesReceived;
  end;

// *********************************************************************//
// DispIntf:  ITftpServerDisp
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {411DBA2E-A588-4F74-AD8B-4E426E63894A}
// *********************************************************************//
  ITftpServerDisp = dispinterface
    ['{411DBA2E-A588-4F74-AD8B-4E426E63894A}']
    property Version: WideString readonly dispid 1;
    property Build: WideString readonly dispid 2;
    property Module: WideString readonly dispid 3;
    property LicenseStatus: WideString readonly dispid 4;
    property Reserved: Integer writeonly dispid 5;
    property LastError: Integer readonly dispid 6;
    property LogFile: WideString dispid 7;
    property LicenseKey: WideString readonly dispid 8;
    procedure Clear; dispid 20;
    function GetErrorDescription(newVal: Integer): WideString; dispid 21;
    procedure Activate(const bstrRegKey: WideString; bPersistent: WordBool); dispid 22;
    property HostPort: Integer dispid 100;
    property BinaryTransfer: WordBool dispid 101;
    property Timeout: Integer dispid 102;
    property PacketsSent: Integer readonly dispid 110;
    property BytesSent: Integer readonly dispid 111;
    property PacketsReceived: Integer readonly dispid 115;
    property BytesReceived: Integer readonly dispid 116;
    procedure Get(const Host: WideString; const RemoteFile: WideString; const LocalFile: WideString); dispid 200;
    procedure Put(const Host: WideString; const LocalFile: WideString; const RemoteFile: WideString); dispid 201;
  end;

// *********************************************************************//
// Interface: IMsn
// Flags:     (4544) Dual NonExtensible OleAutomation Dispatchable
// GUID:      {6EA3B1C3-71BA-4404-AA01-BB39CE2A3423}
// *********************************************************************//
  IMsn = interface(IDispatch)
    ['{6EA3B1C3-71BA-4404-AA01-BB39CE2A3423}']
    function Get_Version: WideString; safecall;
    function Get_Build: WideString; safecall;
    function Get_Module: WideString; safecall;
    function Get_LicenseStatus: WideString; safecall;
    procedure Set_Reserved(Param1: Integer); safecall;
    function Get_LastError: Integer; safecall;
    function Get_LogFile: WideString; safecall;
    procedure Set_LogFile(const pVal: WideString); safecall;
    function Get_LicenseKey: WideString; safecall;
    procedure Clear; safecall;
    function GetErrorDescription(newVal: Integer): WideString; safecall;
    function Get_Server: WideString; safecall;
    procedure Set_Server(const pVal: WideString); safecall;
    function Get_ServerPort: Integer; safecall;
    procedure Set_ServerPort(pVal: Integer); safecall;
    function Get_ServerTimeout: Integer; safecall;
    procedure Set_ServerTimeout(pVal: Integer); safecall;
    function Get_MsnAccount: WideString; safecall;
    procedure Set_MsnAccount(const pVal: WideString); safecall;
    function Get_MsnPassword: WideString; safecall;
    procedure Set_MsnPassword(const pVal: WideString); safecall;
    function Get_MsnDisplayName: WideString; safecall;
    procedure Set_MsnDisplayName(const pVal: WideString); safecall;
    function Get_Message: WideString; safecall;
    procedure Set_Message(const pVal: WideString); safecall;
    procedure AddRecipient(const bstrRecipient: WideString); safecall;
    procedure Send; safecall;
    property Version: WideString read Get_Version;
    property Build: WideString read Get_Build;
    property Module: WideString read Get_Module;
    property LicenseStatus: WideString read Get_LicenseStatus;
    property Reserved: Integer write Set_Reserved;
    property LastError: Integer read Get_LastError;
    property LogFile: WideString read Get_LogFile write Set_LogFile;
    property LicenseKey: WideString read Get_LicenseKey;
    property Server: WideString read Get_Server write Set_Server;
    property ServerPort: Integer read Get_ServerPort write Set_ServerPort;
    property ServerTimeout: Integer read Get_ServerTimeout write Set_ServerTimeout;
    property MsnAccount: WideString read Get_MsnAccount write Set_MsnAccount;
    property MsnPassword: WideString read Get_MsnPassword write Set_MsnPassword;
    property MsnDisplayName: WideString read Get_MsnDisplayName write Set_MsnDisplayName;
    property Message: WideString read Get_Message write Set_Message;
  end;

// *********************************************************************//
// DispIntf:  IMsnDisp
// Flags:     (4544) Dual NonExtensible OleAutomation Dispatchable
// GUID:      {6EA3B1C3-71BA-4404-AA01-BB39CE2A3423}
// *********************************************************************//
  IMsnDisp = dispinterface
    ['{6EA3B1C3-71BA-4404-AA01-BB39CE2A3423}']
    property Version: WideString readonly dispid 1;
    property Build: WideString readonly dispid 2;
    property Module: WideString readonly dispid 3;
    property LicenseStatus: WideString readonly dispid 4;
    property Reserved: Integer writeonly dispid 5;
    property LastError: Integer readonly dispid 6;
    property LogFile: WideString dispid 7;
    property LicenseKey: WideString readonly dispid 8;
    procedure Clear; dispid 20;
    function GetErrorDescription(newVal: Integer): WideString; dispid 21;
    property Server: WideString dispid 101;
    property ServerPort: Integer dispid 102;
    property ServerTimeout: Integer dispid 103;
    property MsnAccount: WideString dispid 111;
    property MsnPassword: WideString dispid 112;
    property MsnDisplayName: WideString dispid 113;
    property Message: WideString dispid 121;
    procedure AddRecipient(const bstrRecipient: WideString); dispid 201;
    procedure Send; dispid 202;
  end;

// *********************************************************************//
// Interface: IRadius
// Flags:     (4544) Dual NonExtensible OleAutomation Dispatchable
// GUID:      {8218765A-2229-40DF-B600-A8A64AF09AC5}
// *********************************************************************//
  IRadius = interface(IDispatch)
    ['{8218765A-2229-40DF-B600-A8A64AF09AC5}']
    function Get_Version: WideString; safecall;
    function Get_Build: WideString; safecall;
    function Get_Module: WideString; safecall;
    function Get_LicenseStatus: WideString; safecall;
    procedure Set_Reserved(Param1: Integer); safecall;
    function Get_LastError: Integer; safecall;
    function Get_LogFile: WideString; safecall;
    procedure Set_LogFile(const pVal: WideString); safecall;
    function Get_LicenseKey: WideString; safecall;
    procedure Clear; safecall;
    function GetErrorDescription(newVal: Integer): WideString; safecall;
    procedure Activate(const bstrRegKey: WideString; bPersistent: WordBool); safecall;
    function Get_Port: Integer; safecall;
    procedure Set_Port(pVal: Integer); safecall;
    function Get_Timeout: Integer; safecall;
    procedure Set_Timeout(pVal: Integer); safecall;
    procedure CheckAccess(const Host: WideString; const User: WideString; 
                          const Password: WideString; const Secret: WideString); safecall;
    property Version: WideString read Get_Version;
    property Build: WideString read Get_Build;
    property Module: WideString read Get_Module;
    property LicenseStatus: WideString read Get_LicenseStatus;
    property Reserved: Integer write Set_Reserved;
    property LastError: Integer read Get_LastError;
    property LogFile: WideString read Get_LogFile write Set_LogFile;
    property LicenseKey: WideString read Get_LicenseKey;
    property Port: Integer read Get_Port write Set_Port;
    property Timeout: Integer read Get_Timeout write Set_Timeout;
  end;

// *********************************************************************//
// DispIntf:  IRadiusDisp
// Flags:     (4544) Dual NonExtensible OleAutomation Dispatchable
// GUID:      {8218765A-2229-40DF-B600-A8A64AF09AC5}
// *********************************************************************//
  IRadiusDisp = dispinterface
    ['{8218765A-2229-40DF-B600-A8A64AF09AC5}']
    property Version: WideString readonly dispid 1;
    property Build: WideString readonly dispid 2;
    property Module: WideString readonly dispid 3;
    property LicenseStatus: WideString readonly dispid 4;
    property Reserved: Integer writeonly dispid 5;
    property LastError: Integer readonly dispid 6;
    property LogFile: WideString dispid 7;
    property LicenseKey: WideString readonly dispid 8;
    procedure Clear; dispid 20;
    function GetErrorDescription(newVal: Integer): WideString; dispid 21;
    procedure Activate(const bstrRegKey: WideString; bPersistent: WordBool); dispid 22;
    property Port: Integer dispid 101;
    property Timeout: Integer dispid 102;
    procedure CheckAccess(const Host: WideString; const User: WideString; 
                          const Password: WideString; const Secret: WideString); dispid 201;
  end;

// *********************************************************************//
// Interface: IScp
// Flags:     (4544) Dual NonExtensible OleAutomation Dispatchable
// GUID:      {4116F2EA-0122-496A-A70E-AFFD0A9B5F6A}
// *********************************************************************//
  IScp = interface(IDispatch)
    ['{4116F2EA-0122-496A-A70E-AFFD0A9B5F6A}']
    function Get_Version: WideString; safecall;
    function Get_Build: WideString; safecall;
    function Get_Module: WideString; safecall;
    function Get_LicenseStatus: WideString; safecall;
    procedure Set_Reserved(Param1: Integer); safecall;
    function Get_LastError: Integer; safecall;
    function Get_LogFile: WideString; safecall;
    procedure Set_LogFile(const pVal: WideString); safecall;
    function Get_LicenseKey: WideString; safecall;
    procedure Clear; safecall;
    function GetErrorDescription(newVal: Integer): WideString; safecall;
    procedure Activate(const bstrRegKey: WideString; bPersistent: WordBool); safecall;
    procedure Sleep(lMilliSeconds: Integer); safecall;
    function Get_Host: WideString; safecall;
    procedure Set_Host(const pVal: WideString); safecall;
    function Get_Port: Integer; safecall;
    procedure Set_Port(pVal: Integer); safecall;
    function Get_UserName: WideString; safecall;
    procedure Set_UserName(const pVal: WideString); safecall;
    function Get_Password: WideString; safecall;
    procedure Set_Password(const pVal: WideString); safecall;
    function Get_PrivateKeyFile: WideString; safecall;
    procedure Set_PrivateKeyFile(const pVal: WideString); safecall;
    function Get_AcceptHostKey: WordBool; safecall;
    procedure Set_AcceptHostKey(pVal: WordBool); safecall;
    function Get_Recursive: WordBool; safecall;
    procedure Set_Recursive(pVal: WordBool); safecall;
    function Get_PreserveAttributes: WordBool; safecall;
    procedure Set_PreserveAttributes(pVal: WordBool); safecall;
    function Get_Compression: WordBool; safecall;
    procedure Set_Compression(pVal: WordBool); safecall;
    procedure Set_sysTempPath(const pVal: WideString); safecall;
    function Get_sysTempPath: WideString; safecall;
    function Get_HostFingerprint: WideString; safecall;
    function Get_ProtocolError: WideString; safecall;
    procedure CopyToRemote(const localPath: WideString; const remotePath: WideString); safecall;
    procedure CopyToLocal(const remotePath: WideString; const localPath: WideString); safecall;
    property Version: WideString read Get_Version;
    property Build: WideString read Get_Build;
    property Module: WideString read Get_Module;
    property LicenseStatus: WideString read Get_LicenseStatus;
    property Reserved: Integer write Set_Reserved;
    property LastError: Integer read Get_LastError;
    property LogFile: WideString read Get_LogFile write Set_LogFile;
    property LicenseKey: WideString read Get_LicenseKey;
    property Host: WideString read Get_Host write Set_Host;
    property Port: Integer read Get_Port write Set_Port;
    property UserName: WideString read Get_UserName write Set_UserName;
    property Password: WideString read Get_Password write Set_Password;
    property PrivateKeyFile: WideString read Get_PrivateKeyFile write Set_PrivateKeyFile;
    property AcceptHostKey: WordBool read Get_AcceptHostKey write Set_AcceptHostKey;
    property Recursive: WordBool read Get_Recursive write Set_Recursive;
    property PreserveAttributes: WordBool read Get_PreserveAttributes write Set_PreserveAttributes;
    property Compression: WordBool read Get_Compression write Set_Compression;
    property sysTempPath: WideString read Get_sysTempPath write Set_sysTempPath;
    property HostFingerprint: WideString read Get_HostFingerprint;
    property ProtocolError: WideString read Get_ProtocolError;
  end;

// *********************************************************************//
// DispIntf:  IScpDisp
// Flags:     (4544) Dual NonExtensible OleAutomation Dispatchable
// GUID:      {4116F2EA-0122-496A-A70E-AFFD0A9B5F6A}
// *********************************************************************//
  IScpDisp = dispinterface
    ['{4116F2EA-0122-496A-A70E-AFFD0A9B5F6A}']
    property Version: WideString readonly dispid 1;
    property Build: WideString readonly dispid 2;
    property Module: WideString readonly dispid 3;
    property LicenseStatus: WideString readonly dispid 4;
    property Reserved: Integer writeonly dispid 5;
    property LastError: Integer readonly dispid 6;
    property LogFile: WideString dispid 7;
    property LicenseKey: WideString readonly dispid 8;
    procedure Clear; dispid 20;
    function GetErrorDescription(newVal: Integer): WideString; dispid 21;
    procedure Activate(const bstrRegKey: WideString; bPersistent: WordBool); dispid 22;
    procedure Sleep(lMilliSeconds: Integer); dispid 23;
    property Host: WideString dispid 101;
    property Port: Integer dispid 102;
    property UserName: WideString dispid 103;
    property Password: WideString dispid 104;
    property PrivateKeyFile: WideString dispid 105;
    property AcceptHostKey: WordBool dispid 106;
    property Recursive: WordBool dispid 107;
    property PreserveAttributes: WordBool dispid 108;
    property Compression: WordBool dispid 109;
    property sysTempPath: WideString dispid 110;
    property HostFingerprint: WideString readonly dispid 120;
    property ProtocolError: WideString readonly dispid 121;
    procedure CopyToRemote(const localPath: WideString; const remotePath: WideString); dispid 201;
    procedure CopyToLocal(const remotePath: WideString; const localPath: WideString); dispid 202;
  end;

// *********************************************************************//
// Interface: ISFtp
// Flags:     (4544) Dual NonExtensible OleAutomation Dispatchable
// GUID:      {06B4D9C1-3A2D-43C3-8E1E-72BD1EBA6B4D}
// *********************************************************************//
  ISFtp = interface(IDispatch)
    ['{06B4D9C1-3A2D-43C3-8E1E-72BD1EBA6B4D}']
    function Get_Version: WideString; safecall;
    function Get_Build: WideString; safecall;
    function Get_Module: WideString; safecall;
    function Get_LicenseStatus: WideString; safecall;
    procedure Set_Reserved(Param1: Integer); safecall;
    function Get_LastError: Integer; safecall;
    function Get_LogFile: WideString; safecall;
    procedure Set_LogFile(const pVal: WideString); safecall;
    function Get_LicenseKey: WideString; safecall;
    procedure Clear; safecall;
    function GetErrorDescription(newVal: Integer): WideString; safecall;
    procedure Activate(const bstrRegKey: WideString; bPersistent: WordBool); safecall;
    procedure Sleep(lMilliSeconds: Integer); safecall;
    function Get_Host: WideString; safecall;
    procedure Set_Host(const pVal: WideString); safecall;
    function Get_Port: Integer; safecall;
    procedure Set_Port(pVal: Integer); safecall;
    function Get_UserName: WideString; safecall;
    procedure Set_UserName(const pVal: WideString); safecall;
    function Get_Password: WideString; safecall;
    procedure Set_Password(const pVal: WideString); safecall;
    function Get_PrivateKeyFile: WideString; safecall;
    procedure Set_PrivateKeyFile(const pVal: WideString); safecall;
    function Get_AcceptHostKey: WordBool; safecall;
    procedure Set_AcceptHostKey(pVal: WordBool); safecall;
    function Get_Compression: WordBool; safecall;
    procedure Set_Compression(pVal: WordBool); safecall;
    procedure Set_sysTempPath(const pVal: WideString); safecall;
    function Get_sysTempPath: WideString; safecall;
    function Get_HostFingerprint: WideString; safecall;
    function Get_ProtocolError: WideString; safecall;
    procedure Connect; safecall;
    procedure Disconnect; safecall;
    function GetCurrentDir: WideString; safecall;
    procedure ChangeDir(const bstrNewDir: WideString); safecall;
    procedure CreateDir(const bstrDirName: WideString); safecall;
    procedure RenameDir(const bstrOldName: WideString; const bstrNewName: WideString); safecall;
    procedure DeleteDir(const bstrDirName: WideString); safecall;
    function FindFile(const bstrSearch: WideString): OleVariant; safecall;
    function FindFirstFile(const bstrSearch: WideString): OleVariant; safecall;
    function FindNextFile: OleVariant; safecall;
    procedure GetFile(const bstrRemotePath: WideString; const bstrLocalPath: WideString); safecall;
    procedure PutFile(const bstrLocalPath: WideString; const bstrRemotePath: WideString); safecall;
    procedure RenameFile(const bstrOldFile: WideString; const bstrNewFile: WideString); safecall;
    procedure DeleteFile(const bstrFileName: WideString); safecall;
    property Version: WideString read Get_Version;
    property Build: WideString read Get_Build;
    property Module: WideString read Get_Module;
    property LicenseStatus: WideString read Get_LicenseStatus;
    property Reserved: Integer write Set_Reserved;
    property LastError: Integer read Get_LastError;
    property LogFile: WideString read Get_LogFile write Set_LogFile;
    property LicenseKey: WideString read Get_LicenseKey;
    property Host: WideString read Get_Host write Set_Host;
    property Port: Integer read Get_Port write Set_Port;
    property UserName: WideString read Get_UserName write Set_UserName;
    property Password: WideString read Get_Password write Set_Password;
    property PrivateKeyFile: WideString read Get_PrivateKeyFile write Set_PrivateKeyFile;
    property AcceptHostKey: WordBool read Get_AcceptHostKey write Set_AcceptHostKey;
    property Compression: WordBool read Get_Compression write Set_Compression;
    property sysTempPath: WideString read Get_sysTempPath write Set_sysTempPath;
    property HostFingerprint: WideString read Get_HostFingerprint;
    property ProtocolError: WideString read Get_ProtocolError;
  end;

// *********************************************************************//
// DispIntf:  ISFtpDisp
// Flags:     (4544) Dual NonExtensible OleAutomation Dispatchable
// GUID:      {06B4D9C1-3A2D-43C3-8E1E-72BD1EBA6B4D}
// *********************************************************************//
  ISFtpDisp = dispinterface
    ['{06B4D9C1-3A2D-43C3-8E1E-72BD1EBA6B4D}']
    property Version: WideString readonly dispid 1;
    property Build: WideString readonly dispid 2;
    property Module: WideString readonly dispid 3;
    property LicenseStatus: WideString readonly dispid 4;
    property Reserved: Integer writeonly dispid 5;
    property LastError: Integer readonly dispid 6;
    property LogFile: WideString dispid 7;
    property LicenseKey: WideString readonly dispid 8;
    procedure Clear; dispid 20;
    function GetErrorDescription(newVal: Integer): WideString; dispid 21;
    procedure Activate(const bstrRegKey: WideString; bPersistent: WordBool); dispid 22;
    procedure Sleep(lMilliSeconds: Integer); dispid 23;
    property Host: WideString dispid 101;
    property Port: Integer dispid 102;
    property UserName: WideString dispid 103;
    property Password: WideString dispid 104;
    property PrivateKeyFile: WideString dispid 105;
    property AcceptHostKey: WordBool dispid 106;
    property Compression: WordBool dispid 107;
    property sysTempPath: WideString dispid 108;
    property HostFingerprint: WideString readonly dispid 120;
    property ProtocolError: WideString readonly dispid 121;
    procedure Connect; dispid 201;
    procedure Disconnect; dispid 202;
    function GetCurrentDir: WideString; dispid 203;
    procedure ChangeDir(const bstrNewDir: WideString); dispid 204;
    procedure CreateDir(const bstrDirName: WideString); dispid 205;
    procedure RenameDir(const bstrOldName: WideString; const bstrNewName: WideString); dispid 206;
    procedure DeleteDir(const bstrDirName: WideString); dispid 207;
    function FindFile(const bstrSearch: WideString): OleVariant; dispid 208;
    function FindFirstFile(const bstrSearch: WideString): OleVariant; dispid 209;
    function FindNextFile: OleVariant; dispid 210;
    procedure GetFile(const bstrRemotePath: WideString; const bstrLocalPath: WideString); dispid 211;
    procedure PutFile(const bstrLocalPath: WideString; const bstrRemotePath: WideString); dispid 212;
    procedure RenameFile(const bstrOldFile: WideString; const bstrNewFile: WideString); dispid 213;
    procedure DeleteFile(const bstrFileName: WideString); dispid 214;
  end;

// *********************************************************************//
// Interface: ISFtpFile
// Flags:     (4544) Dual NonExtensible OleAutomation Dispatchable
// GUID:      {5479FBF8-C8BD-4DC0-9967-AAA27F768994}
// *********************************************************************//
  ISFtpFile = interface(IDispatch)
    ['{5479FBF8-C8BD-4DC0-9967-AAA27F768994}']
    function Get_Name: WideString; safecall;
    procedure Set_Name(const pVal: WideString); safecall;
    function Get_SizeBytes: Integer; safecall;
    procedure Set_SizeBytes(pVal: Integer); safecall;
    function Get_SizeBytesHigh: Integer; safecall;
    procedure Set_SizeBytesHigh(pVal: Integer); safecall;
    function Get_SizeKB: Integer; safecall;
    function Get_SizeMB: Integer; safecall;
    function Get_IsDirectory: WordBool; safecall;
    procedure Set_IsDirectory(pVal: WordBool); safecall;
    function Get_Date: WideString; safecall;
    procedure Set_Date(const pVal: WideString); safecall;
    function Get_DateSeconds: Integer; safecall;
    procedure Set_DateSeconds(pVal: Integer); safecall;
    procedure Clear; safecall;
    property Name: WideString read Get_Name write Set_Name;
    property SizeBytes: Integer read Get_SizeBytes write Set_SizeBytes;
    property SizeBytesHigh: Integer read Get_SizeBytesHigh write Set_SizeBytesHigh;
    property SizeKB: Integer read Get_SizeKB;
    property SizeMB: Integer read Get_SizeMB;
    property IsDirectory: WordBool read Get_IsDirectory write Set_IsDirectory;
    property Date: WideString read Get_Date write Set_Date;
    property DateSeconds: Integer read Get_DateSeconds write Set_DateSeconds;
  end;

// *********************************************************************//
// DispIntf:  ISFtpFileDisp
// Flags:     (4544) Dual NonExtensible OleAutomation Dispatchable
// GUID:      {5479FBF8-C8BD-4DC0-9967-AAA27F768994}
// *********************************************************************//
  ISFtpFileDisp = dispinterface
    ['{5479FBF8-C8BD-4DC0-9967-AAA27F768994}']
    property Name: WideString dispid 1;
    property SizeBytes: Integer dispid 2;
    property SizeBytesHigh: Integer dispid 3;
    property SizeKB: Integer readonly dispid 4;
    property SizeMB: Integer readonly dispid 5;
    property IsDirectory: WordBool dispid 6;
    property Date: WideString dispid 7;
    property DateSeconds: Integer dispid 8;
    procedure Clear; dispid 100;
  end;

// *********************************************************************//
// Interface: IHttpEx
// Flags:     (4544) Dual NonExtensible OleAutomation Dispatchable
// GUID:      {805D87DC-5860-4562-BE30-802A47A2F7E0}
// *********************************************************************//
  IHttpEx = interface(IDispatch)
    ['{805D87DC-5860-4562-BE30-802A47A2F7E0}']
    function Get_Version: WideString; safecall;
    function Get_Build: WideString; safecall;
    function Get_Module: WideString; safecall;
    function Get_LicenseStatus: WideString; safecall;
    procedure Set_Reserved(Param1: Integer); safecall;
    function Get_LastError: Integer; safecall;
    function Get_LogFile: WideString; safecall;
    procedure Set_LogFile(const pVal: WideString); safecall;
    function Get_LicenseKey: WideString; safecall;
    procedure Clear; safecall;
    function GetErrorDescription(lErrorCode: Integer): WideString; safecall;
    procedure Activate(const bstrKey: WideString; bPersistent: WordBool); safecall;
    procedure Sleep(lTime: Integer); safecall;
    function Get_HttpLibrary: WideString; safecall;
    procedure Set_HttpLibrary(const pVal: WideString); safecall;
    function Get_WebAccount: WideString; safecall;
    procedure Set_WebAccount(const pVal: WideString); safecall;
    function Get_WebPassword: WideString; safecall;
    procedure Set_WebPassword(const pVal: WideString); safecall;
    function Get_ProxyServer: WideString; safecall;
    procedure Set_ProxyServer(const pVal: WideString); safecall;
    function Get_ProxyAccount: WideString; safecall;
    procedure Set_ProxyAccount(const pVal: WideString); safecall;
    function Get_ProxyPassword: WideString; safecall;
    procedure Set_ProxyPassword(const pVal: WideString); safecall;
    function Get_ConnectionPoolSize: Integer; safecall;
    procedure Set_ConnectionPoolSize(pVal: Integer); safecall;
    function Get_ConnectionExpireTimeout: Integer; safecall;
    procedure Set_ConnectionExpireTimeout(pVal: Integer); safecall;
    function Get_RequestTimeout: Integer; safecall;
    procedure Set_RequestTimeout(pVal: Integer); safecall;
    function Get_ResponseTimeout: Integer; safecall;
    procedure Set_ResponseTimeout(pVal: Integer); safecall;
    function Get_UserAgent: WideString; safecall;
    procedure Set_UserAgent(const pVal: WideString); safecall;
    function Get_FollowRedirect: WordBool; safecall;
    procedure Set_FollowRedirect(pVal: WordBool); safecall;
    function Get_MaxRedirectionDepth: Integer; safecall;
    procedure Set_MaxRedirectionDepth(pVal: Integer); safecall;
    function Get_LastResponseCode: Integer; safecall;
    function Get(const bstrUrl: WideString): WideString; safecall;
    function Post(const bstrUrl: WideString; const bstrData: WideString): WideString; safecall;
    function Head(const bstrUrl: WideString): WideString; safecall;
    procedure GetFile(const vsUrl: WideString; const bstrFileName: WideString); safecall;
    procedure SetHeader(const bstrHeader: WideString; const bstrValue: WideString); safecall;
    function UrlEncode(const bstrIn: WideString): WideString; safecall;
    property Version: WideString read Get_Version;
    property Build: WideString read Get_Build;
    property Module: WideString read Get_Module;
    property LicenseStatus: WideString read Get_LicenseStatus;
    property Reserved: Integer write Set_Reserved;
    property LastError: Integer read Get_LastError;
    property LogFile: WideString read Get_LogFile write Set_LogFile;
    property LicenseKey: WideString read Get_LicenseKey;
    property HttpLibrary: WideString read Get_HttpLibrary write Set_HttpLibrary;
    property WebAccount: WideString read Get_WebAccount write Set_WebAccount;
    property WebPassword: WideString read Get_WebPassword write Set_WebPassword;
    property ProxyServer: WideString read Get_ProxyServer write Set_ProxyServer;
    property ProxyAccount: WideString read Get_ProxyAccount write Set_ProxyAccount;
    property ProxyPassword: WideString read Get_ProxyPassword write Set_ProxyPassword;
    property ConnectionPoolSize: Integer read Get_ConnectionPoolSize write Set_ConnectionPoolSize;
    property ConnectionExpireTimeout: Integer read Get_ConnectionExpireTimeout write Set_ConnectionExpireTimeout;
    property RequestTimeout: Integer read Get_RequestTimeout write Set_RequestTimeout;
    property ResponseTimeout: Integer read Get_ResponseTimeout write Set_ResponseTimeout;
    property UserAgent: WideString read Get_UserAgent write Set_UserAgent;
    property FollowRedirect: WordBool read Get_FollowRedirect write Set_FollowRedirect;
    property MaxRedirectionDepth: Integer read Get_MaxRedirectionDepth write Set_MaxRedirectionDepth;
    property LastResponseCode: Integer read Get_LastResponseCode;
  end;

// *********************************************************************//
// DispIntf:  IHttpExDisp
// Flags:     (4544) Dual NonExtensible OleAutomation Dispatchable
// GUID:      {805D87DC-5860-4562-BE30-802A47A2F7E0}
// *********************************************************************//
  IHttpExDisp = dispinterface
    ['{805D87DC-5860-4562-BE30-802A47A2F7E0}']
    property Version: WideString readonly dispid 1;
    property Build: WideString readonly dispid 2;
    property Module: WideString readonly dispid 3;
    property LicenseStatus: WideString readonly dispid 4;
    property Reserved: Integer writeonly dispid 5;
    property LastError: Integer readonly dispid 6;
    property LogFile: WideString dispid 7;
    property LicenseKey: WideString readonly dispid 8;
    procedure Clear; dispid 20;
    function GetErrorDescription(lErrorCode: Integer): WideString; dispid 21;
    procedure Activate(const bstrKey: WideString; bPersistent: WordBool); dispid 22;
    procedure Sleep(lTime: Integer); dispid 23;
    property HttpLibrary: WideString dispid 101;
    property WebAccount: WideString dispid 102;
    property WebPassword: WideString dispid 103;
    property ProxyServer: WideString dispid 104;
    property ProxyAccount: WideString dispid 105;
    property ProxyPassword: WideString dispid 106;
    property ConnectionPoolSize: Integer dispid 107;
    property ConnectionExpireTimeout: Integer dispid 108;
    property RequestTimeout: Integer dispid 109;
    property ResponseTimeout: Integer dispid 110;
    property UserAgent: WideString dispid 111;
    property FollowRedirect: WordBool dispid 112;
    property MaxRedirectionDepth: Integer dispid 113;
    property LastResponseCode: Integer readonly dispid 114;
    function Get(const bstrUrl: WideString): WideString; dispid 201;
    function Post(const bstrUrl: WideString; const bstrData: WideString): WideString; dispid 202;
    function Head(const bstrUrl: WideString): WideString; dispid 203;
    procedure GetFile(const vsUrl: WideString; const bstrFileName: WideString); dispid 204;
    procedure SetHeader(const bstrHeader: WideString; const bstrValue: WideString); dispid 205;
    function UrlEncode(const bstrIn: WideString): WideString; dispid 206;
  end;

// *********************************************************************//
// Interface: ITraceRoute
// Flags:     (4544) Dual NonExtensible OleAutomation Dispatchable
// GUID:      {081790B5-1D5D-4FFF-9F46-6B5F2E144BFF}
// *********************************************************************//
  ITraceRoute = interface(IDispatch)
    ['{081790B5-1D5D-4FFF-9F46-6B5F2E144BFF}']
    function Get_Version: WideString; safecall;
    function Get_Build: WideString; safecall;
    function Get_Module: WideString; safecall;
    function Get_LicenseStatus: WideString; safecall;
    procedure Set_Reserved(Param1: Integer); safecall;
    function Get_LastError: Integer; safecall;
    function Get_LogFile: WideString; safecall;
    procedure Set_LogFile(const pVal: WideString); safecall;
    function Get_LicenseKey: WideString; safecall;
    procedure Clear; safecall;
    function GetErrorDescription(ErrorCode: Integer): WideString; safecall;
    procedure Activate(const bstrRegKey: WideString; bPersistent: WordBool); safecall;
    procedure Sleep(lMilliSeconds: Integer); safecall;
    function Get_ResolveHostName: WordBool; safecall;
    procedure Set_ResolveHostName(pVal: WordBool); safecall;
    function Get_MaxHops: Integer; safecall;
    procedure Set_MaxHops(pVal: Integer); safecall;
    function Get_BufferSize: Integer; safecall;
    procedure Set_BufferSize(pVal: Integer); safecall;
    function Get_Timeout: Integer; safecall;
    procedure Set_Timeout(pVal: Integer); safecall;
    function FindFirstHop(const HostName: WideString): OleVariant; safecall;
    function FindNextHop: OleVariant; safecall;
    property Version: WideString read Get_Version;
    property Build: WideString read Get_Build;
    property Module: WideString read Get_Module;
    property LicenseStatus: WideString read Get_LicenseStatus;
    property Reserved: Integer write Set_Reserved;
    property LastError: Integer read Get_LastError;
    property LogFile: WideString read Get_LogFile write Set_LogFile;
    property LicenseKey: WideString read Get_LicenseKey;
    property ResolveHostName: WordBool read Get_ResolveHostName write Set_ResolveHostName;
    property MaxHops: Integer read Get_MaxHops write Set_MaxHops;
    property BufferSize: Integer read Get_BufferSize write Set_BufferSize;
    property Timeout: Integer read Get_Timeout write Set_Timeout;
  end;

// *********************************************************************//
// DispIntf:  ITraceRouteDisp
// Flags:     (4544) Dual NonExtensible OleAutomation Dispatchable
// GUID:      {081790B5-1D5D-4FFF-9F46-6B5F2E144BFF}
// *********************************************************************//
  ITraceRouteDisp = dispinterface
    ['{081790B5-1D5D-4FFF-9F46-6B5F2E144BFF}']
    property Version: WideString readonly dispid 1;
    property Build: WideString readonly dispid 2;
    property Module: WideString readonly dispid 3;
    property LicenseStatus: WideString readonly dispid 4;
    property Reserved: Integer writeonly dispid 5;
    property LastError: Integer readonly dispid 6;
    property LogFile: WideString dispid 7;
    property LicenseKey: WideString readonly dispid 8;
    procedure Clear; dispid 20;
    function GetErrorDescription(ErrorCode: Integer): WideString; dispid 21;
    procedure Activate(const bstrRegKey: WideString; bPersistent: WordBool); dispid 22;
    procedure Sleep(lMilliSeconds: Integer); dispid 23;
    property ResolveHostName: WordBool dispid 24;
    property MaxHops: Integer dispid 25;
    property BufferSize: Integer dispid 26;
    property Timeout: Integer dispid 27;
    function FindFirstHop(const HostName: WideString): OleVariant; dispid 201;
    function FindNextHop: OleVariant; dispid 202;
  end;

// *********************************************************************//
// Interface: ITraceHop
// Flags:     (4544) Dual NonExtensible OleAutomation Dispatchable
// GUID:      {601A723F-F66D-4129-91D5-AD1B5E9CB590}
// *********************************************************************//
  ITraceHop = interface(IDispatch)
    ['{601A723F-F66D-4129-91D5-AD1B5E9CB590}']
    function Get_Host: WideString; safecall;
    procedure Set_Host(const pVal: WideString); safecall;
    function Get_IP: WideString; safecall;
    procedure Set_IP(const pVal: WideString); safecall;
    function Get_ResponseTime: Integer; safecall;
    procedure Set_ResponseTime(pVal: Integer); safecall;
    function Get_Hop: Integer; safecall;
    procedure Set_Hop(pVal: Integer); safecall;
    procedure Clear; safecall;
    property Host: WideString read Get_Host write Set_Host;
    property IP: WideString read Get_IP write Set_IP;
    property ResponseTime: Integer read Get_ResponseTime write Set_ResponseTime;
    property Hop: Integer read Get_Hop write Set_Hop;
  end;

// *********************************************************************//
// DispIntf:  ITraceHopDisp
// Flags:     (4544) Dual NonExtensible OleAutomation Dispatchable
// GUID:      {601A723F-F66D-4129-91D5-AD1B5E9CB590}
// *********************************************************************//
  ITraceHopDisp = dispinterface
    ['{601A723F-F66D-4129-91D5-AD1B5E9CB590}']
    property Host: WideString dispid 1;
    property IP: WideString dispid 2;
    property ResponseTime: Integer dispid 3;
    property Hop: Integer dispid 4;
    procedure Clear; dispid 20;
  end;

// *********************************************************************//
// Interface: I_SnmpManager
// Flags:     (4544) Dual NonExtensible OleAutomation Dispatchable
// GUID:      {F46A9413-336E-4E18-A2C3-CD4068C25A0A}
// *********************************************************************//
  I_SnmpManager = interface(IDispatch)
    ['{F46A9413-336E-4E18-A2C3-CD4068C25A0A}']
    function Get_Version: WideString; safecall;
    function Get_Build: WideString; safecall;
    function Get_Module: WideString; safecall;
    function Get_LicenseStatus: WideString; safecall;
    procedure Set_Reserved(Param1: Integer); safecall;
    function Get_LastError: Integer; safecall;
    function Get_LogFile: WideString; safecall;
    procedure Set_LogFile(const pVal: WideString); safecall;
    procedure Clear; safecall;
    function GetErrorDescription(Error: Integer): WideString; safecall;
    procedure Activate(const bstrRegKey: WideString; bPersistent: Integer); safecall;
    procedure Sleep(newVal: Integer); safecall;
    function Get_ProtocolVersion: Integer; safecall;
    procedure Set_ProtocolVersion(pVal: Integer); safecall;
    function Get_Timeout: Integer; safecall;
    procedure Set_Timeout(pVal: Integer); safecall;
    procedure Initialize; safecall;
    procedure Shutdown; safecall;
    procedure Open(const Agent: WideString; const Community: WideString; Port: Integer); safecall;
    procedure Close; safecall;
    function Get(const OID: WideString): OleVariant; safecall;
    function GetNext: OleVariant; safecall;
    procedure Set_(var pVal: OleVariant); safecall;
    procedure LoadMibFile(const bstrMibFile: WideString); safecall;
    property Version: WideString read Get_Version;
    property Build: WideString read Get_Build;
    property Module: WideString read Get_Module;
    property LicenseStatus: WideString read Get_LicenseStatus;
    property Reserved: Integer write Set_Reserved;
    property LastError: Integer read Get_LastError;
    property LogFile: WideString read Get_LogFile write Set_LogFile;
    property ProtocolVersion: Integer read Get_ProtocolVersion write Set_ProtocolVersion;
    property Timeout: Integer read Get_Timeout write Set_Timeout;
  end;

// *********************************************************************//
// DispIntf:  I_SnmpManagerDisp
// Flags:     (4544) Dual NonExtensible OleAutomation Dispatchable
// GUID:      {F46A9413-336E-4E18-A2C3-CD4068C25A0A}
// *********************************************************************//
  I_SnmpManagerDisp = dispinterface
    ['{F46A9413-336E-4E18-A2C3-CD4068C25A0A}']
    property Version: WideString readonly dispid 1;
    property Build: WideString readonly dispid 2;
    property Module: WideString readonly dispid 3;
    property LicenseStatus: WideString readonly dispid 4;
    property Reserved: Integer writeonly dispid 5;
    property LastError: Integer readonly dispid 6;
    property LogFile: WideString dispid 7;
    procedure Clear; dispid 20;
    function GetErrorDescription(Error: Integer): WideString; dispid 21;
    procedure Activate(const bstrRegKey: WideString; bPersistent: Integer); dispid 22;
    procedure Sleep(newVal: Integer); dispid 23;
    property ProtocolVersion: Integer dispid 101;
    property Timeout: Integer dispid 102;
    procedure Initialize; dispid 201;
    procedure Shutdown; dispid 202;
    procedure Open(const Agent: WideString; const Community: WideString; Port: Integer); dispid 210;
    procedure Close; dispid 211;
    function Get(const OID: WideString): OleVariant; dispid 220;
    function GetNext: OleVariant; dispid 221;
    procedure Set_(var pVal: OleVariant); dispid 222;
    procedure LoadMibFile(const bstrMibFile: WideString); dispid 223;
  end;

// *********************************************************************//
// Interface: I_SnmpTrapManager
// Flags:     (4544) Dual NonExtensible OleAutomation Dispatchable
// GUID:      {07316FD5-B0E6-4A17-9015-9ABC7FECAEB4}
// *********************************************************************//
  I_SnmpTrapManager = interface(IDispatch)
    ['{07316FD5-B0E6-4A17-9015-9ABC7FECAEB4}']
    function Get_Version: WideString; safecall;
    function Get_Build: WideString; safecall;
    function Get_Module: WideString; safecall;
    function Get_LicenseStatus: WideString; safecall;
    procedure Set_Reserved(Param1: Integer); safecall;
    function Get_LastError: Integer; safecall;
    function Get_LogFile: WideString; safecall;
    procedure Set_LogFile(const pVal: WideString); safecall;
    procedure Clear; safecall;
    function GetErrorDescription(Error: Integer): WideString; safecall;
    procedure Activate(const bstrRegKey: WideString; bPersistent: Integer); safecall;
    procedure Sleep(newVal: Integer); safecall;
    function Get_ProtocolVersion: Integer; safecall;
    procedure Set_ProtocolVersion(pVal: Integer); safecall;
    procedure Initialize; safecall;
    procedure Shutdown; safecall;
    procedure StartListening(const Community: WideString; Port: Integer); safecall;
    procedure StopListening; safecall;
    function GetFirstTrap: OleVariant; safecall;
    function GetNextTrap: OleVariant; safecall;
    procedure Send(var pVal: OleVariant); safecall;
    procedure LoadMibFile(const bstrMibFile: WideString); safecall;
    property Version: WideString read Get_Version;
    property Build: WideString read Get_Build;
    property Module: WideString read Get_Module;
    property LicenseStatus: WideString read Get_LicenseStatus;
    property Reserved: Integer write Set_Reserved;
    property LastError: Integer read Get_LastError;
    property LogFile: WideString read Get_LogFile write Set_LogFile;
    property ProtocolVersion: Integer read Get_ProtocolVersion write Set_ProtocolVersion;
  end;

// *********************************************************************//
// DispIntf:  I_SnmpTrapManagerDisp
// Flags:     (4544) Dual NonExtensible OleAutomation Dispatchable
// GUID:      {07316FD5-B0E6-4A17-9015-9ABC7FECAEB4}
// *********************************************************************//
  I_SnmpTrapManagerDisp = dispinterface
    ['{07316FD5-B0E6-4A17-9015-9ABC7FECAEB4}']
    property Version: WideString readonly dispid 1;
    property Build: WideString readonly dispid 2;
    property Module: WideString readonly dispid 3;
    property LicenseStatus: WideString readonly dispid 4;
    property Reserved: Integer writeonly dispid 5;
    property LastError: Integer readonly dispid 6;
    property LogFile: WideString dispid 7;
    procedure Clear; dispid 20;
    function GetErrorDescription(Error: Integer): WideString; dispid 21;
    procedure Activate(const bstrRegKey: WideString; bPersistent: Integer); dispid 22;
    procedure Sleep(newVal: Integer); dispid 23;
    property ProtocolVersion: Integer dispid 101;
    procedure Initialize; dispid 201;
    procedure Shutdown; dispid 202;
    procedure StartListening(const Community: WideString; Port: Integer); dispid 210;
    procedure StopListening; dispid 211;
    function GetFirstTrap: OleVariant; dispid 220;
    function GetNextTrap: OleVariant; dispid 221;
    procedure Send(var pVal: OleVariant); dispid 230;
    procedure LoadMibFile(const bstrMibFile: WideString); dispid 240;
  end;

// *********************************************************************//
// Interface: IVMware
// Flags:     (4544) Dual NonExtensible OleAutomation Dispatchable
// GUID:      {EB3954ED-BAF8-4623-9B38-811C6894E87F}
// *********************************************************************//
  IVMware = interface(IDispatch)
    ['{EB3954ED-BAF8-4623-9B38-811C6894E87F}']
    function Get_Version: WideString; safecall;
    function Get_Build: WideString; safecall;
    function Get_Module: WideString; safecall;
    function Get_LicenseStatus: WideString; safecall;
    procedure Set_Reserved(Param1: Integer); safecall;
    function Get_LastError: Integer; safecall;
    function Get_LogFile: WideString; safecall;
    procedure Set_LogFile(const pVal: WideString); safecall;
    function Get_LicenseKey: WideString; safecall;
    procedure Clear; safecall;
    function GetErrorDescription(lError: Integer): WideString; safecall;
    procedure Activate(const bstrKey: WideString; bPersistent: WordBool); safecall;
    procedure Sleep(newVal: Integer); safecall;
    function Get_Server: WideString; safecall;
    procedure Set_Server(const pVal: WideString); safecall;
    function Get_ServerAccount: WideString; safecall;
    procedure Set_ServerAccount(const pVal: WideString); safecall;
    function Get_ServerPassword: WideString; safecall;
    procedure Set_ServerPassword(const pVal: WideString); safecall;
    function Get_ProxyServer: WideString; safecall;
    procedure Set_ProxyServer(const pVal: WideString); safecall;
    function Get_ProxyAccount: WideString; safecall;
    procedure Set_ProxyAccount(const pVal: WideString); safecall;
    function Get_ProxyPassword: WideString; safecall;
    procedure Set_ProxyPassword(const pVal: WideString); safecall;
    function Get_RequestTimeout: Integer; safecall;
    procedure Set_RequestTimeout(pVal: Integer); safecall;
    procedure Initialize; safecall;
    procedure Shutdown; safecall;
    procedure Connect; safecall;
    procedure Disconnect; safecall;
    function GetFirstVirtualMachine: WideString; safecall;
    function GetNextVirtualMachine: WideString; safecall;
    function GetOperatingSystem(const bstrObject: WideString): WideString; safecall;
    function GetFirstCounterID: Integer; safecall;
    function GetNextCounterID: Integer; safecall;
    function GetCounterDescription(lCounter: Integer): WideString; safecall;
    function GetCounterUnits(lCounter: Integer): WideString; safecall;
    function IsContextAllowed(lCounterID: Integer): WordBool; safecall;
    function GetPerfData(const bstrObject: WideString; lCounterID: Integer; 
                         const bstrContext: WideString): Integer; safecall;
    function TranslatePerfData(lCounterID: Integer; lValue: Integer): WideString; safecall;
    property Version: WideString read Get_Version;
    property Build: WideString read Get_Build;
    property Module: WideString read Get_Module;
    property LicenseStatus: WideString read Get_LicenseStatus;
    property Reserved: Integer write Set_Reserved;
    property LastError: Integer read Get_LastError;
    property LogFile: WideString read Get_LogFile write Set_LogFile;
    property LicenseKey: WideString read Get_LicenseKey;
    property Server: WideString read Get_Server write Set_Server;
    property ServerAccount: WideString read Get_ServerAccount write Set_ServerAccount;
    property ServerPassword: WideString read Get_ServerPassword write Set_ServerPassword;
    property ProxyServer: WideString read Get_ProxyServer write Set_ProxyServer;
    property ProxyAccount: WideString read Get_ProxyAccount write Set_ProxyAccount;
    property ProxyPassword: WideString read Get_ProxyPassword write Set_ProxyPassword;
    property RequestTimeout: Integer read Get_RequestTimeout write Set_RequestTimeout;
  end;

// *********************************************************************//
// DispIntf:  IVMwareDisp
// Flags:     (4544) Dual NonExtensible OleAutomation Dispatchable
// GUID:      {EB3954ED-BAF8-4623-9B38-811C6894E87F}
// *********************************************************************//
  IVMwareDisp = dispinterface
    ['{EB3954ED-BAF8-4623-9B38-811C6894E87F}']
    property Version: WideString readonly dispid 1;
    property Build: WideString readonly dispid 2;
    property Module: WideString readonly dispid 3;
    property LicenseStatus: WideString readonly dispid 4;
    property Reserved: Integer writeonly dispid 5;
    property LastError: Integer readonly dispid 6;
    property LogFile: WideString dispid 7;
    property LicenseKey: WideString readonly dispid 8;
    procedure Clear; dispid 20;
    function GetErrorDescription(lError: Integer): WideString; dispid 21;
    procedure Activate(const bstrKey: WideString; bPersistent: WordBool); dispid 22;
    procedure Sleep(newVal: Integer); dispid 23;
    property Server: WideString dispid 101;
    property ServerAccount: WideString dispid 102;
    property ServerPassword: WideString dispid 103;
    property ProxyServer: WideString dispid 104;
    property ProxyAccount: WideString dispid 105;
    property ProxyPassword: WideString dispid 106;
    property RequestTimeout: Integer dispid 107;
    procedure Initialize; dispid 200;
    procedure Shutdown; dispid 202;
    procedure Connect; dispid 210;
    procedure Disconnect; dispid 211;
    function GetFirstVirtualMachine: WideString; dispid 215;
    function GetNextVirtualMachine: WideString; dispid 216;
    function GetOperatingSystem(const bstrObject: WideString): WideString; dispid 217;
    function GetFirstCounterID: Integer; dispid 218;
    function GetNextCounterID: Integer; dispid 219;
    function GetCounterDescription(lCounter: Integer): WideString; dispid 220;
    function GetCounterUnits(lCounter: Integer): WideString; dispid 221;
    function IsContextAllowed(lCounterID: Integer): WordBool; dispid 222;
    function GetPerfData(const bstrObject: WideString; lCounterID: Integer; 
                         const bstrContext: WideString): Integer; dispid 230;
    function TranslatePerfData(lCounterID: Integer; lValue: Integer): WideString; dispid 231;
  end;

// *********************************************************************//
// Interface: IXen
// Flags:     (4544) Dual NonExtensible OleAutomation Dispatchable
// GUID:      {4D219C63-9EEC-4419-8764-FFC69299B22C}
// *********************************************************************//
  IXen = interface(IDispatch)
    ['{4D219C63-9EEC-4419-8764-FFC69299B22C}']
    function Get_Version: WideString; safecall;
    function Get_Build: WideString; safecall;
    function Get_Module: WideString; safecall;
    function Get_LicenseStatus: WideString; safecall;
    procedure Set_Reserved(Param1: Integer); safecall;
    function Get_LastError: Integer; safecall;
    function Get_LogFile: WideString; safecall;
    procedure Set_LogFile(const pVal: WideString); safecall;
    function Get_LicenseKey: WideString; safecall;
    procedure Clear; safecall;
    function GetErrorDescription(lError: Integer): WideString; safecall;
    procedure Activate(const bstrKey: WideString; bPersistent: WordBool); safecall;
    procedure Sleep(newVal: Integer); safecall;
    function Get_Server: WideString; safecall;
    procedure Set_Server(const pVal: WideString); safecall;
    function Get_ServerAccount: WideString; safecall;
    procedure Set_ServerAccount(const pVal: WideString); safecall;
    function Get_ServerPassword: WideString; safecall;
    procedure Set_ServerPassword(const pVal: WideString); safecall;
    function Get_ProxyServer: WideString; safecall;
    procedure Set_ProxyServer(const pVal: WideString); safecall;
    function Get_ProxyAccount: WideString; safecall;
    procedure Set_ProxyAccount(const pVal: WideString); safecall;
    function Get_ProxyPassword: WideString; safecall;
    procedure Set_ProxyPassword(const pVal: WideString); safecall;
    function Get_RequestTimeout: Integer; safecall;
    procedure Set_RequestTimeout(pVal: Integer); safecall;
    procedure Initialize; safecall;
    procedure Shutdown; safecall;
    procedure Connect; safecall;
    procedure Disconnect; safecall;
    function GetFirstVirtualMachine: WideString; safecall;
    function GetNextVirtualMachine: WideString; safecall;
    function GetOperatingSystem(const bstrObject: WideString): WideString; safecall;
    function GetFirstCounterID: Integer; safecall;
    function GetNextCounterID: Integer; safecall;
    function GetCounterDescription(lCounter: Integer): WideString; safecall;
    function GetCounterUnits(lCounter: Integer): WideString; safecall;
    function IsContextAllowed(lCounterID: Integer): WordBool; safecall;
    function GetPerfData(const bstrObject: WideString; lCounterID: Integer; 
                         const bstrContext: WideString): Integer; safecall;
    function TranslatePerfData(lCounterID: Integer; lValue: Integer): WideString; safecall;
    property Version: WideString read Get_Version;
    property Build: WideString read Get_Build;
    property Module: WideString read Get_Module;
    property LicenseStatus: WideString read Get_LicenseStatus;
    property Reserved: Integer write Set_Reserved;
    property LastError: Integer read Get_LastError;
    property LogFile: WideString read Get_LogFile write Set_LogFile;
    property LicenseKey: WideString read Get_LicenseKey;
    property Server: WideString read Get_Server write Set_Server;
    property ServerAccount: WideString read Get_ServerAccount write Set_ServerAccount;
    property ServerPassword: WideString read Get_ServerPassword write Set_ServerPassword;
    property ProxyServer: WideString read Get_ProxyServer write Set_ProxyServer;
    property ProxyAccount: WideString read Get_ProxyAccount write Set_ProxyAccount;
    property ProxyPassword: WideString read Get_ProxyPassword write Set_ProxyPassword;
    property RequestTimeout: Integer read Get_RequestTimeout write Set_RequestTimeout;
  end;

// *********************************************************************//
// DispIntf:  IXenDisp
// Flags:     (4544) Dual NonExtensible OleAutomation Dispatchable
// GUID:      {4D219C63-9EEC-4419-8764-FFC69299B22C}
// *********************************************************************//
  IXenDisp = dispinterface
    ['{4D219C63-9EEC-4419-8764-FFC69299B22C}']
    property Version: WideString readonly dispid 1;
    property Build: WideString readonly dispid 2;
    property Module: WideString readonly dispid 3;
    property LicenseStatus: WideString readonly dispid 4;
    property Reserved: Integer writeonly dispid 5;
    property LastError: Integer readonly dispid 6;
    property LogFile: WideString dispid 7;
    property LicenseKey: WideString readonly dispid 8;
    procedure Clear; dispid 20;
    function GetErrorDescription(lError: Integer): WideString; dispid 21;
    procedure Activate(const bstrKey: WideString; bPersistent: WordBool); dispid 22;
    procedure Sleep(newVal: Integer); dispid 23;
    property Server: WideString dispid 101;
    property ServerAccount: WideString dispid 102;
    property ServerPassword: WideString dispid 103;
    property ProxyServer: WideString dispid 104;
    property ProxyAccount: WideString dispid 105;
    property ProxyPassword: WideString dispid 106;
    property RequestTimeout: Integer dispid 107;
    procedure Initialize; dispid 200;
    procedure Shutdown; dispid 202;
    procedure Connect; dispid 210;
    procedure Disconnect; dispid 211;
    function GetFirstVirtualMachine: WideString; dispid 215;
    function GetNextVirtualMachine: WideString; dispid 216;
    function GetOperatingSystem(const bstrObject: WideString): WideString; dispid 217;
    function GetFirstCounterID: Integer; dispid 218;
    function GetNextCounterID: Integer; dispid 219;
    function GetCounterDescription(lCounter: Integer): WideString; dispid 220;
    function GetCounterUnits(lCounter: Integer): WideString; dispid 221;
    function IsContextAllowed(lCounterID: Integer): WordBool; dispid 222;
    function GetPerfData(const bstrObject: WideString; lCounterID: Integer; 
                         const bstrContext: WideString): Integer; dispid 230;
    function TranslatePerfData(lCounterID: Integer; lValue: Integer): WideString; dispid 231;
  end;

// *********************************************************************//
// The Class CoRSh provides a Create and CreateRemote method to          
// create instances of the default interface IRSh exposed by              
// the CoClass RSh. The functions are intended to be used by             
// clients wishing to automate the CoClass objects exposed by the         
// server of this typelibrary.                                            
// *********************************************************************//
  CoRSh = class
    class function Create: IRSh;
    class function CreateRemote(const MachineName: string): IRSh;
  end;

// *********************************************************************//
// The Class CoNtp provides a Create and CreateRemote method to          
// create instances of the default interface INtp exposed by              
// the CoClass Ntp. The functions are intended to be used by             
// clients wishing to automate the CoClass objects exposed by the         
// server of this typelibrary.                                            
// *********************************************************************//
  CoNtp = class
    class function Create: INtp;
    class function CreateRemote(const MachineName: string): INtp;
  end;

// *********************************************************************//
// The Class CoWOL provides a Create and CreateRemote method to          
// create instances of the default interface IWOL exposed by              
// the CoClass WOL. The functions are intended to be used by             
// clients wishing to automate the CoClass objects exposed by the         
// server of this typelibrary.                                            
// *********************************************************************//
  CoWOL = class
    class function Create: IWOL;
    class function CreateRemote(const MachineName: string): IWOL;
  end;

// *********************************************************************//
// The Class CoIcmp provides a Create and CreateRemote method to          
// create instances of the default interface IIcmp exposed by              
// the CoClass Icmp. The functions are intended to be used by             
// clients wishing to automate the CoClass objects exposed by the         
// server of this typelibrary.                                            
// *********************************************************************//
  CoIcmp = class
    class function Create: IIcmp;
    class function CreateRemote(const MachineName: string): IIcmp;
  end;

// *********************************************************************//
// The Class CoNwConstants provides a Create and CreateRemote method to          
// create instances of the default interface INwConstants exposed by              
// the CoClass NwConstants. The functions are intended to be used by             
// clients wishing to automate the CoClass objects exposed by the         
// server of this typelibrary.                                            
// *********************************************************************//
  CoNwConstants = class
    class function Create: INwConstants;
    class function CreateRemote(const MachineName: string): INwConstants;
  end;

// *********************************************************************//
// The Class CoSnmpManager provides a Create and CreateRemote method to          
// create instances of the default interface ISnmpManager exposed by              
// the CoClass SnmpManager. The functions are intended to be used by             
// clients wishing to automate the CoClass objects exposed by the         
// server of this typelibrary.                                            
// *********************************************************************//
  CoSnmpManager = class
    class function Create: ISnmpManager;
    class function CreateRemote(const MachineName: string): ISnmpManager;
  end;

// *********************************************************************//
// The Class CoSnmpTrap provides a Create and CreateRemote method to          
// create instances of the default interface ISnmpTrap exposed by              
// the CoClass SnmpTrap. The functions are intended to be used by             
// clients wishing to automate the CoClass objects exposed by the         
// server of this typelibrary.                                            
// *********************************************************************//
  CoSnmpTrap = class
    class function Create: ISnmpTrap;
    class function CreateRemote(const MachineName: string): ISnmpTrap;
  end;

// *********************************************************************//
// The Class CoSnmpTrapManager provides a Create and CreateRemote method to          
// create instances of the default interface ISnmpTrapManager exposed by              
// the CoClass SnmpTrapManager. The functions are intended to be used by             
// clients wishing to automate the CoClass objects exposed by the         
// server of this typelibrary.                                            
// *********************************************************************//
  CoSnmpTrapManager = class
    class function Create: ISnmpTrapManager;
    class function CreateRemote(const MachineName: string): ISnmpTrapManager;
  end;

// *********************************************************************//
// The Class CoFtpServer provides a Create and CreateRemote method to          
// create instances of the default interface IFtpServer exposed by              
// the CoClass FtpServer. The functions are intended to be used by             
// clients wishing to automate the CoClass objects exposed by the         
// server of this typelibrary.                                            
// *********************************************************************//
  CoFtpServer = class
    class function Create: IFtpServer;
    class function CreateRemote(const MachineName: string): IFtpServer;
  end;

// *********************************************************************//
// The Class CoFtpFile provides a Create and CreateRemote method to          
// create instances of the default interface IFtpFile exposed by              
// the CoClass FtpFile. The functions are intended to be used by             
// clients wishing to automate the CoClass objects exposed by the         
// server of this typelibrary.                                            
// *********************************************************************//
  CoFtpFile = class
    class function Create: IFtpFile;
    class function CreateRemote(const MachineName: string): IFtpFile;
  end;

// *********************************************************************//
// The Class CoUdp provides a Create and CreateRemote method to          
// create instances of the default interface IUdp exposed by              
// the CoClass Udp. The functions are intended to be used by             
// clients wishing to automate the CoClass objects exposed by the         
// server of this typelibrary.                                            
// *********************************************************************//
  CoUdp = class
    class function Create: IUdp;
    class function CreateRemote(const MachineName: string): IUdp;
  end;

// *********************************************************************//
// The Class CoSnmpObject provides a Create and CreateRemote method to          
// create instances of the default interface ISnmpObject exposed by              
// the CoClass SnmpObject. The functions are intended to be used by             
// clients wishing to automate the CoClass objects exposed by the         
// server of this typelibrary.                                            
// *********************************************************************//
  CoSnmpObject = class
    class function Create: ISnmpObject;
    class function CreateRemote(const MachineName: string): ISnmpObject;
  end;

// *********************************************************************//
// The Class CoTcp provides a Create and CreateRemote method to          
// create instances of the default interface ITcp exposed by              
// the CoClass Tcp. The functions are intended to be used by             
// clients wishing to automate the CoClass objects exposed by the         
// server of this typelibrary.                                            
// *********************************************************************//
  CoTcp = class
    class function Create: ITcp;
    class function CreateRemote(const MachineName: string): ITcp;
  end;

// *********************************************************************//
// The Class CoIPtoCountry provides a Create and CreateRemote method to          
// create instances of the default interface IIPtoCountry exposed by              
// the CoClass IPtoCountry. The functions are intended to be used by             
// clients wishing to automate the CoClass objects exposed by the         
// server of this typelibrary.                                            
// *********************************************************************//
  CoIPtoCountry = class
    class function Create: IIPtoCountry;
    class function CreateRemote(const MachineName: string): IIPtoCountry;
  end;

// *********************************************************************//
// The Class CoDnsServer provides a Create and CreateRemote method to          
// create instances of the default interface IDnsServer exposed by              
// the CoClass DnsServer. The functions are intended to be used by             
// clients wishing to automate the CoClass objects exposed by the         
// server of this typelibrary.                                            
// *********************************************************************//
  CoDnsServer = class
    class function Create: IDnsServer;
    class function CreateRemote(const MachineName: string): IDnsServer;
  end;

// *********************************************************************//
// The Class CoDnsRecord provides a Create and CreateRemote method to          
// create instances of the default interface IDnsRecord exposed by              
// the CoClass DnsRecord. The functions are intended to be used by             
// clients wishing to automate the CoClass objects exposed by the         
// server of this typelibrary.                                            
// *********************************************************************//
  CoDnsRecord = class
    class function Create: IDnsRecord;
    class function CreateRemote(const MachineName: string): IDnsRecord;
  end;

// *********************************************************************//
// The Class CoSsh provides a Create and CreateRemote method to          
// create instances of the default interface ISsh exposed by              
// the CoClass Ssh. The functions are intended to be used by             
// clients wishing to automate the CoClass objects exposed by the         
// server of this typelibrary.                                            
// *********************************************************************//
  CoSsh = class
    class function Create: ISsh;
    class function CreateRemote(const MachineName: string): ISsh;
  end;

// *********************************************************************//
// The Class CoSnmpMibBrowser provides a Create and CreateRemote method to          
// create instances of the default interface ISnmpMibBrowser exposed by              
// the CoClass SnmpMibBrowser. The functions are intended to be used by             
// clients wishing to automate the CoClass objects exposed by the         
// server of this typelibrary.                                            
// *********************************************************************//
  CoSnmpMibBrowser = class
    class function Create: ISnmpMibBrowser;
    class function CreateRemote(const MachineName: string): ISnmpMibBrowser;
  end;

// *********************************************************************//
// The Class CoTftpServer provides a Create and CreateRemote method to          
// create instances of the default interface ITftpServer exposed by              
// the CoClass TftpServer. The functions are intended to be used by             
// clients wishing to automate the CoClass objects exposed by the         
// server of this typelibrary.                                            
// *********************************************************************//
  CoTftpServer = class
    class function Create: ITftpServer;
    class function CreateRemote(const MachineName: string): ITftpServer;
  end;

// *********************************************************************//
// The Class CoMsn provides a Create and CreateRemote method to          
// create instances of the default interface IMsn exposed by              
// the CoClass Msn. The functions are intended to be used by             
// clients wishing to automate the CoClass objects exposed by the         
// server of this typelibrary.                                            
// *********************************************************************//
  CoMsn = class
    class function Create: IMsn;
    class function CreateRemote(const MachineName: string): IMsn;
  end;

// *********************************************************************//
// The Class CoRadius provides a Create and CreateRemote method to          
// create instances of the default interface IRadius exposed by              
// the CoClass Radius. The functions are intended to be used by             
// clients wishing to automate the CoClass objects exposed by the         
// server of this typelibrary.                                            
// *********************************************************************//
  CoRadius = class
    class function Create: IRadius;
    class function CreateRemote(const MachineName: string): IRadius;
  end;

// *********************************************************************//
// The Class CoScp provides a Create and CreateRemote method to          
// create instances of the default interface IScp exposed by              
// the CoClass Scp. The functions are intended to be used by             
// clients wishing to automate the CoClass objects exposed by the         
// server of this typelibrary.                                            
// *********************************************************************//
  CoScp = class
    class function Create: IScp;
    class function CreateRemote(const MachineName: string): IScp;
  end;

// *********************************************************************//
// The Class CoSFtp provides a Create and CreateRemote method to          
// create instances of the default interface ISFtp exposed by              
// the CoClass SFtp. The functions are intended to be used by             
// clients wishing to automate the CoClass objects exposed by the         
// server of this typelibrary.                                            
// *********************************************************************//
  CoSFtp = class
    class function Create: ISFtp;
    class function CreateRemote(const MachineName: string): ISFtp;
  end;

// *********************************************************************//
// The Class CoSFtpFile provides a Create and CreateRemote method to          
// create instances of the default interface ISFtpFile exposed by              
// the CoClass SFtpFile. The functions are intended to be used by             
// clients wishing to automate the CoClass objects exposed by the         
// server of this typelibrary.                                            
// *********************************************************************//
  CoSFtpFile = class
    class function Create: ISFtpFile;
    class function CreateRemote(const MachineName: string): ISFtpFile;
  end;

// *********************************************************************//
// The Class CoHttpEx provides a Create and CreateRemote method to          
// create instances of the default interface IHttpEx exposed by              
// the CoClass HttpEx. The functions are intended to be used by             
// clients wishing to automate the CoClass objects exposed by the         
// server of this typelibrary.                                            
// *********************************************************************//
  CoHttpEx = class
    class function Create: IHttpEx;
    class function CreateRemote(const MachineName: string): IHttpEx;
  end;

// *********************************************************************//
// The Class CoTraceRoute provides a Create and CreateRemote method to          
// create instances of the default interface ITraceRoute exposed by              
// the CoClass TraceRoute. The functions are intended to be used by             
// clients wishing to automate the CoClass objects exposed by the         
// server of this typelibrary.                                            
// *********************************************************************//
  CoTraceRoute = class
    class function Create: ITraceRoute;
    class function CreateRemote(const MachineName: string): ITraceRoute;
  end;

// *********************************************************************//
// The Class CoTraceHop provides a Create and CreateRemote method to          
// create instances of the default interface ITraceHop exposed by              
// the CoClass TraceHop. The functions are intended to be used by             
// clients wishing to automate the CoClass objects exposed by the         
// server of this typelibrary.                                            
// *********************************************************************//
  CoTraceHop = class
    class function Create: ITraceHop;
    class function CreateRemote(const MachineName: string): ITraceHop;
  end;

// *********************************************************************//
// The Class Co_SnmpManager provides a Create and CreateRemote method to          
// create instances of the default interface I_SnmpManager exposed by              
// the CoClass _SnmpManager. The functions are intended to be used by             
// clients wishing to automate the CoClass objects exposed by the         
// server of this typelibrary.                                            
// *********************************************************************//
  Co_SnmpManager = class
    class function Create: I_SnmpManager;
    class function CreateRemote(const MachineName: string): I_SnmpManager;
  end;

// *********************************************************************//
// The Class Co_SnmpTrapManager provides a Create and CreateRemote method to          
// create instances of the default interface I_SnmpTrapManager exposed by              
// the CoClass _SnmpTrapManager. The functions are intended to be used by             
// clients wishing to automate the CoClass objects exposed by the         
// server of this typelibrary.                                            
// *********************************************************************//
  Co_SnmpTrapManager = class
    class function Create: I_SnmpTrapManager;
    class function CreateRemote(const MachineName: string): I_SnmpTrapManager;
  end;

// *********************************************************************//
// The Class CoVMware provides a Create and CreateRemote method to          
// create instances of the default interface IVMware exposed by              
// the CoClass VMware. The functions are intended to be used by             
// clients wishing to automate the CoClass objects exposed by the         
// server of this typelibrary.                                            
// *********************************************************************//
  CoVMware = class
    class function Create: IVMware;
    class function CreateRemote(const MachineName: string): IVMware;
  end;

// *********************************************************************//
// The Class CoXen provides a Create and CreateRemote method to          
// create instances of the default interface IXen exposed by              
// the CoClass Xen. The functions are intended to be used by             
// clients wishing to automate the CoClass objects exposed by the         
// server of this typelibrary.                                            
// *********************************************************************//
  CoXen = class
    class function Create: IXen;
    class function CreateRemote(const MachineName: string): IXen;
  end;

implementation

uses ComObj;

class function CoRSh.Create: IRSh;
begin
  Result := CreateComObject(CLASS_RSh) as IRSh;
end;

class function CoRSh.CreateRemote(const MachineName: string): IRSh;
begin
  Result := CreateRemoteComObject(MachineName, CLASS_RSh) as IRSh;
end;

class function CoNtp.Create: INtp;
begin
  Result := CreateComObject(CLASS_Ntp) as INtp;
end;

class function CoNtp.CreateRemote(const MachineName: string): INtp;
begin
  Result := CreateRemoteComObject(MachineName, CLASS_Ntp) as INtp;
end;

class function CoWOL.Create: IWOL;
begin
  Result := CreateComObject(CLASS_WOL) as IWOL;
end;

class function CoWOL.CreateRemote(const MachineName: string): IWOL;
begin
  Result := CreateRemoteComObject(MachineName, CLASS_WOL) as IWOL;
end;

class function CoIcmp.Create: IIcmp;
begin
  Result := CreateComObject(CLASS_Icmp) as IIcmp;
end;

class function CoIcmp.CreateRemote(const MachineName: string): IIcmp;
begin
  Result := CreateRemoteComObject(MachineName, CLASS_Icmp) as IIcmp;
end;

class function CoNwConstants.Create: INwConstants;
begin
  Result := CreateComObject(CLASS_NwConstants) as INwConstants;
end;

class function CoNwConstants.CreateRemote(const MachineName: string): INwConstants;
begin
  Result := CreateRemoteComObject(MachineName, CLASS_NwConstants) as INwConstants;
end;

class function CoSnmpManager.Create: ISnmpManager;
begin
  Result := CreateComObject(CLASS_SnmpManager) as ISnmpManager;
end;

class function CoSnmpManager.CreateRemote(const MachineName: string): ISnmpManager;
begin
  Result := CreateRemoteComObject(MachineName, CLASS_SnmpManager) as ISnmpManager;
end;

class function CoSnmpTrap.Create: ISnmpTrap;
begin
  Result := CreateComObject(CLASS_SnmpTrap) as ISnmpTrap;
end;

class function CoSnmpTrap.CreateRemote(const MachineName: string): ISnmpTrap;
begin
  Result := CreateRemoteComObject(MachineName, CLASS_SnmpTrap) as ISnmpTrap;
end;

class function CoSnmpTrapManager.Create: ISnmpTrapManager;
begin
  Result := CreateComObject(CLASS_SnmpTrapManager) as ISnmpTrapManager;
end;

class function CoSnmpTrapManager.CreateRemote(const MachineName: string): ISnmpTrapManager;
begin
  Result := CreateRemoteComObject(MachineName, CLASS_SnmpTrapManager) as ISnmpTrapManager;
end;

class function CoFtpServer.Create: IFtpServer;
begin
  Result := CreateComObject(CLASS_FtpServer) as IFtpServer;
end;

class function CoFtpServer.CreateRemote(const MachineName: string): IFtpServer;
begin
  Result := CreateRemoteComObject(MachineName, CLASS_FtpServer) as IFtpServer;
end;

class function CoFtpFile.Create: IFtpFile;
begin
  Result := CreateComObject(CLASS_FtpFile) as IFtpFile;
end;

class function CoFtpFile.CreateRemote(const MachineName: string): IFtpFile;
begin
  Result := CreateRemoteComObject(MachineName, CLASS_FtpFile) as IFtpFile;
end;

class function CoUdp.Create: IUdp;
begin
  Result := CreateComObject(CLASS_Udp) as IUdp;
end;

class function CoUdp.CreateRemote(const MachineName: string): IUdp;
begin
  Result := CreateRemoteComObject(MachineName, CLASS_Udp) as IUdp;
end;

class function CoSnmpObject.Create: ISnmpObject;
begin
  Result := CreateComObject(CLASS_SnmpObject) as ISnmpObject;
end;

class function CoSnmpObject.CreateRemote(const MachineName: string): ISnmpObject;
begin
  Result := CreateRemoteComObject(MachineName, CLASS_SnmpObject) as ISnmpObject;
end;

class function CoTcp.Create: ITcp;
begin
  Result := CreateComObject(CLASS_Tcp) as ITcp;
end;

class function CoTcp.CreateRemote(const MachineName: string): ITcp;
begin
  Result := CreateRemoteComObject(MachineName, CLASS_Tcp) as ITcp;
end;

class function CoIPtoCountry.Create: IIPtoCountry;
begin
  Result := CreateComObject(CLASS_IPtoCountry) as IIPtoCountry;
end;

class function CoIPtoCountry.CreateRemote(const MachineName: string): IIPtoCountry;
begin
  Result := CreateRemoteComObject(MachineName, CLASS_IPtoCountry) as IIPtoCountry;
end;

class function CoDnsServer.Create: IDnsServer;
begin
  Result := CreateComObject(CLASS_DnsServer) as IDnsServer;
end;

class function CoDnsServer.CreateRemote(const MachineName: string): IDnsServer;
begin
  Result := CreateRemoteComObject(MachineName, CLASS_DnsServer) as IDnsServer;
end;

class function CoDnsRecord.Create: IDnsRecord;
begin
  Result := CreateComObject(CLASS_DnsRecord) as IDnsRecord;
end;

class function CoDnsRecord.CreateRemote(const MachineName: string): IDnsRecord;
begin
  Result := CreateRemoteComObject(MachineName, CLASS_DnsRecord) as IDnsRecord;
end;

class function CoSsh.Create: ISsh;
begin
  Result := CreateComObject(CLASS_Ssh) as ISsh;
end;

class function CoSsh.CreateRemote(const MachineName: string): ISsh;
begin
  Result := CreateRemoteComObject(MachineName, CLASS_Ssh) as ISsh;
end;

class function CoSnmpMibBrowser.Create: ISnmpMibBrowser;
begin
  Result := CreateComObject(CLASS_SnmpMibBrowser) as ISnmpMibBrowser;
end;

class function CoSnmpMibBrowser.CreateRemote(const MachineName: string): ISnmpMibBrowser;
begin
  Result := CreateRemoteComObject(MachineName, CLASS_SnmpMibBrowser) as ISnmpMibBrowser;
end;

class function CoTftpServer.Create: ITftpServer;
begin
  Result := CreateComObject(CLASS_TftpServer) as ITftpServer;
end;

class function CoTftpServer.CreateRemote(const MachineName: string): ITftpServer;
begin
  Result := CreateRemoteComObject(MachineName, CLASS_TftpServer) as ITftpServer;
end;

class function CoMsn.Create: IMsn;
begin
  Result := CreateComObject(CLASS_Msn) as IMsn;
end;

class function CoMsn.CreateRemote(const MachineName: string): IMsn;
begin
  Result := CreateRemoteComObject(MachineName, CLASS_Msn) as IMsn;
end;

class function CoRadius.Create: IRadius;
begin
  Result := CreateComObject(CLASS_Radius) as IRadius;
end;

class function CoRadius.CreateRemote(const MachineName: string): IRadius;
begin
  Result := CreateRemoteComObject(MachineName, CLASS_Radius) as IRadius;
end;

class function CoScp.Create: IScp;
begin
  Result := CreateComObject(CLASS_Scp) as IScp;
end;

class function CoScp.CreateRemote(const MachineName: string): IScp;
begin
  Result := CreateRemoteComObject(MachineName, CLASS_Scp) as IScp;
end;

class function CoSFtp.Create: ISFtp;
begin
  Result := CreateComObject(CLASS_SFtp) as ISFtp;
end;

class function CoSFtp.CreateRemote(const MachineName: string): ISFtp;
begin
  Result := CreateRemoteComObject(MachineName, CLASS_SFtp) as ISFtp;
end;

class function CoSFtpFile.Create: ISFtpFile;
begin
  Result := CreateComObject(CLASS_SFtpFile) as ISFtpFile;
end;

class function CoSFtpFile.CreateRemote(const MachineName: string): ISFtpFile;
begin
  Result := CreateRemoteComObject(MachineName, CLASS_SFtpFile) as ISFtpFile;
end;

class function CoHttpEx.Create: IHttpEx;
begin
  Result := CreateComObject(CLASS_HttpEx) as IHttpEx;
end;

class function CoHttpEx.CreateRemote(const MachineName: string): IHttpEx;
begin
  Result := CreateRemoteComObject(MachineName, CLASS_HttpEx) as IHttpEx;
end;

class function CoTraceRoute.Create: ITraceRoute;
begin
  Result := CreateComObject(CLASS_TraceRoute) as ITraceRoute;
end;

class function CoTraceRoute.CreateRemote(const MachineName: string): ITraceRoute;
begin
  Result := CreateRemoteComObject(MachineName, CLASS_TraceRoute) as ITraceRoute;
end;

class function CoTraceHop.Create: ITraceHop;
begin
  Result := CreateComObject(CLASS_TraceHop) as ITraceHop;
end;

class function CoTraceHop.CreateRemote(const MachineName: string): ITraceHop;
begin
  Result := CreateRemoteComObject(MachineName, CLASS_TraceHop) as ITraceHop;
end;

class function Co_SnmpManager.Create: I_SnmpManager;
begin
  Result := CreateComObject(CLASS__SnmpManager) as I_SnmpManager;
end;

class function Co_SnmpManager.CreateRemote(const MachineName: string): I_SnmpManager;
begin
  Result := CreateRemoteComObject(MachineName, CLASS__SnmpManager) as I_SnmpManager;
end;

class function Co_SnmpTrapManager.Create: I_SnmpTrapManager;
begin
  Result := CreateComObject(CLASS__SnmpTrapManager) as I_SnmpTrapManager;
end;

class function Co_SnmpTrapManager.CreateRemote(const MachineName: string): I_SnmpTrapManager;
begin
  Result := CreateRemoteComObject(MachineName, CLASS__SnmpTrapManager) as I_SnmpTrapManager;
end;

class function CoVMware.Create: IVMware;
begin
  Result := CreateComObject(CLASS_VMware) as IVMware;
end;

class function CoVMware.CreateRemote(const MachineName: string): IVMware;
begin
  Result := CreateRemoteComObject(MachineName, CLASS_VMware) as IVMware;
end;

class function CoXen.Create: IXen;
begin
  Result := CreateComObject(CLASS_Xen) as IXen;
end;

class function CoXen.CreateRemote(const MachineName: string): IXen;
begin
  Result := CreateRemoteComObject(MachineName, CLASS_Xen) as IXen;
end;

end.
