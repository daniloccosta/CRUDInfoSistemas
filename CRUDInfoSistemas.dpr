program CRUDInfoSistemas;

uses
  Vcl.Forms,
  ViewClienteForm in 'Views\ViewClienteForm.pas' {CadClientesForm},
  Cliente in 'Commons\Cliente.pas',
  Endereco in 'Commons\Endereco.pas',
  ModelClienteIntf in 'Interfaces\ModelClienteIntf.pas',
  ModelCliente in 'Models\ModelCliente.pas',
  ViewPresenterClienteIntf in 'Interfaces\ViewPresenterClienteIntf.pas',
  PresenterCliente in 'Presenters\PresenterCliente.pas',
  ProcurarForm in 'Commons\ProcurarForm.pas' {FormProcurar},
  Utils in 'Commons\Utils.pas',
  ViaCEP.Model in 'ViaCEP\ViaCEP.Model.pas',
  ViaCEP.Intf in 'ViaCEP\ViaCEP.Intf.pas',
  ViaCEP.Core in 'ViaCEP\ViaCEP.Core.pas',
  SendEmailForm in 'Views\SendEmailForm.pas' {FormSendMail};

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TCadClientesForm, CadClientesForm);
  Application.Run;
end.
