unit Tools;

interface
uses
    Classes,SysUtils,Windows,WinSvc,WinSock,ExtCtrls,StdCtrls,Controls,Uni,OracleUniProvider,MySQLUniProvider,AccessUniProvider,SQLiteUniProvider;
type
{-----------------------------------------------------------------------
	PassType密码结构:
    	PassCode:返回的ACCESS密码
        FileType:如果是Access类型则返回ACCESS-97或ACCESS-2000,否则返回空
------------------------------------------------------------------------}
    TUniQueryArr = class(TPersistent)
    private
      function GetItems(Key: string): TUniQuery;
      function GetCount: Integer;
    public
      Keys: TStrings;
      Values: array of TUniQuery;
      property Items[Key: string]: TUniQuery read GetItems; default;  //获取其单一元素
      property Count: Integer read GetCount;  //获取个数
      function Add(Key: string; Value: TUniQuery): Integer;  //添加元素
      procedure clear;
      function Remove(Key: string): Integer;  //移除
      constructor Create; overload;
      destructor Destroy; override;
    end;
    TStringArr = class(TPersistent)
    private
      function GetItems(Key: string): string;
      function GetCount: Integer;
    public
      Keys: TStrings;
      Values: array of string;
      property Items[Key: string]: string read GetItems; default;  //获取其单一元素
      property Count: Integer read GetCount;  //获取个数
      function Add(Key: string; Value: string): Integer;  //添加元素
      procedure clear;
      function Remove(Key: string): Integer;  //移除
      constructor Create; overload;
    end;
    TDataRows = array of TStringArr;//结果集
    PassType = record
      PassCode: string;
      FileType: string;
    end;
    TDataSource = class(TComponent)
    private
      DataNameP : string;
      DataTypeP : string;
      ServerP   : string;
      PortP     : string;
      UserNameP : string;
      PassWordP : string;
      DataBasep : string;
    published
      property DataName : string read DataNameP write DataNameP;
      property DataBase : string read DataBasep write DataBasep;
      property DataType : string read DataTypeP write DataTypeP;
      property Server   : string read ServerP write ServerP;
      property Port   : string read PortP write PortP;
      property UserName   : string read UserNameP write UserNameP;
      property PassWord   : string read PassWordP write PassWordP;
    public
      isOpen : Boolean;
      FileName:string;
      Connection:TUniConnection;
      constructor Create; overload;
      destructor Destroy; override;
    end;
    TSourceArr = class(TPersistent)
    private
      function GetItems(Key: string): TDataSource;
      function GetCount: Integer;
    public
      Keys: TStrings;
      Values: array of TDataSource;
      property Items[Key: string]: TDataSource read GetItems; default;  //获取其单一元素
      property Count: Integer read GetCount;  //获取个数
      function Add(Key: string; Value: TDataSource): Integer;  //添加元素
      procedure clear;
      function Remove(Key: string): Integer;  //移除
      constructor Create; overload;
    end;
    TSql = class(TPanel)
    private
      SQLP        : TMemo;
      DataSourceP : TComboBox;
      StepIndexP  : Integer;
    Published
      property SQL        : TMemo read SQLP write SQLP;
      property DataSource : TComboBox read DataSourceP write DataSourceP;
      property StepIndex  : Integer read StepIndexP write StepIndexP;
    public
      btnDel : TButton;
      bLable : TLabel;
      constructor Create(AOwner: TComponent;Datas:TStrings;PA:TWinControl);
    end;
    TTask = class(TComponent)
    private
      pname:string;
      psqls:TStrings;
      pdatas:TStrings;
      ptime:Integer;
    Published
      property name  : string read pname write pname;
      property sql   : TStrings read psqls write psqls;
      property data   : TStrings read pdatas write pdatas;
      property time   : Integer read ptime write ptime;
    public
      DataRows1,DataRows2 : TDataRows;
      isRun:Boolean;
      Timer : TTimer;
      AdoConnect : TUniConnection;
      UniQueryArr : TUniQueryArr;
      procedure addSql(sql:TSQL);
      constructor Create(AOwner: TComponent); overload;
      destructor Destroy; override;
    end;
    TTaskArr = class(TPersistent)
    private
      function GetItems(Key: string): TTask;
      function GetCount: Integer;
    public
      Keys: TStrings;
      Values: array of TTask;
      property Items[Key: string]: TTask read GetItems; default;  //获取其单一元素
      property Count: Integer read GetCount;  //获取个数
      function Add(Key: string; Value: TTask): Integer;  //添加元素
      procedure clear;
      function Remove(Key: string): Integer;  //移除
      constructor Create; overload;
    end;
    procedure saveTask(Task:TTask);    //保存任务对象
    function getTask(Name:string):TTask; //读取任务对象
    function getTasks:TTaskArr; //读取全部任务
    function getAllFilesFromDir(dir:string;p:string):TStrings; //从指定目录获取到全部指定类型文件
    procedure saveData(Data:TDataSource);    //保存数据源对象
    function getData(Name:string):TDataSource; //读取数据源对象
    function initData(AOwner: TComponent):TSourceArr; //初始化所数据源
    function ExecFile(FName: string): PassType;
    function ServiceGetStatus(sMachine, sService: string ): DWord;
    function ServiceInstalled(sMachine, sService : string ) : boolean;  {判断某服务是否安装，未安装返回false，已安装返回true}
    function ServiceRunning(sMachine, sService : string ) : boolean;  {判断某服务是否启动，启动返回true，未启动返回false}
    function ServiceStopped(sMachine, sService : string ) : boolean;  {判断某服务是否停止，停止返回true，未停止返回false}
    function ComputerLocalIP: string;
    function ComputerName: string;
    function WinUserName: string;
    function RunProcess(FileName: string; ShowCmd: DWORD; wait: Boolean; ProcID:PDWORD): Longword;
    function RunDOS(const CommandLine: string): string; //执行CMD后返回结果
