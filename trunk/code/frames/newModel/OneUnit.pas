unit OneUnit;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms, 
  Dialogs, bsSkinCtrls, bsSkinBoxCtrls, ComCtrls, bsSkinShellCtrls, StdCtrls,
  Mask,Common,ModelLib, BusinessSkinForm;

type
  TOneModel = class(TFrame)
    bsSkinStdLabel3: TbsSkinStdLabel;
    bsSkinStdLabel1: TbsSkinStdLabel;
    bsSkinStdLabel2: TbsSkinStdLabel;
    bsSkinStdLabel4: TbsSkinStdLabel;
    bsSkinStdLabel5: TbsSkinStdLabel;
    bsSkinStdLabel6: TbsSkinStdLabel;
    bsSkinStdLabel7: TbsSkinStdLabel;
    bsSkinStdLabel8: TbsSkinStdLabel;
    bsSkinStdLabel9: TbsSkinStdLabel;
    bsSkinStdLabel10: TbsSkinStdLabel;
    bsSkinStdLabel11: TbsSkinStdLabel;
    firepath: TbsSkinDirectoryEdit;
    modelPack: TbsSkinEdit;
    hibernateFileName: TbsSkinEdit;
    modelName: TbsSkinEdit;
    modelPath: TbsSkinEdit;
    modelJava: TbsSkinEdit;
    ModelCNName: TbsSkinEdit;
    author: TbsSkinComboBox;
    Company: TbsSkinComboBox;
    changeHibernate: TbsSkinCheckRadioBox;
    dynamic: TbsSkinCheckRadioBox;
    OneToMany: TbsSkinComboBox;
    ManyToOne: TbsSkinComboBox;
    bsSkinLabel2: TbsSkinLabel;
    bsSkinStdLabel12: TbsSkinStdLabel;
    hibernate: TbsSkinEdit;
    bsSkinStdLabel13: TbsSkinStdLabel;
    springPath: TbsSkinEdit;
    bsSkinPanel1: TbsSkinPanel;
    treeshell: TbsSkinDirTreeView;
    bsSkinScrollBar1: TbsSkinScrollBar;
    bsSkinStdLabel14: TbsSkinStdLabel;
    modelLargeName: TbsSkinEdit;
    bsSkinButton8: TbsSkinButton;
    mobile: TbsSkinCheckRadioBox;
    bsSkinStdLabel15: TbsSkinStdLabel;
    mobilePath: TbsSkinDirectoryEdit;
    bsSkinFrame1: TbsSkinFrame;
    procedure firepathChange(Sender: TObject);
    procedure treeshellClick(Sender: TObject);
    procedure bsSkinButton8Click(Sender: TObject);
    procedure mobileClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
    procedure init;
    function check(var mess:string):boolean;
  end;

implementation

{$R *.dfm}
uses
  main;

procedure TOneModel.Init;
begin
  Common.getHistoryFromtxt(author,ExtractFileDir(PARAMSTR(0))+'\res\box\author.txt');
  Common.getHistoryFromtxt(Company,ExtractFileDir(PARAMSTR(0))+'\res\box\Company.txt');
  Common.getHistoryFromtxt(OneToMany,ExtractFileDir(PARAMSTR(0))+'\res\box\OneToMany.txt');
  Common.getHistoryFromtxt(ManyToOne,ExtractFileDir(PARAMSTR(0))+'\res\box\ManyToOne.txt');
end;

procedure TOneModel.mobileClick(Sender: TObject);
begin
    mobilePath.Enabled := mobile.Checked;
end;

procedure TOneModel.bsSkinButton8Click(Sender: TObject);
begin
treeshell.Refresh(treeshell.Items[0]);
end;

function TOneModel.check(var mess:string):boolean;
var
  hiberFiles:TStrings;
  I:Integer;
  Model:TModel;
