object MainForm: TMainForm
  Left = 0
  Top = 0
  BorderIcons = []
  BorderStyle = bsNone
  Caption = 'MainForm'
  ClientHeight = 240
  ClientWidth = 463
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 13
  object WebBrowser: TWebBrowser
    Left = 0
    Top = 0
    Width = 463
    Height = 240
    Align = alClient
    TabOrder = 0
    OnDocumentComplete = WebBrowserDocumentComplete
    ExplicitLeft = 56
    ExplicitTop = 8
    ExplicitWidth = 300
    ExplicitHeight = 150
    ControlData = {
      4C000000DA2F0000CE1800000000000000000000000000000000000000000000
      000000004C000000000000000000000001000000E0D057007335CF11AE690800
      2B2E126208000000000000004C0000000114020000000000C000000000000046
      8000000000000000000000000000000000000000000000000000000000000000
      00000000000000000100000000000000000000000000000000000000}
  end
  object Timer: TTimer
    Interval = 120000
    OnTimer = TimerTimer
    Left = 328
    Top = 64
  end
end