var
{ 固定密码区域 }
  InhereCode: array[0..9] of Word =($37EC, $FA9C, $E628, $608A, $367B, $B1DF, $4313, $33B1, $5B79, $2A7C);
  InhereCode2: array[0..9] of Word = ($37ED, $FA9D, $E629, $608B, $367A, $B1DE, $4312, $33B0, $5B78, $2A7D);//  用户密码区域 }
  UserCode: array[0..9] of Word  =  ($7B86, $C45D, $DEC6, $3613, $1454, $F2F5, $7477, $2FCF, $E134, $3592);  //89年9月17日后
  InCode97: array[0..19] of byte = ($86, $FB, $EC, $37, $5D, $44, $9C, $FA, $C6, $5E,$28, $E6, $13, $00, $00, $00, $00, $00, $00, $00);

implementation
procedure TTask.addSql(sql:TSQL);
begin
    pdatas.Add(sql.DataSource.Text);
    psqls.Add(sql.SQLP.Text);
end;
constructor TDataSource.Create;
begin
    Connection := nil;
end;
destructor TDataSource.Destroy;
begin
    if Assigned(Connection)then
    begin
        if Connection.Connected  then
        begin
            Connection.Close;
        end;
        Connection.Free;
    end;
end;
constructor TTask.Create(AOwner: TComponent);
begin
    inherited Create(AOwner);
    AdoConnect := nil;
    isRun := False;
    pdatas := TStringList.Create;
    psqls := TStringList.Create;
    UniQueryArr := TUniQueryArr.Create;
end;
destructor TTask.Destroy;
begin
    if Assigned(AdoConnect) then
    begin
        if AdoConnect.Connected  then
        begin
          AdoConnect.Close;
        end;
        AdoConnect.Free;
    end;
    UniQueryArr.Free;
end;
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
constructor TSql.Create(AOwner: TComponent;Datas:TStrings;PA:TWinControl);
var
   Panel : TPanel;
