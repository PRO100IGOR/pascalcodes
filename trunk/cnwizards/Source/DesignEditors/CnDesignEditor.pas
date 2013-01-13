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

unit CnDesignEditor;
{ |<PRE>
================================================================================
* ������ƣ�CnPack IDE ר�Ұ�
* ��Ԫ���ƣ����ԡ�����༭������Ԫ
* ��Ԫ���ߣ��ܾ��� (zjy@cnpack.org)
* ��    ע�����ԡ�����༭������Ԫ
* ����ƽ̨��PWin2000Pro + Delphi 5.01
* ���ݲ��ԣ�PWin9X/2000/XP + Delphi 5/6/7 + C++Builder 5/6
* �� �� �����õ�Ԫ�е��ַ���֧�ֱ��ػ�����ʽ
* ��Ԫ��ʶ��$Id: CnDesignEditor.pas 867 2011-07-07 09:34:13Z zjy@cnpack.org $
* �޸ļ�¼��2003.04.28 V1.1
*               �޸����Ա༭����ܣ�ʹ��PropertyMapper����̬�������Ա༭����
*               ����֧�ֶ�̬ж����ͬʱ���ϱ༭��֧�����м������ԣ���ר�Ұ���
*               ���Ա༭�����ȼ���ߡ�
*           2003.03.22 V1.0
*               ������Ԫ
================================================================================
|</PRE>}

interface

{$I CnWizards.inc}

uses
  Windows, SysUtils, Classes, Graphics, IniFiles, Registry, TypInfo, Contnrs,
  {$IFDEF COMPILER6_UP}
  DesignIntf, DesignEditors,
  {$ELSE}
  DsgnIntf,
  {$ENDIF}
  ToolsAPI, CnCommon, CnConsts, CnDesignEditorConsts, CnWizOptions, CnWizUtils,
  CnIni, CnWizNotifier;

type

//==============================================================================
// ���ԡ�����༭����Ϣ��
//==============================================================================

  TCnGetEditorInfoProc = procedure (var Name, Author, Email, Comment: string)
    of object;
  TCnObjectProc = procedure of object;
  TCnCustomRegisterProc = procedure (PropertyType: PTypeInfo; ComponentClass:
    TClass; const PropertyName: string; var Success: Boolean) of object;

{ TCnDesignEditorInfo }

{$M+}

  TCnDesignEditorInfo = class
  private
    FActive: Boolean;
    FIDStr: string;
    FEmail: string;
    FComment: string;
    FAuthor: string;
    FName: string;
    FConfigProc: TCnObjectProc;
    FEditorInfoProc: TCnGetEditorInfoProc;
    FRegEditorProc: TCnObjectProc;
  protected
    function GetHasConfig: Boolean; virtual;
    function GetHasCustomize: Boolean; virtual;
    function GetRegPath: string; virtual; abstract;
    procedure SetActive(const Value: Boolean); virtual;
  public
    constructor Create; virtual;
    {* �๹���� }
    procedure Config; virtual;
    {* ���Ա༭�����÷������ɹ����������ý����е��ã��� HasConfig Ϊ��ʱ��Ч }
    procedure Customize; virtual;
    {* ���Ա༭���Զ��巽�����ɹ����������ý����е��ã��� HasCustomize Ϊ��ʱ��Ч }
    procedure LanguageChanged(Sender: TObject);
    {* ���¶������Ա༭�����ַ��� }
    procedure LoadSettings(Ini: TCustomIniFile); virtual;
    {* װ�����÷������������ش˷����� INI �����ж�ȡ���� }
    procedure SaveSettings(Ini: TCustomIniFile); virtual;
    {* �������÷������������ش˷������������浽 INI ������ }
    function CreateIniFile(CompilerSection: Boolean = False): TCustomIniFile;
    {* ����һ�����ڴ�ȡ���ò����� INI �����û�ʹ�ú����Լ��ͷ� }
    procedure DoLoadSettings;
    {* װ������ }
    procedure DoSaveSettings;
    {* װ������ }
    procedure Loaded; virtual;
    {* IDE ������ɺ���ø÷���}

    property IDStr: string read FIDStr;
    {* Ψһ��ʶ���Ա༭�� }
    property Name: string read FName;
    {* ���Ա༭�����ƣ�������֧�ֱ��ػ����ַ��� }
    property Author: string read FAuthor;
    {* ���Ա༭�����ߣ�����ж�����ߣ��÷ֺŷָ� }
    property Email: string read FEmail;
    {* ���Ա༭���������䣬����ж�����ߣ��÷ֺŷָ� }
    property Comment: string read FComment;
    {* ���Ա༭��˵����������֧�ֱ��ػ������з����ַ��� }
    property HasConfig: Boolean read GetHasConfig;
    {* ��ʾ���Ա༭���Ƿ�������ý�������� }
    property HasCustomize: Boolean read GetHasCustomize;
    {* ��ʾ���Ա༭���Ƿ�֧���û�����ע�� }
    property Active: Boolean read FActive write SetActive;
    {* ��Ծ���ԣ��������Ա༭����ǰ�Ƿ���� }

    property EditorInfoProc: TCnGetEditorInfoProc read FEditorInfoProc write FEditorInfoProc;
    {* ��ȡ�༭����Ϣ�ķ���ָ�� }
    property RegEditorProc: TCnObjectProc read FRegEditorProc write FRegEditorProc;
    {* ��ȡ�༭����Ϣ�ķ���ָ�� }
  end;

