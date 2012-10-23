unit UpdateLib;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, bsSkinCtrls, bsSkinData, BusinessSkinForm,
  ExtCtrls, StdCtrls, bsSkinBoxCtrls, IniFiles, Shellapi, MutiScreensApi,
  bsMessages, bsSkinShellCtrls, UpdateTool, bsSkinExCtrls;
type
  TUpdateForm = class(TForm)
    bskngbloading: TbsSkinGauge;
    bskng1: TbsSkinGauge;
    bsBusinessSkinForm: TbsBusinessSkinForm;
    bsSkinData: TbsSkinData;
    bsCompressedSkinList: TbsCompressedSkinList;
    mmoInfo: TbsSkinMemo;
    bsSkinScrollBar1: TbsSkinScrollBar;
    bsSkinMessage: TbsSkinMessage;
    bsknlbl1: TbsSkinLabel;
    blversion: TbsSkinLabel;
    bsknlbl2: TbsSkinLabel;
    bsknlbl3: TbsSkinLabel;
    btnOK: TbsSkinButton;
    btnBcanel: TbsSkinButton;
    lbl2: TbsSkinStdLabel;
    lbl3: TbsSkinStdLabel;
    mmo2: TbsSkinMemo;
    bsknscrlbr1: TbsSkinScrollBar;
    lbl4: TbsSkinLinkLabel;
    procedure FormShow(Sender: TObject);
    procedure btnBcanelClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure btnOKClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
  private
    { Private declarations }
    procedure TOnFinashOne(messShow, version: string; value: Integer); //�����һ�� ��ʾ�ܽ�����Ϣ������
    procedure TOnDowning(value: Integer); //��������ʾ����
    procedure TOnFinashAll; //���ȫ��
    procedure TBeforeAllDown(explain: string; MaxValue: Integer; IniFile: string; ExeFile: string; main, versionLast: string); //ȫ�����ؿ�ʼǰ�������ܽ��ȳ��ȡ���ʼ����������Ϣ����Ϣ
    procedure TBeforeDownOne(MaxValue: Integer); //����һ��ǰ����ʼ������������
    procedure TAddExplans(explans: TStrings); //����˵��
    procedure OnError; //��������
  public
    { Public declarations }
  end;

var
  UpdateForm: TUpdateForm;
  DownTool: TDownTool;
  IniFileName: string;
  ExeFileName: string;
  mainName: string;
implementation

{$R *.dfm}

procedure TUpdateForm.TOnFinashOne(messShow, version: string; value: Integer); //�����һ�� ��ʾ�ܽ�����Ϣ������
begin
  mmo2.Lines.Add(messShow);
  blversion.Caption := version;
  bskngbloading.Value := value;
end;

procedure TUpdateForm.TOnDowning(value: Integer); //��������ʾ����
begin
  bskng1.Value := value;
end;

procedure TUpdateForm.TOnFinashAll; //���ȫ��
var
  IniFiles: TIniFile;
begin
  bskngbloading.Value := bskngbloading.MaxValue;
  IniFileName := ExtractFileDir(PARAMSTR(0)) + '\' + IniFileName;
  if FileExists(IniFileName) then
  begin
    IniFiles := TIniFile.Create(IniFileName);
    IniFiles.WriteString(mainName, 'version', blversion.Caption);
    IniFiles.Free;
  end;
  btnOK.Enabled := True;
  if bskng1.Value <> bskng1.MaxValue then
  begin
    mmo2.Lines.Add('����ʧ�ܣ�ԭ������ǣ�');
    mmo2.Lines.Add('1�����������Ӵ���');
    mmo2.Lines.Add('2���������ļ����ܶ�ʧ');
    mmo2.Lines.Add('3�����ĸ�����ʱĿ¼���ƶ�');
    mmo2.Lines.Add('������ȷ�������¸��£�');
  end
  else
    mmo2.Lines.Add('���³ɹ��������ȷ�����������򣬵����ȡ�����˳���');
end;

procedure TUpdateForm.OnError;
begin
  Application.ShowMainForm := False;
  bsSkinMessage.MessageDlg('�벻Ҫֱ������������', mtError, [mbOK], 0);
  Close;
end;

procedure TUpdateForm.TBeforeAllDown(explain: string; MaxValue: Integer; IniFile: string; ExeFile: string; main, versionLast: string); //ȫ�����ؿ�ʼǰ�������ܽ��ȳ��ȡ���ʼ����������Ϣ����Ϣ
begin
  mmo2.Lines.Add(explain + '��');
  IniFileName := IniFile;
  ExeFileName := ExeFile;
  mainName := main;
  bsknlbl3.Caption := versionLast;
  bskngbloading.MaxValue := MaxValue;
end;

procedure TUpdateForm.TBeforeDownOne(MaxValue: Integer); //����һ��ǰ����ʼ������������
begin
  bskng1.MaxValue := MaxValue;
  bskng1.Value := 0;
end;

procedure TUpdateForm.btnBcanelClick(Sender: TObject);
begin
  Close;
end;

procedure TUpdateForm.btnOKClick(Sender: TObject);
begin
  ShellExecute(Application.Handle, nil, pchar(ExeFileName), nil, pchar(ExtractFileDir(PARAMSTR(0))), SW_SHOW);
  Close;
end;

procedure TUpdateForm.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  if DownTool <> nil then
  begin
    DownTool.FreeOnTerminate := True;
    DownTool.Terminate;
  end;
  UpdateTool.nDeleteDir(ExtractFileDir(PARAMSTR(0)) + '\update_temp');
end;

procedure TUpdateForm.FormCreate(Sender: TObject);
begin
  DownTool := TDownTool.Create;
end;

procedure TUpdateForm.FormShow(Sender: TObject);
begin
  changeScreen(Self, 0, Screen);
  DownTool.OnFinashOne := TOnFinashOne;
  DownTool.OnDowning := TOnDowning;
  DownTool.OnFinashAll := TOnFinashAll;
  DownTool.BeforeAllDown := TBeforeAllDown;
  DownTool.BeforeDownOne := TBeforeDownOne;
  DownTool.AddExplans := TAddExplans;
  DownTool.OnError := OnError;
  DownTool.Start;

end;

procedure TUpdateForm.TAddExplans(explans: TStrings); //����˵��
begin
  mmoInfo.Lines.AddStrings(explans);
end;

end.

