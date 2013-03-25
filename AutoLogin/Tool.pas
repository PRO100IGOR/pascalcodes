unit Tool;

interface

uses
   Windows,SysUtils,Tlhelp32 ;

   
Function KillTask( ExeFileName: String ): Integer ; //关闭进程 
Function EnableDebugPrivilege: Boolean ; //提升权限 
Function FindProcessId( ExeFileName: String ): THandle ; //查找进程 


implementation


Function FindProcessId( ExeFileName: String ): THandle ; 
Var 
  ContinueLoop: BOOL ; 
  FSnapshotHandle: THandle ; 
  FProcessEntry32: TProcessEntry32 ; 
Begin 
  result := 0 ; 
  FSnapshotHandle := CreateToolhelp32Snapshot( TH32CS_SNAPPROCESS, 0 ) ; 
  FProcessEntry32.dwSize := Sizeof( FProcessEntry32 ) ; 
  ContinueLoop := Process32First( FSnapshotHandle, FProcessEntry32 ) ; 
  While integer( ContinueLoop ) <> 0 Do 
  Begin 
    If UpperCase( FProcessEntry32.szExeFile ) = UpperCase( ExeFileName ) Then 
    Begin 
      result := FProcessEntry32.th32ProcessID ; 
      break ; 
    End ; 
    ContinueLoop := Process32Next( FSnapshotHandle, FProcessEntry32 ) ; 
  End ; 
  CloseHandle( FSnapshotHandle ) ; 
End ; 

Function KillTask( ExeFileName: String ): Integer ; 
Const 
  PROCESS_TERMINATE = $0001 ; 
Var 
  ContinueLoop: boolean ; 
  FSnapshotHandle: THandle ; 
  FProcessEntry32: TProcessEntry32 ; 
Begin 
  Result := 0 ; 
  FSnapshotHandle := CreateToolhelp32Snapshot( TH32CS_SNAPPROCESS, 0 ) ; 
  FProcessEntry32.dwSize := SizeOf( FProcessEntry32 ) ; 
  ContinueLoop := Process32First( FSnapshotHandle, FProcessEntry32 ) ; 

  While Integer( ContinueLoop ) <> 0 Do 
  Begin 
    If ( ( UpperCase( ExtractFileName( FProcessEntry32.szExeFile ) ) = 
      UpperCase( ExeFileName ) ) Or ( UpperCase( FProcessEntry32.szExeFile ) = 
      UpperCase( ExeFileName ) ) ) Then 
      Result := Integer( TerminateProcess( 
        OpenProcess( PROCESS_TERMINATE, 
        BOOL( 0 ), 
        FProcessEntry32.th32ProcessID ), 
        0 ) ) ; 
    ContinueLoop := Process32Next( FSnapshotHandle, FProcessEntry32 ) ; 
  End ; 
  CloseHandle( FSnapshotHandle ) ; 
End ; 

//但是对于服务程序,它会提示"拒绝访问".其实只要程序拥有Debug权限即可: 

Function EnableDebugPrivilege: Boolean ; 

Function EnablePrivilege( hToken: Cardinal ;PrivName: String ;bEnable: Boolean ): Boolean ; 
  Var 
    TP: TOKEN_PRIVILEGES ; 
    Dummy: Cardinal ; 
  Begin 
    TP.PrivilegeCount := 1 ; 
    LookupPrivilegeValue( Nil, pchar( PrivName ), TP.Privileges[ 0 ].Luid ) ; 
    If bEnable Then 
      TP.Privileges[ 0 ].Attributes := SE_PRIVILEGE_ENABLED 
    Else 
      TP.Privileges[ 0 ].Attributes := 0 ; 
    AdjustTokenPrivileges( hToken, False, TP, SizeOf( TP ), Nil, Dummy ) ; 
    Result := GetLastError = ERROR_SUCCESS ; 
  End ; 
Var 
  hToken: Cardinal ; 
Begin 
  OpenProcessToken( GetCurrentProcess, TOKEN_ADJUST_PRIVILEGES, hToken ) ; 
  result := EnablePrivilege( hToken, 'SeDebugPrivilege', True ) ; 
  CloseHandle( hToken ) ; 
End ; 




end.