{$M-}

{ TCnPropEditorInfo }

  TCnPropEditorInfo = class(TCnDesignEditorInfo)
  private
    FCustomProperties: TStringList;
    FCustomRegProc: TCnCustomRegisterProc;
    procedure CheckCustomProperties;
  protected
    function GetRegPath: string; override;
    function GetHasCustomize: Boolean; override;
  public
    constructor Create; override;
    destructor Destroy; override;
    procedure LoadSettings(Ini: TCustomIniFile); override;
    procedure SaveSettings(Ini: TCustomIniFile); override;
    procedure Customize; override;

    property CustomRegProc: TCnCustomRegisterProc read FCustomRegProc write FCustomRegProc;
    {* �û��Զ�������ע����� }
    property CustomProperties: TStringList read FCustomProperties;
    {* �û��Զ��������ע�����ݣ�ÿ�и�ʽΪ ClassName.PropName }
  end;

{ TCnCompEditorInfo }

  TCnCompEditorInfo = class(TCnDesignEditorInfo)
  private
    FEditorClass: TComponentEditorClass;
    FCustomClasses: TStringList;
    procedure CheckCustomClasses;
  protected
    function GetRegPath: string; override;
    function GetHasCustomize: Boolean; override;
  public
    constructor Create; override;
    destructor Destroy; override;
    procedure LoadSettings(Ini: TCustomIniFile); override;
    procedure SaveSettings(Ini: TCustomIniFile); override;
    function GetEditorClass: TComponentEditorClass;
    procedure Customize; override;

    property CustomClasses: TStringList read FCustomClasses;
    {* �û��Զ������ע�����ݣ�ÿ�и�ʽΪ ClassName }
  end;

