unit tdMain;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants, 
  FMX.Types, FMX.Graphics, FMX.Controls, FMX.Forms, FMX.Dialogs, FMX.StdCtrls,
  IPPeerClient, System.Rtti, Data.Bind.EngExt, Fmx.Bind.DBEngExt, Fmx.Bind.Grid,
  System.Bindings.Outputs, Fmx.Bind.Editors, Data.Bind.Components,
  Data.Bind.Grid, Data.Bind.DBScope, FMX.Layouts, FMX.Grid, Data.DB,
  REST.Client, REST.Authenticator.Basic, Datasnap.DBClient, XJson, XJsonVariants,
  REST.Response.Adapter, Data.Bind.ObjectScope, REST.Json, FMX.Memo,
  System.JSON, MidasLib;

type
  TfrmTelldus = class(TForm)
    RESTClient: TRESTClient;
    RESTReqList: TRESTRequest;
    RESTResponse: TRESTResponse;
    RESTResponseDataSetAdapter: TRESTResponseDataSetAdapter;
    cdsList: TClientDataSet;
    HTTPBasicAuthenticator: THTTPBasicAuthenticator;
    dsList: TDataSource;
    memLog: TMemo;
    btnClients: TButton;
    btnSensor: TButton;
    btnSensorLog: TButton;
    RESTRequest: TRESTRequest;
    RESTResponseInfo: TRESTResponse;
    Timer: TTimer;
    cbAutoLog: TCheckBox;
    StyleBook: TStyleBook;
    cbLogImport: TCheckBox;
    BindingsList1: TBindingsList;
    LinkControlToPropertyEnabled: TLinkControlToProperty;
    procedure RESTResponseDataSetAdapterBeforeOpenDataSet(Sender: TObject);
    procedure RESTReqListAfterExecute(Sender: TCustomRESTRequest);
    procedure btnClientsClick(Sender: TObject);
    procedure btnSensorClick(Sender: TObject);
    procedure RESTRequestAfterExecute(Sender: TCustomRESTRequest);
    procedure btnSensorLogClick(Sender: TObject);
    procedure TimerTimer(Sender: TObject);
  private
    procedure SaveClientList;
    procedure SaveSensorList;
    procedure SaveSensor(Id: String; UpdateDB: Boolean = False);
    procedure SaveSensorToDB(ASensor: TxJSONObject);
    procedure SaveSensorLog(ASensor: TxJSONObject);
    { Private declarations }
  public
    { Public declarations }
  end;

var
  frmTelldus: TfrmTelldus;

implementation

{$R *.fmx}

uses tdData, JclStrings, tdTelldus, DateUtils;

procedure TfrmTelldus.btnClientsClick(Sender: TObject);
begin
  RESTResponseDataSetAdapter.ResetToDefaults;
  if cdsList.Active then
    cdsList.Close;
  RESTResponse.ResetToDefaults;

  RESTReqList.Resource := 'clients/list';
  RESTResponseDataSetAdapter.RootElement := 'client';
  RESTReqList.Execute;
  SaveClientList;
end;

procedure TfrmTelldus.SaveClientList;
begin
  dmData.fdqClient.Active := True;

  while not cdsList.Eof do begin

    if not dmData.fdqClient.FindKey([cdsList.FieldByName('id').AsInteger]) then
      dmData.fdqClient.Append
    else
      dmData.fdqClient.Edit;

    dmData.fdqClientClientID.AsInteger := cdsList.FieldByName('id').AsInteger;
    dmData.fdqClientUUID.AsString := cdsList.FieldByName('uuid').AsString;
    dmData.fdqClientName.AsString := cdsList.FieldByName('name').AsString;
    dmData.fdqClientOnline.AsInteger := cdsList.FieldByName('online').AsInteger;
    dmData.fdqClientEditable.AsInteger := cdsList.FieldByName('editable').AsInteger;
    dmData.fdqClientExtentions.AsInteger := cdsList.FieldByName('extensions').AsInteger;
    dmData.fdqClientVersion.AsString := cdsList.FieldByName('version').AsString;
    dmData.fdqClientType.AsString := cdsList.FieldByName('type').AsString;
    dmData.fdqClientIP.AsString := cdsList.FieldByName('ip').AsString;
    dmData.fdqClient.Post;
    dmData.fdqClient.ApplyUpdates(-1);

    cdsList.Next;
  end;

  dmData.fdqClient.Active := False;
