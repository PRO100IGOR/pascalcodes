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

unit CnEditorInsertTime;
{* |<PRE>
================================================================================
* ������ƣ�CnPack IDE ר�Ұ�
* ��Ԫ���ƣ���������ʱ�乤��
* ��Ԫ���ߣ���Х (liuxiao@cnpack.org)
* ��    ע��
* ����ƽ̨��PWinXP SP2 + Delphi 5.01
* ���ݲ��ԣ�PWin9X/2000/XP + Delphi 5/6/7 + C++Builder 5/6
* �� �� �����ô����е��ַ��������ϱ��ػ�����ʽ
* ��Ԫ��ʶ��$Id: CnEditorInsertTime.pas 763 2011-02-07 14:18:23Z liuxiao@cnpack.org $
* �޸ļ�¼��2005.11.24 V1.0
*               ������Ԫ��ʵ�ֹ���
================================================================================
|</PRE>}

interface

{$I CnWizards.inc}

{$IFDEF CNWIZARDS_CNEDITORWIZARD}

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, IniFiles, ToolsAPI, CnWizUtils, CnConsts, CnCommon, CnEditorWizard,
  CnWizConsts, CnEditorCodeTool, CnIni, CnWizMultiLang;

type

//==============================================================================
// ������ɫ������
//==============================================================================

{ TCnEditorInsertTime }

  TCnEditorInsertTime = class(TCnBaseEditorTool)
  private
    FDateTimeFmt: string;
  public
    constructor Create(AOwner: TCnEditorWizard); override;
    destructor Destroy; override;
    function GetCaption: string; override;
    function GetHint: string; override;
    procedure GetEditorInfo(var Name, Author, Email: string); override;
    function GetState: TWizardState; override;
    procedure Execute; override;
  published
    property DateTimeFmt: string read FDateTimeFmt write FDateTimeFmt;
  end;

  TCnEditorInsertTimeForm = class(TCnTranslateForm)
    cbbDateTimeFmt: TComboBox;
    lblFmt: TLabel;
    lblPreview: TLabel;
    edtPreview: TEdit;
    btnOK: TButton;
    btnCancel: TButton;
    procedure cbbDateTimeFmtChange(Sender: TObject);
  private
    { Private declarations }
  public
    procedure UpdateDateTimeStr;
    { Public declarations }
  end;

{$ENDIF CNWIZARDS_CNEDITORWIZARD}

implementation

{$IFDEF CNWIZARDS_CNEDITORWIZARD}

{$R *.dfm}

{ TCnEditorInsertTime }

constructor TCnEditorInsertTime.Create(AOwner: TCnEditorWizard);
begin
  inherited;

end;

destructor TCnEditorInsertTime.Destroy;
begin

  inherited;
end;

function TCnEditorInsertTime.GetCaption: string;
begin
  Result := SCnEditorInsertTimeMenuCaption;
end;

function TCnEditorInsertTime.GetHint: string;
begin
  Result := SCnEditorInsertTimeMenuHint;
end;

procedure TCnEditorInsertTime.GetEditorInfo(var Name, Author, Email: string);
begin
  Name := SCnEditorInsertTimeName;
  Author := SCnPack_LiuXiao;
  Email := SCnPack_LiuXiaoEmail;
end;

procedure TCnEditorInsertTime.Execute;
begin
  with TCnEditorInsertTimeForm.Create(nil) do
  begin
    if FDateTimeFmt = '' then
      cbbDateTimeFmt.ItemIndex := 0
    else
      cbbDateTimeFmt.Text := FDateTimeFmt;
    UpdateDateTimeStr;

    if ShowModal = mrOK then
    begin
      FDateTimeFmt := cbbDateTimeFmt.Text;
      CnOtaInsertTextToCurSource(edtPreview.Text, ipCur);
    end;
    Free;
  end;
end;

function TCnEditorInsertTime.GetState: TWizardState;
begin
  Result := inherited GetState;
  if (wsEnabled in Result) and not CurrentIsSource then
    Result := [];
end;

{ TCnInsertTimeForm }

procedure TCnEditorInsertTimeForm.UpdateDateTimeStr;
begin
  try
    edtPreview.Text := FormatDateTime(cbbDateTimeFmt.Text, Date + Time);
  except
    ;
  end;
end;

procedure TCnEditorInsertTimeForm.cbbDateTimeFmtChange(Sender: TObject);
begin
  UpdateDateTimeStr;
end;

initialization
  RegisterCnEditor(TCnEditorInsertTime);
  
{$ENDIF CNWIZARDS_CNEDITORWIZARD}
end.
