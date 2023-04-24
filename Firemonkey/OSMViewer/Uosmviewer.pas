unit Uosmviewer
  ;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs,
  Generics.Collections,
  FMX.uecNativeShape, FMX.StdCtrls, FMX.uecMapUtil, FMX.Objects, System.IOUtils,
  FMX.uecNativeMapControl, FMX.Controls.Presentation, FMX.ListBox, FMX.Edit,
  FMX.uecGraphics,
  System.UIConsts, FMX.uecOSM, System.DateUtils,
  FMX.EditBox, FMX.SpinBox, FMX.ScrollBox, FMX.Memo, FMX.Layouts, FMX.ComboEdit,
  System.Rtti, FMX.Grid.Style, FMX.Grid, FMX.Colors, FMX.ExtCtrls, FMX.Menus;

type


  // hack for auto complete edit
  TComboEdit = class(FMX.ComboEdit.TComboEdit)
  private
    Keys : string;
  protected
    procedure KeyDown(var Key : Word; var KeyChar : System.WideChar;
      Shift : TShiftState); override;
  end;

  TInfoGauge = (igNone, igProgressCircle, igInfinite);

  TForm2 = class(TForm)
    Panel1 : TPanel;
    StyleBook1 : TStyleBook;
    Rectangle2 : TRectangle;

    filename : TLabel;
    Rectangle1 : TRectangle;
    OpenOSMFile : TButton;
    OpenDialogOSM : TOpenDialog;
    NodeWayRelation : TLabel;
    KeysLabel : TLabel;
    valuesLabel : TLabel;
    InfosFile : TRectangle;
    search : TLabel;
    searchnodes : TButton;
    searchway : TButton;
    SearchResult : TLabel;
    Keys : TComboEdit;
    values : TComboEdit;
    GridProperty : TGrid;
    ColKeys : TColumn;
    ColValues : TColumn;
    ColorBox : TComboColorBox;
    grouplabel : TLabel;
    Groups : TComboBox;
    GroupVisible : TButton;
    GroupDelete : TButton;
    map : TECNativeMap;
    Ani : TAniIndicator;
    WaitInfo : TLabel;
    ProgressCircle : TCircle;
    ProgressInnerCircle : TCircle;
    ProgressCircleArc : TArc;
    ProgressCircleText : TText;
    KeyCount : TLabel;
    ValueCount : TLabel;
    Node : TLabel;
    NodeImage : TImage;
    NodeCount : TLabel;
    Way : TLabel;
    WayImage : TImage;
    WayCount : TLabel;
    Relation : TLabel;
    RelationImage : TImage;
    RelationCount : TLabel;
    NodeCheck : TCheckBox;
    WayCheck : TCheckBox;
    RelationCheck : TCheckBox;
    SearchLabel : TLabel;
    GroupItem : TComboBox;
    SaveOLT : TButton;
    BaseMap : TCheckBox;
    timing : TLabel;
    Timer1 : TTimer;
    RelationsLabel : TLabel;
    Relations : TComboEdit;
    AniSave : TAniIndicator;
    OpenDialog1: TOpenDialog;
    ArcDial1: TArcDial;
    Rectangle3: TRectangle;

    procedure FormCreate(Sender : TObject);
    procedure FormDestroy(Sender : TObject);
    procedure OpenOSMFileClick(Sender : TObject);
    procedure keysChange(Sender : TObject);
    procedure searchnodesClick(Sender : TObject);
    procedure mapLoad(Sender : TObject; const GroupName : string;
      const FinishLoading : Boolean);
    procedure searchwayClick(Sender : TObject);
    procedure mapShapeClick(Sender : TObject; const item : TECShape);
    procedure GridPropertyGetValue(Sender : TObject; const ACol, ARow : Integer;
      var Value : TValue);
    procedure FormCloseQuery(Sender : TObject; var CanClose : Boolean);
    procedure GroupsChange(Sender : TObject);
    procedure GroupVisibleClick(Sender : TObject);
    procedure GroupDeleteClick(Sender : TObject);
    procedure mapMapSelectRect(Sender : TObject; const SWLat, SWLng, NELat,
      NELng : Double);
    procedure GroupItemChange(Sender : TObject);
    procedure SaveOLTClick(Sender : TObject);
    procedure BaseMapChange(Sender : TObject);
    procedure Timer1Timer(Sender : TObject);
    procedure RelationsChange(Sender : TObject);
    procedure mapChangeMapZoom(Sender: TObject);
    procedure ArcDial1Change(Sender: TObject);
    procedure ArcDial1DblClick(Sender: TObject);
    procedure mapMapPaint(sender: TObject; const canvas: TECCanvas);

  private
    { Déclarations privées }

    FThreadOSMToOLT : TThreadOSMToOLT;

    selected_shape : TECShape;

    ItemKey : array of TValue;
    ItemValue : array of TValue;

    FOSMFile : TOSMFile;

    FSaveArea : boolean;

    FMemoryStream : TMemoryStream;

    procedure InfosCaption;

    procedure mapMapSelectChange(Sender : TObject; const SWLat, SWLng, NELat,
      NELng : Double);

    procedure SelectGroup(const name : string);

   // procedure doStreamLoad(Sender : TObject);
   // procedure doShapesLoad(Sender : TObject);


    procedure doEndSaveToOLT(Sender : TObject);

    procedure doOnRead(const percentage : Integer; var cancel : Boolean);
    procedure doOnLoaded(Sender : TObject);

  //  procedure doLoadGeoJSON(Sender : TObject);

    procedure ClearAllData;

    procedure Area_Bounds;

    procedure StartAnimInfo(const info : string;
      const Gauge : TInfoGauge = igInfinite);
    procedure StopAnimInfo;

    procedure UpdateCircleProgress(const PercentValue : Integer);

    procedure ResetSelect;

  public
    { Déclarations publiques }
  end;

