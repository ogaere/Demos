unit Umain;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes,
  System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs, System.IOUtils,
  FMX.Controls.Presentation, FMX.ScrollBox, FMX.Memo, FMX.Objects,
  FMX.uecNativeMapControl, FMX.uecNativeShape, FMX.uecMapUtil, FMX.StdCtrls,
  FMX.Memo.Types, FMX.uecNativeScaleMap;

type
  TForm15 = class(TForm)
    Memo1: TMemo;
    map: TECNativeMap;
    GroupBox1: TGroupBox;
    Circle: TCheckBox;
    polygone1: TCheckBox;
    polygone2: TCheckBox;
    polygone3: TCheckBox;
    route2: TCheckBox;
    procedure FormCreate(Sender: TObject);
    procedure mapEnterGeofence(Sender: TObject; const Geofence: TECBaseGeofence;
      const item: TECShape);
    procedure mapLeaveGeofence(Sender: TObject; const Geofence: TECBaseGeofence;
      const item: TECShape);
    procedure CircleChange(Sender: TObject);
    procedure FormDestroy(Sender: TObject);

  private
    { Déclarations privées }
    FECNativeScaleMap: TECNativeScaleMap;

    procedure doEndAnimationMove(Sender: TObject);

  public
    { Déclarations publiques }

  end;

var
  Form15: TForm15;

implementation

{$R *.fmx}

const
  ENCODED_PATH_ROUTE = 'ocvmqAoexCC@bDAz@R~RRvLf@R?z@R|@h@AAf@oARgEvBsl@nA_b' +
    '@~C_{@z@_DbBoPbBs]f@{JjH{r@f@kC~Cg^rD_]z@gO?sDSgE{@k' +
    'Hg@kCkCsSg@eC?EoK_q@{@_ISwBoUscBcBgJSoAgYwpBwG{c@cB_' +
    'IwB{OUgC@Cf@SRg@nAkCz@{@bG_DfOwGf@g@f@g@z@oABECyCoAo' +
    'FQw@ACoAg@{JwBsD?oF?mMbB@?_Ikk@QgBAOsDf@{OgEgY_IkCg@' +
    'oP{E_jAc[wQ{EcGcBsIwBsNsDgJkCwVsIsBk@CB?wB{@wBcB{@ch' +
    'AwkB_D{EsjA{dBqAsB@Ccj@rDwLf@{^vB_Nz@gOnAkHf@sb@nAsD?kCRkC?eLC??@B';

  ENCODED_PATH_ROUTE2 = '}vzfGubNG_@ACAMEg@A_@AK?m@COBM@MJqC@WDwAHwBDgADO' +
    'Hw@D_ABa@Be@@CPgBHy@BMB]JeA@MNqADs@?QAQE_@CMKu@A' +
    'KCKEWa@iCE]AMSqAq@yECUIa@GLA@ILN@H@??B?LEXGH?H@\' +
    'JTNBFDBB@B@FADCBGBE?E?GLEd@INKfEw@DA|@Qb@Q^Sn@a@' +
    'NO\GLLPDH@JCHELMHSDWP_@FGHIfAw@~A{@LE~CiAREtASZK' +
    'PGxA}@xBu@xAe@pBs@TE|@OZ?FJFFJDH@JAJEFIDKDM?UCSG' +
    'OGIIEKCMBMFILCJ_@\[Fw@PsBt@qEvAgB^IB[NgBz@y@XoBr@_@P';

procedure TForm15.FormCreate(Sender: TObject);
var
  route, route2: TECShapeLine;
  triangle: TECShapePOI;
  moving: TECAnimationMoveOnPath;
  i: integer;

