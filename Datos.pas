//---------------------------------------------------------------------------
//
//  Módulo de Acceso a la Base de Datos del Programa
//
//  Creación de tablas de la base de datos 16-01-2001
//  Agregado en Módulo de ImageLists para evitar problemas de gráficos
//  corruptos 06-02-2001
//  Finalización de Módulo 07-02-2001
//  Agregado de tablas de Franjas y GruposFranjas 12-03-2001
//  Actualización de datos por defecto 29-03-2001
//  Cambios en la tabla de Usuarios 12-04-2001
//  Modificación de datos de Session para estabilidad en Paradox 17-11-2001
//  Encriptación de base de datos Paradox 13-03-2002
//  Agregado de tabla de dispositivos 16-02-2004
//  Agregado de soporte para Interbase 6 22-02-2004
//  Default de tipo de Base = Paradox 09-01-2006
//
//  A Hacer:
//
//---------------------------------------------------------------------------

unit Datos;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  Db, DBTables, FileCtrl, ImgList, SerKey;

const
  PARADOX = 0;
  INTERBASE = 1;

type
  Tdata = class(TDataModule)
    Consulta: TQuery;
    DConsulta: TDataSource;
    Database: TDatabase;
    Consulta2: TQuery;
    ImgCmdSistema: TImageList;
    ImgCmdNodos: TImageList;
    ImgANodos: TImageList;
    ImgLNodos: TImageList;
    IconosBarraEstado: TImageList;
    ImgAyuda: TImageList;
    imgEstadoNodos: TImageList;
    procedure ConsultaBeforeOpen(DataSet: TDataSet);
  private
    { Private declarations }
  public
    { Public declarations }
    function DBConnect : Boolean;
    procedure Crea_tabla(t : String);
  end;

const
  tablas: Array[1..10] of String = ('GruposNodos', 'Nodos', 'GruposAcceso',
                                    'Usuarios', 'Asignaciones', 'Eventos',
                                    'Franjas', 'GruposFranjas', 'Feriados',
                                    'Dispositivos');
var
  data: Tdata;
  base_ok: Boolean = False;
  d: Boolean = False;

  // Tipo de base de datos a la que se conecta SAC32
  TIPO_BASE: Integer;     { 0: Paradox, 1: Interbase }

implementation

uses Principal, Comunicaciones, Rutinas, Password;

{$R *.DFM}

//---------------------------------------------------------------------------
// ESTABLECE CONEXION CON BASE DE DATOS Y GENERA TABLAS SI ES NECESARIO
//---------------------------------------------------------------------------

function Tdata.DBConnect : Boolean;
var
  i: Integer;
  base: String;
  qry: TQuery;
