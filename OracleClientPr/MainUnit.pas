unit MainUnit;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, bsSkinData, bsMessages, BusinessSkinForm, bsSkinCtrls, bsSkinGrids,
  bsDBGrids, bsTrayIcon, StdCtrls, Mask, bsSkinBoxCtrls, BeaEdit, AccessForTns,
  DB, PerlRegEx, RegeditUnit;

type
  TMainForm = class(TForm)
    bsBusinessSkinForm: TbsBusinessSkinForm;
    bsSkinData: TbsSkinData;
    bsSkinMessage: TbsSkinMessage;
    bsSkinScrollBar: TbsSkinScrollBar;
    DBGridEh: TbsSkinDBGrid;
    bsTrayIcon: TbsTrayIcon;
    BADD: TbsSkinButton;
    BUPDATE: TbsSkinButton;
    BDelete: TbsSkinButton;
    bsSkinButton1: TbsSkinButton;
    bsSkinStdLabel1: TbsSkinStdLabel;
    Deport: TBeaEdit;
    DataSource: TDataSource;
    GMAIN: TbsSkinGroupBox;
    bsSkinStdLabel5: TbsSkinStdLabel;
    bsSkinStdLabel10: TbsSkinStdLabel;
    TNAME: TBeaEdit;
    TCP: TbsSkinComboBox;
    BOK: TbsSkinButton;
    BCanecl: TbsSkinButton;
    bsSkinStdLabel2: TbsSkinStdLabel;
    bsSkinStdLabel3: TbsSkinStdLabel;
    PORT: TBeaEdit;
    bsSkinStdLabel4: TbsSkinStdLabel;
    SID: TBeaEdit;
    Regedit: TbsSkinButton;
    HOST: TBeaEdit;
    bsSkinGauge: TbsSkinGauge;
    bsCompressedSkinList1: TbsCompressedSkinList;
    procedure RegeditClick(Sender: TObject);
    procedure BDeleteClick(Sender: TObject);
    procedure BCaneclClick(Sender: TObject);
    procedure BOKClick(Sender: TObject);
    procedure BUPDATEClick(Sender: TObject);
    procedure BADDClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormDestroy(Sender: TObject);
    procedure bsSkinButton1Click(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure DBGridEhDrawColumnCell(Sender: TObject; const Rect: TRect;
      DataCol: Integer; Column: TbsColumn; State: TGridDrawState);
    procedure FormCreate(Sender: TObject);
    procedure Search;
    procedure O2F;
    procedure F2O;
    procedure ChangeForm(Hei: Integer);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  MainForm: TMainForm;
  nsManage: TnsManage;
  TNS: TTNS;
  ADDORUPDATE: BOOLEAN;
implementation

{$R *.dfm}

procedure TMainForm.ChangeForm(Hei: Integer);
begin
  if DBGridEh.Height <> Hei then
  begin
    DBGridEh.Height := Hei;
    DBGridEh.VScrollBar.Height := DBGridEh.Height;
  end;
  if Hei = 175 then
  begin
    GMAIN.Visible := true;
    BADD.Enabled := false;
    BUPDATE.Enabled := false;
    BDelete.Enabled := false;
  end
  else
  begin
    GMAIN.Visible := false;
    BADD.Enabled := true;
    BUPDATE.Enabled := true;
    BDelete.Enabled := true;
  end;

end;

procedure TMainForm.O2F;
begin
  TNAME.Text := TNS.TNAME;
  SID.Text := TNS.SID;
  TCP.ItemIndex := TCP.Items.IndexOf(TNS.TCP);
  HOST.Text := TNS.HOST;
  PORT.Text := TNS.PORT;
end;

procedure TMainForm.RegeditClick(Sender: TObject);
begin
  RegeditUnit.InitOracle;
  if bsSkinMessage.MessageDlg('�ó���ÿ���ƶ�λ�ö���Ҫ����ע��,'#13'��ÿ���ƶ�λ��ʱֻ��ע��һ�Σ�', mtConfirmation, [mbYes, mbNo], 0) <> 6 then
    Exit;
  bsSkinMessage.MessageDlg('ע��ɹ���', mtInformation, [mbOK], 0);
end;

procedure TMainForm.F2O;
begin
  TNS.TNAME := TNAME.Text;
  TNS.SID := SID.Text;
  TNS.TCP := TCP.Text;
  TNS.HOST := HOST.Text;
  TNS.PORT := PORT.Text;
end;

procedure TMainForm.BADDClick(Sender: TObject);
begin
  TNS := TTNS.Create;
  O2F;
  ChangeForm(175);
  ADDORUPDATE := TRUE;
end;

procedure TMainForm.BCaneclClick(Sender: TObject);
begin
  ChangeForm(351);
end;

procedure TMainForm.BDeleteClick(Sender: TObject);
begin
  TNS := nsManage.GetTnsById(DBGridEh.DataSource.dataSet.FieldByName('TID').AsString);
  if bsSkinMessage.MessageDlg('ȷ��ɾ��ѡ��ļ�¼��?', mtConfirmation, [mbYes, mbNo], 0) <> 6 then
    Exit;
  nsManage.DeleteTns(TNS);
  bsSkinMessage.MessageDlg('ɾ���ɹ���', mtInformation, [mbOK], 0);
  Search;
end;

procedure TMainForm.BOKClick(Sender: TObject);
var
  Mess: string;
  PerlRegEx: TPerlRegEx;
begin
  Mess := '';
  PerlRegEx := TPerlRegEx.Create(nil);
  if TNAME.Text = '' then
    Mess := '�������������'#13
  else
  begin
    if nsManage.CheckTnsName(TNAME.Text, TNS.TID) then
      Mess := Mess + '�������Ѿ����ڣ�'#13;
  end;

  if TCP.ItemIndex = -1 then
    Mess := Mess + '��ѡ��Э�飡'#13;

  if PORT.Text = '' then
    Mess := Mess + '������˿ڣ�'#13;


  if PORT.Text = '' then
    Mess := Mess + '������˿ڣ�'#13
  else
  begin
    PerlRegEx.RegEx := '^[0-9]*$';
    PerlRegEx.Subject := PORT.Text;
    if not PerlRegEx.Match then
      Mess := Mess + '�˿ڲ��Ϸ���'#13;
  end;



  if SID.Text = '' then
    Mess := Mess + '������SID��'#13;

  if HOST.Text = '' then
    Mess := Mess + '������ip��'#13
  else
  begin
    PerlRegEx.RegEx := '(((\d{1,2})|(1\d{2})|(2[0-4]\d)|(25[0-5]))\.){3}((\d{1,2})|(1\d{2})|(2[0-4]\d)|(25[0-5]))';
    PerlRegEx.Subject := HOST.Text;
    if not PerlRegEx.Match then
      Mess := Mess + 'IP���Ϸ���'#13;
  end;

  if Mess <> '' then
  begin
    bsSkinMessage.MessageDlg(Mess, mtError, [mbOK], 0);
    Exit;
  end;
  F2O;
  if ADDORUPDATE then
  begin
    nsManage.AddTns(TNS);
    bsSkinMessage.MessageDlg('��ӳɹ���', mtInformation, [mbOK], 0);
  end
  else
  begin
    nsManage.UpdateTns(TNS);
    bsSkinMessage.MessageDlg('�޸ĳɹ���', mtInformation, [mbOK], 0);
  end;
  ChangeForm(351);
  GMAIN.Visible := false;
  Search;
end;

procedure TMainForm.bsSkinButton1Click(Sender: TObject);
begin
  Search;
end;

procedure TMainForm.BUPDATEClick(Sender: TObject);
begin
  TNS := nsManage.GetTnsById(DBGridEh.DataSource.dataSet.FieldByName('TID').AsString);
  O2F;
  ChangeForm(175);
  ADDORUPDATE := FALSE;
end;

procedure TMainForm.DBGridEhDrawColumnCell(Sender: TObject; const Rect: TRect;
  DataCol: Integer; Column: TbsColumn; State: TGridDrawState);
begin
  with DBGridEh.DataSource.dataSet do
  begin
    if DataCol = 0 then
      DBGridEh.Canvas.TextRect(Rect, Rect.Left, Rect.Top, InttoStr(RecNo));
  end;
end;

procedure TMainForm.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  bsSkinGauge.Visible := true;
  Application.ProcessMessages;
  nsManage.SaveAll(bsSkinGauge);
end;

procedure TMainForm.FormCreate(Sender: TObject);
begin
  nsManage := TnsManage.Create;
  DBGridEh.DataSource.DataSet := nsManage.ADOQuery;
  nsManage.InitAll;
end;

procedure TMainForm.FormDestroy(Sender: TObject);
begin
  nsManage.Destroy;
end;

procedure TMainForm.FormShow(Sender: TObject);
begin
  Search;
end;

procedure TMainForm.Search;
var
  TSQL, FileName: string;
begin
  FileName := 'Tns.xml';
  TSQL := 'select * from tns ';
  if Deport.Text <> '' then
  begin
    TSQL := TSQL + ' where TNAME like ''%' + Deport.Text + '%''';
  end;
  TSQL := TSQL + ' order by TNAME';
  nsManage.Search(TSQL, FileName, DBGridEh);
end;



end.

