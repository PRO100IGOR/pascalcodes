{******************************************************************************}
{                       CnPack For Delphi/C++Builder                           }
{                     �й����Լ��Ŀ���Դ�������������                         }
{                   (C)Copyright 2001-2011 CnPack ������                       }
{                   ------------------------------------                       }
{                                                                              }
{            ���������ǿ�Դ���������������������� CnPack �ķ���Э������        }
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

unit CnCompFilterFrm;
{ |<PRE>
================================================================================
* �������ƣ�CnPack IDE ר�Ұ�
* ��Ԫ���ƣ���������˴���
* ��Ԫ���ߣ���Х liuxiao@cnpack.org
* ��    ע���˵�Ԫ������ D7 for D8 �±���
* ����ƽ̨��PWinXP + Delphi 5.01
* ���ݲ��ԣ�PWin9X/2000/XP + Delphi 5/6/7 + C++Builder 5/6
* �� �� �����õ�Ԫ�е��ַ���֧�ֱ��ػ�������ʽ
* ��Ԫ��ʶ��$Id: CnCompFilterFrm.pas 763 2011-02-07 14:18:23Z liuxiao@cnpack.org $
* �޸ļ�¼��2006.09.08 V1.0
*               ������Ԫ
================================================================================
|</PRE>}

interface

{$I CnWizards.inc}

{$IFDEF CNWIZARDS_CNPALETTEENHANCEWIZARD}

uses
  Windows, Messages, SysUtils, Classes, Graphics,
  Controls, Forms, Dialogs, ExtCtrls, ToolWin, ComCtrls, StdCtrls, TypInfo,
  ActnList, ImgList, Menus, ToolsAPI, Tabs,
  {$IFDEF COMPILER6_UP}
  ComponentDesigner, DesignIntf,
  {$ELSE}
  LibIntf,
  {$ENDIF}
  CnWizUtils, CnWizMultiLang, CnWizShareImages, CnWizConsts, CnWizIdeUtils,
  CnWizNotifier, CnCommon, CnPopupMenu, RegExpr;

type
  TCnFilterFormStyle = (fsHidden, fsDropped, fsFloat);

  TCnIdeCompType = (ctVCL, ctCLX, ctBoth);

  TCnIdeCompInfo = class(TObject)
  private
    FCompName: string;
    FTabName: string;
    FUnitName: string;
    FImgIndex: Integer;
    FInternalName: string;
    FCompType: TCnIdeCompType;
  published
    property InternalName: string read FInternalName write FInternalName;
    property CompName: string read FCompName write FCompName;
    property TabName: string read FTabName write FTabName;
    property UnitName: string read FUnitName write FUnitName;
    property ImgIndex: Integer read FImgIndex write FImgIndex;
    property CompType: TCnIdeCompType read FCompType write FCompType;
  end;

  TCnCompFilterForm = class(TCnTranslateForm)
    Panel1: TPanel;
    pnlHdr: TPanel;
    tlb1: TToolBar;
    btnMatchStart: TToolButton;
    btnMatchAny: TToolButton;
    imgHdr: TImage;
    edtSearch: TEdit;
    ToolBar1: TToolBar;
    btnCreateComp: TToolButton;
    btnHelp: TToolButton;
    actlstFilter: TActionList;
    actCreateComp: TAction;
    tmrHide: TTimer;
    ilComps: TImageList;
    pmList: TPopupMenu;
    mniCreateComp: TMenuItem;
    N2: TMenuItem;
    mniDisplay: TMenuItem;
    mniTabs: TMenuItem;
    mniShowPrefix: TMenuItem;
    mniShowDetailHint: TMenuItem;
    mniAutoSelect: TMenuItem;
    mniShowAllTabs: TMenuItem;
    mniN1: TMenuItem;
    tmrHint: TTimer;
    ilBackup: TImageList;
    tmrLoad: TTimer;
    tbst1: TTabSet;
    pnlComp: TPanel;
    lvComps: TListView;
    pnlTab: TPanel;
    lvTabs: TListView;
    ilTabs: TImageList;
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure FormKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure edtSearchChange(Sender: TObject);
    procedure lvCompsData(Sender: TObject; Item: TListItem);
    procedure edtSearchKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure FormDeactivate(Sender: TObject);
    procedure FormHide(Sender: TObject);
    procedure edtSearchKeyPress(Sender: TObject; var Key: Char);
    procedure actCreateCompExecute(Sender: TObject);
    procedure lvCompsDblClick(Sender: TObject);
    procedure tmrHideTimer(Sender: TObject);
    procedure lvCompsCustomDrawItem(Sender: TCustomListView;
      Item: TListItem; State: TCustomDrawState; var DefaultDraw: Boolean);
    procedure lvCompsKeyPress(Sender: TObject; var Key: Char);
    procedure btnMatchStartClick(Sender: TObject);
    procedure FormResize(Sender: TObject);
    procedure imgHdrMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure imgHdrMouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure imgHdrMouseMove(Sender: TObject; Shift: TShiftState; X,
      Y: Integer);
    procedure actCreateCompUpdate(Sender: TObject);
    procedure lvCompsChange(Sender: TObject; Item: TListItem;
      Change: TItemChange);
    procedure btnHelpClick(Sender: TObject);
    procedure pmListPopup(Sender: TObject);
    procedure mniShowPrefixClick(Sender: TObject);
    procedure mniShowDetailHintClick(Sender: TObject);
    procedure mniAutoSelectClick(Sender: TObject);
    procedure mniShowAllTabsClick(Sender: TObject);
    procedure tmrHintTimer(Sender: TObject);
    procedure tmrLoadTimer(Sender: TObject);
    procedure tbst1Change(Sender: TObject; NewTab: Integer;
      var AllowChange: Boolean);
    procedure lvTabsData(Sender: TObject; Item: TListItem);
    procedure lvTabsCustomDrawItem(Sender: TCustomListView;
      Item: TListItem; State: TCustomDrawState; var DefaultDraw: Boolean);
    procedure lvTabsChange(Sender: TObject; Item: TListItem;
      Change: TItemChange);
    procedure lvTabsDblClick(Sender: TObject);
    procedure lvCompsKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
  private
    FFilterFormStyle: TCnFilterFormStyle;
    FCaptionHeight: Integer;
    FCompList: TStringList;
    FDisplayList: TStringList;
    FTabsList: TStringList;
    FTabsDisplayList: TStringList;
    FBasePoint: TPoint;
    FOnStyleChanged: TNotifyEvent;
    FOnSettingChanged: TNotifyEvent;
    FJustHide: Boolean;
    FNeedRefresh: Boolean;
    FUpdating: Boolean;
    FJustLoad: Boolean; // ���ƶ����ڲ��ظ� Load������� exception
    FMouseDown: Boolean;
    FOldX: Integer;
    FOldY: Integer;
    FCompBmp: TBitmap;

