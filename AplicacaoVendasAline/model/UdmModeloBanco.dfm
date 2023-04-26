object DataModule1: TDataModule1
  OldCreateOrder = False
  Height = 230
  Width = 331
  object SQLConnection1: TSQLConnection
    DriverName = 'Sqlite'
    Params.Strings = (
      'DriverUnit=Data.DbxSqlite'
      
        'DriverPackageLoader=TDBXSqliteDriverLoader,DBXSqliteDriver270.bp' +
        'l'
      
        'MetaDataPackageLoader=TDBXSqliteMetaDataCommandFactory,DbxSqlite' +
        'Driver270.bpl'
      'FailIfMissing=True'
      'Database=C:\BancoDadosVendas\banco.db')
    Left = 24
    Top = 8
  end
  object SQLQuery1: TSQLQuery
    Params = <>
    Left = 104
    Top = 8
  end
end
