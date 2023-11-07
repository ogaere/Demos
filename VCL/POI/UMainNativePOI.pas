unit UMainNativePOI;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  uecGraphics,
  Dialogs, ExtCtrls, ComCtrls, StdCtrls, uecmaputil, uecNativeMapControl,
  uecNativeShape;

type
  TFormNativePoi = class(TForm)
    Panel1: TPanel;
    AddPois: TButton;
    PoiNumber: TPanel;
    infos: TPanel;
    fitbounds: TButton;
    Label1: TLabel;
    clustering: TCheckBox;
    MoveDirection360: TButton;
    cbClusterStyle: TComboBox;
    Label2: TLabel;
    map: TECNativeMap;
    GroupBox1: TGroupBox;
    rbAscending: TRadioButton;
    rbDescending: TRadioButton;
    rbNone: TRadioButton;

    procedure AddPoisClick(Sender: TObject);

    procedure FormCreate(Sender: TObject);
    procedure mapShapeClick(Sender: TObject; const item: TECShape);

    procedure mapShapeDragEnd(Sender: TObject);
    procedure mapShapeDblClick(Sender: TObject; const item: TECShape);
    procedure clusteringClick(Sender: TObject);
    procedure MoveDirection360Click(Sender: TObject);
    procedure cbClusterStyleChange(Sender: TObject);

    procedure rbAscendingClick(Sender: TObject);
    procedure fitboundsClick(Sender: TObject);

  private
    { Déclarations privées }
    FClusterGroup : TECShapes;

    procedure UpdatePoiNumber;

    procedure doOnColorSizeCluster(const Cluster: TECCluster; var Color: TColor;
      var BorderColor: TColor; var TextColor: TColor;
      var WidthHeight, FontSize: integer; var CStyle: TClusterStyle);

    procedure doOnclusterClick(Sender: TObject; const Cluster: TECCluster);

  public
    { Déclarations publiques }
    FEditPoi: TECShapePOI;
  end;

  TECShapeMyMarker = class(TECShapeMarker);

var
  FormNativePoi: TFormNativePoi;

implementation

{$R *.dfm}


procedure TFormNativePoi.FormCreate(Sender: TObject);
begin
  map.MinZoom := 4;

  // We're going to use the default shapes group.
  // To use another group, replace map.shapes with map['group_name'].

  FClusterGroup := map.shapes;


  // if you need to manipulate the elements contained in the cluster set FillClusterList a true
  // FClusterGroup.ClusterManager.FillClusterList := true;


  // dynamically adjust color and size to suit your needs
  FClusterGroup.ClusterManager.OnColorSizeCluster := doOnColorSizeCluster;

  // default value true, it's for documentation purposes.
  FClusterGroup.ClusterManager.ZoomWhenClicked := true;


  map.OnClusterClick := doOnclusterClick;


  // Categories are determined by the value of the 'shape' property of the elements.
  FClusterGroup.ClusterManager.CategorieKey := 'shape';

  // Each type of POI is referenced as a category,
  // The color is calculated according to the name to maintain consistency.
  with FClusterGroup.ClusterManager do
  begin
   AddCategorie('Ellipse', GetHashColor('ellipse'));
   AddCategorie('Star', GetHashColor('etar'));
   AddCategorie('Triangle', GetHashColor('triangle'));
   AddCategorie('Diamond', GetHashColor('diamond'));
   AddCategorie('Hexagon', GetHashColor('hexagon'));
   AddCategorie('Arrow', GetHashColor('arrow'));
   AddCategorie('ArrowHead', GetHashColor('arrowhead'));
   AddCategorie('Cross', GetHashColor('cross'));
   AddCategorie('DiagCross', GetHashColor('diagcross'));
   AddCategorie('DirectionSign', GetHashColor('directionsign'));
   AddCategorie('Rect', GetHashColor('rect'));
   AddCategorie('Text', GetHashColor('text'));

   // The last category will be used to count non-referenced categories.
   // Here it's useless, but it's for documentation purposes.
   AddCategorie('Other', GetHashColor('Other'));
  end;


  FClusterGroup.HintColor := clWhite;

  // add first 1000 pois
  AddPoisClick(nil);
end;


// generate 1000 pois on the visible area
procedure TFormNativePoi.AddPoisClick(Sender: TObject);
var
  x, y: integer;
  anim: TECAnimationFadePoi;
  P: TECShapePOI;
  Lat, Lng,
  dx, dy: double;
