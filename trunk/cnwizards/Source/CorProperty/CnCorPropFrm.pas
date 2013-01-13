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

unit CnCorPropFrm;
{* |<PRE>
================================================================================
* ������ƣ�CnPack IDE ר�Ұ�
* ��Ԫ���ƣ������޸�ר�������浥Ԫ
* ��Ԫ���ߣ���ʡ(hubdog) hubdog@263.net
*           ��Х(LiuXiao) liuxiao@cnpack.org
* ��    ע�������޸�ר�������浥Ԫ
* ����ƽ̨��PWin2000Pro + Delphi 5.01
* ���ݲ��ԣ�PWin2000 + Delphi 5
* �� �� �����õ�Ԫ�е��ַ��������ϱ��ػ�����ʽ
* ��Ԫ��ʶ��$Id: CnCorPropFrm.pas 961 2011-07-31 08:32:24Z liuxiaoshanzhashu@gmail.com $
* �޸ļ�¼��2004.09.08 V1.3 by LiuXiao
*               ���Ӵ������д� Form ��ѡ��
*           2003.09.28 V1.2 by ����
*               ��������ɾ���Ѿ��޸ĵĿؼ�������˫����λ���ÿؼ�ʱ�����쳣
*           2003.06.06 V1.1 by �ܾ���
*               ������������ƥ������������Ч����
*           2003.05.17 V1.0 by LiuXiao
*               ������Ԫ
================================================================================
|</PRE>}

interface

{$I CnWizards.inc}

{$IFDEF CNWIZARDS_CNCORPROPWIZARD}

uses
  Windows, Messages, SysUtils, Classes, CnWizConsts, Menus, ImgList,
  Controls, ActnList, ComCtrls, StdCtrls, ExtCtrls, CnCommon,
  Graphics, Forms, Dialogs, CnCorPropWizard, contnrs, ToolsApi, TypInfo,
  {$IFDEF COMPILER5}Dsgnintf, {$ELSE}DesignIntf, Variants, {$ENDIF}
  CnConsts, CnWizManager, CnWizUtils, CnWizIdeUtils, CnLangMgr, CnWizMultiLang,
  CnPopupMenu;

