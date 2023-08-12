unit MainItinerary;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, uecNativeMapControl,uecnativeshape, uecmaputil,Vcl.StdCtrls, Vcl.ExtCtrls;

type
  TItineraryForm = class(TForm)
    menu: TPanel;
    map: TECNativeMap;
    StartRoute: TEdit;
    EndRoute: TEdit;
    AddRoute: TButton;
    vehicle: TComboBox;
    itinerary: TListBox;
    engine: TComboBox;
    Clear: TButton;
    procedure FormCreate(Sender: TObject);
    procedure itineraryClick(Sender: TObject);
    procedure AddRouteClick(Sender: TObject);
    procedure ClearClick(Sender: TObject);
  private
    { Déclarations privées }
    procedure doOnAddRoute(Sender: TECShapeLine; const params: string);
    procedure doOnSelectedItinerarySegment(Sender: TECItinerary);
    procedure BuildItinerary(const route: TECShapeLine);
    procedure doChangeRoute(Sender: TObject);
    procedure SelectSegment(const index: integer);
  public
    { Déclarations publiques }
  end;

var
  ItineraryForm: TItineraryForm;

implementation

{$R *.dfm}

procedure TItineraryForm.FormCreate(Sender: TObject);
begin

  Map.Routing.OnAddRoute := doOnAddRoute;

  Map.Routing.itinerary.OnSelectedItinerarySegment :=
    doOnSelectedItinerarySegment;

  Map.Routing.Itinerary.OnChangeRoute := doChangeRoute;

end;



// request new route
procedure TItineraryForm.AddRouteClick(Sender: TObject);
begin

 // select engine routing

  case engine.ItemIndex of
    0 : map.Routing.Engine(reOpenStreetMap);
    1 : map.Routing.Engine(reValhalla);
  end;

 // select route type

 case vehicle.ItemIndex of
    0:
      Map.Routing.routeType := rtPedestrian;
    1:
      Map.Routing.routeType := rtBicycle;
    2:
      Map.Routing.routeType := rtCar;
    3:
      Map.Routing.routeType := rtTruck;
  end;

  Map.Routing.Request(StartRoute.Text, EndRoute.Text);
end;



// event triggered when the route has been calculated and is available
procedure TItineraryForm.doOnAddRoute(Sender: TECShapeLine; const params: string);
begin
  Sender.Focusable := false;
  Sender.Color := GetRandomColor;
  // show all road
  Sender.fitBounds;

  BuildItinerary(Sender);
end;



// build route planner
procedure TItineraryForm.BuildItinerary(const route: TECShapeLine);
var
  i: integer;
  d: double;
  distance: string;
begin
  Map.Routing.itinerary.route := route;

  itinerary.Items.Clear;

  itinerary.Items.BeginUpdate;

  for i := 0 to Map.Routing.itinerary.Count - 1 do
  begin

    // calculate distance
    d := Map.Routing.itinerary[i].Distancekm;

    if d < 1  then
     distance := inttostr(round(d * 1000)) + 'm'
     else
      distance := DoubleToStrDigit(d, 2) + 'km' ;

    itinerary.Items.Add(Map.Routing.itinerary[i].Instruction + ' (' +
      distance + ')');


  end;

  itinerary.Items.EndUpdate;

  itinerary.ItemIndex :=  Map.Routing.itinerary.SegmentIndex;


end;


// click on route planner
procedure TItineraryForm.itineraryClick(Sender: TObject);
begin
  SelectSegment(itinerary.ItemIndex);
end;



// Triggered by Click on Map.Routing.itinerary.route
procedure TItineraryForm.doOnSelectedItinerarySegment(Sender: TECItinerary);
begin
  SelectSegment(Sender.SegmentIndex);
end;



// Triggered by Click of a route <> Map.Routing.itinerary.route
procedure TItineraryForm.doChangeRoute(Sender: TObject);
begin
  BuildItinerary(Sender as TECShapeLine)
end;



procedure TItineraryForm.SelectSegment(const index: integer);
var selected_segment: TECShapeLine;
begin

  if index < 0 then
    exit;

  itinerary.ItemIndex := Index;

  Map.Routing.itinerary.SegmentIndex := index;

  selected_segment := Map.Routing.itinerary.SegmentRoute;

  if not assigned(Map.Routing.itinerary.SegmentRoute) then
    exit;

  // move map for show segment
  Map.Routing.itinerary.ShowSegment(index);

  // you can also change color of selected_segment here

  // Flash the segment 20 times per 250 ms period
  // the animation will be automatically released when required
  selected_segment.animation := TECAnimationShapeColor.create(20);
  selected_segment.animation.Timing := 250;

  // show infowindow with segment instruction
  Map.Routing.itinerary.ShowInstruction(index);

end;


procedure TItineraryForm.ClearClick(Sender: TObject);
begin
 map.Clear;
 itinerary.Items.Clear;
end;

end.
