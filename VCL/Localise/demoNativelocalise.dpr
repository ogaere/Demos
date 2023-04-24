program demonativelocalise;

uses
  sysutils,
  Forms,
  UDemonativeLocalise in 'UDemoNativeLocalise.pas' {FDemoNativeLocalise};

{$R *.RES}

begin
  Application.Initialize;
  Application.CreateForm(TFDemonativeLocalise, FDemonativeLocalise);
  Application.Run;
end.
