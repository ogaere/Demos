program cvsdemo;

uses
  Forms,
  UCVS in 'UCVS.pas' {Form29};

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TForm29, Form29);
  Application.Run;
end.