var
  Form2 : TForm2;

implementation

{$R *.fmx}

uses UDialogMapOlt,
     // default OSM styles
     uecOSMStyles_standard;



// hack for auto complete edit
procedure TComboEdit.KeyDown(var Key : Word; var KeyChar : System.WideChar;
  Shift : TShiftState);
var
  aStr : string;
  I, j : Integer;
begin
  if Key = vkReturn then
  begin
    if assigned(OnChange) then
      OnChange(self);

    exit;
  end;

  j := self.SelStart;

  if (KeyChar in [chr(48) .. chr(57)]) or (KeyChar in [chr(65) .. chr(90)]) or
    (KeyChar in [chr(97) .. chr(122)]) then
  begin

    Keys := copy(text, 1, SelStart) + KeyChar;

    // lookup item
    for I := 0 to count - 1 do
      if pos(Keys, items[I]) = 1 then
      begin
        itemindex := I;

        if assigned(OnChange) then
          OnChange(self);

        self.SelStart := j + 1;
        exit;
      end;
  end;
  inherited;
end;
//------------------------------------------------------------------------------



// Format file byte size
function FormatByteSize(const bytes : int64) : string;
const
  B = 1; // byte
  KB = 1024 * B; // kilobyte
  MB = 1024 * KB; // megabyte
  GB = 1024 * MB; // gigabyte
begin
  if bytes > GB then
    result := FormatFloat('#.## GB', bytes / GB)
  else
    if bytes > MB then
      result := FormatFloat('#.## MB', bytes / MB)
    else
      if bytes > KB then
        result := FormatFloat('#.## KB', bytes / KB)
      else
        result := FormatFloat('#.## bytes', bytes);
end;

function FormatMS(MilliSecondes : Cardinal) : string;
var
  Hour, Min, Sec : Cardinal;
begin
  Hour := MilliSecondes div 3600000;
  MilliSecondes := MilliSecondes mod 3600000;
  Min := MilliSecondes div 60000;
  MilliSecondes := MilliSecondes mod 60000;
  Sec := MilliSecondes div 1000;
  MilliSecondes := MilliSecondes mod 1000;
  result := Format('%.2d:%.2d:%.2d', [Hour, Min, Sec]);
end;

// ----------------------------------------------------------------------------



