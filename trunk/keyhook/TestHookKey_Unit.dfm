object Form1: TForm1
  Left = 438
  Top = 292
  BorderStyle = bsNone
  Caption = 'Form1'
  ClientHeight = 281
  ClientWidth = 359
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  FormStyle = fsStayOnTop
  OldCreateOrder = False
  WindowState = wsMaximized
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  PixelsPerInch = 96
  TextHeight = 13
  object Button1: TButton
    Left = 168
    Top = 240
    Width = 75
    Height = 25
    Caption = 'HOOK'
    TabOrder = 0
    OnClick = Button1Click
  end
  object Button2: TButton
    Left = 264
    Top = 240
    Width = 75
    Height = 25
    Caption = 'NO HOOK'
    TabOrder = 1
    OnClick = Button2Click
  end
  object Memo1: TMemo
    Left = 16
    Top = 8
    Width = 329
    Height = 217
    Lines.Strings = (
      'Memo1')
    TabOrder = 2
  end
  object Button3: TButton
    Left = 72
    Top = 240
    Width = 75
    Height = 25
    Caption = 'close'
    TabOrder = 3
    OnClick = Button3Click
  end
  object Timer1: TTimer
    Enabled = False
    Interval = 1
    OnTimer = Timer1Timer
    Left = 112
    Top = 96
  end
end
