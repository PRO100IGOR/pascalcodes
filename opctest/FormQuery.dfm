object FormQueryUnit: TFormQueryUnit
  Left = 0
  Top = 0
  Caption = 'OPC'#36718#35810#26041#24335
  ClientHeight = 463
  ClientWidth = 639
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  OnDestroy = FormDestroy
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object Logs: TMemo
    Left = 0
    Top = 0
    Width = 639
    Height = 409
    Align = alTop
    ScrollBars = ssVertical
    TabOrder = 0
  end
  object LogClear: TCheckBox
    Left = 24
    Top = 428
    Width = 121
    Height = 17
    Caption = #22823#20110'100'#34892#33258#21160#28165#31354
    Checked = True
    State = cbChecked
    TabOrder = 1
  end
  object ClearLogBtn: TButton
    Left = 397
    Top = 424
    Width = 189
    Height = 25
    Caption = #28165#31354#26085#24535
    TabOrder = 2
    OnClick = ClearLogBtnClick
  end
  object DeBugCk: TCheckBox
    Left = 168
    Top = 428
    Width = 73
    Height = 17
    Caption = #35843#35797#27169#24335
    TabOrder = 3
  end
  object Timer: TTimer
    OnTimer = TimerTimer
    Left = 264
    Top = 424
  end
  object ReadServer: TTimer
    Enabled = False
    OnTimer = ReadServerTimer
    Left = 304
    Top = 424
  end
end
