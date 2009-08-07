//---------------------------------------------------------------------------
//
//  Módulo de ABM Avanzado y Asignaciones v1.0
//
//
//  Actualización de Rutinas a SQL 27-11-2000 OK
//  Chequeo general OK 30-11-2000
//  Agregado de seguridad 06-12-2000
//  Chequeo general 08-12-2000
//  Revisión General 01-02-2001
//  Comandos SQL con consulta 01-02-2001 (Eliminación de Database.Execute)
//  Fin de la interfase 01-02-2001
//  Implementación de la ayuda al presionar F1 03-03-2001
//  Restricción de 8 caracteres a campo Tarjeta 12-03-2001
//  Agregado de edición de franja 13-03-2001
//  Reducción de tamaño de la ventana de ABM 14-03-2001
//  Revisión general de rutinas 14-03-2001
//  ABM de Franjas OK 14-03-2001
//  Implementado Módulo de Franjas (Modulo 3) 14-03-2001
//  Tarjeta y Código OK. Chequeo y relleno con ceros 29-03-2001
//  Agregado de caducidad y suspendido 12-04-2001
//  Tarjeta y Código alfanuméricos 12-04-2001
//  CheckBox para ver o no asignaciones 12-04-2001
//  Graba correctamente la franja de la persona 21-07-2001
//  Agilización de la carga del árbol de personas y grupos 07-10-2001
//  Consulta de personas siempre abierta para tener rápido los datos 07-10-2001
//  Corrección no cargaba grupos de personas vacíos 17-03-2002
//  Corrección: Al seleccionar una persona cuya franja no existía, error. 05-04-2003
//  Corrección: No se podían seleccionar imágenes aún en modo full 30-12-2003
//
//
//  A hacer:
//           Agilizar operaciones con tablas en memoria
//           Agregar configuración de nodos (Modem, TCP-IP, RS-485)
//           Agregar más números de nodo
//
//---------------------------------------------------------------------------

unit ABM;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  ComCtrls, ExtCtrls, StdCtrls, ImgList, ToolWin, Buttons, Menus, DBTables;

type
  TFABM = class(TForm)
    BoxGruposPersonas: TGroupBox;
    LGrupos: TListView;
    BoxPersonas: TGroupBox;
    LPersonas: TTreeView;
    ToolBar1: TToolBar;
    btnAltaGrupo: TToolButton;
    btnBajaGrupo: TToolButton;
    btnModiGrupo: TToolButton;
    BoxDatos: TGroupBox;
    Label1: TLabel;
    ENombre: TEdit;
    Label2: TLabel;
    Label3: TLabel;
    CBGrupo: TComboBox;
    ETarjeta: TEdit;
    ToolBar2: TToolBar;
    btnContrae: TToolButton;
    btnExpande: TToolButton;
    btnAltaPersona: TToolButton;
    btnBajaPersona: TToolButton;
    btnBuscaPersona: TToolButton;
    MenuBuscar: TPopupMenu;
    mnuNombre: TMenuItem;
    mnuTarjeta: TMenuItem;
    BoxNodos: TGroupBox;
    ToolBar3: TToolBar;
    btnAltaConjunto: TToolButton;
    LNodos: TTreeView;
    btnBorra: TToolButton;
    btnModifica: TToolButton;
    ToolButton3: TToolButton;
    ImgGrupos: TImageList;
    ImgMenuPers: TImageList;
    ImgPers: TImageList;
    ImgMenuNod: TImageList;
    ImgNod: TImageList;
    btnAltaNodo: TToolButton;
    btnCambiaOp: TToolButton;
    BoxAsignaciones: TGroupBox;
    LAsig: TListView;
    ImgAsig: TImageList;
    Tool2: TToolBar;
    btnBorraAsig: TToolButton;
    ComboFotos: TComboBox;
    GroupBox1: TGroupBox;
    Image1: TImage;
    btnOK: TBitBtn;
    btnCancel: TBitBtn;
    barranod: TStatusBar;
    btnSelectAll: TToolButton;
    Label4: TLabel;
    btnConfigFranjas: TToolButton;
    Label5: TLabel;
    CBFranja: TComboBox;
    Label6: TLabel;
    btnSalir: TSpeedButton;
    Label7: TLabel;
    ECod: TEdit;
    Label8: TLabel;
    ECaducidad: TDateTimePicker;
    CSuspendido: TCheckBox;
    CheckAsig: TCheckBox;
    btnConfigFeriados: TToolButton;
    MenuGrupos: TPopupMenu;
    NuevaPersona1: TMenuItem;
    MenuPersonas: TPopupMenu;
    Modificar1: TMenuItem;
    Eliminar1: TMenuItem;
    Label9: TLabel;
    procedure FormShow(Sender: TObject);
    procedure AltaGrupoAccesos(Sender: TObject);
    procedure LGruposInfoTip(Sender: TObject; Item: TListItem; var InfoTip: String);
    procedure LGruposEdited(Sender: TObject; Item: TListItem; var S: String);
    procedure BajaGrupoAcceso(Sender: TObject);
    procedure ModiGrupoAcceso(Sender: TObject);
    procedure LPersonasChange(Sender: TObject; Node: TTreeNode);
    procedure DatosChange(Sender: TObject);
    procedure btnOKClick(Sender: TObject);
    procedure LPersonasDblClick(Sender: TObject);
    procedure LPersonasEnter(Sender: TObject);
    procedure btnContraeClick(Sender: TObject);
    procedure btnExpandeClick(Sender: TObject);
    procedure LPersonasCollapsed(Sender: TObject; Node: TTreeNode);
    procedure LPersonasDragDrop(Sender, Source: TObject; X, Y: Integer);
    procedure LPersonasDragOver(Sender, Source: TObject; X, Y: Integer;
      State: TDragState; var Accept: Boolean);
    procedure LPersonasMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure btnAltaPersonaClick(Sender: TObject);
    procedure btnBajaPersonaClick(Sender: TObject);
    procedure btnAltaConjuntoClick(Sender: TObject);
    procedure LNodosEdited(Sender: TObject; Node: TTreeNode; var S: String);
    procedure btnBorraClick(Sender: TObject);
    procedure btnModificaClick(Sender: TObject);
    procedure LNodosEditing(Sender: TObject; Node: TTreeNode; var AllowEdit: Boolean);
    procedure btnAltaNodoClick(Sender: TObject);
    procedure LNodosChange(Sender: TObject; Node: TTreeNode);
    procedure btnCambiaOpClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure LNodosDragOver(Sender, Source: TObject; X, Y: Integer;
      State: TDragState; var Accept: Boolean);
    procedure LNodosDragDrop(Sender, Source: TObject; X, Y: Integer);
    procedure btnBorraAsigDragOver(Sender, Source: TObject; X, Y: Integer;
      State: TDragState; var Accept: Boolean);
    procedure btnBorraAsigDragDrop(Sender, Source: TObject; X, Y: Integer);
    procedure LNodosEnter(Sender: TObject);
    procedure Busqueda(Sender: TObject);
    procedure BoxDatosEnter(Sender: TObject);
    procedure btnCancelClick(Sender: TObject);
    procedure btnBorraAsigClick(Sender: TObject);
    procedure btnSelectAllClick(Sender: TObject);
    procedure btnSalirClick(Sender: TObject);
    procedure btnConfigFranjasClick(Sender: TObject);
    procedure Mayusculas(Sender: TObject; var Key: Char);
    procedure CheckAsigClick(Sender: TObject);
    procedure btnConfigFeriadosClick(Sender: TObject);
    procedure NuevaPersona1Click(Sender: TObject);
    procedure Modificar1Click(Sender: TObject);
    procedure Eliminar1Click(Sender: TObject);
    procedure LPersonasKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
  private
    { Private declarations }
  public
    { Public declarations }
    qryPersonas: TQuery;
    qryAsig: TQuery;
    procedure CargaUsuarios;
    procedure CargaNodos;
    procedure CargaFotos;
    procedure BorraAsignaciones;
    procedure CargaFranjas;
  end;

//---------------------------------------------------------------------------
// VARIABLES DEL MÓDULO ABM
//---------------------------------------------------------------------------

var
  FABM: TFABM;                 // Form de ABM Avanzado
  NAccesos: TTreeNode;
  NPC: TTreeNode;
  N0: TTreeNode;
  modi: record
     nom, trj, cod, grp, fot, fra, cad, susp: Boolean;
  end;
  pers_actual:  Record         // Tipo de variable Usuario
    id: Longint;
    nombre: String;
    tarjeta: String;
    codigo: String;
    grupo: String;
    foto: String;
    franja:  String;
    caducidad: String;
    suspendido: String;
  end;
  alta: Boolean=False;        // Flag de modo alta
  Modulo_Franjas: Boolean;
  full: Boolean = True;
  UltimaTarjeta: String;
  actualizando: Boolean;
  
implementation

uses Datos, DB, Comunicaciones, Busqueda, NumNodo, Principal, Rutinas,
  Franjas, Serkey, Feriados, Progreso;

{$R *.DFM}

//---------------------------------------------------------------------------
// MUESTRA EL FORM DE ABM AVANZADO
//---------------------------------------------------------------------------

procedure TFABM.FormShow(Sender: TObject);
begin
    Modulo_Franjas := ((llave.Modulos shr 2) and $01) = $01;

    Randomize;     // Inicializa números aleatorios para id's
    CargaFotos;    // Carga el combo de fotos
    CargaUsuarios; // Carga las personas y los grupos de personas
    CargaNodos;    // Carga arbol de nodos
    CargaFranjas;  // Carga el combo de grupos de franjas
    UltimaTarjeta := '';

    qryPersonas := TQuery.Create(nil);
    with qryPersonas do
    begin
      DatabaseName := 'MIBASE';
      SQL.Clear;
      SQL.Add('SELECT Usr_id, Usr_nom, Usr_tarj, Usr_cod, Usr_fot, Gu_nom, Gf_nom, Usr_cad, Usr_susp, Fr_num');
      SQL.Add('FROM Usuarios');
      SQL.Add('LEFT OUTER JOIN GruposAcceso ON (Usuarios.Usr_grp = GruposAcceso.Gu_num)');
      SQL.Add('LEFT OUTER JOIN GruposFranjas ON (Usuarios.Usr_fra = GruposFranjas.Gf_num)');
      SQL.Add('LEFT OUTER JOIN Franjas ON (GruposFranjas.Gf_fra = Franjas.Fr_num)');
      Open;
    end;

    qryAsig := TQuery.Create(nil);
    qryAsig.DatabaseName := 'MIBASE';

    LPersonas.SetFocus;
    actualizando := False;
end;

//---------------------------------------------------------------------------
// CIERRA EL FORM DE ABM AVANZADO
//---------------------------------------------------------------------------

procedure TFABM.FormClose(Sender: TObject; var Action: TCloseAction);
begin
    qryPersonas.Close;
    FreeAndNil(qryPersonas);
    FreeAndNil(qryAsig);
end;

//---------------------------------------------------------------------------
// CARGA TODAS LAS FOTOS DISPONIBLES EN EL COMBO (*.BMP)
//---------------------------------------------------------------------------

procedure TFABM.CargaFotos;
var
    sr: TSearchRec;
begin
  // En modo descargador no carga las fotos
  if not llave.modofull then Exit;

  with ComboFotos.Items do
  begin
    Clear;
    Add('Sin foto');      // Añade 'Sin foto'

    // Busca todos los BMP de la carpeta FOTOS
    if FindFirst(ReadReg_S('Ufot') + '\*.bmp', faAnyFile, sr) = 0 then
    begin
      Add(sr.Name);
      while FindNext(sr) = 0 do Add(sr.Name);
      FindClose(sr);
    end;
  end;
end;

//---------------------------------------------------------------------------
// CARGA LOS GRUPOS DE FRANJAS EN EL COMBO DE FRANJAS
//---------------------------------------------------------------------------

procedure TFABM.CargaFranjas;
begin
  with CBFranja.Items do
  begin
    Clear;
    BeginUpdate;

    // Realiza consulta de todos los grupos de franjas
    with data.Consulta do
    begin
      SQL.Text := 'SELECT Gf_nom FROM GruposFranjas';
      Open;
      while not Eof do
      begin
         Add(FieldbyName('Gf_nom').AsString);
         Next;
      end;
      Close;
    end;

    CBFranja.Enabled := Modulo_Franjas;
    Label5.Enabled := Modulo_Franjas;
    EndUpdate;
  end;
end;

// **************************************************************************
//
//                PROCEDIMIENTOS DE LISTA DE USUARIOS
//
// **************************************************************************

//---------------------------------------------------------------------------
// RECUPERA LA LISTA DE PERSONAS DESDE LA BASE
//---------------------------------------------------------------------------

procedure TFABM.CargaUsuarios;
var
   I: TListItem;             // Variable item de la lista
   Ng, Np: TTreeNode;        // Variable nodo del arbol
   //nombre: String;
   numero: Integer;
   ultimo_grupo, grupo: String;
