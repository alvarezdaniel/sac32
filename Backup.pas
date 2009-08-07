//---------------------------------------------------------------------------
//
//  Módulo de Backup de las categorias del sistema
//
//
// Inicio de la interfaz 25-01-2001
// Backup de categorias en archivo por Categoría 26-01-2001
// Fin de rutinas, agregado de encriptación de datos 27-01-2001
//
//---------------------------------------------------------------------------

unit Backup;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  Buttons, StdCtrls, ExtCtrls;

type
  TFBackup = class(TForm)
    GroupBox1: TGroupBox;
    btnSalir: TSpeedButton;
    btnBackup: TSpeedButton;
    btnRestore: TSpeedButton;
    rg: TRadioGroup;
    open: TOpenDialog;
    save: TSaveDialog;
    procedure btnSalirClick(Sender: TObject);
    procedure btnBackupClick(Sender: TObject);
    procedure btnRestoreClick(Sender: TObject);
  private
    { Private declarations }
    procedure Busca(s : String);
    procedure Escribe_Backup;
    procedure Lee_Backup;
    function crip(c : Char) : Char;
    function decr(c : Char) : Char;
    { Public declarations }
  end;

  // Tipo archivo para crear array
  archivo = record
          name : String;
          size : LongWord;
  end;

var
  FBackup: TFBackup;
  categoria : String;               // Nombre de la categoria actual
  dirbase : String;                 // Carpeta donde está la base de datos
  archivos : Array of archivo;      // Lista de archivos a Backupear

implementation

uses Rutinas;

{$R *.DFM}

//---------------------------------------------------------------------------
// VUELVE A LA VENTANA DE MANTENIMIENTO
//---------------------------------------------------------------------------

procedure TFBackup.btnSalirClick(Sender: TObject);
begin
     Close;
end;

//---------------------------------------------------------------------------
// PRESIONA EL BOTON PARA GUARDAR ARCHIVOS
//---------------------------------------------------------------------------

procedure TFBackup.btnBackupClick(Sender: TObject);
begin
   // Selecciona categoría de datos a grabar
   case rg.ItemIndex of
   0: categoria := 'Personas';
   1: categoria := 'Nodos';
   2: categoria := 'Asignaciones';
   3: categoria := 'Eventos';
   end;

   // Lee ubicación de base de datos
   dirbase := ReadReg_S('UBD');

   // Directorio inicial = Carpeta donde está instalado programa
   save.InitialDir := dirbase;
   // Propone un nombre de archivo basado en categoría y fecha
   save.FileName := dirbase + '\' + categoria + ' (' + StringReplace(DateToStr(Now), '/', '-', [rfReplaceAll]) + ').sac';
   // Pone un título al cuadro de dialogo
   save.Title := 'Guardar datos de ' + categoria + ' en';

   // Si presiona Aceptar guarda el backup
   if save.Execute then Escribe_Backup;
end;

//---------------------------------------------------------------------------
// PRESIONA EL BOTON PARA RECUPERAR ARCHIVOS
//---------------------------------------------------------------------------

procedure TFBackup.btnRestoreClick(Sender: TObject);
begin
   // Selecciona categoría de datos a grabar
   case rg.ItemIndex of
   0: categoria := 'Personas';
   1: categoria := 'Nodos';
   2: categoria := 'Asignaciones';
   3: categoria := 'Eventos';
   end;

   // Lee ubicación de base de datos
   dirbase := ReadReg_S('UBD');

   // Directorio inicial = Carpeta donde está instalado el prograna
   open.InitialDir := dirbase;
   // Pone un título al cuadro de dialogo
   open.Title := 'Recuperar datos de ' + categoria + ' desde';

   // Si presiona Aceptar recupera el backup
   if open.Execute then Lee_Backup;
end;

//---------------------------------------------------------------------------
// DEVUELVE LA LISTA DE ARCHIVOS CON UN NOMBRE DADO (TODAS LAS EXTENSIONES)
//---------------------------------------------------------------------------

procedure TFBackup.Busca(s : String);
var
   sr: TSearchRec;
   fhnd : Integer;
