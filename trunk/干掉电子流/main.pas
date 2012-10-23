unit main;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, OleCtrls, SHDocVw,WebLib,Ini,ErrorLogsUnit;


type
  StringArray = array of string;
  TMainForm = class(TForm)
    procedure FormCreate(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
    procedure doweb;
  end;

function SplitToStringList(const Source: string; ASplit: string): TStrings; overload;
function Split(const Source: string; ASplit: string): StringArray;

var
  MainForm: TMainForm;
  username ,password:TStrings;
  path,path2:string;
  index:Integer;
implementation

{$R *.dfm}

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
    Roles.Add(rArray[I]);
  end;
  Result := Roles;
end;

procedure TMainForm.doweb;
begin
   try
      try
          WebForm.WebBrowser.OleObject.document.getElementByID('id_username').innerText := username[index];
          WebForm.WebBrowser.OleObject.document.getElementByID('id_password').innerText := password[index];
          WebForm.WebBrowser.OleObject.document.parentWindow.eval('document.forms[0].submit();');
          Sleep(5000);
          WebForm.Close;
          WebForm.Free;
          WebForm := TWebForm.Create(Application);
          WebForm.Show;
          WebForm.WebBrowser.Navigate(path2);
      except
         WebForm.WebBrowser.OleObject.document.taskform.opt.Click();
         Application.MessageBox(PChar(username[index]+'ǩ���ɹ���'), '��ʾ', MB_OK);
         ErrorLogsUnit.addErrors(username[index]+'ǩ���ɹ���');
         WebForm.Close;
         WebForm.Free;
         WebForm := TWebForm.Create(Application);
         WebForm.Show;
         WebForm.WebBrowser.Navigate(path);
         Inc(index);
         if index >= username.Count then
         begin
            Application.Terminate;
         end;
      end;
   except
       ErrorLogsUnit.addErrors('�Ѿ�ǩ�������������!');
       Application.Terminate;
   end;
end;

procedure TMainForm.FormCreate(Sender: TObject);
var
  str:TStrings;
  temp:string;
begin
  if not DirectoryExists(ExtractFileDir(PARAMSTR(0)) + '\logs') then CreateDirectory(PChar(ExtractFilePath(ParamStr(0)) + '\logs'), nil);
  if not FileExists(ExtractFilePath(ParamStr(0))+'\config.ini') then
  begin
      str := TStringList.Create;
      str.Add('[server]');
      str.Add('username=');
      str.Add('password=');
      str.Add('path=');
      str.SaveToFile(ExtractFilePath(ParamStr(0))+'\config.ini');

      Application.MessageBox('���ò���ȫ����config.ini������' + #13#10 +
        'username���û�����' + #13#10 + 'password�����룩' + #13#10 +
        'path����������ַ��' + #13#10 + 'path2(�����ַ)'+ #13#10 +'�ٽ��룡', '��ʾ', MB_OK +
        MB_ICONSTOP);
      ErrorLogsUnit.addErrors('�Ҳ����ļ���' + ExtractFilePath(ParamStr(0))+'\config.ini');
      Application.Terminate;
  end;


  temp := Ini.ReadIni('server','username');
  if temp = '' then
  begin
    ErrorLogsUnit.addErrors('�û���û������');
    Application.MessageBox('�û���û�����ã�', '��ʾ', MB_OK + MB_ICONSTOP);
    Application.Terminate;
  end;
  username := SplitToStringList(temp,',');


  temp := Ini.ReadIni('server','password');
  if temp = '' then
  begin
    ErrorLogsUnit.addErrors('����û������');
    Application.MessageBox('����û�����ã�', '��ʾ', MB_OK + MB_ICONSTOP);
    Application.Terminate;
  end;
  password := SplitToStringList(temp,',');


  if username.Count <> password.Count  then
  begin
    ErrorLogsUnit.addErrors('�û��������������һ�£�');
    Application.MessageBox('�û��������������һ�£�', '��ʾ', MB_OK + MB_ICONSTOP);
    Application.Terminate;
  end;


  path := Ini.ReadIni('server','path');
  if path = '' then
  begin
    ErrorLogsUnit.addErrors('��������ַû������');
    Application.MessageBox('��������ַû������', '��ʾ', MB_OK + MB_ICONSTOP);
    Application.Terminate;
  end;


  path2 := Ini.ReadIni('server','path2');
  if path = '' then
  begin
    ErrorLogsUnit.addErrors('�����ַû������');
    Application.MessageBox('�����ַû������', '��ʾ', MB_OK + MB_ICONSTOP);
    Application.Terminate;
  end;

  index := 0;

  if WebForm = nil then
     WebForm := TWebForm.Create(Application);
  WebForm.Show;
  WebForm.WebBrowser.Navigate(path);
end;

end.
