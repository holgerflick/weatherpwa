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
    FCountry: String;

  public
    property Name: String read FName write FName;
    property Country: String read FCountry write FCountry;

    property Latitude: Double read FLatitude write FLatitude;
    property Longitude: Double read FLongitude write FLongitude;
  end;

  TWeatherForecast = class
  private
    FDt: TDateTime;
    FTemperature: Double;
    FHumidity: Integer;
    FDescription: String;
    FIcon: String;
    FPropPrec: Integer;
    function GetDtReadable: String;
    function GetIconUrl: String;
  public
    property Dt: TDateTime read FDt write FDt;
    property Temperature: Double read FTemperature write FTemperature;
    property Humidity: Integer read FHumidity write FHumidity;
    property Description: String read FDescription write FDescription;
    property Icon: String read FIcon write FIcon;
    property PropPrec: Integer read FPropPrec write FPropPrec;

    property IconUrl: String read GetIconUrl;
    property DtReadable: String read GetDtReadable;
  end;

  TWeatherForecastsArray = array of TWeatherForecast;

  TWeatherForecasts = TObjectList<TWeatherForecast>;


implementation

uses
  DateUtils
  ;

const
  URL_ICON = 'https://openweathermap.org/img/wn/%s@2x.png';

{ TWeatherForecast }

function TWeatherForecast.GetDtReadable: String;
var
  LFormat: TFormatSettings;

begin
  LFormat := TFormatSettings.Create;
  LFormat.ShortDateFormat := 'ddd mmm d, yyyy';
  LFormat.LongTimeFormat := '''@'' ham/pm';
  Result := DateTimeToStr( UniversalTimeToLocal(Dt), LFormat );
end;

function TWeatherForecast.GetIconUrl: String;
begin
  Result := Format( URL_ICON, [Icon] );
end;


end.