begin

  map.BeginUpdate;

  dy := (map.NorthEastLatitude - map.SouthWestLatitude) / 2;
  dx := (map.NorthEastLongitude - map.SouthWestlongitude) / 2;

  for y := 0 to 99 do
  begin
    for x := 0 to 9 do
    begin


      Lat := map.latitude - dy + (random(round(dy*2 * 1000)) / 1000);
      Lng := map.longitude - dx + (random(round(dx*2 * 1000)) / 1000);

      P  := FClusterGroup.AddPoi(Lat,Lng);

      P.POIUnit := puPixel;

      P.width := 32;
      P.height := 32;

      P.hint := 'Poi n°' + inttostr(P.IndexOf);

      P.Description := 'shape n°' + inttostr(P.indexof);

      P.Draggable := true;

      P.FillOpacity := 10+random(90);

      P.BorderSize := 2;

      case random(13) of
        0:
          P.POIShape := poiEllipse;
        1:
          P.POIShape := poiStar;
        2:
          P.POIShape := poiTriangle;
        4:
          P.POIShape := poiDiamond;
        5:
          P.POIShape := poiHexagon;
        6:
          P.POIShape := poiArrow;
        7:
          P.POIShape := poiArrowHead;
        8:
          P.POIShape := poiCross;
        9:
          P.POIShape := poiDiagCross;
        10:
          begin
            P.POIShape := poiDirectionSign;
            P.width := 64;
          end;
        12:
          P.POIShape := poiRect;
        11:
          begin
            P.POIShape := poiText;
            P.Description := 'Poi n°' + inttostr(P.IndexOf);
          end;
      end;

      // animated stars will not be clusterable
      case random(8) of
       1:
          if P.POIShape = poiStar then
          begin
            // anim auto free by P
            anim := TECAnimationFadePoi.Create;
            anim.MaxSize := 48;
            anim.StartSize := 8;
            anim.StartOpacity := 95;
            P.BorderSize := 0;
            P.Animation := anim;
            P.clusterable := false;
          end;
      end;

      P['shape'] := copy(psToStr(P.POIShape), 4, 50);

      P.Color := GetHashColor(lowercase(P['shape']));

    end;
  end;

  UpdatePoiNumber;

  map.EndUpdate;
end;

procedure TFormNativePoi.UpdatePoiNumber;
begin
  PoiNumber.caption := 'Total Pois : ' + inttostr(FClusterGroup.pois.count);
end;

// adapt the zoom to show all pois
procedure TFormNativePoi.fitboundsClick(Sender: TObject);
begin
 FClusterGroup.fitBounds;
end;


// fired when click on Cluster
procedure TFormNativePoi.doOnclusterClick(Sender: TObject;
  const Cluster: TECCluster);
var i:integer;
    s:string;
begin

 s := 'Cluster : ';

 if FClusterGroup.ClusterManager.Style<>csCategories then
   Infos.caption  := s+inttostr(Cluster.Count)+' shapes'
 else
  begin
   for i := Low(cluster.Categories.Serie) to High(cluster.Categories.Serie) do
   begin
     // use Index[i] to take sorting into account
     if cluster.Categories.Serie[cluster.Categories.Index[i]].Value>0 then
     begin
       s := s+cluster.Categories.Serie[cluster.Categories.Index[i]].legend+' - ';
     end;

   end;
   Infos.Caption := s;
  end;
end;


// The color and size of the cluster are adapted to the number of elements contained.
procedure TFormNativePoi.doOnColorSizeCluster(const Cluster: TECCluster;
  var Color: TColor; var BorderColor: TColor; var TextColor: TColor;
  var WidthHeight, FontSize: integer; var CStyle: TClusterStyle);
// var  i, nbrSelected: integer;
begin
  // sample code if you need to manipulate the elements contained in the cluster
  (*
    nbrSelected := 0;
    for i := 0 to Cluster.shapes.count - 1 do
    begin
    if Cluster.shapes[i].selected then
    inc(nbrSelected);
    end;
  *)

  if Cluster.count < 10 then
  begin
    Color := GetHighlightColorBy(clGreen, 32);
    WidthHeight := 30;
    FontSize := 9;
  end

  else

    if Cluster.count < 100 then
  begin
    Color := GetHighlightColorBy(clBlue, 32);
    WidthHeight := 60;
    FontSize := 11;
  end

  else

  begin
    Color := GetHighlightColorBy(clRed, 32);
    WidthHeight := 80;
    FontSize := 14;

  end;

  BorderColor := GetShadowColorBy(clWhite, 32);

  if CStyle = csStar then
    WidthHeight := WidthHeight + 20;

