unit UCartoTrack;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes,
  System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs,
  FMX.uecNativeScaleMap, FMX.uecMapUtil,
  FMX.StdCtrls, FMX.Objects, FMX.Layouts,
  // TECNativeMap units
  FMX.uecNativeMapControl,
  FMX.uecNativeShape,
  FMX.uecgeoLocalise,
  FMX.uecGraphics,
  FMX.uecMapillary,
  // -------------------
  System.IOUtils,
{$IFDEF ANDROID}
  Androidapi.Jni.Os,
  Androidapi.Jni.javatypes,
  Androidapi.Helpers,
{$ENDIF}
  System.UIConsts,
  FMX.Controls.Presentation, System.Permissions, FMX.ListBox, FMX.Memo.Types,
  FMX.ScrollBox, FMX.Memo, System.Sensors, System.Sensors.Components,
  FMX.Platform, FMX.Edit, FMX.ComboEdit,FMX.surfaces,FMX.DialogService, FMX.Ani;

type
  TForm3 = class(TForm)
    Panel1: TPanel;
    map: TECNativeMap;
    LaBottom: TLayout;
    ScaleLegend: TLabel;
    scaleline: TLine;
    lbZoom: TLabel;
    cbLayers: TComboBox;
    laTop: TLayout;
    LocationSensor: TLocationSensor;
    btLocation: TCircle;
    laButtons: TLayout;
    btLayers: TCircle;
    ptLayers: FMX.Objects.TPath;
    ptLocation: FMX.Objects.TPath;
    btCompass: TCircle;
    ptCompass: FMX.Objects.TPath;
    RecTracking: TRectangle;
    Tracking: TLabel;
    recAddress: TRectangle;
    lbAddress: TListBox;
    edAddress: TEdit;
    tmAddress: TTimer;
    ptAddress: FMX.Objects.TPath;
    ptCancel: FMX.Objects.TPath;
    btEdit: TCircle;
    ptEdit: FMX.Objects.TPath;
    laEdit: TLayout;
    btAddPoint: TCircle;
    ptAddPoint: FMX.Objects.TPath;
    btValidLine: TCircle;
    ptValidLine: FMX.Objects.TPath;
    btCancelPoint: TCircle;
    ptCancelPoint: FMX.Objects.TPath;
    cbGuidance: TComboBox;
    laTopLeft: TLayout;
    laParent: TLayout;
    ptDirect: FMX.Objects.TPath;
    ptFoot: FMX.Objects.TPath;
    ptBike: FMX.Objects.TPath;
    ptCar: FMX.Objects.TPath;
    laProprietes: TLayout;
    recPropriete: TRectangle;
    edDescription: TEdit;
    btValidProp: TCircle;
    ptValidProp: FMX.Objects.TPath;
    btCancelProp: TCircle;
    ptCancelProp: FMX.Objects.TPath;
    btDelete: TCircle;
    ptDelete: FMX.Objects.TPath;
    lbDistance: TLabel;
    btMappilary: TCircle;
    ptMappilary: FMX.Objects.TPath;
    aniMappilary: TAniIndicator;
    btPOI: TCircle;
    ptPOI: FMX.Objects.TPath;
    AniPOI: TAniIndicator;
    LaAmenity: TLayout;
    recAmenity: TRectangle;
    btParking: TCircle;
    ptParking: FMX.Objects.TPath;
    btHotel: TCircle;
    ptHotel: FMX.Objects.TPath;
    btRestaurant: TCircle;
    ptRestaurant: FMX.Objects.TPath;
    btCancelAmenity: TCircle;
    ptCancelamenity: FMX.Objects.TPath;
    btValidAmenity: TCircle;
    ptValidamenity: FMX.Objects.TPath;
    Label1: TLabel;
    ptCafe: FMX.Objects.TPath;
    ptBar: FMX.Objects.TPath;
    laZoom: TLayout;
    btZoomIn: TCircle;
    ptZoomIn: FMX.Objects.TPath;
    BtZoomOut: TCircle;
    ptZoomOut: FMX.Objects.TPath;
    tmZoom: TTimer;
    ptTarget: FMX.Objects.TPath;
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure mapChangeMapZoom(Sender: TObject);
    procedure cbLayersClick(Sender: TObject);
    procedure LocationSensorLocationChanged(Sender: TObject;
      const OldLocation, NewLocation: TLocationCoord2D);
    procedure mapChangeMapActive(Sender: TObject);
    procedure btLocationClick(Sender: TObject);
    procedure btLayersClick(Sender: TObject);
    procedure mapChangeMapBounds(Sender: TObject);
    procedure btCompassClick(Sender: TObject);
    procedure tmAddressTimer(Sender: TObject);
    procedure edAddressChangeTracking(Sender: TObject);
    procedure lbAddressItemClick(const Sender: TCustomListBox;
      const Item: TListBoxItem);
    procedure edAddressEnter(Sender: TObject);
    procedure edAddressExit(Sender: TObject);
    procedure edAddressKeyDown(Sender: TObject; var Key: Word;
      var KeyChar: Char; Shift: TShiftState);
    procedure mapMapClick(Sender: TObject; const Lat, Lng: Double);

    procedure btEditClick(Sender: TObject);
    procedure btAddPointClick(Sender: TObject);
    procedure btValidLineClick(Sender: TObject);
    procedure btCancelPointClick(Sender: TObject);
    procedure GuidanceSelection(Sender: TObject);
    procedure mapShapeClick(sender: TObject; const item: TECShape);
    procedure FormSaveState(Sender: TObject);
    procedure btValidPropClick(Sender: TObject);
    procedure btCancelPropClick(Sender: TObject);
    procedure btDeleteClick(Sender: TObject);
    procedure btMappilaryClick(Sender: TObject);
    procedure btPOIClick(Sender: TObject);
    procedure btParkingClick(Sender: TObject);
    procedure btCancelAmenityClick(Sender: TObject);
    procedure btValidAmenityClick(Sender: TObject);
    procedure btZoomInMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Single);
    procedure tmZoomTimer(Sender: TObject);
    procedure BtZoomOutMouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Single);
    procedure btZoomInMouseLeave(Sender: TObject);


  private
    { Déclarations privées }
    FECNativeScaleMap: TECNativeScaleMap;

    FDirectPath, FWorkLine: TECShapeLine;
    FEditStartLine: boolean;

    FEditLineLastPoint: TLatLng;

    FEditLineGroup, FPositionGroup: TECShapes;

    FGPSPosition, FPosition: TECShapeMarker;
    FAnimPos: TECShapePOI;

    FECMappilaryLayer : TECMapillaryLayer;


    BackgroundColor, TextColor, FDarkColor, FLightColor: TAlphaColor;

    IsMappilaryLayer : boolean;

    fTimeKeyPress: cardinal;

    procedure doNotifyScale(Sender: TObject);

    procedure GetArcGisPlacesTile(var TileFilename: string;
      const x, y, z: integer);

    procedure doClickGPSPosition(Sender: TObject; const Item: TECShape);
    procedure doMoveGPSPosition(Sender: TObject; const Item: TECShape;
      var cancel: boolean);

    procedure CancelTracking;

    procedure doShapeDrag(Sender: TObject; const Item: TECShape;
      var cancel: boolean);
    procedure doShapeDragEnd(Sender: TObject);

    procedure doDrawCross(Sender: TObject; const canvas: TECCanvas);

    procedure doOnChangeRoute(Sender: TECShapeLine; const params: string);
    procedure doOnErrorRoute(Sender: TObject;
      const dataroute: TECThreadDataRoute);

     procedure doBeforeDraw(const canvas: TECCanvas; var Rect: TRect;
      Item: TECShape);

    procedure doHideGPSPositionInfo(Sender: TECShape);

    procedure GotoAddress(const Index: integer);

    procedure doMappilaryClick(Layer: TECMapillaryLayer;
  Item: TECShape; MappilarySequence: TMapillarySequence; PhotoIndex: integer);

    procedure doClickAmenity(Sender: TECShape);
    procedure doSearchAmenity(sender : TObject);
    procedure doEndSearchAmenity(sender : TObject);

    procedure doLongPress(Sender: TObject);


    procedure setSystemTheme;

    procedure setEdition(const value: boolean);

    procedure EditProprietes(sender : TECShape);

    procedure setMarkersLabels(const G:TECShapes);

    procedure setStyleLine(const line: TECShapeLine; const guidance: string);

    procedure CancelAddressSearch;

    procedure CloseLayers;

    procedure doBeginRequest(sender: TObject);
    procedure doEndRequest(sender: TObject);

  public
    { Déclarations publiques }
  end;

