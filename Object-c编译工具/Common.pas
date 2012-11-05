unit Common;

interface

uses
  SysUtils, ActiveX, Winsock, Classes,StdCtrls,IdHTTP,Windows,XMLIntf, XMLDoc,Variants,bsSkinBoxCtrls,ShellAPI;
const
  strEncryptCode : String = 'VZHLEPDQKYMGSOJX';
type
  StringArray = array of string;

function Split(const Source: string; ASplit: string): StringArray;

function SplitToStringList(const Source: string; ASplit: string): TStrings; overload;

function SplitToStringList(const Source: string; ASplit: string; Strings: TStrings): TStrings; overload;

function toArr(const Source: string): StringArray; //字符串变为一个数组

function toStringList(const Source: string): TStrings; //字符串变为一个数组

function StrToUniCode(text: string): string;

function UnicodeToStr(text: string): string;

procedure CompletStr(var text: string; Lengths: Integer); // 用0填充text为指定长度

function CheckNum(const V: string): Boolean; //验证是否是数子

function CreateOnlyId: string; //产生唯一序列号

function CompletWeight(text: string; LengthInt, LengthFloat: Integer): string; //格式化重量输出

function GetIPAddr: string; //获取ip地址

function FormatDouble(Source: Double; Format: string): Double; //四舍五入数字

function RandomStr(): string; //随机取得4位a到z之间字符串

function BooleanToStr(va: boolean): string;
function Encrypt(Source: string): string; //解密
function Decrypt(Source: string): string;    //加密

function checkPro(path:String;var mess:string):Boolean; //检查项目中内容是否合法
function checkMobilePro(path:String;var mess:string):Boolean; //检查移动项目中内容是否合法
function checkHasFire(dir:String;p:string):Boolean;    //文件夹内是否有这样的文件
function getAllFilesFromDir(dir:string;p:string):TStrings; //从dir中获取全部指定类型的文件名
procedure changeFileContext(filename,name1,name2:string);  //替换指定文件中的内容

function getClassNameFromPack(pack:string):string;//从包名解析类名


function getIdFromXml(xml:string):string;//从指定xml中读取主键id
procedure getHistoryFromtxt(author: TbsSkinComboBox;fileName:string);overload; //从txt中读取历史内容，并默认选择1
procedure getHistoryFromtxt(author: TbsSkinListBox;fileName:string);overload; //从txt中读取历史内容，并默认选择1
function getValueFromServer(fileName,url:string):TStrings; //从服务器上读取文件内容
function getServiceFromSpring(basePath,className:string;springs:TStrings):string;//从xml中读取spring配置文件中的service
function getPacFromHbm(fileName:string):string;

