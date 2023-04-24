program keyboard;

uses
  System.StartUpCopy,
  FMX.Forms,
  UKeyboard in 'UKeyboard.pas' {Form13};

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TForm13, Form13);
  Application.Run;
end.
