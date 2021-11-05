object FormSendMail: TFormSendMail
  Left = 0
  Top = 0
  BorderStyle = bsDialog
  Caption = 'Configura'#231#227'o de Servi'#231'o de Envio de E-mails'
  ClientHeight = 283
  ClientWidth = 356
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -12
  Font.Name = 'Segoe UI'
  Font.Style = []
  KeyPreview = True
  Position = poScreenCenter
  OnClose = FormClose
  OnCreate = FormCreate
  OnKeyPress = FormKeyPress
  PixelsPerInch = 96
  TextHeight = 15
  object Label1: TLabel
    Left = 16
    Top = 16
    Width = 57
    Height = 15
    Caption = 'Remetente'
  end
  object Label2: TLabel
    Left = 16
    Top = 72
    Width = 76
    Height = 15
    Caption = 'Servidor SMTP'
  end
  object Label3: TLabel
    Left = 288
    Top = 72
    Width = 28
    Height = 15
    Caption = 'Porta'
  end
  object Label4: TLabel
    Left = 16
    Top = 176
    Width = 40
    Height = 15
    Caption = 'Usu'#225'rio'
  end
  object Label5: TLabel
    Left = 216
    Top = 176
    Width = 32
    Height = 15
    Caption = 'Senha'
  end
  object edFrom: TEdit
    Left = 16
    Top = 37
    Width = 321
    Height = 23
    CharCase = ecLowerCase
    TabOrder = 0
  end
  object edHost: TEdit
    Left = 16
    Top = 93
    Width = 266
    Height = 23
    CharCase = ecLowerCase
    TabOrder = 1
  end
  object edPort: TEdit
    Left = 288
    Top = 93
    Width = 49
    Height = 23
    TabOrder = 2
    OnKeyPress = edPortKeyPress
  end
  object edUsername: TEdit
    Left = 16
    Top = 197
    Width = 194
    Height = 23
    CharCase = ecLowerCase
    TabOrder = 5
  end
  object edPassword: TEdit
    Left = 216
    Top = 197
    Width = 121
    Height = 23
    TabOrder = 6
  end
  object btGravar: TBitBtn
    Left = 184
    Top = 240
    Width = 153
    Height = 25
    Kind = bkOK
    NumGlyphs = 2
    TabOrder = 7
  end
  object ckRequeAuth: TCheckBox
    Left = 16
    Top = 136
    Width = 129
    Height = 17
    Caption = 'Requer autentica'#231#227'o'
    TabOrder = 3
  end
  object ckSSL: TCheckBox
    Left = 208
    Top = 136
    Width = 129
    Height = 17
    Caption = 'Usa conex'#227'o segura'
    TabOrder = 4
  end
  object IdSMTP: TIdSMTP
    IOHandler = IdSSLIOHandlerSocket
    Port = 0
    SASLMechanisms = <>
    UseTLS = utUseImplicitTLS
    Left = 160
    Top = 8
  end
  object IdMessage: TIdMessage
    AttachmentEncoding = 'MIME'
    BccList = <>
    CharSet = 'utf-8'
    CCList = <>
    ContentType = 'text/plain'
    Encoding = meMIME
    FromList = <
      item
      end>
    Recipients = <>
    ReplyTo = <>
    ConvertPreamble = True
    Left = 232
    Top = 8
  end
  object IdSSLIOHandlerSocket: TIdSSLIOHandlerSocketOpenSSL
    MaxLineAction = maException
    Port = 0
    DefaultPort = 0
    SSLOptions.Mode = sslmUnassigned
    SSLOptions.VerifyMode = []
    SSLOptions.VerifyDepth = 0
    Left = 160
    Top = 64
  end
end
