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

unit CnPas2HtmlConfigFrm;
{* |<PRE>
================================================================================
* ������ƣ�CnPack IDE ר�Ұ�
* ��Ԫ���ƣ����뵽 HTML ת�����ר�����õ�Ԫ
* ��Ԫ���ߣ���Х(LiuXiao) liuxiao@cnpack.org
* ��    ע��CnPas2Html ר�����õ�Ԫ
* ����ƽ̨��PWin98SE + Delphi 6
* ���ݲ��ԣ����ޣ�PWin9X/2000/XP + Delphi 5/6/7 + C++Builder 5/6��
* �� �� �����ô����е��ַ��������ϱ��ػ�����ʽ
* ��Ԫ��ʶ��$Id: CnPas2HtmlConfigFrm.pas 763 2011-02-07 14:18:23Z liuxiao@cnpack.org $
* �޸ļ�¼��2004.06.29 V1.3
*               ���볢�Դ�ע���������IDE�������õĹ��ܡ�
*           2003.03.09 V1.2
*               �������д��ļ�ת���ȼ���
*           2003.02.28 V1.1
*               �������崦��
*           2003.02.23 V1.0
*               ������Ԫ��ʵ�ֹ���
================================================================================
|</PRE>}

interface

{$I CnWizards.inc}

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Registry,
  Dialogs, StdCtrls, ComCtrls, ActnList, ExtCtrls, CnWizUtils, CnWizMultiLang,
  CnWizIdeUtils;

type

{ TCnPas2HtmlConfigForm }

  TCnPas2HtmlConfigForm = class(TCnTranslateForm)
    btnOK: TButton;
    btnCancel: TButton;
    btnHelp: TButton;
    PageControl: TPageControl;
    TabSheet1: TTabSheet;
    TabSheet2: TTabSheet;
    gbShortCut: TGroupBox;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    Label6: TLabel;
    hkCopySelected: THotKey;
    hkExportUnit: THotKey;
    hkExportBPG: THotKey;
    hkConfig: THotKey;
    hkExportDPR: THotKey;
    CheckBoxDispGauge: TCheckBox;
    GroupBox1: TGroupBox;
    Label5: TLabel;
    ComboBoxFont: TComboBox;
    LabelFontDisp: TLabel;
    Label7: TLabel;
    BtnModifyFont: TButton;
    FontDialog: TFontDialog;
    ActionList1: TActionList;
    ChangeFontAction: TAction;
    BtnResetFont: TButton;
    ResetFontAction: TAction;
    PanelDisp: TPanel;
    hkExportOpened: THotKey;
    Label8: TLabel;
    btnLoad: TButton;
    actLoad: TAction;
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure ComboBoxFontChange(Sender: TObject);
    procedure ChangeFontActionExecute(Sender: TObject);
    procedure ResetFontActionExecute(Sender: TObject);
    procedure PanelDispDblClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure btnHelpClick(Sender: TObject);
    procedure actLoadExecute(Sender: TObject);
  private
    FFontArray: array[0..9] of TFont;
    
    function GetShortCut(const Index: Integer): TShortCut;
    procedure SetShortCut(const Index: Integer; const Value: TShortCut);
    function GetDispGauge: Boolean;
    procedure SetDispGauge(const Value: Boolean);
    function GetFonts(const Index: Integer): TFont;
    procedure SetFonts(const Index: Integer; const Value: TFont);
    procedure DispFontText;
    procedure ResetFontsFromBasic(ABasicFont: TFont);
    { Private declarations }
  protected
    function GetHelpTopic: string; override;
  public
    { Public declarations }
    property CopySelectedShortCut: TShortCut index 0 read GetShortCut write SetShortCut;
    property ExportUnitShortCut: TShortCut index 1 read GetShortCut write SetShortCut;
    property ExportOpenedShortCut: TShortCut index 2 read GetShortCut write SetShortCut;
    property ExportDPRShortCut: TShortCut index 3 read GetShortCut write SetShortCut;
    property ExportBPGShortCut: TShortCut index 4 read GetShortCut write SetShortCut;
    property ConfigShortCut: TShortCut index 5 read GetShortCut write SetShortCut;
    property DispGauge: Boolean read GetDispGauge write SetDispGauge;

    property FontBasic: TFont index 0 read GetFonts write SetFonts;
    property FontAssembler: TFont index 1 read GetFonts write SetFonts;
    property FontComment: TFont index 2 read GetFonts write SetFonts;
    property FontDirective: TFont index 3 read GetFonts write SetFonts;
    property FontIdentifier: TFont index 4 read GetFonts write SetFonts;
    property FontKeyWord: TFont index 5 read GetFonts write SetFonts;
    property FontNumber: TFont index 6 read GetFonts write SetFonts;
    property FontSpace: TFont index 7 read GetFonts write SetFonts;
    property FontString: TFont index 8 read GetFonts write SetFonts;
    property FontSymbol: TFont index 9 read GetFonts write SetFonts;
  end;

