object xmlMainFrm: TxmlMainFrm
  Left = 114
  Top = 257
  Caption = 'xmlMainFrm'
  ClientHeight = 510
  ClientWidth = 390
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  Position = poDesigned
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 13
  object pnl3: TPanel
    Left = 0
    Top = 0
    Width = 390
    Height = 510
    Align = alClient
    TabOrder = 0
    ExplicitWidth = 1016
    ExplicitHeight = 566
    object pnl5: TPanel
      Left = 1
      Top = 1
      Width = 388
      Height = 508
      Align = alClient
      TabOrder = 0
      ExplicitWidth = 1014
      ExplicitHeight = 564
      object mmodbg: TMemo
        Left = 1
        Top = 1
        Width = 386
        Height = 506
        Align = alClient
        Color = clBlack
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWhite
        Font.Height = -11
        Font.Name = 'MS Sans Serif'
        Font.Style = []
        ImeName = #20013#25991' ('#31616#20307') - '#25628#29399#25340#38899#36755#20837#27861
        Lines.Strings = (
          #35843#35797#31383#21475)
        ParentFont = False
        ScrollBars = ssBoth
        TabOrder = 0
        ExplicitWidth = 464
        ExplicitHeight = 562
      end
    end
  end
  object conDB: TADOConnection
    Connected = True
    ConnectionString = 
      'Provider=MSDASQL.1;Persist Security Info=False;Data Source=xmlPa' +
      'rse;Initial Catalog=XML_Parse'
    LoginPrompt = False
    Left = 160
    Top = 264
  end
end
