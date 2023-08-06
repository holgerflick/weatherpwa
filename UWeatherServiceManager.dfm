object WeatherServiceManager: TWeatherServiceManager
  OnCreate = WebDataModuleCreate
  OnDestroy = WebDataModuleDestroy
  Height = 196
  Width = 163
  object Geocoder: TWebGeoLocation
    OnGeolocation = GeocoderGeolocation
    Left = 72
    Top = 32
  end
  object Request: TWebHttpRequest
    ResponseType = rtJSON
    Left = 72
    Top = 104
  end
end