procedure TForm2.FormCreate(Sender : TObject);
begin

  

  SaveOLT.visible := false;
  AniSave.visible := false;

  StopAnimInfo;

  FMemoryStream := TMemoryStream.Create;

  InfosFile.visible := false;



  map.ScaleMarkerToZoom := true;


  map.OverSizeForRotation := true;

  map.OnMapSelectChange := mapMapSelectChange;

  map.LocalCache := ExtractfilePath(ParamStr(0)) + 'cache';

  map.styles.GraphicDirectory := ExtractfilePath(ParamStr(0)) +    'all_maki_icons\svgs\';


  // change the map style
  // see uecOSMStyles_standard
  map.styles.Rules := UEC_OSM_STYLESHEET;

 
  setLength(ItemKey, 100);
  setLength(ItemValue, 100);

  //
  FOSMFile          := TOSMFile.Create;
  // call for each block read
  FOSMFile.OnRead   := doOnRead;
  // call when parsing is finish
  FOSMFile.OnLoaded := doOnLoaded;


end;
// -----------------------------------------------------------------------------



// open OSM / OLT file
procedure TForm2.OpenOSMFileClick(Sender : TObject);
begin

  if OpenDialogOSM.Execute then
  begin

    map.Clear;

    // don't parse, get just infos like bounds
    FOSMFile.FilterPrimitive := [];

    if FOSMFile.LoadFromFile(OpenDialogOSM.filename) then
    begin

      // if OSM show button for convert to OLT
      SaveOLT.visible := FOSMFile.FileFormat = ftOSM;

      filename.text := FormatByteSize(FOSMFile.FileSize) + ' ' +
        ExtractFilename(FOSMFile.filename);

      Area_Bounds;

      ResetSelect;

      InfosFile.visible := true;

    end;

  end;
end;
//------------------------------------------------------------------------------



// save in compressed format .olt
 procedure TForm2.SaveOLTClick(Sender : TObject);
var Primitives  : TSetPrimitiveOSM;
begin

  AniSave.visible := true;
  AniSave.Enabled := true;

   if NodeCheck.IsChecked then
    Primitives := Primitives + [poNode];

  if WayCheck.IsChecked then
   Primitives := Primitives + [poWay];

  if RelationCheck.IsChecked then
     Primitives := Primitives + [poRelation];


  // save in a thread, you can use FOSMFile
  // doEndSaveToOLT is call when file is saved
  FThreadOSMToOLT := OSMFileToOLT(FOSMFile.filename,Primitives, doEndSaveToOLT);


end;
//------------------------------------------------------------------------------


// call when olt is saved
procedure TForm2.doEndSaveToOLT(Sender : TObject);
begin
  // here your osm file is savec in .olt
  SaveOLT.visible :=  FSaveArea;

  AniSave.Enabled := false;
  AniSave.visible := false;
  FThreadOSMToOLT := nil;
  FSaveArea       := false;
end;
// -----------------------------------------------------------------------------






// To handle files of several gigabytes, file is analyzed chunck by chunck,
// each loaded buffet triggers this event
procedure TForm2.doOnRead(const percentage : Integer;
  var cancel : Boolean);
begin

  UpdateCircleProgress(percentage);

  KeyCount.text   := Format('(%d)', [FOSMFile.Keys.count]);
  ValueCount.text := Format('(%d)', [FOSMFile.values.count]);
  NodeCount.text  := Format('%d', [FOSMFile.Nodes.count]);
  WayCount.text   := Format('%d', [FOSMFile.ways.count]);


end;
//------------------------------------------------------------------------------



// this event is fired when osm-olt file is parsed
procedure TForm2.doOnLoaded(Sender : TObject);
var
  L : TStringList;
  I : Integer;
  incomplet : string;
  NELat, NELng, SWLat, SWLng : double;
