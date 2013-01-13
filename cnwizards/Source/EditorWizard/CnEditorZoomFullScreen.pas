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

unit CnEditorZoomFullScreen;
{* |<PRE>
================================================================================
* ������ƣ�CnPack IDE ר�Ұ�
* ��Ԫ���ƣ����봰��ȫ��Ļ�л����ߵ�Ԫ
* ��Ԫ���ߣ��ܾ��� (zjy@cnpack.org)
* ��    ע��
* ����ƽ̨��PWin2000Pro + Delphi 5.01
* ���ݲ��ԣ�PWin9X/2000/XP + Delphi 5/6/7 + C++Builder 5/6
* �� �� �����ô����е��ַ��������ϱ��ػ�����ʽ
* ��Ԫ��ʶ��$Id: CnEditorZoomFullScreen.pas 763 2011-02-07 14:18:23Z liuxiao@cnpack.org $
* �޸ļ�¼��2008.05.08 V1.3
*               ���Ӷ� BDS ��֧��
*           2005.02.22 V1.2
*               ���Ӵ��봰�����ʱ�Զ����������ڵĹ���
*           2003.03.06 V1.1
*               IDE ��������봰�����
*           2002.12.11 V1.0
*               ������Ԫ��ʵ�ֹ���
================================================================================
|</PRE>}

interface

{$I CnWizards.inc}

{$IFDEF CNWIZARDS_CNEDITORWIZARD}

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, ExtCtrls, IniFiles, ToolsAPI, CnWizIdeUtils, CnConsts, CnCommon,
  CnWizConsts, CnEditorWizard, CnWizUtils, CnWizMultiLang;

type
  TCnEditorZoomFullScreenForm = class(TCnTranslateForm)
    GroupBox1: TGroupBox;
    cbAutoZoom: TCheckBox;
    btnOK: TButton;
    btnCancel: TButton;
    chkAutoHideMainForm: TCheckBox;
    chkRestoreNormal: TCheckBox;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

//==============================================================================
// ���봰��ȫ��Ļ�л�������
//==============================================================================

{ TCnEditorZoomFullScreen }

  TCnEditorZoomFullScreen = class(TCnBaseEditorTool)
  private
    // Save main IDE top
    MainIDETop: Integer;
    FTimer: TTimer;
    FUpdating: Boolean;
    FAutoZoom: Boolean;
    FAutoHideMainForm: Boolean;
    FLastAutoHideMainForm: Boolean;
    FRestoreNormal: Boolean;
    FStayedTop: Boolean;
    procedure AdjustEditorForm(FullScreen: Boolean);
    procedure SetAutoHideMainForm(const Value: Boolean);
    procedure UpdateAutoHide;
    procedure UpdateMainFormPos(AShow: Boolean);
    function CheckMousePos(var AMouseEnter: Boolean): Boolean;
    procedure OnTimer(Sender: TObject);
    function GetFullScreen: Boolean;
    procedure SetFullScreen(const Value: Boolean);
  protected
    function GetHasConfig: Boolean; override;
    function NeedAutoHide: Boolean;
  public
    constructor Create(AOwner: TCnEditorWizard); override;
    destructor Destroy; override;
    function GetState: TWizardState; override;
    function GetCaption: string; override;
    function GetHint: string; override;
    function GetDefShortCut: TShortCut; override;
    procedure Loaded; override;
    procedure Execute; override;
    procedure GetEditorInfo(var Name, Author, Email: string); override;
    procedure Config; override;

    property FullScreen: Boolean read GetFullScreen write SetFullScreen;
  published
    property AutoZoom: Boolean read FAutoZoom write FAutoZoom default False;
    property AutoHideMainForm: Boolean read FAutoHideMainForm write SetAutoHideMainForm default True;
    property RestoreNormal: Boolean read FRestoreNormal write FRestoreNormal default False;
  end;

{$ENDIF CNWIZARDS_CNEDITORWIZARD}

