unit newMobile;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms, 
  Dialogs, bsSkinCtrls, StdCtrls, bsSkinBoxCtrls, bsSkinExCtrls, Mask,
  bsSkinShellCtrls,UpdateTool,Common,Shellapi;

type
  TMobileFream = class(TFrame)
    bsSkinGroupBox1: TbsSkinGroupBox;
    bsSkinGauge1: TbsSkinGauge;
    bsSkinExPanel1: TbsSkinExPanel;
    bsSkinStdLabel1: TbsSkinStdLabel;
    bsSkinStdLabel2: TbsSkinStdLabel;
    bsSkinStdLabel3: TbsSkinStdLabel;
    bsSkinStdLabel4: TbsSkinStdLabel;
    propath: TbsSkinDirectoryEdit;
    proname: TbsSkinEdit;
    loginUrlN: TbsSkinComboBox;
    updatePro: TbsSkinButtonEx;
    proChName: TbsSkinEdit;
    bsSkinExPanel4: TbsSkinExPanel;
    TbsSkinMemo2: TbsSkinMemo2;
    bsSkinScrollBar18: TbsSkinScrollBar;
    bsSkinStdLabel5: TbsSkinStdLabel;
    appCode: TbsSkinEdit;
    bsSkinStdLabel6: TbsSkinStdLabel;
    modelCode: TbsSkinEdit;
    bsSkinStdLabel7: TbsSkinStdLabel;
    bsSkinStdLabel8: TbsSkinStdLabel;
    loginUrlW: TbsSkinComboBox;
    procedure updateProClick(Sender: TObject);
  private
    procedure TBeforeDown;
    procedure TBeforeUnZip(value:Integer);
    procedure TOnDowning(value: Integer); //下载中显示进度
    procedure TOnUnZip(value:Integer); //解压显示进度
    procedure TAddExplan(explans: string); //更新说明/日志
    procedure TOnfinsh; //全部结束
  public
    { Public declarations }
    procedure Init;
  end;

implementation
uses
  main;
{$R *.dfm}
procedure TMobileFream.Init;
begin
    Common.getHistoryFromtxt(loginUrlN,ExtractFileDir(PARAMSTR(0))+'\res\box\loginUrlN.txt');
    Common.getHistoryFromtxt(loginUrlW,ExtractFileDir(PARAMSTR(0))+'\res\box\loginUrlW.txt');
end;
procedure TMobileFream.TBeforeDown;
begin
   bsSkinGauge1.MaxValue := 100;
   bsSkinGauge1.Value := 0;
   bsSkinGauge1.ProgressText := '下载中...';
end;
procedure TMobileFream.TBeforeUnZip(value:Integer);
begin
   bsSkinGauge1.MaxValue := value;
   bsSkinGauge1.Value := 0;
   bsSkinGauge1.ProgressText := '解压中...';
end;
procedure TMobileFream.TOnUnZip(value:Integer);
begin
   bsSkinGauge1.Value := value;
end;
procedure TMobileFream.TOnDowning(value: Integer);
begin
  bsSkinGauge1.Value := value;
end;
procedure TMobileFream.TAddExplan(explans: string);
begin
   TbsSkinMemo2.Lines.Add(explans);
end;
procedure TMobileFream.TOnfinsh;
var
  javas:TStrings;
  ClassName : string;
