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

unit CnCorPropRulesFrm;
{* |<PRE>
================================================================================
* ������ƣ�CnPack IDE ר�Ұ�
* ��Ԫ���ƣ������޸Ĺ���༭��Ԫ
* ��Ԫ���ߣ���ʡ(hubdog) hubdog@263.net
*           ��Х(LiuXiao) liuxiao@cnpack.org
* ��    ע�������޸�ר�����õ�Ԫ
* ����ƽ̨��PWin2000Pro + Delphi 5.01
* ���ݲ��ԣ�PWin2000 + Delphi 5
* �� �� �����õ�Ԫ�е��ַ��������ϱ��ػ�����ʽ
* ��Ԫ��ʶ��$Id: CnCorPropRulesFrm.pas 961 2011-07-31 08:32:24Z liuxiaoshanzhashu@gmail.com $
* �޸ļ�¼��2004.05.15 V1.1 by LiuXiao
*               �޸� PropDef ���õ��ظ��ͷŵ��³��������
*           2003.05.17 V1.0 by LiuXiao
*               ������Ԫ
================================================================================
|</PRE>}

interface

{$I CnWizards.inc}

{$IFDEF CNWIZARDS_CNCORPROPWIZARD}

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, TypInfo, CnCommon, CnWizConsts, CnWizUtils, CnCorPropWizard,
  CnWizMultiLang;

type
  TCorPropRuleForm = class(TCnTranslateForm)
    btnOK: TButton;
    btnCancel: TButton;
    btnHelp: TButton;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    Label6: TLabel;
    cbbComponent: TComboBox;
    cbbProperty: TComboBox;
    cbbCondition: TComboBox;
    cbbValue: TComboBox;
    cbbAction: TComboBox;
    cbbDestValue: TComboBox;
    chkActive: TCheckBox;
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
    procedure FormShow(Sender: TObject);
    procedure btnHelpClick(Sender: TObject);
  private
    FPropDef: TCnPropDef;
    procedure SetPropDef(const Value: TCnPropDef);
    function GetPropDef: TCnPropDef;
    { Private declarations }
  protected
    function GetHelpTopic: string; override;
  public
    { Public declarations }
    procedure ClearAll;
    procedure AddUniqueToCombo(Combo: TComboBox);
    property PropDef: TCnPropDef read GetPropDef write SetPropDef;
    {������ã��Լ�������}
  end;

var
  CorPropRuleForm: TCorPropRuleForm = nil;

{$ENDIF CNWIZARDS_CNCORPROPWIZARD}

implementation

{$IFDEF CNWIZARDS_CNCORPROPWIZARD}

uses
  CnCorPropCfgFrm, CnCorPropFrm, CnWizIdeUtils;

{$R *.DFM}

procedure TCorPropRuleForm.FormCreate(Sender: TObject);
var
  i: Integer;
begin
  FPropDef := TCnPropDef.Create(nil);
  cbbCondition.Items.Clear;
  cbbAction.Items.Clear;
  for i := Ord(Low(CompareStr)) to Ord(High(CompareStr)) do
    cbbCondition.Items.Add(CompareStr[TCompareOper(i)]);

  ActionStr[paWarn] := SCnCorrectPropertyActionWarn;
  ActionStr[paCorrect] := SCnCorrectPropertyActionAutoCorrect;
  for i := Ord(Low(ActionStr)) to Ord(High(ActionStr)) do
    cbbAction.Items.Add(ActionStr[TPropAction(i)]);

  {$IFDEF COMPILER6_UP}
  cbbComponent.AutoComplete := True;
  cbbProperty.AutoComplete := True;
  cbbValue.AutoComplete := True;
  cbbDestValue.AutoComplete := True;
  {$ENDIF}

  cbbCondition.ItemIndex := 0;
  cbbAction.ItemIndex := 0;
end;

