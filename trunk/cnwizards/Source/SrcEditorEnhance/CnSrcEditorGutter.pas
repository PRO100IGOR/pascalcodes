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

unit CnSrcEditorGutter;
{ |<PRE>
================================================================================
* ������ƣ�CnPack IDE ר�Ұ�
* ��Ԫ���ƣ�����༭���к���ʾ��Ԫ
* ��Ԫ���ߣ���Х��LiuXiao�� liuxiao@cnpack.org
*           �ܾ��� (zjy@cnpack.org)
* ��    ע��
* ����ƽ̨��PWin2000Pro + Delphi 5.01
* ���ݲ��ԣ�PWin9X/2000/XP + Delphi 5/6/7 + C++Builder 5/6
* �� �� �����õ�Ԫ�е��ַ���֧�ֱ��ػ�����ʽ
* ��Ԫ��ʶ��$Id: CnSrcEditorGutter.pas 763 2011-02-07 14:18:23Z liuxiao@cnpack.org $
* �޸ļ�¼��2004.12.25
*               ������Ԫ����ԭ CnSrcEditorEnhancements �Ƴ�
================================================================================
|</PRE>}

interface

{$I CnWizards.inc}

uses
  Windows, Messages, Classes, Graphics, SysUtils, Controls, Menus, Forms, ToolsAPI,
  IniFiles, CnEditControlWrapper, CnWizNotifier, CnIni, CnPopupMenu;

type

{ TCnSrcEditorGutter }

  TCnSrcEditorGutterMgr = class;
  TCnGutterWidth = 1..10;

  TCnSrcEditorGutter = class(TCustomControl)
  private
    FActive: Boolean;
    FPainting: Boolean;
    FGutterMgr: TCnSrcEditorGutterMgr;
    FEditControl: TControl;
    FEditWindow: TCustomForm;
    FMenu: TPopupMenu;
{$IFDEF BDS}
    FIDELineNumMenu: TMenuItem;
{$ENDIF}
    FOldLineWidth: Integer;
    FPosInfo: TEditControlInfo;
    function GetTextHeight: Integer;
    procedure MenuPopup(Sender: TObject);
    procedure EditorChanged(Editor: TEditorObject; ChangeType: TEditorChangeTypes);
    procedure OnClearBookMarks(Sender: TObject);
    procedure OnEnhConfig(Sender: TObject);
    procedure OnGotoLine(Sender: TObject);
    procedure OnLineClose(Sender: TObject);
{$IFDEF BDS}
    procedure OnShowIDELineNum(Sender: TObject);
{$ENDIF}
    procedure SubItemClick(Sender: TObject);
    function GetLineCountRect: TRect;
  protected
{$IFDEF BDS}
    procedure SetEnabled(Value: Boolean); override;
{$ENDIF}
    procedure Click; override;
    procedure InitPopupMenu;
    procedure Paint; override;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    procedure UpdateStatus;
    procedure UpdateStatusOnIdle(Sender: TObject);
    procedure LanguageChanged(Sender: TObject);
    property EditControl: TControl read FEditControl write FEditControl;
    property EditWindow: TCustomForm read FEditWindow write FEditWindow;
    property OldLineWidth: Integer read FOldLineWidth write FOldLineWidth;
    property Menu: TPopupMenu read FMenu;
  end;

