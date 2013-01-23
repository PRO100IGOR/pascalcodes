object Form1: TForm1
  Left = 0
  Top = 0
  BorderIcons = [biSystemMenu, biMinimize]
  Caption = #31867#21517#26597#25214
  ClientHeight = 452
  ClientWidth = 760
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
  object Memo4: TMemo
    Left = 8
    Top = 40
    Width = 746
    Height = 404
    ScrollBars = ssBoth
    TabOrder = 0
  end
  object Button1: TButton
    Left = 679
    Top = 8
    Width = 75
    Height = 25
    Caption = #20572#27490
    TabOrder = 1
    OnClick = Button1Click
  end
  object Timer1: TTimer
    Interval = 1
    OnTimer = Timer1Timer
    Left = 600
    Top = 24
  end
end
