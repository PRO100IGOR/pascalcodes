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

unit CnSrcEditorToolBar;
{ |<PRE>
================================================================================
* ������ƣ�CnPack IDE ר�Ұ�
* ��Ԫ���ƣ�����༭����������Ԫ
* ��Ԫ���ߣ��ܾ��� (zjy@cnpack.org)
* ��    ע��
* ����ƽ̨��PWin2000Pro + Delphi 5.01
* ���ݲ��ԣ�PWin9X/2000/XP + Delphi 5/6/7 + C++Builder 5/6
* �� �� �����õ�Ԫ�е��ַ��������ϱ��ػ�����ʽ
* ��Ԫ��ʶ��$Id: CnSrcEditorToolBar.pas 763 2011-02-07 14:18:23Z liuxiao@cnpack.org $
* �޸ļ�¼��2004.12.25
*               ������Ԫ����ԭ CnSrcEditorEnhancements �Ƴ�
================================================================================
|</PRE>}

interface

{$I CnWizards.inc}

{$IFDEF CNWIZARDS_CNSRCEDITORENHANCE}

uses
  Windows, Messages, Classes, Graphics, SysUtils, Controls, Menus, Forms, CnIni,
  ComCtrls, ToolWin, ToolsAPI, IniFiles, CnEditControlWrapper, CnWizNotifier,
  CnWizIni, CnWizIdeUtils, CnPopupMenu;

type

//==============================================================================
// ����༭��������
//==============================================================================

{ TCnBaseSrcEditorToolBar }

  TCnBaseSrcEditorToolBar = class(TToolBar)
  protected
{$IFDEF BDS}
    procedure SetEnabled(Value: Boolean); override;
{$ENDIF}
  public
    constructor Create(AOwner: TComponent); override;
    procedure InitControls; virtual;
    function CanShow(APage: TCnSrcEditorPage): Boolean; virtual;
  end;

{ TCnSrcEditorToolButton }

  TCnSrcEditorToolButton = class(TToolButton)
  private
    FMenu: TPopupMenu;
    FLastTick: Cardinal;
    procedure OnPopup(Sender: TObject);
    procedure DoClick(Sender: TObject);
  public
    procedure InitiateAction; override;
    procedure Click; override;
  end;

{ TCnSrcEditorToolBar }

  TCnSrcEditorToolBarMgr = class;

  TCnSrcEditorToolBarType = (tbtCode, tbtDesign);

  TCnSrcEditorToolBar = class(TCnBaseSrcEditorToolBar)
  private
    FMenu: TPopupMenu;
    FToolBarMgr: TCnSrcEditorToolBarMgr;
    FToolBarType: TCnSrcEditorToolBarType;
    procedure OnConfig(Sender: TObject);
    procedure OnClose(Sender: TObject);
    procedure OnEnhConfig(Sender: TObject);
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    procedure InitControls; override;
    function CanShow(APage: TCnSrcEditorPage): Boolean; override;
    procedure RecreateButtons;
    procedure InitPopupMenu;
    procedure LanguageChanged(Sender: TObject);
    property Menu: TPopupMenu read FMenu;
    property ToolBarType: TCnSrcEditorToolBarType read FToolBarType write FToolBarType;
  end;

  TCnSrcEditorCanShowEvent = procedure (Sender: TObject; APage: TCnSrcEditorPage;
    var ACanShow: Boolean) of object;

  TCnExternalSrcEditorToolBar = class(TCnBaseSrcEditorToolBar)
  private
    FOnCanShow: TCnSrcEditorCanShowEvent;
  public
    procedure InitControls; override;
    function CanShow(APage: TCnSrcEditorPage): Boolean; override;
    property OnCanShow: TCnSrcEditorCanShowEvent read FOnCanShow write FOnCanShow;
  end;

//==============================================================================
// ����༭��������������
//==============================================================================

{ TCnSrcEditorToolBarMgr }

  TCnSrcEditorToolBarMgr = class
  private
    FShowToolBar: Boolean;
    FToolBarActions: TStringList;
    FShowDesignToolBar: Boolean;
    FDesignToolBarActions: TStringList;
    FActive: Boolean;
    FList: TList;
    FOnEnhConfig: TNotifyEvent;
    FWrapable: Boolean;
    procedure LoadToolBarActions(Actions: TStrings; const FileName: string);
    procedure SaveToolBarActions(Actions: TStrings; const FileName: string);
    procedure SetShowToolBar(const Value: Boolean);
    procedure SetShowDesignToolBar(const Value: Boolean);
    procedure SetActive(const Value: Boolean);
    procedure DoInstallToolBars(EditWindow: TCustomForm; EditControl: TControl;
      Context: Pointer);
    procedure DoGetEditList(EditWindow: TCustomForm; EditControl: TControl;
      Context: Pointer);
    function GetCount: Integer;
    function GetToolBar(Index: Integer): TCnSrcEditorToolBar;
    procedure EditControlNotify(EditControl: TControl; EditWindow: TCustomForm;
      Operation: TOperation);
    procedure SetWrapable(Value: Boolean);
  protected
    procedure DoEnhConfig;
    function CanShowToolBar: Boolean;
    function CanShowDesignToolBar: Boolean;
  public
    constructor Create;
    destructor Destroy; override;

    procedure InstallToolBars;
    procedure UpdateToolBars;
    procedure ConfigToolBar(AType: TCnSrcEditorToolBarType);
    procedure CheckToolBarEnable;
    procedure LanguageChanged(Sender: TObject);
    procedure LoadSettings(Ini: TCustomIniFile);
    procedure SaveSettings(Ini: TCustomIniFile);

    property Count: Integer read GetCount;
    property ToolBars[Index: Integer]: TCnSrcEditorToolBar read GetToolBar;

    property ShowToolBar: Boolean read FShowToolBar write SetShowToolBar;
    property ShowDesignToolBar: Boolean read FShowDesignToolBar write SetShowDesignToolBar;
    property Wrapable: Boolean read FWrapable write SetWrapable;
    property Active: Boolean read FActive write SetActive;
    property OnEnhConfig: TNotifyEvent read FOnEnhConfig write FOnEnhConfig;
  end;

