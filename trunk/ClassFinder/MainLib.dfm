object MainForm: TMainForm
  Left = 0
  Top = 0
  BorderIcons = [biSystemMenu, biMinimize]
  Caption = #31867#21517#26597#25214
  ClientHeight = 447
  ClientWidth = 762
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  Position = poDesktopCenter
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 13
  object Label1: TLabel
    Left = 191
    Top = 8
    Width = 42
    Height = 28
    Caption = #21477#26564
    Font.Charset = ANSI_CHARSET
    Font.Color = clWindowText
    Font.Height = -21
    Font.Name = #24494#36719#38597#40657
    Font.Style = []
    ParentFont = False
  end
  object Label2: TLabel
    Left = 8
    Top = 8
    Width = 42
    Height = 28
    Caption = #22352#26631
    Font.Charset = ANSI_CHARSET
    Font.Color = clWindowText
    Font.Height = -21
    Font.Name = #24494#36719#38597#40657
    Font.Style = []
    ParentFont = False
  end
  object Label3: TLabel
    Left = 382
    Top = 8
    Width = 42
    Height = 28
    Caption = #20869#23481
    Font.Charset = ANSI_CHARSET
    Font.Color = clWindowText
    Font.Height = -21
    Font.Name = #24494#36719#38597#40657
    Font.Style = []
    ParentFont = False
  end
  object Label4: TLabel
    Left = 573
    Top = 8
    Width = 42
    Height = 28
    Caption = #31867#21517
    Font.Charset = ANSI_CHARSET
    Font.Color = clWindowText
    Font.Height = -21
    Font.Name = #24494#36719#38597#40657
    Font.Style = []
    ParentFont = False
  end
  object Memo1: TMemo
    Left = 0
    Top = 40
    Width = 185
    Height = 407
    ScrollBars = ssBoth
    TabOrder = 0
  end
  object Memo2: TMemo
    Left = 191
    Top = 40
    Width = 185
    Height = 407
    ScrollBars = ssHorizontal
    TabOrder = 1
  end
  object Memo3: TMemo
    Left = 382
    Top = 40
    Width = 185
    Height = 407
    ScrollBars = ssBoth
    TabOrder = 2
  end
  object Memo4: TMemo
    Left = 573
    Top = 40
    Width = 185
    Height = 407
    ScrollBars = ssBoth
    TabOrder = 3
  end
  object Button1: TButton
    Left = 679
    Top = 8
    Width = 75
    Height = 25
    Caption = #20572#27490
    TabOrder = 4
    OnClick = Button1Click
  end
  object Timer1: TTimer
    Interval = 1
    OnTimer = Timer1Timer
    Left = 8
    Top = 408
  end
end
