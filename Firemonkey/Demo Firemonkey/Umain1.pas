unit Umain1;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Rtti, System.Classes,
  System.Variants, FMX.Types, FMX.Controls, FMX.Forms, FMX.Dialogs,
  FMX.Graphics,
  System.UIConsts, math,
  System.Generics.Collections,
{$IFDEF MSWINDOWS}
  Winapi.ShellAPI, Winapi.Windows,
{$ENDIF}
  FMX.uecMapillary,
  // used by NativeMap ---------------------------------------------------------
  FMX.uecgeoLocalise,
  FMX.uecNativeMapControl, FMX.uecNativeShape, FMX.uecNativePlace,
  FMX.uecMapUtil, FMX.uecGraphics, FMX.uecNativeMiniMap,
  FMX.uecNativePlaceLayer,
  // for recalculate a route interactively
  FMX.uecEditNativeLine,
  // for the label triangles animated
  FMX.uecNativeLabelLayer,
  // for scale bar
  FMX.uecNativeScaleMap, FMX.uecNativeMeasureMap,
  // vector styles
  uecVectorStyles_standard,

  // ---------------------------------------------------------------------------
  FMX.uecHeatMap,
  FMX.uecHttp,
  FMX.Edit, FMX.ListBox, FMX.Objects, FMX.StdCtrls, FMX.Controls.Presentation,
  FMX.Ani, System.Sensors, System.Sensors.Components,
  FMX.Layouts, System.ImageList, FMX.ImgList{$IFDEF XE7_OR_HIGHER},
  FMX.Controls.Presentation{$ENDIF};

type
  TFormMegademo = class(TForm)
    Panel1: TPanel;
    ckPanoramio: TCheckBox;
    pnLatLng: TPanel;
    LatLng: TLabel;
    GroupBox1: TGroupBox;
    Label1: TLabel;
    Label2: TLabel;
    RouteStart: TEdit;
    RouteEnd: TEdit;
    AddRoute: TButton;
    GroupBox2: TGroupBox;
    DefaultMarker: TButton;
    MarkerImage: TButton;
    Traffic: TCheckBox;
    GroupBox3: TGroupBox;
    cbMaps: TComboBox;
    InfoRoute: TLabel;
    LoadMap: TButton;
    SaveMap: TButton;
    OpenDialog: TOpenDialog;
    ClearMap: TButton;
    SaveDialog: TSaveDialog;
    MarkerPOI: TButton;
    ckMiniMap: TCheckBox;
    Lines: TGroupBox;
    btLines: TButton;
    btPoly: TButton;
    btNone: TButton;
    lbInfosize: TLabel;
    ArcDial1: TArcDial;
    pnMap: TPanel;
    pnInfo: TPanel;
    Label3: TLabel;
    GroupBox4: TGroupBox;
    rbResto: TRadioButton;
    rbStore: TRadioButton;
    btFindPlaces: TButton;
    btAbort: TButton;
    GroupBox5: TGroupBox;
    edAdress: TEdit;
    PermaLink: TGroupBox;
    cbPermaLink: TComboBox;
    AddLink: TButton;
    rbNone: TRadioButton;
    ckLoupe: TCheckBox;
    map: TECNativeMap;
    pnNativeMap: TPanel;
    GroupBox6: TGroupBox;
    ProgressBar: TProgressBar;
    StartStop: TButton;
    LabelDownLoad: TLabel;
    ckMeasure: TCheckBox;
    LEngine: TLabel;
    engine: TComboBox;
    ScaleToZoom: TCheckBox;
    Clustering: TCheckBox;
    InfoBar: TLayout;
    ScaleLine: TLine;
    ScaleLegend: TLabel;
    CopyrightMap: TLabel;
    LayerAniIndicator: TAniIndicator;
    Mappilary: TCheckBox;
    Heatmap: TCheckBox;
    CheckBox2: TCheckBox;
    HeatmapOpacity: TTrackBar;
    procedure ckPanoramioClick(Sender: TObject);

    procedure AddRouteClick(Sender: TObject);
    procedure mapPanoramioClick(Sender: TObject; const Item: TECShape;
      const ownerId, ownerName, PhotoId, PhotoDate, PhotoTitle, PhotoUrl,
      copyright: string);
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure DefaultMarkerClick(Sender: TObject);
    procedure MarkerImageClick(Sender: TObject);
    procedure TrafficClick(Sender: TObject);

    procedure cbMapsClick(Sender: TObject);
    procedure LoadMapClick(Sender: TObject);
    procedure ClearMapClick(Sender: TObject);
    procedure SaveMapClick(Sender: TObject);
    procedure MarkerPOIClick(Sender: TObject);
    procedure ckMiniMapChange(Sender: TObject);

    procedure btLinesClick(Sender: TObject);

    procedure mapMapClick(Sender: TObject; const Lat, Lng: Double);
    procedure mapShapeClick(Sender: TObject; const Item: TECShape);
    procedure ArcDial1Change(Sender: TObject);

    procedure edAdressKeyUp(Sender: TObject; var Key: Word; var KeyChar: Char;
      Shift: TShiftState);

    procedure AddLinkClick(Sender: TObject);
    procedure cbPermaLinkClick(Sender: TObject);
    procedure UtfGeographyClick(Sender: TObject);
    procedure rbNoneClick(Sender: TObject);
    procedure ckLoupeChange(Sender: TObject);
    procedure mapLoad(Sender: TObject; const GroupName: string;
      const FinishLoading: Boolean);
    procedure mapBeforeUrl(Sender: TObject; var Url: string);
    procedure StartStopClick(Sender: TObject);
    procedure LinesDblClick(Sender: TObject);

    procedure mapMapDblClick(Sender: TObject; const Lat, Lng: Double);
    procedure ckMeasureChange(Sender: TObject);
    procedure mapMapSelectRect(Sender: TObject;
      const SWLat, SWLng, NELat, NELng: Double);
    procedure mapClusterClick(Sender: TObject; const Cluster: TECCluster);
    procedure mapKeyUp(Sender: TObject; var Key: Word; var KeyChar: Char;
      Shift: TShiftState);

    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);

    procedure ScaleToZoomChange(Sender: TObject);

    procedure ClusteringChange(Sender: TObject);
    procedure mappilaryChange(Sender: TObject);
    procedure mapShapeRightClick(Sender: TObject; const Item: TECShape);
    procedure ArcDial1DblClick(Sender: TObject);
    procedure mapShapeDblClick(Sender: TObject; const Item: TECShape);
    procedure mapShapeMouseOver(Sender: TObject; const Item: TECShape);
    procedure mapShapeDrag(Sender: TObject; const Item: TECShape;
      var cancel: Boolean);
    procedure mapShapeDragEnd(Sender: TObject);
    procedure mapShapeMouseDown(Sender: TObject; const Item: TECShape);

    procedure doSelectLine(Sender: TObject);
    procedure doDeSelectLine(Sender: TObject);
    procedure mapMapMouseMove(Sender: TObject; const Lat, Lng: Double);
    procedure HeatmapChange(Sender: TObject);
    procedure HeatmapOpacityTracking(Sender: TObject);

  private
    { Déclarations privées }

    FEditLine: TecNativeLineSelect;

    FSelectionLine: TECShapeLine;
    FSelectionPoly: TECShapePolygone;

    FHeatmapLayer: TECHeatmapLayer;

    FGoogleMarker: Boolean;

    FECOpenWeatherTilesLayer: TECOpenWeatherTilesLayer;

    FMiniMap: TECNativeMiniMap;

    FECNativeScaleMap: TECNativeScaleMap;
    FECNativeMeasureMap: TECNativeMeasureMap;

    FECMappilaryLayer: TECMapillaryLayer;

    // labels layer see uecNativeLabelLayer
    FLabelLayer: TecNativeLabelLayer;

    FSelectedShape: TECShape;

    FInfoWindowShapes: TECShapes;

    FUTFLayer: TECNativeUTFLayer;

    // FPlacesLayer : TECNativePlaceLayer;

    // download area of tiles
    FECDownLoadTiles: TECDownLoadTiles;

    procedure doMappilaryClick(Layer: TECMapillaryLayer; Item: TECShape;
      MappilarySequence: TMapillarySequence; PhotoIndex: integer);

    procedure doOnCreateCSVPoint(const Group: TECShapes; var CSVPoint: TECShape;
      const Lat, Lng: Double; const Data: TStringList);

    procedure doNotifyScale(Sender: TObject);
    procedure doUpdateCopyrighMap;

    procedure doOnAddRoute(Sender: TECShapeLine; const params: string);
    procedure doOnChangeRoute(Sender: TECShapeLine; const params: string);

    procedure doDownLoadTiles(Sender: TObject);
    procedure doEndDownLoadtiles(Sender: TObject);
    // --------------------------------

    procedure Editshape(const Value: Boolean);
    procedure doPathChange(Sender: TObject);

    procedure doSelectedChange(Sender: TObject);
    procedure doOnSelectShape(Sender: TObject; const Shape: TECShape;
      var cancel: Boolean);

    procedure doOnShapeMove(Sender: TObject; const Item: TECShape;
      var cancel: Boolean);

    procedure doEndAnimationMove(Sender: TObject);

    procedure doNumDrawPOI(const canvas: TECCanvas; var r: TRect;
      Item: TECShape);

    procedure doDrawHint(const canvas: TECCanvas; var r: TRect; Item: TECShape);

    procedure doOwnerDrawPOI(const canvas: TECCanvas; var Rect: TRect;
      Item: TECShape);
    procedure doFontPOI(const canvas: TECCanvas; Item: TECShape);

    procedure doAfterDraw(const canvas: TECCanvas; var Rect: TRect;
      Item: TECShape);

    procedure OpenInfoWindow(const content: string;
      const Latitude, Longitude: single);

    procedure GetArcGisPlacesTile(var TileFilename: string;
      const x, y, z: integer);

    procedure GetUTFTile(var TileFilename: string; const x, y, z: integer);
    procedure doOnOverUTFData(Sender: TObject);
    procedure doOnOutUTFData(Sender: TObject);

    procedure doOnXAPIClick(Sender: TECShape);
    procedure doOnXAPIStartSearch(Sender: TObject);
    procedure doOnXAPIChange(Sender: TObject);

    procedure doOnMoveTriangle(Sender: TObject; const Item: TECShape;
      var cancel: Boolean);
    procedure doOnClickTriangle(Sender: TObject; const Item: TECShape);
    procedure OnOffTracking(const Item: TECShape);

    procedure doCreateShapeLinePointEditable(Sender: TObject;
      const Group: TECShapes; var ShapeLinePoint: TECShape;
      const Lat, Lng: Double; const index: integer);
  public
    { Déclarations publiques }
    procedure UpdateXapiStyles;
  end;

