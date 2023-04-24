program BoundaryArea;

uses
  System.StartUpCopy,
  FMX.Forms,
  UnitBoundaryArea in 'UnitBoundaryArea.pas' {Form12};

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TForm12, Form12);
  Application.Run;
end.
