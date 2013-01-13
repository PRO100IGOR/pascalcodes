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

unit CnComponentSelector;
{ |<PRE>
================================================================================
* ������ƣ�CnPack IDE ר�Ұ�
* ��Ԫ���ƣ����ѡ�񹤾�ר�ҵ�Ԫ
* ��Ԫ���ߣ��ܾ��� (zjy@cnpack.org)
* ��    ע��
* ����ƽ̨��PWin2000Pro + Delphi 5.01
* ���ݲ��ԣ�PWin9X/2000/XP + Delphi 5/6/7 + C++Builder 5/6
* �� �� �����ô����е��ַ���֧�ֱ��ػ�����ʽ
* ��Ԫ��ʶ��$Id: CnComponentSelector.pas 763 2011-02-07 14:18:23Z liuxiao@cnpack.org $
* �޸ļ�¼��2003.04.16 V1.2
*               �����л� Tag ��Χ����Ϊ�����ڡ�ʱ���ڶ��� SpinEdit ������ʾ�Ĵ���
*           2003.03.12 V1.1
*               ������֧��Ĭ�����������
*           2002.10.02 V1.0
*               ������Ԫ
================================================================================
|</PRE>}

interface

{$I CnWizards.inc}

{$IFDEF CNWIZARDS_CNCOMPONENTSELECTOR}

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, ExtCtrls, Buttons, ComCtrls, IniFiles, Registry, Menus, ToolsAPI,
  {$IFDEF COMPILER6_UP}
  DesignIntf, DesignEditors,
  {$ELSE}
  DsgnIntf,
  {$ENDIF}
  ActnList, TypInfo, CnConsts, CnWizClasses, CnWizConsts, CnWizUtils, CnCommon,
  CnSpin, CnWizOptions, CnWizMultiLang;

type

//==============================================================================
// ���ѡ��ר�Ҵ���
//==============================================================================

{ TCnComponentSelectorForm }

  TCnComponentSelectorForm = class(TCnTranslateForm)
    gbFilter: TGroupBox;
    rbCurrForm: TRadioButton;
    rbCurrControl: TRadioButton;
    rbSpecControl: TRadioButton;
    cbbFilterControl: TComboBox;
    gbByName: TGroupBox;
    gbComponentList: TGroupBox;
    lbSource: TListBox;
    btnAdd: TButton;
    btnAddAll: TButton;
    btnDelete: TButton;
    btnDeleteAll: TButton;
    btnSelAll: TButton;
    btnSelNone: TButton;
    btnSelInvert: TButton;
    Label1: TLabel;
    lbDest: TListBox;
    Label2: TLabel;
    btnHelp: TButton;
    btnOK: TButton;
    btnCancel: TButton;
    edtByName: TEdit;
    cbByName: TCheckBox;
    cbByClass: TCheckBox;
    cbbByClass: TComboBox;
    gbTag: TGroupBox;
    cbByTag: TCheckBox;
    cbbByTag: TComboBox;
    lblTag: TLabel;
    Label4: TLabel;
    cbbSourceOrderStyle: TComboBox;
    cbbSourceOrderDir: TComboBox;
    cbSubClass: TCheckBox;
    ActionList: TActionList;
    actAdd: TAction;
    actAddAll: TAction;
    actDelete: TAction;
    actDeleteAll: TAction;
    actSelAll: TAction;
    actSelNone: TAction;
    actSelInvert: TAction;
    cbDefaultSelAll: TCheckBox;
    cbIncludeChildren: TCheckBox;
    btnMoveToTop: TButton;
    btnMoveToBottom: TButton;
    btnMoveUp: TButton;
    btnMoveDown: TButton;
    actMoveToTop: TAction;
    actMoveToBottom: TAction;
    actMoveUp: TAction;
    actMoveDown: TAction;
    seTagStart: TCnSpinEdit;
    seTagEnd: TCnSpinEdit;
    chkByEvent: TCheckBox;
    cbbByEvent: TComboBox;
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure DoUpdateSourceOrder(Sender: TObject);
    procedure DoUpdateListControls(Sender: TObject);
    procedure DoUpdateList(Sender: TObject);
    procedure DoActionListUpdate(Sender: TObject);
    procedure actAddExecute(Sender: TObject);
    procedure actAddAllExecute(Sender: TObject);
    procedure actDeleteExecute(Sender: TObject);
    procedure actDeleteAllExecute(Sender: TObject);
    procedure actSelAllExecute(Sender: TObject);
    procedure actSelNoneExecute(Sender: TObject);
    procedure actSelInvertExecute(Sender: TObject);
    procedure btnOKClick(Sender: TObject);
    procedure actMoveToTopExecute(Sender: TObject);
    procedure actMoveToBottomExecute(Sender: TObject);
    procedure actMoveUpExecute(Sender: TObject);
    procedure actMoveDownExecute(Sender: TObject);
    procedure btnHelpClick(Sender: TObject);
  private
    { Private declarations }
    FIni: TCustomIniFile;
    FSourceList, FDestList: IDesignerSelections;
    FContainerWindow: TWinControl;
    FCurrList: TStrings;
    procedure GetEventList(AObj: TObject; AList: TStringList);
    procedure BeginUpdateList;
    procedure EndUpdateList;
    procedure InitControls;
    procedure UpdateControls;
    procedure UpdateList;
    procedure UpdateSourceOrders;
  protected
    property Ini: TCustomIniFile read FIni;
    property SourceList: IDesignerSelections read FSourceList;
    property DestList: IDesignerSelections read FDestList;
    property ContainerWindow: TWinControl read FContainerWindow;
    property CurrList: TStrings read FCurrList;
    function GetHelpTopic: string; override;
  public
    { Public declarations }
    constructor CreateEx(AOwner: TComponent; AIni: TCustomIniFile; ASourceList,
      ADestList: IDesignerSelections; AContainerWindow: TWinControl);
    procedure LoadSettings(Ini: TCustomIniFile; const Section: string); virtual;
    procedure SaveSettings(Ini: TCustomIniFile; const Section: string); virtual;
  end;

