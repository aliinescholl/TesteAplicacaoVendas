object DataModule1: TDataModule1
  OldCreateOrder = False
  Height = 230
  Width = 331
  object FDConnection1: TFDConnection
    Params.Strings = (
      'Database=C:\base\bancoVendas.db'
      'DriverID=SQLite')
    Connected = True
    LoginPrompt = False
    Left = 56
    Top = 16
  end
  object FDQryProdutos: TFDQuery
    Active = True
    Connection = FDConnection1
    SQL.Strings = (
      'SELECT * FROM PRODUTOS')
    Left = 152
    Top = 16
    object FDQryProdutosid: TFDAutoIncField
      FieldName = 'id'
      Origin = 'id'
      ProviderFlags = [pfInWhere, pfInKey]
      ReadOnly = True
    end
    object FDQryProdutospreco: TFloatField
      FieldName = 'preco'
      Origin = 'preco'
    end
    object FDQryProdutosdescricao: TStringField
      FieldName = 'descricao'
      Size = 55
    end
  end
  object FDQryClientes: TFDQuery
    CachedUpdates = True
    Connection = FDConnection1
    SQL.Strings = (
      'SELECT * FROM clientes')
    Left = 248
    Top = 16
  end
  object FDQueryItens: TFDQuery
    Active = True
    Connection = FDConnection1
    SQL.Strings = (
      'SELECT * FROM itens')
    Left = 152
    Top = 72
    object FDQueryItensid: TFDAutoIncField
      FieldName = 'id'
      Origin = 'id'
      ProviderFlags = [pfInWhere, pfInKey]
      ReadOnly = True
    end
    object FDQueryItensid_produto: TIntegerField
      FieldName = 'id_produto'
      Origin = 'id_produto'
    end
    object FDQueryItensqtd: TIntegerField
      FieldName = 'qtd'
      Origin = 'qtd'
    end
    object FDQueryItenspreco: TFloatField
      FieldName = 'preco'
      Origin = 'preco'
    end
    object FDQueryItensid_venda: TIntegerField
      FieldName = 'id_venda'
      Origin = 'id_venda'
    end
  end
  object FDQryVendas: TFDQuery
    Active = True
    Connection = FDConnection1
    SQL.Strings = (
      'SELECT * FROM vendas')
    Left = 248
    Top = 72
    object FDQryVendasid: TFDAutoIncField
      FieldName = 'id'
      Origin = 'id'
      ProviderFlags = [pfInWhere, pfInKey]
    end
    object FDQryVendasid_cliente: TIntegerField
      FieldName = 'id_cliente'
      Origin = 'id_cliente'
    end
    object FDQryVendasvalor_total: TFloatField
      FieldName = 'valor_total'
      Origin = 'valor_total'
    end
    object FDQryVendasdata_venda: TWideMemoField
      FieldName = 'data_venda'
      Origin = 'data_venda'
      BlobType = ftWideMemo
    end
  end
  object FDQuery1: TFDQuery
    Connection = FDConnection1
    SQL.Strings = (
      
        'SELECT v.id, c.nome, v.valor_total, v.data_venda, i.id_produto, ' +
        'i.qtd, i.preco'
      'FROM vendas v'
      'INNER JOIN clientes c ON v.id_cliente = c.id'
      'INNER JOIN itens i ON v.id = i.id_venda;')
    Left = 64
    Top = 72
  end
end
