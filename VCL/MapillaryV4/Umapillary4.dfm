object Form30: TForm30
  Left = 0
  Top = 0
  Caption = 'TECNativeMap Mapillary Layer '#169' ESCOT-SEP Christophe'
  ClientHeight = 664
  ClientWidth = 805
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -13
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  PixelsPerInch = 96
  TextHeight = 16
  object Panel1: TPanel
    Left = 543
    Top = 0
    Width = 262
    Height = 664
    Align = alRight
    TabOrder = 0
    object Image: TImage
      AlignWithMargins = True
      Left = 4
      Top = 99
      Width = 254
      Height = 256
      Align = alTop
      Center = True
      ExplicitLeft = -1
      ExplicitTop = 1
      ExplicitWidth = 528
    end
    object Label1: TLabel
      AlignWithMargins = True
      Left = 4
      Top = 7
      Width = 254
      Height = 16
      Margins.Top = 6
      Margins.Bottom = 6
      Align = alTop
      Alignment = taCenter
      Caption = 'Label1'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -13
      Font.Name = 'Tahoma'
      Font.Style = [fsBold]
      ParentFont = False
      Transparent = False
      ExplicitWidth = 42
    end
    object MapillaryRequest: TLabel
      AlignWithMargins = True
      Left = 4
      Top = 644
      Width = 254
      Height = 16
      Align = alBottom
      Alignment = taCenter
      Color = clBackground
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWhite
      Font.Height = -13
      Font.Name = 'Tahoma'
      Font.Style = [fsBold]
      ParentColor = False
      ParentFont = False
      Transparent = False
      ExplicitWidth = 4
    end
    object Label2: TLabel
      AlignWithMargins = True
      Left = 3
      Top = 72
      Width = 69
      Height = 16
      Caption = 'Sequence : '
    end
    object Label4: TLabel
      AlignWithMargins = True
      Left = 4
      Top = 405
      Width = 254
      Height = 16
      Margins.Top = 6
      Margins.Bottom = 6
      Align = alTop
      Alignment = taCenter
      Caption = 'Detections image'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -13
      Font.Name = 'Tahoma'
      Font.Style = [fsBold]
      ParentFont = False
      Transparent = False
      ExplicitWidth = 112
    end
    object LoadVisibleArea: TButton
      AlignWithMargins = True
      Left = 4
      Top = 35
      Width = 254
      Height = 25
      Margins.Top = 6
      Margins.Bottom = 6
      Align = alTop
      Caption = 'Load visible area'
      TabOrder = 1
      OnClick = LoadVisibleAreaClick
    end
    object ckLayer: TCheckBox
      AlignWithMargins = True
      Left = 4
      Top = 618
      Width = 250
      Height = 17
      Margins.Top = 6
      Margins.Right = 7
      Margins.Bottom = 6
      Align = alBottom
      Caption = 'Show mapillary layer'
      Checked = True
      State = cbChecked
      TabOrder = 2
      OnClick = ckLayerClick
    end
    object pnImage: TPanel
      Left = 1
      Top = 358
      Width = 260
      Height = 41
      Align = alTop
      Caption = 'pnImage'
      Enabled = False
      ShowCaption = False
      TabOrder = 3
      object lbImage: TLabel
        AlignWithMargins = True
        Left = 77
        Top = 4
        Width = 106
        Height = 33
        ParentCustomHint = False
        Align = alClient
        Alignment = taCenter
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -12
        Font.Name = 'Tahoma'
        Font.Style = []
        ParentFont = False
        Transparent = False
        Layout = tlCenter
        StyleElements = [seClient, seBorder]
        ExplicitWidth = 4
        ExplicitHeight = 14
      end
      object NextImage: TButton
        AlignWithMargins = True
        Left = 189
        Top = 4
        Width = 32
        Height = 33
        Hint = 'Next Image'
        Margins.Right = 0
        Align = alRight
        Caption = '>'
        ParentShowHint = False
        ShowHint = True
        TabOrder = 0
        OnClick = NextImageClick
      end
      object PrevImage: TButton
        AlignWithMargins = True
        Left = 39
        Top = 4
        Width = 32
        Height = 33
        Hint = 'Prev Image'
        Align = alLeft
        Caption = '<'
        ParentShowHint = False
        ShowHint = True
        TabOrder = 1
        OnClick = PrevImageClick
      end
      object LastImage: TButton
        AlignWithMargins = True
        Left = 224
        Top = 4
        Width = 32
        Height = 33
        Hint = 'Last Image'
        Align = alRight
        Caption = '>>'
        ParentShowHint = False
        ShowHint = True
        TabOrder = 2
        OnClick = LastImageClick
      end
      object FirstImage: TButton
        AlignWithMargins = True
        Left = 4
        Top = 4
        Width = 32
        Height = 33
        Hint = 'First Image'
        Margins.Right = 0
        Align = alLeft
        Caption = '<<'
        ParentShowHint = False
        ShowHint = True
        TabOrder = 3
        OnClick = FirstImageClick
      end
    end
    object Sequences: TComboBox
      AlignWithMargins = True
      Left = 76
      Top = 69
      Width = 182
      Height = 24
      Margins.Left = 75
      Align = alTop
      Style = csDropDownList
      TabOrder = 0
      TabStop = False
      OnChange = SequencesChange
    end
    object Panel2: TPanel
      Left = 1
      Top = 571
      Width = 260
      Height = 41
      Align = alBottom
      BevelOuter = bvNone
      TabOrder = 4
      object Label3: TLabel
        AlignWithMargins = True
        Left = 3
        Top = 19
        Width = 254
        Height = 16
        Margins.Bottom = 6
        Align = alBottom
        Caption = 'DblClick search distance (meters)'
        ExplicitWidth = 191
      end
      object distance: TSpinEdit
        AlignWithMargins = True
        Left = 200
        Top = 15
        Width = 52
        Height = 26
        Margins.Bottom = 6
        Increment = 10
        MaxValue = 5000
        MinValue = 0
        TabOrder = 0
        Value = 100
      end
    end
    object detections: TMemo
      AlignWithMargins = True
      Left = 4
      Top = 430
      Width = 254
      Height = 138
      Align = alClient
      ReadOnly = True
      ScrollBars = ssVertical
      TabOrder = 5
      ExplicitLeft = 6
      ExplicitWidth = 260
      ExplicitHeight = 144
    end
  end
  object map: TECNativeMap
    Left = 0
    Top = 0
    Width = 543
    Height = 664
    HideShapesWhenZoom = False
    HideShapesWhenWaitingTile = False
    DblClickZoom = False
    MouseWheelZoom = True
    latitude = 43.232951000000000000
    longitude = 0.078081999999994910
    Reticle = False
    ReticleColor = clBlack
    ZoomScaleFactor = 0
    DragRect = drNone
    Draggable = True
    OnlyOneOpenInfoWindow = False
    WaitingForDestruction = False
    Active = True
    OnChangeMapZoom = mapChangeMapZoom
    OnMapDblClick = mapMapDblClick
    Align = alClient
  end
end
