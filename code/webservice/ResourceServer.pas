// ************************************************************************ //
// The types declared in this file were generated from data read from the
// WSDL File described below:
// WSDL     : http://127.0.0.1:8081/oxhide/services/ResourceServer?wsdl
//  >Import : http://127.0.0.1:8081/oxhide/services/ResourceServer?wsdl:0
//  >Import : http://127.0.0.1:8081/oxhide/services/ResourceServer?wsdl:1
//  >Import : http://127.0.0.1:8081/oxhide/services/ResourceServer?wsdl:2
//  >Import : http://127.0.0.1:8081/oxhide/services/ResourceServer?wsdl:3
//  >Import : http://127.0.0.1:8081/oxhide/services/ResourceServer?wsdl:4
//  >Import : http://127.0.0.1:8081/oxhide/services/ResourceServer?wsdl:5
//  >Import : http://127.0.0.1:8081/oxhide/services/ResourceServer?wsdl:6
//  >Import : http://127.0.0.1:8081/oxhide/services/ResourceServer?wsdl:7
//  >Import : http://127.0.0.1:8081/oxhide/services/ResourceServer?wsdl:8
//  >Import : http://127.0.0.1:8081/oxhide/services/ResourceServer?wsdl:9
//  >Import : http://127.0.0.1:8081/oxhide/services/ResourceServer?wsdl:10
//  >Import : http://127.0.0.1:8081/oxhide/services/ResourceServer?wsdl:11
//  >Import : http://127.0.0.1:8081/oxhide/services/ResourceServer?wsdl:12
//  >Import : http://127.0.0.1:8081/oxhide/services/ResourceServer?wsdl:13
//  >Import : http://127.0.0.1:8081/oxhide/services/ResourceServer?wsdl:14
//  >Import : http://127.0.0.1:8081/oxhide/services/ResourceServer?wsdl:15
//  >Import : http://127.0.0.1:8081/oxhide/services/ResourceServer?wsdl:16
//  >Import : http://127.0.0.1:8081/oxhide/services/ResourceServer?wsdl:17
//  >Import : http://127.0.0.1:8081/oxhide/services/ResourceServer?wsdl:18
//  >Import : http://127.0.0.1:8081/oxhide/services/ResourceServer?wsdl:19
//  >Import : http://127.0.0.1:8081/oxhide/services/ResourceServer?wsdl:20
// Encoding : UTF-8
// Version  : 1.0
// (2012-8-16 15:25:27 - - $Rev: 10138 $)
// ************************************************************************ //

