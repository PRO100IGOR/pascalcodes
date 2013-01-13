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

unit CnWizMultiLang;
{* |<PRE>
================================================================================
* ������ƣ�CnPack IDE ר�Ұ�
* ��Ԫ���ƣ�ר�Ұ�������Ƶ�Ԫ
* ��Ԫ���ߣ���Х��LiuXiao�� liuxiao@cnpack.org
* ��    ע��
* ����ƽ̨��PWin2000Pro + Delphi 5.01
* ���ݲ��ԣ�PWin9X/2000/XP + Delphi 5/6/7 + C++Builder 5/6
* �� �� �����õ�Ԫ�е��ַ��������ϱ��ػ�����ʽ
* ��Ԫ��ʶ��$Id: CnWizMultiLang.pas 856 2011-07-06 08:32:17Z zjy@cnpack.org $
* �޸ļ�¼��2009.01.07
*               ����λ�ñ��湦��
*           2004.11.19 V1.4
*               ����������л������Scaled=Falseʱ���廹�ǻ�Scaled��BUG (shenloqi)
*           2004.11.18 V1.3
*               ��TCnTranslateForm.FScaler��Private��ΪProtected (shenloqi)
*           2003.10.30 V1.2
*               ���ӷ��� F1 ��ʾ������������ⷽ�� GetHelpTopic
*           2003.10.20 V1.1
*               �����������ļ�ʱ�Ĵ���
*           2003.08.23 V1.0
*               ������Ԫ
================================================================================
|</PRE>}

interface

{$I CnWizards.inc}

{$IFDEF DELPHI2007}
// RAD Studio 2007 �¿��� AutoComplete �ᵼ���������ĺ��˸�����
{$DEFINE COMBOBOX_CHS_BUG}
{$ENDIF}

{$IFDEF COMPILER12}
// RAD Studio 2009 �� CreateParams �п��ܵ�����ѭ��
{$DEFINE CREATE_PARAMS_BUG}
{$ENDIF}

{$IFDEF TEST_APP}
{$DEFINE STAND_ALONE}
{$ENDIF}

uses
  Windows, Messages, SysUtils, Classes, Forms, ActnList, Controls, Menus,
{$IFNDEF TEST_APP}
{$IFNDEF STAND_ALONE}
  CnConsts, CnWizClasses, CnWizManager, CnWizUtils, CnWizOptions, CnDesignEditor,
  CnWizTranslate, CnLangUtils,
{$ELSE}
  CnWizLangID,
{$ENDIF}
  CnWizConsts, CnCommon, CnLangMgr, CnHashLangStorage, CnLangStorage, CnWizHelp,
  CnFormScaler, CnWizIni,
{$ENDIF}
  StdCtrls, IniFiles;

type

{$IFNDEF STAND_ALONE}

{ TCnWizMultiLang }

  TCnWizMultiLang = class(TCnSubMenuWizard)
  private
    Indexes: array of Integer;
  protected
    procedure SubActionExecute(Index: Integer); override;
    procedure SubActionUpdate(Index: Integer); override;
    class procedure OnLanguageChanged(Sender: TObject);
  public
    constructor Create; override;
    destructor Destroy; override;
    procedure AcquireSubActions; override;
    procedure RefreshSubActions; override;
    class procedure GetWizardInfo(var Name, Author, Email, Comment: string); override;
    class function IsInternalWizard: Boolean; override;
    function GetCaption: string; override;
    function GetHint: string; override;
  end;

{$ENDIF}

  TCnTranslateForm = class(TForm)
{$IFNDEF TEST_APP}
  private
    FActionList: TActionList;
    FHelpAction: TAction;
    procedure OnLanguageChanged(Sender: TObject);
    procedure OnHelp(Sender: TObject);
{$ENDIF TEST_APP}
  protected
{$IFNDEF TEST_APP}
    FScaler: TCnFormScaler;

    procedure Loaded; override;
    procedure DoCreate; override;
    procedure DoDestroy; override;
    procedure ReadState(Reader: TReader); override;
{$ENDIF TEST_APP}

