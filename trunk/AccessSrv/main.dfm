object MainForm: TMainForm
  Left = 0
  Top = 0
  Caption = #22235#21644'Access'#25968#25454#37319#38598
  ClientHeight = 464
  ClientWidth = 594
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  PixelsPerInch = 96
  TextHeight = 13
  object Logs: TMemo
    Left = 0
    Top = 0
    Width = 594
    Height = 409
    Align = alTop
    ScrollBars = ssVertical
    TabOrder = 0
  end
  object LogClear: TCheckBox
    Left = 8
    Top = 431
    Width = 121
    Height = 17
    Caption = #22823#20110'100'#34892#33258#21160#28165#31354
    Checked = True
    State = cbChecked
    TabOrder = 1
  end
  object ClearLogBtn: TButton
    Left = 389
    Top = 427
    Width = 189
    Height = 25
    Caption = #28165#31354#26085#24535
    TabOrder = 2
  end
  object Timer: TTimer
    OnTimer = TimerTimer
    Left = 24
    Top = 72
  end
  object TimerRead: TTimer
    Enabled = False
    OnTimer = TimerReadTimer
    Left = 232
    Top = 424
  end
  object UniConnection: TUniConnection
    ProviderName = 'Oracle'
    Port = 1521
    SpecificOptions.Strings = (
      'Oracle.Direct=True')
    Username = 'oxhide'
    Password = 'oxhide'
    Server = '10.10.0.158:1521:oracle'
    LoginPrompt = False
    Left = 272
    Top = 424
  end
  object OracleUniProvider: TOracleUniProvider
    Left = 312
    Top = 424
  end
  object UniQuery: TUniQuery
    Connection = UniConnection
    Left = 200
    Top = 424
  end
end
