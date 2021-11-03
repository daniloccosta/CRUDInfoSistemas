object CadClientesForm: TCadClientesForm
  Left = 0
  Top = 0
  Caption = 'Cadastro de Clientes'
  ClientHeight = 441
  ClientWidth = 612
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -12
  Font.Name = 'Segoe UI'
  Font.Style = []
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 15
  object Label1: TLabel
    Left = 16
    Top = 16
    Width = 33
    Height = 15
    Caption = 'Nome'
  end
  object Label2: TLabel
    Left = 327
    Top = 16
    Width = 56
    Height = 15
    Caption = 'Identidade'
  end
  object Label3: TLabel
    Left = 471
    Top = 16
    Width = 21
    Height = 15
    Caption = 'CPF'
  end
  object Label4: TLabel
    Left = 16
    Top = 80
    Width = 44
    Height = 15
    Caption = 'Telefone'
  end
  object Label5: TLabel
    Left = 160
    Top = 80
    Width = 34
    Height = 15
    Caption = 'E-mail'
  end
  object Label6: TLabel
    Left = 488
    Top = 80
    Width = 21
    Height = 15
    Caption = 'CEP'
  end
  object Label7: TLabel
    Left = 16
    Top = 144
    Width = 62
    Height = 15
    Caption = 'Logradouro'
  end
  object Label8: TLabel
    Left = 328
    Top = 144
    Width = 44
    Height = 15
    Caption = 'N'#250'mero'
  end
  object Label9: TLabel
    Left = 416
    Top = 144
    Width = 77
    Height = 15
    Caption = 'Complemento'
  end
  object Label10: TLabel
    Left = 16
    Top = 208
    Width = 31
    Height = 15
    Caption = 'Bairro'
  end
  object Label11: TLabel
    Left = 296
    Top = 208
    Width = 37
    Height = 15
    Caption = 'Cidade'
  end
  object Label12: TLabel
    Left = 532
    Top = 208
    Width = 35
    Height = 15
    Caption = 'Estado'
  end
  object Label13: TLabel
    Left = 16
    Top = 272
    Width = 21
    Height = 15
    Caption = 'Pa'#237's'
  end
  object edNome: TEdit
    Left = 16
    Top = 37
    Width = 289
    Height = 23
    CharCase = ecUpperCase
    TabOrder = 0
  end
  object edIdentidade: TEdit
    Left = 327
    Top = 37
    Width = 122
    Height = 23
    CharCase = ecUpperCase
    TabOrder = 1
  end
  object edEmail: TEdit
    Left = 160
    Top = 101
    Width = 305
    Height = 23
    CharCase = ecLowerCase
    TabOrder = 4
  end
  object edLogradouro: TEdit
    Left = 16
    Top = 165
    Width = 289
    Height = 23
    CharCase = ecUpperCase
    TabOrder = 6
  end
  object edNumero: TEdit
    Left = 328
    Top = 165
    Width = 65
    Height = 23
    CharCase = ecUpperCase
    TabOrder = 7
  end
  object edComplemento: TEdit
    Left = 416
    Top = 165
    Width = 177
    Height = 23
    CharCase = ecUpperCase
    TabOrder = 8
  end
  object edBairro: TEdit
    Left = 16
    Top = 229
    Width = 257
    Height = 23
    CharCase = ecUpperCase
    TabOrder = 9
  end
  object edCidade: TEdit
    Left = 296
    Top = 229
    Width = 217
    Height = 23
    CharCase = ecUpperCase
    TabOrder = 10
  end
  object edPais: TEdit
    Left = 16
    Top = 293
    Width = 161
    Height = 23
    CharCase = ecUpperCase
    TabOrder = 11
  end
  object edCPF: TMaskEdit
    Left = 471
    Top = 37
    Width = 122
    Height = 23
    EditMask = '000\.000\.000\-00;0;_'
    MaxLength = 14
    TabOrder = 2
    Text = ''
  end
  object edTelefone: TMaskEdit
    Left = 16
    Top = 101
    Width = 121
    Height = 23
    EditMask = '!\(00\)00000-0000;0;_'
    MaxLength = 14
    TabOrder = 3
    Text = ''
  end
  object cbEstados: TComboBox
    Left = 532
    Top = 229
    Width = 61
    Height = 23
    Style = csDropDownList
    TabOrder = 12
    Items.Strings = (
      'AC'
      'AL'
      'AP'
      'AM'
      'BA'
      'CE'
      'DF'
      'ES'
      'GO'
      'MA'
      'MT'
      'MS'
      'MG'
      'PA'
      'PB'
      'PR'
      'PE'
      'PI'
      'RR'
      'RO'
      'RJ'
      'RN'
      'RS'
      'SC'
      'SP'
      'SE'
      'TO')
  end
  object edCEP: TMaskEdit
    Left = 488
    Top = 101
    Width = 105
    Height = 23
    EditMask = '00\.000\-000;0;_'
    MaxLength = 10
    TabOrder = 5
    Text = ''
  end
  object BitBtn1: TBitBtn
    Left = 170
    Top = 344
    Width = 75
    Height = 25
    Caption = 'BitBtn1'
    TabOrder = 13
  end
  object BitBtn2: TBitBtn
    Left = 258
    Top = 344
    Width = 75
    Height = 25
    Caption = 'BitBtn2'
    TabOrder = 14
  end
  object BitBtn3: TBitBtn
    Left = 352
    Top = 344
    Width = 75
    Height = 25
    Caption = 'BitBtn3'
    TabOrder = 15
  end
end
