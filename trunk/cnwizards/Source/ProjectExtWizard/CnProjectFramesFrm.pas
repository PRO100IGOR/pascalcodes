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

unit CnProjectFramesFrm;
{ |<PRE>
================================================================================
* ������ƣ�CnPack IDE ר�Ұ�
* ��Ԫ���ƣ���������� Frame �б���
* ��Ԫ���ߣ���ΰ��Alan�� BeyondStudio@163.com
* ��    ע��
* ����ƽ̨��PWinXPPro + Delphi 5.01
* ���ݲ��ԣ�PWin9X/2000/XP + Delphi 5/6/7 + C++Builder 5/6
* �� �� �����ô����е��ַ��������ϱ��ػ�����ʽ
* ��Ԫ��ʶ��$Id: CnProjectFramesFrm.pas 763 2011-02-07 14:18:23Z liuxiao@cnpack.org $
* �޸ļ�¼��2007.04.27 V1.0
*               ������Ԫ
================================================================================
|</PRE>}

interface

{$I CnWizards.inc}

{$IFDEF CNWIZARDS_CNPROJECTEXTWIZARD}

uses
  Windows, Messages, SysUtils, Classes, Controls, Forms, Dialogs, Contnrs,
{$IFDEF COMPILER6_UP}
  StrUtils,
{$ENDIF}
  ComCtrls, StdCtrls, ExtCtrls, Math, ToolWin, Clipbrd, IniFiles, ToolsAPI,
  Graphics, ImgList, ActnList,
  CnCommon, CnConsts, CnWizConsts, CnWizOptions, CnWizUtils, CnIni,
  CnWizMultiLang, CnProjectViewBaseFrm, CnWizDfmParser, CnProjectViewFormsFrm;

type

//==============================================================================
// ��������� Frame �б���
//==============================================================================

{ TCnProjectFramesForm }

  TCnProjectFramesForm = class(TCnProjectViewFormsForm)
    procedure lvListData(Sender: TObject; Item: TListItem);
  protected
    procedure OpenSelect; override;
    function GetHelpTopic: string; override;
    procedure CreateList; override;
    procedure UpdateStatusBar; override;
  public
    { Public declarations }
  end;

{$ENDIF CNWIZARDS_CNPROJECTEXTWIZARD}

implementation

{$IFDEF CNWIZARDS_CNPROJECTEXTWIZARD}

{$R *.DFM}

{$IFDEF DEBUG}
uses
  CnDebug;
{$ENDIF}

const
  SFrameOfForm = 'TFrame';
  SDataMoudleOfForm = 'TDataModule';

type
  TControlAccess = class(TControl);

//==============================================================================
// ��������� Frame �б���
//==============================================================================

{ TCnProjectFramesForm }

procedure TCnProjectFramesForm.CreateList;
var
  ProjectInfo: TCnProjectInfo;
  FormInfo: TCnFormInfo;
  i, j: Integer;
  FormFileName: string;
  IProject: IOTAProject;
  IModuleInfo: IOTAModuleInfo;
  ProjectInterfaceList: TInterfaceList;
  Exists: Boolean;
{$IFDEF BDS}
  ProjectGroup: IOTAProjectGroup;
{$ENDIF}

  function GetDfmInfoFromIDE(const AFileName: string; AInfo: TCnFormInfo): Boolean;
  var
    IModule: IOTAModule;
    IFormEditor: IOTAFormEditor;
    Comp: TComponent;
  begin
    Result := False;
    try
      IModule := CnOtaGetModule(AFileName);
      if not Assigned(IModule) then
        Exit;

      IFormEditor := CnOtaGetFormEditorFromModule(IModule);
      if not Assigned(IFormEditor) then
        Exit;

      Comp := CnOtaGetRootComponentFromEditor(IFormEditor);
      if Assigned(Comp) and (Comp is TControl) then
      begin
        AInfo.FormClass := Comp.ClassName;
        AInfo.Name := Comp.Name;
        AInfo.Caption := TControlAccess(Comp).Caption;
        AInfo.Left := TControl(Comp).Left;
        AInfo.Top := TControl(Comp).Top;
        AInfo.Width := TControl(Comp).Width;
        AInfo.Height := TControl(Comp).Height;
        Result := True;
      end;
    except
      ;
    end;
  end;
begin
  ProjectInterfaceList := TInterfaceList.Create;
  try
    CnOtaGetProjectList(ProjectInterfaceList);

    try
      for i := 0 to ProjectInterfaceList.Count - 1 do
      begin
        IProject := IOTAProject(ProjectInterfaceList[i]);

        if IProject.FileName = '' then
          Continue;

