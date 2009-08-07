unit RegUnit1;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, Buttons, ComCtrls, ExtCtrls, ShellApi, jpeg;

type
  TRegForm1 = class(TForm)
    Label2: TLabel;
    Edit1: TEdit;
    Panel1: TPanel;
    Pbar1: TProgressBar;
    LDate1: TLabel;
    LDate2: TLabel;
    LText: TLabel;
    Lexpire: TLabel;
    RegButton: TButton;
    BtnCancel: TButton;
    Label1: TLabel;
    Memo2: TMemo;
    Label21: TLabel;
    BtnOk: TButton;
    SpeedButton1: TSpeedButton;
    Label6: TLabel;
    Label7: TLabel;
    SpeedButton2: TSpeedButton;
    Label8: TLabel;
    EdName: TEdit;
    EdCompany: TEdit;
    Label10: TLabel;
    Image1: TImage;
    Image2: TImage;
    Image3: TImage;
    Label3: TLabel;
    EdCodInstal: TEdit;
    Label5: TLabel;
    Panel2: TPanel;
    Logo: TImage;
    Memo1: TMemo;
    Line2: TImage;
    Line1: TImage;
    procedure BtnCancelClick(Sender: TObject);
    procedure RegButtonClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure BtnOkClick(Sender: TObject);
    procedure SpeedButton1Click(Sender: TObject);
    procedure SpeedButton2Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

//var
  //RegForm: TRegForm;

implementation

uses Colores, Principal;

{$R *.DFM}

procedure TRegForm1.BtnCancelClick(Sender: TObject);
begin
  modalresult:=mrCancel;
end;

procedure TRegForm1.RegButtonClick(Sender: TObject);
begin
  modalresult:=mrYes;
end;

procedure TRegForm1.FormShow(Sender: TObject);
begin
  EdCodInstal.text := FPrincipal.avlockpro1.InstalCode;
end;

procedure TRegForm1.BtnOkClick(Sender: TObject);
begin
  modalresult:=mrOk;
end;

procedure TRegForm1.SpeedButton1Click(Sender: TObject);
begin
  ShellExecute(0, 'open',
  Pchar('http://www.sac32.com.ar'),
  nil, nil, SW_SHOWMAXIMIZED);
end;

procedure TRegForm1.SpeedButton2Click(Sender: TObject);
begin
  if (Edname.text='') or (edcompany.text='') then showmessage('Se debe ingresar el nombre y la empresa') else
  ShellExecute(self.handle, 'open',pchar(
  'mailto:registrar@sac32.com?Subject=Registración de SAC32 &Body=Name='+EdName.text+
  '%0D%0ACompany='+Edcompany.text+'%0D%0AUserCode='+
  EdcodInstal.text), nil, nil, SW_SHOWNORMAL);
end;

end.
