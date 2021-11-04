unit ProcurarForm;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.Buttons, Vcl.ComCtrls,
  System.Contnrs;

type
  TFormProcurar = class(TForm)
    lbProcurarPor: TLabel;
    edProcurar: TEdit;
    lvProcurar: TListView;
    btOk: TBitBtn;
    btCancel: TBitBtn;
    procedure lvProcurarDblClick(Sender: TObject);
    procedure lvProcurarKeyPress(Sender: TObject; var Key: Char);
    procedure FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure edProcurarChange(Sender: TObject);
    procedure edProcurarKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure lvProcurarData(Sender: TObject; Item: TListItem);
    procedure btOkClick(Sender: TObject);
  private
    { Private declarations }
    procedure AplicarFiltro(Const Filtro: String);
  public
    { Public declarations }
    Lista: TObjectList;
    ItensListados: TList;
  end;

var
  FormProcurar: TFormProcurar;

implementation

{$R *.dfm}

uses Cliente;

{ TFormProcurar }


procedure TFormProcurar.AplicarFiltro(const Filtro: String);
var
  i: Integer;
begin
  lvProcurar.Items.BeginUpdate;
  try
    lvProcurar.Clear;
    ItensListados.Clear;
    for i := 0 to Lista.Count - 1 do
      if (Filtro = '') or (Pos(UpperCase(Filtro), UpperCase(TCliente(Lista[i]).Nome)) <> 0) then
        ItensListados.Add(Lista[i]);
    lvProcurar.Items.Count := ItensListados.Count;

  finally
    lvProcurar.Items.EndUpdate;
  end;
end;

procedure TFormProcurar.btOkClick(Sender: TObject);
begin
  Close;
  ModalResult := btOk.ModalResult;
end;

procedure TFormProcurar.edProcurarChange(Sender: TObject);
begin
  AplicarFiltro(TEdit(Sender).Text);
end;

procedure TFormProcurar.edProcurarKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if (Key = VK_DOWN)  then
  begin
    Key := 0;
    SelectNext(ActiveControl, True, True);
  end;
end;

procedure TFormProcurar.FormCreate(Sender: TObject);
begin
  Lista := TObjectList.Create;
  ItensListados := TList.Create;
end;

procedure TFormProcurar.FormDestroy(Sender: TObject);
begin
  ItensListados.Free;
end;

procedure TFormProcurar.FormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if (Key = VK_RETURN) then
  begin
    Key := 0;
    SelectNext(ActiveControl, True, True);
  end
  else if (Key = VK_ESCAPE) then
    Close;
end;

procedure TFormProcurar.lvProcurarData(Sender: TObject; Item: TListItem);
var
  Cliente: TCliente;
begin
  //Cliente := TCliente.Create;
  Cliente := TCliente(ItensListados.Items[Item.Index]);
  Item.Caption := Cliente.Nome;
  Item.SubItems.Add(Cliente.Telefone);
  Item.SubItems.Add(Cliente.Endereco.Logradouro);
  Item.SubItems.Add(Cliente.Endereco.Bairro);
end;

procedure TFormProcurar.lvProcurarDblClick(Sender: TObject);
begin
  btOkClick(btOk);
end;

procedure TFormProcurar.lvProcurarKeyPress(Sender: TObject; var Key: Char);
begin
  if (Key = #13) and (lvProcurar.Selected.Selected) then
    Self.Close;
end;

end.
