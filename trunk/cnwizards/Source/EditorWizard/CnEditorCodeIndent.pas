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

unit CnEditorCodeIndent;
{* |<PRE>
================================================================================
* ������ƣ�CnPack IDE ר�Ұ�
* ��Ԫ���ƣ�������������ߵ�Ԫ
* ��Ԫ���ߣ���Х��LiuXiao�� liuxiao@cnpack.org; http://www.cnpack.org
* ��    ע��
* ����ƽ̨��PWin2000Pro + Delphi 5.01
* ���ݲ��ԣ�PWin9X/2000/XP + Delphi 5/6/7 + C++Builder 5/6
* �� �� �����ô����е��ַ��������ϱ��ػ�����ʽ
* ��Ԫ��ʶ��$Id: CnEditorCodeIndent.pas 763 2011-02-07 14:18:23Z liuxiao@cnpack.org $
* �޸ļ�¼��2005.01.22 V1.0
*               ������Ԫ��ʵ�ֹ���
================================================================================
|</PRE>}

interface

{$I CnWizards.inc}

{$IFDEF CNWIZARDS_CNEDITORWIZARD}

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, IniFiles, ToolsAPI, CnWizClasses, CnWizUtils, CnConsts, CnCommon,
  Menus, CnEditorWizard, CnWizConsts, CnEditorCodeTool;

type

//==============================================================================
// ���������������
//==============================================================================

{ TCnEditorCodeIndent }

  TCnEditorCodeIndent = class(TCnEditorCodeTool)
  public
    constructor Create(AOwner: TCnEditorWizard); override;
    function GetCaption: string; override;
    function GetHint: string; override;
    procedure GetEditorInfo(var Name, Author, Email: string); override;
    procedure Execute; override;
  end;

//==============================================================================
// ����鷴����������
//==============================================================================

{ TCnEditorCodeUnIndent }

  TCnEditorCodeUnIndent = class(TCnEditorCodeTool)
  public
    constructor Create(AOwner: TCnEditorWizard); override;
    function GetCaption: string; override;
    function GetHint: string; override;
    procedure GetEditorInfo(var Name, Author, Email: string); override;
    procedure Execute; override;
  end;

{$ENDIF CNWIZARDS_CNEDITORWIZARD}

implementation

{$IFDEF CNWIZARDS_CNEDITORWIZARD}

{ TCnEditorCodeIndent }

constructor TCnEditorCodeIndent.Create(AOwner: TCnEditorWizard);
begin
  inherited;
  ValidInSource := True;
  BlockMustNotEmpty := True;
end;

function TCnEditorCodeIndent.GetCaption: string;
begin
  Result := SCnEditorCodeIndentMenuCaption;
end;

function TCnEditorCodeIndent.GetHint: string;
begin
  Result := SCnEditorCodeIndentMenuHint;
end;

procedure TCnEditorCodeIndent.GetEditorInfo(var Name, Author, Email: string);
begin
  Name := SCnEditorCodeIndentName;
  Author := SCnPack_LiuXiao;
  Email := SCnPack_LiuXiaoEmail;
end;

procedure TCnEditorCodeIndent.Execute;
var
  EditView: IOTAEditView;
begin
  EditView := CnOtaGetTopMostEditView;
  if Assigned(EditView) and (EditView.Block <> nil) then
  begin
    EditView.Block.Indent(CnOtaGetBlockIndent);
    EditView.Paint;
  end;
end;

{ TCnEditorCodeUnIndent }

constructor TCnEditorCodeUnIndent.Create(AOwner: TCnEditorWizard);
begin
  inherited;
  ValidInSource := True;
  BlockMustNotEmpty := True;
end;

function TCnEditorCodeUnIndent.GetCaption: string;
begin
  Result := SCnEditorCodeUnIndentMenuCaption;
end;

function TCnEditorCodeUnIndent.GetHint: string;
begin
  Result := SCnEditorCodeUnIndentMenuHint;
end;

procedure TCnEditorCodeUnIndent.GetEditorInfo(var Name, Author, Email: string);
begin
  Name := SCnEditorCodeUnIndentName;
  Author := SCnPack_LiuXiao;
  Email := SCnPack_LiuXiaoEmail;
end;

procedure TCnEditorCodeUnIndent.Execute;
var
  EditView: IOTAEditView;
begin
  EditView := CnOtaGetTopMostEditView;
  if Assigned(EditView) and (EditView.Block <> nil) then
  begin
    EditView.Block.Indent(-CnOtaGetBlockIndent);
    EditView.Paint;
  end;
end;

initialization
  RegisterCnEditor(TCnEditorCodeIndent);
  RegisterCnEditor(TCnEditorCodeUnIndent);

{$ENDIF CNWIZARDS_CNEDITORWIZARD}  
end.