unit ResourceServer;

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
  // !:anyType         - "http://www.w3.org/2001/XMLSchema"[Gbl]
  // !:string          - "http://www.w3.org/2001/XMLSchema"[Gbl]
  // !:boolean         - "http://www.w3.org/2001/XMLSchema"[Gbl]
  // !:int             - "http://www.w3.org/2001/XMLSchema"[Gbl]

  entry                = class;                 { "http://resource.server.oxhide.sxsihe.com"[Cplx] }
  entry2               = class;                 { "http://resource.server.oxhide.sxsihe.com"[Cplx] }
  ConditionBlock       = class;                 { "http://persistence.oxhide.sxsihe.com"[GblCplx] }
  Resources            = class;                 { "http://domain.resource.oxhide.sxsihe.com"[GblCplx] }
  Rolesresources       = class;                 { "http://domain.rolesresource.oxhide.sxsihe.com"[GblCplx] }
  Ssoroles             = class;                 { "http://domain.ssoroles.oxhide.sxsihe.com"[GblCplx] }
  Usersroles           = class;                 { "http://domain.usersroles.oxhide.sxsihe.com"[GblCplx] }
  Ssousers             = class;                 { "http://domain.ssouser.oxhide.sxsihe.com"[GblCplx] }
  Boxmenus             = class;                 { "http://domain.boxmenus.imenus.oxhide.sxsihe.com"[GblCplx] }
  Blob                 = class;                 { "http://sql.java"[GblCplx] }
  Application_         = class;                 { "http://domain.application.oxhide.sxsihe.com"[GblCplx] }
  Employee             = class;                 { "http://domain.employee.oxhide.sxsihe.com"[GblCplx] }
  Deptment             = class;                 { "http://domain.dept.oxhide.sxsihe.com"[GblCplx] }
  Posts                = class;                 { "http://domain.post.oxhide.sxsihe.com"[GblCplx] }
  Organ                = class;                 { "http://domain.organ.oxhide.sxsihe.com"[GblCplx] }
  Workhistory          = class;                 { "http://domain.workhistory.oxhide.sxsihe.com"[GblCplx] }
  Unmobile             = class;                 { "http://domain.mobile.message.oxhide.sxsihe.com"[GblCplx] }
  Rolesapp             = class;                 { "http://domain.rolesapp.oxhide.sxsihe.com"[GblCplx] }
  Tokens               = class;                 { "http://domain.token.message.oxhide.sxsihe.com"[GblCplx] }
  InputStream          = class;                 { "http://io.java"[GblCplx] }
  Educationhistory     = class;                 { "http://domain.educationhistory.oxhide.sxsihe.com"[GblCplx] }
  Commonmenus          = class;                 { "http://domain.commonmenus.imenus.oxhide.sxsihe.com"[GblCplx] }

  anyType2anyTypeMap = array of entry;          { "http://resource.server.oxhide.sxsihe.com"[GblCplx] }


  // ************************************************************************ //
  // XML       : entry, <complexType>
  // Namespace : http://resource.server.oxhide.sxsihe.com
  // ************************************************************************ //
  entry = class(TRemotable)
  private
    Fkey: Variant;
    Fkey_Specified: boolean;
    Fvalue: Variant;
    Fvalue_Specified: boolean;
    procedure Setkey(Index: Integer; const AVariant: Variant);
    function  key_Specified(Index: Integer): boolean;
    procedure Setvalue(Index: Integer; const AVariant: Variant);
    function  value_Specified(Index: Integer): boolean;
  published
    property key:   Variant  Index (IS_OPTN) read Fkey write Setkey stored key_Specified;
    property value: Variant  Index (IS_OPTN) read Fvalue write Setvalue stored value_Specified;
  end;

  ArrayOfString = array of WideString;          { "http://resource.server.oxhide.sxsihe.com"[GblCplx] }
  anyType2booleanMap = array of entry2;         { "http://resource.server.oxhide.sxsihe.com"[GblCplx] }


  // ************************************************************************ //
  // XML       : entry, <complexType>
  // Namespace : http://resource.server.oxhide.sxsihe.com
  // ************************************************************************ //
  entry2 = class(TRemotable)
  private
    Fkey: Variant;
    Fkey_Specified: boolean;
    Fvalue: Boolean;
    Fvalue_Specified: boolean;
    procedure Setkey(Index: Integer; const AVariant: Variant);
    function  key_Specified(Index: Integer): boolean;
    procedure Setvalue(Index: Integer; const ABoolean: Boolean);
    function  value_Specified(Index: Integer): boolean;
  published
    property key:   Variant  Index (IS_OPTN) read Fkey write Setkey stored key_Specified;
    property value: Boolean  Index (IS_OPTN) read Fvalue write Setvalue stored value_Specified;
  end;

  ArrayOfResources = array of Resources;        { "http://domain.resource.oxhide.sxsihe.com"[GblCplx] }


  // ************************************************************************ //
  // XML       : ConditionBlock, global, <complexType>
  // Namespace : http://persistence.oxhide.sxsihe.com
  // ************************************************************************ //
  ConditionBlock = class(TRemotable)
  private
    FHQL: WideString;
    FHQL_Specified: boolean;
    Fmap: anyType2anyTypeMap;
    Fmap_Specified: boolean;
    Fselects: ArrayOfString;
    Fselects_Specified: boolean;
    procedure SetHQL(Index: Integer; const AWideString: WideString);
    function  HQL_Specified(Index: Integer): boolean;
    procedure Setmap(Index: Integer; const AanyType2anyTypeMap: anyType2anyTypeMap);
    function  map_Specified(Index: Integer): boolean;
    procedure Setselects(Index: Integer; const AArrayOfString: ArrayOfString);
    function  selects_Specified(Index: Integer): boolean;
  public
    destructor Destroy; override;
  published
    property HQL:     WideString          Index (IS_OPTN or IS_NLBL) read FHQL write SetHQL stored HQL_Specified;
    property map:     anyType2anyTypeMap  Index (IS_OPTN or IS_NLBL) read Fmap write Setmap stored map_Specified;
    property selects: ArrayOfString       Index (IS_OPTN or IS_NLBL) read Fselects write Setselects stored selects_Specified;
  end;

  ArrayOfCommonmenus = array of Commonmenus;    { "http://domain.commonmenus.imenus.oxhide.sxsihe.com"[GblCplx] }
  ArrayOfRolesresources = array of Rolesresources;   { "http://domain.rolesresource.oxhide.sxsihe.com"[GblCplx] }


  // ************************************************************************ //
  // XML       : Resources, global, <complexType>
  // Namespace : http://domain.resource.oxhide.sxsihe.com
  // ************************************************************************ //
  Resources = class(TRemotable)
  private
    Fapplication_: Application_;
    Fapplication__Specified: boolean;
    Fbigico: WideString;
    Fbigico_Specified: boolean;
    Fcommonmenus: ArrayOfCommonmenus;
    Fcommonmenus_Specified: boolean;
    Fdisplay: Integer;
    Fdisplay_Specified: boolean;
    FdisplayAppId: WideString;
    FdisplayAppId_Specified: boolean;
    FdisplayPId: WideString;
    FdisplayPId_Specified: boolean;
    Fico: WideString;
    Fico_Specified: boolean;
    Fisvalidation: WideString;
    Fisvalidation_Specified: boolean;
    Flargeico: WideString;
    Flargeico_Specified: boolean;
    Fmenutype: Integer;
    Fmenutype_Specified: boolean;
    Fmobileico: WideString;
    Fmobileico_Specified: boolean;
    Fmobileurl: WideString;
    Fmobileurl_Specified: boolean;
    Forderno: Integer;
    Forderno_Specified: boolean;
    Fprompt: WideString;
    Fprompt_Specified: boolean;
    Fremark: WideString;
    Fremark_Specified: boolean;
    Fresourcecode: WideString;
    Fresourcecode_Specified: boolean;
    Fresourcees: ArrayOfResources;
    Fresourcees_Specified: boolean;
    Fresourceid: WideString;
    Fresourceid_Specified: boolean;
    Fresourcename: WideString;
    Fresourcename_Specified: boolean;
    Fresourcesp: Resources;
    Fresourcesp_Specified: boolean;
    Fresourceurl: WideString;
    Fresourceurl_Specified: boolean;
    Frolesresourceses: ArrayOfRolesresources;
    Frolesresourceses_Specified: boolean;
    Fselfclick: WideString;
    Fselfclick_Specified: boolean;
    Fsimplyname: WideString;
    Fsimplyname_Specified: boolean;
    Ftabname: WideString;
    Ftabname_Specified: boolean;
    Ftarget: Integer;
    Ftarget_Specified: boolean;
    procedure Setapplication_(Index: Integer; const AApplication_: Application_);
    function  application__Specified(Index: Integer): boolean;
    procedure Setbigico(Index: Integer; const AWideString: WideString);
    function  bigico_Specified(Index: Integer): boolean;
    procedure Setcommonmenus(Index: Integer; const AArrayOfCommonmenus: ArrayOfCommonmenus);
    function  commonmenus_Specified(Index: Integer): boolean;
    procedure Setdisplay(Index: Integer; const AInteger: Integer);
    function  display_Specified(Index: Integer): boolean;
    procedure SetdisplayAppId(Index: Integer; const AWideString: WideString);
    function  displayAppId_Specified(Index: Integer): boolean;
    procedure SetdisplayPId(Index: Integer; const AWideString: WideString);
    function  displayPId_Specified(Index: Integer): boolean;
    procedure Setico(Index: Integer; const AWideString: WideString);
    function  ico_Specified(Index: Integer): boolean;
    procedure Setisvalidation(Index: Integer; const AWideString: WideString);
    function  isvalidation_Specified(Index: Integer): boolean;
    procedure Setlargeico(Index: Integer; const AWideString: WideString);
    function  largeico_Specified(Index: Integer): boolean;
    procedure Setmenutype(Index: Integer; const AInteger: Integer);
    function  menutype_Specified(Index: Integer): boolean;
    procedure Setmobileico(Index: Integer; const AWideString: WideString);
    function  mobileico_Specified(Index: Integer): boolean;
    procedure Setmobileurl(Index: Integer; const AWideString: WideString);
    function  mobileurl_Specified(Index: Integer): boolean;
    procedure Setorderno(Index: Integer; const AInteger: Integer);
    function  orderno_Specified(Index: Integer): boolean;
    procedure Setprompt(Index: Integer; const AWideString: WideString);
    function  prompt_Specified(Index: Integer): boolean;
    procedure Setremark(Index: Integer; const AWideString: WideString);
    function  remark_Specified(Index: Integer): boolean;
    procedure Setresourcecode(Index: Integer; const AWideString: WideString);
    function  resourcecode_Specified(Index: Integer): boolean;
    procedure Setresourcees(Index: Integer; const AArrayOfResources: ArrayOfResources);
    function  resourcees_Specified(Index: Integer): boolean;
    procedure Setresourceid(Index: Integer; const AWideString: WideString);
    function  resourceid_Specified(Index: Integer): boolean;
    procedure Setresourcename(Index: Integer; const AWideString: WideString);
    function  resourcename_Specified(Index: Integer): boolean;
    procedure Setresourcesp(Index: Integer; const AResources: Resources);
    function  resourcesp_Specified(Index: Integer): boolean;
    procedure Setresourceurl(Index: Integer; const AWideString: WideString);
    function  resourceurl_Specified(Index: Integer): boolean;
    procedure Setrolesresourceses(Index: Integer; const AArrayOfRolesresources: ArrayOfRolesresources);
    function  rolesresourceses_Specified(Index: Integer): boolean;
    procedure Setselfclick(Index: Integer; const AWideString: WideString);
    function  selfclick_Specified(Index: Integer): boolean;
    procedure Setsimplyname(Index: Integer; const AWideString: WideString);
    function  simplyname_Specified(Index: Integer): boolean;
    procedure Settabname(Index: Integer; const AWideString: WideString);
    function  tabname_Specified(Index: Integer): boolean;
    procedure Settarget(Index: Integer; const AInteger: Integer);
    function  target_Specified(Index: Integer): boolean;
  public
    destructor Destroy; override;
  published
    property application_:     Application_           Index (IS_OPTN or IS_NLBL) read Fapplication_ write Setapplication_ stored application__Specified;
    property bigico:           WideString             Index (IS_OPTN or IS_NLBL) read Fbigico write Setbigico stored bigico_Specified;
    property commonmenus:      ArrayOfCommonmenus     Index (IS_OPTN or IS_NLBL) read Fcommonmenus write Setcommonmenus stored commonmenus_Specified;
    property display:          Integer                Index (IS_OPTN or IS_NLBL) read Fdisplay write Setdisplay stored display_Specified;
    property displayAppId:     WideString             Index (IS_OPTN or IS_NLBL) read FdisplayAppId write SetdisplayAppId stored displayAppId_Specified;
    property displayPId:       WideString             Index (IS_OPTN or IS_NLBL) read FdisplayPId write SetdisplayPId stored displayPId_Specified;
    property ico:              WideString             Index (IS_OPTN or IS_NLBL) read Fico write Setico stored ico_Specified;
    property isvalidation:     WideString             Index (IS_OPTN or IS_NLBL) read Fisvalidation write Setisvalidation stored isvalidation_Specified;
    property largeico:         WideString             Index (IS_OPTN or IS_NLBL) read Flargeico write Setlargeico stored largeico_Specified;
    property menutype:         Integer                Index (IS_OPTN or IS_NLBL) read Fmenutype write Setmenutype stored menutype_Specified;
    property mobileico:        WideString             Index (IS_OPTN or IS_NLBL) read Fmobileico write Setmobileico stored mobileico_Specified;
    property mobileurl:        WideString             Index (IS_OPTN or IS_NLBL) read Fmobileurl write Setmobileurl stored mobileurl_Specified;
    property orderno:          Integer                Index (IS_OPTN or IS_NLBL) read Forderno write Setorderno stored orderno_Specified;
    property prompt:           WideString             Index (IS_OPTN or IS_NLBL) read Fprompt write Setprompt stored prompt_Specified;
    property remark:           WideString             Index (IS_OPTN or IS_NLBL) read Fremark write Setremark stored remark_Specified;
    property resourcecode:     WideString             Index (IS_OPTN or IS_NLBL) read Fresourcecode write Setresourcecode stored resourcecode_Specified;
    property resourcees:       ArrayOfResources       Index (IS_OPTN or IS_NLBL) read Fresourcees write Setresourcees stored resourcees_Specified;
    property resourceid:       WideString             Index (IS_OPTN or IS_NLBL) read Fresourceid write Setresourceid stored resourceid_Specified;
    property resourcename:     WideString             Index (IS_OPTN or IS_NLBL) read Fresourcename write Setresourcename stored resourcename_Specified;
    property resourcesp:       Resources              Index (IS_OPTN or IS_NLBL) read Fresourcesp write Setresourcesp stored resourcesp_Specified;
    property resourceurl:      WideString             Index (IS_OPTN or IS_NLBL) read Fresourceurl write Setresourceurl stored resourceurl_Specified;
    property rolesresourceses: ArrayOfRolesresources  Index (IS_OPTN or IS_NLBL) read Frolesresourceses write Setrolesresourceses stored rolesresourceses_Specified;
    property selfclick:        WideString             Index (IS_OPTN or IS_NLBL) read Fselfclick write Setselfclick stored selfclick_Specified;
    property simplyname:       WideString             Index (IS_OPTN or IS_NLBL) read Fsimplyname write Setsimplyname stored simplyname_Specified;
    property tabname:          WideString             Index (IS_OPTN or IS_NLBL) read Ftabname write Settabname stored tabname_Specified;
    property target:           Integer                Index (IS_OPTN or IS_NLBL) read Ftarget write Settarget stored target_Specified;
  end;



  // ************************************************************************ //
  // XML       : Rolesresources, global, <complexType>
  // Namespace : http://domain.rolesresource.oxhide.sxsihe.com
  // ************************************************************************ //
  Rolesresources = class(TRemotable)
  private
    Fresourceroleid: WideString;
    Fresourceroleid_Specified: boolean;
    Fresources: Resources;
    Fresources_Specified: boolean;
    Fssoroles: Ssoroles;
    Fssoroles_Specified: boolean;
    procedure Setresourceroleid(Index: Integer; const AWideString: WideString);
    function  resourceroleid_Specified(Index: Integer): boolean;
    procedure Setresources(Index: Integer; const AResources: Resources);
    function  resources_Specified(Index: Integer): boolean;
    procedure Setssoroles(Index: Integer; const ASsoroles: Ssoroles);
    function  ssoroles_Specified(Index: Integer): boolean;
  public
    destructor Destroy; override;
  published
    property resourceroleid: WideString  Index (IS_OPTN or IS_NLBL) read Fresourceroleid write Setresourceroleid stored resourceroleid_Specified;
    property resources:      Resources   Index (IS_OPTN or IS_NLBL) read Fresources write Setresources stored resources_Specified;
    property ssoroles:       Ssoroles    Index (IS_OPTN or IS_NLBL) read Fssoroles write Setssoroles stored ssoroles_Specified;
  end;

  ArrayOfRolesapp = array of Rolesapp;          { "http://domain.rolesapp.oxhide.sxsihe.com"[GblCplx] }
  ArrayOfUsersroles = array of Usersroles;      { "http://domain.usersroles.oxhide.sxsihe.com"[GblCplx] }


  // ************************************************************************ //
  // XML       : Ssoroles, global, <complexType>
  // Namespace : http://domain.ssoroles.oxhide.sxsihe.com
  // ************************************************************************ //
  Ssoroles = class(TRemotable)
  private
    Fisvalidation: Integer;
    Fisvalidation_Specified: boolean;
    Fremark: WideString;
    Fremark_Specified: boolean;
    Frolecode: WideString;
    Frolecode_Specified: boolean;
    Froleid: WideString;
    Froleid_Specified: boolean;
    Frolename: WideString;
    Frolename_Specified: boolean;
    Frolesapp: ArrayOfRolesapp;
    Frolesapp_Specified: boolean;
    Frolesresourceses: ArrayOfRolesresources;
    Frolesresourceses_Specified: boolean;
    Fusersroleses: ArrayOfUsersroles;
    Fusersroleses_Specified: boolean;
    procedure Setisvalidation(Index: Integer; const AInteger: Integer);
    function  isvalidation_Specified(Index: Integer): boolean;
    procedure Setremark(Index: Integer; const AWideString: WideString);
    function  remark_Specified(Index: Integer): boolean;
    procedure Setrolecode(Index: Integer; const AWideString: WideString);
    function  rolecode_Specified(Index: Integer): boolean;
    procedure Setroleid(Index: Integer; const AWideString: WideString);
    function  roleid_Specified(Index: Integer): boolean;
    procedure Setrolename(Index: Integer; const AWideString: WideString);
    function  rolename_Specified(Index: Integer): boolean;
    procedure Setrolesapp(Index: Integer; const AArrayOfRolesapp: ArrayOfRolesapp);
    function  rolesapp_Specified(Index: Integer): boolean;
    procedure Setrolesresourceses(Index: Integer; const AArrayOfRolesresources: ArrayOfRolesresources);
    function  rolesresourceses_Specified(Index: Integer): boolean;
    procedure Setusersroleses(Index: Integer; const AArrayOfUsersroles: ArrayOfUsersroles);
    function  usersroleses_Specified(Index: Integer): boolean;
  public
    destructor Destroy; override;
  published
    property isvalidation:     Integer                Index (IS_OPTN or IS_NLBL) read Fisvalidation write Setisvalidation stored isvalidation_Specified;
    property remark:           WideString             Index (IS_OPTN or IS_NLBL) read Fremark write Setremark stored remark_Specified;
    property rolecode:         WideString             Index (IS_OPTN or IS_NLBL) read Frolecode write Setrolecode stored rolecode_Specified;
    property roleid:           WideString             Index (IS_OPTN or IS_NLBL) read Froleid write Setroleid stored roleid_Specified;
    property rolename:         WideString             Index (IS_OPTN or IS_NLBL) read Frolename write Setrolename stored rolename_Specified;
    property rolesapp:         ArrayOfRolesapp        Index (IS_OPTN or IS_NLBL) read Frolesapp write Setrolesapp stored rolesapp_Specified;
    property rolesresourceses: ArrayOfRolesresources  Index (IS_OPTN or IS_NLBL) read Frolesresourceses write Setrolesresourceses stored rolesresourceses_Specified;
    property usersroleses:     ArrayOfUsersroles      Index (IS_OPTN or IS_NLBL) read Fusersroleses write Setusersroleses stored usersroleses_Specified;
  end;



  // ************************************************************************ //
  // XML       : Usersroles, global, <complexType>
  // Namespace : http://domain.usersroles.oxhide.sxsihe.com
  // ************************************************************************ //
  Usersroles = class(TRemotable)
  private
    Fssoroles: Ssoroles;
    Fssoroles_Specified: boolean;
    Fssousers: Ssousers;
    Fssousers_Specified: boolean;
    Fuserroleid: WideString;
    Fuserroleid_Specified: boolean;
    procedure Setssoroles(Index: Integer; const ASsoroles: Ssoroles);
    function  ssoroles_Specified(Index: Integer): boolean;
    procedure Setssousers(Index: Integer; const ASsousers: Ssousers);
    function  ssousers_Specified(Index: Integer): boolean;
    procedure Setuserroleid(Index: Integer; const AWideString: WideString);
    function  userroleid_Specified(Index: Integer): boolean;
  public
    destructor Destroy; override;
  published
    property ssoroles:   Ssoroles    Index (IS_OPTN or IS_NLBL) read Fssoroles write Setssoroles stored ssoroles_Specified;
    property ssousers:   Ssousers    Index (IS_OPTN or IS_NLBL) read Fssousers write Setssousers stored ssousers_Specified;
    property userroleid: WideString  Index (IS_OPTN or IS_NLBL) read Fuserroleid write Setuserroleid stored userroleid_Specified;
  end;

  ArrayOfBoxmenus = array of Boxmenus;          { "http://domain.boxmenus.imenus.oxhide.sxsihe.com"[GblCplx] }
  ArrayOfTokens = array of Tokens;              { "http://domain.token.message.oxhide.sxsihe.com"[GblCplx] }


  // ************************************************************************ //
  // XML       : Ssousers, global, <complexType>
  // Namespace : http://domain.ssouser.oxhide.sxsihe.com
  // ************************************************************************ //
  Ssousers = class(TRemotable)
  private
    Fandroid: WideString;
    Fandroid_Specified: boolean;
    Fapple: WideString;
    Fapple_Specified: boolean;
    Fboxmenus: ArrayOfBoxmenus;
    Fboxmenus_Specified: boolean;
    Fcommonmenus: ArrayOfCommonmenus;
    Fcommonmenus_Specified: boolean;
    Fdesk: WideString;
    Fdesk_Specified: boolean;
    FdeskType: WideString;
    FdeskType_Specified: boolean;
    Femployee: Employee;
    Femployee_Specified: boolean;
    Ffacestyle: WideString;
    Ffacestyle_Specified: boolean;
    Fissingel: Integer;
    Fissingel_Specified: boolean;
    Fisvalidation: Integer;
    Fisvalidation_Specified: boolean;
    Fpassword: WideString;
    Fpassword_Specified: boolean;
    Ftokens: ArrayOfTokens;
    Ftokens_Specified: boolean;
    Fuserid: WideString;
    Fuserid_Specified: boolean;
    Fusername: WideString;
    Fusername_Specified: boolean;
    Fusersroleses: ArrayOfUsersroles;
    Fusersroleses_Specified: boolean;
    procedure Setandroid(Index: Integer; const AWideString: WideString);
    function  android_Specified(Index: Integer): boolean;
    procedure Setapple(Index: Integer; const AWideString: WideString);
    function  apple_Specified(Index: Integer): boolean;
    procedure Setboxmenus(Index: Integer; const AArrayOfBoxmenus: ArrayOfBoxmenus);
    function  boxmenus_Specified(Index: Integer): boolean;
    procedure Setcommonmenus(Index: Integer; const AArrayOfCommonmenus: ArrayOfCommonmenus);
    function  commonmenus_Specified(Index: Integer): boolean;
    procedure Setdesk(Index: Integer; const AWideString: WideString);
    function  desk_Specified(Index: Integer): boolean;
    procedure SetdeskType(Index: Integer; const AWideString: WideString);
    function  deskType_Specified(Index: Integer): boolean;
    procedure Setemployee(Index: Integer; const AEmployee: Employee);
    function  employee_Specified(Index: Integer): boolean;
    procedure Setfacestyle(Index: Integer; const AWideString: WideString);
    function  facestyle_Specified(Index: Integer): boolean;
    procedure Setissingel(Index: Integer; const AInteger: Integer);
    function  issingel_Specified(Index: Integer): boolean;
    procedure Setisvalidation(Index: Integer; const AInteger: Integer);
    function  isvalidation_Specified(Index: Integer): boolean;
    procedure Setpassword(Index: Integer; const AWideString: WideString);
    function  password_Specified(Index: Integer): boolean;
    procedure Settokens(Index: Integer; const AArrayOfTokens: ArrayOfTokens);
    function  tokens_Specified(Index: Integer): boolean;
    procedure Setuserid(Index: Integer; const AWideString: WideString);
    function  userid_Specified(Index: Integer): boolean;
    procedure Setusername(Index: Integer; const AWideString: WideString);
    function  username_Specified(Index: Integer): boolean;
    procedure Setusersroleses(Index: Integer; const AArrayOfUsersroles: ArrayOfUsersroles);
    function  usersroleses_Specified(Index: Integer): boolean;
  public
    destructor Destroy; override;
  published
    property android:      WideString          Index (IS_OPTN or IS_NLBL) read Fandroid write Setandroid stored android_Specified;
    property apple:        WideString          Index (IS_OPTN or IS_NLBL) read Fapple write Setapple stored apple_Specified;
    property boxmenus:     ArrayOfBoxmenus     Index (IS_OPTN or IS_NLBL) read Fboxmenus write Setboxmenus stored boxmenus_Specified;
    property commonmenus:  ArrayOfCommonmenus  Index (IS_OPTN or IS_NLBL) read Fcommonmenus write Setcommonmenus stored commonmenus_Specified;
    property desk:         WideString          Index (IS_OPTN or IS_NLBL) read Fdesk write Setdesk stored desk_Specified;
    property deskType:     WideString          Index (IS_OPTN or IS_NLBL) read FdeskType write SetdeskType stored deskType_Specified;
    property employee:     Employee            Index (IS_OPTN or IS_NLBL) read Femployee write Setemployee stored employee_Specified;
    property facestyle:    WideString          Index (IS_OPTN or IS_NLBL) read Ffacestyle write Setfacestyle stored facestyle_Specified;
    property issingel:     Integer             Index (IS_OPTN or IS_NLBL) read Fissingel write Setissingel stored issingel_Specified;
    property isvalidation: Integer             Index (IS_OPTN or IS_NLBL) read Fisvalidation write Setisvalidation stored isvalidation_Specified;
    property password:     WideString          Index (IS_OPTN or IS_NLBL) read Fpassword write Setpassword stored password_Specified;
    property tokens:       ArrayOfTokens       Index (IS_OPTN or IS_NLBL) read Ftokens write Settokens stored tokens_Specified;
    property userid:       WideString          Index (IS_OPTN or IS_NLBL) read Fuserid write Setuserid stored userid_Specified;
    property username:     WideString          Index (IS_OPTN or IS_NLBL) read Fusername write Setusername stored username_Specified;
    property usersroleses: ArrayOfUsersroles   Index (IS_OPTN or IS_NLBL) read Fusersroleses write Setusersroleses stored usersroleses_Specified;
  end;

  ArrayOfSsousers = array of Ssousers;          { "http://domain.ssouser.oxhide.sxsihe.com"[GblCplx] }


  // ************************************************************************ //
  // XML       : Boxmenus, global, <complexType>
  // Namespace : http://domain.boxmenus.imenus.oxhide.sxsihe.com
  // ************************************************************************ //
  Boxmenus = class(TRemotable)
  private
    Fbid: WideString;
    Fbid_Specified: boolean;
    Fmenuname: WideString;
    Fmenuname_Specified: boolean;
    Fmenuurl: WideString;
    Fmenuurl_Specified: boolean;
    Fssousers: Ssousers;
    Fssousers_Specified: boolean;
    procedure Setbid(Index: Integer; const AWideString: WideString);
    function  bid_Specified(Index: Integer): boolean;
    procedure Setmenuname(Index: Integer; const AWideString: WideString);
    function  menuname_Specified(Index: Integer): boolean;
    procedure Setmenuurl(Index: Integer; const AWideString: WideString);
    function  menuurl_Specified(Index: Integer): boolean;
    procedure Setssousers(Index: Integer; const ASsousers: Ssousers);
    function  ssousers_Specified(Index: Integer): boolean;
  public
    destructor Destroy; override;
  published
    property bid:      WideString  Index (IS_OPTN or IS_NLBL) read Fbid write Setbid stored bid_Specified;
    property menuname: WideString  Index (IS_OPTN or IS_NLBL) read Fmenuname write Setmenuname stored menuname_Specified;
    property menuurl:  WideString  Index (IS_OPTN or IS_NLBL) read Fmenuurl write Setmenuurl stored menuurl_Specified;
    property ssousers: Ssousers    Index (IS_OPTN or IS_NLBL) read Fssousers write Setssousers stored ssousers_Specified;
  end;

  ArrayOfEducationhistory = array of Educationhistory;   { "http://domain.educationhistory.oxhide.sxsihe.com"[GblCplx] }


  // ************************************************************************ //
  // XML       : Blob, global, <complexType>
  // Namespace : http://sql.java
  // ************************************************************************ //
  Blob = class(TRemotable)
  private
    FbinaryStream: InputStream;
    FbinaryStream_Specified: boolean;
    procedure SetbinaryStream(Index: Integer; const AInputStream: InputStream);
    function  binaryStream_Specified(Index: Integer): boolean;
  public
    destructor Destroy; override;
  published
    property binaryStream: InputStream  Index (IS_OPTN or IS_NLBL) read FbinaryStream write SetbinaryStream stored binaryStream_Specified;
  end;

  ArrayOfUnmobile = array of Unmobile;          { "http://domain.mobile.message.oxhide.sxsihe.com"[GblCplx] }


  // ************************************************************************ //
  // XML       : Application, global, <complexType>
  // Namespace : http://domain.application.oxhide.sxsihe.com
  // ************************************************************************ //
  Application_ = class(TRemotable)
  private
    Fandroidkey: WideString;
    Fandroidkey_Specified: boolean;
    Fandroidkf: WideString;
    Fandroidkf_Specified: boolean;
    Fappcode: WideString;
    Fappcode_Specified: boolean;
    Fappid: WideString;
    Fappid_Specified: boolean;
    Fappindex: WideString;
    Fappindex_Specified: boolean;
    Fapplekey: WideString;
    Fapplekey_Specified: boolean;
    Fapplekf: WideString;
    Fapplekf_Specified: boolean;
    Fappname: WideString;
    Fappname_Specified: boolean;
    Fapptitle: WideString;
    Fapptitle_Specified: boolean;
    Fappurl: WideString;
    Fappurl_Specified: boolean;
    Fappurlw: WideString;
    Fappurlw_Specified: boolean;
    Fbigico: WideString;
    Fbigico_Specified: boolean;
    Fico: WideString;
    Fico_Specified: boolean;
    Flargeico: WideString;
    Flargeico_Specified: boolean;
    Forderno: Integer;
    Forderno_Specified: boolean;
    Fremark: WideString;
    Fremark_Specified: boolean;
    Fresources: ArrayOfResources;
    Fresources_Specified: boolean;
    Frolesapp: ArrayOfRolesapp;
    Frolesapp_Specified: boolean;
    Fsimplyname: WideString;
    Fsimplyname_Specified: boolean;
    Ftimeenable: WideString;
    Ftimeenable_Specified: boolean;
    Ftimer: WideString;
    Ftimer_Specified: boolean;
    Ftimes: WideString;
    Ftimes_Specified: boolean;
    Ftokens: ArrayOfTokens;
    Ftokens_Specified: boolean;
    Funmobiles: ArrayOfUnmobile;
    Funmobiles_Specified: boolean;
    procedure Setandroidkey(Index: Integer; const AWideString: WideString);
    function  androidkey_Specified(Index: Integer): boolean;
    procedure Setandroidkf(Index: Integer; const AWideString: WideString);
    function  androidkf_Specified(Index: Integer): boolean;
    procedure Setappcode(Index: Integer; const AWideString: WideString);
    function  appcode_Specified(Index: Integer): boolean;
    procedure Setappid(Index: Integer; const AWideString: WideString);
    function  appid_Specified(Index: Integer): boolean;
    procedure Setappindex(Index: Integer; const AWideString: WideString);
    function  appindex_Specified(Index: Integer): boolean;
    procedure Setapplekey(Index: Integer; const AWideString: WideString);
    function  applekey_Specified(Index: Integer): boolean;
    procedure Setapplekf(Index: Integer; const AWideString: WideString);
    function  applekf_Specified(Index: Integer): boolean;
    procedure Setappname(Index: Integer; const AWideString: WideString);
    function  appname_Specified(Index: Integer): boolean;
    procedure Setapptitle(Index: Integer; const AWideString: WideString);
    function  apptitle_Specified(Index: Integer): boolean;
    procedure Setappurl(Index: Integer; const AWideString: WideString);
    function  appurl_Specified(Index: Integer): boolean;
    procedure Setappurlw(Index: Integer; const AWideString: WideString);
    function  appurlw_Specified(Index: Integer): boolean;
    procedure Setbigico(Index: Integer; const AWideString: WideString);
    function  bigico_Specified(Index: Integer): boolean;
    procedure Setico(Index: Integer; const AWideString: WideString);
    function  ico_Specified(Index: Integer): boolean;
    procedure Setlargeico(Index: Integer; const AWideString: WideString);
    function  largeico_Specified(Index: Integer): boolean;
    procedure Setorderno(Index: Integer; const AInteger: Integer);
    function  orderno_Specified(Index: Integer): boolean;
    procedure Setremark(Index: Integer; const AWideString: WideString);
    function  remark_Specified(Index: Integer): boolean;
    procedure Setresources(Index: Integer; const AArrayOfResources: ArrayOfResources);
    function  resources_Specified(Index: Integer): boolean;
    procedure Setrolesapp(Index: Integer; const AArrayOfRolesapp: ArrayOfRolesapp);
    function  rolesapp_Specified(Index: Integer): boolean;
    procedure Setsimplyname(Index: Integer; const AWideString: WideString);
    function  simplyname_Specified(Index: Integer): boolean;
    procedure Settimeenable(Index: Integer; const AWideString: WideString);
    function  timeenable_Specified(Index: Integer): boolean;
    procedure Settimer(Index: Integer; const AWideString: WideString);
    function  timer_Specified(Index: Integer): boolean;
    procedure Settimes(Index: Integer; const AWideString: WideString);
    function  times_Specified(Index: Integer): boolean;
    procedure Settokens(Index: Integer; const AArrayOfTokens: ArrayOfTokens);
    function  tokens_Specified(Index: Integer): boolean;
    procedure Setunmobiles(Index: Integer; const AArrayOfUnmobile: ArrayOfUnmobile);
    function  unmobiles_Specified(Index: Integer): boolean;
  public
    destructor Destroy; override;
  published
    property androidkey: WideString        Index (IS_OPTN or IS_NLBL) read Fandroidkey write Setandroidkey stored androidkey_Specified;
    property androidkf:  WideString        Index (IS_OPTN or IS_NLBL) read Fandroidkf write Setandroidkf stored androidkf_Specified;
    property appcode:    WideString        Index (IS_OPTN or IS_NLBL) read Fappcode write Setappcode stored appcode_Specified;
    property appid:      WideString        Index (IS_OPTN or IS_NLBL) read Fappid write Setappid stored appid_Specified;
    property appindex:   WideString        Index (IS_OPTN or IS_NLBL) read Fappindex write Setappindex stored appindex_Specified;
    property applekey:   WideString        Index (IS_OPTN or IS_NLBL) read Fapplekey write Setapplekey stored applekey_Specified;
    property applekf:    WideString        Index (IS_OPTN or IS_NLBL) read Fapplekf write Setapplekf stored applekf_Specified;
    property appname:    WideString        Index (IS_OPTN or IS_NLBL) read Fappname write Setappname stored appname_Specified;
    property apptitle:   WideString        Index (IS_OPTN or IS_NLBL) read Fapptitle write Setapptitle stored apptitle_Specified;
    property appurl:     WideString        Index (IS_OPTN or IS_NLBL) read Fappurl write Setappurl stored appurl_Specified;
    property appurlw:    WideString        Index (IS_OPTN or IS_NLBL) read Fappurlw write Setappurlw stored appurlw_Specified;
    property bigico:     WideString        Index (IS_OPTN or IS_NLBL) read Fbigico write Setbigico stored bigico_Specified;
    property ico:        WideString        Index (IS_OPTN or IS_NLBL) read Fico write Setico stored ico_Specified;
    property largeico:   WideString        Index (IS_OPTN or IS_NLBL) read Flargeico write Setlargeico stored largeico_Specified;
    property orderno:    Integer           Index (IS_OPTN or IS_NLBL) read Forderno write Setorderno stored orderno_Specified;
    property remark:     WideString        Index (IS_OPTN or IS_NLBL) read Fremark write Setremark stored remark_Specified;
    property resources:  ArrayOfResources  Index (IS_OPTN or IS_NLBL) read Fresources write Setresources stored resources_Specified;
    property rolesapp:   ArrayOfRolesapp   Index (IS_OPTN or IS_NLBL) read Frolesapp write Setrolesapp stored rolesapp_Specified;
    property simplyname: WideString        Index (IS_OPTN or IS_NLBL) read Fsimplyname write Setsimplyname stored simplyname_Specified;
    property timeenable: WideString        Index (IS_OPTN or IS_NLBL) read Ftimeenable write Settimeenable stored timeenable_Specified;
    property timer:      WideString        Index (IS_OPTN or IS_NLBL) read Ftimer write Settimer stored timer_Specified;
    property times:      WideString        Index (IS_OPTN or IS_NLBL) read Ftimes write Settimes stored times_Specified;
    property tokens:     ArrayOfTokens     Index (IS_OPTN or IS_NLBL) read Ftokens write Settokens stored tokens_Specified;
    property unmobiles:  ArrayOfUnmobile   Index (IS_OPTN or IS_NLBL) read Funmobiles write Setunmobiles stored unmobiles_Specified;
  end;

  ArrayOfWorkhistory = array of Workhistory;    { "http://domain.workhistory.oxhide.sxsihe.com"[GblCplx] }


  // ************************************************************************ //
  // XML       : Employee, global, <complexType>
  // Namespace : http://domain.employee.oxhide.sxsihe.com
  // ************************************************************************ //
  Employee = class(TRemotable)
  private
    Faccount: WideString;
    Faccount_Specified: boolean;
    Faccounttype: WideString;
    Faccounttype_Specified: boolean;
    Fassociation: WideString;
    Fassociation_Specified: boolean;
    Fbirthday: WideString;
    Fbirthday_Specified: boolean;
    Fblood: WideString;
    Fblood_Specified: boolean;
    Fcardid: WideString;
    Fcardid_Specified: boolean;
    Fdutydate: WideString;
    Fdutydate_Specified: boolean;
    Feducation: WideString;
    Feducation_Specified: boolean;
    Feducationhistory: ArrayOfEducationhistory;
    Feducationhistory_Specified: boolean;
    Femail: WideString;
    Femail_Specified: boolean;
    FemailPassword: WideString;
    FemailPassword_Specified: boolean;
    Femployeecode: WideString;
    Femployeecode_Specified: boolean;
    Femployeeid: WideString;
    Femployeeid_Specified: boolean;
    Femployeename: WideString;
    Femployeename_Specified: boolean;
    FhasPen: Boolean;
    FhasPen_Specified: boolean;
    FhasPhoto: Boolean;
    FhasPhoto_Specified: boolean;
    Fidentity: WideString;
    Fidentity_Specified: boolean;
    Fidentityplace: WideString;
    Fidentityplace_Specified: boolean;
    Fisvalidation: Integer;
    Fisvalidation_Specified: boolean;
    Fmainplace: WideString;
    Fmainplace_Specified: boolean;
    Fmarry: WideString;
    Fmarry_Specified: boolean;
    Fmobile: WideString;
    Fmobile_Specified: boolean;
    Fnation: WideString;
    Fnation_Specified: boolean;
    Fnational: WideString;
    Fnational_Specified: boolean;
    Fnowworkbegin: WideString;
    Fnowworkbegin_Specified: boolean;
    Fnowworkend: WideString;
    Fnowworkend_Specified: boolean;
    Forderno: Integer;
    Forderno_Specified: boolean;
    Forigin: WideString;
    Forigin_Specified: boolean;
    Fotherprofessional: WideString;
    Fotherprofessional_Specified: boolean;
    Fotherprofessionalid: WideString;
    Fotherprofessionalid_Specified: boolean;
    Fotherprofessionalidtime: WideString;
    Fotherprofessionalidtime_Specified: boolean;
    Foutlook: WideString;
    Foutlook_Specified: boolean;
    Fpen: Blob;
    Fpen_Specified: boolean;
    Fphone: WideString;
    Fphone_Specified: boolean;
    Fphoto: Blob;
    Fphoto_Specified: boolean;
    Fposts: Posts;
    Fposts_Specified: boolean;
    Fprofessional: WideString;
    Fprofessional_Specified: boolean;
    Fprofessionallife: WideString;
    Fprofessionallife_Specified: boolean;
    Fprofessionaltype: WideString;
    Fprofessionaltype_Specified: boolean;
    Fremark: WideString;
    Fremark_Specified: boolean;
    Freportscores: WideString;
    Freportscores_Specified: boolean;
    Fsex: Integer;
    Fsex_Specified: boolean;
    Fssouserses: ArrayOfSsousers;
    Fssouserses_Specified: boolean;
    Ftitle: WideString;
    Ftitle_Specified: boolean;
    Ftitleid: WideString;
    Ftitleid_Specified: boolean;
    Ftraintime: WideString;
    Ftraintime_Specified: boolean;
    Funmobiles: ArrayOfUnmobile;
    Funmobiles_Specified: boolean;
    FuserCount: Integer;
    FuserCount_Specified: boolean;
    Fworkhistory: ArrayOfWorkhistory;
    Fworkhistory_Specified: boolean;
    Fworkstarttime: WideString;
    Fworkstarttime_Specified: boolean;
    Fworktime: WideString;
    Fworktime_Specified: boolean;
    Fworktype: WideString;
    Fworktype_Specified: boolean;
    procedure Setaccount(Index: Integer; const AWideString: WideString);
    function  account_Specified(Index: Integer): boolean;
    procedure Setaccounttype(Index: Integer; const AWideString: WideString);
    function  accounttype_Specified(Index: Integer): boolean;
    procedure Setassociation(Index: Integer; const AWideString: WideString);
    function  association_Specified(Index: Integer): boolean;
    procedure Setbirthday(Index: Integer; const AWideString: WideString);
    function  birthday_Specified(Index: Integer): boolean;
    procedure Setblood(Index: Integer; const AWideString: WideString);
    function  blood_Specified(Index: Integer): boolean;
    procedure Setcardid(Index: Integer; const AWideString: WideString);
    function  cardid_Specified(Index: Integer): boolean;
    procedure Setdutydate(Index: Integer; const AWideString: WideString);
    function  dutydate_Specified(Index: Integer): boolean;
    procedure Seteducation(Index: Integer; const AWideString: WideString);
    function  education_Specified(Index: Integer): boolean;
    procedure Seteducationhistory(Index: Integer; const AArrayOfEducationhistory: ArrayOfEducationhistory);
    function  educationhistory_Specified(Index: Integer): boolean;
    procedure Setemail(Index: Integer; const AWideString: WideString);
    function  email_Specified(Index: Integer): boolean;
    procedure SetemailPassword(Index: Integer; const AWideString: WideString);
    function  emailPassword_Specified(Index: Integer): boolean;
    procedure Setemployeecode(Index: Integer; const AWideString: WideString);
    function  employeecode_Specified(Index: Integer): boolean;
    procedure Setemployeeid(Index: Integer; const AWideString: WideString);
    function  employeeid_Specified(Index: Integer): boolean;
    procedure Setemployeename(Index: Integer; const AWideString: WideString);
    function  employeename_Specified(Index: Integer): boolean;
    procedure SethasPen(Index: Integer; const ABoolean: Boolean);
    function  hasPen_Specified(Index: Integer): boolean;
    procedure SethasPhoto(Index: Integer; const ABoolean: Boolean);
    function  hasPhoto_Specified(Index: Integer): boolean;
    procedure Setidentity(Index: Integer; const AWideString: WideString);
    function  identity_Specified(Index: Integer): boolean;
    procedure Setidentityplace(Index: Integer; const AWideString: WideString);
    function  identityplace_Specified(Index: Integer): boolean;
    procedure Setisvalidation(Index: Integer; const AInteger: Integer);
    function  isvalidation_Specified(Index: Integer): boolean;
    procedure Setmainplace(Index: Integer; const AWideString: WideString);
    function  mainplace_Specified(Index: Integer): boolean;
    procedure Setmarry(Index: Integer; const AWideString: WideString);
    function  marry_Specified(Index: Integer): boolean;
    procedure Setmobile(Index: Integer; const AWideString: WideString);
    function  mobile_Specified(Index: Integer): boolean;
    procedure Setnation(Index: Integer; const AWideString: WideString);
    function  nation_Specified(Index: Integer): boolean;
    procedure Setnational(Index: Integer; const AWideString: WideString);
    function  national_Specified(Index: Integer): boolean;
    procedure Setnowworkbegin(Index: Integer; const AWideString: WideString);
    function  nowworkbegin_Specified(Index: Integer): boolean;
    procedure Setnowworkend(Index: Integer; const AWideString: WideString);
    function  nowworkend_Specified(Index: Integer): boolean;
    procedure Setorderno(Index: Integer; const AInteger: Integer);
    function  orderno_Specified(Index: Integer): boolean;
    procedure Setorigin(Index: Integer; const AWideString: WideString);
    function  origin_Specified(Index: Integer): boolean;
    procedure Setotherprofessional(Index: Integer; const AWideString: WideString);
    function  otherprofessional_Specified(Index: Integer): boolean;
    procedure Setotherprofessionalid(Index: Integer; const AWideString: WideString);
    function  otherprofessionalid_Specified(Index: Integer): boolean;
    procedure Setotherprofessionalidtime(Index: Integer; const AWideString: WideString);
    function  otherprofessionalidtime_Specified(Index: Integer): boolean;
    procedure Setoutlook(Index: Integer; const AWideString: WideString);
    function  outlook_Specified(Index: Integer): boolean;
    procedure Setpen(Index: Integer; const ABlob: Blob);
    function  pen_Specified(Index: Integer): boolean;
    procedure Setphone(Index: Integer; const AWideString: WideString);
    function  phone_Specified(Index: Integer): boolean;
    procedure Setphoto(Index: Integer; const ABlob: Blob);
    function  photo_Specified(Index: Integer): boolean;
    procedure Setposts(Index: Integer; const APosts: Posts);
    function  posts_Specified(Index: Integer): boolean;
    procedure Setprofessional(Index: Integer; const AWideString: WideString);
    function  professional_Specified(Index: Integer): boolean;
    procedure Setprofessionallife(Index: Integer; const AWideString: WideString);
    function  professionallife_Specified(Index: Integer): boolean;
    procedure Setprofessionaltype(Index: Integer; const AWideString: WideString);
    function  professionaltype_Specified(Index: Integer): boolean;
    procedure Setremark(Index: Integer; const AWideString: WideString);
    function  remark_Specified(Index: Integer): boolean;
    procedure Setreportscores(Index: Integer; const AWideString: WideString);
    function  reportscores_Specified(Index: Integer): boolean;
    procedure Setsex(Index: Integer; const AInteger: Integer);
    function  sex_Specified(Index: Integer): boolean;
    procedure Setssouserses(Index: Integer; const AArrayOfSsousers: ArrayOfSsousers);
    function  ssouserses_Specified(Index: Integer): boolean;
    procedure Settitle(Index: Integer; const AWideString: WideString);
    function  title_Specified(Index: Integer): boolean;
    procedure Settitleid(Index: Integer; const AWideString: WideString);
    function  titleid_Specified(Index: Integer): boolean;
    procedure Settraintime(Index: Integer; const AWideString: WideString);
    function  traintime_Specified(Index: Integer): boolean;
    procedure Setunmobiles(Index: Integer; const AArrayOfUnmobile: ArrayOfUnmobile);
    function  unmobiles_Specified(Index: Integer): boolean;
    procedure SetuserCount(Index: Integer; const AInteger: Integer);
    function  userCount_Specified(Index: Integer): boolean;
    procedure Setworkhistory(Index: Integer; const AArrayOfWorkhistory: ArrayOfWorkhistory);
    function  workhistory_Specified(Index: Integer): boolean;
    procedure Setworkstarttime(Index: Integer; const AWideString: WideString);
    function  workstarttime_Specified(Index: Integer): boolean;
    procedure Setworktime(Index: Integer; const AWideString: WideString);
    function  worktime_Specified(Index: Integer): boolean;
    procedure Setworktype(Index: Integer; const AWideString: WideString);
    function  worktype_Specified(Index: Integer): boolean;
  public
    destructor Destroy; override;
  published
    property account:                 WideString               Index (IS_OPTN or IS_NLBL) read Faccount write Setaccount stored account_Specified;
    property accounttype:             WideString               Index (IS_OPTN or IS_NLBL) read Faccounttype write Setaccounttype stored accounttype_Specified;
    property association:             WideString               Index (IS_OPTN or IS_NLBL) read Fassociation write Setassociation stored association_Specified;
    property birthday:                WideString               Index (IS_OPTN or IS_NLBL) read Fbirthday write Setbirthday stored birthday_Specified;
    property blood:                   WideString               Index (IS_OPTN or IS_NLBL) read Fblood write Setblood stored blood_Specified;
    property cardid:                  WideString               Index (IS_OPTN or IS_NLBL) read Fcardid write Setcardid stored cardid_Specified;
    property dutydate:                WideString               Index (IS_OPTN or IS_NLBL) read Fdutydate write Setdutydate stored dutydate_Specified;
    property education:               WideString               Index (IS_OPTN or IS_NLBL) read Feducation write Seteducation stored education_Specified;
    property educationhistory:        ArrayOfEducationhistory  Index (IS_OPTN or IS_NLBL) read Feducationhistory write Seteducationhistory stored educationhistory_Specified;
    property email:                   WideString               Index (IS_OPTN or IS_NLBL) read Femail write Setemail stored email_Specified;
    property emailPassword:           WideString               Index (IS_OPTN or IS_NLBL) read FemailPassword write SetemailPassword stored emailPassword_Specified;
    property employeecode:            WideString               Index (IS_OPTN or IS_NLBL) read Femployeecode write Setemployeecode stored employeecode_Specified;
    property employeeid:              WideString               Index (IS_OPTN or IS_NLBL) read Femployeeid write Setemployeeid stored employeeid_Specified;
    property employeename:            WideString               Index (IS_OPTN or IS_NLBL) read Femployeename write Setemployeename stored employeename_Specified;
    property hasPen:                  Boolean                  Index (IS_OPTN) read FhasPen write SethasPen stored hasPen_Specified;
    property hasPhoto:                Boolean                  Index (IS_OPTN) read FhasPhoto write SethasPhoto stored hasPhoto_Specified;
    property identity:                WideString               Index (IS_OPTN or IS_NLBL) read Fidentity write Setidentity stored identity_Specified;
    property identityplace:           WideString               Index (IS_OPTN or IS_NLBL) read Fidentityplace write Setidentityplace stored identityplace_Specified;
    property isvalidation:            Integer                  Index (IS_OPTN or IS_NLBL) read Fisvalidation write Setisvalidation stored isvalidation_Specified;
    property mainplace:               WideString               Index (IS_OPTN or IS_NLBL) read Fmainplace write Setmainplace stored mainplace_Specified;
    property marry:                   WideString               Index (IS_OPTN or IS_NLBL) read Fmarry write Setmarry stored marry_Specified;
    property mobile:                  WideString               Index (IS_OPTN or IS_NLBL) read Fmobile write Setmobile stored mobile_Specified;
    property nation:                  WideString               Index (IS_OPTN or IS_NLBL) read Fnation write Setnation stored nation_Specified;
    property national:                WideString               Index (IS_OPTN or IS_NLBL) read Fnational write Setnational stored national_Specified;
    property nowworkbegin:            WideString               Index (IS_OPTN or IS_NLBL) read Fnowworkbegin write Setnowworkbegin stored nowworkbegin_Specified;
    property nowworkend:              WideString               Index (IS_OPTN or IS_NLBL) read Fnowworkend write Setnowworkend stored nowworkend_Specified;
    property orderno:                 Integer                  Index (IS_OPTN or IS_NLBL) read Forderno write Setorderno stored orderno_Specified;
    property origin:                  WideString               Index (IS_OPTN or IS_NLBL) read Forigin write Setorigin stored origin_Specified;
    property otherprofessional:       WideString               Index (IS_OPTN or IS_NLBL) read Fotherprofessional write Setotherprofessional stored otherprofessional_Specified;
    property otherprofessionalid:     WideString               Index (IS_OPTN or IS_NLBL) read Fotherprofessionalid write Setotherprofessionalid stored otherprofessionalid_Specified;
    property otherprofessionalidtime: WideString               Index (IS_OPTN or IS_NLBL) read Fotherprofessionalidtime write Setotherprofessionalidtime stored otherprofessionalidtime_Specified;
    property outlook:                 WideString               Index (IS_OPTN or IS_NLBL) read Foutlook write Setoutlook stored outlook_Specified;
    property pen:                     Blob                     Index (IS_OPTN or IS_NLBL) read Fpen write Setpen stored pen_Specified;
    property phone:                   WideString               Index (IS_OPTN or IS_NLBL) read Fphone write Setphone stored phone_Specified;
    property photo:                   Blob                     Index (IS_OPTN or IS_NLBL) read Fphoto write Setphoto stored photo_Specified;
    property posts:                   Posts                    Index (IS_OPTN or IS_NLBL) read Fposts write Setposts stored posts_Specified;
    property professional:            WideString               Index (IS_OPTN or IS_NLBL) read Fprofessional write Setprofessional stored professional_Specified;
    property professionallife:        WideString               Index (IS_OPTN or IS_NLBL) read Fprofessionallife write Setprofessionallife stored professionallife_Specified;
    property professionaltype:        WideString               Index (IS_OPTN or IS_NLBL) read Fprofessionaltype write Setprofessionaltype stored professionaltype_Specified;
    property remark:                  WideString               Index (IS_OPTN or IS_NLBL) read Fremark write Setremark stored remark_Specified;
    property reportscores:            WideString               Index (IS_OPTN or IS_NLBL) read Freportscores write Setreportscores stored reportscores_Specified;
    property sex:                     Integer                  Index (IS_OPTN or IS_NLBL) read Fsex write Setsex stored sex_Specified;
    property ssouserses:              ArrayOfSsousers          Index (IS_OPTN or IS_NLBL) read Fssouserses write Setssouserses stored ssouserses_Specified;
    property title:                   WideString               Index (IS_OPTN or IS_NLBL) read Ftitle write Settitle stored title_Specified;
    property titleid:                 WideString               Index (IS_OPTN or IS_NLBL) read Ftitleid write Settitleid stored titleid_Specified;
    property traintime:               WideString               Index (IS_OPTN or IS_NLBL) read Ftraintime write Settraintime stored traintime_Specified;
    property unmobiles:               ArrayOfUnmobile          Index (IS_OPTN or IS_NLBL) read Funmobiles write Setunmobiles stored unmobiles_Specified;
    property userCount:               Integer                  Index (IS_OPTN) read FuserCount write SetuserCount stored userCount_Specified;
    property workhistory:             ArrayOfWorkhistory       Index (IS_OPTN or IS_NLBL) read Fworkhistory write Setworkhistory stored workhistory_Specified;
    property workstarttime:           WideString               Index (IS_OPTN or IS_NLBL) read Fworkstarttime write Setworkstarttime stored workstarttime_Specified;
    property worktime:                WideString               Index (IS_OPTN or IS_NLBL) read Fworktime write Setworktime stored worktime_Specified;
    property worktype:                WideString               Index (IS_OPTN or IS_NLBL) read Fworktype write Setworktype stored worktype_Specified;
  end;

  ArrayOfDeptment = array of Deptment;          { "http://domain.dept.oxhide.sxsihe.com"[GblCplx] }
  ArrayOfPosts = array of Posts;                { "http://domain.post.oxhide.sxsihe.com"[GblCplx] }


  // ************************************************************************ //
  // XML       : Deptment, global, <complexType>
  // Namespace : http://domain.dept.oxhide.sxsihe.com
  // ************************************************************************ //
  Deptment = class(TRemotable)
  private
    Fareaid: WideString;
    Fareaid_Specified: boolean;
    Fdeptcode: WideString;
    Fdeptcode_Specified: boolean;
    Fdeptid: WideString;
    Fdeptid_Specified: boolean;
    Fdeptman: WideString;
    Fdeptman_Specified: boolean;
    Fdeptmanid: WideString;
    Fdeptmanid_Specified: boolean;
    Fdeptment: Deptment;
    Fdeptment_Specified: boolean;
    Fdeptments: ArrayOfDeptment;
    Fdeptments_Specified: boolean;
    Fdeptname: WideString;
    Fdeptname_Specified: boolean;
    Fisvalidation: Integer;
    Fisvalidation_Specified: boolean;
    Forderno: Integer;
    Forderno_Specified: boolean;
    Forgan: Organ;
    Forgan_Specified: boolean;
    Fpostses: ArrayOfPosts;
    Fpostses_Specified: boolean;
    Fremark: WideString;
    Fremark_Specified: boolean;
    procedure Setareaid(Index: Integer; const AWideString: WideString);
    function  areaid_Specified(Index: Integer): boolean;
    procedure Setdeptcode(Index: Integer; const AWideString: WideString);
    function  deptcode_Specified(Index: Integer): boolean;
    procedure Setdeptid(Index: Integer; const AWideString: WideString);
    function  deptid_Specified(Index: Integer): boolean;
    procedure Setdeptman(Index: Integer; const AWideString: WideString);
    function  deptman_Specified(Index: Integer): boolean;
    procedure Setdeptmanid(Index: Integer; const AWideString: WideString);
    function  deptmanid_Specified(Index: Integer): boolean;
    procedure Setdeptment(Index: Integer; const ADeptment: Deptment);
    function  deptment_Specified(Index: Integer): boolean;
    procedure Setdeptments(Index: Integer; const AArrayOfDeptment: ArrayOfDeptment);
    function  deptments_Specified(Index: Integer): boolean;
    procedure Setdeptname(Index: Integer; const AWideString: WideString);
    function  deptname_Specified(Index: Integer): boolean;
    procedure Setisvalidation(Index: Integer; const AInteger: Integer);
    function  isvalidation_Specified(Index: Integer): boolean;
    procedure Setorderno(Index: Integer; const AInteger: Integer);
    function  orderno_Specified(Index: Integer): boolean;
    procedure Setorgan(Index: Integer; const AOrgan: Organ);
    function  organ_Specified(Index: Integer): boolean;
    procedure Setpostses(Index: Integer; const AArrayOfPosts: ArrayOfPosts);
    function  postses_Specified(Index: Integer): boolean;
    procedure Setremark(Index: Integer; const AWideString: WideString);
    function  remark_Specified(Index: Integer): boolean;
  public
    destructor Destroy; override;
  published
    property areaid:       WideString       Index (IS_OPTN or IS_NLBL) read Fareaid write Setareaid stored areaid_Specified;
    property deptcode:     WideString       Index (IS_OPTN or IS_NLBL) read Fdeptcode write Setdeptcode stored deptcode_Specified;
    property deptid:       WideString       Index (IS_OPTN or IS_NLBL) read Fdeptid write Setdeptid stored deptid_Specified;
    property deptman:      WideString       Index (IS_OPTN or IS_NLBL) read Fdeptman write Setdeptman stored deptman_Specified;
    property deptmanid:    WideString       Index (IS_OPTN or IS_NLBL) read Fdeptmanid write Setdeptmanid stored deptmanid_Specified;
    property deptment:     Deptment         Index (IS_OPTN or IS_NLBL) read Fdeptment write Setdeptment stored deptment_Specified;
    property deptments:    ArrayOfDeptment  Index (IS_OPTN or IS_NLBL) read Fdeptments write Setdeptments stored deptments_Specified;
    property deptname:     WideString       Index (IS_OPTN or IS_NLBL) read Fdeptname write Setdeptname stored deptname_Specified;
    property isvalidation: Integer          Index (IS_OPTN or IS_NLBL) read Fisvalidation write Setisvalidation stored isvalidation_Specified;
    property orderno:      Integer          Index (IS_OPTN or IS_NLBL) read Forderno write Setorderno stored orderno_Specified;
    property organ:        Organ            Index (IS_OPTN or IS_NLBL) read Forgan write Setorgan stored organ_Specified;
    property postses:      ArrayOfPosts     Index (IS_OPTN or IS_NLBL) read Fpostses write Setpostses stored postses_Specified;
    property remark:       WideString       Index (IS_OPTN or IS_NLBL) read Fremark write Setremark stored remark_Specified;
  end;



  // ************************************************************************ //
  // XML       : Posts, global, <complexType>
  // Namespace : http://domain.post.oxhide.sxsihe.com
  // ************************************************************************ //
  Posts = class(TRemotable)
  private
    Fdeptment: Deptment;
    Fdeptment_Specified: boolean;
    Femployees: ArrayOfDeptment;
    Femployees_Specified: boolean;
    Fisvalidation: Integer;
    Fisvalidation_Specified: boolean;
    Forderno: Integer;
    Forderno_Specified: boolean;
    Fpostcode: WideString;
    Fpostcode_Specified: boolean;
    Fpostid: WideString;
    Fpostid_Specified: boolean;
    Fpostname: WideString;
    Fpostname_Specified: boolean;
    Fposts: Posts;
    Fposts_Specified: boolean;
    Fpostses: ArrayOfPosts;
    Fpostses_Specified: boolean;
    Fremark: WideString;
    Fremark_Specified: boolean;
    procedure Setdeptment(Index: Integer; const ADeptment: Deptment);
    function  deptment_Specified(Index: Integer): boolean;
    procedure Setemployees(Index: Integer; const AArrayOfDeptment: ArrayOfDeptment);
    function  employees_Specified(Index: Integer): boolean;
    procedure Setisvalidation(Index: Integer; const AInteger: Integer);
    function  isvalidation_Specified(Index: Integer): boolean;
    procedure Setorderno(Index: Integer; const AInteger: Integer);
    function  orderno_Specified(Index: Integer): boolean;
    procedure Setpostcode(Index: Integer; const AWideString: WideString);
    function  postcode_Specified(Index: Integer): boolean;
    procedure Setpostid(Index: Integer; const AWideString: WideString);
    function  postid_Specified(Index: Integer): boolean;
    procedure Setpostname(Index: Integer; const AWideString: WideString);
    function  postname_Specified(Index: Integer): boolean;
    procedure Setposts(Index: Integer; const APosts: Posts);
    function  posts_Specified(Index: Integer): boolean;
    procedure Setpostses(Index: Integer; const AArrayOfPosts: ArrayOfPosts);
    function  postses_Specified(Index: Integer): boolean;
    procedure Setremark(Index: Integer; const AWideString: WideString);
    function  remark_Specified(Index: Integer): boolean;
  public
    destructor Destroy; override;
  published
    property deptment:     Deptment         Index (IS_OPTN or IS_NLBL) read Fdeptment write Setdeptment stored deptment_Specified;
    property employees:    ArrayOfDeptment  Index (IS_OPTN or IS_NLBL) read Femployees write Setemployees stored employees_Specified;
    property isvalidation: Integer          Index (IS_OPTN or IS_NLBL) read Fisvalidation write Setisvalidation stored isvalidation_Specified;
    property orderno:      Integer          Index (IS_OPTN or IS_NLBL) read Forderno write Setorderno stored orderno_Specified;
    property postcode:     WideString       Index (IS_OPTN or IS_NLBL) read Fpostcode write Setpostcode stored postcode_Specified;
    property postid:       WideString       Index (IS_OPTN or IS_NLBL) read Fpostid write Setpostid stored postid_Specified;
    property postname:     WideString       Index (IS_OPTN or IS_NLBL) read Fpostname write Setpostname stored postname_Specified;
    property posts:        Posts            Index (IS_OPTN or IS_NLBL) read Fposts write Setposts stored posts_Specified;
    property postses:      ArrayOfPosts     Index (IS_OPTN or IS_NLBL) read Fpostses write Setpostses stored postses_Specified;
    property remark:       WideString       Index (IS_OPTN or IS_NLBL) read Fremark write Setremark stored remark_Specified;
  end;

  ArrayOfOrgan = array of Organ;                { "http://domain.organ.oxhide.sxsihe.com"[GblCplx] }


  // ************************************************************************ //
  // XML       : Organ, global, <complexType>
  // Namespace : http://domain.organ.oxhide.sxsihe.com
  // ************************************************************************ //
  Organ = class(TRemotable)
  private
    Faddress: WideString;
    Faddress_Specified: boolean;
    Fareaid: WideString;
    Fareaid_Specified: boolean;
    Fdeptments: ArrayOfDeptment;
    Fdeptments_Specified: boolean;
    Ffax: WideString;
    Ffax_Specified: boolean;
    Fisvalidation: Integer;
    Fisvalidation_Specified: boolean;
    Forganalias: WideString;
    Forganalias_Specified: boolean;
    Forgancode: WideString;
    Forgancode_Specified: boolean;
    Forganid: WideString;
    Forganid_Specified: boolean;
    Forganman: WideString;
    Forganman_Specified: boolean;
    Forganmanid: WideString;
    Forganmanid_Specified: boolean;
    Forganname: WideString;
    Forganname_Specified: boolean;
    Forgans: ArrayOfOrgan;
    Forgans_Specified: boolean;
    Fporgan: Organ;
    Fporgan_Specified: boolean;
    Fpostcode: WideString;
    Fpostcode_Specified: boolean;
    Fremark: WideString;
    Fremark_Specified: boolean;
    Ftelephone: WideString;
    Ftelephone_Specified: boolean;
    procedure Setaddress(Index: Integer; const AWideString: WideString);
    function  address_Specified(Index: Integer): boolean;
    procedure Setareaid(Index: Integer; const AWideString: WideString);
    function  areaid_Specified(Index: Integer): boolean;
    procedure Setdeptments(Index: Integer; const AArrayOfDeptment: ArrayOfDeptment);
    function  deptments_Specified(Index: Integer): boolean;
    procedure Setfax(Index: Integer; const AWideString: WideString);
    function  fax_Specified(Index: Integer): boolean;
    procedure Setisvalidation(Index: Integer; const AInteger: Integer);
    function  isvalidation_Specified(Index: Integer): boolean;
    procedure Setorganalias(Index: Integer; const AWideString: WideString);
    function  organalias_Specified(Index: Integer): boolean;
    procedure Setorgancode(Index: Integer; const AWideString: WideString);
    function  organcode_Specified(Index: Integer): boolean;
    procedure Setorganid(Index: Integer; const AWideString: WideString);
    function  organid_Specified(Index: Integer): boolean;
    procedure Setorganman(Index: Integer; const AWideString: WideString);
    function  organman_Specified(Index: Integer): boolean;
    procedure Setorganmanid(Index: Integer; const AWideString: WideString);
    function  organmanid_Specified(Index: Integer): boolean;
    procedure Setorganname(Index: Integer; const AWideString: WideString);
    function  organname_Specified(Index: Integer): boolean;
    procedure Setorgans(Index: Integer; const AArrayOfOrgan: ArrayOfOrgan);
    function  organs_Specified(Index: Integer): boolean;
    procedure Setporgan(Index: Integer; const AOrgan: Organ);
    function  porgan_Specified(Index: Integer): boolean;
    procedure Setpostcode(Index: Integer; const AWideString: WideString);
    function  postcode_Specified(Index: Integer): boolean;
    procedure Setremark(Index: Integer; const AWideString: WideString);
    function  remark_Specified(Index: Integer): boolean;
    procedure Settelephone(Index: Integer; const AWideString: WideString);
    function  telephone_Specified(Index: Integer): boolean;
  public
    destructor Destroy; override;
  published
    property address:      WideString       Index (IS_OPTN or IS_NLBL) read Faddress write Setaddress stored address_Specified;
    property areaid:       WideString       Index (IS_OPTN or IS_NLBL) read Fareaid write Setareaid stored areaid_Specified;
    property deptments:    ArrayOfDeptment  Index (IS_OPTN or IS_NLBL) read Fdeptments write Setdeptments stored deptments_Specified;
    property fax:          WideString       Index (IS_OPTN or IS_NLBL) read Ffax write Setfax stored fax_Specified;
    property isvalidation: Integer          Index (IS_OPTN or IS_NLBL) read Fisvalidation write Setisvalidation stored isvalidation_Specified;
    property organalias:   WideString       Index (IS_OPTN or IS_NLBL) read Forganalias write Setorganalias stored organalias_Specified;
    property organcode:    WideString       Index (IS_OPTN or IS_NLBL) read Forgancode write Setorgancode stored organcode_Specified;
    property organid:      WideString       Index (IS_OPTN or IS_NLBL) read Forganid write Setorganid stored organid_Specified;
    property organman:     WideString       Index (IS_OPTN or IS_NLBL) read Forganman write Setorganman stored organman_Specified;
    property organmanid:   WideString       Index (IS_OPTN or IS_NLBL) read Forganmanid write Setorganmanid stored organmanid_Specified;
    property organname:    WideString       Index (IS_OPTN or IS_NLBL) read Forganname write Setorganname stored organname_Specified;
    property organs:       ArrayOfOrgan     Index (IS_OPTN or IS_NLBL) read Forgans write Setorgans stored organs_Specified;
    property porgan:       Organ            Index (IS_OPTN or IS_NLBL) read Fporgan write Setporgan stored porgan_Specified;
    property postcode:     WideString       Index (IS_OPTN or IS_NLBL) read Fpostcode write Setpostcode stored postcode_Specified;
    property remark:       WideString       Index (IS_OPTN or IS_NLBL) read Fremark write Setremark stored remark_Specified;
    property telephone:    WideString       Index (IS_OPTN or IS_NLBL) read Ftelephone write Settelephone stored telephone_Specified;
  end;



  // ************************************************************************ //
  // XML       : Workhistory, global, <complexType>
  // Namespace : http://domain.workhistory.oxhide.sxsihe.com
  // ************************************************************************ //
  Workhistory = class(TRemotable)
  private
    Fbegintime: WideString;
    Fbegintime_Specified: boolean;
    Fdept: WideString;
    Fdept_Specified: boolean;
    Fdeptid: WideString;
    Fdeptid_Specified: boolean;
    Femployee: Employee;
    Femployee_Specified: boolean;
    Fendtime: WideString;
    Fendtime_Specified: boolean;
    Fhid: WideString;
    Fhid_Specified: boolean;
    Forganid: WideString;
    Forganid_Specified: boolean;
    Forganname: WideString;
    Forganname_Specified: boolean;
    Fpost: WideString;
    Fpost_Specified: boolean;
    Fpostid: WideString;
    Fpostid_Specified: boolean;
    Fremark: WideString;
    Fremark_Specified: boolean;
    procedure Setbegintime(Index: Integer; const AWideString: WideString);
    function  begintime_Specified(Index: Integer): boolean;
    procedure Setdept(Index: Integer; const AWideString: WideString);
    function  dept_Specified(Index: Integer): boolean;
    procedure Setdeptid(Index: Integer; const AWideString: WideString);
    function  deptid_Specified(Index: Integer): boolean;
    procedure Setemployee(Index: Integer; const AEmployee: Employee);
    function  employee_Specified(Index: Integer): boolean;
    procedure Setendtime(Index: Integer; const AWideString: WideString);
    function  endtime_Specified(Index: Integer): boolean;
    procedure Sethid(Index: Integer; const AWideString: WideString);
    function  hid_Specified(Index: Integer): boolean;
    procedure Setorganid(Index: Integer; const AWideString: WideString);
    function  organid_Specified(Index: Integer): boolean;
    procedure Setorganname(Index: Integer; const AWideString: WideString);
    function  organname_Specified(Index: Integer): boolean;
    procedure Setpost(Index: Integer; const AWideString: WideString);
    function  post_Specified(Index: Integer): boolean;
    procedure Setpostid(Index: Integer; const AWideString: WideString);
    function  postid_Specified(Index: Integer): boolean;
    procedure Setremark(Index: Integer; const AWideString: WideString);
    function  remark_Specified(Index: Integer): boolean;
  public
    destructor Destroy; override;
  published
    property begintime: WideString  Index (IS_OPTN or IS_NLBL) read Fbegintime write Setbegintime stored begintime_Specified;
    property dept:      WideString  Index (IS_OPTN or IS_NLBL) read Fdept write Setdept stored dept_Specified;
    property deptid:    WideString  Index (IS_OPTN or IS_NLBL) read Fdeptid write Setdeptid stored deptid_Specified;
    property employee:  Employee    Index (IS_OPTN or IS_NLBL) read Femployee write Setemployee stored employee_Specified;
    property endtime:   WideString  Index (IS_OPTN or IS_NLBL) read Fendtime write Setendtime stored endtime_Specified;
    property hid:       WideString  Index (IS_OPTN or IS_NLBL) read Fhid write Sethid stored hid_Specified;
    property organid:   WideString  Index (IS_OPTN or IS_NLBL) read Forganid write Setorganid stored organid_Specified;
    property organname: WideString  Index (IS_OPTN or IS_NLBL) read Forganname write Setorganname stored organname_Specified;
    property post:      WideString  Index (IS_OPTN or IS_NLBL) read Fpost write Setpost stored post_Specified;
    property postid:    WideString  Index (IS_OPTN or IS_NLBL) read Fpostid write Setpostid stored postid_Specified;
    property remark:    WideString  Index (IS_OPTN or IS_NLBL) read Fremark write Setremark stored remark_Specified;
  end;



  // ************************************************************************ //
  // XML       : Unmobile, global, <complexType>
  // Namespace : http://domain.mobile.message.oxhide.sxsihe.com
  // ************************************************************************ //
  Unmobile = class(TRemotable)
  private
    Fapplication_: Application_;
    Fapplication__Specified: boolean;
    Femployee: Employee;
    Femployee_Specified: boolean;
    Fudate: WideString;
    Fudate_Specified: boolean;
    Funid: WideString;
    Funid_Specified: boolean;
    procedure Setapplication_(Index: Integer; const AApplication_: Application_);
    function  application__Specified(Index: Integer): boolean;
    procedure Setemployee(Index: Integer; const AEmployee: Employee);
    function  employee_Specified(Index: Integer): boolean;
    procedure Setudate(Index: Integer; const AWideString: WideString);
    function  udate_Specified(Index: Integer): boolean;
    procedure Setunid(Index: Integer; const AWideString: WideString);
    function  unid_Specified(Index: Integer): boolean;
  public
    destructor Destroy; override;
  published
    property application_: Application_  Index (IS_OPTN or IS_NLBL) read Fapplication_ write Setapplication_ stored application__Specified;
    property employee:     Employee      Index (IS_OPTN or IS_NLBL) read Femployee write Setemployee stored employee_Specified;
    property udate:        WideString    Index (IS_OPTN or IS_NLBL) read Fudate write Setudate stored udate_Specified;
    property unid:         WideString    Index (IS_OPTN or IS_NLBL) read Funid write Setunid stored unid_Specified;
  end;



  // ************************************************************************ //
  // XML       : Rolesapp, global, <complexType>
  // Namespace : http://domain.rolesapp.oxhide.sxsihe.com
  // ************************************************************************ //
  Rolesapp = class(TRemotable)
  private
    Fapplication_: Application_;
    Fapplication__Specified: boolean;
    Frolesappid: WideString;
    Frolesappid_Specified: boolean;
    Fssoroles: Ssoroles;
    Fssoroles_Specified: boolean;
    procedure Setapplication_(Index: Integer; const AApplication_: Application_);
    function  application__Specified(Index: Integer): boolean;
    procedure Setrolesappid(Index: Integer; const AWideString: WideString);
    function  rolesappid_Specified(Index: Integer): boolean;
    procedure Setssoroles(Index: Integer; const ASsoroles: Ssoroles);
    function  ssoroles_Specified(Index: Integer): boolean;
  public
    destructor Destroy; override;
  published
    property application_: Application_  Index (IS_OPTN or IS_NLBL) read Fapplication_ write Setapplication_ stored application__Specified;
    property rolesappid:   WideString    Index (IS_OPTN or IS_NLBL) read Frolesappid write Setrolesappid stored rolesappid_Specified;
    property ssoroles:     Ssoroles      Index (IS_OPTN or IS_NLBL) read Fssoroles write Setssoroles stored ssoroles_Specified;
  end;



  // ************************************************************************ //
  // XML       : Tokens, global, <complexType>
  // Namespace : http://domain.token.message.oxhide.sxsihe.com
  // ************************************************************************ //
  Tokens = class(TRemotable)
  private
    Fapplication_: Application_;
    Fapplication__Specified: boolean;
    Fssousers: Ssousers;
    Fssousers_Specified: boolean;
    Ftid: WideString;
    Ftid_Specified: boolean;
    Ftoken: WideString;
    Ftoken_Specified: boolean;
    Ftokentype: WideString;
    Ftokentype_Specified: boolean;
    procedure Setapplication_(Index: Integer; const AApplication_: Application_);
    function  application__Specified(Index: Integer): boolean;
    procedure Setssousers(Index: Integer; const ASsousers: Ssousers);
    function  ssousers_Specified(Index: Integer): boolean;
    procedure Settid(Index: Integer; const AWideString: WideString);
    function  tid_Specified(Index: Integer): boolean;
    procedure Settoken(Index: Integer; const AWideString: WideString);
    function  token_Specified(Index: Integer): boolean;
    procedure Settokentype(Index: Integer; const AWideString: WideString);
    function  tokentype_Specified(Index: Integer): boolean;
  public
    destructor Destroy; override;
  published
    property application_: Application_  Index (IS_OPTN or IS_NLBL) read Fapplication_ write Setapplication_ stored application__Specified;
    property ssousers:     Ssousers      Index (IS_OPTN or IS_NLBL) read Fssousers write Setssousers stored ssousers_Specified;
    property tid:          WideString    Index (IS_OPTN or IS_NLBL) read Ftid write Settid stored tid_Specified;
    property token:        WideString    Index (IS_OPTN or IS_NLBL) read Ftoken write Settoken stored token_Specified;
    property tokentype:    WideString    Index (IS_OPTN or IS_NLBL) read Ftokentype write Settokentype stored tokentype_Specified;
  end;



  // ************************************************************************ //
  // XML       : InputStream, global, <complexType>
  // Namespace : http://io.java
  // ************************************************************************ //
  InputStream = class(TRemotable)
  private
  published
  end;



  // ************************************************************************ //
  // XML       : Educationhistory, global, <complexType>
  // Namespace : http://domain.educationhistory.oxhide.sxsihe.com
  // ************************************************************************ //
  Educationhistory = class(TRemotable)
  private
    Fcertificate: WideString;
    Fcertificate_Specified: boolean;
    Feducation: WideString;
    Feducation_Specified: boolean;
    Fedutype: WideString;
    Fedutype_Specified: boolean;
    Feid: WideString;
    Feid_Specified: boolean;
    Femployee: Employee;
    Femployee_Specified: boolean;
    Fgraduation: WideString;
    Fgraduation_Specified: boolean;
    Fprofessional: WideString;
    Fprofessional_Specified: boolean;
    Fschoolname: WideString;
    Fschoolname_Specified: boolean;
    procedure Setcertificate(Index: Integer; const AWideString: WideString);
    function  certificate_Specified(Index: Integer): boolean;
    procedure Seteducation(Index: Integer; const AWideString: WideString);
    function  education_Specified(Index: Integer): boolean;
    procedure Setedutype(Index: Integer; const AWideString: WideString);
    function  edutype_Specified(Index: Integer): boolean;
    procedure Seteid(Index: Integer; const AWideString: WideString);
    function  eid_Specified(Index: Integer): boolean;
    procedure Setemployee(Index: Integer; const AEmployee: Employee);
    function  employee_Specified(Index: Integer): boolean;
    procedure Setgraduation(Index: Integer; const AWideString: WideString);
    function  graduation_Specified(Index: Integer): boolean;
    procedure Setprofessional(Index: Integer; const AWideString: WideString);
    function  professional_Specified(Index: Integer): boolean;
    procedure Setschoolname(Index: Integer; const AWideString: WideString);
    function  schoolname_Specified(Index: Integer): boolean;
  public
    destructor Destroy; override;
  published
    property certificate:  WideString  Index (IS_OPTN or IS_NLBL) read Fcertificate write Setcertificate stored certificate_Specified;
    property education:    WideString  Index (IS_OPTN or IS_NLBL) read Feducation write Seteducation stored education_Specified;
    property edutype:      WideString  Index (IS_OPTN or IS_NLBL) read Fedutype write Setedutype stored edutype_Specified;
    property eid:          WideString  Index (IS_OPTN or IS_NLBL) read Feid write Seteid stored eid_Specified;
    property employee:     Employee    Index (IS_OPTN or IS_NLBL) read Femployee write Setemployee stored employee_Specified;
    property graduation:   WideString  Index (IS_OPTN or IS_NLBL) read Fgraduation write Setgraduation stored graduation_Specified;
    property professional: WideString  Index (IS_OPTN or IS_NLBL) read Fprofessional write Setprofessional stored professional_Specified;
    property schoolname:   WideString  Index (IS_OPTN or IS_NLBL) read Fschoolname write Setschoolname stored schoolname_Specified;
  end;



  // ************************************************************************ //
  // XML       : Commonmenus, global, <complexType>
  // Namespace : http://domain.commonmenus.imenus.oxhide.sxsihe.com
  // ************************************************************************ //
  Commonmenus = class(TRemotable)
  private
    Fcid: WideString;
    Fcid_Specified: boolean;
    Fresources: Resources;
    Fresources_Specified: boolean;
    Fssousers: Ssousers;
    Fssousers_Specified: boolean;
    procedure Setcid(Index: Integer; const AWideString: WideString);
    function  cid_Specified(Index: Integer): boolean;
    procedure Setresources(Index: Integer; const AResources: Resources);
    function  resources_Specified(Index: Integer): boolean;
    procedure Setssousers(Index: Integer; const ASsousers: Ssousers);
    function  ssousers_Specified(Index: Integer): boolean;
  public
    destructor Destroy; override;
  published
    property cid:       WideString  Index (IS_OPTN or IS_NLBL) read Fcid write Setcid stored cid_Specified;
    property resources: Resources   Index (IS_OPTN or IS_NLBL) read Fresources write Setresources stored resources_Specified;
    property ssousers:  Ssousers    Index (IS_OPTN or IS_NLBL) read Fssousers write Setssousers stored ssousers_Specified;
  end;


  // ************************************************************************ //
  // Namespace : http://resource.server.oxhide.sxsihe.com
  // transport : http://schemas.xmlsoap.org/soap/http
  // style     : document
  // binding   : ResourceServerHttpBinding
  // service   : ResourceServer
  // port      : ResourceServerHttpPort
  // URL       : http://127.0.0.1:8081/oxhide/services/ResourceServer
  // ************************************************************************ //
  ResourceServerPortType = interface(IInvokable)
  ['{08E45933-64DD-BFBC-A3FF-9493EE040876}']
    function  queryHql(const in0: WideString): ArrayOfResources; stdcall;
    function  findObjectBykey(const in0: WideString): Resources; stdcall;
    procedure delete(const in0: WideString); stdcall;
    function  getAll: ArrayOfResources; stdcall;
    function  findObjectsByCondition(const in0: ConditionBlock; const in1: anyType2booleanMap): ArrayOfResources; stdcall;
    procedure add(const in0: Resources); stdcall;
    procedure add1(const in0: WideString; const in1: WideString; const in2: WideString; const in3: WideString; const in4: WideString); stdcall;
  end;

