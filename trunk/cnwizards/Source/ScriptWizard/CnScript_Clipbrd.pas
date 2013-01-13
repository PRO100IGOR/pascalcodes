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

unit CnScript_Clipbrd;
{ |<PRE>
================================================================================
* ������ƣ�CnPack IDE ר�Ұ�
* ��Ԫ���ƣ��ű���չ Clipbrd ע����
* ��Ԫ���ߣ��ܾ��� (zjy@cnpack.org)
* ��    ע���õ�Ԫ�� UnitParser v0.7 �Զ����ɵ��ļ��޸Ķ���
* ����ƽ̨��PWinXP SP2 + Delphi 5.01
* ���ݲ��ԣ�PWin9X/2000/XP + Delphi 5/6/7
* �� �� �����ô����е��ַ���֧�ֱ��ػ�����ʽ
* ��Ԫ��ʶ��$Id: CnScript_Clipbrd.pas 763 2011-02-07 14:18:23Z liuxiao@cnpack.org $
* �޸ļ�¼��2006.12.30 V1.0
*               ������Ԫ
================================================================================
|</PRE>}

interface

{$I CnWizards.inc}

uses
  Windows, SysUtils, Classes, Clipbrd, uPSComponent, uPSRuntime, uPSCompiler;

type

  TPSImport_Clipbrd = class(TPSPlugin)
  public
    procedure CompileImport1(CompExec: TPSScript); override;
    procedure ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter); override;
  end;

  { compile-time registration functions }
procedure SIRegister_TClipboard(CL: TPSPascalCompiler);
procedure SIRegister_Clipbrd(CL: TPSPascalCompiler);

{ run-time registration functions }
procedure RIRegister_Clipbrd_Routines(S: TPSExec);
procedure RIRegister_TClipboard(CL: TPSRuntimeClassImporter);
procedure RIRegister_Clipbrd(CL: TPSRuntimeClassImporter);

implementation

(* === compile-time registration functions === *)

procedure SIRegister_TClipboard(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TPersistent', 'TClipboard') do
  with CL.AddClass(CL.FindClass('TPersistent'), TClipboard) do
  begin
    RegisterMethod('Procedure Clear');
    RegisterMethod('Procedure Close');
    RegisterMethod('Function GetComponent( Owner, Parent : TComponent) : TComponent');
    RegisterMethod('Function GetAsHandle( Format : Word) : THandle');
    RegisterMethod('Function GetTextBuf( Buffer : PChar; BufSize : Integer) : Integer');
    RegisterMethod('Function HasFormat( Format : Word) : Boolean');
    RegisterMethod('Procedure Open');
    RegisterMethod('Procedure SetComponent( Component : TComponent)');
    RegisterMethod('Procedure SetAsHandle( Format : Word; Value : THandle)');
    RegisterMethod('Procedure SetTextBuf( Buffer : PChar)');
    RegisterProperty('AsText', 'string', iptrw);
    RegisterProperty('FormatCount', 'Integer', iptr);
    RegisterProperty('Formats', 'Word Integer', iptr);
  end;
end;

procedure SIRegister_Clipbrd(CL: TPSPascalCompiler);
begin
  SIRegister_TClipboard(CL);
  CL.AddDelphiFunction('Function Clipboard : TClipboard');
end;

(* === run-time registration functions === *)

procedure TClipboardFormats_R(Self: TClipboard; var T: Word; const t1: Integer);
begin
  T := Self.Formats[t1];
end;

procedure TClipboardFormatCount_R(Self: TClipboard; var T: Integer);
begin
  T := Self.FormatCount;
end;

procedure TClipboardAsText_W(Self: TClipboard; const T: string);
begin
  Self.AsText := T;
end;

procedure TClipboardAsText_R(Self: TClipboard; var T: string);
begin
  T := Self.AsText;
end;

procedure RIRegister_Clipbrd_Routines(S: TPSExec);
begin
  S.RegisterDelphiFunction(@Clipboard, 'Clipboard', cdRegister);
end;

procedure RIRegister_TClipboard(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TClipboard) do
  begin
    RegisterMethod(@TClipboard.Clear, 'Clear');
    RegisterMethod(@TClipboard.Close, 'Close');
    RegisterMethod(@TClipboard.GetComponent, 'GetComponent');
    RegisterMethod(@TClipboard.GetAsHandle, 'GetAsHandle');
    RegisterMethod(@TClipboard.GetTextBuf, 'GetTextBuf');
    RegisterMethod(@TClipboard.HasFormat, 'HasFormat');
    RegisterMethod(@TClipboard.Open, 'Open');
    RegisterMethod(@TClipboard.SetComponent, 'SetComponent');
    RegisterMethod(@TClipboard.SetAsHandle, 'SetAsHandle');
    RegisterMethod(@TClipboard.SetTextBuf, 'SetTextBuf');
    RegisterPropertyHelper(@TClipboardAsText_R, @TClipboardAsText_W, 'AsText');
    RegisterPropertyHelper(@TClipboardFormatCount_R, nil, 'FormatCount');
    RegisterPropertyHelper(@TClipboardFormats_R, nil, 'Formats');
  end;
end;

procedure RIRegister_Clipbrd(CL: TPSRuntimeClassImporter);
begin
  RIRegister_TClipboard(CL);
end;

{ TPSImport_Clipbrd }

procedure TPSImport_Clipbrd.CompileImport1(CompExec: TPSScript);
begin
  SIRegister_Clipbrd(CompExec.Comp);
end;

procedure TPSImport_Clipbrd.ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter);
begin
  RIRegister_Clipbrd(ri);
  RIRegister_Clipbrd_Routines(CompExec.Exec); // comment it if no routines
end;

end.