begin
   if (loginUrlN.Items.IndexOf(loginUrlN.Text) = -1) and (loginUrlN.Text <> '') then
         loginUrlN.Items.Add(loginUrlN.Text);
   loginUrlN.Items.SaveToFile(ExtractFileDir(PARAMSTR(0))+'\res\box\loginUrlN.txt');
   if (loginUrlW.Items.IndexOf(loginUrlW.Text) = -1) and (loginUrlW.Text <> '') then
         loginUrlN.Items.Add(loginUrlW.Text);
   loginUrlW.Items.SaveToFile(ExtractFileDir(PARAMSTR(0))+'\res\box\loginUrlW.txt');
   TbsSkinMemo2.Lines.Add('更新完毕，开始配置文件...');

   Common.changeFileContext(propath.Text+'\.project','basemobile',proname.Text);
   TbsSkinMemo2.Lines.Add('.project修改完毕');


   ClassName := UpperCase(Copy(proname.Text,1,1)) + Copy(proname.Text,2,Length(proname.Text) - 1) + 'Activity';
   Common.changeFileContext(propath.Text+'\AndroidManifest.xml','.basemobile"','.'+proname.Text+'"');
   Common.changeFileContext(propath.Text+'\AndroidManifest.xml','".BasemobileActivity"','".' + ClassName + '"');
   TbsSkinMemo2.Lines.Add('AndroidManifest.xml修改完毕');


   ForceDirectories(PChar(propath.Text + '\src\com\sxsihe\mobile\'+proname.Text));
   javas := TStringList.Create;
   javas.Add('package com.sxsihe.mobile.'+proname.Text+';');
   javas.Add('');
   javas.Add('import org.apache.cordova.DroidGap;');
   javas.Add('import android.os.Bundle;');
   javas.Add('');
   javas.Add('public class '+ClassName+' extends DroidGap {');
   javas.Add('');
   javas.Add('@Override');
   javas.Add('    public void onCreate(Bundle savedInstanceState) {');
   javas.Add('         super.onCreate(savedInstanceState);');
   javas.Add('         super.loadUrl("file:///android_asset/www/index.html");');
   javas.Add('    }');
   javas.Add('}');
   javas.SaveToFile(propath.Text + '\src\com\sxsihe\mobile\'+proname.Text+'\'+ClassName+'.java');
   TbsSkinMemo2.Lines.Add('com.sxsihe.mobile.'+proname.Text+'ClassName生成完毕');


   ForceDirectories(PChar(propath.Text + '\gen\com\sxsihe\mobile\'+proname.Text));
   javas := TStringList.Create;
   javas.Add('package com.sxsihe.mobile.'+proname.Text+';');
   javas.Add('');
   javas.Add('public final class BuildConfig {');
   javas.Add('   public final static boolean DEBUG = true;');
   javas.Add('}');
   javas.SaveToFile(propath.Text + '\gen\com\sxsihe\mobile\'+proname.Text+'\BuildConfig.java');
   TbsSkinMemo2.Lines.Add('com.sxsihe.mobile.BuildConfig生成完毕');

   javas := TStringList.Create;
   javas.Add('package com.sxsihe.mobile.'+proname.Text+';');
   javas.Add('');
   javas.Add('public final class R {');
   javas.Add('   public static final class attr {');
   javas.Add('   }');
   javas.Add('   public static final class drawable {');
   javas.Add('       public static final int ic_launcher=0x7f020000;');
   javas.Add('   }');
   javas.Add('   public static final class layout {');
   javas.Add('       public static final int main=0x7f030000;');
   javas.Add('   }');
   javas.Add('   public static final class string {');
   javas.Add('       public static final int app_name=0x7f050001;');
   javas.Add('       public static final int hello=0x7f050000;');
   javas.Add('   }');
   javas.Add('   public static final class xml {');
   javas.Add('       public static final int cordova=0x7f040000;');
   javas.Add('       public static final int plugins=0x7f040001;');
   javas.Add('   }');
   javas.Add('}');
   javas.SaveToFile(propath.Text + '\gen\com\sxsihe\mobile\'+proname.Text+'\R.java');
   TbsSkinMemo2.Lines.Add('com.sxsihe.mobile.R生成完毕');

   javas := TStringList.Create;
   javas.LoadFromFile(propath.Text + '\assets\www\index.html');
   if modelCode.Text = '' then
      javas[71] := '$.appcode = "'+appCode.Text+'";'
   else
      javas[71] := '$.appcode = "'+appCode.Text+'";$.modelcode="'+modelCode.Text+'";';
   javas[72] := '$.loginUrlN = "' + loginUrlN.Text + '&mobile=1",$.loginUrlW = "' + loginUrlW.Text + '&mobile=1";';
   javas[73] := '$(".apptitle").html("'+proChName.Text+'");';
   javas.SaveToFile(propath.Text + '\assets\www\index.html');
   TbsSkinMemo2.Lines.Add(propath.Text + '\assets\www\index.html修改完毕');

   javas.LoadFromFile(propath.Text + '\res\values\strings.xml');
   javas[5] := '<string name="app_name">'+proChName.Text+'</string>';

   updatePro.Enabled := True;
   Application.MessageBox('创建完成！', '提示', MB_OK +
     MB_ICONINFORMATION);
   ShellExecute(Application.Handle, nil, nil, nil, pchar(propath.Text), SW_SHOW);
end;
procedure TMobileFream.updateProClick(Sender: TObject);
var
  DownTool: TDownTool;
begin
    if propath.Text = '' then
    begin
         Application.MessageBox('请输入项目目录！', '提示', MB_OK +
           MB_ICONSTOP);
         Exit;
    end;
    if proname.Text = '' then
    begin
         Application.MessageBox('请输入项目名称！', '提示', MB_OK +
           MB_ICONSTOP);
         Exit;
    end;
    if proChName.Text = '' then
    begin
         Application.MessageBox('请输入项目中文名称！', '提示', MB_OK +
           MB_ICONSTOP);
         Exit;
    end;
    if loginUrlN.Text = '' then
    begin
         Application.MessageBox('请输入登录地址(内)！', '提示', MB_OK +
           MB_ICONSTOP);
         Exit;
    end;
    if loginUrlW.Text = '' then
    begin
         Application.MessageBox('请输入登录地址(外)！', '提示', MB_OK +
           MB_ICONSTOP);
         Exit;
    end;
    if appCode.Text = '' then
    begin
         Application.MessageBox('请输入对应系统编码！', '提示', MB_OK +
           MB_ICONSTOP);
         Exit;
    end;

    DownTool := TDownTool.Create;
    DownTool.fireName := 'baseMobile';
    DownTool.path := propath.Text;
    DownTool.url := main.Path;
    DownTool.BeforeDown := TBeforeDown;
    DownTool.OnDowning := TOnDowning;
    DownTool.BeforeUnZip := TBeforeUnZip;
    DownTool.OnUnZip := TOnUnZip;
    DownTool.AddExplans := TAddExplan;
    DownTool.Onfinsh := TOnfinsh;
    updatePro.Enabled := False;
    DownTool.Start;
end;

end.

