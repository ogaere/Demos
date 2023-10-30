object FormWMS_WFS: TFormWMS_WFS
  Left = 0
  Top = 0
  Caption = 'Demo WMS - WFS for TECNativeMap '#169' ESCOT-SEP Christophe'
  ClientHeight = 553
  ClientWidth = 701
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -12
  Font.Name = 'Segoe UI'
  Font.Style = []
  WindowState = wsMaximized
  OnCreate = FormCreate
  TextHeight = 15
  object Panel1: TPanel
    Left = 496
    Top = 0
    Width = 205
    Height = 440
    Align = alRight
    BevelOuter = bvNone
    TabOrder = 0
    ExplicitHeight = 360
    object gbTiles: TGroupBox
      AlignWithMargins = True
      Left = 3
      Top = 3
      Width = 199
      Height = 105
      Align = alTop
      Caption = 'Tiles server'
      TabOrder = 0
      object rbOSM: TRadioButton
        Left = 7
        Top = 16
        Width = 170
        Height = 17
        Caption = 'OpenStreetMap (no WMS)'
        Checked = True
        TabOrder = 0
        TabStop = True
        OnClick = rbOSMClick
      end
      object rbTopoWMS: TRadioButton
        Left = 7
        Top = 40
        Width = 170
        Height = 17
        Caption = 'TOPO-OSM-WMS'
        TabOrder = 1
        OnClick = rbTopoWMSClick
      end
      object ckOverlayWMS: TCheckBox
        Left = 7
        Top = 72
        Width = 139
        Height = 17
        Caption = 'OSM-Overlay-WMS'
        TabOrder = 2
        OnClick = ckOverlayWMSClick
      end
    end
    object gbWMSLayers: TGroupBox
      AlignWithMargins = True
      Left = 3
      Top = 114
      Width = 199
      Height = 218
      Align = alTop
      Caption = 'WMS Layers'
      TabOrder = 1
      ExplicitLeft = 6
      object Time: TLabel
        AlignWithMargins = True
        Left = 22
        Top = 151
        Width = 172
        Height = 15
        Margins.Left = 20
        Margins.Top = 0
        Align = alTop
        ExplicitLeft = 20
        ExplicitTop = 146
      end
      object pnLegend: TPanel
        AlignWithMargins = True
        Left = 5
        Top = 97
        Width = 189
        Height = 51
        Align = alTop
        BevelOuter = bvNone
        Enabled = False
        TabOrder = 0
        ExplicitTop = 43
        object ckLegend: TCheckBox
          Left = 8
          Top = 3
          Width = 57
          Height = 17
          Caption = 'Legend'
          TabOrder = 0
          OnClick = ckLegendClick
        end
        object cbLegendPosition: TComboBox
          Left = 71
          Top = 0
          Width = 98
          Height = 23
          Style = csDropDownList
          ItemIndex = 7
          TabOrder = 1
          Text = 'RightCenter'
          OnChange = cbLegendPositionChange
          Items.Strings = (
            'TopLeft'
            'TopRight'
            'BottomLeft, '
            'BottomRight,'
            'TopCenter'
            'BottomCenter'
            'LeftCenter'
            'RightCenter')
        end
        object ckTime: TCheckBox
          Left = 8
          Top = 29
          Width = 97
          Height = 17
          Caption = 'Last hour'
          TabOrder = 2
          OnClick = ckTimeClick
        end
      end
      object ckRadar: TCheckBox
        AlignWithMargins = True
        Left = 5
        Top = 74
        Width = 189
        Height = 17
        Align = alTop
        Caption = 'Precipitation radar (Germany)'
        TabOrder = 1
        OnClick = ckRadarClick
        ExplicitTop = 20
      end
      object ckCadastre: TCheckBox
        AlignWithMargins = True
        Left = 5
        Top = 51
        Width = 189
        Height = 17
        Align = alTop
        Caption = 'Cadastre (Rennes France)'
        TabOrder = 2
        OnClick = ckCadastreClick
        ExplicitLeft = 3
        ExplicitTop = 44
      end
      object btClearWMSLayers: TButton
        AlignWithMargins = True
        Left = 5
        Top = 20
        Width = 189
        Height = 25
        Align = alTop
        Caption = 'Clear WMS Layers'
        TabOrder = 3
        OnClick = btClearWMSLayersClick
        ExplicitLeft = -3
        ExplicitTop = 12
      end
      object barTime: TPanel
        AlignWithMargins = True
        Left = 5
        Top = 172
        Width = 189
        Height = 25
        Align = alTop
        BevelOuter = bvNone
        TabOrder = 4
        Visible = False
        object StartTime: TButton
          Left = 0
          Top = 0
          Width = 32
          Height = 25
          Align = alLeft
          Caption = '<<'
          TabOrder = 0
          OnClick = StartTimeClick
        end
        object PrevTime: TButton
          Left = 32
          Top = 0
          Width = 32
          Height = 25
          Align = alLeft
          Caption = '<'
          TabOrder = 1
          OnClick = PrevTimeClick
        end
        object PauseTime: TButton
          Left = 64
          Top = 0
          Width = 62
          Height = 25
          Align = alLeft
          Caption = 'Pause'
          TabOrder = 2
          OnClick = PauseTimeClick
          ExplicitLeft = 51
          ExplicitTop = 1
          ExplicitHeight = 39
        end
        object EndTime: TButton
          Left = 158
          Top = 0
          Width = 32
          Height = 25
          Align = alLeft
          Caption = '>>'
          TabOrder = 3
          OnClick = EndTimeClick
        end
        object NextTime: TButton
          Left = 126
          Top = 0
          Width = 32
          Height = 25
          Align = alLeft
          Caption = '>'
          TabOrder = 4
          OnClick = NextTimeClick
        end
      end
      object TimeLoading: TProgressBar
        AlignWithMargins = True
        Left = 5
        Top = 203
        Width = 189
        Height = 10
        Align = alTop
        BarColor = clMoneyGreen
        TabOrder = 5
        Visible = False
        ExplicitTop = 118
      end
    end
    object GroupBox1: TGroupBox
      AlignWithMargins = True
      Left = 3
      Top = 338
      Width = 199
      Height = 83
      Align = alTop
      Caption = 'WFS Layer'
      TabOrder = 2
      ExplicitTop = 320
      object ckOilGas: TCheckBox
        AlignWithMargins = True
        Left = 5
        Top = 20
        Width = 189
        Height = 17
        Align = alTop
        Caption = 'Oil && Gas wells - Gulf of Mexico'
        TabOrder = 0
        OnClick = ckOilGasClick
      end
      object ckUs: TCheckBox
        AlignWithMargins = True
        Left = 5
        Top = 43
        Width = 180
        Height = 17
        Caption = 'U.S., Core Based Statistical Areas'
        TabOrder = 1
        OnClick = ckUsClick
      end
    end
  end
  object pn_events: TPanel
    Left = 0
    Top = 440
    Width = 701
    Height = 113
    Align = alBottom
    BevelOuter = bvNone
    TabOrder = 1
    ExplicitTop = 360
    object events: TMemo
      AlignWithMargins = True
      Left = 3
      Top = 3
      Width = 695
      Height = 107
      Align = alClient
      ScrollBars = ssVertical
      TabOrder = 0
      WantReturns = False
    end
  end
  object map: TECNativeMap
    Left = 0
    Top = 0
    Width = 496
    Height = 440
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
    TabOrder = 2
    ExplicitHeight = 360
  end
end
