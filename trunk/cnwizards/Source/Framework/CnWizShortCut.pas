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

unit CnWizShortCut;
{* |<PRE>
================================================================================
* ������ƣ�CnPack IDE ר�Ұ�
* ��Ԫ���ƣ�IDE ��ݼ�����͹�����ʵ�ֵ�Ԫ
* ��Ԫ���ߣ��ܾ��� (zjy@cnpack.org)
* ��    ע���õ�ԪΪ CnWizards ��ܵ�һ���֣�ʵ���� IDE ��ݼ��󶨺Ϳ�ݼ��б��
*           ��Ĺ��ܡ��ⲿ�ֹ�����Ҫ�� CnWizMenuAction ר�Ҳ˵���Action ������ʹ
*           �ã���ͨר��Ҳ�ɵ��ÿ�ݼ��������������Լ��Ŀ�ݼ���
*             - �����Ҫ�� IDE ��ע��һ����ݼ���ʹ�� WizShortCutMgr.Add(...) ��
*               ����һ����ݼ�����
*             - ����ʱ���Ŀ�ݼ���������ԣ����������Զ����¡�
*             - ���һ�θ��´������ԣ���ʹ�� BeginUpdate �� EndUpdate ����ֹ���
*               ���£����������� EndUpdate ʱ����һ�Ρ�
*             - ��������Ҫ��ݼ�ʱ������ WizShortCutMgr.Delete(...) ��ɾ��������
*               ��Ҫ�Լ�ȥ�ͷſ�ݼ�����
* ����ƽ̨��PWin2000Pro + Delphi 5.01
* ���ݲ��ԣ�PWin9X/2000/XP + Delphi 5/6/7 + C++Builder 5/6
* �� �� �����õ�Ԫ�е��ַ��������ϱ��ػ�����ʽ
* ��Ԫ��ʶ��$Id: CnWizShortCut.pas 763 2011-02-07 14:18:23Z liuxiao@cnpack.org $
* �޸ļ�¼��2007.05.21 V1.4
*               ȥ�� PushKeyboard ���ã���Ϊ�޸� AddKeyBinding ���������ĳЩ��
*               �ݼ���Ч�����⡣
*           2007.05.10 V1.3
*               ������ε��� PushKeyboard �Ĵ��󣬸�������ܵ�����ʹ�� Alt+G ��
*               �༭������ʧЧ����л Dans �ṩ���������
*           2003.07.31 V1.2
*               ��ݼ���Ϊ������д�����б���
*           2003.06.08 V1.1
*               ��������Ĭ��ֵ����ͬ�Ŀ�ݼ�
*           2002.09.17 V1.0
*               ������Ԫ��ʵ�ֹ���
================================================================================
|</PRE>}

interface

{$I CnWizards.inc}

uses
  Windows, Messages, Classes, SysUtils, Menus, ExtCtrls, ToolsAPI,
  CnWizConsts, CnCommon;

type
//==============================================================================
// IDE ��ݼ�������
//==============================================================================

{ TCnWizShortCut }

  TCnWizShortCutMgr = class;

  TCnWizShortCut = class(TObject)
  {* IDE ��ݼ������࣬�� CnWizards ��ʹ�ã������˿�ݼ������Ժ͹��ܡ�
     ÿһ���������Ŀ�ݼ�ʵ�������Զ��ڴ���ʱ��ע�����ؿ�ݼ��������ͷ�ʱ
     ���б��档�벻Ҫֱ�Ӵ������ͷŸ����ʵ������Ӧ��ʹ�ÿ�ݼ�������
     WizShortCutMgr �� Add �� Delete ������ʵ�֡�}
  private
    FDefShortCut: TShortCut;
    FOwner: TCnWizShortCutMgr;
    FShortCut: TShortCut;
    FKeyProc: TNotifyEvent;
    FMenuName: string;
    FName: string;
    FTag: Integer;
    procedure SetKeyProc(const Value: TNotifyEvent);
    procedure SetShortCut(const Value: TShortCut);
    procedure SetMenuName(const Value: string);
    function ReadShortCut(const Name: string; DefShortCut: TShortCut): TShortCut;
    procedure WriteShortCut(const Name: string; AShortCut: TShortCut);
  protected
    procedure Changed; virtual;
  public
    constructor Create(AOwner: TCnWizShortCutMgr; const AName: string;
      AShortCut: TShortCut; AKeyProc: TNotifyEvent; const AMenuName: string;
      ATag: Integer = 0);
    {* �๹�������벻Ҫֱ�ӵ��ø÷���������ʵ������Ӧ���ÿ�ݼ�������
       WizShortCutMgr.Add ���������������� Delete ��ɾ����}
    destructor Destroy; override;
    {* �����������벻Ҫֱ���ͷŸ����ʵ������Ӧ���ÿ�ݼ�������
       WizShortCutMgr.Delete ��ɾ��һ�� IDE ��ݼ���}

    property Name: string read FName;
    {* ��ݼ������֣�ͬʱҲ�Ǳ�����ע����еļ�ֵ�������Ϊ�գ��ÿ�ݼ�����
       ������ע����С�}
    property ShortCut: TShortCut read FShortCut write SetShortCut;
    {* ��ݼ���ֵ��}
    property KeyProc: TNotifyEvent read FKeyProc write SetKeyProc;
    {* ��ݼ�֪ͨ�¼�������ݼ�������ʱ���ø��¼�}
    property MenuName: string read FMenuName write SetMenuName;
    {* ���ݼ������� IDE �˵��������}
    property Tag: Integer read FTag write FTag;
    {* ��ݼ���ǩ}
  end;

