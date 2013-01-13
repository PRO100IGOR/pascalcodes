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

unit CnScriptRegister;
{ |<PRE>
================================================================================
* ������ƣ�CnPack IDE ר�Ұ�
* ��Ԫ���ƣ��ű���չ��ע�ᵥԪ
* ��Ԫ���ߣ��ܾ��� (zjy@cnpack.org)
* ��    ע��
* ����ƽ̨��PWinXP SP2 + Delphi 5.01
* ���ݲ��ԣ�PWin9X/2000/XP + Delphi 5/6/7
* �� �� �����ô����е��ַ���֧�ֱ��ػ�����ʽ
* ��Ԫ��ʶ��$Id: CnScriptRegister.pas 763 2011-02-07 14:18:23Z liuxiao@cnpack.org $
* �޸ļ�¼��2006.12.11 V1.0
*               ������Ԫ
================================================================================
|</PRE>}

interface

{$I CnWizards.inc}

implementation

{$IFDEF CNWIZARDS_CNSCRIPTWIZARD}

{$IFDEF SUPPORT_PASCAL_SCRIPT}

uses
  uPSComponent, CnScriptClasses, CnScript_System, CnScript_Windows,
  CnScript_Messages, CnScript_SysUtils, CnScript_Classes, CnScript_TypInfo,
  CnScript_Graphics, CnScript_Controls, CnScript_Clipbrd, CnScript_Printers,
  CnScript_IniFiles, CnScript_Registry, CnScript_Menus, CnScript_ActnList,
  CnScript_Forms, CnScript_StdCtrls, CnScript_ExtCtrls, CnScript_ComCtrls,
  CnScript_Buttons, CnScript_Dialogs, CnScript_ExtDlgs, CnScript_ComObj,
{$IFDEF COMPILER6_UP}
  CnScript_DesignIntf,
  CnScript_ToolsAPI,
{$ELSE}
  CnScript_DsgnIntf,
  CnScript_ToolsAPI_D5,
{$ENDIF}
  CnScript_IdeInstComp, CnScript_CnCommon, CnScript_CnDebug, CnScript_CnWizUtils,
  CnScript_CnWizIdeUtils, CnScript_CnWizOptions, CnScript_ScriptEvent,
  CnScript_RegExpr;

initialization
  RegisterCnScriptPlugin(TPSDllPlugin);
  RegisterCnScriptPlugin(TPSImport_System);
  RegisterCnScriptPlugin(TPSImport_Windows);
  RegisterCnScriptPlugin(TPSImport_Messages);
  RegisterCnScriptPlugin(TPSImport_SysUtils);
  RegisterCnScriptPlugin(TPSImport_Classes);
  RegisterCnScriptPlugin(TPSImport_TypInfo);
  RegisterCnScriptPlugin(TPSImport_Graphics);
  RegisterCnScriptPlugin(TPSImport_Controls);
  RegisterCnScriptPlugin(TPSImport_Clipbrd);
  RegisterCnScriptPlugin(TPSImport_Printers);
  RegisterCnScriptPlugin(TPSImport_IniFiles);
  RegisterCnScriptPlugin(TPSImport_Registry);
  RegisterCnScriptPlugin(TPSImport_Menus);
  RegisterCnScriptPlugin(TPSImport_ActnList);
  RegisterCnScriptPlugin(TPSImport_Forms);
  RegisterCnScriptPlugin(TPSImport_StdCtrls);
  RegisterCnScriptPlugin(TPSImport_ExtCtrls);
  RegisterCnScriptPlugin(TPSImport_ComCtrls);
  RegisterCnScriptPlugin(TPSImport_Buttons);
  RegisterCnScriptPlugin(TPSImport_Dialogs);
  RegisterCnScriptPlugin(TPSImport_ExtDlgs);
  RegisterCnScriptPlugin(TPSImport_ComObj);
{$IFDEF COMPILER6_UP}
  RegisterCnScriptPlugin(TPSImport_DesignIntf);
{$ELSE}
  RegisterCnScriptPlugin(TPSImport_DsgnIntf);
{$ENDIF}
  RegisterCnScriptPlugin(TPSImport_ToolsAPI);
  RegisterCnScriptPlugin(TPSImport_IdeInstComp);
  RegisterCnScriptPlugin(TPSImport_CnCommon);
  RegisterCnScriptPlugin(TPSImport_CnDebug);
  RegisterCnScriptPlugin(TPSImport_CnWizUtils);
  RegisterCnScriptPlugin(TPSImport_CnWizIdeUtils);
  RegisterCnScriptPlugin(TPSImport_CnWizOptions);
  RegisterCnScriptPlugin(TPSImport_ScriptEvent);
  RegisterCnScriptPlugin(TPSImport_RegExpr);

{$ENDIF}

{$ENDIF CNWIZARDS_CNSCRIPTWIZARD}
end.