{$ELSE}

uses
  SysUtils, Classes, ComCtrls, Controls;

{$ENDIF CNWIZARDS_CNSRCEDITORENHANCE}

type
  TCnEditorToolBarEvent = procedure (ToolBarType: string;
     EditControl: TControl; ToolBar: TToolBar) of object;

  ICnEditorToolBarService = interface
  ['{BF6B4399-270A-4E24-8137-587162D12497}']
    procedure RegisterToolBarType(const ToolBarType: string;
      CreateEvent: TCnEditorToolBarEvent;
      InitEvent: TCnEditorToolBarEvent;
      RemoveEvent: TCnEditorToolBarEvent);
    {* �����ⲿģ��ע��һ���������Ͳ��ṩ�ص���������������ʼ����ɾ��}
    procedure RemoveToolBarType(const ToolBarType: string);
    {* �Ƴ�����������ע��}
    procedure SetVisible(const ToolBarType: string; Visible: Boolean);
    {* ����ĳ�๤�����Ƿ�ȫ���ɼ���ȫ�����ɼ������ ToolBarType �ǿգ�
       ���ʾ�����඼����}
    function GetVisible(const ToolBarType: string): Boolean;
    {* ���ĳ�๤�����Ƿ�ɼ�}
    procedure LanguageChanged;
    {* ���ⲿ���õ����Ըı�֪ͨ}
  end;

var
  CnEditorToolBarService: ICnEditorToolBarService = nil;
  {* �༭�������������ṩ��}
  CreateEditorToolBarServiceProc: TProcedure = nil;
  {* �����༭����������������}

implementation

{$IFDEF CNWIZARDS_CNSRCEDITORENHANCE}

uses
{$IFDEF DEBUG}
  CnDebug,
{$ENDIF}
  Math, TypInfo, CnCommon, CnWizUtils, CnWizConsts,
  CnWizShareImages, CnFlatToolbarConfigFrm, CnWizOptions;

const
  SCnSrcEditorToolBar = 'CnSrcEditorToolBar';
  SCnSrcEditorDesignToolBar = 'CnSrcEditorDesignToolBar';

  csToolBar = 'ToolBar';
  csShowToolBar = 'ShowToolBar';
  csShowDesignToolBar = 'ShowDesignToolBar';
  csWrapable = 'Wrapable';

  csUpdateMinInterval = 500;

type
  TCnEditorToolBarObj = class(TComponent)
  {* ��������һ�๤������������ʵ���������ص�������� EditControl ������}
  private
    FToolBars: TList;
    FEditControls: TList;
    FToolBarType: string;
    FToolBarVisible: Boolean;
    FCreateEvent: TCnEditorToolBarEvent;
    FInitEvent: TCnEditorToolBarEvent;
    FRemoveEvent: TCnEditorToolBarEvent;
    function GetToolBars(Index: Integer): TControl;
    function GetToolBarCount: Integer;
    function GetEditControls(Index: Integer): TControl;
  protected
    procedure Notification(AComponent: TComponent;
      Operation: TOperation); override;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    procedure AddToolBar(AToolBar: TControl; EditControl: TControl);
    procedure RemoveEditControlFromIndex(Index: Integer);

    property CreateEvent: TCnEditorToolBarEvent read FCreateEvent write FCreateEvent;
    property InitEvent: TCnEditorToolBarEvent read FInitEvent write FInitEvent;
    property RemoveEvent: TCnEditorToolBarEvent read FRemoveEvent write FRemoveEvent;
    property EditControls[Index: Integer]: TControl read GetEditControls;
    property ToolBars[Index: Integer]: TControl read GetToolBars;
    property ToolBarCount: Integer read GetToolBarCount;
    property ToolBarVisible: Boolean read FToolBarVisible write FToolBarVisible;
    property ToolBarType: string read FToolBarType write FToolBarType;
  end;

  TCnExternalEditorToolBarMgr = class(TInterfacedObject, ICnEditorToolBarService)
  private
    FToolBarTypes: TStrings;
    procedure DoInstallToolBars(EditWindow: TCustomForm; EditControl: TControl;
      Context: Pointer);
    function GetToolBarObj(ToolBarType: string): TCnEditorToolBarObj;
  protected
    procedure EditControlNotify(EditControl: TControl; EditWindow: TCustomForm;
      Operation: TOperation);
  public
    constructor Create;
    destructor Destroy; override;

    procedure InstallToolBars;
    procedure RegisterToolBarType(const ToolBarType: string;
      CreateEvent: TCnEditorToolBarEvent;
      InitEvent: TCnEditorToolBarEvent;
      RemoveEvent: TCnEditorToolBarEvent);
    procedure RemoveToolBarType(const ToolBarType: string);
    procedure SetVisible(const ToolBarType: string; Visible: Boolean);
    function GetVisible(const ToolBarType: string): Boolean;
    procedure LanguageChanged;
    property ToolBarObj[ToolBarType: string]: TCnEditorToolBarObj read GetToolBarObj;
  end;

