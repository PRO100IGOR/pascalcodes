unit TestHookKey_Unit;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, ExtCtrls;

const
  WM_HOOKKEY= WM_USER + $1000;
  HookDLL       = 'Key.dll';
type
  THookProcedure=procedure; stdcall;
  TForm1 = class(TForm)
    Button1: TButton;
    Button2: TButton;
    Memo1: TMemo;
    Timer1: TTimer;
    Button3: TButton;
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure Timer1Timer(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure Button3Click(Sender: TObject);
  private
    { Private declarations }
    FileMapHandle  : THandle;
    PMem     : ^Integer;
    HandleDLL      : THandle;
    HookOn,
    HookOff        : THookProcedure;
    procedure HookKey(var message: TMessage); message  WM_HOOKKEY;

  public
    { Public declarations }
  end;
var
  Form1: TForm1;

implementation

{$R *.DFM}

procedure TForm1.FormCreate(Sender: TObject);
begin
  Memo1.Clear;
  HandleDLL:=LoadLibrary(PChar(ExtractFilePath(Application.Exename)+
                                HookDll) );
  if HandleDLL = 0 then raise Exception.Create('未发现键盘钩子DLL');
  @HookOn :=GetProcAddress(HandleDLL, 'HookOn');
  @HookOff:=GetProcAddress(HandleDLL, 'HookOff');
  IF not assigned(HookOn) or
     not assigned(HookOff)  then
     raise Exception.Create('在给定的 DLL中'+#13+
                           '未发现所需的函数');
  FileMapHandle:=CreateFileMapping( $FFFFFFFF,
                              nil,
                              PAGE_READWRITE,
                              0,
                              SizeOf(Integer),
                              'TestHook');

   if FileMapHandle=0 then
     raise Exception.Create( '创建内存映射文件时出错');
   PMem:=MapViewOfFile(FileMapHandle,FILE_MAP_WRITE,0,0,0);
   PMem^:=Handle;                           
end;

procedure TForm1.HookKey(var message: TMessage);
type
      KbDllHookStruct   =   record   
          vkCode:DWord;
          ScanCode:DWord;   
          Flags:DWord;
          Time:DWord;   
          dwExtraInfo:DWord;   
end;
var
   KeyName : array[0..100] of char;
   Accion      : string;
   P:^KbDllHookStruct;
begin
  P := Pointer(message.LParam);
  //GetKeyNameText(p.vkCode,@KeyName,100);
  if (Message.wParam = WM_KEYDOWN) then Accion:='KEYDOWN'
  else if (Message.wParam = WM_KEYUP) then Accion:='KEYUP'
  else if (Message.wParam = WM_SYSKEYUP) then Accion:='SYSKEYUP'
  else if (Message.wParam = WM_SYSKEYDOWN) then Accion:='SYSKEYDOWN';
  Memo1.Lines.add( Accion+
                      ': '+
                      inttostr(p.vkCode)+':'+inttostr(p.Flags)) ;
end;

procedure TForm1.FormDestroy(Sender: TObject);
begin
 if Assigned(HookOff) then
     HookOff;
 if HandleDLL<>0 then
  FreeLibrary(HandleDLL);
end;

procedure TForm1.Button1Click(Sender: TObject);
var wnd: hwnd;
begin
  if Assigned(HookOn) then
  begin
   HookOn;
   wnd:=findwindow('shell_traywnd' , '');
   ShowWindow(wnd, SW_HIDE);
   timer1.Enabled := true;
   showmessage('HOOK OK');
  end;
end;

procedure TForm1.Timer1Timer(Sender: TObject);
var WHandle: THandle;
begin
  WHandle := FindWindow(nil, 'Windows 任务管理器');
  if WHandle <> 0 then SendMessage (WHandle, WM_CLOSE, 0, 0);
end;

procedure TForm1.Button2Click(Sender: TObject);
var wnd: hwnd;
begin
  timer1.Enabled := false;
  if Assigned(HookOff) then
  begin
   HookOff;
   wnd:=findwindow('shell_traywnd' , '');
   ShowWindow(wnd, SW_SHOW);
  end;
end;

procedure TForm1.Button3Click(Sender: TObject);
begin
  close;
end;

end.
