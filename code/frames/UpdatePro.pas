unit UpdatePro;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms, 
  Dialogs, StdCtrls, Mask, bsSkinBoxCtrls, bsSkinShellCtrls, bsSkinCtrls,
  bsSkinExCtrls,UpdateTool,Common,ShellAPI;

type
  TUpdateProForm = class(TFrame)
    bsSkinGroupBox1: TbsSkinGroupBox;
    bsSkinGauge1: TbsSkinGauge;
    bsSkinExPanel4: TbsSkinExPanel;
    bsSkinExPanel1: TbsSkinExPanel;
    firepath: TbsSkinDirectoryEdit;
    TbsSkinMemo2: TbsSkinMemo2;
    bsSkinScrollBar18: TbsSkinScrollBar;
    updatePro: TbsSkinButtonEx;
    procedure updateProClick(Sender: TObject);
  private
    { Private declarations }
    procedure TBeforeDown;
    procedure TBeforeUnZip(value:Integer);
    procedure TOnDowning(value: Integer); //下载中显示进度
    procedure TOnUnZip(value:Integer); //解压显示进度
    procedure TAddExplan(explans: string); //更新说明/日志
    procedure TOnfinsh; //全部结束
  public
    { Public declarations }
  end;

implementation

{$R *.dfm}
uses
  main;

procedure TUpdateProForm.TBeforeDown;
begin
   bsSkinGauge1.MaxValue := 100;
   bsSkinGauge1.Value := 0;
   bsSkinGauge1.ProgressText := '下载中...';
end;
procedure TUpdateProForm.TBeforeUnZip(value:Integer);
begin
   bsSkinGauge1.MaxValue := value;
   bsSkinGauge1.Value := 0;
   bsSkinGauge1.ProgressText := '解压中...';
end;

procedure TUpdateProForm.TOnUnZip(value:Integer);
begin
   bsSkinGauge1.Value := value;
end;

procedure TUpdateProForm.TOnDowning(value: Integer);
begin
  bsSkinGauge1.Value := value;
end;
procedure TUpdateProForm.TAddExplan(explans: string);
begin
   TbsSkinMemo2.Lines.Add(explans);
end;
procedure TUpdateProForm.TOnfinsh;
begin
   Application.MessageBox('更新完毕！', '提示', MB_OK + MB_ICONINFORMATION);
   updatePro.Enabled := True;
   ShellExecute(Application.Handle, nil, nil, nil, pchar(firepath.Text), SW_SHOW);
end;

procedure TUpdateProForm.updateProClick(Sender: TObject);
var
  DownTool: TDownTool;
  mess:string;
begin
    if not checkPro(firepath.Text,mess) then
    begin
         Application.MessageBox(PChar('目录错误,'+mess), '提示', MB_OK +
           MB_ICONSTOP);
         Exit;
    end;
    case Application.MessageBox('是否备份？', '提示', MB_OKCANCEL + 
      MB_ICONQUESTION) of
      IDOK:
        begin
            CopyDirectory(firepath.Text,ExtractFilePath(ParamStr(0))+'\bak\'+Formatdatetime('yyyy-MM-ddhhmmss', Now)+'更新项目备份\');
        end;
    end;

    DownTool := TDownTool.Create;
    DownTool.fireName := 'baseweb';
    DownTool.path := firepath.Text;
    DownTool.url := main.Path;
    DownTool.BeforeDown := TBeforeDown;
    DownTool.OnDowning := TOnDowning;
    DownTool.BeforeUnZip := TBeforeUnZip;
    DownTool.OnUnZip := TOnUnZip;
    DownTool.AddExplans := TAddExplan;
    DownTool.Onfinsh := TOnfinsh;
    DownTool.isUpdate := True;
    updatePro.Enabled := False;
    DownTool.Start;
end;



end.