begin
    LGrupos.Items.Clear;    // Borra lista de grupos
    CBGrupo.Items.Clear;    // Borra combo de grupos
    LPersonas.Items.Clear;  // Borra items del árbol
    LGrupos.Items.BeginUpdate;
    LPersonas.Items.BeginUpdate;

    // Crea Ramas de Grupos raiz
    NAccesos := LPersonas.Items.Add(nil, 'Todas las personas');
    NAccesos.ImageIndex := 0;
    NAccesos.SelectedIndex := 0;

    // Realiza consulta de todos los grupos de personas
    with data.Consulta do
    begin
        // Agrega los grupos que tienen personas dentro
        //SQL.Text := 'SELECT Gu_nom, Gu_num FROM GruposAcceso';
        SQL.Text := 'select GruposAcceso.Gu_nom, GruposAcceso.Gu_num, Usuarios.Usr_nom ' +
                    'from Usuarios, GruposAcceso ' +
                    'where Usuarios.Usr_grp=GruposAcceso.Gu_num ' +
                    'Order by GruposAcceso.Gu_nom';
        Open;

        ultimo_grupo := '';

        // Recorre todos los registros
        while not Eof do
        begin
            grupo := FieldbyName('Gu_nom').AsString;
            numero := FieldbyName('Gu_num').AsInteger;

            if grupo <> ultimo_grupo then
            begin
              // Añade item a la lista
              I := LGrupos.Items.Add;
              I.Caption := grupo;
              I.ImageIndex := 0;

              // Agrega numero de grupo como subítem
              I.SubItems.Add(InttoStr(numero));

              // Añade item al combo de grupos
              CBGrupo.Items.Add(grupo);

              // Añade grupos al arbol de personas
              Ng := LPersonas.Items.AddChild(NAccesos, grupo);
              Ng.ImageIndex := 1;
              Ng.SelectedIndex := 1;

              ultimo_grupo := grupo;
            end;

            Np := LPersonas.Items.AddChild(Ng, FieldbyName('Usr_nom').AsString);
            Np.ImageIndex := 2;
            Np.SelectedIndex := 2;

            // Añade personas pertenecientes a ese grupo
            {with data.Consulta2 do
            begin
                Close;
                SQL.Clear;
                SQL.Add('SELECT Usr_nom FROM Usuarios');
                SQL.Add('INNER JOIN GruposAcceso ON (Usr_grp = Gu_num)');
                SQL.Add('WHERE Gu_nom = "' + nombre + '"');
                Open;

                while not Eof do   // Recorre las personas de ese grupo
                begin
                    Np := LPersonas.Items.AddChild(Ng, FieldbyName('Usr_nom').AsString);
                    Np.ImageIndex := 2;
                    Np.SelectedIndex := 2;

                    Next;
                end;
                Close;
            end;}

            Next;
        end;
        Close;

        // Agrega los grupos que no tienen personas dentro
        SQL.Text := 'select GruposAcceso.Gu_nom, GruposAcceso.Gu_num ' +
                    'from GruposAcceso ' +
                    'where GruposAcceso.Gu_nom not in (' +
                    'select distinct GruposAcceso.Gu_nom ' +
                    'from GruposAcceso, Usuarios ' +
                    'where Usuarios.Usr_grp=GruposAcceso.Gu_num ' +
                    ') Order by GruposAcceso.Gu_nom';
        Open;

        // Recorre todos los registros
        while not Eof do
        begin
            grupo := FieldbyName('Gu_nom').AsString;
            numero := FieldbyName('Gu_num').AsInteger;

            // Añade item a la lista
            I := LGrupos.Items.Add;
            I.Caption := grupo;
            I.ImageIndex := 0;

            // Agrega numero de grupo como subítem
            I.SubItems.Add(InttoStr(numero));

            // Añade item al combo de grupos
            CBGrupo.Items.Add(grupo);

            // Añade grupos al arbol de personas
            Ng := LPersonas.Items.AddChild(NAccesos, grupo);
            Ng.ImageIndex := 1;
            Ng.SelectedIndex := 1;

            Next;
        end;
        Close;
    end;

    // Ordena el arbol
    LPersonas.SortType := stNone;
    LPersonas.SortType := stText;

    LGrupos.Items.EndUpdate;
    LPersonas.Items.EndUpdate;

    // Selecciona el nodo raíz
    LPersonas.Items.Item[0].Expand(False);  // Expande Grupos
    LPersonas.Selected := LPersonas.Items.GetFirstNode;
    LPersonasChange(LPersonas, LPersonas.Selected);
end;

//---------------------------------------------------------------------------
// DA DE ALTA UN NUEVO GRUPO DE ACCESOS
//---------------------------------------------------------------------------

procedure TFABM.AltaGrupoAccesos(Sender: TObject);
var
    I : TListItem;
    N : TTreeNode;
    numero, k : Integer;
    nombre : String;
    existe : Boolean;
begin
  // Entra sólo si está habilitada la función
  if Habilitada(1, 2) then
  begin
    with data.Consulta do
    begin
        // Busca próximo número de grupo disponible empezando en 0
        SQL.Text := 'SELECT Gu_num FROM GruposAcceso WHERE Gu_num = :numgrupo';

        numero := 0;
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
        SQL.Text := 'SELECT Gu_nom FROM GruposAcceso WHERE Gu_nom = :nombre';
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
       SQL.Add('INSERT INTO GruposAcceso (Gu_nom, Gu_num)');
       SQL.Add('VALUES ("' + nombre + '", ' + InttoStr(numero) + ')');
       ExecSQL;
    end;

    // Agrega item a la lista de Grupos
    I := LGrupos.Items.Add;
    I.Caption := nombre;
    I.ImageIndex := 0;
    I.SubItems.Add(InttoStr(numero));
    I.EditCaption;

    // Agrega nodo (Grupo de Acceso) al árbol de personas
    N := LPersonas.Items.AddChild(NAccesos, nombre);
    N.ImageIndex := 1;
    N.SelectedIndex := 1;

    // Ordena el arbol
    LPersonas.SortType := stNone;
    LPersonas.SortType := stText;

    // Agrega grupo al Combo de grupos
    CBGrupo.Items.Add(nombre);
  end;
end;

//---------------------------------------------------------------------------
// VA ACTUALIZANDO EL HINT MOSTRANDO NUMERO DEL GRUPO DE ACCESO
//---------------------------------------------------------------------------

procedure TFABM.LGruposInfoTip(Sender: TObject; Item: TListItem; var InfoTip: String);
begin
   InfoTip := 'Grupo: ' + Item.Caption + ' [' + Item.SubItems[0] + ']';
end;

//---------------------------------------------------------------------------
// BORRA UN GRUPO DE ACCESOS DE LA LISTA
//---------------------------------------------------------------------------

procedure TFABM.BajaGrupoAcceso(Sender: TObject);
var
   i : Integer;
begin
  // Entra sólo si está habilitada la función
  if Habilitada(1, 3) then
  begin
    // Entra solo si hay un item seleccionado
    if LGrupos.Selected = nil then
       Application.MessageBox('Para borrar un grupo debe seleccionarlo', 'Información', MB_OK + MB_ICONEXCLAMATION)
    else
    begin
       // Confirma borrado
       if Application.MessageBox(PChar('Está seguro que quiere borrar el grupo ' +
          LGrupos.Selected.Caption + '?'),
          'Advertencia', MB_YESNO + MB_ICONQUESTION) = ID_YES then
       begin
         // Busca el nodo a borrar del arbol
         for i:=0 to LPersonas.Items[0].Count-1 do
            if LPersonas.Items[0].Item[i].Text = LGrupos.Selected.Caption then break;

         // Si tiene personas abajo, no lo borra
         if LPersonas.Items[0].Item[i].HasChildren then
                Application.MessageBox(PChar('El Grupo ' +
                            LPersonas.Items[0].Item[i].Text +
                            ' tiene personas asignadas.' + #13 +
                            'Es imposible borrarlo hasta reasignar' +
                            ' las personas.'), 'Advertencia', MB_OK + MB_ICONQUESTION)
         else
         begin
              // Borra grupo de la base
              with data.Consulta do
              begin
                 SQL.Clear;
                 SQL.Add('DELETE FROM GruposAcceso');
                 SQL.Add('WHERE Gu_nom = "' + LGrupos.Selected.Caption + '"');
                 ExecSQL;
              end;

              // Borra grupo del arbol
              LPersonas.Items[0].Item[i].Delete;

              // Borra grupo del combo
              for i:=0 to CBGrupo.Items.Count-1 do
                if CBGrupo.Items.Strings[i] = LGrupos.Selected.Caption then break;
              CBGrupo.Items.Delete(i);

              // Borra grupo de la lista de grupos
              LGrupos.Items.Delete(LGrupos.Selected.Index);
         end;
       end;
    end;
  end;
end;

//---------------------------------------------------------------------------
// COMIENZA EL CAMBIO DE NOMBRE DE UN GRUPO DE ACCESOS
//---------------------------------------------------------------------------

procedure TFABM.ModiGrupoAcceso(Sender: TObject);
begin
  // Entra si está habilitada la función
  if Habilitada(1, 4) then
  begin
    // Si hay algún nodo seleccionado, edita su nombre
    if LGrupos.Selected <> nil then LGrupos.Selected.EditCaption
    else
        Application.MessageBox('Para editar el nombre de un grupo debe seleccionarlo', 'Información', MB_OK + MB_ICONEXCLAMATION);
  end;
end;

//---------------------------------------------------------------------------
// CAMBIA EL NOMBRE DEL GRUPO DE ACCESOS EN LA BASE, LISTA Y ARBOL
//---------------------------------------------------------------------------

procedure TFABM.LGruposEdited(Sender: TObject; Item: TListItem;
  var S: String);
var
   i : Integer;
   existe : Boolean;
begin
    // Busca si el nuevo nombre del grupo ya existe
    with data.Consulta do
    begin
      SQL.Text := 'SELECT Gu_nom FROM GruposAcceso WHERE Gu_nom = "' + S + '"';
      Open;
      existe := (RecordCount <> 0);
      Close;
    end;

    // Si no encuentra el nombre del grupo lo cambia al nuevo
    if not existe then
    begin
      // Modifica el nombre en la base
      with data.Consulta do
      begin
         SQL.Clear;
         SQL.Add('UPDATE GruposAcceso SET Gu_nom = "' + S + '" ');
         SQL.Add('WHERE Gu_nom = "' + Item.Caption + '"');
         ExecSQL;
      end;

      // Cambia el nombre en el árbol de personas
      for i:=0 to LPersonas.Items[0].Count-1 do
         if LPersonas.Items[0].Item[i].Text = Item.Caption then break;
      LPersonas.Items[0].Item[i].Text := S;

      // Cambia el nombre en el Combo de grupos
      for i:=0 to CBGrupo.Items.Count do
          if CBGrupo.Items.Strings[i] = Item.Caption then break;
      CBGrupo.Items.Strings[i] := S;

      // Cambia el nombre del item (grupo)
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
// EXPANDE RAMAS DE GRUPOS SOLAMENTE
//---------------------------------------------------------------------------

procedure TFABM.btnContraeClick(Sender: TObject);
begin
   LPersonas.FullCollapse;
   LPersonas.Items.Item[0].Expand(False); // Expande Grupos de Acceso
   LPersonas.Selected := LPersonas.Items.GetFirstNode;
end;

//---------------------------------------------------------------------------
// EXPANDE EL ARBOL COMPLETO
//---------------------------------------------------------------------------

procedure TFABM.btnExpandeClick(Sender: TObject);
begin
   LPersonas.FullExpand;
   LPersonas.Selected := LPersonas.Items.GetFirstNode;
end;

//---------------------------------------------------------------------------
// DA DE ALTA UNA NUEVA PERSONA
//---------------------------------------------------------------------------

procedure TFABM.btnAltaPersonaClick(Sender: TObject);
var
   N: TTreeNode;
   Grupo, Franj: Integer;
   nombre: String;
   k: Integer;
   existe: Boolean;
   //i: Integer;
   t: Int64;
   s: String;
   qryAux: TQuery;
   mas200: Boolean;
