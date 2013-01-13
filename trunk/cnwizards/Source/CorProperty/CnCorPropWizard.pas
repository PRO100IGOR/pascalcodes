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

unit CnCorPropWizard;
{* |<PRE>
================================================================================
* ������ƣ�CnPack IDE ר�Ұ�
* ��Ԫ���ƣ������޸�ר�ҵ�Ԫ
* ��Ԫ���ߣ���ʡ(hubdog) hubdog@263.net
*           ��Х(LiuXiao) liuxiao@cnpack.org
* ��    ע�������޸�ר�ҵ�Ԫ
* ����ƽ̨��PWin2000Pro + Delphi 5.01
* ���ݲ��ԣ�PWin2000 + Delphi 5
* �� �� �����õ�Ԫ�е��ַ��������ϱ��ػ�����ʽ
* ��Ԫ��ʶ��$Id: CnCorPropWizard.pas 963 2011-07-31 11:28:51Z liuxiaoshanzhashu@gmail.com $
* �޸ļ�¼��2003.05.17 V1.0 by LiuXiao
*               ������Ԫ
================================================================================
|</PRE>}

interface

{$I CnWizards.inc}

{$IFDEF CNWIZARDS_CNCORPROPWIZARD}

uses
  Forms, Graphics, ActnList, Classes, Menus, Controls, Windows,
  ToolsApi, Sysutils, TypInfo, contnrs, IniFiles, Comctrls,
  CnConsts, CnWizClasses, CnWizConsts, CnWizUtils, CnCommon,
  CnWizIdeUtils, CnIni, CnWizOptions, CnWizIni;

type
  TCnCorPropWizard = class(TCnMenuWizard)
  private
    FPropDefList: TObjectList;
  protected
    function GetHasConfig: Boolean; override;
  public
    constructor Create; override;
    destructor Destroy; override;
    procedure Config; override;
    function GetState: TWizardState; override;
    class procedure GetWizardInfo(var Name, Author, Email, Comment: string); override;
    function GetCaption: string; override;
    function GetHint: string; override;
    function GetDefShortCut: TShortCut; override;
    procedure Execute; override;
    procedure LoadSettings(Ini: TCustomIniFile); override;
    procedure SaveSettings(Ini: TCustomIniFile); override;
    procedure LanguageChanged(Sender: TObject); override;

    procedure LoadPropertyRules(const FileName: string);
    procedure SavePropertyRules(const FileName: string);
  end;

  TCompareOper = (coLarge, coLess, coLargeEqual, coLessEqual, coEqual, coNotEqual);
  //���ܻ���Ҫʵ�� Include Exclude �ȱȽ�
  TPropAction = (paWarn, paCorrect);
  //���Զ������

  TCnPropDef = class(TComponent)
  private
    FActive: Boolean;
    FToValue: string;
    FValue: string;
    FCompName: string;
    FPropName: string;
    FCompare: TCompareOper;
    FAction: TPropAction;
  published
    property Action   : TPropAction   read FAction   write FAction;     //��Ϊ
    property Active   : Boolean       read FActive   write FActive;     //�Ƿ���Ч
    property Compare  : TCompareOper  read FCompare  write FCompare;    //�Ƚϲ�������
    property CompName : string        read FCompName write FCompName;   //�ؼ�����
    property PropName : string        read FPropName write FPropName;   //��������
    property ToValue  : string        read FToValue  write FToValue;    //������ֵ
    property Value    : string        read FValue    write FValue;      //���ǰ��ֵ
    procedure Assign(Source: TPersistent); override;
  end;

function StrToCompare(Str: string): TCompareOper;

function StrToAction(Str: string): TPropAction;

const
  CompareStr: array[TCompareOper] of string = ('>', '<', '>=', '<=', '=', '<>');

var
  ActionStr: array[TPropAction] of string =
    ('SCnCorrectPropertyActionWarn', 'SCnCorrectPropertyActionAutoCorrect');

