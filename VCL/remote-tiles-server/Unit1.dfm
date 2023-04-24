object Form1: TForm1
  Left = 0
  Top = 0
  BorderStyle = bsDialog
  Caption = 'TECNativeMap Tiles Server'
  ClientHeight = 41
  ClientWidth = 498
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  Position = poScreenCenter
  StyleElements = []
  OnCloseQuery = FormCloseQuery
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 13
  object Label2: TLabel
    Left = 307
    Top = 12
    Width = 58
    Height = 13
    Caption = 'Port server:'
  end
  object btConnect: TButton
    Left = 8
    Top = 8
    Width = 75
    Height = 25
    Caption = 'Start Server'
    TabOrder = 0
    OnClick = btConnectClick
  end
  object ckCache: TCheckBox
    Left = 99
    Top = 12
    Width = 58
    Height = 17
    Caption = 'Cache'
    TabOrder = 1
    OnClick = ckCacheClick
  end
  object edCache: TEdit
    Left = 163
    Top = 10
    Width = 121
    Height = 21
    TabOrder = 2
    Text = 'C:\Maps'
  end
  object edPortServer: TEdit
    Left = 371
    Top = 10
    Width = 121
    Height = 21
    TabOrder = 3
    Text = '8080'
  end
end
