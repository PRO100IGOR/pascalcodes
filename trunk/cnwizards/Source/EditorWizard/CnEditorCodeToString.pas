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

unit CnEditorCodeToString;
{ |<PRE>
================================================================================
* ������ƣ�CnPack IDE ר�Ұ�
* ��Ԫ���ƣ�����ת��Ϊ�ַ���������
* ��Ԫ���ߣ��ܾ��� (zjy@cnpack.org)
* ��    ע������ת��Ϊ�ַ�������
* ����ƽ̨��PWin2000Pro + Delphi 5.01
* ���ݲ��ԣ�PWin9X/2000/XP + Delphi 5/6/7 + C++Builder 5/6
* �� �� �����õ�Ԫ�е��ַ���֧�ֱ��ػ�����ʽ
* ��Ԫ��ʶ��$Id: CnEditorCodeToString.pas 763 2011-02-07 14:18:23Z liuxiao@cnpack.org $
* �޸ļ�¼��2003.03.23 V1.0
*               ������Ԫ
================================================================================
|</PRE>}

interface

{$I CnWizards.inc}

{$IFDEF CNWIZARDS_CNEDITORWIZARD}

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, IniFiles, ToolsAPI, CnWizClasses, CnWizUtils, CnConsts, CnCommon,
  CnEditorWizard, CnWizConsts, CnEditorCodeTool, CnWizMultiLang;

type
  TCnEditorCodeToStringForm = class(TCnTranslateForm)
    btnOK: TButton;
    btnCancel: TButton;
    GroupBox1: TGroupBox;
    Label1: TLabel;
    edtDelphiReturn: TEdit;
    Label2: TLabel;
    edtCReturn: TEdit;
    cbSkipSpace: TCheckBox;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

//==============================================================================
// ����ת��Ϊ�ַ���
//==============================================================================

{ TCnEditorCodeToString }

  TCnEditorCodeToString = class(TCnEditorCodeTool)
  private
    FDelphiReturn: string;
    FCReturn: string;
    FSkipSpace: Boolean;
  protected
    function GetHasConfig: Boolean; override;
    function ProcessText(const Text: string): string; override;
    function GetStyle: TCnCodeToolStyle; override;
  public
    constructor Create(AOwner: TCnEditorWizard); override;
    function GetCaption: string; override;
    function GetHint: string; override;
    procedure GetEditorInfo(var Name, Author, Email: string); override;
    procedure Config; override;
  published
    property DelphiReturn: string read FDelphiReturn write FDelphiReturn;
    property CReturn: string read FCReturn write FCReturn;
    property SkipSpace: Boolean read FSkipSpace write FSkipSpace default True;
  end;

{$ENDIF CNWIZARDS_CNEDITORWIZARD}

implementation

{$IFDEF CNWIZARDS_CNEDITORWIZARD}

{$R *.DFM}

//==============================================================================
// ����ת��Ϊ�ַ���
//==============================================================================

{ TCnEditorCodeToString }

constructor TCnEditorCodeToString.Create(AOwner: TCnEditorWizard);
begin
  inherited;
  FDelphiReturn := '#13#10';
  FCReturn := '\n';
  FSkipSpace := True;
end;

function TCnEditorCodeToString.ProcessText(const Text: string): string;
var
  AdjustRet: Boolean;
  Strings: TStrings;
  i, SpcCount: Integer;
  c: Char;
  s: string;
begin
  AdjustRet := StrRight(Text, 2) = #13#10;
  Result := StrToSourceCode(Text, FDelphiReturn, FCReturn, True);

  if FSkipSpace then                    // �������׿ո�
  begin
    Strings := TStringList.Create;
    try
      Strings.Text := Result;
      SpcCount := 0;
      for i := 0 to Strings.Count - 1 do
      begin
        s := Strings[i];
        if Length(s) > 2 then
          if s[2] = ' ' then            // ���ո����
          begin
            c := s[1];
            s[1] := ' ';
            SpcCount := 0;
            while (SpcCount < Length(s)) and (s[SpcCount + 2] = ' ') do
              Inc(SpcCount);
            s[SpcCount + 1] := c;
            
            Strings[i] := s;
          end
          else
          begin                         // �����ո����
            Strings[i] := Spc(SpcCount) + s;
          end;
      end;
      Result := Strings.Text;
      Delete(Result, Length(Result) - 1, 2); // ɾ������Ļ��з�
    finally
      Strings.Free;
    end;
  end;
  
  if AdjustRet then
    Result := Result + #13#10;          // ����ѡ������ʱת������һ�лس�������
end;

procedure TCnEditorCodeToString.Config;
begin
  with TCnEditorCodeToStringForm.Create(nil) do
  try
    edtDelphiReturn.Text := FDelphiReturn;
    edtCReturn.Text := FCReturn;
    cbSkipSpace.Checked := FSkipSpace;

    if ShowModal = mrOK then
    begin
      FDelphiReturn := edtDelphiReturn.Text;
      FCReturn := edtCReturn.Text;
      FSkipSpace := cbSkipSpace.Checked;
    end;
  finally
    Free;
  end;
end;

function TCnEditorCodeToString.GetHasConfig: Boolean;
begin
  Result := True;
end;

function TCnEditorCodeToString.GetStyle: TCnCodeToolStyle;
begin
  Result := csSelText;
end;

function TCnEditorCodeToString.GetCaption: string;
begin
  Result := SCnEditorCodeToStringMenuCaption;
end;

function TCnEditorCodeToString.GetHint: string;
begin
  Result := SCnEditorCodeToStringMenuHint;
end;

procedure TCnEditorCodeToString.GetEditorInfo(var Name, Author, Email: string);
begin
  Name := SCnEditorCodeToStringName;
  Author := SCnPack_Zjy;
  Email := SCnPack_ZjyEmail;
end;

initialization
  RegisterCnEditor(TCnEditorCodeToString); // ע��ר��

{$ENDIF CNWIZARDS_CNEDITORWIZARD}
end.

