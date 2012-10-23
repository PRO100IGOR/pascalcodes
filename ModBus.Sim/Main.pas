unit Main;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs,Ini, StdCtrls, ExtCtrls,SPComm,Box,Clipbrd,StrUtils;


const
  Colors : array [0.. 8] of Integer = (
     clBtnFace,clRed,clFuchsia,clLime,clYellow,clTeal,clSilver,clWhite,clOlive
  );
  //* CRC 高位字节值表 */
  CRCTableHi:array[0..255] of DWORD = (
       $00, $C1, $81, $40,$01, $C0, $80, $41,$01, $C0, $80, $41,$00, $C1, $81, $40,
       $01, $C0, $80, $41,$00, $C1, $81, $40,$00, $C1, $81, $40,$01, $C0, $80, $41,
       $01, $C0, $80, $41,$00, $C1, $81, $40,$00, $C1, $81, $40,$01, $C0, $80, $41,
       $00, $C1, $81, $40,$01, $C0, $80, $41,$01, $C0, $80, $41,$00, $C1, $81, $40,
       $01, $C0, $80, $41,$00, $C1, $81, $40,$00, $C1, $81, $40,$01, $C0, $80, $41,
       $00, $C1, $81, $40,$01, $C0, $80, $41,$01, $C0, $80, $41,$00, $C1, $81, $40,
       $00, $C1, $81, $40,$01, $C0, $80, $41,$01, $C0, $80, $41,$00, $C1, $81, $40,
       $01, $C0, $80, $41,$00, $C1, $81, $40,$00, $C1, $81, $40,$01, $C0, $80, $41,
       $01, $C0, $80, $41,$00, $C1, $81, $40,$00, $C1, $81, $40,$01, $C0, $80, $41,
       $00, $C1, $81, $40,$01, $C0, $80, $41,$01, $C0, $80, $41,$00, $C1, $81, $40,
       $00, $C1, $81, $40,$01, $C0, $80, $41,$01, $C0, $80, $41,$00, $C1, $81, $40,
       $01, $C0, $80, $41,$00, $C1, $81, $40,$00, $C1, $81, $40,$01, $C0, $80, $41,
       $00, $C1, $81, $40,$01, $C0, $80, $41,$01, $C0, $80, $41,$00, $C1, $81, $40,
       $01, $C0, $80, $41,$00, $C1, $81, $40,$00, $C1, $81, $40,$01, $C0, $80, $41,
       $01, $C0, $80, $41,$00, $C1, $81, $40,$00, $C1, $81, $40,$01, $C0, $80, $41,
       $00, $C1, $81, $40,$01, $C0, $80, $41,$01, $C0, $80, $41,$00, $C1, $81, $40
  );
  //* CRC低位字节值表*/
  CRCTableLo:array[0..255] of DWORD  = (
      $00, $C0, $C1, $01,$C3, $03, $02, $C2,$C6, $06, $07, $C7,$05, $C5, $C4, $04,
      $CC, $0C, $0D, $CD,$0F, $CF, $CE, $0E,$0A, $CA, $CB, $0B,$C9, $09, $08, $C8,
      $D8, $18, $19, $D9,$1B, $DB, $DA, $1A,$1E, $DE, $DF, $1F,$DD, $1D, $1C, $DC,
      $14, $D4, $D5, $15,$D7, $17, $16, $D6,$D2, $12, $13, $D3,$11, $D1, $D0, $10,
      $F0, $30, $31, $F1,$33, $F3, $F2, $32,$36, $F6, $F7, $37,$F5, $35, $34, $F4,
      $3C, $FC, $FD, $3D,$FF, $3F, $3E, $FE,$FA, $3A, $3B, $FB,$39, $F9, $F8, $38,
      $28, $E8, $E9, $29,$EB, $2B, $2A, $EA,$EE, $2E, $2F, $EF,$2D, $ED, $EC, $2C,
      $E4, $24, $25, $E5,$27, $E7, $E6, $26,$22, $E2, $E3, $23,$E1, $21, $20, $E0,
      $A0, $60, $61, $A1,$63, $A3, $A2, $62,$66, $A6, $A7, $67,$A5, $65, $64, $A4,
      $6C, $AC, $AD, $6D,$AF, $6F, $6E, $AE,$AA, $6A, $6B, $AB,$69, $A9, $A8, $68,
      $78, $B8, $B9, $79,$BB, $7B, $7A, $BA,$BE, $7E, $7F, $BF,$7D, $BD, $BC, $7C,
      $B4, $74, $75, $B5,$77, $B7, $B6, $76,$72, $B2, $B3, $73,$B1, $71, $70, $B0,
      $50, $90, $91, $51,$93, $53, $52, $92,$96, $56, $57, $97,$55, $95, $94, $54,
      $9C, $5C, $5D, $9D,$5F, $9F, $9E, $5E,$5A, $9A, $9B, $5B,$99, $59, $58, $98,
      $88, $48, $49, $89,$4B, $8B, $8A, $4A,$4E, $8E, $8F, $4F,$8D, $4D, $4C, $8C,
      $44, $84, $85, $45,$87, $47, $46, $86,$82, $42, $43, $83,$41, $81, $80, $40
  );


