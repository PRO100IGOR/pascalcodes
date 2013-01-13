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

unit CnHighlightLineFrm;
{ |<PRE>
================================================================================
* ������ƣ�CnPack IDE ר�Ұ�
* ��Ԫ���ƣ�����༭�������������ô���
* ��Ԫ���ߣ���Х (liuxiao@cnpack.org)
* ��    ע��
* ����ƽ̨��PWin2000Pro + Delphi 5.01
* ���ݲ��ԣ�PWin9X/2000/XP + Delphi 5/6/7 + C++Builder 5/6
* �� �� �����õ�Ԫ�е��ַ���֧�ֱ��ػ�����ʽ
* ��Ԫ��ʶ��$Id: CnHighlightLineFrm.pas 763 2011-02-07 14:18:23Z liuxiao@cnpack.org $
* �޸ļ�¼��2008.07.02
*               ������Ԫ
================================================================================
|</PRE>}

interface

{$I CnWizards.inc}

{$IFDEF CNWIZARDS_CNSOURCEHIGHLIGHT}

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, CnSpin, CnLangMgr, CnWizMultiLang;

type
  TCnHighlightLineForm = class(TCnTranslateForm)
    GroupBox1: TGroupBox;
    lblLineWidth: TLabel;
    seLineWidth: TCnSpinEdit;
    btnOK: TButton;
    btnCancel: TButton;
    btnHelp: TButton;
    lblLineType: TLabel;
    cbbLineType: TComboBox;
    chkLineEnd: TCheckBox;
    chkLineClass: TCheckBox;
    chkLineHori: TCheckBox;
    chkLineHoriDot: TCheckBox;
    procedure cbbLineTypeDrawItem(Control: TWinControl; Index: Integer;
      Rect: TRect; State: TOwnerDrawState);
    procedure chkLineHoriClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure btnHelpClick(Sender: TObject);
  private
    { Private declarations }
  protected
    function GetHelpTopic: string; override;
  public
    { Public declarations }
  end;

{$ENDIF CNWIZARDS_CNSOURCEHIGHLIGHT}

implementation

{$IFDEF CNWIZARDS_CNSOURCEHIGHLIGHT}

uses
  CnSourceHighlight;

{$R *.DFM}

procedure TCnHighlightLineForm.cbbLineTypeDrawItem(Control: TWinControl;
  Index: Integer; Rect: TRect; State: TOwnerDrawState);
var
  OldStyle: TPenStyle;
  OldBrushColor, OldPenColor: TColor;
begin
  OldStyle := cbbLineType.Canvas.Pen.Style;
  OldBrushColor := cbbLineType.Canvas.Brush.Color;
  OldPenColor := cbbLineType.Canvas.Pen.Color;

  if odSelected in State then
  begin
    cbbLineType.Canvas.Brush.Color := clHighlight;
    cbbLineType.Canvas.Pen.Color := clWhite;
  end
  else
  begin
    cbbLineType.Canvas.Brush.Color := clWhite;
    cbbLineType.Canvas.Pen.Color := clBlack;
  end;

  cbbLineType.Canvas.FillRect(Rect);

  HighlightCanvasLine(cbbLineType.Canvas, Rect.Left + 2, (Rect.Top + Rect.Bottom) div 2,
    Rect.Right - 2, (Rect.Top + Rect.Bottom) div 2, TCnLineStyle(Index));

  cbbLineType.Canvas.Pen.Style := OldStyle;
  cbbLineType.Canvas.Pen.Color := OldPenColor;
  cbbLineType.Canvas.Brush.Color := OldBrushColor;
end;

procedure TCnHighlightLineForm.chkLineHoriClick(Sender: TObject);
begin
  chkLineHoriDot.Enabled := chkLineHori.Checked;
end;

procedure TCnHighlightLineForm.FormCreate(Sender: TObject);
begin
  chkLineHoriDot.Enabled := chkLineHori.Checked;
end;

function TCnHighlightLineForm.GetHelpTopic: string;
begin
  Result := 'CnSourceHighlight';
end;

procedure TCnHighlightLineForm.btnHelpClick(Sender: TObject);
begin
  ShowFormHelp;
end;

{$ENDIF CNWIZARDS_CNSOURCEHIGHLIGHT}
end.