type
  //������Ŀ
  TCorrectItem = class(TPersistent)
  private
    FCorrComp: TComponent;
    FFileName: string;
    FPropDef: TCnPropDef;
    FPropName: string;
    FOldValue: string;
    procedure SetCorrComp(const Value: TComponent);
    procedure SetFileName(const Value: string);
    procedure SetPropDef(const Value: TCnPropDef);
    procedure SetPropName(const Value: string);
    procedure SetOldValue(const Value: string);
  published
    property FileName: string read FFileName write SetFileName;
    property CorrComp: TComponent read FCorrComp write SetCorrComp;
    property PropDef: TCnPropDef read FPropDef write SetPropDef;
    property PropName: string read FPropName write SetPropName;
    property OldValue: string read FOldValue write SetOldValue;
  end;

  TCorrectRange=(crCurrent, crOpened, crProject, crGroup);

  TCnCorPropForm = class(TCnTranslateForm)
    GroupBox1: TGroupBox;
    rbProject: TRadioButton;
    rbForm: TRadioButton;
    rbGroup: TRadioButton;
    btnFind: TButton;
    btnClose: TButton;
    btnConfig: TButton;
    btnHelp: TButton;
    ActionList: TActionList;
    actCorrect: TAction;
    actLocateComp: TAction;
    actCorrectComp: TAction;
    ilImageList1: TImageList;
    pmResult: TPopupMenu;
    LocateComponent1: TMenuItem;
    CorrectPropertyValue1: TMenuItem;
    btnAll: TButton;
    actUndoCorrect: TAction;
    U1: TMenuItem;
    btnUndo: TButton;
    grpResult: TGroupBox;
    lvResult: TListView;
    rbOpened: TRadioButton;
    procedure actCorrectExecute(Sender: TObject);
    procedure btnConfigClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure actCorrectCompUpdate(Sender: TObject);
    procedure actLocateCompUpdate(Sender: TObject);
    procedure actCorrectCompExecute(Sender: TObject);
    procedure actLocateCompExecute(Sender: TObject);
    procedure btnCloseClick(Sender: TObject);
    procedure btnHelpClick(Sender: TObject);
    procedure FormActivate(Sender: TObject);
    procedure lvResultDblClick(Sender: TObject);
    procedure btnAllClick(Sender: TObject);
    procedure actUndoCorrectUpdate(Sender: TObject);
    procedure actUndoCorrectExecute(Sender: TObject);
  private
    FPropDefList: TObjectList;
    FCorrectItemList: TObjectList;
    FHasForm: Boolean;
    procedure SetPropDefList(const Value: TObjectList);
    //���������ԵĽ����ӵ�ListView�У������Ƿ��޸�
    function CorrectProp(FileName: string; AComp: IOTAComponent): Boolean;
    function ValidateProp(APropDef: TCnPropDef; AValue: Variant;
      PropInfo: PPropInfo): Boolean;
    procedure AddCorrItem(AItem: TCorrectItem);
    procedure SetCorrectItemList(const Value: TObjectList); //���������Ŀ
    procedure ClearItems;
    procedure UpdateView;
    function GetCorrectRange: TCorrectRange;
    procedure SetCorrectRange(const Value: TCorrectRange);
    { Private declarations }
  protected
    function GetHelpTopic: string; override;
    procedure DoLanguageChanged(Sender: TObject); override;
  public
    { Public declarations }
    procedure CorrectGroup;//������Ŀ���е�ȫ���Ĵ���
    procedure CorrectProject(Project:IOTAProject); //������Ŀ�е�ȫ������
    procedure CorrectCurrentForm; //���µ�ǰ����
    procedure CorrectOpenedForm; // �������д򿪴���
    procedure CorrectModule(Module: IOTAModule); //����ģ��
    property CorrectItemList: TObjectList read FCorrectItemList write
      SetCorrectItemList; //������Ŀ�б�
    property PropDefList: TObjectList read FPropDefList write SetPropDefList;
    property CorrectRange:TCorrectRange read GetCorrectRange write SetCorrectRange;
    //���޸�ȫ��������ֻ�ǵ�ǰ
  end;

  TValueType = (vtInt, vtFloat, vtIdent, vtObject, vtOther);

{$ENDIF CNWIZARDS_CNCORPROPWIZARD}

implementation

{$IFDEF CNWIZARDS_CNCORPROPWIZARD}

uses
{$IFDEF DEBUG}
  CnDebug,
{$ENDIF}
  CnCorPropCfgFrm;

{$R *.DFM}

{ TCnFormCorProp }

procedure TCnCorPropForm.SetPropDefList(const Value: TObjectList);
begin
  FPropDefList := Value;
end;

procedure TCnCorPropForm.actCorrectExecute(Sender: TObject);
begin
  BeginWait;
  try
    //���
    Assert(FPropDefList <> nil);
    ClearItems;
    //�ж��Ǹ�������Project���ǵ���ֻ�ǵ�ǰ����
    FHasForm := True;
    case CorrectRange of
      crCurrent:
        begin
          if not rbForm.Enabled then Exit;
          CorrectCurrentForm;
        end;
      crOpened:
        begin
          if not rbOpened.Enabled then Exit;
          CorrectOpenedForm;
        end;
      crProject:
        begin
          if not rbProject.Enabled then Exit;
          CorrectProject(CnOtaGetCurrentProject);
        end;
      crGroup:
        begin
          if not rbGroup.Enabled then Exit;
          CorrectGroup;
        end;
    end;

    if FCorrectItemList.Count > 0 then
      UpdateView //������ͼ
    else if (CorrectRange in [crProject, crGroup]) or not FHasForm then
      ErrorDlg(SCnCorrectPropertyErrNoResult);
  finally
    EndWait;
  end;
end;

function TCnCorPropForm.CorrectProp(FileName: string; AComp: IOTAComponent): Boolean;
var
  NTAComp: INTAComponent;
  ANTAComp: TComponent;
  L: Integer;
  APropDef: TCnPropDef;
  PropName: string;
  V: Variant;
  AValue: Variant;
  AItem: TCorrectItem;
  PropInfo: PPropInfo;
  ClassType: TClass;
