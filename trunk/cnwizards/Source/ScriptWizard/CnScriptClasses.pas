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

unit CnScriptClasses;
{ |<PRE>
================================================================================
* ������ƣ�CnPack IDE ר�Ұ�
* ��Ԫ���ƣ��ű���չ�൥Ԫ
* ��Ԫ���ߣ��ܾ��� (zjy@cnpack.org)
* ��    ע��
* ����ƽ̨��PWinXP SP2 + Delphi 5.01
* ���ݲ��ԣ�PWin9X/2000/XP + Delphi 5/6/7
* �� �� �����ô����е��ַ���֧�ֱ��ػ�����ʽ
* ��Ԫ��ʶ��$Id: CnScriptClasses.pas 763 2011-02-07 14:18:23Z liuxiao@cnpack.org $
* �޸ļ�¼��2006.09.20 V1.0
*               ������Ԫ
================================================================================
|</PRE>}

interface

{$I CnWizards.inc}

{$IFDEF CNWIZARDS_CNSCRIPTWIZARD}

{$IFDEF SUPPORT_PASCAL_SCRIPT}

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  uPSComponent, uPSCompiler, uPSRuntime;

type

  TCnPSPlugin = class(TPSPlugin)
  public
    procedure CompOnUses1(CompExec: TPSScript); virtual;
    {* ���û�ʵ��ʹ�� uses �õ�Ԫʱ��ע�� }
  end;

  TCnPSScript = class(TPSScript)
  protected
    function DoOnUnknowUses(Sender: TPSPascalCompiler; const Name: AnsiString):
      Boolean; override;
  public
    destructor Destroy; override;
  end;

  TCnExecResult = (erSucc, erCompileError, erExecError);
  
  TCnReadlnEvent = procedure (const Prompt: string; var Text: string) of object;
  TCnWritelnEvent = procedure (const Text: string) of object;

{$IFDEF DELPHI2009_UP}
  TPSOnCompImport = TPSOnCompImportEvent;
  TPSOnExecImport = TPSOnExecImportEvent;
{$ENDIF}

  TCnScriptExec = class
  private
    PSScript: TPSScript;
    FOnCompile: TPSEvent;
    FOnExecute: TPSEvent;
    FOnCompImport: TPSOnCompImport;
    FOnExecImport: TPSOnExecImport;
    FSearchPath: TStrings;
    FScripFile: string;
    FOnReadln: TCnReadlnEvent;
    FOnWriteln: TCnWritelnEvent;
    function PSScriptNeedFile(Sender: TObject; const OrginFileName: AnsiString;
      var FileName, Output: AnsiString): Boolean;
    procedure PSScriptCompImport(Sender: TObject; x: TIFPSPascalcompiler);
    procedure PSScriptExecute(Sender: TPSScript);
    procedure PSScriptExecImport(Sender: TObject; Exec: TIFPSExec;
      x: TIFPSRuntimeClassImporter);
    procedure PSScriptCompile(Sender: TPSScript);
  public
    constructor Create;
    destructor Destroy; override;

    function ExecScript(Script: string; var Msg: string): TCnExecResult;
    function FindFileInSearchPath(const OrgName, FileName: string;
      var OutName: string): Boolean;

    property ScripFile: string read FScripFile write FScripFile;
    property SearchPath: TStrings read FSearchPath;
    property Engine: TPSScript read PSScript;
    property OnCompile: TPSEvent read FOnCompile write FOnCompile;
    property OnExecute: TPSEvent read FOnExecute write FOnExecute;
    property OnCompImport: TPSOnCompImport read FOnCompImport write FOnCompImport;
    property OnExecImport: TPSOnExecImport read FOnExecImport write FOnExecImport;
    property OnReadln: TCnReadlnEvent read FOnReadln write FOnReadln;
    property OnWriteln: TCnWritelnEvent read FOnWriteln write FOnWriteln;
  end;

  TPSPluginClass = class of TPSPlugin;

function RegisterCnScriptPlugin(APluginClass: TPSPluginClass): Integer;
{* ע��һ���ű������ }

