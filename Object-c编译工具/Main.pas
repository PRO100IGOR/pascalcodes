unit Main;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ComCtrls, StdCtrls,FileCtrl,WinSock,Ini,Common;

type

  TMainForm = class(TForm)
    GroupBox1: TGroupBox;
    Install: TButton;
    SetPath: TButton;
    Runer: TButton;
    ClearBtn: TButton;
    ShowArea: TMemo;
    InputArea: TEdit;
    RunMe: TButton;
    OpenDialog: TOpenDialog;
    CSFiles: TButton;
    procedure InstallClick(Sender: TObject);
    procedure SetPathClick(Sender: TObject);
    procedure ClearBtnClick(Sender: TObject);
    procedure RunerClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure CSFilesClick(Sender: TObject);
    procedure RunMeClick(Sender: TObject);
    procedure InputAreaKeyUp(Sender: TObject; var Key: Word;
      Shift: TShiftState);
  private
    { Private declarations }
    procedure setMainPath;
  public
    { Public declarations }
  end;

var
  MainForm : TMainForm;
  ProPath:string;
  fileName :string;
  codes:TStrings;
  his:Integer;
implementation

{$R *.dfm}



procedure TMainForm.setMainPath;
var 
 FStr: PChar; 
 FSize: Cardinal;
begin
  if not FileExists(ReadIni('C','BasePath') + '\bin\gcc.exe') then
  begin
     ShowArea.Lines.Add(ReadIni('C','BasePath') + '\bin\gcc.exe' + ' not exits');
     Exit;
  end;
  if not DirectoryExists(ReadIni('C','BasePath') + '\msys\1.0\home\' + WinUserName) then
  begin
     ShowArea.Lines.Add('setWorkPath fail on : ' + ReadIni('C','BasePath') + '\msys\1.0\home\' + WinUserName + ' not exits');
     Exit;
  end;
  if not FileExists(ReadIni('C','BasePath') + '\msys\1.0\msys.bat') then
  begin
     ShowArea.Lines.Add('setWorkPath fail on : ' +ReadIni('C','BasePath') + '\msys\1.0\msys.bat not exits');
     Exit;
  end;
  ShowArea.Lines.Add('setWorkPath on : ' + ReadIni('C','BasePath'));
  Runer.Enabled := True;
  CSFiles.Enabled := True;
  RunMe.Enabled := True;
end;
procedure TMainForm.ClearBtnClick(Sender: TObject);
begin
   ShowArea.Lines.Clear;
end;
procedure TMainForm.CSFilesClick(Sender: TObject);
begin
  if Filectrl.SelectDirectory('选择项目顶级目录', '', ProPath) then
  begin
     WriteIni('C','ProPath',ProPath);
     ShowArea.Lines.Add('setProPath on : ' + ProPath);
  end;
end;
procedure TMainForm.RunerClick(Sender: TObject);
var
  Lines:TStrings;
begin
  Lines := TStringList.Create;
  OpenDialog.InitialDir := ProPath;
  if OpenDialog.Execute then
  begin
     fileName := OpenDialog.FileName;
     WriteIni('C','FileName',fileName);
     ShowArea.Lines.Add('mainFile is : ' + fileName);
  end;
end;



procedure TMainForm.RunMeClick(Sender: TObject);
var
  code,ProName :string;
begin
  ProName := Copy(ProPath,LastDelimiter('\',ProPath)+1,100);
  code := Format('%6s\bin\gcc.exe '+fileName+' -o '+ProPath+'\'+ProName+'.exe -I '
  +'%6s\GNUstep\System\Library\Headers -L %6s\GNUstep\System\Library\Libraries -lobjc -fobjc-exceptions -lgnustep-base '
  +'-fconstant-string-class=NSConstantString -enable-auto-import',[ReadIni('C','BasePath'),ReadIni('C','BasePath'),ReadIni('C','BasePath')]);
  ShowArea.Lines.Add(RunDOS(code));
  ShowArea.Lines.Add(RunDOS(ProPath + '\' + ProName+'.exe'));
end;

procedure TMainForm.FormCreate(Sender: TObject);
var
   temp:TStrings;
begin
    if not FileExists(ExtractFileDir(PARAMSTR(0)) + '\config.ini') then 
    begin
        temp := TStringList.Create;
        temp.Add('[C]');
        temp.Add('BasePath=');
        temp.SaveToFile(ExtractFileDir(PARAMSTR(0)) + '\config.ini');
    end;
    if ReadIni('C','BasePath') <> '' then
       setMainPath;
    ProPath := ReadIni('C','ProPath');
    if (ProPath <> '') and (DirectoryExists(ProPath)) then
       ShowArea.Lines.Add('setProPath on : ' + ProPath);
    fileName := ReadIni('C','FileName');
    if (fileName <> '') and (FileExists(fileName)) then
       ShowArea.Lines.Add('mainFile is : ' + fileName);
    codes := TStringList.Create;
    his := -1;
end;



procedure TMainForm.SetPathClick(Sender: TObject);
var
  dir: string;
begin
  if Filectrl.SelectDirectory('选择目录', '', dir) then
  begin
     WriteIni('C','BasePath',dir);
     setMainPath;
  end;
end;
procedure TMainForm.InputAreaKeyUp(Sender: TObject; var Key: Word;
  Shift: TShiftState);
var
  code:string;
begin
    if (key = 13)  and (InputArea.Text <> '')then
    begin
       if codes.IndexOf(InputArea.Text) = -1 then
       begin
          codes.Add(InputArea.Text);
          his := -1;
       end;
       code := InputArea.Text;
       InputArea.Text := '';
       try
          ShowArea.Lines.Add(RunDOS(code));
       except
          ShowArea.Lines.Add(RunDOS('cmd /k ' + code));
//          try
//             ShowArea.Lines.Add(RunDOS(GetEnvironmentVariable('Path') + '/' +  InputArea.Text));      //获取系统变量
//          except
//             ShowArea.Lines.Add(RunDOS(GetEnvironmentVariable('Path') + '/' + InputArea.Text));
//          end;
       end;
    end
//    else if key = 38 then
//    begin
//       if his = -1 then
//       begin
//          his := codes.Count - 1;
//       end
//       else if his > 0 then
//       begin
//          Dec(his);
//       end;
//       if (his > 0) and (his < codes.count)  then
//       begin
//          InputArea.Text := codes[his];
//       end;
//    end
//    else if Key = 40 then
//    begin
//       if (his > -1) and (his < codes.Count - 1) then
//       begin
//          Inc(his);
//          InputArea.Text := codes[his];
//       end;
//    end;
end;

procedure TMainForm.InstallClick(Sender: TObject);
var
  ProcID: Cardinal;
begin
  RunProcess(ExtractFileDir(PARAMSTR(0)) + '/gnustep/gnustep-msys-system.exe',SW_SHOW,True,@ProcID);
  RunProcess(ExtractFileDir(PARAMSTR(0)) + '/gnustep/gnustep-core.exe',SW_SHOW,True,@ProcID);
  RunProcess(ExtractFileDir(PARAMSTR(0)) + '/gnustep/gnustep-devel.exe',SW_SHOW,True,@ProcID);
  RunProcess(ExtractFileDir(PARAMSTR(0)) + '/gnustep/gnustep-cairo.exe',SW_SHOW,True,@ProcID);
end;


end.
