program WeatherPWA;

{$R *.dres}

uses
  Vcl.Forms,
  WEBLib.Forms,
  UFrmMain in 'UFrmMain.pas' {FrmMain: TWebForm} {*.html},
  UWeatherServiceManager in 'UWeatherServiceManager.pas' {WeatherServiceManager: TWebDataModule},
  UWeatherServiceTypes in 'UWeatherServiceTypes.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TFrmMain, FrmMain);
  Application.Run;
end.
