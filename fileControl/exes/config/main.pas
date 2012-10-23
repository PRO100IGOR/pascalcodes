unit main;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ALHintBalloon, StdCtrls, Buttons,AccessLib,PerlRegEx;

type
  TmainForm = class(TForm)
    Label2: TLabel;
    Label1: TLabel;
    BOK: TBitBtn;
    BClose: TBitBtn;
    MySqlIp: TEdit;
    MySqlPort: TEdit;
    Hint: TALHintBalloonControl;
    Label3: TLabel;
    username: TEdit;
    password: TEdit;
    Label4: TLabel;
    dataname: TEdit;
    Label5: TLabel;
    Label6: TLabel;
    weburl: TEdit;
    Label7: TLabel;
    webport: TEdit;
    procedure BCloseClick(Sender: TObject);
    procedure BOKClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure MySqlIpKeyPress(Sender: TObject; var Key: Char);
    procedure MySqlPortKeyPress(Sender: TObject; var Key: Char);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  mainForm: TmainForm;
  ParamManage: TParamManage;
  IP, Port,user,pass,db,web,webports: TParam;
  Params: TParams;
  PerlRegEx: TPerlRegEx;
implementation

{$R *.dfm}

procedure TmainForm.BCloseClick(Sender: TObject);
begin
  Close;
end;

procedure TmainForm.BOKClick(Sender: TObject);
begin


  PerlRegEx.RegEx := '^(0|[1-9]\d?|[0-1]\d{2}|2[0-4]\d|25[0-5]).(0|[1-9]\d?|[0-1]\d{2}|2[0-4]\d|25[0-5]).(0|[1-9]\d?|[0-1]\d{2}|2[0-4]\d|25[0-5]).(0|[1-9]\d?|[0-1]\d{2}|2[0-4]\d|25[0-5])$';
  PerlRegEx.Subject := weburl.Text;
  if weburl.Text = '' then
  begin
    Hint.ShowTextHintBalloon(bmtError, '出错了！', '请输入web地址！', 300, 10, 10, weburl, bapBottomLeft);
    Exit;
  end;
  if not PerlRegEx.Match then
  begin
    Hint.ShowTextHintBalloon(bmtError, '出错了！', '请输入正确的服务器地址！', 300, 10, 10, weburl, bapBottomLeft);
    Exit;
  end;

  PerlRegEx.RegEx := '^\d+$';
  PerlRegEx.Subject := webport.Text;
  if webport.Text = '' then
  begin
    Hint.ShowTextHintBalloon(bmtError, '出错了！', '请输入端口！', 300, 10, 10, webport, bapBottomLeft);
    Exit;
  end;
  if not PerlRegEx.Match then
  begin
    Hint.ShowTextHintBalloon(bmtError, '出错了！', '请输入正确的端口！', 300, 10, 10, webport, bapBottomLeft);
    Exit;
  end;

  PerlRegEx.RegEx := '^(0|[1-9]\d?|[0-1]\d{2}|2[0-4]\d|25[0-5]).(0|[1-9]\d?|[0-1]\d{2}|2[0-4]\d|25[0-5]).(0|[1-9]\d?|[0-1]\d{2}|2[0-4]\d|25[0-5]).(0|[1-9]\d?|[0-1]\d{2}|2[0-4]\d|25[0-5])$';
  PerlRegEx.Subject := MySqlIp.Text;
  if MySqlIp.Text = '' then
  begin
    Hint.ShowTextHintBalloon(bmtError, '出错了！', '请输入服务器地址！', 300, 10, 10, MySqlIp, bapBottomLeft);
    Exit;
  end;
  if not PerlRegEx.Match then
  begin
    Hint.ShowTextHintBalloon(bmtError, '出错了！', '请输入正确的服务器地址！', 300, 10, 10, MySqlIp, bapBottomLeft);
    Exit;
  end;

  PerlRegEx.RegEx := '^\d+$';
  PerlRegEx.Subject := MySqlPort.Text;
  if MySqlPort.Text = '' then
  begin
    Hint.ShowTextHintBalloon(bmtError, '出错了！', '请输入端口！', 300, 10, 10, MySqlPort, bapBottomLeft);
    Exit;
  end;
  if not PerlRegEx.Match then
  begin
    Hint.ShowTextHintBalloon(bmtError, '出错了！', '请输入正确的端口！', 300, 10, 10, MySqlPort, bapBottomLeft);
    Exit;
  end;
  if dataname.Text = '' then
  begin
    Hint.ShowTextHintBalloon(bmtError, '出错了！', '请输入目标数据库！', 300, 10, 10, dataname, bapBottomLeft);
    Exit;
  end;
  if username.Text = '' then
  begin
    Hint.ShowTextHintBalloon(bmtError, '出错了！', '请输入用户名！', 300, 10, 10, username, bapBottomLeft);
    Exit;
  end;



  IP.PValue := MySqlIp.Text;
  Port.PValue := MySqlPort.Text;
  user.PValue :=  username.Text;
  pass.PValue :=  password.Text;
  web.PValue := weburl.Text;
  db.PValue :=  dataname.Text;
  webports.PValue := webport.Text;
  Params[0] := IP;
  Params[1] := Port;
  Params[2] := user;
  Params[3] := pass;
  Params[4] := db;
  Params[5] := web;
  Params[6] := webports;
  ParamManage.SaveRange(Params);

  Close;
end;

procedure TmainForm.FormCreate(Sender: TObject);
begin
  ParamManage := TParamManage.Create;
  SetLength(Params, 7);
  PerlRegEx := TPerlRegEx.Create(nil);

  IP := ParamManage.GetParamByName('MySqlIp');
  Port := ParamManage.GetParamByName('MySqlPort');
  user := ParamManage.GetParamByName('MySqlUserName');
  pass := ParamManage.GetParamByName('MySqlPassWord');
  db :=   ParamManage.GetParamByName('MySqlDb');
  web :=   ParamManage.GetParamByName('weburl');
  webports := ParamManage.GetParamByName('webport');
  MySqlIp.Text := IP.PValue;
  MySqlPort.Text := Port.PValue;
  username.Text := user.PValue;
  password.Text :=  pass.PValue;
  dataname.Text := db.PValue;
  weburl.Text := web.PValue;
  webport.Text := webports.PValue;
end;

procedure TmainForm.FormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if Key = 27 then
    Close(); //
  if Key = 13 then
    BOKClick(Self);
end;

procedure TmainForm.MySqlIpKeyPress(Sender: TObject; var Key: Char);
begin
if Key = ' ' then Key := #0
end;

procedure TmainForm.MySqlPortKeyPress(Sender: TObject; var Key: Char);
begin
if Key = ' ' then Key := #0
end;

end.