//==============================================================================
// ���ѡ��ר����
//==============================================================================

{ TCnComponentSelector }

  TCnComponentSelector = class(TCnMenuWizard)
  private
  
  protected
    function GetHasConfig: Boolean; override;
  public
    function GetState: TWizardState; override;
    class procedure GetWizardInfo(var Name, Author, Email, Comment: string); override;
    function GetCaption: string; override;
    function GetHint: string; override;
    function GetDefShortCut: TShortCut; override;
    procedure Execute; override;
  end;

{$ENDIF CNWIZARDS_CNCOMPONENTSELECTOR}

implementation

{$IFDEF CNWIZARDS_CNCOMPONENTSELECTOR}

{$R *.DFM}

{$IFDEF DEBUG}
uses
  CnDebug;
{$ENDIF}

//==============================================================================
// ���ѡ��ר�Ҵ���
//==============================================================================

{ TCnComponentSelectorForm }

// ��չ�Ĺ������������������������б���ƴ���
constructor TCnComponentSelectorForm.CreateEx(AOwner: TComponent;
  AIni: TCustomIniFile; ASourceList, ADestList: IDesignerSelections;
  AContainerWindow: TWinControl);
begin
  Create(AOwner);
  FIni := AIni;
  FSourceList := ASourceList;
  FDestList := ADestList;
  FContainerWindow := AContainerWindow;
end;

// �����ʼ��
procedure TCnComponentSelectorForm.FormCreate(Sender: TObject);
begin
  FCurrList := TStringList.Create;
  InitControls;
  LoadSettings(Ini, '');
  UpdateControls;
  UpdateList;
end;

// �����ͷ�
procedure TCnComponentSelectorForm.FormDestroy(Sender: TObject);
begin
  SaveSettings(Ini, '');
  FCurrList.Free;
end;

// ȷ������ѡ����
procedure TCnComponentSelectorForm.btnOKClick(Sender: TObject);
var
  i: Integer;
begin
  if lbDest.Items.Count > 0 then       // ѡ���б�Ϊ��
  begin
    for i := 0 to lbDest.Items.Count - 1 do
    {$IFDEF COMPILER6_UP}
      DestList.Add(TComponent(lbDest.Items.Objects[i]));
    {$ELSE}
      DestList.Add(MakeIPersistent(TComponent(lbDest.Items.Objects[i])));
    {$ENDIF}
  end
  else if cbDefaultSelAll.Checked then // ��ѡ����ʱ�Զ�������������
  begin
    for i := 0 to lbSource.Items.Count - 1 do
    {$IFDEF COMPILER6_UP}
      DestList.Add(TComponent(lbSource.Items.Objects[i]));
    {$ELSE}
      DestList.Add(MakeIPersistent(TComponent(lbSource.Items.Objects[i])));
    {$ENDIF}
  end;
  ModalResult := mrOk;
end;

//------------------------------------------------------------------------------
// �ؼ����÷���
//------------------------------------------------------------------------------

procedure TCnComponentSelectorForm.GetEventList(AObj: TObject;
  AList: TStringList);