implementation

{$IFDEF CNWIZARDS_CNEDITORWIZARD}

{$IFDEF DEBUG}
uses
  CnDebug;
{$ENDIF}

{$R *.DFM}

//==============================================================================
// ���봰��ȫ��Ļ�л�������
//==============================================================================

{ TCnEditorZoomFullScreen }

const
  csZoomFullScreen = 'ZoomFullScreen';
  csBarWidth = 4;

constructor TCnEditorZoomFullScreen.Create(AOwner: TCnEditorWizard);
begin
  inherited;
  FAutoZoom := False;
  FRestoreNormal := False;
  FUpdating := False;
  FLastAutoHideMainForm := False;
  FTimer := TTimer.Create(nil);
  FTimer.Enabled := False;
  FTimer.Interval := 200;
  FTimer.OnTimer := OnTimer;
  // �ֹ������ڲ��ĸı�
  AutoHideMainForm := True;
end;

destructor TCnEditorZoomFullScreen.Destroy;
begin
  FTimer.Free;
  inherited;
end;

procedure TCnEditorZoomFullScreen.AdjustEditorForm(FullScreen: Boolean);
var
  EditorForm, IdeMainForm: TCustomForm;
  IdeBottom: Integer;
  i: Integer;
begin
  EditorForm := nil;
  for i := 0 to Screen.CustomFormCount - 1 do
  begin
    if (Screen.CustomForms[i].Parent = nil) and IsIdeEditorForm(Screen.CustomForms[i]) then
    begin
      EditorForm := Screen.CustomForms[i];
      if EditorForm.WindowState = wsNormal then // δ���ʱֱ�����
        EditorForm.WindowState := wsMaximized
      else
      begin
        if FullScreen then              // ȫ����ʽ��ֱ������Ϊ��������
          with GetWorkRect do
            SetWindowPos(EditorForm.Handle, HWND_TOP, Left, Top, Right - Left,
              Bottom - Top, SWP_SHOWWINDOW)
        else
        begin
          if RestoreNormal then
            EditorForm.WindowState := wsNormal
          else
          begin
            IdeMainForm := GetIdeMainForm;
            if Assigned(IdeMainForm) then     // �ҵ� IDE ������ʱ�������������·�
            begin
              IdeBottom := IdeMainForm.Top + IdeMainForm.Height;
              with GetWorkRect do
                SetWindowPos(EditorForm.Handle, HWND_TOP, Left, IdeBottom,
                Right - Left, Bottom - IdeBottom, SWP_SHOWWINDOW);
            end
            else
            begin                         // û�취��ֻ���ȳ��滯�����
              EditorForm.WindowState := wsNormal;
              EditorForm.WindowState := wsMaximized;
            end;
          end;
        end;
      end;
      Exit;
    end;
  end;

  if EditorForm = nil then
    ErrorDlg(SCnEditorZoomFullScreenNoEditor);
end;

procedure TCnEditorZoomFullScreen.Execute;
begin
  FullScreen := not FullScreen;
  UpdateAutoHide;
  AdjustEditorForm(FullScreen);
end;

procedure TCnEditorZoomFullScreen.Loaded;
begin
  if Active and FAutoZoom then
  begin
    AdjustEditorForm(FullScreen);
  end;
end;

function TCnEditorZoomFullScreen.GetFullScreen: Boolean;
var
  Options: IOTAEnvironmentOptions;
begin
  Options := CnOtaGetEnvironmentOptions;
  if Assigned(Options) then
    Result := Options.GetOptionValue(csZoomFullScreen)
  else
    Result := False;
end;

procedure TCnEditorZoomFullScreen.SetFullScreen(const Value: Boolean);
var
  Options: IOTAEnvironmentOptions;
begin
  Options := CnOtaGetEnvironmentOptions;
  if Assigned(Options) then
    Options.SetOptionValue(csZoomFullScreen, Value);
end;

