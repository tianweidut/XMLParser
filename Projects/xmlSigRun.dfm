object sigRun: TsigRun
  Left = 0
  Top = 0
  Caption = 'sigRun'
  ClientHeight = 498
  ClientWidth = 425
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  PixelsPerInch = 96
  TextHeight = 13
  object mmoDebug: TMemo
    Left = 0
    Top = 0
    Width = 425
    Height = 498
    Align = alClient
    Color = clBlack
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWhite
    Font.Height = -11
    Font.Name = 'Tahoma'
    Font.Style = []
    Lines.Strings = (
      #35843#35797#31383#21475)
    ParentFont = False
    ScrollBars = ssBoth
    TabOrder = 0
  end
  object btn1: TButton
    Left = 304
    Top = 432
    Width = 75
    Height = 25
    Caption = 'quit'
    TabOrder = 1
    OnClick = btn1Click
  end
  object conDB: TADOConnection
    Connected = True
    ConnectionString = 
      'Provider=MSDASQL.1;Persist Security Info=False;Data Source=xmlPa' +
      'rse;Initial Catalog=XML_Parse'
    LoginPrompt = False
    Left = 120
    Top = 168
  end
  object tmr: TTimer
    OnTimer = tmrTimer
    Left = 128
    Top = 256
  end
end