{$IFDEF COMPILER6_UP}
    FOldDesignerType: string;
    FIsDataModule: Boolean;
    FOldRootClass: TClass;    
{$ENDIF}

    FShowPrefix: Boolean;
    FUseSmallImg: Boolean;
    FAutoSelect: Boolean;
    FShowDetails: Boolean;
    FFilterTab: string;
    FDetailStr: string;
    FClassNameList: TStringList;
    FDetailsList: TStringList;
    FDetailHint: THintWindow;
    FPackageChanged: Boolean;
    FRegExpr: TRegExpr;

    procedure SetFilterFormStyle(const Value: TCnFilterFormStyle);
    procedure FileNotify(NotifyCode: TOTAFileNotification; const FileName: string);
    procedure UpdateFilterFormStyle;
    function AddCompImage(AComp: string): Integer;
    procedure TabsMenuClick(Sender: TObject);
    procedure ActivateDetailHint;
    procedure DeactivateDetailHint;
    procedure FormEditorNotify(FormEditor: IOTAFormEditor; NotifyType:
      TCnWizFormEditorNotifyType; ComponentHandle: TOTAHandle; Component:
      TComponent; const OldName, NewName: string);
    procedure CheckEnvAndUpdateCompList;
    procedure DoUpdateCompList(Sender: TObject);

    procedure SetShowPrefix(const Value: Boolean);
    procedure SetUseSmallImg(const Value: Boolean);
    procedure SetAutoSelect(const Value: Boolean);
    procedure SetFilterTab(const Value: string);
    procedure SetShowDetails(const Value: Boolean);
  protected
    procedure DoStyleChanged; virtual;
    procedure DoSettingChanged; virtual;
    procedure DoLanguageChanged(Sender: TObject); override;
    function GetHelpTopic: string; override;
  public
    { Public declarations }
    procedure LoadComponentsList;
    procedure ClearCompList;
    procedure ClearTabList;
    procedure UpdateToDisplayList;
    function RegExpContainsText(AText, APattern: string; IsMatchStart: Boolean = False): Boolean;
    function CanDisplayAComp(AComp: TCnIdeCompInfo): Boolean;
    function CanDisplayATab(ATab: string): Boolean;
    procedure AdjustLayout;

    property FilterFormStyle: TCnFilterFormStyle read FFilterFormStyle write SetFilterFormStyle;
    property BasePoint: TPoint read FBasePoint write FBasePoint;

    property OnStyleChanged: TNotifyEvent read FOnStyleChanged write FOnStyleChanged;
    property OnSettingChanged: TNotifyEvent read FOnSettingChanged write FOnSettingChanged;
    property JustHide: Boolean read FJustHide write FJustHide;

    property ShowPrefix: Boolean read FShowPrefix write SetShowPrefix;
    property UseSmallImg: Boolean read FUseSmallImg write SetUseSmallImg;
    property ShowDetails: Boolean read FShowDetails write SetShowDetails;
    property AutoSelect: Boolean read FAutoSelect write SetAutoSelect;
    property FilterTab: string read FFilterTab write SetFilterTab;
  end;

var
  CnCompFilterForm: TCnCompFilterForm = nil;

{$ENDIF CNWIZARDS_CNPALETTEENHANCEWIZARD}

implementation

{$IFDEF CNWIZARDS_CNPALETTEENHANCEWIZARD}

{$R *.DFM}

{$IFDEF DEBUG}
uses
  CnDebug;
{$ENDIF}

const
  CnImgIndexUnset = -2;
  CnImgIndexInvalid = -1;

var
  FOldRegisterComponentsProc: procedure(const Page: string;
    {$IFDEF COMPILER7_UP} const {$ENDIF} ComponentClasses: array of TComponentClass) = nil;

  ComponentTabListMap: TStringList = nil;

procedure CnCompRegisterComponents(const Page: string;
  {$IFDEF COMPILER7_UP} const {$ENDIF} ComponentClasses: array of TComponentClass);
var
  I: Integer;
  Obj: TObject;
begin
  if ComponentTabListMap = nil then
    ComponentTabListMap := TStringList.Create;

  for I := Low(ComponentClasses) to High(ComponentClasses) do
  begin
    if ComponentTabListMap.IndexOf(ComponentClasses[I].ClassName + '=' + Page) < 0 then
    begin
      if ComponentClasses[I].InheritsFrom(TWinControl) then
        Obj := TObject(ctVCL)
      else if InheritsFromClassName(ComponentClasses[I], 'TWidgetControl') then
        Obj := TObject(ctCLX)
      else
        Obj := TObject(ctBoth);

      ComponentTabListMap.AddObject(ComponentClasses[I].ClassName + '=' + Page, Obj);
    end;
  end;

  if Assigned(FOldRegisterComponentsProc) then
     FOldRegisterComponentsProc(Page, ComponentClasses);
end;

function TCnCompFilterForm.AddCompImage(AComp: string): Integer;
var
  AClass: TComponentClass;
{$IFDEF COMPILER6_UP}
  FormEditor: IOTAFormEditor;
  Root: TPersistent;
  PalItem: IPaletteItem;
  PalItemPaint: IPalettePaint;
{$ENDIF}
begin
  if FCompBmp = nil then
  begin
    FCompBmp := TBitmap.Create;
    FCompBmp.Height := 26;
    FCompBmp.Width := 26;
    FCompBmp.Canvas.Brush.Color := clBtnFace;
  end;

  Result := 0; // Ĭ��ʹ��ȱʡ�ؼ�ͼ��
  try
{$IFDEF COMPILER6_UP}
    FormEditor := CnOtaGetCurrentFormEditor;
    if Assigned(FormEditor) and (FormEditor.GetSelComponent(0) <> nil) then
    begin
      Root := TPersistent(FormEditor.GetSelComponent(0).GetComponentHandle);
      if (Root <> nil) and not ObjectIsInheritedFromClass(Root, 'TDataModule') then
      begin
        // ֻ���� CLX �� VCL ����ڴ���仯�������ת�� CLX/VCL ������ָ�
        if FOldRootClass <> Root.ClassType then
        begin
          ActivateClassGroup(TPersistentClass(Root.ClassType));
          FOldRootClass := Root.ClassType;
        end;
      end;
    end;
{$ENDIF}

    AClass := TComponentClass(GetClass(AComp));
    if AClass <> nil then
    begin
      FCompBmp.Canvas.FillRect(Bounds(0, 0, FCompBmp.Width, FCompBmp.Height));
{$IFDEF COMPILER6_UP}
      PalItem := ComponentDesigner.ActiveDesigner.Environment.GetPaletteItem(AClass) as IPaletteItem;
      if Supports(PalItem, IPalettePaint, PalItemPaint) then
        PalItemPaint.Paint(FCompBmp.Canvas, 0, 0);
{$ELSE}
      DelphiIDE.GetPaletteItem(TComponentClass(AClass)).Paint(FCompBmp.Canvas, -1, -1);
{$ENDIF}
    end;
    Result := ilComps.Add(FCompBmp, nil);
  except
    ;
  end;
end;