{$IFDEF CREATE_PARAMS_BUG}
    procedure CreateParams(var Params: TCreateParams); override;
{$ENDIF}

    procedure DoHelpError; virtual;
    procedure InitFormControls; virtual;
    {* ��ʼ�������ӿؼ�}
    procedure DoLanguageChanged(Sender: TObject); virtual;
    {* ��ǰ���Ա��֪ͨ}
    function GetHelpTopic: string; virtual;
    {* ���ര�����ش˷������� F1 ��Ӧ�İ�����������}
    function GetNeedPersistentPosition: Boolean; virtual;
    {* ���ര�����ش˷��������Ƿ���Ҫ���洰���С��λ�ù��´�������ָ���Ĭ�ϲ���Ҫ}
    procedure ShowFormHelp;
  public
    procedure Translate; virtual;
    {* ����ȫ���巭��}
  end;

{$IFNDEF TEST_APP}
function CnLangMgr: TCnCustomLangManager;
{* CnLanguageManager �ļ��Է�װ����֤���صĹ������ܽ��з��� }

procedure InitLangManager;

function GetFileFromLang(const FileName: string): string;
{$ENDIF}

implementation

{$R *.DFM}

{$IFDEF DEBUG}
uses
  CnDebug;
{$ENDIF DEBUG}

const
  csLanguage = 'Language';
  csEnglishID = 1033;

{$IFDEF STAND_ALONE}
  csLangDir = 'Lang\';
  csHelpDir = 'Help\';
{$ENDIF}

{$IFNDEF TEST_APP}
var
  FStorage: TCnHashLangFileStorage;

procedure InitLangManager;
var
  LangID: Cardinal;
begin
  CnLanguageManager.AutoTranslate := False;
  CnLanguageManager.TranslateTreeNode := True;
  CnLanguageManager.UseDefaultFont := True;
  FStorage := TCnHashLangFileStorage.Create(nil);
  FStorage.FileName := SCnWizLangFile;
  FStorage.StorageMode := smByDirectory;

  try
{$IFNDEF STAND_ALONE}
    FStorage.LanguagePath := WizOptions.LangPath;
{$ELSE}
    FStorage.LanguagePath := ExtractFilePath(ParamStr(0)) + csLangDir;
{$ENDIF}
  except
    ; // �����Զ���������ļ�ʱ���ܳ��Ĵ�
{$IFDEF DEBUG}
    CnDebugger.LogMsgError('Language Storage Initialization Error.');
{$ENDIF DEBUG}
  end;
  CnLanguageManager.LanguageStorage := FStorage;

{$IFNDEF STAND_ALONE}
  LangID := WizOptions.CurrentLangID;
{$ELSE}
  LangID := GetWizardsLanguageID;
{$ENDIF}

  if FStorage.Languages.Find(LangID) >= 0 then
    CnLanguageManager.CurrentLanguageIndex := FStorage.Languages.Find(LangID)
  else
  begin
{$IFNDEF STAND_ALONE}
    // �����õ� LangID �����ڵ�ʱ��Ĭ�����ó�Ӣ��
    WizOptions.CurrentLangID := csEnglishID;
{$ENDIF}
    CnLanguageManager.CurrentLanguageIndex := FStorage.Languages.Find(csEnglishID);
  end;
end;

// CnLanguageManager �ļ��Է�װ����֤���صĹ�������Ϊnil���ܽ��з���
function CnLangMgr: TCnCustomLangManager;
begin
  if CnLanguageManager = nil then
    CreateLanguageManager;
  if CnLanguageManager.LanguageStorage = nil then
    InitLangManager;

  Result := CnLanguageManager;
end;

function GetFileFromLang(const FileName: string): string;
begin
  Result := CnWizHelp.GetFileFromLang(FileName);
end;
{$ENDIF}

{$IFNDEF STAND_ALONE}

