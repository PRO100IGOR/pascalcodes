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

unit CnBuildFrm;
{* |<PRE>
================================================================================
* ������ƣ�CnPack IDE ר�Ұ��Զ��幹������
* ��Ԫ���ƣ�CnPack IDE ר�Ұ��Զ��幹�����������嵥Ԫ
* ��Ԫ���ߣ���Х��LiuXiao�� liuxiao@cnpack.org
* ��    ע��
* ����ƽ̨��PWin2000Pro + Delphi 5.01
* ���ݲ��ԣ�PWin9X/2000/XP + Delphi 5/6/7 + C++Builder 5/6
* �� �� �����õ�Ԫ�е��ַ��������ϱ��ػ�����ʽ
* ��Ԫ��ʶ��$Id: CnBuildFrm.pas 763 2011-02-07 14:18:23Z liuxiao@cnpack.org $
* �޸ļ�¼��2007.02.11 V1.0
*               ������Ԫ
================================================================================
|</PRE>}

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, ExtCtrls, CheckLst, Buttons, ImgList, CnCommon, CnWizLangID,
  CnLangTranslator, CnLangMgr, CnClasses, CnLangStorage, CnHashLangStorage;

type
  TCnCustBuildForm = class(TForm)
    pnlTop: TPanel;
    bvlLineTop: TBevel;
    imgIcon: TImage;
    lblFun: TLabel;
    lblDesc: TLabel;
    lblList: TLabel;
    chklstWizards: TCheckListBox;
    bvlLine: TBevel;
    btnClose: TBitBtn;
    btnAbout: TBitBtn;
    btnNext: TBitBtn;
    btnHelp: TBitBtn;
    bvlWizard: TBevel;
    lblWizardName: TLabel;
    imgWizard: TImage;
    lblComments: TLabel;
    lblWizDesc: TLabel;
    ilWizImages: TImageList;
    lblState: TLabel;
    lblEnabled: TLabel;
    btnSelAll: TSpeedButton;
    btnDeselAll: TSpeedButton;
    btnInvert: TSpeedButton;
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure chklstWizardsClick(Sender: TObject);
    procedure chklstWizardsClickCheck(Sender: TObject);
    procedure btnCloseClick(Sender: TObject);
    procedure btnNextClick(Sender: TObject);
    procedure btnAboutClick(Sender: TObject);
    procedure btnSelAllClick(Sender: TObject);
    procedure btnDeselAllClick(Sender: TObject);
    procedure btnInvertClick(Sender: TObject);
    procedure btnHelpClick(Sender: TObject);
  private
    { Private declarations }
    FLangDir: string;
    FSaved: Boolean;
    FLangId: Cardinal;
    FWizardConstMap: TStrings;
    FWizardInc: TStrings; // �洢 CnWizards.inc �����ݣ����޸ı���
    FWizardIds: TStrings; // �洢���� Wizard �� Name���Ƿ� Enable �� Objects ��
    FWizardLines: TList;  // �洢���� Wizard �������к�
    FWizardNames: TStrings; // �洢�Ӷ����ļ��ж���� Wizard �Ķ������ƣ�
    FWizardComments: TStrings;

    hfs: TCnHashLangFileStorage;
    lm: TCnLangManager;
    procedure InitMap;
    procedure LoadWizardIds;
    procedure LoadWizardNamesAndComments;
    procedure LoadWizardImages;
  protected
    procedure DoCreate; override;
    procedure TranslateStrings;
  public
    { Public declarations }
    procedure LoadWizards;
  end;

var
  CnCustBuildForm: TCnCustBuildForm;

implementation

{$R *.DFM}

const
  SCnWizardsIncPath = '..\..\Source\';
  SCnWizardsIconPath = '..\..\Bin\Icons\';
  SCnWizardsLangPath = '..\..\Bin\Lang\';
  SCnWizardsIncName = 'CnWizards.inc';
  SCnWizardsLangName = 'CnWizards.txt';

  SCnWizardIdPrefix = '// Wizard: ';
  SCnWizardCommentPrefix = '// ';
  SCnWizardDefinePrefix ='{$DEFINE ';

