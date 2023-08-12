object PTVForm: TPTVForm
  Left = 0
  Top = 0
  Caption = 'TECNativeMap demo PTV Map and Routing'
  ClientHeight = 573
  ClientWidth = 624
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -12
  Font.Name = 'Segoe UI'
  Font.Style = []
  OnCreate = FormCreate
  TextHeight = 15
  object PageControl1: TPageControl
    Left = 0
    Top = 288
    Width = 624
    Height = 285
    ActivePage = TabSheet2
    Align = alBottom
    TabOrder = 0
    object TabSheet1: TTabSheet
      Caption = 'Map'
      object Label15: TLabel
        Left = 3
        Top = 8
        Width = 71
        Height = 15
        Caption = 'Basemap PTV'
      end
      object basemaplayer: TComboBox
        Left = 3
        Top = 29
        Width = 145
        Height = 23
        Style = csDropDownList
        TabOrder = 0
        OnChange = basemaplayerChange
        Items.Strings = (
          'sandbox'
          'classic'
          'silkysand'
          'amber'
          'blackmarble'
          'gravelpit'
          'silica'
          'satellite'
          'none')
      end
      object GroupBox2: TGroupBox
        Left = 3
        Top = 58
        Width = 145
        Height = 185
        Caption = 'Layers'
        TabOrder = 1
        object Labels: TCheckBox
          Left = 15
          Top = 47
          Width = 97
          Height = 17
          Caption = 'Labels'
          TabOrder = 0
          OnClick = LabelsClick
        end
        object Trafficincidents: TCheckBox
          Left = 15
          Top = 70
          Width = 97
          Height = 17
          Caption = 'TrafficIncidents'
          TabOrder = 1
          OnClick = LabelsClick
        end
        object TrafficPatterns: TCheckBox
          Left = 15
          Top = 93
          Width = 97
          Height = 17
          Caption = 'TrafficPatterns'
          TabOrder = 2
          OnClick = LabelsClick
        end
        object Transport: TCheckBox
          Left = 15
          Top = 116
          Width = 97
          Height = 17
          Caption = 'Transport'
          TabOrder = 3
          OnClick = LabelsClick
        end
        object Background: TCheckBox
          Left = 15
          Top = 24
          Width = 97
          Height = 17
          Caption = 'Background'
          TabOrder = 4
          OnClick = LabelsClick
        end
        object Restrictions: TCheckBox
          Left = 15
          Top = 139
          Width = 97
          Height = 17
          Caption = 'Restrictions'
          TabOrder = 5
          OnClick = LabelsClick
        end
        object Toll: TCheckBox
          Left = 15
          Top = 162
          Width = 97
          Height = 17
          Caption = 'Toll'
          TabOrder = 6
          OnClick = LabelsClick
        end
      end
      object Overlays: TGroupBox
        Left = 170
        Top = 58
        Width = 138
        Height = 185
        Caption = 'Overlays'
        TabOrder = 2
        object OLabels: TCheckBox
          Left = 15
          Top = 24
          Width = 97
          Height = 17
          Caption = 'Labels'
          TabOrder = 0
          OnClick = OLabelsClick
        end
        object OTrafficIncidents: TCheckBox
          Left = 15
          Top = 47
          Width = 97
          Height = 17
          Caption = 'TrafficIncidents'
          TabOrder = 1
          OnClick = OLabelsClick
        end
        object OTrafficPatterns: TCheckBox
          Left = 15
          Top = 70
          Width = 97
          Height = 17
          Caption = 'TrafficPatterns'
          TabOrder = 2
          OnClick = OLabelsClick
        end
        object OTransport: TCheckBox
          Left = 15
          Top = 93
          Width = 97
          Height = 17
          Caption = 'Transport'
          TabOrder = 3
          OnClick = OLabelsClick
        end
        object ORestrictions: TCheckBox
          Left = 15
          Top = 116
          Width = 97
          Height = 17
          Caption = 'Restrictions'
          TabOrder = 4
          OnClick = OLabelsClick
        end
        object OToll: TCheckBox
          Left = 15
          Top = 139
          Width = 97
          Height = 17
          Caption = 'Toll'
          TabOrder = 5
          OnClick = OLabelsClick
        end
      end
    end
    object TabSheet2: TTabSheet
      Caption = 'Routing'
      ImageIndex = 1
      object StartRoute: TEdit
        Left = 3
        Top = 8
        Width = 147
        Height = 23
        TabOrder = 0
        TextHint = 'From'
      end
      object EndRoute: TEdit
        Left = 156
        Top = 8
        Width = 147
        Height = 23
        TabOrder = 1
        TextHint = 'To'
      end
      object AddRoute: TButton
        Left = 386
        Top = 6
        Width = 75
        Height = 25
        Caption = 'Add Route'
        TabOrder = 2
        OnClick = AddRouteClick
      end
      object vehicle: TComboBox
        Left = 309
        Top = 8
        Width = 71
        Height = 23
        Style = csDropDownList
        ItemIndex = 2
        TabOrder = 3
        Text = 'Car'
        Items.Strings = (
          'Pedestrian'
          'Bicycle'
          'Car'
          'Truck')
      end
      object Panel1: TPanel
        Left = 0
        Top = 34
        Width = 616
        Height = 221
        Align = alBottom
        Anchors = [akLeft, akTop, akRight, akBottom]
        BevelEdges = []
        BevelOuter = bvNone
        Caption = 'Panel1'
        TabOrder = 4
        OnResize = Panel1Resize
        object itinerary: TListBox
          AlignWithMargins = True
          Left = 3
          Top = 3
          Width = 244
          Height = 215
          Style = lbOwnerDrawFixed
          AutoComplete = False
          Align = alClient
          ExtendedSelect = False
          ItemHeight = 15
          TabOrder = 0
          OnClick = itineraryClick
        end
        object InfoRoute: TMemo
          AlignWithMargins = True
          Left = 253
          Top = 3
          Width = 360
          Height = 215
          Align = alRight
          ScrollBars = ssVertical
          TabOrder = 1
        end
      end
    end
  end
  object Map: TECNativeMap
    Left = 0
    Top = 0
    Width = 624
    Height = 288
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
