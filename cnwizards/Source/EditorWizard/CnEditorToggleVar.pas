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

unit CnEditorToggleVar;
{* |<PRE>
================================================================================
* ������ƣ�CnPack IDE ר�Ұ�
* ��Ԫ���ƣ��ֲ�������ת����
* ��Ԫ���ߣ���Х (liuxiao@cnpack.org)
* ��    ע��
* ����ƽ̨��PWinXP SP2 + Delphi 5.01
* ���ݲ��ԣ�PWin9X/2000/XP + Delphi 5/6/7 + C++Builder 5/6
* �� �� �����ô����е��ַ��������ϱ��ػ�����ʽ
* ��Ԫ��ʶ��$Id: CnEditorToggleVar.pas 763 2011-02-07 14:18:23Z liuxiao@cnpack.org $
* �޸ļ�¼��2005.08.23 V1.0
*               ������Ԫ��ʵ�ֹ���
================================================================================
|</PRE>}

interface

{$I CnWizards.inc}

{$IFDEF CNWIZARDS_CNEDITORWIZARD}

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, IniFiles, ToolsAPI, Menus,
  CnWizUtils, CnConsts, CnCommon, CnEditorWizard,
  CnWizConsts, CnEditorCodeTool, CnIni, mPasLex;

type

//==============================================================================
// �ֲ�������ת����
//==============================================================================

{ TCnEditorToggleVar }

  TCnEditorToggleVar = class(TCnBaseEditorTool)
  private
    FIsVar: Boolean;
    FParser: TmwPasLex;
    FAddVar: Boolean;
    FAddNewLine: Boolean;
    FEscBack: Boolean;
    FDelBlankVar: Boolean;

    FLineAdded: Boolean;
    FVarAdded: Boolean;
    FColumn: Integer;
    procedure CursorReturnBack;
  protected
    procedure EditorKeyDown(Key, ScanCode: Word; Shift: TShiftState; var Handled: Boolean);
  public
    constructor Create(AOwner: TCnEditorWizard); override;
    destructor Destroy; override;
    function GetCaption: string; override;
    function GetHint: string; override;
    procedure GetEditorInfo(var Name, Author, Email: string); override;
    function GetState: TWizardState; override;
    function GetDefShortCut: TShortCut; override;
    procedure Execute; override;
  published
    property AddVar: Boolean read FAddVar write FAddVar default True;
    property AddNewLine: Boolean read FAddNewLine write FAddNewLine default True;
    property EscBack: Boolean read FEscBack write FEscBack default True;
    property DelBlankVar: Boolean read FDelBlankVar write FDelBlankVar default True;
  end;

{$ENDIF CNWIZARDS_CNEDITORWIZARD}

implementation

{$IFDEF CNWIZARDS_CNEDITORWIZARD}

uses
  CnEditControlWrapper;

const
  CnToggleVarBookmarkID = 19;

  csAddVar = 'AddVar';
  csAddNewLine = 'AddNewLine';
  csEscBack = 'EscBack';
  csDelBlankVar = 'DelBlankVar';

type
  TCnProcedure = class(TObject)
  private
    FHasVar: Boolean;
    FLineNo: Integer;
    FVarStart: Integer;
    FVarEnd: Integer;
    FVarDeclareEnd: Integer;
  public
    property LineNo: Integer read FLineNo write FLineNo;
    property HasVar: Boolean read FHasVar write FHasVar;
    property VarStart: Integer read FVarStart write FVarStart;
    property VarEnd: Integer read FVarEnd write FVarEnd;
    property VarDeclareEnd: Integer read FVarDeclareEnd write FVarDeclareEnd;
  end;

{ TCnEditorToggleVar }

function TCnEditorToggleVar.GetCaption: string;
begin
  Result := SCnEditorToggleVarMenuCaption;
end;

function TCnEditorToggleVar.GetHint: string;
begin
  Result := SCnEditorToggleVarMenuHint;
end;