var
  SCnInfoCaption: string = '��ʾ';
  SCnAboutCaption: string = '����';
  SCnWizardEnabled: string = '�������';
  SCnWizardDisabled: string = 'δ�������';
  SCnWizardExitAsk: string = '�Ƿ��˳������ߣ�';
  SCnWizardGenerate: string = '�Ƿ�ȷ�������������Ϣд�� cnwizards\Source\CnWizards.inc ?';
  SCnWizardGenerateOK: string = 'cnwizards\Source\CnWizards.inc д��ɹ���';
  SCnCustBuildAbout: string = 'CnPack IDE ר�Ұ��Զ��幹������' + #13#10#13#10 +
    '������� ��Х (LiuXiao)  liuxiao@cnpack.org' + #13#10 +
    '��Ȩ���� (C) 2001-2011 CnPack ������';

  SCnCustBuildHelp: string =
    'CnPack IDE ר�Ұ�֧���Զ��幹�������ĸ���ר���Ƿ������붼ͳһ��Դ���е�' + #13#10 +
    'cnwizards\Source\CnWizards.inc �ļ����ơ�' + #13#10 +
    '' + #13#10 +
    '�������ܹ��Կ��ӻ��ķ�ʽ���û�ѡ����Ҫ�����ר�Ҳ���ѡ��д�� CnWizards.inc' + #13#10 +
    '�ļ����Ӷ��ﵽѡ���Եر���ĳЩר�ҵ�Ŀ�ġ�' + #13#10 +
    '' + #13#10 +
    '�����ߵ�ʹ�÷��������� cnpack �� cnwizards Դ��󣬱�������' + #13#10 +
    'cnwizards\Tools\CnCustBuild Ŀ¼�µ� CnCustBuild.dpr ����' + #13#10 +
    'ѡ��ר�Һ�д�� CnWizards.inc ���ɡ�' + #13#10 +
    '' + #13#10 +
    'ע�⣺����ר�����ض��汾�� IDE ����Ч������˴���ѡ�񲻻���������Ӱ�졣' + #13#10 +
    '' + #13#10 +
    'д��ɹ��󣬿ɴ� cnwizards\Source Ŀ¼�µĹ����ļ����±��� CnWizards��';

procedure TCnCustBuildForm.FormCreate(Sender: TObject);
begin
  Application.Title := Caption;
  FWizardConstMap := TStringList.Create;
  InitMap;

  FWizardInc := TStringList.Create;
  FWizardIds := TStringList.Create;
  FWizardNames := TStringList.Create;
  FWizardComments := TStringList.Create;
  FWizardLines := TList.Create;

  FWizardInc.LoadFromFile(SCnWizardsIncPath + SCnWizardsIncName);
  LoadWizards;
end;

procedure TCnCustBuildForm.FormDestroy(Sender: TObject);
begin
  FreeAndNil(FWizardConstMap);
  FreeAndNil(FWizardLines);
  FreeAndNil(FWizardComments);
  FreeAndNil(FWizardNames);
  FreeAndNil(FWizardIds);
  FreeAndNil(FWizardNames);
end;

procedure TCnCustBuildForm.LoadWizardIds;
var
  I: Integer;
  S: string;
  E: Boolean;
begin
  I := 0;
  while I < FWizardInc.Count do
  begin
    if Pos(SCnWizardIdPrefix, FWizardInc[I]) = 1 then
    begin
      E := False;
      S := Trim(Copy(FWizardInc[I], Length(SCnWizardIdPrefix) + 1, MaxInt));
      Inc(I);
      if I < FWizardInc.Count then
        E := Pos(SCnWizardDefinePrefix, FWizardInc[I]) = 1;

      FWizardIds.AddObject(S, TObject(E));
      FWizardLines.Add(Pointer(I));
    end;

    Inc(I);
  end;
end;

procedure TCnCustBuildForm.LoadWizardImages;
var
  I: Integer;
  FileName: string;
  AIcon: TIcon;
begin
  ilWizImages.Clear;
  AIcon := TIcon.Create;
  try
    for I := 0 to FWizardIds.Count - 1 do
    begin
      FileName := SCnWizardsIconPath + 'T' + FWizardIds[I] + '.ico';
      AIcon.LoadFromFile(FileName);
      if not AIcon.Empty then
        ilWizImages.AddIcon(AIcon);
    end;
  finally
    AIcon.Free;
  end;
