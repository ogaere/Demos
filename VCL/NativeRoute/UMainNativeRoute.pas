unit UMainNativeRoute;
// {$I Delphi_Versions.inc}

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, Spin, Buttons, ExtCtrls, OleCtrls,
  ComCtrls, ShDocVw, MSHTML,
  uecNativeMapControl,
  uecGeoLocalise, activex, uecNativeshape,
  uecgraphics,
  UECMapUtil;

type
  TFDemoNativeRoute = class(TForm)
    PanelStartEnd: TPanel;
    cbStart: TComboBox;
    lbstart: TLabel;
    Label1: TLabel;
    cbDestination: TComboBox;
    Panel2: TPanel;
    RouteAdd: TButton;
    Colordialog: TColorDialog;
    Panel1: TPanel;
    routes: TComboBox;
    rbDriving: TRadioButton;
    rbBicycle: TRadioButton;
    rbWalking: TRadioButton;
    Panel7: TPanel;

    NextInstruction: TPanel;
    NextKM: TPanel;
    Instructions: TPanel;
    Follow: TCheckBox;
    infos: TPanel;
    map: TECNativeMap;
    itinerary: TListBox;

    procedure RouteAddClick(Sender: TObject);

    procedure routesChange(Sender: TObject);


    procedure cbStartChange(Sender: TObject);
    procedure FormCreate(Sender: TObject);
 

    procedure rbDrivingClick(Sender: TObject);
    procedure itineraryClick(Sender: TObject);


  private
    { Déclarations privées }


    procedure BuildItinerary(const route: TECShapeLine);


    procedure doOnErrorRoute(Sender: TObject; const dataroute:TECThreadDataRoute);
    procedure doOnAddRoute(Sender: TECShapeLine; const params: string);
    procedure doOnChangeRoute(Sender: TECShapeLine; const params: string);

    procedure doOnTurnByTurnAlert(Sender: TECTurnByTurn;
      const Instruction: string; const Distance: double);

    procedure doOnTurnByTurnInstruction(Sender: TECTurnByTurn;
      const Instruction: string; const Distance: double);

    procedure doOnTurnByTurnArrival(Sender: TObject);

    procedure doOnTurnByTurnError(Sender: TECTurnByTurn; const Lat, Lng: double;
      const ErrorCounter: integer);

    procedure doOnDeconnectTurnByTurn(Sender: TObject);

    procedure doShowDataRoute(const id: integer);

    procedure doEndAnimationMove(Sender: TObject);
    procedure doOnMoveMobile(Sender: TObject; const Item: TECShape;
      var cancel: boolean);
    procedure doOnClickMobile(Sender: TObject; const Item: TECShape);
    procedure OnOffTracking(const Item: TECShape);

  public
    { Déclarations publiques }
  end;

var
  FDemoNativeRoute: TFDemoNativeRoute;

implementation

{$R *.DFM}


procedure TFDemoNativeRoute.FormCreate(Sender: TObject);
begin

  cbStart.tag := -1;
  cbDestination.tag := -1;

  // We'll use a label to display information about the mobile
  // that activates the turn-by-turn function.
  // by default Description property will be displayed
  map.shapes.Pois.Labels.Visible := true;
  map.Shapes.Pois.Labels.Align   := laTop;

  // setup cache for tiles, routing
  map.LocalCache := extractfilepath(application.exename) + 'cache';

  // setup routing

  map.Routing.OnAddRoute    := doOnAddRoute;
  map.Routing.OnErrorRoute  := doOnErrorRoute;
  map.Routing.OnChangeRoute := doOnChangeRoute;

  map.Routing.RouteType     := rtCar;
  map.Routing.weight        := 5;

  // connect events for turn by turn navigation
  map.Routing.TurnByTurn.OnAlert            := doOnTurnByTurnAlert;
  map.Routing.TurnByTurn.OnInstruction      := doOnTurnByTurnInstruction;
  map.Routing.TurnByTurn.OnAfterInstruction := doOnTurnByTurnInstruction;
  map.Routing.TurnByTurn.OnArrival          := doOnTurnByTurnArrival;
  map.Routing.TurnByTurn.OnError            := doOnTurnByTurnError;
  map.Routing.TurnByTurn.OnDeconnectRoute   := doOnDeconnectTurnByTurn;

  // by default, interactive route editing is activated by clicking on it
  // map.Routing.editOnClick := false;




