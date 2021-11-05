unit SendEmailForm;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes,
  System.UITypes, Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls,
  IdIOHandler, IdIOHandlerSocket, IdIOHandlerStack, IdSSL, IdSSLOpenSSL, IdMessage,
  IdBaseComponent, IdComponent, IdTCPConnection, IdTCPClient,
  IdExplicitTLSClientServerBase, IdMessageClient, IdSMTPBase, IdSMTP,
  Vcl.Buttons, Cliente, IdAttachment, IdAttachmentFile, IdText;

type
  TFormSendMail = class(TForm)
    Label1: TLabel;
    IdSMTP: TIdSMTP;
    IdMessage: TIdMessage;
    IdSSLIOHandlerSocket: TIdSSLIOHandlerSocketOpenSSL;
    edFrom: TEdit;
    Label2: TLabel;
    edHost: TEdit;
    Label3: TLabel;
    edPort: TEdit;
    Label4: TLabel;
    edUsername: TEdit;
    Label5: TLabel;
    edPassword: TEdit;
    btGravar: TBitBtn;
    ckRequeAuth: TCheckBox;
    ckSSL: TCheckBox;
    procedure FormKeyPress(Sender: TObject; var Key: Char);
    procedure edPortKeyPress(Sender: TObject; var Key: Char);
    procedure FormCreate(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
  private
    { Private declarations }
    procedure ConfigServerMail;
    procedure GravarConfiguracao;
  public
    { Public declarations }
    function ServidorConfigurado: Boolean;
    procedure Configurar;
    function EnviarEmail(Cliente: TCliente): Boolean;
  end;

var
  FormSendMail: TFormSendMail;

implementation

{$R *.dfm}

uses Utils, IniFiles, IdMessageParts;

{ TFormSendMail }

procedure TFormSendMail.ConfigServerMail;
var
  IniFIle: TInifile;
  FileName: String;
  MailFrom: String;
  RequerAuth: Boolean;
  UsaSSL: Boolean;
begin
  FileName := GetAppDataFolder + 'config.ini';
  IniFile := TIniFile.Create(FileName);
  try
    MailFrom := IniFile.ReadString('Email', 'From', '');
    IdSMTP.Host := IniFile.ReadString('Email', 'Host', '');
    IdSMTP.Port := IniFile.ReadInteger('Email', 'Port', 587);
    RequerAuth := IniFile.ReadBool('Email', 'Autenticado', False);
    UsaSSL := IniFile.ReadBool('Email', 'SSL', False);
    IdSMTP.Username := IniFile.ReadString('Email', 'UserName', '');
    IdSMTP.Password := IniFile.ReadString('Email', 'Password', '');
  finally
    IniFile.Free;
  end;
  //Identificação do Remetente
  IdMessage.From.Address := MailFrom;

  // Configuração do protocolo SSL (TIdSSLIOHandlerSocketOpenSSL)
  IdSSLIOHandlerSocket.SSLOptions.Method := sslvSSLv23;
  IdSSLIOHandlerSocket.SSLOptions.Mode := sslmClient;

  // Configuração do servidor SMTP (TIdSMTP)
  IdSMTP.UseTLS := utNoTLSSupport;
  if UsaSSL then
  begin
    IdSMTP.IOHandler := IdSSLIOHandlerSocket;
    IdSMTP.UseTLS := utUseImplicitTLS;
  end
  else
    IdSMTP.IOHandler := Nil;
  if RequerAuth then
    IdSMTP.AuthType := satDefault
  else
    IdSMTP.AuthType := satNone;
end;

procedure TFormSendMail.Configurar;
begin
  if (Self.ShowModal = mrOk) then
    ConfigServerMail;
end;

procedure TFormSendMail.edPortKeyPress(Sender: TObject; var Key: Char);
begin
  SomenteNumeros(Sender, Key);
end;

function TFormSendMail.EnviarEmail(Cliente: TCliente): Boolean;
var
  Anexo: String;
  IdMessagePart: TIdMessagePart;
  IdText: TIdText;
begin
  Result := True;
  try
    //Configuração da mensagem (TIdMessage)
    IdMessage.From.Name := 'InfoSistemas';
    IdMessage.ReplyTo.EMailAddresses := IdMessage.From.Address;
    IdMessage.Recipients.Add.Text := Cliente.Email;
    IdMessage.Subject := 'Teste InfoSistemas';
    IdMessage.Encoding := meMIME;
    IdMessage.CharSet := 'utf-8';
    IdMessage.ContentType := 'multipart/related; type="text/plain"'; //; charset=iso-8859-1';

    //Corpo da Mensagem
    IdText := TIdText.Create(IdMessage.MessageParts);
    IdText.ContentType := 'text/plain';
    IdText.CharSet := 'utf-8';
    IdText.Body.Add('InfoSistemas - Dados Cadastrados');
    IdText.Body.Add('Nome: '+ Cliente.Nome);
    IdText.Body.Add('Identidade: '+ Cliente.Identidade);
    IdText.Body.Add('CPF: '+ Cliente.CPF);
    IdText.Body.Add('Telefone: '+ Cliente.Telefone);
    IdText.Body.Add('E-mail: '+ Cliente.Email);
    IdText.Body.Add('CEP: '+ Cliente.Endereco.CEP);
    IdText.Body.Add('Logradouro: '+ Cliente.Endereco.Logradouro);
    IdText.Body.Add('Número: '+ Cliente.Endereco.Numero);
    IdText.Body.Add('Complemento: '+ Cliente.Endereco.Complemento);
    IdText.Body.Add('Bairro: '+ Cliente.Endereco.Bairro);
    IdText.Body.Add('Cidade: '+ Cliente.Endereco.Cidade);
    IdText.Body.Add('Estado: '+ Cliente.Endereco.Estado);
    IdText.Body.Add('País: '+ Cliente.Endereco.Pais);

    // Opcional - Anexo da mensagem (TIdAttachmentFile)
    Anexo := GetAppDataFolder + Cliente.Id.ToString +'.xml';
    if FileExists(Anexo) then
    begin
      //IdMessagePart := IdMessage.MessageParts.Add;
      IdMessagePart := TIdAttachmentFile.Create(IdMessage.MessageParts, Anexo);
      IdMessagePart.ContentType := 'application/xml';
      IdMessagePart.ContentDisposition := 'inline';
    end;

    // Conexão e autenticação
    try
      IdSMTP.Connect;
      //IdSMTP.ValidateAuthLoginCapability := True;
      IdSMTP.Authenticate;
    except
      on E:Exception do
      begin
        Result := False;
        MessageDlg('Erro na conexão ou autenticação: ' +
          E.Message, mtWarning, [mbOK], 0);
        Exit;
      end;
    end;

    // Envio da mensagem
    try
      IdSMTP.Send(IdMessage);
      MessageDlg('Mensagem enviada com sucesso!', mtInformation, [mbOK], 0);
    except
      On E:Exception do
      begin
        Result := False;
        MessageDlg('Erro ao enviar a mensagem: ' +
          E.Message, mtWarning, [mbOK], 0);
      end;
    end;
  finally
    // desconecta do servidor
    IdSMTP.Disconnect;
    // liberação da DLL
    UnLoadOpenSSLLibrary;
  end;
end;

procedure TFormSendMail.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  GravarConfiguracao;
end;

procedure TFormSendMail.FormCreate(Sender: TObject);
begin
  ConfigServerMail;
end;

procedure TFormSendMail.FormKeyPress(Sender: TObject; var Key: Char);
begin
  if (Key = #13) then
  begin
    Key := #0;
    SelectNext(ActiveControl, True, True);
  end;
end;

procedure TFormSendMail.GravarConfiguracao;
var
  IniFile: TInifile;
  FileName: TFilename;
begin
  Filename := GetAppDataFolder  + 'config.ini';
  IniFile := TIniFile.Create(FileName);
  try
    IniFile.WriteString('Email', 'From', Trim(edFrom.Text));
    IniFile.WriteString('Email', 'Host', Trim(edHost.Text));
    IniFile.WriteBool('Email', 'Autenticado', ckRequeAuth.Checked);
    IniFile.WriteBool('Email', 'SSL', ckSSL.Checked);
    if (Trim(edPort.Text) = '') then
      edPort.Text := '0';
    IniFile.WriteInteger('Email', 'Port', StrToInt(Trim(edPort.Text)));
    IniFile.WriteString('Email', 'UserName', Trim(edUsername.Text));
    IniFile.WriteString('Email', 'Password', Trim(edPassword.Text));
  finally
    IniFile.Free;
  end;

end;

function TFormSendMail.ServidorConfigurado: Boolean;
begin
  Result := (IdSMTP.Host <> '') and (IdSMTP.Port <> 0)
    and (IdSMTP.Username <> '') and (IdSMTP.Password <> '');
end;

end.
