unit UDemoNativeLocalise;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  uecNativePlace, uecNativeShape, UECMapUtil, ExtCtrls, StdCtrls, Grids,
  uecGeoLocalise,
  uecNativeMapControl;

type

  TFDemoNativeLocalise = class(TForm)
    Panel1: TPanel;
    Panel2: TPanel;
    Panel3: TPanel;
    Label2: TLabel;
    adresse: TComboBox;
    btGo: TButton;
    GroupBox1: TGroupBox;
    Label3: TLabel;
    radius: TEdit;
    Label4: TLabel;
    btFindPlaces: TButton;
    ckStore: TRadioButton;
    ckRestaurant: TRadioButton;
    Panel4: TPanel;
    Panel5: TPanel;
    place: TComboBox;
    results: TStringGrid;
    btClear: TButton;
    map: TECNativeMap;
    TimerPlaces: TTimer;
    tileserver: TComboBox;
    Label1: TLabel;
    abort: TButton;

    procedure mapMapClick(sender: TObject; const dLatitude, dLongitude: Double);

    procedure Panel1Resize(sender: TObject);
    procedure btGoClick(sender: TObject);
    procedure AdresseKeyPress(sender: TObject; var Key: Char);
    procedure FormCreate(sender: TObject);

    procedure btFindPlacesClick(sender: TObject);
    procedure mapPlacesSearch(sender: TObject);
    procedure btClearClick(sender: TObject);
    procedure Panel4Resize(sender: TObject);
    procedure placeClick(sender: TObject);
    procedure radiusChange(sender: TObject);
    procedure mapPlacesDetail(sender: TObject);
    procedure resultsDrawCell(sender: TObject; aCol, aRow: Integer;
      Rect: TRect; State: TGridDrawState);
    procedure mapBeforeChangeMapApi(sender: TObject);

    procedure mapAfterReload(sender: TObject);
    procedure FormClose(sender: TObject; var Action: TCloseAction);

    procedure mapShapeClick(sender: TObject; const item: TECShape);
    procedure adresseClick(sender: TObject);
    procedure mapShapeDragEnd(sender: TObject);
    procedure TimerPlacesTimer(sender: TObject);
    procedure tileserverClick(Sender: TObject);
    procedure abortClick(Sender: TObject);
  private
    { Déclarations privées }
    FStartPlace: Integer;
    idSelected : integer;

    procedure doShowPlaces(const idPlace: Integer);
    procedure doClearPlaces;

    procedure doClearGrids;

    procedure AddDefaultMarker;
    procedure showSearchArea;
  public
    { Déclarations publiques }
  end;

var
  FDemoNativeLocalise: TFDemoNativeLocalise;

implementation

{$R *.DFM}

procedure TFDemoNativeLocalise.Panel1Resize(sender: TObject);
begin
  btGo.Left := Panel1.Width - btGo.Width - 7;
  adresse.Width := btGo.Left - 14 - adresse.Left;
end;

{ *
  click on the map
}
procedure TFDemoNativeLocalise.mapMapClick(sender: TObject; const dLatitude,
  dLongitude: Double);
begin

  map.shapes.Markers[0].setPosition(dLatitude, dLongitude);

  showSearchArea;
end;

procedure TFDemoNativeLocalise.btGoClick(sender: TObject);
var
  i: Integer;
begin

  map.address := adresse.Text;

  map.shapes.Markers[0].setPosition(map.latitude, map.longitude);
  showSearchArea;
end;

procedure TFDemoNativeLocalise.FormClose(sender: TObject; var Action: TCloseAction);
begin
  Action := caFree;
end;

procedure TFDemoNativeLocalise.FormCreate(sender: TObject);
begin
  Panel1Resize(nil);

  results.Cells[0, 0] := 'Key';
  results.Cells[1, 0] := 'Value';

  radius.Text := '1000';

  map.LocalCache := extractfilepath(application.exename)+'cache';

  map.GeoLocalise.OnSearch := mapPlacesSearch;

  tileserver.ItemIndex := 2;

  AddDefaultMarker;

end;

procedure TFDemoNativeLocalise.abortClick(Sender: TObject);
begin
 map.GeoLocalise.AbortPlaceSearch;
end;

