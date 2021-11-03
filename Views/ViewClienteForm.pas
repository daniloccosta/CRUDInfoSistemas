unit ViewClienteForm;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes,
  System.UITypes, Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.Dialogs,
  ViewPresenterClienteIntf, Cliente, PresenterCliente, Generics.Collections,
  ModelClienteIntf, Vcl.StdCtrls, Vcl.Mask, Vcl.Buttons, System.ImageList,
  Vcl.ImgList, System.Actions, Vcl.ActnList;

type
  TEstadosTela = (eVisualizando, eInserindo, eAlterando, eInativo);
  TCadClientesForm = class(TForm, IViewCliente)
    Label1: TLabel;
    edNome: TEdit;
    Label2: TLabel;
    edIdentidade: TEdit;
    Label3: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    edEmail: TEdit;
    Label6: TLabel;
    Label7: TLabel;
    edLogradouro: TEdit;
    Label8: TLabel;
    edNumero: TEdit;
    Label9: TLabel;
    edComplemento: TEdit;
    Label10: TLabel;
    edBairro: TEdit;
    Label11: TLabel;
    edCidade: TEdit;
    Label12: TLabel;
    Label13: TLabel;
    edPais: TEdit;
    edCPF: TMaskEdit;
    edTelefone: TMaskEdit;
    cbEstados: TComboBox;
    edCEP: TMaskEdit;
    btNovo: TBitBtn;
    btGravar: TBitBtn;
    btExcluir: TBitBtn;
    btFechar: TBitBtn;
    ActionList1: TActionList;
    ImageList1: TImageList;
    acNovo: TAction;
    acGravar: TAction;
    acExcluir: TAction;
    acFechar: TAction;
    btProcurar: TBitBtn;
    acProcurar: TAction;
    btAlterar: TBitBtn;
    btCancelar: TBitBtn;
    acAlterar: TAction;
    acCancelar: TAction;
    procedure FormCreate(Sender: TObject);
    procedure FormKeyPress(Sender: TObject; var Key: Char);
    procedure acNovoExecute(Sender: TObject);
    procedure acAlterarExecute(Sender: TObject);
    procedure acGravarExecute(Sender: TObject);
    procedure acCancelarExecute(Sender: TObject);
    procedure acExcluirExecute(Sender: TObject);
    procedure acProcurarExecute(Sender: TObject);
    procedure acFecharExecute(Sender: TObject);
  private
    { Private declarations }
    FCliente: TCliente;
    FClientes: TList<TCliente>;
    FPresenter: IPresenterCliente;
    FModel: IModelCliente;
    EstadoTela: TEstadosTela;
    function GetCliente: TCliente;
    procedure SetCliente(Value: TCliente);
    function GetPresenter: IPresenterCliente;
    procedure SetPresenter(const Value: IPresenterCliente);
    // ******************* //
    procedure IniciliazarMVP;
    procedure HabilitaBotoes;
    procedure LimparTela;
    procedure BloquearTelaParaEdicao(const Bloqueio: Boolean);
    function CamposPreenchidos: Boolean;
    procedure GravarDados;
  public
    { Public declarations }
    function ShowView: TModalResult;
    property Cliente: TCliente read GetCliente write SetCliente;
    property Presenter: IPresenterCliente read GetPresenter write SetPresenter;
    // ******************* //
  end;

var
  CadClientesForm: TCadClientesForm;

implementation

{$R *.dfm}

uses ModelCliente;

{ TCadClientesForm }

procedure TCadClientesForm.acAlterarExecute(Sender: TObject);
begin
  //Atualiza o estado da tela
  EstadoTela := eAlterando;
  HabilitaBotoes;

  //Desbloqueia tela, permitindo a edição do registro aberto
  BloquearTelaParaEdicao(False);

  edNome.SetFocus;
end;

