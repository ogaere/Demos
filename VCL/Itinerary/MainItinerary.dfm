object ItineraryForm: TItineraryForm
  Left = 0
  Top = 0
  Caption = 'Itinerary demo for TECNativeMap '
  ClientHeight = 441
  ClientWidth = 667
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -12
  Font.Name = 'Segoe UI'
  Font.Style = []
  OnCreate = FormCreate
  TextHeight = 15
  object menu: TPanel
    AlignWithMargins = True
    Left = 3
    Top = 3
    Width = 661
    Height = 36
    Align = alTop
    BevelOuter = bvNone
    TabOrder = 0
    object StartRoute: TEdit
      Left = 3
      Top = 6
      Width = 147
      Height = 23
      TabOrder = 1
      TextHint = 'From'
    end
    object EndRoute: TEdit
      Left = 156
      Top = 6
      Width = 147
      Height = 23
      TabOrder = 2
      TextHint = 'To'
    end
    object AddRoute: TButton
      Left = 498
      Top = 5
      Width = 75
      Height = 25
      Caption = 'Add Route'
      TabOrder = 0
      OnClick = AddRouteClick
    end
    object vehicle: TComboBox
      Left = 309
      Top = 6
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
    object engine: TComboBox
      Left = 386
      Top = 6
      Width = 106
      Height = 23
      Style = csDropDownList
      ItemIndex = 0
      TabOrder = 4
      Text = 'OSRM'
      Items.Strings = (
        'OSRM'
        'Valhalla')
    end
    object Clear: TButton
      Left = 579
      Top = 5
      Width = 75
      Height = 25
      Caption = 'Clear'
      TabOrder = 5
      OnClick = ClearClick
    end
  end
  object itinerary: TListBox
    AlignWithMargins = True
    Left = 3
    Top = 312
    Width = 661
    Height = 126
    Style = lbOwnerDrawFixed
    AutoComplete = False
    Align = alBottom
    ExtendedSelect = False
    ItemHeight = 15
    TabOrder = 1
    OnClick = itineraryClick
  end
  object map: TECNativeMap
    AlignWithMargins = True
    Left = 3
    Top = 45
    Width = 661
    Height = 261
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
    TabStop = True
  end
end
