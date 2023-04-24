object FormNativeMiniMap: TFormNativeMiniMap
  Left = 0
  Top = 0
  Caption = 'DemoNativeMiniMap '#169' 2013 Escot-Sep Christophe'
  ClientHeight = 592
  ClientWidth = 640
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  Position = poMainFormCenter
  OnClose = FormClose
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 13
  object Map: TECNativeMap
    Left = 0
    Top = 0
    Width = 640
    Height = 592
    HideShapesWhenZoom = False
    DblClickZoom = True
    MouseWheelZoom = True
    Latitude = 43.214434375074640000
    Longitude = 0.105571746826171900
    ZoomScaleFactor = 0
    ZoomEffect = False
    DragRect = drNone
    Draggable = True
    OnChangeMapZoom = MapChangeMapZoom
    Align = alClient
    DesignSize = (
      640
      592)
    object plus: TButton
      Left = 3
      Top = 6
      Width = 52
      Height = 25
      Caption = 'MiniMap'
      TabOrder = 0
      OnClick = plusClick
    end
    object tileserver: TComboBox
      Left = 477
      Top = 8
      Width = 160
      Height = 21
      Style = csDropDownList
      Anchors = [akTop, akRight]
      TabOrder = 1
      OnChange = tileserverChange
      Items.Strings = (
        'MapQuest'
        'MapQuestSat'
        'OSM'
        'CloudMade'
        'Cycle Map'
        'OPVN'
        'ArcGis World Topo Map'
        'ArcGis World Street Map'
        'ArcGis World Imagery')
    end
  end
end