//==============================================================================
// ���ԡ�����༭���б������
//==============================================================================

  TCnDesignEditorMgr = class(TObject)
  private
    FPropEditorList: TObjectList;
    FCompEditorList: TObjectList;
    FGroup: Integer;
    FActive: Boolean;

    function GetPropEditorCount: Integer;
    function GetPropEditor(Index: Integer): TCnPropEditorInfo;
    function GetPropEditorByClass(AEditor: TPropertyEditorClass): TCnPropEditorInfo;
    function GetPropEditorActive(AEditor: TPropertyEditorClass): Boolean;
    
    function GetCompEditorCount: Integer;
    function GetCompEditor(Index: Integer): TCnCompEditorInfo;
    function GetCompEditorByClass(AEditor: TComponentEditorClass): TCnCompEditorInfo;
    function GetCompEditorActive(AEditor: TComponentEditorClass): Boolean;
    procedure SetActive(const Value: Boolean);
  public
    constructor Create;
    destructor Destroy; override;

    procedure RegisterPropEditor(AEditor: TPropertyEditorClass;
      AEditorInfoProc: TCnGetEditorInfoProc; ARegEditorProc: TCnObjectProc;
      ACustomRegister: TCnCustomRegisterProc = nil; AConfigProc: TCnObjectProc = nil);
    {* ע��һ�����Ա༭������Ϣ }
    procedure RegisterCompEditor(AEditor: TComponentEditorClass;
      AEditorInfoProc: TCnGetEditorInfoProc; ARegEditorProc: TCnObjectProc;
      AConfigProc: TCnObjectProc = nil);
    {* ע��һ������༭������Ϣ }

    procedure Register;
    {* ע�����е����ԡ�����༭�� }
    procedure UnRegister;
    {* ȡ��ע�� }
    procedure LanguageChanged(Sender: TObject);
    {* ���Ա����ˢ������ Editor �� Info }

    property PropEditorCount: Integer read GetPropEditorCount;
    {* ������ע������Ա༭������ }
    property PropEditors[Index: Integer]: TCnPropEditorInfo read GetPropEditor;
    {* ����������ȡָ�������Ա༭����Ϣ }
    property PropEditorsByClass[AEditor: TPropertyEditorClass]: TCnPropEditorInfo
      read GetPropEditorByClass;
    {* ���ݱ༭����ȡָ�������Ա༭����Ϣ }
    property PropEditorActive[AEditor: TPropertyEditorClass]: Boolean read GetPropEditorActive;
    {* ����ָ���ı༭���Ƿ���Ч }

    property CompEditorCount: Integer read GetCompEditorCount;
    {* ������ע������Ա༭������ }
    property CompEditors[Index: Integer]: TCnCompEditorInfo read GetCompEditor;
    {* ����������ȡָ�������Ա༭����Ϣ }
    property CompEditorsByClass[AEditor: TComponentEditorClass]: TCnCompEditorInfo
      read GetCompEditorByClass;
    {* ���ݱ༭����ȡָ�������Ա༭����Ϣ }
    property CompEditorActive[AEditor: TComponentEditorClass]: Boolean read GetCompEditorActive;
    {* ����ָ���ı༭���Ƿ���Ч }

    property Active: Boolean read FActive write SetActive;
  end;

function CnDesignEditorMgr: TCnDesignEditorMgr;
{* ���ر༭������������ }

implementation

uses
  {$IFDEF Debug}CnDebug,{$ENDIF}
  CnPropEditorCustomizeFrm;

const
  csCustomProperties = 'CustomProperties';
  csCustomClasses = 'CustomClasses';

var
  FCnDesignEditorMgr: TCnDesignEditorMgr;
{$IFDEF BDS}
  FNeedUnRegister: Boolean = True;
{$ENDIF}

function CnDesignEditorMgr: TCnDesignEditorMgr;
begin
  if FCnDesignEditorMgr = nil then
    FCnDesignEditorMgr := TCnDesignEditorMgr.Create;
  Result := FCnDesignEditorMgr;
end;

function GetClassIDStr(ClassType: TClass): string;
begin
  Result := RemoveClassPrefix(ClassType.ClassName);
end;

{ TCnDesignEditorInfo }

constructor TCnDesignEditorInfo.Create;
begin
  inherited;
  FActive := True;
end;

//------------------------------------------------------------------------------
// �������÷���
//------------------------------------------------------------------------------

// ����һ�����ڴ�ȡ���ò����� INI �����û�ʹ�ú����Լ��ͷ�
function TCnDesignEditorInfo.CreateIniFile(CompilerSection: Boolean): TCustomIniFile;
var
  Path: string;
