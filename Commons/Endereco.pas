unit Endereco;

interface

type
  TEndereco = class
  private
    FCEP: String;
    FLogradouro: String;
    FNumero: String;
    FComplemento: String;
    FBairro: String;
    FCidade: String;
    FEstado: String;
    FPais: String;
  protected
    function GetCEP: String;
    procedure SetCEP(Value: String);
    function GetLogradouro: String;
    procedure SetLogradouro(Value: String);
    function GetNumero: String;
    procedure SetNumero(Value: String);
    function GetComplemento: String;
    procedure SetComplemento(Value: String);
    function GetBairro: String;
    procedure SetBairro(Value: String);
    function GetCidade: String;
    procedure SetCidade(Value: String);
    function GetEstado: String;
    procedure SetEstado(Value: String);
    function GetPais: String;
    procedure SetPais(Value: String);
  public
    property CEP: String read GetCEP write SetCEP;
    property Logradouro: String read GetLogradouro write SetLogradouro;
    property Numero: String read GetNumero write SetNumero;
    property Complemento: String read GetComplemento write SetComplemento;
    property Bairro: String read GetBairro write SetBairro;
    property Cidade: String read GetCidade write SetCidade;
    property Estado: String read GetEstado write SetEstado;
    property Pais: String read GetPais write SetPais;
  end;

implementation

{ TEndereco }

function TEndereco.GetBairro: String;
begin
  Result := FBairro;
end;

function TEndereco.GetCEP: String;
begin
  Result := FCEP;
end;

function TEndereco.GetCidade: String;
begin
  Result := FCidade;
end;

function TEndereco.GetComplemento: String;
begin
  Result := FComplemento;
end;

function TEndereco.GetEstado: String;
begin
  Result := FEstado;
end;

function TEndereco.GetLogradouro: String;
begin
  Result := FLogradouro;
end;

function TEndereco.GetNumero: String;
begin
  Result := FNumero;
end;

function TEndereco.GetPais: String;
begin
  Result := FPais;
end;

procedure TEndereco.SetBairro(Value: String);
begin
  FBairro := Value;
end;

procedure TEndereco.SetCEP(Value: String);
begin
  FCEP := Value;
end;

procedure TEndereco.SetCidade(Value: String);
begin
  FCidade := Value;
end;

procedure TEndereco.SetComplemento(Value: String);
begin
  FComplemento := Value;
end;

procedure TEndereco.SetEstado(Value: String);
begin
  FEstado := Value;
end;

procedure TEndereco.SetLogradouro(Value: String);
begin
  FLogradouro := Value;
end;

procedure TEndereco.SetNumero(Value: String);
begin
  FNumero := Value;
end;

procedure TEndereco.SetPais(Value: String);
begin
  FPais := Value;
end;

end.
