//---------------------------------------------------------------------------
//
//  Módulo de Comunicación Serie con los Nodos v3.0
//
//
// Revisión de Rutinas 27-11-2000
// Nueva Revisión 02-12-2000 (Consultas SQL e interrogación de valores)
// Agregado de seguridad 06-12-2000
// Consulta en módulo para evitar problemas de tablas abiertas 08-12-2000
// Modificación para que funcione con ABATRACK 2 10-12-2000
// Funciona a 9600 y 38400 12-12-2000
// Devuelve respuesta a eventos online 13-12-2000
// Agregado de Sonidos de Eventos 19-12-2000
// Corrección de bug descarga de eventos E/S 19-12-2000
// Agregado de protección con llave SERKEY v1.0 11-01-2001
// Corrección bug Baud Rate. 13-01-2001
// Reproduce Wavs desde Resources 13-01-2001
// En modo demo no hay comunicación 13-01-2001
// Muestra BMP's de intruso y alarma como resources 15-01-2001
// Eliminación de rutinas generales y de SERKEY 25-01-2001
// Inicio de mejora de rutinas 27-01-2001
// Objeto Comm485 27-01-2001
// Configuración automática de Puerto Serie hecho por SERKEY
// Descarga en archivo de texto 03-03-2001
// Reintentos hasta 50 veces 14-03-2001
// Cambio de [port] a [port1] para inicio multiport 14-03-2001
// Uso de valores de interrogación para eventos y habilitados 14-03-2001
// Eliminación de paquetes erróneos 17-03-2001
// Agregado de transmisión de franjas 28-04-2001
// v3.0 Modificación a paquete de 16 bytes 05-05-2001
// Cambio a array de datos en funciones Leer/Escribir memoria 14-05-2001
// Agregado de cálculo de banco por relación grabada 15-05-2001
// Corrección de Bug al grabar propiedades borraba relación 15-07-2001
// Correcciones a la subida y bajada de datos con relación HAB/EV 19-07-2001
// Alarma y Aviso de Puerta Abierta 06-08-2001
// Habilitación por diferencias 07-08-2001
// Descarga Automática 13-08-2001
// Flag hab_online para deshabilitar eventos online entre operaciones 07-10-2001
// Modificación de rutina para agregar evento a la base (más rápida) 07-10-2001
// Modificación de modo de comunicación con nodos (Al comunicarse con el nodo
// se espera la respuesta, al recibir evento online, se implementó timeout x ruido
// y funciona bien con buffer chico 05-11-2001
// Arreglo de comunicación cuando la lista de habilitados no está equilibrada 17-11-2001
// Subida por diferencias siempre habilitado no importando flag 05-04-2003
// Problema de ventana de progreso tapando pregunta si desea seguir subiendo franjas,
// Sólo sube 3 franjas si está en modo descargador 05/08/2003
// Corrección no permitía año mayor a 2003 30-12-2003
// Corrección en Paradox no setea Ev_id 23-06-2004
// Huevo de Pascua, si se trata de comunicar después de 31/12/2005 (rx y tx), error 05-07-2004
// Eliminación de Huevo de Pascua anterior, pasando la fecha a 31/12/2007, 05-01-2006
// Soporte para año 2008 a 2011, modificación interpretación fecha en paquete, 14/12/2007
//
//---------------------------------------------------------------------------

unit Comunicaciones;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  OoMisc, Registry, AdPort, ComCtrls, Db, DBTables, FileCtrl, AdPacket,
  ExtCtrls, kbmMemTable;

//---------------------------------------------------------------------------
// CONSTANTES
//------------------------------------------------------------------------------

const
   BAUDRATE = 38400;   // Velocidad de comunicación con los nodos
   SIZE = 16;          // Tamaño del paquete de comunicación

   // Corrección 13/03/2004 - Permite hasta 127 nodos
   //MAX_NOD = 31;       // Máxima cantidad de nodos permitidos
   MAX_NOD = 127;       // Máxima cantidad de nodos permitidos

   // Constantes de comunicación (recepción)
   IDDLE =   0;
   SUCCESS = 1;
   ERROR =   2;
   TIMEOUT = $FF;

   // Comandos de comunicacion con el NODO
   CMD_INTERROGA =     $BB; // Retorna variables del nodo
   CMD_MODELO =        $CC; // Retorna nombre del equipo
   CMD_LEE_ESTADO =    $08; // Devuelve fecha y hora, tiempo de acceso
   CMD_EV_HAB =        $01; // Borra y retorna cant. de eventos y habils.
   CMD_ESCRIBE_RELOJ = $10; // Escribe RTC del nodo
   CMD_RESET =         $AA; // Resetea el nodo
   CMD_ESCRIBE_MEM =   $11; // Escribe la memoria del nodo
   CMD_LEE_MEM =       $22; // Lee la memoria del nodo
   CMD_ONLINE =        $DD; // Evento Online
   CMD_AP_REMOTA =     $20; // Apertura remota
   CMD_ALARMA =        $40; // Alarma de puerta abierta
   CMD_RESPUESTA =     $33; // Respuesta a un evento online
   CMD_BLOQUEO   =     $44; // Bloqueo / Desbloqueo del nodo
   CMD_ATENDER =       $45; // Atiende la alarma del nodo

   // Direcciones de Memoria de Datos
   DIR_FLAGS2 =  $04;
   DIR_TACC =    $05;
   DIR_PRIMDIG = $06;
   DIR_TAL =     $07;
   DIR_FLAGS =   $08;
   DIR_RELAC =   $09;

   // Constantes para comando CMD_EV_HAB
   EV = 1;      HAB = 0;     BORRA = 1;     LEE = 0;

   // Definición de colores de los eventos en lista
   clFICHADA  = $00FFFFFF;      // Blanco
   clREMOTA   = $00FBFCAC;      // Celeste
   clERRCOM   = $00B9B9BB;      // Gris
   clCOMANDO  = $00C0FFFF;      // Amarillo
   clINTRUSO  = $00BAF8C0;      // Verde
   clFUERA    = $00B0C8E4;      // Naranja
   clCADUC    = $00DBC0BD;      // Lila
   clAVISO    = $009D9DFB;
   clALARMA   = $00A6A6FC;      // Rojo
   clPULSADOR = $00F2EFA6;      // Celeste

//------------------------------------------------------------------------------
// DEFINICION DE CLASES Y TIPOS
//------------------------------------------------------------------------------

