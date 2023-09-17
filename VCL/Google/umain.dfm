object FormGoogle: TFormGoogle
  Left = 0
  Top = 0
  Caption = 'Google Maps tiles with TECNativeMap'
  ClientHeight = 479
  ClientWidth = 745
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -12
  Font.Name = 'Segoe UI'
  Font.Style = []
  OnCreate = FormCreate
  TextHeight = 15
  object map: TECNativeMap
    Left = 0
    Top = 0
    Width = 496
    Height = 479
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
    TabOrder = 0
    ExplicitLeft = 32
    ExplicitTop = 8
    ExplicitWidth = 416
  end
  object Panel1: TPanel
    Left = 496
    Top = 0
    Width = 249
    Height = 479
    Align = alRight
    BevelOuter = bvNone
    Padding.Left = 7
    Padding.Top = 7
    Padding.Right = 7
    Padding.Bottom = 7
    TabOrder = 1
    object Label1: TLabel
      Left = 7
      Top = 55
      Width = 235
      Height = 15
      Align = alTop
      Alignment = taCenter
      Caption = 'Langue'
      ExplicitLeft = 6
      ExplicitTop = 52
      ExplicitWidth = 171
    end
    object Label3: TLabel
      Left = 7
      Top = 7
      Width = 235
      Height = 15
      Align = alTop
      Alignment = taCenter
      Caption = 'Map type'
      ExplicitLeft = 6
      ExplicitTop = 4
      ExplicitWidth = 171
    end
    object maptype: TComboBox
      AlignWithMargins = True
      Left = 10
      Top = 29
      Width = 229
      Height = 23
      Margins.Top = 7
      Align = alTop
      Style = csDropDownList
      ItemIndex = 0
      TabOrder = 0
      Text = 'roadmap'
      OnChange = maptypeChange
      Items.Strings = (
        'roadmap'
        'terrain'
        'satellite')
      ExplicitLeft = 9
      ExplicitTop = 8
      ExplicitWidth = 165
    end
    object langue: TComboBox
      AlignWithMargins = True
      Left = 10
      Top = 77
      Width = 229
      Height = 23
      Margins.Top = 7
      Align = alTop
      Style = csDropDownList
      TabOrder = 1
      OnChange = langueChange
      Items.Strings = (
        'en-US'
        'fr-FR')
      ExplicitTop = 29
      ExplicitWidth = 165
    end
    object traffic: TCheckBox
      AlignWithMargins = True
      Left = 10
      Top = 106
      Width = 229
      Height = 17
      Align = alTop
      Caption = 'Traffic'
      TabOrder = 2
      OnClick = trafficClick
      ExplicitLeft = 48
      ExplicitTop = 168
      ExplicitWidth = 97
    end
    object GStyles: TGroupBox
      AlignWithMargins = True
      Left = 10
      Top = 129
      Width = 229
      Height = 340
      Align = alClient
      Caption = 'JSON styles'
      Padding.Left = 3
      Padding.Top = 3
      Padding.Right = 3
      Padding.Bottom = 3
      TabOrder = 3
      ExplicitLeft = 24
      ExplicitTop = 176
      ExplicitWidth = 185
      ExplicitHeight = 105
      object LinkStyles: TLabel
        AlignWithMargins = True
        Left = 8
        Top = 317
        Width = 213
        Height = 15
        Cursor = crHandPoint
        Align = alBottom
        Caption = 'https://mapstyle.withgoogle.com/'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clHighlight
        Font.Height = -12
        Font.Name = 'Segoe UI'
        Font.Style = []
        ParentFont = False
        OnClick = LinkStylesClick
        ExplicitLeft = 5
        ExplicitTop = 320
        ExplicitWidth = 183
      end
      object json: TMemo
        Left = 5
        Top = 20
        Width = 219
        Height = 263
        Align = alClient
        ScrollBars = ssVertical
        TabOrder = 0
        OnChange = jsonChange
      end
      object ClearStyles: TButton
        AlignWithMargins = True
        Left = 8
        Top = 286
        Width = 213
        Height = 25
        Align = alBottom
        Caption = 'Clear'
        TabOrder = 1
        OnClick = ClearStylesClick
        ExplicitLeft = 96
        ExplicitTop = 8
        ExplicitWidth = 75
      end
    end
  end
end