{$ENDIF CNWIZARDS_CNCORPROPWIZARD}

implementation

{$IFDEF CNWIZARDS_CNCORPROPWIZARD}

uses
{$IFDEF DEBUG}
  CnDebug,
{$ENDIF}
  CnCorPropFrm, CnCorPropCfgFrm;

const
  sSection     = 'CorPropRules';
  sCount       = 'DefCount';
  sCompNameFmt = 'CompName%d';
  sPropNameFmt = 'PropName%d';
  sActiveFmt   = 'Active%d';
  sCompareFmt  = 'Compare%d';
  sValueFmt    = 'Value%d';
  sToValueFmt  = 'ToValue%d';
  sActionFmt   = 'Action%d';

function StrToCompare(Str: string): TCompareOper;
begin
  case IndexStr(Str, ['>', '<', '>=', '<=', '=', '<>']) of
    0: Result := coLarge;
    1: Result := coLess;
    2: Result := coLargeEqual;
    3: Result := coLessEqual;
    4: Result := coEqual;
    5: Result := coNotEqual;
  else
    Result := coEqual;
  end;
end;
//('Warn','AutoCorrect');

function StrToAction(Str: string): TPropAction;
begin
  if Str = SCnCorrectPropertyActionWarn then
    Result := paWarn
  else //if Str=AutoCorrect then
    Result := paCorrect;
end;

{ TCnCorPropWizard }

procedure TCnCorPropWizard.Config;
begin
{$IFDEF DEBUG}
  CnDebugger.LogMsg('Configure Correct Property Wizard');
{$ENDIF}
  with TCnCorPropCfgForm.Create(Application) do
    try
      PropDefList := FPropDefList;
      if ShowModal = mrOk then
      begin
        FPropDefList := PropDefList;
        DoSaveSettings;
      end;
    finally
      Free;
    end;
end;

constructor TCnCorPropWizard.Create;
begin
  inherited;
  FPropDefList := TObjectList.Create;
end;

destructor TCnCorPropWizard.Destroy;
begin
  FPropDefList.Free;
  inherited;
end;

function TCnCorPropWizard.GetCaption: string;
begin
  Result := SCnCorrectPropertyMenuCaption;
end;

function TCnCorPropWizard.GetDefShortCut: TShortCut;
begin
  Result := 0;
end;

function TCnCorPropWizard.GetHasConfig: Boolean;
begin
  Result := True;
end;

function TCnCorPropWizard.GetHint: string;
begin
  Result := SCnCorrectPropertyMenuHint;
end;

function TCnCorPropWizard.GetState: TWizardState;
begin
  Result := [wsEnabled];
end;

class procedure TCnCorPropWizard.GetWizardInfo(var Name, Author, Email,
  Comment: string);
begin
  Name    := SCnCorrectPropertyName;
  Author  := SCnPack_Hubdog + ';' + SCnPack_LiuXiao;
  Email   := SCnPack_HubdogEmail + ';' + SCnPack_LiuXiaoEmail;
  Comment := SCnCorrectPropertyComment;
end;

procedure TCnCorPropWizard.LoadSettings(Ini: TCustomIniFile);
begin
  inherited;

  LoadPropertyRules(WizOptions.GetUserFileName(SCnCorPropDataName, True));
  with TCnIniFile.Create(Ini) do
  begin
    try
      //��ע����ȡ������������Զ���
    finally
      Free;
    end;
  end;
end;

procedure TCnCorPropWizard.Execute;
var
  AForm: TCnCorPropForm;
begin
  // ��ʾ����
  AForm := TCnCorPropForm(FindFormByClass(TCnCorPropForm));
  if Assigned(AForm) then
  begin
    AForm.Show;
    Exit;
  end;

  AForm := TCnCorPropForm.Create(Application);
  AForm.PropDefList := FPropDefList;
  AForm.Show;
