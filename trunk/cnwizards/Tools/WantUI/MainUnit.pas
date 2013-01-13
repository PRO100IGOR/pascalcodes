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

unit MainUnit;
{ |<PRE>
================================================================================
* ������ƣ�CnPack ��ִ���ļ���ϵ��������
* ��Ԫ���ƣ��ļ���ϵ������������ʵ�ֵ�Ԫ
* ��Ԫ���ߣ��ܺ�(beta)��beta@01cn.net��
* ��    ע��
* ����ƽ̨��PWinXP SP3 + Delphi 7.1
* ���ݲ��ԣ�PWin9X/2000/XP + Delphi 5/6/7
* �� �� �����õ�Ԫ�е��ַ����ݲ�֧�ֱ��ػ�����ʽ
* ��Ԫ��ʶ��$Id: MainUnit.pas 763 2011-02-07 14:18:23Z liuxiao@cnpack.org $
* �޸ļ�¼��2008.11.15 V1.0
*               �� AegeanSoftware Corp. ���׵� WantUI Դ�����޸Ķ���
================================================================================
|</PRE>}

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ComCtrls, DosCommand, ExtCtrls;

type
  TMainForm = class(TForm)
    lvProjects: TListView;
    edtFileName: TEdit;
    btnBrowseXML: TButton;
    btnBrowseWant: TButton;
    btnLoadXML: TButton;
    btnBuild: TButton;
    statInfo: TStatusBar;
    mmoInfo: TMemo;
    btnAbout: TButton;
    cbbProperties: TComboBox;
    tmrBuild: TTimer;
    procedure FormCreate(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormShow(Sender: TObject);
    procedure btnBrowseXMLClick(Sender: TObject);
    procedure btnBrowseWantClick(Sender: TObject);
    procedure btnLoadXMLClick(Sender: TObject);
    procedure btnBuildClick(Sender: TObject);
    procedure lvProjectsDblClick(Sender: TObject);
    procedure btnAboutClick(Sender: TObject);
    procedure lvProjectsResize(Sender: TObject);
    procedure lvProjectsKeyPress(Sender: TObject; var Key: Char);
    procedure tmrBuildTimer(Sender: TObject);
  private
    Canceled: Boolean;
    DosProcess: TDosCommand;
    Running: Boolean;
    StartTick: DWord;
    WantFile: string;
    function BuildSwitches: string;
    function BuildProject(const Project: string): Boolean;
    function LoadXML(const FileName: string): Boolean;
    procedure OnProcessTerminated(Sender: TObject);
    procedure OnProcessNewLine(Sender: TObject; NewLine: string; OutputType: TOutputType);
    procedure ShowMsg(const MsgStr: string);
    procedure ShowTime(const TimeStr: string = '');
  public
    { Public declarations }
  end;

var
  MainForm: TMainForm;

implementation

uses OmniXML;

const
  DefWantFile = 'want.exe';
  DefXMLFile = 'want.xml';

  SXProject = 'project';
  SXDefault = 'default';
  SXTarget = 'target';
  SXName = 'name';
  SXDescription = 'description';

  CBtnCaptionBuild = '&Build';
  CBtnCaptionTerminate = '&Terminate';

  CBtnCaptions: array [Boolean{Running}] of string = (
    CBtnCaptionBuild, CBtnCaptionTerminate
  );

{$R *.dfm}

function GetTimeStr(Sec: Integer): string;
begin
  if Sec >= 3600 then
    Result := Format('%d hour %d min %d sec', [Sec div 3600, Sec mod 3600 div 60, Sec mod 60])
  else if Sec >= 60 then
    Result := Format('%d min %d sec', [Sec div 60, Sec mod 60])
  else
    Result := Format('%d sec', [Sec]);
end;

{ TMainForm }

procedure TMainForm.FormCreate(Sender: TObject);
var
  AppPath: string;
begin
  DosProcess := TDosCommand.Create(Self);
  DosProcess.OnTerminated := OnProcessTerminated;
  DosProcess.OnNewLine := OnProcessNewLine;

  AppPath := ExtractFilePath(ParamStr(0));
  WantFile := AppPath + DefWantFile;
  edtFileName.Text := AppPath + DefXMLFile;
  if FileExists(ChangeFileExt(Application.ExeName, '.dat')) then
    cbbProperties.Items.LoadFromFile(ChangeFileExt(Application.ExeName, '.dat'));
end;

procedure TMainForm.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  if DosProcess.IsRunning then
    DosProcess.Stop;
end;

procedure TMainForm.FormShow(Sender: TObject);
begin
  btnLoadXMLClick(Sender);
end;

function TMainForm.LoadXML(const FileName: string): Boolean;
var
  XMLDoc: IXMLDocument;
  Root: IXMLElement;
  Item: IXMLNode;
  Def, Name, Disc: string;
  i: Integer;
begin
  Result := False;
  lvProjects.Items.Clear;
  try
    XMLDoc := CreateXMLDoc;
    if XMLDoc.Load(FileName) and Assigned(XMLDoc.DocumentElement) and
      SameText(XMLDoc.DocumentElement.NodeName, SXProject) then
    begin
      Root := XMLDoc.DocumentElement;
      if Assigned(Root.Attributes.GetNamedItem(SXDefault)) then
        Def := Root.Attributes.GetNamedItem(SXDefault).NodeValue
      else
        Def := '';
      for i := 0 to Root.ChildNodes.Length - 1 do
      begin
        Item := Root.ChildNodes.Item[i];
        if SameText(Item.NodeName, SXTarget) then
        begin
          Name := Item.Attributes.GetNamedItem(SXName).NodeValue;
          // TargetName starts with '-' can not be invoked in command line,
          // since it's command switch, we do not display it
          if (Name <> '') and (Name[1] <> '-') then
          begin
            if Assigned(Item.Attributes.GetNamedItem(SXDescription)) then
              Disc := Item.Attributes.GetNamedItem(SXDescription).NodeValue
            else
              Disc := '';
            with lvProjects.Items.Add do
            begin
              Caption := Name;
              SubItems.Add(Disc);
              if CompareStr(Def, Name) = 0 then
              begin
                lvProjects.Selected := lvProjects.Items[Index];
                lvProjects.ItemFocused := lvProjects.Selected;
              end;
            end;
          end;            
        end;
      end;
      Result := True;
    end;
  except
    on E: Exception do OutputDebugString(PChar(E.Message));
  end;
end;

function TMainForm.BuildSwitches: string;
const
  SPropertyDefSwitchFmt = '-D%s ';
var
  i: Integer;
  List: TStringList;
begin
  Result := '';
  List := TStringList.Create;
  try
    List.Text := StringReplace(cbbProperties.Text, ';', #13#10, [rfReplaceAll]);
    for i := 0 to List.Count - 1 do
    begin
      if Trim(List[i]) <> '' then
        Result := Result + Format(SPropertyDefSwitchFmt, [Trim(List[i])]);
    end;
  finally
    List.Free;
  end;
  Result := Trim(Result);
end;

function TMainForm.BuildProject(const Project: string): Boolean;
begin
  Result := FileExists(WantFile);
  if Result then
  begin
    ShowMsg('Building...');

    DosProcess.CommandLine := Format('%s %s "%s"', [WantFile, BuildSwitches, Project]);
    StartTick := GetTickCount;
    Running := True;
    Canceled := False;
    btnBuild.Caption := CBtnCaptions[Running];
    DosProcess.Execute;
  end
  else
    ShowMsg('Want file not found.');
end;

procedure TMainForm.btnBrowseXMLClick(Sender: TObject);
begin
  with TOpenDialog.Create(nil) do
    try
      Filter := 'XML File|*.xml|Any File|*.*';
      if Execute then
      begin
        edtFileName.Text := FileName;
        btnLoadXMLClick(Sender);
      end;
    finally
      Free;
    end;
end;

procedure TMainForm.btnBrowseWantClick(Sender: TObject);
begin
  with TOpenDialog.Create(nil) do
    try
      Filter := 'Exe File|*.exe|Any File|*.*';
      if Execute then
      begin
        WantFile := FileName;
      end;
    finally
      Free;
    end;
end;

procedure TMainForm.btnLoadXMLClick(Sender: TObject);
begin
  LoadXML(edtFileName.Text);
  if lvProjects.CanFocus then
    lvProjects.SetFocus;
end;

procedure TMainForm.btnBuildClick(Sender: TObject);
begin
  if not Running then
  begin
    mmoInfo.Clear;
    if lvProjects.Selected <> nil then
      BuildProject(lvProjects.Selected.Caption)
    else
      ShowMsg('No Project to Build.');
  end else
  begin
    if DosProcess.IsRunning then
    begin
      ShowMsg('Terminating...');
      Canceled := True;
      DosProcess.Stop;
    end;
  end;
end;

procedure TMainForm.lvProjectsDblClick(Sender: TObject);
begin
  btnBuildClick(Sender);
end;

procedure TMainForm.btnAboutClick(Sender: TObject);
begin
  ShowMsg('Copyright 2003-2008 AegeanSoftware Corp., 2008-2009 CnPack Team.');
end;

procedure TMainForm.lvProjectsResize(Sender: TObject);
begin
  with lvProjects do
    Column[1].Width := Width - Column[0].Width - 32;
end;

procedure TMainForm.lvProjectsKeyPress(Sender: TObject; var Key: Char);
begin
  if Ord(Key) = VK_RETURN then
  begin
    Key := #0;
    btnBuildClick(Sender);
  end;
end;

procedure TMainForm.OnProcessNewLine(Sender: TObject; NewLine: string;
  OutputType: TOutputType);
begin
  if OutputType = otEntireLine then
    mmoInfo.Lines.Add(NewLine);
end;

procedure TMainForm.OnProcessTerminated(Sender: TObject);
var
  TimeStr: string;
begin
  Running := False;
  TimeStr := GetTimeStr((GetTickCount - StartTick) div 1000);
  if Canceled then
    ShowMsg('User canceled')
  else
    if DosProcess.ExitCode = 0 then
      ShowMsg('Build successful')
    else
      ShowMsg('Build failed');
  ShowTime(TimeStr);
  btnBuild.Caption := CBtnCaptions[Running];
end;

procedure TMainForm.ShowMsg(const MsgStr: string);
begin
  with statInfo.Panels[0] do
    Text := MsgStr;
end;

procedure TMainForm.ShowTime(const TimeStr: string = '');
begin
  with statInfo.Panels[1] do
    if TimeStr <> '' then
      Text := TimeStr
    else
      Text := GetTimeStr((GetTickCount - StartTick) div 1000);
end;

procedure TMainForm.tmrBuildTimer(Sender: TObject);
begin
  if Running then
    ShowTime;
end;

end.
