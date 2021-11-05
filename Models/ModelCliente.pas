unit ModelCliente;

interface

uses ModelClienteIntf, Cliente, Generics.Collections, Vcl.Dialogs,
  System.SysUtils, System.UITypes, Xml.XMLDoc, Xml.XMLIntf;

type
  TModelCliente = class(TInterfacedObject, IModelCliente)
  private
    FCliente: TCliente;
    FClientes: TList<TCliente>;
    FXMLDoc: TXMLDocument;
    function GetIndex(Id: Integer): Integer;
    function CamposRequeridosPreenchidos: Boolean;
    procedure SalvarXML;
    procedure EnviarCadastroPorEmail;
  protected
    function GetCliente: TCliente;
    procedure SetCliente(Value: TCliente);
  public
    constructor Create;
    function Add: Boolean;
    function Get: TCliente;
    function Update: Boolean;
    procedure Delete;
    function ListAll: TList<TCliente>;
    property Cliente: TCliente read GetCliente write SetCliente;
  end;
implementation

{ TModelCliente }

uses Utils, SendEmailForm;

function TModelCliente.Add: Boolean;
begin
  Result := False;
  Cliente.Id := FClientes.Count + 1;
  if CamposRequeridosPreenchidos then
  begin
    FClientes.Add(Cliente);
    SalvarXML;
    Result := True;
    //Coloquei o envio após confirmada a inclusão do registro,
    //para evitar que problemas no envio atrapalhem a conclusão do cadastro
    EnviarCadastroPorEmail
  end;
end;

function TModelCliente.CamposRequeridosPreenchidos: Boolean;
begin
  Result := False;
  if (Trim(Cliente.Nome) = '') then
  begin
    MessageDlg('O Nome do cliente precisa ser informado.', mtWarning, [mbOk], 0);
    Exit;
  end;
//  if (Trim(Cliente.Identidade = '') then
  if (Trim(Cliente.CPF) = '') then
  begin
    MessageDlg('O campo CPF precisa ser preenchido.', mtWarning, [mbOk], 0);
    Exit;
  end;

  if Not ValidarCPF(Cliente.CPF) then
  begin
    MessageDlg('O CPF é inválido, por favor corrija.', mtWarning, [mbOk], 0);
    Exit;
  end;

  if (Trim(Cliente.Telefone) = '') then
  begin
    MessageDlg('O campo Telefone precisa ser preenchido.', mtWarning, [mbOk], 0);
    Exit;
  end;
  if (Trim(Cliente.Email) = '') then
  begin
    MessageDlg('O campo E-mail precisa ser preenchido.', mtWarning, [mbOk], 0);
    Exit;
  end;
  if (Trim(Cliente.Endereco.CEP) = '') then
  begin
    MessageDlg('O cacmpo CEP precisa ser preenchido.', mtWarning, [mbOk], 0);
    Exit;
  end;
  if (Trim(Cliente.Endereco.Logradouro) = '') then
  begin
    MessageDlg('O campo Logradouro precisa ser preenchido.', mtWarning, [mbOk], 0);
    Exit;
  end;
  if (Trim(Cliente.Endereco.Numero) = '') then
  begin
    MessageDlg('O campo Número precisa ser preenchido.', mtWarning, [mbOk], 0);
    Exit;
  end;
//  if (Trim(Cliente.Endereco.Complemento) = '') then
  if (Trim(Cliente.Endereco.Bairro) = '') then
  begin
    MessageDlg('O campo Bairro precisa ser preenchido.', mtWarning, [mbOk], 0);
    Exit;
  end;
  if (Trim(Cliente.Endereco.Cidade) = '') then
  begin
    MessageDlg('O campo Cidade precisa ser preenchido.', mtWarning, [mbOk], 0);
    Exit;
  end;
  if (Trim(Cliente.Endereco.Estado) = '') then
  begin
    MessageDlg('O campo Estado precisa ser preenchido.', mtWarning, [mbOk], 0);
    Exit;
  end;
  if (Trim(Cliente.Endereco.Pais) = '') then
  begin
    MessageDlg('O campo País precisa ser preenchido.', mtWarning, [mbOk], 0);
    Exit;
  end;
  Result := True;
