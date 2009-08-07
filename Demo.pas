unit Demo;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, ExtCtrls, Buttons;

type
  TFDemo = class(TForm)
    Label1: TLabel;
    BitBtn1: TBitBtn;
    Label2: TLabel;
    Image1: TImage;
    procedure SpeedButton1Click(Sender: TObject);
    procedure FormShow(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  FDemo: TFDemo;

implementation

uses Serkey;

{$R *.DFM}

procedure TFDemo.SpeedButton1Click(Sender: TObject);
begin
     ModalResult := mrOK;
end;

procedure TFDemo.FormShow(Sender: TObject);
begin
   if HARDDEMO then
   begin
      Label2.Caption := 'El software funcionará en modo'#10#13 +
                        'demostración, por lo que algunas'#10#13 +
                        'funciones estarán limitadas en su uso,'#10#13 +
                        'como las comunicaciones con los nodos'#10#13 +
                        #10#13 +
                        'MODO DEMOSTRACIÓN';
   end;
end;

end.
