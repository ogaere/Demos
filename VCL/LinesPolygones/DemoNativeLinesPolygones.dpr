program DemoNativeLinesPolygones;

uses
  Forms,
  UMainNativeLinesPolygones in 'UMainNativeLinesPolygones.pas' {FormNativeLinePolygone};

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TFormNativeLinePolygone, FormNativeLinePolygone);
  Application.Run;
end.