var
  FormMegademo: TFormMegademo;
  tick: cardinal;

implementation

{$R *.fmx}
{$I Delphi_Versions.inc}

function GetRandomColor: TAlphaColor;
begin

  TAlphaColorRec(result).r := random(255);
  TAlphaColorRec(result).G := random(255);
  TAlphaColorRec(result).B := random(255);
  TAlphaColorRec(result).A := 255;

end;




// ============ FORM ===========================================================



// download area of tiles

// Start / Stop download
procedure TFormMegademo.StartStopClick(Sender: TObject);
begin
  case StartStop.tag of

    0:
      begin
        // start downloading visible area

        StartStop.Text := 'Stop';
        StartStop.tag := 1;

        // tiles are saved in DirectoryTiles
        FECDownLoadTiles.DirectoryTiles := map.LocalCache;
        FECDownLoadTiles.TileServer := map.TileServer;
        FECDownLoadTiles.TileSize := map.TileSize;

        FECDownLoadTiles.MapBoxToken := map.MapBoxToken;
        FECDownLoadTiles.DigitalGlobeToken := map.DigitalGlobeToken;

        // download visible area from zoom+1 to MaxZoom

        FECDownLoadTiles.DownLoadTiles(map.Zoom + 1, map.MaxZoom,
          map.NorthEastLatitude, map.NorthEastLongitude, map.SouthWestLatitude,
          map.SouthWestLongitude);

      end;

    1:
      begin
        // stop downloading

        FECDownLoadTiles.cancel;

        StartStop.Text := 'Start';
        StartStop.tag := 0;

      end;

  end;
end;

// event fired after a tile is downloading
procedure TFormMegademo.doDownLoadTiles(Sender: TObject);
begin

  ProgressBar.Max := FECDownLoadTiles.CountTotalTiles;
  ProgressBar.Value := FECDownLoadTiles.CountDownLoadTiles;

  LabelDownLoad.Text :=
    inttostr(round((FECDownLoadTiles.CountDownLoadTiles /
    FECDownLoadTiles.CountTotalTiles) * 100)) + '%   ' +
    inttostr(FECDownLoadTiles.CountDownLoadTiles) + ' / ' +
    inttostr(FECDownLoadTiles.CountTotalTiles);

end;

// fired when cancel or when all tiles are downloading
procedure TFormMegademo.doEndDownLoadtiles(Sender: TObject);
begin
  doDownLoadTiles(nil);

  StartStop.Text := 'Start';
  StartStop.tag := 0;
end;

// ------------------------------------------------------------------------------
procedure TFormMegademo.doOnSelectShape(Sender: TObject; const Shape: TECShape;
  var cancel: Boolean);
begin
  // cancel := not(Shape is TECShapePOI);
end;

procedure TFormMegademo.FormCloseQuery(Sender: TObject; var CanClose: Boolean);
begin
  // map.Clear;
end;

procedure TFormMegademo.UpdateXapiStyles;
var
  Selector: string;
begin

  Selector := '#' + map.XapiLayer.Shapes.Name + '.marker.amenity';

  map.styles.addRule(Selector + ':restaurant' +
    '{graphic:base64,iVBORw0KGgoAAAANSUhEUgAAABIAAAAaBAMAAABI' +
    'sxEJAAAAGXRFWHRTb2Z0d2FyZQBBZG9iZSBJbWFnZVJlYWR5ccllPAAAABJQTFRFAAAA////AAAAAAA'
    + 'AAAAAAAAA/h6U3wAAAAV0Uk5TAAAQgL++EJOXAAAAOElEQVQY02MIFQ0MFWRUCXVigLBcQ0OgrNDQUH'
    + 'JYQIDOMg0NDYawBIFC2FgCSCxBerFMg0Es02AAP34wMx8/aIAAAAAASUVORK5CYII=;visible:true;');

  map.styles.addRule(Selector + ':bar' +
    '{graphic:base64,iVBORw0KGgoAAAANSUhEUgAAABoAAAAaCAYAAACpSkzOAAAAzklEQVRIx+2WUQ3'
    + 'FIAxFK2ES8HANVMIkIGUOkICESUDCJCABCdtPSQgJC2UjeXlZk3402e1ZoRSIGgZgA3AqfSOtAYgDoK'
    + 'iFmCxWaDLMaEAsoqDQBNGsGlDeHyexnbJPAHwpKuIe9zSwDFzFPR6egM4P9HMgX3YQgDSr67gQrsq51'
    + 'z8ZqqqSwHrOkhsZqguAo0iyS5weL1kD5qZUcjPNfXV1HPIThmaY9vr4QH8KknbPXbfMgtiqvSMA+1Zy'
    + 'lrNy9/SK8g0PVamc2NlTK98F1MyKB+QkmGEAAAAASUVORK5CYII=;visible:true;}');

  map.styles.addRule(Selector + ':cafe' +
    '{graphic:base64,iVBORw0KGgoAAAANSUhEUgAAABoAAAAaCAYAAACpSkzOA' +
    'AAAuUlEQVRIx2NgIACMjY0F0PgN+OTJBkCD9iMbCsT/cclTYkkCzGCoJfuB+D02eUosKQAZAjIM5nKQ'
    + 'JUBsgE2eEotQDIHyHXDJU2JRPyn8wQmgcfCfTPye1HghGw8/i4D4PBrbgVYWYcMGtLAoAakUmQ8VW0/'
    + 'TOALyFXDGHZUtEqCXRbCy8DzNLAKlNqTMn0ATi0AVI5LYflol7/1I7Pk4a18q5Zv3BKsPKpUMCvQogh'
    + 'RGS2+aW0SzGhYAB5lDXBZ7NtoAAAAASUVORK5CYII=;visible:true;}');


  // roads

  map.styles.addRule
    ('.line.highway:motorway,.line.highway:trunk  {zindex:10;weight:6;color:gradient(Red,Yellow,0.1);visible:true;}');

  map.styles.addRule
    ('.line.highway:primary {zindex:9;weight:4;color:gradient(Red,Yellow,0.3);visible:true;}');
  map.styles.addRule
    ('.line.highway:secondary {zindex:8;weight:3;color:gradient(Red,Yellow,0.4);visible:true;}');

  map.styles.addRule('.line.highway:tertiary,' + '.line.highway:unclassified,' +
    '.line.highway:road {zindex:7;weight:3;color:gradient(Red,Yellow,0.6);visible:true;}');

  map.styles.addRule
    ('.line.highway:residential {zindex:6;weight:2;color:gradient(Red,Yellow,0.8);visible:true;}');

  // junction
  map.styles.addRule
    ('.marker.junction:yes {zindex : 10;color:gradient(red,yellow,0.3);styleicon:Flat;}');

  map.styles.addRule('#' + map.XapiLayer.Shapes.Name +
    '.marker.highway:bus_stop {color:blue;styleicon:Flat;visible:true;}');
  map.styles.addRule('#' + map.XapiLayer.Shapes.Name + '.marker  {scale:1;}');
  map.styles.addRule('#' + map.XapiLayer.Shapes.Name +
    '.marker:hover  {scale:1.5;}');

  map.styles.addRule('.kind:major_road{weight:10}');

end;


// manual management of the scale and copyright
// Enables proper display even during map rotation

procedure TFormMegademo.doUpdateCopyrighMap;
begin
  CopyrightMap.Text := map.CopyrightTile;
end;

procedure TFormMegademo.doNotifyScale(Sender: TObject);
begin

  if assigned(Sender) and (Sender is TECNativeScaleMap) then
  begin
    ScaleLine.Size.Width := TECNativeScaleMap(Sender).ScaleWidth;
    ScaleLegend.Size.Width := ScaleLine.Size.Width;
    ScaleLegend.Text := TECNativeScaleMap(Sender).ScaleLegend;
  end;

end;
// ------------------------------------------------------------------------------

procedure MyOnGetScale(Sender: TECShape; var ScaleValue: Double);
var
  Scale: Double;
begin

  Scale := Sender.Scale;

  if Scale = 0 then
    Scale := 1;

  ScaleValue := 4 * Scale * (Sender.World.Zoom / Sender.World.MaxZoom);
end;

