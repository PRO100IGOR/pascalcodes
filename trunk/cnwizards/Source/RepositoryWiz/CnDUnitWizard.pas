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

unit CnDUnitWizard;
{ |<PRE>
================================================================================
* ������ƣ�CnPack IDE ר�Ұ�
* ��Ԫ���ƣ�DUnit ��Ԫ���Թ������ɵ�Ԫ
* ��Ԫ���ߣ�������SQUALL��
��          LiuXiao ��liuxiao@cnpack.org��
* ��    ע��DUnit ��Ԫ���Թ������ɵ�Ԫ
* ����ƽ̨��Windows 2000 + Delphi 5
* ���ݲ��ԣ�PWin9X/2000/XP + Delphi 5/6/7
* �� �� �����ô����е��ַ��������ϱ��ػ�����ʽ
* ��Ԫ��ʶ��$Id: CnDUnitWizard.pas 763 2011-02-07 14:18:23Z liuxiao@cnpack.org $
* �޸ļ�¼��2003.10.15 V1.0
*               LiuXiao ��ֲ�˵�Ԫ
================================================================================
|</PRE>}

interface

{$I CnWizards.inc}

{$IFDEF CNWIZARDS_CNDUNITWIZARD}

uses
  Windows, SysUtils, Classes, Forms, Controls, ToolsApi,
  CnWizClasses, CnConsts, CnWizConsts, CnCommon, CnWizUtils, CnWizOptions,
  CnOTACreators;

type
  TCnDUnitWizard = class(TCnProjectWizard)
  private
    FIsAddHead: Boolean;
    FIsAddInit: Boolean;
    FCreatorType: TCnCreatorType;
  public
    class procedure GetWizardInfo(var Name, Author, Email, Comment: string); override;
    procedure Execute; override;

    property IsAddHead: Boolean read FIsAddHead write FIsAddHead;
    {* �Ƿ���ӵ�Ԫͷ }
    property IsAddInit: Boolean read FIsAddInit write FIsAddInit;
    {* �Ƿ�����ʼ�������� }
    property CreatorType: TCnCreatorType read FCreatorType write FCreatorType;
    {* �������̻��Ǵ�����Ԫ }
  end;

  TCnDUnitProjectCreator = class(TCnTemplateProjectCreator)
  private
    FIsAddHead: Boolean;
    FIsAddInit: Boolean;

  protected
    function GetTemplateFile(FileType: TCnSourceType): string; override;
    {* �������ṩ��ͬ�����ļ��ľ���ģ���ļ��� }
  public
    procedure NewDefaultModule; override;
    {* �½���Ŀʱ��Ҫ����Ĭ��ģ���ʱ����� }

    property IsAddHead: Boolean read FIsAddHead write FIsAddHead;
    property IsAddInit: Boolean read FIsAddInit write FIsAddInit;
  end;

  TCnDUnitModuleCreator = class(TCnTemplateModuleCreator)
  private
    FIsAddHead: Boolean;
    FIsAddInit: Boolean;

  protected
    function GetTemplateFile(FileType: TCnSourceType): string; override;
    {* �������ṩ��ͬ�����ļ��ľ���ģ���ļ��� }
    procedure DoReplaceTagsSource(const TagString: string; TagParams:
        TStrings; var ReplaceText: string; ASourceType: TCnSourceType; ModuleIdent,
        FormIdent, AncestorIdent: string); override;
    {* ���ش˺���ʵ�� ModuleCreator ��ģ�� Tag �滻 }
  public
    property IsAddHead: Boolean read FIsAddHead write FIsAddHead;
    property IsAddInit: Boolean read FIsAddInit write FIsAddInit;
  end;

var
  SCnDUnitProjectTemplateFile: string = 'CnDUnitProject.dpr';
  SCnDUnitModuleTemplateFile: string = 'CnDUnitUnit.pas';

  SCnDUnitCommentHeadFmt: string =
    '{******************************************************************************}' + CRLF +
    '{                                                                              }' + CRLF +
    '{          %s                                                          }' + CRLF +
    '{          %s                                                          }' + CRLF +
    '{          %s                                                          }' + CRLF +
    '{          %s                                                          }' + CRLF +
    '{          %s                                                          }' + CRLF +
    '{                                                                              }' + CRLF +
    '{******************************************************************************}' + CRLF
    + CRLF;

  SCnDUnitInitIntf: string =
    '  protected' + CRLF +
    '    procedure SetUp; override;' + CRLF +
    '    procedure TearDown; override;' + CRLF
    + CRLF;

  SCnDUnitInitImpl: string =
    'procedure TTest.Setup;' + CRLF +
    'begin' + CRLF + CRLF +
    'end;' + CRLF + CRLF +
    'procedure TTest.TearDown;' + CRLF +
    'begin' + CRLF + CRLF +
    'end;' + CRLF + CRLF +
    'procedure TTest.Test;' + CRLF +
    'begin' + CRLF + CRLF +
    'end;' + CRLF + CRLF;

