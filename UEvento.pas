//---------------------------------------------------------------------------
//
// Ventana para ver el último evento de una persona
//
//
// Chequeo OK 09-12-2000
// Agregado de visualización de los últimos 20 eventos de esa persona
// Agregado de vista de foto de persona 09-12-2000
// Finalización de Interfase 07-02-2001
// Agregado de ayuda con F1 03-03-2001
//
// A Hacer:
//          Módulo Avanzado de Localizador de Personas
//
//---------------------------------------------------------------------------

unit UEvento;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, Buttons, ExtCtrls, ComCtrls;

type
  TFUEv = class(TForm)
    GroupBox1: TGroupBox;
    Bevel1: TBevel;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Label5: TLabel;
    Label7: TLabel;
    Label8: TLabel;
    btnSalir: TSpeedButton;
    Bevel2: TBevel;
    GroupBox2: TGroupBox;
    Bevel3: TBevel;
    LEv: TListView;
    Bevel4: TBevel;
    Image1: TImage;
    Bevel5: TBevel;
    Label4: TLabel;
    Label6: TLabel;
    procedure btnSalirClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  FUEv: TFUEv;

implementation

{$R *.DFM}

procedure TFUEv.btnSalirClick(Sender: TObject);
begin
     ModalResult := mrYes;
end;



end.
