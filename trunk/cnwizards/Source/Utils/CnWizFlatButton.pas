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

unit CnWizFlatButton;
{* |<PRE>
================================================================================
* ������ƣ�CnPack IDE ר�Ұ�
* ��Ԫ���ƣ�IDE ��ع�����Ԫ
* ��Ԫ���ߣ��ܾ��� (zjy@cnpack.org)
* ��    ע���������߰�ť���嵥Ԫ
* ����ƽ̨��PWin2000Pro + Delphi 5.01
* ���ݲ��ԣ�PWin9X/2000/XP + Delphi 5/6/7 + C++Builder 5/6
* �� �� �����õ�Ԫ�е��ַ��������ϱ��ػ�����ʽ
* ��Ԫ��ʶ��$Id: CnWizFlatButton.pas 763 2011-02-07 14:18:23Z liuxiao@cnpack.org $
* �޸ļ�¼��2005.01.06 V1.0
*               ������Ԫ��ʵ�ֹ���
================================================================================
|</PRE>}

interface

{$I CnWizards.inc}

uses
  Windows, Messages, SysUtils, Graphics, Classes, Controls, ExtCtrls, Forms,
  Menus, CnPopupMenu;

type
  TFlatButtonState = (bsHide, bsNormal, bsEnter, bsDropdown);

  TCnWizFlatButton = class(TCustomControl)
  private
    FDropdownMenu: TPopupMenu;
    FImage: TGraphic;
    FIsMouseEnter: Boolean;
    FIsDropdown: Boolean;
    FTimer: TTimer;
    procedure SetImage(Value: TGraphic);
    procedure ImageChange(Sender: TObject);
    procedure OnTimer(Sender: TObject);
    procedure SetIsDropdown(const Value: Boolean);
    procedure SetIsMouseEnter(const Value: Boolean);
  protected
    procedure CreateParams(var Params: TCreateParams); override;
    procedure CMMouseEnter(var Message: TMessage); message CM_MOUSEENTER;
    procedure CMMouseLeave(var Message: TMessage); message CM_MOUSELEAVE;
    procedure Click; override;
    procedure Paint; override;
    procedure MouseUp(Button: TMouseButton; Shift: TShiftState;
      X, Y: Integer); override;
    procedure UpdateSize;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;

    function GetState: TFlatButtonState;
    {* ���ص�ǰ��ť��״̬ }
    procedure Dropdown;
    {* �������˵� }

    property DropdownMenu: TPopupMenu read FDropdownMenu write FDropdownMenu;
    {* �����˵�����Ҫ���û��Լ����������� }
    property Image: TGraphic read FImage write SetImage;
    {* ��ťͼ�꣬��Ҫ���û��Լ����������� }
    property IsDropdown: Boolean read FIsDropdown write SetIsDropdown;
    property IsMouseEnter: Boolean read FIsMouseEnter write SetIsMouseEnter;
  end;

implementation

{$IFDEF Debug}
uses
  CnDebug;
{$ENDIF}

const
  csImageWidth = 16;
  csImageHeight = 16;
  csBorderWidths: array[TFlatButtonState] of Integer = (2, 2, 3, 3);
  csArrowWidths: array[TFlatButtonState] of Integer = (0, 0, 8, 8);
  csBkColors: array[TFlatButtonState] of TColor =
    (clWhite, clWhite, $00D2BDB6, $00D1D8DB);
  csBorderColors: array[TFlatButtonState] of TColor =
    ($006A240A, $006A240A, $006A240A, $666666);
  csArrowColor = clBlack;

{ TCnWizFlatButton }

constructor TCnWizFlatButton.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  Visible := False;
  ShowHint := True;
  FTimer := TTimer.Create(Self);
  FTimer.Enabled := False;
  FTimer.Interval := 500;
  FTimer.OnTimer := OnTimer;
  UpdateSize;
end;

destructor TCnWizFlatButton.Destroy;
begin
  inherited;
end;

