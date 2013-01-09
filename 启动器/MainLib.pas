unit MainLib;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, SvcMgr, Dialogs,MainLoader;

type
  TRunner = class(TService)
    procedure ServiceStart(Sender: TService; var Started: Boolean);
  private
    { Private declarations }
  public
    function GetServiceController: TServiceController; override;
    { Public declarations }
  end;

var
  Runner: TRunner;

implementation

{$R *.DFM}
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
procedure ServiceController(CtrlCode: DWord); stdcall;
begin
  Runner.Controller(CtrlCode);
end;

function TRunner.GetServiceController: TServiceController;
begin
  Result := ServiceController;
end;

procedure TRunner.ServiceStart(Sender: TService; var Started: Boolean);
begin
     LoaderForm.Show;
end;

end.
