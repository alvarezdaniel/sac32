//---------------------------------------------------------------------------
//
//  Módulo de Ingreso al sistema (login)
//
//
//  Inicio 05-12-2000
//  Modificaciones 08-12-2000 OK
//  Modificación de logo a SAC32
//  Con Ctrl-Shift-Alt-F11 Ingresa con usuario secreto y clave secreta 05-04-2003
//
//---------------------------------------------------------------------------

unit Login;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, Buttons, ExtCtrls, Registry, ComCtrls;

type
  TFLogin = class(TForm)
    Panel1: TPanel;
    Image1: TImage;
    Bevel1: TBevel;
    Label1: TLabel;
    Editnombre: TEdit;
    Label4: TLabel;
    Editpwd: TEdit;
    Bevel2: TBevel;
    btnAcepta: TSpeedButton;
    btnCancela: TSpeedButton;
    Labelver: TLabel;
    procedure btnAceptaClick(Sender: TObject);
    procedure btnCancelaClick(Sender: TObject);
    procedure EditnombreChange(Sender: TObject);
    procedure EditnombreKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure EditpwdKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure FormKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  FLogin: TFLogin;
  users : String;
  Reg : TRegistry;

implementation

uses Rutinas;

{$R *.DFM}

//---------------------------------------------------------------------------
// PRESIONA EL BOTON ACEPTAR
//---------------------------------------------------------------------------

procedure TFLogin.btnAceptaClick(Sender: TObject);
begin
     ModalResult := mrYes;
end;

//---------------------------------------------------------------------------
// PRESIONA EL BOTON CANCELAR
//---------------------------------------------------------------------------

procedure TFLogin.btnCancelaClick(Sender: TObject);
begin
     ModalResult := mrNo;
end;

//---------------------------------------------------------------------------
// CAMBIA EL NOMBRE Y HABILITA ENTRADA DE CLAVE
//---------------------------------------------------------------------------

procedure TFLogin.EditnombreChange(Sender: TObject);
begin
     if Editnombre.Text <> '' then
     begin
          Editpwd.Enabled := True;
          Label4.Enabled := True;
     end
     else
     begin
          Editpwd.Enabled := False;
          Label4.Enabled := False;
     end;
end;

//---------------------------------------------------------------------------
// CAPTURA TECLAS EN CONTROL
//---------------------------------------------------------------------------

procedure TFLogin.EditnombreKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
begin
   if Key = VK_ESCAPE then ModalResult := mrNo

   else if Key = VK_RETURN then
   begin
      if Editnombre.Text <> '' then Editpwd.SetFocus;
   end

   else if (Key = VK_F11) and (ssCtrl in Shift) and (ssAlt in Shift) and (ssShift in Shift) then
   begin
      Editnombre.Text := USECRETO;
      Editpwd.Text := CSECRETA;
      ModalResult := mrYes;
   end;
end;

//---------------------------------------------------------------------------
// CAPTURA TECLAS EN CONTROL
//---------------------------------------------------------------------------

procedure TFLogin.EditpwdKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
begin
   if Key = VK_ESCAPE then ModalResult := mrNo
   else if Key = VK_RETURN then ModalResult := mrYes;
end;

//---------------------------------------------------------------------------
// CAPTURA TECLAS EL FORM
//---------------------------------------------------------------------------

procedure TFLogin.FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
begin
  if (Key = VK_F12) and (Shift = [ssShift, ssAlt, ssCtrl]) then
  begin
    Editnombre.Text := USECRETO;
    Editpwd.Text := CSECRETA;
    btnAcepta.Click;
  end;
end;

end.
