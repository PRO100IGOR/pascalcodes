unit UpdateMaker;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ComCtrls, StdCtrls, FileCtrl, XMLIntf, msxmldom, XMLDoc,
  RzFilSys, RzTreeVw, RzShellCtrls, VCLUnZip, VCLZip, kpSFXCfg, RzLabel, Menus,
  bsSkinShellCtrls;

type
  StringArray = array of string;
  TForm2 = class(TForm)
    rzshltr1: TRzShellTree;
    lst2: TRzFileListBox;
    vclzp1: TVCLZip;
    lbl2: TRzLabel;
    RzLabel1: TRzLabel;
    mmo1: TMemo;
    mmo2: TMemo;
    lbl3: TLabel;
    lbl4: TLabel;
    btn2: TButton;
    lbl5: TRzLabel;
    edt3: TEdit;
    btn3: TButton;
    pm1: TPopupMenu;
    N1: TMenuItem;
    N2: TMenuItem;
    N3: TMenuItem;
    N4: TMenuItem;
    dlgOpen1: TOpenDialog;
    VersionList: TEdit;
    lbl6: TLabel;
    btn4: TButton;
    SystemPath: TEdit;
    lbl7: TLabel;
    btn5: TButton;
    lbl8: TLabel;
    edt2: TComboBox;
    N5: TMenuItem;
    Button1: TButton;
    procedure btn5Click(Sender: TObject);
    procedure btn4Click(Sender: TObject);
    procedure N4Click(Sender: TObject);
    procedure N3Click(Sender: TObject);
    procedure rzshltr1Change(Sender: TObject; Node: TTreeNode);
    procedure N1Click(Sender: TObject);
    procedure N2Click(Sender: TObject);
    procedure btn3Click(Sender: TObject);
    procedure btn2Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure N5Click(Sender: TObject);
    procedure Button1Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
    procedure add(par:TTreeNode);
  end;

var
  Form2: TForm2;
  path: string;
  PathLength: Integer;
implementation

{$R *.dfm}


procedure TForm2.add(par:TTreeNode);
var
  I,K:Integer;
begin
    if par = nil then
    begin
        for I := 0 to rzshltr1.Items.Count - 1 do
        begin
           rzshltr1.Items[I].Selected := True;
           for K := 0 to lst2.Items.Count - 1 do
           begin
              lst2.ItemIndex := K;
              mmo1.Lines.Add('u- ' + Copy(lst2.FileName, PathLength + 2, 9999));
           end;
           add(rzshltr1.Items[I]);
        end;
    end
    else
    begin
       par.Expanded := True;
       par.Selected := True;
       for I := 0 to par.Count - 1 do
       begin
           par.Item[I].Selected := True;
           for K := 0 to lst2.Items.Count - 1 do
           begin
              lst2.ItemIndex := K;
              mmo1.Lines.Add('u- ' + Copy(lst2.FileName, PathLength + 2, 9999));
           end;
           add(par.Item[I]);
       end;
    end;
end;


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

procedure TForm2.btn2Click(Sender: TObject);
var
  i: Integer;
  strarr: StringArray;
  fileDel, fileExecSave, FileExecDel, fileUpdate: TStrings;
  XMLDocument: IXMLDocument;
  rootNode, beanNode, beanNode2: IXMLNode;
