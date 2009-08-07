//---------------------------------------------------------------------------
//
//  Módulo de Configuración de los Nodos
//
//
// Hacer cambios visuales 09-12-2000
// Agregado de configuración de primer dígito en equipo ABA-Track
// Cambio de Interfase 31-01-2001
// Agregado de configuración de tipo de lector y división
// de ventana en dos páginas (opciones principales y secundarias) 07-10-2001
//
//
//---------------------------------------------------------------------------

unit ConfigNodo;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  ComCtrls, StdCtrls, Buttons, ExtCtrls, ToolWin, ImgList;

type
  TFConfigNodo = class(TForm)
    GroupBox1: TGroupBox;
    Label7: TLabel;
    ANodos: TTreeView;
    ImgANodos: TImageList;
    btnGet: TSpeedButton;
    btnSet: TSpeedButton;
    Timer1: TTimer;
    btnSalir: TSpeedButton;
    PageControl1: TPageControl;
    TabSheet1: TTabSheet;
    TabSheet2: TTabSheet;
    GroupBoxTacc: TGroupBox;
    Label1: TLabel;
    EditTacc: TEdit;
    ud_acc: TUpDown;
    GroupBoxFlags: TGroupBox;
    CheckOnline: TCheckBox;
    CheckValidar: TCheckBox;
    CheckPulsador: TCheckBox;
    CheckFranjas: TCheckBox;
    CheckSalida: TCheckBox;
    GroupBoxAlarma: TGroupBox;
    Label2: TLabel;
    EditTAlarma: TEdit;
    ud_al: TUpDown;
    CheckAlarma: TCheckBox;
    GroupBoxFecha: TGroupBox;
    btnLeeFecha: TSpeedButton;
    btnGrabaFecha: TSpeedButton;
    SpeedButton1: TSpeedButton;
    lblDia: TLabel;
    fecha: TDateTimePicker;
    hora: TDateTimePicker;
    GroupBoxRelacion: TGroupBox;
    LabelHab: TLabel;
    LabelEv: TLabel;
    Track1: TTrackBar;
    btnGrabarRel: TButton;
    GroupBoxDig: TGroupBox;
    Label3: TLabel;
    EditDigito: TEdit;
    ud_dig: TUpDown;
    GroupBoxHab: TGroupBox;
    EditHabils: TEdit;
    BorraHab: TButton;
    GroupBoxEv: TGroupBox;
    EditEven: TEdit;
    BorraEven: TButton;
    RadioGroupLector: TRadioGroup;
    GroupBoxModelo: TGroupBox;
    EditModelo: TEdit;
    CheckAvisoPuerta: TCheckBox;
    procedure LeerOpciones(Sender: TObject);
    procedure EscribirOpciones(Sender: TObject);
    procedure BorraHabClick(Sender: TObject);
    procedure BorraEvenClick(Sender: TObject);
    procedure LeeFechaDelNodo(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure GrabaFechaAlNodo(Sender: TObject);
    procedure btnSalirClick(Sender: TObject);
    procedure ANodosChange(Sender: TObject; Node: TTreeNode);
    procedure Timer1Timer(Sender: TObject);
    procedure FechaChange(Sender: TObject);
    procedure Actualizafecha(Sender: TObject);
    procedure GroupBoxModeloDblClick(Sender: TObject);
    procedure Track1Change(Sender: TObject);
    procedure btnGrabarRelClick(Sender: TObject);
    procedure horaChange(Sender: TObject);
    procedure GroupBoxHabDblClick(Sender: TObject);
  private
    { Private declarations }
    h : Boolean;
  public
    { Public declarations }
  end;

var
  FConfigNodo: TFConfigNodo;

implementation

uses Comunicaciones, Principal, Rutinas, Datos, Test;

{$R *.DFM}

//---------------------------------------------------------------------------
// AL ENTRAR CARGA LOS NODOS SELECCIONADOS
//---------------------------------------------------------------------------

procedure TFConfigNodo.FormShow(Sender: TObject);
var
  i : Integer;
  N : TTreeNode;
begin
  // Muestra las opciones principales
  PageControl1.ActivePageIndex := 0;

  // Carga árbol con los nodos seleccionados
  for i:=0 to Length(Nodos)-1 do
  begin
     with data.Consulta do
     begin
         SQL.Clear;
         SQL.Add('SELECT Nod_nom FROM Nodos WHERE Nod_num = :nodo');
         ParambyName('nodo').AsInteger := Nodos[i];
         Open;
         N := ANodos.Items.AddChild(ANodos.Items[0], FieldbyName('Nod_nom').AsString);
         N.ImageIndex := 1;
         N.SelectedIndex := 1;
         Close;
     end;
  end;
  ANodos.FullExpand;

  // Si entró con un solo nodo seleccionado, lee sus propiedades
  if Length(Nodos) = 1 then
  begin
       ANodos.Selected := ANodos.Items[1];
       btnGet.Click;
  end
  else ANodos.Selected := ANodos.Items[0];

  // Inicializa flag
  h := False;
  Timer1Timer(Self);

  // Actualiza día de la semana
  fecha.OnChange(Self);
end;

//---------------------------------------------------------------------------
// VUELVE A LA VENTANA PRINCIPAL
//---------------------------------------------------------------------------

procedure TFConfigNodo.btnSalirClick(Sender: TObject);
begin
     Close;
end;

//---------------------------------------------------------------------------
// SI SE SELECCIONAN TODOS LOS NODOS NO SE PUEDE LEER
//---------------------------------------------------------------------------

procedure TFConfigNodo.ANodosChange(Sender: TObject; Node: TTreeNode);
var
   flag : Boolean;
begin
   flag := (ANodos.Selected.Level = 0);

   btnGet.Enabled := not flag;
   btnLeeFecha.Enabled := not flag;
   BorraHab.Enabled := not flag;
   BorraEven.Enabled := not flag;

   {
   if ANodos.Selected.Level = 0 then
   begin
      Track1.Enabled := False;
      btnGrabarRel.Enabled := False;
   end;
   }

   // Deshabilita edición de relación Hab/Ev
   GroupBoxRelacion.Enabled := False;
   Track1.Enabled := False;
   btnGrabarRel.Enabled := False;
   Track1.Position := Track1.Min;
   LabelHab.Caption := 'Habilitados = ?';
   LabelEv.Caption := 'Eventos = ?';
end;

//---------------------------------------------------------------------------
// ACTUALIZA LA FECHA Y HORA DE LA PC EN PANTALLA
//---------------------------------------------------------------------------

procedure TFConfigNodo.Timer1Timer(Sender: TObject);
var
  days: array[1..7] of string;
begin
   h := True;
   fecha.Date := Now;
   hora.Time := Now;

   days[1] := 'Domingo';
   days[2] := 'Lunes';
   days[3] := 'Martes';
   days[4] := 'Miércoles';
   days[5] := 'Jueves';
   days[6] := 'Viernes';
   days[7] := 'Sábado';

   lblDia.Caption := days[DayOfWeek(fecha.Date)];

   h := False;
end;

//---------------------------------------------------------------------------
// AL HACER UN CAMBIO EN LA FECHA U HORA PARA EL TIMER DE ACTUALIZACIÓN
//---------------------------------------------------------------------------

procedure TFConfigNodo.FechaChange(Sender: TObject);
var
  days: array[1..7] of string;
begin
  Timer1.Enabled := h;

  days[1] := 'Domingo';
  days[2] := 'Lunes';
  days[3] := 'Martes';
  days[4] := 'Miércoles';
  days[5] := 'Jueves';
  days[6] := 'Viernes';
  days[7] := 'Sábado';

  lblDia.Caption := days[DayOfWeek(fecha.Date)];
end;

procedure TFConfigNodo.horaChange(Sender: TObject);
begin
  Timer1.Enabled := h;
end;

//---------------------------------------------------------------------------
// VUELVE A HABILITAR ACTUALIZACIÖN DE FECHA Y HORA ACTUAL
//---------------------------------------------------------------------------

procedure TFConfigNodo.Actualizafecha(Sender: TObject);
begin
   PlayWav('CLICK');
   fecha.OnChange(Self);
   Timer1.Enabled := True;
end;

//---------------------------------------------------------------------------
// LEE FECHA Y HORA DE NODO SELECCIONADO
//---------------------------------------------------------------------------

procedure TFConfigNodo.LeeFechaDelNodo(Sender: TObject);
var
    estado : TStatus;
    nodo : Integer;
begin
    // Busca número del nodo a leer
    with data.Consulta do
    begin
       SQL.Clear;
       SQL.Add('SELECT Nod_num FROM Nodos WHERE Nod_nom = :nodo');
       ParambyName('nodo').AsString := ANodos.Selected.Text;
       Open;
       nodo := FieldbyName('Nod_num').AsInteger;
       Close;
    end;

    // Obtiene la fecha y hora del nodo
    if p.Get_Status(nodo, estado) then
    begin
      try
         fecha.Date := StrtoDate(estado.fecha);
         hora.Time := StrtoTime(estado.hora);
         h := False;
         Timer1.Enabled := h;
         fecha.OnChange(Self);
      except
      end;

      PlayWav('INFO');
      FPrincipal.Nod_Status[nodo] := 0;
      FPrincipal.ActualizaEstadoNodos(nodo);
    end
    else
    begin
       PlayWav('ERR');
       Application.MessageBox(PChar(Format('%s no responde', [ANodos.Selected.Text])), 'Offline', MB_OK + MB_ICONEXCLAMATION);
       FPrincipal.Nod_Status[nodo] := 1;
       FPrincipal.ActualizaEstadoNodos(nodo);
    end;
end;

//---------------------------------------------------------------------------
// ESCRIBE FECHA Y HORA EN NODOS
//---------------------------------------------------------------------------

procedure TFConfigNodo.GrabaFechaAlNodo(Sender: TObject);
var
    estado : TStatus;
    min, hor, seg, ms, anio, mes, dia : Word;
    nodo, i : Integer;
begin
    // Recolecta información de fecha y hora a grabar en los nodos
    DecodeDate(fecha.Date, anio, mes, dia);     // Toma fecha configurada
    DecodeTime(hora.Time, hor, min, seg, ms);  // Toma hora configurada

    estado.fecha := Format('%2.2d/%2.2d/%4.4d', [dia, mes, anio]);;
    estado.hora := Format('%2.2d:%2.2d', [hor, min]);

    // Graba la fecha y hora en los nodos seleccionados
    if ANodos.Selected.Level = 1 then
    begin
        // Busca número del nodo a escribir
        with data.Consulta do
        begin
           SQL.Clear;
           SQL.Add('SELECT Nod_num FROM Nodos WHERE Nod_nom = :nodo');
           ParambyName('nodo').AsString := ANodos.Selected.Text;
           Open;
           nodo := FieldbyName('Nod_num').AsInteger;
           Close;
        end;

        // Escribe la fecha y hora
        if not p.Escribe_Reloj(nodo, estado) then
        begin
            PlayWav('ERR');
            Application.MessageBox(PChar(ANodos.Selected.Text + ' no responde'), 'Offline', MB_OK + MB_ICONEXCLAMATION);
            FPrincipal.Nod_Status[nodo] := 1;
            FPrincipal.ActualizaEstadoNodos(nodo);
        end
        else
        begin
            PlayWav('INFO');
            FPrincipal.Nod_Status[nodo] := 0;
            FPrincipal.ActualizaEstadoNodos(nodo);
        end;
    end
    else
    begin
        for i:=0 to ANodos.Items[0].Count-1 do
        begin
            // Busca número del nodo a escribir
            with data.Consulta do
            begin
               SQL.Clear;
               SQL.Add('SELECT Nod_num FROM Nodos WHERE Nod_nom = :nodo');
               ParambyName('nodo').AsString := ANodos.Items[0].Item[i].Text;
               Open;
               nodo := FieldbyName('Nod_num').AsInteger;
               Close;
            end;

            // Escribe la fecha y hora
            if not p.Escribe_Reloj(nodo, estado) then
            begin
                PlayWav('ERR');
                Application.MessageBox(PChar(ANodos.Items[0].Item[i].Text + ' no responde'), 'Offline', MB_OK + MB_ICONEXCLAMATION);
                FPrincipal.Nod_Status[nodo] := 1;
                FPrincipal.ActualizaEstadoNodos(nodo);
            end
            else
            begin
                PlayWav('INFO');
                FPrincipal.Nod_Status[nodo] := 0;
                FPrincipal.ActualizaEstadoNodos(nodo);
            end;
        end;
    end;
end;

//---------------------------------------------------------------------------
// LEE TODA LA CONFIGURACION DEL NODO
//---------------------------------------------------------------------------

procedure TFConfigNodo.LeerOpciones(Sender: TObject);
var
  //estado : TStatus;
  d: dato;
  n: Integer;
  s: String;
  st: Boolean;
  nodo: Integer;
begin
    // Busca número del nodo a leer
    with data.Consulta do
    begin
       SQL.Clear;
       SQL.Add('SELECT Nod_num FROM Nodos WHERE Nod_nom = :nodo');
       ParambyName('nodo').AsString := ANodos.Selected.Text;
       Open;
       nodo := FieldbyName('Nod_num').AsInteger;
       Close;
    end;

    // Asume que no puede leer bien las propiedades
    st := False;

    // Lee Flags y Valores
    if p.Modelo(nodo, s) then
    begin
      if p.Lee_Memoria(nodo, p.UltimoBanco, DIR_FLAGS2, 6, d) then
      begin
        // Agregado 13/03/2004 - en $04 bit 0 se almacena el nuevo flag de aviso de puerta abierta
        CheckAvisoPuerta.Checked :=  ((d[0] and $01) shr 0) = 1;

        ud_acc.Position := d[1];
        ud_dig.Position := d[2];
        ud_al.Position := d[3];
        CheckValidar.Checked :=  ((d[4] and $01) shr 0) = 1;
        CheckOnline.Checked :=   ((d[4] and $02) shr 1) = 1;
        CheckAlarma.Checked :=   ((d[4] and $04) shr 2) = 1;
        CheckPulsador.Checked := ((d[4] and $08) shr 3) = 1;
        CheckFranjas.Checked :=  ((d[4] and $10) shr 4) = 1;
        CheckSalida.Checked :=   ((d[4] and $20) shr 5) = 1;
        RadioGroupLector.ItemIndex := ((d[4] shr 6) and $03);
        Track1.Min := 0;
        Track1.Max := p.UltimoBanco - 5;
        Track1Change(Self);
        Track1.Position := d[5];

        // Lee cantidad de habilitados
        if p.Even_Hab(nodo, LEE, HAB, n) then
        begin
            EditHabils.Text := InttoStr(n);

            // Lee cantidad de eventos
            if p.Even_Hab(nodo, LEE, EV, n) then
            begin
                EditEven.Text := InttoStr(n);

                // Lee modelo
                //if p.Modelo(nodo, s) then
                //begin
                    EditModelo.Text := s;

                    // Lee fecha y hora
                    {if p.Get_Status(nodo, estado) then
                    begin

                    end;}

                    // Habilita configuración de relación
                    GroupBoxRelacion.Enabled := True;
                    Track1.Enabled := True;
                    btnGrabarRel.Enabled := True;

                    st := True;
                //end;
            end;
        end;

        // Corrección 13/03/2004 - En el modelo M, algunas opciones no están habilitadas
        CheckPulsador.Enabled := p.ModeloEquipo <> 'M';
        CheckOnline.Enabled := p.ModeloEquipo <> 'M';
        Track1.Enabled := p.ModeloEquipo <> 'M';
        RadioGroupLector.Enabled := p.ModeloEquipo <> 'M';
        EditDigito.Enabled := p.ModeloEquipo <> 'M';
      end;
    end;

    if not st then
    begin
        PlayWav('ERR');
        Application.MessageBox(PChar(ANodos.Selected.Text + ' no responde'), 'Offline', MB_OK + MB_ICONEXCLAMATION);
        FPrincipal.Nod_Status[nodo] := 1;
    end
    else
    begin
        PlayWav('INFO');
        FPrincipal.Nod_Status[nodo] := 0;
    end;
    FPrincipal.ActualizaEstadoNodos(nodo);
end;

//---------------------------------------------------------------------------
// ESCRIBE LA CONFIGURACION EN LOS NODOS
//---------------------------------------------------------------------------

procedure TFConfigNodo.EscribirOpciones(Sender: TObject);
var
    tacc, tal, dig, flags, flags2: Byte;
    nodo, i: Integer;
    d: dato;
    s: String;
begin
    // Recopila la información a grabar a los nodos
    tacc := ud_acc.Position;
    tal := ud_al.Position;
    dig := ud_dig.Position;
    flags := 0;
    if CheckValidar.Checked then flags := flags + $01;
    if CheckOnline.Checked then flags := flags + $02;
    if CheckAlarma.Checked then flags := flags + $04;
    if CheckPulsador.Checked then flags := flags + $08;
    if CheckFranjas.Checked then flags := flags + $10;
    if CheckSalida.Checked then flags := flags + $20;
    flags := flags + (RadioGroupLector.ItemIndex shl 6);

    // Agregado 13/03/2004 - en $04 bit 0 se almacena el nuevo flag de aviso de puerta abierta
    flags2 := 0;
    if CheckAvisoPuerta.Checked then flags2 := flags2 + $01;

    // Graba las opciones en los nodos seleccionados
    if ANodos.Selected.Level = 1 then
    begin
        // Busca número del nodo a escribir
        with data.Consulta do
        begin
           SQL.Clear;
           SQL.Add('SELECT Nod_num FROM Nodos WHERE Nod_nom = :nodo');
           ParambyName('nodo').AsString := ANodos.Selected.Text;
           Open;
           nodo := FieldbyName('Nod_num').AsInteger;
           Close;
        end;

        if p.Modelo(nodo, s) then
        begin
          // Escribe la configuración en el nodo
          d[0] := flags2;
          d[1] := tacc;
          d[2] := dig;
          d[3] := tal;
          d[4] := flags;
          if not p.Escribe_Memoria(nodo, p.UltimoBanco, DIR_FLAGS2, 5, d) then
          begin
             PlayWav('ERR');
             Application.MessageBox(PChar(ANodos.Selected.Text + ' no responde'), 'Offline', MB_OK + MB_ICONEXCLAMATION);
             FPrincipal.Nod_Status[nodo] := 1;
             FPrincipal.ActualizaEstadoNodos(nodo);
          end
          else
          begin
             p.Reset(nodo);
             FPrincipal.Nod_Status[nodo] := 0;
             FPrincipal.ActualizaEstadoNodos(nodo);
          end;
        end
        else
        begin
           PlayWav('ERR');
           Application.MessageBox(PChar(ANodos.Selected.Text + ' no responde'), 'Offline', MB_OK + MB_ICONEXCLAMATION);
           FPrincipal.Nod_Status[nodo] := 1;
           FPrincipal.ActualizaEstadoNodos(nodo);
        end;
    end
    else
    begin
        for i:=0 to ANodos.Items[0].Count-1 do
        begin
            // Busca número del nodo a escribir
            with data.Consulta do
            begin
               SQL.Clear;
               SQL.Add('SELECT Nod_num FROM Nodos WHERE Nod_nom = :nodo');
               ParambyName('nodo').AsString := ANodos.Items[0].Item[i].Text;
               Open;
               nodo := FieldbyName('Nod_num').AsInteger;
               Close;
            end;

            if p.Modelo(nodo, s) then
            begin
              // Escribe la configuración en el nodo
              d[0] := flags2;
              d[1] := tacc;
              d[2] := dig;
              d[3] := tal;
              d[4] := flags;
              if not p.Escribe_Memoria(nodo, p.UltimoBanco, DIR_FLAGS2, 5, d) then
              begin
                  PlayWav('ERR');
                  Application.MessageBox(PChar(ANodos.Items[0].Item[i].Text + ' no responde'), 'Offline', MB_OK + MB_ICONEXCLAMATION);
                  FPrincipal.Nod_Status[nodo] := 1;
              end
              else
              begin
                  PlayWav('INFO');
                  p.Reset(nodo);
                  FPrincipal.Nod_Status[nodo] := 0;
              end;
              FPrincipal.ActualizaEstadoNodos(nodo);
            end
            else
            begin
               PlayWav('ERR');
               Application.MessageBox(PChar(ANodos.Items[0].Item[i].Text + ' no responde'), 'Offline', MB_OK + MB_ICONEXCLAMATION);
               FPrincipal.Nod_Status[nodo] := 1;
               FPrincipal.ActualizaEstadoNodos(nodo);
            end;
        end;
    end;
end;

//---------------------------------------------------------------------------
// BORRA LOS HABILITADOS DE LOS NODOS SELECCIONADOS
//---------------------------------------------------------------------------

procedure TFConfigNodo.BorraHabClick(Sender: TObject);
var
    n, nodo : Integer;
begin
  if Application.MessageBox(PChar(
  'Desea borrar los habilitados de ' + ANodos.Selected.Text + '?'),
  'Pregunta', MB_YESNO + MB_ICONQUESTION) = ID_YES then
  begin
      // Consulta número del nodo a borrar
      with data.Consulta do
      begin
         SQL.Clear;
         SQL.Add('SELECT Nod_num FROM Nodos WHERE Nod_nom = :nodo');
         ParambyName('nodo').AsString := ANodos.Selected.Text;
         Open;
         nodo := FieldbyName('Nod_num').AsInteger;
         Close;
      end;

      if p.Even_Hab(nodo, BORRA, HAB, n) then
      begin
          PlayWav('INFO');
          EditHabils.Text := '0';
          FPrincipal.Nod_Status[nodo] := 0;
          FPrincipal.ActualizaEstadoNodos(nodo);
       end
      else
      begin
          PlayWav('ERR');
          Application.MessageBox(PChar(ANodos.Selected.Text + ' no responde'), 'Offline', MB_OK + MB_ICONEXCLAMATION);
          FPrincipal.Nod_Status[nodo] := 1;
          FPrincipal.ActualizaEstadoNodos(nodo);
      end;
  end;
end;

//---------------------------------------------------------------------------
// BORRA LOS EVENTOS DE LOS NODOS SELECCIONADOS
//---------------------------------------------------------------------------

procedure TFConfigNodo.BorraEvenClick(Sender: TObject);
var
    n, nodo : Integer;
begin
  if Application.MessageBox(PChar(
  'Desea borrar los eventos de ' + ANodos.Selected.Text + '?'),
  'Pregunta', MB_YESNO + MB_ICONQUESTION) = ID_YES then
  begin
      // Consulta número del nodo a borrar
      with data.Consulta do
      begin
         SQL.Clear;
         SQL.Add('SELECT Nod_num FROM Nodos WHERE Nod_nom = :nodo');
         ParambyName('nodo').AsString := ANodos.Selected.Text;
         Open;
         nodo := FieldbyName('Nod_num').AsInteger;
         Close;
      end;

      if p.Even_Hab(nodo, BORRA, EV, n) then
      begin
          PlayWav('INFO');
          EditEven.Text := '0';
          FPrincipal.Nod_Status[nodo] := 0;
          FPrincipal.ActualizaEstadoNodos(nodo);
      end
      else
      begin
          PlayWav('ERR');
          Application.MessageBox(PChar(ANodos.Selected.Text + ' no responde'), 'Offline', MB_OK + MB_ICONEXCLAMATION);
          FPrincipal.Nod_Status[nodo] := 1;
          FPrincipal.ActualizaEstadoNodos(nodo);
      end;
  end;
end;

//---------------------------------------------------------------------------
// INICIA LA PRUEBA DE COMUNICACION
//---------------------------------------------------------------------------

procedure TFConfigNodo.GroupBoxModeloDblClick(Sender: TObject);
begin
   if ANodos.Selected.Level = 1 then
   begin
     Application.CreateForm(TFTest, FTest);
     FTest.ShowModal;
     FTest.Free;
   end;
end;

procedure TFConfigNodo.Track1Change(Sender: TObject);
begin
    LabelHab.Caption := 'Habilitados = ' + IntToStr((Track1.Position + 1) * 25);
    LabelEv.Caption := 'Eventos = ' + IntToStr((p.UltimoBanco - 4 - Track1.Position) * 25);
end;

procedure TFConfigNodo.btnGrabarRelClick(Sender: TObject);
var
   n: Integer;
   d: dato;
   s: String;
begin
    if Application.MessageBox('Al grabar esta información se borrarán todos los habilitados y eventos en el nodo.'#13'Desea realizar esta operación?', 'Advertencia', MB_YESNO + MB_ICONQUESTION) = IDYES then
    begin
      // Busca número del nodo a escribir
      with data.Consulta do
      begin
         SQL.Clear;
         SQL.Add('SELECT Nod_num FROM Nodos WHERE Nod_nom = :nodo');
         ParambyName('nodo').AsString := ANodos.Selected.Text;
         Open;
         nodo := FieldbyName('Nod_num').AsInteger;
         Close;
      end;

      if p.Modelo(nodo, s) then
      begin
        // Escribe la relación en el nodo
        d[0] := Track1.Position;
        if not p.Escribe_Memoria(nodo, p.UltimoBanco, DIR_RELAC, 1, d) then
        begin
            PlayWav('ERR');
            Application.MessageBox(PChar(ANodos.Selected.Text + ' no responde'), 'Offline', MB_OK + MB_ICONEXCLAMATION);
            FPrincipal.Nod_Status[nodo] := 1;
            FPrincipal.ActualizaEstadoNodos(nodo);
        end
        else
        begin
            p.Even_Hab(nodo, BORRA, HAB, n);
            EditHabils.Text := '0';
            p.Even_Hab(nodo, BORRA, EV, n);
            EditEven.Text := '0';
            p.Reset(nodo);
            FPrincipal.Nod_Status[nodo] := 0;
            FPrincipal.ActualizaEstadoNodos(nodo);
        end;
      end
      else
      begin
          PlayWav('ERR');
          Application.MessageBox(PChar(ANodos.Selected.Text + ' no responde'), 'Offline', MB_OK + MB_ICONEXCLAMATION);
          FPrincipal.Nod_Status[nodo] := 1;
          FPrincipal.ActualizaEstadoNodos(nodo);
      end;
    end;
end;

procedure TFConfigNodo.GroupBoxHabDblClick(Sender: TObject);
var
   s: String;
   nodo: Integer;
begin
    // Busca número del nodo a escribir
    with data.Consulta do
    begin
       SQL.Clear;
       SQL.Add('SELECT Nod_num FROM Nodos WHERE Nod_nom = :nodo');
       ParambyName('nodo').AsString := ANodos.Selected.Text;
       Open;
       nodo := FieldbyName('Nod_num').AsInteger;
       Close;
    end;

    if p.Lee_ID_Ultima_Subida(nodo, s) then ShowMessage(s);
end;

end.
