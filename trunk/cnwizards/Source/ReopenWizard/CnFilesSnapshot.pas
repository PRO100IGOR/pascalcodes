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

unit CnFilesSnapshot;
{ |<PRE>
================================================================================
* ������ƣ�CnPack IDE ר�Ұ�
* ��Ԫ���ƣ��ļ��б���յ�Ԫ
* ��Ԫ���ߣ��ܺ㣨beta�� xbeta@tom.com
* ��    ע��
* ����ƽ̨��PWin2000Pro + Delphi 7
* ���ݲ��ԣ�PWin2000Pro + Delphi 6/7
* �� �� �����õ�Ԫ�е��ַ��������ϱ��ػ�����ʽ
* ��Ԫ��ʶ��$Id: CnFilesSnapshot.pas 763 2011-02-07 14:18:23Z liuxiao@cnpack.org $
* �޸ļ�¼��2007.08.01 V1.3
*               beta Ĭ�����ȴ򿪹������ļ��������ļ�
*               �����������������
*           2004.07.22 V1.2
*               LiuXiao ����ר�Ҵӹ�����չ�����ж��������ɵ����Ӳ˵���ר��
*               ��������ʷ�ļ��ƶ������С�
*           2004.06.01 V1.1
*               LiuXiao �޸ĵ�ֻ����һ���б��Ӳ˵�ʱ"����־"��������û��ֵ������
*           2004.04.23 V1.0
*               ������Ԫ
================================================================================
|</PRE>}

interface

{$I CnWizards.inc}

{$IFDEF CNWIZARDS_CNFILESSNAPSHOTWIZARD}

uses
  Windows, Messages, SysUtils, Classes, Controls, Forms, Dialogs, ActnList,
  ToolsAPI, IniFiles, ShellAPI, Menus, CnCommon, CnWizClasses, CnWizUtils,
  CnConsts, CnWizConsts, CnFilesSnapshotManageFrm, CnWizOptions, CnWizIdeUtils,
  CnRoWizard;

type

//==============================================================================
// �ļ��б����ר��
//==============================================================================

{ TCnFilesSnapshotWizard }

  TCnFilesSnapshotWizard = class(TCnSubMenuWizard)
  private
    FExecuting: Boolean;
    // ��һ��ִ����ӿ��յ�ʱ�䣬���ڷ�ֹһ�� bug����� FilesSnapshotAdd ����
    FLastAddExecuteTick: DWord;
    IdFilesSnapshotsFirst: Integer;
    IdFilesSnapshotsLast: Integer;
    IdFilesSnapshotAdd: Integer;
    IdFilesSnapshotManage: Integer;
    IdReopen: Integer;
    FFilesSnapshots: TStringList;
    FReOpener: TCnFileReopener;
    FSnapSection: string;
    procedure InternalLoadSettings(Ini: TCustomIniFile);
    procedure InternalSaveSettings(Ini: TCustomIniFile);
    procedure FilesSnapshotAdd;
    procedure FilesSnapshotManage;
    function IsAnyFileOpen: Boolean;
    procedure FilesRestore(Index: Integer);
  protected
    procedure SetActive(Value: Boolean); override;
    function GetHasConfig: Boolean; override;
    procedure SubActionExecute(Index: Integer); override;
    procedure SubActionUpdate(Index: Integer); override;
  public
    constructor Create; override;
    destructor Destroy; override;
    function GetState: TWizardState; override;
    procedure AcquireSubActions; override;
    class procedure GetWizardInfo(var Name, Author, Email, Comment: string); override;
    function GetCaption: string; override;
    function GetHint: string; override;
    procedure LoadSettings(Ini: TCustomIniFile); override;
    procedure SaveSettings(Ini: TCustomIniFile); override;
    procedure Config; override;
  end;

{$ENDIF CNWIZARDS_CNFILESSNAPSHOTWIZARD}

implementation

{$IFDEF CNWIZARDS_CNFILESSNAPSHOTWIZARD}

{$IFDEF DEBUG}
uses
  CnDebug;
{$ENDIF}

// todo: �ⲿ�ִ���Ӧ����ȡ����Ӧ��Ԫ���½���Ԫ�У���������ط�Ҳ��Ҫ
type
  TCnSourceFileType = (sftGroup, sftProject, sftHeader, sftUnit, sftForm, sftOthers);