begin
  if VersionList.Text = '' then
  begin
    Application.MessageBox('请选择版本列表文件！', '提示', MB_OK + MB_ICONINFORMATION +
      MB_DEFBUTTON3 + MB_TOPMOST);
    Exit;
  end;
  if edt2.Text = '' then
  begin
    Application.MessageBox('请输入版本号！', '提示', MB_OK + MB_ICONINFORMATION +
      MB_DEFBUTTON3 + MB_TOPMOST);
    Exit;
  end;

  if edt2.Items.IndexOf(edt2.Text) <> -1 then
  begin
    Application.MessageBox('版本号已经存在！', '提示', MB_OK + MB_ICONINFORMATION +
      MB_DEFBUTTON3 + MB_TOPMOST);
    Exit;
  end;
  if edt3.Text = '' then
  begin
    Application.MessageBox('请选择存放目录！', '提示', MB_OK + MB_ICONINFORMATION +
      MB_DEFBUTTON3 + MB_TOPMOST);
    Exit;
  end;
  if mmo1.Text = '' then
  begin
    Application.MessageBox('没有要更新的内容！', '提示', MB_OK + MB_ICONINFORMATION +
      MB_DEFBUTTON3 + MB_TOPMOST);
    Exit;
  end;

  vclzp1.ZipName := edt3.Text + '\' + edt2.Text + '.pak';
  fileDel := TStringList.Create;
  fileExecSave := TStringList.Create;
  FileExecDel := TStringList.Create;
  fileUpdate := TStringList.Create;

  XMLDocument := TXMLDocument.Create(nil);
  XMLDocument.Active := true;
  XMLDocument.Version := '1.0';
  XMLDocument.Encoding := 'gb2312';

  rootNode := XMLDocument.CreateNode('updates');
  XMLDocument.DocumentElement := rootNode;

  beanNode := XMLDocument.CreateNode('version');
  beanNode.Text := edt2.Text;
  rootNode.ChildNodes.Add(beanNode);

  beanNode := XMLDocument.CreateNode('time');
  beanNode.Text := FormatDateTime('yyyy-MM-dd hh:mm', Now);
  rootNode.ChildNodes.Add(beanNode);

  beanNode := XMLDocument.CreateNode('explains');
  for I := 0 to mmo2.Lines.Count - 1 do
  begin
    beanNode2 := XMLDocument.CreateNode('explain');
    beanNode2.Text := mmo2.Lines[I];
    beanNode.ChildNodes.Add(beanNode2);
  end;
  rootNode.ChildNodes.Add(beanNode);
  beanNode := XMLDocument.CreateNode('files');

  for I := 0 to mmo1.Lines.Count - 1 do
  begin
    strarr := Split(mmo1.Lines[I], '- ');
    if (strarr[0] = 'u') and (fileUpdate.IndexOf(strarr[1]) = -1) then
    begin
      if Pos('.',strarr[1]) = 0 then
        vclzp1.FilesList.Add(path + '\' + strarr[1]+'\*.*')
      else
        vclzp1.FilesList.Add(path + '\' + strarr[1]);
      fileUpdate.Add(strarr[1]);
      beanNode2 := XMLDocument.CreateNode('file');
      beanNode2.Text := strarr[1];
      beanNode2.SetAttributeNS('action', '', 'u');
      beanNode.ChildNodes.Add(beanNode2);
    end
    else if (strarr[0] = 'd') and (fileDel.IndexOf(strarr[1]) = -1) then
    begin
      fileDel.Add(strarr[1]);
      beanNode2 := XMLDocument.CreateNode('file');
      beanNode2.Text := strarr[1];
      beanNode2.SetAttributeNS('action', '', 'd');
      beanNode.ChildNodes.Add(beanNode2);
    end
    else if (strarr[0] = 'ed') and (FileExecDel.IndexOf(strarr[1]) = -1) then
    begin
      FileExecDel.Add(strarr[1]);
      beanNode2 := XMLDocument.CreateNode('file');
      beanNode2.Text := strarr[1];
      beanNode2.SetAttributeNS('action', '', 'ed');
      beanNode.ChildNodes.Add(beanNode2);
      if vclzp1.FilesList.IndexOf(path + '\' + strarr[1]) = -1 then
      begin
          if Pos('.',strarr[1]) = 0 then
             vclzp1.FilesList.Add(path + '\' + strarr[1]+'\*.*')
          else
             vclzp1.FilesList.Add(path + '\' + strarr[1]);
      end;
    end
    else if (strarr[0] = 'es') and (fileExecSave.IndexOf(strarr[1]) = -1) then
    begin
      fileExecSave.Add(strarr[1]);
      beanNode2 := XMLDocument.CreateNode('file');
      beanNode2.Text := strarr[1];
      beanNode2.SetAttributeNS('action', '', 'es');
      beanNode.ChildNodes.Add(beanNode2);
      if vclzp1.FilesList.IndexOf(path + '\' + strarr[1]) = -1 then
      begin
          if Pos('.',strarr[1]) = 0 then
             vclzp1.FilesList.Add(path + '\' + strarr[1]+'\*.*')
          else
             vclzp1.FilesList.Add(path + '\' + strarr[1]);
      end;

    end;
  end;
  rootNode.ChildNodes.Add(beanNode);
  XMLDocument.SaveToFile(edt3.Text + '\' + edt2.Text + '.xml');

  DeleteFile(vclzp1.ZipName);
  vclzp1.Zip;
  XMLDocument := nil;
  edt2.Items.Add(edt2.Text);
  edt2.Items.SaveToFile(VersionList.Text);
  Application.MessageBox('更新包生成完毕！'#13#13'请将生成的.pak文件和.xml文件放入tomcat目录的webapps\CsUpdate下'#13#13'保存updateList.txt文件到tomcat目录的webapps\CsUpdate下', '提示', MB_OK +
    MB_ICONINFORMATION + MB_DEFBUTTON3 + MB_TOPMOST);
  mmo1.Lines.Clear;
  mmo2.Lines.Clear;
  edt2.Items.Clear;
  VersionList.Text := '';
  edt2.Text := '';
  fileDel.Free;
  fileExecSave.Free;
  FileExecDel.Free;
  fileUpdate.Free;
end;

procedure TForm2.btn3Click(Sender: TObject);
var
  dir: string;
begin
  if Filectrl.SelectDirectory('选择目录', '', dir) then
    edt3.Text := dir;
end;

procedure TForm2.btn4Click(Sender: TObject);
var
  FileName: string;
begin
  if dlgOpen1.Execute then
  begin
    FileName := dlgOpen1.FileName;
    VersionList.Text := dlgOpen1.FileName;
    if Pos('updateList.txt', FileName) = 0 then
      Application.MessageBox('文件无效！', '提示', MB_OK +
        MB_ICONINFORMATION + MB_DEFBUTTON3 + MB_TOPMOST)
    else
      edt2.Items.LoadFromFile(FileName);
  end;
end;

procedure TForm2.btn5Click(Sender: TObject);
var
  dir: string;
begin
  if Filectrl.SelectDirectory('选择目录', '', dir) then
  begin
    SystemPath.Text := dir;
    path := dir;
    PathLength := Length(path);
    rzshltr1.BaseFolder.PathName := path;
    lst2.Directory := rzshltr1.SelectedPathName;
    vclzp1.RootDir := path;
    SystemPath.Text := path;
  end;
end;

procedure TForm2.Button1Click(Sender: TObject);
var
  K:Integer;
begin
  for K := 0 to lst2.Items.Count - 1 do
  begin
      lst2.ItemIndex := K;
      mmo1.Lines.Add('u- ' + Copy(lst2.FileName, PathLength + 2, 9999));
  end;
  add(rzshltr1.Selected);
end;

procedure TForm2.FormCreate(Sender: TObject);
begin
  path := ExtractFileDir(PARAMSTR(0));
  PathLength := Length(path);
  rzshltr1.BaseFolder.PathName := path;
  lst2.Directory := rzshltr1.SelectedPathName;
  vclzp1.RootDir := path;
  SystemPath.Text := path;
end;

procedure TForm2.N1Click(Sender: TObject);
var
  filename: string;
begin
  filename := Copy(lst2.FileName, PathLength + 2, 9999);
  if filename = '' then Exit;
  mmo1.Lines.Add('u- ' + filename);
end;

procedure TForm2.N2Click(Sender: TObject);
var
  filename: string;
begin
  filename := Copy(lst2.FileName, PathLength + 2, 9999);
  if filename = '' then Exit;
  mmo1.Lines.Add('d- ' + filename);
end;

procedure TForm2.N3Click(Sender: TObject);
var
  filename: string;
begin
  filename := Copy(lst2.FileName, PathLength + 2, 9999);
  if filename = '' then Exit;
  mmo1.Lines.Add('es- ' + filename);
end;

procedure TForm2.N4Click(Sender: TObject);
var
  filename: string;
begin
  filename := Copy(lst2.FileName, PathLength + 2, 9999);
  if filename = '' then Exit;
  mmo1.Lines.Add('ed- ' + filename);
end;

procedure TForm2.N5Click(Sender: TObject);
var
  I:Integer;
begin
    mmo1.Lines.Clear;
    for I := 0 to lst2.Items.Count - 1 do
    begin
         lst2.ItemIndex := I;
         mmo1.Lines.Add('u- ' + Copy(lst2.FileName, PathLength + 2, 9999));
    end;
end;

procedure TForm2.rzshltr1Change(Sender: TObject; Node: TTreeNode);
begin
  lst2.Directory := rzshltr1.SelectedPathName;
end;

end.