procedure TCnCompFilterForm.LoadComponentsList;
var
  I, J, EquPos: Integer;
  OldTabIdx, OldPalIdx: Integer;
  Info: TCnIdeCompInfo;
  AClass: TPersistentClass;
  S: string;

  procedure InitCompImages;
  var
    Bmp: TBitmap;
  begin
    ilComps.Clear;
    Bmp := TBitmap.Create;
    try
      Bmp.Height := ilComps.Height;
      Bmp.Width := ilComps.Width;
      Bmp.Canvas.Brush.Color := clBtnFace;
      Bmp.Canvas.FillRect(Bounds(0, 0, Bmp.Width, Bmp.Height));

      ilBackup.GetBitmap(0, Bmp); // ���Ĭ�Ͽؼ���
      ilComps.Add(Bmp, nil);
    finally
      Bmp.Free;
    end;
  end;

begin
  ClearCompList;
  ClearTabList;
  InitCompImages;

  OldTabIdx := CnPaletteWrapper.TabIndex;
  OldPalIdx := CnPaletteWrapper.SelectedIndex;

  // ���������Package�仯���µģ�����ͨ���ҽ�RegisterComponent���������
  if FPackageChanged then
  begin
    CnPaletteWrapper.Visible := False;
    CnPaletteWrapper.BeginUpdate;
  end;

{$IFDEF DEBUG}
  CnDebugger.LogEnter('LoadComponentsList');
{$ENDIF}
  Screen.Cursor := crHourGlass;

  try
    try
      if FPackageChanged then // �ɵķ����������� IDE �䶯
      begin
        for I := 0 to CnPaletteWrapper.TabCount - 1 do
        begin
          CnPaletteWrapper.TabIndex := I;
          for J := 0 to CnPaletteWrapper.PalToolCount - 1 do
          begin
            CnPaletteWrapper.SelectedIndex := J;
            if CnPaletteWrapper.SelectedToolName = 'Frames' then
              Continue;

            Info := TCnIdeCompInfo.Create;
            Info.InternalName := CnPaletteWrapper.SelectedToolName;
            Info.ImgIndex := CnImgIndexUnset;
            if not FShowPrefix and (Info.InternalName[1] = 'T') then
              Info.CompName := Copy(Info.InternalName, 2, MaxInt)
            else
              Info.CompName := Info.InternalName;

            Info.TabName := CnPaletteWrapper.ActiveTab;
            Info.CompType := ctBoth; // ����������� VCL/CLX �Ĵ��������Ը�ֵ both 

            AClass := GetClass(Info.InternalName);
            if (AClass <> nil) and (PTypeInfo(AClass.ClassInfo).Kind = tkClass) then
              Info.UnitName := GetTypeData(PTypeInfo(AClass.ClassInfo)).UnitName;

            FCompList.AddObject(Info.CompName, Info);
          end;
        end;
      end
      else // ���淽ʽ
      begin
        if ComponentTabListMap <> nil then
        begin
          ComponentTabListMap.Sort;
          for I := 0 to ComponentTabListMap.Count - 1 do
          begin
            Info := TCnIdeCompInfo.Create;

            S := ComponentTabListMap[I];
            EquPos := Pos('=', S);
            if EquPos > 0 then
            begin
              Info.InternalName := Copy(S, 1, EquPos - 1);
              Info.TabName := Copy(S, EquPos + 1, MaxInt);
            end
            else
            begin
              Info.InternalName := S;
              Info.TabName := 'Unknown';
            end;

            Info.ImgIndex := CnImgIndexUnset;
            Info.CompType := TCnIdeCompType(ComponentTabListMap.Objects[I]);
            if not FShowPrefix and (Info.InternalName[1] = 'T') then
              Info.CompName := Copy(Info.InternalName, 2, MaxInt)
            else
              Info.CompName := Info.InternalName;

            AClass := GetClass(Info.InternalName);
            if (AClass <> nil) and (PTypeInfo(AClass.ClassInfo).Kind = tkClass) then
              Info.UnitName := GetTypeData(PTypeInfo(AClass.ClassInfo)).UnitName;

            FCompList.AddObject(Info.CompName, Info);
          end;
        end;
      end;
    except
      ;
    end;

    // װ��������� Tabs �б�
    for I := 0 to CnPaletteWrapper.TabCount - 1 do
      FTabsList.Add(CnPaletteWrapper.Tabs[I]);

    // ��ǰ�ָ�
    if FPackageChanged then
    begin
      CnPaletteWrapper.Visible := True;
      CnPaletteWrapper.TabIndex := OldTabIdx;
      CnPaletteWrapper.SelectedIndex := OldPalIdx;
    end;

    // �˴��ݲ�����ͼ�񣬴���Ҫʱ��
  finally
    Screen.Cursor := crDefault;

    if FPackageChanged then
    begin
      CnPaletteWrapper.Visible := True;
      CnPaletteWrapper.TabIndex := OldTabIdx;
      CnPaletteWrapper.SelectedIndex := OldPalIdx;
      CnPaletteWrapper.EndUpdate;
      FPackageChanged := False;
    end;
    
    FJustLoad := True;
    tmrLoad.Enabled := True;
{$IFDEF DEBUG}
    CnDebugger.LogLeave('LoadComponentsList');
{$ENDIF}
  end;
end;

procedure TCnCompFilterForm.SetFilterFormStyle(const Value: TCnFilterFormStyle);
begin
  if FFilterFormStyle <> Value then
  begin
    FFilterFormStyle := Value;
    UpdateFilterFormStyle;
    DoStyleChanged;
  end;
end;

procedure TCnCompFilterForm.UpdateFilterFormStyle;
var
  WLong: Longint;
begin
  case FFilterFormStyle of
    fsHidden:
      begin
        Hide;
      end;
    fsDropped:
      begin
        WLong := GetWindowLong(Handle, GWL_STYLE);
        if WLong and WS_CAPTION <> 0 then // ˵���б�����
        begin
          SetWindowLong(Handle, GWL_STYLE,
            WLong and (not WS_CAPTION));
          Height := ClientHeight;
        end;
        AdjustLayout;
        if FNeedRefresh then
        begin
{$IFDEF DEBUG}
          CnDebugger.LogMsg('Drop and Refresh');
{$ENDIF}
          LoadComponentsList;
          UpdateToDisplayList;
          FNeedRefresh := False;
        end;
        edtSearch.SelectAll;
        if lvComps.Selected <> nil then
        begin
          lvComps.Selected.Focused := False;
          lvComps.Selected := nil;
        end;
        if Assigned(lvComps.OnChange) then
          lvComps.OnChange(lvComps, lvComps.Selected, ctState);
        Visible := True;
      end;
    fsFloat:
      begin
        SetWindowLong(Handle, GWL_STYLE,
          GetWindowLong(Handle, GWL_STYLE) or WS_CAPTION);
        Height := ClientHeight + FCaptionHeight;
        Visible := True;
      end;
  end;
end;

