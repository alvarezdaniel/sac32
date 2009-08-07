object FLimitacionesDescargador: TFLimitacionesDescargador
  Left = 358
  Top = 242
  BorderIcons = [biSystemMenu]
  BorderStyle = bsDialog
  Caption = 'Limitaciones SAC32 modo descargador'
  ClientHeight = 235
  ClientWidth = 412
  Color = clBtnFace
  Font.Charset = ANSI_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = [fsBold]
  OldCreateOrder = False
  Position = poScreenCenter
  PixelsPerInch = 96
  TextHeight = 13
  object Memo1: TMemo
    Left = 0
    Top = 0
    Width = 412
    Height = 235
    Align = alClient
    Lines.Strings = (
      'Limitaciones del modo descargador:'
      '======================='
      ''
      '1) No está disponible la recepción de eventos on-line.'
      '2) De las 16 franjas horarias, sólo están disponibles 3.'
      '3) El módulo de seguridad no está habilitado.'
      '4) La función de localizador de personas no está habilitada.'
      '5) No se puede utilizar la apertura remota.'
      '6) No se puede utilizar el bloqueo/desbloqueo de nodos.'
      '7) No se pueden utilizar las alarmas y atenciones de alarmas.'
      '8) No se puede habilitar la descarga automática.'
      '9) No se pueden cargar las fotos para las personas.'
      '10) No se pueden dar de alta más de 200 personas.'
      '11) No se pueden dar de alta más de 2 grupos de nodos.'
      '12) No se pueden dar de alta más de 2 nodos.'
      
        '13) No se muestra la ventana de login (No hay módulo de segurida' +
        'd).')
    ReadOnly = True
    TabOrder = 0
  end
end
