unit UFrmMain;

interface

uses
  System.SysUtils, System.Classes, JS, Web, WEBLib.Graphics, WEBLib.Controls,
  WEBLib.Forms, WEBLib.Dialogs, Vcl.StdCtrls, WEBLib.StdCtrls, Vcl.Controls,
  UWeatherServiceManager, WEBLib.ExtCtrls;

type
  TFrmMain = class(TWebForm)
    btnGetCurrent: TWebButton;
    txtCurrent: TWebEdit;
    Icon: TWebImageControl;
    procedure WebFormCreate(Sender: TObject);
  private
    { Private declarations }
    FService: TWeatherServiceManager;

    procedure OnLocationUpdated( Sender: TObject );
    procedure OnForecastUpdated( Sender: TObject );

  public
    { Public declarations }
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
  txtCurrent.Text := LForecast.Description;
  Icon.URL := LForecast.IconUrl;
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
  end
  else
  begin
    txtCurrent.Text := 'offline';
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