procedure TCnCompFilterForm.FormCreate(Sender: TObject);
begin
  FCaptionHeight := Height - ClientHeight;
  pnlComp.Align := alClient;
  pnlTab.Align := alClient;
  pnlComp.BringToFront;
  
  // ���� CnTranslateForm �� ScreenCenter
  Position := poDesigned;
  FDetailHint := THintWindow.Create(Self);
  tmrHint.Interval := Trunc(1.5 * Application.HintHidePause); // ��һ���

  FCompList := TStringList.Create;
  FDisplayList := TStringList.Create;
  FTabsList := TStringList.Create;
  FTabsDisplayList := TStringList.Create;
  FClassNameList := TStringList.Create;
  FDetailsList := TStringList.Create;
  FNeedRefresh := True;
  
  FRegExpr := TRegExpr.Create;
  FRegExpr.ModifierI := True;

  CnWizNotifierServices.AddFileNotifier(FileNotify);
  CnWizNotifierServices.AddFormEditorNotifier(FormEditorNotify);
end;

procedure TCnCompFilterForm.FormDestroy(Sender: TObject);
begin
  DeactivateDetailHint;
  CnWizNotifierServices.RemoveFormEditorNotifier(FormEditorNotify);
  CnWizNotifierServices.RemoveFileNotifier(FileNotify);
  FRegExpr.Free;
  FCompList.Free;
  FDetailsList.Free;
  FClassNameList.Free;
  FTabsDisplayList.Free;
  FTabsList.Free;
  FDisplayList.Free;
  FCompBmp.Free;
end;

procedure TCnCompFilterForm.ClearCompList;
var
  I: Integer;
begin
  if FCompList <> nil then
  begin
    for I := 0 to FCompList.Count - 1 do
      if FCompList.Objects[I] <> nil then
        FCompList.Objects[I].Free;
    FCompList.Clear;
  end;
end;

procedure TCnCompFilterForm.AdjustLayout;
begin
  // ������Ļ��ĳ���������λ�ã������ڿ�������
{$IFDEF DEBUG}
  CnDebugger.LogPoint(BasePoint);
{$ENDIF}

  if BasePoint.x < 0 then
    Left := 0 + 2
  else if BasePoint.x > Screen.Width - Width then // ̫��
    Left := Screen.Width - Width - 2
  else // �м�
    Left := BasePoint.x;

  if BasePoint.y < 0 then
    Top := 0
  else if BasePoint.y > Screen.Height - Height then // ̫��
    Top := Screen.Height - Height - 2
  else
    Top := BasePoint.y + 2;
end;

procedure TCnCompFilterForm.FormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if Key = VK_ESCAPE then
  begin
    CnPaletteWrapper.SelectComponent('', '');
    FilterFormStyle := fsHidden;
    Key := 0;
  end;
end;

procedure TCnCompFilterForm.UpdateToDisplayList;
var
  I: Integer;
begin
  FDisplayList.Clear;
  for I := 0 to FCompList.Count - 1 do
  begin
    if CanDisplayAComp(TCnIdeCompInfo(FCompList.Objects[I])) then
      FDisplayList.AddObject(TCnIdeCompInfo(FCompList.Objects[I]).CompName, FCompList.Objects[I]);
  end;
  lvComps.Items.Count := FDisplayList.Count;
  lvComps.Invalidate;

  if FFilterTab = '' then
    Caption := SCnSearchComponent
  else if tbst1.TabIndex = 0 then
    Caption := SCnSearchComponent + ' - ' + FFilterTab;

  FTabsDisplayList.Clear;
  for I := 0 to FTabsList.Count - 1 do
  begin
    if CanDisplayATab(FTabsList[I]) then
      FTabsDisplayList.Add(FTabsList[I]);
  end;
  lvTabs.Items.Count := FTabsDisplayList.Count;
  lvTabs.Invalidate;
end;

function TCnCompFilterForm.CanDisplayAComp(AComp: TCnIdeCompInfo): Boolean;
begin
  // ���һ����Ƿ������ʾ��Ҫ��
  Result := AComp <> nil;
  if Result then
  begin
    Result := RegExpContainsText(AComp.CompName, Trim(edtSearch.Text), btnMatchStart.Down);

    if Result and (FFilterTab <> '') then
      Result := AComp.TabName = FFilterTab;

    // �жϵ�ǰ�����������������Ƿ�ƥ��
    if Result and (AComp.CompType <> ctBoth) then
    begin
      if ((CnOtaGetActiveDesignerType = 'dfm') and (AComp.CompType = ctCLX)) or
        ((CnOtaGetActiveDesignerType = 'xfm') and (AComp.CompType = ctVCL)) then
        Result := False;
    end;
  end;
end;

function TCnCompFilterForm.CanDisplayATab(ATab: string): Boolean;
begin
  Result := ATab <> '';
  if Result then
  begin
    Result := edtSearch.Text = '';
    if btnMatchAny.Down then
    begin
      if not Result then
        Result := Pos(UpperCase(Trim(edtSearch.Text)), UpperCase(ATab)) > 0;
    end
    else
    begin
      if not Result then
        Result := Pos(UpperCase(Trim(edtSearch.Text)), UpperCase(ATab)) = 1;
    end;
  end;
end;

procedure TCnCompFilterForm.edtSearchChange(Sender: TObject);
begin
  UpdateToDisplayList;
  lvComps.Items.Count := FDisplayList.Count;
  lvComps.Invalidate;
  lvTabs.Items.Count := FTabsDisplayList.Count;
  lvTabs.Invalidate;
end;

procedure TCnCompFilterForm.lvCompsData(Sender: TObject; Item: TListItem);
var
  AComp: TCnIdeCompInfo;
begin
  if Item.Index >= FDisplayList.Count then Exit;

  AComp := TCnIdeCompInfo(FDisplayList.Objects[Item.Index]);
  if AComp <> nil then
  begin
    Item.Caption := AComp.CompName;
    // ��Ҫʱ����δȡ����ȡ
    if AComp.ImgIndex = CnImgIndexUnset then
      AComp.ImgIndex := AddCompImage(AComp.InternalName);

    Item.ImageIndex := AComp.ImgIndex;
    Item.Data := AComp;
  end;
end;

procedure TCnCompFilterForm.edtSearchKeyDown(Sender: TObject;
  var Key: Word; Shift: TShiftState);
begin
  if (Key in [VK_LEFT, VK_RIGHT]) and (Shift = []) then
  begin
    if tbst1.TabIndex = 0 then
    begin
      if (Key = VK_RIGHT) and (edtSearch.SelLength = 0) // ��������ҳ
        and (edtSearch.SelStart = Length(edtSearch.Text)) then
      begin
        tbst1.TabIndex := 1;
      end;
    end
    else
    begin
      if (Key = VK_LEFT) and (edtSearch.SelLength = 0) // ��������ҳ
        and (edtSearch.SelStart = 0) then
      begin
        tbst1.TabIndex := 0;
      end;
    end;
  end;

  if not (((Key = VK_F4) and (ssAlt in Shift)) or
    (Key in [VK_DELETE, VK_LEFT, VK_RIGHT]) or
    ((Key in [VK_HOME, VK_END]) and not (ssCtrl in Shift)) or
    ((Key in [VK_INSERT]) and ((ssShift in Shift) or (ssCtrl in Shift)))) then
  begin
    if tbst1.TabIndex = 0 then
      SendMessage(lvComps.Handle, WM_KEYDOWN, Key, 0)
    else
      SendMessage(lvTabs.Handle, WM_KEYDOWN, Key, 0);

    Key := 0;
  end;
