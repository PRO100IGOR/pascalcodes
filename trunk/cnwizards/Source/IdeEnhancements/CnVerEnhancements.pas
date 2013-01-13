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

unit CnVerEnhancements;
{ |<PRE>
================================================================================
* ������ƣ�CnPack IDE ר�Ұ�
* ��Ԫ���ƣ��汾��Ϣ��ǿר��
* ��Ԫ���ߣ���ʡ��hubdog��
* ��    ע����ר�Ҳ�֧��D5,C5
* ����ƽ̨��JWinXPPro + Delphi 7.01
* ���ݲ��ԣ�JWinXPPro ��Delphi7.����
* �� �� �����õ�Ԫ�е��ַ���֧�ֱ��ػ�����ʽ
* ��Ԫ��ʶ��$Id: CnVerEnhancements.pas 763 2011-02-07 14:18:23Z liuxiao@cnpack.org $
* �޸ļ�¼��2007.01.22 V1.0 by liuxiao
*               ʹ�ܴ˵�Ԫ��������Ӧ���޸�
*           2005.05.05 V1.0 by hubdog
*               ������Ԫ
================================================================================
|</PRE>}

interface

{$I CnWizards.inc}

{$IFDEF CNWIZARDS_CNVERENHANCEWIZARD}

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, ToolsAPI, IniFiles,
  Forms, ExtCtrls, Menus, ComCtrls, Contnrs, CnCommon, CnWizUtils, CnWizNotifier,
  CnWizIdeUtils, CnWizConsts, CnMenuHook, CnConsts, CnWizClasses;

type

//==============================================================================
// �汾��Ϣ��չר��
// Todo: �����Զ�������µİ汾��Ϣ����ͨ�õ�ģ�棬����վ���ƣ���˾���Ƶȵ�
//==============================================================================

{ TCnVerEnhanceWizard }

  TCnVerEnhanceWizard = class(TCnIDEEnhanceWizard)
  private
    FLastCompiled: Boolean;
    FIncBuild: Boolean;

    FBeforeBuildNo: Integer;
    FAfterBuildNo: Integer;
    FIncludeVer: Boolean;
    FCompileNotifierAdded: Boolean;
    function GetCompileNotifyEnabled: Boolean;
    procedure SetIncBuild(const Value: Boolean);
    procedure SetLastCompiled(const Value: Boolean);
  protected
    procedure BeforeCompile(const Project: IOTAProject; IsCodeInsight: Boolean;
      var Cancel: Boolean);
    procedure AfterCompile(Succeeded: Boolean; IsCodeInsight: Boolean);
    procedure InsertTime;
    procedure DeleteTime;

    function GetHasConfig: Boolean; override;
    procedure UpdateCompileNotify;
    property CompileNotifyEnabled: Boolean read GetCompileNotifyEnabled;
  public
    constructor Create; override;
    destructor Destroy; override;

    class procedure GetWizardInfo(var Name, Author, Email,
      Comment: string); override;
    procedure LoadSettings(Ini: TCustomIniFile); override;
    procedure SaveSettings(Ini: TCustomIniFile); override;
    procedure Config; override;

    property LastCompiled: Boolean read FLastCompiled write SetLastCompiled;
    property IncBuild: Boolean read FIncBuild write SetIncBuild;
  end;

{$ENDIF CNWIZARDS_CNVERENHANCEWIZARD}

implementation

{$IFDEF CNWIZARDS_CNVERENHANCEWIZARD}

uses
{$IFDEF DEBUG}
  CnDebug,
{$ENDIF}
  CnVerEnhanceFrm, VersionInfo;

const
  csDateKeyName = 'LastCompiledTime';

  csLastCompiled = 'LastCompiled';
  csIncBuild = 'IncBuild';

{ TCnVerEnhanceWizard }

procedure TCnVerEnhanceWizard.AfterCompile(Succeeded,
  IsCodeInsight: Boolean);
var
  Options: IOTAProjectOptions;
  Project: IOTAProject;
begin
  if IsCodeInsight or not Active then Exit;

  //ע��build project���ڱ���������buildno��
  //��������汾��Ϣ�����ִ���ļ����˳�
  if not FIncludeVer then Exit;

{$IFDEF DEBUG}
  CnDebugger.LogMsg('VerEnhance AfterCompile');
{$ENDIF}                                      
  Options := CnOtaGetActiveProjectOptions;
  if not Assigned(Options) then Exit;

  FAfterBuildNo := Options.GetOptionValue('Build');

