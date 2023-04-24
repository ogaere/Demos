unit UDrawPath;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs, FMX.Objects,
  FMX.Controls.Presentation, FMX.StdCtrls, FMX.ListBox,
  FMX.Colors,
  // TECNativeMap units
  FMX.uecNativeMapControl,FMX.uecNativeShape, FMX.uecMapUtil,FMX.uecGraphics,
  FMX.Layouts;

type
  TForm7 = class(TForm)
    map: TECNativeMap;
    Active_deactive: TButton;
    AddPoint: TButton;
    Validate: TButton;
    Undo: TButton;
    guidance: TComboBox;
    ColorPathLine: TColorComboBox;
    ckCursor: TCheckBox;
    ckAddPointClick: TCheckBox;
    Layout1: TLayout;
    Layout2: TLayout;
    procedure Active_deactiveClick(Sender: TObject);
    procedure AddPointClick(Sender: TObject);
    procedure ValidateClick(Sender: TObject);
    procedure UndoClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure guidanceChange(Sender: TObject);
    procedure ColorPathLineChange(Sender: TObject);
    procedure ckCursorChange(Sender: TObject);
    procedure ckAddPointClickChange(Sender: TObject);
  private
    { Déclarations privées }
    procedure doOnReady(const Ready:boolean);
    procedure doOnActivate(const Activate:boolean);
    procedure doOnError(Sender: TObject);
    procedure doPaintCursor(const canvas:TECCanvas);
  public
    { Déclarations publiques }
  end;

var
  Form7: TForm7;

implementation

{$R *.fmx}

procedure TForm7.FormCreate(Sender: TObject);
begin
  map.DrawPath.OnReady    := doOnReady ;
  map.DrawPath.OnActivate := doOnActivate ;
  map.DrawPath.OnError    := doOnError;
  // we assign a value to trigger onActivate
  // which will update the buttons that manage the DrawPath actions
  map.DrawPath.Activate   := false;
end;

// This event occurs before and after the calculation of the route in a thread,
// while the segment is being calculated you can neither validate the route
// nor cancel the last segment
procedure  TForm7.doOnReady(const Ready:boolean);
begin
 Validate.Enabled := Ready and map.DrawPath.activate;
 Undo.Enabled     := Ready and map.DrawPath.isUndo;
end;

// Activation / deactivation of route tracing
procedure TForm7.doOnActivate(const Activate:boolean);
begin
 AddPoint.Enabled := Activate;
 Guidance.Enabled := Activate;

 if Activate then
 begin
  Active_deactive.Text := 'Deactivate'  ;
  Guidance.ItemIndex := integer(map.DrawPath.PathType);
 end
 else
   Active_deactive.Text := 'Activate'

end;

// event triggered if the route calculation is not validated
procedure TForm7.doOnError(Sender: TObject);
begin
  ShowMessage('Routing Error !');
end;

// We draw a simple cross in the center of the map, the same as in VCL mode
// add unit uecGraphics for TECCanvas
procedure TForm7.doPaintCursor(const canvas:TECCanvas);
var X, Y: integer;
begin

  // convert center position to local X,Y
  Map.FromLatLngToXY(Map.Center, X, Y);

  canvas.PenWidth(2);

  canvas.Polyline([Point(X, Y - 10), Point(X, Y + 10)]);
  canvas.Polyline([Point(X - 10, Y), Point(X + 10, Y)]);

end;


// path type selection
// You can either draw segments directly, or follow a route for pedestrians, bikes or cars.
procedure TForm7.guidanceChange(Sender: TObject);
begin
 map.DrawPath.PathType := TECDrawPathType(guidance.ItemIndex);
end;

// delete last segment
procedure TForm7.UndoClick(Sender: TObject);
begin
 map.DrawPath.Undo;
end;

// Finalize the route
procedure TForm7.ValidateClick(Sender: TObject);
begin
 map.DrawPath.GetPath(map.shapes.AddLine) ;
end;

procedure TForm7.Active_deactiveClick(Sender: TObject);
begin
 map.DrawPath.activate := not map.DrawPath.activate;
end;

procedure TForm7.AddPointClick(Sender: TObject);
begin
 map.DrawPath.AddPoint;
end;


procedure TForm7.ckAddPointClickChange(Sender: TObject);
begin
 map.DrawPath.AddPointOnClick := ckAddPointClick.IsChecked;
end;

// Support for drawing the cursor indicating the position of the point to be added
// Under Firemonkey you can also more simply fill the CursorData property
// with a string containing drawing instructions, this is identical to TPathData.Data
procedure TForm7.ckCursorChange(Sender: TObject);
begin
 if ckCursor.IsChecked then
  map.DrawPath.OnPaintCursor := doPaintCursor
 else
  map.DrawPath.OnPaintCursor := nil;
end;

// style for path line
procedure TForm7.ColorPathLineChange(Sender: TObject);
begin
 // add unit uecMapUtil for use ColorToHTML
  Map.Styles.addRule('#' + map.DrawPath.Name + '.line {color:'+ColorToHTML(ColorPathLine.Color)+'}');
end;

end.
