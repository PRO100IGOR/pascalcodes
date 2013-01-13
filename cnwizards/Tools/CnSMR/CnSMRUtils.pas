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

unit CnSMRUtils;
{ |<PRE>
================================================================================
* ������ƣ�CnPack ��ִ���ļ���ϵ��������
* ��Ԫ���ƣ�SMR ������
* ��Ԫ���ߣ�Chinbo��Shenloqi��
* ��    ע��
* ����ƽ̨��PWin2000Pro + Delphi 5.01
* ���ݲ��ԣ�PWin9X/2000/XP + Delphi 5/6/7 + C++Builder 5/6
* �� �� �����õ�Ԫ�е��ַ���֧�ֱ��ػ�����ʽ
* ��Ԫ��ʶ��$Id: CnSMRUtils.pas 763 2011-02-07 14:18:23Z liuxiao@cnpack.org $
* �޸ļ�¼��2007.08.29 V1.0
*               ������Ԫ
================================================================================
|</PRE>}

interface

{$I CnWizards.inc}

{$IFDEF DELPHI7_UP}
  {$WARN SYMBOL_PLATFORM OFF}
  {$WARN UNIT_PLATFORM OFF}
{$ENDIF}

uses
  SysUtils, Windows, Classes, CnBaseUtils;

type
  PSMR = ^TSMR;
  TSMR = record
    AffectModules: TStrings;
    AllAffectModules: TStrings;
  end;

  TSMRList = class(TStringList)
  private
    function GetSMR(Index: Integer): PSMR;
    procedure SetSMR(Index: Integer; const Value: PSMR);

    procedure ClearSMR;
    procedure InternalSaveToText(var Stream: Text);
  public
    constructor Create;
    destructor Destroy; override;

    function GetAllAffectModules(const s: string): string; virtual;
    function GetAffectModules(const s: string): string; virtual;

    function AddCommaText(const s, CommaAffects, CommaAllAffects: string): Integer;
    procedure Clear; override;
    procedure Delete(Index: Integer); override;

    procedure LoadFromFile(const FileName: string); override;
    procedure SaveToFile(const FileName: string); override;

    property SMR[Index: Integer]: PSMR read GetSMR write SetSMR;
  end;

function NewSMR: PSMR;
function NewSMRAndCreateList: PSMR;
procedure DisposeSMR(P: PSMR);

implementation

uses
  FileCtrl, CnBuffStr;

var
  cssSourceFiles: string = ' Source Files:';
  cssAffectModules: string = 'Affect Modules:';
  cssAllAffectModules: string = 'All Affect Modules:';
  { DO NOT LOCALIZE }

function NewSMR: PSMR;
begin
  New(Result);
  Result.AffectModules := nil;
  Result.AllAffectModules := nil;
end;

function NewSMRAndCreateList: PSMR;
begin
  New(Result);
  Result.AffectModules := TStringList.Create;
  TStringList(Result.AffectModules).Sorted := True;
  Result.AllAffectModules := TStringList.Create;
  TStringList(Result.AllAffectModules).Sorted := True;
end;

procedure DisposeSMR(P: PSMR); 
begin
  if P <> nil then
  begin
    if Assigned(P.AffectModules) then
    begin
      FreeAndNil(P.AffectModules);
    end;
    if Assigned(P.AllAffectModules) then
    begin
      FreeAndNil(P.AllAffectModules);
    end;
    Dispose(P);
  end;
end;

{ TPackageInfosList }

function TSMRList.AddCommaText(const s, CommaAffects, CommaAllAffects: string): Integer;
var
  P: PSMR;
begin
  Result := Add(s);
  if Result >= 0 then
  begin
    P := NewSMRAndCreateList;
    try
      SetCommaText(CommaAffects, P.AffectModules);
      SetCommaText(CommaAllAffects, P.AllAffectModules);
      Objects[Result] := Pointer(P);
    except
      DisposeSMR(P);
      raise;
    end;
  end;
end;

procedure TSMRList.Clear;
begin
  ClearSMR;
  inherited;
end;

procedure TSMRList.ClearSMR;
var
  i: Integer;
begin
  for i := 0 to Count - 1 do
  begin
    DisposeSMR(PSMR(Objects[i]));
  end;
end;

constructor TSMRList.Create;
begin
  inherited;
end;

procedure TSMRList.Delete(Index: Integer);
begin
  if (Index < 0) or (Index >= Count) then
  begin
    Exit;
  end;
  DisposeSMR(SMR[Index]);
  inherited;
end;

destructor TSMRList.Destroy;
begin
  Clear;
  inherited;
end;

function TSMRList.GetSMR(Index: Integer): PSMR;
begin
  if (Index < 0) or (Index >= Count) then
  begin
    Result := nil;
    Exit;
  end;
  Result := Pointer(Objects[Index]);
end;

function TSMRList.GetAllAffectModules(
  const s: string): string;
begin
  Result := cssAllAffectModules + s;
end;

function TSMRList.GetAffectModules(const s: string): string;
begin
  Result := cssAffectModules + s;
end;

procedure TSMRList.InternalSaveToText(var Stream: Text);
var
  i: Integer;
begin
  //Save Head
  StringsSaveToTextWithSection(Self, Stream, cssSourceFiles);
  //Save Results
  for i := 0 to Count - 1 do
  begin
    if SMR[i] <> nil then
    begin
      with SMR[i]^ do
      begin
        StringsSaveToTextWithSection(
          AffectModules,
          Stream,
          GetAffectModules(Strings[i]));
        StringsSaveToTextWithSection(
          AllAffectModules,
          Stream,
          GetAllAffectModules(Strings[i]));
      end;
    end;
  end;
end;

procedure TSMRList.LoadFromFile(const FileName: string);
var
  P: PSMR;
  Stream: TStringReader;
  i: Integer;
  sl: TSectionList;
begin
  Stream := TStringReader.Create;
  try
    Stream.LoadFromFile(FileName);
    BulidSectionList(Stream, sl);
//    sl := nil;
    BeginUpdate;
    try
      Clear;
      //Load Head
      StringsLoadFromTextWithSection(Self, Stream, cssSourceFiles, sl);
      //Load Results
      for i := 0 to Count - 1 do
      begin
        P := NewSMRAndCreateList;
        try
          SMR[i] := P;
          StringsLoadFromTextWithSection(P.AffectModules,
            Stream,
            GetAffectModules(Strings[i]),
            sl);
          StringsLoadFromTextWithSection(
            P.AllAffectModules,
            Stream,
            GetAllAffectModules(Strings[i]),
            sl);
        except
          DisposeSMR(P);
          raise;
        end;
      end;
    finally
      EndUpdate;
    end;
  finally
    Stream.Free;
    FreeSectionList(sl);
  end;
end;

procedure TSMRList.SaveToFile(const FileName: string);
var
  Stream: TextFile;
begin
  AssignFile(Stream, FileName);
  try
    Rewrite(Stream);
    InternalSaveToText(Stream);
  finally
    CloseFile(Stream);
  end;
end;

procedure TSMRList.SetSMR(Index: Integer;
  const Value: PSMR);
begin
  if (Index < 0) or (Index >= Count) then
  begin
    Exit;
  end;
  PutObject(Index, Pointer(Value));
end;

end.
