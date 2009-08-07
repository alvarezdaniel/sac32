object FPaquetes: TFPaquetes
  Left = 482
  Top = 238
  BorderIcons = [biHelp]
  BorderStyle = bsToolWindow
  Caption = 'Paquetes'
  ClientHeight = 275
  ClientWidth = 353
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
  object memo: TMemo
    Left = 0
    Top = 0
    Width = 353
    Height = 275
    Align = alClient
    ReadOnly = True
    TabOrder = 0
    OnDblClick = memoDblClick
  end
end
