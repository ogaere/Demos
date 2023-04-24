unit UnitBoundaryArea;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs, FMX.Objects,
  System.ioUtils,
  FMX.uecNativeMapControl, FMX.uecNativeShape,FMX.uecMapUtil,
  FMX.Controls.Presentation, FMX.StdCtrls,
  FMX.ScrollBox, FMX.Memo, FMX.ListBox, FMX.Memo.Types, FMX.Edit;

type
  TForm12 = class(TForm)
    Panel1: TPanel;
    map: TECNativeMap;
    Label3: TLabel;
    Id: TLabel;
    Label1: TLabel;
    Tags: TMemo;
    Label2: TLabel;
    AdminLevel: TComboBox;
    KeepAllArea: TCheckBox;
    Label4: TLabel;
    surface: TLabel;
    Rectangle1: TRectangle;
    address: TEdit;
    faddr: TLabel;
    procedure FormCreate(Sender: TObject);
    procedure mapMapClick(sender: TObject; const Lat, Lng: Double);
    procedure mapShapeClick(sender: TObject; const item: TECShape);
    procedure KeepAllAreaChange(Sender: TObject);
    procedure addressKeyUp(Sender: TObject; var Key: Word; var KeyChar: Char;
      Shift: TShiftState);
  private
    { Déclarations privées }
  public
    { Déclarations publiques }
  end;

var
  Form12: TForm12;

implementation

{$R *.fmx}

(*
  we will take advantage of the fact that polygons contain openstreetmap info
  to define their styles according to the administrative level

  see http://www.helpandweb.com/ecmap/en/vector_tiles.htm#STYLE_SHEET
*)
const BOUDARY_STYLESHEET =
    // set variables
    '@yellow {#f1e755}'+
    '@orange {#d97200}'+
    '@red {#ba3827}'+
    '@brown {#725a50}'+
    //-------------------
    // set properties in function of level admin
    '.polygone {if:admin_level=2;color:@red;fcolor:@red;zindex:2;}' +
    // another syntax equivalent to if:admin_level=4
    '.polygone.admin_level:4 {color:@orange;fcolor:@orange;zindex:4;}' +
    //
    '.polygone {if:admin_level=6;color:@yellow;fcolor:@yellow;zindex:6;}' +
    '.polygone {if:admin_level=8;color:@brown;fcolor:@brown;zindex:8;}';

procedure TForm12.addressKeyUp(Sender: TObject; var Key: Word; var KeyChar: Char;
  Shift: TShiftState);
var i,j:integer;
    poly:TECShapePolygone;
    line:TECShapeLine;
begin
 if Key = 13 then
  begin


     id.text := '';
     Surface.Text :=  '';
     tags.Lines.Clear;


    for i := 0 to map.Boundary.Address(Address.Text)-1 do
     begin

      poly := nil;
      line := nil;

      if (map.Boundary.Items[i] is TECShapePolygone) then
       poly := TECShapePolygone(map.Boundary.Items[i])
       else
       if (map.Boundary.Items[i] is TECShapeLine) then
       line := TECShapeLine(map.Boundary.Items[i]) ;
    //  //

      if assigned(poly) then
      begin

       Poly.FillColor := GetHashColor(Address.Text);
       Poly.FillOpacity := 10;
       Poly.Opacity     := 100;
       Poly.PenStyle    := psDash;
       Poly.BorderColor := Poly.FillColor;
       Poly.BorderSize  := 4;
      end;


      if assigned(line) then
      begin
        line.Color := GetHashColor(Address.Text);
        line.Opacity     := 100;
        line.PenStyle    := psDash;
        line.weight  := 4;
      end;


     end;

     map.Boundary.fitBounds;
  end;
end;

procedure TForm12.FormCreate(Sender: TObject);
begin

 caption := 'Administrative Boundary - © ' + inttostr(CurrentYear) + ' E. Christophe';

 // json polygons are stored in cache/BOUNDARYAREA/

{$IFDEF MSWINDOWS}
 map.LocalCache := ExtractfilePath(ParamStr(0)) + 'cache';
{$ELSE}
 map.LocalCache := TPath.Combine(TPath.GetSharedDocumentsPath, 'cache');
{$ENDIF}

 // set styles
 map.Styles.Rules := BOUDARY_STYLESHEET;


end;



procedure TForm12.KeepAllAreaChange(Sender: TObject);
begin

 if not KeepAllArea.IsChecked then
  map.Boundary.Shapes.Clear;

end;


// get administrative polygon
procedure TForm12.mapMapClick(sender: TObject; const Lat, Lng: Double);
var Level,
    i,shape_count: integer;
    SurfaceArea : double;
begin

 case AdminLevel.ItemIndex of
  0 : Level := 0;
  1 : Level := 2;
  2 : Level := 4;
  3 : Level := 6
  else Level := 8;
 end;

  // delete the previous area if necessary
  if not KeepAllArea.IsChecked then
      map.Boundary.Shapes.Clear;


 (*
   if Level=0 you can simplify the call by not passing it as a parameter

    map.Boundary.Administrative(lat,lng) => Level is then determined according to the zoom

   By default :

     Zoom 0  to 4  = Level 2
     Zoom 5  to 8  = Level 4
     Zoom 9  to 11 = Level 6
     Zoom 12 to 24 = Level 8

     You control this with the AdminLevelFromZoom property

      map.Boundary.AdminLevelFromZoom := '0-8=4,9-24=8'; // only Level 4 et 8

     Pass an empty string to reset to default values

      map.Boundary.AdminLevelFromZoom := ''; // default values

 *)

 shape_count := map.Boundary.Administrative(lat,lng,Level);
 if shape_count>0 then
 begin

   id.text         := Inttostr(map.Boundary.Id);
   tags.Lines.Text := map.Boundary.Tags.Text;

   SurfaceArea := 0;

   for i := 0 to shape_count-1 do
     SurfaceArea := SurfaceArea + (map.boundary.Items[i] as TECShapePolygone).Area;
   Surface.Text :=  DoubleToStrDigit(SurfaceArea, 4) + ' Km²';


 end;
end;

procedure TForm12.mapShapeClick(sender: TObject; const item: TECShape);
var area_id:int64;
    key,value:string;

begin
   area_id := StrToInt64Def(item.PropertyValue['area_id'],0);

   if area_id>0 then
   begin
     id.text := Inttostr(area_id);
   end;

   if item is TECShapePolygone then

   Surface.Text :=  DoubleToStrDigit(TECShapePolygone(item).area, 4) + ' Km²'

   else

   Surface.Text :=  DoubleToStrDigit(TECShapeline(item).distance, 4) + ' Km';


   tags.Lines.Clear;

    // list of properties

  if Item.PropertiesFindFirst(Key, Value) then
  begin
    repeat

     // ignore this keys
      if (Key = 'ecshape')or(Key ='area_id') then
        continue;

     tags.Lines.Add(key+'='+value) ;

    until Item.PropertiesFindNext(Key, Value);
  end;


end;

end.
