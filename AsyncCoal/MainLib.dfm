object MainForm: TMainForm
  Left = 0
  Top = 0
  BorderIcons = [biSystemMenu, biMinimize]
  BorderStyle = bsSingle
  Caption = #29028#30719#39033#30446#21512#24182#24037#20855
  ClientHeight = 252
  ClientWidth = 472
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  Position = poDesktopCenter
  PixelsPerInch = 96
  TextHeight = 13
  object lbl7: TLabel
    Left = 8
    Top = 13
    Width = 72
    Height = 13
    Caption = #39033#30446#25152#22312#30446#24405
  end
  object SystemPath: TEdit
    Left = 86
    Top = 8
    Width = 299
    Height = 21
    ReadOnly = True
    TabOrder = 0
  end
  object btn5: TButton
    Left = 391
    Top = 6
    Width = 65
    Height = 25
    Caption = #36873#25321
    TabOrder = 1
    OnClick = btn5Click
  end
  object Logs: TMemo
    Left = 8
    Top = 35
    Width = 456
    Height = 209
    ScrollBars = ssVertical
    TabOrder = 2
  end
end