begin

  StopAnimInfo;

  // get all keys
  L := TStringList.Create;
  try

    FOSMFile.Keys.getStrings(L);

    L.Sort;

    Keys.items.Assign(L);

  finally
    L.Free;
  end;


  // get all relations

  RelationCount.Text := inttostr(FOSMFile.Relations.count);
  Relations.items.BeginUpdate;

  for I := 0 to FOSMFile.Relations.count - 1 do
  begin

   if FOSMFile.Relations[I].Complete then
     incomplet:=''
   else
     incomplet:='(incomplet)';

   Relations.items.Add( FOSMFile.Relations.ReadKey(I,'type')+  ' (' +
      inttostr(FOSMFile.Relations[I].count) + ')'+incomplet);

  end;

  Relations.items.EndUpdate;

  if FOSMFile.Aborted then exit;


  // load data in map or save in olt format

  // isLoadInMap is in UDialogMapOlt
  if isLoadInMap(self) then
  begin
    StartAnimInfo('Load in map...');
    FOSMFile.ToShapes(map.Shapes) ;
  end
  else
  begin

  if not FSaveArea then
  begin
   FSaveArea := true;

   AniSave.visible := true;
   AniSave.Enabled := true;

   FOSMFile.FilterBounds.get(0,NELat, NELng, SWLat, SWLng);

   FOSMFile.saveToFile(FOSMFile.Filename+
                          '['+
                             doubleToStrDigit(NELat,5)+','+
                             doubleToStrDigit(NELng,5)+','+
                             doubleToStrDigit(SWLat,5)+','+
                             doubleToStrDigit(SWLng,5)+
                          '].olt',doEndSaveToOLT);
  end
  else  ShowMessage('Wait for the end of the previous save !');

    ResetSelect;

  end;



end;
//------------------------------------------------------------------------------



procedure TForm2.mapMapPaint(sender: TObject; const canvas: TECCanvas);
begin
{$IFDEF DEBUG}
 InfosCaption;
{$ENDIF}
end;

procedure TForm2.mapMapSelectChange(Sender : TObject; const SWLat, SWLng, NELat,
  NELng : Double);
begin
  StartAnimInfo(DoubleToStrDigit(map.SelectedArea, 4) + ' km²', igNone);
end;
//------------------------------------------------------------------------------



// call when the selection of the area is completed
procedure TForm2.mapMapSelectRect(Sender : TObject; const SWLat, SWLng, NELat,
  NELng : Double);
begin

  FOSMFile.FilterBounds.Clear;
  FOSMFile.FilterBounds.Add(NELat, NELng, SWLat, SWLng);
  FOSMFile.FilterPrimitive := [];

  FOSMFile.FilterWay.clear;


 // here you can define filters
 (*
  // keep the nodees only if he has a amenity key (regardless of value)
  FOSMFile.FilterNode.OnlyIfKeyExist('amenity');
  // keep all ways except those with key building
  FOSMFile.FilterWay.ExcludeIfKeyExist('building');
  // keep the ways only if he has a building key
  FOSMFile.FilterWay.OnlyIfKeyExist('building');

  FOSMFile.FilterWay.ExcludeKeyValue('leisure','park');
  FOSMFile.FilterWay.ExcludeKeyValue('natural','coastline');
  *)


  if NodeCheck.IsChecked then
    FOSMFile.FilterPrimitive := FOSMFile.FilterPrimitive + [poNode];

  if WayCheck.IsChecked then
    FOSMFile.FilterPrimitive := FOSMFile.FilterPrimitive + [poWay];

  if RelationCheck.IsChecked then
    FOSMFile.FilterPrimitive := FOSMFile.FilterPrimitive + [poRelation];

  // [poNode,poWay,poRelation];

  if FOSMFile.Reload then
  begin
    map.DragRect := drNone;
    StartAnimInfo('Parsing osm data...', igProgressCircle);
    ClearAllData;
  end;
end;
//------------------------------------------------------------------------------




// call when all data is charged and visible in map
procedure TForm2.mapChangeMapZoom(Sender: TObject);
begin
 InfosCaption;
end;

procedure TForm2.InfosCaption;
begin
 caption := 'OSMViewer for TECNativeMap - © ' + inttostr(CurrentYear) +
    ' E. Christophe - Zoom : '+inttostr(map.Zoom);

 {$IFDEF DEBUG}
  caption := caption+' '+inttostr(map.CalculTime)+'('+inttostr(map.ShapeListToDrawTime)+') - '+inttostr(map.DrawTime);
 {$ENDIF}

end;

procedure TForm2.mapLoad(Sender : TObject; const GroupName : string;
  const FinishLoading : Boolean);
var
  I : Integer;
begin

  if GroupName = '' then
  begin
    StopAnimInfo;
    ResetSelect;
    exit;
  end;

  SearchLabel.text := inttostr(map.group[GroupName].count);

  I := Groups.items.IndexOf(GroupName);

  if I = -1 then
    I := Groups.items.Add(GroupName);

  Groups.itemindex := I;

  SelectGroup(GroupName);

