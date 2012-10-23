unit HookKey_Unit;

interface
 uses windows,messages;
const
  WM_HOOKKEY = WM_USER + $1000;
  LLKHF_ALTDOWN   =   $20;
  WH_KEYBOARD_LL   =   13;
  procedure HookOn; stdcall;
  procedure HookOff;  stdcall;
implementation
var
  HookDeTeclado     : HHook;
  FileMapHandle     : THandle;
  PViewInteger      : ^Integer;

function CallBackDelHook(Code: Integer; wParam: WPARAM;  lParam: LPARAM): LRESULT; stdcall;
type
      KbDllHookStruct   =   record   
          vkCode:DWord;   
          ScanCode:DWord;   
          Flags:DWord;
          Time:DWord;   
          dwExtraInfo:DWord;   
end;
var
  P:^KbDllHookStruct;
  fFlag:Boolean;
begin
   fFlag := false;
   if code=HC_ACTION then
   begin
     P := Pointer(LPARAM);
     case  WPARAM  of
        WM_KEYDOWN,WM_SYSKEYDOWN,WM_KEYUP,WM_SYSKEYUP:
        begin
     FileMapHandle:=OpenFileMapping(FILE_MAP_READ,False,'TestHook');
     if FileMapHandle<>0 then
     begin
       PViewInteger:=MapViewOfFile(FileMapHandle,FILE_MAP_READ,0,0,0);
       PostMessage(PViewInteger^,WM_HOOKKEY,wParam,lParam);
       UnmapViewOfFile(PViewInteger);
       CloseHandle(FileMapHandle);
     end;
          fFlag  := (P.vkCode = VK_LWIN) or (P.vkCode = VK_RWIN)  or  (P.vkCode = VK_APPS)  //WIN¼ü
                  or ((P.vkCode = VK_TAB) and ((p.flags and LLKHF_ALTDOWN) <> 0))  //ALT+TAB
                  or ((P.vkCode = VK_ESCAPE) and ((p.flags and LLKHF_ALTDOWN) <> 0)) //ALT+Esc
                  or ((p.vkCode  =  VK_CONTROL) and (P.vkCode = LLKHF_ALTDOWN) and (P.vkCode = VK_Delete))
                  or ((p.vkCode = VK_F4) and ((p.flags and LLKHF_ALTDOWN) <> 0)) //ALT+F4
                  or ((p.vkCode = VK_SPACE) and ((p.flags and LLKHF_ALTDOWN) <> 0))
                  or ((p.vkCode = VK_SPACE) or (p.vkCode=VK_F1) or (P.vkCode=VK_LCONTROL) or (p.vkCode=VK_RCONTROL) or (p.vkCode=VK_LSHIFT) or (p.vkCode=VK_RSHIFT))
                  or (((p.vkCode = VK_CONTROL) and (P.vkCode = LLKHF_ALTDOWN and p.flags) and (P.vkCode = VK_Delete)))
                  or ((P.vkCode = VK_ESCAPE) and (GetKeyState(VK_control) <> 0));  //CTL+Esc

        end;
     end;
   end;
   if fFlag then
   begin

     result := 1;
   end
   else  Result := CallNextHookEx(0,Code,wParam,lParam);
end;

procedure HookOn; stdcall;
begin
  HookDeTeclado:=SetWindowsHookEx(WH_KEYBOARD_LL, CallBackDelHook, HInstance, 0);
end;

procedure HookOff;  stdcall;
begin
  UnhookWindowsHookEx(HookDeTeclado);
end;


end.       