begin
  Result := False;
  NTAComp := AComp as INTAComponent;
  ANTAComp := NTAComp.GetComponent;

  for L := 0 to PropDefList.Count - 1 do
  begin
    APropDef := TCnPropDef(PropDefList.Items[L]);
    if not APropDef.Active then
      Continue;

    // �ж������Ƿ�ƥ��
    ClassType := ANTAComp.ClassType;
    while ClassType <> nil do
      if SameText(ClassType.ClassName, APropDef.CompName) then
        Break
      else
        ClassType := ClassType.ClassParent;

    if ClassType = nil then
      Continue;

    PropName := APropDef.PropName;
    PropInfo := GetPropInfoIncludeSub(ANTAComp, PropName);
    if PropInfo = nil then
      Continue;

    // ���ÿؼ����޸����������Ҽ���Ƿ���Font.Color�����ļ������ԡ�
    AValue := GetPropValueIncludeSub(ANTAComp, PropName);
    // ������ Nil ֵʱ GetPropValueIncludeSub ���� 0��������ֵ
    if (PropInfo^.PropType^.Kind = tkClass) and (VarToStr(AValue) = '0') then
      AValue := '';

  {$IFDEF DEBUG}
    CnDebugger.LogMsg('AValue: ' + VarToStr(AValue));
  {$ENDIF}

    if not ValidateProp(APropDef, AValue, PropInfo) then
      Continue;

    if APropDef.Action = paCorrect then // �Զ�����
    begin
      V := APropDef.ToValue;
      SetPropValueIncludeSub(ANTAComp, PropName, V, ANTAComp.Owner);
      Result := True;
    end;
    //��ӵ����������б�

    AItem := TCorrectItem.Create;
    AItem.FileName := FileName;
    AItem.PropDef := APropDef;
    AItem.PropName := PropName;
    AItem.CorrComp := ANTAComp;
    AItem.OldValue := AValue;

    AddCorrItem(AItem);
  end;
end;

//��������Ƿ���������
function TCnCorPropForm.ValidateProp(APropDef: TCnPropDef;
  AValue: Variant; PropInfo: PPropInfo): Boolean;
var
  I1, I2: integer;
  F1, F2: double;
  S1, S2: string;
  ValueType: TValueType;
  IdToInt: TIdentToInt;
begin
  Result := False;
  I1 := 0; I2 := 0; F1 := 0.0; F2 := 0.0;
  try
    //todo:��VarType��� AValue����,�����TObject�����;��˳�
    if IsInt(APropDef.Value) then
    begin
      I1 := StrToInt(APropDef.Value);
      I2 := AValue;
      ValueType := vtInt;
    end
    else if IsFloat(APropDef.Value) then
    begin
      F1 := StrToFloat(APropDef.Value);
      F2 := AValue;
      ValueType := vtFloat;
    end
    else if PropInfo^.PropType^.Kind = tkInteger then
    begin
      IdToInt := FindIdentToInt(PPropInfo(PropInfo)^.PropType^);
      if Assigned(IdToInt) and ((APropDef.Value = '') or (IdToInt(APropDef.Value, I1)))
        and IdToInt(AValue, I2) then
      begin
        ValueType := vtInt;
        if APropDef.Value = '' then
          I1 := 0;
      end
      else
      begin
        S1 := APropDef.Value;
        S2 := AValue;
        ValueType := vtOther;
      end;
    end
    else
    begin
      S1 := APropDef.Value;
      S2 := AValue;
      if PropInfo^.PropType^.Kind = tkClass then
        ValueType := vtObject
      else
        ValueType := vtOther;
    end;

