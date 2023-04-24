program cartoTrack;

uses
  System.StartUpCopy,
  FMX.Forms,
  UCartoTrack in 'UCartoTrack.pas' {Form16};

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TForm3, Form3);
  Application.Run;
end.
