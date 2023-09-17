program googleMaps;

uses
  Vcl.Forms,
  umain in 'umain.pas' {FormGoogle};

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TFormGoogle, FormGoogle);
  Application.Run;
end.
