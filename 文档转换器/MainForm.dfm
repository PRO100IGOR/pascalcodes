object Form1: TForm1
  Left = 0
  Top = 0
  Caption = #36716#25442#25991#26723
  ClientHeight = 213
  ClientWidth = 455
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  PixelsPerInch = 96
  TextHeight = 13
  object Button1: TButton
    Left = 272
    Top = 96
    Width = 75
    Height = 25
    Caption = 'Button1'
    TabOrder = 0
    OnClick = Button1Click
  end
  object OpenDialog1: TOpenDialog
    Filter = '*.doc|*.doc|*.xsl|*.xsl'
    Left = 40
    Top = 48
  end
  object SaveDialog1: TSaveDialog
    Filter = '*.pdf|*.pdf'
    Left = 56
    Top = 104
  end
end
