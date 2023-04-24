program MapArchiveCreator;

uses
  System.StartUpCopy,
  FMX.Forms,
  UMapArchiveCreator in 'UMapArchiveCreator.pas' {Form10};

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TForm10, Form10);
  Application.Run;
end.
