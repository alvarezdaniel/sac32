object FCom: TFCom
  OldCreateOrder = False
  OnCreate = DataModuleCreate
  OnDestroy = DataModuleDestroy
  Left = 349
  Top = 199
  Height = 479
  Width = 434
  object port1: TApdComPort
    Baud = 38400
    InSize = 2048
    OutSize = 1024
    AutoOpen = False
    DTR = False
    TraceSize = 65000
    TraceName = 'SAC32.trc'
    LogSize = 65000
    LogName = 'SAC32.log'
    CommNotificationLevel = 1
    TapiMode = tmOff
    OnTriggerAvail = port1TriggerAvail
    Left = 24
    Top = 8
  end
  object Consulta: TQuery
    DatabaseName = 'MIBASE'
    DataSource = dComm
    Left = 88
    Top = 8
  end
  object dComm: TDataSource
    Left = 160
    Top = 8
  end
  object TimerCOM: TTimer
    Enabled = False
    Interval = 100
    OnTimer = TimerCOMTimer
    Left = 24
    Top = 72
  end
end