{ TCnSrcEditorGutterMgr }

  TCnSrcEditorGutterMgr = class(TObject)
  private
    FList: TList;
    FFont: TFont;
    FShowLineNumber: Boolean;
    FOnEnhConfig: TNotifyEvent;
    FActive: Boolean;
    FCurrFont: TFont;
    FShowLineCount: Boolean;
    FAutoWidth: Boolean;
    FMinWidth: TCnGutterWidth;
    FFixedWidth: TCnGutterWidth;
    procedure SetFont(const Value: TFont);
    procedure SetShowLineNumber(const Value: Boolean);
    procedure SetActive(const Value: Boolean);
    function GetCount: Integer;
    function GetGutters(Index: Integer): TCnSrcEditorGutter;
    procedure SetCurrFont(const Value: TFont);
    procedure EditControlNotify(EditControl: TControl; EditWindow: TCustomForm; 
      Operation: TOperation);
    procedure SetFixedWidth(const Value: TCnGutterWidth);
    procedure SetMinWidth(const Value: TCnGutterWidth);
  protected
    procedure DoUpdateGutters(EditWindow: TCustomForm; EditControl: TControl; Context: 
      Pointer);
    procedure DoEnhConfig;
    procedure DoLineClose;
    function CanShowGutter: Boolean;
  public
    constructor Create;
    destructor Destroy; override;
    
    procedure UpdateGutters;
    procedure LanguageChanged(Sender: TObject);
    procedure LoadSettings(Ini: TCustomIniFile);
    procedure SaveSettings(Ini: TCustomIniFile); 

    property Count: Integer read GetCount;
    property Gutters[Index: Integer]: TCnSrcEditorGutter read GetGutters;
    
    property Font: TFont read FFont write SetFont;
    property CurrFont: TFont read FCurrFont write SetCurrFont;
    property ShowLineNumber: Boolean read FShowLineNumber write SetShowLineNumber;
    property ShowLineCount: Boolean read FShowLineCount write FShowLineCount;
    property AutoWidth: Boolean read FAutoWidth write FAutoWidth;
    property MinWidth: TCnGutterWidth read FMinWidth write SetMinWidth;
    property FixedWidth: TCnGutterWidth read FFixedWidth write SetFixedWidth;

    property Active: Boolean read FActive write SetActive;
    property OnEnhConfig: TNotifyEvent read FOnEnhConfig write FOnEnhConfig;
  end;

implementation

uses
{$IFDEF Debug}
  CnDebug,
{$ENDIF}
  CnCommon, CnWizClasses, CnWizManager, CnBookmarkWizard, CnWizUtils, CnWizConsts,
  CnWizIdeUtils, Math;

const
  SCnSrcEditorGutter = 'CnSrcEditorGutter';
  csIDEShowLineNumbers = 'ShowLineNumbers';

  csBevelWidth = 4;
  csGutter = 'Gutter';
{$IFDEF BDS}
  csShowLineNumber = 'ShowLineNumberBDS';
  csShowLineNumberDef = True;
{$ELSE}
  csShowLineNumber = 'ShowLineNumber';
  csShowLineNumberDef = True;
{$ENDIF}
  csFont = 'Font';
  csCurrFont = 'CurrFont';
  csShowLineCount = 'ShowLineCount';
  csAutoWidth = 'AutoWidth';
  csMinWidth = 'MinWidth';
  csFixedWidth = 'FixedWidth';

{ TCnSrcEditorGutter }

constructor TCnSrcEditorGutter.Create(AOwner: TComponent);
begin
  inherited;
  BevelOuter := bvLowered;
  BevelInner := bvRaised;
  Width := 10;
  Align := alLeft;
  DoubleBuffered := True;

  FMenu := TPopupMenu.Create(Self);
  FMenu.OnPopup := MenuPopup;
  InitPopupMenu;
  PopupMenu := FMenu;
  EditControlWrapper.AddEditorChangeNotifier(EditorChanged);
end;

destructor TCnSrcEditorGutter.Destroy;
begin
  FGutterMgr.FList.Remove(Self);
  EditControlWrapper.RemoveEditorChangeNotifier(EditorChanged);
  inherited;
end;

//------------------------------------------------------------------------------
// ״̬����
//------------------------------------------------------------------------------

{$IFDEF BDS}
procedure TCnSrcEditorGutter.SetEnabled(Value: Boolean);
begin
// ʲôҲ���������赲 BDS ���л�ҳ��ʱ Disable �������Ĳ���
end;
{$ENDIF}

function TCnSrcEditorGutter.GetTextHeight: Integer;
begin
  Result := EditControlWrapper.GetCharHeight;
end;