//==============================================================================
// IDE ��ݼ��󶨽ӿ�ʵ����
//==============================================================================

{ TCnKeyBinding }

  TCnKeyBinding = class(TNotifierObject, IOTAKeyboardBinding)
  {* IDE ��ݼ��󶨽ӿ�ʵ���࣬�� CnWizards ���ڲ�ʹ�á�
     ����ʵ���� IOTAKeyboardBinding �ӿڣ��ɱ� IDE �����Զ��� IDE �Ŀ�ݼ��󶨡�
     ������� IDE ��ݼ��������� TCnWizShortCutMgr �ڲ�ʹ�ã��벻Ҫֱ��ʹ�á�}
  private
    FOwner: TCnWizShortCutMgr;
  protected
    procedure KeyProc(const Context: IOTAKeyContext; KeyCode: TShortcut;
      var BindingResult: TKeyBindingResult);
    property Owner: TCnWizShortCutMgr read FOwner;
  public
    constructor Create(AOwner: TCnWizShortCutMgr);
    {* �๹���������� IDE ��ݼ���������Ϊ����}
    destructor Destroy; override;

    // IOTAKeyboardBinding methods
    function GetBindingType: TBindingType;
    {* ȡ�����ͣ�����ʵ�ֵ� IOTAKeyboardBinding ����}
    function GetDisplayName: string;
    {* ȡ��ݼ�����ʾ���ƣ�����ʵ�ֵ� IOTAKeyboardBinding ����}
    function GetName: string;
    {* ȡ��ݼ������ƣ�����ʵ�ֵ� IOTAKeyboardBinding ����}
    procedure BindKeyboard(const BindingServices: IOTAKeyBindingServices);
    {* ��ݼ��󶨹��̣�����ʵ�ֵ� IOTAKeyboardBinding ����}
  end;

//==============================================================================
// IDE ��ݼ���������
//==============================================================================

