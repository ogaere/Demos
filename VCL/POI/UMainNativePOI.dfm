object FormNativePoi: TFormNativePoi
  Left = 0
  Top = 0
  ClientHeight = 547
  ClientWidth = 839
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  Position = poMainFormCenter
  OnClose = FormClose
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 13
  object Panel1: TPanel
    Left = 654
    Top = 0
    Width = 185
    Height = 547
    Align = alRight
    BevelOuter = bvNone
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -13
    Font.Name = 'Tahoma'
    Font.Style = []
    ParentFont = False
    TabOrder = 0
    object Label1: TLabel
      Left = 9
      Top = 153
      Width = 167
      Height = 16
      Caption = 'Double click for resize POI'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -13
      Font.Name = 'Tahoma'
      Font.Style = [fsBold]
      ParentFont = False
    end
    object Label2: TLabel
      Left = 16
      Top = 221
      Width = 89
      Height = 16
      Caption = 'Cluster shape'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -13
      Font.Name = 'Tahoma'
      Font.Style = [fsBold]
      ParentFont = False
    end
    object AddPois: TButton
      Left = 19
      Top = 55
      Width = 153
      Height = 25
      Caption = 'Add 1000 Pois'
      TabOrder = 0
      OnClick = AddPoisClick
    end
    object PoiNumber: TPanel
      Left = 0
      Top = 0
      Width = 185
      Height = 41
      Align = alTop
      BevelOuter = bvLowered
      Font.Charset = DEFAULT_CHARSET
      Font.Color = 16744448
      Font.Height = -19
      Font.Name = 'Tahoma'
      Font.Style = [fsBold]
      ParentFont = False
      TabOrder = 1
    end
    object infos: TPanel
      Left = 0
      Top = 506
      Width = 185
      Height = 41
      Align = alBottom
      BevelOuter = bvLowered
      Font.Charset = DEFAULT_CHARSET
      Font.Color = 4737279
      Font.Height = -19
      Font.Name = 'Tahoma'
      Font.Style = [fsBold]
      ParentFont = False
      TabOrder = 2
    end
    object fitbounds: TButton
      Left = 20
      Top = 122
      Width = 152
      Height = 25
      Caption = 'Show all'
      TabOrder = 3
      OnClick = fitboundsClick
    end
    object clustering: TCheckBox
      Left = 14
      Top = 198
      Width = 143
      Height = 17
      Caption = 'Enabled Clustering'
      TabOrder = 4
      OnClick = clusteringClick
    end
    object MoveDirection360: TButton
      Left = 20
      Top = 86
      Width = 152
      Height = 25
      Caption = 'Move Direction 360'
      TabOrder = 5
      OnClick = MoveDirection360Click
    end
    object cbClusterStyle: TComboBox
      Left = 16
      Top = 237
      Width = 145
      Height = 24
      Style = csDropDownList
      TabOrder = 6
      OnChange = cbClusterStyleChange
      Items.Strings = (
        'Ellipse'
        'Rectangle'
        'Star'
        'Hexagon'
        'Diamond'
        'Triangle'
        'Triangle Down')
    end
  end
  object map: TECNativeMap
    Left = 0
    Top = 0
    Width = 654
    Height = 547
    FocusedShapeWhenClicking = True
    HideShapesWhenZoom = False
    HideShapesWhenWaitingTile = False
    DblClickZoom = True
    MouseWheelZoom = True
    latitude = 43.232947274405240000
    longitude = 0.078105926513671880
    Reticle = False
    ReticleColor = clBlack
    ZoomScaleFactor = 0
    NumericalZoom = 14.000000000000000000
    DragRect = drNone
    Draggable = True
    OnlyOneOpenInfoWindow = False
    WaitingForDestruction = False
    Active = True
    OnShapeDragEnd = mapShapeDragEnd
    OnShapeClick = mapShapeClick
    OnShapeDblClick = mapShapeDblClick
    Align = alClient
  end
end
