unit ModoMuestra;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  Buttons, StdCtrls, ExtCtrls;

type
  TFModoMuestra = class(TForm)
    btnCerrar: TSpeedButton;
    Label1: TLabel;
    Label2: TLabel;
    Timer1: TTimer;
    procedure btnCerrarClick(Sender: TObject);
    procedure Timer1Timer(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
  private
    { Private declarations }
  public
    { Public declarations }
    Timeout: Integer;
  end;

implementation

{$R *.DFM}

procedure TFModoMuestra.btnCerrarClick(Sender: TObject);
begin
  Close;
end;

procedure TFModoMuestra.Timer1Timer(Sender: TObject);
begin
  Timeout := Timeout - 1;
  btnCerrar.Caption := '&Salir (' + InttoStr(Timeout) + ')';
  if Timeout = 0 then
  begin
    Timer1.Enabled := False;
    btnCerrar.Enabled := True;
    btnCerrar.Caption := '&Salir';
  end;
end;

procedure TFModoMuestra.FormShow(Sender: TObject);
begin
  btnCerrar.Enabled := False;
  Timeout := 10;
  Timer1.Enabled := True;
  Timer1Timer(nil);
end;

procedure TFModoMuestra.FormCloseQuery(Sender: TObject; var CanClose: Boolean);
begin
  if Timeout <> 0 then CanClose := False;
end;

end.