procedure TFormMegademo.FormCreate(Sender: TObject);
begin

  // take over the creation of the points
  map.Shapes.CSV.OnCreateCSVPoint := doOnCreateCSVPoint;

  // map.OnlyLocal := true;

  // create heatmap layer
  FHeatmapLayer := TECHeatmapLayer.Create(map);

  FECOpenWeatherTilesLayer := nil;

  map.Reticle := true;
  map.ReticleColor := claRed;

  map.OnKeyUp := nil;

  UpdateXapiStyles;

  map.HereApiKey := 'J0i4D_Us-VVif8CoGThgli_BtH8Pof9zwW_h_PJUTgw';
  map.ThunderforestKey := 'cc4056248fe0412ea9262810f4ab8abc';

  // ! USE YOUR KEY !
  map.MapBoxToken :=
    'pk.eyJ1Ijoiam9tYXgiLCJhIjoiY2lrZjVkaTl2MDAzNXZza3F5Zmg3eno2ZiJ9.VN9b5zTP0OrTLqQncoVafQ';
  map.Routing.OnAddRoute := doOnAddRoute;
  map.Routing.OnChangeRoute := doOnChangeRoute;

  map.DigitalGlobeToken :=
    'pk.eyJ1IjoiZGlnaXRhbGdsb2JlIiwiYSI6ImNpcXV6aXVpMjAwY2lnMm5ocGc5d2NzeTYifQ.uNk6Hd01rz1wrQIm2Lp0jg';

  FECNativeScaleMap := TECNativeScaleMap.Create;
  FECNativeScaleMap.OnChange := doNotifyScale;
  // manual draw scale bar in doNotifyScale
  FECNativeScaleMap.Visible := false;
  FECNativeScaleMap.map := map;

  doUpdateCopyrighMap;
  // manual copyright in doUpdateCopyrighMap
  map.ShowCopyrightTile := false;

  FECNativeMeasureMap := TECNativeMeasureMap.Create;
  FECNativeMeasureMap.map := map;

  // map.selected.onchange := doSelectedChange;
  map.selected.onSelectshape := doOnSelectShape;

  // HACK FOR ROTATION MAP
  // for adapt to rotation, size map is double of its parent
  // Placing the map to a TPanel (pnNativeMap) determines the visible area

  map.OverSizeForRotation := false; // true;

  // map.ScaleFactor := 2;

  map.ScaleMarkerToZoom := true;

  (* map.OnGetScale :=  myOnGetScale;

    // default 1 for all zoom
    map.styles.addRule('.marker [zoom *] {scale:1;}');
    map.styles.addRule('.marker [zoom 14,15,16] {scale:0.8}');
    map.styles.addRule('.marker [zoom 10,11,12,13] {scale:0.5}');
    map.styles.addRule('.marker [zoom 1,2,3,4,5,6,7,8,9] {scale:0.2}'); *)


  // -----------------------------------------
  // map.HideShapesWhenZoom := true;

  // use your Bing Map Key => http://msdn.microsoft.com/fr-fr/library/ff428642.aspx
  map.BingKey :=
    'ArHKANdOJkF3qiLETYcxAJSpT1lpG1sPR-jDLu7DHr0DZVFvky30AehdYHMhWoy4';

  // ! USE YOUR KEY !
  map.MapQuestKey := 'kFJXGPYO7xkGxpNtoPxujSuhmYIxgWNv';

  btNone.isPressed := true;

  // for download area of tiles
  // cwaiting 500 ms between each tile
  FECDownLoadTiles := TECDownLoadTiles.Create(500);

  FECDownLoadTiles.OnDownLoad := doDownLoadTiles;
  FECDownLoadTiles.OnEndDownLoad := doEndDownLoadtiles;
  //

  // local cache for tiles
  map.LocalCache := ExtractfilePath(ParamStr(0)) + 'cache';


  // on iOS and Android you can use TPath.Combine(TPath.GetDocumentsPath, 'cache');
  // Android (not on iOS) you can use also TPath.Combine(TPath.GetSharedDocumentsPath, 'cache');
  //
  // see :
  // http://docwiki.appmethod.com/appmethod/1.14/libraries/en/System.IOUtils.TPath.GetDocumentsPath
  // http://docwiki.appmethod.com/appmethod/1.14/libraries/en/System.IOUtils.TPath.GetSharedDocumentsPath

  // create minimap
  FMiniMap := TECNativeMiniMap.Create(map);

  ckLoupe.Visible := ckMiniMap.IsChecked;

  // re draw after basic draw
  map.Group['pois'].Pois.OnAfterDraw := doNumDrawPOI;
  // map.shapes.Pois.OnAfterDraw := doNumDrawPOI;
  // self draw pois
  map.Group['pois'].Pois.OnOwnerDraw := doOwnerDrawPOI;

  // group infowindows
  FInfoWindowShapes := map.Group['mywindows'];
  FInfoWindowShapes.Zindex := 20;

  // default infowindow invisible
  FInfoWindowShapes.InfoWindows.add;
  FInfoWindowShapes.InfoWindows[0].Zindex := 100;
  FInfoWindowShapes.InfoWindows[0].Width := 200;



  // support UTFGrid Layer see http://www.mapbox.com/developers/utfgrid/

  FUTFLayer := TECNativeUTFLayer.Create(map, 'mapbox.geography', GetUTFTile);

  FUTFLayer.OnMouseOver := doOnOverUTFData;
  FUTFLayer.OnMouseOut := doOnOutUTFData;

  FUTFLayer.Shapes.Zindex := 2;

  // label triangles animated
  FLabelLayer := TecNativeLabelLayer.Create(map, 'labels');
  FLabelLayer.Visible := true;

  ckMiniMapChange(nil);

  // Compensates for the rotation of the map
  // if true the panoramio images appears not rotate even if the map rotate
  // it consumes CPU, it is best not to activate in mobile
  // false by default
  map.RotationPanoramioLayer := true;

  // map.setCenter(43.2332,0.0736);

  map.TileCacheSize := 1024;

  FECMappilaryLayer := TECMapillaryLayer.Create(map, 'mappilary');

  FECMappilaryLayer.LocalCache := map.LocalCache;
  FECMappilaryLayer.OnClick := doMappilaryClick;

  map.XapiLayer.OnClick := doOnXAPIClick;
  map.XapiLayer.OnChange := doOnXAPIChange;
  map.XapiLayer.OnStartSearch := doOnXAPIStartSearch;

  LayerAniIndicator.Visible := false;
  LayerAniIndicator.Enabled := false;

  map.styles.addRule('#_DRAGZOOM_.line {weight:10;color:green;penStyle:dash}');

  map.styles.addRule
    ('#markers.line {bsize:2;bcolor:white;opacity:90;penStyle:dash;}');

  map.styles.addRule('.marker.severity:LowImpact{color:#9BFF28;}' +
    '.marker.severity:Minor{color:#D6FF21;}' +
    '.marker.severity:Moderate{color:#FF8411;}' +
    '.marker.severity:RoadClosed{color:#FF0A16;}' +
    '.marker.severity:Serious{color:black;}');

  // get your key from http://openweathermap.org/appid
  map.OpenWeather.Key := '80feeb4b98aad684474194921cbc7c2f';



  // map.Styles.addRule('#_DRAGZOOM_.line {bsize:2;bcolor:white;opacity:90;penStyle:dash;}');



  // map.styles.addRule('.marker {styleicon:0-17=flat,18-20=direction}');

end;

procedure TFormMegademo.FormDestroy(Sender: TObject);
begin

  FECMappilaryLayer.Free;

  FECOpenWeatherTilesLayer.Free;
  FECDownLoadTiles.Free;

  FMiniMap.Free;
  FECNativeScaleMap.Free;
  FECNativeMeasureMap.Free;
  FUTFLayer.Free;

  FLabelLayer.Free;

  FHeatmapLayer.Free;

  FEditLine.Free;

end;

procedure TFormMegademo.ArcDial1Change(Sender: TObject);
begin
  map.RotationAngle := ArcDial1.Value;

  map.OverSizeForRotation := map.RotationAngle <> 0;

  // map.Group['markers'].Markers[1].Angle :=  round(ArcDial1.Value);

end;

procedure TFormMegademo.ArcDial1DblClick(Sender: TObject);
begin
  ArcDial1.Value := 0;
end;

// =============================================================================




// =========  Maps ======================================================


// select map tiles

procedure TFormMegademo.cbMapsClick(Sender: TObject);
begin
  // use same tileserver than map
  FMiniMap.TileServer := tsNone;

  map.RemoveAllOverlayTiles;

  case cbMaps.ItemIndex of

    0:
      map.TileServer := tsOSM;

    1:
      map.TileServer := tsOpenCycleMap;
    2:
      map.TileServer := tsOPNV;

    3:
      map.TileServer := tsArcGisWorldTopoMap;
    4:
      map.TileServer := tsArcGisWorldStreetMap;
    5:
      begin
        map.TileServer := tsArcGisWorldImagery;
        // use different minimap
        FMiniMap.TileServer := tsArcGisWorldStreetMap;
      end;
    6:
      begin

        map.TileServer := tsArcGisWorldImagery;
        // add overlay tiles for places
        map.AddOverlayTiles(GetArcGisPlacesTile, 'World_Places_Tile');
        // use different minimap
        FMiniMap.TileServer := tsArcGisWorldStreetMap;

      end;

    7:
      begin

        map.TileServer := tsBingRoad;
        FMiniMap.TileServer := tsBingRoad;

      end;

    8:
      begin

        map.TileServer := tsBingAerial;
        FMiniMap.TileServer := tsBingRoad;

      end;

    9:
      begin

        map.TileServer := tsBingAerialLabels;
        FMiniMap.TileServer := tsBingRoad;

      end;
    10:
      begin

        map.TileServer := tsHereNormal;
        FMiniMap.TileServer := tsHereNormal;

      end;
    11:
      begin

        map.TileServer := tsHereTerrain;
        FMiniMap.TileServer := tsHereTerrain;

      end;

    12:
      begin

        map.TileServer := tsHereMobile;
        FMiniMap.TileServer := tsHereMobile;

      end;
    13:
      begin

        map.TileServer := tsHereHiRes;
        FMiniMap.TileServer := tsHereHiRes;

      end;
    14:
      begin

        map.TileServer := tsHereTransit;
        FMiniMap.TileServer := tsHereTransit;

      end;
    15:
      begin

        map.TileServer := tsHereTruck;
        FMiniMap.TileServer := tsHereTruck;

      end;
    16:
      begin

        map.TileServer := tsHereTraffic;
        FMiniMap.TileServer := tsHereTraffic;

      end;

    17:
      begin

        map.TileServer := tsBingAerialLabels;
        map.AddOverlayTileServer(tsHereFlow);
        FMiniMap.TileServer := tsBingRoad;

      end;

    18:
      begin
        map.TileServer := tsHereSatellite;
        FMiniMap.TileServer := tsHereSatellite;

      end;

    19:
      begin
        map.TileServer := tsHereHybrid;
        FMiniMap.TileServer := tsHereHybrid;

      end;

    20:
      begin

        map.TileServer := tsBingAerial;
        map.MaxZoom := 19;

      end;

    21:
      begin
        map.TileServer := tsMapBoxStreets;
        FMiniMap.TileServer := tsMapBoxStreets;

      end;

    22:
      begin
        map.TileServer := tsMapBoxStreetsSatellite;
        FMiniMap.TileServer := tsMapBoxStreetsSatellite;

      end;

    23:
      begin
        map.TileServer := tsMapBoxOutdoors;
        FMiniMap.TileServer := tsMapBoxOutdoors;

      end;

    24:
      begin
        map.TileServer := tsOsmFr;
        FMiniMap.TileServer := tsOsmFr;
      end;

    25:
      begin
        map.TileServer := tsOpenTopoMap;
        FMiniMap.TileServer := tsOpenTopoMap;
      end;

    26:
      begin

        map.TileServer := tsOSM;
        // add overlay tiles for mappilary
        map.AddOverlayTileServer(tsMapillary);

      end;

  end;
  doUpdateCopyrighMap;
end;

procedure TFormMegademo.cbPermaLinkClick(Sender: TObject);
begin
  if cbPermaLink.ItemIndex < 0 then
    exit;

  map.Url := cbPermaLink.Items[cbPermaLink.ItemIndex];
end;

procedure TFormMegademo.GetArcGisPlacesTile(var TileFilename: string;
  const x, y, z: integer);
begin
  TileFilename :=
    format('http://services.arcgisonline.com/ArcGIS/rest/services/Reference/World_Boundaries_and_Places/MapServer/tile/%d/%d/%d.png',
    [z, y, x]);
end;

// load data map
procedure TFormMegademo.LinesDblClick(Sender: TObject);
begin
  if SaveDialog.Execute then
    map.ScreenShot.SaveToFile(SaveDialog.FileName);
