object FormChartLayer: TFormChartLayer
  Left = 0
  Top = 0
  Caption = 'FormChartLayer'
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
    Left = 432
    Top = 0
    Width = 192
    Height = 441
    Align = alRight
    TabOrder = 0
    object layers: TComboBox
      Left = 6
      Top = 9
      Width = 177
      Height = 23
      Style = csDropDownList
      TabOrder = 0
      OnChange = layersChange
    end
    object addLayer: TButton
      Left = 8
      Top = 38
      Width = 80
      Height = 25
      Caption = 'Add layer'
      TabOrder = 1
      OnClick = addLayerClick
    end
    object Delete: TButton
      Left = 105
      Top = 38
      Width = 80
      Height = 25
      Caption = 'Delete layer'
      Enabled = False
      TabOrder = 2
      OnClick = DeleteClick
    end
  end
  object map: TECNativeMap
    Left = 0
    Top = 0
    Width = 432
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
    ExplicitLeft = 88
    ExplicitTop = 144
    ExplicitWidth = 256
    ExplicitHeight = 256
  end
end