end;


// Move the mobile to the start of a route segment.
procedure TFDemoNativeRoute.itineraryClick(Sender: TObject);
var StartSegment : TLatLng;
    Mobile       : TECShapePOI;
    Distance     : double;
    index        : integer;
    FakeLat,FakeLng : double;
begin
 if (itinerary.tag = map.Routing.TurnByTurn.Line.id) then
  begin
   if (map.Routing.TurnByTurn.Line.item is TECShapePOI) and (itinerary.itemindex>-1)and(itinerary.itemindex<map.Routing.Itinerary.count) then
  begin
    Mobile       := TECShapePOI(map.Routing.TurnByTurn.Line.item);

    if Mobile.Animation is TECAnimationMoveOnPath then
    begin

      StartSegment :=  map.Routing.Itinerary.Segment[itinerary.itemindex].PointA;
      // Get the index of the point closest to the coordinates
      Index := map.Routing.TurnByTurn.Line.IndexAndPositionOfNearestPointTo(StartSegment.Lat,StartSegment.Lng,fakeLat,FakeLng);
      // Distance in kilometers from start to this point
      Distance := map.Routing.TurnByTurn.Line.DistanceToIndexPoint(index);
      // Animation expects distance in meters
      TECAnimationMoveOnPath(Mobile.Animation).Distance := round(Distance * 1000);


    end;
  end;

  end;
end;

{ *
  Add new route
}
procedure TFDemoNativeRoute.RouteAddClick(Sender: TObject);
var
  title: string;
  RouteType: TMQRouteType;
begin

  if rbWalking.checked then
    RouteType := rtPedestrian
  else if rbBicycle.checked then
    RouteType := rtBicycle
  else
    RouteType := rtCar;

  RouteAdd.enabled := false;

  map.Routing.Request(cbStart.Text, cbDestination.Text);

  title := cbStart.Text + ' > ' + cbDestination.Text + ' > ' +
    rtToStr(RouteType);

  routes.items.add(title);

end;


// routing events


// route not created !
procedure TFDemoNativeRoute.doOnErrorRoute(Sender: TObject;
  const dataroute:TECThreadDataRoute);
