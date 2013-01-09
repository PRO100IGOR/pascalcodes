{
	�����Ϻིܶ��ACCESS�ƽ�ԭ��Ĵ��룬��û�п��ǵ��������롣
	������֧��ACCESS��������������ƽ⡣
	���ִ����������ռ�������ԭ���ߣ�����û�����ܴ�Ķ���
	ֻ��������һЩ���ܡ�
		1������OLEֱ�Ӵ򿪴������ACCESS�ļ���
		2����WIN�Ĵ򿪷�ʽ����δ֪���͵��ļ���
		3��ȡWIN�Ķ������ԶԻ���
		4���ļ������ƴ���.����Ŀ¼�ķ��ʡ�
		5������Ϊ���������ACCESS�ļ��Ľ��ܡ�
	ACCESS2000������������ʱ�����ǣ����Խ���ʱҪ��ʱ���
	ȡ�����������


    ����:������

    �ѣ�:12109253

	2008-10-08 14:28

}

unit GetAPass;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, ExtCtrls, ComCtrls, FileCtrl, ImgList, Menus, Buttons,
  SHELLAPI, StrUtils, Clipbrd, ComObj;

{-------------------------------------------
	���Ѷ�����һ�������ļ�ͼ�����������͵Ľṹ��
--------------------------------------------}
  type T_Lst=record
  	Index:integer;
  	Type_:String;
  End;

