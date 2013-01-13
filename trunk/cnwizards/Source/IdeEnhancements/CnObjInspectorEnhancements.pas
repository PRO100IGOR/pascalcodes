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

unit CnObjInspectorEnhancements;
{ |<PRE>
================================================================================
* ������ƣ�CnPack IDE ר�Ұ�
* ��Ԫ���ƣ�����鿴����չ��Ԫ
* ��Ԫ���ߣ��ܾ��� (zjy@cnpack.org)
* ��    ע��
* ����ƽ̨��PWin2000Pro + Delphi 5.01
* ���ݲ��ԣ�
* �� �� �����õ�Ԫ�е��ַ���֧�ֱ��ػ�����ʽ
* ��Ԫ��ʶ��$Id: CnObjInspectorEnhancements.pas 763 2011-02-07 14:18:23Z liuxiao@cnpack.org $
* �޸ļ�¼��2004.5.15 chinbo(shenloqi)
*               ֧��setelement�Ĵ�����ʾ
*           2003.10.31
*               ע������Ч��ö��Ԫ�صļӴ�
*           2003.10.27
*               ����ʵ����D5�µļӴֹ��ܣ�D6,D7��Ҫ���������ķ�����
*           2003.10.27
*               ʵ�����Ա༭�������ҽӺ��ļ���
================================================================================
|</PRE>}

interface

{$I CnWizards.inc}

{$IFDEF CNWIZARDS_CNOBJINSPECTORENHANCEWIZARD}

{$IFDEF COMPILER6_UP}
  'Error: This wizard can used only for Delphi/C++ Builder 5.'
{$ENDIF COMPILER6_UP}

uses
  Windows, SysUtils, Classes, Graphics, IniFiles, TypInfo,
{$IFDEF COMPILER6_UP}
  DesignIntf, DesignEditors, VCLEditors,
{$ELSE}
  DsgnIntf,
{$ENDIF}
  CnConsts, CnWizClasses, CnWizConsts, CnWizMethodHook;

type
  TCnObjInspectorEnhanceWizard = class(TCnIDEEnhanceWizard)
  private
    procedure HookPropEditor;
    procedure UnhookPropEditor;
  protected
    function GetHasConfig: Boolean; override;
    procedure SetActive(Value: Boolean); override;
  public
    constructor Create; override;
    destructor Destroy; override;

    class procedure GetWizardInfo(var Name, Author, Email, Comment: string); override;
    procedure LoadSettings(Ini: TCustomIniFile); override;
    procedure SaveSettings(Ini: TCustomIniFile); override;
    procedure Config; override;
  end;

{$ENDIF CNWIZARDS_CNOBJINSPECTORENHANCEWIZARD}

implementation

{$IFDEF CNWIZARDS_CNOBJINSPECTORENHANCEWIZARD}

uses
  CnCommon;

type
  // ԭ���Ա༭�����Ʒ�������Ϊԭ����Ϊ���󷽷���ר����ʹ����ͨ�������ҽӣ�
  // �ʶ���һ�� ASelf: TPropertyEditor �����ض���ʵ��
  TPropDrawProc = procedure (ASelf: TPropertyEditor; ACanvas: TCanvas;
    const ARect: TRect; ASelected: Boolean);

var
  OldPropDrawName: TPropDrawProc;
  OldPropDrawValue: TPropDrawProc;
  PropDrawNameHook: TCnMethodHook;
  PropDrawValueHook: TCnMethodHook;
  AllowHook: Boolean;

// �ҽ� TPropertyEditor.PropDrawName �ķ���
type
  THackPropertyEditor = class(TPropertyEditor);

procedure PropDrawName(ASelf: TPropertyEditor; ACanvas: TCanvas;
  const ARect: TRect; ASelected: Boolean);
begin
  if AllowHook and (ASelf.PropCount > 0) then
  begin
    // ������ PropCount = 0 ʱ���� GetPropType ����
    if (THackPropertyEditor(ASelf).GetPropType.Kind in [tkClass]) and
      (not (paSubProperties in ASelf.GetAttributes)) and
      (not (paDialog in ASelf.GetAttributes)) and
      (paValueList in ASelf.GetAttributes) then
      ACanvas.Font.Color := clMaroon;
  end;

  // ����ԭ���ķ���
  PropDrawNameHook.UnhookMethod;
  try
    OldPropDrawName(ASelf, ACanvas, ARect, ASelected);
  finally
    PropDrawNameHook.HookMethod;
  end;
end;

// �ҽ� TPropertyEditor.PropDrawValue �ķ���
procedure PropDrawValue(ASelf: TPropertyEditor; ACanvas: TCanvas;
  const ARect: TRect; ASelected: Boolean);
const
  tkOrdinal = [tkEnumeration, tkInteger, tkChar, tkWChar];

  function _ObjPropAllEqualDef(AObj: TObject): Boolean;
  var
    PropList: PPropList;
    Count, I: Integer;
  begin
    Result := True;
    try
      Count := GetPropList(AObj.ClassInfo, tkOrdinal, nil);
    except
      Exit;
    end;

    GetMem(PropList, Count * SizeOf(PPropInfo));
    try
      GetPropList(AObj.ClassInfo, tkOrdinal, PropList);
      for i := 0 to Count - 1 do
        if PropList[I].Default <> GetOrdProp(AObj, PropList[I]) then
        begin
          Result := False;
          Break;
        end;
    finally
      FreeMem(PropList);
    end;
  end;

