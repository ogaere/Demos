program ChartLayer;

uses
  Vcl.Forms,
  UMain in 'UMain.pas' {FormChartLayer};

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TFormChartLayer, FormChartLayer);
  Application.Run;
end.