end;

procedure TfrmTelldus.btnSensorClick(Sender: TObject);
begin
  RESTResponseDataSetAdapter.ResetToDefaults;
  if cdsList.Active then
    cdsList.Close;
  RESTResponse.ResetToDefaults;

  RESTReqList.Resource := 'sensors/list';
  RESTResponseDataSetAdapter.RootElement := 'sensor';
  RESTReqList.Execute;
  SaveSensorList;
end;

procedure TfrmTelldus.btnSensorLogClick(Sender: TObject);
begin
  //Looper i databasens Sensorer og henter verdier
  dmData.fdqSensor.Open;
  while not dmData.fdqSensor.Eof do begin
    SaveSensor(dmData.fdqSensorSensorID.AsString, False);
    dmData.fdqSensor.Next;
  end;
  dmData.fdqSensor.Close;
end;

procedure TfrmTelldus.SaveSensor(Id: String; UpdateDB: Boolean = False);
var
  J: TxJSONObject;
  A: Boolean;
begin
  RESTResponse.ResetToDefaults;
  RESTRequest.ResetToDefaults;

  RESTRequest.Resource := 'sensor/info';
  RESTRequest.Params.AddItem('id', Id);
  RESTRequest.Execute;

  if Pos('error', RESTResponseInfo.Content) > 0 then Exit;

  J := JSONObjectFromJSON(RESTResponseInfo.Content);
  if UpdateDB then begin

    A := dmData.fdqSensor.Active;
    if not A then
      dmData.fdqSensor.Open;

    SaveSensorToDB(J);

    if not A then
      dmData.fdqSensor.Close;
  end;

  SaveSensorLog(J);
end;

procedure TfrmTelldus.SaveSensorLog(ASensor: TxJSONObject);
var
  Updated: TDateTime;
  TempVal, HumVal: Double;
begin
  if VarIsEmpty(ASensor) then Exit;

  Updated := DateUtils.UnixToDateTime(ASensor.lastUpdated);
  dmData.fdqSensorLog.Params.ParamValues['SensorId'] := ASensor.id;
  dmData.fdqSensorLog.Params.ParamValues['Updated'] := Updated;

  TempVal := -99;
  HumVal := -99;

  FormatSettings.DecimalSeparator := '.';

  if ASensor.data.Count = 1 then begin
    if ASensor.data[0].Name = 'temp' then
      TempVal := ASensor.data[0].Value;
  end
  else if ASensor.data.Count = 2 then begin

    if ASensor.data[0].Name = 'temp' then
      TempVal := StrToFloat(ASensor.data[0].Value)
    else if ASensor.data[0].Name = 'humidity' then
      HumVal := StrToFloat(ASensor.data[0].Value);

    if ASensor.data[1].Name = 'humidity' then
      HumVal := StrToFloat(ASensor.data[1].Value)
    else if ASensor.data[1].Name = 'temp' then
      TempVal := StrToFloat(ASensor.data[1].Value);

  end;

  dmData.fdqSensorLog.Open;
  if (dmData.fdqSensorLog.RecordCount = 0) and ((HumVal <> -99) or (TempVal <> -99)) then begin
    dmData.fdqSensorLog.Append;
    dmData.fdqSensorLogSensorID.AsInteger := ASensor.id;
    dmData.fdqSensorLogUpdated.AsDateTime := Updated;
    if TempVal <> -99 then
      dmData.fdqSensorLogTempValue.AsFloat := TempVal;
    if HumVal <> -99 then
      dmData.fdqSensorLogHumidityValue.AsFloat := HumVal;
    dmData.fdqSensorLog.Post;
    dmData.fdqSensorLog.ApplyUpdates(-1);
  end;
  dmData.fdqSensorLog.Close;