begin
  // Entra solo si está habilitada la función
  if Habilitada(1, 5) then
  begin
   // Da de alta solo si está parado sobre un grupo de personas
   if (LPersonas.Selected <> nil) and (LPersonas.Selected.Level=1) then
   begin
      // En modo TITA no chequea cantidad de personas
      {$IFNDEF TITA}
      // En modo descargador no se pueden ingresar más de 200 personas
      if not llave.modofull then
      begin
        qryAux := TQuery.Create(nil);
        try
          qryAux.DatabaseName := data.Consulta.DatabaseName;
          qryAux.SQL.Text := 'select count(*) from usuarios';
          qryAux.Open;
          mas200 := (qryAux.Fields[0].AsInteger >= 200);
          qryAux.Close;
        except
        end;
        qryAux.Free;

        if mas200 then
        begin
          Application.MessageBox('En modo descargador no se pueden configurar más de 200 personas', 'Advertencia', MB_OK + MB_ICONINFORMATION);
          Exit;
        end;
      end;
      {$ENDIF}

      with data.Consulta do
      begin
        // Busca número de grupo
        SQL.Text := 'SELECT Gu_num FROM GruposAcceso WHERE Gu_nom = "' + LPersonas.Selected.Text + '"';
        Open;
        Grupo := FieldbyName('Gu_num').AsInteger;
        Close;

        // Busca número de franja
        {SQL.Text := 'SELECT Gf_num FROM GruposFranjas WHERE Gf_nom = "' + CBFranja.Text + '"';
        Open;
        Franj := FieldbyName('Gf_num').AsInteger;
        Close;}
        Franj := 1;

        // Si existe la persona Nueva Persona, le pone un número consecutivo
        SQL.Text := 'SELECT Usr_nom FROM Usuarios WHERE Usr_nom = :nombre';
        ParambyName('nombre').AsString := 'Nueva Persona';

        Open;
        if RecordCount <> 0 then
        begin
            Close;
            k := 0;
            existe := True;
            while existe do
            begin
                ParambyName('nombre').AsString := 'Nueva Persona ' + InttoStr(k);
                Open;
                if RecordCount = 0 then existe := False
                else inc(k);
                Close;
            end;
            nombre := 'Nueva Persona ' + InttoStr(k);
        end
        else
        begin
            nombre := 'Nueva Persona';
        end;
        Close;

        // Agrega a la base nueva Persona (Usr_id = Aleatorio)
        SQL.Text := 'SELECT * FROM Usuarios WHERE 1=2';
        RequestLive := True;
        Open;
        Append;
        FieldbyName('Usr_id').AsInteger := Random(2147483647);
        FieldbyName('Usr_nom').AsString := nombre;

        if UltimaTarjeta = '' then
        begin
           s := '00000000';
           FieldbyName('Usr_tarj').AsString := s;
           //UltimaTarjeta := s;
        end
        else
        begin
           // Corrección 25/04/2004 - Suma uno en modo decimal
           t := StrToInt('$' + UltimaTarjeta);
           s := IntToHex(t + 1, 8);
           FieldbyName('Usr_tarj').AsString := s;
           UltimaTarjeta := s;
        end;

        FieldbyName('Usr_cod').AsString := 'FFFF';
        FieldbyName('Usr_grp').AsInteger := Grupo;
        FieldbyName('Usr_fot').AsString := 'Sin foto';
        FieldbyName('Usr_fra').AsInteger := Franj;
        FieldbyName('Usr_cad').AsString := 'N01/01/2000';
        FieldbyName('Usr_susp').AsString := 'NO';
        Post;
        Close;
        RequestLive := False;

        // Refresca la consulta de Personas
        qryPersonas.Close;
        qryPersonas.Open;

        //SQL.Clear;
        //SQL.Add('INSERT INTO Usuarios (Usr_nom, Usr_tarj, Usr_cod, Usr_grp, Usr_fot, Usr_id, Usr_fra, Usr_cad, Usr_susp) ');
        //SQL.Add(Format('VALUES ("%s", "00000000", "FFFF", %d, "Sin foto", %d, %d, "N01/01/2000", "NO")', [nombre, Grupo, Random(2147483647), Franj]));
        //ExecSQL;

        {
        RequestLive := True;
        SQL.Text := 'SELECT * FROM Usuarios';
        Open;
        for i:=0 to 1200 do
        begin
           Append;
           FieldbyName('Usr_id').AsString := inttoStr(Random(2147483647));
           FieldbyName('Usr_nom').AsString := InttoStr(Random(99999999));
           FieldbyName('Usr_tarj').AsString := InttoStr(Random(99999999));
           FieldbyName('Usr_cod').AsString := 'FFFF';
           FieldbyName('Usr_grp').AsString := '6';
           FieldbyName('Usr_fot').AsString := 'Sin foto';
           FieldbyName('Usr_fra').AsString := '1';
           FieldbyName('Usr_cad').AsString := 'N01/01/2000';
           FieldbyName('Usr_susp').AsString := 'NO';
           Post;
           FABM.Caption := InttoStr(i);
           Application.ProcessMessages;
        end;
        Close;
        RequestLive := False;
        }
      end;

      // Añade la persona como nodo hijo del grupo
      N := LPersonas.Items.AddChild(LPersonas.Selected, nombre);
      N.ImageIndex := 2;
      N.SelectedIndex := 2;

      // Pone nombre en campo de texto
      ENombre.Text := nombre;

      // Selecciona la persona para editarla
      LPersonas.Selected := N;
      ENombre.SetFocus;

      // Reordena el árbol
      LPersonas.SortType := stNone;
      LPersonas.SortType := stText;

      btnCancel.Enabled := True;    // Habilita botón cancelar
      alta := True;                 // Se pone en modo Alta
      //bar.Panels[0].Text := 'ALTA'; // Indica que es una alta
      Label6.Visible := True;
   end
   else
      Application.MessageBox('Para dar de alta una persona se debe seleccionar el grupo al que pertenece', 'Información', MB_OK + MB_ICONINFORMATION);
  end;
end;

//---------------------------------------------------------------------------
// BORRA LA PERSONA SELECCIONADA
//---------------------------------------------------------------------------

procedure TFABM.btnBajaPersonaClick(Sender: TObject);
begin
  // Entra solo si esta habilitada la función
  if Habilitada(1, 6) then
  begin
   // Solo borra si esta seleccionada una persona
   if (LPersonas.Selected = nil) or (LPersonas.Selected.Level<>2) then
      Application.MessageBox('Para borrar una persona debe seleccionarla', 'Información', MB_OK + MB_ICONEXCLAMATION)
   else
   begin
      // Confirma borrado
      if Application.MessageBox(PChar('Está seguro que quiere borrar la persona: ' + LPersonas.Selected.Text + '?'), 'Advertencia', MB_YESNO + MB_ICONQUESTION) = ID_YES then
      begin
        with data.Consulta do
        begin
             // Borra asignaciones de la persona (ANTES DE BORRAR PERSONA)
             SQL.Clear;
             SQL.Add('DELETE FROM Asignaciones');
             SQL.Add('WHERE (Asg_usr IN ');
             SQL.Add(' (');
             SQL.Add('   SELECT Asg_usr FROM Asignaciones');
             SQL.Add('   INNER JOIN Usuarios ON (Usr_id = Asg_usr)');
             SQL.Add('   WHERE Usr_nom = "' + LPersonas.Selected.Text + '")');
             SQL.Add(' )');
             ExecSQL;

             // Borra persona de la base
             SQL.Clear;
             SQL.Add('DELETE FROM Usuarios');
             SQL.Add('WHERE Usr_nom = "' + LPersonas.Selected.Text + '"');
             ExecSQL;
        end;

        // Borra persona del arbol
        LPersonas.Selected.Delete;
        LPersonas.SetFocus;       // Le da foco al arbol de personas

        // Actualiza consulta de personas
        qryPersonas.Close;
        qryPersonas.Open;
      end;
   end;
  end;
end;

//---------------------------------------------------------------------------
// REALIZA BUSQUEDA DE PERSONA EN EL ARBOL
//---------------------------------------------------------------------------

procedure TFABM.Busqueda(Sender: TObject);
var
    p, t : String;
    i : Integer;
    f : Boolean;
begin
  // Entra solo si está habilitada la función
  if Habilitada(1, 8) then
  begin
    // Crea ventana de búsqueda
    Application.CreateForm(TFBusqueda, FBusqueda);

    // Búsqueda por nombre
    if (Sender as TMenuItem).Name = 'mnuNombre' then
    begin
      // Agrega todas las personas al combo
      with FBusqueda do
      begin
        Label1.Caption := 'Ingrese nombre de la persona';
        ComboBox1.Items.Clear;
        for i:=0 to LPersonas.Items.Count-1 do
            if LPersonas.Items[i].Level = 2 then
                ComboBox1.Items.Add(LPersonas.Items.Item[i].Text);
        ComboBox1.Sorted := True;
      end;

      // Muestra ventana
      if FBusqueda.ShowModal = mrOK then
      begin
        p := FBusqueda.ComboBox1.Text;

        f := False;
        // Recorre todos los nodos del arbol
        for i:=0 to LPersonas.Items.Count-1 do
        begin
            // Si es una persona, se fija si contiene la cadena
            if (LPersonas.Items[i].Level = 2) and
               (Pos(UpperCase(p), UpperCase(LPersonas.Items[i].Text)) <> 0) then
            begin
                // Si es, selecciona el nodo y expande su padre
                LPersonas.Items[i].Selected := True;
                LPersonas.Items[i].Parent.Expand(False);
                LPersonas.SetFocus;
                f := True;
                break;
            end;
        end;

        if not f then
            Application.MessageBox('No se encontró ninguna persona con ese nombre', 'Mensaje', MB_OK + MB_ICONEXCLAMATION)
      end;
    end

    // Búsqueda por tarjeta
    else
    begin
      with FBusqueda do
      begin
        // Agrega todas las tarjetas al combo
        Label1.Caption := 'Ingrese tarjeta de la persona';
        ComboBox1.Items.Clear;
        with data.Consulta do
        begin
          SQL.Text := 'SELECT Usr_tarj FROM Usuarios';
          Open;
          while not Eof do
          begin
              ComboBox1.Items.Add(InttoStr(FieldbyName('Usr_tarj').AsInteger));
              Next;
          end;
          Close;
        end;
        ComboBox1.Sorted := True;
      end;

      if FBusqueda.ShowModal = mrOK then
      begin
        t := FBusqueda.ComboBox1.Text;

        // Busca persona con esa tarjeta
        with data.Consulta do
        begin
          SQL.Text := 'SELECT Usr_nom FROM Usuarios WHERE Usr_tarj = "' + t + '"';
          Open;
          if RecordCount = 0 then
              Application.MessageBox('No se encontró ninguna persona con esa tarjeta', 'Mensaje', MB_OK + MB_ICONEXCLAMATION)
          else
          begin
            p := FieldbyName('Usr_nom').AsString;
            // Recorre todos los nodos del arbol
            for i:=0 to LPersonas.Items.Count-1 do
            begin
              // Si es una persona, se fija si contiene la cadena
              if (LPersonas.Items[i].Level = 2) and
                 (Pos(UpperCase(p), UpperCase(LPersonas.Items[i].Text)) <> 0) then
              begin
                // Si es, selecciona el nodo y expande su padre
                LPersonas.Items[i].Selected := True;
                LPersonas.Items[i].Parent.Expand(False);
                LPersonas.SetFocus;
                break;
              end;
            end;
          end;
          Close;
        end;
      end;
    end;
    FBusqueda.Free;
  end;
end;

//---------------------------------------------------------------------------
// MUESTRA DATOS DE PERSONA SELECCIONADA
//---------------------------------------------------------------------------

procedure TFABM.LPersonasChange(Sender: TObject; Node: TTreeNode);
var
  c, i: Integer;
  N: TListItem;
  qryAux: TQuery;
  gf_num: Integer;
  error_franja: Boolean;