var
  EnumInfo: PTypeInfo;
  dwDefault, dwValue: DWORD;
  dwbBit: TDWordBit;
begin
  if AllowHook and (ASelf.PropCount > 0) then
  begin
    // ����IsStoredProp
    if not ASelected then
    begin

      if ASelf is TSetElementProperty then
      begin
        EnumInfo := GetTypeData(THackPropertyEditor(ASelf).GetPropType).CompType^;
        dwDefault := THackPropertyEditor(ASelf).GetPropInfo.Default;
        dwValue := THackPropertyEditor(ASelf).GetOrdValue;
        dwbBit := GetEnumValue(EnumInfo, TSetElementProperty(ASelf).GetName);
        if GetBit(dwDefault, dwbBit) <>
          GetBit(dwValue, dwbBit) then
        begin
          ACanvas.Font.Style := ACanvas.Font.Style + [fsBold];
        end
        else
          ACanvas.Font.Style := ACanvas.Font.Style - [fsBold];
      end
      else
      // TODO: �ж��¼��ǲ��Ǽ̳е�
      if ((THackPropertyEditor(ASelf).GetPropType.Kind in tkOrdinal) and
          (THackPropertyEditor(ASelf).GetOrdValue <> THackPropertyEditor(ASelf).GetPropInfo.default)) or
        ((THackPropertyEditor(ASelf).GetPropType.Kind in [tkFloat]) and
          (THackPropertyEditor(ASelf).GetFloatValue <> 0)) or
        ((THackPropertyEditor(ASelf).GetPropType.Kind in [tkString, tkLString, tkWString{$IFDEF UNICODE_STRING}, tkUString{$ENDIF}]) and
          (THackPropertyEditor(ASelf).GetStrValue <> '') and (THackPropertyEditor(ASelf).GetName <> 'Name')) or
        ((THackPropertyEditor(ASelf).GetPropType.Kind in [tkInt64]) and
          (THackPropertyEditor(ASelf).GetInt64Value <> THackPropertyEditor(ASelf).GetPropInfo.default)) or
        ((THackPropertyEditor(ASelf).GetPropType.Kind = tkClass) and
          (Pointer(THackPropertyEditor(ASelf).GetOrdValue) <> nil) and
          (not _ObjPropAllEqualDef(TObject(THackPropertyEditor(ASelf).GetOrdValue)))) or
        ((THackPropertyEditor(ASelf).GetPropType.Kind in [tkMethod]) and
          (THackPropertyEditor(ASelf).GetMethodValue.Code <> nil)) then
          ACanvas.Font.Style := ACanvas.Font.Style + [fsBold];
    end;
  end;

  // ����ԭ���ķ���
  PropDrawValueHook.UnhookMethod;
  try
    OldPropDrawValue(ASelf, ACanvas, ARect, ASelected);
  finally
    PropDrawValueHook.HookMethod;
  end;
end;

{ TCnObjInspectorEnhanceWizard }

constructor TCnObjInspectorEnhanceWizard.Create;
begin
  inherited;
  HookPropEditor;
end;

destructor TCnObjInspectorEnhanceWizard.Destroy;
begin
  UnhookPropEditor;
  inherited;
end;

procedure TCnObjInspectorEnhanceWizard.HookPropEditor;
begin
  // ȡ��ԭ�е����Ա༭�����Ʒ�����ַ
  OldPropDrawName := GetBplMethodAddress(@TPropertyEditor.PropDrawName);
  OldPropDrawValue := GetBplMethodAddress(@TPropertyEditor.PropDrawValue);
  // �ҽ����Ա༭�����Ʒ���
  PropDrawNameHook := TCnMethodHook.Create(@OldPropDrawName, @PropDrawName);
  PropDrawValueHook := TCnMethodHook.Create(@OldPropDrawValue, @PropDrawValue);
end;

procedure TCnObjInspectorEnhanceWizard.UnhookPropEditor;
begin
  OldPropDrawName := nil;
  OldPropDrawValue := nil;
  FreeAndNil(PropDrawNameHook);
  FreeAndNil(PropDrawValueHook);
end;

procedure TCnObjInspectorEnhanceWizard.LoadSettings(Ini: TCustomIniFile);
begin
  inherited;
  { TODO : װ������ }
end;

procedure TCnObjInspectorEnhanceWizard.SaveSettings(Ini: TCustomIniFile);
begin
  inherited;
  { TODO : �������� }
end;

procedure TCnObjInspectorEnhanceWizard.SetActive(Value: Boolean);
begin
  inherited;
  AllowHook := Value;
end;

procedure TCnObjInspectorEnhanceWizard.Config;
begin
  { TODO : ��ʾ���ô��� }
end;

function TCnObjInspectorEnhanceWizard.GetHasConfig: Boolean;
begin
  Result := False;
end;

class procedure TCnObjInspectorEnhanceWizard.GetWizardInfo(var Name,
  Author, Email, Comment: string);
begin
  Name := SCnObjInspectorEnhanceWizardName;
  Author := SCnPack_Zjy;
  Email := SCnPack_ZjyEmail;
  Comment := SCnObjInspectorEnhanceWizardComment;
end;

initialization
  RegisterCnWizard(TCnObjInspectorEnhanceWizard);

{$ENDIF CNWIZARDS_CNOBJINSPECTORENHANCEWIZARD}
end.
