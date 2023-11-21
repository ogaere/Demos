unit UMainNativeLinesPolygones;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, uecNativeMapControl, uecNativeshape, uecMapUtil, Buttons, ExtCtrls,
  uecGraphics,
  StdCtrls, ComCtrls, Vcl.Imaging.pngimage;

type
  TFormNativeLinePolygone = class(TForm)
    Bar_Menu: TPanel;
    SpeedPolyline: TSpeedButton;
    speedLoadMap: TSpeedButton;
    SpeedSaveMap: TSpeedButton;
    pn_latlng: TPanel;
    map: TECNativeMap;
    SpeedPolygone: TSpeedButton;
    noshape: TSpeedButton;
    ColorDialog: TColorDialog;
    pnHelpPoint: TPanel;
    Label2: TLabel;
    OpenDialog: TOpenDialog;
    SaveDialog: TSaveDialog;
    Tools: TPanel;
    ColorBorder: TPanel;
    HoverColor: TPanel;
    BHColor: TPanel;
    pn_line_specific: TPanel;
    Label5: TLabel;
    edtBSize: TEdit;
    lbPenStyle: TLabel;
    PenStyle: TComboBox;
    Panel3: TPanel;
    Label3: TLabel;
    weight: TEdit;
    pn_poly_specific: TPanel;
    FillColor: TPanel;
    Label4: TLabel;
    Transparence: TTrackBar;
    BColor: TPanel;
    Distance: TLabel;
    Area: TLabel;
    Delete: TButton;

    procedure noshapeClick(sender: TObject);
    procedure SpeedPolylineClick(sender: TObject);
    procedure ColorBorderClick(sender: TObject);

    procedure TransparenceChange(sender: TObject);
    procedure speedLoadMapClick(sender: TObject);
    procedure SpeedSaveMapClick(sender: TObject);
    procedure styleChange(sender: TObject);
    procedure weightChange(sender: TObject);
    procedure PenStyleChange(sender: TObject);
    procedure FormCreate(sender: TObject);
    procedure DeleteClick(Sender: TObject);



  private
    { Déclarations privées }

    FEditGroup : TECShapes;

    procedure doShapeClick(sender: TObject; const item: TECShape);
    procedure doMapClick(sender: TObject; const Lat, Lng: Double);
    procedure doLoad(sender: TObject; const GroupName: string;  const FinishLoading: Boolean);

    procedure Editshape(const Value: Boolean);
    procedure doUpdateShape;
    procedure doInfoShape(const item: TECShape);
    procedure doPathChange(sender: TObject);

    procedure doChangeEditable(sender: TObject);

    procedure doCreateShapeLinePointEditable(sender: TObject;
      const Group: TECShapes; var ShapeLinePoint: TECShape;
      const Lat, Lng: Double; const index: integer);

  public
    { Déclarations publiques }
  end;

var
  FormNativeLinePolygone: TFormNativeLinePolygone;

implementation

{$R *.dfm}

// In this demo you will learn how to add, delete, edit lines and polygons.


procedure TFormNativeLinePolygone.FormCreate(sender: TObject);
begin

  Tools.Visible := false;

  // Lines and polygons will be placed in the default map.Shapes group.
  // To define another group do FEditGroup := map['group_name']

  FEditGroup := map.Shapes;

  // display label only if line or polygon is in edit mode
  FEditGroup.Polygones.Labels.Visible := true;
  FEditGroup.Polygones.Labels.ShowOnlyIf := lsoEdited;
  FEditGroup.Polygones.Labels.FontSize := 10;
  FEditGroup.Polygones.Labels.ColorType := lcContrasting;

  FEditGroup.Lines.Labels.Visible := true;
  FEditGroup.Lines.Labels.ShowOnlyIf := lsoEdited;
  FEditGroup.Lines.Labels.FontSize := 10;
  FEditGroup.Polygones.Labels.ColorType := lcContrasting;


  map.OnMapClick   := doMapClick;
  map.OnShapeClick := doShapeClick;
  map.OnLoad       := doLoad;

  // event triggered when an element's editable property changes
  map.OnChangeEditable := doChangeEditable;

  // the default value is true but I assign it for documentation purposes
  // the point clicked on the map will be automatically  added to the edited line or polygon
  map.EditableAddPointByClickOnMap := true;

end;


// event triggered when load data in group
procedure TFormNativeLinePolygone.doLoad(sender: TObject;
  const GroupName: string; const FinishLoading: Boolean);
begin
  // show all data
 if (GroupName=FEditGroup.name) then
   TECShapes(sender).fitBounds;
end;

// event triggered when click on map
procedure TFormNativeLinePolygone.doMapClick(sender: TObject;
  const Lat, Lng: Double);
