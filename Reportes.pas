//---------------------------------------------------------------------------
//
//  Módulo de Generación de Reportes (Consultas SQL)
//
//  Actualicación a botones flat 09-12-2000
//  Reportes Embebidos dentro del ejecutable 09-12-2000
//  Corrección de bug Read-Only en Arboles 09-12-2000
//  Chequeo General 06-02-2001 
//  Finalización de Módulo 06-02-2001
//  Agregado de ayuda con F1 03-03-2001
//  Limitación a 20 registros en modo demo
//  Eliminación de campo Habilitado, agregado de campo Código 16-03-2001
//  Agregado de nuevos eventos, datos de personas 24-07-2001
//  Agilización de carga de árboles de personas y nodos 07-10-2001
//  Controles de fecha tenían fecha máxima 31/12/2007, 18-01-2008
//
//
//  A Hacer:
//           Almacenamiento de archivos de reporte dentro del EXE como resources?
//           Reportes de franjas
//           Agregar campo código en consultas SQL
//
//
//---------------------------------------------------------------------------

unit Reportes;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  ImgList, ComCtrls, ToolWin, StdCtrls, ppComm, ppRelatv, ppProd, ppClass,
  ppReport, ppVar, ppCtrls, ppPrnabl, ppDB, ppDBPipe, ppDBBDE, daDataVw,
  daQuery, daDBBDE, ppModule, daDatMod, ppBands, ppCache, Buttons, daQClass,
  ExtCtrls, ppViewr;

