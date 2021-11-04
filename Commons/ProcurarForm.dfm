object FormProcurar: TFormProcurar
  Left = 0
  Top = 0
  BorderStyle = bsDialog
  Caption = 'Procurar clientes'
  ClientHeight = 306
  ClientWidth = 490
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -12
  Font.Name = 'Segoe UI'
  Font.Style = []
  KeyPreview = True
  Position = poScreenCenter
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  OnKeyDown = FormKeyDown
  PixelsPerInch = 96
  TextHeight = 15
  object lbProcurarPor: TLabel
    Left = 16
    Top = 16
    Width = 33
    Height = 15
    Caption = 'Nome'
  end
  object edProcurar: TEdit
    Left = 16
    Top = 37
    Width = 362
    Height = 23
    CharCase = ecUpperCase
    TabOrder = 0
    OnChange = edProcurarChange
    OnKeyDown = edProcurarKeyDown
  end
  object lvProcurar: TListView
    Left = 16
    Top = 72
    Width = 457
    Height = 169
    Columns = <
      item
        Caption = 'C'#243'digo'
        Width = 70
      end
      item
        Caption = 'Descri'#231#227'o'
        Width = 320
      end>
    OwnerData = True
    ReadOnly = True
    RowSelect = True
    TabOrder = 1
    ViewStyle = vsReport
    OnData = lvProcurarData
    OnDblClick = lvProcurarDblClick
    OnKeyPress = lvProcurarKeyPress
  end
  object btOk: TBitBtn
    Left = 384
    Top = 264
    Width = 89
    Height = 25
    Kind = bkOK
    NumGlyphs = 2
    TabOrder = 2
  end
  object btCancel: TBitBtn
    Left = 289
    Top = 264
    Width = 89
    Height = 25
    Caption = 'Cancelar'
    Kind = bkCancel
    NumGlyphs = 2
    TabOrder = 3
  end
end
