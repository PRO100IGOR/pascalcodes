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

unit CnEditorCodeComment;
{* |<PRE>
================================================================================
* ������ƣ�CnPack IDE ר�Ұ�
* ��Ԫ���ƣ������ע�͹��ߵ�Ԫ
* ��Ԫ���ߣ���Х��LiuXiao�� liuxiao@cnpack.org; http://www.cnpack.org
* ��    ע��
* ����ƽ̨��PWin2000Pro + Delphi 5.01
* ���ݲ��ԣ�PWin9X/2000/XP + Delphi 5/6/7 + C++Builder 5/6
* �� �� �����ô����е��ַ��������ϱ��ػ�����ʽ
* ��Ԫ��ʶ��$Id: CnEditorCodeComment.pas 763 2011-02-07 14:18:23Z liuxiao@cnpack.org $
* �޸ļ�¼��2002.12.31 V1.0
*               ������Ԫ��ʵ�ֹ���
================================================================================
|</PRE>}

interface

{$I CnWizards.inc}

{$IFDEF CNWIZARDS_CNEDITORWIZARD}

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, IniFiles, ToolsAPI, CnWizClasses, CnWizUtils, CnConsts, CnCommon,
  Menus, CnEditorWizard, CnWizConsts, CnEditorCodeTool, CnWizMultiLang;

type

//==============================================================================
// �����ע�͹�����
//==============================================================================

{ TCnEditorCodeComment }

  TCnEditorCodeComment = class(TCnEditorCodeTool)
  protected
    function ProcessLine(const Str: string): string; override;
    function GetStyle: TCnCodeToolStyle; override;
  public
    function GetCaption: string; override;
    function GetHint: string; override;
    procedure GetEditorInfo(var Name, Author, Email: string); override;
  end;

//==============================================================================
// �����ȡ��ע�͹�����
//==============================================================================

{ TCnEditorCodeUnComment }

  TCnEditorCodeUnComment = class(TCnEditorCodeTool)
  protected
    function ProcessLine(const Str: string): string; override;
    function GetStyle: TCnCodeToolStyle; override;
  public
    function GetCaption: string; override;
    function GetHint: string; override;
    procedure GetEditorInfo(var Name, Author, Email: string); override;
  end;

//==============================================================================
// ������л�ע�͹�����
//==============================================================================

{ TCnEditorCodeToggleComment }

  TCnEditorCodeToggleComment = class(TCnEditorCodeTool)
  private
    Inited: Boolean;
    FirstIsCommented: Boolean;
    FMoveToNextLine: Boolean;
  protected
    function GetHasConfig: Boolean; override;
    function ProcessLine(const Str: string): string; override;
    function GetStyle: TCnCodeToolStyle; override;
    function GetDefShortCut: TShortCut; override;
    procedure GetNewPos(var ARow: Integer; var ACol: Integer); override;
  public
    constructor Create(AOwner: TCnEditorWizard); override;
    function GetCaption: string; override;
    function GetHint: string; override;
    procedure GetEditorInfo(var Name, Author, Email: string); override;
    procedure Execute; override;
    procedure Config; override;
  published
    property MoveToNextLine: Boolean read FMoveToNextLine write FMoveToNextLine default True;    
  end;

  TCnEditorCodeCommentForm = class(TCnTranslateForm)
    grp1: TGroupBox;
    chkMoveToNextLine: TCheckBox;
    btnOK: TButton;
    btnCancel: TButton;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

{$ENDIF CNWIZARDS_CNEDITORWIZARD}

implementation

{$R *.dfm}

{$IFDEF CNWIZARDS_CNEDITORWIZARD}

function GetCommentStr(const Str: string): string;
begin
  Result := '//' + Str;
end;

function IsCommentStr(const Str: string): Boolean;
var
  S: string;
begin
  S := Trim(Str);
  // ǰ�������� // ���Ҳ���ֻ���������� ///
  Result := (Pos('//', S) = 1) and ((Length(S) <= 2) or (S[3] <> '/') or
    (Pos('////', S) = 1));
end;

function GetUnCommentStr(const Str: string): string;
begin
  if IsCommentStr(Str) then
    Result := StringReplace(Str, '//', '', [])
  else
    Result := Str;
end;

{ TCnEditorCodeComment }

function TCnEditorCodeComment.ProcessLine(const Str: string): string;
begin
  Result := GetCommentStr(Str);
