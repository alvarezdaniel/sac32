//---------------------------------------------------------------------------
//
//  Módulo de Configuración del Sistema
//
//
//  Actualización con seguridad 06-12-2000
//  Mejora de la interfase modo flat 08-12-2000
//  Configuración de Empresa 11-01-2001
//  Configuración de Sonidos 25-01-2001
//  Cambio de unit a ConfigPC 01-02-2001
//  Agregado de habilitación de sonidos 06-02-2001
//  Fin del Módulo 06-02-2001
//  Implementación de módulos en MODEM 19-02-2001
//  Agregado de ayuda con F1 03-03-2001
//  Agregado de filtrado por nuevos eventos 19-05-2001
//
//
//  A hacer:
//           Sonidos configurables
//           Agregar COM a opciones de modem, y varias opciones más.
//
//---------------------------------------------------------------------------

unit ConfigPC;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  ComCtrls, StdCtrls, Buttons, ExtCtrls, Registry, ShlObj, ActiveX;

type
  TFConfiguracion = class(TForm)
    Opciones: TTreeView;
    GroupBoxComm: TGroupBox;
    GroupBoxDescarga: TGroupBox;
    GroupBoxUbicacion: TGroupBox;
    GroupBoxModem: TGroupBox;
    GroupBox2: TGroupBox;
    rb1: TRadioButton;
    rb2: TRadioButton;
    rb3: TRadioButton;
    rb4: TRadioButton;
    GroupBox3: TGroupBox;
    Label10: TLabel;
    EditReintentos: TEdit;
    rt: TUpDown;
    Label11: TLabel;
    Edittimeout: TEdit;
    tm: TUpDown;
    l1: TLabel;
    l2: TLabel;
    l3: TLabel;
    l4: TLabel;
    ebd: TEdit;
    Label1: TLabel;
    Label2: TLabel;
    efot: TEdit;
    GroupBoxEntorno: TGroupBox;
    Label3: TLabel;
    elin: TEdit;
    udlin: TUpDown;
    CheckCons: TCheckBox;
    grpFiltros: TGroupBox;
    CheckBox1: TCheckBox;
    CheckBox2: TCheckBox;
    CheckBox3: TCheckBox;
    CheckBox4: TCheckBox;
    CheckBox5: TCheckBox;
    CheckBox6: TCheckBox;
    CheckBorra: TCheckBox;
    CheckMuestra: TCheckBox;
    GroupBox4: TGroupBox;
    CheckDA: TCheckBox;
    btnCerrar: TSpeedButton;
    btnPordefbd: TSpeedButton;
    Pordeffot: TSpeedButton;
    btnselbd: TSpeedButton;
    btnselfot: TSpeedButton;
    CheckModem: TCheckBox;
    OpcionesModem: TGroupBox;
    Labelnum: TLabel;
    btnOKnum: TSpeedButton;
    btnKOnum: TSpeedButton;
    Editnum: TEdit;
    GroupBoxSonidos: TGroupBox;
    lin: TLabel;
    horai: TDateTimePicker;
    Editmin: TEdit;
    udmin: TUpDown;
    lint: TLabel;
    rbtodos: TRadioButton;
    rbuno: TRadioButton;
    CheckDtxt: TCheckBox;
    CheckSonidos: TCheckBox;
    CheckBox7: TCheckBox;
    CheckBox8: TCheckBox;
    CheckBox9: TCheckBox;
    CheckModoSubida: TCheckBox;
    btnAceptarCambio: TSpeedButton;
    procedure FormShow(Sender: TObject);
    procedure OpcionesChange(Sender: TObject; Node: TTreeNode);
    procedure rbClick(Sender: TObject);
    procedure rtClick(Sender: TObject; Button: TUDBtnType);
    procedure tmClick(Sender: TObject; Button: TUDBtnType);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure CheckDAClick(Sender: TObject);
    procedure pordefbdClick(Sender: TObject);
    procedure selbdClick(Sender: TObject);
    procedure pordeffotClick(Sender: TObject);
    procedure selfotClick(Sender: TObject);
    procedure udlinClick(Sender: TObject; Button: TUDBtnType);
    procedure CheckConsClick(Sender: TObject);
    procedure CheckBox1Click(Sender: TObject);
    procedure CheckBox2Click(Sender: TObject);
    procedure CheckBox3Click(Sender: TObject);
    procedure CheckBox4Click(Sender: TObject);
    procedure CheckBox5Click(Sender: TObject);
    procedure CheckBox6Click(Sender: TObject);
    procedure CheckBorraClick(Sender: TObject);
    procedure CheckMuestraClick(Sender: TObject);
    procedure btnCerrarClick(Sender: TObject);
    procedure CheckModemClick(Sender: TObject);
    procedure btnOKnumClick(Sender: TObject);
    procedure btnKOnumClick(Sender: TObject);
    procedure horaiChange(Sender: TObject);
    procedure EditminChange(Sender: TObject);
    procedure rbtodosClick(Sender: TObject);
    procedure CheckDtxtClick(Sender: TObject);
    procedure CheckSonidosClick(Sender: TObject);
    procedure CheckBox7Click(Sender: TObject);
    procedure CheckBox8Click(Sender: TObject);
    procedure CheckBox9Click(Sender: TObject);
    procedure CheckModoSubidaClick(Sender: TObject);
    procedure btnAceptarCambioClick(Sender: TObject);
  private
    { Private declarations }
    DescAut_a_entrar: Boolean;
  public
    { Public declarations }
  end;