function GetResourceServerPortType(UseWSDL: Boolean=System.False; Addr: string=''; HTTPRIO: THTTPRIO = nil): ResourceServerPortType;


implementation
  uses SysUtils;

function GetResourceServerPortType(UseWSDL: Boolean; Addr: string; HTTPRIO: THTTPRIO): ResourceServerPortType;
const
  defWSDL = 'http://127.0.0.1:8081/oxhide/services/ResourceServer?wsdl';
  defURL  = 'http://127.0.0.1:8081/oxhide/services/ResourceServer';
  defSvc  = 'ResourceServer';
  defPrt  = 'ResourceServerHttpPort';
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
    Result := (RIO as ResourceServerPortType);
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


procedure entry.Setkey(Index: Integer; const AVariant: Variant);
begin
  Fkey := AVariant;
  Fkey_Specified := True;
end;

function entry.key_Specified(Index: Integer): boolean;
begin
  Result := Fkey_Specified;
end;

procedure entry.Setvalue(Index: Integer; const AVariant: Variant);
begin
  Fvalue := AVariant;
  Fvalue_Specified := True;
end;

function entry.value_Specified(Index: Integer): boolean;
begin
  Result := Fvalue_Specified;
end;

procedure entry2.Setkey(Index: Integer; const AVariant: Variant);
begin
  Fkey := AVariant;
  Fkey_Specified := True;