end;

procedure TfrmTelldus.SaveSensorToDB(ASensor: TxJSONObject);
begin
  if dmData.fdqSensor.FindKey([ASensor.id]) then begin
    dmData.fdqSensor.Edit;
    dmData.fdqSensorName.AsString := ASensor.name;
    dmData.fdqSensorIgnored.AsInteger := ASensor.ignored;
    dmData.fdqSensorEditable.AsInteger := ASensor.editable;
    dmData.fdqSensorProtocol.AsString := ASensor.protocol;
    dmData.fdqSensorInternalSensorId.AsString := ASensor.sensorId;
    dmData.fdqSensor.Post;
    dmData.fdqSensor.ApplyUpdates(-1);
  end;
end;

procedure TfrmTelldus.TimerTimer(Sender: TObject);
begin
  btnSensorLogClick(Self);
end;

procedure TfrmTelldus.SaveSensorList;
var
  Sl: TStringList;
  I: Integer;
begin
  dmData.fdqSensor.Active := True;

  Sl := TStringList.Create;
  try

    while not cdsList.Eof do begin
      if not dmData.fdqSensor.FindKey([cdsList.FieldByName('id').AsInteger]) then begin
        dmData.fdqSensor.Append;
        dmData.fdqSensorSensorID.AsInteger := cdsList.FieldByName('id').AsInteger;
        dmData.fdqSensorClientID.AsInteger := cdsList.FieldByName('client').AsInteger;
        dmData.fdqSensorOnline.AsInteger := cdsList.FieldByName('online').AsInteger;
        dmData.fdqSensor.Post;
        dmData.fdqSensor.ApplyUpdates(-1);
      end;
      Sl.Add(cdsList.FieldByName('id').AsString);
      cdsList.Next;
    end;

    for I := 0 to Sl.Count -1 do
      SaveSensor(Sl[I], True);

  finally
    Sl.Free;
  end;

  dmData.fdqSensor.Active := False;
end;

procedure TfrmTelldus.RESTReqListAfterExecute(Sender: TCustomRESTRequest);
begin
  memLog.Lines.Clear;
  memLog.Lines.Add(DateTimeToStr(Now));
  memLog.Lines.Add(TJson.Format(RESTResponse.JSONValue));

  if cbLogImport.IsChecked then begin
    dmData.fdqImportLog.Open;
    dmData.fdqImportLog.Insert;
    dmData.fdqImportLogDataType.AsString := 'List';
    dmData.fdqImportLogRawData.AsString := TJson.Format(RESTResponse.JSONValue);
    dmData.fdqImportLog.Post;
  end;
end;

procedure TfrmTelldus.RESTRequestAfterExecute(Sender: TCustomRESTRequest);
begin
  memLog.Lines.Clear;
  memLog.Lines.Add(DateTimeToStr(Now));
  memLog.Lines.Add(TJson.Format(RESTResponseInfo.JSONValue));
  if cbLogImport.IsChecked then begin
    dmData.fdqImportLog.Open;
    dmData.fdqImportLog.Insert;
    dmData.fdqImportLogDataType.AsString := 'Info';
    dmData.fdqImportLogRawData.AsString := TJson.Format(RESTResponseInfo.JSONValue);
    dmData.fdqImportLog.Post;
  end;
end;

procedure TfrmTelldus.RESTResponseDataSetAdapterBeforeOpenDataSet(Sender: TObject);
begin
  if cdsList.FieldCount = 0 then
    cdsList.CreateDataSet;
end;

end.