procedure TCnSrcEditorGutter.EditorChanged(Editor: TEditorObject;
  ChangeType: TEditorChangeTypes);
begin
  if FGutterMgr.CanShowGutter and (Editor.EditControl = EditControl) then
  begin
    if ChangeType * [ctView, ctTopEditorChanged] <> [] then
      CnWizNotifierServices.ExecuteOnApplicationIdle(UpdateStatusOnIdle)
    else if ChangeType * [ctWindow, ctCurrLine, ctFont, ctVScroll,
      ctElided, ctUnElided] <> [] then
      Repaint;
  end;
end;

procedure TCnSrcEditorGutter.UpdateStatus;
var
  EditorObj: TEditorObject;
  MaxRowWidth, MaxCurRowWidth: Integer;
  EndLine: Integer;

  function GetNumWidth(Len: Integer): Integer;
  begin
    Result := Canvas.TextWidth(IntToStrEx(0, Len));
  end;
begin
  if not FActive then
  begin
    Visible := False;
    Exit;
  end;
  
  EditorObj := EditControlWrapper.GetEditorObject(EditControl);
  if (EditorObj = nil) or not EditorObj.EditorIsOnTop then
  begin
    Visible := False;
    Exit;
  end;

  Visible := True;
  Canvas.Font := Font;

  if FGutterMgr.AutoWidth then
  begin
    FPosInfo := EditControlWrapper.GetEditControlInfo(EditControl);
    if FGutterMgr.ShowLineCount then
      EndLine := FPosInfo.LineCount
    else
      EndLine := EditorObj.ViewBottomLine;
    MaxRowWidth := Max(GetNumWidth(Length(IntToStr(EndLine))),
      GetNumWidth(FGutterMgr.MinWidth));

    Canvas.Font := FGutterMgr.CurrFont;
    MaxCurRowWidth := Max(GetNumWidth(Length(IntToStr(EndLine))),
      GetNumWidth(FGutterMgr.MinWidth));
  end
  else
  begin
    MaxRowWidth := GetNumWidth(FGutterMgr.FixedWidth);
    Canvas.Font := FGutterMgr.CurrFont;
    MaxCurRowWidth := GetNumWidth(FGutterMgr.FixedWidth);
  end;

  Canvas.Font := Font;
  MaxRowWidth := Max(MaxRowWidth, MaxCurRowWidth);
  // ��ǰ��������ܸ�����û��Ʋ��㣬ȡ����
  Width := MaxRowWidth + csBevelWidth + 1; // ���һ���
  Invalidate;
end;

procedure TCnSrcEditorGutter.UpdateStatusOnIdle(Sender: TObject);
begin
  UpdateStatus;
end;

function TCnSrcEditorGutter.GetLineCountRect: TRect;
begin
  Canvas.Font := FGutterMgr.Font;
  Result := Rect(1, ClientHeight - Canvas.TextHeight(IntToStr(FPosInfo.LineCount)),
    Width - csBevelWidth, ClientHeight);
end;

procedure TCnSrcEditorGutter.Paint;
var
  R: TRect;
  StrNum: string;
  I, Idx, TextHeight, MaxRow: Integer;
  EditorObj: TEditorObject;
