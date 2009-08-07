//---------------------------------------------------------------------------
//
//  Módulo de Chequeo de Registros Huérfanos
//
// Finalización de Módulo 07-02-2001
//
//---------------------------------------------------------------------------

unit Huerfanos;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, Buttons, ComCtrls, Menus;

type
  TFOrphan = class(TForm)
    GroupBox1: TGroupBox;
    SpeedButton2: TSpeedButton;
    sb: TStatusBar;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    btncheck1: TButton;
    btncheck2: TButton;
    btncheck3: TButton;
    btncheck4: TButton;
    btnrep1: TButton;
    btnrep2: TButton;
    btnrep3: TButton;
    btnrep4: TButton;
    mnu_eventos: TPopupMenu;
    Checktipo: TMenuItem;
    Checktarj: TMenuItem;
    Checkpers: TMenuItem;
    Checknodo: TMenuItem;
    procedure SpeedButton2Click(Sender: TObject);
    procedure btncheck1Click(Sender: TObject);
    procedure btnrep1Click(Sender: TObject);
    procedure btncheck2Click(Sender: TObject);
    procedure btncheck3Click(Sender: TObject);
    procedure btncheck4Click(Sender: TObject);
    procedure btnrep2Click(Sender: TObject);
    procedure btnrep3Click(Sender: TObject);
    procedure btnrep4Click(Sender: TObject);
    procedure ChecktipoClick(Sender: TObject);
    procedure ChecktarjClick(Sender: TObject);
    procedure CheckpersClick(Sender: TObject);
    procedure ChecknodoClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  FOrphan: TFOrphan;
  st : String;

implementation

uses Datos;

{$R *.DFM}

procedure TFOrphan.SpeedButton2Click(Sender: TObject);
begin
     ModalResult := mrCancel;
end;

//---------------------------------------------------------------------------
// VERIFICA LA PRESENCIA DE ASIGNACIONES HUERFANAS
//---------------------------------------------------------------------------

procedure TFOrphan.btncheck1Click(Sender: TObject);
begin
  with data.Consulta do
  begin
    SQL.Clear;
    SQL.Add('SELECT * FROM Asignaciones ');
    SQL.Add('WHERE Asg_usr NOT IN (SELECT Usr_id FROM Usuarios) OR ');
    SQL.Add('      Asg_nod NOT IN (SELECT Nod_id FROM Nodos)');
    Open;
    if RecordCount = 0 then
       sb.SimpleText := 'La tabla de asignaciones no tiene registros inválidos'
    else
       sb.SimpleText := 'La tabla de asignaciones tiene ' + InttoStr(RecordCount) + ' registros inválidos';
    Close;
  end;
end;

//---------------------------------------------------------------------------
// VERIFICA LA PRESENCIA DE USUARIOS HUERFANOS
//---------------------------------------------------------------------------

procedure TFOrphan.btncheck2Click(Sender: TObject);
begin
    with data.Consulta do
    begin
        SQL.Clear;
        SQL.Add('SELECT * FROM Usuarios');
        SQL.Add('WHERE Usr_grp NOT IN (SELECT Gu_num FROM GruposAcceso)');
        Open;
        if RecordCount = 0 then
           sb.SimpleText := 'La tabla de usuarios no tiene registros inválidos'
        else
           sb.SimpleText := 'La tabla de usuarios tiene ' + InttoStr(RecordCount) + ' registros inválidos';
        Close;
    end;
end;

//---------------------------------------------------------------------------
// VERIFICA LA PRESENCIA DE NODOS HUERFANOS
//---------------------------------------------------------------------------

procedure TFOrphan.btncheck3Click(Sender: TObject);
begin
    with data.Consulta do
    begin
        SQL.Clear;
        SQL.Add('SELECT * FROM Nodos');
        SQL.Add('WHERE Nod_grp NOT IN (SELECT Gn_num FROM GruposNodos)');
        Open;
        if RecordCount = 0 then
           sb.SimpleText := 'La tabla de nodos no tiene registros inválidos'
        else
           sb.SimpleText := 'La tabla de nodos tiene ' + InttoStr(RecordCount) + ' registros inválidos';
        Close;
    end;
