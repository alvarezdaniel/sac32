//---------------------------------------------------------------------------
//
//  Módulo de Chequeo de Comunicación con los Nodos
//
//
// Inicio 31-01-2001
// Chequeo de paquetes más rápido 17-03-2001
//
//---------------------------------------------------------------------------

unit Test;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, ComCtrls, ToolWin, Buttons, AdStatLt;

type
  TFTest = class(TForm)
    btnPrueba: TSpeedButton;
    btnCancelar: TSpeedButton;
    btnSalir: TBitBtn;
    ani: TAnimate;
    Label1: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    Label6: TLabel;
    Edit1: TEdit;
    Edit2: TEdit;
    Edit3: TEdit;
    Edit4: TEdit;
    barra: TProgressBar;
    litot: TApdStatusLight;
    liok: TApdStatusLight;
    liko: TApdStatusLight;
    procedure FormShow(Sender: TObject);
    procedure btnPruebaClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  FTest: TFTest;
  nodo : Integer;

implementation

uses Rutinas, Comunicaciones, Datos, ConfigNodo;

{$R *.DFM}


//---------------------------------------------------------------------------
// RECUPERA NÚMERO DE NODO A CHEQUEAR
//---------------------------------------------------------------------------

procedure TFTest.FormShow(Sender: TObject);
begin
    // Consulta número del nodo a chequear
    with data.Consulta do
    begin
       SQL.Clear;
       SQL.Add('SELECT Nod_num FROM Nodos WHERE Nod_nom = :nodo');
       ParambyName('nodo').AsString := FConfigNodo.ANodos.Selected.Text;
       Open;
       nodo := FieldbyName('Nod_num').AsInteger;
       Close;
    end;
end;

//---------------------------------------------------------------------------
// INICIA PRUEBA DE COMUNICACIÓN
//---------------------------------------------------------------------------

procedure TFTest.btnPruebaClick(Sender: TObject);
var
    e : TStatus;
    s : String;
    ok, ko, total : Integer;
begin
    total := 0;
    ok := 0;
    ko := 0;
    Edit1.Text := '0';
    Edit2.Text := '0';
    Edit3.Text := '0';
    Edit1.Text := InttoStr(total);
    Edit2.Text := InttoStr(ok);
    Edit3.Text := InttoStr(ko);
    Edit4.Text := '0.00%';
    ani.Active := True;
    btnSalir.Enabled := False;

    while not btnCancelar.Down do
    begin
        litot.Lit := True;

        if p.Get_Status(nodo, e) then
        begin
             liok.Lit := True;
             inc(ok);
        end
        else
        begin
             liko.Lit := True;
             inc(ko);
        end;
        //sleep(5);

        inc(total);

        if total=0 then s:='0.00%' else s := Format('%4.2f%%', [100*(ko/total)]);

        Edit1.Text := InttoStr(total);
        Edit2.Text := InttoStr(ok);
        Edit3.Text := InttoStr(ko);
        Edit4.Text := s;
        barra.Position := Trunc(100*(ko/total));
        Application.ProcessMessages;

        litot.Lit := False;
        liok.Lit := False;
        liko.Lit := False;
        //sleep(100);
    end;

    ani.Active := False;
    btnSalir.Enabled := True;
end;

end.
