unit UMainSnapeDrag;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes,
  System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs, FMX.Objects,
  FMX.uecNativeMapControl, FMX.uecNativeshape, FMX.uecMaputil,
  FMX.Controls.Presentation, FMX.StdCtrls, FMX.Edit, FMX.EditBox, FMX.NumberBox;

type
  TForm11 = class(TForm)
    map: TECNativeMap;
    Panel1: TPanel;
    Check_Polygone: TCheckBox;
    Chekc_redline: TCheckBox;
    Check_greenline: TCheckBox;
    Label1: TLabel;
    usemeters: TCheckBox;
    Label2: TLabel;
    d_unit: TLabel;
    Rectangle1: TRectangle;
    snapdistance: TNumberBox;
    Label3: TLabel;
    Check_marker: TCheckBox;
    Check_Star: TCheckBox;
    chk_targetline: TCheckBox;
    procedure FormCreate(Sender: TObject);
    procedure Check_PolygoneChange(Sender: TObject);
    procedure usemetersChange(Sender: TObject);
    procedure snapdistanceChange(Sender: TObject);
    procedure Check_markerChange(Sender: TObject);
    procedure chk_targetlineChange(Sender: TObject);
  private
    { Déclarations privées }

    poly: TECShapePolygone;
    red_line, green_line: TECShapeLine;

    mrk: TECShapeMarker;
    star: TECShapePoi;

    procedure doOnSnap(Sender: TObject);
    procedure doOnMouseDown(Sender: TObject; const item: TECShape);


  public
    { Déclarations publiques }
  end;

var
  Form11: TForm11;

implementation

{$R *.fmx}

procedure TForm11.FormCreate(Sender: TObject);
begin

  caption := 'SnapDrag - © ' + inttostr(CurrentYear) + ' E. Christophe';

  map.setCenter(43.2258805134321, 0.073);
  map.Zoom := 15;

  // adapt the size of the markers to the zoom level
  map.ScaleMarkerToZoom := true;

  // use Google Encoded Polyline Algorithm Format but with 6 digit precision
  poly := map.AddEncodedPolygone('sxmmqAykoB`tEjuD~jDehEzBkhFcoA{_DczBxY', 6);
  poly.fillColor := StrTocolor('#0080C0');
  poly.Color := poly.fillColor;
  poly.Name := 'Polygon';

  red_line := map.AddEncodedLine
    ('ievmqAe`nCrMec@jdAlT~i@`G`}Bn\rNauBrP_z@yH{|AqP}lBqPerAxDmoA|B_z@wHabAuLmgA~g@ajA?mgA}@st@vJqd@qRiw@ws@e~H',
    6);
  red_line.Color := StrTocolor('#FF4848');
  red_line.Name := 'red line';

  green_line := map.AddEncodedLine
    ('inkmqA}oeChpBe_@xrDbjAzzA`sFxq@{jElVgsGknBysJp{@i_O~@gkGqiFsoB', 6);
  green_line.Color := StrTocolor('#008040');
  green_line.Name := 'green line';

  mrk := map.AddMarker(map.Latitude, map.Longitude);
  mrk.draggable := true;



  // bas64 encoded image 'http://maps.google.com/mapfiles/ms/icons/red-dot.png';
  // defined in unit uecMapUtil
  mrk.FileName := GOOGLE_RED_DOT_ICON;

  mrk.YAnchor := 32;

  mrk.OnShapeMouseDown := doOnMouseDown;

  mrk.Name := 'Red marker';

  star := map.AddPOI(map.Latitude, map.Longitude + 0.001);
  star.POIShape := poiStar;
  star.Color := green_line.Color;
  star.draggable := true;
  star.OnShapeMouseDown := doOnMouseDown;
  star.Name := 'Green star';

  map.SnapDrag.AddMarker(mrk);

  map.SnapDrag.TargetLine := false;

  Check_marker.IsChecked := true;
  Check_Star.IsChecked := false;

  map.SnapDrag.AddGuide(poly);
  map.SnapDrag.AddGuide(red_line);

  Check_Polygone.IsChecked := true;
  Chekc_redline.IsChecked := true;
  Check_greenline.IsChecked := false;

  map.SnapDrag.snapdistance := 30; // 30 pixels
  snapdistance.Value := map.SnapDrag.snapdistance;

  map.SnapDrag.OnSnap := doOnSnap;

  // double the size of line when targeted
  map.Styles.addRule('.line._snap_:true {scale:2}')  ;
  map.Styles.addRule('.polygone._snap_:true {scale:2}')  ;
  // default size
  map.Styles.addRule('.line._snap_:false {scale:1}')  ;
  map.Styles.addRule('.polygone._snap_:false {scale:1}')  ;
  // doted target line
  map.Styles.addRule('#TECSnapDrag.line{penStyle:Dot}');

end;



procedure TForm11.doOnSnap(Sender: TObject);
begin
  TECSnapDrag(Sender).SnapShape.hint := TECSnapDrag(Sender).SnapShape.Name +
    ' snap to ' + TECSnapDrag(Sender).SnapGuide.Name;
  TECSnapDrag(Sender).SnapShape.ShowHint;
end;

procedure TForm11.doOnMouseDown(Sender: TObject; const item: TECShape);
begin
  item.hint := '';
end;

procedure TForm11.Check_markerChange(Sender: TObject);
var
  cb: TCheckBox;
begin

  cb := TCheckBox(Sender);

  case cb.tag of

    0:
      if cb.IsChecked then
        map.SnapDrag.AddMarker(mrk)
      else
        map.SnapDrag.RemoveMarker(mrk);

    1:
      if cb.IsChecked then
        map.SnapDrag.AddMarker(star)
      else
        map.SnapDrag.RemoveMarker(star);
  end;

end;

procedure TForm11.Check_PolygoneChange(Sender: TObject);
var
  cb: TCheckBox;
begin

  cb := TCheckBox(Sender);

  case cb.tag of

    0:
      if cb.IsChecked then
        map.SnapDrag.AddGuide(poly)
      else
        map.SnapDrag.RemoveGuide(poly);

    1:
      if cb.IsChecked then
        map.SnapDrag.AddGuide(red_line)
      else
        map.SnapDrag.RemoveGuide(red_line);

    2:
      if cb.IsChecked then
        map.SnapDrag.AddGuide(green_line)
      else
        map.SnapDrag.RemoveGuide(green_line);

  end;
end;

procedure TForm11.chk_targetlineChange(Sender: TObject);
begin
    map.SnapDrag.TargetLine := chk_targetline.IsChecked;
end;

procedure TForm11.snapdistanceChange(Sender: TObject);
begin
  map.SnapDrag.snapdistance := round(snapdistance.Value);
end;

procedure TForm11.usemetersChange(Sender: TObject);
begin
  map.SnapDrag.MeterDistance := usemeters.IsChecked;

  if usemeters.IsChecked then
    d_unit.Text := 'meters'
  else
    d_unit.Text := 'pixels';
end;

end.
