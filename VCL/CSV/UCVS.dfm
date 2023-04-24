object Form29: TForm29
  Left = 0
  Top = 0
  ClientHeight = 432
  ClientWidth = 925
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OnCreate = FormCreate
  TextHeight = 13
  object Panel1: TPanel
    AlignWithMargins = True
    Left = 3
    Top = 3
    Width = 200
    Height = 426
    Align = alLeft
    BevelInner = bvRaised
    BevelOuter = bvNone
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -12
    Font.Name = 'Tahoma'
    Font.Style = [fsBold]
    ParentFont = False
    TabOrder = 0
    object Label1: TLabel
      Left = 7
      Top = 16
      Width = 54
      Height = 14
      Caption = 'Delimiter'
    end
    object Label2: TLabel
      Left = 6
      Top = 80
      Width = 82
      Height = 14
      Caption = 'Latitude field'
    end
    object Label3: TLabel
      Left = 6
      Top = 144
      Width = 93
      Height = 14
      Caption = 'Longitude field'
    end
    object lbValidate: TLabel
      AlignWithMargins = True
      Left = 83
      Top = 400
      Width = 96
      Height = 13
      Margins.Right = 4
      Margins.Bottom = 4
      Alignment = taCenter
      Caption = 'validate with ENTER'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clRed
      Font.Height = -11
      Font.Name = 'Tahoma'
      Font.Style = []
      ParentFont = False
      Visible = False
    end
    object Label4: TLabel
      Left = 7
      Top = 259
      Width = 186
      Height = 14
      Caption = 'Use this field as wkt geometry'
    end
    object delimiter: TEdit
      Left = 7
      Top = 36
      Width = 186
      Height = 22
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -12
      Font.Name = 'Tahoma'
      Font.Style = []
      ParentFont = False
      TabOrder = 0
      OnChange = FieldChange
      OnKeyPress = delimiterKeyPress
    end
    object latitude: TEdit
      Left = 6
      Top = 100
      Width = 186
      Height = 22
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -12
      Font.Name = 'Tahoma'
      Font.Style = []
      ParentFont = False
      TabOrder = 1
      OnChange = FieldChange
      OnKeyPress = latitudeKeyPress
    end
    object longitude: TEdit
      Left = 6
      Top = 164
      Width = 186
      Height = 22
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -12
      Font.Name = 'Tahoma'
      Font.Style = []
      ParentFont = False
      TabOrder = 2
      OnChange = FieldChange
      OnKeyPress = longitudeKeyPress
    end
    object btOpenCSV: TButton
      Left = 6
      Top = 312
      Width = 186
      Height = 25
      Caption = 'Open csv file'
      TabOrder = 3
      OnClick = btOpenCSVClick
    end
    object Fields: TComboBox
      Left = 6
      Top = 231
      Width = 186
      Height = 22
      AutoComplete = False
      Style = csDropDownList
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -12
      Font.Name = 'Tahoma'
      Font.Style = []
      ParentFont = False
      TabOrder = 4
      OnChange = FieldChange
      OnKeyPress = LabelFieldKeyPress
      OnSelect = FieldsSelect
    end
    object DisplayLabel: TCheckBox
      Left = 6
      Top = 208
      Width = 173
      Height = 17
      Caption = 'Use this field as a label'
      TabOrder = 5
      OnClick = DisplayLabelClick
    end
    object wktFields: TComboBox
      Left = 7
      Top = 276
      Width = 186
      Height = 22
      AutoComplete = False
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -12
      Font.Name = 'Tahoma'
      Font.Style = []
      ParentFont = False
      TabOrder = 6
      OnChange = wktFieldsChange
      OnKeyPress = LabelFieldKeyPress
      OnSelect = FieldsSelect
    end
  end
  object Memo1: TMemo
    AlignWithMargins = True
    Left = 725
    Top = 3
    Width = 197
    Height = 426
    Align = alRight
    ReadOnly = True
    ScrollBars = ssBoth
    TabOrder = 1
    WantReturns = False
    WordWrap = False
  end
  object Panel2: TPanel
    AlignWithMargins = True
    Left = 209
    Top = 3
    Width = 510
    Height = 426
    Align = alClient
    BevelInner = bvLowered
    Caption = 'Panel2'
    TabOrder = 2
    object PageControl1: TPageControl
      Left = 2
      Top = 2
      Width = 506
      Height = 422
      ActivePage = View
      Align = alClient
      Font.Charset = ANSI_CHARSET
      Font.Color = clWindowText
      Font.Height = -12
      Font.Name = 'Tahoma'
      Font.Style = []
      ParentFont = False
      TabOrder = 0
      object View: TTabSheet
        Caption = 'Map'
        object map: TECNativeMap
          AlignWithMargins = True
          Left = 3
          Top = 3
          Width = 492
          Height = 387
          FocusedShapeWhenClicking = True
          FocusedShapeWhenHovering = False
          HideShapesWhenZoom = False
          HideShapesWhenWaitingTile = False
          DblClickZoom = True
          MouseWheelZoom = True
          latitude = 43.232947274405240000
          longitude = 0.078105926513671880
          Reticle = False
          ReticleColor = clBlack
          ZoomScaleFactor = 0
          NumericalZoom = 14.000000000000000000
          DragRect = drNone
          Draggable = True
          OnlyOneOpenInfoWindow = False
          WaitingForDestruction = False
          Active = True
          Align = alClient
        end
      end
      object TabSheet1: TTabSheet
        Caption = 'CSV'
        ImageIndex = 1
        object csvdata: TMemo
          Left = 0
          Top = 0
          Width = 498
          Height = 393
          Align = alClient
          Font.Charset = ANSI_CHARSET
          Font.Color = clWindowText
          Font.Height = -12
          Font.Name = 'Segoe UI'
          Font.Style = []
          ParentFont = False
          ReadOnly = True
          ScrollBars = ssBoth
          TabOrder = 0
          WordWrap = False
        end
      end
    end
  end
  object OpenDialog1: TOpenDialog
    DefaultExt = '*.csv'
    Left = 536
    Top = 120
  end
end
