object frmNewServerSock: TfrmNewServerSock
  Left = 297
  Top = 301
  Width = 285
  Height = 166
  Caption = #21019#24314'Socket'#26381#21153#22120
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
    Left = 48
    Top = 27
    Width = 65
    Height = 13
    Caption = #30417#21548#31471#21475':  '
  end
  object Edit1: TEdit
    Left = 104
    Top = 24
    Width = 113
    Height = 21
    TabOrder = 0
    Text = '60000'
  end
  object Button1: TsuiButton
    Left = 48
    Top = 65
    Width = 80
    Height = 27
    UIStyle = WinXP
    Caption = #30830#23450
    AutoSize = False
    TabOrder = 1
    Transparent = False
    ModalResult = 0
    Layout = blGlyphLeft
    Spacing = 4
    ResHandle = 0
    OnClick = Button1Click
  end
  object Button2: TsuiButton
    Left = 136
    Top = 65
    Width = 80
    Height = 27
    UIStyle = WinXP
    Caption = #21462#28040
    AutoSize = False
    TabOrder = 2
    Transparent = False
    ModalResult = 0
    Layout = blGlyphLeft
    Spacing = 4
    ResHandle = 0
    OnClick = Button2Click
  end
end
