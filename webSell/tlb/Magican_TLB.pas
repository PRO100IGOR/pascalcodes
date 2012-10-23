unit Magican_TLB;

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

// $Rev: 8291 $
// File generated on 2012-5-22 10:46:43 from Type Library described below.

// ************************************************************************  //
// Type Lib: E:\pro\del\webSell\tlb\Magican.tlb (1)
// LIBID: {FD299DFA-F003-4EFA-BB0E-705C7137C79F}
// LCID: 0
// Helpfile: 
// HelpString: Magican Library
// DepndLst: 
//   (1) v2.0 stdole, (C:\WINDOWS\system32\stdole2.tlb)
// ************************************************************************ //
{$TYPEDADDRESS OFF} // Unit must be compiled without type-checked pointers. 
{$WARN SYMBOL_PLATFORM OFF}
{$WRITEABLECONST ON}
{$VARPROPSETTER ON}
interface

uses Windows, ActiveX, Classes, Graphics, StdVCL, Variants;
  

// *********************************************************************//
// GUIDS declared in the TypeLibrary. Following prefixes are used:        
//   Type Libraries     : LIBID_xxxx                                      
//   CoClasses          : CLASS_xxxx                                      
//   DISPInterfaces     : DIID_xxxx                                       
//   Non-DISP interfaces: IID_xxxx                                        
// *********************************************************************//
const
  // TypeLibrary Major and minor versions
  MagicanMajorVersion = 1;
  MagicanMinorVersion = 0;

  LIBID_Magican: TGUID = '{FD299DFA-F003-4EFA-BB0E-705C7137C79F}';

  IID_BigExternal: TGUID = '{686FB3EB-0B0F-48FE-B1AD-D010354DD05E}';
type

// *********************************************************************//
// Forward declaration of types defined in TypeLibrary                    
// *********************************************************************//
  BigExternal = interface;
  BigExternalDisp = dispinterface;

// *********************************************************************//
// Interface: BigExternal
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {686FB3EB-0B0F-48FE-B1AD-D010354DD05E}
// *********************************************************************//
  BigExternal = interface(IDispatch)
    ['{686FB3EB-0B0F-48FE-B1AD-D010354DD05E}']
    procedure Show; safecall;
  end;

// *********************************************************************//
// DispIntf:  BigExternalDisp
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {686FB3EB-0B0F-48FE-B1AD-D010354DD05E}
// *********************************************************************//
  BigExternalDisp = dispinterface
    ['{686FB3EB-0B0F-48FE-B1AD-D010354DD05E}']
    procedure Show; dispid 201;
  end;

implementation

uses ComObj;

end.
