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

unit CnPrefixList;
{* |<PRE>
================================================================================
* ������ƣ�CnPack IDE ר�Ұ�
* ��Ԫ���ƣ����ǰ׺ר���б��嵥Ԫ
* ��Ԫ���ߣ��ܾ��� (zjy@cnpack.org)
* ��    ע�����ǰ׺ר���б��嵥Ԫ
* ����ƽ̨��PWin2000Pro + Delphi 5.01
* ���ݲ��ԣ�PWin9X/2000/XP + Delphi 5/6/7 + C++Builder 5/6
* �� �� �����õ�Ԫ�е��ַ��������ϱ��ػ�����ʽ
* ��Ԫ��ʶ��$Id: CnPrefixList.pas 763 2011-02-07 14:18:23Z liuxiao@cnpack.org $
* �޸ļ�¼��2003.04.26 V1.0
*               ������Ԫ
================================================================================
|</PRE>}

interface

{$I CnWizards.inc}

{$IFDEF CNWIZARDS_CNPREFIXWIZARD}

uses
  Windows, Messages, SysUtils, Classes, Contnrs, IniFiles, ToolsAPI, CnWizIni;

type

{ TPrefixItem }

  TPrefixItem = class(TObject)
  private
    FIgnore: Boolean;
    FPrefix: string;
    FComponentClass: string;
    procedure SetPrefix(const Value: string);
  public
    property ComponentClass: string read FComponentClass write FComponentClass;
    property Prefix: string read FPrefix write SetPrefix;
    property Ignore: Boolean read FIgnore write FIgnore;
  end;

{ TPrefixList }

  TPrefixList = class(TObject)
  private
    FList: TObjectList;
    function GetCount: Integer;
    function GetIgnore(ComponentClass: string): Boolean;
    function GetItem(Index: Integer): TPrefixItem;
    function GetPrefix(ComponentClass: string): string;
    procedure SetIgnore(ComponentClass: string; const Value: Boolean);
    procedure SetPrefix(ComponentClass: string; const Value: string);
  protected

  public
    constructor Create;
    destructor Destroy; override;
    function IndexOf(const ComponentClass: string): Integer;
    function Add(const ComponentClass, Prefix: string; Ignore: Boolean = False): Integer;
    procedure Delete(Index: Integer);
    procedure Clear;
    function LoadFromFile(const FileName: string): Boolean;
    function SaveToFile(const FileName: string): Boolean;

    property Items[Index: Integer]: TPrefixItem read GetItem; default;
    property Count: Integer read GetCount;
    property Prefixs[ComponentClass: string]: string read GetPrefix write SetPrefix;
    property Ignore[ComponentClass: string]: Boolean read GetIgnore write SetIgnore;
  end;

{ TCompItem }

  TCompItem = class(TObject)
  private
    FActive: Boolean;
    FFormEditor: IOTAFormEditor;
    FComponent: TComponent;
    FPrefix: string;
    FOldName: string;
    FNewName: string;
    FProjectName: string;
  public
    property Active: Boolean read FActive write FActive;
    property ProjectName: string read FProjectName write FProjectName;
    property FormEditor: IOTAFormEditor read FFormEditor write FFormEditor;
    property Component: TComponent read FComponent write FComponent;
    property Prefix: string read FPrefix write FPrefix;
    property OldName: string read FOldName write FOldName;
    property NewName: string read FNewName write FNewName;
  end;

{ TCompList }

  TCompList = class(TObject)
  private
    FList: TObjectList;
    function GetCount: Integer;
    function GetItem(Index: Integer): TCompItem;
  public
    constructor Create;
    destructor Destroy; override;

    function Add(const AProjectName: string; AFormEditor: IOTAFormEditor;
      AComponent: TComponent; const APrefix, AOldName, ANewName: string): Integer;
    procedure Delete(Index: Integer);
    procedure Clear;
    function IndexOfNewName(AFormEditor: IOTAFormEditor; ANewName: string): Integer;
    function IndexOfComponent(AFormEditor: IOTAFormEditor; AComponent: TComponent): Integer;

    property Count: Integer read GetCount;
    property Items[Index: Integer]: TCompItem read GetItem; default;
  end;

{$ENDIF CNWIZARDS_CNPREFIXWIZARD}

implementation

{$IFDEF CNWIZARDS_CNPREFIXWIZARD}

{ TPrefixItem }

procedure TPrefixItem.SetPrefix(const Value: string);
begin
  if (Value <> '') and IsValidIdent(Value) then
  begin
    FPrefix := Value;
  end
  else
    FPrefix := '';
end;

{ TPrefixList }

function TPrefixList.Add(const ComponentClass, Prefix: string;
  Ignore: Boolean): Integer;
var
  Item: TPrefixItem;
begin
  Result := IndexOf(ComponentClass);
  if Result < 0 then
  begin
    Item := TPrefixItem.Create;
    Result := FList.Add(Item);
  end
  else
    Item := Items[Result];

  Item.ComponentClass := ComponentClass;
  Item.Prefix := Prefix;
  Item.Ignore := Ignore;
end;

procedure TPrefixList.Clear;
begin
  FList.Clear;
end;

constructor TPrefixList.Create;
begin
  FList := TObjectList.Create;
end;

