object MainForm: TMainForm
  Left = 0
  Top = 0
  Caption = 'OBject-c'#32534#35793#36741#21161
  ClientHeight = 525
  ClientWidth = 960
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  Position = poDesktopCenter
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 13
  object GroupBox1: TGroupBox
    Left = 0
    Top = 0
    Width = 960
    Height = 51
    Align = alTop
    Caption = #24037#20855#26639
    TabOrder = 0
    object Install: TButton
      Left = 24
      Top = 16
      Width = 75
      Height = 25
      Caption = #23433#35013#29615#22659
      TabOrder = 0
      OnClick = InstallClick
    end
    object SetPath: TButton
      Left = 120
      Top = 16
      Width = 97
      Height = 25
      Caption = #35774#32622#29615#22659#30446#24405
      TabOrder = 1
      OnClick = SetPathClick
    end
    object Runer: TButton
      Left = 375
      Top = 16
      Width = 106
      Height = 25
      Caption = #36873#25321#20027#25991#20214#9313
      TabOrder = 2
      OnClick = RunerClick
    end
    object ClearBtn: TButton
      Left = 605
      Top = 16
      Width = 75
      Height = 25
      Caption = #28165#31354
      TabOrder = 3
      OnClick = ClearBtnClick
    end
    object RunMe: TButton
      Left = 503
      Top = 16
      Width = 75
      Height = 25
      Caption = #36816#34892#9314
      TabOrder = 4
      OnClick = RunMeClick
    end
    object CSFiles: TButton
      Left = 244
      Top = 16
      Width = 104
      Height = 25
      Caption = #36873#25321#39033#30446#30446#24405#9312
      TabOrder = 5
      OnClick = CSFilesClick
    end
  end
  object ShowArea: TMemo
    Left = 0
    Top = 51
    Width = 960
    Height = 453
    Align = alClient
    Color = clInfoText
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clLime
    Font.Height = -13
    Font.Name = 'Tahoma'
    Font.Style = []
    ParentFont = False
    ScrollBars = ssBoth
    TabOrder = 1
  end
  object InputArea: TEdit
    Left = 0
    Top = 504
    Width = 960
    Height = 21
    Align = alBottom
    Color = clInfoText
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clLime
    Font.Height = -11
    Font.Name = 'Tahoma'
    Font.Style = []
    ParentFont = False
    TabOrder = 2
    OnKeyUp = InputAreaKeyUp
  end
  object OpenDialog: TOpenDialog
    Filter = 'ObjectC'#25991#20214'|*.m'
    Left = 888
    Top = 16
  end
end
