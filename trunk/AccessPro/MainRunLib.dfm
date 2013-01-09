object MainView: TMainView
  Left = 0
  Top = 0
  BorderIcons = [biSystemMenu, biMinimize]
  BorderStyle = bsSingle
  Caption = #36816#34892#35270#22270
  ClientHeight = 358
  ClientWidth = 617
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  Position = poDesigned
  PixelsPerInch = 96
  TextHeight = 13
  object mmoLogs: TMemo
    Left = 0
    Top = 0
    Width = 617
    Height = 358
    Align = alClient
    ScrollBars = ssVertical
    TabOrder = 0
  end
  object TimerInit: TTimer
    Interval = 3000
    OnTimer = TimerInitTimer
    Left = 8
    Top = 24
  end
end
