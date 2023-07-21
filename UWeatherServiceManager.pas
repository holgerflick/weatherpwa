unit UWeatherServiceManager;

interface

uses
  System.SysUtils, System.Classes, JS, Web, WEBLib.Modules, WEBLib.ExtCtrls,
  WEBLib.REST, UWeatherServiceTypes;

type
  TWeatherServiceManager = class(TWebDataModule)
    Geocoder: TWebGeoLocation;
    Request: TWebHttpRequest;
    procedure WebDataModuleDestroy(Sender: TObject);
    procedure WebDataModuleCreate(Sender: TObject);
    procedure GeocoderGeolocation(Sender: TObject; Lat, Lon, Alt: Double);

  private
    FLocation: TWeatherLocation;
    FOnForecastUpdated: TNotifyEvent;
    FOnLocationUpdated: TNotifyEvent;
    FForecasts: TWeatherForecasts;

    [async] procedure GetForecastForCurrentLocation;

    [async] procedure GetLocationNameForCurrentLocation;

    function GetForecastUrlForLocation: String;
    function GetReverseGeocodingUrlForLocation: String;

    procedure ProcessReverseGeocodingResult(AResponse: TJSXMLHttpRequest);
    procedure ProcessForecastResult(AResponse: JSValue; ADoStore: Boolean = true);

    procedure StoreLastForecastResponse(AResponse: JSValue);
    function GetCurrentForecast: TWeatherForecast;

  public
    procedure LoadLastForecastResponse;

    procedure UpdateLocation;
    procedure UpdateForecast;

    property CurrentForecast: TWeatherForecast read GetCurrentForecast;

    property Location: TWeatherLocation read FLocation;
    property Forecasts: TWeatherForecasts read FForecasts write FForecasts;

    property OnLocationUpdated: TNotifyEvent
      read FOnLocationUpdated write FOnLocationUpdated;

    property OnForecastUpdated: TNotifyEvent
      read FOnForecastUpdated write FOnForecastUpdated;
  end;


implementation

{%CLASSGROUP 'Vcl.Controls.TControl'}

uses
    DateUtils
  , WebLib.Storage
  ;

const
  REQ_PATTERN_FORECAST = 'https://api.openweathermap.org/data/2.5/forecast?lat=%f&lon=%f&appid=%s&units=metric';
  REQ_PATTERN_REVERSE = 'https://api.openweathermap.org/geo/1.0/reverse?lat=%f&lon=%f&limit=1&appid=%s';
  STORAGE_KEY_FORECAST = 'cached_forecast';
  STORAGE_KEY_DT_FORECAST = 'cached_forecast_dt';
  STORAGE_KEY_MAP = 'cached_map';

  LANGID = 'en';

  API_KEY = '41bd2ec8a08aa94db50c45ab68ca71e8';

{$R *.dfm}

procedure TWeatherServiceManager.WebDataModuleDestroy(Sender: TObject);
begin
  FLocation.Free;
  FForecasts.Free;
end;

procedure TWeatherServiceManager.WebDataModuleCreate(Sender: TObject);
begin
  FLocation := TWeatherLocation.Create;
  FForecasts := TWeatherForecasts.Create;
end;

function TWeatherServiceManager.GetForecastUrlForLocation: String;
begin
  Result := Format(
    REQ_PATTERN_FORECAST,
    [ Location.Latitude, Location.Longitude, API_KEY ]
    );
end;

procedure TWeatherServiceManager.GetLocationNameForCurrentLocation;
var
  LResponse: TJSXMLHttpRequest;

begin
  Request.URL := GetReverseGeocodingUrlForLocation;
  console.log(Request.URL);

  LResponse := await( TJSXMLHttpRequest, Request.Perform );

  if LResponse.Status = 200 then
  begin
    ProcessReverseGeocodingResult(LResponse);
  end;
end;

function TWeatherServiceManager.GetReverseGeocodingUrlForLocation: String;
begin
  Result := Format(
    REQ_PATTERN_REVERSE,
    [ Location.Latitude, Location.Longitude, API_KEY ] );
end;

procedure TWeatherServiceManager.LoadLastForecastResponse;
var
  LStoredForecast: String;
  LJSON: JSValue;
begin
  LStoredForecast := TLocalStorage.GetValue(STORAGE_KEY_FORECAST);

  if not LStoredForecast.IsEmpty then
  begin
    console.log('Loaded locally stored forecast.');
    LJSON := TJSJSON.parse(LStoredForecast);

    // process, but do not store locally - it's already stored
    ProcessForecastResult(LJSON, False);
  end;
