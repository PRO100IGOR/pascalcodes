unit MainUnit;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls,AxNetwork_TLB;

type
  StringArray = array of string;
  TMainForm = class(TForm)
    Memo1: TMemo;
    procedure FormShow(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
    procedure exec;
  end;

var
  MainForm: TMainForm;
  Host,Port,User,Pass,Command,ProName:string;
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
    if Roles.IndexOf(rArray[I]) = -1 then
      Roles.Add(rArray[I]);
  end;
  Result := Roles;
end;

procedure TMainForm.exec;
var
  sshh:Ssh;
  success,channelNum:Integer;
  cmdOutput: String;
begin
  sshh := COSsh.Create();
  sshh.Host :=  Host;
  sshh.Port := StrtoInt(Port);
  sshh.UserName := User;
  sshh.Password := Pass;
  sshh.Command := Command;
  sshh.Run;
  Memo1.Lines.Add('Running, result: ' + IntToStr(sshh.LastError) + ' (' + sshh.GetErrorDescription(sshh.LastError) + ')');
 if( sshh.LastError = 0 )then
  begin
   Memo1.Lines.Add('STDERR: ');
   Memo1.Lines.Add(sshh.StdErr );
	 Memo1.Lines.Add('STDOUT: ');
	 Memo1.Lines.Add(sshh.StdOut );
  end;
  Memo1.Lines.Add('***********' + ProName + '½áÊø*************************');
end;


procedure TMainForm.FormShow(Sender: TObject);
var
  Hosts,Commands:TStrings;
  I:Integer;
begin
    if  FileExists(ExtractFileDir(PARAMSTR(0)) + '\linux.txt') then
    begin
        Hosts := TStringList.Create;
        Hosts.LoadFromFile(ExtractFileDir(PARAMSTR(0)) + '\linux.txt');
        for I := 0 to Hosts.Count - 1 do
        begin
            Commands := SplitToStringList(Hosts[I],',');
            if Commands.Count = 6 then
            begin
                Host := Commands[0];
                Port := Commands[1];
                User := Commands[2];
                Pass := Commands[3];
                Command := Commands[4];
                ProName := Commands[5];
                Memo1.Lines.Add('***********' + ProName + '¿ªÊ¼*************************');
                exec;
            end;
        end;  
    end;
end;

end.