{ TCnWizShortCutMgr }

  TCnWizShortCutMgr = class(TObject)
  {* IDE ��ݼ��������࣬����ά���� IDE �а󶨵Ŀ�ݼ����б�
     �벻Ҫֱ�Ӵ��������ʵ����Ӧʹ�� WizShortCutMgr ����õ�ǰ�Ĺ�����ʵ����}
  private
    FShortCuts: TList;
    FKeyBindingIndex: Integer;
    FUpdateCount: Integer;
    FUpdated: Boolean;
    FSaveMenus: TList;
    FSaveShortCuts: TList;
    FMenuTimer: TTimer;
    function GetShortCuts(Index: Integer): TCnWizShortCut;
    function GetCount: Integer;
    procedure InstallKeyBinding;
    procedure RemoveKeyBinding;
    procedure SaveMainMenuShortCuts;
    procedure RestoreMainMenuShortCuts;
    procedure DoRestoreMainMenuShortCuts(Sender: TObject);
  public
    constructor Create;
    {* �๹�������벻Ҫֱ�Ӵ��������ʵ����Ӧʹ�� WizShortCutMgr ����õ�ǰ
       �Ĺ�����ʵ����}
    destructor Destroy; override;
    {* ����������}
    function IndexOfShortCut(AWizShortCut: TCnWizShortCut): Integer;
    {* ���� IDE ��ݼ�������������ţ�����Ϊ��ݼ�������������ڷ���-1��}
    function IndexOfName(const AName: string): Integer; 
    {* ���ݿ�ݼ����Ʋ��������ţ���������ڷ���-1��}
    function Add(const AName: string; AShortCut: TShortCut; AKeyProc:
      TNotifyEvent; const AMenuName: string = ''; ATag: Integer = 0): TCnWizShortCut;
    {* ����һ����ݼ�����
     |<PRE>
       AName: string           - ��ݼ����ƣ����Ϊ�մ���ÿ�ݼ������浽ע�����
       AShortCut: TShortCut    - ��ݼ�Ĭ�ϼ�ֵ����� AName ��Ч��ʵ��ʹ�õļ�ֵ�Ǵ�ע����ж�ȡ��
       AKeyProc: TNotifyEvent  - ��ݼ�֪ͨ�¼�
       AMenuName: string       - ��ݼ���Ӧ�� IDE ���˵���������û�п���Ϊ��
       Result: Integer;        - ���������ӵĿ�ݼ������ţ����Ҫ����Ŀ�ݼ��Ѵ��ڷ���-1
     |</PRE>}
    procedure Delete(Index: Integer);
    {* ɾ��һ����ݼ����󣬲���Ϊ��ݼ�����������š�}
    procedure DeleteShortCut(var AWizShortCut: TCnWizShortCut); 
    {* ɾ��һ����ݼ����󣬲���Ϊ��ݼ����󣬵��óɹ����������Ϊ nil��}
    procedure Clear;
    {* ��տ�ݼ������б�}
    procedure BeginUpdate;
    {* ��ʼ���¿�ݼ������б��ڴ�֮��Կ�ݼ��б�ĸĶ��������Զ����а�ˢ�£�
       ֻ�е����½�����Ż��Զ����°󶨡�
       ʹ��ʱ������ EndUpdate ��ԡ�}
    procedure EndUpdate;
    {* �����Կ�ݼ������б�ĸ��£���������һ�ε��ã����Զ����°� IDE ��ݼ���
       ʹ��ʱ������ BeginUpdate ��ԡ�}
    function Updating: Boolean;
    {* ��ݼ������б����״̬���� BeginUpdate �� EndUpdate}
    procedure UpdateBinding;
    {* �����Ѱ󶨵Ŀ�ݼ������б�}

    property Count: Integer read GetCount;
    {* ��ݼ�����������}
    property ShortCuts[Index: Integer]: TCnWizShortCut read GetShortCuts;
    {* ��ݼ���������}
  end;

function WizShortCutMgr: TCnWizShortCutMgr;
{* ���ص�ǰ�� IDE ��ݼ�������ʵ���������Ҫʹ�ÿ�ݼ����������벻Ҫֱ�Ӵ���
   TCnWizShortCutMgr ��ʵ������Ӧ���øú��������ʡ�}

procedure FreeWizShortCutMgr;
{* �ͷ� IDE ��ݼ�������ʵ��}

implementation

uses
{$IFDEF Debug}
  CnDebug,
{$ENDIF Debug}
  IniFiles, Registry, CnWizUtils, CnWizOptions;

const
  csInvalidIndex = -1;

//==============================================================================
// IDE ��ݼ�������
//==============================================================================

{ TCnWizShortCut }

// ��ݼ������ѱ����֪ͨ���������°�
procedure TCnWizShortCut.Changed;
begin
{$IFDEF Debug}
  CnDebugger.LogFmt('TCnWizShortCut.Changed: %s', [Name]);
{$ENDIF Debug}
  if FOwner <> nil then
    FOwner.UpdateBinding;
end;

// �๹����
constructor TCnWizShortCut.Create(AOwner: TCnWizShortCutMgr;
  const AName: string; AShortCut: TShortCut; AKeyProc: TNotifyEvent;
  const AMenuName: string; ATag: Integer);
begin
  inherited Create;
  FOwner := AOwner;
  FName := AName;
  FDefShortCut := AShortCut;
  FShortCut := ReadShortCut(FName, AShortCut); // ��ע����ж�ȡʵ��ʹ�õļ�ֵ
  FKeyProc := AKeyProc;
  FMenuName := AMenuName;
  FTag := ATag;
end;

// ��������
destructor TCnWizShortCut.Destroy;
begin
  FOwner := nil;
  FKeyProc := nil;
  inherited;