end;

procedure TCnCustBuildForm.LoadWizardNamesAndComments;
var
  Langs: TStrings;
  AName: string;
  I: Integer;

  function GetLangValues(AWizardName: string; const ASubfix: string): string;
  begin
    if FWizardConstMap.Values[AWizardName] <> '' then // �Ȳ��ֹ�ӳ��
      AWizardName := FWizardConstMap.Values[AWizardName];

    AName := 'S' + AWizardName + ASubfix;
    Result := Langs.Values[AName];
    if Result = '' then  // ԭ�������ھ�ȥ��Wizard����
    begin
      if StrRight(AWizardName, Length('Wizard')) = 'Wizard' then
      begin
        Result := AWizardName;
        Delete(Result, Length(Result) - Length('Wizard') + 1, Length('Wizard'));
        AName := 'S' + Result + ASubfix;
        Result := Langs.Values[AName];
      end;
    end;
  end;

begin
  FLangDir := SCnWizardsLangPath + InttoStr(GetWizardsLanguageID);
  if not FileExists(IncludeTrailingBackslash(FLangDir) + SCnWizardsLangName) then
    FLangDir := SCnWizardsLangPath + '1033';

  if FileExists(IncludeTrailingBackslash(FLangDir) + SCnWizardsLangName) then
  begin
    Langs := TStringList.Create;
    try
      Langs.LoadFromFile(IncludeTrailingBackslash(FLangDir) + SCnWizardsLangName);
      for I := 0 to FWizardIds.Count - 1 do
      begin
        FWizardNames.Add(GetLangValues(FWizardIds[I], 'Name'));
        FWizardComments.Add(GetLangValues(FWizardIds[I], 'Comment'));
      end;
    finally
      FreeAndNil(Langs);
    end;
  end;
end;

procedure TCnCustBuildForm.LoadWizards;
var
  I: Integer;
begin
  LoadWizardIds;
  LoadWizardNamesAndComments;
  LoadWizardImages;

  chklstWizards.Items.Assign(FWizardIds);
  for I := 0 to FWizardIds.Count - 1 do
    chklstWizards.Checked[I] := FWizardIds.Objects[I] <> nil;

  if chklstWizards.Items.Count > 0 then
  begin
    chklstWizards.ItemIndex := 0;
    if Assigned(chklstWizards.OnClick) then
      chklstWizards.OnClick(chklstWizards);
  end;
end;

procedure TCnCustBuildForm.chklstWizardsClick(Sender: TObject);
var
  ARect: TRect;
  Idx: Integer;
begin
  Idx := chklstWizards.ItemIndex;
  ARect := Rect(0, 0, imgWizard.Width, imgWizard.Height);
  imgWizard.Canvas.Brush.Color := Self.Color;
  imgWizard.Canvas.Pen.Color := clBlack;
  imgWizard.Canvas.FillRect(ARect);
  imgWizard.Canvas.FrameRect(ARect);

  if (Idx >= 0) and (Idx < ilWizImages.Count) then
  begin
    ARect := Rect(0, 0, imgWizard.Width, imgWizard.Height);
    imgWizard.Canvas.FillRect(ARect);
    imgWizard.Canvas.FrameRect(ARect);
    ilWizImages.Draw(imgWizard.Canvas, 1, 1, Idx);
  end;

  if (Idx >= 0) and (Idx < FWizardNames.Count) then
    lblWizardName.Caption := FWizardNames[Idx];

  if (Idx >= 0) and (Idx < FWizardComments.Count) then
    lblWizDesc.Caption := FWizardComments[Idx];

  if chklstWizards.Checked[Idx] then
    lblEnabled.Caption := SCnWizardEnabled
  else
    lblEnabled.Caption := SCnWizardDisabled;
end;

procedure TCnCustBuildForm.chklstWizardsClickCheck(Sender: TObject);
var
  Idx: Integer;
begin
  Idx := chklstWizards.ItemIndex;
  if chklstWizards.Checked[Idx] then
    lblEnabled.Caption := SCnWizardEnabled
  else
    lblEnabled.Caption := SCnWizardDisabled;
end;