var
  Form3: TForm3;

implementation

{$R *.fmx}

  // all Icon made from http://www.onlinewebfonts.com/icon
const
  CLICK_FOR_TRACKING = 'Click to start recording your positions';
  CLICK_FOR_SAVE_TRACKING = 'Click to save your track';

procedure Switch(bt:TCircle);
var c:TAlphaColor;
    pt:FMX.Objects.TPath;
begin

 if (TFMXObject(bt).ChildrenCount=0) then exit;

 pt := FMX.Objects.TPath(TFMXObject(bt).children[0]);
 // switch to 1 and 0
 bt.tag := 1 - bt.tag;

 // invert the colors
 c := bt.Fill.color;
      bt.Fill.color   := bt.Stroke.color;
      bt.Stroke.color := c;
      pt.Fill.color := c;
end;


procedure TForm3.FormCreate(Sender: TObject);
var i:integer;
    selector:string;
begin

{$IFDEF ANDROID}

  // android permissions management

  PermissionsService.RequestPermissions
    ([JStringToString(TJManifest_permission.JavaClass.ACCESS_FINE_LOCATION)],
    procedure(const APermissions: TArray<string>;
      const AGrantResults: TArray<TPermissionStatus>)
    begin
      if (Length(AGrantResults) = 1) and
        (AGrantResults[0] = TPermissionStatus.Granted) then
        { activate or deactivate the location sensor }
        LocationSensor.Active := True
      else
      begin
        ShowMessage('Location permission not granted');
      end;
    end);

  PermissionsService.RequestPermissions
    ([JStringToString(TJManifest_permission.JavaClass.READ_EXTERNAL_STORAGE),
    JStringToString(TJManifest_permission.JavaClass.WRITE_EXTERNAL_STORAGE)],
    procedure(const APermissions: TArray<string>;
      const AGrantResults: TArray<TPermissionStatus>)
    begin
      if (Length(AGrantResults) = 2) and
        (AGrantResults[0] = TPermissionStatus.Granted) and
        (AGrantResults[1] = TPermissionStatus.Granted) then
        map.LocalCache := TPath.Combine(TPath.GetSharedDocumentsPath, 'cartoTrack')
      else
      begin
        map.LocalCache := '';
      end;
    end);
{$ELSE}
  map.LocalCache := TPath.Combine(ExtractfilePath(ParamStr(0)), 'cartoTrack');
{$ENDIF}


  FECNativeScaleMap := TECNativeScaleMap.Create;
  FECNativeScaleMap.OnChange := doNotifyScale;

  FECNativeScaleMap.map := map;
  FECNativeScaleMap.Visible := false;

  cbLayers.ItemIndex := 2;

  map.OverSizeForRotation := True;

  laProprietes.Visible := false;
  laAmenity.Visible    := false;


  // the default group that contains the markers Position and GPSPosition is not saved
  map.Shapes.Serialize := false;

  // amenity search layer
  map.XapiLayer.Shapes.Serialize := false;
  // return a maximum of 100 items
  map.XapiLayer.MaxItem := 100;
  map.XapiLayer.Shapes.Markers.Labels.LabelType := ltHint;
  map.XapiLayer.Shapes.Markers.Labels.Visible := true;
  map.XapiLayer.Shapes.Markers.Labels.Rotation:= lsrHideRotation;
  map.XapiLayer.Shapes.Markers.Labels.Margin := 12;
  // draw circle in background
  map.XapiLayer.Shapes.Markers.OnBeforeDraw := doBeforeDraw;
  map.XapiLayer.OnClick       := doClickAmenity;

  // end of search
  map.XapiLayer.OnChange      := doEndSearchAmenity;
  // start of search
  map.XapiLayer.OnStartSearch := doSearchAmenity;




  // load the data into the map

   map.LoadFromFile( TPath.Combine(map.localcache,'map.txt') );

   // reconnect attributes that are not saveable
     case map.TileServer of

       tsIgn : begin
                if map.TileServerInfo.MapStyle = '' then
                  cbLayers.ItemIndex := 0
                else
                if  map.TileServerInfo.MapStyle = 'IMAGERY' then
                  cbLayers.ItemIndex := 1
                else
                  cbLayers.ItemIndex := 2;
       end;

    tsHotOsm : cbLayers.ItemIndex := 3;

    tsArcGisWorldImagery : cbLayers.ItemIndex := 4;

   end;

    // browse the list of all groups
    for i := 0 to map.Groups.Count-1 do
    // search for those with a "guidance" property
    if map.Groups[i]['guidance']<>'' then
    begin
      // show labels
      setMarkersLabels(map.Groups[i]);
      // draw a background for our marker
      map.Groups[i].markers.OnBeforeDraw := doBeforeDraw;
    end;


  lbZoom.Text := doubleToStrDigit(map.NumericalZoom,1);

  // add a marker in default group
  // to specify a group use : map.AddMarker(lat, lng, 'name') or map['name'].addMarker(lat,lng)

  FGPSPosition := map.AddMarker(map.latitude, map.longitude);
  FGPSPosition.color := claDodgerBlue;
  FGPSPosition.HoverColor := claDeepSkyBlue;
  FGPSPosition.BorderColor := claWhite;

  // ZIndex is used to indicate the display order of the elements
  // the highest ZIndex is displayed last and is therefore above the others
  // Groups also have a ZIndex,
  // so an element of the group with the highest ZIndex will be displayed above
  // an element of a Group with a lower ZIndex,
  // even if the ZIndex of this element is lower than the element of the other group
  FGPSPosition.ZIndex := 50;

  FGPSPosition.OnShapeClick := doClickGPSPosition;
  FGPSPosition.OnShapeMove := doMoveGPSPosition;

  FGPSPosition.Visible := false;


  // add a property to define a style that applies only to this marker
  FGPSPosition.PropertyValue['GPS'] := 'true';

  FPosition := map.AddMarker(map.latitude, map.longitude);
  FPosition.StyleIcon := siSVG;
  FPosition.filename  := SVG_PIN_HOLE;  // unit uecMapUtil

  // use XAnchor and YAnchor to shift your marker to adjust the exact location point
  // here we want it to be at the bottom of the pin.
  // default XAnchor & YAnchor are in the center of the shape
  FPosition.YAnchor  := 24;

  FPosition.color := claBrown;
  FPosition.HoverColor := GetHighlightColorBy(FPosition.color, 32);// unit uecMapUtil

  FPosition.Draggable := True;
  FPosition.OnShapeDrag := doShapeDrag;
  FPosition.OnShapeDragEnd := doShapeDragEnd;

  // display the labels for the group of this marker
  // same for FGPSPosition because it is in the same group
  FPosition.Group.Markers.Labels.Visible := True;

  FPosition.Group.Markers.Labels.ShowOnlyIf := lsoHover;

  FPosition.Group.Markers.Labels.FillOpacity := 80; // 0..100
  FPosition.Group.Markers.Labels.Rotation := lsrRotation;
  FPosition.Group.Markers.Labels.MinZoom := 1;

  // use the description property as label text
  FPosition.Group.Markers.Labels.LabelType := ltDescription;

  // for a better readability of the label we insert line breaks
  FPosition.Description := Remplace_Str(FPosition.Address, ',', #13#10);

  // use a round POI that we will animate to better visualize the GPS position
  FAnimPos := map.AddPOI(FGPSPosition.latitude, FGPSPosition.longitude);
  FAnimPos.Visible := false;

  // we assign a ZIndex < to that of FGPSPosition so that the POI is below
  FAnimPos.ZIndex := 0;

  FAnimPos.Width := 50;
  FAnimPos.height := 50;

  FAnimPos.color := claLightBlue;

  FAnimPos.BorderColor := claLightBlue;
  FAnimPos.BorderSize := 2;

  FAnimPos.POIShape := poiEllipse;

  FAnimPos.Clickable := false;

  FAnimPos.FillOpacity := 50;

  // map.shapes is the default group,
  FPositionGroup := map.Shapes;
  // the group data will not be saved when the map is saved
  FPositionGroup.Serialize := false;

  // Group containing lines in edit mode
  FEditLineGroup := map['_EditLine_'];
  // don't save
  FEditLineGroup.Serialize := false;

  map.TimeLongClick := 750;
  map.OnLongPress := doLongPress;


  // ------------------ styles -------------------------------------------------

  // default lines style

     // border thickness = 2 ; line thickness  = 6 ;  scale = 1
  map.Styles.addRule('.line {bsize:2;weigth:6;scale:1}');

  // default markers style

  map.Styles.addRule('.marker {width:24;height:24;scale:1}');

  // default markers style for Position group
  map.Styles.addRule('#.marker {scale:2}');
  // rule for gps marker
  map.Styles.addRule('#.marker.gps:true {scale:1}');

  // styling trackline
  map.Styles.addRule
    // border thickness = 2 ; border color  = white ;  opacity = 90% ; type of stroke = dash
    ('.line.dash:true {bsize:1;bcolor:white;opacity:90;penStyle:dash;}');

  // style for editing line
  map.Styles.addRule('#_EditLine_.line {color:dodgerBlue;bcolor:white}');

  // for GPS marker Styleicon depends on the zoom
    // flat for zoom 1 to 16; direction for zoom 17 to 21
  map.Styles.addRule('#.marker.GPS:true {styleicon:1-16=Flat,17-21=direction}');

  // style according to the mode of tracing
  // define colors variables
  map.Styles.addRule('@hand {Grey}');
  map.Styles.addRule('@foot {dodgerBlue}');
  map.Styles.addRule('@bike {forestGreen}');
  map.Styles.addRule('@car  {OrangeRed}');
  map.Styles.addRule('@gps  {blueviolet}');
  map.Styles.addRule('@food {gold}');
  map.Styles.addRule('@parking {royalblue}');
  map.Styles.addRule('@hotel {chocolate}');

  // if the property contains a value, any value except empty
  map.Styles.addRule('.guidance:*   {styleicon:svg;}');
  // depending on the content of the "guidance" property, we assign an icon, a main color and a border color
  map.Styles.addRule('.guidance:0 {graphic:' + ptDirect.Data.Data +
    ';color:@hand;bcolor:light(@hand);}');
  map.Styles.addRule('.guidance:1 {graphic:' + ptFoot.Data.Data +
    ';color:@foot;bcolor:light(@foot)');
  map.Styles.addRule('.guidance:2 {graphic:' + ptBike.Data.Data +
    ';color:@bike;bcolor:light(@bike)}');
  map.Styles.addRule('.guidance:3 {graphic:' + ptCar.Data.Data +
    ';color:@car;bcolor:light(@car)}');
  map.Styles.addRule('.guidance:4 {graphic:' + ptLocation.Data.Data +
    ';color:@gps;bcolor:light(@gps)}');

  // another way to select a rule based on the content of a property
  // these rules are only applied to selected or mouse-over elements
  map.Styles.addRule
    (':selected,:hover { if:guidance=0 ;scale:1.3;color:light(@hand);bcolor:light(@hand);hbcolor:light(@hand)}');
  map.Styles.addRule
    (':selected,:hover { if:guidance=1 ;scale:1.3;color:light(@foot);bcolor:light(@foot);hbcolor:light(@foot)}');
  map.Styles.addRule
    (':selected,:hover { if:guidance=2 ;scale:1.3;color:light(@bike);bcolor:light(@bike);hbcolor:light(@bike)}');
  map.Styles.addRule
    (':selected,:hover { if:guidance=3 ;scale:1.3;color:light(@car);bcolor:light(@car);hbcolor:light(@car)');
  map.Styles.addRule
    (':selected,:hover { if:guidance=4 ;scale:1.3;color:light(@gps);bcolor:light(@gps);hbcolor:light(@gps)');

 // amenity

 Selector := '#' + map.XapiLayer.Shapes.Name ;  // group
 map.Styles.addRule(Selector+'.marker {styleicon:svg;}'); // markers use svg image

 // graphic for propriety tourims = hotel
 map.styles.addRule(Selector + '.marker.tourism:hotel {graphic:'+ptHotel.Data.data+';color:@hotel;hbcolor:light(@hotel)}');

 Selector := Selector + '.marker.amenity';
 map.styles.addRule(Selector + ':restaurant {graphic:'+ptRestaurant.Data.data+';color:@food;hbcolor:light(@food)}');
 map.styles.addRule(Selector + ':cafe {graphic:'+ptcafe.Data.data+';color:@food;hbcolor:light(@food)}');
 map.styles.addRule(Selector + ':bar {graphic:'+ptbar.Data.data+';color:@food;hbcolor:light(@food)}');

 map.styles.addRule(Selector + ':parking {graphic:'+ptparking.Data.data+';color:@parking;hbcolor:light(@parking)}');


 // ----------------------------------------------------------------------------

  FDarkColor := claBlack;
  FLightColor := claWhite;

  // btCompass.Visible := map.RotationAngle <> 0;

  map.Routing.Engine(reOpenStreetMap);

  // OnChangeRoute is triggered and not OnAddRoute
  // because we will provide a line during the request,
  // so it will not be created but modified
  map.Routing.OnChangeRoute := doOnChangeRoute;

  map.Routing.OnErrorRoute := doOnErrorRoute;

  // hack  to bypass the bug that prevents the OnKeyDown event for TEdit on android
  edAddress.ReturnKeyType := TReturnKeyType.Go;
{$IFNDEF MSWINDOWS}
  edAddress.ControlType := FMX.Controls.Presentation.TPresentedControl.
    TControlType.Platform;
  edDescription.ControlType := FMX.Controls.Presentation.TPresentedControl.
    TControlType.Platform;
{$ELSE}
  edAddress.ControlType := FMX.Controls.Presentation.TPresentedControl.
    TControlType.styled;
  edDescription.ControlType := FMX.Controls.Presentation.TPresentedControl.
    TControlType.styled;
{$ENDIF}
  // end of hack

  setEdition(false);


  // -------------  mappilary layer --------------------------------------------
  FECMappilaryLayer := TECMapillaryLayer.Create(map, 'Mapillary');

  FECMappilaryLayer.LocalCache     := map.LocalCache;
  FECMappilaryLayer.OnClick        := doMappilaryClick;
  FECMappilaryLayer.OnBeginRequest := doBeginRequest;
  FECMappilaryLayer.OnEndRequest   := doEndRequest;
  //----------------------------------------------------------------------------


  // use the dark or light theme
  setSystemTheme;




end;

procedure TForm3.FormDestroy(Sender: TObject);
begin
  FECNativeScaleMap.Free;
  FECMappilaryLayer.Free;
end;

procedure TForm3.FormSaveState(Sender: TObject);
begin
 // save data in file

 (*
    by default all groups are saved,
    if you don't want some of them to be saved,
    you have to assign false to their Serialize property

     map['dont_save_this_group'].Serialize := false;

 *)

  map.SaveToFile( TPath.Combine(map.localcache,'map.txt') );
 end;






// ======  Adjust the colors according to the light or dark themes ============
procedure TForm3.setSystemTheme;
// browse the list of elements and assign the theme colors
procedure set_colors(aFmxObj: TFmxObject);
begin
  afmxObj.EnumObjects(
    function(FmxObject: TFmxObject): TEnumControlsResult
    begin
      if TControl(FmxObject).InheritsFrom(FMX.Objects.TCircle) then
      begin
        FMX.Objects.TCircle(FmxObject).Fill.color   := BackgroundColor;
        FMX.Objects.TCircle(FmxObject).Stroke.color := TextColor;
      end
      else
      if TControl(FmxObject).InheritsFrom(FMX.Objects.TRectangle) then
      begin
        FMX.Objects.TRectangle(FmxObject).Fill.color   := BackgroundColor;
        FMX.Objects.TRectangle(FmxObject).Stroke.color := TextColor;
      end
      else
      if TControl(FmxObject).InheritsFrom(FMX.Objects.TPath) then
       FMX.Objects.TPath(FmxObject).Fill.color := TextColor
      else
      if TControl(FmxObject).InheritsFrom(FMX.Edit.TEdit) then
       FMX.Edit.TEdit(FmxObject).TextSettings.FontColor := TextColor
      else
      if TControl(FmxObject).InheritsFrom(FMX.StdCtrls.TLabel) then
       FMX.StdCtrls.TLabel(FmxObject).TextSettings.FontColor := TextColor;

      Result := TEnumControlsResult.Continue;
    end);
end;
var
  LService: IFMXSystemAppearanceService;
begin

  // default light
  BackgroundColor := FLightColor;
  TextColor := FDarkColor;

  // retrieve the active theme from the system, if there is none we will use the light one
  if TPlatformServices.Current.SupportsPlatformService
    (IFMXSystemAppearanceService, LService) then
  begin

    if LService.GetSystemThemeKind = TSystemThemeKind.Dark then
    begin

      TextColor := FLightColor;
      BackgroundColor := FDarkColor;

    end;

  end;


  set_colors(self);


end;
// -----------------------------------------------------------------------------




// ============ Tracking =======================================================

// center the map on the GPS position
procedure TForm3.btLocationClick(Sender: TObject);
begin
  map.setCenter(FGPSPosition.latitude, FGPSPosition.longitude);

  // Description will be displayed because FGPSPosition.Group.Markers.Labels.visible = true
  FGPSPosition.Description := CLICK_FOR_TRACKING;

  FGPSPosition.Animation := TECAnimationCustom.Create;
  // Automatically destroyed in doHideGPSPositionInfo by assigning another animation
  FGPSPosition.Animation.Timing := 3000;
  // OnExecute is triggered after Timing milliseconds, here 3 secondes
  TECAnimationCustom(FGPSPosition.Animation).OnExecute := doHideGPSPositionInfo;

  CancelAddressSearch;
end;



// event fired by FGPSPosition.TECAnimationCustom after 3s
procedure TForm3.doHideGPSPositionInfo(Sender: TECShape);
begin
  FGPSPosition.Description := '';

  // pause the animation
  // to restart it you should use FGPSPosition.TECAnimationCustom.Reset

  // here it's useless because the animation is freed
  // by the assignment of another animation, it's just for information
  FGPSPosition.Animation.Stop := True;

  FGPSPosition.Animation := TECAnimationShapeColor.Create;
end;

// event triggered when a new position is detected by the GPS
procedure TForm3.LocationSensorLocationChanged(Sender: TObject;
const OldLocation, NewLocation: TLocationCoord2D);
var
  anim: TECAnimationFadePoi;
begin

  FGPSPosition.SetDirection(NewLocation.latitude, NewLocation.longitude);
  FAnimPos.SetPosition(NewLocation.latitude, NewLocation.longitude);

  // Creation of an animation for the POI
  // Size and opacity will vary
  if FAnimPos.Animation = nil then
  begin
    anim := TECAnimationFadePoi.Create;

    anim.Timing := 50;

    anim.MaxSize := 50;
    anim.StartSize := 32;

    anim.StartOpacity := 50;

    // The animations are automatically destroyed when the element is destroyed
    // or when you assign nil or another animation
    FAnimPos.Animation := anim;
  end;

  if FGPSPosition.Visible then
    exit;

  FGPSPosition.Visible := True;
  FAnimPos.Visible := True;

end;

// event triggered by clicking on the GPS marker
procedure TForm3.doClickGPSPosition(Sender: TObject; const Item: TECShape);
var
  g: TECShapes;
  line: TECShapeLine;
begin

  CancelAddressSearch;

  if FGPSPosition.isTrackLineActive then
  begin
    g := map[inttostr(gettickcount)];

    g.markers.OnBeforeDraw := doBeforeDraw ;

    line := g.AddLine;
    line.Add(FGPSPosition.TrackLine);

    setStyleLine(line, '4');

    CancelTracking;
  end
  else
  begin

{$IFDEF ANDROID}

    // this permission does not seem to be handled by Delphi
    // AndroidManifest.template.xml has been modified to add it

    // but this is not enough to get the position in the background,
    // you have to use a service

    // see https://delphiworlds.com/2020/01/cross-platform-location-monitoring/


    (*
    if LocationSensor.Active then
      PermissionsService.RequestPermissions
        (['android.permission.ACCESS_BACKGROUND_LOCATION'],
        procedure(const APermissions: TArray<string>;
          const AGrantResults: TArray<TPermissionStatus>)
        begin
          if (Length(AGrantResults) = 1) and
            (AGrantResults[0] = TPermissionStatus.Granted) then
            { activate the location sensor in background }
            LocationSensor.UsageAuthorization :=
              TLocationUsageAuthorization.always
          else
          begin
            LocationSensor.UsageAuthorization :=
              TLocationUsageAuthorization.WhenInUse;
            ShowMessage('access location in the background not granted !');
          end;
        end);
      *)
{$ENDIF}
    // Description will be displayed because FGPSPosition.Group.Markers.Labels.visible = true
    FGPSPosition.Description := CLICK_FOR_SAVE_TRACKING;

    FGPSPosition.Animation := TECAnimationCustom.Create;
    // Automatically destroyed in doHideGPSPositionInfo by assigning another animation
    FGPSPosition.Animation.Timing := 3000;
    // OnExecute is triggered after Timing milliseconds, here 3 secondes
    TECAnimationCustom(FGPSPosition.Animation).OnExecute :=
      doHideGPSPositionInfo;

    ptCancel.Visible := True;
    ptEdit.Visible := false;

    Tracking.Text := 'Tracking on';
    RecTracking.Visible := True;
    FGPSPosition.TrackLine.Visible := True;
    // set the Dash property to true to use the dash style defined above
    FGPSPosition.TrackLine.PropertyValue['dash'] := 'true';
  end;

end;

procedure TForm3.CancelTracking;
begin
  FGPSPosition.TrackLine := nil;
  RecTracking.Visible := false;
  Tracking.Text := '';
  ptCancel.Visible := false;
  ptEdit.Visible := True;
end;

// event triggered when the GPS marker is moved
procedure TForm3.doMoveGPSPosition(Sender: TObject; const Item: TECShape;
var cancel: boolean);
begin

  if FGPSPosition.isTrackLineActive then
    Tracking.Text := DoubleToStrDigit(TECShapeMarker(Item).TrackLine.Distance,
      2) + ' Km';
end;

// -----------------------------------------------------------------------------

// event activated when the map moves to the background or foreground
procedure TForm3.mapChangeMapActive(Sender: TObject);
begin
  if map.Active then
    map.setCenter(FGPSPosition.latitude, FGPSPosition.longitude);
end;

// event triggered when the map displays a new position
procedure TForm3.mapChangeMapBounds(Sender: TObject);
begin

  CancelAddressSearch;

  // add 180° because the svg has the head down
  ptCompass.RotationAngle := map.RotationAngle + 180;

  // btCompass.Visible := map.RotationAngle <> 0;

  // draw line if Edit mode
  if (laEdit.Visible) and assigned(FWorkLine) and (not FEditStartLine) then
  begin

    FWorkLine.SetPath([FEditLineLastPoint.Lat, FEditLineLastPoint.Lng,
      map.latitude, map.longitude])

  end;

end;

// event triggered when the zoom changes
procedure TForm3.mapChangeMapZoom(Sender: TObject);
begin
  lbZoom.Text := doubleToStrDigit(map.NumericalZoom,1);
end;

// event triggered by a click on the map
procedure TForm3.mapMapClick(Sender: TObject; const Lat, Lng: Double);
begin
  CancelAddressSearch;
end;




// event triggered by a long press on the map
// sender is either the map or a TECShape element
procedure TForm3.doLongPress(Sender: TObject);
begin

 // ignore long press on a shape
 if sender<>map then
   exit;

 FPosition.setPosition(map.MouseLatLng.lat,map.MouseLatLng.lng);
 // update description with new address
 // for a better readability of the label we insert line breaks
 FPosition.Description := Remplace_Str(FPosition.Address, ',', #13#10);
end;

// event triggered by a click on an shape
procedure TForm3.mapShapeClick(sender: TObject; const item: TECShape);
begin

 if (laEdit.Visible) then
    exit;


 if laAmenity.Visible then
  btCancelAmenityClick(nil);

 // Control that the element has a guidance property
 if item.PropertyValue['guidance']<>'' then
   EditProprietes(item);

end;

// event OnshapeDrag triggered during the entire move
procedure TForm3.doShapeDrag(Sender: TObject; const Item: TECShape;
var cancel: boolean);
begin
  // at the start of the move the description is deleted
  if Item.DragStart then
    Item.Description := '';
end;

// at the end of the move OnDragEnd is called
// update the description with the new address
procedure TForm3.doShapeDragEnd(Sender: TObject);
begin
  if Sender is TECShapeMarker then
    // for a better readability of the label we insert line breaks
    TECShapeMarker(Sender).Description :=
      Remplace_Str(TECShapeMarker(Sender).Address, ',', #13#10)
end;

// cancel the rotation of the map
procedure TForm3.btCompassClick(Sender: TObject);
begin
  map.AnimRotationAngleTo(0);

  CancelAddressSearch;
end;

procedure TForm3.CloseLayers;
begin
   if FECMappilaryLayer.Visible then
    btMappilaryClick(nil);

 map.XapiLayer.Visible := false;
 aniPOI.Visible := false;
 aniPOI.Enabled := false;

end;



// =================== Edition Mode ============================================

procedure TForm3.setEdition(const value: boolean);
begin
  if value then
  begin

    FPositionGroup.Visible := false;

    FWorkLine := FEditLineGroup.AddLine;

    // set the Dash property to true to use the dash style defined above
    FWorkLine.PropertyValue['dash'] := 'true';

    FEditStartLine := True;
    CancelTracking;
    ptCancel.Visible := True;
    ptEdit.Visible := false;
    btValidLine.Enabled := false;
    laEdit.Visible := True;
    map.OnShapesPaint := doDrawCross;
  end
  else
  begin
    FPositionGroup.Visible := True;
    laEdit.Visible := false;
    ptCancel.Visible := false;
    ptEdit.Visible := True;
    // recAddress.Visible     := true;
    FWorkLine := nil;
    FDirectPath := nil;
    map.OnShapesPaint := nil;
    FEditLineGroup.Clear;
  end;
end;

// activate route editing
procedure TForm3.btEditClick(Sender: TObject);
begin


  CloseLayers;



  if FGPSPosition.isTrackLineActive then
    CancelTracking
  else
  // edit path
  begin
    // select the type of plot assistance
    if ptEdit.Visible then
      cbGuidance.dropDown
    else
      setEdition(false);
  end;
end;

procedure TForm3.GuidanceSelection(Sender: TObject);
begin

  case cbGuidance.ItemIndex of
    0:
      FDirectPath := FEditLineGroup.AddLine;
    1:
      map.Routing.RouteType := rtPedestrian;
    2:
      map.Routing.RouteType := rtBicycle;
  else
    map.Routing.RouteType := rtCar;

  end;

  setEdition(ptEdit.Visible = True);
end;

procedure TForm3.btAddPointClick(Sender: TObject);
var
  Lat, Lng: Double;
  FuturLine: TECShapeLine;
begin

  if FEditStartLine then
  begin
    FEditLineLastPoint.Lat := map.latitude;
    FEditLineLastPoint.Lng := map.longitude;

    if assigned(FDirectPath) then
      FDirectPath.Add(FEditLineLastPoint.Lat, FEditLineLastPoint.Lng);


    FEditStartLine := false;
  end
  else
  begin

    Lat := FEditLineLastPoint.Lat;
    Lng := FEditLineLastPoint.Lng;
    FEditLineLastPoint.Lat := map.latitude;
    FEditLineLastPoint.Lng := map.longitude;

    if assigned(FDirectPath) then
    begin
      FDirectPath.Add(map.latitude, map.longitude);
      btValidLine.Enabled := true;
    end
    else
    begin
      // while waiting for the calculation of the route, we draw a direct line
      FuturLine := FEditLineGroup.AddLine([Lat, Lng, map.latitude,
        map.longitude]);
      // we mark the line to avoid its destruction while a thread computes the path
      FuturLine.PropertyValue['waiting'] := 'true';
      // idem for validation and cancellation
      btValidLine.Enabled := false;
      btEdit.Enabled := false;
      // the calculation is done in a thread, FuturLine will be updated to contain the route
      map.Routing.Request([Lat, Lng, map.latitude, map.longitude], '',
        FuturLine);
    end;


  end;

end;

// event triggered if the route calculation is validated
procedure TForm3.doOnChangeRoute(Sender: TECShapeLine; const params: string);
begin
  FWorkLine.Clear;
  // now we can destroy this line, we cancel the mark
  Sender.PropertyValue['waiting'] := '';
  // now we can validate or cancel this line;
  btValidLine.Enabled := True;
  btEdit.Enabled := True;

end;

// event triggered if the route calculation is not validated
procedure TForm3.doOnErrorRoute(Sender: TObject;
const dataroute: TECThreadDataRoute);
begin
  FWorkLine.Clear;
  btValidLine.Enabled := True;
  btEdit.Enabled := True;
  btCancelPointClick(nil);
  ShowMessage('Routing Error !');
end;

// Validation of the route, it is definitively registered


procedure TForm3.btValidLineClick(Sender: TObject);
var
  g: TECShapes;
  line: TECShapeLine;
  i: integer;
begin
  // create un group with unique name
  g := map[Crc32Str(DateTimeToStr(now))];

  // draw a background for our marker
  g.markers.OnBeforeDraw := doBeforeDraw;
  // display the labels of the markers in this group
  setMarkersLabels(g);

  if assigned(FDirectPath) then
  begin
    line := g.AddLine;
    line.Add(FDirectPath);
  end

  else
  begin
    // Merge all segments into one line
    line := g.AddLine;

    for i := 1 to FEditLineGroup.Lines.count - 1 do
      line.Add(FEditLineGroup.Lines[i]);

  end;

  setStyleLine(line, inttostr(cbGuidance.ItemIndex));



  setEdition(false);

end;



// display the labels of the markers in this group
procedure TForm3.setMarkersLabels(const G:TECShapes);
begin
  // the Description property of the marker is used as label text
  G.Markers.Labels.LabelType := ltDescription;
  G.Markers.Labels.Align := TLabelShapeAlign.LaBottom;
  G.Markers.Labels.Margin := 12;
  G.Markers.Labels.MaxWidth := 150;
  G.Markers.Labels.Visible := True;
end;


// delete last segment


procedure TForm3.btCancelPointClick(Sender: TObject);
var
  line: TECShapeLine;
  pt: TECPointLine;
begin

  if FEditLineGroup.Lines.count = 1 then
  begin
    FEditStartLine := True;
    btValidLine.Enabled   := false;
    FWorkLine.Clear;
  end
  else
  begin

    if assigned(FDirectPath) then
    begin
      if FDirectPath.count > 0 then
      begin
        FDirectPath.Delete(FDirectPath.count - 1);

        if FDirectPath.count > 0 then
        begin
          pt := FDirectPath.Path[FDirectPath.count - 1];

          FEditLineLastPoint.Lat := pt.latitude;
          FEditLineLastPoint.Lng := pt.longitude;

          FWorkLine.SetPath([FEditLineLastPoint.Lat, FEditLineLastPoint.Lng,
            map.latitude, map.longitude]);
        end
        else
        begin
          FEditStartLine := True;
          FWorkLine.Clear;
        end;

        btValidLine.Enabled := FDirectPath.count > 1;

      end;
    end

    else
    begin

      line := FEditLineGroup.Lines[FEditLineGroup.Lines.count - 1];

      // do not destroy a line that is being calculated!
      if line.PropertyValue['waiting'] <> '' then
        exit;

      pt := line.Path[0];

      FEditLineLastPoint.Lat := pt.latitude;
      FEditLineLastPoint.Lng := pt.longitude;

      line.Remove;

      btValidLine.Enabled   := FEditLineGroup.Lines.count>1;

      if FEditLineGroup.Lines.count > 0 then
        FWorkLine.SetPath([FEditLineLastPoint.Lat, FEditLineLastPoint.Lng,
          map.latitude, map.longitude]);

    end;

  end;

end;




// Stylize the elements (line & marker ) according to the type of track
procedure TForm3.setStyleLine(const line: TECShapeLine; const guidance: string);
var
  mrk: TECShapeMarker;
begin

  // the style will be determined according to this group property
   line.group['guidance'] := guidance;
  // by adding this property at the group level all elements inherit it
  // it is the equivalent of

  //   line['guidance'] := guidance;
  //    mrk['guidance'] := guidance;


  line.focusable := false;

  // add a marker to indicate the beginning of the route.
  // it is added in the same group as the line
  mrk := line.Group.AddMarker(line.Path[0].latitude, line.Path[0].longitude);

  mrk.focusable := false;

  // for the marker to be displayed over the line, it must be assigned a higher ZIndex
  mrk.ZIndex := line.ZIndex + 1;

  // adjust the orientation of the marker icon according to the rotation of the map
  // so that it always stays in the same direction
  mrk.Rotation := True;

  // use the description property as label text
  mrk.Description := DateTimeToStr(now);

  EditProprietes(mrk);


end;



procedure TForm3.EditProprietes(sender : TECShape);
begin
  if (sender.Group.Markers.Count>0) and (sender.Group.Lines[0].count>0) then
  begin
   btEdit.Enabled          := false;
   sender.Group.Selected   := true;
   edDescription.Text      := sender.Group.Markers[0].Description;
   edDescription.SetFocus;
   edDescription.TagObject := sender.Group.Markers[0];
   lbDistance.Text         := DoubleToStrDigit(sender.Group.Lines[0].Distance, 2) + ' Km';
   laProprietes.Visible    := true;
  end;
end;

procedure TForm3.btValidPropClick(Sender: TObject);
begin
 TECshapeMarker(edDescription.TagObject).Description    := edDescription.Text;
 TECshapeMarker(edDescription.TagObject).Group.Selected := false;
 laProprietes.Visible := false;
 btEdit.Enabled       := true;
end;



procedure TForm3.btCancelPropClick(Sender: TObject);
begin
 TECshapeMarker(edDescription.TagObject).Group.Selected := false;
 laProprietes.Visible := false;
 btEdit.Enabled       := true;
end;


procedure TForm3.btDeleteClick(Sender: TObject);
begin

 TDialogService.MessageDialog(('Are you sure you want to delete this route'),
      system.UITypes.TMsgDlgType.mtConfirmation,
      [system.UITypes.TMsgDlgBtn.mbYes, system.UITypes.TMsgDlgBtn.mbNo], system.UITypes.TMsgDlgBtn.mbYes,0,
procedure (const AResult: System.UITypes.TModalResult)
  begin
          case AResult of
            mrYES: TECshapeMarker(edDescription.TagObject).Group.Remove;
          end;
  end);

 laProprietes.Visible := false;
 btEdit.Enabled       := true;
end;


// draw a circle in the background for markers that indicate the start of a route
procedure TForm3.doBeforeDraw(const canvas: TECCanvas; var Rect: TRect;
Item: TECShape);
begin
  canvas.FillOpacity := 90;
  canvas.brush.color := BackgroundColor;


  // border size
  canvas.PenSize := 2;

  // border color
  if Item.Selected then
    canvas.Pen.color := TECShapeMarker(Item).HoverBorderColor
  else
    canvas.Pen.color := Item.color;

  // Rect indicates the rectangle enclosing the element
  // enlarge it by 7px
  InflateRect(Rect,7,7);

  canvas.fillCircle(Rect);

end;

// draw a svg target in the center of the map
// OnShapesPaint is fired after shapes are drawn
// use OnMapPaint to draw under the elements
procedure TForm3.doDrawCross(Sender: TObject; const canvas: TECCanvas);
var
  x, y, angle: integer;
begin

  // convert center position to local X,Y
  map.FromLatLngToXY(map.Center, x, y);

  angle := canvas.angle;

  // compensate for the rotation of the map.
  canvas.angle := round(360 - map.RotationAngle);

  canvas.PenWidth(1);

  canvas.Pen.color := TextColor;
  canvas.brush.color := BackgroundColor;

  // center svg on x,y
  canvas.Left := x - 24;
  canvas.Right := x + 24;
  canvas.Top := y - 24;
  canvas.Bottom := y + 24;

  canvas.CenterRotation := Point(x, y);

  canvas.DrawData(ptTarget.data);

  canvas.angle := angle;

end;

// ------------------------------------------------------------------------------



// ============= select tiles server ===========================================

procedure TForm3.btLayersClick(Sender: TObject);
begin
  cbLayers.dropDown;
  CancelAddressSearch;
end;

procedure TForm3.cbLayersClick(Sender: TObject);
begin


  map.RemoveAllOverlayTiles;

  case cbLayers.ItemIndex of
    0:
      begin
        map.TileServer := tsIgn;
        map.TileServerInfo.MapStyle := '';
        map.MaxZoom := map.TileServerInfo.MaxZoom;
      end;
    1:
      begin
        map.TileServer := tsIgn;
        map.TileServerInfo.MapStyle := 'IMAGERY';
        map.MaxZoom := map.TileServerInfo.MaxZoom;
      end;
    2:
      begin
        map.TileServer := tsIgn;
        map.TileServerInfo.MapStyle := 'SCAN';
        map.MaxZoom := map.TileServerInfo.MaxZoom;
        map.IgnKey := 'ob7nq7gdfz74qiy9x8rg4iyi';
      end;
    3:
      begin
        map.TileServer := tsHotOsm;
      end;
    4:
      begin
        map.TileServer := tsArcGisWorldImagery;
        // add overlay tiles for places
        map.AddOverlayTiles(GetArcGisPlacesTile, 'World_Places_Tile');
      end;
  end;

end;

procedure TForm3.GetArcGisPlacesTile(var TileFilename: string;
const x, y, z: integer);
begin
  TileFilename :=
    format('https://services.arcgisonline.com/ArcGIS/rest/services/Reference/World_Boundaries_and_Places/MapServer/tile/%d/%d/%d.png',
    [z, y, x]);
end;

// ------------------------------------------------------------------------------

procedure TForm3.doNotifyScale(Sender: TObject);
begin

  if assigned(Sender) and (Sender is TECNativeScaleMap) then
  begin
    scaleline.Size.Width := TECNativeScaleMap(Sender).ScaleWidth;
    ScaleLegend.Text := TECNativeScaleMap(Sender).ScaleLegend;
  end;

end;


// ============= search for the geographical position of an address ============

procedure TForm3.edAddressChangeTracking(Sender: TObject);
begin

  if (gettickcount - fTimeKeyPress > tmAddress.interval) then
    tmAddressTimer(nil)
  else
    tmAddress.Enabled := True;

  fTimeKeyPress := gettickcount;

end;

procedure TForm3.edAddressEnter(Sender: TObject);
begin
  laTop.height := 300;
  lbAddress.Visible := True;
end;

procedure TForm3.edAddressExit(Sender: TObject);
begin
  lbAddress.Visible := false;
  lbAddress.Items.Text := '';
  edAddress.Text := '';
  laTop.height := 60;
  map.GeoLocalise.SearchResults.Clear;
end;

procedure TForm3.edAddressKeyDown(Sender: TObject; var Key: Word;
var KeyChar: Char; Shift: TShiftState);
begin

  // if validate then select the first address
  if Key = 13 then
    GotoAddress(0);

end;

procedure TForm3.tmAddressTimer(Sender: TObject);
var
  i: integer;
begin
  tmAddress.Enabled := false;

  if Length(edAddress.Text) < 3 then
    exit;

  if map.GeoLocalise.OpenStreetMapSearch(edAddress.Text) > 0 then
  begin

    lbAddress.Items.BeginUpdate;
    lbAddress.Items.Text := map.GeoLocalise.SearchResults.Text;

    for i := 0 to lbAddress.Items.count - 1 do
    begin
      lbAddress.ListItems[i].TextSettings.FontColor := TextColor;
      lbAddress.ListItems[i].StyledSettings := lbAddress.ListItems[i]
        .StyledSettings - [TStyledSetting.FontColor];
    end;

    lbAddress.Items.EndUpdate;

  end;

end;




procedure TForm3.lbAddressItemClick(const Sender: TCustomListBox;
const Item: TListBoxItem);
begin
  GotoAddress(Item.Index);
end;

procedure TForm3.GotoAddress(const Index: integer);
var
  geoResult: TECGeoResult;
begin

  if (index > -1) and (index < map.GeoLocalise.SearchResults.count) then
  begin

    geoResult := map.GeoLocalise.SearchResult[Index];

    map.setCenter(geoResult.latitude, geoResult.longitude);

    FPosition.SetPosition(geoResult.latitude, geoResult.longitude);
    // for a better readability of the label we insert line breaks
    FPosition.Description := Remplace_Str(geoResult.Display_name, ',', #13#10);

  end;

  CancelAddressSearch;
end;

procedure TForm3.CancelAddressSearch;
begin

  if not lbAddress.Visible then
    exit;

  // hack for disable focus
  edAddress.Visible := false;
  edAddress.Visible := True;
end;

// -----------------------------------------------------------------------------





// ==================== Mappilary ==============================================

procedure TForm3.btMappilaryClick(Sender: TObject);
begin

 switch(btMappilary);

 if (btMappilary.tag = 1) and (map.Zoom<FECMappilaryLayer.MinZoom) then
  map.Zoom := FECMappilaryLayer.MinZoom;

 FECMappilaryLayer.Visible := (btMappilary.tag = 1);
 FECMappilaryLayer.TrafficSignVisible := false;

end;



// display the photograph of the place in an infowindow
procedure TForm3.doMappilaryClick(Layer: TECMapillaryLayer;
  Item: TECShape; MappilarySequence: TMapillarySequence; PhotoIndex: integer);
begin


  FECMappilaryLayer.OpenWindow(MappilarySequence.images[PhotoIndex].Lat,
                               MappilarySequence.images[PhotoIndex].Lng,
                               '<img width="256" height="256" src="' + MappilarySequence.images[photoindex].Url256 + '">'
                               ,256);

end;

// start mappilary request
procedure TForm3.doBeginRequest(sender: TObject);
begin
  aniMappilary.Visible := true;
  aniMappilary.Enabled := true;
end;

// end mappilary request
procedure TForm3.doEndRequest(sender: TObject);
begin
  aniMappilary.Visible := false;
  aniMappilary.Enabled := false;
end;


//------------------------------------------------------------------------------


// ====================== POI restaurant - parking - hotel =====================

procedure TForm3.btParkingClick(Sender: TObject);
var bt:TCircle;
begin
 bt := TCircle(sender);

 if bthotel.Tag=1 then
 switch(btHotel);

 if btParking.Tag=1 then
 switch(btParking);

 if btRestaurant.Tag=1 then
 switch(btRestaurant);


 switch(bt);

end;

procedure TForm3.btPOIClick(Sender: TObject);
begin
 if not map.XapiLayer.Visible then
  switch(btPOI);

 laAmenity.Visible := not laAmenity.Visible;
 btEdit.Enabled    := not laAmenity.Visible;
end;

procedure TForm3.btCancelAmenityClick(Sender: TObject);
begin
 switch(btPOI);
 laAmenity.Visible := false;
 btEdit.Enabled    := not laAmenity.Visible;
 map.XapiLayer.Visible := false;
 aniPOI.Visible := false;
 aniPOI.Enabled := false;
end;



// launch a POI search using the XAPI layer
procedure TForm3.btValidAmenityClick(Sender: TObject);
var amenity:string;
begin

 laAmenity.Visible := false;
 btEdit.Enabled    := not laAmenity.Visible;

 amenity := '';

 if (bthotel.Tag=1) then
  amenity := 'tourism=hotel';

 if (btrestaurant.Tag=1) then
 begin
   amenity := amenity+'amenity=restaurant|cafe|bar';
 end;

 if (btparking.Tag=1) then
 begin
   amenity  := amenity+'amenity=parking';
 end;


 map.XapiLayer.Visible := amenity<>'';

 if map.XapiLayer.Visible then
 begin
  map.XapiLayer.Search := amenity;
 end


end;


// start xapi request
procedure TForm3.doSearchAmenity(sender : TObject);
begin
 aniPOI.Visible := true;
 aniPOI.Enabled := true;
end;

// end xapi request
procedure TForm3.doEndSearchAmenity(sender : TObject);
begin
 aniPOI.Visible := false;
 aniPOI.Enabled := false;
end;


// Display the properties of the clicked element
procedure TForm3.doClickAmenity(Sender: TECShape);
var s:string;
    Key, Value: string;
begin

  s := '';

  // Browse the property list
  if Sender.PropertiesFindFirst(Key, Value) then
  begin
    repeat

      // ignore this one
      if (Key = 'ecshape')or(Key = 'id') then
        continue;



      if length(Key) < 9 then
       // add a tab to start the values at 65px
        Key := Key + '<tab="65">';

      // put in bold the key and return to the line after each couple key/value
      s := s + '<b>' + Key + '</b>: ' + Value + '<br>';

    // continue as long as it has properties
    until Sender.PropertiesFindNext(Key, Value);
  end;

  if s='' then exit;

  // Display the list of properties in a 250px wide InfoWindow
  map.XapiLayer.OpenWindow(Sender.Latitude,Sender.Longitude,s,250);

end;


// -----------------------------------------------------------------------------




// ============= automatic Zoom ================================================

// activate the timer when the button is pressed
// a progressive zoom will then be automatically performed
procedure TForm3.btZoomInMouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Single);
begin
 // save the button pressed to react on it.
 tmZoom.TagObject := Sender;

 // don't display the layer mappilary during the progressive zoom because it is time consuming
 IsMappilaryLayer := FECMappilaryLayer.Visible;
 FECMappilaryLayer.Visible := false;

 tmZoom.Enabled   := true;
end;

// cancel progressive zoom
procedure TForm3.btZoomInMouseLeave(Sender: TObject);
begin
 tmZoom.Enabled   := false;
 // if necessary reactivate the layer mappilary
 FECMappilaryLayer.Visible := IsMappilaryLayer;
end;

// cancel progressive zoom
procedure TForm3.BtZoomOutMouseUp(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Single);
begin
 tmZoom.Enabled   := false;
 // if necessary reactivate the layer mappilary
 FECMappilaryLayer.Visible := IsMappilaryLayer;
end;



// Progressive zoom in or out
// Allows to go beyond the maximum zoom managed by the tile server
procedure TForm3.tmZoomTimer(Sender: TObject);
begin

  if (tmZoom.TagObject = btZoomIn) then
   // map.ZoomScaleFactorAround(map.center,map.ZoomScaleFactor + 10)
   map.ZoomScaleFactor := map.ZoomScaleFactor + 10
  else
   map.ZoomScaleFactor := map.ZoomScaleFactor - 10;
  // map.ZoomScaleFactorAround(map.center,map.ZoomScaleFactor - 10);


end;

//------------------------------------------------------------------------------

end.