implementation

uses CnWizCompilerConst;

{$R *.dfm}

{ TCnPas2HtmlConfigForm }

procedure TCnPas2HtmlConfigForm.FormCreate(Sender: TObject);
var
  i: Integer;
begin
  for i := Low(Self.FFontArray) to High(FFontArray) do
    FFontArray[i] := TFont.Create;
end;

procedure TCnPas2HtmlConfigForm.FormShow(Sender: TObject);
begin
  Self.PageControl.ActivePageIndex := 0;
  if ComboBoxFont.ItemIndex < 0 then
    ComboBoxFont.ItemIndex := 0;
  ComboBoxFont.OnChange(ComboBoxFont);
end;

procedure TCnPas2HtmlConfigForm.FormDestroy(Sender: TObject);
var
  i: Integer;
begin
  for i := Low(Self.FFontArray) to High(FFontArray) do
    if Assigned(FFontArray[i]) then
      FFontArray[i].Free;
end;

function TCnPas2HtmlConfigForm.GetDispGauge: Boolean;
begin
  Result := Self.CheckBoxDispGauge.Checked;
end;

function TCnPas2HtmlConfigForm.GetFonts(const Index: Integer): TFont;
begin
  Result := FFontArray[Index];
end;

function TCnPas2HtmlConfigForm.GetShortCut(
  const Index: Integer): TShortCut;
begin
  case Index of
    0: Result := hkCopySelected.HotKey;
    1: Result := hkExportUnit.HotKey;
    2: Result := hkExportOpened.HotKey;
    3: Result := hkExportDPR.HotKey;
    4: Result := hkExportBPG.HotKey;
    5: Result := hkConfig.HotKey;
  else
    Result := 0;
  end;
end;

procedure TCnPas2HtmlConfigForm.SetDispGauge(const Value: Boolean);
begin
  Self.CheckBoxDispGauge.Checked := Value;
end;

procedure TCnPas2HtmlConfigForm.SetFonts(const Index: Integer;
  const Value: TFont);
begin
  if Assigned(Value) then
    FFontArray[Index].Assign(Value);
end;

procedure TCnPas2HtmlConfigForm.SetShortCut(const Index: Integer;
  const Value: TShortCut);
begin
  case Index of
    0: hkCopySelected.HotKey := Value;
    1: hkExportUnit.HotKey := Value;
    2: hkExportOpened.HotKey := Value;
    3: hkExportDPR.HotKey := Value;
    4: hkExportBPG.HotKey := Value;
    5: hkConfig.HotKey := Value;
  end;
end;

procedure TCnPas2HtmlConfigForm.ComboBoxFontChange(Sender: TObject);
begin
  PanelDisp.Font := FFontArray[ComboBoxFont.ItemIndex];
  DispFontText;
end;

procedure TCnPas2HtmlConfigForm.DispFontText;
var
  s: string;
