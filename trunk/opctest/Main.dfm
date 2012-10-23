object MainForm: TMainForm
  Left = 0
  Top = 0
  Caption = 'OPC'#23458#25143#31471
  ClientHeight = 461
  ClientWidth = 829
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  Position = poDesktopCenter
  OnCreate = FormCreate
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object Logs: TMemo
    Left = 0
    Top = 131
    Width = 829
    Height = 330
    Align = alClient
    ScrollBars = ssVertical
    TabOrder = 0
    ExplicitTop = 137
  end
  object GroupBox1: TGroupBox
    Left = 0
    Top = 0
    Width = 829
    Height = 131
    Align = alTop
    Caption = #25805#20316
    TabOrder = 1
    object Label1: TLabel
      Left = 768
      Top = 88
      Width = 12
      Height = 13
      Caption = #20010
    end
    object LogClear: TCheckBox
      Left = 40
      Top = 20
      Width = 121
      Height = 17
      Caption = #22823#20110'100'#34892#33258#21160#28165#31354
      Checked = True
      State = cbChecked
      TabOrder = 0
    end
    object ClearLogBtn: TButton
      Left = 237
      Top = 52
      Width = 189
      Height = 25
      Caption = #28165#31354#26085#24535
      TabOrder = 1
      OnClick = ClearLogBtnClick
    end
    object DeBugCk: TCheckBox
      Left = 196
      Top = 20
      Width = 73
      Height = 17
      Caption = #35843#35797#27169#24335
      TabOrder = 2
    end
    object Button1: TButton
      Left = 40
      Top = 52
      Width = 189
      Height = 25
      Caption = #36941#21382#26381#21153
      TabOrder = 3
      OnClick = Button1Click
    end
    object Button2: TButton
      Left = 40
      Top = 83
      Width = 189
      Height = 25
      Caption = #36941#21382#35813#26381#21153#28857':'
      TabOrder = 4
      OnClick = Button2Click
    end
    object Button3: TButton
      Left = 408
      Top = 83
      Width = 227
      Height = 25
      Caption = #24320#22987#30417#21548#27492#26381#21153#28857
      TabOrder = 5
      OnClick = Button3Click
    end
    object ServerName: TComboBox
      Left = 237
      Top = 85
      Width = 148
      Height = 21
      Style = csDropDownList
      ItemHeight = 13
      TabOrder = 6
    end
    object Button4: TButton
      Left = 446
      Top = 52
      Width = 189
      Height = 25
      Caption = #20572#27490#30417#21548
      TabOrder = 7
      OnClick = Button4Click
    end
    object COUNTS: TEdit
      Left = 641
      Top = 85
      Width = 121
      Height = 21
      TabOrder = 8
      Text = '10'
    end
  end
end
