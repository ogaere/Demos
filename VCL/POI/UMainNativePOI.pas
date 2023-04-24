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
    map: TECNativeMap;
    Label1: TLabel;
    clustering: TCheckBox;
    MoveDirection360: TButton;
    cbClusterStyle: TComboBox;
    Label2: TLabel;
    procedure AddPoisClick(Sender: TObject);

    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure fitboundsClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure mapShapeClick(Sender: TObject; const item: TECShape);

    procedure mapShapeDragEnd(Sender: TObject);
    procedure mapShapeDblClick(Sender: TObject; const item: TECShape);
    procedure clusteringClick(Sender: TObject);
    procedure MoveDirection360Click(Sender: TObject);
    procedure cbClusterStyleChange(Sender: TObject);
  private
    { Déclarations privées }
    procedure UpdatePoiNumber;
    procedure doOwnerDrawPOI(const canvas: TECCanvas; var Rect: TRect;
      item: TECShape);
    procedure doNumDrawPOI(const canvas: TECCanvas; var r: TRect;
      item: TECShape);
    procedure doOnColorSizeCluster(const Cluster: TECCluster; var Color: TColor;
      var BorderColor: TColor; var TextColor: TColor;
      var WidthHeight, FontSize: integer; var CStyle: TClusterStyle);
  public
    { Déclarations publiques }
    FEditPoi: TECShapePOI;
  end;

var
  FormNativePoi: TFormNativePoi;

implementation

{$R *.dfm}

procedure TFormNativePoi.AddPoisClick(Sender: TObject);
var
  x, y, i, sx, sy: integer;
  anim: TECAnimationFadePoi;
  P: TECShapePOI;
begin

  map.BeginUpdate;

  for y := 0 to 99 do
  begin
    for x := 0 to 9 do
    begin

      if x < 5 then
        sx := 1
      else
        sx := -1;

      if y < 5 then
        sy := 1
      else
        sy := -1;

      i := map.shapes.pois.add(map.Latitude + (sx * (x * 0.004)),
        map.Longitude + (sy * (y * 0.004)));

      P := map.shapes.pois[i];

      P.POIUnit := puPixel;

      P.width := 32;
      P.height := 32;

      P.hint := 'Poi n°' + inttostr(i);

      P.Description := 'shape n°' + inttostr(i);

      P.Draggable := true;

      P.Color := RGB(random(255), random(255), random(255));

      P.BorderSize := 2;

      case random(7) of
        0:
          P.POIShape := poiEllipse;
        1:
          P.POIShape := poiStar;
        2:
          P.POIShape := poiRect;
        3:
          P.POIShape := poiTriangle;
        4:
          P.POIShape := poiOwnerDraw;
        5:
          P.POIShape := poiHexagon;
        6:
          P.POIShape := poiDiamond;
      end;

      if (P.POIShape <> poiTriangle) and (P.POIShape <> poiStar) then

        P.OnAfterDraw := doNumDrawPOI;

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

    end;
  end;

  UpdatePoiNumber;

  map.EndUpdate;
end;

procedure TFormNativePoi.UpdatePoiNumber;
begin
  PoiNumber.caption := 'Total Pois : ' + inttostr(map.shapes.pois.count);
end;

procedure TFormNativePoi.doOnColorSizeCluster(const Cluster: TECCluster;
  var Color: TColor; var BorderColor: TColor; var TextColor: TColor;
  var WidthHeight, FontSize: integer; var CStyle: TClusterStyle);
//var  i, nbrSelected: integer;
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

  if CStyle=csStar then  WidthHeight := WidthHeight + 20;


end;

procedure TFormNativePoi.mapShapeClick(Sender: TObject; const item: TECShape);
begin
  if assigned(FEditPoi) then
    FEditPoi.Editable := false;

  infos.caption := 'Click Poi n° ' + inttostr(item.IndexOf);
end;

procedure TFormNativePoi.mapShapeDblClick(Sender: TObject;
  const item: TECShape);
begin
  FEditPoi := TECShapePOI(item);
  FEditPoi.Editable := item.Animation = nil;

end;

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
  SpeedKMh, nb: integer;