begin
  if CompilerSection then
    Path := MakePath(MakePath(GetRegPath) + IDStr) + WizOptions.CompilerID
  else
    Path := MakePath(GetRegPath) + IDStr;
  Result := TRegistryIniFile.Create(Path, KEY_ALL_ACCESS);
end;

procedure TCnDesignEditorInfo.DoLoadSettings;
var
  Ini: TCustomIniFile;
begin
  Ini := CreateIniFile;
  try
  {$IFDEF Debug}
    CnDebugger.LogMsg('Loading settings: ' + IDStr);
  {$ENDIF Debug}
    LoadSettings(Ini);
  finally
    Ini.Free;
  end;
end;

procedure TCnDesignEditorInfo.DoSaveSettings;
var
  Ini: TCustomIniFile;
begin
  Ini := CreateIniFile;
  try
  {$IFDEF Debug}
    CnDebugger.LogMsg('Saving settings: ' + IDStr);
  {$ENDIF Debug}
    SaveSettings(Ini);
  finally
    Ini.Free;
  end;
end;

procedure TCnDesignEditorInfo.Config;
begin
  if HasConfig then
  begin
    FConfigProc;
  end;
end;

procedure TCnDesignEditorInfo.Customize;
begin
  // do noting.
end;

procedure TCnDesignEditorInfo.LanguageChanged(Sender: TObject);
begin
  if Assigned(FEditorInfoProc) then
    FEditorInfoProc(FName, FAuthor, FEmail, FComment);
end;

procedure TCnDesignEditorInfo.LoadSettings(Ini: TCustomIniFile);
begin
  with TCnIniFile.Create(Ini) do
  try
    ReadObject('', Self);
  finally
    Free;
  end;   
end;

procedure TCnDesignEditorInfo.SaveSettings(Ini: TCustomIniFile);
begin
  with TCnIniFile.Create(Ini) do
  try
    WriteObject('', Self);
  finally
    Free;
  end;   
end;

procedure TCnDesignEditorInfo.Loaded;
begin
  // do nothing
end;

function TCnDesignEditorInfo.GetHasConfig: Boolean;
begin
  Result := Assigned(FConfigProc);
end;

function TCnDesignEditorInfo.GetHasCustomize: Boolean;
begin
  Result := False;
end;

procedure TCnDesignEditorInfo.SetActive(const Value: Boolean);
begin
  FActive := Value;
end;

{ TCnPropEditorInfo }

procedure TCnPropEditorInfo.CheckCustomProperties;
var
  i: Integer;
begin
  for i := FCustomProperties.Count - 1 downto 0 do
  begin
    FCustomProperties[i] := Trim(FCustomProperties[i]);
    if (FCustomProperties[i] = '') or (Pos('.', FCustomProperties[i]) <= 1) then
      FCustomProperties.Delete(i);
  end;
end;

constructor TCnPropEditorInfo.Create;
begin
  inherited;
  FCustomProperties := TStringList.Create;
end;

procedure TCnPropEditorInfo.Customize;
begin
  inherited;
  if Assigned(FCustomRegProc) then
  begin
    if ShowPropEditorCustomizeForm(FCustomProperties, False) then
    begin
      CheckCustomProperties;
      DoSaveSettings;
    end;
  end;  
end;

destructor TCnPropEditorInfo.Destroy;
begin
  FCustomProperties.Free;
  inherited;
end;

function TCnPropEditorInfo.GetHasCustomize: Boolean;
begin
  Result := Assigned(FCustomRegProc);
end;

function TCnPropEditorInfo.GetRegPath: string;
begin
  Result := WizOptions.PropEditorRegPath;
end;

procedure TCnPropEditorInfo.LoadSettings(Ini: TCustomIniFile);
begin
  inherited;
  FCustomProperties.CommaText := Ini.ReadString('', csCustomProperties, '');
  CheckCustomProperties;