var
  FConfiguracion: TFConfiguracion;

implementation

uses Comunicaciones, Principal, ABM, Datos, Rutinas, Serkey;

{$R *.DFM}

//---------------------------------------------------------------------------
// AL ENTRAR LEE TODA LA CONFIGURACION DESDE EL REGISTRO DE WINDOWS
//---------------------------------------------------------------------------

procedure TFConfiguracion.FormShow(Sender: TObject);
var
  i : Integer;
  col : TColor;
  cap : String;
begin
  // Lee como entró en descarga automática
  DescAut_a_entrar := ReadReg_I('DescAut') = 1;

  // Obtiene información de puertos instalados en la PC
  GetAvailPorts;

  // // Distingue entre puertos disponibles y no disponibles
  for i:=1 to 4 do
  begin
     // Deshabilita y deschequea todos los radio buttons
     //TRadioButton(FindComponent('rb'+InttoStr(i))).Enabled := False;
     TRadioButton(FindComponent('rb'+InttoStr(i))).Checked := False;

     if existeCOM[i] then begin col := clBlack; cap := 'disponible'; end
     else                 begin col := clRed;   cap := 'no disponible'; end;

     if existeCOM[i] then
        TRadioButton(FindComponent('rb'+InttoStr(i))).Enabled := True
     else
        TRadioButton(FindComponent('rb'+InttoStr(i))).Enabled := False;

     TLabel(FindComponent('l'+InttoStr(i))).Font.Color := col;
     TLabel(FindComponent('l'+InttoStr(i))).Caption := cap;
  end;

  // Configura el puerto configurado para la comunicación RS-485 si = 0
  i := ReadReg_I('Puerto');
  if (i <> 0)  then
  begin
     TRadioButton(FindComponent('rb'+InttoStr(i))).Checked := True;
     //TRadioButton(FindComponent('rb'+InttoStr(i))).Enabled := True;
     //TLabel(FindComponent('l'+InttoStr(i))).Caption := 'llave conectada';
     //TLabel(FindComponent('l'+InttoStr(i))).Font.Color := clBlue;
  end;

  // Lee reintentos y timeout
  rt.Position := ReadReg_I('Reintentos');
  tm.Position := ReadReg_I('Timeout');

  // Lee Opciones descarga automática
  CheckDA.Checked := (ReadReg_I('DescAut') = 1);
  try    horai.Time := StrtoTime(ReadReg_S('DA_inicio'));
  except horai.Time := StrtoTime('00:00:00');
         WriteReg_S('DA_inicio', TimetoStr(horai.Time));
  end;
  udmin.Position := ReadReg_I('DA_interv');
  rbtodos.Checked := (ReadReg_I('DA_todos') = 0);
  rbuno.Checked := not rbtodos.Checked;
  horai.Enabled := CheckDA.Checked;
  Editmin.Enabled := CheckDA.Checked;
  udmin.Enabled := CheckDA.Checked;
  rbtodos.Enabled := CheckDA.Checked;
  rbuno.Enabled := CheckDA.Checked;

  // Lee descarga en texto
  CheckDtxt.Checked := (ReadReg_I('DescTXT') = 1);

  // Lee borrado de eventos al descargar
  CheckBorra.Checked := (ReadReg_I('BorraEv') = 1);

  // Lee mostrar eventos
  CheckMuestra.Checked := (ReadReg_I('MuestraEv') = 1);

  // Lee Ubicacion BD
  ebd.Text := ReadReg_S('UBD'); ebd.Hint := ebd.Text;

  // Lee Ubicación fotos
  efot.Text := ReadReg_S('UFot'); efot.hint := efot.Text;

  // Lee cantidad de líneas
  udlin.Position := ReadReg_I('Lineas');

  // Lee estado de autoconsulta
  CheckCons.Checked := (ReadReg_I('AutoConsulta') = 1);

  // Lee filtros de eventos
  CheckBox1.Checked := (ReadReg_I('Filtro.Accesos') = 1);
  CheckBox2.Checked := (ReadReg_I('Filtro.Intrusos') = 1);
  CheckBox3.Checked := (ReadReg_I('Filtro.Alarmas') = 1);
  CheckBox4.Checked := (ReadReg_I('Filtro.ApRemotas') = 1);
  CheckBox5.Checked := (ReadReg_I('Filtro.Transferencias') = 1);
  CheckBox6.Checked := (ReadReg_I('Filtro.NodosOffline') = 1);
  CheckBox7.Checked := (ReadReg_I('Filtro.FueraHorario') = 1);
  CheckBox8.Checked := (ReadReg_I('Filtro.Caducidades') = 1);
  CheckBox9.Checked := (ReadReg_I('Filtro.Pulsador') = 1);

  // Lee modo de habilitación
  CheckModoSubida.Checked := (ReadReg_I('ModoSubida') = 1);

  // Lee Opciones de modem
  CheckModem.Enabled := (llave.Modulos and $0002) <> 0;

  if CheckModem.Enabled then CheckModem.Checked := (ReadReg_I('CommModem') = 1)
  else CheckModem.Checked := False;
  Labelnum.Enabled := CheckModem.Checked;
  Editnum.Enabled := CheckModem.Checked;
  btnOKnum.Enabled := CheckModem.Checked;
  btnKOnum.Enabled := CheckModem.Checked;
  Editnum.Text := ReadReg_S('TelefonoRemoto');

  // Lee estado de habilitación de sonidos
  CheckSonidos.Checked := (ReadReg_I('Sonidos') = 1); 

