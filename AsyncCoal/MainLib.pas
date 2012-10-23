unit MainLib;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls,FileCtrl;

type
  TMainForm = class(TForm)
    lbl7: TLabel;
    SystemPath: TEdit;
    btn5: TButton;
    Logs: TMemo;
    procedure btn5Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  MainForm: TMainForm;

implementation

{$R *.dfm}
function getAllFilesFromDir(dir:string;p:string):TStrings; //从dir中获取全部指定类型的文件名
var
  sr:TSearchRec;
  temp:TStrings;
begin
    temp := TStringList.Create;
    if SysUtils.FindFirst(dir + '\'+p, faAnyFile, sr) = 0 then
    begin
      repeat
        if (sr.Name<>'.') and (sr.Name<>'..') then
        begin
          temp.Add(sr.Name);
        end;
      until SysUtils.FindNext(sr) <> 0;
      SysUtils.FindClose(sr);
    end;
    Result := temp;
end;
function checkPro(path:String;var mess:string):Boolean; //检查项目中内容是否合法
begin
    Result:=True;
    if not DirectoryExists(path + '\WebRoot') then
    begin
      mess := '找不到WebRoot！';
      Result:=False;
      Exit;
    end;
    if not DirectoryExists(path + '\src') then
    begin
      mess := '找不到src！';
      Result:=False;
      Exit;
    end;
    if not DirectoryExists(path + '\src\hibernatemap') then
    begin
      CreateDirectory(PChar(path + '\src\hibernatemap'), nil);
      Exit;
    end;
    if not DirectoryExists(path + '\src\springconfig') then
    begin
      CreateDirectory(PChar(path + '\src\springconfig'), nil);
      Exit;
    end;
end;
procedure TMainForm.btn5Click(Sender: TObject);
var
  dir,mess: string;
  FileNames,FileContents,temp:TStrings;
  I,K:Integer;
  Flag :Boolean;
begin
  if Filectrl.SelectDirectory('选择目录', '', dir) then
  begin
      SystemPath.Text := dir;
      if not checkPro(SystemPath.Text,mess) then
      begin
           Application.MessageBox(PChar('目录错误,'+mess), '提示', MB_OK +
             MB_ICONSTOP);
           Exit;
      end;
      Logs.Lines.Add('开始合并hibernate...');
      FileNames := getAllFilesFromDir(SystemPath.Text+'\src\hibernatemap','*.hbm.xml');
      Logs.Lines.Add('读取到' + IntToStr(FileNames.Count) + '个hibernate文件');
      FileContents := TStringList.Create;
      FileContents.Add('<?xml version="1.0"?>');
      FileContents.Add('<!DOCTYPE hibernate-mapping PUBLIC "-//Hibernate/Hibernate Mapping DTD 3.0//EN"');
      FileContents.Add('"http://hibernate.sourceforge.net/hibernate-mapping-3.0.dtd">');
      FileContents.Add('<hibernate-mapping>');
      temp := TStringList.Create;
      for I := 0 to FileNames.Count - 1 do
      begin
          Flag := False;
          temp.Clear;
          temp.LoadFromFile(SystemPath.Text+'\src\hibernatemap\' + FileNames[I]);
          for K := 0 to temp.Count - 1 do
          begin
              if not Flag and (Pos('class',temp[K]) > 0) then
                 Flag := True;
              if Flag and (Pos('</hibernate-mapping>',temp[K]) = 0) then
                 FileContents.Add(temp[K]);
          end;
          Logs.Lines.Add(FileNames[I] + '合并完毕...');
          FileContents.Add(#13#10);
      end;
      Logs.Lines.Add('hibernate合并完毕,保存到coal.hbm.xml');
      FileContents.Add('</hibernate-mapping>');
      FileContents.SaveToFile(SystemPath.Text+'\src\hibernatemap\coal.hbm.xml');

      FileNames.Clear;
      FileContents.Clear;
      Logs.Lines.Add('开始合并spring...');
      FileNames := getAllFilesFromDir(SystemPath.Text+'\src\springconfig','*.xml');
      Logs.Lines.Add('读取到' + IntToStr(FileNames.Count) + '个spring文件');
      FileContents.Add('<?xml version="1.0" encoding="gbk"?>');
      FileContents.Add('<!DOCTYPE beans PUBLIC "-//SPRING//DTD BEAN//EN" "http://www.springframework.org/dtd/spring-beans.dtd">');
      FileContents.Add('<beans default-autowire="byName">');
      temp := TStringList.Create;
      for I := 0 to FileNames.Count - 1 do
      begin
          Flag := False;
          temp.Clear;
          temp.LoadFromFile(SystemPath.Text+'\src\springconfig\' + FileNames[I]);
          for K := 0 to temp.Count - 1 do
          begin
              if not Flag and (Pos('id=',temp[K]) > 0) then
                 Flag := True;
              if Flag and (Pos('</beans>',temp[K]) = 0) then
                 FileContents.Add(temp[K]);
          end;
          FileContents.Add(#13#10);
          Logs.Lines.Add(FileNames[I] + '合并完毕...');
      end;
      FileContents.Add('</beans>');
      Logs.Lines.Add('spring合并完毕,保存到coal.xml');
      FileContents.SaveToFile(SystemPath.Text+'\src\springconfig\coal.xml');


      FileNames.Clear;
      FileContents.Clear;
      Logs.Lines.Add('开始合并struts...');
      FileNames := getAllFilesFromDir(SystemPath.Text+'\WebRoot\WEB-INF\strutsconfig\','*.xml');
      Logs.Lines.Add('读取到' + IntToStr(FileNames.Count) + '个struts文件');
      FileContents.Add('<?xml version="1.0" encoding="UTF-8"?>');
      FileContents.Add('<!DOCTYPE struts-config PUBLIC "-//Apache Software Foundation//DTD Struts Configuration 1.1//EN" ');
      FileContents.Add('"http://jakarta.apache.org/struts/dtds/struts-config_1_1.dtd">');
      FileContents.Add('<struts-config>');
      temp := TStringList.Create;
      for I := 0 to FileNames.Count - 1 do
      begin
          Flag := False;
          temp.Clear;
          temp.LoadFromFile(SystemPath.Text+'\WebRoot\WEB-INF\strutsconfig\' + FileNames[I]);
          for K := 0 to temp.Count - 1 do
          begin
              if not Flag and (Pos('<struts-config>',temp[K]) > 0) then
              begin
                 Flag := True;
                 Continue;
              end;
              if Flag and (Pos('</struts-config>',temp[K]) = 0) then
                 FileContents.Add(temp[K]);
          end;
          FileContents.Add(#13#10);
          Logs.Lines.Add(FileNames[I] + '合并完毕...');
      end;
      FileContents.Add('</struts-config>');
      Logs.Lines.Add('struts合并完毕,保存到coal.xml');
      FileContents.SaveToFile(SystemPath.Text+'\WebRoot\WEB-INF\strutsconfig\coal.xml');
  end;
end;

end.
