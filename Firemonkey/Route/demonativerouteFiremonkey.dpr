program demonativerouteFiremonkey;

uses
  System.StartUpCopy,
  FMX.Forms,
  UMainRoute in 'UMainRoute.pas' {FDemoNativeRoute};

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TFDemoNativeRoute, FDemoNativeRoute);
  Application.Run;
end.
