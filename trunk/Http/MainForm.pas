unit MainForm;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, IdBaseComponent, IdComponent, IdTCPConnection, IdTCPClient,
  IdHTTP,IdMultipartFormData,IdObjs,superobject, Grids,WebForm,SHDocVw,mshtml,ActiveX,ComObj;

type
  TForm1 = class(TForm)
    GroupBox1: TGroupBox;
    Edit1: TEdit;
    Label1: TLabel;
    Edit2: TEdit;
    Label2: TLabel;
    Edit3: TEdit;
    Label3: TLabel;
    Button1: TButton;
    Edit4: TEdit;
    Label4: TLabel;
    GroupBox2: TGroupBox;
    Label5: TLabel;
    Label7: TLabel;
    Edit6: TEdit;
    Label6: TLabel;
    Button2: TButton;
    StringGrid: TStringGrid;
    ComboBox1: TComboBox;
    procedure Button1Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form1: TForm1;
  Id:string;
implementation

{$R *.dfm}


procedure  WB_LoadHTML(WebBrowser:  TWebBrowser;  HTMLCode:  string);
var
   sl:  TStringList;
   ms:  TMemoryStream;
begin
   WebBrowser.Navigate('about:blank');
   if  Assigned(WebBrowser.Document)  then
   begin
       sl  :=  TStringList.Create;
       try
           ms  :=  TMemoryStream.Create;
           try
               sl.Text  :=  HTMLCode;
               sl.SaveToStream(ms);
               ms.Seek(0,  0);
               (WebBrowser.Document  as  IPersistStreamInit).Load(TStreamAdapter.Create(ms));
           finally
               ms.Free;
           end;
       finally
           sl.Free;
       end;
   end;
end;
procedure WB_LoadHTML2(WebBrowser: TWebBrowser; HTMLCode: string);
var
  sl: TStringList;
  ms: TMemoryStream;
begin
  WebBrowser.Navigate('about:blank');
  while WebBrowser.ReadyState < READYSTATE_INTERACTIVE do
   Application.ProcessMessages;
  if Assigned(WebBrowser.Document) then
  begin
    sl := TStringList.Create;
    try
      ms := TMemoryStream.Create;
      try
        sl.Text := HTMLCode;
        sl.SaveToStream(ms);
        ms.Seek(0, 0);
        (WebBrowser.Document as IPersistStreamInit).Load(TStreamAdapter.Create(ms));
      finally
        ms.Free;
      end;
    finally
      sl.Free;
    end;
  end;
end;








procedure TForm1.Button1Click(Sender: TObject);
var
//    Content:TIdMultiPartFormDataStream;
    Ret:TStringStream;
    Content:TIdStringStream;
    RevObj      : ISuperObject;
    IdHTTP: TIdHTTP;
begin
//  Content:=TIdMultiPartFormDataStream.Create;
  Ret     :=TStringStream.Create('');
  IdHTTP :=  TIdHTTP.Create(Application);
  Content := TIdStringStream.Create('{"username":"'+Edit1.Text+'","password":"'+Edit2.Text+'","appcode":"'+Edit4.Text+'","apple":"1"}');
  IdHTTP.Post(Edit3.Text + '/loginAction.do?action=login&mobile=true',Content,Ret);
  RevObj := So(UTF8Decode(ret.DataString));
    IdHTTP.Free;
  Content.Free;
  Ret.Free;
  if RevObj.S['message'] <> '' then
  begin
      ShowMessage(RevObj.S['message']);
      Exit;
  end;
  Label5.Caption := '';
  Label5.Caption := Label5.Caption +  '名字 --> ' +RevObj.S['employeename'] + #13#10;
  Label5.Caption := Label5.Caption + 'id --> ' + RevObj.S['id'] + #13#10;
  Id :=   RevObj.S['id'];

  GroupBox2.Enabled := True;
end;

procedure TForm1.Button2Click(Sender: TObject);
var
    Ret:TStringStream;
    Content:TIdStringStream;
    RevObj,Names :TSuperArray;
    D : TSuperTableString;
    I,K:Integer;
    IdHTTP: TIdHTTP;
begin
    if ComboBox1.Items.IndexOf(ComboBox1.Text) = -1 then
       ComboBox1.Items.Add(ComboBox1.Text);
    IdHTTP :=  TIdHTTP.Create(Application);
    Ret     :=TStringStream.Create('');
    Content := TIdStringStream.Create(ComboBox1.Text);
    IdHTTP.Post(Edit6.Text + '&SESSIONID=' + Id,Content,Ret);
    try
       RevObj := SO(UTF8Decode(ret.DataString)).AsArray;
       StringGrid.RowCount := 0;
       StringGrid.ColCount := 0;
       if RevObj.Length > 0 then
       begin
           StringGrid.RowCount := RevObj.Length + 1;
           StringGrid.FixedRows := 1;
           D := RevObj.O[0].AsObject ;
           Names := D.GetNames.AsArray;
           StringGrid.ColCount := Names.Length + 1;
           StringGrid.Cells[0,0] := '序号';
           for I := 0 to Names.Length - 1 do
           begin
               StringGrid.Cells[I+1,0] := Names.S[I];
           end;
           for I := 0 to RevObj.Length - 1 do
           begin
               D := RevObj.O[I].AsObject;
               StringGrid.Cells[0,I+1] := IntToStr(I+1);
               for K := 0 to Names.Length - 1 do
               begin
                   StringGrid.Cells[K+1,I+1] := D.S[Names.S[K]];
               end;  
           end;
       end;
        Content.Free;
        Ret.Free;
        IdHTTP.Free;
    except
      ShowMessage('数据解析错误！！！点击显示返回内容！');
      WB_LoadHTML2(Web.WebBrowser,'<meta http-equiv=Content-Type content="text/html; charset=GBK">' + ret.DataString);
      Web.ShowModal;
      Content.Free;
      Ret.Free;
      IdHTTP.Free;
    end;
end;

end.
