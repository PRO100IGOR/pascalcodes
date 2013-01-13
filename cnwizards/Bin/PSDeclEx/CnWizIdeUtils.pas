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

unit CnWizIdeUtils;
{* |<PRE>
================================================================================
* ������ƣ�CnPack IDE ר�Ұ�
* ��Ԫ���ƣ��ڽű���ʹ�õ� CnIdeWizUtils ��Ԫ����
* ��Ԫ���ߣ�CnPack ������
* ��    ע������Ԫ�����������ͺͺ��������� PasScript �ű���ʹ��
* ����ƽ̨��PWin2000Pro + Delphi 5.01
* ���ݲ��ԣ�PWin9X/2000/XP + Delphi 5/6/7 + C++Builder 5/6
* �� �� �����õ�Ԫ�е��ַ��������ϱ��ػ�����ʽ
* ��Ԫ��ʶ��$Id: CnWizIdeUtils.pas 763 2011-02-07 14:18:23Z liuxiao@cnpack.org $
* �޸ļ�¼��2006.12.31 V1.0
*               ������Ԫ
================================================================================
|</PRE>}

interface

uses
  Windows, Messages, Classes, Controls, SysUtils, Graphics, Forms, ComCtrls,
  ExtCtrls, Menus, Buttons, Tabs,
{$IFNDEF VER130}
  DesignIntf,
{$ENDIF}
  ToolsAPI;

//==============================================================================
// IDE ����༭�����ܺ���
//==============================================================================

function IdeGetEditorSelectedLines(Lines: TStringList): Boolean;
{* ȡ�õ�ǰ����༭��ѡ���еĴ��룬ʹ������ģʽ�����ѡ���Ϊ�գ��򷵻ص�ǰ�д��롣}

function IdeGetEditorSelectedText(Lines: TStringList): Boolean;
{* ȡ�õ�ǰ����༭��ѡ���Ĵ��롣}

function IdeGetEditorSourceLines(Lines: TStringList): Boolean;
{* ȡ�õ�ǰ����༭��ȫ��Դ���롣}

function IdeSetEditorSelectedLines(Lines: TStringList): Boolean;
{* �滻��ǰ����༭��ѡ���еĴ��룬ʹ������ģʽ�����ѡ���Ϊ�գ����滻��ǰ�д��롣}

function IdeSetEditorSelectedText(Lines: TStringList): Boolean;
{* �滻��ǰ����༭��ѡ���Ĵ��롣}

function IdeSetEditorSourceLines(Lines: TStringList): Boolean;
{* �滻��ǰ����༭��ȫ��Դ���롣}

function IdeInsertTextIntoEditor(const Text: string): Boolean;
{* �����ı�����ǰ�༭����֧�ֶ����ı���}

function IdeEditorGetEditPos(var Col, Line: Integer): Boolean;
{* ���ص�ǰ���λ�ã���� EditView Ϊ��ʹ�õ�ǰֵ�� }

function IdeEditorGotoEditPos(Col, Line: Integer; Middle: Boolean): Boolean;
{* �ƶ���굽ָ��λ�ã�Middle ��ʾ�Ƿ��ƶ���ͼ�����ġ�}

function IdeGetBlockIndent: Integer;
{* ��õ�ǰ�༭����������� }

function IdeGetSourceByFileName(const FileName: string): string;
{* �����ļ���ȡ�����ݡ�����ļ��� IDE �д򿪣����ر༭���е����ݣ����򷵻��ļ����ݡ�}

function IdeSetSourceByFileName(const FileName: string; Source: TStrings;
  OpenInIde: Boolean): Boolean;
{* �����ļ���д�����ݡ�����ļ��� IDE �д򿪣�д�����ݵ��༭���У��������
   OpenInIde Ϊ����ļ�д�뵽�༭����OpenInIde Ϊ��ֱ��д���ļ���}

//==============================================================================
// IDE ����༭�����ܺ���
//==============================================================================

function IdeGetFormDesigner(FormEditor: IOTAFormEditor = nil): IDesigner;
{* ȡ�ô���༭�����������FormEditor Ϊ nil ��ʾȡ��ǰ���� }

function IdeGetDesignedForm(Designer: IDesigner = nil): TCustomForm;
{* ȡ�õ�ǰ��ƵĴ��� }

function IdeGetFormSelection(Selections: TList; Designer: IDesigner = nil;
  ExcludeForm: Boolean = True): Boolean;
{* ȡ�õ�ǰ��ƴ�������ѡ������ }
 
//==============================================================================
// �޸��� GExperts Src 1.12 �� IDE ��غ���
//==============================================================================