procedure TCadClientesForm.acCancelarExecute(Sender: TObject);
begin
  //Verifica se o estado da tela permite a execução da rotina
  if Not (EstadoTela in [eInserindo, eAlterando]) then
    Exit;

  //Limpa a tela
  LimparTela;

  //bloqueia campos para digitação
  BloquearTelaParaEdicao(True);

  //Atualiza o estado da tela
  EstadoTela := eInativo;
  HabilitaBotoes;
end;

procedure TCadClientesForm.acExcluirExecute(Sender: TObject);
begin
  //Verifica se o estado da tela permite a execução da rotina
  if Not (EstadoTela in [eVisualizando]) then
    Exit;

  //Exclui registro
  if MessageDlg('Confirma a exclusão?', mtConfirmation, [mbYes, mbNo], 0) = mrYes then
    Presenter.Delete;

  //Limpa a tela
  LimparTela;

  //bloqueia campos para digitação
  BloquearTelaParaEdicao(True);

  //Atualiza o estado da tela
  EstadoTela := eInativo;
  HabilitaBotoes;
end;

procedure TCadClientesForm.acFecharExecute(Sender: TObject);
begin
  //Verifica se o estado da tela permite a execução da rotina
  if (EstadoTela in [eVisualizando, eInativo]) then
    Close;
end;

procedure TCadClientesForm.acGravarExecute(Sender: TObject);
begin
  //verifica o estado da tela antes de executar a rotina
  if Not (EstadoTela in [eInserindo, eAlterando]) then
    Exit;

  //Verifica se os campos estão preenchidos. Se ok, salva.
  if CamposPreenchidos then
  begin
    GravarDados;

    //Limpa tela
    LimparTela;

    //Bloqueia os campos para digitação
    BloquearTelaParaEdicao(True);

    //Após gravar os dados, atualiza o estado da tela
    EstadoTela := eInativo;
    HabilitaBotoes;
  end;
end;

procedure TCadClientesForm.acNovoExecute(Sender: TObject);
begin
  //Atualiza estado da tela
  EstadoTela := eInserindo;
  HabilitaBotoes;

  //Desbloqueia tela, permitindo a inserção de um novo registro
  BloquearTelaParaEdicao(False);

  //Limpa os campos da tela
  LimparTela;

  edNome.SetFocus;
end;

procedure TCadClientesForm.acProcurarExecute(Sender: TObject);
begin
  //
end;

procedure TCadClientesForm.BloquearTelaParaEdicao(const Bloqueio: Boolean);
var
  i: Integer;
begin
  for i := 0 to Self.ComponentCount - 1 do
  begin
    if (Components[i].ClassType = TEdit)
    or (Components[i].ClassType = TMaskEdit)then
      TEdit(Components[i]).ReadOnly := Bloqueio;
  end;
  cbEstados.Enabled := Not Bloqueio;
end;

function TCadClientesForm.CamposPreenchidos: Boolean;
var
  i: Integer;
begin
  Result := True;

  //Componentes com tag = 1 são de preenchimento obrigatório
  //Todas as labels devem estar com o FocusControl corretamente configurado
  for i := 0 to Self.ComponentCount - 1 do
  begin
    if (Components[i].ClassType = TLabel) then
      if (TLabel(Components[i]).Tag = 1) then
      begin
        if (TLabel(Components[i]).FocusControl.ClassType = TEdit)
        or (TLabel(Components[i]).FocusControl.ClassType = TMaskEdit) then
        begin
          if (Trim(TEdit(TLabel(Components[i]).FocusControl).Text) = '') then
          begin
            MessageDlg('O campo "'+ TLabel(Components[i]).Caption +'" deve ser preenchido.',
              mtWarning, [mbOk], 0);
            TEdit(TLabel(Components[i]).FocusControl).SetFocus;
            Result := False;
            Break;
          end;
        end
        else if (TLabel(Components[i]).FocusControl.ClassType = TComboBox) then
          if (TComboBox(TLabel(Components[i]).FocusControl).ItemIndex = -1) then
          begin
            MessageDlg('O campo "'+ TLabel(Components[i]).Caption +'" deve ser preenchido.',
              mtWarning, [mbOk], 0);
            TComboBox(TLabel(Components[i]).FocusControl).SetFocus;
            Result := False;
            Break;
          end;

      end;
  end;