var
  PropList: PPropList;
  Value: TMethod;
  Count, I: Integer;
  MName: string;
begin
  if (AObj = nil) or not (AObj is TComponent) or (TComponent(AObj).Owner = nil) then
    Exit;
  try
    Count := GetPropList(AObj.ClassInfo, [tkMethod], nil);
  except
    Exit;
  end;

  GetMem(PropList, Count * SizeOf(PPropInfo));
  try
    GetPropList(AObj.ClassInfo, [tkMethod], PropList);
    for i := 0 to Count - 1 do
    begin
      Value := GetMethodProp(AObj, PropList[I]);
      if Value.Code <> nil then
      begin
        MName := TComponent(AObj).Owner.MethodName(Value.Code);
        if (MName <> '') and (AList.IndexOf(MName) < 0) then
          AList.Add(MName);
      end;
    end;
  finally
    FreeMem(PropList);
  end;
end;

// ��ʼ���ؼ�
procedure TCnComponentSelectorForm.InitControls;
var
  i: Integer;
  WinControl: TWinControl;
  SelIsEmpty: Boolean;
  Component: TComponent;
  List: TStringList;
begin
  // ��鵱ǰѡ�������б��Ƿ�����ӿؼ�
  SelIsEmpty := True;
  for i := 0 to SourceList.Count - 1 do
  begin
  {$IFDEF COMPILER6_UP}
    Component := TComponent(SourceList[i]);
  {$ELSE}
    Component := TryExtractComponent(SourceList[i]);
  {$ENDIF}
    if Component = ContainerWindow then Break; // ѡ�񲿷ְ������屾��
    if (Component is TWinControl) and (TWinControl(Component).ControlCount > 0) then
    begin
      SelIsEmpty := False;
      Break;
    end;
  end;
  rbCurrControl.Enabled := not SelIsEmpty;
  if rbCurrControl.Checked and SelIsEmpty then
    rbCurrForm.Checked := True;
  // ��ʼ�������ؼ��б�
  cbbFilterControl.Items.Clear;
  for i := 0 to ContainerWindow.ComponentCount - 1 do
  begin
    if ContainerWindow.Components[i] is TControl then
    begin
      WinControl := TControl(ContainerWindow.Components[i]).Parent;
      if (WinControl <> nil) and (WinControl <> ContainerWindow) and
        (WinControl.Name <> '') and
        (cbbFilterControl.Items.IndexOfObject(WinControl) < 0) then
        cbbFilterControl.Items.AddObject(WinControl.Name, WinControl);
    end;
  end;
  rbSpecControl.Enabled := cbbFilterControl.Items.Count > 0;
  // ��ʼ�����б�
  cbbByClass.Items.Clear;
  for i := 0 to ContainerWindow.ComponentCount - 1 do
    with ContainerWindow.Components[i] do
      if cbbByClass.Items.IndexOf(ClassName) < 0 then
        cbbByClass.Items.AddObject(ClassName, Pointer(ClassType));
  cbbByEvent.Items.Clear;
  List := TStringList.Create;
  try
    List.Sorted := True;
    for i := 0 to ContainerWindow.ComponentCount - 1 do
      GetEventList(ContainerWindow.Components[i], List);
    cbbByEvent.Items.Assign(List);
  finally
    List.Free;
  end;          
end;

