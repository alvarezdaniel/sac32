unit AdminTCPIP;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  Buttons, Placemnt;

type
  TFAdminTCPIP = class(TForm)
    btnOcultar: TSpeedButton;
    frmStore: TFormStorage;
    procedure btnOcultarClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  FAdminTCPIP: TFAdminTCPIP;

implementation

{$R *.DFM}

procedure TFAdminTCPIP.btnOcultarClick(Sender: TObject);
begin
  Close;
end;

procedure TFAdminTCPIP.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  Action := caHide;
end;

end.
