unit Regedit;

interface
uses
  Windows, Registry, Forms;
procedure SetAutoRun(Active: Boolean); //设置为自动启动 是|否
function getAutoRun: Boolean;
implementation

procedure SetAutoRun(Active: Boolean);
var RegF: TRegistry;
begin
  RegF := TRegistry.Create;
  RegF.RootKey := HKEY_LOCAL_MACHINE;
  try
    RegF.OpenKey('SOFTWARE\Microsoft\Windows\CurrentVersion\Run', True);
    //设置开机是否自动运行
    RegF.DeleteValue(Application.Title);
    if Active then RegF.WriteString(Application.Title, Application.ExeName)
  except
  end;
  RegF.CloseKey;
  RegF.Free;
end;

function getAutoRun: Boolean;
var
  RegF: TRegistry;
begin
    //读取注册表,根据是否设置了开机自动运行,而设置N9的状态
  RegF := TRegistry.Create;
  RegF.RootKey := HKEY_LOCAL_MACHINE;
  try
    RegF.OpenKey('SOFTWARE\Microsoft\Windows\CurrentVersion\Run', True);
    Result := RegF.ValueExists(Application.Title)
  except
  end;
  RegF.CloseKey;
  RegF.Free;
end;

end.

