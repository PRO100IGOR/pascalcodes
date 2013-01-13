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

unit CnEditorToggleUses;
{* |<PRE>
================================================================================
* ������ƣ�CnPack IDE ר�Ұ�
* ��Ԫ���ƣ�Uses ��ת����
* ��Ԫ���ߣ���Х (liuxiao@cnpack.org)
* ��    ע��
* ����ƽ̨��PWinXP SP2 + Delphi 5.01
* ���ݲ��ԣ�PWin9X/2000/XP + Delphi 5/6/7 + C++Builder 5/6
* �� �� �����ô����е��ַ��������ϱ��ػ�����ʽ
* ��Ԫ��ʶ��$Id: CnEditorToggleUses.pas 763 2011-02-07 14:18:23Z liuxiao@cnpack.org $
* �޸ļ�¼��2007.12.02 V1.0
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

  TCnUsesPosition = (upNone, upInterface, upImplementation);

//==============================================================================
// �ֲ�������ת����
//==============================================================================

{ TCnEditorToggleUses }

  TCnEditorToggleUses = class(TCnBaseEditorTool)
  private
    FUsesPosition: TCnUsesPosition;
    FJumpTime: DWORD;
    FParser: TmwPasLex;

    FUsesAdded: Boolean;
    FColumn: Integer;
    procedure CursorReturnBack;
  protected
    procedure EditorKeyDown(Key, ScanCode: Word; Shift: TShiftState; var Handled: Boolean);
  public
    constructor Create(AOwner: TCnEditorWizard); override;
    destructor Destroy; override;
    procedure LoadSettings(Ini: TCustomIniFile); override;
    procedure SaveSettings(Ini: TCustomIniFile); override;
    function GetCaption: string; override;
    function GetHint: string; override;
    procedure GetEditorInfo(var Name, Author, Email: string); override;
    function GetState: TWizardState; override;
    function GetDefShortCut: TShortCut; override;
    procedure Execute; override;
  end;

{$ENDIF CNWIZARDS_CNEDITORWIZARD}

implementation

{$IFDEF CNWIZARDS_CNEDITORWIZARD}

uses
  CnEditControlWrapper;

const
  CnToggleUsesBookmarkID = 20;
  CnToggleUsesTimeInterval = 2; // Seconds

{ TCnEditorToggleUses }

function TCnEditorToggleUses.GetCaption: string;
begin
  Result := SCnEditorToggleUsesMenuCaption;
end;

function TCnEditorToggleUses.GetHint: string;
begin
  Result := SCnEditorToggleUsesMenuHint;
end;

procedure TCnEditorToggleUses.GetEditorInfo(var Name, Author, Email: string);
begin
  Name := SCnEditorToggleUsesName;
  Author := SCnPack_LiuXiao;
  Email := SCnPack_LiuXiaoEmail;
end;

constructor TCnEditorToggleUses.Create(AOwner: TCnEditorWizard);
begin
  inherited;
  EditControlWrapper.AddKeyDownNotifier(EditorKeyDown);
end;

destructor TCnEditorToggleUses.Destroy;
begin
  EditControlWrapper.RemoveKeyDownNotifier(EditorKeyDown);
  FParser.Free;
  inherited;
end;

procedure TCnEditorToggleUses.Execute;
const
  SCnCInclude = '#include';
  SCnCppComment = '//--';
var
  View: IOTAEditView;
  MemStream: TMemoryStream;
  Use1Line, Use2Line, CurLine, IntfLine, ImplLine: Integer;
  Uses1, Uses2, InImplement, CursorInImplement: Boolean;
  S: string;
  CSources: TStringList;
  I, InsertPos, CommentPos, CommentCount: Integer;

begin
  View := CnOtaGetTopMostEditView;
  if View = nil then
    Exit;

  if (FUsesPosition = upInterface) or ((FUsesPosition = upImplementation) and
    (GetTickCount - FJumpTime > CnToggleUsesTimeInterval * 1000)) then
  begin
    // �Ѿ��л����� Interface �� uses�������� Implementation ���� Uses ����ʱ�ˣ����л���ȥ
    CursorReturnBack;
    FUsesPosition := upNone;
    FJumpTime := 0;
  end
  else
  begin
    if FParser = nil then
      FParser := TmwPasLex.Create;

    S := CnOtaGetCurrentSourceFileName;

    MemStream := TMemoryStream.Create;
    try
      CnOtaSaveCurrentEditorToStream(MemStream, False);
      FParser.Origin := MemStream.Memory;

      CurLine := CnOtaGetCurrCharPos.Line;

      Use1Line := 0;
      Use2Line := 0;
      IntfLine := 0;
      ImplLine := 0;
      Uses1 := False;
      Uses2 := False;
      InImplement := False;
      CursorInImplement := False;

      if IsDprOrPas(S) or IsInc(S) then // ���� Pascal
      begin
        while FParser.TokenID <> tkNull do
        begin
          FParser.Next;
          case FParser.TokenID of
          tkInterface:
            begin
              if IntfLine = 0 then
                IntfLine := FParser.LineNumber + 1;
            end;
          tkImplementation:
            begin
              InImplement := True;
              CursorInImplement := (CurLine >= FParser.LineNumber + 1);
              ImplLine := FParser.LineNumber + 1;
            end;
          tkUses:
            begin
              if InImplement then
                Uses2 := True
              else
                Uses1 := True;

              while not (FParser.TokenID in [tkNull, tkSemiColon]) do
                FParser.Next;

              if FParser.TokenID = tkSemiColon then
              begin
                if InImplement then
                begin
                  Use2Line := FParser.LineNumber + 1;
                end
                else
                begin
                  Use1Line := FParser.LineNumber + 1;
                end;
              end;  
            end;  
          end;
        end;

        // ���� interface Ҳ���� uses1 ������
        if (not CursorInImplement and (FUsesPosition = upNone))
          or ((FUsesPosition = upImplementation) and
          (GetTickCount - FJumpTime <= CnToggleUsesTimeInterval * 1000)) then
        begin
          // ��ʼ״̬������� interface ����ʱ�����߹�������� Implementation ��
          // uses ����������ʱ�������� interface �� uses
          if FUsesPosition = upNone then
          begin
            // ����ǩ��¼λ�ã�ע�⣬�������� interface ʱ���ǡ�
            View.BookmarkRecord(CnToggleUsesBookmarkID);
            FColumn := View.Buffer.EditPosition.Column;
          end;  

          if Uses1 then
          begin
            View.Buffer.EditPosition.GotoLine(Use1Line);
            View.Buffer.EditPosition.MoveEOL;
            View.Buffer.EditPosition.MoveRelative(0, -1);
          end
          else
          begin
            View.Buffer.EditPosition.GotoLine(IntfLine);
            View.Buffer.EditPosition.MoveEOL;
            View.Buffer.EditPosition.InsertText(#$D#$A#$D#$A'uses'#$D#$A'  ;');
            View.Buffer.EditPosition.MoveRelative(0, -1);
            FUsesAdded := False;
          end;  
          FUsesPosition := upInterface;
          FUsesAdded := False;
        end
        else if FUsesPosition = upNone then
        begin
          // ����ǩ��¼λ��
          View.BookmarkRecord(CnToggleUsesBookmarkID);
          FColumn := View.Buffer.EditPosition.Column;

          if Uses2 then
          begin
            View.Buffer.EditPosition.GotoLine(Use2Line);
            View.Buffer.EditPosition.MoveEOL;
            View.Buffer.EditPosition.MoveRelative(0, -1);
          end
          else
          begin
            View.Buffer.EditPosition.GotoLine(ImplLine);
            View.Buffer.EditPosition.MoveEOL;
            View.Buffer.EditPosition.InsertText(#$D#$A#$D#$A'uses'#$D#$A'  ;');
            View.Buffer.EditPosition.MoveRelative(0, -1);
            FUsesAdded := False;
          end;

          FUsesPosition := upImplementation;
        end;
      end
      else if IsCpp(S) or IsC(S) or IsH(S) or IsHpp(S) then // ���� C
      begin
        // TODO: ���� C �� Include ����
        CSources := TStringList.Create;
        try
          CSources.LoadFromStream(MemStream);
          InsertPos := 0;
          CommentCount := 0;
          CommentPos := 0;

          for I := 0 to CSources.Count - 1 do // �����һ�� include
          begin
            if SCnCInclude = Copy(Trim(CSources[I]), 1, Length(SCnCInclude)) then
            begin
              // ��¼���һ�� include ��λ�ã����·����룬���Լ� 2
              InsertPos := I + 2;
            end;

            if SCnCppComment = Copy(Trim(CSources[I]), 1, Length(SCnCppComment)) then
            begin
              Inc(CommentCount);
              // ˳����� BCB �е�����ע�ͣ�Cpp�ĵ�������ע��ǰ���� H �ĵڶ�����ע��ǰ�ɹ�����
              if ((IsCpp(S) or IsC(S)) and (CommentCount <= 2)) or
                ((IsH(S) or IsHpp(S)) and (CommentCount <= 3)) then
                CommentPos := I + 1;
            end;
          end;

          if InsertPos = 0 then
            InsertPos := CommentPos;

          // ����ǩ��¼λ��
          View.BookmarkRecord(CnToggleUsesBookmarkID);
          FColumn := View.Buffer.EditPosition.Column;

          View.Buffer.EditPosition.GotoLine(InsertPos);
          View.Buffer.EditPosition.MoveBOL; // ������
          if (InsertPos > CSources.Count) or (Trim(CSources[InsertPos - 1]) = '') then
          begin
            // ��ǰ���ǿ��У���������
            View.Buffer.EditPosition.InsertText(#$D#$A);
            View.Buffer.EditPosition.MoveRelative(-1, 0); // �²���һ����
          end;

          if IsCpp(S) or IsC(S) then
            View.Buffer.EditPosition.InsertText('#include ""'#$D#$A)
          else
            View.Buffer.EditPosition.InsertText('#include <>'#$D#$A);

          View.Buffer.EditPosition.MoveRelative(-1, 0);
          View.Buffer.EditPosition.MoveEOL; // ����β
          View.Buffer.EditPosition.MoveRelative(0, -1);
          
          FUsesAdded := False;
          FUsesPosition := upImplementation;
        finally
          CSources.Free;
        end;
      end
      else
        Exit;

      View.MoveViewToCursor;
      View.Paint;
      FJumpTime := GetTickCount;
    finally
      MemStream.Free;
    end;
  end;
end;

function TCnEditorToggleUses.GetState: TWizardState;
begin
  Result := inherited GetState;
  if (wsEnabled in Result) and not CurrentIsSource then
    Result := [];
end;

function TCnEditorToggleUses.GetDefShortCut: TShortCut;
begin
  Result := ShortCut(Word('U'), [ssCtrl, ssAlt]);
end;

procedure TCnEditorToggleUses.LoadSettings(Ini: TCustomIniFile);
begin
  inherited;

end;

procedure TCnEditorToggleUses.SaveSettings(Ini: TCustomIniFile);
begin
  inherited;

end;

procedure TCnEditorToggleUses.EditorKeyDown(Key, ScanCode: Word; Shift: TShiftState;
  var Handled: Boolean);
begin
  if (Key = VK_ESCAPE) and (FUsesPosition in [upInterface, upImplementation]) then
  begin
    CursorReturnBack;
    Handled := True;
    FUsesPosition := upNone;
    FJumpTime := 0;
  end;
end;

procedure TCnEditorToggleUses.CursorReturnBack;
var
  View: IOTAEditView;
begin
  View := CnOtaGetTopMostEditView;
  if View = nil then
    Exit;

  View.BookmarkGoto(CnToggleUsesBookmarkID);
  if View.Buffer.EditPosition.Column = 1 then // ������ص�ԭ��
    View.Buffer.EditPosition.MoveRelative(0, FColumn - 1);

  View.MoveViewToCursor;
  View.Paint;
end;

initialization
  RegisterCnEditor(TCnEditorToggleUses);

{$ENDIF CNWIZARDS_CNEDITORWIZARD}  
end.