begin
  if FPainting or not Visible or (EditControl = nil) or (Parent = nil) then
    Exit;

  FPainting := True;
  try
    TextHeight := EditControlWrapper.GetCharHeight;
    if TextHeight > 0 then
    begin
      EditorObj := EditControlWrapper.GetEditorObject(EditControl);
      if EditorObj = nil then Exit;
      FPosInfo := EditControlWrapper.GetEditControlInfo(EditControl);

      if FGutterMgr.AutoWidth then
      begin
        if FGutterMgr.ShowLineCount then
          MaxRow := FPosInfo.LineCount
        else
          MaxRow := EditorObj.ViewBottomLine;
        if (OldLineWidth <> Length(IntToStr(MaxRow))) then
        begin
          OldLineWidth := Length(IntToStr(MaxRow));
          UpdateStatus;
          Exit;
        end;
      end;

      Canvas.Brush.Style := bsClear;
      for I := 0 to EditorObj.ViewLineCount - 1 do
      begin
        Idx := EditorObj.ViewLineNumber[I];
        if Idx <> FPosInfo.CaretY then
          Canvas.Font := FGutterMgr.Font
        else
          Canvas.Font := FGutterMgr.CurrFont;

        StrNum := IntToStr(Idx);
        R := Rect(1, I * TextHeight, Width - csBevelWidth, (I + 1) * TextHeight);

        DrawText(Canvas.Handle, PChar(StrNum), Length(StrNum), R, DT_VCENTER or
          DT_RIGHT);
      end;

      if FGutterMgr.ShowLineCount then
      begin
        R := GetLineCountRect;
        Canvas.Font := FGutterMgr.Font;
        Canvas.Font.Color := clWhite;
        StrNum := IntToStr(FPosInfo.LineCount);
        Canvas.Brush.Color := clNavy;
        Canvas.FillRect(R);
        DrawText(Canvas.Handle, PChar(StrNum), Length(StrNum), R, DT_VCENTER or
          DT_RIGHT);
      end;
    end;

    Canvas.Pen.Color := clBtnHighlight;
    Canvas.MoveTo(Width - 1, 0);
    Canvas.LineTo(Width - 1, Height);

    Canvas.Pen.Color := clBtnShadow;
    Canvas.MoveTo(Width - 2, 0);
    Canvas.LineTo(Width - 2, Height);
  finally
    FPainting := False;
  end;
end;

//------------------------------------------------------------------------------
// ����¼�
//------------------------------------------------------------------------------

procedure TCnSrcEditorGutter.Click;
var
  EditView: IOTAEditView;
  Row: Integer;
  ID: Integer;
  EditPos, SavePos: TOTAEditPos;
  Pt: TPoint;
  EditorObj: TEditorObject;

  function GetBlankBookmarkID: Integer;
  var
    I: Integer;
  begin
    Result := 1;
    for I := 1 to 10 do
      if EditView.BookmarkPos[I mod 10].Line = 0 then
      begin
        Result := I mod 10;
        Exit;
      end;
  end;

  function FindBookmark(Row: Integer): Integer;
  var
    I: Integer;
  begin
    Result:= -1;
    for I := 0 to 9 do
      if EditView.BookmarkPos[I].Line = Row then
      begin
        Result := I;
        Exit;
      end;
  end;

begin
  EditView := EditControlWrapper.GetEditView(EditControl);
  if Assigned(EditView) then
  begin
    Pt := Mouse.CursorPos;
    Pt := ScreenToClient(Pt);
    
    if FGutterMgr.ShowLineCount and PtInRect(GetLineCountRect, Pt) then
    begin
      OnGotoLine(Self);
    end
    else
    begin
      Row := Pt.y div GetTextHeight;
      EditorObj := EditControlWrapper.GetEditorObject(EditControl);
      if (EditorObj <> nil) and (Row < EditorObj.ViewLineCount) then
        Row := EditorObj.ViewLineNumber[Row]
      else
        Row := EditView.TopRow + Row;
      SavePos := EditView.CursorPos;
      EditPos := EditView.CursorPos;
      EditPos.Line := Row;
      EditView.CursorPos := EditPos;

      ID := FindBookmark(Row);
      if ID = -1 then
        ID := GetBlankBookmarkID;
      EditView.BookmarkToggle(ID);
      EditView.CursorPos := SavePos;
      EditView.Paint;
    end;
  end;
end;

procedure TCnSrcEditorGutter.LanguageChanged(Sender: TObject);
begin
  InitPopupMenu;
end;

//------------------------------------------------------------------------------
// �˵����
//------------------------------------------------------------------------------

procedure TCnSrcEditorGutter.InitPopupMenu;
var
  Wizard: TCnBaseWizard;
  Item: TMenuItem;
