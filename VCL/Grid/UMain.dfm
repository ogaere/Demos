object Form8: TForm8
  Left = 0
  Top = 0
  Caption = 'DemoGrids - Right click on a rectangular grid to edit it'
  ClientHeight = 441
  ClientWidth = 738
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -12
  Font.Name = 'Segoe UI'
  Font.Style = []
  OnActivate = FormActivate
  OnCreate = FormCreate
  TextHeight = 15
  object info: TLabel
    AlignWithMargins = True
    Left = 7
    Top = 418
    Width = 728
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
    ExplicitWidth = 4
  end
  object Panel1: TPanel
    Left = 0
    Top = 0
    Width = 738
    Height = 41
    Align = alTop
    TabOrder = 0
    object Label1: TLabel
      Left = 514
      Top = 11
      Width = 18
      Height = 15
      Caption = 'Col'
    end
    object Label2: TLabel
      Left = 589
      Top = 11
      Width = 23
      Height = 15
      Caption = 'Row'
    end
    object address: TEdit
      Left = 191
      Top = 8
      Width = 236
      Height = 23
      Hint = 'Address'
      ParentShowHint = False
      ShowHint = True
      TabOrder = 0
      TextHint = 'get a polygon from address (press enter)'
      OnKeyUp = addressKeyUp
    end
    object AddGrid: TButton
      Left = 433
      Top = 7
      Width = 75
      Height = 25
      Caption = 'Add grid'
      TabOrder = 1
      OnClick = AddGridClick
    end
    object col: TSpinEdit
      Left = 538
      Top = 8
      Width = 40
      Height = 24
      MaxValue = 99
      MinValue = 1
      TabOrder = 2
      Value = 5
    end
    object row: TSpinEdit
      Left = 618
      Top = 8
      Width = 40
      Height = 24
      MaxValue = 99
      MinValue = 1
      TabOrder = 3
      Value = 5
    end
    object grids: TComboBox
      Left = 8
      Top = 8
      Width = 114
      Height = 23
      Style = csDropDownList
      TabOrder = 4
      OnChange = gridsChange
    end
    object DeleteGrid: TButton
      Left = 128
      Top = 7
      Width = 57
      Height = 25
      Caption = 'Delete'
      Enabled = False
      TabOrder = 5
      OnClick = DeleteGridClick
    end
  end
  object map: TECNativeMap
    Left = 0
    Top = 41
    Width = 738
    Height = 374
    FocusedShapeWhenClicking = True
    FocusedShapeWhenHovering = True
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
    TabOrder = 1
  end
  object pmGrid: TPopupMenu
    Left = 376
    Top = 153
    object N2x21: TMenuItem
      Caption = 'Grid 2x2'
      OnClick = N2x21Click
    end
    object Grid5x51: TMenuItem
      Tag = 1
      Caption = 'Grid 5x5'
      OnClick = N2x21Click
    end
    object Grid10x101: TMenuItem
      Tag = 2
      Caption = 'Grid 10x10'
      OnClick = N2x21Click
    end
    object Cell1: TMenuItem
      Tag = 3
      Caption = 'Cell size 500 m'
      OnClick = N2x21Click
    end
    object Cellsize500m1: TMenuItem
      Tag = 4
      Caption = 'Cell size 1 km'
      OnClick = N2x21Click
    end
    object Cellsize1km1: TMenuItem
      Tag = 5
      Caption = 'Cell size 2 km'
      OnClick = N2x21Click
    end
    object Exiteditmode1: TMenuItem
      Tag = 6
      Caption = 'Exit edit mode'
      OnClick = N2x21Click
    end
  end
end
