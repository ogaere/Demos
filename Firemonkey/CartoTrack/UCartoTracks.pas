unit UCartoTracks;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs, System.Sensors,
  System.Sensors.Components, FMX.StdCtrls, FMX.Edit, FMX.Layouts, FMX.ListBox,
  FMX.Objects, FMX.Controls.Presentation,System.IOUtils,
  System.UIConsts, System.Permissions,FMX.DialogService, FMX.Ani,FMX.Platform,

  // TECNativeMap units
  FMX.uecNativeMapControl,
  FMX.uecNativeShape,
  FMX.uecNativeScaleMap,
  FMX.uecMapUtil,
  FMX.uecgeoLocalise,
  FMX.uecGraphics,
  FMX.uecMapillary
  // -------------------

  ;

type
  TForm2 = class(TForm)
    laParent: TLayout;
    Panel1: TPanel;
    map: TECNativeMap;
    cbGuidance: TComboBox;
    LaBottom: TLayout;
    RecTracking: TRectangle;
    Tracking: TLabel;
    ScaleLegend: TLabel;
    lbZoom: TLabel;
    scaleline: TLine;
    laEdit: TLayout;
    btAddPoint: TCircle;
    ptAddPoint: FMX.Objects.TPath;
    btValidLine: TCircle;
    ptValidLine: FMX.Objects.TPath;
    btCancelPoint: TCircle;
    ptCancelPoint: FMX.Objects.TPath;
    laTop: TLayout;
    cbLayers: TComboBox;
    recAddress: TRectangle;
    lbAddress: TListBox;
    edAddress: TEdit;
    tmAddress: TTimer;
    ptAddress: FMX.Objects.TPath;
    laTopLeft: TLayout;
    btCompass: TCircle;
    ptCompass: FMX.Objects.TPath;
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
    lbDistance: TLabel;
    btDelete: TCircle;
    ptDelete: FMX.Objects.TPath;
    LaAmenity: TLayout;
    recAmenity: TRectangle;
    btParking: TCircle;
    ptParking: FMX.Objects.TPath;
    btHotel: TCircle;
    ptHotel: FMX.Objects.TPath;
    btRestaurant: TCircle;
    ptRestaurant: FMX.Objects.TPath;
    Label1: TLabel;
    btCancelAmenity: TCircle;
    ptCancelamenity: FMX.Objects.TPath;
    btValidAmenity: TCircle;
    ptValidamenity: FMX.Objects.TPath;
    ptCafe: FMX.Objects.TPath;
    ptBar: FMX.Objects.TPath;
    ptTarget: FMX.Objects.TPath;
    laButtons: TLayout;
    btLocation: TCircle;
    ptLocation: FMX.Objects.TPath;
    btLayers: TCircle;
    ptLayers: FMX.Objects.TPath;
    btEdit: TCircle;
    ptEdit: FMX.Objects.TPath;
    ptCancel: FMX.Objects.TPath;
    btMappilary: TCircle;
    ptMappilary: FMX.Objects.TPath;
    aniMappilary: TAniIndicator;
    btPOI: TCircle;
    ptPOI: FMX.Objects.TPath;
    AniPOI: TAniIndicator;
    laZoom: TLayout;
    btZoomIn: TCircle;
    ptZoomIn: FMX.Objects.TPath;
    BtZoomOut: TCircle;
    ptZoomOut: FMX.Objects.TPath;
    tmZoom: TTimer;
    LocationSensor: TLocationSensor;
    ImageControl1: TImageControl;
    Rectangle1: TRectangle;
    laDEBUG: TLayout;
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
    procedure mapLongPress(Sender: TObject);
    procedure mapMapLongClick(sender: TObject; const Lat, Lng: Double);

  private
    { Déclarations privées }
   FECNativeScaleMap: TECNativeScaleMap;

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


     procedure doBeforeDraw(const canvas: TECCanvas; var Rect: TRect;
      Item: TECShape);

    procedure doHideGPSPositionInfo(Sender: TECShape);

    procedure GotoAddress(const Index: integer);

    procedure doMappilaryClick(Layer: TECMapillaryLayer;
  Item: TECShape; MappilarySequence: TMapillarySequence; PhotoIndex: integer);

    procedure doClickAmenity(Sender:TObject; const Item: TECShape);
    procedure doSearchAmenity(sender : TObject);
    procedure doEndSearchAmenity(sender : TObject);

    procedure doLongPress(Sender: TObject);


    procedure setSystemTheme;

    procedure EditProprietes(sender : TECShape);

    procedure setMarkersLabels(const G:TECShapes);

    procedure setStyleLine(const line: TECShapeLine; const guidance: string);

    procedure CancelAddressSearch;

    procedure CloseLayers;

    procedure doBeginRequest(sender: TObject);
    procedure doEndRequest(sender: TObject);

    procedure doOnLocationPermission(Sender: TObject; const APermissions: TClassicStringDynArray; const AGrantResults: TClassicPermissionStatusDynArray);
    procedure doOnStoragePermission(Sender: TObject; const APermissions: TClassicStringDynArray; const AGrantResults: TClassicPermissionStatusDynArray);

    procedure  doOnReady(const Ready:boolean);
    procedure  doOnActivate(const Activate:boolean);
    procedure  doOnError(Sender: TObject);

  public
    { Déclarations publiques }
  end;

