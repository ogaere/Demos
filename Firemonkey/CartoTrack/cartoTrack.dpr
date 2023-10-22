program CartoTrack;

uses
  System.StartUpCopy,
  FMX.Forms,
  UCartoTracks in 'UCartoTracks.pas' {Form2};

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TForm2, Form2);
  Application.Run;
end.
