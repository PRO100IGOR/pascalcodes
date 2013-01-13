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

unit CnFavoriteWizard;
{ |<PRE>
================================================================================
* ������ƣ�CnPack IDE ר�Ұ�
* ��Ԫ���ƣ��ղؼ�ר�ҵ�Ԫ
* ��Ԫ���ߣ���ΰ��Alan�� BeyondStudio@163.com
* ��    ע��
* ����ƽ̨��PWin2000Pro + Delphi 5.01
* ���ݲ��ԣ�PWin9X/2000/XP + Delphi 5/6/7 + C++Builder 5/6
* �� �� �����ô����е��ַ���֧�ֱ��ػ�����ʽ
* ��Ԫ��ʶ��$Id: CnFavoriteWizard.pas 763 2011-02-07 14:18:23Z liuxiao@cnpack.org $
* �޸ļ�¼��2003.07.15 V1.0
*               ������Ԫ
================================================================================
|</PRE>}

interface

{$I CnWizards.inc}

uses
  Windows, Messages, SysUtils, Classes, Controls, Forms, Dialogs, ToolsAPI,
  IniFiles, CnBaseWizard, CnConsts, CnWizUtils, CnWizConsts, CnAddToFavoriteFrm,
  CnManageFavoriteFrm, CnWizIdeUtils;

type

//==============================================================================
// �ղؼ�ר��
//==============================================================================

{ TCnFavoriteWizard }

  TCnFavoriteWizard = class(TCnSubMenuWizard)
  private
    IDAddToFavorite: Integer;
    IDManageFavorite: Integer;
  protected
    function GetHasConfig: Boolean; override;
    procedure SubActionExecute(Index: Integer); override;
    procedure SubActionUpdate(Index: Integer); override;
  public
    constructor Create; override;
    function GetState: TWizardState; override;
    procedure Config; override;
    procedure Loaded; override;
    procedure LoadSettings(Ini: TCustomIniFile); override;
    procedure SaveSettings(Ini: TCustomIniFile); override;
    class procedure GetWizardInfo(var Name, Author, Email, Comment: string); override;
    function GetCaption: string; override;
    function GetHint: string; override;
  end;

implementation

{$IFDEF Debug}
uses
  uDbg;
{$ENDIF Debug}

{ TCnFavoriteWizard }

procedure TCnFavoriteWizard.Config;
begin
  ShowShortCutDialog('CnFavoriteWizard');
end;

constructor TCnFavoriteWizard.Create;
begin
  inherited;

  IDAddToFavorite := AddSubAction(SCnFavWizAddToFavorite,
    SCnFavWizAddToFavoriteMenuCaption, 0,
    SCnFavWizAddToFavoriteMenuHint, SCnFavWizAddToFavorite);

  IDManageFavorite := AddSubAction(SCnFavWizManageFavorite,
    SCnFavWizManageFavoriteMenuCaption, 0,
    SCnFavWizManageFavoriteMenuHint, SCnFavWizManageFavorite);

  AddSepMenu;
end;

function TCnFavoriteWizard.GetCaption: string;
begin
  Result := SCnFavWizCaption;
end;

function TCnFavoriteWizard.GetHasConfig: Boolean;
begin
  Result := True;
end;

function TCnFavoriteWizard.GetHint: string;
begin
  Result := SCnFavWizHint;
end;

function TCnFavoriteWizard.GetState: TWizardState;
begin
  Result := [wsEnabled];
end;

class procedure TCnFavoriteWizard.GetWizardInfo(var Name, Author, Email,
  Comment: string);
begin
  Name := SCnFavWizName;
  Author := SCnPack_Alan;
  Email := SCnPack_AlanEmail;
  Comment := SCnFavWizComment;
end;

procedure TCnFavoriteWizard.Loaded;
begin
  inherited;

end;

procedure TCnFavoriteWizard.LoadSettings(Ini: TCustomIniFile);
begin
  inherited;

end;

procedure TCnFavoriteWizard.SaveSettings(Ini: TCustomIniFile);
begin
  inherited;

end;

procedure TCnFavoriteWizard.SubActionExecute(Index: Integer);
begin
  if not Active then Exit;

  if Index = IDAddToFavorite then
    ShowAddToFavoriteForm
  else
  if Index = IDManageFavorite then
    ShowManageFavoriteForm;
end;

procedure TCnFavoriteWizard.SubActionUpdate(Index: Integer);
var
  AEnabled: Boolean;
begin
  AEnabled := (CnOtaGetCurrentFormEditor <> nil) or (CnOtaGetCurrentSourceEditor <> nil);

  SubActions[IDAddToFavorite].Visible := Active;
  SubActions[IDAddToFavorite].Enabled := AEnabled;
end;

initialization
  RegisterCnWizard(TCnFavoriteWizard); // ע��ר��

end.
