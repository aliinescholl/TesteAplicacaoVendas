unit UdmModeloBanco;

interface

uses
  System.SysUtils, System.Classes, Data.DB, Data.SqlExpr, Data.DBXSQLite,
  Data.FMTBcd, FireDAC.Stan.Intf, FireDAC.Stan.Option, FireDAC.Stan.Error,
  FireDAC.UI.Intf, FireDAC.Phys.Intf, FireDAC.Stan.Def, FireDAC.Stan.Pool,
  FireDAC.Stan.Async, FireDAC.Phys, FireDAC.Phys.SQLite, FireDAC.Phys.SQLiteDef,
  FireDAC.Stan.ExprFuncs, FireDAC.Phys.SQLiteWrapper.Stat, FireDAC.VCLUI.Wait,
  FireDAC.Comp.Client, FireDAC.Stan.Param, FireDAC.DatS, FireDAC.DApt.Intf,
  FireDAC.DApt, FireDAC.Comp.DataSet;

type
  TDataModule1 = class(TDataModule)
    FDConnection1: TFDConnection;
    FDQryProdutos: TFDQuery;
    FDQryProdutosid: TFDAutoIncField;
    FDQryProdutospreco: TFloatField;
    FDQryClientes: TFDQuery;
    FDQueryItens: TFDQuery;
    FDQueryItensid: TFDAutoIncField;
    FDQueryItensid_produto: TIntegerField;
    FDQueryItensqtd: TIntegerField;
    FDQueryItenspreco: TFloatField;
    FDQueryItensid_venda: TIntegerField;
    FDQryVendas: TFDQuery;
    FDQryProdutosdescricao: TStringField;
    FDQuery1: TFDQuery;
    FDQryVendasid: TFDAutoIncField;
    FDQryVendasid_cliente: TIntegerField;
    FDQryVendasvalor_total: TFloatField;
    FDQryVendasdata_venda: TWideMemoField;
  private
    { Private declarations }
  public
    procedure CriarBanco;

    { Public declarations }
  end;

var
  DataModule1: TDataModule1;

implementation

uses
  Vcl.Dialogs;

{%CLASSGROUP 'Vcl.Controls.TControl'}

{$R *.dfm}

{ TDataModule1 }

procedure TDataModule1.CriarBanco;
var
  Conn: TFDConnection;
  Query: TFDQuery;
begin
  Conn := TFDConnection.Create(nil);
  try
    Conn.DriverName := 'SQLite';
    Conn.Params.Database := 'C:\base\bancoVendas.db';
    Conn.Params.UserName := '';
    Conn.Params.Password := '';

    Conn.Close;
    Conn.Open;

    Query := TFDQuery.Create(nil);
    try
      Query.Connection := Conn;
      Query.ExecSQL('CREATE TABLE IF NOT EXISTS clientes (id INTEGER PRIMARY KEY AUTOINCREMENT, nome TEXT, cpf TEXT UNIQUE)');
      Query.ExecSQL('CREATE TABLE IF NOT EXISTS vendas (id INTEGER PRIMARY KEY AUTOINCREMENT, id_cliente INTEGER, valor_total REAL, data_venda TEXT, FOREIGN KEY (id_cliente) REFERENCES clientes(id))');
      Query.ExecSQL('CREATE TABLE IF NOT EXISTS itens (id INTEGER PRIMARY KEY AUTOINCREMENT, id_produto INTEGER, qtd INTEGER, preco REAL, id_venda INTEGER, FOREIGN KEY (id_venda) REFERENCES venda(id))');
      Query.ExecSQL('CREATE TABLE IF NOT EXISTS produtos (id INTEGER PRIMARY KEY AUTOINCREMENT, descricao VARCHAR(55) UNIQUE, preco REAL)');

      Query.ExecSQL('INSERT OR IGNORE INTO produtos(descricao, preco) VALUES (''Camiseta'', 29.99)');
      Query.ExecSQL('INSERT OR IGNORE INTO produtos(descricao, preco) VALUES (''Camisa Polo'', 49.99)');
      Query.ExecSQL('INSERT OR IGNORE INTO produtos(descricao, preco) VALUES (''T�nis'', 99.99)');
    finally
      Query.Close;
      Query.Free;
    end;
  finally
    Conn.Close;
    Conn.Free;
  end;
end;

end.
