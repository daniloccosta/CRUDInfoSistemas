unit PresenterCliente;

interface

uses ViewPresenterClienteIntf, ModelClienteIntf, Cliente, Generics.Collections;

type
  TPresenterCliente = class(TInterfacedObject, IPresenterCliente)
  private
    FModel: IModelCliente;
    FView: IViewCliente;
  protected
    function GetModel: IModelCliente;
    procedure SetModel(const Value: IModelCliente);
    function GetView: IViewCliente;
    procedure SetView(const Value: IViewCliente);
  public
    procedure Add;
    function Get: TCliente;
    procedure Update;
    procedure Delete;
    function ListAll: TList<TCliente>;

    property Model: IModelCliente read GetModel write SetModel;
    property View: IViewCliente read GetView write SetView;
  end;

implementation

{ TPresenterCliente }

procedure TPresenterCliente.Add;
begin
  Model.Cliente := View.Cliente;
  Model.Add;
  //Inicializa novo cliente na View
  View.Cliente := TCliente.Create;
end;

procedure TPresenterCliente.Delete;
begin
  Model.Cliente := View.Cliente;
  Model.Delete;
end;

function TPresenterCliente.Get: TCliente;
begin
  Model.Cliente := View.Cliente;
  Result := Model.Get;
end;

function TPresenterCliente.GetModel: IModelCliente;
begin
  Result := FModel;
end;

function TPresenterCliente.GetView: IViewCliente;
begin
  Result := FView;
end;

function TPresenterCliente.ListAll: TList<TCliente>;
begin
  Result := Model.ListAll;
end;

procedure TPresenterCliente.SetModel(const Value: IModelCliente);
begin
  FModel := Value;
end;

procedure TPresenterCliente.SetView(const Value: IViewCliente);
begin
  FView := Value;
end;

procedure TPresenterCliente.Update;
begin
  Model.Cliente := View.Cliente;
  Model.Update;
end;

end.
