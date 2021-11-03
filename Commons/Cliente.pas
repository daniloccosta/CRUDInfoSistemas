unit Cliente;

interface

uses Endereco;

type
  TCliente = class
  private
    FId: Integer;
    FNome: String;
    FIdentidade: String;
    FCPF: String;
    FTelefone: String;
    FEmail: String;
    FEndereco: TEndereco;
  protected
    function GetId: Integer;
    procedure SetId(Value: Integer);
    function GetNome: String;
    procedure SetNome(Value: String);
    function GetIdentidade: String;
    procedure SetIdentidade(Value: String);
    function GetCPF: String;
    procedure SetCPF(Value: String);
    function GetTelefone: String;
    procedure SetTelefone(Value: String);
    function GetEmail: String;
    procedure SetEmail(Value: String);
    function GetEndereco: TEndereco;
    procedure SetEndereco(Value: TEndereco);
  public
    property Id: Integer read GetId write SetId;
    property Nome: String read GetNome write SetNome;
    property Identidade: String read GetIdentidade write SetIdentidade;
    property CPF: String read GetCPF write SetCPF;
    property Telefone: String read GetTelefone write SetTelefone;
    property Email: String read GetEmail write SetEmail;
    property Endereco: TEndereco read GetEndereco write SetEndereco;
  end;

implementation

{ TCliente }

function TCliente.GetCPF: String;
begin
  Result := FCPF;
end;

function TCliente.GetEmail: String;
begin
  Result := FEmail;
end;

function TCliente.GetEndereco: TEndereco;
begin
  Result := FEndereco;
end;

function TCliente.GetId: Integer;
begin
  Result := FId;
end;

function TCliente.GetIdentidade: String;
begin
  Result := FIdentidade;
end;

function TCliente.GetNome: String;
begin
  Result := FNome;
end;

function TCliente.GetTelefone: String;
begin
  Result := FTelefone;
end;

procedure TCliente.SetCPF(Value: String);
begin
  FCPF := Value;
end;

procedure TCliente.SetEmail(Value: String);
begin
  FEmail := Value;
end;

procedure TCliente.SetEndereco(Value: TEndereco);
begin
  FEndereco := Value;
end;

procedure TCliente.SetId(Value: Integer);
begin
  FId := Value;
end;

procedure TCliente.SetIdentidade(Value: String);
begin
  FIdentidade := Value;
end;

procedure TCliente.SetNome(Value: String);
begin
  FNome := Value;
end;

procedure TCliente.SetTelefone(Value: String);
begin
  FTelefone := Value;
end;

end.
