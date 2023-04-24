program heatmap;

uses
  System.StartUpCopy,
  FMX.Forms,
  UHeatmap in 'UHeatmap.pas' {Form17};

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TForm17, Form17);
  Application.Run;
end.
