object FDebug: TFDebug
  Left = 199
  Top = 154
  Width = 696
  Height = 480
  Caption = 'Debug'
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  PixelsPerInch = 96
  TextHeight = 13
  object Label1: TLabel
    Left = 88
    Top = 176
    Width = 45
    Height = 13
    Caption = 'Comando'
  end
  object Button1: TButton
    Left = 136
    Top = 8
    Width = 75
    Height = 25
    Caption = 'Estado'
    TabOrder = 0
    OnClick = Button1Click
  end
  object Edit1: TEdit
    Left = 8
    Top = 8
    Width = 121
    Height = 21
    TabOrder = 1
  end
  object Button3: TButton
    Left = 552
    Top = 112
    Width = 75
    Height = 25
    Caption = 'Valores'
    TabOrder = 2
    OnClick = Button3Click
  end
  object Memo1: TMemo
    Left = 312
    Top = 8
    Width = 241
    Height = 433
    ScrollBars = ssVertical
    TabOrder = 3
  end
  object Button4: TButton
    Left = 552
    Top = 136
    Width = 75
    Height = 25
    Caption = 'Modelo'
    TabOrder = 4
    OnClick = Button4Click
  end
  object Button5: TButton
    Left = 8
    Top = 80
    Width = 75
    Height = 25
    Caption = 'Escribe'
    TabOrder = 5
    OnClick = Button5Click
  end
  object Button6: TButton
    Left = 8
    Top = 48
    Width = 75
    Height = 25
    Caption = 'Lee'
    TabOrder = 6
    OnClick = Button6Click
  end
  object Button7: TButton
    Left = 200
    Top = 360
    Width = 75
    Height = 25
    Caption = 'Test'
    TabOrder = 7
    OnClick = Button8Click
  end
  object Edit2: TEdit
    Left = 88
    Top = 192
    Width = 121
    Height = 21
    TabOrder = 8
    Text = '0'
  end
  object Button8: TButton
    Left = 8
    Top = 192
    Width = 75
    Height = 25
    Caption = 'CMD'
    TabOrder = 9
    OnClick = Button8Click
  end
  object Button9: TButton
    Left = 576
    Top = 248
    Width = 75
    Height = 25
    Caption = 'Borra EV'
    TabOrder = 10
    OnClick = Button9Click
  end
  object Button10: TButton
    Left = 576
    Top = 272
    Width = 75
    Height = 25
    Caption = 'Borra HAB'
    TabOrder = 11
    OnClick = Button10Click
  end
  object Button11: TButton
    Left = 24
    Top = 248
    Width = 75
    Height = 25
    Caption = 'Cantidad EV'
    TabOrder = 12
    OnClick = Button11Click
  end
  object Button12: TButton
    Left = 24
    Top = 280
    Width = 75
    Height = 25
    Caption = 'Cantidad HAB'
    TabOrder = 13
    OnClick = Button12Click
  end
  object Button13: TButton
    Left = 200
    Top = 296
    Width = 75
    Height = 25
    Caption = 'Reset'
    TabOrder = 14
    OnClick = Button13Click
  end
  object Button14: TButton
    Left = 224
    Top = 120
    Width = 75
    Height = 25
    Caption = 'Escribe Reloj'
    TabOrder = 15
    OnClick = Button14Click
  end
  object Button2: TButton
    Left = 72
    Top = 376
    Width = 75
    Height = 25
    Caption = 'Button2'
    TabOrder = 16
    OnClick = Button2Click
  end
  object Button15: TButton
    Left = 176
    Top = 224
    Width = 107
    Height = 25
    Caption = 'Agregar Usuarios'
    TabOrder = 17
    OnClick = Button15Click
  end
  object Button16: TButton
    Left = 120
    Top = 56
    Width = 75
    Height = 25
    Caption = 'Baja Evento'
    TabOrder = 18
    OnClick = Button16Click
  end
  object Edit3: TEdit
    Left = 200
    Top = 56
    Width = 81
    Height = 21
    TabOrder = 19
  end
end
