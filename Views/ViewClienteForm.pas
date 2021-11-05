unit ViewClienteForm;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes,
  System.UITypes, Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.Dialogs,
  ViewPresenterClienteIntf, Cliente, PresenterCliente, Generics.Collections,
  ModelClienteIntf, Vcl.StdCtrls, Vcl.Mask, Vcl.Buttons, System.ImageList,
  Vcl.ImgList, System.Actions, Vcl.ActnList, System.Contnrs, System.Math, Vcl.ComCtrls,
  Utils;

type
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
    procedure edCEPExit(Sender: TObject);
    procedure FormShow(Sender: TObject);
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
    function GravarDados: Boolean;
    function Procurar(Lista: TObjectList; Colunas: TListColumns): TCliente;
    procedure CarregarDadosCliente;
    procedure BuscarCEP;
    procedure AdicionarDadosTeste;
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

uses ModelCliente, ProcurarForm, ViaCEP.Model, ViaCEP.Intf, ViaCEP.Core,
  SendEmailForm;

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

  //Verifica se os dados foram gravados.
  if GravarDados then
  begin
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

  //Instancia novo cliente
  FCliente := TCliente.Create;

  edNome.SetFocus;
end;

procedure TCadClientesForm.acProcurarExecute(Sender: TObject);
var
  Lista: TListView;
  Column: TListColumn;
  Retorno: TCliente;
  ListaDeClientes: TObjectList;
  i: Integer;
begin
  //verifica o estado da tela antes de executar a rotina
  if Not (EstadoTela in [eInativo, eVisualizando]) then
    Exit;

  Lista := TListView.Create(Self);
  ListaDeClientes := TObjectList.Create;
  try
    Lista.Parent := Self;
    Lista.Visible := False;

    //Carregando ListColumns
    Lista.Columns.Clear;
    Column := Lista.Columns.Add;
    Column.Caption := 'Nome';
    Column.Width := 130;
    Column := Lista.Columns.Add;
    Column.Caption := 'Telefone';
    Column.Width := 90;
    Column := Lista.Columns.Add;
    Column.Caption := 'Logradouro';
    Column.Width := 130;
    Column.Caption := 'Bairro';
    Column.Width := 90;

    //Carrega lista de clientes
    FClientes := Presenter.ListAll;
    for i := 0 to FClientes.Count - 1 do
    begin
      ListaDeClientes.Add(FClientes.Items[i]);
    end;

    //Chama tela de Procura
    Retorno := Procurar(ListaDeClientes, Lista.Columns);
    if (Retorno <> nil) then
    begin
      //Carrega dados do cliente na tela
      Cliente := Retorno;
      CarregarDadosCliente;

      //Atualiza o estado da tela
      EstadoTela := eVisualizando;
      HabilitaBotoes;
    end;
  finally
    FreeAndNil(Lista);
    //FreeAndNil(ListaDeClientes);
    //FreeAndNil(Cli);
  end;
end;

procedure TCadClientesForm.AdicionarDadosTeste;
begin
  //Instancia novo cliente
  FCliente := TCliente.Create;

  //Preenche os dados
  Cliente.Nome := 'ARI TOLEDO';
  Cliente.Identidade := '5241236';
  Cliente.CPF := '48528910873';
  Cliente.Telefone := '11123456789';
  Cliente.Email := 'aritoledo@gmail.com';
  Cliente.Endereco.CEP := '11222345';
  Cliente.Endereco.Logradouro := 'RUA TARARA';
  Cliente.Endereco.Numero := '100';
  Cliente.Endereco.Complemento := '';
  Cliente.Endereco.Bairro := 'CENTRO';
  Cliente.Endereco.Cidade := 'ITAQUAQUECETUBA';
  Cliente.Endereco.Estado := 'SP';
  Cliente.Endereco.Pais := 'BRASIL';

  //Adiciona
  Presenter.Add;

  //Instancia novo cliente
  FCliente := TCliente.Create;

  //Preenche os dados
  Cliente.Nome := 'SÔNIA LIMA';
  Cliente.Identidade := '54687965';
  Cliente.CPF := '02789435006';
  Cliente.Telefone := '71985215138';
  Cliente.Email := 'sonialima@gmail.com';
  Cliente.Endereco.CEP := '11222345';
  Cliente.Endereco.Logradouro := 'RUA BABEBIBOBU';
  Cliente.Endereco.Numero := '1054';
  Cliente.Endereco.Complemento := '';
  Cliente.Endereco.Bairro := 'CENTRO';
  Cliente.Endereco.Cidade := 'PINDAMONHANGABA';
  Cliente.Endereco.Estado := 'SP';
  Cliente.Endereco.Pais := 'BRASIL';

  //Adiciona
  Presenter.Add;
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

