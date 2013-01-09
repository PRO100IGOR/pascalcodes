unit ErrorLogsUnit;

interface
uses
  SysUtils;
procedure addErrors(Value: string);
implementation

procedure addErrors(Value: string);
var
  FilesName: string;
  FLogs: TextFile;
begin
  FilesName := ExtractFileDir(PARAMSTR(0)) + '\logs\' + FormatDateTime('yyyy-mm-dd', now);
  AssignFile(FLogs, FilesName);
  if FileExists(FilesName) then
  begin
    Append(FLogs);
  end
  else
  begin
    ReWrite(FLogs);
  end;
  if Value <> '' then
    WriteLn(FLogs, FormatDateTime('hh:mm:ss', now) + ' : ' + Value);
  CloseFile(FLogs);
end;

end.
