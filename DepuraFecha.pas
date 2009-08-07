//---------------------------------------------------------------------------
//
//  Módulo de Depuración por fechas
//
//  Creación 19-01-2001
//  Finalización 07-02-2001
//
//---------------------------------------------------------------------------

unit DepuraFecha;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, ComCtrls, Buttons;

type
  TFDepurar = class(TForm)
    GroupBox1: TGroupBox;
    Fecha1: TDateTimePicker;
    Fecha2: TDateTimePicker;
    Label1: TLabel;
    Label2: TLabel;
    rdin: TRadioButton;
    rdout: TRadioButton;
    btnAceptar: TSpeedButton;
    btnCancelar: TSpeedButton;
    procedure FormShow(Sender: TObject);
    procedure btnCancelarClick(Sender: TObject);
    procedure CambiodeFecha(Sender: TObject);
    procedure btnAceptarClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  FDepurar: TFDepurar;

implementation

uses Datos;

{$R *.DFM}

//---------------------------------------------------------------------------
// AL ABRIR, MUESTRA FECHA ACTUAL
//---------------------------------------------------------------------------

procedure TFDepurar.FormShow(Sender: TObject);
begin
     Fecha1.Date := Now;
     Fecha2.Date := Now;
end;

//---------------------------------------------------------------------------
// CIERRA LA VENTANA
//---------------------------------------------------------------------------

procedure TFDepurar.btnCancelarClick(Sender: TObject);
begin
     ModalResult := mrCancel;
end;

//---------------------------------------------------------------------------
// NO PERMITE QUE LA FECHA INICIAL SEA MAYOR QUE LA FINAL
//---------------------------------------------------------------------------

procedure TFDepurar.CambiodeFecha(Sender: TObject);
begin
     if Fecha1.Date > Fecha2.Date then Fecha2.Date := Fecha1.Date;
end;

//---------------------------------------------------------------------------
// BORRA LOS REGISTROS SELECCIONADOS
//---------------------------------------------------------------------------

procedure TFDepurar.btnAceptarClick(Sender: TObject);
var
   p : String;
   fi, ff : String;
begin
    // Recupera fecha inicial y final
    p := DatetoStr(Fecha1.Date);
    fi := (Copy(p,7,4) + Copy(p,3,4) + Copy(p,1,2));
    p := DatetoStr(Fecha2.Date);
    ff := (Copy(p,7,4) + Copy(p,3,4) + Copy(p,1,2));

    if rdin.Checked then  // Borra registros dentro del rango
       p := 'DELETE FROM Eventos WHERE (Ev_fecha2>="' + fi + '") AND (Ev_fecha2<="' + ff + '")'
    else                  // Borra registros fuera del rango
       p := 'DELETE FROM Eventos WHERE (Ev_fecha2<"' + fi + '") OR (Ev_fecha2>"' + ff + '")';

    try
       with data.Consulta do
       begin
            SQL.Text := p;
            ExecSQL;
            Close;
            ShowMessage('Eventos borrados');
       end;
    except
       Application.MessageBox('No se pueden borrar los registros seleccionados', 'Error', MB_OK + MB_ICONHAND);
    end;

    ModalResult := mrOK;
end;

end.
