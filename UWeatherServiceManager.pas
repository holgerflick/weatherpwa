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

    [async]
    procedure GetForecastForCurrentLocation;

    [async]
    procedure GetLocationNameForCurrentLocation;

    function GetForecastUrlForLocation: String;
    function GetReverseGeocodingUrlForLocation: String;

    procedure UpdateLocation;
  public
    property Location: TWeatherLocation read FLocation;
  end;


implementation

{%CLASSGROUP 'Vcl.Controls.TControl'}
const
  REQ_PATTERN_FORECAST = 'https://api.openweathermap.org/data/2.5/forecast?lat=%f&lon=%f&appid=%s&units=metric';
  REQ_PATTERN_REVERSE = 'https://api.openweathermap.org/geo/1.0/reverse?lat=%f&lon=%f&limit=1&appid=%s';

  LANGID = 'en';

  API_KEY = '41bd2ec8a08aa94db50c45ab68ca71e8';

{$R *.dfm}

procedure TWeatherServiceManager.WebDataModuleDestroy(Sender: TObject);
begin
  FLocation.Free;
end;

procedure TWeatherServiceManager.WebDataModuleCreate(Sender: TObject);
begin
  FLocation := TWeatherLocation.Create;

  UpdateLocation;
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
  LObject: TJSObject;
  LArray: TJSArray;

begin
  Request.URL := GetReverseGeocodingUrlForLocation;
  console.log(Request.URL);

  LResponse := await( TJSXMLHttpRequest, Request.Perform );

  if LResponse.Status = 200 then
  begin
    LArray := TJSArray( LResponse.response );
    if LArray.Length > 0 then
    begin
      LObject := TJSObject( LArray[0] );

      Location.Name := JS.toString( LObject['name'] );
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
end;

function TWeatherServiceManager.GetReverseGeocodingUrlForLocation: String;
begin
  Result := Format(
    REQ_PATTERN_REVERSE,
    [ Location.Latitude, Location.Longitude, API_KEY ] );
end;

procedure TWeatherServiceManager.GetForecastForCurrentLocation;
begin
  Request.URL := GetForecastUrlForLocation;

  console.log(Request.URL);
end;

procedure TWeatherServiceManager.GeocoderGeolocation(Sender: TObject; Lat, Lon,
    Alt: Double);
begin
  Location.Latitude := Lat;
  Location.Longitude := Lon;

  GetForecastForCurrentLocation;
  GetLocationNameForCurrentLocation;
end;

procedure TWeatherServiceManager.UpdateLocation;
begin
  Geocoder.GetGeolocation;
end;

end.
