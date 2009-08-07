object FPwd: TFPwd
  Left = 480
  Top = 259
  BorderIcons = []
  BorderStyle = bsToolWindow
  Caption = 'Clave'
  ClientHeight = 133
  ClientWidth = 260
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
  object Label1: TLabel
    Left = 8
    Top = 8
    Width = 65
    Height = 13
    Caption = 'Clave anterior'
  end
  object Label2: TLabel
    Left = 8
    Top = 56
    Width = 62
    Height = 13
    Caption = 'Nueva Clave'
  end
  object Editpwd1: TEdit
    Left = 8
    Top = 24
    Width = 121
    Height = 21
    MaxLength = 10
    PasswordChar = '*'
    TabOrder = 0
  end
  object Editpwd2: TEdit
    Left = 8
    Top = 72
    Width = 121
    Height = 21
    MaxLength = 10
    PasswordChar = '*'
    TabOrder = 1
  end
  object BitBtn1: TBitBtn
    Left = 160
    Top = 72
    Width = 89
    Height = 25
    Caption = '&Aceptar'
    TabOrder = 3
    Kind = bkYes
  end
  object BitBtn2: TBitBtn
    Left = 160
    Top = 104
    Width = 89
    Height = 25
    Caption = '&Cancelar'
    TabOrder = 4
    Kind = bkNo
  end
  object Editpwd3: TEdit
    Left = 8
    Top = 104
    Width = 121
    Height = 21
    MaxLength = 10
    PasswordChar = '*'
    TabOrder = 2
  end
end