{$ENDIF}

{$ENDIF CNWIZARDS_CNSCRIPTWIZARD}

implementation

{$IFDEF CNWIZARDS_CNSCRIPTWIZARD}

{$IFDEF SUPPORT_PASCAL_SCRIPT}

{ TCnScriptExec }

var
  FPluginClasses: TList;

// ע��һ���ű������
function RegisterCnScriptPlugin(APluginClass: TPSPluginClass): Integer;
begin
  if FPluginClasses = nil then
    FPluginClasses := TList.Create;
  Result := FPluginClasses.Add(APluginClass);
end;

{ TCnPSPlugin }

procedure TCnPSPlugin.CompOnUses1(CompExec: TPSScript);
begin

end;

{ TCnPSScript }

function TCnPSScript.DoOnUnknowUses(Sender: TPSPascalCompiler;
  const Name: AnsiString): Boolean;
var
  i: Integer;
  Plugin: TPSPlugin;
  CName: string;
begin
  for i := 0 to Plugins.Count - 1 do
  begin
    Plugin := TPSPluginItem(Plugins.Items[i]).Plugin;
    CName := Plugin.ClassName;
    if Pos('_', CName) > 0 then
      CName := Copy(CName, Pos('_', CName) + 1, MaxInt);
    if SameText(CName, string(Name)) then
    begin
      // ֻ������ʱע��ĵ�Ԫ
      if Plugin is TCnPSPlugin then
        TCnPSPlugin(Plugin).CompOnUses1(Self);
      Result := True;
      Exit;
    end;
  end;
  Result := False;
end;

destructor TCnPSScript.Destroy;
var
  i: Integer;
begin
  // ��ǰ�ͷŲ�����Ա�������ͷ�ʱ����
  for i := Plugins.Count - 1 downto 0 do
    TPSPluginItem(Plugins.Items[i]).Plugin.Free;
  inherited Destroy;
end;

{ TCnScriptExec }

function ScriptFileName(Caller: TPSExec; p: TPSExternalProcRec;
  Global, Stack: TPSStack): Boolean;
begin
  Stack.SetString(-1, TCnScriptExec(p.Ext1).ScripFile);
  Result := True;
end;

function _Readln(Caller: TPSExec; p: TPSExternalProcRec;
  Global, Stack: TPSStack): Boolean;
var
  S: string;
begin
  if Assigned(TCnScriptExec(p.Ext1).OnReadln) then
    TCnScriptExec(p.Ext1).OnReadln(Stack.GetString(-2), S);
  Stack.SetString(-1, S);
  Result := True;
end;

function _Writeln(Caller: TPSExec; p: TPSExternalProcRec;
  Global, Stack: TPSStack): Boolean;
begin
  if Assigned(TCnScriptExec(p.Ext1).OnWriteln) then
    TCnScriptExec(p.Ext1).OnWriteln(Stack.GetString(-1));
  Result := True;
end;

constructor TCnScriptExec.Create;
var
 i: Integer;
begin
  FSearchPath := TStringList.Create;
  PSScript := TCnPSScript.Create(nil);
  PSScript.UsePreProcessor := True;
  PSScript.OnNeedFile := PSScriptNeedFile;
  PSScript.OnCompImport := PSScriptCompImport;
  PSScript.OnExecImport := PSScriptExecImport;
  PSScript.OnCompile := PSScriptCompile;
  PSScript.OnExecute := PSScriptExecute;
  for i := 0 to FPluginClasses.Count - 1 do
    TPSPluginItem(PSScript.Plugins.Add).Plugin := TPSPluginClass(FPluginClasses[i]).Create(PSScript);
end;

destructor TCnScriptExec.Destroy;
begin
  FSearchPath.Free;
  PSScript.Free;
  inherited;
end;

