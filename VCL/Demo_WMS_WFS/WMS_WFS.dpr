program WMS_WFS;

uses
  Vcl.Forms,
  UMain in 'UMain.pas' {FormWMS_WFS};

{$R *.res}

begin
  ReportMemoryLeaksOnShutdown := True;
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TFormWMS_WFS, FormWMS_WFS);
  Application.Run;
end.
