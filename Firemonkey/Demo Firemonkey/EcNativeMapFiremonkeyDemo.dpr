program EcNativeMapFiremonkeyDemo;
uses
 {$IFDEF DEBUG}
 //LeakCheck ,
 {$ENDIF}
  FMX.Forms, FMX.types,
  Umain1 in 'Umain1.pas';
 // FMX.uecNativeMiniMap in '..\..\FMX.uecNativeMiniMap.pas';

{$R *.res}

begin
 {$IFDEF DEBUG}
  ReportMemoryLeaksOnShutDown :=true;
 {$ENDIF}

  Application.Initialize;

  Application.CreateForm(TForm1, Form1);
  Application.Run;
end.
