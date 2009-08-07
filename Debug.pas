unit Debug;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls;

type
  TFDebug = class(TForm)
    Button1: TButton;
    Edit1: TEdit;
    Button3: TButton;
    Memo1: TMemo;
    Button4: TButton;
    Button5: TButton;
    Button6: TButton;
    Button7: TButton;
    Edit2: TEdit;
    Label1: TLabel;
    Button8: TButton;
    Button9: TButton;
    Button10: TButton;
    Button11: TButton;
    Button12: TButton;
    Button13: TButton;
    Button14: TButton;
    Button2: TButton;
    Button15: TButton;
    Button16: TButton;
    Edit3: TEdit;
    procedure Button1Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure Button3Click(Sender: TObject);
    procedure Button4Click(Sender: TObject);
    procedure Button5Click(Sender: TObject);
    procedure Button6Click(Sender: TObject);
    procedure Button8Click(Sender: TObject);
    procedure Button11Click(Sender: TObject);
    procedure Button12Click(Sender: TObject);
    procedure Button13Click(Sender: TObject);
    procedure Button14Click(Sender: TObject);
    procedure Button9Click(Sender: TObject);
    procedure Button10Click(Sender: TObject);
    procedure Button15Click(Sender: TObject);
    procedure Button16Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  FDebug: TFDebug;

implementation

Uses Comunicaciones, ABM, Datos;

{$R *.DFM}

//---------------------------------------------------------------------------
// CIERRA EL FORM

procedure TFDebug.Button1Click(Sender: TObject);
var
        estado : TStatus;
begin
        if Get_Status(1, estado) then
        begin
                Edit1.Text := 'OK';
                Memo1.Lines.Add(estado.fecha + ' ' + estado.hora + ' Tacc= ' + InttoStr(estado.tacc));
        end
        else
                Edit1.Text := 'Mal';
end;

procedure TFDebug.Button2Click(Sender: TObject);
begin
    Upload_Tarjetas(3);
end;

procedure TFDebug.Button3Click(Sender: TObject);
begin
    if Interroga(1, valores) then
    begin
        Memo1.Lines.Add('Bytes x tarjeta = ' + InttoStr(valores.BYTESxTARJETA));
        Memo1.Lines.Add('Bytes x evento = ' + InttoStr(valores.BYTESxEVENTO));
        Memo1.Lines.Add('Tarjetas x banco = ' + InttoStr(valores.TARJETASxBANCO));
        Memo1.Lines.Add('Eventos x banco = ' + InttoStr(valores.EVENTOSxBANCO));
        Memo1.Lines.Add('Banco inicial de tarjetas = ' + InttoStr(valores.PRIMBANCOTARJETAS));
        Memo1.Lines.Add('Banco final de tarjetas = ' + InttoStr(valores.ULTBANCOTARJETAS));
        Memo1.Lines.Add('Banco inicial de eventos = ' + InttoStr(valores.PRIMBANCOEVENTOS));
        Memo1.Lines.Add('Banco final de eventos = ' + InttoStr(valores.ULTBANCOEVENTOS));
    end
    else
        Memo1.Lines.Add('Mal');
end;

procedure TFDebug.Button4Click(Sender: TObject);
var
    s : String;
begin
    if Modelo(1, s) then
        Memo1.Lines.Add('Modelo = ' + s)
    else
        Memo1.Lines.Add('Mal');
end;

procedure TFDebug.Button5Click(Sender: TObject);
begin
    if Escribe_Memoria(1, 8, 0, 5, 0, 0, 0, 0, 0) then
        Memo1.Lines.Add('Escritura OK.')
    else
        Memo1.Lines.Add('Escritura Mal.');
end;

procedure TFDebug.Button6Click(Sender: TObject);
var
    d0, d1, d2, d3, d4 : Byte;
begin
    if Lee_Memoria(1, 8, 0, 5, d0, d1, d2, d3, d4) then
    begin
        Memo1.Lines.Add(Format('%d %d %d %d %d', [d0, d1, d2, d3, d4]));
    end
    else
        Memo1.Lines.Add('Lectura Mal.');
end;

procedure TFDebug.Button8Click(Sender: TObject);
var
    i : Integer;
begin
    randomize;

    for i:=1 to SIZE do
        pack_out[i] := random(255);

    if send_paquete then
    begin
      for i:=2 to SIZE-1 do
          if pack_in[i] <> pack_out[i] then
          begin
              Memo1.Lines.Add('Error en paquete ' + InttoStr(i));
          end;
    end;
end;

procedure TFDebug.Button11Click(Sender: TObject);
var
    n : Integer;
begin
    if Even_Hab(1, LEE, EV, n) then Memo1.Lines.Add(InttoStr(n) + ' Eventos');
end;

procedure TFDebug.Button12Click(Sender: TObject);
var
    n : Integer;
begin
    if Even_Hab(1, LEE, HAB, n) then Memo1.Lines.Add(InttoStr(n) + ' Habilitados');
end;

procedure TFDebug.Button13Click(Sender: TObject);
begin
    if Reset(1) then Memo1.Lines.Add('Nodo Reseteado');
end;

procedure TFDebug.Button14Click(Sender: TObject);
begin
    //if Escribe_Reloj(1) then Memo1.Lines.Add('Reloj configurado');
end;

procedure TFDebug.Button9Click(Sender: TObject);
var
    n : Integer;
begin
    if Even_Hab(1, BORRA, EV, n) then Memo1.Lines.Add('Eventos borrados');
end;

procedure TFDebug.Button10Click(Sender: TObject);
var
    n : Integer;
begin
    if Even_Hab(1, BORRA, HAB, n) then Memo1.Lines.Add('Habilitados borrados');
end;

procedure TFDebug.Button15Click(Sender: TObject);
var
    i : Integer;
begin
    for i:=1 to 800 do
    begin
      with data.TUsuarios do
      begin
           Open;
           Append;
           FieldbyName('usr_nom').AsString := 'Persona';
           FieldbyName('usr_tarj').AsInteger := 0;
           FieldbyName('usr_hab').AsBoolean := False;
           FieldbyName('usr_grp').AsInteger := 3;
           Post;
           Close;
      end;
    end;
end;

procedure TFDebug.Button16Click(Sender: TObject);
var
    evento : TEvento;
begin
    Get_Evento(1, 0, evento);

    with data.TUsuarios do
    begin
        Open;
        if Locate('usr_tarj', evento.tarjeta, []) then
            evento.nombre := FieldbyName('usr_nom').AsString
        else
            evento.nombre := 'Desconocido';
        Close;
    end;

    with data.TNodos do
    begin
        Open;
        if Locate('nod_num', (pack_in[1] and $7F), []) then
            evento.nodo := FieldbyName('nod_nom').AsString
        else
            evento.nodo := 'Desconocido';
        Close;
    end;

    NuevoEvento(evento, True);
end;

end.
