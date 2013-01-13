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

unit CnWizUpgradeFrm;
{ |<PRE>
================================================================================
* ������ƣ�CnPack IDE ר�Ұ�
* ��Ԫ���ƣ������������Զ���ⵥԪ
* ��Ԫ���ߣ��ܾ��� (zjy@cnpack.org)
* ��    ע�������������Զ���ⵥԪ
* ����ƽ̨��PWin2000Pro + Delphi 5.01
* ���ݲ��ԣ�PWin9X/2000/XP + Delphi 5/6/7 + C++Builder 5/6
* �� �� �����ô����е��ַ��������ϱ��ػ�����ʽ
* ��Ԫ��ʶ��$Id: CnWizUpgradeFrm.pas 763 2011-02-07 14:18:23Z liuxiao@cnpack.org $
* �޸ļ�¼��2003.08.10 V1.1
*               ֻ�е�����رա���ťʱ���Ŵ����Ժ�����ʾ������
*           2003.04.28 V1.1
*               �������� IDE �����Ϲرտ��ܵ��� IDE ����������
*           2003.03.09 V1.0
*               ������Ԫ
================================================================================
|</PRE>}

interface

{$I CnWizards.inc}

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  WinInet, IniFiles, CnWizConsts, CnWizOptions, CnCommon, StdCtrls, ExtCtrls,
  CnWizUtils, CnInetUtils, CnWizMultiLang, CnWizCompilerConst;

type

{ TCnWizUpgradeItem }

  TCnWizUpgradeItem = class(TCollectionItem)
  private
    FBigBugFixed: Boolean;
    FNewFeature: Boolean;
    FVersion: string;
    FDate: TDateTime;
    FComment: string;
    FURL: string;
    FBetaVersion: Boolean;
  public
    procedure Assign(Source: TPersistent); override;
  published
    property Date: TDateTime read FDate write FDate;
    property Version: string read FVersion write FVersion;
    property NewFeature: Boolean read FNewFeature write FNewFeature;
    property BigBugFixed: Boolean read FBigBugFixed write FBigBugFixed;
    property BetaVersion: Boolean read FBetaVersion write FBetaVersion;
    property Comment: string read FComment write FComment;
    property URL: string read FURL write FURL;
  end;

{ TCnWizUpgradeCollection }

  TCnWizUpgradeCollection = class(TCollection)
  private
    function GetItems(Index: Integer): TCnWizUpgradeItem;
    procedure SetItems(Index: Integer; const Value: TCnWizUpgradeItem);
  public
    constructor Create;
    function Add: TCnWizUpgradeItem;
    property Items[Index: Integer]: TCnWizUpgradeItem read GetItems write SetItems; default;
  end;

{ TCnWizUpgradeThread }

  TCnWizUpgradeThread = class(TThread)
  private
    FUserCheck: Boolean;
    FUpgradeCollection: TCnWizUpgradeCollection;
    FHTTP: TCnHTTP;
    function GetUpgradeCollection(const Content: string): Boolean;
    procedure CheckUpgrade;
    procedure FindLinks(S: string; Strings: TStrings);
    function GetUpgrade(const AURL: string; Level: Integer): Boolean;
  protected

  public
    procedure Execute; override;
    constructor Create(AUserCheck: Boolean);
    destructor Destroy; override;
  end;