begin
  if modelName.Text = '' then
  begin
      mess := '请选择实体类！';
      Result := False;
      Exit;
  end;
  
  if author.Text = '' then
  begin
      mess := '请输入作者！';
      Result := False;
      Exit;
  end;
  if Company.Text = '' then
  begin
      mess := '请输入公司！';
      Result := False;
      Exit;
  end;
  if (OneToMany.Text <> '') and (Pos('=',OneToMany.Text) = 0) then
  begin
      mess := 'OneToMany格式错误！';
      Result := False;
      Exit;
  end;
  if (ManyToOne.Text <> '') and (Pos('=',ManyToOne.Text) = 0) then
  begin
      mess := 'ManyToOne格式错误！';
      Result := False;
      Exit;
  end;
  if (author.Items.IndexOf(author.Text) = -1) and (author.Text <> '') then
         author.Items.Add(author.Text);
  if (Company.Items.IndexOf(Company.Text) = -1) and (Company.Text <> '') then
         Company.Items.Add(Company.Text);
  if (OneToMany.Items.IndexOf(OneToMany.Text) = -1) and (OneToMany.Text <> '') then
         OneToMany.Items.Add(OneToMany.Text);
  if (ManyToOne.Items.IndexOf(ManyToOne.Text) = -1) and (ManyToOne.Text <> '') then
         ManyToOne.Items.Add(ManyToOne.Text);
  author.Items.SaveToFile(ExtractFileDir(PARAMSTR(0))+'\res\box\author.txt');
  Company.Items.SaveToFile(ExtractFileDir(PARAMSTR(0))+'\res\box\Company.txt');
  OneToMany.Items.SaveToFile(ExtractFileDir(PARAMSTR(0))+'\res\box\OneToMany.txt');
  ManyToOne.Items.SaveToFile(ExtractFileDir(PARAMSTR(0))+'\res\box\ManyToOne.txt');
  Result := True;

  if modelPath.Text <> MainForm.NewModelForm.ModelCode.modelPath then
  begin
      MainForm.NewModelForm.hasInit[1]:=False;
      MainForm.NewModelForm.hasInit[2]:=False;
      MainForm.NewModelForm.hasInit[3]:=False;
      with MainForm.NewModelForm.ModelCode do
      begin
        clear;
        propath := firepath.Text;
        modelPath := Self.modelPath.Text;
        pacname := modelPack.Text;
        className := Self.modelJava.Text;
        modelName := Self.modelName.Text;
        hibernatePath := Self.hibernateFileName.Text;
        modelChname := Self.ModelCNName.Text;
        author := Self.author.Text;
        Company := Self.Company.Text;
        changeHibernate := Self.changeHibernate.Checked;
        dynamicUpdate := Self.dynamic.Checked;
        OneToMany := Self.OneToMany.Text;
        ManyToOne := Self.ManyToOne.Text;
        hibernate := Self.hibernate.Text;
        modelLargeName := Self.modelLargeName.Text;
        springPath :=  Self.springPath.Text;
        hiberFiles := Common.getAllFilesFromDir(hibernate,'*.hbm.xml');
        Common.readXml('','',MainForm.NewModelForm.ModelCode);
        springList := getAllFilesFromDir(springPath,'*.xml');
        for I := 0 to hiberFiles.Count - 1 do
        begin
             Model := TModel.Create;
             Model.modelName := Copy(hiberFiles[I],1,Pos('.hbm',hiberFiles[I])-1);
             Model.className := Model.modelName+'.java';
             Model.hibernatePath := hibernate + hiberFiles[I];
             Model.pacName := getPacFromHbm(Model.hibernatePath);
             Model.serviceName := getServiceFromSpring(springPath,Model.modelName,springList);
             if Model.serviceName = '' then Continue;
                Common.getProsFromHiberNate(Model);
             otherModels.Add(getClassNameFromPack(Model.pacName),Model);
        end;
      end;
  end;


  if mobile.Checked then
  begin
      if (mobilePath.Text = '') then
      begin
          mess := '请选择移动应用目录！';
          Result := False;
          Exit;
      end;
      if not checkMobilePro(mobilePath.Text,mess) then
      begin
           Result := False;
           Exit;
      end;
      MainForm.NewModelForm.ModelCode.mobile := True;
      MainForm.NewModelForm.ModelCode.mobilePath := mobilePath.Text;
  end;



