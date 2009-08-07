//---------------------------------------------------------------------------
//
//  Módulo de Acceso a la llave de protección
//
//
//  Inicio 24-01-2001
//  Modificación de Rutinas 25-01-2001
//  Reintentos de lectura para evitar errores aleatorios 07-02-2001
//  Migración a Componente TComport v2.6 16-03-2001
//  Módulo independiente del programa (crea componentes a mano) 16-03-2001
//  Vuelta a component AsyncPro v2.56 19-03-2001
//  Componente de acceso a COM creado a mano 19-03-2001
//  Al acceder a llave, baja y sube DTR para evitar ya alimentada 19-03-2001
//  Bug en comunicación con llave (timeout nunca salía de bucle) 07-10-2001
//
//
//  A hacer:
//          Crear dinámicamente ventana de transacciones
//
//---------------------------------------------------------------------------

unit Serkey;

interface

uses SysUtils, Dialogs, Forms, Windows, OoMisc, AdPort, ProgresoLlave;

//---------------------------------------------------------------------------
// FUNCIONES Y PROCEDIMIENTOS DECLARADOS
//------------------------------------------------------------------------------

procedure Config_Serkey;
function Llave_Presente: Boolean;
//procedure Modo_Demo(s: String);

function READ(dir: Byte; var i: Integer) : Boolean;
function WRITE(dir: Byte; i: Integer) : Boolean;
function EWEN: Boolean;
function EWDS: Boolean;
function Check_Partida: Boolean;
function Llave_Virgen: Boolean;
function Escribe_Empresa: Boolean;
function Lee_Empresa: String;
function Lee_Serie: Integer;
function Lee_Modulos: LongWord;
function Comando(var cmd, hi, lo: Byte): Boolean;

procedure msg(mensaje : String);

//---------------------------------------------------------------------------
// VARIABLES GLOBALES
//------------------------------------------------------------------------------

var
  c: TApdComPort;             // Declara la clase de acceso al puerto serie
  COM_SERKEY : Integer;       // Puerto Serie donde está la llave
  cmd, hi, lo : Byte;         // Variables de acceso a memoria 93C46
  flag : Boolean=False;       // Flag general
  vt : Boolean=False;         // Indica si ventana de transacciones activa
  buf : array[1..10] of Byte; // Buffer de comunicación con llave

  llave : Record              // Datos de la llave leída
    Empresa : String;         // Nombre de la Empresa Registrada
    Serie : Integer;          // Número de Serie de la Llave
    //mododemo : Boolean;       // Flag que indica modo demo
    modofull: Boolean;        // Flag que indica el modo full de SAC32
    Modulos : LongWord;       // Información sobre los módulos habilitados
  end;

  prog: TFProgresoLlave;

  modo_muestra: Boolean;      // Guarda el modo actual (24/04/2004}

  Caption_Principal: String;  // Guarda el caption del form principal

const
  HARDDEMO = False;               // Indica si debe compilar un software DEMO

implementation

uses Principal, Paquetes, Rutinas;

//---------------------------------------------------------------------------
// CONFIGURA OPERACIÓN DEL PROGRAMA IDENTIFICANDO LA LLAVE
//---------------------------------------------------------------------------
// Busca la llave de protección en alguno de los puertos serie
// Setea los valores de:
//   Empresa, Serie, mododemo, FPrincipal.Caption, Modulos
//
procedure Config_Serkey;
var
   s, m : String;
