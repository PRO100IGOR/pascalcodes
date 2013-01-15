unit Common;

interface
uses
  ActiveX, SysUtils,Classes,Windows,WinSvc,WinSock,ExtCtrls,StdCtrls,Controls;
const
  XorKey: array[0..7] of Byte = ($B2, $09, $AA, $55, $93, $6D, $84, $47); //字符串加密用

type
  StringArray = array of string;

function CreateOnlyId: string; //产生唯一序列号
function Split(const Source: string; ASplit: string): StringArray; //分割字符串
function SplitToStrings(const Source: string; ASplit: string): TStrings;
function Append(Source:TStrings;ASplit: string):string;       //将TStrings用 ASplit连接
function EncrypKey(Str: string): string; //加密函数
function UncrypKey(Str: string): string; //解密函数
function BooleanToStr(Value: Boolean): string;
function rePlace(const s, source, dest: string): string;  //将  source 中的 s 替换为 dest
function StrToUniCode(text: string): string;
function UnicodeToStr(text: string): string;
function encode(text:String):string;
function decode(text:String):string;
function ServiceGetStatus(sMachine, sService: string ): DWord;
function ServiceInstalled(sMachine, sService : string ) : boolean;  {判断某服务是否安装，未安装返回false，已安装返回true}
function ServiceRunning(sMachine, sService : string ) : boolean;  {判断某服务是否启动，启动返回true，未启动返回false}
function ServiceStopped(sMachine, sService : string ) : boolean;  {判断某服务是否停止，停止返回true，未停止返回false}
function ComputerLocalIP: string;
function ComputerName: string;
function WinUserName: string;
function RunProcess(FileName: string; ShowCmd: DWORD; wait: Boolean; ProcID:PDWORD): Longword;
function RunDOS(const CommandLine: string): string; //执行CMD后返回结果
function getAllFilesFromDir(dir:string;p:string):TStrings; //从指定目录获取到全部指定类型文件


implementation

function encode(text:String):string;
var
  i, len: Integer;
  cur: Integer;
  t: string;
  ws: WideString;
begin
  Result := '';
  ws := text;
  len := Length(ws);
  i := 1;
  while i <= len do
  begin
    cur := Ord(ws[i]);
    if cur > 255 then
    begin
        FmtStr(t, '%4.4X', [cur]);
        Result := Result + '^' + LowerCase(t);
    end
    else
    begin
        if ((cur < 48) or ((cur > 57) and (cur < 65)) or ( (cur > 90) and (cur < 97)) or (cur > 122)) then
        begin
          FmtStr(t, '%2.2X', [cur]);
          Result := Result + '~' + LowerCase(t);
        end
        else
        begin
           Result := Result + ws[i];
        end;

    end;
    Inc(i);
  end;
end;
function decode(text:String):string;
var
  I, Len: Integer;
  temp:string;
