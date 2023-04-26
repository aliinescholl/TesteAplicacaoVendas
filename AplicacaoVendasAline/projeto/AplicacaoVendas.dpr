program AplicacaoVendas;

uses
  Vcl.Forms,
  UfrmPrincipal in '..\src\forms\UfrmPrincipal.pas' {Form1},
  UdmModeloBanco in '..\src\model\UdmModeloBanco.pas' {DataModule1: TDataModule};

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TForm1, Form1);
  Application.CreateForm(TDataModule1, DataModule1);
  Application.Run;
end.
