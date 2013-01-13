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

unit CnTestPaintLineWizard;
{ |<PRE>
================================================================================
* ������ƣ�CnPack IDE ר�Ұ���������
* ��Ԫ���ƣ�PaintLine ��װ����������Ԫ
* ��Ԫ���ߣ�CnPack ������
* ��    ע���õ�Ԫ�� CnEditControlWrapper �� PaintLine ֪ͨ����װ
            ���в��ԣ�ֻ�轫�˵�Ԫ����ר�Ұ�Դ�빤�̺��ر�����ؼ��ɽ��в��ԡ�
* ����ƽ̨��PWin2000Pro + Delphi 5.01
* ���ݲ��ԣ�PWin9X/2000/XP + Delphi 5/6/7 + C++Builder 5/6
* �� �� �����ô����е��ַ����ݲ�֧�ֱ��ػ�����ʽ
* ��Ԫ��ʶ��$Id: CnTestPaintLineWizard.pas 763 2011-02-07 14:18:23Z liuxiao@cnpack.org $
* �޸ļ�¼��2008.06.10 V1.0
*               ������Ԫ
================================================================================
|</PRE>}

interface

{$I CnWizards.inc}

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  ToolsAPI, IniFiles, CnWizClasses, CnWizUtils, CnWizConsts, CnWizIdeUtils,
  CnEditControlWrapper;

type

//==============================================================================
// ���� CnEditControlWrapper �� PaintLine �Ĳ˵�ר��
//==============================================================================

{ TCnTestPaintLineMenuWizard }

  TCnTestPaintLineMenuWizard = class(TCnMenuWizard)
  private
    FTest: Integer;
    FCharSize: TSize;
    FGutterWidth: Integer;
    FAdded: Boolean;

    procedure PaintLine(EditControl: TControl; EditView: IOTAEditView; LineNum: Integer);
    procedure EditorPaintText(EditControl: TControl; ARect: TRect; AText: string;
      AColor, AColorBk, AColorBd: TColor; ABold, AItalic: Boolean);
  protected
    function GetHasConfig: Boolean; override;
  public
    destructor Destroy; override;
    function GetState: TWizardState; override;
    procedure Config; override;
    procedure LoadSettings(Ini: TCustomIniFile); override;
    procedure SaveSettings(Ini: TCustomIniFile); override;
    class procedure GetWizardInfo(var Name, Author, Email, Comment: string); override;
    function GetCaption: string; override;
    function GetHint: string; override;
    function GetDefShortCut: TShortCut; override;
    procedure Execute; override;
  end;

implementation

uses
  CnDebug;

//==============================================================================
// ���� CnEditControlWrapper �� PaintLine �Ĳ˵�ר��
//==============================================================================

{ TCnTestPaintLineMenuWizard }

procedure TCnTestPaintLineMenuWizard.Config;
begin
  ShowMessage('No option for this test case.');
end;

destructor TCnTestPaintLineMenuWizard.Destroy;
begin
  if FAdded then
    EditControlWrapper.RemoveAfterPaintLineNotifier(PaintLine);
  inherited;
end;

type
  TCustomControlAccess = class(TCustomControl);
  
procedure TCnTestPaintLineMenuWizard.EditorPaintText(EditControl: TControl;
  ARect: TRect; AText: string; AColor, AColorBk, AColorBd: TColor; ABold,
  AItalic: Boolean);
var
  SavePenColor, SaveBrushColor, SaveFontColor: TColor;
  SavePenStyle: TPenStyle;
  SaveBrushStyle: TBrushStyle;
  SaveFontStyles: TFontStyles;
  ACanvas: TCanvas;
begin
  ACanvas := EditControlWrapper.GetEditControlCanvas(EditControl);
  with ACanvas do
  begin
    SavePenColor := Pen.Color;
    SavePenStyle := Pen.Style;
    SaveBrushColor := Brush.Color;
    SaveBrushStyle := Brush.Style;
    SaveFontColor := Font.Color;
    SaveFontStyles := Font.Style;

    // Fill Background
    if AColorBk <> clNone then
    begin
      Brush.Color := AColorBk;
      Brush.Style := bsSolid;
      FillRect(ARect);
    end;      

    // Draw Border
    if AColorBd <> clNone then
    begin
      Pen.Color := AColorBd;
      Brush.Style := bsClear;
      Rectangle(ARect);
    end;

    // Draw Text
    Font.Color := AColor;
    Font.Style := [];
    if ABold then
      Font.Style := Font.Style + [fsBold];
    if AItalic then
      Font.Style := Font.Style + [fsItalic];
    Brush.Style := bsClear;
    TextOut(ARect.Left, ARect.Top, AText);

    Pen.Color := SavePenColor;
    Pen.Style := SavePenStyle;
    Brush.Color := SaveBrushColor;
    Brush.Style := SaveBrushStyle;
    Font.Color := SaveFontColor;
    Font.Style := SaveFontStyles;
  end;