end;

function TWeatherServiceManager.GetCurrentForecast: TWeatherForecast;
var
  LIndex: Integer;
  LForecast: TWeatherForecast;
begin
  Result := nil;

  LIndex := 0;

  // This simple algorithm works because the forecast items are returned in
  // order. The first index in the list denotes the most current weather forecast
  // whereas the last index is the most distant in the future.
  // For the particular endpoint chosen this means 3 days out.
  while Result = nil do
  begin
    LForecast := FForecasts[LIndex];
    if UniversalTimeToLocal(LForecast.Dt) > Now then
    begin
      Result := LForecast;
    end;

    Inc(LIndex);
  end;

  if Result = nil then
  begin
    Result := FForecasts.Last;
  end;
end;

procedure TWeatherServiceManager.GetForecastForCurrentLocation;
var
  LResponse: TJSXMLHttpRequest;

begin
  Request.URL := GetForecastUrlForLocation;

  LResponse := await( TJSXMLHttpRequest, Request.Perform );

  if LResponse.Status = 200 then
  begin
    console.info('Loading from webservice response.');
    ProcessForecastResult(LResponse.response);
  end;
end;

procedure TWeatherServiceManager.GeocoderGeolocation(Sender: TObject; Lat, Lon,
    Alt: Double);
begin
  Location.Latitude := Lat;
  Location.Longitude := Lon;

  if Assigned( FOnLocationUpdated ) then
  begin
    FOnLocationUpdated( Location );
  end;
end;

procedure TWeatherServiceManager.ProcessForecastResult(AResponse: JSValue;
    ADoStore: Boolean = true);
var
  LArray: TJSArray;
  LObj: TJSObject;
  LMain,
  LWeather: TJSObject;

  i: Integer;

  LForecast: TWeatherForecast;

begin
  LArray := TJSArray( TJSObject(AResponse)['list'] );

  FForecasts.Clear;

  for i := 0 to LArray.Length-1 do
  begin
    LObj := TJSObject( LArray[i] );
    LMain := TJSObject(LObj['main']);
    LWeather := TJSObject( TJSArray(LObj['weather'])[0] );

    LForecast := TWeatherForecast.Create;
    LForecast.Dt := UnixToDateTime( JS.toInteger( LObj['dt'] ) );
    LForecast.Temperature := JS.toNumber( LMain['temp'] );
    LForecast.Humidity := JS.toNumber( LMain['humidity'] );
    LForecast.Description := JS.toString( LWeather['description'] );
    LForecast.Icon := JS.toString( LWeather['icon'] );

    FForecasts.Add(LForecast);
  end;

  if (FForecasts.Count>0) then
  begin
    if ADoStore then
    begin
      StoreLastForecastResponse(AResponse);
    end;

    if (Assigned(FOnForecastUpdated)) then
    begin
      FOnForecastUpdated(nil);
    end;
  end;
end;

procedure TWeatherServiceManager.ProcessReverseGeocodingResult(AResponse:
    TJSXMLHttpRequest);
var
  LObject: TJSObject;
  LArray: TJSArray;

begin
  LArray := TJSArray( AResponse.response );
  if LArray.Length > 0 then
  begin
    LObject := TJSObject( LArray[0] );

    Location.Name := JS.toString( LObject['name'] );
    Location.Country := JS.toString( LObject['country'] );
    Location.State := JS.toString( LObject['state'] );

    if Assigned( TJSObject( LObject['local_names'] )[LANGID] ) then
    begin
      Location.LocalName := JS.toString( TJSObject( LObject['local_names'] )[LANGID] );
    end
    else
    begin
      Location.LocalName := Location.Name;
    end;
  end;
end;

procedure TWeatherServiceManager.StoreLastForecastResponse(AResponse: JSValue);

begin
  TLocalStorage.SetValue( STORAGE_KEY_FORECAST,
     TJSJSON.stringify(AResponse)
     );

  // as the date/time is only used locally, we can use the local time of the
  // system
  TLocalStorage.SetValue( STORAGE_KEY_DT_FORECAST,
    DateTimeToRFC3339( Now ) );
  console.info('Stored forecast locally.');
end;

procedure TWeatherServiceManager.UpdateForecast;
begin
  GetForecastForCurrentLocation;
end;

procedure TWeatherServiceManager.UpdateLocation;
begin
  Geocoder.GetGeolocation;
end;

end.
