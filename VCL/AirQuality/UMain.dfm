object FormAirQuality: TFormAirQuality
  Left = 0
  Top = 0
  Caption = 
    'Air Quality - data from World Air Quality Index - https://waqi.i' +
    'nfo'
  ClientHeight = 476
  ClientWidth = 719
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -12
  Font.Name = 'Segoe UI'
  Font.Style = []
  OnCreate = FormCreate
  TextHeight = 15
  object Panel1: TPanel
    Left = 480
    Top = 0
    Width = 239
    Height = 476
    Margins.Left = 7
    Margins.Top = 7
    Align = alRight
    Caption = 'Panel1'
    Padding.Left = 7
    Padding.Top = 7
    Padding.Right = 7
    Padding.Bottom = 7
    TabOrder = 0
    object MJson: TMemo
      Left = 8
      Top = 8
      Width = 223
      Height = 398
      Margins.Top = 7
      Margins.Bottom = 7
      Align = alClient
      BevelEdges = []
      BevelInner = bvSpace
      BevelOuter = bvNone
      BorderStyle = bsNone
      EditMargins.Left = 7
      EditMargins.Right = 7
      ReadOnly = True
      ScrollBars = ssVertical
      TabOrder = 0
      WantTabs = True
      ExplicitLeft = 456
      ExplicitTop = 0
      ExplicitWidth = 168
      ExplicitHeight = 441
    end
    object getallstations: TButton
      AlignWithMargins = True
      Left = 11
      Top = 440
      Width = 217
      Height = 25
      Align = alBottom
      Caption = 'Get All stations in area'
      TabOrder = 1
      OnClick = getallstationsClick
      ExplicitLeft = 80
      ExplicitTop = 328
      ExplicitWidth = 75
    end
    object GetStation: TButton
      AlignWithMargins = True
      Left = 11
      Top = 409
      Width = 217
      Height = 25
      Align = alBottom
      Caption = 'Get station center of map'
      TabOrder = 2
      OnClick = GetStationClick
      ExplicitLeft = 64
      ExplicitTop = 384
      ExplicitWidth = 75
    end
  end
  object map: TECNativeMap
    Left = 0
    Top = 0
    Width = 480
    Height = 476
    HideShapesWhenZoom = False
    HideShapesWhenWaitingTile = False
    DblClickZoom = True
    MouseWheelZoom = True
    latitude = 48.853500000000000000
    longitude = 2.348320000000000000
    Reticle = False
    ReticleColor = clBlack
    Zoom = 12
    ZoomScaleFactor = 0
    NumericalZoom = 12.000000000000000000
    DragRect = drNone
    Draggable = True
    OnlyOneOpenInfoWindow = False
    WaitingForDestruction = False
    Active = True
    NbrThreadTile = ttFour
    Align = alClient
    TabOrder = 1
    ExplicitWidth = 481
  end
end
