object FormWMS_WFS: TFormWMS_WFS
  Left = 0
  Top = 0
  Caption = 'Demo WMS - WFS for TECNativeMap '#169' ESCOT-SEP Christophe'
  ClientHeight = 441
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
    Height = 328
    Align = alRight
    BevelOuter = bvNone
    TabOrder = 0
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
      Height = 135
      Align = alTop
      Caption = 'WMS Layers'
      TabOrder = 1
      object pnLegend: TPanel
        AlignWithMargins = True
        Left = 5
        Top = 43
        Width = 189
        Height = 28
        Align = alTop
        BevelOuter = bvNone
        Enabled = False
        TabOrder = 0
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
      end
      object ckRadar: TCheckBox
        AlignWithMargins = True
        Left = 5
        Top = 20
        Width = 189
        Height = 17
        Align = alTop
        Caption = 'Precipitation radar (Germany)'
        TabOrder = 1
        OnClick = ckRadarClick
      end
      object ckCadastre: TCheckBox
        AlignWithMargins = True
        Left = 5
        Top = 77
        Width = 189
        Height = 17
        Align = alTop
        Caption = 'Cadastre (Rennes France)'
        TabOrder = 2
        OnClick = ckCadastreClick
      end
      object btClearWMSLayers: TButton
        AlignWithMargins = True
        Left = 5
        Top = 100
        Width = 189
        Height = 25
        Align = alTop
        Caption = 'Clear WMS Layers'
        TabOrder = 3
        OnClick = btClearWMSLayersClick
      end
    end
    object GroupBox1: TGroupBox
      AlignWithMargins = True
      Left = 3
      Top = 255
      Width = 199
      Height = 105
      Align = alTop
      Caption = 'WFS Layer'
      TabOrder = 2
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
    Top = 328
    Width = 701
    Height = 113
    Align = alBottom
    BevelOuter = bvNone
    TabOrder = 1
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
    Height = 328
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
  end
end
