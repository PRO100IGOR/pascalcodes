object CnLocalHistoryForm: TCnLocalHistoryForm
  Left = 272
  Top = 153
  BorderStyle = bsNone
  Caption = '��ʷ�汾�Ƚ�'
  ClientHeight = 458
  ClientWidth = 653
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -12
  Font.Name = '����'
  Font.Style = []
  OldCreateOrder = True
  Position = poScreenCenter
  Scaled = False
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  OnResize = FormResize
  PixelsPerInch = 96
  TextHeight = 12
  object splMain: TSplitter
    Left = 0
    Top = 153
    Width = 653
    Height = 3
    Cursor = crVSplit
    Align = alTop
  end
  object pnlDisplay: TPanel
    Left = 634
    Top = 182
    Width = 19
    Height = 257
    Align = alRight
    BevelInner = bvRaised
    BevelOuter = bvLowered
    TabOrder = 2
    Visible = False
    object pbFile: TPaintBox
      Left = 8
      Top = 2
      Width = 9
      Height = 253
      Align = alClient
      Color = clBtnFace
      ParentColor = False
      OnMouseDown = pbFileMouseDown
      OnPaint = pbFilePaint
    end
    object pbPos: TPaintBox
      Left = 2
      Top = 2
      Width = 6
      Height = 253
      Align = alLeft
      Color = clBtnFace
      ParentColor = False
      OnPaint = pbPosPaint
    end
  end
  object Panel1: TPanel
    Left = 0
    Top = 182
    Width = 634
    Height = 257
    Align = alClient
    BevelOuter = bvNone
    Caption = 'Panel1'
    TabOrder = 1
    object pnlMain: TPanel
      Left = 0
      Top = 0
      Width = 634
      Height = 257
      Align = alClient
      BevelOuter = bvNone
      Caption = 'pnlMain'
      TabOrder = 0
      object splFiles: TSplitter
        Left = 315
        Top = 0
        Width = 3
        Height = 257
        Cursor = crHSplit
      end
      object pnlLeft: TPanel
        Left = 0
        Top = 0
        Width = 315
        Height = 257
        Align = alLeft
        BevelOuter = bvNone
        Caption = 'pnlLeft'
        TabOrder = 0
      end
      object pnlRight: TPanel
        Left = 318
        Top = 0
        Width = 316
        Height = 257
        Align = alClient
        BevelOuter = bvNone
        Caption = 'pnlRight'
        TabOrder = 1
      end
    end
  end
  object StatusBar1: TStatusBar
    Left = 0
    Top = 439
    Width = 653
    Height = 19
    Panels = <
      item
        Alignment = taCenter
        Style = psOwnerDraw
        Text = '+'
        Width = 18
      end
      item
        Alignment = taCenter
        Style = psOwnerDraw
        Text = '!'
        Width = 18
      end
      item
        Alignment = taCenter
        Style = psOwnerDraw
        Text = '-'
        Width = 18
      end
      item
        Width = 50
      end>
    ParentFont = True
    SimplePanel = False
    UseSystemFont = False
    OnMouseUp = StatusBar1MouseUp
    OnDrawPanel = StatusBar1DrawPanel
  end
  object ToolBar: TToolBar
    Left = 0
    Top = 156
    Width = 653
    Height = 26
    AutoSize = True
    BorderWidth = 1
    Caption = 'ToolBar'
    DisabledImages = dmCnSharedImages.DisabledImages
    EdgeBorders = []
    Flat = True
    Images = dmCnSharedImages.Images
    Indent = 2
    ParentShowHint = False
    ShowHint = True
    TabOrder = 0
    object tbCompare: TToolButton
      Left = 2
      Top = 0
      Action = actCompare
    end
    object ToolButton11: TToolButton
      Left = 25
      Top = 0
      Width = 8
      Caption = 'ToolButton11'
      ImageIndex = 9
      Style = tbsSeparator
    end
    object tbNextDiff: TToolButton
      Left = 33
      Top = 0
      Action = actNextDiff
    end
    object tbPrioDiff: TToolButton
      Left = 56
      Top = 0
      Action = actPrioDiff
    end
    object tbGoto: TToolButton
      Left = 79
      Top = 0
      Action = actGoto
    end
    object ToolButton4: TToolButton
      Left = 102
      Top = 0
      Width = 8
      Caption = 'ToolButton4'
      ImageIndex = 12
      Style = tbsSeparator
    end
    object tbSplitHorizontally: TToolButton
      Left = 110
      Top = 0
      Action = actSplitHorizontally
    end
    object tbFont: TToolButton
      Left = 133
      Top = 0
      Action = actFont
    end
    object ToolButton1: TToolButton
      Left = 156
      Top = 0
      Width = 8
      Caption = 'ToolButton1'
      ImageIndex = 7
      Style = tbsSeparator
    end
    object tbHelp: TToolButton
      Left = 164
      Top = 0
      Action = actHelp
    end
  end
  object pnlVersion: TPanel
    Left = 0
    Top = 0
    Width = 653
    Height = 153
    Align = alTop
    BevelOuter = bvNone
    TabOrder = 4
    object splVersion: TSplitter
      Left = 321
      Top = 0
      Width = 3
      Height = 153
      Cursor = crHSplit
    end
    object lvLeft: TListView
      Left = 0
      Top = 0
      Width = 321
      Height = 153
      Align = alLeft
      Columns = <
        item
          Caption = '״̬'
          Width = 38
        end
        item
          Caption = '�汾��'
          Width = 100
        end
        item
          Caption = '����ʱ��'
          Width = 150
        end>
      HideSelection = False
      ReadOnly = True
      RowSelect = True
      TabOrder = 0
      ViewStyle = vsReport
    end
    object lvRight: TListView
      Left = 324
      Top = 0
      Width = 329
      Height = 153
      Align = alClient
      Columns = <
        item
          Caption = '״̬'
          Width = 38
        end
        item
          Caption = '�汾��'
          Width = 100
        end
        item
          Caption = '����ʱ��'
          Width = 150
        end>
      HideSelection = False
      ReadOnly = True
      RowSelect = True
      TabOrder = 1
      ViewStyle = vsReport
    end
  end
  object FontDialog: TFontDialog
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -12
    Font.Name = '����'
    Font.Style = []
    MinFontSize = 0
    MaxFontSize = 0
    Left = 8
    Top = 64
  end
  object ColorDialog: TColorDialog
    Ctl3D = True
    Options = [cdFullOpen]
    Left = 40
    Top = 64
  end
  object ActionList: TActionList
    Images = dmCnSharedImages.Images
    OnUpdate = ActionListUpdate
    Left = 72
    Top = 64
    object actGoto: TAction
      Category = 'Actions'
      Caption = 'ת��Դ����༭����(&J)'
      Hint = 'ת��Դ����༭����'
      ImageIndex = 34
      ShortCut = 16458
      OnExecute = actGotoExecute
    end
    object actIgnoreBlanks: TAction
      Category = 'Options'
      Caption = '���Կհ��ַ�(&B)'
      Hint = '���Կհ��ַ�'
      ShortCut = 16450
      OnExecute = actIgnoreBlanksExecute
    end
    object actIgnoreCase: TAction
      Category = 'Options'
      Caption = '���Դ�Сд(&I)'
      Hint = '���Դ�Сд'
      ShortCut = 16457
      OnExecute = actIgnoreCaseExecute
    end
    object actShowDiffOnly: TAction
      Category = 'Options'
      Caption = 'ֻ��ʾ��֮ͬ��(&D)'
      Hint = 'ֻ��ʾ��֮ͬ��'
      ShortCut = 16452
      OnExecute = actShowDiffOnlyExecute
    end
    object actSplitHorizontally: TAction
      Category = 'Options'
      Caption = 'ˮƽ�ָ�(&H)'
      Hint = 'ˮƽ�ָ�'
      ImageIndex = 30
      ShortCut = 16456
      OnExecute = actSplitHorizontallyExecute
    end
    object actAddColor: TAction
      Category = 'Options'
      Caption = '��������(&A)...'
      Hint = '��������������ɫ'
      OnExecute = actAddColorExecute
    end
    object actModColor: TAction
      Category = 'Options'
      Caption = '�޸ĵ���(&M)...'
      Hint = '�����޸ĵ�����ɫ'
      OnExecute = actModColorExecute
    end
    object actDelColor: TAction
      Category = 'Options'
      Caption = 'ɾ������(&D)...'
      Hint = '����ɾ��������ɫ'
      OnExecute = actDelColorExecute
    end
    object actFont: TAction
      Category = 'Options'
      Caption = '����(&F)...'
      Hint = '��������'
      ImageIndex = 29
      ShortCut = 16454
      OnExecute = actFontExecute
    end
    object actCompare: TAction
      Category = 'Actions'
      Caption = 'Դ����Ƚ�(&C)'
      Hint = 'Դ����Ƚ�'
      ImageIndex = 39
      ShortCut = 120
      OnExecute = actCompareExecute
    end
    object actHelp: TAction
      Category = 'Help'
      Caption = '��ʾ����(&H)'
      Hint = '��ʾ����'
      ImageIndex = 1
      ShortCut = 112
      OnExecute = actHelpExecute
    end
    object actNextDiff: TAction
      Category = 'Actions'
      Caption = '��һ����ͬ(&N)'
      Hint = '��һ����ͬ'
      ImageIndex = 45
      ShortCut = 16424
      OnExecute = actNextDiffExecute
    end
    object actPrioDiff: TAction
      Category = 'Actions'
      Caption = '��һ����ͬ(&P)'
      Hint = '��һ����ͬ'
      ImageIndex = 44
      ShortCut = 16422
      OnExecute = actPrioDiffExecute
    end
  end
end
