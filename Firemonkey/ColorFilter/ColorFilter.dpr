program ColorFilter;

uses
  System.StartUpCopy,
  FMX.Forms,
  UColorFilter in 'UColorFilter.pas' {Form18};

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TForm18, Form18);
  Application.Run;
end.
