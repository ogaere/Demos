program Itinerary;

uses
  Vcl.Forms,
  MainItinerary in 'MainItinerary.pas' {ItineraryForm};

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TItineraryForm, ItineraryForm);
  Application.Run;
end.
