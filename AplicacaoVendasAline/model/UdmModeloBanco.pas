unit UdmModeloBanco;

interface

uses
  System.SysUtils, System.Classes, Data.DB, Data.SqlExpr, Data.DBXSQLite,
  Data.FMTBcd;

type
  TDataModule1 = class(TDataModule)
    SQLConnection1: TSQLConnection;
    SQLQuery1: TSQLQuery;
  private
    { Private declarations }
  public
    procedure CriarBanco;

    { Public declarations }
  end;

var
  DataModule1: TDataModule1;

implementation

{%CLASSGROUP 'Vcl.Controls.TControl'}

{$R *.dfm}

{ TDataModule1 }

procedure TDataModule1.CriarBanco;
begin
  SQLConnection1.Open;
  SQLQuery1.SQL.Text := ('CREATE TABLE clientes (id INTEGER PRIMARY KEY, nome TEXT,cpf TEXT UNIQUE);');
  SQLQuery1.SQL.Text := ('CREATE TABLE venda (id INTEGER PRIMARY KEY, id_cliente INTEGER, data_venda TEXT,FOREIGN KEY (id_cliente) REFERENCES clientes(id));');
  SQLQuery1.SQL.Text := ('CREATE TABLE itens (id INTEGER PRIMARY KEY, id_produto INTEGER, qtd INTEGER, preco REAL, id_venda INTEGER, FOREIGN KEY (id_venda) REFERENCES venda(id));');
  SQLQuery1.SQL.Text := ('CREATE TABLE produtos (id INTEGER PRIMARY KEY, nome TEXT, preco REAL);');
  SQLQuery1.ExecSQL;
  SQLConnection1.Close;
end;

end.
