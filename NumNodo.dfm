inherited FNumNodo: TFNumNodo
  Caption = 'Configuración de nodo'
  ClientHeight = 229
  OldCreateOrder = True
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  inherited Label1: TLabel
    Width = 155
    Caption = 'Ingrese el número del nodo'
  end
  inherited btnAcepta: TSpeedButton
    Top = 168
    Hint = 'Cambia el nuevo número de nodo'
  end
  inherited SpeedButton1: TSpeedButton
    Top = 200
    Hint = 'Cancela el cambio'
  end
  object Label2: TLabel [3]
    Left = 8
    Top = 160
    Width = 55
    Height = 13
    Caption = 'Dirección'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'MS Sans Serif'
    Font.Style = [fsBold]
    ParentFont = False
  end
  object Label3: TLabel [4]
    Left = 8
    Top = 208
    Width = 133
    Height = 13
    Caption = 'Ejemplo: 192.168.67.2:1024'
  end
  inherited ComboBox1: TComboBox
    Style = csDropDownList
  end
  object optTipoConexion: TRadioGroup
    Left = 8
    Top = 72
    Width = 169
    Height = 73
    Hint = 'Modo de conexión del nodo a la PC'
    Caption = 'Tipo de Conexión'
    ItemIndex = 0
    Items.Strings = (
      'Puerto Serie'
      'TCP/IP')
    TabOrder = 1
    OnClick = optTipoConexionClick
  end
  object txtDireccion: TEdit
    Left = 8
    Top = 176
    Width = 169
    Height = 21
    Hint = 'Dirección IP y puerto de la conversora conectada al nodo'
    TabOrder = 2
  end
end
