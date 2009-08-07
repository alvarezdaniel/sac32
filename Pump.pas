unit Pump;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  Buttons, StdCtrls, ComCtrls, Db, DBTables;

type
  TFPump = class(TForm)
    btnBackup: TSpeedButton;
    btnSalir: TSpeedButton;
    Label1: TLabel;
    ProgressBar1: TProgressBar;
    dbParadox: TDatabase;
    dbInterbase: TDatabase;
    qryParadox: TQuery;
    qryInterbase: TQuery;
    spInterbase: TStoredProc;
    BatchMove1: TBatchMove;
    tblParadox: TTable;
    tblInterbase: TTable;
    procedure btnSalirClick(Sender: TObject);
    procedure btnBackupClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

const
  tablas: Array[1..11] of String = ('GruposNodos', 'Nodos', 'GruposAcceso',
                                    'Usuarios', 'Asignaciones', 'Eventos',
                                    'Franjas', 'GruposFranjas', 'Feriados',
                                    'Dispositivos', 'Tip_Ev');
var
  FPump: TFPump;

implementation

uses Rutinas;

{$R *.DFM}

procedure TFPump.btnSalirClick(Sender: TObject);
begin
  ModalResult := mrCancel;
end;

procedure TFPump.btnBackupClick(Sender: TObject);
var
  base: String;
  ParadoxOK, InterbaseOK: Boolean;
  i: Integer;
begin
  // Si la ubicación no está configurada la setea con valor default
  if (ReadReg_S('UBD') = '') then WriteReg_S('UBD', carpeta + 'Bases');
  base := ReadReg_S('UBD');

  with dbParadox do
  begin
    try
      Label1.Caption := 'Conectando a base Paradox...';
      Application.ProcessMessages;
      DatabaseName := 'Paradox';
      DriverName := 'STANDARD';
      Session.AddPassword(PARADOX_PASSWORD);
      Params.Clear;
      Params.Add('PATH=' + base);
      Params.Add('DEFAULT DRIVER=PARADOX');
      Params.Add('ENABLE BCD=FALSE');
      Connected := True;
      sleep(500);
      Label1.Caption := 'Conectando a base Paradox... OK';
      Application.ProcessMessages;
      ParadoxOK := True;
      sleep(500);
    except
      Label1.Caption := 'Error';
      Application.ProcessMessages;
      ParadoxOK := False;
      ShowMessage('Error conectando a base Paradox');
      Exit;
    end;
  end;

  with dbInterbase do
  begin
    try
      Label1.Caption := 'Conectando a base Interbase...';
      Application.ProcessMessages;
      DatabaseName := 'Interbase';
      DriverName := 'INTRBASE';
      LoginPrompt := False;
      Params.Clear;
      Params.Add('SERVER NAME=' + base + '\SAC32.gdb');
      Params.Add('USER NAME=SYSDBA');
      Params.Add('PASSWORD=masterkey');
      Connected := True;
      sleep(500);
      Label1.Caption := 'Conectando a base Interbase... OK';
      Application.ProcessMessages;
      InterbaseOK := True;
      sleep(500);
    except
      Label1.Caption := 'Error';
      Application.ProcessMessages;
      InterbaseOK := False;
      ShowMessage('Error conectando a base Interbase');
      Exit;
    end;
  end;

  try
    // Primero ejecuta el stored procedure que borra toda la base interbase
    Label1.Caption := 'Borrando base Interbase...';
    Application.ProcessMessages;
    spInterbase.StoredProcName := 'BORRAR_TODO';
    spInterbase.ExecProc;
    sleep(500);
    Label1.Caption := 'Borrando base Interbase... OK';
    Application.ProcessMessages;

    // Va abriendo las tablas y copiando el contenido
    for i:=1 to Length(tablas) do
    begin
      Label1.Caption := 'Copiando tabla: ' + tablas[i] + '...';
      Application.ProcessMessages;

      tblParadox.Close;
      tblParadox.TableName := tablas[i];
      tblParadox.Open;
      tblInterbase.Close;
      tblInterbase.TableName := tablas[i];
      tblInterbase.Open;
      BatchMove1.Execute;

      Label1.Caption := 'Copiando tabla: ' + tablas[i] + '...OK';
      Application.ProcessMessages;
    end;

    Label1.Caption := 'Copiado de datos OK';
    Application.ProcessMessages;

  except
    on E: Exception do
      ShowMessage('Error: ' + E.Message);
  end;
  dbParadox.Connected := False;
  dbInterbase.Connected := False;
end;

end.