end;

procedure TCnTestPaintLineMenuWizard.Execute;
var
  EditView: IOTAEditView;
  I: Integer;
  EditControl: TControl;
begin
  EditView := CnOtaGetTopMostEditView;
  EditControl := EditControlWrapper.GetTopMostEditControl;
  CnDebugger.TracePointer(Pointer(EditView));
  CnDebugger.TracePointer(EditControl);
   
  for I := EditView.TopRow to EditView.BottomRow do
    CnDebugger.TraceFmt('Line %d Elided? %d', [I, Integer(EditControlWrapper.GetLineIsElided(EditControl, I))]);
  FCharSize := EditControlWrapper.GetCharSize;

  if not FAdded then
  begin
    EditControlWrapper.AddAfterPaintLineNotifier(PaintLine);
    FAdded := True;
  end
  else
  begin
    EditControlWrapper.RemoveAfterPaintLineNotifier(PaintLine);
    FAdded := False;
  end;
end;

function TCnTestPaintLineMenuWizard.GetCaption: string;
begin
  Result := 'Test PaintLine';
end;

function TCnTestPaintLineMenuWizard.GetDefShortCut: TShortCut;
begin
  Result := 0;
end;

function TCnTestPaintLineMenuWizard.GetHasConfig: Boolean;
begin
  Result := True;
end;

function TCnTestPaintLineMenuWizard.GetHint: string;
begin
  Result := 'Test Hint';
end;

function TCnTestPaintLineMenuWizard.GetState: TWizardState;
begin
  Result := [wsEnabled];
end;

class procedure TCnTestPaintLineMenuWizard.GetWizardInfo(var Name, Author, Email, Comment: string);
begin
  Name := 'Test PaintLine Menu Wizard';
  Author := 'Liu Xiao';
  Email := 'master@cnpack.org';
  Comment := 'Test for PaintLine';
end;

procedure TCnTestPaintLineMenuWizard.LoadSettings(Ini: TCustomIniFile);
begin

end;

procedure TCnTestPaintLineMenuWizard.PaintLine(EditControl: TControl;
  EditView: IOTAEditView; LineNum: Integer);
var
  ARect: TRect;
  S: string;
  APos: TOTAEditPos;
{$IFDEF BDS}
  P: TPoint;
{$ENDIF}
begin
  FGutterWidth := EditView.Buffer.BufferOptions.LeftGutterWidth;
  Inc(FTest);
  S := 'PaintLine Examples: ' + IntToStr(FTest) + ' ' + IntToStr(LineNum);
  APos.Col := 1;
  APos.Line := LineNum;
{$IFDEF BDS}
  P := EditControlWrapper.GetPointFromEdPos(EditControl, APos);
  CnDebugger.TracePoint(P, '');
  ARect := Bounds(P.X + (APos.Col - 1) * FCharSize.cx,
        (APos.Line - EditView.TopRow) * FCharSize.cy, FCharSize.cx * Length(S),
        FCharSize.cy);
{$ELSE}
  ARect := Bounds(FGutterWidth + (APos.Col - EditView.LeftColumn) * FCharSize.cx,
        (APos.Line - EditView.TopRow) * FCharSize.cy, FCharSize.cx * Length(S),
        FCharSize.cy);
{$ENDIF}
  CnDebugger.TraceRect(ARect, Format('%d line: ', [LineNum]));
  EditorPaintText(EditControl, ARect, S, clGreen, clYellow, clNone, True, False);
end;

procedure TCnTestPaintLineMenuWizard.SaveSettings(Ini: TCustomIniFile);
begin

end;

initialization
  RegisterCnWizard(TCnTestPaintLineMenuWizard); // ע��˲���ר��

end.
