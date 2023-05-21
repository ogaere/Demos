unit UPhotographer;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs, Generics.Collections,
  FMX.uecNativeShape, FMX.StdCtrls, FMX.uecMapUtil, FMX.Objects, System.IOUtils,
  FMX.uecNativeMapControl, FMX.Controls.Presentation, FMX.ListBox, FMX.Edit,
  FMX.EditBox, FMX.SpinBox;

type

  TDroneInfo = class
   FName               : string;
   FLatPhoto,FLngPhoto : double;
   FPhotos : TList<TBitmap>;
  public
   constructor Create;
   destructor  Destroy; override;
  end;


  TFormPhoto = class(TForm)
    Panel1: TPanel;
    launchdrones: TButton;
    Image: TImage;
    StyleBook1: TStyleBook;
    TotalPhotos: TLabel;
    Rectangle1: TRectangle;
    Label1: TLabel;
    distance: TSpinBox;
    Rectangle2: TRectangle;
    map: TECNativeMap;
    BackPhoto: TRectangle;
    procedure launchdronesClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure distanceChange(Sender: TObject);
  private
    { Déclarations privées }
    FDronesList : TList<TECShape>;

    FTotalPhotos   : integer;
    FDistancePhoto : double;

    procedure Launch_Drones;
    procedure Free_Drones;
    function  Get_Drone_Info(const name:string):TDroneInfo;

    procedure UpdateInfos;

    procedure doOnMoveDrone(sender : TObject;const Item : TECShape; var cancel:boolean);
    procedure doPhotoClick(sender: TObject; const item: TECShape);
    procedure doScreenShot(const name:string;const Screenshot:TBitmap);
  public
    { Déclarations publiques }
  end;

var
  FormPhoto: TFormPhoto;

implementation

{$R *.fmx}


// assume width = meters
// use scale for adapt to zoom
procedure OnGetScale(sender:TECShape;var ScaleValue:double);
var scale:double;
    meters:integer;
    Pixels:integer;
begin

  scale := sender.Scale;

  if scale=0 then
   scale := 1;

   meters := sender.Width;

   Pixels := sender.World.MeterToPixel(meters,sender.latitude);

  scaleValue := Scale * (pixels/meters);
end;


constructor TDroneInfo.Create;
begin
  FPhotos := TList<TBitmap>.create;
end;

destructor  TDroneInfo.Destroy;
var i:integer;
begin

 for I := 0 to FPhotos.Count-1 do
  FPhotos[i].Free;

  FPhotos.Free;

  inherited;

end;



procedure TFormPhoto.FormCreate(Sender: TObject);
var c:TColor;
begin


 caption := caption + ' with TECNativeMap - © ' + inttostr(CurrentYear) +
    ' E. Christophe';

 FDronesList := TList<TECShape>.create;

 map.ScaleMarkerToZoom := true;

 //map.OnGetScale := OnGetScale;

 map.Reticle := true;
 map.ReticleColor :=  $FFFFFFFF;

 map.LocalCache := TPath.Combine(TPath.GetSharedDocumentsPath, 'ecnativemap-cache');

 // default Distance between photos (in km)
 FDistancePhoto := (Distance.Value / 1000) ;
 // size photos
 map.ScreenShots.Width := 320;
 map.ScreenShots.Height:= 240;
 // do not capture elements only tiles
 map.ScreenShots.ShowShapes := false;
 // fired when "photo" is taken
 map.ScreenShots.OnScreenShot := doScreenshot;
end;

procedure TFormPhoto.FormDestroy(Sender: TObject);
begin
 Free_Drones;
 FDronesList.Free;
end;

procedure TFormPhoto.UpdateInfos;
begin
  TotalPhotos.Text := 'Total photos : '+inttostr(FTotalPhotos);
end;

function  TFormPhoto.Get_Drone_Info(const name:string):TDroneInfo;
var i:integer;
begin

   result := nil  ;

   for i :=0  to FDronesList.Count-1 do
   begin
     if TDroneInfo(FDronesList[i].item).Fname = name then
     begin
       result :=  TDroneInfo(FDronesList[i].item);
       break;
     end;
   end;

end;

procedure TFormPhoto.Free_Drones;
var i:integer;
begin

  map.ScreenShots.CancelAll;

   for i :=0  to FDronesList.Count-1 do
   begin
     TDroneInfo(FDronesList[i].item).Free;
   end;

   FDronesList.Clear;


   map.Clear;


   FTotalPhotos := 0;
   image.Bitmap := nil;

   UpdateInfos;

end;


procedure TFormPhoto.distanceChange(Sender: TObject);
begin
 FDistancePhoto := (Distance.Value / 1000) ;
end;



procedure TFormPhoto.Launch_Drones;
var Direction  : integer;
    animD      : TECAnimationMoveToDirection;
    Drone      : TECShapeMarker;
    SpeedKMh   : integer;
    c          : TColor;