type
  TFReportes = class(TForm)
    Reporte1: TppReport;
    ppBDEPipeline1: TppBDEPipeline;
    GroupBox7: TGroupBox;
    PageControl1: TPageControl;
    TabSheetPersonas: TTabSheet;
    GroupBox1: TGroupBox;
    TabSheetNodos: TTabSheet;
    TabSheetAsignaciones: TTabSheet;
    TabSheetEventos: TTabSheet;
    GroupBox10: TGroupBox;
    GroupBox13: TGroupBox;
    GroupBox14: TGroupBox;
    rbPers: TRadioButton;
    rbNod: TRadioButton;
    Check3: TCheckBox;
    GroupBox9: TGroupBox;
    GroupBoxfecha: TGroupBox;
    Label1: TLabel;
    Label2: TLabel;
    FechaI: TDateTimePicker;
    FechaF: TDateTimePicker;
    CheckFecha: TCheckBox;
    GroupBoxhora: TGroupBox;
    Label3: TLabel;
    Label4: TLabel;
    HoraI: TDateTimePicker;
    HoraF: TDateTimePicker;
    CheckHora: TCheckBox;
    GroupBoxtipo: TGroupBox;
    GroupBoxES: TGroupBox;
    ComboES: TComboBox;
    CheckTodos: TCheckBox;
    Check1: TCheckBox;
    Bevel1: TBevel;
    APersonas1: TTreeView;
    Barra1: TStatusBar;
    Bevel2: TBevel;
    Check2: TCheckBox;
    ANodos1: TTreeView;
    Bevel3: TBevel;
    GroupBox2: TGroupBox;
    rdNum: TRadioButton;
    rdNom: TRadioButton;
    Arbol1: TTreeView;
    GroupBox3: TGroupBox;
    rb1: TRadioButton;
    rb2: TRadioButton;
    ListaTipos: TListBox;
    ck_todostipos: TCheckBox;
    GroupBoxnodo: TGroupBox;
    ANodos2: TTreeView;
    GroupBoxpers: TGroupBox;
    APersonas2: TTreeView;
    CheckGrupNod: TCheckBox;
    CheckGrupPers: TCheckBox;
    ppHeaderBand1: TppHeaderBand;
    ppDetailBand1: TppDetailBand;
    ppFooterBand1: TppFooterBand;
    btnVerPersonas: TSpeedButton;
    btnVerNodos: TSpeedButton;
    btnVerAsignaciones: TSpeedButton;
    btnVerEventos: TSpeedButton;
    RGruposPers: TppReport;
    RPersonas: TppReport;
    ppTitleBand1: TppTitleBand;
    ppLabel2: TppLabel;
    ppHeaderBand2: TppHeaderBand;
    ppLine2: TppLine;
    ppDetailBand2: TppDetailBand;
    ppDBText1: TppDBText;
    ppDBText3: TppDBText;
    ppDBText4: TppDBText;
    ppDBText5: TppDBText;
    ppFooterBand2: TppFooterBand;
    ppShape1: TppShape;
    ppLabel1: TppLabel;
    ppLine1: TppLine;
    ppSystemVariable1: TppSystemVariable;
    ppSystemVariable2: TppSystemVariable;
    ppGroup2: TppGroup;
    ppGroupHeaderBand2: TppGroupHeaderBand;
    ppShape4: TppShape;
    ppShape2: TppShape;
    ppLabel3: TppLabel;
    ppLabel5: TppLabel;
    ppDBText2: TppDBText;
    ppLabel4: TppLabel;
    ppLine4: TppLine;
    ppLabel7: TppLabel;
    ppLabel8: TppLabel;
    ppLine3: TppLine;
    ppGroupFooterBand2: TppGroupFooterBand;
    ppShape3: TppShape;
    ppDBCalc1: TppDBCalc;
    ppLabel6: TppLabel;
    ppTitleBand2: TppTitleBand;
    ppLabel9: TppLabel;
    ppHeaderBand3: TppHeaderBand;
    ppShape5: TppShape;
    ppLabel10: TppLabel;
    ppLabel11: TppLabel;
    ppLabel12: TppLabel;
    ppLabel13: TppLabel;
    ppLabel14: TppLabel;
    ppLine5: TppLine;
    ppDetailBand3: TppDetailBand;
    ppDBText6: TppDBText;
    ppDBText7: TppDBText;
    ppDBText8: TppDBText;
    ppDBText9: TppDBText;
    ppDBText10: TppDBText;
    ppFooterBand3: TppFooterBand;
    ppShape6: TppShape;
    ppLabel15: TppLabel;
    ppLine6: TppLine;
    ppSystemVariable3: TppSystemVariable;
    ppSystemVariable4: TppSystemVariable;
    RGruposNods: TppReport;
    RNodos: TppReport;
    ppTitleBand3: TppTitleBand;
    ppLabel16: TppLabel;
    ppHeaderBand4: TppHeaderBand;
    ppLine7: TppLine;
    ppDetailBand4: TppDetailBand;
    ppDBText11: TppDBText;
    ppDBText12: TppDBText;
    ppFooterBand4: TppFooterBand;
    ppShape7: TppShape;
    ppLabel17: TppLabel;
    ppLine8: TppLine;
    ppSystemVariable5: TppSystemVariable;
    ppSystemVariable6: TppSystemVariable;
    ppGroup1: TppGroup;
    ppGroupHeaderBand1: TppGroupHeaderBand;
    ppShape8: TppShape;
    ppShape11: TppShape;
    ppLabel18: TppLabel;
    ppLabel19: TppLabel;
    ppDBText13: TppDBText;
    ppLabel20: TppLabel;
    ppLine11: TppLine;
    ppLine12: TppLine;
    ppGroupFooterBand1: TppGroupFooterBand;
    ppShape12: TppShape;
    ppDBCalc2: TppDBCalc;
    ppLabel21: TppLabel;
    ppTitleBand4: TppTitleBand;
    ppLabel22: TppLabel;
    ppHeaderBand5: TppHeaderBand;
    ppShape9: TppShape;
    ppLabel23: TppLabel;
    ppLabel24: TppLabel;
    ppLabel25: TppLabel;
    ppLine9: TppLine;
    ppDetailBand5: TppDetailBand;
    ppDBText14: TppDBText;
    ppDBText15: TppDBText;
    ppDBText16: TppDBText;
    ppFooterBand5: TppFooterBand;
    ppShape10: TppShape;
    ppLabel26: TppLabel;
    ppLine10: TppLine;
    ppSystemVariable7: TppSystemVariable;
    ppSystemVariable8: TppSystemVariable;
    RAsigXPers0: TppReport;
    RAsigXNod: TppReport;
    RAsigXNod0: TppReport;
    RAsigXPers: TppReport;
    ppTitleBand6: TppTitleBand;
    ppLabel32: TppLabel;
    ppHeaderBand7: TppHeaderBand;
    ppLine15: TppLine;
    ppDetailBand7: TppDetailBand;
    ppDBText20: TppDBText;
    ppDBText21: TppDBText;
    ppDBText22: TppDBText;
    ppDBText29: TppDBText;
    ppFooterBand7: TppFooterBand;
    ppShape15: TppShape;
    ppLabel33: TppLabel;
    ppLine16: TppLine;
    ppSystemVariable11: TppSystemVariable;
    ppSystemVariable12: TppSystemVariable;
    ppGroup3: TppGroup;
    ppGroupHeaderBand3: TppGroupHeaderBand;
    ppShape16: TppShape;
    ppLabel34: TppLabel;
    ppDBText30: TppDBText;
    ppLine21: TppLine;
    ppGroupFooterBand3: TppGroupFooterBand;
    ppGroup4: TppGroup;
    ppGroupHeaderBand4: TppGroupHeaderBand;
    ppShape21: TppShape;
    ppLabel35: TppLabel;
    ppDBText31: TppDBText;
    ppLabel36: TppLabel;
    ppDBText32: TppDBText;
    ppLabel47: TppLabel;
    ppLabel48: TppLabel;
    ppLine22: TppLine;
    ppLine23: TppLine;
    ppLabel49: TppLabel;
    ppLabel50: TppLabel;
    ppGroupFooterBand4: TppGroupFooterBand;
    ppShape22: TppShape;
    ppDBCalc3: TppDBCalc;
    ppLabel51: TppLabel;
    ppTitleBand7: TppTitleBand;
    ppLabel37: TppLabel;
    ppLine17: TppLine;
    ppHeaderBand8: TppHeaderBand;
    ppDetailBand8: TppDetailBand;
    ppDBText23: TppDBText;
    ppDBText24: TppDBText;
    ppDBText25: TppDBText;
    ppDBText33: TppDBText;
    ppFooterBand8: TppFooterBand;
    ppShape17: TppShape;
    ppLabel38: TppLabel;
    ppLine18: TppLine;
    ppSystemVariable13: TppSystemVariable;
    ppSystemVariable14: TppSystemVariable;
    ppGroup5: TppGroup;
    ppGroupHeaderBand5: TppGroupHeaderBand;
    ppShape18: TppShape;
    ppLabel39: TppLabel;
    ppDBText34: TppDBText;
    ppLine24: TppLine;
    ppGroupFooterBand5: TppGroupFooterBand;
    ppGroup6: TppGroup;
    ppGroupHeaderBand6: TppGroupHeaderBand;
    ppShape23: TppShape;
    ppDBText35: TppDBText;
    ppLabel40: TppLabel;
    ppDBText36: TppDBText;
    ppLine25: TppLine;
    ppGroupFooterBand6: TppGroupFooterBand;
    ppTitleBand8: TppTitleBand;
    ppLabel41: TppLabel;
    ppHeaderBand9: TppHeaderBand;
    ppLine19: TppLine;
    ppDetailBand9: TppDetailBand;
    ppDBText26: TppDBText;
    ppDBText27: TppDBText;
    ppFooterBand9: TppFooterBand;
    ppShape19: TppShape;
    ppLabel42: TppLabel;
    ppLine20: TppLine;
    ppSystemVariable15: TppSystemVariable;
    ppSystemVariable16: TppSystemVariable;
    ppGroup7: TppGroup;
    ppGroupHeaderBand7: TppGroupHeaderBand;
    ppShape20: TppShape;
    ppLabel43: TppLabel;
    ppDBText28: TppDBText;
    ppLine26: TppLine;
    ppGroupFooterBand7: TppGroupFooterBand;
    ppGroup8: TppGroup;
    ppGroupHeaderBand8: TppGroupHeaderBand;
    ppShape24: TppShape;
    ppLabel44: TppLabel;
    ppDBText37: TppDBText;
    ppLabel45: TppLabel;
    ppDBText38: TppDBText;
    ppLabel46: TppLabel;
    ppLabel52: TppLabel;
    ppLine27: TppLine;
    ppLine28: TppLine;
    ppDBText39: TppDBText;
    ppGroupFooterBand8: TppGroupFooterBand;
    ppShape25: TppShape;
    ppDBCalc4: TppDBCalc;
    ppLabel55: TppLabel;
    ppTitleBand5: TppTitleBand;
    ppLabel27: TppLabel;
    ppLine13: TppLine;
    ppHeaderBand6: TppHeaderBand;
    ppDetailBand6: TppDetailBand;
    ppDBText17: TppDBText;
    ppDBText18: TppDBText;
    ppLabel28: TppLabel;
    ppFooterBand6: TppFooterBand;
    ppShape13: TppShape;
    ppLabel29: TppLabel;
    ppLine14: TppLine;
    ppSystemVariable9: TppSystemVariable;
    ppSystemVariable10: TppSystemVariable;
    ppGroup9: TppGroup;
    ppGroupHeaderBand9: TppGroupHeaderBand;
    ppShape14: TppShape;
    ppLabel30: TppLabel;
    ppDBText19: TppDBText;
    ppLine29: TppLine;
    ppGroupFooterBand9: TppGroupFooterBand;
    ppGroup10: TppGroup;
    ppGroupHeaderBand10: TppGroupHeaderBand;
    ppShape26: TppShape;
    ppDBText40: TppDBText;
    ppLabel31: TppLabel;
    ppDBText41: TppDBText;
    ppLine30: TppLine;
    ppDBText42: TppDBText;
    ppGroupFooterBand10: TppGroupFooterBand;
    REvGeneralGrupNod: TppReport;
    REvAccGrupNod: TppReport;
    REvAccGrupPers: TppReport;
    REvEspec: TppReport;
    REvEspecGrupNod: TppReport;
    REvGeneral: TppReport;
    ppTitleBand9: TppTitleBand;
    ppLabel56: TppLabel;
    ppHeaderBand11: TppHeaderBand;
    ppDetailBand11: TppDetailBand;
    ppDBText43: TppDBText;
    ppDBText44: TppDBText;
    ppDBText45: TppDBText;
    ppDBText46: TppDBText;
    ppDBText47: TppDBText;
    ppDBText48: TppDBText;
    ppFooterBand11: TppFooterBand;
    ppShape27: TppShape;
    ppLabel57: TppLabel;
    ppLine31: TppLine;
    ppSystemVariable17: TppSystemVariable;
    ppSystemVariable18: TppSystemVariable;
    ppSummaryBand1: TppSummaryBand;
    ppShape28: TppShape;
    ppDBCalc5: TppDBCalc;
    ppLabel58: TppLabel;
    ppLine32: TppLine;
    ppGroup11: TppGroup;
    ppGroupHeaderBand11: TppGroupHeaderBand;
    ppShape29: TppShape;
    ppLabel59: TppLabel;
    ppDBText49: TppDBText;
    ppLine33: TppLine;
    ppGroupFooterBand11: TppGroupFooterBand;
    ppShape30: TppShape;
    ppLabel60: TppLabel;
    ppDBText50: TppDBText;
    ppDBCalc6: TppDBCalc;
    ppLine34: TppLine;
    ppGroup12: TppGroup;
    ppGroupHeaderBand12: TppGroupHeaderBand;
    ppShape31: TppShape;
    ppLine35: TppLine;
    ppLabel61: TppLabel;
    ppLabel62: TppLabel;
    ppLabel63: TppLabel;
    ppDBText51: TppDBText;
    ppLabel64: TppLabel;
    ppLabel65: TppLabel;
    ppLabel66: TppLabel;
    ppLabel67: TppLabel;
    ppGroupFooterBand12: TppGroupFooterBand;
    ppShape32: TppShape;
    ppLabel68: TppLabel;
    ppDBText52: TppDBText;
    ppDBCalc7: TppDBCalc;
    ppLine36: TppLine;
    ppTitleBand10: TppTitleBand;
    ppLabel69: TppLabel;
    ppHeaderBand12: TppHeaderBand;
    ppDetailBand12: TppDetailBand;
    ppDBText53: TppDBText;
    ppDBText54: TppDBText;
    ppDBText55: TppDBText;
    ppDBText56: TppDBText;
    ppDBText57: TppDBText;
    ppDBText58: TppDBText;
    ppFooterBand12: TppFooterBand;
    ppShape33: TppShape;
    ppLabel70: TppLabel;
    ppLine37: TppLine;
    ppSystemVariable19: TppSystemVariable;
    ppSystemVariable20: TppSystemVariable;
    ppSummaryBand2: TppSummaryBand;
    ppShape34: TppShape;
    ppDBCalc8: TppDBCalc;
    ppLabel71: TppLabel;
    ppLine38: TppLine;
    ppGroup13: TppGroup;
    ppGroupHeaderBand13: TppGroupHeaderBand;
    ppShape35: TppShape;
    ppLabel72: TppLabel;
    ppDBText59: TppDBText;
    ppLine39: TppLine;
    ppGroupFooterBand13: TppGroupFooterBand;
    ppShape36: TppShape;
    ppLabel73: TppLabel;
    ppDBText60: TppDBText;
    ppDBCalc9: TppDBCalc;
    ppLine40: TppLine;
    ppGroup14: TppGroup;
    ppGroupHeaderBand14: TppGroupHeaderBand;
    ppShape37: TppShape;
    ppLine41: TppLine;
    ppLabel74: TppLabel;
    ppLabel75: TppLabel;
    ppLabel76: TppLabel;
    ppDBText61: TppDBText;
    ppLabel77: TppLabel;
    ppLabel78: TppLabel;
    ppLabel79: TppLabel;
    ppLabel80: TppLabel;
    ppGroupFooterBand14: TppGroupFooterBand;
    ppShape38: TppShape;
    ppLabel81: TppLabel;
    ppDBText62: TppDBText;
    ppDBCalc10: TppDBCalc;
    ppLine42: TppLine;
    ppTitleBand11: TppTitleBand;
    ppLabel82: TppLabel;
    ppHeaderBand13: TppHeaderBand;
    ppShape39: TppShape;
    ppLabel83: TppLabel;
    ppLine43: TppLine;
    ppLabel84: TppLabel;
    ppLabel85: TppLabel;
    ppLabel86: TppLabel;
    ppDetailBand13: TppDetailBand;
    ppDBText63: TppDBText;
    ppDBText64: TppDBText;
    ppDBText65: TppDBText;
    ppDBText66: TppDBText;
    ppFooterBand13: TppFooterBand;
    ppShape40: TppShape;
    ppLabel87: TppLabel;
    ppLine44: TppLine;
    ppSystemVariable21: TppSystemVariable;
    ppSystemVariable22: TppSystemVariable;
    ppSummaryBand3: TppSummaryBand;
    ppShape41: TppShape;
    ppDBCalc11: TppDBCalc;
    ppLabel88: TppLabel;
    ppLine45: TppLine;
    ppTitleBand12: TppTitleBand;
    ppLabel89: TppLabel;
    ppHeaderBand14: TppHeaderBand;
    ppDetailBand14: TppDetailBand;
    ppDBText67: TppDBText;
    ppDBText68: TppDBText;
    ppDBText69: TppDBText;
    ppFooterBand14: TppFooterBand;
    ppShape42: TppShape;
    ppLabel90: TppLabel;
    ppLine46: TppLine;
    ppSystemVariable23: TppSystemVariable;
    ppSystemVariable24: TppSystemVariable;
    ppSummaryBand4: TppSummaryBand;
    ppShape43: TppShape;
    ppDBCalc12: TppDBCalc;
    ppLabel91: TppLabel;
    ppLine47: TppLine;
    ppGroup15: TppGroup;
    ppGroupHeaderBand15: TppGroupHeaderBand;
    ppShape44: TppShape;
    ppLabel92: TppLabel;
    ppDBText70: TppDBText;
    ppLine48: TppLine;
    ppGroupFooterBand15: TppGroupFooterBand;
    ppGroup16: TppGroup;
    ppGroupHeaderBand16: TppGroupHeaderBand;
    ppShape45: TppShape;
    ppLine49: TppLine;
    ppLabel93: TppLabel;
    ppLabel94: TppLabel;
    ppLabel95: TppLabel;
    ppLabel96: TppLabel;
    ppDBText71: TppDBText;
    ppGroupFooterBand16: TppGroupFooterBand;
    ppTitleBand13: TppTitleBand;
    ppLabel97: TppLabel;
    ppHeaderBand15: TppHeaderBand;
    ppShape46: TppShape;
    ppLabel98: TppLabel;
    ppLabel99: TppLabel;
    ppLabel100: TppLabel;
    ppLine50: TppLine;
    ppLabel101: TppLabel;
    ppLabel102: TppLabel;
    ppLabel103: TppLabel;
    ppLabel104: TppLabel;
    ppDetailBand15: TppDetailBand;
    ppDBText72: TppDBText;
    ppDBText73: TppDBText;
    ppDBText74: TppDBText;
    ppDBText75: TppDBText;
    ppDBText76: TppDBText;
    ppDBText77: TppDBText;
    ppDBText78: TppDBText;
    ppFooterBand15: TppFooterBand;
    ppShape47: TppShape;
    ppLabel105: TppLabel;
    ppLine51: TppLine;
    ppSystemVariable25: TppSystemVariable;
    ppSystemVariable26: TppSystemVariable;
    ppSummaryBand5: TppSummaryBand;
    ppShape48: TppShape;
    ppDBCalc13: TppDBCalc;
    ppLabel106: TppLabel;
    ppLine52: TppLine;
    ppTitleBand14: TppTitleBand;
    ppLabel107: TppLabel;
    ppHeaderBand10: TppHeaderBand;
    ppDetailBand10: TppDetailBand;
    ppDBText79: TppDBText;
    ppDBText80: TppDBText;
    ppDBText81: TppDBText;
    ppDBText82: TppDBText;
    ppDBText83: TppDBText;
    ppDBText84: TppDBText;
    ppFooterBand10: TppFooterBand;
    ppShape49: TppShape;
    ppLabel108: TppLabel;
    ppLine53: TppLine;
    ppSystemVariable27: TppSystemVariable;
    ppSystemVariable28: TppSystemVariable;
    ppSummaryBand6: TppSummaryBand;
    ppShape50: TppShape;
    ppDBCalc14: TppDBCalc;
    ppLabel109: TppLabel;
    ppLine54: TppLine;
    ppGroup17: TppGroup;
    ppGroupHeaderBand17: TppGroupHeaderBand;
    ppShape51: TppShape;
    ppLine55: TppLine;
    ppLabel110: TppLabel;
    ppDBText85: TppDBText;
    ppGroupFooterBand17: TppGroupFooterBand;
    ppGroup18: TppGroup;
    ppGroupHeaderBand18: TppGroupHeaderBand;
    ppLine56: TppLine;
    ppShape52: TppShape;
    ppLabel111: TppLabel;
    ppLabel112: TppLabel;
    ppLabel113: TppLabel;
    ppLabel114: TppLabel;
    ppLabel115: TppLabel;
    ppLabel116: TppLabel;
    ppLabel117: TppLabel;
    ppDBText86: TppDBText;
    ppGroupFooterBand18: TppGroupFooterBand;
    ImgArboles: TImageList;
    ImgRpts: TImageList;
    SpeedButton1: TSpeedButton;
    SpeedButton2: TSpeedButton;
    SpeedButton3: TSpeedButton;
    SpeedButton4: TSpeedButton;
    ppDBText87: TppDBText;
    ppLabel53: TppLabel;
    ppLabel54: TppLabel;
    ppDBText88: TppDBText;
    ppLabel118: TppLabel;
    ppDBText89: TppDBText;
    ppLabel119: TppLabel;
    ppDBText90: TppDBText;
    procedure btnVerPersonasClick(Sender: TObject);
    procedure TabSheetEventosShow(Sender: TObject);
    procedure FechaChange(Sender: TObject);
    procedure TabSheetPersonasShow(Sender: TObject);
    procedure APersonas1Change(Sender: TObject; Node: TTreeNode);
    procedure Check1Click(Sender: TObject);
    procedure TabSheetNodosShow(Sender: TObject);
    procedure btnVerNodosClick(Sender: TObject);
    procedure ANodos1Change(Sender: TObject; Node: TTreeNode);
    procedure Check2Click(Sender: TObject);
    procedure TabSheetAsignacionesShow(Sender: TObject);
    procedure rbClick(Sender: TObject);
    procedure Arbol1Change(Sender: TObject; Node: TTreeNode);
    procedure Check3Click(Sender: TObject);
    procedure btnVerAsignacionesClick(Sender: TObject);
    procedure XXClick(Sender: TObject);
    procedure ck_todostiposClick(Sender: TObject);
    procedure btnVerEventosClick(Sender: TObject);
    procedure CheckTodosClick(Sender: TObject);
    procedure HoraChange(Sender: TObject);
    procedure CheckGrupClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure Reporte1PreviewFormCreate(Sender: TObject);
    procedure Sale(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

procedure Escribe_Barra;

var
  FReportes: TFReportes;
  ListaPersonas, ListaGrupos, ListaNodos, ListaConjuntos, ListaTipos : TStrings;

implementation

uses Datos, Principal, Preview, Rutinas, Serkey;

{$R *.DFM}

//---------------------------------------------------------------------------
// HABILITA O DESHABILITA TIPOS DE REPORTES
//---------------------------------------------------------------------------

procedure TFReportes.FormShow(Sender: TObject);
begin
   btnVerPersonas.Enabled :=            Habilitada(3, 2, False);
   btnVerNodos.Enabled :=               Habilitada(3, 3, False);
   btnVerAsignaciones.Enabled :=        Habilitada(3, 4, False);
   btnVerEventos.Enabled :=             Habilitada(3, 5, False);

   PageControl1.ActivePageIndex := 0;
end;

procedure TFReportes.Reporte1PreviewFormCreate(Sender: TObject);
begin
end;

//---------------------------------------------------------------------------
//
//  REPORTES DE PERSONAS
//
//---------------------------------------------------------------------------

//---------------------------------------------------------------------------
// AL MOSTRAR PÁGINA 1, CARGA ARBOL DE PERSONAS
//---------------------------------------------------------------------------

procedure TFReportes.TabSheetPersonasShow(Sender: TObject);
var
   Ng, Np: TTreeNode;       // Variable nodo del arbol
   NTodas: TTreeNode;
   ultimo_grupo, grupo{, nombre}: String;
begin
  // Carga los datos la primera vez que se muestra la ventana
  if APersonas1.Tag = 0 then
  begin
    APersonas1.Items.BeginUpdate;
    APersonas1.Items.Clear;  // Borra items del árbol

    // Crea Grupo raiz
    NTodas := APersonas1.Items.Add(nil, 'Todas las personas');
    NTodas.ImageIndex := 0;
    NTodas.SelectedIndex := 0;


    // Realiza consulta de todos los grupos de personas
    with data.Consulta do
    begin
        //SQL.Clear;
        //SQL.Add('SELECT Gu_nom, Gu_num FROM GruposAcceso');
        SQL.Text := 'select GruposAcceso.Gu_nom, Usuarios.Usr_nom ' +
                    'from Usuarios, GruposAcceso ' +
                    'where Usuarios.Usr_grp=GruposAcceso.Gu_num ' +
                    'Order by GruposAcceso.Gu_nom';
        Open;

        ultimo_grupo := '';

        // Recorre todos los registros
        while not Eof do
        begin
            grupo := FieldbyName('Gu_nom').AsString;

            // Añade grupos al arbol de personas
            if grupo <> ultimo_grupo then
            begin
              Ng := APersonas1.Items.AddChild(NTodas, grupo);
              Ng.ImageIndex := 1;
              Ng.SelectedIndex := 1;

              ultimo_grupo := grupo;
            end;

            // Añade personas a ese grupo
            Np := APersonas1.Items.AddChild(Ng, FieldbyName('Usr_nom').AsString);
            Np.ImageIndex := 2;
            Np.SelectedIndex := 2;

            // Añade personas pertenecientes a ese grupo
            {with data.Consulta2 do
            begin
                SQL.Clear;
                SQL.Add('SELECT Usr_nom FROM Usuarios');
                SQL.Add('INNER JOIN GruposAcceso ON  (Usr_grp = Gu_num)');
                SQL.Add('WHERE Gu_nom = :grupo');
                ParambyName('grupo').AsString := nombre;
                Open;

                while not Eof do   // Recorre los registros filtrados
                begin
                    Np := APersonas1.Items.AddChild(Ng, FieldbyName('Usr_nom').AsString);
                    Np.ImageIndex := 2;
                    Np.SelectedIndex := 2;

                    Next;
                end;

                Close;
            end;}
            Next;
        end;
        Close;

        // Ordena el arbol
        APersonas1.SortType := stNone;
        APersonas1.SortType := stText;
    end;

    APersonas1.Selected := APersonas1.Items[0];
    APersonas1.Items.Item[0].Expand(False); // Expande Grupos

    Check1.Checked := False;
    APersonas1.Tag := 1;
    APersonas1.Items.EndUpdate;
  end;
  APersonas1Change(APersonas1, APersonas1.Selected);
end;

//---------------------------------------------------------------------------
// ACTUALIZA STATUS BAR CON REPORTE ACTUAL DE PERSONAS
//---------------------------------------------------------------------------

procedure TFReportes.APersonas1Change(Sender: TObject; Node: TTreeNode);
var
    s : String;
begin
  // Solo actualiza si ya se cargó todo el contenido
  if APersonas1.Tag = 1 then
  begin
    case Node.Level of
    0:      begin
                s := 'Todas las Personas';
                Check1.Enabled := True;
                if Check1.Checked then s := s + ' por Grupo';
            end;
    1:      begin
                s := 'Grupo de Personas "' + Node.Text + '"';
                Check1.Enabled := False;
                Check1.Checked := True;
            end;
    2:      begin
                s := 'Persona = "' + Node.Text + '"';
                Check1.Enabled := False;
                Check1.Checked := True;
            end;
    end;

    Barra1.Panels[0].Text := 'Reporte de ' + s;
  end;
end;

procedure TFReportes.Check1Click(Sender: TObject);
begin
    APersonas1Change(APersonas1, APersonas1.Selected);
end;

//---------------------------------------------------------------------------
// MUESTRA REPORTE DE PERSONAS
//---------------------------------------------------------------------------

procedure TFReportes.btnVerPersonasClick(Sender: TObject);
var
  usuario, grupo : String;
  orden : String;
begin
    // Selecciona persona y grupo a consultar
    case APersonas1.Selected.Level of
    0:    begin
              grupo := '%';
              usuario := '%';
          end;
    1:    begin
              grupo := APersonas1.Selected.Text;
              usuario := '%';
          end;
    2:    begin
              grupo := APersonas1.Selected.Parent.Text;
              usuario := APersonas1.Selected.Text;
          end;
    end;

    // Selecciona el orden del reporte
    if Check1.Checked then orden := 'ORDER BY Gu_nom, Usr_nom'
    else                   orden := 'ORDER BY Usr_nom';

    // Ejecuta consulta SQL
    with data.Consulta do
    begin
      SQL.Clear;
      SQL.Add('SELECT Usr_nom, Usr_tarj, Gu_nom, Usr_fot, Usr_cod, Gf_nom, Usr_cad, Usr_fra');
      SQL.Add('FROM Usuarios');
      SQL.Add('INNER JOIN GruposAcceso ON (Gu_num = Usr_grp)');
      SQL.Add('INNER JOIN GruposFranjas ON (Gf_num = Usr_fra)');
      SQL.Add('WHERE (Usr_nom like :usuario) AND (Gu_nom like :grupo)');
      SQL.Add(orden);
      ParambyName('usuario').AsString := usuario;
      ParambyName('grupo').AsString := grupo;

      Open;
      if RecordCount = 0 then Application.MessageBox('No hay datos a mostrar', 'Mensaje', MB_OK + MB_ICONINFORMATION)
      else
      begin
         {if llave.mododemo and (RecordCount>20) then
             Application.MessageBox('En modo Demostración no se pueden imprimir reportes de más de 20 registros', 'Mensaje', MB_OK + MB_ICONINFORMATION)
         else
         begin}
             if Check1.Checked then     RGruposPers.Print
             else                       RPersonas.Print;
         {end;}
      end;
      Close;
    end;
end;

//---------------------------------------------------------------------------
//
//  REPORTES DE NODOS
//
//---------------------------------------------------------------------------

//---------------------------------------------------------------------------
// AL MOSTRAR PÁGINA 2, CARGA ARBOL DE NODOS
//---------------------------------------------------------------------------

procedure TFReportes.TabSheetNodosShow(Sender: TObject);
var
   Ng, Nn: TTreeNode;       // Variable nodo del arbol
   NTodos: TTreeNode;
   ultimo_grupo, grupo{, nombre}: String;
begin
  // Carga los datos la primera vez que se muestra la ventana
  if ANodos1.Tag = 0 then
  begin
    ANodos1.Items.BeginUpdate;
    ANodos1.Items.Clear;  // Borra items del árbol

    // Crea Grupo raiz
    NTodos := ANodos1.Items.Add(nil, 'Todos los nodos');
    NTodos.ImageIndex := 0;
    NTodos.SelectedIndex := 0;

    // Realiza consulta de todos los grupos de nodos
    with data.Consulta do
    begin
        //SQL.Clear;
        //SQL.Add('SELECT Gn_nom, Gn_num FROM GruposNodos');
        SQL.Text := 'select GruposNodos.Gn_nom, Nodos.Nod_nom ' +
                    'from Nodos, GruposNodos ' +
                    'where Nodos.Nod_grp=GruposNodos.Gn_num ' +
                    'Order by GruposNodos.Gn_nom';
        Open;

        ultimo_grupo := '';

        // Recorre todos los registros
        while not Eof do
        begin
            grupo := FieldbyName('Gn_nom').AsString;

            // Añade grupos al arbol de nodos
            if grupo <> ultimo_grupo then
            begin
              Ng := ANodos1.Items.AddChild(NTodos, grupo);
              Ng.ImageIndex := 1;
              Ng.SelectedIndex := 1;

              ultimo_grupo := grupo;
            end;

            // Añade nodos a ese grupo
            Nn := ANodos1.Items.AddChild(Ng, FieldbyName('Nod_nom').AsString);
            Nn.ImageIndex := 3;
            Nn.SelectedIndex := 3;

            // Añade nodos pertenecientes a ese grupo
            {with data.Consulta2 do
            begin
                SQL.Clear;
                SQL.Add('SELECT Nod_nom FROM Nodos');
                SQL.Add('INNER JOIN GruposNodos ON  (Nod_grp = Gn_num)');
                SQL.Add('WHERE Gn_nom = :grupo');
                ParambyName('grupo').AsString := nombre;
                Open;

                while not Eof do   // Recorre los registros filtrados
                begin
                    Nn := ANodos1.Items.AddChild(Ng, FieldbyName('Nod_nom').AsString);
                    Nn.ImageIndex := 3;
                    Nn.SelectedIndex := 3;

                    Next;
                end;

                Close;
            end;}

            Next;
        end;
        Close;

        // Ordena el arbol
        ANodos1.SortType := stNone;
        ANodos1.SortType := stText;
    end;

    ANodos1.Selected := ANodos1.Items[0];
    ANodos1.Items.Item[0].Expand(False); // Expande Grupos

    Check2.Checked := False;
    ANodos1.Tag := 1;
    ANodos1.Items.EndUpdate;
  end;
  ANodos1Change(ANodos1, ANodos1.Selected);
end;

//---------------------------------------------------------------------------
// ACTUALIZA STATUS BAR CON REPORTE ACTUAL DE NODOS
//---------------------------------------------------------------------------

procedure TFReportes.ANodos1Change(Sender: TObject; Node: TTreeNode);
var
    s : String;
begin
  if ANodos1.Tag = 1 then
  begin
    case Node.Level of
    0:      begin
                s := 'Todos los Nodos';
                Check2.Enabled := True;
                if Check2.Checked then s := s + ' por Grupo';
            end;
    1:      begin
                s := 'Grupo de Nodos "' + Node.Text + '"';
                Check2.Enabled := False;
                Check2.Checked := True;
            end;
    2:      begin
                s := 'Nodo = "' + Node.Text + '"';
                Check2.Enabled := False;
                Check2.Checked := True;
            end;
    end;

    if rdNum.Checked then s := s + ' (Ordenados por Número de Nodo)'
    else                  s := s + ' (Ordenados por Nombre de Nodo)';

    Barra1.Panels[0].Text := 'Reporte de ' + s;
  end;
end;

procedure TFReportes.Check2Click(Sender: TObject);
begin
    ANodos1Change(ANodos1, ANodos1.Selected);
end;

//---------------------------------------------------------------------------
// MUESTRA REPORTE DE NODOS
//---------------------------------------------------------------------------

procedure TFReportes.btnVerNodosClick(Sender: TObject);
var
    nodo, grupo : String;
    orden, orden2 : String;
begin
    // Configura nodo y grupo a consultar
    case ANodos1.Selected.Level of
    0:    begin
              grupo := '%';
              nodo := '%';
          end;
    1:    begin
              grupo := ANodos1.Selected.Text;
              nodo := '%';
          end;
    2:    begin
              grupo := ANodos1.Selected.Parent.Text;
              nodo := ANodos1.Selected.Text;
          end;
    end;

    // Configura ordenamiento de nodos
    if rdNum.Checked then        orden2 := 'Nod_num'
    else                         orden2 := 'Nod_nom';

    if Check2.Checked then       orden := 'ORDER BY Gn_nom, ' + orden2
    else                         orden := 'ORDER BY ' + orden2;

    // Realiza consulta SQL
    with data.Consulta do
    begin
      SQL.Clear;
      SQL.Add('SELECT Nod_nom, Nod_num, Gn_nom FROM Nodos');
      SQL.Add('INNER JOIN GruposNodos ON (Gn_num = Nod_grp)');
      SQL.Add('WHERE (Nod_nom like :nodo) AND (Gn_nom like :grupo)');
      SQL.Add(orden);
      ParambyName('nodo').AsString := nodo;
      ParambyName('grupo').AsString := grupo;

      Open;
      if RecordCount = 0 then Application.MessageBox('No hay datos a mostrar', 'Mensaje', MB_OK + MB_ICONINFORMATION)
      else
      begin
         {if llave.mododemo and (RecordCount>20) then
             Application.MessageBox('En modo Demostración no se pueden imprimir reportes de más de 20 registros', 'Mensaje', MB_OK + MB_ICONINFORMATION)
         else
         begin}
             if Check2.Checked then RGruposNods.Print
             else                   RNodos.Print;
         {end;}
      end;
      Close;
    end;
end;

//---------------------------------------------------------------------------
//
//  REPORTES DE ASIGNACIONES
//
//---------------------------------------------------------------------------

//---------------------------------------------------------------------------
// AL MOSTRAR PÁGINA 3, CARGA ARBOL DE NODOS O DE PERSONAS
//---------------------------------------------------------------------------

procedure TFReportes.TabSheetAsignacionesShow(Sender: TObject);
var
   Ng, Np, Nn: TTreeNode;       // Variable nodo del arbol
   NTodas, NTodos: TTreeNode;
   ultimo_grupo, grupo{, nombre}: String;
begin
  if Arbol1.Tag = 0 then
  begin
    Arbol1.Items.BeginUpdate;
    Arbol1.Items.Clear;      // Borra elementos del arbol

    if rbPers.Checked then
    begin
        // Crea Grupo raiz
        NTodas := Arbol1.Items.Add(nil, 'Todas las personas');
        NTodas.ImageIndex := 0;
        NTodas.SelectedIndex := 0;

        // Realiza consulta de todos los grupos de personas
        with data.Consulta do
        begin
            //SQL.Clear;
            //SQL.Add('SELECT Gu_nom, Gu_num FROM GruposAcceso');
            SQL.Text := 'select GruposAcceso.Gu_nom, Usuarios.Usr_nom ' +
                        'from Usuarios, GruposAcceso ' +
                        'where Usuarios.Usr_grp=GruposAcceso.Gu_num ' +
                        'Order by GruposAcceso.Gu_nom';
            Open;

            ultimo_grupo := '';

            // Recorre todos los registros
            while not Eof do
            begin
                grupo := FieldbyName('Gu_nom').AsString;

                // Añade grupos al arbol de personas
                if grupo <> ultimo_grupo then
                begin
                  Ng := Arbol1.Items.AddChild(NTodas, grupo);
                  Ng.ImageIndex := 1;
                  Ng.SelectedIndex := 1;

                  ultimo_grupo := grupo;
                end;

                // Añade personas a ese grupo
                Np := Arbol1.Items.AddChild(Ng, FieldbyName('Usr_nom').AsString);
                Np.ImageIndex := 2;
                Np.SelectedIndex := 2;

                // Añade personas pertenecientes a ese grupo
                {with data.Consulta2 do
                begin
                    SQL.Clear;
                    SQL.Add('SELECT Usr_nom FROM Usuarios');
                    SQL.Add('INNER JOIN GruposAcceso ON  (Usr_grp = Gu_num)');
                    SQL.Add('WHERE Gu_nom = :grupo');
                    ParambyName('grupo').AsString := nombre;
                    Open;

                    while not Eof do   // Recorre los registros filtrados
                    begin
                        Np := Arbol1.Items.AddChild(Ng, FieldbyName('Usr_nom').AsString);
                        Np.ImageIndex := 2;
                        Np.SelectedIndex := 2;

                        Next;
                    end;
                    Close;
                end;}

                Next;
            end;
            Close;
        end;
    end

    else
    begin
        // Crea Grupo raiz
        NTodos := Arbol1.Items.Add(nil, 'Todos los nodos');
        NTodos.ImageIndex := 0;
        NTodos.SelectedIndex := 0;

        // Realiza consulta de todos los grupos de nodos
        with data.Consulta do
        begin
            //SQL.Clear;
            //SQL.Add('SELECT Gn_nom, Gn_num FROM GruposNodos');
            SQL.Text := 'select GruposNodos.Gn_nom, Nodos.Nod_nom ' +
                        'from Nodos, GruposNodos ' +
                        'where Nodos.Nod_grp=GruposNodos.Gn_num ' +
                        'Order by GruposNodos.Gn_nom';
            Open;

            ultimo_grupo := '';

            // Recorre todos los registros
            while not Eof do
            begin
                grupo := FieldbyName('Gn_nom').AsString;

                // Añade grupos al arbol de personas
                if grupo <> ultimo_grupo then
                begin
                  Ng := Arbol1.Items.AddChild(NTodos, grupo);
                  Ng.ImageIndex := 1;
                  Ng.SelectedIndex := 1;

                  ultimo_grupo := grupo;
                end;

                // Añade nodos a ese grupo
                Nn := Arbol1.Items.AddChild(Ng, FieldbyName('Nod_nom').AsString);
                Nn.ImageIndex := 3;
                Nn.SelectedIndex := 3;

                // Añade personas pertenecientes a ese grupo
                {with data.Consulta2 do
                begin
                    SQL.Clear;
                    SQL.Add('SELECT Nod_nom FROM Nodos');
                    SQL.Add('INNER JOIN GruposNodos ON  (Nod_grp = Gn_num)');
                    SQL.Add('WHERE Gn_nom = :grupo');
                    ParambyName('grupo').AsString := nombre;
                    Open;

                    while not Eof do   // Recorre los registros filtrados
                    begin
                        Nn := Arbol1.Items.AddChild(Ng, FieldbyName('Nod_nom').AsString);
                        Nn.ImageIndex := 3;
                        Nn.SelectedIndex := 3;

                        Next;
                    end;
                    Close;
                end;}

                Next;
            end;
            Close;
        end;
    end;

    with Arbol1 do
    begin
      SortType := stNone;
      SortType := stText;
      Selected := Items[0];
      Items.Item[0].Expand(False); // Expande Grupos
      Tag := 1;
      Items.EndUpdate;
    end;
  end;

  Arbol1Change(Arbol1, Arbol1.Selected);
end;

//---------------------------------------------------------------------------
// SI CAMBIA SELECCIÓN DE RADIOBUTTON, CARGA ARBOL QUE CORRESPONDE
//---------------------------------------------------------------------------

procedure TFReportes.rbClick(Sender: TObject);
begin
    if rbPers.Checked then
    begin
        rb1.Caption := 'Por Nombre de Nodo';
        rb2.Caption := 'Por Número de Nodo';
        rb1.Checked := True;
    end
    else
    begin
        rb1.Caption := 'Por Nombre de Persona';
        rb2.Caption := 'Por Número de Tarjeta';
        rb1.Checked := True;
    end;

    Arbol1.Tag := 0;                 // Fuerza actualización
    TabSheetAsignacionesShow(Self);  // Actualiza arbol
end;

//---------------------------------------------------------------------------
// ACTUALIZA STATUS BAR CON REPORTE ACTUAL DE ASIGNACIONES
//---------------------------------------------------------------------------

procedure TFReportes.Arbol1Change(Sender: TObject; Node: TTreeNode);
var
    s : String;
begin
    // Solo actualiza si ya se cargó todo el contenido
    if Arbol1.Tag = 1 then
    begin
      if rbPers.Checked then   // Reporte por Persona
      begin
          case Node.Level of
          0:      begin
                      s := 'de Todas las Personas';
                  end;
          1:      begin
                      s := 'de Grupo "' + Node.Text + '"';
                  end;
          2:      begin
                      s := 'de "' + Node.Text + '"';
                  end;
          end;
      end
      else                     // Reporte por Nodo
      begin
          case Node.Level of
          0:      begin
                      s := 'en Todos los Nodos';
                  end;
          1:      begin
                      s := 'en Grupo "' + Node.Text + '"';
                  end;
          2:      begin
                      s := 'en Nodo "' + Node.Text + '"';
                  end;
          end;
      end;

      if Check3.Checked then    s := s + ' (Formato Reducido)';

      if rbPers.Checked then
          if rb2.Checked then   s := s + ' (Ordenado por Número de Nodo)'
          else                  s := s + ' (Ordenado por Nombre de Nodo)'
      else
          if rb2.Checked then   s := s + ' (Ordenado por Número de Tarjeta)'
          else                  s := s + ' (Ordenado por Nombre de Persona)';

      Barra1.Panels[0].Text := 'Reporte de Asignaciones ' + s;
    end;
end;

//---------------------------------------------------------------------------
// CAMBIA EL ORDEN DE LA SELECCION
//---------------------------------------------------------------------------

procedure TFReportes.Check3Click(Sender: TObject);
begin
    Arbol1Change(Arbol1, Arbol1.Selected);
end;

//---------------------------------------------------------------------------
// MUESTRA REPORTE DE ASIGNACIONES
//---------------------------------------------------------------------------

procedure TFReportes.btnVerAsignacionesClick(Sender: TObject);
var
    usuario, nodo, grupo : String;
    orden : String;
begin
  // Reporte de Asignaciones por Persona
  if rbPers.Checked then
  begin
      // Setea persona y grupo de personas a consultar
      case Arbol1.Selected.Level of
      0:    begin
                grupo := '%';
                usuario := '%';
            end;
      1:    begin
                grupo := Arbol1.Selected.Text;
                usuario := '%';
            end;
      2:    begin
                grupo := Arbol1.Selected.Parent.Text;
                usuario := Arbol1.Selected.Text;
            end;
      end;

      // Setea el orden de los nodos
      if rb2.Checked then orden := 'Nod_num, Nod_nom'
      else                orden := 'Nod_nom, Nod_num';

      // Realiza consulta SQL
      with data.Consulta do
      begin
        SQL.Clear;
        SQL.Add('SELECT Gu_nom, Usr_nom, Usr_tarj, Usr_cod, Nod_nom, Nod_num');
        SQL.Add('FROM Asignaciones');
        SQL.Add('INNER JOIN Nodos ON (Asg_nod = Nod_id)');
        SQL.Add('INNER JOIN Usuarios ON (Asg_usr = Usr_id)');
        SQL.Add('INNER JOIN GruposAcceso ON (Gu_num = Usr_grp)');
        SQL.Add('WHERE (Usr_nom like :usuario)');
        SQL.Add('AND (Gu_nom like :grupo)');
        SQL.Add('ORDER BY Gu_nom, Usr_nom, ' + orden);
        ParambyName('usuario').AsString := usuario;
        ParambyName('grupo').AsString := grupo;

        Open;
        if RecordCount = 0 then Application.MessageBox('No hay datos a mostrar', 'Mensaje', MB_OK + MB_ICONINFORMATION)
        else
        begin
           {if llave.mododemo and (RecordCount>20) then
              Application.MessageBox('En modo Demostración no se pueden imprimir reportes de más de 20 registros', 'Mensaje', MB_OK + MB_ICONINFORMATION)
           else
           begin}
              if Check3.Checked then RAsigXPers0.Print
              else                   RAsigXPers.Print;
           {end;}
        end;
        Close;
      end;
  end

  // Reporte de Asignaciones por Nodo
  else
  begin
      // Setea nodo y grupo de nodos a consultar
      case Arbol1.Selected.Level of
      0:    begin
                grupo := '%';
                nodo := '%';
            end;
      1:    begin
                grupo := Arbol1.Selected.Text;
                nodo := '%';
            end;
      2:    begin
                grupo := Arbol1.Selected.Parent.Text;
                nodo := Arbol1.Selected.Text;
            end;
      end;

      // Setea el orden de los nodos
      if rb2.Checked then      orden := 'Usr_tarj, Usr_nom'
      else                     orden := 'Usr_nom, Usr_tarj';

      // Realiza consulta SQL
      with data.Consulta do
      begin
        SQL.Clear;
        SQL.Add('SELECT Gn_nom, Nod_nom, Nod_num, Usr_nom, Usr_tarj, Usr_cod, Gu_nom');
        SQL.Add('FROM Asignaciones');
        SQL.Add('INNER JOIN Nodos ON (Asg_nod = Nod_id)');
        SQL.Add('INNER JOIN Usuarios ON (Asg_usr = Usr_id)');
        SQL.Add('INNER JOIN GruposNodos ON (Gn_num = Nod_grp)');
        SQL.Add('INNER JOIN GruposAcceso ON (Gu_num = Usr_grp)');
        SQL.Add('WHERE (Nod_nom like :nodo)');
        SQL.Add('AND (Gn_nom like :grupo)');
        SQL.Add('ORDER BY Gn_nom, Nod_nom, ' + orden);
        ParambyName('nodo').AsString := nodo;
        ParambyName('grupo').AsString := grupo;

        Open;
        if RecordCount = 0 then Application.MessageBox('No hay datos a mostrar', 'Mensaje', MB_OK + MB_ICONINFORMATION)
        else
        begin
           {if llave.mododemo and (RecordCount>20) then
              Application.MessageBox('En modo Demostración no se pueden imprimir reportes de más de 20 registros', 'Mensaje', MB_OK + MB_ICONINFORMATION)
           else
           begin}
              if Check3.Checked then RAsigXNod0.Print
              else                   RAsigXNod.Print;
           {end;}
        end;
        Close;
      end;
  end;
end;

//---------------------------------------------------------------------------
//
//  REPORTES DE EVENTOS
//
//---------------------------------------------------------------------------

//---------------------------------------------------------------------------
// AL MOSTRAR PÁGINA 4, CARGA DATOS Y CONFIGURA REPORTE
//---------------------------------------------------------------------------

procedure TFReportes.TabSheetEventosShow(Sender: TObject);
var
  i : Integer;
  NTodos, Ng, Nn, Np : TTreeNode;
  ultimo_grupo, grupo{, nombre}: String;
begin
  // Inicializa configuración solamente la primera vez que entra
  if TabSheetEventos.Tag = 0 then
  begin
      APersonas2.Items.BeginUpdate;
      ANodos2.Items.BeginUpdate;

      // Carga tipos de eventos
      with data.Consulta do
      begin
          SQL.Clear;
          SQL.Add('SELECT Tip_desc2 FROM Tip_Ev ORDER BY Tip_desc2');
          Open;
          ListaTipos.Items.Clear;

          for i:=0 to RecordCount-1 do
          begin
              ListaTipos.Items.Add(FieldbyName('Tip_desc2').AsString);
              ListaTipos.Selected[i] := True;
              Next;
          end;

          Close;
      end;

      // Carga nodos y grupos de nodos
      with data.Consulta do
      begin
          ANodos2.Items.Clear;  // Borra items del árbol

          // Crea Grupo raiz
          NTodos := ANodos2.Items.Add(nil, 'Todos los nodos');
          NTodos.ImageIndex := 0;
          NTodos.SelectedIndex := 0;

          //SQL.Clear;
          //SQL.Add('SELECT Gn_nom, Gn_num FROM GruposNodos');
          SQL.Text := 'select GruposNodos.Gn_nom, Nodos.Nod_nom ' +
                      'from Nodos, GruposNodos ' +
                      'where Nodos.Nod_grp=GruposNodos.Gn_num ' +
                      'Order by GruposNodos.Gn_nom';
          Open;

          ultimo_grupo := '';

          // Recorre todos los registros
          while not Eof do
          begin
              grupo := FieldbyName('Gn_nom').AsString;

              // Añade grupos al arbol de personas
              if grupo <> ultimo_grupo then
              begin
                Ng := ANodos2.Items.AddChild(NTodos, grupo);
                Ng.ImageIndex := 1;
                Ng.SelectedIndex := 1;

                ultimo_grupo := grupo;
              end;

              // Añade nodos a ese grupo
              Nn := ANodos2.Items.AddChild(Ng, FieldbyName('Nod_nom').AsString);
              Nn.ImageIndex := 3;
              Nn.SelectedIndex := 3;

              // Añade personas pertenecientes a ese grupo
              {with data.Consulta2 do
              begin
                  Close;
                  SQL.Clear;
                  SQL.Add('SELECT Nod_nom FROM Nodos');
                  SQL.Add('INNER JOIN GruposNodos ON (Nod_grp = Gn_num)');
                  SQL.Add('WHERE Gn_nom = :grupo');
                  ParambyName('grupo').AsString := nombre;
                  Open;

                  while not Eof do   // Recorre los registros filtrados
                  begin
                      Nn := ANodos2.Items.AddChild(Ng, FieldbyName('Nod_nom').AsString);
                      Nn.ImageIndex := 3;
                      Nn.SelectedIndex := 3;

                      Next;
                  end;

                  Close;
              end;}

              Next;
          end;
          Close;

          // Ordena el arbol
          ANodos2.SortType := stNone;
          ANodos2.SortType := stText;
          ANodos2.Selected := ANodos2.Items[0];
          ANodos2.Items.Item[0].Expand(False); // Expande Grupos
      end;

      // Carga personas y grupos de personas
      with data.Consulta do
      begin
          APersonas2.Items.Clear;  // Borra items del árbol

          // Crea Grupo raiz
          NTodos := APersonas2.Items.Add(nil, 'Todas las personas');
          NTodos.ImageIndex := 0;
          NTodos.SelectedIndex := 0;

          //SQL.Clear;
          //SQL.Add('SELECT Gu_nom, Gu_num FROM GruposAcceso');
          SQL.Text := 'select GruposAcceso.Gu_nom, Usuarios.Usr_nom ' +
                      'from Usuarios, GruposAcceso ' +
                      'where Usuarios.Usr_grp=GruposAcceso.Gu_num ' +
                      'Order by GruposAcceso.Gu_nom';
          Open;

          ultimo_grupo := '';

          // Recorre todos los registros
          while not Eof do
          begin
              grupo := FieldbyName('Gu_nom').AsString;

              // Añade grupos al arbol de personas
              if grupo <> ultimo_grupo then
              begin
                Ng := APersonas2.Items.AddChild(NTodos, grupo);
                Ng.ImageIndex := 1;
                Ng.SelectedIndex := 1;
              end;

              // Añade personas a ese grupo
              Np := APersonas2.Items.AddChild(Ng, FieldbyName('Usr_nom').AsString);
              Np.ImageIndex := 2;
              Np.SelectedIndex := 2;

              // Añade personas pertenecientes a ese grupo
              {with data.Consulta2 do
              begin
                  SQL.Clear;
                  SQL.Add('SELECT Usr_nom FROM Usuarios');
                  SQL.Add('INNER JOIN GruposAcceso ON (Usr_grp = Gu_num)');
                  SQL.Add('WHERE Gu_nom = :grupo');
                  ParambyName('grupo').AsString := nombre;
                  Open;

                  while not Eof do   // Recorre los registros filtrados
                  begin
                      Np := APersonas2.Items.AddChild(Ng, FieldbyName('Usr_nom').AsString);
                      Np.ImageIndex := 2;
                      Np.SelectedIndex := 2;

                      Next;
                  end;

                  Close;
              end;}

              Next;
          end;
          Close;

          // Ordena el arbol
          APersonas2.SortType := stNone;
          APersonas2.SortType := stText;
          APersonas2.Selected := APersonas2.Items[0];
          APersonas2.Items.Item[0].Expand(False); // Expande Grupos
          APersonas2.Enabled := False;
          CheckGrupPers.Enabled := False;
      end;

      // Llena Combo E/S
      with ComboES do
      begin
          Clear;
          Items.Add('Entradas y Salidas');
          Items.Add('Entradas');
          Items.Add('Salidas');
          ItemIndex := 0;
          Enabled := False;
      end;

      // Configura fecha para reporte
      FechaI.Date := Now - 30;
      FechaF.Date := Now;
      CheckFecha.Checked := True;

      // Configura hora para reporte
      HoraI.Time := StrtoTime('00:00:00');
      HoraF.Time := StrtoTime('00:00:00');
      CheckHora.Checked := True;

      // Todos los eventos
      CheckTodos.Checked := True;

      TabSheetEventos.Tag := 1;

      XXClick(Self);

      APersonas2.Items.EndUpdate;
      ANodos2.Items.EndUpdate;
  end;

  Escribe_Barra;
end;

//---------------------------------------------------------------------------
// ACTUALIZA CHECKBOX DE TODOS LOS TIPOS AL CAMBIAR LAS SELECCIONES
//---------------------------------------------------------------------------

procedure TFReportes.XXClick(Sender: TObject);
var
    i: Integer;
    todos_los_tipos: Boolean;
    hab_p: Boolean;
begin
    // Chequea si todos los tipos están seleccionados
    todos_los_tipos := True;
    for i:=0 to ListaTipos.Items.Count-1 do
        if not ListaTipos.Selected[i] then
            todos_los_tipos := False;
    ck_todostipos.Checked := todos_los_tipos;

    // Chequea si está seleccionado solo "Accesos" (De cualquier tipo)
    {if ListaTipos.Selected[0] or
       ListaTipos.Selected[5] or
       ListaTipos.Selected[8] then  hab_p := True
    else                            hab_p := False;
    for i:=1 to ListaTipos.Items.Count-1 do
        if ListaTipos.Selected[i] and (not i in [0,5,8]) then
        begin
           hab_p := False;
           break;
        end;}

    hab_p := True;
    for i:=0 to ListaTipos.Items.Count-1 do
    begin
       if not (i in [0]) and ListaTipos.Selected[i] then
       begin
          hab_p := False;
          break;
       end;
    end;

    APersonas2.Enabled := hab_p;
    CheckGrupPers.Enabled := hab_p;
    if CheckGrupPers.Enabled = False then CheckGrupPers.Checked := False;
    ComboES.Enabled := hab_p;
    if not ComboES.Enabled then ComboES.ItemIndex := 0;

    // Chequea si están seleccionados todos los eventos
    if todos_los_tipos and (ANodos2.Selected.Level=0) and (APersonas2.Selected.Level=0) and
       CheckFecha.Checked and CheckHora.Checked and (ComboES.ItemIndex=0) then
        CheckTodos.Checked := True
    else
        CheckTodos.Checked := False;

    Escribe_Barra;
end;

//---------------------------------------------------------------------------
// SELECCIONA TODOS LOS TIPOS AL CLIQUEAR TODOS LOS TIPOS
//---------------------------------------------------------------------------

procedure TFReportes.ck_todostiposClick(Sender: TObject);
var
    i : Integer;
begin
    if ck_todostipos.Checked then
    begin
        for i:=0 to ListaTipos.Items.Count-1 do
            ListaTipos.Selected[i] := True;
        APersonas2.Enabled := False;
        CheckGrupPers.Enabled := False;
        CheckGrupPers.Checked := False;
        ComboES.Enabled := False;
        ComboES.ItemIndex := 0;
    end;
    Escribe_Barra;
end;

//---------------------------------------------------------------------------
// NO PERMITE QUE LA FECHA INICIAL SEA MAYOR QUE LA FINAL
//---------------------------------------------------------------------------

procedure TFReportes.FechaChange(Sender: TObject);
begin
    if FechaI.Date > FechaF.Date then FechaI.Date := FechaF.Date;
    Escribe_Barra;
end;

//---------------------------------------------------------------------------
// CAMBIA SELECCION A TODOS LOS EVENTOS SI SE SELECCIONA OPCION
//---------------------------------------------------------------------------

procedure TFReportes.CheckTodosClick(Sender: TObject);
var
    i : Integer;
begin
    if CheckTodos.Checked then
    begin
        // Selecciona todos los eventos
        for i:=0 to ListaTipos.Items.Count-1 do
            ListaTipos.Selected[i] := True;
        ck_todostipos.Checked := True;

        ANodos2.Selected := ANodos2.Items[0];
        //APersonas2.Enabled := True;
        APersonas2.Selected := APersonas2.Items[0];

        CheckFecha.Checked := True;
        CheckHora.Checked := True;
        ComboES.Enabled := True;
        ComboES.ItemIndex := 0;
    end;
    Escribe_Barra;
end;

//---------------------------------------------------------------------------
// NO PERMITE AGRUPAR POR LOS DOS
//---------------------------------------------------------------------------

procedure TFReportes.CheckGrupClick(Sender: TObject);
begin
    if (Sender as TCheckBox).Name = 'CheckGrupNod' then
    begin
        if CheckGrupNod.Checked then
            CheckGrupPers.Checked := False;
    end
    else
    begin
        if CheckGrupPers.Checked then
            CheckGrupNod.Checked := False;
    end;
end;

//---------------------------------------------------------------------------
// SI CAMBIA LA HORA ACTUALIZA REPORTE
//---------------------------------------------------------------------------

procedure TFReportes.HoraChange(Sender: TObject);
begin
    Escribe_Barra;
end;

//---------------------------------------------------------------------------
// VA ESCRIBIENDO EN LA BARRA DE ESTADO EL REPORTE ACTUAL
//---------------------------------------------------------------------------

procedure Escribe_Barra;
var
    s : String;
    i : Integer;
begin
    s := 'Muestra ';

    with FReportes do
    begin

      // Escribe el tipo de evento
      if ck_todostipos.Checked then
          s := s + 'Todos los Eventos '
      else
      begin
          for i:=0 to ListaTipos.Items.Count-1 do
          begin
              if ListaTipos.Selected[i] then
              begin
                  s := s + ListaTipos.Items.Strings[i] + ', ';
              end;
          end;
      end;

      // Escribe de que nodo
      case ANodos2.Selected.Level of
      0:   s := s + 'en Todos los Nodos, ';
      1:   s := s + 'en ' + ANodos2.Selected.Text + ', ';
      2:   s := s + 'en ' + ANodos2.Selected.Text + ', ';
      end;

      // Escribe de que persona
      if APersonas2.Enabled then
      begin
        case APersonas2.Selected.Level of
        0:   s := s + 'de Todas las Personas ';
        1:   s := s + 'de ' + APersonas2.Selected.Text + ' ';
        2:   s := s + 'de ' + APersonas2.Selected.Text + ' ';
        end;
      end;

      // Escribe en que fecha
      if not CheckFecha.Checked then
        s := s + 'desde ' + DatetoStr(FechaI.Date) +
                 ' hasta ' + DatetoStr(FechaF.Date) + ' ';

      // Escribe a que hora
      if not CheckHora.Checked then
        s := s + 'desde ' + TimetoStr(HoraI.Time) +
                 ' hasta ' + TimetoStr(HoraF.Time) + ' ';

      // Escribe E/S
      if (ComboES.Enabled) and (ComboES.ItemIndex <> 0) then
        s := s + '(' + ComboES.Text + ')';

      Barra1.Panels[0].Text := s;
      Barra1.Hint := s;
    end;
end;

//---------------------------------------------------------------------------
// MUESTRA REPORTE DE EVENTOS
//---------------------------------------------------------------------------

procedure TFReportes.btnVerEventosClick(Sender: TObject);
var
    A_o_I, Solo_Accesos : Boolean;
    i : Integer;
    tipos_str : String;
    fechas_str, fecha0, fecha1 : String;
    horas_str, hora0, hora1 : String;
    nodos_str, conjunto, nodo : String;
    personas_str, grupo, persona : String;
    es_str : String;

begin
    with ListaTipos do
    begin
      // Chequea si se seleccionó Accesos, Intrusos, Caducidad o Fuera Horario
      A_o_I := (Selected[0] or Selected[9] or Selected[5] or Selected[8]);

      // Chequea si sólo está seleccionado Accesos
      Solo_Accesos := Selected[0] and not(Selected[1] and Selected[2] and
        Selected[3] and Selected[4] and Selected[5] and Selected[6] and Selected[7]
        and Selected[8] and Selected[9] and Selected[10]);
    end;

    // Configura cadena para filtrar por tipo de evento
    if ck_todostipos.Checked then tipos_str := ''  // Muestra todos los tipos
    else
    begin                   // Agrega filtros por tipo
      tipos_str := 'AND (Ev_tipo = "." ';
      for i:=0 to ListaTipos.Items.Count-1 do
      begin
          if ListaTipos.Selected[i] then
          begin
              case i of
                0:      tipos_str := tipos_str + 'OR Ev_tipo = "A" ';
                1:      tipos_str := tipos_str + 'OR Ev_tipo = "U" ';
                2:      tipos_str := tipos_str + 'OR Ev_tipo = "P" ';
                3:      tipos_str := tipos_str + 'OR Ev_tipo = "R" ';
                4:      tipos_str := tipos_str + 'OR Ev_tipo = "T" ';
                5:      tipos_str := tipos_str + 'OR Ev_tipo = "C" ';
                6:      tipos_str := tipos_str + 'OR Ev_tipo = "S" ';
                7:      tipos_str := tipos_str + 'OR Ev_tipo = "B" ';
                8:      tipos_str := tipos_str + 'OR Ev_tipo = "F" ';
                9:      tipos_str := tipos_str + 'OR Ev_tipo = "I" ';
                10:     tipos_str := tipos_str + 'OR Ev_tipo = "O" ';
              end;
          end;
      end;
      tipos_str := tipos_str + ') ';
    end;

    // Configura cadena para filtrar por fechas
    if CheckFecha.Checked then
      fechas_str := ''           // Todos los días
    else
    begin
      fecha0 := Copy(DatetoStr(FechaI.Date),7,4)+Copy(DatetoStr(FechaI.Date),3,4)+Copy(DatetoStr(FechaI.Date),1,2);
      fecha1 := Copy(DatetoStr(FechaF.Date),7,4)+Copy(DatetoStr(FechaF.Date),3,4)+Copy(DatetoStr(FechaF.Date),1,2);
      fechas_str := 'AND ((Eventos.Ev_fecha2 >= "' + fecha0 + '"' +
                    ') AND (Eventos.Ev_fecha2 <= "' + fecha1 + '"))'
    end;

    // Configura cadena para filtrar por rango horario
    if CheckHora.Checked then
        horas_str := ''          // Las 24 hs
    else
    begin
      hora0 := TimetoStr(HoraI.Time);
      hora1 := TimetoStr(HoraF.Time);

      if hora0 <= hora1 then
          horas_str := 'AND ((Ev_hora >= "' + hora0 + '") AND (Ev_hora <= "' + hora1 + '"))'
      else
          horas_str := 'AND ((Ev_hora >= "' + hora0 + '") OR (Ev_hora <= "' + hora1 + '"))';
    end;

    // Configura cadena para filtrar por nodo
    if ANodos2.Selected.Level = 0 then
        nodos_str := ''         // Todos los nodos
    else
    begin
      case ANodos2.Selected.Level of
      1:  begin conjunto := ANodos2.Selected.Text;          nodo := '%'; end;
      2:  begin conjunto := ANodos2.Selected.Parent.Text;   nodo := ANodos2.Selected.Text; end;
      end;

      nodos_str := 'AND ((Gn_nom like "' + conjunto + '") AND (Ev_nod like "' + nodo + '"))';
    end;

    // Configura cadena para filtrar por Persona y por E/S
    if APersonas2.Enabled then
    begin
      // Filtro de personas
      if APersonas2.Selected.Level = 0 then
          personas_str := ''
      else
      begin
        case APersonas2.Selected.Level of
        1:  begin grupo := APersonas2.Selected.Text;          persona := '%'; end;
        2:  begin grupo := APersonas2.Selected.Parent.Text;   persona := APersonas2.Selected.Text; end;
        end;

        personas_str := 'AND ((Gu_nom like "' + grupo + '") AND (Ev_pers like "' + persona + '"))';
      end;

      // Filtro de E/S
      case ComboES.ItemIndex of
      0:  es_str := '';
      1:  es_str := 'AND Ev_es = "E"';
      2:  es_str := 'AND Ev_es = "S"';
      end;
    end
    else
    begin
      personas_str := '';      // No filtra personas
      es_str := '';            // No filtra E/S
    end;

    // Realiza consulta SQL
    with data.Consulta do
    begin
      SQL.Clear;

      SQL.Add('SELECT Tip_desc, Ev_pers, Ev_tarj, Ev_nod, Ev_fecha, Ev_fecha2, Ev_hora, Ev_es, Nod_num, Gn_nom');
      if APersonas2.Enabled then SQL.Add(', Gu_nom');

      SQL.Add('FROM Eventos');

      SQL.Add('INNER JOIN Tip_ev ON (Ev_tipo = Tip_id)');
      SQL.Add('LEFT OUTER JOIN Nodos ON (Ev_nod = Nod_nom)');
      SQL.Add('LEFT OUTER JOIN GruposNodos ON (Nod_grp = Gn_num)');

      if APersonas2.Enabled then
      begin
        SQL.Add('LEFT OUTER JOIN Usuarios ON (Usr_nom = Ev_pers)');
        SQL.Add('LEFT OUTER JOIN GruposAcceso ON (Usr_grp = Gu_num)');
      end;

      SQL.Add('WHERE Ev_fecha like "%"');  // Filtro dummy

      if tipos_str <> '' then    SQL.Add(tipos_str);     // Filtra por tipo de evento
      if fechas_str <> '' then   SQL.Add(fechas_str);    // Filtra por fechas
      if horas_str <> '' then    SQL.Add(horas_str);     // Filtra por horario
      if nodos_str <> '' then    SQL.Add(nodos_str);     // Filtra por nodo
      if personas_str <> '' then SQL.Add(personas_str);     // Filtra por persona
      if es_str <> '' then       SQL.Add(es_str);     // Filtra por E/S

      // Depende como se agrupen los eventos, ordena la consulta
      if CheckGrupNod.Checked then
        SQL.Add('ORDER BY Gn_Nom, Ev_nod, Ev_fecha2, Ev_hora')
      else if (CheckGrupPers.Checked) and (APersonas2.Enabled) then
        SQL.Add('ORDER BY Gu_Nom, Ev_pers, Ev_fecha2, Ev_hora')
      else
        SQL.Add('ORDER BY Ev_fecha2, Ev_hora');

      Open;

      // Imprime reporte solo si hay registros a imprimir
      if RecordCount = 0 then Application.MessageBox('No hay datos a mostrar', 'Mensaje', MB_OK + MB_ICONINFORMATION)
      else
      begin
         {if llave.mododemo and (RecordCount>20) then
            Application.MessageBox('En modo Demostración no se pueden imprimir reportes de más de 20 registros', 'Mensaje', MB_OK + MB_ICONINFORMATION)
         else
         begin}
            // El reporte incluye Accesos o Intrusos
            if A_o_I then
            begin
              // Si el reporte es de accesos solamente
              if Solo_Accesos then
                // Accesos agrupados por nodo
                if CheckGrupNod.Checked then         REvAccGrupNod.Print
                // Accesos agrupados por persona
                else if CheckGrupPers.Checked then   REvAccGrupPers.Print
                // Accesos sin agrupar
                else                                 REvGeneral.Print

              // El reporte tiene accesos e intrusos y más tipos quizás
              else
                if CheckGrupNod.Checked then         REvGeneralGrupNod.Print
                else                                 REvGeneral.Print;
            end

            // El reporte no incluye Accesos ni Intrusos
            else
            begin
              // Si está agrupado por nodos
              if CheckGrupNod.Checked then           REvEspecGrupNod.Print
              // Si no, reporte normal
              else                                   REvEspec.Print;
            end;
         {end;}
      end;
      Close;
    end;
end;

//---------------------------------------------------------------------------
// SALE DEL MÓDULO DE REPORTES
//---------------------------------------------------------------------------

procedure TFReportes.Sale(Sender: TObject);
begin
     Close;
end;

end.
