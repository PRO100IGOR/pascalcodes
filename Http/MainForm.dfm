object Form1: TForm1
  Left = 0
  Top = 0
  BorderStyle = bsSingle
  Caption = #27979#35797
  ClientHeight = 555
  ClientWidth = 635
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  Position = poDesktopCenter
  PixelsPerInch = 96
  TextHeight = 13
  object GroupBox1: TGroupBox
    Left = 0
    Top = 0
    Width = 635
    Height = 105
    Align = alTop
    Caption = #30331#24405
    TabOrder = 0
    object Label1: TLabel
      Left = 21
      Top = 16
      Width = 36
      Height = 13
      Caption = #29992#25143#21517
    end
    object Label2: TLabel
      Left = 197
      Top = 16
      Width = 33
      Height = 13
      Caption = #23494'   '#30721
    end
    object Label3: TLabel
      Left = 9
      Top = 42
      Width = 48
      Height = 13
      Caption = #30331#24405#22320#22336
    end
    object Label4: TLabel
      Left = 389
      Top = 16
      Width = 48
      Height = 13
      Caption = #31995#32479#32534#30721
    end
    object Label7: TLabel
      Left = 9
      Top = 71
      Width = 48
      Height = 13
      Caption = #26597#35810#22320#22336
    end
    object Edit1: TEdit
      Left = 63
      Top = 12
      Width = 121
      Height = 21
      TabOrder = 0
      Text = 'admin'
    end
    object Edit2: TEdit
      Left = 253
      Top = 12
      Width = 121
      Height = 21
      TabOrder = 1
      Text = '888888'
    end
    object Edit3: TEdit
      Left = 63
      Top = 39
      Width = 519
      Height = 21
      TabOrder = 2
      Text = 'http://10.10.0.149:8080/oxhide'
    end
    object Button1: TButton
      Left = 496
      Top = 66
      Width = 86
      Height = 25
      Caption = #30331#24405
      TabOrder = 3
      OnClick = Button1Click
    end
    object Edit4: TEdit
      Left = 445
      Top = 12
      Width = 137
      Height = 21
      TabOrder = 4
      Text = 'XTGL'
    end
    object Edit6: TEdit
      Left = 63
      Top = 68
      Width = 427
      Height = 21
      TabOrder = 5
      Text = 'http://10.10.0.149:8080/coal/sqlqueryShowAction.do?action=query'
    end
  end
  object GroupBox2: TGroupBox
    Left = 0
    Top = 105
    Width = 635
    Height = 90
    Align = alTop
    Caption = #30331#24405#32467#26524
    Enabled = False
    TabOrder = 1
    object Label5: TLabel
      Left = 9
      Top = 12
      Width = 3
      Height = 13
    end
    object Label6: TLabel
      Left = 21
      Top = 57
      Width = 60
      Height = 13
      Caption = #26597#35810#21442#25968#65306
    end
    object Button2: TButton
      Left = 525
      Top = 51
      Width = 113
      Height = 25
      Caption = #26597#35810
      TabOrder = 0
      OnClick = Button2Click
    end
    object ComboBox1: TComboBox
      Left = 87
      Top = 54
      Width = 419
      Height = 21
      ItemHeight = 13
      TabOrder = 1
    end
  end
  object StringGrid: TStringGrid
    Left = 0
    Top = 195
    Width = 635
    Height = 360
    Align = alClient
    ColCount = 1
    FixedCols = 0
    RowCount = 1
    FixedRows = 0
    Options = [goFixedVertLine, goFixedHorzLine, goVertLine, goHorzLine, goRowSizing, goColSizing, goEditing]
    TabOrder = 2
  end
end
