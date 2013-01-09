object MainForm: TMainForm
  Left = 0
  Top = 0
  BorderIcons = [biSystemMenu, biMinimize]
  BorderStyle = bsSingle
  Caption = 'opc'#26381#21153#26032#29256
  ClientHeight = 464
  ClientWidth = 721
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  Position = poDesktopCenter
  OnDestroy = FormDestroy
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object Logs: TMemo
    Left = 0
    Top = 0
    Width = 721
    Height = 409
    Align = alTop
    ScrollBars = ssVertical
    TabOrder = 0
  end
  object LogClear: TCheckBox
    Left = 16
    Top = 426
    Width = 121
    Height = 17
    Caption = #22823#20110'100'#34892#33258#21160#28165#31354
    Checked = True
    State = cbChecked
    TabOrder = 1
  end
  object ClearLogBtn: TButton
    Left = 522
    Top = 426
    Width = 189
    Height = 25
    Caption = #22797#21046#24182#28165#31354#26085#24535
    TabOrder = 3
    OnClick = ClearLogBtnClick
  end
  object DeBugCk: TCheckBox
    Left = 160
    Top = 426
    Width = 73
    Height = 17
    Caption = #35843#35797#27169#24335
    Ctl3D = True
    ParentCtl3D = False
    TabOrder = 2
  end
  object Timer: TTimer
    OnTimer = TimerTimer
    Left = 24
    Top = 72
  end
  object TimeStart: TTimer
    Enabled = False
    Interval = 10000
    OnTimer = TimeStartTimer
    Left = 248
    Top = 416
  end
  object TimeRun: TTimer
    Enabled = False
    Interval = 10000
    OnTimer = TimeRunTimer
    Left = 296
    Top = 416
  end
end