{ TCnWizMultiLang }

constructor TCnWizMultiLang.Create;
begin
  if CnLanguageManager <> nil then
    CnLanguageManager.OnLanguageChanged := Self.OnLanguageChanged;

  inherited;
  // ��Ϊ�� Wizard ���ᱻ Loaded���ã�����Ҫ�ֹ� AcquireSubActions;
  if (CnLanguageManager.LanguageStorage <> nil)
    and (CnLanguageManager.LanguageStorage.LanguageCount > 0) then
    AcquireSubActions
  else
    Self.Active := False;
end;

procedure TCnWizMultiLang.AcquireSubActions;
var
  I: Integer;
  S: string;
begin
  if FStorage.LanguageCount > 0 then
    SetLength(Self.Indexes, FStorage.LanguageCount);
  for I := 0 to FStorage.LanguageCount - 1 do
  begin
    S := CnLanguages.NameFromLocaleID[FStorage.Languages[I].LanguageID];
    S := StringReplace(S, '̨��', '�й�̨��', [rfReplaceAll]);
    Self.Indexes[I] := RegisterASubAction(csLanguage + InttoStr(I) + FStorage.
      Languages[I].Abbreviation, FStorage.Languages[I].LanguageName + ' - ' +
      S, 0, FStorage.Languages[I].LanguageName);
  end;
end;

destructor TCnWizMultiLang.Destroy;
begin
  if FStorage <> nil then
    FreeAndNil(FStorage);
  inherited;
end;

function TCnWizMultiLang.GetCaption: string;
begin
  Result := SCnWizMultiLangCaption;
end;

function TCnWizMultiLang.GetHint: string;
begin
  Result := SCnWizMultiLangHint;
end;

class procedure TCnWizMultiLang.GetWizardInfo(var Name, Author, Email,
  Comment: string);
begin
  Name := SCnWizMultiLangName;
  Author := SCnPack_LiuXiao;
  Email := SCnPack_LiuXiaoEmail;
  Comment := SCnWizMultiLangComment;
end;

class function TCnWizMultiLang.IsInternalWizard: Boolean;
begin
  Result := True;
end;

// �����¼��ı�Ĵ����¼�
class procedure TCnWizMultiLang.OnLanguageChanged(Sender: TObject);
begin
  if (CnLanguageManager <> nil) and (CnLanguageManager.LanguageStorage <> nil)
    and (CnLanguageManager.LanguageStorage.LanguageCount > 0) then
  begin
    CnTranslateConsts(Sender);
    CnWizardMgr.RefreshLanguage;
    CnWizardMgr.ChangeWizardLanguage;
    CnDesignEditorMgr.LanguageChanged(Sender);
  end;
end;

procedure TCnWizMultiLang.RefreshSubActions;
begin
// ʲôҲ������Ҳ�� inherited, ����ֹ�� Action ��ˢ�¡�
end;

procedure TCnWizMultiLang.SubActionExecute(Index: Integer);
var
  i: Integer;
begin
  for i := Low(Indexes) to High(Indexes) do
    if Indexes[i] = Index then
    begin
      CnLanguageManager.CurrentLanguageIndex := i;
      WizOptions.CurrentLangID := FStorage.Languages[i].LanguageID;
    end;
end;

procedure TCnWizMultiLang.SubActionUpdate(Index: Integer);
var
  i: Integer;
begin
  for i := Low(Indexes) to High(Indexes) do
    SubActions[i].Checked := WizOptions.CurrentLangID =
      FStorage.Languages[i].LanguageID;
end;

{$ENDIF}

{$IFNDEF TEST_APP}

{ TCnTranslateForm }

procedure TCnTranslateForm.DoCreate;
begin
  FActionList := TActionList.Create(Self);
  FHelpAction := TAction.Create(Self);
  FHelpAction.ShortCut := ShortCut(VK_F1, []);
  FHelpAction.OnExecute := OnHelp;
  FHelpAction.ActionList := FActionList;
  DisableAlign;
  try
    Translate;
    if not Scaled then
      Font.Height := MulDiv(Font.Height, FScaler.DesignPPI, PixelsPerInch);
  finally
    EnableAlign;
  end;
  DoLanguageChanged(CnLanguageManager);
  inherited;