function TCnEditorZoomFullScreen.GetCaption: string;
begin
  Result := SCnEditorZoomFullScreenMenuCaption;
end;

function TCnEditorZoomFullScreen.GetDefShortCut: TShortCut;
begin
  Result := 0;
end;

function TCnEditorZoomFullScreen.GetHint: string;
begin
  Result := SCnEditorZoomFullScreenMenuHint;
end;

procedure TCnEditorZoomFullScreen.GetEditorInfo(var Name, Author, Email: string);
begin
  Name := SCnEditorZoomFullScreen;
  Author := SCnPack_Zjy;
  Email := SCnPack_ZjyEmail;
end;

function TCnEditorZoomFullScreen.GetState: TWizardState;
begin
  Result := [];

  if Active and (wsEnabled in inherited GetState) then
    Include(Result, wsEnabled);

  if FullScreen then
    Include(Result, wsChecked);
end;

//------------------------------------------------------------------------------
// �������Զ�����
//------------------------------------------------------------------------------

function TCnEditorZoomFullScreen.NeedAutoHide: Boolean;
var
  IdeMainForm: TCustomForm;

  function IsEditorMaximized: Boolean;
  var
    i: Integer;
  begin
    Result := False;
    for i := 0 to Screen.CustomFormCount - 1 do
      if IsIdeEditorForm(Screen.CustomForms[i]) then
      begin
        Result := (Screen.CustomForms[i].WindowState = wsMaximized)
          and (Screen.CustomForms[i].Top <= 0);
        // ��󻯵��жϣ�������WindowState��ҲҪ����Top��λ���С�
        if Result then // ֻҪ�ҵ���һ����󻯵� Edit ���ھ��˳�
          Exit;
      end;
  end;

begin
  IdeMainForm := GetIdeMainForm;
  // ���봰��ȫ�������������û�����ʱ���Զ�����
  Result := Active and FAutoHideMainForm and Assigned(IdeMainForm) and
    (IdeMainForm.WindowState = wsNormal) and FullScreen and IsEditorMaximized;
end;

procedure TCnEditorZoomFullScreen.SetAutoHideMainForm(
  const Value: Boolean);
begin
  FAutoHideMainForm := Value;
  FTimer.Enabled := Value;
  UpdateAutoHide;
end;

procedure TCnEditorZoomFullScreen.OnTimer(Sender: TObject);
begin
  UpdateAutoHide;
end;

function TCnEditorZoomFullScreen.CheckMousePos(var AMouseEnter: Boolean):
  Boolean;
var
  MousePos: TPoint;
  IdeMainForm: TCustomForm;
begin
  Result := False;
  if GetCursorPos(MousePos) then
  begin
    IdeMainForm := GetIdeMainForm;
    if Assigned(IdeMainForm) then
    begin
      with IdeMainForm do
        AMouseEnter := PtInRect(Bounds(Left, Top - MainIDETop, Width, Height + MainIDETop), MousePos) or
          (Top = -Height) and PtInRect(Bounds(Left, 0, Width, csBarWidth), MousePos);
      Result := GetShiftState * [ssLeft, ssRight, ssMiddle, ssDouble] = [];
{$IFDEF DEBUG}
      if MousePos.Y = 0 then // ������
      begin
        CnDebugger.LogBoolean(AMouseEnter, 'FullScreen: Mouse enter');
        with IdeMainForm do
        begin
          CnDebugger.LogRect(Bounds(Left, Top - MainIDETop, Width, Height + MainIDETop), 'FullScreen Rect1');
          CnDebugger.LogRect(Bounds(Left, 0, Width, csBarWidth), 'FullScreen Rect2');
        end;
      end;
{$ENDIF}
    end;
  end;
end;

procedure TCnEditorZoomFullScreen.UpdateAutoHide;
var
  MouseEnter: Boolean;
  IdeMainForm: TCustomForm;