end;

function TCnEditorCodeComment.GetStyle: TCnCodeToolStyle;
begin
  Result := csLine;
end;

function TCnEditorCodeComment.GetCaption: string;
begin
  Result := SCnEditorCodeCommentMenuCaption;
end;

function TCnEditorCodeComment.GetHint: string;
begin
  Result := SCnEditorCodeCommentMenuHint;
end;

procedure TCnEditorCodeComment.GetEditorInfo(var Name, Author, Email: string);
begin
  Name := SCnEditorCodeCommentName;
  Author := SCnPack_LiuXiao;
  Email := SCnPack_LiuXiaoEmail;
end;

{ TCnEditorCodeUnComment }

function TCnEditorCodeUnComment.ProcessLine(const Str: string): string;
begin
  Result := GetUnCommentStr(Str);
end;

function TCnEditorCodeUnComment.GetStyle: TCnCodeToolStyle;
begin
  Result := csLine;
end;

function TCnEditorCodeUnComment.GetCaption: string;
begin
  Result := SCnEditorCodeUnCommentMenuCaption;
end;

function TCnEditorCodeUnComment.GetHint: string;
begin
  Result := SCnEditorCodeUnCommentMenuHint;
end;

procedure TCnEditorCodeUnComment.GetEditorInfo(var Name, Author, Email: string);
begin
  Name := SCnEditorCodeUnCommentName;
  Author := SCnPack_LiuXiao;
  Email := SCnPack_LiuXiaoEmail;
end;

{ TCnEditorCodeToggleComment }

constructor TCnEditorCodeToggleComment.Create(AOwner: TCnEditorWizard);
begin
  inherited;
  FMoveToNextLine := True;
end;

procedure TCnEditorCodeToggleComment.Execute;
begin
  Inited := False;
  FirstIsCommented := False;
  inherited;
end;

function TCnEditorCodeToggleComment.ProcessLine(const Str: string): string;
begin
  // �ж������Ƿ���ע��
  if not Inited then
  begin
    FirstIsCommented := IsCommentStr(Str);
    Inited := True;
  end;

  // ʹ�� BDS 2005 �Ĺ�����
  if not FirstIsCommented then
    Result := GetCommentStr(Str)    // ����δע��ʱȫ������ע��
  else if IsCommentStr(Str) then
    Result := GetUnCommentStr(Str)  // ע�͹���ȡ��ע��
  else
    Result := GetCommentStr(Str);   // δע�͵�����ע��
end;

function TCnEditorCodeToggleComment.GetStyle: TCnCodeToolStyle;
begin
  Result := csLine;
end;

function TCnEditorCodeToggleComment.GetCaption: string;
begin
  Result := SCnEditorCodeToggleCommentMenuCaption;
end;

procedure TCnEditorCodeToggleComment.GetEditorInfo(var Name, Author,
  Email: string);
begin
  Name := SCnEditorCodeToggleCommentName;
  Author := SCnPack_Zjy;
  Email := SCnPack_ZjyEmail;
end;

function TCnEditorCodeToggleComment.GetHint: string;
begin
  Result := SCnEditorCodeToggleCommentMenuHint;
end;

function TCnEditorCodeToggleComment.GetDefShortCut: TShortCut;
begin
  Result := $40BF;   // Ctrl+/
end;

procedure TCnEditorCodeToggleComment.GetNewPos(var ARow, ACol: Integer);
begin
  if MoveToNextLine then
    Inc(ARow);
end;

function TCnEditorCodeToggleComment.GetHasConfig: Boolean;
begin
  Result := True;
end;

procedure TCnEditorCodeToggleComment.Config;
begin
  with TCnEditorCodeCommentForm.Create(nil) do
  try
    chkMoveToNextLine.Checked := FMoveToNextLine;

    if ShowModal = mrOk then
    begin
      FMoveToNextLine := chkMoveToNextLine.Checked;
    end;
  finally
    Free;
  end;
end;

initialization
  RegisterCnEditor(TCnEditorCodeComment);
  RegisterCnEditor(TCnEditorCodeUnComment);
{$IFNDEF COMPILER9_UP}
  RegisterCnEditor(TCnEditorCodeToggleComment);
{$ENDIF}

{$ENDIF CNWIZARDS_CNEDITORWIZARD}
end.
