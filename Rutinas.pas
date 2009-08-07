//---------------------------------------------------------------------------
//
//  Módulo de Rutinas Generales
//
//
//  Inicio 24-01-2001
//  Nuevos procedimientos y funciones 25-01-2001
//  Función que valida fechas para huevo de pascuas 05-01-2006
//
//  A hacer:
//           Verificación de COMCTL32.DLL en 95/98/ME/2000/NT 
//
//---------------------------------------------------------------------------

unit Rutinas;

interface

uses
  Windows, ExtCtrls, Menus, ImgList, Controls, ComCtrls, ToolWin, Graphics,
  Classes, StdCtrls, Forms, SysUtils, Messages, Registry, MMSystem, Dialogs,
  Math, DBTables, ModoMuestra;

//---------------------------------------------------------------------------
// FUNCIONES Y PROCEDIMIENTOS PUBLICOS
//------------------------------------------------------------------------------

procedure bitac(cadena : String);
procedure Config_Cript_Key;
function Check_Video_Mode : Boolean;
procedure PlayWav(wav : String);
function GetFileVersion(archivo : String) : string;
procedure Cript;
procedure DeCrip;
function Logon: Boolean;
procedure Config_Window;
function ReadReg_I(v : String) : Integer;
function ReadReg_S(v : String) : String;
procedure WriteReg_I(v : String; i : Integer);
procedure WriteReg_S(v : String; s : String);
procedure GetAvailPorts;
function bin2bcd( i : Byte) : Byte;
function debug : Boolean;
procedure ShowBmp(bmp : String);
function ResourceExport(FResourceName, FResourceCategory, FExportFileName: String) : Boolean;
procedure Arma_Array;
function Habilitada(funcion, subfuncion : Integer; msg : Boolean = True) : Boolean;
procedure Set_Prioridad(p : Integer);
procedure Config_Locale;
procedure Config_Seguridad;
procedure CargaNodos;
procedure InitModem;
procedure Config_Carpeta;
procedure Config_Registro;
procedure vdemo;
function Check_COMCTL32 : Boolean;
procedure Config_Ayuda;
procedure Config_Desc_Automatica;
procedure ValidaFranjas;
procedure VentanaModoMuestra;
procedure EasterEgg;

//---------------------------------------------------------------------------
// CONSTANTES GLOBALES
//------------------------------------------------------------------------------

const
   // Valor de cadena de Registro usada para configuración
   StrREG = 'Software\SAC';

   // Constantes de Acceso Irrestricto (Debugging o Backdoor?)
   SUPERUSUARIO = 'ad265';
   SUPERCLAVE = 'ad265';
   USECRETO = 'daemon';
   CSECRETA = 'teletru';

   // Constantes de encriptación de passwords
   C1 = 45219;
   C2 = 37815;

   // Constante de encriptación de la base de datos
   PARADOX_PASSWORD = 'ndeaomflap';

   // Cantidad de minutos en modo muestra
   MINUTOS_MODO_MUESTRA = 30;

//---------------------------------------------------------------------------
// VARIABLES GLOBALES
//------------------------------------------------------------------------------

var
  logued : String;                 // Almacena nombre de usuario logueado
  CRYP_KEY : Word;                 // Clave de encriptación mutable
  carpeta : String;                // Carpeta de instalación del Programa
  buffer : Array [0..50] of Byte;  // Buffer 50 bytes (BinaryData Registro)
  Reg : TRegistry;                 // Acceso al registro de Windows
  existeCOM : Array[1..8] of Boolean; // Flags que indican si el COM[n] existe
  Nodos : Array of Integer;        // Array global con números de nodos para comando
  f_act : Array[1..7] of LongWord; // Flags de funciones habilitadas actuales
  Timeout_ModoMuestra: Integer;

implementation

uses
  Login, SerKey, Principal, Datos, Comunicaciones, UModem, Demo;

//---------------------------------------------------------------------------
// ALMACENA CADENA EN BITACORA DE OPERACIONES (Bitácora.dat)
//---------------------------------------------------------------------------

procedure bitac(cadena : String);
var
   f : TextFile;
begin
   // Si no existe archivo de bitácora, lo crea
   if not FileExists(carpeta + 'Bitacora.dat') then
   begin
      AssignFile(f, carpeta + 'Bitacora.dat');
      Rewrite(f);
      CloseFile(f);
   end;

   // Abre bitácora y graba registro
   try
     AssignFile(f, carpeta + 'Bitacora.dat');
     Append(f);
     WriteLn(f, Format('%10s %8s %s',
             [DatetoStr(Now), TimetoStr(Now), cadena]));
     Flush(f);
   finally
     CloseFile(f);
   end;
end;

//---------------------------------------------------------------------------
// CONFIGURA LA CLAVE DE ENCRIPTACIÓN ÚNICA DE CADA INSTALACIÓN DEL PROGRAMA
//---------------------------------------------------------------------------

procedure Config_Cript_Key;
var
   Reg : TRegistry;