begin
  Menu.Items.Clear;
  Wizard := CnWizardMgr.WizardByClassName('TCnBookmarkWizard');
  if Wizard <> nil then
  begin
    Item := TMenuItem.Create(Menu);
    Menu.Items.Add(Item);
    Item.Action := TCnMenuWizard(Wizard).Action;
  end;
  AddMenuItem(Menu.Items, SCnLineNumberClearBookMarks, OnClearBookMarks);
  AddMenuItem(Menu.Items, SCnLineNumberGotoLine, OnGotoLine);
  AddSepMenuItem(Menu.Items);
  AddMenuItem(Menu.Items, SCnEditorEnhanceConfig, OnEnhConfig);
  AddSepMenuItem(Menu.Items);
{$IFDEF BDS}
  FIDELineNumMenu := AddMenuItem(Menu.Items, SCnLineNumberShowIDELineNum, OnShowIDELineNum);
{$ENDIF}
  AddMenuItem(Menu.Items, SCnLineNumberClose, OnLineClose);
end;

procedure TCnSrcEditorGutter.MenuPopup(Sender: TObject);
var
  EditView: IOTAEditView;
  Item, SubItem: TMenuItem;
  I: Integer;
{$IFDEF BDS}
  Options: IOTAEnvironmentOptions;
{$ENDIF}
begin
  EditView := EditControlWrapper.GetEditView(EditControl);
  if Assigned(EditView) then
  begin
    if Menu.Items.Items[0].Tag <> 1 then // �� Tag Ϊ 1 ����ʶ��ǩ�б�˵���
    begin
      Item := TMenuItem.Create(Menu);
      Item.Caption := SCnLineNumberGotoBookMark;
      Item.Tag := 1;
      Menu.Items.Insert(0, Item);
    end
    else
      Item := Menu.Items.Items[0];

    Item.Clear;
    for I := 0 to 9 do
    begin
      SubItem := TMenuItem.Create(Menu);
      SubItem.Caption := Format('Bookmark &%d', [I]);
      SubItem.Tag := I;
      SubItem.OnClick := SubItemClick;
      Item.Add(SubItem);
      SubItem.Enabled := EditView.BookmarkPos[I].Line > 0
    end;
  end;

{$IFDEF BDS}
  Options := CnOtaGetEnvironmentOptions;
  if Options <> nil then
  begin
    FIDELineNumMenu.Checked := Options.GetOptionValue(csIDEShowLineNumbers);
    FIDELineNumMenu.Visible := True;
  end
  else
    FIDELineNumMenu.Visible := False;
{$ENDIF}
end;

procedure TCnSrcEditorGutter.OnClearBookMarks(Sender: TObject);
var
  EditView: IOTAEditView;
  EditPos, SavePos: TOTAEditPos;
  I: Integer;
begin
  EditView := EditControlWrapper.GetEditView(EditControl);
  if Assigned(EditView) then
  begin
    SavePos := EditView.CursorPos;
    for I := 0 to 9 do
    begin
      if EditView.BookmarkPos[I].Line > 0 then
      begin
        EditPos := EditView.CursorPos;
        EditPos.Line := EditView.BookmarkPos[I].Line;
        EditView.CursorPos := EditPos;
        EditView.BookmarkToggle(I);
      end;
    end;
    EditView.CursorPos := SavePos;
    EditView.Paint;
  end;
end;

procedure TCnSrcEditorGutter.OnEnhConfig(Sender: TObject);
begin
  FGutterMgr.DoEnhConfig;
end;

procedure TCnSrcEditorGutter.OnGotoLine(Sender: TObject);
var
  EditView: IOTAEditView;
begin
  EditView := EditControlWrapper.GetEditView(EditControl);
  if Assigned(EditView) then
  begin
    EditView.Position.GotoLine(0);
    EditView.Paint;
  end;
end;

{$IFDEF BDS}
procedure TCnSrcEditorGutter.OnShowIDELineNum(Sender: TObject);
var
  AShow: Boolean;
  Options: IOTAEnvironmentOptions;
  i: Integer;
