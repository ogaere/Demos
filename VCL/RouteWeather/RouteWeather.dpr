program RouteWeather;

uses
  Vcl.Forms,
  URouteWeather in 'URouteWeather.pas' {Form6};

{$R *.res}

begin

  {$IFDEF DEBUG}
  ReportMemoryLeaksOnShutDown :=true;
 {$ENDIF}

  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TForm6, Form6);
  Application.Run;
end.