begin
  Free_Drones;


  // drone speed between 100 and 200 km / h
  SpeedKMh := 100 + random(100);

  // Optimization, call BeginUpdate before adding elements
  // not really necessary here, there are only 8 drones
  map.BeginUpdate;

  // Create 8 drones that will move in their own direction
  Direction := 0;

  while Direction<360 do
  begin

    // All drones will start from the map center
    Drone := map.AddMarker(map.Latitude,map.longitude);

    // use data svg for draw drone

    Drone.StyleIcon := siSVG;

    Drone.Filename := 'M6.8182,0.6818H4.7727'+
	  'C4.0909,0.6818,4.0909,0,4.7727,0h5.4545c0.6818,0,0.6818,0.6818,0,'+
    '0.6818H8.1818c0,0,0.8182,0.5909,0.8182,1.9545V4h6v2L9,8l-0.5,5'+
	  'l2.5,1.3182V15H4v-0.6818L6.5,13L6,8L0,6V4h6V2.6364C6,1.2727,'+
    '6.8182,0.6818,6.8182,0.6818z';


    Drone.width := 32;
    Drone.height:= 32;

    Drone.XAnchor := 16;
    Drone.YAnchor := 16;

    // random color
    TAlphaColorRec(c).R := random(255);
    TAlphaColorRec(c).G := random(255);
    TAlphaColorRec(c).B := random(255);
    TAlphaColorRec(c).A := 255;


  //  Drone.Rotation := true;

    Drone.Color       := c   ;


    // stock infos for drone
    Drone.item := TDroneInfo.Create;

    TDroneInfo(Drone.item).FLatPhoto := Drone.Latitude;
    TDroneInfo(Drone.item).FLngPhoto := Drone.Longitude;
    TDroneInfo(Drone.item).FName     := 'drone_'+inttostr(Direction);


    Drone.OnShapeMove := doOnMoveDrone;

    // create animation
    animD := TECAnimationMoveToDirection.Create(SpeedKMh,Direction);

    // there is no need to destroy the animation,
    // this is done automatically when the item is destroyed
    // or when you assign a new animation
    Drone.Animation := animD;

    // the drone is in the direction of travel
    animD.Heading := true;

    // start move
    animD.Start;

    FDronesList.Add(Drone);

    // direction for next drone

    Direction := Direction + 45;

  end;



  // We can now allow the map to be updated
  map.EndUpdate;


end;





// fired when a drone move
procedure TFormPhoto.doOnMoveDrone(sender : TObject;const Item : TECShape; var cancel:boolean);
var shape:TECShape;
    DroneInfo : TDroneInfo;
begin

  DroneInfo := TDroneInfo(item.item);

  // take a photo every DistancePhoto kilometers
  if map.DistanceFrom(item.Latitude,item.Longitude,DroneInfo.FLatPhoto,DroneInfo.FLngPhoto)>FDistancePhoto then
  begin

    // add a point to the location where the photo is taken
    //shape := map.group[DroneInfo.fname].AddPoint(item.Latitude,item.longitude,item.Color) ;

    shape := map.addMarker(item.Latitude,item.longitude,DroneInfo.fname) ;
    shape.Color := item.Color;
    TECShapeMarker(shape).StyleIcon := siFlat;
    shape.Angle := item.angle ;
    TECShapeMarker(shape).Fov := 40;
    TECShapeMarker(shape).FovRadius := 25;

    // hide point, visible when the picture is realy taken
    shape.Visible := false;

    shape.OnShapeClick := doPhotoClick;

    DroneInfo.FLatPhoto := item.Latitude;
    DroneInfo.FLngPhoto := item.Longitude;

    // screensoot zoom 18 around the point
    map.ScreenShots.ScreenShot(item.Latitude,item.Longitude,18,DroneInfo.fname+'@'+inttostr(shape.Id));

  end;

end;


// view the associated image
procedure TFormPhoto.doPhotoClick(sender: TObject; const item: TECShape);
begin

 image.Bitmap           := TBitmap(item.item);
 backPhoto.stroke.Color := item.Color;

 end;


// here the screenshot is taken
procedure TFormPhoto.doScreenShot(const name:string;const Screenshot:TBitmap);
var bmp   : TBitmap;
    drone : TDroneInfo;
    id    : integer;

    photo   : TECShapeMarker;//POI;
    n,s     :string;
begin

  // name = droneName@IdPhoto
  s  := name;
  n  := strToken(s,'@');
  id := strtoint(s);

  drone := Get_Drone_Info(n);

  if not assigned(drone) then exit;



  // copy photo
  bmp := TBitmap.Create(screenshot.Width,screenshot.Height);
  bmp.Canvas.BeginScene;
  bmp.Canvas.DrawBitmap(Screenshot,Rectf(0,0,screenshot.Width,screenshot.Height),Rectf(0,0,screenshot.Width,screenshot.Height),100);
  bmp.canvas.EndScene;

  // find the point associated with this picture
  //photo := map.Group[n].Pois[id];
  photo := map.Group[n].Markers[id];

  // put in the list to destroy after
  drone.FPhotos.Add(bmp);

  // associate the image with the point
  photo.item := bmp;

  image.Bitmap := bmp;

  photo.Visible := true;
  BackPhoto.Stroke.Color := Photo.Color;

  inc(FTotalPhotos);

  UpdateInfos;

end;

procedure TFormPhoto.launchdronesClick(Sender: TObject);
begin
 Launch_Drones;
end;

end.
