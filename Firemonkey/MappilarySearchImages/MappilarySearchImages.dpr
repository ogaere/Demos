program MappilarySearchImages;

uses
  System.StartUpCopy,
  FMX.Forms,
  UMappilarySearchImages in 'UMappilarySearchImages.pas' {FormMappilarySearchImages};

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TFormMappilarySearchImages, FormMappilarySearchImages);
  Application.Run;
end.