var
  ExternalEditorToolBarMgr: TCnExternalEditorToolBarMgr;
  CnSrcEditorToolBarMgr: TCnSrcEditorToolBarMgr;

//==============================================================================
// ����༭��������
//==============================================================================

{ TCnBaseSrcEditorToolBar }

constructor TCnBaseSrcEditorToolBar.Create(AOwner: TComponent);
{$IFDEF BDS2006_UP}
var
  barStdTool: TToolBar;
{$ENDIF}
begin
  inherited;
  Caption := '';
  DockSite := False;
  ShowHint := True;
  EdgeBorders := [ebBottom];
  Flat := True;
{$IFDEF BDS2006_UP}
  barStdTool := (BorlandIDEServices as INTAServices).ToolBar[sStandardToolBar];
  if Assigned(barStdTool) then
  begin
    DrawingStyle := barStdTool.DrawingStyle;
    GradientDirection := barStdTool.GradientDirection;
    GradientDrawingOptions := barStdTool.GradientDrawingOptions;
    GradientStartColor := barStdTool.GradientStartColor;
    GradientEndColor := barStdTool.GradientEndColor;
  end;
{$ENDIF}
end;

{$IFDEF BDS}
procedure TCnBaseSrcEditorToolBar.SetEnabled(Value: Boolean);
begin
// ʲôҲ���������赲 BDS ���л�ҳ��ʱ Disable �������Ĳ���
end;
{$ENDIF}

procedure TCnBaseSrcEditorToolBar.InitControls;
begin

end;

function TCnBaseSrcEditorToolBar.CanShow(APage: TCnSrcEditorPage): Boolean;
begin
  Result := False;
end;

{ TCnSrcEditorToolButton }

procedure TCnSrcEditorToolButton.Click;
begin
  // ��ʱ��ť���ִ�еĲ����н� ToolBar �ͷ��ˣ��ᵼ�³����������򿪡���ť
  // ��һ���µĹ��̻��ͷŵ�ǰ�༭���ؽ�һ�����˴��� Click �¼�ת�� OnIdle ʱȥ
  // ִ�У��������������⡣
  CnWizNotifierServices.ExecuteOnApplicationIdle(DoClick)
end;

procedure TCnSrcEditorToolButton.DoClick(Sender: TObject);
begin
  inherited Click;
end;

procedure TCnSrcEditorToolButton.InitiateAction;
begin
  // ���ٵ��ô���������CPUռ����
  if Abs(GetTickCount - FLastTick) > csUpdateMinInterval then
  begin
    inherited InitiateAction;
    FLastTick := GetTickCount;
  end;
end;

procedure TCnSrcEditorToolButton.OnPopup(Sender: TObject);
var
  Menu: Menus.TPopupMenu;
begin
  if (Sender <> nil) and (Sender is Menus.TPopupMenu) then
  begin
    Menu := Menus.TPopupMenu((Sender as TComponent).Tag);
    if Menu <> nil then
    begin
      FMenu.Items.Clear;
      if Assigned(Menu.OnPopup) then
        Menu.OnPopup(Menu); // ����һ��ԭʼ�� Menu �ĵ���
      // �� Menu �и������� Items ����
      CloneMenuItem(Menu.Items, FMenu.Items);
    end;
  end;  
end;

{ TCnSrcEditorToolBar }

constructor TCnSrcEditorToolBar.Create(AOwner: TComponent);
begin
  inherited;
  FMenu := TPopupMenu.Create(Self);
end;

destructor TCnSrcEditorToolBar.Destroy;
begin
  FToolBarMgr.FList.Remove(Self);
  inherited;
end;

//------------------------------------------------------------------------------
// ��������ʼ��������
//------------------------------------------------------------------------------

procedure TCnSrcEditorToolBar.InitControls;
begin
  inherited;
  AutoSize := True;
  Top := -1;
  Align := alTop;
  Images := GetIDEImageList;
  InitPopupMenu;
  Wrapable := FToolBarMgr.Wrapable;
  PopupMenu := FMenu;
  RecreateButtons;
  Visible := CanShow(GetCurrentTopEditorPage(Parent));
end;

procedure TCnSrcEditorToolBar.InitPopupMenu;
begin
  FMenu.Items.Clear;
  AddMenuItem(FMenu.Items, SCnMenuFlatFormCustomizeCaption, OnConfig);
  AddSepMenuItem(Menu.Items);
  AddMenuItem(FMenu.Items, SCnEditorEnhanceConfig, OnEnhConfig);
  AddMenuItem(FMenu.Items, SCnToolBarClose, OnClose);
end;