end;

procedure Showfullwindow(map: TECNativeMap; infowindow: TECShapeInfoWindow);
var
  pt: TPoint;
  delta: integer;
begin

  // Test left edge

  pt := map.WorldLeftTop;

  delta := infowindow.Left - map.WorldInfo.DeltaWidth * 2;

  if delta < 0 then
  begin
    map.WorldLeftTop := point(pt.x + delta, pt.y);
    pt := map.WorldLeftTop;
  end;

  // Test right edge

  delta := (map.WorldInfo.DeltaWidth * 2 + map.WorldInfo.TrueWidth) -
    (infowindow.Left + infowindow.Width);

  if infowindow.Left + infowindow.Width > map.WorldInfo.DeltaWidth * 2 +
    map.WorldInfo.TrueWidth then
  begin
    map.WorldLeftTop := point(pt.x - delta, pt.y);
    pt := map.WorldLeftTop;
  end;

  // test top edge

  delta := infowindow.Top - map.WorldInfo.DeltaHeight * 2;

  if delta < 0 then
  begin
    map.WorldLeftTop := point(pt.x, pt.y + delta);
    pt := map.WorldLeftTop;
  end;


  // test bottom edge

  delta := (map.WorldInfo.DeltaHeight * 2 + map.WorldInfo.Trueheight) -
    (infowindow.Top + infowindow.height);

  if infowindow.Top + infowindow.height > map.WorldInfo.DeltaHeight * 2 +
    map.WorldInfo.Trueheight then
  begin
    map.WorldLeftTop := point(pt.x, pt.y - delta);
  end;

end;

procedure FilterCafe(const Shape: TECShape; var cancel: Boolean);
begin
  cancel := (Shape.description <> 'cafe');
end;

procedure TFormMegademo.LoadMapClick(Sender: TObject);
begin

  if OpenDialog.Execute then
  begin

    map.LoadFromfile(OpenDialog.FileName);

  end;

end;

// save data map
procedure TFormMegademo.SaveMapClick(Sender: TObject);
begin

  if SaveDialog.Execute then
  begin

    if map.selected.count > 0 then
      map.selected.SaveToFile(SaveDialog.FileName)
    else
      map.SaveToFile(SaveDialog.FileName);

  end;

end;

procedure TFormMegademo.ScaleToZoomChange(Sender: TObject);
begin
  map.ScaleMarkerToZoom := ScaleToZoom.IsChecked;
end;

// CLear
procedure TFormMegademo.ClearMapClick(Sender: TObject);
begin

  FSelectedShape := nil;

  map.clear;

  FLabelLayer.clear;

end;

procedure TFormMegademo.ClusteringChange(Sender: TObject);
begin
  map.Group['markers'].clusterable := Clustering.IsChecked;
end;

// show/hide minimap
procedure TFormMegademo.ckLoupeChange(Sender: TObject);
begin
  FMiniMap.Loupe := ckLoupe.IsChecked;
end;

procedure TFormMegademo.ckMeasureChange(Sender: TObject);
begin
  map.DblClickZoom := not ckMeasure.IsChecked;

  if ckMeasure.IsChecked then
  begin
    btLinesClick(btNone);
    btNone.isPressed := true;
    FECNativeMeasureMap.map := map;
  end
  else
    FECNativeMeasureMap.map := nil;

end;

procedure TFormMegademo.ckMiniMapChange(Sender: TObject);
begin

  if ckMiniMap.IsChecked then
    FMiniMap.map := map
  else
    FMiniMap.map := nil;

  ckLoupe.Visible := ckMiniMap.IsChecked;
end;

procedure TFormMegademo.mapMapSelectRect(Sender: TObject;
  const SWLat, SWLng, NELat, NELng: Double);
begin

end;

// =============================================================================



// ====== support UTFGrid see http://www.mapbox.com/developers/utfgrid/  ======


// connexion utf geography tiles

// http://a.tiles.mapbox.com/v3/mapbox.geography-class/4/7/7.grid.json for see data tile

procedure TFormMegademo.GetUTFTile(var TileFilename: string;
  const x, y, z: integer);
begin
  TileFilename :=
    format('http://%s.tiles.mapbox.com/v3/mapbox.geography-class/%d/%d/%d.grid.json',
    [Char(Ord('a') + random(3)), z, x, y]);
end;

procedure TFormMegademo.HeatmapChange(Sender: TObject);
begin
  FHeatmapLayer.Visible := Heatmap.IsChecked;
  FHeatmapLayer.AutomaticUpdate := true;
  FHeatmapLayer.GroupZIndex := -1;
  FHeatmapLayer.clear;
end;

procedure TFormMegademo.HeatmapOpacityTracking(Sender: TObject);
begin
  FHeatmapLayer.Opacity := round(HeatmapOpacity.Value);
end;

// OnOver country

// FUTFLayer.Data['admin']     country name
// FUTFLayer.Data['flag_png']  country flag png base64 encoded

procedure TFormMegademo.doOnOverUTFData(Sender: TObject);
begin

  if not assigned(FUTFLayer.Shapes.InfoWindows[0]) then
    exit;

  FUTFLayer.Shapes.InfoWindows[0].content := '<img src="data:image/png;base64,'
    + FUTFLayer.Data['flag_png'] + '" width="80" height="40">' + '<h3>' +
    FUTFLayer.Data['admin'] + '</h3>';

  FUTFLayer.Shapes.InfoWindows[0].SetPosition(map.MouseLatLng.Lat,
    map.MouseLatLng.Lng);
  FUTFLayer.Shapes.InfoWindows[0].Visible := true;

end;

procedure TFormMegademo.doOnOutUTFData(Sender: TObject);
begin
  if assigned(FUTFLayer.Shapes.InfoWindows[0]) then

    FUTFLayer.Shapes.InfoWindows[0].Visible := false;
end;

procedure TFormMegademo.UtfGeographyClick(Sender: TObject);
begin
  (*
    if  not UtfGeography.IsChecked then
    begin

    map.Zoom    := 4;
    map.MaxZoom := 8;

    FUTFLayer.Shapes.InfoWindows.Clear;

    FUTFLayer.Shapes.InfoWindows.add(-10,-100,'');
    FUTFLayer.Shapes.InfoWindows[0].zindex := 100;
    FUTFLayer.Shapes.InfoWindows[0].color  := claBeige;
    FUTFLayer.Shapes.InfoWindows[0].Width  := 110;
    FUTFLayer.Shapes.InfoWindows[0].ContentCenter := true;

    FUTFLayer.visible := true;

    end else begin
    FUTFLayer.visible := false;
    map.MaxZoom := 18;
    end;
  *)
end;

// activate/deactivate TECNativeLayer
procedure TFormMegademo.rbNoneClick(Sender: TObject);
begin

  if not(Sender is TRadioButton) then
    exit;

  case TRadioButton(Sender).tag of

    0:
      begin
        map.XapiLayer.Visible := false;
        LayerAniIndicator.Visible := false;
        LayerAniIndicator.Enabled := false;
      end;

    1:
      begin
        map.XapiLayer.Visible := true;
        map.XapiLayer.Junction := false;
        map.XapiLayer.Search := 'restaurant|bar|cafe';

      end;

    2:
      begin

        map.XapiLayer.Visible := true;
        map.XapiLayer.Junction := true;
        map.XapiLayer.Search := 'highway=bus_stop';
        // ;'way[highway=unclassified|road|motorway|trunk|primary|secondary|tertiary|residential]';//'highway=bus_stop'; // 'node[shop=*]';
        // map.XapiLayer.Bound(map.NorthEastLatitude,map.NorthEastLongitude,map.SouthWestLatitude,map.SouthWestLongitude);

      end;

  end;
end;





// =============================================================================

// Manual creation of each point
// Data contains the CSV values for the point
procedure TFormMegademo.doOnCreateCSVPoint(const Group: TECShapes;
  var CSVPoint: TECShape; const Lat, Lng: Double; const Data: TStringList);
var
  M: TECShapeMarker;
  inbr: string;
begin

  // create new marker
  M := Group.addMarker(Lat, Lng);;
  CSVPoint := M;

  // marker design
  M.Width := 12;
  M.StyleIcon := siFlat;

  // we calculate its color according to its index number
  inbr := inttostr(M.IndexOf);
  M.Color := GetHashColor(inbr);

end;


// ============ Adress =========================================================

procedure TFormMegademo.edAdressKeyUp(Sender: TObject; var Key: Word;
  var KeyChar: Char; Shift: TShiftState);
var
  Lat, Lng: Double;
  poi: TECShapePoi;
  anim: TECAnimationFadePoi;
  mrk: TECShapeMarker;
  poly: TECShapePolygone;
  line: TECShapeLine;
  i, j: integer;
  s: string;
begin

  if Key = 13 then
  begin

    if map.GetLatLngFromAddress(edAdress.Text, Lat, Lng) then
    begin
      // 200 meter around you
      // map.fitBoundsRadius(Lat, Lng, 0.2);

      map.setCenter(Lat, Lng);

      poi := map.Group['location'].Pois.Name[edAdress.Text];

      if assigned(poi) then
        exit;

      poi := map.AddPOI(Lat, Lng, 'location');
      poi.Name := edAdress.Text;

      poi.propertyValue['address'] := map.GeoLocalise.SearchResult[0].Address;

      poi.Color := GetHashColor(map.GeoLocalise.SearchResult[0].Address);
      poi.BorderColor := claWhite;
      poi.BorderSize := 3;
      poi.PenStyle := psDash;
      poi.FillOpacity := 60;

      anim := TECAnimationFadePoi.Create;
      anim.MaxSize := 32;
      anim.StartSize := 8;
      poi.animation := anim;

      poi.Group.Pois.Labels.Visible := true;
      poi.Group.Pois.Labels.Margin := 16;

      s := map.GeoLocalise.SearchResult[0].Display_name;
      poi.description := strToken(s, ',');
      poi.Group.Zindex := -1;

      for i := 0 to map.Boundary.Address(edAdress.Text) - 1 do
      begin

        poly := nil;
        line := nil;

        if (map.Boundary.Items[i] is TECShapePolygone) then
          poly := TECShapePolygone(map.Boundary.Items[i])
        else if (map.Boundary.Items[i] is TECShapeLine) then
          line := TECShapeLine(map.Boundary.Items[i]);

        if assigned(poly) then
        begin

          poly.FillColor := poi.Color;
          poly.BorderColor := poi.Color;
          poly.Hint := map.GeoLocalise.SearchResult[0].Display_name;

        end
        else if assigned(line) then
        begin

          line.Color := poi.Color;
          line.Hint := map.GeoLocalise.SearchResult[0].Display_name;

        end
      end;

      map.Boundary.FitBounds;

    end;

  end;