end;

function entry2.key_Specified(Index: Integer): boolean;
begin
  Result := Fkey_Specified;
end;

procedure entry2.Setvalue(Index: Integer; const ABoolean: Boolean);
begin
  Fvalue := ABoolean;
  Fvalue_Specified := True;
end;

function entry2.value_Specified(Index: Integer): boolean;
begin
  Result := Fvalue_Specified;
end;

destructor ConditionBlock.Destroy;
var
  I: Integer;
begin
  for I := 0 to Length(Fmap)-1 do
    FreeAndNil(Fmap[I]);
  SetLength(Fmap, 0);
  inherited Destroy;
end;

procedure ConditionBlock.SetHQL(Index: Integer; const AWideString: WideString);
begin
  FHQL := AWideString;
  FHQL_Specified := True;
end;

function ConditionBlock.HQL_Specified(Index: Integer): boolean;
begin
  Result := FHQL_Specified;
end;

procedure ConditionBlock.Setmap(Index: Integer; const AanyType2anyTypeMap: anyType2anyTypeMap);
begin
  Fmap := AanyType2anyTypeMap;
  Fmap_Specified := True;
end;

function ConditionBlock.map_Specified(Index: Integer): boolean;
begin
  Result := Fmap_Specified;
end;

procedure ConditionBlock.Setselects(Index: Integer; const AArrayOfString: ArrayOfString);
begin
  Fselects := AArrayOfString;
  Fselects_Specified := True;