end;

procedure TOneModel.firepathChange(Sender: TObject);
var
  mess:string;
begin
    try
        if not checkPro(firepath.Text,mess) then
        begin
             Application.MessageBox(PChar('目录错误,'+mess), '提示', MB_OK +
               MB_ICONSTOP);
             Exit;
        end;
        treeshell.Enabled := True;
        treeshell.Root :=  firepath.Text+'\src\com';
    except

    end;
end;

procedure TOneModel.treeshellClick(Sender: TObject);
var
  dir,temp,temp1:string;
  javas:TStrings;
begin
    dir := Copy(treeshell.SelectedFolder.PathName,LastDelimiter('\',treeshell.SelectedFolder.PathName)+1,6);
    if dir = 'domain' then
    begin
        modelPath.Text := Copy(treeshell.SelectedFolder.PathName,1,LastDelimiter('\',treeshell.SelectedFolder.PathName)-1);
        if DirectoryExists(modelPath.Text+'\action') then
        begin
          if Application.MessageBox('此模块已经存在，继续吗？', '提示', MB_OKCANCEL+ MB_ICONQUESTION) <> 1 then
          begin
               Exit;
          end;
        end;
        
        temp := Copy(treeshell.SelectedFolder.PathName,Pos('com',treeshell.SelectedFolder.PathName),500);
        modelPack.Text := StringReplace(Copy(temp,1,LastDelimiter('\',temp)-1),'\','.',[rfReplaceAll]);
        javas := Common.getAllFilesFromDir(treeshell.SelectedFolder.PathName,'*.java');
        if javas.Count <> 1  then
        begin
           Application.MessageBox(PChar(treeshell.SelectedFolder.PathName+'目录下没有实体类或者有其他java文件!'), '提示', MB_OK +
             MB_ICONSTOP);
           Exit;
        end;
        
        modelJava.Text := javas[0];
        temp := Copy(modelJava.Text,1,LastDelimiter('.',modelJava.Text)-1);
        modelLargeName.Text := temp;
        modelName.Text := LowerCase(Copy(temp,1,1)) + Copy(temp,2);
        temp1 := Copy(treeshell.SelectedFolder.PathName,1,Pos('com',treeshell.SelectedFolder.PathName)-2) + '\hibernatemap\'+temp+'.hbm.xml';
        springPath.Text := Copy(treeshell.SelectedFolder.PathName,1,Pos('com',treeshell.SelectedFolder.PathName)-2) + '\springconfig\';
        hibernate.Text := Copy(treeshell.SelectedFolder.PathName,1,Pos('com',treeshell.SelectedFolder.PathName)-2) + '\hibernatemap\';
        ModelCNName.Text := modelName.Text;
        if not DirectoryExists(springPath.Text) then CreateDirectory(PChar(springPath.Text), nil);
        if not DirectoryExists(hibernate.Text) then CreateDirectory(PChar(hibernate.Text), nil);
        if not FileExists(temp1) then
        begin
           if FileExists(treeshell.SelectedFolder.PathName+'\'+temp+'.hbm.xml') then
           begin
             MoveFile(PChar(treeshell.SelectedFolder.PathName+'\'+temp+'.hbm.xml'),PChar(temp1));
           end
           else
           begin
             Application.MessageBox(PChar(temp1+'不存在!'), '提示', MB_OK +
               MB_ICONSTOP);
             Exit;
           end;
        end;
        hibernateFileName.Text := temp1;

    end;
end;

end.
