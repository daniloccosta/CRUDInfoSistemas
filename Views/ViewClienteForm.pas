unit ViewClienteForm;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, ViewPresenterClienteIntf, Cliente,
  Generics.Collections, ModelClienteIntf, Vcl.StdCtrls, Vcl.Mask, Vcl.Buttons;

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
    BitBtn1: TBitBtn;
    BitBtn2: TBitBtn;
    BitBtn3: TBitBtn;
    procedure FormCreate(Sender: TObject);
  private
    { Private declarations }
    FCliente: TCliente;
    FClientes: TList<TCliente>;
    FPresenter: Pointer;
    FModel: IModelCliente;
    function GetCliente: TCliente;
    procedure SetCliente(Value: TCliente);
    function GetPresenter: IPresenterCliente;
    procedure SetPresenter(const Value: IPresenterCliente);
    // ******************* //
    procedure IniciliazarMVP;
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

uses ModelCliente, PresenterCliente;

{ TCadClientesForm }

procedure TCadClientesForm.FormCreate(Sender: TObject);
begin
  FCliente := TCliente.Create;
  FClientes := TList<TCliente>.Create;

  IniciliazarMVP;
end;

function TCadClientesForm.GetCliente: TCliente;
begin
  Result  := FCliente;
end;

function TCadClientesForm.GetPresenter: IPresenterCliente;
begin
  Result := IPresenterCliente(FPresenter);
end;

procedure TCadClientesForm.IniciliazarMVP;
begin
  FModel := TModelCliente.Create;
  Presenter := TPresenterCliente.Create;

  Presenter.Model := FModel;
  Presenter.View := Self;

  //Self.Presenter := Presenter; //<< Sem sentido isso!!!!
end;

procedure TCadClientesForm.SetCliente(Value: TCliente);
begin
  FCliente := Value;
end;

procedure TCadClientesForm.SetPresenter(const Value: IPresenterCliente);
begin
  FPresenter := Pointer(Value);
end;

function TCadClientesForm.ShowView: TModalResult;
begin
  Result := Self.ShowModal;
end;

end.