{$IFDEF DEBUG}
  CnDebugger.LogMsg(Format('VerEnhance After Build No %d. Compile Succ %d.',
    [FAfterBuildNo, Integer(Succeeded)]));
{$ENDIF}

  Project := CnOtaGetCurrentProject;
  if not Assigned(Project) then
    Exit;

  if not Succeeded and FIncBuild and (FAfterBuildNo > FBeforeBuildNo) then
  begin
    // ����ʧ�ܣ��汾�ŸĻ�ȥ
{$IFDEF COMPILER6_UP} // ֻ D6 �����ϸĻذ汾�ţ�D5 ���� Bug ����Ч
    CnOtaSetProjectOptionValue(Options, 'Build', Format('%d', [FBeforeBuildNo]));
{$ENDIF}
{$IFDEF DEBUG}
    CnDebugger.LogMsg(Format('VerEnhance Compiling Fail. Set Back Build No %d.', [FBeforeBuildNo]));
{$ENDIF}
  end;

  if not FIncBuild and FLastCompiled then
  begin
    // ���İ汾��ʱ�����Ҫ����ʱ�䣬����Ҫ������дһ���ò���ʱ����Ч
{$IFDEF COMPILER6_UP} // ֻ D6 ���������Ӱ汾�ţ�D5 ���� Bug ����Ч
    CnOtaSetProjectOptionValue(Options, 'Build', Format('%d', [FAfterBuildNo]));
{$ENDIF}
  end;
end;

procedure TCnVerEnhanceWizard.BeforeCompile(const Project: IOTAProject;
  IsCodeInsight: Boolean; var Cancel: Boolean);
var
{$IFDEF COMPILER6_UP}
  I: Integer;
  ModuleFileEditor: IOTAEditor;
  ProjectResource: IOTAProjectResource;
  ResourceEntry: IOTAResourceEntry;
  VI: TVersionInfo;
  Stream: TMemoryStream;
{$ENDIF}
  Options: IOTAProjectOptions;
begin
  if IsCodeInsight then Exit;

{$IFDEF DEBUG}
  CnDebugger.LogMsg('VerEnhance BeforeCompile');
{$ENDIF}

  //Hubdog: ע�⣺ͨ�����dof�ļ�����ð汾��Ϣ��û���õģ���Ϊֻ����save project�󣬲ŻὫ�ڴ��е�
  //Hubdog: ��Щ��Ϣд��dof
  Options := CnOtaGetActiveProjectOptions(Project);
  if not Assigned(Options) then Exit;

  FIncludeVer := Options.GetOptionValue('IncludeVersionInfo') = '-1';
  if not FIncludeVer then Exit;

  FBeforeBuildNo := Options.GetOptionValue('Build');

  //�������ļ��汾��Ϣ, �޸�OptionValue��ֵ�Ϳ�����
  //Hubdog:SetProjectOptionValue��D5���޷��޸�Build, Release�Ȱ汾��Ϣ
  //������D5/BCB5/BCB6��һ��Bug)������D6����Ч
  if FIncBuild then
  begin
{$IFDEF COMPILER6_UP} // ֻ D6 ���������Ӱ汾�ţ�D5 ���� Bug ����Ч
    CnOtaSetProjectOptionValue(Options, 'Build', Format('%d', [FBeforeBuildNo + 1]));
{$ENDIF}
{$IFDEF DEBUG}
    CnDebugger.LogFmt('VerEnhance Set New Build No %d.', [FBeforeBuildNo + 1]);
{$ENDIF}
  end;

{$IFDEF COMPILER6_UP} // D6 �����ϲŴ������ʱ��

  //���LastCompileTime��Ϣ
  if Active and FLastCompiled then
  begin
  {$IFDEF DEBUG}
    CnDebugger.LogMsg('VerEnhance. Set LastCompiledTime ');
  {$ENDIF}
    InsertTime;
  end
  else
  begin
    DeleteTime;
    Exit;
  end;

  //Hubdog: ע�ⲻ���Ǳ��뻹��build���������ɰ汾��Ϣ��ֻ����һ������build no ,һ��������
  //Hubdog: ע�⣺������Auto-inc Build No��Ҳֻ�ǽ���ǰ�İ汾�ű����EXE��Ȼ�������BuildNo
  //LiuXiao: ��ע�⣺���¶� BDS 2005/20006 ��Ч�����ǵ� Bug �����޷���� Resource�ӿڣ����ƺ�ûӰ�졣
  for I := 0 to Project.GetModuleFileCount - 1 do
  begin
    ModuleFileEditor := CnOtaGetFileEditorForModule(Project, I);

    if Supports(ModuleFileEditor, IOTAProjectResource, ProjectResource) then
    begin
{$IFDEF DEBUG}
      CnDebugger.LogMsg('VerEnhance IOTAProjectResource Got.');
{$ENDIF}
    
      ResourceEntry := ProjectResource.FindEntry(RT_VERSION, PChar(1));
      if Assigned(ResourceEntry) then
      begin
        VI := TVersionInfo.Create(PChar(ResourceEntry.GetData));
        try
          Stream := TMemoryStream.Create;
          try
            VI.SaveToStream(Stream);
            ResourceEntry.DataSize := Stream.Size;
            Move(Stream.Memory^, ResourceEntry.GetData^, Stream.Size);
          finally
            Stream.Free;
          end;
        finally
          VI.Free;
        end;
      end;
    end
  end;
{$ENDIF}
end;

