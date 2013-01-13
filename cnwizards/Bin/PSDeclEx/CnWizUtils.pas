{******************************************************************************}
{                       CnPack For Delphi/C++Builder                           }
{                     �й����Լ��Ŀ���Դ�������������                         }
{                   (C)Copyright 2001-2011 CnPack ������                       }
{                   ------------------------------------                       }
{                                                                              }
{            ���������ǿ�Դ��������������������� CnPack �ķ���Э������        }
{        �ĺ����·�����һ����                                                }
{                                                                              }
{            ������һ��������Ŀ����ϣ�������ã���û���κε���������û��        }
{        �ʺ��ض�Ŀ�Ķ������ĵ���������ϸ���������� CnPack ����Э�顣        }
{                                                                              }
{            ��Ӧ���Ѿ��Ϳ�����һ���յ�һ�� CnPack ����Э��ĸ��������        }
{        ��û�У��ɷ������ǵ���վ��                                            }
{                                                                              }
{            ��վ��ַ��http://www.cnpack.org                                   }
{            �����ʼ���master@cnpack.org                                       }
{                                                                              }
{******************************************************************************}

{******************************************************************************}
{ Unit Note:                                                                   }
{    This file is partly derived from GExperts 1.2                             }
{                                                                              }
{ Original author:                                                             }
{    GExperts, Inc  http://www.gexperts.org/                                   }
{    Erik Berry <eberry@gexperts.org> or <eb@techie.com>                       }
{******************************************************************************}

unit CnWizUtils;
{* |<PRE>
================================================================================
* ������ƣ�CnPack IDE ר�Ұ�
* ��Ԫ���ƣ��ڽű���ʹ�õ� CnWizUtils ��Ԫ����
* ��Ԫ���ߣ�CnPack ������
* ��    ע������Ԫ�����������ͺͺ��������� Pascal Script �ű���ʹ��
* ����ƽ̨��PWin2000Pro + Delphi 5.01
* ���ݲ��ԣ�PWin9X/2000/XP + Delphi 5/6/7 + C++Builder 5/6
* �� �� �����õ�Ԫ�е��ַ��������ϱ��ػ�����ʽ
* ��Ԫ��ʶ��$Id: CnWizUtils.pas 953 2011-07-25 08:11:00Z liuxiaoshanzhashu@gmail.com $
* �޸ļ�¼��2006.12.31 V1.0
*               ������Ԫ
================================================================================
|</PRE>}

interface

uses
  Windows, Messages, Classes, Graphics, Controls, SysUtils, Menus, ImgList,
  ActnList, Forms, ComCtrls,
{$IFNDEF VER130}
  DesignIntf,
{$ENDIF}
  ToolsAPI;

type
  TCnCompilerKind = (ckDelphi, ckBCB);
  TCnCompiler = (cnDelphi5, cnDelphi6, cnDelphi7, cnDelphi8, cnDelphi9,
    cnDelphi10, cnDelphi11, cnDelphi12, cnDelphi14, cnBCB5, cnBCB6);

const
  // ���³�����ʵ��ֵȡ���ڵ�ǰ������
  Compiler: TCnCompiler = cnDelphi5;
  CompilerKind: TCnCompilerKind = ckDelphi;
  CompilerName = 'Delphi 5';
  CompilerShortName = 'D5';

  _DELPHI = {$IFDEF DELPHI}True{$ELSE}False{$ENDIF};
  _BCB = {$IFDEF BCB}True{$ELSE}False{$ENDIF};
  _BDS = {$IFDEF BDS}True{$ELSE}False{$ENDIF};

  _DELPHI1 = {$IFDEF DELPHI1}True{$ELSE}False{$ENDIF};
  _DELPHI2 = {$IFDEF DELPHI2}True{$ELSE}False{$ENDIF};
  _DELPHI3 = {$IFDEF DELPHI3}True{$ELSE}False{$ENDIF};
  _DELPHI4 = {$IFDEF DELPHI4}True{$ELSE}False{$ENDIF};
  _DELPHI5 = {$IFDEF DELPHI5}True{$ELSE}False{$ENDIF};
  _DELPHI6 = {$IFDEF DELPHI6}True{$ELSE}False{$ENDIF};
  _DELPHI7 = {$IFDEF DELPHI7}True{$ELSE}False{$ENDIF};
  _DELPHI8 = {$IFDEF DELPHI8}True{$ELSE}False{$ENDIF};
  _DELPHI9 = {$IFDEF DELPHI9}True{$ELSE}False{$ENDIF};
  _DELPHI10 = {$IFDEF DELPHI10}True{$ELSE}False{$ENDIF};
  _DELPHI11 = {$IFDEF DELPHI11}True{$ELSE}False{$ENDIF};
  _DELPHI12 = {$IFDEF DELPHI12}True{$ELSE}False{$ENDIF};
  _DELPHI14 = {$IFDEF DELPHI14}True{$ELSE}False{$ENDIF};

  _DELPHI1_UP = {$IFDEF DELPHI1_UP}True{$ELSE}False{$ENDIF};
  _DELPHI2_UP = {$IFDEF DELPHI2_UP}True{$ELSE}False{$ENDIF};
  _DELPHI3_UP = {$IFDEF DELPHI3_UP}True{$ELSE}False{$ENDIF};
  _DELPHI4_UP = {$IFDEF DELPHI4_UP}True{$ELSE}False{$ENDIF};
  _DELPHI5_UP = {$IFDEF DELPHI5_UP}True{$ELSE}False{$ENDIF};
  _DELPHI6_UP = {$IFDEF DELPHI6_UP}True{$ELSE}False{$ENDIF};
  _DELPHI7_UP = {$IFDEF DELPHI7_UP}True{$ELSE}False{$ENDIF};
  _DELPHI8_UP = {$IFDEF DELPHI8_UP}True{$ELSE}False{$ENDIF};
  _DELPHI9_UP = {$IFDEF DELPHI9_UP}True{$ELSE}False{$ENDIF};
  _DELPHI10_UP = {$IFDEF DELPHI10_UP}True{$ELSE}False{$ENDIF};
  _DELPHI11_UP = {$IFDEF DELPHI11_UP}True{$ELSE}False{$ENDIF};
  _DELPHI12_UP = {$IFDEF DELPHI12_UP}True{$ELSE}False{$ENDIF};
  _DELPHI14_UP = {$IFDEF DELPHI14_UP}True{$ELSE}False{$ENDIF};

  _BCB1 = {$IFDEF BCB1}True{$ELSE}False{$ENDIF};
  _BCB3 = {$IFDEF BCB3}True{$ELSE}False{$ENDIF};
  _BCB4 = {$IFDEF BCB4}True{$ELSE}False{$ENDIF};
  _BCB5 = {$IFDEF BCB5}True{$ELSE}False{$ENDIF};
  _BCB6 = {$IFDEF BCB6}True{$ELSE}False{$ENDIF};
  _BCB7 = {$IFDEF BCB7}True{$ELSE}False{$ENDIF};
  _BCB10 = {$IFDEF BCB10}True{$ELSE}False{$ENDIF};
  _BCB11 = {$IFDEF BCB11}True{$ELSE}False{$ENDIF};
  _BCB12 = {$IFDEF BCB12}True{$ELSE}False{$ENDIF};
  _BCB14 = {$IFDEF BCB14}True{$ELSE}False{$ENDIF};

  _BCB1_UP = {$IFDEF BCB1_UP}True{$ELSE}False{$ENDIF};
  _BCB3_UP = {$IFDEF BCB3_UP}True{$ELSE}False{$ENDIF};
  _BCB4_UP = {$IFDEF BCB4_UP}True{$ELSE}False{$ENDIF};
  _BCB5_UP = {$IFDEF BCB5_UP}True{$ELSE}False{$ENDIF};
  _BCB6_UP = {$IFDEF BCB6_UP}True{$ELSE}False{$ENDIF};
  _BCB7_UP = {$IFDEF BCB7_UP}True{$ELSE}False{$ENDIF};
  _BCB10_UP = {$IFDEF BCB10_UP}True{$ELSE}False{$ENDIF};
  _BCB11_UP = {$IFDEF BCB11_UP}True{$ELSE}False{$ENDIF};
  _BCB12_UP = {$IFDEF BCB12_UP}True{$ELSE}False{$ENDIF};
  _BCB14_UP = {$IFDEF BCB14_UP}True{$ELSE}False{$ENDIF};

  _KYLIX1 = {$IFDEF KYLIX1}True{$ELSE}False{$ENDIF};
  _KYLIX2 = {$IFDEF KYLIX2}True{$ELSE}False{$ENDIF};
  _KYLIX3 = {$IFDEF KYLIX3}True{$ELSE}False{$ENDIF};

  _KYLIX1_UP = {$IFDEF KYLIX1_UP}True{$ELSE}False{$ENDIF};
  _KYLIX2_UP = {$IFDEF KYLIX2_UP}True{$ELSE}False{$ENDIF};
  _KYLIX3_UP = {$IFDEF KYLIX3_UP}True{$ELSE}False{$ENDIF};

  _BDS2 = {$IFDEF BDS2}True{$ELSE}False{$ENDIF};
  _BDS3 = {$IFDEF BDS3}True{$ELSE}False{$ENDIF};
  _BDS4 = {$IFDEF BDS4}True{$ELSE}False{$ENDIF};
  _BDS5 = {$IFDEF BDS5}True{$ELSE}False{$ENDIF};
  _BDS6 = {$IFDEF BDS6}True{$ELSE}False{$ENDIF};
  _BDS7 = {$IFDEF BDS7}True{$ELSE}False{$ENDIF};

  _BDS2_UP = {$IFDEF BDS2_UP}True{$ELSE}False{$ENDIF};
  _BDS3_UP = {$IFDEF BDS3_UP}True{$ELSE}False{$ENDIF};
  _BDS4_UP = {$IFDEF BDS4_UP}True{$ELSE}False{$ENDIF};
  _BDS5_UP = {$IFDEF BDS5_UP}True{$ELSE}False{$ENDIF};
  _BDS6_UP = {$IFDEF BDS6_UP}True{$ELSE}False{$ENDIF};
  _BDS7_UP = {$IFDEF BDS7_UP}True{$ELSE}False{$ENDIF};

  _COMPILER1 = {$IFDEF COMPILER1}True{$ELSE}False{$ENDIF};
  _COMPILER2 = {$IFDEF COMPILER2}True{$ELSE}False{$ENDIF};
  _COMPILER3 = {$IFDEF COMPILER3}True{$ELSE}False{$ENDIF};
  _COMPILER35 = {$IFDEF COMPILER35}True{$ELSE}False{$ENDIF};
  _COMPILER4 = {$IFDEF COMPILER4}True{$ELSE}False{$ENDIF};
  _COMPILER5 = {$IFDEF COMPILER5}True{$ELSE}False{$ENDIF};
  _COMPILER6 = {$IFDEF COMPILER6}True{$ELSE}False{$ENDIF};
  _COMPILER7 = {$IFDEF COMPILER7}True{$ELSE}False{$ENDIF};
  _COMPILER8 = {$IFDEF COMPILER8}True{$ELSE}False{$ENDIF};
  _COMPILER9 = {$IFDEF COMPILER9}True{$ELSE}False{$ENDIF};
  _COMPILER10 = {$IFDEF COMPILER10}True{$ELSE}False{$ENDIF};
  _COMPILER11 = {$IFDEF COMPILER11}True{$ELSE}False{$ENDIF};
  _COMPILER12 = {$IFDEF COMPILER12}True{$ELSE}False{$ENDIF};
  _COMPILER14 = {$IFDEF COMPILER14}True{$ELSE}False{$ENDIF};

  _COMPILER1_UP = {$IFDEF COMPILER1_UP}True{$ELSE}False{$ENDIF};
  _COMPILER2_UP = {$IFDEF COMPILER2_UP}True{$ELSE}False{$ENDIF};
  _COMPILER3_UP = {$IFDEF COMPILER3_UP}True{$ELSE}False{$ENDIF};
  _COMPILER35_UP = {$IFDEF COMPILER35_UP}True{$ELSE}False{$ENDIF};
  _COMPILER4_UP = {$IFDEF COMPILER4_UP}True{$ELSE}False{$ENDIF};
  _COMPILER5_UP = {$IFDEF COMPILER5_UP}True{$ELSE}False{$ENDIF};
  _COMPILER6_UP = {$IFDEF COMPILER6_UP}True{$ELSE}False{$ENDIF};
  _COMPILER7_UP = {$IFDEF COMPILER7_UP}True{$ELSE}False{$ENDIF};
  _COMPILER8_UP = {$IFDEF COMPILER8_UP}True{$ELSE}False{$ENDIF};
  _COMPILER9_UP = {$IFDEF COMPILER9_UP}True{$ELSE}False{$ENDIF};
  _COMPILER10_UP = {$IFDEF COMPILER10_UP}True{$ELSE}False{$ENDIF};
  _COMPILER11_UP = {$IFDEF COMPILER11_UP}True{$ELSE}False{$ENDIF};
  _COMPILER12_UP = {$IFDEF COMPILER12_UP}True{$ELSE}False{$ENDIF};
  _COMPILER14_UP = {$IFDEF COMPILER14_UP}True{$ELSE}False{$ENDIF};

type
  TFormType = (ftBinary, ftText, ftUnknown);
  TCnCharSet = set of Char;

//==============================================================================
// ������Ϣ����
//==============================================================================

function CnIntToObject(AInt: Integer): TObject;
{* �� Pascal Script ʹ�õĽ�����ֵת���� TObject �ĺ���}
function CnWizLoadIcon(AIcon: TIcon; const ResName: string): Boolean;
{* ����Դ���ļ���װ��ͼ�ִ꣬��ʱ�ȴ�ͼ��Ŀ¼�в��ң����ʧ���ٴ���Դ�в��ң�
   ���ؽ��Ϊͼ��װ�سɹ���־������ ResName �벻Ҫ�� .ico ��չ��}
function CnWizLoadBitmap(ABitmap: TBitmap; const ResName: string): Boolean;
{* ����Դ���ļ���װ��λͼ��ִ��ʱ�ȴ�ͼ��Ŀ¼�в��ң����ʧ���ٴ���Դ�в��ң�
   ���ؽ��Ϊλͼװ�سɹ���־������ ResName �벻Ҫ�� .bmp ��չ��}
function AddIconToImageList(AIcon: TIcon; ImageList: TCustomImageList): Integer;
{* ����ͼ�굽 ImageList �У�ʹ��ƽ������}
function CreateDisabledBitmap(Glyph: TBitmap): TBitmap;
{* ����һ�� Disabled ��λͼ�����ض�����Ҫ���÷��ͷ�}
procedure AdjustButtonGlyph(Glyph: TBitmap);
{* Delphi �İ�ť�� Disabled ״̬ʱ����ʾ��ͼ����ѿ����ú���ͨ���ڸ�λͼ�Ļ�����
   ����һ���µĻҶ�λͼ�������һ���⡣������ɺ� Glyph ��ȱ�Ϊ�߶ȵ���������Ҫ
   ���� Button.NumGlyphs := 2 }
function SameFileName(const S1, S2: string): Boolean;
{* �ļ�����ͬ}
function CompressWhiteSpace(const Str: string): string;
{* ѹ���ַ����м�Ŀհ��ַ�}
procedure ShowHelp(const Topic: string);
{* ��ʾָ������İ�������}
procedure CenterForm(const Form: TCustomForm);
{* �������}
procedure EnsureFormVisible(const Form: TCustomForm);
{* ��֤����ɼ�}
function GetCaptionOrgStr(const Caption: string): string;
{* ɾ���������ȼ���Ϣ}
function GetIDEImageList: TCustomImageList;
{* ȡ�� IDE �� ImageList}
procedure SaveIDEImageListToPath(const Path: string);
{* ���� IDE ImageList �е�ͼ��ָ��Ŀ¼��}
procedure SaveMenuNamesToFile(AMenu: TMenuItem; const FileName: string);
{* ����˵������б��ļ�}
function GetIDEMainMenu: TMainMenu;
{* ȡ�� IDE ���˵�}
function GetIDEToolsMenu: TMenuItem;
{* ȡ�� IDE ���˵��µ� Tools �˵�}
function GetIDEActionList: TCustomActionList;
{* ȡ�� IDE �� ActionList}
function GetIDEActionFromShortCut(ShortCut: TShortCut): TCustomAction;
{* ȡ�� IDE �� ActionList ��ָ����ݼ��� Action}
function GetIdeRootDirectory: string;
{* ȡ�� IDE ��Ŀ¼}
function ReplaceToActualPath(const Path: string): string;
{* �� $(DELPHI) �����ķ����滻Ϊ Delphi ����·��}
procedure SaveIDEActionListToFile(const FileName: string);
{* ���� IDE ActionList �е����ݵ�ָ���ļ�}
procedure SaveIDEOptionsNameToFile(const FileName: string);
{* ���� IDE �������ñ�������ָ���ļ�}
procedure SaveProjectOptionsNameToFile(const FileName: string);
{* ���浱ǰ���̻������ñ�������ָ���ļ�}
function FindIDEAction(const ActionName: string): TContainedAction;
{* ���� IDE Action �������ض���}
function ExecuteIDEAction(const ActionName: string): Boolean;
{* ���� IDE Action ����ִ����}
function AddMenuItem(Menu: TMenuItem; const Caption: string;
  OnClick: TNotifyEvent = nil; Action: TContainedAction = nil;
  ShortCut: TShortCut = 0; const Hint: string = ''; Tag: Integer = 0): TMenuItem;
{* ����һ���Ӳ˵���}
function AddSepMenuItem(Menu: TMenuItem): TMenuItem;
{* ����һ���ָ��˵���}
procedure SortListByMenuOrder(List: TList);
{* ���� TCnMenuWizard �б��е� MenuOrder ֵ������С���������}
function IsTextForm(const FileName: string): Boolean;
{* ���� DFM �ļ��Ƿ��ı���ʽ}
procedure DoHandleException(const ErrorMsg: string);
{* ����һЩִ�з����е��쳣}
function FindComponentByClassName(AWinControl: TWinControl;
  const AClassName: string; const AComponentName: string = ''): TComponent;
{* �ڴ��ڿؼ��в���ָ�������������}
function ScreenHasModalForm: Boolean;
{* ����ģʽ����}
procedure SetFormNoTitle(Form: TForm);
{* ȥ������ı���}
procedure SendKey(vk: Word);
{* ����һ�������¼�}
function IMMIsActive: Boolean;
{* �ж����뷨�Ƿ��}
function GetCaretPosition(var Pt: TPoint): Boolean;
{* ȡ�༭�������Ļ������}
procedure GetCursorList(List: TStrings);
{* ȡCursor��ʶ���б� }
procedure GetCharsetList(List: TStrings);
{* ȡFontCharset��ʶ���б� }
procedure GetColorList(List: TStrings);
{* ȡColor��ʶ���б� }
function HandleEditShortCut(AControl: TWinControl; AShortCut: TShortCut): Boolean;
{* ʹ�ؼ������׼�༭��ݼ� }

//==============================================================================
// �ؼ������� 
//==============================================================================

type
  TCnSelectMode = (smAll, smNone, smInvert);

function CnGetComponentText(Component: TComponent): string;
{* ��������ı���}
function CnGetComponentAction(Component: TComponent): TBasicAction;
{* ȡ�ؼ������� Action }
procedure RemoveListViewSubImages(ListView: TListView);
{* ���� ListView �ؼ���ȥ������� SubItemImages }
function GetListViewWidthString(AListView: TListView): string;
{* ת�� ListView ������Ϊ�ַ��� }
procedure SetListViewWidthString(AListView: TListView; const Text: string);
{* ת���ַ���Ϊ ListView ������ }
function ListViewSelectedItemsCanUp(AListView: TListView): Boolean;
{* ListView ��ǰѡ�����Ƿ��������� }
function ListViewSelectedItemsCanDown(AListView: TListView): Boolean;
{* ListView ��ǰѡ�����Ƿ��������� }
procedure ListViewSelectItems(AListView: TListView; Mode: TCnSelectMode);
{* �޸� ListView ��ǰѡ���� }

//==============================================================================
// �������ж� IDE/BDS �� Delphi ���� C++Builder ���Ǳ��
//==============================================================================

function IsDelphiRuntime: Boolean;
{* �ø��ַ����жϵ�ǰ IDE �Ƿ��� Delphi(.NET)�����򷵻� True�������򷵻� False}

function IsCSharpRuntime: Boolean;
{* �ø��ַ����жϵ�ǰ IDE �Ƿ��� C#�����򷵻� True�������򷵻� False}

function IsDelphiProject(Project: IOTAProject): Boolean;
{* �жϵ�ǰ�Ƿ��� Delphi ����}

//==============================================================================
// �ļ����жϴ����� (���� GExperts Src 1.12)
//==============================================================================

function CurrentIsDelphiSource: Boolean;
{* ��ǰ�༭���ļ���DelphiԴ�ļ�}
function CurrentIsCSource: Boolean;
{* ��ǰ�༭���ļ���CԴ�ļ�}
function CurrentIsSource: Boolean;
{* ��ǰ�༭���ļ���Delphi��CԴ�ļ�}
function CurrentIsForm: Boolean;
{* ��ǰ�༭���ļ��Ǵ����ļ�}
function ExtractUpperFileExt(const FileName: string): string;
{* ȡ��д�ļ���չ��}
procedure AssertIsDprOrPas(const FileName: string);
{* �ٶ���.Dpr��.Pas�ļ�}
procedure AssertIsDprOrPasOrInc(const FileName: string);
{* �ٶ���.Dpr��.Pas��.Inc�ļ�}
procedure AssertIsPasOrInc(const FileName: string);
{* �ٶ���.Pas��.Inc�ļ�}
function IsSourceModule(const FileName: string): Boolean;
{* �ж��Ƿ�Delphi��C++Դ�ļ�}
function IsDelphiSourceModule(const FileName: string): Boolean;
{* �ж��Ƿ�DelphiԴ�ļ�}
function IsDprOrPas(const FileName: string): Boolean;
{* �ж��Ƿ�.Dpr��.Pas�ļ�}
function IsDpr(const FileName: string): Boolean;
{* �ж��Ƿ�.Dpr�ļ�}
function IsBpr(const FileName: string): Boolean;
{* �ж��Ƿ�.Bpr�ļ�}
function IsProject(const FileName: string): Boolean;
{* �ж��Ƿ�.Bpr��.Dpr�ļ�}
function IsBdsProject(const FileName: string): Boolean;
{* �ж��Ƿ�.bdsproj�ļ�}
function IsDProject(const FileName: string): Boolean;
{* �ж��Ƿ�.dproj�ļ�}
function IsCbProject(const FileName: string): Boolean;
{* �ж��Ƿ�.cbproj�ļ�}
function IsDpk(const FileName: string): Boolean;
{* �ж��Ƿ�.Dpk�ļ�}
function IsBpk(const FileName: string): Boolean;
{* �ж��Ƿ�.Bpk�ļ�}
function IsPackage(const FileName: string): Boolean;
{* �ж��Ƿ�.Dpk��.Bpk�ļ�}
function IsBpg(const FileName: string): Boolean;
{* �ж��Ƿ�.Bpg�ļ�}
function IsPas(const FileName: string): Boolean;
{* �ж��Ƿ�.Pas�ļ�}
function IsDcu(const FileName: string): Boolean;
{* �ж��Ƿ�.Dcu�ļ�}
function IsInc(const FileName: string): Boolean;
{* �ж��Ƿ�.Inc�ļ�}
function IsDfm(const FileName: string): Boolean;
{* �ж��Ƿ�.Dfm�ļ�}
function IsForm(const FileName: string): Boolean;
{* �ж��Ƿ����ļ�}
function IsXfm(const FileName: string): Boolean;
{* �ж��Ƿ�.Xfm�ļ�}
function IsCppSourceModule(const FileName: string): Boolean;
{* �ж��Ƿ��������͵�C++Դ�ļ�}
function IsCpp(const FileName: string): Boolean;
{* �ж��Ƿ�.Cpp�ļ�}
function IsHpp(const FileName: string): Boolean;
{* �ж��Ƿ�.Hpp�ļ�}
function IsC(const FileName: string): Boolean;
{* �ж��Ƿ�.C�ļ�}
function IsH(const FileName: string): Boolean;
{* �ж��Ƿ�.H�ļ�}
function IsAsm(const FileName: string): Boolean;
{* �ж��Ƿ�.ASM�ļ�}
function IsRC(const FileName: string): Boolean;
{* �ж��Ƿ�.RC�ļ�}
function IsKnownSourceFile(const FileName: string): Boolean;
{* �ж��Ƿ�δ֪�ļ�}
function IsTypeLibrary(const FileName: string): Boolean;
{* �ж��Ƿ��� TypeLibrary �ļ�}
function ObjectIsInheritedFromClass(AObj: TObject; const AClassName: string): Boolean;
{* ʹ���ַ����ķ�ʽ�ж϶����Ƿ�̳��Դ���}
function FindControlByClassName(AParent: TWinControl; const AClassName: string): TControl;
{* ʹ���ַ����ķ�ʽ�жϿؼ��Ƿ����ָ���������ӿؼ��������򷵻�������һ��}

//==============================================================================
// OTA �ӿڲ�����غ���
//==============================================================================

{* ��ѯ����ķ���ӿڲ�����һ��ָ���ӿ�ʵ�������ʧ�ܣ����� False}
function CnOtaGetEditBuffer: IOTAEditBuffer;
{* ȡIOTAEditBuffer�ӿ�}
function CnOtaGetEditPosition: IOTAEditPosition;
{* ȡIOTAEditPosition�ӿ�}
function CnOtaGetTopMostEditView(SourceEditor: IOTASourceEditor): IOTAEditView; overload;
{* ȡָ���༭����ǰ�˵�IOTAEditView�ӿ�}
function CnOtaGetTopMostEditActions: IOTAEditActions;
{* ȡ��ǰ��ǰ�˵� IOTAEditActions �ӿ�}
function CnOtaGetCurrentModule: IOTAModule;
{* ȡ��ǰģ��}
function CnOtaGetCurrentSourceEditor: IOTASourceEditor;
{* ȡ��ǰԴ��༭��}
function CnOtaGetFileEditorForModule(Module: IOTAModule; Index: Integer): IOTAEditor;
{* ȡģ��༭��}
function CnOtaGetFormEditorFromModule(const Module: IOTAModule): IOTAFormEditor;
{* ȡ����༭��}
function CnOtaGetCurrentFormEditor: IOTAFormEditor;
{* ȡ��ǰ����༭��}
function CnOtaGetSelectedControlFromCurrentForm(List: TList): Boolean;
{* ȡ�õ�ǰ����༭������ѡ��Ŀؼ�}
function CnOtaShowFormForModule(const Module: IOTAModule): Boolean;
{* ��ʾָ��ģ��Ĵ��� (���� GExperts Src 1.2)}
procedure CnOtaShowDesignerForm;
{* ��ʾ��ǰ��ƴ��� }
function CnOtaGetFormDesigner(FormEditor: IOTAFormEditor = nil): IDesigner;
{* ȡ��ǰ�Ĵ��������}
function CnOtaGetActiveDesignerType: string;
{* ȡ��ǰ����������ͣ������ַ��� dfm �� xfm}
function CnOtaGetComponentName(Component: IOTAComponent; var Name: string): Boolean;
{* ȡ���������}
function CnOtaGetComponentText(Component: IOTAComponent): string;
{* ��������ı���}
function CnOtaGetModule(const FileName: string): IOTAModule;
{* �����ļ�������ģ��ӿ�}
function CnOtaGetModuleCountFromProject(Project: IOTAProject): Integer;
{* ȡ��ǰ������ģ�������޹��̷��� -1}
function CnOtaGetModuleFromProjectByIndex(Project: IOTAProject; Index: Integer): IOTAModuleInfo;
{* ȡ��ǰ�����еĵ� Index ��ģ����Ϣ���� 0 ��ʼ}
function CnOtaGetEditor(const FileName: string): IOTAEditor;
{* �����ļ������ر༭���ӿ�}
function CnOtaGetRootComponentFromEditor(Editor: IOTAFormEditor): TComponent;
{* ���ش���༭����ƴ������}
function CnOtaGetCurrentEditWindow: TCustomForm;
{* ȡ��ǰ�� EditWindow}
function CnOtaGetCurrentEditControl: TWinControl;
{* ȡ��ǰ�� EditControl �ؼ�}
function CnOtaGetUnitName(Editor: IOTASourceEditor): string;
{* ���ص�Ԫ����}
function CnOtaGetProjectGroup: IOTAProjectGroup;
{* ȡ��ǰ������}
function CnOtaGetProjectGroupFileName: string;
{* ȡ��ǰ�������ļ���}
function CnOtaGetProjectResource(Project: IOTAProject): IOTAProjectResource;
{* ȡ������Դ}
function CnOtaGetCurrentProject: IOTAProject;
{* ȡ��ǰ����}
function CnOtaGetProject: IOTAProject;
{* ȡ��һ������}
function CnOtaGetProjectCountFromGroup: Integer;
{* ȡ��ǰ�������й��������޹����鷵�� -1}
function CnOtaGetProjectFromGroupByIndex(Index: Integer): IOTAProject;
{* ȡ��ǰ�������еĵ� Index �����̣��� 0 ��ʼ}
procedure CnOtaGetOptionsNames(Options: IOTAOptions; List: TStrings;
  IncludeType: Boolean = True); overload;
{* ȡ�� IDE ���ñ������б�}
procedure CnOtaSetProjectOptionValue(Options: IOTAProjectOptions; const AOption,
  AValue: string);
{* ���õ�ǰ��Ŀ������ֵ}
procedure CnOtaGetProjectList(const List: TInterfaceList);
{* ȡ�����й����б�}
function CnOtaGetCurrentProjectName: string;
{* ȡ��ǰ��������}
function CnOtaGetCurrentProjectFileName: string;
{* ȡ��ǰ�����ļ�����}
function CnOtaGetCurrentProjectFileNameEx: string;
{* ȡ��ǰ�����ļ�������չ}
function CnOtaGetCurrentFormName: string;
{* ȡ��ǰ��������}
function CnOtaGetCurrentFormFileName: string;
{* ȡ��ǰ�����ļ�����}
function CnOtaGetFileNameOfModule(Module: IOTAModule;
  GetSourceEditorFileName: Boolean = False): string;
{* ȡָ��ģ���ļ�����GetSourceEditorFileName ��ʾ�Ƿ񷵻��ڴ���༭���д򿪵��ļ�}
function CnOtaGetFileNameOfCurrentModule(GetSourceEditorFileName: Boolean = False): string;
{* ȡ��ǰģ���ļ���}
function CnOtaGetEnvironmentOptions: IOTAEnvironmentOptions;
{* ȡ��ǰ��������}
function CnOtaGetEditOptions: IOTAEditOptions;
{* ȡ��ǰ�༭������}
function CnOtaGetActiveProjectOptions(Project: IOTAProject = nil): IOTAProjectOptions;
{* ȡ��ǰ����ѡ��}
function CnOtaGetActiveProjectOption(const Option: string; var Value: Variant): Boolean;
{* ȡ��ǰ����ָ��ѡ��}
function CnOtaGetPackageServices: IOTAPackageServices;
{* ȡ��ǰ�����������}
function CnOtaGetActiveProjectOptionsConfigurations(Project: IOTAProject = nil): IOTAProjectOptionsConfigurations;
{* ȡ��ǰ��������ѡ�2009 �����Ч}
function CnOtaGetNewFormTypeOption: TFormType;
{* ȡ�����������½�������ļ�����}
function CnOtaGetSourceEditorFromModule(Module: IOTAModule; const FileName: string = ''): IOTASourceEditor;
{* ����ָ��ģ��ָ���ļ����ĵ�Ԫ�༭��}
function CnOtaGetEditorFromModule(Module: IOTAModule; const FileName: string): IOTAEditor;
{* ����ָ��ģ��ָ���ļ����ı༭��}
function CnOtaGetEditActionsFromModule(Module: IOTAModule): IOTAEditActions;
{* ����ָ��ģ��� EditActions }
function CnOtaGetCurrentSelection: string;
{* ȡ��ǰѡ����ı�}
procedure CnOtaDeleteCurrentSelection;
{* ɾ��ѡ�е��ı�}
procedure CnOtaEditBackspace(Many: Integer);
{* �ڱ༭�����˸�}
procedure CnOtaEditDelete(Many: Integer);
{* �ڱ༭����ɾ��}
function CnOtaGetLineText(LineNum: Integer; EditBuffer: IOTAEditBuffer = nil;
  Count: Integer = 1): string;
{* ȡָ���е�Դ����}
function CnOtaGetCurrLineText(var Text: string; var LineNo: Integer;
  var CharIndex: Integer; View: IOTAEditView = nil): Boolean;
{* ȡ��ǰ��Դ����}
function CnNtaGetCurrLineText(var Text: string; var LineNo: Integer;
  var CharIndex: Integer): Boolean;
{* ʹ�� NTA ����ȡ��ǰ��Դ���롣�ٶȿ죬��ȡ�ص��ı��ǽ� Tab ��չ�ɿո�ġ�
   ���ʹ�� ConvertPos ��ת���� EditPos ���ܻ������⡣ֱ�ӽ� CharIndex + 1 
   ��ֵ�� EditPos.Col ���ɡ�}
function CnOtaGetCurrLineInfo(var LineNo, CharIndex, LineLen: Integer): Boolean;
{* ���� SourceEditor ��ǰ����Ϣ}
function CnOtaGetCurrPosToken(var Token: string; var CurrIndex: Integer;
  CheckCursorOutOfLineEnd: Boolean = True; FirstSet: TCnCharSet = [];
  CharSet: TCnCharSet = []): Boolean;
{* ȡ��ǰ����µı�ʶ��������ڱ�ʶ���е������ţ��ٶȽϿ�}
function CnOtaGetCurrChar(OffsetX: Integer = 0; View: IOTAEditView = nil): Char;
{* ȡ��ǰ����µ��ַ�������ƫ����}
function CnOtaDeleteCurrToken(FirstSet: TCnCharSet = [];
  CharSet: TCnCharSet = []): Boolean;
{* ɾ����ǰ����µı�ʶ��}
function CnOtaDeleteCurrTokenLeft(FirstSet: TCnCharSet = [];
  CharSet: TCnCharSet = []): Boolean;
{* ɾ����ǰ����µı�ʶ����벿��}
function CnOtaDeleteCurrTokenRight(FirstSet: TCnCharSet = [];
  CharSet: TCnCharSet = []): Boolean;
{* ɾ����ǰ����µı�ʶ���Ұ벿��}
function CnOtaIsEditPosOutOfLine(EditPos: TOTAEditPos; View: IOTAEditView = nil): Boolean;
{* �ж�λ���Ƿ񳬳���β�� }
procedure CnOtaSelectBlock(const Editor: IOTASourceEditor; const Start, After: TOTACharPos);
{* ѡ��һ�������}
function CnOtaCurrBlockEmpty: Boolean;
{* ���ص�ǰѡ��Ŀ��Ƿ�Ϊ�� }
function CnOtaOpenFile(const FileName: string): Boolean;
{* ���ļ�}
function CnOtaOpenUnSaveForm(const FormName: string): Boolean;
{* ��δ����Ĵ���}
function CnOtaIsFileOpen(const FileName: string): Boolean;
{* �ж��ļ��Ƿ��}
function CnOtaIsFormOpen(const FormName: string): Boolean;
{* �жϴ����Ƿ��}
function CnOtaIsModuleModified(AModule: IOTAModule): Boolean;
{* �ж�ģ���Ƿ��ѱ��޸�}
function CnOtaModuleIsShowingFormSource(Module: IOTAModule): Boolean;
{* ָ��ģ���Ƿ����ı����巽ʽ��ʾ, Lines Ϊת��ָ���У�<= 0 ����}
function CnOtaMakeSourceVisible(const FileName: string; Lines: Integer = 0): Boolean;
{* ��ָ���ļ��ɼ�}
function CnOtaIsDebugging: Boolean;
{* ��ǰ�Ƿ��ڵ���״̬}
function CnOtaGetBaseModuleFileName(const FileName: string): string;
{* ȡģ��ĵ�Ԫ�ļ���}

//==============================================================================
// Դ���������غ���
//==============================================================================

function StrToSourceCode(const Str, ADelphiReturn, ACReturn: string;
  Wrap: Boolean): string;
{* �ַ���תΪԴ���봮}

function CodeAutoWrap(Code: string; Width, Indent: Integer;
  IndentOnceOnly: Boolean): string;
{* �������Զ��л�Ϊ���д��롣
 |<PRE>
   Code: string            - Դ����
   Len: Integer            - �п��
   Indent: Integer         - ���к�������ַ���
   IndentOnceOnly: Boolean - �Ƿ���ڲ����ڶ���ʱ��������
 |</PRE>}

function ConvertTextToEditorText(const Text: string): string;
{* ת���ַ���Ϊ�༭��ʹ�õ��ַ��� }

function ConvertEditorTextToText(const Text: string): string;
{* ת���༭��ʹ�õ��ַ���Ϊ��ͨ�ַ��� }

function CnOtaGetCurrentSourceFile: string;
{* ȡ��ǰ�༭��Դ�ļ�}

type
  TInsertPos = (ipCur, ipFileHead, ipFileEnd, ipLineHead, ipLineEnd);
{* �ı�����λ��
 |<PRE>
   ipCur         - ��ǰ��괦
   ipFileHead    - �ļ�ͷ��
   ipFileEnd     - �ļ�β��
   ipLineHead    - ��ǰ����
   ipLineEnd     - ��ǰ��β
 |</PRE>}

function CnOtaInsertTextToCurSource(const Text: string; InsertPos: TInsertPos
  = ipCur): Boolean;
{* ����һ���ı�����ǰ���ڱ༭��Դ�ļ��У����سɹ���־
 |<PRE>
   Text: string           - �ı�����
   InsertPos: TInsertPos  - ����λ�ã�Ĭ��Ϊ ipCurr ��ǰλ��
 |</PRE>}

function CnOtaGetCurSourcePos(var Col, Row: Integer): Boolean;
{* ��õ�ǰ�༭��Դ�ļ��й���λ�ã����سɹ���־
 |<PRE>
   Col: Integer           - ��λ��
   Row: Integer           - ��λ��
 |</PRE>}

function CnOtaSetCurSourcePos(Col, Row: Integer): Boolean;
{* �趨��ǰ�༭��Դ�ļ��й���λ�ã����سɹ���־
 |<PRE>
   Col: Integer           - ��λ��
   Row: Integer           - ��λ��
 |</PRE>}

function CnOtaSetCurSourceCol(Col: Integer): Boolean;
{* �趨��ǰ�༭��Դ�ļ��й���λ�ã����سɹ���־}

function CnOtaSetCurSourceRow(Row: Integer): Boolean;
{* �趨��ǰ�༭��Դ�ļ��й���λ�ã����سɹ���־}

function CnOtaMovePosInCurSource(Pos: TInsertPos; OffsetRow, OffsetCol: Integer): Boolean;
{* �ڵ�ǰ�༭��Դ�ļ����ƶ���꣬���سɹ���־
 |<PRE>
   Pos: TInsertPos        - ���λ��
   Offset: Integer        - ƫ����
 |</PRE>}

function CnOtaGetCurrPos(SourceEditor: IOTASourceEditor = nil): Integer;
{* ���� SourceEditor ��ǰ���λ�õ����Ե�ַ}

function CnOtaGetCurrCharPos(SourceEditor: IOTASourceEditor = nil): TOTACharPos;
{* ���� SourceEditor ��ǰ���λ��}

function CnOtaEditPosToLinePos(EditPos: TOTAEditPos; EditView: IOTAEditView = nil): Integer;
{* �༭λ��ת��Ϊ����λ�� }

function CnOtaLinePosToEditPos(LinePos: Integer; EditView: IOTAEditView = nil): TOTAEditPos;
{* ����λ��ת��Ϊ�༭λ�� }

procedure CnOtaSaveReaderToStream(EditReader: IOTAEditReader; Stream:
  TMemoryStream; StartPos: Integer = 0; EndPos: Integer = 0;
  PreSize: Integer = 0; CheckUtf8: Boolean = True);
{* ����EditReader���ݵ�����}

function CnOtaSaveEditorToStream(Editor: IOTASourceEditor; Stream: TMemoryStream;
  FromCurrPos: Boolean; CheckUtf8: Boolean = True): Boolean;
{* ����༭���ı�������}

function CnOtaSaveCurrentEditorToStream(Stream: TMemoryStream; FromCurrPos:
  Boolean; CheckUtf8: Boolean = True): Boolean;
{* ���浱ǰ�༭���ı�������}

function CnOtaGetCurrentEditorSource: string;
{* ȡ�õ�ǰ�༭��Դ����}

procedure CnOtaInsertLineIntoEditor(const Text: string);
{* ����һ���ַ�������ǰ IOTASourceEditor������ Text Ϊ�����ı�ʱ����
   �����滻��ǰ��ѡ���ı���}

procedure CnOtaInsertSingleLine(Line: Integer; const Text: string;
  EditView: IOTAEditView = nil);
{* ����һ���ı���ǰ IOTASourceEditor��Line Ϊ�кţ�Text Ϊ���� }

procedure CnOtaInsertTextIntoEditor(const Text: string);
{* �����ı�����ǰ IOTASourceEditor����������ı���}

function CnOtaGetEditWriterForSourceEditor(SourceEditor: IOTASourceEditor = nil): IOTAEditWriter;
{* Ϊָ�� SourceEditor ����һ�� Writer���������Ϊ�շ��ص�ǰֵ��}

procedure CnOtaInsertTextIntoEditorAtPos(const Text: string; Position: Longint;
  SourceEditor: IOTASourceEditor = nil);
{* ��ָ��λ�ô������ı������ SourceEditor Ϊ��ʹ�õ�ǰֵ��}

procedure CnOtaGotoPosition(Position: Longint; EditView: IOTAEditView = nil;
  Middle: Boolean = True);
{* �ƶ���굽ָ��λ�ã���� EditView Ϊ��ʹ�õ�ǰֵ��}

function CnOtaGetEditPos(EditView: IOTAEditView): TOTAEditPos;
{* ���ص�ǰ���λ�ã���� EditView Ϊ��ʹ�õ�ǰֵ�� }

procedure CnOtaGotoEditPos(EditPos: TOTAEditPos; EditView: IOTAEditView = nil;
  Middle: Boolean = True);
{* �ƶ���굽ָ��λ�ã���� EditView Ϊ��ʹ�õ�ǰֵ��}

function CnOtaGetCharPosFromPos(Position: LongInt; EditView: IOTAEditView): TOTACharPos;
{* ת��һ������λ�õ� TOTACharPos����Ϊ�� D5/D6 �� IOTAEditView.PosToCharPos
   ���ܲ�����������}

function CnOtaGetBlockIndent: Integer;
{* ��õ�ǰ�༭����������� }

procedure CnOtaClosePage(EditView: IOTAEditView);
{* �ر�ģ����ͼ}

procedure CnOtaCloseEditView(AModule: IOTAModule);
{* ���ر�ģ�����ͼ�������ر�ģ��}

//==============================================================================
// ���������غ���
//==============================================================================

function CnOtaGetCurrDesignedForm(var AForm: TCustomForm; Selections: TList; 
  ExcludeForm: Boolean = True): Boolean;
{* ȡ�õ�ǰ��ƵĴ��弰ѡ�������б����سɹ���־
 |<PRE>
   var AForm: TCustomForm    - ������ƵĴ���
   Selections: TList         - ��ǰѡ�������б�������� nil �򲻷���
   ExcludeForm: Boolean      - ������ Form ����
   Result: Boolean           - ����ɹ�����Ϊ True
 |</PRE>}

function CnOtaGetCurrFormSelectionsCount: Integer;
{* ȡ��ǰ��ƵĴ�����ѡ��ؼ�������}

function CnOtaIsCurrFormSelectionsEmpty: Boolean;
{* �жϵ�ǰ��ƵĴ������Ƿ�ѡ���пؼ�}

procedure CnOtaNotifyFormDesignerModified(FormEditor: IOTAFormEditor = nil);
{* ֪ͨ��������������ѱ��}

function CnOtaSelectedComponentIsRoot(FormEditor: IOTAFormEditor = nil): Boolean;
{* �жϵ�ǰѡ��Ŀؼ��Ƿ�Ϊ��ƴ��屾��}

function CnOtaPropertyExists(const Component: IOTAComponent; const PropertyName: string): Boolean;
{* �ж�����ڿؼ���ָ�������Ƿ����}

procedure CnOtaSetCurrFormSelectRoot;
{* ���õ�ǰ����ڴ���ѡ������Ϊ��ƴ��屾��}

procedure CnOtaGetCurrFormSelectionsName(List: TStrings);
{* ȡ�õ�ǰѡ��Ŀؼ��������б�}

procedure CnOtaCopyCurrFormSelectionsName;
{* ���Ƶ�ǰѡ��Ŀؼ��������б�������}

function OTACharPos(CharIndex: SmallInt; Line: Longint): TOTACharPos;
{* ����һ��λ��ֵ}

function OTAEditPos(Col: SmallInt; Line: Longint): TOTAEditPos;
{* ����һ���༭λ��ֵ }

function SameEditPos(Pos1, Pos2: TOTAEditPos): Boolean;
{* �ж������༭λ���Ƿ���� }

function SameCharPos(Pos1, Pos2: TOTACharPos): Boolean;
{* �ж������ַ�λ���Ƿ���� }

function HWndIsNonvisualComponent(hWnd: HWND): Boolean;
{* �ж�һ�ؼ������Ƿ��Ƿǿ��ӻ��ؼ�}

implementation

{$WARNINGS OFF}

function CnIntToObject(AInt: Integer): TObject;
begin
end;

function CnWizLoadIcon(AIcon: TIcon; const ResName: string): Boolean;
begin
end;

function CnWizLoadBitmap(ABitmap: TBitmap; const ResName: string): Boolean;
begin
end;

function AddIconToImageList(AIcon: TIcon; ImageList: TCustomImageList): Integer;
begin
end;

function CreateDisabledBitmap(Glyph: TBitmap): TBitmap;
begin
end;

procedure AdjustButtonGlyph(Glyph: TBitmap);
begin
end;

function SameFileName(const S1, S2: string): Boolean;
begin
end;

function CompressWhiteSpace(const Str: string): string;
begin
end;

procedure ShowHelp(const Topic: string);
begin
end;

procedure CenterForm(const Form: TCustomForm);
begin
end;

procedure EnsureFormVisible(const Form: TCustomForm);
begin
end;

function GetCaptionOrgStr(const Caption: string): string;
begin
end;

function GetIDEImageList: TCustomImageList;
begin
end;

procedure SaveIDEImageListToPath(const Path: string);
begin
end;

procedure SaveMenuNamesToFile(AMenu: TMenuItem; const FileName: string);
begin
end;

function GetIDEMainMenu: TMainMenu;
begin
end;

function GetIDEToolsMenu: TMenuItem;
begin
end;

function GetIDEActionList: TCustomActionList;
begin
end;

function GetIDEActionFromShortCut(ShortCut: TShortCut): TCustomAction;
begin
end;

function GetIdeRootDirectory: string;
begin
end;

function ReplaceToActualPath(const Path: string): string;
begin
end;

procedure SaveIDEActionListToFile(const FileName: string);
begin
end;

procedure SaveIDEOptionsNameToFile(const FileName: string);
begin
end;

procedure SaveProjectOptionsNameToFile(const FileName: string);
begin
end;

function FindIDEAction(const ActionName: string): TContainedAction;
begin
end;

function ExecuteIDEAction(const ActionName: string): Boolean;
begin
end;

function AddMenuItem(Menu: TMenuItem; const Caption: string;
  OnClick: TNotifyEvent = nil; Action: TContainedAction = nil;
  ShortCut: TShortCut = 0; const Hint: string = ''; Tag: Integer = 0): TMenuItem;
begin
end;

function AddSepMenuItem(Menu: TMenuItem): TMenuItem;
begin
end;

procedure SortListByMenuOrder(List: TList);
begin
end;

function IsTextForm(const FileName: string): Boolean;
begin
end;

procedure DoHandleException(const ErrorMsg: string);
begin
end;

function FindComponentByClassName(AWinControl: TWinControl;
  const AClassName: string; const AComponentName: string = ''): TComponent;
begin
end;

function ScreenHasModalForm: Boolean;
begin
end;

procedure SetFormNoTitle(Form: TForm);
begin
end;

procedure SendKey(vk: Word);
begin
end;

function IMMIsActive: Boolean;
begin
end;

function GetCaretPosition(var Pt: TPoint): Boolean;
begin
end;

procedure GetCursorList(List: TStrings);
begin
end;

procedure GetCharsetList(List: TStrings);
begin
end;

procedure GetColorList(List: TStrings);
begin
end;

function HandleEditShortCut(AControl: TWinControl; AShortCut: TShortCut): Boolean;
begin
end;

function CnGetComponentText(Component: TComponent): string;
begin
end;

function CnGetComponentAction(Component: TComponent): TBasicAction;
begin
end;

procedure RemoveListViewSubImages(ListView: TListView);
begin
end;

function GetListViewWidthString(AListView: TListView): string;
begin
end;

procedure SetListViewWidthString(AListView: TListView; const Text: string);
begin
end;

function ListViewSelectedItemsCanUp(AListView: TListView): Boolean;
begin
end;

function ListViewSelectedItemsCanDown(AListView: TListView): Boolean;
begin
end;

procedure ListViewSelectItems(AListView: TListView; Mode: TCnSelectMode);
begin
end;

function IsDelphiRuntime: Boolean;
begin
end;

function IsCSharpRuntime: Boolean;
begin
end;

function IsDelphiProject(Project: IOTAProject): Boolean;
begin
end;

function CurrentIsDelphiSource: Boolean;
begin
end;

function CurrentIsCSource: Boolean;
begin
end;

function CurrentIsSource: Boolean;
begin
end;

function CurrentIsForm: Boolean;
begin
end;

function ExtractUpperFileExt(const FileName: string): string;
begin
end;

procedure AssertIsDprOrPas(const FileName: string);
begin
end;

procedure AssertIsDprOrPasOrInc(const FileName: string);
begin
end;

procedure AssertIsPasOrInc(const FileName: string);
begin
end;

function IsSourceModule(const FileName: string): Boolean;
begin
end;

function IsDelphiSourceModule(const FileName: string): Boolean;
begin
end;

function IsDprOrPas(const FileName: string): Boolean;
begin
end;

function IsDpr(const FileName: string): Boolean;
begin
end;

function IsBpr(const FileName: string): Boolean;
begin
end;

function IsProject(const FileName: string): Boolean;
begin
end;

function IsBdsProject(const FileName: string): Boolean;
begin
end;

function IsDProject(const FileName: string): Boolean;
begin
end;

function IsCbProject(const FileName: string): Boolean;
begin
end;

function IsDpk(const FileName: string): Boolean;
begin
end;

function IsBpk(const FileName: string): Boolean;
begin
end;

function IsPackage(const FileName: string): Boolean;
begin
end;

function IsBpg(const FileName: string): Boolean;
begin
end;

function IsPas(const FileName: string): Boolean;
begin
end;

function IsDcu(const FileName: string): Boolean;
begin
end;

function IsInc(const FileName: string): Boolean;
begin
end;

function IsDfm(const FileName: string): Boolean;
begin
end;

function IsForm(const FileName: string): Boolean;
begin
end;

function IsXfm(const FileName: string): Boolean;
begin
end;

function IsCppSourceModule(const FileName: string): Boolean;
begin
end;

function IsCpp(const FileName: string): Boolean;
begin
end;

function IsHpp(const FileName: string): Boolean;
begin
end;  

function IsC(const FileName: string): Boolean;
begin
end;

function IsH(const FileName: string): Boolean;
begin
end;

function IsAsm(const FileName: string): Boolean;
begin
end;

function IsRC(const FileName: string): Boolean;
begin
end;

function IsKnownSourceFile(const FileName: string): Boolean;
begin
end;

function IsTypeLibrary(const FileName: string): Boolean;
begin
end;

function ObjectIsInheritedFromClass(AObj: TObject; const AClassName: string): Boolean;
begin
end;

function FindControlByClassName(AParent: TWinControl; const AClassName: string): TControl;
begin
end;

function CnOtaGetEditBuffer: IOTAEditBuffer;
begin
end;

function CnOtaGetEditPosition: IOTAEditPosition;
begin
end;

function CnOtaGetTopMostEditView(SourceEditor: IOTASourceEditor): IOTAEditView; overload;
begin
end;

function CnOtaGetTopMostEditActions: IOTAEditActions;
begin
end;

function CnOtaGetCurrentModule: IOTAModule;
begin
end;

function CnOtaGetCurrentSourceEditor: IOTASourceEditor;
begin
end;

function CnOtaGetFileEditorForModule(Module: IOTAModule; Index: Integer): IOTAEditor;
begin
end;

function CnOtaGetFormEditorFromModule(const Module: IOTAModule): IOTAFormEditor;
begin
end;

function CnOtaGetCurrentFormEditor: IOTAFormEditor;
begin
end;

function CnOtaGetSelectedControlFromCurrentForm(List: TList): Boolean;
begin
end;

function CnOtaShowFormForModule(const Module: IOTAModule): Boolean;
begin
end;

procedure CnOtaShowDesignerForm;
begin
end;

function CnOtaGetFormDesigner(FormEditor: IOTAFormEditor = nil): IDesigner;
begin
end;

function CnOtaGetActiveDesignerType: string;
begin
end;

function CnOtaGetComponentName(Component: IOTAComponent; var Name: string): Boolean;
begin
end;

function CnOtaGetComponentText(Component: IOTAComponent): string;
begin
end;

function CnOtaGetModule(const FileName: string): IOTAModule;
begin
end;

function CnOtaGetModuleCountFromProject(Project: IOTAProject): Integer;
begin
end;

function CnOtaGetModuleFromProjectByIndex(Project: IOTAProject; Index: Integer): IOTAModuleInfo;
begin
end;

function CnOtaGetEditor(const FileName: string): IOTAEditor;
begin
end;

function CnOtaGetRootComponentFromEditor(Editor: IOTAFormEditor): TComponent;
begin
end;

function CnOtaGetCurrentEditWindow: TCustomForm;
begin
end;

function CnOtaGetCurrentEditControl: TWinControl;
begin
end;

function CnOtaGetUnitName(Editor: IOTASourceEditor): string;
begin
end;

function CnOtaGetProjectGroup: IOTAProjectGroup;
begin
end;

function CnOtaGetProjectGroupFileName: string;
begin
end;

function CnOtaGetProjectResource(Project: IOTAProject): IOTAProjectResource;
begin
end;

function CnOtaGetCurrentProject: IOTAProject;
begin
end;

function CnOtaGetProject: IOTAProject;
begin
end;

function CnOtaGetProjectCountFromGroup: Integer;
begin
end;

function CnOtaGetProjectFromGroupByIndex(Index: Integer): IOTAProject;
begin
end;

procedure CnOtaGetOptionsNames(Options: IOTAOptions; List: TStrings;
  IncludeType: Boolean = True); overload;
begin
end;

procedure CnOtaSetProjectOptionValue(Options: IOTAProjectOptions; const AOption,
  AValue: string);
begin
end;

procedure CnOtaGetProjectList(const List: TInterfaceList);
begin
end;

function CnOtaGetCurrentProjectName: string;
begin
end;

function CnOtaGetCurrentProjectFileName: string;
begin
end;

function CnOtaGetCurrentProjectFileNameEx: string;
begin
end;

function CnOtaGetCurrentFormName: string;
begin
end;

function CnOtaGetCurrentFormFileName: string;
begin
end;

function CnOtaGetFileNameOfModule(Module: IOTAModule;
  GetSourceEditorFileName: Boolean = False): string;
begin
end;

function CnOtaGetFileNameOfCurrentModule(GetSourceEditorFileName: Boolean = False): string;
begin
end;

function CnOtaGetEnvironmentOptions: IOTAEnvironmentOptions;
begin
end;

function CnOtaGetEditOptions: IOTAEditOptions;
begin
end;

function CnOtaGetActiveProjectOptions(Project: IOTAProject = nil): IOTAProjectOptions;
begin
end;

function CnOtaGetActiveProjectOption(const Option: string; var Value: Variant): Boolean;
begin
end;

function CnOtaGetPackageServices: IOTAPackageServices;
begin
end;

function CnOtaGetActiveProjectOptionsConfigurations(Project: IOTAProject = nil): IOTAProjectOptionsConfigurations;
begin
end;

function CnOtaGetNewFormTypeOption: TFormType;
begin
end;

function CnOtaGetSourceEditorFromModule(Module: IOTAModule; const FileName: string = ''): IOTASourceEditor;
begin
end;

function CnOtaGetEditorFromModule(Module: IOTAModule; const FileName: string): IOTAEditor;
begin
end;

function CnOtaGetEditActionsFromModule(Module: IOTAModule): IOTAEditActions;
begin
end;

function CnOtaGetCurrentSelection: string;
begin
end;

procedure CnOtaDeleteCurrentSelection;
begin
end;

procedure CnOtaEditBackspace(Many: Integer);
begin
end;

procedure CnOtaEditDelete(Many: Integer);
begin
end;

function CnOtaGetCurrentProcedure: string;
begin
end;

function CnOtaGetCurrentOuterBlock: string;
begin
end;

function CnOtaGetLineText(LineNum: Integer; EditBuffer: IOTAEditBuffer = nil;
  Count: Integer = 1): string;
begin
end;

function CnOtaGetCurrLineText(var Text: string; var LineNo: Integer;
  var CharIndex: Integer; View: IOTAEditView = nil): Boolean;
begin
end;

function CnNtaGetCurrLineText(var Text: string; var LineNo: Integer;
  var CharIndex: Integer): Boolean;
begin
end;

function CnOtaGetCurrLineInfo(var LineNo, CharIndex, LineLen: Integer): Boolean;
begin
end;

function CnOtaGetCurrPosToken(var Token: string; var CurrIndex: Integer;
  CheckCursorOutOfLineEnd: Boolean = True; FirstSet: TCnCharSet = [];
  CharSet: TCnCharSet = []): Boolean;
begin
end;

function CnOtaGetCurrChar(OffsetX: Integer = 0; View: IOTAEditView = nil): Char;
begin
end;

function CnOtaDeleteCurrToken(FirstSet: TCnCharSet = [];
  CharSet: TCnCharSet = []): Boolean;
begin
end;

function CnOtaDeleteCurrTokenLeft(FirstSet: TCnCharSet = [];
  CharSet: TCnCharSet = []): Boolean;
begin
end;

function CnOtaDeleteCurrTokenRight(FirstSet: TCnCharSet = [];
  CharSet: TCnCharSet = []): Boolean;
begin
end;

function CnOtaIsEditPosOutOfLine(EditPos: TOTAEditPos; View: IOTAEditView = nil): Boolean;
begin
end;

procedure CnOtaSelectBlock(const Editor: IOTASourceEditor; const Start, After: TOTACharPos);
begin
end;

function CnOtaCurrBlockEmpty: Boolean;
begin
end;

function CnOtaOpenFile(const FileName: string): Boolean;
begin
end;

function CnOtaOpenUnSaveForm(const FormName: string): Boolean;
begin
end;

function CnOtaIsFileOpen(const FileName: string): Boolean;
begin
end;

function CnOtaIsFormOpen(const FormName: string): Boolean;
begin
end;

function CnOtaIsModuleModified(AModule: IOTAModule): Boolean;
begin
end;

function CnOtaModuleIsShowingFormSource(Module: IOTAModule): Boolean;
begin
end;

function CnOtaMakeSourceVisible(const FileName: string; Lines: Integer = 0): Boolean;
begin
end;

function CnOtaIsDebugging: Boolean;
begin
end;

function CnOtaGetBaseModuleFileName(const FileName: string): string;
begin
end;

function StrToSourceCode(const Str, ADelphiReturn, ACReturn: string;
  Wrap: Boolean): string;
begin
end;

function CodeAutoWrap(Code: string; Width, Indent: Integer;
  IndentOnceOnly: Boolean): string;
begin
end;

function ConvertTextToEditorText(const Text: string): string;
begin
end;

function ConvertEditorTextToText(const Text: string): string;
begin
end;

function CnOtaGetCurrentSourceFile: string;
begin
end;

function CnOtaInsertTextToCurSource(const Text: string; InsertPos: TInsertPos
  = ipCur): Boolean;
begin
end;

function CnOtaGetCurSourcePos(var Col, Row: Integer): Boolean;
begin
end;

function CnOtaSetCurSourcePos(Col, Row: Integer): Boolean;
begin
end;

function CnOtaSetCurSourceCol(Col: Integer): Boolean;
begin
end;

function CnOtaSetCurSourceRow(Row: Integer): Boolean;
begin
end;

function CnOtaMovePosInCurSource(Pos: TInsertPos; OffsetRow, OffsetCol: Integer): Boolean;
begin
end;

function CnOtaGetCurrPos(SourceEditor: IOTASourceEditor = nil): Integer;
begin
end;

function CnOtaGetCurrCharPos(SourceEditor: IOTASourceEditor = nil): TOTACharPos;
begin
end;

function CnOtaEditPosToLinePos(EditPos: TOTAEditPos; EditView: IOTAEditView = nil): Integer;
begin
end;

function CnOtaLinePosToEditPos(LinePos: Integer; EditView: IOTAEditView = nil): TOTAEditPos;
begin
end;

procedure CnOtaSaveReaderToStream(EditReader: IOTAEditReader; Stream:
  TMemoryStream; StartPos: Integer = 0; EndPos: Integer = 0;
  PreSize: Integer = 0; CheckUtf8: Boolean = True);
begin
end;

function CnOtaSaveEditorToStream(Editor: IOTASourceEditor; Stream: TMemoryStream;
  FromCurrPos: Boolean; CheckUtf8: Boolean = True): Boolean;
begin
end;

function CnOtaSaveCurrentEditorToStream(Stream: TMemoryStream; FromCurrPos:
  Boolean; CheckUtf8: Boolean = True): Boolean;
begin
end;

function CnOtaGetCurrentEditorSource: string;
begin
end;

procedure CnOtaInsertLineIntoEditor(const Text: string);
begin
end;

procedure CnOtaInsertSingleLine(Line: Integer; const Text: string;
  EditView: IOTAEditView = nil);
begin
end;

procedure CnOtaInsertTextIntoEditor(const Text: string);
begin
end;

function CnOtaGetEditWriterForSourceEditor(SourceEditor: IOTASourceEditor = nil): IOTAEditWriter;
begin
end;

procedure CnOtaInsertTextIntoEditorAtPos(const Text: string; Position: Longint;
  SourceEditor: IOTASourceEditor = nil);
begin
end;

procedure CnOtaGotoPosition(Position: Longint; EditView: IOTAEditView = nil;
  Middle: Boolean = True);
begin
end;

function CnOtaGetEditPos(EditView: IOTAEditView): TOTAEditPos;
begin
end;

procedure CnOtaGotoEditPos(EditPos: TOTAEditPos; EditView: IOTAEditView = nil;
  Middle: Boolean = True);
begin
end;

function CnOtaGetCharPosFromPos(Position: LongInt; EditView: IOTAEditView): TOTACharPos;
begin
end;

function CnOtaGetBlockIndent: Integer;
begin
end;

procedure CnOtaClosePage(EditView: IOTAEditView);
begin
end;

procedure CnOtaCloseEditView(AModule: IOTAModule);
begin
end;

function CnOtaGetCurrDesignedForm(var AForm: TCustomForm; Selections: TList; 
  ExcludeForm: Boolean = True): Boolean;
begin
end;

function CnOtaGetCurrFormSelectionsCount: Integer;
begin
end;

function CnOtaIsCurrFormSelectionsEmpty: Boolean;
begin
end;

procedure CnOtaNotifyFormDesignerModified(FormEditor: IOTAFormEditor = nil);
begin
end;

function CnOtaSelectedComponentIsRoot(FormEditor: IOTAFormEditor = nil): Boolean;
begin
end;

function CnOtaPropertyExists(const Component: IOTAComponent; const PropertyName: string): Boolean;
begin
end;

procedure CnOtaSetCurrFormSelectRoot;
begin
end;

procedure CnOtaGetCurrFormSelectionsName(List: TStrings);
begin
end;

procedure CnOtaCopyCurrFormSelectionsName;
begin
end;

function OTACharPos(CharIndex: SmallInt; Line: Longint): TOTACharPos;
begin
end;

function OTAEditPos(Col: SmallInt; Line: Longint): TOTAEditPos;
begin
end;

function SameEditPos(Pos1, Pos2: TOTAEditPos): Boolean;
begin
end;

function SameCharPos(Pos1, Pos2: TOTACharPos): Boolean;
begin
end;

function HWndIsNonvisualComponent(hWnd: HWND): Boolean;
begin
end;

end.

