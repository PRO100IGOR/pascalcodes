{
	网络上很多讲解ACCESS破解原理的代码，都没有考虑到中文密码。
	本程序支持ACCESS设置中文密码的破解。
	部分代码自网上收集，尊重原作者，所以没有做很大改动。
	只是增加了一些功能。
		1、采用OLE直接打开带密码的ACCESS文件。
		2、用WIN的打开方式来打开未知类型的文件。
		3、取WIN的对象属性对话框。
		4、文件夹名称带“.”的目录的访问。
		5、设置为中文密码的ACCESS文件的解密。
	ACCESS2000后的密码采用了时间戳标记，所以解密时要将时间戳
	取出后做异或处理。


    编制:黄先生

    ＱＱ:12109253

	2008-10-08 14:28

}

unit GetAPass;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, ExtCtrls, ComCtrls, FileCtrl, ImgList, Menus, Buttons,
  SHELLAPI, StrUtils, Clipbrd, ComObj;

{-------------------------------------------
	自已定义了一个返回文件图标索引及类型的结构体
--------------------------------------------}
  type T_Lst=record
  	Index:integer;
  	Type_:String;
  End;

const
  Model = 'yyyy-mm-dd hh:nn:ss';
{-----------------------------------------------------------------------
	PassType密码结构:
    	PassCode:返回的ACCESS密码
        FileType:如果是Access类型则返回ACCESS-97或ACCESS-2000,否则返回空
------------------------------------------------------------------------}
type
  PassType = record
    PassCode: string;
    FileType: string;
  end;

  TPassForm = class(TForm)
    Button2: TButton;
    ListView1: TListView;
    Button1: TButton;
    ImageList_SMALL: TImageList;
    Panel1: TPanel;
    Label2: TLabel;
    Edit2: TStaticText;
    LB_LEN: TLabel;
    Button3: TBitBtn;
    Edit1: TLabeledEdit;
    LE_TYPE: TLabeledEdit;
    PopupM: TPopupMenu;
    O1: TMenuItem;
    H1: TMenuItem;
    N1: TMenuItem;
    P1: TMenuItem;
    SPB_TOP: TSpeedButton;
    SPB_PRI: TSpeedButton;
    PopupList: TPopupMenu;
    ST_Count: TStaticText;
    procedure Button1Click(Sender: TObject);
    procedure ListView1SelectItem(Sender: TObject; Item: TListItem;
      Selected: Boolean);
    procedure Edit2DblClick(Sender: TObject);
    procedure ListView1DblClick(Sender: TObject);
    procedure Button3Click(Sender: TObject);
    procedure Edit1KeyPress(Sender: TObject; var Key: Char);
    procedure H1Click(Sender: TObject);
    procedure P1Click(Sender: TObject);
    procedure ListView1MouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure SPB_TOPClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure SPB_PRIMouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure PopupListClick(Sender: TObject);
    procedure Button2Click(Sender: TObject);
  private
    { Private declarations }
    VisitDir:TStringList;                						//访问记录
    BaseDate: DWord;
    LastPath,                                                   //最后目录
    PassCode: string;
    InhereArray: array[0..19] of Word;
    ReaderArray: array[0..19] of Word;
    function ExecFile(FName: string): PassType;
    procedure ExecDirectory;
  public
    { Public declarations }
  end;

var
{ 固定密码区域 }
  InhereCode: array[0..9] of Word =
  ($37EC, $FA9C, $E628, $608A, $367B, $B1DF, $4313, $33B1, $5B79, $2A7C);
  InhereCode2: array[0..9] of Word =
  ($37ED, $FA9D, $E629, $608B, $367A, $B1DE, $4312, $33B0, $5B78, $2A7D);
//  用户密码区域 }
  UserCode: array[0..9] of Word = //89年9月17日后
  ($7B86, $C45D, $DEC6, $3613, $1454, $F2F5, $7477, $2FCF, $E134, $3592);
  InCode97: array[0..19] of byte =
  ($86, $FB, $EC, $37, $5D, $44, $9C, $FA, $C6, $5E,
    $28, $E6, $13, $00, $00, $00, $00, $00, $00, $00);
var
  PassForm: TPassForm;
  ACCDB:Variant;     																					//用OLE打开ACCESS数据库(带密码)
implementation

{$R *.DFM}

