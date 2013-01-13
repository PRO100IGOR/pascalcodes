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

unit CnScript_ExtDlgs;
{ |<PRE>
================================================================================
* ������ƣ�CnPack IDE ר�Ұ�
* ��Ԫ���ƣ��ű���չ ExtDlgs ע����
* ��Ԫ���ߣ��ܾ��� (zjy@cnpack.org)
* ��    ע���õ�Ԫ�� UnitParser v0.7 �Զ����ɵ��ļ��޸Ķ���
* ����ƽ̨��PWinXP SP2 + Delphi 5.01
* ���ݲ��ԣ�PWin9X/2000/XP + Delphi 5/6/7
* �� �� �����ô����е��ַ���֧�ֱ��ػ�����ʽ
* ��Ԫ��ʶ��$Id: CnScript_ExtDlgs.pas 763 2011-02-07 14:18:23Z liuxiao@cnpack.org $
* �޸ļ�¼��2006.12.30 V1.0
*               ������Ԫ
================================================================================
|</PRE>}

interface

{$I CnWizards.inc}

uses
  Windows, SysUtils, Classes, Dialogs, ExtDlgs, uPSComponent, uPSRuntime, uPSCompiler;

type

  TPSImport_ExtDlgs = class(TPSPlugin)
  public
    procedure CompileImport1(CompExec: TPSScript); override;
    procedure ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter); override;
  end;

  { compile-time registration functions }
procedure SIRegister_TSavePictureDialog(CL: TPSPascalCompiler);
procedure SIRegister_TOpenPictureDialog(CL: TPSPascalCompiler);
procedure SIRegister_ExtDlgs(CL: TPSPascalCompiler);

{ run-time registration functions }
procedure RIRegister_TSavePictureDialog(CL: TPSRuntimeClassImporter);
procedure RIRegister_TOpenPictureDialog(CL: TPSRuntimeClassImporter);
procedure RIRegister_ExtDlgs(CL: TPSRuntimeClassImporter);

implementation

(* === compile-time registration functions === *)

procedure SIRegister_TSavePictureDialog(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TOpenPictureDialog', 'TSavePictureDialog') do
  with CL.AddClass(CL.FindClass('TOpenPictureDialog'), TSavePictureDialog) do
  begin
  end;
end;

procedure SIRegister_TOpenPictureDialog(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TOpenDialog', 'TOpenPictureDialog') do
  with CL.AddClass(CL.FindClass('TOpenDialog'), TOpenPictureDialog) do
  begin
  end;
end;

procedure SIRegister_ExtDlgs(CL: TPSPascalCompiler);
begin
  SIRegister_TOpenPictureDialog(CL);
  SIRegister_TSavePictureDialog(CL);
end;

(* === run-time registration functions === *)

procedure RIRegister_TSavePictureDialog(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TSavePictureDialog) do
  begin
  end;
end;

procedure RIRegister_TOpenPictureDialog(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TOpenPictureDialog) do
  begin
  end;
end;

procedure RIRegister_ExtDlgs(CL: TPSRuntimeClassImporter);
begin
  RIRegister_TOpenPictureDialog(CL);
  RIRegister_TSavePictureDialog(CL);
end;

{ TPSImport_ExtDlgs }

procedure TPSImport_ExtDlgs.CompileImport1(CompExec: TPSScript);
begin
  SIRegister_ExtDlgs(CompExec.Comp);
end;

procedure TPSImport_ExtDlgs.ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter);
begin
  RIRegister_ExtDlgs(ri);
end;

end.



