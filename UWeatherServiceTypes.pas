unit UWeatherServiceTypes;

interface
uses
    System.SysUtils
  , System.Generics.Collections
  ;

type
  TWeatherLocation = class
  private
    FName: String;
    FLatitude: Double;
    FLongitude: Double;
    FLocalName: String;
    FCountry: String;
    FState: String;

  public
    property Name: String read FName write FName;
    property LocalName: String read FLocalName write FLocalName;
    property Country: String read FCountry write FCountry;
    property State: String read FState write FState;

    property Latitude: Double read FLatitude write FLatitude;
    property Longitude: Double read FLongitude write FLongitude;
  end;

  TWeatherForecast = class
  private
    FDt: TDateTime;
    FTemperature: Double;
    FHumidity: Double;
    FDescription: String;
    FIcon: String;
    FPropPrec: Double;
    function GetDtReadable: String;
    function GetIconUrl: String;
  public
    property Dt: TDateTime read FDt write FDt;
    property Temperature: Double read FTemperature write FTemperature;
    property Humidity: Double read FHumidity write FHumidity;
    property Description: String read FDescription write FDescription;
    property Icon: String read FIcon write FIcon;
    property PropPrec: Double read FPropPrec write FPropPrec;

    property IconUrl: String read GetIconUrl;
    property DtReadable: String read GetDtReadable;
  end;

  TWeatherForecastsArray = array of TWeatherForecast;

  TWeatherForecasts = TObjectList<TWeatherForecast>;


implementation

const
  URL_ICON = 'https://openweathermap.org/img/wn/%s@2x.png';

{ TWeatherForecast }

function TWeatherForecast.GetDtReadable: String;
begin
  Result := DateTimeToStr(Dt);
end;

function TWeatherForecast.GetIconUrl: String;
begin
  Result := Format( URL_ICON, [Icon] );
end;


end.
