//---------------------------------------------------------------------------
//
//  Ventana de barra de progreso de operaciones
//
//
// 
//
//---------------------------------------------------------------------------

unit Progreso;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, Buttons, Gauges, ComCtrls;

type
  TFProgreso = class(TForm)
    lbl: TLabel;
    barra: TGauge;
    ani: TAnimate;
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  FProgreso: TFProgreso;

implementation

{$R *.DFM}

procedure TFProgreso.FormCloseQuery(Sender: TObject;
  var CanClose: Boolean);
begin
     CanClose := False;
end;

end.
