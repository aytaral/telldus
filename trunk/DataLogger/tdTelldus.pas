unit tdTelldus;

interface

uses
  System.SysUtils, System.Classes, System.Generics.Collections;

type
  TClient = class(TPersistent)
  public
    Id: Integer;
    Name: String;
    Online: Boolean;
  end;

  TSensor = class(TPersistent)
  public
    Id: Integer;
    Name: String;
    Temp: Double;
    Humidity: Double;
    LastUpdated: TDateTime;
    Ignored: Boolean;
    Editable: Boolean;
    Protocol: String;
    SensorId: String;
    TimezoneOffset: Integer;
    Client: TClient;
  end;

  TDataSensor = class(TObject)
    id: String;
    clientName: String;
//    name: String;
//    lastUpdated: Integer;
//    ignored: smallint;
//    editable: smallint;
//    protocol: string;
//    sensorId: string;
//    timezoneoffset: integer;
  end;

  TClientList = TObjectList<TClient>;
  TSensorList = TObjectList<TSensor>;

  TTelldus = class(TObject)
  private
    FClients: TClientList;
    FSensors: TSensorList;
  public
    constructor Create;
    destructor Destroy; override;
    property Clients: TClientList read FClients;
    property Sensors: TSensorList read FSensors;
  end;


implementation

{ TTelldus }

constructor TTelldus.Create;
begin
  FClients := TClientList.Create(True);
  FSensors := TSensorList.Create(True);
end;

destructor TTelldus.Destroy;
begin
  FClients.Free;
  FSensors.Free;

  inherited;
end;

end.
