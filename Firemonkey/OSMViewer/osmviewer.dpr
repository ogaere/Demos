program osmviewer;

uses
  System.StartUpCopy,
  FMX.Forms, fmx.types,
  Uosmviewer in 'Uosmviewer.pas' {Form2},
  UDialogMapOlt in 'UDialogMapOlt.pas' {FDialogMapOrOlt};

{$R *.res}

begin
  {$IFDEF DEBUG}
  ReportMemoryLeaksOnShutDown :=true;
 {$ENDIF}

 // FMX.Types.GlobalUseGPUCanvas := True;

  Application.Initialize;
  Application.CreateForm(TForm2, Form2);
  Application.CreateForm(TFDialogMapOrOlt, FDialogMapOrOlt);
  Application.Run;
end.
