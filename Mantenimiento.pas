//---------------------------------------------------------------------------
//
//  Módulo de Mantenimiento del Sistema
//
//
// No implementado todavía 09-12-2000
// Inicio de la interfaz 16-01-2001
// Pack de datos 22-01-2001
// Backup de Datos 26-01-2001
// Finalización del Módulo 07-02-2001
// Agregado de ayuda al presionar F1 03-03-2001
// Función de encriptación de tablas con CTRL-ALT-V y botón 13-03-2002
// Agregado de soporte para Interbase 6 22-02-2004
//
//
// A Hacer:
//          Exportación de Datos
//          Mejora de la interfase
//
//---------------------------------------------------------------------------

unit Mantenimiento;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  Buttons, ComCtrls, StdCtrls, ExtCtrls, DBTables, DB, BDE, DbiTypes,
  ImgList;

{ TUtility (TUVerifyTable) Session Options }
const
  TU_Append_Errors = 1;
  TU_No_Secondary  = 2;
  TU_No_Warnings   = 4;
  TU_Header_Only   = 8;
  TU_Dialog_Hide   = 16;
  TU_No_Lock       = 32;

type
  TblInfo = record
          archivo : String;
          mensaje : String;
  end;

  hTUses  = Word;
  phTUses = ^hTUses;
  { Verify Callback processes }
  TUVerifyProcess = (TUVerifyHeader, TUVerifyIndex, TUVerifyData, TUVerifySXHeader,
                     TUVerifySXIndex, TUVerifySXData, TUVerifySXIntegrity,
                     TUVerifyTableName, TURebuild);
  { Call back info for Verify Callback function }
  TUVerifyCallBack = record
    PercentDone: word;
    TableName: DBIPath;
    Process: TUVerifyProcess;
    CurrentIndex: word;
    TotalIndex: word;
  end;

  TBDEUtil = class;

  TFMant = class(TForm)
    GroupBox1: TGroupBox;
    GroupBox3: TGroupBox;
    Label24: TLabel;
    Label25: TLabel;
    Label26: TLabel;
    Label27: TLabel;
    PBHeader: TProgressBar;
    PBIndexes: TProgressBar;
    PBData: TProgressBar;
    PBRebuild: TProgressBar;
    btnSalir: TSpeedButton;
    ATablas: TTreeView;
    leds: TImageList;
    btnVerificar: TSpeedButton;
    Label1: TLabel;
    btnReparar: TSpeedButton;
    btnDepurar: TSpeedButton;
    btnBackup: TSpeedButton;
    btnPack: TSpeedButton;
    btnGenerar: TSpeedButton;
    btnExportar: TSpeedButton;
    btnFiltrar: TSpeedButton;
    btnHuerfanos: TSpeedButton;
    btnSystbl: TSpeedButton;
    btnReindexar: TSpeedButton;
    st: TStatusBar;
    Bevel1: TBevel;
    btnEncriptar: TSpeedButton;
    procedure btnSalirClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure btnVerificarClick(Sender: TObject);
    procedure ATablasChange(Sender: TObject; Node: TTreeNode);
    procedure btnGenerarClick(Sender: TObject);
    procedure ATablasCollapsed(Sender: TObject; Node: TTreeNode);
    procedure btnRepararClick(Sender: TObject);
    procedure btnDepurarClick(Sender: TObject);
    procedure btnReindexarClick(Sender: TObject);
    procedure btnPackClick(Sender: TObject);
    procedure btnFiltrarClick(Sender: TObject);
    procedure btnSystblClick(Sender: TObject);
    procedure btnHuerfanosClick(Sender: TObject);
    procedure btnBackupClick(Sender: TObject);
    procedure btnExportarClick(Sender: TObject);
    procedure FormKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure FormKeyUp(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure btnEncriptarClick(Sender: TObject);
  private
    { Private declarations }
    BDEUtil: TBDEUtil;
  public
    { Public declarations }
  end;

  TBDEUtil = class
    CbInfo: TUVerifyCallback;
    TUProps: CURProps;
    hDb: hDBIDb;
    vhTSes: hTUSes;
    constructor Create;
    destructor Destroy; override;
    function GetTCursorProps(szTable: String): Boolean;
    procedure RegisterCallBack;
    procedure UnRegisterCallBack;
  end;

{ TUtility functions }
function TUInit(var hTUSession: hTUses): DBIResult;  stdcall;

function TUVerifyTable(hTUSession: hTUses; pszTableName, pszDriverType,
                       pszErrTableName, pszPassword: PChar; iOptions: integer;
                       var piErrorLevel: Integer): DBIResult; stdcall;

function TURebuildTable(hTUSession: hTUses; pszTableName, pszDriverType,
                        pszBackupTableName, pszKeyviolName, pszProblemTableName: PChar;
                        pCrDesc: pCRTblDesc): DBIResult; stdcall;

function TUGetCRTblDescCount(hTUSession: hTUses; pszTableName: PChar;
                             var iFldCount, iIdxCount, iSecRecCount,
                             iValChkCount, iRintCount, iOptParams,
                             iOptDataLen: word): DBIResult; stdcall;

function TUFillCRTblDesc(hTUSession: hTUses; pCrDesc: pCRTblDesc;
                         pszTableName, pszPassword: PChar): DBIResult; stdcall;

function TUFillCURProps(hTUSession: hTUses; pszTableName: PChar;
                        var tblProps: CURProps): DBIResult; stdcall;

function TUGetExtTblProps(hTUSession: hTUses; pszTableName: PChar;
                          var pTS: TimeStamp; var pbReadOnly: Boolean): DBIResult; stdcall;

function TUExit(hTUSession: hTUses): DBIResult; stdcall;

function TUGetErrorString(iErrorcode: DBIResult; pszError: PChar): DBIResult; stdcall;

var
  FMant: TFMant;
  tablasX: Array[1..6] of TblInfo;
  i, ini, fin : Integer;

implementation

uses Comunicaciones, Datos, FiltroEventos, Huerfanos, Rutinas,
  Backup, DepuraFecha, Password;

{$R *.DFM}

const TU32 = 'TUTIL32.DLL';

function TUInit;              external TU32 name 'TUInit';
function TUVerifyTable;       external TU32 name 'TUVerifyTable';
function TURebuildTable;      external TU32 name 'TURebuildTable';
function TUGetCRTblDescCount; external TU32 name 'TUGetCRTblDescCount';
function TUFillCRTblDesc;     external TU32 name 'TUFillCRTblDesc';
function TUFillCURProps;      external TU32 name 'TUFillCURProps';
function TUGetExtTblProps;    external TU32 name 'TUGetExtTblProps';
function TUExit;              external TU32 name 'TUExit';
function TUGetErrorString;    external TU32 name 'TUGetErrorString';

// FUNCION QUE ACTUALIZA BARRAS DE PROGRESO
function GenProgressCallBack(ecbType: CBType; Data: LongInt; pcbInfo: Pointer) : CBRType; stdcall;
var
  CBInfo: TUVerifyCallBack;
begin
  CBInfo := TUVerifyCallBack(pcbInfo^);
  if ecbType = cbGENPROGRESS then
    case CBInfo.Process of
     TUVerifyHeader: begin FMant.PBHeader.Position := CBInfo.percentdone;  end;
     TUVerifyIndex:  begin FMant.PBIndexes.Position := CBInfo.percentdone; end;
     TUVerifyData:   begin FMant.PBData.Position := CBInfo.percentdone;    end;
     TURebuild:      begin FMant.PBRebuild.Position := CBInfo.percentdone; end;
    end;

  Result := cbrUSEDEF;
end;

// FUNCIONES Y PROCEDIMIENTOS BDEUtil
constructor TBDEUtil.Create;
begin
  Check(TUInit(vhtSes));
end;

destructor TBDEUtil.Destroy;
begin
  Check(TUExit(vhtSes));
  inherited Destroy;
end;

function TBDEUtil.GetTCursorProps(szTable: String): Boolean;
begin
  if TUFillCURProps(vHtSes, PChar(szTable), TUProps) = DBIERR_NONE then
    Result := True
  else Result := False;
end;

procedure TBDEUtil.RegisterCallback;
begin
 Check(DbiRegisterCallBack(nil, cbGENPROGRESS, 0,
            sizeof(TUVerifyCallBack), @CbInfo, GenProgressCallback));
end;

procedure TBDEUtil.UnRegisterCallback;
begin
  Check(DbiRegisterCallBack(nil, cbGENPROGRESS, 0,
           sizeof(TUVerifyCallBack), @CbInfo, nil));
end;

//---------------------------------------------------------------------------
// CREA LA VENTANA DE MANTENIMIENTO
//---------------------------------------------------------------------------

procedure TFMant.FormCreate(Sender: TObject);
var
   i : Integer;
begin
   BDEUtil := TBDEUtil.Create;    // Inicializa el objeto BDEUtil
   ATablas.FullExpand;            // Expande árbol de tablas

   // Inicializa variables de tablas y mensajes
   tablasX[1].archivo := 'GruposNodos';
   tablasX[2].archivo := 'Nodos';
   tablasX[3].archivo := 'GruposAcceso';
   tablasX[4].archivo := 'Usuarios';
   tablasX[5].archivo := 'Asignaciones';
   tablasX[6].archivo := 'Eventos';

   for i:=1 to 6 do tablasX[i].mensaje := 'Tabla no verificada';

   if TIPO_BASE = INTERBASE then
   begin
     btnVerificar.Enabled := False;
     btnReindexar.Enabled := False;
     btnBackup.Enabled := False;
     btnReparar.Enabled := False;
     btnPack.Enabled := False;
   end;
end;

//---------------------------------------------------------------------------
// DESTRUYE LA VENTANA DE MANTENIMIENTO
//---------------------------------------------------------------------------

procedure TFMant.FormDestroy(Sender: TObject);
begin
    BDEUtil.Free;
end;

//---------------------------------------------------------------------------
// SELECCIONA LA TABLA SOBRE LA CUAL REALIZAR OPERACIÓN
//---------------------------------------------------------------------------

procedure TFMant.ATablasChange(Sender: TObject; Node: TTreeNode);
begin
   if Node.Level = 0 then
   begin
        st.SimpleText := '';
        ini := 1;
        fin := 6;
   end
   else
   begin
        st.SimpleText := tablasX[Node.AbsoluteIndex].mensaje;
        ini := ATablas.Selected.AbsoluteIndex;;
        fin := ini;
   end;

   PBHeader.Position := 0;
   PBIndexes.Position := 0;
   PBData.Position := 0;
   PBRebuild.Position := 0;
end;

//---------------------------------------------------------------------------
// NO PERMITE COLAPSAR EL ARBOL
//---------------------------------------------------------------------------

procedure TFMant.ATablasCollapsed(Sender: TObject; Node: TTreeNode);
begin
     ATablas.FullExpand;
end;

//---------------------------------------------------------------------------
// VERIFICA LA TABLA SELECCIONADA
//---------------------------------------------------------------------------

procedure TFMant.btnVerificarClick(Sender: TObject);
var
  i, Msg: Integer;
  Table: String;
begin
  // Recorre todas las tablas seleccionadas
  for i:=ini to fin do
  begin
    Table := ReadReg_S('UBD') + '\' + tablasX[i].archivo + '.DB';

    st.SimpleText := 'Verificando tabla: ' + tablasX[i].archivo;
    PBHeader.Position := 0;
    PBIndexes.Position := 0;
    PBData.Position := 0;
    PBRebuild.Position := 0;
    Application.ProcessMessages;

    Check(TUExit(BDEUtil.vHtSes));
    Check(TUInit(BDEUtil.vHtSes));
    BDEUtil.RegisterCallBack;

    try
      if TUVerifyTable(BDEUtil.vHtSes, PChar(Table), szPARADOX, 'VERIFY.DB', nil, 0, Msg) = DBIERR_NONE then
      begin
        case Msg of
          0: st.SimpleText := 'La tabla no tiene errores.';
          1: st.SimpleText := 'Verificación completa.';
          2: st.SimpleText := 'La verificación no se pudo completar.';
          3: st.SimpleText := 'La tabla debe ser reconstruida manualmente.';
          4: st.SimpleText := 'La tabla no puede ser reconstruida.';
        else
          st.SimpleText := 'No se pudo verificar la tabla.';
        end;

        if Msg < 2 then ATablas.Items[i].ImageIndex := 2
        else            ATablas.Items[i].ImageIndex := 1;
        ATablas.Items[i].SelectedIndex := ATablas.Items[i].ImageIndex;

        tablasX[i].mensaje := st.SimpleText;
      end;
    finally
      BDEUtil.UnRegisterCallBack;
    end;
  end;
end;

//---------------------------------------------------------------------------
// REPARA LA TABLA SELECCIONADA
//---------------------------------------------------------------------------

procedure TFMant.btnRepararClick(Sender: TObject);
var
  iFld, iIdx, iSec, iVal, iRI, iOptP, iOptD: word;
  szTable: String;
  rslt: DBIResult;
  i, Msg: Integer;
  TblDesc: CRTBlDesc;
  Backup: String;
begin
  // Recorre todas las tablas seleccionadas
  for i:=ini to fin do
  begin
    st.SimpleText := 'Reparando tabla: ' + tablasX[i].archivo;
    PBHeader.Position := 0;
    PBIndexes.Position := 0;
    PBData.Position := 0;
    PBRebuild.Position := 0;
    Application.ProcessMessages;

    Check(TUExit(BDEUtil.vHtSes));
    Check(TUInit(BDEUtil.vHtSes));
    szTable := ReadReg_S('UBD') + '\' + tablasX[i].archivo + '.DB';
    BDEUtil.RegisterCallBack;
    try
      Check(TUVerifyTable(BDEUtil.vHtSes, PChar(szTable), szPARADOX, 'VERIFY.DB', nil, 0, Msg));
      rslt := TUGetCRTblDescCount(BDEUtil.vhTSes, PChar(szTable), iFld, iIdx, iSec, iVal, iRI, iOptP, iOptD);
      if rslt = DBIERR_NONE then
      begin
        FillChar(TblDesc, SizeOf(CRTBlDesc), 0);
        StrPCopy(TblDesc.szTblName, szTable);
        TblDesc.szTblType := szParadox;
        TblDesc.szErrTblName := 'Rebuild.DB';

        TblDesc.iFldCount := iFld;
        GetMem(TblDesc.pFldDesc, (iFld * SizeOf(FldDesc)));

        TblDesc.iIdxCount := iIdx;
        GetMem(TblDesc.pIdxDesc, (iIdx * SizeOf(IdxDesc)));

        TblDesc.iSecRecCount := iSec;
        GetMem(TblDesc.pSecDesc, (iSec * SizeOf(SecDesc)));

        TblDesc.iValChkCount := iVal;
        GetMem(TblDesc.pvchkDesc, (iVal * SizeOf(VCHKDesc)));

        TblDesc.iRintCount := iRI;
        GetMem(TblDesc.printDesc, (iRI * SizeOf(RINTDesc)));

        TblDesc.iOptParams := iOptP;
        GetMem(TblDesc.pfldOptParams, (iOptP * sizeOf(FLDDesc)));

        GetMem(TblDesc.pOptData, (iOptD * DBIMAXSCFLDLEN));
        try
           rslt := TUFillCRTblDesc(BDEUtil.vhTSes, @TblDesc, PChar(szTable), nil);
           if rslt = DBIERR_NONE then
           begin
             Backup := 'Backup.DB';
             if TURebuildTable(BDEUtil.vhTSes, PChar(szTable), szPARADOX, PChar(Backup), 'KEYVIOL.DB', 'PROBLEM.DB', @TblDesc) = DBIERR_NONE then
             begin
                st.SimpleText := 'Reparación exitosa';
                ATablas.Items[i].ImageIndex := 2;
             end
             else
             begin
                st.SimpleText := 'Reparación fallida';
                ATablas.Items[i].ImageIndex := 1;
             end;
           end
           else
           begin
               MessageDlg('Error llenando estructura de la tabla', mtError, [mbok], 0);
               ATablas.Items[i].ImageIndex := 1;
           end;

        finally
          ATablas.Items[i].SelectedIndex := ATablas.Items[i].ImageIndex;
          tablasX[i].mensaje := st.SimpleText;

          FreeMem(TblDesc.pFldDesc, (iFld * SizeOf(FldDesc)));
          FreeMem(TblDesc.pIdxDesc, (iIdx * SizeOf(IdxDesc)));
          FreeMem(TblDesc.pSecDesc, (iSec * SizeOf(SecDesc)));
          FreeMem(TblDesc.pvchkDesc, (iVal * SizeOf(VCHKDesc)));
          FreeMem(TblDesc.printDesc, (iRI * SizeOf(RINTDesc)));
          FreeMem(TblDesc.pfldOptParams, (iOptP * sizeOf(FLDDesc)));
          FreeMem(TblDesc.pOptData, (iOptD * DBIMAXSCFLDLEN));
        end;
      end;
    finally
      BDEUtil.UnRegisterCallBack;
    end;
  end;
end;

//---------------------------------------------------------------------------
// REINDEXA LA TABLA SELECCIONADA
//---------------------------------------------------------------------------

procedure TFMant.btnReindexarClick(Sender: TObject);
var
   i : Integer;
begin
  // Recorre todas las tablas seleccionadas
  for i:=ini to fin do
  begin
     st.SimpleText := 'Reindexando tabla: ' + tablasX[i].archivo;
     PBHeader.Position := 0;
     PBIndexes.Position := 0;
     PBData.Position := 0;
     PBRebuild.Position := 0;
     Application.ProcessMessages;

     with TTable.Create(Application) do
     begin
        DatabaseName := 'MIBASE';
        TableType := ttParadox;
        TableName := tablasX[i].archivo + '.DB';

        try
          try
            if TableName = 'Usuarios.DB' then
            begin
              AddIndex('', 'Usr_id', [ixPrimary, ixUnique]);
              AddIndex('Usuarios_IDX', 'Usr_nom;Usr_tarj;Usr_id', [ixCaseInsensitive]);
            end
            else if TableName = 'Asignaciones.DB' then
            begin
              AddIndex('', 'Asg_id', [ixPrimary, ixUnique]);
              AddIndex('Asig_IDX', 'Asg_usr;Asg_nod', [ixCaseInsensitive]);
            end
            else if TableName = 'Eventos.DB' then
            begin
              AddIndex('', 'Ev_id', [ixPrimary, ixUnique]);
              AddIndex('Eventos_IDX', 'Ev_fecha2;Ev_hora;Ev_pers;Ev_nod;Ev_fecha', [ixCaseInsensitive]);
            end;

            PBIndexes.Position := PBIndexes.Max;
            st.SimpleText := 'Tabla reindexada';

          except st.SimpleText := 'Error al reindexar tabla';
          end;
        finally Free;
        end;

        tablasX[i].mensaje := st.SimpleText;
     end;
  end;
end;

//---------------------------------------------------------------------------
// COMPRIME LA TABLA (PACK)
//---------------------------------------------------------------------------

procedure TFMant.btnPackClick(Sender: TObject);
var
   Props: CURProps;
   hDb: hDBIDb;
   TableDesc: CRTblDesc;
   Tabla : TTable;
   i : Integer;
begin
  // Recorre las tablas seleccionadas
  for i:=ini to fin do
  begin
     st.SimpleText := 'Comprimiendo tabla: ' + tablasX[i].archivo;
     PBHeader.Position := 0;
     PBIndexes.Position := 0;
     PBData.Position := 0;
     PBRebuild.Position := 0;
     Application.ProcessMessages;

     Tabla := TTable.Create(Application);

     try
        with Tabla do
        begin
          DatabaseName := 'MIBASE';
          TableType := ttParadox;
          TableName := tablasX[i].archivo + '.DB';
          Active := False;
          Exclusive := True;
          Active := True;
        end;

        // Get the table properties to determine table type...
        Check(DbiGetCursorProps(Tabla.Handle, Props));

        if (Props.szTableType = szPARADOX) then
        begin
          // Blank out the structure...
          FillChar(TableDesc, sizeof(TableDesc), 0);
          // Get the database handle from the table's cursor handle...
          Check(DbiGetObjFromObj(hDBIObj(Tabla.Handle), objDATABASE, hDBIObj(hDb)));
          // Put the table name in the table descriptor...
          StrPCopy(TableDesc.szTblName, Tabla.TableName);
          // Put the table type in the table descriptor...
          StrPCopy(TableDesc.szTblType, Props.szTableType);
          // Set the Pack option in the table descriptor to TRUE...
          TableDesc.bPack := True;
          // Close the table so the restructure can complete...
          Tabla.Close;
          // Call DbiDoRestructure...

          Check(DbiDoRestructure(hDb, 1, @TableDesc, nil, nil, nil, False));
          Tabla.Open;

          PBHeader.Position := PBHeader.Max;
          PBIndexes.Position := PBIndexes.Max;
          PBData.Position := PBData.Max;
          st.SimpleText := 'Tabla comprimida';
          tablasX[i].mensaje := st.SimpleText;
        end;

     except
           tablasX[i].mensaje := st.SimpleText;
           ShowMessage(st.SimpleText);
     end;

     Tabla.Free;
  end;
end;

//---------------------------------------------------------------------------
// REGENERA LA TABLA SELECCIONADA
//---------------------------------------------------------------------------

procedure TFMant.btnGenerarClick(Sender: TObject);
var
   i : Integer;
begin
  // Recorre las tablas seleccionadas
  for i:=ini to fin do
  begin
    try
       st.SimpleText := 'Regenerando tabla: ' + tablasX[i].archivo;
       PBHeader.Position := 0;
       PBIndexes.Position := 0;
       PBData.Position := 0;
       PBRebuild.Position := 0;
       Application.ProcessMessages;

       data.Crea_tabla(tablasX[i].archivo);

       PBHeader.Position := PBHeader.Max;
       PBIndexes.Position := PBIndexes.Max;
       PBData.Position := PBData.Max;
       PBRebuild.Position := PBRebuild.Max;
       st.SimpleText := 'Tabla regenerada';
    except
       st.SimpleText := 'No se pudo generar tabla';
    end;

    tablasX[i].mensaje := st.SimpleText;
  end;
end;

//---------------------------------------------------------------------------
// CHEQUEA LA PRESENCIA DE REGISTROS HUÉRFANOS
//---------------------------------------------------------------------------

procedure TFMant.btnHuerfanosClick(Sender: TObject);
begin
    // Crea y abre la ventana de chequeo de registros huérfanos
    Application.CreateForm(TFOrphan, FOrphan);
    FOrphan.ShowModal;
    FOrphan.Free;
end;

//---------------------------------------------------------------------------
// FILTRA LA BASE DE EVENTOS DEPURANDO POR FECHAS
//---------------------------------------------------------------------------

procedure TFMant.btnDepurarClick(Sender: TObject);
begin
    // Crea y abre la ventana de depuración de eventos por fecha
    Application.CreateForm(TFDepurar, FDepurar);
    FDepurar.ShowModal;
    FDepurar.Free;
end;

//---------------------------------------------------------------------------
// FILTRA LA BASE DE EVENTOS DEPURANDO POR TIPO DE EVENTO
//---------------------------------------------------------------------------

procedure TFMant.btnFiltrarClick(Sender: TObject);
begin
    Application.CreateForm(TFFiltroEv, FFiltroEv);
    FFiltroEv.ShowModal;
    FFiltroEv.Free;
end;

//---------------------------------------------------------------------------
// HACE BACKUP DE LAS TABLAS SELECCIONADAS
//---------------------------------------------------------------------------

procedure TFMant.btnBackupClick(Sender: TObject);
begin
    // Crea y abre la ventana de depuración de eventos por tipo
    if Application.MessageBox('Antes de realizar un backup de las tablas, es conveniente '#13'comprimir los datos, para evitar almacenar las tablas en más '#13'espacio que el necesario. '#13#13'Está seguro que quiere ingresar al módulo de Backup?', 'Advertencia', MB_YESNO + MB_ICONQUESTION) = ID_YES then
    begin
      // Crea y abre la ventana de backup de tablas
      Application.CreateForm(TFBackup, FBackup);
      FBackup.ShowModal;
      FBackup.Free;
    end;
end;

//---------------------------------------------------------------------------
// EXPORTA LAS TABLAS A OTRO FORMATO
//---------------------------------------------------------------------------

procedure TFMant.btnExportarClick(Sender: TObject);
begin

end;

//---------------------------------------------------------------------------
// REGENERA LAS TABLAS DEL SISTEMA
//---------------------------------------------------------------------------

procedure TFMant.btnSystblClick(Sender: TObject);
begin
      //data.Crea_tabla('Hab');       // Crea tablas estáticas
      data.Crea_tabla('Tip_Ev');

      st.SimpleText := 'Tablas del sistema generadas';
end;

//---------------------------------------------------------------------------
// VUELVE AL MENU PRINCIPAL
//---------------------------------------------------------------------------

procedure TFMant.btnSalirClick(Sender: TObject);
begin
     Close;
end;

//---------------------------------------------------------------------------
// Muestra botón encriptar
//---------------------------------------------------------------------------

procedure TFMant.FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
begin
   if (ssCtrl in Shift) and (ssAlt in Shift) and (Key = Ord('V')) then
      btnEncriptar.Visible := True;
end;

procedure TFMant.FormKeyUp(Sender: TObject; var Key: Word; Shift: TShiftState);
begin
   btnEncriptar.Visible := False;
end;

//---------------------------------------------------------------------------
// Encripta todas las tablas del sistema
//---------------------------------------------------------------------------

procedure TFMant.btnEncriptarClick(Sender: TObject);
var
  i: Integer;
  tbl: TTable;
  min, max: Integer;
begin
  min := PBHeader.Min;
  max := PBHeader.Max;
  PBHeader.Min := 0;
  PBHeader.Max := Length(tablas);

  tbl := TTable.Create(Self);
  tbl.DatabaseName := 'MIBASE';

  // Encripta todas las tablas del sistema
  try
    for i:=1 to Length(tablas) do
    begin
       PBHeader.StepIt;
       Application.ProcessMessages;
       tbl.Close;
       tbl.Exclusive := True;
       tbl.TableName := tablas[i] + '.db';
       st.SimpleText := 'Encriptando ' + tbl.TableName + ' ...';
       tbl.Open;
       AddMasterPassword(tbl, PARADOX_PASSWORD);
       tbl.Close;
       tbl.Exclusive := False;
    end;
    st.SimpleText := 'Tablas encriptadas';

  except
    st.SimpleText := 'Error encriptando tablas';
  end;

  FreeAndNil(tbl);
  PBHeader.Min := min;
  PBHeader.Max := max;
  PBHeader.Position := PBHeader.Min;
end;

end.
