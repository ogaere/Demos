program overpass;

uses
  FMX.Forms,
  UMainOverPass in 'UMainOverPass.pas' {FormOverPass};

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TFormOverPass, FormOverPass);
  Application.Run;
end.