end;

procedure TCnCompFilterForm.FormDeactivate(Sender: TObject);
begin
  if FilterFormStyle = fsFloat then
    DeactivateDetailHint;
  if FilterFormStyle = fsDropped then
  begin
    FilterFormStyle := fsHidden;
    FJustHide := True;
    tmrHide.Enabled := True;
  end;
end;

procedure TCnCompFilterForm.DoStyleChanged;
begin
  if Assigned(FOnStyleChanged) then
    FOnStyleChanged(Self);
end;

procedure TCnCompFilterForm.FormHide(Sender: TObject);
var
  OldChange: TLVChangeEvent;
begin
  DeactivateDetailHint;
  // �� F�����ⴥ��������¼�
  FFilterFormStyle := fsHidden;
  if lvComps.Selected <> nil then
  begin
    OldChange := lvComps.OnChange;
    lvComps.OnChange := nil;
    lvComps.Selected.Focused := False;
    lvComps.Selected := nil;
    lvComps.OnChange := OldChange;
  end;
end;

procedure TCnCompFilterForm.edtSearchKeyPress(Sender: TObject;
  var Key: Char);
begin
  if Key = #13 then
  begin
    if tbst1.TabIndex = 0 then
      actCreateComp.Execute
    else if FilterFormStyle = fsDropped then
      FilterFormStyle := fsHidden;
    Key := #0;
  end;
end;

procedure TCnCompFilterForm.actCreateCompExecute(Sender: TObject);
var
  I: Integer;
  AComp: TCnIdeCompInfo;
  FormEditor: IOTAFormEditor;
{$IFDEF COMPILER6_UP}
  Root: TPersistent;
  OldGroup: TPersistentClass;
{$ENDIF}  
begin
  try
    if (tbst1.TabIndex <> 0) or (lvComps.SelCount = 0) then Exit;

    FormEditor := CnOtaGetCurrentFormEditor;
    if FormEditor <> nil then
    begin
{$IFDEF COMPILER6_UP}
      OldGroup := nil;
      if FormEditor.GetSelComponent(0) <> nil then
      begin
        Root := TPersistent(FormEditor.GetSelComponent(0).GetComponentHandle);
        if Root <> nil then
          OldGroup := ActivateClassGroup(TPersistentClass(Root.ClassType));
      end;
{$ENDIF}
      for I := 0 to lvComps.Items.Count - 1 do
      begin
        if lvComps.Items[I].Selected and (lvComps.Items[I] <> nil)then
        begin
          AComp := TCnIdeCompInfo(lvComps.Items[I].Data);
          FormEditor.CreateComponent(FormEditor.GetSelComponent(0), AComp.InternalName,
            0, 0, 0, 0);
        end;
      end;
{$IFDEF COMPILER6_UP}
      if OldGroup <> nil then
        ActivateClassGroup(OldGroup);
{$ENDIF}
      CnOtaShowDesignerForm;
      CnPaletteWrapper.SelectComponent('', '');
      if FilterFormStyle = fsFloat then
        lvComps.Selected := nil;
    end;
  except
    ; // BPL �ı䵼������� Form ��ʧ�󣬵��ô˹��ܻ�����ʳ�ͻ�����������Ρ�
  end;
end;

procedure TCnCompFilterForm.lvCompsDblClick(Sender: TObject);
begin
  actCreateComp.Execute;
end;

procedure TCnCompFilterForm.tmrHideTimer(Sender: TObject);
begin
  FJustHide := False;
  tmrHide.Enabled := False;
end;

procedure TCnCompFilterForm.FileNotify(NotifyCode: TOTAFileNotification;
  const FileName: string);
begin
  if NotifyCode in [ofnPackageInstalled, ofnPackageUnInstalled] then
  begin
{$IFDEF DEBUG}
    Cndebugger.LogMsg('CompFilter: Package Changed.');
{$ENDIF}
    if Application.FindComponent('AppBuilder') = nil then
    begin
      Close;
      Exit;
    end;
    FPackageChanged := True;

    case FilterFormStyle of
      fsFloat:
      begin
        FNeedRefresh := True;
        FilterFormStyle := fsHidden;
      end;
      fsDropped:
      begin
        LoadComponentsList;
        UpdateToDisplayList;
      end;
      fsHidden:
      begin
        FNeedRefresh := True;
      end;
    end;
  end;
end;

procedure TCnCompFilterForm.lvCompsCustomDrawItem(Sender: TCustomListView;
  Item: TListItem; State: TCustomDrawState; var DefaultDraw: Boolean);
var
  R, ARect: TRect;
  Bmp: TBitmap;
  ImgIdx, MatchIdx, x, y: Integer;
  HdrStr, MatchStr, TailStr : string;
  OldColor: TColor;
begin
  DefaultDraw := False;

  R := Item.DisplayRect(drSelectBounds);
  if Item.Data <> nil then
  begin
    // ��Ҫʱ����δȡ����ȡ
    if TCnIdeCompInfo(Item.Data).ImgIndex = CnImgIndexUnset then
      TCnIdeCompInfo(Item.Data).ImgIndex := AddCompImage(TCnIdeCompInfo(Item.Data).InternalName);
    ImgIdx := TCnIdeCompInfo(Item.Data).ImgIndex;
  end
  else
    ImgIdx := CnImgIndexInvalid;

  // ������ʱλͼ��������˸
  Bmp := TBitmap.Create;
  try
    Bmp.PixelFormat := pf24bit;
    Bmp.Width := R.Right - R.Left;
    Bmp.Height := R.Bottom - R.Top;
    ARect := Bounds(0, 0, Bmp.Width, Bmp.Height);

    Bmp.Canvas.Font.Assign(lvComps.Font);
    Bmp.Canvas.Font.Style := [fsBold];
    Bmp.Canvas.Brush.Style := bsSolid;

    if Item.Selected then
    begin
      Bmp.Canvas.Brush.Color := $FFB0B0;
      Bmp.Canvas.Font.Color := clBlue;
    end;
    Bmp.Canvas.FillRect(Bounds(1, (Bmp.Height - ilComps.Height) div 2,
      Bmp.Width, ilComps.Height));

    if ImgIdx >= 0 then
      ilComps.Draw(Bmp.Canvas, 1, (Bmp.Height - ilComps.Height) div 2, ImgIdx);

    if edtSearch.Text = '' then
      MatchIdx := 0
    else
      MatchIdx := Pos(UpperCase(Trim(edtSearch.Text)), UpperCase(Item.Caption));

    x := ilComps.Width + 2;
    y := (Bmp.Height - Bmp.Canvas.TextHeight(Item.Caption)) div 2;
    if MatchIdx > 0 then
    begin
      HdrStr := Copy(Item.Caption, 1, MatchIdx - 1);
      MatchStr := Copy(Item.Caption, MatchIdx, Length(Trim(edtSearch.Text)));
      TailStr := Copy(Item.Caption, MatchIdx + Length(Trim(edtSearch.Text)), MaxInt);

      Bmp.Canvas.TextOut(x, y, HdrStr);
      Inc(x, Bmp.Canvas.TextWidth(HdrStr));
      OldColor := Bmp.Canvas.Font.Color;
      Bmp.Canvas.Font.Color := clRed;
      Bmp.Canvas.TextOut(x, y, MatchStr);
      Bmp.Canvas.Font.Color := OldColor;
      Inc(x, Bmp.Canvas.TextWidth(MatchStr));
      Bmp.Canvas.TextOut(x, y, TailStr);
    end
    else
      Bmp.Canvas.TextOut(x, y, Item.Caption);

    BitBlt(lvComps.Canvas.Handle, R.Left, R.Top, Bmp.Width, Bmp.Height,
      Bmp.Canvas.Handle, 0, 0, SRCCOPY);
  finally
    Bmp.Free;
  end;