procedure TCnVerEnhanceWizard.Config;
begin
  // �������á�
  with TCnVerEnhanceForm.Create(nil) do
  try
    chkLastCompiled.Checked := FLastCompiled;
    chkIncBuild.Checked := FIncBuild;
    if ShowModal = mrOK then
    begin
      LastCompiled := chkLastCompiled.Checked;
      IncBuild := chkIncBuild.Checked;
      DoSaveSettings;
    end;
  finally
    Free;
  end;
end;

constructor TCnVerEnhanceWizard.Create;
begin
  inherited;
  CnWizNotifierServices.AddBeforeCompileNotifier(BeforeCompile);
  CnWizNotifierServices.AddAfterCompileNotifier(AfterCompile);
end;

procedure TCnVerEnhanceWizard.InsertTime;
var
  Keys: TStringList;
begin
  Keys := TStringList(CnOtaGetVersionInfoKeys);
  try
    Keys.Values[csDateKeyName] := DateTimeToStr(Now);
  except
    // ����D5/BCB5/BCB6����ģ�������
{$IFDEF DEBUG}
    CnDebugger.LogMsg('VerEnhance. Insert LastCompiledTime not Exists or Fail.');
{$ENDIF}
  end;
end;

procedure TCnVerEnhanceWizard.DeleteTime;
var
  Keys: TStringList;
  Index: Integer;
begin
  Keys := TStringList(CnOtaGetVersionInfoKeys);
  Keys.Values[csDateKeyName] := '';
  
  Index := Keys.IndexOfName(csDateKeyName);
  if Index > -1 then
  begin
    Keys.Delete(Index);
{$IFDEF DEBUG}
    CnDebugger.LogInteger(Index, 'VerEnhance VersionInfoKeys: DateTime.');
{$ENDIF}
  end;
end;

destructor TCnVerEnhanceWizard.Destroy;
begin
  if FCompileNotifierAdded then
  begin
    CnWizNotifierServices.RemoveAfterCompileNotifier(AfterCompile);
    CnWizNotifierServices.RemoveBeforeCompileNotifier(BeforeCompile);
    FCompileNotifierAdded := False;
  end;
  inherited;
end;

function TCnVerEnhanceWizard.GetHasConfig: Boolean;
begin
  Result := True;
end;

class procedure TCnVerEnhanceWizard.GetWizardInfo(var Name, Author, Email,
  Comment: string);
begin
  Name := SCnVerEnhanceWizardName;
  Author := SCnPack_Hubdog + ';' + SCnPack_LiuXiao;
  Email := SCnPack_HubdogEmail + ';' + SCnPack_LiuXiaoEmail;
  Comment := SCnVerEnhanceWizardComment;
end;


procedure TCnVerEnhanceWizard.LoadSettings(Ini: TCustomIniFile);
begin
  FLastCompiled := Ini.ReadBool('', csLastCompiled, False);
  FIncBuild := Ini.ReadBool('', csIncBuild, False);
  UpdateCompileNotify; // ��Ϊ����Ҫ�Ž���֪ͨ��������
end;

procedure TCnVerEnhanceWizard.SaveSettings(Ini: TCustomIniFile);
begin
  Ini.WriteBool('', csLastCompiled, FLastCompiled);
  Ini.WriteBool('', csIncBuild, FIncBuild);
end;

function TCnVerEnhanceWizard.GetCompileNotifyEnabled: Boolean;
begin
  Result := FIncBuild or FLastCompiled;
end;

procedure TCnVerEnhanceWizard.SetIncBuild(const Value: Boolean);
begin
  if FIncBuild <> Value then
  begin
    FIncBuild := Value;
    UpdateCompileNotify;
  end;
end;

procedure TCnVerEnhanceWizard.SetLastCompiled(const Value: Boolean);
begin
  if FLastCompiled <> Value then
  begin
    FLastCompiled := Value;
    UpdateCompileNotify;
  end;
end;

procedure TCnVerEnhanceWizard.UpdateCompileNotify;
begin
  if CompileNotifyEnabled and not FCompileNotifierAdded then
  begin
    // ����Ҫ������ǰû֪ͨ��������
    CnWizNotifierServices.AddBeforeCompileNotifier(BeforeCompile);
    CnWizNotifierServices.AddAfterCompileNotifier(AfterCompile);
    FCompileNotifierAdded := True;
  end
  else if not CompileNotifyEnabled and FCompileNotifierAdded then
  begin
    // ����Ҫ������ǰ��֪ͨ����ɾ��
    CnWizNotifierServices.RemoveAfterCompileNotifier(AfterCompile);
    CnWizNotifierServices.RemoveBeforeCompileNotifier(BeforeCompile);
    FCompileNotifierAdded := False;
  end;
end;

initialization
{$IFDEF COMPILER6_UP} // D5/BCB5/BCB6 ���� OTA Bug ����Ч���ʲ�ע��
{$IFNDEF BCB6}
  RegisterCnWizard(TCnVerEnhanceWizard);
{$ENDIF}
{$ENDIF}

{$ENDIF CNWIZARDS_CNVERENHANCEWIZARD}
end.

 
