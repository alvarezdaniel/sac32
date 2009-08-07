object FOrphan: TFOrphan
  Left = 462
  Top = 237
  BorderIcons = []
  BorderStyle = bsToolWindow
  Caption = 'Registros Huérfanos'
  ClientHeight = 188
  ClientWidth = 294
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  Position = poScreenCenter
  PixelsPerInch = 96
  TextHeight = 13
  object GroupBox1: TGroupBox
    Left = 0
    Top = 0
    Width = 294
    Height = 188
    Align = alClient
    ParentShowHint = False
    ShowHint = True
    TabOrder = 0
    object SpeedButton2: TSpeedButton
      Left = 128
      Top = 136
      Width = 153
      Height = 25
      Hint = 'Vuelve a la ventana de mantenimiento'
      Caption = '&Salir'
      Flat = True
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
      OnClick = SpeedButton2Click
    end
    object Label1: TLabel
      Left = 8
      Top = 16
      Width = 113
      Height = 13
      Caption = 'Asignaciones huérfanas'
    end
    object Label2: TLabel
      Left = 8
      Top = 48
      Width = 93
      Height = 13
      Caption = 'Usuarios Huérfanos'
    end
    object Label3: TLabel
      Left = 8
      Top = 80
      Width = 83
      Height = 13
      Caption = 'Nodos Huérfanos'
    end
    object Label4: TLabel
      Left = 8
      Top = 112
      Width = 91
      Height = 13
      Caption = 'Eventos Huérfanos'
    end
    object sb: TStatusBar
      Left = 2
      Top = 167
      Width = 290
      Height = 19
      Panels = <>
      SimplePanel = True
    end
    object btncheck1: TButton
      Left = 128
      Top = 16
      Width = 75
      Height = 17
      Hint = 
        'Verifica que la tabla de asignaciones no contenga personas o nod' +
        'os inválidos'
      Caption = 'Verificar'
      TabOrder = 1
      OnClick = btncheck1Click
    end
    object btncheck2: TButton
      Left = 128
      Top = 48
      Width = 75
      Height = 17
      Hint = 'Verifica que la tabla de usuarios no contenga personas sin grupo'
      Caption = 'Verificar'
      TabOrder = 2
      OnClick = btncheck2Click
    end
    object btncheck3: TButton
      Left = 128
      Top = 80
      Width = 75
      Height = 17
      Hint = 'Verifica que la tabla de nodos no contenga nodos sin grupo'
      Caption = 'Verificar'
      TabOrder = 3
      OnClick = btncheck3Click
    end
    object btncheck4: TButton
      Left = 128
      Top = 112
      Width = 75
      Height = 17
      Hint = 
        'Verifica que la tabla de eventos no contenga eventos de personas' +
        ', nodos o tarjetas inexistentes'
      Caption = 'Verificar'
      PopupMenu = mnu_eventos
      TabOrder = 4
      OnClick = btncheck4Click
    end
    object btnrep1: TButton
      Left = 208
      Top = 16
      Width = 75
      Height = 17
      Hint = 'Elimina de la tabla de asignaciones los registros inválidos'
      Caption = 'Eliminar'
      TabOrder = 5
      OnClick = btnrep1Click
    end
    object btnrep2: TButton
      Left = 208
      Top = 48
      Width = 75
      Height = 17
      Hint = 'Elimina de la tabla de usuarios los registros inválidos'
      Caption = 'Eliminar'
      TabOrder = 6
      OnClick = btnrep2Click
    end
    object btnrep3: TButton
      Left = 208
      Top = 80
      Width = 75
      Height = 17
      Hint = 'Elimina de la tabla de nodos los registros inválidos'
      Caption = 'Eliminar'
      TabOrder = 7
      OnClick = btnrep3Click
    end
    object btnrep4: TButton
      Left = 208
      Top = 112
      Width = 75
      Height = 17
      Hint = 'Elimina de la tabla de eventos los registros inválidos'
      Caption = 'Eliminar'
      PopupMenu = mnu_eventos
      TabOrder = 8
      OnClick = btnrep4Click
    end
  end
  object mnu_eventos: TPopupMenu
    Left = 48
    Top = 136
    object Checktipo: TMenuItem
      Caption = 'Tipo de evento incorrecto'
      OnClick = ChecktipoClick
    end
    object Checktarj: TMenuItem
      Caption = 'Tarjetas inexistentes'
      OnClick = ChecktarjClick
    end
    object Checkpers: TMenuItem
      Caption = 'Personas inexistentes'
      OnClick = CheckpersClick
    end
    object Checknodo: TMenuItem
      Caption = 'Nodos inexistentes'
      OnClick = ChecknodoClick
    end
  end
end
