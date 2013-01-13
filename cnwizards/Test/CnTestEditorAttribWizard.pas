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

unit CnTestEditorAttribWizard;
{ |<PRE>
================================================================================
* ������ƣ�CnPack IDE ר�Ұ�
* ��Ԫ���ƣ��򵥵�ר����ʾ��Ԫ
* ��Ԫ���ߣ�CnPack ������
* ��    ע���õ�Ԫ�ɻ�ȡ����������༭����ǰ������ڵ����Լ��ַ����Ե�����
* ����ƽ̨��PWin2000Pro + Delphi 5.01
* ���ݲ��ԣ�PWin9X/2000/XP + Delphi 5/6/7 + C++Builder 5/6
* �� �� �����ô����е��ַ����ݲ�֧�ֱ��ػ�����ʽ
* ��Ԫ��ʶ��$Id: CnTestEditorAttribWizard.pas 763 2011-02-07 14:18:23Z liuxiao@cnpack.org $
* �޸ļ�¼��2009.01.07 V1.0
*               ������Ԫ
================================================================================
|</PRE>}

interface

{$I CnWizards.inc}

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  ToolsAPI, IniFiles, CnWizClasses, CnWizUtils, CnWizConsts, CnEditControlWrapper;

type

//==============================================================================
// �༭�����Ի�ȡ�˵�ר��
//==============================================================================

{ TCnTestEditorAttribWizard }

  TCnTestEditorAttribWizard = class(TCnMenuWizard)
  private

  protected
    function GetHasConfig: Boolean; override;
  public
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

//==============================================================================
// ��ʾ�ò˵�ר��
//==============================================================================

{ TCnTestEditorAttribWizard }

procedure TCnTestEditorAttribWizard.Config;
begin
  { TODO -oAnyone : �ڴ���ʾ���ô��� }
end;

procedure TCnTestEditorAttribWizard.Execute;
var
  EditPos: TOTAEditPos;
  EditControl: TControl;
  EditView: IOTAEditView;
  LineFlag, Element: Integer;
  S, T: string;
  Block: IOTAEditBlock;
begin
  { TODO -oAnyone : ��ר�ҵ���ִ�й��� }
  EditControl := CnOtaGetCurrentEditControl;
  EditView := CnOtaGetTopMostEditView;

  Block := EditView.Block;
  S := Format('Edit Block %8.8x. ', [Integer(Block)]);
  if Block <> nil then
  begin
    if Block.IsValid then
      S := S + 'Is Valid.'
    else
      S := S + 'NOT Valid.';
  end;

  EditPos := EditView.CursorPos;
  EditControlWrapper.GetAttributeAtPos(EditControl, EditPos, False, Element, LineFlag);

  S := S + #13#10 +Format('EditPos Line %d, Col %d. LineFlag %d. Element: %d, ',
    [EditPos.Line, EditPos.Col, LineFlag, Element]);
  case Element of
    0:  T := 'atWhiteSpace  ';
    1:  T := 'atComment     ';
    2:  T := 'atReservedWord';
    3:  T := 'atIdentifier  ';
    4:  T := 'atSymbol      ';
    5:  T := 'atString      ';
    6:  T := 'atNumber      ';
    7:  T := 'atFloat       ';
    8:  T := 'atOctal       ';
    9:  T := 'atHex         ';
    10: T := 'atCharacter   ';
    11: T := 'atPreproc     ';
    12: T := 'atIllegal     ';
    13: T := 'atAssembler   ';
    14: T := 'SyntaxOff     ';
    15: T := 'MarkedBlock   ';
    16: T := 'SearchMatch   ';
  else
    T := 'Unknown';
  end;
  ShowMessage(S + T);

  if EditPos.Col > 1 then
    Dec(EditPos.Col);

  EditControlWrapper.GetAttributeAtPos(EditControl, EditPos, False, Element, LineFlag);

  S := Format('EditPos Line %d, Col %d. LineFlag %d. Element: %d, ',
    [EditPos.Line, EditPos.Col, LineFlag, Element]);
  case Element of
    0:  T := 'atWhiteSpace  ';
    1:  T := 'atComment     ';
    2:  T := 'atReservedWord';
    3:  T := 'atIdentifier  ';
    4:  T := 'atSymbol      ';
    5:  T := 'atString      ';
    6:  T := 'atNumber      ';
    7:  T := 'atFloat       ';
    8:  T := 'atOctal       ';
    9:  T := 'atHex         ';
    10: T := 'atCharacter   ';
    11: T := 'atPreproc     ';
    12: T := 'atIllegal     ';
    13: T := 'atAssembler   ';
    14: T := 'SyntaxOff     ';
    15: T := 'MarkedBlock   ';
    16: T := 'SearchMatch   ';
  else
    T := 'Unknown';
  end;
  ShowMessage(S + T);
end;

function TCnTestEditorAttribWizard.GetCaption: string;
begin
  Result := 'Show Attribute at Cursor';
  { TODO -oAnyone : ����ר�Ҳ˵��ı��⣬�ַ�������б��ػ����� }
end;

function TCnTestEditorAttribWizard.GetDefShortCut: TShortCut;
begin
  Result := 0;
  { TODO -oAnyone : ����Ĭ�ϵĿ�ݼ� }
end;

function TCnTestEditorAttribWizard.GetHasConfig: Boolean;
begin
  Result := False;
  { TODO -oAnyone : ����ר���Ƿ������ô��� }
end;

function TCnTestEditorAttribWizard.GetHint: string;
begin
  Result := 'Show Attribute at Cursor in Current Editor';
  { TODO -oAnyone : ����ר�Ҳ˵���ʾ��Ϣ���ַ�������б��ػ����� }
end;

function TCnTestEditorAttribWizard.GetState: TWizardState;
begin
  Result := [wsEnabled];
  { TODO -oAnyone : ����ר�Ҳ˵�״̬���ɸ���ָ���������趨 }
end;

class procedure TCnTestEditorAttribWizard.GetWizardInfo(var Name, Author, Email, Comment: string);
begin
  Name := 'Test Editor Attribute Menu Wizard';
  Author := 'CnPack Team';
  Email := 'liuxiao@cnpack.org';
  Comment := 'Test Editor Attribute Menu Wizard';
  { TODO -oAnyone : ����ר�ҵ����ơ����ߡ����估��ע���ַ�������б��ػ����� }
end;

procedure TCnTestEditorAttribWizard.LoadSettings(Ini: TCustomIniFile);
begin
  { TODO -oAnyone : �ڴ�װ��ר���ڲ��õ��Ĳ�����ר�Ҵ���ʱ�Զ������� }
end;

procedure TCnTestEditorAttribWizard.SaveSettings(Ini: TCustomIniFile);
begin
  { TODO -oAnyone : �ڴ˱���ר���ڲ��õ��Ĳ�����ר���ͷ�ʱ�Զ������� }
end;

initialization
  RegisterCnWizard(TCnTestEditorAttribWizard); // ע��ר��

end.
