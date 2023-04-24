program DemoNativeRoute;

uses
  Forms,
  UMainNativeRoute in 'UMainNativeRoute.pas' {FDemoNativeRoute};

{$R *.RES}

begin
  Application.Initialize;
  Application.CreateForm(TFDemoNativeRoute, FDemoNativeRoute);
  Application.Run;
end.