procedure TFDemoNativeLocalise.AddDefaultMarker;
begin

  map.address:='paris';

  map.shapes.Markers.add(map.latitude, map.longitude);

  map.shapes.Markers[0].filename :=
    'http://maps.google.com/mapfiles/ms/micons/red-pushpin.png';
  map.shapes.Markers[0].Draggable := true;

  idSelected := map.shapes.Markers.add(map.latitude, map.longitude);
  map.shapes.Markers[idSelected].ZIndex    := 101;
  map.shapes.Markers[idSelected].visible   := false;
  map.shapes.Markers[idSelected].draggable := false;

 // start animation for 20 cycles
  map.shapes.Markers[idSelected].Animation := TECAnimationShapeColor.create(20);
  // 1 cyble every 250 ms
  map.shapes.Markers[idSelected].Animation.Timing := 250;


  map.shapes.InfoWindows.add(0,0,'');
  map.shapes.infowindows[0].visible := false;
  map.shapes.infowindows[0].ZIndex  := 20;



  showSearchArea;
end;

procedure TFDemoNativeLocalise.adresseClick(sender: TObject);
begin

 if map.GEoLocalise.SearchCount  = 0 then
begin
  ShowMessage('no result');
  Exit;
end;
  map.setCenter(map.GEoLocalise.SearchResult[adresse.itemindex].latitude,
    map.GEoLocalise.SearchResult[adresse.itemindex].longitude);

  map.shapes.Markers[0].setPosition(map.latitude, map.longitude);
  showSearchArea;

end;

procedure TFDemoNativeLocalise.AdresseKeyPress(sender: TObject; var Key: Char);
var
  gr: TECGeoResult;
begin
  if Key = #13 then
  begin
    map.GEoLocalise.Search(adresse.Text);

    if map.GEoLocalise.SearchCount  = 0 then
    begin
    ShowMessage('no result');
    Exit;
   end;

    adresse.Items.assign(map.GEoLocalise.SearchResults);
    // goto first address
    gr := map.GEoLocalise.SearchResult[0];
    map.setCenter(gr.latitude, gr.longitude);

    map.shapes.Markers[0].setPosition(map.latitude, map.longitude);
    showSearchArea;

  end;

end;

procedure TFDemoNativeLocalise.btFindPlacesClick(sender: TObject);
var
  Tags: string;
  isOSM: boolean;
begin

  btFindPlaces.enabled := false;

  Abort.visible := true;

  application.ProcessMessages;

  map.setCenter(map.shapes.Markers[0].latitude, map.shapes.Markers[0]
      .longitude);

  map.GEoLocalise.Places.latitude := map.latitude;
  map.GEoLocalise.Places.longitude := map.longitude;

  if ckStore.checked then
    Tags := 'node[shop=*]'
  else if ckRestaurant.checked then
    Tags := 'node[amenity=restaurant]';

  doClearPlaces;

  map.GEoLocalise.Places.radius := StrToInt(radius.Text);

  map.GEoLocalise.Places.Search(Tags);

  TimerPlaces.enabled := true;
end;

procedure TFDemoNativeLocalise.mapPlacesSearch(sender: TObject);
var
  i, max: Integer;
  iMarker: Integer;
  icon, types, names: string;

begin

  place.Items.clear;

  TimerPlaces.enabled := false;

  btFindPlaces.enabled := (radius.Text <> '')
    and not map.GEoLocalise.Places.searching;

  abort.visible := false;

  if map.GEoLocalise.Places.Status <> 'OK' then
    exit;

  WaitFor(100);


  FStartPlace := 1;

  max := map.GEoLocalise.Places.results.count - 1;

  map.BeginUpdate;

  map.shapes.Markers.clear;

  AddDefaultMarker;

  place.Items.BeginUpdate;

  for i := 0 to max do
  begin

    types := map.GEoLocalise.Places.results[i].result['types'];
    names := map.GEoLocalise.Places.results[i].result['name'];

    if names = '' then
      names := 'unknown';

    iMarker := map.shapes.Markers.add(map.GEoLocalise.Places.results[i].latitude,
      map.GEoLocalise.Places.results[i].longitude);

    if (iMarker > -1) and (iMarker<map.shapes.Markers.count) then
    begin

     if ckStore.checked then
       map.shapes.Markers[iMarker].color := clGreen;
      
      map.shapes.Markers[iMarker].Clickable := true;
      map.shapes.Markers[iMarker].StyleIcon := siFlat;
     map.shapes.Markers[iMarker].width := 12 ;
      map.shapes.Markers[iMarker].tag := FStartPlace + place.Items.add(names);
      map.shapes.Markers[iMarker].hint := names;
      // map.Markers[iMarker].IconSize   := Point(37,32);

    end;

  end;

  place.Items.EndUpdate;

  (* *)

  map.EndUpdate;

 doShowPlaces(0);