// ���µ�ǰ�����б�
procedure TCnComponentSelectorForm.UpdateList;
var
  i, j: Integer;
  SelStrs: TStrings;
  Component: TComponent;
  WinControl: TWinControl;
  
  // �����Ƿ�ƥ��
  function MatchName(const AName: string): Boolean;
  begin
    Result := not cbByName.Checked or (edtByName.Text = '') or
      (AnsiPos(UpperCase(edtByName.Text), UpperCase(AName)) > 0);
  end;

  // �����Ƿ�ƥ��
  function MatchClass(AObject: TObject): Boolean;
  begin
    Result := not cbByClass.Checked or (cbbByClass.Text = '') or
      AObject.ClassNameIs(cbbByClass.Text) or
      (cbSubClass.Checked and AObject.InheritsFrom(
      TClass(cbbByClass.Items.Objects[cbbByClass.ItemIndex])));
  end;

  // �¼��Ƿ�ƥ��
  function MatchEvent(AObject: TObject): Boolean;
  var
    List: TStringList;
  begin
    Result := True;
    if not chkByEvent.Checked or (cbbByEvent.Text = '') then
      Exit;

    List := TStringList.Create;
    try
      GetEventList(AObject, List);
      Result := List.IndexOf(cbbByEvent.Text) >= 0;
    finally
      List.Free;
    end;   
  end;

  // Tag �Ƿ�ƥ��
  function MatchTag(ATag: Integer): Boolean;
  var
    TagStart, TagEnd: Integer;
  begin
    if cbByTag.Checked then
    begin
      TagStart := StrToIntDef(seTagStart.Text, 0);
      TagEnd := StrToIntDef(seTagEnd.Text, 0);
      case cbbByTag.ItemIndex of
        0: Result := ATag = TagStart;
        1: Result := ATag < TagStart;
        2: Result := ATag > TagStart;
        3: Result := (ATag >= TagStart) and (ATag <= TagEnd);
      else
        Result := True;
      end;
    end
    else
      Result := True;
  end;

  // ����һ����Ŀ
  procedure AddItem(AComponent: TComponent; IncludeChildren: Boolean = False);
  var
    s: string;
    i: Integer;
  begin
    // �ж��Ƿ�ƥ��
    if (AComponent.Name <> '') and MatchName(AComponent.Name) and MatchClass(AComponent)
      and MatchEvent(AComponent) and MatchTag(AComponent.Tag)
      and (CurrList.IndexOfObject(AComponent) < 0) then
    begin
      s := AComponent.Name + ': ' + AComponent.ClassName;
      CurrList.AddObject(s, AComponent);  // ���ӵ���ǰ�����б�
      if lbDest.Items.IndexOf(s) < 0 then
        lbSource.Items.AddObject(s, AComponent); // ֻ���Ӳ�����ѡ���б��е���
    end;
    // �ݹ������ӿؼ�
    if IncludeChildren and (AComponent is TWinControl) then
      with TWinControl(AComponent) do
        for i := 0 to ControlCount - 1 do
          AddItem(Controls[i], True);
  end;
begin
  BeginUpdateList;
  try
    SelStrs := TStringList.Create;
    try
      for i := 0 to lbSource.Items.Count - 1 do // ���浱ǰ��ѡ����б�
        if lbSource.Selected[i] then
          SelStrs.Add(lbSource.Items[i]);
      CurrList.Clear;
      lbSource.Clear;
      if rbCurrForm.Checked then       // �������������
      begin
        for i := 0 to ContainerWindow.ComponentCount - 1 do
          AddItem(ContainerWindow.Components[i]);
      end
      else if rbCurrControl.Checked then // ��ǰѡ��ؼ����ӿؼ�
      begin
        for i := 0 to SourceList.Count - 1 do
        begin
        {$IFDEF COMPILER6_UP}
          Component := TComponent(SourceList[i]);
        {$ELSE}
          Component := TryExtractComponent(SourceList[i]);
        {$ENDIF}
          if Component is TWinControl then
          begin
            WinControl := TWinControl(Component);
            for j := 0 to WinControl.ControlCount - 1 do
              AddItem(WinControl.Controls[j], cbIncludeChildren.Checked);
          end;
        end;
      end
      else if rbSpecControl.Checked then // ָ���ؼ����ӿؼ�
      begin
        if cbbFilterControl.ItemIndex >= 0 then
        begin
          WinControl := TWinControl(cbbFilterControl.Items.Objects[cbbFilterControl.ItemIndex]);
            for i := 0 to WinControl.ControlCount - 1 do
              AddItem(WinControl.Controls[i], cbIncludeChildren.Checked);
        end;
      end;
      for i := 0 to lbSource.Items.Count - 1 do // �ָ������ѡ���б�
        lbSource.Selected[i] := SelStrs.IndexOf(lbSource.Items[i]) >= 0;
    finally
      SelStrs.Free;
    end;
  finally
    UpdateSourceOrders;
    EndUpdateList;
  end;
end;

// ���¿ؼ�״̬
procedure TCnComponentSelectorForm.UpdateControls;
  procedure InitComboBox(Combo: TComboBox);
  begin
    if (Combo.Items.Count > 0) and (Combo.ItemIndex < 0) then
      Combo.ItemIndex := 0;
  end;  
