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

unit CnRepositoryMenu;
{ |<PRE>
================================================================================
* ������ƣ�CnPack IDE ר�Ұ�
* ��Ԫ���ƣ�ר����������
* ��Ԫ���ߣ�LiuXiao  ��liuxiao@cnpack.org��
* ��    ע���� Repository ר�Ҽ��뵽�Ӳ˵��С�
* ����ƽ̨��Windows 2000 + Delphi 5
* ���ݲ��ԣ�PWin9X/2000/XP + Delphi 5/6/7 + C++Builder 5/6
* �� �� �����ô����е��ַ��������ϱ��ػ�����ʽ
* ��Ԫ��ʶ��$Id: CnRepositoryMenu.pas 763 2011-02-07 14:18:23Z liuxiao@cnpack.org $
* �޸ļ�¼��2003.10.15 V1.0
*               ������Ԫ
================================================================================
|</PRE>}

interface

{$I CnWizards.inc}

{$IFDEF CNWIZARDS_CNREPOSITORYMENUWIZARD}

uses
  SysUtils, Classes, ToolsApi, IniFiles,
  CnConsts, CnWizClasses, CnWizManager, CnWizConsts;

type
  TCnRepositoryMenuWizard = class(TCnSubMenuWizard)
  private
    Indexes: array of Integer;
  protected
    function GetHasConfig: Boolean; override;
  public
    constructor Create; override;
    {* �๹���� }
    destructor Destroy; override;
    {* �������� }
    procedure AcquireSubActions; override;
    function GetState: TWizardState; override;
    function GetDefShortCut: TShortCut; override;
    class procedure GetWizardInfo(var Name, Author, Email, Comment: string); override;
    procedure Execute; override;
    procedure SubActionExecute(Index: Integer); override;
    procedure SubActionUpdate(Index: Integer); override;
    procedure LoadSettings(Ini: TCustomIniFile); override;
    procedure SaveSettings(Ini: TCustomIniFile); override;    
    function GetCaption: string; override;
    function GetHint: string; override;
  end;

{$ENDIF CNWIZARDS_CNREPOSITORYMENUWIZARD}

implementation

{$IFDEF CNWIZARDS_CNREPOSITORYMENUWIZARD}

{ TCnRepositoryMenu }

constructor TCnRepositoryMenuWizard.Create;
begin
  inherited;
end;

procedure TCnRepositoryMenuWizard.AcquireSubActions;
var
  I: Integer;
begin
  if CnWizardMgr <> nil then
  begin
    SetLength(Indexes, CnWizardMgr.RepositoryWizardCount);
    for I := Low(Indexes) to High(Indexes) do
      Indexes[I] := RegisterASubAction(SCnRepositoryMenuCommand + InttoStr(I) +
        CnWizardMgr.RepositoryWizards[I].GetIDStr,
        CnWizardMgr.RepositoryWizards[I].WizardName, 0,
        CnWizardMgr.RepositoryWizards[I].GetComment,
        CnWizardMgr.RepositoryWizards[I].ClassName);
  end;
end;

destructor TCnRepositoryMenuWizard.Destroy;
begin
  SetLength(Indexes, 0);
  inherited;
end;

procedure TCnRepositoryMenuWizard.Execute;
begin

end;

function TCnRepositoryMenuWizard.GetCaption: string;
begin
  Result := SCnRepositoryMenuCaption;
end;

function TCnRepositoryMenuWizard.GetDefShortCut: TShortCut;
begin
  Result := 0;
end;

function TCnRepositoryMenuWizard.GetHasConfig: Boolean;
begin
  Result := False;
end;

function TCnRepositoryMenuWizard.GetHint: string;
begin
  Result := SCnRepositoryMenuHint;
end;

function TCnRepositoryMenuWizard.GetState: TWizardState;
begin
  if Active then
    Result := [wsEnabled]
  else
    Result := [];
end;

class procedure TCnRepositoryMenuWizard.GetWizardInfo(var Name, Author, Email,
  Comment: string);
begin
  Name := SCnRepositoryMenuName;
  Author := SCnPack_LiuXiao;
  Email := SCnPack_LiuXiaoEmail;
  Comment := SCnRepositoryMenuComment;
end;

procedure TCnRepositoryMenuWizard.LoadSettings(Ini: TCustomIniFile);
begin

end;

procedure TCnRepositoryMenuWizard.SaveSettings(Ini: TCustomIniFile);
begin

end;

procedure TCnRepositoryMenuWizard.SubActionExecute(Index: Integer);
var
  I: Integer;
begin
  for I := Low(Indexes) to High(Indexes) do
    if Indexes[I] = Index then
    begin
      CnWizardMgr.RepositoryWizards[I].Execute;
      Exit;
    end;
end;

procedure TCnRepositoryMenuWizard.SubActionUpdate(Index: Integer);
var
  I: Integer;
begin
  for I := Low(Indexes) to High(Indexes) do
    if Indexes[I] = Index then
      SubActions[Index].Enabled := CnWizardMgr.RepositoryWizards[Index].Active;
end;

initialization
  RegisterCnWizard(TCnRepositoryMenuWizard);

{$ENDIF CNWIZARDS_CNREPOSITORYMENUWIZARD}
end.