{$IFDEF DEBUG}
    CnDebugger.LogFmt('PropName %s, TypeKind %d, S1 %s, S2 %s',
      [APropDef.PropName, Integer(PropInfo^.PropType^.Kind), S1, S2]);
{$ENDIF}

    case APropDef.Compare of
      coLarge, coLargeEqual, coLess, coLessEqual:
        // �ַ����Ͷ����û�д��ڵ��ڵȲ�����ֻ���� = �� <> ����
        begin
          if (ValueType = vtOther) or (ValueType = vtObject) then
            Exit;
          case APropDef.Compare of
            coLarge:
              begin
                if ((ValueType = vtInt) and (I2 > I1)) or ((ValueType = vtFloat)
                  and (F2 > F1)) then
                  Result := True
                else
                  Result := False;
              end;
            coLess:
              begin
                if ((ValueType = vtInt) and (I2 < I1)) or ((ValueType = vtFloat)
                  and (F2 < F1)) then
                  Result := True
                else
                  Result := False;
              end;
            coLargeEqual:
              begin
                if ((ValueType = vtInt) and (I2 >= I1)) or ((ValueType = vtFloat)
                  and (F2 >= F1)) then
                  Result := True
                else
                  Result := False;
              end;
            coLessEqual:
              begin
                if ((ValueType = vtInt) and (I2 <= I1)) or ((ValueType = vtFloat)
                  and (F2 <= F1)) then
                  Result := True
                else
                  Result := False;
              end;

          end;
        end;
      coEqual:
        begin
          if ((ValueType = vtInt) and (I2 = I1))
            or ((ValueType = vtFloat) and (FloatToStr(F2) = FloatToStr(F1)))
            or ((ValueType = vtObject) and (S2 = S1))
            or ((ValueType = vtOther) and (S2 = S1)) then
            Result := True
          else
            Result := False;
        end;
      coNotEqual:
        begin
          if ((ValueType = vtInt) and (I2 <> I1))
            or ((ValueType = vtFloat) and (FloatToStr(F2) <> FloatToStr(F1)))
            or ((ValueType = vtObject) and (S2 <> S1))
            or ((ValueType = vtOther) and (S2 <> S1)) then
            Result := True
          else
            Result := False;
        end;
    end;
{$IFDEF DEBUG}
    CnDebugger.LogBoolean(Result, 'ValidateProp');
{$ENDIF}
  except

  end;
end;

procedure TCnCorPropForm.btnConfigClick(Sender: TObject);
var
  AForm: TCnCorPropCfgForm;
begin
  AForm := TCnCorPropCfgForm.Create(nil);
  try
    AForm.PropDefList := FPropDefList;
    AForm.Initialing := True;
    if AForm.ShowModal = mrOk then
    begin
      FPropDefList := AForm.PropDefList;
      if CnWizardMgr.WizardByClass(TCnCorPropWizard) <> nil then
        CnWizardMgr.WizardByClass(TCnCorPropWizard).DoSaveSettings;
    end;
  finally
    AForm.Free;
  end;
end;

procedure TCnCorPropForm.CorrectProject(Project:IOTAProject);
var
  ModuleInfo: IOTAModuleInfo;
  Module: IOTAModule;
  I, CorResultCount: Integer;
  ModuleIsOpen: Boolean;
  Ext: string;
begin
  Assert(Assigned(Project));
  for I := 0 to Project.GetModuleCount - 1 do
  begin
    ModuleInfo := Project.GetModule(I);
    Assert(Assigned(ModuleInfo));

    if Trim(ModuleInfo.FileName) = '' then // This is a unit like Forms.pas
      Continue;
    ModuleIsOpen := CnOtaIsFileOpen(ModuleInfo.FileName);
    CorResultCount := FCorrectItemList.Count;

    Ext := UpperCase(ExtractFileExt(ModuleInfo.FileName));
    if (Ext = '.DCR') then
      Continue;

    try
      Module := ModuleInfo.OpenModule;
    except
      Continue;
    end;
    if not Assigned(Module) then
      Continue;

    CorrectModule(Module);

    if not ModuleIsOpen and (CorResultCount = FCorrectItemList.Count) then
      Module.CloseModule(True);
  end;
end;

procedure TCnCorPropForm.CorrectCurrentForm;
var
  Module: IOTAModule;
begin
  Module := CnOtaGetCurrentModule;
  if Module = nil then
  begin
    FHasForm := False;
    ErrorDlg(SCnCorrectPropertyErrNoForm);
    Exit;
  end;
  CorrectModule(Module);