function GetIdeMainForm: TCustomForm;
{* ���� IDE ������ (TAppBuilder) }

function GetIdeEdition: string;
{* ���� IDE �汾}

function GetComponentPaletteTabControl: TTabControl;
{* ������������󣬿���Ϊ��}

function GetObjectInspectorForm: TCustomForm;
{* ���ض����������壬����Ϊ��}

function GetComponentPalettePopupMenu: TPopupMenu;
{* �����������Ҽ��˵�������Ϊ��}

function GetComponentPaletteControlBar: TControlBar;
{* �������������ڵ�ControlBar������Ϊ��}

function GetMainMenuItemHeight: Integer;
{* �������˵���߶� }

function IsIdeEditorForm(AForm: TCustomForm): Boolean;
{* �ж�ָ�������Ƿ�༭������}

function IsIdeDesignForm(AForm: TCustomForm): Boolean;
{* �ж�ָ�������Ƿ�������ڴ���}

procedure BringIdeEditorFormToFront;
{* ��Դ��༭����Ϊ��Ծ}

function IDEIsCurrentWindow: Boolean;
{* �ж� IDE �Ƿ��ǵ�ǰ�Ļ���� }

//==============================================================================
// ������ IDE ��غ���
//==============================================================================

function GetInstallDir: string;
{* ȡ��������װĿ¼}

{$IFDEF BDS}
function GetBDSUserDataDir: string;
{* ȡ�� BDS (Delphi8/9) ���û�����Ŀ¼ }
{$ENDIF}

procedure GetProjectLibPath(Paths: TStrings);
{* ȡ��ǰ���������� Path ����}

function GetFileNameFromModuleName(AName: string; AProject: IOTAProject = nil): string;
{* ����ģ������������ļ���}

procedure GetLibraryPath(Paths: TStrings; IncludeProjectPath: Boolean = True);
{* ȡ���������е� LibraryPath ����}

function GetComponentUnitName(const ComponentName: string): string;
{* ȡ����������ڵĵ�Ԫ��}

procedure GetInstalledComponents(Packages, Components: TStrings);
{* ȡ�Ѱ�װ�İ����������������Ϊ nil�����ԣ�}

function GetEditControlFromEditorForm(AForm: TCustomForm): TControl;
{* ���ر༭�����ڵı༭���ؼ� }

function GetCurrentEditControl: TControl;
{* ���ص�ǰ�Ĵ���༭���ؼ� }

function GetStatusBarFromEditor(EditControl: TControl): TStatusBar;
{* �ӱ༭���ؼ�����������ı༭�����ڵ�״̬��}

//==============================================================================
// �������װ��
//==============================================================================

type

{ TCnPaletteWrapper }

  TCnPaletteWrapper = class(TObject)
  private
    function GetActiveTab: string;
    function GetEnabled: Boolean;
    function GetIsMultiLine: Boolean;
    function GetPalToolCount: Integer;
    function GetSelectedIndex: Integer;
    function GetSelectedToolName: string;
    function GetSelector: TSpeedButton;
    function GetTabCount: Integer;
    function GetTabIndex: Integer;
    function GetTabs(Index: Integer): string;
    function GetVisible: Boolean;
    procedure SetEnabled(const Value: Boolean);
    procedure SetSelectedIndex(const Value: Integer);
    procedure SetTabIndex(const Value: Integer);
    procedure SetVisible(const Value: Boolean);

  public
    constructor Create;

    procedure BeginUpdate;
    {* ��ʼ���£���ֹˢ��ҳ�� }
    procedure EndUpdate;
    {* ֹͣ���£��ָ�ˢ��ҳ�� }
    function SelectComponent(const AComponent: string; const ATab: string): Boolean;
    {* ��������ѡ�пؼ����е�ĳ�ؼ� }
    function FindTab(const ATab: string): Integer;
    {* ����ĳҳ������� }
    property SelectedIndex: Integer read GetSelectedIndex write SetSelectedIndex;
    {* ���µĿؼ��ڱ�ҳ����ţ�0 ��ͷ }
    property SelectedToolName: string read GetSelectedToolName;
    {* ���µĿؼ���������δ������Ϊ�� }
    property Selector: TSpeedButton read GetSelector;
    {* �����л��������� SpeedButton }
    property PalToolCount: Integer read GetPalToolCount;
    {* ��ǰҳ�ؼ����� }
    property ActiveTab: string read GetActiveTab;
    {* ��ǰҳ���� }
    property TabIndex: Integer read GetTabIndex write SetTabIndex;
    {* ��ǰҳ���� }
    property Tabs[Index: Integer]: string read GetTabs;
    {* ���������õ�ҳ���� }
    property TabCount: Integer read GetTabCount;
    {* �ؼ�����ҳ�� }
    property IsMultiLine: Boolean read GetIsMultiLine;
    {* �ؼ����Ƿ���� }
    property Visible: Boolean read GetVisible write SetVisible;
    {* �ؼ����Ƿ�ɼ� }
    property Enabled: Boolean read GetEnabled write SetEnabled;
    {* �ؼ����Ƿ�ʹ�� }
  end;