begin
  // Deshabilita los botones de actualización
  btnOK.Enabled := False;
  btnCancel.Enabled := False;

  // Muestra los datos en la ventana si está habilitada la función
  if Habilitada(1, 7, False) then
  begin
    // Si se seleccionó un grupo de personas
    if Node.Level in [0, 1] then
    begin
        // Si no esta seleccionada una persona, deshabilita controles
        BoxDatos.Visible := False;

        // Borra ventana de asignaciones
        BoxAsignaciones.Caption := 'Asignaciones';
        LAsig.Items.BeginUpdate;
        LAsig.Items.Clear;
        LAsig.Items.EndUpdate;

        // Pone cantidad de personas bajo el grupo
        if Node.Level = 1 then BoxPersonas.Caption := Format('%d Personas', [Node.Count])
        else
        begin
           c := 0;
           for i:=0 to LPersonas.Items.Count-1 do
              if LPersonas.Items.Item[i].Level = 2 then inc(c);
           BoxPersonas.Caption := Format('%d Personas', [c])
        end;
    end

    // Si el nodo seleccionado corresponde a una persona (Level = 2),
    else if Node.Level = 2 then
    begin
        BoxPersonas.Caption := 'Personas';
        actualizando := True;

        // Busca persona en la base para mostrar datos
        {with data.Consulta do
        begin
            SQL.Clear;
            SQL.Add('SELECT Usr_nom, Usr_tarj, Usr_cod, Usr_fot, Gu_nom, Gf_nom, Usr_cad, Usr_susp, Fr_num');
            SQL.Add('FROM Usuarios');
            SQL.Add('LEFT OUTER JOIN GruposAcceso ON (Usuarios.Usr_grp = GruposAcceso.Gu_num)');
            SQL.Add('LEFT OUTER JOIN GruposFranjas ON (Usuarios.Usr_fra = GruposFranjas.Gf_num)');
            SQL.Add('LEFT OUTER JOIN Franjas ON (GruposFranjas.Gf_fra = Franjas.Fr_num)');
            Open;
            Locate('Usr_nom;Gu_nom', VarArrayOf([LPersonas.Selected.Text, LPersonas.Selected.Parent.Text]), []);

            // Carga datos de persona actual
            with pers_actual do
            begin
                nombre := LPersonas.Selected.Text;
                tarjeta := data.Consulta['Usr_tarj'];  //FieldbyName('Usr_tarj').AsString;

                codigo :=  data.Consulta['Usr_cod'];   //FieldbyName('Usr_cod').AsString;
                if codigo = 'FFFF' then codigo := '';

                grupo := LPersonas.Selected.Parent.Text;
                foto := data.Consulta['Usr_fot'];      //FieldbyName('Usr_fot').AsString;
                franja := data.Consulta['Gf_nom'];     //FieldbyName('Gf_nom').AsString;
                caducidad := data.Consulta['Usr_cad']; //FieldbyName('Usr_cad').AsString;
                try
                   StrtoDate(Copy(caducidad, 2, 10));
                except;
                   caducidad := 'N01/01/2000';
                end;
                suspendido := data.Consulta['Usr_susp']; //FieldbyName('Usr_susp').AsString;
            end;

            Close;
        end;}

        // Busca persona en la consulta para mostrar sus datos
        with qryPersonas do
        begin
            // Busca la persona en la query
            Locate('Usr_nom;Gu_nom', VarArrayOf([LPersonas.Selected.Text, LPersonas.Selected.Parent.Text]), []);

            // Carga los datos de la persona
            with pers_actual do
            begin
                id := qryPersonas['Usr_id'];
                nombre := LPersonas.Selected.Text;
                tarjeta := qryPersonas['Usr_tarj'];  //FieldbyName('Usr_tarj').AsString;

                codigo :=  qryPersonas['Usr_cod'];   //FieldbyName('Usr_cod').AsString;
                if codigo = 'FFFF' then codigo := '';

                grupo := LPersonas.Selected.Parent.Text;
                foto := qryPersonas.FieldbyName('Usr_fot').AsString;      //FieldbyName('Usr_fot').AsString;

                // Corrección 30/12/2003 - Si foto = '' then foto := 'Sin foto'
                if foto = '' then foto := 'Sin foto';

                // Corrección 04/04/2003
                // Si el grupo de franjas de la persona se borró, asigna una existente
                if qryPersonas['Gf_nom'] = Null then
                begin
                  error_franja := True;

                  qryAux := TQuery.Create(nil);
                  try
                    //Application.MessageBox(PChar(Format('La persona %s pertenece a un grupo de franjas que no existe más. Se le asignará uno existente', [nombre])),
                    //                       'Error', MB_OK + MB_ICONERROR);
                    //LPersonas.EndDrag(True);
                    qryAux.DatabaseName := qryPersonas.DatabaseName;
                    qryAux.SQL.Text := 'select * from gruposfranjas';
                    qryAux.Open;
                    franja := qryAux['Gf_nom'];
                    gf_num := qryAux['Gf_num'];
                    qryAux.Close;
                    qryAux.SQL.Text := Format('update usuarios set usr_fra = %d where usr_id = %d',
                                       [gf_num, id]);
                    qryAux.ExecSQL;
                  except
                    franja := '';
                  end;
                end
                else
                begin
                  error_franja := False;
                  franja := qryPersonas['Gf_nom'];     //FieldbyName('Gf_nom').AsString;
                end;

                caducidad := qryPersonas['Usr_cad']; //FieldbyName('Usr_cad').AsString;
                try
                   StrtoDate(Copy(caducidad, 2, 10));
                except;
                   caducidad := 'N01/01/2000';
                end;
                suspendido := qryPersonas['Usr_susp']; //FieldbyName('Usr_susp').AsString;
            end;
        end;

        // Muestra los datos de la persona
        ENombre.Text := pers_actual.nombre;
        ETarjeta.Text := pers_actual.tarjeta;
        ECod.Text := pers_actual.codigo;

        // Cambia string en Combo grupo
        for i:=0 to CBGrupo.Items.Count-1 do
            if CBGrupo.Items.Strings[i] = pers_actual.grupo then break;
        CBGrupo.ItemIndex := i;

        // Cambia string en Combo franjas
        for i:=0 to CBFranja.Items.Count-1 do
            if CBFranja.Items.Strings[i] = pers_actual.franja then break;
        CBFranja.ItemIndex := i;

        // Muestra la fecha de caducidad
        try
           ECaducidad.DateTime := StrtoDate(Copy(pers_actual.caducidad, 2, 10));
           ECaducidad.Checked := (pers_actual.caducidad[1] = 'S');
        except;
           ECaducidad.DateTime := StrtoDate('01/01/2000');
           ECaducidad.Checked := False;
        end;

        // Muestra estado de suspendido
        CSuspendido.Checked := (pers_actual.suspendido = 'SI');

        // Cambia string en Combo fotos
        for i:=0 to Combofotos.Items.Count-1 do
            // 19/03/2005 - Estaba comparando mal
            //if Combofotos.Items.Strings[i] = pers_actual.foto then break;
            if CompareText(Combofotos.Items.Strings[i], pers_actual.foto) = 0 then break;
        Combofotos.ItemIndex := i;

        // Carga la imagen si tiene una foto asignada y ésta existe
        // Sólo en modo full de SAC32
        if (pers_actual.foto <> 'Sin foto') and
            FileExists(ReadReg_S('Ufot') + '\' + pers_actual.foto) and
            llave.modofull then
        begin
            Image1.Picture.LoadfromFile(ReadReg_S('Ufot') + '\' + pers_actual.foto);
            Image1.Show;
        end
        // Sino, borra la foto anterior
        else Image1.Hide;

        // Habilita controles de edición
        BoxDatos.Visible := True;

        // En modo descargador no permite cambiar foto
        // Corrección 30/12/2003 - En ningún modo permitía editar las fotos
        //ComboFotos.Enabled := False;
        ComboFotos.Enabled := (llave.modofull);

        // Muestra nodos asignados a esa persona
        if CheckAsig.Checked then
        begin
          Screen.Cursor := crHourGlass;
          //with data.Consulta do
          with qryAsig do
          begin
              //SQL.Clear;
              //SQL.Add('SELECT Nod_nom FROM Asignaciones');
              //SQL.Add('INNER JOIN Usuarios ON (Asg_usr = Usr_id)');
              //SQL.Add('INNER JOIN Nodos ON (Asg_nod = Nod_id)');
              //SQL.Add('WHERE Usr_nom = "' + pers_actual.nombre + '"');
              Close;
              SQL.Text := 'select Nod_nom from Asignaciones, Nodos ' +
                          'where Asignaciones.Asg_nod=Nodos.Nod_id ' +
                          'and Asg_usr = ' + IntToStr(pers_actual.id);
              Open;

              BoxAsignaciones.Caption := Format('Accesos de %s [%d]',
                                         [pers_actual.nombre, qryAsig.RecordCount]);

              LAsig.Items.BeginUpdate;
              LAsig.Items.Clear;
              while not Eof do
              begin
                  // Añade item a la lista
                  N := LAsig.Items.Add;
                  N.Caption := FieldbyName('Nod_nom').AsString;
                  N.ImageIndex := 2;
                  Next;
              end;
              LAsig.Items.EndUpdate;

              Close;
          end;
          Screen.Cursor := crDefault;
        end;

        {if error_franja then
        begin
          LPersonas.EndDrag(False);
          Application.MessageBox(PChar(Format(
                                 'La persona %s pertenece a un grupo de franjas que no existe más. Se le asignará uno existente',
                                 [pers_actual.nombre])),
                                 'Error', MB_OK + MB_ICONERROR);
        end;}

        actualizando := False;
    end;
  end;
end;

//---------------------------------------------------------------------------
// ACTIVA O DESACTIVA BOTON DE ACTUALIZAR DATOS DE PERSONAS
//---------------------------------------------------------------------------

procedure TFABM.DatosChange(Sender: TObject);
begin
    if not actualizando then
    begin
      // Si hay foco en algún campo de edición
      if (ActiveControl <> nil) and
          ((ActiveControl.Name = 'ENombre') or
           (ActiveControl.Name = 'ETarjeta') or
           (ActiveControl.Name = 'ECod') or
           (ActiveControl.Name = 'CBGrupo') or
           (ActiveControl.Name = 'CBFranja') or
           (ActiveControl.Name = 'ECaducidad') or
           (ActiveControl.Name = 'CSuspendido') or
           (ActiveControl.Name = 'ComboFotos')) then
      begin
        // Chequea cambios en los campos
        modi.nom := (ENombre.Text <> pers_actual.nombre);
        modi.trj := (ETarjeta.Text <> pers_actual.tarjeta);
        modi.cod := (ECod.Text <> pers_actual.codigo);
        modi.grp := (CBGrupo.Text <> pers_actual.grupo);
        modi.fra := (CBFranja.Text <> pers_actual.franja);
        modi.fot := (ComboFotos.Text <> pers_actual.foto);
        modi.susp := CSuspendido.Checked <> (pers_actual.suspendido = 'SI');
        modi.cad := (ECaducidad.Checked <> (pers_actual.caducidad[1] = 'S')) or
                    (ECaducidad.Date <> StrtoDate(Copy(pers_actual.caducidad, 2, 10)));

        // Carga la imagen si tiene una foto asignada y ésta existe
        if (ComboFotos.Text <> 'Sin foto') and
            FileExists(ReadReg_S('Ufot') + '\' + ComboFotos.Text) and
            llave.modofull then
        begin
            Image1.Picture.LoadfromFile(ReadReg_S('Ufot') + '\' + ComboFotos.Text);
            Image1.Show;
        end
        // Sino, borra la foto anterior
        else Image1.Hide;

        // Actualiza estado de botones de actualización
        if (modi.nom or modi.trj or modi.cod or modi.grp or modi.fot or modi.fra or modi.susp or modi.cad) then
        begin
            btnOK.Enabled := True;
            btnCancel.Enabled := True;
        end
        else
        begin
            btnOK.Enabled := False;
            if not alta then btnCancel.Enabled := False;
        end;
      end;
    end;
end;

//---------------------------------------------------------------------------
// FILTRA Y CORRIGE TECLAS INGRESADAS
//---------------------------------------------------------------------------

procedure TFABM.Mayusculas(Sender: TObject; var Key: Char);
begin
     if Key in ['a'..'z'] then Key := Chr(Ord(Key) + (Ord('A')-Ord('a')));
end;

//---------------------------------------------------------------------------
// AL COLAPSAR ARBOL, DESACTIVA CONTROLES DE DATOS DE USUARIOS
//---------------------------------------------------------------------------

procedure TFABM.LPersonasCollapsed(Sender: TObject; Node: TTreeNode);
begin
    BoxDatos.Visible := False;
end;

//---------------------------------------------------------------------------
// DOBLE CLIC EN NOMBRE DE PERSONA PARA EDITAR DATOS
//---------------------------------------------------------------------------

procedure TFABM.LPersonasDblClick(Sender: TObject);
begin
  // Edita el nombre solo si se doble-cliqueo una persona
  if (Habilitada(1, 7, False)) and (LPersonas.Selected.Level = 2) then
       ENombre.SetFocus;
end;

//---------------------------------------------------------------------------
// ACEPTA CAMBIOS: ACTUALIZA DATOS DE PERSONA EN TABLA DE USUARIOS
//---------------------------------------------------------------------------

procedure TFABM.btnOKClick(Sender: TObject);
var
    i : Integer;
    NombrePersona, NumeroTarjeta, NumeroCodigo : String;
    NombreGrupo, NombreFoto, Grupo, Franj : String;
    Caducidad, Suspendido : String;
    Destino : TTreeNode;
    existe : Boolean;
begin
    try
      // Agrega ceros y verifica campo de tarjeta
      if Length(ETarjeta.Text) < 8 then ETarjeta.Text := StringOfChar('0', 8 - Length(ETarjeta.Text)) + ETarjeta.Text;
      for i:=1 to Length(ETarjeta.Text) do
          if not ((ETarjeta.Text[i] in ['0'..'9']) or (ETarjeta.Text[i] in ['A'..'F'])) then
               raise Exception.Create('Tarjeta inválida');

      // Agrega ceros y verifica campo de código
      if ECod.Text <> '' then
      begin
        if Length(ECod.Text) < 4 then ECod.Text := StringOfChar('0', 4 - Length(ECod.Text)) + ECod.Text;
        for i:=1 to Length(ECod.Text) do
            if not ((ECod.Text[i] in ['0'..'9']) or (ECod.Text[i] in ['A'..'F'])) then
                 raise Exception.Create('Código inválido');
      end;

      // Setea variables con nuevos valores a grabar
      NombrePersona := ENombre.Text;
      NumeroTarjeta := ETarjeta.Text;
      NumeroCodigo := ECod.Text;
      NombreGrupo := CBGrupo.Text;
      NombreFoto := ComboFotos.Text;
      if CSuspendido.Checked then Suspendido := 'SI' else Suspendido := 'NO';
      if ECaducidad.Checked then Caducidad := 'S' else Caducidad := 'N';
      Caducidad := Caducidad + DatetoStr(ECaducidad.Date);

      // Chequea si es un nombre válido
      if NombrePersona = '' then raise Exception.Create('Nombre inválido');

      // Modifica el nombre?
      if modi.nom then
      begin
        // Busca si está repetido
        with data.Consulta do
        begin
            SQL.Clear;
            SQL.Add('SELECT Usr_nom FROM Usuarios WHERE Usr_nom = "' + NombrePersona + '"');
            Open;
            existe := (RecordCount <> 0);
            Close;
        end;

        // Si ya existe mensaje de error
        if existe then raise Exception.Create('Nombre repetido')
        else
        // Si no existe nuevo nombre, lo cambia
        begin
          with data.Consulta do
          begin
             SQL.Clear;
             SQL.Add('UPDATE Usuarios SET Usr_nom = "' + NombrePersona + '" ');
             SQL.Add('WHERE Usr_nom = "' + pers_actual.nombre + '"');
             ExecSQL;
          end;
          pers_actual.nombre := NombrePersona;

          // Actualiza árbol
          LPersonas.Selected.Text := NombrePersona;
        end;
      end;

      // Modifica el número de la tarjeta?
      if modi.trj then
      begin
          with data.Consulta do
          begin
             RequestLive := True;
             SQL.Text := 'SELECT * FROM Usuarios';
             Open;
             Locate('Usr_nom', pers_actual.nombre, []);
             Edit;
             FieldbyName('Usr_tarj').AsString := NumeroTarjeta;
             Post;
             Close;
             RequestLive := False;

             UltimaTarjeta := NumeroTarjeta;

             {SQL.Clear;
             SQL.Add('UPDATE Usuarios SET Usr_tarj = "' + NumeroTarjeta + '" ');
             SQL.Add('WHERE Usr_nom = "' + pers_actual.nombre + '"');
             ExecSQL;}
          end;
      end;

      // Modifica la foto?
      if modi.fot then
      begin
          with data.Consulta do
          begin
             SQL.Clear;
             SQL.Add('UPDATE Usuarios SET Usr_fot = "' + NombreFoto + '" ');
             SQL.Add('WHERE Usr_nom = "' + pers_actual.nombre + '"');
             ExecSQL;
          end;
      end;

      // Modifica el código?
      if modi.cod then
      begin
          with data.Consulta do
          begin
             if NumeroCodigo = '' then NumeroCodigo := 'FFFF';
             SQL.Clear;
             SQL.Add('UPDATE Usuarios SET Usr_cod = "' + NumeroCodigo + '" ');
             SQL.Add('WHERE Usr_nom = "' + pers_actual.nombre + '"');
             ExecSQL;
          end;
      end;

      // Modifica el grupo?
      if modi.grp then
      begin
          with data.Consulta do
          begin
            // Busca número de grupo
            SQL.Clear;
            SQL.Add('SELECT Gu_num FROM GruposAcceso WHERE Gu_nom = "' + CBGrupo.Text + '"');
            Open;
            Grupo := InttoStr(FieldbyName('Gu_num').AsInteger);
            Close;

            // Actualiza grupo del usuario
            SQL.Clear;
            SQL.Add('UPDATE Usuarios SET Usr_grp = ' + Grupo + ' ');
            SQL.Add('WHERE Usr_nom = "' + pers_actual.nombre + '"');
            ExecSQL;
          end;

          // Busca rama (grupo) donde mover la persona
          for i:=0 to LPersonas.Items[0].Count-1 do
              if LPersonas.Items[0].Item[i].Text = NombreGrupo then break;
          Destino := LPersonas.Items[0].Item[i];

          // Mueve persona en árbol si no es el mismo grupo
          if LPersonas.Selected.Parent <> Destino then
             LPersonas.Selected.MoveTo(Destino, naAddChild);
      end;

      // Modifica la franja?
      if modi.fra then
      begin
         with data.Consulta do
         begin
            // Busca la franja que le corresponde al grupo seleccionado
            SQL.Clear;
            SQL.Add('SELECT Gf_num FROM GruposFranjas WHERE Gf_nom = "' + CBFranja.Text + '"');
            Open;
            Franj := InttoStr(FieldbyName('Gf_num').AsInteger);
            Close;

            // Actualiza grupo de franja del usuario
            SQL.Clear;
            SQL.Add('UPDATE Usuarios SET Usr_fra = ' + Franj + ' ');
            SQL.Add('WHERE Usr_nom = "' + pers_actual.nombre + '"');
            ExecSQL;
         end;
      end;

      // Modifica la caducidad?
      if modi.cad then
      begin
         with data.Consulta do
         begin
            SQL.Clear;
            SQL.Add('UPDATE Usuarios SET Usr_cad = "' + Caducidad + '"');
            SQL.Add('WHERE Usr_nom = "' + pers_actual.nombre + '"');
            ExecSQL;
         end;
      end;

      // Modifica el estado de suspendido?
      if modi.susp then
      begin
         with data.Consulta do
         begin
            SQL.Clear;
            SQL.Add('UPDATE Usuarios SET Usr_susp = "' + Suspendido + '"');
            SQL.Add('WHERE Usr_nom = "' + pers_actual.nombre + '"');
            ExecSQL;
         end;
      end;

      // Actualiza consulta de personas
      qryPersonas.Close;
      qryPersonas.Open;

      // Le da foco al arbol de personas
      LPersonas.SetFocus;

      // Actualiza cambios en ventana de datos
      LPersonasChange(LPersonas, LPersonas.Selected);

      // Ordena el arbol
      LPersonas.SortType := stNone;
      LPersonas.SortType := stText;

      alta := False;             // Modo alta = Falso
      Label6.Visible := False;
      BtnOK.Enabled := False;    // Desactiva botones de aceptar y cancelar
      btnCancel.Enabled := False;

    except
      on E:Exception do
      begin
         Application.MessageBox(PChar('Error actualizando datos de persona.'#13 + E.Message + #13'Verifique los datos ingresados'), 'Advertencia', MB_OK + MB_ICONHAND);
         //LPersonasChange(LPersonas, LPersonas.Selected);
      end;
    end;
end;

//---------------------------------------------------------------------------
// CANCELA ACTUALIZACION O ALTA DE PERSONA
//---------------------------------------------------------------------------

procedure TFABM.btnCancelClick(Sender: TObject);
begin
  // Si cancela al estar dando de alta una persona la borra de la base
  if alta then
  begin
      // Borra persona de la base
      with data.Consulta do
      begin
         SQL.Clear;
         SQL.Add('DELETE FROM Usuarios');
         SQL.Add('WHERE Usr_nom = "' + LPersonas.Selected.Text + '"');
         ExecSQL;
      end;

      // Borra persona del arbol
      LPersonas.Selected.Delete;
      LPersonas.SetFocus;       // Le da foco al arbol de personas

      alta := False;
      Label6.Visible := False;
  end
  else    // Si no, en modo edición, aborta cambios no grabados
  begin
      LPersonasEnter(Self);
      LPersonas.SetFocus;
  end;

  // Actualiza consulta de personas
  qryPersonas.Close;
  qryPersonas.Open;
end;

//---------------------------------------------------------------------------
// DESACTIVA BOTON DE ACTUALIZAR DATOS EN BASE DE PERSONAS
//---------------------------------------------------------------------------

procedure TFABM.LPersonasEnter(Sender: TObject);
begin
   // Al entrar en Arbol de Personas, deshabilita botón de actualización
   btnOK.Enabled := False;
   btnCancel.Enabled := False;
   alta := False;
   //bar.Panels[0].Text := '';
   Label6.Visible := False;

   // Si hay alguna persona seleccionada, muestra sus datos en ventana
   if LPersonas.Selected <> nil then
      LPersonasChange(LPersonas, LPersonas.Selected);
end;

//---------------------------------------------------------------------------
// PERMITE INICIAR EL DRAG DE OBJETO DE ARBOL DE PERSONAS
//---------------------------------------------------------------------------

procedure TFABM.LPersonasMouseDown(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
var
   HT: THitTests;
   nodo: TTreeNode;
begin
   // Si está presionado el botón izquierdo del mouse
   if (Button = mbLeft) then
   begin
     // Obtiene info de desde donde se hace el drag
     with LPersonas do
     begin
        HT := GetHitTestInfoAt(X, Y);
        if (HT - [htOnItem, htOnIcon] <> HT) then BeginDrag(False, -1)
        else                                      EndDrag(True);
     end;
   end

   else
   begin
      LPersonas.EndDrag(True);

      // Si está presionado el botón derecho
      if (Button = mbRight) then
      begin
         nodo := LPersonas.GetNodeAt(X, Y);
         if nodo <> nil then
         begin
            LPersonas.Selected := nodo;
            if nodo.Level = 2 then MenuPersonas.Popup(Mouse.CursorPos.x, Mouse.CursorPos.y);
         end;
      end;
   end;
end;

//---------------------------------------------------------------------------
// PERMITE ACEPTAR O NO EL DROP EN EL GRUPO DE PERSONAS
//---------------------------------------------------------------------------

procedure TFABM.LPersonasDragOver(Sender, Source: TObject; X, Y: Integer;
  State: TDragState; var Accept: Boolean);
begin
  // Acepta el drag si:
  // Está habilitada la función, el objeto viene de lista de personas,
  // es una persona y va hacia un grupo
  Accept := Habilitada(1, 7, False) and
            ((Source as TComponent).Name = 'LPersonas') and
            ((Source as TTreeView).Selected <> nil) and
            ((Source as TTreeView).Selected.Level = 2) and
            ((Sender as TTreeView).GetNodeAt(X, Y) <> nil) and
            ((Sender as TTreeView).GetNodeAt(X, Y).Level = 1);
end;

//---------------------------------------------------------------------------
// PROCESA EL DROP (CAMBIA EL GRUPO DE LA PERSONA)
//---------------------------------------------------------------------------

procedure TFABM.LPersonasDragDrop(Sender, Source: TObject; X, Y: Integer);
var
    Destino: TTreeNode;
    HT: THitTests;
    Grupo : String;
begin
    // Busca sobre que elemento se tiró el objeto
    HT := LPersonas.GetHitTestInfoAt(X, Y);

    // Encuentra Grupo destino
    Destino := LPersonas.GetNodeAt(X, Y);

    // Solo mueve persona de grupo si se tiró sobre el icono o item
    if (HT - [htOnItem, htOnIcon, htOnLabel] <> HT) then
    begin
        with data.Consulta do
        begin
          // Busca nuevo número de grupo
          SQL.Clear;
          SQL.Add('SELECT Gu_num FROM GruposAcceso');
          SQL.Add('WHERE Gu_nom = "' + Destino.Text + '"');
          Open;
          Grupo := InttoStr(FieldbyName('Gu_num').AsInteger);
          Close;

          // Actualiza cambio de grupo en tabla de usuarios
          SQL.Clear;
          SQL.Add('UPDATE Usuarios SET Usr_grp = ' + Grupo + ' ');
          SQL.Add('WHERE Usr_nom = "' + LPersonas.Selected.Text + '"');
          ExecSQL;
        end;

        // Mueve persona en árbol si no es el mismo grupo
        if LPersonas.Selected.Parent <> Destino then
           LPersonas.Selected.MoveTo(Destino, naAddChild);

        // Ordena el arbol
        LPersonas.SortType := stNone;
        LPersonas.SortType := stText;

        // Actualiza cambios en ventana de datos
        LPersonasChange(LPersonas, LPersonas.Selected);
    end;
end;

//---------------------------------------------------------------------------
// AL ENTRAR AL BOX DE DATOS, RESETEA MODIFICACIONES
//---------------------------------------------------------------------------

procedure TFABM.BoxDatosEnter(Sender: TObject);
begin
    modi.nom := False;
    modi.trj := False;
    modi.cod := False;
    modi.grp := False;
    modi.fot := False;
    modi.fra := False;

    BtnOK.Enabled := False;
    //btnCancelar.Enabled := False;
end;

// **************************************************************************
//
//                      PROCEDIMIENTOS DE ARBOL DE NODOS
//
// **************************************************************************

//---------------------------------------------------------------------------
// CARGA EL ARBOL DE NODOS
//---------------------------------------------------------------------------

procedure TFABM.CargaNodos;
var
      Ng, Nn : TTreeNode;
      nombre : String;
begin
    // Borra todos los items del árbol de nodos
    LNodos.Items.Clear;
    LNodos.Items.BeginUpdate;

    // Crea raíces
    NPC := LNodos.Items.Add(nil, 'Todos los nodos');
    NPC.ImageIndex := 0;
    NPC.SelectedIndex := 0;

    N0 := LNodos.Items.Add(nil, 'Ningún nodo');
    N0.ImageIndex := 3;
    N0.SelectedIndex := 3;

    // Realiza consulta de todos los nodos y grupos de nodos
    with data.Consulta do
    begin
        SQL.Text := 'SELECT Gn_nom, Gn_num FROM GruposNodos ORDER BY Gn_nom';
        Open;

        // Recorre todos los registros
        while not Eof do
        begin
          nombre := FieldbyName('Gn_nom').AsString;

          Ng := LNodos.Items.AddChild(NPC, nombre);
          Ng.ImageIndex := 1;
          Ng.SelectedIndex := 1;

          // Añade nodos pertenecientes a ese grupo
          with data.Consulta2 do
          begin
            SQL.Clear;
            SQL.Add('SELECT Nod_nom, Nod_num FROM Nodos');
            SQL.Add('INNER JOIN GruposNodos ON (Nod_grp = Gn_num)');
            SQL.Add('WHERE Gn_nom = "' + nombre + '"');
            SQL.Add('ORDER BY Nod_num');
            Open;

            while not Eof do   // Recorre los nodos de ese grupo
            begin
              Nn := LNodos.Items.AddChild(Ng, FieldbyName('Nod_nom').AsString);
              Nn.ImageIndex := 2;
              Nn.SelectedIndex := 2;

              Next;
            end;
            Close;
          end;
          Next;
        end;
        Close;
    end;

    // Selecciona 'Todos los nodos'
    LNodos.Selected := LNodos.Items[0];
    LNodos.Items.EndUpdate;

    // Expande Grupos de Nodos
    LNodos.Items.Item[0].Expand(True);
    LNodosChange(LNodos, LNodos.Selected);
end;

//---------------------------------------------------------------------------
// CREA UN NUEVO GRUPO DE NODOS
//---------------------------------------------------------------------------

procedure TFABM.btnAltaConjuntoClick(Sender: TObject);
var
    N : TTreeNode;
    numero, k : Integer;
    nombre : String;
    existe : Boolean;
    mas2: Boolean;
    qryAux: TQuery;
begin
  // Entra si está habilitada la función
  if Habilitada(1, 9) then
  begin
    // En modo descargador no se pueden ingresar más de 2 grupos de nodos
    if not llave.modofull then
    begin
      qryAux := TQuery.Create(nil);
      try
        qryAux.DatabaseName := data.Consulta.DatabaseName;
        qryAux.SQL.Text := 'select count(*) from gruposnodos';
        qryAux.Open;
        mas2 := (qryAux.Fields[0].AsInteger >= 2);
        qryAux.Close;
      except
      end;
      qryAux.Free;

      if mas2 then
      begin
        Application.MessageBox('En modo descargador no se pueden configurar más de 2 grupos de nodos', 'Advertencia', MB_OK + MB_ICONINFORMATION);
        Exit;
      end;
    end;

    with data.Consulta do
    begin
      // Busca próximo número de grupo disponible empezando en 0
      SQL.Clear;
      SQL.Add('SELECT Gn_num FROM GruposNodos WHERE Gn_num = :numgrupo');

      numero := 0;
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
      SQL.Clear;
      SQL.Add('SELECT Gn_nom FROM GruposNodos WHERE Gn_nom = :nombre');
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
       SQL.Add('INSERT INTO GruposNodos (Gn_nom, Gn_num) ');
       SQL.Add('VALUES ("' + nombre + '", ' + InttoStr(numero) + ')');
       ExecSQL;
    end;

    // Agrega nodo (Grupo de Nodos) al árbol de nodos
    N := LNodos.Items.AddChild(NPC, nombre);
    N.ImageIndex := 1;
    N.SelectedIndex := 1;
    LNodos.Selected := N;

    N.EditText;               // Edita su nombre
  end;
end;

//---------------------------------------------------------------------------
// GUARDA EL CAMBIO DE NOMBRE DEL GRUPO DE NODOS
//---------------------------------------------------------------------------

procedure TFABM.LNodosEdited(Sender: TObject; Node: TTreeNode; var S: String);
begin
    // Cambia el nombre de un grupo
    if Node.Level = 1 then
    begin
       with data.Consulta do
       begin
          SQL.Clear;
          SQL.Add('UPDATE GruposNodos SET Gn_nom = "' + S + '" ');
          SQL.Add('WHERE Gn_nom = "' + Node.Text + '"');
          ExecSQL;
       end;

       Node.Text := S;
       LNodos.Selected := Node;
       LNodos.SetFocus;
    end

    // Cambia el nombre de un nodo
    else if Node.Level = 2 then
    begin
       with data.Consulta do
       begin
          SQL.Clear;
          SQL.Add('UPDATE Nodos SET Nod_nom = "' + S + '" ');
          SQL.Add('WHERE Nod_nom = "' + Node.Text + '"');
          ExecSQL;
       end;

       Node.Text := S;
       LNodos.Selected := Node;
       LNodos.SetFocus;
       LNodosChange(Self, Node);
    end;
end;

//---------------------------------------------------------------------------
// BORRA EL GRUPO DE NODOS O NODO SELECCIONADO
//---------------------------------------------------------------------------

procedure TFABM.btnBorraClick(Sender: TObject);
begin
   if LNodos.Selected = nil then
      Application.MessageBox('Para borrar un grupo o un nodo debe seleccionarlo', 'Información', MB_OK + MB_ICONEXCLAMATION)
   else
   begin
      if LNodos.Selected.Level = 0 then
          Application.MessageBox('Este objeto no se puede borrar', 'Información', MB_OK + MB_ICONEXCLAMATION)

      // Borra grupo de nodos
      else if LNodos.Selected.Level = 1 then
      begin
          if Habilitada(1, 10) then
          begin
            // Confirma borrado
            if Application.MessageBox(PChar('Seguro borra Grupo '+LNodos.Selected.Text+'?'), 'Advertencia', MB_YESNO + MB_ICONQUESTION) = ID_YES then
            begin
                 // Si tiene nodos abajo, no lo borra
                 if LNodos.Selected.HasChildren then
                     Application.MessageBox(PChar('El Grupo ' +
                         LNodos.Selected.Text + ' tiene nodos asignados.'#13+
                          'Es imposible borrarlo hasta reasignar o borrar los nodos.'),
                          'Advertencia', MB_OK + MB_ICONQUESTION)
                 else
                 begin
                    // Borra grupo de la base
                    with data.Consulta do
                    begin
                       SQL.Clear;
                       SQL.Add('DELETE FROM GruposNodos ');
                       SQL.Add('WHERE Gn_nom = "' + LNodos.Selected.Text + '"');
                       ExecSQL;
                    end;

                    // Borra grupo del arbol
                    LNodos.Selected.Delete;
                    LNodos.SetFocus;
                 end;
            end;
          end;
      end

      // Borra nodo
      else if LNodos.Selected.Level = 2 then
      begin
          if Habilitada(1, 13) then
          begin
            // Confirma borrado
            if Application.MessageBox(PChar('Seguro borra Nodo '+LNodos.Selected.Text+'?'), 'Advertencia', MB_YESNO + MB_ICONQUESTION) = ID_YES then
            begin
                with data.Consulta do
                begin
                   // Borra asignaciones del nodo (ANTES DE BORRAR NODO)
                   SQL.Clear;
                   SQL.Add('DELETE FROM Asignaciones ');
                   SQL.Add('WHERE (Asg_nod IN ');
                   SQL.Add('  (SELECT Asg_nod FROM Asignaciones ');
                   SQL.Add('  INNER JOIN Nodos ON (Nod_id = Asg_nod)');
                   SQL.Add('  WHERE Nod_nom = "' + LNodos.Selected.Text + '"))');
                   ExecSQL;

                   // Borra nodo de la base
                   SQL.Clear;
                   SQL.Add('DELETE FROM Nodos ');
                   SQL.Add('WHERE Nod_nom = "' + LNodos.Selected.Text + '"');
                   ExecSQL;
                end;

                // Borra nodo del arbol
                LNodos.Selected.Delete;
                LNodos.SetFocus;
            end;
          end;
      end;
   end;
end;

//---------------------------------------------------------------------------
// PERMITE EDITAR EL NOMBRE DE UN GRUPO
//---------------------------------------------------------------------------

procedure TFABM.btnModificaClick(Sender: TObject);
begin
    if LNodos.Selected = nil then
        Application.MessageBox('Para cambiar el nombre hay que seleccionar un elemento', 'Advertencia', MB_OK + MB_ICONEXCLAMATION)

    else
    begin
      // Si hay algún grupo o nodo seleccionado, edita su nombre
      if ((LNodos.Selected.Level = 1) and (Habilitada(1, 11))) or
         ((LNodos.Selected.Level = 2) and (Habilitada(1, 14))) then
           LNodos.Selected.EditText;
    end;
end;

//---------------------------------------------------------------------------
// SOLO PERMITE LA EDICION DE UN GRUPO DE NODOS O UN NODO
//---------------------------------------------------------------------------

procedure TFABM.LNodosEditing(Sender: TObject; Node: TTreeNode;
  var AllowEdit: Boolean);
begin
     if Node.Level > 0 then AllowEdit := True else AllowEdit := False;
end;

//---------------------------------------------------------------------------
// AGREGA UN NUEVO NODO
//---------------------------------------------------------------------------

procedure TFABM.btnAltaNodoClick(Sender: TObject);
var
   NumGrupo : Integer;
   N : TTreeNode;
   numero, i, k : Integer;
   existe : Boolean;
   nombre : String;
   mas2: Boolean;
   qryAux: TQuery;
begin
  if Habilitada(1, 12) then
  begin
   // Entra solo si hay un grupo de nodos seleccionado
   if (LNodos.Selected <> nil) and (LNodos.Selected.Level = 1) then
   begin
      // En modo descargador no se pueden ingresar más de 2 nodos
      if not llave.modofull then
      begin
        qryAux := TQuery.Create(nil);
        try
          qryAux.DatabaseName := data.Consulta.DatabaseName;
          qryAux.SQL.Text := 'select count(*) from nodos';
          qryAux.Open;
          mas2 := (qryAux.Fields[0].AsInteger >= 2);
          qryAux.Close;
        except
        end;
        qryAux.Free;

        if mas2 then
        begin
          Application.MessageBox('En modo descargador no se pueden configurar más de 2 nodos', 'Advertencia', MB_OK + MB_ICONINFORMATION);
          Exit;
        end;
      end;

      with data.Consulta do
      begin
        // Chequea si llegó al máximo de nodos
        SQL.Text := 'SELECT * FROM Nodos';
        Open;
        i := RecordCount;
        Close;

        if i < MAX_NOD then
        begin
            // Busca Número de grupo de nodos
            SQL.Text := 'SELECT Gn_num FROM GruposNodos WHERE Gn_nom = :grupo';
            ParambyName('grupo').AsString := LNodos.Selected.Text;
            Open;
            NumGrupo := FieldbyName('Gn_num').AsInteger;
            Close;

            // Busca próximo número de nodo disponible
            SQL.Text := 'SELECT Nod_num FROM Nodos WHERE Nod_num = :num';

            numero := 1;
            existe := True;
            while existe do
            begin
                ParambyName('num').AsInteger := numero;
                Open;
                if RecordCount = 0 then existe := False
                else inc(numero);
                Close;
            end;

            // Si existe el nodo Nuevo Nodo, le pone un número consecutivo
            SQL.Text := ('SELECT Nod_nom FROM Nodos WHERE Nod_nom = :nombre');
            ParambyName('nombre').AsString := 'Nuevo Nodo';

            Open;
            if RecordCount <> 0 then
            begin
                Close;
                k := 0;
                existe := True;
                while existe do
                begin
                    ParambyName('nombre').AsString := 'Nuevo Nodo ' + InttoStr(k);
                    Open;
                    if RecordCount = 0 then existe := False
                    else inc(k);
                    Close;
                end;
                nombre := 'Nuevo Nodo ' + InttoStr(k);
            end
            else
            begin
                nombre := 'Nuevo Nodo';
            end;
            Close;

            // Agrega nodo a la tabla
            with data.Consulta do
            begin
               SQL.Clear;
               SQL.Add('INSERT INTO Nodos (Nod_nom, Nod_num, Nod_grp, Nod_id) ');
               SQL.Add('VALUES ("' + nombre + '", ' + InttoStr(numero) + ', ' + InttoStr(NumGrupo) + ', ' + InttoStr(Random(2147483647)) + ')');
               ExecSQL;
            end;

            // Añade el nodo como nodo hijo del grupo
            N := LNodos.Items.AddChild(LNodos.Selected, nombre);
            N.ImageIndex := 2;
            N.SelectedIndex := 2;

            // Selecciona el nodo para editarlo
            LNodos.Selected := N;
            LNodos.Selected.EditText;
            LNodos.SetFocus;
        end
        else
            Application.MessageBox('Se llegó a la cantidad máxima de '#13'nodos admitida por el sistema.'#13'No se pueden agregar más nodos'#13, 'Advertencia', MB_OK + MB_ICONINFORMATION);
      end;
   end
   else
      Application.MessageBox('Para dar de alta un nodo se debe seleccionar el grupo al que pertenece', 'Información', MB_OK + MB_ICONINFORMATION);
  end;
end;

//---------------------------------------------------------------------------
// VISUALIZA DATOS DEL NODO
//---------------------------------------------------------------------------

procedure TFABM.LNodosChange(Sender: TObject; Node: TTreeNode);
var
    N : TListItem;
begin
    // Si el nodo seleccionado corresponde a un nodo (Level = 2),
    // muestra los datos en la barra de estado
    if Node.Level = 2 then
    begin
        // Busca nodo en la base para mostrar datos
        with data.Consulta do
        begin
          SQL.Text := 'SELECT Nod_num FROM Nodos WHERE Nod_nom = :nombre';
          ParambyName('nombre').AsString := Node.Text;
          Open;

          // Recupera datos y los muestra
          barranod.SimpleText := Node.Text + ' [Nodo ' + FieldbyName('Nod_num').AsString + ']';
          Close;

          // Muestra personas asignadas a ese nodo
          if CheckAsig.Checked then
          begin
            Screen.Cursor := crHourGlass;
            LAsig.Items.BeginUpdate;
            LAsig.Items.Clear;

            SQL.Clear;
            SQL.Add('SELECT Usr_nom, Usr_tarj FROM Asignaciones ');
            SQL.Add('INNER JOIN Usuarios ON  (Asg_usr = Usr_id)');
            SQL.Add('INNER JOIN Nodos ON  (Asg_nod = Nod_id)');
            SQL.Add('WHERE Nod_nom = :nombre');
            ParambyName('nombre').AsString := Node.Text;
            Open;

            BoxAsignaciones.Caption := Format('Personas en %s [%d]',
                                         [Node.Text, data.Consulta.RecordCount]);

            while not Eof do
            begin
              // Añade item a la lista
              N := LAsig.Items.Add;
              N.Caption := FieldbyName('Usr_nom').AsString;
              N.ImageIndex := 1;
              Next;
            end;

            LAsig.Items.EndUpdate;
            Close;
            Screen.Cursor := crDefault;
          end;
        end;
    end

    // Si el nodo seleccionado corresponde a un grupo (Level = 1),
    // muestra la cantidad de nodos en ese grupo
    else if Node.Level = 1 then
    begin
        BoxAsignaciones.Caption := 'Asignaciones';
        LAsig.Items.BeginUpdate;
        LAsig.Items.Clear;

        if Node.HasChildren then
            if Node.Count = 1 then
                barraNod.Simpletext := 'El grupo tiene 1 nodo asignado'
            else
                barraNod.Simpletext := 'El grupo tiene ' + InttoStr(Node.Count) + ' nodos asignados'
        else
            barraNod.Simpletext := 'El grupo no tiene nodos asignados';

        LAsig.Items.EndUpdate;
    end

    // Si el nodo seleccionado corresponde a todos (Level = 0,
    else
    begin
        barranod.SimpleText := Node.Text;
    end;
end;

//---------------------------------------------------------------------------
// ENTRA AL ARBOL DE NODOS
//---------------------------------------------------------------------------

procedure TFABM.LNodosEnter(Sender: TObject);
begin
     if LNodos.Selected <> nil then LNodosChange(LNodos, LNodos.Selected);
end;

//---------------------------------------------------------------------------
// CAMBIA PROPIEDADES DEL NODO SELECCIONADO
//---------------------------------------------------------------------------

procedure TFABM.btnCambiaOpClick(Sender: TObject);
var
    num, i : Integer;
    s: String;
    dis: String;
begin
  // Entra si está habilitada la función
  if Habilitada(1, 15) then
  begin
    // Si hay algún nodo seleccionado, edita el número de nodo
    if (LNodos.Selected <> nil) and (LNodos.Selected.Level = 2) then
    begin
       // Crea ventana para cambio de nro de nodo
       Application.CreateForm(TFNumNodo, FNumNodo);
       with FNumNodo do
       begin
            // Carga Combobox con todos los nros de nodo
            ComboBox1.Items.Clear;
            for i:=1 to MAX_NOD do
                ComboBox1.Items.Append(InttoStr(i));

            // Elimina de la lista nros de nodo ya asignados
            with data.Consulta do
            begin
                SQL.Text := 'SELECT Nod_num FROM Nodos';
                Open;
                while not Eof do
                begin
                    num := FieldbyName('Nod_num').AsInteger;

                    // Busca nro en Combo y lo elimina
                    for i:=0 to ComboBox1.Items.Count-1 do
                        if ComboBox1.Items[i] = InttoStr(num) then
                            ComboBox1.Items.Delete(i);
                    Next;
                end;
                Close;

                // Inserta número de nodo seleccionado
                SQL.Text := 'SELECT Nod_num FROM Nodos WHERE Nod_nom = "' + LNodos.Selected.Text + '"';
                Open;
                ComboBox1.Items.Insert(0, InttoStr(FieldbyName('Nod_num').AsInteger));
                Close;

                // Selecciona nro de nodo actual
                ComboBox1.ItemIndex := 0;
            end;

            // Corrección 16/02/2004 - Muestra dispositivo asignado al nodo
            // Corrección 13/03/2004 - Sólo en modo full
            if llave.modofull then
            begin
              with data.Consulta do
              begin
                SQL.Text := 'select nod_dis from nodos where nod_nom = "' +  LNodos.Selected.Text + '"';
                Open;
                nod_dis := FieldbyName('nod_dis').AsString;
                Close;
              end;
            end
            else
              nod_dis := '';

            // Muestra ventana para cambiar el nro de nodo
            if ShowModal = mrOK then
            begin
              // Si acepta el cambio actualiza en tabla de nodos
              with data.Consulta do
              begin
                 // Si antes estaba por serie y ahora por tcp/ip, graba el nuevo dispositivo
                 if (nod_dis = '') and (optTipoConexion.ItemIndex = 1) then
                 begin
                   SQL.Text := 'select dis_cod from dispositivos order by dis_cod desc';
                   Open;
                   s := Fields[0].AsString;
                   Close;
                   i := StrtoIntDef(s, 1);
                   inc(i);
                   dis := InttoStr(i);

                   SQL.Text := 'insert into dispositivos (dis_cod, dis_direccion) ' +
                               'values (:dis_cod, :dis_direccion)';
                   Params[0].AsString := dis;
                   Params[1].AsString := txtDireccion.Text;
                   ExecSQL;
                 end

                 // Si antes estaba por tcp/ip y ahora por serie, elimina el dispositivo
                 else if (nod_dis <> '') and (optTipoConexion.ItemIndex = 0) then
                 begin
                   SQL.Text := 'delete from dispositivos where dis_cod = "' + nod_dis + '"';
                   ExecSQL;

                   dis := '';
                 end

                 // Si estaba por tcp/ip, ahora también, y cambió la dirección, la cambia
                 else if (nod_dis <> '') and (optTipoConexion.ItemIndex = 1) then
                 begin
                   SQL.Text := 'update dispositivos set dis_direccion = "' + txtDireccion.Text + '" ' +
                               'where dis_cod = "' + nod_dis + '"';
                   ExecSQL;

                   dis := nod_dis;
                 end

                 // Si estaba serie, y ahora también, no hace nada
                 else
                 begin
                   dis := '';
                 end;

                 SQL.Clear;
                 SQL.Add('UPDATE Nodos SET Nod_num = "' + ComboBox1.Text + '" ');

                 // Corrección 16/02/2004 - Actualiza el dispositivo del nodo
                 SQL.Add(', Nod_dis = "' + dis + '"');

                 SQL.Add('WHERE Nod_nom = "' + LNodos.Selected.Text + '"');
                 ExecSQL;
              end;
            end;

            // Actualiza datos de nodo actual
            LNodosChange(Self, LNodos.Selected);

            // Destruye ventana
            Release;
       end;
    end
    else
        Application.MessageBox('Sólo es posible cambiar el número de un nodo'#13, 'Advertencia', MB_OK + MB_ICONEXCLAMATION);
  end;
end;

//---------------------------------------------------------------------------
// ABRE LA VENTANA DE CONFIGURACIÓN DE FRANJAS
//---------------------------------------------------------------------------

procedure TFABM.btnConfigFranjasClick(Sender: TObject);
begin
    if Modulo_Franjas then
    begin
      // Crea y muestra ventana de Franjas
      Application.CreateForm(TFFranjas, FFranjas);
      FFranjas.ShowModal;
      FFranjas.Free;

      // Actualiza el combo de grupos de franjas
      CargaFranjas;

      // Actualiza datos de Persona Actual
      LPersonasChange(LPersonas, LPersonas.Selected);
    end
    else
        Application.MessageBox('El Módulo de Franjas Horarias y Feriados no está habilitado', 'Advertencia', MB_OK + MB_ICONEXCLAMATION);
end;

//---------------------------------------------------------------------------
// ABRE LA VENTANA DE CONFIGURACIÓN DE FERIADOS
//---------------------------------------------------------------------------

procedure TFABM.btnConfigFeriadosClick(Sender: TObject);
begin
    if Modulo_Franjas then
    begin
      // Crea y muestra ventana de Feriados
      Application.CreateForm(TFFeriados, FFeriados);
      FFeriados.ShowModal;
      FFeriados.Free;
    end
    else
        Application.MessageBox('El Módulo de Franjas Horarias y Feriados no está habilitado', 'Advertencia', MB_OK + MB_ICONEXCLAMATION);
end;

//---------------------------------------------------------------------------
// PERMITE O NO EL DROP (SOLO SI EL OBJECTO VIENE DE LA LISTA DE PERSONAS)
//---------------------------------------------------------------------------

procedure TFABM.LNodosDragOver(Sender, Source: TObject; X, Y: Integer;
  State: TDragState; var Accept: Boolean);
var
  HT: THitTests;
begin
  // Obtiene información de la posición donde se arrojó el objeto
  HT := LNodos.GetHitTestInfoAt(X, Y);

  // Solo si la función está habilitada
  if Habilitada(1, 16, False) then
  begin
     // Chequea si el objeto viene de la lista de personas y
     // se arroja sobre un item válido
     if ((Source as TComponent).Name = 'LPersonas') and
        (LNodos.GetNodeAt(X,Y) <> nil) and
        (HT - [htOnItem, htOnIcon, htOnLabel] <> HT) then
     begin
        barranod.SimpleText := LPersonas.Selected.Text + ' a ' + LNodos.GetNodeAt(X, Y).Text;
        Accept := True;
     end
     else
     begin
        barranod.SimpleText := '';
        Accept := False;
     end;
  end
  else Accept := False;
end;

//---------------------------------------------------------------------------
// PROCESA EL DROP (REALIZA ASIGNACIÓN)
//---------------------------------------------------------------------------

procedure TFABM.LNodosDragDrop(Sender, Source: TObject; X, Y: Integer);
var
  Origen, Destino: TTreeNode;
  Usuarios, Nodos: array of Integer;   // Arrays dinámicos
  i: Integer;
  u, n: Integer;
  a, max: Integer;

begin
   Origen := LPersonas.Selected;       // Configura elemento origen
   Destino := LNodos.GetNodeAt(X, Y);  // Configura elemento destino

   // Inicializa arrays para asignar pares [Usuario,Nodo]
   SetLength(Usuarios, 0);
   SetLength(Nodos, 0);

   // Crea array con id's de todas las personas a asignar
   with data.Consulta do
   begin
      SQL.Clear;
      SQL.Add('SELECT Usr_id FROM Usuarios');
      SQL.Add('INNER JOIN GruposAcceso ON Usr_grp = Gu_num');
      SQL.Add('WHERE Gu_nom like :grupo AND Usr_nom like :nombre');

      case Origen.Level of
          // Si se asignan todas las personas
      0:  begin
              ParambyName('grupo').AsString := '%';
              ParambyName('nombre').AsString := '%';
          end;
          // Si se asigna un grupo de personas
      1:  begin
              ParambyName('grupo').AsString := Origen.Text;
              ParambyName('nombre').AsString := '%';
          end;
          // Si se asigna una persona sola
      2:  begin
              ParambyName('grupo').AsString := Origen.Parent.Text;
              ParambyName('nombre').AsString := Origen.Text;
          end;
      end;

      Open;
      SetLength(Usuarios, RecordCount);
      for i:=0 to Length(Usuarios)-1 do
      begin
          Usuarios[i] := FieldbyName('Usr_id').AsInteger;
          Next;
      end;
      Close;
   end;

   // Crea array con id's de todos los nodos donde asignar
   with data.Consulta do
   begin
      SQL.Clear;
      SQL.Add('SELECT Nod_id FROM Nodos');
      SQL.Add('INNER JOIN GruposNodos ON Nod_grp = Gn_num');
      SQL.Add('WHERE Gn_nom like :grupo AND Nod_nom like :nombre');

      case Destino.Level of
          // Si se asignan todas las personas
      0:  begin
              ParambyName('grupo').AsString := '%';
              ParambyName('nombre').AsString := '%';
          end;
          // Si se asigna un grupo de personas
      1:  begin
              ParambyName('grupo').AsString := Destino.Text;
              ParambyName('nombre').AsString := '%';
          end;
          // Si se asigna una persona sola
      2:  begin
              ParambyName('grupo').AsString := Destino.Parent.Text;
              ParambyName('nombre').AsString := Destino.Text;
          end;
      end;

      Open;
      SetLength(Nodos, RecordCount);
      for i:=0 to Length(Nodos)-1 do
      begin
          Nodos[i] := FieldbyName('Nod_id').AsInteger;
          Next;
      end;
      Close;
   end;

   // Si el grupo no contiene personas, mensaje
   if Length(Usuarios) = 0 then
      Application.MessageBox('No hay personas a asignar', 'Advertencia', MB_OK + MB_ICONINFORMATION)
   else
   begin
      // Borra todos las asignaciones de persona o grupo de personas
      if Destino.Text = 'Ningún nodo' then
      begin
          for i:=0 to Length(Usuarios)-1 do
          begin
              with data.Consulta do
              begin
                 SQL.Clear;
                 SQL.Add('DELETE FROM Asignaciones ');
                 SQL.Add('WHERE (Asg_usr = ' + InttoStr(Usuarios[i]) + ')');
                 ExecSQL;
              end;
          end;
      end

      // Asigna personas en nodos que corresponda
      else
      begin
          // Si la lista de nodos está vacía, error
          if Length(Nodos) = 0 then
              Application.MessageBox('No hay nodos donde asignar', 'Advertencia', MB_OK + MB_ICONINFORMATION)
          else
          begin
            // Crea y muestra ventana de progreso de asignación
            Application.CreateForm(TFProgreso, FProgreso);
            with FProgreso do
            begin
                ani.Active := True;
                barra.Progress := 0;
                lbl.Caption := '';
                Show;
            end;

            // Actualiza ventana de progreso
            FProgreso.lbl.Caption := Format('Iniciando Asignación de Tarjetas', []);
            FProgreso.barra.Progress := 0;
            Application.ProcessMessages;

            a := 1;
            max := Length(Usuarios)*Length(Nodos);

            // Asigna los usuarios que correspondan...
            for u:=0 to Length(Usuarios)-1 do
            begin
                // En los nodos que correspondan.
                for n:=0 to Length(Nodos)-1 do
                begin
                    // Actualiza ventana de progreso
                    FProgreso.lbl.Caption := Format('Asignando %d de %d tarjetas',
                                             [a , max]);
                    FProgreso.barra.Progress := Trunc(100 * a / max);
                    Application.ProcessMessages;
                    inc(a);

                    // Busca si asignación ya está hecha
                    with data.Consulta do
                    begin
                      SQL.Clear;
                      SQL.Add('SELECT * FROM Asignaciones');
                      SQL.Add('WHERE Asg_usr = :usuario AND Asg_nod = :nodo');
                      ParambyName('usuario').AsInteger := Usuarios[u];
                      ParambyName('nodo').AsInteger := Nodos[n];
                      Open;
                      if RecordCount = 0 then
                      begin
                          Close;
                          // Si no existe, agrega asignación
                          SQL.Clear;
                          SQL.Add('INSERT INTO Asignaciones (Asg_id, Asg_usr, Asg_nod) ');
                          SQL.Add('VALUES (' + InttoStr(Random(2147483647)) + ', ' + InttoStr(Usuarios[u]) + ', ' + InttoStr(Nodos[n]) + ')');
                          ExecSQL;
                      end
                      else // Si ya existe no la agrega
                          Close;
                    end;
                end;
            end;
            // Destruye ventana de progreso
            FProgreso.Free;
            // Wav con operación exitosa
            PlayWav('INFO');
          end;
      end;
   end;

   // Actualiza cambios en ventanas de datos
   LNodosChange(LNodos, Destino);
   LPersonasChange(LPersonas, Origen);

   // Borra arrays
   SetLength(Usuarios, 0);
   SetLength(Nodos, 0);
end;

// **************************************************************************
//
//                PROCEDIMIENTOS DE LISTA DE ASIGNACIONES
//
// **************************************************************************

//---------------------------------------------------------------------------
// PERMITE ACEPTAR O NO EL DROP DE LA ASIGNACIÖN A BORRAR
//---------------------------------------------------------------------------

procedure TFABM.btnBorraAsigDragOver(Sender, Source: TObject; X, Y: Integer;
  State: TDragState; var Accept: Boolean);
begin
 // Solo acepta si el objeto viene de la lista de asignaciones
 Accept := (Habilitada(1, 17, False)) and
           ((Source as TComponent).Name = 'LAsig');
end;

//---------------------------------------------------------------------------
// BORRA ASIGNACION DADO EL PAR (PERSONA, NODO)
//---------------------------------------------------------------------------

procedure BorraAsig(persona, nodo : String);
begin
  with data.Consulta do
  begin
    SQL.Text :=
        Format(
        'DELETE FROM Asignaciones ' +
        'WHERE ' +
        '( ' +
        '  Asg_usr IN ' +
        '  ( ' +
        '    SELECT Asg_usr FROM Asignaciones ' +
        '    INNER JOIN Usuarios ON Usr_id = Asg_usr ' +
        '    WHERE Usr_nom = "%s" ' +
        '  ) ' +
        '  AND Asg_nod IN ' +
        '  ( ' +
        '    SELECT Asg_nod FROM Asignaciones ' +
        '    INNER JOIN Nodos ON Nod_id = Asg_nod ' +
        '    WHERE Nod_nom = "%s" ' +
        '  ) ' +
        ') ', [persona, nodo]);
    ExecSQL;
  end;
end;

//---------------------------------------------------------------------------
// BORRA ASIGNACIONES SELECCIONADAS
//---------------------------------------------------------------------------

procedure TFABM.BorraAsignaciones;
var
    Item: TListItem;
    max, a: Integer;
begin
    // Confirma borrado de asignaciones
    if Application.MessageBox('Está seguro que quiere borrar todas ' +
                  'las asignaciones seleccionadas?'#13, 'Advertencia',
                  MB_YESNO + MB_ICONQUESTION) = ID_YES then
    begin
       // Crea y muestra ventana de progreso de asignación
       Application.CreateForm(TFProgreso, FProgreso);
       with FProgreso do
       begin
           ani.Active := True;
           barra.Progress := 0;
           lbl.Caption := '';
           Show;
       end;

       // Actualiza ventana de progreso
       FProgreso.lbl.Caption := Format('Iniciando Borrado de Asignaciones', []);
       FProgreso.barra.Progress := 0;
       Application.ProcessMessages;

       // Borra nodos asignados a persona
       if Copy(BoxAsignaciones.Caption, 1, 7) = 'Accesos' then
       begin
           max := LAsig.SelCount;
           a := 1;

           Item := LAsig.Selected;
           BorraAsig(LPersonas.Selected.Text, Item.Caption);

           Item := LAsig.GetNextItem(Item, sdAll, [isSelected]);
           while Item <> nil do
           begin
              // Actualiza ventana de progreso
              FProgreso.lbl.Caption := Format('Borrando %d de %d nodos',
                                       [a , max]);
              FProgreso.barra.Progress := Trunc(100 * a / max);
              Application.ProcessMessages;
              inc(a);

              BorraAsig(LPersonas.Selected.Text, Item.Caption);
              Item := LAsig.GetNextItem(Item, sdAll, [isSelected]);
           end;

           // Actualiza LAsig
           LPersonasChange(LPersonas, LPersonas.Selected);
       end

       // Borra personas asignados a nodo
       else if Copy(BoxAsignaciones.Caption, 1, 7) = 'Persona' then
       begin
           max := LAsig.SelCount;
           a := 1;

           Item := LAsig.Selected;
           BorraAsig(Item.Caption, LNodos.Selected.Text);

           Item := LAsig.GetNextItem(Item, sdAll, [isSelected]);
           while Item <> nil do
           begin
              // Actualiza ventana de progreso
              FProgreso.lbl.Caption := Format('Borrando %d de %d tarjetas',
                                       [a , max]);
              FProgreso.barra.Progress := Trunc(100 * a / max);
              Application.ProcessMessages;
              inc(a);

              BorraAsig(Item.Caption, LNodos.Selected.Text);
              Item := LAsig.GetNextItem(Item, sdAll, [isSelected]);
           end;

           // Actualiza LAsig
           LNodosChange(LNodos, LNodos.Selected);
       end;
       // Destruye ventana de progreso
       FProgreso.Free;
    end;
end;

//---------------------------------------------------------------------------
// PROCESA EL DROP
//---------------------------------------------------------------------------

procedure TFABM.btnBorraAsigDragDrop(Sender, Source: TObject; X, Y: Integer);
begin
    BorraAsignaciones;
end;

//---------------------------------------------------------------------------
// BORRA LAS ASIGNACIONES SELECCIONADAS
//---------------------------------------------------------------------------

procedure TFABM.btnBorraAsigClick(Sender: TObject);
begin
  if Habilitada(1, 17) then
   if LAsig.Selected = nil then
        Application.MessageBox('No hay asignaciones a borrar', 'Advertencia', MB_OK + MB_ICONINFORMATION)
   else
        BorraAsignaciones;
end;

//---------------------------------------------------------------------------
// SELECCIONA TODAS LAS ASIGNACIONES
//---------------------------------------------------------------------------

procedure TFABM.btnSelectAllClick(Sender: TObject);
var
    i : Integer;
begin
    LAsig.SetFocus;
    for i:=0 to LAsig.Items.Count-1 do
        LAsig.Items.Item[i].Selected := not LAsig.Items.Item[i].Selected;
end;

//---------------------------------------------------------------------------
// VUELVE A LA VENTANA PRINCIPAL
//---------------------------------------------------------------------------

procedure TFABM.btnSalirClick(Sender: TObject);
begin
    Close;
end;

//---------------------------------------------------------------------------
// PERMITE VER O NO LAS ASIGNACIONES DE LA PERSONA O NODO
//---------------------------------------------------------------------------

procedure TFABM.CheckAsigClick(Sender: TObject);
begin
     if CheckAsig.Checked then LPersonasChange(LPersonas, LPersonas.Selected)
     else LAsig.Items.Clear;
end;

//---------------------------------------------------------------------------
// DA DE ALTA UNA NUEVA PERSONA DESDE EL MENÚ
//---------------------------------------------------------------------------

procedure TFABM.NuevaPersona1Click(Sender: TObject);
var
   i: Integer;
begin
   if LGrupos.Selected <> nil then
   begin
     // Busca el grupo seleccionado
     for i:=0 to LPersonas.Items.Count-1 do
     begin
        if LPersonas.Items.Item[i].Level = 1 then
        begin
           if LPersonas.Items.Item[i].Text = LGrupos.Selected.Caption then
              break;
        end;
     end;

     LPersonas.Selected := LPersonas.Items.Item[i];
     LPersonas.SetFocus;
     btnAltaPersona.Click;
   end;
end;

//---------------------------------------------------------------------------
// MODIFICA UNA PERSONA
//---------------------------------------------------------------------------

procedure TFABM.Modificar1Click(Sender: TObject);
begin
   if LPersonas.Selected <> nil then
      if LPersonas.Selected.Level = 2 then
         ENombre.SetFocus;
end;

//---------------------------------------------------------------------------
// ELIMINA UNA PERSONA
//---------------------------------------------------------------------------

procedure TFABM.Eliminar1Click(Sender: TObject);
begin
   if LPersonas.Selected <> nil then
      if LPersonas.Selected.Level = 2 then
         btnBajaPersona.Click;
end;

//---------------------------------------------------------------------------
// PROCESA LOS COMANDOS POR TECLADO DEL ABM DE PERSONAS
//---------------------------------------------------------------------------

procedure TFABM.LPersonasKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
var
   f: TextFile;
   s, d: String;
   q: TQuery;
   n, t: String;
begin
   if (LPersonas.Selected <> nil) then
   begin
     // ALTA
     if Key = VK_INSERT then
     begin
         if LPersonas.Selected.Level = 1 then
         begin
            btnAltaPersona.Click;
         end
         else if LPersonas.Selected.Level = 2 then
         begin
            LPersonas.Selected := LPersonas.Selected.Parent;
            btnAltaPersona.Click;
         end;
     end

     // BAJA
     else if Key = VK_DELETE then
     begin
         if LPersonas.Selected.Level = 2 then
         begin
            btnBajaPersona.Click;
         end;
     end

     // MODIFICACION
     else if Key = VK_RETURN then
     begin
         if LPersonas.Selected.Level = 2 then
         begin
            ENombre.SetFocus;
         end;
     end

     else if Key = VK_F7 then
     begin
        q := TQuery.Create(Self);
        q.DatabaseName := 'MIBASE';
        q.SQL.Text := 'select * from usuarios';
        q.RequestLive := True;
        q.Open;
        AssignFile(f, 'p.txt');
        Reset(f);
        d := '';
        while not Eof(f) do
        begin
           ReadLn(f, s);
           n := Copy(s, 1, Pos(',', s)-1);
           t := Copy(s, Pos(',', s)+1, 8);
           //ShowMessage(s + #10 + #13 + n + #10 + #13 + t);

           with q do
           begin
              Append;
              FieldbyName('Usr_id').AsInteger := Random(2147483647);
              FieldbyName('Usr_nom').AsString := n;
              FieldbyName('Usr_tarj').AsString := t;
              FieldbyName('Usr_cod').AsString := 'FFFF';
              FieldbyName('Usr_grp').AsInteger := 0;
              FieldbyName('Usr_fot').AsString := 'Sin foto';
              FieldbyName('Usr_fra').AsInteger := 1;
              FieldbyName('Usr_cad').AsString := 'N01/01/2000';
              FieldbyName('Usr_susp').AsString := 'NO';
              Post;
           end;
        end;
        CloseFile(f);
        q.Close;
        FreeAndNil(q);

        // Refresca la consulta de Personas
        qryPersonas.Close;
        qryPersonas.Open;
     end;
   end;
end;

end.
