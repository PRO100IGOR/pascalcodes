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

unit CnDesignEditorConsts;
{* |<PRE>
================================================================================
* ������ƣ����������ԡ�����༭����
* ��Ԫ���ƣ���������༭���������嵥Ԫ
* ��Ԫ���ߣ�CnPack������
* ��    ע��
* ����ƽ̨��PWin2000 + Delphi 5.01
* ���ݲ��ԣ�PWin9X/2000/XP + Delphi 5/6
* �� �� �����õ�Ԫ�е��ַ��������ϱ��ػ�����ʽ
* ��Ԫ��ʶ��$Id: CnDesignEditorConsts.pas 903 2011-07-10 07:38:07Z zhoujingyu $
* �޸ļ�¼��2003.03.14 V1.2
*               �����˱��ػ��ַ���
*           2003.03.01 V1.0
*               ������Ԫ
================================================================================
|</PRE>}

interface

uses
  Windows;

{$I CnWizards.inc}

const
  // TCnImageListEditor
  csImageCacheDir = 'ImageCache';

//==============================================================================
// Need to Localize
//==============================================================================

var
  SCnPropertyEditor: string = 'Property Editor';
  SCnComponentEditor: string = 'Component Editor';
  SCnDesignEditorNameStr: string = 'Name:';
  SCnDesignEditorStateStr: string = 'State:';
  SCnPropEditorConfigFormCaption: string = '%s - Property Filter';
  SCnCompEditorCustomizeCaption: string = 'Customize Component Editor';
  SCnCompEditorCustomizeCaption1: string = 'Customize Component';
  SCnCompEditorCustomizeDesc: string = 'Component List to Register, (Format "ClassName")';

  // Editor Names
  SCnStringPropEditorName: string = 'String Caption Editor';
  sCnHintPropEditorName: string = 'Hint Editor';
  SCnStringsPropEditorName: string = 'String List Editor';
  SCnFileNamePropEditorName: string = 'FileName Editor';
  SCnSizeConstraintsPropEditorName: string = 'Constraints Editor';
  SCnFontPropEditorName: string = 'Font Editor';
  SCnControlScrollBarPropEditorName: string = 'Scrollbar Editor';
  SCnBooleanPropEditorName: string = 'Bool Editor';
  SCnSetPropEditorName: string = 'Set Editor';
  SCnAlignPropEditorName: string = 'Align Editor';
  SCnNamePropEditorName: string = 'Component Name Editor';
  SCnImageListCompEditorName: string = 'ImageList Editor';

  // Editor Comments
  SCnStringPropEditorComment: string = 'Editor for Multi-line String and Caption.';
  sCnHintPropEditorComment: string = 'Editor for Multi-line Hint, Short and Long Style Supported.';
  SCnStringsPropEditorComment: string = 'Editor for String List.';
  SCnFileNamePropEditorComment: string = 'Use OpenFile Dialog to Select FileName.';
  SCnSizeConstraintsPropEditorComment: string = 'Editor for Constraints.';
  SCnFontPropEditorComment: string = 'Editor for Font with more Information.';
  SCnControlScrollBarPropEditorComment: string = 'Editor for Scrollbar with more Information.';
  SCnBooleanPropEditorComment: string = 'Editor for Bool Property with a Checkbox.';
  SCnSetPropEditorComment: string = 'Editor for Set Property with Checkboxs in Dropdown List, Direct Input Supported.';
  SCnAlignPropEditorComment: string = 'Editor for Align Property with a bitmap.';
  SCnNamePropEditorComment: string = 'Editor for Component Name Property used Component Prefix Rules.';
  SCnImageListCompEditorComment: string = 'Editor for TImageList, XP Style Image and Online Search Supported.';

  // TCnMultiLineEditorForm
  SCnPropEditorNoMatch: string = 'No Matched Text!';
  SCnPropEditorReplaceOK: string = 'Replace OK, %D actions total.';
  SCnPropEditorCursorPos: string = 'Caret [%D:%D]';
  SCnPropEditorSaveText: string = 'Text Changed. Save it Now?';

  // TCnSizeConstraintsEditorForm
  SCnSizeConsInputError: string = 'Please Enter Integer Values.';
  SCnSizeConsInputNeg: string = 'Negative is Invalid.';

  // TCnNamePropEditor
  SCnPrefixWizardNotExist: string = 'Component Prefix Wizard NOT Exists, Please Enable It.';

  // TCnImageListEditor
  SCnImageListChangeSize: string = 'Do you want to change the image dimensions?';
  SCnImageListChangeXPStyle: string = 'Do you want to change the image style?';
  SCnImageListSearchFailed: string = 'Search image failed!';
  SCnImageListInvalidFile: string = 'The file is not a valid image file: ';
  SCnImageListSepBmp: string = 'Image dimensions for %s are greater than imagelist dimensions. Separate into %d separate bitmaps?';
  SCnImageListNoPngLib: string = 'CnPngLib.dll not found! Please reinstall CnWizards.';
  SCnImageListExportFailed: string = 'Export images failed!';
  SCnImageListXPStyleNotSupport: string = 'The ImageList uses XP Style images, but your IDE doesn''t support XPManifest! Do you want to convert images to normal style?';
  SCnImageListSearchIconsetFailed: string = 'Search icon set failed!';
  SCnImageListGotoPage: string = 'Goto Page';
  SCnImageListGotoPagePrompt: string = 'Enter new page number:';

implementation

end.