end;

function ConditionBlock.selects_Specified(Index: Integer): boolean;
begin
  Result := Fselects_Specified;
end;

destructor Resources.Destroy;
var
  I: Integer;
begin
  for I := 0 to Length(Fcommonmenus)-1 do
    FreeAndNil(Fcommonmenus[I]);
  SetLength(Fcommonmenus, 0);
  for I := 0 to Length(Fresourcees)-1 do
    FreeAndNil(Fresourcees[I]);
  SetLength(Fresourcees, 0);
  for I := 0 to Length(Frolesresourceses)-1 do
    FreeAndNil(Frolesresourceses[I]);
  SetLength(Frolesresourceses, 0);
  FreeAndNil(Fapplication_);
  FreeAndNil(Fresourcesp);
  inherited Destroy;
end;

procedure Resources.Setapplication_(Index: Integer; const AApplication_: Application_);
begin
  Fapplication_ := AApplication_;
  Fapplication__Specified := True;
end;

function Resources.application__Specified(Index: Integer): boolean;
begin
  Result := Fapplication__Specified;
end;

procedure Resources.Setbigico(Index: Integer; const AWideString: WideString);
begin
  Fbigico := AWideString;
  Fbigico_Specified := True;
end;

function Resources.bigico_Specified(Index: Integer): boolean;
begin
  Result := Fbigico_Specified;
end;

procedure Resources.Setcommonmenus(Index: Integer; const AArrayOfCommonmenus: ArrayOfCommonmenus);
begin
  Fcommonmenus := AArrayOfCommonmenus;
  Fcommonmenus_Specified := True;
end;

function Resources.commonmenus_Specified(Index: Integer): boolean;
begin
  Result := Fcommonmenus_Specified;
end;

procedure Resources.Setdisplay(Index: Integer; const AInteger: Integer);
begin
  Fdisplay := AInteger;
  Fdisplay_Specified := True;
end;

function Resources.display_Specified(Index: Integer): boolean;
begin
  Result := Fdisplay_Specified;
end;

procedure Resources.SetdisplayAppId(Index: Integer; const AWideString: WideString);
begin
  FdisplayAppId := AWideString;
  FdisplayAppId_Specified := True;
end;

function Resources.displayAppId_Specified(Index: Integer): boolean;
begin
  Result := FdisplayAppId_Specified;
end;

procedure Resources.SetdisplayPId(Index: Integer; const AWideString: WideString);
begin
  FdisplayPId := AWideString;
  FdisplayPId_Specified := True;
end;

function Resources.displayPId_Specified(Index: Integer): boolean;
begin
  Result := FdisplayPId_Specified;
end;

procedure Resources.Setico(Index: Integer; const AWideString: WideString);
begin
  Fico := AWideString;
  Fico_Specified := True;
end;

function Resources.ico_Specified(Index: Integer): boolean;
begin
  Result := Fico_Specified;
end;

procedure Resources.Setisvalidation(Index: Integer; const AWideString: WideString);
begin
  Fisvalidation := AWideString;
  Fisvalidation_Specified := True;
end;

function Resources.isvalidation_Specified(Index: Integer): boolean;
begin
  Result := Fisvalidation_Specified;
end;

procedure Resources.Setlargeico(Index: Integer; const AWideString: WideString);
begin
  Flargeico := AWideString;
  Flargeico_Specified := True;
end;

function Resources.largeico_Specified(Index: Integer): boolean;
begin
  Result := Flargeico_Specified;
end;

procedure Resources.Setmenutype(Index: Integer; const AInteger: Integer);
begin
  Fmenutype := AInteger;
  Fmenutype_Specified := True;
end;

function Resources.menutype_Specified(Index: Integer): boolean;
begin
  Result := Fmenutype_Specified;
end;

procedure Resources.Setmobileico(Index: Integer; const AWideString: WideString);
begin
  Fmobileico := AWideString;
  Fmobileico_Specified := True;
end;

function Resources.mobileico_Specified(Index: Integer): boolean;
begin
  Result := Fmobileico_Specified;
end;

procedure Resources.Setmobileurl(Index: Integer; const AWideString: WideString);
begin
  Fmobileurl := AWideString;
  Fmobileurl_Specified := True;
end;

function Resources.mobileurl_Specified(Index: Integer): boolean;
begin
  Result := Fmobileurl_Specified;
end;

procedure Resources.Setorderno(Index: Integer; const AInteger: Integer);
begin
  Forderno := AInteger;
  Forderno_Specified := True;
end;

function Resources.orderno_Specified(Index: Integer): boolean;
begin
  Result := Forderno_Specified;
end;

procedure Resources.Setprompt(Index: Integer; const AWideString: WideString);
begin
  Fprompt := AWideString;
  Fprompt_Specified := True;
end;

function Resources.prompt_Specified(Index: Integer): boolean;
begin
  Result := Fprompt_Specified;
end;

procedure Resources.Setremark(Index: Integer; const AWideString: WideString);
begin
  Fremark := AWideString;
  Fremark_Specified := True;
end;

function Resources.remark_Specified(Index: Integer): boolean;
begin
  Result := Fremark_Specified;
end;

procedure Resources.Setresourcecode(Index: Integer; const AWideString: WideString);
begin
  Fresourcecode := AWideString;
  Fresourcecode_Specified := True;
end;

function Resources.resourcecode_Specified(Index: Integer): boolean;
begin
  Result := Fresourcecode_Specified;
end;

procedure Resources.Setresourcees(Index: Integer; const AArrayOfResources: ArrayOfResources);
begin
  Fresourcees := AArrayOfResources;
  Fresourcees_Specified := True;
end;

function Resources.resourcees_Specified(Index: Integer): boolean;
begin
  Result := Fresourcees_Specified;
end;

procedure Resources.Setresourceid(Index: Integer; const AWideString: WideString);
begin
  Fresourceid := AWideString;
  Fresourceid_Specified := True;
end;

function Resources.resourceid_Specified(Index: Integer): boolean;
begin
  Result := Fresourceid_Specified;
end;

procedure Resources.Setresourcename(Index: Integer; const AWideString: WideString);
begin
  Fresourcename := AWideString;
  Fresourcename_Specified := True;
end;

function Resources.resourcename_Specified(Index: Integer): boolean;
begin
  Result := Fresourcename_Specified;
end;

procedure Resources.Setresourcesp(Index: Integer; const AResources: Resources);
begin
  Fresourcesp := AResources;
  Fresourcesp_Specified := True;
end;

function Resources.resourcesp_Specified(Index: Integer): boolean;
begin
  Result := Fresourcesp_Specified;
end;

procedure Resources.Setresourceurl(Index: Integer; const AWideString: WideString);
begin
  Fresourceurl := AWideString;
  Fresourceurl_Specified := True;
end;

function Resources.resourceurl_Specified(Index: Integer): boolean;
begin
  Result := Fresourceurl_Specified;
end;

procedure Resources.Setrolesresourceses(Index: Integer; const AArrayOfRolesresources: ArrayOfRolesresources);
begin
  Frolesresourceses := AArrayOfRolesresources;
  Frolesresourceses_Specified := True;
end;

function Resources.rolesresourceses_Specified(Index: Integer): boolean;
begin
  Result := Frolesresourceses_Specified;
end;

procedure Resources.Setselfclick(Index: Integer; const AWideString: WideString);
begin
  Fselfclick := AWideString;
  Fselfclick_Specified := True;
end;

function Resources.selfclick_Specified(Index: Integer): boolean;
begin
  Result := Fselfclick_Specified;
end;

procedure Resources.Setsimplyname(Index: Integer; const AWideString: WideString);
begin
  Fsimplyname := AWideString;
  Fsimplyname_Specified := True;
end;

function Resources.simplyname_Specified(Index: Integer): boolean;
begin
  Result := Fsimplyname_Specified;
end;

procedure Resources.Settabname(Index: Integer; const AWideString: WideString);
begin
  Ftabname := AWideString;
  Ftabname_Specified := True;
end;

function Resources.tabname_Specified(Index: Integer): boolean;
begin
  Result := Ftabname_Specified;
end;

procedure Resources.Settarget(Index: Integer; const AInteger: Integer);
begin
  Ftarget := AInteger;
  Ftarget_Specified := True;
end;

function Resources.target_Specified(Index: Integer): boolean;
begin
  Result := Ftarget_Specified;
end;

destructor Rolesresources.Destroy;
begin
  FreeAndNil(Fresources);
  FreeAndNil(Fssoroles);
  inherited Destroy;
end;

procedure Rolesresources.Setresourceroleid(Index: Integer; const AWideString: WideString);
begin
  Fresourceroleid := AWideString;
  Fresourceroleid_Specified := True;
end;

function Rolesresources.resourceroleid_Specified(Index: Integer): boolean;
begin
  Result := Fresourceroleid_Specified;
end;

procedure Rolesresources.Setresources(Index: Integer; const AResources: Resources);
begin
  Fresources := AResources;
  Fresources_Specified := True;
end;

function Rolesresources.resources_Specified(Index: Integer): boolean;
begin
  Result := Fresources_Specified;
end;

procedure Rolesresources.Setssoroles(Index: Integer; const ASsoroles: Ssoroles);
begin
  Fssoroles := ASsoroles;
  Fssoroles_Specified := True;
end;

function Rolesresources.ssoroles_Specified(Index: Integer): boolean;
begin
  Result := Fssoroles_Specified;
end;

destructor Ssoroles.Destroy;
var
  I: Integer;
begin
  for I := 0 to Length(Frolesapp)-1 do
    FreeAndNil(Frolesapp[I]);
  SetLength(Frolesapp, 0);
  for I := 0 to Length(Frolesresourceses)-1 do
    FreeAndNil(Frolesresourceses[I]);
  SetLength(Frolesresourceses, 0);
  for I := 0 to Length(Fusersroleses)-1 do
    FreeAndNil(Fusersroleses[I]);
  SetLength(Fusersroleses, 0);
  inherited Destroy;
end;

procedure Ssoroles.Setisvalidation(Index: Integer; const AInteger: Integer);
begin
  Fisvalidation := AInteger;
  Fisvalidation_Specified := True;
end;

function Ssoroles.isvalidation_Specified(Index: Integer): boolean;
begin
  Result := Fisvalidation_Specified;
end;

procedure Ssoroles.Setremark(Index: Integer; const AWideString: WideString);
begin
  Fremark := AWideString;
  Fremark_Specified := True;
end;

function Ssoroles.remark_Specified(Index: Integer): boolean;
begin
  Result := Fremark_Specified;
end;

procedure Ssoroles.Setrolecode(Index: Integer; const AWideString: WideString);
begin
  Frolecode := AWideString;
  Frolecode_Specified := True;
end;

function Ssoroles.rolecode_Specified(Index: Integer): boolean;
begin
  Result := Frolecode_Specified;
end;

procedure Ssoroles.Setroleid(Index: Integer; const AWideString: WideString);
begin
  Froleid := AWideString;
  Froleid_Specified := True;
end;

function Ssoroles.roleid_Specified(Index: Integer): boolean;
begin
  Result := Froleid_Specified;
end;

procedure Ssoroles.Setrolename(Index: Integer; const AWideString: WideString);
begin
  Frolename := AWideString;
  Frolename_Specified := True;
end;

function Ssoroles.rolename_Specified(Index: Integer): boolean;
begin
  Result := Frolename_Specified;
end;

procedure Ssoroles.Setrolesapp(Index: Integer; const AArrayOfRolesapp: ArrayOfRolesapp);
begin
  Frolesapp := AArrayOfRolesapp;
  Frolesapp_Specified := True;
end;

function Ssoroles.rolesapp_Specified(Index: Integer): boolean;
begin
  Result := Frolesapp_Specified;
end;

procedure Ssoroles.Setrolesresourceses(Index: Integer; const AArrayOfRolesresources: ArrayOfRolesresources);
begin
  Frolesresourceses := AArrayOfRolesresources;
  Frolesresourceses_Specified := True;
end;

function Ssoroles.rolesresourceses_Specified(Index: Integer): boolean;
begin
  Result := Frolesresourceses_Specified;
end;

