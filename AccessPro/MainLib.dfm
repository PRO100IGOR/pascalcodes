object MainForm: TMainForm
  Left = 0
  Top = 0
  BorderIcons = [biSystemMenu, biMinimize]
  BorderStyle = bsSingle
  Caption = #26381#21153#31649#29702
  ClientHeight = 501
  ClientWidth = 670
  Color = clBtnFace
  Font.Charset = GB2312_CHARSET
  Font.Color = clWindowText
  Font.Height = -12
  Font.Name = #23435#20307
  Font.Style = []
  OldCreateOrder = False
  Position = poDesktopCenter
  Visible = True
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 12
  object PageControl1: TPageControl
    Left = 0
    Top = 0
    Width = 670
    Height = 501
    ActivePage = TabSheet1
    Align = alClient
    TabOrder = 0
    object TabSheet1: TTabSheet
      Caption = #36816#34892#29366#24577
      object LogMemo: TMemo
        Left = 0
        Top = 57
        Width = 662
        Height = 416
        Align = alClient
        ScrollBars = ssVertical
        TabOrder = 1
      end
      object GroupBox1: TGroupBox
        Left = 0
        Top = 0
        Width = 662
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
          Width = 54
          Height = 12
          Caption = #26816#27979#20013'...'
        end
        object btnStopStart: TButton
          Left = 492
          Top = 20
          Width = 75
          Height = 25
          Caption = #21551#21160#26381#21153
          Enabled = False
          TabOrder = 1
          OnClick = btnStopStartClick
        end
        object btnClearLog: TButton
          Left = 579
          Top = 20
          Width = 75
          Height = 25
          Caption = #28165#31354#26085#24535
          TabOrder = 2
          OnClick = btnClearLogClick
        end
        object btnInstallUnInstall: TButton
          Left = 406
          Top = 20
          Width = 75
          Height = 25
          Caption = #23433#35013#26381#21153
          Enabled = False
          TabOrder = 0
          OnClick = btnInstallUnInstallClick
        end
      end
    end
    object TabSheet2: TTabSheet
      Caption = #20219#21153#31649#29702
      ImageIndex = 1
      object SQLBox: TScrollBox
        Left = 0
        Top = 89
        Width = 662
        Height = 384
        Align = alClient
        Ctl3D = True
        ParentCtl3D = False
        TabOrder = 1
      end
      object GroupBox2: TGroupBox
        Left = 0
        Top = 0
        Width = 662
        Height = 89
        Align = alTop
        Caption = #20219#21153#23646#24615
        TabOrder = 0
        object Label1: TLabel
          Left = 16
          Top = 23
          Width = 72
          Height = 12
          Caption = #36873#25321#25110#26032#24314#65306
        end
        object Label7: TLabel
          Left = 466
          Top = 58
          Width = 152
          Height = 19
          Caption = 'select'#20851#38190#23383#35201#23567#20889'@@'
          Font.Charset = GB2312_CHARSET
          Font.Color = clWindowText
          Font.Height = -14
          Font.Name = #24494#36719#38597#40657
          Font.Style = [fsBold]
          ParentFont = False
        end
        object cbbTaskNames: TComboBox
          Left = 84
          Top = 19
          Width = 277
          Height = 20
          ItemHeight = 12
          TabOrder = 3
        end
        object btnLoad: TButton
          Left = 385
          Top = 17
          Width = 75
          Height = 25
          Caption = #21152#36733
          TabOrder = 0
          OnClick = btnLoadClick
        end
        object btnSave: TButton
          Left = 481
          Top = 17
          Width = 75
          Height = 25
          Caption = #20445#23384
          TabOrder = 1
          OnClick = btnSaveClick
        end
        object btnDelTask: TButton
          Left = 584
          Top = 17
          Width = 75
          Height = 25
          Caption = #21024#38500
          TabOrder = 2
          OnClick = btnDelTaskClick
        end
        object lbledtReadTime: TLabeledEdit
          Left = 84
          Top = 59
          Width = 277
          Height = 20
          EditLabel.Width = 72
          EditLabel.Height = 12
          EditLabel.Caption = #25191#34892#21608#26399#31186#65306
          LabelPosition = lpLeft
          LabelSpacing = 5
          TabOrder = 5
        end
        object btnAddSql: TButton
          Left = 385
          Top = 57
          Width = 75
          Height = 25
          Caption = #22686#21152'SQL'
          TabOrder = 4
          OnClick = btnAddSqlClick
        end
      end
    end
    object TabSheet3: TTabSheet
      Caption = #25968#25454#28304#31649#29702
      ImageIndex = 2
      ExplicitLeft = 0
      ExplicitTop = 0
      ExplicitWidth = 0
      ExplicitHeight = 0
      object Label2: TLabel
        Left = 14
        Top = 43
        Width = 72
        Height = 12
        Caption = #36873#25321#25110#26032#24314#65306
      end
      object Label3: TLabel
        Left = 14
        Top = 83
        Width = 72
        Height = 12
        Caption = #25968#25454#24211#31867#22411#65306
      end
      object Label4: TLabel
        Left = 371
        Top = 123
        Width = 271
        Height = 14
        Caption = #25968#25454#24211#30340'IP'#22320#22336#25110#32773#25968#25454#24211#30340#25991#20214#22841#21517#31216
        Font.Charset = GB2312_CHARSET
        Font.Color = clWindowText
        Font.Height = -14
        Font.Name = #23435#20307
        Font.Style = [fsBold]
        ParentFont = False
      end
      object Label5: TLabel
        Left = 373
        Top = 163
        Width = 72
        Height = 12
        Caption = #25968#25454#24211#30340#31471#21475
      end
      object Label6: TLabel
        Left = 371
        Top = 197
        Width = 288
        Height = 24
        Caption = #25968#25454#24211#21517#31216#25110#32773#25968#25454#24211#25991#20214#21517#65292#25903#25345#27491#21017#34920#36798#24335#21644#21464#37327#13#10#26367#25442','#19981#29992#27491#21017#12289#21464#37327#26102#65292#22312#25991#20214#21517#21518#21152#19968#20010'^_^'
        Font.Charset = GB2312_CHARSET
        Font.Color = clWindowText
        Font.Height = -12
        Font.Name = #23435#20307
        Font.Style = []
        ParentFont = False
      end
      object lbledtServer: TLabeledEdit
        Left = 92
        Top = 120
        Width = 277
        Height = 20
        EditLabel.Width = 60
        EditLabel.Height = 12
        EditLabel.Caption = #26381#21153#22320#22336#65306
        LabelPosition = lpLeft
        LabelSpacing = 5
        TabOrder = 5
      end
      object cbbDataName: TComboBox
        Left = 92
        Top = 40
        Width = 277
        Height = 20
        ItemHeight = 0
        TabOrder = 3
      end
      object lbledtPort: TLabeledEdit
        Left = 92
        Top = 160
        Width = 277
        Height = 20
        EditLabel.Width = 36
        EditLabel.Height = 12
        EditLabel.Caption = #31471#21475#65306
        LabelPosition = lpLeft
        LabelSpacing = 5
        TabOrder = 6
      end
      object lbledtUserName: TLabeledEdit
        Left = 92
        Top = 239
        Width = 277
        Height = 20
        EditLabel.Width = 48
        EditLabel.Height = 12
        EditLabel.Caption = #29992#25143#21517#65306
        LabelPosition = lpLeft
        LabelSpacing = 5
        TabOrder = 8
      end
      object lbledtPassWord: TLabeledEdit
        Left = 92
        Top = 279
        Width = 277
        Height = 20
        EditLabel.Width = 36
        EditLabel.Height = 12
        EditLabel.Caption = #23494#30721#65306
        LabelPosition = lpLeft
        LabelSpacing = 5
        TabOrder = 9
      end
      object cbbDataType: TComboBox
        Left = 92
        Top = 80
        Width = 277
        Height = 20
        Style = csDropDownList
        ItemHeight = 0
        TabOrder = 4
        OnChange = cbbDataTypeChange
        Items.Strings = (
          'MySql'
          'Oracle'
          'SQLite'
          'Access')
      end
      object btnLoadData: TButton
        Left = 385
        Top = 38
        Width = 75
        Height = 25
        Caption = #21152#36733
        TabOrder = 0
        OnClick = btnLoadDataClick
      end
      object btnSaveData: TButton
        Left = 481
        Top = 38
        Width = 75
        Height = 25
        Caption = #20445#23384
        TabOrder = 1
        OnClick = btnSaveDataClick
      end
      object btnData: TButton
        Left = 576
        Top = 38
        Width = 75
        Height = 25
        Caption = #21024#38500
        TabOrder = 2
        OnClick = btnDataClick
      end
      object lbledtDataBase: TLabeledEdit
        Left = 92
        Top = 199
        Width = 277
        Height = 20
        EditLabel.Width = 48
        EditLabel.Height = 12
        EditLabel.Caption = #25968#25454#24211#65306
        LabelPosition = lpLeft
        LabelSpacing = 5
        TabOrder = 7
      end
      object Button1: TButton
        Left = 30
        Top = 321
        Width = 203
        Height = 64
        Caption = 'Access'#23494#30721#30772#35299#24037#20855
        Font.Charset = GB2312_CHARSET
        Font.Color = clWindowText
        Font.Height = -16
        Font.Name = #24494#36719#38597#40657
        Font.Style = [fsBold]
        ParentFont = False
        TabOrder = 10
        OnClick = btnAccessPjClick
      end
    end
    object TabSheet4: TTabSheet
      Caption = #24110#21161
      ImageIndex = 3
      ExplicitLeft = 0
      ExplicitTop = 0
      ExplicitWidth = 0
      ExplicitHeight = 0
      object Memo1: TMemo
        Left = 0
        Top = 0
        Width = 662
        Height = 473
        Align = alClient
        Font.Charset = GB2312_CHARSET
        Font.Color = clWindowText
        Font.Height = -12
        Font.Name = #23435#20307
        Font.Style = []
        Lines.Strings = (
          '0'#12289#25968#25454#28304#12289#20219#21153#21517#31216#65292#19981#33021#26377#20013#25991
          ''
          ''
          '1'#12289#20219#21153#30340#31532#19968#27493#20013#30340'sql'#35821#21477#65292#19981#33021#26377'  ":'#21442#25968'"  '#30340#21442#25968#35774#32622#65292#22240#20026#65292#27599#20010'sql'#35821#21477#30340#21442#25968#65292#37117#26159#20174#19978#19968#27493#30340#32467#26524#38598#20013#23547#25214
          #30340#12290
          ''
          '2'#12289'sql'#35821#21477#12289#25991#20214#30446#24405#12289#25991#20214#21517#25903#25345'el'#34920#36798#24335#20889#27861#65292'${}'#20013#23384#25918#21508#31181#21464#37327#12290#21464#37327#22914#19979#65306
          'yyyy-------->'#24180#20221#65292#24180#20221#19968#33324#26377#20004#31181#20889#27861#65292'yyyy'#21644'yy'#65292'yyyy'#34920#31034'4'#20301#25968#65292'yy'#34920#31034#20004#20301#25968
          'MM---------->'#26376#20221#65292#19968#20010'M'#34920#31034#20801#35768#20986#29616#19968#20301#25968#23383#65292#20363#22914#19968#26376'=1'#65292'MM'#34920#31034#24517#39035#20004#20301#25968#65292#27604#22914#19968#26376'=01'
          'dd----------->'#26085#26399#65292#19968#20010'd'#21644#20004#20010'd'#30340#21547#20041#21516#19978'     '
          'hh/HH------->'#23567#26102#65292'H'#34920#31034'24'#23567#26102#21046#65292'h'#34920#31034'12'#23567#26102#21046#65292#19968#20010'h'#21644#20004#20010'h'#30340#21547#20041#21516#19978
          'mm---------->'#20998#38047#65292#19968#20010'm'#21644#20004#20010'm'#30340#21547#20041#21516#19978'               '
          ''
          #25991#20214#30446#24405#12289#25991#20214#21517#36824#25903#25345#27491#21017#34920#36798#24335#65292#22914
          '\d{1}      '#19968#20010#25968#23383
          '\d{1,3}  1'#21040'3'#20010#25968#23383
          '[0-4]{1,3}0  0'#21040'4'#30340#25968#23383#20986#29616'1'#21040'3'#27425
          '\d*  0'#20010#25110#32773'N'#20010#25968#23383
          ''
          #20363#22914#25991#20214#22841#26159#65306' E:\pros\'#20313#21556#29028#30719'\doc\'#35843#30740#36164#26009'\shuiwen\'#22810#21442#25968#27700#25991#21160#24577#30417#27979#26234#33021#39044#35686#31995#32479'4.0 '
          #25991#20214#21517#26159#65306' \d*.sdb,'
          #37027#20040#23558#20174#25991#20214#22841#20013#25214#21040#25152#26377#31526#21512#35813#25991#20214#21517#27491#21017#34920#36798#24335#30340#25991#20214#12290' 123.sdb'#12289'2010333.sdb')
        ParentFont = False
        ReadOnly = True
        TabOrder = 0
      end
    end
  end
  object tltpA: TToolTip
    ICON = ttWarningIcon
    Left = 536
    Top = 160
  end
  object Timer: TTimer
    OnTimer = TimerTimer
    Left = 568
    Top = 161
  end
end