begin
  I := 1;
  text := StringReplace(text, #13, '', [rfReplaceAll]);
  text := StringReplace(text, #10, '', [rfReplaceAll]);
  Len := Length(text);
  while I <= Len do
  begin
    temp := text[I];
    if temp = '~' then
    begin
        Result := Result + Widechar(StrToInt('$' + copy(text, I+1, 2)));
        I := I + 3;
    end
    else if temp = '^' then
    begin
       Result := Result + Widechar(StrToInt('$' + copy(text, I+1, 4)));
       I := I + 5;
    end
    else
    begin
       Result := Result + temp;
       Inc(I);
    end;
  end;
  Result := Trim(Result);
end;
function StrToUniCode(text: string): string;
var
  I, len: Integer;
  cur: Integer;
  t: string;
  ws: WideString;
begin
  Result := '';
  ws := text;
  len := Length(ws);
  I := 1;
  Result := 'U';
  while I <= len do
  begin
    cur := Ord(ws[I]);
    FmtStr(t, '%4.4X', [cur]);
    Result := Result + t;
    if I <> len then
      Result := Result + ' U';
    Inc(I);
  end;
end;
function UnicodeToStr(text: string): string;
var
  I, len: Integer;
  ws: WideString;
begin
  ws := '';
  I := 1;
  len := Length(text);
  while I < len do
  begin
    ws := ws + Widechar(StrToInt('$' + copy(text, I, 4)));
    I := I + 4;
  end;
  Result := ws;
end;
function BooleanToStr(Value: Boolean): string;
begin
  if Value then
    Result := 'true'
  else
    Result := 'false';
end;
function CreateOnlyId: string; //产生唯一序列号
var
  AGuid: TGuid;
begin
  if CoCreateGuid(AGuid) = s_OK then begin
    Result := Split(Split(GUIDToString(AGuid), '{')[1], '}')[0];
  end;
end;
function Split(const Source: string; ASplit: string): StringArray;
var
  AStr: string;
  rArray: StringArray;
  I: Integer;
begin
  if Source = '' then
    Exit;
  AStr := Source;
  I := pos(ASplit, Source);
  Setlength(rArray, 0);
  while I <> 0 do
  begin
    Setlength(rArray, Length(rArray) + 1);
    rArray[Length(rArray) - 1] := copy(AStr, 0, I - 1);
    Delete(AStr, 1, I + Length(ASplit) - 1);
    I := pos(ASplit, AStr);
  end;
  Setlength(rArray, Length(rArray) + 1);
  rArray[Length(rArray) - 1] := AStr;
  Result := rArray;
end;
function SplitToStrings(const Source: string; ASplit: string): TStrings;
var
  rArray: StringArray;
  Roles: TStrings;
  I: Integer;
begin
  rArray := Split(Source, ASplit);
  Roles := TStringList.Create;
  for I := 0 to Length(rArray) - 1 do
  begin
    if rArray[I] = '' then Continue;
    if Roles.IndexOf(rArray[I]) = -1 then Roles.Add(rArray[I]);
  end;
  Result := Roles;
end;
function Append(Source:TStrings;ASplit: string):string;
var
  I:Integer;
  Re:String;
begin
  Re := '';
  for I := 0 to Source.Count - 2 do
  begin
     if Trim(Source[I]) <> '' then
     Re := Re +  Source[I]+ASplit;
  end;
  if (Source.Count > 0) and (Trim(Source[Source.Count - 1]) <> '') then   Re := Re + Source[Source.Count - 1];
  Result := Re;
end;
function EncrypKey(Str: string): string; //字符加密函数   这是用的一个异或加密
var
  i, j: Integer;
begin
  Result := '';
  j := 0;
  for i := 1 to Length(Str) do
  begin
    Result := Result + IntToHex(Byte(Str[i]) xor XorKey[j], 2);
    j := (j + 1) mod 8;
  end;
end;
function UncrypKey(Str: string): string; //字符解密函数
var
  i, j: Integer;
begin
  Result := '';
  j := 0;
  for i := 1 to Length(Str) div 2 do
  begin
    Result := Result + Char(StrToInt('$' + Copy(Str, i * 2 - 1, 2)) xor XorKey[j]);
    j := (j + 1) mod 8;
  end;
end;
function rePlace(const s, source, dest: string): string;
var
  ss, ssource, sdest: string;
begin
  ss := s;
  ssource := source;
  sdest := dest;
  while pos(ssource, ss) <> 0 do
  begin
    delete(ss, pos(ssource, ss), length(ssource));
    insert(sdest, ss, pos(ssource, ss));
  end;
  result := ss;
end;
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
function ComputerLocalIP: string;
var
 ch: array [ 1 .. 32 ] of char;
 wsData: TWSAData;
 myHost: PHostEnt;
 i: integer;
begin
 Result := '' ;
 if WSAstartup( 2 ,wsData) <> 0 then Exit; // can’t start winsock
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
function RunDOS(const CommandLine: string): string;
  procedure CheckResult(b: Boolean);
  begin
    if not b then
      raise Exception.Create(SysErrorMessage(GetLastError));
  end;
var
  HRead, HWrite: THandle;
  StartInfo: TStartupInfo;
  ProceInfo: TProcessInformation;
  b: Boolean;
  sa: TSecurityAttributes;
  inS: THandleStream;
  sRet: TStrings;
begin
  Result := '';
  FillChar(sa, sizeof(sa), 0);
  // 设置允许继承，否则在NT和2000下无法取得输出结果
  sa.nLength := sizeof(sa);
  sa.bInheritHandle := True;
  sa.lpSecurityDescriptor := nil;
  b := CreatePipe(HRead, HWrite, @sa, 0);
  CheckResult(b);

  FillChar(StartInfo, sizeof(StartInfo), 0);
  StartInfo.cb := sizeof(StartInfo);
  StartInfo.wShowWindow := SW_HIDE;
  // 使用指定的句柄作为标准输入输出的文件句柄,使用指定的显示方式
  StartInfo.dwFlags := STARTF_USESTDHANDLES or STARTF_USESHOWWINDOW;
  StartInfo.hStdError := HWrite;
  StartInfo.hStdInput := GetStdHandle(STD_INPUT_HANDLE); // HRead;
  StartInfo.hStdOutput := HWrite;
    b := CreateProcess(nil, // lpApplicationName: PChar
      PChar(CommandLine), // lpCommandLine: PChar
      nil, // lpProcessAttributes: PSecurityAttributes
      nil, // lpThreadAttributes: PSecurityAttributes
      True, // bInheritHandles: BOOL
      CREATE_NEW_CONSOLE, nil, nil, StartInfo, ProceInfo);
     CheckResult(b);



  WaitForSingleObject(ProceInfo.hProcess, INFINITE);

  inS := THandleStream.Create(HRead);
  if inS.Size > 0 then
  begin
    sRet := TStringList.Create;
    sRet.LoadFromStream(inS);
    Result := sRet.Text;
    sRet.Free;
  end;
  inS.Free;

  CloseHandle(HRead);
  CloseHandle(HWrite);
end;
function ServiceGetStatus(sMachine, sService: string ): DWord;
var
	schm, schs: SC_Handle;
	ss: TServiceStatus;
	dwStat : DWord;
begin
	dwStat := 0;
	schm := OpenSCManager(PChar(sMachine), Nil, SC_MANAGER_CONNECT);
	if (schm > 0) then
	begin
	    schs := OpenService(schm, PChar(sService), SERVICE_QUERY_STATUS);
	    if(schs > 0) then
	    begin
	      if(QueryServiceStatus(schs, ss))then dwStat := ss.dwCurrentState;
	      CloseServiceHandle(schs);
	    end;
	    CloseServiceHandle(schm);
	end;
	Result := dwStat;
end;
function ServiceInstalled(sMachine, sService : string ) : boolean;
begin
	Result := 0 <> ServiceGetStatus(sMachine, sService);
end;
function ServiceRunning(sMachine, sService : string ) : boolean;
begin
	Result := SERVICE_RUNNING = ServiceGetStatus(sMachine, sService );
end;
function ServiceStopped(sMachine, sService : string ) : boolean;
begin
	Result := SERVICE_STOPPED = ServiceGetStatus(sMachine, sService );
end;
function  getAllFilesFromDir(dir:string;p:string):TStrings; //从指定目录获取到全部指定类型文件
var
  sr:TSearchRec;
  temp:TStrings;
begin
    temp := TStringList.Create;
    if SysUtils.FindFirst(dir + '\'+p, faAnyFile, sr) = 0 then
    begin
      repeat
        if (sr.Name<>'.') and (sr.Name<>'..') then
        begin
          temp.Add(sr.Name);
        end;
      until SysUtils.FindNext(sr) <> 0;
      SysUtils.FindClose(sr);
    end;
    Result := temp;
end;



end.