procedure Ssoroles.Setusersroleses(Index: Integer; const AArrayOfUsersroles: ArrayOfUsersroles);
begin
  Fusersroleses := AArrayOfUsersroles;
  Fusersroleses_Specified := True;
end;

function Ssoroles.usersroleses_Specified(Index: Integer): boolean;
begin
  Result := Fusersroleses_Specified;
end;

destructor Usersroles.Destroy;
begin
  FreeAndNil(Fssoroles);
  FreeAndNil(Fssousers);
  inherited Destroy;
end;

procedure Usersroles.Setssoroles(Index: Integer; const ASsoroles: Ssoroles);
begin
  Fssoroles := ASsoroles;
  Fssoroles_Specified := True;
end;

function Usersroles.ssoroles_Specified(Index: Integer): boolean;
begin
  Result := Fssoroles_Specified;
end;

procedure Usersroles.Setssousers(Index: Integer; const ASsousers: Ssousers);
begin
  Fssousers := ASsousers;
  Fssousers_Specified := True;
end;

function Usersroles.ssousers_Specified(Index: Integer): boolean;
begin
  Result := Fssousers_Specified;
end;

procedure Usersroles.Setuserroleid(Index: Integer; const AWideString: WideString);
begin
  Fuserroleid := AWideString;
  Fuserroleid_Specified := True;
end;

function Usersroles.userroleid_Specified(Index: Integer): boolean;
begin
  Result := Fuserroleid_Specified;
end;

destructor Ssousers.Destroy;
var
  I: Integer;
begin
  for I := 0 to Length(Fboxmenus)-1 do
    FreeAndNil(Fboxmenus[I]);
  SetLength(Fboxmenus, 0);
  for I := 0 to Length(Fcommonmenus)-1 do
    FreeAndNil(Fcommonmenus[I]);
  SetLength(Fcommonmenus, 0);
  for I := 0 to Length(Ftokens)-1 do
    FreeAndNil(Ftokens[I]);
  SetLength(Ftokens, 0);
  for I := 0 to Length(Fusersroleses)-1 do
    FreeAndNil(Fusersroleses[I]);
  SetLength(Fusersroleses, 0);
  FreeAndNil(Femployee);
  inherited Destroy;
end;

procedure Ssousers.Setandroid(Index: Integer; const AWideString: WideString);
begin
  Fandroid := AWideString;
  Fandroid_Specified := True;
end;

function Ssousers.android_Specified(Index: Integer): boolean;
begin
  Result := Fandroid_Specified;
end;

procedure Ssousers.Setapple(Index: Integer; const AWideString: WideString);
begin
  Fapple := AWideString;
  Fapple_Specified := True;
end;

function Ssousers.apple_Specified(Index: Integer): boolean;
begin
  Result := Fapple_Specified;
end;

procedure Ssousers.Setboxmenus(Index: Integer; const AArrayOfBoxmenus: ArrayOfBoxmenus);
begin
  Fboxmenus := AArrayOfBoxmenus;
  Fboxmenus_Specified := True;
end;

function Ssousers.boxmenus_Specified(Index: Integer): boolean;
begin
  Result := Fboxmenus_Specified;
end;

procedure Ssousers.Setcommonmenus(Index: Integer; const AArrayOfCommonmenus: ArrayOfCommonmenus);
begin
  Fcommonmenus := AArrayOfCommonmenus;
  Fcommonmenus_Specified := True;
end;

function Ssousers.commonmenus_Specified(Index: Integer): boolean;
begin
  Result := Fcommonmenus_Specified;
end;

procedure Ssousers.Setdesk(Index: Integer; const AWideString: WideString);
begin
  Fdesk := AWideString;
  Fdesk_Specified := True;
end;

function Ssousers.desk_Specified(Index: Integer): boolean;
begin
  Result := Fdesk_Specified;
end;

procedure Ssousers.SetdeskType(Index: Integer; const AWideString: WideString);
begin
  FdeskType := AWideString;
  FdeskType_Specified := True;
end;

function Ssousers.deskType_Specified(Index: Integer): boolean;
begin
  Result := FdeskType_Specified;
end;

procedure Ssousers.Setemployee(Index: Integer; const AEmployee: Employee);
begin
  Femployee := AEmployee;
  Femployee_Specified := True;
end;

function Ssousers.employee_Specified(Index: Integer): boolean;
begin
  Result := Femployee_Specified;
end;

procedure Ssousers.Setfacestyle(Index: Integer; const AWideString: WideString);
begin
  Ffacestyle := AWideString;
  Ffacestyle_Specified := True;
end;

function Ssousers.facestyle_Specified(Index: Integer): boolean;
begin
  Result := Ffacestyle_Specified;
end;

procedure Ssousers.Setissingel(Index: Integer; const AInteger: Integer);
begin
  Fissingel := AInteger;
  Fissingel_Specified := True;
end;

function Ssousers.issingel_Specified(Index: Integer): boolean;
begin
  Result := Fissingel_Specified;
end;

procedure Ssousers.Setisvalidation(Index: Integer; const AInteger: Integer);
begin
  Fisvalidation := AInteger;
  Fisvalidation_Specified := True;
end;

function Ssousers.isvalidation_Specified(Index: Integer): boolean;
begin
  Result := Fisvalidation_Specified;
end;

procedure Ssousers.Setpassword(Index: Integer; const AWideString: WideString);
begin
  Fpassword := AWideString;
  Fpassword_Specified := True;
end;

function Ssousers.password_Specified(Index: Integer): boolean;
begin
  Result := Fpassword_Specified;
end;

procedure Ssousers.Settokens(Index: Integer; const AArrayOfTokens: ArrayOfTokens);
begin
  Ftokens := AArrayOfTokens;
  Ftokens_Specified := True;
end;

function Ssousers.tokens_Specified(Index: Integer): boolean;
begin
  Result := Ftokens_Specified;
end;

procedure Ssousers.Setuserid(Index: Integer; const AWideString: WideString);
begin
  Fuserid := AWideString;
  Fuserid_Specified := True;
end;

function Ssousers.userid_Specified(Index: Integer): boolean;
begin
  Result := Fuserid_Specified;
end;

procedure Ssousers.Setusername(Index: Integer; const AWideString: WideString);
begin
  Fusername := AWideString;
  Fusername_Specified := True;
end;

function Ssousers.username_Specified(Index: Integer): boolean;
begin
  Result := Fusername_Specified;
end;

procedure Ssousers.Setusersroleses(Index: Integer; const AArrayOfUsersroles: ArrayOfUsersroles);
begin
  Fusersroleses := AArrayOfUsersroles;
  Fusersroleses_Specified := True;
end;

function Ssousers.usersroleses_Specified(Index: Integer): boolean;
begin
  Result := Fusersroleses_Specified;
end;

destructor Boxmenus.Destroy;
begin
  FreeAndNil(Fssousers);
  inherited Destroy;
end;

procedure Boxmenus.Setbid(Index: Integer; const AWideString: WideString);
begin
  Fbid := AWideString;
  Fbid_Specified := True;
end;

function Boxmenus.bid_Specified(Index: Integer): boolean;
begin
  Result := Fbid_Specified;
end;

procedure Boxmenus.Setmenuname(Index: Integer; const AWideString: WideString);
begin
  Fmenuname := AWideString;
  Fmenuname_Specified := True;
end;

function Boxmenus.menuname_Specified(Index: Integer): boolean;
begin
  Result := Fmenuname_Specified;
end;

procedure Boxmenus.Setmenuurl(Index: Integer; const AWideString: WideString);
begin
  Fmenuurl := AWideString;
  Fmenuurl_Specified := True;
end;

function Boxmenus.menuurl_Specified(Index: Integer): boolean;
begin
  Result := Fmenuurl_Specified;
end;

procedure Boxmenus.Setssousers(Index: Integer; const ASsousers: Ssousers);
begin
  Fssousers := ASsousers;
  Fssousers_Specified := True;
end;

function Boxmenus.ssousers_Specified(Index: Integer): boolean;
begin
  Result := Fssousers_Specified;
end;

destructor Blob.Destroy;
begin
  FreeAndNil(FbinaryStream);
  inherited Destroy;
end;

procedure Blob.SetbinaryStream(Index: Integer; const AInputStream: InputStream);
begin
  FbinaryStream := AInputStream;
  FbinaryStream_Specified := True;
end;

function Blob.binaryStream_Specified(Index: Integer): boolean;
begin
  Result := FbinaryStream_Specified;
end;

destructor Application_.Destroy;
var
  I: Integer;
begin
  for I := 0 to Length(Fresources)-1 do
    FreeAndNil(Fresources[I]);
  SetLength(Fresources, 0);
  for I := 0 to Length(Frolesapp)-1 do
    FreeAndNil(Frolesapp[I]);
  SetLength(Frolesapp, 0);
  for I := 0 to Length(Ftokens)-1 do
    FreeAndNil(Ftokens[I]);
  SetLength(Ftokens, 0);
  for I := 0 to Length(Funmobiles)-1 do
    FreeAndNil(Funmobiles[I]);
  SetLength(Funmobiles, 0);
  inherited Destroy;
end;

procedure Application_.Setandroidkey(Index: Integer; const AWideString: WideString);
begin
  Fandroidkey := AWideString;
  Fandroidkey_Specified := True;
end;

function Application_.androidkey_Specified(Index: Integer): boolean;
begin
  Result := Fandroidkey_Specified;
end;

procedure Application_.Setandroidkf(Index: Integer; const AWideString: WideString);
begin
  Fandroidkf := AWideString;
  Fandroidkf_Specified := True;
end;

function Application_.androidkf_Specified(Index: Integer): boolean;
begin
  Result := Fandroidkf_Specified;
end;

procedure Application_.Setappcode(Index: Integer; const AWideString: WideString);
begin
  Fappcode := AWideString;
  Fappcode_Specified := True;
end;

function Application_.appcode_Specified(Index: Integer): boolean;
begin
  Result := Fappcode_Specified;
end;

procedure Application_.Setappid(Index: Integer; const AWideString: WideString);
begin
  Fappid := AWideString;
  Fappid_Specified := True;
end;

function Application_.appid_Specified(Index: Integer): boolean;
begin
  Result := Fappid_Specified;
end;

procedure Application_.Setappindex(Index: Integer; const AWideString: WideString);
begin
  Fappindex := AWideString;
  Fappindex_Specified := True;
end;

function Application_.appindex_Specified(Index: Integer): boolean;
begin
  Result := Fappindex_Specified;
end;

procedure Application_.Setapplekey(Index: Integer; const AWideString: WideString);
begin
  Fapplekey := AWideString;
  Fapplekey_Specified := True;
end;

function Application_.applekey_Specified(Index: Integer): boolean;
begin
  Result := Fapplekey_Specified;
end;

procedure Application_.Setapplekf(Index: Integer; const AWideString: WideString);
begin
  Fapplekf := AWideString;
  Fapplekf_Specified := True;
end;

function Application_.applekf_Specified(Index: Integer): boolean;
begin
  Result := Fapplekf_Specified;
end;

procedure Application_.Setappname(Index: Integer; const AWideString: WideString);
begin
  Fappname := AWideString;
  Fappname_Specified := True;
end;

function Application_.appname_Specified(Index: Integer): boolean;
begin
  Result := Fappname_Specified;
end;

procedure Application_.Setapptitle(Index: Integer; const AWideString: WideString);
begin
  Fapptitle := AWideString;
  Fapptitle_Specified := True;
end;

function Application_.apptitle_Specified(Index: Integer): boolean;
begin
  Result := Fapptitle_Specified;
end;

procedure Application_.Setappurl(Index: Integer; const AWideString: WideString);
begin
  Fappurl := AWideString;
  Fappurl_Specified := True;
end;

function Application_.appurl_Specified(Index: Integer): boolean;
begin
  Result := Fappurl_Specified;
end;

procedure Application_.Setappurlw(Index: Integer; const AWideString: WideString);
begin
  Fappurlw := AWideString;
  Fappurlw_Specified := True;
end;

function Application_.appurlw_Specified(Index: Integer): boolean;
begin
  Result := Fappurlw_Specified;
end;

procedure Application_.Setbigico(Index: Integer; const AWideString: WideString);
begin
  Fbigico := AWideString;
  Fbigico_Specified := True;
end;

function Application_.bigico_Specified(Index: Integer): boolean;
begin
  Result := Fbigico_Specified;
end;

procedure Application_.Setico(Index: Integer; const AWideString: WideString);
begin
  Fico := AWideString;
  Fico_Specified := True;
end;

function Application_.ico_Specified(Index: Integer): boolean;
begin
  Result := Fico_Specified;
end;

procedure Application_.Setlargeico(Index: Integer; const AWideString: WideString);
begin
  Flargeico := AWideString;
  Flargeico_Specified := True;
end;

function Application_.largeico_Specified(Index: Integer): boolean;
begin
  Result := Flargeico_Specified;
end;

procedure Application_.Setorderno(Index: Integer; const AInteger: Integer);
begin
  Forderno := AInteger;
  Forderno_Specified := True;
end;

function Application_.orderno_Specified(Index: Integer): boolean;
begin
  Result := Forderno_Specified;
end;

procedure Application_.Setremark(Index: Integer; const AWideString: WideString);
begin
  Fremark := AWideString;
  Fremark_Specified := True;
end;

function Application_.remark_Specified(Index: Integer): boolean;
begin
  Result := Fremark_Specified;
end;

procedure Application_.Setresources(Index: Integer; const AArrayOfResources: ArrayOfResources);
begin
  Fresources := AArrayOfResources;
  Fresources_Specified := True;
end;

function Application_.resources_Specified(Index: Integer): boolean;
begin
  Result := Fresources_Specified;
end;

procedure Application_.Setrolesapp(Index: Integer; const AArrayOfRolesapp: ArrayOfRolesapp);
begin
  Frolesapp := AArrayOfRolesapp;
  Frolesapp_Specified := True;
end;

function Application_.rolesapp_Specified(Index: Integer): boolean;
begin
  Result := Frolesapp_Specified;
end;

procedure Application_.Setsimplyname(Index: Integer; const AWideString: WideString);
begin
  Fsimplyname := AWideString;
  Fsimplyname_Specified := True;
end;

function Application_.simplyname_Specified(Index: Integer): boolean;
begin
  Result := Fsimplyname_Specified;
end;

procedure Application_.Settimeenable(Index: Integer; const AWideString: WideString);
begin
  Ftimeenable := AWideString;
  Ftimeenable_Specified := True;
end;

function Application_.timeenable_Specified(Index: Integer): boolean;
begin
  Result := Ftimeenable_Specified;
end;

procedure Application_.Settimer(Index: Integer; const AWideString: WideString);
begin
  Ftimer := AWideString;
  Ftimer_Specified := True;
end;

function Application_.timer_Specified(Index: Integer): boolean;
begin
  Result := Ftimer_Specified;
end;

procedure Application_.Settimes(Index: Integer; const AWideString: WideString);
begin
  Ftimes := AWideString;
  Ftimes_Specified := True;
end;

function Application_.times_Specified(Index: Integer): boolean;
begin
  Result := Ftimes_Specified;
end;

procedure Application_.Settokens(Index: Integer; const AArrayOfTokens: ArrayOfTokens);
begin
  Ftokens := AArrayOfTokens;
  Ftokens_Specified := True;
end;

function Application_.tokens_Specified(Index: Integer): boolean;
begin
  Result := Ftokens_Specified;
end;

procedure Application_.Setunmobiles(Index: Integer; const AArrayOfUnmobile: ArrayOfUnmobile);
begin
  Funmobiles := AArrayOfUnmobile;
  Funmobiles_Specified := True;
end;

function Application_.unmobiles_Specified(Index: Integer): boolean;
begin
  Result := Funmobiles_Specified;
end;

destructor Employee.Destroy;
var
  I: Integer;
begin
  for I := 0 to Length(Feducationhistory)-1 do
    FreeAndNil(Feducationhistory[I]);
  SetLength(Feducationhistory, 0);
  for I := 0 to Length(Fssouserses)-1 do
    FreeAndNil(Fssouserses[I]);
  SetLength(Fssouserses, 0);
  for I := 0 to Length(Funmobiles)-1 do
    FreeAndNil(Funmobiles[I]);
  SetLength(Funmobiles, 0);
  for I := 0 to Length(Fworkhistory)-1 do
    FreeAndNil(Fworkhistory[I]);
  SetLength(Fworkhistory, 0);
  FreeAndNil(Fpen);
  FreeAndNil(Fphoto);
  FreeAndNil(Fposts);
  inherited Destroy;
end;

procedure Employee.Setaccount(Index: Integer; const AWideString: WideString);
begin
  Faccount := AWideString;
  Faccount_Specified := True;
end;

function Employee.account_Specified(Index: Integer): boolean;
begin
  Result := Faccount_Specified;
end;

procedure Employee.Setaccounttype(Index: Integer; const AWideString: WideString);
begin
  Faccounttype := AWideString;
  Faccounttype_Specified := True;
end;

function Employee.accounttype_Specified(Index: Integer): boolean;
begin
  Result := Faccounttype_Specified;
end;

procedure Employee.Setassociation(Index: Integer; const AWideString: WideString);
begin
  Fassociation := AWideString;
  Fassociation_Specified := True;
end;

function Employee.association_Specified(Index: Integer): boolean;
begin
  Result := Fassociation_Specified;
end;

procedure Employee.Setbirthday(Index: Integer; const AWideString: WideString);
begin
  Fbirthday := AWideString;
  Fbirthday_Specified := True;
end;

function Employee.birthday_Specified(Index: Integer): boolean;
begin
  Result := Fbirthday_Specified;
end;

procedure Employee.Setblood(Index: Integer; const AWideString: WideString);
begin
  Fblood := AWideString;
  Fblood_Specified := True;
end;

function Employee.blood_Specified(Index: Integer): boolean;
begin
  Result := Fblood_Specified;
end;

procedure Employee.Setcardid(Index: Integer; const AWideString: WideString);
begin
  Fcardid := AWideString;
  Fcardid_Specified := True;
end;

function Employee.cardid_Specified(Index: Integer): boolean;
begin
  Result := Fcardid_Specified;
end;

procedure Employee.Setdutydate(Index: Integer; const AWideString: WideString);
begin
  Fdutydate := AWideString;
  Fdutydate_Specified := True;
end;

function Employee.dutydate_Specified(Index: Integer): boolean;
begin
  Result := Fdutydate_Specified;
end;

procedure Employee.Seteducation(Index: Integer; const AWideString: WideString);
begin
  Feducation := AWideString;
  Feducation_Specified := True;
end;

function Employee.education_Specified(Index: Integer): boolean;
begin
  Result := Feducation_Specified;
end;

procedure Employee.Seteducationhistory(Index: Integer; const AArrayOfEducationhistory: ArrayOfEducationhistory);
begin
  Feducationhistory := AArrayOfEducationhistory;
  Feducationhistory_Specified := True;
end;

function Employee.educationhistory_Specified(Index: Integer): boolean;
begin
  Result := Feducationhistory_Specified;
end;

procedure Employee.Setemail(Index: Integer; const AWideString: WideString);
begin
  Femail := AWideString;
  Femail_Specified := True;
end;

function Employee.email_Specified(Index: Integer): boolean;
begin
  Result := Femail_Specified;
end;

procedure Employee.SetemailPassword(Index: Integer; const AWideString: WideString);
begin
  FemailPassword := AWideString;
  FemailPassword_Specified := True;
end;

function Employee.emailPassword_Specified(Index: Integer): boolean;
begin
  Result := FemailPassword_Specified;
end;

procedure Employee.Setemployeecode(Index: Integer; const AWideString: WideString);
begin
  Femployeecode := AWideString;
  Femployeecode_Specified := True;
end;

function Employee.employeecode_Specified(Index: Integer): boolean;
begin
  Result := Femployeecode_Specified;
end;

procedure Employee.Setemployeeid(Index: Integer; const AWideString: WideString);
begin
  Femployeeid := AWideString;
  Femployeeid_Specified := True;
end;

function Employee.employeeid_Specified(Index: Integer): boolean;
begin
  Result := Femployeeid_Specified;
end;

procedure Employee.Setemployeename(Index: Integer; const AWideString: WideString);
begin
  Femployeename := AWideString;
  Femployeename_Specified := True;
end;

function Employee.employeename_Specified(Index: Integer): boolean;
begin
  Result := Femployeename_Specified;
end;