begin

  if noshape.down then
    exit;

  // if there is no element in edit mode, we'll create one and put it in edit mode
  // map.OnChangeEditable is triggered
  if not assigned(map.Editshape) then
  begin

    if SpeedPolygone.down then
       FEditGroup.addPolygone([Lat, Lng]).Editable := true
    else
      FEditGroup.addLine([Lat, Lng]).Editable := true;

  end;

  (*

    by default map.EditableAddPointByClickOnMap is set to true,
    so the point is automatically added to the line or polygon in edit mode when clicked on the map.

    Otherwise you should do it yourself here by code

  *)


end;


// event triggered when an element's editable property changes
procedure TFormNativeLinePolygone.doChangeEditable(sender: TObject);
begin
  // if map.Editshape = nil editable = false
  if not assigned(map.Editshape) then
    exit;

  // editable is true
  Editshape(true);
  doInfoShape(map.Editshape);
  doUpdateShape;
end;

// redefine the creation selection points for lines and polygones
procedure TFormNativeLinePolygone.doCreateShapeLinePointEditable
  (sender: TObject;
  // sender is the line or polygon whose points are to be redefined
  const Group: TECShapes; // Group is sender's internal group
  var ShapeLinePoint: TECShape; // ShapeLinePoint is the return point
  const Lat, Lng: Double; // position
  const index: integer); // index of point
begin

  // it could also be a TECShapeMarker
  ShapeLinePoint := Group.AddPoi(Lat, Lng);

  ShapeLinePoint.Width := 14;
  ShapeLinePoint.height := 14;

  // first point is a rectangle
  if index = 0 then
    TECShapePoi(ShapeLinePoint).POIShape := poiRect
  else
    TECShapePoi(ShapeLinePoint).POIShape := poiEllipse;

  // Sender is TECShapeLine or TECShapePolygone
  // Polygons descend from TECShapeLine, so the same applies to polygons.
  ShapeLinePoint.Color := TECShapeLine(sender).HoverColor;
  ShapeLinePoint.HoverColor := TECShapeLine(sender).HoverBorderColor;
  TECShapePoi(ShapeLinePoint).BorderColor := TECShapeLine(sender).Color;
  TECShapePoi(ShapeLinePoint).HoverBorderColor := TECShapeLine(sender).Color;

  // first and last point in Black
  if (index = 0) or (index = TECShapeLine(sender).count - 1) then
    ShapeLinePoint.Color := GetShadowColorBy(TECShape(sender).Color, 128)
  else
    ShapeLinePoint.Color := GetHighlightColorBy(TECShape(sender).Color, 64);

  ShapeLinePoint.HoverColor := GetHighlightColorBy(ShapeLinePoint.Color, 32);
  TECShapePoi(ShapeLinePoint).HoverBorderColor :=
    GetHighlightColorBy(ShapeLinePoint.Color, 16);

end;

// // event triggered when click on shape (here lines and polygons)
procedure TFormNativeLinePolygone.doShapeClick(sender: TObject;
  const item: TECShape);
begin

  // as a precaution, we make sure it exists
  // and that its group is the same as the one in which
  //  we're adding our lines and polygons
  // It's not necessary in this demo, but it's for documentation purposes.
  if not assigned(item) or (item.Group.name <> FEditGroup.name) then
    exit;

  Tools.Visible := true;

  // Switches the element to edit mode
  item.Editable := true;

  if item is TECShapePolygone then
  begin
    SpeedPolygone.down := true;
  end
  else if item is TECShapeLine then
  begin
    SpeedPolyline.down := true;
  end
  else
  begin
    noshape.down := true;
  end;

end;


// line or polygon path change
procedure TFormNativeLinePolygone.doPathChange(sender: TObject);
begin

  // Polygons descend from TECShapeLine, so the same applies to polygons.
  Distance.Caption := 'Distance : ' + doubleToStrDigit
    (TECShapeLine(sender).Distance, 2) + ' Km';

  if sender is TECShapePolygone then
  begin
    Area.Caption := 'Area : ' + doubleToStrDigit(TECShapePolygone(sender).Area,
      2) + ' Km²';
    TECShapePolygone(sender).Description := Area.Caption;
  end
  else
   TECShapeLine(sender).Description := Distance.Caption;



end;

// Updates line or polygon with interface data
procedure TFormNativeLinePolygone.doUpdateShape;
var
  FSelectedShape: TECShape;
