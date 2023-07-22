unit UFrmMain;

interface

uses
  System.SysUtils, System.Classes, JS, Web, WEBLib.Graphics, WEBLib.Controls,
  WEBLib.Forms, WEBLib.Dialogs, Vcl.StdCtrls, WEBLib.StdCtrls, Vcl.Controls,
  UWeatherServiceManager, WEBLib.ExtCtrls, DB, WEBLib.Grids;

type
  TFrmMain = class(TWebForm)
    Icon: TWebImageControl;
    txtDescription: TWebLabel;
    txtLocationText: TWebLabel;
    txtLocationNumbers: TWebLabel;
    Grid: TWebTableControl;
    procedure WebFormCreate(Sender: TObject);
  private
    FService: TWeatherServiceManager;

    procedure OnLocationUpdated( Sender: TObject );
    procedure OnForecastUpdated( Sender: TObject );

    function OnLineStatus: String;

  public
    procedure UpdateForecast;
    procedure UpdateLocation;
  end;

var
  FrmMain: TFrmMain;

implementation

uses

  UWeatherServiceTypes
  ;

{$R *.dfm}

procedure TFrmMain.OnForecastUpdated(Sender: TObject);
var
  LForecast: TWeatherForecast;

begin
  console.log('Updated UI.');

  LForecast := FService.CurrentForecast;
  Icon.URL := LForecast.IconUrl;

  txtDescription.Caption := LForecast.Description;
  txtLocationText.Caption :=
    FService.Location.Name + ', ' +
    FService.Location.Country;

  txtLocationNumbers.Caption := Format(
    '(Lat: %.2f, Lon: %.2f)',
    [
      FService.Location.Latitude,
      FService.Location.Longitude
    ] );

  Grid.Cells[ 0, 0 ] := 'Forecast for';
  Grid.Cells[ 1, 0 ] := LForecast.DtReadable;

  Grid.Cells[ 0, 1 ] := 'Temperature';
  Grid.Cells[ 1, 1 ] := LForecast.Temperature.ToString + ' C';

  Grid.Cells[ 0, 2 ] := 'Humidity';
  Grid.Cells[ 1, 2 ] := LForecast.Humidity.ToString + '%';

  Grid.Cells[ 0, 3 ] := '% of Precipation';
  Grid.Cells[ 1, 3 ] := LForecast.PropPrec.ToString + '%';


end;

function TFrmMain.OnLineStatus: String;
begin
  if Application.IsOnline then
  begin
    Result := 'online';
  end
  else
  begin
    Result := 'offline';
  end;
end;

procedure TFrmMain.OnLocationUpdated(Sender: TObject);
begin
  UpdateForecast;
end;

procedure TFrmMain.UpdateForecast;
begin
  if Application.IsOnline then
  begin
    FService.UpdateForecast;
  end;
end;

procedure TFrmMain.UpdateLocation;
begin
  if Application.IsOnline then
  begin
    FService.UpdateLocation;
  end;
end;

procedure TFrmMain.WebFormCreate(Sender: TObject);
begin
  FService := TWeatherServiceManager.Create(self);
  FService.OnLocationUpdated := OnLocationUpdated;
  FService.OnForecastUpdated := OnForecastUpdated;

  FService.LoadLastForecastResponse;

  UpdateLocation;
end;

end.
