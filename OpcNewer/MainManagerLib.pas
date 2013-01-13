unit MainManagerLib;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ExtCtrls, StdCtrls,Common;

type
  TMainForm = class(TForm)
    GroupBox1: TGroupBox;
    ServerColor: TShape;
    ServerState: TLabel;
    btnStopStart: TButton;
    btnClearLog: TButton;
    btnInstallUnInstall: TButton;
    LogMemo: TMemo;
    Timer: TTimer;
    procedure btnInstallUnInstallClick(Sender: TObject);
    procedure btnStopStartClick(Sender: TObject);
    procedure TimerTimer(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure btnClearLogClick(Sender: TObject);
  private
    { Private declarations }
    procedure InitServiceState;
    procedure ReadLogs;
    procedure LoadLogs;
  public
    { Public declarations }
  end;

var
  MainForm: TMainForm;
  ComputName:string; //�������
  LinesCount :Integer; //��ȡ��������־�ļ��ĵڼ�����.
  HasReaded : Boolean;
implementation

{$R *.dfm}


procedure TMainForm.btnClearLogClick(Sender: TObject);
var
  Dir:string;
  FileName:TStrings;
  I:Integer;
begin
  Dir := ExtractFileDir(PARAMSTR(0)) + '\logs\';
  FileName := Common.getAllFilesFromDir(Dir,'*.log');
  LogMemo.Lines.Clear;
  for I := 0 to FileName.Count - 1 do
      DeleteFile(Dir + FileName[I]);
  LinesCount := -1;
end;

procedure TMainForm.btnInstallUnInstallClick(Sender: TObject);
begin
    if btnInstallUnInstall.Caption = '��װ����' then
    begin
      Common.RunDOS('OpcServers.exe /install');
      btnInstallUnInstall.Caption := 'ж�ط���';
    end
    else
    begin
      Common.RunDOS('sc delete SiheOpc');
      btnInstallUnInstall.Caption := '��װ����';
    end;
    InitServiceState;
end;

procedure TMainForm.btnStopStartClick(Sender: TObject);
begin
  if btnStopStart.Caption = '��������' then
  begin
      Common.RunDOS('net start shService');
      btnStopStart.Caption := 'ֹͣ����';
  end
  else
  begin
      Common.RunDOS('net stop shService');
      btnStopStart.Caption := '��������';
  end;
  InitServiceState;
end;

procedure TMainForm.FormCreate(Sender: TObject);
begin
  if not DirectoryExists(ExtractFileDir(PARAMSTR(0)) + '\logs') then  CreateDirectory(PChar(ExtractFilePath(ParamStr(0)) + '\logs'), nil);
  InitServiceState;
  LinesCount := -1;
  HasReaded := False;
  LoadLogs;
end;
procedure TMainForm.LoadLogs;
var
  FileName,Logs : TStrings;
  I:Integer;
  Dir:string;
begin
  Dir := ExtractFileDir(PARAMSTR(0)) + '\logs\';
  FileName := Common.getAllFilesFromDir(Dir,'*.log');
  Logs := TStringList.Create;
  for I := 0 to FileName.Count - 1 do
  begin
      LogMemo.Lines.Add('==================' + FileName[I] + '==================');
      Logs.LoadFromFile(Dir + FileName[I]);
      LogMemo.Lines.AddStrings(Logs);
      if FileName[I] = FormatDateTime('yyyy-mm-dd', now) then
      begin
         LinesCount :=  Logs.Count;
      end;
  end;
  Logs.Free;
end;
procedure TMainForm.InitServiceState;
var
  install,IsRunning : Boolean;
begin
  if ComputName = '' then
     ComputName := Common.ComputerName;
  install := Common.ServiceInstalled(ComputName,'SiheOpc');
  if not install then
  begin
      ServerColor.Brush.Color := clRed;
      ServerState.Caption := '�ĺ�OPC���ݶ�ȡ������δ��װ!';
      btnStopStart.Enabled := False;
      btnInstallUnInstall.Enabled := True;
  end
  else
  begin
      IsRunning := Common.ServiceRunning(ComputName,'SiheOpc');
      if IsRunning then
      begin
          ServerColor.Brush.Color := clGreen;
          ServerState.Caption := '�ĺ�OPC���ݶ�ȡ����������...';
          btnStopStart.Enabled := True;
          btnStopStart.Caption := 'ֹͣ����';
          btnInstallUnInstall.Enabled := True;
          btnInstallUnInstall.Caption := 'ж�ط���';
      end
      else
      begin
          ServerColor.Brush.Color := clPurple;
          ServerState.Caption := '�ĺ�OPC���ݶ�ȡ������ֹͣ!';
          btnStopStart.Enabled := True;
          btnStopStart.Caption := '��������';
          btnInstallUnInstall.Enabled := True;
          btnInstallUnInstall.Caption := 'ж�ط���'
      end;
  end;
end;

procedure TMainForm.ReadLogs;
var
  Logs : TStrings;
  I:Integer;
begin
  Logs := TStringList.Create;

  if not FileExists(ExtractFileDir(PARAMSTR(0)) + '\logs\' + FormatDateTime('yyyy-mm-dd', now) + '.log') then
     Exit;

  Logs.LoadFromFile(ExtractFileDir(PARAMSTR(0)) + '\logs\' + FormatDateTime('yyyy-mm-dd', now) + '.log');
  if LinesCount = -1 then
  begin
      LogMemo.Lines.AddStrings(Logs);
      LinesCount := Logs.Count;
  end
  else
  begin
      if LinesCount <  Logs.Count  then
      begin
          for I := LinesCount - 1 to Logs.Count - 1 do
          begin
              LogMemo.Lines.Add(Logs[I]);
          end;
          LinesCount := I;
      end
      else  if LinesCount >  Logs.Count then
      begin
         LogMemo.Lines.AddStrings(Logs);
         LinesCount := Logs.Count;
         HasReaded := True;
      end;
  end;
  
end;

procedure TMainForm.TimerTimer(Sender: TObject);
begin
ReadLogs;
if HasReaded then
begin
   LogMemo.Perform(EM_LINESCROLL, 0, LogMemo.Lines.Count);
   HasReaded := False;
end;

end;

end.