begin
  IdeMainForm := GetIdeMainForm;
  if NeedAutoHide then
  begin
    if not FLastAutoHideMainForm then
    begin
      FLastAutoHideMainForm := True;
      UpdateMainFormPos(False);
      if Assigned(IdeMainForm) then
      begin
        StayOnTop(IdeMainForm.Handle, True);
        FStayedTop := True;
      end;
    end
    else
    begin
      if CheckMousePos(MouseEnter) then
      begin
        if not Application.Active or not MouseEnter then
          UpdateMainFormPos(False)
        else if not ScreenHasModalForm then
          UpdateMainFormPos(True);
      end;
    end;
  end
  else if FLastAutoHideMainForm then
  begin
    FLastAutoHideMainForm := False;
    UpdateMainFormPos(True);
    if Assigned(IdeMainForm) then
    begin
      StayOnTop(IdeMainForm.Handle, False);
      FStayedTop := False;
    end;
  end;
end;

procedure TCnEditorZoomFullScreen.UpdateMainFormPos(AShow: Boolean);
var
  WorkRect: TRect;
  IdeMainForm: TCustomForm;
begin
  if FUpdating then
    Exit;

  FUpdating := True;
  try
    IdeMainForm := GetIdeMainForm;
    if Assigned(IdeMainForm) then
    begin
      if IdeMainForm.WindowState = wsNormal then
      begin
        WorkRect := GetWorkRect;
        if IdeMainForm.Left <> WorkRect.Left then
          IdeMainForm.Left := WorkRect.Left;
        if IdeMainForm.Width <> WorkRect.Right - WorkRect.Left then
          IdeMainForm.Width := WorkRect.Right - WorkRect.Left;

        if AShow then
        begin
          if IdeMainForm.Top <> 0 then
          begin
            // ������������ԭ���� MainIDETop С��0������������������
            if MainIDETop < 0 then
              MainIDETop := 0;
              
            IdeMainForm.Top := MainIDETop;
            IdeMainForm.BringToFront;
{$IFDEF DEBUG}
            CnDebugger.LogMsg('FullScreen. Main IDE Popup.');
{$ENDIF}
            if not FStayedTop then
            begin
              StayOnTop(IdeMainForm.Handle, True);
{$IFDEF BDS}
              (IdeMainForm as TForm).FormStyle := fsStayOnTop;
{$ENDIF}

{$IFDEF DEBUG}
              CnDebugger.LogMsg('FullScreen. Main IDE SetWindowPos to Top.');
{$ENDIF}
              FStayedTop := True;
            end;
          end;
        end
        else
        begin
          FStayedTop := False;
{$IFDEF BDS}
          (IdeMainForm as TForm).FormStyle := fsNormal;
{$ENDIF}
          if IdeMainForm.Top <> -IdeMainForm.Height then
          begin
            MainIDETop := IdeMainForm.Top;
            IdeMainForm.Top := -IdeMainForm.Height;
          end;
        end;
      end;
    end;
  finally
    FUpdating := False;
  end;
end;

//------------------------------------------------------------------------------
// �������
//------------------------------------------------------------------------------

procedure TCnEditorZoomFullScreen.Config;
begin
  with TCnEditorZoomFullScreenForm.Create(nil) do
  try
    cbAutoZoom.Checked := FAutoZoom;
    chkAutoHideMainForm.Checked := FAutoHideMainForm;
    chkRestoreNormal.Checked := FRestoreNormal;

    if ShowModal = mrOk then
    begin
      AutoZoom := cbAutoZoom.Checked;
      AutoHideMainForm := chkAutoHideMainForm.Checked;
      RestoreNormal := chkRestoreNormal.Checked;
    end;
  finally
    Free;
  end;
end;

function TCnEditorZoomFullScreen.GetHasConfig: Boolean;
begin
  Result := True;
end;

initialization
  RegisterCnEditor(TCnEditorZoomFullScreen); // ע��ר��

{$ENDIF CNWIZARDS_CNEDITORWIZARD}
end.
