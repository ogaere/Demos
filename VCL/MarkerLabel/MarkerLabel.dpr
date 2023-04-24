program MarkerLabel;

uses
  Vcl.Forms,
  UMarkerLabel in 'UMarkerLabel.pas' {Form27};

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TForm27, Form27);
  Application.Run;
end.
