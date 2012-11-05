object DataModuleMain2: TDataModuleMain2
  OldCreateOrder = False
  Height = 151
  Width = 215
  object ds1: TADODataSet
    Connection = xmlMainFrm.conDB
    CommandText = 'select * from finishFile'
    Parameters = <>
    Left = 128
    Top = 32
  end
  object dsfinishfile: TDataSource
    DataSet = ds1
    Left = 48
    Top = 32
  end
end
