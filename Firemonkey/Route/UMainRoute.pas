unit UMainRoute;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes,
  System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs, FMX.ListBox,
  FMX.Controls.Presentation, FMX.StdCtrls, FMX.Layouts, FMX.Edit,
  System.UIConsts,
  FMX.uecMapUtil, FMX.uecNativeMapControl,FMX.uecGeoLocalise,
  FMX.uecNativeShape, FMX.uecGraphics, FMX.uecNativeScaleMap,
  FMX.Objects,System.IOUtils;

type
  TFDemoNativeRoute = class(TForm)
    LLeftRight: TLayout;
    LLeft: TLayout;
    LRight: TLayout;
    RouteEnd: TEdit;
    routes: TComboBox;
    From: TLabel;
    RouteStart: TEdit;
    Label1: TLabel;
    LRoute: TLayout;
    LTurnByTurn: TLayout;
    RouteAdd: TButton;
    rbDriving: TRadioButton;
    rbBicycling: TRadioButton;
    rbWalking: TRadioButton;
    Follow: TCheckBox;
    Panel1: TPanel;
    map: TECNativeMap;
    Rectangle1: TRectangle;
    Rectangle2: TRectangle;
    Rectangle3: TRectangle;
    infos: TLabel;
    instructions: TLabel;
    NextKM: TLabel;
    engine: TComboBox;
    InfoBar: TLayout;
    ScaleLine: TLine;
    ScaleLegend: TLabel;
    CopyrightMap: TLabel;
    Label2: TLabel;
    procedure LLeftRightResize(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure RouteAddClick(Sender: TObject);
    procedure routesChange(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
  private
    { Déclarations privées }
    FECNativeScaleMap: TECNativeScaleMap;

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
    procedure doOnMoveTriangle(Sender: TObject; const Item: TECShape;
      var cancel: boolean);
    procedure doOnClickTriangle(Sender: TObject; const Item: TECShape);
    procedure OnOffTracking(const Item: TECShape);

    procedure doNotifyScale(Sender: TObject);

  public
    { Déclarations publiques }
  end;

var
  FDemoNativeRoute: TFDemoNativeRoute;

implementation

{$R *.fmx}
//{$I Delphi_Versions.inc}

function GetRandomColor: TAlphaColor;
begin

  TAlphaColorRec(result).R := random(255);
  TAlphaColorRec(result).G := random(255);
  TAlphaColorRec(result).B := random(255);
  TAlphaColorRec(result).A := 255;

end;

procedure TFDemoNativeRoute.FormCreate(Sender: TObject);
begin
  LLeftRightResize(nil);

 // map.SSL := true;

  // USE YOUR KEY ! this key is just for demo
  map.MapBoxToken :=
    'pk.eyJ1Ijoiam9tYXgiLCJhIjoiY2lrZjVkaTl2MDAzNXZza3F5Zmg3eno2ZiJ9.VN9b5zTP0OrTLqQncoVafQ';

  map.Routing.OnAddRoute := doOnAddRoute;
  map.Routing.OnErrorRoute := doOnErrorRoute;
  map.Routing.OnChangeRoute := doOnChangeRoute;



  // connect events for turn by turn navigation
  map.Routing.TurnByTurn.OnAlert := doOnTurnByTurnAlert;
  map.Routing.TurnByTurn.OnInstruction := doOnTurnByTurnInstruction;
  map.Routing.TurnByTurn.OnAfterInstruction := doOnTurnByTurnInstruction;
  map.Routing.TurnByTurn.OnArrival := doOnTurnByTurnArrival;
  map.Routing.TurnByTurn.OnError := doOnTurnByTurnError;
  map.Routing.TurnByTurn.OnDeconnectRoute := doOnDeconnectTurnByTurn;

  // HACK FOR ROTATION MAP
  // Place your map in a TPanel, align = Client

  map.OverSizeForRotation := true;

  FECNativeScaleMap := TECNativeScaleMap.create;
  FECNativeScaleMap.OnChange := doNotifyScale;
  FECNativeScaleMap.Visible := false;
  FECNativeScaleMap.map := map;

  CopyrightMap.Text := map.CopyrightTile;
  map.ShowCopyrightTile := false;

  // local cache for tiles
 {$IFDEF NEXTGEN}
  map.LocalCache := TPath.Combine(TPath.GetSharedDocumentsPath, 'cache');
 {$ELSE}
  map.LocalCache := ExtractfilePath(ParamStr(0)) + 'cache';
 {$ENDIF}

  map.ScaleMarkerToZoom := true;


 

 {$IFDEF UseNET_HTTP_CLIENT}
  map.tileserver := tsOSM;
 {$ENDIF}


end;

procedure TFDemoNativeRoute.FormDestroy(Sender: TObject);
begin
  FECNativeScaleMap.free;
end;

procedure TFDemoNativeRoute.LLeftRightResize(Sender: TObject);
begin
  LLeft.Width := LLeftRight.Width / 2;
end;

procedure TFDemoNativeRoute.RouteAddClick(Sender: TObject);
var
  title: string;
  RouteLine : TECShapeLine;
begin

  (*
    We will directly pass a line to the routing engine
    so that we can attach parameters to it
    that will be used when the route is calculated,
    here we store the speed of our mobile according to the type of route desired
  *)

  RouteLine := map.routing.futureRoute; // return a empty line

  if rbWalking.ischecked then
  begin
    map.Routing.RouteType := rtPedestrian ;
    RouteLine.propertyValue['speed']:='6';
  end
  else if rbBicycling.ischecked then
  begin
    map.Routing.RouteType := rtBicycle ;
    RouteLine.propertyValue['speed']:='20';
  end
  else
   begin
    map.Routing.RouteType := rtCar;
    RouteLine.propertyValue['speed']:='50';
   end;





  title := RouteStart.Text + ' > ' + RouteEnd.Text + ' > ' +
    rtToStr(map.Routing.RouteType);

  if routes.Items.IndexOf(title)>-1 then
  begin
   RouteLine.Remove;
   exit;
  end;




  RouteAdd.enabled := false;



  map.Routing.Color := GetRandomColor;

  // select routing engine

  case engine.ItemIndex of
    0:
      map.Routing.engine(reMapBox);
    1:
      map.Routing.engine(reMapQuest);
    // USE YOUR KEY !  this key is just for demo
    2:
      map.Routing.engine(reMapZen, 'valhalla-SSzliI4');
    3:
      map.Routing.engine(reOSRM);
    4 : map.Routing.Engine(reOpenStreetMap);
  end;

  // then empty string is for optionnal params, here none
  map.Routing.Request(RouteStart.Text, RouteEnd.Text,'',RouteLine);

  title := RouteStart.Text + ' > ' + RouteEnd.Text + ' > ' +
    rtToStr(map.Routing.RouteType);

  routes.Items.Add(title);

end;

procedure TFDemoNativeRoute.routesChange(Sender: TObject);
begin
  doShowDataRoute(routes.ItemIndex);
end;

// routing events

// route not created !
procedure TFDemoNativeRoute.doOnErrorRoute(Sender: TObject;
  const dataroute:TECThreadDataRoute);
begin
  RouteAdd.enabled := true;

  Instructions.Text := 'Route not found !';
end;

// route is ok
//
// a triangle is added to simulate a vehicle which moves
procedure TFDemoNativeRoute.doOnAddRoute(Sender: TECShapeLine;
  const params: string);
var
  moving: TECAnimationMoveOnPath;
  triangle: TECShapePOI;
  speed: integer;
begin

  RouteAdd.enabled := true;


  // obtain the road speed
  speed := StrToInt(Sender.propertyValue['speed']);


  // Create an animation to move a triangle along the road

  // starting from km 0

  moving := TECAnimationMoveOnPath.create(Sender, 0, speed);

  // create triangle

  triangle := map.AddPOI(0, 0);

  triangle.POIShape := poiArrowHead;
  triangle.Width := 18;
  triangle.height := 24;
  triangle.Color := GetshadowColorBy(Sender.Color, 32);
  triangle.HoverColor := GetHighlightColorBy(Sender.Color, 32);

  // we want react when the triangle moves (to follow and to turn by turn)
  triangle.OnShapeMove := doOnMoveTriangle;

  triangle.OnShapeClick := doOnClickTriangle;

  Sender.Item := triangle;

  triangle.animation := moving;

  // event fired when arrived
  moving.OnDriveUp := doEndAnimationMove;

  // start animation
  moving.stop := false;

  // directing the tip of the triangle in the direction of travel
  moving.heading := true;

  infos.Text := doubleToStrDigit(Sender.Distance, 2) + 'km - ' +
                doubleToStrDigit(Sender.Duration / 3600, 2) + 'h';

  //routes.ItemIndex := Sender.indexof;
  OnOffTracking(triangle);
  doShowDataRoute(Sender.indexof);

  //

   // 500 meter around you
    if Follow.ischecked then
       map.fitBoundsRadius(sender.Path[0].Latitude, sender.Path[0].Longitude, 0.5);

end;

// the event is triggered when the route is recalculated
procedure TFDemoNativeRoute.doOnChangeRoute(Sender: TECShapeLine;
  const params: string);
begin
  if not assigned(Sender) then
    exit;

  infos.Text := doubleToStrDigit(Sender.Distance, 2) + 'km - ' +
    doubleToStrDigit(Sender.Duration / 3600, 2) + 'h';

end;

// event turn by turn

// First alert
procedure TFDemoNativeRoute.doOnTurnByTurnAlert(Sender: TECTurnByTurn;
  const Instruction: string; const Distance: double);
begin
  instructions.TextSettings.Fontcolor := claBlack;

  instructions.Text := Instruction;

  if Distance > 0 then
    NextKM.Text := doubleToStrDigit(Distance, 2) + 'km'
  else
    NextKM.Text := '';
end;

// execute now
procedure TFDemoNativeRoute.doOnTurnByTurnInstruction(Sender: TECTurnByTurn;
  const Instruction: string; const Distance: double);
begin
  instructions.TextSettings.Fontcolor := claRed;
  instructions.Text := Instruction;

  if Distance > 0 then
    NextKM.Text := doubleToStrDigit(Distance, 2) + 'km'
  else
    NextKM.Text := '';
end;

procedure TFDemoNativeRoute.doOnTurnByTurnArrival(Sender: TObject);
begin
  instructions.Text := 'you arrived !';
end;

procedure TFDemoNativeRoute.doOnTurnByTurnError(Sender: TECTurnByTurn;
  const Lat, Lng: double; const ErrorCounter: integer);
begin
  ShowMessage('Error, your not on the route !');
end;

procedure TFDemoNativeRoute.doOnDeconnectTurnByTurn(Sender: TObject);
begin
  instructions.Text := '';
  NextKM.Text := '';
end;


// --------------------

// fired when click triangle
// activate / deactivate auto tracking
procedure TFDemoNativeRoute.doOnClickTriangle(Sender: TObject;
  const Item: TECShape);
begin
  doShowDataRoute(item.indexof);
  OnOffTracking(Item);
end;

// activate / deactivate auto tracking
procedure TFDemoNativeRoute.OnOffTracking(const Item: TECShape);
var
  Circle: TECShapePOI;
  anim: TECAnimationFadePoi;
begin

  if not assigned(Item) then
    exit;


  // the target is indicated by a circle
  // if it does not exist you must create

  if map.Group['tracking'].pois.Count = 0 then
  begin

    map.Group['tracking'].ZIndex := 100;

    Circle := map.AddPOI(Item.Latitude, Item.Longitude, ('tracking'));

    Circle.Width  := 48;
    Circle.height := 48;

    Circle.BorderColor := claWhite;
    Circle.BorderSize  := 4;

    Circle.POIShape := poiEllipse;

    Circle.Clickable := false;

  end

  else

    Circle := map.Group['tracking'].pois[0];

  // stop tracking
  if assigned(Circle.Item) and (Circle.Item = Item) then
  begin
    Circle.Item := nil;
    // cancel turn by turn
    map.Routing.TurnByTurn.Line := nil;

  end

  else // track item
  begin
    // item is the triangle that we follow
    Circle.Item := Item;

    // an animation of the circle is created by varying its size
    // anim is auto free when change circle.Animation or destroy circle
    anim := TECAnimationFadePoi.create;

    anim.MaxSize := 48;
    anim.StartSize := 12;

    anim.StartOpacity := 80;

    Circle.animation := anim;

    if assigned(Item.animation) and (Item.animation is TECAnimationMoveOnPath)
    then
    begin

      // Connect the road on which the triangle is animated, has the turn by turn navigation
      map.Routing.TurnByTurn.Line := TECAnimationMoveOnPath(Item.animation)
        .ShapeLine;

    end;

  end;

  // hide circle if no triangle
  Circle.Visible := Circle.Item <> nil;

  if not Circle.Visible then
   map.AnimRotationAngleTo(0);


  Circle.Color := GetHighlightColorBy(Item.Color, 16);

  Circle.BorderColor := claWhite;
  Circle.BorderSize  := 4;


  Item.setFocus;

end;

// go to start when arrived
procedure TFDemoNativeRoute.doEndAnimationMove(Sender: TObject);
begin
  TECAnimationMoveOnPath(TECShape(Sender).animation).Distance := 0;
  TECAnimationMoveOnPath(TECShape(Sender).animation).stop := false;
end;

// fired when triangle move
procedure TFDemoNativeRoute.doOnMoveTriangle(Sender: TObject;
  const Item: TECShape; var cancel: boolean);
begin

  if assigned(Item) then
  begin

    if map.Group['tracking'].pois.Count = 1 then
    begin
      // tracking actif
      if (map.Group['tracking'].pois[0].Item = Item) then
      begin

        map.Group['tracking'].pois[0].SetPosition(Item.Latitude,
          Item.Longitude);

        map.AnimRotationAngleTo(Item.Angle);

        if Follow.ischecked then
          map.setCenter(item.Latitude,item.longitude);

        // update your position in turn by turn navigation
        map.Routing.TurnByTurn.Position(Item.Latitude, Item.Longitude);

      end;

    end;

  end;

end;

{ *
  update the screen with the properties of the selected route
}
procedure TFDemoNativeRoute.doShowDataRoute(const id: integer);
var

  s: string;

begin

  if id < 0 then
    exit;

  s := routes.Items[id];

  RouteStart.Text := trim(strtoken(s, '>'));
  RouteEnd.Text := trim(strtoken(s, '>'));

  case StrToRT(trim(s)) of

    rtPedestrian:
      rbWalking.ischecked := true;

    rtFastest:
      rbDriving.ischecked := true;

    rtBicycle:
      rbBicycling.ischecked := true;
  end;

  routes.ItemIndex := id;


  // select this route for turn by turn navigation
  map.Routing.TurnByTurn.Line := map.shapes.lines[id];

  infos.Text := doubleToStrDigit(map.shapes.lines[id].Distance, 2) + 'km - ' +
    doubleToStrDigit(map.shapes.lines[id].Duration / 3600, 2) + 'h';

  OnOffTracking(TECShape(map.shapes.lines[id].Item));

end;


// scale change
procedure TFDemoNativeRoute.doNotifyScale(Sender: TObject);
begin

  if assigned(Sender) and (Sender is TECNativeScaleMap) then
  begin
    ScaleLine.Size.Width := TECNativeScaleMap(Sender).ScaleWidth;
    ScaleLegend.Size.Width := ScaleLine.Size.Width;
    ScaleLegend.Text := TECNativeScaleMap(Sender).ScaleLegend;
  end;

end;

end.
