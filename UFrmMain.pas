unit UFrmMain;

interface

uses
  System.SysUtils, System.Classes, JS, Web, WEBLib.Graphics, WEBLib.Controls,
  WEBLib.Forms, WEBLib.Dialogs, Vcl.StdCtrls, WEBLib.StdCtrls, Vcl.Controls,
  UWeatherServiceManager;

type
  TFrmMain = class(TWebForm)
    btnGetCurrent: TWebButton;
    txtCurrent: TWebEdit;
    procedure WebFormCreate(Sender: TObject);
  private
    { Private declarations }
    FService: TWeatherServiceManager;

  public
    { Public declarations }
  end;

var
  FrmMain: TFrmMain;

implementation

{$R *.dfm}

procedure TFrmMain.WebFormCreate(Sender: TObject);
begin
  FService := TWeatherServiceManager.Create(self);
end;

end.
