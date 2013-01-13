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

unit CnEditorFontZoom;
{* |<PRE>
================================================================================
* ������ƣ�CnPack IDE ר�Ұ�
* ��Ԫ���ƣ��༭���������ŵ�Ԫ
* ��Ԫ���ߣ��ܾ��� (zjy@cnpack.org)
* ��    ע��
* ����ƽ̨��PWin XP SP3 + Delphi 5.01
* ���ݲ��ԣ�
* �� �� �����ô����е��ַ��������ϱ��ػ�����ʽ
* ��Ԫ��ʶ��$Id: CnEditorFontZoom.pas 418 2010-02-08 04:53:54Z zhoujingyu $
* �޸ļ�¼��2010.06.10 V1.0
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
// �༭����������
//==============================================================================

{ TCnEditorFontInc }

  TCnEditorFontInc = class(TCnEditorCodeTool)
  public
    constructor Create(AOwner: TCnEditorWizard); override;
    function GetCaption: string; override;
    function GetHint: string; override;
    procedure GetEditorInfo(var Name, Author, Email: string); override;
    procedure Execute; override;
  end;

//==============================================================================
// �༭��������С
//==============================================================================

{ TCnEditorFontDec }

  TCnEditorFontDec = class(TCnEditorCodeTool)
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

{ TCnEditorFontInc }

constructor TCnEditorFontInc.Create(AOwner: TCnEditorWizard);
begin
  inherited;
  ValidInSource := True;
  BlockMustNotEmpty := False;
end;

function TCnEditorFontInc.GetCaption: string;
begin
  Result := SCnEditorFontIncMenuCaption;
end;

function TCnEditorFontInc.GetHint: string;
begin
  Result := SCnEditorFontIncMenuHint;
end;

procedure TCnEditorFontInc.GetEditorInfo(var Name, Author, Email: string);
begin
  Name := SCnEditorFontIncName;
  Author := SCnPack_Zjy;
  Email := SCnPack_ZjyEmail;
end;

procedure TCnEditorFontInc.Execute;
var
  Option: IOTAEditOptions;
begin
  Option := CnOtaGetEditOptions;
  if Assigned(Option) then
    Option.FontSize := Round(Option.FontSize * 1.1);
end;

{ TCnEditorFontDec }

constructor TCnEditorFontDec.Create(AOwner: TCnEditorWizard);
begin
  inherited;
  ValidInSource := True;
  BlockMustNotEmpty := False;
end;

function TCnEditorFontDec.GetCaption: string;
begin
  Result := SCnEditorFontDecMenuCaption;
end;

function TCnEditorFontDec.GetHint: string;
begin
  Result := SCnEditorFontDecMenuHint;
end;

procedure TCnEditorFontDec.GetEditorInfo(var Name, Author, Email: string);
begin
  Name := SCnEditorFontDecName;
  Author := SCnPack_Zjy;
  Email := SCnPack_ZjyEmail;
end;

procedure TCnEditorFontDec.Execute;
var
  Option: IOTAEditOptions;
begin
  Option := CnOtaGetEditOptions;
  if Assigned(Option) then
    Option.FontSize := Round(Option.FontSize / 1.1);
end;

initialization
  RegisterCnEditor(TCnEditorFontInc);
  RegisterCnEditor(TCnEditorFontDec);

{$ENDIF CNWIZARDS_CNEDITORWIZARD}  
end.