end;

procedure TCnPropEditorInfo.SaveSettings(Ini: TCustomIniFile);
begin
  inherited;
  Ini.WriteString('', csCustomProperties, FCustomProperties.CommaText);
end;

{ TCnCompEditorInfo }

procedure TCnCompEditorInfo.CheckCustomClasses;
var
  i: Integer;
begin
  for i := FCustomClasses.Count - 1 downto 0 do
  begin
    FCustomClasses[i] := Trim(FCustomClasses[i]);
    if FCustomClasses[i] = '' then
      FCustomClasses.Delete(i);
  end;
end;

constructor TCnCompEditorInfo.Create;
begin
  inherited;
  FCustomClasses := TStringList.Create;
end;

procedure TCnCompEditorInfo.Customize;
begin
  if ShowPropEditorCustomizeForm(FCustomClasses, True) then
  begin
    CheckCustomClasses;
    DoSaveSettings;
  end;
end;

destructor TCnCompEditorInfo.Destroy;
begin
  FCustomClasses.Free;
  inherited;
end;

function TCnCompEditorInfo.GetEditorClass: TComponentEditorClass;
begin
  Result := FEditorClass;
end;

function TCnCompEditorInfo.GetHasCustomize: Boolean;
begin
  Result := True;
end;

function TCnCompEditorInfo.GetRegPath: string;
begin
  Result := WizOptions.CompEditorRegPath;
end;

procedure TCnCompEditorInfo.LoadSettings(Ini: TCustomIniFile);
begin
  inherited;
  FCustomClasses.CommaText := Ini.ReadString('', csCustomClasses, '');
  CheckCustomClasses;
end;

procedure TCnCompEditorInfo.SaveSettings(Ini: TCustomIniFile);
begin
  inherited;
  Ini.WriteString('', csCustomClasses, FCustomClasses.CommaText);
end;

{ TCnDesignEditorMgr }

constructor TCnDesignEditorMgr.Create;
begin
  inherited;
  FActive := True;
  FGroup := -1;
  FPropEditorList := TObjectList.Create(True);
  FCompEditorList := TObjectList.Create(True);
end;

destructor TCnDesignEditorMgr.Destroy;
begin
  UnRegister;
  FPropEditorList.Free;
  FCompEditorList.Free;
  inherited;
end;

//------------------------------------------------------------------------------
// �༭��ע��
//------------------------------------------------------------------------------

procedure TCnDesignEditorMgr.RegisterCompEditor(
  AEditor: TComponentEditorClass; AEditorInfoProc: TCnGetEditorInfoProc;
  ARegEditorProc, AConfigProc: TCnObjectProc);
var
  Info: TCnCompEditorInfo;
  IDStr: string;
  i: Integer;
begin
  IDStr := GetClassIDStr(AEditor);
  for i := 0 to CompEditorCount - 1 do
    if SameText(CompEditors[i].IDStr, IDStr) then
      Exit;

  Info := TCnCompEditorInfo.Create;
  Info.FIDStr := IDStr;
  Info.FEditorInfoProc := AEditorInfoProc;
  Info.FRegEditorProc := ARegEditorProc;
  Info.FConfigProc := AConfigProc;
  Info.FEditorClass := AEditor;
  if Assigned(AEditorInfoProc) then
    Info.LanguageChanged(nil);
  FCompEditorList.Add(Info);
end;

procedure TCnDesignEditorMgr.RegisterPropEditor(
  AEditor: TPropertyEditorClass; AEditorInfoProc: TCnGetEditorInfoProc;
  ARegEditorProc: TCnObjectProc; ACustomRegister: TCnCustomRegisterProc;
  AConfigProc: TCnObjectProc);
var
  Info: TCnPropEditorInfo;
  IDStr: string;
  i: Integer;
