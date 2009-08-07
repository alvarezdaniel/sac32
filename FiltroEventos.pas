//---------------------------------------------------------------------------
//
//  Módulo de Depuración por tipo de eventos
//
//  Creación 19-01-2001
//  Finalización 07-02-2001
//
//---------------------------------------------------------------------------

unit FiltroEventos;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, Buttons;

type
  TFFiltroEv = class(TForm)
    GroupBox1: TGroupBox;
    Label1: TLabel;
    cbTipos: TComboBox;
    rbigual: TRadioButton;
    rbdiferente: TRadioButton;
    btnAceptar: TSpeedButton;
    btnCancelar: TSpeedButton;
    procedure FormShow(Sender: TObject);
    procedure btnCancelarClick(Sender: TObject);
    procedure btnAceptarClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  FFiltroEv: TFFiltroEv;

implementation

uses Datos;

{$R *.DFM}

//---------------------------------------------------------------------------
// ABRE LA VENTANA
//---------------------------------------------------------------------------

procedure TFFiltroEv.FormShow(Sender: TObject);
var
   i : Integer;
begin
  // Carga tipos de eventos
  with data.Consulta do
  begin
      Close;
      SQL.Clear;
      SQL.Add('SELECT Tip_desc2 FROM Tip_Ev');
      Open;
      cbTipos.Items.Clear;

      for i:=0 to RecordCount-1 do
      begin
          cbTipos.Items.Add(FieldbyName('Tip_desc2').AsString);
          Next;
      end;

      Close;

      cbTipos.ItemIndex := 0;
  end;
end;

//---------------------------------------------------------------------------
// VUELVE A MANTENIMIENTO
//---------------------------------------------------------------------------

procedure TFFiltroEv.btnCancelarClick(Sender: TObject);
begin
     ModalResult := mrCancel;
end;

//---------------------------------------------------------------------------
// BORRA REGISTROS SELECCIONADOS
//---------------------------------------------------------------------------

procedure TFFiltroEv.btnAceptarClick(Sender: TObject);
var
   p : String;
   t : String;
begin
    with data.Consulta do
    begin
        Close;
        SQL.Clear;
        SQL.Add('SELECT Tip_id FROM Tip_Ev WHERE Tip_desc2 = "' + cbTipos.Text + '"');
        Open;
        t := FieldbyName('Tip_id').AsString;
        Close;
    end;

    if rbigual.Checked then // Borra registros dentro del rango
       p := 'DELETE FROM Eventos WHERE Ev_tipo = "' + t + '"'
    else  // Borra registros fuera del rango
       p := 'DELETE FROM Eventos WHERE Ev_tipo <> "' + t + '"';

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
