unit UMainNativeLinesPolygones;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, uecNativeMapControl,uecNativeshape,uecMapUtil, Buttons, ExtCtrls,uecGraphics,
  StdCtrls, ComCtrls,uecNativeMeasureMap, Vcl.Imaging.pngimage,uecNativePlaceLayer;

type
  TFormNativeLinePolygone = class(TForm)
    Bar_Menu: TPanel;
    SpeedPolyline: TSpeedButton;
    speedLoadMap: TSpeedButton;
    SpeedSaveMap: TSpeedButton;
    pn_latlng: TPanel;
    Infos: TPanel;
    map: TECNativeMap;
    SpeedPolygone: TSpeedButton;
    noshape: TSpeedButton;
    ColorDialog: TColorDialog;
    pnPolygone: TPanel;
    FillColor: TPanel;
    Label1: TLabel;
    Level: TEdit;
    Label4: TLabel;
    Transparence: TTrackBar;
    Panel1: TPanel;
    ColorBorder: TPanel;
    HoverColor: TPanel;
    pnHelpPoint: TPanel;
    Label2: TLabel;
    pnInfoSize: TPanel;
    OpenDialog: TOpenDialog;
    SaveDialog: TSaveDialog;
    Label6: TLabel;
    style: TComboBox;
    weight: TEdit;
    Label3: TLabel;
    lbPenStyle: TLabel;
    PenStyle: TComboBox;
    BColor: TPanel;
    BHColor: TPanel;
    Label5: TLabel;
    edtBSize: TEdit;
    ruler: TSpeedButton;
    Label7: TLabel;
    xapilayer: TComboBox;
    procedure mapShapeClick(sender: TObject; const item: TECShape);
    procedure mapMapClick(sender: TObject; const Lat, Lng: Double);
    procedure noshapeClick(Sender: TObject);
    procedure SpeedPolylineClick(Sender: TObject);
    procedure ColorBorderClick(Sender: TObject);
    procedure LevelChange(Sender: TObject);
    procedure TransparenceChange(Sender: TObject);
    procedure speedLoadMapClick(Sender: TObject);
    procedure SpeedSaveMapClick(Sender: TObject);
    procedure styleChange(Sender: TObject);
    procedure weightChange(Sender: TObject);
    procedure PenStyleChange(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure mapResize(Sender: TObject);
    procedure mapLoad(sender: TObject; const GroupName: string;
      const FinishLoading: Boolean);
    procedure mapMapMouseUp(sender: TObject; const Lat, Lng: Double);
    procedure rulerClick(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure xapilayerChange(Sender: TObject);
    procedure mapMapRightClick(sender: TObject; const Lat, Lng: Double);
    procedure mapShapeRightClick(sender: TObject; const item: TECShape);
  
  private
    { Déclarations privées }

    FSelectedShape : TECShape;

    FECNativeMeasureMap : TECNativeMeasureMap  ;

    InInfoshape    : boolean;

    procedure Editshape (const Value:boolean);
    procedure doUpdateShape;
    procedure doInfoShape;
    procedure doPathChange(sender : TObject);

    procedure doOnLayerClick(sender : TECShape) ;

    procedure doDrawHint(const canvas: TECCanvas; var r: TRect; Item: TECShape);


  public
    { Déclarations publiques }
  end;

var
  FormNativeLinePolygone: TFormNativeLinePolygone;

implementation

{$R *.dfm}

procedure TFormNativeLinePolygone.mapLoad(sender: TObject;
  const GroupName: string; const FinishLoading: Boolean);
begin
 if assigned(sender) and (sender is TECShapes) then
  TECShapes(sender).fitBounds;

      (*

      map.Shapes.Polygones[map.Shapes.Polygones.Count-1].Weight:=60;     // Works if file loaded is kml, but not if JSON
      map.Shapes.Polygones[map.Shapes.Polygones.Count-1].FillOpacity := 50;
      map.Shapes.Polygones[map.Shapes.Polygones.Count-1].Color:=clgreen;
      map.Shapes.Polygones[map.Shapes.Polygones.Count-1].FillColor:=clgreen;    // does not work, and if present makes outlines invisible
     // map.setCenter(map.Shapes.Polygones[map.Shapes.Polygones.Count-1].Centroid.lat,map.Shapes.Polygones[map.Shapes.Polygones.Count-1].Centroid.lng);  // works
  *)

end;

procedure TFormNativeLinePolygone.mapMapClick(sender: TObject; const Lat, Lng: Double);
begin

 if noshape.down then exit;


 if not assigned(FSelectedshape) then
 begin

   if SpeedPolygone.down then
   begin
    FSelectedshape := map.add(nsPolygon,Lat,Lng)    ;
    FSelectedshape.Hint := 'polygon '+inttostr(FSelectedshape.Id);
   end
   else
    if SpeedPolyline.Down then
    begin
    FSelectedshape := map.add(nsLine,Lat,Lng) ;
    TECshapeLine(FSelectedshape).bordersize := 2;
    end
   else exit;

  EditShape(true);
  doInfoShape;
  doUpdateShape;



 end else begin

         // if not key CTRL then add point
         if not((GetKeyState(VK_CONTROL) AND 128) = 128)  then
         begin


           if SpeedPolygone.down then

            TECshapePolygone(FSelectedshape).Add(Lat,Lng)
            else
            TECshapeLine(FSelectedshape).Add(Lat,Lng) ;

         end

         else  // if CTRL Pressed then move Shape

           FSelectedshape.SetPosition(lat,lng);

        end;

end;

procedure TFormNativeLinePolygone.mapMapMouseUp(sender: TObject; const Lat,
  Lng: Double);
begin
// map.Draggable := not((GetKeyState(VK_CONTROL) AND 128) = 128)    ;
// map.InertiaScroll := not((GetKeyState(VK_CONTROL) AND 128) = 128)    ;
end;


procedure BitmapGrayscale(ABitmap: TBitmap);
type
  PPixelRec = ^TPixelRec;
  TPixelRec = packed record
    B: Byte;
    G: Byte;
    R: Byte;
  end;
var
  X: Integer;
  Y: Integer;
  Gray: Byte;
  Pixel: PPixelRec;
begin
  ABitmap.PixelFormat := pf24bit;
  for Y := 0 to ABitmap.Height - 1 do
  begin
    Pixel := ABitmap.ScanLine[Y];
    for X := 0 to ABitmap.Width - 1 do
    begin
      Gray := Round((0.299 * Pixel.R) + (0.587 * Pixel.G) + (0.114 * Pixel.B));
      Pixel.R := Gray;
      Pixel.G := Gray;
      Pixel.B := Gray;
      Inc(Pixel);
    end;
  end;
end;

procedure ToGray(aBitmap: Graphics.TBitmap );

var w, h: integer; CurrRow, OffSet: integer;

  x: byte; pRed, pGreen, pBlue: PByte;

begin


    ABitmap.PixelFormat := pf24bit;



    CurrRow := Integer(aBitmap.ScanLine[0]);

    OffSet := Integer(aBitmap.ScanLine[1]) - CurrRow;



    for h := 0 to aBitmap.Height - 1 do

    begin

      for w := 0 to aBitmap.Width - 1 do

      begin

        pBlue  := pByte(CurrRow + w*3);

        pGreen := pByte(CurrRow + w*3 + 1);

        pRed   := pByte(CurrRow + w*3 + 2);

        x :=   Round((0.299 * pRed^) + (0.587 * pGreen^) + (0.114 * pBlue^));

        pBlue^  := x;

        pGreen^ := x;

        pRed^   := x;

      end;

      inc(CurrRow, OffSet);

    end;



end;



procedure TFormNativeLinePolygone.mapMapRightClick(sender: TObject; const Lat,
  Lng: Double);
var mrk:TECShapeMarker;
begin
  mrk := map.AddMarker(lat,lng);

  mrk.FileName := 'data:image/png;base64,iVBORw0KGgoAAA' +
      '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';


  mrk.YAnchor := 32;

  mrk.Angle := random(360);

  mrk.Hint := inttostr(mrk.Angle);

end;

procedure TFormNativeLinePolygone.mapResize(Sender: TObject);
begin
//
end;

procedure TFormNativeLinePolygone.mapShapeClick(sender: TObject; const item: TECShape);
begin




 if not assigned(item) or (item.Group.name<>'') then exit;


 if assigned(FSelectedshape) and (FSelectedshape is TECshapeLine) then
  TECshapeLine(FSelectedshape).Editable := false;



 FSelectedShape := Item;

 doInfoShape;


 Infos.visible := true;
 pnHelpPoint.visible := true;

 if item is TECShapePolygone then
 begin
  SpeedPolygone.down := true ;
  EditShape(true);
 end
 else
 if item is TECShapeLine then
 begin
  SpeedPolyline.Down := true;
  EditShape(true);
 end
  else
  begin
   Infos.visible := false;
   pnHelpPoint.visible := false;
   Noshape.down := true;
  end;



end;


procedure TFormNativeLinePolygone.mapShapeRightClick(sender: TObject;
  const item: TECShape);

var l:tstringlist;
    line,line1 : TECShapeLine;
    i:integer;
    mrk:TECShapeMarker;
begin

  exit;
  if item is TECShapeLine then
  begin
    //TECShapeLine(item).ShowDirection := not TECShapeLine(item).ShowDirection;


    i := TECShapeLine(item).Shapes.Markers.Add(TECShapeLine(item).Path[0].lat,TECShapeLine(item).Path[0].lng);
    mrk := TECShapeLine(item).Shapes.Markers[i];

    TECShapeLine(item).group.zindex := 100;

    TECShapeLine(item).Shapes.ZIndex := TECShapeLine(item).group.ZIndex + 1;

    TECShapeLine(item).Shapes.visible := true;

    mrk.Visible := true;

    mrk.FileName := 'http://www.helpandweb.com/car.png';
    map.styles.addRule('.marker:hover {scale:1.5;}');

  end;


end;

procedure TFormNativeLinePolygone.noshapeClick(Sender: TObject);
begin
 if noshape.down then
 begin
   EditShape(false);

   FSelectedshape := nil;

   Infos.visible := false;
   pnHelpPoint.visible := false;

   FECNativeMeasureMap.map := nil;
 end;

end;

procedure TFormNativeLinePolygone.PenStyleChange(Sender: TObject);
begin
 doUpdateShape;
end;

procedure TFormNativeLinePolygone.rulerClick(Sender: TObject);
begin
 EditShape(false);
 FSelectedshape := nil;

 Infos.visible := false;
 pnHelpPoint.visible := false;


 FECNativeMeasureMap.map := map;
 FECNativeMeasureMap.StartMeasure(map.latitude,map.longitude);

end;


procedure Showfullwindow(map:TECNativeMap;infowindow:TECShapeInfoWindow);
var pt:TPoint;
    delta : integer;
begin

 // Test left edge

 pt := map.WorldLeftTop;

 delta := InfoWindow.Left-map.WorldInfo.DeltaWidth*2;

 if delta < 0  then
 begin
  map.WorldLeftTop := point(pt.x+delta,pt.Y);
  pt               := map.WorldLeftTop;
 end;

 // Test right edge

 delta := (map.WorldInfo.DeltaWidth*2+map.WorldInfo.TrueWidth) - (InfoWindow.Left+InfoWindow.width) ;

 if infoWindow.Left+InfoWindow.width>map.WorldInfo.DeltaWidth*2+map.WorldInfo.TrueWidth then
 begin
    map.WorldLeftTop := point(pt.x-delta,pt.Y);
    pt               := map.WorldLeftTop;
 end;

 // test top edge

 delta :=  InfoWindow.Top-map.WorldInfo.DeltaHeight*2;

 if delta < 0  then
 begin
  map.WorldLeftTop := point(pt.x,pt.Y+delta);
  pt               := map.WorldLeftTop;
 end;


 // test bottom edge

  delta := (map.WorldInfo.Deltaheight*2+map.WorldInfo.Trueheight) - (InfoWindow.top+InfoWindow.height) ;

 if InfoWindow.Top+InfoWindow.height>map.WorldInfo.Deltaheight*2+map.WorldInfo.TrueHeight then
 begin
   map.WorldLeftTop := point(pt.x,pt.Y-delta);
 end;

end;

procedure TFormNativeLinePolygone.speedLoadMapClick(Sender: TObject);
var lat,lng,x:double;
begin

  //showfullwindow(map,map.XapiLayer.Shapes.InfoWindows[0]);exit;

(*
  lng := -180;


  while lng<>180 do
  begin


      map.AddLine([85,lng,-85,lng],'toto');

      x := 0;
      while lng+x<lng+36 do
      begin
       map.AddLine([85,lng+x,-85,lng+x],'toto');
       x := x+0.1;
      end;

      lng := lng+36;


  end;


  lat := -85;

  while lat<>85 do
  begin

      x := 0;
      map.AddLine([lat,180,lat,-180],'toto');

      while lat+x<lat+17 do
      begin
       map.AddLine([lat+x,180,lat+x,-180],'toto');
       x := x+0.05;
      end;

      lat := lat+17;


  end;


  exit;

  _MAX_GEOJSON_LINE := 1000000;  *)

 if OpenDialog.execute then
 // map.Shapes.ToGeoJSon := '@'+OpenDialog.filename;
 map.LoadFromFile(OpenDialog.filename);
end;

procedure TFormNativeLinePolygone.SpeedPolylineClick(Sender: TObject);
begin
  FECNativeMeasureMap.map := nil;
  EditShape(false);
  FSelectedshape := nil;
end;


procedure TFormNativeLinePolygone.SpeedSaveMapClick(Sender: TObject);
begin
  if SaveDialog.execute then
  map.SaveToFile(SaveDialog.filename);
end;

procedure TFormNativeLinePolygone.styleChange(Sender: TObject);
begin
 doUpdateShape;
end;

procedure TFormNativeLinePolygone.TransparenceChange(Sender: TObject);
begin
 doUpdateShape;
end;

procedure TFormNativeLinePolygone.weightChange(Sender: TObject);
begin
   doUpdateShape;
end;

procedure TFormNativeLinePolygone.xapilayerChange(Sender: TObject);
begin
 case xapilayer.ItemIndex of
  0 : begin
       map.XapiLayer.Visible := false;
  end;
  1 : begin
        map.XapiLayer.Visible := true;
        map.XapiLayer.Junction := false;
        map.XapiLayer.Search := 'way[highway=unclassified|road|motorway|trunk|primary|secondary|tertiary|residential]';
      end;
  2 : begin
        map.XapiLayer.Visible := true;
        map.XapiLayer.Junction := true;
        map.XapiLayer.Search := 'way[highway=unclassified|road|motorway|trunk|primary|secondary|tertiary|residential]';
      end;
  3 : begin
       map.XapiLayer.Visible := true;
       map.XapiLayer.Junction := false;
        map.XapiLayer.Search := 'way[waterway=river]';
  end;
  4 : begin
        map.XapiLayer.Visible := true;
        map.XapiLayer.Search := 'highway=bus_stop';
      end;
   5 : begin
        map.XapiLayer.Visible := true;
        map.XapiLayer.Junction := false;
        map.XapiLayer.Search := 'way[building=*]';
      end;
 end;

end;

procedure TFormNativeLinePolygone.ColorBorderClick(Sender: TObject);
begin
 if ColorDialog.execute then
 begin
  (Sender As TPanel).color := ColorDialog.color;

  doUpdateShape;
 end;
end;


procedure TFormNativeLinePolygone.doPathChange(sender : TObject);
begin

  if sender is TECShapePolygone then

  pnInfoSize.caption := 'Perimeter : '+doubleToStrDigit(TECShapePolygone(sender).Distance,4 )+' Km - Area : '+doubleToStrDigit(TECShapePolygone(sender).Area,4 )+' Km²'

  else

  if sender is TECShapeLine then

  pnInfoSize.caption := 'Distance : '+doubleToStrDigit(TECShapeLine(sender).Distance,4 )+' Km' ;


end;


procedure TFormNativeLinePolygone.doUpdateShape;
begin

 if not assigned(FSelectedshape) or InInfoshape then  exit;

 FSelectedshape.color                := ColorBorder.Color;
 FSelectedshape.HoverColor           := HoverColor.Color;
 TECShapeLine(FSelectedshape).Weight := StrToIntDef(weight.text,4);

 TECShapeLine(FSelectedshape).Bordercolor                := BColor.Color;
 TECShapeLine(FSelectedshape).HoverBorderColor           := BHcolor.Color;
 TECShapeLine(FSelectedshape).BorderSize := StrToIntDef(edtBSize.text,0);

 if (penstyle.itemindex>-1) then
     TECShapeLine(FSelectedshape).penstyle := TPenStyle(penstyle.itemindex);


 if FSelectedshape is TECShapePolygone then
 begin

  TECShapePolygone(FSelectedshape).color        := ColorBorder.Color;
  TECShapePolygone(FSelectedshape).Bordercolor  := ColorBorder.Color;
  TECShapePolygone(FSelectedshape).Weight := StrToIntDef(weight.text,4);


  TECShapePolygone(FSelectedshape).FillColor := FillColor.Color;
  TECShapePolygone(FSelectedShape).FillOpacity   := Transparence.Position;

  if (style.itemindex>-1) then
     TECShapePolygone(FSelectedshape).style := TBrushStyle(style.itemindex);

 //  TECShapePolygone(FSelectedShape).PenStyle := psDot;

 end;

 Infos.visible := true;
 pnHelpPoint.visible := true;


end;

(*

procedure TFormNativeLinePolygone.doUpdateShape;
begin

 if not assigned(FSelectedshape) or InInfoshape then  exit;

 FSelectedshape.color                := ColorBorder.Color;
 FSelectedshape.HoverColor           := HoverColor.Color;
 TECShapeLine(FSelectedshape).Weight := StrToIntDef(weight.text,4);

 TECShapeLine(FSelectedshape).Bordercolor       := BColor.Color;
 TECShapeLine(FSelectedshape).HoverBorderColor  := BHcolor.Color;
 TECShapeLine(FSelectedshape).BorderSize := StrToIntDef(edtBSize.text,0);

 if (penstyle.itemindex>-1) then
     TECShapeLine(FSelectedshape).penstyle := TPenStyle(penstyle.itemindex);


 if FSelectedshape is TECShapePolygone then
 begin

  TECShapePolygone(FSelectedshape).color        := ColorBorder.Color;
  TECShapePolygone(FSelectedshape).Bordercolor  := ColorBorder.Color;
  TECShapePolygone(FSelectedshape).Weight := StrToIntDef(weight.text,4);
  TECShapePolygone(FSelectedshape).FillColor := FillColor.Color;
  TECShapePolygone(FSelectedShape).FillOpacity   := Transparence.Position;

  if (style.itemindex>-1) then
     TECShapePolygone(FSelectedshape).style := TBrushStyle(style.itemindex);



 end;

 Infos.visible := true;
 pnHelpPoint.visible := true;


end; *)


procedure TFormNativeLinePolygone.doInfoShape;
begin

 if not assigned(FSelectedshape) then  exit;

 InInfoShape := true;

 ColorBorder.Color  := FSelectedshape.color;
 HoverColor.Color   := FSelectedshape.HoverColor;

 edtbsize.Text :=  IntToStr(TECShapeLine(FSelectedshape).bordersize);

 BColor.Color  := TECShapeLine(FSelectedshape).bordercolor;
 BHColor.Color   := TECShapeLine(FSelectedshape).HoverBorderColor;

 weight.text        := IntToStr(TECShapeLine(FSelectedshape).Weight);


 penstyle.itemindex := integer(TECShapeLine(FSelectedShape).penstyle);


 if FSelectedshape is TECShapePolygone then
 begin

  FillColor.Color       := TECShapePolygone(FSelectedshape).FillColor;
  Level.text            := IntToStr(TECShapePolygone(FSelectedshape).Level);
  Transparence.Position := TECShapePolygone(FSelectedShape).FillOpacity;
  penstyle.itemindex    := 0;

  style.itemindex       := integer( TECShapePolygone(FSelectedshape).style );


  lbpenstyle.visible := false;
  penstyle.visible   := false;

  edtbsize.visible := false;

  BColor.visible := false;
  BHColor.visible := false;
  Label5.Visible  := false;

 end else begin
           lbpenstyle.visible := true;
           penstyle.visible   := true;
           edtbsize.visible := true;

           BColor.visible := true;
           BHColor.visible := true;
           Label5.Visible  := true;
          end;




 InInfoshape := false;

end;



procedure TFormNativeLinePolygone.Editshape (const Value:boolean);
begin
  if assigned(FSelectedshape) then
 if FSelectedshape is TECShapePolygone then
  TECshapePolygone(FSelectedshape).Editable := value
  else
   TECshapeLine(FSelectedshape).Editable := value;

  if value then
  begin

    pnPolygone.visible :=  FSelectedshape is TECShapePolygone;

    TECshapeLine(FSelectedShape).OnShapePathChange := doPathChange;

    // update infos perimeter / area
    doPathChange(FSelectedShape);


  end;

  if assigned(FSelectedshape) then
  FSelectedshape.Draggable := true;

end;

procedure TFormNativeLinePolygone.FormCreate(Sender: TObject);
begin
  Map.LocalCache     := ExtractFilePath(application.exename) + 'cache';

  map.Shapes.Polygones.OnAfterDraw := doDrawHint;

  FECNativeMeasureMap := TECNativeMeasureMap.create;
  FECNativeMeasureMap.map := map;

  map.ScaleMarkerToZoom := true;

  Map.Reticle := true;
  Map.ReticleColor := clBlack;

  map.XapiLayer.Shapes.ZIndex := -1;

  map.XapiLayer.OnClick := doOnLayerClick;



  // styles

//    map.styles.addRule('.line {visible:true}');
//    map.styles.addRule('.polygone {visible:true}');
   // map.styles.addRule('.marker {scale:0.9;}');

    // roads
    map.styles.addRule('.line.highway:motorway,.line.highway:trunk  {zindex:10;weight:6;color:gradient(Red,Yellow,0.1);}');
    map.styles.addRule('.line.highway:primary {zindex:9;weight:4;color:gradient(Red,Yellow,0.3);}');
    map.styles.addRule('.line.highway:secondary {zindex:8;weight:3;color:gradient(Red,Yellow,0.4);}');

    map.styles.addRule(
                       '.line.highway:tertiary,'+
                       '.line.highway:unclassified,'+
                       '.line.highway:road {zindex:7;weight:3;color:gradient(Red,Yellow,0.6);}');


    map.styles.addRule('.line.highway:residential {zindex:6;weight:2;color:gradient(Red,Yellow,0.8);}');

  // junction
  map.styles.addRule('.marker.junction:yes {zindex : 10;color:gradient(red,yellow,0.3);styleicon:Flat;}');

   // rivers

   map.styles.addRule('.line.waterway:river {zindex:-1;weight:4;color:#54b4eA;}');

   // bus stop

   map.styles.addRule('.marker.highway:bus_stop {color:gradient(blue,silver,0.5);styleicon:Flat;}');

    


end;


procedure TFormNativeLinePolygone.doDrawHint(const canvas: TECCanvas; var r: TRect;
  Item: TECShape);
var
  x, y, w, h: integer;
  s: string;
begin

  // don't draw nomber on animated shape

  canvas.font.Style := [TFontStyle.fsBold];

  s := Item.hint;

  w := canvas.TextWidth(s);
  h := canvas.TextHeight(s);

  x := 1 + ((r.Left + r.Right) - w) DIV 2;
  y := 1 + ((r.Top + r.Bottom) - h) DIV 2;

  canvas.brush.Style := bsClear;

  canvas.fontcolor := clWhite;

  canvas.TextRect(r, x, y, s);
end;




procedure TFormNativeLinePolygone.doOnLayerClick(sender : TECShape) ;
var

  Key, Value, content: string;

begin

  // here Sender are allway assigned

  content := '<h3>OpenStreetMap Data</h3><br>';

  if Sender.PropertiesFindFirst(Key, Value) then
  begin
    repeat

      if (Key = 'ecshape') or (key='') then
        continue;

      //if length(Key) < 9 then
        Key := Key + '<tab="110">';

      content := content + '<b>' + Key + '</b>: ' + Value + '<br>';

    until Sender.PropertiesFindNext(Key, Value);
  end;

  if map.XapiLayer.Shapes.InfoWindows.count = 0 then
  begin
    map.XapiLayer.Shapes.InfoWindows.add(0, 0, '');
    map.XapiLayer.Shapes.InfoWindows[0].Zindex := 100;
    map.XapiLayer.Shapes.InfoWindows[0].Width := 320;
  end;

  map.XapiLayer.Shapes.InfoWindows[0].content := content;
  map.XapiLayer.Shapes.InfoWindows[0].SetPosition(map.MouseLatLng.Lat,
    map.MouseLatLng.lng);
  map.XapiLayer.Shapes.InfoWindows[0].Visible := true;


end;

procedure TFormNativeLinePolygone.FormDestroy(Sender: TObject);
begin
  FECNativeMeasureMap.map := nil;
  FECNativeMeasureMap.Free;
end;

procedure TFormNativeLinePolygone.LevelChange(Sender: TObject);
begin
 if FSelectedshape is TECShapePolygone then
 begin
  TECshapePolygone(FSelectedshape).Level    := StrToInt(Level.text);
 end;
end;

end.