const
  Model = 'yyyy-mm-dd hh:nn:ss';
{-----------------------------------------------------------------------
	PassType����ṹ:
    	PassCode:���ص�ACCESS����
        FileType:�����Access�����򷵻�ACCESS-97��ACCESS-2000,���򷵻ؿ�
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
    VisitDir:TStringList;                						//���ʼ�¼
    BaseDate: DWord;
    LastPath,                                                   //���Ŀ¼
    PassCode: string;
    InhereArray: array[0..19] of Word;
    ReaderArray: array[0..19] of Word;
    function ExecFile(FName: string): PassType;
    procedure ExecDirectory;
  public
    { Public declarations }
  end;

var
{ �̶��������� }
  InhereCode: array[0..9] of Word =
  ($37EC, $FA9C, $E628, $608A, $367B, $B1DF, $4313, $33B1, $5B79, $2A7C);
  InhereCode2: array[0..9] of Word =
  ($37ED, $FA9D, $E629, $608B, $367A, $B1DE, $4312, $33B0, $5B78, $2A7D);
//  �û��������� }
  UserCode: array[0..9] of Word = //89��9��17�պ�
  ($7B86, $C45D, $DEC6, $3613, $1454, $F2F5, $7477, $2FCF, $E134, $3592);
  InCode97: array[0..19] of byte =
  ($86, $FB, $EC, $37, $5D, $44, $9C, $FA, $C6, $5E,
    $28, $E6, $13, $00, $00, $00, $00, $00, $00, $00);
var
  PassForm: TPassForm;
  ACCDB:Variant;     																					//��OLE��ACCESS���ݿ�(������)
implementation

{$R *.DFM}

procedure TPassForm.ExecDirectory;                  													//�г�Ŀ¼�µ��ļ�
var
  i: integer;
  TP: TSearchRec;
  function CovTime(FD: _FileTime): TDateTime;                      										//��ʽ���ļ�ʱ��
  var
    TCT: _SystemTime;
    Tmp: _FileTime;
  begin
    FileTimeToLocalFileTime(FD, Tmp);
    FileTimeToSystemTime(Tmp, TCT);
    Result := SystemTimeToDateTime(TCT);
  end;
  procedure SetViewImageList(PH_:String);                             									//ȡ·�����ļ�ͼ��
  var
 	ImageList: THandle;
 	FileInfo: TSHFileInfo;
  begin
 	FillChar(FileInfo, SizeOf(FileInfo), #0);
    ImageList := SHGetFileInfo(Pchar(PH_), 0, FileInfo,
                sizeof(TSHFileInfo), SHGFI_SMALLICON+SHGFI_SYSICONINDEX);
    if ImageList <> 0 then ImageList_SMALL.Handle:=ImageList;
  end;
  Function SetImageIndex(File_:String):T_Lst;                      										//ȡ�ļ�ͼ������
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
	procedure FillList(FName:String);                            										//�����б�
	var
  		P: PassType;
  		X:T_Lst;
  		FT: TDateTime;
        isDir:Boolean;
        TmpDir_:String;
	begin
    	If LeftStr(FName,1)='.' then exit;
    	If RightStr(FName,1)='.' then FName:=FName+'.';     											//����Ǵ�"."��Ŀ¼,���һ��"."�󼴿ɷ���(��һ����ԭ���ɵ�"g."Ŀ¼)
    	X:=SetImageIndex(LastPath+FName);
        If (X.Type_='') And (RightStr(FName,1)='.') then
        begin
        	TmpDir_:=LastPath+'~Tmp'+FormatDateTime('HHNNSSZZZ',Now);									//��һ����ʱĿ¼��ȡ���ļ���ͼ�꼰����
            ForceDirectories(TmpDir_);
            X:=SetImageIndex(TmpDir_);
            RemoveDirectory(Pchar(TmpDir_));                                							//�Ƴ���ʱĿ¼
        End;
    	isDir:=Pos('�ļ���',X.Type_)>0;                                         						//�Ƿ��ļ���(���ﲻ��DirectoryExists����Ϊ�����д�.��Ŀ¼)
    	with ListView1.Items.Add do
    	begin
			FT := CovTime(TP.FindData.ftCreationTime);                          						//ת��ʱ��
            ImageIndex:=X.Index;                                                						//ͼ������
	        If isDir then
    	    begin
	      		Caption := ' '+FName;
                SubItems.Add('');
            	SubItems.Add(X.Type_);
                SubItems.Add('');
            End Else
            begin
	      		Caption := FName;
	            SubItems.Add(FormatFloat(',0 KB',Round(TP.Size/1024+0.4999))); 							//�����ļ���С(��Explorer,����С����ֱ�ӽ�λ1K)
    			P := ExecFile(LastPath+FName);                                  						//У���ļ��Ƿ�MDB,����������
	      		If P.FileType='' then
    	  			SubItems.Add(X.Type_)
      			Else SubItems.Add(P.FileType);
	      		SubItems.Add(P.PassCode);
            end;
      		SubItems.Add(FormatDateTime(model, FT));
      		Application.ProcessMessages;
    	end;
	end;        
	Function GPH(LDir_:WideString):String;                                      						//ȡ����Ŀ¼,�����ϼ�ʱ��..
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
    ST_Count.Caption:=Format('%d�� ����',[ListView1.Items.Count]);
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
  	Stream := TFileStream.Create(FName, fmShareDenyNone);                								//����ռ���ļ�
  	Stream.Seek($00, 00); Stream.Read(Buf[0], 21);                                                     //ȡǰ200λ����
  	If (Buf[$4]<>$53) or (Buf[$5]<>$74) or (Buf[$6]<>$61) or (Buf[$7]<>$6E) or (Buf[$8]<>$64)           //У���Ƿ�MDB��ʽ�ļ� (MDB�ļ�ͷΪ Standard Jet DB)
  		or (Buf[$9]<>$61) or (Buf[$A]<>$72) or (Buf[$B]<>$64) or (Buf[$C]<>$20) or (Buf[$D]<>$4A)
    	or (Buf[$E]<>$65) or (Buf[$F]<>$74) or (Buf[$10]<>$20) or (Buf[$11]<>$44) or (Buf[$12]<>$42) Then
  	begin
  		PassCode:='';
	    Result.PassCode:='';
    	Result.FileType:='';
    	Exit;                                                                                           //����MDB��ʽ��ֱ�ӷ���,����������
    end else
	if Buf[$14] = 0 then																				//2000��ǰ��,�Ǻ�
	begin
    	PassCode := '';
    	Stream.Seek($42, 00); Stream.Read(Buf[0], 20);
		for i := 0 to 19 do
        Begin
        	N:=Buf[i] xor InCode97[i];
            If N>128 then                                          										//��������ļ�����(�ַ�ASCII����128)
            	PassCode := PassCode + Widechar(N)                                 						//�������ļ��ַ�
            Else
				PassCode := PassCode + chr(N);                                     						//��ͨASCII�ַ�
        End;
        Result.PassCode := PassCode;
		Result.FileType := 'ACCESS-97';																	//��Ϊ97���ݿ�
		Exit; // ��Access97�汾����
    end;
    Date0 := EncodeDate(1978, 7, 01);
  	Date1 := EncodeDate(1989, 9, 17);
  	Date2 := EncodeDate(2079, 6, 05);
    Stream.Seek($42, 00); Stream.Read(ReaderArray[0], 40);												//���ļ���(��66���40λ����)
  	Stream.Seek($75, 00); Stream.Read(BaseDate, 4);                                                     //ʱ��У��λ(��177λ��һ��"��"����)
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
        begin //2076.6.5֮��
      		for i := 0 to 9 do
            begin
        		InhereArray[i * 2] := (Trunc(WTime) - Trunc(Date1)) xor UserCode[i];
        		InhereArray[i * 2 + 1] := InhereCode2[i];
      		end;
    	end else
        begin //2076.6.5֮ǰ
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
        		PassCode := PassCode +WideChar(N)														//���������ַ�
        	else
    			PassCode := PassCode + Chr(N);                                                          //����ASCII�ַ�
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
	    LB_LEN.Caption:='  ���볤��:  '+Inttostr(LENGTH(WideString(Item.SubItems[2])))+' λ  '
    Else LB_LEN.Caption:='  ';
    H1.Enabled:=Not((Item.SubItems[1]='�ļ���') or (Item.SubItems[1]='Ӧ�ó���'));
end;

procedure TPassForm.Edit2DblClick(Sender: TObject);
begin
	If Edit2.Caption<>'' then
    begin
		Clipboard.Clear;
    	Clipboard.AsText:=Edit2.Caption;
        ShowMessage('�����Ѹ��Ƶ���ճ�壡');
    End;
end;

procedure TPassForm.ListView1DblClick(Sender: TObject);
begin
	If ListView1.SelCount=0 then exit;
	If ListView1.Selected=Nil then exit;
    If (ListView1.Selected.SubItems[1]='ACCESS-97') or (ListView1.Selected.SubItems[1]='ACCESS-2000') then
    begin
        Try                        
	        ACCDB:=CreateOleObject('Access.Application');                                               //��OLE�򿪿��ܴ������ACCESS���ݿ�
            ACCDB.OpenCurrentDatabase(LastPath+Trim(ListView1.Selected.Caption),True,Edit2.caption);
            ACCDB.visible:=True;
        Except ON E:Exception do
        	Begin
            	Application.MessageBox(Pchar('���ļ�ʧ��:'+#13+E.Message),'��ʾ',MB_OK+48);
                VarClear(ACCDB);
            End;
        End;
    end else
    begin
    	//  ����Ϊ�ļ��� ,��˫����ֱ�ӽ���
    	If (pos('�ļ���',ListView1.Selected.SubItems[1])>0) And (LeftStr(ListView1.Selected.Caption,1)=' ') then
        begin
        	Edit1.text:=LastPath+Trim(ListView1.Selected.Caption);
            Button1.click;
        End Else
        //��֪�ļ�����,ֱ�Ӵ��ļ�
		Case ShellExecute(Handle,'OPEN',Pchar(LastPath+Trim(ListView1.Selected.Caption)),'',Pchar(LastPath),SW_SHOW) of
    		5:WinExec(PChar(LastPath+Trim(ListView1.Selected.Caption)), SW_SHOWNORMAL);
    		6..31:H1.Click;																				//δ֪����,���ô򿪷�ʽ���ļ�
    	END;
    end;
end;

procedure TPassForm.Button3Click(Sender: TObject);
var
	Paths_:String;
begin
	//�����ʷ·��
    VisitDir.Clear; 
    Edit1.SetFocus;
	Paths_:=LastPath;
	If SelectDirectory('��ѡ��·��:','',Paths_) then
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
	�򿪷�ʽ
}
procedure TPassForm.H1Click(Sender: TObject);
begin
	//����WINϵͳ�Ĵ򿪷�ʽ
	WinExec(PChar(Format('rundll32.exe shell32.dll,OpenAs_RunDLL %S',[LastPath+Trim(ListView1.Selected.Caption)])), SW_SHOWNORMAL);
end;

{
	���ԶԻ���
}
procedure TPassForm.P1Click(Sender: TObject);
procedure SHOWPRO;                                        												//����WINϵͳ�����ԶԻ���
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
	�������ϼ�Ŀ¼
}
procedure TPassForm.SPB_TOPClick(Sender: TObject);
begin
	If Length(LastPath)<4 then exit;
    Edit1.text:=LastPath+'..\';
    Button1.click;
end;

procedure TPassForm.FormCreate(Sender: TObject);
begin
	VisitDir:=TStringList.Create;            														//��¼��ʷ�����б�
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
			If VisitDir.Count =0 then exit;				//û����ʷ����·��
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

