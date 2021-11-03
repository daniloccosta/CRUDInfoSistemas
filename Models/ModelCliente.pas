unit ModelCliente;

interface

uses ModelClienteIntf, Cliente, Generics.Collections;

type
  TModelCliente = class(TInterfacedObject, IModelCliente)
  private
    FCliente: TCliente;
    FClientes: TList<TCliente>;
    function GetIndex(Id: Integer): Integer;
  protected
    function GetCliente: TCliente;
    procedure SetCliente(Value: TCliente);
  public
    constructor Create;
    procedure Add;
    function Get: TCliente;
    procedure Update;
    procedure Delete;
    function ListAll: TList<TCliente>;
    property Cliente: TCliente read GetCliente write SetCliente;
  end;
implementation

{ TModelCliente }

procedure TModelCliente.Add;
begin
  FClientes.Add(Cliente);
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

procedure TModelCliente.SetCliente(Value: TCliente);
begin
  FCliente := Value;
end;

procedure TModelCliente.Update;
var
  Index: Integer;
begin
  Index := GetIndex(Cliente.Id);
  if (Index > -1) then
    FClientes.Items[Index] := Cliente;
end;

end.