begin
    Reg := TRegistry.Create;
    Reg.OpenKey(StrREG, True);

    // Chequea si existe en el registro la clave de encriptación (DELAY!!)
    if not Reg.ValueExists('Delay') then
    begin
       // Si no existe, crea una nueva (valor de 16 bits) y la almacena
       //bitac('Creando nueva clave de encriptación del sistema');
       Randomize;
       CRYP_KEY := Random($FFFF);
       Reg.WriteInteger('Delay', CRYP_KEY);
    end
    else
    begin
        // Si existe, la lee del registro
        //bitac('Configurando clave de encriptación del sistema');
        CRYP_KEY := Reg.ReadInteger('Delay');
    end;

    Reg.CloseKey;
    Reg.Destroy;
end;

//---------------------------------------------------------------------------
// CHEQUEA QUE EL MODO DE VIDEO SEA CORRECTO
//---------------------------------------------------------------------------

function Check_Video_Mode : Boolean;
{var
  h: hDC;
  colors: Integer;
  HRes, VRes: Integer;
  check: Boolean;}
begin
   {
   h := 0;  // Inicializa h para evitar "warning"

   // Obtiene la cantidad de colores del video y la resolución usada
   try
     h := GetDC(0);
     Colors := 1 shl (GetDeviceCaps(h, PLANES) * GetDeviceCaps(h, BITSPIXEL));
     HRes := GetDeviceCaps(h, HORZRES);
     VRes := GetDeviceCaps(h, VERTRES);
   finally
     ReleaseDC(0, h);
   end;

   // Si no es un modo de video de 800x600x16c error
   check := (Colors >= 256) and (HRes>=800) and (VRes>=600);

   //if not check then Application.MessageBox('Para ejecutar esta aplicación se necesita por lo menos'#13'un modo de video de 800x600 pixeles y 256 colores.', 'Advertencia', MB_OK + MB_ICONINFORMATION);

   //Result := check;
   }

   Result := True;
end;

//---------------------------------------------------------------------------
// REPRODUCE UN WAV ALMACENADO DENTRO DEL .EXE COMO RESOURCE
//---------------------------------------------------------------------------

procedure PlayWav(wav : String);
var
    Asciz : Array [0..255] of Char;
    lpRes : PChar;
    hRes : THandle;
    hResInfo : THandle;
begin
  if (ReadReg_I('Sonidos') = 1) then
  begin
    StrPCopy(Asciz, wav);  // Convierte nombre a CString
    hResInfo := FindResource(HInstance, Asciz, 'WAVE');  // Busca resource
    if hResInfo <> 0 then
    begin
      hRes := LoadResource(HInstance, hResInfo); // Carga resource

      if hRes <> 0 then
      begin
        lpRes := LockResource(hRes);
        PlaySound(lpRes, 0, SND_ASYNC or SND_MEMORY);
        UnlockResource(hRes);
        FreeResource(hRes);
      end;
    end;
  end;
end;

//---------------------------------------------------------------------------
// OBTIENE VERSIÓN DE ARCHIVO
//---------------------------------------------------------------------------

function GetFileVersion(archivo : String) : string;
var
  Size: Cardinal;
  Handle: Cardinal;
  RezBuffer: string;
  FixedFileInfoBuf  : PVSFixedFileInfo;