procedure TCorPropRuleForm.SetPropDef(const Value: TCnPropDef);
begin
  if not Assigned(Value) then Exit;
  with Value do
  begin
    cbbComponent.Text := CompName;
    cbbProperty.Text := PropName;
    cbbCondition.ItemIndex := Ord(Compare);
    cbbValue.Text := Value;
    cbbAction.ItemIndex := Ord(Action);
    cbbDestValue.Text := ToValue;
    chkActive.Checked := Active;
  end;
  FPropDef.Assign(Value);
end;

procedure TCorPropRuleForm.FormDestroy(Sender: TObject);
begin
  FreeAndNil(FPropDef);
end;

function TCorPropRuleForm.GetPropDef: TCnPropDef;
begin
  if FPropDef <> nil then with FPropDef do
  begin
    CompName := cbbComponent.Text;
    PropName := cbbProperty.Text;
    Compare := TCompareOper(cbbCondition.ItemIndex);
    Value := cbbValue.Text;
    Action := TPropAction(cbbAction.ItemIndex);
    ToValue := cbbDestValue.Text;
    Active := chkActive.Checked;
  end;
  Result := FPropDef;
end;

procedure TCorPropRuleForm.ClearAll;
begin
  cbbComponent.Text := '';
  cbbProperty.Text := '';
  cbbValue.Text := '';
  cbbDestValue.Text := '';
  chkActive.Checked := True;
end;

procedure TCorPropRuleForm.AddUniqueToCombo(Combo: TComboBox);
begin
  if (Combo <> nil) and
     (Combo.Style <> csDropDownList) and
     (Combo.Text <> '') and
     (Combo.Items.IndexOf(Combo.Text) < 0) then
  begin
    Combo.Items.Add(Combo.Text);
  end;
end;

procedure TCorPropRuleForm.FormCloseQuery(Sender: TObject;
  var CanClose: Boolean);
var
  AClass: TPersistentClass;
  AComponent: TComponent;
begin
  if ModalResult = mrOK then
  begin
    CanClose := True;
    AClass := GetClass(cbbComponent.Text);
    if AClass = nil then
    begin
      CanClose := QueryDlg(Format(SCnCorrectPropertyErrClassFmt,
        [cbbComponent.Text]));
    end
    else
    begin
      if GetPropInfo(AClass, cbbProperty.Text) = nil then
      begin
        AComponent := nil;
        try
          AComponent := TComponent(AClass.NewInstance);
          try
            AComponent.Create(nil);
          except
            AComponent := nil;
            CanClose := QueryDlg(Format(SCnCorrectPropertyErrClassCreate,
              [cbbComponent.Text, cbbProperty.Text]));
          end;

          if (AComponent <> nil) and (GetPropInfoIncludeSub(AComponent, cbbProperty.Text) = nil) then
            CanClose := QueryDlg(Format(SCnCorrectPropertyErrPropFmt,
              [cbbComponent.Text, cbbProperty.Text]));
        except
          CanClose := QueryDlg(Format(SCnCorrectPropertyErrPropFmt,
              [cbbComponent.Text, cbbProperty.Text]));
        end;

        try
          AComponent.Free;
        except
          ;
        end;
      end;
    end;
  end
  else
  begin
    CanClose := True;
  end;
  if CanClose then
  begin
    AddUniqueToCombo(cbbProperty);
    AddUniqueToCombo(cbbValue);
    AddUniqueToCombo(cbbDestValue);
  end;
end;

procedure TCorPropRuleForm.FormShow(Sender: TObject);
var
  I: Integer;
begin
  with cbbComponent do
  begin
    GetInstalledComponents(nil, Items);
    for I := 0 to CnNoIconList.Count - 1 do
      Items.Add(CnNoIconList[I]);
    SetFocus;
  end;
end;

procedure TCorPropRuleForm.btnHelpClick(Sender: TObject);
begin
  ShowFormHelp;
end;

function TCorPropRuleForm.GetHelpTopic: string;
begin
  Result := 'CnCorrectProperty';
end;

{$ENDIF CNWIZARDS_CNCORPROPWIZARD}
end.

