object MainForm: TMainForm
  Left = 0
  Top = 0
  BorderIcons = [biSystemMenu, biMinimize]
  Caption = 'MODBUS RTU'
  ClientHeight = 422
  ClientWidth = 775
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  Position = poDesktopCenter
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  PixelsPerInch = 96
  TextHeight = 13
  object Logs: TMemo
    Left = 0
    Top = 222
    Width = 775
    Height = 200
    Align = alBottom
    ScrollBars = ssVertical
    TabOrder = 0
  end
  object Panel1: TPanel
    Left = 0
    Top = 181
    Width = 775
    Height = 41
    Align = alBottom
    TabOrder = 1
    object ClearLogBtn: TButton
      Left = 616
      Top = 1
      Width = 158
      Height = 39
      Align = alRight
      Caption = #28165#31354#24182#22797#21046#26085#24535
      TabOrder = 0
      OnClick = ClearLogBtnClick
    end
    object LogClear: TCheckBox
      Left = 17
      Top = 13
      Width = 120
      Height = 17
      Caption = #22823#20110'100'#34892#33258#21160#28165#31354
      Checked = True
      State = cbChecked
      TabOrder = 1
    end
    object AutoChange: TCheckBox
      Left = 149
      Top = 13
      Width = 97
      Height = 17
      Caption = #33258#21160#21464#21270
      TabOrder = 2
      OnClick = AutoChangeClick
    end
  end
  object Timer: TTimer
    Enabled = False
    Interval = 500
    OnTimer = TimerTimer
    Left = 288
    Top = 184
  end
end