end;

//---------------------------------------------------------------------------
// SALE DE LA VENTANA DE CONFIGURACION
//---------------------------------------------------------------------------

procedure TFConfiguracion.FormClose(Sender: TObject; var Action: TCloseAction);
begin

end;

//---------------------------------------------------------------------------
// AL SELECCIONAR OPCION DEL ARBOL, MUESTRA VENTANA CORRESPONDIENTE
//---------------------------------------------------------------------------

procedure TFConfiguracion.OpcionesChange(Sender: TObject; Node: TTreeNode);
begin
  with Opciones do
  begin
    // Oculta todos los grupos
    GroupBoxComm.Hide;
    GroupBoxDescarga.Hide;
    GroupBoxUbicacion.Hide;
    GroupBoxModem.Hide;
    GroupBoxEntorno.Hide;
    GroupBoxSonidos.Hide;

    if Selected = Items[0] then
    begin
       if Habilitada(2, 2, False) then
       begin
            GroupBoxComm.Show;
            GroupBoxComm.BringtoFront;
       end;
    end

    else if Selected = Items[1] then
    begin
       if Habilitada(2, 3, False) then
       begin
            GroupBoxDescarga.Show;
            GroupBoxDescarga.BringtoFront;
       end;
    end

    else if Selected = Items[2] then
    begin
       if Habilitada(2, 4, False) then
       begin
            GroupBoxUbicacion.Show;
            GroupBoxUbicacion.BringtoFront;
       end;
    end

    else if Selected = Items[3] then
    begin
       if Habilitada(2, 5, False) then
       begin
            GroupBoxModem.Show;
            GroupBoxModem.BringtoFront;
       end;
    end

    else if Selected = Items[4] then
    begin
       if Habilitada(2, 6, False) then
       begin
            GroupBoxEntorno.Show;
            GroupBoxEntorno.BringtoFront;
       end;
    end

    else if Selected = Items[5] then
    begin
       if Habilitada(2, 7, False) then
       begin
            GroupBoxSonidos.Show;
            GroupBoxSonidos.BringtoFront;
       end;
    end;
  end;