end;
// -----------------------------------------------------------------------------







procedure TForm2.FormCloseQuery(Sender : TObject; var CanClose : Boolean);
begin

 if not AniSave.Enabled then
 begin

   if assigned(selected_shape) then
   begin
    selected_shape.Animation := nil;
    selected_shape := nil;
   end;

   FOSMFile.Abort;
 end

 else begin

        CanClose := (MessageDlg('Abort file conversion ?', TMsgDlgType.mtConfirmation,
        [TMsgDlgBtn.mbYes, TMsgDlgBtn.mbNo], 0) = mrYes);


        if CanClose then
        begin
         FThreadOSMToOLT.abort;
        end;

      end;

end;


procedure TForm2.BaseMapChange(Sender : TObject);
begin

  if BaseMap.IsChecked then
    map.TileServer := tsOSM
  else
    map.TileServer := tsNone;

end;



// Search nodes

procedure TForm2.searchnodesClick(Sender : TObject);
var
  G : TECShapes;
begin

  if Keys.text = '' then
    exit;
  if values.text = '' then
    exit;

  if assigned(selected_shape) then
  begin
    selected_shape.Animation := nil;
    selected_shape := nil;
  end;

  // create group for this search
  G := map.group[Keys.text + '_' + values.text];

  G.Clear;
  G.ZIndex := 100;

  map.styles.addRule('#' + G.name + '.marker{visible:true;color:' +
    ColorToHtml(ColorBox.Color) + '}');

  // search in all data
  FOSMFile.Nodes.search(Keys.text, values.text);

  // you can also limit the search to a specific area,
  // such as the visible area of the map
  (*
  FOSMFile.Nodes.search( map.SouthWestLatitude,map.SouthWestLongitude,
                        map.NorthEastLatitude, map.NorthEastLongitude,
                        Keys.text, values.text);
  *)

  // show result on map

  FOSMFile.Nodes.SearchResult.ToShapes(G);

end;


// Search Ways

procedure TForm2.searchwayClick(Sender : TObject);
var
  G : TECShapes;
  sc : string;
begin

  if Keys.text = '' then
    exit;
  if values.text = '' then
    exit;

  if assigned(selected_shape) then
  begin
    selected_shape.Animation := nil;
    selected_shape := nil;
  end;

  // create a group for this search
  G := map.group[Keys.text + '_' + values.text];

  G.Clear;

  G.ZIndex := 100;

  sc := ColorToHtml(ColorBox.Color);

  map.styles.addRule('#' + G.name + '.line {scale:0.8;color:' + sc + '}');

  map.styles.addRule('#' + G.name + '.marker{scale:1;color:' +
    ColorToHtml(GetShadowColorBy(ColorBox.Color, 32)) + '}');

  map.styles.addRule('#' + G.name + '.polygone {weigth:2;color:' + sc +
    ';fcolor:' + sc + '}');

  map.styles.addRule('#' + G.name +
    '.polygone:hover {fopacity:100;weigth:3;hbcolor:' + sc +
    ';fcolor:' + sc + '}');

  // search in all data
  FOSMFile.ways.search(Keys.text, values.text);

   // you can also limit the search to a specific area,
  // such as the visible area of the map
  (*
  FOSMFile.ways.search( map.SouthWestLatitude,map.SouthWestLongitude,
                        map.NorthEastLatitude, map.NorthEastLongitude,
                        Keys.text, values.text);
  *)

  // show result on map
  FOSMFile.ways.SearchResult.ToShapes(G);
end;

// see https://github.com/OneChen/ProgressCircle
procedure TForm2.UpdateCircleProgress(const PercentValue : Integer);
begin
  if PercentValue <> 0 then
    ProgressCircleArc.EndAngle := 360 / (100 / PercentValue)
  else
    ProgressCircleArc.EndAngle := 0;
  ProgressCircleText.text := inttostr(PercentValue) + '%';
end;

procedure TForm2.RelationsChange(Sender : TObject);
var
  id, I, j : Integer;
  R : TRelationOSM;
  M : TMemberOSM;
