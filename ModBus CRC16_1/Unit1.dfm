object Form1: TForm1
  Left = 270
  Top = 153
  Width = 540
  Height = 313
  Caption = 'Form1'
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  PixelsPerInch = 96
  TextHeight = 13
  object Panel1: TPanel
    Left = 0
    Top = 0
    Width = 532
    Height = 286
    Align = alClient
    BevelInner = bvLowered
    Font.Charset = ANSI_CHARSET
    Font.Color = clWindowText
    Font.Height = -16
    Font.Name = #23435#20307
    Font.Style = []
    ParentFont = False
    TabOrder = 0
    object Label1: TLabel
      Left = 72
      Top = 56
      Width = 240
      Height = 16
      Caption = #35831#36755#20837#35201#26657#39564#30340#23383#31526#20018#65288'16'#36827#21046#65289
    end
    object Label2: TLabel
      Left = 72
      Top = 128
      Width = 72
      Height = 16
      Caption = 'CRC'#30721#20026#65306
    end
    object Edit1: TEdit
      Left = 72
      Top = 80
      Width = 241
      Height = 24
      TabOrder = 0
      Text = '01 02 03 04'
    end
    object Edit2: TEdit
      Left = 72
      Top = 152
      Width = 241
      Height = 24
      TabOrder = 1
    end
    object Button1: TButton
      Left = 104
      Top = 208
      Width = 88
      Height = 33
      Caption = #35745#31639
      TabOrder = 2
      OnClick = Button1Click
    end
    object Button2: TButton
      Left = 312
      Top = 208
      Width = 88
      Height = 33
      Caption = #20851#38381
      TabOrder = 3
      OnClick = Button2Click
    end
  end
end
