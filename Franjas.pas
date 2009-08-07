//---------------------------------------------------------------------------
//
//  Módulo de Franjas Horarias (Definición, Grupos y Asignación)
//
//
//  Inicio de Módulo 05-03-2001
//  Pintado de zonas 06-03-2001
//  Creación de tabla de franjas completa 07-03-2001
//  Asignación de grupos de franjas 12-03-2001
//  Asignación de personas a grupos de franjas 13-03-2001
//  Finalización de interfase 14-03-2001
//  Transmisión de franjas a los nodos 28-04-2001
//  Corrección: Siempre cargaba 3 franjas, hasta en modo full 30-06-2003
//
//  A hacer:
//
//---------------------------------------------------------------------------

unit Franjas;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  ComCtrls, StdCtrls, ImgList, Grids, ExtCtrls, Buttons;

type
  TFFranjas = class(TForm)
    imgFranjas: TImageList;
    Timer1: TTimer;
    Contenedor: TPageControl;
    Hoja1: TTabSheet;
    Hoja2: TTabSheet;
    Hoja3: TTabSheet;
    GroupBox1: TGroupBox;
    Label1: TLabel;
    Labelhs0: TLabel;
    Label2: TLabel;
    btnGrabar: TSpeedButton;
    btnSalir: TSpeedButton;
    btnEditar: TSpeedButton;
    btnCancelar: TSpeedButton;
    btnTransmitir: TSpeedButton;
    LFranjas: TListView;
    Grid: TDrawGrid;
    barra: TStatusBar;
    GroupBox2: TGroupBox;
    GroupBox3: TGroupBox;
    LGrupos: TListView;
    Label3: TLabel;
    Label4: TLabel;
    LFranjas2: TListView;
    btnNuevoGrupo: TSpeedButton;
    btnBorraGrupo: TSpeedButton;
    SpeedButton1: TSpeedButton;
    barra2: TStatusBar;
    btnCambiaNombre: TSpeedButton;
    Label5: TLabel;
    Label6: TLabel;
    LGrupos2: TListView;
    SpeedButton2: TSpeedButton;
    barra3: TStatusBar;
    LPersonas: TListView;
    Label7: TLabel;
    Label8: TLabel;
    Label9: TLabel;
    procedure FormShow(Sender: TObject);
    procedure GridMouseMove(Sender: TObject; Shift: TShiftState; X, Y: Integer);
    procedure GridMouseDown(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
    procedure GridMouseUp(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
    procedure GridDrawCell(Sender: TObject; ACol, ARow: Integer; Rect: TRect; State: TGridDrawState);
    procedure LFranjasChange(Sender: TObject; Item: TListItem;  Change: TItemChange);
    procedure btnSalirClick(Sender: TObject);
    procedure btnEditarClick(Sender: TObject);
    procedure btnGrabarClick(Sender: TObject);
    procedure btnCancelarClick(Sender: TObject);
    procedure MuestraDesc(Sender: TObject; Shift: TShiftState; X, Y: Integer);
    procedure Timer1Timer(Sender: TObject);
    procedure ContenedorChange(Sender: TObject);
    procedure btnNuevoGrupoClick(Sender: TObject);
    procedure LGruposEdited(Sender: TObject; Item: TListItem; var S: String);
    procedure btnBorraGrupoClick(Sender: TObject);
    procedure btnCambiaNombreClick(Sender: TObject);
    procedure LGruposChange(Sender: TObject; Item: TListItem; Change: TItemChange);
    procedure LGruposMouseDown(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
    procedure LFranjas2DragOver(Sender, Source: TObject; X, Y: Integer; State: TDragState; var Accept: Boolean);
    procedure LFranjas2DragDrop(Sender, Source: TObject; X, Y: Integer);
    procedure LFranjas2MouseDown(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
    procedure LPersonasMouseDown(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
    procedure LGrupos2DragOver(Sender, Source: TObject; X, Y: Integer; State: TDragState; var Accept: Boolean);
    procedure LGrupos2Click(Sender: TObject);
    procedure LGrupos2KeyUp(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure LGrupos2DragDrop(Sender, Source: TObject; X, Y: Integer);
    procedure LGruposEditing(Sender: TObject; Item: TListItem; var AllowEdit: Boolean);
    procedure LGruposClick(Sender: TObject);
    procedure btnTransmitirClick(Sender: TObject);
    procedure FormActivate(Sender: TObject);
    procedure FormHide(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
  private
    { Private declarations }
    dibujar: Boolean;
    salir: Boolean;
    editando: Boolean;
    procedure Carga_Franjas;
    procedure Crea_hs;
  public
    { Public declarations }
    procedure AppActivate(Sender: TObject);
  end;

const
     VERDE = $1AC81A;
     VERDECLARO = $40C840;

var
  FFranjas: TFFranjas;
  pinta : Boolean = False;
  borra : Boolean = False;
  franja : record
       nom : String[40];
       desc : String[80];
       dat : String[192];
  end;

implementation

uses Datos, Serkey, Rutinas, Comunicaciones;

{$R *.DFM}

//---------------------------------------------------------------------------
// INICIALIZA MÓDULO DE FRANJAS
//---------------------------------------------------------------------------

procedure TFFranjas.FormShow(Sender: TObject);
begin
   Contenedor.ActivePageIndex := 0;

   Carga_Franjas;     // Carga las franjas en la lista
   Crea_hs;           // Inicializa labels de las horas

   LFranjas.SetFocus;

   dibujar := True;
   salir := True;
   editando := False;
   Application.OnActivate := AppActivate; 
end;

//---------------------------------------------------------------------------
// AL CARGAR VENTANA, MUESTRA DATOS DE PRIMERA FRANJA
//---------------------------------------------------------------------------

procedure TFFranjas.Timer1Timer(Sender: TObject);
begin
   LFranjasChange(LFranjas, LFranjas.Items[0], ctState);
   Timer1.Enabled := False;
end;

//---------------------------------------------------------------------------
// SALE DE LA VENTANA DE FRANJAS
//---------------------------------------------------------------------------

procedure TFFranjas.btnSalirClick(Sender: TObject);
begin
   ModalResult := mrCancel;
end;

//---------------------------------------------------------------------------
// AL CAMBIAR DE PÁGINA, PINTA FRANJA ACTUAL
//---------------------------------------------------------------------------

procedure TFFranjas.ContenedorChange(Sender: TObject);
begin
     if Contenedor.ActivePageIndex = 0 then
       if LFranjas.Selected <> nil then
         LFranjasChange(LFranjas, LFranjas.Selected, ctState)

     else if Contenedor.ActivePageIndex = 1 then
       if LGrupos.Selected <> nil then
         LGruposChange(LGrupos, LGrupos.Selected, ctState);
end;

//---------------------------------------------------------------------------
// CARGA LAS TABLA DE GRUPOS, FRANJAS Y PERSONAS
//---------------------------------------------------------------------------

procedure TFFranjas.Carga_Franjas;
var
   I : TListItem;             // Variable item de la lista
   n: Integer;
   MAX: Integer;
begin
   LFranjas.Items.Clear;      // Borra todos los items de la lista
   LFranjas2.Items.Clear;

   // Realiza consulta de todas las franjas
   with data.Consulta do
   begin
      SQL.Text := ('SELECT Fr_nom FROM Franjas');
      Open;

      // Corrección 30/06/2003
      // En modo descargador sólo carga 3 franjas
      if llave.modofull then MAX := 16
      else                   MAX := 3;

      // Recorre todos los registros
      n := 1;
      while not Eof do
      begin
         // En modo descargador sólo carga 3 franjas
         if n <= MAX then
         begin
           // Agrega items a la lista
           I := LFranjas.Items.Add;
           I.Caption := FieldbyName('Fr_nom').AsString;
           I.ImageIndex := 0;

           I := LFranjas2.Items.Add;
           I.Caption := FieldbyName('Fr_nom').AsString;
           I.ImageIndex := 0;
         end;

         Next;
         inc(n);
      end;

      Close;

      // Selecciona la primera franja
      LFranjas.Selected := LFranjas.Items[0];
   end;

   with data.Consulta do
   begin
      SQL.Clear;
      SQL.Add('SELECT Gf_nom FROM GruposFranjas ORDER BY Gf_nom');
      Open;

      // Recorre todos los registros
      while not Eof do
      begin
          I := LGrupos.Items.Add;
          I.Caption := FieldbyName('Gf_nom').AsString;
          I.ImageIndex := 1;

          I := LGrupos2.Items.Add;
          I.Caption := FieldbyName('Gf_nom').AsString;
          I.ImageIndex := 1;

          Next;
      end;

      Close;

      LGrupos.Selected := LGrupos.Items[0];
   end;
end;

//---------------------------------------------------------------------------
// CREA LABELS DE LAS HORAS
//---------------------------------------------------------------------------

procedure TFFranjas.Crea_hs;
var
   i : Integer;
   x, y : Integer;
   lbl : TLabel;
begin
   x := Labelhs0.Left;
   y := Labelhs0.Top;
   for i:=1 to 24 do
   begin
      lbl := TLabel.Create(Self);
      with lbl do
      begin
        Left := x;
        y := y + 2 * (Grid.DefaultRowHeight+1);
        Top := y;
        Caption := Format('%d hs', [i]);
        Name := 'Labelhs' + InttoStr(i);
        Parent := Labelhs0.Parent;
        if (i mod 4) = 0 then Font.Style := [fsBold];
      end;
   end;
end;

//---------------------------------------------------------------------------
// AL CAMBIAR DE FRANJA, ACTUALIZA DATOS
//---------------------------------------------------------------------------

procedure TFFranjas.LFranjasChange(Sender: TObject; Item: TListItem; Change: TItemChange);
var
   i : Integer;
   fila, col : Integer;
   dat : Integer;
   r : TRect;
begin
  // Entra si cambia de estado
  if Change = ctState then
  begin
    // Busca datos de la franja seleccionada en la tabla
    with data.Consulta do
    begin
       SQL.Text := ('SELECT * FROM Franjas WHERE Fr_nom = :nombre');
       ParambyName('nombre').AsString := Item.Caption;
       Open;
       with franja do
       begin
          nom := FieldbyName('Fr_nom').AsString;
          desc := FieldbyName('Fr_desc').AsString;
          dat := FieldbyName('Fr_dat').AsString;
       end;
       Close;

       barra.SimpleText := franja.desc;
    end;

    // Recorre todas las horas de todos los días (192 celdas)
    // Pinta las franjas habilitadas para ese horario
    for i:=0 to 191 do
    begin
       col := i div 24;                  // calcula columna
       fila := (i mod 24) * 2;           // calcula fila
       dat := StrtoInt(franja.dat[i+1]); // obtiene dato de franja

       // Pinta la primera 1/2 hora
       r := Grid.CellRect(col, fila);
       r.Top := r.Top + 3;
       r.Left := r.Left + 3;
       r.Bottom := r.Bottom - 1;
       r.Right := r.Right - 1;
       if ((dat and $01) = $01) then Grid.Canvas.Brush.Color := VERDE
       else                          Grid.Canvas.Brush.Color := Grid.Color;
       Grid.Canvas.FillRect(r);

       // Pinta la segunda 1/2 hora
       r := Grid.CellRect(col, fila+1);
       r.Top := r.Top + 3;
       r.Left := r.Left + 3;
       r.Bottom := r.Bottom - 1;
       r.Right := r.Right - 1;
       if ((dat and $02) = $02) then Grid.Canvas.Brush.Color := VERDE
       else                          Grid.Canvas.Brush.Color := Grid.Color;
       Grid.Canvas.FillRect(r);
    end;

    // Deshabilita botones
    btnGrabar.Enabled := editando;
    btnCancelar.Enabled := editando;
    btnEditar.Enabled := (Item.Index <> 0) and (not editando);
    LFranjas.Enabled := not editando;
    btnEditar.Enabled := not editando;
    btnTransmitir.Enabled := not editando;
    btnSalir.Enabled := not editando;
    Contenedor.Pages[1].TabVisible := not editando;
    Contenedor.Pages[2].TabVisible := not editando;
    salir := not editando;
  end;
end;

//---------------------------------------------------------------------------
// DIBUJA LAS CELDAS
//---------------------------------------------------------------------------

procedure TFFranjas.GridDrawCell(Sender: TObject; ACol, ARow: Integer; Rect: TRect; State: TGridDrawState);
var
  x, y : Integer;
begin
 with Grid.Canvas do
 begin
    // Dibuja las líneas verticales entre celdas
    if ACol <> 0 then
    begin
      x := ACol * (Grid.DefaultColWidth+1);
      y := ARow * (Grid.DefaultRowHeight+1);
      Pen.Color := clRed;
      Moveto(x, y);
      Lineto(x, y + (Grid.DefaultRowHeight+1));
    end;

    // Dibuja las líneas horizontales entre celdas
    if ARow <> 0 then
    begin
      x := ACol * (Grid.DefaultColWidth+1);
      y := ARow * (Grid.DefaultRowHeight+1);

      if (ARow mod 8) = 0 then Pen.Color := clBlue
      else if (ARow mod 2) = 0 then Pen.Color := clBlack
      else Pen.Color := $CBCBCB;

      //if (ARow mod 8) = 0 then Pen.Width := 2 else Pen.Width := 1;
      //if (ARow mod 2) = 0 then Pen.Style := psSolid else Pen.Style := psSolid;

      Moveto(x, y);
      Lineto(x + (Grid.DefaultColWidth+1), y);
    end;
 end;
end;

//---------------------------------------------------------------------------
// INICIA PINTADO DE CELDA AL PRESIONAR BOTÓN DEL MOUSE
//---------------------------------------------------------------------------

procedure TFFranjas.GridMouseDown(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
   // La primera franja no es editable
   if LFranjas.Selected.Index = 0 then
      Application.MessageBox('La franja Sin Restricciones no se puede modificar', 'Mensaje', MB_OK + MB_ICONHAND)
   else
   begin
     pinta := (Button = mbLeft);  // Botón izquierdo = pinta
     borra := (Button = mbRight); // Botón derecho = borra
     GridMouseMove(Self, [], X, Y);
   end;
end;

//---------------------------------------------------------------------------
// FINALIZA EL PINTADO AL SOLTAR EL BOTÓN DEl MOUSE
//---------------------------------------------------------------------------

procedure TFFranjas.GridMouseUp(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
   pinta := False;
   borra := False;
end;

//---------------------------------------------------------------------------
// PINTA O DESPINTA LA CELDA AL MOVERSE SOBRE ELLA
//---------------------------------------------------------------------------

procedure TFFranjas.GridMouseMove(Sender: TObject; Shift: TShiftState; X, Y: Integer);
var
   ACol, ARow : Integer;
   r : TRect;
   dat : Integer;
   dia, hora, estado : String;

begin
   // Calcula fila y columna bajo el mouse
   Grid.MousetoCell(X, Y, ACol, ARow);

   //ShowMessage(Format('%d %d', [ACol, ARow]));
   if (ACol>=0) and (ACol<=7) and (ARow>=0) and (ARow<=47) then
   begin
     if pinta or borra then
     begin
        // Pinta o despinta franja
        r := Grid.CellRect(ACol, ARow);
        r.Top := r.Top + 3;
        r.Left := r.Left + 3;
        r.Bottom := r.Bottom - 1;
        r.Right := r.Right - 1;
        if pinta then   Grid.Canvas.Brush.Color := VERDE
        else            Grid.Canvas.Brush.Color := Grid.Color;
        Grid.Canvas.FillRect(r);

        {r := Grid.CellRect(ACol, ARow);
        GridDrawCell(Grid, ACol, ARow, r, []);
        r := Grid.CellRect(ACol, ARow+1);
        GridDrawCell(Grid, ACol, ARow, r, []);}

        // Actualiza franja actual
        dat := StrtoInt(franja.dat[(ACol*24)+(ARow div 2)+1]);
        if pinta then
        begin
             if (ARow mod 2) = 0 then dat := dat or $01
             else                     dat := dat or $02;
        end
        else
        begin
             if (ARow mod 2) = 0 then dat := dat and not $01
             else                     dat := dat and not $02;
        end;
        franja.dat[(ACol*24)+(ARow div 2)+1] := InttoStr(dat)[1];

        // Habilita botones
        btnGrabar.Enabled := True;
        btnCancelar.Enabled := True;

        // Deshabilita hasta grabar o cancelar
        LFranjas.Enabled := False;
        btnEditar.Enabled := False;
        btnTransmitir.Enabled := False;
        btnSalir.Enabled := False;
        Contenedor.Pages[1].TabVisible := False;
        Contenedor.Pages[2].TabVisible := False;
        salir := False;
     end;

     case ACol of
     0: dia := 'Domingo';
     1: dia := 'Lunes';
     2: dia := 'Martes';
     3: dia := 'Miércoles';
     4: dia := 'Jueves';
     5: dia := 'Viernes';
     6: dia := 'Sábado';
     7: dia := 'Feriado';
     end;
     hora := Format('%2.2d:%2.2d a %2.2d:%2.2d', [ARow div 2, (ARow mod 2)*30 , ARow div 2, (ARow mod 2)*30+29]);

     dat := StrtoInt(franja.dat[(ACol*24)+(ARow div 2)+1]);
     if (dat and ((ARow mod 2)+1)) <> 0 then estado := 'Habilitado'
     else                                    estado := 'No habilitado';

     barra.SimpleText := '[' + dia + '] ' + hora + ' ' + estado;
   end;

   if dibujar and LFranjas.Enabled then
   begin
      LFranjasChange(LFranjas, LFranjas.Selected, ctState);
      dibujar := False;
   end;
end;

//---------------------------------------------------------------------------
// MUESTRA DESCRIPCIÓN DE LA FRANJA
//---------------------------------------------------------------------------

procedure TFFranjas.MuestraDesc(Sender: TObject; Shift: TShiftState;
  X, Y: Integer);
begin
   barra.SimpleText := franja.desc;
   borra := False;
   pinta := False;

   dibujar := True;
end;

//---------------------------------------------------------------------------
// EDITA EL NOMBRE DE LA FRANJA ACTUAL
//---------------------------------------------------------------------------

procedure TFFranjas.btnEditarClick(Sender: TObject);
var
   nom, desc : String;
begin
    if LFranjas.Selected <> nil then
    begin
      nom := InputBox('Nuevo nombre', 'Ingrese nuevo nombre de franja:', LFranjas.Selected.Caption);
      desc := InputBox('Nueva descripción', 'Ingrese nueva descripción de franja:', barra.SimpleText);

      // Actualiza tabla de franjas
      with data.Consulta do
      begin
         SQL.Clear;
         SQL.Add('UPDATE Franjas SET Fr_nom = "' + nom + '" ');
         SQL.Add('WHERE Fr_nom = "' + LFranjas.Selected.Caption + '"');
         ExecSQL;

         SQL.Clear;
         SQL.Add('UPDATE Franjas SET Fr_desc = "' + desc + '" ');
         SQL.Add('WHERE Fr_desc = "' + barra.SimpleText + '"');
         ExecSQL;
      end;

      // Actualiza franja actual
      LFranjas.Selected.Caption := nom;
      barra.SimpleText := desc;
    end;
end;

//---------------------------------------------------------------------------
// GRABA LOS DATOS DE LA FRANJA ACTUAL
//---------------------------------------------------------------------------

procedure TFFranjas.btnGrabarClick(Sender: TObject);
begin
    // Actualiza franja actual
    with data.Consulta do
    begin
       SQL.Clear;
       SQL.Add('UPDATE Franjas SET Fr_dat = "' + franja.dat + '" ');
       SQL.Add('WHERE Fr_nom = "' + LFranjas.Selected.Caption + '"');
       ExecSQL;
    end;

    // Deshabilita botones
    btnGrabar.Enabled := False;
    btnCancelar.Enabled := False;

    // Habilita controles
    LFranjas.Enabled := True;
    btnEditar.Enabled := True;
    btnTransmitir.Enabled := True;
    btnSalir.Enabled := True;
    Contenedor.Pages[1].TabVisible := True;
    Contenedor.Pages[2].TabVisible := True;
    salir := True;
    editando := False;
end;

//---------------------------------------------------------------------------
// CANCELA LA EDICIÓN DE LA FRANJA ACTUAL
//---------------------------------------------------------------------------

procedure TFFranjas.btnCancelarClick(Sender: TObject);
begin
    LFranjasChange(LFranjas, LFranjas.Selected, ctState);

    // Habilita controles
    LFranjas.Enabled := True;
    btnEditar.Enabled := True;
    btnTransmitir.Enabled := True;
    btnSalir.Enabled := True;
    Contenedor.Pages[1].TabVisible := True;
    Contenedor.Pages[2].TabVisible := True;
    salir := True;
    editando := False;
end;

//---------------------------------------------------------------------------
// DA DE ALTA UN NUEVO GRUPO DE FRANJAS
//---------------------------------------------------------------------------

procedure TFFranjas.btnNuevoGrupoClick(Sender: TObject);
var
    I : TListItem;
    numero, k : Integer;
    nombre : String;
    existe : Boolean;
begin
  // Entra sólo si está habilitada la función
  if True {Habilitada(1, 2)} then
  begin
    with data.Consulta do
    begin
        // Busca próximo número de grupo disponible empezando en 1
        SQL.Text := 'SELECT Gf_num FROM GruposFranjas WHERE Gf_num = :numgrupo';

        numero := 1;
        existe := True;
        while existe do
        begin
            ParambyName('numgrupo').AsInteger := numero;
            Open;
            if RecordCount = 0 then existe := False
            else inc(numero);
            Close;
        end;

        // Si existe el grupo Nuevo Grupo, le pone un número consecutivo
        SQL.Text := 'SELECT Gf_nom FROM GruposFranjas WHERE Gf_nom = :nombre';
        ParambyName('nombre').AsString := 'Nuevo Grupo';

        Open;
        if RecordCount <> 0 then
        begin
            Close;
            k := 0;
            existe := True;
            while existe do
            begin
                ParambyName('nombre').AsString := 'Nuevo Grupo ' + InttoStr(k);
                Open;
                if RecordCount = 0 then existe := False
                else inc(k);
                Close;
            end;
            nombre := 'Nuevo Grupo ' + InttoStr(k);
        end
        else
        begin
            Close;
            nombre := 'Nuevo Grupo';
        end;
    end;

    // Agrega a la base nuevo Grupo
    with data.Consulta do
    begin
       SQL.Clear;
       SQL.Add('INSERT INTO GruposFranjas (Gf_nom, Gf_num, Gf_fra)');
       SQL.Add('VALUES ("' + nombre + '", ' + InttoStr(numero) + ', 1)');
       ExecSQL;
    end;

    // Agrega item a la listas de Grupos
    I := LGrupos2.Items.Add;
    I.Caption := nombre;
    I.ImageIndex := 1;

    I := LGrupos.Items.Add;
    I.Caption := nombre;
    I.ImageIndex := 1;
    I.EditCaption;
  end;
end;

//---------------------------------------------------------------------------
// CAMBIA EL NOMBRE DE UN GRUPO EXISTENTE EN LA BASE
//---------------------------------------------------------------------------

procedure TFFranjas.LGruposEdited(Sender: TObject; Item: TListItem;
  var S: String);
var
   existe : Boolean;
begin
    // Busca si el nuevo nombre del grupo ya existe
    with data.Consulta do
    begin
      SQL.Clear;
      SQL.Add('SELECT Gf_nom FROM GruposFranjas WHERE Gf_nom = :nombre');
      ParambyName('nombre').AsString := S;
      Open;
      if RecordCount <> 0 then        existe := True
      else                            existe := False;
      Close;
    end;

    // Si no encuentra el nombre del grupo lo cambia al nuevo
    if not existe then
    begin
        with data.Consulta do
        begin
           SQL.Clear;
           SQL.Add('UPDATE GruposFranjas SET Gf_nom = "' + S + '" ');
           SQL.Add('WHERE Gf_nom = "' + Item.Caption + '"');
           ExecSQL;
        end;

        // Cambia el nombre del item (grupo)
        LGrupos2.FindCaption(0, Item.Caption, False, True, False).Caption := S;
        Item.Caption := S;
    end
    else
    begin
        // Si está repetido, mensaje indicando
        Application.MessageBox(PChar('El grupo ' + S + ' ya existe'), 'Advertencia', MB_OK + MB_ICONINFORMATION);

        // No cambia el nombre del grupo
        S := Item.Caption;
    end;
end;

//---------------------------------------------------------------------------
// BORRA UN GRUPO EXISTENTE
//---------------------------------------------------------------------------

procedure TFFranjas.btnBorraGrupoClick(Sender: TObject);
var
   vacio : Boolean;
begin
  // Entra sólo si está habilitada la función
  if True {Habilitada(1, 3)} then
  begin
    // Entra solo si hay un item seleccionado
    if LGrupos.Selected = nil then
       Application.MessageBox('Para borrar un grupo debe seleccionarlo', 'Información', MB_OK + MB_ICONEXCLAMATION)
    else
    begin
       if LGrupos.Selected.Caption = 'Sin Restricciones' then
          Application.MessageBox('El Grupo de franjas "Sin Restricciones"'#13'no se puede borrar', 'Advertencia', MB_OK + MB_ICONINFORMATION)
       else
       begin
         // Confirma borrado
         if Application.MessageBox(PChar('Está seguro que quiere borrar el grupo de franjas ' +
            LGrupos.Selected.Caption + '?'),
            'Advertencia', MB_YESNO + MB_ICONQUESTION) = ID_YES then
         begin
           // Consulta si el grupo a borrar tiene personas dentro
           with data.Consulta do
           begin
               SQL.Clear;
               SQL.Add('SELECT Usr_nom FROM Usuarios');
               SQL.Add('INNER JOIN GruposFranjas ON (Usr_fra = Gf_num)');
               SQL.Add('WHERE Gf_nom = :grupo');
               ParambyName('grupo').AsString := LGrupos.Selected.Caption;
               Open;
               vacio := (RecordCount = 0);
               Close;
           end;

           // Si tiene personas abajo, no lo borra
           if not vacio then
                  Application.MessageBox(PChar('El Grupo ' +
                              LGrupos.Selected.Caption +
                              ' tiene personas asignadas.' + #13 +
                              'Es imposible borrarlo hasta reasignar' +
                              ' las personas.'), 'Advertencia', MB_OK + MB_ICONQUESTION)
           else
           begin
                // Borra grupo de la base
                with data.Consulta do
                begin
                     SQL.Clear;
                     SQL.Add('DELETE FROM GruposFranjas');
                     SQL.Add('WHERE Gf_nom = "' + LGrupos.Selected.Caption + '"');
                     ExecSQL;
                end;

                // Borra grupo de la lista de grupos
                LGrupos2.Items.Delete(LGrupos.Selected.Index);
                LGrupos.Items.Delete(LGrupos.Selected.Index);
           end;
         end;
       end;
    end;
  end;
end;

//---------------------------------------------------------------------------
// PERMITE CAMBIAR EL NOMBRE DE UN GRUPO
//---------------------------------------------------------------------------

procedure TFFranjas.btnCambiaNombreClick(Sender: TObject);
begin
  // Entra si está habilitada la función
  if True {Habilitada(1, 4)} then
  begin
      // Si hay algún nodo seleccionado, edita su nombre
      if LGrupos.Selected <> nil then
      begin
           if LGrupos.Selected.Caption = 'Sin Restricciones' then
              Application.MessageBox('El Grupo de franjas "Sin Restricciones"'#13'no se puede cambiar de nombre', 'Advertencia', MB_OK + MB_ICONINFORMATION)
           else
              LGrupos.Selected.EditCaption;
      end
      else
          Application.MessageBox('Para editar el nombre de un grupo debe seleccionarlo', 'Información', MB_OK + MB_ICONEXCLAMATION);
  end;
end;

//---------------------------------------------------------------------------
// MUESTRA FRANJA ACTUAL ASIGNADA
//---------------------------------------------------------------------------

procedure TFFranjas.LGruposChange(Sender: TObject; Item: TListItem; Change: TItemChange);
var
   S : String;
begin
   if Change = ctState then
   begin
     with data.Consulta do
     begin
        SQL.Clear;
        SQL.Add('SELECT Fr_nom, Fr_desc FROM Franjas');
        SQL.Add('INNER JOIN GruposFranjas ON (Gf_fra = Fr_num)');
        SQL.Add('WHERE Gf_nom = :franja');
        ParambyName('franja').AsString := Item.Caption;

        Open;
        S := FieldbyName('Fr_nom').AsString;
        barra2.SimpleText := FieldbyName('Fr_desc').AsString;
        Close;
     end;

     LFranjas.Selected := LFranjas2.FindCaption(0, S, False, True, False);
   end;
end;

//---------------------------------------------------------------------------
// INICIA LA ASIGNACIÓN DEL GRUPO A UNA FRANJA
//---------------------------------------------------------------------------

procedure TFFranjas.LGruposMouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
var
   HT: THitTests;
begin
   // Si está presionado el botón izquierdo del mouse
   if (Button = mbLeft) then
   begin
     // Obtiene info de desde donde se hace el drag
     with LGrupos do
     begin
          HT := GetHitTestInfoAt(X, Y);
          if (HT - [htOnItem, htOnIcon, htOnLabel] <> HT) then BeginDrag(False, -1)
          else EndDrag(True);
     end;
   end
   else LGrupos.EndDrag(True);
end;

//---------------------------------------------------------------------------
// ACEPTA O NO LA ASIGNACIÓN
//---------------------------------------------------------------------------

procedure TFFranjas.LFranjas2DragOver(Sender, Source: TObject; X,
  Y: Integer; State: TDragState; var Accept: Boolean);
begin
  Accept := True {Habilitada(1, 7, False)} and
            ((Source as TComponent).Name = 'LGrupos') and
            ((Source as TListView).Selected <> nil) and
            ((Sender as TListView).GetItemAt(X,Y) <> nil);
end;

//---------------------------------------------------------------------------
// REALIZA EL CAMBIO DE FRANJA DEL GRUPO SOLTADO
//---------------------------------------------------------------------------

procedure TFFranjas.LFranjas2DragDrop(Sender, Source: TObject; X,
  Y: Integer);
var
    Destino: TListItem;
    HT: THitTests;
    Franja : String;
begin
    if LGrupos.Selected.Caption = 'Sin Restricciones' then
       Application.MessageBox('El Grupo de franjas "Sin Restricciones"'#13'no se puede cambiar de franja', 'Advertencia', MB_OK + MB_ICONINFORMATION)
    else
    begin
      // Busca sobre que elemento se tiró el objeto
      HT := LFranjas.GetHitTestInfoAt(X, Y);

      // Encuentra Grupo destino
      Destino := LFranjas.GetItemAt(X, Y);

      // Solo mueve persona de grupo si se tiró sobre el icono o item
      if (HT - [htOnItem, htOnIcon, htOnLabel] <> HT) then
      begin
         if Application.MessageBox(PChar('Está seguro que quiere asignar el grupo ' +
            LGrupos.Selected.Caption + ' a la franja ' + Destino.Caption + '?'),
            'Advertencia', MB_YESNO + MB_ICONQUESTION) = ID_YES then
         begin
            with data.Consulta do
            begin
              // Busca nuevo número de franja
              SQL.Clear;
              SQL.Add('SELECT Fr_num FROM Franjas');
              SQL.Add('WHERE Fr_nom = "' + Destino.Caption + '"');
              Open;
              Franja := InttoStr(FieldbyName('Fr_num').AsInteger);
              Close;

              // Actualiza cambio de franja en tabla de grupos
              SQL.Clear;
              SQL.Add('UPDATE GruposFranjas SET Gf_fra = ' + Franja + ' ');
              SQL.Add('WHERE Gf_nom = "' + LGrupos.Selected.Caption + '"');
              ExecSQL;
            end;

            LGruposChange(LGrupos, LGrupos.Selected, ctState);
         end;
      end;
    end;
end;

//---------------------------------------------------------------------------
// EDITA LA FRANJA QUE SE HIZO DOBLE CLIC
//---------------------------------------------------------------------------

procedure TFFranjas.LFranjas2MouseDown(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
   if (Button = mbLeft) and (ssDouble in Shift) and (LFranjas2.GetItemAt(X,Y) <> nil) then
   begin
      Contenedor.ActivePageIndex := 0;
      LFranjas.Selected := LFranjas.FindCaption(0, LFranjas2.GetItemAt(X,Y).Caption, False, True, False);
      LFranjasChange(LFranjas, LFranjas.Selected, ctState);
   end;
end;

//---------------------------------------------------------------------------
// MUESTRA PERSONAS ASIGNADAS AL GRUPO SELECCIONADO
//---------------------------------------------------------------------------

procedure TFFranjas.LGrupos2Click(Sender: TObject);
var
   I : TListItem;             // Variable item de la lista
begin
   if (LGrupos2.Selected <> nil) then
   begin
      LPersonas.Items.Clear;

      // Realiza consulta de las personas de ese grupo
      with data.Consulta do
      begin
         SQL.Clear;
         SQL.Add('SELECT Usr_nom FROM Usuarios');
         SQL.Add('INNER JOIN GruposFranjas ON (Usr_fra = Gf_num)');
         SQL.Add('WHERE Gf_nom = :grupo');
         ParambyName('grupo').AsString := LGrupos2.Selected.Caption;
         Open;

         barra3.SimpleText := Format('Grupo %s tiene %d personas asignadas', [LGrupos2.Selected.Caption, RecordCount]);

         // Recorre todos los registros
         while not Eof do
         begin
             // Agrega items a la lista
             I := LPersonas.Items.Add;
             I.Caption := FieldbyName('Usr_nom').AsString;
             I.ImageIndex := 2;

             Next;
         end;

         Close;
      end;
   end;
end;

procedure TFFranjas.LGrupos2KeyUp(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
     LGrupos2Click(LGrupos2);
end;

//---------------------------------------------------------------------------
// INICIA DRAG DE PERSONA PARA CAMBIARLA DE GRUPO
//---------------------------------------------------------------------------

procedure TFFranjas.LPersonasMouseDown(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
var
   HT: THitTests;
begin
   // Si está presionado el botón izquierdo del mouse
   if (ssLeft in Shift) then
   begin
     // Obtiene info de desde donde se hace el drag
     with LPersonas do
     begin
        HT := GetHitTestInfoAt(X, Y);
        if (HT - [htOnItem, htOnIcon, htOnLabel] <> HT) then BeginDrag(False, -1)
        else EndDrag(True);
     end;
   end
   else LPersonas.EndDrag(True);
end;

//---------------------------------------------------------------------------
// PERMITE ACEPTAR LA PERSONA PARA ASIGNARLA A ESE GRUPO
//---------------------------------------------------------------------------

procedure TFFranjas.LGrupos2DragOver(Sender, Source: TObject; X,
  Y: Integer; State: TDragState; var Accept: Boolean);
begin
  Accept := True {Habilitada(1, 7, False)} and
            ((Source as TComponent).Name = 'LPersonas') and
            ((Source as TListView).Selected <> nil) and
            ((Sender as TListView).GetItemAt(X,Y) <> nil);
end;

//---------------------------------------------------------------------------
// CAMBIA DE GRUPO DE FRANJAS A UNA PERSONA
//---------------------------------------------------------------------------

procedure TFFranjas.LGrupos2DragDrop(Sender, Source: TObject; X,
  Y: Integer);
var
    Destino: TListItem;
    HT: THitTests;
    Grupo : String;
begin
    // Busca sobre que elemento se tiró el objeto
    HT := LGrupos2.GetHitTestInfoAt(X, Y);

    // Encuentra Grupo destino
    Destino := LGrupos2.GetItemAt(X, Y);

    // Solo mueve persona de grupo si se tiró sobre el icono o item
    if (HT - [htOnItem, htOnIcon, htOnLabel] <> HT) then
    begin
       //if Application.MessageBox(PChar('Está seguro que quiere asignar la persona ' +
       //   LPersonas.Selected.Caption + ' al grupo de franjas ' + Destino.Caption + '?'),
       //   'Advertencia', MB_YESNO + MB_ICONQUESTION) = ID_YES then
       begin
          with data.Consulta do
          begin
            // Busca nuevo número de grupo de franjas
            SQL.Clear;
            SQL.Add('SELECT Gf_num FROM GruposFranjas');
            SQL.Add('WHERE Gf_nom = "' + Destino.Caption + '"');
            Open;
            Grupo := InttoStr(FieldbyName('Gf_num').AsInteger);
            Close;

            // Actualiza cambio de grupo de franjas en tabla de usuarios
            SQL.Clear;
            SQL.Add('UPDATE Usuarios SET Usr_fra = ' + Grupo + ' ');
            SQL.Add('WHERE Usr_nom = "' + LPersonas.Selected.Caption + '"');
            ExecSQL;
          end;

          LGrupos2.Selected := Destino;
          LGrupos2Click(LGrupos2);
       end;
    end;
end;

//---------------------------------------------------------------------------
// NO PERMITE CAMBIAR EL NOMBRE DEL GRUPO "SIN RESTRICCIONES"
//---------------------------------------------------------------------------

procedure TFFranjas.LGruposEditing(Sender: TObject; Item: TListItem;
  var AllowEdit: Boolean);
begin
     AllowEdit := (Item.Caption <> 'Sin Restricciones');
end;

//---------------------------------------------------------------------------
// MUESTRA FRANJA CONFIGURADA PARA ESE GRUPO
//---------------------------------------------------------------------------

procedure TFFranjas.LGruposClick(Sender: TObject);
begin
     if LGrupos.Selected <> nil then
        LGruposChange(LGrupos, LGrupos.Selected, ctState);
end;

procedure TFFranjas.btnTransmitirClick(Sender: TObject);
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
        Application.MessageBox('Para cargar las franjas debe haber algún nodo cargado', 'Información', MB_OK + MB_ICONINFORMATION)
    else
        for i:=0 to Length(Nodos)-1 do p.Upload_Franjas(Nodos[i]);

    LFranjasChange(LFranjas, LFranjas.Selected, ctState);
  {end;}
end;

procedure TFFranjas.FormActivate(Sender: TObject);
begin
   LFranjasChange(LFranjas, LFranjas.Selected, ctState);
end;

procedure TFFranjas.FormHide(Sender: TObject);
begin
   dibujar := True;
end;

procedure TFFranjas.AppActivate(Sender: TObject);
begin


   dibujar := True;
   LFranjasChange(LFranjas, LFranjas.Selected, ctState);
   dibujar := False;
end;

procedure TFFranjas.FormClose(Sender: TObject; var Action: TCloseAction);
begin
   Application.OnActivate := nil;
end;

procedure TFFranjas.FormCloseQuery(Sender: TObject; var CanClose: Boolean);
begin
   CanClose := salir; 
end;

end.