end;



// clicking on an element deactivates editing mode
procedure TFormNativePoi.mapShapeClick(Sender: TObject; const item: TECShape);
begin
  if assigned(FEditPoi) then
    FEditPoi.Editable := false;

  infos.caption := 'Click Poi n° ' + inttostr(item.IndexOf);

end;

// double-clicking on an element activates editing mode, unless it is animated
procedure TFormNativePoi.mapShapeDblClick(Sender: TObject;
  const item: TECShape);
begin
  FEditPoi := TECShapePOI(item);
  FEditPoi.Editable := item.Animation = nil;

end;

// fired when drag end
procedure TFormNativePoi.mapShapeDragEnd(Sender: TObject);
begin
  if Sender is TECShapePOI then
    infos.caption := 'Move Poi n° ' + inttostr(TECShapePOI(Sender).IndexOf);
end;

procedure TFormNativePoi.MoveDirection360Click(Sender: TObject);
var
  Direction: integer;
  animD: TECAnimationMoveToDirection;
  ShapePOI: TECShapePOI;
  SpeedKMh: integer;
begin

  // Optimization, call BeginUpdate before adding elements
  map.BeginUpdate;

  // Create 360 shapes that will move in their own direction
  for Direction := 0 to 359 do
  begin
    // All items will start from the map center
    ShapePOI := FClusterGroup.AddPOI(map.Latitude, map.Longitude);

   case random(4) of
     0 : ShapePOI.POIShape := poiStar;
     1 : ShapePOI.POIShape := poiTriangle;
     2 : ShapePOI.POIShape := poiArrow;
     3 : ShapePOI.POIShape := poiArrowHead;
   end;


    ShapePOI.width  := 24;
    ShapePOI.height := 24;


    // use it for cluster categories
    ShapePOI['shape'] := copy(psToStr(ShapePOI.POIShape), 4, 50);

    // set color in function of type
    ShapePOI.Color := GetHashColor(lowercase(ShapePOI['shape']));

    ShapePOI.BorderColor := GetShadowColorBy(ShapePOI.Color, 32);

    // speed between 30 and 130 km / h
    SpeedKMh := 30 + random(100);

    // create animation
    animD := TECAnimationMoveToDirection.Create(SpeedKMh, Direction);

    // there is no need to destroy the animation,
    // this is done automatically when the item is destroyed
    // or when you assign a new animation
    ShapePOI.Animation := animD;

    // the shape points in the direction
    animD.Heading := true;

    // start move
    animD.Start;

  end;

  // We can now allow the map to be updated
  map.EndUpdate;

  UpdatePoiNumber;

end;


// sort categories
procedure TFormNativePoi.rbAscendingClick(Sender: TObject);
begin
  case TRadioButton(Sender).tag of
    0:
      FClusterGroup.ClusterManager.CategorieSort := ctsAscending;
    1:
      FClusterGroup.ClusterManager.CategorieSort := ctsDescending;
    2:
     FClusterGroup.ClusterManager.CategorieSort := ctsNone;

  end;
end;

// set cluster style
procedure TFormNativePoi.cbClusterStyleChange(Sender: TObject);
begin


  FClusterGroup.ClusterManager.DrawWhenMoving := true;

   case cbClusterStyle.ItemIndex of
    0:
      FClusterGroup.ClusterManager.Style := csEllipse;
    1:
      FClusterGroup.ClusterManager.Style := csRect;
    2:
      FClusterGroup.ClusterManager.Style := csStar;
    3:
      FClusterGroup.ClusterManager.Style := csHexagon;
    4:
      FClusterGroup.ClusterManager.Style := csDiamond;
    5:
      FClusterGroup.ClusterManager.Style := csTriangle;
    6:
      FClusterGroup.ClusterManager.Style := csTriangleDown;

    7:begin
      FClusterGroup.ClusterManager.Style := csCategories;
      // categories are much more time-consuming to display
      FClusterGroup.ClusterManager.DrawWhenMoving := false;
    end;
  end;
end;

procedure TFormNativePoi.clusteringClick(Sender: TObject);
begin

  FClusterGroup.clusterable := clustering.checked;


end;




end.
