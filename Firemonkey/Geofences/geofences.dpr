program geofences;

uses
  System.StartUpCopy,
  FMX.Forms,
  Umain in 'Umain.pas' {Form15};

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TForm15, Form15);
  Application.Run;
end.