function TCnSrcEditorToolBar.CanShow(APage: TCnSrcEditorPage): Boolean;
begin
  if APage in [epCode, epCPU] then
    Result := FToolBarType = tbtCode
  else if APage in [epDesign] then
    Result := FToolBarType = tbtDesign
  else
    Result := False;
end;
  
procedure TCnSrcEditorToolBar.RecreateButtons;
var
  i: Integer;
  Btn: TCnSrcEditorToolButton;
  IDEBtn: TToolButton;
  MenuObj: TObject;
  Act: TBasicAction;
  Actions: TStringList;
  Svcs40: INTAServices40;
  IDEToolBarParent: TWinControl;

  // ���� IDE �е���Ӧ�� ToolButton
  function FindIDEToolButton(AAction: TBasicAction): TToolButton;
  var
    i, j: Integer;
  begin
    Result := nil;
    if IDEToolBarParent <> nil then
    begin
      for i := 0 to IDEToolBarParent.ControlCount - 1 do
        if IDEToolBarParent.Controls[i] is TToolBar then
        with IDEToolBarParent.Controls[i] as TToolBar do
          for j := 0 to ButtonCount - 1 do
            if Buttons[j].Action = AAction then
            begin
              Result := Buttons[j];
              Exit;
            end;
    end;
  end;
begin
  for i := ButtonCount - 1 downto 0 do
    Buttons[i].Free;

  if FToolBarType = tbtCode then
    Actions := FToolBarMgr.FToolBarActions
  else
    Actions := FToolBarMgr.FDesignToolBarActions;
  QuerySvcs(BorlandIDEServices, INTAServices40, Svcs40);
  if Svcs40.ToolBar[sStandardToolBar] <> nil then
    IDEToolBarParent := Svcs40.ToolBar[sStandardToolBar].Parent;
  for i := Actions.Count - 1 downto 0 do
  begin
    if Actions[i] = '-' then
    begin
      Btn := TCnSrcEditorToolButton.Create(Self);
      Btn.Style := tbsSeparator;
      if Align in [alTop, alBottom] then
        Btn.Width := 4
      else
        Btn.Height := 4;
      Btn.SetToolBar(Self);
    end
    else
    begin
      Act := FindIDEAction(Actions[i]);
      if Act <> nil then
      begin
        Btn := TCnSrcEditorToolButton.Create(Self);
        Btn.Action := Act;
        if Btn.ImageIndex < 0 then
          Btn.ImageIndex := dmCnSharedImages.IdxUnknownInIDE;
        if Btn.Caption = '' then
          Btn.Caption := Btn.Name;
        if Btn.Hint = '' then
          Btn.Hint := StripHotkey(Btn.Caption);

        // ����������˵��İ�ť
        IDEBtn := FindIDEToolButton(Act);
        if IDEBtn <> nil then
        begin
          // ֱ��������ȡ�õ�ʼ���ǿգ����� IDE �� TCommandButton �ض������������
          MenuObj := GetObjectProp(IDEBtn, 'DropdownMenu');
          if (MenuObj <> nil) and (MenuObj is Menus.TPopupMenu) then
          begin
            Btn.Style := tbsDropDown;
            if Btn.FMenu <> nil then
              FreeAndNil(Btn.FMenu);
            Btn.FMenu := TPopupMenu.Create(Btn);
            Btn.FMenu.Tag := Integer(MenuObj);
            Btn.FMenu.OnPopup := Btn.OnPopup;
            Btn.DropdownMenu := Btn.FMenu;
          end;
        end;
        Btn.SetToolBar(Self);
      end;
    end;
  end;
end;

//------------------------------------------------------------------------------
// �¼�����
//------------------------------------------------------------------------------

procedure TCnSrcEditorToolBar.OnConfig(Sender: TObject);
begin
  FToolBarMgr.ConfigToolBar(FToolBarType);
end;

procedure TCnSrcEditorToolBar.OnClose(Sender: TObject);
begin
  InfoDlg(SCnToolBarCloseHint);
  if FToolBarType = tbtCode then
    FToolBarMgr.ShowToolBar := False
  else
    FToolBarMgr.ShowDesignToolBar := False;
end;

procedure TCnSrcEditorToolBar.OnEnhConfig(Sender: TObject);
begin
  FToolBarMgr.DoEnhConfig;
end;

procedure TCnSrcEditorToolBar.LanguageChanged(Sender: TObject);
begin
  InitPopupMenu;
end;

//==============================================================================
// ����༭��������������
//==============================================================================

{ TCnSrcEditorToolBarMgr }

constructor TCnSrcEditorToolBarMgr.Create;
begin
  inherited;
  CnSrcEditorToolBarMgr := Self;
  FWrapable := True;
  FShowToolBar := True;
  FShowDesignToolBar := True;
  FActive := True;

  FToolBarActions := TStringList.Create;
  FDesignToolBarActions := TStringList.Create;
  FList := TList.Create;
  
  EditControlWrapper.AddEditControlNotifier(EditControlNotify);
  InstallToolBars;
end;

destructor TCnSrcEditorToolBarMgr.Destroy;
var
  i: Integer;
begin
  CnSrcEditorToolBarMgr := nil;
  EditControlWrapper.RemoveEditControlNotifier(EditControlNotify);
  for i := FList.Count - 1 downto 0 do
    TCnSrcEditorToolBar(FList[i]).Free;
  FList.Free;
  FToolBarActions.Free;
  FDesignToolBarActions.Free;
  inherited;