end;

// ��ע����ȡһ����ݼ��ı���ֵ
function TCnWizShortCut.ReadShortCut(const Name: string; DefShortCut: TShortCut):
  TShortCut;
begin
  Result := DefShortCut;
  if Name = '' then Exit;

  with WizOptions.CreateRegIniFile do
  try
    if ValueExists(SCnShortCutsSection, Name) then
    begin
      if ReadInteger(SCnShortCutsSection, Name, -1) <> -1 then
        Result := ReadInteger(SCnShortCutsSection, Name, DefShortCut)
      else  // ���ݾɵ��ı���ʽ��ݼ�
        Result := TextToShortCut(ReadString(SCnShortCutsSection, Name,
          ShortCutToText(DefShortCut)));
    end;
  finally
    Free;
  end;
end;

// ����һ����ݼ���ע���
procedure TCnWizShortCut.WriteShortCut(const Name: string; AShortCut: TShortCut);
begin
  if Name = '' then Exit;
  
  with WizOptions.CreateRegIniFile do 
  try
    DeleteKey(SCnShortCutsSection, Name);
    if AShortCut <> FDefShortCut then  // ��������Ĭ��ֵ����ͬ�Ŀ�ݼ�
      WriteInteger(SCnShortCutsSection, Name, AShortCut);
  finally
    Free;
  end;
end;

//------------------------------------------------------------------------------
// ���Զ�д����
//------------------------------------------------------------------------------

// KeyProc ����д����
procedure TCnWizShortCut.SetKeyProc(const Value: TNotifyEvent);
begin
  if not SameMethod(TMethod(FKeyProc), TMethod(Value)) then
  begin
    FKeyProc := Value;
    Changed;
  end;
end;

// MenuName ����д����
procedure TCnWizShortCut.SetMenuName(const Value: string);
begin
  if FMenuName <> Value then
  begin
    FMenuName := Value;
    Changed;
  end;
end;

// ShortCut ����д����
procedure TCnWizShortCut.SetShortCut(const Value: TShortCut);
begin
  if FShortCut <> Value then
  begin
    FShortCut := Value;
    // ���ÿ�ݼ�ʱͬʱ���棬���� IDE �쳣�ر�ʱ��ʧ����
    WriteShortCut(FName, FShortCut);
    Changed;
  end;
end;

//==============================================================================
// IDE ��ݼ��󶨽ӿ�ʵ����
//==============================================================================

{ TCnKeyBinding }

// �๹����
constructor TCnKeyBinding.Create(AOwner: TCnWizShortCutMgr);
begin
  inherited Create;
  FOwner := AOwner;
end;

// ��������
destructor TCnKeyBinding.Destroy;
begin
  FOwner := nil;
  inherited;
end;

// ��ݼ�֪ͨ�¼��ַ�����
procedure TCnKeyBinding.KeyProc(const Context: IOTAKeyContext;
  KeyCode: TShortcut; var BindingResult: TKeyBindingResult);
begin
{$IFDEF Debug}
  CnDebugger.LogFmt('TCnKeyBinding.KeyProc, KeyCode: %s', [ShortCutToText(KeyCode)]);
  CnDebugger.LogMsg('Call: ' + TCnWizShortCut(Context.GetContext).Name);
{$ENDIF Debug}
  // ע���ݼ�ʱ�ѽ���ݼ����󴫵ݸ�������
  if Assigned(TCnWizShortCut(Context.GetContext).KeyProc) then
    TCnWizShortCut(Context.GetContext).KeyProc(TObject(Context.GetContext))
  else
  begin
  {$IFDEF Debug}
    CnDebugger.LogMsgWithType('KeyProc is nil', cmtWarning);
  {$ENDIF Debug}
  end;
  BindingResult := krHandled; // �������¼��ѱ��������
end;

//------------------------------------------------------------------------------
// ����ʵ�ֵ� IOTAKeyboardBinding ����
//------------------------------------------------------------------------------

{ TCnKeyBinding.IOTAKeyboardBinding }

// ȡ������
function TCnKeyBinding.GetBindingType: TBindingType;
begin
  Result := btPartial;
end;

// ��ݼ��󶨹���
procedure TCnKeyBinding.BindKeyboard(
  const BindingServices: IOTAKeyBindingServices);
var
  i: Integer;
  KeyboardName: string;