end;

//---------------------------------------------------------------------------
// AL CAMBIAR LOS REINTENTOS LOS GRABA AL REGISTRO
//---------------------------------------------------------------------------

procedure TFConfiguracion.rtClick(Sender: TObject; Button: TUDBtnType);
begin
     // Graba registro
     WriteReg_I('Reintentos', rt.Position);

     // Actualiza reintentos actuales
     p.retry := rt.Position;
end;

//---------------------------------------------------------------------------
// AL CAMBIAR EL TIMEOUT LO GRABA AL REGISTRO
//---------------------------------------------------------------------------

procedure TFConfiguracion.tmClick(Sender: TObject; Button: TUDBtnType);
begin
     // Graba registro
     WriteReg_I('Timeout', tm.Position);

     // Actualiza timeout actual
     p.rxtimeout := tm.Position / 86400000;
end;

//---------------------------------------------------------------------------
// AL CAMBIAR EL COM, GRABA EN REGISTRO Y ABRE NUEVO PUERTO
//---------------------------------------------------------------------------

procedure TFConfiguracion.rbClick(Sender: TObject);
begin
    if rb1.Checked then                 WriteReg_I('Puerto', 1)
    else if rb2.Checked then            WriteReg_I('Puerto', 2)
    else if rb3.Checked then            WriteReg_I('Puerto', 3)
    else if rb4.Checked then            WriteReg_I('Puerto', 4);

    p.InitPort;
end;

//---------------------------------------------------------------------------
// GRABA CONFIGURACION DE DESCARGA AUTOMATICA
//---------------------------------------------------------------------------

procedure TFConfiguracion.CheckDAClick(Sender: TObject);
begin
   // En modo descargador no se pueden habilitar la descarga automática
    if (not llave.modofull) and (CheckDA.Checked) then
    begin
      Application.MessageBox('En modo descargador no se puede habilitar la descarga automática', 'Advertencia', MB_OK + MB_ICONINFORMATION);
      WriteREG_I('DescAut', 0);
      CheckDA.Checked := False;
      Exit;
    end;

    if CheckDA.Checked then     WriteREG_I('DescAut', 1)
    else                        WriteREG_I('DescAut', 0);

    horai.Enabled := CheckDA.Checked;
    Editmin.Enabled := CheckDA.Checked;
    udmin.Enabled := CheckDA.Checked;
    rbtodos.Enabled := CheckDA.Checked;
    rbuno.Enabled := CheckDA.Checked;
end;

//---------------------------------------------------------------------------
// GRABA CAMBIO DE HORARIO INICIAL DE DESCARGA
//---------------------------------------------------------------------------

procedure TFConfiguracion.horaiChange(Sender: TObject);
begin
     // Graba registro
     WriteReg_S('DA_inicio', TimetoStr(horai.Time));
end;

//---------------------------------------------------------------------------
// GRABA INTERVALO DE DESCARGA
//---------------------------------------------------------------------------

procedure TFConfiguracion.EditminChange(Sender: TObject);
begin
     // Graba registro
     WriteReg_I('DA_interv', udmin.Position);
end;

//---------------------------------------------------------------------------
// GRABA TODOS LOS NODOS O UNO POR VEZ
//---------------------------------------------------------------------------