procedure TCnEditorToggleVar.GetEditorInfo(var Name, Author, Email: string);
begin
  Name := SCnEditorToggleVarName;
  Author := SCnPack_LiuXiao;
  Email := SCnPack_LiuXiaoEmail;
end;

constructor TCnEditorToggleVar.Create(AOwner: TCnEditorWizard);
begin
  inherited;
  EditControlWrapper.AddKeyDownNotifier(EditorKeyDown);
  FAddVar := True;
  FAddNewLine := True;
  FEscBack := True;
  FDelBlankVar := True;
end;

destructor TCnEditorToggleVar.Destroy;
begin
  EditControlWrapper.RemoveKeyDownNotifier(EditorKeyDown);
  FParser.Free;
  inherited;
end;

procedure TCnEditorToggleVar.Execute;
var
  View: IOTAEditView;
  MemStream: TMemoryStream;
  CurLine: Integer;
  InParenthesis, IdentifierNeeded: Boolean;
  AProcInfo: TCnProcedure;
  CanExit: Boolean;
  LineText: string;
  LineNo, CharIndex: Integer;
  I, ProcLineOffSet, PrevLineOffSet: Integer;

  procedure SkipProcedureDeclaration;
  begin
    while not (FParser.TokenId in [tkNull]) do
    begin
      case FParser.TokenID of
        tkIdentifier, tkRegister:
          IdentifierNeeded := False;
        tkRoundOpen:
          begin
            if IdentifierNeeded then
              Break;
            InParenthesis := True;
          end;
        tkRoundClose:
          InParenthesis := False;
      end;

      if (not InParenthesis) and (FParser.TokenID in [tkSemiColon, tkVar,
        tkBegin, tkType, tkConst]) then // �����������޷ֺţ�������Ҫ��������
        Break;
      FParser.Next;
    end;
  end;

  procedure SearchCurrentProc;
  var
    ProcLine, ProcStart, ProcEnd, ProcVarStart, ProcVarEnd, ProcVarDeclareEnd: Integer;
    ProcHasVar, ProcHasBody, HasSubProc, VarEnded: Boolean;
    NestingLevel: Integer;
  begin
    NestingLevel := 0;
    ProcHasVar := False;
    ProcHasBody := False;
    HasSubProc := False;
    VarEnded := False;

    ProcStart := FParser.LineNumber + 1;
    ProcLine := FParser.LineNumber + 1;

    SkipProcedureDeclaration;
    ProcVarStart := FParser.LineNumber + 1;
    ProcVarEnd := FParser.LineNumber + 1;
    ProcVarDeclareEnd := FParser.LineNumber + 1;
    while (FParser.TokenID <> tkNull) and not CanExit do
    begin
      // Procedure declaration �������
      case FParser.TokenID of
        tkVar:
          begin
            ProcHasVar := True;
            ProcVarStart := FParser.LineNumber + 1;
          end;
        tkBegin, tkAsm:
          begin
            if not HasSubProc and (NestingLevel = 0) then
              if not VarEnded then
                ProcVarDeclareEnd := FParser.LineNumber;

            ProcHasBody := True;
            if NestingLevel = 0 then
            begin
              ProcStart := FParser.LineNumber + 1;
              ProcVarEnd := FParser.LineNumber;
            end;
            Inc(NestingLevel);
          end;
        tkConst, tkLabel:
          begin
            if not HasSubProc and ProcHasVar and (NestingLevel = 0) then
            begin
              ProcVarDeclareEnd := FParser.LineNumber;
              VarEnded := True;
            end;
          end;
        tkTry, tkRecord, tkCase, tkClass, tkInterface:
          begin
            Inc(NestingLevel);
          end;
        tkEnd, tkNull:
          begin
            Dec(NestingLevel);
            if NestingLevel <= 0 then
            begin
               if ProcHasBody then // �ǹ����ڲ������һ�� End
               begin
                 ProcEnd := FParser.LineNumber + 1;
                 if (ProcStart <= CurLine) and (ProcEnd >= CurLine) then
                 begin
                   // ��ǰ Procedure
                   AProcInfo := TCnProcedure.Create;
                   AProcInfo.HasVar := ProcHasVar;
                   AProcInfo.LineNo := ProcLine;
                   AProcInfo.VarStart := ProcVarStart;
                   AProcInfo.VarEnd := ProcVarEnd;
                   AProcInfo.VarDeclareEnd := ProcVarDeclareEnd;
                   CanExit := True;
                 end;
                 Exit; // ���������е����һ�� End ʱ������ Search
               end
               else // �� var �������һ�� End��
               begin
                 // ɶ������������
               end;  
            end;
          end;
        tkFunction, tkProcedure, tkConstructor, tkDestructor:
          begin
            // �����µ�Ƕ�׹���
            if not HasSubProc then
              ProcVarDeclareEnd := FParser.LineNumber;
            HasSubProc := True;

            // if NestingLevel = 0 then // Ҫ֧����������������Ҫ������� 0
            SearchCurrentProc;
          end;
      end;
      FParser.Next;
    end;
  end;