begin
{$IFDEF COMPILER7_UP}
  KeyboardName := '';
{$ELSE}
  KeyboardName := SCnKeyBindingName;
{$ENDIF}
{$IFDEF Debug}
  CnDebugger.LogFmt('TCnKeyBinding.BindKeyboard, Count: %d', [Owner.Count]);
{$ENDIF Debug}
  // ע���ݼ�ʱ����ݼ����󴫵ݸ�������
  for i := 0 to Owner.Count - 1 do
    if Owner.ShortCuts[i].ShortCut <> 0 then
      BindingServices.AddKeyBinding([Owner.ShortCuts[i].ShortCut], KeyProc,
        Owner.ShortCuts[i], kfImplicitShift or kfImplicitModifier or
        kfImplicitKeypad, KeyboardName, Owner.ShortCuts[i].MenuName);
end;

// ȡ��ݼ�����ʾ����
function TCnKeyBinding.GetDisplayName: string;
begin
  Result := SCnKeyBindingDispName;
end;

// ȡ��ݼ�������
function TCnKeyBinding.GetName: string;
begin
  Result := SCnKeyBindingName;
end;

//==============================================================================
// IDE ��ݼ���������
//==============================================================================

{ TCnWizShortCutMgr }

// �๹����
constructor TCnWizShortCutMgr.Create;
begin
{$IFDEF Debug}
  CnDebugger.LogEnter('TCnWizShortCutMgr.Create');
{$ENDIF Debug}

  inherited;
  FShortCuts := TList.Create;
  FUpdateCount := 0;
  FUpdated := False;
  FKeyBindingIndex := csInvalidIndex;

  FSaveMenus := TList.Create;
  FSaveShortCuts := TList.Create;

{$IFDEF Debug}
  CnDebugger.LogLeave('TCnWizShortCutMgr.Create');
{$ENDIF Debug}
end;

// ��������
destructor TCnWizShortCutMgr.Destroy;
begin
{$IFDEF Debug}
  CnDebugger.LogEnter('TCnWizShortCutMgr.Destroy');
  if Count > 0 then
    CnDebugger.LogFmtWithType('WizShortCutMgr.Count = %d', [Count], cmtWarning);
{$ENDIF Debug}

  Clear;
  FSaveMenus.Free;
  FSaveShortCuts.Free;
  FShortCuts.Free;
  if Assigned(FMenuTimer) then FMenuTimer.Free;
  inherited;
  
{$IFDEF Debug}
  CnDebugger.LogLeave('TCnWizShortCutMgr.Destroy');
{$ENDIF Debug}
end;

//------------------------------------------------------------------------------
// ���¿��Ʒ���
//------------------------------------------------------------------------------

// ��ʼ���¿�ݼ��б����
procedure TCnWizShortCutMgr.BeginUpdate;
begin
  if not Updating then
    FUpdated := False;
  Inc(FUpdateCount);
end;

// ��������
procedure TCnWizShortCutMgr.EndUpdate;
begin
  Dec(FUpdateCount);
  if not Updating and FUpdated then
  begin
    UpdateBinding; // ����������°�
    FUpdated := False;
  end;
end;

// ȡ��ǰ�ĸ���״̬
function TCnWizShortCutMgr.Updating: Boolean;
begin
  Result := FUpdateCount > 0;
end;

//------------------------------------------------------------------------------
// �б���Ŀ����
//------------------------------------------------------------------------------

// ����һ����ݼ����壬���ؿ�ݼ�����ʵ��
function TCnWizShortCutMgr.Add(const AName: string; AShortCut: TShortCut;
  AKeyProc: TNotifyEvent; const AMenuName: string; ATag: Integer): TCnWizShortCut;
begin
{$IFDEF Debug}
  CnDebugger.LogFmt('TCnWizShortCutMgr.Add: %s (%s)', [AName,
    ShortCutToText(AShortCut)]);
{$ENDIF Debug}
  if IndexOfName(AName) >= 0 then // ���������Ϊ�������
    raise ECnDuplicateShortCutName.CreateFmt(SCnDuplicateShortCutName, [AName]);
  Result := TCnWizShortCut.Create(Self, AName, AShortCut, AKeyProc, AMenuName, ATag);
  FShortCuts.Add(Result);
  if Result.FShortCut <> 0 then   // ���ڿ�ݼ�ʱ�����°�
    UpdateBinding;
end;

// ɾ��ָ�������ŵĿ�ݼ�����
procedure TCnWizShortCutMgr.Delete(Index: Integer);
var
  NeedUpdate: Boolean;
