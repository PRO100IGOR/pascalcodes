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

unit CnEditorCodeTool;
{ |<PRE>
================================================================================
* ������ƣ�CnPack IDE ר�Ұ�
* ��Ԫ���ƣ�ѡ���ı�����༭������
* ��Ԫ���ߣ��ܾ��� (zjy@cnpack.org)
* ��    ע�������û�ѡ���ı��Ĵ���༭������
* ����ƽ̨��PWin2000Pro + Delphi 5.01
* ���ݲ��ԣ�PWin9X/2000/XP + Delphi 5/6/7 + C++Builder 5/6
* �� �� �����õ�Ԫ�е��ַ���֧�ֱ��ػ�����ʽ
* ��Ԫ��ʶ��$Id: CnEditorCodeTool.pas 763 2011-02-07 14:18:23Z liuxiao@cnpack.org $
* �޸ļ�¼��2005.01.25 V1.2
*               �ֲ� GetText ���ܶ�ȡ�󳤶ȴ����ȱ��
*           2004.08.22 V1.1
*               ���Ӵ���ȫ����Ԫ�ļ���ѡ��
*           2003.03.23 V1.0
*               ������Ԫ
================================================================================
|</PRE>}

interface

{$I CnWizards.inc}

{$IFDEF CNWIZARDS_CNEDITORWIZARD}

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, IniFiles, ToolsAPI, CnWizClasses, CnWizUtils, CnConsts, CnCommon,
  CnEditorWizard, CnWizConsts;

type

//==============================================================================
// ѡ���ı�����༭������
//==============================================================================

{ TCnEditorCodeTool }

  TCnCodeToolStyle = (csLine, csSelText, csAllText);
  {* �����ı��ķ�ʽ��csLine Ϊѡ���з�ʽ��csSelText/csAllTextΪѡ��/ȫ���ı���ʽ}

  TCnEditorCodeTool = class(TCnBaseEditorTool)
  {* ѡ����봦���߻��ࡣ
     �û������������û�ѡ����ı������û�ѡ���˴����ִ�иñ༭�����ߣ�����
     ѡ��Ĵ������ת������}
  private
    FValidInSource: Boolean;
    FBlockMustNotEmpty: Boolean;
  protected
    property ValidInSource: Boolean read FValidInSource write FValidInSource;
    {* ֻ��Դ�����ļ�����Ч }
    property BlockMustNotEmpty: Boolean read FBlockMustNotEmpty write
      FBlockMustNotEmpty;
    {* ֻ�е�ѡ��鲻Ϊ��ʱ��Ч }
    function ProcessLine(const Str: string): string; virtual;
    {* �������ѡ�� Style Ϊ csLine �з�ʽ������ʹ�ø÷���������ÿһ�д��룬
       ��ʱ�ɲ����� ProcessText ����}
    function ProcessText(const Text: string): string; virtual;
    {* �������ѡ�� Style Ϊ csSelText/csAllText ȫ�ı���ʽ������ϣ���Լ�������
       ����Ӧ���ظ÷�������ʱ�������� ProcessLine ����}
    function GetStyle: TCnCodeToolStyle; virtual; abstract;
    {* ����ʽ�����Ϊ csLine��ProcessText ���� Text ������û�ѡ��
       ��������Ϊ���С����Ϊ csSelText��Text ��ֻ�����û�ʵ��ѡ����ı���
       ���Ϊ csAllText��Text ����ȫ Unit �����ݡ�}
    procedure GetNewPos(var ARow: Integer; var ACol: Integer); virtual;
    {* ִ����Ϻ������ͨ�����ش˺�����ȷ��������ڵ�λ��}
  public
    constructor Create(AOwner: TCnEditorWizard); override;
    procedure Execute; override;
    function GetState: TWizardState; override;
  end;

{$ENDIF CNWIZARDS_CNEDITORWIZARD}

implementation

{$IFDEF CNWIZARDS_CNEDITORWIZARD}

{$IFDEF DEBUG}
uses
  CnDebug;
{$ENDIF}

//==============================================================================
// ѡ���ı�����༭������
//==============================================================================

{ TCnEditorCodeTool }

constructor TCnEditorCodeTool.Create(AOwner: TCnEditorWizard);
begin
  inherited;
  ValidInSource := True;
  BlockMustNotEmpty := False;
end;

function TCnEditorCodeTool.ProcessLine(const Str: string): string;
begin
  { do nothing }
end;

function TCnEditorCodeTool.ProcessText(const Text: string): string;
var
  Lines: TStrings;
  i: Integer;
begin
  Lines := TStringList.Create;
  try
    Lines.Text := Text;
    for i := 0 to Lines.Count - 1 do
      Lines[i] := ProcessLine(Lines[i]);
    Result := Lines.Text;
  finally
    Lines.Free;
  end;
end;

procedure TCnEditorCodeTool.Execute;
const
  SCnOtaBatchSize = $7FFF;
var
  View: IOTAEditView;
  Block: IOTAEditBlock;
  Text: AnsiString;
  Buf: PAnsiChar;
  BlockStartLine, BlockEndLine: Integer;
  StartPos, EndPos, ReadStart: Integer;
  Reader: IOTAEditReader;
  Writer: IOTAEditWriter;
  Row, Col, Len, ASize: Integer;
  NewRow, NewCol: Integer;
  Stream: TMemoryStream;