end;

procedure TCnTranslateForm.DoDestroy;
{$IFNDEF STAND_ALONE}
var
  Ini: TCustomIniFile;
{$ENDIF}
begin
{$IFNDEF STAND_ALONE}
  // ����λ�ã���ͣ��������
  if (Parent = nil) and GetNeedPersistentPosition and (Position in [poDesigned,
    poDefault, poDefaultPosOnly, poDefaultSizeOnly]) then
  begin
    Ini := WizOptions.CreateRegIniFile;
    try
      Ini.WriteInteger(SCnFormPosition, ClassName + SCnFormPositionTop, Top);
      Ini.WriteInteger(SCnFormPosition, ClassName + SCnFormPositionLeft, Left);
      Ini.WriteInteger(SCnFormPosition, ClassName + SCnFormPositionWidth, Width);
      Ini.WriteInteger(SCnFormPosition, ClassName + SCnFormPositionHeight, Height);
    finally
      Ini.Free;
    end;
  end;
{$ENDIF}

  FHelpAction.Free;
  FActionList.Free;
  FScaler.Free;
  if CnLanguageManager <> nil then
    CnLanguageManager.RemoveChangeNotifier(OnLanguageChanged);
  inherited;
end;

procedure TCnTranslateForm.Loaded;
{$IFNDEF STAND_ALONE}
var
  Ini: TCustomIniFile;
  I: Integer;
{$ENDIF}
begin
  inherited;
  FScaler := TCnFormScaler.Create(Self);
  FScaler.DoEffects;
  InitFormControls;

{$IFNDEF STAND_ALONE}
  // ��ȡ���ָ�λ��
  if GetNeedPersistentPosition then
  begin
    Ini := WizOptions.CreateRegIniFile;
    try
      I := Ini.ReadInteger(SCnFormPosition, ClassName + SCnFormPositionTop, -1);
      if I <> -1 then Top := I;
      I := Ini.ReadInteger(SCnFormPosition, ClassName + SCnFormPositionLeft, -1);
      if I <> -1 then Left := I;
      I := Ini.ReadInteger(SCnFormPosition, ClassName + SCnFormPositionWidth, -1);
      if I <> -1 then Width := I;
      I := Ini.ReadInteger(SCnFormPosition, ClassName + SCnFormPositionHeight, -1);
      if I <> -1 then Height := I;

      Position := poDesigned;
    finally
      Ini.Free;
    end;
  end;
{$ENDIF}
end;

procedure TCnTranslateForm.ReadState(Reader: TReader);
begin
  inherited;
  OldCreateOrder := False;
end;

{$IFDEF CREATE_PARAMS_BUG}

procedure TCnTranslateForm.CreateParams(var Params: TCreateParams);
var
  OldLong: Longint;
  AHandle: THandle;
  NeedChange: Boolean;
begin
  NeedChange := False;
  OldLong := 0;
  AHandle := Application.ActiveFormHandle;
  if AHandle <> 0 then
  begin
    OldLong := GetWindowLong(AHandle, GWL_EXSTYLE);
    NeedChange := OldLong and WS_EX_TOOLWINDOW = WS_EX_TOOLWINDOW;
    if NeedChange then
    begin
{$IFDEF DEBUG}
      CnDebugger.LogMsg('TCnTranslateForm: D2009 Bug fix: HWnd for WS_EX_TOOLWINDOW style.');
{$ENDIF}
      SetWindowLong(AHandle, GWL_EXSTYLE, OldLong and not WS_EX_TOOLWINDOW);
    end;
  end;

  inherited; // �ȴ����굱ǰ���ڵķ������ԭ���̣�֮��ָ�

  if NeedChange and (OldLong <> 0) then
    SetWindowLong(AHandle, GWL_EXSTYLE, OldLong);