procedure TFConfiguracion.rbtodosClick(Sender: TObject);
begin
     if rbtodos.Checked then WriteReg_I('DA_todos', 0)
     else                    WriteReg_I('DA_todos', 1);
end;

//---------------------------------------------------------------------------
// GRABA SI DESCARGA EN ARCHIVO DE TEXTO O NO
//---------------------------------------------------------------------------

procedure TFConfiguracion.CheckDtxtClick(Sender: TObject);
begin
    if CheckDtxt.Checked then      WriteREG_I('DescTXT', 1)
    else                           WriteREG_I('DescTXT', 0);
end;

//---------------------------------------------------------------------------
// GRABA CONFIGURACION DE BORRA EVENTOS AL DESCARGAR
//---------------------------------------------------------------------------

procedure TFConfiguracion.CheckBorraClick(Sender: TObject);
begin
    if CheckBorra.Checked then     WriteREG_I('BorraEv', 1)
    else                           WriteREG_I('BorraEv', 0);
end;

//---------------------------------------------------------------------------
// GRABA CONFIGURACION DE MUESTRA EVENTOS MIENTRAS DESCARGA
//---------------------------------------------------------------------------

procedure TFConfiguracion.CheckMuestraClick(Sender: TObject);
begin
    if CheckMuestra.Checked then     WriteREG_I('MuestraEv', 1)
    else                             WriteREG_I('MuestraEv', 0);
end;

//---------------------------------------------------------------------------
// PREGUNTA NUEVA CARPETA DE DATOS
//---------------------------------------------------------------------------

function Nueva_Ubic(var folder : String) : Boolean;
var
   Inf : TBrowseInfo;                 // uses ShlObj, ActiveX
   Identificador : PItemIDList;
   Gestor : IMalloc;
   Carpeta : Array[0..100] Of Char;
begin
     // Llena estructura TBrowseInfo
     with Inf do
     begin
          hwndOwner := Application.Handle;       // Handle del owner
          pidlRoot := Nil;                       //
          pszDisplayName := Carpeta;             // Variable de retorno
          lpszTitle := 'Seleccione una carpeta'; // Título de ventana
          ulFlags := BIF_RETURNONLYFSDIRS;
          lpfn := Nil;
     end;

     // Retorna identificador
     Identificador := SHBrowseForFolder(Inf);

     If Identificador <> Nil then
     begin
          SHGetPathFromIDList(Identificador, Carpeta);
          SHGetMalloc(Gestor);
          Gestor.Free(Identificador);

          folder := Carpeta;
          Result := True;
     end
     else
         Result := False;
end;

//---------------------------------------------------------------------------
// CONFIGURA UBICACION DE BASE DE DATOS
//---------------------------------------------------------------------------

procedure TFConfiguracion.selbdClick(Sender: TObject);
var
   new_carpeta, temp : String;
begin
    // Elige nueva carpeta de Base de Datos
    if Nueva_Ubic(new_carpeta) then
    begin
      // Guarda ubicación anterior como backup si es imposible cambiar
      temp := ReadReg_S('UBD');

      // Graba la nueva carpeta de datos
      WriteReg_S('UBD', new_carpeta);

      // Si puede inicializar la base de datos, cambia a nueva ubicación
      if data.DBConnect then
      begin
          CargaNodos;                      // Carga nueva lista de nodos
          ebd.Text := ReadReg_S('UBD');
          ebd.hint := ebd.Text;
      end
      else // Si no, se queda con la anterior y muestra mensaje de error
      begin
         Application.MessageBox('Ubicación de base de datos inválida', 'Advertencia', MB_OK + MB_ICONHAND);

         WriteReg_S('UBD', temp);
         data.DBConnect;
         CargaNodos;
      end;
    end;
end;

//---------------------------------------------------------------------------
// GRABA UBICACIÓN DE BD POR DEFECTO
//---------------------------------------------------------------------------

procedure TFConfiguracion.pordefbdClick(Sender: TObject);
var
   temp : String;
