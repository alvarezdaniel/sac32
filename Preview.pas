//---------------------------------------------------------------------------
//
// Módulo de vista previa del Reporte
// (RBuilder\Source\ppPrvDlg unit modificado)
//
// 08-12-2000 Mejora de la interfase, cambio de nombres de componentes
// Finalización de Módulo 06-02-2001
// 04-10-2001 Agregado de exportación del reporte
//
//
// A Hacer:
//          Mejora de la interfase.
//
//---------------------------------------------------------------------------

unit Preview;

interface

{$I ppIfDef.pas}

uses
  Windows, ComCtrls, SysUtils, Messages, Classes, Graphics, Controls, Forms, ExtCtrls, StdCtrls, Mask, Buttons,
  ppForms, ppTypes, ppProd, ppDevice, ppViewr, Dialogs, ppUtils, EC_Main,
  EC_DataSet, EC_Table;

type
  TFPreview = class(TppCustomPreviewer)
    barra: TPanel;
    Vista: TppViewer;
    panel: TPanel;
    btnCompleta: TSpeedButton;
    btnPrimera: TSpeedButton;
    btnAnterior: TSpeedButton;
    btnSiguiente: TSpeedButton;
    btnUltima: TSpeedButton;
    btnAncho: TSpeedButton;
    btn100: TSpeedButton;
    mskPagina: TMaskEdit;
    btnSalir: TSpeedButton;
    btnPrint: TSpeedButton;
    btnExportar: TSpeedButton;
    ExportTable1: TExportTable;
    procedure btnPrintClick(Sender: TObject);
    procedure btnCompletaClick(Sender: TObject);
    procedure btnPrimeraClick(Sender: TObject);
    procedure btnAnteriorClick(Sender: TObject);
    procedure btnSiguienteClick(Sender: TObject);
    procedure btnUltimaClick(Sender: TObject);
    procedure mskPaginaKeyPress(Sender: TObject; var Key: Char);
    procedure ppViewerPageChange(Sender: TObject);
    procedure ppViewerStatusChange(Sender: TObject);
    procedure btnAnchoClick(Sender: TObject);
    procedure btn100Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure VistaPrintStateChange(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure btnSalirClick(Sender: TObject);
    procedure btnExportarClick(Sender: TObject);

  private
    FStatusBar: TStatusBar;

  protected
    function  GetViewer: TObject; override;

  public
    procedure Init; override;

  end;

var
  FPreview: TFPreview;

implementation

uses Comunicaciones, Rutinas, Serkey, Datos;

{$R *.DFM}

//---------------------------------------------------------------------------
// Crea el nuevo form de vista previa
//---------------------------------------------------------------------------

procedure TFPreview.FormCreate(Sender: TObject);
begin
    FStatusBar := TStatusBar.Create(Self);  // Crea un status bar
    FStatusBar.Parent      := Self;         // sin parent
    FStatusBar.SimplePanel := True;         // modo panel simple
    FStatusBar.Align       := alBottom;     // alineado abajo
end;

//---------------------------------------------------------------------------
// Cierra el form
//---------------------------------------------------------------------------

procedure TFPreview.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  Action := caFree;             // Libera la memoria del form y lo cierra
end;

//---------------------------------------------------------------------------
// Inicializa el form
//---------------------------------------------------------------------------

procedure TFPreview.Init;
begin
  if (Report is TppProducer) then
    begin
      // Configura de que reporte saca los datos a mostrar
      Vista.Report := TppProducer(Report);
    end;

  // Setea el tipo de Zoom anteriormente grabado
  case ReadReg_I('Preview.Zoom') of
   0:   Vista.ZoomSetting := zsWholePage;
   1:   Vista.ZoomSetting := zsPageWidth;
   2:   Vista.ZoomSetting := zs100Percent;
  end;

  // Presiona botón correspondiente
  btnCompleta.Down := (Vista.ZoomSetting = zsWholePage);
  btnAncho.Down := (Vista.ZoomSetting = zsPageWidth);
  btn100.Down := (Vista.ZoomSetting = zs100Percent);

  // Si no existen en el registro las variables, centra el reporte
  if ReadReg_I('Preview.Width') = 0 then
  begin
       Width := 520;
       Height := 600;
       Left := (Screen.Width - Width) div 2;
       Top := (Screen.Height - Height) div 2;
       WindowState := wsNormal;
  end
  else
  begin
    Left := ReadReg_I('Preview.Left');
    Top := ReadReg_I('Preview.Top');
    Width := ReadReg_I('Preview.Width');
    Height := ReadReg_I('Preview.Height');
    WindowState := TWindowState(ReadReg_I('Preview.WindowState'));
  end;
end;

//---------------------------------------------------------------------------
// TppPrintPreview.GetViewer = Devuelve visor para mostrar reporte
//---------------------------------------------------------------------------

function TFPreview.GetViewer: TObject;
begin
  Result := Vista;
end;

//---------------------------------------------------------------------------
// Cambia estado de viewer
//---------------------------------------------------------------------------

procedure TFPreview.VistaPrintStateChange(Sender: TObject);
var
  lPosition: TPoint;
begin
  // Cuando está ocupado, deshabilita controles
  if Vista.Busy then
    begin
      mskPagina.Enabled := False;
      barra.Cursor := crHourGlass;
      Vista.PaintBox.Cursor := crHourGlass;
      FStatusbar.Cursor := crHourGlass;
      btnSalir.Cursor := crArrow;
      btnSalir.Caption := 'Cancelar';
    end
  else
    begin
      mskPagina.Enabled := True;
      barra.Cursor := crDefault;
      Vista.PaintBox.Cursor := crDefault;
      FStatusbar.Cursor := crDefault;
      btnSalir.Cursor := crDefault;
      btnSalir.Caption := 'Salir'; 
    end;

  {this code will force the cursor to update}
  GetCursorPos(lPosition);
  SetCursorPos(lPosition.X, lPosition.Y);
end;

//---------------------------------------------------------------------------
// Configura las teclas de avance de páginas
//---------------------------------------------------------------------------

procedure TFPreview.FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
var
  lScrollBar: TControlScrollBar;
begin
   case Key of
       VK_ESCAPE: // Escape
       begin
            Close;
       end;

       VK_UP:  // Cursor arriba = Sube reporte
       begin
           lScrollBar := Vista.ScrollBox.VertScrollBar;
           lScrollBar.Position := lScrollBar.Position - 10;
       end;

       VK_DOWN: // Cursor abajo = Baja reporte
       begin
           lScrollBar := Vista.ScrollBox.VertScrollBar;
           lScrollBar.Position := lScrollBar.Position + 10;
       end;

       VK_LEFT:    // Cursor IZQ = shift reporte izquierda
       begin
           lScrollBar := Vista.ScrollBox.HorzScrollBar;
           lScrollBar.Position := lScrollBar.Position - 10;
       end;

       VK_RIGHT:   // Cursor DER = shift reporte derecha
       begin
           lScrollBar := Vista.ScrollBox.HorzScrollBar;
           lScrollBar.Position := lScrollBar.Position + 10;
       end;

       VK_PRIOR: Vista.PriorPage;  // PgUp = Página anterior

       VK_NEXT:  Vista.NextPage;   // PgDn = Página siguiente

       VK_HOME:
         begin
            Vista.FirstPage;  // Home = Inicio
            lScrollBar := Vista.ScrollBox.VertScrollBar;
            lScrollBar.Position := lScrollBar.Position - Vista.ScrollBox.Height;
         end;

       VK_END:
         begin
            Vista.LastPage;   // End  = Fin
            lScrollBar := Vista.ScrollBox.VertScrollBar;
            lScrollBar.Position := lScrollBar.Position + Vista.ScrollBox.Height;
         end;
   end;
end;

//---------------------------------------------------------------------------
// Cierra el form de preview o cancela el reporte
//---------------------------------------------------------------------------

procedure TFPreview.btnSalirClick(Sender: TObject);
begin
  if TppProducer(Report).Printing then
    Vista.Cancel
  else
  begin
    // Graba información de la ventana de reportes
    WriteReg_I('Preview.Left', Left);
    WriteReg_I('Preview.Top', Top);
    WriteReg_I('Preview.Width', Width);
    WriteReg_I('Preview.Height', Height);
    WriteReg_I('Preview.WindowState', Integer(WindowState));

    if btnCompleta.Down then            WriteReg_I('Preview.Zoom', 0)
    else if btnAncho.Down then          WriteReg_I('Preview.Zoom', 1)
    else if btn100.Down then            WriteReg_I('Preview.Zoom', 2);

    // Cierra la ventana
    Close;
  end;
end;

//---------------------------------------------------------------------------
// Cambia el estado del visor
//---------------------------------------------------------------------------

procedure TFPreview.ppViewerStatusChange(Sender: TObject);
begin
     FStatusBar.SimpleText := Vista.Status;
end;

//---------------------------------------------------------------------------
// Cambia la página del reporte
//---------------------------------------------------------------------------

procedure TFPreview.ppViewerPageChange(Sender: TObject);
begin
     mskPagina.Text := IntToStr(Vista.AbsolutePageNo);
end;

//---------------------------------------------------------------------------
// Imprime el reporte en la impresora
//---------------------------------------------------------------------------

procedure TFPreview.btnPrintClick(Sender: TObject);
begin
     {if llave.mododemo then vdemo else} Vista.Print;
end;

//---------------------------------------------------------------------------
// Cambia las páginas
//---------------------------------------------------------------------------

procedure TFPreview.btnPrimeraClick(Sender: TObject);
begin
     Vista.FirstPage;
end;

procedure TFPreview.btnAnteriorClick(Sender: TObject);
begin
     Vista.PriorPage;
end;

procedure TFPreview.btnSiguienteClick(Sender: TObject);
begin
     Vista.NextPage;
end;

procedure TFPreview.btnUltimaClick(Sender: TObject);
begin
     Vista.LastPage;
end;

//---------------------------------------------------------------------------
// Se cambia el número de página manualmente
//---------------------------------------------------------------------------

procedure TFPreview.mskPaginaKeyPress(Sender: TObject; var Key: Char);
begin
    if (Key = #13) then Vista.GotoPage(StrToInt(mskPagina.Text));
end;

//---------------------------------------------------------------------------
// Cambia el modo de zoom
//---------------------------------------------------------------------------

procedure TFPreview.btnCompletaClick(Sender: TObject);
begin
     Vista.ZoomSetting := zsWholePage;
end;

procedure TFPreview.btnAnchoClick(Sender: TObject);
begin
     Vista.ZoomSetting := zsPageWidth;
end;

procedure TFPreview.btn100Click(Sender: TObject);
begin
     Vista.ZoomSetting := zs100Percent;
end;

procedure TFPreview.btnExportarClick(Sender: TObject);
var
  st: Boolean;
begin
  st := data.Consulta.Active;
  if not data.Consulta.Active then data.Consulta.Open;
  ExportTable1.Choose;
  data.Consulta.Active := st;
end;

{***************************************************************************
*
*      I N I T I A L I Z A T I O N   /   F I N A L I Z A T I O N
*
{***************************************************************************}

initialization

  ppRegisterForm(TppCustomPreviewer, TFPreview);

finalization

  ppUnRegisterForm(TppCustomPreviewer);

end.
