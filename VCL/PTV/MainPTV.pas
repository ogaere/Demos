unit MainPTV;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants,
  System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.ComCtrls, uecNativeMapControl,
  Vcl.StdCtrls,
  uecnativeshape, uecmaputil, Vcl.ExtCtrls;

type
  TPTVForm = class(TForm)
    PageControl1: TPageControl;
    Map: TECNativeMap;
    TabSheet1: TTabSheet;
    TabSheet2: TTabSheet;
    Label15: TLabel;
    basemaplayer: TComboBox;
    GroupBox2: TGroupBox;
    Labels: TCheckBox;
    Trafficincidents: TCheckBox;
    TrafficPatterns: TCheckBox;
    Transport: TCheckBox;
    Background: TCheckBox;
    Restrictions: TCheckBox;
    Toll: TCheckBox;
    Overlays: TGroupBox;
    OLabels: TCheckBox;
    OTrafficIncidents: TCheckBox;
    OTrafficPatterns: TCheckBox;
    OTransport: TCheckBox;
    ORestrictions: TCheckBox;
    OToll: TCheckBox;
    StartRoute: TEdit;
    EndRoute: TEdit;
    AddRoute: TButton;
    vehicle: TComboBox;
    Panel1: TPanel;
    itinerary: TListBox;
    InfoRoute: TMemo;
    procedure basemaplayerChange(Sender: TObject);
    procedure LabelsClick(Sender: TObject);
    procedure OLabelsClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure AddRouteClick(Sender: TObject);
    procedure Panel1Resize(Sender: TObject);
    procedure itineraryClick(Sender: TObject);

  private
    { Déclarations privées }
    procedure doOnAddRoute(Sender: TECShapeLine; const params: string);
    procedure doOnSelectedItinerarySegment(Sender: TECItinerary);
    procedure ShowInfoRoute(const route: TECShapeLine);
    procedure doChangeRoute(Sender: TObject);
    procedure SelectSegment(const index: integer);
  public
    { Déclarations publiques }

  end;

var
  PTVForm: TPTVForm;

implementation

{$R *.dfm}

procedure TPTVForm.FormCreate(Sender: TObject);
begin
  // see https://developer.myptv.com/en/documentation
  Map.PTV.ApiKey := 'YOUR API KEY HERE';
  
  Map.Routing.Engine(rePTV);
  Map.Routing.OnAddRoute := doOnAddRoute;

  Map.Routing.itinerary.OnSelectedItinerarySegment :=
    doOnSelectedItinerarySegment;

  Map.Routing.Itinerary.OnChangeRoute := doChangeRoute;


end;

// request new route
procedure TPTVForm.AddRouteClick(Sender: TObject);
begin

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

// build route planner and route infos
procedure TPTVForm.ShowInfoRoute(const route: TECShapeLine);
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

  InfoRoute.Lines.Clear;

  InfoRoute.Lines.Add('Distance : ' + DoubleToStrDigit(route.distance,
    2) + ' km');
  InfoRoute.Lines.Add('Time : ' + SecondeToTimeStr(route.duration));
  InfoRoute.Lines.Add('violated : ' + route['violated'] + #13#10);
  InfoRoute.Lines.Add(route['toll'] + #13#10);
  InfoRoute.Lines.Add(route['monetaryCosts']);

end;

// event triggered when the route has been calculated and is available
procedure TPTVForm.doOnAddRoute(Sender: TECShapeLine; const params: string);
begin

  Sender.distance;
  Sender.Focusable := false;
  Sender.Color := GetRandomColor;
  // show all road
  Sender.fitBounds;
  ShowInfoRoute(Sender);
end;

// click on route planner
procedure TPTVForm.itineraryClick(Sender: TObject);
begin
  SelectSegment(itinerary.ItemIndex);
end;

// click on route
procedure TPTVForm.doOnSelectedItinerarySegment(Sender: TECItinerary);
begin
  SelectSegment(Sender.SegmentIndex);
end;

// click on another route
procedure TPTVForm.doChangeRoute(Sender: TObject);
begin
  ShowInfoRoute(Sender as TECShapeLine);
end;



procedure TPTVForm.SelectSegment(const index: integer);
var
  selected_route, selected_segment: TECShapeLine;
begin

  if index < 0 then
    exit;

  itinerary.ItemIndex := Index;

  Map.Routing.itinerary.SegmentIndex := index;

  selected_route := Map.Routing.itinerary.route;
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

// map ptv

procedure TPTVForm.basemaplayerChange(Sender: TObject);
begin
  case basemaplayer.ItemIndex of
    0:
      Map.PTV.basemaplayer := TPTVBaseMapLayer.sandbox;
    1:
      Map.PTV.basemaplayer := TPTVBaseMapLayer.classic;
    2:
      Map.PTV.basemaplayer := TPTVBaseMapLayer.silkysand;
    3:
      Map.PTV.basemaplayer := TPTVBaseMapLayer.amber;
    4:
      Map.PTV.basemaplayer := TPTVBaseMapLayer.blackmarble;
    5:
      Map.PTV.basemaplayer := TPTVBaseMapLayer.gravelpit;
    6:
      Map.PTV.basemaplayer := TPTVBaseMapLayer.silica;
    7:
      Map.PTV.basemaplayer := TPTVBaseMapLayer.satellite;
    8:
      begin
        Map.PTV.basemaplayer := TPTVBaseMapLayer.none;

        // clear foregroung layers
        Labels.Checked := false;
        Background.Checked := false;
        Transport.Checked := false;
        Trafficincidents.Checked := false;
        TrafficPatterns.Checked := false;
        Restrictions.Checked := false;
        Toll.Checked := false;
        Map.PTV.ForegroundLayers := [];
      end;
  end;
end;

procedure TPTVForm.LabelsClick(Sender: TObject);
var
  fl: TPTVForegroundLayers;
begin

  fl := [];

  if Labels.Checked then
    fl := fl + [TPTVForegroundLayer.Labels];

  if Background.Checked then
    fl := fl + [TPTVForegroundLayer.Background];

  if Transport.Checked then
    fl := fl + [TPTVForegroundLayer.Transport];

  if Trafficincidents.Checked then
    fl := fl + [TPTVForegroundLayer.Trafficincidents];

  if TrafficPatterns.Checked then
    fl := fl + [TPTVForegroundLayer.TrafficPatterns];

  if Restrictions.Checked then
    fl := fl + [TPTVForegroundLayer.Restrictions];

  if Toll.Checked then
    fl := fl + [TPTVForegroundLayer.Toll];

  Map.PTV.ForegroundLayers := fl;

end;

procedure TPTVForm.OLabelsClick(Sender: TObject);
var
  fl: TPTVForegroundLayers;
begin

  fl := [];

  if OLabels.Checked then
    fl := fl + [TPTVForegroundLayer.Labels];

  if OTransport.Checked then
    fl := fl + [TPTVForegroundLayer.Transport];

  if OTrafficIncidents.Checked then
    fl := fl + [TPTVForegroundLayer.Trafficincidents];

  if OTrafficPatterns.Checked then
    fl := fl + [TPTVForegroundLayer.TrafficPatterns];

  if ORestrictions.Checked then
    fl := fl + [TPTVForegroundLayer.Restrictions];

  if OToll.Checked then
    fl := fl + [TPTVForegroundLayer.Toll];

  Map.PTV.OverlayLayers := fl;
end;

procedure TPTVForm.Panel1Resize(Sender: TObject);
begin
  InfoRoute.Width := Panel1.Width div 2;
end;

end.