begin

  FSelectedShape := map.Editshape;

  if not assigned(FSelectedShape) or not(FSelectedShape.Editable) then
    exit;

  FSelectedShape.Color := ColorBorder.Color;
  FSelectedShape.HoverColor := HoverColor.Color;

  // Polygons descend from TECShapeLine, so the same applies to polygons.
  TECShapeLine(FSelectedShape).weight := StrToIntDef(weight.text, 4);

  TECShapeLine(FSelectedShape).BorderColor := BColor.Color;
  TECShapeLine(FSelectedShape).HoverBorderColor := BHColor.Color;
  TECShapeLine(FSelectedShape).BorderSize := StrToIntDef(edtBSize.text, 0);

  if (PenStyle.itemindex > -1) then
    TECShapeLine(FSelectedShape).PenStyle := TPenStyle(PenStyle.itemindex);

  // only polygones
  if FSelectedShape is TECShapePolygone then
  begin

    TECShapePolygone(FSelectedShape).Color := ColorBorder.Color;
    TECShapePolygone(FSelectedShape).BorderColor := ColorBorder.Color;
    TECShapePolygone(FSelectedShape).HoverBorderColor := BHColor.Color;
    TECShapePolygone(FSelectedShape).weight := StrToIntDef(weight.text, 4);

    TECShapePolygone(FSelectedShape).FillColor := FillColor.Color;
    TECShapePolygone(FSelectedShape).FillOpacity := Transparence.Position;

  end;

  Tools.Visible := true;

end;

// Updates the interface with data from the line or polygon being edited
procedure TFormNativeLinePolygone.doInfoShape(const item: TECShape);
var
  FSelectedShape: TECShape;
begin

  FSelectedShape := item;

  if not assigned(FSelectedShape) then
    exit;

  ColorBorder.Color := FSelectedShape.Color;
  HoverColor.Color := FSelectedShape.HoverColor;

  edtBSize.text := inttostr(TECShapeLine(FSelectedShape).BorderSize);

  BColor.Color := TECShapeLine(FSelectedShape).BorderColor;
  BHColor.Color := TECShapeLine(FSelectedShape).HoverBorderColor;

  weight.text := inttostr(TECShapeLine(FSelectedShape).weight);

  PenStyle.itemindex := integer(TECShapeLine(FSelectedShape).PenStyle);

  if FSelectedShape is TECShapePolygone then
  begin

    FillColor.Color := TECShapePolygone(FSelectedShape).FillColor;

    Transparence.Position := TECShapePolygone(FSelectedShape).FillOpacity;
    PenStyle.itemindex := 0;

    pn_poly_specific.Visible := true;
    Area.Visible := true;
    pn_line_specific.Visible := false;

  end
  else
  begin
    pn_poly_specific.Visible := false;
    pn_line_specific.Visible := true;
    Area.Visible := false;
  end;

end;

procedure TFormNativeLinePolygone.Editshape(const Value: Boolean);
var
  FSelectedShape: TECShape;
begin

  FSelectedShape := map.Editshape;
  if not assigned(FSelectedShape) then
    exit;

  if Value then
  begin

    FSelectedShape.Draggable := true;

    // Polygons descend from TECShapeLine, so the same applies to polygons.
    TECShapeLine(FSelectedShape).OnShapePathChange := doPathChange;
    // change default point
    TECShapeLine(FSelectedShape).OnCreateShapeLinePoint :=
      doCreateShapeLinePointEditable;

    // update infos perimeter / area
    doPathChange(FSelectedShape);

  end
  else
  begin
    FSelectedShape.Editable := false;
    FSelectedShape.Draggable := false;
  end;

end;


// delete shape
procedure TFormNativeLinePolygone.DeleteClick(Sender: TObject);
begin
  if assigned(map.Editshape) then
   map.Editshape.Remove;
end;

// disable line and polygon editing
procedure TFormNativeLinePolygone.noshapeClick(sender: TObject);
begin
  if noshape.down then
  begin
    Editshape(false);

    Tools.Visible := false;
  end;

end;

procedure TFormNativeLinePolygone.PenStyleChange(sender: TObject);
begin
  doUpdateShape;
end;

// load map from file
procedure TFormNativeLinePolygone.speedLoadMapClick(sender: TObject);
begin
  if OpenDialog.execute then
    map.LoadFromFile(OpenDialog.filename);
end;

// save map to file
procedure TFormNativeLinePolygone.SpeedSaveMapClick(sender: TObject);
begin
  if SaveDialog.execute then
    map.SaveToFile(SaveDialog.filename);
end;


// draw line or polygon
procedure TFormNativeLinePolygone.SpeedPolylineClick(sender: TObject);
begin
  Editshape(false);
end;



procedure TFormNativeLinePolygone.styleChange(sender: TObject);
begin
  doUpdateShape;
end;

procedure TFormNativeLinePolygone.TransparenceChange(sender: TObject);
begin
  doUpdateShape;
end;

procedure TFormNativeLinePolygone.weightChange(sender: TObject);
begin
  doUpdateShape;
end;

procedure TFormNativeLinePolygone.ColorBorderClick(sender: TObject);
begin
  if ColorDialog.execute then
  begin
    (sender As TPanel).Color := ColorDialog.Color;

    doUpdateShape;
  end;
end;



end.