type
  TMainForm = class(TForm)
    Logs: TMemo;
    Panel1: TPanel;
    ClearLogBtn: TButton;
    LogClear: TCheckBox;
    AutoChange: TCheckBox;
    Timer: TTimer;
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure ClearLogBtnClick(Sender: TObject);
    procedure AutoChangeClick(Sender: TObject);
    procedure TimerTimer(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }

    PointStart:Integer;
    PointEnd:Integer;
    Events : TStrings;
    SpComm : TComm;
    Comm   : string;
    procedure InitC;
    procedure CustomReceiveData(Sender: TObject; Buffer: Pointer; BufferLength: Word);
    procedure CustomReceiveErrorEvent(Sender: TObject; EventMask : DWORD);
    procedure AddLog(logContent:string);
    function ByteToStr(BufferArr:array of Byte):string;
    procedure ComboBoxChange(Sender: TObject);
    function ModBusCRC16(Data: string;var CRC16Hi,CRC16Lo:DWORD): string;

  end;

var
  MainForm : TMainForm;
  PControl : TPControl;
implementation

{$R *.dfm}
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
    try
        SpComm.StopComm;
    except

    end;
end;
procedure TMainForm.InitC;
var
   HCount,SCount:Integer;
   I,K,N        :Integer;
   GroupBox     :TGroupBox;
   ComboBox     :TComboBox;
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

             ComboBox := TComboBox.Create(Self);
             ComboBox.Parent := GroupBox;
             ComboBox.Items := Events;
             ComboBox.ItemIndex := 0;
             ComboBox.Left := 16;
             ComboBox.Top  := 16;
             ComboBox.DropDownCount := 10;
             ComboBox.Name := 'C' + GroupBox.Caption;
             ComboBox.Width:= 97;
             ComboBox.Style := csDropDownList;
             ComboBox.OnChange := ComboBoxChange;
           end;
       end;
   end;
   SpComm := TComm.Create(Application);
   SpComm.CommName := Comm;
   SpComm.BaudRate := 4800;
   SpComm.Parity := None;
   SpComm.ByteSize := _8;
   SpComm.StopBits := _1;
   SpComm.OnReceiveData := CustomReceiveData;
   SpComm.OnReceiveError := CustomReceiveErrorEvent;
   try
       SpComm.StartComm;
       AddLog(Comm + '打开成功');
   except
       AddLog(Comm + '打开失败,不存在或被占用');
   end;
end;
procedure TMainForm.CustomReceiveData(Sender: TObject; Buffer: Pointer; BufferLength: Word);
var
  Str: string;
  BufferArr,BufferArrSender : array of Byte;
  BeginPoint,PointCount,BufferLengthSender,I,OutIndex,BeginOut,K : Integer;
  ComboBox  :TComboBox;
  GroupBoxSrc :TControl;
  StrToCrc : string;
  CRC16Lo,CRC16Hi:DWORD;
