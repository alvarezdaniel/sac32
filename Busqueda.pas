//---------------------------------------------------------------------------
//
//  Ventana para Búsqueda de Personas
//
//
//  Revisión General OK 09-12-2000
//  Agregado de botones flat 09-12-2000
//  Finalización de Módulo 01-02-2001
//
//
//  A hacer:
//           Autocompletar como tiene Internet Explorer
//
//---------------------------------------------------------------------------

unit Busqueda;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, Buttons;

type
  TFBusqueda = class(TForm)
    Label1: TLabel;
    ComboBox1: TComboBox;
    btnAcepta: TSpeedButton;
    SpeedButton1: TSpeedButton;
    procedure btnAceptaClick(Sender: TObject);
    procedure SpeedButton1Click(Sender: TObject);
    procedure ComboBox1KeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  FBusqueda: TFBusqueda;

implementation

{$R *.DFM}

procedure TFBusqueda.btnAceptaClick(Sender: TObject);
begin
     ModalResult := mrOK;
end;

procedure TFBusqueda.SpeedButton1Click(Sender: TObject);
begin
     ModalResult := mrCancel;
end;

procedure TFBusqueda.ComboBox1KeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
   if Key = VK_RETURN then
      ModalResult := mrOK

   else if Key = VK_ESCAPE then
        ModalResult := mrCancel;
end;

end.
