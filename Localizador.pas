//---------------------------------------------------------------------------
//
//  Módulo del Localizador de Personas Monitoreable
//
//
//  No implementado todavía 09-12-2000
//
//---------------------------------------------------------------------------

unit Localizador;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  ComCtrls, ToolWin, ImgList, ExtCtrls, StdCtrls;

type
  TFLocalizador = class(TForm)
    StatusBar1: TStatusBar;
    CoolBar1: TCoolBar;
    ToolBar1: TToolBar;
    btnAgregar: TToolButton;
    ImgLoc: TImageList;
    Panel1: TPanel;
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  FLocalizador: TFLocalizador;

implementation

uses Principal, Comunicaciones, Rutinas;

{$R *.DFM}

//---------------------------------------------------------------------------
// AL CERRAR LA VENTANA, GRABA CONFIGURACIÓN
//---------------------------------------------------------------------------

procedure TFLocalizador.FormClose(Sender: TObject;
  var Action: TCloseAction);
begin
     // Graba configuración de ventana
     WriteReg_I('Loc.Top', FLocalizador.Top);
     WriteReg_I('Loc.Left', FLocalizador.Left);
     WriteReg_I('Loc.Width', FLocalizador.Width);
     WriteReg_I('Loc.Height', FLocalizador.Height);

     loc := False;
     Free;
end;

end.
