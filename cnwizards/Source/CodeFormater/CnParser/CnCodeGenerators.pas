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

unit CnCodeGenerators;
{* |<PRE>
================================================================================
* ������ƣ�CnPack �����ʽ��ר��
* ��Ԫ���ƣ���ʽ��������������� CnCodeGenerators
* ��Ԫ���ߣ�CnPack������
* ��    ע���õ�Ԫʵ���˴����ʽ������Ĳ���������
* ����ƽ̨��Win2003 + Delphi 5.0
* ���ݲ��ԣ�not test yet
* �� �� ����not test hell
* ��Ԫ��ʶ��$Id: CnCodeGenerators.pas 763 2011-02-07 14:18:23Z liuxiao@cnpack.org $
* �޸ļ�¼��2007-10-13 V1.0
*               ���뻻�еĲ������ô����������ơ�
*           2003-12-16 V0.1
*               �������򵥵Ĵ�������д���Լ����������
================================================================================
|</PRE>}

interface

uses
  Classes, SysUtils;

type
  TCnCodeWrapMode = (cwmNone, cwmSimple, cwmAdvanced);
  {* ���뻻�е����ã����Զ����У��򵥵ĳ����ͻ��У��߼����У�����֪����ɶ;-(��}

  TCnCodeGenerator = class
  private
    FCode: TStrings;
    FLock: Word;
    FColumnPos: Integer;
    FCodeWrapMode: TCnCodeWrapMode;
    function GetCurIndentSpace: Integer;
    function GetLockedCount: Word;
  public
    constructor Create;
    procedure Reset;
    procedure Write(S: String; BeforeSpaceCount:Word = 0;
        AfterSpaceCount: Word = 0);
    procedure Writeln;
    function SourcePos: Word;
    procedure SaveToStream(Stream: TStream);
    procedure SaveToFile(FileName: String);
    procedure SaveToStrings(AStrings: TStrings);

    procedure LockOutput;
    procedure UnLockOutput;
    
    procedure ClearOutputLock;
    {* ֱ�ӽ������������}

    property LockedCount: Word read GetLockedCount;
    {* �������}
    property ColumnPos: Integer read FColumnPos;
    {* ��ǰ���ĺ���λ�ã����ڻ���}
    property CurIndentSpace: Integer read GetCurIndentSpace;
    {* ��ǰ����ǰ��Ŀո���}
    property CodeWrapMode: TCnCodeWrapMode read FCodeWrapMode write FCodeWrapMode;
    {* ���뻻�е�����}
  end;

implementation

{ TCnCodeGenerator }

uses
  CnCodeFormatRules;

procedure TCnCodeGenerator.ClearOutputLock;
begin
  FLock := 0;
end;

constructor TCnCodeGenerator.Create;
begin
  FCode := TStringList.Create;
  FLock := 0;
end;

function TCnCodeGenerator.GetCurIndentSpace: Integer;
var
  I, Len: Integer;
begin
  Result := 0;
  if FCode.Count > 0 then
  begin
    Len := Length(FCode[FCode.Count - 1]);
    if Len > 0 then
    begin
      for I := 1 to Len do
        if FCode[FCode.Count - 1][I] in [' ', #09] then
          Inc(Result)
        else
          Exit;
    end;
  end;
end;

function TCnCodeGenerator.GetLockedCount: Word;
begin
  Result := FLock;
end;

procedure TCnCodeGenerator.LockOutput;
begin
  Inc(FLock);
end;

procedure TCnCodeGenerator.Reset;
begin
  FCode.Clear;
end;

procedure TCnCodeGenerator.SaveToFile(FileName: String);
begin
  FCode.SaveToFile(FileName);
end;

procedure TCnCodeGenerator.SaveToStream(Stream: TStream);
begin
  FCode.SaveToStream(Stream);
end;

procedure TCnCodeGenerator.SaveToStrings(AStrings: TStrings);
begin
  AStrings.Assign(FCode);
end;

function TCnCodeGenerator.SourcePos: Word;
begin
  Result := Length(FCode[FCode.Count - 1]);
end;

procedure TCnCodeGenerator.UnLockOutput;
begin
  Dec(FLock);
end;

procedure TCnCodeGenerator.Write(S: string; BeforeSpaceCount,
  AfterSpaceCount: Word);
var
  Str: string;
  Len: Integer;
begin
  if FLock <> 0 then Exit;
  
  if FCode.Count = 0 then FCode.Add('');

  Str := Format('%s%s%s', [StringOfChar(' ', BeforeSpaceCount), S,
    StringOfChar(' ', AfterSpaceCount)]);
  Len := Length(Str);

  if CodeWrapMode = cwmNone then
  begin
    // ���Զ�����ʱ���账��
  end
  else if CodeWrapMode = cwmSimple then // �򵥻��У��ж��Ƿ񳬳����
  begin
    if (FColumnPos <= CnPascalCodeForRule.WrapWidth) and
      (FColumnPos + Len > CnPascalCodeForRule.WrapWidth) then
    begin
      Str := StringOfChar(' ', CurIndentSpace) + Str; // ����ԭ�е�����
      Writeln;
    end;
  end
  else if CodeWrapMode = cwmAdvanced then // TODO: ��δ����
  begin

  end;

  FCode[FCode.Count - 1] :=
    Format('%s%s', [FCode[FCode.Count - 1], Str]);

  FColumnPos := Length(FCode[FCode.Count - 1]);
end;

procedure TCnCodeGenerator.Writeln;
begin
  if FLock <> 0 then Exit;

  // Write(S, BeforeSpaceCount, AfterSpaceCount);
  // delete trailing blanks
  FCode[FCode.Count - 1] := TrimRight(FCode[FCode.Count - 1]);
  FCode.Add('');
  FColumnPos := 0;
end;

end.
