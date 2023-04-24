object Form6: TForm6
  Left = 0
  Top = 0
  Caption = 'OpenWeather for TECNativeMap '#169' ESCOT-SEP Christophe'
  ClientHeight = 533
  ClientWidth = 668
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
    Width = 668
    Height = 41
    Align = alTop
    TabOrder = 0
    object route: TButton
      AlignWithMargins = True
      Left = 536
      Top = 4
      Width = 124
      Height = 33
      Margins.Right = 7
      Align = alRight
      Caption = 'Calculate the route'
      TabOrder = 0
      OnClick = routeClick
    end
    object Panel3: TPanel
      Left = 1
      Top = 1
      Width = 532
      Height = 39
      Align = alClient
      BevelOuter = bvNone
      TabOrder = 1
      OnResize = Panel3Resize
      object rend: TEdit
        AlignWithMargins = True
        Left = 261
        Top = 10
        Width = 268
        Height = 19
        Margins.Top = 10
        Margins.Bottom = 10
        Align = alRight
        TabOrder = 0
        Text = 'end-route'
        ExplicitHeight = 21
      end
      object start: TEdit
        AlignWithMargins = True
        Left = 3
        Top = 10
        Width = 252
        Height = 19
        Margins.Top = 10
        Margins.Bottom = 10
        Align = alLeft
        TabOrder = 1
        Text = 'start-route'
        ExplicitHeight = 21
      end
    end
  end
  object Panel2: TPanel
    Left = 0
    Top = 424
    Width = 668
    Height = 109
    Align = alBottom
    Caption = 'Panel2'
    TabOrder = 1
    object Label1: TLabel
      AlignWithMargins = True
      Left = 4
      Top = 4
      Width = 660
      Height = 14
      Align = alTop
      Alignment = taCenter
      Caption = 
        'Double click on the map to get the weather, Right click + drag t' +
        'o select an area'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -12
      Font.Name = 'Tahoma'
      Font.Style = [fsBold]
      ParentFont = False
      ExplicitWidth = 493
    end
    object weatherMemo: TMemo
      Left = 1
      Top = 21
      Width = 666
      Height = 87
      Align = alClient
      ScrollBars = ssBoth
      TabOrder = 0
      WordWrap = False
    end
  end
  object map: TECNativeMap
    Left = 0
    Top = 41
    Width = 668
    Height = 383
    HideShapesWhenZoom = False
    HideShapesWhenWaitingTile = False
    DblClickZoom = False
    MouseWheelZoom = True
    Latitude = 43.232951000000000000
    Longitude = 0.078081999999994910
    Reticle = False
    ReticleColor = clBlack
    ZoomScaleFactor = 0
    DragRect = drSelect
    Draggable = True
    Active = True
    OnMapSelectRect = mapMapSelectRect
    OnMapDblClick = mapMapDblClick
    Align = alClient
  end
end
