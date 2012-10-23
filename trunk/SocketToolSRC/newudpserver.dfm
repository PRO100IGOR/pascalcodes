object frmNewUDPServer: TfrmNewUDPServer
  Left = 360
  Top = 327
  Width = 242
  Height = 159
  Caption = #21019#24314'UDP Server'
  Color = clCream
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  PixelsPerInch = 96
  TextHeight = 13
  object Label3: TLabel
    Left = 32
    Top = 32
    Width = 68
    Height = 13
    Caption = #26412#22320#31471#21475'    '
  end
  object Edit3: TEdit
    Left = 96
    Top = 26
    Width = 105
    Height = 21
    TabOrder = 0
    Text = '60000'
  end
  object Button1: TsuiButton
    Left = 32
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
    Left = 120
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