begin
  RouteAdd.enabled := true;

  ShowMessage('Route not found !' + #13#10 + 'Try this format:' + #13#10 +
    #13#10 + 'Street, Town, Country');
end;

// route is ok
//
// a mobile shape is added to simulate a vehicle which moves
procedure TFDemoNativeRoute.doOnAddRoute(Sender: TECShapeLine;
  const params: string);
var
  moving   : TECAnimationMoveOnPath;
  mobile   : TECShapePOI;
  speed    : integer;
  i        : integer;
begin


  Sender.Color := GetHashColor(params);
  Sender.BorderSize := 5;
  Sender.BorderColor := GetShadowColorBy(Sender.color, 32);
  Sender.HoverBorderColor := Sender.BorderColor;
  Sender.HoverColor := GetHighLightColorBy(Sender.color, 32);
  
  sender.ShowText := false;

  RouteAdd.enabled := true;


  case map.Routing.RouteType of
    
    rtPedestrian: speed := 10;
    rtBicycle: speed := 30;
    else speed := 90;
  end;
  
  // Create an animation to move a triangle along the road
  //
  // starting from km 0
  // speed in km / h
  moving := TECAnimationMoveOnPath.create(Sender, 0, speed);

  // create mobile

  mobile := map.AddPOI(0,0);

  mobile.POIShape := poiArrowHead;
  mobile.width := 18;
  mobile.height := 24;
  mobile.color := GetShadowColorBy(Sender.color, 32);
  mobile.item  := Sender;

  // find arrival instruction
  i := sender.Count-1;
  while (mobile.Hint='') and (i>0) do
  begin
   mobile.Hint := sender.Path[i].Text;
   dec(i);
  end;


  // we want react when the mobile moves (to follow and to turn by turn)
  mobile.OnShapeMove  := doOnMoveMobile;

  mobile.OnShapeClick := doOnClickMobile;

  // we keep a reference on our mobile to find it from a reference to a route
  Sender.Item := mobile;


  mobile.animation := moving;


  // event fired when arrived
  moving.OnDriveUp := doEndAnimationMove;

  // start animation
  moving.stop := false;

  // directing the tip of the mobile in the direction of travel
  moving.heading := true;

  doShowDataRoute(Sender.indexof);

end;


// the event is triggered when the route is recalculated
procedure TFDemoNativeRoute.doOnChangeRoute(Sender: TECShapeLine;
  const params: string);
begin
  if not assigned(Sender) then
    exit;


  infos.Caption := doubleToStrDigit(Sender.Distance, 2) + 'km - ' +
                   SecondeToTimeStr(sender.duration);

   if  (Sender.Item is TECShapePoi) and
       assigned(TECShapePoi(Sender.Item).animation) and
       assigned(TECShapePoi(Sender.Item).animation.animations)  then
     begin

      // Connect the road on which the triangle is animated, has the turn by turn navigation
       map.Routing.TurnByTurn.Line := Sender;

       BuildItinerary(Sender);

     end;
end;


// fired when click triangle
// activate auto tracking
procedure TFDemoNativeRoute.doOnClickMobile(Sender: TObject;
  const Item: TECShape);
begin
  // Connect the road on which the triangle is animated, has the turn by turn navigation
  routes.ItemIndex := TECShapeLine(Item.item).id;
  doShowDataRoute(TECShapeLine(Item.item).id);

end;

// activate / deactivate auto tracking
procedure TFDemoNativeRoute.OnOffTracking(const Item: TECShape);
var
    anim    : TECAnimationFadePoi;
begin

  if not assigned(Item) then
    exit;

  // Tracking will be signaled by a second animation added to the mobile element
  if not assigned(Item.Animation.Animations) then
  begin

    Item.Color := strToColor('#2b8cbe');
    Item.unFocus;
    Item.SaveState;

    // an animation is created by varying size and opacity
    // anim is auto free when change Animations or destroy item
    anim := TECAnimationFadePoi.create;

    anim.MaxSize   := 40;
    anim.StartSize := 24;

    // opacity don't change
    anim.StartOpacity := 0;

    Item.animation.animations := anim;

  end
  else
  // if there's already a second animation,
  // tracking has already been activated and should be deactivated.
  begin
    Item.animation.animations := nil;
    // cancel turn by turn
    map.Routing.TurnByTurn.Line := nil;
    //
    if Item.item is TECShapeLine then
    begin
      Item.color := GetShadowColorBy(TECShapeLine(Item.Item).color, 32);
      Item.unFocus;
      Item.SaveState;
    end;
  end;



end;

// fired when mobile move
procedure TFDemoNativeRoute.doOnMoveMobile(Sender: TObject;
  const Item: TECShape; var cancel: boolean);
begin


  if assigned(Item) and assigned(Item.Animation)  then
  begin

      // The turn-by-turn mobile has a double animation (movement + size change)
      if assigned(Item.Animation.Animations) then
      begin

        // Description serves as Label
        Item.Description := Item.Hint+#13#10+'in '+doubletostrdigit(TECShapeLine(Item.item).Distance-(TECAnimationMoveOnPath(Item.animation).Distance / 1000),2)+' km';


        // 500 meter around you
        if Follow.checked then
           map.fitBoundsRadius(Item.Latitude, Item.Longitude, 0.5);

        // update your position in turn by turn navigation
        map.Routing.TurnByTurn.Position(Item.Latitude, Item.Longitude);
      end
      else
      Item.Description := '';



  end;

end;

// event turn by turn

// First alert
procedure TFDemoNativeRoute.doOnTurnByTurnAlert(Sender: TECTurnByTurn;
  const Instruction: string; const Distance: double);
begin

   Instructions.Font.color := clBlack;
   Instructions.Caption := Instruction;


  if (itinerary.tag = map.Routing.TurnByTurn.Line.id) then
  begin

     itinerary.ItemIndex := itinerary.items.IndexOf(Instruction);
     itinerary.TopIndex  := itinerary.ItemIndex;

  end;


  if Distance > 0 then
    NextKM.Caption := doubleToStrDigit(Distance, 2) + 'km'
  else
    NextKM.Caption := '';
end;

// execute now
procedure TFDemoNativeRoute.doOnTurnByTurnInstruction(Sender: TECTurnByTurn;
  const Instruction: string; const Distance: double);
begin
  Instructions.Font.color := clRed;
  Instructions.Caption := Instruction;

  if Distance > 0 then
    NextKM.Caption := doubleToStrDigit(Distance, 2) + 'km'
  else
    NextKM.Caption := '';
end;

procedure TFDemoNativeRoute.doOnTurnByTurnArrival(Sender: TObject);
begin
  Instructions.Caption := 'you arrived !';
end;

procedure TFDemoNativeRoute.doOnTurnByTurnError(Sender: TECTurnByTurn;
  const Lat, Lng: double; const ErrorCounter: integer);
begin
  Instructions.Caption := 'Error, your not on the route !';
end;

procedure TFDemoNativeRoute.doOnDeconnectTurnByTurn(Sender: TObject);
begin
  Instructions.Caption := '';
  NextKM.Caption       := '';
end;


// --------------------

// go to start when arrived
procedure TFDemoNativeRoute.doEndAnimationMove(Sender: TObject);
begin
  TECAnimationMoveOnPath(TECShape(Sender).animation).Distance := 0;
  TECAnimationMoveOnPath(TECShape(Sender).animation).stop     := false;
end;

{ *
  select new route
}
procedure TFDemoNativeRoute.routesChange(Sender: TObject);
begin
  doShowDataRoute(routes.ItemIndex);
end;

{
  update the screen with the properties of the selected route
}
procedure TFDemoNativeRoute.doShowDataRoute(const id: integer);
var

  s: string;

begin

  if (id < 0) then 
    exit;


    
  s := routes.items[id];

  cbStart.Text := trim(strtoken(s, '>'));
  cbDestination.Text := trim(strtoken(s, '>'));

  case StrToRT(trim(s)) of

    rtPedestrian:
      rbWalking.checked := true;

    rtCar:
      rbDriving.checked := true;

    rtBicycle:
      rbBicycle.checked := true;
  end;

  routes.ItemIndex := id;



   //  deactivate prev vehicle tracking and turn-by-turn mode
  if assigned(map.Routing.TurnByTurn.Line) then
  begin
    // find the mobile associated with the route
    if map.Routing.TurnByTurn.Line.item is TECShapePOI then
    begin
      // The turn-by-turn mobile has a double animation (movement + size change).
      if assigned(TECShapePOI(map.Routing.TurnByTurn.Line.item).animation) and
         assigned(TECShapePOI(map.Routing.TurnByTurn.Line.item).animation.animations)
       then
        OnOffTracking(TECShapePOI(map.Routing.TurnByTurn.Line.item));

    end;
  end;



  BuildItinerary(map.shapes.lines[id]);


  
  // select this route for turn by turn navigation
  map.Routing.TurnByTurn.Line := map.shapes.lines[id];

   // activate new line vehicle tracking and turn-by-turn mode
   if map.Routing.TurnByTurn.Line.item is TECShapePOI then
    OnOffTracking(TECShapePOI(map.Routing.TurnByTurn.Line.item));

  // show route  
  map.Routing.TurnByTurn.Line.fitBounds;


  infos.Caption := doubleToStrDigit(map.shapes.lines[id].Distance, 2) + 'km - '
    + SecondeToTimeStr(map.shapes.lines[id].Duration);


end;


// build route planner
procedure TFDemoNativeRoute.BuildItinerary(const route: TECShapeLine);
var
  i: integer;
begin

  map.Routing.Itinerary.Route := route;

  itinerary.tag := route.id;

  itinerary.Items.BeginUpdate;
  itinerary.Items.Clear;

  for i := 0 to Map.Routing.itinerary.Count - 1 do
    itinerary.Items.Add(Map.Routing.itinerary[i].Instruction );


  itinerary.Items.EndUpdate;

  // disengage the route, as otherwise it cannot be edited and the itineray mode takes over,
  // but is still available
  map.Routing.Itinerary.Route := nil;


end;





procedure TFDemoNativeRoute.cbStartChange(Sender: TObject);
begin
  RouteAdd.enabled := (cbStart.Text <> '') and (cbDestination.Text <> '');
end;




procedure TFDemoNativeRoute.rbDrivingClick(Sender: TObject);
var
  title: string;
  RouteType: TMQRouteType;
begin

  if rbWalking.checked then

    RouteType := rtPedestrian

  else

    if rbDriving.checked then

    RouteType := rtFastest

  else

    RouteType := rtBicycle;

  map.Routing.RouteType := RouteType;

  title := cbStart.Text + ' > ' + cbDestination.Text + ' > ' +
    rtToStr(RouteType);

  if routes.ItemIndex > -1 then
  begin
    routes.items[routes.ItemIndex] := title;
  end;

end;

end.
