object Form2: TForm2
  Left = 0
  Top = 0
  Caption = 'TECNativeMap Client'
  ClientHeight = 281
  ClientWidth = 789
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
    Top = 240
    Width = 789
    Height = 41
    Align = alBottom
    TabOrder = 0
    object Label1: TLabel
      Left = 344
      Top = 12
      Width = 48
      Height = 13
      Caption = 'IP server:'
    end
    object Label2: TLabel
      Left = 554
      Top = 12
      Width = 58
      Height = 13
      Caption = 'Port server:'
    end
    object edIPServer: TEdit
      Left = 398
      Top = 10
      Width = 121
      Height = 21
      TabOrder = 0
      Text = '127.0.0.1'
    end
    object edPortServer: TEdit
      Left = 618
      Top = 10
      Width = 121
      Height = 21
      TabOrder = 1
      Text = '8080'
    end
    object btConnect: TButton
      Left = 7
      Top = 8
      Width = 75
      Height = 25
      Caption = 'Start client'
      TabOrder = 2
      OnClick = btConnectClick
    end
    object CheckBox1: TCheckBox
      Left = 120
      Top = 16
      Width = 97
      Height = 17
      Caption = 'local'
      TabOrder = 3
      OnClick = CheckBox1Click
    end
  end
  object map: TECNativeMap
    Left = 0
    Top = 0
    Width = 789
    Height = 240
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
    OnlyOneOpenInfoWindow = False
    WaitingForDestruction = False
    Active = True
    Align = alClient
  end
end