begin
  View := CnOtaGetTopMostEditView;
  if View = nil then
    Exit;

  if FIsVar then // �Ѿ��л����� var ���л���ȥ
  begin
    CursorReturnBack;
  end
  else
  begin
    FVarAdded := False;
    FLineAdded := False;
    if FParser = nil then
      FParser := TmwPasLex.Create;

    AProcInfo := nil;
    MemStream := TMemoryStream.Create;
    try
      CnOtaSaveCurrentEditorToStream(MemStream, False);
      FParser.Origin := MemStream.Memory;

      // ���ҵ�ǰ���ڵ� Proc �ľֲ��������򲢶�λ
      CurLine := CnOtaGetCurrCharPos.Line;
      while not (FParser.TokenId in [tkNull, tkImplementation, tkProgram, tkLibrary]) do
        FParser.Next;

      if (FParser.TokenID = tkNull) or (FParser.LineNumber + 1 > CurLine) then
        Exit;
      // Not in Implementation, Exit;

      IdentifierNeeded := False;
      InParenthesis := False;

      CanExit := False;
      while (FParser.TokenID <> tkNull) and not CanExit do
      begin
        if FParser.TokenID in [tkClass, tkInterface] then // If class/interface definition in Implementation then jump to end;
        begin
          if FParser.TokenID = tkClass then
          begin
            FParser.NextNoJunk;
            if not (FParser.TokenID in [tkFunction, tkProcedure]) then
            begin
              // NOT class procedure/function. Jump to end;
              while not (FParser.TokenId in [tkEnd, tkNull]) do
                FParser.Next;
            end;
          end
          else
          begin
            // Jump to end;
            while not (FParser.TokenId in [tkEnd, tkNull]) do
              FParser.Next;
          end;
        end;

        if FParser.TokenID in [tkFunction, tkProcedure, tkConstructor, tkDestructor] then
          SearchCurrentProc;
        FParser.Next;
      end;

      if AProcInfo = nil then
        Exit;

      ProcLineOffSet := 0;
      LineText := CnOtaGetLineText(AProcInfo.LineNo);
      for I := 1 to Length(LineText) - 1 do
      begin
        if not CharInSet(LineText[I], [' ', #9]) then
        begin
          ProcLineOffSet := I - 1;
          Break;
        end;
      end;

      PrevLineOffSet := 0;
      if AProcInfo.HasVar then
      begin
        if AProcInfo.VarDeclareEnd = AProcInfo.VarStart then // �����һ��
          LineNo := AProcInfo.VarDeclareEnd
        else LineNo := AProcInfo.VarDeclareEnd -1;

        LineText := CnOtaGetLineText(LineNo);
        for I := 1 to Length(LineText) - 1 do
        begin
          if not CharInSet(LineText[I], [' ', #9]) then
          begin
            PrevLineOffSet := I - 1;
            Break;
          end;
        end;
      end;

      // ����ҵ��� var ���ȵ�ǰ��껹���棬˵��������
      if AProcInfo.VarDeclareEnd > View.Buffer.EditPosition.Row then
        Exit;

      View.BookmarkRecord(CnToggleVarBookmarkID);
      FColumn := View.Buffer.EditPosition.Column;
      FIsVar := True;

      if AProcInfo.HasVar then
      begin
        View.Buffer.EditPosition.GotoLine(AProcInfo.VarDeclareEnd);
        View.Buffer.EditPosition.MoveEOL;
        if CnOtaGetCurrLineText(LineText, LineNo, CharIndex, View) then
        begin
          if FAddNewLine and (Trim(LineText) <> '') then // ��������
          begin
            View.Buffer.EditPosition.InsertText(#$D#$A);
            if View.Buffer.EditPosition.Column = 1 then
              View.Buffer.EditPosition.MoveRelative(0, PrevLineOffSet);
            FLineAdded := True;
          end
          else // ���п���
          if AProcInfo.VarDeclareEnd - AProcInfo.VarStart = 1 then // ������ var������
          begin
            View.Buffer.EditPosition.MoveReal(View.Buffer.EditPosition.Row, 1);
            View.Buffer.EditPosition.MoveRelative(0, PrevLineOffSet + CnOtaGetBlockIndent);
          end
          else // ���У��������������������ö�������
          begin
            View.Buffer.EditPosition.MoveRelative(0, PrevLineOffSet);
          end;
        end;
      end
      else  // No var
      begin
        if FAddVar then
        begin
          View.Buffer.EditPosition.GotoLine(AProcInfo.VarDeclareEnd);
          View.Buffer.EditPosition.MoveEOL;
          View.Buffer.EditPosition.InsertText(#$D#$A);
          FLineAdded := True;
          View.Buffer.EditPosition.MoveBOL;
          View.Buffer.EditPosition.MoveRelative(0, ProcLineOffSet);
          View.Buffer.EditPosition.InsertText('var'#$D#$A);
          View.Buffer.EditPosition.MoveRelative(0, CnOtaGetBlockIndent);
          // �˴�����Ҫ�� LineOffSet ��Ϊ�Ѿ�������
          FVarAdded := True;
        end;
      end;

      View.MoveViewToCursor;
      View.Paint;
    finally
      MemStream.Free;
      AProcInfo.Free;
    end;
  end;
end;

function TCnEditorToggleVar.GetState: TWizardState;
begin
  Result := inherited GetState;
  if (wsEnabled in Result) and not CurrentIsSource then
    Result := [];
end;

function TCnEditorToggleVar.GetDefShortCut: TShortCut;
begin
  Result := ShortCut(Word('V'), [ssCtrl, ssShift]);
end;

procedure TCnEditorToggleVar.EditorKeyDown(Key, ScanCode: Word; Shift: TShiftState;
  var Handled: Boolean);
begin
  if FEscBack and FIsVar and (Key = VK_ESCAPE) then
  begin
    CursorReturnBack;
  end;
end;

procedure TCnEditorToggleVar.CursorReturnBack;
var
  View: IOTAEditView;
  Text: string;
  LineNo, CharIndex: Integer;
begin
  View := CnOtaGetTopMostEditView;
  if View = nil then
    Exit;

  if not FVarAdded and FDelBlankVar then
  begin
    CnOtaGetCurrLineText(Text, LineNo, CharIndex);
    if FLineAdded and (Trim(Text) = '') then // ����
    begin
      // �����˸�ɾ����ǰ��
      View.Buffer.EditPosition.MoveBOL;
      View.Buffer.EditPosition.BackspaceDelete(1);
    end;
  end;

  View.BookmarkGoto(CnToggleVarBookmarkID);
  if View.Buffer.EditPosition.Column = 1 then // ������ص�ԭ��
    View.Buffer.EditPosition.MoveRelative(0, FColumn - 1);

  View.MoveViewToCursor;
  View.Paint;
  FIsVar := False;
  FVarAdded := False;
  FLineAdded := False;
end;

initialization
  RegisterCnEditor(TCnEditorToggleVar);

{$ENDIF CNWIZARDS_CNEDITORWIZARD}  
end.
