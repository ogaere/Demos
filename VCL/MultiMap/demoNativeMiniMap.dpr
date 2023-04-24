program demoNativeMiniMap;

uses
 
  Forms,
  UMainNativeMiniMap in 'UMainNativeMiniMap.pas' {FormNativeMiniMap};

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TFormNativeMiniMap, FormNativeMiniMap);
  Application.Run;
end.