begin
   // Inicializa generador de random (debe ser llamado una sola vez)
   Randomize;

   // Parámetro /backdoor funciona sin llave (backdoor) - Pide clave
   {if FindCmdLineSwitch('backdoor', ['/', '-'], True) and
      (InputBox('Ingreso sin llave','Ingresar clave:','') = 'dalvarez') then
   begin
      with llave do
      begin
         Empresa := 'BackDoor S.A.';
         Serie := 1056;
         Modulos := 5;
         mododemo := False;
         FPrincipal.Caption := Application.Title + ' [Software licenciado a ' + Empresa + ']';
      end;
   end
   else
   begin}
      // Si modo demo HARDWIRED no busca la llave
      {if HARDDEMO then
      begin
        Modo_Demo('El programa se ejecutará en modo DEMOSTRACIÓN.');
      end
      else
      begin}
        // En modo cocheras TITA, siempre deja fijo el nombre de empresa
        {$IFDEF TITA}
        llave.Serie := 0;
        llave.Modulos := 5;
        llave.Empresa := 'Cocheras TITA';
        FPrincipal.Caption := Application.Title + ' Modo Descargador [Software licenciado a ' + llave.Empresa + ']';
        llave.modofull := False;
        {$ENDIF}

        {$IFNDEF TITA}
        // Corrección 24/04/2004 - En modo MUESTRA, entra en modo FULL
        if modo_muestra then
        begin
          with llave do
          begin
             Empresa := 'MODO MUESTRA NO COMERCIAL';
             Serie := 1056;
             Modulos := 5;
             FPrincipal.Caption := Application.Title + ' [Software licenciado a ' + Empresa + ']';
             modofull := True;
          end;
        end
        else
        begin
          // Corrección 05/04/2003 - Implementa protección por software
          FPrincipal.AVLockPro1.Read;
          if FPrincipal.AVLockPro1.Registered then
          begin
            llave.Empresa := ReadReg_S('Empresa');
            llave.Serie := 1234;
            llave.Modulos := 5;
            FPrincipal.Caption := Application.Title + ' Modo FULL [Software licenciado a ' + llave.Empresa + ']';
            llave.modofull := True;

            // Corrección 13/03/2004 - /desc fuerza modo descargador
            if FindCmdLineSwitch('descargador', ['/', '-'], True) then
            begin
              llave.Empresa := ReadReg_S('Empresa');
              llave.Serie := 0;
              llave.Modulos := 5;
              FPrincipal.Caption := Application.Title + ' Modo Descargador [Software licenciado a ' + llave.Empresa + ']';
              llave.modofull := False;

              // En modo descargador fuerza ciertos seteos
              WriteReg_I('DescAut', 0);
            end;
          end
          else
          begin
            llave.Empresa := ReadReg_S('Empresa');
            llave.Serie := 0;
            llave.Modulos := 5;
            FPrincipal.Caption := Application.Title + ' Modo Descargador [Software licenciado a ' + llave.Empresa + ']';
            llave.modofull := False;

            // En modo descargador fuerza ciertos seteos
            WriteReg_I('DescAut', 0);
          end;
        end;
        {$ENDIF}
        
        // Finalmente, guarda el caption del form principal
        Caption_Principal := FPrincipal.Caption;

        (*
        // Crea ventana de transacciones con la llave si parámetro /m
        if FindCmdLineSwitch('m', ['/', '-'], True) then
        begin
           Application.CreateForm(TFPaquetes, FPaquetes);
           with FPaquetes do
           begin
              Caption := 'Protección de SAC32';
              Show;
              memo.Lines.Add('Iniciando transacción con llave...');
           end;
           vt := True;
        end;

        prog := TFProgresoLlave.Create(nil);
        prog.FormStyle := fsStayOnTop;
        prog.Visible := True;
        prog.BringToFront;
        Application.ProcessMessages;

        // Obtiene puertos disponibles en la PC
        msg('Obteniendo puertos serie...');
        GetAvailPorts;
        if ExisteCOM[1] then msg('COM1 existe.') else msg('COM1 no existe.');
        if ExisteCOM[2] then msg('COM2 existe.') else msg('COM2 no existe.');
        if ExisteCOM[3] then msg('COM3 existe.') else msg('COM3 no existe.');
        if ExisteCOM[4] then msg('COM4 existe.') else msg('COM4 no existe.');

        // Crea clase de acceso al puerto serie
        c := TApdComPort.Create(nil);

        // Si la llave no está, entra en modo demo
        msg('Verificando presencia de llave...');
        if not Llave_Presente then
        begin
           prog.Hide;
           Modo_Demo('La llave de protección no está instalada.'#13'El programa se ejecutará en modo DEMOSTRACIÓN.');
        end
        else
        begin
           // Resetea la llave a modo virgen si encuentra switch
           if FindCmdLineSwitch('graba', ['/', '-'], True) and
              (InputBox('Borrado de llave','Ingresar clave:','') = 'erasure') then
           begin
             msg('Reseteando llave...');

             // Ingresa número de serie
             s := InputBox('Serie', 'Ingrese Número de Serie:', '0');

             // Ingresa Módulos
             m := InputBox('Módulos', 'Ingrese Id de Módulos a Grabar:', '1');

             // atrapa errores en número
             try StrtoInt(s); except s := '0'; end;
             try StrtoInt(m); except m := '0'; end;

             EWEN;                    // Permite escribir la llave
             WRITE(59, $FF);          // Llave sin personalizar
             WRITE(60, $00);
             WRITE(61, StrtoInt(m));  // Módulos habilitados
             WRITE(62, StrtoInt(s));  // Escribe Número de Serie
             WRITE(63, $07D1);        // Escribe Número de Partida
             WRITE(58, $07D1);        // 2 veces para evitar errores
             EWDS;                    // Deshabilita escritura
           end;

           // Si la partida no es la correcta, entra en modo demo
           msg('Verificando partida...');
           if not Check_Partida then
           begin
              msg('Partida incorrecta');
              Modo_Demo('La llave de protección no corresponde al programa.'#13'El programa se ejecutará en modo DEMOSTRACIÓN.');
           end
           else
           begin
              msg('Partida correcta');

              // Si la llave no está personalizada, la escribe...
              if Llave_Virgen then
              begin
                 msg('Personalización de llave');
                 if not Escribe_Empresa then
                 begin
                    msg('Personalización incorrecta');
                    Modo_Demo('La llave de protección debe ser registrada con el nombre de la empresa para funcionar.'#13'El programa se ejecutará en modo DEMOSTRACIÓN.');
                 end
                 else
                 begin
                    msg('Personalización correcta');
                    llave.Empresa := Lee_Empresa;
                    llave.Serie := Lee_Serie;
                    llave.Modulos := Lee_Modulos;
                    FPrincipal.Caption := Application.Title + ' [Software licenciado a ' + llave.Empresa + ']';
                    llave.mododemo := False;
                    msg('Empresa = ' + llave.Empresa);
                    msg('Serie = ' + InttoStr(llave.Serie));
                    msg('Módulos = ' + InttoStr(llave.Modulos));
                 end;
              end
              else
              begin
                 llave.Empresa := Lee_Empresa;
                 llave.Serie := Lee_Serie;
                 llave.Modulos := Lee_Modulos;
                 FPrincipal.Caption := Application.Title + ' [Software licenciado a ' + llave.Empresa + ']';
                 llave.mododemo := False;
                 msg('Empresa = ' + llave.Empresa);
                 sleep(200);
                 msg('Serie = ' + InttoStr(llave.Serie));
                 sleep(200);
                 msg('Módulos = ' + InttoStr(llave.Modulos));
                 sleep(200);
              end;
           end;

           // Cierra el puerto serie y saca la alimentación de la llave
           msg('Cerrando acceso a llave...');
           c.DTR := False;
           c.Open := False;
        end;

        // Cierra ventana de transacciones si estaba activa
        if vt then
        begin
           ShowMessage('Transacción finalizada');
           FPaquetes.Free;
        end;

        // Libera clase de acceso al puerto serie
        C.Free;

        prog.Close;
        prog.Release;
        *)
      {end;}
   {end;}
end;

//---------------------------------------------------------------------------
// VERIFICA QUE LA LLAVE ESTE PRESENTE
//---------------------------------------------------------------------------

function Llave_Presente : Boolean;
var
   puerto, reint : Integer;
   found : Boolean;
begin
  // Configura propiedades del puerto serie
  with c do
  begin
    Baud := 9600;
    AutoOpen := False;
    DTR := False;
    TraceName := 'APRO.TRC';
    LogName := 'APRO.LOG';
    TapiMode := tmOff;
  end;

  // Recorre todos los puertos series presentes buscando la llave
  puerto := 1;
  found := False;
  repeat
    if existeCOM[puerto] then
    begin
      reint := 1;
      repeat
         try
            msg('Esperando llave en COM' + InttoStr(puerto) + '...');

            // Abre puerto serie y alimenta llave
            with c do
            begin
              //Open := False;                  // Cierra el puerto
              ComNumber := puerto;            // Setea COM
              Open := True;                   // Abre el puerto
              DTR := False;                   // Baja DTR
              Sleep(800);                     // Espera para encender llave
              DTR := True;                    // Alimenta llave
              //Sleep(100);                     // Espera para tomar datos
            end;

            // Espera contestación de la llave (SK1.0)
            if c.WaitForString('SK1.0', 10, True, True) then
            begin
               msg('Llave encontrada en COM' + InttoStr(puerto));
               COM_SERKEY := puerto;    // Setea COM de llave encontrada
               c.FlushInBuffer;         // Limpia buffer rx
               found := True;           // Llave encontrada
               break;                   // No sigue buscando más...
            end
            else
            begin // Si hubo timeout, no hay llave acá
               msg('No hay llave en COM' + InttoStr(puerto));
               COM_SERKEY := 0;
               c.DTR := False;          // Saca alimentaci¾n a la llave
               c.Open := False;         // Cierra el puerto serie
               found := False;          // No encontrada
               inc(reint);              // Incrementa reintentos
            end;

         // Error en COM. Ya está en uso el puerto?
         except
           msg('Error en COM ' + InttoStr(puerto) + ' (Usado)');
           COM_SERKEY := 0;
           c.DTR := False;     // Saca alimentación a la llave
           c.Open := False;    // Cierra el puerto serie
           found := False;     // No encontrada
           inc(reint);         // Incrementa reintentos
         end;

      until (reint>3) or found;  // Reintenta 3 veces
    end;
    inc(puerto);    // Próximo puerto serie

  until (puerto>4) or found; // Recorre los 4 COM's

  // Escribe en registro puerto encontrado o cero si no hay llave
  //WriteReg_I('puerto', COM_SERKEY);

  Result := found;
end;

//---------------------------------------------------------------------------
// SETEA EL PROGRAMA EN MODO DEMO
//---------------------------------------------------------------------------

{procedure Modo_Demo(s: String);
begin
   with llave do
   begin
     Empresa := '--MODO DEMO--';
     Serie := 1056;
     Modulos := 5;
     mododemo := True;
     FPrincipal.Caption := Application.Title + ' [Software licenciado a ' + Empresa + ']';
   end;
   PlayWav('ERR');
   vdemo;
end;}

//---------------------------------------------------------------------------
// CHEQUEA QUE CORRESPONDA NÚMERO DE PARTIDA
//---------------------------------------------------------------------------

function Check_Partida : Boolean;
var
   partida1, partida2 : Integer;
begin
   //flag := True;

   // Lee número de partida
   READ(58, partida1);
   READ(63, partida2);

   //flag := False;

   // Devuelve si alguna de las partidas corresponde
   Result := (partida1 = $07D1) or (partida2 = $07D1);

   msg('Partida1 = ' + InttoStr(partida1));
   msg('Partida2 = ' + InttoStr(partida2));
end;

//---------------------------------------------------------------------------
// CHEQUEA SI LA LLAVE TODAVÍA NO FUE PERSONALIZADA
//---------------------------------------------------------------------------

function Llave_Virgen : Boolean;
var
   flag : Integer;
begin
   // Verifica si el nombre de empresa está grabado
   READ(59, flag);
   if flag = $FF then Result := True
   else               Result := False;
end;

//---------------------------------------------------------------------------
// PERSONALIZA LA LLAVE CON EL NOMBRE DE LA EMPRESA
//---------------------------------------------------------------------------

function Escribe_Empresa : Boolean;
var
   dir, i, j : Integer;
   h, l : Byte;
begin
  // Ingresa el nombre de la empresa
  if not InputQuery('Personalización de SAC32', 'Ingrese el nombre de la empresa', llave.Empresa) then
  begin
     llave.Empresa := 'NO INGRESADA';
     Result := False;
  end
  else
  begin
     if Application.MessageBox('Los datos que usted intenta introducir serán registrados'#13'permanentemente en la llave de protección.'#13'Ante cualquier duda consulte a su proveedor.'#13#13'Está seguro de querer realizar esta operación?', 'Advertencia', MB_YESNO + MB_ICONQUESTION) = ID_YES then
     begin
       // Limita el nombre de empresa a 40 caracteres
       if Length(llave.Empresa) > 40 then llave.Empresa := Copy(llave.Empresa,1,40);

       // Agrega un espacio para hacer par la longitud de la cadena
       if (Length(llave.Empresa) mod 2) <> 0 then llave.Empresa := llave.Empresa + ' ';

       EWEN;        // Habilita la escritura de la llave

       dir := 0;
       i := 1;
       while i <= Length(llave.Empresa) do
       begin
          repeat
            h := Byte(llave.Empresa[i]);
            l := Byte(llave.Empresa[i+1]);
            WRITE(dir, (h shl 8) + l);
            READ(dir, j);
          until ((h shl 8) + l) = j;

          inc(dir);
          i := i + 2;
       end;

       // Escribe posiciones restantes
       for i := dir to 19 do WRITE(i, 0);

       WRITE(59, 0);          // Llave personalizada
       EWDS;                 // Deshabilita escritura de llave

       Result := True;
     end
     else
     begin
         llave.Empresa := 'NO INGRESADA';
         Result := False;
     end;
  end;
end;

//---------------------------------------------------------------------------
// LEE DE LA LLAVE DATOS DE EMPRESA
//---------------------------------------------------------------------------

function Lee_Empresa : String;
var
   s : String;
   i, d : Integer;
   c : Char;
begin
   s := '';              // Lee el nombre de la empresa
   for i:=0 to 19 do
   begin
      READ(i, d);

      c := Char((d and $FF00) shr 8);
      if (c <> #0) and (c <> #255) then s := s + c;

      c := Char(d and $00FF);
      if (c <> #0) and (c <> #255) then s := s + c;
   end;

   if s[Length(s)] = ' ' then s := Copy(s, 1, Length(s)-1);
   Result := s;
end;

//---------------------------------------------------------------------------
// LEE DE LA LLAVE DATOS DE NÚMERO DE SERIE
//---------------------------------------------------------------------------

function Lee_Serie : Integer;
begin
   READ(62, Result);   // Lee número de serie
end;

//---------------------------------------------------------------------------
// LEE DE LA LLAVE DATOS DE LOS MÓDULOS HABILITADOS
//---------------------------------------------------------------------------

function Lee_Modulos : LongWord;
var
   h, l : Integer;
begin
   READ(60, h);
   READ(61, l);
   Result := (h shl 8) or l;
end;

//---------------------------------------------------------------------------
// MANDA COMANDO A LLAVE Y ESPERA RESPUESTA
//---------------------------------------------------------------------------

function Comando(var cmd, hi, lo : Byte) : Boolean;
var
   rx: Boolean;
   i: Integer;
   key: Byte;
   t_inicio: TDateTime;
   timeout: Boolean;
begin
   c.FlushInBuffer;         // Borra el buffer de RX

   // Cargo valores del buffer de transmisión
   buf[1] := Random($FF);   // Clave de encriptación random en buffer[1]
   buf[5] := cmd;           // Comando de memoria en buffer[5]

   // Dependiendo de bit 0 de clave ubica bytes hi y lo en buffer[2] y buffer[6]
   if (buf[1] and 1) = 1 then
   begin
     buf[6] := hi;              // Byte alto
     buf[2] := lo;              // Byte bajo
   end
   else
   begin
     buf[2] := hi;              // Byte alto
     buf[6] := lo;              // Byte bajo
   end;

   buf[4] := Random($FF);     // Byte random
   buf[3] := lo xor buf[4];// Byte para engañar

   // Encripta el paquete dos veces
   for i:=1 to 6 do buf[i] := buf[i] xor $07;

   key := buf[1];
   for i:=2 to 6 do
   begin
        buf[i] := buf[i] xor key;
        key := ((key xor $2E) + $F1) xor $C4;
   end;

   if flag then msg(Format('TX = %.02x %.02x %.02x %.02x %.02x %.02x', [buf[1],buf[2],buf[3],buf[4],buf[5],buf[6]]));

   // Transmite el buffer
   for i:=1 to 6 do
   begin
      c.PutChar(Char(buf[i]));
      sleep(1);
   end;

   // Espera la respuesta
   rx := False;                  // Estado rx = inactivo
   timeout := False;             // Timeout no ocurrió todavía
   t_inicio := Now;              // Tiempo inicial = Ahora

   repeat
      // Recibe el paquete de 6 bytes todo entero
      if c.CharReady then        // Si hay alg·n caracter
      begin
         try
           c.GetBlock(buf, 6);   // Recibe paquete de 6 bytes
           rx := True;        // estado = exitoso
         except
           rx := False;          // Si falló, estado = error
         end;
      end;

      if (Now - t_inicio) > (2/(24*60*60)) then    // Si pas¾ el tiempo
         timeout := True;               // estado = Timeout

      // Procesa mensajes de windows
      Application.ProcessMessages;

   // Repite bucle hasta recibir datos o timeout
   until rx or timeout;

   if flag then msg(Format('RX = %.02x %.02x %.02x %.02x %.02x %.02x', [buf[1],buf[2],buf[3],buf[4],buf[5],buf[6]]));

   if rx then
   begin
        // Desencripta el paquete
        key := buf[1];
        for i:=2 to 6 do
        begin
            buf[i] := buf[i] xor key;
            key := ((key xor $2E) + $F1) xor $C4;
        end;

        cmd := buf[5];

        if (buf[1] and 1) = 1 then
        begin
         hi := buf[6];              // Byte alto
         lo := buf[2];              // Byte bajo
        end
        else
        begin
         hi := buf[2];              // Byte alto
         lo := buf[6];              // Byte bajo
        end;
        Result := True;
   end
   else
       Result := False;

   sleep(1);
end;

//---------------------------------------------------------------------------
// FUNCIONES DE ACCESO A LA MEMORIA 93C46
//---------------------------------------------------------------------------

function READ(dir : Byte; var i : Integer) : Boolean;
begin
     cmd := $80 + dir;
     hi := Random($FF);
     lo := Random($FF);

     if Comando(cmd, hi, lo) then
     begin
          i := (hi shl 8) + lo;
          Result := True;
     end
     else if Comando(cmd, hi, lo) then
     begin
          i := (hi shl 8) + lo;
          Result := True;
     end
     else Result := False;
end;

function WRITE(dir : Byte; i : Integer) : Boolean;
begin
     cmd := $40 + dir;
     hi := (i shr 8) and $FF;
     lo := i and $FF;

     if Comando(cmd, hi, lo) then         Result := True
     else if Comando(cmd, hi, lo) then    Result := True
     else                                 Result := False;
end;

function EWEN : Boolean;
begin
     cmd := $30;
     hi := Random($FF);
     lo := Random($FF);

     if Comando(cmd, hi, lo) then         Result := True
     else if Comando(cmd, hi, lo) then    Result := True
     else                                 Result := False;
end;

function EWDS : Boolean;
begin
     cmd := $00;
     hi := Random($FF);
     lo := Random($FF);

     if Comando(cmd, hi, lo) then         Result := True
     else if Comando(cmd, hi, lo) then    Result := True
     else                                 Result := False;
end;

//---------------------------------------------------------------------------
// MUESTRA MENSAJES DE TRANSACCIONES CON LA LLAVE
//---------------------------------------------------------------------------

procedure msg(mensaje : String);
begin
   if vt then FPaquetes.memo.Lines.Add(mensaje);
   prog.Label1.Caption := mensaje;
   Application.ProcessMessages;
end;

end.

