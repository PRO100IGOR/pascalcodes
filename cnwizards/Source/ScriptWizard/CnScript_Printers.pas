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

unit CnScript_Printers;
{ |<PRE>
================================================================================
* ������ƣ�CnPack IDE ר�Ұ�
* ��Ԫ���ƣ��ű���չ Printers ע����
* ��Ԫ���ߣ��ܾ��� (zjy@cnpack.org)
* ��    ע���õ�Ԫ�� UnitParser v0.7 �Զ����ɵ��ļ��޸Ķ���
* ����ƽ̨��PWinXP SP2 + Delphi 5.01
* ���ݲ��ԣ�PWin9X/2000/XP + Delphi 5/6/7
* �� �� �����ô����е��ַ���֧�ֱ��ػ�����ʽ
* ��Ԫ��ʶ��$Id: CnScript_Printers.pas 763 2011-02-07 14:18:23Z liuxiao@cnpack.org $
* �޸ļ�¼��2006.12.30 V1.0
*               ������Ԫ
================================================================================
|</PRE>}

interface

{$I CnWizards.inc}

uses
  Windows, SysUtils, Classes, Printers, Graphics, uPSComponent, uPSRuntime,
  uPSCompiler;

type

  TPSImport_Printers = class(TPSPlugin)
  public
    procedure CompileImport1(CompExec: TPSScript); override;
    procedure ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter); override;
  end;

  { compile-time registration functions }
procedure SIRegister_TPrinter(CL: TPSPascalCompiler);
procedure SIRegister_Printers(CL: TPSPascalCompiler);

{ run-time registration functions }
procedure RIRegister_Printers_Routines(S: TPSExec);
procedure RIRegister_TPrinter(CL: TPSRuntimeClassImporter);
procedure RIRegister_Printers(CL: TPSRuntimeClassImporter);

implementation

(* === compile-time registration functions === *)