begin

  FECNativeScaleMap := TECNativeScaleMap.create;
  FECNativeScaleMap.map := map;
  // encode / decode Google Encoded Polyline Algorithm Format
  // see https://developers.google.com/maps/documentation/utilities/polylinealgorithm

  // precision of 6 decimal
  // create in group 'guide"
  route := map.AddencodedLine(ENCODED_PATH_ROUTE, 6, 'guide');

  route.Color := GetHashColor(ENCODED_PATH_ROUTE);

  route.fitBounds;

  route.Hint := 'Route 1';

  route2 := map.AddencodedLine(ENCODED_PATH_ROUTE2, 5);

  route2.Color := GetHashColor(ENCODED_PATH_ROUTE2);

  route2.Visible := false;

  // create green triangle
  triangle := map.AddPOI(0, 0);
  triangle.POIShape := poiTriangle;
  triangle.Width := 18;
  triangle.Height := 18;
  triangle.Color := GetshadowColorBy(route.Color, 32);

  triangle.name := 'Green';

  // move on route
  // start 0 meter
  // speed at 80 km/h
  moving := TECAnimationMoveOnPath.create(route, 0, 80);

  // directing the tip of the triangle in the direction of travel
  moving.heading := true;

  // moving will be automatically deleted
  triangle.animation := moving;

  // fired when arrived at end (or at start)
  moving.OnDriveUp := doEndAnimationMove;

  // run animation
  moving.stop := false;

  // create blue  triangle
  triangle := map.AddPOI(0, 0);
  triangle.POIShape := poiTriangle;
  triangle.Width := 18;
  triangle.Height := 18;

  triangle.Color := $FF306EFF;
  triangle.name := 'Blue';

  // move on route
  // start end of route (in meters)
  // speed at 50 km/h
  moving := TECAnimationMoveOnPath.create(route,
    round(route.Distance * 1000), 50);

  // directing the tip of the triangle in the direction of travel
  moving.heading := true;

  // moving will be automatically deleted
  triangle.animation := moving;

  // fired when arrived at end (or at start)
  moving.OnDriveUp := doEndAnimationMove;

  // run animation
  moving.stop := false;


  // create geofences

  // circle geofence
  map.Geofences.Add(43.23185, 0.080853, 50, 'Circle');

  // add first polygone
  // you can pass directly the name, it's just to show you how to access geofences
  i := map.Geofences.Add([43.2328534732095, 0.0829124450683594,
    43.2332286771262, 0.0857019424438477, 43.229195113965, 0.0841140747070313]);

  map.Geofences[i].name := 'Polygone 1';

  map.Geofences.Add([43.2342604759861, 0.0889205932617188, 43.2361364291573,
    0.0905942916870117, 43.2352297256686, 0.094757080078125, 43.2310712230598,
    0.0941133499145508], 'Polygone 2');

  map.Geofences.Add([43.2389502506328, 0.0926113128662109, 43.2413262653543,
    0.0947999954223633, 43.2362614906487, 0.100336074829102], 'Polygone 3');

  i := map.Geofences.Add(route2, 'Route 2');
  TECLineGeofence(map.Geofences[i]).MargingMeter := 5; // 5m tolerance margin

  map['guide'].ZIndex := 0;
  // fences above green line
  map.Geofences.ZIndex := 1;
  // mobiles shapes on top
  map.Shapes.ZIndex := 2;

  // local cache for tiles
  map.LocalCache := System.IOUtils.TPath.Combine
    (System.IOUtils.TPath.GetSharedDocumentsPath, 'ecnativemap-cache');

end;

procedure TForm15.FormDestroy(Sender: TObject);
begin
  FECNativeScaleMap.Free;
end;

// fired when enter in a geofence
procedure TForm15.mapEnterGeofence(Sender: TObject;
  const Geofence: TECBaseGeofence; const item: TECShape);
begin
  Memo1.Lines.Add(item.name + ' enter in ' + Geofence.name);
  Memo1.GoToTextEnd;
end;

// fired when exit geofence
procedure TForm15.mapLeaveGeofence(Sender: TObject;
  const Geofence: TECBaseGeofence; const item: TECShape);
begin
  Memo1.Lines.Add(item.name + ' exit ' + Geofence.name);
  Memo1.GoToTextEnd;

end;

// fired when the triangle reaches the end/start of road
procedure TForm15.CircleChange(Sender: TObject);
begin
  map.Geofences[TCheckBox(Sender).tag].Active := TCheckBox(Sender).IsChecked
end;

procedure TForm15.doEndAnimationMove(Sender: TObject);
var
  anim: TECAnimationMoveOnPath;
begin

  anim := TECAnimationMoveOnPath(TECShape(Sender).animation);

  // we got it reverses direction
  anim.ComeBack := not anim.ComeBack;
  // start animation
  anim.stop := false;

end;

end.
