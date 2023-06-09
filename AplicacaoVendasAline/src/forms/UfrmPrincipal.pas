unit UfrmPrincipal;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Data.DB, Datasnap.DBClient,
  Vcl.StdCtrls, Vcl.Grids, Vcl.DBGrids, frxClass, frxDBSet;

type
  TForm1 = class(TForm)
    DBGProdutos: TDBGrid;
    DBGItens: TDBGrid;
    edtIdProd: TEdit;
    Button2: TButton;
    btnFinalizarVenda: TButton;
    Label1: TLabel;
    edtCPFCliente: TEdit;
    edtNomeCliente: TEdit;
    DataSourceProdutos: TDataSource;
    Label2: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    Label6: TLabel;
    DataSourceItens: TDataSource;
    frxReport1: TfrxReport;
    frxDBDataset1: TfrxDBDataset;
    procedure FormCreate(Sender: TObject);
    procedure edtNomeClienteKeyPress(Sender: TObject; var Key: Char);
    procedure edtCPFClienteKeyPress(Sender: TObject; var Key: Char);
    procedure btnFinalizarVendaClick(Sender: TObject);
    procedure edtIdProdKeyPress(Sender: TObject; var Key: Char);
    procedure Button2Click(Sender: TObject);
  private
    procedure AdicionarDadosCliente(const acpf, anome: String);
    procedure AdicionarItemVenda;
    function ValorTotalVenda: Currency;
    procedure FinalizarVenda;
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form1: TForm1;

implementation

uses
  UdmModeloBanco, Data.SqlExpr;

{$R *.dfm}

procedure TForm1.AdicionarDadosCliente(const ACpf, ANome: string);
var
  xSQLConexao: TSQLConnection;
  xSQLQuery: TSQLQuery;
begin

  try
    // adiciona o CPF do cliente
    DataModule1.FDQryClientes.SQL.Text := 'INSERT INTO clientes(cpf) VALUES (:acpf)';
    DataModule1.FDQryClientes.ParamByName('acpf').AsString := ACpf;
    DataModule1.FDQryClientes.ExecSQL;

    // atualiza o nome do cliente na mesma linha do CPF
    DataModule1.FDQryClientes.SQL.Text := 'UPDATE clientes SET nome = :anome WHERE cpf = :acpf';
    DataModule1.FDQryClientes.ParamByName('anome').AsString := ANome;
    DataModule1.FDQryClientes.ParamByName('acpf').AsString  := ACpf;
    DataModule1.FDQryClientes.ExecSQL;
  finally

  end;
end;

procedure TForm1.AdicionarItemVenda;
var
  id_produto, qtd: Integer;
  preco: Double;
  id_venda: Integer;
begin
  try
  // Recupera os valores do produto selecionado
    DataModule1.FDQryProdutos.SQL.Text := 'SELECT desc, preco FROM produtos WHERE id = :id';
    DataModule1.FDQryProdutos.ParamByName('id').AsInteger := StrToInt(edtIdProd.Text);

    DataModule1.FDQryProdutos.Open;

    id_produto := DataModule1.FDQryProdutos.FieldByName('id').AsInteger;
    preco      := DataModule1.FDQryProdutos.FieldByName('preco').AsFloat;

    DataModule1.FDQryVendas.SQL.Text := 'SELECT MAX(id) FROM venda';
    DataModule1.FDQryVendas.Open;
    id_venda := DataModule1.FDQryVendas.Fields[0].AsInteger + 1; // incrementa em 1

  // Verifica se o produto j� foi adicionado na lista de itens
    DataModule1.FDQueryItens.SQL.Text := 'SELECT qtd FROM itens WHERE id_venda = :id_venda AND id_produto = :id_produto';
    DataModule1.FDQueryItens.ParamByName('id_venda').AsInteger := id_venda;
    DataModule1.FDQueryItens.ParamByName('id_produto').AsInteger := id_produto;
    DataModule1.FDQueryItens.Open;

    if not DataModule1.FDQueryItens.IsEmpty then
    begin
      // Se j� existe, atualiza a quantidade
      qtd := DataModule1.FDQueryItens.FieldByName('qtd').AsInteger + qtd;
      DataModule1.FDQueryItens.SQL.Text := 'UPDATE itens SET qtd = :qtd WHERE id_venda = :id_venda AND id_produto = :id_produto';
      DataModule1.FDQueryItens.ParamByName('qtd').AsInteger := qtd;
      DataModule1.FDQueryItens.ExecSQL;
    end
    else
    begin
      // Se tem insere um novo registro
      with DataModule1.FDQueryItens do
      begin
        SQL.Text := 'INSERT INTO itens (id_produto, qtd, preco, id_venda) VALUES (:id_produto, :qtd, :preco, :id_venda)';
        ParamByName('id_produto').AsInteger := id_produto;
        ParamByName('qtd').AsInteger := qtd;
        ParamByName('preco').AsFloat := preco;
        ParamByName('id_venda').AsInteger := id_venda;
        ExecSQL;
      end;
      ShowMessage('Item adicionado com sucesso!');
    end;
  finally
    DataModule1.FDQryProdutos.Close;
    DataModule1.FDQryClientes.Close;
    DataModule1.FDQueryItens.Close;
  end;