{ TCnMessageViewWrapper }

{$IFDEF BDS}
  TXTreeView = TCustomControl;
{$ELSE}
  TXTreeView = TTreeView;
{$ENDIF BDS}

  TCnMessageViewWrapper = class(TObject)
  {* ��װ����Ϣ��ʾ���ڵĸ������Ե��� }
  private
    FMessageViewForm: TCustomForm;
    FEditMenuItem: TMenuItem;
    FTabSet: TTabSet;
    FTreeView: TXTreeView;
{$IFNDEF BDS}
    function GetMessageCount: Integer;
    function GetSelectedIndex: Integer;
    procedure SetSelectedIndex(const Value: Integer);
    function GetCurrentMessage: string;
{$ENDIF}
    function GetTabCaption: string;
    function GetTabCount: Integer;
    function GetTabIndex: Integer;
    procedure SetTabIndex(const Value: Integer);
    function GetTabSetVisible: Boolean;
  public
    constructor Create;

    procedure UpdateAllItems;

    procedure EditMessageSource;
    {* ˫����Ϣ����}

    property MessageViewForm: TCustomForm read FMessageViewForm;
    {* ��Ϣ����}
    property TreeView: TXTreeView read FTreeView;
    {* ��Ϣ�����ʵ����BDS �·� TreeView�����ֻ�ܷ��� CustomControl }
{$IFNDEF BDS}
    property SelectedIndex: Integer read GetSelectedIndex write SetSelectedIndex;
    {* ��Ϣ��ѡ�е����}
    property MessageCount: Integer read GetMessageCount;
    {* ���е���Ϣ��}
    property CurrentMessage: string read GetCurrentMessage;
    {* ��ǰѡ�е���Ϣ�����ƺ����Ƿ��ؿ�}
{$ENDIF}
    property TabSet: TTabSet read FTabSet;
    {* ���ط�ҳ�����ʵ��}
    property TabSetVisible: Boolean read GetTabSetVisible;
    {* ���ط�ҳ����Ƿ�ɼ���D5 ��Ĭ�ϲ��ɼ�}
    property TabIndex: Integer read GetTabIndex write SetTabIndex;
    {* ����/���õ�ǰҳ���}
    property TabCount: Integer read GetTabCount;
    {* ������ҳ��}
    property TabCaption: string read GetTabCaption;
    {* ���ص�ǰҳ���ַ���}
    property EditMenuItem: TMenuItem read FEditMenuItem;
    {* '�༭'�˵���}
  end;

function CnPaletteWrapper: TCnPaletteWrapper;

function CnMessageViewWrapper: TCnMessageViewWrapper;

implementation

{$WARNINGS OFF}

function IdeGetEditorSelectedLines(Lines: TStringList): Boolean;
begin
end;

function IdeGetEditorSelectedText(Lines: TStringList): Boolean;
begin
end;

function IdeGetEditorSourceLines(Lines: TStringList): Boolean;
begin
end;

function IdeSetEditorSelectedLines(Lines: TStringList): Boolean;
begin
end;

function IdeSetEditorSelectedText(Lines: TStringList): Boolean;
begin
end;

function IdeSetEditorSourceLines(Lines: TStringList): Boolean;
begin
end;

function IdeInsertTextIntoEditor(const Text: string): Boolean;
begin
end;

function IdeEditorGetEditPos(var Col, Line: Integer): Boolean;
begin
end;

function IdeEditorGotoEditPos(Col, Line: Integer; Middle: Boolean): Boolean;
begin
end;

function IdeGetBlockIndent: Integer;
begin
end;

function IdeGetSourceByFileName(const FileName: string): string;
begin
end;

function IdeSetSourceByFileName(const FileName: string; Source: TStrings;
  OpenInIde: Boolean): Boolean;
begin
end;

function IdeGetFormDesigner(FormEditor: IOTAFormEditor = nil): IDesigner;
begin
end;

function IdeGetDesignedForm(Designer: IDesigner = nil): TCustomForm;
begin
end;

function IdeGetFormSelection(Selections: TList; Designer: IDesigner = nil;
  ExcludeForm: Boolean = True): Boolean;
