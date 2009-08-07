//---------------------------------------------------------------------------
//
//  Ventana de cambio de clave de un usuario
//
//
// Chequeo OK 09-12-2000
// Finalización de Unit 07-02-2001
//
//---------------------------------------------------------------------------

unit Pwd;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, Buttons;

type
  TFPwd = class(TForm)
    Editpwd1: TEdit;
    Editpwd2: TEdit;
    Label1: TLabel;
    BitBtn1: TBitBtn;
    BitBtn2: TBitBtn;
    Label2: TLabel;
    Editpwd3: TEdit;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  FPwd: TFPwd;

implementation

{$R *.DFM}

end.