begin
  IDStr := GetClassIDStr(AEditor);
  for i := 0 to PropEditorCount - 1 do
    if SameText(PropEditors[i].IDStr, IDStr) then
      Exit;

  Info := TCnPropEditorInfo.Create;
  Info.FIDStr := IDStr;
  Info.FEditorInfoProc := AEditorInfoProc;
  Info.FRegEditorProc := ARegEditorProc;
  Info.FCustomRegProc := ACustomRegister;
  Info.FConfigProc := AConfigProc;
  if Assigned(AEditorInfoProc) then
    Info.LanguageChanged(nil);
  FPropEditorList.Add(Info);
end;

procedure TCnDesignEditorMgr.Register;
var
  i, j, Idx: Integer;
  AClass: TClass;
  AName, CName, PName: string;
  AInfo: PPropInfo;
  Success: Boolean;
begin
  UnRegister;

  FGroup := NewEditorGroup;
{$IFDEF Debug}
  CnDebugger.LogInteger(FGroup, 'NewEditorGroup');
{$ENDIF}
  for i := 0 to PropEditorCount - 1 do
    if PropEditors[i].Active then
    begin
      if Assigned(PropEditors[i].RegEditorProc) then
      begin
      {$IFDEF Debug}
        CnDebugger.LogMsg('Register PropEditor: ' + PropEditors[i].IDStr);
      {$ENDIF}
        PropEditors[i].RegEditorProc;
      end;

      // ע���Զ��������
      if Assigned(PropEditors[i].CustomRegProc) then
      begin
        for j := 0 to PropEditors[i].CustomProperties.Count - 1 do
        begin
          AName := Trim(PropEditors[i].CustomProperties[j]);
          Idx := Pos('.', AName);
          if Idx > 1 then
          begin
            CName := Trim(Copy(AName, 1, Idx - 1));
            PName := Trim(Copy(AName, Idx + 1, MaxInt));
            if (CName <> '') and (PName <> '') then
            begin
              AClass := GetClass(CName);
              if AClass <> nil then
              begin
                Success := False;
                AInfo := GetPropInfo(AClass, PName);
                if (AInfo <> nil) and (AInfo.PropType^ <> nil) then
                  PropEditors[i].CustomRegProc(AInfo.PropType^, AClass, PName, Success)
                else
                  PropEditors[i].CustomRegProc(nil, AClass, PName, Success);
              {$IFDEF Debug}
                CnDebugger.LogFmt('CustomRegister: %s.%s Succ: %s',
                  [CName, PName, BoolToStr(Success, True)]);
              {$ENDIF}
              end
            end;
          end;
        end;  
      end;
    end;

  for i := 0 to CompEditorCount - 1 do
    if CompEditors[i].Active and Assigned(CompEditors[i].RegEditorProc) then
    begin
    {$IFDEF Debug}
      CnDebugger.LogMsg('Register CompEditor: ' + CompEditors[i].IDStr);
    {$ENDIF}
      CompEditors[i].RegEditorProc;

      for j := 0 to CompEditors[i].CustomClasses.Count - 1 do
      begin
        AName := Trim(CompEditors[i].CustomClasses[j]);
        if AName <> '' then
        begin
          AClass := GetClass(AName);
          if AClass <> nil then
          begin
            RegisterComponentEditor(TComponentClass(AClass), CompEditors[i].GetEditorClass);
          {$IFDEF Debug}
            CnDebugger.LogFmt('CustomRegister: %s Succ: %s',
              [AName, BoolToStr(Success, True)]);
          {$ENDIF}
          end
        end;
      end;
    end;

  // Ϊ�˱��ⷴע��ʱ������ģ���еı༭��Ҳ��ע�����һ�����ܵ������ CodeRush
  // ע�������༭�������˴���һ�����顣������Ȼ���ܵ����ж���Ŀ��飬������
  // ʹ�� TBit ����������Ϣ�� IDE ��˵ûʲôӰ�졣
  NewEditorGroup;
end;