end;

procedure TCnCorPropWizard.SaveSettings(Ini: TCustomIniFile);
begin
  inherited;

  SavePropertyRules(WizOptions.GetUserFileName(SCnCorPropDataName, False));
  // ����û��ļ��������Ĭ���ļ���ͬ��ɾ������֧��Ĭ���ļ�����
  WizOptions.CheckUserFile(SCnCorPropDataName);

  with TCnIniFile.Create(Ini) do
    try
      // ��������ñ��浽ע�����
    finally
      Free;
    end;
end;

procedure TCnCorPropWizard.LoadPropertyRules(const FileName: string);
var
  i: Integer;
  APropDef: TCnPropDef;
  DefCount: Integer;
begin
  with TMemIniFile.Create(FileName) do
  begin
    try
      DefCount := ReadInteger(sSection, sCount, 0);
      for i := 0 to DefCount - 1 do
      begin
        APropDef := TCnPropDef.Create(nil);
        with APropDef do
        begin
          Action   := TPropAction (ReadInteger(sSection, Format(sActionFmt  , [I]), 0));
          Active   :=              ReadBool   (sSection, Format(sActiveFmt  , [I]), False);
          Compare  := TCompareOper(ReadInteger(sSection, Format(sCompareFmt , [I]), 0));
          CompName :=              ReadString (sSection, Format(sCompNameFmt, [I]), '');
          PropName :=              ReadString (sSection, Format(sPropNameFmt, [I]), '');
          ToValue  :=              ReadString (sSection, Format(sToValueFmt , [I]), '');
          Value    :=              ReadString (sSection, Format(sValueFmt   , [I]), '');
        end;
        FPropDefList.Add(APropDef);
      end;
    finally
      Free;
    end;
  end;
end;

procedure TCnCorPropWizard.SavePropertyRules(const FileName: string);
var
  i: Integer;
  APropDef: TCnPropDef;
begin
  with TMemIniFile.Create(FileName) do
  begin
    try
      EraseSection(sSection);
      WriteInteger(sSection, sCount, FPropDefList.Count);
      for i := 0 to FPropDefList.Count - 1 do
      begin
        APropDef := TCnPropDef(FPropDefList.Items[I]);
        with APropDef do
        begin
          WriteBool   (sSection, Format(sActiveFmt  , [I]), Active);
          WriteInteger(sSection, Format(sActionFmt  , [I]), Ord(Action));
          WriteInteger(sSection, Format(sCompareFmt , [I]), Ord(Compare));
          WriteString (sSection, Format(sCompNameFmt, [I]), CompName);
          WriteString (sSection, Format(sPropNameFmt, [I]), PropName);
          WriteString (sSection, Format(sToValueFmt , [I]), ToValue);
          WriteString (sSection, Format(sValueFmt   , [I]), Value);
        end;
      end;
    finally
      UpdateFile;
      Free;
    end;
  end;
end;

procedure TCnCorPropWizard.LanguageChanged(Sender: TObject);
begin
  ActionStr[paWarn] := SCnCorrectPropertyActionWarn;
  ActionStr[paCorrect] := SCnCorrectPropertyActionAutoCorrect;
end;

{ TCnPropDef }

procedure TCnPropDef.Assign(Source: TPersistent);
begin
  if Source is TCnPropDef then
  begin
    Action := (Source as TCnPropDef).Action;
    Active := (Source as TCnPropDef).Active;
    Compare := (Source as TCnPropDef).Compare;
    CompName := (Source as TCnPropDef).CompName;
    PropName := (Source as TCnPropDef).PropName;
    ToValue := (Source as TCnPropDef).ToValue;
    Value := (Source as TCnPropDef).Value;
  end
  else
    inherited;
end;

initialization
  RegisterCnWizard(TCnCorPropWizard);

{$ENDIF CNWIZARDS_CNCORPROPWIZARD}
end.