end;

procedure TFDemoNativeLocalise.mapShapeClick(sender: TObject; const item: TECShape);
var
  marker: TECShapeMarker;
begin

  if item is TECShapeMarker then
  begin
    marker := TECShapeMarker(item);

    if (marker.id > 0) and (map.shapes.Markers[marker.id].tag >= FStartPlace)
      then
      doShowPlaces(map.shapes.Markers[marker.id].tag - FStartPlace);
  end;
end;

procedure TFDemoNativeLocalise.mapShapeDragEnd(sender: TObject);
begin

  showSearchArea;

end;

procedure TFDemoNativeLocalise.showSearchArea;
var
  latSW, lngSW, latNE, lngNE: Double;
begin



  if (map.shapes.Markers.count > 0) then
  begin



    boundingCoordinates(map.shapes.Markers[0].latitude, map.shapes.Markers[0]
        .longitude, StrToDouble(radius.Text) / 1000, // transform meters in km
      latSW, lngSW, latNE, lngNE);




    (*map.shapes.Polygones.clear;
    map.shapes.Polygones.add(latSW, lngSW); ;
    map.shapes.Polygones[0].fillColor := clBlue;
    map.shapes.Polygones[0].hoverColor := clBlue;
    map.shapes.Polygones[0].ZIndex := -1;

    map.shapes.Polygones[0].Opacity := 10;

    map.shapes.Polygones[0].add(latSW, lngNE);
    map.shapes.Polygones[0].add(latNE, lngNE);
    map.shapes.Polygones[0].add(latNE, lngSW);
    map.shapes.Polygones[0].add(latSW, lngSW);
    map.shapes.Polygones[0].Clickable := false;*)
  end;



end;

procedure TFDemoNativeLocalise.tileserverClick(Sender: TObject);
begin
 case tileserver.ItemIndex of
  0 : map.TileServer := tsOpenMapQuest;
  1 : map.TileServer := tsOpenMapQuestSat;
  2 : map.TileServer := tsOSM;
  3 : map.TileServer := tsCloudMade;
  4 : map.TileServer := tsOpenCycleMap;
  else  map.TileServer := tsOPNV;
 end;
end;

procedure TFDemoNativeLocalise.TimerPlacesTimer(sender: TObject);
var tm:cardinal;
begin
  tm := map.GEoLocalise.AbortPlaceSearchIfMaxTime(40); // abort search after 30 secondes
  Abort.caption := 'Abort in '+inttostr(40-tm)+'s';
end;

procedure TFDemoNativeLocalise.doClearPlaces;
begin

  map.shapes.clear;

  doClearGrids;

  AddDefaultMarker;

end;

procedure TFDemoNativeLocalise.doClearGrids;
begin
  place.Items.clear;
  place.Text := '';

  results.RowCount := 2;
  results.Cells[0, 1] := '';
  results.Cells[1, 1] := '';

end;

procedure TFDemoNativeLocalise.btClearClick(sender: TObject);
begin
  doClearPlaces;
end;

procedure TFDemoNativeLocalise.Panel4Resize(sender: TObject);
begin
  results.ColWidths[0] := results.Width div 3;
  results.ColWidths[1] := results.Width - results.ColWidths[0];

  if (GetWindowlong(results.Handle, GWL_STYLE) and WS_VSCROLL) <> 0 then
    results.ColWidths[1] := results.ColWidths[1] - GetSystemMetrics
      (SM_CYVSCROLL);

end;

procedure TFDemoNativeLocalise.placeClick(sender: TObject);
begin
  doShowPlaces(place.itemindex);
end;

procedure TFDemoNativeLocalise.doShowPlaces(const idPlace: Integer);
var
  j: Integer;
  PlaceResult: TECPlaceResult;

  latSW, lngSW, latNE, lngNE: Double;
