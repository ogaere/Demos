object FormWFS_WMS: TFormWFS_WMS
  Left = 0
  Top = 0
  Caption = 'WMS WFS Capabilities List'
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
    AlignWithMargins = True
    Left = 3
    Top = 248
    Width = 618
    Height = 190
    Align = alBottom
    TabOrder = 0
    object PageControl1: TPageControl
      Left = 1
      Top = 1
      Width = 616
      Height = 188
      ActivePage = WMS
      Align = alClient
      TabOrder = 0
      object WMS: TTabSheet
        Caption = 'WMS'
        object Label2: TLabel
          AlignWithMargins = True
          Left = 3
          Top = 3
          Width = 82
          Height = 15
          Align = alTop
          Caption = 'WMS end point'
        end
        object wmfEndPoint: TEdit
          AlignWithMargins = True
          Left = 3
          Top = 24
          Width = 602
          Height = 23
          Align = alTop
          TabOrder = 0
          Text = 'https://public.sig.rennesmetropole.fr/geoserver/ows'
          OnChange = wmfEndPointChange
        end
        object wmsGetCapabilities: TButton
          AlignWithMargins = True
          Left = 3
          Top = 53
          Width = 602
          Height = 25
          Align = alTop
          Caption = 'Click for a list of WMS server layers'
          TabOrder = 1
          OnClick = wmsGetCapabilitiesClick
        end
        object ListLayer: TListBox
          AlignWithMargins = True
          Left = 3
          Top = 84
          Width = 602
          Height = 71
          Align = alClient
          ItemHeight = 15
          TabOrder = 2
          OnClick = ListLayerClick
        end
      end
      object WFS: TTabSheet
        Caption = 'WFS'
        ImageIndex = 1
        object Label1: TLabel
          AlignWithMargins = True
          Left = 3
          Top = 3
          Width = 77
          Height = 15
          Align = alTop
          Caption = 'WFS end point'
        end
        object wfsEndPoint: TEdit
          AlignWithMargins = True
          Left = 3
          Top = 24
          Width = 602
          Height = 23
          Align = alTop
          TabOrder = 0
          Text = 'https://geobretagne.fr/geoserver/ows'
          OnChange = wfsEndPointChange
        end
        object wfsGetCapabilities: TButton
          AlignWithMargins = True
          Left = 3
          Top = 53
          Width = 602
          Height = 25
          Align = alTop
          Caption = 'Click for a list of WFS server features'
          TabOrder = 1
          OnClick = wfsGetCapabilitiesClick
        end
        object ListFeature: TListBox
          AlignWithMargins = True
          Left = 3
          Top = 84
          Width = 602
          Height = 71
          Align = alClient
          ItemHeight = 15
          TabOrder = 2
          OnClick = ListFeatureClick
        end
      end
    end
  end
  object map: TECNativeMap
    Left = 0
    Top = 0
    Width = 624
    Height = 245
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
  end
end
