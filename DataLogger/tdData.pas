unit tdData;

interface

uses
  System.SysUtils, System.Classes, FireDAC.Stan.Intf, FireDAC.Stan.Option,
  FireDAC.Stan.Error, FireDAC.UI.Intf, FireDAC.Phys.Intf, FireDAC.Stan.Def,
  FireDAC.Stan.Pool, FireDAC.Stan.Async, FireDAC.Phys, FireDAC.Phys.MSSQL,
  FireDAC.FMXUI.Wait, FireDAC.Stan.Param, FireDAC.DatS, FireDAC.DApt.Intf,
  FireDAC.DApt, Data.DB, FireDAC.Comp.DataSet, FireDAC.Comp.Client,
  FireDAC.Phys.ODBCBase, FireDAC.Comp.UI, tdSettings;

type
  TdmData = class(TDataModule)
    FDConn: TFDConnection;
    FDGUIxWaitCursor: TFDGUIxWaitCursor;
    FDPhysMSSQLDriverLink: TFDPhysMSSQLDriverLink;
    fdqClient: TFDQuery;
    fdqSensor: TFDQuery;
    fdqClientClientID: TIntegerField;
    fdqClientUUID: TStringField;
    fdqClientName: TWideStringField;
    fdqClientOnline: TByteField;
    fdqClientType: TStringField;
    fdqClientVersion: TStringField;
    fdqClientExtentions: TIntegerField;
    fdqClientEditable: TByteField;
    fdqClientIP: TStringField;
    fdqSensorSensorID: TIntegerField;
    fdqSensorClientID: TIntegerField;
    fdqSensorName: TWideStringField;
    fdqSensorIgnored: TByteField;
    fdqSensorOnline: TByteField;
    fdqSensorEditable: TByteField;
    fdqSensorProtocol: TStringField;
    fdqSensorInternalSensorId: TStringField;
    fdqSensorLog: TFDQuery;
    fdqSensorLogSensorID: TIntegerField;
    fdqSensorLogUpdated: TSQLTimeStampField;
    fdqSensorLogTempValue: TFloatField;
    fdqSensorLogHumidityValue: TFloatField;
    fdqImportLog: TFDQuery;
    fdqImportLogImportId: TFDAutoIncField;
    fdqImportLogImported: TSQLTimeStampField;
    fdqImportLogRawData: TMemoField;
    fdqImportLogDataType: TStringField;
    procedure DataModuleCreate(Sender: TObject);
    procedure DataModuleDestroy(Sender: TObject);
    procedure FDConnBeforeConnect(Sender: TObject);
  private
    { Private declarations }
    Settings: TSettings;
  public
    { Public declarations }
  end;

var
  dmData: TdmData;

implementation

{%CLASSGROUP 'FMX.Controls.TControl'}

{$R *.dfm}

procedure TdmData.DataModuleCreate(Sender: TObject);
begin
  Settings := TSettingsHandler.LoadFromFile();
  FDConn.Open;
end;

procedure TdmData.DataModuleDestroy(Sender: TObject);
begin
  Settings.Free;
end;

procedure TdmData.FDConnBeforeConnect(Sender: TObject);
begin
  FDConn.Params.Values['User_Name'] := Settings.Username;
  FDConn.Params.Values['Database'] := Settings.Database;
  FDConn.Params.Values['Password'] := Settings.Password;
  if Settings.Port = 0 then
    FDConn.Params.Values['Server'] := Settings.Server
  else
    FDConn.Params.Values['Server'] := Settings.Server + ',' + Settings.Port.ToString;
end;

end.
