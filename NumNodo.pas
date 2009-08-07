//---------------------------------------------------------------------------
//
//  Ventana para cambiar el número de nodo
//
//
// Chequeo OK 09-12-2000
// Finalización del Módulo 01-02-2001
//
//
//
// A hacer :
//           Autocompletar como Internet Explorer
//
//---------------------------------------------------------------------------

unit NumNodo;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  Busqueda, StdCtrls, Buttons, ExtCtrls, DBTables;

type
  TFNumNodo = class(TFBusqueda)
    optTipoConexion: TRadioGroup;
    Label2: TLabel;
    txtDireccion: TEdit;
    Label3: TLabel;
    procedure optTipoConexionClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure btnAceptaClick(Sender: TObject);
  private
    Fnod_dis: String;
    procedure Setnod_dis(const Value: String);
    { Private declarations }
  public
    { Public declarations }
    property nod_dis: String read Fnod_dis write Setnod_dis;
  end;

var
  FNumNodo: TFNumNodo;

implementation

uses Datos, Serkey;

{$R *.DFM}

{ TFNumNodo }

procedure TFNumNodo.optTipoConexionClick(Sender: TObject);
begin
  inherited;
  Label2.Enabled := (optTipoConexion.ItemIndex = 1);
  txtDireccion.Enabled := Label2.Enabled;
  Label3.Enabled := Label2.Enabled;
  if optTipoConexion.ItemIndex = 0 then txtDireccion.Text := '';
end;

procedure TFNumNodo.FormShow(Sender: TObject);
begin
  inherited;

  // Corrección 13/03/2004 - Sólo TCP/IP en modo full
  optTipoConexion.Enabled := llave.modofull;

  optTipoConexion.OnClick(nil);
end;

procedure TFNumNodo.Setnod_dis(const Value: String);
var
  qryAux: TQuery;
begin
  qryAux := TQuery.Create(nil);
  try
    qryAux.DatabaseName := data.Consulta.DatabaseName;

    if Trim(Value) = '' then
    begin
      optTipoConexion.ItemIndex := 0;
      txtDireccion.Text := '';
      Fnod_dis := '';
    end
    else
    begin
      qryAux.SQL.Text := 'select * from Dispositivos where dis_cod = "' + Value + '"';
      qryAux.Open;
      if qryAux.IsEmpty then
      begin
        optTipoConexion.ItemIndex := 0;
        txtDireccion.Text := '';
        Fnod_dis := '';
      end
      else
      begin
        optTipoConexion.ItemIndex := 1;
        txtDireccion.Text := qryAux.FieldbyName('dis_direccion').AsString;
        Fnod_dis := Value;
      end;
      qryAux.Close;
    end;
  finally
    qryAux.Free;
  end;
end;

procedure TFNumNodo.btnAceptaClick(Sender: TObject);
begin
  // Por ahora no permite TCP/IP
  if optTipoConexion.ItemIndex = 1 then
  begin
    Application.MessageBox('La conexión por TCP/IP todavía no está implementada', 'Advertencia', MB_OK + MB_ICONERROR);
  end
  else
    inherited;
end;

end.
