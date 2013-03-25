object MainForm: TMainForm
  Left = 0
  Top = 0
  BorderIcons = [biSystemMenu, biMinimize]
  Caption = #25968#25454#26356#26032#24773#20917#37319#38598
  ClientHeight = 54
  ClientWidth = 354
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  Position = poDesktopCenter
  OnClick = FormClick
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 13
  object Timer: TTimer
    Enabled = False
    OnTimer = TimerTimer
    Left = 48
    Top = 16
  end
  object UniConnection: TUniConnection
    ProviderName = 'MySQL'
    Left = 80
    Top = 16
  end
  object UniQuery: TUniQuery
    Connection = UniConnection
    Left = 112
    Top = 16
  end
  object MySQLUniProvider: TMySQLUniProvider
    Left = 16
    Top = 16
  end
end
