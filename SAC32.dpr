//---------------------------------------------------------------------------
//
//  Software Administrador de Controles de Acceso (SAC32) v1.0
//
//  ® Daniel Alvarez 2000, 2001, 2002 SAC Sistemas
//
//  Componentes adicionales
//                          * AsyncPro v2.56 (Comunicación Serie)
//                          * ReportBuilder v4.24 Professional (Reportes)
//                          * RX Lib v2.75 (componente Animate)
//                          * ExportX-DB v3.05 (exportación de reportes)
//                          * kbmMemTable v2.53g (Tablas de Memoria)
//                          * AVLock Pro v2.4 (Protección por software)
//
//  Utilitarios adicionales
//                          * Windows Commander v4.54 (Administrador de archivos)
//                          * Delphi 5.0 Enterprise (compilador)
//                          * GExperts 1.01 (Expertos de Delphi)
//                          * ASPack 2.11 (compresor de ejecutable)
//                          * Help and Manual 3.0.3 (Creador de Ayuda y Manual)
//                          * Paint Shop Pro 7.04 (Editor de Gráficos)
//                          * InstallShield Express 3.51 (Instalador)
//                          * Easy CD Creator 5 (Generación de CD)
//                          * CD Label Creator 5.0 (Creación de etiqueta CD)
//
//    Parámetros:
//                /backdoor = Funciona sin SERKEY. Pide password 'dalvarez'
//                /m = Muestra Transacciones con la llave.
//                /graba = Resetea llave a modo virgen (pide nro serie y clave 'erasure')
//                /base = Muestra información de la base de datos
//                /debug = Modo Debug (Muestra paquetes enviados y recibidos)
//         (no)   /login = No pide login (ingresa como Superusuario)
//                /log = crea archivo de log de comunicaciones
//                /muestra - entra en modo muestra
//                /descargador - entra en modo descargador aunque esté registrado
//
//---------------------------------------------------------------------------

{ Nombre del proyecto = SAC32                                                }
program SAC32;

{ Units usadas en el proyecto SAC32                                          }
uses
  SysUtils,
  Forms,
  Comunicaciones in 'Comunicaciones.pas' {FCom: TDataModule},
  Busqueda in 'Busqueda.pas' {FBusqueda},
  Principal in 'Principal.pas' {FPrincipal},
  ConfigPC in 'ConfigPC.pas' {FConfiguracion},
  ConfigNodo in 'ConfigNodo.pas' {FConfigNodo},
  Reportes in 'Reportes.pas' {FReportes},
  ABM in 'ABM.pas' {FABM},
  Datos in 'Datos.pas' {data: TDataModule},
  NumNodo in 'NumNodo.pas' {FNumNodo},
  Preview in 'Preview.pas' {FPreview},
  Progreso in 'Progreso.pas' {FProgreso},
  Seguridad in 'Seguridad.pas' {FSeg},
  Pwd in 'Pwd.pas' {FPwd},
  Login in 'Login.pas' {FLogin},
  Localizador in 'Localizador.pas' {FLocalizador},
  UEvento in 'UEvento.pas' {FUEv},
  Mantenimiento in 'Mantenimiento.pas' {FMant},
  About in 'About.pas' {FAbout},
  UModem in 'UModem.pas' {FModem},
  DepuraFecha in 'DepuraFecha.pas' {FDepurar},
  FiltroEventos in 'FiltroEventos.pas' {FFiltroEv},
  Huerfanos in 'Huerfanos.pas' {FOrphan},
  Rutinas in 'Rutinas.pas',
  Serkey in 'Serkey.pas',
  Backup in 'Backup.pas' {FBackup},
  Test in 'Test.pas' {FTest},
  Paquetes in 'Paquetes.pas' {FPaquetes},
  Demo in 'Demo.pas' {FDemo},
  Franjas in 'Franjas.pas' {FFranjas},
  Feriados in 'Feriados.pas' {FFeriados},
  ProgresoLlave in 'ProgresoLlave.pas' {FProgresoLlave},
  HabTest in 'HabTest.pas' {FHab},
  Colores in 'Colores.pas' {Form1},
  Password in 'Password.pas',
  RegUnit1 in 'RegUnit1.pas' {RegForm1},
  ModoDescargador in 'ModoDescargador.pas' {FModoDescargador},
  Pump in 'Pump.pas' {FPump},
  AdminTCPIP in 'AdminTCPIP.pas' {FAdminTCPIP},
  ModoMuestra in 'ModoMuestra.pas' {FModoMuestra},
  LimitacionesDescargador in 'LimitacionesDescargador.pas' {FLimitacionesDescargador},
  CocherasTita in 'CocherasTita.pas' {FCocherasTita};

{$R *.RES}        // Incluye ícono de la aplicación y datos de versión
{$R FILES.RES}    // Incluye WAVS,BMPs y DLLs como resources

begin
  // Inicializa la aplicación
  Application.Initialize;
  Application.Title := '';

  // 25/04/2004 - Si detecta el switch /muestra, entra en modo demostración
  modo_muestra := FindCmdLineSwitch('muestra', ['/', '-'], True);

  Application.HelpFile := 'Sac32.hlp';
  Application.CreateForm(Tdata, data);
  Application.CreateForm(TFCom, FCom);
  Application.CreateForm(TFPrincipal, FPrincipal);
  Application.Run;
end.