{$IFDEF BDS}
        // BDS ��ProjectGroup Ҳ֧�� Project �ӿڣ������Ҫȥ��
        if Supports(IProject, IOTAProjectGroup, ProjectGroup) then
          Continue;
{$ENDIF}

        ProjectInfo := TCnProjectInfo.Create;
        ProjectInfo.Name := ExtractFileName(IProject.FileName);
        ProjectInfo.FileName := IProject.FileName;

        // ��Ӵ�����Ϣ�� FormInfo
        for j := 0 to IProject.GetModuleCount - 1 do
        begin
          IModuleInfo := IProject.GetModule(j);
          if IModuleInfo.FormName = '' then
            Continue;
          if UpperCase(ExtractFileExt(IModuleInfo.FormName)) = '.RES' then
            Continue;
{$IFDEF DEBUG}
          CnDebugger.LogFmt('Frames: IModuleInfo DesignClass is %s.', [IModuleInfo.DesignClass]);
          if GetClass(IModuleInfo.DesignClass) <> nil then
            CnDebugger.LogFmt('Frames: IModuleInfo DesignClass Found. Parent is %s.', [GetClass(IModuleInfo.DesignClass).ClassParent.ClassName]);
{$ENDIF}
          if Trim(IModuleInfo.DesignClass) = '' then
            Continue;

          if IModuleInfo.DesignClass <> SFrameOfForm then
          begin
            if GetClass(IModuleInfo.DesignClass) = nil then
              Continue
            else if not GetClass(IModuleInfo.DesignClass).InheritsFrom(TCustomFrame) then
              Continue;
          end;

          FormFileName := ChangeFileExt(IModuleInfo.FileName, '.dfm');
          Exists := FileExists(FormFileName);
          if not Exists then
          begin
            FormFileName := ChangeFileExt(IModuleInfo.FileName, '.nfm'); // VCL.NET
            Exists := FileExists(FormFileName);
            if not Exists then
            begin
              FormFileName := ChangeFileExt(IModuleInfo.FileName, '.xfm'); // CLX, Kylix
              Exists := FileExists(FormFileName);
            end;
          end;

          if not Exists then
          begin
            // todo: Get default form name
            FormFileName := ChangeFileExt(IModuleInfo.FileName, '.dfm');
          end;

          FormInfo := TCnFormInfo.Create;
          with FormInfo do
          begin
            Name := IModuleInfo.FormName;
            FileName := FormFileName;
            Project := ExtractFileName(IProject.FileName);
            DesignClass := IModuleInfo.DesignClass;
            IsOpened := CnOtaIsFormOpen(Name);
            
            if Exists then
            begin
              Size := GetFileSize(FormFileName);
              ParseDfmFile(FormFileName, FormInfo);
            end
            else
            begin
              Size := 0;
              Format := dfUnknown;
            end;
          end;

          GetDfmInfoFromIDE(IModuleInfo.FileName, FormInfo);
          FillFormInfo(FormInfo);
          ProjectInfo.InfoList.Add(FormInfo);  // ��Ӵ�����Ϣ�� ProjectRecord
        end;

        ProjectList.Add(ProjectInfo);  // PProjectRecord �а���ģ����Ϣ
      end;
    except
      raise Exception.Create(SCnProjExtCreatePrjListError);
    end;
  finally
    ProjectInterfaceList.Free;
  end;
end;

function TCnProjectFramesForm.GetHelpTopic: string;
begin
  Result := 'CnProjectExtFrames';
end;

procedure TCnProjectFramesForm.OpenSelect;
begin
  if lvList.SelCount > 0 then
    ModalResult := mrOK;
end;

procedure TCnProjectFramesForm.UpdateStatusBar;
begin
  with StatusBar do
  begin
    Panels[1].Text := Format(SCnProjExtProjectCount, [ProjectList.Count]);
    Panels[2].Text := Format(SCnProjExtFramesFileCount, [lvList.Items.Count]);
  end;
end;

procedure TCnProjectFramesForm.lvListData(Sender: TObject;
  Item: TListItem);
var
  Info: TCnFormInfo;
begin
  if (Item.Index >= 0) and (Item.Index < CurrList.Count) then
  begin
    Info := TCnFormInfo(CurrList[Item.Index]);
    Item.Caption := Info.Name;
    Item.ImageIndex := Info.ImageIndex;
    Item.Data := Info;

    with Item.SubItems do
    begin
      Add(Info.DesignClassText);
      Add(Info.Project);
      Add(IntToStrSp(Info.Size));
      Add(SDfmFormats[Info.Format]);
    end;
  end;
end;

{$ENDIF CNWIZARDS_CNPROJECTEXTWIZARD}
end.
