unit ModelClienteIntf;

interface

uses Cliente, Generics.Collections;

type
  IModelCliente = interface
    ['{CDB069C6-31CB-4F4E-8C0F-07DC1F985BC2}']
    function GetCliente: TCliente;
    procedure SetCliente(Value: TCliente);
    procedure Add;
    function Get: TCliente;
    procedure Update;
    procedure Delete;
    function ListAll: TList<TCliente>;
    property Cliente: TCliente read GetCliente write SetCliente;
  end;

implementation

end.
