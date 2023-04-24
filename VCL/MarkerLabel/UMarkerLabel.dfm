object Form27: TForm27
  Left = 0
  Top = 0
  Caption = 'Labels - TECNativeMap - '#169' ESCOT-SEP Christophe'
  ClientHeight = 545
  ClientWidth = 763
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 13
  object Panel1: TPanel
    Left = 0
    Top = 0
    Width = 763
    Height = 65
    Align = alTop
    TabOrder = 0
    ExplicitWidth = 634
    object Label1: TLabel
      Left = 344
      Top = 27
      Width = 29
      Height = 13
      Caption = 'Style'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'Tahoma'
      Font.Style = [fsBold]
      ParentFont = False
    end
    object Label2: TLabel
      Left = 470
      Top = 27
      Width = 28
      Height = 13
      Caption = 'Align'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'Tahoma'
      Font.Style = [fsBold]
      ParentFont = False
    end
    object Label3: TLabel
      Left = 623
      Top = 27
      Width = 35
      Height = 13
      Caption = 'Select'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'Tahoma'
      Font.Style = [fsBold]
      ParentFont = False
    end
    object addMarker: TButton
      Left = 7
      Top = 3
      Width = 98
      Height = 25
      Caption = 'Add 8 Markers'
      TabOrder = 0
      OnClick = addMarkerClick
    end
    object cbStyle: TComboBox
      Left = 377
      Top = 23
      Width = 82
      Height = 21
      Style = csDropDownList
      ItemIndex = 0
      TabOrder = 1
      Text = 'Rectangle'
      OnChange = cbStyleChange
      Items.Strings = (
        'Rectangle'
        'RoundRect'
        'Transparent')
    end
    object Button1: TButton
      Left = 263
      Top = 23
      Width = 75
      Height = 21
      Caption = 'Font'
      TabOrder = 2
      OnClick = Button1Click
    end
    object cbAlign: TComboBox
      Left = 502
      Top = 23
      Width = 59
      Height = 21
      Style = csDropDownList
      TabOrder = 3
      OnChange = cbAlignChange
      Items.Strings = (
        'Top'
        'Bottom'
        'Left'
        'Right')
    end
    object ckLabels: TCheckBox
      Left = 208
      Top = 25
      Width = 49
      Height = 17
      Caption = 'Labels'
      Checked = True
      State = cbChecked
      TabOrder = 4
      OnClick = ckLabelsClick
    end
    object AddPois: TButton
      Left = 7
      Top = 34
      Width = 98
      Height = 25
      Caption = 'Add 8 Pois'
      TabOrder = 5
      OnClick = AddPoisClick
    end
    object RadioGroup1: TRadioGroup
      Left = 111
      Top = 0
      Width = 82
      Height = 59
      Caption = 'Select'
      TabOrder = 6
    end
    object rbMarkers: TRadioButton
      Left = 123
      Top = 16
      Width = 60
      Height = 17
      Caption = 'Markers'
      Checked = True
      TabOrder = 7
      TabStop = True
      OnClick = rbMarkersClick
    end
    object rbPois: TRadioButton
      Left = 123
      Top = 36
      Width = 60
      Height = 17
      Caption = 'Pois'
      TabOrder = 8
      OnClick = rbMarkersClick
    end
    object ckScale: TCheckBox
      Left = 570
      Top = 25
      Width = 47
      Height = 17
      Caption = 'Scale'
      TabOrder = 9
      OnClick = ckScaleClick
    end
    object cbSelect: TComboBox
      Left = 664
      Top = 23
      Width = 73
      Height = 21
      Style = csDropDownList
      TabOrder = 10
      OnChange = cbSelectChange
      Items.Strings = (
        'none'
        'Alpha'
        'Beta'
        'Gamma')
    end
  end
  object map: TECNativeMap
    Left = 0
    Top = 65
    Width = 763
    Height = 480
    HideShapesWhenZoom = False
    HideShapesWhenWaitingTile = False
    DblClickZoom = True
    MouseWheelZoom = True
    latitude = 43.232951000000000000
    longitude = 0.078081999999994910
    Reticle = False
    ReticleColor = clBlack
    ZoomScaleFactor = 0
    DragRect = drNone
    Draggable = True
    TileServer = tsOsmFr
    OnlyOneOpenInfoWindow = False
    WaitingForDestruction = False
    Active = True
    OnMapPaint = mapMapPaint
    Align = alClient
    ExplicitWidth = 634
  end
  object FontDialog: TFontDialog
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'Tahoma'
    Font.Style = []
    Left = 464
    Top = 88
  end
end