{ TCnWizUpgradeForm }

  TCnWizUpgradeForm = class(TCnTranslateForm)
    Memo: TMemo;
    pnlTop: TPanel;
    Label1: TLabel;
    Bevel2: TBevel;
    pnlBottom: TPanel;
    cbNoHint: TCheckBox;
    btnDownload: TButton;
    Bevel1: TBevel;
    btnClose: TButton;
    btnHelp: TButton;
    pnlLeft: TPanel;
    Image1: TImage;
    pnlRight: TPanel;
    lbl1: TLabel;
    procedure btnDownloadClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure btnHelpClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure btnCloseClick(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure cbNoHintClick(Sender: TObject);
  private
    { Private declarations }
    FCollection: TCnWizUpgradeCollection;
  protected
    function GetHelpTopic: string; override;
  public
    { Public declarations }
  end;

procedure CheckUpgrade(AUserCheck: Boolean);

implementation

uses
{$IFDEF Debug}
  CnDebug,
{$ENDIF Debug}
  CnWizTipOfDayFrm;

{$R *.DFM}

const
  csVersion = 'Version';
  csNewFeature = 'NewFeature';
  csBigBugFixed = 'BigBugFixed';
  csBetaVersion = 'BetaVersion';
  csURL = 'URL';

var
  FThread: TCnWizUpgradeThread;
  FForm: TCnWizUpgradeForm;

procedure CheckUpgrade(AUserCheck: Boolean);
begin
  // ��ʱ����Ĵ��룬�ĳ�һ��ֻ���һ�Σ��¿���в���ʹ�ñ���Ԫ
  with WizOptions do
  begin
    // ��ֹ�û���ǰ��������
    if Date < UpgradeCheckDate then
      UpgradeCheckDate := Date - 1;
    if AUserCheck or ((UpgradeStyle = usAllUpgrade) or (UpgradeStyle = usUserDefine) and
      (UpgradeContent <> [])) and (Date - UpgradeCheckDate >= 1) then
    begin
      UpgradeCheckDate := Date;
      if FThread = nil then
      begin
        FThread := TCnWizUpgradeThread.Create(AUserCheck);
      end
      else
        FThread.FUserCheck := AUserCheck;
    end;
  end;
end;

{ TCnWizUpgradeItem }

procedure TCnWizUpgradeItem.Assign(Source: TPersistent);
begin
  if Source is TCnWizUpgradeItem then
  begin
    FBigBugFixed := TCnWizUpgradeItem(Source).FBigBugFixed;
    FNewFeature := TCnWizUpgradeItem(Source).FNewFeature;
    FVersion := TCnWizUpgradeItem(Source).FVersion;
    FDate := TCnWizUpgradeItem(Source).FDate;
    FComment := TCnWizUpgradeItem(Source).FComment;
    FURL := TCnWizUpgradeItem(Source).FURL;
    FBetaVersion := TCnWizUpgradeItem(Source).FBetaVersion;
  end
  else
    inherited;
end;

{ TCnWizUpgradeCollection }

constructor TCnWizUpgradeCollection.Create;
begin
  inherited Create(TCnWizUpgradeItem);
end;

function TCnWizUpgradeCollection.Add: TCnWizUpgradeItem;
begin
  Result := TCnWizUpgradeItem(inherited Add);
end;

function TCnWizUpgradeCollection.GetItems(Index: Integer): TCnWizUpgradeItem;
begin
  Result := TCnWizUpgradeItem(inherited Items[Index]);
end;

procedure TCnWizUpgradeCollection.SetItems(Index: Integer;
  const Value: TCnWizUpgradeItem);
begin
  inherited Items[Index] := Value;
end;

{ TCnWizUpgradeThread }

constructor TCnWizUpgradeThread.Create(AUserCheck: Boolean);
begin
  inherited Create(True);
  FUserCheck := AUserCheck;
  FreeOnTerminate := True;
  FUpgradeCollection := TCnWizUpgradeCollection.Create;
  FHTTP := TCnHTTP.Create;
  if FForm <> nil then FForm.Close;
  
  if Suspended then
    Resume;
{$IFDEF Debug}
  CnDebugger.LogMsg('TCnWizUpgradeThread.Create');
{$ENDIF Debug}
end;

destructor TCnWizUpgradeThread.Destroy;
begin
  FThread := nil;
  FHTTP.Free;
  FUpgradeCollection.Free;
{$IFDEF Debug}
  CnDebugger.LogMsg('TCnWizUpgradeThread.Destroy');
{$ENDIF Debug}
  inherited;
end;

const
  csHttp = 'http://';
  csMaxLevel = 3;
  csMaxLinks = 3;

procedure TCnWizUpgradeThread.Execute;
var
  S: string;
  Y1, M1, D1, Y2, M2, D2: Word;
begin
  // ȡ������¼������IDE��汾����ר�Ұ��汾���Լ�����ID��Ϊ����
  S := Format('%s?ide=%s&ver=%s&langid=%d', [WizOptions.UpgradeURL, CompilerShortName,
    SCnWizardVersion, WizOptions.CurrentLangID]);

  // �ֶ�����
  if FUserCheck then
    S := S + '&manual=1';

  // ÿ���µ���һ��
  DecodeDate(WizOptions.UpgradeCheckMonth, Y1, M1, D1);
  DecodeDate(Date, Y2, M2, D2);
  if (Y1 <> Y2) or (M1 <> M2) then
  begin
    S := S + '&month=1';
    WizOptions.UpgradeCheckMonth := Date;
  end;

  // ȡ�ø�����Ϣ
  if not GetUpgrade(S, 1) then
  begin
    if not FHTTP.Aborted and FUserCheck then
      ErrorDlg(SCnWizUpgradeFail);
  end;

  // ����°汾
  if not FHTTP.Aborted and not Terminated then
    Synchronize(CheckUpgrade);
end;

// �� S ���ҳ����õ� URL ����
procedure TCnWizUpgradeThread.FindLinks(S: string; Strings: TStrings);
var
  i, j: Integer;
begin
  Strings.Clear;
  i := Pos(csHttp, LowerCase(S));
  while i > 0 do
  begin
    j := i + Length(csHttp);
    while (j < Length(S)) and not CharInSet(S[j], ['"', ' ', '>']) do
      Inc(j);
    Strings.Add(Copy(S, i, j - i));
    Delete(S, i, j - i);
    i := Pos(csHttp, LowerCase(S));
  end;
end;

function TCnWizUpgradeThread.GetUpgrade(const AURL: string; Level: Integer): Boolean;
var
  Content: string;
  Strings: TStrings;
  i: Integer;
begin
  Result := False;
  Content := string(FHTTP.GetString(AURL));
{$IFDEF Debug}
  CnDebugger.LogMsg('Upgrade: ' + AURL);
  CnDebugger.LogMsg(Content);
{$ENDIF Debug}
  if FHTTP.GetDataFail or FHTTP.Aborted then
    Exit;

  // �ӷ��ؽ��ȡ��������
  if GetUpgradeCollection(Content) then
  begin
    Result := True;
    Exit;
  end
  else if Level <= csMaxLevel then    // ��ת�����ݣ��ٷ�����ת���ַ
  begin                               // ת��ݹ鲻�ܳ���ָ����
    Strings := TStringList.Create;
    try
      FindLinks(Content, Strings);
      if Strings.Count <= csMaxLinks then // ������ת����Ϣ��Ӧ���й��������
        for i := 0 to Strings.Count - 1 do
          if GetUpgrade(Strings[i], Level + 1) then
          begin
            Result := True;
            Exit;
          end
          else if FHTTP.Aborted or Terminated then
            Exit;
    finally
      Strings.Free;
    end;
  end;
end;

function TCnWizUpgradeThread.GetUpgradeCollection(const Content: string): Boolean;
var
  Strings: TStrings;
  Ini: TMemIniFile;
  i: Integer;
  ADate: TDateTime;
  Item: TCnWizUpgradeItem;
begin
  FUpgradeCollection.Clear;
  Strings := nil;
  Ini := nil;
  try
    Strings := TStringList.Create;
    Ini := TMemIniFile.Create('');
    Strings.Text := Content;
    if Strings.Count > 0 then
    begin
      Ini.SetStrings(Strings);
      Ini.ReadSections(Strings);
      for i := 0 to Strings.Count - 1 do
      begin
        try
          ADate := CnStrToDate(Strings[i]);
          Item := FUpgradeCollection.Add;
          with Item do
          begin
            Date := ADate;
            Version := Ini.ReadString(Strings[i], csVersion, '');
            NewFeature := Ini.ReadBool(Strings[i], csNewFeature, False);
            BigBugFixed := Ini.ReadBool(Strings[i], csBigBugFixed, False);
            Comment := StrToLines(Ini.ReadString(Strings[i], SCnWizUpgradeCommentName, ''));
            URL := Ini.ReadString(Strings[i], csURL, '');
            BetaVersion := Ini.ReadBool(Strings[i], csBetaVersion, False);
          end;
        {$IFDEF Debug}
          CnDebugger.LogObject(Item);
        {$ENDIF Debug}
        except
          FreeAndNil(Item);
        end;
      end;
    end;
  finally
    if Assigned(Ini) then Ini.Free;
    if Assigned(Strings) then Strings.Free;
    Result := FUpgradeCollection.Count > 0;
  end;
end;

procedure TCnWizUpgradeThread.CheckUpgrade;
var
  i: Integer;
  
  function GetBuildNo(const VerStr: string): Integer;
  var
    s, s1: string;
    i: Integer;
  begin
    Result := 0;
    with TStringList.Create do
    try
      Text := StringReplace(VerStr, '.', CRLF, [rfReplaceAll]);
      if Count = 4 then
      begin
        s := Trim(Strings[3]);
        s1 := '';
        for i := 1 to Length(s) do
          if CharInSet(s[i], ['0'..'9']) then
            s1 := s1 + s[i]
          else
            Break;
        Result := StrToIntDef(s1, 0);
      end;
    finally
      Free;
    end;   
  end;
begin
  // �������������⵼������ʧ��ʱ����
  if FUpgradeCollection.Count = 0 then Exit;
  // �����������
  if (FUpgradeCollection[0].Date > WizOptions.BuildDate) or
    (GetBuildNo(FUpgradeCollection[0].Version) > GetBuildNo(SCnWizardVersion)) then
  begin
    // ɾ���ɰ汾��¼
    for i := FUpgradeCollection.Count - 1 downto 1 do
      if GetBuildNo(FUpgradeCollection[i].Version) <= GetBuildNo(SCnWizardVersion) then
        FUpgradeCollection.Delete(i);

    if not FUserCheck then
    begin
      // ����������ʾ
      if (WizOptions.UpgradeStyle = usDisabled) or (WizOptions.UpgradeStyle =
        usUserDefine) and (WizOptions.UpgradeContent = []) then
        Exit;

      // ɾ�����µĲ��԰汾��¼
      if WizOptions.UpgradeReleaseOnly then
        while FUpgradeCollection.Count > 0 do
          if FUpgradeCollection.Items[0].BetaVersion then
            FUpgradeCollection.Delete(0)
          else
            Break;

      // ɾ���������û��������ݲ����ļ�¼
      if WizOptions.UpgradeStyle = usUserDefine then
        while FUpgradeCollection.Count > 0 do
          if (ucNewFeature in WizOptions.UpgradeContent) and
            (FUpgradeCollection.Items[0].FNewFeature) or
            (ucBigBugFixed in WizOptions.UpgradeContent) and
            (FUpgradeCollection.Items[0].FBigBugFixed) then
            Break
          else
            FUpgradeCollection.Delete(0);

      // �ϴ���ʾ��û���µĸ���
      if (FUpgradeCollection.Count <= 0) or (Trunc(FUpgradeCollection.Items[0].Date)
        <= Trunc(WizOptions.UpgradeLastDate)) then
        Exit;
    end;
  end
  else
  begin
    if FUserCheck and QueryDlg(SCnWizNoUpgrade) then
      OpenUrl(WizOptions.NightlyBuildURL);
    Exit;
  end;

  // ��ʾ������ʾ����
  if FUpgradeCollection.Count > 0 then
  begin
    FForm := TCnWizUpgradeForm.Create(Application.MainForm);
    FForm.FCollection.Assign(FUpgradeCollection);
    FForm.Show;
  end;
end;

{ TCnWizUpgradeForm }

procedure TCnWizUpgradeForm.FormCreate(Sender: TObject);
begin
  FCollection := TCnWizUpgradeCollection.Create;
  ShowHint := WizOptions.ShowHint;
end;

const
  csNoHint = 'NoHint';

procedure TCnWizUpgradeForm.FormShow(Sender: TObject);
var
  i: Integer;
  s: string;
begin
  for i := 0 to FCollection.Count - 1 do
    with Memo.Lines do
    begin
      s := Format(SCnWizUpgradeVersion, [FCollection.Items[i].Version,
        CnDateToStr(FCollection.Items[i].Date)]);
      Add(s);
      Add(GetLine('-', Length(s)));
      Add(FCollection.Items[i].Comment);
      Add('');
      Add('URL: ' + FCollection.Items[i].URL);
      if i < FCollection.Count - 1 then
      begin
        Add('');
        Add('');
      end;
    end;
  cbNoHint.Checked := WizOptions.ReadBool(SCnUpgradeSection, csNoHint, True);
end;

procedure TCnWizUpgradeForm.FormClose(Sender: TObject;
  var Action: TCloseAction);
begin
  Action := caFree;
end;

procedure TCnWizUpgradeForm.FormDestroy(Sender: TObject);
begin
  FCollection.Free;
  FForm := nil;
end;

procedure TCnWizUpgradeForm.btnDownloadClick(Sender: TObject);
begin
  RunFile(FCollection.Items[0].URL);
  Close;
end;

procedure TCnWizUpgradeForm.btnHelpClick(Sender: TObject);
begin
  ShowFormHelp;
end;

function TCnWizUpgradeForm.GetHelpTopic: string;
begin
  Result := 'CnWizUpgrade';
end;

procedure TCnWizUpgradeForm.btnCloseClick(Sender: TObject);
begin
  if cbNoHint.Checked then
    WizOptions.UpgradeLastDate := FCollection.Items[0].Date;
  Close;
end;

procedure TCnWizUpgradeForm.cbNoHintClick(Sender: TObject);
begin
  WizOptions.WriteBool(SCnUpgradeSection, csNoHint, cbNoHint.Checked);
end;

initialization

finalization
{$IFDEF Debug}
  CnDebugger.LogEnter('CnWizUpgradeFrm finalization.');
{$ENDIF Debug}
  if Assigned(FThread) then
    try
      // �����ǰ����ִ�� HTTP ���������ܲ��������˳����˴�ǿ���˳��߳�
      TerminateThread(FThread.Handle, 0);
      if Assigned(FThread) then
        FreeAndNil(FThread);
    except
      ;
    end;
  if FForm <> nil then
    FForm.Free;

{$IFDEF Debug}
  CnDebugger.LogLeave('CnWizUpgradeFrm finalization.');
{$ENDIF Debug}
end.