function TCnScriptExec.FindFileInSearchPath(const OrgName, FileName: string;
  var OutName: string): Boolean;

  function LinkPath(const Head, Tail: string): string;
  var
    AHead, ATail: string;
    i: Integer;
  begin
    if Head = '' then
    begin
      Result := Tail;
      Exit;
    end;

    if Tail = '' then
    begin
      Result := Head;
      Exit;
    end;

    AHead := StringReplace(Head, '/', '\', [rfReplaceAll]);
    ATail := StringReplace(Tail, '/', '\', [rfReplaceAll]);
    if Copy(ATail, 1, 2) = '.\' then
      Delete(ATail, 1, 2);
      
    if AHead[Length(AHead)] = '\' then
      Delete(AHead, Length(AHead), MaxInt);
    i := Pos('..\', ATail);
    while i > 0 do
    begin
      AHead := ExtractFileDir(AHead);
      Delete(ATail, 1, 3);
      i := Pos('..\', ATail);
    end;
    
    Result := AHead + '\' + ATail;
  end;
var
  i: Integer;
begin
  Result := True;

  OutName := LinkPath(ExtractFileDir(OrgName), FileName);
  if FileExists(OutName) then
    Exit;

  OutName := LinkPath(ExtractFileDir(ScripFile), FileName);
  if FileExists(OutName) then
    Exit;

  for i := 0 to FSearchPath.Count - 1 do
  begin
    OutName := LinkPath(FSearchPath[i], FileName);
    if FileExists(OutName) then
      Exit;
  end;

  OutName := FileName;
  if FileExists(OutName) then
    Exit;
    
  Result := False;
  OutName := '';
end;

function TCnScriptExec.PSScriptNeedFile(Sender: TObject;
  const OrginFileName: AnsiString; var FileName, Output: AnsiString): Boolean;
var
  FullFile: string;
begin
  if FindFileInSearchPath(string(OrginFileName), string(FileName), FullFile) and
    FileExists(FullFile) then
  begin
    with TStringList.Create do
    try
      LoadFromFile(FullFile);
      Output := AnsiString(Text);
    finally
      Free;
    end;
    Result := True;
  end
  else
    Result := False;
end;

procedure TCnScriptExec.PSScriptCompImport(Sender: TObject;
  x: TIFPSPascalcompiler);
begin
  x.AddFunction('function ScriptFileName: string;');
  x.AddFunction('function Readln(const Msg: string): string;');
  x.AddFunction('procedure Writeln(const Text: string);');
  if Assigned(FOnCompImport) then
    FOnCompImport(Sender, x);
end;

procedure TCnScriptExec.PSScriptExecImport(Sender: TObject; Exec: TIFPSExec;
  x: TIFPSRuntimeClassImporter);
begin
  Exec.RegisterFunctionName('ScriptFileName', ScriptFileName, Self, nil);
  Exec.RegisterFunctionName('Readln', _Readln, Self, nil);
  Exec.RegisterFunctionName('Writeln', _Writeln, Self, nil);
  if Assigned(FOnExecImport) then
    FOnExecImport(Sender, Exec, x);
end;

procedure TCnScriptExec.PSScriptCompile(Sender: TPSScript);
begin
  if Assigned(FOnCompile) then
    FOnCompile(Sender);
end;

procedure TCnScriptExec.PSScriptExecute(Sender: TPSScript);
begin
  if Assigned(FOnExecute) then
    FOnExecute(Sender);
end;

function TCnScriptExec.ExecScript(Script: string; var Msg: string): TCnExecResult;
var
  i: Integer;
begin
  PSScript.Script.Text := Script;
  if PSScript.Compile then
  begin
    if PSScript.Execute then
      Result := erSucc
    else
    begin
      Msg := string(PSScript.ExecErrorToString);
      Result := erExecError;
    end;
  end
  else
  begin
    for i := 0 to PSScript.CompilerMessageCount - 1 do
      Msg := Msg + string(PSScript.CompilerErrorToStr(i)) + #13#10;
    Result := erCompileError;
  end;
end;

initialization

finalization
  if FPluginClasses <> nil then
    FPluginClasses.Free;

{$ENDIF}

{$ENDIF SUPPORT_PASCAL_SCRIPT}
end.
