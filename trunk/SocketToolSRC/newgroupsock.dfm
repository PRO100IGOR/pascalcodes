object frmNewGroupSock: TfrmNewGroupSock
  Left = 312
  Top = 289
  Width = 250
  Height = 203
  Caption = #21019#24314'UDP'#32452#25773
  Color = clCream
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  PixelsPerInch = 96
  TextHeight = 13
  object Label1: TLabel
    Left = 32
    Top = 27
    Width = 65
    Height = 13
    Caption = #32452#25773#22320#22336':  '
  end
  object Label2: TLabel
    Left = 32
    Top = 64
    Width = 62
    Height = 13
    Caption = #32452#25773#31471#21475': '
  end
  object Edit1: TEdit
    Left = 96
    Top = 24
    Width = 97
    Height = 21
    TabOrder = 0
    Text = '224.1.1.1'
  end
  object Edit2: TEdit
    Left = 96
    Top = 61
    Width = 97
    Height = 21
    TabOrder = 1
    Text = '65000'
  end
  object Button1: TsuiButton
    Left = 32
    Top = 112
    Width = 80
    Height = 27
    UIStyle = WinXP
    Caption = #30830#23450
    AutoSize = False
    TabOrder = 2
    Transparent = False
    ModalResult = 0
    Layout = blGlyphLeft
    Spacing = 4
    ResHandle = 0
    OnClick = Button1Click
  end
  object Button2: TsuiButton
    Left = 120
    Top = 112
    Width = 80
    Height = 27
    UIStyle = WinXP
    Caption = #21462#28040
    AutoSize = False
    TabOrder = 3
    Transparent = False
    ModalResult = 0
    Layout = blGlyphLeft
    Spacing = 4
    ResHandle = 0
    OnClick = Button2Click
  end
end