end;

procedure TCnCorPropForm.CorrectOpenedForm;
var
  I: Integer;
  iModuleServices: IOTAModuleServices;
begin
  QuerySvcs(BorlandIDEServices, IOTAModuleServices, iModuleServices);
  if iModuleServices.GetModuleCount = 0 then
  begin
    FHasForm := False;
    ErrorDlg(SCnCorrectPropertyErrNoForm);
    Exit;
  end;

  for I := 0 to iModuleServices.GetModuleCount - 1 do
    CorrectModule(iModuleServices.GetModule(I));
end;

procedure TCnCorPropForm.CorrectModule(Module: IOTAModule);
var
  J, K, CorResultCount: Integer;
  Editor: IOTAEditor;
  FormEditor: IOTAFormEditor;
  RootComp: IOTAComponent;
  AComp: IOTAComponent;
begin
  for J := 0 to Module.GetModuleFileCount - 1 do
  begin
    Editor := Module.GetModuleFileEditor(J);
    if Editor.QueryInterface(IOTAFormEditor, FormEditor) = S_OK then
    begin
    {$IFDEF DEBUG}
      CnDebugger.LogFmt('Successfully Get %s.FormEditor', [Editor.FileName]);
    {$ENDIF}
      RootComp := FormEditor.GetRootComponent;
      CorResultCount := FCorrectItemList.Count;
      //���ж�Form����
      CorrectProp(FormEditor.GetFileName, RootComp);

      //Ȼ���ж�Form��DataModule�ϵĿؼ�
      for K := 0 to RootComp.GetComponentCount - 1 do
      begin
        AComp := RootComp.GetComponent(K);
        CorrectProp(FormEditor.GetFileName, AComp);
      end;

      // ���޸�������ˢ��Object Inspector
      if FCorrectItemList.Count > CorResultCount then
        CnOtaNotifyFormDesignerModified(FormEditor);
    end;
  end;
end;

procedure TCnCorPropForm.AddCorrItem(AItem: TCorrectItem);
begin
  FCorrectItemList.Add(AItem);
end;

procedure TCnCorPropForm.SetCorrectItemList(const Value: TObjectList);
begin
  FCorrectItemList := Value;
end;

procedure TCnCorPropForm.ClearItems;
begin
  lvResult.Items.BeginUpdate;
  lvResult.Items.Clear;
  lvResult.Items.EndUpdate;
  CorrectItemList.Clear;
end;

procedure TCnCorPropForm.UpdateView;
var
  I: Integer;
  AItem: TCorrectItem;
  AViewItem: TListItem;
begin
  lvResult.Items.BeginUpdate;
  //��Item��ӵ�ListView��ȥ
  for I := 0 to FCorrectItemList.Count - 1 do
  begin
    AItem := TCorrectItem(FCorrectItemList.Items[I]);
    AViewItem := lvResult.Items.Add;
    if AItem.PropDef.Action = paCorrect then
    begin
      AViewItem.ImageIndex := 0;
      AViewItem.Caption := SCnCorrectPropertyStateCorrected;
    end
    else
    begin
      AViewItem.ImageIndex := 1;
      AViewItem.Caption := SCnCorrectPropertyStateWarning;
    end;
    AViewItem.SubItems.Add(ChangeFileExt(ExtractFileName(AItem.FileName), ''));
    AViewItem.SubItems.Add(AItem.CorrComp.Name + '.' + AItem.PropDef.PropName);
    with AItem do
    begin
     {$IFDEF DEBUG}
      CnDebugger.LogMsg(PropDef.PropName);
      CnDebugger.LogMsgWithTag(PropDef.PropName, 'PropName');
     {$ENDIF}

      AViewItem.SubItems.Add(OldValue);
      AViewItem.SubItems.Add(PropDef.ToValue);
    end;
  end;
  lvResult.Items.EndUpdate;
end;

function TCnCorPropForm.GetCorrectRange: TCorrectRange;
begin
  if rbForm.Checked then
    Result := crCurrent
  else if rbOpened.Checked then
    Result := crOpened
  else if rbProject.Checked then
    Result := crProject
  else
    Result := crGroup;