begin

  (*
    // => explose le programme
    for nb:=0 to 100 do
    Map.Group['pois'].markers.add(map.latitude,map.longitude);
    Map.Group['pois'].markers.Selected := true;
    Map.Group['pois'].markers.Clear;
    exit; *)

  // Optimization, call BeginUpdate before adding elements
  map.BeginUpdate;

  // Create 360 triangles that will move in their own direction
  for Direction := 0 to 359 do
  begin
    // All items will start from the map center
    ShapePOI := map.AddPOI(map.Latitude, map.Longitude);

    ShapePOI.POIShape := poiTriangle;

    ShapePOI.width := 24;
    ShapePOI.height := 24;

    ShapePOI.Color := RGB(random(255), random(255), random(255));
    ShapePOI.BorderColor := GetShadowColorBy(ShapePOI.Color, 32);

    // speed between 30 and 130 km / h
    SpeedKMh := 30 + random(100);

    // create animation
    animD := TECAnimationMoveToDirection.Create(SpeedKMh, Direction);

    // there is no need to destroy the animation,
    // this is done automatically when the item is destroyed
    // or when you assign a new animation
    ShapePOI.Animation := animD;

    // the triangle points in the direction
    animD.Heading := true;

    // start move
    animD.Start;

  end;

  // We can now allow the map to be updated
  map.EndUpdate;

  UpdatePoiNumber;

end;

// draw number on shape
procedure TFormNativePoi.cbClusterStyleChange(Sender: TObject);
begin
  case cbClusterStyle.ItemIndex of
    0:
      map.shapes.ClusterManager.Style := csEllipse;
    1:
      map.shapes.ClusterManager.Style := csRect;
    2:
      map.shapes.ClusterManager.Style := csStar;
    3:
      map.shapes.ClusterManager.Style := csHexagon;
    4:
      map.shapes.ClusterManager.Style := csDiamond;
    5:
      map.shapes.ClusterManager.Style := csTriangle;
    6:
      map.shapes.ClusterManager.Style := csTriangleDown;
  end;
end;

procedure TFormNativePoi.clusteringClick(Sender: TObject);
begin

  map.shapes.clusterable := clustering.checked;
  map.shapes.ClusterManager.OnColorSizeCluster := doOnColorSizeCluster;
  map.shapes.ClusterManager.DrawWhenMoving := false;

  // if you need to manipulate the elements contained in the cluster set FillClusterList a true
  map.Shapes.ClusterManager.FillClusterList := true;
end;

procedure TFormNativePoi.doNumDrawPOI(const canvas: TECCanvas; var r: TRect;
  item: TECShape);
var
  x, y, w, h: integer;
  s: string;
begin

  canvas.font.Style := [fsBold];

  s := inttostr(item.Id);

  w := canvas.TextWidth(s);
  h := canvas.TextHeight(s);

  x := 1 + ((r.Left + r.Right) - w) DIV 2;
  y := 1 + ((r.Top + r.Bottom) - h) DIV 2;

  canvas.brush.Style := bsClear;

  canvas.font.Color := clWhite;

  canvas.TextRect(r, x, y, s);
end;

// owner draw poi, here transparancy text
procedure TFormNativePoi.doOwnerDrawPOI(const canvas: TECCanvas;
  var Rect: TRect; item: TECShape);
begin

  canvas.brush.Style := bsClear;

  if item.Hover then
    canvas.font.Color := item.HoverColor
  else
    canvas.font.Color := item.Color;

  canvas.font.Style := [fsBold];

  item.width := canvas.TextWidth(item.hint);
  item.height := canvas.TextHeight(item.hint);


  // item.x := item.x - (item.Width  div 2);
  // item.y := item.y - (item.height  div 2);

  canvas.TextOut(item.x - (item.width div 2), item.y - (item.height div 2),
    item.hint);

end;

procedure TFormNativePoi.fitboundsClick(Sender: TObject);
begin
  map.shapes.pois.getBounds;
  map.fitbounds(map.shapes.pois.NorthEastLatitude,
    map.shapes.pois.NorthEastLongitude, map.shapes.pois.SouthWestLatitude,
    map.shapes.pois.SouthWestLongitude);
end;

procedure TFormNativePoi.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  Action := caFree;
end;

procedure TFormNativePoi.FormCreate(Sender: TObject);
begin
  map.MinZoom := 4;

  map.ScaleMarkerToZoom := true;

  map.LocalCache := extractfilepath(application.exename) + 'cache';
  // set procedure for draw poiOwnerDraw
  map.shapes.pois.OnOwnerDraw := doOwnerDrawPOI;

  map.UseInfoWindowDescription := true;

  map.shapes.ClusterManager.FillClusterList := true;

 // map.FreeHand.Selection := true;
// map.FreeHand.OnValidSelection := doOnValidSelection;
// map.FreeHand.MouseButton :=  TMouseButton.mbLeft;


  // map.OverSizeForRotation := true;
  // map.RotationAngle       := 45;

  AddPoisClick(nil);
end;

end.
