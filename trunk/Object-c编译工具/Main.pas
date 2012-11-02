unit Main;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ComCtrls, StdCtrls,FileCtrl,WinSock;

type
  TMainForm = class(TForm)
    GroupBox1: TGroupBox;
    Install: TButton;
    SetPath: TButton;
    Runer: TButton;
    ClearBtn: TButton;
    ShowArea: TMemo;
    InputArea: TEdit;
    procedure InstallClick(Sender: TObject);
    procedure SetPathClick(Sender: TObject);
    procedure ClearBtnClick(Sender: TObject);
    procedure RunerClick(Sender: TObject);
  private
    { Private declarations }
    procedure setMainPath;
  public
    { Public declarations }
  end;

var
  MainForm : TMainForm;
  BasePath : string;
implementation

{$R *.dfm}


function ComputerLocalIP: string; 
var 
 ch: array [ 1 .. 32 ] of char; 
 wsData: TWSAData; 
 myHost: PHostEnt; 
 i: integer; 
begin 
 Result := '' ;
 if WSAstartup( 2 ,wsData) <> 0 then Exit; // can¡¯t start winsock
 try
    if GetHostName(@ch[ 1 ], 32 ) <> 0 then Exit; // getHostName failed
 except 
    Exit;
 end ; 
 myHost := GetHostByName(@ch[ 1 ]); // GetHostName error
 if myHost = nil then exit; 
 for i := 1 to 4 do
 begin 
	Result := Result + IntToStr(Ord(myHost.h_addr^[i - 1 ]));
	if i < 4 then 
	   Result := Result + '.' ;
	end ; 
end ; 

 
function ComputerName: string;
var
 FStr: PChar; 
 FSize: Cardinal;
begin
 FSize := 255 ;
 GetMem(FStr, FSize); 
 Windows.GetComputerName(FStr, FSize); 
 Result := FStr;
 FreeMem(FStr); 
end;

 
function WinUserName: string;
 var 
 FStr: PChar; 
 FSize: Cardinal; 
begin
 FSize := 255 ;
 GetMem(FStr, FSize); 
 GetUserName(FStr, FSize); 
 Result := FStr; 
 FreeMem(FStr); 
end ;


function RunProcess(FileName: string; ShowCmd: DWORD; wait: Boolean; ProcID:PDWORD): Longword;
var
    StartupInfo: TStartupInfo;
    ProcessInfo: TProcessInformation;
begin
    FillChar(StartupInfo, SizeOf(StartupInfo), #0);
    StartupInfo.cb := SizeOf(StartupInfo);
    StartupInfo.dwFlags := STARTF_USESHOWWINDOW or STARTF_FORCEONFEEDBACK;
    StartupInfo.wShowWindow := ShowCmd;
    if not CreateProcess(nil,@Filename[1],nil,nil,False,CREATE_NEW_CONSOLE or NORMAL_PRIORITY_CLASS,nil,nil,StartupInfo,ProcessInfo) then
       Result := WAIT_FAILED
    else
    begin
       if wait = FALSE then
       begin
            if ProcID <> nil then
               ProcID^ := ProcessInfo.dwProcessId;
            result := WAIT_FAILED;
            exit;
       end;
       WaitForSingleObject(ProcessInfo.hProcess, INFINITE);
       GetExitCodeProcess(ProcessInfo.hProcess, Result);
    end;
    if ProcessInfo.hProcess <> 0 then
       CloseHandle(ProcessInfo.hProcess);
    if ProcessInfo.hThread <> 0 then
       CloseHandle(ProcessInfo.hThread);
end;


procedure TMainForm.setMainPath;
var 
 FStr: PChar; 
 FSize: Cardinal;
begin
  ShowArea.Lines.Add('setMainPath: C:\GNUstep');
  BasePath := 'C:\GNUstep';
  if not DirectoryExists(BasePath + '\msys\1.0\home\' + WinUserName) then
  begin
     ShowArea.Lines.Add('setMainPath fail on : ' + BasePath + '\msys\1.0\home\' + WinUserName + ' not exits');
     Exit;
  end;
  if not FileExists(BasePath + '\msys\1.0\msys.bat') then
  begin
     ShowArea.Lines.Add('setMainPath fail on : ' + BasePath + '\msys\1.0\msys.bat not exits');
     Exit;
  end;
  Runer.Enabled := True;
end;

procedure TMainForm.ClearBtnClick(Sender: TObject);
begin
   ShowArea.Lines.Clear;
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



procedure TMainForm.RunerClick(Sender: TObject);
var
  Lines:TStrings;
begin
  Lines := TStringList.Create;
  
end;

procedure TMainForm.SetPathClick(Sender: TObject);
var
  dir: string;
begin
  if Filectrl.SelectDirectory('Ñ¡ÔñÄ¿Â¼', '', dir) then
  begin
     BasePath := dir;
     setMainPath;
  end;
end;



end.
