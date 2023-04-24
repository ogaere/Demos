program mapillary4;

uses
  Vcl.Forms,
  Umapillary4 in 'Umapillary4.pas' {Form30};

{$R *.res}

begin
  {$IFDEF DEBUG}
  ReportMemoryLeaksOnShutDown :=true;
 {$ENDIF}
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TForm30, Form30);
  Application.Run;
end.
