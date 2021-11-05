unit Utils;

interface

type
  TEstadosTela = (eVisualizando, eInserindo, eAlterando, eInativo);

function ValidarCPF(sCPF: String): Boolean;
function GetAppDataFolder: String;
procedure SomenteNumeros(Componente: TObject; var Key: Char; isDecimal: Boolean = False);

implementation

uses
  System.Math, System.SysUtils, ShlObj, Winapi.Windows, Vcl.StdCtrls;

procedure SomenteNumeros(Componente: TObject; var Key: Char; isDecimal: Boolean = False);
begin
  if not isDecimal then
  begin
    if not (CharInSet(Key, ['0'..'9', Chr(8), Char(13)])) then
      Key := #0
  end
  else
  begin
    if (Key = #46) then
      Key := FormatSettings.DecimalSeparator;

    if not (CharInSet(Key, ['0'..'9', Chr(8), FormatSettings.DecimalSeparator])) then
      Key := #0
    else
      if (Key = FormatSettings.DecimalSeparator) and (Pos(Key, TEdit(Componente).Text) > 0) then
        Key := #0;
  end;
end;

function GetAppDataFolder: String;
const
  SHGFP_TYPE_CURRENT = 0;
var
  Path: array [0..MAX_PATH] of char;
begin
  SHGetFolderPath(0, CSIDL_APPDATA, 0, SHGFP_TYPE_CURRENT, @Path[0]) ;

  Result := IncludeTrailingPathDelimiter(Path) + 'InfoSistemas\' ;
end;

function ValidarCPF(sCPF: String): Boolean;
var
  v: array [0 .. 1] of Word;
  cpf: array [0 .. 10] of Byte;
  I: Byte;
begin
  Result := False;

  //Verificando se tem 11 caracteres
  if Length(sCPF) <> 11 then
  begin
    Exit;
  end;

  //Conferindo se todos dígitos são iguais
  for I := 0 to 9 do
    if (sCPF = StringOfChar(IntToStr(I)[1], 11)) then
      Exit;

  try
    for I := 1 to 11 do
      cpf[I - 1] := StrToInt(sCPF[I]);
    // Nota: Calcula o primeiro dígito de verificação.
    v[0] := 10 * cpf[0] + 9 * cpf[1] + 8 * cpf[2];
    v[0] := v[0] + 7 * cpf[3] + 6 * cpf[4] + 5 * cpf[5];
    v[0] := v[0] + 4 * cpf[6] + 3 * cpf[7] + 2 * cpf[8];
    v[0] := 11 - v[0] mod 11;
    v[0] := IfThen(v[0] >= 10, 0, v[0]);
    // Nota: Calcula o segundo dígito de verificação.
    v[1] := 11 * cpf[0] + 10 * cpf[1] + 9 * cpf[2];
    v[1] := v[1] + 8 * cpf[3] + 7 * cpf[4] + 6 * cpf[5];
    v[1] := v[1] + 5 * cpf[6] + 4 * cpf[7] + 3 * cpf[8];
    v[1] := v[1] + 2 * v[0];
    v[1] := 11 - v[1] mod 11;
    v[1] := IfThen(v[1] >= 10, 0, v[1]);
    // Nota: Verdadeiro se os dígitos de verificação são os esperados.
    Result := ((v[0] = cpf[9]) and (v[1] = cpf[10]));
  except
    on E: Exception do
      Result := False;
  end;
end;

end.