end;

// =============================================================================










// ======== Lines / Polygones ==================================================

procedure TFormMegademo.btLinesClick(Sender: TObject);
begin

  if Sender <> btLines then
    btLines.isPressed := false;

  if Sender <> btPoly then
    btPoly.isPressed := false;

  if Sender <> btNone then
    btNone.isPressed := false;

  Editshape(false);
  FSelectedShape := nil;

  if btLines.isPressed or btPoly.isPressed then

    ckMeasure.IsChecked := false;

end;

// start xapi search
procedure TFormMegademo.doOnXAPIStartSearch(Sender: TObject);
begin
  LayerAniIndicator.Visible := true;
  LayerAniIndicator.Enabled := true;
end;

// end xapi search
procedure TFormMegademo.doOnXAPIChange(Sender: TObject);
begin
  LayerAniIndicator.Visible := false;
  LayerAniIndicator.Enabled := false;

  (*


    map.Group['save'].ToTxt := map.XapiLayer.Shapes.toTxt;

    map.XapiLayer.Visible   := false; *)

end;

procedure TFormMegademo.doOnXAPIClick(Sender: TECShape);
begin
  mapShapeClick(nil, Sender);
end;

procedure TFormMegademo.mapShapeClick(Sender: TObject; const Item: TECShape);
var
  s: string;
  Key, Value: string;

  line: TECShapeLine;
  P0, P1: TECPointLine;
begin

  if (Item is TECShapeLine) and (pos('MeasureMap', Item.Group.Name) <> 0) then
    exit;

  if (Item is TECShapeLine) then
  begin
    line := TECShapeLine(Item);

    if (line.HoverPoint > 0) and (line.HoverPoint < line.count) then
    begin
      P0 := line.Path[line.HoverPoint - 1];
      P1 := line.Path[line.HoverPoint];
      caption := doubletostr(P0.Latitude) + '-' + doubletostr(P1.Latitude)
    end;
  end;



  // list of properties

  s := '';

  s := Item.propertyValue['name'] + '<br>' + Item.description;

  if Item.PropertiesFindFirst(Key, Value) then
  begin
    repeat

      if Key = 'ecshape' then
        continue;

      if length(Key) < 9 then
        Key := Key + '<tab="65">';

      s := s + '<b>' + Key + '</b>: ' + Value + '<br>';

    until Item.PropertiesFindNext(Key, Value);
  end;

  if s <> '' then
  begin

    s := '<h2><tab="47">Properties</h2><br>' + s;

    if map.Shapes.InfoWindows.count = 0 then
    begin

      map.Shapes.InfoWindows.add(Item.Latitude, Item.Longitude, s);

      map.Shapes.InfoWindows[0].Zindex := 100;
      map.Shapes.InfoWindows[0].Width := 200;
    end

    else
    begin

      map.Shapes.InfoWindows[0].content := s;
      map.Shapes.InfoWindows[0].SetPosition(map.MouseLatLng.Lat,
        map.MouseLatLng.Lng); // Item.Latitude, Item.Longitude);
    end;

    map.Shapes.InfoWindows[0].closebutton := true;

    map.Shapes.InfoWindows[0].Visible := true;

    map.Shapes.InfoWindows[0].CenterOnMap;

    // window on top
    map.Shapes.InfoWindows[0].Zindex := map.TopGroupZIndex;

    map.Shapes.InfoWindows[0].Width := 250;
  end;

  if not assigned(Item) or (not Item.isEditable) then
    exit;

  if assigned(FSelectedShape) and (FSelectedShape is TECShapeLine) then
  begin
    TECShapeLine(FSelectedShape).Editable := false;
    TECShapeLine(FSelectedShape).draggable := false;
  end;

  // select Line or Polygone ?
  if (Item is TECShapeLine) and (Item.Group.Name <> 'routes') and
    (Item.isEditable) then
  begin

    // if Item is TECShapePolygone then
    // TECShapePolygone(item).PenStyle := psDash;

    FSelectedShape := Item;

    btNone.isPressed := false;

    if Item is TECShapePolygone then
      btPoly.isPressed := true
    else
      btLines.isPressed := true;

    Editshape(true);

    ckMeasure.IsChecked := false;

  end

  else // no line or polygone

  begin
    FSelectedShape := nil;
    btNone.isPressed := true;
    btPoly.isPressed := false;
    btLines.isPressed := false;
  end;

  if (btNone.isPressed) or (not btLines.isPressed and not btPoly.isPressed) then
  begin

    s := '<img src="' + UrlStaticGoogleStreetView(Item.Latitude, Item.Longitude,
      300, 200) + '"><br><br>' + '<b>Latitude <tab="70">: </b>' +
      DoubleToStrDigit(Item.Latitude, 4) + '<br><b>Longitude <tab="70">: </b>' +
      DoubleToStrDigit(Item.Longitude, 4) + '<br><br>' + map.GeoLocalise.Reverse
      (Item.Latitude, Item.Longitude);

    if map.Zoom < 18 then
    begin
      s := s + '<br><br><a href="#' + inttostr(18) + '/' +
        DoubleToStrDigit(Item.Latitude, 6) + '/' +
        DoubleToStrDigit(Item.Longitude, 6) +
        '"><font hcolor=FF0000 >Zoom To Street</font></a>';
    end;

    OpenInfoWindow(s, Item.Latitude, Item.Longitude);

  end;

end;

procedure TFormMegademo.mapShapeDblClick(Sender: TObject; const Item: TECShape);
begin

  if Item is TECShapeMarker then
  begin

    // item.AlignToRoute;exit;

    if TECShapeMarker(Item).isTrackLineActive then
      TECShapeMarker(Item).TrackLine := nil
    else
      TECShapeMarker(Item).TrackLine.Visible := true;

  end

  else

    if Item is TECShapePoi then

  begin
    if TECShapePoi(Item).isTrackLineActive then
      TECShapePoi(Item).TrackLine := nil
    else
      TECShapePoi(Item).TrackLine.Visible := true;
  end;
end;

procedure TFormMegademo.mapShapeDrag(Sender: TObject; const Item: TECShape;
  var cancel: Boolean);
begin
  // caption := caption+'drag';
end;

procedure TFormMegademo.mapShapeDragEnd(Sender: TObject);
begin
  // caption:=caption+'end';
end;

procedure TFormMegademo.mapShapeMouseDown(Sender: TObject;
  const Item: TECShape);
begin
  // caption:='start';
end;

procedure TFormMegademo.mapShapeMouseOver(Sender: TObject;
  const Item: TECShape);
var
  trueID: integer;
  _lat, _lng: Double;
begin
  exit;
  if Item is TECShapeLine then
  begin
    trueID := TECShapeLine(Item).IndexAndPositionOfNearestPointTo
      (map.MouseLatLng.Lat, map.MouseLatLng.Lng, _lat, _lng);
    caption := inttostr(TECShapeLine(Item).HoverPoint) + '-' + inttostr(trueID);
  end;

end;

procedure SliceLine(const StartKm, EndKm: Double;
  const ParentLine, ChildLine: TECShapeLine); overload;
var
  i, j, M: integer;
  p: TECPointLine;
  StartIndex, EndIndex: integer;
  lat1, lng1, lat2, lng2: Double;
  Heading: integer;
  bEnd: Boolean;
begin
  if not assigned(ChildLine) then
    exit;

  M := ParentLine.count - 1;

  if not ParentLine.getLatLngFromMeter(true, round(StartKm * 1000), lat1, lng1,
    StartIndex, Heading, bEnd) then
    exit;
  if not ParentLine.getLatLngFromMeter(true, round(EndKm * 1000), lat2, lng2,
    EndIndex, Heading, bEnd) then
    exit;

  inc(StartIndex);
  inc(EndIndex);

  if (StartIndex < 0) or (StartIndex > M) or (EndIndex < 0) or (EndIndex > M)
  then
    exit;

  ChildLine.BeginUpdate;
  ChildLine.clear;

  i := StartIndex;
  j := EndIndex;

  ChildLine.add(lat1, lng1);

  while i <= j do
  begin
    p := ParentLine.Path[i];

    ChildLine.add(p.Lat, p.Lng);

    inc(i);
  end;

  ChildLine.add(lat2, lng2);

  ChildLine.EndUpdate;

end;

procedure SliceLine(const StartIndex, EndIndex: integer;
  const ParentLine, ChildLine: TECShapeLine); overload;
var
  i, j, M: integer;
  p: TECPointLine;
begin
  if not assigned(ChildLine) then
    exit;

  M := ParentLine.count - 1;

  if (StartIndex < 0) or (StartIndex > M) or (EndIndex < 0) or (EndIndex > M)
  then
    exit;

  ChildLine.BeginUpdate;
  ChildLine.clear;

  i := StartIndex;
  j := EndIndex;

  while i <= j do
  begin
    p := ParentLine.Path[i];

    ChildLine.add(p.Lat, p.Lng);

    inc(i);
  end;

  ChildLine.EndUpdate;
end;

