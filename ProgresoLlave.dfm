object FProgresoLlave: TFProgresoLlave
  Left = 415
  Top = 268
  BorderIcons = []
  BorderStyle = bsToolWindow
  Caption = 'Lectura de llave'
  ClientHeight = 53
  ClientWidth = 364
  Color = clMenu
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
    Width = 188
    Height = 20
    Caption = 'Protección de Software'
    Color = clBlack
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clBlack
    Font.Height = -16
    Font.Name = 'MS Sans Serif'
    Font.Style = [fsBold]
    ParentColor = False
    ParentFont = False
    Transparent = True
  end
  object ProgressBar1: TProgressBar
    Left = 8
    Top = 32
    Width = 353
    Height = 16
    Min = 0
    Max = 100
    TabOrder = 0
  end
  object Timer1: TTimer
    Interval = 200
    OnTimer = Timer1Timer
    Left = 328
    Top = 8
  end
end
