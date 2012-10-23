unit main;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls,Ini, bsDialogs, bsSkinData, BusinessSkinForm, ComCtrls,
  ExtCtrls, OleCtrls, SHDocVw, bsSkinCtrls,
  bsSkinExCtrls, ImgList, bsPngImageList, bsSkinHint, bsTrayIcon, bsSkinMenus,
  jpeg,index,UpdatePro,newFrames,newModelUni,UpdateToolForApi, bsMessages,newMobile;

type
  TMainForm = class(TForm)
    diag: TbsSkinInputDialog;
    bsBusinessSkinForm: TbsBusinessSkinForm;
    bsSkinData: TbsSkinData;
    bg: TbsSkinPanel;
    Timer: TTimer;
    bsSkinStatusBar1: TbsSkinStatusBar;
    bsPngImageList: TbsPngImageList;
    bsSkinHint: TbsSkinHint;
    bsSkinImagesMenu1: TbsSkinImagesMenu;
    bsSkinMenuSpeedButton1: TbsSkinMenuSpeedButton;
    Image1: TImage;
    versi: TbsSkinStdLabel;
    bsCompressedSkinList2: TbsCompressedSkinList;
    procedure FormShow(Sender: TObject);
    procedure TimerTimer(Sender: TObject);
    procedure updateProClick(Sender: TObject);
    procedure goIndexClick(Sender: TObject);
    procedure newProClick(Sender: TObject);
    procedure newModelClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormCreate(Sender: TObject);
    procedure bsSkinImagesMenu1ImagesItems5Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
    indexForm:TIndexForm;
    updateProForm:TUpdateProForm;
    NewProForm:TNewProForm;
    NewModelForm:TNewModelForm;
    MobileFream : TMobileFream;
    procedure hideAllFrame;
  end;

var
  MainForm: TMainForm;
  bathPath,Path,oxhidePath:string;
  forms : array of TFrame;
implementation


{$R *.dfm}
procedure TMainForm.goIndexClick(Sender: TObject);
begin
  if indexForm = nil then
  begin
  indexForm := TIndexForm.Create(Application);
  indexForm.Parent := bg;
  indexForm.Align := alClient;

  SetLength(forms,Length(forms)+1);
  forms[Length(forms)-1] := indexForm;
  end;
  hideAllFrame;
  indexForm.Visible := True;
  indexForm.WebBrowser.Navigate(Path + '/doc/index.html');
end;
procedure TMainForm.bsSkinImagesMenu1ImagesItems5Click(Sender: TObject);
begin
  if MobileFream = nil then
  begin
     MobileFream := TMobileFream.Create(Application);
     MobileFream.Parent := bg;
     MobileFream.Align := alClient;
     SetLength(forms,Length(forms)+1);
     forms[Length(forms)-1] := MobileFream;
  end;
  hideAllFrame;
  MobileFream.Init;
  MobileFream.Visible := True;
end;

procedure TMainForm.FormClose(Sender: TObject; var Action: TCloseAction);
begin
//  if Application.MessageBox('确定退出？'#13'代码是否已经生成完毕', '请问', MB_OKCANCEL + MB_ICONWARNING) <> 1 then
//  begin
//     Abort();
//  end;
end;

procedure TMainForm.FormCreate(Sender: TObject);
var
  version:string;
begin
  version := Ini.ReadIni('server','version');
  if version <> '' then
  begin
     versi.Caption := '当前版本：'+version;
  end;
end;

procedure TMainForm.FormShow(Sender: TObject);
begin
    Timer.Enabled := True;
end;
procedure TMainForm.hideAllFrame;
var
  I:Integer;
begin
  for I := 0 to Length(forms) - 1 do
  begin
      forms[I].Visible := False;
  end;
end;
procedure TMainForm.newModelClick(Sender: TObject);
begin
  if NewModelForm = nil then
  begin
     NewModelForm := TNewModelForm.Create(Application);
     NewModelForm.Parent := bg;
     NewModelForm.Align := alClient;

     SetLength(forms,Length(forms)+1);
     forms[Length(forms)-1] := NewModelForm;

  end;
  hideAllFrame;
  NewModelForm.init;
  NewModelForm.Visible := True;
end;
procedure TMainForm.newProClick(Sender: TObject);
begin
  if NewProForm = nil then
  begin
     NewProForm := TNewProForm.Create(Application);
     NewProForm.Parent := bg;
     NewProForm.Align := alClient;

     SetLength(forms,Length(forms)+1);
     forms[Length(forms)-1] := NewProForm;
  end;
  NewProForm.Init;
  hideAllFrame;
  NewProForm.Visible := True;
end;
procedure TMainForm.TimerTimer(Sender: TObject);
var
  temp:TStrings;
begin
    Timer.Enabled := False;
    if not DirectoryExists(ExtractFileDir(PARAMSTR(0)) + '\logs') then CreateDirectory(PChar(ExtractFilePath(ParamStr(0)) + '\logs'), nil);
    if not DirectoryExists(ExtractFileDir(PARAMSTR(0)) + '\bak') then CreateDirectory(PChar(ExtractFilePath(ParamStr(0)) + '\bak'), nil);
    if not DirectoryExists(ExtractFileDir(PARAMSTR(0)) + '\res\box') then ForceDirectories(PChar(ExtractFilePath(ParamStr(0)) + '\res\box'));
    if not FileExists(ExtractFileDir(PARAMSTR(0)) + '\config.ini') then
    begin
        temp := TStringList.Create;
        temp.Add('[server]');
        temp.Add('path=');
        temp.SaveToFile(ExtractFileDir(PARAMSTR(0)) + '\config.ini');
    end;

    bathPath := Ini.ReadIni('server','path');
    oxhidePath := Ini.ReadIni('server','oxhide');

    Path := bathPath+'\coder';

    if bathPath = '' then
    begin
      bathPath := diag.InputBox('请输入服务器路径！','路径：','');
    end;
    if bathPath = '' then
    begin
       Timer.Enabled := True;
    end
    else
    begin
        Ini.WriteIni('server','path',bathPath);
        Path := bathPath+'\coder';
        UpdateToolForApi.getUpdateInfo(Path, Ini.ReadIni('server','version'),'config.ini','server');
        Image1.Visible := False;
        if indexForm = nil then
        begin
            indexForm := TIndexForm.Create(Application);
            indexForm.Parent := bg;
            indexForm.Align := alClient;

            SetLength(forms,Length(forms)+1);
            forms[Length(forms)-1] := indexForm;
        end;
        hideAllFrame;
        indexForm.Visible := True;
        indexForm.WebBrowser.Navigate(Path +  '/doc/index.html');
    end;
    
end;
procedure TMainForm.updateProClick(Sender: TObject);
begin
  //更新项目资源
  if updateProForm = nil then
  begin
     updateProForm := TUpdateProForm.Create(Application);
     updateProForm.Parent := bg;
     updateProForm.Align := alClient;

     SetLength(forms,Length(forms)+1);
     forms[Length(forms)-1] := updateProForm;
  end;
  hideAllFrame;
  updateProForm.Visible := True;
end;

end.
