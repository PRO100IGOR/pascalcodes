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

unit CnScript_IniFiles;
{ |<PRE>
================================================================================
* ������ƣ�CnPack IDE ר�Ұ�
* ��Ԫ���ƣ��ű���չ IniFiles ע����
* ��Ԫ���ߣ��ܾ��� (zjy@cnpack.org)
* ��    ע���õ�Ԫ�� UnitParser v0.7 �Զ����ɵ��ļ��޸Ķ���
* ����ƽ̨��PWinXP SP2 + Delphi 5.01
* ���ݲ��ԣ�PWin9X/2000/XP + Delphi 5/6/7
* �� �� �����ô����е��ַ���֧�ֱ��ػ�����ʽ
* ��Ԫ��ʶ��$Id: CnScript_IniFiles.pas 763 2011-02-07 14:18:23Z liuxiao@cnpack.org $
* �޸ļ�¼��2006.12.30 V1.0
*               ������Ԫ
================================================================================
|</PRE>}

interface

{$I CnWizards.inc}

uses
  Windows, SysUtils, Classes, IniFiles, uPSComponent, uPSRuntime, uPSCompiler;

type

  TPSImport_IniFiles = class(TPSPlugin)
  public
    procedure CompileImport1(CompExec: TPSScript); override;
    procedure ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter); override;
  end;

  { compile-time registration functions }
procedure SIRegister_TMemIniFile(CL: TPSPascalCompiler);
procedure SIRegister_TIniFile(CL: TPSPascalCompiler);
procedure SIRegister_TCustomIniFile(CL: TPSPascalCompiler);
procedure SIRegister_IniFiles(CL: TPSPascalCompiler);

{ run-time registration functions }
procedure RIRegister_TMemIniFile(CL: TPSRuntimeClassImporter);
procedure RIRegister_TIniFile(CL: TPSRuntimeClassImporter);
procedure RIRegister_TCustomIniFile(CL: TPSRuntimeClassImporter);
procedure RIRegister_IniFiles(CL: TPSRuntimeClassImporter);

implementation

(* === compile-time registration functions === *)