begin
  InitComboBox(cbbFilterControl);
  InitComboBox(cbbByClass);
  InitComboBox(cbbByTag);
  InitComboBox(cbbByEvent);
  InitComboBox(cbbSourceOrderStyle);
  InitComboBox(cbbSourceOrderDir);
  cbbFilterControl.Enabled := rbSpecControl.Checked;
  cbIncludeChildren.Enabled := not rbCurrForm.Checked;
  edtByName.Enabled := cbByName.Checked;
  cbSubClass.Enabled := cbByClass.Checked;
  cbbByClass.Enabled := cbByClass.Checked;
  cbbByTag.Enabled := cbByTag.Checked;
  cbbByEvent.Enabled := chkByEvent.Checked;
  seTagStart.Enabled := cbByTag.Checked;
  seTagEnd.Enabled := cbByTag.Checked;
  seTagEnd.Visible := cbbByTag.ItemIndex = 3;
  lblTag.Visible := cbbByTag.ItemIndex = 3;
end;

//------------------------------------------------------------------------------
// ListBox ���򷽷�
//------------------------------------------------------------------------------

type
  TSortStyle = (ssByName, ssByClass);
  TSortDir = (sdUp, sdDown);

var
  SortStyle: TSortStyle;
  SortDir: TSortDir;

// �ַ����б��������
function DoSortProc(List: TStringList; Index1, Index2: Integer): Integer;
var
  Comp1, Comp2: TComponent;
begin
  Comp1 := TComponent(List.Objects[Index1]);
  Comp2 := TComponent(List.Objects[Index2]);
  if SortStyle = ssByName then         // ����������
    Result := AnsiCompareText(Comp1.Name, Comp2.Name)
  else
  begin
    Result := AnsiCompareText(Comp1.ClassName, Comp2.ClassName);
    if Result = 0 then                 // ���ͬ���ٰ���������
      Result := AnsiCompareText(Comp1.Name, Comp2.Name);
  end;
  if SortDir = sdDown then             // ��������
    Result := -Result;
end;

// ���б���������
procedure DoSortListBox(ListBox: TCustomListBox);
var
  SelStrs: TStrings;
  OrderStrs: TStrings;
  i: Integer;
begin
  SelStrs := nil;
  OrderStrs := nil;
  try
    SelStrs := TStringList.Create;
    OrderStrs := TStringList.Create;
    for i := 0 to ListBox.Items.Count - 1 do // ����ѡ�����Ŀ
      if ListBox.Selected[i] then
        SelStrs.Add(ListBox.Items[i]);       // ListBox.Items �� ListBoxStrings ����
    OrderStrs.Assign(ListBox.Items);         // ����ֱ������ͨ�� TStringList ������
    TStringList(OrderStrs).CustomSort(DoSortProc);
    ListBox.Items.Assign(OrderStrs);
    for i := 0 to ListBox.Items.Count - 1 do // �ָ�ѡ�����Ŀ
      ListBox.Selected[i] := SelStrs.IndexOf(ListBox.Items[i]) >= 0;
  finally
    if SelStrs <> nil then SelStrs.Free;
    if OrderStrs <> nil then OrderStrs.Free;
  end;
end;

// ��Դ�б����½�������
procedure TCnComponentSelectorForm.UpdateSourceOrders;
begin
  case cbbSourceOrderStyle.ItemIndex of
    1: SortStyle := ssByName;
    2: SortStyle := ssByClass;
  else
    Exit;
  end;
  if cbbSourceOrderDir.ItemIndex = 1 then
    SortDir := sdDown
  else
    SortDir := sdUp;
  DoSortListBox(lbSource);
end;

//------------------------------------------------------------------------------
// ���ò�����ȡ
//------------------------------------------------------------------------------

const
  csContainerFilter = 'ContainerFilter';
  csFilterControl = 'FilterControl';
  csIncludeChildren = 'IncludeChildren';
  csByName = 'ByName';
  csByNameText = 'ByNameText';
  csByClass = 'ByClass';
  csByClassText = 'ByClassText';
  csSubClass = 'SubClass';
  csByEvent = 'ByEvent';
  csByEventIndex = 'ByEventIndex';
  csByTag = 'ByTag';
  csByTagIndex = 'ByTagIndex';
  csTagStart = 'TagStart';
  csTagEnd = 'TagEnd';
  csSourceOrderStyle = 'SourceOrderStyle';
  csSourceOrderDir = 'SourceOrderDir';
  csDestOrderStyle = 'DestOrderStyle';
  csDestOrderDir = 'DestOrderDir';
  csDefaultSelAll = 'DefaultSelAll';

// װ������
procedure TCnComponentSelectorForm.LoadSettings(Ini: TCustomIniFile;
  const Section: string);
