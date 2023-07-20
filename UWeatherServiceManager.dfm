object WeatherServiceManager: TWeatherServiceManager
  OnCreate = WebDataModuleCreate
  OnDestroy = WebDataModuleDestroy
  Height = 229
  Width = 394
  object Geocoder: TWebGeoLocation
    OnGeolocation = GeocoderGeolocation
    Left = 80
    Top = 96
  end
  object Request: TWebHttpRequest
    ResponseType = rtJSON
    Left = 176
    Top = 96
  end
end
