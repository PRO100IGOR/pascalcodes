object MainForm: TMainForm
  Left = 0
  Top = 0
  Caption = #28023#28286'MODBUS RTU'#36890#35759
  ClientHeight = 471
  ClientWidth = 829
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
    Top = 271
    Width = 829
    Height = 200
    Align = alBottom
    ScrollBars = ssVertical
    TabOrder = 0
  end
  object Panel1: TPanel
    Left = 0
    Top = 230
    Width = 829
    Height = 41
    Align = alBottom
    TabOrder = 1
    object ClearLogBtn: TButton
      Left = 670
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
  end
end
