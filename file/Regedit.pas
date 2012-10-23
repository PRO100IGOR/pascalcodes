unit Regedit;

interface
uses
  Windows, Registry, Forms;
procedure SetAutoRun(Active: Boolean); //����Ϊ�Զ����� ��|��
function getAutoRun: Boolean;
implementation

procedure SetAutoRun(Active: Boolean);
var RegF: TRegistry;
begin
  RegF := TRegistry.Create;
  RegF.RootKey := HKEY_LOCAL_MACHINE;
  try
    RegF.OpenKey('SOFTWARE\Microsoft\Windows\CurrentVersion\Run', True);
    //���ÿ����Ƿ��Զ�����
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
    //��ȡע���,�����Ƿ������˿����Զ�����,������N9��״̬
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

