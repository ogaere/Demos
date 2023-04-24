object Form10: TForm10
  Left = 0
  Top = 0
  Caption = 'Demo Bubble Layer '
  ClientHeight = 547
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
    Height = 547
    Align = alRight
    TabOrder = 0
    ExplicitLeft = 438
    object Label1: TLabel
      Left = 6
      Top = 288
      Width = 41
      Height = 15
      Caption = 'Opacity'
    end
    object addLayer: TButton
      Left = 8
      Top = 38
      Width = 80
      Height = 25
      Caption = 'Add layer'
      TabOrder = 0
      OnClick = addLayerClick
    end
    object layers: TComboBox
      Left = 8
      Top = 9
      Width = 177
      Height = 23
      Style = csDropDownList
      TabOrder = 1
      OnChange = layersChange
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
    object ckColorPalette: TCheckBox
      Left = 6
      Top = 205
      Width = 185
      Height = 17
      Caption = 'Use color palette'
      TabOrder = 3
    end
    object ColorListBox: TColorListBox
      Left = 6
      Top = 86
      Width = 177
      Height = 113
      DefaultColorColor = clGreen
      Selected = clGreen
      Style = [cbStandardColors, cbExtendedColors, cbSystemColors, cbIncludeDefault, cbCustomColor, cbPrettyNames, cbCustomColors]
      DoubleBuffered = True
      ParentDoubleBuffered = False
      TabOrder = 4
    end
    object MinItemSize: TLabeledEdit
      Left = 56
      Top = 240
      Width = 33
      Height = 23
      EditLabel.AlignWithMargins = True
      EditLabel.Width = 47
      EditLabel.Height = 15
      EditLabel.Caption = 'Min Size '
      LabelPosition = lpLeft
      MaxLength = 3
      NumbersOnly = True
      TabOrder = 5
      Text = ''
    end
    object MaxItemSize: TLabeledEdit
      Left = 144
      Top = 240
      Width = 33
      Height = 23
      EditLabel.AlignWithMargins = True
      EditLabel.Width = 49
      EditLabel.Height = 15
      EditLabel.Caption = 'Max Size '
      LabelPosition = lpLeft
      MaxLength = 3
      NumbersOnly = True
      TabOrder = 6
      Text = ''
    end
    object trOpacity: TTrackBar
      Left = 53
      Top = 278
      Width = 126
      Height = 25
      Max = 100
      Min = 10
      Position = 10
      PositionToolTip = ptTop
      TabOrder = 7
    end
    object UpdateOptions: TButton
      Left = 6
      Top = 392
      Width = 177
      Height = 25
      Caption = 'Update Options'
      TabOrder = 8
      OnClick = UpdateOptionsClick
    end
  end
  object map: TECNativeMap
    Left = 0
    Top = 0
    Width = 432
    Height = 547
    FocusedShapeWhenClicking = True
    FocusedShapeWhenHovering = False
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
