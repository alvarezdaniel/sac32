object FTest: TFTest
  Left = 463
  Top = 262
  BorderIcons = []
  BorderStyle = bsToolWindow
  Caption = 'Prueba de Comunicaci�n'
  ClientHeight = 197
  ClientWidth = 289
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  Position = poScreenCenter
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object btnPrueba: TSpeedButton
    Left = 8
    Top = 8
    Width = 73
    Height = 25
    GroupIndex = 1
    Caption = 'Iniciar'
    OnClick = btnPruebaClick
  end
  object btnCancelar: TSpeedButton
    Left = 88
    Top = 8
    Width = 73
    Height = 25
    GroupIndex = 1
    Down = True
    Caption = 'Detener'
  end
  object Label1: TLabel
    Left = 8
    Top = 104
    Width = 104
    Height = 13
    Caption = 'Cantidad de paquetes'
  end
  object Label3: TLabel
    Left = 8
    Top = 128
    Width = 83
    Height = 13
    Caption = 'Paquetes buenos'
  end
  object Label4: TLabel
    Left = 8
    Top = 153
    Width = 75
    Height = 13
    Caption = 'Paquetes malos'
  end
  object Label6: TLabel
    Left = 8
    Top = 176
    Width = 90
    Height = 13
    Caption = 'Porcentaje de error'
  end
  object litot: TApdStatusLight
    Left = 168
    Top = 104
    Width = 13
    Height = 13
    Lit = False
    LitColor = clBlue
    NotLitColor = clNavy
  end
  object liok: TApdStatusLight
    Left = 168
    Top = 128
    Width = 13
    Height = 13
    Lit = False
    LitColor = clLime
  end
  object liko: TApdStatusLight
    Left = 168
    Top = 152
    Width = 13
    Height = 13
    Lit = False
    NotLitColor = clPurple
  end
  object btnSalir: TBitBtn
    Left = 208
    Top = 8
    Width = 75
    Height = 25
    Cancel = True
    Caption = '&Volver'
    ModalResult = 2
    TabOrder = 0
    Glyph.Data = {
      C6050000424DC605000000000000360400002800000014000000140000000100
      08000000000090010000330B0000330B00000001000000010000000000007B00
      000000007B007B7B7B000000FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00050505050505
      0505050505050505050505050505050505050505050505050505050505050505
      0505050505050505050305050505050505050505050505050505050503030505
      0505030305050505050505050505040200030305050403030305050505050505
      0505040202000303050200000303050505050505050504020200030304020200
      0305050505050505050505040202000002020202050505050505050505050504
      0202020202020200050505050505050505050505040202020202030505050505
      0505050505050505050402020200030305050505050505050505050505040202
      0200030305050505050505050505050505020202020200030305050505050505
      0505050505020202040200000303050505050505050505050402000305040202
      0003030505050505050505050202030505050402020000050505050505050505
      0402010505050404020005050505050505050505050505050505050504050505
      0505050505050505050505050505050505050505050505050505050505050505
      05050505050505050505}
  end
  object ani: TAnimate
    Left = 8
    Top = 40
    Width = 272
    Height = 60
    Active = False
    CommonAVI = aviCopyFiles
    StopFrame = 34
  end
  object Edit1: TEdit
    Left = 120
    Top = 104
    Width = 41
    Height = 21
    Enabled = False
    ReadOnly = True
    TabOrder = 2
  end
  object Edit2: TEdit
    Left = 120
    Top = 128
    Width = 41
    Height = 21
    Enabled = False
    ReadOnly = True
    TabOrder = 3
  end
  object Edit3: TEdit
    Left = 120
    Top = 152
    Width = 41
    Height = 21
    Enabled = False
    ReadOnly = True
    TabOrder = 4
  end
  object Edit4: TEdit
    Left = 120
    Top = 176
    Width = 41
    Height = 21
    Enabled = False
    ReadOnly = True
    TabOrder = 5
  end
  object barra: TProgressBar
    Left = 176
    Top = 176
    Width = 102
    Height = 16
    Min = 0
    Max = 100
    TabOrder = 6
  end
end