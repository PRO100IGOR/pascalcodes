object FrmData: TFrmData
  Left = 309
  Top = 193
  Width = 511
  Height = 509
  Caption = #25968#25454#25910#21457#31383#21475
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  FormStyle = fsMDIChild
  OldCreateOrder = False
  Position = poDefault
  Visible = True
  WindowState = wsMaximized
  PixelsPerInch = 96
  TextHeight = 13
  object GroupBox1: TGroupBox
    Left = 0
    Top = 0
    Width = 503
    Height = 81
    Align = alTop
    Caption = 'Socket'#29366#24577
    Color = clCream
    ParentColor = False
    TabOrder = 0
    object Label1: TLabel
      Left = 16
      Top = 24
      Width = 73
      Height = 13
      AutoSize = False
      Caption = 'linkstatus'
      Transparent = True
    end
    object Label2: TLabel
      Left = 96
      Top = 24
      Width = 32
      Height = 13
      Caption = 'Label2'
      Transparent = True
      Visible = False
    end
    object Label3: TLabel
      Left = 232
      Top = 24
      Width = 129
      Height = 13
      AutoSize = False
      Caption = 'Label3'
      Transparent = True
    end
    object Label4: TLabel
      Left = 365
      Top = 24
      Width = 132
      Height = 13
      AutoSize = False
      Caption = 'Label4'
      Transparent = True
    end
    object Label5: TLabel
      Left = 232
      Top = 56
      Width = 129
      Height = 13
      AutoSize = False
      Caption = 'Label5'
      Transparent = True
    end
    object Label6: TLabel
      Left = 367
      Top = 56
      Width = 129
      Height = 13
      AutoSize = False
      Caption = 'Label6'
      Transparent = True
    end
    object Button5: TsuiButton
      Left = 16
      Top = 48
      Width = 80
      Height = 27
      UIStyle = WinXP
      AutoSize = False
      Visible = False
      TabOrder = 0
      Transparent = False
      ModalResult = 0
      Layout = blGlyphLeft
      Spacing = 4
      ResHandle = 0
      OnClick = Button5Click
    end
    object Button6: TsuiButton
      Left = 104
      Top = 48
      Width = 80
      Height = 27
      UIStyle = WinXP
      AutoSize = False
      Visible = False
      TabOrder = 1
      Transparent = False
      ModalResult = 0
      Layout = blGlyphLeft
      Spacing = 4
      ResHandle = 0
      OnClick = Button6Click
      OnMouseUp = Button6MouseUp
    end
    object ckwebsvr: TCheckBox
      Left = 96
      Top = 0
      Width = 97
      Height = 17
      Caption = #21551#21160'Web'#26381#21153
      TabOrder = 2
      Visible = False
    end
  end
  object Panel2: TPanel
    Left = 0
    Top = 81
    Width = 503
    Height = 394
    Align = alClient
    Caption = 'Panel2'
    TabOrder = 1
    object Panel4: TPanel
      Left = 1
      Top = 1
      Width = 501
      Height = 164
      Align = alTop
      Caption = 'Panel4'
      TabOrder = 0
      object GroupBox3: TGroupBox
        Left = 1
        Top = 1
        Width = 499
        Height = 162
        Align = alClient
        Caption = #25968#25454#25509#25910#21450#25552#31034#31383#21475
        Color = clCream
        ParentColor = False
        TabOrder = 0
        object Memo2: TMemo
          Left = 2
          Top = 15
          Width = 495
          Height = 145
          Align = alClient
          Color = 16644599
          ImeName = #20013#25991' ('#31616#20307') - '#24494#36719#25340#38899
          TabOrder = 0
        end
      end
    end
    object GroupBox2: TGroupBox
      Left = 1
      Top = 165
      Width = 501
      Height = 228
      Align = alClient
      Caption = #25968#25454#21457#36865#31383#21475'('#25991#26412#27169#24335')'
      Color = clCream
      ParentColor = False
      TabOrder = 1
      object Panel6: TPanel
        Left = 342
        Top = 15
        Width = 157
        Height = 170
        Align = alRight
        Color = clCream
        TabOrder = 0
        object Label7: TLabel
          Left = 24
          Top = 40
          Width = 93
          Height = 13
          Caption = #37325#22797#21457#36865#27425#25968'       '
        end
        object Label8: TLabel
          Left = 16
          Top = 104
          Width = 43
          Height = 13
          Caption = #38388#38548'(ms)'
        end
        object ComboBox2: TComboBox
          Left = 24
          Top = 60
          Width = 97
          Height = 21
          ImeName = #20013#25991' ('#31616#20307') - '#20840#25340
          ItemHeight = 13
          TabOrder = 0
          Text = '1'
          Items.Strings = (
            '1'
            '10'
            '100'
            '1000'
            '10000')
        end
        object StatusBar2: TStatusBar
          Left = 1
          Top = 150
          Width = 155
          Height = 19
          Color = clCream
          Panels = <
            item
              Width = 100
            end>
          SimplePanel = False
        end
        object Button11: TsuiButton
          Left = 24
          Top = 1
          Width = 93
          Height = 25
          UIStyle = WinXP
          Caption = #21457#36865#25968#25454
          AutoSize = False
          TabOrder = 2
          Transparent = False
          ModalResult = 0
          Layout = blGlyphLeft
          Spacing = 4
          ResHandle = 0
          OnClick = Button11Click
        end
        object suiButton1: TsuiButton
          Left = 8
          Top = 124
          Width = 57
          Height = 23
          UIStyle = WinXP
          Caption = #23450#26102#21457#36865
          AutoSize = False
          TabOrder = 3
          Transparent = False
          ModalResult = 0
          Layout = blGlyphLeft
          Spacing = 4
          ResHandle = 0
          OnClick = suiButton1Click
        end
        object suiButton2: TsuiButton
          Left = 72
          Top = 124
          Width = 81
          Height = 22
          UIStyle = WinXP
          Caption = #20572#27490#23450#26102#21457#36865
          AutoSize = False
          TabOrder = 4
          Transparent = False
          ModalResult = 0
          Layout = blGlyphLeft
          Spacing = 4
          ResHandle = 0
          OnClick = suiButton2Click
        end
        object Edit1: TEdit
          Left = 69
          Top = 101
          Width = 48
          Height = 21
          TabOrder = 5
          Text = '1000'
        end
      end
      object Memo3: TMemo
        Left = 2
        Top = 15
        Width = 340
        Height = 170
        Align = alClient
        Color = clBtnHighlight
        ImeName = #20013#25991' ('#31616#20307') - '#26234#33021' ABC'
        TabOrder = 1
        OnKeyPress = Memo3KeyPress
      end
      object GroupBox8: TGroupBox
        Left = 2
        Top = 185
        Width = 497
        Height = 41
        Align = alBottom
        Color = clCream
        ParentColor = False
        TabOrder = 2
        object CheckBox2: TCheckBox
          Left = 8
          Top = 16
          Width = 145
          Height = 17
          Caption = ' '#26174#31034#21313#20845#36827#21046#20540'     '
          TabOrder = 0
          OnClick = CheckBox2Click
        end
        object Button2: TsuiButton
          Left = 371
          Top = 10
          Width = 80
          Height = 25
          UIStyle = WinXP
          Caption = #32479#35745#28165#38646
          AutoSize = False
          TabOrder = 1
          Transparent = False
          ModalResult = 0
          Layout = blGlyphLeft
          Spacing = 4
          ResHandle = 0
          OnClick = Button2Click
        end
      end
    end
  end
  object ClientSocket1: TClientSocket
    Active = False
    ClientType = ctNonBlocking
    Port = 0
    Left = 192
    Top = 56
  end
  object ClientSocket2: TClientSocket
    Active = False
    ClientType = ctNonBlocking
    Port = 0
    Left = 464
    Top = 8
  end
  object XComm1: TXComm
    BaudRate = br9600
    BaudValue = 9600
    Buffers.InputSize = 2048
    Buffers.OutputSize = 2048
    Buffers.InputTimeout = 500
    Buffers.OutputTimeout = 500
    RTSSettings = []
    DataControl.DataBits = db8
    DataControl.Parity = paNone
    DataControl.StopBits = sb1
    DeviceName = 'COM1'
    DTRSettings = []
    EventChars.XonChar = #17
    EventChars.XoffChar = #19
    EventChars.EofChar = #0
    EventChars.ErrorChar = #0
    EventChars.EventChar = #10
    MonitorEvents = [deChar, deFlag, deOutEmpty]
    FlowControl = fcNone
    Options = []
    Synchronize = True
    Timeouts.ReadInterval = 1
    Timeouts.ReadMultiplier = 0
    Timeouts.ReadConstant = 1
    Timeouts.WriteMultiplier = 0
    Timeouts.WriteConstant = 1
    XOnXOffSettings = []
    OnData = XComm1Data
    Left = 184
    Top = 128
  end
  object Timer1: TTimer
    Enabled = False
    OnTimer = Timer1Timer
    Left = 248
    Top = 320
  end
end
