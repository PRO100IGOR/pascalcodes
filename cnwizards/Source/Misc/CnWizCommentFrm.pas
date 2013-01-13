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

unit CnWizCommentFrm;
{* |<PRE>
================================================================================
* ������ƣ�CnPack IDE ר�Ұ�
* ��Ԫ���ƣ�ר�ҹ�����ʾ���嵥Ԫ
* ��Ԫ���ߣ��ܾ��� (zjy@cnpack.org)
* ��    ע��
* ����ƽ̨��PWin2000Pro + Delphi 5.01
* ���ݲ��ԣ�PWin9X/2000/XP + Delphi 5/6/7 + C++Builder 5/6
* �� �� �����õ�Ԫ�е��ַ��������ϱ��ػ�����ʽ
* ��Ԫ��ʶ��$Id: CnWizCommentFrm.pas 763 2011-02-07 14:18:23Z liuxiao@cnpack.org $
* �޸ļ�¼��2002.10.17 V1.0
*               ������Ԫ
================================================================================
|</PRE>}

interface

{$I CnWizards.inc}

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, ExtCtrls, Registry, Menus, CnWizClasses, CnLangMgr, CnWizMultiLang,
  CnWizIni, CnWideStrings;

type
//==============================================================================
// ר�ҹ�����ʾ����
//==============================================================================

{ TCnWizCommentForm }

  TCnWizCommentForm = class(TCnTranslateForm)
    imgIcon: TImage;
    Label1: TLabel;
    Bevel1: TBevel;
    memHint: TMemo;
    Bevel2: TBevel;
    cbNotShow: TCheckBox;
    btnContinue: TButton;
    btnCancel: TButton;
    chkCloseAll: TCheckBox;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

function ShowCnWizCommentForm(Wizard: TCnBaseWizard;
  Command: string = ''): Boolean; overload;
{* ��ʾר�ҹ�����ʾ���壬����û���ǰ��ʾ���ô��岢ѡ�����Ժ�����ʾ������ø�
   ����ֱ�ӷ���Ϊ�档
   ��ʾ���ݽ���ͳһ���ļ��ж�ȡ�����÷�����Ҫ���ġ�
 |<PRE>
   Wizard: TCnBaseWizard    - ���ø÷�����ר��
   Command: string          - Ҫִ�е����Ĭ��Ϊ�գ���ר����ִ������
   Result: Boolean          - ����û����������������Ϊ�棬����Ϊ��
 |</PRE>}
function ShowCnWizCommentForm(const ACaption: string; AIcon: TIcon;
  Command: string): Boolean; overload;
{* ��ʾר�ҹ�����ʾ���壬����û���ǰ��ʾ���ô��岢ѡ�����Ժ�����ʾ������ø�
   ����ֱ�ӷ���Ϊ�档
   ��ʾ���ݽ���ͳһ���ļ��ж�ȡ�����÷�����Ҫ���ġ�
 |<PRE>
   ACaption: string         - ���ڱ���
   AIcon: TIcon             - ͼ��
   Command: string          - Ҫִ�е�����
   Result: Boolean          - ����û����������������Ϊ�棬����Ϊ��
 |</PRE>}

procedure ShowSimpleCommentForm(const ACaption: string; AText, Command: string;
  NextChecked: Boolean = True);
{* ��ʾ�򵥵���ʾ����
 |<PRE>
   ACaption: string         - ���ڱ���
   AText:    string         - ��ʾ����
   Command:  string         - ��ʶ������
   NextChecked: Boolean     - �Ƿ��ϡ��´β���ʾ��
 |</PRE>}

procedure ResetAllComment(Show: Boolean);
{* ���������е���ʾ��Ϣ��ʾ��������ʾ�Ƿ�������ʾ}

function GetCommandComment(Command: string): string;
{* ȡָ���������ʾ��Ϣ}

implementation

uses
  IniFiles, CnWizUtils, CnWizOptions, CnWizConsts, CnCommon;

{$R *.DFM}

const
  csOption = 'Option';
  csReturn = 'Return';
  csIndent = 'Indent';
  csComment = 'Comment';
  csDefReturn = '\n';

// ��ʾר�ҹ�����ʾ����
function ShowCnWizCommentForm(const ACaption: string; AIcon: TIcon;
  Command: string): Boolean;
var
  FileName: string;
  Comment: string;
  Show: Boolean;
  CRLF: string;
  Indent: Integer;