{$ENDIF CNWIZARDS_CNDUNITWIZARD}

implementation

{$IFDEF CNWIZARDS_CNDUNITWIZARD}

uses
  CnDUnitSetFrm;

const
  csCommentHead = 'CommentHead';
  csInitIntf = 'InitIntf';
  csInitImpl = 'InitImpl';

{ TCnDUnitWizard }

class procedure TCnDUnitWizard.GetWizardInfo(var Name, Author, Email,
  Comment: string);
begin
  Name := SCnDUnitWizardName;
  Author := SCnPack_SQuall + ';' + SCnPack_LiuXiao;
  Email := SCnPack_SQuallEmail + ';' + SCnPack_LiuXiaoEmail;
  Comment := SCnDUnitWizardComment;
end;

procedure TCnDUnitWizard.Execute;
var
  ModuleCreator: TCnBaseCreator;
begin
  with TCnDUnitSetForm.Create(nil) do
  begin
    try
      IsAddHead := Self.IsAddHead;
      IsAddInit := Self.IsAddInit;
      CreatorType := Self.CreatorType;
      if ShowModal = mrOK then
      begin
        Self.IsAddHead := IsAddHead;
        Self.IsAddInit := IsAddInit;
        Self.CreatorType := CreatorType;
        ModuleCreator := nil;

        case Self.CreatorType of
        ctProject:
          begin
            ModuleCreator := TCnDUnitProjectCreator.Create;
            TCnDUnitProjectCreator(ModuleCreator).IsAddHead := Self.IsAddHead;
            TCnDUnitProjectCreator(ModuleCreator).IsAddInit := Self.IsAddInit;
          end;
        ctPascalUnit:
          begin
            if not IsDelphiRuntime then
            begin
              ErrorDlg(SCnDUnitErrorNOTSupport);
              Exit;
            end;
            
            ModuleCreator := TCnDUnitModuleCreator.Create;
            TCnDUnitModuleCreator(ModuleCreator).IsAddHead := Self.IsAddHead;
            TCnDUnitModuleCreator(ModuleCreator).IsAddInit := Self.IsAddInit;
          end;
        end;
        (BorlandIDEServices as IOTAModuleServices).CreateModule(ModuleCreator);
      end;
    finally
      Free;
    end;
  end;
end;

{ TCnDUnitModuleCreator }

procedure TCnDUnitModuleCreator.DoReplaceTagsSource(const TagString:
  string; TagParams: TStrings; var ReplaceText: string; ASourceType:
  TCnSourceType; ModuleIdent, FormIdent, AncestorIdent: string);
begin
  if ASourceType = stImplSource then
  begin
    if TagString = csCommentHead then
    begin
      if Self.IsAddHead then
        ReplaceText := Format(SCnDUnitCommentHeadFmt, [SCnDUnitTestName,
          SCnDUnitTestAuthor, SCnDUnitTestVersion,
          SCnDUnitTestDescription, SCnDUnitTestComments])
      else
        ReplaceText := '';
    end
    else if TagString = csInitIntf then
    begin
      if Self.IsAddInit then
        ReplaceText := SCnDUnitInitIntf
      else
        ReplaceText := '';
    end
    else if TagString = csInitImpl then
    begin
      if Self.IsAddInit then
        ReplaceText := SCnDUnitInitImpl
      else
        ReplaceText := '';
    end;
  end;
end;

function TCnDUnitModuleCreator.GetTemplateFile(FileType: TCnSourceType): string;
begin
  if FileType = stImplSource then
    Result := MakePath(WizOptions.TemplatePath) + SCnDUnitModuleTemplateFile
  else
    Result := '';
end;

{ TCnDUnitProjectCreator }

procedure TCnDUnitProjectCreator.NewDefaultModule;
var
  ModuleCreator: TCnDUnitModuleCreator;
begin
  ModuleCreator := TCnDUnitModuleCreator.Create;
  TCnDUnitModuleCreator(ModuleCreator).IsAddHead := Self.IsAddHead;
  TCnDUnitModuleCreator(ModuleCreator).IsAddInit := Self.IsAddInit;
  (BorlandIDEServices as IOTAModuleServices).CreateModule(ModuleCreator);
end;

function TCnDUnitProjectCreator.GetTemplateFile(FileType: TCnSourceType): string;
begin
  if FileType = stProjectSource then
    Result := MakePath(WizOptions.TemplatePath) + SCnDUnitProjectTemplateFile
  else
    Result := '';
end;

initialization
  {$IFDEF DELPHI}
  {$IFNDEF BDS}
  // BDS �²�ע���ר�ң���Ϊ�Ѿ����Դ�����
  RegisterCnWizard(TCnDUnitWizard);
  {$ENDIF}
  {$ENDIF}

{$ENDIF CNWIZARDS_CNDUNITWIZARD}
end.