function trimFileContext(filename:string):TStrings;  //查找xml
function   CopyDirectory(const   Source,   Dest:   string):   boolean;
function encode(text:String):string;    //转换unicode编码
function decode(text:String):string;     //解析unicode编码
function enLargeCode(text:String;key:string):string;     //异或加密
function deLargeCode(text:String;key:string):string;  //异或解密
function ComputerLocalIP: string;
function ComputerName: string;
function WinUserName: string;
function RunProcess(FileName: string; ShowCmd: DWORD; wait: Boolean; ProcID:PDWORD): Longword;
function RunDOS(const CommandLine: string): string; //执行CMD后返回结果
implementation



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
  Len := Length(text);
  text := StringReplace(text, #13, '', [rfReplaceAll]);
  text := StringReplace(text, #10, '', [rfReplaceAll]);
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
end;

function trimFileContext(filename:string):TStrings;  //查找xml
var
  F: TextFile;
  Str: string;
  I: integer;
  TypeStrings: TStrings;
  booleana,bb:Boolean;
begin
  
end;

function getValueFromServer(fileName,url:string):TStrings; //从服务器上读取文件内容
var
  idhtpLog: TIdHTTP;
  Stream: TMemoryStream;
begin
    idhtpLog := TIdHTTP.Create(nil);
    Stream := TMemoryStream.Create;
  try
    idhtpLog.Get(url + '/res/'+fileName, Stream);
    Result := TStringList.Create;
    Stream.SaveToFile(ExtractFileDir(PARAMSTR(0))+'/~temp.bmp');
    Result.LoadFromFile(ExtractFileDir(PARAMSTR(0))+'/~temp.bmp');
    DeleteFile(PChar(ExtractFileDir(PARAMSTR(0))+'/~temp.bmp'));
  finally
    Stream.Free;
    idhtpLog.Free;
  end;
end;

procedure getHistoryFromtxt(author: TbsSkinComboBox;fileName:string); //从txt中读取历史内容，并默认选择1
var
  I:Integer;
  A:array of Integer;
begin
  if FileExists(fileName) then
  begin
    author.Items.LoadFromFile(fileName);
    for I := 0 to author.Items.Count - 1 do begin
        if author.Items[I] = '' then
        begin
             SetLength(A,Length(A) + 1);
             A[Length(A) - 1] := I;
        end;
    end;
    for I := 0 to Length(A) - 1 do
        author.Items.Delete(A[I]);
    if author.Items.Count > 0 then
      author.ItemIndex := 0;
  end;
end;

procedure getHistoryFromtxt(author: TbsSkinListBox;fileName:string); //从txt中读取历史内容，并默认选择1
var
  I:Integer;
  A:array of Integer;
begin
  if FileExists(fileName) then
  begin
    author.Items.LoadFromFile(fileName);

    for I := 0 to author.Items.Count - 1 do begin
        if author.Items[I] = '' then
        begin
             SetLength(A,Length(A) + 1);
             A[Length(A) - 1] := I;
        end;
    end;
    for I := 0 to Length(A) - 1 do
        author.Items.Delete(A[I]);

    if author.Items.Count > 0 then
      author.ItemIndex := 0;
  end;
end;

function getIdFromXml(xml:string):string;//从指定xml中读取主键id
var
  XMLDocument: IXMLDocument;
  rootnode, classNode: IXMLNode;
begin
  if FileExists(xml) then
  begin
      XMLDocument := TXMLDocument.Create(nil);
      XMLDocument.LoadFromFile(xml);
      rootnode := XMLDocument.DocumentElement;
      classNode := rootnode.ChildNodes[0];
      Result := classNode.ChildNodes['id'].Attributes['name'];
      XMLDocument := nil;
  end
  else
  begin
     Result := '';
  end;
end;



function getClassNameFromPack(pack:string):string;//从包名解析类名
begin
  Result := Copy(pack,LastDelimiter('.',pack)+1,999);
end;

function checkHasFire(dir:String;p:string):Boolean;    //文件夹内是否有这样的文件
var
  sr:TSearchRec;
begin
    if SysUtils.FindFirst(dir + '\'+p, faAnyFile, sr) = 0 then
    begin
      repeat
        if (sr.Name<>'.') and (sr.Name<>'..') then
        begin
          Result := True;
          Break;
        end;
      until SysUtils.FindNext(sr) <> 0;
      SysUtils.FindClose(sr);
    end;
    Result := False;
end;
function getAllFilesFromDir(dir:string;p:string):TStrings; //从dir中获取全部指定类型的文件名
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
procedure changeFileContext(filename,name1,name2:string);  //替换指定文件中的内容
var
  F: TextFile;
  Str: string;
  TypeStrings: TStrings;
begin
  TypeStrings := TStringList.Create;
  if FileExists(FileName) then
  begin
    AssignFile(F, FileName);
    Reset(F);
    while not Eof(F) do
    begin
      Readln(F, Str);
      if  Pos(name1,Str) > 0 then
      begin
          TypeStrings.add(StringReplace(Str,name1,name2,[rfReplaceAll,rfIgnoreCase]));
      end
      else
      begin
         TypeStrings.Add(Str);
      end;
    end;
    Closefile(F);
    TypeStrings.SaveToFile(FileName);
  end;


end;




///复制Source整个目录到DEST目录，如果Dest不存在，自动建立，如果DEST存在，那么Source将作为Dest的子目录！
//例如如果要复制E:\Temp整个目录到E:\那么代码为：   copydirectory( 'e:\temp ', 'e:\ '); 
///如果要复制E:\Temp到E:\Test目录下面，那么代码为：CopyDirecotry( 'E:\Temp ', 'E:\TEST ');
function   CopyDirectory(const   Source,   Dest:   string):   boolean;
var 
    fo:   TSHFILEOPSTRUCT; 
begin 
    FillChar(fo,   SizeOf(fo),   0); 
    with   fo   do 
    begin 
        Wnd   :=   0; 
        wFunc   :=   FO_COPY; 
        pFrom   :=   PChar(source+#0); 
        pTo   :=   PChar(Dest+#0); 
        fFlags   :=   FOF_NOCONFIRMATION+FOF_NOCONFIRMMKDIR         ; 
    end; 
    Result   :=   (SHFileOperation(fo)   =   0); 
end;
function checkPro(path:String;var mess:string):Boolean; //检查项目中内容是否合法
begin
    Result:=True;
    if not DirectoryExists(path + '\WebRoot') then
    begin
      mess := '找不到WebRoot！';
      Result:=False;
      Exit;
    end;
    if not DirectoryExists(path + '\src') then
    begin
      mess := '找不到src！';
      Result:=False;
      Exit;
    end;
    if not DirectoryExists(path + '\src\hibernatemap') then
    begin
      CreateDirectory(PChar(path + '\src\hibernatemap'), nil);
      Exit;
    end;
    if not DirectoryExists(path + '\src\springconfig') then
    begin
      CreateDirectory(PChar(path + '\src\springconfig'), nil);
      Exit;
    end;
end;
function checkMobilePro(path:String;var mess:string):Boolean; //检查移动项目中内容是否合法
begin
    Result:=True;
    if not DirectoryExists(path + '\assets') then
    begin
      mess := '找不到assets！';
      Result:=False;
      Exit;
    end;
    if not DirectoryExists(path + '\src') then
    begin
      mess := '找不到src！';
      Result:=False;
      Exit;
    end;
    if not DirectoryExists(path + '\gen') then
    begin
      mess := '找不到gen！';
      Result:=False;
      Exit;
    end;
end;
function Encrypt(Source: string): string;
var
  i, n, j: Integer;
  strTmp: string;
  chrTmp: Char;
begin
//    strEncryptCode := 'VZHLEPDQKYMGSOJX';

  Result := '';
  n := Length(Source);
  if (n <= 0) or (n >= 100) then Exit; // 限制

    // 生成2位长度
  if n < 10 then Result := '0' + IntToStr(n) // 长度
  else Result := IntToStr(n);

    // 生成 00+AABBCCDD....
  for i := 1 to n do
  begin
    chrTmp := Source[i];
    strTmp := IntToHex(Ord(ChrTmp), 2);
    Result := Result + strTmp;
  end;
  n := Length(Result);
  strTmp := Copy(Result, n, 1);
  Delete(Result, n, 1);
  Result := strTmp + Result; // 最后一个字符放到第一个字符
  strTmp := '';
    //
  for i := 1 to n do // 替换
  begin
    case Result[i] of
      '0'..'9':
        strTmp := strTmp + strEncryptCode[StrToInt(Result[i]) + 1];
      'A'..'F', 'a'..'f':
        begin
          j := Ord(UpperCase(Result[i])[1]) - 54; //(-55+1)//91;
          strTmp := strTmp + strEncryptCode[j];
        end;
    end;
  end;
  Result := strTmp;
end;

function Decrypt(Source: string): string;
var
  i, n, j, k: Integer;
  strTmp, strTmp1: string;
    //chrTmp: Char;
begin
  Result := '';
  n := Length(Source);
  if n <= 4 then Exit;

  j := -1;
  strTmp := '';
  for i := 1 to n do
  begin
    StrTmp := Source[i];
    j := Pos(strTmp, strEncryptCode) - 1;
    if j < 0 then break;
        //if j>9 then j := j + 54;

    Result := Result + IntToHex(j, 1);
  end;
  if j < 0 then // 出错
  begin
    Result := '';
    Exit;
  end;

  strTmp := Copy(Result, 1, 1);
  Delete(Result, 1, 1);
  Result := Result + strTmp;
  strTmp := Copy(Result, 1, 2);
  try
    k := StrToInt(strTmp);
  except
    Result := '';
    Exit;
  end;

  if k > ((n - 2) div 2) then // 较验长度
  begin
    Result := '';
    Exit;
  end;
  n := k;
  strTmp := '';
  for i := 1 to n do
  begin
    strTmp1 := Copy(Result, i * 2 + 1, 2);
    j := 0;
    for k := 1 to 2 do
    begin
      case strTmp1[k] of
        '0'..'9':
          j := j * 16 + StrToInt(strTmp1[k]);
        'A'..'F', 'a'..'f':
          begin
            j := j * 16 + Ord(UpperCase(strTmp1[k])[1]) - 55; //91
          end;
      end;
    end;
    strTmp := strTmp + Chr(j);
  end;
  Result := strTmp;
end;

function FormatDouble(Source: Double; Format: string): Double;
var
  Temp: string;
begin
  Temp := FormatFloat(Format, Source);
  Result := StrtoFloat(Temp);
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

function SplitToStringList(const Source: string; ASplit: string): TStrings;
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
    if Roles.IndexOf(rArray[I]) = -1 then
      Roles.Add(rArray[I]);
  end;
  Result := Roles;
end;

function SplitToStringList(const Source: string; ASplit: string; Strings: TStrings): TStrings;
var
  rArray: StringArray;
  I: Integer;
begin
  rArray := Split(Source, ASplit);
  for I := 0 to Length(rArray) - 1 do
  begin
    Strings.Add(rArray[I]);
  end;
  Result := Strings;
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
  Result := '\u';
  while I <= len do
  begin
    cur := Ord(ws[I]);
    FmtStr(t, '%4.4X', [cur]);
    Result := Result + t;
    if I <> len then
      Result := Result + '\u';
    Inc(I);
  end;
end;

// 恢复

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

procedure CompletStr(var text: string; Lengths: Integer); // 用0填充text为指定长度
var
  L, I: Integer;
begin
  L := Lengths - Length(text);
  for I := 0 to L - 1 do
  begin
    text := '0' + text;
  end;

end;

function CreateOnlyId: string; //产生唯一序列号
var
  AGuid: TGuid;
begin
  if CoCreateGuid(AGuid) = s_OK then begin
    Result := Split(Split(GUIDToString(AGuid), '{')[1], '}')[0];
  end;
end;

function CheckNum(const V: string): Boolean;
var
  Temp: Double;
begin
  Result := false;
  try
    Temp := StrtoFloat(V);
    Result := true;
  except

  end;

end;

function CompletWeight(text: string; LengthInt, LengthFloat: Integer): string; //格式化重量输出
var
  SA: StringArray;
  L, I: Integer;
begin
  SA := Split(text, '.');
  L := LengthInt - Length(SA[0]);

  text := SA[0];
  for I := 0 to L - 1 do
  begin
    text := '0' + text;
  end;

  text := text + '.';
  if Length(SA) = 2 then
  begin
    L := LengthFloat - Length(SA[1]);
    text := text + SA[1];
  end
  else
  begin
    L := LengthFloat;
  end;

  for I := 0 to L - 1 do
  begin
    text := text + '0';
  end;
  Result := text;
end;

function toArr(const Source: string): StringArray; //字符串变为一个数组
var
  rArray: StringArray;
  I: Integer;
begin
  for I := 1 to Length(Source) do
  begin
    SetLength(rArray, Length(rArray) + 1);
    rArray[Length(rArray) - 1] := Copy(Source, I, 1);
  end;
  Result := rArray;
end;
function toStringList(const Source: string): TStrings; //字符串变为一个数组
var
  a:TStrings;
  I:Integer;
begin
  a:=TStringList.Create;
  for I := 1 to Length(Source) do
  begin
     a.Add(Copy(Source, I, 1))
  end;
  Result := a;
end;
function GetIPAddr: string; //获取ip地址
type
  TaPInAddr = array[0..10] of PInAddr;
  PaPInAddr = ^TaPInAddr;
var
  phe: PHostEnt;
  pptr: PaPInAddr;
  Buffer: array[0..63] of char;
  I: Integer;
  GInitData: TWSADATA;
begin
  WSAStartup($101, GInitData);
  Result := '';
  GetHostName(Buffer, SizeOf(Buffer));
  phe := GetHostByName(buffer);
  if phe = nil then Exit;
  pptr := PaPInAddr(Phe^.h_addr_list);
  I := 0;
  while pptr^[I] <> nil do begin
    result := StrPas(inet_ntoa(pptr^[I]^));
    Inc(I);
  end;
  WSACleanup;
end;

function RandomStr(): string;
var
  PicName: string;
  I: Integer;
begin
  Randomize;
  for I := 1 to 4 do
    PicName := PicName + chr(97 + random(26));
  RandomStr := PicName;
end;

function BooleanToStr(va: boolean): string;
begin
  if va then Result := 'true'
  else Result := 'false';
end;

function getServiceFromSpring(basePath,className:string;springs:TStrings):string;//从xml中读取spring配置文件中的service
var
  temp:string;
  I,K:Integer;
  XMLDocument: IXMLDocument;
  rootnode, bean: IXMLNode;
begin
  temp := 'applicationcontext-'+ LowerCase(className)+'.xml';
  for I := 0 to springs.Count - 1 do
  begin
    if LowerCase(springs[I]) = temp  then
    begin
        XMLDocument := TXMLDocument.Create(nil);
        XMLDocument.LoadFromFile(basePath+springs[I]);
        rootnode := XMLDocument.DocumentElement;
        for K := 0 to rootnode.ChildNodes.Count - 1 do
        begin
            bean := rootnode.ChildNodes[K];
            if bean.Attributes['parent'] = 'baseTxService' then
            begin
                Result := bean.Attributes['id'];
                XMLDocument := nil;
                Exit;
            end;
        end;
    end;
  end;
end;
function getPacFromHbm(fileName:string):string;
var
  temp:string;
  I,K:Integer;
  XMLDocument: IXMLDocument;
  rootnode, bean: IXMLNode;
begin
  XMLDocument := TXMLDocument.Create(nil);
  XMLDocument.LoadFromFile(fileName);
  rootnode := XMLDocument.DocumentElement;
  Result :=rootnode.ChildNodes[0].Attributes['name'];
  XMLDocument := nil;
end;

function enLargeCode(text:String;key:string):string;
var
  keys : array of byte;
  i,j,k:integer;
begin
  for i := 1 to Length(key) do
  begin
      SetLength(keys,i);
      keys[i-1] := byte(key[i]);
  end;
  Result := '';
  j := 0;
  k := Length(keys);
  for i := 1 to Length(text) do
  begin
    Result := Result + IntToHex(Byte(text[i]) xor keys[j], 2);
    j := (j + 1) mod k;
  end;
end;
function deLargeCode(text:String;key:string):string;
var
  keys : array of byte;
  i,j,k:integer;
begin
  for i := 1 to Length(key) do
  begin
      SetLength(keys,i);
      keys[i-1] := byte(key[i]);
  end;
  Result := '';
  j := 0;
  k := Length(keys);
  for i := 1 to Length(text) div 2 do
  begin
    Result := Result + Char(StrToInt('$' + Copy(text, i * 2 - 1, 2)) xor keys[j]);
    j := (j + 1) mod k;
  end;
end;


end.