begin
end;

function GetIdeMainForm: TCustomForm;
begin
end;

function GetIdeEdition: string;
begin
end;

function GetComponentPaletteTabControl: TTabControl;
begin
end;

function GetObjectInspectorForm: TCustomForm;
begin
end;

function GetComponentPalettePopupMenu: TPopupMenu;
begin
end;

function GetComponentPaletteControlBar: TControlBar;
begin
end;

function GetMainMenuItemHeight: Integer;
begin
end;

function IsIdeEditorForm(AForm: TCustomForm): Boolean;
begin
end;

function IsIdeDesignForm(AForm: TCustomForm): Boolean;
begin
end;

procedure BringIdeEditorFormToFront;
begin
end;

function IDEIsCurrentWindow: Boolean;
begin
end;

function GetInstallDir: string;
begin
end;

function GetBDSUserDataDir: string;
begin
end;

procedure GetProjectLibPath(Paths: TStrings);
begin
end;

function GetFileNameFromModuleName(AName: string; AProject: IOTAProject = nil): string;
begin
end;

procedure GetLibraryPath(Paths: TStrings; IncludeProjectPath: Boolean = True);
begin
end;

function GetComponentUnitName(const ComponentName: string): string;
begin
end;

procedure GetInstalledComponents(Packages, Components: TStrings);
begin
end;

function GetEditControlFromEditorForm(AForm: TCustomForm): TControl;
begin
end;

function GetCurrentEditControl: TControl;
begin
end;

function GetStatusBarFromEditor(EditControl: TControl): TStatusBar;
begin
end;

{ TCnPaletteWrapper }

procedure TCnPaletteWrapper.BeginUpdate;
begin
end;

constructor TCnPaletteWrapper.Create;
begin
end;

procedure TCnPaletteWrapper.EndUpdate;
begin
end;

function TCnPaletteWrapper.FindTab(const ATab: string): Integer;
begin
end;

function TCnPaletteWrapper.GetActiveTab: string;
begin
end;

function TCnPaletteWrapper.GetEnabled: Boolean;
begin
end;

function TCnPaletteWrapper.GetIsMultiLine: Boolean;
begin
end;

function TCnPaletteWrapper.GetPalToolCount: Integer;
begin
end;

function TCnPaletteWrapper.GetSelectedIndex: Integer;
begin
end;

function TCnPaletteWrapper.GetSelectedToolName: string;
begin
end;

function TCnPaletteWrapper.GetSelector: TSpeedButton;
begin
end;

function TCnPaletteWrapper.GetTabCount: Integer;
begin
end;

function TCnPaletteWrapper.GetTabIndex: Integer;
begin
end;

function TCnPaletteWrapper.GetTabs(Index: Integer): string;
begin
end;

function TCnPaletteWrapper.GetVisible: Boolean;
begin
end;

function TCnPaletteWrapper.SelectComponent(const AComponent,
  ATab: string): Boolean;
begin
end;

procedure TCnPaletteWrapper.SetEnabled(const Value: Boolean);
begin
end;

procedure TCnPaletteWrapper.SetSelectedIndex(const Value: Integer);
begin
end;

procedure TCnPaletteWrapper.SetTabIndex(const Value: Integer);
begin
end;

procedure TCnPaletteWrapper.SetVisible(const Value: Boolean);
begin
end;

function CnPaletteWrapper: TCnPaletteWrapper;
begin
end;
  
{ TCnMessageViewWrapper }

constructor TCnMessageViewWrapper.Create;
begin
end;

procedure TCnMessageViewWrapper.EditMessageSource;
begin
end;

function TCnMessageViewWrapper.GetCurrentMessage: string;
begin
end;

function TCnMessageViewWrapper.GetMessageCount: Integer;
begin
end;

function TCnMessageViewWrapper.GetSelectedIndex: Integer;
begin
end;

function TCnMessageViewWrapper.GetTabCaption: string;
begin
end;

function TCnMessageViewWrapper.GetTabCount: Integer;
begin
end;

function TCnMessageViewWrapper.GetTabIndex: Integer;
begin
end;

function TCnMessageViewWrapper.GetTabSetVisible: Boolean;
begin
end;

procedure TCnMessageViewWrapper.SetSelectedIndex(const Value: Integer);
begin
end;

procedure TCnMessageViewWrapper.SetTabIndex(const Value: Integer);
begin
end;

procedure TCnMessageViewWrapper.UpdateAllItems;
begin
end;

function CnMessageViewWrapper: TCnMessageViewWrapper;
begin
end;

end.

