unit LogsUnit;

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
  try
    FilesName := ExtractFileDir(PARAMSTR(0)) + '\logs\' + FormatDateTime('yyyy-mm-dd', now) + '.log';
    AssignFile(FLogs, FilesName);
    if FileExists(FilesName) then Append(FLogs)
    else ReWrite(FLogs);
    if Value <> '' then
      WriteLn(FLogs, FormatDateTime('hh:mm:ss', now) + ' : ' + Value)
    else
      WriteLn(FLogs, Value);
    CloseFile(FLogs);
  except
    CloseFile(FLogs);
  end;

end;

end.

