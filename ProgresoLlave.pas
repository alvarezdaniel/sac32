unit ProgresoLlave;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, Animate, GIFCtrl, ComCtrls, ExtCtrls;

type
  TFProgresoLlave = class(TForm)
    Label1: TLabel;
    ProgressBar1: TProgressBar;
    Timer1: TTimer;
    procedure Timer1Timer(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  FProgresoLlave: TFProgresoLlave;

implementation

{$R *.DFM}

procedure TFProgresoLlave.Timer1Timer(Sender: TObject);
begin
   ProgressBar1.StepIt;
   if ProgressBar1.Position = ProgressBar1.Max then
               ProgressBar1.Position := ProgressBar1.Min;
   Application.ProcessMessages;
end;

end.
