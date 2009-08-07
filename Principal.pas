//---------------------------------------------------------------------------
//
//  Módulo Principal del Programa
//  =============================
//
//  Revisión General OK 30-11-2000
//  Actualización con chequeo de claves 05-12-2000
//  Chequeo general 08-12-2000
//  About Box 09-12-2000
//  Oculta y muestra barra de títulos
//  Agregado de comando de reset de nodos 03-01-2001
//  Chequea protección SERKEY 10-01-2001
//  Usa nuevo sistema de seguridad v2.0 12-01-2001
//  Chequeo de rutinas Create de Form 12-01-2001
//  Agregado de chequeo de cantidad de colores de pantalla 13-01-2001
//  Módulo de Mantenimiento casi listo 19-01-2001
//  Cambio de nombre del proyecto a SAC32 24-01-2001
//  Nombre Empresa = "Desarrollos Digitales" 24-01-2001
//  Rutinas generales en UNIT "Rutinas.pas" 24-01-2001
//  Mejora de rutinas 25-01-2001
//  Eliminación de rutinas generales y de listas de imagenes 01-02-2001
//  Al ejecutarse por primera vez, crea variables en registro 19-02-2001
//  Implementación de la ayuda general y sensitiva al contexto 03-03-2001
//  Restricción de funciones en modo demo 03-03-2001
//  Chequeo de DLL COMCTL32.DLL versión >= 4.70 03-03-2001 (deshabilitado)
//  Se ordenan los íconos de los nodos por número de nodo 04-11-2001
//
//---------------------------------------------------------------------------

unit Principal;

interface

uses
  Windows, ExtCtrls, Menus, ImgList, Controls, ComCtrls, ToolWin, Graphics,
  Classes, StdCtrls, Forms, SysUtils, Messages, Registry, Dialogs, Comunicaciones,
  DBTables, AVLockPro, Placemnt;

