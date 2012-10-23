object MainForm: TMainForm
  Left = 0
  Top = 0
  Caption = 'MainForm'
  ClientHeight = 454
  ClientWidth = 800
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 13
  object Logs: TMemo
    Left = 0
    Top = 0
    Width = 800
    Height = 409
    Align = alTop
    ScrollBars = ssVertical
    TabOrder = 0
  end
  object ClearLogBtn: TButton
    Left = 603
    Top = 421
    Width = 189
    Height = 25
    Caption = #22797#21046#24182#28165#31354#26085#24535
    TabOrder = 1
    OnClick = ClearLogBtnClick
  end
  object LogClear: TCheckBox
    Left = 16
    Top = 426
    Width = 121
    Height = 17
    Caption = #22823#20110'100'#34892#33258#21160#28165#31354
    Checked = True
    State = cbChecked
    TabOrder = 2
  end
  object DeBugCk: TCheckBox
    Left = 160
    Top = 426
    Width = 73
    Height = 17
    Caption = #35843#35797#27169#24335
    TabOrder = 3
  end
  object Timer: TTimer
    Enabled = False
    OnTimer = TimerTimer
    Left = 40
    Top = 416
  end
  object TimerFree: TTimer
    Interval = 60000
    OnTimer = TimerFreeTimer
    Left = 8
    Top = 416
  end
end
