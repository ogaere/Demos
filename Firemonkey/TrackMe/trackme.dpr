program trackme;

uses
  System.StartUpCopy,
  FMX.Forms,
  umaintrack in 'umaintrack.pas' {FormTrack};

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TFormTrack, FormTrack);
  Application.Run;
end.
