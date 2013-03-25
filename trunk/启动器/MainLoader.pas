unit MainLoader;

interface

uses
  Windows, Messages, Ini,ShellAPI,SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs,ErrorLogsUnit;

type
  TLoaderForm = class(TForm)
    procedure FormShow(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;
function RunDOS(const CommandLine: string): string; //ִ��CMD�󷵻ؽ��
var
  LoaderForm: TLoaderForm;

implementation

{$R *.dfm}

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
  // ��������̳У�������NT��2000���޷�ȡ��������
  sa.nLength := sizeof(sa);
  sa.bInheritHandle := True;
  sa.lpSecurityDescriptor := nil;
  b := CreatePipe(HRead, HWrite, @sa, 0);
  CheckResult(b);

  FillChar(StartInfo, sizeof(StartInfo), 0);
  StartInfo.cb := sizeof(StartInfo);
  StartInfo.wShowWindow := SW_HIDE;
  // ʹ��ָ���ľ����Ϊ��׼����������ļ����,ʹ��ָ������ʾ��ʽ
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




procedure TLoaderForm.FormShow(Sender: TObject);
var
  FileName :string;
  ProcID: Cardinal;
begin
    FileName := Ini.ReadIni('server','file');
    ShellExecute(Application.Handle, nil, pchar(FileName), nil,nil, SW_SHOW);
   // Application.Terminate;
//   addErrors(RunDOS(FileName));
//    addErrors(GetEnvironmentVariable('JAVA_HOME'));
// ShowMessage(GetEnvironmentVariable('JAVA_HOME'));
end;

end.