begin
  if (Index >= 0) and (Index <= Count - 1) then
  begin
  {$IFDEF Debug}
    CnDebugger.LogFmt('TCnWizShortCutMgr.Delete(%d): %s', [Index,
      ShortCuts[Index].Name]);
  {$ENDIF Debug}
    NeedUpdate := ShortCuts[Index].FShortCut <> 0;
    ShortCuts[Index].Free;
    FShortCuts.Delete(Index);
    if NeedUpdate then           // ���ڿ�ݼ�ʱ�����°�
      UpdateBinding;
  end;
end;

// ɾ��ָ���Ŀ�ݼ�����
procedure TCnWizShortCutMgr.DeleteShortCut(var AWizShortCut: TCnWizShortCut);
begin
  Delete(IndexOfShortCut(AWizShortCut));
  AWizShortCut := nil;
end;

// ��տ�ݼ������б�
procedure TCnWizShortCutMgr.Clear;
begin
  while Count > 0 do
  begin
    ShortCuts[0].Free;
    FShortCuts.Delete(0);
  end;
  
  RemoveKeyBinding;
end;

// ȡ��ݼ����ƶ�Ӧ��������
function TCnWizShortCutMgr.IndexOfName(const AName: string): Integer;
var
  i: Integer;
begin
  Result := -1;
  if AName = '' then Exit;
  for i := 0 to Count - 1 do
    if ShortCuts[i].Name = AName then
    begin
      Result := i;
      Exit;
    end;
end;

// ȡ��ݼ������Ӧ��������
function TCnWizShortCutMgr.IndexOfShortCut(AWizShortCut: TCnWizShortCut): 
    Integer;
var
  i: Integer;
begin
  Result := -1;
  for i := 0 to Count - 1 do
    if ShortCuts[i] = AWizShortCut then
    begin
      Result := i;
      Exit;
    end;
end;

//------------------------------------------------------------------------------
// ���̰���ط���
//------------------------------------------------------------------------------

// ĳЩ���ڵ�ר�ң��� DelForEx û��ʹ�� OTA �ļ��̰���֧�ֿ�ݼ�������ʹ��
// ��ʱ���� IDE ���������ò˵���Ŀ�ݼ���ע�ᡣ�������°󶨼���ʱ�����ܵ���
// �����ݼ�ʧЧ���˴��Ƚ��б��棬ע����ɺ��ٻָ����ָ�ʱʹ�ö�ʱ����ʱ��

procedure TCnWizShortCutMgr.DoRestoreMainMenuShortCuts(Sender: TObject);
var
  i: Integer;
begin
  FreeAndNil(FMenuTimer);

  for i := 0 to FSaveMenus.Count - 1 do
  begin
    TMenuItem(FSaveMenus[i]).ShortCut := TShortCut(FSaveShortCuts[i]);
  {$IFDEF Debug}
    CnDebugger.LogMsg(Format('MenuItem ShortCut Restored: %s (%s)',
      [TMenuItem(FSaveMenus[i]).Caption, ShortCutToText(TShortCut(FSaveShortCuts[i]))]));
  {$ENDIF Debug}
  end;

  FSaveMenus.Clear;
  FSaveShortCuts.Clear;
end;

procedure TCnWizShortCutMgr.RestoreMainMenuShortCuts;
begin
  if FMenuTimer = nil then
  begin
    FMenuTimer := TTimer.Create(nil);
    FMenuTimer.Interval := 1000;
    FMenuTimer.OnTimer := DoRestoreMainMenuShortCuts;
  end;
  FMenuTimer.Enabled := False;
  FMenuTimer.Enabled := True;
end;

procedure TCnWizShortCutMgr.SaveMainMenuShortCuts;
var
  Svcs40: INTAServices40;
  MainMenu: TMainMenu;

  procedure DoSaveMenu(MenuItem: TMenuItem);
  var
    i: Integer;
  begin
    if (MenuItem.Action = nil) and (MenuItem.ShortCut <> 0) then
    begin
      FSaveMenus.Add(MenuItem);
      FSaveShortCuts.Add(Pointer(MenuItem.ShortCut));
    {$IFDEF Debug}
      //CnDebugger.LogMsg(Format('MenuItem ShortCut Saved: %s (%s)',
      //  [MenuItem.Caption, ShortCutToText(MenuItem.ShortCut)]));
    {$ENDIF Debug}
    end;
    
    for i := 0 to MenuItem.Count - 1 do
      DoSaveMenu(MenuItem.Items[i]);
  end;
