object FProgreso: TFProgreso
  Left = 383
  Top = 216
  BorderIcons = []
  BorderStyle = bsToolWindow
  Caption = 'Transferencia de datos'
  ClientHeight = 135
  ClientWidth = 446
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  FormStyle = fsStayOnTop
  OldCreateOrder = False
  Position = poScreenCenter
  OnCloseQuery = FormCloseQuery
  PixelsPerInch = 96
  TextHeight = 13
  object lbl: TLabel
    Left = 8
    Top = 16
    Width = 27
    Height = 13
    Caption = 'Texto'
  end
  object barra: TGauge
    Left = 14
    Top = 40
    Width = 418
    Height = 25
    ForeColor = clNavy
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clNavy
    Font.Height = -13
    Font.Name = 'MS Sans Serif'
    Font.Style = [fsBold]
    ParentFont = False
    Progress = 0
  end
  object ani: TAnimate
    Left = 87
    Top = 72
    Width = 272
    Height = 60
    Active = False
    CommonAVI = aviCopyFiles
    StopFrame = 34
  end
end