begin
  Result := True;
  if not WizOptions.ShowWizComment then Exit;
  if Command = '' then Exit;

  Show := WizOptions.ReadBool(SCnCommentSection, Command, True);
  if Show then
  begin
    FileName := GetFileFromLang(SCnWizCommentIniFile);
    if FileExists(FileName) then
      with TCnWideMemIniFile.Create(FileName) do
      try
        if not CheckWinVista and not ValueExists(csComment, Command) then
        begin
          WriteString(csComment, Command, '');  // �����������ݹ��༭
          Exit;
        end
        else
        begin
          Comment := ReadString(csComment, Command, '');
          if Comment = '' then Exit;
          with TCnWizCommentForm.Create(nil) do
          try
            ShowHint := WizOptions.ShowHint;
            CRLF := ReadString(csOption, csReturn, csDefReturn); // �ַ����еĻ��з�
            Indent := ReadInteger(csOption, csIndent, 0); // ��������
            Comment := Spc(Indent) + StringReplace(Comment, CRLF, #13#10 +
              Spc(Indent), [rfReplaceAll]);
            memHint.Lines.Text := Comment;
            if AIcon <> nil then
              imgIcon.Picture.Graphic := AIcon; // ר��ͼ��
            Caption := StripHotkey(ACaption);
            if ShowModal = mrOK then
            begin
              Result := True;
              WizOptions.WriteBool(SCnCommentSection, Command, not cbNotShow.Checked);
              WizOptions.ShowWizComment := not chkCloseAll.Checked;
            end
            else
              Result := False;
          finally
            Free;
          end;
        end;
      finally
        if not CheckWinVista then
          UpdateFile;
        Free;
      end;
  end;
end;

// ��ʾר�ҹ�����ʾ����
function ShowCnWizCommentForm(Wizard: TCnBaseWizard; Command: string): Boolean;
begin
  Assert(Assigned(Wizard));
  if Command = '' then
    Command := Wizard.GetIDStr;
  Result := ShowCnWizCommentForm(Wizard.WizardName, Wizard.Icon, Command);
end;

// ��ʾ�򵥵���ʾ����
procedure ShowSimpleCommentForm(const ACaption: string; AText, Command: string;
  NextChecked: Boolean);
var
  Show: Boolean;
begin
  if Command = '' then Exit;

  Show := WizOptions.ReadBool(SCnCommentSection, Command, True);
  if Show then
  begin
    with TCnWizCommentForm.Create(nil) do
    try
      ShowHint := WizOptions.ShowHint;
      memHint.Lines.Text := AText;
      if ACaption <> '' then
        Caption := StripHotkey(ACaption);
      chkCloseAll.Visible := False;
      btnCancel.Enabled := False;
      cbNotShow.Checked := NextChecked;
      
      ShowModal; // Don't Judge = mrOK for Saving when Direct Close.
      WizOptions.WriteBool(SCnCommentSection, Command, not cbNotShow.Checked);
    finally
      Free;
    end;
  end;
end;

// ȡָ���������ʾ��Ϣ
function GetCommandComment(Command: string): string;
var
  CRLF: string;
  Indent: Integer;
begin
  Result := '';
  with TCnWideMemIniFile.Create(GetFileFromLang(SCnWizCommentIniFile)) do
  try
    Result := ReadString(csComment, Command, '');
    if not CheckWinVista and (Result = '') then
    begin
      WriteString(csComment, Command, '');  // �����������ݹ��༭
      Exit;
    end;
    CRLF := ReadString(csOption, csReturn, csDefReturn); // �ַ����еĻ��з�
    Indent := ReadInteger(csOption, csIndent, 0); // ��������
    Result := Spc(Indent) + StringReplace(Result, CRLF, #13#10 +
      Spc(Indent), [rfReplaceAll]);
  finally
    if not CheckWinVista then
      UpdateFile;
    Free;
  end;
end;

// ���������е���ʾ��Ϣ��ʾ��������ʾ�Ƿ�������ʾ
procedure ResetAllComment(Show: Boolean);
var
  Values: TStrings;
  i: Integer;
begin
  Values := TStringList.Create;
  try
    with TCnWideMemIniFile.Create(GetFileFromLang(SCnWizCommentIniFile)) do
    try
      ReadSectionValues(csComment, Values);
    finally
      Free;
    end;

    with WizOptions.CreateRegIniFile do
    try
      for i := 0 to Values.Count - 1 do
        if Show then
          DeleteKey(SCnCommentSection, Values.Names[i])
        else
          WriteBool(SCnCommentSection, Values.Names[i], Show);
    finally
      Free;
    end;
  finally
    Values.Free;
  end;
end;

end.
