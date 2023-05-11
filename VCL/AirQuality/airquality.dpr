program airquality;

uses
  Vcl.Forms,
  UMain in 'UMain.pas' {FormAirQuality};

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TFormAirQuality, FormAirQuality);
  Application.Run;
end.