begin
  map.Selected.UnSelectedAll;

  id := Relations.itemindex;

  if id < 0 then
    exit;

  R := FOSMFile.Relations[id];

  j := FOSMFile.CountKey(R);

  GridProperty.RowCount := j;
  setLength(ItemKey, j);
  setLength(ItemValue, j);

  for I := 0 to j - 1 do
  begin

    ItemKey[I]   := FOSMFile.getKey(R, I);
    ItemValue[I] := FOSMFile.getValue(R, I);

    ColKeys.UpdateCell(I);
    ColValues.UpdateCell(I);

  end;

  j := R.count - 1;

  for I := 0 to j do
  begin
    M := R.Member[I];

    map.Selected.ByKeyValue('id', inttostr(M.Ref));

  end;

  map.Selected.fitBounds;

end;

procedure TForm2.ResetSelect;
begin
  StartAnimInfo('Right click + drag to select the area to explore', igNone);
  map.DragRect := drSelect;
end;






(*
procedure TForm2.doShapesLoad(Sender : TObject);
begin
  StopAnimInfo;
  ResetSelect;
end;

procedure TForm2.doStreamLoad(Sender : TObject);
begin
  StopAnimInfo;
  StartAnimInfo('Load from GeoJSON Stream...');

  FMemoryStream.Position := 0;
  // FMemoryStream.SaveTofile(FOSMFile.filename+'-'+inttostr(gettickcount) + '._geojson');
  map.Shapes.ASyncLoadFromGeoJSONStream(FMemoryStream);

end;
*)

procedure TForm2.StopAnimInfo;
begin
  Ani.visible := false;
  Ani.Enabled := false;
  ProgressCircle.visible := false;
  WaitInfo.visible := false;
  timing.visible := false;
  timing.text := '';
  Timer1.Enabled := false;
end;

procedure TForm2.Timer1Timer(Sender : TObject);
begin
  timing.text := FormatMS(GettickCount - Timer1.tag);
end;

procedure TForm2.StartAnimInfo(const info : string;
  const Gauge : TInfoGauge = igInfinite);
begin
  Ani.visible := Gauge = igInfinite;
  Ani.Enabled := Ani.visible;
  UpdateCircleProgress(0);
  ProgressCircle.visible := Gauge = igProgressCircle;
  WaitInfo.text := info;
  WaitInfo.visible := true;

  timing.visible := ProgressCircle.visible;
  Timer1.tag := GettickCount;
  Timer1.Enabled := ProgressCircle.visible;
end;

(*
procedure TForm2.doLoadGeoJSON(Sender : TObject);
var
  filename : string;
begin

  StopAnimInfo;

  filename := FOSMFile.filename + '.geojson';

  StartAnimInfo('Loading ' + ExtractFilename(filename) + '...');

  map.Shapes.toGeoJSon := '@' + filename;
end;
*)

procedure TForm2.FormDestroy(Sender : TObject);
begin
  FMemoryStream.Free;
  FOSMFile.Free;
end;

procedure TForm2.GridPropertyGetValue(Sender : TObject; const ACol,
  ARow : Integer; var Value : TValue);
begin
  case ACol of
  0 : Value := ItemKey[ARow];
  1 : Value := ItemValue[ARow];
  end;
end;

procedure TForm2.GroupDeleteClick(Sender : TObject);
begin
  if Groups.itemindex < 0 then
    exit;

  map.group[Groups.items[Groups.itemindex]].Remove;

  Groups.items.Delete(Groups.itemindex);

end;

procedure TForm2.GroupItemChange(Sender : TObject);
begin

  if GroupItem.itemindex < 0 then
    exit;

  if assigned(selected_shape) then
    selected_shape.Animation := nil;

  selected_shape := TECShape(GroupItem.items.Objects[GroupItem.itemindex]);

  selected_shape.Animation := TecAnimationBlink.Create;

  map.Selected.Clear;
  selected_shape.Selected := true;
  map.Zoom := map.MaxZoom;
  map.setCenter(selected_shape.Latitude, selected_shape.Longitude);

end;

procedure TForm2.GroupsChange(Sender : TObject);
begin
  if Groups.itemindex < 0 then
    exit;

  map.group[Groups.items[Groups.itemindex]].fitBounds;

  if map.group[Groups.items[Groups.itemindex]].visible then
  begin
    GroupVisible.text := 'Hide';
  end
  else
    GroupVisible.text := 'Show';

  SelectGroup(Groups.items[Groups.itemindex]);

