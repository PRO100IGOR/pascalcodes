object MainForm: TMainForm
  Left = 0
  Top = 0
  BorderIcons = [biSystemMenu, biMinimize]
  Caption = #26381#21153#31649#29702
  ClientHeight = 419
  ClientWidth = 667
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
    Width = 667
    Height = 57
    Align = alTop
    Caption = #26381#21153#25511#21046
    TabOrder = 0
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
      TabOrder = 1
      OnClick = btnStopStartClick
    end
    object btnClearLog: TButton
      Left = 568
      Top = 20
      Width = 75
      Height = 25
      Caption = #28165#31354#26085#24535
      TabOrder = 2
      OnClick = btnClearLogClick
    end
    object btnInstallUnInstall: TButton
      Left = 399
      Top = 20
      Width = 75
      Height = 25
      Caption = #23433#35013#26381#21153
      Enabled = False
      TabOrder = 0
      OnClick = btnInstallUnInstallClick
    end
  end
  object LogMemo: TMemo
    Left = 0
    Top = 57
    Width = 667
    Height = 362
    Align = alClient
    ScrollBars = ssVertical
    TabOrder = 1
  end
  object Timer: TTimer
    OnTimer = TimerTimer
    Left = 536
    Top = 105
  end
end