begin
   inherited Create(AOwner);
   Self.Parent := PA;

   Panel := TPanel.Create(AOwner);
   Panel.Parent := Self;
   Panel.Align := alTop;
   Panel.Caption := '';
   Panel.Height := 22;

   DataSource := TComboBox.Create(AOwner);
   DataSource.Style := csDropDownList;
   DataSource.Parent := Panel;
   DataSource.Items := Datas;
   DataSource.Align := alLeft;
   DataSource.Top := 1;
   DataSource.Width := 500;

   btnDel := TButton.Create(AOwner);
   btnDel.Parent := Panel;
   btnDel.Caption := '删除';
   btnDel.Top := 1;
   btnDel.Align := alRight;

   bLable := TLabel.Create(AOwner);
   bLable.Parent := Panel;
   bLable.Caption := '';
   bLable.Top := 1;
   bLable.Align := alRight;

   SQL := TMemo.Create(AOwner);
   SQL.Parent := Self;
   SQL.Align := alClient;
   SQL.ScrollBars := ssVertical;
   Self.Left := 5;
   Self.Height := 120;
   Self.Top := (PA.ControlCount - 1) * 125 + 5;
   Self.Width := 630;
end;
constructor TTaskArr.Create;
begin
  Keys := TStringList.Create;
  SetLength(Values, 0);
end;
procedure TTaskArr.clear;
begin
  SetLength(Values, 0);
  Keys.Clear;
end;
function  TTaskArr.GetItems(Key: string): TTask;
var
  KeyIndex: Integer;
begin
  KeyIndex := Keys.IndexOf(Key);
  if KeyIndex <> -1 then
    Result := Values[KeyIndex]
  else
    Result := nil;
end;
function  TTaskArr.Add(Key: string; Value: TTask): Integer;
begin
  if Keys.IndexOf(Key) = -1 then
  begin
    Keys.Add(Key);
    SetLength(Values, Length(Values) + 1);
    Values[Length(Values) - 1] := Value;
  end
  else
    Values[Keys.IndexOf(Key)] := Value;
  Result := Length(Values) - 1;
end;
function  TTaskArr.GetCount: Integer;
begin
  Result := Keys.Count;
end;
function  TTaskArr.Remove(Key: string): Integer;
var
  Index, Count: Integer;
begin
  Index := Keys.IndexOf(Key);
  Count := Length(Values);
  if Index <> -1 then
  begin
    Keys.Delete(Index);
    Move(Values[Index + 1], Values[Index], (Count - Index) * SizeOf(Values[0]));
    SetLength(Values, Count - 1);
  end;
  Result := Count - 1;
end;
procedure saveData(Data:TDataSource);    //保存数据源对象
var
  BinStream: TMemoryStream;