end;

procedure TForm2.GroupVisibleClick(Sender : TObject);
var
  G : TECShapes;
begin
  if Groups.itemindex < 0 then
    exit;

  G := map.group[Groups.items[Groups.itemindex]];

  G.visible := not G.visible;

  if G.visible then
    GroupVisible.text := 'Hide'
  else
    GroupVisible.text := 'Show';

end;

procedure TForm2.keysChange(Sender : TObject);
var
  L : TStringList;
begin

  if Keys.itemindex < 0 then
    exit;

  L := TStringList.Create;
  try

    FOSMFile.ReadValuesForKey(Keys.items[Keys.itemindex], L);

    values.items.Assign(L);

  finally
    L.Free;
  end;



end;

procedure TForm2.SelectGroup(const name : string);
var
  I : Integer;
  item : TECShape;
  G : TECShapes;
begin

  G := map.group[name];

  GroupItem.items.BeginUpdate;
  GroupItem.items.Clear;

  for I := 0 to G.Markers.count - 1 do
    GroupItem.items.Addobject(G.Markers[I].PropertyValue['name'], G.Markers[I]);

  for I := 0 to G.Lines.count - 1 do
    GroupItem.items.Addobject(G.Lines[I].PropertyValue['name'], G.Lines[I]);

  for I := 0 to G.Polygones.count - 1 do
    GroupItem.items.Addobject(G.Polygones[I].PropertyValue['name'],
      G.Polygones[I]);

  SearchLabel.text := inttostr(G.count);

  GroupItem.items.EndUpdate;

end;





procedure TForm2.ClearAllData;
begin
  if assigned(selected_shape) then
    selected_shape.Animation := nil;

  selected_shape := nil;

  Keys.items.Clear;
  values.items.Clear;
  Keys.itemindex := -1;

  SearchLabel.text := '';

  Groups.items.Clear;
  GroupItem.items.Clear;
  Relations.items.Clear;

  map.Shapes.Clear;
end;



procedure TForm2.mapShapeClick(Sender : TObject; const item : TECShape);
var
  Key, Value : string;
  I          : Integer;
begin

  I := 0;
  if item.PropertiesFindFirst(Key, Value) then
  begin
    repeat

      if Key = 'ecshape' then
        continue;

      setLength(ItemKey, I + 1);
      setLength(ItemValue, I + 1);
      GridProperty.RowCount := I + 1;

      ItemKey[I] := Key;
      ItemValue[I] := Value;

      ColKeys.UpdateCell(I);
      ColValues.UpdateCell(I);

      inc(I);

    until item.PropertiesFindNext(Key, Value);
  end;

end;

procedure TForm2.ArcDial1Change(Sender: TObject);
begin
  map.RotationAngle := ArcDial1.Value;
  map.OverSizeForRotation := map.RotationAngle <> 0;
end;

procedure TForm2.ArcDial1DblClick(Sender: TObject);
begin
  ArcDial1.Value := 0;
  map.RotationAngle := ArcDial1.Value;
  map.OverSizeForRotation := map.RotationAngle <> 0;
end;

procedure TForm2.Area_Bounds;
var
  G : TECShapes;
begin
  G := map.group['osm-area'];
  G.Clear;
  G.Lines.Add([FOSMFile.Bounds.NELat, FOSMFile.Bounds.NELng,
    FOSMFile.Bounds.SWLat, FOSMFile.Bounds.NELng,
    FOSMFile.Bounds.SWLat, FOSMFile.Bounds.SWLng,
    FOSMFile.Bounds.NELat, FOSMFile.Bounds.SWLng,
    FOSMFile.Bounds.NELat, FOSMFile.Bounds.NELng]);

  G.Lines[0].HoverColor := G.Lines[0].Color;
  G.Lines[0].Opacity := 75;
  G.Lines[0].Clickable := false;

  map.fitBounds(FOSMFile.Bounds.NELat, FOSMFile.Bounds.NELng,
    FOSMFile.Bounds.SWLat, FOSMFile.Bounds.SWLng);
end;





end.
