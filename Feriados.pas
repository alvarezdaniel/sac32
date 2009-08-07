//---------------------------------------------------------------------------
//
//  Módulo de Configuración de Feriados
//
//
//  Inicio 12-04-2001
//
//---------------------------------------------------------------------------

unit Feriados;

interface

uses
  Forms, Classes, Controls, StdCtrls, Mask, ComCtrls, ImgList, SysUtils,
  Buttons, Windows, Messages, Graphics, Dialogs, Grids, ExtCtrls;


type
  TFFeriados = class(TForm)
    GroupBox1: TGroupBox;
    LFeriados: TListView;
    imgFeriados: TImageList;
    Calendario: TMonthCalendar;
    btnAceptar: TSpeedButton;
    btnCancelar: TSpeedButton;
    btnActualizar: TSpeedButton;
    btnSalir: TSpeedButton;
    procedure FormShow(Sender: TObject);
    procedure LFeriadosChange(Sender: TObject; Item: TListItem;
      Change: TItemChange);
    procedure CalendarioClick(Sender: TObject);
    procedure btnSalirClick(Sender: TObject);
    procedure btnCancelarClick(Sender: TObject);
    procedure btnAceptarClick(Sender: TObject);
    procedure btnActualizarClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  FFeriados: TFFeriados;

implementation

uses Datos, Serkey, Rutinas, Comunicaciones;

{$R *.DFM}

//---------------------------------------------------------------------------
// CARGA LA TABLA DE FERIADOS
//---------------------------------------------------------------------------

procedure TFFeriados.FormShow(Sender: TObject);
var
   I : TListItem;
   d, m, a : Word;
begin
    LFeriados.Items.Clear;

    // Realiza consulta de todos los feriados
    with data.Consulta do
    begin
      SQL.Text := 'SELECT * FROM Feriados';
      Open;
      while not Eof do
      begin
         I := LFeriados.Items.Add;
         I.Caption := FieldbyName('Fer_fecha').AsString;
         I.ImageIndex := 0;
         Next;
      end;
      Close;
    end;

    LFeriados.Selected := LFeriados.Items[0];

    DecodeDate(Now, a, m, d);
    Calendario.MinDate := StrtoDate('01/01/' + InttoStr(a));
    Calendario.MaxDate := StrtoDate('31/12/' + InttoStr(a));
end;

//---------------------------------------------------------------------------
// ACTUALIZA CALENDARIO CON FERIADO SELECCIONADO
//---------------------------------------------------------------------------

procedure TFFeriados.LFeriadosChange(Sender: TObject; Item: TListItem;
  Change: TItemChange);
var
   d, m, a : Word;
begin
   // Toma año actual para feriados
   DecodeDate(Now, a, m, d);
   Calendario.Date := StrtoDate(Item.Caption + '/' + InttoStr(a));
end;

//---------------------------------------------------------------------------
// CAMBIA FECHA DEL FERIADO SELECCIONADO
//---------------------------------------------------------------------------

procedure TFFeriados.CalendarioClick(Sender: TObject);
begin
     LFeriados.Selected.Caption := Copy(DatetoStr(Calendario.Date), 1, 5);
end;

//---------------------------------------------------------------------------
// CIERRA LA VENTANA Y VUELVE AL PROGRAMA
//---------------------------------------------------------------------------

procedure TFFeriados.btnSalirClick(Sender: TObject);
begin
     Close;
end;

//---------------------------------------------------------------------------
// CANCELA LOS CAMBIOS REALIZADOS
//---------------------------------------------------------------------------

procedure TFFeriados.btnCancelarClick(Sender: TObject);
begin
     FormShow(Self);
end;

//---------------------------------------------------------------------------
// ACEPTA Y GRABA LOS CAMBIOS REALIZADOS
//---------------------------------------------------------------------------

procedure TFFeriados.btnAceptarClick(Sender: TObject);
var
   i : Integer;
begin
    // Actualiza datos de feriados en la tabla
    with data.Consulta do
    begin
      SQL.Text := 'SELECT * FROM Feriados';
      RequestLive := True;
      Open;
      i := 0;
      while not Eof do
      begin
         Edit;
         FieldbyName('Fer_fecha').AsString := LFeriados.Items[i].Caption;
         Post;
         inc(i);
         Next;
      end;
      Close;
    end;
    FormShow(Self);
end;

//---------------------------------------------------------------------------
// SUBE LOS FERIADOS a un Nodo
//---------------------------------------------------------------------------

procedure TFFeriados.btnActualizarClick(Sender: TObject);
var i : Integer;
begin
  {if llave.mododemo then vdemo else
  begin}
    // Arma array con los nodos existentes
    with data.Consulta do
    begin
       SQL.Text := 'SELECT * FROM Nodos ORDER BY Nod_num';
       Open;
       SetLength(Nodos, RecordCount);
       i := 0;
       while not Eof do
       begin
          Nodos[i] := FieldbyName('Nod_num').AsInteger;
          Next;
          inc(i);
       end;
       Close;
    end;

    if Length(Nodos) = 0 then
        Application.MessageBox('Para cargar los feriados debe haber algún nodo cargado', 'Información', MB_OK + MB_ICONINFORMATION)
    else
        for i:=0 to Length(Nodos)-1 do p.Upload_Feriados(Nodos[i]);
  {end;}
end;

end.