end;

//---------------------------------------------------------------------------
// VERIFICA LA PRESENCIA DE EVENTOS HUERFANOS
//---------------------------------------------------------------------------

procedure TFOrphan.btncheck4Click(Sender: TObject);
begin
     mnu_eventos.Tag := 0;
     mnu_eventos.Popup(Mouse.CursorPos.X, Mouse.CursorPos.Y);;
end;

//---------------------------------------------------------------------------
// ELIMINA LAS ASIGNACIONES HUERFANAS
//---------------------------------------------------------------------------

procedure TFOrphan.btnrep1Click(Sender: TObject);
begin
   with data.Consulta do
   begin
      SQL.Clear;
      SQL.Add('DELETE FROM Asignaciones');
      SQL.Add('WHERE Asg_usr NOT IN (SELECT Usr_id FROM Usuarios)');
      SQL.Add('OR    Asg_nod NOT IN (SELECT Nod_id FROM Nodos)');
      ExecSQL;
      Close;
   end;

   sb.SimpleText := 'Asignaciones inválidas eliminadas';
end;

//---------------------------------------------------------------------------
// ELIMINA LOS USUARIOS HUERFANOS
//---------------------------------------------------------------------------

procedure TFOrphan.btnrep2Click(Sender: TObject);
begin
   with data.Consulta do
   begin
      SQL.Clear;
      SQL.Add('DELETE FROM Usuarios');
      SQL.Add('WHERE Usr_grp NOT IN (SELECT Gu_num FROM GruposAcceso)');
      ExecSQL;
      Close;
   end;

   sb.SimpleText := 'Usuarios inválidos eliminados';
end;

//---------------------------------------------------------------------------
// ELIMINA LOS NODOS HUERFANOS
//---------------------------------------------------------------------------

procedure TFOrphan.btnrep3Click(Sender: TObject);
begin
   with data.Consulta do
   begin
      SQL.Clear;
      SQL.Add('DELETE FROM Nodos');
      SQL.Add('WHERE Nod_grp NOT IN (SELECT Gn_num FROM GruposNodos)');
      ExecSQL;
      Close;
   end;

   sb.SimpleText := 'Nodos inválidos eliminados';
end;

//---------------------------------------------------------------------------
// ELIMINA LOS EVENTOS HUERFANOS
//---------------------------------------------------------------------------

procedure TFOrphan.btnrep4Click(Sender: TObject);
begin
     mnu_eventos.Tag := 1;
     mnu_eventos.Popup(Mouse.CursorPos.X, Mouse.CursorPos.Y);;
end;

//---------------------------------------------------------------------------
// CHEQUEA Y REPARA LOS EVENTOS CON TIPO INCORRECTO
//---------------------------------------------------------------------------

procedure TFOrphan.ChecktipoClick(Sender: TObject);
begin
    with data.Consulta do
    begin
        SQL.Clear;

        if mnu_eventos.Tag = 0 then
        begin
          SQL.Add('SELECT * FROM Eventos');
          SQL.Add('WHERE Ev_tipo NOT IN (SELECT Tip_id FROM Tip_Ev)');
          Open;
          if RecordCount = 0 then
             sb.SimpleText := 'La tabla de eventos no tiene tipos inválidos'
          else
             sb.SimpleText := 'La tabla de eventos tiene ' + InttoStr(RecordCount) + ' registros inválidos';
          Close;
        end
        else
        begin
          SQL.Add('DELETE FROM Eventos');
          SQL.Add('WHERE Ev_tipo NOT IN (SELECT Tip_id FROM Tip_Ev)');
          ExecSQL;
          Close;
          sb.SimpleText := 'Eventos con tipos inválidos eliminados';
        end;
    end;