begin
  View := CnOtaGetTopMostEditView;
  if View <> nil then
  begin
    Block := View.Block;
    StartPos := 0;
    EndPos := 0;
    BlockStartLine := 0;
    BlockEndLine := 0;
    NewRow := 0;
    NewCol := 0;
    if GetStyle = csLine then
    begin
      if (Block <> nil) and Block.IsValid then
      begin             // ѡ���ı���������
        BlockStartLine := Block.StartingRow;
        StartPos := CnOtaEditPosToLinePos(OTAEditPos(1, BlockStartLine), View);
        BlockEndLine := Block.EndingRow;
        // ��겻������ʱ��������һ������
        if Block.EndingColumn > 1 then
        begin
          if BlockEndLine < View.Buffer.GetLinesInBuffer then
          begin
            Inc(BlockEndLine);
            EndPos := CnOtaEditPosToLinePos(OTAEditPos(1, BlockEndLine), View);
          end
          else
            EndPos := CnOtaEditPosToLinePos(OTAEditPos(255, BlockEndLine), View);
        end
        else
          EndPos := CnOtaEditPosToLinePos(OTAEditPos(1, BlockEndLine), View);
      end
      else
      begin    // δѡ���ʾת�����С�
        if CnOtaGetCurSourcePos(Col, Row) then
        begin
          StartPos := CnOtaEditPosToLinePos(OTAEditPos(1, Row), View);
          if Row < View.Buffer.GetLinesInBuffer then
          begin
            EndPos := CnOtaEditPosToLinePos(OTAEditPos(1, Row + 1), View);
            NewRow := Row; 
            NewCol := Col;
            GetNewPos(NewRow, NewCol); // ������ȷ��һ��λ�ñ仯
          end
          else
            EndPos := CnOtaEditPosToLinePos(OTAEditPos(255, Row), View);
        end
        else
        begin
          ErrorDlg(SCnEditorCodeToolNoLine);
          Exit;
        end;
      end;
    end
    else if GetStyle = csSelText then
    begin
      if (Block <> nil) and (Block.IsValid) then
      begin                           // ������ѡ����ı�
        StartPos := CnOtaEditPosToLinePos(OTAEditPos(Block.StartingColumn,
          Block.StartingRow), View);
        EndPos := CnOtaEditPosToLinePos(OTAEditPos(Block.EndingColumn,
          Block.EndingRow), View);
      end;
    end
    else
    begin
      StartPos := 0;
      Stream := TMemoryStream.Create;
      CnOtaSaveCurrentEditorToStream(Stream, False);
      EndPos := Stream.Size - 1; // �ñ��취�õ��༭�ĳ��ȣ�
      // ��һ��Ϊ��ȥ�� SaveToStream ʱβ���ӵ�#0��һ
      Stream.Free;
    end;

    Len := EndPos - StartPos;
    Assert(Len >= 0);
    SetLength(Text, Len);
    Buf := Pointer(Text);
    ReadStart := StartPos;

    Reader := View.Buffer.CreateReader;
    try
      while Len > SCnOtaBatchSize do // ��ζ�ȡ
      begin
        ASize := Reader.GetText(ReadStart, Buf, SCnOtaBatchSize);
        Inc(Buf, ASize);
        Inc(ReadStart, ASize);
        Dec(Len, ASize);
      end;
      if Len > 0 then // �����ʣ���
        Reader.GetText(ReadStart, Buf, Len);
    finally
      Reader := nil;
    end;

    if Text <> '' then
    begin
    {$IFDEF UNICODE_STRING}
      Text := AnsiString(ProcessText(string(ConvertEditorTextToText(Text)))); // �����ı�
    {$ELSE}
      Text := ProcessText(ConvertEditorTextToText(Text)); // �����ı�
    {$ENDIF}
      Writer := View.Buffer.CreateUndoableWriter;
      try
        Writer.CopyTo(StartPos);
        Writer.Insert(PAnsiChar(ConvertTextToEditorText(Text)));
        Writer.DeleteTo(EndPos);
      finally
        Writer := nil;
      end;                      
    end;

    if (NewRow > 0) and (NewCol > 0) then
    begin
      View.CursorPos := OTAEditPos(NewCol, NewRow);
    end
    else if (BlockStartLine > 0) and (BlockEndLine > 0) then
    begin
      CnOtaSelectBlock(View.Buffer, OTACharPos(0, BlockStartLine),
        OTACharPos(0, BlockEndLine));
    end;

    View.Paint;
  end
  else
    ErrorDlg(SCnEditorCodeToolSelIsEmpty);
end;

function TCnEditorCodeTool.GetState: TWizardState;
begin
  Result := inherited GetState;
  if wsEnabled in Result then
  begin
    if ValidInSource and not CurrentIsSource or
      BlockMustNotEmpty and CnOtaCurrBlockEmpty then
      Result := [];
  end;
end;

procedure TCnEditorCodeTool.GetNewPos(var ARow, ACol: Integer);
begin
// ����ɶ�����������ı�ֵ
end;

{$ENDIF CNWIZARDS_CNEDITORWIZARD}
end.