type
  TFPrincipal = class(TForm)
    CoolBar1: TCoolBar;
    BarraIconos: TToolBar;
    cmdApRemota: TToolButton;
    BarraAccesos: TToolBar;
    cmdABM: TToolButton;
    cmdConfig: TToolButton;
    cmdReportes: TToolButton;
    cmdSubir: TToolButton;
    cmdBajar: TToolButton;
    cmdOpciones: TToolButton;
    GroupBox1: TGroupBox;
    ANodos: TTreeView;
    MenuLista: TPopupMenu;
    Borrarlista1: TMenuItem;
    N1: TMenuItem;
    cmdConsultar: TToolButton;
    Timer1: TTimer;
    Panel1: TPanel;
    LNodos: TListView;
    EstadoNodos: TStatusBar;
    Image2: TImage;
    cmdSeguridad: TToolButton;
    cmdLocalizador: TToolButton;
    cmdMantenimiento: TToolButton;
    cmdAbout: TToolButton;
    cmdSalir: TToolButton;
    MenuNodos: TPopupMenu;
    mnuApRemota: TMenuItem;
    mnuSubir: TMenuItem;
    mnuBajar: TMenuItem;
    mnuOpciones: TMenuItem;
    mnuConsultar: TMenuItem;
    cmdReinit: TToolButton;
    mnuReinit: TMenuItem;
    MenuFoto: TPopupMenu;
    mnuBorraImg: TMenuItem;
    MenuAyuda: TPopupMenu;
    AyudadeSAC321: TMenuItem;
    N2: TMenuItem;
    AcercadeSAC321: TMenuItem;
    Obtenerayudasobre1: TMenuItem;
    Label1: TLabel;
    cmdBloquear: TToolButton;
    cmdAtender: TToolButton;
    BloquearNodo1: TMenuItem;
    AtenderAlarma1: TMenuItem;
    AVLockPro1: TAVLockPro;
    Panel2: TPanel;
    GroupBox2: TGroupBox;
    LEventos: TListView;
    GroupBoxFoto: TGroupBox;
    Image1: TImage;
    Panel3: TPanel;
    BarraEstado: TStatusBar;
    Clockbar: TStatusBar;
    frmStore: TFormStorage;
    Splitter1: TSplitter;
    cmdTCPIP: TToolButton;
    tmrMuestra: TTimer;
    LimitacionesDescargador1: TMenuItem;
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure cmdABMClick(Sender: TObject);
    procedure ANodosChange(Sender: TObject; Node: TTreeNode);
    procedure cmdSubirClick(Sender: TObject);
    procedure cmdApRemotaClick(Sender: TObject);
    procedure Borrarlista1Click(Sender: TObject);
    procedure cmdConfigClick(Sender: TObject);
    procedure cmdOpcionesClick(Sender: TObject);
    procedure cmdReportesClick(Sender: TObject);
    procedure cmdBajarClick(Sender: TObject);
    procedure WREventoLST(Sender: TCustomListView; Item: TListItem; Rect: TRect; State: TOwnerDrawState);
    procedure cmdSalirClick(Sender: TObject);
    procedure AppException(Sender: TObject; E: Exception);
    procedure FormCreate(Sender: TObject);
    procedure BarraEstadoDrawPanel(StatusBar: TStatusBar; Panel: TStatusPanel; const Rect: TRect);
    procedure DisplayHint(Sender: TObject);
    procedure LNodosInfoTip(Sender: TObject; Item: TListItem; var InfoTip: String);
    procedure EstadoNodosDrawPanel(StatusBar: TStatusBar; Panel: TStatusPanel; const Rect: TRect);
    procedure LNodosSelectItem(Sender: TObject; Item: TListItem; Selected: Boolean);
    procedure Timer1Timer(Sender: TObject);
    procedure cmdConsultarClick(Sender: TObject);
    procedure ClockbarDrawPanel(StatusBar: TStatusBar; Panel: TStatusPanel; const Rect: TRect);
    procedure cmdSeguridadClick(Sender: TObject);
    procedure cmdLocalizadorClick(Sender: TObject);
    procedure cmdMantenimientoClick(Sender: TObject);
    procedure cmdAboutClick(Sender: TObject);
    procedure BarraEstadoDblClick(Sender: TObject);
    procedure cmdReinitClick(Sender: TObject);
    procedure mnuBorraImgClick(Sender: TObject);
    procedure AyudadeSAC321Click(Sender: TObject);
    procedure AcercadeSAC321Click(Sender: TObject);
    procedure GroupBox2DblClick(Sender: TObject);
    procedure cmdBloquearClick(Sender: TObject);
    procedure cmdAtenderClick(Sender: TObject);
    procedure FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure FormKeyUp(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure ClockbarMouseMove(Sender: TObject; Shift: TShiftState; X, Y: Integer);
    procedure cmdTCPIPClick(Sender: TObject);
    procedure tmrMuestraTimer(Sender: TObject);
    procedure LimitacionesDescargador1Click(Sender: TObject);

  private
    { Private declarations }
    procedure WMEndSession(var Msg:TWMEndSession); message WM_ENDSESSION;
    procedure WMNCHitTest(var M: TWMNCHitTest); message wm_NCHitTest;
    procedure HideTitlebar;
    procedure ShowTitlebar;
    procedure WMUser(var msg: TMessage); message wm_User;

  public
    { Public declarations }
    Nod_Status: Array[1..MAX_NOD] of Integer;
    procedure ConsultaNodos;
    procedure ActualizaEstadoNodos(nodo: Integer);
  end;

var
  FPrincipal: TFPrincipal;      // Form Principal
  loc : Boolean = False;

//---------------------------------------------------------------------------
// IMPLEMENTACION DE LAS RUTINAS
//---------------------------------------------------------------------------

implementation

uses Datos, ConfigNodo, ABM, Seguridad, Localizador, UEvento, Busqueda, Mantenimiento,
  About, UModem, Rutinas, Serkey, Paquetes, ConfigPC, Reportes, Franjas, Demo, Feriados,
  ModoDescargador, Pump, AdminTCPIP, LimitacionesDescargador, CocherasTita;

{$R *.DFM}

//---------------------------------------------------------------------------
// CREACIÓN DE LA VENTANA PRINCIPAL DEL PROGRAMA
//---------------------------------------------------------------------------

procedure TFPrincipal.FormCreate(Sender: TObject);
var
  i: Integer;
  tita: TFCocherasTita;
begin
  // 05-01-2006 Prueba EasterEgg
  //EasterEgg();

  // Corrección 22/02/2004 - Permite copiar base Paradox a Interbase
  if FindCmdLineSwitch('pump', ['/', '-'], True) then
  begin
    if modo_muestra then
    begin
      // En modo muestra no se puede conectar a Interbase
      Application.MessageBox('En modo muestra no se puede acceder a la base Interbase para migrarla', 'Advertencia', MB_OK + MB_ICONINFORMATION);
      Application.Terminate;
    end
    else
    begin
      Application.CreateForm(TFPump, FPump);
      try
        FPump.ShowModal;
      finally
        FPump.Release;
        Application.Terminate;
      end;
    end;
    Exit;
  end
  else
  begin
    // Inicializa Título de la Aplicación
    Application.Title := 'SAC32 ' + GetFileVersion(Application.ExeName);
    Top := Screen.Height + 1;  // Truquito para evitar parpadeo
    Left := Screen.Width + 1;

    // 24/04/2004
    // En modo muestra, agrega texto al caption
    if modo_muestra then
      Application.Title := Application.Title + ' (MODO MUESTRA)';

    // Chequea versión de COMCTL32.DLL
    if not Check_COMCTL32 then Application.Terminate
    else
    begin
      // Chequea modo de video mínimo.
      if not Check_Video_Mode then Application.Terminate
      else
      begin
        Config_Cript_Key;               // Clave de encriptación del programa
        Config_Registro;                // Configura variables del registro
        Config_Carpeta;                 // Configura Carpeta del programa
        Config_Locale;                  // Configura formato fecha y hora
        Config_Ayuda;                   // Configura archivo de ayuda
        Config_Serkey;                  // Configura llave de protección
        Application.OnException := AppException; // Configura handlers
        Application.OnHint := DisplayHint;
        if (ReadReg_S('UFot') = '') then
           WriteReg_S('UFot', carpeta + 'Fotos');

        // Mensaje para MODO DEMO HARDWIRED
        {Application.CreateForm(TFDemo, FDemo);
        FDemo.Image1.Visible := False;
        FDemo.Label1.Caption := 'Muestra de Evaluación';
        FDemo.Label1.Font.Size := 16;
        FDemo.Label2.Top := FDemo.Label2.Top - 20;
        FDemo.Label2.Caption := 'El siguiente programa es solamente una muestra sin valor comercial enviada para su evaluación a la empresa Netlan S.A.'#13'Ingresar como'#13'usuario = "administrador" y clave = "1234"'#13#13'Autor: Daniel Alvarez'#13'daniel@alvarez.net.ar';
        FDemo.ShowModal;
        FDemo.Free;}

        // Chequea login del usuario
        if not Logon then Application.Terminate
        else
        begin
          // 24/04/2004 - Muestra ventana de modo MUESTRA
          VentanaModoMuestra;

          // Intenta conexión a BD
          if not data.DBConnect then
          begin
              // Si hubo error pregunta si cambia opciones de ubicación de BD
              if Application.MessageBox('Error inicializando base de datos.'#13'Corrija ubicación de base de datos'#13'Desea corregir la configuración?', 'Error', MB_YESNO + MB_ICONQUESTION) = ID_YES then
              begin
                 // Muestra ventana de configuración del sistema
                 Application.CreateForm(TFConfiguracion, FConfiguracion);
                 with FConfiguracion do
                 begin
                    // Selecciona la opción de Ubicación de Datos
                    Opciones.Selected := Opciones.Items[2];
                    OpcionesChange(Self, Opciones.Selected);
                    ShowModal;
                    Free;
                 end;
              end;
          end;

          // Si la base no inicializó bien, termina el programa
          if not base_ok then
          begin
               Application.MessageBox('La base de datos no se configuró correctamente.', 'Error', MB_OK + MB_ICONHAND);
               Application.Terminate;
          end
          else
          begin
            // Abre el puerto serie (mensaje si no pudo abrirlo correctamente)
            if not p.InitPort then
            begin
              Application.MessageBox('El puerto serie configurado no existe o ya está en uso'#13'Configure el puerto que corresponda', 'Error', MB_OK + MB_ICONHAND);

              // Muestra ventana de configuración del sistema
              Application.CreateForm(TFConfiguracion, FConfiguracion);
              with FConfiguracion do
              begin
                // Selecciona la opción de Comunicaciones
                Opciones.Selected := Opciones.Items[0];
                OpcionesChange(Self, Opciones.Selected);
                ShowModal;
                Free;
              end;
            end;

            // Carga estados iniciales en Nod_Status
            for i:=1 to MAX_NOD do Nod_Status[i] := 2;      // Desconocido;

            Config_Window;               // Configura ventana principal
            CargaNodos;                  // Carga el árbol de nodos

            // Actualiza fecha y hora
            Timer1Timer(Self);
            Clockbar.Repaint;

            //ConsultaNodos;               // Lee estado de los nodos
            Config_Seguridad;            // Habilita botones permitidos
            InitModem;                   // Inicializa modem
            Config_Desc_Automatica;      // Configura la descarga automática

            // Inicializa ventana de paquetes si en modo debug
            if debug then
            begin
                Application.CreateForm(TFPaquetes, FPaquetes);
                FPaquetes.FormStyle := fsStayonTop;
                FPaquetes.Show;
            end;

            // Corrección 13/03/2004 - Crea ventana de administración de TCP/IP
            FAdminTCPIP := TFAdminTCPIP.Create(Self);

            // 24/04/2004 - Daniel
            if modo_muestra then
            begin
              tmrMuestra.Interval := 1000 * 60;  // 1000 = 1 segundo, Timer cuenta por minutos
              Timeout_ModoMuestra := MINUTOS_MODO_MUESTRA;  // Tiempo en minutos, de uso en modo muestra;
              tmrMuestra.Enabled := True;
            end;

            {$IFDEF TITA}
            tita :=  TFCocherasTita.Create(nil);
            tita.ShowModal;
            tita.Release;
            {$ENDIF}
          end;
        end;
      end;
    end;
  end;
end;

//---------------------------------------------------------------------------
// CIERRA EL FORM
//---------------------------------------------------------------------------

procedure TFPrincipal.FormClose(Sender: TObject; var Action: TCloseAction);
begin
    if Application.MessageBox('Seguro que quiere cerrar la aplicación?', 'Confirmación', MB_YESNO + MB_ICONQUESTION) = ID_YES then
    begin
      // Graba ubicación de la ventana principal
      WriteReg_I('Main.Top', Top);
      WriteReg_I('Main.Left', Left);

      // Si está en modo remoto, cierra la ventana de estado de modem
      if p.Modem then FModem.Close;

      // Si en modo debug cierra ventana de paquetes
      if debug then FPaquetes.Close;

      // Cierra el puerto serie
      p.ClosePort;

      // Cierra conexión con la base de datos
      data.Database.Connected := False;

      // Cierra el programa
      Action := caFree;
    end

    // Si repondió NO, aborta la operación
    else Action := caNone;
end;

//---------------------------------------------------------------------------
// ABRE LA VENTANA DE ABM AVANZADO Y ASIGNACIONES
//---------------------------------------------------------------------------

procedure TFPrincipal.cmdABMClick(Sender: TObject);
begin
    // Muestra ventana modo demo
    vdemo;

    // Crea y muestra ventana de ABM
    Application.CreateForm(TFABM, FABM);
    try
      FABM.ShowModal;
    finally
      FABM.Release;
    end;

    // Actualiza arbol de nodos con los cambios realizados
    CargaNodos;
end;

//---------------------------------------------------------------------------
// ABRE LA VENTANA DE CONFIGURACIÓN DEL SISTEMA
//---------------------------------------------------------------------------

procedure TFPrincipal.cmdConfigClick(Sender: TObject);
begin
   // Muestra ventana modo demo
   vdemo;

   // Crea y muestra ventana de configuración del sistema
   Application.CreateForm(TFConfiguracion, FConfiguracion);
   try
     FConfiguracion.ShowModal;
   finally
     FConfiguracion.Release;
   end;
end;

//---------------------------------------------------------------------------
// ABRE MÓDULO DE GENERACIÓN DE REPORTES
//---------------------------------------------------------------------------

procedure TFPrincipal.cmdReportesClick(Sender: TObject);
begin
    // Muestra ventana modo demo
    vdemo;

    // Crea y muestra ventana de reportes
    Application.CreateForm(TFReportes, FReportes);
    with FReportes do
    begin
         //Height := 380;
         ShowModal;
         Free;
    end;
end;

//---------------------------------------------------------------------------
// ABRE MÓDULO DE SEGURIDAD
//---------------------------------------------------------------------------

procedure TFPrincipal.cmdSeguridadClick(Sender: TObject);
begin
  // En modo descargador, no permite seguridad
  if not llave.modofull then
  begin
    Application.MessageBox('En el modo descargador no está habilitado el módulo de seguridad', 'Advertencia', MB_OK + MB_ICONINFORMATION);
    Exit;
  end;

  // Muestra ventana modo demo
  vdemo;

  // Crea y muestra ventana de seguridad
  Application.CreateForm(TFSeg, FSeg);
  try
    FSeg.ShowModal;
  finally
    FSeg.Release;
  end;
end;

//---------------------------------------------------------------------------
// ABRE MÓDULO LOCALIZADOR DE PERSONAS
//---------------------------------------------------------------------------

procedure TFPrincipal.cmdLocalizadorClick(Sender: TObject);
var
   p : String;
   f : Boolean;
   i : Integer;
   Item : TListItem;
begin
    // En modo descargador, no permite localizador
    if not llave.modofull then
    begin
      Application.MessageBox('En el modo descargador no está habilitado el módulo localizador de personas', 'Advertencia', MB_OK + MB_ICONINFORMATION);
      Exit;
    end;

    // Muestra ventana modo demo
    vdemo;

    // Crea ventana de búsqueda
    Application.CreateForm(TFBusqueda, FBusqueda);

    try
      // Agrega todas las personas al combo
      with FBusqueda do
      begin
        Label1.Caption := 'Ingrese nombre de la persona';
        ComboBox1.Items.Clear;
        with data.Consulta do
        begin
            SQL.Clear;
            SQL.Add('SELECT Usr_nom FROM Usuarios');
            Open;
            while not Eof do
            begin
                ComboBox1.Items.Add(FieldbyName('Usr_nom').AsString);
                Next;
            end;
            Close;
        end;
        ComboBox1.Sorted := True;
      end;

      // Muestra ventana
      if FBusqueda.ShowModal = mrOK then
      begin
        p := FBusqueda.ComboBox1.Text;

        f := False;
        // Recorre todas las personas
        for i:=0 to FBusqueda.ComboBox1.Items.Count-1 do
        begin
             if Pos(UpperCase(p), UpperCase(FBusqueda.ComboBox1.Items[i])) <> 0 then
             begin
                  f := True;
                  break;
             end;
        end;

        if not f then
           Application.MessageBox('No se encontró ninguna persona con ese nombre', 'Mensaje', MB_OK + MB_ICONEXCLAMATION)
        else
        begin
           // Busca último evento de esa persona
           with data.Consulta do
           begin
              SQL.Clear;
              SQL.Add('SELECT Ev_pers, Ev_tarj, Ev_fecha, Ev_hora, Ev_es, Ev_nod, Ev_tipo, Ev_fecha2, Usr_fot');
              SQL.Add('FROM Eventos');
              SQL.Add('INNER JOIN Usuarios ON (Usr_nom = Ev_pers)');
              SQL.Add('WHERE Ev_pers = :nombre');
              SQL.Add('ORDER BY Ev_fecha2 DESC, Ev_hora DESC');
              ParambyName('nombre').AsString := FBusqueda.ComboBox1.Items[i];
              Open;
              if RecordCount = 0 then
              begin
                 Close;
                 Application.MessageBox('Esa persona no tiene ningún evento', 'Mensaje', MB_OK + MB_ICONEXCLAMATION);
              end
              else
              begin
                 Application.CreateForm(TFUEv, FUEv);
                 with FUev do
                 begin
                    // Rellena labels con último evento de esa persona
                    Label1.Caption := FBusqueda.ComboBox1.Items[i] + ' (Tarjeta: ' + FieldbyName('Ev_tarj').AsString + ')';
                    Label2.Caption := FieldbyName('Ev_nod').AsString;
                    if FieldbyName('Ev_es').AsString = 'E' then
                       Label2.Caption := Label2.Caption + ' (Entrada)'
                    else Label2.Caption := Label2.Caption + ' (Salida)';
                    Label3.Caption := FormatDateTime('dddd, dd "de" mmmm "de" yyyy', StrtoDate(FieldbyName('Ev_fecha').AsString));
                    Label6.Caption := FieldbyName('Ev_hora').AsString;
                                    
                    // Carga foto de la persona
                    try
                      Image1.Picture.LoadfromFile(ReadReg_S('Ufot') + '\' + FieldbyName('Usr_fot').AsString);
                      Image1.Show;
                    except
                      Image1.Hide;
                    end;

                    // Rellena lista con último 20 eventos de esa persona
                    with LEv do
                    begin
                       i := 1;
                       repeat
                           Item := Items.Add;
                           Item.Caption := FieldbyName('Ev_nod').AsString;

                           if FieldbyName('Ev_es').AsString = 'E' then
                               Item.SubItems.Add('Entrada')
                           else
                               Item.SubItems.Add('Salida');

                           Item.SubItems.Add(FieldbyName('Ev_fecha').AsString);
                           Item.SubItems.Add(FieldbyName('Ev_hora').AsString);

                           data.Consulta.Next;
                           inc(i);

                       until (i>20) or Eof;
                       Selected := Items[0];
                    end;

                    ShowModal;
                    Free;
                 end;

                 Close;
              end;
           end;
        end;
      end;
    finally
      FBusqueda.Release;
    end;
end;

//---------------------------------------------------------------------------
// ABRE LA VENTANA DE MANTENIMIENTO
//---------------------------------------------------------------------------

procedure TFPrincipal.cmdMantenimientoClick(Sender: TObject);
begin
    // Muestra ventana modo demo
    vdemo;

    // Muestra mensaje que las comunicaciones están temporariamente deshabilitadas
    Application.MessageBox('Se dehabilitarán temporariamente las comunicaciones mientras esté en modo mantenimiento',
                           'Advertencia', MB_OK + MB_ICONINFORMATION);
    p.hab_online := False;

    // Crea y abre la ventana de mantenimiento del sistema
    Application.CreateForm(TFMant, FMant);
    try
      FMant.ShowModal;
    finally
      FMant.Release;
    end;

    p.hab_online := True;
end;

//---------------------------------------------------------------------------
// ABRE EL MENÚ DE AYUDA
//---------------------------------------------------------------------------

procedure TFPrincipal.cmdAboutClick(Sender: TObject);
begin
     // Abre el menú de ayuda
     MenuAyuda.PopUp(Mouse.CursorPos.X, Mouse.CursorPos.Y);
end;

//---------------------------------------------------------------------------
// ABRE LA AYUDA DEL PROGRAMA
//---------------------------------------------------------------------------

procedure TFPrincipal.AyudadeSAC321Click(Sender: TObject);
begin
     Application.HelpCommand(HELP_FINDER, 0);
end;

//---------------------------------------------------------------------------
// ABRE LA VENTANA DE ABOUT
//---------------------------------------------------------------------------

procedure TFPrincipal.AcercadeSAC321Click(Sender: TObject);
begin
    // Crea y abre la ventana de about
    Application.CreateForm(TFAbout, FAbout);
    try
      FAbout.ShowModal;
    finally
      FAbout.Release;
    end;
end;

//---------------------------------------------------------------------------
// BOTÓN SALIR DEL PROGRAMA
//---------------------------------------------------------------------------

procedure TFPrincipal.cmdSalirClick(Sender: TObject);
begin
     Close;
end;

//---------------------------------------------------------------------------
// REALIZA UNA APERTURA REMOTA EN LOS NODOS SELECCIONADOS
//---------------------------------------------------------------------------

procedure TFPrincipal.cmdApRemotaClick(Sender: TObject);
var i : Integer;
begin
  // En modo descargador, no permite
  if not llave.modofull then
  begin
    Application.MessageBox('En el modo descargador no está habilitada la apertura remota', 'Advertencia', MB_OK + MB_ICONINFORMATION);
    Exit;
  end;

  {if llave.mododemo then vdemo else
  begin}
    Arma_Array;       // Arma array con nodos seleccionados

    if Length(Nodos) = 0 then
        Application.MessageBox('Para realizar una apertura remota se debe seleccionar algún nodo', 'Información', MB_OK + MB_ICONINFORMATION)
    else
        for i:=0 to Length(Nodos)-1 do p.Apertura_Remota(Nodos[i]);
  {end;}
end;

//---------------------------------------------------------------------------
// SUBE LOS HABILITADOS AL NODO SELECCIONADO
//---------------------------------------------------------------------------

procedure TFPrincipal.cmdSubirClick(Sender: TObject);
var i : Integer;
begin
  {if llave.mododemo then vdemo else
  begin}
    // Arma array con los nodos seleccionados
    Arma_Array;

    if Length(Nodos) = 0 then
        Application.MessageBox('Para cargar los habilitados se debe seleccionar algún nodo', 'Información', MB_OK + MB_ICONINFORMATION)
    else
        for i:=0 to Length(Nodos)-1 do
           if cmdSubir.Tag = 0 then p.Upload_Tarjetas(Nodos[i])
           else                     p.Compara_Tarjetas(Nodos[i]);
  {end;}
end;

//---------------------------------------------------------------------------
// BAJA LOS EVENTOS DEL NODO
//---------------------------------------------------------------------------

procedure TFPrincipal.cmdBajarClick(Sender: TObject);
var i : Integer;
begin
  {if llave.mododemo then vdemo else
  begin}
    // Arma array con los nodos seleccionados
    Arma_Array;

    if Length(Nodos) = 0 then
        Application.MessageBox('Para descargar los eventos se debe seleccionar algún nodo', 'Información', MB_OK + MB_ICONINFORMATION)
    else
        for i:=0 to Length(Nodos)-1 do p.Download_Ev(Nodos[i]);
  {end;}
end;

//---------------------------------------------------------------------------
// CONFIGURA PROPIEDADES DE UN NODO
//---------------------------------------------------------------------------

procedure TFPrincipal.cmdOpcionesClick(Sender: TObject);
begin
  {if llave.mododemo then vdemo else
  begin}
    // Arma array con los nodos seleccionados
    Arma_Array;

    if Length(Nodos) = 0 then
        Application.MessageBox('Para configurar opciones se debe seleccionar algún nodo', 'Información', MB_OK + MB_ICONINFORMATION)
    else
    begin
       //Crea ventana de propiedades de nodos
       Application.CreateForm(TFConfigNodo, FConfigNodo);
       with FConfigNodo do
       begin
          ShowModal;
          Free;
       end;
    end
  {end;}
end;

//---------------------------------------------------------------------------
// CONSULTA EL ESTADO DE LOS NODOS SELECCIONADOS
//---------------------------------------------------------------------------

procedure TFPrincipal.cmdConsultarClick(Sender: TObject);
var
  i: Integer;
  e: TStatus;
begin
  {if llave.mododemo then vdemo else
  begin}
    // Arma lista de nodos a consultar
    Arma_Array;

    if Length(Nodos) = 0 then
        Application.MessageBox('Para consultar el estado se debe seleccionar algún nodo', 'Información', MB_OK + MB_ICONINFORMATION)
    else
    begin
      // Consulta el estado en los nodos que correspondan.
      for i:=0 to Length(Nodos)-1 do
      begin
        if p.Get_Status(Nodos[i], e) then     // Consulta estado
        begin
           case e.estado of
            0: Nod_Status[Nodos[i]] := 0;       // Online
            1: Nod_Status[Nodos[i]] := 12;      // Bloqueado
            2: Nod_Status[Nodos[i]] := 8;       // Alarma Puerta Ab.
           end;
           ActualizaEstadoNodos(Nodos[i]);
           //str := 'Online';
        end
        else
        begin
           //index := 1;
           //str := 'Offline';
           Nod_Status[Nodos[i]] := 1;
           ActualizaEstadoNodos(Nodos[i]);
           PlayWav('ERR');
           p.Evento_Local('O', Nodos[i]);
        end;

        // Busca nodo en la lista de iconos y configura texto e imagen
        {for j:=0 to LNodos.Items.Count-1 do
        begin
          if LNodos.Items[j].SubItems[0] = InttoStr(Nodos[i]) then
          begin
            LNodos.Items[j].ImageIndex := index;
            Nod_Status[Nodos[i]] := index;
            LNodos.Items[j].SubItems[2] := 'Nodo ' + str;
          end;
        end;}
      end;
    end;
  {end;}
end;

//---------------------------------------------------------------------------
// RESETEA LOS NODOS SELECCIONADOS
//---------------------------------------------------------------------------

procedure TFPrincipal.cmdReinitClick(Sender: TObject);
var i : Integer;
begin
  {if llave.mododemo then vdemo else
  begin}
    // Arma array con nodos seleccionados
    Arma_Array;

    if Length(Nodos) = 0 then
        Application.MessageBox('Para realizar una reinicialización se debe seleccionar algún nodo', 'Información', MB_OK + MB_ICONINFORMATION)
    else
        // Realiza la apertura remota en los nodos que correspondan.
        for i:=0 to Length(Nodos)-1 do
        begin
           if p.Reset(Nodos[i]) then Nod_Status[Nodos[i]] := 0
           else                      Nod_Status[Nodos[i]] := 1;
           ActualizaEstadoNodos(Nodos[i]);
        end;
  {end;}
end;

//---------------------------------------------------------------------------
// BLOQUEA LOS NODOS SELECCIONADOS
//---------------------------------------------------------------------------

procedure TFPrincipal.cmdBloquearClick(Sender: TObject);
var i : Integer;
begin
  // En modo descargador, no permite
  if not llave.modofull then
  begin
    Application.MessageBox('En el modo descargador no está habilitado el bloqueo de nodos', 'Advertencia', MB_OK + MB_ICONINFORMATION);
    Exit;
  end;

  {if llave.mododemo then vdemo else
  begin}
    Arma_Array;       // Arma array con nodos seleccionados

    if Length(Nodos) = 0 then
        Application.MessageBox('Para realizar un bloqueo se debe seleccionar algún nodo', 'Información', MB_OK + MB_ICONINFORMATION)
    else
        for i:=0 to Length(Nodos)-1 do p.Bloqueo(Nodos[i]);
  {end;}
end;

//---------------------------------------------------------------------------
// ATIENDE LA ALARMA EN LOS NODOS SELECCIONADOS
//---------------------------------------------------------------------------

procedure TFPrincipal.cmdAtenderClick(Sender: TObject);
var i : Integer;
begin
  // En modo descargador, no permite
  if not llave.modofull then
  begin
    Application.MessageBox('En el modo descargador no están habilitadas las alarmas', 'Advertencia', MB_OK + MB_ICONINFORMATION);
    Exit;
  end;

  {if llave.mododemo then vdemo else
  begin}
    Arma_Array;       // Arma array con nodos seleccionados

    if Length(Nodos) = 0 then
        Application.MessageBox('Para atender la alarma se debe seleccionar algún nodo', 'Información', MB_OK + MB_ICONINFORMATION)
    else
        for i:=0 to Length(Nodos)-1 do p.AtenderAlarma(Nodos[i]);
  {end;}
end;

//---------------------------------------------------------------------------
// ACTUALIZA ICONOS DE NODOS AL CAMBIAR SELECCIÓN EN ARBOL DE NODOS
//---------------------------------------------------------------------------

procedure TFPrincipal.ANodosChange(Sender: TObject; Node: TTreeNode);
var
  Item : TListItem;
  grupo, nodo : String;
begin
  // Filtra búsqueda de grupo y nodo
  case Node.Level of
    0:     begin grupo := '%';              nodo := '%';       end;
    1:     begin grupo := Node.Text;        nodo := '%';       end;
    2:     begin grupo := 'Ninguno';        nodo := 'Ninguno';  end;
  end;

  // Prepara consulta de nodos
  with data.Consulta do
  begin
      SQL.Clear;
      SQL.Add('SELECT Nod_nom, Nod_num, Gn_nom FROM Nodos');
      SQL.Add('INNER JOIN GruposNodos ON  (Nod_grp = Gn_num)');
      SQL.Add('WHERE (Nod_nom like :nodo) AND (Gn_nom like :grupo)');
      SQL.Add('ORDER BY Nod_num');
      ParambyName('nodo').AsString := nodo;
      ParambyName('grupo').AsString := grupo;
      Open;

      // Añade los nodos seleccionados a la lista
      LNodos.Items.Clear;

      while not Eof do
      begin
        Item := LNodos.Items.Add;
        with Item do
        begin
            Caption := FieldbyName('Nod_nom').AsString;
            ImageIndex := Nod_Status[FieldbyName('Nod_num').AsInteger];
            SubItems.Add(InttoStr(FieldbyName('Nod_num').AsInteger));
            SubItems.Add(FieldbyName('Gn_nom').AsString);
            case Nod_Status[FieldbyName('Nod_num').AsInteger] of
              0:  SubItems.Add('Nodo Online');
              1:  SubItems.Add('Nodo Offline');
              2:  SubItems.Add('No Consultado');
              3:  SubItems.Add('Acceso Normal');
              4:  SubItems.Add('Apertura Remota');
              5:  SubItems.Add('Comunicación exitosa');
              6:  SubItems.Add('Acceso no Autorizado');
              7:  SubItems.Add('Tarjeta Caduca');
              8:  SubItems.Add('Alarma de Puerta Abierta');
              9:  SubItems.Add('Aviso de Puerta Abierta');
              10: SubItems.Add('Tarjeta fuera de horario');
              11: SubItems.Add('Acceso por Pulsador');
            end;
        end;
        Next;
      end;

      Close;

      // Muestra en barra de estado cantidad de nodos
      LNodosSelectItem(LNodos, LNodos.Items[0], False);
  end;
end;

//---------------------------------------------------------------------------
// MUESTRA INFOTIP DEL NODO SELECCIONADO EN LA LISTA (Nro Nodo y Estado)
//---------------------------------------------------------------------------

procedure TFPrincipal.LNodosInfoTip(Sender: TObject; Item: TListItem;
  var InfoTip: String);
begin
   InfoTip := 'Información del Nodo:' + #13 +
              'Nombre: ' + Item.Caption + #13 +
              'Número: ' + Item.SubItems[0] + #13 +
              'Grupo: ' + Item.SubItems[1] + #13 +
              'Estado: ' + Item.SubItems[2];
end;

//---------------------------------------------------------------------------
// DIBUJA BARRA DE ESTADO DE NODOS
//---------------------------------------------------------------------------

procedure TFPrincipal.EstadoNodosDrawPanel(StatusBar: TStatusBar;
  Panel: TStatusPanel; const Rect: TRect);
begin
  if Panel.Index = 2 then
  begin
      with EstadoNodos.Canvas do
      begin
        Font.Color := clBlack;
        TextOut(Rect.left + 23, Rect.top + 1, 'Nodos');
        data.IconosBarraEstado.Draw(EstadoNodos.Canvas, Rect.Left + 3, Rect.Top, 3);
      end;
  end;
end;

//---------------------------------------------------------------------------
// VA SELECCIONANDO O DESELECCIONANDO NODOS DE LA LISTA
//---------------------------------------------------------------------------

procedure TFPrincipal.LNodosSelectItem(Sender: TObject; Item: TListItem;
  Selected: Boolean);
var
    i, n : Integer;
begin
    // Cuenta nodos seleccionados
    n := 0;
    for i:=0 to LNodos.Items.Count-1 do
        if LNodos.Items[i].Selected then inc(n);

    // Muestra cuantos nodos hay seleccionados o no seleccionados
    with EstadoNodos.Panels[0] do
      Text := InttoStr(n) + ' de ' + InttoStr(LNodos.Items.Count) + ' objetos seleccionados';
end;

//---------------------------------------------------------------------------
// BORRA LA LISTA DE EVENTOS EN PANTALLA
//---------------------------------------------------------------------------

procedure TFPrincipal.Borrarlista1Click(Sender: TObject);
begin
  LEventos.Items.BeginUpdate;
  LEventos.Items.Clear;
  LEventos.Items.EndUpdate;
end;

//---------------------------------------------------------------------------
// BORRA LA IMAGEN ACTUAL
//---------------------------------------------------------------------------

procedure TFPrincipal.mnuBorraImgClick(Sender: TObject);
begin
  FPrincipal.Image1.Hide;
end;

//---------------------------------------------------------------------------
// CAMBIA EL COLOR DE LA LÍNEA SEGÚN EL TIPO DE EVENTO
// (Ejecutado cada vez que se dibuja un item en la lista)
//---------------------------------------------------------------------------

procedure TFPrincipal.WREventoLST(Sender: TCustomListView;
  Item: TListItem; Rect: TRect; State: TOwnerDrawState);
var
    ItemRect : TRect;
    x : Integer;
begin
    with LEventos.Canvas do
    begin
      ItemRect := Rect;
      Brush.Style := bsSolid;

      with Brush do   // Selecciona el color del Brush
      begin
        case Item.Caption[1] of
        'A':          Color := clFICHADA;
        'R':          Color := clREMOTA;
        'S':          Color := clCOMANDO;
        'B':          Color := clCOMANDO;
        'I':          Color := clINTRUSO;
        'O':          Color := clERRCOM;
        'C':          Color := clCADUC;
        'P':          Color := clALARMA;
        'T':          Color := clAVISO;
        'F':          Color := clFUERA;
        'U':          Color := clPULSADOR
        end;
      end;

      FillRect(ItemRect);     // Llena el Rect con el color seleccionado

      // Escribe el evento
      x := 4;
      TextOut(ItemRect.Left + x, ItemRect.Top, Item.Caption);     x := x + 17;
      TextOut(ItemRect.Left + x, ItemRect.Top, Item.SubItems[0]); x := x + 125;
      TextOut(ItemRect.Left + x, ItemRect.Top, Item.SubItems[1]); x := x + 155;
      TextOut(ItemRect.Left + x, ItemRect.Top, Item.SubItems[2]); x := x + 65;
      TextOut(ItemRect.Left + x, ItemRect.Top, Item.SubItems[3]); x := x + 45;
      TextOut(ItemRect.Left + x, ItemRect.Top, Item.SubItems[4]); x := x + 70;
      TextOut(ItemRect.Left + x, ItemRect.Top, Item.SubItems[5]); x := x + 40;
      TextOut(ItemRect.Left + x, ItemRect.Top, Item.SubItems[6]);
    end;
end;

//---------------------------------------------------------------------------
// CUSTOMIZA BARRA DE ESTADO
//---------------------------------------------------------------------------

procedure TFPrincipal.BarraEstadoDrawPanel(StatusBar: TStatusBar;
  Panel: TStatusPanel; const Rect: TRect);
var
    i : Integer;
begin
    // Escribe estado de puerto serie
    if Panel.Index = 0 then
    begin
        with BarraEstado.Canvas do
        begin
          if Copy(p.txt_status, 6, 2) = 'OK' then
          begin
            i := 0;                  // Imagen OK
            Font.Color := clGreen;   // Color Verde
          end
          else
          begin
            i := 1;                  // Imagen KO
            Font.Color := clRed;     // Color Rojo
          end;
          // Escribe Texto
          TextOut(Rect.left + 3, Rect.top + 3, p.txt_status);
          // Dibuja imagen
          data.IconosBarraEstado.Draw(BarraEstado.Canvas, Rect.Left + 60, Rect.Top + 2, i);
        end;
    end

    // Escribe nombre del usuario logueado
    else if Panel.Index = 1 then
    begin
      with BarraEstado.Canvas do
      begin
          data.IconosBarraEstado.Draw(BarraEstado.Canvas, Rect.Left + 1, Rect.Top + 2, 2);
          TextOut(Rect.left + 19, Rect.top + 3, logued);
      end;
    end;
end;

//---------------------------------------------------------------------------
// HANDLER DE HINTS
//---------------------------------------------------------------------------

procedure TFPrincipal.DisplayHint(Sender: TObject);
begin
    //BarraEstado.Panels[2].Text := GetLongHint(Application.Hint);
end;

//---------------------------------------------------------------------------
// HANDLER DE EXCEPCIONES
//---------------------------------------------------------------------------

procedure TFPrincipal.AppException(Sender: TObject; E: Exception);
begin
  Application.MessageBox(PChar(E.Message), 'Excepción del sistema', MB_OK + MB_ICONHAND);
  //Application.Terminate;
end;

//---------------------------------------------------------------------------
// MUESTRA FECHA Y HORA EN BARRA DE ESTADO
//---------------------------------------------------------------------------

procedure TFPrincipal.Timer1Timer(Sender: TObject);
begin
  ClockBar.Repaint;
  //BarraEstado.Panels[2].Text := 'Próxima descarga = ' + DateTimetoStr(p.DescAuto.HoraProxDescarga);
end;

//---------------------------------------------------------------------------
// ACTUALIZA RELOJ
//---------------------------------------------------------------------------

procedure TFPrincipal.ClockbarDrawPanel(StatusBar: TStatusBar; Panel: TStatusPanel; const Rect: TRect);
//var
//   h1, h2, m1, m2, s1, s2, ms1, ms2: Word;
begin
    with Clockbar.Canvas do
    begin
        data.IconosBarraEstado.Draw(Clockbar.Canvas, Rect.Left + 1 + 18, Rect.Top + 2, 4);
        TextOut(Rect.left + 19 + 18, Rect.top + 3, FormatDateTime('hh:mm', Now));

        // Si está habilitada la descarga automática, chequea el horario de ésta
        if p.DescAuto.hab then
        begin
           data.IconosBarraEstado.Draw(Clockbar.Canvas, Rect.Left + 1, Rect.Top +2, 5);

           if Now >= p.DescAuto.HoraProxDescarga then
           begin
               // Setea horario de próxima descarga
               p.DescAuto.HoraProxDescarga := Now + (p.DescAuto.Intervalo / 1440);

               // Efectúa la descarga automática
               p.DescargaAutomatica;
           end;
        end
        else
           data.IconosBarraEstado.Draw(Clockbar.Canvas, Rect.Left + 1, Rect.Top +2, 6);
    end;
end;

//---------------------------------------------------------------------------
// OCULTA LA BARRA DE TÍTULOS
//---------------------------------------------------------------------------

procedure TFPrincipal.HideTitlebar;
var
  Save : LongInt;
begin
  If BorderStyle=bsNone then Exit;
  Save:=GetWindowLong(Handle,gwl_Style);
  If (Save and ws_Caption)=ws_Caption then Begin
    Case BorderStyle of
      bsSingle,
      bsSizeable : SetWindowLong(Handle,gwl_Style,Save and
        (Not(ws_Caption)) or ws_border);
      bsDialog : SetWindowLong(Handle,gwl_Style,Save and
        (Not(ws_Caption)) or ds_modalframe or ws_dlgframe);
    End;
    Height:=Height-getSystemMetrics(sm_cyCaption);
    Refresh;
  end;
end;

//---------------------------------------------------------------------------
// MUESTRA LA BARRA DE TÍTULOS
//---------------------------------------------------------------------------

procedure TFPrincipal.ShowTitlebar;
var
  Save : LongInt;
begin
  If BorderStyle=bsNone then Exit;
  Save:=GetWindowLong(Handle,gwl_Style);
  If (Save and ws_Caption)<>ws_Caption then Begin
    Case BorderStyle of
      bsSingle,
      bsSizeable : SetWindowLong(Handle,gwl_Style,Save or ws_Caption or
        ws_border);
      bsDialog : SetWindowLong(Handle,gwl_Style,Save or ws_Caption or
        ds_modalframe or ws_dlgframe);
    End;
    Height:=Height+getSystemMetrics(sm_cyCaption);
    Refresh;
  End;
end;

//---------------------------------------------------------------------------
// PERMITE MOSTRAR U OCULTAR LA BARRA DE TÍTULOS
//---------------------------------------------------------------------------

procedure TFPrincipal.BarraEstadoDblClick(Sender: TObject);
begin
     if tag = 0 then begin HideTitleBar;  tag := 1;  end
     else            begin ShowTitleBar;  tag := 0;  end;
end;

//---------------------------------------------------------------------------
// HACE QUE SE PUEDA MOVER LA VENTANA CLIQUEANDO EN CUALQUIER PARTE
//---------------------------------------------------------------------------

procedure TFPrincipal.WMNCHitTest(var M: TWMNCHitTest);
begin
  inherited;                    { call the inherited message handler }
  if  M.Result = htClient then  { is the click in the client area?   }
    M.Result := htCaption;      { if so, make Windows think it's     }
                                { on the caption bar.                }
end;

//---------------------------------------------------------------------------
// AL EJECUTAR UNA SEGUNDA INSTANCIA, LLAMA A ESTA FUNCION
//---------------------------------------------------------------------------

procedure TFPrincipal.WMUser(var msg: TMessage);
begin
     Application.Restore;
end;

//---------------------------------------------------------------------------
// PERMITE QUE EL PROGRAMA SE EJECUTE AUTOMATICAMENTE SI SE REINICIA WINDOWS
//---------------------------------------------------------------------------

procedure TFPrincipal.WMEndSession(var Msg: TWMEndSession);
var
  Reg: TRegistry;
begin
  Reg := TRegistry.Create;
  try
    Reg.RootKey := HKEY_CURRENT_USER;
    if Reg.OpenKey('\Software\Microsoft\Windows\CurrentVersion\RunOnce', True)
    then Reg.WriteString('SAC','"' + ParamStr(0) + '"');
  finally
    Reg.CloseKey;
    Reg.Free;
    inherited;
  end;
end;

//---------------------------------------------------------------------------
// SI ESTA CONFIGURADO, CONSULTA TODOS LOS NODOS AL INICIAR EL PROGRAMA
//---------------------------------------------------------------------------

procedure TFPrincipal.ConsultaNodos;
var
   Reg : TRegistry;
   c : Integer;

begin
    // Abre acceso al registro
    Reg := TRegistry.Create;
    Reg.OpenKey(StrREG, True);

    if Reg.ValueExists('AutoConsulta') then c := Reg.ReadInteger('AutoConsulta')
    else                                    c := 0;
    Reg.WriteInteger('AutoConsulta', c);

    if (c=1) then
    begin
       //ANodos.SetFocus;
       ANodos.Selected := ANodos.Items[0];
       cmdConsultar.Click;
    end;

    // Cierra acceso al registro
    Reg.CloseKey;
    Reg.Destroy;
end;

//---------------------------------------------------------------------------
// CREA EVENTOS DE PRUEBA PARA PANTALLA DE DEMOSTRACIÓN
//---------------------------------------------------------------------------

procedure TFPrincipal.GroupBox2DblClick(Sender: TObject);
var
   e: TEvento;
   i: Integer;
begin
   e.tipo := 'A';
   e.numnodo := 1;
   e.nodo := 'Acceso Principal';
   e.nombre := 'Carlos Rodriguez';
   e.tarjeta := '12345678';
   e.fecha := '23/05/2000';
   e.hora := '09:30';
   e.es := 'E';
   e.foto := '001.bmp';
   e.mensaje := e.nombre;
   e.codigo := '    ';
   p.Evento_a_Lista(e);
   p.Evento_a_Imagen(e);

   e.tipo := 'A';
   e.numnodo := 1;
   e.nodo := 'Acceso Principal';
   e.nombre := 'Ricardo Lomas';
   e.tarjeta := '01440011';
   e.fecha := '23/05/2000';
   e.hora := '09:35';
   e.es := 'S';
   e.foto := '004.bmp';
   e.mensaje := e.nombre;
   e.codigo := '    ';
   p.Evento_a_Lista(e);
   p.Evento_a_Imagen(e);

   e.tipo := 'I';
   e.numnodo := 1;
   e.nodo := 'Acceso Principal';
   e.nombre := '';
   e.tarjeta := '12000000';
   e.fecha := '23/05/2000';
   e.hora := '09:40';
   e.es := 'E';
   e.foto := '';
   e.mensaje := e.nombre;
   e.codigo := '    ';
   p.Evento_a_Lista(e);
   p.Evento_a_Imagen(e);

   e.tipo := 'F';
   e.numnodo := 2;
   e.nodo := 'Acceso a Primer Piso';
   e.nombre := 'Jorge Finch';
   e.tarjeta := '00000034';
   e.fecha := '23/05/2000';
   e.hora := '09:45';
   e.es := 'E';
   e.foto := '';
   e.mensaje := 'Fuera de Horario: ' + e.nombre;
   e.codigo := '    ';
   p.Evento_a_Lista(e);
   p.Evento_a_Imagen(e);

   e.tipo := 'C';
   e.numnodo := 1;
   e.nodo := 'Acceso Principal';
   e.nombre := 'Guillermo Ingis';
   e.tarjeta := '00000054';
   e.fecha := '23/05/2000';
   e.hora := '09:53';
   e.es := 'E';
   e.foto := '';
   e.mensaje := 'Tarjeta Caduca: ' + e.nombre;
   e.codigo := '    ';
   p.Evento_a_Lista(e);
   p.Evento_a_Imagen(e);

   e.tipo := 'P';
   e.numnodo := 3;
   e.nodo := 'Acceso a Segundo Piso';
   e.nombre := '';
   e.tarjeta := '';
   e.fecha := '23/05/2000';
   e.hora := '09:59';
   e.es := ' ';
   e.foto := '';
   e.mensaje := 'Alarma por Puerta Abierta';
   e.codigo := '    ';
   p.Evento_a_Lista(e);
   p.Evento_a_Imagen(e);

   e.tipo := 'A';
   e.numnodo := 2;
   e.nodo := 'Acceso a Primer Piso';
   e.nombre := 'Natalia Grey';
   e.tarjeta := '00001456';
   e.fecha := '23/05/2000';
   e.hora := '10:05';
   e.es := 'E';
   e.foto := '003.bmp';
   e.mensaje := e.nombre;
   e.codigo := '    ';
   p.Evento_a_Lista(e);
   p.Evento_a_Imagen(e);


   for i:=0 to LNodos.Items.Count-1 do
   begin
      LNodos.Items[i].ImageIndex := 0;
   end;
end;

//---------------------------------------------------------------------------
// ACTUALIZA EL ESTADO DEL NODO PASADO COMO PARAMETRO
//---------------------------------------------------------------------------

procedure TFPrincipal.ActualizaEstadoNodos(nodo: Integer);
var
   j: Integer;
   str: String;
begin
    // Busca nodo en la lista de iconos y configura texto e imagen
    for j:=0 to FPrincipal.LNodos.Items.Count-1 do
    begin
      if LNodos.Items[j].SubItems[0] = InttoStr(nodo) then
      begin
        LNodos.Items[j].ImageIndex := Nod_Status[nodo];

        case Nod_Status[nodo] of
          0:  str := 'Nodo Online';
          1:  str := 'Nodo Offline';
          2:  str := 'No Consultado';
          3:  str := 'Acceso Normal';
          4:  str := 'Apertura Remota';
          5:  str := 'Comunicación exitosa';
          6:  str := 'Acceso no Autorizado';
          7:  str := 'Tarjeta Caduca';
          8:  str := 'Alarma de Puerta Abierta';
          9:  str := 'Aviso de Puerta Abierta';
          10: str := 'Tarjeta fuera de horario';
          11: str := 'Acceso por Pulsador';
          12: str := 'Nodo Bloqueado';
        end;
        LNodos.Items[j].SubItems[2] := str;

        break;
      end;
    end;
end;

//---------------------------------------------------------------------------
// CON ALT + CTRL CAMBIA LA FUNCION DEl BOTON SUBIR HABILITADOS
//---------------------------------------------------------------------------

procedure TFPrincipal.FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
begin
  if (Shift = [ssCtrl, ssAlt]) then
  begin
     cmdSubir.Caption := 'Comp. Habilitados';
     cmdSubir.Tag := 1;
     cmdSubir.ImageIndex := 8;
  end;

  if (Key = VK_F12) then
  begin
    Panel2.Visible := not Panel2.Visible;
  end;

  if (Shift = [ssCtrl, ssAlt, ssShift]) and (Key = Ord('I')) then
  begin
    Self.Caption := Caption_Principal + Format(' [Quedan %d minutos...]', [Timeout_ModoMuestra]);
  end;
end;

//---------------------------------------------------------------------------
// BOTON HABILITADOS VUELVE A SU FUNCION NORMAL
//---------------------------------------------------------------------------

procedure TFPrincipal.FormKeyUp(Sender: TObject; var Key: Word; Shift: TShiftState);
begin
  cmdSubir.Caption := 'Subir Habilitados';
  cmdSubir.Tag := 0;
  cmdSubir.ImageIndex := 1;

  Self.Caption := Caption_Principal;
end;

//---------------------------------------------------------------------------
//
//---------------------------------------------------------------------------

procedure TFPrincipal.ClockbarMouseMove(Sender: TObject; Shift: TShiftState; X, Y: Integer);
begin
  if X < 20 then
  begin
     if p.DescAuto.hab then
     begin
        Clockbar.Hint := 'Descarga automática activada' + #13 +
                         Format('Próxima descarga = %s', [DateTimetoStr(p.DescAuto.HoraProxDescarga)]);
     end
     else Clockbar.Hint := 'Descarga automática desactivada';
  end
  else
     Clockbar.Hint := FormatDateTime('dddd, dd "de" mmmm "de" yyyy', Now);
end;

//---------------------------------------------------------------------------
//
//---------------------------------------------------------------------------

procedure TFPrincipal.cmdTCPIPClick(Sender: TObject);
begin
  // En modo descargador, no permite tcp/ip
  {
  if not llave.modofull then
  begin
    Application.MessageBox('En el modo descargador no está habilitado el módulo de administración de conexiones TCP/IP', 'Advertencia', MB_OK + MB_ICONINFORMATION);
    Exit;
  end;
  }

  // Muestra ventana modo demo
  vdemo;

  // Muestra ventana de seguridad
  FAdminTCPIP.Show;
end;

//---------------------------------------------------------------------------
//
//---------------------------------------------------------------------------

procedure TFPrincipal.tmrMuestraTimer(Sender: TObject);
begin
  Timeout_ModoMuestra := Timeout_ModoMuestra - 1;

  // Si está en la última cuenta regresiva, muestra contador
  if tmrMuestra.Tag = 1 then
  begin
    Self.Caption := Caption_Principal + Format(' [Quedan %d segundos...]', [Timeout_ModoMuestra]);
  end;

  if Timeout_ModoMuestra <= 0 then
  begin
    if tmrMuestra.Tag = 0 then
    begin
      tmrMuestra.Enabled := False;
      Application.MessageBox('Ha llegado el límite de uso de SAC en modo muestra. Tiene 1 minuto para cerrar todas las ventanas abiertas', 'Mensaje', MB_OK + MB_ICONWARNING);
      Timeout_ModoMuestra := 60;   // 60 segundos
      tmrMuestra.Interval := 1000; // 1000 = 1 segundo
      tmrMuestra.Tag := 1;
      tmrMuestra.Enabled := True;
    end
    else if tmrMuestra.Tag = 1 then
    begin
      tmrMuestra.Enabled := False;
      Application.MessageBox('Pasó el tiempo para cerrar las ventanas... Se cerrará la aplicación', 'Mensaje', MB_OK + MB_ICONWARNING);
      Application.Terminate;
    end;
  end;
end;

procedure TFPrincipal.LimitacionesDescargador1Click(Sender: TObject);
begin
  Application.CreateForm(TFLimitacionesDescargador, FLimitacionesDescargador);
  try
    FLimitacionesDescargador.ShowModal;
  finally
    FLimitacionesDescargador.Release;
  end;
end;

end.

