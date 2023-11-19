object FormMeasureTool: TFormMeasureTool
  Left = 0
  Top = 0
  Caption = 'Demo Measure Tool '#169' ESCOT-SEP Christophe'
  ClientHeight = 441
  ClientWidth = 624
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -12
  Font.Name = 'Segoe UI'
  Font.Style = []
  OnCreate = FormCreate
  TextHeight = 15
  object Panel1: TPanel
    Left = 456
    Top = 0
    Width = 168
    Height = 441
    Align = alRight
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -13
    Font.Name = 'Segoe UI'
    Font.Style = []
    ParentFont = False
    TabOrder = 0
    object lbArea: TLabel
      AlignWithMargins = True
      Left = 4
      Top = 420
      Width = 4
      Height = 17
      Align = alBottom
    end
    object lbDistance: TLabel
      AlignWithMargins = True
      Left = 4
      Top = 397
      Width = 4
      Height = 17
      Align = alBottom
    end
    object GroupBox1: TGroupBox
      AlignWithMargins = True
      Left = 4
      Top = 4
      Width = 160
      Height = 93
      Align = alTop
      Caption = 'Show Measure tool '
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -13
      Font.Name = 'Segoe UI'
      Font.Style = [fsBold]
      ParentFont = False
      TabOrder = 0
      ExplicitWidth = 272
      object rbHide: TRadioButton
        AlignWithMargins = True
        Left = 5
        Top = 22
        Width = 150
        Height = 17
        Align = alTop
        Caption = 'Hide'
        Checked = True
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -13
        Font.Name = 'Segoe UI'
        Font.Style = []
        ParentFont = False
        TabOrder = 0
        TabStop = True
        OnClick = doShowMeasureTool
        ExplicitLeft = 24
        ExplicitTop = 40
        ExplicitWidth = 113
      end
      object rbDistance: TRadioButton
        Tag = 1
        AlignWithMargins = True
        Left = 5
        Top = 45
        Width = 150
        Height = 17
        Align = alTop
        Caption = 'Distance'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -13
        Font.Name = 'Segoe UI'
        Font.Style = []
        ParentFont = False
        TabOrder = 1
        OnClick = doShowMeasureTool
        ExplicitLeft = 40
        ExplicitTop = 56
        ExplicitWidth = 113
      end
      object rbArea: TRadioButton
        Tag = 2
        AlignWithMargins = True
        Left = 5
        Top = 68
        Width = 150
        Height = 17
        Align = alTop
        Caption = 'Area'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -13
        Font.Name = 'Segoe UI'
        Font.Style = []
        ParentFont = False
        TabOrder = 2
        OnClick = doShowMeasureTool
        ExplicitLeft = 7
      end
    end
    object GroupBox2: TGroupBox
      AlignWithMargins = True
      Left = 4
      Top = 103
      Width = 160
      Height = 82
      Align = alTop
      Caption = 'Unit Measure tool'
      DefaultHeaderFont = False
      HeaderFont.Charset = DEFAULT_CHARSET
      HeaderFont.Color = clWindowText
      HeaderFont.Height = -13
      HeaderFont.Name = 'Segoe UI'
      HeaderFont.Style = [fsBold]
      TabOrder = 1
      object rbMetric: TRadioButton
        AlignWithMargins = True
        Left = 5
        Top = 22
        Width = 150
        Height = 17
        Align = alTop
        Caption = 'Metric'
        Checked = True
        TabOrder = 0
        TabStop = True
        OnClick = doUnit
        ExplicitLeft = 16
        ExplicitTop = 32
        ExplicitWidth = 113
      end
      object rbImperial: TRadioButton
        Tag = 1
        AlignWithMargins = True
        Left = 5
        Top = 45
        Width = 150
        Height = 17
        Align = alTop
        Caption = 'Imperial'
        TabOrder = 1
        OnClick = doUnit
        ExplicitLeft = 40
        ExplicitTop = 56
        ExplicitWidth = 113
      end
    end
    object GroupBox3: TGroupBox
      AlignWithMargins = True
      Left = 4
      Top = 191
      Width = 160
      Height = 74
      Align = alTop
      Caption = 'Colors Measure tool'
      DefaultHeaderFont = False
      HeaderFont.Charset = DEFAULT_CHARSET
      HeaderFont.Color = clWindowText
      HeaderFont.Height = -13
      HeaderFont.Name = 'Segoe UI'
      HeaderFont.Style = [fsBold]
      TabOrder = 2
      object rbBlackWhite: TRadioButton
        AlignWithMargins = True
        Left = 5
        Top = 22
        Width = 150
        Height = 17
        Align = alTop
        Caption = 'Black && White'
        Checked = True
        TabOrder = 0
        TabStop = True
        OnClick = doColors
        ExplicitLeft = 24
        ExplicitTop = 40
        ExplicitWidth = 113
      end
      object rbOrange: TRadioButton
        Tag = 1
        AlignWithMargins = True
        Left = 5
        Top = 45
        Width = 150
        Height = 17
        Align = alTop
        Caption = 'Orange'
        TabOrder = 1
        OnClick = doColors
        ExplicitLeft = 16
        ExplicitTop = 56
        ExplicitWidth = 113
      end
    end
    object GroupBox4: TGroupBox
      AlignWithMargins = True
      Left = 4
      Top = 271
      Width = 160
      Height = 74
      Align = alTop
      Caption = 'Styles Measure tool'
      DefaultHeaderFont = False
      HeaderFont.Charset = DEFAULT_CHARSET
      HeaderFont.Color = clWindowText
      HeaderFont.Height = -13
      HeaderFont.Name = 'Segoe UI'
      HeaderFont.Style = [fsBold]
      TabOrder = 3
      ExplicitLeft = 6
      ExplicitTop = 383
      object rbClassic: TRadioButton
        AlignWithMargins = True
        Left = 5
        Top = 22
        Width = 150
        Height = 17
        Align = alTop
        Caption = 'Classic'
        Checked = True
        TabOrder = 0
        TabStop = True
        OnClick = doStyle
      end
      object rbSolid: TRadioButton
        Tag = 1
        AlignWithMargins = True
        Left = 5
        Top = 45
        Width = 150
        Height = 17
        Align = alTop
        Caption = 'Solid && fin'
        TabOrder = 1
        OnClick = doStyle
      end
    end
    object ckLabel: TCheckBox
      AlignWithMargins = True
      Left = 4
      Top = 351
      Width = 160
      Height = 17
      Align = alTop
      Caption = 'Show Label'
      Checked = True
      State = cbChecked
      TabOrder = 4
      OnClick = doLabel
      ExplicitLeft = 32
      ExplicitTop = 360
      ExplicitWidth = 97
    end
  end
  object map: TECNativeMap
    Left = 0
    Top = 0
    Width = 456
    Height = 441
    HideShapesWhenZoom = False
    HideShapesWhenWaitingTile = False
    DblClickZoom = True
    MouseWheelZoom = True
    latitude = 43.232951000000000000
    longitude = 0.078081999999994910
    Reticle = False
    ReticleColor = clBlack
    ZoomScaleFactor = 0
    NumericalZoom = 14.000000000000000000
    DragRect = drNone
    Draggable = True
    OnlyOneOpenInfoWindow = False
    WaitingForDestruction = False
    Active = True
    NbrThreadTile = ttFour
    Align = alClient
    TabOrder = 1
    ExplicitWidth = 417
  end
end
