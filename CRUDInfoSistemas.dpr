program CRUDInfoSistemas;

uses
  Vcl.Forms,
  ViewClienteForm in 'Views\ViewClienteForm.pas' {CadClientesForm},
  Cliente in 'Commons\Cliente.pas',
  Endereco in 'Commons\Endereco.pas',
  ModelClienteIntf in 'Interfaces\ModelClienteIntf.pas',
  ModelCliente in 'Models\ModelCliente.pas',
  ViewPresenterClienteIntf in 'Interfaces\ViewPresenterClienteIntf.pas',
  PresenterCliente in 'Presenters\PresenterCliente.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TCadClientesForm, CadClientesForm);
  Application.Run;
end.
