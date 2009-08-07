unit Paquetes;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls;

type
  TFPaquetes = class(TForm)
    memo: TMemo;
    procedure memoDblClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  FPaquetes: TFPaquetes;

implementation

{$R *.DFM}

procedure TFPaquetes.memoDblClick(Sender: TObject);
begin
     memo.Lines.Clear;
end;

end.
