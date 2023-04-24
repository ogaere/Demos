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
    RouteEValue: TSpinEdit;
    RouteColor: TPanel;
    Panel7: TPanel;
    map: TECNativeMap;
    NextInstruction: TPanel;
    NextKM: TPanel;
    Instructions: TPanel;
    Follow: TCheckBox;
    infos: TPanel;

    procedure RouteAddClick(Sender: TObject);

    procedure routesChange(Sender: TObject);

    procedure RouteColorClick(Sender: TObject);

    procedure cbStartChange(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);

    procedure RouteEValueChange(Sender: TObject);

    procedure rbDrivingClick(Sender: TObject);
    procedure mapShapesPaint(Sender: TObject; const canvas: TECCanvas);

  private
    { Déclarations privées }

    MarkerInstruction: TECShapeMarker;

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

  public
    { Déclarations publiques }
  end;

var
  FDemoNativeRoute: TFDemoNativeRoute;

implementation

{$R *.DFM}

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
    RouteType := rtFastest;

  RouteAdd.enabled := false;
 //   map.Routing.OptimizeRoute := false;

  //
  map.Routing.Request(cbStart.Text, cbDestination.Text);

  title := cbStart.Text + ' > ' + cbDestination.Text + ' > ' +
    rtToStr(RouteType);

  routes.ItemIndex := routes.items.add(title);

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
// a triangle is added to simulate a vehicle which moves
procedure TFDemoNativeRoute.doOnAddRoute(Sender: TECShapeLine;
  const params: string);
var
  moving   : TECAnimationMoveOnPath;
  triangle : TECShapePOI;
begin

  RouteAdd.enabled := true;

  // Create an animation to move a triangle along the road
  //
  // starting from km 0
  // speed 80 km / h
  moving := TECAnimationMoveOnPath.create(Sender, 0, 80);

  // create triangle

  triangle := map.AddPOI(0,0);

  triangle.POIShape := poiTriangle;
  triangle.width := 18;
  triangle.height := 24;
  triangle.color := GetShadowColorBy(RouteColor.color, 32);

  // we want react when the triangle moves (to follow and to turn by turn)
  triangle.OnShapeMove  := doOnMoveTriangle;

  triangle.OnShapeClick := doOnClickTriangle;

  Sender.Item := triangle;


  triangle.animation := moving;

  // event fired when arrived
  moving.OnDriveUp := doEndAnimationMove;

  // start animation
  moving.stop := false;

  // directing the tip of the triangle in the direction of travel
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
end;

procedure TFDemoNativeRoute.mapShapesPaint(Sender: TObject;
  const canvas: TECCanvas);
begin
end;

// fired when click triangle
// activate / deactivate auto tracking
procedure TFDemoNativeRoute.doOnClickTriangle(Sender: TObject;
  const Item: TECShape);
begin
  OnOffTracking(Item);
end;

// activate / deactivate auto tracking
procedure TFDemoNativeRoute.OnOffTracking(const Item: TECShape);
var
  Circle  : TECShapePOI;
  anim    : TECAnimationFadePoi;
begin

  if not assigned(Item) then
    exit;


  // the target is indicated by a blue circle
  // if it does not exist you must create

  if map.Group['tracking'].pois.Count = 0 then
  begin

    map.Group['tracking'].ZIndex := 100;


    Circle := map.AddPOI(Item.Latitude, Item.Longitude,('tracking'));

    Circle.width  := 48;
    Circle.height := 48;

    Circle.color := clBlue;

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
    //  item is the triangle that we follow
    Circle.Item := Item;

    // an animation of the circle is created by varying its size
    // anim is auto free when change circle.Animation or destroy circle
    anim := TECAnimationFadePoi.create;

    anim.MaxSize   := 48;
    anim.StartSize := 12;

    anim.StartOpacity := 80;

    Circle.animation := anim;

    if  assigned(Item.animation) and
       (Item.animation is TECAnimationMoveOnPath)  then
     begin

      // Connect the road on which the triangle is animated, has the turn by turn navigation
      map.Routing.TurnByTurn.Line := TECAnimationMoveOnPath(Item.animation).ShapeLine;

     end;

  end;

  // hide circle if no triangle
  Circle.Visible := Circle.Item <> nil;

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

        // 500 meter around you
        if Follow.checked then
           map.fitBoundsRadius(Item.Latitude, Item.Longitude, 0.5);

        // update your position in turn by turn navigation
        map.Routing.TurnByTurn.Position(Item.Latitude, Item.Longitude);

      end;

    end;

  end;

end;

// event turn by turn

// First alert
procedure TFDemoNativeRoute.doOnTurnByTurnAlert(Sender: TECTurnByTurn;
  const Instruction: string; const Distance: double);
