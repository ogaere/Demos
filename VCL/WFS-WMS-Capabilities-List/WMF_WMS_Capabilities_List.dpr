program WMF_WMS_Capabilities_List;

uses
  Vcl.Forms,
  Umain in 'Umain.pas' {FormWFS_WMS};

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TFormWFS_WMS, FormWFS_WMS);
  Application.Run;
end.