begin
  rbCurrForm.Checked := True;
  case Ini.ReadInteger(Section, csContainerFilter, 0) of
    1: if rbCurrControl.Enabled then rbCurrControl.Checked := True;
    2: if rbSpecControl.Enabled then rbSpecControl.Checked := True;
  end;
  cbbFilterControl.ItemIndex := cbbFilterControl.Items.IndexOf(
    Ini.ReadString(Section, csFilterControl, ''));
  cbIncludeChildren.Checked := Ini.ReadBool(Section, csIncludeChildren, True);
  cbByName.Checked := Ini.ReadBool(Section, csByName, False);
  edtByName.Text := Ini.ReadString(Section, csByNameText, '');
  cbByClass.Checked := Ini.ReadBool(Section, csByClass, False);
  cbbByClass.ItemIndex := cbbByClass.Items.IndexOf(
    Ini.ReadString(Section, csByClassText, ''));
  cbSubClass.Checked := Ini.ReadBool(Section, csSubClass, True);
  chkByEvent.Checked := Ini.ReadBool(Section, csByEvent, False);
  cbbByEvent.ItemIndex := Ini.ReadInteger(Section, csByEvent, 0);
  cbByTag.Checked := Ini.ReadBool(Section, csByTag, False);
  cbbByTag.ItemIndex := Ini.ReadInteger(Section, csByTagIndex, 0);
  seTagStart.Text := IntToStr(Ini.ReadInteger(Section, csTagStart, 0));
  seTagEnd.Text := IntToStr(Ini.ReadInteger(Section, csTagEnd, 0));
  cbbSourceOrderStyle.ItemIndex := Ini.ReadInteger(Section, csSourceOrderStyle, 0);
  cbbSourceOrderDir.ItemIndex := Ini.ReadInteger(Section, csSourceOrderDir, 0);
  cbDefaultSelAll.Checked := Ini.ReadBool(Section, csDefaultSelAll, True);
end;

// ��������
procedure TCnComponentSelectorForm.SaveSettings(Ini: TCustomIniFile;
  const Section: string);
var
  i: Integer;
begin
  if rbCurrControl.Checked then i := 1
  else if rbSpecControl.Checked then i := 2
  else i := 0;
  Ini.WriteInteger(Section, csContainerFilter, i);
  Ini.WriteString(Section, csFilterControl, cbbFilterControl.Text);
  Ini.WriteBool(Section, csIncludeChildren, cbIncludeChildren.Checked);
  Ini.WriteBool(Section, csByName, cbByName.Checked);
  Ini.WriteString(Section, csByNameText, edtByName.Text);
  Ini.WriteBool(Section, csByClass, cbByClass.Checked);
  Ini.WriteString(Section, csByClassText, cbbByClass.Text);
  Ini.WriteBool(Section, csSubClass, cbSubClass.Checked);
  Ini.WriteBool(Section, csByEvent, chkByEvent.Checked);
  Ini.WriteInteger(Section, csByEvent, cbbByEvent.ItemIndex);
  Ini.WriteBool(Section, csByTag, cbByTag.Checked);
  Ini.WriteInteger(Section, csByTagIndex, cbbByTag.ItemIndex);
  Ini.WriteInteger(Section, csTagStart, StrToIntDef(seTagStart.Text, 0));
  Ini.WriteInteger(Section, csTagEnd, StrToIntDef(seTagEnd.Text, 0));
  Ini.WriteInteger(Section, csSourceOrderStyle, cbbSourceOrderStyle.ItemIndex);
  Ini.WriteInteger(Section, csSourceOrderDir, cbbSourceOrderDir.ItemIndex);
  Ini.WriteBool(Section, csDefaultSelAll, cbDefaultSelAll.Checked);
end;

//------------------------------------------------------------------------------
// �ؼ��¼�����
//------------------------------------------------------------------------------

// ��ʼ�����б�
procedure TCnComponentSelectorForm.BeginUpdateList;
begin
  lbSource.Items.BeginUpdate;
  lbDest.Items.BeginUpdate;
end;

// ���������б�
procedure TCnComponentSelectorForm.EndUpdateList;
begin
  lbSource.Items.EndUpdate;
  lbDest.Items.EndUpdate;
end;

// ���¶�Դ�б�����
procedure TCnComponentSelectorForm.DoUpdateSourceOrder(
  Sender: TObject);
begin
  if cbbSourceOrderStyle.ItemIndex <= 0 then
    UpdateList
  else
    UpdateSourceOrders;
end;

// �����б�
procedure TCnComponentSelectorForm.DoUpdateList(Sender: TObject);
begin
  UpdateList;
end;

// �����б�Ϳؼ�״̬
procedure TCnComponentSelectorForm.DoUpdateListControls(Sender: TObject);
begin
  UpdateControls;
  UpdateList;
end;