procedure Employee.SethasPen(Index: Integer; const ABoolean: Boolean);
begin
  FhasPen := ABoolean;
  FhasPen_Specified := True;
end;

function Employee.hasPen_Specified(Index: Integer): boolean;
begin
  Result := FhasPen_Specified;
end;

procedure Employee.SethasPhoto(Index: Integer; const ABoolean: Boolean);
begin
  FhasPhoto := ABoolean;
  FhasPhoto_Specified := True;
end;

function Employee.hasPhoto_Specified(Index: Integer): boolean;
begin
  Result := FhasPhoto_Specified;
end;

procedure Employee.Setidentity(Index: Integer; const AWideString: WideString);
begin
  Fidentity := AWideString;
  Fidentity_Specified := True;
end;

function Employee.identity_Specified(Index: Integer): boolean;
begin
  Result := Fidentity_Specified;
end;

procedure Employee.Setidentityplace(Index: Integer; const AWideString: WideString);
begin
  Fidentityplace := AWideString;
  Fidentityplace_Specified := True;
end;

function Employee.identityplace_Specified(Index: Integer): boolean;
begin
  Result := Fidentityplace_Specified;
end;

procedure Employee.Setisvalidation(Index: Integer; const AInteger: Integer);
begin
  Fisvalidation := AInteger;
  Fisvalidation_Specified := True;
end;

function Employee.isvalidation_Specified(Index: Integer): boolean;
begin
  Result := Fisvalidation_Specified;
end;

procedure Employee.Setmainplace(Index: Integer; const AWideString: WideString);
begin
  Fmainplace := AWideString;
  Fmainplace_Specified := True;
end;

function Employee.mainplace_Specified(Index: Integer): boolean;
begin
  Result := Fmainplace_Specified;
end;

procedure Employee.Setmarry(Index: Integer; const AWideString: WideString);
begin
  Fmarry := AWideString;
  Fmarry_Specified := True;
end;

function Employee.marry_Specified(Index: Integer): boolean;
begin
  Result := Fmarry_Specified;
end;

procedure Employee.Setmobile(Index: Integer; const AWideString: WideString);
begin
  Fmobile := AWideString;
  Fmobile_Specified := True;
end;

function Employee.mobile_Specified(Index: Integer): boolean;
begin
  Result := Fmobile_Specified;
end;

procedure Employee.Setnation(Index: Integer; const AWideString: WideString);
begin
  Fnation := AWideString;
  Fnation_Specified := True;
end;

function Employee.nation_Specified(Index: Integer): boolean;
begin
  Result := Fnation_Specified;
end;

procedure Employee.Setnational(Index: Integer; const AWideString: WideString);
begin
  Fnational := AWideString;
  Fnational_Specified := True;
end;

function Employee.national_Specified(Index: Integer): boolean;
begin
  Result := Fnational_Specified;
end;

procedure Employee.Setnowworkbegin(Index: Integer; const AWideString: WideString);
begin
  Fnowworkbegin := AWideString;
  Fnowworkbegin_Specified := True;
end;

function Employee.nowworkbegin_Specified(Index: Integer): boolean;
begin
  Result := Fnowworkbegin_Specified;
end;

procedure Employee.Setnowworkend(Index: Integer; const AWideString: WideString);
begin
  Fnowworkend := AWideString;
  Fnowworkend_Specified := True;
end;

function Employee.nowworkend_Specified(Index: Integer): boolean;
begin
  Result := Fnowworkend_Specified;
end;

procedure Employee.Setorderno(Index: Integer; const AInteger: Integer);
begin
  Forderno := AInteger;
  Forderno_Specified := True;
end;

function Employee.orderno_Specified(Index: Integer): boolean;
begin
  Result := Forderno_Specified;
end;

procedure Employee.Setorigin(Index: Integer; const AWideString: WideString);
begin
  Forigin := AWideString;
  Forigin_Specified := True;
end;

function Employee.origin_Specified(Index: Integer): boolean;
begin
  Result := Forigin_Specified;
end;

procedure Employee.Setotherprofessional(Index: Integer; const AWideString: WideString);
begin
  Fotherprofessional := AWideString;
  Fotherprofessional_Specified := True;
end;

function Employee.otherprofessional_Specified(Index: Integer): boolean;
begin
  Result := Fotherprofessional_Specified;
end;

procedure Employee.Setotherprofessionalid(Index: Integer; const AWideString: WideString);
begin
  Fotherprofessionalid := AWideString;
  Fotherprofessionalid_Specified := True;
end;

function Employee.otherprofessionalid_Specified(Index: Integer): boolean;
begin
  Result := Fotherprofessionalid_Specified;
end;

procedure Employee.Setotherprofessionalidtime(Index: Integer; const AWideString: WideString);
begin
  Fotherprofessionalidtime := AWideString;
  Fotherprofessionalidtime_Specified := True;
end;

function Employee.otherprofessionalidtime_Specified(Index: Integer): boolean;
begin
  Result := Fotherprofessionalidtime_Specified;
end;

procedure Employee.Setoutlook(Index: Integer; const AWideString: WideString);
begin
  Foutlook := AWideString;
  Foutlook_Specified := True;
end;

function Employee.outlook_Specified(Index: Integer): boolean;
begin
  Result := Foutlook_Specified;
end;

procedure Employee.Setpen(Index: Integer; const ABlob: Blob);
begin
  Fpen := ABlob;
  Fpen_Specified := True;
end;

function Employee.pen_Specified(Index: Integer): boolean;
begin
  Result := Fpen_Specified;
end;

procedure Employee.Setphone(Index: Integer; const AWideString: WideString);
begin
  Fphone := AWideString;
  Fphone_Specified := True;
end;

function Employee.phone_Specified(Index: Integer): boolean;
begin
  Result := Fphone_Specified;
end;

procedure Employee.Setphoto(Index: Integer; const ABlob: Blob);
begin
  Fphoto := ABlob;
  Fphoto_Specified := True;
end;

function Employee.photo_Specified(Index: Integer): boolean;
begin
  Result := Fphoto_Specified;
end;

procedure Employee.Setposts(Index: Integer; const APosts: Posts);
begin
  Fposts := APosts;
  Fposts_Specified := True;
end;

function Employee.posts_Specified(Index: Integer): boolean;
begin
  Result := Fposts_Specified;
end;

procedure Employee.Setprofessional(Index: Integer; const AWideString: WideString);
begin
  Fprofessional := AWideString;
  Fprofessional_Specified := True;
end;

function Employee.professional_Specified(Index: Integer): boolean;
begin
  Result := Fprofessional_Specified;
end;

procedure Employee.Setprofessionallife(Index: Integer; const AWideString: WideString);
begin
  Fprofessionallife := AWideString;
  Fprofessionallife_Specified := True;
end;

function Employee.professionallife_Specified(Index: Integer): boolean;
begin
  Result := Fprofessionallife_Specified;
end;

procedure Employee.Setprofessionaltype(Index: Integer; const AWideString: WideString);
begin
  Fprofessionaltype := AWideString;
  Fprofessionaltype_Specified := True;
end;

function Employee.professionaltype_Specified(Index: Integer): boolean;
begin
  Result := Fprofessionaltype_Specified;
end;

procedure Employee.Setremark(Index: Integer; const AWideString: WideString);
begin
  Fremark := AWideString;
  Fremark_Specified := True;
end;

function Employee.remark_Specified(Index: Integer): boolean;
begin
  Result := Fremark_Specified;
end;

procedure Employee.Setreportscores(Index: Integer; const AWideString: WideString);
begin
  Freportscores := AWideString;
  Freportscores_Specified := True;
end;

function Employee.reportscores_Specified(Index: Integer): boolean;
begin
  Result := Freportscores_Specified;
end;

procedure Employee.Setsex(Index: Integer; const AInteger: Integer);
begin
  Fsex := AInteger;
  Fsex_Specified := True;
end;

function Employee.sex_Specified(Index: Integer): boolean;
begin
  Result := Fsex_Specified;
end;

procedure Employee.Setssouserses(Index: Integer; const AArrayOfSsousers: ArrayOfSsousers);
begin
  Fssouserses := AArrayOfSsousers;
  Fssouserses_Specified := True;
end;

function Employee.ssouserses_Specified(Index: Integer): boolean;
begin
  Result := Fssouserses_Specified;
end;

procedure Employee.Settitle(Index: Integer; const AWideString: WideString);
begin
  Ftitle := AWideString;
  Ftitle_Specified := True;
end;

function Employee.title_Specified(Index: Integer): boolean;
begin
  Result := Ftitle_Specified;
end;

procedure Employee.Settitleid(Index: Integer; const AWideString: WideString);
begin
  Ftitleid := AWideString;
  Ftitleid_Specified := True;
end;

function Employee.titleid_Specified(Index: Integer): boolean;
begin
  Result := Ftitleid_Specified;
end;

procedure Employee.Settraintime(Index: Integer; const AWideString: WideString);
begin
  Ftraintime := AWideString;
  Ftraintime_Specified := True;
end;

function Employee.traintime_Specified(Index: Integer): boolean;
begin
  Result := Ftraintime_Specified;
end;

procedure Employee.Setunmobiles(Index: Integer; const AArrayOfUnmobile: ArrayOfUnmobile);
begin
  Funmobiles := AArrayOfUnmobile;
  Funmobiles_Specified := True;
end;

function Employee.unmobiles_Specified(Index: Integer): boolean;
begin
  Result := Funmobiles_Specified;
end;

procedure Employee.SetuserCount(Index: Integer; const AInteger: Integer);
begin
  FuserCount := AInteger;
  FuserCount_Specified := True;
end;

function Employee.userCount_Specified(Index: Integer): boolean;
begin
  Result := FuserCount_Specified;
end;

procedure Employee.Setworkhistory(Index: Integer; const AArrayOfWorkhistory: ArrayOfWorkhistory);
begin
  Fworkhistory := AArrayOfWorkhistory;
  Fworkhistory_Specified := True;
end;

function Employee.workhistory_Specified(Index: Integer): boolean;
begin
  Result := Fworkhistory_Specified;
end;

procedure Employee.Setworkstarttime(Index: Integer; const AWideString: WideString);
begin
  Fworkstarttime := AWideString;
  Fworkstarttime_Specified := True;
end;

function Employee.workstarttime_Specified(Index: Integer): boolean;
begin
  Result := Fworkstarttime_Specified;
end;

procedure Employee.Setworktime(Index: Integer; const AWideString: WideString);
begin
  Fworktime := AWideString;
  Fworktime_Specified := True;
end;

function Employee.worktime_Specified(Index: Integer): boolean;
begin
  Result := Fworktime_Specified;
end;

procedure Employee.Setworktype(Index: Integer; const AWideString: WideString);
begin
  Fworktype := AWideString;
  Fworktype_Specified := True;
end;

function Employee.worktype_Specified(Index: Integer): boolean;
begin
  Result := Fworktype_Specified;
end;

destructor Deptment.Destroy;
var
  I: Integer;
begin
  for I := 0 to Length(Fdeptments)-1 do
    FreeAndNil(Fdeptments[I]);
  SetLength(Fdeptments, 0);
  for I := 0 to Length(Fpostses)-1 do
    FreeAndNil(Fpostses[I]);
  SetLength(Fpostses, 0);
  FreeAndNil(Fdeptment);
  FreeAndNil(Forgan);
  inherited Destroy;
end;

procedure Deptment.Setareaid(Index: Integer; const AWideString: WideString);
begin
  Fareaid := AWideString;
  Fareaid_Specified := True;
end;

function Deptment.areaid_Specified(Index: Integer): boolean;
begin
  Result := Fareaid_Specified;
end;

procedure Deptment.Setdeptcode(Index: Integer; const AWideString: WideString);
begin
  Fdeptcode := AWideString;
  Fdeptcode_Specified := True;
end;

function Deptment.deptcode_Specified(Index: Integer): boolean;
begin
  Result := Fdeptcode_Specified;
end;

procedure Deptment.Setdeptid(Index: Integer; const AWideString: WideString);
begin
  Fdeptid := AWideString;
  Fdeptid_Specified := True;
end;

function Deptment.deptid_Specified(Index: Integer): boolean;
begin
  Result := Fdeptid_Specified;
end;

procedure Deptment.Setdeptman(Index: Integer; const AWideString: WideString);
begin
  Fdeptman := AWideString;
  Fdeptman_Specified := True;
end;

function Deptment.deptman_Specified(Index: Integer): boolean;
begin
  Result := Fdeptman_Specified;
end;

procedure Deptment.Setdeptmanid(Index: Integer; const AWideString: WideString);
begin
  Fdeptmanid := AWideString;
  Fdeptmanid_Specified := True;
end;

function Deptment.deptmanid_Specified(Index: Integer): boolean;
begin
  Result := Fdeptmanid_Specified;
end;

procedure Deptment.Setdeptment(Index: Integer; const ADeptment: Deptment);
begin
  Fdeptment := ADeptment;
  Fdeptment_Specified := True;
end;

function Deptment.deptment_Specified(Index: Integer): boolean;
begin
  Result := Fdeptment_Specified;
end;

procedure Deptment.Setdeptments(Index: Integer; const AArrayOfDeptment: ArrayOfDeptment);
begin
  Fdeptments := AArrayOfDeptment;
  Fdeptments_Specified := True;
end;

function Deptment.deptments_Specified(Index: Integer): boolean;
begin
  Result := Fdeptments_Specified;
end;

procedure Deptment.Setdeptname(Index: Integer; const AWideString: WideString);
begin
  Fdeptname := AWideString;
  Fdeptname_Specified := True;
end;

function Deptment.deptname_Specified(Index: Integer): boolean;
begin
  Result := Fdeptname_Specified;
end;

procedure Deptment.Setisvalidation(Index: Integer; const AInteger: Integer);
begin
  Fisvalidation := AInteger;
  Fisvalidation_Specified := True;
end;

function Deptment.isvalidation_Specified(Index: Integer): boolean;
begin
  Result := Fisvalidation_Specified;
end;

procedure Deptment.Setorderno(Index: Integer; const AInteger: Integer);
begin
  Forderno := AInteger;
  Forderno_Specified := True;
end;

function Deptment.orderno_Specified(Index: Integer): boolean;
begin
  Result := Forderno_Specified;
end;

procedure Deptment.Setorgan(Index: Integer; const AOrgan: Organ);
begin
  Forgan := AOrgan;
  Forgan_Specified := True;
end;

function Deptment.organ_Specified(Index: Integer): boolean;
begin
  Result := Forgan_Specified;
end;

procedure Deptment.Setpostses(Index: Integer; const AArrayOfPosts: ArrayOfPosts);
begin
  Fpostses := AArrayOfPosts;
  Fpostses_Specified := True;
end;

function Deptment.postses_Specified(Index: Integer): boolean;
begin
  Result := Fpostses_Specified;
end;

procedure Deptment.Setremark(Index: Integer; const AWideString: WideString);
begin
  Fremark := AWideString;
  Fremark_Specified := True;
end;

function Deptment.remark_Specified(Index: Integer): boolean;
begin
  Result := Fremark_Specified;
end;

destructor Posts.Destroy;
var
  I: Integer;
begin
  for I := 0 to Length(Femployees)-1 do
    FreeAndNil(Femployees[I]);
  SetLength(Femployees, 0);
  for I := 0 to Length(Fpostses)-1 do
    FreeAndNil(Fpostses[I]);
  SetLength(Fpostses, 0);
  FreeAndNil(Fdeptment);
  FreeAndNil(Fposts);
  inherited Destroy;
end;

procedure Posts.Setdeptment(Index: Integer; const ADeptment: Deptment);
begin
  Fdeptment := ADeptment;
  Fdeptment_Specified := True;
end;

function Posts.deptment_Specified(Index: Integer): boolean;
begin
  Result := Fdeptment_Specified;
end;

procedure Posts.Setemployees(Index: Integer; const AArrayOfDeptment: ArrayOfDeptment);
begin
  Femployees := AArrayOfDeptment;
  Femployees_Specified := True;
end;

function Posts.employees_Specified(Index: Integer): boolean;
begin
  Result := Femployees_Specified;
end;

procedure Posts.Setisvalidation(Index: Integer; const AInteger: Integer);
begin
  Fisvalidation := AInteger;
  Fisvalidation_Specified := True;
end;

function Posts.isvalidation_Specified(Index: Integer): boolean;
begin
  Result := Fisvalidation_Specified;
end;

procedure Posts.Setorderno(Index: Integer; const AInteger: Integer);
begin
  Forderno := AInteger;
  Forderno_Specified := True;
end;

function Posts.orderno_Specified(Index: Integer): boolean;
begin
  Result := Forderno_Specified;
end;

procedure Posts.Setpostcode(Index: Integer; const AWideString: WideString);
begin
  Fpostcode := AWideString;
  Fpostcode_Specified := True;
end;

function Posts.postcode_Specified(Index: Integer): boolean;
begin
  Result := Fpostcode_Specified;
end;

procedure Posts.Setpostid(Index: Integer; const AWideString: WideString);
begin
  Fpostid := AWideString;
  Fpostid_Specified := True;
end;

function Posts.postid_Specified(Index: Integer): boolean;
begin
  Result := Fpostid_Specified;
end;

procedure Posts.Setpostname(Index: Integer; const AWideString: WideString);
begin
  Fpostname := AWideString;
  Fpostname_Specified := True;
end;

function Posts.postname_Specified(Index: Integer): boolean;
begin
  Result := Fpostname_Specified;
end;

procedure Posts.Setposts(Index: Integer; const APosts: Posts);
begin
  Fposts := APosts;
  Fposts_Specified := True;
end;

function Posts.posts_Specified(Index: Integer): boolean;
begin
  Result := Fposts_Specified;
end;

procedure Posts.Setpostses(Index: Integer; const AArrayOfPosts: ArrayOfPosts);
begin
  Fpostses := AArrayOfPosts;
  Fpostses_Specified := True;
end;

function Posts.postses_Specified(Index: Integer): boolean;
begin
  Result := Fpostses_Specified;
end;

procedure Posts.Setremark(Index: Integer; const AWideString: WideString);
begin
  Fremark := AWideString;
  Fremark_Specified := True;
end;

function Posts.remark_Specified(Index: Integer): boolean;
begin
  Result := Fremark_Specified;
end;

destructor Organ.Destroy;
var
  I: Integer;
begin
  for I := 0 to Length(Fdeptments)-1 do
    FreeAndNil(Fdeptments[I]);
  SetLength(Fdeptments, 0);
  for I := 0 to Length(Forgans)-1 do
    FreeAndNil(Forgans[I]);
  SetLength(Forgans, 0);
  FreeAndNil(Fporgan);
  inherited Destroy;
end;

procedure Organ.Setaddress(Index: Integer; const AWideString: WideString);
begin
  Faddress := AWideString;
  Faddress_Specified := True;
end;

function Organ.address_Specified(Index: Integer): boolean;
begin
  Result := Faddress_Specified;
end;

procedure Organ.Setareaid(Index: Integer; const AWideString: WideString);
begin
  Fareaid := AWideString;
  Fareaid_Specified := True;
end;

function Organ.areaid_Specified(Index: Integer): boolean;
begin
  Result := Fareaid_Specified;
end;

procedure Organ.Setdeptments(Index: Integer; const AArrayOfDeptment: ArrayOfDeptment);
begin
  Fdeptments := AArrayOfDeptment;
  Fdeptments_Specified := True;
end;

function Organ.deptments_Specified(Index: Integer): boolean;
begin
  Result := Fdeptments_Specified;
end;

procedure Organ.Setfax(Index: Integer; const AWideString: WideString);
begin
  Ffax := AWideString;
  Ffax_Specified := True;
end;

function Organ.fax_Specified(Index: Integer): boolean;
begin
  Result := Ffax_Specified;
end;

procedure Organ.Setisvalidation(Index: Integer; const AInteger: Integer);
begin
  Fisvalidation := AInteger;
  Fisvalidation_Specified := True;
end;

function Organ.isvalidation_Specified(Index: Integer): boolean;
begin
  Result := Fisvalidation_Specified;
end;

procedure Organ.Setorganalias(Index: Integer; const AWideString: WideString);
begin
  Forganalias := AWideString;
  Forganalias_Specified := True;
end;

function Organ.organalias_Specified(Index: Integer): boolean;
begin
  Result := Forganalias_Specified;
end;

procedure Organ.Setorgancode(Index: Integer; const AWideString: WideString);
begin
  Forgancode := AWideString;
  Forgancode_Specified := True;
end;