end;

procedure TCnCompFilterForm.lvCompsKeyPress(Sender: TObject;
  var Key: Char);
begin
  if Key in ['0'..'9', 'a'..'z', 'A'..'Z'] then
  begin
    PostMessage(edtSearch.Handle, WM_CHAR, Integer(Key), 0);
    edtSearch.SetFocus;
    Key := #0;
  end
  else if Key = #13 then
  begin
    Key := #0;
    if tbst1.TabIndex = 0 then
      actCreateComp.Execute
    else
    begin
      if FilterFormStyle = fsDropped then
        FilterFormStyle := fsHidden;
    end;
  end;
end;

procedure TCnCompFilterForm.btnMatchStartClick(Sender: TObject);
begin
  UpdateToDisplayList;
  lvComps.Items.Count := FDisplayList.Count;
  lvComps.Invalidate;
  lvTabs.Items.Count := FTabsDisplayList.Count;
  lvTabs.Invalidate;
end;

procedure TCnCompFilterForm.SetShowPrefix(const Value: Boolean);
var
  I: Integer;
  Info: TCnIdeCompInfo;
begin
  if FShowPrefix <> Value then
  begin
    FShowPrefix := Value;
    for I := 0 to FCompList.Count - 1 do
    begin
      Info := TCnIdeCompInfo(FCompList.Objects[I]);
      if Info <> nil then
      begin
        if not FShowPrefix and (Info.InternalName[1] = 'T') then
          Info.CompName := Copy(Info.InternalName, 2, MaxInt)
        else
          Info.CompName := Info.InternalName;
      end;
      FCompList.Strings[I] := Info.CompName;
    end;
    UpdateToDisplayList;

    DoSettingChanged;
  end;
end;

procedure TCnCompFilterForm.SetUseSmallImg(const Value: Boolean);
begin
  if FUseSmallImg <> Value then
  begin
    FUseSmallImg := Value;
    // NOT Implemented
    DoSettingChanged;
  end;
end;

procedure TCnCompFilterForm.FormResize(Sender: TObject);
begin
  lvComps.Columns[0].Width := lvComps.Width - 22;
  lvTabs.Columns[0].Width := lvTabs.Width - 22;
  Invalidate;
end;