begin
    // Guarda ubicación anterior como backup
    temp := ReadReg_S('UBD');

    // Ubicación por defecto = <InstallProgram>\Bases
    WriteReg_S('UBD', carpeta + 'Bases');

    // Intenta conectar a base en ubicación default
    if data.DBConnect then
    begin
        CargaNodos;
        ebd.Text := ReadReg_S('UBD');
        ebd.hint := ebd.Text;
    end

    // Si no, se queda con la anterior y muestra mensaje de error
    else
    begin
        Application.MessageBox('Error inicializando base de datos en ubicación por defecto', 'Advertencia', MB_OK + MB_ICONHAND);
        WriteReg_S('UBD', temp);
        CargaNodos;
    end;
end;

//---------------------------------------------------------------------------
// CAMBIA UBICACIÓN DE FOTOS
//---------------------------------------------------------------------------

procedure TFConfiguracion.selfotClick(Sender: TObject);
var
   s : String;
begin
    if Nueva_Ubic(s) then
    begin
        WriteReg_S('Ufot', s);
        efot.Text := s;
        efot.hint := s;
    end;
end;

//---------------------------------------------------------------------------
// GRABA UBICACIÓN DE FOTOS POR DEFECTO
//---------------------------------------------------------------------------

procedure TFConfiguracion.pordeffotClick(Sender: TObject);
begin
    efot.Text := carpeta + 'Fotos';
    efot.hint := efot.Text;
    WriteReg_S('UFot', efot.Text);
end;

//---------------------------------------------------------------------------
// GRABA CONFIGURACION DE OPCIONES DE MODEM
//---------------------------------------------------------------------------

procedure TFConfiguracion.CheckModemClick(Sender: TObject);
begin
   if CheckModem.Checked then WriteReg_I('CommModem', 1)
   else                       WriteReg_I('CommModem', 0);

   Labelnum.Enabled := CheckModem.Checked;
   Editnum.Enabled := CheckModem.Checked;
   btnOKnum.Enabled := CheckModem.Checked;
   btnKOnum.Enabled := CheckModem.Checked;
end;

procedure TFConfiguracion.btnOKnumClick(Sender: TObject);
begin
     WriteReg_S('TelefonoRemoto', Editnum.Text);
end;

procedure TFConfiguracion.btnKOnumClick(Sender: TObject);
begin
     Editnum.Text := ReadReg_S('TelefonoRemoto');
end;

//---------------------------------------------------------------------------
// AL CAMBIAR LA CANTIDAD DE LÍNEAS LA GRABA AL REGISTRO
//---------------------------------------------------------------------------

procedure TFConfiguracion.udlinClick(Sender: TObject; Button: TUDBtnType);
begin
     WriteReg_I('Lineas', udlin.Position);
end;

//---------------------------------------------------------------------------
// GRABA CONFIGURACION DE FILTROS DE EVENTOS
//---------------------------------------------------------------------------

procedure TFConfiguracion.CheckBox1Click(Sender: TObject);
begin
     WriteReg_I('Filtro.Accesos', Integer(CheckBox1.Checked));
end;

procedure TFConfiguracion.CheckBox2Click(Sender: TObject);
begin
     WriteReg_I('Filtro.Intrusos', Integer(CheckBox2.Checked));
end;

procedure TFConfiguracion.CheckBox3Click(Sender: TObject);
begin
     WriteReg_I('Filtro.Alarmas', Integer(CheckBox3.Checked));
end;

procedure TFConfiguracion.CheckBox4Click(Sender: TObject);
begin
     WriteReg_I('Filtro.ApRemotas', Integer(CheckBox4.Checked));
end;

procedure TFConfiguracion.CheckBox5Click(Sender: TObject);
begin
     WriteReg_I('Filtro.Transferencias', Integer(CheckBox5.Checked));
end;

procedure TFConfiguracion.CheckBox6Click(Sender: TObject);
begin
     WriteReg_I('Filtro.NodosOffline', Integer(CheckBox6.Checked));
end;

procedure TFConfiguracion.CheckBox7Click(Sender: TObject);
begin
     WriteReg_I('Filtro.FueraHorario', Integer(CheckBox7.Checked));
end;

