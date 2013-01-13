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

{******************************************************************************}
{ Unit Note:                                                                   }
{    This file is derived from GExperts 1.2                                    }
{                                                                              }
{ Original author:                                                             }
{    GExperts, Inc  http://www.gexperts.org/                                   }
{    Erik Berry <eberry@gexperts.org> or <eb@techie.com>                       }
{******************************************************************************}

unit CnWizMacroUtils;
{* |<PRE>
================================================================================
* ������ƣ�CnPack IDE ר�Ұ�
* ��Ԫ���ƣ��༭��ר�Ҹ���������Ԫ
* ��Ԫ���ߣ��ܾ��� (zjy@cnpack.org)
* ��    ע���õ�Ԫ��Ҫ��ֲ�� GExperts 1.12 Src
*           ��ԭʼ������ GExperts License �ı���
* ����ƽ̨��PWin2000Pro + Delphi 5.01
* ���ݲ��ԣ�PWin9X/2000/XP + Delphi 5/6/7 + C++Builder 5/6
* �� �� �����ô����е��ַ��������ϱ��ػ�����ʽ
* ��Ԫ��ʶ��$Id: CnWizMacroUtils.pas 763 2011-02-07 14:18:23Z liuxiao@cnpack.org $
* �޸ļ�¼��2003.09.26 V1.1 ����(QSoft)
*               ��������༭��ר���еļ������ͷʱ����Class methods��������BUG 
*           2002.12.04 V1.0
*               ������Ԫ��ʵ�ֹ���
================================================================================
|</PRE>}

interface

uses
  Windows, SysUtils, Classes, ToolsAPI;

{$I CnWizards.inc}

type
  TEditorInsertPos = (ipCurrPos, ipBOL, ipEOL, ipBOF, ipEOF, ipProcHead);

  TCnProcArgument = record
    ArgKind: string;
    ArgName: string;
    ArgType: string;
    ArgDefault: string;
  end;
  TCnProcArguments = array of TCnProcArgument;

const
  csArgKind = '$k';
  csArgName = '$n';
  csArgType = '$t';
  csArgDefault = '$d';
  csRetType = '$t';

function EdtGetProjectDir: string;
function EdtGetProjectName: string;
function EdtGetProjectGroupDir: string;
function EdtGetProjectGroupName: string;
function EdtGetUnitName: string;
function EdtGetProcName: string;
function EdtGetCurrProcName: string;
function EdtGetResult: string;
function EdtGetArguments: string;
function EdtGetArgList(FormatStr: string): string;
function EdtGetRetType(FormatStr: string): string;
function EdtGetUser: string;
function EdtGetCodeLines: string;

function EdtGetProcInfo(var Name: string; var Args: TCnProcArguments;
  var ResultType: string): Boolean;

procedure EdtInsertTextToCurSource(const AContent: string;
  InsertPos: TEditorInsertPos; ASavePos: Boolean; PosInText: Integer = 0);

implementation

uses
{$IFDEF DEBUG}
  CnDebug,
{$ENDIF}
  CnCommon, CnWizUtils, CnWizConsts, CnWizIdeUtils, mPasLex;

function IsParseSource: Boolean;
begin
  Result := CurrentIsDelphiSource;
end;

procedure GetNameArgsResult(var Name, Args, ResultType: string;
  RetEmpty: Boolean = False; IgnoreCompDir: Boolean = False);
var
  Parser: TmwPasLex;
  MemStream: TMemoryStream;
begin
  if RetEmpty then
  begin
    Name := '';
    Args := '';
    ResultType := '';
  end
  else
  begin
    Name := SCnUnknownNameResult;
    Args := SCnNoneResult;
    ResultType := SCnNoneResult;
  end;

  MemStream := TMemoryStream.Create;
  try
    CnOtaSaveCurrentEditorToStream(MemStream, True);
    Parser := TmwPasLex.Create;
    try
      Parser.Origin := MemStream.Memory;
      while not (Parser.TokenID in [tkNull, tkProcedure, tkFunction, tkConstructor, tkDestructor]) do
        Parser.NextNoJunk;
      if Parser.TokenID in [tkProcedure, tkFunction, tkConstructor, tkDestructor] then
      begin
        Parser.NextNoJunk; // Get the proc/class identifier
        if Parser.TokenID in [tkIdentifier, tkRegister] then
          Name := string(Parser.Token);
        Parser.NextNoJunk; // Skip to the open paren or the '.'
        if Parser.TokenID = tkPoint then
        begin
          Parser.NextNoJunk; // Get the proc identifier
          Name := Name + '.' + string(Parser.Token);
          Parser.NextNoJunk; // skip past the procedure identifier
        end;

        if Parser.TokenID = tkRoundOpen then
        begin
          Parser.NextNoJunk;
          Args := '';
          while not (Parser.TokenID in [tkNull, tkRoundClose]) do
          begin
            if Parser.TokenID in [tkCRLF, tkCRLFCo, tkSlashesComment,
              tkBorComment, tkAnsiComment, tkSpace] then
              Args := Args + ' '
            else if IgnoreCompDir and (Parser.TokenID = tkCompDirect) then
              Args := Args + ' '
            else
              Args := Args + string(Parser.Token);
            Parser.Next;
          end;
          Args := CompressWhiteSpace(Args);
          // Skip to the colon or semicolon after the ')'
          Parser.NextNoJunk;
        end;
        if Parser.TokenID in [tkAnsiComment, tkBorComment, tkCRLF, tkCRLFCo, tkSpace] then
          Parser.NextNoJunk;
        // If a colon is found, find the next token
        if Parser.TokenID = tkColon then
        begin
          Parser.NextNoJunk;
          ResultType := string(Parser.Token);
        end;
      end;
    finally
      Parser.Free;
    end;
  finally
    MemStream.Free;
  end;
end;

function EdtGetProjectDir: string;
begin
  Result := ExtractFilePath(CnOtaGetCurrentProjectFileName);
  if Result = '' then
    Result := SCnUnknownNameResult;
end;

function EdtGetProjectName: string;
begin
  Result := ExtractFileName(CnOtaGetCurrentProjectFileName);
  if Result = '' then
    Result := SCnUnknownNameResult
  else
    Result := ChangeFileExt(Result, '');
end;

function EdtGetProjectGroupDir: string;
begin
  Result := ExtractFilePath(CnOtaGetProjectGroupFileName);
  if Result = '' then
    Result := SCnUnknownNameResult;
end;

function EdtGetProjectGroupName: string;
begin
  Result := ExtractFileName(CnOtaGetProjectGroupFileName);
  if Result = '' then
    Result := SCnUnknownNameResult
  else
    Result := ChangeFileExt(Result, '');
end;

function EdtGetUnitName: string;
begin
  Result := ExtractFileName(CnOtaGetCurrentSourceFile);
  if Result = '' then
    Result := SCnUnknownNameResult;
end;

function EdtGetProcName: string;
var
  ProcName, ProcArgs, ProcResult: string;
begin
  if IsParseSource then
  begin
    GetNameArgsResult(ProcName, ProcArgs, ProcResult);
    Result := ProcName;
  end
  else
    Result := SCnUnknownNameResult;
end;

function EdtGetCurrProcName: string;
begin
  Result := CnOtaGetCurrentProcedure;
  if Result = '' then
    Result := SCnUnknownNameResult;
end;

function EdtGetResult: string;
var
  ProcName, ProcArgs, ProcResult: string;
begin
  if IsParseSource then
  begin
    GetNameArgsResult(ProcName, ProcArgs, ProcResult);
    Result := ProcResult;
  end
  else
    Result := SCnUnknownNameResult;
end;

function EdtGetArguments: string;
var
  ProcName, ProcArgs, ProcResult: string;
begin
  if IsParseSource then
  begin
    GetNameArgsResult(ProcName, ProcArgs, ProcResult);
    Result := ProcArgs;
  end
  else
    Result := SCnUnknownNameResult;
end;

function EdtGetArgList(FormatStr: string): string;
var
  Name: string;
  Args: TCnProcArguments;
  RetType: string;
  Text: string;
  i: Integer;
begin
  Result := '';
  if (FormatStr <> '') and EdtGetProcInfo(Name, Args, RetType) then
  begin
    for i := Low(Args) to High(Args) do
    begin
      Text := FormatStr;
      Text := StringReplace(Text, csArgKind, Args[i].ArgKind, [rfReplaceAll]);
      Text := StringReplace(Text, csArgName, Args[i].ArgName, [rfReplaceAll]);
      Text := StringReplace(Text, csArgType, Args[i].ArgType, [rfReplaceAll]);
      Text := StringReplace(Text, csArgDefault, Args[i].ArgDefault, [rfReplaceAll]);
      Result := Result + Text;
    end;
  end;
end;

function EdtGetRetType(FormatStr: string): string;
var
  Name: string;
  Args: TCnProcArguments;
  RetType: string;
begin
  Result := '';
  if (FormatStr <> '') and EdtGetProcInfo(Name, Args, RetType) and
    (RetType <> '') then
  begin
    Result := StringReplace(FormatStr, csRetType, RetType, [rfReplaceAll]);
  end;
end;
  
function EdtGetUser: string;
var
  NameBufferSize: DWORD;
  NameBuffer: array[0..256] of Char;
begin
  NameBufferSize := SizeOf(NameBuffer);
  if Windows.GetUserName(NameBuffer, NameBufferSize) then
    Result := NameBuffer
  else
    Result := SCnUnknownNameResult;
end;

function EdtGetCodeLines: string;
var
  ISourceEditor: IOTASourceEditor;
begin
  ISourceEditor := CnOtaGetCurrentSourceEditor;
  if Assigned(ISourceEditor) then
    Result := IntToStr(ISourceEditor.GetLinesInBuffer)
  else
    Result := SCnUnknownNameResult;
end;

function EdtGetProcInfo(var Name: string; var Args: TCnProcArguments;
  var ResultType: string): Boolean;
var
  ProcArgs: string;
  Lines, Params: TStringList;

  function ParseArgs(DoAdd: Boolean): Integer;
  var
    i, j, Idx: Integer;
    Text, ArgKind, ArgType, ArgDefault: string;
  begin
    Result := 0;
    Lines.Text := StringReplace(ProcArgs, ';', CRLF, [rfReplaceAll]);
    for i := 0 to Lines.Count - 1 do
    begin
      Text := Trim(Lines[i]);
    {$IFDEF DEBUG}
      if DoAdd then
        CnDebugger.LogFmt('Line: %s', [Text]);
    {$ENDIF}

      // ȡ��������
      ArgType := '';
      ArgDefault := '';
      Idx := AnsiPos(':', Text);
      if Idx > 0 then
      begin
        ArgType := Trim(Copy(Text, Idx + 1, MaxInt));
        Text := Trim(Copy(Text, 1, Idx - 1));

        // ����Ĭ��ֵ
        Idx := AnsiPos('=', ArgType);
        if Idx > 0 then
        begin
          ArgDefault := Trim(Copy(ArgType, Idx + 1, MaxInt));
          ArgType := Trim(Copy(ArgType, 1, Idx - 1));
        end;  
      end;

      // ȡ������ʽ
      Idx := 1;
      ArgKind := '';
      while Idx < Length(Text) do
      begin
        if Text[Idx] = ' ' then
        begin
          ArgKind := Trim(Copy(Text, 1, Idx - 1));
          Text := Trim(Copy(Text, Idx + 1, MaxInt));
          Break;
        end
        else if not IsValidIdentChar(Text[Idx]) then
        begin
          Break;
        end;
        Inc(Idx);
      end;
    {$IFDEF DEBUG}
      if DoAdd then
        CnDebugger.LogFmt('Kind: %s, Type: %s, Default: %s, Text: %s',
          [ArgKind, ArgType, ArgDefault, Text]);
    {$ENDIF}

      // ȡ������
      Params.Text := StringReplace(Text, ',', CRLF, [rfReplaceAll]);
      for j := 0 to Params.Count - 1 do
      begin
        if DoAdd then
        begin
          Args[Result].ArgKind := ArgKind;
          Args[Result].ArgName := Trim(Params[j]);
          Args[Result].ArgType := ArgType;
          Args[Result].ArgDefault := ArgDefault;
        end;
        Inc(Result);
      end;
    end;
  end;
begin
{$IFDEF DEBUG}
  CnDebugger.LogEnter('EdtGetProcInfo');
{$ENDIF}
  Name := '';
  Args := nil;
  ResultType := '';
  if IsParseSource then
  begin
    GetNameArgsResult(Name, ProcArgs, ResultType, True, True);
  {$IFDEF DEBUG}
    CnDebugger.LogFmt('Name: %s, Args: %s, Result: %s', [Name, ProcArgs, ResultType]);
  {$ENDIF}
    Lines := nil;
    Params := nil;
    try
      Lines := TStringList.Create;
      Params := TStringList.Create;
      SetLength(Args, ParseArgs(False));
      ParseArgs(True);
    finally
      Lines.Free;
      Params.Free;
    end;
    Result := True;
  end
  else
    Result := False;
{$IFDEF DEBUG}
  CnDebugger.LogLeave('EdtGetProcInfo');
{$ENDIF}
end;

procedure EdtInsertTextToCurSource(const AContent: string;
  InsertPos: TEditorInsertPos; ASavePos: Boolean; PosInText: Integer);
var
  EditView: IOTAEditView;
  SavePos: Integer;
  Position: Integer;
  CharPos: TOTACharPos;
  EditPos: TOTAEditPos;

  procedure MovePosToProcHead;
  label BeginFindProcHead;

  var
    Parser: TmwPasLex;
    MemStream: TMemoryStream;
    ClassPos: Integer;
  begin
    MemStream := TMemoryStream.Create;
    try
      CnOtaSaveCurrentEditorToStream(MemStream, True);
      Parser := TmwPasLex.Create;
      try
        Parser.Origin := MemStream.Memory;

  BeginFindProcHead: // ��ʼ�ҹ���ͷ
        while not (Parser.TokenID in [tkNull, tkClass, tkProcedure, tkFunction,
          tkConstructor, tkDestructor]) do
          Parser.NextNoJunk;

        // ���� class proceduer classfunc ���͵Ĺ��̶���
        if Parser.TokenID = tkClass then
        begin
          ClassPos := Parser.TokenPos; // �ȼ�¼class�����ֵĿ�ʼλ��
          Parser.NextNoJunk;
          if Parser.TokenID in [tkProcedure, tkFunction] then
            CnOtaGotoPosition(CnOtaGetCurrPos + ClassPos)
          else // class �����ֺ�δ����procedure �� function���������ҹ���ͷ
            goto BeginFindProcHead;  
        end
        else if Parser.TokenID in [tkProcedure, tkFunction,
          tkConstructor, tkDestructor] then
          CnOtaGotoPosition(CnOtaGetCurrPos + Parser.TokenPos);
      finally
        Parser.Free;
      end;
    finally
      MemStream.Free;
    end;
  end;
begin
  SavePos := CnOtaGetCurrPos;
  case InsertPos of
    ipBOL:
      begin
        CnOtaMovePosInCurSource(ipLineHead, 0, 0);
        Inc(SavePos, Length(AContent));
      end;
    ipEOL:
      CnOtaMovePosInCurSource(ipLineEnd, 0, 0);
    ipBOF:
      begin
        CnOtaMovePosInCurSource(ipFileHead, 0, 0);
        Inc(SavePos, Length(AContent));
      end;
    ipEOF:
      CnOtaMovePosInCurSource(ipFileEnd, 0, 0);
    ipProcHead:
      MovePosToProcHead;
  end;

  EditView := CnOtaGetTopMostEditView;
  Assert(Assigned(EditView));
  EditPos := EditView.CursorPos;
  EditView.ConvertPos(True, EditPos, CharPos);
  Position := EditView.CharPosToPos(CharPos);
  CnOtaInsertTextIntoEditorAtPos(AContent, Position);
  
  if ASavePos then
    CnOtaGotoPosition(SavePos)
  else
  begin
    if PosInText > 0 then
    begin
      CnOtaGotoPosition(Position + PosInText); // �����1
      EditView.Paint;
    end;
    EditView.MoveViewToCursor;
  end;
  EditView.Paint;
  BringIdeEditorFormToFront;
end;

end.