var
  Form2: TForm2;

implementation

{$R *.fmx}

 // all Icon made from http://www.onlinewebfonts.com/icon
const
 {$IFDEF ANDROID}
  PermissionReadExternalStorage = 'android.permission.READ_EXTERNAL_STORAGE';
  PermissionWriteExternalStorage = 'android.permission.WRITE_EXTERNAL_STORAGE';
  PermissionAccessFineLocation = 'android.permission.ACCESS_FINE_LOCATION';
 {$ENDIF}

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


procedure TForm2.doOnLocationPermission(Sender: TObject; const APermissions: TClassicStringDynArray; const AGrantResults: TClassicPermissionStatusDynArray) ;
    begin
      if (Length(AGrantResults) = 1) and
        (AGrantResults[0] = TPermissionStatus.Granted) then
        { activate or deactivate the location sensor }
        LocationSensor.Active := True
      else
      begin
        TDialogService.ShowMessage('Location permission not granted');
      end;
    end;


procedure TForm2.doOnStoragePermission(Sender: TObject; const APermissions: TClassicStringDynArray; const AGrantResults: TClassicPermissionStatusDynArray);
begin
  if (Length(AGrantResults) = 2) and
        (AGrantResults[0] = TPermissionStatus.Granted) and
        (AGrantResults[1] = TPermissionStatus.Granted) then
        map.LocalCache := TPath.Combine(TPath.GetSharedDocumentsPath, 'cartoTrack')
      else
      begin
        TDialogService.ShowMessage('Storage permission not granted');
        map.LocalCache := '';
      end;

end;




procedure TForm2.FormCreate(Sender: TObject);
var i:integer;
    selector:string;
begin
{$IFDEF ANDROID}

  // android permissions management

  PermissionsService.RequestPermissions([PermissionAccessFineLocation],doOnLocationPermission);

  PermissionsService.RequestPermissions
    ([PermissionReadExternalStorage,
    PermissionWriteExternalStorage],
    doOnStoragePermission);

    //map.LocalCache := TPath.Combine(TPath.getpublicpath(*getlibrarypath(*GetSharedDocumentsPath*), 'cartoTrack');