procedure TFormMegademo.doSelectLine(Sender: TObject);
begin

  if FEditLine.line is TECShapePolygone then

    FEditLine.SelectionTo(FSelectionPoly)

  else

    FEditLine.SelectionTo(FSelectionLine);

  // caption := inttostr(FEditLine.Count)+'-'+doubleToStr(FEditLine.Selection[0].Latitude);

  FSelectionPoly.Color := claRed;
  // FSelectionLine.Weight := 10;

  (* FEDitLine.SelectionToLine(FSelectionLine);

    //caption := inttostr(FEditLine.Count)+'-'+doubleToStr(FEditLine.Selection[0].Latitude); *)

  FSelectionLine.Color := claRed;
  FSelectionLine.Weight := 10;

end;

procedure TFormMegademo.doDeSelectLine(Sender: TObject);
begin
  FSelectionLine.clear;
  FSelectionPoly.clear;
end;

// right click on line or polygon => select partial zone
procedure TFormMegademo.mapShapeRightClick(Sender: TObject;
  const Item: TECShape);
begin

  if (Item is TECShapeLine) or (Item is TECShapePolygone) then
  begin

    if not assigned(FEditLine) then
    begin
      FEditLine := TecNativeLineSelect.Create;
      FEditLine.OnSelect := doSelectLine;
      FEditLine.OnDeselect := doDeSelectLine;
      FSelectionLine := map.AddLine(-10, -10);
      FSelectionPoly := map.AddPolygone(-10, -10);
    end;

    FEditLine.line := TECShapeLine(Item);

  end;

end;

// call by clickink on link "Zoom to street" in InfoWindow
// close InfoWindow if exists
procedure TFormMegademo.mapBeforeUrl(Sender: TObject; var Url: string);
begin
  if (FInfoWindowShapes.InfoWindows.count > 0) then
    FInfoWindowShapes.InfoWindows[0].Visible := false;
end;

procedure TFormMegademo.mapClusterClick(Sender: TObject;
  const Cluster: TECCluster);
var
  L: TList<TECShape>;
begin

  L := TList<TECShape>.Create;

  map.FindShapeByArea(Cluster.LatSW, Cluster.LngSW, Cluster.LatNE,
    Cluster.LngNE, L);

  L.Free;

end;

procedure TFormMegademo.mapKeyUp(Sender: TObject; var Key: Word;
  var KeyChar: Char; Shift: TShiftState);
var
  p: TPoint;
begin
  p := map.WorldLeftTop;

  case Key of
    37:
      map.WorldLeftTop := point(p.x - 40, p.y);
    38:
      map.WorldLeftTop := point(p.x, p.y - 40);
    39:
      map.WorldLeftTop := point(p.x + 40, p.y);
    40:
      map.WorldLeftTop := point(p.x, p.y + 40);
  end;

end;

procedure TFormMegademo.mapLoad(Sender: TObject; const GroupName: string;
  const FinishLoading: Boolean);
Begin
  if assigned(Sender) and (Sender is TECShapes) and (GroupName = '') then
  begin
    // caption := inttostr(TECShapes(Sender).count);
    TECShapes(Sender).FitBounds;
    // map.Shapes.Polygones[map.Shapes.Polygones.Count-1].Weight:=60;
  end;
end;

procedure TFormMegademo.mapMapClick(Sender: TObject; const Lat, Lng: Double);
begin

  map.Shapes.Polygones.OnAfterDraw := doDrawHint;

  if not assigned(FSelectedShape) then
  begin

    if btPoly.isPressed then
    begin
      FSelectedShape := map.add(nsPolygon, Lat, Lng);

      // change défault point
      TECShapePolygone(FSelectedShape).OnCreateShapeLinePoint :=
        doCreateShapeLinePointEditable;
    end

    else

      if btLines.isPressed then
    begin
      FSelectedShape := map.add(nsLine, Lat, Lng);

      // change défault point
      TECShapeLine(FSelectedShape).OnCreateShapeLinePoint :=
        doCreateShapeLinePointEditable;
    end;

    if not assigned(FSelectedShape) then
      exit;

    FSelectedShape.Color := GetRandomColor;
    FSelectedShape.HoverColor := FSelectedShape.Color;
    // GetHighlightColorBy(FSelectedShape.color, 32);
    TECShapePolygone(FSelectedShape).HoverBorderColor := FSelectedShape.Color;

    if btPoly.isPressed then
    begin
      TECShapePolygone(FSelectedShape).FillColor :=
        GetshadowColorBy(FSelectedShape.Color, 64);

      FSelectedShape.Hint := 'polygone ' + inttostr(FSelectedShape.IndexOf);
    end;

    FLabelLayer.add(FSelectedShape);

    Editshape(true);

  end
  else
  begin

    // if not key CTRL then add point
    if not(KeyIsDown(vkcontrol)) then
    begin

      if btPoly.isPressed then
      begin
        TECShapePolygone(FSelectedShape).add(Lat, Lng);
      end
      else
        TECShapeLine(FSelectedShape).add(Lat, Lng);

    end

    else // if CTRL Pressed then move Shape

      FSelectedShape.SetPosition(Lat, Lng);

  end;

end;

procedure TFormMegademo.mapMapDblClick(Sender: TObject; const Lat, Lng: Double);
begin

  if ckMeasure.IsChecked and btNone.isPressed then
  begin
    FECNativeMeasureMap.PenStyle := psDash;
    FECNativeMeasureMap.StartMeasure(Lat, Lng);
  end;

end;

procedure TFormMegademo.mapMapMouseMove(Sender: TObject;
  const Lat, Lng: Double);
begin
  if Heatmap.IsChecked then
    FHeatmapLayer.add(Lat, Lng);
end;

// redefine the creation selection points for lines and polygones
procedure TFormMegademo.doCreateShapeLinePointEditable(Sender: TObject;
  const Group: TECShapes; var ShapeLinePoint: TECShape; const Lat, Lng: Double;
  const index: integer);
var
  i: integer;
  poi: TECShapePoi;
begin

  i := Group.Pois.add(Lat, Lng);
  poi := Group.Pois[i];

  ShapeLinePoint := poi;

  if index > 0 then
  begin

    poi.POIShape := poiEllipse;
    poi.Width := 14;
    poi.height := 14;

  end

  else

  begin
    poi.POIShape := poiRect;
    poi.Width := 14;
    poi.height := 14;
  end;

  poi.Color := TECShapeLine(Sender).HoverColor;
  poi.HoverColor := TECShapeLine(Sender).HoverBorderColor;
  poi.BorderColor := TECShapeLine(Sender).Color;
  poi.HoverBorderColor := TECShapeLine(Sender).Color;

  // first and last point in Black
  if (index = 0) or (index = TECShapeLine(Sender).count - 1) then
    poi.Color := claBlack;

end;

procedure TFormMegademo.Editshape(const Value: Boolean);
begin

  pnInfo.Visible := false;

  if not assigned(FSelectedShape) then
    exit;

  if FSelectedShape is TECShapePolygone then
  begin
    TECShapePolygone(FSelectedShape).Editable := Value;
    TECShapePolygone(FSelectedShape).draggable := Value;
  end
  else if FSelectedShape is TECShapeLine then
  begin
    TECShapeLine(FSelectedShape).Editable := Value;
    TECShapeLine(FSelectedShape).draggable := Value;

  end
  else
    exit;

  if Value then
  begin

    pnInfo.Visible := true;

    TECShapeLine(FSelectedShape).OnShapePathChange := doPathChange;

    // update infos perimeter / area
    doPathChange(FSelectedShape);

  end;

end;

procedure TFormMegademo.doSelectedChange(Sender: TObject);
var
  // Item: TECShape;
  i: integer;
begin

  map.selected.OnChange := nil;

  // for item in map.Selected do
  // item.Selected := item is TECShapePOI;

  for i := 0 to map.selected.count - 1 do
    map.selected[i].selected := map.selected[i] is TECShapePoi;

  map.selected.OnChange := doSelectedChange;

end;

procedure TFormMegademo.doPathChange(Sender: TObject);
begin

  if Sender is TECShapePolygone then
  begin

    lbInfosize.Text := 'Perimeter : ' + DoubleToStrDigit
      (TECShapePolygone(Sender).Distance, 4) + ' Km '#13#10'Area : ' +
      DoubleToStrDigit(TECShapePolygone(Sender).Area, 4) + ' Km²';

    TECShapePolygone(Sender).description := 'Perimeter : ' +
      DoubleToStrDigit(TECShapePolygone(Sender).Distance, 4) + ' Km <br>Area : '
      + DoubleToStrDigit(TECShapePolygone(Sender).Area, 4) + ' Km²'
  end

  else

    if Sender is TECShapeLine then

    lbInfosize.Text := 'Distance : ' + DoubleToStrDigit
      (TECShapeLine(Sender).Distance, 4) + ' Km';

end;

// ============================================================================



// ================= ROUTE =====================================================


// add route

// the calculation is done in a background thread
// OnRoutePath event is triggered when finished
procedure TFormMegademo.AddLinkClick(Sender: TObject);
begin
  cbPermaLink.Items.add(map.Url);

  // map.Shapes.Polygones[0].description := map.Url;
  // map.invalidate;

end;

procedure TFormMegademo.AddRouteClick(Sender: TObject);
begin

  case engine.ItemIndex of
    0:
      map.Routing.engine(reMapBox);
    1:
      map.Routing.engine(reMapQuest);
    // ! USE YOUR KEY !
    2:
      map.Routing.engine(reMapZen, 'valhalla-SSzliI4');
    3:
      map.Routing.engine(reOSRM);
  end;

  map.Routing.GroupName := 'routing';

  map.Routing.Request(RouteStart.Text, RouteEnd.Text);

end;

// route is ok
//
// a triangle is added to simulate a vehicle which moves
procedure TFormMegademo.doOnAddRoute(Sender: TECShapeLine;
  const params: string);
var
  moving: TECAnimationMoveOnPath;
  i: integer;
  iw: TECShapeInfoWindow;

begin

  Sender.Color := GetRandomColor;

  InfoRoute.Text := 'Distance : ' + DoubleToStrDigit(Sender.Distance,
    2) + ' km';

  // create triangle
  i := map.Shapes.Pois.add(0, 0);
  map.Shapes.Pois[i].POIShape := poiTriangle;
  map.Shapes.Pois[i].Width := 18;
  map.Shapes.Pois[i].height := 18;

  map.Shapes.Pois[i].Color := GetshadowColorBy(Sender.Color, 32);

  // move on line
  // start km 0
  // speed at 50 + random(5)*10  km/h
  moving := TECAnimationMoveOnPath.Create(Sender, 0, 50 + random(5) * 10);

  // directing the tip of the triangle in the direction of travel
  moving.Heading := true;

  // moving will be automatically deleted
  map.Shapes.Pois[i].animation := moving;

  // create InfoWindow and keep is index
  // used when the shape reaches the end of road see  doEndAnimationMove
  map.Shapes.Pois[i].tag := FInfoWindowShapes.InfoWindows.add(-10, -10, '');

  // setup infowindow
  iw := FInfoWindowShapes.InfoWindows[map.Shapes.Pois[i].tag];

  iw.closebutton := false;
  iw.ContentCenter := true;

  iw.Color := claBeige;
  iw.Style := iwsRectangle;

  // infowindow on top of all shapes
  iw.Zindex := map.TopGroupZIndex;

  // fired when arrived at end (or at start)
  moving.OnDriveUp := doEndAnimationMove;
  // run animation
  moving.stop := false;

  // to adjust the hint with every movement
  map.Shapes.Pois[i].OnShapeMove := doOnMoveTriangle;
  // on/off auto tracking
  map.Shapes.Pois[i].OnShapeClick := doOnClickTriangle;

  OnOffTracking(map.Shapes.Pois[i]);

  map.Shapes.Pois[i].Zindex := map.TopGroupZIndex;



  // map.OverSizeForRotation := true;

end;

procedure TFormMegademo.doOnChangeRoute(Sender: TECShapeLine;
  const params: string);
begin
  InfoRoute.Text := 'Distance : ' + DoubleToStrDigit(Sender.Distance,
    2) + ' Km';
end;

// fired when click triangle
// activate / deactivate auto tracking
procedure TFormMegademo.doOnClickTriangle(Sender: TObject;
  const Item: TECShape);
begin
  OnOffTracking(Item);
end;

// activate / deactivate auto tracking
procedure TFormMegademo.OnOffTracking(const Item: TECShape);
var
  ShapePOI: TECShapePoi;
  anim: TECAnimationFadePoi;
begin

  if map.Group['tracking'].Pois.count = 0 then
  begin

    map.Group['tracking'].Zindex := 100;

    map.Group['tracking'].Pois.add(Item.Latitude, Item.Longitude);

    ShapePOI := map.Group['tracking'].Pois[0];

    ShapePOI.Width := 48;
    ShapePOI.height := 48;

    ShapePOI.Color := claLightBlue;

    ShapePOI.BorderColor := claWhite;
    ShapePOI.BorderSize := 4;

    ShapePOI.POIShape := poiEllipse;

    ShapePOI.Clickable := false;

    anim := TECAnimationFadePoi.Create;

    anim.MaxSize := 48;
    anim.StartSize := 12;

    anim.StartOpacity := 80;

    ShapePOI.animation := anim;

  end

  else

    ShapePOI := map.Group['tracking'].Pois[0];

  // stop tracking, back north up
  if assigned(ShapePOI.Item) and (ShapePOI.Item = Item) then
  begin
    ShapePOI.Item := nil;

    // use AnimRotationAngleTo for smoother Animation

    map.AnimRotationAngleTo(0);

  end

  else // track item

    ShapePOI.Item := Item;

  ShapePOI.Visible := ShapePOI.Item <> nil;

  if not ShapePOI.Visible then
    map.RotationAngle := 0;

  Item.setFocus;

end;

// fired when triangle move
procedure TFormMegademo.doOnMoveTriangle(Sender: TObject; const Item: TECShape;
  var cancel: Boolean);
begin
  if assigned(Item) then
  begin

    if map.Group['tracking'].Pois.count = 1 then
    begin
      // tracking actif
      if (map.Group['tracking'].Pois[0].Item = Item) then
      begin

        // the map is rotated to be in the direction of travel
        // item.angle is automatically updated with the direction angle by TECAnimationMoveOnPath

        // To calculate the angle : angle := - map.Bearing( oldLat,OldLng,NewLat,NewLng )

        // AnimRotationAngleTo for smoother Animation

        map.AnimRotationAngleTo(Item.Angle);

        map.Group['tracking'].Pois[0].SetPosition(Item.Latitude,
          Item.Longitude);

        // if not map.ContainsLatLng(item.latitude,item.longitude) then ///
        // if not item.ShowOnMap then
        map.setCenter(Item.Latitude, Item.Longitude);

        map.OverSizeForRotation := map.RotationAngle <> 0;

      end;
    end;

    // only display position information if the map has not suffered rotation
    if assigned(Item.Item) then

      TECShapeInfoWindow(Item.Item).Visible := map.RotationAngle = 0;

  end;
end;

// fired when the triangle reaches the end of road
procedure TFormMegademo.doEndAnimationMove(Sender: TObject);
var
  iw: TECShapeInfoWindow;
begin

  // we got it reverses direction
  TECAnimationMoveOnPath(TECShape(Sender).animation).ComeBack :=
    not TECAnimationMoveOnPath(TECShape(Sender).animation).ComeBack;
  TECAnimationMoveOnPath(TECShape(Sender).animation).stop := false;


  // show infowindow

  iw := FInfoWindowShapes.InfoWindows[TECShape(Sender).tag];

  iw.SetPosition(TECShape(Sender).Latitude, TECShape(Sender).Longitude);

  // InfoWindow Content can interpret basic html commands
  iw.content :=
    '<img src="http://www.helpandweb.com/icon-damier.png" width=42 height=21> <b>Arrived !</b>';

  iw.Visible := true;

  // The release of the animation is automatically
  iw.animation := TECAnimationAutoHide.Create;

  // auto hide infowindow after 2s
  TECAnimationAutoHide(iw.animation).MaxTiming := 2000;
end;




// =============================================================================






// ====================== Panoramio ============================================

procedure TFormMegademo.ckPanoramioClick(Sender: TObject);
begin
  map.PanoramioLayer := not ckPanoramio.IsChecked;
end;

// Event Click on panoramio photo
procedure TFormMegademo.mapPanoramioClick(Sender: TObject; const Item: TECShape;
  const ownerId, ownerName, PhotoId, PhotoDate, PhotoTitle, PhotoUrl,
  copyright: string);
var
  s: string;
begin

  s := '<img src="' + PanoramioPhotoUrlSize(PhotoUrl, pimSmall) + '" ><br><h3>'
    + PhotoTitle + '</h3>';

  OpenInfoWindow(s, Item.Latitude, Item.Longitude);

end;

procedure TFormMegademo.mappilaryChange(Sender: TObject);
begin
  FECMappilaryLayer.Visible := Mappilary.IsChecked;
end;

procedure TFormMegademo.doMappilaryClick(Layer: TECMapillaryLayer;
  Item: TECShape; MappilarySequence: TMapillarySequence; PhotoIndex: integer);
var
  FileName, content: string;
  Lat, Lng: Double;
begin

  FileName := (MappilarySequence.Images[PhotoIndex].Url256);

  Lat := MappilarySequence.Images[PhotoIndex].Lat;
  Lng := MappilarySequence.Images[PhotoIndex].Lng;

  if fileExists(FileName) then
  begin
    content := '<img src="' + FileName + '"><br><br>';
  end
  else
    content := '<img src="' + MappilarySequence.Images[PhotoIndex].Url256 +
      '"><br><br>';

  content := '<h1><font color=' + copy(ColorToHtml(Item.Color), 2, 10) +
    '>Mappilary</font></h1><br><br>' + content + '<br>' + '<b>Lat : </b>' +
    doubletostr(Lat) + ' - ' + '<b>Lng : </b>' + doubletostr(Lng) + '<br>';

  FECMappilaryLayer.OpenWindow(Lat, Lng, content);

end;

// =============================================================================







// ==================== MARKERS ================================================

// Add default marker
procedure TFormMegademo.DefaultMarkerClick(Sender: TObject);
var
  mrk: TECShapeMarker;
begin

  mrk := map.addMarker(map.Latitude, map.Longitude, 'markers');

  // the marker does not follow the rotation of the map
  mrk.Rotation := false;

  mrk.draggable := true;

  mrk.DelayHint := 4000;

  if FGoogleMarker then
  begin

    // 'http://maps.google.com/mapfiles/ms/icons/red-dot.png';
    mrk.FileName := 'data:image/png;base64,iVBORw0KGgoAAA' +
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

    (*
      mrk.StyleIcon := siSVG;
      mrk.filename := 'M34.856,34.773V5.762h-7.939v29.012h-2.645V13.447h-7.938v21.326h-2.312V19.379H6.084v15.395H2.916V1.068H0v33.705v2.916'+
      'h1.642c0.425,0,0.85,0,1.274,0c11.353,0,22.706,0,34.061,0h1.781v-2.916H34.856z';
    *)

    mrk.StyleIcon := siSVG;

    case random(4) of
      0:
        mrk.FileName := SVG_PIN_HOLE;
      1:
        mrk.FileName := SVG_PIN;
      2:
        mrk.FileName := SVG_ROUND_PIN_HOLE;
    else
      mrk.FileName := SVG_ROUND_PIN;
    end;

    // mrk.Rotation := true;

    mrk.Width := 32;
    mrk.height := 32;

    mrk.YAnchor := 32;

    // mrk.Fov := 40;
    // mrk.FovRadius := 33;
    // mrk.FovAngle  := 90;

    // mrk.setHitBox(10,10,20,50);

  end
  else
  begin

    case random(4) of
      0:
        mrk.StyleIcon := si3D;
      1:
        mrk.StyleIcon := siFlat;
      2:
        mrk.StyleIcon := siFlatNoBorder;
      3:
        mrk.StyleIcon := siDirection;
    end;

    mrk.Angle := random(360);

    mrk.Width := 12;

    mrk.Color := GetRandomColor;
    mrk.HoverColor := GetHighlightColorBy(mrk.Color, 64);

    // 20 flashing ,  TECAnimationShapeColor is is automatically released
    // mrk.animation := TECAnimationShapeColor.create(20);
  end;

  mrk.Hint := 'Lat : ' + DoubleToStrDigit(mrk.Latitude, 4) + #13#10 + 'Lng : ' +
    DoubleToStrDigit(mrk.Longitude, 4);

  mrk.Color := GetRandomPastelColor;

  mrk.OnAfterDraw := doAfterDraw;

  // trak move for update hint
  mrk.OnShapeMove := doOnShapeMove;

  FGoogleMarker := not FGoogleMarker;

  mrk.TrackLine.Visible := FGoogleMarker;

end;

// fired when default, images and Pois markers move
procedure TFormMegademo.doOnShapeMove(Sender: TObject; const Item: TECShape;
  var cancel: Boolean);
begin
  if not assigned(Item) then
    exit;
  // update hint info position
  Item.Hint := 'Lat : ' + DoubleToStrDigit(Item.Latitude, 4) + #13#10 + 'Lng : '
    + DoubleToStrDigit(Item.Longitude, 4);
end;

// add image marker
procedure TFormMegademo.MarkerImageClick(Sender: TObject);
var
  Direction: integer;
  animD: TECAnimationMoveToDirection;
  ShapePOI: TECShapePoi;
  ShapeMarker: TECShapeMarker;
  SpeedKMh: integer;

var
  is_triangle: Boolean;
begin

  // Optimization, call BeginUpdate before adding elements
  map.BeginUpdate;

  is_triangle := random(2) = 0;

  // Create 360 markers that will move in their own direction
  for Direction := 0 to 359 do
  begin

    if is_triangle then
    begin
      ShapePOI := map.AddPOI(map.Latitude, map.Longitude, 'rot360');

      ShapePOI.POIShape := FMX.uecMapUtil.poiArrowHead;
      // fmx.uecmaputil.poiTriangle;

      ShapePOI.Width := 18;
      ShapePOI.height := 24;

      ShapePOI.Color := GetRandomPastelColor;
      // RGB(random(255),random(255),random(255))   ;
      ShapePOI.BorderColor := GetshadowColorBy(ShapePOI.Color, 32);

      // speed between 30 and 130 km / h
      SpeedKMh := 30 + random(100);

      // create animation
      animD := TECAnimationMoveToDirection.Create(SpeedKMh, Direction * 10);

      // there is no need to destroy the animation,
      // this is done automatically when the item is destroyed
      // or when you assign a new animation
      ShapePOI.animation := animD;
    end

    else
    begin

      ShapeMarker := map.addMarker(map.Latitude, map.Longitude, 'rot360');
      ShapeMarker.FileName := 'http://www.helpandweb.com/arrow2.png';
      SpeedKMh := 30 + random(100);

      // create animation
      animD := TECAnimationMoveToDirection.Create(SpeedKMh, Direction);
      ShapeMarker.animation := animD;

      ShapeMarker.draggable := true;

      // ShapeMarker.Rotation := true;

      ShapeMarker.OnShapeMove := doOnShapeMove;
    end;

    // the triangle points in the direction
    animD.Heading := true;

    // start move
    animD.Start;

  end;

  // We can now allow the map to be updated

  map.EndUpdate;

end;

procedure TFormMegademo.doAfterDraw(const canvas: TECCanvas; var Rect: TRect;
  Item: TECShape);
var
  size_start: integer;
begin
  if assigned(Item) and (Item.selected) then
  begin
    size_start := (Item.Width div 2);
    if size_start < 10 then
      size_start := 10;

    canvas.Pen.Color := claBlack;
    canvas.PenWidth(1);
    canvas.Brush.Color := GetHighlightColorBy(claRed, 16);
    Rect.Left := Rect.Left + (Rect.Right - Rect.Left) - size_start;
    Rect.Top := Rect.Top - (size_start div 2);
    Rect.Bottom := Rect.Top + size_start;
    canvas.DrawStar(Rect);
  end;
end;



// add POI

procedure TFormMegademo.MarkerPOIClick(Sender: TObject);
var
  i: integer;
  c: TAlphaColor;
  ShapePOI: TECShapePoi;
  anim: TECAnimationFadePoi;
  animD: TECAnimationMoveToDirection;
begin

  map.BeginUpdate;

  map.Group['pois'].Zindex := 100;

  map.Group['pois'].DelayHint := 1000;

  i := map.Group['pois'].Pois.add(map.Latitude, map.Longitude);

  ShapePOI := map.Group['pois'].Pois[i];

  ShapePOI.OnAfterDraw := doAfterDraw; // doNumDrawPOI;//doAfterDraw;

  // Compensates for the rotation of the map
  // if true the element appears not rotate even if the map rotate
  ShapePOI.Rotation := true;

  ShapePOI.Width := 24;
  ShapePOI.height := 24;

  ShapePOI.Hint := 'Poi n°' + inttostr(i);

  ShapePOI.draggable := true;

  // shapepoi.EnabledHint := false;

  // map.shapes.pois[i].Opacity := 50;

  i := random(11);
  c := GetRandomColor;

  ShapePOI.Color := c;

  case i of
    0:
      begin
        ShapePOI.POIShape := poiEllipse;
        ShapePOI.BorderSize := 4;
        ShapePOI.BorderColor := claWhite;
      end;
    1:
      begin
        ShapePOI.POIShape := poiStar;
        ShapePOI.description := 'cafe';
      end;
    2:
      ShapePOI.POIShape := poiRect;
    3:
      ShapePOI.POIShape := poiTriangle;
    4:
      begin
        ShapePOI.POIShape := poiText;

        ShapePOI.OnShapeFont := doFontPOI;
        // fix font size see doFontPOI
        ShapePOI.tag := 10 + random(10);
        //
        if ShapePOI.tag > 12 then
        begin
          // with = 0 => 1 line auto calc with
          ShapePOI.Width := 0;

        end
        else
        begin
          // multi line
          ShapePOI.Width := 50;
          ShapePOI.height := 40;
        end;

        ShapePOI.description := 'Multi line ' + ShapePOI.Hint;
        // ShapePOI.EnabledHint := false;
      end;
    5:
      ShapePOI.POIShape := poiHexagon;
    6:
      ShapePOI.POIShape := poiDiamond;
    7:
      ShapePOI.POIShape := poiArrow;
    8:
      ShapePOI.POIShape := poiArrowHead;
    9:
      ShapePOI.POIShape := poiCross;
    10:
      ShapePOI.POIShape := poiDiagCross;
  end;

  // ShapePOI.angle := random(360);


  // ShapePOI.POIShape := poiOwnerDraw;

  if (ShapePOI.POIShape <> poiOwnerDraw) and (ShapePOI.POIShape <> poiText) then
  begin
    // trak move for update hint
    ShapePOI.OnShapeMove := doOnShapeMove;

    ShapePOI.Hint := ' Lat <tab="24">: <b>' +
      DoubleToStrDigit(ShapePOI.Latitude, 4) + '</b><br>' +
      'Lng <tab="20">: <b>' + DoubleToStrDigit(ShapePOI.Longitude, 4) + '</b>';


    // anim

    if (ShapePOI.POIShape = poiTriangle) then
    begin
      animD := TECAnimationMoveToDirection.Create(30 + random(90), random(360));

      ShapePOI.animation := animD;
      animD.Heading := true;
      animD.Start;

    end

    else

      if (random(2) = 0) then
    begin

      anim := TECAnimationFadePoi.Create;
      anim.MaxSize := 32;
      anim.StartSize := 8;

      anim.StartOpacity := 90;

      ShapePOI.animation := anim;

    end;
  end;

  map.EndUpdate;

end;

// draw number on shape
procedure TFormMegademo.doNumDrawPOI(const canvas: TECCanvas; var r: TRect;
  Item: TECShape);
var
  x, y, w, h: integer;
  s: string;
begin

  // don't draw nomber on animated shape

  if assigned(Item.animation) then
    exit;

  canvas.font.Style := [TFontStyle.fsBold];

  s := inttostr(Item.Id);

  w := canvas.TextWidth(s);
  h := canvas.TextHeight(s);

  // r.right  := r.left + w + 5;
  // r.bottom := r.Top  + h + 5;

  x := ((r.Left + r.Right) - w) DIV 2;
  y := ((r.Top + r.Bottom) - h) DIV 2;
  (*
    canvas.Brush.Color := claBlack;
    canvas.FillRectangle(r); *)
  canvas.fontcolor := claWhite;

  canvas.Angle := round(map.RotationAngle);
  // canvas.TextOut(x,y,s);

  canvas.TextRect(r, x, y, s);
end;

procedure TFormMegademo.doDrawHint(const canvas: TECCanvas; var r: TRect;
  Item: TECShape);
var
  x, y, w, h: integer;
  s: string;
  centroid: TLatLng;
begin



  // don't draw nomber on animated shape

  if assigned(Item.animation) then
    exit;

  canvas.font.Style := [TFontStyle.fsBold];

  canvas.Angle := round(map.RotationAngle);

  s := Item.Hint;

  w := canvas.TextWidth(s);
  h := canvas.TextHeight(s);

  canvas.fontcolor := claWhite;

  x := 1 + ((r.Left + r.Right) - w) DIV 2;
  y := 1 + ((r.Top + r.Bottom) - h) DIV 2;

  centroid := TECShapePolygone(Item).centroid;

  map.WorldInfo.LatLngToXY(centroid.Lat, centroid.Lng, x, y);

  if canvas.Angle = 0 then
  begin
    x := x - (w div 2);
    y := y - (h div 2);
  end;


  // canvas.TextOut(x,y,s);

  canvas.TextHTML(Item.description, x, y);

  // canvas.TextRect(r, x, y, s);

  (* x := 1 + ((r.Left + r.Right) - w) DIV 2;
    y := 1 + ((r.Top + r.Bottom) - h) DIV 2;



    canvas.TextRect(r, x, y, s); *)
end;

procedure TFormMegademo.doFontPOI(const canvas: TECCanvas; Item: TECShape);
begin
  canvas.font.Size := Item.tag;
end;

// owner draw poi, here transparancy text
procedure TFormMegademo.doOwnerDrawPOI(const canvas: TECCanvas; var Rect: TRect;
  Item: TECShape);
var
  x, y, radius, diff: integer;

  Scale: Double;
begin

  if Item.Hover then
    canvas.fontcolor := Item.HoverColor
  else
    canvas.fontcolor := Item.Color;

  canvas.font.Style := [TFontStyle.fsBold];

  if Item.Width = 0 then
    Item.Width := canvas.TextWidth(Item.description) + 20;

  if map.ScaleMarkerToZoom then
  begin

    // map.OnGetScale(item,scale);

    Scale := Item.Scale;

    if Scale = 0 then
      Scale := 1;

    Scale := Scale * (map.Zoom / map.MaxZoom);
    // (item.World.Zoom / item.World.MaxZoom);
  end
  else
    Scale := 1;

  radius := round((Item.height div 2) * Scale);

  diff := round(radius - (sin(45) * radius));

  canvas.Polygon([point(Rect.Left + (Rect.Width div 2), Rect.Top),

    point(Rect.Right - diff, Rect.Bottom - diff),

    point(Rect.Left + (Rect.Width div 2), Rect.Bottom - (Rect.height div 3)),

    point(Rect.Left + diff, Rect.Bottom - diff)]);

  canvas.Pen.Color := Item.Color;

  canvas.FillOpacity := 0;

  x := Rect.Left + (Rect.Width div 2);

  y := Rect.Top + (Rect.height div 2);

  canvas.Ellipse(x - radius, y - radius, x + radius, y + radius);

end;


// =============================================================================




// =========== InfoWindow ======================================================

procedure TFormMegademo.OpenInfoWindow(const content: string;
  const Latitude, Longitude: single);
begin

  Editshape(false);

  if FInfoWindowShapes.InfoWindows.count = 0 then
  begin
    FInfoWindowShapes.InfoWindows.add(Latitude, Longitude, content);
    FInfoWindowShapes.InfoWindows[0].Zindex := 100;
  end

  else

  begin
    FInfoWindowShapes.InfoWindows[0].content := content;
    FInfoWindowShapes.InfoWindows[0].SetPosition(Latitude, Longitude);
  end;

  FInfoWindowShapes.InfoWindows[0].closebutton := true;
  FInfoWindowShapes.InfoWindows[0].Visible := true;

  FInfoWindowShapes.InfoWindows[0].CenterOnMap;

  // window on top
  FInfoWindowShapes.Zindex := map.TopGroupZIndex;

end;



// =============================================================================

procedure TFormMegademo.TrafficClick(Sender: TObject);
begin
  map.TrafficLayer := not Traffic.IsChecked;
end;

end.