procedure TCnWizFlatButton.CreateParams(var Params: TCreateParams);
begin
  inherited;
  Params.ExStyle := Params.ExStyle or WS_EX_TOPMOST;
end;

function TCnWizFlatButton.GetState: TFlatButtonState;
begin
  if not Visible then
    Result := bsHide
  else if IsDropdown then
    Result := bsDropdown
  else if IsMouseEnter then
    Result := bsEnter
  else
    Result := bsNormal;
end;

//------------------------------------------------------------------------------
// ��Ϣ���¼�����
//------------------------------------------------------------------------------

procedure TCnWizFlatButton.Click;
begin
  inherited;
  Dropdown;
end;

procedure TCnWizFlatButton.MouseUp(Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
  if Button = mbRight then
    Dropdown;
end;

procedure TCnWizFlatButton.CMMouseEnter(var Message: TMessage);
begin
  IsMouseEnter := True;
end;

procedure TCnWizFlatButton.CMMouseLeave(var Message: TMessage);
begin
  IsMouseEnter := False;
end;

procedure TCnWizFlatButton.Paint;
var
  X, Y: Integer;
  State: TFlatButtonState;
begin
  State := GetState;
  with Canvas do
  begin
    Brush.Color := csBkColors[State];
    FillRect(ClientRect);
    Brush.Color := csBorderColors[State];
    FrameRect(ClientRect);
    if (FImage <> nil) and not FImage.Empty then
      Draw(csBorderWidths[State], csBorderWidths[State], FImage);

    if csArrowWidths[State] > 0 then
    begin
      Pen.Color := csArrowColor;
      X := Width - csBorderWidths[State] - csArrowWidths[State] div 2;
      Y := Height div 2;
      MoveTo(X - 2, Y - 1);
      LineTo(X + 3, Y - 1);
      MoveTo(X - 1, Y);
      LineTo(X + 2, Y);
      Pixels[X, Y + 1] := csArrowColor;
    end;
  end;
end;

//------------------------------------------------------------------------------
// �ؼ�����
//------------------------------------------------------------------------------

procedure TCnWizFlatButton.Dropdown;
var
  P: TPoint;
begin
  if not IsDropdown and Assigned(FDropdownMenu) then
  begin
    P := ClientToScreen(Point(0, Height));
    IsDropdown := True;
    FDropdownMenu.Popup(P.x, P.y);
    IsDropdown := False;
  end;
end;

//------------------------------------------------------------------------------
// ״̬����
//------------------------------------------------------------------------------

procedure TCnWizFlatButton.UpdateSize;
var
  State: TFlatButtonState;
begin
  State := GetState;
  Width := csBorderWidths[State] * 2 + csArrowWidths[State] + csImageWidth;
  Height := csBorderWidths[State] * 2 + csImageHeight;
  if Visible then
    Repaint;
end;

procedure TCnWizFlatButton.ImageChange(Sender: TObject);
begin
  UpdateSize;
end;

procedure TCnWizFlatButton.OnTimer(Sender: TObject);
var
  P: TPoint;
begin
  if IsMouseEnter and GetCursorPos(P) then
  begin
    if not PtInRect(ClientRect, ScreenToClient(P)) then
    begin
      IsMouseEnter := False;
    end;
  end;
end;

//------------------------------------------------------------------------------
// ���Զ�д
//------------------------------------------------------------------------------

procedure TCnWizFlatButton.SetImage(Value: TGraphic);
begin
  if FImage <> Value then
  begin
    FImage := Value;
    if FImage <> nil then
      FImage.OnChange := ImageChange;
    UpdateSize;
  end;
end;

procedure TCnWizFlatButton.SetIsDropdown(const Value: Boolean);
begin
  if FIsDropdown <> Value then
  begin
    FIsDropdown := Value;
    UpdateSize;
  end;
end;

procedure TCnWizFlatButton.SetIsMouseEnter(const Value: Boolean);
begin
  if FIsMouseEnter <> Value then
  begin
    FIsMouseEnter := Value;
    UpdateSize;
    FTimer.Enabled := IsMouseEnter;
  end;
end;

end.
