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

unit CnWizMacroFrm;
{* |<PRE>
================================================================================
* ������ƣ�CnPack IDE ר�Ұ�
* ��Ԫ���ƣ�Editor ר�Һ��滻���嵥Ԫ
* ��Ԫ���ߣ��ܾ��� (zjy@cnpack.org)
* ��    ע���ô������� Editor ר�ҵ���ʱ����ʾ�û�������滻ֵ
* ����ƽ̨��PWin2000Pro + Delphi 5.01
* ���ݲ��ԣ�PWin9X/2000/XP + Delphi 5/6/7 + C++Builder 5/6
* �� �� �����ô����е��ַ��������ϱ��ػ�����ʽ
* ��Ԫ��ʶ��$Id: CnWizMacroFrm.pas 763 2011-02-07 14:18:23Z liuxiao@cnpack.org $
* �޸ļ�¼��2002.11.03 V1.0
*               ������Ԫ��ʵ�ֹ���
================================================================================
|</PRE>}

interface

{$I CnWizards.inc}

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, ExtCtrls, IniFiles, CnIni, CnWizUtils, CnWizOptions, CnCommon,
  CnWizMultiLang;

type

//==============================================================================
// ���滻����
//==============================================================================

{ TCnEditorMacroForm }

  TCnWizMacroForm = class(TCnTranslateForm)
    edtMacro0: TEdit;
    lblMacro0: TLabel;
    lblValue0: TLabel;
    Panel1: TPanel;
    Bevel2: TBevel;
    btnHelp: TButton;
    btnOK: TButton;
    btnCancel: TButton;
    imgIcon: TImage;
    Label3: TLabel;
    Bevel1: TBevel;
    edtMacro1: TEdit;
    lblMacro1: TLabel;
    lblValue1: TLabel;
    cbbValue0: TComboBox;
    cbbValue1: TComboBox;
    procedure cbbValue0KeyPress(Sender: TObject; var Key: Char);
    procedure btnHelpClick(Sender: TObject);
  private
    { Private declarations }
  protected
    function GetHelpTopic: string; override;
  public
    { Public declarations }
  end;

function GetEditorMacroValue(Macros: TStrings; const ACaption: string = ''; 
  AIcon: TIcon = nil): Boolean;
{* ȡ���б��Ӧ��ֵ������� Macros.Values ��
 |<PRE>
   Macros: TStrings             - ������б�����Ϊ nil
   Caption: string              - ���ڱ���
   Icon: TIcon                  - ����ͼ�꣬���Դ� nil
 |</PRE>}

implementation

{$R *.DFM}

const
  csMaxLastCount = 8;                  // ��������󱣴���Ŀ��

// ȡ���б��Ӧ��ֵ
function GetEditorMacroValue(Macros: TStrings; const ACaption: string = '';
  AIcon: TIcon = nil): Boolean;
const
  csMacroHistory = 'MacroHistory';
var
  edtMacros: array of TEdit;
  cbbValues: array of TComboBox;
  lblMacros: array of TLabel;
  lblValues: array of TLabel;
  Ini: TCustomIniFile;
  i, Delta: Integer;
  Macro: string;

  function CreateEdit(Exists: TEdit; TopDelta: Integer): TEdit;
  begin
    Result := TEdit.Create(Exists.Owner);
    Result.Parent := Exists.Parent;
    Result.Left := Exists.Left;
    Result.Top := Exists.Top + TopDelta;
    Result.Width := Exists.Width;
    Result.Height := Exists.Height;
    Result.ReadOnly := Exists.ReadOnly;
    Result.TabStop := Exists.TabStop;
    Result.OnKeyPress := Exists.OnKeyPress;
  end;

  function CreateComboBox(Exists: TComboBox; TopDelta: Integer): TComboBox;
  begin
    Result := TComboBox.Create(Exists.Owner);
    Result.Parent := Exists.Parent;
    Result.Left := Exists.Left;
    Result.Top := Exists.Top + TopDelta;
    Result.Width := Exists.Width;
    Result.Height := Exists.Height;
    Result.TabStop := Exists.TabStop;
    Result.OnKeyPress := Exists.OnKeyPress;
  end;

  function CreateLabel(Exists: TLabel; TopDelta: Integer): TLabel;
  begin
    Result := TLabel.Create(Exists.Owner);
    Result.Parent := Exists.Parent;
    Result.Left := Exists.Left;
    Result.Top := Exists.Top + TopDelta;
    Result.Width := Exists.Width;
    Result.Height := Exists.Height;
    Result.Caption := Exists.Caption;
  end;
