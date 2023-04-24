program DemoSelectArea;

uses
  Vcl.Forms,
  UMain in 'UMain.pas' {FSelectArea};

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TFSelectArea, FSelectArea);
  Application.Run;
end.
