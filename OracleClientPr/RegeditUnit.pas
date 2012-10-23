unit RegeditUnit;

interface
uses
  Windows, Registry, SysUtils;

procedure InitOracle;

implementation

procedure InitOracle;
var
  reg: Tregistry;
begin
  reg := Tregistry.Create;
  try
    reg.RootKey := HKEY_LOCAL_MACHINE;
    reg.CreateKey('\SOFTWARE\ORACLE');
    reg.CreateKey('\SOFTWARE\ORACLE\HOME0');
    reg.CreateKey('\SOFTWARE\ORACLE\ALL_HOMES');
    reg.CreateKey('\SOFTWARE\ORACLE\ALL_HOMES\ID0');
    reg.OpenKey('\SOFTWARE\ORACLE\ALL_HOMES', true);
    reg.WriteString('DEFAULT_HOME', 'HOME0');
    reg.WriteString('HOME_COUNTER', '1');
    reg.WriteString('LAST_HOME', '0');
    reg.CloseKey;
    reg.OpenKey('\SOFTWARE\ORACLE\ALL_HOMES\ID0', true);
    reg.WriteString('NAME', 'OraHomeLYMS');
    reg.WriteString('NLS_LANG', 'SIMPLIFIED CHINESE_CHINA.ZHS16GBK');
    reg.WriteString('PATH', ExtractFileDir(PARAMSTR(0)) + '\oran;'+ExtractFileDir(PARAMSTR(0)) + '\oran\rdbms\mesg');
    reg.CloseKey;
    reg.OpenKey('\SOFTWARE\ORACLE\HOME0', true);
    reg.WriteString('ID', '0');
    reg.WriteString('NLS_LANG', 'SIMPLIFIED CHINESE_CHINA.ZHS16GBK');
    reg.WriteString('ORACLE_BUNDLE_NAME', 'Enterprise');
    reg.WriteString('ORACLE_GROUP_NAME', 'Oracle - OraHomeLYMS');
    reg.WriteString('ORACLE_HOME', ExtractFileDir(PARAMSTR(0)) + '\oran');
    reg.WriteString('ORACLE_HOME_KEY', 'Software\ORACLE\HOME0');
    reg.WriteString('ORACLE_HOME_NAME', 'OraHomeLYMS');
    reg.WriteString('SQLPATH', ExtractFileDir(PARAMSTR(0)) + '\dbs');
    reg.WriteString('NLSRTL33', ExtractFileDir(PARAMSTR(0)) + '\oran\ocommon\nls\ADMIN\DATA');
  finally // ÊÍ·Å×ÊÔ´
    reg.CloseKey;
    reg.Free;
  end;
end;

end.