// ���ð���
procedure TCnComponentSelectorForm.btnHelpClick(Sender: TObject);
begin
  ShowFormHelp;
end;

function TCnComponentSelectorForm.GetHelpTopic: string;
begin
  Result := 'CnComponentSelector';
end;

//------------------------------------------------------------------------------
// ActionList �¼�����
//------------------------------------------------------------------------------

// Action ����
procedure TCnComponentSelectorForm.DoActionListUpdate(Sender: TObject);
begin
  actAdd.Enabled := lbSource.SelCount > 0;
  actAddAll.Enabled := lbSource.Items.Count > 0;
  actDelete.Enabled := lbDest.SelCount > 0;
  actDeleteAll.Enabled := lbDest.Items.Count > 0;
  actSelAll.Enabled := lbSource.SelCount < lbSource.Items.Count;
  actSelNone.Enabled := lbSource.SelCount > 0;
  actSelInvert.Enabled := lbSource.Items.Count > 0;
  actMoveToTop.Enabled := lbDest.SelCount > 0;
  actMoveToBottom.Enabled := lbDest.SelCount > 0;
  actMoveUp.Enabled := lbDest.SelCount > 0;
  actMoveDown.Enabled := lbDest.SelCount > 0;
end;

// ����ѡ��
procedure TCnComponentSelectorForm.actAddExecute(Sender: TObject);
var
  i: Integer;
begin
  BeginUpdateList;
  try
    for i := 0 to lbSource.Items.Count - 1 do
      if lbSource.Selected[i] then
        lbDest.Items.AddObject(lbSource.Items[i], lbSource.Items.Objects[i]);
    for i := lbSource.Items.Count - 1 downto 0 do
      if lbSource.Selected[i] then
        lbSource.Items.Delete(i);
  finally
    EndUpdateList;
  end;
end;

// ����ȫ��ѡ��
procedure TCnComponentSelectorForm.actAddAllExecute(Sender: TObject);
begin
  BeginUpdateList;
  try
    lbDest.Items.AddStrings(lbSource.Items);
    lbSource.Items.Clear;
  finally
    EndUpdateList;
  end;
end;

// ɾ��ѡ��
procedure TCnComponentSelectorForm.actDeleteExecute(Sender: TObject);
var
  i: Integer;
begin
  BeginUpdateList;
  try
    for i := 0 to lbDest.Items.Count - 1 do // ֻ�е�ǰ�����б����еĲż��뵽���
      if lbDest.Selected[i] and (CurrList.IndexOf(lbDest.Items[i]) >= 0) then
        lbSource.Items.AddObject(lbDest.Items[i], lbDest.Items.Objects[i]);
    for i := lbDest.Items.Count - 1 downto 0 do
      if lbDest.Selected[i] then
        lbDest.Items.Delete(i);
  finally
    UpdateSourceOrders;
    EndUpdateList;
  end;
end;

// ɾ��ȫ��ѡ��
procedure TCnComponentSelectorForm.actDeleteAllExecute(Sender: TObject);
var
  i: Integer;
begin
  BeginUpdateList;
  try
    for i := 0 to lbDest.Items.Count - 1 do // ֻ�е�ǰ�����б����еĲż��뵽���
      if CurrList.IndexOf(lbDest.Items[i]) >= 0 then
        lbSource.Items.AddObject(lbDest.Items[i], lbDest.Items.Objects[i]);
    lbDest.Items.Clear;
  finally
    UpdateSourceOrders;
    EndUpdateList;
  end;
end;

// ѡ��ȫ��
procedure TCnComponentSelectorForm.actSelAllExecute(Sender: TObject);
var
  i: Integer;
begin
  for i := 0 to lbSource.Items.Count - 1 do
    lbSource.Selected[i] := True;
end;

// ȡ��ѡ��
procedure TCnComponentSelectorForm.actSelNoneExecute(Sender: TObject);
var
  i: Integer;
begin
  for i := 0 to lbSource.Items.Count - 1 do
    lbSource.Selected[i] := False;
end;

// ��תѡ��
procedure TCnComponentSelectorForm.actSelInvertExecute(Sender: TObject);
var
  i: Integer;
begin
  for i := 0 to lbSource.Items.Count - 1 do
    lbSource.Selected[i] := not lbSource.Selected[i];
end;

// �ƶ�������
procedure TCnComponentSelectorForm.actMoveToTopExecute(Sender: TObject);
var
  i, j: Integer;
begin
  BeginUpdateList;
  try
    j := 0;
    for i := 0 to lbDest.Items.Count - 1 do
      if lbDest.Selected[i] then
      begin
        lbDest.Items.Move(i, j);
        lbDest.Selected[j] := True;
        Inc(j);
      end;
  finally
    EndUpdateList;
  end;