end;

//        SQL.Add('OR    Ev_nod  NOT IN (SELECT Nod_nom FROM Nodos)');

//---------------------------------------------------------------------------
// CHEQUEA Y REPARA LOS EVENTOS CON TARJETAS INEXISTENTES
//---------------------------------------------------------------------------

procedure TFOrphan.ChecktarjClick(Sender: TObject);
begin
    with data.Consulta do
    begin
        SQL.Clear;

        if mnu_eventos.Tag = 0 then
        begin
          SQL.Add('SELECT * FROM Eventos');
          SQL.Add('WHERE (Ev_tarj NOT IN (SELECT Usr_tarj FROM Usuarios))');
          SQL.Add('AND (Ev_tipo = "A")');
          Open;
          if RecordCount = 0 then
             sb.SimpleText := 'La tabla de eventos no tiene tarjetas inexistentes'
          else
             sb.SimpleText := 'La tabla de eventos tiene ' + InttoStr(RecordCount) + ' registros inválidos';
          Close;
        end
        else
        begin
          SQL.Add('DELETE FROM Eventos');
          SQL.Add('WHERE (Ev_tarj NOT IN (SELECT Usr_tarj FROM Usuarios))');
          SQL.Add('AND (Ev_tipo = "A")');
          ExecSQL;
          Close;
          sb.SimpleText := 'Eventos con tarjetas inexistentes eliminados';
        end;
    end;
end;

//---------------------------------------------------------------------------
// CHEQUEA Y REPARA LOS EVENTOS CON PERSONAS INEXISTENTES
//---------------------------------------------------------------------------

procedure TFOrphan.CheckpersClick(Sender: TObject);
begin
    with data.Consulta do
    begin
        SQL.Clear;

        if mnu_eventos.Tag = 0 then
        begin
          SQL.Add('SELECT * FROM Eventos');
          SQL.Add('WHERE (Ev_pers NOT IN (SELECT Usr_nom FROM Usuarios))');
          SQL.Add('AND (Ev_tipo = "A")');
          Open;
          if RecordCount = 0 then
             sb.SimpleText := 'La tabla de eventos no tiene personas inexistentes'
          else
             sb.SimpleText := 'La tabla de eventos tiene ' + InttoStr(RecordCount) + ' registros inválidos';
          Close;
        end
        else
        begin
          SQL.Add('DELETE FROM Eventos');
          SQL.Add('WHERE (Ev_pers NOT IN (SELECT Usr_nom FROM Usuarios))');
          SQL.Add('AND (Ev_tipo = "A")');
          ExecSQL;
          Close;
          sb.SimpleText := 'Eventos con personas inexistentes eliminados';
        end;
    end;
end;

//---------------------------------------------------------------------------
// CHEQUEA Y REPARA LOS EVENTOS CON NODOS INEXISTENTES
//---------------------------------------------------------------------------

procedure TFOrphan.ChecknodoClick(Sender: TObject);
begin
    with data.Consulta do
    begin
        SQL.Clear;

        if mnu_eventos.Tag = 0 then
        begin
          SQL.Add('SELECT * FROM Eventos');
          SQL.Add('WHERE (Ev_nod NOT IN (SELECT Nod_nom FROM Nodos))');
          Open;
          if RecordCount = 0 then
             sb.SimpleText := 'La tabla de eventos no tiene nodos inexistentes'
          else
             sb.SimpleText := 'La tabla de eventos tiene ' + InttoStr(RecordCount) + ' registros inválidos';
          Close;
        end
        else
        begin
          SQL.Add('DELETE FROM Eventos');
          SQL.Add('WHERE (Ev_nod NOT IN (SELECT Nod_nom FROM Nodos))');
          ExecSQL;
          Close;
          sb.SimpleText := 'Eventos con nodos inexistentes eliminados';
        end;
    end;
end;

end.