begin
  Instructions.Font.color := clBlack;

  MarkerInstruction.SetPosition(map.Routing.TurnByTurn.NextInstructionPosition.
    Lat, map.Routing.TurnByTurn.NextInstructionPosition.Lng);

  Instructions.Caption := Instruction;

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
  ShowMessage('Error, your not on the route !');
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

{ *
  update the screen with the properties of the selected route
}
procedure TFDemoNativeRoute.doShowDataRoute(const id: integer);
var

  s: string;

begin

  if id < 0 then
    exit;

  s := routes.Text;

  cbStart.Text := trim(strtoken(s, '>'));
  cbDestination.Text := trim(strtoken(s, '>'));

  case StrToRT(trim(s)) of

    rtPedestrian:
      rbWalking.checked := true;

    rtFastest:
      rbDriving.checked := true;

    rtBicycle:
      rbBicycle.checked := true;
  end;

  routes.ItemIndex := id;

  RouteColor.color := map.shapes.lines[id].color;
  RouteEValue.value := map.shapes.lines[id].weight;

  // move marker at start route
  MarkerInstruction.SetPosition(map.shapes.lines[id].Path[0].Lat,
    map.shapes.lines[id].Path[0].Lng);

  // select this route for turn by turn navigation
  map.Routing.TurnByTurn.Line := map.shapes.lines[id];

  MarkerInstruction.PanTo;


  infos.Caption := doubleToStrDigit(map.shapes.lines[id].Distance, 2) + 'km - '
    + SecondeToTimeStr(map.shapes.lines[id].Duration);

  OnOffTracking(TECShape(map.shapes.lines[id].Item));

end;



{ *
  select color
}
procedure TFDemoNativeRoute.RouteColorClick(Sender: TObject);
var
  Line: TECShapeLine;
begin
  if Colordialog.execute then
  begin
    (Sender as TPanel).color := Colordialog.color;
    if (routes.ItemIndex > -1) then
    begin
      Line := map.shapes.lines[routes.ItemIndex];
      Line.color := RouteColor.color;
      Line.BorderColor := GetShadowColorBy(Line.color, 32);
      Line.HoverBorderColor := Line.BorderColor;
      Line.HoverColor := GetHighLightColorBy(Line.color, 32);
    end;

    map.Routing.color := RouteColor.color;

  end;
end;

procedure TFDemoNativeRoute.RouteEValueChange(Sender: TObject);
begin
  if (routes.ItemIndex > -1) then
    map.shapes.lines[routes.ItemIndex].weight := RouteEValue.value;

  map.Routing.weight := RouteEValue.value;
end;

procedure TFDemoNativeRoute.cbStartChange(Sender: TObject);
begin
  RouteAdd.enabled := (cbStart.Text <> '') and (cbDestination.Text <> '');
end;

procedure TFDemoNativeRoute.FormClose(Sender: TObject;
  var Action: TCloseAction);
begin

  Action := caFree;

end;