end;

procedure TCnCorPropForm.SetCorrectRange(const Value: TCorrectRange);
begin
  case Value of
    crCurrent: rbForm.Checked:=true;
    crProject: rbProject.Checked:=true;
    crGroup: rbGroup.checked:=true;
  end;
end;

procedure TCnCorPropForm.CorrectGroup;
var
  CurrentGroup: IOTAProjectGroup;
  Project:IOTAProject;
  i: Integer;
begin
  CurrentGroup := CnOtaGetProjectGroup;
  Assert(Assigned(CurrentGroup));
  for I:=0 to CurrentGroup.GetProjectCount-1 do
  begin
    Project:=CurrentGroup.GetProject(i);
    CorrectProject(Project);
  end;
end;

{ TCorrectItem }

procedure TCorrectItem.SetCorrComp(const Value: TComponent);
begin
  FCorrComp := Value;
end;

procedure TCorrectItem.SetFileName(const Value: string);
begin
  FFileName := Value;
end;

procedure TCorrectItem.SetOldValue(const Value: string);
begin
  FOldValue := Value;
end;

procedure TCorrectItem.SetPropDef(const Value: TCnPropDef);
begin
  FPropDef := Value;
end;

procedure TCnCorPropForm.FormCreate(Sender: TObject);
begin
  FCorrectItemList := TObjectList.Create;
end;

procedure TCnCorPropForm.FormDestroy(Sender: TObject);
begin
  FreeAndNil(FCorrectItemList);
end;

procedure TCorrectItem.SetPropName(const Value: string);
begin
  FPropName := Value;
end;

procedure TCnCorPropForm.actCorrectCompUpdate(Sender: TObject);
begin
  //����Ѿ����¹���
  if Assigned(lvResult.Selected) then
    (Sender as TAction).Enabled := lvResult.Selected.ImageIndex <> 0
  else
    (Sender as TAction).Enabled := False;
end;

procedure TCnCorPropForm.actLocateCompUpdate(Sender: TObject);
begin
  (Sender as TAction).Enabled := Assigned(lvResult.Selected);
end;

procedure TCnCorPropForm.actCorrectCompExecute(Sender: TObject);
var
  AItem: TCorrectItem;
  I: Integer;
begin
  //��������
  for I := 0 to lvResult.Items.Count - 1 do
  begin
    if lvResult.Items[I].Selected and (lvResult.Items[I].ImageIndex > 0) then
    begin
      AItem := TCorrectItem(FCorrectItemList.Items[lvResult.Items[I].Index]);
      if SetPropValueIncludeSub(AItem.CorrComp, AItem.PropName, AItem.PropDef.ToValue, AItem.CorrComp.Owner) then
      begin
        lvResult.Items[I].ImageIndex := 0;
        lvResult.Items[I].Caption := SCnCorrectPropertyStateCorrected;
      end;
    end;
  end;
end;

procedure TCnCorPropForm.actLocateCompExecute(Sender: TObject);
var
  AItem: TCorrectItem;
  Module: IOTAModule;
  I: Integer;
  Editor: IOTAEditor;
  FormEditor: IOTAFormEditor;
  NTAComp: INTAComponent;
begin
  with lvResult.Selected do
    AItem := TCorrectItem(FCorrectItemList.Items[Index]);

  if IsDelphiRuntime then
    Module := CnOtaGetModule(ChangeFileExt(AItem.FileName, '.pas'))
  else
    Module := CnOtaGetModule(ChangeFileExt(AItem.FileName, '.cpp'));

  if not Assigned(Module) then
  begin
    ErrorDlg(SCnCorrectPropertyErrNoModuleFound);
    Exit;
  end;

  for I := 0 to Module.GetModuleFileCount - 1 do
  begin
    Editor := Module.GetModuleFileEditor(I);
    if Editor.QueryInterface(IOTAFormEditor, FormEditor) = S_OK then
    begin
    {$IFDEF DEBUG}
      CnDebugger.LogMsg('Locate Component');
    {$ENDIF}
      try
        Editor.Show;
        NTAComp := FormEditor.GetRootComponent as INTAComponent;

        if NTAComp.GetComponent.Name = AItem.CorrComp.Name then
          //�����Form��DataModule
          FormEditor.GetRootComponent.Select(False)
        else
          FormEditor.FindComponent(AItem.CorrComp.Name).Select(False);
      except
        ErrorDlg(SCnCorrectPropertyErrNoModuleFound);
        Continue;
      end;
    end;
  end;
