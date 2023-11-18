program MeasureTool;

uses
  Vcl.Forms,
  UMain in 'UMain.pas' {FormMeasureTool};

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TFormMeasureTool, FormMeasureTool);
  Application.Run;
end.
