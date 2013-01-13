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

unit CnFastList;
{* |<PRE>
================================================================================
* ������ƣ�CnPack IDE ר�Ұ�
* ��Ԫ���ƣ����� List ��Ԫ
* ��Ԫ���ߣ��ܾ��� zjy@cnpack.org
* ��    ע���õ�Ԫ������ �����б��� TCnFastList
* ����ƽ̨��PWinXP SP3 + Delphi 7
* ���ݲ��ԣ�PWin9X/2000/XP + Delphi 5/6/7 + C++Builder 5/6
* �� �� �����õ�Ԫ�е��ַ��������ϱ��ػ�����ʽ
* ��Ԫ��ʶ��$Id: CnFastList.pas 897 2011-07-09 07:04:28Z liuxiao@cnpack.org $
* �޸ļ�¼��2008.06.20 V1.0
*               ������Ԫ
================================================================================
|</PRE>}

interface

{$I CnWizards.inc}

uses
  Classes, {$IFDEF COMPILER6_UP}RTLConsts{$ELSE}Consts{$ENDIF}, SysUtils;

{$IFDEF BDS2012_UP}
const
  MaxListSize = Maxint div 16;

type
  PCnPointerList = ^TCnPointerList;
  TCnPointerList = array[0..MaxListSize - 1] of Pointer;
{$ELSE}
type
  PCnPointerList = PPointerList;
{$ENDIF}

type
  TCnBaseList = class(TObject)
  private
    FList: PCnPointerList;
    FObjectList: Boolean;
    FCount: Integer;
    FCapacity: Integer;
  protected
    function Get(Index: Integer): Pointer;
    procedure Grow;
    procedure Put(Index: Integer; Item: Pointer);
    procedure SetCapacity(NewCapacity: Integer);
    procedure SetCount(NewCount: Integer);
    class procedure Error(const Msg: string; Data: Integer);
  public
    constructor Create(AObjectList: Boolean);
    destructor Destroy; override;
    function Add(Item: Pointer): Integer;
    procedure Clear;
    procedure Delete(Index: Integer);
    function First: Pointer;
    function IndexOf(Item: Pointer): Integer;
    function Last: Pointer;
    property Capacity: Integer read FCapacity write SetCapacity;
    property Count: Integer read FCount write SetCount;
    property Items[Index: Integer]: Pointer read Get write Put; default;
    property List: PCnPointerList read FList;
  end;

  TCnList = class(TCnBaseList)
  public
    constructor Create;
  end;

  TCnObjectList = class(TCnBaseList)
  public
    constructor Create;
  end;

implementation

{ TCnBaseList }

constructor TCnBaseList.Create(AObjectList: Boolean);
begin
  FObjectList := AObjectList;
end;

destructor TCnBaseList.Destroy;
begin
  Clear;
end;

function TCnBaseList.Add(Item: Pointer): Integer;
begin
  Result := FCount;
  if Result = FCapacity then
    Grow;
  FList^[Result] := Item;
  Inc(FCount);
end;

procedure TCnBaseList.Clear;
var
  I: Integer;
begin
  if FObjectList then
    for I := 0 to FCount - 1 do
      TObject(FList^[I]).Free;
  FCount := 0;
  SetCapacity(0);
end;

procedure TCnBaseList.Delete(Index: Integer);
var
  Temp: Pointer;
begin
  if (Index < 0) or (Index >= FCount) then
    Error(SListIndexError, Index);
  Temp := Items[Index];
  Dec(FCount);
  if Index < FCount then
    System.Move(FList^[Index + 1], FList^[Index],
      (FCount - Index) * SizeOf(Pointer));
  if FObjectList and (Temp <> nil) then
    TObject(Temp).Free;
end;

class procedure TCnBaseList.Error(const Msg: string; Data: Integer);

  function ReturnAddr: Pointer;
  asm
          MOV     EAX,[EBP+4]
  end;

begin
  raise EListError.CreateFmt(Msg, [Data]) at ReturnAddr;
end;

function TCnBaseList.First: Pointer;
begin
  Result := Get(0);
end;

function TCnBaseList.Get(Index: Integer): Pointer;
begin
  if (Index < 0) or (Index >= FCount) then
    Error(SListIndexError, Index);
  Result := FList^[Index];
end;

procedure TCnBaseList.Grow;
var
  Delta: Integer;
begin
  if FCapacity >= 4 then
    Delta := FCapacity
  else
    Delta := 4;
  SetCapacity(FCapacity + Delta);
end;

function TCnBaseList.IndexOf(Item: Pointer): Integer;
var
  I: Integer;
begin
  for I := 0 to FCount - 1 do
    if FList^[I] = Item then
    begin
      Result := I;
      Exit;
    end;
  Result := -1;
end;

function TCnBaseList.Last: Pointer;
begin
  Result := Get(FCount - 1);
end;

procedure TCnBaseList.Put(Index: Integer; Item: Pointer);
begin
  if (Index < 0) or (Index >= FCount) then
    Error(SListIndexError, Index);
  FList^[Index] := Item;
end;

procedure TCnBaseList.SetCapacity(NewCapacity: Integer);
begin
  if (NewCapacity < FCount) or (NewCapacity > MaxListSize) then
    Error(SListCapacityError, NewCapacity);
  if NewCapacity <> FCapacity then
  begin
    ReallocMem(FList, NewCapacity * SizeOf(Pointer));
    FCapacity := NewCapacity;
  end;
end;

procedure TCnBaseList.SetCount(NewCount: Integer);
var
  I: Integer;
begin
  if (NewCount < 0) or (NewCount > MaxListSize) then
    Error(SListCountError, NewCount);
  if NewCount > FCapacity then
    SetCapacity(NewCount);
  if NewCount > FCount then
    FillChar(FList^[FCount], (NewCount - FCount) * SizeOf(Pointer), 0)
  else if FObjectList then
    for I := FCount - 1 downto NewCount do
      TObject(FList^[I]).Free;
  FCount := NewCount;
end;

{ TCnList }

constructor TCnList.Create;
begin
  inherited Create(False);
end;

{ TCnObjectList }

constructor TCnObjectList.Create;
begin
  inherited Create(True);
end;

end.