end;

procedure TCadClientesForm.FormCreate(Sender: TObject);
begin
  FCliente := TCliente.Create;
  FClientes := TList<TCliente>.Create;

  IniciliazarMVP;

  ///Bloqueia campos para digitação
  BloquearTelaParaEdicao(True);

  //Atualiza o estado da tela
  EstadoTela := eInativo;
  HabilitaBotoes;
end;

procedure TCadClientesForm.FormKeyPress(Sender: TObject; var Key: Char);
begin
  if (Key = #13) then
  begin
    Key := #0;
    SelectNext(ActiveControl, True, True);
  end;
end;

function TCadClientesForm.GetCliente: TCliente;
begin
  Result  := FCliente;
end;

function TCadClientesForm.GetPresenter: IPresenterCliente;
begin
  Result := FPresenter;
end;

procedure TCadClientesForm.GravarDados;
begin
  FCliente := TCliente.Create;

  Cliente.Nome := Trim(edNome.Text);
  Cliente.Identidade := Trim(edIdentidade.Text);
  Cliente.CPF := Trim(edCPF.Text);
  Cliente.Telefone := Trim(edTelefone.Text);
  Cliente.Email := Trim(edEmail.Text);
  Cliente.Endereco.CEP := Trim(edCEP.Text);
  Cliente.Endereco.Logradouro := Trim(edLogradouro.Text);
  Cliente.Endereco.Numero := Trim(edNumero.Text);
  Cliente.Endereco.Complemento := Trim(edComplemento.Text);
  Cliente.Endereco.Bairro := Trim(edBairro.Text);
  Cliente.Endereco.Cidade := Trim(edCidade.Text);
  Cliente.Endereco.Estado := cbEstados.Text;
  Cliente.Endereco.Pais := Trim(edPais.Text);

  Presenter.Add;
end;

procedure TCadClientesForm.HabilitaBotoes;
begin
  acNovo.Enabled := (EstadoTela in [eVisualizando, eInativo]);
  acAlterar.Enabled := (EstadoTela = eVisualizando);
  acGravar.Enabled := (EstadoTela in [eInserindo, eAlterando]);
  acCancelar.Enabled := acGravar.Enabled;
  acExcluir.Enabled := (EstadoTela = eVisualizando);
  acProcurar.Enabled := (EstadoTela in [eVisualizando, eInativo]);
  acFechar.Enabled := (EstadoTela in [eVisualizando, eInativo]);
end;

procedure TCadClientesForm.IniciliazarMVP;
begin
  FModel := TModelCliente.Create;
  Presenter := TPresenterCliente.Create;

  Presenter.Model := FModel;
  Presenter.View := Self;

  //Self.Presenter := Presenter; //<< Sem sentido isso!!!!
end;

procedure TCadClientesForm.LimparTela;
var
  i: Integer;
begin
  for i := 0 to Self.ComponentCount - 1 do
  begin
    if (Components[i].ClassType = TEdit) then
      TEdit(Components[i]).Text := ''
    else if (Components[i].ClassType = TMaskEdit)then
      TMaskEdit(Components[i]).Text := '';
  end;
  cbEstados.ItemIndex := -1;
end;

procedure TCadClientesForm.SetCliente(Value: TCliente);
begin
  FCliente := Value;
end;

procedure TCadClientesForm.SetPresenter(const Value: IPresenterCliente);
begin
  FPresenter := Value;
end;

function TCadClientesForm.ShowView: TModalResult;
begin
  Result := Self.ShowModal;
end;

end.