end;

constructor TModelCliente.Create;
begin
  FCliente := TCliente.Create;
  FClientes := TList<TCliente>.Create;
end;

procedure TModelCliente.Delete;
var
  Index: Integer;
begin
  Index := GetIndex(Cliente.Id);

  if (Index > -1) then
    FClientes.Delete(Index);
end;

procedure TModelCliente.EnviarCadastroPorEmail;
begin
  FormSendMail := TFormSendMail.Create(Nil);
  try
    if FormSendMail.ServidorConfigurado then
      FormSendMail.EnviarEmail(Cliente)
    else
      FormSendMail.Configurar;

  finally
    FreeAndNil(FormSendMail);
  end;
end;

function TModelCliente.Get: TCliente;
var
  Index: Integer;
begin
  Index := GetIndex(Cliente.Id);

  if (Index > -1) then
    Result := FClientes.Items[Index]
  else Result := Nil;
end;

function TModelCliente.GetCliente: TCliente;
begin
  Result :=  FCliente;
end;

function TModelCliente.GetIndex(Id: Integer): Integer;
var
  I, Index: Integer;
begin
  Index := -1;
  for I := 0 to FClientes.Count - 1 do
    if (TCliente(FClientes.Items[I]).id = Id) then
    begin
      Index := I;
      Break;
    end;
  Result := Index;
end;

function TModelCliente.ListAll: TList<TCliente>;
begin
  Result := FClientes;
end;

procedure TModelCliente.SalvarXML;
var
  XMLFileName: String;
  CliNode, EnderNode: IXMLNode;
begin
  FXMLDoc := TXMLDocument.Create(Nil);
  FXMLDoc.Active := False;
  FXMLDoc.Active := True;
  CliNode := FXMLDoc.AddChild('Cliente');
  try
    CliNode.ChildValues['ID'] := Cliente.Id;
    CliNode.ChildValues['Nome'] := Cliente.Nome;
    CliNode.ChildValues['Identidade'] := Cliente.Identidade;
    CliNode.ChildValues['CPF'] := Cliente.CPF;
    CliNode.ChildValues['Telefone'] := Cliente.Telefone;
    CliNode.ChildValues['Email'] := Cliente.Email;

    EnderNode := CliNode.AddChild('Endereco');
    EnderNode.ChildValues['CEP'] := Cliente.Endereco.CEP;
    EnderNode.ChildValues['Logradouro'] := Cliente.Endereco.Logradouro;
    EnderNode.ChildValues['Numero'] := Cliente.Endereco.Numero;
    EnderNode.ChildValues['Complemento'] := Cliente.Endereco.Complemento;
    EnderNode.ChildValues['Bairro'] := Cliente.Endereco.Bairro;
    EnderNode.ChildValues['Cidade'] := Cliente.Endereco.Cidade;
    EnderNode.ChildValues['Estado'] := Cliente.Endereco.Estado;
    EnderNode.ChildValues['Pais'] := Cliente.Endereco.Pais;

    XMLFileName := GetAppDataFolder + FCliente.Id.ToString +'.xml';
    FXMLDoc.FileName := XMLFileName;
    FXMLDoc.SaveToFile(FXMLDoc.FileName);
  finally
    FXMLDoc.Active := False;
    FXMLDoc := Nil;
    FXMLDoc.Free;
  end;
end;

procedure TModelCliente.SetCliente(Value: TCliente);
begin
  FCliente := Value;
end;

function TModelCliente.Update: Boolean;
var
  Index: Integer;
begin
  Result := False;
  Index := GetIndex(Cliente.Id);
  if (Index > -1) then
  begin
    if CamposRequeridosPreenchidos then
    begin
      FClientes.Items[Index] := Cliente;
      Result := True;
    end;
  end;
end;

end.
