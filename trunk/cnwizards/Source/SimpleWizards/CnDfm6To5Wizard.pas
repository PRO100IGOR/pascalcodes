{******************************************************************************}
{                       CnPack For Delphi/C++Builder                           }
{                     中国人自己的开放源码第三方开发包                         }
{                   (C)Copyright 2001-2011 CnPack 开发组                       }
{                   ------------------------------------                       }
{                                                                              }
{            本开发包是开源的自由软件，您可以遵照 CnPack 的发布协议来修        }
{        改和重新发布这一程序。                                                }
{                                                                              }
{            发布这一开发包的目的是希望它有用，但没有任何担保。甚至没有        }
{        适合特定目的而隐含的担保。更详细的情况请参阅 CnPack 发布协议。        }
{                                                                              }
{            您应该已经和开发包一起收到一份 CnPack 发布协议的副本。如果        }
{        还没有，可访问我们的网站：                                            }
{                                                                              }
{            网站地址：http://www.cnpack.org                                   }
{            电子邮件：master@cnpack.org                                       }
{                                                                              }
{******************************************************************************}

unit CnDfm6To5Wizard;
{ |<PRE>
================================================================================
* 软件名称：CnPack IDE 专家包
* 单元名称：在 Delphi5 中打开 D6 窗体专家
* 单元作者：周劲羽 (zjy@cnpack.org)
* 备    注：
* 开发平台：PWin2000Pro + Delphi 5.01
* 兼容测试：PWin9X/2000/XP + Delphi 5/6/7 + C++Builder 5/6
* 本 地 化：该单元中的字符串支持本地化处理方式
* 单元标识：$Id: CnDfm6To5Wizard.pas 763 2011-02-07 14:18:23Z liuxiao@cnpack.org $
* 修改记录：2004.08.22 V1.1
*               修改 PAS、CPP 扩展名为小写
*           2002.11.17 V1.0
*               创建单元
================================================================================
|</PRE>}

interface

{$I CnWizards.inc}

{$IFDEF CNWIZARDS_CNDFM6TO5WIZARD}

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  ToolsAPI, IniFiles, CnWizClasses, CnWizUtils, CnWizConsts, CnConsts;

type

//==============================================================================
// 在 Delphi5 中打开 D6 窗体专家
//==============================================================================

{ TCnDfm6To5Wizard }

  TCnDfm6To5Wizard = class(TCnMenuWizard)
  private
  
  protected
    function GetHasConfig: Boolean; override;
  public
    function GetState: TWizardState; override;
    class procedure GetWizardInfo(var Name, Author, Email, Comment: string); override;
    function GetCaption: string; override;
    function GetHint: string; override;
    function GetDefShortCut: TShortCut; override;
    procedure Execute; override;
  end;

{$ENDIF CNWIZARDS_CNDFM6TO5WIZARD}

implementation

{$IFDEF CNWIZARDS_CNDFM6TO5WIZARD}

uses
  CnWizDfm6To5, CnCommon;

//==============================================================================
// 在 Delphi5 中打开 D6 窗体专家
//==============================================================================

{ TCnDfm6To5Wizard }

procedure TCnDfm6To5Wizard.Execute;
var
  OpenDialog: TOpenDialog;
  i: Integer;
  Fn: string;
  ActionSvcs: IOTAActionServices;
begin
  OpenDialog := TOpenDialog.Create(nil);
  try
    with OpenDialog do
    begin
      DefaultExt := 'dfm';
      FilterIndex := 1;
      Filter := 'Delphi/C++Builder form (*.dfm)|*.dfm';
      Options := [ofHideReadOnly, ofAllowMultiSelect, ofEnableSizing];
      Title := 'Open';
    end;
    if OpenDialog.Execute then
    begin
      QuerySvcs(BorlandIDEServices, IOTAActionServices, ActionSvcs);
      for i := 0 to OpenDialog.Files.Count - 1 do
       if IsDfm(OpenDialog.Files[i]) then
         case DFM6To5(OpenDialog.Files[i]) of
           crSucc:
             begin
               Fn := ChangeFileExt(OpenDialog.Files[i], '.pas'); // 相关的 Pas 文件
               if not FileExists(Fn) then
                 Fn := ChangeFileExt(OpenDialog.Files[i], '.cpp'); // 相关的 Cpp 文件
               if not FileExists(Fn) then
                 Fn := OpenDialog.Files[i]; // 没有相关的单元文件，打开窗体本身
               ActionSvcs.CloseFile(Fn); // 先关闭相关单元
               ActionSvcs.OpenFile(Fn);  // 再重新打开
             end;
           crOpenError:
             ErrorDlg(Format(SCnDfm6To5OpenError, [OpenDialog.Files[i]]));
           crSaveError:
             ErrorDlg(Format(SCnDfm6To5SaveError, [OpenDialog.Files[i]]));
           crInvalidFormat:
             ErrorDlg(Format(SCnDfm6To5InvalidFormat, [OpenDialog.Files[i]]))
       end;
    end;
  finally
    OpenDialog.Free;
  end;
end;

function TCnDfm6To5Wizard.GetCaption: string;
begin
  Result := SCnDfm6To5WizardMenuCaption;
end;

function TCnDfm6To5Wizard.GetDefShortCut: TShortCut;
begin
  Result := 0;
end;

function TCnDfm6To5Wizard.GetHasConfig: Boolean;
begin
  Result := False;
end;

function TCnDfm6To5Wizard.GetHint: string;
begin
  Result := SCnDfm6To5WizardMenuHint;
end;

function TCnDfm6To5Wizard.GetState: TWizardState;
begin
  Result := [wsEnabled];
end;

class procedure TCnDfm6To5Wizard.GetWizardInfo(var Name, Author, Email, Comment: string);
begin
  Name := SCnDfm6To5WizardName;
  Author := SCnPack_Zjy;
  Email := SCnPack_ZjyEmail;
  Comment := SCnDfm6To5WizardComment;
end;

initialization

{$IFDEF COMPILER5}                    // 仅在 Delphi5/BCB5 下才注册该专家
  RegisterCnWizard(TCnDfm6To5Wizard); // 注册专家
{$ENDIF COMPILER5}

{$ENDIF CNWIZARDS_CNDFM6TO5WIZARD}
end.
