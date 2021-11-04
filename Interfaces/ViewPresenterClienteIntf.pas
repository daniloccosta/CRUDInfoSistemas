unit ViewPresenterClienteIntf;

interface

uses Cliente, ModelClienteIntf, Generics.Collections, Controls;

type
  IPresenterCliente = interface;

  IViewCliente = interface
    ['{48C59298-FD39-4D65-A6AB-388F08E2D56E}']
    function GetCliente: TCliente;
    procedure SetCliente(Value: TCliente);
    function GetPresenter: IPresenterCliente;
    procedure SetPresenter(const Value: IPresenterCliente);

    function ShowView: TModalResult;
    property Cliente: TCliente read GetCliente write SetCliente;
    property Presenter: IPresenterCliente read GetPresenter write SetPresenter;
  end;

  IPresenterCliente = interface
    ['{F1E68F94-398C-492B-9CE8-8977A0ECCE8D}']
    function GetModel: IModelCliente;
    procedure SetModel(const Value: IModelCliente);
    function GetView: IViewCliente;
    procedure SetView(const Value: IViewCliente);

    function Add: Boolean;
    function Get: TCliente;
    function Update: Boolean;
    procedure Delete;
    function ListAll: TList<TCliente>;

    property Model: IModelCliente read GetModel write SetModel;
    property View: IViewCliente read GetView write SetView;
  end;

implementation

end.