end;

//------------------------------------------------------------------------------
// ��������װ������
//------------------------------------------------------------------------------

function TCnSrcEditorToolBarMgr.CanShowToolBar: Boolean;
begin
  Result := Active and ShowToolBar;
end;

function TCnSrcEditorToolBarMgr.CanShowDesignToolBar: Boolean;
begin
  Result := Active and ShowDesignToolBar and IdeGetIsEmbeddedDesigner;
end;

procedure TCnSrcEditorToolBarMgr.DoInstallToolBars(EditWindow: TCustomForm;
  EditControl: TControl; Context: Pointer);
var
  ToolBar: TCnSrcEditorToolBar;
begin
  ToolBar := TCnSrcEditorToolBar(EditWindow.FindComponent(SCnSrcEditorToolBar));
  if CanShowToolBar then
  begin
    if ToolBar = nil then
    begin
      ToolBar := TCnSrcEditorToolBar.Create(EditWindow);
      ToolBar.FToolBarType := tbtCode;
      ToolBar.FToolBarMgr := Self;
      ToolBar.Name := SCnSrcEditorToolBar;
      ToolBar.Parent := EditControl.Parent;
      ToolBar.InitControls;
      FList.Add(ToolBar);
    end;
  end
  else if ToolBar <> nil then
  begin
    ToolBar.Free;
  end;
{$IFDEF BDS}
  ToolBar := TCnSrcEditorToolBar(EditWindow.FindComponent(SCnSrcEditorDesignToolBar));
  if CanShowDesignToolBar then
  begin
    if ToolBar = nil then
    begin
      ToolBar := TCnSrcEditorToolBar.Create(EditWindow);
      ToolBar.FToolBarType := tbtDesign;
      ToolBar.FToolBarMgr := Self;
      ToolBar.Name := SCnSrcEditorDesignToolBar;
      ToolBar.Parent := EditControl.Parent;
      ToolBar.InitControls;
      FList.Add(ToolBar);
    end;
  end
  else if ToolBar <> nil then
  begin
    ToolBar.Free;
  end;
{$ENDIF}
end;

procedure TCnSrcEditorToolBarMgr.DoGetEditList(EditWindow: TCustomForm; EditControl: TControl;
  Context: Pointer);
begin
  if (EditControl <> nil) and (TList(Context).IndexOf(EditControl.Parent) <= 0) then
    TList(Context).Add(EditControl.Parent);
end;

procedure TCnSrcEditorToolBarMgr.InstallToolBars;
begin
  EnumEditControl(DoInstallToolBars, nil);
end;

procedure TCnSrcEditorToolBarMgr.UpdateToolBars;
var
  I: Integer;
begin
  for I := 0 to Count - 1 do
  begin
    ToolBars[I].RecreateButtons;
    ToolBars[I].InitPopupMenu;
  end; 
end;

procedure TCnSrcEditorToolBarMgr.EditControlNotify(EditControl: TControl;
  EditWindow: TCustomForm; Operation: TOperation);
begin
  if Operation = opInsert then
    InstallToolBars;
end;

//------------------------------------------------------------------------------
// �������������
//------------------------------------------------------------------------------

procedure TCnSrcEditorToolBarMgr.LoadToolBarActions(Actions: TStrings;
  const FileName: string);
var
  Value: string;
  i: Integer;
begin
  Actions.Clear;
  with TMemIniFile.Create(FileName) do
  try
    i := 0;
    while ValueExists(csToolBar, csButton + IntToStr(i)) do
    begin
      Value := Trim(ReadString(csToolBar, csButton + IntToStr(i), ''));
      if Value <> '' then
        Actions.Add(Value);
      Inc(i);
    end;
  finally
    Free;
  end;
end;

procedure TCnSrcEditorToolBarMgr.SaveToolBarActions(Actions: TStrings;
  const FileName: string);
var
  i: Integer;
begin
  with TMemIniFile.Create(FileName) do
  try
    EraseSection(csToolBar);
    for i := 0 to Actions.Count - 1 do
      WriteString(csToolBar, csButton + IntToStr(i), Actions[i]);
  finally
    UpdateFile;
    Free;
  end;
end;

procedure TCnSrcEditorToolBarMgr.ConfigToolBar(AType: TCnSrcEditorToolBarType);
var
  List: TStringList;
  FileName: string;
begin
  with TCnFlatToolbarConfigForm.Create(nil) do
  try
    if AType = tbtCode then
    begin
      List := FToolBarActions;
      FileName := SCnEditorToolBarDataName;
    end
    else
    begin
      List := FDesignToolBarActions;
      FileName := SCnEditorDesignToolBarDataName;
    end;
    SetStyle(tbsEditor, FileName, 'CnSrcEditorToolbarConfigForm');
    ToolbarActions := List;
    if ShowModal = mrOk then
    begin
      List.Assign(ToolbarActions);

      SaveToolBarActions(List, WizOptions.GetUserFileName(FileName, False));
      WizOptions.CheckUserFile(FileName);
      UpdateToolBars;
    end;
  finally
    Free;
  end;
end;