function GetSourceFileType(const AFileName: string): TCnSourceFileType;
begin
  Result := sftOthers;
  // todo: �����û�����Ĳ�ͬ����Դ�ļ���չ����Ӧ��������࣬�Ա���˴���Ӳ����
  if FileMatchesExts(AFileName, '.bpg;.bdsgroup;.groupproj') then
    Result := sftGroup
  else if FileMatchesExts(AFileName, '.dpr;.dpk;.bdsproj;.dproj;.cbproj;.bpr;.bpk') then
    Result := sftProject
  else if FileMatchesExts(AFileName, '.h;.hpp') then
    Result := sftHeader
  else if FileMatchesExts(AFileName, '.pas;.c;.cpp') then
    Result := sftUnit
  else if FileMatchesExts(AFileName, '.dfm;.xfm') then
    Result := sftForm
end;

//==============================================================================
// �ļ��б����ר��
//==============================================================================

const
  csSnapshots = 'Snapshots';

{ TCnFilesSnapshotWizard }

constructor TCnFilesSnapshotWizard.Create;
begin
  inherited;
  FExecuting := False;
  FLastAddExecuteTick := 0;
  FFilesSnapshots := TStringList.Create;
  FReOpener := TCnFileReopener.Create;
  FSnapSection := csSnapshots + '.' + WizOptions.CompilerID;
end;

destructor TCnFilesSnapshotWizard.Destroy;
var
  i: Integer;
begin
  for i := 0 to FFilesSnapshots.Count - 1 do
    FFilesSnapshots.Objects[i].Free;
  FFilesSnapshots.Free;
  FReOpener.Free;
  inherited;
end;

procedure TCnFilesSnapshotWizard.AcquireSubActions;
var
  i: Integer;
begin
  // ��û�п��գ��򲻱ش������ղ˵���ͷָ���
  if FFilesSnapshots.Count > 0 then
  begin
    // �������ղ˵���
    i := 0;
    IdFilesSnapshotsFirst := RegisterASubAction(SCnProjExtFilesSnapshotsItem +
      IntToStr(i), FFilesSnapshots[i], 0, FFilesSnapshots[i],
      SCnProjExtFilesSnapshotsItem + IntToStr(i));
    IdFilesSnapshotsLast := IdFilesSnapshotsFirst; // �������汻������û��ֵ��LiuXiao
    for i := 1 to FFilesSnapshots.Count - 1 do
      IdFilesSnapshotsLast := RegisterASubAction(SCnProjExtFilesSnapshotsItem +
        IntToStr(i), FFilesSnapshots[i], 0, FFilesSnapshots[i],
        SCnProjExtFilesSnapshotsItem + IntToStr(i));

    AddSepMenu;
  end
  else
  begin
    IdFilesSnapshotsFirst := -1;
    IdFilesSnapshotsLast := -1;
  end;

  // ����������Ӳ˵���
  IdFilesSnapshotAdd := RegisterASubAction(SCnProjExtFilesSnapshotAdd,
    SCnFilesSnapshotAddCaption, ShortCut(Word('W'), [ssCtrl, ssShift]),
    SCnFilesSnapshotAddHint, SCnProjExtFilesSnapshotAdd);

  IdFilesSnapshotManage := RegisterASubAction(SCnProjExtFilesSnapshotManage,
    SCnFilesSnapshotManageCaption, 0,
    SCnFilesSnapshotManageHint, SCnProjExtFilesSnapshotManage);
  AddSepMenu;

  IdReopen := RegisterASubAction(SCnProjExtFileReopen,
    SCnProjExtFileReopenCaption, FReOpener.GetDefShortCut,
    SCnProjExtFileReopenHint, SCnProjExtFileReopen);
end;

function TCnFilesSnapshotWizard.GetCaption: string;
begin
  Result := SCnFilesSnapshotWizardCaption;
end;

function TCnFilesSnapshotWizard.GetHasConfig: Boolean;
begin
  Result := True;
end;

function TCnFilesSnapshotWizard.GetHint: string;
begin
  Result := SCnFilesSnapshotWizardHint;
end;

function TCnFilesSnapshotWizard.GetState: TWizardState;
begin
  Result := [wsEnabled];
end;

class procedure TCnFilesSnapshotWizard.GetWizardInfo(var Name, Author, Email,
  Comment: string);
