object WebForm: TWebForm
  Left = -500
  Top = -500
  AlphaBlend = True
  BorderStyle = bsSingle
  Caption = #25235#21462
  ClientHeight = 289
  ClientWidth = 710
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  Position = poDesigned
  PixelsPerInch = 96
  TextHeight = 13
  object WebBrowser: TWebBrowser
    Left = 0
    Top = 0
    Width = 710
    Height = 289
    Align = alClient
    TabOrder = 0
    OnNewWindow2 = WebBrowserNewWindow2
    OnDocumentComplete = WebBrowserDocumentComplete
    ExplicitWidth = 0
    ExplicitHeight = 0
    ControlData = {
      4C00000061490000DE1D00000000000000000000000000000000000000000000
      000000004C000000000000000000000001000000E0D057007335CF11AE690800
      2B2E126208000000000000004C0000000114020000000000C000000000000046
      8000000000000000000000000000000000000000000000000000000000000000
      00000000000000000100000000000000000000000000000000000000}
  end
end
