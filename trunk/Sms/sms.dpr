program sms;

uses
  Forms,SysUtils,Dialogs,
  MainFormLib in 'MainFormLib.pas' {MainForm},
  Common in 'tool\Common.pas',
  ErrorLogsUnit in 'tool\ErrorLogsUnit.pas',
  superobject in 'tool\superobject.pas',
  SmsLib in 'interface\SmsLib.pas',
  SmsObj in 'interface\SmsObj.pas';

{$R *.res}
begin
  //3个参数，端口 串口 波特率
  if ParamCount <> 3 then Exit;
  Application.Initialize;
  Application.Title := '四和短信猫';
  Application.CreateForm(TMainForm, MainForm);
  MainForm.Port := StrToInt(ParamStr(1));
  MainForm.Com  := StrToInt(ParamStr(2));
  MainForm.BaudRate  := StrToInt(ParamStr(3));
//  MainForm.Port := 4444;
//  MainForm.Com  := 12;
//  MainForm.BaudRate  := 9600;
  MainForm.OpenCom;
  MainForm.OpenPort;
  Application.Run;
end.