begin
  OutIndex := 0;
  BeginOut := -1;
  K := 1;
  SetLength(BufferArr, BufferLength);
  Move(buffer^, PChar(@BufferArr[0])^, BufferLength);
  if Length(BufferArr) <> 8 then
     AddLog('接受的命令长度不符 >>' + ByteToStr(BufferArr))
  else if (BufferArr[1] <> $03) then
     AddLog('接受的命令头不以0103开始 >>' + ByteToStr(BufferArr))
  else if ModBusCRC16((IntToHex(BufferArr[0],2) + ' '+  IntToHex(BufferArr[1],2) + ' '+   IntToHex(BufferArr[2],2) +  ' '+  IntToHex(BufferArr[3],2) + ' '+  IntToHex(BufferArr[4],2) + ' '+  IntToHex(BufferArr[5],2)),CRC16Lo,CRC16Hi) <> (IntToHex(BufferArr[6],2) + IntToHex(BufferArr[7],2)) then
     AddLog('CRC检验错误 >>' + ByteToStr(BufferArr))
  else
  begin
      BeginPoint := BufferArr[3];
      PointCount := BufferArr[5];

      if PointCount > 100 then    //最多100
      begin
          AddLog('请求' + IntToStr(PointCount) + '个,限制100以内，改为100个');
          PointCount := 100;
      end;
      AddLog('收到 >> ' + ByteToStr(BufferArr)+',从' + IntToStr(BeginPoint) +'开始,查询' + IntToStr(PointCount)+'个寄存器,从机:' + IntToHex(BufferArr[0],2));
      
      BufferLengthSender := 5 + PointCount * 2;
      SetLength(BufferArrSender,BufferLengthSender);
      BufferArrSender[0] := BufferArr[0];
      BufferArrSender[1] := $03;
      for I := 1 to PointCount  do
      begin
           BufferArrSender[K + 2] := $00;
           GroupBoxSrc := PControl.FindChildControl('G' + InttoStr(BeginPoint+1));
           if Assigned(GroupBoxSrc) then
           begin
              ComboBox :=  (GroupBoxSrc as TGroupBox).FindChildControl('C' + InttoStr(BeginPoint+1)) as TComboBox;
              if ComboBox.ItemIndex < 4 then
                 BufferArrSender[K + 3] := ComboBox.ItemIndex
              else
                 BufferArrSender[K + 3] := ComboBox.ItemIndex + 1;
           end
           else
           begin
              Dec(PointCount);
              SetLength(BufferArrSender,Length(BufferArrSender) - 2);
              if BeginOut = -1 then
                 BeginOut := BeginPoint;
              Inc(OutIndex);
           end;
           Inc(BeginPoint);
           K := K + 2;
      end;
      BufferArrSender[2] := PointCount * 2;

      for I := 0 to Length(BufferArrSender) - 3 do
      begin
           StrToCrc := StrToCrc + IntToHex(BufferArrSender[I],2) + ' ';
      end;
      ModBusCRC16(StrToCrc,CRC16Lo,CRC16Hi);
      BufferArrSender[Length(BufferArrSender)-2] := CRC16Lo;
      BufferArrSender[Length(BufferArrSender)-1] := CRC16Hi;
      if BeginOut <> -1 then
         AddLog('从'+InttoStr(BeginOut)+'地址开始越界了' + IntToStr(OutIndex) +'个寄存器,实际返回' + IntToStr(PointCount) + '个');
//      AddLog('发送 >> ' + ByteToStr(BufferArrSender));
      SpComm.WriteCommData(PChar(BufferArrSender),Length(BufferArrSender));
  end;
end;
procedure TMainForm.CustomReceiveErrorEvent(Sender: TObject; EventMask : DWORD);
begin
   AddLog(InttoStr(EventMask));
end;
procedure TMainForm.AddLog(logContent:string);
begin
    if (LogClear.Checked) and (Logs.Lines.Count >= 100) then
       Logs.Lines.Clear;
    Logs.Lines.Add(FormatDateTime('hh:mm:ss', now) + '  ' + logContent);
end;
procedure TMainForm.ClearLogBtnClick(Sender: TObject);
begin
  Clipboard.AsText := Logs.Text;
  Logs.Lines.Clear;
end;
procedure TMainForm.ComboBoxChange(Sender: TObject);
begin
     ((Sender as  TComboBox).Parent as  TGroupBox).Color := Colors[(Sender as  TComboBox).ItemIndex];
end;
procedure TMainForm.AutoChangeClick(Sender: TObject);
begin
    Timer.Enabled := AutoChange.Checked;
end;
function  TMainForm.ByteToStr(BufferArr:array of Byte):string;
var
  Str:string;
  I :Integer;
begin
  Str := '';
  for I := 0 to Length(BufferArr) - 1 do
  begin
      Str := Str + IntToHex(BufferArr[I],2) + ' ';
  end;
  Result := Str;
end;
function  TMainForm.ModBusCRC16(Data:String;var CRC16Hi,CRC16Lo:DWORD) : string;
var
  uIndex,uIndex1:Integer;
  Data1:String;
begin
  CRC16Lo := $FF; //CRC16Lo为CRC寄存器低8位
  CRC16Hi := $FF; //CRC16Hi为CRC寄存器高8位
  uIndex1:=1;
  Data1:=Trim(Data);
  while Length(Data1)>0 do
  begin
    uIndex := CRC16Hi xor (StrToInt('$'+(Data1[1])+(Data1[2])));
    CRC16Hi := CRC16Lo xor CRCTableHi[uIndex];
    CRC16Lo := CRCTableLo[uIndex];
    Data1:=Trim(MidStr(Data1,3,Length(Data1)));
  end;
  Result := IntToHex(CRC16Hi,2) + IntToHex(CRC16Lo,2);
end;
procedure TMainForm.TimerTimer(Sender: TObject);
var
  GroupBox     :TGroupBox;
  ComboBox     :TComboBox;
  I:Integer;
begin
  Randomize;
  I := Random(PointEnd-PointStart) + PointStart;

  GroupBox := PControl.FindChildControl('G' + InttoStr(I)) as TGroupBox;
  ComboBox := GroupBox.FindChildControl('C' + InttoStr(I)) as TComboBox;

  Randomize;
  I := Random(8);
  ComboBox.ItemIndex :=  I;
  GroupBox.Color := Colors[I];
end;

end.