end;

// �ƶ����ײ�
procedure TCnComponentSelectorForm.actMoveToBottomExecute(Sender: TObject);
var
  i, j: Integer;
begin
  BeginUpdateList;
  try
    j := lbDest.Items.Count - 1;
    for i := lbDest.Items.Count - 1 downto 0 do
      if lbDest.Selected[i] then
      begin
        lbDest.Items.Move(i, j);
        lbDest.Selected[j] := True;
        Dec(j);
      end;
  finally
    EndUpdateList;
  end;
end;

// ����һ��
procedure TCnComponentSelectorForm.actMoveUpExecute(Sender: TObject);
var
  i: Integer;
begin
  BeginUpdateList;
  try
    for i := 1 to lbDest.Items.Count - 1 do
      if lbDest.Selected[i] and not lbDest.Selected[i - 1] then
      begin
        lbDest.Items.Move(i, i - 1);
        lbDest.Selected[i - 1] := True;
      end;
  finally
    EndUpdateList;
  end;
end;

// ����һ��
procedure TCnComponentSelectorForm.actMoveDownExecute(Sender: TObject);
var
  i: Integer;
begin
  BeginUpdateList;
  try
    for i := lbDest.Items.Count - 2 downto 0 do
      if lbDest.Selected[i] and not lbDest.Selected[i + 1] then
      begin
        lbDest.Items.Move(i, i + 1);
        lbDest.Selected[i + 1] := True;
      end;
  finally
    EndUpdateList;
  end;
end;

//==============================================================================
// ���ѡ��ר����
//==============================================================================

{ TCnComponentSelector }

// ר��ִ��������
procedure TCnComponentSelector.Execute;
var
  Ini: TCustomIniFile;
  Root: TComponent;
  FormDesigner: IDesigner;
  SourceList, DestList: IDesignerSelections;
begin
  if not Active and not Action.Enabled then
    Exit;
    
  Ini := CreateIniFile;
  try
    Root := CnOtaGetRootComponentFromEditor(CnOtaGetCurrentFormEditor);
{$IFDEF DEBUG}
    CnDebugger.LogFmt('%s: %s', [Root.ClassName, Root.Name]);
{$ENDIF}

    FormDesigner := CnOtaGetFormDesigner;
    if FormDesigner = nil then Exit;

{$IFDEF DEBUG}
    CnDebugger.LogFmt('Root Class: %s', [FormDesigner.GetRootClassName]);
{$ENDIF}

    SourceList := CreateSelectionList;
    DestList := CreateSelectionList;
    FormDesigner.GetSelections(SourceList);
    
    with TCnComponentSelectorForm.CreateEx(nil, Ini, SourceList, DestList,
      TWinControl(Root)) do
    try
      ShowHint := WizOptions.ShowHint;
      if ShowModal = mrOK then
        FormDesigner.SetSelections(DestList);
    finally
      Free;
    end;
  finally
    Ini.Free;
  end;
end;

//------------------------------------------------------------------------------
// ר�� override ����
//------------------------------------------------------------------------------

// ȡר�Ҳ˵�����
function TCnComponentSelector.GetCaption: string;
begin
  Result := SCnCompSelectorMenuCaption;
end;

// ȡר��Ĭ�Ͽ�ݼ�
function TCnComponentSelector.GetDefShortCut: TShortCut;
begin
  Result := 0;
end;

// ȡר���Ƿ������ô���
function TCnComponentSelector.GetHasConfig: Boolean;
begin
  Result := False;
end;

// ȡר�Ұ�ť��ʾ
function TCnComponentSelector.GetHint: string;
begin
  Result := SCnCompSelectorMenuHint;
end;

// ����ר��״̬
function TCnComponentSelector.GetState: TWizardState;
begin
  if CurrentIsForm then
    Result := [wsEnabled]              // ��ǰ�༭���ļ��Ǵ���ʱ������
  else
    Result := [];
end;

// ����ר����Ϣ
class procedure TCnComponentSelector.GetWizardInfo(var Name, Author, Email,
  Comment: string);
begin
  Name := SCnCompSelectorName;
  Author := SCnPack_Zjy;
  Email := SCnPack_ZjyEmail;
  Comment := SCnCompSelectorComment;
end;

initialization
  RegisterCnWizard(TCnComponentSelector); // ע��ר��

{$ENDIF CNWIZARDS_CNCOMPONENTSELECTOR}
end.
