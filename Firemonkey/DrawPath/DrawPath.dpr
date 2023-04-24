program DrawPath;

uses
  System.StartUpCopy,
  FMX.Forms,
  UDrawPath in 'UDrawPath.pas' {Form7};

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TForm7, Form7);
  Application.Run;
end.
