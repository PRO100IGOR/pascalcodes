object frmNewClientSock: TfrmNewClientSock
  Left = 344
  Top = 238
  Width = 259
  Height = 209
  Caption = #21019#24314'Socket'#23458#25143#31471
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
    Top = 37
    Width = 53
    Height = 13
    Caption = #23545#26041'IP:    '
  end
  object Label2: TLabel
    Left = 32
    Top = 72
    Width = 65
    Height = 13
    Caption = #23545#26041#31471#21475':  '
  end
  object Edit1: TEdit
    Left = 96
    Top = 32
    Width = 97
    Height = 21
    TabOrder = 0
    Text = '127.0.0.1'
  end
  object Edit2: TEdit
    Left = 96
    Top = 69
    Width = 97
    Height = 21
    TabOrder = 1
    Text = '60000'
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
