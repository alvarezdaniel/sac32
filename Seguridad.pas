//---------------------------------------------------------------------------
//
//  Módulo de Seguridad y Niveles de usuario
//
//  Actualización 05-12-2000
//  Agregado de encriptación de claves 06-12-2000
//  Corrección de bugs de encriptado 09-12-2000
//  Seguridad en módulo (nuevo: permitir modif. de funciones) 09-12-2000
//  Agregado de función de nombre de empresa 11-01-2001
//  Seguridad v2.0: Nuevo sistema de seguridad 11-01-2001
//  Revisión de rutinas 07-02-2001
//  Finalización de Módulo 07-02-2001
//  Agregado de ayuda con F1 03-03-2001
//  Nuevas funciones agregadas a seguridad 24-01-2004
//
//  A Hacer:
//           Mejora de la interfaz
//
//
//---------------------------------------------------------------------------

unit Seguridad;

interface

uses
  Windows, ImgList, Controls, StdCtrls, Buttons, ComCtrls, ToolWin, Classes,
  Forms, Registry, SysUtils, Dialogs, Math;

type
  TFSeg = class(TForm)
    status1: TStatusBar;
    CoolBar1: TCoolBar;
    ToolBar1: TToolBar;
    GroupBox1: TGroupBox;
    GroupBox2: TGroupBox;
    AUsuarios: TTreeView;
    PanelFunciones: TGroupBox;
    ImgSeg: TImageList;
    Funciones: TTreeView;
    btnNuevoUsuario: TToolButton;
    btnBorrarUsuario: TToolButton;
    btnCambiaNombre: TToolButton;
    btnCambiaClave: TToolButton;
    f: TPageControl;
    TabSheet1: TTabSheet;
    TabSheet2: TTabSheet;
    BoxABM: TGroupBox;
    CheckBox101: TCheckBox;
    GConfig: TGroupBox;
    CheckBox201: TCheckBox;
    GroupBox9: TGroupBox;
    CheckBox202: TCheckBox;
    CheckBox203: TCheckBox;
    CheckBox204: TCheckBox;
    CheckBox205: TCheckBox;
    CheckBox206: TCheckBox;
    TabSheet3: TTabSheet;
    TabSheet4: TTabSheet;
    TabSheet5: TTabSheet;
    TabSheet6: TTabSheet;
    GroupBox10: TGroupBox;
    CheckBox301: TCheckBox;
    GroupBox11: TGroupBox;
    CheckBox302: TCheckBox;
    CheckBox303: TCheckBox;
    CheckBox304: TCheckBox;
    CheckBox305: TCheckBox;
    GroupBox12: TGroupBox;
    CheckBox401: TCheckBox;
    GroupBox13: TGroupBox;
    CheckBox402: TCheckBox;
    CheckBox403: TCheckBox;
    CheckBox404: TCheckBox;
    CheckBox405: TCheckBox;
    CheckBox406: TCheckBox;
    GroupBox14: TGroupBox;
    CheckBox501: TCheckBox;
    GroupBox15: TGroupBox;
    CheckBox601: TCheckBox;
    TabSheet7: TTabSheet;
    GroupBox16: TGroupBox;
    GroupBox17: TGroupBox;
    CheckBox701: TCheckBox;
    CheckBox702: TCheckBox;
    CheckBox703: TCheckBox;
    CheckBox704: TCheckBox;
    CheckBox705: TCheckBox;
    PageControl2: TPageControl;
    TabSheet8: TTabSheet;
    TabSheet9: TTabSheet;
    TabSheet10: TTabSheet;
    GroupBox4: TGroupBox;
    CheckBox102: TCheckBox;
    CheckBox103: TCheckBox;
    CheckBox104: TCheckBox;
    GroupBox5: TGroupBox;
    CheckBox105: TCheckBox;
    CheckBox106: TCheckBox;
    CheckBox107: TCheckBox;
    CheckBox108: TCheckBox;
    GroupBox6: TGroupBox;
    CheckBox109: TCheckBox;
    CheckBox110: TCheckBox;
    CheckBox111: TCheckBox;
    GroupBox7: TGroupBox;
    CheckBox112: TCheckBox;
    CheckBox113: TCheckBox;
    CheckBox114: TCheckBox;
    CheckBox115: TCheckBox;
    GroupBox8: TGroupBox;
    CheckBox116: TCheckBox;
    CheckBox117: TCheckBox;
    btnA: TBitBtn;
    btnC: TBitBtn;
    btnCopia: TToolButton;
    CheckBox407: TCheckBox;
    btnSalir: TToolButton;
    CheckBox408: TCheckBox;
    CheckBox207: TCheckBox;
    CheckBox706: TCheckBox;
    CheckBox707: TCheckBox;
    CheckBox708: TCheckBox;
    CheckBox709: TCheckBox;
    procedure FormShow(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure btnNuevoUsuarioClick(Sender: TObject);
    procedure btnBorrarUsuarioClick(Sender: TObject);
    procedure btnCambiaNombreClick(Sender: TObject);
    procedure btnCambiaClaveClick(Sender: TObject);
    procedure FuncionesChange(Sender: TObject; Node: TTreeNode);
    procedure AUsuariosChange(Sender: TObject; Node: TTreeNode);
    procedure CheckBoxClick(Sender: TObject);
    procedure btnAClick(Sender: TObject);
    procedure btnCClick(Sender: TObject);
    procedure btnCopiaClick(Sender: TObject);
    procedure btnSalirClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  FSeg: TFSeg;                    // Form de Módulo de Seguridad
  Reg : TRegistry;                // Acceso al Registro de Windows
  loading : Boolean = False;      // Modo carga de datos
  copiado : Boolean = False;      // Modo copiado
  nombre_actual : String;         // Nombre actual del usuario
  clave_actual : String;          // Clave actual del usuario
  old_str, new_str : String;      // Cadenas de funciones vieja y nueva
  fun : Array[1..7] of LongWord;  // Flags de funciones habilitadas

implementation

uses Principal, Comunicaciones, Pwd, Rutinas;

{$R *.DFM}

//---------------------------------------------------------------------------
// INGRESA AL MÓDULO DE SEGURIDAD
//---------------------------------------------------------------------------

procedure TFSeg.FormShow(Sender: TObject);
var
   cadena, nombre : String;
   i : Integer;
   Usr : TTreeNode;
begin
   // Habilita botones que correspondan al usuario logueado
   btnNuevoUsuario.Enabled :=  Habilitada(4, 2, False);
   btnBorrarUsuario.Enabled := Habilitada(4, 3, False);
   btnCambiaNombre.Enabled :=  Habilitada(4, 4, False);
   btnCambiaClave.Enabled :=   Habilitada(4, 5, False);
   btnCopia.Enabled :=         Habilitada(4, 6, False);
   btnSalir.Enabled :=         True;

   // Crea la variable de Acceso al Registro y abre la clave
   Reg := TRegistry.Create;
   Reg.OpenKey(StrREG, False);

   // Recupera cadena completa de usuarios registrados en el sistema
   cadena := Reg.ReadString('Usuarios');

   // Lee todos los nombres de usuario y los agrega al árbol de usuarios
   i := 1;
   while i<=Length(cadena) do  // Recorre todos los caracteres de cadena
   begin
      nombre := '';
      while cadena[i] <> ';' do    // Recupera nombre hasta ';'
      begin
           nombre := nombre + cadena[i];
           inc(i);
      end;

      // Agrega usuario al árbol
      Usr := AUsuarios.Items.AddChild(AUsuarios.Items[0], nombre);
      Usr.ImageIndex := 1;
      Usr.SelectedIndex := 1;

      // Próximo carácter
      inc(i);
   end;

   // Reordena, expande y selecciona primer nodo del arbol
   with AUsuarios do
   begin
      SortType := stNone;
      SortType := stText;
      FullExpand;
      Selected := Items[0];
   end;

   f.ActivePageIndex := 0;
end;

//---------------------------------------------------------------------------
// ACTUALIZA PANEL DE FUNCIONES CON FUNCIONES HABILITADAS DEL USUARIO
//---------------------------------------------------------------------------

procedure TFSeg.AUsuariosChange(Sender: TObject; Node: TTreeNode);
var
   i, j : Cardinal;
   b : Boolean;
begin
 // Si no se selecciona ningún usuario, desactiva panel de funciones
 if AUsuarios.Selected.Level = 0 then
 begin
   PanelFunciones.Visible := False;
   status1.Simpletext := '';
 end

 // Si es un usuario, muestra sus datos en el panel
 else
 begin
    // Si se selecciona un usuario, muestra funciones habilitadas
    if not copiado then
    begin
      // Muestra solo si está permitido
      if Habilitada(4, 7, False) then
      begin
        PanelFunciones.Visible := True;  // Activa panel de funciones

        // Guarda nombre del usuario
        nombre_actual := AUsuarios.Selected.Text;

        // Lee funciones habilitadas del usuario seleccionado
        Reg.ReadBinaryData('Usr.' + nombre_actual + '.fun', buffer, 28);
        j := 0;
        for i:=1 to 7 do
        begin
             fun[i] := (buffer[j] shl 24) + (buffer[j+1] shl 16) + (buffer[j+2] shl 8) + buffer[j+3];
             j := j + 4;
        end;

        // Lee clave del usuario seleccionado
        Reg.ReadBinaryData('Usr.' + nombre_actual + '.pwd', buffer, Reg.GetDataSize('Usr.' + nombre_actual + '.pwd'));
        DeCrip;
        clave_actual := '';
        for i:=1 to Reg.GetDataSize('Usr.' + nombre_actual + '.pwd') do
             clave_actual := clave_actual + Char(buffer[i-1]);

        // Setea los flags de opciones del usuario seleccionado
        loading := True;
        b := Habilitada(4, 8, False);   // Permite o no edición de funciones

        for i:=1 to 17 do
          with TCheckBox(FindComponent('CheckBox' + InttoStr(i+100))) do
          begin
               Checked := (((fun[1] shr (i-1)) and 1) = 1);
               Enabled := b;
          end;

        for i:=1 to 7 do
          with TCheckBox(FindComponent('CheckBox' + InttoStr(i+200))) do
          begin
               Checked := (((fun[2] shr (i-1)) and 1) = 1);
               Enabled := b;
          end;

        for i:=1 to 5 do
          with TCheckBox(FindComponent('CheckBox' + InttoStr(i+300))) do
          begin
               Checked := (((fun[3] shr (i-1)) and 1) = 1);
               Enabled := b;
          end;

        for i:=1 to 8 do
          with TCheckBox(FindComponent('CheckBox' + InttoStr(i+400))) do
          begin
               Checked := (((fun[4] shr (i-1)) and 1) = 1);
               Enabled := b;
          end;

        for i:=1 to 1 do
          with TCheckBox(FindComponent('CheckBox' + InttoStr(i+500))) do
          begin
               Checked := (((fun[5] shr (i-1)) and 1) = 1);
               Enabled := b;
          end;

        for i:=1 to 1 do
          with TCheckBox(FindComponent('CheckBox' + InttoStr(i+600))) do
          begin
               Checked := (((fun[6] shr (i-1)) and 1) = 1);
               Enabled := b;
          end;

        // Corrección 24/01/2004 - Nuevas funciones agregadas a seguridad
        // Corrección 13/03/2004 - Nuevas funciones agregadas a seguridad
        //for i:=1 to 6 do
        //for i:=1 to 8 do
        for i:=1 to 9 do
          with TCheckBox(FindComponent('CheckBox' + InttoStr(i+700))) do
          begin
               Checked := (((fun[7] shr (i-1)) and 1) = 1);
               Enabled := b;
          end;

        loading := False;

        // Deshabilita botones de aceptar y cancelar
        btnA.enabled := False;
        btnC.enabled := False;

        // Setea cadena con flags actuales
        old_str := Format(' %.05x %.05x %.05x %.05x %.05x %.05x %.05x',
            [fun[1], fun[2], fun[3], fun[4], fun[5], fun[6], fun[7]]);

        status1.SimpleText :=
            'Nombre del Usuario = ' + nombre_actual +
            '   Clave del Usuario = ' + clave_actual;
      end;
    end
    else // Si está en modo copiado, copia flags de ese usuario
    begin
       // Lee cadena de flags del usuario origen y la copia en destino
       Reg.ReadBinaryData('Usr.' + AUsuarios.Selected.Text + '.fun', buffer, 28);
       Reg.WriteBinaryData('Usr.' + nombre_actual + '.fun', buffer, 28);
       copiado := False;        // desactiva modo copiado

       // Selecciona usuario actual y actualiza su panel de funciones
       for i:=0 to AUsuarios.Items.Count-1 do
            if AUsuarios.Items[i].Text = nombre_actual then break;
       AUsuarios.Selected := AUsuarios.Items[i];
       AUsuariosChange(AUsuarios, AUsuarios.Selected);
    end;
 end;
end;

//---------------------------------------------------------------------------
// SALE DEL MÓDULO DE SEGURIDAD
//---------------------------------------------------------------------------

procedure TFSeg.FormClose(Sender: TObject; var Action: TCloseAction);
begin
   // Cierra clave y destruye la variable de Acceso al Registro
   Reg.CloseKey;
   Reg.Destroy;

   // Vuelve a leer funciones para actualizar los cambios realizados
   Config_Seguridad;

   // Cierra la ventana
   Action := caFree;
end;

//---------------------------------------------------------------------------
// CREA UN USUARIO NUEVO CON TODAS LAS FUNCIONES HABILITADAS Y SIN CLAVE
//---------------------------------------------------------------------------

procedure TFSeg.btnNuevoUsuarioClick(Sender: TObject);
var
   cadena: String;
   new_usr, new_pwd: String;
   Usr: TTreeNode;
   i, j: Integer;
begin
   // Recupera cadena con todos los usuarios registrados en el sistema
   cadena := Reg.ReadString('Usuarios');

   // Pregunta nombre del nuevo usuario
   if InputQuery('Nuevo usuario', 'Ingrese el nombre del nuevo usuario', new_usr) then
    // Chequea que no sea nombre nulo
    if new_usr <> '' then
    begin
       // Si no existe ya, lo agrega
       if Pos(new_usr, cadena) = 0 then
       begin
          new_pwd := InputBox('Clave', 'Ingrese la clave del nuevo usuario', '');

          // Agrega usuario al registro
          Reg.WriteString('Usuarios', cadena + new_usr + ';');

          // Graba la clave del usuario
          for i:=1 to Length(new_pwd) do buffer[i-1] := Byte(new_pwd[i]);
          Cript;  // Encripta nueva clave
          Reg.WriteBinaryData('Usr.' + new_usr + '.pwd', buffer, Length(new_pwd));
          //Reg.WriteBinaryData('Usr.' + new_usr + '.pwd', buffer, 0);

          // Escribe funciones habilitadas (7 grupos x 4 bytes = 28 bytes)
          fun[1] := Trunc(Power(2, 17)) - 1;
          fun[2] := Trunc(Power(2, 7)) - 1;
          fun[3] := Trunc(Power(2, 5)) - 1;
          fun[4] := Trunc(Power(2, 8)) - 1;
          fun[5] := Trunc(Power(2, 1)) - 1;
          fun[6] := Trunc(Power(2, 1)) - 1;

          // Corrección 24/01/2004 - Nuevas funciones agregadas a seguridad
          // Corrección 13/03/2004 - Nuevas funciones agregadas a seguridad
          //fun[7] := Trunc(Power(2, 6)) - 1;
          //fun[7] := Trunc(Power(2, 8)) - 1;
          fun[7] := Trunc(Power(2, 9)) - 1;

          j := 0;
          for i:=1 to 7 do
          begin
               buffer[j]   := (fun[i] shr 24) and $FF;
               buffer[j+1] := (fun[i] shr 16) and $FF;
               buffer[j+2] := (fun[i] shr 8) and $FF;
               buffer[j+3] := (fun[i]) and $FF;

               j := j + 4;
          end;
          Reg.WriteBinaryData('Usr.' + new_usr + '.fun', buffer, 28);

          // Agrega usuario al árbol
          Usr := AUsuarios.Items.AddChild(AUsuarios.Items[0], new_usr);
          Usr.ImageIndex := 1;
          Usr.SelectedIndex := 1;
          AUsuarios.Selected := Usr;

          // Reordena arbol
          AUsuarios.SortType := stNone;
          AUsuarios.SortType := stText;

          // Selecciona usuario y muestra sus datos
          AUsuariosChange(AUsuarios, AUsuarios.Selected);
       end
       else Application.MessageBox('El usuario ya existe', 'Error', MB_OK + MB_ICONHAND);
    end
    else Application.MessageBox('Nombre no válido', 'Error', MB_OK + MB_ICONHAND);
end;

//---------------------------------------------------------------------------
// BORRA UN USUARIO EXISTENTE
//---------------------------------------------------------------------------

procedure TFSeg.btnBorrarUsuarioClick(Sender: TObject);
var
   cadena, usr : String;
begin
   // Chequea que se haya seleccionado algún usuario
   if (AUsuarios.Selected <> nil) and (AUsuarios.Selected.Level = 1) then
   begin
      // No se puede borrar al usuario logueado
      if AUsuarios.Selected.Text = logued then
         Application.MessageBox('Imposible borrar al usuario que está '#13'actualmente logueado en el sistema', 'Error', MB_OK + MB_ICONEXCLAMATION)
      else
      begin
        if Application.MessageBox(PChar('Está seguro que quiere borrar a ' + AUsuarios.Selected.Text + '?'), 'Advertencia', MB_YESNO + MB_ICONQUESTION) = ID_YES then
        begin
          cadena := Reg.ReadString('Usuarios');
          usr := AUsuarios.Selected.Text;

          // Elimina del registro al usuario
          Delete(cadena, Pos(usr, cadena), Length(usr)+1);
          Reg.WriteString('Usuarios', cadena);
          Reg.DeleteValue('Usr.' + usr + '.pwd');
          Reg.DeleteValue('Usr.' + usr + '.fun');

          // Elimina del arbol al usuario
          AUsuarios.Items.Delete(AUsuarios.Selected);
        end;
      end;
   end
   else
       Application.MessageBox('No hay ningún usuario seleccionado', 'Error', MB_OK + MB_ICONHAND);
end;

//---------------------------------------------------------------------------
// CAMBIA EL NOMBRE DE UN USUARIO
//---------------------------------------------------------------------------

procedure TFSeg.btnCambiaNombreClick(Sender: TObject);
var
   new_usr, old_usr, str : String;
begin
   // Entra sólo si hay algún usuario seleccionado
   if (AUsuarios.Selected <> nil) and (AUsuarios.Selected.Level = 1) then
   begin
     // Pregunta nombre del nuevo usuario
     if InputQuery('Modifica Usuario', PChar('Cambia nombre de ' + AUsuarios.Selected.Text + ' a:'), new_usr) then
     begin
        str := Reg.ReadString('Usuarios');
        old_usr := AUsuarios.Selected.Text;

        // Cambia nombre en el registro
        Delete(str, Pos(old_usr, str), Length(old_usr)+1);
        str := str + new_usr + ';';
        Reg.WriteString('Usuarios', str);

        Reg.ReadBinaryData('Usr.' + old_usr + '.pwd', buffer, Reg.GetDataSize('Usr.' + old_usr + '.pwd'));
        Reg.WriteBinaryData('Usr.' + new_usr + '.pwd', buffer, Reg.GetDataSize('Usr.' + old_usr + '.pwd'));
        Reg.DeleteValue('Usr.' + old_usr + '.pwd');

        Reg.ReadBinaryData('Usr.' + old_usr + '.fun', buffer, 28);
        Reg.WriteBinaryData('Usr.' + new_usr + '.fun', buffer, 28);
        Reg.DeleteValue('Usr.' + old_usr + '.fun');

        // Cambia el nombre en el árbol
        AUsuarios.Selected.Text := new_usr;

        // Reordena arbol
        AUsuarios.SortType := stNone;
        AUsuarios.SortType := stText;

        // Selecciona usuario y muestra sus datos
        AUsuariosChange(AUsuarios, AUsuarios.Selected);
     end;
   end
   else
       Application.MessageBox('No hay ningún usuario seleccionado', 'Error', MB_OK + MB_ICONHAND);
end;

//---------------------------------------------------------------------------
// CAMBIA LA CLAVE DE UN USUARIO
//---------------------------------------------------------------------------

procedure TFSeg.btnCambiaClaveClick(Sender: TObject);
var
   i: Integer;
begin
   // Entra sólo si hay un usuario seleccionado
   if (AUsuarios.Selected <> nil) and (AUsuarios.Selected.Level = 1) then
   begin
     Application.CreateForm(TFPwd, FPwd);
     with FPwd do
     begin
        Caption := 'Cambio de clave de ' + nombre_actual;

        // Muestra ventana de cambio de clave
        if ShowModal = mrYes then
        begin
           // Chequea que clave anterior corresponda
           if Editpwd1.Text = clave_actual then
           begin
              // Chequea que la clave nueva se haya escrito dos veces igual
              if Editpwd2.Text = Editpwd3.Text then
              begin
                 // Graba nueva clave
                 for i:=1 to Length(Editpwd2.Text) do
                     buffer[i-1] := Byte(Editpwd2.Text[i]);
                 Cript;  // Encripta nueva clave
                 Reg.WriteBinaryData('Usr.' + nombre_actual + '.pwd', buffer, Length(Editpwd2.Text));

                 // Refleja el cambio en el panel
                 AUsuariosChange(AUsuarios, AUsuarios.Selected);
              end
              else Application.MessageBox('La nueva clave se debe escribir dos veces para confirmarla', 'Error', MB_OK + MB_ICONHAND);
           end
           else Application.MessageBox('La clave anterior no es correcta', 'Error', MB_OK + MB_ICONHAND);
        end;

        Free;
     end;
   end
   else Application.MessageBox('No hay ningún usuario seleccionado', 'Error', MB_OK + MB_ICONHAND);
end;

//---------------------------------------------------------------------------
// COPIA LOS FLAGS DE OTRO USUARIO
//---------------------------------------------------------------------------

procedure TFSeg.btnCopiaClick(Sender: TObject);
begin
   if (AUsuarios.Selected <> nil) and (AUsuarios.Selected.Level = 1) then
   begin
     if AUsuarios.Selected.Text = logued then
        Application.MessageBox('No se pueden cargar las opciones al usuario actualmente logueado', 'Mensaje', MB_OK + MB_ICONINFORMATION)
     else
     begin
       PanelFunciones.Visible := False;
       AUsuarios.Cursor := crMultidrag;
       btnNuevoUsuario.Enabled := False;
       btnBorrarUsuario.Enabled := False;
       btnCambiaNombre.Enabled := False;
       btnCambiaClave.Enabled := False;
       btnCopia.Enabled := False;
       btnSalir.Enabled := False;
       copiado := True;

       Application.MessageBox('Seleccionar el usuario del cual tomar las opciones', 'Mensaje', MB_OK + MB_ICONINFORMATION);

       // Espera a que se elija algún usuario para copiar
       while copiado do Application.ProcessMessages;

       PanelFunciones.Visible := True;
       AUsuarios.Cursor := crDefault;
       btnNuevoUsuario.Enabled := Habilitada(4, 2, False);
       btnBorrarUsuario.Enabled := Habilitada(4, 3, False);
       btnCambiaNombre.Enabled := Habilitada(4, 4, False);
       btnCambiaClave.Enabled := Habilitada(4, 5, False);
       btnCopia.Enabled := Habilitada(4, 6, False);
       btnSalir.Enabled := True;
     end;
   end
   else
       Application.MessageBox('No hay ningún usuario seleccionado', 'Error', MB_OK + MB_ICONHAND);
end;

//---------------------------------------------------------------------------
// CIERRA LA VENTANA
//---------------------------------------------------------------------------

procedure TFSeg.btnSalirClick(Sender: TObject);
begin
     Close;
end;

//---------------------------------------------------------------------------
// CAMBIA DE PÁGINA DE FUNCIONES
//---------------------------------------------------------------------------

procedure TFSeg.FuncionesChange(Sender: TObject; Node: TTreeNode);
begin
  with Funciones do
  begin
    if Selected = Items[0] then        f.ActivePageIndex := 0
    else if Selected = Items[1] then   f.ActivePageIndex := 1
    else if Selected = Items[2] then   f.ActivePageIndex := 2
    else if Selected = Items[3] then   f.ActivePageIndex := 3
    else if Selected = Items[4] then   f.ActivePageIndex := 4
    else if Selected = Items[5] then   f.ActivePageIndex := 5
    else if Selected = Items[6] then   f.ActivePageIndex := 6;
  end;
end;

//---------------------------------------------------------------------------
// ACTUALIZA OPCIONES CADA VEZ QUE SE MODIFICA UN FLAG
//---------------------------------------------------------------------------

procedure TFSeg.CheckBoxClick(Sender: TObject);
var
   i, j : Integer;
begin
   if not loading then
   begin
      if (AUsuarios.Selected.Text = logued) and
         (Pos('CheckBox4', (Sender as TCheckBox).Name) > 0) then
      begin
         loading := True;
         (Sender as TCheckBox).Checked := True;
         loading := False;
         Application.MessageBox('No se puede deshabilitar seguridad para el usuario logueado', 'Error', MB_OK + MB_ICONHAND);
      end
      else
      begin
        // Habilita o deshabilita grupo de funciones
        if ((Sender as TCheckBox).Name = 'CheckBox101') then
           for i:=102 to 117 do
               TCheckBox(FindComponent('CheckBox' + InttoStr(i))).Checked :=
                                            (Sender as TCheckBox).Checked;

        if ((Sender as TCheckBox).Name = 'CheckBox201') then
           for i:=202 to 207 do
               TCheckBox(FindComponent('CheckBox' + InttoStr(i))).Checked :=
                                            (Sender as TCheckBox).Checked;

        if ((Sender as TCheckBox).Name = 'CheckBox301') then
           for i:=302 to 305 do
               TCheckBox(FindComponent('CheckBox' + InttoStr(i))).Checked :=
                                            (Sender as TCheckBox).Checked;

        if ((Sender as TCheckBox).Name = 'CheckBox401') then
           for i:=402 to 408 do
               TCheckBox(FindComponent('CheckBox' + InttoStr(i))).Checked :=
                                            (Sender as TCheckBox).Checked;

        // Selecciona grupo de funciones y función
        j := StrtoInt(Copy((Sender as TCheckBox).Name, 9, 1));
        i := StrtoInt(Copy((Sender as TCheckBox).Name, 10, 2));

        // Activa o desactiva función
        if (Sender as TCheckBox).Checked then
             fun[j] := fun[j] or Trunc(Power(2, i-1))
        else
             fun[j] := fun[j] and not(Trunc(Power(2, i-1)));

        // Arma nueva cadena con modificaciones de flags
        new_str := Format(' %.05x %.05x %.05x %.05x %.05x %.05x %.05x',
                [fun[1], fun[2], fun[3], fun[4], fun[5], fun[6], fun[7]]);

        // Si hay algún cambio, habilita botones y muestra cambio
        if old_str <> new_str then
        begin
           btnA.enabled := True;
           btnC.enabled := True;
           status1.SimpleText := 'Nombre del Usuario = ' + nombre_actual +
                '   Clave del Usuario = ' + clave_actual + '' + {new_str +} ' (Modificado)';
        end
        else
        begin
           btnA.enabled := False;
           btnC.enabled := False;
           status1.SimpleText := 'Nombre del Usuario = ' + nombre_actual +
                '   Clave del Usuario = ' + clave_actual + ''; {+ new_str; }
        end;
      end;
   end;
end;

//---------------------------------------------------------------------------
// ACEPTA LOS CAMBIOS Y GRABA EL REGISTRO
//---------------------------------------------------------------------------

procedure TFSeg.btnAClick(Sender: TObject);
var
   i, j : Integer;
begin
    // Escribe funciones habilitadas (7 grupos x 4 bytes = 28 bytes)
    j := 0;
    for i:=1 to 7 do
    begin
         buffer[j]   := (fun[i] shr 24) and $000000FF;
         buffer[j+1] := (fun[i] shr 16) and $000000FF;
         buffer[j+2] := (fun[i] shr 8) and $000000FF;
         buffer[j+3] := (fun[i]) and $000000FF;

         j := j + 4;
    end;
    Reg.WriteBinaryData('Usr.' + nombre_actual + '.fun', buffer, 28);

    btnA.enabled := False;
    btnC.enabled := False;
    AUsuariosChange(AUsuarios, AUsuarios.Selected);
end;

//---------------------------------------------------------------------------
// CANCELA LOS CAMBIOS
//---------------------------------------------------------------------------

procedure TFSeg.btnCClick(Sender: TObject);
begin
    new_str := old_str;
    btnA.enabled := False;
    btnC.enabled := False;
    AUsuariosChange(AUsuarios, AUsuarios.Selected);
end;

end.
