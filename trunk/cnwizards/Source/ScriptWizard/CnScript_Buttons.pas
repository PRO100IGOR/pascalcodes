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

unit CnScript_Buttons;
{ |<PRE>
================================================================================
* ������ƣ�CnPack IDE ר�Ұ�
* ��Ԫ���ƣ��ű���չ Buttons ע����
* ��Ԫ���ߣ��ܾ��� (zjy@cnpack.org)
* ��    ע���õ�Ԫ�� UnitParser v0.7 �Զ����ɵ��ļ��޸Ķ���
* ����ƽ̨��PWinXP SP2 + Delphi 5.01
* ���ݲ��ԣ�PWin9X/2000/XP + Delphi 5/6/7
* �� �� �����ô����е��ַ���֧�ֱ��ػ�����ʽ
* ��Ԫ��ʶ��$Id: CnScript_Buttons.pas 763 2011-02-07 14:18:23Z liuxiao@cnpack.org $
* �޸ļ�¼��2006.12.29 V1.0
*               ������Ԫ
================================================================================
|</PRE>}

interface

{$I CnWizards.inc}

uses
  Windows, SysUtils, Classes, Buttons, uPSComponent, uPSRuntime, uPSCompiler;

type

  TPSImport_Buttons = class(TPSPlugin)
  public
    procedure CompileImport1(CompExec: TPSScript); override;
    procedure ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter); override;
  end;

  { compile-time registration functions }
procedure SIRegister_TBitBtn(CL: TPSPascalCompiler);
procedure SIRegister_TSpeedButton(CL: TPSPascalCompiler);
procedure SIRegister_Buttons(CL: TPSPascalCompiler);

{ run-time registration functions }
procedure RIRegister_Buttons_Routines(S: TPSExec);
procedure RIRegister_TBitBtn(CL: TPSRuntimeClassImporter);
procedure RIRegister_TSpeedButton(CL: TPSRuntimeClassImporter);
procedure RIRegister_Buttons(CL: TPSRuntimeClassImporter);

implementation

(* === compile-time registration functions === *)

procedure SIRegister_TBitBtn(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TButton', 'TBitBtn') do
  with CL.AddClass(CL.FindClass('TButton'), TBitBtn) do
  begin
    RegisterPublishedProperties;
  end;
end;

procedure SIRegister_TSpeedButton(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TGraphicControl', 'TSpeedButton') do
  with CL.AddClass(CL.FindClass('TGraphicControl'), TSpeedButton) do
  begin
    RegisterPublishedProperties;
  end;
end;

procedure SIRegister_Buttons(CL: TPSPascalCompiler);
begin
  CL.AddTypeS('TButtonLayout', '( blGlyphLeft, blGlyphRight, blGlyphTop, blGlyp'
    + 'hBottom )');
  CL.AddTypeS('TButtonState', '( bsUp, bsDisabled, bsDown, bsExclusive )');
  CL.AddTypeS('TButtonStyle', '( bsAutoDetect, bsWin31, bsNew )');
  CL.AddTypeS('TNumGlyphs', 'Integer');
  SIRegister_TSpeedButton(CL);
  CL.AddTypeS('TBitBtnKind', '( bkCustom, bkOK, bkCancel, bkHelp, bkYes, bkNo, '
    + 'bkClose, bkAbort, bkRetry, bkIgnore, bkAll )');
  SIRegister_TBitBtn(CL);
  CL.AddDelphiFunction('Function DrawButtonFace( Canvas : TCanvas; const Client : TRect; BevelWidth : Integer; Style : TButtonStyle; IsRounded, IsDown, IsFocused : Boolean) : TRect');
end;

procedure RIRegister_Buttons_Routines(S: TPSExec);
begin
  S.RegisterDelphiFunction(@DrawButtonFace, 'DrawButtonFace', cdRegister);
end;

procedure RIRegister_TBitBtn(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TBitBtn) do
  begin
  end;
end;

procedure RIRegister_TSpeedButton(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TSpeedButton) do
  begin
  end;
end;

procedure RIRegister_Buttons(CL: TPSRuntimeClassImporter);
begin
  RIRegister_TSpeedButton(CL);
  RIRegister_TBitBtn(CL);
end;

{ TPSImport_Buttons }

procedure TPSImport_Buttons.CompileImport1(CompExec: TPSScript);
begin
  SIRegister_Buttons(CompExec.Comp);
end;

procedure TPSImport_Buttons.ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter);
begin
  RIRegister_Buttons(ri);
  RIRegister_Buttons_Routines(CompExec.Exec); // comment it if no routines
end;

end.

