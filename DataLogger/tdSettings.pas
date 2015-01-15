unit tdSettings;

interface

uses Classes, SysUtils, Rest.Json, System.JSON;

type
  TSettings = class(TObject)
  private
    FServer: String;
    FDatabase: String;
    FUsername: String;
    FPassword: String;
    FPort: Integer;
  public
    property Server: String read FServer write FServer;
    property Database: String read FDatabase write FDatabase;
    property Username: String read FUsername write FUsername;
    property Password: String read FPassword write FPassword;
    property Port: Integer read FPort write FPort;
    constructor Create();
  end;

  TSettingsHandler = class(TObject)
  published
    class function LoadFromFile(Path: String = ''): TSettings;
    class procedure SaveToFile(Settings: TSettings; Path: String = '');
  end;

implementation

{ TSettingsHandler }

class function TSettingsHandler.LoadFromFile(Path: String): TSettings;
var
  Strings: TStrings;
begin
  if Path = '' then
    Path := ChangeFileExt(ParamStr(0), '') + '.json';

  if FileExists(Path) then begin
    Strings := TStringList.Create;
    Strings.LoadFromFile(Path);
    Result := TJSON.JsonToObject<TSettings>(Strings.Text);
    Strings.Free();
  end
  else
    Result := TSettings.Create();
end;

class procedure TSettingsHandler.SaveToFile(Settings: TSettings; Path: String);
var
  Strings : TStrings;
  AJSONObject: TJSOnObject;

begin
  if Path = '' then
    Path := ChangeFileExt(ParamStr(0), '') + '.json';

  AJSONObject := TJSON.ObjectToJsonObject(Settings);

  Strings := TStringList.Create;
  Strings.Add(TJSON.Format(AJSONObject));
  Strings.SaveToFile(Path);
  Strings.Free;
end;

{ TSettings }

constructor TSettings.Create;
begin
  FPort := 0;
end;

end.
