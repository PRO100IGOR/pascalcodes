object Form2: TForm2
  Left = 0
  Top = 0
  BorderIcons = [biSystemMenu, biMinimize]
  Caption = #26381#21153#31649#29702
  ClientHeight = 328
  ClientWidth = 655
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
    Width = 655
    Height = 57
    Align = alTop
    Caption = #26381#21153#25511#21046
    TabOrder = 0
    ExplicitLeft = -7
    ExplicitWidth = 662
    object ServerColor: TShape
      Left = 16
      Top = 13
      Width = 25
      Height = 33
      Brush.Color = clRed
      DragCursor = crHandPoint
      Shape = stCircle
    end
    object ServerState: TLabel
      Left = 56
      Top = 25
      Width = 48
      Height = 13
      Caption = #26816#27979#20013'...'
    end
    object btnStopStart: TButton
      Left = 480
      Top = 20
      Width = 75
      Height = 25
      Caption = #21551#21160#26381#21153
      Enabled = False
      TabOrder = 2
    end
    object btnClearLog: TButton
      Left = 568
      Top = 20
      Width = 75
      Height = 25
      Caption = #28165#31354#26085#24535
      TabOrder = 3
    end
    object btnInstallUnInstall: TButton
      Left = 391
      Top = 20
      Width = 75
      Height = 25
      Caption = #23433#35013#26381#21153
      Enabled = False
      TabOrder = 1
    end
    object btnAccessPj: TButton
      Left = 270
      Top = 20
      Width = 107
      Height = 25
      Caption = #23494#30721#30772#35299#24037#20855
      TabOrder = 0
    end
  end
  object LogMemo: TMemo
    Left = 0
    Top = 57
    Width = 655
    Height = 271
    Align = alClient
    ScrollBars = ssVertical
    TabOrder = 1
    ExplicitLeft = -7
    ExplicitTop = -88
    ExplicitWidth = 662
    ExplicitHeight = 416
  end
  object Timer: TTimer
    Left = 536
    Top = 105
  end
end