end;

procedure TForm1.btnFinalizarVendaClick(Sender: TObject);
begin
  FinalizarVenda;
end;

procedure TForm1.Button2Click(Sender: TObject);
begin
  DataModule1.FDQryVendas.Close;
  DataModule1.FDQryVendas.Open;
  Self.frxReport1.ShowReport;
end;

procedure TForm1.edtCPFClienteKeyPress(Sender: TObject; var Key: Char);
begin
  if Key = #13 then
  begin
    AdicionarDadosCliente(edtCPFCliente.Text, edtNomeCliente.Text);
    ShowMessage('CPF do cliente adicionado com sucesso!');
  end;
end;

procedure TForm1.edtIdProdKeyPress(Sender: TObject; var Key: Char);
begin
  if Key = #13 then
    AdicionarItemVenda
end;

procedure TForm1.edtNomeClienteKeyPress(Sender: TObject; var Key: Char);
begin
  if Key = #13 then
  begin
    AdicionarDadosCliente(edtCPFCliente.Text, edtNomeCliente.Text);
    ShowMessage('Nome do cliente adicionado com sucesso!');
  end;
end;

procedure TForm1.FinalizarVenda;
var
  ClienteID : Integer;
begin
  try
    DataModule1.FDQryClientes.SQL.Text := 'SELECT id FROM clientes WHERE nome = :nome_cliente';
    DataModule1.FDQryClientes.ParamByName('nome_cliente').AsString := edtnomecliente.Text;
    DataModule1.FDQryClientes.Open;

    ClienteId := DataModule1.FDQryClientes.FieldByName('id').AsInteger;

    with DataModule1.FDQueryItens do
    begin
      DataModule1.FDQueryItens.Open;
      DataModule1.FDQueryItens.SQL.Text := 'INSERT INTO vendas (id_cliente, valor_total, data_venda) VALUES (:id_cliente, :valor_total, :data_venda)';
      DataModule1.FDQueryItens.ParamByName('id_cliente').AsInteger := ClienteID;
      DataModule1.FDQueryItens.ParamByName('valor_total').AsFloat := ValorTotalVenda;
      DataModule1.FDQueryItens.ParamByName('data_venda').AsString := DateToStr(Date); // Data atual da venda
      DataModule1.FDQueryItens.ExecSQL;
    end;
    ShowMessage('Venda finalizada com sucesso!');
  finally
    DataModule1.FDQueryItens.Close
  end;
end;

procedure TForm1.FormCreate(Sender: TObject);
begin
  DataModule1.CriarBanco;
end;

function TForm1.ValorTotalVenda: Currency;
// calcula o valor total da venda a partir dos valores dos produtos selecionados no DBGrid
var
  ValorTotal: Double;
  i: Integer;
begin
  ValorTotal := 0;
  for i := 0 to DBGItens.SelectedRows.Count - 1 do
  begin
    DBGItens.DataSource.DataSet.GotoBookmark(DBGItens.SelectedRows[i]);
    ValorTotal := ValorTotal + DBGItens.DataSource.DataSet.FieldByName('preco').AsFloat;
  end;
end;

end.
