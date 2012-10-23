object frmNewUdpSock: TfrmNewUdpSock
  Left = 392
  Top = 233
  Width = 246
  Height = 247
  Caption = #21019#24314'UDP Client'
  Color = clCream
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  OnActivate = FormActivate
  PixelsPerInch = 96
  TextHeight = 13
  object Label1: TLabel
    Left = 32
    Top = 32
    Width = 47
    Height = 13
    Caption = #23545#26041'IP   '
  end
  object Label2: TLabel
    Left = 32
    Top = 90
    Width = 62
    Height = 13
    Caption = #23545#26041#31471#21475'  '
  end
  object Label3: TLabel
    Left = 32
    Top = 117
    Width = 68
    Height = 13
    Caption = #26412#22320#31471#21475'    '
  end
  object Edit1: TEdit
    Left = 96
    Top = 27
    Width = 105
    Height = 21
    TabOrder = 0
    Text = '127.0.0.1'
  end
  object Edit2: TEdit
    Left = 96
    Top = 85
    Width = 105
    Height = 21
    TabOrder = 1
    Text = '60000'
  end
  object Edit3: TEdit
    Left = 96
    Top = 111
    Width = 105
    Height = 21
    TabOrder = 2
    Text = '10000'
  end
  object Button1: TsuiButton
    Left = 32
    Top = 161
    Width = 80
    Height = 27
    UIStyle = WinXP
    Caption = #30830#23450
    AutoSize = False
    TabOrder = 3
    Transparent = False
    ModalResult = 0
    Layout = blGlyphLeft
    Spacing = 4
    ResHandle = 0
    OnClick = Button1Click
  end
  object suiButton1: TsuiButton
    Left = 120
    Top = 161
    Width = 80
    Height = 27
    UIStyle = WinXP
    Caption = #21462#28040
    AutoSize = False
    TabOrder = 4
    Transparent = False
    ModalResult = 0
    Layout = blGlyphLeft
    Spacing = 4
    ResHandle = 0
    OnClick = Button2Click
  end
  object Button3: TsuiButton
    Left = 96
    Top = 50
    Width = 105
    Height = 23
    UIStyle = WinXP
    Caption = #24191#25773#22320#22336
    AutoSize = False
    TabOrder = 5
    Transparent = False
    ModalResult = 0
    Layout = blGlyphLeft
    Spacing = 4
    ResHandle = 0
    OnClick = Button3Click
  end
end