{$ELSE}
  map.LocalCache := TPath.Combine(TPath.GetSharedDocumentsPath, 'ecnativemap-cache1');
{$ENDIF}


 map.BeginUpdate;


  FECNativeScaleMap := TECNativeScaleMap.Create;
  FECNativeScaleMap.OnChange := doNotifyScale;

  FECNativeScaleMap.map := map;
  FECNativeScaleMap.Visible := false;

  cbLayers.ItemIndex := 0;

  map.OverSizeForRotation := True;

  laProprietes.Visible := false;
  laAmenity.Visible    := false;

  FDarkColor  := GetHighlightColorBy(claBlack,64);
  FLightColor := GetShadowColorBy(claWhite,16);


  // the default group that contains the markers Position and GPSPosition is not saved
  map.Shapes.Serialize := false;

  // amenity search layer

  map.OverPassApi.Layer.Group.Markers.Labels.LabelType := ltHint;
  map.OverPassApi.Layer.Group.Markers.Labels.Visible := true;
  map.OverPassApi.Layer.Group.Markers.Labels.Rotation:= lsrHideRotation;
  map.OverPassApi.Layer.Group.Markers.Labels.Margin := 4;

  // start of search
  map.OverPassApi.Layer.OnBeginQuery := doSearchAmenity;
  // end of search
  map.OverPassApi.Layer.OnEndQuery   := doEndSearchAmenity;
  map.OverPassApi.Layer.OnClick      := doClickAmenity;

  // draw circle in background
  map.OverPassApi.Layer.Group.Markers.OnBeforeDraw := doBeforeDraw;

  // cluster
  map.OverPassApi.Layer.Group.Clusterable := true;
  // use by 'restaurant','cafe' and 'bar' using categorized clusters
  map.OverPassApi.Layer.Group.ClusterManager.AddCategorie('Restaurant',StrToColor('#e34a33'));
  map.OverPassApi.Layer.Group.ClusterManager.AddCategorie('Bar',StrToColor('#fc8d59'));
  map.OverPassApi.Layer.Group.ClusterManager.AddCategorie('Cafe',StrToColor('#fdcc8a'));
  map.OverPassApi.Layer.Group.ClusterManager.CategorieKey := 'amenity';

  map.OverPassApi.Layer.Group.ClusterManager.FontSize := 12;
  map.OverPassApi.Layer.Group.ClusterManager.Proportional := true;

  // the size of clusters will vary between MinWithHeight and WidthHeight,
  // and will be proportional to the number of elements they contain
  map.OverPassApi.Layer.Group.ClusterManager.WidthHeight := 64;
  map.OverPassApi.Layer.Group.ClusterManager.MinWidthHeight := 32;

  map.OverPassApi.Layer.Group.ClusterManager.Opacity := 80;
  map.OverPassApi.Layer.Group.HintColor := FLightColor;
  map.OverPassApi.Layer.Group.ClusterManager.Color := FLightColor;
  map.OverPassApi.Layer.Group.ClusterManager.TextColor := FDarkColor;
  map.OverPassApi.Layer.Group.HintCenter:= false;



  // load the data into the map

  // map.LoadFromFile( TPath.Combine(map.localcache,'map.txt') );
   map.SSL := true;
   map.OnlyLocal := false;

   map.UseLowZoom := true;

   map.tileserver := tsosm;


   // reconnect attributes that are not saveable
     case map.TileServer of

     tsOSM : begin
                cbLayers.ItemIndex := 0;
                 map.TileServerInfo.MapStyle :='';
    end;

    tsArcGisWorldImagery : begin
     cbLayers.ItemIndex := 1;
      map.TileServerInfo.MapStyle := '';
    end;

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
  FPosition.YAnchor  := 32;

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



  map.TimeLongClick := 750;
  map.OnLongPress := doLongPress;


  // ------------------ styles -------------------------------------------------

  // default lines style

     // border thickness = 2 ; line thickness  = 6 ;  scale = 1
  map.Styles.addRule('.line {bsize:2;weigth:6;scale:1;visible:true}');

  // default markers style

  map.Styles.addRule('.marker {width:32;height:32;scale:1}');


  // rule for gps marker
 // map.Styles.addRule('.marker.gps:true {width:8;height:8;scale:1}');

  // styling trackline
  map.Styles.addRule
    // border thickness = 2 ; border color  = white ;  opacity = 90% ; type of stroke = dash
    ('.line.dash:true {bsize:1;bcolor:white;opacity:90;penStyle:dash;}');

  // style for editing line
  map.Styles.addRule('#_EditLine_.line {color:dodgerBlue;bcolor:white}');

  // for GPS marker Styleicon depends on the zoom
    // flat for zoom 1 to 16; direction for zoom 17 to 21
  map.Styles.addRule('.marker {if:gps=true;width:16;height:16;styleicon:1-16=Flat,17-21=direction}');

  // style according to the mode of tracing
  // define colors variables
  map.Styles.addRule('@hand {Grey}');
  map.Styles.addRule('@foot {dodgerBlue}');
  map.Styles.addRule('@bike {forestGreen}');
  map.Styles.addRule('@car  {OrangeRed}');
  map.Styles.addRule('@gps  {blueviolet}');
  map.Styles.addRule('@food {gold}');
  map.Styles.addRule('@parking {royalblue}');
  map.Styles.addRule('@hotel {#2ca25f}');
  map.Styles.addRule('@restaurant {#e34a33}');
  map.Styles.addRule('@cafe {#fdcc8a}');
  map.Styles.addRule('@bar {#fc8d59}');


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
    (':selected, :hover { if:guidance=4 ;scale:1.3;color:light(@gps);bcolor:light(@gps);hbcolor:light(@gps)');


 // amenity

 Selector := '#' + map.OverPassApi.Layer.Group.Name;
 map.Styles.addRule(Selector+'.marker {styleicon:svg;}'); // markers use svg image

 // graphic for propriety tourims = hotel
 map.styles.addRule(Selector + '.marker.tourism:hotel {graphic:'+ptHotel.Data.data+';color:@hotel;hbcolor:light(@hotel)}');

 map.styles.addRule(Selector+'.polygone.amenity:parking {color:@parking;fcolor:light(@parking)}');


 Selector := Selector + '.marker.amenity';
 map.styles.addRule(Selector + ':restaurant {graphic:'+ptRestaurant.Data.data+';color:@restaurant;hbcolor:light(@restaurant)}');
 map.styles.addRule(Selector + ':cafe {graphic:'+ptcafe.Data.data+';color:@cafe;hbcolor:light(@cafe)}');
 map.styles.addRule(Selector + ':bar {graphic:'+ptbar.Data.data+';color:@bar;hbcolor:light(@bar)}');

 map.styles.addRule(Selector + ':parking {graphic:'+ptparking.Data.data+';color:@parking;hbcolor:light(@parking)}');


 // ----------------------------------------------------------------------------



  // btCompass.Visible := map.RotationAngle <> 0;



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


  // -------------  mappilary layer --------------------------------------------
  FECMappilaryLayer := TECMapillaryLayer.Create(map, 'Mapillary');

  FECMappilaryLayer.LocalCache     := map.LocalCache;
  FECMappilaryLayer.OnClick        := doMappilaryClick;
  FECMappilaryLayer.OnBeginRequest := doBeginRequest;
  FECMappilaryLayer.OnEndRequest   := doEndRequest;
  //----------------------------------------------------------------------------


  // Route Manager
  map.DrawPath.OnReady    := doOnReady;
  map.DrawPath.OnActivate := doOnActivate;
  map.DrawPath.OnError    := doOnError;
  // we assign a value to trigger onActivate
  // which will update the buttons that manage the DrawPath actions
  map.DrawPath.Activate   := false;
  // ---------------------------------------------------------------------------

  // use the dark or light theme
  setSystemTheme;

  map.EndUpdate;


 