procedure SIRegister_TPrinter(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TObject', 'TPrinter') do
  with CL.AddClass(CL.FindClass('TObject'), TPrinter) do
  begin
    RegisterMethod('Constructor Create');
    RegisterMethod('Procedure Abort');
    RegisterMethod('Procedure BeginDoc');
    RegisterMethod('Procedure EndDoc');
    RegisterMethod('Procedure NewPage');
    RegisterMethod('Procedure GetPrinter( ADevice, ADriver, APort : PChar; var ADeviceMode : THandle)');
    RegisterMethod('Procedure SetPrinter( ADevice, ADriver, APort : PChar; ADeviceMode : THandle)');
    RegisterMethod('Procedure Refresh');
    RegisterProperty('Aborted', 'Boolean', iptr);
    RegisterProperty('Canvas', 'TCanvas', iptr);
    RegisterProperty('Capabilities', 'TPrinterCapabilities', iptr);
    RegisterProperty('Copies', 'Integer', iptrw);
    RegisterProperty('Fonts', 'TStrings', iptr);
    RegisterProperty('Handle', 'HDC', iptr);
    RegisterProperty('Orientation', 'TPrinterOrientation', iptrw);
    RegisterProperty('PageHeight', 'Integer', iptr);
    RegisterProperty('PageWidth', 'Integer', iptr);
    RegisterProperty('PageNumber', 'Integer', iptr);
    RegisterProperty('PrinterIndex', 'Integer', iptrw);
    RegisterProperty('Printing', 'Boolean', iptr);
    RegisterProperty('Printers', 'TStrings', iptr);
    RegisterProperty('Title', 'string', iptrw);
  end;
end;

procedure SIRegister_Printers(CL: TPSPascalCompiler);
begin
  CL.AddTypeS('TPrinterState', '( psNoHandle, psHandleIC, psHandleDC )');
  CL.AddTypeS('TPrinterOrientation', '( poPortrait, poLandscape )');
  CL.AddTypeS('TPrinterCapability', '( pcCopies, pcOrientation, pcCollation )');
  CL.AddTypeS('TPrinterCapabilities', 'set of TPrinterCapability');
  SIRegister_TPrinter(CL);
  CL.AddDelphiFunction('Function Printer : TPrinter');
end;

(* === run-time registration functions === *)

procedure TPrinterTitle_W(Self: TPrinter; const T: string);
begin
  Self.Title := T;
end;

procedure TPrinterTitle_R(Self: TPrinter; var T: string);
begin
  T := Self.Title;
end;

procedure TPrinterPrinters_R(Self: TPrinter; var T: TStrings);
begin
  T := Self.Printers;
end;

procedure TPrinterPrinting_R(Self: TPrinter; var T: Boolean);
begin
  T := Self.Printing;
end;

procedure TPrinterPrinterIndex_W(Self: TPrinter; const T: Integer);
begin
  Self.PrinterIndex := T;
end;

procedure TPrinterPrinterIndex_R(Self: TPrinter; var T: Integer);
begin
  T := Self.PrinterIndex;
end;

procedure TPrinterPageNumber_R(Self: TPrinter; var T: Integer);
begin
  T := Self.PageNumber;
end;

procedure TPrinterPageWidth_R(Self: TPrinter; var T: Integer);
begin
  T := Self.PageWidth;
end;

procedure TPrinterPageHeight_R(Self: TPrinter; var T: Integer);
begin
  T := Self.PageHeight;
end;

procedure TPrinterOrientation_W(Self: TPrinter; const T: TPrinterOrientation);
begin
  Self.Orientation := T;
end;

procedure TPrinterOrientation_R(Self: TPrinter; var T: TPrinterOrientation);
begin
  T := Self.Orientation;
end;

procedure TPrinterHandle_R(Self: TPrinter; var T: HDC);
begin
  T := Self.Handle;
end;

procedure TPrinterFonts_R(Self: TPrinter; var T: TStrings);
begin
  T := Self.Fonts;
end;

procedure TPrinterCopies_W(Self: TPrinter; const T: Integer);
begin
  Self.Copies := T;
end;

procedure TPrinterCopies_R(Self: TPrinter; var T: Integer);
begin
  T := Self.Copies;
end;

procedure TPrinterCapabilities_R(Self: TPrinter; var T: TPrinterCapabilities);
begin
  T := Self.Capabilities;
end;

procedure TPrinterCanvas_R(Self: TPrinter; var T: TCanvas);
begin
  T := Self.Canvas;
end;

procedure TPrinterAborted_R(Self: TPrinter; var T: Boolean);
begin
  T := Self.Aborted;
end;

procedure RIRegister_Printers_Routines(S: TPSExec);
begin
  S.RegisterDelphiFunction(@Printer, 'Printer', cdRegister);
end;

procedure RIRegister_TPrinter(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TPrinter) do
  begin
    RegisterConstructor(@TPrinter.Create, 'Create');
    RegisterMethod(@TPrinter.Abort, 'Abort');
    RegisterMethod(@TPrinter.BeginDoc, 'BeginDoc');
    RegisterMethod(@TPrinter.EndDoc, 'EndDoc');
    RegisterMethod(@TPrinter.NewPage, 'NewPage');
    RegisterMethod(@TPrinter.GetPrinter, 'GetPrinter');
    RegisterMethod(@TPrinter.SetPrinter, 'SetPrinter');
    RegisterMethod(@TPrinter.Refresh, 'Refresh');
    RegisterPropertyHelper(@TPrinterAborted_R, nil, 'Aborted');
    RegisterPropertyHelper(@TPrinterCanvas_R, nil, 'Canvas');
    RegisterPropertyHelper(@TPrinterCapabilities_R, nil, 'Capabilities');
    RegisterPropertyHelper(@TPrinterCopies_R, @TPrinterCopies_W, 'Copies');
    RegisterPropertyHelper(@TPrinterFonts_R, nil, 'Fonts');
    RegisterPropertyHelper(@TPrinterHandle_R, nil, 'Handle');
    RegisterPropertyHelper(@TPrinterOrientation_R, @TPrinterOrientation_W, 'Orientation');
    RegisterPropertyHelper(@TPrinterPageHeight_R, nil, 'PageHeight');
    RegisterPropertyHelper(@TPrinterPageWidth_R, nil, 'PageWidth');
    RegisterPropertyHelper(@TPrinterPageNumber_R, nil, 'PageNumber');
    RegisterPropertyHelper(@TPrinterPrinterIndex_R, @TPrinterPrinterIndex_W, 'PrinterIndex');
    RegisterPropertyHelper(@TPrinterPrinting_R, nil, 'Printing');
    RegisterPropertyHelper(@TPrinterPrinters_R, nil, 'Printers');
    RegisterPropertyHelper(@TPrinterTitle_R, @TPrinterTitle_W, 'Title');
  end;
end;

procedure RIRegister_Printers(CL: TPSRuntimeClassImporter);
begin
  RIRegister_TPrinter(CL);
end;

{ TPSImport_Printers }

procedure TPSImport_Printers.CompileImport1(CompExec: TPSScript);
begin
  SIRegister_Printers(CompExec.Comp);
end;

procedure TPSImport_Printers.ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter);
begin
  RIRegister_Printers(ri);
  RIRegister_Printers_Routines(CompExec.Exec); // comment it if no routines
end;

end.



