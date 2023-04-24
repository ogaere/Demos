program SnapeDrag;

uses
  System.StartUpCopy,
  FMX.Forms,
  UMainSnapeDrag in 'UMainSnapeDrag.pas' {Form11};

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TForm11, Form11);
  Application.Run;
end.
