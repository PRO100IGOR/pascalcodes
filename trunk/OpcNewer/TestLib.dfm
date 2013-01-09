object TestForm: TTestForm
  Left = 0
  Top = 0
  BorderIcons = [biSystemMenu, biMinimize]
  BorderStyle = bsSingle
  Caption = #27979#35797#31383#21475
  ClientHeight = 404
  ClientWidth = 710
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
  object Label1: TLabel
    Left = 92
    Top = 6
    Width = 36
    Height = 13
    Caption = #26381#21153#21517
  end
  object Label2: TLabel
    Left = 340
    Top = 6
    Width = 24
    Height = 13
    Caption = #28857#21517
  end
  object SERVERNAME: TEdit
    Left = 92
    Top = 25
    Width = 229
    Height = 21
    TabOrder = 0
  end
  object GROUPNAME: TEdit
    Left = 340
    Top = 25
    Width = 253
    Height = 21
    TabOrder = 1
  end
  object AddBtn: TButton
    Left = 627
    Top = 23
    Width = 75
    Height = 25
    Caption = #28155#21152#30417#25511
    Enabled = False
    TabOrder = 2
    OnClick = AddBtnClick
  end
  object Logs: TMemo
    Left = 8
    Top = 54
    Width = 694
    Height = 315
    ScrollBars = ssVertical
    TabOrder = 3
  end
  object ClearBtn: TButton
    Left = 627
    Top = 375
    Width = 75
    Height = 25
    Caption = #28165#31354
    TabOrder = 4
    OnClick = ClearBtnClick
  end
  object AutoClear: TCheckBox
    Left = 8
    Top = 379
    Width = 121
    Height = 17
    Caption = '100'#34892#33258#21160#28165#31354
    Checked = True
    State = cbChecked
    TabOrder = 5
  end
  object ConBtn: TButton
    Left = 8
    Top = 21
    Width = 75
    Height = 25
    Caption = #36830#25509
    TabOrder = 6
    OnClick = ConBtnClick
  end
end