begin
  Name := SCnFilesSnapshotWizardName;
  Author := SCnPack_Beta + ';' + SCnPack_Leeon + ';' + SCnPack_LiuXiao;
  Email := SCnPack_BetaEmail + ';' + SCnPack_LeeonEmail + ';' + SCnPack_LiuXiaoEmail;
  Comment := SCnFilesSnapshotWizardComment;
end;

procedure TCnFilesSnapshotWizard.SubActionExecute(Index: Integer);
begin
  if not Active or FExecuting then Exit;
  FExecuting := True;
  try
    case IndexInt(Index, [IdFilesSnapshotAdd, IdFilesSnapshotManage, IdReopen]) of
      0:        // IdFilesSnapshotAdd
        FilesSnapshotAdd;
      1:        // IdFilesSnapshotManage
        FilesSnapshotManage;
      2:
        FReOpener.Execute;
      else
      begin
        if (Index <= IdFilesSnapshotsLast) and (Index >= IdFilesSnapshotsFirst) then
          FilesRestore(Index - IdFilesSnapshotsFirst);
      end;
    end;
  finally
    FExecuting := False;
  end;
end;

procedure TCnFilesSnapshotWizard.SubActionUpdate(Index: Integer);
begin
  inherited;
  case IndexInt(Index, [IdFilesSnapshotAdd, IdFilesSnapshotManage, IdReopen]) of
    0:  // IdFilesSnapshotAdd
      SubActions[IdFilesSnapshotAdd].Enabled := IsAnyFileOpen;
    1:  // IdFilesSnapshotManage
      SubActions[IdFilesSnapshotManage].Enabled := FFilesSnapshots.Count > 0;
    2:
      SubActions[IdReopen].Enabled := True;
  end;
end;

procedure TCnFilesSnapshotWizard.FilesSnapshotAdd;

  // ��ȡ�Ѿ��򿪵��ļ����б�
  function DoSnapshotFiles(Files: TStrings): Boolean;
  var
    i: Integer;
    iModuleServices: IOTAModuleServices;
  begin
    Files.Clear;
    QuerySvcs(BorlandIDEServices, IOTAModuleServices, iModuleServices);

    // �����ȡ����Ϊ������õ��ļ�˳��ʹ�ʱ���෴��
    for i := iModuleServices.ModuleCount - 1 downto 0 do
      Files.Add(iModuleServices.Modules[i].FileName);

    Result := Files.Count > 0;
  end;

  // ��һ�������ļ���ر��Ѿ��򿪵ĵ�Ԫ�ļ�������Ӧ�����ȴ򿪹����ļ�
  function FixupFileOrders(Files: TStrings): TStrings;
  var
    i, Base: Integer;
  begin
    Result := Files;

    for i := 0 to Files.Count - 1 do
      Files.Objects[i] := TObject(GetSourceFileType(Files[i]));

    Base := 0;
    // ���ȴ򿪹������ļ�
    for i := 0 to Files.Count - 1 do
      if TCnSourceFileType(Files.Objects[i]) = sftGroup then
      begin
        Files.Move(i, Base);
        Inc(Base);
      end;
    // ����ǹ����ļ�
    for i := 0 to Files.Count - 1 do
      if TCnSourceFileType(Files.Objects[i]) = sftProject then
      begin
        Files.Move(i, Base);
        Inc(Base);
      end;
  end;

var
  Idx: Integer;
  NewName: string;
  Files, List: TStringList;
  NeedRefresh: Boolean;
begin
  // ��������� Delphi ���һ��ͨ����ݼ���ӿ��գ��� RefreshSubActions ������
  // �� Action ���ظ�ִ�У���Ӧ���ǿ�ܵ����⡣��ʱֻ��ͨ������� Action ������
  // ���ظ�ִ����������
  if GetTickCount - FLastAddExecuteTick < 300 then Exit;

  // �����ǰû�д򿪵��ļ�
  if not IsAnyFileOpen then
  begin
    MessageBeep(MB_ICONWARNING);
    Exit;
  end;

  Files := TStringList.Create;
  try
    // �����봰��ȡ���µĿ�����
    if not DoSnapshotFiles(Files) then Exit;
    NewName := AddFilesSnapshot(FFilesSnapshots, FixupFileOrders(Files));

    // ���ɹ�ȡ�ÿ��������򽫵�ǰ�ļ��б�������
    if (NewName <> '') and (Files.Count > 0) then
    begin
      Idx := FFilesSnapshots.IndexOf(NewName);
      if Idx >= 0 then
      begin
        List := TStringList(FFilesSnapshots.Objects[Idx]);
        NeedRefresh := False;
      end
      else
      begin
        List := TStringList.Create;
        FFilesSnapshots.AddObject(NewName, List);
        NeedRefresh := True;
      end;

      List.Assign(Files);

      // ����һ���µĿ�������ǿ��ˢ�±�ר�ң���ʹ�µĿ�����ʾ��ר�Ҳ˵���
      if NeedRefresh then
      begin
        ClearSubActions;
        RefreshSubActions;
      end;

      DoSaveSettings;
    end;
  finally
    // ��¼�����һ��ִ�б��β�����ʱ��
    FLastAddExecuteTick := GetTickCount;

    Files.Free;
  end;
