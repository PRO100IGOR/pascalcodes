 unit DocHostUIHandler;
 
 interface
 
 uses
 Windows, ActiveX;
 const
 DOCHOSTUIFLAG_DIALOG                      = $00000001;
 DOCHOSTUIFLAG_DISABLE_HELP_MENU           = $00000002;
 DOCHOSTUIFLAG_NO3DBORDER                  = $00000004;
 DOCHOSTUIFLAG_SCROLL_NO                   = $00000008;
 DOCHOSTUIFLAG_DISABLE_SCRIPT_INACTIVE     = $00000010;
 DOCHOSTUIFLAG_OPENNEWWIN                  = $00000020;
 DOCHOSTUIFLAG_DISABLE_OFFSCREEN           = $00000040;
 DOCHOSTUIFLAG_FLAT_SCROLLBAR              = $00000080;
 DOCHOSTUIFLAG_DIV_BLOCKDEFAULT            = $00000100;
 DOCHOSTUIFLAG_ACTIVATE_CLIENTHIT_ONLY     = $00000200;
 DOCHOSTUIFLAG_OVERRIDEBEHAVIORFACTORY     = $00000400;
 DOCHOSTUIFLAG_CODEPAGELINKEDFONTS         = $00000800;
 DOCHOSTUIFLAG_URL_ENCODING_DISABLE_UTF8   = $00001000;
 DOCHOSTUIFLAG_URL_ENCODING_ENABLE_UTF8    = $00002000;
 DOCHOSTUIFLAG_ENABLE_FORMS_AUTOCOMPLETE   = $00004000;
 DOCHOSTUIFLAG_ENABLE_INPLACE_NAVIGATION   = $00010000;
 DOCHOSTUIFLAG_IME_ENABLE_RECONVERSION     = $00020000;
 DOCHOSTUIFLAG_THEME                       = $00040000;
 DOCHOSTUIFLAG_NOTHEME                     = $00080000;
 DOCHOSTUIFLAG_NOPICS                      = $00100000;
 DOCHOSTUIFLAG_NO3DOUTERBORDER             = $00200000;
 DOCHOSTUIFLAG_DISABLE_EDIT_NS_FIXUP       = $1;
 DOCHOSTUIFLAG_LOCAL_MACHINE_ACCESS_CHECK = $1;
 DOCHOSTUIFLAG_DISABLE_UNTRUSTEDPROTOCOL   = $1;
 DOCHOSTUIDBLCLK_DEFAULT         = 0;
 DOCHOSTUIDBLCLK_SHOWPROPERTIES = 1;
 DOCHOSTUIDBLCLK_SHOWCODE        = 2;
 DOCHOSTUITYPE_BROWSE = 0;
 DOCHOSTUITYPE_AUTHOR = 1;
 
 type
 TDocHostUIInfo = record
     cbSize: ULONG;
     dwFlags: DWORD;
     dwDoubleClick: DWORD;
     pchHostCss: PWChar;
     pchHostNS: PWChar;
 end;
 
 PDocHostUIInfo = ^TDocHostUIInfo;
 IDocHostUIHandler = interface(IUnknown)
     ['{bd3f23c0-d43e-11cf-893b-00aa00bdce1a}']
     function ShowContextMenu(const dwID: DWORD; const ppt: PPOINT;
       const pcmdtReserved: IUnknown; const pdispReserved: IDispatch): HResult;
       stdcall;
     function GetHostInfo(var pInfo: TDocHostUIInfo): HResult; stdcall;
     function ShowUI(const dwID: DWORD;
       const pActiveObject: IOleInPlaceActiveObject;
       const pCommandTarget: IOleCommandTarget; const pFrame: IOleInPlaceFrame;
       const pDoc: IOleInPlaceUIWindow): HResult; stdcall;
     function HideUI: HResult; stdcall;
     function UpdateUI: HResult; stdcall;
     function EnableModeless(const fEnable: BOOL): HResult; stdcall;
     function OnDocWindowActivate(const fActivate: BOOL): HResult; stdcall;
     function OnFrameWindowActivate(const fActivate: BOOL): HResult; stdcall;
     function ResizeBorder(const prcBorder: PRECT;
       const pUIWindow: IOleInPlaceUIWindow; const fFrameWindow: BOOL): HResult;
       stdcall;
     function TranslateAccelerator(const lpMsg: PMSG; const pguidCmdGroup: PGUID;
       const nCmdID: DWORD): HResult; stdcall;
     function GetOptionKeyPath(var pchKey: POLESTR; const dw: DWORD ): HResult;
       stdcall;
     function GetDropTarget(const pDropTarget: IDropTarget;
       out ppDropTarget: IDropTarget): HResult; stdcall;
     function GetExternal(out ppDispatch: IDispatch): HResult; stdcall;
     function TranslateUrl(const dwTranslate: DWORD; const pchURLIn: POLESTR;
      var ppchURLOut: POLESTR): HResult; stdcall;
     function FilterDataObject(const pDO: IDataObject;
       out ppDORet: IDataObject): HResult; stdcall;
    end;
 
 implementation

 end.