begin
  Options := CnOtaGetEnvironmentOptions;
  if Options <> nil then
  begin
    AShow := Options.GetOptionValue(csIDEShowLineNumbers);
    Options.SetOptionValue(csIDEShowLineNumbers, not AShow);
    for i := 0 to EditControlWrapper.EditorCount - 1 do
      EditControlWrapper.Editors[i].IDEShowLineNumberChanged;
  end;
end;
{$ENDIF}

procedure TCnSrcEditorGutter.OnLineClose(Sender: TObject);
begin
  FGutterMgr.DoLineClose;
end;

procedure TCnSrcEditorGutter.SubItemClick(Sender: TObject);
var
  EditView: IOTAEditView;
  ID: Integer;
  EditPos: TOTAEditPos;
begin
  EditView := EditControlWrapper.GetEditView(EditControl);
  if Assigned(EditView) then
  begin
    ID := (Sender as TComponent).Tag;
    if ID in [0..9] then
    begin
      EditView.BookmarkGoto(ID);
      EditPos.Line := EditView.BookmarkPos[ID].Line;
      if EditPos.Line > 0 then
      begin
        EditPos.Col := 1;
        EditView.CursorPos := EditPos;
        EditView.MoveViewToCursor;
        EditView.Paint;
        if (EditControl <> nil) and (EditControl is TWinControl) and EditControl.Visible then
          (EditControl as TWinControl).SetFocus;
      end;
    end;
  end;
end;

{ TCnSrcEditorGutterMgr }

constructor TCnSrcEditorGutterMgr.Create;
begin
  inherited;
  FList := TList.Create;
  FFont := TFont.Create;
  FCurrFont := TFont.Create;
  FFont.Name := 'Courier New';
  FFont.Size := 8;
  FFont.Color := clNavy;
  FCurrFont.Name := 'Courier New';
  FCurrFont.Size := 8;
  FCurrFont.Color := clRed;
  
  FActive := True;
  FShowLineNumber := True;
  FShowLineCount := True;
  FMinWidth := 2;
  FFixedWidth := 4;
  FAutoWidth := True;
  
  EditControlWrapper.AddEditControlNotifier(EditControlNotify);
  UpdateGutters;
end;

destructor TCnSrcEditorGutterMgr.Destroy;
var
  i: Integer;
begin
  EditControlWrapper.RemoveEditControlNotifier(EditControlNotify);
  for i := FList.Count - 1 downto 0 do
    TCnSrcEditorGutter(FList[i]).Free;
  FList.Free;
  FFont.Free;
  FCurrFont.Free;
  inherited;
end;

function TCnSrcEditorGutterMgr.CanShowGutter: Boolean;
begin
  Result := FActive and FShowLineNumber;
end;

procedure TCnSrcEditorGutterMgr.DoLineClose;
begin
  ShowLineNumber := False;
end;

procedure TCnSrcEditorGutterMgr.DoEnhConfig;
begin
  if Assigned(FOnEnhConfig) then
    FOnEnhConfig(Self);
end;

procedure TCnSrcEditorGutterMgr.DoUpdateGutters(EditWindow: TCustomForm;
  EditControl: TControl; Context: Pointer);
var
  Gutter: TCnSrcEditorGutter;
begin
  if (EditWindow <> nil) and (EditControl <> nil) then
  begin
    Gutter := TCnSrcEditorGutter(EditWindow.FindComponent(SCnSrcEditorGutter));
    if CanShowGutter then
    begin
      if Gutter = nil then
      begin
        Gutter := TCnSrcEditorGutter.Create(EditWindow);
        Gutter.Name := SCnSrcEditorGutter;
        Gutter.EditControl := EditControl;
        Gutter.EditWindow := EditWindow;
        Gutter.FGutterMgr := Self;
        Gutter.Parent := EditControl.Parent;
        FList.Add(Gutter);
      end;

      Gutter.Font := Font;
      Gutter.FActive := True;
      Gutter.UpdateStatus;
    end
    else if Gutter <> nil then
    begin
      Gutter.FActive := False;
      Gutter.Visible := False;
    end;
  end;
