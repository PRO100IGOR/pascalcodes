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

unit CnSourceCropper;
{ |<PRE>
================================================================================
* ������ƣ�CnPack IDE ר�Ұ�
* ��Ԫ���ƣ�Դ��ע��ɾ������ģ��
* ��Ԫ���ߣ���Х(LiuXiao) liuxiao@cnpack.org
* ��    ע��Դ��ע�ͽ���ģ��
* ����ƽ̨��Windows 2000 + Delphi 5
* ���ݲ��ԣ�PWin9X/2000/XP + Delphi 5/6/7 + C++Builder 5/6
* �� �� �����õ�Ԫ�е��ַ���֧�ֱ��ػ�����ʽ
* ��Ԫ��ʶ��$Id: CnSourceCropper.pas 763 2011-02-07 14:18:23Z liuxiao@cnpack.org $
* �޸ļ�¼��2003.07.29 V1.1
*               ���ӱ����Զ����ʽע�͵Ĺ���
*           2003.06.15 V1.0
*               ������Ԫ
================================================================================
|</PRE>}

interface

{$I CnWizards.inc}

uses
  Classes, SysUtils;

type
  TSourceTokenKind = (skUndefined, skCode, skBlockComment, skLineComment,
    skQuoteString, skDittoString, skDirective, skTodoList, skToReserve);
    
  TCropOption = (coAll, coExAscii);

type
  TCnSourceCropper = class(TComponent)
  private
    FCurTokenKind: TSourceTokenKind;
    FCurChar: AnsiChar;

    FCropTodoList: Boolean;
    FCropDirective: Boolean;
    FCropOption: TCropOption;
    FInStream: TStream;
    FOutStream: TStream;
    FReserve: Boolean;
    FReserveItems: TStringList;
    procedure SetInStream(const Value: TStream);
    procedure SetOutStream(const Value: TStream);
    procedure SetReserveItems(const Value: TStringList);

  protected
    procedure DoParse; virtual; abstract;
    procedure ProcessToBlockEnd; virtual; abstract;

    function IsTodoList: Boolean;
    function IsReserved: Boolean;
    function IsBlank(AChar: AnsiChar): Boolean;

    function GetCurChar: AnsiChar;
    function NextChar(Value: Integer = 1): AnsiChar;
    procedure WriteChar(Value: AnsiChar);
    
    procedure ProcessToLineEnd;
    procedure DoDefaultProcess;
    procedure DoBlockEndProcess;
  public
    procedure Parse;
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
  published
    property InStream: TStream read FInStream write SetInStream;
    property OutStream: TStream read FOutStream write SetOutStream;
    property CropOption: TCropOption read FCropOption write FCropOption;
    property CropDirective: Boolean read FCropDirective write FCropDirective;
    property CropTodoList: Boolean read FCropTodoList write FCropTodoList;
    property Reserve: Boolean read FReserve write FReserve;
    property ReserveItems: TStringList read FReserveItems write SetReserveItems;
    {* �Ƿ����ض���ʽ��ע�� }
  end;

type
  TCnPasCropper = class(TCnSourceCropper)
  private

  protected
    procedure DoParse; override;
    procedure ProcessToBlockEnd; override;
    procedure ProcessToBracketBlockEnd;
  public

  published

  end;

type
  TCnCPPCropper = class(TCnSourceCropper)
  private

  protected
    procedure DoParse; override;
    procedure ProcessToBlockEnd; override;
  public

  published

  end;

implementation

{ TCnSourceCropper }

const
  SCnToDo = 'TODO';
  SCnToDoDone = 'DONE';

constructor TCnSourceCropper.Create(AOwner: TComponent);
begin
  inherited;
  Self.FReserveItems := TStringList.Create;
end;

destructor TCnSourceCropper.Destroy;
begin
  Self.FReserveItems.Free;
  inherited;
end;