procedure TCadClientesForm.BuscarCEP;
var
  ViaCEP: IViaCEP;
  CEP: TViaCEPClass;
  SaveCursor: TCursor;
begin
  ViaCEP := TViaCEP.Create;
  if ViaCEP.Validate(edCEP.Text) then
  begin
    SaveCursor := Self.Cursor;
    try
      Self.Cursor := crHourGlass;
      CEP := ViaCEP.Get(edCEP.Text);
    finally
      Self.Cursor := SaveCursor;
    end;


    if Not Assigned(CEP) then
    begin
      MessageDlg('CEP não localizado.', mtINformation, [mbOk], 0);
      Exit;
    end;
    try
      edLogradouro.Text := CEP.Logradouro;
      edComplemento.Text := CEP.Complemento;
      edBairro.Text := CEP.Bairro;
      edCidade.Text := CEP.Localidade;
      cbEstados.ItemIndex := cbEstados.Items.IndexOf(CEP.UF);
    finally
      CEP.Free;
    end;
  end;
end;

procedure TCadClientesForm.CarregarDadosCliente;
begin
  edNome.Text := Cliente.Nome;
  edIdentidade.Text := Cliente.Identidade;
  edCPF.Text := Cliente.CPF;
  edTelefone.Text := Cliente.Telefone;
  edEmail.Text := Cliente.Email;
  edCEP.Text := Cliente.Endereco.CEP;
  edLogradouro.Text := Cliente.Endereco.Logradouro;
  edNumero.Text := Cliente.Endereco.Numero;
  edComplemento.Text := Cliente.Endereco.Complemento;
  edBairro.Text := Cliente.Endereco.Bairro;
  edCidade.Text := Cliente.Endereco.Cidade;
  cbEstados.ItemIndex := cbEstados.Items.IndexOf(Cliente.Endereco.Estado);
  edPais.Text := Cliente.Endereco.Pais;
end;

procedure TCadClientesForm.edCEPExit(Sender: TObject);
begin
  if (EstadoTela in [eInserindo, eAlterando]) then
    BuscarCEP;
end;

procedure TCadClientesForm.FormCreate(Sender: TObject);
var
  AppFolder: String;
begin
  //Criar pasta para o programa, se não existir!
  AppFolder := GetAppDataFolder;
  if Not DirectoryExists(AppFolder) then
    ForceDirectories(AppFolder);

  //Instancia objetos
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

procedure TCadClientesForm.FormShow(Sender: TObject);
begin
  //Configurar Serviço de envio de e-mails
  FormSendMail := TFormSendMail.Create(Nil);
  try
    if Not FormSendMail.ServidorConfigurado then
      FormSendMail.Configurar;

  finally
    FreeAndNil(FormSendMail);
  end;

  //Adicionar dados de testes
  AdicionarDadosTeste;
end;

function TCadClientesForm.GetCliente: TCliente;
begin
  Result  := FCliente;
end;

function TCadClientesForm.GetPresenter: IPresenterCliente;
begin
  Result := FPresenter;
end;

function TCadClientesForm.GravarDados: Boolean;
begin
  //Instanciar novo cliente, somente se estiver inserindo
//  if (EstadoTela = eInserindo) then
//    FCliente := TCliente.Create;
// CÓDIGO ACIMA MOVIDO PARA ACNOVO.ONEXECUTE

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

  if (EstadoTela = eInserindo) then
    Result := Presenter.Add
  else Result := Presenter.Update;
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

function TCadClientesForm.Procurar(Lista: TObjectList;
  Colunas: TListColumns): TCliente;
var
  i: Integer;
  mr: TModalResult;
begin
  FormProcurar := TFormProcurar.Create(Nil);
  FormProcurar.Lista := Lista;
  FormProcurar.lvProcurar.Columns := Colunas;
  mr := FormProcurar.ShowModal;

  if (FormProcurar.lvProcurar.Selected = Nil)
  or (Lista.Count = 0) or (mr <> mrOk) then
    Result := nil
  else begin
    i := FormProcurar.lvProcurar.Selected.Index;
    Result := TCliente(FormProcurar.ItensListados[i]);
  end;

  FreeAndNil(FormProcurar);
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