procedure TCnDesignEditorMgr.UnRegister;
begin
  if FGroup >= 0 then
  begin
{$IFDEF DEBUG}
    CnDebugger.LogInteger(FGroup, 'FreeEditorGroup');
{$ENDIF}

    try
{$IFDEF BDS}
      // D8/D2005 ���� DLL �ͷ�ʱ���ÿ��ܻ���쳣
      if FNeedUnRegister then
        FreeEditorGroup(FGroup);
{$ELSE}
      FreeEditorGroup(FGroup);
{$ENDIF}
    except
      ;
    end;
    FGroup := -1;
  end;
end;

procedure TCnDesignEditorMgr.LanguageChanged(Sender: TObject);
var
  i: Integer;
begin
  for i := 0 to PropEditorCount - 1 do
    PropEditors[i].LanguageChanged(Sender);

  for i := 0 to CompEditorCount - 1 do
    CompEditors[i].LanguageChanged(Sender);
end;

//------------------------------------------------------------------------------
// ���Զ�д
//------------------------------------------------------------------------------

function TCnDesignEditorMgr.GetCompEditor(Index: Integer): TCnCompEditorInfo;
begin
  Result := TCnCompEditorInfo(FCompEditorList[Index]);
end;

function TCnDesignEditorMgr.GetCompEditorActive(
  AEditor: TComponentEditorClass): Boolean;
var
  Info: TCnCompEditorInfo;
begin
  Info := GetCompEditorByClass(AEditor);
  if Assigned(Info) then
    Result := Info.Active
  else
    Result := False;
end;

function TCnDesignEditorMgr.GetCompEditorByClass(
  AEditor: TComponentEditorClass): TCnCompEditorInfo;
var
  IDStr: string;
  i: Integer;
begin
  Result := nil;
  IDStr := GetClassIDStr(AEditor);
  for i := 0 to CompEditorCount - 1 do
    if SameText(CompEditors[i].IDStr, IDStr) then
    begin
      Result := CompEditors[i];
      Exit;
    end;
end;

function TCnDesignEditorMgr.GetCompEditorCount: Integer;
begin
  Result := FCompEditorList.Count;
end;

function TCnDesignEditorMgr.GetPropEditor(Index: Integer): TCnPropEditorInfo;
begin
  Result := TCnPropEditorInfo(FPropEditorList[Index]);
end;

function TCnDesignEditorMgr.GetPropEditorActive(
  AEditor: TPropertyEditorClass): Boolean;
var
  Info: TCnPropEditorInfo;
begin
  Info := PropEditorsByClass[AEditor];
  if Assigned(Info) then
    Result := Info.Active
  else
    Result := False;
end;

function TCnDesignEditorMgr.GetPropEditorByClass(
  AEditor: TPropertyEditorClass): TCnPropEditorInfo;
var
  IDStr: string;
  i: Integer;
begin
  Result := nil;
  IDStr := GetClassIDStr(AEditor);
  for i := 0 to PropEditorCount - 1 do
    if SameText(PropEditors[i].IDStr, IDStr) then
    begin
      Result := PropEditors[i];
      Exit;
    end;
end;

function TCnDesignEditorMgr.GetPropEditorCount: Integer;
begin
  Result := FPropEditorList.Count;
end;

procedure TCnDesignEditorMgr.SetActive(const Value: Boolean);
begin
  if FActive <> Value then
  begin
    FActive := Value;
    UnRegister;
    if FActive then
      Register;
  end;
end;

initialization

finalization
{$IFDEF Debug}
  CnDebugger.LogEnter('CnDesignEditor finalization.');
{$ENDIF Debug}

  if FCnDesignEditorMgr <> nil then
  begin
  {$IFDEF BDS}
    FNeedUnRegister := False;
  {$ENDIF}
    FreeAndNil(FCnDesignEditorMgr);
  end;

{$IFDEF Debug}
  CnDebugger.LogLeave('CnDesignEditor finalization.');
{$ENDIF Debug}
end.