procedure SIRegister_TMemIniFile(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TCustomIniFile', 'TMemIniFile') do
  with CL.AddClass(CL.FindClass('TCustomIniFile'), TMemIniFile) do
  begin
    RegisterMethod('Constructor Create( const FileName : string)');
    RegisterMethod('Procedure Clear');
    RegisterMethod('Procedure GetStrings( List : TStrings)');
    RegisterMethod('Procedure Rename( const FileName : string; Reload : Boolean)');
    RegisterMethod('Procedure SetStrings( List : TStrings)');
  end;
end;

procedure SIRegister_TIniFile(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TCustomIniFile', 'TIniFile') do
  with CL.AddClass(CL.FindClass('TCustomIniFile'), TIniFile) do
  begin
  end;
end;

procedure SIRegister_TCustomIniFile(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TObject', 'TCustomIniFile') do
  with CL.AddClass(CL.FindClass('TObject'), TCustomIniFile) do
  begin
    RegisterMethod('Constructor Create( const FileName : string)');
    RegisterMethod('Function SectionExists( const Section : string) : Boolean');
    RegisterMethod('Function ReadString( const Section, Ident, Default : string) : string');
    RegisterMethod('Procedure WriteString( const Section, Ident, Value : String)');
    RegisterMethod('Function ReadInteger( const Section, Ident : string; Default : Longint) : Longint');
    RegisterMethod('Procedure WriteInteger( const Section, Ident : string; Value : Longint)');
    RegisterMethod('Function ReadBool( const Section, Ident : string; Default : Boolean) : Boolean');
    RegisterMethod('Procedure WriteBool( const Section, Ident : string; Value : Boolean)');
    RegisterMethod('Function ReadDate( const Section, Name : string; Default : TDateTime) : TDateTime');
    RegisterMethod('Function ReadDateTime( const Section, Name : string; Default : TDateTime) : TDateTime');
    RegisterMethod('Function ReadFloat( const Section, Name : string; Default : Double) : Double');
    RegisterMethod('Function ReadTime( const Section, Name : string; Default : TDateTime) : TDateTime');
    RegisterMethod('Procedure WriteDate( const Section, Name : string; Value : TDateTime)');
    RegisterMethod('Procedure WriteDateTime( const Section, Name : string; Value : TDateTime)');
    RegisterMethod('Procedure WriteFloat( const Section, Name : string; Value : Double)');
    RegisterMethod('Procedure WriteTime( const Section, Name : string; Value : TDateTime)');
    RegisterMethod('Procedure ReadSection( const Section : string; Strings : TStrings)');
    RegisterMethod('Procedure ReadSections( Strings : TStrings)');
    RegisterMethod('Procedure ReadSectionValues( const Section : string; Strings : TStrings)');
    RegisterMethod('Procedure EraseSection( const Section : string)');
    RegisterMethod('Procedure DeleteKey( const Section, Ident : String)');
    RegisterMethod('Procedure UpdateFile');
    RegisterMethod('Function ValueExists( const Section, Ident : string) : Boolean');
    RegisterProperty('FileName', 'string', iptr);
  end;
end;

procedure SIRegister_IniFiles(CL: TPSPascalCompiler);
begin
  SIRegister_TCustomIniFile(CL);
  SIRegister_TIniFile(CL);
  SIRegister_TMemIniFile(CL);
end;

(* === run-time registration functions === *)

procedure TCustomIniFileFileName_R(Self: TCustomIniFile; var T: string);
begin
  T := Self.FileName;
end;

procedure RIRegister_TMemIniFile(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TMemIniFile) do
  begin
    RegisterConstructor(@TMemIniFile.Create, 'Create');
    RegisterMethod(@TMemIniFile.Clear, 'Clear');
    RegisterMethod(@TMemIniFile.GetStrings, 'GetStrings');
    RegisterMethod(@TMemIniFile.Rename, 'Rename');
    RegisterMethod(@TMemIniFile.SetStrings, 'SetStrings');
  end;
end;

procedure RIRegister_TIniFile(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TIniFile) do
  begin
  end;
end;

procedure RIRegister_TCustomIniFile(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TCustomIniFile) do
  begin
    RegisterConstructor(@TCustomIniFile.Create, 'Create');
    RegisterMethod(@TCustomIniFile.SectionExists, 'SectionExists');
    RegisterVirtualAbstractMethod(TIniFile, @TIniFile.ReadString, 'ReadString');
    RegisterVirtualAbstractMethod(TIniFile, @TIniFile.WriteString, 'WriteString');
    RegisterVirtualMethod(@TCustomIniFile.ReadInteger, 'ReadInteger');
    RegisterVirtualMethod(@TCustomIniFile.WriteInteger, 'WriteInteger');
    RegisterVirtualMethod(@TCustomIniFile.ReadBool, 'ReadBool');
    RegisterVirtualMethod(@TCustomIniFile.WriteBool, 'WriteBool');
    RegisterVirtualMethod(@TCustomIniFile.ReadDate, 'ReadDate');
    RegisterVirtualMethod(@TCustomIniFile.ReadDateTime, 'ReadDateTime');
    RegisterVirtualMethod(@TCustomIniFile.ReadFloat, 'ReadFloat');
    RegisterVirtualMethod(@TCustomIniFile.ReadTime, 'ReadTime');
    RegisterVirtualMethod(@TCustomIniFile.WriteDate, 'WriteDate');
    RegisterVirtualMethod(@TCustomIniFile.WriteDateTime, 'WriteDateTime');
    RegisterVirtualMethod(@TCustomIniFile.WriteFloat, 'WriteFloat');
    RegisterVirtualMethod(@TCustomIniFile.WriteTime, 'WriteTime');
    RegisterVirtualAbstractMethod(TIniFile, @TIniFile.ReadSection, 'ReadSection');
    RegisterVirtualAbstractMethod(TIniFile, @TIniFile.ReadSections, 'ReadSections');
    RegisterVirtualAbstractMethod(TIniFile, @TIniFile.ReadSectionValues, 'ReadSectionValues');
    RegisterVirtualAbstractMethod(TIniFile, @TIniFile.EraseSection, 'EraseSection');
    RegisterVirtualAbstractMethod(TIniFile, @TIniFile.DeleteKey, 'DeleteKey');
    RegisterVirtualAbstractMethod(TIniFile, @TIniFile.UpdateFile, 'UpdateFile');
    RegisterMethod(@TCustomIniFile.ValueExists, 'ValueExists');
    RegisterPropertyHelper(@TCustomIniFileFileName_R, nil, 'FileName');
  end;
end;

procedure RIRegister_IniFiles(CL: TPSRuntimeClassImporter);
begin
  RIRegister_TCustomIniFile(CL);
  RIRegister_TIniFile(CL);
  RIRegister_TMemIniFile(CL);
end;

{ TPSImport_IniFiles }

procedure TPSImport_IniFiles.CompileImport1(CompExec: TPSScript);
begin
  SIRegister_IniFiles(CompExec.Comp);
end;

procedure TPSImport_IniFiles.ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter);
begin
  RIRegister_IniFiles(ri);
end;

end.