end;

procedure TCnSrcEditorGutterMgr.EditControlNotify(EditControl: TControl;
  EditWindow: TCustomForm; Operation: TOperation);
begin
  UpdateGutters;
end;

procedure TCnSrcEditorGutterMgr.UpdateGutters;
var
  i: Integer;
begin
  EnumEditControl(DoUpdateGutters, nil);
  for i := 0 to Count - 1 do
    Gutters[i].UpdateStatus;
end;

//------------------------------------------------------------------------------
// �������
//------------------------------------------------------------------------------

procedure TCnSrcEditorGutterMgr.LanguageChanged(Sender: TObject);
var
  i: Integer;
begin
  for i := 0 to Count - 1 do
    Gutters[i].LanguageChanged(Sender);
end;

procedure TCnSrcEditorGutterMgr.LoadSettings(Ini: TCustomIniFile);
begin
  with TCnIniFile.Create(Ini) do
  try
    FShowLineNumber := ReadBool(csGutter, csShowLineNumber, csShowLineNumberDef);
    FShowLineCount := ReadBool(csGutter, csShowLineCount, True);
    FFont := ReadFont(csGutter, csFont, FFont);
    FCurrFont := ReadFont(csGutter, csCurrFont, FCurrFont);
    FAutoWidth := ReadBool(csGutter, csAutoWidth, FAutoWidth);
    MinWidth := ReadInteger(csGutter, csMinWidth, FMinWidth);
    FixedWidth := ReadInteger(csGutter, csFixedWidth, FFixedWidth);
    UpdateGutters;
  finally
    Free;
  end;
end;

procedure TCnSrcEditorGutterMgr.SaveSettings(Ini: TCustomIniFile);
begin
  with TCnIniFile.Create(Ini) do
  try
    WriteBool(csGutter, csShowLineNumber, FShowLineNumber);
    WriteBool(csGutter, csShowLineCount, FShowLineCount);
    WriteFont(csGutter, csFont, FFont);
    WriteFont(csGutter, csCurrFont, FCurrFont);
    WriteBool(csGutter, csAutoWidth, FAutoWidth);
    WriteInteger(csGutter, csMinWidth, FMinWidth);
    WriteInteger(csGutter, csFixedWidth, FFixedWidth);
  finally
    Free;
  end;
end;

//------------------------------------------------------------------------------
// ���Զ�д
//------------------------------------------------------------------------------

function TCnSrcEditorGutterMgr.GetCount: Integer;
begin
  Result := FList.Count;
end;

function TCnSrcEditorGutterMgr.GetGutters(Index: Integer): TCnSrcEditorGutter;
begin
  Result := TCnSrcEditorGutter(FList[Index]);
end;

procedure TCnSrcEditorGutterMgr.SetFont(const Value: TFont);
begin
  FFont.Assign(Value);
  UpdateGutters;
end;

procedure TCnSrcEditorGutterMgr.SetCurrFont(const Value: TFont);
begin
  FCurrFont.Assign(Value);
  UpdateGutters;
end;

procedure TCnSrcEditorGutterMgr.SetShowLineNumber(const Value: Boolean);
begin
  if Value <> FShowLineNumber then
  begin
    FShowLineNumber := Value;
    UpdateGutters;
  end;
end;

procedure TCnSrcEditorGutterMgr.SetActive(const Value: Boolean);
begin
  if FActive <> Value then
  begin
    FActive := Value;
    UpdateGutters;
  end;
end;

procedure TCnSrcEditorGutterMgr.SetFixedWidth(const Value: TCnGutterWidth);
begin
  FFixedWidth := TrimInt(Value, Low(TCnGutterWidth), High(TCnGutterWidth));
end;

procedure TCnSrcEditorGutterMgr.SetMinWidth(const Value: TCnGutterWidth);
begin
  FMinWidth := TrimInt(Value, Low(TCnGutterWidth), High(TCnGutterWidth));
end;

end.