begin
  FSaveMenus.Clear;
  FSaveShortCuts.Clear;
  QuerySvcs(BorlandIDEServices, INTAServices40, Svcs40);
  MainMenu := Svcs40.MainMenu;
  DoSaveMenu(MainMenu.Items);
end;

// ��װ���̰�
procedure TCnWizShortCutMgr.InstallKeyBinding;
var
  KeySvcs: IOTAKeyboardServices;
  i: Integer;
  IsEmpty: Boolean;
begin
  Assert(FKeyBindingIndex = csInvalidIndex);
  IsEmpty := True;
  for i := 0 to Count - 1 do    // �ж��Ƿ���ڿ�ݼ�
    if ShortCuts[i].FShortCut <> 0 then
    begin
      IsEmpty := False;
      Break;
    end;
  if not IsEmpty then
  begin
    QuerySvcs(BorlandIDEServices, IOTAKeyboardServices, KeySvcs);
    SaveMainMenuShortCuts;
    try
      try
        FKeyBindingIndex := KeySvcs.AddKeyboardBinding(TCnKeyBinding.Create(Self));
      {$IFNDEF COMPILER7_UP}
        // todo: Delphi 5/6 �²����� PushKeyboard �ᵼ��ĳЩ��ݼ�ʧЧ
        // �����ֻᵼ�°� Alt+G �����ʧЧ����ʱ�ȵ���
        KeySvcs.PushKeyboard(SCnKeyBindingName);
      {$ENDIF}
      except
        ;
      end;
    finally
      RestoreMainMenuShortCuts;
    end;
  end;
end;

// ����װ���̰�
procedure TCnWizShortCutMgr.RemoveKeyBinding;
var
  KeySvcs: IOTAKeyboardServices;
begin
  if FKeyBindingIndex <> csInvalidIndex then
  begin
    SaveMainMenuShortCuts;
    try
      QuerySvcs(BorlandIDEServices, IOTAKeyboardServices, KeySvcs);
    {$IFNDEF COMPILER7_UP}
      KeySvcs.PopKeyboard(SCnKeyBindingName);
    {$ENDIF}
      KeySvcs.RemoveKeyboardBinding(FKeyBindingIndex);
      FKeyBindingIndex := csInvalidIndex;
    finally
      RestoreMainMenuShortCuts;
    end;
  end;
end;

// ���� IDE ��ݼ���
procedure TCnWizShortCutMgr.UpdateBinding;
begin
  if Updating then
  begin
    FUpdated := True;
    Exit;
  end;
  
  if IdeClosing then
    Exit;

{$IFDEF Debug}
  CnDebugger.LogMsg('TCnWizShortCutMgr.UpdateBinding');
{$ENDIF Debug}
  RemoveKeyBinding;
{$IFDEF Debug}
  CnDebugger.LogMsg('RemoveKeyBinding succeed');
{$ENDIF Debug}
  InstallKeyBinding;
{$IFDEF Debug}
  CnDebugger.LogMsg('InstallKeyBinding succeed');
{$ENDIF Debug}
end;

//------------------------------------------------------------------------------
// ���Զ�д����
//------------------------------------------------------------------------------

// Count ���Զ�����
function TCnWizShortCutMgr.GetCount: Integer;
begin
  Result := FShortCuts.Count;
end;

// ShortCuts �������Զ�����
function TCnWizShortCutMgr.GetShortCuts(Index: Integer): TCnWizShortCut;
begin
  Result := nil; // ����Խ�緵�ؿ�ָ��
  if (Index >= 0) and (Index <= Count - 1) then
    Result := TCnWizShortCut(FShortCuts[Index]);
end;

var
  FWizShortCutMgr: TCnWizShortCutMgr = nil;

// ���ص�ǰ�� IDE ��ݼ�������ʵ��
function WizShortCutMgr: TCnWizShortCutMgr;
begin
  if FWizShortCutMgr = nil then
    FWizShortCutMgr := TCnWizShortCutMgr.Create;
  Result := FWizShortCutMgr;
end;

// �ͷ� IDE ��ݼ�������ʵ��
procedure FreeWizShortCutMgr;
begin
  if FWizShortCutMgr <> nil then
    FreeAndNil(FWizShortCutMgr);
end;

end.
