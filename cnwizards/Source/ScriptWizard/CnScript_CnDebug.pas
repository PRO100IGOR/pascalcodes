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

unit CnScript_CnDebug;
{ |<PRE>
================================================================================
* ������ƣ�CnPack IDE ר�Ұ�
* ��Ԫ���ƣ��ű���չ CnWizIdeUtils ע����
* ��Ԫ���ߣ��ܾ��� (zjy@cnpack.org)
* ��    ע���õ�Ԫ�� UnitParser v0.7 �Զ����ɵ��ļ��޸Ķ���
* ����ƽ̨��PWinXP SP2 + Delphi 5.01
* ���ݲ��ԣ�PWin9X/2000/XP + Delphi 5/6/7
* �� �� �����ô����е��ַ���֧�ֱ��ػ�����ʽ
* ��Ԫ��ʶ��$Id: CnScript_CnDebug.pas 763 2011-02-07 14:18:23Z liuxiao@cnpack.org $
* �޸ļ�¼��2006.12.31 V1.0
*               ������Ԫ
================================================================================
|</PRE>}

interface

{$I CnWizards.inc}

uses
  Windows, SysUtils, Classes, CnDebug, uPSComponent, uPSRuntime, uPSCompiler;

type

  TPSImport_CnDebug = class(TPSPlugin)
  public
    procedure CompileImport1(CompExec: TPSScript); override;
    procedure ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter); override;
  end;

{ compile-time registration functions }
procedure SIRegister_TCnMapFileChannel(CL: TPSPascalCompiler);
procedure SIRegister_TCnDebugChannel(CL: TPSPascalCompiler);
procedure SIRegister_TCnDebugger(CL: TPSPascalCompiler);
procedure SIRegister_TCnDebugFilter(CL: TPSPascalCompiler);
procedure SIRegister_CnDebug(CL: TPSPascalCompiler);

{ run-time registration functions }
procedure RIRegister_CnDebug_Routines(S: TPSExec);
procedure RIRegister_TCnMapFileChannel(CL: TPSRuntimeClassImporter);
procedure RIRegister_TCnDebugChannel(CL: TPSRuntimeClassImporter);
procedure RIRegister_TCnDebugger(CL: TPSRuntimeClassImporter);
procedure RIRegister_TCnDebugFilter(CL: TPSRuntimeClassImporter);
procedure RIRegister_CnDebug(CL: TPSRuntimeClassImporter);

implementation

(* === compile-time registration functions === *)