procedure TCnSrcEditorToolBarMgr.CheckToolBarEnable;
var
  I, J, K: Integer;
  APage: TCnSrcEditorPage;
  ATop: Integer;
  AControl: TWinControl;
  EditorList: TList;
  VisibleList, InvisibleList: TList;
  TBObj: TCnEditorToolBarObj;
  ExToolBar: TCnExternalSrcEditorToolBar;
begin
  EditorList := TList.Create;
  VisibleList := TList.Create;
  InvisibleList := TList.Create;
  try
    // Build EditorControl.Parent List
    EnumEditControl(DoGetEditList, EditorList);
    for I := 0 to EditorList.Count - 1 do
    begin
      AControl := TWinControl(EditorList[I]);
      APage := GetCurrentTopEditorPage(AControl);
      VisibleList.Clear;
      InvisibleList.Clear;

      // Build Visible and Invisible ToolBar List
      for J := 0 to Count - 1 do
      begin
        if ToolBars[J].Parent = AControl then
          if ToolBars[J].CanShow(APage) then
            VisibleList.Add(ToolBars[J])
          else
            InvisibleList.Add(ToolBars[J]);
      end;

      if ExternalEditorToolBarMgr <> nil then
      begin
        with ExternalEditorToolBarMgr do
        begin
          for J := 0 to FToolBarTypes.Count - 1 do
          begin
            TBObj := TCnEditorToolBarObj(FToolBarTypes.Objects[J]);
            for K := 0 to TBObj.FToolBars.Count - 1 do
            begin
              ExToolBar := TCnExternalSrcEditorToolBar(TBObj.FToolBars[K]);
              if ExToolBar.Parent = AControl then
                if TBObj.ToolBarVisible and ExToolBar.CanShow(APage) then
                  VisibleList.Add(ExToolBar)
                else
                  InvisibleList.Add(ExToolBar);
            end;
          end;
        end;
      end;

      // Hide Invisible ToolBars
      for J := InvisibleList.Count - 1 downto 0 do
        TToolBar(InvisibleList[J]).Visible := False;

      // Show Visible ToolBars
      ATop := -1;
      for J := 0 to VisibleList.Count - 1 do
      begin
        TToolBar(VisibleList[J]).Visible := True;
        TToolBar(VisibleList[J]).Top := ATop;
        ATop := ATop + TToolBar(VisibleList[J]).Height;
      end;  
    end;
  finally
    EditorList.Free;
    VisibleList.Free;
    InvisibleList.Free;
  end;
end;

//------------------------------------------------------------------------------
// �����������
//------------------------------------------------------------------------------

procedure TCnSrcEditorToolBarMgr.LanguageChanged(Sender: TObject);
var
  I: Integer;
begin
  for I := 0 to Count - 1 do
    ToolBars[I].InitPopupMenu;
end;

procedure TCnSrcEditorToolBarMgr.LoadSettings(Ini: TCustomIniFile);
begin
  ShowToolBar := Ini.ReadBool(csToolBar, csShowToolBar, FShowToolBar);
  ShowDesignToolBar := Ini.ReadBool(csToolBar, csShowDesignToolBar, FShowDesignToolBar);
  Wrapable := Ini.ReadBool(csToolBar, csWrapable, FWrapable);
  LoadToolBarActions(FToolBarActions, WizOptions.GetUserFileName(SCnEditorToolBarDataName, True));
  LoadToolBarActions(FDesignToolBarActions, WizOptions.GetUserFileName(SCnEditorDesignToolBarDataName, True));
end;

procedure TCnSrcEditorToolBarMgr.SaveSettings(Ini: TCustomIniFile);
begin
  Ini.WriteBool(csToolBar, csShowToolBar, FShowToolBar);
  Ini.WriteBool(csToolBar, csShowDesignToolBar, FShowDesignToolBar);
  Ini.WriteBool(csToolBar, csWrapable, FWrapable);
  SaveToolBarActions(FToolBarActions, WizOptions.GetUserFileName(SCnEditorToolBarDataName, False));
  WizOptions.CheckUserFile(SCnEditorToolBarDataName);
  SaveToolBarActions(FDesignToolBarActions, WizOptions.GetUserFileName(SCnEditorDesignToolBarDataName, False));
  WizOptions.CheckUserFile(SCnEditorDesignToolBarDataName);
end;

procedure TCnSrcEditorToolBarMgr.DoEnhConfig;
begin
  if Assigned(FOnEnhConfig) then
    FOnEnhConfig(Self);
end;

//------------------------------------------------------------------------------
// ���Զ�д����
//------------------------------------------------------------------------------

function TCnSrcEditorToolBarMgr.GetCount: Integer;
begin
  Result := FList.Count;
end;

function TCnSrcEditorToolBarMgr.GetToolBar(Index: Integer): TCnSrcEditorToolBar;
begin
  Result := TCnSrcEditorToolBar(FList[Index]);
end;

procedure TCnSrcEditorToolBarMgr.SetActive(const Value: Boolean);
begin
  if FActive <> Value then
  begin
    FActive := Value;
    InstallToolBars;
  end;
end;

procedure TCnSrcEditorToolBarMgr.SetShowToolBar(const Value: Boolean);
begin
  if FShowToolBar <> Value then
  begin
    FShowToolBar := Value;
    InstallToolBars;
  end;
end;

