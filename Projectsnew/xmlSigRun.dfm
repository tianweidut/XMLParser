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
  OnCreate = FormCreate
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
    ExplicitLeft = 8
    ExplicitTop = 8
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
end