procedure TCnSourceCropper.DoBlockEndProcess;
begin
  case FCurTokenKind of
  skBlockComment: // ����ע�ͣ�ֻ������ɾ����չASCII�������ַ�С��128��ʱ���д��
    if (FCropOption = coExAscii) and (FCurChar < #128) then
      WriteChar(FCurChar);
  skDirective: // ���ڱ���ָ�ֻ�в��������ָ���ʱ����д�������ʱ����ע������
    if not CropDirective or
      ((FCropOption = coExAscii) and (FCurChar < #128)) then
      WriteChar(FCurChar);
  skTodoList: // ����todo��ֻ�в�����todo��ʱ����д�������ʱ����ע������
     if not CropTodoList or
      ((FCropOption = coExAscii) and (FCurChar < #128)) then
      WriteChar(FCurChar);
  skToReserve:
    if FReserve then
      WriteChar(FCurChar);
  else
    DoDefaultProcess;
  end;
end;

procedure TCnSourceCropper.DoDefaultProcess;
begin
  if (FCropOption = coAll) or (FCurChar < #128) then
    WriteChar(FCurChar);
end;

// ��һ�ַ���ָ��ָ���һ����
function TCnSourceCropper.GetCurChar: AnsiChar;
begin
  Result := #0;
  if Assigned(FInStream) then
  begin
    try
      FInStream.Read(Result, SizeOf(AnsiChar));
    except
      Exit;
    end;
  end;
end;

function TCnSourceCropper.IsBlank(AChar: AnsiChar): Boolean;
begin
  Result := AChar in [' ', #13, #10, #7, #9];
end;

function TCnSourceCropper.IsReserved: Boolean;
var
  i: Integer;
  OldChar: AnsiChar;
  OldPos: Integer;
  MaxLen: Integer;
  PBuf: PChar;
  SToCompare: String;
begin
  // �ж��Ƿ����ڱ����б��еĶ�����Ҳ�����ж��Ƿ�Ӧ�ñ���
  Result := False;
  if FInStream = nil then Exit;

  PBuf := nil;
  OldChar := FCurChar;
  OldPos := FInStream.Position;

  MaxLen := 0;
  for i := Self.FReserveItems.Count - 1 downto 0 do
  begin
    if MaxLen < Length(Self.FReserveItems.Strings[i]) then
      MaxLen := Length(Self.FReserveItems.Strings[i]);  
    if Self.FReserveItems.Strings[i] = '' then
      Self.FReserveItems.Delete(i);
  end;

  if (FCurChar = '/') or (FCurChar = '(') then
  begin
    FCurChar := GetCurChar;
    if FCurChar <> '*' then
      Exit;
  end;
  // ��ʱFCurCharָ��ע�Ϳ�ʼ���ŵ����һ�ֽڣ�{��/*��*��(*��*

  try
    PBuf := StrAlloc(MaxLen + 1);
    FillChar(PBuf^, Length(PBuf), 0);
    FInStream.Read(PBuf^, MaxLen);

    for i := 0 to Self.FReserveItems.Count - 1 do
    begin
      SToCompare := Copy(StrPas(PBuf), 1, Length(Self.FReserveItems.Strings[i]));
      if SToCompare = Self.FReserveItems.Strings[i] then
      begin
        Result := True;
        Exit;
      end;
    end;
  finally
    FCurChar := OldChar;
    FInStream.Position := OldPos;
    if PBuf <> nil then
      StrDispose(PBuf);
  end;
end;

function TCnSourceCropper.IsTodoList: Boolean;
var
  OldPos: Integer;
  OldChar: AnsiChar;
  PTodo: PChar;
  STodo: String;
begin
  // (* �� { ��// �����޿հ���Todo��Done�������޿ո��ð�ţ����ǺϷ���TodoList.
  // ����ʱ��FCurChar������'{'����'(*'��'('����'/*'�е�'/'����'//'�еĵ�һ��'/'��

  Result := False;
  if FInStream = nil then Exit;

  PTodo := nil;
  OldChar := FCurChar;
  OldPos := FInStream.Position;
  try
    if (FCurChar = '/') or (FCurChar = '(') then
    begin
      FCurChar := GetCurChar;
      if (FCurChar <> '*') and (FCurChar <> '/') then
        Exit;
    end;
    // ��ʱFCurCharָ��ע�Ϳ�ʼ���ŵ����һ�ֽڣ�{��/*��*��(*��*��//�ĵڶ���/

    while IsBlank(NextChar) do
      FCurChar := GetCurChar;
    // ��ʱFCurCharָ��ע���в�Ϊ�յĵ�һ���ַ���ǰһ�ַ���������{��*���

    PTodo := StrAlloc(Length(SCnToDo) + 1);
    FillChar(PTodo^, Length(PTodo), 0);
    FInStream.Read(PTodo^, Length(SCnToDo));
    STodo := Copy(UpperCase(StrPas(PTodo)), 1, 4);

    if (STodo = SCnTodo) or (STodo = SCnTodoDone) then
    begin
      // ��ʱָ��ָ�� todo ��һ���ַ���
      while IsBlank(NextChar) do
        FCurChar := GetCurChar;
        
      if NextChar = ':' then
      begin
        Result := True;
        Exit;
      end
    end;

  finally
    FCurChar := OldChar;
    FInStream.Position := OldPos;
    if PTodo <> nil then
      StrDispose(PTodo);
  end;
end;

// ��һ�ַ���ָ��λ�ò��䣬��Ȼ�ڵ�ǰ�ַ��ĺ�һλ�á�
function TCnSourceCropper.NextChar(Value: Integer): AnsiChar;
begin
  Result := #0;
  if Assigned(FInStream) then
  begin
    try
      FInStream.Seek(Value - 1, soFromCurrent);
      FInStream.Read(Result, SizeOf(AnsiChar));
      FInStream.Seek(-Value, soFromCurrent);
    except
      Exit;
    end;
  end;
end;

procedure TCnSourceCropper.Parse;
begin
  if (FInStream <> nil) and (FOutStream <> nil) then
  begin
    if (FInStream.Size > 0) then
    begin
      FInStream.Position := 0;
      FCurTokenKind := skUndefined;
      DoParse;
    end;
  end;
end;

procedure TCnSourceCropper.ProcessToLineEnd;
begin
  while not (FCurChar in [#0, #13]) do
  begin
    if ((FCropOption = coExAscii) and (FCurChar < #128))
      or (FCurTokenKind = skTodoList) then
        WriteChar(FCurChar);
    FCurChar := GetCurChar;
  end;

  if FCurChar = #13 then
    repeat
      WriteChar(FCurChar);   // �س�����Ҫд�ġ�
      FCurChar := GetCurChar;
    until FCurChar in [#0, #10];

  if FCurChar = #10 then
    WriteChar(FCurChar);

  // ���غ�FCurCharָ��#10��#0��Ҳ�������һ����������ַ���
  FCurTokenKind := skUndefined;
end;

procedure TCnSourceCropper.SetInStream(const Value: TStream);
begin
  FInStream := Value;
end;

procedure TCnSourceCropper.SetOutStream(const Value: TStream);
begin
  FOutStream := Value;
end;

procedure TCnSourceCropper.SetReserveItems(const Value: TStringList);
begin
  if Value <> nil then
    FReserveItems.Assign(Value);
end;

procedure TCnSourceCropper.WriteChar(Value: AnsiChar);
begin
  if Assigned(FOutStream) then
  begin
    try
      OutStream.Write(Value, SizeOf(Value));
    except
      Exit;
    end;
  end;
end;

{ TCnCPPCropper }

procedure TCnCPPCropper.DoParse;
begin
  FCurChar := GetCurChar;
  while FCurChar <> #0 do
  begin
    case FCurChar of
    '/':
      begin
        if (FCurTokenKind in [skCode, skUndefined]) and (NextChar = '/') then
        begin
          if IsTodoList then
            FCurTokenKind := skTodoList
          else
            FCurTokenKind := skLineComment;
          // ���Ŵ�����β��
          ProcessToLineEnd;
        end
        else
        if (FCurTokenKind in [skCode, skUndefined]) and (NextChar = '*') then
        begin
          // ����Ƿ���TodoList
          if IsTodoList then
            FCurTokenKind := skTodoList
          else if FReserve and IsReserved then  // (NextChar(2) = '#')
            FCurTokenKind := skToReserve
          else
            FCurTokenKind := skBlockComment;
          // ���� '*/'
          ProcessToBlockEnd;
        end
        else
          DoDefaultProcess;
      end;
    '''':
      begin
        if FCurTokenKind in [skCode, skUndefined] then
          FCurTokenKind := skQuoteString
        else if FCurTokenKind = skQuoteString then
           FCurTokenKind := skCode;

        DoDefaultProcess;       
      end;
    '"':
      begin
        if FCurTokenKind in [skCode, skUndefined] then
          FCurTokenKind := skDittoString
        else if FCurTokenKind = skDittoString then
           FCurTokenKind := skCode;

        DoDefaultProcess;
      end;
    else
      DoDefaultProcess;
    end;

    FCurChar := GetCurChar;
  end;
//  WriteChar(#0);
end;

procedure TCnCPPCropper.ProcessToBlockEnd;
begin
  while ((FCurChar <> '*') or (NextChar <> '/')) and (FCurChar <> #0) do
  begin
    DoBlockEndProcess;
    FCurChar := GetCurChar;
  end;

  // ��ʱFCurChar�Ѿ�ָ����'*'�����Һ������'/'��
  if FCurChar = '*' then
  begin
    DoBlockEndProcess;   // д*
    FCurChar := GetCurChar;
    DoBlockEndProcess;   // д/
  end;

  FCurTokenKind := skUndefined;
  // ���ַ��Ѿ�������д����
end;

{ TCnPasCropper }

procedure TCnPasCropper.DoParse;
begin
  FCurChar := GetCurChar;
  while FCurChar <> #0 do
  begin
    case FCurChar of
    '/':
      begin
        if (FCurTokenKind in [skCode, skUndefined]) and (NextChar = '/') then
        begin
          if IsTodoList then
            FCurTokenKind := skTodoList
          else
            FCurTokenKind := skLineComment;
          // ���Ŵ�����β��
          ProcessToLineEnd;
        end
        else
          DoDefaultProcess;
      end;
    '{':
      begin
        if FCurTokenKind in [skCode, skUndefined] then
        begin
          if NextChar <> '$' then
          begin
            // ����Ƿ���TodoList
            if IsTodoList then
              FCurTokenKind := skTodoList
            else if FReserve and IsReserved then      // (NextChar = '*')
              FCurTokenKind := skToReserve
            else
              FCurTokenKind := skBlockComment
          end
          else
            FCurTokenKind := skDirective;
          // ����'}'�š�
          ProcessToBlockEnd;
        end
        else
          DoDefaultProcess;
      end;
    '(':
      begin
        if (FCurTokenKind in [skCode, skUndefined]) and (NextChar = '*') then
        begin
          // ����Ƿ���TodoList
          if IsTodoList then
            FCurTokenKind := skTodoList
          else if NextChar(2) = '$' then
            FCurTokenKind := skDirective
          else
            FCurTokenKind := skBlockComment;
          // ���� '*)'
          ProcessToBracketBlockEnd;
        end
        else
          DoDefaultProcess;
      end;
    '''':
      begin
        if FCurTokenKind in [skCode, skUndefined] then
          FCurTokenKind := skQuoteString
        else if FCurTokenKind = skQuoteString then
           FCurTokenKind := skCode;

        DoDefaultProcess;
      end;
    else
      DoDefaultProcess;
    end;

    FCurChar := GetCurChar;
  end;
//  WriteChar(#0);
end;

procedure TCnPasCropper.ProcessToBlockEnd;
begin
  while not (FCurChar in [#0, '}']) do
  begin
    DoBlockEndProcess;
    FCurChar := GetCurChar;
  end;

  // ��ʱFCurChar�Ѿ�ָ��������'}'��Ҳ�������һ����������ַ�
  DoBlockEndProcess;
  FCurTokenKind := skUndefined;
  // ���ַ��Ѿ�������д����
end;

procedure TCnPasCropper.ProcessToBracketBlockEnd;
begin
  while ((FCurChar <> '*') or (NextChar <> ')')) and (FCurChar <> #0) do
  begin
    DoBlockEndProcess;
    FCurChar := GetCurChar;
  end;

  // ��ʱFCurChar�Ѿ�ָ����'*'�����Һ������')'��
  if FCurChar = '*' then
  begin
    DoBlockEndProcess;   // д*
    FCurChar := GetCurChar;
    DoBlockEndProcess;   // д)
  end;

  FCurTokenKind := skUndefined;
  // ���ַ��Ѿ�������д����
end;

end.
