unit UWeatherServiceTypes;

interface

type
  TWeatherLocation = class
  private
    FName: String;
    FLatitude: Double;
    FLongitude: Double;
    FLocalName: String;

  public
    property Name: String read FName write FName;
    property LocalName: String read FLocalName write FLocalName;
    property Latitude: Double read FLatitude write FLatitude;
    property Longitude: Double read FLongitude write FLongitude;
  end;

implementation

end.
