object dmData: TdmData
  OldCreateOrder = False
  OnCreate = DataModuleCreate
  OnDestroy = DataModuleDestroy
  Height = 329
  Width = 488
  object FDConn: TFDConnection
    Params.Strings = (
      'User_Name=tmpuser'
      'Password=abc123'
      'Server=ds.labit.no,443'
      'Database=Telldus'
      'DriverID=MSSQL')
    ConnectedStoredUsage = [auDesignTime]
    LoginPrompt = False
    BeforeConnect = FDConnBeforeConnect
    Left = 58
    Top = 24
  end
  object FDGUIxWaitCursor: TFDGUIxWaitCursor
    Provider = 'FMX'
    Left = 58
    Top = 120
  end
  object FDPhysMSSQLDriverLink: TFDPhysMSSQLDriverLink
    Left = 58
    Top = 72
  end
  object fdqClient: TFDQuery
    CachedUpdates = True
    IndexFieldNames = 'ClientID'
    Connection = FDConn
    SQL.Strings = (
      'select * from Client')
    Left = 146
    Top = 24
    object fdqClientClientID: TIntegerField
      FieldName = 'ClientID'
      Origin = 'ClientID'
      ProviderFlags = [pfInUpdate, pfInWhere, pfInKey]
      Required = True
    end
    object fdqClientUUID: TStringField
      FieldName = 'UUID'
      Origin = 'UUID'
      Size = 50
    end
    object fdqClientName: TWideStringField
      FieldName = 'Name'
      Origin = 'Name'
      Size = 100
    end
    object fdqClientOnline: TByteField
      FieldName = 'Online'
      Origin = 'Online'
    end
    object fdqClientType: TStringField
      FieldName = 'Type'
      Origin = 'Type'
      Size = 30
    end
    object fdqClientVersion: TStringField
      FieldName = 'Version'
      Origin = 'Version'
      Size = 10
    end
    object fdqClientExtentions: TIntegerField
      FieldName = 'Extentions'
      Origin = 'Extentions'
    end
    object fdqClientEditable: TByteField
      FieldName = 'Editable'
      Origin = 'Editable'
    end
    object fdqClientIP: TStringField
      FieldName = 'IP'
      Origin = 'IP'
      Size = 32
    end
  end
  object fdqSensor: TFDQuery
    CachedUpdates = True
    IndexFieldNames = 'SensorID'
    Connection = FDConn
    SQL.Strings = (
      'select * '
      'from Sensor'
      'where Ignored = 0'
      'and Online = 1')
    Left = 208
    Top = 24
    object fdqSensorSensorID: TIntegerField
      FieldName = 'SensorID'
      Origin = 'SensorID'
      ProviderFlags = [pfInUpdate, pfInWhere, pfInKey]
      Required = True
    end
    object fdqSensorClientID: TIntegerField
      FieldName = 'ClientID'
      Origin = 'ClientID'
    end
    object fdqSensorName: TWideStringField
      FieldName = 'Name'
      Origin = 'Name'
      Size = 100
    end
    object fdqSensorIgnored: TByteField
      FieldName = 'Ignored'
      Origin = 'Ignored'
    end
    object fdqSensorOnline: TByteField
      FieldName = 'Online'
      Origin = 'Online'
    end
    object fdqSensorEditable: TByteField
      FieldName = 'Editable'
      Origin = 'Editable'
    end
    object fdqSensorProtocol: TStringField
      FieldName = 'Protocol'
      Origin = 'Protocol'
      Size = 50
    end
    object fdqSensorInternalSensorId: TStringField
      FieldName = 'InternalSensorId'
      Origin = 'InternalSensorId'
    end
  end
  object fdqSensorLog: TFDQuery
    CachedUpdates = True
    Connection = FDConn
    SQL.Strings = (
      'select * '
      'from SensorLog'
      'where SensorID = :SensorId'
      'and Updated = :Updated')
    Left = 280
    Top = 24
    ParamData = <
      item
        Name = 'SENSORID'
        DataType = ftInteger
        ParamType = ptInput
        Value = 12345
      end
      item
        Name = 'UPDATED'
        DataType = ftDateTime
        ParamType = ptInput
        Value = Null
      end>
    object fdqSensorLogSensorID: TIntegerField
      FieldName = 'SensorID'
      Origin = 'SensorID'
      ProviderFlags = [pfInUpdate, pfInWhere, pfInKey]
      Required = True
    end
    object fdqSensorLogUpdated: TSQLTimeStampField
      FieldName = 'Updated'
      Origin = 'Updated'
      ProviderFlags = [pfInUpdate, pfInWhere, pfInKey]
      Required = True
    end
    object fdqSensorLogTempValue: TFloatField
      FieldName = 'TempValue'
      Origin = 'TempValue'
    end
    object fdqSensorLogHumidityValue: TFloatField
      FieldName = 'HumidityValue'
      Origin = 'HumidityValue'
    end
  end
  object fdqImportLog: TFDQuery
    Connection = FDConn
    SQL.Strings = (
      'select top 1 * from ImportLog')
    Left = 144
    Top = 120
    object fdqImportLogImportId: TFDAutoIncField
      FieldName = 'ImportId'
      Origin = 'ImportId'
      ProviderFlags = [pfInWhere, pfInKey]
      ReadOnly = True
    end
    object fdqImportLogImported: TSQLTimeStampField
      FieldName = 'Imported'
      Origin = 'Imported'
    end
    object fdqImportLogRawData: TMemoField
      FieldName = 'RawData'
      Origin = 'RawData'
      BlobType = ftMemo
    end
    object fdqImportLogDataType: TStringField
      FieldName = 'DataType'
      Origin = 'DataType'
      Size = 10
    end
  end
end
