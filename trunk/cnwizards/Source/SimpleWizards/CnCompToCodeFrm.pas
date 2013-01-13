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

unit CnCompToCodeFrm;
{ |<PRE>
================================================================================
* ������ƣ�CnPack IDE ר�Ұ�
* ��Ԫ���ƣ����ת���뵥Ԫ
* ��Ԫ���ߣ���Х (liuxiao@cnpack.org)
* ��    ע��
* ����ƽ̨��PWinXP SP2 + Delphi 5.01
* ���ݲ��ԣ�PWin9X/2000/XP + Delphi 5/6/7 + C++Builder 5/6
* �� �� �����õ�Ԫ�е��ַ���֧�ֱ��ػ�����ʽ
* ��Ԫ��ʶ��$Id: CnCompToCodeFrm.pas 763 2011-02-07 14:18:23Z liuxiao@cnpack.org $
* �޸ļ�¼��2007.01.31
*               ������Ԫ
================================================================================
|</PRE>}

interface

{$I CnWizards.inc}

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, ExtCtrls, ComCtrls, ToolWin, ActnList, Clipbrd, ToolsAPI, Contnrs,
  TypInfo, CnWizConsts, CnWizMultiLang, CnCommon, CnWizUtils;

type
  TCnCompToCodeForm = class(TCnTranslateForm)
    ToolBar: TToolBar;
    btnRefresh: TToolButton;
    btnSep1: TToolButton;
    btnCopyVar: TToolButton;
    btnCopyImpl: TToolButton;
    btnSep4: TToolButton;
    btnExit: TToolButton;
    btn1: TToolButton;
    pnlVar: TPanel;
    pnlImpl: TPanel;
    spl1: TSplitter;
    mmoImpl: TMemo;
    mmoVar: TMemo;
    lblVar: TLabel;
    lblImpl: TLabel;
    StatusBar1: TStatusBar;
    actlst1: TActionList;
    actRefrseh: TAction;
    actCopyVar: TAction;
    actCopyImpl: TAction;
    btnClear: TToolButton;
    actClear: TAction;
    actHelp: TAction;
    actExit: TAction;
    btnCopyProc: TToolButton;
    actCopyProc: TAction;
    btnHelp: TToolButton;
    procedure actRefrsehExecute(Sender: TObject);
    procedure actClearExecute(Sender: TObject);
    procedure actCopyVarExecute(Sender: TObject);
    procedure actCopyImplExecute(Sender: TObject);
    procedure actHelpExecute(Sender: TObject);
    procedure actExitExecute(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure actCopyProcExecute(Sender: TObject);
    procedure actlst1Update(Action: TBasicAction; var Handled: Boolean);
    procedure FormKeyPress(Sender: TObject; var Key: Char);
  private
    { Private declarations }
    FComps: TComponentList;
    FUniqueComps: TComponentList;
    FPropNames: TStrings;
    FCreates: TStrings;
    FIsPas: Boolean;
    FHasProps: Boolean;
    FCurIsForm: Boolean;
    FSelIsForm: Boolean;
    FFirstComp: Boolean;
    FOwnForm: TComponent;
    FOwnFormName: string;
    FOwnFormClass: string;
    FCurLineNo: Integer;
    FCurLine: string;
    FIndentWidth: Integer;
    procedure ReadOneLine(CompStrs: TStrings);
    function GetReadEof(CompStrs: TStrings): Boolean;
    function GetCppValue(PropNames: TStrings; const PName, PValue: string): string;
    procedure ParseCompText(AComp: TComponent; CompStrs: TStrings);
    {* ����һ object �ַ������������}
    procedure UpdateStatusBar;
    procedure GetPropNames(AComp: TObject; PropNames: TStrings);
    function PropIsType(PName: string; AType: TTypeKind; PropNames: TStrings): Boolean;
  protected
    function GetHelpTopic: string; override;
    procedure DoLanguageChanged(Sender: TObject); override;
  public
    { Public declarations }
    procedure RefreshCode;

    procedure GetComponentStrings(AComp: TComponent; Texts: TStrings);
    procedure ConvertComponents(AComp: TComponent);
    procedure ConvertComponent(AComp: TComponent);
  end;

var
  CnCompToCodeForm: TCnCompToCodeForm = nil;

function ShowCompToCodeForm(): TCnCompToCodeForm;

implementation

{$R *.DFM}

{$IFDEF DEBUG}
uses
  CnDebug;
{$ENDIF}

const
  CreateProcName = 'CreateComponents';

function ShowCompToCodeForm(): TCnCompToCodeForm;
begin
  if CnCompToCodeForm = nil then
    CnCompToCodeForm := TCnCompToCodeForm.Create(nil);
  CnCompToCodeForm.Show;
  CnCompToCodeForm.Update;
  Result := CnCompToCodeForm;
end;

{ TCnCompToCodeForm }

procedure TCnCompToCodeForm.actRefrsehExecute(Sender: TObject);
begin
  RefreshCode;
end;

procedure TCnCompToCodeForm.RefreshCode;
var
  FormEditor: IOTAFormEditor;
  AComp: TComponent;
  SelCount, I, J: Integer;
  AParent: TControl;

  procedure DeleteLastEmpty(List: TStrings);
  var
    K: Integer;
  begin
    for K := List.Count - 1 downto 0 do
    begin
      if Trim(List[K]) = '' then
        List.Delete(K)
      else
        Break;
    end;
  end;

  procedure DeleteFirstEmpty(List: TStrings);
  var
    K, E: Integer;
  begin
    E := 0;
    for K := 0 to List.Count - 1 do
    begin
      if Trim(List[K]) = '' then
        Inc(E)
      else
        Break;
    end;
    for K := 0 to E - 1 do
      List.Delete(0);
  end;

begin
{$IFDEF COMPILER6_UP}
  if BorlandIDEServices = nil then Exit;
  if (BorlandIDEServices as IOTAServices).GetActiveDesignerType = 'nfm' then
  begin
    ErrorDlg(SCnCompToCodeEnvNotSupport);
    Exit;
  end;
{$ENDIF}

  FIsPas := IsDelphiRuntime; // True Ϊ Pascal��False Ϊ C++
  FIndentWidth := CnOtaGetBlockIndent;
{$IFDEF DEBUG}
  CnDebugger.LogInteger(FIndentWidth, 'Editor Indent Width.');
  CnDebugger.LogBoolean(FIsPas, 'Is Pascal.');
{$ENDIF}

  FormEditor := CnOtaGetCurrentFormEditor;
  if FormEditor = nil then Exit;
  actClear.Execute;

{$IFDEF DEBUG}
  CnDebugger.LogMsg('CurrentFormEditor Exists.');
{$ENDIF}

  if FComps = nil then
    FComps := TComponentList.Create(False)
  else
    FComps.Clear;

  if FCreates = nil then
    FCreates := TStringList.Create
  else
    FCreates.Clear;

  // ����ظ������б�
  if FUniqueComps = nil then
    FUniqueComps := TComponentList.Create(False)
  else
    FUniqueComps.Clear;

  // �������ѡ�������� FComps ��ͷ��δѡ��ʹ�ô��屾��
  I := 0;
  SelCount := FormEditor.GetSelCount;
  FSelIsForm := False;
  repeat
    if SelCount = 0 then
    begin
      AComp := TComponent(FormEditor.GetRootComponent.GetComponentHandle);
      FSelIsForm := True;
    end
    else
      AComp := TComponent(FormEditor.GetSelComponent(I).GetComponentHandle);

    if (AComp <> nil) and (FComps.IndexOf(AComp) < 0) then
      FComps.Add(AComp);

    if (SelCount = 1) and (AComp is TCustomForm) or (AComp is TDataModule)  then
      FSelIsForm := True;

    Inc(I);
  until (I >= SelCount);

  FOwnFormClass := TObject(FormEditor.GetRootComponent.GetComponentHandle).ClassName;
  FOwnForm := TComponent(FormEditor.GetRootComponent.GetComponentHandle);
  FOwnFormName := FOwnForm.Name;

{$IFDEF DEBUG}
  CnDebugger.LogMsg('Got All Selected Components in ' + FOwnFormName);
{$ENDIF}
  // ȥ�� Parent �ظ��Ĳ���
  if FComps.Count > 1 then
  begin
    for I := 0 to FComps.Count - 1 do
    begin
      for J := 0 to FComps.Count - 1 do
      begin
        if I <> J then
        begin
          if FComps[I] is TControl then
          begin
            AParent := (FComps[I] as TControl).Parent;
            if (AParent = FComps[J]) and (FComps[J] <> nil) then
              FComps[I] := nil;
          end;
        end;
      end;
    end;

    for I := FComps.Count - 1 downto 0 do
      if FComps[I] = nil then
        FComps.Delete(I);
  end;

{$IFDEF DEBUG}
  CnDebugger.LogInteger(FComps.Count, 'Got All Unique Components.');
{$ENDIF}

  // ��ʼת�ؼ����� Children
  FFirstComp := True;
  for I := 0 to FComps.Count - 1 do
    ConvertComponents(FComps[I]);

  DeleteLastEmpty(mmoVar.Lines);
  DeleteLastEmpty(mmoImpl.Lines);
  DeleteFirstEmpty(mmoImpl.Lines);
  DeleteFirstEmpty(FCreates);
  DeleteLastEmpty(FCreates);
  FCreates.Add('');
  FCreates.AddStrings(mmoImpl.Lines);

  mmoImpl.Lines.Clear;
  mmoImpl.Lines.AddStrings(FCreates);
  UpdateStatusBar;
end;

procedure TCnCompToCodeForm.actClearExecute(Sender: TObject);
begin
  mmoVar.Clear;
  mmoImpl.Clear;
  UpdateStatusBar;
end;

procedure TCnCompToCodeForm.actCopyVarExecute(Sender: TObject);
begin
  Clipboard.AsText := mmoVar.Text;
end;

procedure TCnCompToCodeForm.actCopyImplExecute(Sender: TObject);
begin
  Clipboard.AsText := mmoImpl.Text;
end;

procedure TCnCompToCodeForm.actHelpExecute(Sender: TObject);
begin
  ShowFormHelp;
end;

procedure TCnCompToCodeForm.actExitExecute(Sender: TObject);
begin
  Close;
  Release;
end;

procedure TCnCompToCodeForm.FormDestroy(Sender: TObject);
begin
  FreeAndNil(FComps);
  FreeAndNil(FPropNames);
  FreeAndNil(FUniqueComps);
  CnCompToCodeForm := nil;
end;

procedure TCnCompToCodeForm.ConvertComponent(AComp: TComponent);
var
  CompStrs: TStrings;
begin
  CompStrs := TStringList.Create;
  GetComponentStrings(AComp, CompStrs);

{$IFDEF DEBUG}
  CnDebugger.LogStrings(CompStrs);
{$ENDIF}

  // ���� CompStrs
  FCurLineNo := 0;
  while not GetReadEof(CompStrs) do
  begin
    ReadOneLine(CompStrs);
    if LowerCase(Copy(FCurLine, 1, Length('object'))) = 'object' then
    begin
      // ���������� Component �ˣ���ʼ��������
      ParseCompText(AComp, CompStrs);
    end;
  end;

  CompStrs.Free;
end;

procedure TCnCompToCodeForm.ConvertComponents(AComp: TComponent);
var
  I: Integer;
  CurIsForm: Boolean;
begin
  FCurIsForm := (AComp.Owner = nil) or (AComp is TDataModule);
  // ת�������
  ConvertComponent(AComp);
  // ���� FCurIsForm ����ĸ��ĵ�
  CurIsForm := (AComp.Owner = nil) or (AComp is TDataModule);
  if FSelIsForm and CurIsForm then
  begin
    for I := 0 to AComp.ComponentCount - 1  do
      ConvertComponents(AComp.Components[I]);
  end
  else if AComp is TWinControl then // ת����� Children
    for I := 0 to (AComp as TWinControl).ControlCount - 1 do
      ConvertComponents((AComp as TWinControl).Controls[I]);
end;

procedure TCnCompToCodeForm.GetComponentStrings(AComp: TComponent;
  Texts: TStrings);
var
  Writer: TWriter;
  StreamIn, StreamOut: TStream;
begin
  // �����������������ת�� dfm ��ʽ���ı�
  StreamIn := TMemoryStream.Create;
  StreamOut := nil;
  try
    Writer := TWriter.Create(StreamIn, 4096);
    try
      if (AComp.Owner <> nil) and not (AComp is TDataModule) then
        Writer.Root := AComp.Owner
      else
        Writer.Root := AComp;
        
      Writer.WriteSignature;
      Writer.WriteComponent(AComp);
      Writer.WriteListEnd;
      Writer.WriteListEnd;
    finally
      FreeAndNil(Writer);
    end;
    StreamIn.Position := 0;
    StreamOut := TMemoryStream.Create;
    ObjectBinaryToText(StreamIn, StreamOut);

    Texts.Clear;
    StreamOut.Position := 0;
    Texts.LoadFromStream(StreamOut);
  finally
    StreamIn.Free;
    StreamOut.Free;
  end;
end;

procedure TCnCompToCodeForm.ReadOneLine(CompStrs: TStrings);
begin
  FCurLine := Trim(CompStrs[FCurLineNo]);
  Inc(FCurLineNo);
end;

function TCnCompToCodeForm.GetReadEof(CompStrs: TStrings): Boolean;
begin
  Result := (FCurLineNo >= CompStrs.Count);
end;

procedure TCnCompToCodeForm.ParseCompText(AComp: TComponent; CompStrs: TStrings);
var
  S, Suffix, CreateStr, AName, AClass, AParent, AChild, AOwner: string;
  PName, PValue, PItemClass, PItemName, PItemValue: string;
  ColonPos, EquPos, DotPos, I: Integer;
  AChildComp: TComponent;
  NeedRefreshPropNames: Boolean;
  IsLastLine: Boolean;
  ACollect: TObject;
begin
  if FUniqueComps.IndexOf(AComp) >= 0 then
    Exit;
  // �ظ��򲻴���
  FUniqueComps.Add(AComp);
  NeedRefreshPropNames := False;

  // ��ȡ AComp �������������б�������б����ж������Ƿ���ڡ�������������������� Font.Size
  if FPropNames = nil then
    FPropNames := TStringList.Create
  else
    FPropNames.Clear;

  GetPropNames(AComp, FPropNames);
{$IFDEF DEBUG}
  CnDebugger.LogStrings(FPropNames);
{$ENDIF}

  S := Copy(FCurLine, Length('object') + 2, Length(FCurLine) - Length('object') - 1);
  ColonPos := Pos(':', S);
  if ColonPos > 0 then
  begin
    AClass := Trim(Copy(S, ColonPos + 1, Length(S) - ColonPos));
    AName := Trim(Copy(S, 1, ColonPos - 1));

    // �� var ������
    if FIsPas then
      mmoVar.Lines.Add(Spc(FIndentWidth) + AName + ': ' + AClass + ';')
    else
      mmoVar.Lines.Add(Spc(FIndentWidth) + AClass + '* ' + AName + ';');

    // �� Create �Ĺ���
    if FFirstComp then
    begin
      FCreates.Add('');
      FFirstComp := False;
    end;

    mmoImpl.Lines.Add('');
    FCreates.Add('');
    FCreates.Add(Spc(FIndentWidth) + '//' + AName);
    mmoImpl.Lines.Add(Spc(FIndentWidth) + '//' + AName);
    if FCurIsForm and (AComp.Name = FOwnFormName) then // ����� Form ����
    begin
      if FIsPas then
        FCreates.Add(Spc(FIndentWidth) + AName + ' := ' + AClass + '.Create(Application);')
      else
        FCreates.Add(Spc(FIndentWidth) + AName + ' = new ' + AClass + '(Application);');
    end
    else
    begin
      AOwner := '';
      if FSelIsForm and not FCurIsForm then
        AOwner := FOwnFormName
      else
      begin
        if FIsPas then
          AOwner := 'Self'
        else
          AOwner := 'this'
      end;

      if FIsPas then
        FCreates.Add(Spc(FIndentWidth) + AName + ' := ' + AClass + '.Create(' + AOwner + ');')
      else
        FCreates.Add(Spc(FIndentWidth) + AName + ' = new ' + AClass + '(' + AOwner + ');');
    end;

    // ���� Name ��ֵ
    if FIsPas then
      mmoImpl.Lines.Add(Spc(FIndentWidth) + AName + '.Name := ''' + AComp.Name + ''';')
    else
      mmoImpl.Lines.Add(Spc(FIndentWidth) + AName + '->Name = "' + AComp.Name + '";');

{$IFDEF DEBUG}
    CnDebugger.LogFmt('Comp: %s. FSelIsForm %d, FCurIsForm %d.', [AComp.Name, Integer(FSelIsForm), Integer(FCurIsForm)]);
{$ENDIF}
    // ���� TControl �� Parent ��ֵ
    AParent := '';
    if AComp is TControl then
    begin
      if (AComp as TControl).Parent is TCustomForm then
      begin
        if FSelIsForm and not FCurIsForm then
          AParent := FOwnFormName
        else
        begin
          if FIsPas then
            AParent := 'Self'
          else
            AParent := 'this';
        end;
      end
      else if (AComp as TControl).Parent <> nil then
        AParent := (AComp as TControl).Parent.Name;

      if AParent <> '' then
      begin
        if FIsPas then
          mmoImpl.Lines.Add(Spc(FIndentWidth) + AName + '.Parent := ' + AParent + ';')
        else
          mmoImpl.Lines.Add(Spc(FIndentWidth) + AName + '->Parent = ' + AParent + ';');
      end;

      // ����� TabSheet ��Ҫ���� PageControl ����
      if AComp is TTabSheet then
      begin
        if FIsPas then
          mmoImpl.Lines.Add(Spc(FIndentWidth) + AName + '.PageControl := ' + AParent + ';')
        else
          mmoImpl.Lines.Add(Spc(FIndentWidth) + AName + '->PageControl = ' + AParent + ';');
      end;
    end;

    // ���Ŵ�����������
    while not GetReadEof(CompStrs) do
    begin
      ReadOneLine(CompStrs);
      if LowerCase(FCurLine) = 'end' then Break;

      if LowerCase(Copy(FCurLine, 1, Length('object'))) = 'object' then
      begin
        // ���µ������
        S := Copy(FCurLine, Length('object') + 2, Length(FCurLine) - Length('object') - 1);
        ColonPos := Pos(':', S);
        if ColonPos > 0 then
        begin
          AChild := Trim(Copy(S, 1, ColonPos - 1)); // ����������
          if AComp is TWinControl then
          begin
{$IFDEF DEBUG}
            CnDebugger.LogInteger((AComp as TWinControl).ControlCount, 'Control Count');
{$ENDIF}
            // AChildComp := (AComp as TWinControl).FindChildControl(AChild);
            // FindChildControl ��ʱ�� bug �޷�������ȷֵ��ֻ���ñ����ķ�ʽ�ֹ���Ѱ

            AChildComp := nil;
            for I := 0 to (AComp as TWinControl).ControlCount - 1 do
            begin
              if (AComp as TWinControl).Controls[I].Name = AChild then
              begin
                AChildComp := (AComp as TWinControl).Controls[I];
{$IFDEF DEBUG}
                CnDebugger.LogInteger(I, 'Control Index as AChild');
{$ENDIF}
                Break;
              end;
            end;

            if AChildComp <> nil then // ���ʵ�ʴ��� Child �������ݹ鴦�� Child ���
            begin
              // ���������FPropNames �ᱻ���³�������������б���������־
              NeedRefreshPropNames := True;
              FCurIsForm := False;
              ParseCompText(AChildComp, CompStrs);
            end;
          end
          else if FSelIsForm then // ���� DataModule �����
          begin
            AChildComp := (AComp as TComponent).FindComponent(AChild);
            if AChildComp = nil then // ���� TAction �����
              AChildComp := FOwnForm.FindComponent(AChild);

            if AChildComp <> nil then // ���ʵ�ʴ��� Child �������ݹ鴦�� Child ���
            begin
              // ���������FPropNames �ᱻ���³�������������б���������־
              NeedRefreshPropNames := True;
              FCurIsForm := False;
              ParseCompText(AChildComp, CompStrs);
            end;
          end;
        end;
      end
      else // ������
      begin
        EquPos := Pos('=', FCurLine);
        if EquPos > 0 then
        begin
          // ���»������������б���֤����ÿ������ʱ���е�ǰ����������������б�
          if NeedRefreshPropNames then
          begin
            GetPropNames(AComp, FPropNames);
            NeedRefreshPropNames := False;
          end;

          PName := Trim(Copy(FCurLine, 1, EquPos - 1));
          PValue := Trim(Copy(FCurLine, EquPos + 1, Length(FCurLine) - EquPos));

          // Params �� dfm �л����Ϊ ParamData����������޸�
          if ((AClass = 'TQuery') or (AClass = 'TStoredProc')) and (PName = 'ParamData') then
            PName := 'Params';

          // ע����Ҫͨ�� RTTI �ж����Դ��ڲſɸ�ֵ������ Top �� Left ��������
          if (FHasProps and (FPropNames.IndexOfName(PName) < 0)) and
            (StrRight(PName, Length('.Strings')) <> '.Strings') and
             (StrRight(PName, Length('.Items')) <> '.Items') and
             (PName <> 'Parent') and (PName <> 'PageControl')
            then
            Continue;

          DotPos := Pos('.', FCurLine);
          if DotPos > 0 then // ��ʾ��������ĳ Form.ImageList1 ����������
          begin
            if Copy(PValue, 1, DotPos - 1) = FOwnFormName then // �Ǳ� Form ��ȥ�� Form ��
              PValue := Copy(PValue, DotPos + 1, Length(PValue) - DotPos);
          end;

          if PValue = '{' then // ���Զ���������
          begin
{$IFDEF DEBUG}
            CnDebugger.LogMsg('{} Ignored.');
{$ENDIF}
            if FIsPas then
              mmoImpl.Lines.Add(Spc(FIndentWidth) + '// ' + AName + '.' + PName + ' Ignored.')
            else
              mmoImpl.Lines.Add(Spc(FIndentWidth) + '// ' + AName + '->' + PName + ' Ignored.');

            while not GetReadEof(CompStrs) do
            begin
              ReadOneLine(CompStrs);
              if FCurLine[Length(FCurLine)] = '}' then
                Break;
            end;
          end
          else if PValue = '(' then // �����ַ����б�
          begin
{$IFDEF DEBUG}
            CnDebugger.LogMsg('Strings Comes.');
{$ENDIF}
            // ʹ�� Clear ���� Add �Ĵ��룬��ȥ�����ұߵ� Strings
            if LastDelimiter('.', PName) > 0 then
              PName := Copy(PName, 1, LastDelimiter('.', PName) - 1);

            // ���� Clear �Ĵ���
            mmoImpl.Lines.Add('');
            if FIsPas then
            begin
              if AName = '' then
                mmoImpl.Lines.Add(Spc(FIndentWidth) + PName + '.Clear;')
              else
                mmoImpl.Lines.Add(Spc(FIndentWidth) + AName + '.' + PName + '.Clear;');
            end
            else
            begin
              if AName = '' then
                mmoImpl.Lines.Add(Spc(FIndentWidth) + PName + '->Clear();')
              else
                mmoImpl.Lines.Add(Spc(FIndentWidth) + AName + '->' + PName + '->Clear();');
            end;

            // ѭ��ͨ�� Add �ķ�ʽ�����ַ���
            IsLastLine := False;
            while not GetReadEof(CompStrs) and not IsLastLine do
            begin
              ReadOneLine(CompStrs);
              if (Length(FCurLine) > 2) and (Copy(FCurLine, Length(FCurLine) - 1, 2) = ' +') then
                Delete(FCurLine, Length(FCurLine) - 1, 2)
              else if FCurLine[Length(FCurLine)] = ')' then
              begin
                Delete(FCurLine, Length(FCurLine), 1);
                IsLastLine := True;
              end;

              if FIsPas then
              begin
                if AName = '' then
                  mmoImpl.Lines.Add(Spc(FIndentWidth) + PName + '.Add(' + FCurLine + ');')
                else
                  mmoImpl.Lines.Add(Spc(FIndentWidth) + AName + '.' + PName + '.Add(' + FCurLine + ');');
              end
              else
              begin
                if AName = '' then
                  mmoImpl.Lines.Add(Spc(FIndentWidth) + PName + '->Add(' + FCurLine + ');')
                else
                  mmoImpl.Lines.Add(Spc(FIndentWidth) + AName + '->' + PName + '->Add(' + GetCppValue(FPropNames, PName, FCurLine) + ');');
              end;
            end;
            mmoImpl.Lines.Add('');
          end
          else if PValue = '<' then // ���� Collection Item ����
          begin
{$IFDEF DEBUG}
            CnDebugger.LogMsg('Collection Comes.');
{$ENDIF}
            IsLastLine := False;
            mmoImpl.Lines.Add('');

            if not FIsPas then
            begin
              // Ҫ��ø� Collection ���Ե� CollectionItem �� Classname
              ACollect := GetObjectProp(AComp, PName);
              if (ACollect <> nil) and (ACollect is TCollection) then
              begin
                PItemClass := (ACollect as TCollection).ItemClass.ClassName;
                // ���һ�� Item��Ȼ���� Item �������б�
                if (ACollect as TCollection).Count > 0 then
                  GetPropNames((ACollect as TCollection).Items[0], FPropNames);
              end;
            end;

            while not GetReadEof(CompStrs) and not IsLastLine do
            begin
              ReadOneLine(CompStrs);

              if UpperCase(FCurLine) = 'ITEM' then
              begin
                // �Ӹ� with xxx.Add do <CRLF> begin
                if FIsPas then
                begin
                  if AName = '' then
                    CreateStr := Spc(FIndentWidth) + 'with ' + PName + '.Add do'
                  else
                    CreateStr := Spc(FIndentWidth) + 'with ' + AName + '.' + PName + '.Add do';

                  mmoImpl.Lines.Add(CreateStr);
                  mmoImpl.Lines.Add(Spc(FIndentWidth) + 'begin');
                end
                else // C++ �﷨ʹ�� TCollectionItem* Item = MyCollection->Add();����ʽ
                begin
                  mmoImpl.Lines.Add(Spc(FIndentWidth) + '{');

                  if AName = '' then
                    CreateStr := Spc(FIndentWidth * 2) + PItemClass + '* Item = ' + PName + '->Add();'
                  else
                    CreateStr := Spc(FIndentWidth * 2) + PItemClass + '* Item = ' + AName + '->' +PName + '->Add();';

                  mmoImpl.Lines.Add(CreateStr);
                end;

                while not GetReadEof(CompStrs) do
                begin
                  ReadOneLine(CompStrs);

                  if (UpperCase(FCurLine) = 'END') or (UpperCase(FCurLine) = 'END>') then  // �� Item ����
                  begin
                    if FIsPas then
                    begin
                      mmoImpl.Lines.Add(Spc(FIndentWidth) + 'end;');
                    end
                    else
                    begin
                      mmoImpl.Lines.Add(Spc(FIndentWidth) + '}');
                    end;

                    if FCurLine[Length(FCurLine)] = '>' then
                    begin
                      NeedRefreshPropNames := True;
                      // ���������� Items ���˳����������»�ȡ FPropNames �ı�־
                      Break;
                    end
                    else
                      mmoImpl.Lines.Add('');
                  end
                  else if UpperCase(FCurLine) = 'ITEM' then
                  begin
                    if FIsPas then
                    begin
                      mmoImpl.Lines.Add(CreateStr);
                      mmoImpl.Lines.Add(Spc(FIndentWidth) + 'begin');
                    end
                    else
                    begin
                      mmoImpl.Lines.Add(Spc(FIndentWidth) + '{');
                      mmoImpl.Lines.Add(CreateStr);
                    end;
                  end
                  else // ѭ������� Item �ļ����ԣ�������һ����δ����� Item �������� Collection/Strings �Լ� Object ������
                  begin
                    EquPos := Pos('=', FCurLine);
                    if EquPos > 0 then
                    begin
                      PItemName := Trim(Copy(FCurLine, 1, EquPos - 1));
                      PItemValue := Trim(Copy(FCurLine, EquPos + 1, Length(FCurLine) - EquPos));

                      // �������Ը�ֵ��
                      if FIsPas then
                      begin
                        mmoImpl.Lines.Add(Spc(FIndentWidth * 2) + PItemName + ' := ' + PItemValue + ';')
                      end
                      else
                      begin
                        if FSelIsForm and PropIsType(PName, tkMethod, FPropNames) then
                        begin
                          if FIsPas then
                            PItemValue := FOwnFormName + '.' + PValue
                          else
                            PItemValue := FOwnFormName + '->' + PValue;
                        end;
                        if AName = '' then
                          mmoImpl.Lines.Add(Spc(FIndentWidth * 2) + 'Item->' + StringReplace(PItemName, '.', '->', [rfReplaceAll]) + ' = ' + GetCppValue(FPropNames, PItemName, PItemValue) + ';')
                        else
                          mmoImpl.Lines.Add(Spc(FIndentWidth * 2) + 'Item->' + StringReplace(PItemName, '.', '->', [rfReplaceAll]) + ' = ' + GetCppValue(FPropNames, PItemName, PItemValue) + ';')
                      end;
                    end;
                  end;
                end;
              end; // ������һ�� Item ��Ӧ���������
            end;
          end
          else if PValue = '' then // ��������ַ����б�
          begin
{$IFDEF DEBUG}
            CnDebugger.LogMsg('Multi-line String Comes.');
{$ENDIF}
            // �ȼӸ�ֵ���
            if FIsPas then
              mmoImpl.Lines.Add(Spc(FIndentWidth) + AName + '.' + PName + ' := ')
            else
              mmoImpl.Lines.Add(Spc(FIndentWidth) + AName + '->' + StringReplace(PName, '.', '->', [rfReplaceAll]) + ' = ');

            IsLastLine := False;
            while not GetReadEof(CompStrs) and not IsLastLine do
            begin
              ReadOneLine(CompStrs);
              IsLastLine := FCurLine[Length(FCurLine)] <> '+';
              if IsLastLine then
                Suffix := ';'
              else
                Suffix := '';

              mmoImpl.Lines.Add(Spc(FIndentWidth * 2) + FCurLine + Suffix);
            end;
          end
          else
          begin
            // �����¼������Ը�ֵ��
            if FSelIsForm and PropIsType(PName, tkMethod, FPropNames) then
            begin
              if FIsPas then
                PValue := FOwnFormName + '.' + PValue
              else
                PValue := FOwnFormName + '->' + PValue;
            end;

            if FIsPas then
              mmoImpl.Lines.Add(Spc(FIndentWidth) + AName + '.' + PName + ' := ' + PValue + ';')
            else
              mmoImpl.Lines.Add(Spc(FIndentWidth) + AName + '->' + StringReplace(PName, '.', '->', [rfReplaceAll]) + ' = ' + GetCppValue(FPropNames, PName, PValue) + ';')
          end;
        end;
      end;
    end;
  end;
end;

function TCnCompToCodeForm.GetCppValue(PropNames: TStrings;
  const PName, PValue: string): string;
var
  PType: string;
begin
  Result := PValue;
  if (PValue = 'True') or (PValue = 'False') then
  begin
    Result := LowerCase(PValue);
    Exit;
  end;
  PType := PropNames.Values[PName];

  // ��������
  if (Length(Result) >= 2) or (Pos('#39''', Result) = 1) then
  begin
    if (Pos('#39''', Result) = 1) or (Result[1] = '''') and (Result[Length(Result)] = '''') then
    begin
      Result := StringReplace(Result, '#39''', '''', [rfReplaceAll]);
      Result := Copy(Result, 2, Length(Result) - 2);
      Result := StringReplace(Result, '''''', '''', [rfReplaceAll]);
      Result := StringReplace(Result, '\', '\\', [rfReplaceAll]);
      Result := StringReplace(Result, '"', '\"', [rfReplaceAll]);
      Result := '"' + Result + '"';
    end
    else if (Result[1] = '[') and (Result[Length(Result)] = ']') then
    begin
      if Result = '[]' then
        Result := PType + '()'
      else
      begin
        Result := StringReplace(Result, '[', PType + '() << ', []);
        Result := StringReplace(Result, ', ', ' << ', [rfReplaceAll]);
        Result := StringReplace(Result, ',', ' << ', [rfReplaceAll]);
        Result := StringReplace(Result, ']', '', []);
      end;
    end;
  end;
end;

procedure TCnCompToCodeForm.actCopyProcExecute(Sender: TObject);
var
  S: TStrings;
  ClassPrefix: string;
begin
  if mmoVar.Lines.Text = '' then Exit;

  if FSelIsForm then
    ClassPrefix := ''
  else if FIsPas then
    ClassPrefix := FOwnFormClass + '.'
  else
    ClassPrefix := FOwnFormClass + '::';

  S := TStringList.Create;
  if FIsPas then
  begin
    S.Add('procedure ' + ClassPrefix + CreateProcName + ';');
    S.Add('var');
  end
  else
  begin
    S.Add('void __fastcall ' + ClassPrefix + CreateProcName + '()');
    S.Add('{');
  end;
  S.AddStrings(mmoVar.Lines);

  if FIsPas then
    S.Add('begin')
  else
    S.Add('');

  S.AddStrings(mmoImpl.Lines);
  if FIsPas then
    S.Add('end;')
  else
    S.Add('}');

  Clipboard.AsText := S.Text;
  InfoDlg(Format(SCnCompToCodeProcCopiedFmt, [S[0]]));  
  S.Free;
end;

procedure TCnCompToCodeForm.actlst1Update(Action: TBasicAction;
  var Handled: Boolean);
begin
  Handled := True;
  if (Action = actCopyVar) or (Action = actCopyImpl) or (Action = actCopyProc) then
    (Action as TCustomAction).Enabled := mmoVar.Lines.Text <> '';
end;

function TCnCompToCodeForm.GetHelpTopic: string;
begin
  Result := 'CnAlignSizeConfig';
end;

procedure TCnCompToCodeForm.UpdateStatusBar;
begin
  if Trim(mmoVar.Lines.Text) = '' then
    StatusBar1.SimpleText := ''
  else
    StatusBar1.SimpleText := Format(SCnCompToCodeConvertedFmt, [mmoVar.Lines.Count]);
end;

procedure TCnCompToCodeForm.DoLanguageChanged(Sender: TObject);
begin
  UpdateStatusBar;
end;

procedure TCnCompToCodeForm.GetPropNames(AComp: TObject;
  PropNames: TStrings);
begin
  PropNames.Clear;
  try
    GetAllPropNames(AComp, PropNames, '', True);
    FHasProps := True;
  except
    PropNames.Clear;
    FHasProps := False;
  end;
end;

function TCnCompToCodeForm.PropIsType(PName: string;
  AType: TTypeKind; PropNames: TStrings): Boolean;
var
  I: Integer;
begin
  Result := False;
  if PropNames <> nil then
  begin
    I := PropNames.IndexOfName(PName);
    if I >= 0 then
      Result := Integer(PropNames.Objects[I]) = Integer(AType);
  end;
end;

procedure TCnCompToCodeForm.FormKeyPress(Sender: TObject; var Key: Char);
begin
  if Key = #1 then
  begin
    if mmoImpl.Focused then
      mmoImpl.SelectAll
    else if mmoVar.Focused then
      mmoVar.SelectAll
    else
    begin
      mmoVar.SelectAll;
      mmoImpl.SelectAll;
    end;
  end;
end;

initialization

finalization
  if CnCompToCodeForm <> nil then
    FreeAndNil(CnCompToCodeForm);

end.
