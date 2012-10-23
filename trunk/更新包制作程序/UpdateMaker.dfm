object Form2: TForm2
  Left = 0
  Top = 0
  BorderIcons = [biSystemMenu, biMinimize]
  BorderStyle = bsSingle
  Caption = #21319#32423#21253#21046#20316#24037#20855
  ClientHeight = 529
  ClientWidth = 738
  Color = clBtnFace
  Font.Charset = GB2312_CHARSET
  Font.Color = clWindowText
  Font.Height = -13
  Font.Name = #24494#36719#38597#40657
  Font.Style = []
  OldCreateOrder = False
  Position = poDesktopCenter
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 19
  object lbl2: TRzLabel
    Left = 34
    Top = 127
    Width = 52
    Height = 19
    Caption = #36873#25321#30446#24405
  end
  object RzLabel1: TRzLabel
    Left = 398
    Top = 128
    Width = 52
    Height = 19
    Caption = #36873#25321#25991#20214
  end
  object lbl3: TLabel
    Left = 34
    Top = 70
    Width = 52
    Height = 19
    Caption = #26356#26032#35828#26126
  end
  object lbl4: TLabel
    Left = 47
    Top = 41
    Width = 39
    Height = 19
    Caption = #29256#26412#21495
  end
  object lbl5: TRzLabel
    Left = 398
    Top = 41
    Width = 52
    Height = 19
    Caption = #23384#25918#30446#24405
  end
  object lbl6: TLabel
    Left = 8
    Top = 10
    Width = 78
    Height = 19
    Caption = #29256#26412#21015#34920#25991#20214
  end
  object lbl7: TLabel
    Left = 372
    Top = 10
    Width = 78
    Height = 19
    Caption = #39033#30446#25152#22312#30446#24405
  end
  object lbl8: TLabel
    Left = 60
    Top = 379
    Width = 26
    Height = 19
    Caption = #25351#20196
  end
  object rzshltr1: TRzShellTree
    Left = 98
    Top = 128
    Width = 294
    Height = 184
    Ctl3D = True
    Indent = 21
    ParentCtl3D = False
    ParentShowHint = False
    ReadOnly = True
    RightClickSelect = True
    RowSelect = True
    ShowHint = True
    ShowRoot = True
    TabOrder = 8
    OnChange = rzshltr1Change
  end
  object lst2: TRzFileListBox
    Left = 456
    Top = 128
    Width = 262
    Height = 184
    Ctl3D = True
    ItemHeight = 18
    ParentCtl3D = False
    PopupMenu = pm1
    TabOrder = 9
  end
  object mmo1: TMemo
    Left = 98
    Top = 379
    Width = 620
    Height = 105
    Ctl3D = True
    ParentCtl3D = False
    ScrollBars = ssVertical
    TabOrder = 11
  end
  object mmo2: TMemo
    Left = 98
    Top = 70
    Width = 625
    Height = 52
    Ctl3D = True
    ParentCtl3D = False
    ScrollBars = ssVertical
    TabOrder = 7
  end
  object btn2: TButton
    Left = 119
    Top = 492
    Width = 500
    Height = 25
    Caption = #29983#25104#26356#26032#21253
    TabOrder = 12
    OnClick = btn2Click
  end
  object edt3: TEdit
    Left = 461
    Top = 38
    Width = 184
    Height = 27
    Ctl3D = True
    ParentCtl3D = False
    ReadOnly = True
    TabOrder = 5
  end
  object btn3: TButton
    Left = 658
    Top = 39
    Width = 65
    Height = 25
    Caption = #36873#25321
    TabOrder = 6
    OnClick = btn3Click
  end
  object VersionList: TEdit
    Left = 98
    Top = 8
    Width = 183
    Height = 27
    ReadOnly = True
    TabOrder = 0
  end
  object btn4: TButton
    Left = 294
    Top = 8
    Width = 65
    Height = 25
    Caption = #36873#25321
    TabOrder = 1
    OnClick = btn4Click
  end
  object SystemPath: TEdit
    Left = 461
    Top = 8
    Width = 184
    Height = 27
    ReadOnly = True
    TabOrder = 2
  end
  object btn5: TButton
    Left = 658
    Top = 8
    Width = 65
    Height = 25
    Caption = #36873#25321
    TabOrder = 3
    OnClick = btn5Click
  end
  object edt2: TComboBox
    Left = 98
    Top = 38
    Width = 183
    Height = 27
    ItemHeight = 19
    TabOrder = 4
  end
  object Button1: TButton
    Left = 98
    Top = 328
    Width = 294
    Height = 25
    Caption = #30446#24405#20840#37096#26356#26032
    TabOrder = 10
    OnClick = Button1Click
  end
  object vclzp1: TVCLZip
    RecreateDirs = True
    Recurse = True
    StorePaths = True
    RelativePaths = True
    MultiZipInfo.BlockSize = 1457600
    AddDirEntriesOnRecurse = True
    Left = 164
    Top = 100
  end
  object pm1: TPopupMenu
    Left = 132
    Top = 100
    object N1: TMenuItem
      Caption = #26356#26032#25110#28155#21152
      OnClick = N1Click
    end
    object N2: TMenuItem
      Caption = #21024#38500
      OnClick = N2Click
    end
    object N3: TMenuItem
      Caption = #25191#34892#24182#20445#30041
      OnClick = N3Click
    end
    object N4: TMenuItem
      Caption = #25191#34892#24182#21024#38500
      OnClick = N4Click
    end
    object N5: TMenuItem
      Caption = #20840#37096#26356#26032#25110#28155#21152
      OnClick = N5Click
    end
  end
  object dlgOpen1: TOpenDialog
    FileName = 'updateList.txt'
    Filter = '*.txt|*.txt'
    Left = 100
    Top = 100
  end
end