begin
  BinStream := TMemoryStream.Create;
  try
      BinStream.WriteComponent(Data);
      BinStream.SaveToFile(ExtractFileDir(PARAMSTR(0)) +'\data\'+data.DataName);
  finally
    BinStream.Free;
//    Data.Free;
  end;
end;
function getData(Name:string):TDataSource; //读取数据源对象
var
  BinStream: TMemoryStream;
  Instance:TDataSource;
begin
   Result := nil;
   if FileExists(ExtractFileDir(PARAMSTR(0)) +'\data\' + Name) then
   begin
       BinStream := TMemoryStream.Create;
       Instance := TDataSource.Create(nil);
       try
          BinStream.LoadFromFile(ExtractFileDir(PARAMSTR(0)) +'\data\' + Name);
          BinStream.Seek(0, soFromBeginning);
          Result := TDataSource(BinStream.ReadComponent(Instance));
          Result.Connection := nil;
       finally
          BinStream.Free;
       end;
   end;
end;
function initData(AOwner: TComponent):TSourceArr; //初始化所有数据源
var
  dataFiles : TStrings;
  I:Integer;
  Data : TDataSource;
  OracleUni: TOracleUniProvider;
  MySQLUni: TMySQLUniProvider;
  AccessUni:TAccessUniProvider;
  SQLiteUni:TSQLiteUniProvider;
begin
  dataFiles := getAllFilesFromDir(ExtractFileDir(PARAMSTR(0)) + '\data\','*');
  Result := TSourceArr.Create;
  MySQLUni := nil;
  OracleUni := nil;
  for I := 0 to dataFiles.Count - 1 do
  begin
      Data := getData(dataFiles[I]);
      Data.Connection := TUniConnection.Create(AOwner);
      if Data.DataType = 'MySql' then
      begin
          Data.Connection.Server := Data.Server;
          Data.Connection.Port := StrToInt(Data.Port);
          Data.Connection.Username := Data.UserName;
          Data.Connection.Password := Data.PassWord;
          if  not Assigned(MySQLUni) then
          begin
             MySQLUni := TMySQLUniProvider.Create(AOwner);
             MySQLUni.Name := 'MySql';
          end;
          Data.Connection.SpecificOptions.Add('MySQL.Charset=GBK');
          Data.Connection.Database := Data.DataBase;
      end
      else if Data.DataType = 'Oracle' then
      begin
          Data.Connection := TUniConnection.Create(AOwner);
          Data.Connection.Server := Data.Server;
          Data.Connection.Port := StrToInt(Data.Port);
          Data.Connection.Username := Data.UserName;
          Data.Connection.Password := Data.PassWord;
          if  not Assigned(OracleUni) then
          begin
             OracleUni := TOracleUniProvider.Create(AOwner);
             OracleUni.Name := 'Oracle';
          end;
          Data.Connection.SpecificOptions.Add('Oracle.Direct=True');
      end
      else if Data.DataType = 'Access' then
      begin
          if  not Assigned(AccessUni) then
          begin
             AccessUni := TAccessUniProvider.Create(AOwner);
             AccessUni.Name := 'Access';
          end;
          Data.Connection.Password := Data.PassWord;
      end
      else if Data.DataType = 'SQLite' then
      begin
          if  not Assigned(SQLiteUni) then
          begin
             SQLiteUni := TSQLiteUniProvider.Create(AOwner);
             SQLiteUni.Name := 'SQLite';
          end;
          Data.Connection.SpecificOptions.Add('SQLite.ClientLibrary='+ExtractFileDir(PARAMSTR(0))+'\sqlite3.dll');
          Data.Connection.Password := Data.PassWord;
      end;
      Data.Connection.ProviderName := Data.DataType;
      Result.Add(Data.DataName,Data);
  end;  
end;
procedure saveTask(Task:TTask);
var
  BinStream: TMemoryStream;
begin
  BinStream := TMemoryStream.Create;
  try
      BinStream.WriteComponent(Task);
      BinStream.SaveToFile(ExtractFileDir(PARAMSTR(0)) +'\task\'+Task.pname);
  finally
    BinStream.Free;
  end;
end;
function  getTask(Name:string):TTask;
var
  BinStream: TMemoryStream;
  Instance:TTask;
begin
   Result := nil;
   if FileExists(ExtractFileDir(PARAMSTR(0)) +'\task\' + Name) then
   begin
       BinStream := TMemoryStream.Create;
       Instance := TTask.Create(nil);
       try
          BinStream.LoadFromFile(ExtractFileDir(PARAMSTR(0)) +'\task\' + Name );
          BinStream.Seek(0, soFromBeginning);
          Result := TTask(BinStream.ReadComponent(Instance));
          Result.AdoConnect := nil;
          Result.UniQueryArr := TUniQueryArr.Create;
       finally
          BinStream.Free;
       end;
   end;
end;
function getTasks:TTaskArr; //读取全部任务
var
  TaskFiles : TStrings;
  I:Integer;
  Task : TTask;
begin
  TaskFiles := getAllFilesFromDir(ExtractFileDir(PARAMSTR(0)) + '\task\','*');
  Result := TTaskArr.Create;
  for I := 0 to TaskFiles.Count - 1 do
  begin
      Task := getTask(TaskFiles[I]);
      Result.Add(Task.name,Task);
  end;  
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
function ExecFile(FName: string): PassType;
var
  Stream: TFileStream;
  i, n: integer;
  WTime: TDateTime;
  WSec: DWord;
  Buf: array[0..20] of byte;
  Date0: TDateTime;
  Date1: TDateTime;
  Date2: TDateTime;
  PassCode: string;
  BaseDate: DWord;
  InhereArray: array[0..19] of Word;
  ReaderArray: array[0..19] of Word;
const
  XorStr = $823E6C94;
begin
  Try
  	Stream := TFileStream.Create(FName, fmShareDenyNone);                								//不独占打开文件
  	Stream.Seek($00, 00); Stream.Read(Buf[0], 21);                                                     //取前200位长度
  	If (Buf[$4]<>$53) or (Buf[$5]<>$74) or (Buf[$6]<>$61) or (Buf[$7]<>$6E) or (Buf[$8]<>$64)           //校验是否MDB格式文件 (MDB文件头为 Standard Jet DB)
  		or (Buf[$9]<>$61) or (Buf[$A]<>$72) or (Buf[$B]<>$64) or (Buf[$C]<>$20) or (Buf[$D]<>$4A)
    	or (Buf[$E]<>$65) or (Buf[$F]<>$74) or (Buf[$10]<>$20) or (Buf[$11]<>$44) or (Buf[$12]<>$42) Then
  	begin
  		PassCode:='';
	    Result.PassCode:='';
    	Result.FileType:='';
    	Exit;                                                                                           //不是MDB格式则直接返回,不计算密码
    end else
	if Buf[$14] = 0 then																				//2000的前身,呵呵
	begin
    	PassCode := '';
    	Stream.Seek($42, 00); Stream.Read(Buf[0], 20);
		for i := 0 to 19 do
        Begin
        	N:=Buf[i] xor InCode97[i];
            If N>128 then                                          										//如果是中文件密码(字符ASCII大于128)
            	PassCode := PassCode + Widechar(N)                                 						//返回中文件字符
            Else
				PassCode := PassCode + chr(N);                                     						//普通ASCII字符
        End;
        Result.PassCode := PassCode;
		Result.FileType := 'ACCESS-97';																	//置为97数据库
		Exit; // 按Access97版本处理
    end;
    Date0 := EncodeDate(1978, 7, 01);
  	Date1 := EncodeDate(1989, 9, 17);
  	Date2 := EncodeDate(2079, 6, 05);
    Stream.Seek($42, 00); Stream.Read(ReaderArray[0], 40);												//读文件流(第66起的40位数据)
  	Stream.Seek($75, 00); Stream.Read(BaseDate, 4);                                                     //时间校验位(第177位的一个"字"长度)
  	Stream.Free;
  	if (BaseDate >= $90000000) and (BaseDate < $B0000000) then
    begin
    	WSec := BaseDate xor $903E6C94;
    	WTime := Date2 + WSec / 8192 * 2;
  	end else
    begin
    	WSec := BaseDate xor $803E6C94;
    	WTime := Date1 + WSec / 8192;
    	if WSec and $30000000 <> 0 then
        begin
      		WSec := $40000000 - WSec;
      		WTime := Date1 - WSec / 8192 / 2;
    	end;
  	end;
  	if WTime < Date1 then
    begin
    	for i := 0 to 9 do
        begin
      		InhereArray[i * 2] := (Trunc(WTime) - Trunc(Date0)) xor UserCode[i] xor $F000;
      		InhereArray[i * 2 + 1] := InhereCode[i];
    	end;
  	end else
    begin
    	if WTime >= Date2 then
        begin //2076.6.5之后
      		for i := 0 to 9 do
            begin
        		InhereArray[i * 2] := (Trunc(WTime) - Trunc(Date1)) xor UserCode[i];
        		InhereArray[i * 2 + 1] := InhereCode2[i];
      		end;
    	end else
        begin //2076.6.5之前
      		for i := 0 to 9 do
            begin
        		InhereArray[i * 2] := (Trunc(WTime) - Trunc(Date1)) xor UserCode[i];
        		InhereArray[i * 2 + 1] := InhereCode[i];
      		end;
    	end;
  	end;
  	PassCode := '';
  	for i := 0 to 19 do
    begin
    	N := InhereArray[i] xor ReaderArray[i];
    	if N <> 0 then
    	begin
    		If N>128 then
        		PassCode := PassCode +WideChar(N)														//返回中文字符
        	else
    			PassCode := PassCode + Chr(N);                                                          //返回ASCII字符
    	end;
  	end;
  	Result.FileType := 'ACCESS-2000';
  	Result.PassCode := PassCode;
  Except
  	Begin
  		PassCode:='';
	    Result.PassCode:='';
    	Result.FileType:='';
    End;
  End;
end;
constructor TSourceArr.Create;
begin
  Keys := TStringList.Create;
  SetLength(Values, 0);
end;
procedure TSourceArr.clear;
begin
  SetLength(Values, 0);
  Keys.Clear;
end;
function  TSourceArr.GetItems(Key: string): TDataSource;
var
  KeyIndex: Integer;
begin
  KeyIndex := Keys.IndexOf(Key);
  if KeyIndex <> -1 then
    Result := Values[KeyIndex]
  else
    Result := nil;
end;
function  TSourceArr.Add(Key: string; Value: TDataSource): Integer;
begin
  if Keys.IndexOf(Key) = -1 then
  begin
    Keys.Add(Key);
    SetLength(Values, Length(Values) + 1);
    Values[Length(Values) - 1] := Value;
  end
  else
    Values[Keys.IndexOf(Key)] := Value;
  Result := Length(Values) - 1;
end;
function  TSourceArr.GetCount: Integer;
begin
  Result := Keys.Count;
end;
function  TSourceArr.Remove(Key: string): Integer;
var
  Index, Count: Integer;
begin
  Index := Keys.IndexOf(Key);
  Count := Length(Values);
  if Index <> -1 then
  begin
    Keys.Delete(Index);
    Move(Values[Index + 1], Values[Index], (Count - Index) * SizeOf(Values[0]));
    SetLength(Values, Count - 1);
  end;
  Result := Count - 1;
end;
destructor TUniQueryArr.Destroy;
var
  I:Integer;
begin
  for I := 0 to Count - 1 do
  begin
      if Assigned(Values[I]) then
      begin
         Values[I].Close;
         Values[I].Free;
      end;
  end;
end;
constructor TUniQueryArr.Create;
begin
  Keys := TStringList.Create;
  SetLength(Values, 0);
end;
procedure TUniQueryArr.clear;
begin
  SetLength(Values, 0);
  Keys.Clear;
end;
function  TUniQueryArr.GetItems(Key: string): TUniQuery;
var
  KeyIndex: Integer;
begin
  KeyIndex := Keys.IndexOf(Key);
  if KeyIndex <> -1 then
    Result := Values[KeyIndex]
  else
    Result := nil;
end;
function  TUniQueryArr.Add(Key: string; Value: TUniQuery): Integer;
begin
  if Keys.IndexOf(Key) = -1 then
  begin
    Keys.Add(Key);
    SetLength(Values, Length(Values) + 1);
    Values[Length(Values) - 1] := Value;
  end
  else
    Values[Keys.IndexOf(Key)] := Value;
  Result := Length(Values) - 1;
end;
function  TUniQueryArr.GetCount: Integer;
begin
  Result := Keys.Count;
end;
function  TUniQueryArr.Remove(Key: string): Integer;
var
  Index, Count: Integer;
begin
  Index := Keys.IndexOf(Key);
  Count := Length(Values);
  if Index <> -1 then
  begin
    Keys.Delete(Index);
    Move(Values[Index + 1], Values[Index], (Count - Index) * SizeOf(Values[0]));
    SetLength(Values, Count - 1);
  end;
  Result := Count - 1;
end;
constructor TStringArr.Create;
begin
  Keys := TStringList.Create;
  SetLength(Values, 0);
end;
procedure TStringArr.clear;
begin
  SetLength(Values, 0);
  Keys.Clear;
end;
function  TStringArr.GetItems(Key: string): string;
var
  KeyIndex: Integer;
begin
  KeyIndex := Keys.IndexOf(Key);
  if KeyIndex <> -1 then
    Result := Values[KeyIndex]
  else
    Result := '';
end;
function  TStringArr.Add(Key: string; Value: string): Integer;
begin
  if Keys.IndexOf(Key) = -1 then
  begin
    Keys.Add(Key);
    SetLength(Values, Length(Values) + 1);
    Values[Length(Values) - 1] := Value;
  end
  else
    Values[Keys.IndexOf(Key)] := Value;
  Result := Length(Values) - 1;
end;
function  TStringArr.GetCount: Integer;
begin
  Result := Keys.Count;
end;
function  TStringArr.Remove(Key: string): Integer;
var
  Index, Count: Integer;
begin
  Index := Keys.IndexOf(Key);
  Count := Length(Values);
  if Index <> -1 then
  begin
    Keys.Delete(Index);
    Move(Values[Index + 1], Values[Index], (Count - Index) * SizeOf(Values[0]));
    SetLength(Values, Count - 1);
  end;
  Result := Count - 1;
end;




end.