procedure TCnSrcEditorToolBarMgr.SetShowDesignToolBar(const Value: Boolean);
begin
  if FShowDesignToolBar <> Value then
  begin
    FShowDesignToolBar := Value;
    InstallToolBars;
  end;
end;

procedure TCnSrcEditorToolBarMgr.SetWrapable(Value: Boolean);
var
  I: Integer;
begin
  if FWrapable <> Value then
  begin
    FWrapable := Value;
    for I := 0 to Count - 1 do
      ToolBars[I].Wrapable := Value;
  end;
end;

{ TCnExternalEditorToolBarMgr }

constructor TCnExternalEditorToolBarMgr.Create;
begin
  inherited;
  ExternalEditorToolBarMgr := Self;
  FToolBarTypes := TStringList.Create;

  EditControlWrapper.AddEditControlNotifier(EditControlNotify);
  InstallToolBars;
end;

destructor TCnExternalEditorToolBarMgr.Destroy;
var
  I: Integer;
begin
  ExternalEditorToolBarMgr := nil;
  EditControlWrapper.RemoveEditControlNotifier(EditControlNotify);
  
  for I := FToolBarTypes.Count - 1 downto 0 do
    TObject(FToolBarTypes.Objects[I]).Free;
  FToolBarTypes.Free;
  inherited;
end;

procedure TCnExternalEditorToolBarMgr.DoInstallToolBars(
  EditWindow: TCustomForm; EditControl: TControl; Context: Pointer);
var
  I: Integer;
  ToolBar: TToolBar;
  Obj: TCnEditorToolBarObj;
begin
  for I := 0 to FToolBarTypes.Count - 1 do
  begin
    ToolBar := TToolBar(EditWindow.FindComponent(FToolBarTypes[I]));
    Obj := TCnEditorToolBarObj(FToolBarTypes.Objects[I]);
    if ToolBar = nil then
    begin
      ToolBar := TCnExternalSrcEditorToolBar.Create(EditWindow);
      ToolBar.Name := FToolBarTypes[I];
      ToolBar.Tag := Integer(EditControl); // �� Tag ��¼�����Ӧ�� EditoControl

      ToolBar.Parent := EditControl.Parent;
      (ToolBar as TCnExternalSrcEditorToolBar).InitControls;

      if Assigned(Obj.CreateEvent) then
        Obj.CreateEvent(Obj.ToolBarType, EditControl, ToolBar);
      if Assigned(Obj.InitEvent) then
        Obj.InitEvent(Obj.ToolBarType, EditControl, ToolBar);

      ToolBar.Visible := Obj.ToolBarVisible;
      if Obj.ToolBarVisible then
        ToolBar.Update;
      Obj.AddToolBar(ToolBar, EditControl);
    end;
  end;
end;

function TCnExternalEditorToolBarMgr.GetToolBarObj(ToolBarType: string): TCnEditorToolBarObj;
var
  Idx: Integer;
begin
  Idx := FToolBarTypes.IndexOf(ToolBarType);
  if Idx >= 0 then
    Result := TCnEditorToolBarObj(FToolBarTypes.Objects[Idx])
  else
    Result := nil;
end;

procedure TCnExternalEditorToolBarMgr.EditControlNotify(
  EditControl: TControl; EditWindow: TCustomForm; Operation: TOperation);
var
  I, J: Integer;
  Obj: TCnEditorToolBarObj;
begin
  if Operation = opInsert then
    DoInstallToolBars(EditWindow, EditControl, nil)
  else if Operation = opRemove then
  begin
{$IFDEF DEBUG}
    CnDebugger.LogFmt('TCnEditorToolBarObj EditControl Removed: %8.8x.',
      [Integer(EditControl)]);
{$ENDIF}
    for I := FToolBarTypes.Count - 1 downto 0 do
    begin
      Obj := TCnEditorToolBarObj(FToolBarTypes.Objects[I]);
      for J := Obj.ToolBarCount - 1 downto 0 do
      begin
        if Obj.EditControls[J] = EditControl then
        begin
          // Ϊ�˱������ EditControl �ͷŶ� ToolBar û���ͷŵ�������˴��ֹ��ͷŵ���
          // �� ToolBar �ͷŵ� Notification ֪ͨ������ʣ�µ����顣
          Obj.ToolBars[J].Free;
        end;
      end;
    end;
  end;
end;

function TCnExternalEditorToolBarMgr.GetVisible(const ToolBarType: string): Boolean;
var
  Obj: TCnEditorToolBarObj;
begin
  Result := False;
  Obj := ToolBarObj[ToolBarType];
  if Obj <> nil then
  begin
    Result := Obj.ToolBarVisible;
  end;
end;

procedure TCnExternalEditorToolBarMgr.InstallToolBars;
begin
  EnumEditControl(DoInstallToolBars, nil);
end;

procedure TCnExternalEditorToolBarMgr.LanguageChanged;
var
  I, J: Integer;
  Obj: TCnEditorToolBarObj;
begin
  for I := 0 to FToolBarTypes.Count - 1 do
  begin
    Obj := TCnEditorToolBarObj(FToolBarTypes.Objects[I]);
    for J := 0 to Obj.ToolBarCount - 1 do
      if Obj.ToolBars[J] <> nil then
        if Assigned(Obj.InitEvent) then
        begin
          Obj.InitEvent(Obj.ToolBarType, Obj.EditControls[J], TToolBar(Obj.ToolBars[J]));
          Obj.ToolBars[J].Update;
        end;
  end;