procedure TCnCompFilterForm.imgHdrMouseDown(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
  if (Button = mbLeft) and not FMouseDown then
  begin
    FMouseDown := True;
    FOldX := X; FOldY := Y;
  end;
end;

procedure TCnCompFilterForm.imgHdrMouseUp(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
  FMouseDown := False;
  if Left < 0 then
    Left := 0;
  if Top < 0 then
    Top := 0;
  if (Top + Height) > Screen.Height then
    Top := Screen.Height - Height;
  if (Left + Width) > Screen.Width then
    Left := Screen.Width - Width;
end;

procedure TCnCompFilterForm.imgHdrMouseMove(Sender: TObject;
  Shift: TShiftState; X, Y: Integer);
begin
  if FMouseDown then
  begin
    imgHdr.OnMouseMove := nil;
    SetBounds(Left + X - FOldX, Top + Y - FOldY, Width, Height);
    if FilterFormStyle = fsDropped then
      FilterFormStyle := fsFloat;
    imgHdr.OnMouseMove := imgHdrMouseMove;
  end;
end;

procedure TCnCompFilterForm.actCreateCompUpdate(Sender: TObject);
begin
  actCreateComp.Enabled := (tbst1.TabIndex = 0) and (lvComps.Selected <> nil);
end;

procedure TCnCompFilterForm.SetAutoSelect(const Value: Boolean);
begin
  if FAutoSelect <> Value then
  begin
    FAutoSelect := Value;
    if not FAutoSelect then
      CnPaletteWrapper.SelectComponent('', '')
    else if Assigned(lvComps.OnChange) then
      lvComps.OnChange(lvComps, lvComps.Selected, ctState);

    DoSettingChanged;
  end;
end;

procedure TCnCompFilterForm.lvCompsChange(Sender: TObject; Item: TListItem;
  Change: TItemChange);
var
  Info: TCnIdeCompInfo;
  AClass: TClass;
begin
  if FAutoSelect and (Change = ctState) and (lvComps.Selected <> nil) then
  begin
    if lvComps.Selected.Data <> nil then
    begin
      Info := TCnIdeCompInfo(lvComps.Selected.Data);
      FDetailStr := Format(SCnComponentDetailFmt, [Info.InternalName, Info.UnitName, Info.TabName]);

      FClassNameList.Clear;
      AClass := GetClass(Info.InternalName);
      while AClass <> nil do
      begin
        FClassNameList.Add(AClass.ClassName);
        AClass := AClass.ClassParent;
      end;
      FDetailStr := FDetailStr + FClassNameList.Text;

      if FShowDetails then
        ActivateDetailHint;

      CnPaletteWrapper.SelectComponent(Info.InternalName, Info.TabName);
    end;
  end;
end;

procedure TCnCompFilterForm.btnHelpClick(Sender: TObject);
begin
  ShowFormHelp;
end;

procedure TCnCompFilterForm.FormEditorNotify(FormEditor: IOTAFormEditor;
  NotifyType: TCnWizFormEditorNotifyType; ComponentHandle: TOTAHandle;
  Component: TComponent; const OldName, NewName: string);
begin
  if NotifyType = fetActivated then
    CheckEnvAndUpdateCompList;
end;

procedure TCnCompFilterForm.CheckEnvAndUpdateCompList;
var
  EnvChanged: Boolean;
{$IFDEF COMPILER6_UP}
  FormDesigner: IDesigner;
  AContainer: TComponent;
  IsDataModule: Boolean;
{$ENDIF}
begin
  try
{$IFDEF COMPILER6_UP}
    if (BorlandIDEServices as IOTAServices).GetActiveDesignerType <> FOldDesignerType then
    begin
{$IFDEF DEBUG}
      Cndebugger.LogMsg('DesignerType different');
{$ENDIF}
      EnvChanged := True;
      FOldDesignerType := (BorlandIDEServices as IOTAServices).GetActiveDesignerType;
    end
    else
    begin
      FormDesigner := CnOtaGetFormDesigner;
      if FormDesigner = nil then Exit;
      AContainer := FormDesigner.Root;
      // ���� VCL/CLX �µĿ��ӻ������ʾ�� DataModule
      IsDataModule := not (AContainer is TWinControl) and
        not ObjectIsInheritedFromClass(AContainer, 'TWidgetControl');

{$IFDEF DEBUG}
      Cndebugger.LogBoolean(IsDataModule, 'Current Is Datamodule: ');
{$ENDIF}

      EnvChanged := FIsDataModule <> IsDataModule; // ��ͬ�����
      FIsDataModule := IsDataModule;
    end;
{$ELSE}
    // D5 �²���Ҫ����
    EnvChanged := False;
{$ENDIF}

    if EnvChanged then
    begin
      if not FUpdating and (((FilterFormStyle = fsDropped) and not FJustLoad)
        or (FilterFormStyle = fsFloat)) then
      begin
        CnWizNotifierServices.ExecuteOnApplicationIdle(DoUpdateCompList);
      end
      else
        FNeedRefresh := True;
    end;
  except
    ;
  end;
end;

procedure TCnCompFilterForm.DoUpdateCompList(Sender: TObject);
begin
  try
    FUpdating := True;
    LoadComponentsList;
    UpdateToDisplayList;
  finally
    FUpdating := False;
  end;
end;

function TCnCompFilterForm.GetHelpTopic: string;
begin
  Result := 'CnPalEnhanceWizard';
end;

procedure TCnCompFilterForm.SetFilterTab(const Value: string);
begin
  FFilterTab := Value;
  UpdateToDisplayList;
end;

procedure TCnCompFilterForm.SetShowDetails(const Value: Boolean);
begin
  if FShowDetails <> Value then
  begin
    FShowDetails := Value;
    UpdateToDisplayList;
    DoSettingChanged;

    if not FShowDetails then
      DeactivateDetailHint
    else if Assigned(lvComps.OnChange) then
      lvComps.OnChange(lvComps, lvComps.Selected, ctState);
  end;
end;

procedure TCnCompFilterForm.DoSettingChanged;
begin
  if Assigned(FOnSettingChanged) then
    FOnSettingChanged(Self);
end;

procedure TCnCompFilterForm.pmListPopup(Sender: TObject);
var
  I: Integer;
  Item: TMenuItem;
begin
  CnPaletteWrapper.SelectComponent('', '');
  mniShowPrefix.Checked := FShowPrefix;
  mniAutoSelect.Checked := FAutoSelect;
  mniShowDetailHint.Checked := FShowDetails;
  mniShowAllTabs.Checked := FFilterTab = '';

  // ɾ���ɵ� Tabs �˵���
  if mniTabs.Count > 2 then
    for I := mniTabs.Count - 1 downto 2 do
      mniTabs.Delete(I);

  for I := 0 to CnPaletteWrapper.TabCount - 1 do
  begin
    Item := TMenuItem.Create(Self);
    Item.Caption := CnPaletteWrapper.Tabs[I];
    if FFilterTab = Item.Caption then
      Item.Checked := True;

    Item.Tag := I;
    Item.OnClick := TabsMenuClick;
    mniTabs.Add(Item);
  end;
end;

procedure TCnCompFilterForm.TabsMenuClick(Sender: TObject);
begin
  if (Sender is TMenuItem) then
  begin
    FilterTab := CnPaletteWrapper.Tabs[(Sender as TMenuItem).Tag];
    CnPaletteWrapper.SelectComponent('', CnPaletteWrapper.Tabs[(Sender as TMenuItem).Tag]);
  end;
end;

procedure TCnCompFilterForm.mniShowPrefixClick(Sender: TObject);
begin
  ShowPrefix := not ShowPrefix;
end;

procedure TCnCompFilterForm.mniShowDetailHintClick(Sender: TObject);
begin
  ShowDetails := not ShowDetails;
end;

procedure TCnCompFilterForm.mniAutoSelectClick(Sender: TObject);
begin
  AutoSelect := not AutoSelect;
end;

procedure TCnCompFilterForm.mniShowAllTabsClick(Sender: TObject);
begin
  FilterTab := '';
end;

procedure TCnCompFilterForm.ActivateDetailHint;
const
  AMargin = 10;
var
  R: TRect;
  P: TPoint;
  AWidth, HintWidth, HintHeight: Integer;
  I: Integer;
begin
  // ���� HINT ���ڵ�λ�ã�������������
  FDetailsList.Text := FDetailStr;
  HintWidth := 0; 
  // ������������
  for I := 0 to FDetailsList.Count - 1 do
  begin
    AWidth := FDetailHint.Canvas.TextWidth(FDetailsList[I]);
    if AWidth > HintWidth then
      HintWidth := AWidth;
  end;

  // �����ߵ�����
  if Trim(FDetailsList[FDetailsList.Count - 1]) = '' then
    HintHeight := (FDetailsList.Count - 1) * (FDetailHint.Canvas.TextHeight('Jy') + 1)
  else
    HintHeight := FDetailsList.Count * (FDetailHint.Canvas.TextHeight('Jy') + 1);

  P.x := 0;
  P.y := 0;
  // �õ����Ͻǵ�
  P := lvComps.ClientToScreen(P);

  R.Top := P.y;
  if P.x - HintWidth - 3 * AMargin < 0 then // ��ߵ�̫�󣬻��ұ�
  begin
    P.x := lvComps.Width;
    P.y := 0;
    // �õ����Ͻǵ�
    P := lvComps.ClientToScreen(P);

    if P.x + HintWidth + 3 * AMargin > Screen.Width then // �ұߵ�̫�ң���
      R.Left := Screen.Width - HintWidth - 3 * AMargin
    else // ȡ�ұ�
      R.Left := P.x + AMargin;
  end
  else // ȡ���
    R.Left := P.x - HintWidth - 3 * AMargin;

  R.Bottom := R.Top + HintHeight + 2 * AMargin;
  R.Right := R.Left + HintWidth + 2 * AMargin;

  FDetailHint.ActivateHint(R, FDetailStr);
  tmrHint.Enabled := False;
  tmrHint.Enabled := True;
end;

procedure TCnCompFilterForm.tmrHintTimer(Sender: TObject);
begin
  DeactivateDetailHint;
end;

procedure TCnCompFilterForm.DeactivateDetailHint;
begin
  if FDetailHint <> nil then
    FDetailHint.ReleaseHandle;
end;

procedure TCnCompFilterForm.tmrLoadTimer(Sender: TObject);
begin
{$IFDEF DEBUG}
  Cndebugger.LogMsg('Just load Time out.');
{$ENDIF}
  FJustLoad := False;
  lvComps.Invalidate;
  tmrLoad.Enabled := False;
end;

procedure TCnCompFilterForm.DoLanguageChanged(Sender: TObject);
begin
  Caption := SCnSearchComponent;
  if (tbst1 <> nil) and (tbst1.Tabs.Count > 0) then
    tbst1.TabIndex := 0;
  if FDetailHint <> nil then
    DeactivateDetailHint;
end;

procedure TCnCompFilterForm.tbst1Change(Sender: TObject; NewTab: Integer;
  var AllowChange: Boolean);
var
  Pnl: TPanel;
begin
  if NewTab = 0 then
    Pnl := pnlComp
  else
    Pnl := pnlTab;

  if Pnl.Align <> alClient then
    Pnl.Align := alClient;
  Pnl.BringToFront;

  if FDisplayList = nil then
    Exit;

  UpdateToDisplayList;
  if NewTab = 0 then
  begin
    lvComps.Items.Count := FDisplayList.Count;
    lvComps.Invalidate;
  end
  else
  begin
    lvTabs.Items.Count := FTabsDisplayList.Count;
    lvTabs.Invalidate;
    DeactivateDetailHint;
  end;

  if FFilterTab = '' then
    Caption := SCnSearchComponent
  else if tbst1.TabIndex = 0 then
    Caption := SCnSearchComponent + ' - ' + FFilterTab;
end;

procedure TCnCompFilterForm.ClearTabList;
begin
  FTabsList.Clear;
end;

procedure TCnCompFilterForm.lvTabsData(Sender: TObject; Item: TListItem);
begin
  if Item.Index < FTabsDisplayList.Count then
    Item.Caption := FTabsDisplayList[Item.Index];
end;

procedure TCnCompFilterForm.lvTabsCustomDrawItem(Sender: TCustomListView;
  Item: TListItem; State: TCustomDrawState; var DefaultDraw: Boolean);
var
  R, ARect: TRect;
  Bmp: TBitmap;
  MatchIdx, x, y: Integer;
  HdrStr, MatchStr, TailStr : string;
  OldColor: TColor;
begin
  DefaultDraw := False;

  R := Item.DisplayRect(drSelectBounds);

  // ������ʱλͼ��������˸
  Bmp := TBitmap.Create;
  try
    Bmp.PixelFormat := pf24bit;
    Bmp.Width := R.Right - R.Left;
    Bmp.Height := R.Bottom - R.Top;
    ARect := Bounds(0, 0, Bmp.Width, Bmp.Height);

    Bmp.Canvas.Font.Assign(lvComps.Font);
    Bmp.Canvas.Font.Style := [fsBold];
    Bmp.Canvas.Brush.Style := bsSolid;

    if Item.Selected then
    begin
      Bmp.Canvas.Brush.Color := $FFB0B0;
      Bmp.Canvas.Font.Color := clBlue;
    end;
    Bmp.Canvas.FillRect(Bounds(1, (Bmp.Height - ilTabs.Height) div 2,
      Bmp.Width - 1, ilTabs.Height));

    ilTabs.Draw(Bmp.Canvas, 1, (Bmp.Height - ilTabs.Height) div 2, 0);

    if edtSearch.Text = '' then
      MatchIdx := 0
    else
      MatchIdx := Pos(UpperCase(Trim(edtSearch.Text)), UpperCase(Item.Caption));

    x := ilTabs.Width + 2;
    y := (Bmp.Height - Bmp.Canvas.TextHeight(Item.Caption)) div 2;
    if MatchIdx > 0 then
    begin
      HdrStr := Copy(Item.Caption, 1, MatchIdx - 1);
      MatchStr := Copy(Item.Caption, MatchIdx, Length(Trim(edtSearch.Text)));
      TailStr := Copy(Item.Caption, MatchIdx + Length(Trim(edtSearch.Text)), MaxInt);

      Bmp.Canvas.TextOut(x, y, HdrStr);
      Inc(x, Bmp.Canvas.TextWidth(HdrStr));
      OldColor := Bmp.Canvas.Font.Color;
      Bmp.Canvas.Font.Color := clRed;
      Bmp.Canvas.TextOut(x, y, MatchStr);
      Bmp.Canvas.Font.Color := OldColor;
      Inc(x, Bmp.Canvas.TextWidth(MatchStr));
      Bmp.Canvas.TextOut(x, y, TailStr);
    end
    else
      Bmp.Canvas.TextOut(x, y, Item.Caption);

    BitBlt(lvTabs.Canvas.Handle, R.Left, R.Top, Bmp.Width, Bmp.Height,
      Bmp.Canvas.Handle, 0, 0, SRCCOPY);
  finally
    Bmp.Free;
  end;
end;

procedure TCnCompFilterForm.lvTabsChange(Sender: TObject; Item: TListItem;
  Change: TItemChange);
begin
  if (Change = ctState) and (lvTabs.Selected <> nil) then
    CnPaletteWrapper.SelectComponent('', lvTabs.Selected.Caption);
end;

procedure TCnCompFilterForm.lvTabsDblClick(Sender: TObject);
begin
  if FilterFormStyle = fsDropped then
    FilterFormStyle := fsHidden;
end;

procedure TCnCompFilterForm.lvCompsKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if Key in [VK_LEFT, VK_RIGHT] then
  begin
    PostMessage(edtSearch.Handle, WM_KEYDOWN, Key, 0);
    edtSearch.SetFocus;
  end
end;

function TCnCompFilterForm.RegExpContainsText(AText, APattern: string;
  IsMatchStart: Boolean): Boolean;
begin
  Result := True;
  if APattern = '' then Exit;

  if IsMatchStart and (APattern[1] <> '^') then // ����Ĵ�ͷƥ��
    APattern := '^' + APattern;

  FRegExpr.Expression := APattern;
  try
    Result := FRegExpr.Exec(AText);
  except
    Result := False;
  end;
end;

initialization
  // �ҽ�ϵͳ�� Classes.RegisterComponentsProc
  if Assigned(RegisterComponentsProc) then
  begin
    FOldRegisterComponentsProc := Classes.RegisterComponentsProc;
    Classes.RegisterComponentsProc := CnCompRegisterComponents;
  end;

finalization
  if ComponentTabListMap <> nil then
    FreeAndNil(ComponentTabListMap);
    
  // �ָ��ҽ�ϵͳ�� Classes.RegisterComponentsProc
  if Assigned(FOldRegisterComponentsProc) then
  begin
    Classes.RegisterComponentsProc := FOldRegisterComponentsProc;
    FOldRegisterComponentsProc := nil;
  end;

  if CnCompFilterForm <> nil then
    FreeAndNil(CnCompFilterForm);

{$ENDIF CNWIZARDS_CNPALETTEENHANCEWIZARD}
end.