procedure TCnCustBuildForm.InitMap;
begin
  with FWizardConstMap do
  begin
    Clear;
    Add('CnMessageBoxWizard=CnMsgBox');
    Add('CnComponentSelector=CnCompSelector');
    Add('CnSrcEditorEnhance=CnEditorEnhanceWizard');
    Add('CnCorPropWizard=CnCorrectProperty');
    Add('CnProjectExtWizard=CnProjExtWizard');
    Add('CnExplorerWizard=CnExplore');
    Add('CnSourceHighlight=CnSourceHighlightWizard');
  end;
end;

procedure TCnCustBuildForm.btnCloseClick(Sender: TObject);
begin
  if FSaved or QueryDlg(SCnWizardExitAsk, False, SCnInfoCaption) then
    Close;
end;

procedure TCnCustBuildForm.btnNextClick(Sender: TObject);
var
  I: Integer;
  LineNo: Integer;
begin
  if QueryDlg(SCnWizardGenerate, False, SCnInfoCaption) then
  begin
    for I := 0 to chklstWizards.Items.Count - 1 do
    begin
      FWizardIds.Objects[I] := TObject(chklstWizards.Checked[I]);

      LineNo := Integer(FWizardLines[I]);
      FWizardInc[LineNo] := SCnWizardDefinePrefix + 'CNWIZARDS_' + UpperCase(FWizardIds[I]) + '}';
      if not chklstWizards.Checked[I] then
        FWizardInc[LineNo] := SCnWizardCommentPrefix + FWizardInc[LineNo];
    end;
    FWizardInc.SaveToFile(SCnWizardsIncPath + SCnWizardsIncName);
    InfoDlg(SCnWizardGenerateOK, SCnInfoCaption);
    FSaved := True;
  end;
end;

procedure TCnCustBuildForm.btnAboutClick(Sender: TObject);
begin
  InfoDlg(SCnCustBuildAbout, SCnAboutCaption);
end;

procedure TCnCustBuildForm.btnSelAllClick(Sender: TObject);
var
  I: Integer;
begin
  for I := 0 to chklstWizards.Items.Count - 1 do
    chklstWizards.Checked[I] := True;
end;

procedure TCnCustBuildForm.btnDeselAllClick(Sender: TObject);
var
  I: Integer;
begin
  for I := 0 to chklstWizards.Items.Count - 1 do
    chklstWizards.Checked[I] := False;
end;

procedure TCnCustBuildForm.btnInvertClick(Sender: TObject);
var
  I: Integer;
begin
  for I := 0 to chklstWizards.Items.Count - 1 do
    chklstWizards.Checked[I] := not chklstWizards.Checked[I];
end;

procedure TCnCustBuildForm.btnHelpClick(Sender: TObject);
begin
  InfoDlg(SCnCustBuildHelp, SCnInfoCaption);
end;

procedure TCnCustBuildForm.DoCreate;
begin
  hfs := TCnHashLangFileStorage.Create(Self);
  hfs.AutoDetect := True;
  lm := TCnLangManager.Create(Self);
  lm.LanguageStorage := hfs;

  FLangId := GetWizardsLanguageID;
  if hfs.Languages.Find(FLangId) >= 0 then
    lm.CurrentLanguageIndex := hfs.Languages.Find(FLangId)
  else
    lm.CurrentLanguageIndex := hfs.Languages.Find(1033);
  CnLanguageManager.TranslateForm(Self);
  TranslateStrings;
  inherited;  
end;

procedure TCnCustBuildForm.TranslateStrings;
begin
  TranslateStr(SCnInfoCaption, 'SCnInfoCaption');
  TranslateStr(SCnAboutCaption, 'SCnAboutCaption');
  TranslateStr(SCnWizardEnabled, 'SCnWizardEnabled');
  TranslateStr(SCnWizardDisabled, 'SCnWizardDisabled');
  TranslateStr(SCnWizardExitAsk, 'SCnWizardExitAsk');
  TranslateStr(SCnWizardGenerate, 'SCnWizardGenerate');
  TranslateStr(SCnWizardGenerateOK, 'SCnWizardGenerateOK');
  TranslateStr(SCnCustBuildAbout,  'SCnCustBuildAbout');
  TranslateStr(SCnCustBuildHelp, 'SCnCustBuildHelp');
end;

end.
