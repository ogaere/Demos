unit UMain;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants,
  System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, uecNativeMapControl,
  uecnativeshape, uecmaputil,
  Vcl.ExtCtrls, Vcl.ComCtrls, Vcl.Samples.Spin, Vcl.Menus;

type
  TForm8 = class(TForm)
    Panel1: TPanel;
    map: TECNativeMap;
    address: TEdit;
    AddGrid: TButton;
    Label1: TLabel;
    col: TSpinEdit;
    Label2: TLabel;
    row: TSpinEdit;
    grids: TComboBox;
    pmGrid: TPopupMenu;
    N2x21: TMenuItem;
    Grid5x51: TMenuItem;
    Grid10x101: TMenuItem;
    Cell1: TMenuItem;
    Cellsize500m1: TMenuItem;
    Cellsize1km1: TMenuItem;
    Exiteditmode1: TMenuItem;
    info: TLabel;
    DeleteGrid: TButton;
    procedure addressKeyUp(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure FormActivate(Sender: TObject);
    procedure AddGridClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure gridsChange(Sender: TObject);
    procedure N2x21Click(Sender: TObject);
    procedure mapMapClick(sender: TObject; const Lat, Lng: Double);
    procedure DeleteGridClick(Sender: TObject);

  private
    { Déclarations privées }
  public
    { Déclarations publiques }
    procedure doFocusedGrid(Sender: TObject);
    procedure doChangeGrids(Sender: TObject);

    procedure donOnHeaderClick(const Grid:TECGrid;const Text:string;const index: integer; const Position : TECHeaderLabelPosition) ;

    procedure doOnEditChange(const Grid:TECGrid);

    procedure doCellClick(const Grid:TECGrid; const Item: TECShapePolygone);
    procedure doCellDblClick(const Grid:TECGrid; const Item: TECShapePolygone);
    procedure doCellLongPress(const Grid:TECGrid; const Item: TECShapePolygone);

    procedure doGridRightClick(const Grid:TECGrid; const Item: TECShapePolygone);



  end;

var
  Form8: TForm8;

implementation

{$R *.dfm}


procedure TForm8.addressKeyUp(Sender: TObject; var Key: Word;
  Shift: TShiftState);
var
  poly: TECShapePolygone;
  i: integer;
  area:double;
  Distance,CellSize : integer;
begin

  if Key = 13 then
  begin



    // Boundary allows you to obtain the polygons, polylines and data of an area
    // just by indicating a geographical point or an address..

    // see http://www.helpandweb.com/ecmap/en/location.htm#BOUNDARY
    i :=  map.Boundary.address(address.Text);

    if i>0 then
    begin

      poly := nil;
      area := 0;

      // Keep only the largest polygon

      while i>0 do
      begin
       dec(i);

       if (map.Boundary.Items[i] is TECShapePolygone) then
       begin
         if TECShapePolygone(map.Boundary.Items[i]).Area>Area then
         begin
           Poly := TECShapePolygone(map.Boundary.Items[i]);
           Area := Poly.area;
         end;
       end;

      end;

      if assigned(poly) then
      begin

        poly.getBounds;

        if poly.Area<6000000 then
        begin

        Distance := round(DistanceFrom(poly.SouthWestLat,poly.SouthWestLng, poly.SouthWestLat,poly.NorthEastLng)) ;

        if Distance<20 then   // 10km
         CellSize := 500      // 500m
        else
        if Distance<40 then
         CellSize := 1000
        else
        if Distance<60 then
         CellSize := 5000
        else
         CellSize := 20000;




        map.grids.Add(poly,CellSize).fitbounds;


        end
        else
         showmessage('Polygone to big !');
      end
      else
        showmessage('Not a polygone !');

    end;

    map.Boundary.Clear;

  end;

end;

procedure TForm8.DeleteGridClick(Sender: TObject);
begin
  if assigned(map.grids.FocusedGrid) then
   map.grids.FocusedGrid.Free;
end;

procedure TForm8.AddGridClick(Sender: TObject);
//var  grid_name: string;
begin
  //grid_name := 'grid ' + inttostr(map.grids.Count);
  map.grids.Add(col.Value, row.Value);
  //grids.Items.Add(grid_name);
end;

procedure TForm8.doChangeGrids(Sender: TObject);
begin
  map.Grids.getList(grids.Items);
   DeleteGrid.Enabled := grids.ItemIndex>-1;
end;

procedure TForm8.doFocusedGrid(Sender: TObject);
begin
  if assigned(map.grids.FocusedGrid) then
  begin

    col.Value := map.grids.FocusedGrid.col;
    row.Value := map.grids.FocusedGrid.row;

    grids.OnChange := nil;
    grids.ItemIndex := grids.Items.IndexOf(map.grids.FocusedGrid.name);
    grids.OnChange := gridsChange;


  end;
end;


procedure TForm8.FormActivate(Sender: TObject);
begin
  map.SetFocus;
end;

procedure TForm8.FormCreate(Sender: TObject);
begin
  map.grids.OnFocusedGrid    := doFocusedGrid;
  map.grids.OnCellRightClick := doGridRightClick;
  map.grids.OnHeaderClick    :=  donOnHeaderClick ;
  map.grids.OnCellClick      := doCellClick;
  map.grids.OnCelldblClick   := doCellDblClick;
  map.grids.OnCellLongPress  := doCellLongPress;
  map.Grids.OnEditChange     := doOnEditChange;
  map.Grids.OnChange         := doChangeGrids;

end;



procedure TForm8.doOnEditChange(const Grid:TECGrid);
begin
  info.Caption := (
  'NorthEst : '+ doubletostrdigit(Grid.NELat,3)+' , '+doubletostrdigit(Grid.NELng,3)+
  ' SouthWest : '+doubletostrdigit(Grid.SWLat,3)+' , '+doubletostrdigit(Grid.SWLng,3)+
  ' - Col : '+inttostr(Grid.col)+' Row : '+inttostr(Grid.row));
end;

procedure TForm8.donOnHeaderClick(const Grid:TECGrid;const Text:string;const index: integer; const Position : TECHeaderLabelPosition) ;
var PosText:string;
begin


   case Position of
     hlpTop   : PosText := 'Top';
     hlpBottom: PosText := 'Bottom';
     hlpLeft  : PosText := 'Left' ;
     hlpRight : PosText := 'Right';
   end;



 info.Caption := (Text + ' - Index : '+inttostr(index)+'  Pos : '+PosText);
end;

procedure TForm8.doCellClick(const Grid:TECGrid; const Item: TECShapePolygone);
begin
 info.Caption := ('Click '+Item.Description+ ' - Col:'+ Item['cell-col']+' Row:'+Item['cell-row']);

 if Grid.editable then
  info.Caption := info.Caption+ ' EDITABLE';

end;

procedure TForm8.doCellDblClick(const Grid:TECGrid; const Item: TECShapePolygone);
begin
 info.Caption := ('DblClick '+Item.Description+ ' - Col:'+ Item['cell-col']+' Row:'+Item['cell-row']);
end;


procedure TForm8.doCellLongPress(const Grid:TECGrid; const Item: TECShapePolygone);
begin
 info.Caption := ('Press '+Item.Description+ ' - Col:'+ Item['cell-col']+' Row:'+Item['cell-row']);
 Grid.editable := true;
end;


// righ click on grid
procedure TForm8.doGridRightClick(const Grid:TECGrid; const Item: TECShapePolygone);
begin


  info.Caption := ('RightClick '+Item.Description+ ' - Col:'+ Item['cell-col']+' Row:'+Item['cell-row']);


  map.Grids.FocusedGrid := Grid;

  if not assigned(map.Grids.FocusedGrid) then  exit;


  if (map.Grids.FocusedGrid.GridType=gtTable) then
      begin
       // only griType=gtTable can be editable with mouse
       if not map.Grids.FocusedGrid.editable then
           map.Grids.FocusedGrid.editable := true
       else
          pmGrid.Popup(Mouse.CursorPos.X, Mouse.CursorPos.Y);
      end;
end;



// select the grid that has the focus from the comboBox
procedure TForm8.gridsChange(Sender: TObject);
begin
  // select grid
  map.grids.FocusedGrid := map.grids[grids.ItemIndex];

  // map.grids[] return nil if the index is outside the range
  if assigned(map.grids.FocusedGrid) then
  begin
     DeleteGrid.Enabled := true;
    // zoom to grid
    map.grids.FocusedGrid.FitBounds;
  end
  else  DeleteGrid.Enabled := false;
end;


// center the editable grid on the clicked point
procedure TForm8.mapMapClick(sender: TObject; const Lat, Lng: Double);
begin
  if assigned(map.grids.FocusedGrid) and (map.grids.FocusedGrid.editable) then
   map.grids.FocusedGrid.setPosition(Lat,Lng);
end;



// action in response to PopupMenu
procedure TForm8.N2x21Click(Sender: TObject);
begin
if assigned(map.grids.FocusedGrid) and
 ((map.grids.FocusedGrid.editable) ) then
  begin

    case  TMenuItem(Sender).tag of
      0: map.grids.FocusedGrid.setSize(2,2);
      1: map.grids.FocusedGrid.setSize(5,5);
      2: map.grids.FocusedGrid.setSize(10,10);
      3: map.grids.FocusedGrid.CellSizeMeter :=  500; // 500 meters
      4: map.grids.FocusedGrid.CellSizeMeter := 1000; // 1km meters
      5: map.grids.FocusedGrid.CellSizeMeter := 2000; // 2km
      6: map.grids.FocusedGrid.Editable := false;
      end;
    end;
end;




end.
