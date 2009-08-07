object FSeg: TFSeg
  Left = 273
  Top = 188
  HelpContext = 60000
  BorderIcons = []
  BorderStyle = bsToolWindow
  Caption = 'Módulo de Seguridad y Usuarios'
  ClientHeight = 311
  ClientWidth = 671
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  Position = poScreenCenter
  OnClose = FormClose
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object status1: TStatusBar
    Left = 0
    Top = 292
    Width = 671
    Height = 19
    Panels = <>
    SimplePanel = True
  end
  object CoolBar1: TCoolBar
    Left = 0
    Top = 0
    Width = 671
    Height = 26
    AutoSize = True
    Bands = <
      item
        Control = ToolBar1
        ImageIndex = -1
        MinHeight = 22
        Width = 667
      end>
    object ToolBar1: TToolBar
      Left = 9
      Top = 0
      Width = 654
      Height = 22
      AutoSize = True
      ButtonWidth = 104
      Caption = 'ToolBar1'
      EdgeBorders = []
      Flat = True
      HotImages = ImgSeg
      Images = ImgSeg
      List = True
      ParentShowHint = False
      ShowCaptions = True
      ShowHint = True
      TabOrder = 0
      Transparent = True
      object btnNuevoUsuario: TToolButton
        Left = 0
        Top = 0
        Hint = 'Crea un nuevo usuario'
        AutoSize = True
        Caption = 'Usuario nuevo'
        ImageIndex = 1
        ParentShowHint = False
        ShowHint = True
        OnClick = btnNuevoUsuarioClick
      end
      object btnBorrarUsuario: TToolButton
        Left = 100
        Top = 0
        Hint = 'Borra un usuario'
        AutoSize = True
        Caption = 'Borra usuario'
        ImageIndex = 3
        OnClick = btnBorrarUsuarioClick
      end
      object btnCambiaNombre: TToolButton
        Left = 193
        Top = 0
        Hint = 'Cambia el nombre de un usuario'
        Caption = 'Modifica usuario'
        ImageIndex = 4
        OnClick = btnCambiaNombreClick
      end
      object btnCambiaClave: TToolButton
        Left = 297
        Top = 0
        Hint = 'Cambia la clave de un usuario'
        AutoSize = True
        Caption = 'Cambia clave'
        ImageIndex = 5
        OnClick = btnCambiaClaveClick
      end
      object btnCopia: TToolButton
        Left = 392
        Top = 0
        Hint = 'Copia los flags de opciones de otro usuario'
        AutoSize = True
        Caption = 'Copia opciones'
        ImageIndex = 6
        OnClick = btnCopiaClick
      end
      object btnSalir: TToolButton
        Left = 496
        Top = 0
        Hint = 'Cierra el módulo de seguridad'
        AutoSize = True
        Caption = 'Salir'
        ImageIndex = 7
        OnClick = btnSalirClick
      end
    end
  end
  object GroupBox1: TGroupBox
    Left = 0
    Top = 26
    Width = 671
    Height = 263
    ParentShowHint = False
    ShowHint = True
    TabOrder = 2
    object GroupBox2: TGroupBox
      Left = 8
      Top = 8
      Width = 209
      Height = 241
      Caption = 'Usuarios'
      TabOrder = 0
      object AUsuarios: TTreeView
        Left = 8
        Top = 16
        Width = 193
        Height = 217
        HideSelection = False
        HotTrack = True
        Images = ImgSeg
        Indent = 19
        ReadOnly = True
        ShowButtons = False
        ShowRoot = False
        TabOrder = 0
        OnChange = AUsuariosChange
        Items.Data = {
          01000000210000000000000000000000FFFFFFFFFFFFFFFF0000000000000000
          085573756172696F73}
      end
    end
    object PanelFunciones: TGroupBox
      Left = 232
      Top = 8
      Width = 433
      Height = 249
      Caption = 'Funciones'
      TabOrder = 1
      object Funciones: TTreeView
        Left = 8
        Top = 16
        Width = 137
        Height = 161
        HideSelection = False
        HotTrack = True
        Images = ImgSeg
        Indent = 19
        ReadOnly = True
        ShowRoot = False
        TabOrder = 0
        OnChange = FuncionesChange
        Items.Data = {
          070000002B0000000200000002000000FFFFFFFFFFFFFFFF0000000000000000
          1241424D207920417369676E6163696F6E6573260000000200000002000000FF
          FFFFFFFFFFFFFF00000000000000000D436F6E6669677572616369F36E210000
          000200000002000000FFFFFFFFFFFFFFFF0000000000000000085265706F7274
          6573220000000200000002000000FFFFFFFFFFFFFFFF00000000000000000953
          6567757269646164240000000200000002000000FFFFFFFFFFFFFFFF00000000
          000000000B4C6F63616C697A61646F72260000000200000002000000FFFFFFFF
          FFFFFFFF00000000000000000D4D616E74656E696D69656E746F290000000200
          000002000000FFFFFFFFFFFFFFFF000000000000000010436F6D616E646F7320
          6465204E6F646F}
      end
      object f: TPageControl
        Left = 144
        Top = 16
        Width = 281
        Height = 225
        ActivePage = TabSheet7
        Font.Charset = ANSI_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'MS Sans Serif'
        Font.Style = []
        HotTrack = True
        MultiLine = True
        ParentFont = False
        Style = tsButtons
        TabHeight = 14
        TabOrder = 1
        TabWidth = 37
        object TabSheet1: TTabSheet
          Caption = 'abm'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'MS Sans Serif'
          Font.Style = []
          ParentFont = False
          object BoxABM: TGroupBox
            Left = 0
            Top = 0
            Width = 273
            Height = 201
            Caption = 'ABM y Asignaciones'
            TabOrder = 0
            object CheckBox101: TCheckBox
              Left = 8
              Top = 16
              Width = 153
              Height = 17
              Caption = 'Entrar al módulo'
              TabOrder = 0
              OnClick = CheckBoxClick
            end
            object PageControl2: TPageControl
              Left = 8
              Top = 40
              Width = 257
              Height = 153
              ActivePage = TabSheet8
              HotTrack = True
              Style = tsButtons
              TabOrder = 1
              object TabSheet8: TTabSheet
                Caption = 'Personas'
                object GroupBox4: TGroupBox
                  Left = 0
                  Top = 0
                  Width = 105
                  Height = 89
                  Caption = 'Grupos'
                  TabOrder = 0
                  object CheckBox102: TCheckBox
                    Left = 8
                    Top = 16
                    Width = 81
                    Height = 17
                    Caption = 'Alta'
                    TabOrder = 0
                    OnClick = CheckBoxClick
                  end
                  object CheckBox103: TCheckBox
                    Left = 8
                    Top = 32
                    Width = 81
                    Height = 17
                    Caption = 'Baja'
                    TabOrder = 1
                    OnClick = CheckBoxClick
                  end
                  object CheckBox104: TCheckBox
                    Left = 8
                    Top = 48
                    Width = 89
                    Height = 17
                    Caption = 'Modificación'
                    TabOrder = 2
                    OnClick = CheckBoxClick
                  end
                end
                object GroupBox5: TGroupBox
                  Left = 112
                  Top = 0
                  Width = 113
                  Height = 89
                  Caption = 'Personas'
                  TabOrder = 1
                  object CheckBox105: TCheckBox
                    Left = 8
                    Top = 16
                    Width = 57
                    Height = 17
                    Caption = 'Alta'
                    TabOrder = 0
                    OnClick = CheckBoxClick
                  end
                  object CheckBox106: TCheckBox
                    Left = 8
                    Top = 32
                    Width = 81
                    Height = 17
                    Caption = 'Baja'
                    TabOrder = 1
                    OnClick = CheckBoxClick
                  end
                  object CheckBox107: TCheckBox
                    Left = 8
                    Top = 48
                    Width = 89
                    Height = 17
                    Caption = 'Modificación'
                    TabOrder = 2
                    OnClick = CheckBoxClick
                  end
                  object CheckBox108: TCheckBox
                    Left = 8
                    Top = 64
                    Width = 81
                    Height = 17
                    Caption = 'Búsqueda'
                    TabOrder = 3
                    OnClick = CheckBoxClick
                  end
                end
              end
              object TabSheet9: TTabSheet
                Caption = 'Nodos'
                ImageIndex = 1
                object GroupBox6: TGroupBox
                  Left = 0
                  Top = 0
                  Width = 105
                  Height = 89
                  Caption = 'Grupos'
                  TabOrder = 0
                  object CheckBox109: TCheckBox
                    Left = 8
                    Top = 16
                    Width = 65
                    Height = 17
                    Caption = 'Alta'
                    TabOrder = 0
                    OnClick = CheckBoxClick
                  end
                  object CheckBox110: TCheckBox
                    Left = 8
                    Top = 32
                    Width = 57
                    Height = 17
                    Caption = 'Baja'
                    TabOrder = 1
                    OnClick = CheckBoxClick
                  end
                  object CheckBox111: TCheckBox
                    Left = 8
                    Top = 48
                    Width = 89
                    Height = 17
                    Caption = 'Modificación'
                    TabOrder = 2
                    OnClick = CheckBoxClick
                  end
                end
                object GroupBox7: TGroupBox
                  Left = 112
                  Top = 0
                  Width = 113
                  Height = 89
                  Caption = 'Nodos'
                  TabOrder = 1
                  object CheckBox112: TCheckBox
                    Left = 8
                    Top = 16
                    Width = 65
                    Height = 17
                    Caption = 'Alta'
                    TabOrder = 0
                    OnClick = CheckBoxClick
                  end
                  object CheckBox113: TCheckBox
                    Left = 8
                    Top = 32
                    Width = 65
                    Height = 17
                    Caption = 'Baja'
                    TabOrder = 1
                    OnClick = CheckBoxClick
                  end
                  object CheckBox114: TCheckBox
                    Left = 8
                    Top = 48
                    Width = 81
                    Height = 17
                    Caption = 'Modificación'
                    TabOrder = 2
                    OnClick = CheckBoxClick
                  end
                  object CheckBox115: TCheckBox
                    Left = 8
                    Top = 64
                    Width = 97
                    Height = 17
                    Caption = 'Cambio número'
                    TabOrder = 3
                    OnClick = CheckBoxClick
                  end
                end
              end
              object TabSheet10: TTabSheet
                Caption = 'Asignaciones'
                ImageIndex = 2
                object GroupBox8: TGroupBox
                  Left = 0
                  Top = 0
                  Width = 225
                  Height = 89
                  Caption = 'Asignaciones'
                  TabOrder = 0
                  object CheckBox116: TCheckBox
                    Left = 8
                    Top = 16
                    Width = 97
                    Height = 17
                    Caption = 'Asignar'
                    TabOrder = 0
                    OnClick = CheckBoxClick
                  end
                  object CheckBox117: TCheckBox
                    Left = 8
                    Top = 32
                    Width = 97
                    Height = 17
                    Caption = 'Borrar'
                    TabOrder = 1
                    OnClick = CheckBoxClick
                  end
                end
              end
            end
          end
        end
        object TabSheet2: TTabSheet
          Caption = 'conf'
          ImageIndex = 1
          object GConfig: TGroupBox
            Left = 0
            Top = 0
            Width = 273
            Height = 201
            Caption = 'Configuración'
            TabOrder = 0
            object CheckBox201: TCheckBox
              Left = 8
              Top = 16
              Width = 153
              Height = 17
              Caption = 'Entrar al módulo'
              TabOrder = 0
              OnClick = CheckBoxClick
            end
            object GroupBox9: TGroupBox
              Left = 8
              Top = 40
              Width = 257
              Height = 137
              Caption = 'Funciones habilitadas'
              TabOrder = 1
              object CheckBox202: TCheckBox
                Left = 8
                Top = 24
                Width = 121
                Height = 17
                Caption = 'Comunicaciones'
                TabOrder = 0
                OnClick = CheckBoxClick
              end
              object CheckBox203: TCheckBox
                Left = 8
                Top = 40
                Width = 121
                Height = 17
                Caption = 'Descarga'
                TabOrder = 1
                OnClick = CheckBoxClick
              end
              object CheckBox204: TCheckBox
                Left = 8
                Top = 56
                Width = 121
                Height = 17
                Caption = 'Ubicación de Datos'
                TabOrder = 2
                OnClick = CheckBoxClick
              end
              object CheckBox205: TCheckBox
                Left = 8
                Top = 72
                Width = 121
                Height = 17
                Caption = 'Opciones de Modem'
                TabOrder = 3
                OnClick = CheckBoxClick
              end
              object CheckBox206: TCheckBox
                Left = 8
                Top = 88
                Width = 121
                Height = 17
                Caption = 'Entorno'
                TabOrder = 4
                OnClick = CheckBoxClick
              end
              object CheckBox207: TCheckBox
                Left = 8
                Top = 104
                Width = 121
                Height = 17
                Caption = 'Sonidos'
                TabOrder = 5
                OnClick = CheckBoxClick
              end
            end
          end
        end
        object TabSheet3: TTabSheet
          Caption = 'rep'
          ImageIndex = 2
          object GroupBox10: TGroupBox
            Left = 0
            Top = 0
            Width = 273
            Height = 201
            Caption = 'Reportes'
            TabOrder = 0
            object CheckBox301: TCheckBox
              Left = 8
              Top = 16
              Width = 153
              Height = 17
              Caption = 'Entrar al módulo'
              TabOrder = 0
              OnClick = CheckBoxClick
            end
            object GroupBox11: TGroupBox
              Left = 8
              Top = 40
              Width = 257
              Height = 89
              Caption = 'Reportes habilitados'
              TabOrder = 1
              object CheckBox302: TCheckBox
                Left = 8
                Top = 16
                Width = 97
                Height = 17
                Caption = 'Personas'
                TabOrder = 0
                OnClick = CheckBoxClick
              end
              object CheckBox303: TCheckBox
                Left = 8
                Top = 32
                Width = 97
                Height = 17
                Caption = 'Nodos'
                TabOrder = 1
                OnClick = CheckBoxClick
              end
              object CheckBox304: TCheckBox
                Left = 8
                Top = 48
                Width = 97
                Height = 17
                Caption = 'Asignaciones'
                TabOrder = 2
                OnClick = CheckBoxClick
              end
              object CheckBox305: TCheckBox
                Left = 8
                Top = 64
                Width = 97
                Height = 17
                Caption = 'Eventos'
                TabOrder = 3
                OnClick = CheckBoxClick
              end
            end
          end
        end
        object TabSheet4: TTabSheet
          Caption = 'seg'
          ImageIndex = 3
          object GroupBox12: TGroupBox
            Left = 0
            Top = 0
            Width = 273
            Height = 201
            Caption = 'Seguridad'
            TabOrder = 0
            object CheckBox401: TCheckBox
              Left = 8
              Top = 16
              Width = 153
              Height = 17
              Caption = 'Entrar al módulo'
              TabOrder = 0
              OnClick = CheckBoxClick
            end
            object GroupBox13: TGroupBox
              Left = 8
              Top = 40
              Width = 257
              Height = 137
              Caption = 'Usuarios'
              TabOrder = 1
              object CheckBox402: TCheckBox
                Left = 8
                Top = 16
                Width = 97
                Height = 17
                Caption = 'Alta'
                TabOrder = 0
                OnClick = CheckBoxClick
              end
              object CheckBox403: TCheckBox
                Left = 8
                Top = 32
                Width = 97
                Height = 17
                Caption = 'Baja'
                TabOrder = 1
                OnClick = CheckBoxClick
              end
              object CheckBox404: TCheckBox
                Left = 8
                Top = 48
                Width = 97
                Height = 17
                Caption = 'Modificación'
                TabOrder = 2
                OnClick = CheckBoxClick
              end
              object CheckBox405: TCheckBox
                Left = 8
                Top = 64
                Width = 113
                Height = 17
                Caption = 'Cambio de clave'
                TabOrder = 3
                OnClick = CheckBoxClick
              end
              object CheckBox406: TCheckBox
                Left = 8
                Top = 80
                Width = 185
                Height = 17
                Caption = 'Copiado de flags'
                TabOrder = 4
                OnClick = CheckBoxClick
              end
              object CheckBox407: TCheckBox
                Left = 8
                Top = 96
                Width = 185
                Height = 17
                Caption = 'Ver funciones habilitadas'
                TabOrder = 5
                OnClick = CheckBoxClick
              end
              object CheckBox408: TCheckBox
                Left = 8
                Top = 112
                Width = 185
                Height = 17
                Caption = 'Cambiar las funciones habilitadas'
                TabOrder = 6
                OnClick = CheckBoxClick
              end
            end
          end
        end
        object TabSheet5: TTabSheet
          Caption = 'loc'
          ImageIndex = 4
          object GroupBox14: TGroupBox
            Left = 0
            Top = 0
            Width = 273
            Height = 201
            Caption = 'Localizador'
            TabOrder = 0
            object CheckBox501: TCheckBox
              Left = 8
              Top = 16
              Width = 153
              Height = 17
              Caption = 'Entrar al módulo'
              TabOrder = 0
              OnClick = CheckBoxClick
            end
          end
        end
        object TabSheet6: TTabSheet
          Caption = 'mant'
          ImageIndex = 5
          object GroupBox15: TGroupBox
            Left = 0
            Top = 0
            Width = 273
            Height = 201
            Caption = 'Mantenimiento'
            TabOrder = 0
            object CheckBox601: TCheckBox
              Left = 8
              Top = 16
              Width = 153
              Height = 17
              Caption = 'Entrar al módulo'
              TabOrder = 0
              OnClick = CheckBoxClick
            end
          end
        end
        object TabSheet7: TTabSheet
          Caption = 'cmd'
          ImageIndex = 6
          object GroupBox16: TGroupBox
            Left = 0
            Top = 0
            Width = 273
            Height = 201
            Caption = 'Comandos de Nodo'
            TabOrder = 0
            object GroupBox17: TGroupBox
              Left = 8
              Top = 24
              Width = 153
              Height = 169
              Caption = 'Funciones'
              TabOrder = 0
              object CheckBox701: TCheckBox
                Left = 8
                Top = 16
                Width = 121
                Height = 17
                Caption = 'Apertura Remota'
                TabOrder = 0
                OnClick = CheckBoxClick
              end
              object CheckBox702: TCheckBox
                Left = 8
                Top = 32
                Width = 121
                Height = 17
                Caption = 'Subir Habilitados'
                TabOrder = 1
                OnClick = CheckBoxClick
              end
              object CheckBox703: TCheckBox
                Left = 8
                Top = 48
                Width = 121
                Height = 17
                Caption = 'Bajar Eventos'
                TabOrder = 2
                OnClick = CheckBoxClick
              end
              object CheckBox704: TCheckBox
                Left = 8
                Top = 64
                Width = 121
                Height = 17
                Caption = 'Propiedades'
                TabOrder = 3
                OnClick = CheckBoxClick
              end
              object CheckBox705: TCheckBox
                Left = 8
                Top = 80
                Width = 121
                Height = 17
                Caption = 'Chequeo'
                TabOrder = 4
                OnClick = CheckBoxClick
              end
              object CheckBox706: TCheckBox
                Left = 8
                Top = 96
                Width = 121
                Height = 17
                Caption = 'Reinicializar'
                TabOrder = 5
                OnClick = CheckBoxClick
              end
              object CheckBox707: TCheckBox
                Left = 8
                Top = 112
                Width = 121
                Height = 17
                Caption = 'Bloquear nodo'
                TabOrder = 6
                OnClick = CheckBoxClick
              end
              object CheckBox708: TCheckBox
                Left = 8
                Top = 128
                Width = 121
                Height = 17
                Caption = 'Atender alarma'
                TabOrder = 7
                OnClick = CheckBoxClick
              end
              object CheckBox709: TCheckBox
                Left = 8
                Top = 144
                Width = 137
                Height = 17
                Caption = 'Administración TCP/IP'
                TabOrder = 8
                OnClick = CheckBoxClick
              end
            end
          end
        end
      end
      object btnA: TBitBtn
        Left = 8
        Top = 184
        Width = 137
        Height = 25
        Caption = '&Aceptar'
        Default = True
        Enabled = False
        TabOrder = 2
        OnClick = btnAClick
        Glyph.Data = {
          DE010000424DDE01000000000000760000002800000024000000120000000100
          0400000000006801000000000000000000001000000000000000000000000000
          80000080000000808000800000008000800080800000C0C0C000808080000000
          FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFFFF00333333333333
          3333333333333333333333330000333333333333333333333333F33333333333
          00003333344333333333333333388F3333333333000033334224333333333333
          338338F3333333330000333422224333333333333833338F3333333300003342
          222224333333333383333338F3333333000034222A22224333333338F338F333
          8F33333300003222A3A2224333333338F3838F338F33333300003A2A333A2224
          33333338F83338F338F33333000033A33333A222433333338333338F338F3333
          0000333333333A222433333333333338F338F33300003333333333A222433333
          333333338F338F33000033333333333A222433333333333338F338F300003333
          33333333A222433333333333338F338F00003333333333333A22433333333333
          3338F38F000033333333333333A223333333333333338F830000333333333333
          333A333333333333333338330000333333333333333333333333333333333333
          0000}
        NumGlyphs = 2
      end
      object btnC: TBitBtn
        Left = 8
        Top = 216
        Width = 137
        Height = 25
        Cancel = True
        Caption = '&Cancelar'
        Enabled = False
        TabOrder = 3
        OnClick = btnCClick
        Glyph.Data = {
          DE010000424DDE01000000000000760000002800000024000000120000000100
          0400000000006801000000000000000000001000000000000000000000000000
          80000080000000808000800000008000800080800000C0C0C000808080000000
          FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFFFF00333333333333
          3333333333333FFFFF333333000033333388888833333333333F888888FFF333
          000033338811111188333333338833FFF388FF33000033381119999111833333
          38F338888F338FF30000339119933331111833338F388333383338F300003391
          13333381111833338F8F3333833F38F3000039118333381119118338F38F3338
          33F8F38F000039183333811193918338F8F333833F838F8F0000391833381119
          33918338F8F33833F8338F8F000039183381119333918338F8F3833F83338F8F
          000039183811193333918338F8F833F83333838F000039118111933339118338
          F3833F83333833830000339111193333391833338F33F8333FF838F300003391
          11833338111833338F338FFFF883F83300003339111888811183333338FF3888
          83FF83330000333399111111993333333388FFFFFF8833330000333333999999
          3333333333338888883333330000333333333333333333333333333333333333
          0000}
        NumGlyphs = 2
      end
    end
  end
  object ImgSeg: TImageList
    Left = 80
    Top = 165
    Bitmap = {
      494C010108000900040010001000FFFFFFFFFF10FFFFFFFFFFFFFFFF424D3600
      0000000000003600000028000000400000003000000001002000000000000030
      000000000000000000000000000000000000BFBFBF00BFBFBF00BFBFBF00BFBF
      BF00BFBFBF00BFBFBF00BFBFBF00BFBFBF00BFBFBF00BFBFBF00BFBFBF00BFBF
      BF00BFBFBF00BFBFBF00BFBFBF007F7F7F00FFFFFF00BFBFBF00BFBFBF00FFFF
      FF00BFBFBF007F7F7F00FFFFFF00BFBFBF007F7F7F00BFBFBF00BFBFBF00BFBF
      BF00BFBFBF00BFBFBF00BFBFBF00BFBFBF00BFBFBF00BFBFBF00BFBFBF00BFBF
      BF00BFBFBF00BFBFBF00BFBFBF00BFBFBF00BFBFBF00BFBFBF00BFBFBF00BFBF
      BF00BFBFBF00BFBFBF00BFBFBF00BFBFBF00BFBFBF00BFBFBF00BFBFBF00BFBF
      BF00BFBFBF00BFBFBF00BFBFBF00BFBFBF00BFBFBF00BFBFBF00BFBFBF00BFBF
      BF00BFBFBF00BFBFBF00BFBFBF00BFBFBF00BFBFBF00BFBFBF00BFBFBF00BFBF
      BF00BFBFBF00BFBFBF00BFBFBF00BFBFBF00BFBFBF00BFBFBF00BFBFBF00BFBF
      BF00BFBFBF00BFBFBF00BFBFBF007F7F7F00FFFFFF00BFBFBF00BFBFBF00FFFF
      FF00BFBFBF007F7F7F00FFFFFF00BFBFBF007F7F7F00BFBFBF00BFBFBF00BFBF
      BF00BFBFBF00BFBFBF00BFBFBF00BFBFBF00BFBFBF00BFBFBF00BFBFBF00BFBF
      BF00BFBFBF00BFBFBF00BFBFBF00BFBFBF00BFBFBF00BFBFBF00BFBFBF00BFBF
      BF00BFBFBF00BFBFBF00BFBFBF00BFBFBF00BFBFBF00BFBFBF00BFBFBF00BFBF
      BF00BFBFBF00BFBFBF00BFBFBF00BFBFBF00BFBFBF00BFBFBF00BFBFBF00BFBF
      BF00BFBFBF00BFBFBF00BFBFBF00BFBFBF00BFBFBF00BFBFBF00BFBFBF00BFBF
      BF00BFBFBF00BFBFBF00BFBFBF00BFBFBF00BFBFBF00BFBFBF00BFBFBF00BFBF
      BF00BFBFBF00BFBFBF00BFBFBF007F7F7F00FFFFFF00BFBFBF00BFBFBF00FFFF
      FF00BFBFBF007F7F7F00FFFFFF00BFBFBF007F7F7F00BFBFBF00BFBFBF00BFBF
      BF00BFBFBF00BFBFBF00BFBFBF00BFBFBF00BFBFBF00BFBFBF00BFBFBF00BFBF
      BF00BFBFBF00BFBFBF00BFBFBF00BFBFBF00BFBFBF00BFBFBF00BFBFBF00BFBF
      BF00BFBFBF00BFBFBF00BFBFBF00BFBFBF00BFBFBF00BFBFBF00BFBFBF00BFBF
      BF00BFBFBF00BFBFBF00BFBFBF00BFBFBF00BFBFBF00BFBFBF00BFBFBF00BFBF
      BF00BFBFBF00BFBFBF00BFBFBF00BFBFBF00BFBFBF00BFBFBF00BFBFBF00BFBF
      BF00BFBFBF00BFBFBF00BFBFBF00BFBFBF00BFBFBF00BFBFBF00BFBFBF00BFBF
      BF00BFBFBF00BFBFBF00BFBFBF007F7F7F00FFFFFF00BFBFBF00BFBFBF00FFFF
      FF00BFBFBF007F7F7F00FFFFFF00BFBFBF007F7F7F00BFBFBF00BFBFBF00BFBF
      BF00BFBFBF00BFBFBF00BFBFBF00BFBFBF00BFBFBF00BFBFBF00BFBFBF00BFBF
      BF00BFBFBF00BFBFBF00BFBFBF00BFBFBF00BFBFBF00BFBFBF00BFBFBF00BFBF
      BF00BFBFBF00BFBFBF00BFBFBF00BFBFBF00BFBFBF00BFBFBF00BFBFBF00BFBF
      BF00BFBFBF00BFBFBF00BFBFBF00BFBFBF00BFBFBF00BFBFBF00BFBFBF00BFBF
      BF00BFBFBF00BFBFBF00BFBFBF00BFBFBF00BFBFBF00BFBFBF00BFBFBF00BFBF
      BF00BFBFBF00BFBFBF00BFBFBF00BFBFBF00BFBFBF00BFBFBF00BFBFBF00BFBF
      BF00BFBFBF00BFBFBF00BFBFBF007F7F7F00FFFFFF00BFBFBF00BFBFBF00FFFF
      FF00BFBFBF007F7F7F00FFFFFF00BFBFBF007F7F7F00BFBFBF00BFBFBF00BFBF
      BF00BFBFBF00BFBFBF00BFBFBF00BFBFBF00BFBFBF00BFBFBF00BFBFBF00BFBF
      BF00BFBFBF00BFBFBF00BFBFBF00BFBFBF00BFBFBF00BFBFBF00BFBFBF00BFBF
      BF00BFBFBF00BFBFBF00BFBFBF00BFBFBF00BFBFBF00BFBFBF00BFBFBF00BFBF
      BF00BFBFBF00BFBFBF00BFBFBF00BFBFBF00BFBFBF00BFBFBF00BFBFBF00BFBF
      BF00BFBFBF00BFBFBF00BFBFBF00BFBFBF00BFBFBF00BFBFBF00BFBFBF00BFBF
      BF00BFBFBF00BFBFBF00BFBFBF00BFBFBF00BFBFBF00BFBFBF00BFBFBF00BFBF
      BF00BFBFBF00BFBFBF00BFBFBF007F7F7F00FFFFFF00BFBFBF00BFBFBF00FFFF
      FF00BFBFBF007F7F7F00FFFFFF00BFBFBF007F7F7F00BFBFBF00BFBFBF00BFBF
      BF00BFBFBF00BFBFBF00BFBFBF00BFBFBF00BFBFBF00BFBFBF00BFBFBF00BFBF
      BF00BFBFBF00BFBFBF00BFBFBF00BFBFBF00BFBFBF00BFBFBF00BFBFBF00BFBF
      BF00BFBFBF00BFBFBF00BFBFBF00BFBFBF00BFBFBF00BFBFBF00BFBFBF00BFBF
      BF00BFBFBF00BFBFBF00BFBFBF00BFBFBF00BFBFBF00BFBFBF00BFBFBF00BFBF
      BF00BFBFBF00BFBFBF00BFBFBF00BFBFBF00BFBFBF00BFBFBF00BFBFBF00BFBF
      BF00BFBFBF00BFBFBF00BFBFBF00BFBFBF00BFBFBF00BFBFBF00BFBFBF00BFBF
      BF00BFBFBF00BFBFBF00BFBFBF007F7F7F00FFFFFF00BFBFBF00BFBFBF00FFFF
      FF00BFBFBF007F7F7F00FFFFFF00BFBFBF007F7F7F00BFBFBF00BFBFBF00BFBF
      BF00BFBFBF00BFBFBF00BFBFBF00BFBFBF00BFBFBF00BFBFBF00BFBFBF00BFBF
      BF00BFBFBF00BFBFBF00BFBFBF00BFBFBF00BFBFBF00BFBFBF00BFBFBF00BFBF
      BF00BFBFBF00BFBFBF00BFBFBF00BFBFBF00BFBFBF00BFBFBF00BFBFBF00BFBF
      BF00BFBFBF00BFBFBF00BFBFBF00BFBFBF00BFBFBF00BFBFBF00BFBFBF00BFBF
      BF00BFBFBF00BFBFBF00BFBFBF00BFBFBF00BFBFBF00BFBFBF00BFBFBF00BFBF
      BF00BFBFBF00BFBFBF00BFBFBF00BFBFBF00BFBFBF00BFBFBF00BFBFBF00BFBF
      BF00BFBFBF00BFBFBF00BFBFBF007F7F7F00FFFFFF00BFBFBF00BFBFBF00FFFF
      FF00BFBFBF007F7F7F00FFFFFF00BFBFBF007F7F7F00BFBFBF00BFBFBF00BFBF
      BF00BFBFBF00BFBFBF00BFBFBF00BFBFBF00BFBFBF00BFBFBF00BFBFBF00BFBF
      BF00BFBFBF00BFBFBF00BFBFBF00BFBFBF00BFBFBF00BFBFBF00BFBFBF00BFBF
      BF00BFBFBF00BFBFBF00BFBFBF00BFBFBF00BFBFBF00BFBFBF00BFBFBF00BFBF
      BF00BFBFBF00BFBFBF00BFBFBF00BFBFBF00BFBFBF00BFBFBF00BFBFBF00BFBF
      BF00BFBFBF00BFBFBF00BFBFBF00BFBFBF00BFBFBF00BFBFBF00BFBFBF00BFBF
      BF00BFBFBF00BFBFBF00BFBFBF00BFBFBF00BFBFBF00BFBFBF00BFBFBF00BFBF
      BF00BFBFBF00BFBFBF00BFBFBF007F7F7F00FFFFFF00BFBFBF00BFBFBF00FFFF
      FF00BFBFBF007F7F7F00FFFFFF00BFBFBF007F7F7F00BFBFBF00BFBFBF00BFBF
      BF00BFBFBF00BFBFBF00BFBFBF00BFBFBF00BFBFBF00BFBFBF00BFBFBF00BFBF
      BF00BFBFBF00BFBFBF00BFBFBF00BFBFBF00BFBFBF00BFBFBF00BFBFBF00BFBF
      BF00BFBFBF00BFBFBF00BFBFBF00BFBFBF00BFBFBF00BFBFBF00BFBFBF00BFBF
      BF00BFBFBF00BFBFBF00BFBFBF00BFBFBF00BFBFBF00BFBFBF00BFBFBF00BFBF
      BF00BFBFBF00BFBFBF00BFBFBF00BFBFBF00BFBFBF00BFBFBF00BFBFBF00BFBF
      BF00BFBFBF00BFBFBF00BFBFBF00BFBFBF00BFBFBF00BFBFBF00BFBFBF00BFBF
      BF00BFBFBF00BFBFBF00BFBFBF007F7F7F00FFFFFF00BFBFBF00BFBFBF00FFFF
      FF00BFBFBF007F7F7F00FFFFFF00BFBFBF007F7F7F00BFBFBF00BFBFBF00BFBF
      BF00BFBFBF00BFBFBF00BFBFBF00BFBFBF00BFBFBF00BFBFBF00BFBFBF00BFBF
      BF00BFBFBF00BFBFBF00BFBFBF00BFBFBF00BFBFBF00BFBFBF00BFBFBF00BFBF
      BF00BFBFBF00BFBFBF00BFBFBF00BFBFBF00BFBFBF00BFBFBF00BFBFBF00BFBF
      BF00BFBFBF00BFBFBF00BFBFBF00BFBFBF00BFBFBF00BFBFBF00BFBFBF00BFBF
      BF00BFBFBF00BFBFBF00BFBFBF00BFBFBF00BFBFBF00BFBFBF00BFBFBF00BFBF
      BF00BFBFBF00BFBFBF00BFBFBF00BFBFBF00BFBFBF00BFBFBF00BFBFBF00BFBF
      BF00BFBFBF00BFBFBF00BFBFBF007F7F7F00FFFFFF00BFBFBF00BFBFBF00FFFF
      FF00BFBFBF007F7F7F00FFFFFF00BFBFBF007F7F7F00BFBFBF00BFBFBF00BFBF
      BF00BFBFBF00BFBFBF00BFBFBF00BFBFBF00BFBFBF00BFBFBF00BFBFBF00BFBF
      BF00BFBFBF00BFBFBF00BFBFBF00BFBFBF00BFBFBF00BFBFBF00BFBFBF00BFBF
      BF00BFBFBF00BFBFBF00BFBFBF00BFBFBF00BFBFBF00BFBFBF00BFBFBF00BFBF
      BF00BFBFBF00BFBFBF00BFBFBF00BFBFBF00BFBFBF00BFBFBF00BFBFBF00BFBF
      BF00BFBFBF00BFBFBF00BFBFBF00BFBFBF00BFBFBF00BFBFBF00BFBFBF00BFBF
      BF00BFBFBF00BFBFBF00BFBFBF00BFBFBF00BFBFBF00BFBFBF00BFBFBF00BFBF
      BF00BFBFBF00BFBFBF00BFBFBF007F7F7F00FFFFFF00BFBFBF00BFBFBF00FFFF
      FF00BFBFBF007F7F7F00FFFFFF00BFBFBF007F7F7F00BFBFBF00BFBFBF00BFBF
      BF00BFBFBF00BFBFBF00BFBFBF00BFBFBF00BFBFBF00BFBFBF00BFBFBF00BFBF
      BF00BFBFBF00BFBFBF00BFBFBF00BFBFBF00BFBFBF00BFBFBF00BFBFBF00BFBF
      BF00BFBFBF00BFBFBF00BFBFBF00BFBFBF00BFBFBF00BFBFBF00BFBFBF00BFBF
      BF00BFBFBF00BFBFBF00BFBFBF00BFBFBF00BFBFBF00BFBFBF00BFBFBF00BFBF
      BF00BFBFBF00BFBFBF00BFBFBF00BFBFBF00BFBFBF00BFBFBF00BFBFBF00BFBF
      BF00BFBFBF00BFBFBF00BFBFBF00BFBFBF00BFBFBF00BFBFBF00BFBFBF00BFBF
      BF00BFBFBF00BFBFBF00BFBFBF007F7F7F00FFFFFF00BFBFBF00BFBFBF00FFFF
      FF00BFBFBF007F7F7F00FFFFFF00BFBFBF007F7F7F00BFBFBF00BFBFBF00BFBF
      BF00BFBFBF00BFBFBF00BFBFBF00BFBFBF00BFBFBF00BFBFBF00BFBFBF00BFBF
      BF00BFBFBF00BFBFBF00BFBFBF00BFBFBF00BFBFBF00BFBFBF00BFBFBF00BFBF
      BF00BFBFBF00BFBFBF00BFBFBF00BFBFBF00BFBFBF00BFBFBF00BFBFBF00BFBF
      BF00BFBFBF00BFBFBF00BFBFBF00BFBFBF00BFBFBF00BFBFBF00BFBFBF00BFBF
      BF00BFBFBF00BFBFBF00BFBFBF00BFBFBF00BFBFBF00BFBFBF00BFBFBF00BFBF
      BF00BFBFBF00BFBFBF00BFBFBF00BFBFBF00BFBFBF00BFBFBF00BFBFBF00BFBF
      BF00BFBFBF00BFBFBF00BFBFBF007F7F7F00FFFFFF00BFBFBF00BFBFBF00FFFF
      FF00BFBFBF007F7F7F00FFFFFF00BFBFBF007F7F7F00BFBFBF00BFBFBF00BFBF
      BF00BFBFBF00BFBFBF00BFBFBF00BFBFBF00BFBFBF00BFBFBF00BFBFBF00BFBF
      BF00BFBFBF00BFBFBF00BFBFBF00BFBFBF00BFBFBF00BFBFBF00BFBFBF00BFBF
      BF00BFBFBF00BFBFBF00BFBFBF00BFBFBF00BFBFBF00BFBFBF00BFBFBF00BFBF
      BF00BFBFBF00BFBFBF00BFBFBF00BFBFBF00BFBFBF00BFBFBF00BFBFBF00BFBF
      BF00BFBFBF00BFBFBF00BFBFBF00BFBFBF00BFBFBF00BFBFBF00BFBFBF00BFBF
      BF00BFBFBF00BFBFBF00BFBFBF00BFBFBF00BFBFBF00BFBFBF00BFBFBF00BFBF
      BF00BFBFBF00BFBFBF00BFBFBF007F7F7F00FFFFFF00BFBFBF00BFBFBF00FFFF
      FF00BFBFBF007F7F7F00FFFFFF00BFBFBF007F7F7F00BFBFBF00BFBFBF00BFBF
      BF00BFBFBF00BFBFBF00BFBFBF00BFBFBF00BFBFBF00BFBFBF00BFBFBF00BFBF
      BF00BFBFBF00BFBFBF00BFBFBF00BFBFBF00BFBFBF00BFBFBF00BFBFBF00BFBF
      BF00BFBFBF00BFBFBF00BFBFBF00BFBFBF00BFBFBF00BFBFBF00BFBFBF00BFBF
      BF00BFBFBF00BFBFBF00BFBFBF00BFBFBF00BFBFBF00BFBFBF00BFBFBF00BFBF
      BF00BFBFBF00BFBFBF00BFBFBF00BFBFBF00BFBFBF00BFBFBF00BFBFBF00BFBF
      BF00BFBFBF00BFBFBF00BFBFBF00BFBFBF00BFBFBF00BFBFBF00BFBFBF00BFBF
      BF00BFBFBF00BFBFBF00BFBFBF007F7F7F00FFFFFF00BFBFBF00BFBFBF00FFFF
      FF00BFBFBF007F7F7F00FFFFFF00BFBFBF007F7F7F00BFBFBF00BFBFBF00BFBF
      BF00BFBFBF00BFBFBF00BFBFBF00BFBFBF00BFBFBF00BFBFBF00BFBFBF00BFBF
      BF00BFBFBF00BFBFBF00BFBFBF00BFBFBF00BFBFBF00BFBFBF00BFBFBF00BFBF
      BF00BFBFBF00BFBFBF00BFBFBF00BFBFBF00BFBFBF00BFBFBF00BFBFBF00BFBF
      BF00BFBFBF00BFBFBF00BFBFBF00BFBFBF00BFBFBF00BFBFBF00BFBFBF00BFBF
      BF00BFBFBF00BFBFBF00BFBFBF00BFBFBF000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000007F7F
      7F007F7F7F007F7F7F007F7F7F007F7F7F007F7F7F007F7F7F007F7F7F007F7F
      7F007F7F7F000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000000000000000000000000000FFFF
      FF00FFFFFF000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000FF000000FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF007F7F7F000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000FFFFFF00FFFF
      FF00FFFFFF00FFFFFF007F7F7F00000000000000000000000000000000000000
      000000000000000000000000000000000000000000007F7F7F00000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000707F7000707F7000000000000000000000000000707F7000000000000000
      00000000000000000000000000000000000000000000FF000000BFBFBF00BFBF
      BF00BFBFBF00BFBFBF00BFBFBF00BFBFBF00BFBFBF00BFBFBF00BFBFBF00FFFF
      FF007F7F7F000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000FFFFFF00FFFF
      FF00FFFFFF00FFFFFF000000000000000000000000000000000000FFFF00FFFF
      FF00FFFFFF0000FFFF00FFFFFF00FFFFFF00FFFFFF007F7F7F007F7F7F007F7F
      7F007F7F7F007F7F7F0000000000000000000000000000000000000000000000
      700000000000707F7000707F7000000000000000FF00707F7000707F70000000
      00000000000000000000000000000000000000000000FF000000BFBFBF00BFBF
      BF00BFBFBF00BFBFBF00BFBFBF00BFBFBF00BFBFBF00BFBFBF00BFBFBF00FFFF
      FF007F7F7F000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF0000000000000000000000000000000000FFFFFF007F00
      00007F0000007F0000007F0000007F000000FFFFFF0000000000000000000000
      000000000000000000007F7F7F00000000000000000000000000000000000000
      70000000700000000000707F7000000000000000700000000000707F7000707F
      70000000000000000000000000000000000000000000FF000000BFBFBF00BFBF
      BF00BFBFBF00BFBFBF00BFBFBF0000000000BFBFBF00BFBFBF00BFBFBF00FFFF
      FF007F7F7F00000000000000000000000000000000000000000000000000BFBF
      BF00000000007F7F7F007F7F7F007F7F7F0000000000FFFFFF00FFFFFF00FFFF
      FF0000000000FFFFFF0000000000000000000000000000000000FFFFFF00FFFF
      FF0000FFFF00FFFFFF00FFFFFF0000FFFF00FFFFFF00FFFFFF0000FFFF00FFFF
      FF00FFFFFF00000000007F7F7F00000000000000000000000000000000000000
      FF00000070000000700000000000000070000000700000007000000000000000
      00000000000000000000000000000000000000000000FF000000BFBFBF00BFBF
      BF00BFBFBF00BFBFBF00BFBFBF00BFBFBF0000FFFF00BFBFBF00BFBFBF00FFFF
      FF007F7F7F00000000000000000000000000000000000000000000000000BFBF
      BF007F7F7F007F7F7F0000000000FFFFFF00FFFFFF00FFFFFF00FFFFFF000000
      000000000000FFFFFF000000000000000000000000000000000000FFFF00FFFF
      FF00FFFFFF0000FFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF0000FFFF00000000007F7F7F00000000000000000000000000000000000000
      FF00000070000000700000007000000070000000700000007000000000000000
      00000000000000000000000000000000000000000000FF000000BFBFBF00BFBF
      BF00BFBFBF00BFBFBF00BFBFBF00BFBFBF00BFBFBF0000FFFF00BFBFBF00FFFF
      FF007F7F7F000000000000000000000000000000000000000000BFBFBF000000
      00007F7F7F007F7F7F00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF0000000000FFFFFF0000000000000000000000000000000000FFFFFF007F00
      00007F0000007F0000007F0000007F000000FFFFFF007F0000007F0000007F00
      00007F000000000000007F7F7F00000000000000000000000000000000000000
      00000000FF0000007000000070000000700000007000707F7000000000000000
      00000000000000000000000000000000000000000000FF000000BFBFBF00BFBF
      BF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00BFBFBF0000FFFF00FFFF
      FF007F7F7F000000000000000000000000000000000000000000BFBFBF000000
      00007F7F7F007F7F7F00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF0000000000000000000000000000000000FFFFFF00FFFF
      FF0000FFFF00FFFFFF00FFFFFF0000FFFF00FFFFFF00FFFFFF0000FFFF00FFFF
      FF00FFFFFF00000000007F7F7F00000000000000000000000000000000000000
      0000000000000000FF00000070000000700000000000707F7000707F70000000
      00000000000000000000000000000000000000000000FF000000BFBFBF00BFBF
      BF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00BFBFBF00BFBFBF0000FF
      FF007F7F7F007F7F7F0000000000000000000000000000000000BFBFBF000000
      00007F7F7F007F7F7F00FFFFFF00FFFFFF000000000000000000FFFFFF00FFFF
      FF00FFFFFF00FFFFFF007F7F7F00000000000000000000000000FFFFFF007F00
      00007F000000000000000000000000000000000000007F0000007F0000007F7F
      7F007F7F7F00000000007F7F7F00000000000000000000000000000000000000
      0000000000000000FF0000007000000070000000700000000000707F70000000
      00000000000000000000000000000000000000000000FF000000BFBFBF00BFBF
      BF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00BFBFBF00BFBFBF00FFFF
      FF0000FFFF007F7F7F007F7F7F00000000000000000000000000BFBFBF00BFBF
      BF007F7F7F007F7F7F0000000000BFBFBF000000000000000000FFFFFF00FFFF
      FF00FFFFFF000000000000000000000000000000000000000000FFFFFF007F00
      00007F00000000000000FFFFFF0000FFFF0000000000FFFFFF007F7F7F000000
      000000FF00007F7F7F007F7F7F00000000000000000000000000000000000000
      00000000000000007000000070000000FF000000700000000000707F7000707F
      70000000000000000000000000000000000000000000FF000000BFBFBF00BFBF
      BF00FF000000FF000000FF000000FF000000FF000000BFBFBF00BFBFBF00FFFF
      FF007F7F7F00FFFFFF007F7F7F0000000000000000000000000000000000BFBF
      BF007F7F7F007F7F7F007F7F7F007F7F7F007F7F7F0000000000000000000000
      0000000000000000000000000000000000000000000000000000FFFFFF00FFFF
      FF0000FFFF0000000000FFFFFF0000000000FFFFFF0000000000000000000000
      000000FF00000000000000000000000000000000000000000000000000000000
      00000000FF000000700000000000000000000000FF000000700000000000707F
      7000707F700000000000000000000000000000000000FF000000BFBFBF00BFBF
      BF00BFBFBF00BFBFBF00BFBFBF00BFBFBF00BFBFBF00BFBFBF00BFBFBF00FFFF
      FF0000000000000000000000FF0000000000007F0000007F000000000000BFBF
      BF00BFBFBF00000000007F7F7F00000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000FFFFFF007F0000000000000000FF000000FF
      000000FF000000FF000000000000000000000000000000000000000000000000
      00000000700000007000707F700000000000000000000000FF00000070000000
      0000707F700000000000000000000000000000000000FF000000BFBFBF00BFBF
      BF00BFBFBF00BFBFBF00BFBFBF00BFBFBF00BFBFBF00BFBFBF00BFBFBF00FF00
      000000000000000000000000000000000000007F0000007F0000000000000000
      000000000000BFBFBF00BFBFBF00000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000FFFFFF00FFFFFF0000000000000000000000
      000000FF00000000000000000000000000000000000000000000000000000000
      00000000FF000000FF00000000000000000000000000000000000000FF000000
      7000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000FF0000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000004F4F4F004F4F4F00000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000007F7F7F007F7F7F0000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000AFEF0000AFEF000060DF000060DF004F4F4F005F5F5F006060
      6000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00000000000000000000000000000000000000
      0000000000007F7F7F007F7F7F00BFBFBF007F7F7F007F7F7F00000000000000
      000000000000000000000000000000000000000000000000000000000000FFFF
      FF0000FFFF00FFFFFF0000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000F0F0F0000AFEF0000AFEF000060DF000060DF0050505000606060006F6F
      6F00707070000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00000000000000000000000000000000007F7F
      7F007F7F7F00BFBFBF00BFBFBF00BFBFBF007F7F7F007F7F7F007F7F7F000000
      000000000000000000000000000000000000000000000000000000000000FFFF
      FF0000FFFF00FFFFFF0000FFFF00FFFFFF000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00001F1F1F0000AFEF0000AFEF000F60DF000060DF005F5F5F006F6F6F007F7F
      7F00808080000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF000000000000000000000000007F7F7F00BFBF
      BF00BFBFBF00FFFFFF00007F0000BFBFBF00BFBFBF007F7F7F007F7F7F000000
      000000000000000000000000000000000000000000000000000000000000FFFF
      FF0000FFFF00FFFFFF0000FFFF00FFFFFF0000FFFF00FFFFFF00000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00002020200010B0EF000FAFEF001F70E000106FE00060606000707070007F7F
      7F007F7F7F000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000000000007F7F7F00BFBFBF00BFBF
      BF00BFBFBF00007F0000007F0000FFFFFF00BFBFBF007F7F7F007F7F7F007F7F
      7F0000000000000000000000000000000000000000000000000000000000FFFF
      FF0000FFFF00FFFFFF0000FFFF00FFFFFF0000FFFF00FFFFFF0000FFFF00FFFF
      FF00000000000000000000000000000000000000000000000000000000000000
      0000303030002FBFF00020B0F0001FB0EF002F7FE00000000000000000007F7F
      7F007F7F7F000000000000000000000000000000000000000000000000000000
      0000FFFFFF00FFFFFF000000000000000000FF000000FF000000FF000000FF00
      0000FF000000FF000000FF00000000000000000000007F7F7F00BFBFBF00BFBF
      BF00FFFFFF00007F0000BFBFBF00007F0000BFBFBF007F7F7F007F7F7F007F7F
      7F0000000000000000000000000000000000000000000000000000000000FFFF
      FF0000FFFF00FFFFFF0000FFFF00FFFFFF0000FFFF00FFFFFF0000FFFF00FFFF
      FF00000000000000000000000000000000000000000000000000000000000000
      00004040400040C0F0003FC0F00030BFF000408FEF001F1F1F00000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000FFFFFF00FFFFFF0000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000BFBFBF00BFBFBF00BFBF
      BF00BFBFBF007F7F7F00BFBFBF00007F0000BFBFBF007F7F7F007F7F7F007F7F
      7F007F7F7F00000000000000000000000000000000000000000000000000FFFF
      FF0000FFFF00FFFFFF0000FFFF00FFFFFF0000FFFF00FFFFFF0000FFFF00FFFF
      FF00000000000000000000000000000000000000000000000000000000000000
      000060D0FF005FCFF00050CFF0004FCFF0005F9FEF0020202000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF000000000000000000000000000000000000000000BFBFBF007F7F7F00FFFF
      FF00BFBFBF00BFBFBF00BFBFBF00BFBFBF00BFBFBF00BFBFBF007F7F7F007F7F
      7F007F7F7F00000000000000000000000000000000000000000000000000FFFF
      FF0000FFFF00FFFFFF0000FFFF00FFFFFF0000FFFF00FFFFFF0000FFFF00FFFF
      FF00000000000000000000000000000000000000000000000000000000000000
      00007FDFFF0070DFFF006FD0FF0060D0FF006FA0F00030303000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000007F7F7F00BFBFBF00007F0000007F
      0000FFFFFF00007F0000007F0000FFFFFF00BFBFBF00BFBFBF007F7F7F007F7F
      7F007F7F7F00000000000000000000000000000000000000000000000000FFFF
      FF0000FFFF00FFFFFF0000FFFF00FFFFFF0000FFFF00FFFFFF0000FFFF00FFFF
      FF00000000000000000000000000000000000000000000000000000000000000
      000090E0FF008FE0FF0080DFFF00FFFFFF0080B0F00040404000000000000000
      0000000000000000000000000000000000000000000000000000FFFFFF000000
      000000000000FF000000FF000000FF000000FF000000FF000000FF000000FF00
      0000000000000000000000000000000000007F7F7F00BFBFBF00007F0000FFFF
      FF00BFBFBF00007F00007F7F7F00FFFFFF00BFBFBF00BFBFBF007F7F7F007F7F
      7F007F7F7F007F7F7F000000000000000000000000000000000000000000FFFF
      FF0000FFFF00FFFFFF0000FFFF00FFFFFF0000FFFF00FFFFFF0000FFFF00FFFF
      FF00000000000000000000000000000000000000000000000000000000000000
      00009FEFFF002F7FFF001F70FF000F6FFF000060FF0050505000000000000000
      0000000000000000000000000000000000000000000000000000FFFFFF000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000007F7F7F00BFBFBF00BFBFBF00BFBF
      BF00007F00007F7F7F00BFBFBF00BFBFBF00BFBFBF00BFBFBF007F7F7F007F7F
      7F007F7F7F007F7F7F0000000000000000000000000000000000000000000000
      000000FFFF000000000000FFFF000000000000FFFF00FFFFFF0000FFFF00FFFF
      FF00000000000000000000000000000000000000000000000000000000000000
      00008080800040404000404040001F1F1F000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00000000000000
      000000000000000000000000000000000000BFBFBF00BFBFBF00BFBFBF00BFBF
      BF00BFBFBF00BFBFBF00BFBFBF00BFBFBF00FFFFFF00BFBFBF00BFBFBF00FFFF
      FF007F7F7F007F7F7F007F7F7F00000000000000000000000000000000000000
      00000000000000000000FFFFFF00FFFFFF00FFFFFF000000000000FFFF00FFFF
      FF00000000000000000000000000000000000000000000000000000000000000
      0000000000009F9F9F009F9F9F005F5F5F000F0F0F0000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000BFBFBF00BFBFBF00BFBFBF00BFBF
      BF00BFBFBF00FFFFFF00BFBFBF00BFBFBF00BFBFBF00BFBFBF00BFBFBF007F7F
      7F007F7F7F00FFFFFF007F7F7F00000000000000000000000000000000000000
      00000000000000000000FFFFFF00FFFFFF00FFFFFF00FFFFFF0000FFFF00FFFF
      FF00000000000000000000000000000000000000000000000000000000000000
      000000000000D0D0D000D0D0D0007F7F7F001F1F1F0000000000000000000000
      000000000000000000000000000000000000000000000000000000000000FF00
      0000FF000000FF000000FF000000FF000000FF000000FF000000000000000000
      000000000000000000000000000000000000BFBFBF00BFBFBF00FFFFFF00BFBF
      BF00BFBFBF00BFBFBF00BFBFBF007F7F7F007F7F7F00FFFFFF00BFBFBF00BFBF
      BF007F7F7F007F7F7F0000000000000000000000000000000000000000000000
      000000000000000000000000000000000000FFFFFF0000000000FFFFFF000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000009F9F9F005F5F5F000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000000000007F7F7F007F7F7F007F7F
      7F00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000000000007F7F7F000000
      00007F7F7F007F7F7F00FFFFFF007F7F7F007F7F7F007F7F7F00000000000000
      000000000000000000000000000000000000424D3E000000000000003E000000
      2800000040000000300000000100010000000000800100000000000000000000
      000000000000000000000000FFFFFF00FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
      FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
      FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
      FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
      FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFE007FFC3FFFFFFFF
      8007FFC1803FF3BF8007FF808003E11F8007F0808001E10F8007E0008001E01F
      8007C0088001E03F8007C0008001F03F8007C0008001F81F8003C0018001F81F
      8001C0418001F80F8001C0638001F107800D207F8001F187800F30FFFC01F3CF
      FFFFFFFFFFE7FFFFFFFFFBFFFFFFFFFFFFFFFC3FFC00FE7FF7FFF80FFC00F81F
      E1FFF007FC00E00FE07FF007FC00C007E01FF007E0008007E007F067E1008007
      E007F03FE0008007E007F03FE0078003E007F03F80070003E007F03F88070003
      E007F03F80070003E007F0FF801F0001F807F87F801F0001FC07F87FA01F0003
      FE07FCFF801F001FFFEFFFFFFFFFC03F00000000000000000000000000000000
      000000000000}
  end
end
