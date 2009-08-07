unit ModoDescargador;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, ExtCtrls, Buttons, Principal;

type
  TFModoDescargador = class(TForm)
    Panel1: TPanel;
    Image1: TImage;
    Label1: TLabel;
    btnSalir: TSpeedButton;
    btnRegistrar: TSpeedButton;
    procedure btnSalirClick(Sender: TObject);
    procedure btnRegistrarClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  FModoDescargador: TFModoDescargador;

implementation

uses Serkey;

{$R *.DFM}

procedure TFModoDescargador.btnSalirClick(Sender: TObject);
begin
  Close;
end;

procedure TFModoDescargador.btnRegistrarClick(Sender: TObject);
begin
  FPrincipal.AVLockPro1.DoExecute;
  Config_Serkey;
end;

end.