begin
 // Operaciones sobre la base de datos
 with data.Database do
 begin
   {0: Paradox, 1: Interbase }
   (*
   if FindCmdLineSwitch('paradox', ['/', '-'], True) then TIPO_BASE := 0
   else                                                   TIPO_BASE := 1;
   *)

   // 09-01-2006 Por default Paradox, sino Interbase
   if FindCmdLineSwitch('paradox', ['/', '-'], True) then
     TIPO_BASE := 0
   else if FindCmdLineSwitch('interbase', ['/', '-'], True) then
     TIPO_BASE := 1
   else
     TIPO_BASE := 0;

   // 25/04/2004 - Por ahora siempre funciona en modo PARADOX
   // 19/03/2005 - Se habilita el soporte para Interbase (por defecto si no se ingresa parámetro)
   //TIPO_BASE := 0;

   // 24/04/2004 - En modo muestra, siempre Paradox
   if modo_muestra then
     TIPO_BASE := 0;

   try
      // Se desconecta de la base de datos y configura opciones
      Connected := False;
      DatabaseName := 'MIBASE';         // Alias de la base

      if TIPO_BASE = PARADOX then
        DriverName := 'STANDARD'         // Driver PARADOX
      else
        DriverName := 'INTRBASE';        // Driver SQLLinks Interbase

      // Si la ubicación no está configurada la setea con valor default
      if (ReadReg_S('UBD') = '') then WriteReg_S('UBD', carpeta + 'Bases');
      base := ReadReg_S('UBD');

      if TIPO_BASE = PARADOX then
        if not DirectoryExists(base) then CreateDir(base);

      // Configura los datos de la Sesión
      Session.Active := False;

      if TIPO_BASE = PARADOX then
      begin
        Session.NetFileDir := base;
        Session.PrivateDir := carpeta + 'Private';
      end;

      // Agrega la password a la sesión para las tablas encriptadas
      if TIPO_BASE = PARADOX then
        Session.AddPassword(PARADOX_PASSWORD);

      if TIPO_BASE = PARADOX then
        if not DirectoryExists(carpeta + 'Private') then
          CreateDir(carpeta + 'Private');

      // Configura tipo y ubicación de Base de Datos
      Params.Clear;

      if TIPO_BASE = PARADOX then
      begin
        Params.Add('PATH=' + base);
        Params.Add('DEFAULT DRIVER=PARADOX');
        Params.Add('ENABLE BCD=FALSE');
      end
      else
      begin
        Params.Add('SERVER NAME=' + base + '\SAC32.gdb');
        Params.Add('USER NAME=SYSDBA');
        Params.Add('PASSWORD=masterkey');
      end;

      // Parámetro /base muestra información de la base
      if FindCmdLineSwitch('base', ['/', '-'], True) then
            Application.MessageBox(PChar(Params.Text), 'Configuración de Base de Datos', MB_OK + MB_ICONINFORMATION);

      // Intenta la conexión con la base de datos
      Connected := True;
      Session.Active := True;

      if not Connected then base_ok := False
      else
      begin
        // Crea carpeta de base de datos si no existe
        if TIPO_BASE = PARADOX then
          if not DirectoryExists(base) then CreateDir(base);

        // Crea tablas dinámicas si no existen
        if TIPO_BASE = PARADOX then
        begin
          for i:=1 to Length(tablas) do
          begin
            if not FileExists(base + '\' + tablas[i] + '.DB') then
              Crea_tabla(tablas[i]);
          end;

          // Crea tablas estáticas si no existen
          if not FileExists(base + '\Tip_Ev.DB') then Crea_tabla('Tip_Ev');
        end
        else
        begin
          for i:=1 to Length(tablas) do Crea_tabla(tablas[i]);

          // Crea tablas estáticas si no existen
          Crea_tabla('Tip_Ev');
        end;

        base_ok := True;
      end;

      // 25/04/2004 - Hace la validación de nodos y grupos de nodos si modo descargador
      if (base_ok) and (not llave.modofull) then
      begin
        qry := TQuery.Create(nil);
        try
          qry.DatabaseName := 'MIBASE';
          qry.SQL.Text := 'select count(*) from GruposNodos';
          qry.Open;
          if qry.Fields[0].AsInteger > 2 then
          begin
            Application.MessageBox('Hay más de 2 grupos de nodos configurados en la base de datos. No se puede ingresar en modo descargador', 'Error', MB_OK + MB_ICONERROR);
            base_ok := False;
          end;
          qry.Close;
          if base_ok then
          begin
            qry.SQL.Text := 'select count(*) from Nodos';
            qry.Open;
            if qry.Fields[0].AsInteger > 2 then
            begin
              Application.MessageBox('Hay más de 2 nodos configurados en la base de datos. No se puede ingresar en modo descargador', 'Error', MB_OK + MB_ICONERROR);
              base_ok := False;
            end;
            qry.Close;
          end;

          // En modo TITA no chequea cantidad de personas
          {$IFNDEF TITA}
          if base_ok then
          begin
            qry.SQL.Text := 'select count(*) from Usuarios';
            qry.Open;
            if qry.Fields[0].AsInteger > 200 then
            begin
              Application.MessageBox('Hay más de 200 personas configuradas en la base de datos. No se puede ingresar en modo descargador', 'Error', MB_OK + MB_ICONERROR);
              base_ok := False;
            end;
            qry.Close;
          end;
          {$ENDIF}

        finally
          qry.Free;
        end;
      end;

   except
      on E: Exception do
      begin
        ShowMessage(E.Message);
        base_ok := False;
      end;
   end;
 end;

 Result := base_ok;
end;

//---------------------------------------------------------------------------
// CREA UNA TABLA EN LA BASE DE DATOS
//---------------------------------------------------------------------------

procedure Tdata.Crea_tabla(t: String);
var
  tbl: TTable;
begin
  tbl := TTable.Create(Application);
  with tbl do
  try
    // Propiedades de la tabla
    DatabaseName := 'MIBASE';

    if TIPO_BASE = PARADOX then
    begin
      TableType := ttParadox;
      TableName := t + '.DB';
    end
    else
    begin
      TableType := ttDefault;
      TableName := t;
    end;

    if TIPO_BASE = PARADOX then
    begin
      // Define los campos de la tabla
      with FieldDefs do
      begin
        if t = 'Usuarios' then
        begin
          Add('Usr_id', ftInteger, 0, False);    // Identificador del Usuario
          Add('Usr_nom', ftString, 60, False);   // Nombre y Apellido
          Add('Usr_tarj', ftString, 8, False);   // Número de tarjeta o touch
          Add('Usr_cod', ftString, 4, False);    // Código de teclado
          Add('Usr_grp', ftSmallint, 0, False);  // Grupo al que pertenece
          Add('Usr_fot', ftString, 20, False);   // Archivo de foto
          Add('Usr_fra', ftSmallint, 0, False);  // Franja asignada
          Add('Usr_cad', ftString, 11, False);   // Estado y Fecha de caducidad
          Add('Usr_susp', ftString, 2, False);   // Estado de suspensión
        end
        else if t = 'Nodos' then
        begin
          Add('Nod_id', ftInteger, 0, False);     // ID del nodo
          Add('Nod_nom', ftString, 40, False);    // Nombre del nodo
          Add('Nod_num', ftSmallint, 0, False);   // Número de nodo
          Add('Nod_grp', ftSmallint, 0, False);   // Grupo al que pertenece
          Add('Nod_dis', ftString, 3, False);     // Dispositivo conectado
        end
        else if t = 'GruposAcceso' then
        begin
          Add('Gu_num', ftSmallint, 0, False);
          Add('Gu_nom', ftString, 40, False);
        end
        else if t = 'GruposNodos' then
        begin
          Add('Gn_num', ftSmallint, 0, False);
          Add('Gn_nom', ftString, 40, False);
        end
        else if t = 'GruposFranjas' then
        begin
          Add('Gf_num', ftSmallint, 0, False);
          Add('Gf_nom', ftString, 40, False);
          Add('Gf_fra', ftSmallint, 0, False);
        end
        else if t = 'Asignaciones' then
        begin
          Add('Asg_id', ftInteger, 0, False);
          Add('Asg_nod', ftInteger, 0, False);
          Add('Asg_usr', ftInteger, 0, False);
        end
        else if t = 'Tip_Ev' then
        begin
          Add('Tip_id', ftString, 1, False);
          Add('Tip_desc', ftString, 25, False);
          Add('Tip_desc2', ftString, 25, False);
        end
        else if t = 'Eventos' then
        begin
          Add('Ev_id', ftAutoInc, 0, False);
          Add('Ev_tipo', ftString, 1, False);
          Add('Ev_pers', ftString, 40, False);
          Add('Ev_nod', ftString, 40, False);
          Add('Ev_fecha', ftString, 10, False);
          Add('Ev_fecha2', ftString, 10, False);
          Add('Ev_hora', ftString, 8, False);
          Add('Ev_tarj', ftString, 8, False);
          Add('Ev_cod', ftString, 4, False);
          Add('Ev_es', ftString, 1, False);
        end
        else if t = 'Franjas' then
        begin
          Add('Fr_num', ftSmallint, 0, False);
          Add('Fr_nom', ftString, 30, False);
          Add('Fr_desc', ftString, 80, False);
          Add('Fr_dat', ftString, 192, False);
        end
        else if t = 'Feriados' then
        begin
          Add('Fer_num', ftSmallint, 0, False);
          Add('Fer_fecha', ftString, 5, False);
        end
        else if t = 'Dispositivos' then
        begin
          Add('Dis_cod', ftString, 3, False);
          Add('Dis_direccion', ftString, 15, False);
        end;
      end;

      // Define los índices de la tabla
      with IndexDefs do
      begin
        if t = 'Usuarios' then
        begin
          Add('', 'Usr_id', [ixPrimary, ixUnique]);
          Add('Usuarios_IDX', 'Usr_nom;Usr_tarj;Usr_id', [ixCaseInsensitive]);
        end
        else if t = 'Asignaciones' then
        begin
          Add('', 'Asg_id', [ixPrimary, ixUnique]);
          Add('Asig_IDX', 'Asg_usr;Asg_nod', [ixCaseInsensitive]);
        end
        else if t = 'Eventos' then
        begin
          Add('', 'Ev_id', [ixPrimary, ixUnique]);
          Add('Eventos_IDX', 'Ev_fecha2;Ev_hora;Ev_pers;Ev_nod;Ev_fecha', [ixCaseInsensitive]);
        end;
      end;

      // Crea la tabla
      CreateTable;

      // Encripta la tabla recién creada
      if Active then Close;
      Exclusive := True;
      Open;
      AddMasterPassword(tbl, PARADOX_PASSWORD);
      Close;
      Exclusive := False;
    end;

    // Inserta registros por defecto
    if t = 'GruposAcceso' then
    begin
      Open;
      if RecordCount = 0 then
      begin
        AppendRecord([0, 'Administración']);
        AppendRecord([1, 'Gerencia']);
        //AppendRecord([2, 'Desarrollo']);
        //AppendRecord([3, 'Recepción']);
        //AppendRecord([4, 'Servicio Técnico']);
        //AppendRecord([5, 'Ventas']);
      end;
      Close;
    end
    else if t = 'Usuarios' then
    begin
      Open;
      Randomize;
      if RecordCount = 0 then
      begin
        AppendRecord([0, 'Ramiro Gonzalez', '10000000', 'FFFF', 0, '001.bmp', 1, 'N01/01/2000', 'NO']);
        AppendRecord([1, 'Graciela Wexler', '10000001', 'FFFF', 0, '002.bmp', 2, 'N01/01/2000', 'NO']);
        AppendRecord([2, 'Natalia Grey', '10000002', 'FFFF',    1, '003.bmp', 2, 'N01/01/2000', 'NO']);
        //AppendRecord([3, 'Miriam Paladino', '10000003', 'FFFF', 0, '004.bmp', 2, 'N01/01/2000', 'NO']);
        //AppendRecord([4, 'José Trapatoni', '10000004', 'FFFF',  5, '005.bmp', 1, 'N01/01/2000', 'NO']);
        //AppendRecord([5, 'Basilio Romero', '10000005', 'FFFF',  1, '006.bmp', 1, 'N01/01/2000', 'NO']);
      end;
      Close;
    end
    else if t = 'GruposNodos' then
    begin
      Open;
      if RecordCount = 0 then
      begin
        AppendRecord([0, '0 - Planta Baja']);
        AppendRecord([1, '1 - Primer Piso']);
        //AppendRecord([2, '2 - Segundo Piso']);
      end;
      Close;
    end
    else if t = 'GruposFranjas' then
    begin
      Open;
      if RecordCount = 0 then
      begin
        AppendRecord([1, 'Sin Restricciones', 1]);
        AppendRecord([2, 'Oficina', 2]);
      end;
      Close;
    end
    else if t = 'Nodos' then
    begin
      Open;
      Randomize;
      if RecordCount = 0 then
      begin
        AppendRecord([0, 'Acceso Principal', 1, 0, '']);
        AppendRecord([1, 'Entrada Primer Piso', 2, 1, '']);
        //AppendRecord([2, 'Entrada Segundo Piso', 3, 2, '']);
      end;
      Close;
    end
    else if t = 'Asignaciones' then
    begin
      Open;
      if RecordCount = 0 then
      begin
        AppendRecord([Random(2000000), 0, 0]);   // Todos en Acceso Principal
        AppendRecord([Random(2000000), 0, 1]);
        AppendRecord([Random(2000000), 0, 2]);
        //AppendRecord([Random(2000000), 0, 3]);
        //AppendRecord([Random(2000000), 0, 4]);
        //AppendRecord([Random(2000000), 0, 5]);

        AppendRecord([Random(2000000), 1, 1]);
        AppendRecord([Random(2000000), 1, 2]);
        //AppendRecord([Random(2000000), 1, 3]);
        //AppendRecord([Random(2000000), 1, 5]);

        //AppendRecord([Random(2000000), 2, 0]);
        //AppendRecord([Random(2000000), 2, 2]);
        //AppendRecord([Random(2000000), 2, 4]);
        //AppendRecord([Random(2000000), 2, 5]);
      end;
      Close;
    end
    else if t = 'Tip_Ev' then
    begin
      Open;
      if RecordCount = 0 then
      begin
        AppendRecord(['A', 'Acceso Normal',            'Accesos Normales']);
        AppendRecord(['R', 'Apertura Remota',          'Aperturas Remotas']);
        AppendRecord(['S', 'Carga Exitosa',            'Cargas Exitosas']);
        AppendRecord(['B', 'Descarga Exitosa',         'Descargas Exitosas']);
        AppendRecord(['I', 'Intruso',                  'Intrusos']);
        AppendRecord(['O', 'Nodo OFF-LINE',            'Nodos OFF-LINE']);
        AppendRecord(['C', 'Caducidad Vencida',        'Caducidades Vencidas']);
        AppendRecord(['P', 'Alarma Puerta Abierta',    'Alarmas Puerta Abierta']);
        AppendRecord(['T', 'Aviso Puerta Abierta',     'Avisos Puerta Abierta']);
        AppendRecord(['U', 'Acceso por Pulsador',      'Accesos por Pulsador']);
        AppendRecord(['F', 'Fuera de Horario',         'Fuera de Horario']);
      end;
      Close;
    end
    else if t = 'Feriados' then
    begin
      Open;
      if RecordCount = 0 then
      begin
        AppendRecord([1, '01/01']);
        AppendRecord([2, '02/04']);
        AppendRecord([3, '01/05']);
        AppendRecord([4, '25/05']);
        AppendRecord([5, '10/06']);
        AppendRecord([6, '20/06']);
        AppendRecord([7, '09/07']);
        AppendRecord([8, '17/08']);
        AppendRecord([9, '12/10']);
        AppendRecord([10, '25/12']);
        AppendRecord([11, '31/12']);
        AppendRecord([12, '01/01']);
        AppendRecord([13, '01/01']);
        AppendRecord([14, '01/01']);
        AppendRecord([15, '01/01']);
        AppendRecord([16, '01/01']);
        AppendRecord([17, '01/01']);
        AppendRecord([18, '01/01']);
        AppendRecord([19, '01/01']);
        AppendRecord([20, '01/01']);
        AppendRecord([21, '01/01']);
        AppendRecord([22, '01/01']);
        AppendRecord([23, '01/01']);
        AppendRecord([24, '01/01']);
        AppendRecord([25, '01/01']);
        AppendRecord([26, '01/01']);
        AppendRecord([27, '01/01']);
        AppendRecord([28, '01/01']);
        AppendRecord([29, '01/01']);
        AppendRecord([30, '01/01']);
        AppendRecord([31, '01/01']);
        AppendRecord([32, '01/01']);
      end;
      Close;
    end
    else if t = 'Franjas' then
    begin
      Open;
      if RecordCount = 0 then
      begin
        AppendRecord([1, 'Sin Restricciones',
                         'Horario sin Restricciones de Acceso',
                         StringOfChar('3', 192)]);
        AppendRecord([2, 'Horario de Oficina',
                         'Horario de Oficina: Lunes a Viernes de 9 a 13hs y de 14 a 18hs',
                         '000000000000000000000000' +
                         '000000000333303333000000' +
                         '000000000333303333000000' +
                         '000000000333303333000000' +
                         '000000000333303333000000' +
                         '000000000333303333000000' +
                         '000000000000000000000000' +
                         '000000000000000000000000' ]);
        AppendRecord([3, 'Horario Rotación 1/3',
                         'Horario de Rotación 1/3: Lunes a Domingo de 0 a 8hs',
                         '333333330000000000000000' +
                         '333333330000000000000000' +
                         '333333330000000000000000' +
                         '333333330000000000000000' +
                         '333333330000000000000000' +
                         '333333330000000000000000' +
                         '333333330000000000000000' +
                         '333333330000000000000000' ]);
        AppendRecord([4, 'Horario Rotación 2/3',
                         'Horario de Rotación 2/3: Lunes a Domingo de 8 a 16hs',
                         '000000003333333300000000' +
                         '000000003333333300000000' +
                         '000000003333333300000000' +
                         '000000003333333300000000' +
                         '000000003333333300000000' +
                         '000000003333333300000000' +
                         '000000003333333300000000' +
                         '000000003333333300000000' ]);
        AppendRecord([5, 'Horario Rotación 3/3',
                         'Horario de Rotación 3/3: Lunes a Domingo de 16 a 24hs',
                         '000000000000000033333333' +
                         '000000000000000033333333' +
                         '000000000000000033333333' +
                         '000000000000000033333333' +
                         '000000000000000033333333' +
                         '000000000000000033333333' +
                         '000000000000000033333333' +
                         '000000000000000033333333' ]);
        AppendRecord([6, 'Horario Turno Mañana',
                         'Horario Turno Mañana: Lunes a Viernes de 9 a 13hs',
                         '000000000000000000000000' +
                         '000000000333300000000000' +
                         '000000000333300000000000' +
                         '000000000333300000000000' +
                         '000000000333300000000000' +
                         '000000000333300000000000' +
                         '000000000000000000000000' +
                         '000000000000000000000000' ]);
        AppendRecord([7, 'Horario Turno Tarde',
                         'Horario Turno Tarde: Lunes a Viernes de 14 a 18hs',
                         '000000000000000000000000' +
                         '000000000000003333000000' +
                         '000000000000003333000000' +
                         '000000000000003333000000' +
                         '000000000000003333000000' +
                         '000000000000003333000000' +
                         '000000000000000000000000' +
                         '000000000000000000000000' ]);
        AppendRecord([8, 'Horario Turno Noche',
                         'Horario Turno Noche: Lunes a Viernes de 18 a 24hs',
                         '000000000000000000000000' +
                         '000000000000000000333333' +
                         '000000000000000000333333' +
                         '000000000000000000333333' +
                         '000000000000000000333333' +
                         '000000000000000000333333' +
                         '000000000000000000000000' +
                         '000000000000000000000000' ]);
        AppendRecord([9, 'Horario Completo Laboral',
                         'Horario Completo Semana Laboral: Lunes a Viernes todo el día',
                         '000000000000000000000000' +
                         '333333333333333333333333' +
                         '333333333333333333333333' +
                         '333333333333333333333333' +
                         '333333333333333333333333' +
                         '333333333333333333333333' +
                         '000000000000000000000000' +
                         '000000000000000000000000' ]);
        AppendRecord([10, 'Horario 1 Usuario',
                         'Horario 1 definible por el Usuario',
                         '333333333333333333333333' +
                         '000000000000000000000000' +
                         '000000000000000000000000' +
                         '000000000000000000000000' +
                         '000000000000000000000000' +
                         '000000000000000000000000' +
                         '000000000000000000000000' +
                         '000000000000000000000000' ]);
        AppendRecord([11, 'Horario 2 Usuario',
                         'Horario 2 definible por el Usuario',
                         '000000000000000000000000' +
                         '333333333333333333333333' +
                         '000000000000000000000000' +
                         '000000000000000000000000' +
                         '000000000000000000000000' +
                         '000000000000000000000000' +
                         '000000000000000000000000' +
                         '000000000000000000000000' ]);
        AppendRecord([12, 'Horario 3 Usuario',
                         'Horario 3 definible por el Usuario',
                         '000000000000000000000000' +
                         '000000000000000000000000' +
                         '333333333333333333333333' +
                         '000000000000000000000000' +
                         '000000000000000000000000' +
                         '000000000000000000000000' +
                         '000000000000000000000000' +
                         '000000000000000000000000' ]);
        AppendRecord([13, 'Horario 4 Usuario',
                         'Horario 4 definible por el Usuario',
                         '000000000000000000000000' +
                         '000000000000000000000000' +
                         '000000000000000000000000' +
                         '333333333333333333333333' +
                         '000000000000000000000000' +
                         '000000000000000000000000' +
                         '000000000000000000000000' +
                         '000000000000000000000000' ]);
        AppendRecord([14, 'Horario 5 Usuario',
                         'Horario 5 definible por el Usuario',
                         '000000000000000000000000' +
                         '000000000000000000000000' +
                         '000000000000000000000000' +
                         '000000000000000000000000' +
                         '333333333333333333333333' +
                         '000000000000000000000000' +
                         '000000000000000000000000' +
                         '000000000000000000000000' ]);
        AppendRecord([15, 'Horario 6 Usuario',
                         'Horario 6 definible por el Usuario',
                         '000000000000000000000000' +
                         '000000000000000000000000' +
                         '000000000000000000000000' +
                         '000000000000000000000000' +
                         '000000000000000000000000' +
                         '333333333333333333333333' +
                         '000000000000000000000000' +
                         '000000000000000000000000' ]);
        AppendRecord([16, 'Horario 7 Usuario',
                         'Horario 7 definible por el Usuario',
                         '000000000000000000000000' +
                         '000000000000000000000000' +
                         '000000000000000000000000' +
                         '000000000000000000000000' +
                         '000000000000000000000000' +
                         '000000000000000000000000' +
                         '333333333333333333333333' +
                         '000000000000000000000000' ]);
      end;
      Close;
    end;
  finally
    Free;
  end;
end;

procedure Tdata.ConsultaBeforeOpen(DataSet: TDataSet);
begin
     if d then ShowMessage(Consulta.SQL.Text);
end;

end.