procedure SIRegister_TCnMapFileChannel(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TCnDebugChannel', 'TCnMapFileChannel') do
  with CL.AddClass(CL.FindClass('TCnDebugChannel'), TCnMapFileChannel) do
  begin
  end;
end;

procedure SIRegister_TCnDebugChannel(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TObject', 'TCnDebugChannel') do
  with CL.AddClass(CL.FindClass('TObject'), TCnDebugChannel) do
  begin
    RegisterMethod('Constructor Create( IsAutoFlush : Boolean)');
    RegisterMethod('Procedure StartDebugViewer');
    RegisterMethod('Function CheckFilterChanged : Boolean');
    RegisterMethod('Procedure RefreshFilter( Filter : TCnDebugFilter)');
    RegisterMethod('Procedure SendContent( var MsgDesc, Size : Integer)');
    RegisterProperty('Active', 'Boolean', iptrw);
    RegisterProperty('AutoFlush', 'Boolean', iptrw);
  end;
end;

procedure SIRegister_TCnDebugger(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TObject', 'TCnDebugger') do
  with CL.AddClass(CL.FindClass('TObject'), TCnDebugger) do
  begin
    RegisterMethod('Constructor Create');
    RegisterMethod('Procedure StartDebugViewer');
    RegisterMethod('Procedure StartTimeMark( const ATag : Integer; const AMsg : string);');
    RegisterMethod('Procedure StopTimeMark( const ATag : Integer; const AMsg : string);');
    RegisterMethod('Procedure LogMsg( const AMsg : string)');
    RegisterMethod('Procedure LogMsgWithTag( const AMsg : string; const ATag : string)');
    RegisterMethod('Procedure LogMsgWithLevel( const AMsg : string; ALevel : Integer)');
    RegisterMethod('Procedure LogMsgWithType( const AMsg : string; AType : TCnMsgType)');
    RegisterMethod('Procedure LogMsgWithTagLevel( const AMsg : string; const ATag : string; ALevel : Integer)');
    RegisterMethod('Procedure LogMsgWithLevelType( const AMsg : string; ALevel : Integer; AType : TCnMsgType)');
    RegisterMethod('Procedure LogMsgWithTypeTag( const AMsg : string; AType : TCnMsgType; const ATag : string)');
    RegisterMethod('Procedure LogFmt( const AFormat : string; Args : array of const)');
    RegisterMethod('Procedure LogFmtWithTag( const AFormat : string; Args : array of const; const ATag : string)');
    RegisterMethod('Procedure LogFmtWithLevel( const AFormat : string; Args : array of const; ALevel : Integer)');
    RegisterMethod('Procedure LogFmtWithType( const AFormat : string; Args : array of const; AType : TCnMsgType)');
    RegisterMethod('Procedure LogFull( const AMsg : string; const ATag : string; ALevel : Integer; AType : TCnMsgType; CPUPeriod : Int64)');
    RegisterMethod('Procedure LogSeparator');
    RegisterMethod('Procedure LogEnter( const AProcName : string; const ATag : string)');
    RegisterMethod('Procedure LogLeave( const AProcName : string; const ATag : string)');
    RegisterMethod('Procedure LogMsgWarning( const AMsg : string)');
    RegisterMethod('Procedure LogMsgError( const AMsg : string)');
    RegisterMethod('Procedure LogErrorFmt( const AFormat : string; Args : array of const)');
    RegisterMethod('Procedure LogLastError');
    RegisterMethod('Procedure LogAssigned( Value : Pointer; const AMsg : string)');
    RegisterMethod('Procedure LogBoolean( Value : Boolean; const AMsg : string)');
    RegisterMethod('Procedure LogColor( Color : TColor; const AMsg : string)');
    RegisterMethod('Procedure LogFloat( Value : Extended; const AMsg : string)');
    RegisterMethod('Procedure LogInteger( Value : Integer; const AMsg : string)');
    RegisterMethod('Procedure LogChar( Value : Char; const AMsg : string)');
    RegisterMethod('Procedure LogDateTime( Value : TDateTime; const AMsg : string)');
    RegisterMethod('Procedure LogDateTimeFmt( Value : TDateTime; const AFmt : string; const AMsg : string)');
    RegisterMethod('Procedure LogPointer( Value : Pointer; const AMsg : string)');
    RegisterMethod('Procedure LogPoint( Point : TPoint; const AMsg : string)');
    RegisterMethod('Procedure LogRect( Rect : TRect; const AMsg : string)');
    RegisterMethod('Procedure LogStrings( Strings : TStrings; const AMsg : string)');
    RegisterMethod('Procedure LogMemDump( AMem : Pointer; Size : Integer)');
    RegisterMethod('Procedure LogVirtualKey( AKey : Word)');
    RegisterMethod('Procedure LogVirtualKeyWithTag( AKey : Word; const ATag : string)');
    RegisterMethod('Procedure LogObject( AObject : TObject)');
    RegisterMethod('Procedure LogObjectWithTag( AObject : TObject; const ATag : string)');
    RegisterMethod('Procedure LogCollection( ACollection : TCollection)');
    RegisterMethod('Procedure LogCollectionWithTag( ACollection : TCollection; const ATag : string)');
    RegisterMethod('Procedure LogComponent( AComponent : TComponent)');
    RegisterMethod('Procedure LogComponentWithTag( AComponent : TComponent; const ATag : string)');
    RegisterMethod('Procedure TraceMsg( const AMsg : string)');
    RegisterMethod('Procedure TraceMsgWithTag( const AMsg : string; const ATag : string)');
    RegisterMethod('Procedure TraceMsgWithLevel( const AMsg : string; ALevel : Integer)');
    RegisterMethod('Procedure TraceMsgWithType( const AMsg : string; AType : TCnMsgType)');
    RegisterMethod('Procedure TraceMsgWithTagLevel( const AMsg : string; const ATag : string; ALevel : Integer)');
    RegisterMethod('Procedure TraceMsgWithLevelType( const AMsg : string; ALevel : Integer; AType : TCnMsgType)');
    RegisterMethod('Procedure TraceMsgWithTypeTag( const AMsg : string; AType : TCnMsgType; const ATag : string)');
    RegisterMethod('Procedure TraceFmt( const AFormat : string; Args : array of const)');
    RegisterMethod('Procedure TraceFmtWithTag( const AFormat : string; Args : array of const; const ATag : string)');
    RegisterMethod('Procedure TraceFmtWithLevel( const AFormat : string; Args : array of const; ALevel : Integer)');
    RegisterMethod('Procedure TraceFmtWithType( const AFormat : string; Args : array of const; AType : TCnMsgType)');
    RegisterMethod('Procedure TraceFull( const AMsg : string; const ATag : string; ALevel : Integer; AType : TCnMsgType; CPUPeriod : Int64)');
    RegisterMethod('Procedure TraceSeparator');
    RegisterMethod('Procedure TraceEnter( const AProcName : string; const ATag : string)');
    RegisterMethod('Procedure TraceLeave( const AProcName : string; const ATag : string)');
    RegisterMethod('Procedure TraceMsgWarning( const AMsg : string)');
    RegisterMethod('Procedure TraceMsgError( const AMsg : string)');
    RegisterMethod('Procedure TraceErrorFmt( const AFormat : string; Args : array of const)');
    RegisterMethod('Procedure TraceLastError');
    RegisterMethod('Procedure TraceAssigned( Value : Pointer; const AMsg : string)');
    RegisterMethod('Procedure TraceBoolean( Value : Boolean; const AMsg : string)');
    RegisterMethod('Procedure TraceColor( Color : TColor; const AMsg : string)');
    RegisterMethod('Procedure TraceFloat( Value : Extended; const AMsg : string)');
    RegisterMethod('Procedure TraceInteger( Value : Integer; const AMsg : string)');
    RegisterMethod('Procedure TraceChar( Value : Char; const AMsg : string)');
    RegisterMethod('Procedure TraceDateTime( Value : TDateTime; const AMsg : string)');
    RegisterMethod('Procedure TraceDateTimeFmt( Value : TDateTime; const AFmt : string; const AMsg : string)');
    RegisterMethod('Procedure TracePointer( Value : Pointer; const AMsg : string)');
    RegisterMethod('Procedure TracePoint( Point : TPoint; const AMsg : string)');
    RegisterMethod('Procedure TraceRect( Rect : TRect; const AMsg : string)');
    RegisterMethod('Procedure TraceStrings( Strings : TStrings; const AMsg : string)');
    RegisterMethod('Procedure TraceMemDump( AMem : Pointer; Size : Integer)');
    RegisterMethod('Procedure TraceVirtualKey( AKey : Word)');
    RegisterMethod('Procedure TraceVirtualKeyWithTag( AKey : Word; const ATag : string)');
    RegisterMethod('Procedure TraceObject( AObject : TObject)');
    RegisterMethod('Procedure TraceObjectWithTag( AObject : TObject; const ATag : string)');
    RegisterMethod('Procedure TraceCollection( ACollection : TCollection)');
    RegisterMethod('Procedure TraceCollectionWithTag( ACollection : TCollection; const ATag : string)');
    RegisterMethod('Procedure TraceComponent( AComponent : TComponent)');
    RegisterMethod('Procedure TraceComponentWithTag( AComponent : TComponent; const ATag : string)');
    RegisterMethod('Procedure EvaluateObject( AObject : TObject);');
    RegisterProperty('Channel', 'TCnDebugChannel', iptr);
    RegisterProperty('Filter', 'TCnDebugFilter', iptr);
    RegisterProperty('Active', 'Boolean', iptrw);
    RegisterProperty('ExceptTracking', 'Boolean', iptrw);
    RegisterProperty('AutoStart', 'Boolean', iptrw);
    RegisterProperty('DumpToFile', 'Boolean', iptrw);
    RegisterProperty('DumpFileName', 'string', iptrw);
    RegisterProperty('MessageCount', 'Integer', iptr);
    RegisterProperty('PostedMessageCount', 'Integer', iptr);
    RegisterProperty('DiscardedMessageCount', 'Integer', iptr);
  end;
end;

procedure SIRegister_TCnDebugFilter(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TObject', 'TCnDebugFilter') do
  with CL.AddClass(CL.FindClass('TObject'), TCnDebugFilter) do
  begin
    RegisterProperty('Enabled', 'Boolean', iptrw);
    RegisterProperty('MsgTypes', 'TCnMsgTypes', iptrw);
    RegisterProperty('Level', 'Integer', iptrw);
    RegisterProperty('Tag', 'string', iptrw);
  end;
end;

procedure SIRegister_CnDebug(CL: TPSPascalCompiler);
begin
  CL.AddTypeS('TCnMsgType', '( cmtInformation, cmtWarning, cmtError, cmtSeparat'
    + 'or, cmtEnterProc, cmtLeaveProc, cmtTimeMarkStart, cmtTimeMarkStop, cmtMemo'
    + 'ryDump, cmtException, cmtObject, cmtComponent, cmtCustom, cmtSystem )');
  CL.AddTypeS('TCnMsgTypes', 'set of TCnMsgType');
  CL.AddTypeS('TCnTimeStampType', '( ttNone, ttDateTime, ttTickCount, ttCPUPeri'
    + 'od )');
  SIRegister_TCnDebugFilter(CL);
  CL.AddClass(CL.FindClass('TObject'), TCnDebugChannel);
  SIRegister_TCnDebugger(CL);
  SIRegister_TCnDebugChannel(CL);
  //CL.AddTypeS('TCnDebugChannelClass', 'class of TCnDebugChannel');
  SIRegister_TCnMapFileChannel(CL);
  CL.AddDelphiFunction('Function CnDebugger : TCnDebugger');
end;

(* === run-time registration functions === *)

procedure TCnDebugChannelAutoFlush_W(Self: TCnDebugChannel; const T: Boolean);
begin
  Self.AutoFlush := T;
end;

procedure TCnDebugChannelAutoFlush_R(Self: TCnDebugChannel; var T: Boolean);
begin
  T := Self.AutoFlush;
end;

procedure TCnDebugChannelActive_W(Self: TCnDebugChannel; const T: Boolean);
begin
  Self.Active := T;
end;

procedure TCnDebugChannelActive_R(Self: TCnDebugChannel; var T: Boolean);
begin
  T := Self.Active;
end;

procedure TCnDebuggerDiscardedMessageCount_R(Self: TCnDebugger; var T: Integer);
begin
  T := Self.DiscardedMessageCount;
end;

procedure TCnDebuggerPostedMessageCount_R(Self: TCnDebugger; var T: Integer);
begin
  T := Self.PostedMessageCount;
end;

procedure TCnDebuggerMessageCount_R(Self: TCnDebugger; var T: Integer);
begin
  T := Self.MessageCount;
end;

procedure TCnDebuggerAutoStart_W(Self: TCnDebugger; const T: Boolean);
begin
  Self.AutoStart := T;
end;

procedure TCnDebuggerAutoStart_R(Self: TCnDebugger; var T: Boolean);
begin
  T := Self.AutoStart;
end;

procedure TCnDebuggerDumpToFile_W(Self: TCnDebugger; const T: Boolean);
begin
  Self.DumpToFile := T;
end;

procedure TCnDebuggerDumpToFile_R(Self: TCnDebugger; var T: Boolean);
begin
  T := Self.DumpToFile;
end;

procedure TCnDebuggerDumpFileName_W(Self: TCnDebugger; const T: string);
begin
  Self.DumpFileName := T;
end;

procedure TCnDebuggerDumpFileName_R(Self: TCnDebugger; var T: string);
begin
  T := Self.DumpFileName;
end;

procedure TCnDebuggerExceptTracking_W(Self: TCnDebugger; const T: Boolean);
begin
  Self.ExceptTracking := T;
end;

procedure TCnDebuggerExceptTracking_R(Self: TCnDebugger; var T: Boolean);
begin
  T := Self.ExceptTracking;
end;

procedure TCnDebuggerActive_W(Self: TCnDebugger; const T: Boolean);
begin
  Self.Active := T;
end;

procedure TCnDebuggerActive_R(Self: TCnDebugger; var T: Boolean);
begin
  T := Self.Active;
end;

procedure TCnDebuggerFilter_R(Self: TCnDebugger; var T: TCnDebugFilter);
begin
  T := Self.Filter;
end;

procedure TCnDebuggerChannel_R(Self: TCnDebugger; var T: TCnDebugChannel);
begin
  T := Self.Channel;
end;

procedure TCnDebuggerEvaluateObject_P(Self: TCnDebugger; AObject: TObject);
begin
  Self.EvaluateObject(AObject);
end;

procedure TCnDebuggerStopTimeMark_P(Self: TCnDebugger; const ATag: Integer; const AMsg: string);
begin
  Self.StopTimeMark(ATag, AMsg);
end;

procedure TCnDebuggerStartTimeMark_P(Self: TCnDebugger; const ATag: Integer; const AMsg: string);
begin
  Self.StartTimeMark(ATag, AMsg);
end;

procedure TCnDebugFilterTag_W(Self: TCnDebugFilter; const T: string);
begin
  Self.Tag := T;
end;

procedure TCnDebugFilterTag_R(Self: TCnDebugFilter; var T: string);
begin
  T := Self.Tag;
end;

procedure TCnDebugFilterLevel_W(Self: TCnDebugFilter; const T: Integer);
begin
  Self.Level := T;
end;

procedure TCnDebugFilterLevel_R(Self: TCnDebugFilter; var T: Integer);
begin
  T := Self.Level;
end;

procedure TCnDebugFilterMsgTypes_W(Self: TCnDebugFilter; const T: TCnMsgTypes);
begin
  Self.MsgTypes := T;
end;

procedure TCnDebugFilterMsgTypes_R(Self: TCnDebugFilter; var T: TCnMsgTypes);
begin
  T := Self.MsgTypes;
end;

procedure TCnDebugFilterEnabled_W(Self: TCnDebugFilter; const T: Boolean);
begin
  Self.Enabled := T;
end;

procedure TCnDebugFilterEnabled_R(Self: TCnDebugFilter; var T: Boolean);
begin
  T := Self.Enabled;
end;

procedure RIRegister_CnDebug_Routines(S: TPSExec);
begin
  S.RegisterDelphiFunction(@CnDebugger, 'CnDebugger', cdRegister);
end;

procedure RIRegister_TCnMapFileChannel(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TCnMapFileChannel) do
  begin
  end;
end;

procedure RIRegister_TCnDebugChannel(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TCnDebugChannel) do
  begin
    RegisterVirtualConstructor(@TCnDebugChannel.Create, 'Create');
    RegisterVirtualMethod(@TCnDebugChannel.StartDebugViewer, 'StartDebugViewer');
    RegisterVirtualMethod(@TCnDebugChannel.CheckFilterChanged, 'CheckFilterChanged');
    RegisterVirtualMethod(@TCnDebugChannel.RefreshFilter, 'RefreshFilter');
    RegisterVirtualMethod(@TCnDebugChannel.SendContent, 'SendContent');
    RegisterPropertyHelper(@TCnDebugChannelActive_R, @TCnDebugChannelActive_W, 'Active');
    RegisterPropertyHelper(@TCnDebugChannelAutoFlush_R, @TCnDebugChannelAutoFlush_W, 'AutoFlush');
  end;
end;

procedure RIRegister_TCnDebugger(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TCnDebugger) do
  begin
    RegisterConstructor(@TCnDebugger.Create, 'Create');
    RegisterMethod(@TCnDebugger.StartDebugViewer, 'StartDebugViewer');
    RegisterMethod(@TCnDebuggerStartTimeMark_P, 'StartTimeMark');
    RegisterMethod(@TCnDebuggerStopTimeMark_P, 'StopTimeMark');
    RegisterMethod(@TCnDebugger.LogMsg, 'LogMsg');
    RegisterMethod(@TCnDebugger.LogMsgWithTag, 'LogMsgWithTag');
    RegisterMethod(@TCnDebugger.LogMsgWithLevel, 'LogMsgWithLevel');
    RegisterMethod(@TCnDebugger.LogMsgWithType, 'LogMsgWithType');
    RegisterMethod(@TCnDebugger.LogMsgWithTagLevel, 'LogMsgWithTagLevel');
    RegisterMethod(@TCnDebugger.LogMsgWithLevelType, 'LogMsgWithLevelType');
    RegisterMethod(@TCnDebugger.LogMsgWithTypeTag, 'LogMsgWithTypeTag');
    RegisterMethod(@TCnDebugger.LogFmt, 'LogFmt');
    RegisterMethod(@TCnDebugger.LogFmtWithTag, 'LogFmtWithTag');
    RegisterMethod(@TCnDebugger.LogFmtWithLevel, 'LogFmtWithLevel');
    RegisterMethod(@TCnDebugger.LogFmtWithType, 'LogFmtWithType');
    RegisterMethod(@TCnDebugger.LogFull, 'LogFull');
    RegisterMethod(@TCnDebugger.LogSeparator, 'LogSeparator');
    RegisterMethod(@TCnDebugger.LogEnter, 'LogEnter');
    RegisterMethod(@TCnDebugger.LogLeave, 'LogLeave');
    RegisterMethod(@TCnDebugger.LogMsgWarning, 'LogMsgWarning');
    RegisterMethod(@TCnDebugger.LogMsgError, 'LogMsgError');
    RegisterMethod(@TCnDebugger.LogErrorFmt, 'LogErrorFmt');
    RegisterMethod(@TCnDebugger.LogLastError, 'LogLastError');
    RegisterMethod(@TCnDebugger.LogAssigned, 'LogAssigned');
    RegisterMethod(@TCnDebugger.LogBoolean, 'LogBoolean');
    RegisterMethod(@TCnDebugger.LogColor, 'LogColor');
    RegisterMethod(@TCnDebugger.LogFloat, 'LogFloat');
    RegisterMethod(@TCnDebugger.LogInteger, 'LogInteger');
    RegisterMethod(@TCnDebugger.LogChar, 'LogChar');
    RegisterMethod(@TCnDebugger.LogDateTime, 'LogDateTime');
    RegisterMethod(@TCnDebugger.LogDateTimeFmt, 'LogDateTimeFmt');
    RegisterMethod(@TCnDebugger.LogPointer, 'LogPointer');
    RegisterMethod(@TCnDebugger.LogPoint, 'LogPoint');
    RegisterMethod(@TCnDebugger.LogRect, 'LogRect');
    RegisterMethod(@TCnDebugger.LogStrings, 'LogStrings');
    RegisterMethod(@TCnDebugger.LogMemDump, 'LogMemDump');
    RegisterMethod(@TCnDebugger.LogVirtualKey, 'LogVirtualKey');
    RegisterMethod(@TCnDebugger.LogVirtualKeyWithTag, 'LogVirtualKeyWithTag');
    RegisterMethod(@TCnDebugger.LogObject, 'LogObject');
    RegisterMethod(@TCnDebugger.LogObjectWithTag, 'LogObjectWithTag');
    RegisterMethod(@TCnDebugger.LogCollection, 'LogCollection');
    RegisterMethod(@TCnDebugger.LogCollectionWithTag, 'LogCollectionWithTag');
    RegisterMethod(@TCnDebugger.LogComponent, 'LogComponent');
    RegisterMethod(@TCnDebugger.LogComponentWithTag, 'LogComponentWithTag');
    RegisterMethod(@TCnDebugger.TraceMsg, 'TraceMsg');
    RegisterMethod(@TCnDebugger.TraceMsgWithTag, 'TraceMsgWithTag');
    RegisterMethod(@TCnDebugger.TraceMsgWithLevel, 'TraceMsgWithLevel');
    RegisterMethod(@TCnDebugger.TraceMsgWithType, 'TraceMsgWithType');
    RegisterMethod(@TCnDebugger.TraceMsgWithTagLevel, 'TraceMsgWithTagLevel');
    RegisterMethod(@TCnDebugger.TraceMsgWithLevelType, 'TraceMsgWithLevelType');
    RegisterMethod(@TCnDebugger.TraceMsgWithTypeTag, 'TraceMsgWithTypeTag');
    RegisterMethod(@TCnDebugger.TraceFmt, 'TraceFmt');
    RegisterMethod(@TCnDebugger.TraceFmtWithTag, 'TraceFmtWithTag');
    RegisterMethod(@TCnDebugger.TraceFmtWithLevel, 'TraceFmtWithLevel');
    RegisterMethod(@TCnDebugger.TraceFmtWithType, 'TraceFmtWithType');
    RegisterMethod(@TCnDebugger.TraceFull, 'TraceFull');
    RegisterMethod(@TCnDebugger.TraceSeparator, 'TraceSeparator');
    RegisterMethod(@TCnDebugger.TraceEnter, 'TraceEnter');
    RegisterMethod(@TCnDebugger.TraceLeave, 'TraceLeave');
    RegisterMethod(@TCnDebugger.TraceMsgWarning, 'TraceMsgWarning');
    RegisterMethod(@TCnDebugger.TraceMsgError, 'TraceMsgError');
    RegisterMethod(@TCnDebugger.TraceErrorFmt, 'TraceErrorFmt');
    RegisterMethod(@TCnDebugger.TraceLastError, 'TraceLastError');
    RegisterMethod(@TCnDebugger.TraceAssigned, 'TraceAssigned');
    RegisterMethod(@TCnDebugger.TraceBoolean, 'TraceBoolean');
    RegisterMethod(@TCnDebugger.TraceColor, 'TraceColor');
    RegisterMethod(@TCnDebugger.TraceFloat, 'TraceFloat');
    RegisterMethod(@TCnDebugger.TraceInteger, 'TraceInteger');
    RegisterMethod(@TCnDebugger.TraceChar, 'TraceChar');
    RegisterMethod(@TCnDebugger.TraceDateTime, 'TraceDateTime');
    RegisterMethod(@TCnDebugger.TraceDateTimeFmt, 'TraceDateTimeFmt');
    RegisterMethod(@TCnDebugger.TracePointer, 'TracePointer');
    RegisterMethod(@TCnDebugger.TracePoint, 'TracePoint');
    RegisterMethod(@TCnDebugger.TraceRect, 'TraceRect');
    RegisterMethod(@TCnDebugger.TraceStrings, 'TraceStrings');
    RegisterMethod(@TCnDebugger.TraceMemDump, 'TraceMemDump');
    RegisterMethod(@TCnDebugger.TraceVirtualKey, 'TraceVirtualKey');
    RegisterMethod(@TCnDebugger.TraceVirtualKeyWithTag, 'TraceVirtualKeyWithTag');
    RegisterMethod(@TCnDebugger.TraceObject, 'TraceObject');
    RegisterMethod(@TCnDebugger.TraceObjectWithTag, 'TraceObjectWithTag');
    RegisterMethod(@TCnDebugger.TraceCollection, 'TraceCollection');
    RegisterMethod(@TCnDebugger.TraceCollectionWithTag, 'TraceCollectionWithTag');
    RegisterMethod(@TCnDebugger.TraceComponent, 'TraceComponent');
    RegisterMethod(@TCnDebugger.TraceComponentWithTag, 'TraceComponentWithTag');
    RegisterMethod(@TCnDebuggerEvaluateObject_P, 'EvaluateObject');
    RegisterPropertyHelper(@TCnDebuggerChannel_R, nil, 'Channel');
    RegisterPropertyHelper(@TCnDebuggerFilter_R, nil, 'Filter');
    RegisterPropertyHelper(@TCnDebuggerActive_R, @TCnDebuggerActive_W, 'Active');
    RegisterPropertyHelper(@TCnDebuggerExceptTracking_R, @TCnDebuggerExceptTracking_W, 'ExceptTracking');
    RegisterPropertyHelper(@TCnDebuggerAutoStart_R, @TCnDebuggerAutoStart_W, 'AutoStart');
    RegisterPropertyHelper(@TCnDebuggerDumpToFile_R, @TCnDebuggerDumpToFile_W, 'DumpToFile');
    RegisterPropertyHelper(@TCnDebuggerDumpFileName_R, @TCnDebuggerDumpFileName_W, 'DumpFileName');   
    RegisterPropertyHelper(@TCnDebuggerMessageCount_R, nil, 'MessageCount');
    RegisterPropertyHelper(@TCnDebuggerPostedMessageCount_R, nil, 'PostedMessageCount');
    RegisterPropertyHelper(@TCnDebuggerDiscardedMessageCount_R, nil, 'DiscardedMessageCount');
  end;
end;

procedure RIRegister_TCnDebugFilter(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TCnDebugFilter) do
  begin
    RegisterPropertyHelper(@TCnDebugFilterEnabled_R, @TCnDebugFilterEnabled_W, 'Enabled');
    RegisterPropertyHelper(@TCnDebugFilterMsgTypes_R, @TCnDebugFilterMsgTypes_W, 'MsgTypes');
    RegisterPropertyHelper(@TCnDebugFilterLevel_R, @TCnDebugFilterLevel_W, 'Level');
    RegisterPropertyHelper(@TCnDebugFilterTag_R, @TCnDebugFilterTag_W, 'Tag');
  end;
end;

procedure RIRegister_CnDebug(CL: TPSRuntimeClassImporter);
begin
  RIRegister_TCnDebugFilter(CL);
  CL.Add(TCnDebugChannel);
  RIRegister_TCnDebugger(CL);
  RIRegister_TCnDebugChannel(CL);
  RIRegister_TCnMapFileChannel(CL);
end;

{ TPSImport_CnDebug }

procedure TPSImport_CnDebug.CompileImport1(CompExec: TPSScript);
begin
  SIRegister_CnDebug(CompExec.Comp);
end;

procedure TPSImport_CnDebug.ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter);
begin
  RIRegister_CnDebug(ri);
  RIRegister_CnDebug_Routines(CompExec.Exec); // comment it if no routines
end;

end.




