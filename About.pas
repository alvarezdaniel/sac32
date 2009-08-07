//---------------------------------------------------------------------------
//
//  Módulo de Acerca de...
//
//
//  Creación 09-12-2000
//  Cambio Año 2000->2001 15-01-2001
//  Recuperación de información de versión desde archivos 20-01-2001
//  Finalización de Módulo 07-02-2001
//  Cambio de interfase, nuevo modelo 29-03-2001
//
//  A Hacer:
//           Huevo de Pascua
//
//
//---------------------------------------------------------------------------

unit About;

interface

uses Windows, SysUtils, Classes, Graphics, Forms, Controls, StdCtrls,
  Buttons, ExtCtrls, ShellApi, Dialogs;

type

  TEPInfo = class
  private
    { Private declarations }
    FLangId           : string;
    FExeName          : string;
    FCompanyName      : string;
    FFileDescription  : string;
    FFileVersion      : string;
    FInternalName     : string;
    FLegalCopyright   : string;
    FLegalTradeMarks  : string;
    FOriginalFilename : string;
    FProductName      : string;
    FProductVersion   : string;
    FComments         : string;
  public
    { Public declarations }
    constructor Create;
    procedure GetInfo;
  end;

  TFAbout = class(TForm)
    GroupBox1: TGroupBox;
    Bevel1: TBevel;
    Panel1: TPanel;
    Image1: TImage;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Authorlab: TLabel;
    fwintypelab: TLabel;
    fmemavailablelab: TLabel;
    btnSalir: TSpeedButton;
    Label4: TLabel;
    mailurl: TLabel;
    lblEmail: TLabel;
    btnRegistrar: TSpeedButton;
    Button1: TButton;
    btnEmpresa: TSpeedButton;
    procedure btnSalirClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure mailurlClick(Sender: TObject);
    procedure FormKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure FormKeyUp(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure CambiaEmpresa(Sender: TObject);
    procedure btnRegistrarClick(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure btnEmpresaClick(Sender: TObject);
  private
    { Private declarations }
    MemStat   : TMemoryStatus;
    OS : TOSVersionInfo;
    fversionbuild : string;
  public
    { Public declarations }
  end;

var
  FAbout: TFAbout;

implementation

uses Principal, Serkey, Rutinas, RegUnit1;

{$R *.DFM}

//---------------------------------------------------------------------------
// INICIALIZACIÓN DE LA CLASE
//---------------------------------------------------------------------------

constructor TEPInfo.Create;
begin
  inherited Create;

  FLangId           := '040C';
  FExeName          := '';
  FCompanyName      := '';
  FFileDescription  := '';
  FFileVersion      := '';
  FInternalName     := '';
  FLegalCopyright   := '';
  FLegalTradeMarks  := '';
  FOriginalFilename := '';
  FProductName      := '';
  FProductVersion   := '';
  FComments         := '';
end;

//---------------------------------------------------------------------------
// RECOPILA INFORMACIÓN DEL EJECUTABLE O DLL
//---------------------------------------------------------------------------

procedure TEPInfo.GetInfo;
var
  loc_InfoBufSize : integer;
  loc_InfoBuf     : PChar;
  loc_VerBufSize  : integer;
  loc_VerBuf      : PChar;
begin
  loc_InfoBufSize := GetFileVersionInfoSize(PChar(FExeName), DWORD(loc_InfoBufSize));
  if loc_InfoBufSize > 0 then
  begin
    loc_InfoBuf := AllocMem(loc_InfoBufSize);
    GetFileVersionInfo(PChar(FExeName), 0, loc_InfoBufSize, loc_InfoBuf);

    VerQueryValue(loc_InfoBuf, PChar('StringFileInfo\' + FLangId + '04E4\CompanyName'), Pointer(loc_VerBuf), DWORD(loc_VerBufSize));
    FCompanyName := loc_VerBuf;

    VerQueryValue(loc_InfoBuf, PChar('StringFileInfo\' + FLangId + '04E4\FileDescription'), Pointer(loc_VerBuf), DWORD(loc_VerBufSize));
    FFileDescription := loc_VerBuf;

    VerQueryValue(loc_InfoBuf, PChar('StringFileInfo\' + FLangId + '04E4\FileVersion'), Pointer(loc_VerBuf), DWORD(loc_VerBufSize));
    FFileVersion := loc_VerBuf;

    VerQueryValue(loc_InfoBuf, PChar('StringFileInfo\' + FLangId + '04E4\InternalName'), Pointer(loc_VerBuf), DWORD(loc_VerBufSize));
    FInternalName := loc_VerBuf;

    VerQueryValue(loc_InfoBuf, PChar('StringFileInfo\' + FLangId + '04E4\LegalCopyright'), Pointer(loc_VerBuf), DWORD(loc_VerBufSize));
    FLegalCopyright := loc_VerBuf;

    VerQueryValue(loc_InfoBuf, PChar('StringFileInfo\' + FLangId + '04E4\LegalTradeMarks'), Pointer(loc_VerBuf), DWORD(loc_VerBufSize));
    FLegalTradeMarks := loc_VerBuf;

    VerQueryValue(loc_InfoBuf, PChar('StringFileInfo\' + FLangId + '04E4\OriginalFilename'), Pointer(loc_VerBuf), DWORD(loc_VerBufSize));
    FOriginalFilename := loc_VerBuf;

    VerQueryValue(loc_InfoBuf, PChar('StringFileInfo\' + FLangId + '04E4\ProductName'), Pointer(loc_VerBuf), DWORD(loc_VerBufSize));
    FProductName := loc_VerBuf;

    VerQueryValue(loc_InfoBuf, PChar('StringFileInfo\' + FLangId + '04E4\ProductVersion'), Pointer(loc_VerBuf), DWORD(loc_VerBufSize));
    FProductVersion := loc_VerBuf;

    VerQueryValue(loc_InfoBuf, PChar('StringFileInfo\' + FLangId + '04E4\Comments'), Pointer(loc_VerBuf), DWORD(loc_VerBufSize));
    FComments := loc_VerBuf;

    FreeMem(loc_InfoBuf, loc_InfoBufSize);
  end;
end;

//---------------------------------------------------------------------------
// MUESTRA LA VENTANA DE ABOUT
//---------------------------------------------------------------------------

procedure TFAbout.FormShow(Sender: TObject);
var
   Info : TEPInfo;
   Floatit : Double;
begin
    // Crea objeto recolector de información
    Info := TEPInfo.Create;

    Info.FLangId := '0C0A';
    Info.FExeName := ExtractFileName(Application.ExeName);
    Info.GetInfo;
    Label1.Caption := Info.FFileDescription;
    Label2.Caption := Info.FInternalName + ' versión ' + Info.FFileVersion; // + ' Serie ' + InttoStr(llave.Serie);

    // Pone si modo full o modo descargador
    if llave.modofull then
      Label2.Caption := Label2.Caption + ' [SAC32 FULL]'
    else
      Label2.Caption := Label2.Caption + ' [SAC32 Descargador]';

    Label3.Caption := Info.FLegalCopyright;
    Label4.Caption := 'Software licenciado a ' + llave.Empresa;  

    OS.dwOSVersionInfoSize := sizeof(OS);
    GetVersionEx(OS);
    with OS do
    begin
      FVersionBuild := Format(' %d.%d', [dwMajorVersion, dwMinorVersion]) +
                       Format(' (Build %d)', [LOWORD(dwBuildNumber)]);
      case dwPlatformId of
        VER_PLATFORM_WIN32s : FWinTypelab.Caption := 'Windows 3.1x/32s' + FVersionBuild;
        VER_PLATFORM_WIN32_WINDOWS :
        begin
          if dwMinorVersion >= 90 then
             FwinTypelab.Caption := 'Windows ME' + FVersionBuild
          else if dwMinorVersion > 0 then
             FwinTypelab.Caption := 'Windows 98' + FVersionBuild
          else
             FwinTypelab.Caption := 'Windows 95' + FVersionBuild;
        end;
        VER_PLATFORM_WIN32_NT :
        begin
          if (dwMajorVersion > 4) then
             FWinTypelab.Caption := 'Windows 2000' + FversionBuild
          else
             FWinTypelab.Caption := 'Windows NT' + FversionBuild;
        end;
      end;
    end;
    MemStat.dwLength := sizeof(MemStat);
    GlobalMemoryStatus(MemStat);
    with MemStat do
    begin
       Floatit := dwTotalPhys / 1024;
       FMemAvailablelab.Caption := 'Memoria disponible para Windows:  ' +
                                   Format('%.0n KB',[Floatit]);
    end;

    // Destruye objeto recolector de información
    Info.Free;

    // 05/04/2003  - Habilita el botón de registrar si no está registrado
    FPrincipal.AVLockPro1.Read;
    btnRegistrar.Enabled := not FPrincipal.AVLockPro1.Registered;

    Panel1.SetFocus;

    {$IFDEF TITA}
    btnEmpresa.Visible := False;
    btnRegistrar.Visible := False;
    {$ENDIF}
end;

//---------------------------------------------------------------------------
// VUELVE AL PROGRAMA
//---------------------------------------------------------------------------

procedure TFAbout.btnSalirClick(Sender: TObject);
begin
     ModalResult := mrOK;
end;

//---------------------------------------------------------------------------
// MANDA UN MAIL
//---------------------------------------------------------------------------

procedure TFAbout.mailurlClick(Sender: TObject);
var
   h: Integer;
   zFname: array[0..79] of Char;
begin
   h := ShellExecute(
         0,                   //handle to parent window
         'open',              //string specifing operation to perform
         StrPcopy(zFname, 'mailto:' + mailurl.Caption + '?subject=Info SAC32 Software'),
         Nil,                 //pointer to exe-file parameters string
         Nil,                 //pointer to string specifing default directory
         SW_SHOWNORMAL);

   if h < 33 then
      MessageDlg('No se puede abrir Explorador', mtError, [mbOk], 0);
end;

//---------------------------------------------------------------------------
// HUEVO DE PASCUA
//---------------------------------------------------------------------------

procedure TFAbout.FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
begin
   if (Key = Ord('V')) and (ssCtrl in Shift) and (ssAlt in Shift) then
   begin
      lblEmail.Visible := True;
      mailurl.Visible := True;
      Authorlab.Visible := True;
   end;
end;

procedure TFAbout.FormKeyUp(Sender: TObject; var Key: Word; Shift: TShiftState);
begin
   if (Key = Ord('V')) and (ssCtrl in Shift) and (ssAlt in Shift) then
   begin
      lblEmail.Visible := False;
      mailurl.Visible := False;
      Authorlab.Visible := False;
   end;
end;

procedure TFAbout.CambiaEmpresa(Sender: TObject);
var
  s: String;
begin
  {$IFNDEF TITA}
  // Corrección 24/04/2004 - En modo MUESTRA no se puede cambiar la empresa
  if modo_muestra then
  begin
    Application.MessageBox('En el modo MUESTRA no se puede cambiar el nombre de la empresa', 'Mensaje', MB_OK + MB_ICONINFORMATION);
  end
  else
  begin
    s := ReadReg_S('Empresa');
    if InputQuery('Personalización de Empresa', 'Ingrese el nombre de la Empresa', s) then
    begin
      WriteReg_S('Empresa', s);
      Self.FormShow(nil);
      //Label4.Caption := 'Software licenciado a ' + llave.empresa;
      Config_Serkey;
    end;
  end;
  {$ENDIF}
end;

procedure TFAbout.btnRegistrarClick(Sender: TObject);
var
  F: TRegForm1;
  s: String;
  Result: Boolean;
begin
  FPrincipal.AVLockPro1.DoExecute;
  Config_Serkey;
  Exit;

  Result:=False;
  //setreg;
  if FPrincipal.avlockpro1.firsttime then FPrincipal.avlockpro1.maketrial;
  if FPrincipal.avlockpro1.Authorized then FPrincipal.avlockpro1.writelastdate;
  if (FPrincipal.avlockpro1.Registered or (FPrincipal.avlockpro1.Authorized and (FPrincipal.avlockpro1.EndDate-date > 10) and not FPrincipal.avlockpro1.Expired)) then Result:=True;
  if not result {or force} then with FPrincipal.avlockpro1 do begin
    WriteLastDate;
    Result:=False;
    F:=TRegForm1.Create(nil);
    try
    F.Caption:=AppName;
    F.EdCodInstal.text:=Instalcode;
    F.BtnOk.Enabled:=not expired;
    F.Panel1.Visible := not registered and not expired;

    if authorized then s:='authorized ' else s:= 'evaluation ';
    if expired then s:=s+'period expired.'
    else s:= 'You are in the day '+inttostr(trunc(now-begindate+1))
    +' of your '+inttostr(days)+' day '+s+'period.';
    if registered then s:='Application registered.';
    F.Ltext.caption:=s;

    s:='';
    F.memo2.Clear;
    if m1 then s:=s+'  >'+module1Text;
    if m2 then s:=s+'  >'+module2Text;
    if m3 then s:=s+'  >'+module3Text;
    if m4 then s:=s+'  >'+module4Text;
    if m5 then s:=s+'  >'+module5Text;
    if m6 then s:=s+'  >'+module6Text;
    if m7 then s:=s+'  >'+module7Text;
    if m8 then s:=s+'  >'+module8Text;
    F.memo2.Lines.add(s);

    {F.memo1.Lines.Clear;
    with FPrincipal.avlockpro1 do begin
      if expired then F.memo1.lines.add(TextExpired)
      else if not registered and (EndDate-date < 11) then F.memo1.lines.add(TextWarning)
      else if not registered and not authorized
      then F.memo1.lines.add(TextCongratulation);
    end;}
    F.LDate1.Caption := datetostr(begindate);
    F.LDate2.Caption := datetostr(enddate);
    F.PBar1.Min :=0;
    F.PBar1.Max :=trunc(enddate-begindate);
    F.Pbar1.Position := trunc(date-begindate);

    F.ClientWidth:=F.Line2.Left+F.Line2.Width+3;
    F.ClientHeight:=F.btnOk.Top+F.btnOk.Height+20;

    F.ShowModal;
    if F.modalresult = mrYes then begin
      if check(F.Edit1.text) then begin
        erasereg;
        write(F.Edit1.text);
        //setreg;
        showmessage('Registration successful');
        if not expired then Result:=True;
      end else showmessage('Invalid Registration Code');
      F.Panel1.Visible := not registered and not expired;
    end;
    if (F.modalresult = mrOk) and not expired then Result:=True;
    finally
    F.Free;
    end;
  end;

  Config_Serkey;
end;

procedure TFAbout.Button1Click(Sender: TObject);
begin
  // Corrección 05/08/2003 - Daniel - Permite desregistrar la aplicación
  FPrincipal.AVLockPro1.EraseReg;
end;

procedure TFAbout.btnEmpresaClick(Sender: TObject);
begin
  Label4.OnDblClick(nil);
end;

end.