begin
  Assert(Macros <> nil);
  Result := True;
  if Macros.Count = 0 then Exit;

  Ini := nil;
  with TCnWizMacroForm.Create(nil) do
  try
    ShowHint := WizOptions.ShowHint;
    if ACaption <> '' then
      Caption := ACaption;
    if (AIcon <> nil) and not AIcon.Empty then
      imgIcon.Picture.Graphic := Icon;
    Ini := WizOptions.CreateRegIniFile(WizOptions.RegPath + csMacroHistory);

    Delta := edtMacro1.Top - edtMacro0.Top;
    if Macros.Count > 2 then
      Height := Height + Delta * (Macros.Count - 2);
    SetLength(edtMacros, Macros.Count);
    SetLength(cbbValues, Macros.Count);
    SetLength(lblMacros, Macros.Count);
    SetLength(lblValues, Macros.Count);

    for i := 0 to Macros.Count - 1 do
    begin
      Assert(Macros[i] <> '');
      if i = 0 then
      begin
        edtMacros[i] := edtMacro0;
        cbbValues[i] := cbbValue0;
        lblMacros[i] := lblMacro0;
        lblValues[i] := lblValue0;
      end
      else if i = 1 then
      begin
        edtMacros[i] := edtMacro1;
        cbbValues[i] := cbbValue1;
        lblMacros[i] := lblMacro1;
        lblValues[i] := lblValue1;
      end
      else
      begin
        edtMacros[i] := CreateEdit(edtMacro0, i * Delta);
        cbbValues[i] := CreateComboBox(cbbValue0, i * Delta);
        lblMacros[i] := CreateLabel(lblMacro0, i * Delta);
        lblValues[i] := CreateLabel(lblValue0, i * Delta);
      end;
      
      Macro := Macros.Names[i];
      if Macro = '' then Macro := Macros[i];
      edtMacros[i].Text := Macro;
      ReadStringsFromIni(Ini, Macro, cbbValues[i].Items);
      if cbbValues[i].Items.Count > 0 then
        cbbValues[i].Text := cbbValues[i].Items[0];
    end;

    if Macros.Count = 1 then
    begin
      edtMacro1.Visible := False;
      cbbValue1.Visible := False;
      lblMacro1.Visible := False;
      lblValue1.Visible := False;
    end;

    InitFormControls;

    Result := ShowModal = mrOk;
    if Result then
    begin
      for i := 0 to Macros.Count - 1 do
      begin
        Macro := Macros.Names[i];
        if Macro = '' then Macro := Macros[i];
        Macros.Values[Macro] := cbbValues[i].Text;

        if cbbValues[i].Items.IndexOf(cbbValues[i].Text) < 0 then
          cbbValues[i].Items.Insert(0, cbbValues[i].Text)
        else
          cbbValues[i].Items.Move(cbbValues[i].Items.IndexOf(cbbValues[i].Text), 0);
        while cbbValues[i].Items.Count > csMaxLastCount do
          cbbValues[i].Items.Delete(csMaxLastCount);
        WriteStringsToIni(Ini, Macro, cbbValues[i].Items);
      end;
    end;
  finally
    Ini.Free;
    edtMacros := nil;
    cbbValues := nil;
    lblMacros := nil;
    lblValues := nil;
    Free;
  end;
end;

//==============================================================================
// ���滻����
//==============================================================================

{ TCnWizMacroForm }

// �س���ת����һ�����
procedure TCnWizMacroForm.cbbValue0KeyPress(Sender: TObject;
  var Key: Char);
begin
  if (Sender is TComboBox) and (Key = #13) then
  begin
    Key := #0;
    FindNextControl(TComboBox(Sender), True, True, False).SetFocus;
  end;
end;

procedure TCnWizMacroForm.btnHelpClick(Sender: TObject);
begin
  ShowFormHelp;
end;

function TCnWizMacroForm.GetHelpTopic: string;
begin
  Result := 'CnEditorMacroForm';
end;

end.