procedure TFConfiguracion.CheckBox8Click(Sender: TObject);
begin
     WriteReg_I('Filtro.Caducidades', Integer(CheckBox8.Checked));
end;

procedure TFConfiguracion.CheckBox9Click(Sender: TObject);
begin
     WriteReg_I('Filtro.Pulsador', Integer(CheckBox9.Checked));
end;

//---------------------------------------------------------------------------
// GRABA CONFIGURACION DE MODO DE HABILITACION
//---------------------------------------------------------------------------

procedure TFConfiguracion.CheckModoSubidaClick(Sender: TObject);
begin
    WriteREG_I('ModoSubida', Integer(CheckModoSubida.Checked));
end;

//---------------------------------------------------------------------------
// GRABA CONFIGURACION DE CONSULTA AL INICIO
//---------------------------------------------------------------------------

procedure TFConfiguracion.CheckConsClick(Sender: TObject);
begin
    WriteREG_I('AutoConsulta', Integer(CheckCons.Checked));
end;

//---------------------------------------------------------------------------
// GRABA CONFIGURACION DE HABILITACIÓN DE SONIDOS
//---------------------------------------------------------------------------

procedure TFConfiguracion.CheckSonidosClick(Sender: TObject);
begin
    WriteREG_I('Sonidos', Integer(CheckSonidos.Checked));
end;

//---------------------------------------------------------------------------
// SALE DE LA CONFIGURACIÓN
//---------------------------------------------------------------------------

procedure TFConfiguracion.btnCerrarClick(Sender: TObject);
begin
    // Actualiza parámetros de descarga automática
    p.DescAuto.HoraInicio := StrtoDateTime(ReadReg_S('DA_inicio'));
    p.DescAuto.Intervalo := ReadReg_I('DA_interv');
    p.DescAuto.Todos := ReadReg_I('DA_Todos') = 0;
    p.DescAuto.EnProceso := False;
    p.DescAuto.UltimoNodoDescargado := -1;

    // Si entró sin descarga automática y salió con descarga pregunta si desea iniciarla
    if (not DescAut_a_entrar) and (ReadReg_I('DescAut') = 1) then
    begin
      if Application.MessageBox('La descarga automática está habilitada'#13'Desea iniciar el proceso de descarga en este momento?'#13'En caso de indicar que no se esperará el horario configurado',
                                'Atención', MB_YESNO + MB_ICONQUESTION) = IDYES then
      begin
        p.DescAuto.HoraProxDescarga := Now + (p.DescAuto.Intervalo / 1440);
      end
      else
      begin
        // Si el horario de inicio es anterior a la hora actual, empieza el día siguiente
        if p.DescAuto.HoraInicio < Time then
           p.DescAuto.HoraProxDescarga := Date + p.DescAuto.HoraInicio + 1
        else
           p.DescAuto.HoraProxDescarga := Date + p.DescAuto.HoraInicio;
      end;
    end;

    // Finalmente actualiza flag de habilitación de descarga automática
    p.DescAuto.hab := ReadReg_I('DescAut') = 1;

    FPrincipal.Timer1Timer(Self);
    ModalResult := mrCancel;
end;

procedure TFConfiguracion.btnAceptarCambioClick(Sender: TObject);
var
   new_carpeta, temp : String;
begin
   new_carpeta := ebd.Text;

   // Guarda ubicación anterior como backup si es imposible cambiar
   temp := ReadReg_S('UBD');

   // Graba la nueva carpeta de datos
   WriteReg_S('UBD', new_carpeta);

   // Si puede inicializar la base de datos, cambia a nueva ubicación
   if data.DBConnect then
   begin
       CargaNodos;                      // Carga nueva lista de nodos
       ebd.Text := ReadReg_S('UBD');
       ebd.hint := ebd.Text;
   end
   else // Si no, se queda con la anterior y muestra mensaje de error
   begin
      Application.MessageBox('Ubicación de base de datos inválida', 'Advertencia', MB_OK + MB_ICONHAND);

      WriteReg_S('UBD', temp);
      data.DBConnect;
      CargaNodos;
   end;
end;

end.