begin
  s := Format('%s, %d', [FFontArray[ComboBoxFont.ItemIndex].Name,
    FFontArray[ComboBoxFont.ItemIndex].Size]);
  if fsBold in FFontArray[ComboBoxFont.ItemIndex].Style then
    s := s + ', Bold';
  if fsItalic in FFontArray[ComboBoxFont.ItemIndex].Style then
    s := s + ', Italic';
  Self.LabelFontDisp.Caption := s;
end;

procedure TCnPas2HtmlConfigForm.ChangeFontActionExecute(Sender: TObject);
begin
  Self.FontDialog.Font := FFontArray[ComboBoxFont.ItemIndex];
  if Self.FontDialog.Execute then
  begin
    FFontArray[ComboBoxFont.ItemIndex].Assign(Self.FontDialog.Font);
    PanelDisp.Font := FFontArray[ComboBoxFont.ItemIndex];
    if ComboBoxFont.ItemIndex = 0 then
      Self.ResetFontsFromBasic(FFontArray[0]);
    DispFontText;
  end;
end;

procedure TCnPas2HtmlConfigForm.ResetFontActionExecute(Sender: TObject);
var
  TempFont: TFont;
begin
  TempFont := TFont.Create;
  TempFont.Name := 'Courier New';  {Do NOT Localize}
  TempFont.Size := 10;
  Self.ResetFontsFromBasic(TempFont);
  TempFont.Free;
  ComboBoxFont.ItemIndex := 0;
  ComboBoxFont.OnChange(ComboBoxFont);
end;

procedure TCnPas2HtmlConfigForm.ResetFontsFromBasic(ABasicFont: TFont);
var
  TempFont: TFont;
begin
  TempFont := TFont.Create;
  try
    TempFont.Assign(ABasicFont);
    Self.FontBasic := TempFont;
    
    TempFont.Color := clRed;
    Self.FontAssembler := TempFont;

    TempFont.Color := clNavy;
    TempFont.Style := [fsItalic];
    Self.FontComment := TempFont;

    TempFont.Style := [];
    TempFont.Color := clBlack;
    Self.FontIdentifier := TempFont;

    TempFont.Color := clGreen;
    Self.FontDirective := TempFont;

    TempFont.Color := clBlack;
    TempFont.Style := [fsBold];
    Self.FontKeyWord := TempFont;

    TempFont.Style := [];
    Self.FontNumber := TempFont;

    Self.FontSpace := TempFont;

    TempFont.Color := clBlue;
    Self.FontString := TempFont;

    TempFont.Color := clBlack;
    Self.FontSymbol := TempFont;
  finally
    TempFont.Free;
  end;
end;

procedure TCnPas2HtmlConfigForm.PanelDispDblClick(Sender: TObject);
begin
  Self.ChangeFontAction.Execute;
end;

procedure TCnPas2HtmlConfigForm.btnHelpClick(Sender: TObject);
begin
  ShowFormHelp;
end;

function TCnPas2HtmlConfigForm.GetHelpTopic: string;
begin
  Result := 'CnPas2HtmlWizard';
end;

procedure TCnPas2HtmlConfigForm.actLoadExecute(Sender: TObject);
const
  arrRegItems: array [0..9] of string = ('', 'Assembler', 'Comment', 'Preprocessor',
    'Identifier', 'Reserved word', 'Number', 'Whitespace', 'String', 'Symbol');
var
  I: Integer;
  AFont: TFont;
begin
// ��ע��������� IDE ������
  AFont := TFont.Create;
  AFont.Name := 'Courier New';  {Do NOT Localize}
  AFont.Size := 10;

  if GetIDERegistryFont(arrRegItems[0], AFont) then
    ResetFontsFromBasic(AFont);

  for I := Low(FFontArray) + 1 to High(FFontArray) do
  begin
    try
      if GetIDERegistryFont(arrRegItems[I], AFont) then
        FFontArray[I].Assign(AFont);
    except
      Continue;
    end;
  end;
  
  ComboBoxFontChange(ComboBoxFont);
  AFont.Free;
end;

end.
