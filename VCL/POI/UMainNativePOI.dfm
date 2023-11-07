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
  OnCreate = FormCreate
  TextHeight = 13
  object Panel1: TPanel
    Left = 654
    Top = 0
    Width = 185
    Height = 520
    Align = alRight
    BevelOuter = bvNone
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -13
    Font.Name = 'Tahoma'
    Font.Style = []
    ParentFont = False
    TabOrder = 0
    ExplicitLeft = 660
    ExplicitHeight = 547
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
    object fitbounds: TButton
      Left = 20
      Top = 122
      Width = 152
      Height = 25
      Caption = 'Show all'
      TabOrder = 2
      OnClick = fitboundsClick
    end
    object clustering: TCheckBox
      Left = 14
      Top = 198
      Width = 143
      Height = 17
      Caption = 'Enabled Clustering'
      TabOrder = 3
      OnClick = clusteringClick
    end
    object MoveDirection360: TButton
      Left = 20
      Top = 86
      Width = 152
      Height = 25
      Caption = 'Move Direction 360'
      TabOrder = 4
      OnClick = MoveDirection360Click
    end
    object cbClusterStyle: TComboBox
      Left = 16
      Top = 237
      Width = 145
      Height = 24
      Style = csDropDownList
      TabOrder = 5
      OnChange = cbClusterStyleChange
      Items.Strings = (
        'Ellipse'
        'Rectangle'
        'Star'
        'Hexagon'
        'Diamond'
        'Triangle'
        'Triangle Down'
        'Categories')
    end
    object GroupBox1: TGroupBox
      Left = 16
      Top = 267
      Width = 145
      Height = 105
      Caption = 'Sort Categories'
      TabOrder = 6
      object rbAscending: TRadioButton
        AlignWithMargins = True
        Left = 5
        Top = 21
        Width = 135
        Height = 17
        Align = alTop
        Caption = 'Ascending'
        Checked = True
        TabOrder = 0
        TabStop = True
        OnClick = rbAscendingClick
        ExplicitLeft = 16
        ExplicitTop = 24
        ExplicitWidth = 113
      end
      object rbDescending: TRadioButton
        Tag = 1
        AlignWithMargins = True
        Left = 5
        Top = 44
        Width = 135
        Height = 17
        Align = alTop
        Caption = 'Descending'
        TabOrder = 1
        OnClick = rbAscendingClick
        ExplicitLeft = 29
        ExplicitWidth = 113
      end
      object rbNone: TRadioButton
        Tag = 2
        AlignWithMargins = True
        Left = 5
        Top = 67
        Width = 135
        Height = 17
        Align = alTop
        Caption = 'None'
        TabOrder = 2
        OnClick = rbAscendingClick
        ExplicitLeft = 29
        ExplicitTop = 85
        ExplicitWidth = 113
      end
    end
  end
  object infos: TPanel
    Left = 0
    Top = 520
    Width = 839
    Height = 27
    Align = alBottom
    BevelOuter = bvLowered
    Font.Charset = DEFAULT_CHARSET
    Font.Color = 4737279
    Font.Height = -15
    Font.Name = 'Tahoma'
    Font.Style = [fsBold]
    ParentFont = False
    TabOrder = 1
  end
  object map: TECNativeMap
    Left = 0
    Top = 0
    Width = 654
    Height = 520
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
    OnShapeDragEnd = mapShapeDragEnd
    OnShapeClick = mapShapeClick
    OnShapeDblClick = mapShapeDblClick
    Align = alClient
    TabOrder = 2
  end
end