begin

  if (idPlace < 0) then
    exit;

  place.itemindex := idPlace;

  PlaceResult := map.GEoLocalise.Places.results[idPlace];

  if (PlaceResult = nil) then
    exit;

  if PlaceResult.countResult > 0 then
  begin
    results.RowCount := 1 + PlaceResult.countResult;

    for j := 0 to PlaceResult.countResult - 1 do
    begin

      results.Cells[0, 1 + j] := PlaceResult.NameResult[j];
      results.Cells[1, 1 + j] := PlaceResult.result[PlaceResult.NameResult[j]];

    end;

  end

  else

  begin
    results.RowCount := 2;
    results.Cells[0, 1] := '';
    results.Cells[1, 1] := '';
  end;

  map.BeginUpdate;

  boundingCoordinates(map.shapes.Markers[idPlace + 2].latitude,
    map.shapes.Markers[idPlace + 2].longitude, 0.1, latSW, lngSW, latNE, lngNE);

  map.shapes.Markers[idSelected].setPosition(map.shapes.Markers[idPlace + 2].latitude,
    map.shapes.Markers[idPlace + 2].longitude);

  map.shapes.Markers[idSelected].visible := true;
  map.shapes.Markers[idSelected].hint    := map.shapes.Markers[idPlace + 2].hint;

  // start animation for 20 cycles
  map.shapes.Markers[idSelected].Animation := TECAnimationShapeColor.create(20);
  // 1 cyble every 250 ms
  map.shapes.Markers[idSelected].Animation.Timing := 250;

  map.shapes.infowindows[0].content := '<b>'+map.shapes.Markers[idPlace + 2].hint+'</b>' +
  '<br><br>'+map.geolocalise.Reverse(map.shapes.Markers[idPlace + 2].latitude,
    map.shapes.Markers[idPlace + 2].longitude);
  map.shapes.infowindows[0].SetPosition(map.shapes.Markers[idPlace + 2].latitude,
    map.shapes.Markers[idPlace + 2].longitude);
  map.shapes.infowindows[0].visible := true;

  map.Bounds(latSW, lngSW, latNE, lngNE);

  map.EndUpdate;

end;

procedure TFDemoNativeLocalise.radiusChange(sender: TObject);
begin
  btFindPlaces.enabled := (radius.Text <> '')
    and not map.GEoLocalise.Places.searching;

  showSearchArea;
end;

procedure TFDemoNativeLocalise.mapPlacesDetail(sender: TObject);
begin
  doShowPlaces(place.itemindex);
end;

procedure TFDemoNativeLocalise.resultsDrawCell(sender: TObject; aCol, aRow: Integer;
  Rect: TRect; State: TGridDrawState);
begin
  With sender As TStringGrid Do
    With Canvas Do
    Begin

      Canvas.Font.Name := 'Tahoma';
      Canvas.Font.size := 8;

      If (aCol = 0) or (gdFixed in State) then
        Brush.Color := clBtnFace
      Else If gdSelected In State Then
        Brush.Color := clNavy
      Else
        Brush.Color := clWhite;

      FillRect(Rect);

      Pen.Color := cl3DLight;

      Pen.Width := 1;

      Moveto(Rect.Left, Rect.bottom - 1);
      Lineto(Rect.right - 1, Rect.bottom - 1);
      Lineto(Rect.right - 1, Rect.top - 1);

      if (aCol = 0) or (aRow = 0) then
        Canvas.Font.Style := [fsBold]
      else
        Canvas.Font.Style := [];

      If (gdSelected In State) and (aCol > 0) Then
        SetTextColor(Canvas.Handle, clWhite)
      Else
        SetTextColor(Canvas.Handle, clBlack);

      if (aCol = 0) or (aRow = 0) then

        DrawText(Canvas.Handle, PChar(Cells[aCol, aRow]), -1, Rect,
          DT_CENTER or DT_VCENTER or DT_NOPREFIX or DT_SINGLELINE)

      else
      begin
        Rect.top := Rect.top + 4;
        Rect.Left := Rect.Left + 2;
        Rect.right := Rect.right - 2;
        DrawText(Canvas.Handle, PChar(Cells[aCol, aRow]), -1, Rect,
          DT_CENTER or DT_NOPREFIX or DT_WORDBREAK);
      end;

    End;
end;

procedure TFDemoNativeLocalise.mapBeforeChangeMapApi(sender: TObject);
begin
  doClearPlaces;
end;

procedure TFDemoNativeLocalise.mapAfterReload(sender: TObject);
begin
  mapPlacesSearch(self);
end;

end.
