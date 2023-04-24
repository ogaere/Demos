object FSelectArea: TFSelectArea
  Left = 0
  Top = 0
  Caption = 'Click on map for move the selection area or drag it'
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
  object info: TLabel
    AlignWithMargins = True
    Left = 7
    Top = 418
    Width = 614
    Height = 20
    Margins.Left = 7
    Align = alBottom
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -15
    Font.Name = 'Segoe UI'
    Font.Style = []
    ParentFont = False
    Layout = tlCenter
    ExplicitLeft = 0
    ExplicitTop = 420
    ExplicitWidth = 4
  end
  object map: TECNativeMap
    Left = 0
    Top = 29
    Width = 624
    Height = 386
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
    OnMapClick = mapMapClick
    Align = alClient
    TabOrder = 0
    ExplicitLeft = 128
    ExplicitTop = 136
    ExplicitWidth = 256
    ExplicitHeight = 256
  end
  object panel1: TPanel
    Left = 0
    Top = 0
    Width = 624
    Height = 29
    Align = alTop
    TabOrder = 1
    object toolbar: TLabel
      Left = 1
      Top = 1
      Width = 622
      Height = 32
      Align = alTop
      Alignment = taRightJustify
      Caption = '   '
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -16
      Font.Name = 'Segoe UI'
      Font.Style = []
      ParentFont = False
    end
    object CircleSelection: TCheckBox
      Left = 16
      Top = 6
      Width = 97
      Height = 17
      Caption = 'Circle Selection'
      TabOrder = 0
      OnClick = CircleSelectionClick
    end
    object ChangeColor: TButton
      Left = 232
      Top = 2
      Width = 105
      Height = 25
      Caption = 'Change Color'
      TabOrder = 1
      OnClick = ChangeColorClick
    end
    object showmetric: TCheckBox
      Left = 136
      Top = 6
      Width = 97
      Height = 17
      Caption = 'Show metric'
      Checked = True
      State = cbChecked
      TabOrder = 2
      OnClick = showmetricClick
    end
    object CenterOnArea: TButton
      Left = 343
      Top = 2
      Width = 75
      Height = 25
      Caption = 'Zoom Area'
      TabOrder = 3
      OnClick = CenterOnAreaClick
    end
  end
end