end;

procedure TCnCorPropForm.btnAllClick(Sender: TObject);
var
  AItem: TCorrectItem;
  I: Integer;
begin
  //��������
  for I := 0 to lvResult.Items.Count - 1 do
  begin
    AItem := TCorrectItem(FCorrectItemList.Items[I]);
    if lvResult.Items[I].ImageIndex <> 0 then
    begin
      if SetPropValueIncludeSub(AItem.CorrComp, AItem.PropName, AItem.PropDef.ToValue, AItem.CorrComp.Owner) then
      begin
        with lvResult.Items[I] do
        begin
          ImageIndex := 0;
          Caption := SCnCorrectPropertyStateCorrected;
        end;
      end;
    end;
  end;
end;

procedure TCnCorPropForm.btnCloseClick(Sender: TObject);
begin
  Close;
end;

procedure TCnCorPropForm.btnHelpClick(Sender: TObject);
begin
  ShowFormHelp;
end;

function TCnCorPropForm.GetHelpTopic: string;
begin
  Result := 'CnCorrectProperty';
end;

procedure TCnCorPropForm.FormActivate(Sender: TObject);
begin
  rbProject.Enabled := CnOtaGetCurrentProject <> nil;
  rbGroup.Enabled := CnOtaGetProjectGroup <> nil;
  if not rbProject.Enabled then
    rbForm.Checked := True;

  // ���ɾ�����Ѿ��޸ĵĿؼ���˫����λ���ÿؼ���ʱ����Ϊ�Ҳ�����
  // ���Ի��׳�һ���쳣�����µ��ý���֤ÿ�μ����ʱ�Զ������б�
  // �ⲻ�Ǻð취�����һ������ٶ��������������ε��ٿ���ʹ���¼���
  //if lvResult.Items.Count > 0 then
  //  actCorrectExecute(nil);
end;

procedure TCnCorPropForm.lvResultDblClick(Sender: TObject);
begin
  if Self.lvResult.Selected <> nil then
    Self.actLocateComp.Execute;
end;

procedure TCnCorPropForm.actUndoCorrectUpdate(Sender: TObject);
begin
  //����Ѿ����¹���
  if Assigned(lvResult.Selected) then
    (Sender as TAction).Enabled := lvResult.Selected.ImageIndex = 0
  else
    (Sender as TAction).Enabled := False;
end;

procedure TCnCorPropForm.actUndoCorrectExecute(Sender: TObject);
var
  AItem: TCorrectItem;
  I: Integer;
begin
  //��������
  for I := 0 to lvResult.Items.Count - 1 do
  begin
    if lvResult.Items[I].Selected and (lvResult.Items[I].ImageIndex = 0) then
    begin
      AItem := TCorrectItem(FCorrectItemList.Items[lvResult.Items[I].Index]);
      if SetPropValueIncludeSub(AItem.CorrComp, AItem.PropName, AItem.OldValue, AItem.CorrComp.Owner) then
      begin
        lvResult.Items[I].ImageIndex := 1;
        lvResult.Items[I].Caption := SCnCorrectPropertyStateWarning;
      end;
    end;
  end;
end;

procedure TCnCorPropForm.DoLanguageChanged(Sender: TObject);
var
  I: Integer;
begin
  for I := 0 to lvResult.Items.Count - 1 do
    case lvResult.Items[I].ImageIndex of
      0: lvResult.Items[I].Caption := SCnCorrectPropertyStateCorrected;
      1: lvResult.Items[I].Caption := SCnCorrectPropertyStateWarning;
    end;
end;

{$ENDIF CNWIZARDS_CNCORPROPWIZARD}
end.