end;

{$ENDIF CREATE_PARAMS_BUG}
procedure TCnTranslateForm.OnHelp(Sender: TObject);
var
  Topic: string;
begin
  Topic := GetHelpTopic;
  if Topic <> '' then
  begin
{$IFDEF STAND_ALONE}
    if not CnWizHelp.ShowHelp(Topic) then
      DoHelpError;
{$ELSE}
    CnWizUtils.ShowHelp(Topic);
{$ENDIF}
  end;
end;

procedure TCnTranslateForm.OnLanguageChanged(Sender: TObject);
begin
  DisableAlign;
  try
    CnLanguageManager.TranslateForm(Self);
    if not Scaled then
      Font.Height := MulDiv(Font.Height, FScaler.DesignPPI, PixelsPerInch);
  finally
    EnableAlign;
  end;
  DoLanguageChanged(Sender);
end;

{$ENDIF TEST_APP}

procedure TCnTranslateForm.InitFormControls;
{$IFDEF COMBOBOX_CHS_BUG}
var
  i: Integer;
{$ENDIF}
begin
{$IFDEF COMBOBOX_CHS_BUG}
  for i := 0 to ComponentCount - 1 do
    if Components[i] is TCustomComboBox then
      TComboBox(Components[i]).AutoComplete := False;
{$ENDIF}
end;

procedure TCnTranslateForm.DoLanguageChanged(Sender: TObject);
begin
  // ����ɶ������
end;

function TCnTranslateForm.GetHelpTopic: string;
begin
  Result := '';
end;

procedure TCnTranslateForm.DoHelpError;
begin
{$IFNDEF TEST_APP}
  ErrorDlg(SCnNoHelpofThisLang);
{$ENDIF TEST_APP}
end;

procedure TCnTranslateForm.ShowFormHelp;
begin
{$IFNDEF TEST_APP}
  FHelpAction.Execute;
{$ENDIF TEST_APP}
end;

procedure TCnTranslateForm.Translate;
begin
{$IFNDEF TEST_APP}
{$IFDEF DEBUG}
  CnDebugger.LogEnter('TCnTranslateForm.Translate');
{$ENDIF DEBUG}
  if (CnLanguageManager <> nil) and (CnLanguageManager.LanguageStorage <> nil)
    and (CnLanguageManager.LanguageStorage.LanguageCount > 0) then
  begin
    CnLanguageManager.AddChangeNotifier(OnLanguageChanged);
    Screen.Cursor := crHourGlass;
    try
      CnLanguageManager.TranslateForm(Self);
    finally
      Screen.Cursor := crDefault;
    end;
  end
  else
  begin
{$IFDEF DEBUG}
    CnDebugger.LogMsgError('MultiLang Initialization Error. Use Chinese Font as default.');
{$ENDIF DEBUG}
    // ���ʼ��ʧ�ܶ���������Ŀ����ԭʼ���������ģ�������Ϊ��������
    Font.Charset := GB2312_CHARSET;
  end;
{$IFDEF DEBUG}
  CnDebugger.LogLeave('TCnTranslateForm.Translate');
{$ENDIF DEBUG}
{$ENDIF TEST_APP}
end;

function TCnTranslateForm.GetNeedPersistentPosition: Boolean;
begin
  Result := False;
end;

{$IFNDEF TEST_APP}

initialization
{$IFDEF STAND_ALONE}
  CreateLanguageManager;
  InitLangManager;
{$ENDIF}

finalization
{$IFDEF DEBUG}
  CnDebugger.LogEnter('CnWizMultiLang finalization.');
{$ENDIF DEBUG}

  if FStorage <> nil then
    FreeAndNil(FStorage);

{$IFDEF DEBUG}
  CnDebugger.LogLeave('CnWizMultiLang finalization.');
{$ENDIF DEBUG}

{$ENDIF TEST_APP}

end.




