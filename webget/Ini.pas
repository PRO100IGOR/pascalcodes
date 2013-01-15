{ ini配置文件读取 }
unit Ini;

interface

uses
  SysUtils, IniFiles;

function ReadIni(MainName, ConfigName: string): string; overload;
function ReadIni(FileName, MainName, ConfigName: string): string; overload;
procedure WriteIni(MainName, ConfigName, Value: string);overload;
procedure WriteIni(FileName, MainName, ConfigName,value: string); overload;
procedure DeleteIni(MainName, ConfigName: string);


implementation

//删除配置文件



procedure DeleteIni(MainName, ConfigName: string);
var
  IniFile: TIniFile;
  IniFileName, ReadIt: string;
begin

  IniFileName := ExtractFileDir(PARAMSTR(0)) + '\config.ini';
  if FileExists(IniFileName) then
  begin
    IniFile := TIniFile.Create(IniFileName);
    IniFile.DeleteKey(MainName, ConfigName);
    IniFile.Free;
  end;

end;

function ReadIni(MainName, ConfigName: string): string;
var
  IniFile: TIniFile;
  IniFileName, ReadIt: string;
begin

  IniFileName := ExtractFileDir(PARAMSTR(0)) + '\config.ini';
  if FileExists(IniFileName) then
  begin
    IniFile := TIniFile.Create(IniFileName);
    ReadIt := Trim(IniFile.ReadString(MainName, ConfigName, ''));
    result := ReadIt;
    IniFile.Free;
  end;

end;

procedure WriteIni(MainName, ConfigName, Value: string);
var
  IniFile: TIniFile;
  IniFileName, ReadIt: string;
begin

  IniFileName := ExtractFileDir(PARAMSTR(0)) + '\config.ini';
  if FileExists(IniFileName) then
  begin
    IniFile := TIniFile.Create(IniFileName);
    IniFile.WriteString(MainName, ConfigName, Value);
    IniFile.Free;
  end;

end;
procedure WriteIni(FileName, MainName, ConfigName,value: string);
var
  IniFile: TIniFile;
  IniFileName, ReadIt: string;
begin

  IniFileName := ExtractFileDir(PARAMSTR(0)) + '\configs\'+FileName;
  if FileExists(IniFileName) then
  begin
    IniFile := TIniFile.Create(IniFileName);
    IniFile.WriteString(MainName, ConfigName, Value);
    IniFile.Free;
  end;
end;
function ReadIni(FileName, MainName, ConfigName: string): string;
var
  IniFile: TIniFile;
  IniFileName, ReadIt: string;
begin
  IniFileName := ExtractFileDir(PARAMSTR(0)) + '\configs\' + FileName;
  if FileExists(IniFileName) then
  begin
    IniFile := TIniFile.Create(IniFileName);
    ReadIt := Trim(IniFile.ReadString(MainName, ConfigName, ''));
    result := ReadIt;
    IniFile.Free;
  end;
end;

end.
