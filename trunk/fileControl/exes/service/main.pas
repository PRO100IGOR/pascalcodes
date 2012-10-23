unit main;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, UniProvider, MySQLUniProvider, DB, DBAccess,AccessLib,
  Uni,PrintLib, ExtCtrls,LogsUnit, InvokeRegistry, Rio, SOAPHTTPClient;

type
  TMainForm = class(TForm)
    mysql: TMySQLUniProvider;
    UniConnection: TUniConnection;
    Timer: TTimer;
    HTTPRIO: THTTPRIO;
    Memo1: TMemo;
    procedure FormCreate(Sender: TObject);
    procedure TimerTimer(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  MainForm: TMainForm;
  ParamManage: TParamManage;
  PrintManager :TPrintManager;

implementation

{$R *.dfm}

procedure TMainForm.FormCreate(Sender: TObject);
begin
  ParamManage := TParamManage.Create;
  with UniConnection do
  begin
    Server := ParamManage.GetParamByName('MySqlIp').PValue;
    Port := StrtoInt(ParamManage.GetParamByName('MySqlPort').PValue);
    Username := ParamManage.GetParamByName('MySqlUserName').PValue;
    Password := ParamManage.GetParamByName('MySqlPassWord').PValue;
    Database :=  ParamManage.GetParamByName('MySqlDb').PValue;
  end;
  PrintManager :=  TPrintManager.Create(UniConnection);
  PrintLib.Memo1 := Memo1;
  Timer.Enabled := True;
  PrintLib.path := 'http://' + ParamManage.GetParamByName('weburl').PValue + ':'+ParamManage.GetParamByName('webport').PValue+'/fire/services/FireDwr?wsdl';


  PrintLib.owner := Application;
  PrintLib.HTTPRIO := HTTPRIO;
end;

procedure TMainForm.FormDestroy(Sender: TObject);
begin
   Timer.Free;
   UniConnection.Close;
   HTTPRIO.Free;
   PrintManager.close;
   PrintManager.Free;
end;

procedure TMainForm.TimerTimer(Sender: TObject);
begin
   if not UniConnection.Connected then
   begin
      try
        UniConnection.Open;
        PrintManager.open;
      except
        LogsUnit.addErrors('数据库连不上');
        Exit;
      end;
   end;
end;

end.