begin
    // Si encuentra alguno...
    if FindFirst(s , faAnyFile, sr) = 0 then
    begin
      // Incrementa contador de archivos
      SetLength(archivos, Length(archivos)+1);

      // Configura nombre del archivo
      archivos[Length(archivos)-1].name := sr.Name;

      // Configura tamaño del archivo
      fhnd := FileOpen(dirbase + '\' + sr.Name, fmOpenRead);
      archivos[Length(archivos)-1].size := GetFileSize(fhnd, nil);
      FileClose(fhnd);

      // Si sigue habiendo más...
      while FindNext(sr) = 0 do
      begin
          // Incrementa contador de archivos
          SetLength(archivos, Length(archivos)+1);

          // Configura nombre del archivo
          archivos[Length(archivos)-1].name := sr.Name;

          // Configura tamaño del archivo
          fhnd := FileOpen(dirbase + '\' + sr.Name, fmOpenRead);
          archivos[Length(archivos)-1].size := GetFileSize(fhnd, nil);
          FileClose(fhnd);
      end;

      FindClose(sr);
    end;
end;

//---------------------------------------------------------------------------
// GUARDA LOS ARCHIVOS DENTRO DEL BACKUP
//---------------------------------------------------------------------------

procedure TFBackup.Escribe_Backup;
var
   fi, fo : File of Char;
   i, n : Integer;
   Buffer : String;
   c : Char;
   TotalBytes, ActualBytes : LongWord;
begin
    // Deshabilita botones y pone cursor de reloj de arena
    btnBackup.Enabled := False;
    btnRestore.Enabled := False;
    btnSalir.Enabled := False;
    Screen.Cursor := crHourglass;

    // Arma lista de archivos a almacenar en array {archivos}
    SetLength(archivos, 0);

    if categoria = 'Personas' then
    begin
         Busca(dirbase + '\Usuarios.*');
         Busca(dirbase + '\GruposAcceso.*');
    end
    else if categoria = 'Nodos' then
    begin
         Busca(dirbase + '\Nodos.*');
         Busca(dirbase + '\GruposNodos.*');
    end
    else if categoria = 'Asignaciones' then
         Busca(dirbase + '\Asignaciones.*')

    else if categoria = 'Eventos' then
         Busca(dirbase + '\Eventos.*');

    // Abre archivo de backup para escritura (nuevo archivo)
    AssignFile(fo, save.FileName);
    Rewrite(fo);

    // Escribe Header del Backup (20 bytes)
    Buffer := 'SAC32 Backup v1.0.0 ';
    for i:=1 to Length(Buffer) do Write(fo, Buffer[i]);

    // Escribe categoría de las tablas guardadas + '$'
    for i:=1 to Length(categoria) do Write(fo, categoria[i]);
    c := '$';  Write(fo, c);

    // Escribe Cantidad de archivos almacenados
    c := Char(Length(archivos));    Write(fo, c);

    // Inicializa variables para porcentaje de progreso
    ActualBytes := 0;
    TotalBytes := 0;
    for n:=0 to Length(archivos)-1 do TotalBytes := TotalBytes + archivos[n].size;

    // Escribe lista de archivos (nombre y tamaño)
    for n:=0 to Length(archivos)-1 do
    begin
       // Escribe nombre del archivo + '$'
       for i:=1 to Length(archivos[n].name) do Write(fo, archivos[n].name[i]);
       c := '$';  Write(fo, c);

       // Escribe tamaño del archivo (4 bytes)
       c := Char(((archivos[n].size and $FF000000) shr 24) and $FF);  Write(fo, c);
       c := Char(((archivos[n].size and $00FF0000) shr 16) and $FF);  Write(fo, c);
       c := Char(((archivos[n].size and $0000FF00) shr 8) and $FF);   Write(fo, c);
       c := Char((archivos[n].size and $000000FF) and $FF);           Write(fo, c);
    end;

    // Guarda caption para después
    Buffer := FBackup.Caption;

    // Escribe el contenido de los archivos en el backup
    for n:=0 to Length(archivos)-1 do
    begin
      // Abre el archivo para lectura
      AssignFile(fi, dirbase + '\' + archivos[n].name);
      Reset(fi);

      // Copia de archivo a backup mientras no termine archivo
      while not Eof(fi) do
      begin
         Read(fi, c);        c:= crip(c);    Write(fo, c);
         inc(ActualBytes);
         FBackup.Caption := Format('Almacenando en backup %02.0f%%', [(ActualBytes*100)/TotalBytes]);
      end;

      // Cierra el archivo origen
      CloseFile(fi);
    end;

    // Cierra archivo de backup
    CloseFile(fo);

    // Recupera caption de ventana
    FBackup.Caption := Buffer;
    // Vuelve el cursor a la normalidad y habilita botones
    btnBackup.Enabled := True;
    btnRestore.Enabled := True;
    btnSalir.Enabled := True;
    Screen.Cursor := crDefault;

    Application.MessageBox('Almacenamiento de datos completo', 'Backup', MB_OK + MB_ICONEXCLAMATION);
end;

//---------------------------------------------------------------------------
// LEE EL ARCHIVO DE BACKUP Y RECUPERA LOS ARCHIVOS
//---------------------------------------------------------------------------

procedure TFBackup.Lee_Backup;
var
   fi, fo : File of Char;
   i, n : Integer;
   Buffer : String;
   c : Char;
   TotalBytes, ActualBytes : LongWord;
   s : LongWord;
begin
    // Deshabilita botones y pone cursor de reloj de arena
    btnBackup.Enabled := False;
    btnRestore.Enabled := False;
    btnSalir.Enabled := False;
    Screen.Cursor := crHourglass;

    // Abre archivo de backup para lectura
    AssignFile(fi, open.FileName);
    Reset(fi);

    // Verifica el Header del backup
    Buffer := '';
    for i:=1 to 20 do begin Read(fi, c);  Buffer := Buffer + c; end;
    if Buffer <> 'SAC32 Backup v1.0.0 ' then
           Application.MessageBox('El archivo seleccionado no corresponde a un backup válido', 'Error', MB_OK + MB_ICONHAND)
    else
    begin
      // Verifica que el tipo de categorias guardadas corresponda
      Buffer := '';
      repeat Read(fi, c);  if c<>'$' then Buffer := Buffer + c;
      until c = '$';

      if Buffer <> categoria then
           Application.MessageBox('El archivo seleccionado no corresponde al tipo de datos seleccionado', 'Error', MB_OK + MB_ICONHAND)
      else
      begin
         // Lee cantidad de archivos almacenados y configura array de archivos
         Read(fi, c);    i := Ord(c);
         SetLength(archivos, i);

         // Inicializa variables para porcentaje de progreso
         ActualBytes := 0;
         TotalBytes := 0;

         // Lee nombres y tamaños de archivos almacenados
         for n:=0 to Length(archivos)-1 do
         begin
            // Lee nombre del archivo
            Buffer := '';
            repeat Read(fi, c); if c<>'$' then Buffer := Buffer + c;
            until c = '$';
            archivos[n].name := Buffer;

            // Lee el tamaño
            s := 0;
            Read(fi, c);     s := s + (Ord(c) shl 24);
            Read(fi, c);     s := s + (Ord(c) shl 16);
            Read(fi, c);     s := s + (Ord(c) shl 8);
            Read(fi, c);     s := s + Ord(c);
            TotalBytes := TotalBytes + s;
            archivos[n].size := s;
         end;

         // Recupera caption de ventana
         Buffer := FBackup.Caption;

         // Recupera los archivos del backup y los guarda en la base de datos
         for n:=0 to Length(archivos)-1 do
         begin
            //ShowMessage(archivos[n].name + ' ' + InttoStr(archivos[n].size));

            AssignFile(fo, dirbase + '\' + archivos[n].name);
            Rewrite(fo);

            // Copia de backup a archivo
            for i:=1 to archivos[n].size do
            begin
               Read(fi, c);       c := decr(c);    Write(fo, c);
               inc(ActualBytes);
               FBackup.Caption := Format('Recuperando de backup %02.0f%%', [(ActualBytes*100)/TotalBytes]);
            end;

            CloseFile(fo);
         end;

         // Vuelve el cursor a la normalidad
         Screen.Cursor := crDefault;

         Application.MessageBox('Recuperación de datos completa', 'Backup', MB_OK + MB_ICONEXCLAMATION);
      end;
    end;

    // Cierra archivo de backup
    CloseFile(fi);

    // Vuelve el cursor a la normalidad y habilita botones
    Screen.Cursor := crDefault;
    btnBackup.Enabled := True;
    btnRestore.Enabled := True;
    btnSalir.Enabled := True;

    // Recupera caption de ventana
    FBackup.Caption := Buffer;
end;

//---------------------------------------------------------------------------
// ENCRIPTA UN CARACTER
//---------------------------------------------------------------------------

function TFBackup.crip(c : Char) : Char;
begin
     Result := Chr(Ord(c) xor $5D);
end;

//---------------------------------------------------------------------------
// DESENCRIPTA UN CARACTER
//---------------------------------------------------------------------------

function TFBackup.decr(c : Char) : Char;
begin
     Result := Chr(Ord(c) xor $5D);;
end;

end.