end;

procedure TForm2.FormDestroy(Sender: TObject);
begin
  FECNativeScaleMap.Free;
  FECMappilaryLayer.Free;
end;

procedure TForm2.FormSaveState(Sender: TObject);
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
procedure TForm2.setSystemTheme;
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
procedure TForm2.btLocationClick(Sender: TObject);
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
procedure TForm2.doHideGPSPositionInfo(Sender: TECShape);
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
procedure TForm2.LocationSensorLocationChanged(Sender: TObject;
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

    anim.MaxSize := FGPSPosition.Width*5;
    anim.StartSize := FGPSPosition.width;

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
procedure TForm2.doClickGPSPosition(Sender: TObject; const Item: TECShape);
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

procedure TForm2.CancelTracking;
begin
  FGPSPosition.TrackLine := nil;
  RecTracking.Visible := false;
  Tracking.Text := '';
  ptCancel.Visible := false;
  ptEdit.Visible := True;
end;

// event triggered when the GPS marker is moved
procedure TForm2.doMoveGPSPosition(Sender: TObject; const Item: TECShape;
var cancel: boolean);
begin

  if FGPSPosition.isTrackLineActive then
    Tracking.Text := DoubleToStrDigit(TECShapeMarker(Item).TrackLine.Distance,
      2) + ' Km';
end;

// -----------------------------------------------------------------------------

// event activated when the map moves to the background or foreground
procedure TForm2.mapChangeMapActive(Sender: TObject);
begin
  if map.Active then
    map.setCenter(FGPSPosition.latitude, FGPSPosition.longitude);
end;

// event triggered when the map displays a new position
procedure TForm2.mapChangeMapBounds(Sender: TObject);
begin

   CancelAddressSearch;

  // add 180° because the svg has the head down
  ptCompass.RotationAngle := map.RotationAngle + 180;

  // btCompass.Visible := map.RotationAngle <> 0;


end;

// event triggered when the zoom changes
procedure TForm2.mapChangeMapZoom(Sender: TObject);
begin
  lbZoom.Text := doubleToStrDigit(map.NumericalZoom,1);
end;

procedure TForm2.mapLongPress(Sender: TObject);
begin


end;

// event triggered by a click on the map
procedure TForm2.mapMapClick(Sender: TObject; const Lat, Lng: Double);
begin
  CancelAddressSearch;
end;



procedure TForm2.mapMapLongClick(sender: TObject; const Lat, Lng: Double);
begin
end;

// event triggered by a long press on the map
// sender is either the map or a TECShape element
procedure TForm2.doLongPress(Sender: TObject);
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
procedure TForm2.mapShapeClick(sender: TObject; const item: TECShape);
begin

 if (laEdit.Visible) then
    exit;


 if laAmenity.Visible then
  btCancelAmenityClick(nil);

  if not assigned(item) then exit;


 // Control that the element has a guidance property
 if item.PropertyValue['guidance']<>'' then
   EditProprietes(item);

end;

// event OnshapeDrag triggered during the entire move
procedure TForm2.doShapeDrag(Sender: TObject; const Item: TECShape;
var cancel: boolean);
begin
  // at the start of the move the description is deleted
  if Item.DragStart then
    Item.Description := '';
end;

// at the end of the move OnDragEnd is called
// update the description with the new address
procedure TForm2.doShapeDragEnd(Sender: TObject);
begin
  if Sender is TECShapeMarker then
    // for a better readability of the label we insert line breaks
    TECShapeMarker(Sender).Description :=
      Remplace_Str(TECShapeMarker(Sender).Address, ',', #13#10)
end;

// cancel the rotation of the map
procedure TForm2.btCompassClick(Sender: TObject);
begin

  map.AnimRotationAngleTo(0);

  CancelAddressSearch;

end;

procedure TForm2.CloseLayers;
begin
   if FECMappilaryLayer.Visible then
    btMappilaryClick(nil);

 map.OverPassApi.Layer.Visible := false;
 aniPOI.Visible := false;
 aniPOI.Enabled := false;

end;



// =================== Route Edition ===========================================


// activate route editing
procedure TForm2.btEditClick(Sender: TObject);
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
      map.DrawPath.Activate := false;

  end;
end;

procedure TForm2.GuidanceSelection(Sender: TObject);
begin

  case cbGuidance.ItemIndex of
    0: map.DrawPath.PathType := dptStraight;

    1: map.DrawPath.PathType := dptPedestrian;

    2: map.DrawPath.PathType := dptBicycle;
  else
   map.DrawPath.PathType := dptCar;

  end;

  map.DrawPath.Activate := true;

end;

procedure TForm2.btAddPointClick(Sender: TObject);
begin
  map.DrawPath.AddPoint;
end;


// Validation of the route, it is definitively registered
procedure TForm2.btValidLineClick(Sender: TObject);
var
  g: TECShapes;
  line: TECShapeLine;
begin
   // create un group with unique name
  g := map[Crc32Str(DateTimeToStr(now))];
  line := g.AddLine;
  // Copy the edited route in its final version
  map.DrawPath.GetPath(line);

  // draw a background for our marker
  g.markers.OnBeforeDraw := doBeforeDraw;
  // display the labels of the markers in this group
  setMarkersLabels(g);


  // Apply a style to the road according to the type of circulation
  setStyleLine(line, inttostr(cbGuidance.ItemIndex));



end;



// display the labels of the markers in this group
procedure TForm2.setMarkersLabels(const G:TECShapes);
begin
  // the Description property of the marker is used as label text
  G.Markers.Labels.LabelType := ltDescription;
  G.Markers.Labels.Align := TLabelShapeAlign.LaBottom;
  G.Markers.Labels.Margin := 12;
  G.Markers.Labels.MaxWidth := 150;
  G.Markers.Labels.Visible := True;
end;


// delete last segment
procedure TForm2.btCancelPointClick(Sender: TObject);
begin
  map.DrawPath.Undo;
end;

// Activation / deactivation of route tracing
procedure  TForm2.doOnActivate(const Activate:boolean);
begin
  laEdit.Visible := Activate;

  ptCancel.Visible := Activate;
  ptEdit.Visible   := not Activate;
end;

// This event occurs before and after the calculation of the route in a thread,
// while the segment is being calculated you can neither validate the route
// nor cancel the last segment
procedure  TForm2.doOnReady(const Ready:boolean);
begin
 btValidLine.Enabled    := Ready and map.DrawPath.isUndo;
 btCancelPoint.Enabled  := Ready and map.DrawPath.isUndo;
end;

// event triggered if the route calculation is not validated
procedure TForm2.doOnError(Sender: TObject);
begin
  ShowMessage('Routing Error !');
end;


// Stylize the elements (line & marker ) according to the type of track
procedure TForm2.setStyleLine(const line: TECShapeLine; const guidance: string);
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



procedure TForm2.EditProprietes(sender : TECShape);
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


procedure TForm2.btValidPropClick(Sender: TObject);
begin
 TECshapeMarker(edDescription.TagObject).Description    := edDescription.Text;
 TECshapeMarker(edDescription.TagObject).Group.Selected := false;
 laProprietes.Visible := false;
 btEdit.Enabled       := true;
end;



procedure TForm2.btCancelPropClick(Sender: TObject);
begin
 TECshapeMarker(edDescription.TagObject).Group.Selected := false;
 laProprietes.Visible := false;
 btEdit.Enabled       := true;
end;


procedure TForm2.btDeleteClick(Sender: TObject);
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
procedure TForm2.doBeforeDraw(const canvas: TECCanvas; var Rect: TRect;
Item: TECShape);
begin
  canvas.FillOpacity := 90;
  canvas.brush.color := FLightColor;


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



// ------------------------------------------------------------------------------



// ============= select tiles server ===========================================

procedure TForm2.btLayersClick(Sender: TObject);
begin
  cbLayers.dropDown;
  CancelAddressSearch;
end;

procedure TForm2.cbLayersClick(Sender: TObject);
begin


  map.RemoveAllOverlayTiles;

  map.TileServerInfo.MapStyle := '';

  case cbLayers.ItemIndex of
   (* 0:
      begin
        map.TileServer := tsIgn;

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
         map.IgnKey :=   '5ck5xxrc5s1gienx7ne6q6ea';
      end; *)



    0:
      begin
        map.TileServer := tsOSM;//tsHotOsm;
      end;
    1:
      begin
        map.TileServer := tsArcGisWorldImagery;
        // add overlay tiles for places
        map.AddOverlayTiles(GetArcGisPlacesTile, 'World_Places_Tile');
      end;

  end;

end;

procedure TForm2.GetArcGisPlacesTile(var TileFilename: string;
const x, y, z: integer);
begin
  TileFilename :=
    format('https://services.arcgisonline.com/ArcGIS/rest/services/Reference/World_Boundaries_and_Places/MapServer/tile/%d/%d/%d.png',
    [z, y, x]);
end;

// ------------------------------------------------------------------------------

procedure TForm2.doNotifyScale(Sender: TObject);
begin

  if assigned(Sender) and (Sender is TECNativeScaleMap) then
  begin
    scaleline.Size.Width := TECNativeScaleMap(Sender).ScaleWidth;
    ScaleLegend.Text := TECNativeScaleMap(Sender).ScaleLegend;
  end;

end;


// ============= search for the geographical position of an address ============

procedure TForm2.edAddressChangeTracking(Sender: TObject);
begin

  if (gettickcount - fTimeKeyPress > tmAddress.interval) then
    tmAddressTimer(nil)
  else
    tmAddress.Enabled := True;

  fTimeKeyPress := gettickcount;

end;

procedure TForm2.edAddressEnter(Sender: TObject);
begin
  laTop.height := 300;
  lbAddress.Visible := True;
end;

procedure TForm2.edAddressExit(Sender: TObject);
begin
  lbAddress.Visible := false;
  lbAddress.Items.Text := '';
  edAddress.Text := '';
  laTop.height := 60;
  map.GeoLocalise.SearchResults.Clear;
end;

procedure TForm2.edAddressKeyDown(Sender: TObject; var Key: Word;
var KeyChar: Char; Shift: TShiftState);
begin

  // if validate then select the first address
  if Key = 13 then
    GotoAddress(0);

end;

procedure TForm2.tmAddressTimer(Sender: TObject);
var
  i: integer;
begin
  tmAddress.Enabled := false;

  if Length(edAddress.Text) < 3 then
    exit;

  if map.GeoLocalise.OpenStreetMapSearch(edAddress.Text,map.onlylocal) > 0 then
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




procedure TForm2.lbAddressItemClick(const Sender: TCustomListBox;
const Item: TListBoxItem);
begin
  GotoAddress(Item.Index);
end;

procedure TForm2.GotoAddress(const Index: integer);
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

procedure TForm2.CancelAddressSearch;
begin

  if not lbAddress.Visible then
    exit;

  // hack for disable focus
  edAddress.Visible := false;
  edAddress.Visible := True;
end;

// -----------------------------------------------------------------------------





// ==================== Mappilary ==============================================

procedure TForm2.btMappilaryClick(Sender: TObject);
begin

 switch(btMappilary);

 if (btMappilary.tag = 1) and (map.Zoom<FECMappilaryLayer.MinZoom) then
  map.Zoom := FECMappilaryLayer.MinZoom;

 FECMappilaryLayer.Visible := (btMappilary.tag = 1);
 FECMappilaryLayer.TrafficSignVisible := false;

end;



// display the photograph of the place in an infowindow
procedure TForm2.doMappilaryClick(Layer: TECMapillaryLayer;
  Item: TECShape; MappilarySequence: TMapillarySequence; PhotoIndex: integer);
begin


  FECMappilaryLayer.OpenWindow(MappilarySequence.images[PhotoIndex].Lat,
                               MappilarySequence.images[PhotoIndex].Lng,
                               '<img src="' + MappilarySequence.images[photoindex].Url256 + '">'
                               );

end;

// start mappilary request
procedure TForm2.doBeginRequest(sender: TObject);
begin
  aniMappilary.Visible := true;
  aniMappilary.Enabled := true;
end;

// end mappilary request
procedure TForm2.doEndRequest(sender: TObject);
begin
  aniMappilary.Visible := false;
  aniMappilary.Enabled := false;
end;


//------------------------------------------------------------------------------


// ====================== POI restaurant - parking - hotel =====================

procedure TForm2.btParkingClick(Sender: TObject);
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

procedure TForm2.btPOIClick(Sender: TObject);
begin

if not map.OverPassApi.Layer.visible then

  switch(btPOI);

 laAmenity.Visible := not laAmenity.Visible;
 btEdit.Enabled    := not laAmenity.Visible;
end;

procedure TForm2.btCancelAmenityClick(Sender: TObject);
begin
 switch(btPOI);
 laAmenity.Visible := false;
 btEdit.Enabled    := not laAmenity.Visible;
 map.OverPassApi.Layer.Visible := false;
 aniPOI.Visible := false;
 aniPOI.Enabled := false;
end;



// launch a POI search using the XAPI layer
procedure TForm2.btValidAmenityClick(Sender: TObject);
var amenity:string;
begin

 laAmenity.Visible := false;
 btEdit.Enabled    := not laAmenity.Visible;

 amenity := '';


 if (bthotel.Tag=1) then
 begin
  map.OverPassApi.Layer.visible := true;
  map.OverPassApi.Layer.Tag('tourism','hotel');
  map.OverPassApi.Layer.Group.ClusterManager.Style := csEllipse;
  map.OverPassApi.Layer.Group.ClusterManager.TextColor := strToColor('#2ca25f');
  map.OverPassApi.Layer.Group.ClusterManager.BorderColor := map.OverPassApi.Layer.Group.ClusterManager.TextColor;
 end;

 if (btrestaurant.Tag=1) then
 begin
   map.OverPassApi.Layer.visible := true;
   map.OverPassApi.Layer.Amenity(['restaurant','cafe','bar']);
   map.OverPassApi.Layer.Group.ClusterManager.TextColor := FDarkColor;
   map.OverPassApi.Layer.Group.ClusterManager.Style := csCategories;
 end;

 if (btparking.Tag=1) then
 begin
   map.OverPassApi.Layer.visible := true;
   map.OverPassApi.Layer.Amenity('parking');
   map.OverPassApi.Layer.Group.ClusterManager.TextColor   := claRoyalblue;
   map.OverPassApi.Layer.Group.ClusterManager.BorderColor := claRoyalblue;

   map.OverPassApi.Layer.Group.ClusterManager.Style := csEllipse;
 end;




end;


// start xapi request
procedure TForm2.doSearchAmenity(sender : TObject);
begin
 aniPOI.Visible := true;
 aniPOI.Enabled := true;
end;

// end xapi request
procedure TForm2.doEndSearchAmenity(sender : TObject);
begin
 aniPOI.Visible := false;
 aniPOI.Enabled := false;
end;


// Display the properties of the clicked element
procedure TForm2.doClickAmenity(sender:TObject; const Item: TECShape);
var s:string;
    Key, Value: string;
begin

  s := '';

  // Browse the property list
  if Item.PropertiesFindFirst(Key, Value) then
  begin
    repeat

      // ignore this one
      if (Key = 'id') then
        continue;


      if length(Key) < 9 then
       // add a tab to start the values at 65px
        Key := Key + '<tab="65">';

      // put in bold the key and return to the line after each couple key/value
      s := s + '<b>' + Key + '</b>:' + Value + '<br>';




    // continue as long as it has properties
    until Item.PropertiesFindNext(Key, Value);
  end;

  if s='' then exit;

  // Display the list of properties in a 250px wide InfoWindow
  map.OverPassApi.Layer.OpenWindow(item.Latitude,item.Longitude,s,250);


end;


// -----------------------------------------------------------------------------




// ============= automatic Zoom ================================================

// activate the timer when the button is pressed
// a progressive zoom will then be automatically performed
procedure TForm2.btZoomInMouseDown(Sender: TObject; Button: TMouseButton;
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
procedure TForm2.btZoomInMouseLeave(Sender: TObject);
begin
 tmZoom.Enabled   := false;
 // if necessary reactivate the layer mappilary
 FECMappilaryLayer.Visible := IsMappilaryLayer;
end;

// cancel progressive zoom
procedure TForm2.BtZoomOutMouseUp(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Single);
begin
 tmZoom.Enabled   := false;
 // if necessary reactivate the layer mappilary
 FECMappilaryLayer.Visible := IsMappilaryLayer;
end;



// Progressive zoom in or out
// Allows to go beyond the maximum zoom managed by the tile server
procedure TForm2.tmZoomTimer(Sender: TObject);
begin


  if (tmZoom.TagObject = btZoomIn) then
  begin
   // map.ZoomScaleFactorAround(map.center,map.ZoomScaleFactor + 10)
  // if map.ZoomScaleFactor<989 then
   map.ZoomScaleFactor := map.ZoomScaleFactor + 10
  end
  else
   map.ZoomScaleFactor := map.ZoomScaleFactor - 10;
  // map.ZoomScaleFactorAround(map.center,map.ZoomScaleFactor - 10);


end;

//------------------------------------------------------------------------------


end.
