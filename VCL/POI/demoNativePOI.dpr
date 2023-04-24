program demoNativePOI;

uses
  
  Forms,
  UMainNativePOI in 'UMainNativePOI.pas' {FormNativePoi};

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TFormNativePoi, FormNativePoi);
  Application.Run;
end.