function Organ.organcode_Specified(Index: Integer): boolean;
begin
  Result := Forgancode_Specified;
end;

procedure Organ.Setorganid(Index: Integer; const AWideString: WideString);
begin
  Forganid := AWideString;
  Forganid_Specified := True;
end;

function Organ.organid_Specified(Index: Integer): boolean;
begin
  Result := Forganid_Specified;
end;

procedure Organ.Setorganman(Index: Integer; const AWideString: WideString);
begin
  Forganman := AWideString;
  Forganman_Specified := True;
end;

function Organ.organman_Specified(Index: Integer): boolean;
begin
  Result := Forganman_Specified;
end;

procedure Organ.Setorganmanid(Index: Integer; const AWideString: WideString);
begin
  Forganmanid := AWideString;
  Forganmanid_Specified := True;
end;

function Organ.organmanid_Specified(Index: Integer): boolean;
begin
  Result := Forganmanid_Specified;
end;

procedure Organ.Setorganname(Index: Integer; const AWideString: WideString);
begin
  Forganname := AWideString;
  Forganname_Specified := True;
end;

function Organ.organname_Specified(Index: Integer): boolean;
begin
  Result := Forganname_Specified;
end;

procedure Organ.Setorgans(Index: Integer; const AArrayOfOrgan: ArrayOfOrgan);
begin
  Forgans := AArrayOfOrgan;
  Forgans_Specified := True;
end;

function Organ.organs_Specified(Index: Integer): boolean;
begin
  Result := Forgans_Specified;
end;

procedure Organ.Setporgan(Index: Integer; const AOrgan: Organ);
begin
  Fporgan := AOrgan;
  Fporgan_Specified := True;
end;

function Organ.porgan_Specified(Index: Integer): boolean;
begin
  Result := Fporgan_Specified;
end;

procedure Organ.Setpostcode(Index: Integer; const AWideString: WideString);
begin
  Fpostcode := AWideString;
  Fpostcode_Specified := True;
end;

function Organ.postcode_Specified(Index: Integer): boolean;
begin
  Result := Fpostcode_Specified;
end;

procedure Organ.Setremark(Index: Integer; const AWideString: WideString);
begin
  Fremark := AWideString;
  Fremark_Specified := True;
end;

function Organ.remark_Specified(Index: Integer): boolean;
begin
  Result := Fremark_Specified;
end;

procedure Organ.Settelephone(Index: Integer; const AWideString: WideString);
begin
  Ftelephone := AWideString;
  Ftelephone_Specified := True;
end;

function Organ.telephone_Specified(Index: Integer): boolean;
begin
  Result := Ftelephone_Specified;
end;

destructor Workhistory.Destroy;
begin
  FreeAndNil(Femployee);
  inherited Destroy;
end;

procedure Workhistory.Setbegintime(Index: Integer; const AWideString: WideString);
begin
  Fbegintime := AWideString;
  Fbegintime_Specified := True;
end;

function Workhistory.begintime_Specified(Index: Integer): boolean;
begin
  Result := Fbegintime_Specified;
end;

procedure Workhistory.Setdept(Index: Integer; const AWideString: WideString);
begin
  Fdept := AWideString;
  Fdept_Specified := True;
end;

function Workhistory.dept_Specified(Index: Integer): boolean;
begin
  Result := Fdept_Specified;
end;

procedure Workhistory.Setdeptid(Index: Integer; const AWideString: WideString);
begin
  Fdeptid := AWideString;
  Fdeptid_Specified := True;
end;

function Workhistory.deptid_Specified(Index: Integer): boolean;
begin
  Result := Fdeptid_Specified;
end;

procedure Workhistory.Setemployee(Index: Integer; const AEmployee: Employee);
begin
  Femployee := AEmployee;
  Femployee_Specified := True;
end;

function Workhistory.employee_Specified(Index: Integer): boolean;
begin
  Result := Femployee_Specified;
end;

procedure Workhistory.Setendtime(Index: Integer; const AWideString: WideString);
begin
  Fendtime := AWideString;
  Fendtime_Specified := True;
end;

function Workhistory.endtime_Specified(Index: Integer): boolean;
begin
  Result := Fendtime_Specified;
end;

procedure Workhistory.Sethid(Index: Integer; const AWideString: WideString);
begin
  Fhid := AWideString;
  Fhid_Specified := True;
end;

function Workhistory.hid_Specified(Index: Integer): boolean;
begin
  Result := Fhid_Specified;
end;

procedure Workhistory.Setorganid(Index: Integer; const AWideString: WideString);
begin
  Forganid := AWideString;
  Forganid_Specified := True;
end;

function Workhistory.organid_Specified(Index: Integer): boolean;
begin
  Result := Forganid_Specified;
end;

procedure Workhistory.Setorganname(Index: Integer; const AWideString: WideString);
begin
  Forganname := AWideString;
  Forganname_Specified := True;
end;

function Workhistory.organname_Specified(Index: Integer): boolean;
begin
  Result := Forganname_Specified;
end;

procedure Workhistory.Setpost(Index: Integer; const AWideString: WideString);
begin
  Fpost := AWideString;
  Fpost_Specified := True;
end;

function Workhistory.post_Specified(Index: Integer): boolean;
begin
  Result := Fpost_Specified;
end;

procedure Workhistory.Setpostid(Index: Integer; const AWideString: WideString);
begin
  Fpostid := AWideString;
  Fpostid_Specified := True;
end;

function Workhistory.postid_Specified(Index: Integer): boolean;
begin
  Result := Fpostid_Specified;
end;

procedure Workhistory.Setremark(Index: Integer; const AWideString: WideString);
begin
  Fremark := AWideString;
  Fremark_Specified := True;
end;

function Workhistory.remark_Specified(Index: Integer): boolean;
begin
  Result := Fremark_Specified;
end;

destructor Unmobile.Destroy;
begin
  FreeAndNil(Fapplication_);
  FreeAndNil(Femployee);
  inherited Destroy;
end;

procedure Unmobile.Setapplication_(Index: Integer; const AApplication_: Application_);
begin
  Fapplication_ := AApplication_;
  Fapplication__Specified := True;
end;

function Unmobile.application__Specified(Index: Integer): boolean;
begin
  Result := Fapplication__Specified;
end;

procedure Unmobile.Setemployee(Index: Integer; const AEmployee: Employee);
begin
  Femployee := AEmployee;
  Femployee_Specified := True;
end;

function Unmobile.employee_Specified(Index: Integer): boolean;
begin
  Result := Femployee_Specified;
end;

procedure Unmobile.Setudate(Index: Integer; const AWideString: WideString);
begin
  Fudate := AWideString;
  Fudate_Specified := True;
end;

function Unmobile.udate_Specified(Index: Integer): boolean;
begin
  Result := Fudate_Specified;
end;

procedure Unmobile.Setunid(Index: Integer; const AWideString: WideString);
begin
  Funid := AWideString;
  Funid_Specified := True;
end;

function Unmobile.unid_Specified(Index: Integer): boolean;
begin
  Result := Funid_Specified;
end;

destructor Rolesapp.Destroy;
begin
  FreeAndNil(Fapplication_);
  FreeAndNil(Fssoroles);
  inherited Destroy;
end;

procedure Rolesapp.Setapplication_(Index: Integer; const AApplication_: Application_);
begin
  Fapplication_ := AApplication_;
  Fapplication__Specified := True;
end;

function Rolesapp.application__Specified(Index: Integer): boolean;
begin
  Result := Fapplication__Specified;
end;

procedure Rolesapp.Setrolesappid(Index: Integer; const AWideString: WideString);
begin
  Frolesappid := AWideString;
  Frolesappid_Specified := True;
end;

function Rolesapp.rolesappid_Specified(Index: Integer): boolean;
begin
  Result := Frolesappid_Specified;
end;

procedure Rolesapp.Setssoroles(Index: Integer; const ASsoroles: Ssoroles);
begin
  Fssoroles := ASsoroles;
  Fssoroles_Specified := True;
end;

function Rolesapp.ssoroles_Specified(Index: Integer): boolean;
begin
  Result := Fssoroles_Specified;
end;

destructor Tokens.Destroy;
begin
  FreeAndNil(Fapplication_);
  FreeAndNil(Fssousers);
  inherited Destroy;
end;

procedure Tokens.Setapplication_(Index: Integer; const AApplication_: Application_);
begin
  Fapplication_ := AApplication_;
  Fapplication__Specified := True;
end;

function Tokens.application__Specified(Index: Integer): boolean;
begin
  Result := Fapplication__Specified;
end;

procedure Tokens.Setssousers(Index: Integer; const ASsousers: Ssousers);
begin
  Fssousers := ASsousers;
  Fssousers_Specified := True;
end;

function Tokens.ssousers_Specified(Index: Integer): boolean;
begin
  Result := Fssousers_Specified;
end;

procedure Tokens.Settid(Index: Integer; const AWideString: WideString);
begin
  Ftid := AWideString;
  Ftid_Specified := True;
end;

function Tokens.tid_Specified(Index: Integer): boolean;
begin
  Result := Ftid_Specified;
end;

procedure Tokens.Settoken(Index: Integer; const AWideString: WideString);
begin
  Ftoken := AWideString;
  Ftoken_Specified := True;
end;

function Tokens.token_Specified(Index: Integer): boolean;
begin
  Result := Ftoken_Specified;
end;

procedure Tokens.Settokentype(Index: Integer; const AWideString: WideString);
begin
  Ftokentype := AWideString;
  Ftokentype_Specified := True;
end;

function Tokens.tokentype_Specified(Index: Integer): boolean;
begin
  Result := Ftokentype_Specified;
end;

destructor Educationhistory.Destroy;
begin
  FreeAndNil(Femployee);
  inherited Destroy;
end;

procedure Educationhistory.Setcertificate(Index: Integer; const AWideString: WideString);
begin
  Fcertificate := AWideString;
  Fcertificate_Specified := True;
end;

function Educationhistory.certificate_Specified(Index: Integer): boolean;
begin
  Result := Fcertificate_Specified;
end;

procedure Educationhistory.Seteducation(Index: Integer; const AWideString: WideString);
begin
  Feducation := AWideString;
  Feducation_Specified := True;
end;

function Educationhistory.education_Specified(Index: Integer): boolean;
begin
  Result := Feducation_Specified;
end;

procedure Educationhistory.Setedutype(Index: Integer; const AWideString: WideString);
begin
  Fedutype := AWideString;
  Fedutype_Specified := True;
end;

function Educationhistory.edutype_Specified(Index: Integer): boolean;
begin
  Result := Fedutype_Specified;
end;

procedure Educationhistory.Seteid(Index: Integer; const AWideString: WideString);
begin
  Feid := AWideString;
  Feid_Specified := True;
end;

function Educationhistory.eid_Specified(Index: Integer): boolean;
begin
  Result := Feid_Specified;
end;

procedure Educationhistory.Setemployee(Index: Integer; const AEmployee: Employee);
begin
  Femployee := AEmployee;
  Femployee_Specified := True;
end;

function Educationhistory.employee_Specified(Index: Integer): boolean;
begin
  Result := Femployee_Specified;
end;

procedure Educationhistory.Setgraduation(Index: Integer; const AWideString: WideString);
begin
  Fgraduation := AWideString;
  Fgraduation_Specified := True;
end;

function Educationhistory.graduation_Specified(Index: Integer): boolean;
begin
  Result := Fgraduation_Specified;
end;

procedure Educationhistory.Setprofessional(Index: Integer; const AWideString: WideString);
begin
  Fprofessional := AWideString;
  Fprofessional_Specified := True;
end;

function Educationhistory.professional_Specified(Index: Integer): boolean;
begin
  Result := Fprofessional_Specified;
end;

procedure Educationhistory.Setschoolname(Index: Integer; const AWideString: WideString);
begin
  Fschoolname := AWideString;
  Fschoolname_Specified := True;
end;

function Educationhistory.schoolname_Specified(Index: Integer): boolean;
begin
  Result := Fschoolname_Specified;
end;

destructor Commonmenus.Destroy;
begin
  FreeAndNil(Fresources);
  FreeAndNil(Fssousers);
  inherited Destroy;
end;

procedure Commonmenus.Setcid(Index: Integer; const AWideString: WideString);
begin
  Fcid := AWideString;
  Fcid_Specified := True;
end;

function Commonmenus.cid_Specified(Index: Integer): boolean;
begin
  Result := Fcid_Specified;
end;

procedure Commonmenus.Setresources(Index: Integer; const AResources: Resources);
begin
  Fresources := AResources;
  Fresources_Specified := True;
end;

function Commonmenus.resources_Specified(Index: Integer): boolean;
begin
  Result := Fresources_Specified;
end;

procedure Commonmenus.Setssousers(Index: Integer; const ASsousers: Ssousers);
begin
  Fssousers := ASsousers;
  Fssousers_Specified := True;
end;

function Commonmenus.ssousers_Specified(Index: Integer): boolean;
begin
  Result := Fssousers_Specified;
end;

initialization
  InvRegistry.RegisterInterface(TypeInfo(ResourceServerPortType), 'http://resource.server.oxhide.sxsihe.com', 'UTF-8');
  InvRegistry.RegisterDefaultSOAPAction(TypeInfo(ResourceServerPortType), '');
  InvRegistry.RegisterInvokeOptions(TypeInfo(ResourceServerPortType), ioDocument);
  InvRegistry.RegisterExternalParamName(TypeInfo(ResourceServerPortType), 'queryHql', 'out_', 'out');
  InvRegistry.RegisterExternalParamName(TypeInfo(ResourceServerPortType), 'findObjectBykey', 'out_', 'out');
  InvRegistry.RegisterExternalParamName(TypeInfo(ResourceServerPortType), 'getAll', 'out_', 'out');
  InvRegistry.RegisterExternalParamName(TypeInfo(ResourceServerPortType), 'findObjectsByCondition', 'out_', 'out');
  RemClassRegistry.RegisterXSInfo(TypeInfo(anyType2anyTypeMap), 'http://resource.server.oxhide.sxsihe.com', 'anyType2anyTypeMap');
  RemClassRegistry.RegisterXSClass(entry, 'http://resource.server.oxhide.sxsihe.com', 'entry');
  RemClassRegistry.RegisterXSInfo(TypeInfo(ArrayOfString), 'http://resource.server.oxhide.sxsihe.com', 'ArrayOfString');
  RemClassRegistry.RegisterXSInfo(TypeInfo(anyType2booleanMap), 'http://resource.server.oxhide.sxsihe.com', 'anyType2booleanMap');
  RemClassRegistry.RegisterXSClass(entry2, 'http://resource.server.oxhide.sxsihe.com', 'entry2', 'entry');
  RemClassRegistry.RegisterXSInfo(TypeInfo(ArrayOfResources), 'http://domain.resource.oxhide.sxsihe.com', 'ArrayOfResources');
  RemClassRegistry.RegisterXSClass(ConditionBlock, 'http://persistence.oxhide.sxsihe.com', 'ConditionBlock');
  RemClassRegistry.RegisterXSInfo(TypeInfo(ArrayOfCommonmenus), 'http://domain.commonmenus.imenus.oxhide.sxsihe.com', 'ArrayOfCommonmenus');
  RemClassRegistry.RegisterXSInfo(TypeInfo(ArrayOfRolesresources), 'http://domain.rolesresource.oxhide.sxsihe.com', 'ArrayOfRolesresources');
  RemClassRegistry.RegisterXSClass(Resources, 'http://domain.resource.oxhide.sxsihe.com', 'Resources');
  RemClassRegistry.RegisterExternalPropName(TypeInfo(Resources), 'application_', 'application');
  RemClassRegistry.RegisterXSClass(Rolesresources, 'http://domain.rolesresource.oxhide.sxsihe.com', 'Rolesresources');
  RemClassRegistry.RegisterXSInfo(TypeInfo(ArrayOfRolesapp), 'http://domain.rolesapp.oxhide.sxsihe.com', 'ArrayOfRolesapp');
  RemClassRegistry.RegisterXSInfo(TypeInfo(ArrayOfUsersroles), 'http://domain.usersroles.oxhide.sxsihe.com', 'ArrayOfUsersroles');
  RemClassRegistry.RegisterXSClass(Ssoroles, 'http://domain.ssoroles.oxhide.sxsihe.com', 'Ssoroles');
  RemClassRegistry.RegisterXSClass(Usersroles, 'http://domain.usersroles.oxhide.sxsihe.com', 'Usersroles');
  RemClassRegistry.RegisterXSInfo(TypeInfo(ArrayOfBoxmenus), 'http://domain.boxmenus.imenus.oxhide.sxsihe.com', 'ArrayOfBoxmenus');
  RemClassRegistry.RegisterXSInfo(TypeInfo(ArrayOfTokens), 'http://domain.token.message.oxhide.sxsihe.com', 'ArrayOfTokens');
  RemClassRegistry.RegisterXSClass(Ssousers, 'http://domain.ssouser.oxhide.sxsihe.com', 'Ssousers');
  RemClassRegistry.RegisterXSInfo(TypeInfo(ArrayOfSsousers), 'http://domain.ssouser.oxhide.sxsihe.com', 'ArrayOfSsousers');
  RemClassRegistry.RegisterXSClass(Boxmenus, 'http://domain.boxmenus.imenus.oxhide.sxsihe.com', 'Boxmenus');
  RemClassRegistry.RegisterXSInfo(TypeInfo(ArrayOfEducationhistory), 'http://domain.educationhistory.oxhide.sxsihe.com', 'ArrayOfEducationhistory');
  RemClassRegistry.RegisterXSClass(Blob, 'http://sql.java', 'Blob');
  RemClassRegistry.RegisterXSInfo(TypeInfo(ArrayOfUnmobile), 'http://domain.mobile.message.oxhide.sxsihe.com', 'ArrayOfUnmobile');
  RemClassRegistry.RegisterXSClass(Application_, 'http://domain.application.oxhide.sxsihe.com', 'Application_', 'Application');
  RemClassRegistry.RegisterXSInfo(TypeInfo(ArrayOfWorkhistory), 'http://domain.workhistory.oxhide.sxsihe.com', 'ArrayOfWorkhistory');
  RemClassRegistry.RegisterXSClass(Employee, 'http://domain.employee.oxhide.sxsihe.com', 'Employee');
  RemClassRegistry.RegisterXSInfo(TypeInfo(ArrayOfDeptment), 'http://domain.dept.oxhide.sxsihe.com', 'ArrayOfDeptment');
  RemClassRegistry.RegisterXSInfo(TypeInfo(ArrayOfPosts), 'http://domain.post.oxhide.sxsihe.com', 'ArrayOfPosts');
  RemClassRegistry.RegisterXSClass(Deptment, 'http://domain.dept.oxhide.sxsihe.com', 'Deptment');
  RemClassRegistry.RegisterXSClass(Posts, 'http://domain.post.oxhide.sxsihe.com', 'Posts');
  RemClassRegistry.RegisterXSInfo(TypeInfo(ArrayOfOrgan), 'http://domain.organ.oxhide.sxsihe.com', 'ArrayOfOrgan');
  RemClassRegistry.RegisterXSClass(Organ, 'http://domain.organ.oxhide.sxsihe.com', 'Organ');
  RemClassRegistry.RegisterXSClass(Workhistory, 'http://domain.workhistory.oxhide.sxsihe.com', 'Workhistory');
  RemClassRegistry.RegisterXSClass(Unmobile, 'http://domain.mobile.message.oxhide.sxsihe.com', 'Unmobile');
  RemClassRegistry.RegisterExternalPropName(TypeInfo(Unmobile), 'application_', 'application');
  RemClassRegistry.RegisterXSClass(Rolesapp, 'http://domain.rolesapp.oxhide.sxsihe.com', 'Rolesapp');
  RemClassRegistry.RegisterExternalPropName(TypeInfo(Rolesapp), 'application_', 'application');
  RemClassRegistry.RegisterXSClass(Tokens, 'http://domain.token.message.oxhide.sxsihe.com', 'Tokens');
  RemClassRegistry.RegisterExternalPropName(TypeInfo(Tokens), 'application_', 'application');
  RemClassRegistry.RegisterXSClass(InputStream, 'http://io.java', 'InputStream');
  RemClassRegistry.RegisterXSClass(Educationhistory, 'http://domain.educationhistory.oxhide.sxsihe.com', 'Educationhistory');
  RemClassRegistry.RegisterXSClass(Commonmenus, 'http://domain.commonmenus.imenus.oxhide.sxsihe.com', 'Commonmenus');

end.