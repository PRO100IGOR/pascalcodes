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

unit CnEditorSortLines;
{* |<PRE>
================================================================================
* ������ƣ�CnPack IDE ר�Ұ�
* ��Ԫ���ƣ�����ѡ���й���
* ��Ԫ���ߣ��ܾ��� (zjy@cnpack.org)
* ��    ע��
* ����ƽ̨��PWinXP SP2 + Delphi 5.01
* ���ݲ��ԣ�PWin9X/2000/XP + Delphi 5/6/7 + C++Builder 5/6
* �� �� �����ô����е��ַ��������ϱ��ػ�����ʽ
* ��Ԫ��ʶ��$Id: CnEditorSortLines.pas 763 2011-02-07 14:18:23Z liuxiao@cnpack.org $
* �޸ļ�¼��2005.08.23 V1.0
*               ������Ԫ��ʵ�ֹ���
================================================================================
|</PRE>}

interface

{$I CnWizards.inc}

{$IFDEF CNWIZARDS_CNEDITORWIZARD}

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, IniFiles, ToolsAPI, CnWizUtils, CnConsts, CnCommon, CnEditorWizard,
  CnWizConsts, CnEditorCodeTool, CnIni;

type

//==============================================================================
// ������ɫ������
//==============================================================================

{ TCnEditorSortLines }

  TCnEditorSortLines = class(TCnEditorCodeTool)
  protected
    function ProcessText(const Text: string): string; override;
    function GetStyle: TCnCodeToolStyle; override;
  public
    constructor Create(AOwner: TCnEditorWizard); override;
    function GetCaption: string; override;
    function GetHint: string; override;
    procedure GetEditorInfo(var Name, Author, Email: string); override;
  end;

{$ENDIF CNWIZARDS_CNEDITORWIZARD}
  
implementation

{$IFDEF CNWIZARDS_CNEDITORWIZARD}

{ TCnEditorSortLines }

constructor TCnEditorSortLines.Create(AOwner: TCnEditorWizard);
begin
  inherited;
  ValidInSource := False;
  BlockMustNotEmpty := True;
end;

function DoCompare(List: TStringList; Index1, Index2: Integer): Integer;
begin
  Result := CompareText(Trim(List[Index1]), Trim(List[Index2]));
end;

function TCnEditorSortLines.ProcessText(const Text: string): string;
var
  Lines: TStringList;
begin
  Lines := TStringList.Create;
  try
    Lines.Text := Text;
    Lines.CustomSort(DoCompare);
    Result := Lines.Text;
  finally
    Lines.Free;
  end;   
end;

function TCnEditorSortLines.GetStyle: TCnCodeToolStyle;
begin
  Result := csLine;
end;

function TCnEditorSortLines.GetCaption: string;
begin
  Result := SCnEditorSortLinesMenuCaption;
end;

function TCnEditorSortLines.GetHint: string;
begin
  Result := SCnEditorSortLinesMenuHint;
end;

procedure TCnEditorSortLines.GetEditorInfo(var Name, Author, Email: string);
begin
  Name := SCnEditorSortLinesName;
  Author := SCnPack_Zjy;
  Email := SCnPack_ZjyEmail;
end;

initialization
  RegisterCnEditor(TCnEditorSortLines);

{$ENDIF CNWIZARDS_CNEDITORWIZARD}
end.
