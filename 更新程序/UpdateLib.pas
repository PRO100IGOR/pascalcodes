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
    procedure TOnFinashOne(messShow, version: string; value: Integer); //完成了一个 显示总进度信息、进度
    procedure TOnDowning(value: Integer); //下载中显示进度
    procedure TOnFinashAll; //完成全部
    procedure TBeforeAllDown(explain: string; MaxValue: Integer; IniFile: string; ExeFile: string; main, versionLast: string); //全部下载开始前，计算总进度长度、初始化进度条信息、信息
    procedure TBeforeDownOne(MaxValue: Integer); //下载一个前，初始化进度条长度
    procedure TAddExplans(explans: TStrings); //更新说明
    procedure OnError; //发生错误
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

procedure TUpdateForm.TOnFinashOne(messShow, version: string; value: Integer); //完成了一个 显示总进度信息、进度
begin
  mmo2.Lines.Add(messShow);
  blversion.Caption := version;
  bskngbloading.Value := value;
end;

procedure TUpdateForm.TOnDowning(value: Integer); //下载中显示进度
begin
  bskng1.Value := value;
end;

procedure TUpdateForm.TOnFinashAll; //完成全部
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
    mmo2.Lines.Add('更新失败，原因可能是：');
    mmo2.Lines.Add('1：服务器连接错误');
    mmo2.Lines.Add('2：服务器文件可能丢失');
    mmo2.Lines.Add('3：您的更新临时目录被移动');
    mmo2.Lines.Add('请点击【确定】重新更新！');
  end
  else
    mmo2.Lines.Add('更新成功，点击【确定】重启程序，点击【取消】退出！');
end;

procedure TUpdateForm.OnError;
begin
  Application.ShowMainForm := False;
  bsSkinMessage.MessageDlg('请不要直接启动本程序', mtError, [mbOK], 0);
  Close;
end;

procedure TUpdateForm.TBeforeAllDown(explain: string; MaxValue: Integer; IniFile: string; ExeFile: string; main, versionLast: string); //全部下载开始前，计算总进度长度、初始化进度条信息、信息
begin
  mmo2.Lines.Add(explain + '：');
  IniFileName := IniFile;
  ExeFileName := ExeFile;
  mainName := main;
  bsknlbl3.Caption := versionLast;
  bskngbloading.MaxValue := MaxValue;
end;

procedure TUpdateForm.TBeforeDownOne(MaxValue: Integer); //下载一个前，初始化进度条长度
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

procedure TUpdateForm.TAddExplans(explans: TStrings); //更新说明
begin
  mmoInfo.Lines.AddStrings(explans);
end;

end.

