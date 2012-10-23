object Form1: TForm1
  Left = 393
  Top = 260
  BorderStyle = bsToolWindow
  Caption = 'FormSpy'
  ClientHeight = 162
  ClientWidth = 347
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -12
  Font.Name = 'Courier New'
  Font.Style = []
  FormStyle = fsStayOnTop
  OldCreateOrder = False
  PixelsPerInch = 96
  TextHeight = 15
  object Bevel1: TBevel
    Left = 8
    Top = 8
    Width = 329
    Height = 145
    Style = bsRaised
  end
  object Panel1: TPanel
    Left = 19
    Top = 16
    Width = 150
    Height = 20
    BevelOuter = bvLowered
    TabOrder = 0
    object Label1: TLabel
      Left = 1
      Top = 1
      Width = 14
      Height = 18
      Align = alLeft
      Caption = 'X:'
    end
    object labelx: TLabel
      Left = 15
      Top = 1
      Width = 134
      Height = 18
      Align = alClient
      Alignment = taCenter
    end
  end
  object Panel2: TPanel
    Left = 179
    Top = 16
    Width = 150
    Height = 20
    BevelOuter = bvLowered
    TabOrder = 1
    object Label3: TLabel
      Left = 1
      Top = 1
      Width = 14
      Height = 18
      Align = alLeft
      Caption = 'Y:'
    end
    object labely: TLabel
      Left = 15
      Top = 1
      Width = 134
      Height = 18
      Align = alClient
      Alignment = taCenter
    end
  end
  object Panel3: TPanel
    Left = 19
    Top = 48
    Width = 310
    Height = 20
    BevelOuter = bvLowered
    TabOrder = 2
    object Label5: TLabel
      Left = 1
      Top = 1
      Width = 49
      Height = 18
      Align = alLeft
      Caption = 'Handle:'
    end
    object labelHandle: TLabel
      Left = 50
      Top = 1
      Width = 259
      Height = 18
      Align = alClient
      Alignment = taCenter
    end
  end
  object Panel4: TPanel
    Left = 19
    Top = 112
    Width = 310
    Height = 20
    BevelOuter = bvLowered
    TabOrder = 3
    object Label7: TLabel
      Left = 1
      Top = 1
      Width = 70
      Height = 18
      Align = alLeft
      Caption = 'ClassName:'
    end
    object labelName: TLabel
      Left = 71
      Top = 1
      Width = 238
      Height = 18
      Align = alClient
      Alignment = taCenter
    end
  end
  object Panel5: TPanel
    Left = 19
    Top = 80
    Width = 310
    Height = 20
    BevelOuter = bvLowered
    TabOrder = 4
    object Label2: TLabel
      Left = 1
      Top = 1
      Width = 35
      Height = 18
      Align = alLeft
      Caption = 'Text:'
    end
    object labelText: TLabel
      Left = 36
      Top = 1
      Width = 273
      Height = 18
      Align = alClient
      Alignment = taCenter
    end
  end
  object Timer1: TTimer
    Interval = 1
    OnTimer = Timer1Timer
    Left = 296
    Top = 72
  end
end
