  NativeMapControl

  show tile map from OSM, Bing, Here, MapBox, TomTom, ... without WebBrowser without javascript

  Copyright (C) 2013 ESCOT-SEP Christophe

  Web site : https://www.helpandweb.com/ecmap/en/

  @Author ESCOT-SEP Christophe

  Version 1.0 : Juin 2013

5.2  Janvier 2024

  BUG

  style if the property contains a value, any value except empty don't work
     map.Styles.addRule('.property_name:*   {xxx}');

  Regression: pois are not correctly loaded with toTxt (thanks Pier)

  TecNativeLineToRoute

   Fixed various bugs that could cause crashes when editing long routes interactively.
   Enhanced interactive editing
   Interactive route editing is activated by clicking on a route
   when map.Routing.EditOnClick is true (default).

  DragRect no longer displayed (thanks Joze)

  EIntOverflow in uecEditNativeLine (thanks Fabrice)

  Labels.ColorType  lcInvertShape and lcContrasting don't work

  ColorFilter did not work with use2DCanvas = true

  Last point missing during data copy between polygon when geometry is encoded (thanks julien)

  polyKo.toTxt := polyOk.toTxt;

  Airquality data remains displayed after visible := false

  Regression TargetLine SnapDrag don't draw

  KML files with no altitude in the geometrie were not correctly imported

  TECShape.PropertiesFindNext only work on windows

  the zindex is not applied to the element but to its group in rules like

  map.Styles.addRule('#GROUP.SHAPE.PropName:PropValue {zindex:-1;}');


  Refresh problem when adding an element to the map in the OnMapDblClick event

  When importing gpx and kml files, the XAnchor and YAnchor properties of the points
  were not centered, which caused the points to shift more and more when dezooming.

  When zooming in with 2 fingers, the map could not be moved at the same time. (thanks alex)

  Google tiles did not work with versions older than Delphi 10,
  but are now fully supported from Delphi 7 onwards.

  Editable line points were no longer accessible if FocusedShapeWhenClicking was set to true

  VCL Direct2D

  artifact on the polygon contour when zooming out.

  Tile opacity was not taken into account

  Change

   Data import by toTxt detects whether the data is in kml, geojson or gpx format.
   if not, it is treated as TECNativeMap's internal format.
    map.toTxt := 'kml data';
    map['group'].toTxt := 'geojson data';

   DemoNativeLinesPolygons updated,
   simplifying code by directly using line and polygon edit mode

   DemoNativeRoute udated
   covers  creation and modification of routes, turn by turn, itineraries and mobile animation

  ADD
  
    Support Delphi 12

    PTV Routing, support language ISO 639-1 Code

    map.locale := 'fr';

    property TECShapeLine.DistanceToPoint(Const Lat,Lng : double ) : double;

       Distance in kilometers from start to this point,
       Lat,Lng is projected onto the line to obtain the nearest point on the line.


    property TECItinerary.Start : string

     Start Instruction

    property TECItinerary.Arrival : string

     Arrival instruction


    property TECAnimationShape.Animations : TECAnimationShape

     Allows you to define multiple animations for an element

      // first animation move on path
      poi.animation := TECAnimationMoveOnPath.create(line, 0, speed);
      // second animation
      anim := TECAnimationFadePoi.create;
      anim.MaxSize   := 40;
      anim.StartSize := 24;
      poi.animation.animations := anim;


    TLabelShowOnly.lsoEdited

     the label will only be displayed if the element is in edition mode

    Improved measurement tool, modelled on the line editor, it can now also measure surfaces.
    It can be accessed directly from the component's MeasureTool property.

      map.MeasureTool.visible := true;
      map.MeasureTool.MeasureArea := true;

     see demo MeasureTool

  function TNativeMapControl.addPOI(const SWLat,SWLng,NELat,NELng: double; const GroupName: string = ''): TECShapePOI;
  function TECShapes.AddPoi(const SWLat,SWLng,NELat,NELng: double): TECShapePOI;

  Creation of a POI whose surface area will cover the specified zone,
  with the width and height measured in meters.

  poi := map.addPOI(swLat,swLng,neLat,neLng); // default group
  poi := map.addPOI(swLat,swLng,neLat,neLng,'GroupX');

  poi := map['GroupX'].addPoi(swLat,swLng,neLat,neLng);


  property TECShapePOI.WithEgalHeight : boolean;

  if true the POI width and height will be identical,
  if you modify one the other will have the same value


  New style for clusters, csCategories allows you to count element types within the cluster

  see demoNativePOI and https://www.helpandweb.com/ecmap/en/shapes.htm#TECCLUSTERMANAGER

  property TECCluster.Hint:string;

  property TECShapes.ClusterManager.Hint : string;

  Default hint if cluster hint is empty


  property TNativeMapControl.DrawOverlayTilesWhenMoving : boolean (default true ondesktop false on mobile)

  Allows or disallows overlay tiles to be displayed during map movement

  property TECOverlayTileLayer.ZIndex : integer

  Overlapping tiles have a ZIndex to easily indicate their display order

  Import geojson

    support EPSG 3857, EPSG 900913 and 2154 (lambert 93)

    check validity of point coordinates during json import, out-of-bounds points are ignored

  procedure  TNativeMapControl.TileServerWMS(const Url,Layers:string;const ESPG:integer=4326);

  Add WMS Tile server

  map.TileServerWMS('https://ows.mundialis.de/services/service','TOPO-WMS');

  You can select a date in iso-8601 format

  map.WMS_Time := '2023-10-19T09:00:00.000Z';

  set legend property

  procedure  TNativeMapControl.WMS_Legend(const show:boolean;
  const position:TLegendPosition=lpTopRight;
  const fopacity:byte=100;
  const XMargin:integer=7;
  const YMargin:integer=7);

  map.WMS_Legend(true);



  function  TNativeMapControl.AddOverlayTileServerWMS(const Url,Layers:string;const ESPG:integer=4326): TECOverlayTileLayer;

  Add Overlay WMS Tile server

  o := map.AddOverlayTileServerWMS('https://ows.mundialis.de/services/service','OSM-Overlay-WMS');

  You can select a date in iso-8601 format

  o.WMS_Time := '2023-10-19T09:00:00.000Z';

  set Legend property

  o.WMS_Legend(true,lpTopCenter);


  WMS & WFS Layers see Demo and http://www.helpandweb.com/ecmap/en/layers.htm#LAYER_WMS


  property TNativeMapControl.TileServerInfo.MapStyles : TStringList (thanks Fabrice)

  List of all valid TileServerInfo.MapStyle property values
  MapStyle can also be empty, this is the default value

  property TNativeMapControl.TouchZoom_NoPan : boolean (default false)

  if true  the map does not pan during two-finger zooming



  new function for nominatim strutured query  : https://nominatim.org/release-docs/latest/api/Search/

  function TNativeMapControl.GetLatLngStructuredAddress(var dLatitude, dLongitude: double;
  const sAddress: string): boolean; overload;

  if map.GetLatLngStructuredAddress(lat,lng,'street=10 rue de la paix&city=Paris') then
  begin
  map.setCenter(lat,lng);
  end;

  function TNativeMapControl.GetLatLngStructuredAddress(var dLatitude, dLongitude: double;
  const street:string;
  const city:string;
  const amenity:string='';
  const county:string='';
  const state:string='';
  const country: string='';
  const postalcode:string=''): boolean;

  if map.GetLatLngStructuredAddress(lat,lng,'10 rue de la paix','Paris') then
  begin
  map.setCenter(lat,lng);
  end;


  function TNativeMapControl.StructuredAddress(const sAddress: string): boolean;

  StructuredAddress('street=10 rue de la paix&city=Paris')

  function TNativeMapControl.StructuredAddress(const street:string;
  const city:string;
  const amenity:string='';
  const county:string='';
  const state:string='';
  const country: string='';
  const postalcode:string=''
  ): boolean;

  StructuredAddress('10 rue de la paix','Paris');