procedure TPassForm.ExecDirectory;                  													//列出目录下的文件
var
  i: integer;
  TP: TSearchRec;
  function CovTime(FD: _FileTime): TDateTime;                      										//格式化文件时间
  var
    TCT: _SystemTime;
    Tmp: _FileTime;
  begin
    FileTimeToLocalFileTime(FD, Tmp);
    FileTimeToSystemTime(Tmp, TCT);
    Result := SystemTimeToDateTime(TCT);
  end;
  procedure SetViewImageList(PH_:String);                             									//取路径下文件图标
  var
 	ImageList: THandle;
 	FileInfo: TSHFileInfo;
  begin
 	FillChar(FileInfo, SizeOf(FileInfo), #0);
    ImageList := SHGetFileInfo(Pchar(PH_), 0, FileInfo,
                sizeof(TSHFileInfo), SHGFI_SMALLICON+SHGFI_SYSICONINDEX);
    if ImageList <> 0 then ImageList_SMALL.Handle:=ImageList;
  end;
  Function SetImageIndex(File_:String):T_Lst;                      										//取文件图标索引
  var
 	ImageList: THandle;
 	FileInfo: TSHFileInfo;
  begin
	Result.Index :=-1;
    ImageList := SHGetFileInfo(Pchar(File_), 0, FileInfo,
   		SizeOf(FileInfo), SHGFI_SYSICONINDEX+SHGFI_TYPENAME);
    if ImageList <> 0 then
    Begin
    	Result.Index:=FileInfo.iIcon;
        Result.Type_:=FileInfo.szTypeName;
    End;
  end;
	procedure FillList(FName:String);                            										//生成列表
	var
  		P: PassType;
  		X:T_Lst;
  		FT: TDateTime;
        isDir:Boolean;
        TmpDir_:String;
	begin
    	If LeftStr(FName,1)='.' then exit;
    	If RightStr(FName,1)='.' then FName:=FName+'.';     											//如果是带"."的目录,则加一个"."后即可访问(如一键还原生成的"g."目录)
    	X:=SetImageIndex(LastPath+FName);
        If (X.Type_='') And (RightStr(FName,1)='.') then
        begin
        	TmpDir_:=LastPath+'~Tmp'+FormatDateTime('HHNNSSZZZ',Now);									//建一个临时目录来取得文件夹图标及类型
            ForceDirectories(TmpDir_);
            X:=SetImageIndex(TmpDir_);
            RemoveDirectory(Pchar(TmpDir_));                                							//移除临时目录
        End;
    	isDir:=Pos('文件夹',X.Type_)>0;                                         						//是否文件夹(这里不用DirectoryExists是因为可能有带.的目录)
    	with ListView1.Items.Add do
    	begin
			FT := CovTime(TP.FindData.ftCreationTime);                          						//转换时间
            ImageIndex:=X.Index;                                                						//图标索引
	        If isDir then
    	    begin
	      		Caption := ' '+FName;
                SubItems.Add('');
            	SubItems.Add(X.Type_);
                SubItems.Add('');
            End Else
            begin
	      		Caption := FName;
	            SubItems.Add(FormatFloat(',0 KB',Round(TP.Size/1024+0.4999))); 							//计算文件大小(依Explorer,将带小数的直接进位1K)
    			P := ExecFile(LastPath+FName);                                  						//校验文件是否MDB,及计算密码
	      		If P.FileType='' then
    	  			SubItems.Add(X.Type_)
      			Else SubItems.Add(P.FileType);
	      		SubItems.Add(P.PassCode);
            end;
      		SubItems.Add(FormatDateTime(model, FT));
      		Application.ProcessMessages;
    	end;
	end;        
	Function GPH(LDir_:WideString):String;                                      						//取正常目录,返回上级时加..
	var
	i:integer;
    b_:Boolean;
	begin
		Result:=LDIR_;
	    If RightStr(LDIR_,4)<>'\..\' then Exit;
    	If Length(LDIR_)-4<3 then Begin Result:=Copy(LDIR_,1,Length(LDIR_)-3);Exit;End;
	    b_:=false;
    	Result:='';
	    For i:=Length(LDIR_)-4 downto 1 do
    	Begin
	    	If (b_=False) And (LDIR_[i]='\') then Begin b_:=True;Continue;End;
    	    If b_ then
        	Begin
	          	Result:=LDIR_[i]+Result;
    	    End;
	    End; 
	    If RightStr(Result,1)<>'\' then Result:=Result+'\';
	end;
begin
	If LastPath<>'' then VisitDir.Add(LastPath);
	Edit1.Enabled:=false;
    Edit1.text:=GPH(Edit1.text);
	LastPath:=Edit1.text;
	If RightStr(LastPath,1)<>'\' then LastPath:=LastPath+'\';
  	SetViewImageList(LastPath);
  	ListView1.Items.BeginUpdate;
  	ListView1.Items.Clear;
  	Edit2.Caption:='';
  	LB_LEN.Caption:='  ';
  	Screen.Cursor:=crHourGlass;
  	Application.ProcessMessages;
  	i:=FindFirst(LastPath+LE_Type.text, faAnyFile, TP);
    if i=0 then FillList(TP.Name);
    While FindNext(TP)=0 do
  	begin
    	FillList(TP.Name);
  	end;
    FindClose(TP);
  	ListView1.Items.EndUpdate;
    ST_Count.Caption:=Format('%d个 对象',[ListView1.Items.Count]);
  	Screen.Cursor:=crDefault;
    Edit1.Enabled:=True;
	Application.ProcessMessages;
end;

procedure TPassForm.Button1Click(Sender: TObject);
begin
	If Trim(LE_TYPE.Text)='' then LE_TYPE.text:='*.*';
    If Trim(Edit1.Text)='' then Edit1.text:='C:\';
    Button1.Enabled:=false;
  	ExecDirectory;
    Button1.Enabled:=True;
end;

function TPassForm.ExecFile(FName: string): PassType;
var
  Stream: TFileStream;
  i, n: integer;
  WTime: TDateTime;
  WSec: DWord;
  Buf: array[0..20] of byte;
  Date0: TDateTime;
  Date1: TDateTime;
  Date2: TDateTime;
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

procedure TPassForm.ListView1SelectItem(Sender: TObject; Item: TListItem;
  Selected: Boolean);
begin
	If Item<>Nil then Edit2.Caption:=Item.SubItems[2];
    If Item.SubItems[2]<>'' then
	    LB_LEN.Caption:='  密码长度:  '+Inttostr(LENGTH(WideString(Item.SubItems[2])))+' 位  '
    Else LB_LEN.Caption:='  ';
    H1.Enabled:=Not((Item.SubItems[1]='文件夹') or (Item.SubItems[1]='应用程序'));
end;

procedure TPassForm.Edit2DblClick(Sender: TObject);
begin
	If Edit2.Caption<>'' then
    begin
		Clipboard.Clear;
    	Clipboard.AsText:=Edit2.Caption;
        ShowMessage('密码已复制到剪粘板！');
    End;
end;

procedure TPassForm.ListView1DblClick(Sender: TObject);
begin
	If ListView1.SelCount=0 then exit;
	If ListView1.Selected=Nil then exit;
    If (ListView1.Selected.SubItems[1]='ACCESS-97') or (ListView1.Selected.SubItems[1]='ACCESS-2000') then
    begin
        Try                        
	        ACCDB:=CreateOleObject('Access.Application');                                               //用OLE打开可能带密码的ACCESS数据库
            ACCDB.OpenCurrentDatabase(LastPath+Trim(ListView1.Selected.Caption),True,Edit2.caption);
            ACCDB.visible:=True;
        Except ON E:Exception do
        	Begin
            	Application.MessageBox(Pchar('打开文件失败:'+#13+E.Message),'提示',MB_OK+48);
                VarClear(ACCDB);
            End;
        End;
    end else
    begin
    	//  类型为文件夹 ,则双击后直接进入
    	If (pos('文件夹',ListView1.Selected.SubItems[1])>0) And (LeftStr(ListView1.Selected.Caption,1)=' ') then
        begin
        	Edit1.text:=LastPath+Trim(ListView1.Selected.Caption);
            Button1.click;
        End Else
        //已知文件类型,直接打开文件
		Case ShellExecute(Handle,'OPEN',Pchar(LastPath+Trim(ListView1.Selected.Caption)),'',Pchar(LastPath),SW_SHOW) of
    		5:WinExec(PChar(LastPath+Trim(ListView1.Selected.Caption)), SW_SHOWNORMAL);
    		6..31:H1.Click;																				//未知类型,采用打开方式打开文件
    	END;
    end;
end;

procedure TPassForm.Button3Click(Sender: TObject);
var
	Paths_:String;
begin
	//清空历史路径
    VisitDir.Clear; 
    Edit1.SetFocus;
	Paths_:=LastPath;
	If SelectDirectory('请选择路径:','',Paths_) then
    begin
    	Edit1.Text:=Paths_;
        If Edit1.text='' then Edit1.text:='C:\';
		Button1.Click;
    End;
end;

procedure TPassForm.Edit1KeyPress(Sender: TObject; var Key: Char);
begin
	If Key=#13 then Button1.Click;
end;           
{
	打开方式
}
procedure TPassForm.H1Click(Sender: TObject);
begin
	//调用WIN系统的打开方式
	WinExec(PChar(Format('rundll32.exe shell32.dll,OpenAs_RunDLL %S',[LastPath+Trim(ListView1.Selected.Caption)])), SW_SHOWNORMAL);
end;

{
	属性对话框
}
procedure TPassForm.P1Click(Sender: TObject);
procedure SHOWPRO;                                        												//调用WIN系统的属性对话框
var
	SEI: PShellExecuteInfoA;
begin
	New(SEI);
 	try
   		with SEI^ do
   		begin
     		cbSize := SizeOf(SEI^);
     		FMask := SEE_MASK_NOCLOSEPROCESS or SEE_MASK_INVOKEIDLIST or SEE_MASK_FLAG_NO_UI;
     		Wnd := Handle;
     		lpVerb := 'properties';
     		lpFile := Pchar(LastPath+Trim(ListView1.Selected.Caption));
     		lpParameters := nil;
     		lpDirectory := nil;
     		nShow := 0;
     		hInstApp := HInstance;
     		lpIDList := nil;
        end;
   		ShellExecuteEx(SEI);
    finally
   		Dispose(PShellExecuteInfoA(SEI));
    end;
end;
begin
  	SHOWPRO;
end;

procedure TPassForm.ListView1MouseDown(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin     
    If button<>mbRight then exit;
	If ListVIew1.Selected=Nil then exit;
    If ListView1.ItemIndex<0 then exit;
    PopupM.Popup(Mouse.CursorPos.X,Mouse.CursorPos.Y );
end;

{
	返回至上级目录
}
procedure TPassForm.SPB_TOPClick(Sender: TObject);
begin
	If Length(LastPath)<4 then exit;
    Edit1.text:=LastPath+'..\';
    Button1.click;
end;

procedure TPassForm.FormCreate(Sender: TObject);
begin
	VisitDir:=TStringList.Create;            														//记录历史访问列表
end;

procedure TPassForm.FormDestroy(Sender: TObject);
begin
	FreeAndNil(VisitDir);
end;

procedure TPassForm.SPB_PRIMouseUp(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
var
	Lis_:integer;
    MITM:TMenuItem;
begin
	Case Button of
    mbLeft:
    	begin
			If VisitDir.Count =0 then exit;				//没有历史访问路径
	    	Edit1.Text:=VisitDir.Strings[VisitDir.Count-1];
		    VisitDir.Delete(VisitDir.Count-1);
    		Button1.Click;
		    VisitDir.Delete(VisitDir.Count-1);
    	End;
    mbRight:
	    begin
    		PopupList.Items.Clear;
        	For Lis_:=0 to VisitDir.Count-1 do
	        begin
    	    	MITM:=TMenuItem.Create(PopupList);
        	    With MITM do
            	begin
                	Tag:=Lis_;
	            	Caption:=VisitDir.Strings[Lis_];
                    onClick:=PopupListClick;
    	        End;
        	    PopupList.Items.Add(MITM);
	        End;
    		PopupList.Popup(Mouse.CursorPos.X,Mouse.CursorPos.Y );
		End;
    End;
end;

procedure TPassForm.PopupListClick(Sender: TObject);
begin
	Edit1.text:=TMenuItem(Sender).Caption;
    Button1.Click;
    While VisitDir.Count>TMenuItem(Sender).Tag do
    begin
		 VisitDir.Delete(TMenuItem(Sender).Tag);
    End;
end;

procedure TPassForm.Button2Click(Sender: TObject);
begin
	Close;
end;

end.