end;

procedure TCnExternalEditorToolBarMgr.RegisterToolBarType(const ToolBarType:
  string; CreateEvent, InitEvent, RemoveEvent: TCnEditorToolBarEvent);
var
  Obj: TCnEditorToolBarObj;
begin
  if ToolBarType <> '' then
  begin
    Obj := ToolBarObj[ToolBarType];
    if Obj = nil then
    begin
      Obj := TCnEditorToolBarObj.Create(nil);
      FToolBarTypes.AddObject(ToolBarType, Obj);
    end;
    Obj.ToolBarVisible := True;
    Obj.ToolBarType := ToolBarType;
    Obj.CreateEvent := CreateEvent;
    Obj.InitEvent := InitEvent;
    Obj.RemoveEvent := RemoveEvent;
    InstallToolBars;
  end;
end;

procedure TCnExternalEditorToolBarMgr.RemoveToolBarType(const ToolBarType: string);
var
  Obj: TCnEditorToolBarObj;
  I: Integer;
begin
  Obj := ToolBarObj[ToolBarType];
  if Obj <> nil then
  begin
    for I := Obj.ToolBarCount - 1 downto 0 do
      Obj.ToolBars[I].Free;
    Obj.Free;
  end;
  FToolBarTypes.Delete(FToolBarTypes.IndexOf(ToolBarType));  
end;

procedure TCnExternalEditorToolBarMgr.SetVisible(const ToolBarType: string;
  Visible: Boolean);
var
  I: Integer;
  TBObj: TCnEditorToolBarObj;
begin
  for I := 0 to FToolBarTypes.Count - 1 do
  begin
    TBObj := TCnEditorToolBarObj(FToolBarTypes.Objects[I]);
    if (ToolBarType = '') or SameText(TBObj.ToolBarType, ToolBarType) then
    begin
      TBObj.ToolBarVisible := Visible;
    end;
  end;
  if CnSrcEditorToolBarMgr <> nil then
    CnSrcEditorToolBarMgr.CheckToolBarEnable;
end;

{ TCnEditorToolBarObj }

procedure TCnEditorToolBarObj.AddToolBar(AToolBar: TControl; EditControl: TControl);
begin
  FToolBars.Add(AToolBar);
  FEditControls.Add(EditControl);
  AToolBar.FreeNotification(Self);
end;

constructor TCnEditorToolBarObj.Create(AOwner: TComponent);
begin
  inherited;
  FToolBars := TList.Create;
  FEditControls := TList.Create;
end;

destructor TCnEditorToolBarObj.Destroy;
begin
  FEditControls.Free;
  FToolBars.Free;
  inherited;
end;

function TCnEditorToolBarObj.GetEditControls(Index: Integer): TControl;
begin
  Result := TControl(FEditControls[Index]);
end;

function TCnEditorToolBarObj.GetToolBarCount: Integer;
begin
  Result := FToolBars.Count;
end;

function TCnEditorToolBarObj.GetToolBars(Index: Integer): TControl;
begin
  Result := TControl(FToolBars[Index]);
end;

procedure CreateEditorToolBarService;
begin
  CnEditorToolBarService := TCnExternalEditorToolBarMgr.Create;
end;

procedure TCnEditorToolBarObj.Notification(AComponent: TComponent;
  Operation: TOperation);
var
  I: Integer;
begin
  inherited;
  if Operation = opRemove then
    for I := ToolBarCount - 1 downto 0 do
      if AComponent = FToolBars[I] then
      begin
        // ɾ�� ToolBar ʱ������ RemoveEvent ֪ͨ�ͷ���������
        if Assigned(FRemoveEvent)
          and (AComponent.Tag <> 0) and (TObject(AComponent.Tag) is TControl) then
          FRemoveEvent(ToolBarType, TObject(AComponent.Tag) as TControl,
            AComponent as TToolBar);

        // ���б���ֱ��ɾ��
        FToolBars.Delete(I);
        FEditControls.Delete(I);
{$IFDEF DEBUG}
        CnDebugger.LogFmt('TCnEditorToolBarObj Notification: ToolBar %d %8.8x Removed.',
          [I, Integer(AComponent)]);
{$ENDIF}
      end;
end;

procedure TCnEditorToolBarObj.RemoveEditControlFromIndex(Index: Integer);
begin
  FToolBars.Delete(Index);
  FEditControls.Delete(Index);
end;

{ TCnExternalSrcEditorToolBar }

procedure TCnExternalSrcEditorToolBar.InitControls;
begin
  inherited;
  AutoSize := True;
  Align := alTop;
  Images := GetIDEImageList;
end;

function TCnExternalSrcEditorToolBar.CanShow(APage: TCnSrcEditorPage): Boolean; 
begin
  Result := inherited CanShow(APage);
  if Assigned(FOnCanShow) then
    FOnCanShow(Self, APage, Result);
end;

initialization
  CreateEditorToolBarServiceProc := CreateEditorToolBarService;

finalization
  CnEditorToolBarService := nil;

{$ENDIF CNWIZARDS_CNSRCEDITORENHANCE}
end.
