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

unit CnGraphPropEditors;
{* |<PRE>
================================================================================
* 软件名称：界面控件包
* 单元名称：界面控件包属性编辑器单元
* 单元作者：周劲羽 (zjy@cnpack.org)
* 备    注：该单元当前仅为内部参考测试用
* 开发平台：PWin98SE + Delphi 5.0
* 兼容测试：PWin9X/2000/XP + Delphi 5/6
* 本 地 化：该单元中的字符串均符合本地化处理方式
* 单元标识：$Id: CnGraphPropEditors.pas 761 2011-02-07 14:08:58Z liuxiao@cnpack.org $
* 修改记录：2002.04.08 V1.0
*               创建单元
================================================================================
|</PRE>}

interface

{$I CnPack.inc}

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  {$IFDEF COMPILER6_UP}
  DesignIntf, DesignEditors,
  {$ELSE}
  DsgnIntf,
  {$ENDIF}
  CnVCLBase, CnGraphics, CnImage, ExtDlgs;

type

{ TCnBitmapProperty }

  TCnBitmapProperty = class(TPropertyEditor)
  {* TBitmap属性编辑器类，用于TCnImage中，内部测试用}
  public
    procedure Edit; override;
    {* 编辑属性}
    function GetAttributes: TPropertyAttributes; override;
    {* 取属性编辑状态}
    function GetValue: string; override;
    {* 取属性显示字体串}
    procedure SetValue(const Value: string); override;
    {* 设置属性文本值}
  end;

implementation

{ TCnBitmapProperty }

procedure TCnBitmapProperty.Edit;
begin
  if GetComponent(0) is TCnImage then
    with TOpenPictureDialog.Create(nil) do
    try
      if Execute then
        TCnImage(GetComponent(0)).Bitmap.LoadFromFile(FileName);
    finally
      Free;
    end;
end;

function TCnBitmapProperty.GetAttributes: TPropertyAttributes;
begin
  Result := [paDialog, paRevertable];
end;

function TCnBitmapProperty.GetValue: string;
begin
  Result := '(None)';
  if GetComponent(0) is TCnImage then
    with TCnImage(GetComponent(0)) do
      if (Bitmap <> nil) and not Bitmap.Empty then
        Result := '(TCnBitmap)';
end;

procedure TCnBitmapProperty.SetValue(const Value: string);
begin
  if GetComponent(0) is TCnImage then
    if Value = '' then
      TCnImage(GetComponent(0)).Bitmap.FreeImage;
end;

end.



