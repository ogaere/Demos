unit UMappilarySearchImages;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes,
  System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs, FMX.Objects,
  FMX.uecNativeMapControl, FMX.Controls.Presentation, FMX.StdCtrls,
  System.IOUtils,
  System.UIConsts,
  System.Permissions,
{$IFDEF ANDROID}
  Androidapi.Jni.Os,
  Androidapi.Jni.javatypes,
  Androidapi.Helpers,
{$ENDIF}
  FMX.uecNativeShape, FMX.uecMapillary, FMX.uecGraphics, FMX.uecMapUtil;

type
  TFormMappilarySearchImages = class(TForm)
    map: TECNativeMap;
    Label2: TLabel;
    Info: TLabel;
    Ani: TAniIndicator;
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure doDrawReticle(Sender: TObject; const canvas: TECCanvas);
    procedure mapMapClick(Sender: TObject; const Lat, Lng: Double);

    procedure doMarkerClick(Sender: TObject; const item: TECShape);

  private
    { Déclarations privées }
    FMapillary: TECMapillaryLayer;

    FSearchLatLng: TLatLng;
    FSearchFirstImage: integer;

    FInfoWindow: TECShapeInfoWindow;

    procedure doBeginRequest(Sender : TObject);
    procedure doEndRequest(Sender: TObject);

  public
    { Déclarations publiques }
  end;

var
  FormMappilarySearchImages: TFormMappilarySearchImages;

implementation

{$R *.fmx}

const
 
  INFOWINDOW_CONTENT = '<font size=20 color=%s><b><center>%s</center></b></font><br>' +
    '<center><img src="%s" ></center><br=5>' + '<tab=60><b>Lat : </b>%n - <b>Lng : </b>%n';

procedure TFormMappilarySearchImages.FormCreate(Sender: TObject);
begin

  caption := 'Mappilary Search Images for TECNativeMap - © ' +
    inttostr(CurrentYear) + ' E. Christophe';


  // map.LocalCache := TPath.Combine(TPath.GetDocumentsPath, 'cache');


  FMapillary := CreateMapillaryLayer(map,doBeginRequest,doEndRequest);

  
  map.InertiaScroll := true;

  map.ScaleMarkerToZoom := true;

  FInfoWindow := map.AddInfoWindow(map.Latitude, map.longitude);
  FInfoWindow.Visible := false;
  FInfoWindow.Width := 270;



  // Paris, France;

  map.Latitude := 48.85658;
  map.longitude := 2.3515;

  // Styleicon depends on the zoom
  map.Styles.addRule('#.marker {styleicon:1-16=FlatNoBorder,17-21=direction}');
  // for the images in 360° view the direction is not indicated
  map.Styles.addRule('#.marker.pano:1 {styleicon:1-16=flatNoBorder,17-21=Flat}');

  map.InertiaScroll := true;

  map.OnMapPaint := doDrawReticle;

end;

procedure TFormMappilarySearchImages.FormDestroy(Sender: TObject);
begin
  FMapillary.Free;
end;

// Search for images around the click point
procedure TFormMappilarySearchImages.mapMapClick(Sender: TObject;
  const Lat, Lng: Double);
var
  latSW, lngSW, latNE, lngNE: Double;
begin

  FSearchLatLng.Lat := Lat;
  FSearchLatLng.Lng := Lng;

  FSearchFirstImage := 0;

  FInfoWindow.Visible := false;


  // determine a 500 meter rectangle around the click point
  boundingCoordinates(Lat, Lng, 0.5, latSW, lngSW, latNE, lngNE);
   // load area
  FMapillary.SearchBounds(latNE, lngNE, latSW, lngSW);

end;


// triggered just before running a mapillary query
procedure TFormMappilarySearchImages.doBeginRequest(Sender : TObject);
begin
  Info.Text := 'Searching...';

  Ani.Visible := true;
  Ani.Enabled := true;

  // delete previous markers
  map.Shapes.markers.Clear;

end;


// triggered when the request is completed
// we will make a search among the images found
procedure TFormMappilarySearchImages.doEndRequest(Sender: TObject);
var
  L: TListSequenceImage;
  i: integer;
  Marker: TECShapeMarker;
  Seq: TMapillarySequence;
  image: TMapillaryImage;
begin

  (* L is List of  TSequenceImage = record
                     Sequence   : TMapillarySequence;
                     ImageIndex : integer;
                   end;
  *)
  L := TListSequenceImage.Create;



  // search for images within a 500 meter radius

  // !  The search is done locally,
  // so you need to have done a Mapillary SearchBounds(latNE, lngNE,latSW, lngSW) to download the whole area

  FMapillary.SearchImageClose(FSearchLatLng.Lat, FSearchLatLng.Lng, 500, L);

  Info.Text := inttostr(L.Count) + ' images found';



  // add markers associated with the search
  map.BeginUpdate;

  for i := 0 to L.Count - 1 do
  begin

    Seq := L[i].sequence;

    image := Seq.images[L[i].imageIndex];

    Marker := map.AddMarker(image.Lat, image.Lng);

    Marker.Hint := inttostr(image.Id);

    Marker.Angle := integer(-image.Compass_angle);

    Marker.Color      := GetHashColor(image.Sequence_id);
    Marker.HoverColor := GetHighlightColorBy(Marker.Color, 32);

    // detect if image is in 360°, used to assign a particular style
    if image.is_Pano then
      Marker.PropertyValue['pano'] := '1';

    // stock the image data, use it when click on marker
    Marker.item := image;


    //marker.OnShapeMouseDown := doMarkerClick;//
    Marker.OnShapeClick := doMarkerClick;

  end;

  map.EndUpdate;

  L.Free;

  Ani.Enabled := false;
  Ani.Visible := false;

end;

// when clicking on a marker an infowindow is displayed with a 256*256 preview of the corresponding image
procedure TFormMappilarySearchImages.doMarkerClick(Sender: TObject;
  const item: TECShape);
var
  image: TMapillaryImage;

begin

  if not(item.item is TMapillaryImage) then
    exit;

  image := TMapillaryImage(item.item);


  // build infowindow content

  FInfoWindow.content := format(INFOWINDOW_CONTENT,
    [copy(ColorToHtml(item.Color), 2, 10), item.Hint, image.Url256,
    item.Latitude, item.longitude]);

  // open infowindow at click position
  FInfoWindow.SetPosition(item.Latitude, item.longitude);
  FInfoWindow.Visible := true;

end;

// draw selection circle
// OnMapPaint is fired before shapes are drawn
// use OnShapesPaint to draw over the elements
procedure TFormMappilarySearchImages.doDrawReticle(Sender: TObject;
  const canvas: TECCanvas);
var
  x, y, radius: integer;
begin

  // convert search position to local X,Y
  map.FromLatLngToXY(FSearchLatLng, x, y);

  // convert 500 meters to pixels
  radius := map.MeterToPixel(500);

  canvas.PenWidth(2);

  // draw center cross
  canvas.Pen.Color := $80FF2616;

  canvas.Polyline([Point(x, y - 10), Point(x, y + 10)]);
  canvas.Polyline([Point(x - 10, y), Point(x + 10, y)]);


  // draw circle

  canvas.Pen.Color := claBlack;

  // transparent
  canvas.FillOpacity := 0;

  canvas.Ellipse(x - radius, y - radius, x + radius, y + radius);

end;

end.