5.1  Octobre 2023

  BUG

  When a line has focus, if ShowDirection is true, then arrows appear below the line

  A two-finger zoom lasting more than 2 seconds also triggers an OnMapLongClick (thanks Mihai)

  On android and ios the marker click zone is far too large (thanks Mihai)

  If you double-click on a marker to open a dialog box,
  the marker remains "stuck" to the mouse and moves with it when you return (thanks Thore)

  import kml don't show points

  line direction triangles are not deleted if the line is destroyed with remove (thanks Ferenc)

  possible memory leak when abandoning a tile server or loading invalid tiles (thanks Alex)

  stack overflow when switching a route to edit mode and modifying its path

  VCL 2dcanvas

    label display with 2DCanvas was very slow

    opacity does not work if lines have a border

    Graticule only PenStyle = psSolid (thanks Fernando)

    ScaleBar not draw (thanks Fernando)

    PNG transparency was not preserved (thanks Fernando)


  CHANGE

   remove fcLight and fcDark filters

    Lightening and darkening are controlled by LightValue and DarkValue,
    the higher value is applied if the filter is different from fcNone  (thanks Mihai)

     // invert colors + Lightening 40
     map.ColorFilter.filter := fcInvert;
     map.ColorFilter.LightValue := 40;
     map.ColorFilter.DarkValue  := 0;



  Here has changed its tile system, you need to create a new account

  https://platform.here.com/sign-up

  To use the new tiles you must select tsHere and then indicate the map style.

  map.TileServer    := tsHere;
  map.HereApiKey := := 'your_api_key' ;
  // select style
  map.TileServerInfo.MapStyle := 'explore.day';
  map.TileServerInfo.MapStyle := 'lite.day';
  map.TileServerInfo.MapStyle := 'explore.night';
  map.TileServerInfo.MapStyle := 'satellite.day';
  map.TileServerInfo.MapStyle := 'explore.satellite.day';


  ADD

  procedure TNativeMapControl.RemoveGraphic(const Value: string);

   Images loaded with Marker.Filename := 'xxx' are cached,
   this procedure deletes the image from the cache.

   ! All markers that use this image will have their Filename emptied.

  procedure TNativeMapControl.ClearGraphics;

    clear image cache

    ! Markers that use these images have their filenames emptied


  Google 2DTiles API support ( https://developers.google.com/maps/documentation/tile/roadmap?hl=en )

    map.Google.ApiKey := 'your api key';
    map.TileServer := tsGoogle;

    // 3 map types to choose from
    map.TileServerInfo.MapStyle := 'satellite';
    map.TileServerInfo.MapStyle := 'terrain';
    map.TileServerInfo.MapStyle := 'roadmap';

    // set language, default en-US
    map.Google.Lang := 'fr-FR';
    // set region, default US
    map.Google.Region := 'FR';

    // traffic is also supported
    map.TrafficLayer := true;

    // styles also
    map.Google.Styles := '[{"featureType": "all","stylers": [{ "color": "#C0C0C0" }]'+
                        '},{"featureType": "road.arterial", "elementType": "geometry",'+
                        '"stylers": [ { "color": "#CCFFFF" } ]},{'+
                        '"featureType": "landscape","elementType": "labels", "stylers": [{ "visibility": "off" }'+
                        ']}]';


  Dark and Light modes added as ColorFilter shortcuts (thanks Mihai)

    Map.Dark := true;
    Map.Light:= true;

  New color filter for tiles : fcInvert , fcSepia   (thanks Mihai)

  map.ColorFilter.filter := fcInvert;
  map.ColorFilter.filter := fcSepia;

  VCL support Lightvalue and Darkvalue filters


  Demo ColorFilter (Firemonkey)


  new tiles server https://stadiamaps.com/

  map.TileServer    := tsStadiaMaps;
  map.StadiaMapsKey := 'your_api_key' ;
  map.TileServerInfo.MapStyle := 'alidade_smooth'; // default
  map.TileServerInfo.MapStyle := 'alidade_smooth_dark';
  map.TileServerInfo.MapStyle := 'outdoors';
  map.TileServerInfo.MapStyle := 'stamen_toner';
  map.TileServerInfo.MapStyle := 'stamen_terrain';
  map.TileServerInfo.MapStyle := 'stamen_watercolor';
  map.TileServerInfo.MapStyle := 'osm_bright';



  added iwpFixedHead option for infowindow peakLink

  window tips now have a fixed length, as in versions prior to 4.7

  your_window.PeakLink := iwpFixedHeap;


  Improved routing instructions for OpenStreetMap

  TNativeMapControl.Routing.Itinerary : TECItinerary;

  Makes it easy to display a route planner

  see Itineray demo and https://www.helpandweb.com/ecmap/en/roads.htm#ITINERARY

  Map and routing support from PTV Group

  see PTV demo and https://www.helpandweb.com/ecmap/en/tecnativemap.htm#PTV_GROUP

  get your key on https://developer.myptv.com/en/documentation

  map.PTV.ApiKey := 'your api key' ;

  map.Routing.Engine(rePTV);
  map.Routing.OnAddRoute := doOnAddRoute;

  procedure TForm.doOnAddRoute(Sender: TECShapeLine; const params: string);
  begin
  Sender['violated'] content true or false
  Sender['toll'] contains toll data in json format
  Sender['monetaryCosts'] contains monetary costs data in json format
  end;

  // set ptv base map
  map.PTV.BaseMapLayer := amber ; // or blackmarble,classic,gravelpit,sandbox,silica,silkysand,satellite
  map.PTV.ForegroundLayers :=  [background,transport,labels,trafficIncidents,trafficPatterns,restrictions,toll];

  // cancel ptv base map
  map.PTV.BaseMapLayer := none;

  // View PTV layers over any base map
  map.PTV.OverlayLayers :=  [transport,labels,trafficIncidents,trafficPatterns,restrictions,toll];

  // cancel ptv overlay
  map.PTV.OverlayLayers := [];

  Support ThunderForest Maps

  map.ThunderforestKey := 'your api key';
  map.TileServer := tsThunderForest;

  // select your style
  map.TileServerInfo.Style := 'transport';
  map.TileServerInfo.Style := 'landscape';
  map.TileServerInfo.Style := 'neighbourhood';
  map.TileServerInfo.Style := 'mobile-atlas';
  map.TileServerInfo.Style := 'pioneer';
  map.TileServerInfo.Style := 'transport-dark';
  map.TileServerInfo.Style := 'cycle';
  map.TileServerInfo.Style := 'outdoors';


5.0  juin 2023 - 10th anniversary

  BUG

  Using overlay under Firemonkey caused constant cpu usage (thanks Alex)


  ADD

  property TECOffScreenScreenShot.ShowShapes : boolean (default true)

  choose the display of the elements during screen captures

  // do not capture elements only tiles
  map.ScreenShots.ShowShapes := false;


  ChartLayer allows you to display pie charts or stacked bars.

  see https://www.helpandweb.com/ecmap/en/layers_0.htm#CHART_LAYER

  AirQuality displays the rate of air pollution in the world

  see https://www.helpandweb.com/ecmap/en/layers.htm#AIRQUALITY


  property TECShapes.HintColor : TColor

  each group can have its own Hint color

  VCL

  support Direct2DCanvas for a better quality display for lines, polygons and pois

  map.Use2DCanvas := false; // default true


4.9  avril 2023

  BUG

  map.HintInfoWindow.ContentCenter := false don't work

  The vertical offset of hints is not good when ScaleMarkerToZoom = true

  Html links in kml file descriptions are not preserved

  syntaxe AddPolygone([]) and addLine([]) cause errors,
  they must return an empty Polygon or Line (thanks Jaap)

  Crash when the map is destroyed if a line or a polygon is in editable mode

  style :focused refresh problem when using FocusedShapeWhenClicking (thanks Alex)

  In some conditions the drag of the elements is possible with a right mouse down (thanks alex)

  function TECShapePolygone.id : int64;

  the unique identifier is double incremented, 1,3,5 etc.

  A long text surrounded by a <font> tag can block the application
  when displaying an infowindow in VCL

  TECTomTomIncident.Layer

  You have to move the map after reactivating the layer to restart the display (thanks Mario)

  BoundingBox limitation did not work after zooming out

  Error in UseLowZoom which makes that beyond 2 levels of zoom
  the old tiles are badly used and that displays an empty screen (gray)

  The resizing handles of the TECShapePOI defined in meters are badly positioned.
  The resize handles of the TECShapePOI are badly positioned if ScaleMarkerToZoom is active (thanks Gilles).

  OverSizeForRotation crashes if the map is contained
  in a parent whose ControlType is Platform  (thanks Ian)

  Regression marker labels (FStyleIcon = siFlat) or (FStyleIcon = siFlatNoBorder)
  are not displayed   (thanks fabrice)

  TNativeMapControl.RemoveAllOverlayTiles crash (thanks fabrice)


  ADD

  procedure TECSnapDrag.SnapMarker(const Marker : TECShape);

  Force a marker to move on a guide if it is nearby

  Bubble Layer

  see : https://www.helpandweb.com/ecmap/en/layers.htm#BUBBLE_LAYER

  see also DemoBubleLayer


  you can inject the element's properties into its Hint (tooltip) using the syntax

  marker['prop1']:='data 1';
  marker['prop2']:='data 2';
  marker.hint := 'value of [prop1] - value of [prop2]';


  property TECShapes.Hint : string

  Groups have a Hint property that will serve for its elements that have their Hint empty

  map['groupx'].Hint := 'value of [prop1] - value of [prop2]';


  lcContrasting in TLabelShapeColorType

  ltMask in TLabelShapeType

  property TLabelShape.LabelMask: string

  defines a mask to display the content of several properties of the element

  map.shapes.markers.Labels.LabelType := ltMask;
  // [location] and [size] are replaced by the content of these properties
  map.shapes.markers.Labels.LabelMask := '[location]'+#13#10+'[size]';

  function  TECNativeMap.LatLngToQTHLocator(const Lat, Lng: double): string;

  Get the Locator from a GPS position

  procedure TECNativeMap.QTHLocatorToLatlng(Locator: string; var Lat, Lng: double);

  Get a GPS position from a Locator

  Locator is a geocode system used by amateur radio operators
  to succinctly describe their geographic coordinates

  see : https://en.wikipedia.org/wiki/Maidenhead_Locator_System



  add guLOC, guQTHLocator and guUTM in Graticule.LabelUnit

  map.Graticule.LabelUnit := guQTHLocator;
  map.Graticule.LabelUnit := guUTM;
  map.Graticule.LabelUnit := guLOC; // https://www.helpandweb.com/ecmap/en/location.htm#OPEN_LOCATION_CODE

  show LOC, Locator or UTM at the mouse position


  multi-line support in hints without using html markup

  mrk.hint := 'line 1'+#13#10+'line 2';

  support Heading in KML

  <IconStyle>
  <heading>279</heading>
  <Icon><href>image.png</href></Icon>
  </IconStyle>

  property TNativeMapControl.Grids : TECGrids

  This property manages grids that you can place on your map,
  the grids can be rectangular or delimited by a polygon.

  see https://www.helpandweb.com/ecmap/en/shapes.htm#GRIDS

  property  TNativeMapControl.SelectArea : TECSelectArea

  Support for a rectangular or circular selection area

  see https://www.helpandweb.com/ecmap/en/shapes.htm#SELECTAREA

  also new demo demoSelectArea

  LabelType ltPosition

  display latitude and longitude as a label

  map.shapes.labels.LabelType := ltPosition

  property TLabelShape.PositionPrecision:byte   (default 3)

  map.shapes.labels.PositionPrecision := 2;

  precision of the position in the label, by default 3 digits after the comma

  property TECTomTomIncident.ShowInfoWindow : boolean (default true)

  if true display the information of the accidental areas on mouse over
  or when pressing for the mobile versions


  function TECShapeLineList.NearestLineToPoint(const lat,lng:double;MinDistanceMeter:integer=100):TNearestLine;
  function TECShapePolygoneList.NearestPolygoneToPoint(const lat,lng:double;MinDistanceMeter:integer=100):TNearestPolygone;

  var nl : TNearestLine ;

  nl := map.shapes.lines.NearestLineToPoint(lat,lng);

  if assigned(nl.line) then
  begin
  nl.lat; // latitude on line
  nl.lng; // longitude on line
  nl.distance; // distance to line in meters
  end;


  Additonal syntax to access groups by their index

  var g : TECShapes;
  for i:=0 to ECnativeMap.Count-1 do
  g := ECnativeMap[i];

  property TNativeMapControl.EditableAddPointByClickOnMap : boolean  (default false)

  if true and a line is in editable mode add the point when clicking on the map

  property TNativeMapControl.ExitEditableClickLastPointLine : boolean (default false)

  if true leave the editable mode of a line by a right click on the last point

  support SSL for tiles server tsOPNV

  procedure TECDrawPath.AddPoint(const latitude,longitude:double);

  map.DrawPath.Activate := true;
  map.DrawPath.AddPoint(latitude,longitude);

  property TECDrawPath.ShowCursor : boolean

  map.DrawPath.ShowCursor := false;

  property TECClusterManager.OnClusterGetText: TOnClusterGetText

  Intercepts the text of a cluster to modify it


  map.Shapes.ClusterManager.OnClusterGetText := doClusterGetText;
  map['groupx'].ClusterManager.OnClusterGetText := doClusterGetText;
  ...
  procedure TForm.doClusterGetText(const Cluster: TECCluster; var Text : String);
  begin
  //
  end;



4.8  Janvier 2023

  BUG


  procedure TECShapeList.AddItem(value: TECShape);

  The procedure to add derived TECShape was not fully functional (thanks Alex)

  TECShapeMyMarker = class(TECShapeMarker)
  ...
  mymarker := TECShapeMyMarker.create(map.Shapes.Markers);
  map.shapes.Markers.AddItem(mymarker);
  mymarker.SetPosition(map.Center.Lat,map.Center.Lng);

  If the two-finger zoom is disabled, this movement still produces a panning motion

  You can't mix the default properties Path and PropertiesValue for lines and polygones

  var value:string;
  point:TECPointLine;
  Line:TECShapeLine;
  ...
  Line  := map.shapes.lines[0];
  value := Line['name'];
  point := Line[12];


  The simplification of lines and polygons was disabled which could slow down
  the map when there were many lines, or lines containing several thousand points

  Simplification is in itself a relatively slow process that must be done when changing the zoom

  By default lines containing more than 250,000 points are not simplified, you can change it like this

  yout_line.MaxPointForUseDouglasPeucker := 300000;


  Saving and loading in Txt format was very slow when there were lines or polygons containing many points


  TNativeMapControl.RoadDistance

  TNativeMapControl.GetRoutePathByAdress,TNativeMapControl.GetRoutePathFrom ,
  TNativeMapControl.GetASyncRoutePathByAdress,TNativeMapControl.GetASyncRoutePathFrom

  Didn't work anymore because MapQuest was used, now we use OpenStreetMap routing

  TECGeofences.Add(const Polygone: TECShapePolygone;  const Name: string = '')

  The area surrounding the polygon is not correctly calculated,
  the created geofences are not detected  (thanks christiano)

  MapBox road calculation, the duration is false if OptimiseRoute is true

  When clusters are drawn by the user through ClusterManager.OnDrawCluster
  the element count continues to be displayed when it should not (thanks Jaap)

  ADD

  property TNativeMapControl.OnEditMapClick : TOnMapLatLng

  this event is triggered when clicking on the map and if an element is in editable mode

  map.OnEditMapClick := doOnEditMapClick

  procedure TForm.doOnEditMapClick(sender: TObject; const Lat, Lng: double);
  begin
  // sender is the map
  // You access the element in edit mode with TNativeMapControl(sender).EditShape
  end;

  property TNativeMapControl.Graticule : TECGraticule;

  A graticule is a grid of latitude and longitude lines

  map.Graticule.visible := true;

  see www.helpandweb.com/ecmap/en/tecnativemap.htm#GRATICULE


  property TNativeMapControl.DragShape : TECShape;

  modifies on the fly the element that is moved with the mouse,
  the new element must have Draggable set to true


  function TNativeMapControl.AddLineFromAddress(const address: string;
  const GroupName: string = ''): TECShapeLine

  Displays the lines, extracted from nominatim, corresponding to the address.

  There can be several lines, contiguous or not, the last line is returned

  To have the list of lines you can either pass an empty group
  and you will then have the lines in map['group'].lines,
  or save the index of the last line of the group,
  the line returned will be the last one of the group

  var line : TECShapeLine;
  first_line:integer;
  ...

  // use default group
  first_line := map.shapes.lines.count;
  line := map.AddLineFromAddress('avenue des champs- lys es, paris');
  if assigned(line) then
  begin
  // line is the last find
  line.fitBounds;
  // total line is (line.indexof - first_line + 1);
  end;


  function TNativeMapControl.AddPolygoneFromAddress(const address: string;
  const GroupName: string = ''): TECShapePolygone

  same AddLineFromAddress but find polygones


  rtTruck in TECRounting.routeType

  only for TomTom and Valhalla

  map.Routing.routeType := rtTruck;


  Tile Server ArcGis World_Ocean_Base

  map.TileServer := tsArcGisWorldOceanBase;

  Tiles Server OpenRailWayMap.org

  var o : TECOverlayTileLayer;

  // default style
  o :=  map.AddOverlayTileServer(tsOpenRailWayMap);
  // other styles
  o.MapStyle := 'maxspeed';
  o.MapStyle := 'signals';
  o.MapStyle := 'electrification';
  o.MapStyle := 'gauge';


  property TECGeoLocalise.Locale : string

  choice of language preference in TECGeoLocalise.OpenStreetMapReverse
  ( OpenStreetMapReverse is used by TNativeMapControl.Address ,
  TECNativeMap.GetAddressFromLatLng , TECShape.Address )


  map.Geolocalise.Locale := 'fr,en-US';



  4.7.1

  BUG

  map.beginupdate / map.endupdate no longer works properly (thanks Christiano)


  FreeHand.Selection is reset to the default value (false) after a TECNativeMap.Clear (thanks fabrice)

  Routing

  Routing.OptimizeRoute is always true even when set to false (thanks fabrice)

  Routing.OptimizeRoute was not taken into account for MapBox

  TECNativeMiniMap

  FMX : does not work when rotating
  VCL : exception 'TECNativeMap has no parent window' in some circumstances

  TECShapeMarker bad hitbox when scale<>1

  regression group.fitbounds no longer works properly  (thanks Peter)

  SSL not activated for Bing Tiles (thanks Herv )

  ADD

  property TECClusterManager.ZoomWhenClicked : boolean  (default true)
  property TECCluster.ZoomWhenClicked : boolean  (default true)

  Allow or not the automatic zoom on the markers contained in the cluster when clicking on it

  map.OnClusterClick := doOnclusterClick;
  ...
  procedure TForm.doOnclusterClick(sender: TObject; const Cluster: TECCluster);
  begin
  cluster.ZoomWhenClicked :=  Cluster.count>10;
  end;


  property TNativeMapControl.TabOrder
  property TNativeMapControl.TabStop
  property TNativeMapControl.CanFocus (fmx)

  procedure TNativeMapControl.fitBounds(const shapes:array of TECShapes);

  adapts the zoom of the map to display all the groups passed in parameters

  map.fitBounds([map['g1'],map['g2']]);

  With MapBox the optimized routes do not form a loop (start=finish),
  if you want to activate this option add the parameter 'roundtrip=true' to your query

  map.Routing.Request(RouteStart.Text, RouteEnd.Text,'roundtrip=true');

  KeyBoard demo for controlling TECNativeMap with keys

  the points of a line or a polygon in edition mode have a _LPEDIT_ property at true
  we can style them with a rule like
  map.Styles.addRule('._LPEDIT_:true {scale:1.4;}');


  limitation of the empty screen effect when panning and zooming
  when the tiles are not already in memory

  property TECShape.TagObject : TObject;


  4.7 Septembre 2022

  BUG

  When the mouse hovers over the geofences,
  the display of the hint triggers the OnEnterGeofence event

  Firemonkey

  after some zoom in zoom out, the cached tiles might not have exactly
  the right size and were displayed blurry

  VCL

  the mouse wheel zoom does not work in a modal subwindow (thanks Frederic)

  CHANGE

  MapZen and MapQuest routing services are no longer available,
  they are replaced by OpenStreetMap routing


  ADD

  property TNativeMapControl.OnErrorConnexion : TNotifyEvent

  Triggered when loading tiles on the internet and there is no internet connection.

  OnlyLocal is then set to true to avoid continuing to trigger an exception.
  OnlyLocal will not be automatically set to false when the connection comes back,
  you will have to do it manually

  property TNativeMapControl.OnShapeFocus : TNotifyEvent;

  triggered when an element has the focus

  map.OnShapeFocus := doOnShapeFocus;
  ...
  procedure TFormNativePoi.doOnShapeFocus(Sender: TObject);
  begin
  caption := inttostr(TECShape(sender).IndexOf);
  end;


  property TNativeMapControl.OverPassApi.Layer

  OverPassApi layer support see : https://www.helpandweb.com/ecmap/en/layers.htm#OVERPASSAPI_LAYER


  property TNativeMapControl.OverPassApi.FilterPolygone : TECShapePolygone

  use a polygon to limit the search area

  map.OverPassApi.FilterPolygone := map['isochrone'].polygones[0]


  property TNativeMapControl.NbrThreadTile : TNbrThreadTile

  number of threads used to load the tiles

  map.NbrThreadTile := ttOne;
  map.NbrThreadTile := ttTwo;
  map.NbrThreadTile := ttFour;

  by default 2 thread on mobile, 4 threads for other platforms


  procedure TNativeMapControl.Move(const Direction:TECDirection;const DistanceKM:double);

  move the map in one direction (0..359 ), over a distance in km


  support IsoChrone : http://www.helpandweb.com/ecmap/en/roads.htm#ISOCHRONE

  Support routing engine Valhalla :  https://valhalla.readthedocs.io/en/latest/

  map.Routing.Engine(reValhalla);

  TomTom

  * support satellite tiles tsTomTomSat

  * support for 512 pixels tiles (not for satellite)

  * support routing engine
  map.Routing.Engine(reTomTom);

  * support layer traffic incident see https://www.helpandweb.com/ecmap/en/layers.htm#TOMTOM_TRAFFIC_INCIDENTS


  TECShapePOI

  new POIShape  poiDirectionSign

  TECShapeLine

  Path is the default property
  line[i] is now equivalent to line.path[i]

  Styles

  procedure ClearAddRule(const value:string)

  replace the old rules with new otherwise they will be processed and waste time unnecessarily
  this is equivalent to using ClearSelector before AddRule

  procedure addRules(const value:string);

  adds several rules at once

  map.styles.addRules('.line{color:red} .poi{color:blue}');

  new syntax for dark() and light()
  you can specify a strength index, default 32 if you don't specify anything

  map.Styles.addRule('.infowindow{bcolor:dark(red,128);color:light(red)}');


  InfoWindow

  property FontColor : TColor
  text color (default black)

  property BorderColor      : TColor
  property HoverBorderColor : TColor
  property BorderSize       : integer

  property XCurve : integer     (default 10)
  property YCurve : integer     (default 10)

  allows to adjust the radius of curvature for the iwsRoundRect style


  property PeakLink : TInfoWindowPeakLink (iwpNone, iwpArrowHead)

  iwpArrowHead draws a triangle that points to the geographical position

  The length and horizontal or vertical position of this arrow depend
  on the properties XAnchor and YAnchor (pixels offset from r el position)

  property ArrowLX : integer (default 12)
  property ArrowRX : integer (default 12)

  ArrowLX and ArrowRX manage the left and right width of the arrow


  support <center> tag to center a sentence or an image
  usage
  <h1><center>your text</center></h1>
  <center><img src=xxx></center>

  limitation for the text, there can be no other tags mixed with the text
  this does not work : <center><h1>your text</h1></center>


  Under Firemonkey support FillOpacity and Opacity


  procedure TNativeMapControl.BoundingBoxTiles(const _NELat, _NELng, _SWLat, _SWLng: double;
  var NELat, NELng, SWLat, SWLng: double);

  Round the latitude & longitude of the top-right and bottom-left corners
  to those of the nearest tiles

  procedure TNativeMapControl.BoundingBoxTilesScreen(var NELat, NELng, SWLat, SWLng: double);

  returns latitude & longitude of the top-right and bottom-left corners
  of the displayed view, these coordinates are rounded to the nearest tile

  TECGeofences

  add ZIndex property for fences

  map.Geofences.ZIndex := 50;

  Lines can be used as fences
  Allows you to be notified if your item enters or leaves the road
  By default the tolerance margin is 10 meters, use MargingMeter to change it

  line := map.shapes.lines.addLine;
  i   := map.Geofences.Add(line,'Line 1') ;
  // change tolerance margin to 5 meters
  TECLineGeofence(map.Geofences[i]).MargingMeter := 5;


  property TNativeMapControl.DrawPath : TECDrawPath

  Drawing of a road with the mouse or finger,
  the route can automatically follow a path for pedestrian, bicycle or car

  see doc : http://www.helpandweb.com/ecmap/en/roads.htm#DRAW_A_PATH_WITH_THE_MOUSE_OR_FINGER
  See also the DrawPath demo for a full explanation


  property TNativeMapControl.MouseX:integer;
  property TNativeMapControl.MouseY:integer;

  property TNativeMapControl.TimeMouseStop  : int64;
  property TNativeMapControl.OnMapMouseStop : TOnMapLatLng

  The event is triggered after the mouse has stopped moving
  for TimeMouseStop milliseconds (default 250)

  map.TimeMouseStop  := 500; // 500 millisecondes
  map.OnMapMouseStop := doOnMapMouseStop;
  ...
  procedure TForm.mapMapMouseMove(sender: TObject; const Lat, Lng: Double);
  begin
  ...
  end;



4.6  juin 2022

  CHANGE

  By default XAPILayer also displays surfaces in addition to points

  To hide the surfaces add the style
    map.Styles.addRule('#XAPI.polygone {visible:false}');


  A point is added to the center of the surfaces, to hide it define the style
    map.Styles.addRule('#XAPI.marker {if:polyid>-1;visible:false}');

  To find only the points like in the old version you have to modify your query like this

   map.XapiLayer.Search := 'node[restaurant]' // only points
   map.XapiLayer.Search := 'restaurant' // points and area


  if TECShape.Hint is empty,
  returns the content of the TNativeMapControl.DefaultHintProperty (default 'name') property

    map.DefaultHintProperty := 'address';
    your_marker.hint := '';
    your_marker['address']:='10 rue du pommier';
    // here hint show '10 rue du pommier'

  Permanent display of the hint as long as the element is hovered by the mouse

  map.HintInfoWindow.Group.DelayHint := 0;
  ...
  your_shape.DelayHint := 0;


  correction of property OnShapLongeClick in OnShapeLongClick



  BUG

   truncated display of the heatmap in certain circumstances  (thanks fabrice)

   TECShapeMarker.Fov the viewing angle was reversed

   TECShapeInfoWindow

    wrong height calculation in certain circumstances

   AV if we create a TECNAtiveMiniMap in the OnCreate of a form in Firemonkey (thanks ole)

   A TShape is destroyed twice when deleting TECNAtiveMiniMap under firemonkey (thanks ole)


   The routing engine of openstreetmap was not correctly interpreted anymore (thanks Peter)

   TNativeMapControl.NumericalZoom conversion error

    a numerical zoom of 17.5 is interpreted as a zoom of 22 (17+5)


  access violation if calling map.clear and map.freeHand is active

  The mouse wheel does not work if the map is in a dynamically created TTabsheet (thanks Pascal)

  map.FreeHand.OnSelection is triggered whatever mouse button is pressed
  even if it is not the one that activates the selection (thanks Ronald)

  ADD

   property TNativeMapControl.OnChangeTileServer : TNotifyEvent


   Styles : Support of images contained in a TImageList

    map.icons := your_imagelist;
    map.styles.addRule('.marker {graphic:1}'); // all markers display image number 1

   TNativeMapControl.DefaultHintProperty (default 'name')

   if TECShape.Hint is empty returns the content of the DefaultHintProperty property

   property TNativeMapControl.OverPassApi.PendingQuery

    indicates the number of pending requests


   property TECShapes.Opacity : byte

   Assigns an opacity (opacity and FillOpacity) for all elements of the group

   opacity varies from 0 to 100
   a value >100 ignores the opacity of the group
   and only takes into account the opacity of the elements

   initial opacity of the elements is not reset to the original value in case of value>100

   map.shapes.opacity := 50;
   map['group'].opacity := 100;


  support labels for TECShapeLine

    map.Shapes.Lines.Labels.Visible       := true;

   Impmort and Export TECShapes to CSV  (markers, pois, lines and polygones)

    Populate the Fields list with the properties you want to register
    Fields contains the fields of the last loaded CSV file, so if needed empty the list before adding your own fields
    no need to add fields for latitude, longitude and wkt,
    the properties FieldNameLatitude, FieldNameLongitude and FieldNameWKT will be used

    map.Shapes.CSV.Fields.clear;
    map.Shapes.CSV.Fields.add('street');
    map.Shapes.CSV.Fields.add('zip');

    You can load and save the geometry of elements in WKT format, essential for lines and polygons.
    for this you must fill in the field FieldNameWKT

    map.shapes.csv.FieldNameWKT := 'WKT';
    map['group'].csv.FieldNameWKT := 'WKT';

    map.shapes.savetofile('filename.csv');
    map['group'].LoadFromFile('filename.csv');

    The expected coordinates are in decimal degrees format,
    you can connect to OnConvertLatLng to convert your geometry

      // sample
      procedure ConvertLatLng(var lat,lng:double);
      begin
       Lat := Lat  / 1000000;
       Lng := Lng / 1000000;
      end;

      procedure TForm.FormCreate(Sender: TObject);
      begin
        map.shapes.CSV.OnConvertLatLng := ConvertLatLng;
      end;


   property TecCSV.OnFilterCSV : TOnFilterCSV

    Allows you to reject a line in the CSV file based on specific criteria

    // filter csv data
    map.shapes.CSV.OnFilterCSV := doOnFilterCSV;
    ...
    // valid csv data , default true
    procedure TForm29.doOnFilterCSV(const Data: TStringList;var validCSV:boolean);
    begin
      if (data.Count>2) and (pos('POLYGON',data[7])<1) then
      validCSV := (data[2]<>'relation');
    end;


   property TecCSV.OnCreateWKTObject : TOnCreateWKTObject

    By connecting to this event you will be able to modify the properties
    of the imported elements in WKT format

     map['group'].CSV.OnCreateWKTObject := doOnCreateWKTObject;
     // fired after creation wkt object
     procedure TForm.doOnCreateWKTObject(const Group: TECShapes;
                                         const WKTObject: TECShape;
                                         const Lat, Lng: double;
                                         const Data: TStringList);
    begin
     // we calculate its color according to its index number
     if WKTObject is TECShapePolygone then
     TECShapePolygone(WKTObject).FillColor := GetHashColor(inttostr(WKTObject.IndexOf))
      else
     WKTObject.Color := GetHashColor(inttostr(WKTObject.IndexOf));
    end;


   Export of selected elements to geoJSON, CSV and GPX formats in addition to KML and Text formats

     map.Selected.SaveToFile('file.json');
     map.Selected.SaveToFile('file.csv');
     map.Selected.SaveToFile('file.gpx');
     map.Selected.SaveToFile('file.kml');
     map.Selected.SaveToFile('file.txt');

     json_string := map.Selected.toGeoJSON;
     csv_string  := map.Selected.toCSV;
     gpx_string  := map.Selected.toGPX;
     kml_string  := map.Selected.toKML;
     txt_string  := map.Selected.toTxt;


   property TNativeMapControl.ShapeDragMode : TShapeDragMode (sdmShape,sdmMultiShapes)

   Selects the operating mode when moving an element with the mouse

     sdmShape : default mode, only the element pointed by the mouse is moved

     sdmMultiShapes : if the element pointed by the mouse has its selected property set to true,
                      then all the selected draggable elements (selected = true) are moved while keeping the same distance between them.

                      otherwise it is equivalent to sdmShape


   property TLabelShape.UseScaleMarkerToZoom:boolean   (default false)

    synchronize scaling with TNativeMapControl.ScaleMarkerToZoom

     map['group_xyz'].Markers.Labels.UseScaleMarkerToZoom := true;

  TECNativeFreeHand.OnPermission : TOnFreeHandPermission

  controls the activation of FreeHand

  map.FreeHand.Selection                := True;
  map.FreeHand.OnPermission             := doOnFreeHandPermission;
  ...
  // selection with freeHand is only allowed if CTRL or SHIFT is pressed
  procedure TForm1.doOnFreeHandPermission(sender : TObject;var valid:boolean);
  begin
  valid := (((GetKeyState(VK_CONTROL) and $8000) = $8000) or
  ((GetKeyState(VK_SHIFT) and $8000) = $8000)
  );
  end;

  support for cluster styles

  map.shapes.ClusterManager.Style   := csEllipse; (default)
  map.shapes.ClusterManager.Style   := csTriangle;
  map.shapes.ClusterManager.Style   := csRect;
  map.shapes.ClusterManager.Style   := csStar;
  map.shapes.ClusterManager.Style   := csDiamond;
  map['group'].ClusterManager.Style := csHexagon;


  allows the modification of the style in

  ClusterManager.OnColorSizeCluster(const Cluster: TECCluster; var Color: TColor;
  var BorderColor: TColor; var TextColor: TColor;
  var WidthHeight, FontSize: integer;var CStyle:TClusterStyle)


  new style selectors for groups

  #Group:hover
  #Group:selected
  #Group:pressed
  #Group:focused

  // style applied if an element of the group is hovered by the mouse
  map.Styles.addRule('#group_name:hover {color:white}');
  // style applied if an element of the group is pressed
  map.Styles.addRule('#group_name:pressed {color:red}');


  TECNativeFreeHand.OnValidSelection : TNotifyEvent;

  allows you to validate the list of selected items.
  example to deselect the already selected elements

  map.FreeHand.OnValidSelection := doOnValidSelection;
  // start selection mode
  map.FreeHand.Selection := true;
  ...
  procedure TForm.doOnValidSelection(sender: TObject)  ;
  var i:integer;
  begin

  i := 0;
  while i < map.FreeHand.SelectionList.Count-1 do
  begin
  if map.FreeHand.SelectionList[i].Selected then
  begin
  map.FreeHand.SelectionList[i].Selected := false;
  map.FreeHand.SelectionList.Delete(i);
  end
  else inc(i);
  end;

  end;



  TNativeMapControl.FocusedShapeWhenClicking : boolean

  gives focus or not to the clicked element (default true)

  map.FocusedShapeWhenClicking := false;


  TNativeMapControl.FocusedShapeWhenHovering : boolean

  displays the hovered element in the foreground (default false)

  map.FocusedShapeWhenHovering := true;


  TECShape.ShowHintAfter  : cardinal
  TECShapes.ShowHintAfter : cardinal

  delay in milliseconds before the hint of the mouse over element is displayed, default 0

  mrk.ShowHintAfter := 1000; // 1 seconde

  map.group['test'].ShowHintAfter := 500; // 0.5 seconde


  new value for TLabelShape.ColorType allows you to individualize the label colors for each element

  map.Shapes.Markers.Labels.ColorType := lcProperty;

  // you can use several formats to define your colors
  mrk['fontcolor']   := 'rgb(255,0,127)';
  mrk['fillcolor']   := 'red';
  mrk['bordercolor'] := '#10ee55';


4.5

  BUG

   No support for FillOpacity, BorderColor, PenStyle and DashStyle in LoadFromFile and SaveToFile for TECShapePOI (thanks gilles)

   No support for PenStyle and DashStyle in LoadFromFile and SaveToFile for TECShapeLine and TECShapePolygone

   OnlyLocal was not always respected (thanks jaap)

   TECCartoStyles.ClearSelector

    the style is released but not deleted from the list, AV when the map is destroyed

   in editable mode the polygons are drawn only from the 3rd point

   stack overflow marker.seticon := xx  (thanks gilles)

   Regression crash width map.LocalCache:='' (thanks gilles)

   Loss of display when zooming with POIs in editable mode (thanks gilles)

   Style

     light(color) and dark(color) does not work

     map.Styles.addRule(':hover {color:light(@hand);bcolor:dark(@hand)}');


   ZoomScaleFactor regression

   map.ZoomScaleFactor := 400 should be the equivalent of zoom+4 and not zoom+1


   Hint infowindows are not always displayed over elements.

   TECShapeMarker.graphic := bitmap does not change the size of the marker (thanks Herv )

   regression :  wrong positioning of the zoom after a double click (thanks Andreas)

   Under Firemonkey there is an offset of the map under Windows 10 and 11
   if you use a text resolution of 125% and more

   UseInfoWindowDescription does not work correctly on android (thanks Laszlo)

   two-finger zoom

   The zoom is not centered around the contact point but in the center of the map (thanks Laszlo)

  CHANGE

   in editable mode you can delete a point from the lines and polygons by a long click on it (0.5s by default)
   this duration is modifiable through the property TimeLongClick

     map.TimeLongClick := 400; // 0.4s

   a TECShapePOI in editable mode is not groupable in a cluster

   The mapbox raster tiles are now 512 x 512 so you need to specify a tile size of 512

    map.TileSize := 512;
    map.TileServer := tsMapBoxStreets;

    To access all available raster tile styles use the tsMapBoxStreetsBasic server and specify a style

    map.TileSize := 512;
    map.TileServer := tsMapBoxStreetsBasic;
    map.TileServerInfo.MapStyle := 'navigation-day-v1';
    map.TileServerInfo.MapStyle := 'navigation-night-v1';
    map.TileServerInfo.MapStyle := 'light-v10';
    map.TileServerInfo.MapStyle := 'dark-v10';



   two-finger zoom

    the zoom does not automatically switch to a full zoom but stays on the intermediate value

    use map.FullZoomAfterGestureZoom := true to restore the old behavior

    Activation of DIRECT_PAINT_TO_FORM mode for a sharper display when rotating the map.

    But the infowindows are not displayed vertically,
    to cancel the rotation of the map automatically when opening an infowindow add the code

    map.NoInfoWindowRotation := true;

    To disable DIRECT_PAINT_TO_FORM open the file Delphi_Versions.inc
    comment out the line {$DEFINE DIRECT_PAINT_TO_FORM} at the end of the file


  ADD

    property TECRouting.EngineDownload : TECThreadRoutingDownload

    Allows you to manage the way in which road data is downloaded, Get or POST for example

     map.routing.EngineDownload := doEngineDownLoad;
     ...

     procedure doEngineDownLoad (sender:TECThreadDataRoute; var StringStream : TStringStream );
     begin

       // ! Be careful here you are not in the main thread anymore

      // sender.url

      // fill StringStream with your data

     end;


    cyclOSM tile server (https://www.cyclosm.org)

     map.TileServer := tsCyclOSM;

    property  TECShape.OnShapeLongPress(sender : TObject;const item: TECShape);

     event triggered by a long press (without releasing) on an element
     Sender is the map and Item is the pressed element


    property TNativeMapControl.EditShape  : TECShape ;

    contains the element that in editable mode.
    example of use direct creation of a line when clicking on the map

     procedure TForm1.MapClick(sender: TObject; const Lat, Lng: Double);
     var aLine : TECShapeLine;
     begin

       if (map.editshape is TECShapeLine) then
        aLine := TECShapeLine(map.editshape)
       else
       begin
        aline := map.addLine;
        aline.editable := true;
       end;

      aline.Add(plat,plong);


     end;

   support nautical scaling and simultaneous calculation of multiple scale units (thanks jaap)

   OnMapMouseWheel = procedure(sender: TObject; const wheelDelta:integer);


4.4

  BUG

  flickering when hovering over an element in multi-view mode

  Bad display if several markers were in editable mode   (thanks gilles)
  Only one element should be in editable mode at a time

  Firemonkey

  Marker.filename := 'file.svg'

  only the first Path was taken into account


  ZoomScaleFactorAround & ZoomScaleFactor

  // Progressive zoom from zoom 1 to beyond max zoom
  map.ZoomScaleFactor := ZoomScaleFactor + 10

  // zoom out
  map.ZoomScaleFactor := ZoomScaleFactor - 10


  when selecting a Bing tile server, the map.LocalCache is reset to "" (thanks herv )

  TNativeMapControl.Routing.RouteType=rtBicycle with OpenStreeMap and OSRM

  Multiple requests to TNativeMapControl.Routing were not correctly stacked

  AnimRotationAngle works only in one direction

  function TECShapeLine.Add(const dLine: TECShapeLine): integer

  the last point is not added

  CHANGE

  property Rotation : TLabelShapeRotation (lsrRotation,lsrNoRotation,lsrHideRotation) (default lsrRotation)

  with lsrHideRotation the labels are not displayed when the map is rotated

  ADD

  Delphi 11 support

  CartoTrack demo designed for mobile devices and presenting the main features of the component

  The text of the clusters remains horizontal even if the map is rotated (thanks jaap)

  property  TNativeMapControl.NumericalZoom : double

  group Zoom & ZoomScaleFactor

  map.NumericalZoom := 20.05;
  // is the same then
  map.zoom := 18;
  map.ZoomScaleFactor := 250;

  property  TNativeMapControl.OnLongPress(sender : TObject);

  The event is triggered if you press the map or an element for more than TimeLongClick ms (default 500ms)
  sender is either the map or a TECShape element

  map.TimeLongClick := 400; // 0.4s
  map.OnLongPress := doLongPress;
  ...
  procedure TForm.doLongPress(Sender: TObject);
  begin
  //
  end;

  unlike OnLongClick, OnLongPress is triggered before the pressure is released


  Firemonkey

  Optimization of the svg markers display

  TECShape

  function Focused : boolean
  property Focusable : boolean;

  set focusable to false to prevent the element from taking the focus

  by default when you click on an element it takes the focus,
  an element that has the focus is displayed on top of all others regardless of the zindex

  use setFocus and unFocus to manage the focus by code

  only one element can have the focus,
  when you give the focus to an element the one who had it loses it


  Styles

  Support for :Pressed and :Focused status on the same kind as :Hover and :Selected

  :Pressed it is activated as long as you press an element

  map.Styles.addRule(':pressed        {scale:2}');
  map.Styles.addRule('.marker:focused {color:red}');

  Defines a style rule applicable if a property contains a value, any value except empty

  map.Styles.addRule('.guidance:*   {styleicon:svg;}');
  map.Styles.addRule('.line.speed:* {weight:6;}');


  TLabelShape

  property ShowOnlyIf : TLabelShowOnly  (default lsoAll)

  Filter the labels to be displayed
  possibility  : lsoAll,lsoSelected,lsoPressed,lsoHover,lsoFocused

  // display the label only when you press the marker
  map.shapes.markers.labels.ShowOnlyIf := lsoPressed;

  on mobile lsoHover is identical to lsoPressed


  property MaxWidth : integer

  MaxWidth limits the width of labels that are not multi-line,
  the excess text is replaced by ...
  Set to 0 (default value) to display the full text


  property TLabelShape.FillOpacity : byte (0.100)

  adjust the transparency level of the label background

  map.shapes.markers.labels.fillOpacity := 70; // 70%



  property TECShapes.PropertyValue[string]:string

  As for the elements you can store values directly at the group level
  If a value does not exist at the element level, the value at the group level is returned

  map.shapes['key'] := 'value';

  all the elements of the group inherit it


  property TECShapes.Selected : boolean;

  selects or deselects all elements of a group

  map['test'].selected := true;

  TECShapes.Selected returns true if at least one of the elements is selected


  Selected also exists for lists of items

  map['test'].markers.Selected   := true; // selects all markers of test group
  map['test'].pois.Selected      := true;
  map['test'].lines.Selected     := true;
  map['test'].polygones.Selected := true;



  property TECShapeMarker.BorderColor
  property TECShapeMarker.BorderSize


  ign free tileserver for France ( https://geoservices.ign.fr )

  you have access to the base map, imagery and scans of the paper maps
  For the first 2 you don't need a key, for the scans you will have to get one


  map.TileServer := tsIgn; // base map
  map.TileServerInfo.MapStyle := '';
  map.MaxZoom := map.TileServerInfo.MaxZoom;

  map.TileServer := tsIgn;
  map.TileServerInfo.MapStyle := 'IMAGERY';
  map.MaxZoom := map.TileServerInfo.MaxZoom;

  map.TileServer := tsIgn;
  map.TileServerInfo.MapStyle := 'SCAN';
  map.MaxZoom := map.TileServerInfo.MaxZoom;
  map.IgnKey := 'your key';


  TECShapeMarker

  added SVG constant to define Markers in FMX


  mrk.StyleIcon := siSVG;

  case random(4) of
  0 :   mrk.filename := SVG_PIN_HOLE;
  1 :   mrk.filename := SVG_PIN;
  2 :   mrk.filename := SVG_ROUND_PIN_HOLE;
  else  mrk.filename := SVG_ROUND_PIN;
  end;


  TECShapePolygone

  Add a property asHole to determine if a polygon contains holes

  Holes in a polygon have a HoleParent:TECShapePolygon property that points to the parent
  Holes immediately follow their parent in the polygon list

  You can adjust the style of a polygon that contains holes with a rule of this type

  map.styles.addRule('.polygone {if:ashole=true;fcolor:yellow;} ');



  4.3 juillet 2021

  CHANGE

  Mapillary (v4) support only for Delphi 10.x and higher
  The demos have been updated as well as the documentation

  BUG

  Tile servers that use styles are not stored in the correct local directory
  (e.g. tsTopPlusWebOpen and tsTopPlusWebOpenGrey)  (thanks Jurgen)

  Large screenshots outside the visible area did not end

  TECDownLoadTiles did not work if the map used overlays (thanks P ter)

  On Android GetHashColor return allway white color


  Polygones.Labels crash if ColorType = lcShape    (thanks DUAN)


  Bad json export if a property was framed by " (thanks DUAN)


  Regression :

  possible parasitic lines when changing zoom for polygons and lines

  map.endupdate , shapes.fitbounds : lines and polygones are not automatically displayed


  PropertyValue  (thanks Jaap)

  confusion with properties like "index_name" and "name"

  if index_name is declared before name then propertyValue["name"]
  will return the value of propertyValue["index_name"]



  ADD

  TECAnimationCustom

  shape.animation := TECAnimationCustom.create;
  shape.animation.timing := 3000; // 3s
  shape.animation.OnExecute := doExecute;
  ...
  procedure formx.doExecute(sender:TECShape);
  begin
  // your code here
  //  stop := true; for pause animation
  // shape.animation.reset for restart animation
  end;



  TECClusterManager.clickable : boolean (default true)


  support https://www.opentopodata.org/ for default api altitude

  property TLabelShape.ShadowText : boolean
  property TLabelShape.ShadowTextOffset : byte


  4.2 mai 2021


  BUG

  styles are not correctly applied to markers of type siText (thanks Jaap)

  an overflow error occurs when the minimum limits of the map are reached with certain projections (thanks Pier)

  GetLatLngFromAddress was not working on mobile (thanks herv )

  the extrusion of the polygons (level := x meters) did not work correctly anymore

  function TECNativeFreeHand.AddLine(const GroupName: string = ''): TECShapeLine;
  function TECNativeFreeHand.AddPolygone(const GroupName: string = ''): TECShapePolygone;

  return an invalid result (thanks Henk)



  ADD

  function TNativeMapControl.GetMouseColor:{$IFDEF UseFMX}TAlphaColor{$ELSE}TColor{$ENDIF};
  function TNativeMapControl.GetXYColor(const X,Y:integer):{$IFDEF UseFMX}TAlphaColor{$ELSE}TColor{$ENDIF};

  returns the color under the mouse or at the X,Y position


  In addition to the right click you can also leave the editable mode of lines
  and polygons by a long left click on the last point

  Optimization of the display of lines and polygons,
  faster movement and zoom when the map contains hundreds of thousands of them.


  Shorcuts for groups

  function TECShapes.addMarker(const Lat, Lng: double) : TECShapeMarker;
  function TECShapes.AddPOI(const Lat, Lng: double)    : TECShapePOI;
  function TECShapes.AddLine: TECShapeLine;
  function TECShapes.AddEncodedLine(const EncodedLine: string; const precision: byte = 5): TECShapeLine;
  function TECShapes.AddLine(const dLatLngs: array of double): TECShapeLine;
  function TECShapes.AddLine(const dLine: TECShapeLine)  : TECShapeLine;

  function TECShapes.AddPolygone : TECShapePolygone;
  function TECShapes.AddPolygone(const dLine: TECShapeLine): TECShapePolygone;
  function TECShapes.AddEncodedPolygone(const EncodedLine: string; const precision: byte = 5): TECShapePolygone;
  function TECShapes.AddPolygone(const dLatLngs: array of double): TECShapePolygone;

  my_marker := map['my_group'].addMarker(latitude,longitude);
  my_poly   := map['my_group'].addPolygone([lat1,lng1,lat2,lng2,...,latx,lngx]);


  Groups can load and save CSV files  ( see DemoCSV )

  map.loadfromfile(csv_file) (load in default group => map.shapes.loadfromfile(csv_file)  )

  if map.groups['group_name'].loadfromfile(csv_file) then map.groups['group_name'].fitbounds

  by default the component looks for latitude and longitude in the name fields "latitude" and "longitude"
  you can change it this way

  map.shapes.csv.FieldNameLatitude  := 'lat';
  map.shapes.csv.FieldNameLongitude := 'lng';

  If the geographical position is grouped in a single field then indicate it in
  FieldNameLatitude and leave FieldNameLongitude empty

  Indicate in DelimiterLatLng the character that delimits the latitude and longitude ( by default "," )

  map.Shapes.CSV.FieldNameLatitude := 'centroide';
  map.Shapes.CSV.FieldNameLongitude := '';
  map.Shapes.CSV.DelimiterLatLng := ';';


  if the first line of the csv file does not indicate the names of the fields,
  you can indicate directly the index of the fields containing the latitude and longitude
  You must also empty FieldNameLatitude and FieldNameLongitude

  map.Shapes.CSV.FieldNameLatitude := '';
  map.Shapes.CSV.FieldNameLongitude := '';
  map.Shapes.CSV.idxLatitude := 10;
  map.Shapes.CSV.idxLongitude := 11;

  by default the fields are delimited by ',' you can change it this way

  map.shapes.CSV.Delimiter := ';';


  The data of the other fields will be imported into the elements with PropertyValue[field_name]:=field_value
  If the field names are not indicated in the first line,
  then a name will be made with the file name without the .csv extension + the index number

  By default the elements are red markers of type siFlat
  You can manually create the element (marker or Poi) by connecting to OnCreateCSVPoint

  map.Shapes.CSV.OnCreateCSVPoint := doCSVPoint;

  // Data contains the values of each field, you can use it to define your element
  procedure TForm20.doCSVPoint(const Group: TECShapes; var CSVPoint: TECShape; const Lat, Lng: double; const Data:TStringList)  ;
  var i:integer;
  begin
  // if you don't want to import this element return CSVPoint := nil

  // The elements will be pois stars
  i := Group.Pois.Add(lat,lng);
  CSVPoint := Group.Pois[i];
  TECShapePOI(CSVPoint).POIShape := poiStar;
  end;


  You can also load from a Stream or load ASynchronously (in a thread)

  map.Shapes.CSV.LoadFromStream(stream:TStream):boolean;
  map.Shapes.CSV.ASyncLoadFromFile(filename:string):boolean;
  map.Shapes.CSV.ASyncLoadFromStream(stream:TStream):boolean;


  procedure map.Shapes.CSV.SaveToFile(const filename: string;const ShapeList:TECShapeList);

  Populate the Fields list with the properties you want to register
  Fields contains the fields of the last loaded CSV file, so if needed empty the list before adding your own fields
  no need to add fields for latitude and longitude, the properties FieldNameLatitude and FieldNameLongitude will be used

  map.Shapes.CSV.Fields.clear;
  map.Shapes.CSV.Fields.add('street');
  map.Shapes.CSV.Fields.add('zip');
  map.Shapes.CSV.SaveToFile(filename,map.shapes.Markers);


  TileServer tsHotOsm

  property TNativeMapControl.ColorFilter : TECFilterColor

  Allows you to change the colors of the tiles

  In VCL mode you have only the gray filter

  map.ColorFilter.filter := fcGrey;
  // normal color
  map.ColorFilter.filter := fcNone;

  under Firemonkey you can also have Light and Dark modes

  // dark mode
  map.ColorFilter.filter := fcDark;
  // change the darkening value (default 32)
  map.ColorFilter.DarkValue := 64;
  // light mode
  map.ColorFilter.filter := fcLight;
  // change the Lightening value (default 16)
  map.ColorFilter.DarkValue := 8;


  In Firemonkey you can also keep or replace colors without them being modified by the filter

  var c:TAlphaColor;
  ...
  TAlphaColorRec(c).R := 247;
  TAlphaColorRec(c).G := 250;
  TAlphaColorRec(c).B := 191;

  map.ColorFilter.Colors.Add(c);
  map.ColorFilter.ActionColor := acKeep;
  ...
  map.ColorFilter.Add(Old_color_1);
  map.ColorFilter.Add(New_color_1);
  map.ColorFilter.Add(Old_color_2);
  map.ColorFilter.Add(New_color_2);
  map.ColorFilter.ActionColor := acReplace;


  by default a tolerance of 1% is applied to the colors to keep or replace, you can pass to 10% in this way

  map.ColorFilter.Tolerance := 0.1;



  property TNativeMapControl.DontScaleMarkerToZoomIfSelected : boolean

  if the element is selected its size will be independent of the map zoom


  Conversion UTM GWS 84

  procedure TECNativeMap.LatLngToUTM(const Latitude,Longitude:double;
  var   UTMNorthing, UTMEasting : double;
  var   UTMZone: String);

  procedure TECNativeMap.UTMToLatLng(const UTMNorthing,  UTMEasting : double;
  const UTMZone : String;
  var Lat, Lng : double);



  property TNativeMapControl.OnMapFitBounds: TNotifyEvent

  the event is called when a fitBounds has been finalized
  sender will contain the object that requested the fitBounds


  function TNativeMapControl.GetPositionOnMap(const Lat,Lng:double):TPositionOnMap;

  returns the zone containing the geographical position, works even if the map is rotated

  The visible portion of the map is cut into a 3*3 grid.

  TPositionOnMap = (pmOutside,
  pmTopLeft,pmTop,pmTopRight,
  pmLeft,pmCenter,pmRight,
  pmBottomLeft,pmBottom,pmBottomRight);




  CHANGE

  Only TECShapeMarker and TECShapePOI have a TrackLine property

  Marker and Pois styles are taken into account for label display when TLabelShape.ColorType = lcShape


  

4.1 Janvier 2021

  BUG

  Exception when importing GeoJSON file with geographic coordinates like 651e-5

  TECShapePolygone.toTxt := xxx
  TECShapeLine.toTxt     := xxx

  memory leak with if the element was not emptied before

  TECShapePolygone.CopyToGroupAndRemove
  TECShapeLine..CopyToGroupAndRemove

  Memory Leak 1 TECPointLine

  The use of an image in an infowindow caused infinite redrawing

  An access violation occurs when using OnlyOneOpenInfoWindow if the last used window has been destroyed.


  TECShapeLine.remove and TECShapePolygone.remove does not erase direction points

  TECShapePolygone.ShowDirection := true|false causes a STACK OVERFLOW


  ADD

    support of extension tags for GPX format, they are stored in the properties

     line.PropertyValue['gpxx:DisplayColor']


    procedure TNativeMapControl.Selected.UnSelectedAll;
    function  TNativeMapControl.Selected.UnSelectedByKeyValue(const key, value: string): integer;
    function  TNativeMapControl.Selected.UnSelectByArea(const SWALat, SWALng, NEALat, NEALng: double): integer;
    function  TNativeMapControl.Selected.UnSelectByKMDistance(const FLat, FLng,  FKMDistance: double): integer;
    function  TNativeMapControl.Selected.All: integer;



  TECBoundary.Address(value:string):integer

  Find the administrative boundaries for this address
  returns the number of items found

  TECBoundary.Items: TECShapesList

  list of items (TECShapePolygon, TECShapeLine) found by Address, Administrative or Filter

  TECBoundary.FitBounds

  Show all items

  CHANGE : TECBoundary.Administrative and TECBoundary.Filter returns the number of items found

  // display the polygons of the city of New York
  j := map.Boundary.Address('New York');

  for i := 0 to j-1 do
  begin

  map.Boundary.items[i]

  end;

  the BoundaryArea demo has been updated



  Pois support PenStyle and setCustomDash   (like Lines and Polygons)

  poi1.PenStyle := psDash;

  poi2.PenStyle := psUserStyle;
  poi2.setCustomDash([8,16,4,8,32,48]);


  function LocationDirection(lat1,lng1,lat2,lng2:double):TLocationDirection; (unit uecMapUtil)

  Returns a geographical indication of the position of point2 in relation to point1.

  TLocationDirection = (ldUnknown,ldNorth,ldNorthEast,ldEast,ldSouthEast,ldSouth,
  ldSouthWest,ldWest,ldNorthWest);


  function TECShape.LocationDirectionTo(value: TECShape) : TLocationDirection;


  property TNativeMapControl.EditShadowLine : TECShapeLine

  Access to the line that indicates the future trace of a TECShapeLine or TECShapePolygon in editable mode

  map.EditShadowLine.visible := false;

  For polygons, the trace also connects the future point to the first one to close the polygon.


  property TECShapeLine.PathChange : TPathChange    (pcDelete,pcAdd,pcMove)

  this property allows you to determine the type of change in OnShapePathChange and OnDblClickEditLine


  Polygones, Markers and Pois can display the Hint, Description or PropertyValue property
  as a label left, above, right , below or center them (see demo MarkerLabel)

  Labels are managed at group level

  map.Shapes.Markers.Labels.Visible       := true;
  map.group['groupX'].Pois.Labels.Visible := true;

  map.Shapes.Markers.Labels.LabelType := ltHint;
  map.Shapes.Markers.Labels.LabelType := ltDescription; // default

  with ltProperty fill in LabelProperty to specify the property to display

  map.shapes.Markers.Labels.LabelType     := ltProperty;
  map.Shapes.Markers.Labels.LabelProperty := 'lb_voie_ext';

  map.Shapes.Markers[0].PropertyValue['lb_voie_ext'] := 'line 1'+#13#10+'line 2'; // the text can be multi-line

  By default all visible elements can display their label, but you can condition it to the fact that it is selected

   map.shapes.Markers.Labels.OnlyIfSelected := true; // default false;


  By default the background color is the color of the element, use ColorType to set another color.

  map.shapes.Markers.Labels.ColorType := lcColor; // default lcShape
  map.shapes.Markers.Labels.Color     := claRed;


  by default the label is opaque, if you want it to use the transparency of the element
  toggle the Transparent property to true (only for firemonkey)

  map.shapes.Markers.Labels.Transparent := true;

  If you don't want a background, change the Style property.

  map.shapes.Markers.Labels.Style := lsTransparent;  // lsRectangle (default) or lsRoundRect


  when the map is rotated, the labels have no background but the text always remains horizontal.
  if you don't want the text to stay horizontal set the Rotation property to false

  map.shapes.Markers.Labels.Rotation := false; // default true


  use properties FontFamily, FontColor, FontBold, FontItalic and FontSize to modify the font
  when ColorType = lcShape then the color of the font will be either white or black depending on the best contrast


  Align allows to choose the position of the label

  map.Shapes.Markers.Labels.Align := laBottom; // default laTop, laLeft, laRight

  Margin allows to specify the distance between the label and the element

  map.Shapes.Markers.Labels.Margin := 10; // default 8

  MinZoom and MaxZoom allow you to define the zoom range in which the labels are displayed (default 10 and 22)

  MaxShow sets the maximum number of labels displayed for the group (default 1000).

  map.Shapes.Markers.Labels.MaxShow := 5000;

  The points of the lines consist of markers or pois,
  so you can activate the display of labels see http://www.helpandweb.com/ecmap/en/shapes.htm#LABELS_FOR_LINES



  TECShape.OnChangeEditable : TNotifyEvent

  triggers the event when the Editable property changes value



4.0.0  D cembre 2020

  BUG

  regression if you change the scale of an element when hovering the mouse,
  it does not return to its original value when the mouse leaves the element (thanks helene)

  Android : crash on fast phone style Samsung S20

  XapiLayer

  the roads were no longer correctly imported
  the search was not triggered at the right time


  in the mobile versions the dblclick does not work at maximum zoom (thanks Mario)

  the markers were not correctly scaled (thanks Mario)
  offset of the click area for the markers

  under windows GetAddressFromLatLng doesn't work anymore after the SSL update of OpenstreetMap (thanks markus)

  an OutOfResources exception was randomly triggered
  during multiple map resizing in VCL mode  (thanks Helene)

  Android TECShapePOI rotated text  (thanks radek)

  Now poi.rotation := true works
  the text always appears horizontal even after a rotation of the map

  map.GeoLocalise.AlignLatLngToRoute don't work on windows

  Indy crash on iOS with Delphi 10.4 (thanks mihai)

  zooming with the mouse wheel no longer works in vcl mode
  if the component is placed in a dynamically created frame  (thanks henk)

  Error CGEventSourceKeyState with MacOS64


  Add

  support of <ele> and <sym> tags for GPX format

  Bing tiles : tsBingCanvasDark, tsBingCanvasLight, tsBingCanvasGray

  tsBingRoad and tsBingAerialLabels now matches RoadOnDemand and AerialWithLabelsOnDemand
  because the old Road and AerialWithLabels values are no longer updated.

  support traffic flow

  map.TileServer := tsBingRoad;
  map.TileServerInfo.MapStyle := 'traffic';

  TECAnimationRadiusFov (only for TECShapeMarker)

  mrk.FovRadius := 30; // pixels
  mrk.fov := 360;      // 0-360
  mrk.Animation := TECAnimationradiusFov.create;



  procedure TECShapeList.Exchange(Index1, Index2: integer);

  map.shapes.markers.exchange(10,15);
  map.group['test'].pois.exchange(0,1);


  Firemonkey

  procedure TECanvas.Polylines(const Points: TPolygon; const DashStyle:TDashStyle;
  const Style: TPenStyle = psSolid);


  Change

  TECShape.Update is now public




3.9.1  Juin 2020

  BUG

  regression in VCL mode geofence circles are no longer transparent  (thanks markus)

  regression crash with screenshoots (thanks markus)

  with some layout 10.4 android crash at startup in setBounds (thanks frederic)

  TECDownLoadTiles

  pause does not work properly  (thanks Rossel)

  does not restart a download for the same area after it has finished downloading,
  some settings must be reset manually.  (thanks Rossel)

  does not work if you redefine GetTileFilename, you must specify TileServer := tsCustom before the modification

  FECDownLoadTiles.TileServer                     := tsCustom;
  FECDownLoadTiles.TileServerInfo.Name            := 'server_nename';
  FECDownLoadTiles.TileServerInfo.GetTileFilename := Form1.GetYourTiles;


  ADD

  support Delphi 10.4

  function  TECRouting.CountRequests:integer;
  Procedure TECRouting.ClearPendingRequests;

  tsTopPlusWebOpen and tsTopPlusWebOpenGrey tile server added

  see : https://gdz.bkg.bund.de/index.php/default/webdienste/topplus-produkte/wms-topplusopen-mit-layer-fur-normalausgabe-und-druck-wms-topplus-open.html

  map.TileServer := tsTopPlusWebOpen;
  map.TileServer := tsTopPlusWebOpenGrey;





  3.9   Mai 2020

  BREAKING CODE

  the procedure TileServerInfo.GetTileStream changes format and is no longer synchronized,
  you are in the context of the thread that loads the tiles, its index varies from 0 to 3

  procedure TForm.getTileStream(const ThreadIndex:integer;var TileStream: TMemoryStream;const x, y, z: integer);
  begin
  // here fill the stream with your tile
  // !! you are not in main Thread !

  // ThreadIndex 0..3

  end;

  procedure TForm.FormCreate(Sender: TObject);
  begin
  map.TileServerInfo.GetTileStream := getTileStream;
  map.TileServerInfo.Name := 'MyStream';
  // important to specify a manual management tiles
  map.TileServer := tsOwnerDraw;
  end;


  For Here tiles the Here_Id and Here_code keys are now obsolete,
  you have to go to your account here and generate an apiKey for REST

  https://developer.here.com/documentation/authentication/dev_guide/topics/api-key-credentials.html

  then you connect it to your map with map.hereApiKey := 'your_apikey'.

  you MUST activate ssl (map.ssl := true)


  BUG


  TECShapePOI resize anchors in editable mode do not reposition well after a zoom change

  range error on Android when fast double click with inertia scroll

  TECShapeMarker.CenterOnMap returns latitude and longitude 0 if there are several markers (thanks markus)

  if you call map.ScreenShots.ScreenShot(xxx) and if map.ScreenShots.OnScreenShot is not assigned
  app crash when you close

  TECNativePlaceLayer.Search causes memory saturation in case of malformed tags (thanks thore)

  The mouse cursor does not indicate that you can click on a Cluster when you do not move the mouse.

  the name and value used in item.PropertyValue[name]:=value could not contain a comma (thanks jaap)

  item['toto,titi'] := 'titi,toto';

  vertical shift of text in infowindows when the map is rotatedertical shift of text in infowindows when the map is rotated

  When using map.Beginupdate / map.EndUpdate Showdirection was not displayed when editing TECShapeLine (thanks frederic)

  regression with double click zoom
  if inertial scrolling is activated it causes the map to move.  (thanks R ssel)

  regression with drawing and free hand selection,
  if inertial scrolling is activated it causes the map to move.  (thanks ronald)

  regression the mini map causes a slight bounce when zooming in/out the main map  (thanks ronald)

  road calculation error with OpenStreetMap and OSRM if more than 2 points

  regression TECShapeMarker.StyleIcon := ifSVG was no longer working

  animation assigned in the OnShapeClick is automatically disabled (thanks markus)

  if you use TECShape.Infowindow, or UseInfoWindowDescription the infoWindow
  associated with an element is not automatically moved when the element is moved. (thanks olivier)

  ADD

  TNativeMapControl.UserAgent : string
  TECDownLoadTiles .UserAgent : string

  Allows the component to be identified by the tile servers
  With OpenStreetMap it is recommended to use your own user agent otherwise the download is slowed down.


  When the edit mode is activated for TECShapeLine & TECShapePolygon,
  a line connects the mouse to the last point of the element

  you can change the style of this line with map.Styles.addRule('#_EDIT_SHADOW_LINE_ {color:red;penStyle:dot}');

  If you right click on the last point of the line or polygon you disable the edit mode.

  in editable mode the elements are automatically moveable with the mouse

  Right click on a TECShapePOI resizing anchor in editable mode to exit this mode.


  property TECShapeLine.OnDragEdit         : TOnDragLine
  property TECShapeLine.OnDragEnd          : TOnDragLine
  property TECShapeLine.OnDblClickEditLine : TOnDragLine

  These properties will allow you to react to actions when lines or polygons are in editable mode.

  ShapePolygone.OnDragEdit          := doDragLine;
  ShapePolygone.OnDragEnd           := doDragLine;
  ShapePolygone.OnDblClickEditLine  := doDragLine;

  // cancel all
  procedure TForm.doDragLine(sender:TECShapeLine;const IndexPoint:integer;const NewLat,NewLng:double;var cancel:boolean);
  begin
  cancel := true;
  end;



  property TECShapePOI.FillOpacity : byte (0..100)

  adjusts the transparency of the background from 0 = totally transparent to 100 totally opaque

  property TECCirclegeoFence.RadiusMeter : integer;

  allows TECCirclegeoFence to be modified after its creation    (thanks jaap)


  TECShapes.OnClusterChange : TNotifyEvent;

  event triggered by any change in the number or content of clusters

  TECShapes.Clusters : TECClusters;

  Chained list of clusters in the group

  number of clusters in the group

  map.shapes.Clusters.count

  first cluster

  map.shapes.Clusters.Head

  last cluster

  map.shapes.clusters.last

  to browse all the clusters from the first to the last

  var C:TECCluster;
  ...
  C := map.Shapes.clusters.head;
  while C<>nil do
  begin
  // number of element in cluster
  C.Count;
  // next cluster in list
  C := C.Next;
  end;


  TNativeMapControl.setTileHeader(name,value)

  support custom header for tiles server
  you can now use servers that require authorization.

  map.setTileHeader('authorization','your_token');

  it is also available for the minimap

  FMiniMap.setTileHeader('authorization','your_token');


  support for FMX TImageList

  map.icons := imageList;
  mrk := map.addMarker(lat,lng);
  mrk.icon := 2;

  in VCL now you can use also TVirtualImageList

  map.icons := virtualimagelist

  markers that use icons from an imagelist can now rotate

  mrk.icon  := 2;
  mrk.angle := 15;

  You can use the <img> tag to display your icons in an InfoWindow,
  just pass the number in the src parameter

  mrk.infoWindow('<img src=2 width=48 height=48>');



  TNativeMapControl.Group[const Value: string] is the default property

  you can use map['group_name'] instead of map.group['group_name']

  TECShape.propertyValue is the default property

  you can use Item['name'] instead of Item.propertyValue['name'].


  function RoadDistance(const AddressPoints : array of string;
  const UrlEngine:string = 'https://routing.openstreetmap.de/routed-car/route/v1/driving/'):double; overload;

  function RoadDistance(const LatLngPoints : array of double;
  const UrlEngine:string = 'https://routing.openstreetmap.de/routed-car/route/v1/driving/'):double;

  function RoadDistance(const Shapes : array of TECShape;
  const UrlEngine:string = 'https://routing.openstreetmap.de/routed-car/route/v1/driving/'):double; overload;


  calculates the number of kilometres by road

  km := map.RoadDistance(['tarbes','toulouse','paris']);
  km := map.RoadDistance([lat1,lng1,lat2,lng2]);
  km := map.RoadDistance([mrk1,poi1,polygone1]);

  by default it's the OpenStreetMap routing engine that is used, it's based on OSRM,
  you can install it on your own server and pass the url in parameter

  km := map.RoadDistance(['tarbes','paris'],'your_OSRM_server/routed-car/route/v1/driving/');


  3.8.1

  BUG

    if you empty the last property and query the new content then there is a crash. (thanks gilles)

    shape.PropertyValue['prop']:='';
    s := shape.PropertyValue['prop']; // crash here if 'prop' is the last property

  3.8 : Janvier 2020

  BUG

  ArcGis tiles do not work with SSL, do map.ssl := false to download them.

  if we use a TAniIndicator some tiles don't draw without move map (thanks mihai)

  OnTilesTimeout is triggered even if all tiles on the map are displayed. (thanks mihai)

  erratic movement  of the map during a two-finger touchdown, more sensitive under ios (thanks mihai)

  New format for the OpenStreetMap routing engine (thanks olivier)

  stack overflow after moving a draggable + editable TECShapePOI (thanks gilles)

  regression 3.7.1 : map.Styles.Rules := '#mylines.Line {penStyle:dash}' don't work (thanks andreas)

  bad "user agent" for ios (thanks Mihai)

  crash in a rare and undetermined case during a click on an element
  at the code level (FShapesGroup.ShapeHover.Item is TECShapeInfoWindow)
  fix whith this syntaxe (FShapesGroup.ShapeHover.Item.ClassType = TECShapeInfoWindow) (thanks markus)


  ADD

  zoom enhancement

  tile server support from openstreetmap.de  ( tsOSMde )

  property TECOffScreenScreenShot.TileServer : TTileServer;

  map.ScreenShots.TileServer := tsOsm;


  procedure TECOffScreenScreenShot.OnBeforeScreenShot(const Map:TNativeMapControl);

  allows you to access the map from which the screenshots are taken, for example to change the tile server


  map.ScreenShots.OnBeforeScreenShot := doBeforeScreenShot ;
  ...
  procedure TFormPhoto.doBeforeScreenShot(const Map:TNativeMapControl);
  begin
  map.TileServer := tsOsm;
  end;



  Add vincenty direct and inverse distance from  http://delphiforfun.org/Programs/Library/LatLonDistanceTest.htm

  // distance in km
  function TECNativeMap.VincentyInverseDistance(lat1,lon1,lat2,lon2:double):double;

  // bearing in degree, Dist in Km
  procedure TECNativeMap.VincentyDirectDistance(Lat1,Lon1, Bearing, Dist: Double; var Lat2, Lon2: Double);


  procedure TECShape.SetDistanceBearing(const Kilometers, Bearing: double;const vincenty:boolean=false);

  moves an element according to a distance in kilometers and an angle in degree (0-360)
  to use the vincenti algorithm pass true as the last parameter


  property TNativeMapControl.TileServerOpacity:double;

  modifies the opacity of the base tiles

  map.TileServerOpacity := 0.5; // 50%


  procedure TECOverlayTileLayer.MoveTo(const value: integer) (thanks jaap)


  The download of a zone can be paused

  property TECDownLoadTiles.Pause:boolean;

  FDownLoadTiles.Pause := true; // stop
  FDownLoadTiles.Pause := false // resume


  it can also be resumed later from a determined position
  You must save the properties in order to be able to resume at this position later.

  property StartX             : integer
  property StartY             : integer
  property StartZoom          : byte
  property StartCountTiles    : integer
  property StartDownLoadTiles : integer


  property FromZoom             : integer
  property ToZoom               : Integer
  property NorthEastLatitude    : double
  property NorthEastLongitude   : double
  property SouthWestLatitude    : double
  property SouthWestLongitude   : double


  // resume
  procedure TECDownLoadTiles.DownLoadTiles(const FromZoom, ToZoom: Integer;
  const NorthEastLatitude, NorthEastLongitude,
  SouthWestLatitude,SouthWestLongitude: double;
  const StartX,StartY:integer;
  const StartZoom:byte;
  const StartCountTiles,
  StartDownLoadtiles:integer);



  procedure TECCartoStyles.ClearSelector(const Name: string);

  clear all styles for Selector

  map.styles.addrule('#G.line {a:xx;b:yy}');
  map.styles.addrule('#G.line {c:zz}');
  ...
  map.styles.ClearSelector('#G.line');

  Be careful once the style has been applied remove the rule
  will not change the impacted elements.



  3.7.1 : octobre 2019

  BUG

  under D7 and probably other older versions the component no longer compiles
  with an error "the type TECNativeMap is not fully defined" (thanks gilles)

  under android, Map frozen after zoom with two fingers
  in doMapGesture EventInfo.Flags never contains gfEnd
  which signals the end of gesture (thanks herv )

  Error importing GeoJSON file if the points have an altitude (thanks rick)

  Error importing GeoJSON if keys containing multiple values were not imported (thanks rick)
  They are now imported as a single string, you will have to extract the data manually

  key:[123,456,78] -> key = '123,456,78'
  key:{"keyA":"valueA","keyB":"valueB"} -> key = '"keyA":"valueA","keyB":"valueB"'

  ForceRefreshDisplayedTiles does not work, the cache is still used for read/write
  when it should only be used for writing to force the loading of new tiles (thanks olivier)

  LocalCache does not work properly with a UNC path (thanks olivier)

  TECShapePOI.setDirection wrong angle of rotation


  3.7 : septembre 2019

  BUG

  BoundingBox totally restricts the displayed area
  before unzoomed it displayed the surrounding area

  TECAnimationMoveOnPath

  no movement if the speed is low

  TECGeofences

  the last element could not be deleted with TECGeofences.Delete (thanks Jaap)

  Wrong angle for TECShapePOI (thanks Jaap)

  access violation when closing the form when using LocalArchive (thanks Alec)

  access violation when closing the form while an OSM file is loading

  KML

  error with hole polygons (thanks Joze)

  heatmap hide mousemove event
  HeatMap layer is not automatically displayed when it is made visible (thanks Jose)


  GeoJSON

  loss of the last character in the "properties" section
  preservation of the last character " in the "properties" section

  During inertial scrolling the OnMapMove event is not triggered (thanks herve)

  TECRouting.OnEngineValidUrl is not called for MapQuest

  automatic TECShapeLine simplification when ShowDirection is activated, it avoids having too many triangles on top of each other   (thanks Joze)


  ADD

  UnBoundingBox

  removes the visible area boundaries defined by Boundingbox


  support for the OpenStreetMap routing engine, this is the default choice

  it is based on OSRM, so the results are identical to reOSRM
  except that it has the profiles rtCar, rtPedestrian and rtBycyle

  map.routing.engine(reOpenStreetMap);
  // car
  map.Routing.RouteType := rtCar;
  // walking
  map.Routing.RouteType := rtPedestrian
  // by bike
  map.Routing.RouteType := rtBicycle


  support v5 Mapbox routing

  property map.routing.OptimizeRoute : boolean

  only MapBox (https://docs.mapbox.com/api/navigation/#optimization) and MapQuest support this feature


  function map.Routing.futureRoute:TECShapeLine

  return a empty line we can pass it to Request after attaching parameters
  that can be used when the route is available in onAddRoute

  Line := map.routing.futureRoute;
  Line.propertyValue['speed']:='20';
  // then empty string is for optionnal params, here none
  map.Routing.Request(RouteStart.Text, RouteEnd.Text,'',Line);



  function  TecNativeLineSelect.SelectionDistance:double;

  returns the distance of the selection in km


  TECShapeInfoWindow

  property FontSize:integer;
  property FontFamily:string;

  TECShapeLine, TECShapePolygone

  You can now define the length of dashes and spaces by passing an array containing couples of dash-space lenght

  line.penStyle := psUserStyle;
  line.SetCustomDash([4,4,2,4,4,4]);

  you can use in styles like this

  map.styles.addRule('#_DRAGZOOM_.line {weight:4;color:green;penStyle:userStyle;customStyle:4,4,2,4,4,4}');


  You can use TecAnimationDash to move the traits, and MoveFoward to indicate the direction of the animation.

  line.animation := TECAnimationDash.create;
  TECAnimationDash(line.animation).MoveForward := false;



  function TECShapeLine.DistanceBetweenIndexPoint(const idxA,idxB: integer): double;

  returns the distance between 2 index in km

  function TECShapeLine.DistanceBetween(ALat,ALng,BLat,BLng:double): double;

  returns the distance in km between 2 points located on the line.
  if the points are not on the line, they are replaced by the two nearest points on the line


  procedure TECShapeLine.Slice(ALat,ALng,BLat,BLng:double;Line: TECShapeLine);
  function  TECShapeLine.Slice(ALat,ALng,BLat,BLng:double;GroupName: string = ''): TECShapeLine;

  creation of a new line from a portion of a line
  if the points are not on the line, they are replaced by the two nearest points on the line



  function TECNativeFreeHand.AddLine(const GroupName:string=''):TECShapeLine;
  function TECNativeFreeHand.AddPolygone(const GroupName:string=''):TECShapePolygone;

  allows you to add the drawn plot directly to the map


  Mouse selection (DragRect) can now be extended outside the visible area


  property TECNativeMiniMap.ScreenShot: TBitmap;

  You can now get a screenshot of the mini map


  function TECShapeMarker.ToBitmap:TBitmap;
  function TECShapePOI.ToBitmap:TBitmap;

  saves the element in a TBitmap, useful if you need to display a legend for example

  WARNING : you must release the bitmap yourself when you no longer need it


  support styles for tsTomTomIncident and tsTomTomFlow

  var oc:TECOverlayTileLayer;
  ...
  // add overlay tiles for incident
  oc := map.AddOverlayTileServer(tsTomTomIncident);

  oc.MapStyle := 's1';
  oc.MapStyle := 's2';
  oc.MapStyle := 's3';
  oc.MapStyle := 'night';

  // mandatory, reset api key for overlay
  // use your key !
  map.TomTomKey := map.TomTomKey;


  oc := map.AddOverlayTileServer(tsTomTomflow);

  oc.MapStyle := 'absolute';
  oc.MapStyle := 'relative';
  oc.MapStyle := 'relative-delay';
  oc.MapStyle := 'reduced-sensitivity';
  // mandatory, reset api key for overlay
  // use your key !
  map.TomTomKey := map.TomTomKey;



  HeatMap

  procedure TECHeatmapLayer.Remove(const latitude, longitude: double; const Value: double);

  Delete the value (if any) located at the coordinate point Latitude,Longitude

  if you want to delete several points, set automaticUpdate to false
  and then call Update once all the deletion has been done



  VCL

  property OnDragDrop;
  property OnDragOver;
  property OnEndDrag;

  are now published and are therefore available


  TECCanvas.FillRectangle(rect: TRect)
  TECCanvas.FillRectangle(X, Y, X1, Y1: integer);
  TECCanvas.FillCircle(rect:TRect);

  supports transparency for the background

  // addition of a red background, 50% transparent for the marker
  mrk := master.Addmarker(lat,lng) ;
  mrk.OnBeforeDraw := doBeforeDraw;
  ...
  procedure TForm4.doBeforeDraw(const canvas:TECCanvas;var Rect:TRect;item:TECShape) ;
  begin
  canvas.FillOpacity := 50;
  canvas.brush.Color := clRed;
  canvas.FillRectangle(rect);
  end;



  CHANGE

  TECShape, TECShapes and TECBaseGeofence

  the Tag property is of type NativeInt


  !!! By default it is MapQuest's altitude calculation service that is used
  because open-elevation.com has load problems

  to switch from one to the other made

  map.GeoLocalise.ApiAltitude := altOpenElevation;
  map.GeoLocalise.ApiAltitude := altMapQuest;

  ! For mapquest you must provide your own key , map.MapQuestKey = 'your_key'.

  You can connect your own procedures if you want to use other services

  procedure your_getAltitude(const LocalCache:string;const Latitude,Longitude:double;var altitude:double);
  begin
  // put result in altitude
  end;

  procedure your_getAltitudes(const LocalCache:string;const sLatLngs: string;var altitudes:string);
  begin
  // sLatLngs = lat1,lng1,lat2,lng2...
  // put results in altitudes ( '310,120,158' )
  end;





  3.6.2

  BUG

  ANDROID

  drawing with the wrong definition for TECShapePOI

  10.3.1 Freeze the map when downloading to fix we use indy instead of TNetHttpClient

  see https://quality.embarcadero.com/browse/RSP-23742

  ADD


  support tiles raster HyddaFull from OpenStreetMap Sweden

  map.TileServer := tsHyddaFull;


  Support tiles raster TOMTOM

  tsTomTomBasic,tsTomTomHybrid,tsTomTomNight,tsTomTomIncident,tsTomTomFlow

  you must use your api key : https://developer.tomtom.com/

  map.TomTomKey := your_tomtom_key

  map.TileServer := tsTomTomBasic;

  // add flow overlay
  map.AddOverlayTileServer(tsTomTomFlow);

  // mandatory, reset api key for overlay
  map.TomTomKey := map.TomTomKey;



  3.6.1 : 2 janvier 2019

  BUG

  Access violation when changing mapping very quickly
  using the format Map.TileServerInfo.GetTileFilename := your_getfilename;


  FreeHand : Shift between the mouse pointer and the drawing cursor (thanks Mulham)

  OnlyLocal was not respected in the minimap

  demo-remote-tiles-server no longer works

  ERRANGEERROR possible under certain circumstances when zooming/dezooming

  Problem when zooming/unzooming under android (thanks mihai)


  3.6 : D cembre 2018


  BREAKING CHANGE

  TOnErrorRoute = procedure(sender: TObject;const dataroute:TECThreadDataRoute) of object;

  used in

  map.Routing.OnErrorRoute := your_error_routing;


  TECThreadDataRoute is declared in the uecGeoLocalise unit



  BUG

  Exception during the rotation of the device with Delphi Rio for Android

  MouseWheelZoom allway active in Firemonkey

  possibility of ERANGERROR with Mappilary

  the polygon borders must be adjustable with the scale property of the styles

  the element moved with the mouse must be displayed over all the others (thanks ronald)

  TNativeMapObserver event OnShapeMouseUp is never call, OnShapeMouseDown is called instead

  when a TECShapeInfoWindow is associated with TECShapeLine.item,
  the infoWindow is not opened at the click point on the line (thanks ronald)

  in multi-view mode, the last element was not added to the associated maps (thanks simon)

  ScreenShoots could cause a crash at the end of the program under certain circumstances

  Regression, the minimap positioning rectangle does not follow the movement of the main map (thanks ronald)


  when zooming by double click the center of the map does not position itself on the click point (thanks ronald)

  the Bsize style now supports multiple values according to a zoom level (thanks ronald)

  map.Styles.addRule('# {bsize:1-13=0,14-15=1,16=2,17-18=3}')  ;

  regression, only the first element is extracted from geojson files

  when you change visual properties of an element that the mouse hovers over,
  the old ones are restored when the mouse leaves the element (thanks gille)

  TECShape.CopyToGroupAndRemove now copy also the events  (thanks gilles)

  in case of opening an opendialog when double clicking on a shape,
  the component remains in a mouse down state and it is then necessary
  to click again on the map to return to the normal situation  (thanks gilles)

  infinite loop when adding certain properties in shapes (thanks joon )

  VCL : onLoad don't call after map.LoadFromfile



  ADD


  Draw lines and polygons directly with the mouse, you can also select elements by surrounding them

  see http://www.helpandweb.com/ecmap/en/shapes.htm#DRAWING_AND_FREE_HAND_SELECTION


  procedure TecNativeLineSelect.ReverseSelectionTo(NewShape:TECShapeLine);

  return reverse selection, now we can split a polygon into two sub-polygons

  function TNativeMapControl.AddLine(const dLine:TECShapeLine;const GroupName: string = '')
  : TECShapeLine;

  create line from another line

  function TNativeMapControl.AddPolygone(const dLine:TECShapeLine;const GroupName: string = '')
  : TECShapePolygone;

  create polygone from line

  property TECNativeMap.UseInfoWindowDescription : boolean  (default false)

  Allows the Description field to be displayed as an infoWindow when you click on the element

  property TECNativeMap.InfoWindowDescription : TECShapeInfoWindow

  infoWindow use to display the Description property when clicking on an element

  property TECNativeMap.OnlyOneOpenInfoWindow : boolean  (default false)

  only allows one open infowindow at a time (thanks ronald)

  map.OnlyOneOpenInfoWindow := true;


  procedure TECSnapDrag.CancelSnap;

  cancel the marker movement

  Property  TECSnapDrag.OnNoSnap : TNotifyEvent

  triggered if a monitored marker is not attracted by a guide

  property TECSnapDrag.TargetLine : boolean

  draw line between marker and guide line
  you can stylize this line like this

  // doted target line
  map.Styles.addRule('#TECSnapDrag.line{penStyle:Dot}');


  when a guide line is ready to receive the marker its _snap_ property is set to true,
  it allows you to define a style to indicate this state

  // double the size of line when targeted
  map.Styles.addRule('.line._snap_:true {scale:2}')  ;
  // default size
  map.Styles.addRule('.line._snap_:false {scale:1}')  ;


  TRoutingEngine add reCustom for to redefine your routing engine (thanks jaap)

  Map.Routing.Engine(reCustom);
  Map.Routing.EngineName := yourRouting_Name;
  Map.Routing.EngineUrl := yourRouting_URL;
  Map.Routing.EngineExecute := yourRouting_Execute;


  add Item (Tobject) in TECPointLine


  support Open Location code

  The Open Location Code (OLC) is a geocode system for identifying an area anywhere on the Earth

  see https://en.wikipedia.org/wiki/Open_Location_Code


  function TNativeMapControl.OpenLocationCode.Encode(const latitude,longitude : Double;const codeLength:Integer=OLC_CODE_PRECISION_NORMAL):string;

  // Provides a normal precision code, approximately 14x14 meters.
  olc := map.OpenLocationCode(lat,lng);

  // Provides an extra precision code, approximately 2x3 meters.
  olc := map.OpenLocationCode(lat,lng,11);


  function TNativeMapControl.OpenLocationCode.Decode(const code:string):TecOLC_CODEAREA;

  var olcArea : TecOLC_CODEAREA;

  olcArea := map.OpenLocationCode.Decode('8FM263JF+PM');

  olcArea.latitudeLo;
  olcArea.longitudeLo;
  olcArea.latitudeHi;
  olcArea.longitudeHi;
  olcArea.latitudeCenter;
  olcArea.longitudeCenter;
  olcArea.codeLength;

  map.AddPolygone(olcArea);



  procedure TNativeMapControl.OpenLocationCode.MoveTo(const OpenLocationCode:string);

  map.OpenLocationCode.MoveTo('8FM263JF+PM');


  in the uecOpenLocationCode unit you will find class to use OpenLocationCode,
  it is my translation of the javascript openlocationcode.js from Google
  (https://github.com/google/open-location-code/blob/master/js/src/openlocationcode.js)



  support GeoHash

  Geohash is a public domain geocoding system invented by Gustavo Niemeyer,
  which encodes a geographic location into a short string of letters and digits.

  see https://en.wikipedia.org/wiki/Geohash


  procedure TNativeMapControl.GeoHash.Decode(const geohash: string; var latitude, longitude: double);

  var lat,lng : double;

  map.geoHash.Decode('9xj5smj4w40m',lat,lng);


  function  TNativeMapControl.GeoHash.Encode(const latitude, longitude: double;const precision:Integer=12): string;

  s := map.geoHash.encode(map.latitude,map.longitude); // return the geoHash for the center of map



  function  TNativeMapControl.GeoHash.CardinalPoints(const geohash:string):TCardinalGeoHash;

  get geoHashs located at the 8 cardinal points around a geoHash

  var cgh : TCardinalGeoHash;

  cgh := map.geoHash.CardinalPoints('9xj5smj4w40m');

  cgh.North;
  cgh.NorthEast;
  cgh.East;
  cgh.SouthEast;
  cgh.South;
  cgh.SouthWest;
  cgh.West;
  cgh.NorthWest;


  procedure TNativeMapControl.GeoHash.MoveTo(const geohash:string);

  map.GeoHash.Moveto('9xj5smj4w40m') ==> map.setCenter(40.018141, -105.274858)




  in the uecGeoHash unit you will find functions to encode / decode geoHash,
  it is my translation of the javascript geohash-js from Dave Troy
  ( https://github.com/davetroy/geohash-js/blob/master/geohash.js )


  procedure decodeGeoHash(const geohash: string; var latitude, longitude: double);
  function  encodeGeoHash(const latitude, longitude: double;const precision:Integer=12): string;

  I added a function to get geoHashs located at the 8 cardinal points around a geoHash

  function  CardinalGeoHash(const geohash:string):TCardinalGeoHash;





  property TECShapeLine.MeterWeight : boolean (default false)

  defined the unit as meters for the weight and Bordersize properties

  by default the unit is the pixel



  procedure TNativeMapControl.FromLatLngToBoundingBoxTile(const Lat,Lng:Double;
  var NELat,NELng,SWLat,SWLng:Double);

  returns the geographical corners of the tile containing the point passed as parameter


  support local cache in OverPassAPI


  procedure TECDownLoadTiles.OnErrorLoadTiles(sender: TObject; const X,Y,Z:Integer;
  var ReloadTile : boolean)

  fired when tile xyz not loading, you can force reloading or cancel


  Decrease in the number of arrows depending on the zoom when showDirection is activated for TECShapeLine

  You can also control their display by using a style like

  map.Styles.addRule('.poi._direct_:true{scale:1-10=0,11-15=0.5,16-17=0.8,17-20=1}')  ;

  for zooms from 1 to 10 your directional points will not be displayed,
  between 11 and 15 they will have 50% of the size you defined for them,
  80% between 16 and 17 and 100% beyond



  3.5 : juin 2018

  TECNativeMap exists since 5 years, it is the 35th update, thanks to all these users for your support!


  BUG


  Draw DragRect for selected area even if they are many many shapes

  Crash if you request the calculation of a route by passing directly the coordinates like this

  map.Routing.Request([43.232858,0.0781021,43.2426749,0.0965226]);

  thanks enes


  When you modify manually Map.TileServerInfo.Name this is not reflected on the local cache
  and therefore internally the wrong directory is used.  (thanks gilles)


  Heatmap

  The displayed value was disconnected from the data (thanks koechli)


  In designtime using DelphiTokyo 10.2.2 there may be a crash when the form closes


  OnCompleteTiles is re-triggered at each paint even if there has been no need to load new tiles since the previous call


  Add

  property TNativeMapControl.OverPassApi : TECOverPass;

  Allows you to use OverPass API

  see : http://www.helpandweb.com/ecmap/en/import_export.htm#OVERPASSAPI

  see DemoNativeOverPassFiremonkey


  property TNativeMapControl.SnapDrag : TECSnapDrag;

  Snap markers on a line or a polygon

  map.SnapDrag.AddMarker(marker_or_Poi);
  map.SnapDrag.AddGuide(polygone_or_line);

  see : http://www.helpandweb.com/ecmap/en/shapes.htm#SNAP_MARKERS_ON_A_LINE_OR_A_POLYGON

  see also the demo SnapDrag


  property TNativeMapControl.Boundary : TECBoundary

  Boundary allows to obtain information and the polygon of an area by passing a geographical point

  see : http://www.helpandweb.com/ecmap/en/location.htm#BOUNDARY

  see also DemoNativeBoundaryArea



  TECNativeMap.LoadFromfile can read OSM XML and .olt files

  Loading is not blocking so connect to the OnLoad event if you need to react when all data is available

  olt is a TECNativeMap format more compact than OSM XML see http://www.helpandweb.com/ecmap/en/import_export.htm#OSM_XML


  TECShapes (group)

  function  LoadFromFile(const filename: string): boolean;

  now you can also read osm et olt files

  function  LoadFromOSMStream(const Stream: TStream): boolean;

  read osm and olt stream


  function  LoadFromOSMString(const data: string): boolean;

  read osm and olt string


  3.4.1

  BUG

  no longer compiles under D7 because of inline function

  problem with the off-zone screen capture functionality


  3.4 : Janvier 2018

  BUG

  TECShape.Location (search is asynchronous and triggered OnShapeLocation)

  fail if shape move after location call


  TNativeMapControl.Selected.fitBounds bad calcul (thanks gilles)

  TECNativeLine.clear does not erase the line from the map, it remains frozen

  Range check error triggered with some kml file (thanks andreas )

  Stack overflow with certain kml files

  Index Out of range in ExplodeOSMDirectionJSON (mapquest road calculation) (thanks thomas)


  TECShapePOI   (thanks gilles)

  Regression : if the unit is the metre, the size will be wrong when changing the zoom.

  In edit mode the element is not moveable even if Draggable=true



  ADD

  property TNativeMapControl.TimerSpeed : cardinal

  set the rate of threads that handle the internal messages of the component
  default value 16 ms on computers and 64 ms on mobiles



  TecNativeLineSelect (unit uecEditNativeLine)

  Allows you to select a line portion, either directly with the mouse or by code


  var SelectLine  : TecNativeLineSelect;
  ...
  SelectLine := TecNativeLineSelect.create;
  // triggered by selection
  SelectLine.OnSelect   := doSelect;
  // triggered by deselection
  SelectLine.OnDeselect := doDeselect;


  SelectLine.Line := your_Line;

  // select portion by code
  SelectLine.SelectionFrom(Alat,ALng,BLat,BLng);

  // return number of points in selection
  SelectLine.Count;

  // return point (TECPointLine) number x in selection
  P := SelectLine.Selection[x];

  // deselect portion by code
  SelectLine.Deselect;


  // triggered by selection
  procedure form.doSelect(Sender: TObject);
  begin

  // convert selected points to a new line
  if not assigned(NewLine) then
  newLine := map.addLine(0,0);

  SelectLine.SelectionToLine(newLine);

  end;

  // triggered by deselection
  procedure form.doDeselect(Sender: TObject);
  begin
  newLine.Clear;
  end;


  To select with the mouse, just hover over your line and click on the selection point, click on the point again to deselect.



  property TNativeMapControl.OnShapeAutoHide : TNotifyEvent

  triggered when hint hide, sender is TECShape whose hint is no longer displayed


  procedure TNativeMapControl.Selected.fitBounds(const GroupName:string);

  fitbounds selected shapes by group

  map.selected.fitBounds; // all groups
  map.selected.fitBounds('this_group');


  new TileServer : tsMappilary (display mappilary coverage)


  property TECHeatmapLayer.AutomaticUpdate : boolean

  if true the heatmap is automatically repainted when there is a change


  TECShapePOI

  add poiDiagCross


  slight optimization of the Heatmap layer

  Improved reactivity when the map contains many elements



  TECClusterManager.MaxCount

  returns the number of elements in the cluster that contains the most of them



  3.3 : octobre 2017

  BUG : move map only if drag start on it.

  If dragging a shape and your mouse enters a panel, then the dragging stops - ok.
  But if you leave the panel again (mouse button is still pressed) and release
  the mouse button somewhere on the map the map scrolls away     ( thanks Ingo )


  Problem with lines and polygons over 100 pts when switching to editable mode ( thanks Mihai )


  OnLyLocal and MaxDayInCache are not applied for TECOverlayTileLayer if they are added after the value change.


  CHANGE :

  TECShapeMarker with image can use Fov

  use FovAngle to indicate the angle of field of view


  Allow the use of any api for altitude calculation

  2 api are available as standard, mapQuest (used since the component's origin)
  and Open Elevation ( https://open-elevation.com/ ) which becomes the default api.

  to switch from one to the other made

  map.GeoLocalise.ApiAltitude := altOpenElevation;
  map.GeoLocalise.ApiAltitude := altMapQuest;

  ! For mapquest you must provide your own key , map.MapQuestKey = 'your_key'.

  You can connect your own procedures if you want to use other services

  procedure your_getAltitude(const LocalCache:string;const Latitude,Longitude:double;var altitude:double);
  begin
  // put result in altitude
  end;

  procedure your_getAltitudes(const LocalCache:string;const sLatLngs: string;var altitudes:string);
  begin
  // sLatLngs = lat1,lng1,lat2,lng2...

  // put results in altitudes ( '310,120,158' )
  end;


  connect yours procedure like this

  map.GeoLocalise.OnGetAltitude  := your_getAltitude;
  map.GeoLocalise.OnGetAltitudes := your_getAltitudes;




  ADD :


  Heatmap layer : see http://www.helpandweb.com/ecmap/en/layers.htm#HEATMAP

  // create heatmap layer
  FHeatmapLayer := TECHeatmapLayer.Create(map);

  // add points
  FHeatmapLayer.Add(-37.8839, 175.3745188667); // default value 1
  FHeatmapLayer.Add(-37.8869090667, 175.3657417333, 10);
  FHeatmapLayer.Add(-37.8894207167, 175.4015351167, 150);
  ...

  // generates the heat map
  FHeatmapLayer.Update;



  When the server indicates that a tile does not exist (error code 404),
  an empty tile is returned so as not to ask for it again and again.

  You can define your own error tile

  map.TileServerInfo.ErrorTile := your_error_tile_bitmap;


  function TECShapePolygone.PathGetHitLatLng(const startlat,startlng, bearing:double;var HitLat,HitLng:double):integer;

  from a point inside  the polygon, find the exit point located on the polygon according to a direction (bearing)

  startLat,startLng point inside polygone
  bearing direction of exit

  returns the index of the segment containing the intersection point, or -1 if no intersection point
  HitLat,HitLng the intersection point


  TECShapePOIList.HitBorder

  Enlarged the detection area for pois, by default 5 pixels for mobiles and 0 for desktops.

  map.shapes.pois.HitBorder        := 10;
  map.group['name'].pois.HitBorder := 10;



  function TECNativeMap.PixelDistance(const lat1, lng1, lat2,lng2: double) : integer; overload;
  function TECNativeMap.PixelDistance(const shapeA:TECShape;const shapeB:TECShape) : integer; overload;

  function TECShape.PixelDistanceTo(value: TECShape): integer;

  Calculate the distance in pixels between two geographical positions

  map.PixelDistance(43.05,0.007,43.15,0.0089);
  map.PixelDistance(marker1,marker2);

  marker1.PixelDistanceTo(marker2);


  Mapzen's vector tiles are now also available in size 512, this allows to have less latency (1 new tiles = 4 old ones)

  map.TileSize   := 512;
  map.TileServer := tsVectorMapZen;


  TECShapePOI

  add poiCross


  TECOverlayTileLayer

  add property MaxDayInCache:double


  3.2 : september 2017


  BUG :


  VCL rotation png not good size

  TECOpenWeatherTilesLayer fix for

  owPrecipitation,owSnow, owClouds, owPressure,  owTemp, owWind

  other servers don't exist anymore



  Android :

  error in kml file if the opacity of the polygons is not indicated  (thanks jon )


  CHANGE :


  MaxDayInCache is now a double

  The integer part represents the number of days,
  the decimal part indicates the number of minutes

  map.MaxDayInCache := 1 + (30/1440) ; // 1 day and 30 minutes (1440 = numbers of minutes in a day)
  map.MaxDayInCache := 60/1440       ; // 60 minutes


  VCL

  TECShapePolygone.style also works if FillOpacity < 100

  property TECShapePolygon.PenStyle : psSolid, psDot, psDash and psDashdot



  ADD :

  Support Mappilary api V3

  new TileServer : tsOpenTopoMap ( https://opentopomap.org/about )

  property OpenWeatherTilesLayer : TECOpenWeatherTilesLayer

  OpenWeatherTilesLayer is created on demand

  function  OpenWeatherTilesLayer.Add(const Layer:TOWTileServer):TECOverlayTileLayer;
  function  OpenWeatherTilesLayer.Get(const Layer:TOWTileServer):TECOverlayTileLayer;
  procedure OpenWeatherTilesLayer.Remove(const Layer:TOWTileServer);
  procedure OpenWeatherTilesLayer.RemoveAll;

  sample

  map.OpenWeatherTilesLayer.Key := YOUR_API_KEY;  // https://home.openweathermap.org/users/sign_up
  map.OpenWeatherTilesLayer.add(owTemp); // owPrecipitation,owSnow, owClouds, owPressure,  owTemp, owWind
  // add second layer
  map.OpenWeatherTilesLayer.add(owRain);


  TECNativeMap.OnTilesTimeout : TNotifyEvent
  TECNAtiveMap.MaximumTilesTimeout : cardinal;

  OnTilesTimeout event fires if the entire map is not built after MaximumTilesTimeout millisecondes

  By default it's 6000 ms (6 seconds)

  map.OnTilesTimeout      := TimeoutTiles;
  map.MaximumTilesTimeout := 10000; // max 10 secondes
  ...
  procedure TForm.TimeoutTiles(Sender:TObject);
  begin
  // here change your server
  end;


  property TECShapePolygon.PenStyle : psSolid, psDot, psDash and psDashdot

  only in Firemonkey


  // Get the weather inside the polygon and not only on the perimeter
  Polygon.ShowWeather  := true;

  support 5 day / 3 hour forecast

  map.OpenWeather.Now      -> http://openweathermap.org/current
  map.OpenWeather.Daily    -> http://openweathermap.org/forecast16
  map.OpenWeather.Forecast -> http://openweathermap.org/forecast5


  Improved rotation by gesture


  TECShapePOI

  add poiArrow , poiArrowHead


  TECNativeMeasureMap

  add Pointer default poiTriangle





  3.1 :  mai 2017

  ! Uncorrected Bug under Tokyo Android !

  No rotation for bitmap markers
  Crash when using tbitmap.rotate ( ? bug : https://quality.embarcadero.com/browse/RSP-17636 )



  BUG

  crash ForceRefreshDisplayedTiles    (thanks gilles)

  TECShape.PropertyValue['prop']:='value' does not work anymore (thanks gilles)

  Demo-remote-tiles-server is broken

  VCL GroundOverlay broken (thanks Mulham)

  Stack overflow with TecNativeLabelLayer under certain circumstances

  Bad conversion of data kml to properties for TECShapeLine and TECShapePolygone (thanks Duan)

  The Name property of the TECShape must be unique, causing a bug when importing kml files that define names that have the same values

  After importing kml do not use TECShape.name but TECShape.PropertyValue ['name']  (thanks gilles)

  Improved display of "html" text in infowindows, there was a bug in calculating the width (thanks Wilfried)

  bad overlay bitmap with rotation (tecshapemarker.setBounds())


  ADD

  Support current and 5 days weather from openweathermap.org (see unit uecopenweather )

  get your key from http://openweathermap.org/appid

  map.OpenWeather.Key := your_key

  // get the meteo of now, return the number of stations found
  if map.OpenWeather.Now.ByLatLng(lat,lng)>0 then
  begin
  showmmessage(map.OpenWeather.Now.Data[0].weather.description);
  end;

  or

  station : TOpenWeatherData;

  station := map.OpenWeather.Now.Weather(lat,lng);

  if station.name<>'' then
  showmessage(station.weather.description);

  // Get the weather along a TECShapeLine
  Line.ShowWeather  := true;


  see new demo RouteWeather



  property MaxDayInCache for TECDownLoadTiles

  property  TNativeMapObserver.OnMapCompleteTiles : : TNotifyEvent
  procedure TECNativeLayer.doOnMapCompleteTiles(sender : TObject); virtual


  Style FontFamily and FontSize for InfoWindow

  map.styles.addRule('.infowinfow {fontsize:12;fontfamily:Comic sans ms}');


  procedure TECShape.ShowAll

  move map for show whole item (for zooming use fitBounds)


  TECNativeMap.ThunderForestKey

  now OpenCycleMap need a key, get your key from http://www.thunderforest.com/pricing/

  map.ThunderForestKey := your_key;
  map.TileServer       := tsOpenCycleMap;



  3.0 : Janvier 2017

  BREAKING CHANGE

  removing property  MaxLowZoom, MedLowZoom, MinLowZoom and LowTileServer

  the tiles of the previous levels are expanded


  you must reinstall packages, recharge the dfm and ignore the deleted properties


  Google stop Panoramio, Panoramio layer is dead...

  you can use Mappilary as alternative but is not the same spirit


  CHANGE

  update url tileserver OPNV

  change TECShape.Hint and TECShape.Description redraw then shape

  TNativeMapControl.MaxDayInCache is also used for routing data

  now use TNativeMapControl.MaxDayInCache = 0 for an unlimited duration


  BUG

  TECShapes.SaveToFile error with kml files (thanks Duan)

  TECNativeMap.Cursor is allways crDefault

  TECShapePOI in pixels are not displayed if you do not set the width and height
  (they should use the default values)


  Shift problem for GroundOverlay, you must set XAnchor and YAnchor to 0
  this is now done automatically when editing FitBounds  ( thanks Patrick )


  TECShapes.LoadFromFile

  now you can use like TECNativeMap.LoadFromFile , load kml, geojson, gpx and txt files


  Opacity it's not used for TECNativeMap (thanks Mihai)


  Improved geojson import

  improved import KML (thanks diego)

  TOSMFile.TOShapes crash on mobiles (thanks Markus)

  TOSMFile.ToShapes is much faster


  Angle & Properties are not corrected assigned in TECShape.setToTxt

  TMappilaryImage.captured_at is wrong


  VCL

  Marker can't rotate if use TImageList's bitmap  (thanks Beyki)


  ADD


  TECNativeMap.Geofences

  A geo-fence is a virtual perimeter that triggers an alert when you enter or exit

  see DemoFiremonkeyGeofences and http://www.helpandweb.com/ecmap/en/location.htm#GEOFENCES


  procedure TECNativeMap.FromLatLngToXY(const Lat,Lng:double;var X,Y:integer);
  procedure TECNativeMap.FromLatLngToXY(const LatLng:TLatLng;var X,Y:integer);



  property TECNativeMap.FilenameStartEditLine : string
  property TECNativeMap.FilenameEndEditLine   : string
  property TECNativeMap.FilenamePointEditLine : string

  Name of the bitmap files (url, local, base64 or SVG)
  for start, end and intermediate points of lines and polygons in edit mode

  By default: a black square, a white square and a white round

  You can still use OnCreateShapeLinePoint to fully define your editing points



  property TECShapes.Show : boolean   (default true)

  If false the group is not displayed
  but its elements always respond to the mouse contrary to visible = false


  TECShape.SendToBack

  for cancel TECShape.BringToFront


  property TECShape.Time     : TDateTime

  DateTime to last move

  property TECShape.PrevLatitude : double
  property TECShape.PrevLongitude: double

  Previous position

  property TECShape.PrevTime     : TDateTime

  DateTime to Previous position

  property TECShape.MoveDirection : integer

  Direction of movement (0-360 with 0 is north)

  property TECShape.MoveDistance  : double

  distance in km of travel


  function TECShape.SpeedKmH : integer;

  Speed in kilometers per hour


  property TECShape.TrackLine : TECShapeLine

  if TrackLine exists you get the trace of each move

  To activate the trace just access TrackLine,
  line is created in the same group as the tecshape

  FShape.TrackLine.visible := true;

  You can also pass a line

  FShape.TrackLine := your_line;

  for stop tracking set to nil  , the line is free

  FShape.TrackLine := nil


  for test if Trackline exists use TECShape.isTrackLineActive





  property TECPointLine.time : TDateTime;

  line.path[1].time := now;


  function TECNativeMap.isMouseDownButton(button : TMouseButton ) :boolean;

  detect what mouse button is pressed in OnMapMouseDown & onShapeMouseDown

  // vcl
  if map.isMouseDownButton(mbLeft) then ...

  // fmx
  if map.isMouseDownButton(TMouseButton.mbRight) then ...



  TECShapePolygon.Centroid: TLatLng

  centroid of polygon

  map.addPoint(Polygon.Centroid.Lat,Polygon.Centroid.Lng);



  Apis key for TECDownLoadTiles ( MapBoxToken , DigitalGlobeToken  etc.)

  The key is essential if you want to download the DigitalGlobe tiles (thanks Mulham)

  FECDownLoadTiles.DigitalGlobeToken := YOUR_KEY

  // download visible area from zoom+1 to MaxZoom
  FECDownLoadTiles.DownLoadTiles(map.Zoom + 1, map.MaxZoom,
  map.NorthEastLatitude,
  map.NorthEastLongitude,
  map.SouthWestLatitude,
  map.SouthWestLongitude);

  New Demo Firemonkey MappilarySearchImages


  2.9

  BREAKING CHANGE

  Since July 11, 2016 MapQuest not allow direct access to their tiles

  tsOpenMapQuest and tsOpenMapQuestSat are no longer usable (unless you have them in your cache)


  BUG

  MapZen Routing break

  the scale marker is false when save map data
  (it is dependent on the resolution screen which should not be)

  procedure TECNativeMap.LatLonFromDistanceBearing circular call... (thanks Klaus)

  wrong delimiter path for cache tile on OSX (thanks Mihai)

  Crash if LocalCache Path is not valid (merci Gilles)

  Exception raised when Mapillary is enabled and you click on a TECShapePOI that does not belong to the layer

  save / load marker encoded in base64

  angle is not saved

  TECShape.PropertyValue[key] missing the last character of the last value

  AV with TECAnimationMarkerFilename

  TECCartoStyles.addRule blocking if the rule contains ;;

  ArcGis server don't work with D2009, png format invalid (thanks J rgen)

  TECShapeMarker.rotation compensate map rotation

  VCL MouseWheel don't work in TFrame (thanks Mulham)


  ADD


  Support for OSM XML files (add unit uecOSM) (new demo demoOSMViewer)

  see  http://www.helpandweb.com/ecmap/en/import_export.htm#OSM_XML


  Support for zip archives for easy deployment tiles and other files (new demo MapArchiveCreator)

  see http://www.helpandweb.com/ecmap/en/offline_mode.htm#ARCHIVE_LOCAL


  new TileServers :  tsDigitalGlobeRecent , tsDigitalGlobeTerrain  , tsOsmFr

  use map.DigitalGlobeToken := your_token;

  signe up  https://developer.digitalglobe.com/maps-api/#plans


  Openstreetmap request referer to send the tiles, by default i use www.google.com
  you can change this with before map create (in dpr )

  _IDHTTP_REQUEST_REFERER := 'your_valid_referer';

  or you must use map.reLoad for use new value


  TECShapeLine.Reverse, TECShapePolygone.Reverse

  reverse the order of points


  procedure TECShapeLine.Slice(const StartIndex,EndIndex : integer;Line : TECShapeLine); overload;

  Copy the line between the start and finish segment

  function  TECShapeLine.Slice(const StartIndex,EndIndex:integer;GroupName:string=''):TECShapeLine; overload;

  return the line between the start and finish segment


  procedure TECShapeLine.Slice(const StartKm,EndKm : double;Line : TECShapeLine); overload;

  Copy the line between the kilometers of start and finish

  function  TECShapeLine.Slice(const StartKm,EndKm : double;GroupName:string=''):TECShapeLine; overload;

  returns the line between the kilometers of start and finish

  // newLine contains points between 1.5km and 3.6km
  newLine := Line.slice(1.5,3.6);
  newLine.color := claGreen;

  property TECShapeLine.ShowDirection : boolean;

  add arrows at each segment to indicate direction



  TECShapeMarker.OwnsGraphic (default true)

  specify if assigned object in Graphic is released with marker,
  is only useful if you are using the Graphic property,
  when you use Filename images are always released

  marker.Graphic := image1.Picture.Graphic;
  // don't automatic free because image1 is TImage and it's free when form is free
  marker.OwnsGraphic := false;


  TECNativeMap.MouseLatLng is correct even in mobile, it is the location of the contact point

  New marker.StyleIcon (siDirection) = siFlat + triangle oriented in the direction defined by the angle

  TECNativeMap.OnMapSelectChange

  TECNativeMap.SelectedArea:double (in km )

  function TECNativeMap.FindByKeyValue(const Key,Value:string;const ShapeList : TList<TECShape>) : integer;
  function TECNativeMap.Selected.ByKeyValue(key,Value);

  // select items whose property highway contains residential or secondary
  map.Selected.ByKeyValue('highway','residential|secondary');

  New syntaxe for Styles

  Properties Scale, StyleIcon,  FontSize and Weight property supports multiple values depending on the zoom level

  #.poi {fontsize:17=6,18=8,19-20=10;}

  fontsize = 6pt in zoom 17  , 8pt in zoom 18 , 10pt in zoom 19 & 20

  .line {weight:17-20=14,15-16=10,10-14=6,1-9=2}

  weight = 14 pixels in zoom 17 to 20, 10 in zoom 15 & 16, 6 in zoom 10 to 14, 2 in zoom 1 to 9

  .marker {styleicon:0-17=flat,18-20=direction}

  marker.styleIcon = siFlat in zoom 0 to 17 and siDirection in zoom 18 to 20


  You can define name for value and reuse

  @dark {#404040}
  @scale-suburb-village {0-11=0,12=1.2,13=1.5,14=1.6,15-16=1.9,17-20=2.5}

  .poi {if:place=suburb;fontsize:12; scale:@scale-suburb-village;color:@dark;width:0;yanchor:0;}



  TECClusterManager.FillClusterList  : boolean

  Keeps the list of elements contained in clusters, default false

  property TECCluster.Shapes : TECShapesList

  if TECClusterManager.FillClusterList, contain the list of all item in the cluster


  new value for DragRect , drManualSelect fire OnMapSelectRect but items is not selected like with drSelect


  Properties are exported / imported in KML (for format see https://developers.google.com/kml/documentation/extendeddata )

  marker.PropertyValue['myProp']='myPropValue';

  kml format

  <Placemark>
  ...
  <ExtendedData>
  <Data name="myProp">
  <value>myPropvalue</value>
  </Data>
  </ExtendedData>
  ...
  </Placemark>



  The infowindow remain in the right direction even if the map is rotated
  BUT the closing cross is not available

  MiniMap is also usable whith rotation


  2.8

  BUG

  Bad angle for TECShapeMarker SVG

  TECShapeMarker.FovRadius not correct in HighDPI

  <Hx>...</Hx> (InfoWindow.content) not correct in HighDPI

  Error in UECMapUtil when build VCL 64bit

  android : performance problem in the display of tiles

  potential leaks memories

  random bug when simultaneous screenshots

  right Click + scroll wheel does not change ZoomScaleFactor

  the background of infowindows is transparent when the map moves

  Xapi Layer don't draw lines when search way

  // search roads with junction
  map.XapiLayer.Junction := true;
  map.XapiLayer.Search := 'way[highway=unclassified|road|motorway|trunk|primary|secondary|tertiary|residential]'

  ADD

  support for Mappilary.

  Mappilary is a service of the same type as Google Street Map,
  it will display photos at street level, you can enrich it by registering your routes

  see DemoFiremonkeyMappilary and http://www.helpandweb.com/ecmap/en/layers.htm#MAPPILARY


  property TNativeMapControl.MaxDayInCache : integer

  Number of days to keep the tiles in the cache beyond the tiles are reloaded
  30 days by default


  property TNativeMapControl.Reticle : boolean

  show reticle when zoom

  property TNativeMapControl.ReticleColor : TColor

  color reticle default black

  property TNativeMapControl.OnReticlePaint(sender: TObject; const canvas: TECCanvas;const X,Y:integer)

  custom reticle paint

  map.Reticle        := true;
  map.OnReticlePaint := doReticlePaint;

  // X,Y center of zoom
  procedure TForm1.doReticlePaint(sender: TObject; const canvas: TECCanvas;const X,Y:integer) ;
  begin
  Canvas.Ellipse( X - 16, Y - 16,  X + 16, Y + 16);
  end;



  property TECShapeMarker.FovHit

  true if mouse hover Fov, you can test it also in OnClick

  Now the Fov area react to the mouse

  NEW demo ( DemoFiremonkeyPhotographer ) screenshots outside visible area


  support gradient color in styles

  syntax : gradient(StartColor,EndColor,percentage[0..1])

  map.styles.addRule('.line {color:gradient(Red,Yellow,0.6)');

  Please note this does not make a gradient of many colors that can mix a color with another based on a percentage



  procedure TECXapiLayer.Junction : boolean

  find junction when searching Way (usefull for roads)

  function TECXapiLayer.Bound(NELat,NELng,SWLat,SWLng) : boolean;

  Initiates research on requested area

  returns true if the search is launched, false if a search is already underway

  if the layer is visible research is done on the visible area of the map
  and they are restarted automatically when it moves

  set layer visibility to false and you can manually search in your zone

  sample, copie data in another group

  map.XapiLayer.OnChange := XapiChange;
  map.XapiLayer.visible  := false;
  map.XapiLayer.search   := 'highway=bus_stop';
  // ! call bound after set search !
  map.XapiLayer.bound(43,0.7,44,0.8);
  ...
  TForm.XapiChange(sender : TObject);
  begin
  // here xapilayer contain openstreetmap data
  // copie in another group
  map.group[copy_xapi'].ToTxt := map.XapiLayer.shapes.ToTxt;
  end;


  2 new demos ( DemoFiremonkeyMappilary & DemoFiremonkeyPhotographe )
  update DemoNativeLinesPolygones for support XapiLayer



  2.7

  BUG

  OnShapeDragEnd return wrong shape if dragged the shape to the same place as another Shap

  Random crash if you remove an item pointed by the mouse

  Produces an invalid json

  TECShapeMarker.OnAfterDraw is reset to nil after loading the image  (thanks freddie)

  Z order is not respected in the screenshots

  VCL

  the rotation of PNG is not clean  (thanks alexey.k )

  TECShapeMarker.opacity does not work



  ADD

  support SSL for tileservers (not all), routing, geocoding

  map.SSL := true;

  ! only works from Delphi DX

  new TileServer : tsMapBoxSatellite, tsMapBoxStreets,
  tsMapBoxStreetsSatellite, tsMapBoxOutdoors

  use map.MapBoxToken := your_token;


  Simplifying the management of roads and support for routing engines

  support turn by turn, see new demo DemoNativeRoute

  Support routing engine  ( you must use your key ! )

  MapQuest ( like before )
  MapZen TurnByTurn ( https://mapzen.com/documentation/turn-by-turn/ )
  OSRM  ( https://github.com/Project-OSRM/osrm-backend/wiki/Server-api )
  MapBox ( https://www.mapbox.com )

  see http://www.helpandweb.com/ecmap/en/roads.htm


  TECShapeList.OnBeforeDraw
  TECShape.OnBeforeDraw

  // all markers default group
  map.shapes.markers.OnBeforeDraw          := doBeforeDraw;
  // just this marker
  map.group['via'].markers[1].OnBeforeDraw := doBeforeDraw;
  ...
  procedure TForm1.doBeforeDraw(const canvas: TECCanvas; var rect: TRect; item: TECShape) ;
  begin
  //
  end;


  procedure TECShape.InfoWindow(const content:string);
  procedure TECShape.InfoWindow(win:TECShapeInfoWindow);

  a infowindow is added to the element
  It is displayed when clicking on the item

  infoWindow is stored in TECShape.Item

  you can remove with

  your_shape.infoWindow('');
  or
  your_shape.infoWindow(nil);


  property TECShapeInfoWindow.OnOpen:TOnOpenInfoWindow

  call just before open, you can cancel or change content


  win.OnOpen := doOnOpenWindow;
  ...
  procedure TForm.doOnOpenWindow(const infoWindow: TECShapeInfoWindow; var cancel: boolean);
  begin

  // set cancel to true for not open then infowindow (default false)
  // cancel := true;

  infoWindow.Content := 'change content here';

  end;



  TECShape.PropertiesFindFirst(var key,value:string):boolean
  TECShape.PropertiesFindNext (var key,value:string):boolean

  Browse all properties

  if myShape.PropertiesFindFirst(key,value) then
  begin
  repeat
  // here use key and value

  until myShape.PropertiesFindNext(key,value);
  end;


  property TECShapeMarker.Fov : TECAngleFov  (0..360)

  if FOV ( Field of View ) is greater than 0 a cone is displayed
  in the direction specified by the property Angle

  mrk.Fov := 40;

  property TECShapeMarker.FovRadius : integer

  cone length in pixels

  property TECShapeMarker.StyleIcon : TECStyleIcon

  style icon draw if no graphic

  marker.StyleIcon := si3D;           // actual style
  marker.StyleIcon := siFlat;         // circle whith white border
  marker.StyleIcon := siFlatNoBorder; // circle no border
  marker.StyleIcon := siSVG           // set svg data in filename
  marker.StyleIcon := siOwnerDraw     // connect to marker.OnAfterDraw for draw your self

  for speed use siFlatNoBorder

  only on Firemonkey you can load SVG images such as the project MAKI (https://www.mapbox.com/maki-icons/)

  mrk.Filename := 'local_path_or_url\bicycle-15.svg';

  You can also directly inject the SVG data

  mrk.StyleIcon := siSVG;
  mrk.Filename  := 'M7.49,15C4.5288,14.827,2.1676,12.4615,2,9.5C2,6.6,6.25'+
  ',1.66,7.49,0c1.24,1.66,5,6.59,5,9.49S10.17,15,7.49,15z';



  you can style like this

  map.styles.addRule('.marker {StyleIcon:3D}');
  map.styles.addRule('.marker {StyleIcon:Flat}');
  map.styles.addRule('.marker {StyleIcon:FlatNoBorder}');
  map.styles.addRule('.marker {Graphic:HERE-SVG-DATA;StyleIcon:siSVG;color:red}');


  TECShapeMarker, TECShapePoi

  property Scale : double

  adjust the size of the element , for pois only if poiUnit = puPixel

  you can style like this

  map.styles.addRule('.marker {scale:1}');
  map.styles.addRule('.marker:hover {scale:1.5}');

  see : http://www.helpandweb.com/ecmap/en/tecshapemarker.htm


  property TECCartoStyles.GraphicDirectory

  Path to images whose name is made from OSM tag (amenity or kind)

  property TECCartoStyles.GraphicNameFormat

  Mask image name, Default '%s-15.svg' for Maki icons

  Use, download and unzip the icons of the project MAKI (https://www.mapbox.com/maki-icons/)

  map.styles.GraphicDirectory := path_maki_icon

  if you use the Vector tiles, interests point use images of the project MAKI



  property TNativeMapControl.OnlyLocal : boolean

  prohibit or authorize Internet connection for tiles and geocoding (deafult false)
  If true, tiles and geocoding only uses the local cache

  property TNativeMapControl.ScaleMarkerToZoom : boolean;

  adjust the size of markers and pois according to the zoom

  map.ScaleMarkerToZoom := true;


  property TNativeMapControl.XapiLayer : TECXapiLayer;

  see http://www.helpandweb.com/ecmap/en/layers.htm#XAPILAYER


  property TNativeMapControl.MouseOverShape : TECShape

  nil or element that is under the mouse


  event TECShapes.OnChange

  map.shapes.OnChange := doOnShapesListChange;

  // sender is TECShapeList (markers, lines, polygones ... )
  procedure form.doOnShapesListChange(sender : TObject )
  begin
  //
  end;


  TECShape.SaveState, TECShape.RestoreState

  saves and restores the main visual element properties

  These properties are saved when the mouse hovers over the element
  and restored when it leaves the area

  Useful for rollover effects in styles

  But if you changed your element when clicked,
  the change is canceled when the mouse leaves the element

  To make the change permanent you need to use SaveState

  procedure TForm1.mapShapeClick(sender: TObject; const item: TECShape);
  begin
  item.angle := item.angle + 10;
  // if you do not save, the old value of the angle is restored
  // when the mouse leaves the element
  item.SaveState;
  end;


  TECShape.Address := 'new address' move item to 'new address' if find


  Add geocode search and reverse from OpenStreetMap (https://wiki.openstreetmap.org/wiki/Nominatim)

  function map.GeoLocation.OpenStreetMapSearch(const address:string;const onlyLocal:boolean=false):integer;

  var result_nbr : integer;
  lat,lng    : double;

  result_nbr := map.GeoLocalise.OpenStreetMapSearch('Tarbes');

  if (result_nbr>0) then
  begin
  // get first result, genreraly the best
  lat  := map.GeoLocalise.SearchResult[0].Latitude ;
  lng  := map.GeoLocalise.SearchResult[0].Longitude;
  end;

  function map.GeoLocation.OpenStreetMapReverse(const Latitude,Longitude:double;const onlyLocal:boolean=false):string;



  Option to save the tiles in the cache with their extension

  // select a server
  map.TileServer   := tsBingRoad;
  // set this option AFTER change tileserver
  map.TileServerInfo.LocalExt := true;



  property  TNativeMapObserver.OnMapChangeBounds : : TNotifyEvent
  procedure TECNativeLayer.doOnMapChangeBounds(sender : TObject); virtual


  property TECDownLoadTiles.TileServerInfo : TTileServerInfo

  necessary to manually add a server


  unit uecNativeScaleMap

  property TECNativeScaleMap.Visible     : boolean
  property TECNativeScaleMap.ScaleWidth  : integer
  property TECNativeScaleMap.ScaleLegend : string
  property TECNativeScaleMap.OnChange    : TNotifyEvent

  see maj firemonkey demo for manual management of the scale and copyright
  Enables proper display even during map rotation



  CHANGE

  The element pointed by the mouse is displayed above all other

  the bounding box is now calculated on the tile border
  So it changes less often and allows fewer calls to layers as TECNativePlaceLayer
  The offline mode is more functional for this type of layers


  TNativeMapControl.Address,
  TNativeMapControl.GetAddressFromLatLng ,
  TNativeMapControl.GetLatLngFromAddress   use now  OpenStreetMap services ( before MapQuest )

  TECShape.Address use also OpenStreeMap

  To use MapQuest made :  map.geoLocalise.Search and  map.geoLocalise.Reverse


  OnMapMouseDown & OnMapMouseUp is call after OnShapeMouseDown & OnShapeMouseUp


  2.6

  BUG

  Fixed a bug in animations that causes a crash in some circumstances

  On android overlays tiles are paused during their creation.


  Map.TileServerInfo.GetTileStream not work on Android




  TNativeMapControl.WorldInfo.MouseLng  is wrong ( equal to MouseLat )

  ADD

  support for MapZen Vector Tiles ( https://mapzen.com/projects/vector-tiles )

  new tiles server : tsMapZen

  Support styles for shapes

  for doc see http://www.helpandweb.com/ecmap/en/vector_tiles.htm



  TNativeMapControl.DrawVectorTiles (default true)

  Control the display of vector data,
  even if they are not displayed you can get the information
  and do research in the OSM data

  sample

  map.AddOverlayTileServer(tsVectorMapZen);
  map.DrawVectorTiles := false;


  support tile servers tsYandexNormal,tsYandexSatellite,
  tsYandexHybrid,tsYandexPeople    (thanks alexey t.)



  procedure TNativeMapControl.ShowHintAtPos(const Lat,Lng:double;
  const Hint:string;
  const DelayHint:cardinal=DEFAULT_DELAY_HINT);


  function TECShapes.AddPoint( const Lat, Lng: double;
  const Color:TColor=COLOR_DEFAULT;
  const Size:integer=10;
  const BSize:integer=2):TECShapePOI;

  Shortcut to create a circular TECShapePOI with a white border

  map.shapes.addPoint(lat,lng,clGreen);
  map.shapes.addPoint(lat,lng,clBlue,12);


  function TECShapeLineList.Add(const dLatLngs: array of double): integer;
  function TECShapePolygoneList.Add(const dLatLngs: array of double): integer;

  map.shapes.lines.add([38.380978,46.690119,38.380978,46.190119]);
  map.shapes.polygones.add([38.380978,46.690119,38.380978,46.190119]);


  TECShapeLine & TECShapePolygone

  Hint appears at the point where the mouse enters into contact first


  TECShape.PanTo

  centers the map on the item

  If the change is less than both the width and height of the map,
  the transition will be smoothly animated

  map.shapes.markers[0].PanTo;


  TECShapeInfoWindow

  property MinHeight : integer

  minimal height

  property BDRightToLeft: boolean

  trying to put words in the right order for languages that read from right to left



  Limiting the precision with x digits after the decimal for geolocation  (thanks Mihai)

  Default 5 on Desktop and 4 on mobile

  you can change like this

  map.geolocalise.DecimalPrecision := 6;

  also in TECNativePlaceLayer

  FPlacesLayer := TECNativePlaceLayer.create(map,'PLACES_LAYER');
  FPlacesLayer.DecimalPrecision := 6;



  2.5

  BUGS

  Freeze when passing in the background on Android   ( thanks mihai )

  VCL change Parent break the zoom with mouse wheel ( thanks Pier )

  OnCompleteTiles does not take into account the tile overlays

  Bad double-tap and zoom gesture when align <> client on FMX   (thanks Freddy )

  Memory Leak if Selected is not empty when free map

  Wrong position of copyright with OversizeForRotation

  unwanted movement of map if you make a selection within 5 pixels and MouseButtonDragZoom := mbLeft (merci gilles)

  Dropping an element on a cluster trigger a click on the cluster

  minZoom and maxZoom clusters should be limited by minZoom and maxZoom of the group to which the cluster belongs

  at startup the tile server connects to the internet
  even if the tile is in the local cache ( thanks Pier )

  The Names list items were not updated after deleting items ( thanks Pier & Gilles )

  TECShapeLine / TECShapePolygone

  not draw at good position on MultiView

  property Tag not save (merci christophe)

  property Name not initialize after a second load (thank fabio)


  BoundingBox not working

  TECDownLoadTiles all the files are not downloaded (thank Andreas )

  XML header for KML file,
  TECShapes.SaveToFile error extension,
  LatLonFromDistanceBearing                  ( merci Philippe )

  TECShapePOI

  corrects XAnchor and YAnchor

  CHANGE

  Geocoding

  If a directory is assigned to LocalCache,
  geocoding data (addresses, routes, places) are saved and can be retrieved
  even in off-line mode

  the data are placed in the subdirectories OPEN_MAPQUEST_SERVICES and PLACES

  PanTo

  If the change is less than both the width and height of the map,
  the transition will be smoothly animated

  by default the animation takes 250ms, you can change this with _MAX_TIME_PAN

  _MAX_TIME_PAN := 100;

  TECDownLoadTiles use a thread to calculate the load tiles
  that prevents freeze when the geographical area is important

  The Mercator projection is activated when a predefined tile server (tsOSM, tsBingRoad ...) is used
  Before if you used a different projection, Mercator was not reactivated


  ADD

  property TNativeMapControl.ScreenShots : TECOffScreenScreenShot

  Capture of geographical areas, even off-screen, and save them as a bitmap

  use

  // procedure call when bitmap ready
  map.ScreenShots.OnScreenShot := doScreenShot ;

  // you can change the size of the bitmap between each capture (default 800x600)
  // max size is 8192x8192

  map.ScreenShots.Width := 2000;
  map.ScreenShots.Height:= 2000;

  // capture area centered on a point with a specified zoom
  map.ScreenShots.ScreenShot(latitude,longiture,16,'optional_name_of_capture');

  // you can take screenshots even if the previous is not over yet

  // Take the best zoom to a specific area
  map.ScreenShots.ScreenShot(NorthEastLat, NorthEastELng, SouthWestWLat, SouthWestLng,'optional_name_of_capture');

  // Take the best zoom to an area defined by its center and radius in km
  // CAUTION use double for the radius, here 1.0 km, otherwise it will be mistaken for a simple zoom

  map.ScreenShots.ScreenShot(Latitude, Longitude, 1.0 ,'optional_name_of_capture');


  // when capture is ready, you go here
  procedure TForm.doScreenShot(const name:string;const Screenshot:TBitmap);
  begin
  // don't free ScreenShot !
  screenshot.SaveToFile(YourPath+name+'.bmp');
  end;


  procedure TNativeMapControl.DrawOffScreen(const EventDraw:TNotifyEvent)

  Use the map without screen display, useful for creating a large bitmap for printing
  This procedure is the basis for ScreenShots, it is available for greater flexibility

  MapOffScreen.visible := false;
  MapOffScreen.width := 2500;
  MapOffScreen.Height:= 2500;

  // import data from visible map

  MapOffScreen.ToTxt := Map.ToTxt ;
  // center on your zone
  MapOffScreen.setCenter(lat,Lng);

  // DrawOffScreen call MapOffScreen_Ready when ok
  MapOffScreen.DrawOffScreen(MapOffScreen_Ready);

  ...
  // here MapOffScreen.ScreenShot contains the image of your map
  procedure TForm.MapOffScreen_Ready(Sender:TObject);
  begin
  MapOffScreen.ScreenShot.SaveToFile(filename);
  end;




  By default the component's internal messages are managed by threads,
  you can change this so that they are distributed when your application is idle


  map.useExternControlIDLE := true;
  Application.OnIdle       := IdleApp;
  ...
  procedure TForm.IdleApp(Sender: TObject; var Done: Boolean);
  begin

  map.ProcessMessages;

  done := true;
  end;


  procedure TNativeMapControl.ClearMemoryCache;

  clear memory used by tiles


  function TNativeMapControl.AddGeodesicLine(const SLat,SLng,ELat,ELng:double;
  const GroupName: string = '';
  const maxSegmentLength:integer=5000): TECShapeLine;

  draws the line between the starting point and destination using the shortest route

  MaxSegmentLenght (in meters) is the maximum size of the intermediate segments



  function TNativeMapControl.AddLine(const dLatLngs: array of double; const GroupName: string = '')
  : TECShapeLine;

  line := map.AddLine([lat1,lng1,lat2,lng2,...]);

  function TNativeMapControl.AddPolygone(const dLatLngs: array of double; const GroupName: string = '')
  : TECShapePolygone;

  polygone := map.AddPolygone([lat1,lng1,lat2,lng2,...]);


  function TECShapeLine.Add(const dLatLngs: array of double);

  pline.add([lat1,lng1,lat2,lng2,...]);
  pgone.add([lat1,lng1,lat2,lng2,...]);



  Using low-resolution tiles to avoid gray area,
  a smaller zoom is used, the tiles were expanded to cover a larger area
  so fewer tiles faster display

  3 zoom levels are used, the low quality zoom chosen is the one that is closest to the current zoom but is smaller

  property MaxLowZoom  (default 10)
  property MedLowZoom  (default 10)
  property MinLowZoom  (default 5)


  Default low quality tiles use the same server as the base tiles, but you can choose another server

  property LowTileServer: TTileServer


  TECSelectedShapesList.ToKml

  s := map.Selected.ToKml;


  TECDownLoadTiles.ForceRefreshTiles
  if true don't use the tile in cache, allway download


  Support for multiple layers, previously there was only the base layer plus one additional layer

  add class TECOverlayTileLayer

  function  IndexOf:integer;
  procedure ExChange(const value:integer);

  property LocalCache     : string

  property Name           : string

  property MaxZoom        : byte
  property MinZoom        : byte

  property Opacity        : double (0..1) only FMX

  property TileFilename   : TOnMapServerTilePath
  property TileStream     : TOnMapServerTileStream

  property Visible        : boolean

  function TNativeMapControl.getOverlayTilesByName(const value:string):TECOverlayTileLayer;

  function TNativeMapControl.AddOverlayTiles(getOverlayTiles: TOnMapServerTilePath;
  const Name: string = 'Overlay_Tiles'; const MaxZoom: byte = 18;
  const MinZoom: byte = 2):TECOverlayTileLayer;

  function TNativeMapControl.AddOverlayTileServer(value: TTileServer):TECOverlayTileLayer;

  function TNativeMapControl.AddOverlayStreamTiles(getOverlayStreamTiles :TOnMapServerTileStream;
  const Name: string = 'Overlay_StreamTiles';
  const MaxZoom: byte = 18; const MinZoom: byte = 2):TECOverlayTileLayer;

  procedure TNativeMapControl.RemoveOverlayTiles(const index:integer);
  procedure TNativeMapControl.RemoveOverlayTiles(const overlay:TECOverlayTileLayer);

  procedure TNativeMapControl.RemoveAllOverlayTiles;

  The use is the same but there is no limit

  // add traffic layer
  map.AddOverlayTileServer(tsHereFlow);



  Add class TECOpenWeatherTilesLayer for support OpenWeatherMap layers (see http://openweathermap.org/tile_map )

  TOWTileServer = (owPrecipitation,owPrecipitation_cls,owRain,owRain_cls,owSnow,owClouds,owClouds_cls,owPressure,
  owPressure_cntr,owTemp,owWind);


  constructor TECOpenWeatherTilesLayer.Create(const MapValue : TNativeMapControl);

  function  TECOpenWeatherTilesLayer.Add(const Layer:TOWTileServer):TECOverlayTileLayer;
  function  TECOpenWeatherTilesLayer.Get(const Layer:TOWTileServer):TECOverlayTileLayer;
  procedure TECOpenWeatherTilesLayer.Remove(const Layer:TOWTileServer);
  procedure TECOpenWeatherTilesLayer.RemoveAll;

  sample

  FECOpenWeatherTilesLayer := TECOpenWeatherTilesLayer.Create(map) ;
  ...
  // add 2 layers
  FECOpenWeatherTilesLayer.add(owRain);
  FECOpenWeatherTilesLayer.add(owPressure_cntr);
  ...
  // release when you no longer need
  FECOpenWeatherTilesLayer.free

  Ability to change the display duration of information windows (hint)    (thank carlos)
  You can change either at group level or item (default 2secondes)

  map.shapes.DelayHint := 3000; // 3 secondes
  map.shapes.markers[0].DelayHint := 1500; // 1.5 seconde


  function TNativeMapControl.AddLine(const EncodedLine:string; const GroupName: string = ''): TECShapeLine;
  function TNativeMapControl.AddPolygone(const EncodedLine:string; const GroupName: string = ''): TECShapePolygone;




  TECShape.BringToFront
  Force element to be above all other regardless of ZIndex

  now TECShape.setFocus call BringToFront

  TNativeMapControl.ShapeBringToFront

  get/set shape in front

  map.shapeBringToFront := map.shapes.markers[0] == map.shapes.markers[0].BringToFront



  TECClusterManager

  MinZoom

  default value 1

  add events OnMouseOverCluster and OnMouseOutCluster

  map.Shapes.ClusterManager.OnMouseOverCluster := doOnOverCluster;
  map.Shapes.ClusterManager.OnMouseOutCluster  := doOnOutCluster;

  procedure TForm.doOnOverCluster(const Cluster : TECCluster);
  begin
  // mouse enters the cluster
  end;

  procedure TForm.doOnOutCluster(const Cluster : TECCluster);
  begin
  // mouse leaves the cluster
  end;




  2.4

  BUG

  regression zindex in 2.3

  when we decrease the zoom, then increased, it is no longer at the same location  ( thanks mihai )

  CRASH if shape is deleted while the mouse pointer was hovering on that shape ( thanks Alessendro )

  TECShapePolygone

  not refresh after resize map


  TECShapeLine

  the last point of TECShapeLine was not taken into account for the calculation of the bounding box,
  then the line was not displayed if only the last point was visible on the screen ( thanks mihai )


  TECShapeLine & TECShapePolygone

  All Propertie were not saved with ToTXT (thanks Gary )

  if the first element (polyline or polygon) was empty,
  the elements were traveling with the map regardless of their actual position  (thanks Gary )



  Draggable = false not working as it should ( thanks Gary )

  crash TThreadedPoolPlaces (uecNativePlace) and TThreadedPoolPanoramio (uecNativePanoramio)

  Bad resize for TECShapePOI in editable mode (merci gilles)

  The cancellation of Draggable mode for TECShape was not passed for him being moved   (merci gilles)

  Crash if delete in IDE  (thanks alessandro )

  support iOS-64 ( thanks mihai and  foroud )

  publication of property Anchors VCL ( thanks mihai )

  zoom by fingers don't fire OnChangeMapZoom and OnChangeMapBounds ( thanks mihai )

  Clic + Move Map fire OnMapClick when Mouse Up  ( thanks mihai )

  ADD

  Optimisation of the display for markers with rotation

  OnKeyUP, OnKeyDow (also OnKeyPress on VCL)

  ForceRefreshDisplayedTiles

  forces a download of the displayed tiles, even if they are in the local cache


  new animation TECAnimationMoveToDirection

  move an item based on a speed in km/h and a direction (0-360, 0 = north)

  sample

  // move towards the south, 60 km/h
  animD := TECAnimationMoveToDirection.Create(60,180);

  ShapePOI.Animation := animD;
  // orienting the item based on its direction
  animD.Heading := true;

  animD.Timeout := 2000; // stop anim after 2s, set to 0 for illimited

  // start move
  animD.Start;


  property ZoomScaleFactor : TZoomScaleFactor   (0..99)

  can emulate the intermediate zoom

  map.zoom: = 15;
  map.ZoomScaleFactor: = 80;

  is equivalent to a zoom 15.8

  Press the right mouse button + scroll wheel to change ZoomScaleFactor

  use property WheelZoomScaleFactorIncrement to ajust increment, 1 by default

  procedure ZoomScaleFactorAround(const LatLngZoom: TLatLng; const NewZoomScaleFactor: integer);


  function TNativeMapControl.FindShapeByArea(const SWALat,SWALng,NEALat,NEALng  :double;const ShapeList:TList<TECShape>):integer;
  function FindShapeByKMDistance(const FLat,FLng,FKMDistance  :double;const ShapeList:TList<TECShape>):integer;

  ! For D7-D2009 use ShapeList:TList !

  sample : find items located 100 meters from the center of the map

  var L:TList<TECShape>;
  nbr:integer;
  ...

  L   := TList<TECShape>.create;
  nbr := map.FindShapeByKMDistance(map.latitude,map.longitude,0.100,L) ;


  SUPPORT FOR CLUSTERING

  to understand what clustering see https://developers.google.com/maps/articles/toomanymarkers

  in summary, the markers and pois that are close are grouped into one element (circle) that displays the total of the items

  Each group manages its clusters

  TECShapes.Clusterable
  allows clustering, by default false

  TECShapes.ClusterManager
  defined the cluster options

  property Color             : TColor
  property TextColor         : TColor
  property BorderColor       : TColor
  property BorderSize        : integer
  property FontSize          : integer
  property Opacity           : byte
  property WidthHeight       : integer


  property MaxPixelDistance  : integer

  if the elements are within MaxPixelDistance they are grouped (default 60 pixels)


  property DrawWhenMoving    : boolean

  Displays the cluster while you move the map, default true


  property MaxZoom           : byte

  If the zoom exceeds maxZoom items are not grouped, default 17


  property OnAddShapeToCluster : TOnAddShapeToCluster (sender : TECCluster; const Shape:TECShape;var cancel:boolean)

  to reject putting cancel to true, default false


  property OnColorSizeCluster  : TOnColorSizeCluster (const Cluster : TECCluster;
  var Color:TColor;var BorderColor:TColor;var TextColor:TColor,
  var WidthHeight,FontSize:integer)

  Triggered before the cluster display, you can adjust the colors

  property OnDrawCluster       : TOnDrawCluster (const Canvas : TECCanvas; var rect : TRect; Cluster : TECCluster)

  If you tune this event you are supporting the cluster design


  example, allow clusters for the default group and change color depending on the number of items

  map.Shapes.Clusterable := true;
  map.Shapes.ClusterManager.OnColorSizeCluster := doOnColorSizeCluster;

  procedure TForm.doOnColorSizeCluster(const Cluster : TECCluster;
  var Color:TColor;var BorderColor:TColor;var TextColor:TColor;
  var WidthHeight,FontSize:integer
  );
  begin

  if Cluster.Count<10 then
  begin
  Color := clGreen;
  end

  else

  if Cluster.Count<100 then
  begin
  Color := clBlue;
  end

  else

  Color := clRed;

  end;


  The TECShape have a clusterable property (true default) which allows exclusion of clusters

  map.shapes.markers[10].Clusterable := false;


  add event TNativeMapControl.OnClusterClick


  SUPPORT FOR MULTI VIEW

  You can connect other TECNativeMap on the main map,
  they are completely independent except that they use the master map items.

  Items are not duplicated, changes to a view are automatically reflected on all other

  Items added in the views are in fact added to the main map


  procedure TNativeMapControl.AddView(const view:TNativeMapControl);
  procedure TNativeMapControl.ReleaseView(const view:TNativeMapControl);
  procedure TNativeMapControl.ReleaseAllView;

  property TNativeMapControl.ViewCount : integer;
  property TNativeMapControl.Views[index:integer] : TNativeMapControl

  property TNativeMapControl.OnAddShapeToView : TOnAddShapeToView

  Tune in to this event if you want to filter the items displayed on the view

  example, only show star

  ViewA.OnAddShapeToView := doOnAddShapeToView;
  ...
  procedure TForm.doOnAddShapeToView(sender : TObject; const Shape:TECShape;var cancel:boolean) ;
  begin

  // sender is the view, cast for use TECNativeMap(sender);

  if Shape is TECShapePOI then
  cancel := not (TECShapePOI(shape).POIShape = poiStar)
  else
  cancel := true;

  end;



  function TECShapeLine.PositionAndDistanceOfNearestPointTo(const LatPt, LngPt : Double;var nrLatPt, nrLngPt : Double):double;

  returns, in meters, the shortest distance between a point outside the line and the line

  nrLatPt, nrLngPt indicates the point of intersection on the line

  (also work for TECShapePolygon)




  TECSelectedShapesList.OnSelectShape(sender : TObject; const Shape:TECShape;var cancel:boolean)

  use for filter selection

  map.Selected.OnSelectShape := doOnSelectShape;
  ...
  procedure TForm.doOnSelectShape(sender : TObject; const Shape:TECShape;var cancel:boolean) ;
  begin
  // select only TECShapePOI
  cancel := not (Shape is TECShapePOI);
  end;


  Change

  IMPROVING THE ZOOM

  improved import KML

  TECShapePolygone

  You can now use BorderColor ( = color ), BorderSize ( = Weight) and HoverBorderColor


  2.3

  Bugs

  IDE crash during a cut and paste of the component       (thank Kostya P.)

  Display slowed to zoom < 4  (thank Kostya P.)

  Memory leak in TThreadedPoolPlaces (uecNativePlace) (thank Kostya P.)
  Memory leak in TThreadedPoolPanoramio (uecNativePanoramio) same as TThreadedPoolPlaces

  TECShapeLine & TECShapePolygone

  not select the shape if there are only 2 points  (thank Bruce C.)

  MiniMap position when resize if map.OverSizeForRotation = true

  There is a bug with TPageControl the wheel activates the map placed on the last TTabSheet,
  even if the TTabSheet is not active (thank Carlos)

  TECShapePolygone error with Level ( not clear, not good colors ) (merci Gilles)

  bad clipping on TECShapeLine with high zoom (merci Simon )

  miscalculation TECShapePOI dimension in meters (thank Bart )

  in VCL the mouse stops working if you change the position of the form containing TECNativeMap from another form  (merci Gilles)

  aMapForm  := TFormNativeLinePolygone.Create(nil);
  // bug after this line
  aMapForm.Position := pPosition;

  GetASyncRoutePathFrom not working


  Add

  Iterator for all list of shapes (markers, pois, lines, polygones  and infowindows )

  use

  var poly : TECShapePolygone;

  for poly in map.shapes.polygones do
  begin
  poly.color := clRed;
  end;


  TNativeMapControl.Groups:TECGroupShapesList

  to access the group by index

  use

  for i:=0 to map.groups.count-1 do
  map.groups[i].Clear;

  or by iterator

  Group : TECShapes;

  for Group in map.Groups do
  Group.Clear;



  TECShape.MaxShowHint

  number of times the hint is displayed, set to 0 to infinity (default 0)
  you can reactivate by EnabledHint := true, or MaxShowHint := x (x> 0)


  TECShape.Selected : boolean

  Indicates whether the item is selected

  map.shapes.markers[10].Selected := true;



  TNativeMapControl.Selected : TECSelectedShapesList

  List manager selected items

  TECSelectedShapesList = class
  public

  procedure UnSelectedAll; // deselects all elements without removing them from the map

  procedure Clear;  // removes all selected items on the map

  function  count : integer;

  // select items in area
  function ByArea(const NEALat,NEALng,SWALat,SWALng  :double):integer;

  // select items <= KMDistance to FLat,FLng
  function ByKMDistance(const FLat,FLng,FKMDistance  :double):integer;

  procedure SaveToFile(const filename:string);

  property Item[index: integer]: TECShape read getShape; default;

  // filter by groups (empty = all groups)
  property GroupFilter         : TStringList

  property ToTxt:string // returns all items selected in the txt format TECNativeMap (readonly)

  property NELat : double ;  // bounds last selection (read oly)
  property NELng : double ;
  property SWLat : double ;
  property SWLng : double ;

  property OnChange:TNotifyEvent ; // fired when add or remove item

  end;


  you can use Iterator

  var shape:TECShape

  for shape in map.Selected do
  begin
  ..
  end;

  set the property TNativeMapControl.DragRect to drSelect to define a selection rectangle
  using the right mouse button down and dragging

  event OnMapSelectRect(sender:TObject,SWLat,SWLng,NELat,NELng) is fired



  TNativeMapControl.setProjection(LatLngToXY , XYToLatLng)

  Change the projection system

  sample

  map.setProjection(LatLngToXY,XYToLatLng);

  procedure TMainForm.LatLngToXY(const Lat,Lng:double;var X,Y:double);
  begin
  // Calculate X and Y from the latitude and longitude
  end;

  procedure TMainForm.XYToLatLng(const X,Y:double;var Lat,Lng:double);
  begin
  // Calculate latitude and longitude from X and Y
  end;

  for default projection use  map.setProjection(nil,nil);




  TECNativeMapControl.Clear

  Clear all groups


  TECNativeMapControl.MaxShapeShowOnMoveMap

  Before the elements are not displayed on a moving map if there were more MaxShapeShowOnMoveMap

  Now it displays a maximum MaxShapeShowOnMoveMap items on a moving map

  Small additional optimization, we abandon all positioning calculations on the elements
  that will not be displayed because too many


  TECShapePOI.MeterWidth ,  TECShapePOI.MeterHeight

  return size POI in meters   (merci Gilles)


  TECNativeScaleMap ( unit uecNativeScaleMap )

  Adding a scale bar

  property AnchorPosition (apTopLeft, apTopRight, apBottomLeft, apBottomRight )

  anchors the scale over a corner, default apBottomLeft

  property XMargin and YMargin to adjust the offset from the edges

  property BarSize  bar thickness (default 2);

  property Color    bar color (default black)

  property MaxWidth maximum length of the bar in pixels (default 80)

  property MesureSystem  measuring system (msMetric, msImperial) default msMetric

  property Shadow adds a shadow (default true)


  sample (add unit uecNativeScaleMap in uses )

  procedure TForm1.FormCreate(Sender: TObject);
  begin

  FECNativeScaleMap := TECNativeScaleMap.create ;
  FECNativeScaleMap.Map := map;

  end;

  procedure TForm1.FormDestroy(Sender: TObject);
  begin

  FECNativeScaleMap.free;

  end;



  TECNativeMeasureMap (unit uecNativeMeasureMap)

  add ruler for measure on map

  property Color ;  default black

  property MeasureSystem;  measuring system (msMetric, msImperial) default msMetric

  property Distance      : double read FDistance;
  property DistanceLabel : string read FDistanceLabel;


  property Hint  : string ; info text

  property ShowDistance : boolean   show/hide distance on map ( default true )

  property OnChange : TNotifyEvent ; fired when distance change


  sample (add unit uecNativeMeasureMap in uses )

  procedure TForm1.FormCreate(Sender: TObject);
  begin

  FECNativeMeasureMap := TECNativeMeasureMap.create ;
  FECNativeMeasureMap.Map := map;

  FECNativeMeasureMap.StartMeasure(map.latitude,map.longitude);

  end;

  procedure TForm1.FormDestroy(Sender: TObject);
  begin

  FECNativeMeasureMap.free;

  end;


  TECShapePolygone

  Use Douglas-Peucker simplification algorithm

  add TECShapePolygone.AccuracyDraw for control simplication

  TECShapePolygone.AccuracyScaleZoom and   TECShapeLine.AccuracyScaleZoom

  reduction use AccuracyDraw / (AccuracyScaleZoom*Zoom)

  TECShapePolygone.MinPointForUseDouglasPeucker  and TECShapeLine.MinPointForUseDouglasPeucker

  minium points for reduction with Dougles-Peucker algo (default 100)


  Change

  delete property TECNativeMapControl.DragZoom,
  remplaced by DragRect type TDragRect = (drNone,drSelect,drZoom)


  TECNativeMiniMap

  property AnchorPosition (apTopLeft, apTopRight, apBottomLeft, apBottomRight )

  anchors the minimap over a corner, default apBottomRight

  property XMargin and YMargin to adjust the offset from the edges

  property BorderColor
  property BorderSize


  2.2

  BUG

  Automatic connexion to bing server on start even if not use tsbingRoad,tsbingAerial,tsbingAerialLabels

  visible not allway redraw map

  fitbounds


  TECShapeLine.CenterOnMap;
  TECShapePolygon.CenterOnMap;

  Correction angle in TECShapeMarker

  ADD

  TECShapeLine support Clipping, only the visible portions of the line are drawn

  TECShapeLine.PathIndexChange
  TECShapePolygone.PathIndexChange

  index of the segment that was added, inserted, modified or deleted
  you can test it in event OnShapePathChange



  TECShape.setDirection(Latitude,Longitude);

  move shape at Latitude,Longitude  like setPosition
  change the angle of rotation according to the direction

  FIREMONKEY

  Don't use tpathdata for draw line it's hyper slow on android, better is canvas.drawline !

  improved pinch and zoom

  support rotation Map

  So that the rotation does not cut corners, the size of the map should be doubled
  it is then necessary to mask areas outside the field,
  for that you need to place your map in a TPanel (or TRectangle) to be the size of the visible area

  To adjust the size of your map do

  map.OverSizeForRotation := true;

  To allow or not the rotation gesture use the property EnableTouchRotation

  map.EnableTouchRotation := true;

  the action is prohibited by default


  2.1.1

  XE7 update 1, WM_SIZE not call in init ?
  Import KML triggers "Out of Memories" with large files using <MultiGeometry>



  Version 2.0.1

  BUG
  correct size component if align=alnone

  Version 2.1

  BUGS

  spaces prevent the address resolution android

  TECShapes.FitBounds

  Save/load TileServer for Here tiles

  Blocking potential in InfoWindows

  Check whether the zoom is within the boundaries when changing type of map

  TECShapeLine / TECShapePolygon

  delete point in editable mode

  SetPosition

  TECShapePOI

  Incorrect calculation of box to determine whether the element is visible on the screen

  ADD

  TECDownLoadTiles

  Download area of tiles

  sample

  FECDownLoadTiles:=TECDownLoadTiles.create;

  FECDownLoadTiles.OnDownLoad    := doDownLoadtiles;
  FECDownLoadTiles.OnEndDownLoad := doEndDownLoadtiles;

  // tiles are saved in DirectoryTiles
  FECDownLoadTiles.DirectoryTiles := map.LocalCache;

  FECDownLoadTiles.TileServer     := map.TileServer;
  FECDownLoadTiles.TileSize       := map.TileSize;

  // download visible area from zoom+1 to MaxZoom

  FECDownLoadTiles.DownLoadTiles(map.Zoom+1,map.MaxZoom,
  map.NorthEastLatitude,map.NorthEastLongitude,
  map.SouthWestLatitude,map.SouthWestLongitude);

  ...


  // for abort
  FECDownLoadTiles.Cancel;

  see ECNativeMapFiremokeyDemo  for complete use



  property TECGeolocalise.ReverseResults:TStringList;

  use

  adr := map.Geolocalise.Reverse(lat,lng);

  // now ReverseResults contains tags in nominatim <addressparts>


  country := map.Geolocalise.ReverseResults['country'];
  road    := map.Geolocalise.ReverseResults['road'];
  postcode:= map.Geolocalise.ReverseResults['postcode'];
  ...



  Support Here tiles (tsHereSatellite,  tsHereHybrid )

  Firemonkey  Support Hi-Resolution , default false

  property HiRes : boolean;

  map.HiRes := true;

  The standard marker (no bitmap), the TECShapePOI (in pixels),
  the InfoWindows and layers Panoramio are scaled automatically
  when switching to high resolution mode

  High resolution using tiles Here 512 pixels rendering is better


  TECNativePlaceLayer.XAnchor     ( see uecNativePlaceLayer  )
  TECNativePlaceLayer.YAnchor
  TECNativePlaceLayer.HiResXAnchor
  TECNativePlaceLayer.HiResYAnchor
  TECNativePlaceLayer.MarkerHiResFilename


  VCL TECShapePOI

  support opacity even poiEllipse
  border not transparent


  TECShapeMarker.SetHitBox(x, y, w,h)

  X, Y, set the top left corner of the clickable area
  W the width of the area
  H is the height of the area

  The top left corner of the marker is at 0,0

  sample

  map.shapes.markers[0].SetHitBox(10,10,50,30)


  property TECShapeLine.OnCreateShapeLinePoint

  redefine the creation selection points for lines / polygones

  sample


  line := map.add(nsLine,Lat,Lng);

  // change d fault point
  line.OnCreateShapeLinePoint := doCreateShapeLinePointEditable;


  procedure TForm1.doCreateShapeLinePointEditable(sender: TObject; const Group:TECShapes;
  var ShapeLinePoint: TECShape;
  const Lat,Lng:double;const index:integer);
  var i:integer;
  poi:TECShapePOI;
  begin

  i   := Group.Pois.add(lat,Lng);
  Poi := Group.Pois[i];

  ShapeLinePoint := poi;

  poi.Width := 10;
  poi.Height:= 10;

  poi.POIShape := poiRect;

  poi.Color           := claWhite;
  poi.HoverColor      := claWhite;
  poi.BorderColor     := claBlack;
  poi.HoverBorderColor:= claBlack;

  end;


  Version 2.0

  BUGS

  A non-clickable item placed on another clickable element hides the click

  TECShapePOI incorrect size width POIUnit = puMeter

  TECNativePlaceLayer

  missing the tag </gpx> when recording gpx formats

  missing  TECShapePolygone.FillOpacity

  now TECShapePolygone.Opacity = border opacity

  Flashing tiles with some animations if ZoomEffect = false

  Color compatibility between VCL and FireMonkey of imports and exports to txt

  TECShapeInfoWindow images are not displayed automatically when loaded for the first time

  Import KML

  all polylines and polygones in a MultiGeometry have the same Description

  import in 2 passes to take account of defined styles after objects

  REMOVE

  TECShape.EnabledHover instead use TECShape.Clickable

  ADD

  Support XE7

  Support Here tiles (tsHereNormal,  tsHereTerrain, tsHereMobile, tsHereHiRes, tsHereTransit,
  tsHereTraffic, tsHereFlow, tsHereTruck , tsHereTruckTransparent )

  YOU MUST GET YOUR HERE APP_ID / APP_CODE => http://developer.here.com/get-started

  map.HereID     := YOUR_HERE_ID
  map.HereCode   := YOUR_HERE_CODE
  map.TileServer := tsHereNormal;



  function TNativeMapControl.AddPOI(const Lat, Lng: double; const GroupName: string = ''): TECShapePOI;
  function TNativeMapControl.AddMarker(const Lat, Lng: double; const GroupName: string = ''): TECShapeMarker;
  function TNativeMapControl.AddLine(const Lat, Lng: double; const GroupName: string = ''): TECShapeLine;
  function TNativeMapControl.AddPolygone(const Lat, Lng: double; const GroupName: string = ''): TECShapePolygone;
  function TNativeMapControl.AddInfoWindow(const Lat, Lng: double; const GroupName: string = ''): TECShapeInfoWindow;


  TNativeMapControl.ZoomAround(const LatLngZoom:TLatLng; const NewZoom:Integer)

  Zooms the map while keeping a specified point on the map stationary (like for scroll zoom and double-click zoom).

  Improved pinch and zoom on mobile

  Double click zoom use ZoomAround


  TNativeMapControl.HideShapesWhenZoom

  if true Hide Shapes when zoom, default false

  TNativeMapControl.Locale

  language used in the routing instructions,  can be any supported ISO 639-1 code

  map.Locale := 'fr_FR';

  Under Windows Locale is automatically populated using GetLocaleInfo


  property TECShape.Pressed set true if now pressed with left button

  VCL TECShapeMarker support opacity

  VCL TECShapePOI support opacity  (except poiEllipse)


  Adjust the size of TECShapePOI with the mouse

  poi.Editable := true;


  TECShapePOI type poiText show property Description

  poi.POIShape    := poiText
  poi.Description := 'my multi line text';

  property TECShapeLine.BorderColor      : TColor
  property TECShapeLine.HoverBorderColor : TColor
  property TECShapeLine.BorderSize       : integer    (default 0)

  Support Google Encoded Polyline Algorithm Format
  see https://developers.google.com/maps/documentation/utilities/polylinealgorithm

  property TECShapeLine.Encoded : string;

  map.shapes.lines[0].Encoded := 'opq~FnnavOp`@ja@|Nal@j]vX';
  s := map.shapes.lines[0].Encoded;

  map.shapes.polygones[0].Encoded := 'opq~FnnavOp`@ja@|Nal@j]vX';
  s := map.shapes.polygones[0].Encoded;


  TNativeMapControl.SaveEncodedPolyline default true

  SaveToFile, ToTxt saves encoded polylines and polygons
  It takes up less space and it's faster to reload

  An accuracy of 6 decimal places are used

  The old format is still readable even if TNativeMapControl.SaveEncodedPolyline = true

  use TNativeMapControl.SaveEncodedPolyline := false for save in old format


  function TECShapePolygone.ContainsLatLng(const lat: Double; const lng: Double) : Boolean;

  return true if point lat,lng is in Polygone


  TECShapeInfoWindow

  change the colors of text and background on mouseover  in tag <font>
  use params hcolor and hbkcolor

  TECShapeInfoWindow.Content := '<font hcolor=rrggbbaa hbkcolor=rrggbbaa>blabla</font>'



  EVENTS

  TECNativeMap.OnMapPaint(const canvas: TECCanvas);

  call after tiles draw but before shapes draw

  TECNativeMap.OnShapesPaint(const canvas: TECCanvas);

  call after shapes draw

  see unit UECGraphics for TECCanvas

  TECNativeLayer.OnMapPaint
  TECNativeLayer.OnShapesPaint




  Version 1.9.2

  Crash android when open window after click on shape with animation




  Version 1.9.1

  Bug TECShape.hint



  Version 1.9

  Bugs : redraw on resize;

  VCL version : only the first map can be zoomed with the mouse wheel

  reducing CPU consumption when use MiniMap

  reducing CPU consumption when map not moving and draw shapes

  TECShapeInfoWindo

  reducing CPU consumption

  set Cursor = crHandPoint on html link   (<a>text</a>)



  ADD

  Improved zoom at mouse position (thank you Bart)

  Improved zoom effect

  Event OnResize;

  property WorldLeftTop

  World coordinates corner Left, Top

  to move from one screen to the right

  var pt:TPoint;

  pt := map.WorldLeftTop;
  map.WorldLeftTop := Point(pt.x+map.width,pt.y);


  support Bing tiles (tsBingRoad, tsBingAerial, tsBingAerialLabels)

  YOU MUST GET YOUR BING MAP KEY => http://msdn.microsoft.com/fr-fr/library/ff428642.aspx

  map.BingKey    := YOUR_BING_KEY
  map.TileServer := tsBingRoad;


  TECAnimationFadePOI

  sample

  anim := TECAnimationFadePoi.Create;

  anim.MaxSize   := 32;
  anim.StartSize := 8 ;

  anim.StartOpacity := 90;

  map.Shapes.Pois[i].Animation := anim;


  TECAnimationDrawPath  (see ecNativeMapFiremonkeyDemo)

  sample

  // draw route in 3s

  DrawingRoute := TECAnimationDrawPath.Create(3000);

  // call when line is 100% draw
  DrawingRoute.OnEndAnimation := doOnDrawAllRoute;

  // call every draw
  DrawingRoute.OnDraw := doOnDraw

  // DrawingRoute will be automatically deleted
  map.shapes.Lines[i].Animation := DrawingRoute;


  Directly return a stream containing the jpeg or png of your tiles, useful if you have your tiles in a database

  procedure TForm.getTileStream(var TileStream: TMemoryStream;const x, y, z: integer);
  begin
  // here fill the stream with your tile
  end;

  procedure TForm.FormCreate(Sender: TObject);
  begin

  map.TileServerInfo.GetTileStream := getTileStream;
  map.TileServerInfo.Name := 'MyStream';
  map.TileServerInfo.TileFormat := stJpeg; // or stPng
  // called last, if not the first display is not performed
  map.TileServer := tsOwnerDraw;

  end;


  Version 1.8  support XE6

  Clear the background of the map at the launch

  Change MapQuest tiles path ->  http://otile[1-4].mqcdn.com/tiles/1.0.0/map/...

  add property

  TileSize  size of tile default = 256 pixels

  MouseButtonDragZoom  default mbright


  add

  TECShape.EnabledHover

  Responsive to mouseover


  TecShapePOI.BorderSize

  TecShapeList.MaxPointsShowOnMove

  Default = 1000

  Does not display a line while moving the map
  if the number of points is > MaxPointsShowOnMove

  map.shapes.lines.MaxPointsShowOnMove := 2000;


  TECShapeLine

  use Douglas-Peucker polyline simplification,
  tolerance = AccuracyDraw / zoom

  Default AccuracyDraw = 20

  map.shapes.lines[0].AccuracyDraw := 10;



  utility function to use Telogis Geobase tiles server  by Matt Redfearn

  (see http://docs.geobase.info/?topic=html/f7373dad-4347-4ec8-8860-4161b72cac79.htm)

  function  XYZToGeoBaseTile(const x,y,z:integer;
  const geoStreamServerURL:string;
  const geoTilesPerSuperTile:integer=4;
  const geoSatellite:boolean=false):String;

  sample

  procedure TForm.GetGeoBaseTile(var TileFilename:string;const x,y,z:integer);
  var TilePerSuperTile : integer;
  Satellite        : boolean;
  begin
  TilePerSuperTile := 4;
  Satellite        := false;

  TileFilename := map.XYZToGeoBaseTile(x,y,z,YOUR_geoStreamServerURL,TilePerSuperTile,Satellite);
  end;

  procedure TForm.FormCreate(Sender: TObject);
  begin

  map.tileSize := 300;  // default is 256
  map.LocalCache := ExtractFilePath(application.exename) + 'cache';
  // provider of custom tiles
  map.TileServerInfo.MaxZoom := 21;
  map.TileServerInfo.Name := 'GEOBASE-ROAD';
  map.TileServerInfo.GetTileFilename := GetGeoBaseTile;

  end;




  Version  1.7

  Bugs
  At initialization the component was not correctly positioned to the right coordinates (thank you Olaf )

  graphic change over state more responsive polygons

  ERangeError in TNativeMapControl.MyWindowProc when mouse wheel (in debug mode)

  InfoWindow  wrong color in tag <font>

  TECShapeList.getBounds, TECShapeMarkerList.getBounds

  TNativeMapControl.fitBounds



  Add

  TECNativeLabelLayer see unit uecNativeLabelLayer

  Add Label to TECShape (TECShapeMarker, TECShapePOI ...)

  The label is an InfoWindow that displays the contents of TECShape.Hint

  Label adapts itself to the position of TECShape and content of Hint

  Use :

  LLayer : TECNativeLabelLayer;

  LLayer := TECNativeLabelLayer.Create(Map,'my layer');
  LLayer.visible := true;

  LLayer.add(map.Shapes.Markers[0]);
  LLayer.add(map.Shapes.Pois[0]);


  see EcNativeMapFiremonkeyDemo and DemoNativeRoute


  TNativeMapControl.CopyrightColor
  TNativeMapControl.EmptyTileColor

  TNativeMapObserver.OnShapeMove
  TECNativeLayer.OnShapeMove
  TECNativeLayer.OnShapeDrag

  TECAnimationMoveOnPath.Heading (true/false)
  adjusting the angle according to the movement

  TECShapes.fitBounds
  TECShapeList.fitBounds
  TECShapeLine.fitbounds
  Display area containing all the elements in the best zoom


  TECShape.Description ( use when importing kml )
  TECShape.EnabledHint
  TECShape.Angle ( 0-360  available for TECShapeMarker and TECShapePOI )


  TECShapeInfoWindow new style iwsTransparent

  map.shapes.InfoWindows[0].Style := iwsTransparent

  FireMonkey support alpha color in tag <font color=rrggbbaa>
  support bkColor in <font bkcolor=rrggbbaa>


  TECShapePOI

  add

  poiHexagon and poiDiamond


  reducing CPU consumption when drag a shape

  Improvement Importing KML

  Faster even with thousands of polygons and polylines
  <StyleMap> tag Support (normal and highlight)
  tags Support Name and Description

  Zoom at the mouse pointer



  Version 1.5.2

  BUGS

  * TECShapeMarker.Graphic := TGraphic
  * TECShape.Cursor = crHandPoint even if not clickable

  ADD

  TECNativeMap.DragZoom

  press right mouse button and dragging a box around an area will zoom the map to that area when the button is released

  Version 1.6

  ADD

  class TecSelectPointNativeLine and TecNativeLineToRoute in unit uecEditNativeLine

  TecSelectPointNativeLine is for select a point in a TecShapeLine

  TecNativeLineToRoute will recalculate a route interactively from TecShapeLine

  move the square outside the path to change the path, double click the square to remove the waypoint

  ecNativeLineToRoute       := TecNativeLineToRoute.create;
  ...
  TecNativeLineToRoute.Line := nativemap.shapes.lines[0];
  ...
  ecNativeLineToRoute.free;



  Version 1.5.1 bugs TECNativeLayer


  version 1.5

  Support Android and iOS

  Support the inertia effect

  REMOVE Published Property GeoLocalise, no more component TECGeoLocalise on Palette

  map.geoLocalise is automatic created and is read only property

  But you can create manually TECGeoLocalise object and use it


  ADD find and reverse geocode with ArcGis

  function  TECGeolocalise.ArcGisReverse(const Lat,Lng:double):string;
  function  TECGeolocalise.ArcGisFind(const data:string;var Lat,Lng:double):boolean;

  in GetRoutePathByAdress, GetASyncRoutePathByAdress  if the search fails with MapQuest services, we try with ArcGIS


  ADD

  function TopGroupZIndex : longint; Returns the highest ZIndex of all groups

  property MaxShapeShowOnMoveMap for optimise speed on low cpu
  default 100 shapes on mobile, 4000 on other

  Event OnMapLongClick and OnShapeLongClick  fired if press more 0.5s when click

  Use Douglas-Peucker polyline simplification algorithm for TECShapeLine

  add TECShapeLine.AccuracyDraw for control simplication

  RENAME

  property CacheSize ==> TileCacheSize


  version 1.4.1  bug Mouse Wheel Zoom on VCL


  Version 1.4 :

  Support XE5 and Mac OS X

  if LocalCache defined searches are cached in directories OPEN_MAPQUEST_SERVICES and PLACES

  Enhanced support for GPX and GeoJson files

  Add

  procedure PreLoadGraphic(const Filename: string);

  property Url : string  read getUrl write setUrl

  getUrl result = #Zoom/Latitude/Longitude

  setUrl  fire event OnBeforeUrl(sender : TObject; var Url:string);


  if format #Zoom/Latitude/Longitude then set Zoom, Latitude and Longitude => permalink

  else open url in default browser



  InfoWindow :

  * support tag <a> in Content

  * support <img src="data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAAAAUA==" /> in Content

  * bug img size


  TECShapeMarker :

  * support Filename := "data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAAAAUA=="

  see http://en.wikipedia.org/wiki/Data_URI_scheme


  TECNativeUTFLayer support UTFGrid see http://www.mapbox.com/developers/utfgrid/


  TECNativeLayer :

  Add  :

  * property OnShapeRightClick
  * property OnMouseMove
  * property OnMouseClick
  * property MinZoom
  * property MaxZoom


  TECNativePlaceLayer see uecNativePlaceLayer


  version 1.2 :

  Bugs

  memory leak :

  * TECShapeMarker.SetFilename
  * GetAsyncRoutePathByAdress  & GetRoutePathByAdress
  * TECShapePolygone

  Add

  * procedure AddOverlayTiles(getOverlayTiles : TOnMapServerTilePath;const MaxZoom,MinZoom:byte);
  * procedure RemoveOverlayTiles

  AddOverlayTiles inlaid tiles transparent over the basic tiles

  * BingKey, CloudMadeKey, MapQuestKey for set your api key

  *  Event OnLoadShapes (sender : TObject; ShapeType : String; index,max:integer; var Cancel:boolean);

  * Event OnTraffic

  * TrafficLayer via Bing Service


  *  BoundingBox(maxLatitude,maxLongitude,minLatitude,minLatitude)

  Fix limit to map

  OnOutOfBounds is triggered when limits are exceeded

  call BoundingBox; (no parameters) for access to the world map

  InfoWindow :

  * Add CloseButton for show/hide close button
  * support tag <img> in Content


  TECShape :

  Add Animation

  * TECAnimationShapeColor
  * TECAnimationMarkerFilename
  * TECAnimationMarkerZoomFilename
  * TECAnimationMoveOnPath
  * TECAnimationGraphicWait



  TECShapeLine :

  * add property LineType : ltStraight (standard) , ltBezier (bezier curve)
  * add property PenStyle : psSolid, psDot, psDash and psDashdot

  TECShapeMarker

  * add WaitAnimation (true by default) show animation when loading image

  TECShapePolygon

  * add Style (TBrushStyle)
  * Border and style is displayed even if the polygon is transparent
  * add property Level (height in meters) for draw polygon in pseudo 3D

  version 1.3 :

  Support Firemonkey (windows) - XE3

  On firemonkey TECShapeMarker and TECShapePoi support Opacity

  TECShape.Hint is show with a TECShapeInfoWindow

  Bug :

  TECNativeMiniMap.TileServer crash if no map assigned (unit uecNativeMiniMap)






  
  version 1.1 :

  * move download thread graphics in unit uecThreadGraphics
  * move tiles engine in unit uecNativeTileServer
  * Accept controls on map
  * Add procedure TECShapeLine.SetPath(const dLatLngs: array of double) (see uecNativeShape)
  * Add minimap see uecNativeMiniMap
  * Add import/export GeoJson (file .json)
  * Add property TECShape.XHovertilesbitmap and TECSHape.YHover
  * Add InfoWindow
  * optimization of display tiles

  Bugs :

  * onMapMove not triggered when move map with mouse
  * onResize  not triggered
  * Crash if you leave during a search of places







  



























 