begin
  Result := '';
  Size := GetFileVersionInfoSize(PChar(archivo), Handle);
  if Size > 0 then
  begin
    SetLength(RezBuffer, Size);
    if GetFileVersionInfo(PChar(archivo), Handle, Size,
             PChar(RezBuffer)) then
       if VerQueryValue(PChar(RezBuffer), '\', pointer(FixedFileInfoBuf), Size) then
          if Size >= SizeOf(TVSFixedFileInfo) then
            with FixedFileInfoBuf^ do
              Result := Format('v%d.%d.%d.%d', [HIWORD(dwFileVersionMS),
                          LOWORD(dwFileVersionMS), HIWORD(dwFileVersionLS), LOWORD(dwFileVersionLS)]);
  end;
end;

//---------------------------------------------------------------------------
// ENCRIPTA BUFFER
//------------------------------------------------------------------------------

procedure Cript;
var
  i : Byte;
  Key : Word;
begin
  Key := CRYP_KEY;
  for i := 0 to 49 do
  begin
    buffer[i] := buffer[i] xor (Key shr 8);
    //Key := (buffer[i] + Key) * C1 + C2;
  end;
end;

//---------------------------------------------------------------------------
// DESENCRIPTA BUFFER
//------------------------------------------------------------------------------

procedure DeCrip;
var
  i : byte;
  Key : Word;
begin
  Key := CRYP_KEY;
  for i := 0 to 49 do
  begin
    buffer[i] := buffer[i] xor (Key shr 8);
    //Key := (buffer[i] + Key) * C1 + C2;
  end;
end;

//---------------------------------------------------------------------------
// MUESTRA LA VENTANA PARA VALIDACIÓN DEL USUARIO
//---------------------------------------------------------------------------

function Logon : Boolean;
var
   nombre, clave, str, pwd : String;
   i : Integer;
   OK : Boolean;
   s : String;
   Reg : TRegistry;
   sigue : Boolean;
begin
   // En modo descargador no hay ventana de login
   if not llave.modofull then
   begin
     Result := True;
     logued := SUPERUSUARIO;
     Exit;
   end;

   // Parámetro /login funciona sin login
   if False {FindCmdLineSwitch('login', ['/', '-'], True)} then
   begin
        // SuperUsuario
        logued := SUPERUSUARIO;
        Result := True;
   end
   else
   begin
     Result := False;

     repeat  // Repite bucle hasta login OK o botón cancelar

       // Crea ventana de login
       Application.CreateForm(TFLogin, FLogin);

       // Escribe número de versión y número de serie en ventana
       with FLogin.Labelver do
       begin
         Caption := 'SAC32 ' + GetFileVersion(ExtractFilename(Application.ExeName)) +
                    '  ' + DatetoStr(FileDateToDateTime(FileAge(Application.ExeName)));

         //if llave.mododemo then Caption := Caption + ' [DEMO]'
         //else             Caption := Caption + Format(' [Serie:%.05d]', [llave.Serie]);

         // 24/04/2004
         // En modo muestra, muestra otro texto
         if modo_muestra then
         begin
           Caption := Caption + ' MUESTRA';
         end
         else
         begin
           if llave.modofull then Caption := Caption + ' FULL'
           else                   Caption := Caption + ' Descargador';
         end;
       end;

       // Muestra ventana de login y espera OK o Cancelar
       with FLogin do
       begin
          if ShowModal = mrYes then OK := True else OK := False;
          nombre := Editnombre.Text;
          clave := Editpwd.Text;
          Free;
       end;

       // Si presiona botón cancelar, vuelve con False
       if not OK then
       begin
            sigue := False;      // Aborta bucle de login
            Result := False;     // Vuelve con false
       end
       else
       begin
          // Back Door de pruebas
          if ((nombre=SUPERUSUARIO) and (clave=SUPERCLAVE)) or
             ((nombre=USECRETO) and (clave=CSECRETA)) then
          begin
             logued := nombre;    // Almacena usuario logueado
             sigue := False;
             Result := True;
          end
          else   // Chequea nombre y clave en registro
          begin
            Reg := TRegistry.Create;
            Reg.OpenKey(StrREG, True);

            // Lee cadena de nombres
            str := Reg.ReadString('Usuarios');

            // Chequea si existe el usuario en la lista
            if Pos(nombre, str) <> 0 then
            begin
               // Recupera password
               s := 'Usr.' + nombre + '.pwd';
               i := Reg.GetDataSize(s);
               Reg.ReadBinaryData(s, buffer, i);
               DeCrip;  // Desencripta buffer;
               pwd := '';
               for i:=1 to Reg.GetDataSize('Usr.' + nombre + '.pwd') do
                    pwd := pwd + Char(buffer[i-1]);

               // Compara clave tipeada
               if pwd = clave then
               begin
                  // Salva nombre de persona logueada
                  logued := nombre;
                  sigue := False;
                  //bitac('Login del usuario ' + nombre + ' OK');
                  Result := True;
               end
               else // La clave no corresponde
               begin
                   //bitac('Se ingresó mal la clave del usuario ' + nombre);
                   Application.MessageBox('La clave ingresada no es correcta', 'Error', MB_OK + MB_ICONHAND);
                   sigue := True;
               end;
            end
            else // El nombre no existe
            begin
                 //bitac('El usuario ' + nombre + ' no existe');
                 Application.MessageBox('El usuario ingresado no existe', 'Error', MB_OK + MB_ICONHAND);
                 sigue := True;
            end;

            Reg.CloseKey;    // Cierra el acceso al registro
            Reg.Destroy;
          end;
       end;
     until not sigue;
   end;
end;

//---------------------------------------------------------------------------
// CONFIGURA POSICION DE VENTANA PRINCIPAL
//---------------------------------------------------------------------------

procedure Config_Window;
var
   Reg : TRegistry;
begin
    Reg := TRegistry.Create;
    Reg.OpenKey(StrREG, True);

    // Si existe la configuración de la ventana, la lee
    if Reg.ValueExists('Main.Top') and Reg.ValueExists('Main.Left') then
    begin
         FPrincipal.Top := Reg.ReadInteger('Main.Top');
         FPrincipal.Left := Reg.ReadInteger('Main.Left');

         // Si se sale de los límites, centra la ventana en la pantalla
         if ((FPrincipal.Top + FPrincipal.Height) > Screen.Height) or
            ((FPrincipal.Left + FPrincipal.Width) > Screen.Width) then
         begin
           FPrincipal.Top := (Screen.Height - FPrincipal.Height) div 2;
           FPrincipal.Left := (Screen.Width - FPrincipal.Width) div 2;
         end;
    end
    else  // Si no, centra la ventana en el monitor
    begin
         FPrincipal.Top := (Screen.Height - FPrincipal.Height) div 2;
         FPrincipal.Left := (Screen.Width - FPrincipal.Width) div 2;
    end;

    Reg.CloseKey;
    Reg.Destroy;
end;

//------------------------------------------------------------------------------
// LEE VARIABLE ENTERA DEL REGISTRO
//------------------------------------------------------------------------------

function ReadReg_I(v : String) : Integer;
begin
     Reg := TRegistry.Create;
     Reg.OpenKey(StrREG, True);

     if Reg.ValueExists(v) then Result := Reg.ReadInteger(v)
     else                       Result := 0;

     Reg.CloseKey;
     Reg.Destroy;
end;

//------------------------------------------------------------------------------
// LEE VARIABLE STRING DEL REGISTRO
//------------------------------------------------------------------------------

function ReadReg_S(v : String) : String;
begin
     Reg := TRegistry.Create;
     Reg.OpenKey(StrREG, True);

     if Reg.ValueExists(v) then Result := Reg.ReadString(v)
     else                       Result := '';

     Reg.CloseKey;
     Reg.Destroy;
end;

//------------------------------------------------------------------------------
// ESCRIBE VARIABLE ENTERA EN EL REGISTRO
//------------------------------------------------------------------------------

procedure WriteReg_I(v : String; i : Integer);
begin
     Reg := TRegistry.Create;
     Reg.OpenKey(StrREG, True);
     Reg.WriteInteger(v, i);
     Reg.CloseKey;
     Reg.Destroy;
end;

//------------------------------------------------------------------------------
// ESCRIBE VARIABLE STRING EN EL REGISTRO
//------------------------------------------------------------------------------

procedure WriteReg_S(v : String; s : String);
begin
     Reg := TRegistry.Create;
     Reg.OpenKey(StrREG, True);
     Reg.WriteString(v, s);
     Reg.CloseKey;
     Reg.Destroy;
end;

//------------------------------------------------------------------------------
// OBTIENE EN ExisteCOM[] PUERTOS SERIE DISPONIBLES PARA USAR
//------------------------------------------------------------------------------

procedure GetAvailPorts;
var
   Reg : TRegistry;
   i : Integer;
   Val : TStringList;
begin
  // Asume que no hay puertos disponibles
  for i:=1 to 8 do existeCOM[i] := False;

  // Abre registro
  Reg := TRegistry.Create;

  try
     Val := TStringList.Create;    // Crea variable lista de cadenas

     try
        // Clave raíz = HKLM
        Reg.RootKey := HKEY_LOCAL_MACHINE;

        if Reg.OpenKey('Hardware\DeviceMap\SerialComm', False) then
        begin
          Reg.GetValueNames(Val);

          // Chequea los valores buscando 'COM1', 'COM2', etc
          for i:=0 to Val.Count-1 do
             existeCOM[StrtoInt(Copy(Reg.ReadString(Val.Strings[i]), 4, 1))] := True;
        end;

     finally Val.Free;
     end;

  finally Reg.Free;
  end;
end;

//------------------------------------------------------------------------------
// CONVIERTE BINARIO A PACKED BCD
//------------------------------------------------------------------------------

function bin2bcd( i : Byte) : Byte;
begin
     Result := ((i div 10) * 16) + (i - ((i div 10) * 10));
end;

//------------------------------------------------------------------------------
// CHEQUEA SI ENTRÓ EN MODO DEBUG
//------------------------------------------------------------------------------

function debug : Boolean;
begin
    Result := FindCmdLineSwitch('debug', ['/', '-'], True);
end;

//---------------------------------------------------------------------------
// MUESTRA BMP DENTRO DE RESOURCE EN VENTANA
//------------------------------------------------------------------------------

procedure ShowBmp(bmp : String);
var
    name : array [0..20] of Char;
    BM : TBitmap;
begin
    // Crea Bitmap
    BM := TBitmap.Create;

    StrPCopy(name, bmp);
    BM.Handle := LoadBitmap(HInstance, name);
    FPrincipal.Image1.Picture.Graphic := BM;
    DeleteObject(BM.Handle);
    FPrincipal.Image1.Show;

    BM.Free;
end;

//---------------------------------------------------------------------------
// EXPORTA RESOURCES DENTRO DEL EXE EN ARCHIVOS
//------------------------------------------------------------------------------

function ResourceExport(FResourceName, FResourceCategory, FExportFileName: String) : Boolean;
var
   Res, ResHandle : THandle;
   P : ^Char;
   N : integer;
   FS : TFileStream;
begin
   Result := True;   // Asume OK

   Res := FindResource (HInstance, PChar(FResourceName), PChar(FResourceCategory));
   if Res <> 0 then
   begin
      ResHandle := LoadResource(HInstance, Res);
      if ResHandle <> 0 then
      begin
         N := SizeOfResource(HInstance,res) ;
         P := LockResource(ResHandle) ;
         DeleteFile(PChar(FExportFileName));
         FS := TFileStream.Create(FExportFileName, fmCreate);
         FS.Write(P^, N);
         FS.Free;
         UnLockResource(resHandle);
         FreeResource(resHandle);
      end
      else Result := False;
   end
   else Result := False;
end;

//---------------------------------------------------------------------------
// ARMA EL ARRAY CON LOS NODOS A REALIZAR ALGUNA OPERACIÓN
//---------------------------------------------------------------------------

procedure Arma_Array;
var
    i : Integer;
    grupo, nodo : String;
begin
    // Inicializa array de nodos a realizar alguna operación
    SetLength(Nodos, 0);

    if FPrincipal.ActiveControl <> nil then
    begin
      // Se toman como nodos seleccionados los del árbol
      if FPrincipal.ActiveControl.Name = 'ANodos' then
      begin
          // Filtra por grupo y nodo
          case FPrincipal.ANodos.Selected.Level of
          0:      begin      grupo := '%';
                             nodo := '%';
                  end;
          1:      begin      grupo := FPrincipal.ANodos.Selected.Text;
                             nodo := '%';
                  end;
          2:      begin      grupo := FPrincipal.ANodos.Selected.Parent.Text;
                             nodo := FPrincipal.ANodos.Selected.Text;
                  end;
          end;

          // Prepara consulta de nodos
          with data.Consulta do
          begin
              SQL.Clear;
              SQL.Add('SELECT Nod_nom, Nod_num, Gn_nom');
              SQL.Add('FROM Nodos');
              SQL.Add('INNER JOIN GruposNodos');
              SQL.Add('ON  (Nod_grp = Gn_num)');
              SQL.Add('WHERE (Nod_nom like :nodo)');
              SQL.Add('AND (Gn_nom like :grupo)');
              SQL.Add('ORDER BY Gn_nom');
              ParambyName('nodo').AsString := nodo;
              ParambyName('grupo').AsString := grupo;
              Open;

              // Añade los nodos seleccionados al array
              SetLength(Nodos, RecordCount);
              i := 0;
              while not Eof do
              begin
                  Nodos[i] := FieldbyName('nod_num').AsInteger;
                  Next;
                  inc(i);
              end;

              Close;
          end;
      end

      // Se toman como nodos seleccionados los de la lista
      else if FPrincipal.ActiveControl.Name = 'LNodos' then
      begin
        if FPrincipal.LNodos.Selected <> nil then
        begin
          // Recorre todos los nodos buscando los seleccionados
          with FPrincipal.LNodos do
          begin
            for i:=0 to Items.Count-1 do
            begin
              if Items[i].Selected then
              begin
                SetLength(Nodos, Length(Nodos)+1);  // incrementa array
                Nodos[Length(Nodos)-1] := StrtoInt(Items[i].SubItems[0]);
              end;
            end;
          end;
        end
        else
            SetLength(Nodos, 0);
      end;
    end;
end;

//---------------------------------------------------------------------------
// CHEQUEA SI LA FUNCION ESTA HABILITADA
//---------------------------------------------------------------------------

function Habilitada(funcion, subfuncion : Integer; msg : Boolean = True) : Boolean;
begin
    // Si es el superusuario, no hay función que no pueda realizar
    if (logued = SUPERUSUARIO) or (logued = USECRETO) then Result := True
    else
    begin
      Result := (((f_act[funcion] shr (subfuncion-1)) and 1) = 1);

      if ((not Result) and msg) then
         Application.MessageBox('Función no habilitada para este usuario'#13, 'Error', MB_OK + MB_ICONEXCLAMATION);
    end;
end;

//---------------------------------------------------------------------------
// CAMBIA LA PRIORIDAD DEL PROCESO ACTUAL
//---------------------------------------------------------------------------

procedure Set_Prioridad(p : Integer);
var
   h : THandle;
begin
   // IDLE_PRIORITY_CLASS
   // NORMAL_PRIORITY_CLASS
   // HIGH_PRIORITY_CLASS
   // REALTIME_PRIORITY_CLASS
   h := GetCurrentProcess;
   SetPriorityClass(h, REALTIME_PRIORITY_CLASS);
end;

//---------------------------------------------------------------------------
// CONFIGURA VARIABLES PARA FORMATEO DE FECHA Y HORA DEL SISTEMA
//---------------------------------------------------------------------------

procedure Config_Locale;
begin
  DateSeparator := '/';
  TimeSeparator := ':';
  ShortDateFormat := 'dd/MM/yyyy';
  LongDateFormat := 'dddd, dd'' de ''MMMM'' de ''yyyy';
  ShortTimeFormat := 'HH:mm';
  LongTimeFormat := 'HH:mm:ss';
end;

//---------------------------------------------------------------------------
// LEE LA CONFIGURACION DE FUNCIONES HABILITADAS AL USUARIO LOGUEADO
//---------------------------------------------------------------------------

procedure Config_Seguridad;
var
   i, j : Integer;
   Reg : TRegistry;
begin
  // Si está logueado como supersuario habilita todas las funciones
  if (logued = SUPERUSUARIO) or (logued = USECRETO) then
      for i:=1 to 7 do f_act[i] := $FFFFFFFF

  // Si no, lee las funciones del registro (usuario logueado)
  else
  begin
    // Abre acceso al registro
    Reg := TRegistry.Create;
    Reg.OpenKey(StrREG, True);

    // Lee funciones habilitadas del usuario actual
    Reg.ReadBinaryData('Usr.' + logued + '.fun', buffer, 28);
    j := 0;
    for i:=1 to 7 do
    begin
         f_act[i] := (buffer[j] shl 24) + (buffer[j+1] shl 16) +
                    (buffer[j+2] shl 8) + buffer[j+3];
         j := j + 4;
    end;

    // Cierra acceso al registro
    Reg.CloseKey;
    Reg.Destroy;
  end;

  // Habilita o deshabilita comandos que correspondan
  with FPrincipal do
  begin
    cmdABM.Enabled :=           Habilitada(1, 1, False);
    cmdConfig.Enabled :=        Habilitada(2, 1, False);
    cmdReportes.Enabled :=      Habilitada(3, 1, False);
    cmdSeguridad.Enabled :=     Habilitada(4, 1, False);
    cmdLocalizador.Enabled :=   Habilitada(5, 1, False);
    cmdMantenimiento.Enabled := Habilitada(6, 1, False);

    cmdApRemota.Enabled :=  Habilitada(7, 1, False);
    cmdSubir.Enabled :=     Habilitada(7, 2, False);
    cmdBajar.Enabled :=     Habilitada(7, 3, False);
    cmdOpciones.Enabled :=  Habilitada(7, 4, False);
    cmdConsultar.Enabled := Habilitada(7, 5, False);
    cmdReinit.Enabled :=    Habilitada(7, 6, False);

    // Corrección 24/01/2004 - Daniel - Nuevas funciones agregadas a seguridad
    cmdBloquear.Enabled :=  Habilitada(7, 7, False);
    cmdAtender.Enabled :=   Habilitada(7, 8, False);

    // Corrección 13/03/2004 - Daniel - Nueva función agregada a seguridad
    cmdTCPIP.Enabled := Habilitada(7, 9, False);

    mnuApRemota.Enabled :=  cmdApRemota.Enabled;
    mnuSubir.Enabled :=     cmdSubir.Enabled;
    mnuBajar.Enabled :=     cmdBajar.Enabled;
    mnuOpciones.Enabled :=  cmdOpciones.Enabled;
    mnuConsultar.Enabled := cmdConsultar.Enabled;
    mnuReinit.Enabled :=    cmdReinit.Enabled;
  end;
end;

//---------------------------------------------------------------------------
// CARGA EL ARBOL DE NODOS CON TODOS LOS NODOS DE LA BASE
//---------------------------------------------------------------------------

procedure CargaNodos;
var
  Ng, Nn : TTreeNode;
  i : Integer;
  NPC : TTreeNode;
  grupo_existe : Boolean;
  nodo, grupo : String;
begin
  // Realiza consulta de Grupos de Nodos y Nodos
  with data.Consulta do
  begin
    SQL.Clear;
    SQL.Add('SELECT Gn_nom, Nod_nom FROM Nodos');
    SQL.Add('INNER JOIN GruposNodos ON (Nod_grp = Gn_num)');
    Open;

    with FPrincipal.ANodos.Items do
    begin
      // Borra todos los nodos del árbol
      Clear;

      // Crea raiz
      NPC := Add(nil, 'Todos los nodos');
      NPC.ImageIndex := 0;
      NPC.SelectedIndex := 0;

      // Recorre todos los nodos
      while not Eof do
      begin
        grupo := FieldbyName('Gn_nom').AsString;  // nombre del grupo
        nodo := FieldbyName('Nod_nom').AsString;  // nombre del nodo

        // Busca Grupo de Nodos en el árbol
        grupo_existe := False;
        i := 0;
        if NPC.HasChildren then
        begin
          for i:=0 to Count-1 do
          begin
            if Item[i].Text = grupo then
            begin
                grupo_existe := True;
                break;
            end;
          end;
        end;

        // Si el grupo existe en el árbol agrega nodo solamente
        if grupo_existe then
        begin
          Nn := AddChild(Item[i], nodo);
          Nn.ImageIndex := 2;
          Nn.SelectedIndex := 2;
        end
        else  // Si no existe, agrega nuevo grupo y nodo abajo
        begin
          Ng := AddChild(NPC, grupo);
          Ng.ImageIndex := 1;
          Ng.SelectedIndex := 1;

          Nn := AddChild(Ng, nodo);
          Nn.ImageIndex := 2;
          Nn.SelectedIndex := 2;
        end;

        Next;     // Próximo nodo de la tabla
      end;
    end;
    Close;
  end;

  // Expande Grupos de Nodos y selecciona grupo 'todos los nodos'
  with FPrincipal.ANodos do
  begin
    Items.Item[0].Expand(True);
    Selected := Items.Item[0];
  end;

  FPrincipal.ANodosChange(FPrincipal, FPrincipal.ANodos.Selected);   // Actualiza lista de nodos
end;

//---------------------------------------------------------------------------
// INICIALIZA LA VENTANA DE ESTADO DE MODEM SI ESTÁ HABILITADO
//---------------------------------------------------------------------------

procedure InitModem;
var
   Reg : TRegistry;
   m : Integer;
begin
    // Inicializa el modem sólo si está habilitado el módulo correspondiente
    if (llave.Modulos and $0002) = 0 then p.Modem := False
    else
    begin
      // Abre acceso al registro
      Reg := TRegistry.Create;
      Reg.OpenKey(StrREG, True);

      // Lee si debe habilitar el modem
      if Reg.ValueExists('CommModem') then m := Reg.ReadInteger('CommModem')
      else                                 m := 0;
      Reg.WriteInteger('CommModem', m);

      if (m = 1) then
      begin
         p.Modem := True;
         p.Connected := False;

         // Crea la ventana de estado del modem
         Application.CreateForm(TFModem, FModem);
         FModem.Show;
         FModem.Init_Modem(True);
      end
      else p.Modem := False;

      // Cierra acceso al registro
      Reg.CloseKey;
      Reg.Destroy;
    end;
end;

//---------------------------------------------------------------------------
// CONFIGURA LA CARPETA DEL PROGRAMA
//---------------------------------------------------------------------------

procedure Config_Carpeta;
var
   i : Integer;
   s : String;
begin
    s := Lowercase(ExtractFilePath(Application.EXEName));
    for i:=1 to Length(s) do
    begin
         if i=1 then s[i] := Upcase(s[i])
         //else if (s[i-1] = '\') or (s[i-1] = ' ') then s[i] := Upcase(s[i]);
         else if (s[i-1] = '\') then s[i] := Upcase(s[i]);
    end;
    carpeta := s;
end;

//---------------------------------------------------------------------------
// CONFIGURA LAS VARIABLES DEL REGISTRO SI NO EXISTEN
//---------------------------------------------------------------------------

procedure Config_Registro;
var
   R : TRegistry;
   fun : Array[1..7] of LongWord;  // Flags de funciones habilitadas
   i, j : Integer;
   usr, pwd : String;

procedure VarI(nombre : String; valor : Integer);
begin
   if not R.ValueExists(nombre) then R.WriteInteger(nombre, valor);
end;

procedure VarS(nombre : String; valor : String);
begin
   if not R.ValueExists(nombre) then R.WriteString(nombre, valor);
end;

begin
  // Abre acceso al registro
  R := TRegistry.Create;
  R.OpenKey(StrREG, True);

  // Inicializa variables con valores por defecto si no existen
  VarI('AutoConsulta', 0);
  VarI('ModoSubida', 0);
  VarI('BorraEv', 1);
  VarI('CommModem', 0);
  VarI('DescAut', 0);
  VarS('DA_inicio', '12:00:00');
  VarI('DA_interv', 10);
  VarI('DA_Todos', 0);
  // Delay se crea al iniciar clave de encriptación
  VarI('DescTXT', 0);
  VarI('Filtro.Accesos', 1);
  VarI('Filtro.Alarmas', 1);
  VarI('Filtro.ApRemotas', 1);
  VarI('Filtro.Intrusos', 1);
  VarI('Filtro.NodosOffline', 1);
  VarI('Filtro.Transferencias', 1);
  VarI('Filtro.Caducidades', 1);
  VarI('Filtro.FueraHorario', 1);
  VarI('Filtro.Pulsador', 1);
  VarI('Lineas', 20);
  // Main.Left y Main.Top se crean al configurar ventana
  VarI('MuestraEv', 1);
  // Preview.* se crean al ver un reporte
  // puerto se crea al buscar llave de protección
  VarI('Reintentos', 3);
  VarI('Sonidos', 1);
  VarS('TelefonoRemoto', '');
  VarI('Timeout', 100);
  // UBD y UFot se crean despues

  // 05/04/2003 - Agrega la empresa
  VarS('Empresa', 'No configurada');

  if not R.ValueExists('Usuarios') then
  begin
      usr := 'administrador';
      pwd := '1234';
      R.WriteString('Usuarios', usr + ';');

      // Graba clave por defecto de 'administrador'
      for i:=1 to Length(pwd) do buffer[i-1] := Byte(pwd[i]);
      Cript;
      R.WriteBinaryData('Usr.' + usr + '.pwd', buffer, Length(pwd));

      // Escribe funciones habilitadas (7 grupos x 4 bytes = 28 bytes)
      fun[1] := Trunc(Power(2, 17)) - 1;
      fun[2] := Trunc(Power(2, 7)) - 1;
      fun[3] := Trunc(Power(2, 5)) - 1;
      fun[4] := Trunc(Power(2, 8)) - 1;
      fun[5] := Trunc(Power(2, 1)) - 1;
      fun[6] := Trunc(Power(2, 1)) - 1;

      // Corrección 24/01/2004 - Agrega nuevas funciones a seguridad
      //fun[7] := Trunc(Power(2, 6)) - 1;
      fun[7] := Trunc(Power(2, 8)) - 1;

      j := 0;
      for i:=1 to 7 do
      begin
         buffer[j]   := (fun[i] shr 24) and $FF;
         buffer[j+1] := (fun[i] shr 16) and $FF;
         buffer[j+2] := (fun[i] shr 8) and $FF;
         buffer[j+3] := (fun[i]) and $FF;

         j := j + 4;
      end;
      R.WriteBinaryData('Usr.' + usr + '.fun', buffer, 28);
  end;

  // Cierra acceso al registro
  R.CloseKey;
  R.Destroy;
end;

//---------------------------------------------------------------------------
// MUESTRA LA VENTANA DE MODO DEMO
//---------------------------------------------------------------------------

procedure vdemo;
begin
   {
   if llave.mododemo then
   begin
     Application.CreateForm(TFDemo, FDemo);
     FDemo.ShowModal;
     FDemo.Free;
   end;
   }
end;

//---------------------------------------------------------------------------
// MUESTRA LA VENTANA DE MODO DEMO
//---------------------------------------------------------------------------

function Check_COMCTL32 : Boolean;
var
  //Reg : TRegistry;
  //s : String;
  ok : Boolean;
begin
  // Abre acceso al registro
  {
  try
    Reg := TRegistry.Create;
    Reg.RootKey := HKEY_LOCAL_MACHINE;
    Reg.OpenKey('\Software\Microsoft\Windows\CurrentVersion\Setup', True);

    s := GetFileVersion(Reg.ReadString('Sysdir') + '\COMCTL32.DLL');

    // Cierra acceso al registro
    Reg.CloseKey;
    Reg.Destroy;

    // Chequea versión de DLL COMCTL32.DLL
    if s >= 'v4.70' then ok := True else ok := False;

  except
    ok := False;

  end;
  }

  ok := True;    // No chequea por ahora versión

  if not ok then Application.MessageBox('El programa no puede ejecutarse porque'#13'el sistema tiene el archivo COMCTL32.DLL'#13'desactualizado. Por favor actualice este'#13'archivo y luego ejecute el programa', 'Error', MB_OK + MB_ICONEXCLAMATION);
  Result := ok;
end;

//---------------------------------------------------------------------------
// CONFIGURA ARCHIVO DE AYUDA
//---------------------------------------------------------------------------

procedure Config_Ayuda;
begin
    Application.Helpfile := ExtractFilepath(Application.Exename) + 'Sac32.hlp';

    if FindCmdLineSwitch('help', ['/', '-'], True) then
       ShowMessage(Application.HelpFile);
end;

//---------------------------------------------------------------------------
// CONFIGURA LOS PARAMETROS DE LA DESCARGA AUTOMATICA
//---------------------------------------------------------------------------

procedure Config_Desc_Automatica;
begin
    // Lee parámetros de descarga automática
    p.DescAuto.hab := ReadReg_I('DescAut') = 1;
    p.DescAuto.HoraInicio := StrtoDateTime(ReadReg_S('DA_inicio'));
    p.DescAuto.Intervalo := ReadReg_I('DA_interv');
    p.DescAuto.Todos := ReadReg_I('DA_Todos') = 0;
    p.DescAuto.EnProceso := False;
    p.DescAuto.UltimoNodoDescargado := -1;

    // Pregunta si desea iniciar el proceso de descarga automática
    if p.DescAuto.hab then
    begin
      if Application.MessageBox('La descarga automática está habilitada'#13'Desea iniciar el proceso de descarga en este momento?'#13'En caso de indicar que no se esperará el horario configurado',
                                'Atención', MB_YESNO + MB_ICONQUESTION) = IDYES then
      begin
        p.DescAuto.HoraProxDescarga := Now + (p.DescAuto.Intervalo / 1440);
      end
      else
      begin
        // Si el horario de inicio es menor a la hora actual, empieza el día siguiente
        if p.DescAuto.HoraInicio < Time then
           p.DescAuto.HoraProxDescarga := Date + p.DescAuto.HoraInicio + 1
        else
           p.DescAuto.HoraProxDescarga := Date + p.DescAuto.HoraInicio;
      end;
    end;
end;

//---------------------------------------------------------------------------
// VALIDA LAS FRANJAS y GRUPOS DE FRANJAS PARA EL MODO DESCARGADOR
//---------------------------------------------------------------------------

procedure ValidaFranjas;
{var
  qryAux: TQuery;}
begin
  if llave.modofull then Exit;

  {
  qryAux := TQuery.Create(nil);
  qryAux.DatabaseName := datos.Consulta.DatabaseName;
  try

  except
  end;
  qryAux.Free;
  }
end;

//---------------------------------------------------------------------------
// MUESTRA LA VENTANA DE MODO MUESTRA
//---------------------------------------------------------------------------

procedure VentanaModoMuestra;
var
  f: TFModoMuestra;
begin
  if modo_muestra then
  begin
    f := TFModoMuestra.Create(nil);
    try
      f.ShowModal;
    finally
      f.Release;
    end;
  end;
end;

//---------------------------------------------------------------------------
// HUEVO DE PASCUA POR FECHA
//---------------------------------------------------------------------------

procedure EasterEgg;
begin
  // Después de 31/10/2007, no funcionan las comunicaciones (Huevo de Pascuas)
  // Actualización 06/11/2007, saltó la validación por fecha, la cambio
  // a una fecha posterior (15/02/2008)
  // Actualización 18/01/2008, cambio de fecha de huevo de pascua a 15/05/2008
  // Actualización 12/06/2008, cambio de fecha de huevo de pascua a 15/02/2009

  //if SysUtils.Date > EncodeDate(2007, 10, 31) then
  //if SysUtils.Date > EncodeDate(2008, 02, 15) then
  //if SysUtils.Date > EncodeDate(2008, 05, 15) then
  if SysUtils.Date > EncodeDate(2009, 02, 15) then
  begin
    //raise Exception.Create('Access Violation in SAC32@DecodeBuffer procedure. Invalid frame detected in communication buffer');
    // Cambio también el mensaje de error
    raise Exception.Create(
      //'Access Violation in module SAC32. Read of address 30FF6404');
      'Access Violation in module SAC32. Read of address FE01DAE7');
  end;
end;

end.
