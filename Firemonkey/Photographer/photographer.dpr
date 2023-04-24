program photographer;

uses
  System.StartUpCopy,
  FMX.Forms,
  UPhotographer in 'UPhotographer.pas' {Form2};

{$R *.res}

begin
  {$IFDEF DEBUG}
  ReportMemoryLeaksOnShutDown :=true;
 {$ENDIF}
  Application.Initialize;
  Application.CreateForm(TForm2, Form2);
  Application.Run;
end.