procedure TPrefixList.Delete(Index: Integer);
begin
  FList.Delete(Index);
end;

destructor TPrefixList.Destroy;
begin
  FList.Free;
  inherited;
end;

function TPrefixList.GetCount: Integer;
begin
  Result := FList.Count;
end;

function TPrefixList.GetIgnore(ComponentClass: string): Boolean;
var
  Idx: Integer;
begin
  Idx := IndexOf(ComponentClass);
  if Idx >= 0 then
    Result := Items[Idx].Ignore
  else
    Result := False;
end;

function TPrefixList.GetItem(Index: Integer): TPrefixItem;
begin
  Result := TPrefixItem(FList[Index]);
end;

function TPrefixList.GetPrefix(ComponentClass: string): string;
var
  Idx: Integer;
begin
  Idx := IndexOf(ComponentClass);
  if Idx >= 0 then
    Result := Items[Idx].Prefix
  else
    Result := '';
end;

function TPrefixList.IndexOf(const ComponentClass: string): Integer;
var
  i: Integer;
begin
  for i := 0 to Count - 1 do
    if SameText(Items[i].ComponentClass, ComponentClass) then
    begin
      Result := i;
      Exit;
    end;
  Result := -1;
end;

const
  csPrefix = 'Prefix';
  csIgnore = 'Ignore';

function TPrefixList.LoadFromFile(const FileName: string): Boolean;
var
  i: Integer;
  Strs: TStrings;
begin
  Result := False;
  Clear;
  if not FileExists(FileName) then Exit;

  with TMemIniFile.Create(FileName) do
  try
    Strs := TStringList.Create;
    try
      ReadSection(csPrefix, Strs);

      for i := 0 to Strs.Count - 1 do
        Add(Strs[i], ReadString(csPrefix, Strs[i], ''),
          ReadBool(csIgnore, Strs[i], False));
      Result := True;
    finally
      Strs.Free;
    end;
  finally
    Free;
  end;
end;

function TPrefixList.SaveToFile(const FileName: string): Boolean;
var
  i: Integer;
begin
  try
    with TMemIniFile.Create(FileName) do
    try
      for i := 0 to Count - 1 do
      begin
        if (Items[i].Prefix <> '') or Items[i].Ignore then
        begin
          if Items[i].Prefix <> '' then
            WriteString(csPrefix, Items[i].ComponentClass, Items[i].Prefix);
          if Items[i].Ignore then
            WriteBool(csIgnore, Items[i].ComponentClass, Items[i].Ignore)
          else
            DeleteKey(csIgnore, Items[i].ComponentClass);
        end;
      end;

      UpdateFile;
      Result := True;
    finally
      Free;
    end;
  except
    Result := False;
  end;
end;

procedure TPrefixList.SetIgnore(ComponentClass: string;
  const Value: Boolean);
var
  Idx: Integer;
begin
  Idx := IndexOf(ComponentClass);
  if Idx >= 0 then
    Items[Idx].Ignore := Value
  else if Value then
    Add(ComponentClass, '', Value);
end;

procedure TPrefixList.SetPrefix(ComponentClass: string;
  const Value: string);
var
  Idx: Integer;
begin
  Idx := IndexOf(ComponentClass);
  if Idx >= 0 then
    Items[Idx].Prefix := Value
  else
    Add(ComponentClass, Value);
end;

{ TCompList }

function TCompList.Add(const AProjectName: string; AFormEditor: IOTAFormEditor;
  AComponent: TComponent; const APrefix, AOldName, ANewName: string): Integer;
var
  Item: TCompItem;
begin
  Item := TCompItem.Create;
  Item.FActive := True;
  Item.FProjectName := AProjectName;
  Item.FFormEditor := AFormEditor;
  Item.FComponent := AComponent;
  Item.FPrefix := APrefix;
  Item.FOldName := AOldName;
  Item.FNewName := ANewName;
  Result := FList.Add(Item);
end;

procedure TCompList.Clear;
begin
  FList.Clear;
end;

constructor TCompList.Create;
begin
  FList := TObjectList.Create;
end;

procedure TCompList.Delete(Index: Integer);
begin
  FList.Delete(Index);
end;

destructor TCompList.Destroy;
begin
  FList.Free;
  inherited;
end;

function TCompList.GetCount: Integer;
begin
  Result := FList.Count;
end;

function TCompList.GetItem(Index: Integer): TCompItem;
begin
  Result := TCompItem(FList[Index]);
end;

function TCompList.IndexOfComponent(AFormEditor: IOTAFormEditor;
  AComponent: TComponent): Integer;
var
  i: Integer;
begin
  for i := 0 to Count - 1 do
    if (Items[i].FFormEditor = AFormEditor) and (Items[i].FComponent = AComponent) then
    begin
      Result := i;
      Exit;
    end;
  Result := -1;

end;

function TCompList.IndexOfNewName(AFormEditor: IOTAFormEditor;
  ANewName: string): Integer;
var
  i: Integer;
begin
  for i := 0 to Count - 1 do
    if (Items[i].FFormEditor = AFormEditor) and SameText(Items[i].FNewName,
      ANewName) then
    begin
      Result := i;
      Exit;
    end;
  Result := -1;
end;

{$ENDIF CNWIZARDS_CNPREFIXWIZARD}
end.