end;

procedure TCnFilesSnapshotWizard.FilesSnapshotManage;
var
  Ini: TCustomIniFile;
begin
  Ini := TMemIniFile.Create('');
  try
    InternalSaveSettings(Ini);
    if ManageFilesSnapshot(FFilesSnapshots) then
    begin
      ClearSubActions;
      RefreshSubActions;
      DoSaveSettings;
    end
    else
      InternalLoadSettings(Ini);
  finally
    Ini.Free;
  end;          
end;

function TCnFilesSnapshotWizard.IsAnyFileOpen: Boolean;
var
  iModuleServices: IOTAModuleServices;
begin
  QuerySvcs(BorlandIDEServices, IOTAModuleServices, iModuleServices);
  Result := (iModuleServices <> nil) and (iModuleServices.ModuleCount > 0);
end;

procedure TCnFilesSnapshotWizard.FilesRestore(Index: Integer);

  function DoRestoreFiles(Files: TStrings): Boolean;
  var
    i: Integer;
  begin
    Result := False;
    BeginBatchOpenClose;
    try
      for i := 0 to Files.Count - 1 do
        if FileExists(Files[i]) then
          Result := CnOtaOpenFile(Files[i]) or Result;
    finally
      EndBatchOpenClose;
    end;
  end;

begin
  Assert((Index >= 0) and (Index < FFilesSnapshots.Count));

  if not DoRestoreFiles(TStringList(FFilesSnapshots.Objects[Index])) then
    MessageBeep(MB_ICONWARNING);
end;

procedure TCnFilesSnapshotWizard.InternalLoadSettings(Ini: TCustomIniFile);
var
  i: Integer;
  Files: TStringList;
begin
  for i := 0 to FFilesSnapshots.Count - 1 do
    FFilesSnapshots.Objects[i].Free;
  FFilesSnapshots.Clear;

  Ini.ReadSection(FSnapSection, FFilesSnapshots);
  for i := 0 to FFilesSnapshots.Count - 1 do
  begin
    Files := TStringList.Create;
    Files.CommaText := Ini.ReadString(FSnapSection, FFilesSnapshots[i], '');
    FFilesSnapshots.Objects[i] := Files;
  end;
end;

procedure TCnFilesSnapshotWizard.InternalSaveSettings(Ini: TCustomIniFile);
var
  i: Integer;
begin
  if Ini.SectionExists(FSnapSection) then
    Ini.EraseSection(FSnapSection);

  for i := 0 to FFilesSnapshots.Count - 1 do
    Ini.WriteString(FSnapSection, FFilesSnapshots[i],
      TStringList(FFilesSnapshots.Objects[i]).CommaText);
end;

procedure TCnFilesSnapshotWizard.LoadSettings(Ini: TCustomIniFile);
begin
  InternalLoadSettings(Ini);
  // �ı����ù�����Ҫ���¿��ղ˵�
  ClearSubActions;
  RefreshSubActions;
end;

procedure TCnFilesSnapshotWizard.SaveSettings(Ini: TCustomIniFile);
begin
  InternalSaveSettings(Ini);
end;

procedure TCnFilesSnapshotWizard.Config;
begin
  FilesSnapshotManage;
end;

procedure TCnFilesSnapshotWizard.SetActive(Value: Boolean);
begin
  inherited;
  if not Active then
  begin
    if FReOpener.FilesListForm <> nil then
    begin
      FReOpener.FilesListForm.Free;
      FReOpener.FilesListForm := nil;
      FormOpened := False;
    end;
  end;
end;

initialization
  RegisterCnWizard(TCnFilesSnapshotWizard);

{$ENDIF CNWIZARDS_CNFILESSNAPSHOTWIZARD}
end.

