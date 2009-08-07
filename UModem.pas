//---------------------------------------------------------------------------
//
//  Módulo de Información de Estado del Modem
//
//
// Inicio 13-12-2000
// Muestra estado del modem, paquetes rx'd y tx'd, led de ping y led de online
// Chequeo OK
// Agregado de reintentos de ping 19-12-2000
//
//---------------------------------------------------------------------------

unit UModem;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, Buttons, ComCtrls, ExtCtrls, AdStatLt, OoMisc, Menus, mmsystem;

type
  TFModem = class(TForm)
    btnConec: TSpeedButton;
    btnDesc: TSpeedButton;
    TimerPing: TTimer;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    ping: TApdStatusLight;
    Label5: TLabel;
    Label6: TLabel;
    online: TApdStatusLight;
    Image1: TImage;
    mnu1: TPopupMenu;
    ClearCnt: TMenuItem;
    Label7: TLabel;
    Bevel1: TBevel;
    Label8: TLabel;
    procedure FormShow(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure btnDescClick(Sender: TObject);
    procedure btnConecClick(Sender: TObject);
    procedure TimerPingTimer(Sender: TObject);
    procedure ClearCntClick(Sender: TObject);
  private
    { Private declarations }
    procedure WMNCHitTest(var M: TWMNCHitTest); message wm_NCHitTest;
  public
    { Public declarations }
    procedure Init_Modem(pregunta : Boolean);
    procedure Free_Modem(consulta : Boolean);
  end;

var
  FModem: TFModem;
  pinging : Boolean = False;
  reintentos : Integer = 0;

implementation

uses Comunicaciones, Principal, Rutinas;

{$R *.DFM}

//---------------------------------------------------------------------------
// AL MOSTRAR EL FORM, OCULTA BARRA DE CAPTION Y UBICA El POSICION GRABADA
//---------------------------------------------------------------------------

procedure TFModem.FormShow(Sender: TObject);
{var
  Save : LongInt;}
begin
  // Oculta la barra de caption
  {Save := GetWindowLong(FModem.Handle, gwl_Style);
  SetWindowLong(FModem.Handle, gwl_Style, (Save and (not ws_Caption)));
  FModem.Height := FModem.Height - getSystemMetrics(sm_cyCaption);
  FModem.Refresh;}

  Height := 76; //52;

  // Configura la posición de la ventana
  if ReadReg_I('Modem.Top') = 0 then
  begin
       // Si no está grabada, centra la ventana en la pantalla
       Top := (Screen.Height - Height) div 2;
       Left := (Screen.Width - Width) div 2;
  end
  else
  begin
       Top := ReadReg_I('Modem.Top');
       Left := ReadReg_I('Modem.Left');
  end;
end;

//---------------------------------------------------------------------------
// HACE QUE SE PUEDA MOVER LA VENTANA CLIQUEANDO EN CUALQUIER PARTE
//---------------------------------------------------------------------------

procedure TFModem.WMNCHitTest(var M: TWMNCHitTest);
begin
  inherited;                    { call the inherited message handler }
  //if M.Result = htClient then   { is the click in the client area?   }
  //  M.Result := htCaption;      { if so, make Windows think it's     }
                                { on the caption bar.                }
end;

//---------------------------------------------------------------------------
// GRABA LA UBICACIÓN DE LA VENTANA AL SALIR
//---------------------------------------------------------------------------

procedure TFModem.FormClose(Sender: TObject; var Action: TCloseAction);
begin
    // Desconecta la conexión remota
    Free_Modem(False);

    // Graba ubicación de la ventana principal
    WriteReg_I('Modem.Top', Top);
    WriteReg_I('Modem.Left', Left);

    // Cierra el programa
    Action := caFree;
end;

//---------------------------------------------------------------------------
// INICIALIZA EL MODEM
//------------------------------------------------------------------------------

procedure TFModem.Init_Modem(pregunta : Boolean);
var
   sale : Boolean;
   conecta : Boolean;
begin
   // Habilita botones
   p.Connected := False;
   FModem.btnConec.Enabled := p.Connected;
   FModem.btnDesc.Enabled := p.Connected;
   FModem.online.Lit := p.Connected;
   FModem.ping.Lit := p.Connected; 

   // Manda al modem que corte (online u offline)
   FCom.port1.FlushInBuffer;
   FCom.port1.OutPut := '#         $';
   Label7.Caption := 'Verificando modem...';

   // Espera la cadena 'OFFLINE'
   if FCom.port1.WaitForString('OFFLINE', 100, True, False) then
   begin
    Label7.Caption := 'Modem fuera de línea';

    // Debe preguntar antes de conectar?
    if pregunta then
       conecta := (Application.MessageBox('Desea iniciar sesión de comunicaciones remotas?', 'Conexión por Modem', MB_YESNO + MB_ICONQUESTION) = IDYES)
    else
       conecta := True;

    // Si debe conectar, intenta conexión
    if conecta then
    begin
       sale := False;

       while not sale do
       begin
         // Disca el número configurado
         FCom.port1.FlushInBuffer;
         FCom.port1.OutPut := 'D' + Trim(ReadReg_S('TelefonoRemoto')) + '$';
         Label7.Caption := 'Discando ' + Trim(ReadReg_S('TelefonoRemoto') + '...');
         sleep(500);
         Label7.Caption := 'Esperando respuesta...';

         // Espera respuesta del modem
         case FCom.port1.WaitForMultiString('NO DIALTONE^NO CARRIER^CONNECT FSK', 600, True, False, '^') of

         0: begin // El modem no responde
                Label7.Caption := 'Modem local no responde';
                Application.MessageBox('El modem local parece estar apagado o desconectado de la PC'#13'Verificar puerto serie configurado, conexión del modem a la computadora y el encendido del modem.'#13, 'Error', MB_OK + MB_ICONHAND);
                p.Connected := False;
                TimerPing.Enabled := False;
                sale := True;
            end;

         1: begin  // La línea no tiene tono
                Label7.Caption := 'No hay tono de discado';
                if Application.MessageBox('No hay tono de discado'#13'Verificar que el modem esté conectado a la línea telefónica y esta tenga tono'#13'Desea volver a intentar la conexión?', 'Error', MB_RETRYCANCEL + MB_ICONHAND) = IDCANCEL then
                begin
                   p.Connected := False;
                   TimerPing.Enabled := False;
                   sale := True;
                end;
            end;
         2: begin // El modem remoto no responde o línea ocupada
                Label7.Caption := 'Modem remoto no responde';
                if Application.MessageBox('El modem remoto no responde, la línea da ocupado'#13'o el número de teléfono a discar no es correcto'#13'Desea volver a intentar la conexión?', 'Error', MB_RETRYCANCEL + MB_ICONHAND) = IDCANCEL then
                begin
                   p.Connected := False;
                   TimerPing.Enabled := False;
                   sale := True;
                end;
            end;
         3: begin // El modem se conectó con el otro OK
                  Label7.Caption := 'Modem en línea';
                  sleep(500);
                  p.Connected := True;
                  FModem.online.Lit := True;
                  TimerPingTimer(TimerPing);   // realiza el primer ping
                  TimerPing.Enabled := True;   // habilita el timer de pings
                  sale := True;
            end;
         end;
       end;
    end
    else
    begin
      p.Connected := False;
      TimerPing.Enabled := False;
    end;
   end
   else
   begin // Si no hay respuesta, el modem no está conectado o está apagado
      Label7.Caption := 'Modem local no responde';
      Application.MessageBox('El modem local parece estar apagado o desconectado de la PC'#13'Verificar puerto serie configurado, conexión del modem a la computadora y el encendido del modem.'#13, 'Error', MB_OK + MB_ICONHAND);
   end;

   // Habilita botones
   FModem.btnConec.Enabled := not p.Connected;
   FModem.btnDesc.Enabled := p.Connected;  
end;

//---------------------------------------------------------------------------
// CIERRA LA CONEXIÓN CON EL MODEM
//------------------------------------------------------------------------------

procedure TFModem.Free_Modem(consulta : Boolean);
begin
   // Manda al modem que corte
   FCom.port1.FlushInBuffer;
   FCom.port1.OutPut := '#         $';
   Label7.Caption := 'Cortando conexión...';

   // Espera la cadena 'OFFLINE'
   if consulta then
   begin
     if FCom.port1.WaitForString('OFFLINE', 100, True, False) then
          Label7.Caption := 'Modem fuera de línea'
     else
     begin // Si no hay respuesta, el modem no está conectado o está apagado
        Label7.Caption := 'El modem no responde';
        Application.MessageBox('El modem local parece estar apagado o desconectado de la PC'#13'Verificar puerto serie configurado, conexión del modem a la computadora y el encendido del modem.'#13, 'Error', MB_OK + MB_ICONHAND);
     end;
   end;

   p.Connected := False;
   FModem.online.Lit := False;
   TimerPing.Enabled := False;
   FCom.port1.FlushInBuffer;
   FCom.port1.FlushOutBuffer;

   // Habilita botones
   FModem.btnConec.Enabled := not p.Connected;
   FModem.btnDesc.Enabled := p.Connected; 

   Label7.Caption := 'Modem fuera de línea'
end;

//---------------------------------------------------------------------------
// PRESIONA EL BOTÓN DE DESCONECTAR
//------------------------------------------------------------------------------

procedure TFModem.btnDescClick(Sender: TObject);
begin
     Free_Modem(True);
end;

//---------------------------------------------------------------------------
// PRESIONA EL BOTÓN DE CONECTAR
//------------------------------------------------------------------------------

procedure TFModem.btnConecClick(Sender: TObject);
begin
     Init_Modem(False);
end;

//---------------------------------------------------------------------------
// REALIZA EL PING AL MODEM REMOTO
//------------------------------------------------------------------------------

procedure TFModem.TimerPingTimer(Sender: TObject);
begin
   // Manda al modem comando de ping
   Pinging := True;
   ping.Lit := True;
   FCom.port1.FlushInBuffer;
   FCom.port1.OutPut := '?PINGING...';
   Label7.Caption := 'Sincronizando modems';
   Label8.Caption := InttoStr(StrtoInt(Label8.Caption)+1);

   if not FCom.port1.WaitForString('~PINGING...', 10, True, False) then
   begin
        // El modem remoto parece haberse desconectado
        ping.Lit := False;

        inc(reintentos);
        if reintentos > 3 then
        begin
          reintentos := 0;
          Label7.Caption := 'El modem remoto se desconectó';
          //sndPlaySound('Glass.wav', 0);
          PlayWav('GLASS');
          Free_Modem(False);

          if Application.MessageBox('El enlace con el modem remoto ha sido cortado.'#13'Desea restablecer la comunicación?', 'Advertencia', MB_YESNO + MB_ICONQUESTION) = IDYES then
             Init_Modem(False);
        end
        else
        begin
             sleep(500);
             FModem.TimerPingTimer(Self);
        end;
   end
   else
   begin
        // El modem remoto contesta ping
        reintentos := 0;
        ping.Lit := False;
        Label7.Caption := 'Modem en línea';
        p.Connected := True;
   end;

   Pinging := False;
end;

//---------------------------------------------------------------------------
// PONE A CERO CONTADORES DE PAQUETES
//------------------------------------------------------------------------------

procedure TFModem.ClearCntClick(Sender: TObject);
begin
     Label3.Caption := '0';
     Label4.Caption := '0';
end;

end.
