unit Main;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs,Box,Ini,Common, StdCtrls, ExtCtrls,ModBusLoad,Clipbrd;
const
  Colors : array [0.. 8] of Integer = (
     clBtnFace,clRed,clFuchsia,clLime,clYellow,clTeal,clSilver,clWhite,clOlive
  );

type
  TMainForm = class(TForm)
    Logs: TMemo;
    Panel1: TPanel;
    ClearLogBtn: TButton;
    LogClear: TCheckBox;
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure ClearLogBtnClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
     Events : TStrings;
     PointStart:Integer;
     PointEnd:Integer;
     Comm   :string;
     procedure InitC;
     procedure AddLog(logContent:string);
     procedure ShowData(Comm:string;MacAddress,Address,Value:Integer);
  end;

var
  MainForm: TMainForm;
  PControl : TPControl;
implementation

{$R *.dfm}

procedure TMainForm.ClearLogBtnClick(Sender: TObject);
begin
  Clipboard.AsText := Logs.Text;
  Logs.Lines.Clear;
end;

procedure TMainForm.FormCreate(Sender: TObject);
begin
  WindowState := wsMaximized;
  PControl    := TPControl.Create(Application);
  PControl.Parent := Self;
  PControl.Width  := Screen.Width;
  PControl.Height := Screen.Monitors[0].Height - 300;
  PControl.Left   := 0;
  PControl.Top    := 0;
  InitC;
end;
procedure TMainForm.FormDestroy(Sender: TObject);
begin
    ModLoad.Free;
end;

procedure TMainForm.InitC;
var
   HCount,SCount:Integer;
   I,K,N        :Integer;
   GroupBox     :TGroupBox;
   Edit         :TEdit;
   IsSuccess    :Boolean;
   PCount : Integer;
begin
   PointStart := StrToInt(Ini.ReadIni('server','pointStart'));
   if PointStart < 1 then
   begin
        AddLog('最少从1开始..');
        PointStart := 1;
   end;
   PointEnd := StrToInt(Ini.ReadIni('server','pointEnd'));
   if PointEnd > 255 then
   begin
        AddLog('最多到255..');
        PointEnd := 255;
   end;
   PCount := PointEnd - PointStart + 1;
   
   Comm := Ini.ReadIni('server','com');
   Events := TStringList.Create;
   Events.LoadFromFile(ExtractFileDir(PARAMSTR(0)) + '\event.txt');
   HCount := (PControl.Width - 20) div 138;   //一行多少
   SCount := (PCount +  HCount - 1) div HCount; //多少行
   for I := 0 to SCount - 1 do
   begin
       for K := 1 to HCount do
       begin
           N := (I * HCount) + K + PointStart - 1;
           if N <= PointEnd then
           begin
             GroupBox := TGroupBox.Create(Self);
             GroupBox.Parent := PControl;
             GroupBox.Caption := InttoStr(N);
             GroupBox.Width  := 130;
             GroupBox.Height := 50;
             GroupBox.Left := 8 * K + 130 * (K - 1);
             GroupBox.Top  := 8 * (I + 1) + 50 * I;
             GroupBox.Name := 'G' + GroupBox.Caption;

             Edit := TEdit.Create(Self);
             Edit.Parent := GroupBox;
             Edit.Text := '无事件应答';
             Edit.Left := 16;
             Edit.Top  := 16;
             Edit.Width := 97;
             Edit.Name := 'E' + InttoStr(N);
             Edit.ReadOnly := True;
           end;
       end;
   end;
   ModLoad := TModLoad.Create('ModBusDll.dll',ShowData,IsSuccess);
   if IsSuccess then
   begin
      AddLog('函数库加载完毕!');
      //读取时间和超时次数在模拟时要调整大一些，模拟器随机数生成需要时间..
      if ModLoad.Open(Comm,4800,0,3,0,PointStart,PointEnd,1,500,20) then
         AddLog('串口打开成功!')
      else
         AddLog('串口打开失败!');
   end;
end;
procedure TMainForm.AddLog(logContent:string);
begin
    if (LogClear.Checked) and (Logs.Lines.Count >= 100) then
       Logs.Lines.Clear;
    Logs.Lines.Add(FormatDateTime('hh:mm:ss', now) + '  ' + logContent);
end;
procedure TMainForm.ShowData(Comm:string;MacAddress,Address,Value:Integer);
var
   GroupBoxSrc :TControl;
   Edit       : TEdit;
begin
   AddLog(Comm + '发生回调！');
   GroupBoxSrc := PControl.FindChildControl('G' + InttoStr(Address));
   if Assigned(GroupBoxSrc) then
   begin
       Edit := (GroupBoxSrc as TGroupBox).FindChildControl('E' + InttoStr(Address)) as TEdit;
       if Value < 4 then
       begin
            (GroupBoxSrc as TGroupBox).Color := Colors[Value];
            Edit.Text := Events[Value]
       end
       else
       begin
            (GroupBoxSrc as TGroupBox).Color := Colors[Value - 1];
            Edit.Text := Events[Value - 1];
       end;
   end;

end;


end.