procedure TFDemoNativeRoute.FormCreate(Sender: TObject);
begin

  cbStart.tag := -1;
  cbDestination.tag := -1;

  // setup cache for tiles, routing
  map.LocalCache := extractfilepath(application.exename) + 'cache';

  // setup routing

  // select MapZen engine, you must use YOUR KEY
  // don't use this
  //
  // go to https://mapzen.com/developers
  //map.routing.Engine(reMapZen,'valhalla-SSzliI4');

  
  map.Routing.OnAddRoute    := doOnAddRoute;
  map.Routing.OnErrorRoute  := doOnErrorRoute;
  map.Routing.OnChangeRoute := doOnChangeRoute;

  map.Routing.RouteType     := rtFastest;
  map.Routing.color         := RouteColor.color;
  map.Routing.weight        := RouteEValue.value;

  // connect events for turn by turn navigation
  map.Routing.TurnByTurn.OnAlert            := doOnTurnByTurnAlert;
  map.Routing.TurnByTurn.OnInstruction      := doOnTurnByTurnInstruction;
  map.Routing.TurnByTurn.OnAfterInstruction := doOnTurnByTurnInstruction;
  map.Routing.TurnByTurn.OnArrival          := doOnTurnByTurnArrival;
  map.Routing.TurnByTurn.OnError            := doOnTurnByTurnError;
  map.Routing.TurnByTurn.OnDeconnectRoute   := doOnDeconnectTurnByTurn;

  // map.Routing.editOnClick := false;

  { new marker }

   MarkerInstruction := map.AddMarker(map.Latitude, map.Longitude);

  { load new icon }

   // 'http://maps.google.com/mapfiles/ms/icons/red-dot.png';
  MarkerInstruction.filename := 'data:image/png;base64,iVBORw0KGgoAAA' +
    'ANSUhEUgAAACAAAAAgCAYAAABzenr0AAAABGdBTUEAANbY1E9YMgAABPBJREFUWIWtl3tMW1Ucxw+'
    + '0hfEorwIDhdFSKJRnaSnl0ZZXKa9CC4wCo1RhPESWuUQTFd2cuKiJ07hItrnBmFFnXOaymZllWZwi'
    + 'c1uMYzGZyZZgMrc/xCnExCjh1Z+/c90qwr0Tj5J8cnO59/zO9/7O9/x+pwQACB8/dzjIrLuB3G6zk'
    + 'fM1xeSdEgN5WZ8lcicrDIkhwYM+Pj4jhJCjxIeMKEKCdzoT4wtfM2SLjxTnkbPVZvI9jqPjaRyhOS'
    + 'iCD+4LuIOBvqwvJ7u06TmxQYHnxL6+SzmR4dCZkgg7MlTQhVddVASIRaLl2KCAC89q1IZxWykn/H8'
    + 'RMOt2kGc06kfwa+cbFHHwTaMVPD1OgMe2ePH0tMC3TVXQqkzAiGTpiQxV/8y98f9JwHzXZrI3X9OJ'
    + 'QeGIOQ+gHyfsawXPVicsbW32sozQ/9PnH5QVAC4PvJSbOUDHMwv4wVVPzlSacnHyhaMlBoCBdm6ip'
    + 'QfACRlwwXFLIc2E54Sl0DSNcZgEXG2wkmxZ2LlGTDv0//PkK4HH28GtUoAqVDrxld0iZhLwqj7LJP'
    + 'L1hWtNlQC9reuenBPQ2wI3W2pBIvKFndq0SiYBmsjw5zNl4Vyw1V9/qb4cHkX3ywIDuCu95/OEITo'
    + 'SkkOlQ0wC8O+wE11NjbX6C+mkYrHYC71fkwUc15WaSAONsAoY605V8gqgX75SAL3nE7AjK4UGGmMV'
    + 'cLBBEc/tc9YMuFRyGugQkwBTbNRTyWFSWO52snkAvZOFHtJGRTzHJGC4SKfFgjI/XleOhmr7d7sAD'
    + 'fh1g5UWJM/e/Gwjk4CLdWXEGBN1zBQThcvQBp5u57omX+7+M/1V8bG0R5wet5WxFaLpdjvB1Cr9Ra'
    + 'LZodwMLuh6ihEtWq/nawBryK+f2UrT7mIcJgEzXC9opm3Ygkaa21eo5d0Rq403WpxHjbd4wKirW8B'
    + 'eMMPaC+hAygKKOGTSN9GGdKbKzC0H/7q3wQSakTYizEDn/UbE3oza673MdW4m29KTd8s2+MN0hwMA'
    + '2+/fJkd//N7VDMqQYGhPShimon9yOchdl52DScCtVpuX22115M6WOlFKWMjl9iT5mtpAU48HFgj39'
    + '/vuelNV6K3WWjLVUuOFScAkdsOV3GiupktRRpdisvGvBgV4OPkRsxKIBWm3LqNryllDruH7K2EScK'
    + 'G2ZA1X7BaikYV/4lRu8maBfv0redkQ4e93E7eu/2V8hx7hVsJcB1Zz1VFB3izIqcCtCbgknBcWcd8'
    + 'rpEHQp1Y+OdloJV/ge6thEnDaalzDx8gpq1Ei9ZNM4XJwp59Ldgvd83OnrEUJVxzl5GJ92RqYBBwv'
    + 'L+AFj2mk9KHot2ilg+1uPHCkg1waNEGX6GyVmRcmAaNmPS/vlRrI9gxVdVTABlhEDxRsjAS7/OHBk'
    + 'xVF+CyfFyYBh016XkbNeeSN/JzYQIn4t89tpbARO+KgJs34Pk40hj9K+GAS8KIug5ehe2BRuvG0Rg'
    + '14/WVfgVZGhQmJZhLwgjZdkD25mSQxRPqpPloGm4KDrr+Np/eDRh05IACTgF61UhAsywQPmx8GSSS'
    + 'QFCo9jz9CCJpRECYBPalKQQbSkkmWLGw/rYrykOCPXMly0qLcJAiTgP2YOiGosezyuF1UQEVczPAx'
    + 'NKDQrqEwCaCuFuKkpYj0qZPcVECHSr7tREUheRe3pxAPEvAHoSjT1B9h9DoAAAAASUVORK5CYII=';

  MarkerInstruction.YAnchor := 32;

  // on top of all over items, even if zindex <
  MarkerInstruction.setFocus;

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