type
  TFCom = class(TDataModule)
    port1: TApdComPort;
    Consulta: TQuery;
    dComm: TDataSource;
    TimerCOM: TTimer;
    procedure port1TriggerAvail(CP: TObject; Count: Word);
    procedure DataModuleCreate(Sender: TObject);
    procedure DataModuleDestroy(Sender: TObject);
    procedure TimerCOMTimer(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

  // Definición de tipo Registro de Evento
  TEvento = Record
      tipo: Char;           // tipo de evento generado
      numnodo: Integer;     // número del nodo que generó el evento
      nodo: String[40];     // nombre del nodo que generó el evento
      nombre: String[40];   // nombre de la persona si existiera
      tarjeta: String[8];   // numero de tarjeta pasada
      fecha: String[10];    // fecha del evento
      hora: String[5];      // hora del evento
      es: Char;             // entrada / salida del evento
      foto: String;         // archivo de foto a mostrar
      mensaje: String[40];  // mensaje a mostrar en lista de eventos
      codigo: String[4];    // código de teclado del evento
  end;

  // Definición de tipo Registro de Habilitado
  THabilitado = Record
      nombre: String[40];
      tarjeta: String[8];
      codigo: String[4];
      caducidad: String[11];
      franja: Byte;
      susp: Boolean;
  end;

  // Definición de tipo Registro de Estado
  TStatus = Record
      fecha: String[10];
      hora: String[5];
      tacc: Integer;
      estado: Integer;
  end;

  // Definición de tipo Registro de Nodo
  TNodo = Record
         id: Integer;
         nombre: String[40];
  end;

  dato = Array[0..15] of Byte;

  // Definición de objeto TComm485
  TComm485 = Class
  public
     hab_online: Boolean;                      // indica si permite rx de eventos online
     hab_rx: Boolean;                          // indica si rx está habilitada
     modem: Boolean;                           // indica si modem habilitado
     connected: Boolean;                       // indica si modem conectado
     //Nod_status: Array[1..MAX_NOD] of Integer; // estado de los nodos
     status: Integer;                          // estado del puerto (int)
     txt_status: String;                       // estado del puerto (texto)
     retry: Integer;                           // cantidad de intentos de comm
     rxtimeout: Real;                          // timeout en tics
     UltimoBanco: Integer;                     // Ultimo banco de la memoria
     PrimerBancoEventos: Integer;              // Primer banco de eventos
     ConFranjas: Boolean;                      // El nodo maneja franjas?
     DescAuto: record                          // Parámetros de descarga automática
       hab: Boolean;
       HoraInicio: TDateTime;
       Intervalo: Integer;
       Todos: Boolean;
       EnProceso: Boolean;
       HoraProxDescarga: TDateTime;
       UltimoNodoDescargado: Integer;
     end;
     memEventos: TkbmMemTable;
     ModeloEquipo: Char;                       // Almacena letra que corresponde a modelo de nodo

     function InitPort: Boolean;
     function ClosePort: Boolean;
     procedure Apertura_Remota(nodo: Integer);
     procedure Bloqueo(nodo: Integer);
     procedure AtenderAlarma(nodo: Integer);
     function Escribe_Memoria(nodo, banco, dir, cantidad: Byte; d: Dato) : Boolean;
     function Lee_Memoria(nodo, banco, dir, cantidad: Byte; var d: dato) : Boolean;
     function Get_Status(nodo: Integer; var estado: TStatus) : Boolean;
     function Interrumpe(nodo: Integer) : Boolean;
     //function Interroga(nodo : Integer): Boolean;
     function Even_Hab(nodo:Integer; valor1, valor2: Byte; var total: Integer) : Boolean;
     function Upload_Tarjetas(nodo: Integer): Boolean;
     function Reset(nodo: Integer): Boolean;
     function Escribe_Reloj(nodo: Integer; estado: TStatus) : Boolean;
     function Escribe_Tacc(nodo, tacc: Integer): Boolean;
     procedure Evento_Local(tipo: Char; nodo: Integer);
     function Download_Ev(nodo: Integer) : Boolean;
     function Set_Cant_Hab(nodo, cantidad: Integer): Boolean;
     function Upload_Franjas(nodo: Integer) : Boolean;
     function Upload_Feriados(nodo: Integer) : Boolean;
     function Modelo(nodo: Integer; var s: String): Boolean;
     procedure Evento_a_Lista(evento: TEvento);
     procedure Evento_a_Imagen(evento: TEvento);
     procedure Evento_a_tabla_memoria(evento: TEvento);
     function Lee_ID_Ultima_Subida(nodo: Integer; var ID: String): Boolean;
     function Compara_Tarjetas(nodo: Integer): Boolean;
     procedure DescargaAutomatica;

  private
     com: Integer;                          // Número del puerto serie
     timeout_ms: Integer;                   // timeout en ms
     pack_in: Array[1..100] of Byte;        // paquete recibido
     pack_out: Array[1..SIZE] of Byte;      // paquete a transmitir

     function Comando_Nodo(espera: Boolean = True): Boolean;
     procedure Send_paquete;
     procedure Get_paquete(cant: Integer);
     procedure Evento_Online;
     //procedure Alarma_Online;
     procedure Evento_a_Base(evento: TEvento);
     procedure Evento_a_Texto(evento: TEvento);
     function Get_Evento(nodo: Byte; posicion: Integer; var evento: TEvento): Boolean;
     function Hab_Tarjeta(nodo: Byte; posicion: Integer; habil: THabilitado): Boolean;
     function Filtro_Ev(evento: TEvento): Boolean;
     function Escribe_ID_Ultima_Subida(nodo: Integer; ID: String): Boolean;
     procedure Evento_a_Estado(evento: TEvento);
     //procedure Espera_paquete(Count: Integer);
  end;

//---------------------------------------------------------------------------
// DEFINICION DE VARIABLES DEL MÓDULO
//------------------------------------------------------------------------------

var
  FCom: TFCom;       // Form contenedor del componente de puerto serie
  p: TComm485;       // Objeto de comunicación con los nodos

//---------------------------------------------------------------------------
// DECLARACION DE FUNCIONES PÚBLICAS
//------------------------------------------------------------------------------

implementation

// Units referenciadas en el módulo de comunicaciones
uses Principal, UModem, Datos, Rutinas, Progreso, Paquetes, Serkey, HabTest;

{$R *.DFM}

//---------------------------------------------------------------------------
// CREA EL MÓDULO DE COMUNICACIONES
//
// OK 15-05-2001
//------------------------------------------------------------------------------

procedure TFCom.DataModuleCreate(Sender: TObject);
begin
   // Crea objeto de acceso a la red 485
   p := TComm485.Create;
end;

//---------------------------------------------------------------------------
// DESTRUYE EL MÓDULO DE COMUNICACIONES
//
// OK 15-05-2001
//------------------------------------------------------------------------------

procedure TFCom.DataModuleDestroy(Sender: TObject);
begin
   // Destruye clase de acceso a la red
   p.Free;
end;

//------------------------------------------------------------------------------
// RECIBE DATOS POR EL PUERTO SERIE
//
// OK 15-05-2001
//------------------------------------------------------------------------------

procedure TFCom.port1TriggerAvail(CP: TObject; Count: Word);
begin
   // Recibe datos sólo si está habilitada la recepción
   if p.hab_rx then
   begin
      {
      // Después de 31/12/2005, no funcionan las comunicaciones (Huevo de Pascuas)
      if SysUtils.Date > EncodeDate(2005, 12, 31) then
      begin
        raise Exception.Create('Access Violation in SAC32.DecodeDate@Convert function. Date not supported in communication buffer');
      end;
      }

      // 05-01-2006
      EasterEgg();

      // En modo debug muestra bytes recibidos
      if debug then FPaquetes.memo.Lines.Add('Recibido paquete de ' + InttoStr(Count) + ' bytes');

      // Si recibe ruido, borra el buffer de recepción
      {if Count < 2 then
      begin
         FCom.port1.FlushInBuffer;
         if debug then FPaquetes.memo.Lines.Add('Paquete incorrecto. Buffer rx borrado');
      end
      else
        // Si recibió paquete completo, lo procesa
        if Count >= SIZE then p.Get_paquete(Count);}

      // Voy a la rutina que espera el paquete completo
      //p.Espera_paquete(Count);

      if Count < SIZE then TimerCOM.Enabled := True
      else
      begin
         TimerCOM.Enabled := False;
         p.Get_paquete(Count);
      end;
   end;
end;

//------------------------------------------------------------------------------
// TIMER DE TIMEOUT DE RECEPCIÓN DE PAQUETE DE 16 BYTES
//
// OK 05-11-2001
//------------------------------------------------------------------------------

procedure TFCom.TimerCOMTimer(Sender: TObject);
begin
    TimerCOM.Enabled := False;      // Deshabilita timer
    FCom.port1.FlushInBuffer;       // Limpia el buffer de entrada
    if debug then FPaquetes.memo.Lines.Add('TIMEOUT EN PAQUETE!');
end;

//------------------------------------------------------------------------------
// ESPERA LA RECEPCIÓN DE UN PAQUETE COMPLETO
//
// OK 04-11-2001
//------------------------------------------------------------------------------

(*
procedure TComm485.Espera_paquete(Count: Integer);
var
  i: Integer;
  t_inicio: TDateTime;
  crc: Integer;
  rxd: Integer;
begin
   FCom.port1.OnTriggerAvail := nil;
   hab_rx := False;                     // Deshabilita la recepción por eventos
   FPrincipal.Timer1.Enabled := False;  // Deshabilita timer de reloj

   // Borra buffer de paquete de entrada
   for i:=1 to SIZE do pack_in[i] := 0;

   // Recibe lo que tiene hasta ahora
   FCom.port1.GetBlock(pack_in, Count);
   //if (pack_in[1] and $80) = $80 then rxd := Count + 1
   //else                               rxd := 1;
   rxd := Count + 1;

   t_inicio := Now;                  // Tiempo inicial = Ahora
   status := IDDLE;

   while (status = IDDLE) do         // Mientras estado = inactivo
   begin
      //try
        if debug then FPaquetes.memo.Lines.Add('Esperando char...' + InttoStr(rxd));
        if (FCom.port1.CharReady) and (status = IDDLE) then
        begin
           pack_in[rxd] := Integer(FCom.port1.GetChar);
           if debug then FPaquetes.memo.Lines.Add(Format('RX = %2.2X', [pack_in[rxd]]));
           //if not ((rxd = 1) and ((pack_in[1] and $80) = $80)) then inc(rxd);
           inc(rxd);
           if rxd > SIZE then
           begin
               // Muestra paquete rx (DEBUG)
               if debug then FPaquetes.memo.Lines.Add(Format('RX = %2.2X %2.2X %2.2X %2.2X %2.2X %2.2X %2.2X %2.2X %2.2X %2.2X %2.2X %2.2X %2.2X %2.2X %2.2X %2.2X', [pack_in[1], pack_in[2], pack_in[3], pack_in[4], pack_in[5], pack_in[6], pack_in[7], pack_in[8], pack_in[9], pack_in[10], pack_in[11], pack_in[12], pack_in[13], pack_in[14], pack_in[15], pack_in[16]]));

               // Calcula el CRC del paquete
               crc := 0; for i:=1 to SIZE do crc := crc xor pack_in[i];

               // Si CRC OK y paquete desde nodo...
               if (crc=0) and ((pack_in[1] shr 7)=1) then status := SUCCESS
               else                                       status := ERROR;
           end;
        end;
      {except
        status := ERROR;
      end;}

      if (Now - t_inicio) > rxtimeout then  // Si pasó el tiempo
         status := TIMEOUT;                 // estado = Timeout

      // Procesa mensajes de windows
      //Application.ProcessMessages;

      // Procesa comunicaciones
      FCom.port1.ProcessCommunications;
   end;

   {while FCom.port1.CharReady do
   begin
     if debug then FPaquetes.memo.Lines.Add(Format('RX = %2.2X', [Integer(FCom.port1.GetChar)]));
   end;}

   // Limpia buffer de entrada
   FCom.port1.FlushInBuffer;

   // Limpia buffer de recepción si hubo error
   //if status = ERROR then FCom.port1.FlushInBuffer;

   // Si hubo un paquete bueno detecta eventos on-line
   if (status = SUCCESS) and (hab_online) then
   begin
      case pack_in[2] of
         CMD_ONLINE: Evento_Online; // Genera un evento online
      end;
   end;

   Screen.Cursor := crDefault;        // Saca cursor de reloj de arena
   hab_rx := True;                    // Vuelve a habilitar la recepción
   FCom.port1.OnTriggerAvail := FCom.port1TriggerAvail;
end;
*)

//------------------------------------------------------------------------------
// ABRE Y CONFIGURA EL PUERTO SERIE
//
// OK 15-05-2001
//------------------------------------------------------------------------------

function TComm485.InitPort : Boolean;
var
   Reg : TRegistry;
begin
   Reg := TRegistry.Create;        // Crea acceso al registro
   Reg.OpenKey(StrREG, True);      // Abre clave del programa

   // Lee del registro variables de comunicaciones
   if Reg.ValueExists('Puerto') then com := Reg.ReadInteger('Puerto')
   else                              com := 1;
   if Reg.ValueExists('Reintentos') then retry := Reg.ReadInteger('Reintentos')
   else                                  retry := 3;
   if Reg.ValueExists('Timeout') then timeout_ms := Reg.ReadInteger('Timeout')
   else                               timeout_ms := 1000;

   // Chequea valores correctos
   if not (com in [0,1,2,3,4]) then com:=0;
   if (retry<1) or (retry>50) then retry:=3;
   if (timeout_ms<100) or (timeout_ms>10000) then timeout_ms:=1000;

   // Si no existían las variables las crea en el registro
   Reg.WriteInteger('Puerto', com);
   Reg.WriteInteger('Reintentos', retry);
   Reg.WriteInteger('Timeout', timeout_ms);

   // Configura timeout de recepción
   rxtimeout :=  timeout_ms / 86400000;     // (24*60*60*1000)

   Reg.CloseKey;             // Cierra clave de registro
   Reg.Destroy;              // Destruye variable de registro

   // Intenta apertura del puerto serie configurado
   {if not llave.mododemo then
   begin}
     try
        with FCom.port1 do
        begin
          // Permite loguear la comunicación
          if FindCmdLineSwitch('log', ['/', '-'], True) then Tracing := tlOn
          else                                               Tracing := tlOff;

          Open := False;              // Cierra puerto antes de abrirlo
          ComNumber := com;           // Asigna numero de COM
          Baud := BAUDRATE;           // Configura Velocidad de Puerto
          DataBits := 8;              // Configura Propiedades del puerto
          //Parity := pMark;            // 8N2  (8M2)
          Parity := pNone;
          StopBits := 1;              //

          //UseEventWord := True;

          Open := True;               // Abre el COM
          RTS := True;                // Baja E485TX (Modificación CONVERSORA)
          DTR := False;               // Baja DTR (No alimenta SERKEY)
          FlushInBuffer;              // Borra buffer de entrada
          status := IDDLE;            // Estado RX = Esperando
          txt_status := 'COM' + InttoStr(com) + ' OK';
          FPrincipal.BarraEstado.Repaint;
          hab_rx := True;
          hab_online := True;
          Result := True;
        end;
     except
        on E: Exception do
        begin
          status := ERROR;
          txt_status := 'COM' + InttoStr(com) + ' Mal';
          FPrincipal.BarraEstado.Repaint;
          hab_rx := False;
          Result := False;
        end;
     end;
   {end
   else
   begin
      status := iDDLE;
      txt_status := 'COM' + InttoStr(0) + ' OK';
      FPrincipal.BarraEstado.Repaint;
      hab_rx := False;
      Result := True;
   end;}
end;

//------------------------------------------------------------------------------
// CIERRA EL PUERTO SERIE
//
// OK 15-05-2001
//------------------------------------------------------------------------------

function TComm485.ClosePort : Boolean;
begin
   FCom.port1.RTS := True;
   FCom.port1.DTR := False;
   FCom.port1.Open := False;     // Cierra puerto serie;
   Result := True;
end;

//------------------------------------------------------------------------------
// ENVIA UN COMANDO AL NODO Y ESPERA RESPUESTA (REINTENTA n VECES)
//
// OK 15-05-2001
//------------------------------------------------------------------------------

function TComm485.Comando_Nodo(espera: Boolean = True): Boolean;
var
  i, reintentos: Integer;
  t_inicio: TDateTime;
  crc: Integer;
  rxd: Integer;
begin
   hab_rx := False;                     // Deshabilita la recepción por eventos
   Screen.Cursor := crHourGlass;        // Pone cursor de reloj de arena
   FPrincipal.Timer1.Enabled := False;  // Deshabilita timer de reloj

   // Chequeo a hacer cuando está en modo conexión remota
   if Modem then
   begin
      // Espera a que termine de hacer el ping
      while pinging do Application.ProcessMessages;

      // Deshabilita pings e incrementa contador de paquetes tx'd
      if Connected then
      begin
        with FModem do
        begin
           TimerPing.Enabled := False;
           Label3.Caption := InttoStr(StrtoInt(Label3.Caption)+1);
        end;
      end;
   end;

   Result := False;                  // Inicializa Result
   reintentos := 0;                  // Inicializa reintentos

   // Repite hasta que haya respuesta o los reintentos >= valor especificado
   repeat
       // Borra buffer de paquete de entrada
       if espera then for i:=1 to SIZE do pack_in[i] := 0;

       // Envía paquete al nodo
       Send_paquete;

       // Espera paquete de respuesta si es necesario
       if not espera then
       begin
          // Transmisión de paquete OK
          status := SUCCESS;
          Result := True;
       end
       else
       begin
         rxd := 1;
         t_inicio := Now;                  // Tiempo inicial = Ahora

         while (status = IDDLE) do         // Mientras estado = inactivo
         begin
              try
                if FCom.port1.CharReady then
                begin
                   pack_in[rxd] := Integer(FCom.port1.GetChar);
                   if rxd = SIZE then
                   begin
                       // Muestra paquete rx (DEBUG)
                       if debug then FPaquetes.memo.Lines.Add(Format('RX = %2.2X %2.2X %2.2X %2.2X %2.2X %2.2X %2.2X %2.2X %2.2X %2.2X %2.2X %2.2X %2.2X %2.2X %2.2X %2.2X', [pack_in[1], pack_in[2], pack_in[3], pack_in[4], pack_in[5], pack_in[6], pack_in[7], pack_in[8], pack_in[9], pack_in[10], pack_in[11], pack_in[12], pack_in[13], pack_in[14], pack_in[15], pack_in[16]]));

                       // Calcula el CRC del paquete
                       crc := 0; for i:=1 to SIZE do crc := crc xor pack_in[i];

                       // Si CRC OK y paquete desde nodo...
                       if (crc=0) and ((pack_in[1] shr 7)=1) and
                          ((pack_in[1] and $7F) = pack_out[1]) then  status := SUCCESS
                       else                                          status := ERROR;
                   end;
                   inc(rxd);
                end;
              except
                status := ERROR;
              end;

              if (Now - t_inicio) > rxtimeout then  // Si pasó el tiempo
                 status := TIMEOUT;                 // estado = Timeout

              // Procesa mensajes de windows
              Application.ProcessMessages;

              // Procesa comunicaciones
              FCom.port1.ProcessCommunications;
         end;

         if status = SUCCESS then Result := True   // Comm OK
         else inc(reintentos);                     // Comm KO (reintenta)
       end;

   until (Result = True) or (reintentos >= RETRY);

   // Limpia buffer de entrada  (No hace falta)
   //FCom.port.FlushInBuffer;

   // Vuelve a habilitar ping
   if (Modem and Connected) then FModem.TimerPing.Enabled := True;

   FPrincipal.Timer1.Enabled := True; // Vuelve a habilitar timer
   Screen.Cursor := crDefault;        // Saca cursor de reloj de arena

   hab_rx := True;    // Vuelve a habilitar la recepción
end;

//------------------------------------------------------------------------------
// ENVIA EL PAQUETE AL NODO
//
// OK 15-05-2001
//------------------------------------------------------------------------------

procedure TComm485.Send_paquete;
var
   i : Integer;
begin
   {
   // Después de 31/12/2005, no funcionan las comunicaciones (Huevo de Pascuas)
   if SysUtils.Date > EncodeDate(2005, 12, 31) then
   begin
     raise Exception.Create('Access Violation in SAC32.DecodeDate@Convert function. Date not supported in communication buffer');
   end;
   }

   // 05-01-2006
   EasterEgg();

   FCom.port1.FlushOutBuffer;         // Borra buffers rx y tx
   //FCom.port.FlushInBuffer;
   status := IDDLE;                   // Estado RX = IDDLE (Esperando)

   // Calcula el CRC del paquete a enviar
   pack_out[SIZE] := 0;
   for i:=1 to SIZE-1 do pack_out[SIZE] := pack_out[SIZE] xor pack_out[i];

   // Muestra el paquete a mandar (DEBUG)
   if debug then FPaquetes.memo.Lines.Add(Format('TX = %2.2X %2.2X %2.2X %2.2X %2.2X %2.2X %2.2X %2.2X %2.2X %2.2X %2.2X %2.2X %2.2X %2.2X %2.2X %2.2X', [pack_out[1], pack_out[2], pack_out[3], pack_out[4], pack_out[5], pack_out[6], pack_out[7], pack_out[8], pack_out[9], pack_out[10], pack_out[11], pack_out[12], pack_out[13], pack_out[14], pack_out[15], pack_out[16]]));

   // baja RTS para habilitar transmisión de driver 485
   {FCom.port1.RTS := False;}

   // ventana (5ms @ 38400) (1ms @ 9600) (Corrección 1ms @ 38400)
   {sleep(1);}
   //if FCom.port.Baud = 38400 then sleep(1) else sleep(1);

   // Transmite el paquete a la red
   //FCom.port1.PutBlock(pack_out, SIZE);

   begin
     for i:=1 to SIZE do
     begin
         FCom.port1.PutChar(Char(pack_out[i]));
         //if FCom.port1.Baud = 9600 then sleep(2);       // 2ms @ 9600
         //sleep(1);       // 1ms baud=38400 y SIZE=16
     end;
   end;

   // Espera a que se transmita todo el buffer
   repeat until FCom.port1.OutBuffUsed = 0;

   // ventana (4ms @ 38400) (1ms @ 9600)
   {sleep(4);}   // Vuelvo a poner 4ms acá porque hay problemas... (08-09-2001)
   //sleep(1);
   //if FCom.port.Baud = 38400 then sleep(4) else sleep(1);

   // sube RTS para habilitar recepción de driver 485
   {FCom.port1.RTS := True;}
end;

//------------------------------------------------------------------------------
// ESPERA RECIBIR PAQUETE DE UN NODO
//
// OK 15-05-2001
// pendiente: cambio de detección de eventos online
//------------------------------------------------------------------------------

procedure TComm485.Get_paquete(cant : Integer);
var
    crc, i : Integer;
begin
   // Repite hasta que no haya más paquetes pendientes
   repeat
     // Recibe si en modo red ó en modo modem y conectado
     if ((not Modem) or (Modem and Connected and (not Pinging))) then
     begin
       try
         // Intenta recibir todo el paquete
         FCom.port1.GetBlock(pack_in, cant);

         // Incrementa cantidad de paquetes recibidos en modo modem
         if Modem then
            FModem.Label4.Caption := InttoStr(StrtoInt(FModem.Label4.Caption)+1);

         // Muestra paquete rx (DEBUG)
         if debug then FPaquetes.memo.Lines.Add(Format('RX = %2.2X %2.2X %2.2X %2.2X %2.2X %2.2X %2.2X %2.2X %2.2X %2.2X %2.2X %2.2X %2.2X %2.2X %2.2X %2.2X', [pack_in[1], pack_in[2], pack_in[3], pack_in[4], pack_in[5], pack_in[6], pack_in[7], pack_in[8], pack_in[9], pack_in[10], pack_in[11], pack_in[12], pack_in[13], pack_in[14], pack_in[15], pack_in[16]]));

         // Calcula el CRC del paquete
         crc := 0; for i:=1 to SIZE do crc := crc xor pack_in[i];

         // Si CRC OK y paquete desde nodo...
         if (crc=0) and ((pack_in[1] shr 7)=1) then status := SUCCESS
         else                                       status := ERROR;

       except
         status := ERROR;           // Si falló, recepcíon errónea
       end;

       // Limpia buffer de recepción si hubo error
       if status = ERROR then FCom.port1.FlushInBuffer;

       // Si hubo un paquete bueno detecta eventos on-line
       // En modo descargador no recibe eventos online
       if (status = SUCCESS) and (hab_online) and (llave.modofull) then
       begin
          case pack_in[2] of
             CMD_ONLINE: Evento_Online; // Genera un evento online
             //CMD_ALARMA: Alarma_Online; // Genera una alarma
          end;
       end;
     end;
   until not FCom.port1.CharReady;
end;

//------------------------------------------------------------------------------
// PROCESA EL EVENTO ONLINE 
//
// pendiente: revisar con nuevos eventos
//------------------------------------------------------------------------------

procedure TComm485.Evento_Online;
var
    evento : TEvento;                  // Almacena datos del evento
begin
    // Devuelve la respuesta al nodo
    pack_out[1] := pack_in[1] and $7F; // Bajo bit 7 para responder al nodo
    pack_out[2] := CMD_RESPUESTA;      // Comando de respuesta
    Comando_Nodo(False);               // Manda paquete sin esperar respuesta

    // Guarda número y nombre del nodo que generó el evento
    evento.numnodo := pack_in[1] and $7F;
    with FCom.Consulta do
    begin
        SQL.Clear;
        SQL.Add('SELECT Nod_nom FROM Nodos');
        SQL.Add('WHERE Nod_num = ' + InttoStr(evento.numnodo));
        Open;
        if RecordCount <> 0 then evento.nodo := FieldbyName('nod_nom').AsString
        else                     evento.nodo := 'Desconocido';
        Close;
    end;

    // Detecta el tipo de evento
    case pack_in[12] of
      0: begin evento.tipo := 'A'; PlayWav('NOTIFY');   end; // Acceso Normal
      1: begin evento.tipo := 'I'; PlayWav('ERR');      end; // Intruso
      2: begin evento.tipo := 'C'; PlayWav('ERR');      end; // Caducidad Vencida
      3: begin evento.tipo := 'F'; PlayWav('ERR');      end; // Fuera de Horario
      4: begin evento.tipo := 'P';                      end; // Alarma de Puerta Abierta
      5: begin evento.tipo := 'T';                      end; // Aviso de Puerta Abierta
      6: begin evento.tipo := 'U';                      end; // Acceso por Pulsador
    end;

    // Guarda fecha y hora del evento
    evento.fecha := Format('%2.2d/%2.2d/%4.4d',
                    [pack_in[11] and $1F,
                    ((pack_in[9] shr 4) and $08) or
                    ((pack_in[10] shr 5) and $07),

                    // Corrección 30/12/2003 - Estaba tomando sólo hasta 2003 (ahora sigue hasta 2007)
                    //2000 + ((pack_in[11] shr 5) and $03)]);
                    //2000 + ((pack_in[11] shr 5) and $07)]);

                    // Corrección 14/12/2007
                    // Toma el año que viene en pack_in[11], de 2008 hasta 2011
                    // pack_in[11] = yyyh hhhh (y:year, h:hour)
                    // 000: 2008
                    // 001: 2009
                    // 010: 2010
                    // 011: 2011
                    2008 + ((pack_in[11] shr 5) and $03)]);

    evento.hora := Format('%2.2d:%2.2d', [pack_in[10] and $1F, pack_in[9] and $3F]);

    // Proceso los eventos que manejan tarjetas
    if evento.tipo in ['A', 'I', 'C', 'F'] then
    begin
        // Guarda número de tarjeta y codigo pasados
        evento.tarjeta := Format('%2.2x%2.2x%2.2x%2.2x',
                                 [pack_in[6], pack_in[5], pack_in[4], pack_in[3]]);
        evento.codigo := Format('%2.2x%2.2x', [pack_in[7], pack_in[8]]);

        // Guarda E/S del evento
        if (((pack_in[9] and $40) shr 6) = 1) then evento.es := 'E' else evento.es := 'S';

        // Consulta nombre y foto de la persona
        with FCom.Consulta do
        begin
            SQL.Clear;
            SQL.Add('SELECT Usr_nom, Usr_fot FROM Usuarios');
            SQL.Add('WHERE Usr_tarj = "' + evento.tarjeta + '"');
            Open;
            if RecordCount <> 0 then
            begin
                // Si la tarjeta existe en la base recupera nombre y foto
                evento.nombre := FieldbyName('Usr_nom').AsString;
                evento.foto := FieldbyName('Usr_fot').AsString;

                case evento.tipo of
                  'A': evento.mensaje := evento.nombre;
                  'I': evento.mensaje := 'No Autorizado: ' + evento.nombre;
                  'C': evento.mensaje := 'Caducidad: ' + evento.nombre;
                  'F': evento.mensaje := 'Fuera Horario: ' + evento.nombre;
                end;
            end
            else
            begin
                // Si no existe Desconocido o Intruso
                case evento.tipo of
                  'A': evento.nombre := 'Acceso Desconocido';
                  'I': evento.nombre := 'Acceso no Autorizado';
                  'C': evento.nombre := 'Tarjeta Desconocida Caduca';
                  'F': evento.nombre := 'Tarjeta Fuera de Horario';
                end;

                evento.mensaje := evento.nombre;
            end;
            Close;
        end;

        Evento_a_Base(evento);      // Almacena el evento en la base de eventos
        Evento_a_Lista(evento);     // Muestra el evento en la lista on-line
        Evento_a_Imagen(evento);    // Muestra la foto del evento
        Evento_a_Texto(evento);     // Agrega evento al archivo de texto
        Evento_a_Estado(evento);    // Actualiza el estado del ícono
    end

    // Proceso los eventos que no manejan tarjetas
    else
    begin
        evento.tarjeta := '';
        evento.codigo := '';
        evento.es := ' ';
        evento.nombre := '';
        evento.foto := '';

        case evento.tipo of
          'U': evento.mensaje := 'Acceso por Pulsador';
          'P': evento.mensaje := 'Alarma de Puerta Abierta';
          'T': evento.mensaje := 'Aviso de Puerta Abierta';
          else evento.mensaje := '';
        end;

        case evento.tipo of
          'U':  PlayWav('INFO');
          'P':  PlayWav('SIREN');
          'T':  ;
          else ;
        end;


        Evento_a_Base(evento);      // Almacena el evento en la base de eventos
        Evento_a_Lista(evento);     // Muestra el evento en la lista on-line
        Evento_a_Imagen(evento);    // Muestra la foto del evento
        Evento_a_Estado(evento);    // Actualiza el estado del ícono
    end;
end;


//------------------------------------------------------------------------------
// PROCESA LA ALARMA RECIBIDA
//
// pendiente: revisar
//------------------------------------------------------------------------------

{procedure TComm485.Alarma_Online;
begin
   // Devuelve respuesta al nodo
   pack_out[1] := pack_in[1] and $7F;       // Seteo nodo
   pack_out[2] := CMD_RESPUESTA;            // Comando de respuesta
   Comando_Nodo(False);                     // Manda paquete sin espera

   PlayWav('SIREN');                        // Reproduce WAV de alarma

   // Genera un evento de tipo alarma
   Evento_Local('L', (pack_in[1] and $7F));
end;}

//------------------------------------------------------------------------------
// AGREGA UN EVENTO A LA BASE DE EVENTOS
//
// OK: 19-05-2001
// Revisión OK: 19-07-2001
// Modificación más rápido: 16-11-2001
//------------------------------------------------------------------------------

procedure TComm485.Evento_a_Base(evento : TEvento);
var
   //abierta: Boolean;
   qryEv: TQuery;
begin
   qryEv := TQuery.Create(nil);
   try
     qryEv.DatabaseName := FCom.Consulta.DatabaseName;

     // 23/06/2004 - En Paradox no pone Ev_id, en Interbase si.
     if TIPO_BASE = PARADOX then
       qryEv.SQL.Text := Format('insert into Eventos ' +
           '(Ev_tipo, Ev_nod, Ev_pers, Ev_tarj, Ev_cod, Ev_fecha, Ev_fecha2, Ev_hora, Ev_es) ' +
           'VALUES ' +
           '("%s", "%s", "%s", "%s", "%s", "%s", "%s", "%s", "%s")',
           [evento.tipo, evento.nodo, evento.nombre, evento.tarjeta, evento.codigo, evento.fecha,
            Copy(evento.fecha,7,4) + Copy(evento.fecha,3,4) + Copy(evento.fecha,1,2),
            evento.hora, evento.es])

     else if TIPO_BASE = INTERBASE then
       qryEv.SQL.Text := Format('insert into Eventos ' +
           '(Ev_id, Ev_tipo, Ev_nod, Ev_pers, Ev_tarj, Ev_cod, Ev_fecha, Ev_fecha2, Ev_hora, Ev_es) ' +
           'VALUES ' +
           '(%d, "%s", "%s", "%s", "%s", "%s", "%s", "%s", "%s", "%s")',
           [Random(2147483647),
            evento.tipo, evento.nodo, evento.nombre, evento.tarjeta, evento.codigo, evento.fecha,
            Copy(evento.fecha,7,4) + Copy(evento.fecha,3,4) + Copy(evento.fecha,1,2),
            evento.hora, evento.es]);

     qryEv.ExecSQL;
   finally
     qryEv.Free;
   end;
end;

//------------------------------------------------------------------------------
// AGREGA UN EVENTO A LA BASE DE EVENTOS
//
// OK: 17-11-2001
//------------------------------------------------------------------------------

procedure TComm485.Evento_a_tabla_memoria(evento: TEvento);
begin
   memEventos.Append;
   memEventos['Ev_tipo'] := evento.tipo;
   memEventos['Ev_nod'] := evento.nodo;
   memEventos['Ev_pers'] := evento.nombre;
   memEventos['Ev_tarj'] := evento.tarjeta;
   memEventos['Ev_cod'] := evento.codigo;
   memEventos['Ev_fecha'] := evento.fecha;
   memEventos['Ev_fecha2'] := Copy(evento.fecha,7,4) + Copy(evento.fecha,3,4) + Copy(evento.fecha,1,2);
   memEventos['Ev_hora'] := evento.hora;
   memEventos['Ev_es'] := evento.es;
   memEventos.Post;
end;

//------------------------------------------------------------------------------
// AGREGA UN EVENTO A LA LISTA DE EVENTOS ONLINE
//
// OK: 19-05-2001
// Revisión OK: 19-07-2001
//------------------------------------------------------------------------------

procedure TComm485.Evento_a_Lista(evento : TEvento);
var
   I : TListItem;
begin
    // Filtra eventos por tipo según configuración
    if Filtro_Ev(evento) then
    begin
      // Inserta en la lista el nuevo evento
      I := FPrincipal.LEventos.Items.Insert(0);
      I.Caption := evento.tipo;
      I.ImageIndex := 0;

      I.SubItems.Add(evento.nodo);

      case evento.tipo of
        'U': evento.mensaje := 'Acceso por Pulsador';
        'P': evento.mensaje := 'Alarma por Puerta Abierta';
        'T': evento.mensaje := 'Aviso de Puerta Abierta';
      end;
      I.SubItems.Add(evento.mensaje);

      if not (evento.tipo in ['A', 'C', 'F', 'I']) then
      begin
         evento.tarjeta := '';
         evento.codigo := '';
         evento.es := ' ';
      end;

      I.SubItems.Add(evento.tarjeta);
      I.SubItems.Add(evento.codigo);
      I.SubItems.Add(evento.fecha);
      I.SubItems.Add(evento.hora);
      I.SubItems.Add(evento.es);

      // Mantiene la lista con la cantidad de elementos configurada
      with FPrincipal.LEventos do
         while Items.Count > ReadReg_I('Lineas') do Items.Delete(Items.Count-1);
    end;
end;

//------------------------------------------------------------------------------
// MUESTRA LA IMAGEN DEL EVENTO
//
// pendiente: revisar
// Revisión OK: 19-07-2001
//------------------------------------------------------------------------------

procedure TComm485.Evento_a_Imagen(evento : TEvento);
begin
  // Carga foto del evento si corresponde
  with FPrincipal do
  begin
    case evento.tipo of

    // Accesos Normales
    'A': begin
           // Carga la imagen si tiene una foto asignada y ésta existe
           if (evento.foto <> 'Sin foto') and
              FileExists(ReadReg_S('Ufot') + '\' + evento.foto) then
           begin
              Image1.Picture.LoadfromFile(ReadReg_S('Ufot') + '\' + evento.foto);
              GroupBoxFoto.Caption := 'Foto de ' + evento.nombre + ' [' + evento.tarjeta + ']';
              Image1.Show;
           end
           // Sino, borra la foto anterior
           else
           begin
             GroupBoxFoto.Caption := 'Foto';
             Image1.Hide;
           end;
         end;

    // Intrusos
    'I': begin
           GroupBoxFoto.Caption := 'Ingreso no autorizado';
           ShowBmp('Intruso');
         end;

    // Alarma de Puerta Abierta
    'P': begin
           GroupBoxFoto.Caption := 'Alarma por Puerta Abierta';
           ShowBmp('Alarma');
         end;

    // Aviso de Puerta Abierta
    'T': begin
           GroupBoxFoto.Caption := 'Aviso de Puerta Abierta';
           
         end;

    // Caducidad
    'C': begin
           GroupBoxFoto.Caption := 'Tarjeta Caduca';
           Image1.Hide;
         end;

    // Fuera de Horario
    'F': begin
           GroupBoxFoto.Caption := 'Tarjeta Fuera de Horario';
           Image1.Hide;
         end;

    // Acceso por Pulsador
    'U': begin
           GroupBoxFoto.Caption := 'Acceso por Pulsador';
           Image1.Hide;
         end;
    end;
  end;
end;

//------------------------------------------------------------------------------
// AGREGA UN EVENTO AL ARCHIVO DE TEXTO
//
// pendiente: revisar
// Revisión y agregado de campo código OK: 19-07-2001
//------------------------------------------------------------------------------

procedure TComm485.Evento_a_Texto(evento : TEvento);
var
   f: TextFile;
begin
  // Descarga evento en archivo de texto
  if ReadReg_I('DescTXT') = 1 then
  begin
     // Guarda sólo accesos normales
     if evento.tipo = 'A' then
     begin
       // Si no existe archivo de descarga, lo crea
       if not FileExists(carpeta + 'Descarga.dat') then
       begin
          AssignFile(f, carpeta + 'Descarga.dat');
          Rewrite(f);
          CloseFile(f);
       end;

       // Abre archivo y graba registro
       try
         if Length(evento.nombre) < 25 then evento.nombre := evento.nombre + StringOfChar(' ', 25 - Length(evento.nombre))
         else if Length(evento.nombre) > 25 then evento.nombre := Copy(evento.nombre, 1, 25);

         if Length(evento.tarjeta) < 8 then evento.tarjeta := StringOfChar(' ', 8 - Length(evento.tarjeta)) + evento.tarjeta;
         if Length(evento.codigo) < 4 then evento.codigo := StringOfChar(' ', 4 - Length(evento.codigo)) + evento.codigo;

         AssignFile(f, carpeta + 'Descarga.dat');
         Append(f);
         WriteLn(f, Format('%s %8s %4s %20s %10s %5s %1s',
                 [evento.nombre, evento.tarjeta, evento.codigo,
                  evento.nodo, evento.fecha, evento.hora, evento.es]));
         Flush(f);
       finally
         CloseFile(f);
       end;
     end;
  end;
end;

//------------------------------------------------------------------------------
// ACTUALIZA EL ESTADO DEL NODO EN LA LISTA DE NODOS
//
// Inicio: 10-08-2001
//------------------------------------------------------------------------------

procedure TComm485.Evento_a_Estado(evento: TEvento);
begin
  // Carga foto del evento si corresponde
  with FPrincipal do
  begin
    case evento.tipo of

      // Accesos Normales
      'A': FPrincipal.Nod_Status[evento.numnodo] := 3;

      // Intrusos
      'I': FPrincipal.Nod_Status[evento.numnodo] := 6;

      // Alarma de Puerta Abierta
      'P': FPrincipal.Nod_Status[evento.numnodo] := 8;

      // Aviso de Puerta Abierta
      'T': FPrincipal.Nod_Status[evento.numnodo] := 9;

      // Caducidad
      'C': FPrincipal.Nod_Status[evento.numnodo] := 7;

      // Fuera de Horario
      'F': FPrincipal.Nod_Status[evento.numnodo] := 10;

      // Acceso por Pulsador
      'U': FPrincipal.Nod_Status[evento.numnodo] := 11;

    end;

    // Actualiza el ícono en la lista de nodos
    ActualizaEstadoNodos(evento.numnodo);
  end;
end;

//------------------------------------------------------------------------------
// AGREGA UN EVENTO LOCAL EN LA BASE Y EN LA LISTA
//
// pendiente: revisar
// Revisión OK: 19-07-2001
//------------------------------------------------------------------------------

procedure TComm485.Evento_Local(tipo : Char; nodo : Integer);
var
    evento : TEvento;
    min, hora, seg, ms, anio, mes, dia : Word;
begin
    evento.tipo := tipo;      // Tipo de evento
    evento.numnodo := nodo;

    // Busca el nombre del nodo que generó el evento
    with FCom.Consulta do
    begin
      SQL.Text := 'SELECT Nod_nom FROM Nodos WHERE Nod_num = ' + InttoStr(evento.numnodo);
      Open;
      if RecordCount <> 0 then evento.nodo := FieldbyName('Nod_nom').AsString
      else                     evento.nodo := 'Desconocido';
      Close;
    end;

    // Realiza búsqueda de descripcion del tipo de evento
    with FCom.Consulta do
    begin
      SQL.Text := 'SELECT Tip_desc FROM Tip_Ev WHERE Tip_id = "' + tipo + '"';
      Open;
      evento.mensaje := FieldbyName('Tip_desc').AsString;
      Close;
    end;

    // Los eventos locales no tienen nombre, tarjeta ni e/s
    evento.nombre := '';
    evento.tarjeta := '';
    evento.codigo := '';
    evento.es := ' ';

    // Arma fecha y hora del evento (Fecha y Hora al momento de generar el evento)
    DecodeTime(Now, hora, min, seg, ms);
    DecodeDate(Now, anio, mes, dia);
    evento.fecha := Format('%2.2d/%2.2d/%4.4d', [dia, mes, anio]);
    evento.hora := Format('%2.2d:%2.2d', [hora, min]);

    Evento_a_Base(evento);      // Almacena el evento en la base de eventos
    Evento_a_Lista(evento);     // Muestra el evento en la lista de eventos on-line
    Evento_a_Imagen(evento);    // Muestra la foto del evento
end;

//------------------------------------------------------------------------------
// INTERROGA Constantes del nodo para realizar operaciones sobre él
//
// OK: rutina eliminada 15-05-2001
//------------------------------------------------------------------------------

{function TComm485.Interroga(nodo : Integer) : Boolean;
begin
   pack_out[1] := nodo;
   pack_out[2] := CMD_INTERROGA;

   if Comando_Nodo then
   begin
       // Rellena las variables del nodo
       with k do
       begin
          BYTESxTARJETA := pack_in[3];
          BYTESxEVENTO := pack_in[4];
          PRIMBANCOTARJETAS := pack_in[5];
          ULTBANCOTARJETAS := pack_in[6];
          PRIMBANCOEVENTOS := pack_in[7];
          ULTBANCOEVENTOS := pack_in[8];
          TARJETASxBANCO := pack_in[9];
          EVENTOSxBANCO := pack_in[10];

          ShowMessage(Format(
             'Bytes x Tarjeta = %d' + #13 +
             'Bytes x Evento = %d' + #13 +
             'Habilitados desde %d hasta %d' + #13 +
             'Eventos desde %d hasta %d' + #13 +
             'Tarjetas x Banco = %d' + #13 +
             'Eventos x Banco = %d',
             [BYTESxTARJETA, BYTESxEVENTO, PRIMBANCOTARJETAS,
             ULTBANCOTARJETAS, PRIMBANCOEVENTOS, ULTBANCOEVENTOS,
             TARJETASxBANCO, EVENTOSxBANCO]));

          Result := True;
       end;
   end
   else Result := False;
   Result := True;
end;}

//------------------------------------------------------------------------------
// RETORNA el Modelo del equipo (Para setear parámetros de comunicación)
//
// OK: 19-05-2001
// Revisión OK: 19-07-2001
//------------------------------------------------------------------------------

function TComm485.Modelo(nodo: Integer; var s: String): Boolean;
begin
   pack_out[1] := nodo;
   pack_out[2] := CMD_MODELO;

   if Comando_Nodo then
   begin
       case pack_in[3] of
         $10: s := 'AWTEC 2001/C';      // Con caducidad
         $20: s := 'AWTEC 2001/CF';     // Con caducidad y franjas
         $30: s := 'AWTEC 2004B/CF';    // Modelo B con caducidad y franjas
         $40: s := 'AWTEC 2004M';       // Modelo M chiquito
       end;

       // Número de versión
       s := s + Format(' v%d.%d.%d.%d', [pack_in[4], pack_in[5], pack_in[7], pack_in[6]]) + Char(pack_in[8]);

       // Setea el tamaño de memoria (127 = 32Kb, 255 = 64Kb)
       {
       if Char(pack_in[8]) = 'S' then UltimoBanco := 127
       else                           UltimoBanco := 255;
       }
       // Recupera el modelo del nodo
       p.ModeloEquipo := Char(pack_in[8]);

       // Establece el tamaño de la memoria
       case p.ModeloEquipo of
         'S':  UltimoBanco := 127;
         'B':  UltimoBanco := 255;
         'M':  UltimoBanco := 127;
       end;  

       // Maneja franjas
       ConFranjas := pack_in[3] in [$20, $30, $40];

       Result := True;
   end
   else
   begin
       s := 'No responde';
       Result := False;
   end;

   // TRAMPA
   {s := 'AWTEC 2001/C' + Format(' v%d.%d.%d.%d', [1, 0, 0, 0]) + Char(0);
   UltimoBanco := 127;
   ConFranjas := True;
   Result := True;}
end;

//------------------------------------------------------------------------------
// REALIZA UNA APERTURA REMOTA en el nodo
//
// OK: 15-05-2001
//------------------------------------------------------------------------------

procedure TComm485.Apertura_Remota(nodo : Integer);
begin
   pack_out[1] := nodo;
   pack_out[2] := CMD_AP_REMOTA;
   if Comando_Nodo then
   begin
      PlayWav('ABRIR');
      Evento_Local('R', nodo);
      FPrincipal.Nod_Status[nodo] := 4;
   end
   else
   begin
      PlayWav('ERR');
      Evento_Local('O', nodo);
      FPrincipal.Nod_Status[nodo] := 1;
   end;
   FPrincipal.ActualizaEstadoNodos(nodo);
end;

//------------------------------------------------------------------------------
// SUBE LAS TARJETAS HABILITADAS en un nodo
//
// OK: 16-05-2001
// Revisión OK: 19-07-2001
// Agregado de transmisión por diferencias: 04-08-2001
// Final por diferencias: 07-08-2001
//
//------------------------------------------------------------------------------

function TComm485.Upload_Tarjetas(nodo: Integer): Boolean;
var
  Tarj_Total, Tarj_Disponibles, p, i, j: Integer;
  n: Integer;
  Nombre_Nodo, s: String;
  habil: THabilitado;
  rel_ok: Boolean;
  d: dato;
  old_ID, new_ID: String;
  qryAux: TQuery;
  //FileHandle: Integer;
  nombre_nuevo, nombre_viejo: String;
  hab_viejos, hab_nuevos, a_grabar: TStringList;
  //f: TextFile;
  //tarjeta: Array[0..9] of Byte;
  //Cant: Longint;
  h: Integer;
  hay_huecos_a_ocupar: Boolean;
  banco, dir: Byte;
  posicion: Integer;
  crc: Integer;
  crc_string: TStringList;
  Hab_viejos_OK: Boolean;
  e: TStatus;

begin
  // Deshabilita eventos online
  hab_online := False;

  //Interrumpe(nodo);

  // Crea una consulta temporal
  qryAux := TQuery.Create(nil);
  qryAux.DatabaseName := 'MIBASE';

  // Crea las listas de habilitados
  hab_viejos := TStringList.Create;
  hab_nuevos := TStringList.Create;
  a_grabar := TStringList.Create;
  crc_string := TStringList.Create;

  // Crea y muestra ventana de progreso de carga de datos
  Application.CreateForm(TFProgreso, FProgreso);
  with FProgreso do begin
     ani.Active := True;
     barra.Progress := 0;
     lbl.Caption := '';
  end;

  try
    // Antes que nada interroga parámetros de almacenamiento en memoria
    // para saber si el nodo está online
    if not Modelo(nodo, s) then
    begin
       PlayWav('ERR');
       Evento_Local('O', nodo);
       Result := False;
       FPrincipal.Nod_Status[nodo] := 1;
       FPrincipal.ActualizaEstadoNodos(nodo);
    end
    else
    begin
        // Bloquea el Nodo
        //Bloqueo(nodo);

        // Consulta las tarjetas a habilitar
        qryAux.SQL.Clear;
        qryAux.SQL.Add('SELECT Usr_tarj, Usr_nom, Usr_cod, Usr_fra, Usr_cad, Usr_susp, Nod_nom, Gf_fra');
        qryAux.SQL.Add('FROM Asignaciones');
        qryAux.SQL.Add('INNER JOIN Nodos ON (Asg_nod = Nod_id)');
        qryAux.SQL.Add('INNER JOIN Usuarios ON (Asg_usr = Usr_id)');
        qryAux.SQL.Add('INNER JOIN GruposFranjas ON (Usr_fra = Gf_num)');
        qryAux.SQL.Add('WHERE Nod_num = :nodo');
        qryAux.SQL.Add('AND Usr_susp = "NO"');
        qryAux.ParambyName('nodo').Value := nodo;
        qryAux.Open;

        // Guarda cantidad de tarjetas y nombre del nodo
        Tarj_Total := qryAux.RecordCount;
        Nombre_Nodo := qryAux.FieldbyName('Nod_nom').AsString;

        // Verifica que la relación habil/ev esté correcta para la cantidad a habilitar
        if Lee_Memoria(nodo, UltimoBanco, $09, 1, d) then
        begin
           Tarj_Disponibles := ((d[0] + 1) * 25);
           rel_ok := Tarj_Disponibles >= Tarj_Total;
        end
        else rel_ok := False;

        // Si la relación no es suficiente para los habilitados a subir, error...
        if not rel_ok then
        begin
          Application.MessageBox('La relación habilitados / eventos no es suficiente'#13'para almacenar las tarjetas habilitadas en el nodo.'#13'Configure correctamente la relación antes de '#13'transmitir la información.', 'Error', MB_OK + MB_ICONEXCLAMATION);
          Result := True;
        end
        else
        begin
          // Asume que se comunicará bien
          Result := True;

          // Muestra ventana de progreso
          FProgreso.Show;

          // Lee ID de última subida y borra las tarjetas habilitadas anteriormente
          Lee_ID_Ultima_Subida(nodo, old_ID);
          Even_Hab(nodo, BORRA, HAB, n);

          // Si no existe la carpeta Temp la crea
          if not DirectoryExists(carpeta + 'Temp\') then CreateDir(carpeta + 'Temp\');

          // Recorre la lista de habilitados y crea la lista de hab_nuevos
          p := 0;
          qryAux.First;
          hab_nuevos.Clear;
          while not qryAux.Eof do
          begin
              // Actualiza ventana de progreso
              FProgreso.lbl.Caption := Format('Recuperando %d de %d tarjetas. ',
                                              [p+1, Tarj_Total]);
              FProgreso.barra.Progress := Trunc((100 * (p+1)) / Tarj_Total);
              Application.ProcessMessages;

              // Setea propiedades del habilitado
              habil.nombre :=    qryAux.FieldbyName('Usr_nom').AsString;
              habil.tarjeta :=   qryAux.FieldbyName('Usr_tarj').AsString;
              habil.codigo :=    qryAux.FieldbyName('Usr_cod').AsString;
              habil.caducidad := qryAux.FieldbyName('Usr_cad').AsString;
              habil.franja :=    qryAux.FieldbyName('Gf_fra').AsInteger - 1;

              // Setea número de tarjeta
              if Length(habil.tarjeta) < 8 then habil.tarjeta := StringOfChar('0', 8-Length(habil.tarjeta)) + habil.tarjeta;
              buffer[0] := (StrtoInt('$' + Copy(habil.tarjeta, 1, 2)));
              buffer[1] := (StrtoInt('$' + Copy(habil.tarjeta, 3, 2)));
              buffer[2] := (StrtoInt('$' + Copy(habil.tarjeta, 5, 2)));
              buffer[3] := (StrtoInt('$' + Copy(habil.tarjeta, 7, 2)));

              // Setea número de código
              buffer[4] := (StrtoInt('$' + Copy(habil.codigo, 1, 2)));
              buffer[5] := (StrtoInt('$' + Copy(habil.codigo, 3, 2)));

              // Setea fecha de caducidad
              buffer[6] := StrtoInt(Copy(habil.caducidad, 2, 2));
              if Copy(habil.caducidad, 1, 1) = 'S' then buffer[6] := buffer[6] or $80;
              buffer[7] := StrtoInt(Copy(habil.caducidad, 5, 2)) * 16 +
                      StrtoInt(Copy(habil.caducidad, 10, 2));

              // Setea número de franja
              buffer[8] := (habil.franja) and $0F;        // nibble alto reservado
              buffer[9] := 0;                             // Reservado

              // Agrega el habilitado a la lista hab_nuevos
              hab_nuevos.Add(Format('%2.2X%2.2X%2.2X%2.2X%2.2X%2.2X%2.2X%2.2X%2.2X%2.2X',
                             [buffer[0], buffer[1], buffer[2], buffer[3], buffer[4],
                              buffer[5], buffer[6], buffer[7], buffer[8], buffer[9]]));

              inc(p);
              qryAux.Next;
          end;

          // Si existe el archivo de hab anterior, lo carga y crea lista de diferencias
          nombre_viejo := carpeta + 'Temp\' + old_ID + '.dat';

          // Primero chequea que el archivo viejo exista y no esté corrupto
          if FileExists(nombre_viejo) and
             FileExists(nombre_viejo + '.crc') then
          begin
             // Llena la lista con las tarjetas viejas
             hab_viejos.Clear;
             hab_viejos.LoadFromFile(nombre_viejo);

             // Calcula el crc de la lista de habilitados viejos
             crc := 0;
             for i:=0 to hab_viejos.Count-1 do
             begin
                for j:=1 to Length(hab_viejos.Strings[i]) do
                   crc := crc xor Ord(hab_viejos.Strings[i][j]);
             end;

             // Carga crc grabado
             crc_string.Clear;
             crc_string.LoadFromFile(nombre_viejo + '.crc');

             try
                // Si el crc es el mismo que el grabado, todo OK
                Hab_viejos_OK := (crc = StrtoInt(crc_string.Strings[0]));
             except
                Hab_viejos_OK := False;
             end;
          end
          else Hab_viejos_OK := False;

          // Si está corrupto lo borra (si existe)
          if not Hab_viejos_OK then
          begin
             if FileExists(nombre_viejo) then DeleteFile(nombre_viejo);
             if FileExists(nombre_viejo + '.crc') then DeleteFile(nombre_viejo + '.crc');
          end;

          // Si el archivo de habilitados viejos está OK, arma lista de diferencias
          // Sólo habilita diferencias cuando está seteado así, sino sube normalmente todos
          if (Hab_viejos_OK) and (ReadReg_I('ModoSubida') = 1) then
          begin
             // Llena la lista con las tarjetas viejas
             hab_viejos.Clear;
             hab_viejos.LoadFromFile(nombre_viejo);

             // PRUEBA
             {Application.CreateForm(TFHab, FHab);
             FHab.ShowModal;
             hab_viejos.Clear;
             hab_viejos.AddStrings(FHab.Memo1.Lines);
             hab_nuevos.Clear;
             hab_nuevos.AddStrings(FHab.Memo2.Lines);
             FHab.Release;}

             // Recorre la lista de hab viejos y marca los huecos de tarjetas que ya no están
             for i:=0 to hab_viejos.Count-1 do
             begin
                if hab_nuevos.IndexOf(hab_viejos.Strings[i]) = -1 then
                   hab_viejos.Strings[i] := '';
             end;

             // Recorre la lista de hab nuevos y busca las tarjetas que antes no estaban
             a_grabar.Clear;
             for i:=0 to hab_nuevos.Count-1 do
             begin
                // Si alguna tarjeta, no estaba, busca el lugar donde ponerla
                if hab_viejos.IndexOf(hab_nuevos.Strings[i]) = -1 then
                begin
                   // Si quedan huecos lo pone en ese lugar
                   h := hab_viejos.IndexOf('');
                   if h > -1 then
                   begin
                      a_grabar.Add(hab_nuevos.Strings[i] + ',' + InttoStr(h));
                      hab_viejos.Strings[h] := hab_nuevos.Strings[i];
                   end

                   // Si no hay más huecos, lo agrega al final de los habilitados
                   else
                   begin
                      a_grabar.Add(hab_nuevos.Strings[i] + ',' + InttoStr(hab_viejos.Count));
                      hab_viejos.Add(hab_nuevos.Strings[i]);
                   end;
                end;
             end;

             // Si después de crear la lista a habilitar, todavía quedan huecos...
             if hab_viejos.IndexOf('') <> -1 then
             begin
                repeat
                  if hab_viejos.IndexOf('') = -1 then hay_huecos_a_ocupar := False
                  else
                  begin
                     // Busca de atrás hacia adelante un hueco libre
                     hay_huecos_a_ocupar := True;
                     for i:=hab_viejos.IndexOf('') to hab_viejos.Count-1 do
                     begin
                        hay_huecos_a_ocupar := False;
                        if hab_viejos.Strings[i] <> '' then
                        begin
                           hay_huecos_a_ocupar := True;
                           break;
                        end;
                     end;

                     // Si hay alguno, lo llena con la última tarjeta de la lista
                     if hay_huecos_a_ocupar then
                     begin
                        for i:=hab_viejos.Count-1 downto 0 do
                           if hab_viejos.Strings[i] <> '' then break;

                        h := hab_viejos.IndexOf('');
                        hab_viejos.Strings[h] := hab_viejos.Strings[i];
                        a_grabar.Add(hab_viejos.Strings[i] + ',' + InttoStr(h));
                        hab_viejos.Strings[i] := '';
                     end;
                  end;
                until not hay_huecos_a_ocupar;
             end;

             // En hab_viejos queda la lista de habilitados que quedará en el nodo
             // ordenados. (Solo se deben borrar los posibles huecos que quedaran al final)
             while hab_viejos.Strings[hab_viejos.Count-1] = '' do
                hab_viejos.Delete(hab_viejos.Count-1);

             {s := '';
             for i:=0 to hab_viejos.Count-1 do s := s + hab_viejos.Strings[i] + #13;
             ShowMessage(s);
             s := '';
             for i:=0 to hab_nuevos.Count-1 do s := s + hab_nuevos.Strings[i] + #13;
             ShowMessage(s);}

             // Chequea que la lista esté equilibrada
             if hab_viejos.Count <> hab_nuevos.Count then
             begin
                Result := False;

                Application.MessageBox(PChar('Error equilibrando listas. Debe haber tarjetas repetidas'#13#10 +
                                       'Por favor repita la operación de carga de habilitados'),
                                       'Error', MB_OK + MB_ICONERROR);

                // Borra archivo viejo de imagen
                if FileExists(nombre_viejo) then DeleteFile(nombre_viejo);
                if FileExists(nombre_viejo + '.crc') then DeleteFile(nombre_viejo + '.crc');

             end
             else
             begin
               // Luego de esto queda la lista con los valores a grabar y en que posición
               //ShowMessage(a_grabar.Text);

               // Graba archivo de subida
               //a_grabar.SaveToFile(carpeta + 'Temp\subida.dat');

               // Graba las diferencias en el nodo
               p := 0;
               while p < a_grabar.Count do
               begin
                  // Actualiza ventana de progreso
                  FProgreso.lbl.Caption := Format('Cargando %d de %d tarjetas en %s.',
                                           [p+1, a_grabar.Count, Nombre_Nodo]);
                  FProgreso.barra.Progress := Trunc((100 * (p+1)) / a_grabar.Count);
                  Application.ProcessMessages;

                  // Calcula posición en memoria de tarjeta a habilitar
                  // posición = 0..n
                  posicion := StrtoInt(Copy(a_grabar.Strings[p], Pos(',', a_grabar.Strings[p])+1, Length(a_grabar.Strings[p])));
                  banco := posicion div 25;               {25 = Cant Hab x Banco}
                  dir := (posicion mod 25) * 10;          {10 = bytes x Hab}

                  // Setea número de tarjeta
                  d[3] := (StrtoInt('$' + Copy(a_grabar.Strings[p], 1, 2)));
                  d[2] := (StrtoInt('$' + Copy(a_grabar.Strings[p], 3, 2)));
                  d[1] := (StrtoInt('$' + Copy(a_grabar.Strings[p], 5, 2)));
                  d[0] := (StrtoInt('$' + Copy(a_grabar.Strings[p], 7, 2)));

                  // Setea número de código
                  d[4] := (StrtoInt('$' + Copy(a_grabar.Strings[p], 9, 2)));
                  d[5] := (StrtoInt('$' + Copy(a_grabar.Strings[p], 11, 2)));

                  // Setea fecha de caducidad
                  d[6] := (StrtoInt('$' + Copy(a_grabar.Strings[p], 13, 2)));
                  d[7] := (StrtoInt('$' + Copy(a_grabar.Strings[p], 15, 2)));

                  // Setea número de franja
                  d[8] := (StrtoInt('$' + Copy(a_grabar.Strings[p], 17, 2)));
                  d[9] := (StrtoInt('$' + Copy(a_grabar.Strings[p], 19, 2)));

                  // Graba bytes en memoria
                  Result := True;

                  // Sube las tarjetas una a una al nodo
                  if Escribe_Memoria(nodo, banco, dir, 10, d) then
                  begin
                     inc(p);     // Próxima posición en memoria
                  end
                  else
                  begin
                      FProgreso.ani.Active := False;

                      // Si se para por un error pregunta si sigue desde ahi
                      if Application.MessageBox(PChar('Error subiendo habilitados a nodo ' + Nombre_nodo + '. Seguir transmitiendo?'), 'Pregunta', MB_YESNO + MB_ICONQUESTION) = ID_NO then
                      begin
                          // Detiene la subida de habilitados
                          Result := False;
                          break;
                      end;

                      FProgreso.ani.Active := True;
                  end;
               end;
             end;

             // Si grabó bien las diferencias, crea archivo con contenido actual ordenado
             if Result then
             begin
                // Crea archivo de habilitados nuevo
                // (la lista hab_viejos contiene la lista actualizada y ordenada)
                new_ID := Format('%2.2x%2.2x%2.2x%2.2x', [Random($FF), Random($FF), Random($FF), Random($FF)]);
                nombre_nuevo := carpeta + 'Temp\' + new_id + '.dat';
                hab_viejos.SaveToFile(nombre_nuevo);
                // Graba archivo de crc de la lista
                crc := 0;
                for i:=0 to hab_viejos.Count-1 do
                begin
                   for j:=1 to Length(hab_viejos.Strings[i]) do
                      crc := crc xor Ord(hab_viejos.Strings[i][j]);
                end;
                crc_string.Clear;
                crc_string.Add(InttoStr(crc));
                crc_string.SaveToFile(nombre_nuevo + '.crc');
             end;
          end

          // Si no existe archivo anterior, o está corrupto, realiza grabación normal
          else
          begin
            // Recorre todas las tarjetas a habilitar
            p := 0;
            qryAux.First;
            while not qryAux.Eof do
            begin
                // Actualiza ventana de progreso
                FProgreso.lbl.Caption := Format('Cargando %d de %d tarjetas en %s. [%s (%s)]. ',
                                         [p+1, Tarj_Total, Nombre_Nodo, habil.nombre, habil.tarjeta]);
                FProgreso.barra.Progress := Trunc((100 * (p+1)) / Tarj_Total);
                Application.ProcessMessages;

                // Setea propiedades del habilitado
                habil.nombre :=    qryAux.FieldbyName('Usr_nom').AsString;
                habil.tarjeta :=   qryAux.FieldbyName('Usr_tarj').AsString;
                habil.codigo :=    qryAux.FieldbyName('Usr_cod').AsString;
                habil.caducidad := qryAux.FieldbyName('Usr_cad').AsString;
                habil.franja :=    qryAux.FieldbyName('Gf_fra').AsInteger - 1;

                // Sube las tarjetas una a una al nodo
                if Hab_Tarjeta(nodo, p, habil) then
                begin
                   inc(p);     // Próxima posición en memoria
                   qryAux.Next;  // Próxima tarjeta de la base de habilitados
                end
                else
                begin
                    FProgreso.ani.Active := False;

                    // Si se para por un error pregunta si sigue desde ahi
                    if Application.MessageBox(PChar('Error subiendo habilitados a nodo ' + Nombre_nodo + '. Seguir transmitiendo?'), 'Pregunta', MB_YESNO + MB_ICONQUESTION) = ID_NO then
                    begin
                        // Detiene la subida de habilitados
                        Result := False;
                        break;
                    end
                    else ; //Interrumpe(nodo);

                    FProgreso.ani.Active := True;
                end;
            end;

            // Si grabó bien las tarjetas, crea archivo con contenido actual ordenado
            if Result then
            begin
              new_ID := Format('%2.2x%2.2x%2.2x%2.2x', [Random($FF), Random($FF), Random($FF), Random($FF)]);
              nombre_nuevo := carpeta + 'Temp\' + new_id + '.dat';
              hab_nuevos.SaveToFile(nombre_nuevo);
              // Graba archivo de crc de la lista
              crc := 0;
              for i:=0 to hab_nuevos.Count-1 do
              begin
                 for j:=1 to Length(hab_nuevos.Strings[i]) do
                    crc := crc xor Ord(hab_nuevos.Strings[i][j]);
              end;
              crc_string.Clear;
              crc_string.Add(InttoStr(crc));
              crc_string.SaveToFile(nombre_nuevo + '.crc');
            end;
          end;

          // Si subió bien los habilitados, setea cantidad en el nodo
          if Result then
          begin
             // Actualiza ventana de progreso
             FProgreso.lbl.Caption := Format('Configurando %d cantidad de tarjetas en %s. ',
                                      [Tarj_Total, Nombre_Nodo]);
             Application.ProcessMessages;

             // Obtiene cantidad de tarjetas anterior
             Result := Even_Hab(nodo, LEE, HAB, n);

             // Si es diferente a la cantidad actual, lo graba
             if Result and (Tarj_Total <> n) then
             begin
               // Borra todas las tarjetas habilitadas
               if Tarj_Total = 0 then Result := Result and Even_Hab(nodo, BORRA, HAB, n)
               // Setea la cantidad de tarjetas habilitadas
               else                   Result := Result and Set_Cant_Hab(nodo, Tarj_Total);
             end;
             
             // Graba ID de última subida al nodo
             Result := Result and Escribe_ID_Ultima_Subida(nodo, new_ID);

             // Borra archivo viejo de imagen
             if FileExists(nombre_viejo) then DeleteFile(nombre_viejo);
             if FileExists(nombre_viejo + '.crc') then DeleteFile(nombre_viejo + '.crc');

             Sleep(500);
          end;
        end;

        // Cierra consulta de habilitados
        qryAux.Close;

        // Reproduce WAV acorde a la operación
        if Result then PlayWav('INFO') else PlayWav('ERR');

        // Genera evento local
        if Result then Evento_Local('S', nodo)
        else           Evento_Local('O', nodo);

        // Actualiza ícono del nodo
        if Result then FPrincipal.Nod_Status[nodo] := 5
        else           FPrincipal.Nod_Status[nodo] := 1;
        FPrincipal.ActualizaEstadoNodos(nodo);

        // Desbloquea el Nodo
        //Bloqueo(nodo);
    end;

  finally
    // Destruye consulta temporal
    FreeAndNil(qryAux);

    // Destruye las lista de habilitados
    hab_viejos.Free;
    hab_nuevos.Free;
    a_grabar.Free;
    crc_string.Free;

    // Destruye ventana de progreso
    FProgreso.Release;
  end;
  // Vuelve a habilitar los eventos online
  hab_online := True;
end;

//------------------------------------------------------------------------------
// COMPARA las tarjetas del nodo con las de la base
//
// Inicio: 07-08-2001
//
//------------------------------------------------------------------------------

function TComm485.Compara_Tarjetas(nodo: Integer): Boolean;
var
  Tarj_Total, p: Integer;
  Nombre_Nodo, s: String;
  habil: THabilitado;
  d: dato;
  qryAux: TQuery;
  banco, dir: Byte;
  posicion: Integer;
  Cant: Integer;
  hab_viejos: TStringList;
  hab_nodo: TStringList;

begin
  // Deshabilita eventos online
  hab_online := False;

  // Crea una consulta temporal
  qryAux := TQuery.Create(nil);
  qryAux.DatabaseName := 'MIBASE';

  // Crea las listas de habilitados
  hab_viejos := TStringList.Create;
  hab_nodo := TStringList.Create;

  // Crea ventana de progreso de carga de datos
  Application.CreateForm(TFProgreso, FProgreso);
  with FProgreso do begin
     ani.Active := True;
     barra.Progress := 0;
     lbl.Caption := '';
  end;

  try
    // Antes que nada interroga parámetros de almacenamiento en memoria
    // para saber si el nodo está online
    if not Modelo(nodo, s) then
    begin
       PlayWav('ERR');
       Evento_Local('O', nodo);
       Result := False;
    end
    else
    begin
        // Consulta las tarjetas que deberían estar habilitadas en el nodo
        qryAux.SQL.Clear;
        qryAux.SQL.Add('SELECT Usr_tarj, Usr_nom, Usr_cod, Usr_fra, Usr_cad, Usr_susp, Nod_nom, Gf_fra');
        qryAux.SQL.Add('FROM Asignaciones');
        qryAux.SQL.Add('INNER JOIN Nodos ON (Asg_nod = Nod_id)');
        qryAux.SQL.Add('INNER JOIN Usuarios ON (Asg_usr = Usr_id)');
        qryAux.SQL.Add('INNER JOIN GruposFranjas ON (Usr_fra = Gf_num)');
        qryAux.SQL.Add('WHERE Nod_num = :nodo');
        qryAux.SQL.Add('AND Usr_susp = "NO"');
        qryAux.ParambyName('nodo').Value := nodo;
        qryAux.Open;

        // Guarda cantidad de tarjetas y nombre del nodo
        Tarj_Total := qryAux.RecordCount;
        Nombre_Nodo := qryAux.FieldbyName('Nod_nom').AsString;

        // Asume que se comunicará bien
        Result := True;

        // Muestra ventana de progreso
        FProgreso.Show;

        // Recorre la lista de habilitados y crea la lista de hab_nuevos
        p := 0;
        qryAux.First;
        hab_viejos.Clear;
        while not qryAux.Eof do
        begin
            // Actualiza ventana de progreso
            FProgreso.lbl.Caption := Format('Recuperando %d de %d tarjetas. ',
                                            [p+1, Tarj_Total]);
            FProgreso.barra.Progress := Trunc((100 * (p+1)) / Tarj_Total);
            Application.ProcessMessages;

            // Setea propiedades del habilitado
            habil.nombre :=    qryAux.FieldbyName('Usr_nom').AsString;
            habil.tarjeta :=   qryAux.FieldbyName('Usr_tarj').AsString;
            habil.codigo :=    qryAux.FieldbyName('Usr_cod').AsString;
            habil.caducidad := qryAux.FieldbyName('Usr_cad').AsString;
            habil.franja :=    qryAux.FieldbyName('Gf_fra').AsInteger - 1;

            // Setea número de tarjeta
            if Length(habil.tarjeta) < 8 then habil.tarjeta := StringOfChar('0', 8-Length(habil.tarjeta)) + habil.tarjeta;
            buffer[0] := (StrtoInt('$' + Copy(habil.tarjeta, 1, 2)));
            buffer[1] := (StrtoInt('$' + Copy(habil.tarjeta, 3, 2)));
            buffer[2] := (StrtoInt('$' + Copy(habil.tarjeta, 5, 2)));
            buffer[3] := (StrtoInt('$' + Copy(habil.tarjeta, 7, 2)));

            // Setea número de código
            buffer[4] := (StrtoInt('$' + Copy(habil.codigo, 1, 2)));
            buffer[5] := (StrtoInt('$' + Copy(habil.codigo, 3, 2)));

            // Setea fecha de caducidad
            buffer[6] := StrtoInt(Copy(habil.caducidad, 2, 2));
            if Copy(habil.caducidad, 1, 1) = 'S' then buffer[6] := buffer[6] or $80;
            buffer[7] := StrtoInt(Copy(habil.caducidad, 5, 2)) * 16 +
                    StrtoInt(Copy(habil.caducidad, 10, 2));

            // Setea número de franja
            buffer[8] := (habil.franja) and $0F;        // nibble alto reservado
            buffer[9] := 0;                             // Reservado

            // Agrega el habilitado a la lista hab_nuevos
            hab_viejos.Add(Format('%2.2X%2.2X%2.2X%2.2X%2.2X%2.2X%2.2X%2.2X%2.2X%2.2X',
                           [buffer[0], buffer[1], buffer[2], buffer[3], buffer[4],
                            buffer[5], buffer[6], buffer[7], buffer[8], buffer[9]]));

            inc(p);
            qryAux.Next;
        end;
        qryAux.Close;
        FreeAndNil(qryAux);

        // Lee cantidad de habilitados del nodo
        Even_Hab(nodo, LEE, HAB, Cant);

        if hab_viejos.Count <> Cant then Result := False
        else
        begin
          // Recorre los habilitados del nodo y los va borrando de la lista si los encuentra
          hab_nodo.Clear;
          FProgreso.barra.Progress := 0;
          FProgreso.lbl.Caption := '';
          for posicion:=0 to Cant-1 do
          begin
              // Actualiza ventana de progreso
              FProgreso.lbl.Caption := Format('Comparando tarjeta %d de %d', [posicion+1, Cant]);

              FProgreso.barra.Progress := Trunc(((posicion+1)*100) div Cant);
              Application.ProcessMessages;

              // Calcula posición en memoria de tarjeta a leer
              // posición = 0..n
              banco := posicion div 25;               {25 = Cant Hab x Banco}
              dir := (posicion mod 25) * 10;          {10 = bytes x Hab}

              Lee_Memoria(nodo, banco, dir, 10, d);

              s := Format('%2.2X%2.2X%2.2X%2.2X%2.2X%2.2X%2.2X%2.2X%2.2X%2.2X',
                          [d[3], d[2], d[1], d[0], d[4], d[5], d[6], d[7], d[8], d[9]]);
              hab_nodo.Add(s);

              // Va borrando de la lista las tarjetas encontradas
              if hab_viejos.IndexOf(s) <> -1 then
              begin
                 hab_viejos.Delete(hab_viejos.IndexOf(s));
              end;
          end;

          // Crea archivo con habilitados del nodo
          if not DirectoryExists(carpeta + 'Temp\') then CreateDir(carpeta + 'Temp\');
          //hab_nodo.SaveToFile(carpeta + 'Temp\hab_nodo.dat');

          // Si se encontraron todas las tarjetas OK, sino, error
          Result := (hab_viejos.Count = 0);
        end;

        // Reproduce WAV acorde a la operación
        if Result then PlayWav('INFO') else PlayWav('ERR');
    end;

  finally
    // Destruye las lista de habilitados
    hab_viejos.Free;
    hab_nodo.Free;

    // Destruye ventana de progreso
    FProgreso.Release;
  end;

  // Vuelve a habilitar los eventos online
  hab_online := True;
end;

//------------------------------------------------------------------------------
// DESCARGA TODOS LOS EVENTOS de un nodo
//
// OK: 16-05-2001
// Agregado de relación de hab/ev para leer 19-07-2001
//------------------------------------------------------------------------------

function TComm485.Download_Ev(nodo: Integer) : Boolean;
var
   Cant_Eventos, Ev_Actual: Integer;
   evento: TEvento;
   n1: Integer;
   Lista: Boolean;
   Nombre_Nodo, s: String;
   d: dato;
begin
  // Deshabilita eventos online
  hab_online := False;

  // Crea la tabla temporal de eventos
  memEventos := TkbmMemTable.Create(nil);
  with memEventos.FieldDefs do
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
  end;
  memEventos.CreateTable;
  memEventos.Open;

  //Interrumpe(nodo);

  // Antes que nada interroga parámetros de almacenamiento en memoria
  if not p.Modelo(nodo, s) then
  begin
     PlayWav('ERR');
     Evento_Local('O', nodo);
     Result := False;
     FPrincipal.Nod_Status[nodo] := 1;
     FPrincipal.ActualizaEstadoNodos(nodo);
  end
  else
  begin
     // Bloquea el Nodo
     //Bloqueo(nodo);

     // Consulta el nombre del nodo a bajar sus eventos
     with FCom.Consulta do
     begin
        SQL.Text := 'SELECT Nod_nom FROM Nodos WHERE Nod_num = ' + InttoStr(nodo);
        Open;
        if RecordCount = 0 then Nombre_Nodo := 'Desconocido'
        else                    Nombre_Nodo := FieldbyName('Nod_nom').AsString;
        Close;
     end;

     // Inicializa ventana de progreso
     Application.CreateForm(TFProgreso, FProgreso);
     with FProgreso do
     begin
         ani.Active := True;
         barra.Progress := 0;
         lbl.Caption := Format('Obteniendo cantidad de eventos a bajar de %s', [Nombre_Nodo]);
         Show;
     end;

     // Obtiene cantidad de eventos almacenados en el nodo
     if not Even_Hab(nodo, LEE, EV, Cant_Eventos) then
     begin
        FProgreso.ani.Active := False;
        FProgreso.lbl.Caption := Format('No se pudo obtener cantidad de eventos de %s', [Nombre_Nodo]);
        Application.ProcessMessages;
        Sleep(1500);
        Result := False;
     end
     else
     begin
        // Baja eventos solamente si hay alguno
        if Cant_Eventos = 0 then
        begin
           FProgreso.ani.Active := False;
           FProgreso.lbl.Caption := Format('No hay ningún evento en %s', [Nombre_Nodo]);
           Application.ProcessMessages;
           Sleep(1500);
           Result := True;
        end
        else
        begin
            // Chequea si debe bajar mostrando en la lista
            Lista := (ReadReg_I('MuestraEv') = 1);

            // Recupera del nodo el banco inicial de los eventos para recuperar eventos
            // Corrección 13/03/2004 - Toma el banco donde está la relación de eventos/habilitados
            // Corrección 13/03/2004 - En modelo M, la relación ev/hab es fija
            if p.ModeloEquipo <> 'M' then
            begin
              //Lee_Memoria(nodo, $7F, DIR_RELAC, 1, d);
              Lee_Memoria(nodo, UltimoBanco, DIR_RELAC, 1, d);
              PrimerBancoEventos := d[0] + 1;
            end
            else
              PrimerBancoEventos := 40;

            // Asume bajada OK
            Result := True;

            // Recorre todos los eventos y los baja
            Ev_Actual:=0;
            while (Ev_Actual < Cant_Eventos) do
            begin
               // Actualiza ventana de progreso
               FProgreso.lbl.Caption := Format('Descargando %d de %d eventos de %s.', [Ev_Actual+1, Cant_Eventos, Nombre_Nodo]);
               FProgreso.barra.Progress := Trunc((100 * (Ev_Actual+1)) / Cant_Eventos);
               Application.ProcessMessages;

               // Lee uno a uno los eventos
               if Get_Evento(nodo, Ev_Actual, evento) then
               begin
                  // Corrección 06/05/2003 - Sólo procesa el evento si tiene el tipo correcto
                  if evento.tipo in ['A', 'I', 'C', 'F', 'P', 'T', 'U'] then
                  begin
                    with FCom.Consulta do
                    begin
                       // Busca nombre de la persona de esa tarjeta
                       SQL.Text := 'SELECT Usr_nom FROM Usuarios WHERE Usr_tarj = "' + evento.tarjeta + '"';
                       Open;
                       if RecordCount = 0 then evento.nombre := 'Desconocido'
                       else                    evento.nombre := FieldbyName('Usr_nom').AsString;
                       evento.mensaje := evento.nombre;
                       Close;

                       // Setea nombre del nodo
                       evento.nodo := Nombre_Nodo;

                       // Genera un nuevo evento en la tabla de memoria
                       Evento_a_tabla_memoria(evento);
                       // Muestra el evento en la lista on-line
                       if Lista then Evento_a_Lista(evento);
                    end;
                  end;

                  //Sleep(2);                // Tiempo entre paquetes
                  inc(Ev_Actual);          // Próximo evento a bajar
               end

               // Si no pudo bajar el evento...
               else
               begin
                    FProgreso.ani.Active := False;

                    // Pregunta si sigue desde ahi
                    if Application.MessageBox('Error de Comunicación. '#13'Sigue bajando?', 'Pregunta', MB_YESNO + MB_ICONQUESTION) = ID_NO then
                    begin
                         // Detiene la bajada de eventos con error
                         Result := False;
                         break;
                    end
                    else ; //Interrumpe(nodo);

                    FProgreso.ani.Active := True;
               end;
            end;

            // Si la descarga fue exitosa, borra eventos en nodo si está configurado
            if Result and (ReadReg_I('BorraEv') = 1) then
            begin
              FProgreso.lbl.Caption := Format('Borrando eventos', []);
              Application.ProcessMessages;
              Sleep(500);
              Result := Even_Hab(nodo, BORRA, EV, n1);
            end;

            // Si todo bien, copia los eventos bajados a la base y al archivo si hace falta
            if Result then
            begin
              // Y finalmente agrega todos los eventos bajados a la base y el archivo
              FProgreso.lbl.Caption := Format('Agregando eventos a la base', []);
              Ev_actual := 1;
              Cant_Eventos := memEventos.RecordCount;
              memEventos.First;
              while not memEventos.Eof do
              begin
                 // Actualiza ventana de progreso
                 FProgreso.lbl.Caption := Format('Agregando %d de %d eventos de %s.', [Ev_Actual+1, Cant_Eventos, Nombre_Nodo]);
                 FProgreso.barra.Progress := Trunc((100 * (Ev_Actual+1)) / Cant_Eventos);
                 Application.ProcessMessages;

                 evento.numnodo := nodo;
                 evento.tipo := memEventos.FieldbyName('Ev_tipo').AsString[1];
                 evento.nodo := memEventos['Ev_nod'];
                 evento.nombre := memEventos['Ev_pers'];
                 evento.tarjeta := memEventos['Ev_tarj'];
                 evento.codigo := memEventos['Ev_cod'];
                 evento.fecha := memEventos['Ev_fecha'];
                 evento.hora := memEventos['Ev_hora'];
                 evento.es := memEventos.FieldbyName('Ev_es').AsString[1];

                 // Almacena el evento en la base de eventos
                 Evento_a_Base(evento);
                 // Agrega evento al archivo de texto
                 Evento_a_Texto(evento);

                 inc(Ev_Actual);
                 memEventos.Next;
              end;
            end;
        end;
     end;

     // Destruye ventana de progreso
     FProgreso.Free;

     // Reproduce WAV acorde a la operación
     if Result then PlayWav('INFO') else PlayWav('ERR');

     // Genera evento según resultado de la operación
     if Result then Evento_Local('B', nodo) else Evento_Local('O', nodo);

     // Actualiza ícono del nodo
     if Result then FPrincipal.Nod_Status[nodo] := 5
     else           FPrincipal.Nod_Status[nodo] := 1;
     FPrincipal.ActualizaEstadoNodos(nodo);

     // Desbloquea el Nodo
     //Bloqueo(nodo);
  end;

  // Vuelve a habilitar los eventos online
  hab_online := True;

  // Destruye la tabla de memoria
  memEventos.Close;
  FreeAndNil(memEventos);
end;

//------------------------------------------------------------------------------
// SUBE LAS FRANJAS a un nodo
//
// OK: 16-05-2001
// Correcciones: 20-07-2001
//------------------------------------------------------------------------------

function TComm485.Upload_Franjas(nodo : Integer) : Boolean;
type
  Array_Franjas = Array[0..47] of Byte;
var
  franja, paquete: Integer;
  Nombre, Datos, Nombre_Nodo: String;
  Franja_OK: Boolean;
  pos, banco, dir: Integer;
  //bytes: Array[0..47] of Byte;   // 48 bytes x franja
  //b: Integer;
  s: String;
  //archivo: TextFile;
  d: dato;
  //x, y: Integer;
  franjas: Array_Franjas;
  MAX: Integer;

// Convierte la cadena de franja en array de bytes a grabar
procedure StrToArray(s: String; var f: Array_Franjas);
var
   pos: Integer;
begin
   // Recorre los 192 caracteres de la cadena
   pos := 0;
   while pos <= 191 do
   begin
     f[pos div 4] := (StrtoInt(s[(pos div 4) * 4 + 1]) shl 6) +
                     (StrtoInt(s[(pos div 4) * 4 + 2]) shl 4) +
                     (StrtoInt(s[(pos div 4) * 4 + 3]) shl 2) +
                     (StrtoInt(s[(pos div 4) * 4 + 4]) shl 0);
     pos := pos + 4;
   end;
end;

// Convierte el array en binario a representación binaria string
function ArrayToStr(d: dato): String;
var
   s: String;
   x, y: Integer;
begin
   s := '';

   for x:=0 to 7 do
   begin
      for y:=7 downto 0 do
      begin
         if ((d[x] shr y) and $01) = $01 then s := s + '1'
         else                                 s := s + '0';
      end;
   end;

   Result := s;
end;

begin
  // Deshabilita eventos online
  hab_online := False;

  //Interrumpe(nodo);

  with FCom.Consulta do
  begin
    // Guarda nombre del nodo
    SQL.Text := 'SELECT Nod_nom FROM Nodos WHERE Nod_num = :nodo';
    ParambyName('nodo').AsInteger := nodo;
    Open;
    Nombre_Nodo := FieldbyName('Nod_nom').AsString;
    Close;
  end;

  // Antes que nada interroga parámetros de almacenamiento en memoria
  if not p.Modelo(nodo, s) then
  begin
     Application.MessageBox(PChar('Error recuperando estado de nodo ' + Nombre_Nodo), 'Atención', MB_OK + MB_ICONERROR);
     Result := False;
  end
  else
  begin
    // Si el nodo trabaja con franjas, las transmite, si no, no hace nada y retorna OK
    if not ConFranjas then
    begin
       Result := True;
    end
    else
    begin
      // Consulta las franjas a transmitir
      with FCom.Consulta do
      begin
        // Selecciona todas las franjas
        SQL.Text := 'SELECT * FROM Franjas';
        Open;

        // Asume que se comunicará bien
        Result := True;

        // Posición actual de franjas = 1
        franja := 1;

        // Corrección 05/08/2003
        // En modo descargador sólo sube 3 franjas
        if llave.modofull then MAX := 16
        else                   MAX := 3;

        // Crea y muestra ventana de progreso de carga de datos
        Application.CreateForm(TFProgreso, FProgreso);
        with FProgreso do
        begin
           ani.Active := True;
           barra.Progress := 0;
           lbl.Caption := '';
           Show;
        end;

        // Recorre todas las franjas a subir
        while (not Eof) and (franja <= MAX) do
        begin
            // Recupera nombre y datos de la franja a subir
            Nombre := FieldbyName('Fr_nom').AsString;
            Datos := FieldbyName('Fr_dat').AsString;

            // Actualiza ventana de progreso
            FProgreso.lbl.Caption := Format('Cargando %d de %d franjas en %s.', [franja, MAX, Nombre_Nodo]);
            FProgreso.barra.Progress := Trunc((100 * franja) / MAX);
            Application.ProcessMessages;

            // Arma paquete de bytes a grabar de la franja actual
            StrToArray(Datos, franjas);

            Franja_OK := True;

            // Sube una franja (en 6 partes)
            for paquete := 1 to 6 do
            begin
               pos := ((franja-1)*48)+((paquete-1)*8);
               banco := (pos div 256)+(UltimoBanco-3);
               dir := pos mod 256;

               d[0] := franjas[(paquete-1)*8];
               d[1] := franjas[(paquete-1)*8+1];
               d[2] := franjas[(paquete-1)*8+2];
               d[3] := franjas[(paquete-1)*8+3];
               d[4] := franjas[(paquete-1)*8+4];
               d[5] := franjas[(paquete-1)*8+5];
               d[6] := franjas[(paquete-1)*8+6];
               d[7] := franjas[(paquete-1)*8+7];
               Franja_OK := Franja_OK and Escribe_Memoria(nodo, banco, dir, 8, d);
            end;

            // Si subió bien la franja...
            if Franja_OK then
            begin
               inc(franja);  // Próxima franja
               Next;         // Próxima franja de la base de franjas
            end
            else
            begin
                FProgreso.ani.Active := False;

                // Corrección 05/08/2003
                // Al mostrar el mensaje siguiente quedaba atrás de la ventana de progreso
                FProgreso.Hide;

                // Si se para por un error pregunta si sigue desde ahi
                if Application.MessageBox(PChar('Error subiendo franjas a nodo ' + Nombre_Nodo + '. Seguir transmitiendo?'), 'Pregunta', MB_YESNO + MB_ICONQUESTION) = ID_NO then
                begin
                    // Detiene la subida de franjas
                    Result := False;
                    break;
                end
                else ; //Interrumpe(nodo);

                FProgreso.ani.Active := True;

                // Corrección 05/08/2003 - Luego vuelve a mostrar la ventana de progreso
                FProgreso.Show;
            end;
        end;

        // Cierra consulta
        Close;
        // Destruye ventana de progreso
        FProgreso.Free;

        // Muestra mensaje de error
        if not Result then
           Application.MessageBox(PChar('Error subiendo franjas a nodo ' + Nombre_Nodo), 'Atención', MB_OK);
      end;
    end;

    // Escribe archivo con franjas leídas del nodo
    {if False then
    begin
      AssignFile(archivo, carpeta + 'Franjas.dat');
      ReWrite(archivo);

      b := 0;
      s := '';
      while b <= 767 do
      begin
         banco := (b div 256) + (UltimoBanco-3);
         dir := b mod 256;

         Lee_Memoria(nodo, banco, dir, 8, d);
         s  := s + ArrayToStr(d);
         if Length(s) >= 48 then
         begin
            WriteLn(archivo, Copy(s, 1, 48));
            s := Copy(s, 49, Length(s));
         end;

         b := b + 8;
      end;

      CloseFile(archivo);
    end;}
  end;

  // Vuelve a habilitar los eventos online
  hab_online := True;
end;

//------------------------------------------------------------------------------
// SUBE LOS FERIADOS a un nodo
//
// OK: 20-05-2001
//------------------------------------------------------------------------------

function TComm485.Upload_Feriados(nodo: Integer): Boolean;
var
   s : String;
   Nombre_Nodo : String;
   feriado : Integer;
   Fecha : String;
   Feriado_OK : Boolean;
   banco, dir : Byte;
   d : dato;
begin
  // Deshabilita eventos online
  hab_online := False;

  //Interrumpe(nodo);

  with FCom.Consulta do
  begin
    // Guarda nombre del nodo
    SQL.Text := 'SELECT Nod_nom FROM Nodos WHERE Nod_num = :nodo';
    ParambyName('nodo').AsInteger := nodo;
    Open;
    Nombre_Nodo := FieldbyName('Nod_nom').AsString;
    Close;
  end;

  // Antes que nada interroga parámetros de almacenamiento en memoria
  if not p.Modelo(nodo, s) then
  begin
     PlayWav('ERR');
     Application.MessageBox(PChar('Error recuperando estado de nodo ' + Nombre_Nodo), 'Atención', MB_OK + MB_ICONERROR);
     Result := False;
  end
  else
  begin
    // Si el nodo trabaja con franjas, transmite los feriados, si no, no hace nada y retorna
    if not ConFranjas then
    begin
       Result := True;
    end
    else
    begin
      // Consulta los feriados a transmitir
      with FCom.Consulta do
      begin
        // Selecciona todas los feriados
        SQL.Text := 'SELECT * FROM Feriados';
        Open;

        // Asume que se comunicará bien
        Result := True;

        // Posición actual de feriados = 1
        feriado := 1;

        // Crea y muestra ventana de progreso de carga de datos
        Application.CreateForm(TFProgreso, FProgreso);
        with FProgreso do
        begin
           ani.Active := True;
           barra.Progress := 0;
           lbl.Caption := '';
           Show;
        end;

        // Recorre todos los feriados a subir
        while not Eof do
        begin
            // Recupera datos del feriado a subir
            Fecha := FieldbyName('Fer_fecha').AsString;

            // Actualiza ventana de progreso
            FProgreso.lbl.Caption := Format('Cargando %d de 32 feriados en %s.', [feriado, Nombre_Nodo]);
            FProgreso.barra.Progress := Trunc((100 * feriado) / 32);
            Application.ProcessMessages;

            // Sube un feriado
            banco := UltimoBanco;
            dir := ((feriado-1)*2) + 192;

            d[0] := StrtoInt(Copy(Fecha, 1, 2));
            d[1] := StrtoInt(Copy(Fecha, 4, 2));
            Feriado_OK := Escribe_Memoria(nodo, banco, dir, 2, d);

            // Si subió bien el feriado...
            if Feriado_OK then
            begin
               inc(feriado);  // Próximo feriado
               Next;          // Próximo feriado de la base de feriados
            end
            else
            begin
                FProgreso.ani.Active := False;

                // Si se para por un error pregunta si sigue desde ahi
                if Application.MessageBox(PChar('Error subiendo feriados a nodo ' + Nombre_Nodo + '. Seguir transmitiendo?'), 'Pregunta', MB_YESNO + MB_ICONQUESTION) = ID_NO then
                begin
                    // Detiene la subida de franjas
                    Result := False;
                    break;
                end
                else ; //Interrumpe(nodo);

                FProgreso.ani.Active := True;
            end;
        end;

        // Cierra consulta
        Close;
        // Destruye ventana de progreso
        FProgreso.Free;

        // Reproduce WAV acorde a la operación
        if not Result then
           Application.MessageBox(PChar('Error subiendo feriados a nodo ' + Nombre_Nodo), 'Atención', MB_OK);
      end;
    end;
  end;

  // Vuelve a habilitar los eventos online
  hab_online := True;
end;

//------------------------------------------------------------------------------
// OBTIENE ESTADO del nodo (FECHA, HORA, Tiempo de ACCESO)
//
// OK: 16-05-2001
//------------------------------------------------------------------------------

function TComm485.Get_Status(nodo : Integer; var estado : TStatus) : Boolean;
begin
   //Interrumpe(nodo);

   pack_out[1] := nodo;
   pack_out[2] := CMD_LEE_ESTADO;
   if Comando_Nodo then
   begin
       estado.fecha := Format('%2.2d/%2.2d/%4.4d',
                       [pack_in[10] and $1F,
                       ((pack_in[8] shr 4) and $08) or
                       ((pack_in[9] shr 5) and $07),

                       //2000 + ((pack_in[10] shr 5) and $07)]);

                       // Corrección 14/12/2007
                       // Toma el año que viene en pack_in[10], de 2008 hasta 2011
                       // pack_in[10] = yyyh hhhh (y:year, h:hour)
                       // 000: 2008
                       // 001: 2009
                       // 010: 2010
                       // 011: 2011
                       2008 + ((pack_in[10] shr 5) and $03)]);

       estado.hora := Format('%2.2d:%2.2d',
                      [(pack_in[9] and $1F), (pack_in[8] and $3F)]);
       estado.tacc := pack_in[7];
       estado.estado := pack_in[11];

       Result := True;
   end
   else Result := False;
end;

//------------------------------------------------------------------------------
// INTERRUMPE un nodo
//
// 30-07-2001
//------------------------------------------------------------------------------

function TComm485.Interrumpe(nodo: Integer) : Boolean;
begin
   pack_out[1] := nodo;
   pack_out[2] := CMD_LEE_ESTADO;

   Result := Comando_nodo;
end;

//------------------------------------------------------------------------------
// RETORNA CANTIDAD Y BORRA Eventos y Habilitados
//
// OK: 16-05-2001
//------------------------------------------------------------------------------

function TComm485.Even_Hab(nodo : Integer; valor1, valor2 : Byte; var total : Integer) : Boolean;
var
   rxtimeout_temp : Real;
begin
    pack_out[1] := nodo;
    pack_out[2] := CMD_EV_HAB;

    // Setea comando dependiendo de acción a realizar
    if valor2 = EV then
        if valor1 = BORRA then pack_out[3] := $02
        else                   pack_out[3] := $04
    else
        if valor1 = BORRA then pack_out[3] := $01
        else                   pack_out[3] := $03;

    // Si es un comando de borrado, sube el timeout a 2 segundos
    rxtimeout_temp := rxtimeout;
    if valor1 = BORRA then rxtimeout :=  2 / 86400;

    // Ejecuta el comando
    if Comando_Nodo then
    begin
        if valor1 = LEE then total := pack_in[4] + (pack_in[5] * 256);
        Result := True;
    end
    else Result := False;

    // Vuelve al valor normal de rxtimeout
    rxtimeout := rxtimeout_temp;
end;

//------------------------------------------------------------------------------
// ESCRIBE FECHA y HORA en el nodo
//
// OK: 16-05-2001
//------------------------------------------------------------------------------

function TComm485.Escribe_Reloj(nodo : Integer; estado : TStatus) : Boolean;
var
   min, hora, seg, ms, anio, mes, dia : Word;
   f, h : TDateTime;
   x : Word;
begin
   //Interrumpe(nodo);

   f := StrtoDate(estado.fecha);
   h := StrtoTime(estado.hora);

   DecodeTime(h, hora, min, seg, ms); // Toma hora del sistema
   DecodeDate(f, anio, mes, dia);     // Toma fecha del sistema

   pack_out[1] := nodo;
   pack_out[2] := CMD_ESCRIBE_RELOJ;
   pack_out[3] := bin2bcd(min);
   pack_out[4] := bin2bcd(hora);
   pack_out[5] := bin2bcd(dia);
   pack_out[6] := bin2bcd(mes);
   x := anio and $07;
   pack_out[7] := bin2bcd(x);
   pack_out[8] := DayOfWeek(f);      // Manda día de la semana (1=Domingo)

   if Comando_Nodo then        Result := True
   else                        Result := False;
end;

//------------------------------------------------------------------------------
// RESETEA El Nodo
//
// OK: 16-05-2001
//------------------------------------------------------------------------------

function TComm485.Reset(nodo : Integer): Boolean;
begin
    //Interrumpe(nodo);

    pack_out[1] := nodo;
    pack_out[2] := CMD_RESET;

    if Comando_Nodo then
    begin
       PlayWav('INFO');
       Result := True;
    end
    else
    begin
       PlayWav('ERR');
       Result := False;
    end;
end;

//------------------------------------------------------------------------------
// CONFIGURA EL TIEMPO DE ACCESO del nodo
//
// OK: 16-05-2001
//------------------------------------------------------------------------------

function TComm485.Escribe_Tacc(nodo, tacc : Integer) : Boolean;
var
   d : dato;
begin
     d[0] := tacc;
     Result :=  Escribe_Memoria(nodo, $7F, DIR_TACC, 1, d);
end;

//------------------------------------------------------------------------------
// HABILITA UNA TARJETA en el nodo
//
// OK: 16-05-2001
//------------------------------------------------------------------------------

function TComm485.Hab_Tarjeta(nodo : Byte; posicion : Integer; habil : THabilitado) : Boolean;
var
    banco, dir: Integer;
    d: dato;
begin
    // Calcula posición en memoria de tarjeta a habilitar
    // posición = 0..n
    banco := posicion div 25;               {25 = Cant Hab x Banco}
    dir := (posicion mod 25) * 10;          {10 = bytes x Hab}

    // Setea número de tarjeta
    if Length(habil.tarjeta) < 8 then habil.tarjeta := StringOfChar('0', 8-Length(habil.tarjeta)) + habil.tarjeta;
    d[3] := (StrtoInt('$' + Copy(habil.tarjeta, 1, 2)));
    d[2] := (StrtoInt('$' + Copy(habil.tarjeta, 3, 2)));
    d[1] := (StrtoInt('$' + Copy(habil.tarjeta, 5, 2)));
    d[0] := (StrtoInt('$' + Copy(habil.tarjeta, 7, 2)));

    // Setea número de código
    d[4] := (StrtoInt('$' + Copy(habil.codigo, 1, 2)));
    d[5] := (StrtoInt('$' + Copy(habil.codigo, 3, 2)));

    // Setea fecha de caducidad
    d[6] := StrtoInt(Copy(habil.caducidad, 2, 2));
    if Copy(habil.caducidad, 1, 1) = 'S' then d[6] := d[6] or $80;
    d[7] := StrtoInt(Copy(habil.caducidad, 5, 2)) * 16 +
            StrtoInt(Copy(habil.caducidad, 10, 2));

    // Setea número de franja
    d[8] := (habil.franja) and $0F;        // nibble alto reservado
    d[9] := 0;                             // Reservado

    // Graba bytes en memoria
    Result := Escribe_Memoria(nodo, banco, dir, 10, d);
end;

//------------------------------------------------------------------------------
// SETEA CANTIDAD TOTAL DE TARJETAS HABILITADAS en el nodo
//
// OK: 16-05-2001
//------------------------------------------------------------------------------

function TComm485.Set_Cant_Hab(nodo, cantidad : Integer) : Boolean;
var
   i : Integer;
   cant_new, cant_old : Array of Integer;  // cantidades por banco
   cantidad_new, cantidad_old : Integer;
   rxtimeout_temp : Real;
   d : dato;
   bancos : Integer;
begin
   // Sube el timeout a 2 segundos para esta operación
   rxtimeout_temp := rxtimeout;
   rxtimeout :=  2 / 86400;

   // Lee cantidad de habilitados de antes y de ahora
   cantidad_new := cantidad;
   Even_Hab(nodo, LEE, HAB, cantidad_old);

   // Lee del nodo la cantidad de bancos de habilitados
   // Corrección 13/03/2004 - Toma el banco donde está la relación de eventos/habilitados
   //Lee_Memoria(nodo, $7F, DIR_RELAC, 1, d);
   Lee_Memoria(nodo, UltimoBanco, DIR_RELAC, 1, d);
   bancos := d[0] + 1;

   // Seteo longitud de arrays
   SetLength(cant_new, bancos);
   SetLength(cant_old, bancos);

   // Borra cantidades de cantidad de habilitados viejos y nuevos
   for i:=0 to bancos - 1 do cant_new[i] := 0;
   for i:=0 to bancos - 1 do cant_old[i] := 0;

   // Calcula cantidades parciales de habilitados viejos
   for i:=0 to bancos - 1 do
   begin
      if (cantidad_old >= 25) then
      begin
           cant_old[i] := 25;
           cantidad_old := cantidad_old - 25;
      end
      else
      begin
           cant_old[i] := cantidad_old;
           cantidad_old := 0;
      end;
   end;

   // Calcula cantidades parciales de habilitados nuevos
   for i:=0 to bancos - 1 do
   begin
      if cantidad_new >= 25 then
      begin
           cant_new[i] := 25;
           cantidad_new := cantidad_new - 25;
      end
      else
      begin
           cant_new[i] := cantidad_new;
           cantidad_new := 0;
      end;
   end;

   // Asume comunicación OK
   Result := True;

   // Setea habilitados banco por banco
   for i:=0 to bancos - 1 do
   begin
     if cant_new[i] <> cant_old[i] then
     begin
       d[0] := cant_new[i];
       if not Escribe_Memoria(nodo, i, $FF, 1, d) then
       begin
           Result := False;
           break;
       end;
     end;
   end;

   rxtimeout := rxtimeout_temp;
end;

//------------------------------------------------------------------------------
// OBTIENE UN EVENTO ALMACENADO en el nodo
//
// OK: 19-05-2001
// Corrección de banco inicial para leer eventos: 19-07-2001
//------------------------------------------------------------------------------

function TComm485.Get_Evento(nodo: Byte; posicion: Integer; var evento: TEvento) : Boolean;
var
    d: dato;
begin
    // Lee un evento de la memoria (10 bytes)
    if Lee_Memoria(nodo,
                  (posicion div 25) + p.PrimerBancoEventos,    // 25 eventos por banco
                  (posicion mod 25) * 10,
                  10,
                  d) then
    begin
        // Recupera el tipo del evento
        case (d[9] and $0F) of
          0:   evento.tipo := 'A';
          1:   evento.tipo := 'I';
          2:   evento.tipo := 'C';
          3:   evento.tipo := 'F';
          4:   evento.tipo := 'P';
          5:   evento.tipo := 'T';
          6:   evento.tipo := 'U';
          else
            Application.MessageBox('Error en evento recibido: tipo incorrecto', 'Error', MB_OK + MB_ICONERROR);
        end;

        // Recupera tarjeta y código del evento
        evento.tarjeta := Format('%2.2x%2.2x%2.2x%2.2x', [d[3], d[2], d[1], d[0]]);
        evento.codigo :=  Format('%2.2x%2.2x', [d[4], d[5]]);

        // Recupera fecha y hora del evento
        evento.fecha := Format('%2.2d/%2.2d/%4.4d', [
                    { día }   d[8] and $1F,
                    { mes }   ((d[6] shr 4) and $08) or ((d[7] shr 5) and $07),

                    // Corrección 30/12/2003 - Estaba tomando sólo hasta 2003 (ahora sigue hasta 2007)
                    //{ año }   2000 + (d[8] shr 5) and $03
                    //{ año }   2000 + (d[8] shr 5) and $07

                    // Corrección 14/12/2007
                    // Toma el año que viene en d[8], de 2008 hasta 2011
                    // d[8] = yyyh hhhh (y:year, h:hour)
                    // 000: 2008
                    // 001: 2009
                    // 010: 2010
                    // 011: 2011
                    { año }   2008 + (d[8] shr 5) and $03
                                ]);

        evento.hora := Format('%2.2d:%2.2d', [
                              d[7] and $1F, d[6] and $3F]);

        // Recupera E/S del evento
        if ((d[6] and $40) shr 6) = 1 then       evento.es := 'E'
        else                                     evento.es := 'S';

        Result := True;
    end
    else Result := False;
end;

//------------------------------------------------------------------------------
// OBTIENE EL ID de la Última subida de habilitados
//
// OK: 04-08-2001
//------------------------------------------------------------------------------

function TComm485.Lee_ID_Ultima_Subida(nodo: Integer; var ID: String): Boolean;
var
   d : dato;
begin
   // Lee 4 bytes de la memoria donde se almacena el último ID de subida
   if Lee_Memoria(nodo, UltimoBanco, 188, 4, d) then
   begin
       ID := Format('%2.2x%2.2x%2.2x%2.2x', [d[0], d[1], d[2], d[3]]);
       Result := True;
   end
   else
       Result := False;
end;

//------------------------------------------------------------------------------
// SETEA EL ID de la Última subida de habilitados
//
// OK: 04-08-2001
//------------------------------------------------------------------------------

function TComm485.Escribe_ID_Ultima_Subida(nodo: Integer; ID: String): Boolean;
var
   d : dato;
begin
   d[0] := (StrtoInt('$' + Copy(ID, 1, 2)));
   d[1] := (StrtoInt('$' + Copy(ID, 3, 2)));
   d[2] := (StrtoInt('$' + Copy(ID, 5, 2)));
   d[3] := (StrtoInt('$' + Copy(ID, 7, 2)));

   // Escribe 4 bytes de la memoria donde se almacena el último ID de subida
   Result := Escribe_Memoria(nodo, UltimoBanco, 188, 4, d);
end;

//------------------------------------------------------------------------------
// BLOQUEA el nodo seleccionado
//
// OK: 06-08-2001
//------------------------------------------------------------------------------

procedure TComm485.Bloqueo(nodo: Integer);
begin
   pack_out[1] := nodo;
   pack_out[2] := CMD_BLOQUEO;

   if Comando_Nodo then
   begin
      FPrincipal.Nod_Status[nodo] := 12;
   end
   else
   begin
      PlayWav('ERR');
      Evento_Local('O', nodo);
      FPrincipal.Nod_Status[nodo] := 1;
   end;
   FPrincipal.ActualizaEstadoNodos(nodo);
end;

//------------------------------------------------------------------------------
// ATIENDE LA ALARMA del nodo seleccionado
//
// OK: 06-08-2001
//------------------------------------------------------------------------------

procedure TComm485.AtenderAlarma(nodo: Integer);
begin
   pack_out[1] := nodo;
   pack_out[2] := CMD_ATENDER;

   if Comando_Nodo then
   begin
      FPrincipal.Nod_Status[nodo] := 0;
   end
   else
   begin
      PlayWav('ERR');
      Evento_Local('O', nodo);
      FPrincipal.Nod_Status[nodo] := 1;
   end;
   FPrincipal.ActualizaEstadoNodos(nodo);
end;

//---------------------------------------------------------------------------
// FILTRA EL EVENTO ENTRANTE
//
// OK: 19-05-2001
// Revisión OK: 19-07-2001
//------------------------------------------------------------------------------

function TComm485.Filtro_Ev(evento : TEvento) : Boolean;
begin
   case evento.tipo of
     'A':             Result := (ReadReg_I('Filtro.Accesos') = 1);
     'P', 'T':        Result := (ReadReg_I('Filtro.Alarmas') = 1);
     'I':             Result := (ReadReg_I('Filtro.Intrusos') = 1);
     'R':             Result := (ReadReg_I('Filtro.ApRemotas') = 1);
     'O':             Result := (ReadReg_I('Filtro.NodosOffline') = 1);
     'B', 'S':        Result := (ReadReg_I('Filtro.Transferencias') = 1);
     'C':             Result := (ReadReg_I('Filtro.Caducidades') = 1);
     'F':             Result := (ReadReg_I('Filtro.FueraHorario') = 1);
     'U':             Result := (ReadReg_I('Filtro.Pulsador') = 1);
     else             Result := False;
   end;
end;

//---------------------------------------------------------------------------
// REALIZA LA DESCARGA AUTOMÁTICA
//
// INICIO: 13-08-2001
//
//------------------------------------------------------------------------------

procedure TComm485.DescargaAutomatica;
var
   qryAux: TQuery;
   nodo: Integer;
begin
   // Si en cada descarga debe bajar todos los nodos...
   if DescAuto.Todos then
   begin
      qryAux := TQuery.Create(nil);
      qryAux.DatabaseName := 'MIBASE';
      qryAux.SQL.Text := 'select * from nodos order by Nod_num';
      qryAux.Open;
      // Baja todos los nodos configurados
      while not qryAux.Eof do
      begin
         Download_Ev(qryAux.FieldbyName('Nod_num').AsInteger);
         qryAux.Next;
      end;
      qryAux.Close;
      FreeAndNil(qryAux);
   end

   // En cambio, si debe bajar uno por vez...
   else
   begin
      qryAux := TQuery.Create(nil);
      qryAux.DatabaseName := 'MIBASE';
      qryAux.SQL.Text := 'select * from nodos order by Nod_num';
      qryAux.Open;

      if not qryAux.IsEmpty then
      begin
         // Si el último nodo no existe dentro de los disponibles, baja el primero
         if not qryAux.Locate('Nod_num', DescAuto.UltimoNodoDescargado, []) then
         begin
            qryAux.First;
            nodo := qryAux.FieldbyName('Nod_num').AsInteger;
            Download_Ev(nodo);
            DescAuto.UltimoNodoDescargado := nodo;
         end

         // Si el último nodo existe, baja el próximo
         else
         begin
            qryAux.Next;
            // Si ese era el último, baja el primero
            if qryAux.Eof then qryAux.First;

            // Baja el nodo
            nodo := qryAux.FieldbyName('Nod_num').AsInteger;
            Download_Ev(nodo);
            DescAuto.UltimoNodoDescargado := nodo;
         end;
      end;

      qryAux.Close;
      FreeAndNil(qryAux);
   end;
end;

//------------------------------------------------------------------------------
// LEE LA MEMORIA DEL NODO
//
// nodo = Número del nodo del cual leer su memoria
// banco, dir = Número del banco y dirección de memoria (Max = 64k)
// cantidad = Cantidad de bytes a leer de la memoria
// dato = Resultado de la operación de lectura
//
// OK: 19-05-2001
//------------------------------------------------------------------------------
function TComm485.Lee_Memoria(nodo, banco, dir, cantidad : Byte; var d : dato) : Boolean;
begin
    pack_out[1] := nodo;
    pack_out[2] := CMD_LEE_MEM;
    pack_out[3] := banco;
    pack_out[4] := dir;
    pack_out[5] := cantidad;

    if Comando_Nodo then
    begin
        d[0] := pack_in[3];
        d[1] := pack_in[4];
        d[2] := pack_in[5];
        d[3] := pack_in[6];
        d[4] := pack_in[7];
        d[5] := pack_in[8];
        d[6] := pack_in[9];
        d[7] := pack_in[10];
        d[8] := pack_in[11];
        d[9] := pack_in[12];
        d[10] := pack_in[13];
        d[11] := pack_in[14];
        d[12] := pack_in[15];

        Result := True;
    end
    else
        Result := False;
end;

//------------------------------------------------------------------------------
// ESCRIBE LA MEMORIA DEL NODO
//
// nodo = Número del nodo al cual escribir su memoria
// banco, dir = Número del banco y dirección de memoria (Max = 64k)
// cantidad = Cantidad de bytes a escribir en la memoria
// dato = Valor a escribir en la memoria
//
// OK: 19-05-2001
//------------------------------------------------------------------------------
function TComm485.Escribe_Memoria(nodo, banco, dir, cantidad: Byte; d : Dato) : Boolean;
begin
    pack_out[1] := nodo;
    pack_out[2] := CMD_ESCRIBE_MEM;
    pack_out[3] := banco;
    pack_out[4] := dir;
    pack_out[5] := cantidad;
    pack_out[6] := d[0];
    pack_out[7] := d[1];
    pack_out[8] := d[2];
    pack_out[9] := d[3];
    pack_out[10] := d[4];
    pack_out[11] := d[5];
    pack_out[12] := d[6];
    pack_out[13] := d[7];
    pack_out[14] := d[8];
    pack_out[15] := d[9];

    Result := Comando_Nodo;

    // TRAMPA
    //Result := True;
end;

end.
